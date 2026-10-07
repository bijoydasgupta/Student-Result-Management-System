<?php
declare(strict_types=1);
require __DIR__ . '/config.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') jsonResponse(['error' => 'POST request required'], 405);
$data = input();
$teacherId = (int) ($data['teacherId'] ?? 0);
$courseId = (int) ($data['courseId'] ?? 0);
$studentId = (int) ($data['studentId'] ?? 0);
$sectionId = (int) ($data['sectionId'] ?? 0);
$semesterId = (int) ($data['semesterId'] ?? 0);
if ($teacherId < 1 || $courseId < 1 || $studentId < 1 || $sectionId < 1 || $semesterId < 1) jsonResponse(['error' => 'Choose a valid teacher, course, student, section, and semester.'], 422);

try {
    $pdo = database();
    $pdo->beginTransaction();
    foreach ([['teachers', $teacherId], ['courses', $courseId], ['students', $studentId], ['sections', $sectionId], ['semesters', $semesterId]] as [$table, $id]) {
        $check = $pdo->prepare("SELECT id FROM {$table} WHERE id = ?");
        $check->execute([$id]);
        if (!$check->fetch()) {
            $pdo->rollBack();
            jsonResponse(['error' => 'One of the selected records no longer exists.'], 404);
        }
    }
    $previousTeacher = $pdo->prepare('SELECT teacher_id FROM courses WHERE id = ? FOR UPDATE');
    $previousTeacher->execute([$courseId]);
    $previousTeacherId = $previousTeacher->fetchColumn();
    $assignment = $pdo->prepare('INSERT INTO course_section_assignments (course_id, section_id, semester_id, teacher_id) VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE teacher_id = VALUES(teacher_id), assigned_at = CURRENT_TIMESTAMP');
    $assignment->execute([$courseId, $sectionId, $semesterId, $teacherId]);
    $enrollment = $pdo->prepare('INSERT INTO student_course_enrollments (student_id, course_id, section_id, semester_id) VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE enrolled_at = CURRENT_TIMESTAMP');
    $enrollment->execute([$studentId, $courseId, $sectionId, $semesterId]);
    $course = $pdo->prepare('UPDATE courses SET teacher_id = ? WHERE id = ?');
    $course->execute([$teacherId, $courseId]);
    $section = $pdo->prepare('SELECT section_name FROM sections WHERE id = ?');
    $section->execute([$sectionId]);
    $sectionName = (string) $section->fetchColumn();
    $student = $pdo->prepare('UPDATE students SET section_name = ? WHERE id = ?');
    $student->execute([$sectionName, $studentId]);

    // Keep the teacher profile readable in phpMyAdmin as well as preserving
    // the normalized course/section mapping above.
    $teacherProfile = $pdo->prepare("UPDATE teachers SET subject_name = COALESCE(NULLIF((SELECT GROUP_CONCAT(course_name ORDER BY course_name SEPARATOR ', ') FROM courses WHERE teacher_id = ?), ''), 'Not assigned yet'), section_name = ? WHERE id = ?");
    $teacherProfile->execute([$teacherId, $sectionName, $teacherId]);
    if ($previousTeacherId !== false && (int) $previousTeacherId !== $teacherId) {
        $oldTeacherProfile = $pdo->prepare("UPDATE teachers SET subject_name = COALESCE(NULLIF((SELECT GROUP_CONCAT(course_name ORDER BY course_name SEPARATOR ', ') FROM courses WHERE teacher_id = ?), ''), 'Not assigned yet') WHERE id = ?");
        $oldTeacherProfile->execute([(int) $previousTeacherId, (int) $previousTeacherId]);
    }
    $pdo->commit();
    jsonResponse(['ok' => true]);
} catch (Throwable $exception) {
    if (isset($pdo) && $pdo->inTransaction()) $pdo->rollBack();
    jsonResponse(['error' => 'Could not save the academic assignment.'], 500);
}
