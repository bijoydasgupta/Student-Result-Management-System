CREATE DATABASE IF NOT EXISTS srms CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE srms;

CREATE TABLE IF NOT EXISTS accounts(
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(120) NOT NULL,
  email VARCHAR(190) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  role ENUM('student', 'parent', 'teacher', 'admin') NOT NULL DEFAULT 'student',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS students (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  student_code VARCHAR(30) NOT NULL UNIQUE,
  account_id INT UNSIGNED NOT NULL UNIQUE,
  name VARCHAR(120) NOT NULL,
  email VARCHAR(190) NOT NULL UNIQUE,
  phone VARCHAR(30) NULL,
  section_name VARCHAR(30) NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_students_account FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS teachers (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  teacher_code VARCHAR(30) NOT NULL UNIQUE,
  account_id INT UNSIGNED NOT NULL UNIQUE,
  name VARCHAR(120) NOT NULL,
  email VARCHAR(190) NOT NULL UNIQUE,
  phone VARCHAR(30) NULL,
  section_name VARCHAR(30) NULL,
  subject_name VARCHAR(120) NOT NULL DEFAULT 'Not assigned yet',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_teachers_account FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS admins (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  admin_code VARCHAR(30) NOT NULL UNIQUE,
  account_id INT UNSIGNED NOT NULL UNIQUE,
  name VARCHAR(120) NOT NULL,
  email VARCHAR(190) NOT NULL UNIQUE,
  phone VARCHAR(30) NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_admins_account FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Master list of academic sections. Student, parent and teacher profile
-- tables currently retain section_name for backward compatibility.
CREATE TABLE IF NOT EXISTS sections (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  section_name VARCHAR(30) NOT NULL,
  class_name VARCHAR(50) NOT NULL,
  academic_year VARCHAR(20) NOT NULL,
  room_no VARCHAR(30) NULL,
  capacity SMALLINT UNSIGNED NULL,
  status ENUM('active', 'inactive') NOT NULL DEFAULT 'active',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uq_section_year (section_name, academic_year)
) ENGINE=InnoDB;

-- Master list of academic semesters/terms.
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

CREATE TABLE IF NOT EXISTS parents (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  parent_code VARCHAR(30) NOT NULL UNIQUE,
  account_id INT UNSIGNED NOT NULL UNIQUE,
  name VARCHAR(120) NOT NULL,
  email VARCHAR(190) NOT NULL UNIQUE,
  phone VARCHAR(30) NULL,
  section_name VARCHAR(30) NULL,
  child_student_code VARCHAR(30) NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_parents_account FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- A parent may be connected to more than one student, and a student may have
-- more than one parent/guardian. This table keeps that relationship separate.
CREATE TABLE IF NOT EXISTS parent_student (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  parent_id INT UNSIGNED NOT NULL,
  student_id INT UNSIGNED NOT NULL,
  relationship VARCHAR(50) NOT NULL DEFAULT 'Guardian',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_parent_student (parent_id, student_id),
  CONSTRAINT fk_parent_student_parent FOREIGN KEY (parent_id) REFERENCES parents(id) ON DELETE CASCADE,
  CONSTRAINT fk_parent_student_student FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Master course list. teacher_id stores the primary teacher selected by the
-- admin; detailed course/section assignments are stored below.
CREATE TABLE IF NOT EXISTS courses (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  course_name VARCHAR(120) NOT NULL,
  course_code VARCHAR(30) NOT NULL UNIQUE,
  credits TINYINT UNSIGNED NOT NULL DEFAULT 3,
  teacher_id INT UNSIGNED NULL,
  description VARCHAR(500) NULL,
  status ENUM('active', 'inactive') NOT NULL DEFAULT 'active',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_courses_teacher FOREIGN KEY (teacher_id) REFERENCES teachers(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- The teacher responsible for a course in a specific section.
CREATE TABLE IF NOT EXISTS course_section_assignments(
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  course_id INT UNSIGNED NOT NULL,
  section_id INT UNSIGNED NOT NULL,
  semester_id INT UNSIGNED NOT NULL,
  teacher_id INT UNSIGNED NOT NULL,
  assigned_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_course_section_semester (course_id, section_id, semester_id),
  CONSTRAINT fk_csa_course FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
  CONSTRAINT fk_csa_section FOREIGN KEY (section_id) REFERENCES sections(id) ON DELETE CASCADE,
  CONSTRAINT fk_csa_teacher FOREIGN KEY (teacher_id) REFERENCES teachers(id) ON DELETE CASCADE,
  CONSTRAINT fk_csa_semester FOREIGN KEY (semester_id) REFERENCES semesters(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- A student's enrollment in a course and section.
CREATE TABLE IF NOT EXISTS student_course_enrollments (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  student_id INT UNSIGNED NOT NULL,
  course_id INT UNSIGNED NOT NULL,
  section_id INT UNSIGNED NOT NULL,
  semester_id INT UNSIGNED NOT NULL,
  enrolled_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_student_course_section_semester (student_id, course_id, section_id, semester_id),
  CONSTRAINT fk_sce_student FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
  CONSTRAINT fk_sce_course FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
  CONSTRAINT fk_sce_section FOREIGN KEY (section_id) REFERENCES sections(id) ON DELETE CASCADE,
  CONSTRAINT fk_sce_semester FOREIGN KEY (semester_id) REFERENCES semesters(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- One grade row belongs to one student/course/section/semester enrollment.
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

-- Attendance summary for the same course enrollment as a grade/result.
-- One row per enrollment lets reports join grades and attendance reliably.
CREATE TABLE IF NOT EXISTS attendance (
  attendance_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  enrollment_id INT UNSIGNED NOT NULL,
  classes_held SMALLINT UNSIGNED NOT NULL DEFAULT 0,
  classes_present SMALLINT UNSIGNED NOT NULL DEFAULT 0,
  UNIQUE KEY uq_attendance_enrollment (enrollment_id),
  CONSTRAINT chk_attendance_present_le_held CHECK (classes_present <= classes_held),
  CONSTRAINT fk_attendance_enrollment FOREIGN KEY (enrollment_id) REFERENCES student_course_enrollments(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Result report view: grade and attendance are joined through enrollment_id.
CREATE OR REPLACE VIEW student_result_with_attendance AS
SELECT sce.student_id, sce.course_id, sce.section_id, sce.semester_id,
       g.grade_id, g.marks, g.letter_grade, g.grade_point, g.teacher_comment, g.published,
       a.attendance_id, a.classes_held, a.classes_present,
       CASE WHEN a.classes_held > 0
            THEN ROUND(a.classes_present * 100.0 / a.classes_held, 2)
            ELSE NULL END AS attendance_percentage
FROM student_course_enrollments AS sce
LEFT JOIN grades AS g ON g.enrollment_id = sce.id
LEFT JOIN attendance AS a ON a.enrollment_id = sce.id;

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

INSERT IGNORE INTO semesters (semester_name, start_date, end_date, status) VALUES
  ('Fall 2024', '2024-09-01', '2024-12-31', 'active'),
  ('Spring 2024', '2024-01-01', '2024-05-31', 'closed'),
  ('Fall 2023', '2023-09-01', '2023-12-31', 'closed');

-- Initial records keep the existing dashboard options usable in MySQL.
INSERT IGNORE INTO sections (section_name, class_name, academic_year, room_no, capacity) VALUES
  ('10-A', 'Grade 10', '2026', NULL, NULL),
  ('10-B', 'Grade 10', '2026', NULL, NULL);

INSERT IGNORE INTO courses (course_name, course_code, credits) VALUES
  ('Mathematics', 'MATH 101', 4),
  ('Physics', 'PHYS 101', 3),
  ('Computer Science', 'CS 101', 4),
  ('English', 'ENG 101', 3),
  ('Chemistry', 'CHEM 101', 3),
  ('Biology', 'BIO 101', 3);

-- A person is stored here first. Only an approved request is copied to
-- accounts and its matching student/teacher/parent profile table.
CREATE TABLE IF NOT EXISTS signup_requests (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(120) NOT NULL,
  email VARCHAR(190) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  phone VARCHAR(30) NULL,
  section_name VARCHAR(30) NULL,
  role ENUM('student', 'parent', 'teacher') NOT NULL,
  status ENUM('pending', 'approved', 'rejected') NOT NULL DEFAULT 'pending',
  submitted_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  reviewed_at TIMESTAMP NULL DEFAULT NULL
) ENGINE=InnoDB;

-- Each admin receives one notification when a new sign-up request arrives.
-- notification_type and related_request_id make the notification clickable
-- and let the UI take the admin directly to the matching request.
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

CREATE TABLE IF NOT EXISTS notifications (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  recipient_account_id INT UNSIGNED NOT NULL,
  notification_type VARCHAR(50) NOT NULL DEFAULT 'signup_request',
  title VARCHAR(180) NOT NULL,
  message VARCHAR(500) NOT NULL,
  related_request_id INT UNSIGNED NULL,
  related_challenge_id INT UNSIGNED NULL,
  related_student_id INT UNSIGNED NULL,
  related_course_id INT UNSIGNED NULL,
  is_read TINYINT(1) NOT NULL DEFAULT 0,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  read_at TIMESTAMP NULL DEFAULT NULL,
  CONSTRAINT fk_notifications_recipient FOREIGN KEY (recipient_account_id) REFERENCES accounts(id) ON DELETE CASCADE,
  CONSTRAINT fk_notifications_signup_request FOREIGN KEY (related_request_id) REFERENCES signup_requests(id) ON DELETE CASCADE,
  CONSTRAINT fk_notifications_result_challenge FOREIGN KEY (related_challenge_id) REFERENCES result_challenge(id) ON DELETE CASCADE,
  CONSTRAINT fk_notifications_result_student FOREIGN KEY (related_student_id) REFERENCES students(id) ON DELETE CASCADE,
  CONSTRAINT fk_notifications_result_course FOREIGN KEY (related_course_id) REFERENCES courses(id) ON DELETE CASCADE,
  INDEX idx_notifications_recipient_read (recipient_account_id, is_read, created_at)
) ENGINE=InnoDB;

-- Delivery audit for result SMS notifications. This table records queued
-- messages; a provider integration is required to deliver real SMS.
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

-- Stores courses, results, attendance, assignments, requests, SMS and all
-- other SRMS feature updates as one consistent application state.
CREATE TABLE IF NOT EXISTS srms_state (
  id TINYINT UNSIGNED NOT NULL PRIMARY KEY,
  state_json LONGTEXT NOT NULL,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CHECK (id = 1)
) ENGINE=InnoDB;
