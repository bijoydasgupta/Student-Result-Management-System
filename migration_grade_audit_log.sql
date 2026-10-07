-- Run once after migration_grades.sql on an existing srms database.
USE srms;

CREATE TABLE IF NOT EXISTS grade_audit_log (
  audit_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  grade_id INT UNSIGNED NOT NULL,
  changed_by INT UNSIGNED NULL,
  old_marks DECIMAL(5,2) NULL,
  new_marks DECIMAL(5,2) NOT NULL,
  old_grade VARCHAR(2) NULL,
  new_grade VARCHAR(2) NOT NULL,
  action VARCHAR(50) NOT NULL,
  changed_at DATETIME NOT NULL,
  source_key CHAR(64) NOT NULL UNIQUE,
  CONSTRAINT fk_grade_audit_grade FOREIGN KEY (grade_id) REFERENCES grades(grade_id) ON DELETE CASCADE,
  CONSTRAINT fk_grade_audit_actor FOREIGN KEY (changed_by) REFERENCES accounts(id) ON DELETE SET NULL,
  INDEX idx_grade_audit_grade_time (grade_id, changed_at),
  INDEX idx_grade_audit_actor_time (changed_by, changed_at)
) ENGINE=InnoDB;
