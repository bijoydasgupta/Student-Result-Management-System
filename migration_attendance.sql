-- Run once against an existing srms database to add normalized attendance.
-- Import migration_semesters.sql and migration_grades.sql first.
USE srms;

CREATE TABLE IF NOT EXISTS attendance (
  attendance_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  enrollment_id INT UNSIGNED NOT NULL,
  classes_held SMALLINT UNSIGNED NOT NULL DEFAULT 0,
  classes_present SMALLINT UNSIGNED NOT NULL DEFAULT 0,
  UNIQUE KEY uq_attendance_enrollment (enrollment_id),
  CONSTRAINT chk_attendance_present_le_held CHECK (classes_present <= classes_held),
  CONSTRAINT fk_attendance_enrollment FOREIGN KEY (enrollment_id) REFERENCES student_course_enrollments(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Each result row can display attendance through the shared enrollment.
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
