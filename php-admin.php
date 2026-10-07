<?php

declare(strict_types=1);
require __DIR__ . '/api/config.php';
try {
    $pdo = database();
    $record = $pdo->query('SELECT state_json, updated_at FROM srms_state WHERE id = 1')->fetch(PDO::FETCH_ASSOC);
    $state = $record ? json_decode($record['state_json'], true) : null;
    $students = $pdo->query('SELECT student_code, name, email, phone, section_name, created_at FROM students ORDER BY created_at DESC')->fetchAll(PDO::FETCH_ASSOC);
    $teachers = $pdo->query('SELECT teacher_code, name, email, phone, section_name, subject_name, created_at FROM teachers ORDER BY created_at DESC')->fetchAll(PDO::FETCH_ASSOC);
    $admins = $pdo->query('SELECT admin_code, name, email, phone, created_at FROM admins ORDER BY created_at DESC')->fetchAll(PDO::FETCH_ASSOC);
    $parents = $pdo->query('SELECT parent_code, name, email, phone, section_name, child_student_code, created_at FROM parents ORDER BY created_at DESC')->fetchAll(PDO::FETCH_ASSOC);
} catch (Throwable $exception) {
    $state = null;
    $students = [];
    $error = 'Database unavailable. Start MySQL and import database.sql.';
}
function h($value): string
{
    return htmlspecialchars((string) $value, ENT_QUOTES, 'UTF-8');
}
function countOf(?array $state, string $key): int
{
    return is_array($state[$key] ?? null) ? count($state[$key]) : 0;
}
?>
<!doctype html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="refresh" content="15">
    <title>SRMS PHP Dashboard</title>
    <link rel="stylesheet" href="css/style.css">
</head>

<body style="padding:32px;max-width:1300px;margin:auto">
    <h1>SRMS PHP / MySQL Dashboard</h1>
    <p class="subtitle">All application updates are saved in MySQL. This page refreshes every 15 seconds. Last update: <?= h($record['updated_at'] ?? 'No application data saved yet') ?></p>
    <p><a class="btn" href="parent-link.php">Link a parent to an existing student</a></p>
    <?php if (isset($error)): ?><p class="note"><?= h($error) ?></p><?php endif; ?>
    <div class="stat-grid" style="margin:25px 0">
        <div class="stat-card"><span>Students</span><strong><?= countOf($state, 'students') ?></strong></div>
        <div class="stat-card"><span>Courses</span><strong><?= countOf($state, 'courses') ?></strong></div>
        <div class="stat-card"><span>Grades</span><strong><?= countOf($state, 'grades') ?></strong></div>
        <div class="stat-card"><span>Attendance</span><strong><?= countOf($state, 'attendance') ?></strong></div>
        <div class="stat-card"><span>Requests</span><strong><?= countOf($state, 'signupRequests') ?></strong></div>
        <div class="stat-card"><span>Challenges</span><strong><?= countOf($state, 'challenges') ?></strong></div>
        <div class="stat-card"><span>Audit entries</span><strong><?= countOf($state, 'auditLog') ?></strong></div>
    </div>
    <h2>New student accounts</h2>
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Section</th>
                <th>Created</th>
            </tr>
        </thead>
        <tbody><?php foreach ($students as $student): ?><tr>
                    <td><?= h($student['student_code']) ?></td>
                    <td><?= h($student['name']) ?></td>
                    <td><?= h($student['email']) ?></td>
                    <td><?= h($student['phone']) ?></td>
                    <td><?= h($student['section_name']) ?></td>
                    <td><?= h($student['created_at']) ?></td>
                </tr><?php endforeach; ?><?php if (!$students): ?><tr>
                    <td colspan="6">No student account has been created through PHP yet.</td>
                </tr><?php endif; ?></tbody>
    </table>
    <h2 style="margin-top:32px">Teacher accounts</h2>
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Section</th>
                <th>Subject</th>
                <th>Created</th>
            </tr>
        </thead>
        <tbody><?php foreach (($teachers ?? []) as $teacher): ?><tr>
                    <td><?= h($teacher['teacher_code']) ?></td>
                    <td><?= h($teacher['name']) ?></td>
                    <td><?= h($teacher['email']) ?></td>
                    <td><?= h($teacher['phone']) ?></td>
                    <td><?= h($teacher['section_name']) ?></td>
                    <td><?= h($teacher['subject_name']) ?></td>
                    <td><?= h($teacher['created_at']) ?></td>
                </tr><?php endforeach; ?><?php if (empty($teachers)): ?><tr>
                    <td colspan="7">No teacher account has been created through PHP yet.</td>
                </tr><?php endif; ?></tbody>
    </table>
    <h2 style="margin-top:32px">Admin accounts</h2>
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Created</th>
            </tr>
        </thead>
        <tbody><?php foreach (($admins ?? []) as $admin): ?><tr>
                    <td><?= h($admin['admin_code']) ?></td>
                    <td><?= h($admin['name']) ?></td>
                    <td><?= h($admin['email']) ?></td>
                    <td><?= h($admin['phone']) ?></td>
                    <td><?= h($admin['created_at']) ?></td>
                </tr><?php endforeach; ?><?php if (empty($admins)): ?><tr>
                    <td colspan="5">No admin account has been created through PHP yet.</td>
                </tr><?php endif; ?></tbody>
    </table>
    <h2 style="margin-top:32px">Parent accounts</h2>
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Section</th>
                <th>Child ID</th>
                <th>Created</th>
            </tr>
        </thead>
        <tbody><?php foreach (($parents ?? []) as $parent): ?><tr>
                    <td><?= h($parent['parent_code']) ?></td>
                    <td><?= h($parent['name']) ?></td>
                    <td><?= h($parent['email']) ?></td>
                    <td><?= h($parent['phone']) ?></td>
                    <td><?= h($parent['section_name']) ?></td>
                    <td><?= h($parent['child_student_code'] ?: 'Not linked') ?></td>
                    <td><?= h($parent['created_at']) ?></td>
                </tr><?php endforeach; ?><?php if (empty($parents)): ?><tr>
                    <td colspan="7">No parent account has been created through PHP yet.</td>
                </tr><?php endif; ?></tbody>
    </table>
    <?php if ($state): ?>
        <h2 style="margin-top:32px">Results and grade updates</h2>
        <table>
            <thead>
                <tr>
                    <th>Student ID</th>
                    <th>Course ID</th>
                    <th>Marks</th>
                    <th>Grade</th>
                    <th>Published</th>
                    <th>Comment</th>
                </tr>
            </thead>
            <tbody><?php foreach (($state['grades'] ?? []) as $grade): ?><tr>
                        <td><?= h($grade['studentId'] ?? '') ?></td>
                        <td><?= h($grade['courseId'] ?? '') ?></td>
                        <td><?= h($grade['marks'] ?? '') ?></td>
                        <td><?= h($grade['grade'] ?? '') ?></td>
                        <td><?= !empty($grade['published']) ? 'Yes' : 'No' ?></td>
                        <td><?= h($grade['comment'] ?? '') ?></td>
                    </tr><?php endforeach; ?></tbody>
        </table>
        <details style="margin-top:28px">
            <summary><b>View full saved state: all feature data</b></summary>
            <pre style="white-space:pre-wrap;overflow-wrap:anywhere;padding:20px;background:#f5f7fa"><?= h(json_encode($state, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE)) ?></pre>
        </details>
    <?php endif; ?>
</body>

</html>
