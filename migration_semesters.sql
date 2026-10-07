-- Run this once against an existing srms database to add semester support.
USE srms;

CREATE TABLE IF NOT EXISTS semesters (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  semester_name VARCHAR(80) NOT NULL UNIQUE,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  status ENUM('active', 'closed') NOT NULL DEFAULT 'closed',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT chk_semester_dates CHECK (end_date >= start_date)
) ENGINE=InnoDB;

INSERT IGNORE INTO semesters (semester_name, start_date, end_date, status) VALUES
  ('Fall 2024', '2024-09-01', '2024-12-31', 'active'),
  ('Spring 2024', '2024-01-01', '2024-05-31', 'closed'),
  ('Fall 2023', '2023-09-01', '2023-12-31', 'closed');

ALTER TABLE course_section_assignments
  ADD COLUMN semester_id INT UNSIGNED NULL AFTER section_id;
UPDATE course_section_assignments
  SET semester_id = (SELECT id FROM semesters WHERE status = 'active' ORDER BY start_date DESC LIMIT 1)
  WHERE semester_id IS NULL;
ALTER TABLE course_section_assignments
  MODIFY semester_id INT UNSIGNED NOT NULL,
  DROP INDEX uq_course_section,
  ADD UNIQUE KEY uq_course_section_semester (course_id, section_id, semester_id),
  ADD CONSTRAINT fk_csa_semester FOREIGN KEY (semester_id) REFERENCES semesters(id) ON DELETE CASCADE;

ALTER TABLE student_course_enrollments
  ADD COLUMN semester_id INT UNSIGNED NULL AFTER section_id;
UPDATE student_course_enrollments
  SET semester_id = (SELECT id FROM semesters WHERE status = 'active' ORDER BY start_date DESC LIMIT 1)
  WHERE semester_id IS NULL;
ALTER TABLE student_course_enrollments
  MODIFY semester_id INT UNSIGNED NOT NULL,
  DROP INDEX uq_student_course_section,
  ADD UNIQUE KEY uq_student_course_section_semester (student_id, course_id, section_id, semester_id),
  ADD CONSTRAINT fk_sce_semester FOREIGN KEY (semester_id) REFERENCES semesters(id) ON DELETE CASCADE;
