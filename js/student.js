/*
  student.js
  Student side: own results, attendance, report card and the
  "challenge a result" form.
*/

let me = null;      // the logged in user
let student = null; // his student record
let state = null;


document.addEventListener("DOMContentLoaded", function () {
  me = requireRole("student");
  if (!me) return;

  setupShell(me, "Student");
  setupResultNotificationButton(me);

  document.getElementById("openChallengeBtn").addEventListener("click", openChallenge);
  document.getElementById("submitChallengeBtn").addEventListener("click", submitChallenge);

  showEverything();
});


function showEverything() {
  state = db.getState(me);
  student = state.students[0];

  if (!student) {
    toast("Your student record is not ready yet. Please contact the admin office.");
    return;
  }

  document.getElementById("pageSubtitle").textContent = student.id + " · Section " + student.section;

  showOverview();
  showGrades();
  showAttendance();
  showReportCard();
  loadResultNotifications(me);
}


/* ---------------- Overview ---------------- */

function showOverview() {
  const published = publishedGrades();

  document.getElementById("headerName").textContent = student.name;
  document.getElementById("headerMeta").textContent = student.id + " · Section " + student.section;
  document.getElementById("headerCgpa").textContent = calculateGpa(state.grades);

  document.getElementById("statGpa").textContent = calculateGpa(state.grades);
  document.getElementById("statCourses").textContent = state.courses.length;
  document.getElementById("statResults").textContent = published.length;
  document.getElementById("statAttendance").textContent = overallAttendance() + "%";
  document.getElementById("semesterLine").textContent =
    "Published results for " + state.semester + ".";

  const body = document.getElementById("resultTableBody");

  if (published.length === 0) {
    body.innerHTML = '<tr><td colspan="5" class="empty">No result has been published yet.</td></tr>';
  } else {
    body.innerHTML = published.map(function (grade) {
      const course = findById(state.courses, grade.courseId);
      const attendance = attendanceForCourse(grade.courseId);
      const attendanceLabel = attendance && attendance.total > 0
        ? attendance.present + "/" + attendance.total + " (" + Math.round(attendance.present * 100 / attendance.total) + "%)"
        : "—";

      return "<tr>" +
        "<td>" + escapeHtml(course ? course.name : "-") + "</td>" +
        "<td><b>" + grade.marks + "/100</b></td>" +
        '<td><span class="tag green">' + escapeHtml(grade.grade) + "</span></td>" +
        "<td>" + attendanceLabel + "</td>" +
        "<td><i>" + escapeHtml(grade.comment) + "</i></td>" +
        "</tr>";
    }).join("");
  }

  // bar chart of the marks
  const bars = published.map(function (grade) {
    const course = findById(state.courses, grade.courseId);
    return { label: course ? course.code : "-", value: grade.marks };
  });

  drawBars(document.getElementById("markChart"), bars);
  drawBarLabels(document.getElementById("markChartLabels"), bars);
}

function publishedGrades() {
  return state.grades.filter(function (g) {
    return g.published === true || g.published === 1 || g.published === "1";
  });
}

function attendanceForCourse(courseId) {
  return state.attendance.find(function (row) { return row.courseId === courseId; });
}

function overallAttendance() {
  let present = 0;
  let total = 0;

  state.attendance.forEach(function (row) {
    present = present + row.present;
    total = total + row.total;
  });

  if (total === 0) return 0;
  return Math.round((present / total) * 100);
}


/* ---------------- My grades ---------------- */

function showGrades() {
  const body = document.getElementById("gradeTableBody");
  const published = publishedGrades();

  if (published.length === 0) {
    body.innerHTML = '<tr><td colspan="6" class="empty">Nothing published yet.</td></tr>';
    return;
  }

  body.innerHTML = published.map(function (grade) {
    const course = findById(state.courses, grade.courseId);

    return "<tr>" +
      "<td>" + escapeHtml(state.semester) + "</td>" +
      "<td>" + escapeHtml(course ? course.name : "-") + "</td>" +
      "<td>" + grade.marks + "</td>" +
      '<td><span class="tag green">' + escapeHtml(grade.grade) + "</span></td>" +
      "<td>" + grade.gpa + "</td>" +
      "<td>" + escapeHtml(grade.comment) + "</td>" +
      "</tr>";
  }).join("");
}


/* ---------------- Attendance ---------------- */

function showAttendance() {
  const grid = document.getElementById("attendanceGrid");

  if (state.attendance.length === 0) {
    grid.innerHTML = '<div class="card panel empty">No attendance has been recorded yet.</div>';
    return;
  }

  grid.innerHTML = state.attendance.map(function (row) {
    const course = findById(state.courses, row.courseId);
    const percent = row.total > 0 ? Math.round((row.present / row.total) * 100) : 0;

    return '<div class="course-card">' +
      "<h3>" + escapeHtml(course ? course.name : "-") + "</h3>" +
      "<p>" + row.present + " out of " + row.total + " classes attended</p>" +
      '<div class="progress" style="margin:15px 0"><span style="width:' + percent + '%"></span></div>' +
      "<b>" + percent + "% attendance</b>" +
      "</div>";
  }).join("");
}


/* ---------------- Report card ---------------- */

function showReportCard() {
  const published = publishedGrades();

  document.getElementById("reportName").textContent = student.name;
  document.getElementById("reportId").textContent = student.id;
  document.getElementById("reportSection").textContent = student.section;
  document.getElementById("reportSemester").textContent = state.semester;
  document.getElementById("reportDate").textContent = new Date().toLocaleDateString();
  document.getElementById("reportCgpa").textContent = calculateGpa(state.grades);
  document.getElementById("reportCourses").textContent = published.length;

  const body = document.getElementById("reportTableBody");

  if (published.length === 0) {
    body.innerHTML = '<tr><td colspan="5" class="empty">No result to print yet.</td></tr>';
    return;
  }

  body.innerHTML = published.map(function (grade) {
    const course = findById(state.courses, grade.courseId);

    return "<tr>" +
      "<td>" + escapeHtml(course ? course.name : "-") + "</td>" +
      "<td>" + grade.marks + "/100</td>" +
      "<td>" + escapeHtml(grade.grade) + "</td>" +
      "<td>" + grade.gpa + "</td>" +
      "<td>" + escapeHtml(grade.comment) + "</td>" +
      "</tr>";
  }).join("");
}


/* ---------------- Challenge a result ---------------- */

function openChallenge() {
  const published = publishedGrades();

  if (published.length === 0) {
    toast("You can only challenge a result that has been published.");
    return;
  }

  document.getElementById("challengeCourse").innerHTML = published.map(function (grade) {
    const course = findById(state.courses, grade.courseId);
    return '<option value="' + grade.courseId + '">' +
           escapeHtml((course ? course.name : "-") + " — " + grade.grade) + "</option>";
  }).join("");

  document.getElementById("challengeReason").value = "";
  openModal("challengeModal");
}

async function submitChallenge() {
  const button = document.getElementById("submitChallengeBtn");
  if (window.location.protocol === "file:") {
    toast("Challenge MySQL table-এ রাখতে XAMPP Apache চালু করে localhost URL দিয়ে খুলুন.");
    return;
  }
  button.disabled = true;
  toast("Submitting result challenge…");
  try {
    const response = await fetch("api/result_challenges.php", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ action: "submit", email: me.email || "", courseId: Number(document.getElementById("challengeCourse").value), reason: document.getElementById("challengeReason").value })
    });
    const remote = await response.json().catch(function () { return {}; });
    if (!response.ok || remote.error) throw new Error(remote.error || ("Could not save the challenge to MySQL (HTTP " + response.status + ")."));
    closeModal("challengeModal");
    toast("Challenge saved to MySQL and sent to the admin.");
  } catch (error) { toast(error.message); }
  finally { button.disabled = false; }
}
