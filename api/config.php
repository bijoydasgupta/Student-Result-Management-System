<?php
declare(strict_types=1);

// Change these four values only if your XAMPP MySQL credentials are different.
const DB_HOST = '127.0.0.1';
const DB_PORT = 3306;
const DB_NAME = 'srms';
const DB_USER = 'root';
const DB_PASS = '';

function database(): PDO
{
    $pdo = new PDO(
        'mysql:host=' . DB_HOST . ';port=' . DB_PORT . ';dbname=' . DB_NAME . ';charset=utf8mb4',
        DB_USER,
        DB_PASS,
        [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]
    );
    return $pdo;
}

function jsonResponse(array $body, int $status = 200): never
{
    http_response_code($status);
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode($body);
    exit;
}

function input(): array
{
    $body = json_decode(file_get_contents('php://input'), true);
    return is_array($body) ? $body : $_POST;
}
