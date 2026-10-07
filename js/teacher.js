/*
  teacher.js
  Teacher side: enter marks, publish results, look at the class averages
  and the audit log.
*/

let me = null;
let state = null;
let remoteGradeAuditLog = null;


document.addEventListener("DOMContentLoaded", function () {
  me = requireRole("teacher");
  if (!me) return;

  setupShell(me, subjectOfTeacher());

  // when the teacher picks another course, redraw only the mark table
  document.getElementById("gradeCourseSelect").addEventListener("change", showGradeRows);

  showEverything();
  loadGradeAuditLog();
});


function subjectOfTeacher() {
  const teacher = db.teacherOf(me);
  return teacher ? teacher.subject : "Teacher";
}


function showEverything() {
  state = db.getState(me);

  document.getElementById("semesterTag").textContent = state.semester;
  document.getElementById("gradeSemesterTag").textContent = state.semester;

  showOverview();
  showCourseSelect();
  showGradeRows();
  showAnalytics();
  showAuditLog();
}


/* ---------------- Overview ---------------- */

function showOverview() {
  const published = state.grades.filter(function (g) { return g.published; });
  const drafts = state.grades.filter(function (g) { return !g.published; });

  document.getElementById("statMyCourses").textContent = state.courses.length;
  document.getElementById("statMyStudents").textContent = state.students.length;
  document.getElementById("statPublished").textContent = published.length;
  document.getElementById("statDrafts").textContent = drafts.length;

  const body = document.getElementById("courseTableBody");

  if (state.courses.length === 0) {
    body.innerHTML = '<tr><td colspan="6" class="empty">No course has been assigned to you yet. Please ask the admin.</td></tr>';
    return;
  }

  body.innerHTML = state.courses.map(function (course) {
    const marks = gradesOfCourse(course.id);
    const average = averageMark(marks);

    return "<tr>" +
      "<td><b>" + escapeHtml(course.name) + "</b></td>" +
      "<td>" + escapeHtml(course.code) + "</td>" +
      "<td>" + course.credits + "</td>" +
      "<td>" + marks.length + " / " + state.students.length + "</td>" +
      "<td>" + (marks.length ? average + "%" : "No marks yet") + "</td>" +
      '<td><button class="btn small" onclick="showSection(\'grades\')">Enter Grades →</button></td>' +
      "</tr>";
  }).join("");
}

function gradesOfCourse(courseId) {
  return state.grades.filter(function (g) { return g.courseId === courseId; });
}

function averageMark(grades) {
  if (grades.length === 0) return 0;

  let total = 0;
  grades.forEach(function (g) { total = total + g.marks; });
  return Math.round(total / grades.length);
}


/* ---------------- Mark & grade entry ---------------- */

function showCourseSelect() {
  const select = document.getElementById("gradeCourseSelect");
  const chosen = select.value;   // remember which course the teacher was on

  select.innerHTML = state.courses.map(function (course) {
    return '<option value="' + course.id + '">' +
           escapeHtml(course.name + " — " + course.code) + "</option>";
  }).join("");

  // after saving a mark the list is drawn again, so put the teacher back
  // on the same course instead of jumping to the first one
  if (chosen) {
    select.value = chosen;
  }
}

function showGradeRows() {
  const body = document.getElementById("gradeTableBody");
  const courseId = Number(document.getElementById("gradeCourseSelect").value);
  const courseEnrollments = state.enrollments.filter(function (enrollment) {
    return enrollment.courseId === courseId;
  });
  const courseStudents = state.enrollments.length
    ? state.students.filter(function (student) {
        return courseEnrollments.some(function (enrollment) {
          return String(enrollment.studentId) === String(student.id);
        });
      })
    : state.students;

  if (!courseId || courseStudents.length === 0) {
    body.innerHTML = '<tr><td colspan="10" class="empty">Nothing to show. You need an assigned course and students.</td></tr>';
    return;
  }

  body.innerHTML = courseStudents.map(function (student) {
    const grade = findGrade(student.id, courseId);
    const attendance = findAttendance(student.id, courseId);
    const status = grade && grade.published
      ? '<span class="tag green">Published</span>'
      : '<span class="tag orange">Draft</span>';

    let buttons = '<button class="btn small save-btn" data-student="' + student.id + '">Save</button>';
    if (!grade || !grade.published) {
      buttons += ' <button class="btn small green publish-btn" data-student="' + student.id + '">Publish</button>';
    }

    return "<tr>" +
      "<td><b>" + escapeHtml(student.name) + "</b></td>" +
      "<td>" + escapeHtml(student.section) + "</td>" +
      '<td><input class="grade-input mark-box" type="number" min="0" max="100" data-student="' +
        student.id + '" value="' + (grade ? grade.marks : "") + '"></td>' +
      '<td><input class="grade-input held-box" type="number" min="0" step="1" data-student="' + student.id + '" value="' + (attendance ? attendance.total : 0) + '"></td>' +
      '<td><input class="grade-input present-box" type="number" min="0" step="1" data-student="' + student.id + '" value="' + (attendance ? attendance.present : 0) + '"></td>' +
      '<td class="letter-cell">' + (grade ? grade.grade : "—") + "</td>" +
      '<td class="gpa-cell">' + (grade ? grade.gpa : "—") + "</td>" +
      '<td><input class="search comment-box" data-student="' + student.id +
        '" value="' + escapeHtml(grade ? grade.comment : "") + '" placeholder="Add a comment"></td>' +
      "<td>" + status + "</td>" +
      "<td>" + buttons + "</td>" +
      "</tr>";
  }).join("");

  connectRowButtons();
}

// The rows are created above, so the listeners have to be added afterwards.
function connectRowButtons() {
  document.querySelectorAll(".mark-box").forEach(function (input) {
    input.addEventListener("input", function () {
      previewGrade(input);
    });
  });

  document.querySelectorAll(".save-btn").forEach(function (button) {
    button.addEventListener("click", function () {
      saveMark(button.dataset.student, false);
    });
  });

  document.querySelectorAll(".publish-btn").forEach(function (button) {
    button.addEventListener("click", function () {
      saveMark(button.dataset.student, true);
    });
  });
}

// Shows the grade while the teacher is still typing.
function previewGrade(input) {
  const row = input.closest("tr");
  const value = input.value;

  if (value === "") {
    row.querySelector(".letter-cell").textContent = "—";
    row.querySelector(".gpa-cell").textContent = "—";
    return;
  }

  const result = gradeFromMark(value);
  row.querySelector(".letter-cell").textContent = result.letter;
  row.querySelector(".gpa-cell").textContent = result.point;
}

function findGrade(studentId, courseId) {
  return state.grades.find(function (g) {
    return g.studentId === studentId && g.courseId === courseId;
  });
}

function findAttendance(studentId, courseId) {
  return state.attendance.find(function (row) {
    return row.studentId === studentId && row.courseId === courseId;
  });
}

async function saveMark(studentId, publish) {
  const courseId = Number(document.getElementById("gradeCourseSelect").value);
  const markBox = document.querySelector('.mark-box[data-student="' + studentId + '"]');
  const commentBox = document.querySelector('.comment-box[data-student="' + studentId + '"]');
  const heldBox = document.querySelector('.held-box[data-student="' + studentId + '"]');
  const presentBox = document.querySelector('.present-box[data-student="' + studentId + '"]');

  if (markBox.value === "") {
    toast("Please enter a mark first.");
    return;
  }

  const held = Number(heldBox.value);
  const present = Number(presentBox.value);
  if (!Number.isInteger(held) || !Number.isInteger(present) || held < 0 || present < 0 || present > held) {
    toast("Attendance must use whole numbers, and classes present cannot exceed classes held.");
    return;
  }

  const result = db.saveGrade(me, {
    studentId: studentId,
    courseId: courseId,
    marks: Number(markBox.value),
    comment: commentBox.value,
    publish: publish,
    attendance: { total: held, present: present }
  });

  if (result.error) {
    toast(result.error);
    return;
  }

  // Refresh the audit view immediately, then only report a successful save
  // after MySQL has committed the state, audit entry and normalized grade row.
  remoteGradeAuditLog = null;
  showAuditLog();
  const persisted = await result.persistence;
  if (persisted && persisted.error) {
    toast(persisted.error);
    return;
  }
  const syncWarnings = [];
  if (window.location.protocol !== "file:" && (!persisted || persisted.targetGradeSynced !== true)) {
    syncWarnings.push("normalized grade row did not sync; check grades, semester, section, student and course setup");
  }
  if (window.location.protocol !== "file:" && (!persisted || persisted.targetAttendanceSynced !== true)) {
    syncWarnings.push("attendance row did not sync; check migration_attendance.sql and enrollment setup");
  }
  if (window.location.protocol !== "file:" && (!persisted || persisted.targetAuditSynced !== true)) {
    syncWarnings.push("audit row did not sync; check migration_grade_audit_log.sql");
  }
  if (publish && window.location.protocol !== "file:" && (!persisted || persisted.notificationSchemaReady !== true)) {
    syncWarnings.push("result notifications are unavailable; import migration_sms_notifications.sql");
  }
  if (publish && persisted && persisted.notificationError) {
    syncWarnings.push(persisted.notificationError);
  }
  await loadGradeAuditLog();
  showEverything();
  if (syncWarnings.length) {
    toast((publish ? "Result published and saved. " : "Mark saved. ") + "SQL sync warning: " + syncWarnings.join("; ") + ".");
  } else {
    toast(publish ? "Result published. The parent and student have been notified." : "Mark saved.");
  }
}


/* ---------------- Class analytics ---------------- */

function showAnalytics() {
  // average mark of every course, drawn as a progress bar
  const list = document.getElementById("averageList");

  if (state.courses.length === 0) {
    list.innerHTML = '<p class="muted">No course assigned yet.</p>';
  } else {
    list.innerHTML = state.courses.map(function (course) {
      const average = averageMark(gradesOfCourse(course.id));

      return '<div style="margin:22px 0">' +
        '<div style="display:flex;justify-content:space-between;margin-bottom:8px">' +
          "<span>" + escapeHtml(course.name) + "</span><b>" + average + "%</b>" +
        "</div>" +
        '<div class="progress"><span style="width:' + average + '%"></span></div>' +
      "</div>";
    }).join("");
  }

  // how many students got A, B, C, D or F
  const groups = { "A / A-": 0, "B": 0, "C": 0, "D": 0, "F": 0 };

  state.grades.filter(function (g) { return g.published; }).forEach(function (grade) {
    if (grade.gpa >= 3.7) groups["A / A-"]++;
    else if (grade.gpa >= 2.7) groups["B"]++;
    else if (grade.gpa >= 1.7) groups["C"]++;
    else if (grade.gpa >= 1) groups["D"]++;
    else groups["F"]++;
  });

  const names = Object.keys(groups);
  const biggest = Math.max(1, Math.max.apply(null, names.map(function (n) { return groups[n]; })));

  document.getElementById("distributionChart").innerHTML = names.map(function (name) {
    const height = Math.max(8, (groups[name] / biggest) * 90);
    return '<div class="dist"><div class="dbar" style="height:' + height + '%">' +
           "<small>" + groups[name] + "</small></div></div>";
  }).join("");

  document.getElementById("distributionLabels").innerHTML = names.map(function (name) {
    return "<span>" + name + "</span>";
  }).join("");
}


/* ---------------- Audit log ---------------- */

function showAuditLog() {
  const body = document.getElementById("auditTableBody");
  if (remoteGradeAuditLog !== null) {
    if (remoteGradeAuditLog.length === 0) {
      body.innerHTML = '<tr><td colspan="5" class="empty">Nothing has been changed yet.</td></tr>';
      return;
    }
    body.innerHTML = remoteGradeAuditLog.map(function (entry) {
      const previous = entry.old_marks === null
        ? "New"
        : escapeHtml(entry.old_marks) + " (" + escapeHtml(entry.old_grade || "-") + ")";
      const next = escapeHtml(entry.new_marks) + " (" + escapeHtml(entry.new_grade) + ")";
      const change = previous + " → " + next + " · " + escapeHtml(entry.course_name);
      return "<tr>" +
        "<td>" + escapeHtml(entry.changed_at) + "</td>" +
        "<td><b>" + escapeHtml(entry.changed_by_name || "Unknown") + "</b></td>" +
        "<td>" + escapeHtml(entry.action) + "</td>" +
        "<td>" + escapeHtml(entry.student_name) + " (" + escapeHtml(entry.student_code) + ")</td>" +
        "<td>" + change + "</td></tr>";
    }).join("");
    return;
  }
  const allStudents = loadData().students;

  if (state.auditLog.length === 0) {
    body.innerHTML = '<tr><td colspan="5" class="empty">Nothing has been changed yet.</td></tr>';
    return;
  }

  body.innerHTML = state.auditLog.map(function (entry) {
    const student = allStudents.find(function (item) { return String(item.id) === String(entry.student); });
    const studentLabel = student ? student.name + " (" + entry.student + ")" : entry.student;
    return "<tr>" +
      "<td>" + escapeHtml(entry.time) + "</td>" +
      "<td><b>" + escapeHtml(entry.who) + "</b></td>" +
      "<td>" + escapeHtml(entry.action) + "</td>" +
      "<td>" + escapeHtml(studentLabel) + "</td>" +
      "<td>" + escapeHtml(entry.change) + "</td>" +
      "</tr>";
  }).join("");
}

async function loadGradeAuditLog() {
  if (window.location.protocol === "file:") return;
  try {
    const response = await fetch("api/grade_audit_log.php?email=" + encodeURIComponent(me.email || ""));
    const result = await response.json().catch(function () { return {}; });
    if (!response.ok || !Array.isArray(result.auditLog)) return;
    remoteGradeAuditLog = result.auditLog;
    showAuditLog();
  } catch (error) {}
}
