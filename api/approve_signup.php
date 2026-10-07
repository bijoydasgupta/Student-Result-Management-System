<?php
declare(strict_types=1);
require __DIR__ . '/config.php';

// The current workflow uses review_signup.php, which updates the SQL request
// status and creates the account in one transaction.
jsonResponse(['error' => 'Use review_signup.php to approve or reject a sign-up request.'], 410);
