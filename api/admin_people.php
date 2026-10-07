<?php
declare(strict_types=1);
require __DIR__ . '/config.php';

if ($_SERVER['REQUEST_METHOD'] !== 'GET') jsonResponse(['error' => 'GET request required'], 405);

try {
    $pdo = database();
    $students = $pdo->query('SELECT id, student_code, name, email, phone, section_name FROM students ORDER BY name ASC')->fetchAll(PDO::FETCH_ASSOC);
    $teachers = $pdo->query('SELECT id, name, email, subject_name FROM teachers ORDER BY name ASC')->fetchAll(PDO::FETCH_ASSOC);
    $parents = $pdo->query('SELECT id, parent_code, name, email, phone, section_name FROM parents ORDER BY name ASC')->fetchAll(PDO::FETCH_ASSOC);
    $links = $pdo->query('SELECT ps.id, ps.parent_id, ps.student_id, ps.relationship, p.name AS parent_name, s.name AS student_name, s.student_code FROM parent_student ps JOIN parents p ON p.id = ps.parent_id JOIN students s ON s.id = ps.student_id ORDER BY ps.id DESC')->fetchAll(PDO::FETCH_ASSOC);
    foreach ($students as &$student) $student['id'] = (int) $student['id'];
    unset($student);
    foreach ($teachers as &$teacher) $teacher['id'] = (int) $teacher['id'];
    unset($teacher);
    foreach ($parents as &$parent) $parent['id'] = (int) $parent['id'];
    unset($parent);
    foreach ($links as &$link) {
        $link['id'] = (int) $link['id'];
        $link['parent_id'] = (int) $link['parent_id'];
        $link['student_id'] = (int) $link['student_id'];
    }
    unset($link);
    jsonResponse(['students' => $students, 'teachers' => $teachers, 'parents' => $parents, 'parentLinks' => $links]);
} catch (Throwable $exception) {
    jsonResponse(['error' => 'Could not load approved students and teachers.'], 500);
}
