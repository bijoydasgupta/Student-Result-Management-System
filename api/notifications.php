<?php
declare(strict_types=1);
require __DIR__ . '/config.php';

function notificationAccount(PDO $pdo, int $id, string $email): array|false
{
    if ($email !== '') {
        $find = $pdo->prepare("SELECT id, role FROM accounts WHERE email = ? AND role IN ('student', 'parent', 'admin')");
        $find->execute([strtolower($email)]);
        $account = $find->fetch(PDO::FETCH_ASSOC);
        if ($account) return $account;
    }
    if ($id > 0) {
        $find = $pdo->prepare("SELECT id, role FROM accounts WHERE id = ? AND role IN ('student', 'parent', 'admin')");
        $find->execute([$id]);
        return $find->fetch(PDO::FETCH_ASSOC);
    }
    return false;
}

try {
    $pdo = database();
    if ($_SERVER['REQUEST_METHOD'] === 'GET') {
        $account = notificationAccount($pdo, (int) ($_GET['accountId'] ?? 0), trim((string) ($_GET['email'] ?? '')));
        if (!$account) jsonResponse(['error' => 'Account not found.'], 404);
        $list = $pdo->prepare('SELECT id, notification_type, title, message, related_student_id, related_course_id, related_request_id, related_challenge_id, is_read, created_at FROM notifications WHERE recipient_account_id = ? ORDER BY created_at DESC, id DESC LIMIT 30');
        $list->execute([(int) $account['id']]);
        $notifications = $list->fetchAll(PDO::FETCH_ASSOC);
        foreach ($notifications as &$item) {
            foreach (['id', 'related_student_id', 'related_course_id', 'related_request_id', 'related_challenge_id'] as $field) $item[$field] = $item[$field] === null ? null : (int) $item[$field];
            $item['is_read'] = (bool) $item['is_read'];
        }
        unset($item);
        jsonResponse(['accountId' => (int) $account['id'], 'notifications' => $notifications]);
    }
    if ($_SERVER['REQUEST_METHOD'] !== 'POST') jsonResponse(['error' => 'GET or POST request required'], 405);
    $data = input();
    $account = notificationAccount($pdo, (int) ($data['accountId'] ?? 0), trim((string) ($data['email'] ?? '')));
    $notificationId = (int) ($data['notificationId'] ?? 0);
    if (!$account || $notificationId < 1) jsonResponse(['error' => 'Invalid notification request.'], 422);
    $markRead = $pdo->prepare('UPDATE notifications SET is_read = 1, read_at = COALESCE(read_at, CURRENT_TIMESTAMP) WHERE id = ? AND recipient_account_id = ?');
    $markRead->execute([$notificationId, (int) $account['id']]);
    jsonResponse(['ok' => true]);
} catch (Throwable $exception) {
    jsonResponse(['error' => 'Could not load or update notifications.'], 500);
}
