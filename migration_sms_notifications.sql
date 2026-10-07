-- Run once on an existing SRMS database to add clickable result alerts and
-- the persistent SMS delivery log. New installs already get these from database.sql.
USE srms;

ALTER TABLE notifications
  ADD COLUMN related_student_id INT UNSIGNED NULL,
  ADD COLUMN related_course_id INT UNSIGNED NULL,
  ADD CONSTRAINT fk_notifications_result_student FOREIGN KEY (related_student_id) REFERENCES students(id) ON DELETE CASCADE,
  ADD CONSTRAINT fk_notifications_result_course FOREIGN KEY (related_course_id) REFERENCES courses(id) ON DELETE CASCADE;

CREATE TABLE IF NOT EXISTS sms_logs (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  recipient_account_id INT UNSIGNED NULL,
  student_id INT UNSIGNED NOT NULL,
  course_id INT UNSIGNED NOT NULL,
  phone VARCHAR(30) NULL,
  message VARCHAR(500) NOT NULL,
  status ENUM('queued', 'sent', 'failed') NOT NULL DEFAULT 'queued',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_sms_logs_recipient FOREIGN KEY (recipient_account_id) REFERENCES accounts(id) ON DELETE SET NULL,
  CONSTRAINT fk_sms_logs_student FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
  CONSTRAINT fk_sms_logs_course FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
  INDEX idx_sms_logs_created (created_at)
) ENGINE=InnoDB;
