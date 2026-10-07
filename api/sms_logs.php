<?php
declare(strict_types=1);
require __DIR__ . '/config.php';
try {
    $pdo = database();
    $email = strtolower(trim((string) ($_GET['email'] ?? '')));
    $account = $pdo->prepare("SELECT id FROM accounts WHERE email = ? AND role = 'parent'");
    $account->execute([$email]);
    $accountId = (int) ($account->fetchColumn() ?: 0);
    if ($accountId < 1) jsonResponse(['error' => 'Parent account not found.'], 404);
    $list = $pdo->prepare('SELECT created_at, phone, message, status FROM sms_logs WHERE recipient_account_id = ? ORDER BY created_at DESC, id DESC LIMIT 50');
    $list->execute([$accountId]);
    jsonResponse(['logs' => $list->fetchAll(PDO::FETCH_ASSOC)]);
} catch (Throwable $exception) {
    jsonResponse(['error' => 'Could not load SMS history.'], 500);
}
