/*
  admin.js
  Fills the admin dashboard with the data from data.js.
  The HTML is already written in admin.html - here we only put the
  rows, numbers and options inside it.
*/

let me = null;      // the logged in admin
let state = null;   // the data this page is allowed to show
let parentDirectory = { parents: [], students: [], links: [] };
let academicDirectory = null;


document.addEventListener("DOMContentLoaded", function () {
  // Remove this legacy menu/page if an older cached admin.html still contains it.
  document.querySelectorAll('.nav [data-section="sms"], #page-sms').forEach(function (element) { element.remove(); });
  document.querySelectorAll(".nav button, .nav a").forEach(function (element) {
    if (/sms\s*logs?/i.test(element.textContent || "")) element.remove();
  });

  me = requireRole("admin");
  if (!me) return;

  setupShell(me, "System administration");

  // buttons that belong only to this page
  document.getElementById("openCourseModalBtn").addEventListener("click", function () {
    openModal("courseModal");
  });
  document.getElementById("addCourseBtn").addEventListener("click", addCourse);
  document.getElementById("saveAssignmentBtn").addEventListener("click", saveAssignment);
  document.getElementById("linkParentStudentBtn").addEventListener("click", saveParentStudentLink);
  setupNotifications();

  showEverything();
  refreshSignupRequests();
  refreshApprovedPeople();
  refreshAcademics();
  loadNotifications();
  loadResultChallenges();
});


// Read the data once and draw every section.
function showEverything() {
  state = db.getState(me);

  showOverview();
  showStudents();
  showParents();
  showCourses();
  showSemesters();
  showAssignments();
  showRequests();
  showChallenges();
}

// Approved accounts are stored in MySQL. Merge them into the dashboard data
// so they are immediately available in the assignment dropdowns.
async function refreshApprovedPeople() {
  if (window.location.protocol === "file:") return;
  try {
    const response = await fetch("api/admin_people.php");
    const remote = await response.json().catch(function () { return {}; });
    if (!response.ok || !Array.isArray(remote.students)) return;

    parentDirectory = {
      parents: Array.isArray(remote.parents) ? remote.parents : [],
      students: remote.students,
      links: Array.isArray(remote.parentLinks) ? remote.parentLinks : []
    };

    const all = loadData();
    remote.students.forEach(function (student) {
      const record = {
        id: student.student_code,
        name: student.name,
        email: student.email,
        phone: student.phone || "",
        section: student.section_name || "Not assigned",
        parentId: null
      };
      const index = all.students.findIndex(function (item) { return item.id === record.id; });
      if (index === -1) all.students.push(record);
      else all.students[index] = Object.assign({}, all.students[index], record);
    });
    state = db.getState(me);

    // Keep database parent IDs separate from the old demo IDs. This lets the
    // Students table show every saved parent-student relationship correctly.
    const linkedParents = parentDirectory.parents.map(function (parent) {
      return {
        id: "db-parent-" + parent.id,
        name: parent.name,
        email: parent.email,
        phone: parent.phone || "",
        childId: null
      };
    });
    state.parents = state.parents.concat(linkedParents);
    parentDirectory.links.forEach(function (link) {
      const student = state.students.find(function (item) { return item.id === link.student_code; });
      if (student) {
        student.parentId = "db-parent-" + link.parent_id;
        student.parentRelationship = link.relationship;
      }
    });
    showStudents();
    showAssignments();
    showOverview();
    renderParentStudentLinks();
  } catch (error) {
    // Existing local records remain usable if the PHP server is unavailable.
  }
}

function renderParentStudentLinks() {
  fillSelect("linkParent", parentDirectory.parents, function (parent) {
    return { value: parent.id, text: parent.name + " (" + parent.parent_code + ")" };
  });
  fillSelect("linkStudent", parentDirectory.students, function (student) {
    return { value: student.id, text: student.name + " (" + student.student_code + ")" };
  });

  const body = document.getElementById("parentStudentLinkBody");
  if (!parentDirectory.links.length) {
    body.innerHTML = '<tr><td colspan="3" class="empty">No parent-student links yet.</td></tr>';
    return;
  }
  body.innerHTML = parentDirectory.links.map(function (link) {
    return "<tr><td><b>" + escapeHtml(link.parent_name) + "</b></td><td>" +
      escapeHtml(link.student_name) + " (" + escapeHtml(link.student_code) + ")</td><td>" +
      escapeHtml(link.relationship) + "</td></tr>";
  }).join("");
}

async function saveParentStudentLink() {
  const parentId = Number(document.getElementById("linkParent").value);
  const studentId = Number(document.getElementById("linkStudent").value);
  const relationship = document.getElementById("linkRelationship").value;
  if (!parentId || !studentId) {
    toast("Please choose a parent and a student.");
    return;
  }
  try {
    const response = await fetch("api/parent_student.php", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ parentId: parentId, studentId: studentId, relationship: relationship })
    });
    const result = await response.json().catch(function () { return {}; });
    if (!response.ok || result.error) throw new Error(result.error || "Could not save the parent-student link.");
    toast("Parent and student linked successfully.");
    refreshApprovedPeople();
  } catch (error) {
    toast(error.message);
  }
}


/* ---------------- Overview ---------------- */

function showOverview() {
  document.getElementById("statStudents").textContent = state.students.length;
  document.getElementById("statTeachers").textContent = state.teachers.length;
  document.getElementById("statCourses").textContent = state.courses.length;
  document.getElementById("statSemesters").textContent = state.semesters.length;

  const published = state.grades.filter(function (g) { return g.published; });
  const pending = state.grades.filter(function (g) { return !g.published; });

  document.getElementById("sysTotalGrades").textContent = state.grades.length;
  document.getElementById("sysPublished").textContent = published.length;
  document.getElementById("sysPending").textContent = pending.length;
  document.getElementById("sysChallenges").textContent = state.challenges.length;
  document.getElementById("sysSemester").textContent = state.semester;

  const waiting = state.signupRequests.filter(function (r) { return r.status === "Pending"; });
  document.getElementById("quickRequests").textContent = waiting.length + " request(s) waiting for approval.";
  document.getElementById("quickChallenges").textContent = state.challenges.length + " challenge(s) submitted.";

  // one bar per teacher
  const bars = state.teachers.map(function (teacher) {
    const count = published.filter(function (g) { return g.teacherId === teacher.id; }).length;
    return { label: teacher.name.split(" ")[0], value: count };
  });

  drawBars(document.getElementById("teacherChart"), bars);
  drawBarLabels(document.getElementById("teacherChartLabels"), bars);
}


/* ---------------- Students ---------------- */

function showStudents() {
  const body = document.getElementById("studentTableBody");

  if (state.students.length === 0) {
    body.innerHTML = '<tr><td colspan="7" class="empty">No students yet.</td></tr>';
    return;
  }

  body.innerHTML = state.students.map(function (student) {
    const guardian = findById(state.parents, student.parentId);
    const gpa = calculateGpa(gradesOfStudent(student.id));

    return "<tr>" +
      "<td><b>" + escapeHtml(student.name) + "</b></td>" +
      "<td>" + escapeHtml(student.id) + "</td>" +
      '<td><span class="tag blue">' + escapeHtml(student.section) + "</span></td>" +
      "<td>" + escapeHtml(guardian ? guardian.name + (student.parentRelationship ? " (" + student.parentRelationship + ")" : "") : "-") + "</td>" +
      "<td>" + escapeHtml(student.phone || "-") + "</td>" +
      "<td><b>" + gpa + "</b></td>" +
      '<td><button class="btn small light" onclick="viewStudent(\'' + student.id + '\')">View</button></td>' +
      "</tr>";
  }).join("");
}

function gradesOfStudent(studentId) {
  return state.grades.filter(function (g) { return g.studentId === studentId; });
}

function viewStudent(studentId) {
  const student = findById(state.students, studentId);
  const guardian = findById(state.parents, student.parentId);

  document.getElementById("detailsTitle").textContent = student.name;
  document.getElementById("detailsSubtitle").textContent = student.id + " · Section " + student.section;
  document.getElementById("detailsList").innerHTML =
    detailRow("Email", student.email) +
    detailRow("Parent", guardian ? guardian.name : "-") +
    detailRow("Parent phone", guardian ? guardian.phone : "-") +
    detailRow("CGPA", calculateGpa(gradesOfStudent(student.id)));

  openModal("detailsModal");
}


/* ---------------- Parents ---------------- */

function showParents() {
  const body = document.getElementById("parentTableBody");
  if (!body) return;

  if (state.parents.length === 0) {
    body.innerHTML = '<tr><td colspan="6" class="empty">No parent accounts yet.</td></tr>';
    return;
  }

  body.innerHTML = state.parents.map(function (guardian) {
    const child = findById(state.students, guardian.childId);

    return "<tr>" +
      "<td><b>" + escapeHtml(guardian.name) + "</b></td>" +
      "<td>" + escapeHtml(guardian.phone || "-") + "</td>" +
      "<td>" + escapeHtml(child ? child.name : "-") + "</td>" +
      '<td><span class="tag purple">' + escapeHtml(child ? child.section : "-") + "</span></td>" +
      '<td><span class="tag green">Active</span></td>' +
      '<td><button class="btn small light" onclick="viewParent(' + guardian.id + ')">View</button></td>' +
      "</tr>";
  }).join("");
}

function viewParent(parentId) {
  const guardian = findById(state.parents, parentId);
  const child = findById(state.students, guardian.childId);

  document.getElementById("detailsTitle").textContent = guardian.name;
  document.getElementById("detailsSubtitle").textContent = "Parent account";
  document.getElementById("detailsList").innerHTML =
    detailRow("Email", guardian.email) +
    detailRow("Phone", guardian.phone || "-") +
    detailRow("Child", child ? child.name : "-") +
    detailRow("Section", child ? child.section : "-") +
    detailRow("Child CGPA", child ? calculateGpa(gradesOfStudent(child.id)) : "-");

  openModal("detailsModal");
}

function detailRow(label, value) {
  return '<div class="overview-row"><span>' + escapeHtml(label) +
         "</span><strong>" + escapeHtml(value) + "</strong></div>";
}


/* ---------------- Courses ---------------- */

function showCourses() {
  const grid = document.getElementById("courseGrid");

  if (academicDirectory) {
    grid.innerHTML = academicDirectory.courses.map(function (course) {
      return '<div class="course-card">' +
        '<span class="tag blue">' + escapeHtml(course.course_code) + '</span>' +
        '<h3>' + escapeHtml(course.course_name) + '</h3>' +
        '<p>' + escapeHtml(course.credits) + ' credits</p>' +
        '<p>Teacher: <b>' + escapeHtml(course.teacher_name || 'Not assigned') + '</b></p>' +
        '</div>';
    }).join("");
    return;
  }

  grid.innerHTML = state.courses.map(function (course) {
    const teacher = findById(state.teachers, course.teacherId);

    return '<div class="course-card">' +
      '<span class="tag blue">' + escapeHtml(course.code) + "</span>" +
      "<h3>" + escapeHtml(course.name) + "</h3>" +
      "<p>" + course.credits + " credits</p>" +
      "<p>Teacher: <b>" + escapeHtml(teacher ? teacher.name : "Not assigned") + "</b></p>" +
      "</div>";
  }).join("");
}

async function addCourse() {
  const course = {
    name: document.getElementById("courseName").value,
    code: document.getElementById("courseCode").value,
    credits: document.getElementById("courseCredits").value
  };
  if (window.location.protocol === "file:") {
    toast("Course save করতে XAMPP/Apache দিয়ে localhost URL-এ dashboard খুলুন.");
    return;
  }
  try {
    const response = await fetch("api/courses.php", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(course)
    });
    const result = await response.json().catch(function () { return {}; });
    if (!response.ok || result.error) throw new Error(result.error || "Could not save the course.");
    closeModal("courseModal");
    document.getElementById("courseName").value = "";
    document.getElementById("courseCode").value = "";
    toast("Course saved to MySQL.");
    refreshAcademics();
  } catch (error) {
    toast(error.message);
  }
}


/* ---------------- Semesters ---------------- */

function showSemesters() {
  const body = document.getElementById("semesterTableBody");

  if (academicDirectory && Array.isArray(academicDirectory.semesters)) {
    body.innerHTML = academicDirectory.semesters.map(function (semester) {
      const active = semester.status === "active";
      const tag = active
        ? '<span class="tag green">Active</span>'
        : '<span class="tag blue">Closed</span>';
      return "<tr><td><b>" + escapeHtml(semester.semester_name) + "</b></td>" +
        "<td>" + escapeHtml(semester.start_date) + "</td>" +
        "<td>" + escapeHtml(semester.end_date) + "</td><td>" + tag + "</td></tr>";
    }).join("");
    return;
  }

  body.innerHTML = state.semesters.map(function (semester) {
    const tag = semester.active
      ? '<span class="tag green">Active</span>'
      : '<span class="tag blue">Closed</span>';

    return "<tr>" +
      "<td><b>" + escapeHtml(semester.name) + "</b></td>" +
      "<td>" + escapeHtml(semester.startDate) + "</td>" +
      "<td>" + escapeHtml(semester.endDate) + "</td>" +
      "<td>" + tag + "</td>" +
      "</tr>";
  }).join("");
}


/* ---------------- Course & section assignment ---------------- */

async function refreshAcademics() {
  if (window.location.protocol === "file:") return;
  try {
    const response = await fetch("api/academics.php");
    const records = await response.json().catch(function () { return {}; });
    if (!response.ok || !Array.isArray(records.courses) || !Array.isArray(records.sections)) return;
    academicDirectory = records;
    showCourses();
    showSemesters();
    showAssignments();
  } catch (error) {
    // Retain the original local demo data if MySQL is unavailable.
  }
}

function showAssignments() {
  if (academicDirectory) {
    fillSelect("assignTeacher", academicDirectory.teachers, function (teacher) {
      return { value: teacher.id, text: teacher.name };
    });
    fillSelect("assignCourse", academicDirectory.courses, function (course) {
      return { value: course.id, text: course.course_name + " (" + course.course_code + ")" };
    });
    fillSelect("assignStudent", academicDirectory.students, function (student) {
      return { value: student.id, text: student.name + " — " + (student.section_name || "Not assigned") };
    });
    fillSelect("assignSection", academicDirectory.sections, function (section) {
      return { value: section.id, text: section.section_name + " — " + section.class_name };
    });
    fillSelect("assignSemester", academicDirectory.semesters || [], function (semester) {
      return { value: semester.id, text: semester.semester_name };
    });
    document.getElementById("assignmentTableBody").innerHTML = academicDirectory.courses.map(function (course) {
      return "<tr><td><b>" + escapeHtml(course.course_name) + "</b></td><td>" +
        escapeHtml(course.course_code) + "</td><td>" + escapeHtml(course.credits) + "</td><td>" +
        escapeHtml(course.teacher_name || "Not assigned") + "</td></tr>";
    }).join("");
    return;
  }
  fillSelect("assignTeacher", state.teachers, function (t) {
    return { value: t.id, text: t.name };
  });

  fillSelect("assignCourse", state.courses, function (c) {
    return { value: c.id, text: c.name + " (" + c.code + ")" };
  });

  fillSelect("assignStudent", state.students, function (s) {
    return { value: s.id, text: s.name + " — " + s.section };
  });

  fillSelect("assignSection", state.sections, function (name) {
    return { value: name, text: name };
  });

  document.getElementById("assignmentTableBody").innerHTML = state.courses.map(function (course) {
    const teacher = findById(state.teachers, course.teacherId);

    return "<tr>" +
      "<td><b>" + escapeHtml(course.name) + "</b></td>" +
      "<td>" + escapeHtml(course.code) + "</td>" +
      "<td>" + course.credits + "</td>" +
      "<td>" + escapeHtml(teacher ? teacher.name : "Not assigned") + "</td>" +
      "</tr>";
  }).join("");
}

function fillSelect(id, items, makeOption) {
  const select = document.getElementById(id);
  const chosen = select.value;

  select.innerHTML = items.map(function (item) {
    const option = makeOption(item);
    return '<option value="' + escapeHtml(option.value) + '">' + escapeHtml(option.text) + "</option>";
  }).join("");

  // keep the same option selected after the list is drawn again
  if (chosen) select.value = chosen;
}

async function saveAssignment() {
  if (window.location.protocol !== "file:") {
    // Never save assignment data only in localStorage when the MySQL version
    // of the project is open. Wait for the server records to be available.
    if (!academicDirectory) await refreshAcademics();
    if (!academicDirectory) {
      toast("Academic data is still loading. Please try again in a moment.");
      return;
    }
    try {
      const response = await fetch("api/save_academic_assignment.php", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          teacherId: Number(document.getElementById("assignTeacher").value),
          courseId: Number(document.getElementById("assignCourse").value),
          studentId: Number(document.getElementById("assignStudent").value),
          sectionId: Number(document.getElementById("assignSection").value),
          semesterId: Number(document.getElementById("assignSemester").value)
        })
      });
      const result = await response.json().catch(function () { return {}; });
      if (!response.ok || result.error) throw new Error(result.error || "Could not save the academic assignment.");
      toast("Course and section assignment saved.");
      refreshAcademics();
      refreshApprovedPeople();
    } catch (error) {
      toast(error.message);
    }
    return;
  }
  const result = db.saveAssignment({
    teacherId: Number(document.getElementById("assignTeacher").value),
    courseId: Number(document.getElementById("assignCourse").value),
    studentId: document.getElementById("assignStudent").value,
    section: document.getElementById("assignSection").value
  });

  if (result.error) {
    toast(result.error);
    return;
  }

  toast("Assignment saved.");
  showEverything();
}


/* ---------------- Sign-up requests ---------------- */

function showRequests() {
  const body = document.getElementById("requestTableBody");

  if (state.signupRequests.length === 0) {
    body.innerHTML = '<tr><td colspan="7" class="empty">No sign-up requests right now.</td></tr>';
    return;
  }

  body.innerHTML = state.signupRequests.map(function (request) {
    let tagColour = "green";
    if (request.status === "Pending") tagColour = "orange";
    if (request.status === "Rejected") tagColour = "red";

    let action = "—";
    if (request.status === "Pending") {
      action = '<button class="btn small green" onclick="reviewRequest(' + request.id + ', \'approve\')">Approve</button> ' +
               '<button class="btn small red" onclick="reviewRequest(' + request.id + ', \'reject\')">Reject</button>';
    }

    return "<tr>" +
      "<td><b>" + escapeHtml(request.name) + "</b></td>" +
      "<td>" + escapeHtml(request.email) + "</td>" +
      "<td>" + escapeHtml(request.role) + "</td>" +
      "<td>" + escapeHtml(request.section) + "</td>" +
      "<td>" + escapeHtml(request.date) + "</td>" +
      '<td><span class="tag ' + tagColour + '">' + escapeHtml(request.status) + "</span></td>" +
      "<td>" + action + "</td>" +
      "</tr>";
  }).join("");
}

// Pull requests from MySQL, so requests made on another browser also appear.
async function refreshSignupRequests() {
  if (window.location.protocol === "file:") return;
  try {
    const response = await fetch("api/signup_requests.php");
    const remote = await response.json().catch(function () { return {}; });
    if (!response.ok || !Array.isArray(remote.requests)) return;

    state.signupRequests = remote.requests.map(function (request) {
      return {
        id: request.id,
        databaseRequestId: request.id,
        name: request.name,
        email: request.email,
        phone: request.phone || "",
        role: request.role.charAt(0).toUpperCase() + request.role.slice(1),
        section: request.section_name || "-",
        status: request.status.charAt(0).toUpperCase() + request.status.slice(1),
        date: request.submitted_at
      };
    });
    showRequests();
    showOverview();
  } catch (error) {
    // Keep the local demo list available when the PHP server is unavailable.
  }
}

async function reviewRequest(id, decision) {
  const request = state.signupRequests.find(function (item) { return item.id === id; });
  if (!request || request.status !== "Pending") {
    toast("This request has already been reviewed.");
    return;
  }

  // Rejecting only changes the request status. Approving first creates the
  // hashed MySQL account, then the browser state is marked Approved.
  if (decision === "approve") {
    if (window.location.protocol === "file:") {
      toast("MySQL account approve করতে localhost/XAMPP দিয়ে admin page খুলুন.");
      return;
    }
    try {
      const response = await fetch("api/review_signup.php", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ requestId: request.databaseRequestId, decision: decision })
      });
      const remote = await response.json().catch(function () { return {}; });
      if (!response.ok || remote.error) throw new Error(remote.error || "Could not review the MySQL sign-up request.");
    } catch (error) {
      toast(error.message);
      return;
    }
  }

  if (decision === "reject" && request.databaseRequestId) {
    try {
      const response = await fetch("api/review_signup.php", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ requestId: request.databaseRequestId, decision: decision })
      });
      const remote = await response.json().catch(function () { return {}; });
      if (!response.ok || remote.error) throw new Error(remote.error || "Could not reject the MySQL sign-up request.");
    } catch (error) {
      toast(error.message);
      return;
    }
  }

  // Requests loaded from MySQL may not exist in this browser's old local
  // state. The server has already completed the review above.
  if (request.databaseRequestId) {
    request.status = decision === "approve" ? "Approved" : "Rejected";
    toast(decision === "approve" ? "Request approved, the account is ready." : "Request rejected.");
    showRequests();
    showOverview();
    refreshApprovedPeople();
    loadNotifications();
    return;
  }

  const result = db.reviewSignupRequest(id, decision);

  if (result.error) {
    toast(result.error);
    return;
  }

  toast(decision === "approve" ? "Request approved, the account is ready." : "Request rejected.");
  showEverything();
}


/* ---------------- Admin notifications ---------------- */

let notifications = [];

function setupNotifications() {
  const button = document.getElementById("notificationBtn");
  const panel = document.getElementById("notificationPanel");
  button.addEventListener("click", function () {
    const hidden = panel.classList.toggle("hidden");
    button.setAttribute("aria-expanded", String(!hidden));
    if (!hidden) loadNotifications();
  });
}

async function loadNotifications() {
  if (window.location.protocol === "file:" || !me || !me.id) return;
  try {
    const response = await fetch("api/notifications.php?accountId=" + encodeURIComponent(me.id) + "&email=" + encodeURIComponent(me.email || ""));
    const remote = await response.json().catch(function () { return {}; });
    if (!response.ok || !Array.isArray(remote.notifications)) return;
    if (remote.accountId) {
      me.id = remote.accountId;
      saveSession(me);
    }
    notifications = remote.notifications;
    renderNotifications();
  } catch (error) {}
}

function renderNotifications() {
  const unread = notifications.filter(function (notification) { return !notification.is_read; }).length;
  const count = document.getElementById("notificationCount");
  count.textContent = unread > 99 ? "99+" : unread;
  count.classList.toggle("hidden", unread === 0);
  document.getElementById("notificationSummary").textContent = unread ? unread + " unread" : "No new notifications";
  const list = document.getElementById("notificationList");
  if (!notifications.length) {
    list.innerHTML = '<p class="notification-empty">No notifications yet.</p>';
    return;
  }
  list.innerHTML = notifications.map(function (notification) {
    return '<button class="notification-item ' + (notification.is_read ? "" : "unread") + '" type="button" onclick="openAdminNotification(' + notification.id + ')">' +
      '<strong>' + escapeHtml(notification.title) + '</strong><span>' + escapeHtml(notification.message) + '</span><time>' + escapeHtml(notification.created_at) + '</time></button>';
  }).join("");
}

async function openAdminNotification(notificationId) {
  const notification = notifications.find(function (item) { return item.id === notificationId; });
  if (!notification) return;
  document.getElementById("notificationPanel").classList.add("hidden");
  document.getElementById("notificationBtn").setAttribute("aria-expanded", "false");
  if (notification.notification_type === "result_challenge") {
    showSection("challenges");
    await loadResultChallenges();
    const row = document.querySelector('[data-challenge-id="' + notification.related_challenge_id + '"]');
    if (row) { row.classList.add("challenge-glow"); row.scrollIntoView({ behavior: "smooth", block: "center" }); }
  } else {
    showSection("requests");
    await refreshSignupRequests();
  }
  if (!notification.is_read && window.location.protocol !== "file:") {
    try {
      await fetch("api/notifications.php", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ accountId: me.id, email: me.email || "", notificationId: notification.id })
      });
      notification.is_read = true;
      renderNotifications();
    } catch (error) {}
  }
}


/* ---------------- Result challenges ---------------- */

function showChallenges() {
  const body = document.getElementById("challengeTableBody");

  if (state.challenges.length === 0) {
    body.innerHTML = '<tr><td colspan="6" class="empty">No challenges yet.</td></tr>';
    return;
  }

  body.innerHTML = state.challenges.map(function (challenge) {
    const student = findById(state.students, challenge.studentId);
    const course = findById(state.courses, challenge.courseId);
    const tagColour = challenge.status === "Pending" ? "orange" : "green";

    const action = challenge.status === "Pending"
      ? '<button class="btn small" onclick="resolveChallenge(' + challenge.id + ')">Resolve</button>'
      : "Resolved";

    return "<tr>" +
      "<td>" + escapeHtml(student ? student.name : challenge.studentId) + "</td>" +
      "<td>" + escapeHtml(course ? course.name : "-") + "</td>" +
      "<td>" + escapeHtml(challenge.reason) + "</td>" +
      "<td>" + escapeHtml(challenge.date) + "</td>" +
      '<td><span class="tag ' + tagColour + '">' + escapeHtml(challenge.status) + "</span></td>" +
      "<td>" + action + "</td>" +
      "</tr>";
  }).join("");
}

let remoteChallenges = null;

async function loadResultChallenges() {
  if (window.location.protocol === "file:") return;
  try {
    const response = await fetch("api/result_challenges.php?email=" + encodeURIComponent(me.email || ""));
    const remote = await response.json().catch(function () { return {}; });
    if (!response.ok || !Array.isArray(remote.challenges)) {
      remoteChallenges = null;
      document.getElementById("challengeTableBody").innerHTML = '<tr><td colspan="6" class="empty">' + escapeHtml(remote.error || "Could not load result challenges.") + '</td></tr>';
      return;
    }
    remoteChallenges = remote.challenges;
    renderResultChallenges();
  } catch (error) {
    remoteChallenges = null;
    document.getElementById("challengeTableBody").innerHTML = '<tr><td colspan="6" class="empty">Could not reach the result-challenges API: ' + escapeHtml(error.message) + '</td></tr>';
  }
}

function renderResultChallenges() {
  if (!remoteChallenges) { showChallenges(); return; }
  const body = document.getElementById("challengeTableBody");
  if (!remoteChallenges.length) { body.innerHTML = '<tr><td colspan="6" class="empty">No challenges yet.</td></tr>'; return; }
  body.innerHTML = remoteChallenges.map(function (challenge) {
    const pending = challenge.status === "pending";
    const status = challenge.status.charAt(0).toUpperCase() + challenge.status.slice(1);
    const color = pending ? "orange" : (challenge.status === "rejected" ? "red" : "green");
    const actions = pending
      ? '<button class="btn small" onclick="reviewResultChallenge(' + challenge.id + ', \'resolve\')">Resolve / Edit Mark</button> <button class="btn small red" onclick="reviewResultChallenge(' + challenge.id + ', \'reject\')">Reject</button>'
      : escapeHtml(status);
    return '<tr data-challenge-id="' + challenge.id + '">' +
      '<td>' + escapeHtml(challenge.student_name) + '</td>' +
      '<td class="challenged-course">' + escapeHtml(challenge.course_name) + '<small>Current mark: ' + escapeHtml(challenge.current_marks) + (challenge.resolved_marks === null ? '' : ' · Updated: ' + escapeHtml(challenge.resolved_marks)) + '</small></td>' +
      '<td>' + escapeHtml(challenge.reason) + '</td><td>' + escapeHtml(challenge.submitted_at) + '</td>' +
      '<td><span class="tag ' + color + '">' + escapeHtml(status) + '</span></td><td>' + actions + '</td></tr>';
  }).join("");
}

async function reviewResultChallenge(id, decision) {
  let marks = null;
  if (decision === "resolve") {
    const challenge = remoteChallenges.find(function (item) { return item.id === id; });
    marks = window.prompt("Enter the corrected mark (0–100):", challenge ? challenge.current_marks : "");
    if (marks === null) return;
    marks = Number(marks);
    if (!Number.isFinite(marks) || marks < 0 || marks > 100) { toast("Mark must be between 0 and 100."); return; }
  }
  try {
    const response = await fetch("api/result_challenges.php", {
      method: "POST", headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ action: "review", email: me.email || "", challengeId: id, decision: decision, marks: marks })
    });
    const result = await response.json().catch(function () { return {}; });
    if (!response.ok || result.error) throw new Error(result.error || "Could not update this challenge.");
    if (decision === "resolve") {
      const challenge = remoteChallenges.find(function (item) { return item.id === id; });
      const grade = state.grades.find(function (item) { return String(item.studentId) === challenge.student_code && Number(item.courseId) === Number(challenge.course_id); });
      if (grade) { const converted = gradeFromMark(marks); grade.marks = marks; grade.grade = converted.letter; grade.gpa = converted.point; }
      storeData();
    }
    toast(decision === "resolve" ? "Challenge resolved and result updated." : "Challenge rejected.");
    await loadResultChallenges();
    showOverview();
  } catch (error) { toast(error.message); }
}


/* ---------------- Reset ---------------- */

// Handy while showing the project: puts the demo records back.
function resetDemoData() {
  const sure = confirm("This will delete every change and bring back the demo records. Continue?");
  if (!sure) return;

  db.resetData();
  toast("Demo data restored.");
  showEverything();
}
