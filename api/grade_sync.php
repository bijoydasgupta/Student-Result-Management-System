<?php
declare(strict_types=1);

/** Mirror app-state grades into the normalized MySQL grades table. */
function syncGradesToDatabase(PDO $pdo, array $state): array
{
    $tableCheck = $pdo->prepare("SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'grades'");
    $tableCheck->execute();
    if ((int) $tableCheck->fetchColumn() === 0) return ['saved' => 0, 'targetSynced' => false];

    foreach (['semesters', 'sections', 'student_course_enrollments'] as $requiredTable) {
        $check = $pdo->prepare('SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = ?');
        $check->execute([$requiredTable]);
        if ((int) $check->fetchColumn() === 0) return ['saved' => 0, 'targetSynced' => false];
    }
    $semesterColumnCheck = $pdo->prepare("SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'student_course_enrollments' AND column_name = 'semester_id'");
    $semesterColumnCheck->execute();
    if ((int) $semesterColumnCheck->fetchColumn() === 0) return ['saved' => 0, 'targetSynced' => false];

    $semesterId = $pdo->query("SELECT id FROM semesters ORDER BY (status = 'active') DESC, start_date DESC LIMIT 1")->fetchColumn();
    if (!$semesterId) return ['saved' => 0, 'targetSynced' => false];

    $studentQuery = $pdo->prepare('SELECT id, section_name FROM students WHERE student_code = ? OR email = ? ORDER BY (student_code = ?) DESC LIMIT 1');
    $courseQuery = $pdo->prepare('SELECT id FROM courses WHERE id = ? OR course_code = ? ORDER BY (id = ?) DESC LIMIT 1');
    $sectionQuery = $pdo->prepare('SELECT id FROM sections WHERE section_name = ? ORDER BY (status = \'active\') DESC, academic_year DESC LIMIT 1');
    $enrollmentQuery = $pdo->prepare('SELECT id FROM student_course_enrollments WHERE student_id = ? AND course_id = ? ORDER BY (semester_id = ?) DESC, enrolled_at DESC LIMIT 1');
    $enrollmentInsert = $pdo->prepare('INSERT INTO student_course_enrollments (student_id, course_id, section_id, semester_id) VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE enrolled_at = enrolled_at');
    $enrollmentLookup = $pdo->prepare('SELECT id FROM student_course_enrollments WHERE student_id = ? AND course_id = ? AND section_id = ? AND semester_id = ?');
    $authorQuery = $pdo->prepare('SELECT account_id FROM teachers WHERE id = ? OR email = ? ORDER BY (email = ?) DESC LIMIT 1');
    $gradeInsert = $pdo->prepare('INSERT INTO grades (enrollment_id, marks, letter_grade, grade_point, teacher_comment, accepted_by, created_by, published) VALUES (?, ?, ?, ?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE marks = VALUES(marks), letter_grade = VALUES(letter_grade), grade_point = VALUES(grade_point), teacher_comment = VALUES(teacher_comment), accepted_by = CASE WHEN VALUES(published) = 1 THEN COALESCE(VALUES(accepted_by), grades.accepted_by) ELSE grades.accepted_by END, created_by = COALESCE(grades.created_by, VALUES(created_by)), published = VALUES(published), updated_at = CURRENT_TIMESTAMP');

    $saved = 0;
    $latestAudit = $state['auditLog'][0] ?? [];
    $targetStudent = (string) ($latestAudit['student'] ?? '');
    $targetCourse = (int) ($latestAudit['courseId'] ?? 0);
    $targetSynced = false;
    foreach (($state['grades'] ?? []) as $grade) {
        $studentCode = trim((string) ($grade['studentId'] ?? ''));
        $courseId = (int) ($grade['courseId'] ?? 0);
        if ($studentCode === '' || $courseId < 1) continue;
        $appStudent = null;
        foreach (($state['students'] ?? []) as $item) {
            if ((string) ($item['id'] ?? '') === $studentCode) { $appStudent = $item; break; }
        }
        $studentEmail = strtolower(trim((string) ($appStudent['email'] ?? '')));
        $studentQuery->execute([$studentCode, $studentEmail, $studentCode]);
        $student = $studentQuery->fetch(PDO::FETCH_ASSOC);
        if (!$student) continue;
        $appCourse = null;
        foreach (($state['courses'] ?? []) as $item) {
            if ((int) ($item['id'] ?? 0) === $courseId) { $appCourse = $item; break; }
        }
        $courseCode = strtoupper(trim((string) ($appCourse['code'] ?? '')));
        $courseQuery->execute([$courseId, $courseCode, $courseId]);
        $databaseCourseId = $courseQuery->fetchColumn();
        if (!$databaseCourseId) continue;
        $courseId = (int) $databaseCourseId;

        $enrollmentQuery->execute([(int) $student['id'], $courseId, (int) $semesterId]);
        $enrollmentId = $enrollmentQuery->fetchColumn();
        if (!$enrollmentId) {
            $sectionName = trim((string) ($student['section_name'] ?? ''));
            if ($sectionName === '') continue;
            $sectionQuery->execute([$sectionName]);
            $sectionId = $sectionQuery->fetchColumn();
            if (!$sectionId) continue;
            $enrollmentInsert->execute([(int) $student['id'], $courseId, (int) $sectionId, (int) $semesterId]);
            $enrollmentLookup->execute([(int) $student['id'], $courseId, (int) $sectionId, (int) $semesterId]);
            $enrollmentId = $enrollmentLookup->fetchColumn();
        }
        if (!$enrollmentId) continue;

        $createdBy = null;
        if ((int) ($grade['teacherId'] ?? 0) > 0) {
            $teacherEmail = '';
            foreach (($state['teachers'] ?? []) as $item) {
                if ((int) ($item['id'] ?? 0) === (int) $grade['teacherId']) { $teacherEmail = strtolower(trim((string) ($item['email'] ?? ''))); break; }
            }
            $authorQuery->execute([(int) $grade['teacherId'], $teacherEmail, $teacherEmail]);
            $createdByValue = $authorQuery->fetchColumn();
            $createdBy = $createdByValue === false ? null : (int) $createdByValue;
        }
        $marks = (float) ($grade['marks'] ?? 0);
        $letter = trim((string) ($grade['grade'] ?? 'F'));
        $point = (float) ($grade['gpa'] ?? 0);
        $published = !empty($grade['published']) ? 1 : 0;
        $comment = trim((string) ($grade['comment'] ?? ''));
        $gradeInsert->execute([(int) $enrollmentId, $marks, $letter, $point, $comment !== '' ? $comment : null, $published ? $createdBy : null, $createdBy, $published]);
        $saved++;
        if ($targetStudent !== '' && (string) ($grade['studentId'] ?? '') === $targetStudent && (int) ($grade['courseId'] ?? 0) === $targetCourse) $targetSynced = true;
    }
    return ['saved' => $saved, 'targetSynced' => $targetSynced];
}

/** Mirror app-state attendance summaries into the normalized MySQL table. */
function syncAttendanceToDatabase(PDO $pdo, array $state): array
{
    $tableCheck = $pdo->prepare("SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'attendance'");
    $tableCheck->execute();
    if ((int) $tableCheck->fetchColumn() === 0) return ['saved' => 0, 'targetSynced' => false];

    $semesterId = $pdo->query("SELECT id FROM semesters ORDER BY (status = 'active') DESC, start_date DESC LIMIT 1")->fetchColumn();
    if (!$semesterId) return ['saved' => 0, 'targetSynced' => false];

    $studentQuery = $pdo->prepare('SELECT id, section_name FROM students WHERE student_code = ? OR email = ? ORDER BY (student_code = ?) DESC LIMIT 1');
    $courseQuery = $pdo->prepare('SELECT id FROM courses WHERE id = ? OR course_code = ? ORDER BY (id = ?) DESC LIMIT 1');
    $sectionQuery = $pdo->prepare("SELECT id FROM sections WHERE section_name = ? ORDER BY (status = 'active') DESC, academic_year DESC LIMIT 1");
    $enrollmentQuery = $pdo->prepare('SELECT id FROM student_course_enrollments WHERE student_id = ? AND course_id = ? ORDER BY (semester_id = ?) DESC, enrolled_at DESC LIMIT 1');
    $enrollmentInsert = $pdo->prepare('INSERT INTO student_course_enrollments (student_id, course_id, section_id, semester_id) VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE enrolled_at = enrolled_at');
    $enrollmentLookup = $pdo->prepare('SELECT id FROM student_course_enrollments WHERE student_id = ? AND course_id = ? AND section_id = ? AND semester_id = ?');
    $attendanceInsert = $pdo->prepare('INSERT INTO attendance (enrollment_id, classes_held, classes_present) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE classes_held = VALUES(classes_held), classes_present = VALUES(classes_present)');

    $latestAudit = $state['auditLog'][0] ?? [];
    $targetStudent = (string) ($latestAudit['student'] ?? '');
    $targetCourse = (int) ($latestAudit['courseId'] ?? 0);
    $saved = 0;
    $targetSynced = false;
    foreach (($state['attendance'] ?? []) as $row) {
        $studentCode = trim((string) ($row['studentId'] ?? ''));
        $courseId = (int) ($row['courseId'] ?? 0);
        $held = (int) ($row['total'] ?? -1);
        $present = (int) ($row['present'] ?? -1);
        if ($studentCode === '' || $courseId < 1 || $held < 0 || $present < 0 || $present > $held) continue;

        $appStudent = null;
        foreach (($state['students'] ?? []) as $item) {
            if ((string) ($item['id'] ?? '') === $studentCode) { $appStudent = $item; break; }
        }
        $studentEmail = strtolower(trim((string) ($appStudent['email'] ?? '')));
        $studentQuery->execute([$studentCode, $studentEmail, $studentCode]);
        $student = $studentQuery->fetch(PDO::FETCH_ASSOC);
        if (!$student) continue;

        $appCourse = null;
        foreach (($state['courses'] ?? []) as $item) {
            if ((int) ($item['id'] ?? 0) === $courseId) { $appCourse = $item; break; }
        }
        $courseCode = strtoupper(trim((string) ($appCourse['code'] ?? '')));
        $courseQuery->execute([$courseId, $courseCode, $courseId]);
        $databaseCourseId = $courseQuery->fetchColumn();
        if (!$databaseCourseId) continue;
        $courseId = (int) $databaseCourseId;

        $enrollmentQuery->execute([(int) $student['id'], $courseId, (int) $semesterId]);
        $enrollmentId = $enrollmentQuery->fetchColumn();
        if (!$enrollmentId) {
            $sectionName = trim((string) ($student['section_name'] ?? ''));
            if ($sectionName === '') continue;
            $sectionQuery->execute([$sectionName]);
            $sectionId = $sectionQuery->fetchColumn();
            if (!$sectionId) continue;
            $enrollmentInsert->execute([(int) $student['id'], $courseId, (int) $sectionId, (int) $semesterId]);
            $enrollmentLookup->execute([(int) $student['id'], $courseId, (int) $sectionId, (int) $semesterId]);
            $enrollmentId = $enrollmentLookup->fetchColumn();
        }
        if (!$enrollmentId) continue;

        $attendanceInsert->execute([(int) $enrollmentId, $held, $present]);
        $saved++;
        if ($studentCode === $targetStudent && (int) ($row['courseId'] ?? 0) === $targetCourse) $targetSynced = true;
    }
    return ['saved' => $saved, 'targetSynced' => $targetSynced];
}

function gradeAuditSourceKey(array $entry, int $legacyDuplicate = 1): string
{
    $source = (string) ($entry['auditKey'] ?? '');
    if ($source === '') {
        $source = json_encode([
            $entry['time'] ?? '', $entry['who'] ?? '', $entry['student'] ?? '',
            $entry['courseId'] ?? '', $entry['action'] ?? '', $entry['change'] ?? '',
        ], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES) . '#' . $legacyDuplicate;
    }
    return hash('sha256', $source);
}

/** Idempotently copy the JSON audit history into the SQL audit table. */
function syncGradeAuditLogToDatabase(PDO $pdo, array $state): array
{
    $tableCheck = $pdo->prepare("SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'grade_audit_log'");
    $tableCheck->execute();
    if ((int) $tableCheck->fetchColumn() === 0) return ['saved' => 0, 'targetSynced' => false];

    $semesterId = $pdo->query("SELECT id FROM semesters ORDER BY (status = 'active') DESC, start_date DESC LIMIT 1")->fetchColumn();
    if (!$semesterId) return ['saved' => 0, 'targetSynced' => false];
    $studentQuery = $pdo->prepare('SELECT id FROM students WHERE student_code = ? OR email = ? ORDER BY (student_code = ?) DESC LIMIT 1');
    $courseQuery = $pdo->prepare('SELECT id FROM courses WHERE id = ? OR course_code = ? ORDER BY (id = ?) DESC LIMIT 1');
    $enrollmentQuery = $pdo->prepare('SELECT id FROM student_course_enrollments WHERE student_id = ? AND course_id = ? ORDER BY (semester_id = ?) DESC, enrolled_at DESC LIMIT 1');
    $gradeQuery = $pdo->prepare('SELECT grade_id FROM grades WHERE enrollment_id = ?');
    $accountQuery = $pdo->prepare('SELECT id FROM accounts WHERE email = ?');
    $accountNameQuery = $pdo->prepare('SELECT id FROM accounts WHERE name = ? ORDER BY id LIMIT 1');
    $insert = $pdo->prepare('INSERT IGNORE INTO grade_audit_log (grade_id, changed_by, old_marks, new_marks, old_grade, new_grade, action, changed_at, source_key) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)');
    $auditExists = $pdo->prepare('SELECT COUNT(*) FROM grade_audit_log WHERE source_key = ?');

    $saved = 0;
    $targetAuditKey = isset($state['auditLog'][0]) && is_array($state['auditLog'][0]) ? gradeAuditSourceKey($state['auditLog'][0], 1) : '';
    $targetSynced = false;
    $legacyOccurrences = [];
    foreach (($state['auditLog'] ?? []) as $entry) {
        $studentCode = trim((string) ($entry['student'] ?? ''));
        $courseId = (int) ($entry['courseId'] ?? 0);
        $change = trim((string) ($entry['change'] ?? ''));
        if ($studentCode === '' || $courseId < 1 || $change === '') continue;

        $appStudent = null;
        foreach (($state['students'] ?? []) as $item) {
            if ((string) ($item['id'] ?? '') === $studentCode) { $appStudent = $item; break; }
        }
        $studentEmail = strtolower(trim((string) ($appStudent['email'] ?? '')));
        $studentQuery->execute([$studentCode, $studentEmail, $studentCode]);
        $studentId = $studentQuery->fetchColumn();
        if (!$studentId) continue;

        $appCourse = null;
        foreach (($state['courses'] ?? []) as $item) {
            if ((int) ($item['id'] ?? 0) === $courseId) { $appCourse = $item; break; }
        }
        $courseCode = strtoupper(trim((string) ($appCourse['code'] ?? '')));
        $courseQuery->execute([$courseId, $courseCode, $courseId]);
        $databaseCourseId = $courseQuery->fetchColumn();
        if (!$databaseCourseId) continue;

        $enrollmentQuery->execute([(int) $studentId, (int) $databaseCourseId, (int) $semesterId]);
        $enrollmentId = $enrollmentQuery->fetchColumn();
        if (!$enrollmentId) continue;
        $gradeQuery->execute([(int) $enrollmentId]);
        $gradeId = $gradeQuery->fetchColumn();
        if (!$gradeId) continue;

        preg_match_all('/([0-9]+(?:\.[0-9]+)?)\s*\(([A-F][+-]?)\)/i', $change, $pairs, PREG_SET_ORDER);
        if (!$pairs) continue;
        $newPair = $pairs[count($pairs) - 1];
        $oldPair = count($pairs) > 1 ? $pairs[0] : null;

        $changedBy = null;
        $actorEmail = strtolower(trim((string) ($entry['actorEmail'] ?? '')));
        if ($actorEmail !== '') {
            $accountQuery->execute([$actorEmail]);
            $actorId = $accountQuery->fetchColumn();
            if ($actorId !== false) $changedBy = (int) $actorId;
        }
        if ($changedBy === null && trim((string) ($entry['who'] ?? '')) !== '') {
            $accountNameQuery->execute([trim((string) $entry['who'])]);
            $actorId = $accountNameQuery->fetchColumn();
            if ($actorId !== false) $changedBy = (int) $actorId;
        }

        $changedAt = strtotime((string) ($entry['time'] ?? ''));
        $changedAt = $changedAt === false ? date('Y-m-d H:i:s') : date('Y-m-d H:i:s', $changedAt);
        $sourceText = (string) ($entry['auditKey'] ?? '');
        $legacyDuplicate = 1;
        if ($sourceText === '') {
            $sourceText = json_encode([
                $entry['time'] ?? '', $entry['who'] ?? '', $entry['student'] ?? '',
                $entry['courseId'] ?? '', $entry['action'] ?? '', $entry['change'] ?? '',
            ], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
            $legacyOccurrences[$sourceText] = ($legacyOccurrences[$sourceText] ?? 0) + 1;
            $legacyDuplicate = $legacyOccurrences[$sourceText];
        }
        $sourceKey = gradeAuditSourceKey($entry, $legacyDuplicate);
        $insert->execute([
            (int) $gradeId,
            $changedBy,
            $oldPair ? (float) $oldPair[1] : null,
            (float) $newPair[1],
            $oldPair ? strtoupper($oldPair[2]) : null,
            strtoupper($newPair[2]),
            trim((string) ($entry['action'] ?? 'Updated mark')),
            $changedAt,
            $sourceKey,
        ]);
        $saved += $insert->rowCount();
        if ($sourceKey === $targetAuditKey) {
            $auditExists->execute([$sourceKey]);
            $targetSynced = (int) $auditExists->fetchColumn() > 0;
        }
    }
    return ['saved' => $saved, 'targetSynced' => $targetSynced];
}
