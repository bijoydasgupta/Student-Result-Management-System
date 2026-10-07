-- Run once against an existing srms database to add the normalized grades table.
USE srms;

CREATE TABLE IF NOT EXISTS grades (
  grade_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  enrollment_id INT UNSIGNED NOT NULL,
  marks DECIMAL(5,2) NOT NULL,
  letter_grade VARCHAR(2) NOT NULL,
  grade_point DECIMAL(3,2) NOT NULL,
  teacher_comment VARCHAR(1000) NULL,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  accepted_by INT UNSIGNED NULL,
  created_by INT UNSIGNED NULL,
  published TINYINT(1) NOT NULL DEFAULT 0,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_grades_enrollment (enrollment_id),
  CONSTRAINT chk_grades_marks CHECK (marks >= 0 AND marks <= 100),
  CONSTRAINT chk_grades_point CHECK (grade_point >= 0 AND grade_point <= 4),
  CONSTRAINT fk_grades_enrollment FOREIGN KEY (enrollment_id) REFERENCES student_course_enrollments(id) ON DELETE CASCADE,
  CONSTRAINT fk_grades_accepted_by FOREIGN KEY (accepted_by) REFERENCES accounts(id) ON DELETE SET NULL,
  CONSTRAINT fk_grades_created_by FOREIGN KEY (created_by) REFERENCES accounts(id) ON DELETE SET NULL,
  INDEX idx_grades_published_updated (published, updated_at)
) ENGINE=InnoDB;
