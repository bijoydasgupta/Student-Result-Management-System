<?php
declare(strict_types=1);
require __DIR__ . '/config.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    jsonResponse(['error' => 'POST request required'], 405);
}

$data = input();
$name = trim((string) ($data['name'] ?? ''));
$email = strtolower(trim((string) ($data['email'] ?? '')));
$password = (string) ($data['password'] ?? '');
$phone = trim((string) ($data['phone'] ?? ''));
$section = trim((string) ($data['section'] ?? ''));
$role = strtolower(trim((string) ($data['role'] ?? 'student')));

if ($name === '' || !filter_var($email, FILTER_VALIDATE_EMAIL) || strlen($password) < 8) {
    jsonResponse(['error' => 'Enter a name, a valid email, and a password of at least 8 characters.'], 422);
}
if (!in_array($role, ['student', 'parent', 'teacher', 'admin'], true)) {
    jsonResponse(['error' => 'Invalid account role.'], 422);
}

try {
    $pdo = database();
    $check = $pdo->prepare('SELECT id FROM accounts WHERE email = ?');
    $check->execute([$email]);
    if ($check->fetch()) {
        jsonResponse(['error' => 'An account already uses this email.'], 409);
    }

    $pdo->beginTransaction();
    $account = $pdo->prepare('INSERT INTO accounts (name, email, password_hash, role) VALUES (?, ?, ?, ?)');
    $account->execute([$name, $email, password_hash($password, PASSWORD_DEFAULT), $role]);
    $accountId = (int) $pdo->lastInsertId();

    if ($role === 'student') {
      $studentId = 'STU-' . date('Y') . '-' . str_pad((string) $accountId, 3, '0', STR_PAD_LEFT);
      $student = $pdo->prepare('INSERT INTO students (student_code, account_id, name, email, phone, section_name) VALUES (?, ?, ?, ?, ?, ?)');
      $student->execute([$studentId, $accountId, $name, $email, $phone, $section]);
    }
    if ($role === 'teacher') {
        $teacherId = 'TCH-' . date('Y') . '-' . str_pad((string) $accountId, 3, '0', STR_PAD_LEFT);
        $teacher = $pdo->prepare('INSERT INTO teachers (teacher_code, account_id, name, email, phone, section_name) VALUES (?, ?, ?, ?, ?, ?)');
        $teacher->execute([$teacherId, $accountId, $name, $email, $phone, $section]);
    }
    if ($role === 'admin') {
        $adminId = 'ADM-' . date('Y') . '-' . str_pad((string) $accountId, 3, '0', STR_PAD_LEFT);
        $admin = $pdo->prepare('INSERT INTO admins (admin_code, account_id, name, email, phone) VALUES (?, ?, ?, ?, ?)');
        $admin->execute([$adminId, $accountId, $name, $email, $phone]);
    }
    if ($role === 'parent') {
        $parentId = 'PAR-' . date('Y') . '-' . str_pad((string) $accountId, 3, '0', STR_PAD_LEFT);
        $parent = $pdo->prepare('INSERT INTO parents (parent_code, account_id, name, email, phone, section_name) VALUES (?, ?, ?, ?, ?, ?)');
        $parent->execute([$parentId, $accountId, $name, $email, $phone, $section]);
    }
    $pdo->commit();
    jsonResponse(['ok' => true, 'message' => 'Account created and saved in MySQL.', 'studentId' => $studentId ?? null, 'teacherId' => $teacherId ?? null, 'adminId' => $adminId ?? null, 'parentId' => $parentId ?? null]);
} catch (Throwable $exception) {
    if (isset($pdo) && $pdo->inTransaction()) $pdo->rollBack();
    jsonResponse(['error' => 'Could not save the account. Check that MySQL is running and database.sql was imported.'], 500);
}
