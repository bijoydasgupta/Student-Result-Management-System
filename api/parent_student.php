<?php
declare(strict_types=1);
require __DIR__ . '/config.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') jsonResponse(['error' => 'POST request required'], 405);
$data = input();
$parentId = (int) ($data['parentId'] ?? 0);
$studentId = (int) ($data['studentId'] ?? 0);
$relationship = trim((string) ($data['relationship'] ?? 'Guardian'));

if ($parentId < 1 || $studentId < 1 || $relationship === '' || strlen($relationship) > 50) {
    jsonResponse(['error' => 'Choose a parent, a student, and a valid relationship.'], 422);
}

try {
    $pdo = database();
    $pdo->beginTransaction();
    $parent = $pdo->prepare('SELECT id FROM parents WHERE id = ?');
    $parent->execute([$parentId]);
    $student = $pdo->prepare('SELECT id, student_code FROM students WHERE id = ?');
    $student->execute([$studentId]);
    $studentRow = $student->fetch(PDO::FETCH_ASSOC);
    if (!$parent->fetch() || !$studentRow) {
        $pdo->rollBack();
        jsonResponse(['error' => 'The selected parent or student was not found.'], 404);
    }

    $link = $pdo->prepare('INSERT INTO parent_student (parent_id, student_id, relationship) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE relationship = VALUES(relationship)');
    $link->execute([$parentId, $studentId, $relationship]);
    // Retain compatibility with the existing parents profile column.
    $updateParent = $pdo->prepare('UPDATE parents SET child_student_code = ? WHERE id = ?');
    $updateParent->execute([$studentRow['student_code'], $parentId]);
    $pdo->commit();
    jsonResponse(['ok' => true]);
} catch (Throwable $exception) {
    if (isset($pdo) && $pdo->inTransaction()) $pdo->rollBack();
    jsonResponse(['error' => 'Could not save the parent-student link.'], 500);
}
