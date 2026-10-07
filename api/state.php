<?php
declare(strict_types=1);
require __DIR__ . '/config.php';
require __DIR__ . '/grade_sync.php';

function notifyPublishedResults(PDO $pdo, ?array $previous, array $current): int
{
    if ($previous === null) return 0;
    $columns = $pdo->prepare("SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'notifications' AND column_name IN ('related_student_id', 'related_course_id')");
    $columns->execute();
    if ((int) $columns->fetchColumn() !== 2) return 0;
    $hasSmsLogs = (int) $pdo->query("SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'sms_logs'")->fetchColumn() > 0;
    $previousGrades = [];
    foreach (($previous['grades'] ?? []) as $grade) {
        $previousGrades[(string) ($grade['studentId'] ?? '') . ':' . (int) ($grade['courseId'] ?? 0)] = !empty($grade['published']);
    }
    $studentLookup = $pdo->prepare('SELECT id, account_id, name FROM students WHERE student_code = ? OR email = ? ORDER BY (student_code = ?) DESC LIMIT 1');
    $courseLookup = $pdo->prepare('SELECT id, course_name FROM courses WHERE id = ? OR course_code = ? ORDER BY (id = ?) DESC LIMIT 1');
    $parentsLookup = $pdo->prepare('SELECT DISTINCT p.account_id, p.phone FROM parents p LEFT JOIN parent_student ps ON ps.parent_id = p.id WHERE ps.student_id = ? OR p.child_student_code = ?');
    $notify = $pdo->prepare('INSERT INTO notifications (recipient_account_id, notification_type, title, message, related_student_id, related_course_id) VALUES (?, \'result_published\', ?, ?, ?, ?)');
    $sms = $hasSmsLogs ? $pdo->prepare("INSERT INTO sms_logs (recipient_account_id, student_id, course_id, phone, message, status) VALUES (?, ?, ?, ?, ?, 'queued')") : null;
    $created = 0;
    foreach (($current['grades'] ?? []) as $grade) {
        $studentCode = trim((string) ($grade['studentId'] ?? ''));
        $appStudent = null;
        foreach (($current['students'] ?? []) as $candidate) if ((string) ($candidate['id'] ?? '') === $studentCode) { $appStudent = $candidate; break; }
        $studentLookup->execute([$studentCode, strtolower(trim((string) ($appStudent['email'] ?? ''))), $studentCode]);
        $student = $studentLookup->fetch(PDO::FETCH_ASSOC);
        $courseApp = null;
        foreach (($current['courses'] ?? []) as $candidate) if ((int) ($candidate['id'] ?? 0) === (int) ($grade['courseId'] ?? 0)) { $courseApp = $candidate; break; }
        $courseLookup->execute([(int) ($grade['courseId'] ?? 0), strtoupper(trim((string) ($courseApp['code'] ?? ''))), (int) ($grade['courseId'] ?? 0)]);
        $course = $courseLookup->fetch(PDO::FETCH_ASSOC);
        $key = $studentCode . ':' . (int) ($grade['courseId'] ?? 0);
        if (empty($grade['published']) || !empty($previousGrades[$key]) || !$student || !$course) continue;

        $message = 'A new result has been published for ' . $student['name'] . '. Open notifications to view the result overview.';
        $recipients = [(int) $student['account_id'] => null];
        $parentsLookup->execute([(int) $student['id'], $studentCode]);
        foreach ($parentsLookup->fetchAll(PDO::FETCH_ASSOC) as $parent) $recipients[(int) $parent['account_id']] = $parent['phone'];
        foreach ($recipients as $accountId => $phone) {
            $notify->execute([$accountId, 'New result published', $message, (int) $student['id'], (int) $course['id']]);
            if ($phone !== null && $sms) $sms->execute([$accountId, (int) $student['id'], (int) $course['id'], $phone, $message]);
            $created++;
        }
    }
    return $created;
}

try {
    $pdo = database();
    if ($_SERVER['REQUEST_METHOD'] === 'GET') {
        $row = $pdo->query('SELECT state_json, updated_at FROM srms_state WHERE id = 1')->fetch(PDO::FETCH_ASSOC);
        $state = $row ? json_decode($row['state_json'], true) : null;
        if (is_array($state)) {
            // Keep teacher logins created in MySQL visible to the dashboard.
            // Course ownership below is mapped by email to these application
            // teacher IDs, so an omitted profile otherwise looks unassigned.
            $state['teachers'] = is_array($state['teachers'] ?? null) ? $state['teachers'] : [];
            $teacherEmails = [];
            $nextTeacherId = 1;
            foreach ($state['teachers'] as $appTeacher) {
                $teacherEmails[strtolower(trim((string) ($appTeacher['email'] ?? '')))] = true;
                $nextTeacherId = max($nextTeacherId, (int) ($appTeacher['id'] ?? 0) + 1);
            }
            $databaseTeachers = $pdo->query('SELECT name, email, subject_name FROM teachers ORDER BY id')->fetchAll(PDO::FETCH_ASSOC);
            foreach ($databaseTeachers as $databaseTeacher) {
                $email = strtolower(trim((string) $databaseTeacher['email']));
                if ($email === '' || isset($teacherEmails[$email])) continue;
                $state['teachers'][] = [
                    'id' => $nextTeacherId++,
                    'name' => (string) $databaseTeacher['name'],
                    'subject' => (string) ($databaseTeacher['subject_name'] ?? 'Not assigned yet'),
                    'email' => $email,
                ];
                $teacherEmails[$email] = true;
            }

            // The admin assignment screen writes normalized academic records.
            // Hydrate them into the dashboard state so teachers see current
            // course ownership and the students enrolled in each course.
            // Student accounts need a profile before they have an enrollment,
            // so hydrate all SQL student records independently as well.
            $state['students'] = is_array($state['students'] ?? null) ? $state['students'] : [];
            $databaseStudents = $pdo->query('SELECT student_code, name, email, phone, section_name FROM students ORDER BY name')->fetchAll(PDO::FETCH_ASSOC);
            foreach ($databaseStudents as $databaseStudent) {
                $found = false;
                foreach ($state['students'] as $appStudent) {
                    if (strcasecmp((string) ($appStudent['email'] ?? ''), (string) $databaseStudent['email']) === 0 || strcasecmp((string) ($appStudent['id'] ?? ''), (string) $databaseStudent['student_code']) === 0) {
                        $found = true;
                        break;
                    }
                }
                if (!$found) {
                    $state['students'][] = [
                        'id' => (string) $databaseStudent['student_code'],
                        'name' => (string) $databaseStudent['name'],
                        'email' => (string) $databaseStudent['email'],
                        'phone' => (string) ($databaseStudent['phone'] ?? ''),
                        'section' => (string) ($databaseStudent['section_name'] ?? 'Not assigned'),
                        'parentId' => null,
                    ];
                }
            }

            // Parent profiles and links are maintained in normalized tables.
            // Hydrate them into the app state because the parent dashboard
            // resolves its child through parents[].childId.
            $state['parents'] = is_array($state['parents'] ?? null) ? $state['parents'] : [];
            $databaseParents = $pdo->query('SELECT p.id, p.name, p.email, p.phone, p.section_name, p.child_student_code, s.student_code AS linked_student_code FROM parents p LEFT JOIN parent_student ps ON ps.parent_id = p.id LEFT JOIN students s ON s.id = ps.student_id ORDER BY p.id, s.student_code')->fetchAll(PDO::FETCH_ASSOC);
            $parentIndexesByEmail = [];
            foreach ($databaseParents as $databaseParent) {
                $email = strtolower(trim((string) $databaseParent['email']));
                if ($email === '') continue;
                if (!isset($parentIndexesByEmail[$email])) {
                    $existingIndex = null;
                    foreach ($state['parents'] as $index => $appParent) {
                        if (strcasecmp(trim((string) ($appParent['email'] ?? '')), $email) === 0) { $existingIndex = $index; break; }
                    }
                    if ($existingIndex === null) {
                        $state['parents'][] = ['id' => (int) $databaseParent['id'], 'name' => (string) $databaseParent['name'], 'email' => $email, 'phone' => (string) ($databaseParent['phone'] ?? ''), 'section' => (string) ($databaseParent['section_name'] ?? ''), 'childId' => null];
                        $existingIndex = array_key_last($state['parents']);
                    } else {
                        $state['parents'][$existingIndex]['id'] = (int) $databaseParent['id'];
                        $state['parents'][$existingIndex]['name'] = (string) $databaseParent['name'];
                        $state['parents'][$existingIndex]['email'] = $email;
                        $state['parents'][$existingIndex]['phone'] = (string) ($databaseParent['phone'] ?? '');
                        $state['parents'][$existingIndex]['section'] = (string) ($databaseParent['section_name'] ?? '');
                        $state['parents'][$existingIndex]['childId'] = null;
                    }
                    $parentIndexesByEmail[$email] = $existingIndex;
                }
                $studentCode = (string) ($databaseParent['linked_student_code'] ?: $databaseParent['child_student_code'] ?: '');
                if ($studentCode !== '') $state['parents'][$parentIndexesByEmail[$email]]['childId'] = $studentCode;
            }
            $state['enrollments'] = [];
            $enrollments = $pdo->query('SELECT s.student_code, s.name AS student_name, s.email AS student_email, s.phone AS student_phone, c.course_code, c.course_name, c.credits, t.email AS teacher_email, sce.section_id, sec.section_name, sce.semester_id FROM student_course_enrollments sce JOIN students s ON s.id = sce.student_id JOIN courses c ON c.id = sce.course_id LEFT JOIN teachers t ON t.id = c.teacher_id JOIN sections sec ON sec.id = sce.section_id')->fetchAll(PDO::FETCH_ASSOC);
            $courseIdsByCode = [];
            foreach ($enrollments as $enrollment) {
                $code = strtoupper(trim((string) $enrollment['course_code']));
                if (isset($courseIdsByCode[$code])) continue;
                $appCourseId = null;
                foreach ($state['courses'] ?? [] as $index => $appCourse) {
                    if (strcasecmp((string) ($appCourse['code'] ?? ''), $code) === 0) {
                        $appCourseId = (int) $appCourse['id'];
                        break;
                    }
                }
                if ($appCourseId === null) {
                    $appCourseId = (int) $pdo->query('SELECT id FROM courses WHERE course_code = ' . $pdo->quote($enrollment['course_code']))->fetchColumn();
                    $teacherId = null;
                    foreach ($state['teachers'] ?? [] as $appTeacher) {
                        if (strcasecmp((string) ($appTeacher['email'] ?? ''), (string) ($enrollment['teacher_email'] ?? '')) === 0) { $teacherId = $appTeacher['id']; break; }
                    }
                    $state['courses'][] = ['id' => $appCourseId, 'name' => (string) $enrollment['course_name'], 'code' => (string) $enrollment['course_code'], 'credits' => (int) $enrollment['credits'], 'teacherId' => $teacherId];
                }
                $courseIdsByCode[$code] = $appCourseId;
            }
            foreach ($enrollments as $enrollment) {
                $appStudentId = null;
                foreach ($state['students'] ?? [] as $index => $appStudent) {
                    if (strcasecmp((string) ($appStudent['email'] ?? ''), (string) $enrollment['student_email']) === 0 || strcasecmp((string) ($appStudent['id'] ?? ''), (string) $enrollment['student_code']) === 0) {
                        $appStudentId = $appStudent['id'];
                        $state['students'][$index]['section'] = (string) $enrollment['section_name'];
                        break;
                    }
                }
                if ($appStudentId === null) {
                    $appStudentId = (string) $enrollment['student_code'];
                    $state['students'][] = ['id' => $appStudentId, 'name' => (string) $enrollment['student_name'], 'email' => (string) $enrollment['student_email'], 'phone' => (string) ($enrollment['student_phone'] ?? ''), 'section' => (string) $enrollment['section_name'], 'parentId' => null];
                }
                $state['enrollments'][] = [
                    'studentId' => $appStudentId,
                    'courseId' => $courseIdsByCode[strtoupper(trim((string) $enrollment['course_code']))],
                    'sectionId' => (int) $enrollment['section_id'],
                    'section' => (string) $enrollment['section_name'],
                    'semesterId' => (int) $enrollment['semester_id'],
                ];
            }
            $courseTeachers = $pdo->query('SELECT c.course_code, t.email AS teacher_email FROM courses c LEFT JOIN teachers t ON t.id = c.teacher_id')->fetchAll(PDO::FETCH_ASSOC);
            if (!is_array($state['courses'] ?? null)) $state['courses'] = [];
            foreach ($state['courses'] as &$course) {
                foreach ($courseTeachers as $courseTeacher) {
                    if (strcasecmp((string) ($course['code'] ?? ''), (string) $courseTeacher['course_code']) === 0) {
                        $teacherId = null;
                        foreach ($state['teachers'] ?? [] as $appTeacher) {
                            if (strcasecmp((string) ($appTeacher['email'] ?? ''), (string) ($courseTeacher['teacher_email'] ?? '')) === 0) {
                                $teacherId = $appTeacher['id'];
                                break;
                            }
                        }
                        $course['teacherId'] = $teacherId;
                        break;
                    }
                }
            }
            unset($course);
            $pdo->beginTransaction();
            syncGradesToDatabase($pdo, $state);
            syncAttendanceToDatabase($pdo, $state);
            syncGradeAuditLogToDatabase($pdo, $state);
            $pdo->commit();
        }
        jsonResponse(['state' => $state, 'updatedAt' => $row['updated_at'] ?? null]);
    }
    if ($_SERVER['REQUEST_METHOD'] !== 'POST') jsonResponse(['error' => 'GET or POST request required'], 405);
    $payload = input();
    if (!isset($payload['state']) || !is_array($payload['state'])) jsonResponse(['error' => 'A valid application state is required.'], 422);
    $pdo->beginTransaction();
    $oldRow = $pdo->query('SELECT state_json FROM srms_state WHERE id = 1 FOR UPDATE')->fetch(PDO::FETCH_ASSOC);
    $previousState = $oldRow ? json_decode($oldRow['state_json'], true) : null;
    $json = json_encode($payload['state'], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    $stmt = $pdo->prepare('INSERT INTO srms_state (id, state_json) VALUES (1, ?) ON DUPLICATE KEY UPDATE state_json = VALUES(state_json), updated_at = CURRENT_TIMESTAMP');
    $stmt->execute([$json]);
    $gradeSync = syncGradesToDatabase($pdo, $payload['state']);
    $attendanceSync = syncAttendanceToDatabase($pdo, $payload['state']);
    $auditSync = syncGradeAuditLogToDatabase($pdo, $payload['state']);
    // Notifications are a side effect of publishing, not a prerequisite for
    // saving the grade. Older installations may have only part of the
    // notification/SMS migrations applied, so isolate those schema errors
    // from the state, grade, attendance and audit writes above.
    $notificationsCreated = 0;
    $notificationError = null;
    try {
        $notificationsCreated = notifyPublishedResults($pdo, is_array($previousState) ? $previousState : null, $payload['state']);
    } catch (Throwable $notificationException) {
        $notificationError = 'Result saved, but notifications could not be created. Check migration_sms_notifications.sql.';
        error_log('SRMS result notification error: ' . $notificationException->getMessage());
    }
    $notificationSchemaCheck = $pdo->query("SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'notifications' AND column_name IN ('related_student_id', 'related_course_id')");
    $notificationSchemaReady = (int) $notificationSchemaCheck->fetchColumn() === 2;
    $pdo->commit();
    jsonResponse(['ok' => true, 'gradeRowsSaved' => $gradeSync['saved'], 'targetGradeSynced' => $gradeSync['targetSynced'], 'attendanceRowsSaved' => $attendanceSync['saved'], 'targetAttendanceSynced' => $attendanceSync['targetSynced'], 'auditRowsSaved' => $auditSync['saved'], 'targetAuditSynced' => $auditSync['targetSynced'], 'notificationsCreated' => $notificationsCreated, 'notificationSchemaReady' => $notificationSchemaReady, 'notificationError' => $notificationError]);
} catch (Throwable $exception) {
    if (isset($pdo) && $pdo->inTransaction()) $pdo->rollBack();
    error_log('SRMS state save error: ' . $exception->getMessage());
    jsonResponse(['error' => 'Could not read or save the SRMS data.'], 500);
}
