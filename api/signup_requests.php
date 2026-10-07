<?php
declare(strict_types=1);
require __DIR__ . '/config.php';

if ($_SERVER['REQUEST_METHOD'] !== 'GET') jsonResponse(['error' => 'GET request required'], 405);

try {
    $requests = database()->query('SELECT id, name, email, phone, section_name, role, status, submitted_at, reviewed_at FROM signup_requests ORDER BY submitted_at DESC, id DESC')->fetchAll(PDO::FETCH_ASSOC);
    foreach ($requests as &$request) {
        $request['id'] = (int) $request['id'];
    }
    unset($request);
    jsonResponse(['requests' => $requests]);
} catch (Throwable $exception) {
    jsonResponse(['error' => 'Could not load sign-up requests.'], 500);
}
