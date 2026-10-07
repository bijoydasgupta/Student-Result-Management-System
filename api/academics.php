<?php
declare(strict_types=1);
require __DIR__ . '/config.php';

if ($_SERVER['REQUEST_METHOD'] !== 'GET') jsonResponse(['error' => 'GET request required'], 405);

try {
    $pdo = database();
    $courses = $pdo->query("SELECT c.id, c.course_name, c.course_code, c.credits, c.teacher_id, t.name AS teacher_name FROM courses c LEFT JOIN teachers t ON t.id = c.teacher_id WHERE c.status = 'active' ORDER BY c.course_name")->fetchAll(PDO::FETCH_ASSOC);
    $sections = $pdo->query("SELECT id, section_name, class_name, academic_year FROM sections WHERE status = 'active' ORDER BY section_name")->fetchAll(PDO::FETCH_ASSOC);
    $semesters = $pdo->query("SELECT id, semester_name, start_date, end_date, status FROM semesters ORDER BY start_date DESC")->fetchAll(PDO::FETCH_ASSOC);
    $teachers = $pdo->query('SELECT id, name, email FROM teachers ORDER BY name')->fetchAll(PDO::FETCH_ASSOC);
    $students = $pdo->query('SELECT id, student_code, name, section_name FROM students ORDER BY name')->fetchAll(PDO::FETCH_ASSOC);
    foreach ($courses as &$course) $course['id'] = (int) $course['id'];
    unset($course);
    foreach ($sections as &$section) $section['id'] = (int) $section['id'];
    unset($section);
    foreach ($semesters as &$semester) $semester['id'] = (int) $semester['id'];
    unset($semester);
    foreach ($teachers as &$teacher) $teacher['id'] = (int) $teacher['id'];
    unset($teacher);
    foreach ($students as &$student) $student['id'] = (int) $student['id'];
    unset($student);
    jsonResponse(['courses' => $courses, 'sections' => $sections, 'semesters' => $semesters, 'teachers' => $teachers, 'students' => $students]);
} catch (Throwable $exception) {
    jsonResponse(['error' => 'Could not load academic records.'], 500);
}
