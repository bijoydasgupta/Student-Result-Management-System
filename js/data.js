/*
  data.js
  This file is the "database" of the project.

  The whole system runs in the browser only, so there is no MySQL and no
  server. All the records are kept in one object and saved in the browser's
  localStorage, which means the data is still there after a page refresh.

  The starting records below (seedData) are loaded the first time the project
  is opened. After that the saved copy is used.
*/

const STORAGE_KEY = "srms_data";

const seedData = {

  semester: "Fall 2024",

  sections: ["10-A", "10-B"],

  semesters: [
    { id: 1, name: "Fall 2024",   startDate: "2024-09-01", endDate: "2024-12-31", active: true },
    { id: 2, name: "Spring 2024", startDate: "2024-01-01", endDate: "2024-05-31", active: false },
    { id: 3, name: "Fall 2023",   startDate: "2023-09-01", endDate: "2023-12-31", active: false }
  ],

  // Login accounts. In a real system the password would never be stored
  // like this, it would be hashed on a server.
  users: [
    { id: 1, name: "Michael Torres", email: "admin@school.edu",    password: "demo123", role: "admin" },
    { id: 2, name: "David Chen",     email: "teacher@school.edu",  password: "demo123", role: "teacher" },
    { id: 3, name: "Sarah Kim",      email: "teacher2@school.edu", password: "demo123", role: "teacher" },
    { id: 4, name: "Alex Johnson",   email: "student@school.edu",  password: "demo123", role: "student" },
    { id: 5, name: "Maya Patel",     email: "student2@school.edu", password: "demo123", role: "student" },
    { id: 6, name: "Robert Johnson", email: "parent@school.edu",   password: "demo123", role: "parent" },
    { id: 7, name: "Priya Patel",    email: "parent2@school.edu",  password: "demo123", role: "parent" }
  ],

  teachers: [
    { id: 1, name: "David Chen", subject: "Science & Mathematics",   email: "teacher@school.edu" },
    { id: 2, name: "Sarah Kim",  subject: "English & Computer Science", email: "teacher2@school.edu" }
  ],

  students: [
    { id: "STU-2024-001", name: "Alex Johnson", email: "student@school.edu",  phone: "+8801711000001", section: "10-A", parentId: 1 },
    { id: "STU-2024-002", name: "Maya Patel",   email: "student2@school.edu", phone: "+8801711000002", section: "10-A", parentId: 2 }
  ],

  parents: [
    { id: 1, name: "Robert Johnson", email: "parent@school.edu",  phone: "+8801811000001", childId: "STU-2024-001" },
    { id: 2, name: "Priya Patel",    email: "parent2@school.edu", phone: "+8801811000002", childId: "STU-2024-002" }
  ],

  courses: [
    { id: 1, name: "Mathematics",      code: "MATH 101", credits: 4, teacherId: 1 },
    { id: 2, name: "Physics",          code: "PHYS 101", credits: 3, teacherId: 1 },
    { id: 3, name: "Computer Science", code: "CS 101",   credits: 4, teacherId: 2 },
    { id: 4, name: "English",          code: "ENG 101",  credits: 3, teacherId: 2 },
    { id: 5, name: "Chemistry",        code: "CHEM 101", credits: 3, teacherId: null },
    { id: 6, name: "Biology",          code: "BIO 101",  credits: 3, teacherId: null }
  ],

  grades: [
    { id: 1, studentId: "STU-2024-001", courseId: 1, marks: 88, grade: "A-", gpa: 3.7, comment: "Great start to the semester.",   published: true, teacherId: 1 },
    { id: 2, studentId: "STU-2024-001", courseId: 2, marks: 81, grade: "B+", gpa: 3.3, comment: "Good work in the optics chapter.", published: true, teacherId: 1 },
    { id: 3, studentId: "STU-2024-001", courseId: 4, marks: 86, grade: "A-", gpa: 3.7, comment: "Strong mid-term essay.",         published: true, teacherId: 2 },
    { id: 4, studentId: "STU-2024-002", courseId: 1, marks: 92, grade: "A",  gpa: 4.0, comment: "Excellent problem solving.",     published: true, teacherId: 1 }
  ],

  attendance: [
    { studentId: "STU-2024-001", courseId: 1, present: 22, total: 24 },
    { studentId: "STU-2024-001", courseId: 2, present: 20, total: 22 },
    { studentId: "STU-2024-001", courseId: 4, present: 23, total: 24 },
    { studentId: "STU-2024-002", courseId: 1, present: 24, total: 24 }
  ],

  challenges: [],

  signupRequests: [
    { id: 1, name: "Daniel Miller", email: "daniel@example.com", password: "danielpass", phone: "+8801700000000",
      role: "Student", section: "10-B", status: "Pending", date: "2024-11-18 10:15" }
  ],

  sms: [
    { id: 1, parentId: 1, studentId: "STU-2024-001", phone: "+8801811000001",
      message: "A new result has been published for Alex Johnson. Please log in to see the marks.",
      status: "SENT", time: "2024-11-17 16:05" }
  ],

  notifications: [
    { id: 1, parentId: 1, title: "New result published",
      message: "A new result has been published for Alex Johnson. Please log in to see the marks.",
      read: false, time: "2024-11-17 16:05" }
  ],

  auditLog: [
    { time: "2024-11-17 16:05", who: "Sarah Kim",  action: "Published result", student: "STU-2024-001", change: "new → 86 (A-)",       courseId: 4 },
    { time: "2024-11-17 11:42", who: "David Chen", action: "Published result", student: "STU-2024-001", change: "new → 88 (A-)",       courseId: 1 },
    { time: "2024-11-17 10:18", who: "David Chen", action: "Updated mark",     student: "STU-2024-001", change: "78 (B) → 81 (B+)",    courseId: 2 }
  ]
};


/* ------------------------------------------------------------------
   Reading and writing the saved copy
------------------------------------------------------------------ */

let data = null;

function loadData() {
  if (data) return data;

  // PHP/MySQL is the source of truth when the project runs on the PHP server.
  try {
    const request = new XMLHttpRequest();
    request.open("GET", "api/state.php", false);
    request.send();
    if (request.status === 200) {
      const remote = JSON.parse(request.responseText);
      if (remote.state) {
        data = remote.state;
        localStorage.setItem(STORAGE_KEY, JSON.stringify(data));
        return data;
      }
    }
  } catch (error) {
    // Direct file opening remains available as a local-only fallback.
  }

  let saved = null;
  try {
    saved = localStorage.getItem(STORAGE_KEY);
  } catch (error) {
    // some browsers block storage when the file is opened directly
    saved = null;
  }

  if (saved) {
    data = JSON.parse(saved);
    // First server visit: migrate the browser's existing demo data to MySQL.
    storeData();
  } else {
    data = copyOf(seedData);
    storeData();
  }

  return data;
}

function storeData() {
  try {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(data));
  } catch (error) {
    console.log("The data could not be saved in this browser.");
  }

  if (window.location.protocol === "file:") return Promise.resolve({ ok: true, localOnly: true });

  // Every change made by any existing feature is also saved to PHP/MySQL.
  // Return the request so grade entry can wait for both the state/audit log
  // and normalized SQL grade row to commit before showing success.
  try {
    return fetch("api/state.php", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ state: data }),
      keepalive: true
    }).then(function (response) {
      return response.json().catch(function () { return {}; }).then(function (result) {
        if (!response.ok || result.error) return { error: result.error || "Could not save the data to MySQL." };
        return result;
      });
    }).catch(function () {
      return { error: "Could not connect to MySQL while saving the data." };
    });
  } catch (error) {}
  return Promise.resolve({ error: "Could not send the data to MySQL." });
}

// A simple deep copy, so changing the working data never touches seedData.
function copyOf(value) {
  return JSON.parse(JSON.stringify(value));
}

function nextId(list) {
  let biggest = 0;
  list.forEach(function (item) {
    if (item.id > biggest) biggest = item.id;
  });
  return biggest + 1;
}

function rightNow() {
  const now = new Date();
  const pad = function (n) { return String(n).padStart(2, "0"); };
  return now.getFullYear() + "-" + pad(now.getMonth() + 1) + "-" + pad(now.getDate()) +
         " " + pad(now.getHours()) + ":" + pad(now.getMinutes());
}

function newAuditKey() {
  return "grade-audit-" + Date.now() + "-" + Math.random().toString(36).slice(2);
}


/* ==================================================================
   db - everything the pages are allowed to do with the data
================================================================== */

const db = {

  /* ---------- login ---------- */

  login: function (email, password) {
    const all = loadData();
    const user = all.users.find(function (u) {
      return u.email.toLowerCase() === String(email).trim().toLowerCase();
    });

    if (!user || user.password !== password) {
      return { error: "Wrong email or password" };
    }

    return { user: { id: user.id, name: user.name, email: user.email, role: user.role } };
  },


  /* ---------- reading ----------
     Every dashboard asks for the data with this one function. Each role
     only gets the part it is supposed to see.                        */

  getState: function (user) {
    const all = loadData();

    const state = {
      semester: all.semester,
      sections: all.sections.slice(),
      semesters: copyOf(all.semesters),
      students: copyOf(all.students),
      enrollments: copyOf(all.enrollments || []),
      parents: copyOf(all.parents),
      teachers: copyOf(all.teachers),
      courses: copyOf(all.courses),
      grades: copyOf(all.grades),
      attendance: copyOf(all.attendance),
      challenges: copyOf(all.challenges),
      signupRequests: copyOf(all.signupRequests),
      auditLog: copyOf(all.auditLog),
      notifications: [],
      sms: all.sms.map(function (item) {
        return {
          time: item.time,
          parent: db.parentName(item.parentId),
          phone: item.phone,
          student: db.studentName(item.studentId),
          message: item.message,
          status: item.status
        };
      })
    };

    if (user.role === "admin") {
      return state;
    }

    if (user.role === "teacher") {
      const teacher = db.teacherOf(user);
      if (!teacher) return state;

      // IDs can arrive from MySQL JSON as strings even though the demo seed
      // uses numbers. Compare their canonical string forms consistently.
      const myCourses = state.courses.filter(function (c) {
        return c.teacherId != null && String(c.teacherId) === String(teacher.id);
      });
      const myCourseIds = myCourses.map(function (c) { return String(c.id); });
      if (state.enrollments.length) {
        const myStudentIds = state.enrollments.filter(function (enrollment) {
          return myCourseIds.indexOf(String(enrollment.courseId)) !== -1;
        }).map(function (enrollment) { return String(enrollment.studentId); });
        state.students = state.students.filter(function (student) {
          return myStudentIds.indexOf(String(student.id)) !== -1;
        });
      }

      state.courses = myCourses;
      state.enrollments = state.enrollments.filter(function (enrollment) {
        return myCourseIds.indexOf(String(enrollment.courseId)) !== -1;
      });
      state.teachers = state.teachers.filter(function (t) { return t.id === teacher.id; });
      state.grades = state.grades.filter(function (g) { return myCourseIds.indexOf(String(g.courseId)) !== -1; });
      state.attendance = state.attendance.filter(function (a) { return myCourseIds.indexOf(String(a.courseId)) !== -1; });
      state.auditLog = state.auditLog.filter(function (a) { return myCourseIds.indexOf(String(a.courseId)) !== -1; });
      state.parents = [];
      state.signupRequests = [];
      state.challenges = [];
      state.sms = [];
      return state;
    }

    // a student and a parent only see one student
    const student = db.studentOf(user);
    if (!student) {
      state.students = [];
      state.grades = [];
      state.attendance = [];
      state.challenges = [];
      state.courses = [];
      state.sms = [];
      state.teachers = [];
      state.parents = [];
      state.signupRequests = [];
      state.auditLog = [];
      return state;
    }

    // PHP/MySQL JSON can return numeric IDs as strings. Compare IDs in a
    // canonical form so a published grade is not hidden by a type mismatch.
    const belongsToStudent = function (record) {
      return record.studentId != null && String(record.studentId) === String(student.id);
    };
    state.students = state.students.filter(function (s) { return String(s.id) === String(student.id); });
    state.grades = state.grades.filter(belongsToStudent);
    state.attendance = state.attendance.filter(belongsToStudent);
    state.challenges = state.challenges.filter(belongsToStudent);

    const usedCourses = state.grades.map(function (g) { return g.courseId; })
      .concat(state.attendance.map(function (a) { return a.courseId; }));
    state.courses = state.courses.filter(function (c) { return usedCourses.indexOf(c.id) !== -1; });

    state.teachers = [];
    state.signupRequests = [];
    state.auditLog = [];

    if (user.role === "parent") {
      const guardian = all.parents.find(function (p) { return p.email === user.email; });
      state.parents = state.parents.filter(function (p) { return p.id === guardian.id; });
      state.sms = state.sms.filter(function (s) { return s.student === student.name; });
      state.notifications = all.notifications
        .filter(function (n) { return n.parentId === guardian.id; })
        .map(function (n) {
          return { title: n.title, message: n.message, read: n.read, time: n.time };
        });
    } else {
      state.parents = [];
      state.sms = [];
    }

    return state;
  },


  /* ---------- small look-ups ---------- */

  teacherOf: function (user) {
    return loadData().teachers.find(function (t) { return t.email === user.email; });
  },

  // For a student this is himself, for a parent it is his child.
  studentOf: function (user) {
    const all = loadData();
    const sameId = function (left, right) {
      return left != null && right != null && String(left) === String(right);
    };
    const sameEmail = function (left, right) {
      return String(left || "").trim().toLowerCase() === String(right || "").trim().toLowerCase();
    };

    if (user.role === "student") {
      return all.students.find(function (s) { return sameEmail(s.email, user.email); });
    }

    if (user.role === "parent") {
      const guardian = all.parents.find(function (p) { return sameEmail(p.email, user.email); });
      if (!guardian) return null;
      return all.students.find(function (s) { return sameId(s.id, guardian.childId); });
    }

    return null;
  },

  studentName: function (studentId) {
    const found = loadData().students.find(function (s) { return s.id === studentId; });
    return found ? found.name : "-";
  },

  parentName: function (parentId) {
    const found = loadData().parents.find(function (p) { return p.id === parentId; });
    return found ? found.name : "-";
  },


  /* ---------- teacher: save or publish a mark ---------- */

  saveGrade: function (user, entry) {
    const all = loadData();
    const mark = Number(entry.marks);

    if (isNaN(mark) || mark < 0 || mark > 100) {
      return { error: "The mark must be a number between 0 and 100" };
    }

    const student = all.students.find(function (s) { return String(s.id) === String(entry.studentId); });
    const course = all.courses.find(function (c) { return String(c.id) === String(entry.courseId); });

    if (!student || !course) {
      return { error: "Student or course not found" };
    }

    // a teacher can only give marks in his own course
    let teacherId = course.teacherId;
    if (user.role === "teacher") {
      const teacher = db.teacherOf(user);
      if (!teacher || course.teacherId == null || String(course.teacherId) !== String(teacher.id)) {
        return { error: "This course is not assigned to you" };
      }
      teacherId = teacher.id;
    }

    const result = gradeFromMark(mark);
    if (entry.attendance) {
      const held = Number(entry.attendance.total);
      const present = Number(entry.attendance.present);
      if (!Number.isInteger(held) || !Number.isInteger(present) || held < 0 || present < 0 || present > held) {
        return { error: "Attendance must use whole numbers, and classes present cannot exceed classes held" };
      }
      const attendance = all.attendance.find(function (row) {
        return String(row.studentId) === String(student.id) && String(row.courseId) === String(course.id);
      });
      if (attendance) {
        attendance.total = held;
        attendance.present = present;
      } else {
        all.attendance.push({ studentId: student.id, courseId: course.id, total: held, present: present });
      }
    }
    const existing = all.grades.find(function (g) {
      return String(g.studentId) === String(student.id) && String(g.courseId) === String(course.id);
    });

    // Only the Publish button makes a result public. Save on a result that is
    // already published just corrects it, it does not hide it again.
    const published = entry.publish === true || (existing ? existing.published : false);

    if (existing) {
      all.auditLog.unshift({
        auditKey: newAuditKey(),
        time: rightNow(),
        who: user.name,
        actorEmail: user.email || "",
        action: entry.publish ? "Published result" : "Updated mark",
        student: student.id,
        change: existing.marks + " (" + existing.grade + ") → " + mark + " (" + result.letter + ")",
        courseId: course.id
      });

      existing.marks = mark;
      existing.grade = result.letter;
      existing.gpa = result.point;
      existing.comment = entry.comment || "";
      existing.published = published;
      existing.teacherId = teacherId;
    } else {
      all.grades.push({
        id: nextId(all.grades),
        studentId: student.id,
        courseId: course.id,
        marks: mark,
        grade: result.letter,
        gpa: result.point,
        comment: entry.comment || "",
        published: published,
        teacherId: teacherId
      });

      all.auditLog.unshift({
        auditKey: newAuditKey(),
        time: rightNow(),
        who: user.name,
        actorEmail: user.email || "",
        action: entry.publish ? "Published result" : "Saved mark",
        student: student.id,
        change: "new → " + mark + " (" + result.letter + ")",
        courseId: course.id
      });
    }

    // publishing a result sends a message to the parent
    if (entry.publish === true) {
      db.messageParent(student);
    }

    const persistence = storeData();
    return { ok: true, persistence: persistence };
  },

  // Adds one SMS row and one notification for the parent of this student.
  messageParent: function (student) {
    const all = loadData();
    const guardian = all.parents.find(function (p) { return p.id === student.parentId; });
    if (!guardian) return;

    const message = "A new result has been published for " + student.name +
                    ". Please log in to see the marks.";

    all.sms.unshift({
      id: nextId(all.sms),
      parentId: guardian.id,
      studentId: student.id,
      phone: guardian.phone,
      message: message,
      status: "SENT",
      time: rightNow()
    });

    all.notifications.unshift({
      id: nextId(all.notifications),
      parentId: guardian.id,
      title: "New result published",
      message: message,
      read: false,
      time: rightNow()
    });
  },


  /* ---------- admin: courses ---------- */

  addCourse: function (course) {
    const all = loadData();
    const name = String(course.name || "").trim();
    const code = String(course.code || "").trim();
    const credits = Number(course.credits);

    if (!name || !code) {
      return { error: "Please write the course name and code" };
    }
    if (isNaN(credits) || credits <= 0 || credits > 20) {
      return { error: "Credits must be a number between 1 and 20" };
    }

    const taken = all.courses.find(function (c) {
      return c.code.toLowerCase() === code.toLowerCase();
    });
    if (taken) {
      return { error: "This course code already exists" };
    }

    all.courses.push({
      id: nextId(all.courses),
      name: name,
      code: code,
      credits: credits,
      teacherId: null
    });

    storeData();
    return { ok: true };
  },


  /* ---------- admin: course and section assignment ---------- */

  saveAssignment: function (assignment) {
    const all = loadData();

    const teacher = all.teachers.find(function (t) { return t.id === assignment.teacherId; });
    const course = all.courses.find(function (c) { return c.id === assignment.courseId; });
    const student = all.students.find(function (s) { return s.id === assignment.studentId; });

    if (!teacher || !course || !student || all.sections.indexOf(assignment.section) === -1) {
      return { error: "Please choose a valid teacher, course, student and section" };
    }

    course.teacherId = teacher.id;
    student.section = assignment.section;

    // the parent belongs to the same section as the child
    const guardian = all.parents.find(function (p) { return p.id === student.parentId; });
    if (guardian) guardian.section = assignment.section;

    storeData();
    return { ok: true };
  },


  /* ---------- sign-up requests ---------- */

  addSignupRequest: function (request) {
    const all = loadData();
    const name = String(request.name || "").trim();
    const email = String(request.email || "").trim().toLowerCase();
    const password = String(request.password || "");

    if (!name || !email || password.length < 8) {
      return { error: "Give a name, an email and a password of at least 8 characters" };
    }

    const used = all.users.find(function (u) { return u.email.toLowerCase() === email; });
    if (used) {
      return { error: "An account already uses this email" };
    }

    const waiting = all.signupRequests.find(function (r) {
      return r.email.toLowerCase() === email && r.status === "Pending";
    });
    if (waiting) {
      return { error: "A request with this email is already waiting" };
    }

    const pendingRequest = {
      id: nextId(all.signupRequests),
      databaseRequestId: Number(request.databaseRequestId || 0) || null,
      name: name,
      email: email,
      password: password,
      phone: String(request.phone || "").trim(),
      role: request.role,
      section: request.section,
      status: "Pending",
      date: rightNow()
    };
    all.signupRequests.unshift(pendingRequest);

    storeData();
    return { ok: true, request: pendingRequest };
  },

  // Keeps a newly-created PHP/MySQL account available to the existing dashboard.
  // MySQL remains the permanent account store; this only supplies the demo UI data.
  registerAccount: function (request) {
    const all = loadData();
    const name = String(request.name || "").trim();
    const email = String(request.email || "").trim().toLowerCase();
    const password = String(request.password || "");
    const role = String(request.role || "student").toLowerCase();

    if (all.users.some(function (u) { return u.email.toLowerCase() === email; })) return { ok: true };
    const userId = nextId(all.users);
    all.users.push({ id: userId, name: name, email: email, password: password, role: role });

    if (role === "student") {
      all.students.push({
        id: "STU-" + new Date().getFullYear() + "-" + String(userId).padStart(3, "0"),
        name: name, email: email, phone: String(request.phone || "").trim(),
        section: String(request.section || "Not assigned"), parentId: null
      });
    }
    if (role === "teacher") {
      all.teachers.push({
        id: nextId(all.teachers),
        name: name,
        subject: "Not assigned yet",
        email: email
      });
    }
    if (role === "parent") {
      all.parents.push({
        id: nextId(all.parents),
        name: name, email: email, phone: String(request.phone || "").trim(),
        childId: null, section: String(request.section || "Not assigned")
      });
    }
    if (role === "admin") {
      // Admin accounts do not need a separate dashboard profile in the demo UI.
    }
    storeData();
    return { ok: true };
  },

  // Approving a request is what actually creates the account.
  reviewSignupRequest: function (id, decision) {
    const all = loadData();
    const request = all.signupRequests.find(function (r) { return r.id === id; });

    if (!request) {
      return { error: "Request not found" };
    }
    if (request.status !== "Pending") {
      return { error: "This request has already been reviewed" };
    }

    if (decision === "reject") {
      request.status = "Rejected";
      storeData();
      return { ok: true };
    }

    const role = request.role.toLowerCase();
    const userId = nextId(all.users);

    all.users.push({
      id: userId,
      name: request.name,
      email: request.email,
      password: request.password,
      role: role
    });

    if (role === "teacher") {
      all.teachers.push({
        id: nextId(all.teachers),
        name: request.name,
        subject: "Not assigned yet",
        email: request.email
      });
    }

    if (role === "student") {
      all.students.push({
        id: "STU-" + new Date().getFullYear() + "-" + String(userId).padStart(3, "0"),
        name: request.name,
        email: request.email,
        phone: request.phone,
        section: request.section,
        parentId: null
      });
    }

    if (role === "parent") {
      all.parents.push({
        id: nextId(all.parents),
        name: request.name,
        email: request.email,
        phone: request.phone,
        childId: null,
        section: request.section
      });
    }

    request.status = "Approved";
    storeData();
    return { ok: true };
  },


  /* ---------- result challenges ---------- */

  addChallenge: function (user, challenge) {
    const all = loadData();
    const reason = String(challenge.reason || "").trim();

    if (!reason) {
      return { error: "Please write the reason first" };
    }

    const student = db.studentOf(user);
    if (!student || student.id !== challenge.studentId) {
      return { error: "You can only challenge your own result" };
    }

    const grade = all.grades.find(function (g) {
      return g.studentId === student.id && g.courseId === challenge.courseId && g.published;
    });
    if (!grade) {
      return { error: "That result has not been published" };
    }

    all.challenges.unshift({
      id: nextId(all.challenges),
      studentId: student.id,
      courseId: challenge.courseId,
      reason: reason,
      status: "Pending",
      date: rightNow()
    });

    storeData();
    return { ok: true };
  },

  resolveChallenge: function (id) {
    const all = loadData();
    const challenge = all.challenges.find(function (c) { return c.id === id; });

    if (!challenge) {
      return { error: "Challenge not found" };
    }

    challenge.status = "Resolved";
    storeData();
    return { ok: true };
  },


  /* ---------- admin: test the SMS feature ---------- */

  sendTestSms: function () {
    const all = loadData();
    const student = all.students.find(function (s) { return s.parentId; });

    if (!student) {
      return { error: "No student is linked to a parent yet" };
    }

    db.messageParent(student);
    storeData();
    return { ok: true };
  },


  /* ---------- start again with the demo records ---------- */

  resetData: function () {
    data = copyOf(seedData);
    storeData();
    return { ok: true };
  }
};


// As soon as this file is loaded, make sure the records exist.
// The first time it copies seedData, after that it uses the saved copy.
loadData();
