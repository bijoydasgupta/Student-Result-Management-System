<?php
declare(strict_types=1);
require __DIR__ . '/config.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') jsonResponse(['error' => 'POST request required'], 405);
$data = input();
$email = strtolower(trim((string) ($data['email'] ?? '')));
$password = (string) ($data['password'] ?? '');

try {
    $stmt = database()->prepare('SELECT id, name, email, password_hash, role FROM accounts WHERE email = ?');
    $stmt->execute([$email]);
    $user = $stmt->fetch(PDO::FETCH_ASSOC);
    if (!$user || !password_verify($password, $user['password_hash'])) jsonResponse(['error' => 'Wrong email or password.'], 401);
    unset($user['password_hash']);
    $user['id'] = (int) $user['id'];
    jsonResponse(['user' => $user]);
} catch (Throwable $exception) {
    jsonResponse(['error' => 'Could not connect to MySQL.'], 500);
}
