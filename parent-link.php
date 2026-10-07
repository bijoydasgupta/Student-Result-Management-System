<?php

declare(strict_types=1);
require __DIR__ . '/api/config.php';

$message = '';
$error = '';
try {
    $pdo = database();
    $record = $pdo->query('SELECT state_json FROM srms_state WHERE id = 1')->fetch(PDO::FETCH_ASSOC);
    $state = $record ? json_decode($record['state_json'], true) : null;
    if (!$state) throw new RuntimeException('Open the SRMS app once before linking a parent, so its student data is saved.');

    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $parentEmail = strtolower(trim((string) ($_POST['parent_email'] ?? '')));
        $studentId = trim((string) ($_POST['student_id'] ?? ''));
        $parentIndex = null;
        $studentIndex = null;
        foreach ($state['parents'] as $index => $parent) if (strtolower($parent['email']) === $parentEmail) $parentIndex = $index;
        foreach ($state['students'] as $index => $student) if ($student['id'] === $studentId) $studentIndex = $index;
        if ($parentIndex === null || $studentIndex === null) throw new RuntimeException('Select a valid parent and student.');

        $state['parents'][$parentIndex]['childId'] = $studentId;
        $state['students'][$studentIndex]['parentId'] = $state['parents'][$parentIndex]['id'];
        $json = json_encode($state, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);

        $pdo->beginTransaction();
        $saveState = $pdo->prepare('UPDATE srms_state SET state_json = ? WHERE id = 1');
        $saveState->execute([$json]);
        $saveParent = $pdo->prepare('UPDATE parents SET child_student_code = ? WHERE email = ?');
        $saveParent->execute([$studentId, $parentEmail]);
        $pdo->commit();
        $message = 'Parent linked successfully. The parent can now log in and view this student.';
    }
} catch (Throwable $exception) {
    if (isset($pdo) && $pdo->inTransaction()) $pdo->rollBack();
    $error = $exception->getMessage();
}
function h($value): string
{
    return htmlspecialchars((string) $value, ENT_QUOTES, 'UTF-8');
}
?>
<!doctype html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <title>Link Parent to Student | SRMS</title>
    <link rel="stylesheet" href="css/style.css">
</head>

<body style="padding:32px;max-width:760px;margin:auto">
    <h1>Link parent to student</h1>
    <p class="subtitle">Choose the parent account and the existing student they should be able to view.</p>
    <?php if ($message): ?><p class="note" style="color:#16803c"><?= h($message) ?></p><?php endif; ?><?php if ($error): ?><p class="note" style="color:#b42318"><?= h($error) ?></p><?php endif; ?>
    <?php if (!empty($state)): ?><form method="post" class="card" style="padding:24px">
            <div class="field"><label for="parent_email">Parent account</label><select id="parent_email" name="parent_email" required><?php foreach (($state['parents'] ?? []) as $parent): ?><option value="<?= h($parent['email']) ?>"><?= h($parent['name'] . ' — ' . $parent['email']) ?></option><?php endforeach; ?></select></div>
            <div class="field"><label for="student_id">Existing student</label><select id="student_id" name="student_id" required><?php foreach (($state['students'] ?? []) as $student): ?><option value="<?= h($student['id']) ?>"><?= h($student['name'] . ' — ' . $student['id'] . ' (' . $student['section'] . ')') ?></option><?php endforeach; ?></select></div><button class="primary" type="submit">Link Parent & Student</button>
        </form><?php endif; ?>
    <p style="margin-top:22px"><a href="php-admin.php">← Back to PHP dashboard</a></p>
</body>

</html>