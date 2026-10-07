-- Run once against an existing srms database to enable database-backed
-- result challenges and their admin notifications.
USE srms;

CREATE TABLE IF NOT EXISTS result_challenge (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  student_id INT UNSIGNED NOT NULL,
  course_id INT UNSIGNED NOT NULL,
  reason VARCHAR(1000) NOT NULL,
  current_marks DECIMAL(5,2) NOT NULL,
  resolved_marks DECIMAL(5,2) NULL,
  status ENUM('pending', 'resolved', 'rejected') NOT NULL DEFAULT 'pending',
  submitted_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  reviewed_at TIMESTAMP NULL DEFAULT NULL,
  CONSTRAINT fk_result_challenge_student FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
  CONSTRAINT fk_result_challenge_course FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
  INDEX idx_result_challenge_status (status, submitted_at)
) ENGINE=InnoDB;

ALTER TABLE notifications
  ADD COLUMN related_challenge_id INT UNSIGNED NULL AFTER related_request_id,
  ADD CONSTRAINT fk_notifications_result_challenge FOREIGN KEY (related_challenge_id) REFERENCES result_challenge(id) ON DELETE CASCADE;
