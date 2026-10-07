/*
  login.js
  Handles the login form on index.html.
*/

document.addEventListener("DOMContentLoaded", function () {

  // Already logged in? Then go straight to the dashboard.
  const user = getUser();
  if (user) {
    window.location.href = user.role + ".html";
    return;
  }

  // The four role buttons only fill the email and password boxes.
  document.querySelectorAll(".demo").forEach(function (button) {
    button.addEventListener("click", function () {
      document.getElementById("email").value = button.dataset.email;
      document.getElementById("password").value = "demo123";
    });
  });

  document.getElementById("loginForm").addEventListener("submit", handleLogin);
});


async function handleLogin(event) {
  event.preventDefault();

  const email = document.getElementById("email").value.trim();
  const password = document.getElementById("password").value;
  const isDemoAccount = /^(admin|teacher|teacher2|student|student2|parent|parent2)@school\.edu$/i.test(email);

  // A PHP file cannot run when index.html is opened directly from the disk.
  // In that case MySQL is unavailable; retain only the browser demo accounts.
  if (window.location.protocol === "file:") {
    const localResult = db.login(email, password);
    if (localResult.error) {
      toast("SQL account দিয়ে লগইন করতে XAMPP/Apache চালু করে http://localhost/.../index.html খুলুন। সরাসরি index.html file খুললে MySQL ব্যবহার করা যায় না।");
      return;
    }
    saveSession(localResult.user);
    window.location.href = localResult.user.role + ".html";
    return;
  }

  let result = null;
  try {
    const response = await fetch("api/login.php", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ email: email, password: password })
    });
    const remote = await response.json().catch(function () { return {}; });
    if (response.ok && remote.user) {
      result = remote;
    } else if (isDemoAccount) {
      // Demo accounts live in data.js, so they remain usable after setup.
      result = db.login(email, password);
    } else {
      result = { error: remote.error || "Login failed. Check the email and password." };
    }
  } catch (error) {
    result = isDemoAccount
      ? db.login(email, password)
      : { error: "MySQL login server পাওয়া যায়নি। Apache ও MySQL চালু আছে কিনা দেখুন।" };
  }

  if (result.error) { toast(result.error); return; }

  saveSession(result.user);

  // admin -> admin.html, teacher -> teacher.html, and so on
  window.location.href = result.user.role + ".html";
}
