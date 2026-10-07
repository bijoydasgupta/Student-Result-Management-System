<?php
declare(strict_types=1);
require __DIR__ . '/config.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') jsonResponse(['error' => 'POST request required'], 405);
$data = input();
$name = trim((string) ($data['name'] ?? ''));
$code = strtoupper(trim((string) ($data['code'] ?? '')));
$credits = (int) ($data['credits'] ?? 0);
if ($name === '' || $code === '' || $credits < 1 || $credits > 20) jsonResponse(['error' => 'Enter a course name, code, and valid credits.'], 422);

try {
    $pdo = database();
    $insert = $pdo->prepare('INSERT INTO courses (course_name, course_code, credits) VALUES (?, ?, ?)');
    $insert->execute([$name, $code, $credits]);
    jsonResponse(['ok' => true, 'courseId' => (int) $pdo->lastInsertId()]);
} catch (PDOException $exception) {
    if ($exception->getCode() === '23000') jsonResponse(['error' => 'A course already uses this code.'], 409);
    jsonResponse(['error' => 'Could not save the course.'], 500);
} catch (Throwable $exception) {
    jsonResponse(['error' => 'Could not save the course.'], 500);
}
