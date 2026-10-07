<?php
declare(strict_types=1);
require __DIR__ . '/config.php';
require __DIR__ . '/grade_sync.php';

function challengeAccount(PDO $pdo, string $email, string $role): array|false
{
    $query = $pdo->prepare('SELECT id, name FROM accounts WHERE email = ? AND role = ?');
    $query->execute([strtolower(trim($email)), $role]);
    return $query->fetch(PDO::FETCH_ASSOC);
}

function resultForMark(float $mark): array
{
    foreach ([[90, 'A', 4.0], [85, 'A-', 3.7], [80, 'B+', 3.3], [75, 'B', 3.0], [70, 'B-', 2.7], [65, 'C+', 2.3], [60, 'C', 2.0], [55, 'C-', 1.7], [50, 'D', 1.0]] as [$minimum, $letter, $point]) {
        if ($mark >= $minimum) return ['letter' => $letter, 'point' => $point];
    }
    return ['letter' => 'F', 'point' => 0.0];
}

try {
    $pdo = database();
    if ($_SERVER['REQUEST_METHOD'] === 'GET') {
        $admin = challengeAccount($pdo, (string) ($_GET['email'] ?? ''), 'admin');
        if (!$admin) jsonResponse(['error' => 'Admin account not found.'], 404);
        $rows = $pdo->query("SELECT rc.id, s.student_code, s.name AS student_name, c.id AS course_id, c.course_name, rc.reason, rc.current_marks, rc.resolved_marks, rc.status, rc.submitted_at FROM result_challenge rc JOIN students s ON s.id = rc.student_id JOIN courses c ON c.id = rc.course_id ORDER BY (rc.status = 'pending') DESC, rc.submitted_at DESC")->fetchAll(PDO::FETCH_ASSOC);
        foreach ($rows as &$row) {
            $row['id'] = (int) $row['id'];
            $row['course_id'] = (int) $row['course_id'];
            $row['current_marks'] = (float) $row['current_marks'];
            $row['resolved_marks'] = $row['resolved_marks'] === null ? null : (float) $row['resolved_marks'];
        }
        unset($row);
        jsonResponse(['challenges' => $rows]);
    }
    if ($_SERVER['REQUEST_METHOD'] !== 'POST') jsonResponse(['error' => 'GET or POST request required'], 405);
    $data = input();
    $action = (string) ($data['action'] ?? '');

    if ($action === 'submit') {
        $account = challengeAccount($pdo, (string) ($data['email'] ?? ''), 'student');
        if (!$account) jsonResponse(['error' => 'Student account not found.'], 404);
        $courseId = (int) ($data['courseId'] ?? 0);
        $reason = trim((string) ($data['reason'] ?? ''));
        if ($courseId < 1 || $reason === '' || strlen($reason) > 1000) jsonResponse(['error' => 'Choose a course and enter a reason (up to 1000 characters).'], 422);
        $profile = $pdo->prepare('SELECT id, student_code FROM students WHERE account_id = ?');
        $profile->execute([(int) $account['id']]);
        $student = $profile->fetch(PDO::FETCH_ASSOC);
        if (!$student) jsonResponse(['error' => 'Student profile not found.'], 404);

        $pdo->beginTransaction();
        $stateRow = $pdo->query('SELECT state_json FROM srms_state WHERE id = 1 FOR UPDATE')->fetch(PDO::FETCH_ASSOC);
        $state = $stateRow ? json_decode($stateRow['state_json'], true) : null;
        $grade = null;
        foreach (($state['grades'] ?? []) as $item) {
            if ((string) ($item['studentId'] ?? '') === (string) $student['student_code'] && (int) ($item['courseId'] ?? 0) === $courseId && !empty($item['published'])) { $grade = $item; break; }
        }
        if (!$grade) { $pdo->rollBack(); jsonResponse(['error' => 'Published result not found for this course.'], 404); }
        $insert = $pdo->prepare('INSERT INTO result_challenge (student_id, course_id, reason, current_marks) VALUES (?, ?, ?, ?)');
        $insert->execute([(int) $student['id'], $courseId, $reason, (float) $grade['marks']]);
        $challengeId = (int) $pdo->lastInsertId();
        $courseNameQuery = $pdo->prepare('SELECT course_name FROM courses WHERE id = ?');
        $courseNameQuery->execute([$courseId]);
        $courseName = (string) ($courseNameQuery->fetchColumn() ?: 'a course result');
        $notify = $pdo->prepare("INSERT INTO notifications (recipient_account_id, notification_type, title, message, related_challenge_id) SELECT id, 'result_challenge', ?, ?, ? FROM accounts WHERE role = 'admin'");
        $notify->execute(['New result challenge', $account['name'] . ' challenged ' . $courseName . '.', $challengeId]);
        $pdo->commit();
        jsonResponse(['ok' => true, 'challengeId' => $challengeId]);
    }

    if ($action === 'review') {
        $admin = challengeAccount($pdo, (string) ($data['email'] ?? ''), 'admin');
        if (!$admin) jsonResponse(['error' => 'Admin account not found.'], 404);
        $challengeId = (int) ($data['challengeId'] ?? 0);
        $decision = (string) ($data['decision'] ?? '');
        $mark = filter_var($data['marks'] ?? null, FILTER_VALIDATE_FLOAT);
        if ($challengeId < 1 || !in_array($decision, ['resolve', 'reject'], true) || ($decision === 'resolve' && ($mark === false || $mark < 0 || $mark > 100))) jsonResponse(['error' => 'Choose Resolve or Reject and enter a valid mark when resolving.'], 422);
        $pdo->beginTransaction();
        $find = $pdo->prepare("SELECT rc.id, s.student_code, c.id AS course_id FROM result_challenge rc JOIN students s ON s.id = rc.student_id JOIN courses c ON c.id = rc.course_id WHERE rc.id = ? AND rc.status = 'pending' FOR UPDATE");
        $find->execute([$challengeId]);
        $challenge = $find->fetch(PDO::FETCH_ASSOC);
        if (!$challenge) { $pdo->rollBack(); jsonResponse(['error' => 'Pending challenge not found.'], 404); }
        if ($decision === 'resolve') {
            $stateQuery = $pdo->query('SELECT state_json FROM srms_state WHERE id = 1 FOR UPDATE');
            $stateRecord = $stateQuery->fetch(PDO::FETCH_ASSOC);
            if (!$stateRecord) { $pdo->rollBack(); jsonResponse(['error' => 'Result state is not available.'], 409); }
            $state = json_decode($stateRecord['state_json'], true);
            if (!is_array($state) || !isset($state['grades']) || !is_array($state['grades'])) { $pdo->rollBack(); jsonResponse(['error' => 'Result state has no grade records.'], 409); }
            $result = resultForMark((float) $mark);
            $updated = false;
            foreach ($state['grades'] as &$grade) {
                if ((string) ($grade['studentId'] ?? '') === (string) $challenge['student_code'] && (int) ($grade['courseId'] ?? 0) === (int) $challenge['course_id']) {
                    $grade['marks'] = (float) $mark;
                    $grade['grade'] = $result['letter'];
                    $grade['gpa'] = $result['point'];
                    $updated = true;
                    break;
                }
            }
            unset($grade);
            if (!$updated) { $pdo->rollBack(); jsonResponse(['error' => 'The matching result record could not be found.'], 409); }
            $save = $pdo->prepare('UPDATE srms_state SET state_json = ?, updated_at = CURRENT_TIMESTAMP WHERE id = 1');
            $save->execute([json_encode($state, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES)]);
            syncGradesToDatabase($pdo, $state);
        }
        $status = $decision === 'resolve' ? 'resolved' : 'rejected';
        $update = $pdo->prepare('UPDATE result_challenge SET status = ?, resolved_marks = ?, reviewed_at = CURRENT_TIMESTAMP WHERE id = ?');
        $update->execute([$status, $decision === 'resolve' ? $mark : null, $challengeId]);
        $pdo->commit();
        jsonResponse(['ok' => true, 'status' => $status, 'marks' => $decision === 'resolve' ? (float) $mark : null]);
    }
    jsonResponse(['error' => 'Unknown challenge action.'], 422);
} catch (Throwable $exception) {
    if (isset($pdo) && $pdo->inTransaction()) $pdo->rollBack();
    error_log('Result challenge error: ' . $exception->getMessage());
    jsonResponse(['error' => 'Could not process the result challenge: ' . $exception->getMessage()], 500);
}
