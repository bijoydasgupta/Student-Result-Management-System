<?php
declare(strict_types=1);
require __DIR__ . '/config.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') jsonResponse(['error' => 'POST request required'], 405);
$data = input();
$requestId = (int) ($data['requestId'] ?? 0);
$decision = strtolower(trim((string) ($data['decision'] ?? '')));
if ($requestId < 1 || !in_array($decision, ['approve', 'reject'], true)) jsonResponse(['error' => 'Invalid review request.'], 422);

try {
    $pdo = database();
    $pdo->beginTransaction();
    $find = $pdo->prepare('SELECT * FROM signup_requests WHERE id = ? FOR UPDATE');
    $find->execute([$requestId]);
    $request = $find->fetch(PDO::FETCH_ASSOC);
    if (!$request) {
        $pdo->rollBack();
        jsonResponse(['error' => 'Sign-up request not found.'], 404);
    }
    if ($request['status'] !== 'pending') {
        $pdo->rollBack();
        jsonResponse(['error' => 'This request has already been reviewed.'], 409);
    }

    if ($decision === 'reject') {
        $update = $pdo->prepare("UPDATE signup_requests SET status = 'rejected', reviewed_at = CURRENT_TIMESTAMP WHERE id = ?");
        $update->execute([$requestId]);
        $pdo->commit();
        jsonResponse(['ok' => true, 'status' => 'rejected']);
    }

    $used = $pdo->prepare('SELECT id FROM accounts WHERE email = ?');
    $used->execute([$request['email']]);
    if ($used->fetch()) {
        $pdo->rollBack();
        jsonResponse(['error' => 'An account already uses this email.'], 409);
    }

    $account = $pdo->prepare('INSERT INTO accounts (name, email, password_hash, role) VALUES (?, ?, ?, ?)');
    $account->execute([$request['name'], $request['email'], $request['password_hash'], $request['role']]);
    $accountId = (int) $pdo->lastInsertId();
    if ($request['role'] === 'student') {
        $code = 'STU-' . date('Y') . '-' . str_pad((string) $accountId, 3, '0', STR_PAD_LEFT);
        $profile = $pdo->prepare('INSERT INTO students (student_code, account_id, name, email, phone, section_name) VALUES (?, ?, ?, ?, ?, ?)');
        $profile->execute([$code, $accountId, $request['name'], $request['email'], $request['phone'], $request['section_name']]);
    } elseif ($request['role'] === 'teacher') {
        $code = 'TCH-' . date('Y') . '-' . str_pad((string) $accountId, 3, '0', STR_PAD_LEFT);
        $profile = $pdo->prepare('INSERT INTO teachers (teacher_code, account_id, name, email, phone, section_name) VALUES (?, ?, ?, ?, ?, ?)');
        $profile->execute([$code, $accountId, $request['name'], $request['email'], $request['phone'], $request['section_name']]);
    } else {
        $code = 'PAR-' . date('Y') . '-' . str_pad((string) $accountId, 3, '0', STR_PAD_LEFT);
        $profile = $pdo->prepare('INSERT INTO parents (parent_code, account_id, name, email, phone, section_name) VALUES (?, ?, ?, ?, ?, ?)');
        $profile->execute([$code, $accountId, $request['name'], $request['email'], $request['phone'], $request['section_name']]);
    }
    $update = $pdo->prepare("UPDATE signup_requests SET status = 'approved', reviewed_at = CURRENT_TIMESTAMP WHERE id = ?");
    $update->execute([$requestId]);
    $pdo->commit();
    jsonResponse(['ok' => true, 'status' => 'approved', 'code' => $code]);
} catch (Throwable $exception) {
    if (isset($pdo) && $pdo->inTransaction()) $pdo->rollBack();
    jsonResponse(['error' => 'Could not review the sign-up request. Check MySQL and api/config.php.'], 500);
}
