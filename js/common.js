/*
  common.js
  Helper functions that every page needs: the login session, the sidebar
  menu, the popup boxes and a few small formatting functions.
  This file is loaded on every page, right after data.js.
*/


/* ------------------------------------------------------------------
   Login session
   The logged in user is kept in localStorage, so he stays logged in
   while moving from one page to another.
------------------------------------------------------------------ */

function saveSession(user) {
  localStorage.setItem("srms_user", JSON.stringify(user));
}

function getUser() {
  const saved = localStorage.getItem("srms_user");
  return saved ? JSON.parse(saved) : null;
}

function logout() {
  localStorage.removeItem("srms_user");
  window.location.href = "index.html";
}

// Every dashboard page calls this first.
// If the wrong person opens the page, we send him where he belongs.
function requireRole(role) {
  const user = getUser();

  if (!user) {
    window.location.href = "index.html";
    return null;
  }

  if (user.role !== role) {
    window.location.href = user.role + ".html";
    return null;
  }

  return user;
}


/* ------------------------------------------------------------------
   The dashboard shell (sidebar, top bar, page switching)
------------------------------------------------------------------ */

function setupShell(user, subtitle) {
  document.getElementById("userName").textContent = user.name;
  document.getElementById("topName").textContent = user.name;
  document.getElementById("pageSubtitle").textContent = subtitle;

  const letter = user.name ? user.name.charAt(0).toUpperCase() : "?";
  document.querySelectorAll(".avatar").forEach(function (box) {
    box.textContent = letter;
  });

  // sidebar menu
  document.querySelectorAll(".nav button").forEach(function (button) {
    button.addEventListener("click", function () {
      showSection(button.dataset.section);
    });
  });

  document.getElementById("logoutBtn").addEventListener("click", logout);

  // hamburger button for small screens
  document.getElementById("menuBtn").addEventListener("click", function () {
    document.querySelector(".sidebar").classList.toggle("open");
  });

  // close buttons inside the popup boxes
  document.querySelectorAll(".modal-backdrop").forEach(function (backdrop) {
    backdrop.addEventListener("click", function (event) {
      if (event.target === backdrop || event.target.classList.contains("close")) {
        backdrop.classList.remove("show");
      }
    });
  });
}

// Only one <section class="page"> is visible at a time.
function showSection(name) {
  document.querySelectorAll(".nav button").forEach(function (button) {
    button.classList.toggle("active", button.dataset.section === name);
  });

  document.querySelectorAll(".page").forEach(function (page) {
    page.classList.toggle("hidden", page.id !== "page-" + name);
  });

  const active = document.querySelector('.nav button[data-section="' + name + '"]');
  if (active) {
    document.getElementById("pageTitle").textContent = active.dataset.title;
  }

  document.querySelector(".sidebar").classList.remove("open");
  window.scrollTo(0, 0);
}

async function loadResultNotifications(user) {
  const list = document.getElementById("notificationList");
  if (!list || window.location.protocol === "file:") return;
  try {
    const response = await fetch("api/notifications.php?accountId=" + encodeURIComponent(user.id) + "&email=" + encodeURIComponent(user.email || ""));
    const result = await response.json();
    if (!response.ok || !Array.isArray(result.notifications)) throw new Error(result.error || "Could not load notifications.");
    list.innerHTML = result.notifications.length ? result.notifications.map(function (item) {
      return '<button class="notification-item ' + (item.is_read ? "" : "unread") + '" type="button" onclick="openResultNotification(' + item.id + ')">' +
        '<strong>' + escapeHtml(item.title) + '</strong><span>' + escapeHtml(item.message) + '</span><time>' + escapeHtml(item.created_at) + '</time></button>';
    }).join("") : '<div class="card panel empty">No notifications yet.</div>';
    window.resultNotifications = result.notifications;
  } catch (error) {
    list.innerHTML = '<div class="card panel empty">' + escapeHtml(error.message) + '</div>';
  }
}

async function openResultNotification(notificationId) {
  const user = getUser();
  const item = (window.resultNotifications || []).find(function (notification) { return notification.id === notificationId; });
  if (!user || !item) return;
  try {
    await fetch("api/notifications.php", { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify({ accountId: user.id, email: user.email || "", notificationId: item.id }) });
  } catch (error) { /* Result overview remains available if marking read fails. */ }
  if (item.notification_type === "result_published") {
    showSection("report");
    return;
  }
  showSection("notifications");
}

function setupResultNotificationButton(user) {
  const button = document.getElementById("notificationBtn");
  if (!button) return;
  button.addEventListener("click", function () { showSection("notifications"); loadResultNotifications(user); });
}

function openModal(id) {
  document.getElementById(id).classList.add("show");
}

function closeModal(id) {
  document.getElementById(id).classList.remove("show");
}


/* ------------------------------------------------------------------
   Small helpers
------------------------------------------------------------------ */

// People can type anything in a comment box, so escape it before
// putting it inside the page.
function escapeHtml(value) {
  return String(value === null || value === undefined ? "" : value)
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#039;");
}

// Little message box in the bottom right corner.
function toast(message) {
  const box = document.createElement("div");
  box.className = "toast";
  box.textContent = message;
  document.body.appendChild(box);

  setTimeout(function () {
    box.remove();
  }, 2600);
}

// The grading table of the school.
function gradeFromMark(mark) {
  const m = Number(mark);
  if (m >= 90) return { letter: "A", point: 4.0 };
  if (m >= 85) return { letter: "A-", point: 3.7 };
  if (m >= 80) return { letter: "B+", point: 3.3 };
  if (m >= 75) return { letter: "B", point: 3.0 };
  if (m >= 70) return { letter: "B-", point: 2.7 };
  if (m >= 65) return { letter: "C+", point: 2.3 };
  if (m >= 60) return { letter: "C", point: 2.0 };
  if (m >= 55) return { letter: "C-", point: 1.7 };
  if (m >= 50) return { letter: "D", point: 1.0 };
  return { letter: "F", point: 0.0 };
}

// Average grade point of the published results.
function calculateGpa(grades) {
  const published = grades.filter(function (g) { return g.published; });
  if (published.length === 0) return "0.00";

  let total = 0;
  published.forEach(function (g) { total = total + g.gpa; });
  return (total / published.length).toFixed(2);
}

function findById(list, id) {
  return list.find(function (item) { return item.id === id; });
}

// Draws the small bar charts. Every bar is just a div with a height.
function drawBars(container, items) {
  if (items.length === 0) {
    container.innerHTML = '<p class="muted">No data to show yet.</p>';
    return;
  }

  const biggest = Math.max.apply(null, items.map(function (i) { return i.value; }));

  container.innerHTML = items.map(function (item) {
    const height = biggest > 0 ? Math.max(8, (item.value / biggest) * 100) : 8;
    return '<div class="bar-wrap">' +
             '<div class="bar" style="height:' + height + '%"><span>' + item.value + '</span></div>' +
           '</div>';
  }).join("");
}

function drawBarLabels(container, items) {
  container.innerHTML = items.map(function (item) {
    return "<span>" + escapeHtml(item.label) + "</span>";
  }).join("");
}
