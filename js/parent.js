/*
  parent.js
  Parent side: mostly read only. The parent can see the child's results,
  attendance, report card, notifications and can ask for a review.
*/

let me = null;      // the logged in user
let child = null;   // the student this parent is linked to
let state = null;


document.addEventListener("DOMContentLoaded", function () {
  me = requireRole("parent");
  if (!me) return;

  setupShell(me, "Parent");
  setupResultNotificationButton(me);

  document.getElementById("submitChallengeBtn").addEventListener("click", submitChallenge);

  showEverything();
});


function showEverything() {
  state = db.getState(me);
  child = state.students[0];

  if (!child) {
    toast("No child is linked to your account yet. Please contact the admin office.");
    return;
  }

  // show the child's name in the top bar instead of just "Parent"
  document.getElementById("pageSubtitle").textContent = "Viewing: " + child.name;

  showOverview();
  showProgress();
  showReportCard();
  showNotifications();
}


/* ---------------- Overview ---------------- */

function showOverview() {
  const published = publishedGrades();

  document.getElementById("headerName").textContent = child.name;
  document.getElementById("headerMeta").textContent = child.id + " · Section " + child.section;
  document.getElementById("headerCgpa").textContent = calculateGpa(state.grades);

  document.getElementById("statGpa").textContent = calculateGpa(state.grades);
  document.getElementById("statGpaTerm").textContent = state.semester;
  document.getElementById("statCourses").textContent = state.courses.length;
  document.getElementById("statResults").textContent = published.length;
  document.getElementById("statAttendance").textContent = overallAttendance() + "%";

  const body = document.getElementById("resultTableBody");

  if (published.length === 0) {
    body.innerHTML = '<tr><td colspan="4" class="empty">No result has been published yet.</td></tr>';
    return;
  }

  body.innerHTML = published.map(function (grade) {
    const course = findById(state.courses, grade.courseId);

    return "<tr>" +
      "<td>" + escapeHtml(course ? course.name : "-") + "</td>" +
      "<td><b>" + grade.marks + "/100</b></td>" +
      '<td><span class="tag green">' + escapeHtml(grade.grade) + "</span></td>" +
      "<td><i>" + escapeHtml(grade.comment) + "</i></td>" +
      "</tr>";
  }).join("");
}

function publishedGrades() {
  return state.grades.filter(function (g) { return g.published; });
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


/* ---------------- Progress ---------------- */

function showProgress() {
  const bars = publishedGrades().map(function (grade) {
    const course = findById(state.courses, grade.courseId);
    return { label: course ? course.code : "-", value: grade.marks };
  });

  drawBars(document.getElementById("markChart"), bars);
  drawBarLabels(document.getElementById("markChartLabels"), bars);

  const list = document.getElementById("attendanceList");

  if (state.attendance.length === 0) {
    list.innerHTML = '<p class="muted">No attendance has been recorded yet.</p>';
    return;
  }

  list.innerHTML = state.attendance.map(function (row) {
    const course = findById(state.courses, row.courseId);
    const percent = row.total > 0 ? Math.round((row.present / row.total) * 100) : 0;

    return '<div style="margin:22px 0">' +
      '<div style="display:flex;justify-content:space-between;margin-bottom:8px">' +
        "<span>" + escapeHtml(course ? course.name : "-") + "</span>" +
        "<b>" + percent + "%</b>" +
      "</div>" +
      '<div class="progress"><span style="width:' + percent + '%"></span></div>' +
    "</div>";
  }).join("");
}


/* ---------------- Report card ---------------- */

function showReportCard() {
  const published = publishedGrades();

  document.getElementById("reportName").textContent = child.name;
  document.getElementById("reportId").textContent = child.id;
  document.getElementById("reportSection").textContent = child.section;
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


/* ---------------- Notifications ---------------- */

function showNotifications() {
  loadResultNotifications(me);
  loadSmsHistory();
  if (window.location.protocol !== "file:") return;
  const list = document.getElementById("notificationList");

  if (state.notifications.length === 0) {
    list.innerHTML = '<div class="card panel empty">No notifications yet.</div>';
  } else {
    list.innerHTML = state.notifications.map(function (item) {
      const unread = item.read ? "" : " unread";

      return '<div class="notification' + unread + '">' +
        "<b>🔔 " + escapeHtml(item.title) + "</b>" +
        "<p>" + escapeHtml(item.message) + "</p>" +
        "<small>" + escapeHtml(item.time) + "</small>" +
        "</div>";
    }).join("");
  }

  const body = document.getElementById("smsTableBody");

  if (state.sms.length === 0) {
    body.innerHTML = '<tr><td colspan="4" class="empty">No SMS has been sent yet.</td></tr>';
    return;
  }

  body.innerHTML = state.sms.map(function (sms) {
    return "<tr>" +
      "<td>" + escapeHtml(sms.time) + "</td>" +
      "<td>" + escapeHtml(sms.phone) + "</td>" +
      "<td>" + escapeHtml(sms.message) + "</td>" +
      '<td><span class="tag green">' + escapeHtml(sms.status) + "</span></td>" +
      "</tr>";
  }).join("");
}

async function loadSmsHistory() {
  const body = document.getElementById("smsTableBody");
  if (!body || window.location.protocol === "file:") return;
  try {
    const response = await fetch("api/sms_logs.php?email=" + encodeURIComponent(me.email || ""));
    const result = await response.json();
    if (!response.ok || !Array.isArray(result.logs)) throw new Error(result.error || "Could not load SMS history.");
    body.innerHTML = result.logs.length ? result.logs.map(function (sms) {
      return '<tr><td>' + escapeHtml(sms.created_at) + '</td><td>' + escapeHtml(sms.phone) + '</td><td>' + escapeHtml(sms.message) + '</td><td><span class="tag">' + escapeHtml(sms.status) + '</span></td></tr>';
    }).join("") : '<tr><td colspan="4" class="empty">No SMS delivery records yet.</td></tr>';
  } catch (error) {
    body.innerHTML = '<tr><td colspan="4" class="empty">' + escapeHtml(error.message) + '</td></tr>';
  }
}


/* ---------------- Challenge a result ---------------- */

function openChallenge() {
  const published = publishedGrades();

  if (published.length === 0) {
    toast("Only a published result can be challenged.");
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

function submitChallenge() {
  const result = db.addChallenge(me, {
    studentId: child.id,
    courseId: Number(document.getElementById("challengeCourse").value),
    reason: document.getElementById("challengeReason").value
  });

  if (result.error) {
    toast(result.error);
    return;
  }

  closeModal("challengeModal");
  toast("Your request has been sent to the admin.");
  showEverything();
}
