# Student Result Management System

An academic results portal for managing students, parents, teachers, courses,
attendance, marks, and published report cards. The project includes role-based
dashboards, account approval, result challenges, notifications, and grade audit
history.

## Project overview

The interface is built with HTML, CSS, and vanilla JavaScript. PHP API endpoints
and MySQL provide shared, persistent data when the project runs under Apache.
The browser demo data in `js/data.js` also supports a front-end demonstration
without configuring a database. Use the PHP/MySQL setup below for account and
database-backed features.

### User roles

- **Admin:** manage people, courses, semesters, academic assignments, signup
  requests, and result challenges.
- **Teacher:** enter and publish grades, manage attendance, view class summaries,
  and review grade changes.
- **Student:** view published results, attendance, report cards, and challenge a
  result.
- **Parent:** view a linked student's results, progress, report card, and
  notifications.

### Key features

- Signup requests with admin approval for student, parent, and teacher accounts.
- Grade and GPA calculation from marks, with save and publish workflows.
- Attendance summaries, semester and course assignments, and result reports.
- Result challenges, parent notifications, SMS activity logs, and grade audit
  history.
- Printable report cards and responsive dashboards.

### Technology

- Front end: HTML, CSS, and vanilla JavaScript
- Server: PHP with PDO
- Database: MySQL
- Local demonstration mode: browser `localStorage`

## PHP/MySQL account saving

New account requests created from `signup.html` are saved as pending requests.
An admin approval creates the account in MySQL through `api/approve_signup.php`.
Every SRMS feature update (grades, attendance, courses, assignments, requests,
challenges, notifications, SMS and audit logs) is also saved through `api/state.php`.
To use this feature, start **Apache** and **MySQL** in the XAMPP Control Panel, then:

1. Open `http://localhost/phpmyadmin`, choose **Import**, and import `database.sql`.
2. Copy this project folder into `C:\xampp\htdocs\Student-Result-Management` (or configure an Apache virtual host for this folder).
3. Open `http://localhost/Student-Result-Management/index.html` (not the `index.html` file directly) and log in with an account saved in MySQL. You may also create an account from `signup.html`.
4. See the saved students at `http://localhost/Student-Result-Management/php-admin.php` or in phpMyAdmin under `srms` → `students`.

XAMPP normally uses MySQL user `root` with no password. If yours differs, edit the four database settings in `api/config.php`.

If you already have an `srms` database, import `migration_semesters.sql` once
instead of recreating the database. It creates the semester list and attaches
existing course assignments and student enrollments to the active semester.
Import `migration_grades.sql` once as well to add the normalized `grades`
table. Existing grade records in `srms_state` are copied into it the next time
a dashboard loads data or a grade is saved. Import `migration_semesters.sql`
before this migration if you are upgrading an older database. `created_by` and
`accepted_by` point to account IDs; publishing a grade records its teacher in
both fields because the current dashboard has no separate grade-approval step.
Import `migration_grade_audit_log.sql` after `migration_grades.sql` to create
the SQL grade audit table. Existing audit entries in `srms_state` are backfilled
the next time a dashboard loads; future teacher saves and publishes are added
as they happen and the teacher Audit Log reads the SQL rows.
To add SQL attendance summaries to an existing database, import
`migration_attendance.sql` after `migration_semesters.sql` and
`migration_grades.sql`. Attendance is keyed by `enrollment_id`, the same
enrollment used by `grades`, and `student_result_with_attendance` joins the two
for result reports. Each enrollment has one attendance summary row; the view
also calculates its attendance percentage. In the teacher dashboard, attendance
is edited beside the mark and is synced to SQL with the result. The student
Result Overview shows attended/held classes and the percentage beside each
published result.
To enable database-backed result challenges on an existing database, also
import `migration_result_challenges.sql` once. A fresh database gets both
features when you import `database.sql`.
If you previously imported the plural `result_challenges` table, run
`migration_rename_result_challenges.sql` once to rename it to `result_challenge`.

> **Important:** SQL accounts can only be verified through Apache/PHP. Opening
> `index.html` by double-clicking it (`file:///...`) cannot run `api/login.php`,
> so it cannot access MySQL. Start **Apache** and **MySQL**, then open the
> project through `http://localhost/.../index.html`.

### Add the supplied demo accounts to MySQL

After importing the database, open this once in the browser:

`http://localhost/Student-Result-Management/api/seed_demo.php`

It creates the supplied admin, teacher, student, and parent accounts and resets
the password of those supplied demo accounts to `demo123` if they already exist.
This repairs a stale demo password without changing other accounts. The rest of
the demo data (courses, grades, attendance, etc.) syncs
to `srms_state` after you open a dashboard through `localhost`.

### Sign-up approval flow

A student, parent, or teacher first submits a **pending** request from
`signup.html`. It appears under the admin dashboard's **Sign-up Requests**.
Only when the admin selects **Approve** is the account and its role profile
created in MySQL. Selecting **Reject** only records the rejected request; no
MySQL account is created. An account created with the **Admin** role is saved
to MySQL immediately and does not need approval.

A result management system for a school, made with **HTML, CSS and JavaScript only**.
There is no server and no database software to install — the records are kept in the
browser's `localStorage`, so the project runs by simply opening `index.html`.

Four kinds of people use the system and each one gets a different dashboard:

| Role        | What they can do                                                                                                                                 |
| ----------- | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Admin**   | Manage students, parents, courses, semesters, course and section assignment, approve sign-up requests, and handle result challenges |
| **Teacher** | Enter marks, write comments, publish results, see class analytics and the audit log                                                              |
| **Student** | See own results, attendance and report card, and challenge a result                                                                              |
| **Parent**  | See the child's results, progress, report card and notifications                                                                                 |

## How to run it

1. Unzip the folder.
2. Open **`index.html`** in Chrome, Edge or Firefox.

That is all. No installation, no `npm`, no MySQL.

> If your browser blocks storage for files opened directly, open the folder in
> VS Code and start it with the **Live Server** extension, or run
> `python -m http.server` inside the folder and go to `http://localhost:8000`.

## Demo logins

Password for all of them: `demo123`

| Role      | Email               |
| --------- | ------------------- |
| Admin     | admin@school.edu    |
| Teacher   | teacher@school.edu  |
| Teacher 2 | teacher2@school.edu |
| Student   | student@school.edu  |
| Student 2 | student2@school.edu |
| Parent    | parent@school.edu   |
| Parent 2  | parent2@school.edu  |

On the login page you can also just click one of the four role buttons; it fills
the email and the password for you.

## Main features

- Login for four different roles, each one with its own dashboard.
- Nobody can create an account directly. A person sends a **sign-up request** from
  `signup.html` and the admin approves or rejects it. Only after approval does the
  login work.
- The teacher types only the **mark out of 100**. The letter grade and the GPA are
  calculated by the system from the grading table, and the letter grade updates live
  while typing.
- **Save** stores the mark quietly. **Publish** releases the result, and that is what
  creates the parent notification and the SMS entry.
- A student or a parent can **challenge** a published result, and the admin marks it
  as resolved.
- Every mark change is written into an **audit log** with the teacher's name, the
  time and the old and new value.
- The report card page can be printed or saved as PDF straight from the browser.

## Folder structure

```
student_result_management_system/
├── index.html          login page
├── signup.html         account request form
├── admin.html          admin dashboard
├── teacher.html        teacher dashboard
├── student.html        student dashboard
├── parent.html         parent dashboard
│
├── css/
│   └── style.css       all the styling
│
├── js/
│   ├── data.js         the records + all the save/read functions
│   ├── common.js       login session, sidebar menu, popups, small helpers
│   ├── login.js
│   ├── signup.js
│   ├── admin.js
│   ├── teacher.js
│   ├── student.js
│   └── parent.js
│
├── README.md
└── PROJECT_STRUCTURE.txt
```

Every page is a normal HTML file with the layout already written in it — the sidebar,
the top bar, the table headings, the forms, the report card and the popup boxes. The
JavaScript only fills in the parts that change: the table rows, the numbers and the
chart bars.

## How the code is organised

**`js/data.js`** is the data layer. It holds `seedData` (the demo records) and an
object called `db` with all the actions:

```js
db.login(email, password);
db.getState(user); // the data this role is allowed to see
db.saveGrade(user, entry); // save or publish a mark
db.addCourse(course);
db.saveAssignment(assignment); // teacher -> course, student -> section
db.addSignupRequest(request);
db.reviewSignupRequest(id, "approve" | "reject");
db.addChallenge(user, challenge);
db.resolveChallenge(id);
db.sendTestSms();
db.resetData(); // bring the demo records back
```

Every action returns either `{ ok: true }` or `{ error: "message" }`, so the pages
can show a small message when something is wrong.

**`js/common.js`** keeps the logged in user in `localStorage`, draws the sidebar,
switches between the sections of a page and holds the small helpers
(`escapeHtml`, `toast`, `gradeFromMark`, `calculateGpa`, `drawBars`).

**The four dashboard files** only display things. For example `teacher.js` reads
`db.getState(me)` once, draws the tables, and calls `db.saveGrade(...)` when the
teacher presses a button.

## Grading table

| Marks    | Grade | Grade point |
| -------- | ----- | ----------- |
| 90 – 100 | A     | 4.00        |
| 85 – 89  | A-    | 3.70        |
| 80 – 84  | B+    | 3.30        |
| 75 – 79  | B     | 3.00        |
| 70 – 74  | B-    | 2.70        |
| 65 – 69  | C+    | 2.30        |
| 60 – 64  | C     | 2.00        |
| 55 – 59  | C-    | 1.70        |
| 50 – 54  | D     | 1.00        |
| below 50 | F     | 0.00        |

CGPA is the average of the grade points of all the published results.

## A short demo path

1. Log in as **teacher**, open _Mark & Grade Entry_, type a mark for a student and
   press **Publish**.
2. Log in as **student** and the new result is on the overview, in _My Grades_ and on
   the report card.
3. Log in as **student** or **parent** and click the notification to open the result overview.
4. Log in as **admin** and approve the sign-up request that is
   waiting in _Sign-up Requests_.

The admin overview also has a **Reset demo data** button, which puts everything back
to the starting records — useful before showing the project again.

## Limits of a front-end only project

These are worth mentioning during the presentation:

- The data lives in the browser, so two different computers do not share it, and
  clearing the browser data deletes everything.
- The passwords are kept as plain text inside `data.js`. A real system must keep them
  hashed on a server, never in the browser.
- The role checks stop the pages from showing the wrong data, but anybody who opens
  the browser console can read all of it. Real access control has to be done on a
  server.
- The SMS is only written into a log table. Sending a real SMS needs a paid gateway
  and a server to call it.
