<?php
declare(strict_types=1);
require __DIR__ . '/config.php';

try {
    if ($_SERVER['REQUEST_METHOD'] !== 'GET') jsonResponse(['error' => 'GET request required.'], 405);
    $pdo = database();
    $email = strtolower(trim((string) ($_GET['email'] ?? '')));
    $accountQuery = $pdo->prepare("SELECT id FROM accounts WHERE email = ? AND role = 'teacher'");
    $accountQuery->execute([$email]);
    $accountId = (int) ($accountQuery->fetchColumn() ?: 0);
    if ($accountId < 1) jsonResponse(['error' => 'Teacher account not found.'], 404);

    $teacherQuery = $pdo->prepare('SELECT id FROM teachers WHERE account_id = ?');
    $teacherQuery->execute([$accountId]);
    $teacherId = (int) ($teacherQuery->fetchColumn() ?: 0);
    if ($teacherId < 1) jsonResponse(['error' => 'Teacher profile not found.'], 404);

    $query = $pdo->prepare('SELECT al.audit_id, al.grade_id, al.changed_by, a.name AS changed_by_name, al.old_marks, al.new_marks, al.old_grade, al.new_grade, al.action, al.changed_at, s.name AS student_name, s.student_code, c.course_name FROM grade_audit_log al JOIN grades g ON g.grade_id = al.grade_id JOIN student_course_enrollments e ON e.id = g.enrollment_id JOIN students s ON s.id = e.student_id JOIN courses c ON c.id = e.course_id LEFT JOIN accounts a ON a.id = al.changed_by WHERE al.changed_by = ? OR EXISTS (SELECT 1 FROM course_section_assignments csa WHERE csa.course_id = c.id AND csa.teacher_id = ?) ORDER BY al.changed_at DESC, al.audit_id DESC LIMIT 200');
    $query->execute([$accountId, $teacherId]);
    $rows = $query->fetchAll(PDO::FETCH_ASSOC);
    foreach ($rows as &$row) {
        $row['audit_id'] = (int) $row['audit_id'];
        $row['grade_id'] = (int) $row['grade_id'];
        $row['changed_by'] = $row['changed_by'] === null ? null : (int) $row['changed_by'];
        $row['old_marks'] = $row['old_marks'] === null ? null : (float) $row['old_marks'];
        $row['new_marks'] = (float) $row['new_marks'];
    }
    unset($row);
    jsonResponse(['auditLog' => $rows]);
} catch (Throwable $exception) {
    error_log('Grade audit log error: ' . $exception->getMessage());
    jsonResponse(['error' => 'Could not load grade audit log.'], 500);
}
