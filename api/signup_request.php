<?php
declare(strict_types=1);
require __DIR__ . '/config.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') jsonResponse(['error' => 'POST request required'], 405);
$data = input();
$name = trim((string) ($data['name'] ?? ''));
$email = strtolower(trim((string) ($data['email'] ?? '')));
$password = (string) ($data['password'] ?? '');
$phone = trim((string) ($data['phone'] ?? ''));
$section = trim((string) ($data['section'] ?? ''));
$role = strtolower(trim((string) ($data['role'] ?? '')));

if ($name === '' || !filter_var($email, FILTER_VALIDATE_EMAIL) || strlen($password) < 8 || !in_array($role, ['student', 'parent', 'teacher'], true)) {
    jsonResponse(['error' => 'Enter valid student, parent, or teacher account information.'], 422);
}

try {
    $pdo = database();
    $account = $pdo->prepare('SELECT id FROM accounts WHERE email = ?');
    $account->execute([$email]);
    if ($account->fetch()) jsonResponse(['error' => 'An account already uses this email.'], 409);

    $pdo->beginTransaction();
    $insert = $pdo->prepare('INSERT INTO signup_requests (name, email, password_hash, phone, section_name, role) VALUES (?, ?, ?, ?, ?, ?)');
    $insert->execute([$name, $email, password_hash($password, PASSWORD_DEFAULT), $phone, $section, $role]);
    $requestId = (int) $pdo->lastInsertId();

    // One row per admin means every admin account has its own read/unread state.
    $notify = $pdo->prepare("INSERT INTO notifications (recipient_account_id, notification_type, title, message, related_request_id)
      SELECT id, 'signup_request', ?, ?, ? FROM accounts WHERE role = 'admin'");
    $notify->execute([
        'New sign-up request',
        $name . ' has requested a ' . ucfirst($role) . ' account.',
        $requestId,
    ]);
    $pdo->commit();
    jsonResponse(['ok' => true, 'requestId' => $requestId, 'status' => 'pending']);
} catch (PDOException $exception) {
    if (isset($pdo) && $pdo->inTransaction()) $pdo->rollBack();
    if ($exception->getCode() === '23000') jsonResponse(['error' => 'A sign-up request with this email already exists.'], 409);
    jsonResponse(['error' => 'Could not save the sign-up request. Check MySQL and api/config.php.'], 500);
} catch (Throwable $exception) {
    if (isset($pdo) && $pdo->inTransaction()) $pdo->rollBack();
    jsonResponse(['error' => 'Could not save the sign-up request.'], 500);
}
