<?php
declare(strict_types=1);

/*
 * One-time demo-account seeder.
 * Open this file through Apache, for example:
 * http://localhost/Student-Result-Management/api/seed_demo.php
 */
require __DIR__ . '/config.php';

$demoAccounts = [
    ['Michael Torres', 'admin@school.edu', 'admin', 'ADM-DEMO-001'],
    ['David Chen', 'teacher@school.edu', 'teacher', 'TCH-DEMO-001'],
    ['Sarah Kim', 'teacher2@school.edu', 'teacher', 'TCH-DEMO-002'],
    ['Alex Johnson', 'student@school.edu', 'student', 'STU-2024-001'],
    ['Maya Patel', 'student2@school.edu', 'student', 'STU-2024-002'],
    ['Robert Johnson', 'parent@school.edu', 'parent', 'PAR-DEMO-001'],
    ['Priya Patel', 'parent2@school.edu', 'parent', 'PAR-DEMO-002'],
];

try {
    $pdo = database();
    $pdo->beginTransaction();
    $findAccount = $pdo->prepare('SELECT id FROM accounts WHERE email = ?');
    $addAccount = $pdo->prepare('INSERT INTO accounts (name, email, password_hash, role) VALUES (?, ?, ?, ?)');
    // Keep the supplied demo credentials usable when the account already exists
    // with a stale or manually changed password.
    $resetDemoPassword = $pdo->prepare('UPDATE accounts SET password_hash = ? WHERE id = ?');
    $inserted = 0;
    $existing = 0;

    foreach ($demoAccounts as [$name, $email, $role, $code]) {
        $findAccount->execute([$email]);
        $accountId = (int) ($findAccount->fetchColumn() ?: 0);
        if (!$accountId) {
            $addAccount->execute([$name, $email, password_hash('demo123', PASSWORD_DEFAULT), $role]);
            $accountId = (int) $pdo->lastInsertId();
            $inserted++;
        } else {
            $resetDemoPassword->execute([password_hash('demo123', PASSWORD_DEFAULT), $accountId]);
            $existing++;
        }

        if ($role === 'admin') {
            $profile = $pdo->prepare('INSERT IGNORE INTO admins (admin_code, account_id, name, email, phone) VALUES (?, ?, ?, ?, ?)');
            $profile->execute([$code, $accountId, $name, $email, '+8801700000000']);
        }
        if ($role === 'teacher') {
            $subject = $email === 'teacher@school.edu' ? 'Science & Mathematics' : 'English & Computer Science';
            $profile = $pdo->prepare('INSERT IGNORE INTO teachers (teacher_code, account_id, name, email, phone, section_name, subject_name) VALUES (?, ?, ?, ?, ?, ?, ?)');
            $profile->execute([$code, $accountId, $name, $email, '+8801700000000', '10-A', $subject]);
        }
        if ($role === 'student') {
            $profile = $pdo->prepare('INSERT IGNORE INTO students (student_code, account_id, name, email, phone, section_name) VALUES (?, ?, ?, ?, ?, ?)');
            $profile->execute([$code, $accountId, $name, $email, '+8801700000000', '10-A']);
        }
        if ($role === 'parent') {
            $childCode = $email === 'parent@school.edu' ? 'STU-2024-001' : 'STU-2024-002';
            $profile = $pdo->prepare('INSERT IGNORE INTO parents (parent_code, account_id, name, email, phone, section_name, child_student_code) VALUES (?, ?, ?, ?, ?, ?, ?)');
            $profile->execute([$code, $accountId, $name, $email, '+8801700000000', '10-A', $childCode]);
        }
    }

    $pdo->commit();
    jsonResponse([
        'ok' => true,
        'message' => 'Demo accounts are ready. Password for every demo account is demo123.',
        'insertedAccounts' => $inserted,
        'existingAccounts' => $existing,
    ]);
} catch (Throwable $exception) {
    if (isset($pdo) && $pdo->inTransaction()) $pdo->rollBack();
    jsonResponse(['error' => 'Could not seed demo accounts. Check MySQL, database.sql, and api/config.php.'], 500);
}
