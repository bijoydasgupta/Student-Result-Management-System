/*
  signup.js
  Sends a new account request. The admin has to approve it before
  the person can actually log in.
*/

document.addEventListener("DOMContentLoaded", function () {
  document.getElementById("signupForm").addEventListener("submit", sendRequest);
});


async function sendRequest(event) {
  event.preventDefault();

  const request = {
    name: document.getElementById("name").value.trim(),
    email: document.getElementById("email").value.trim(),
    password: document.getElementById("password").value,
    phone: document.getElementById("phone").value.trim(),
    role: document.getElementById("role").value,
    section: document.getElementById("section").value
  };

  const message = document.getElementById("formMessage");
  const button = event.currentTarget.querySelector("button[type='submit']");
  if (window.location.protocol === "file:") {
    message.textContent = "Request পাঠাতে XAMPP/Apache দিয়ে localhost URL-এ এই page খুলুন।";
    return;
  }
  button.disabled = true;
  const isAdmin = request.role.toLowerCase() === "admin";
  message.textContent = isAdmin ? "Creating admin account..." : "Submitting your request...";

  try {
    if (isAdmin) {
      const response = await fetch("api/register.php", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(request)
      });
      const result = await response.json().catch(function () { return {}; });
      if (!response.ok || result.error) throw new Error(result.error || "Admin account could not be created.");
      db.registerAccount(request);
    } else {
      const response = await fetch("api/signup_request.php", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(request)
      });
      const remote = await response.json().catch(function () { return {}; });
      if (!response.ok || remote.error) throw new Error(remote.error || "Sign-up request could not be submitted.");
      const result = db.addSignupRequest(Object.assign({}, request, { databaseRequestId: remote.requestId }));
      if (result.error) throw new Error(result.error);
    }
    document.getElementById("signupForm").reset();
    message.textContent = isAdmin
      ? "Admin account created. You can log in now."
      : "Request submitted. You can log in after the admin approves it.";
    toast(isAdmin ? "Admin account saved to MySQL." : "Sign-up request sent to the admin.");
  } catch (error) {
    message.textContent = error.message;
  } finally {
    button.disabled = false;
  }
}
