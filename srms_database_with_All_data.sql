-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 05, 2026 at 09:33 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `srms`
--

-- --------------------------------------------------------

--
-- Table structure for table `accounts`
--

CREATE TABLE `accounts` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(120) NOT NULL,
  `email` varchar(190) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('student','parent','teacher','admin') NOT NULL DEFAULT 'student',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `accounts`
--

INSERT INTO `accounts` (`id`, `name`, `email`, `password_hash`, `role`, `created_at`) VALUES
(1, 'huda sir', 'huda@g.com', '$2y$10$.U8RO3MSIWCzUV/FjREv5.5I8Z0S7FND2ZRYwnK3WFbPiKIA9P8om', 'admin', '2026-10-02 21:47:08'),
(2, 'mamun sir', 'mamun@g.com', '$2y$10$nhEpa9YDavYvcnBz8hRlbOGCamCD/a63iuQQN5bjQp9lZVO2.QhZO', 'admin', '2026-10-02 21:47:54'),
(3, 'bijoy das gupta', 'bijoy@g.com', '$2y$10$6vTcRBJ.u5yhPrc6OsZ1P.rjGPTcJT5iIIHotHKgMafS4Mqgm6iLi', 'student', '2026-10-02 21:49:05'),
(4, 'mahmudul hasan', 'mahmud@g.com', '$2y$10$T1S9ARxCUuzOQbIago5FV.6AijxNyj9nB6HG5j2V6UxPDZvPyom/S', 'student', '2026-10-02 21:50:53'),
(5, 'farhana sadika', 'sadika@g.com', '$2y$10$qgpayyb.FgxzyyN20NbDXuCd7fHR2A2ueOxHKN5rbrlvjoRcy0MFm', 'student', '2026-10-02 21:51:56'),
(6, 'asraful islam shanto', 'shanto203@gmail.com', '$2y$10$WGBmOy0wXeOPIQE4GKCb8.RXFP3QlsJ80.PzDWqeV3AWIs9XIdciu', 'student', '2026-10-02 21:54:19'),
(7, 'adnan sir', 'adnan@g.com', '$2y$10$nY9P98GLNSFqg2U0466X7uL9vWY7SPZwntROpMbjLKiH509d6LjUC', 'teacher', '2026-10-02 22:00:05'),
(8, 'faruk sir', 'faruk@g.com', '$2y$10$BRF.O33NzGFEr.zdzundwecVHqXSsi5Je.b8Q.mcNa0MGvV7NsNMa', 'teacher', '2026-10-02 22:00:12'),
(9, 'koli mam', 'koli@g.com', '$2y$10$w32QxxcSQ4jt68IKltl2Lu4/fVfQVAGcPtPdcSh0yXDnAu6b2Jzz6', 'teacher', '2026-10-02 22:00:16'),
(10, 'badal das', 'badal@g.com', '$2y$10$r048lEUNQjeG9MQIwU0aUetl1gwYZrk4xXB54YF3q14turmSaLKMy', 'parent', '2026-10-02 22:05:30'),
(11, 'akbar ali', 'akbar@g.com', '$2y$10$K6kH1xi4E1Du1FqUiqZLROHc9DPgD4.WOx6cPSCR9lcRwe5c0UzQO', 'parent', '2026-10-02 22:05:34'),
(12, 'anoar hossain', 'anoar@g.com', '$2y$10$SURFiCmwQhHYmzNfKdaOI.aqMHvtBnypW7DweDEW6avuhEOBHEsAe', 'parent', '2026-10-02 22:05:38'),
(13, 'Sanjana Rahman', 'sanjana@g.com', '$2y$10$Xl8Kh5FuzqVz.yzNvCGHnOsbo90ghyOgCumoxwGMx0P1rP1wgMd1.', 'parent', '2026-10-02 22:07:39'),
(14, 'Michael Torres', 'admin@school.edu', '$2y$10$VsU9Gejlza1iAkQT9Ir72OfWayV4SPt60wy3xeD.ZsPGuhHG3hV/W', 'admin', '2026-10-03 06:39:15'),
(15, 'David Chen', 'teacher@school.edu', '$2y$10$aGmxzz.rSHaovpyoLSLvg.FpgPq7c3eiPJL9r/bIJbLJHQ1mlZDeG', 'teacher', '2026-10-03 06:39:15'),
(16, 'Sarah Kim', 'teacher2@school.edu', '$2y$10$rytDLfhtY2AXr6BvAPGwUuG2HdrGWaxawSrkg/1BgSpJKTk4Xia4y', 'teacher', '2026-10-03 06:39:15'),
(17, 'Alex Johnson', 'student@school.edu', '$2y$10$pn9ioIS.V2eEtytrmq.zHuBMO/hrtxBBnEMX.XcxNmmS0smTnTaGW', 'student', '2026-10-03 06:39:15'),
(18, 'Maya Patel', 'student2@school.edu', '$2y$10$XyDzEe.6NGHYzMjWGs3zlu6xA..wFAfWLPMGSA94XYMDmBRq6614e', 'student', '2026-10-03 06:39:15'),
(19, 'Robert Johnson', 'parent@school.edu', '$2y$10$Yuv5QLwsyov4j/ycm8ot8.69KtL1vW2V8d.4U8z0yq7Yqttkh7SS2', 'parent', '2026-10-03 06:39:15'),
(20, 'Priya Patel', 'parent2@school.edu', '$2y$10$dqqg2KwNCzMnHYg8HA0xBOIBAZd2fBZUgdQ1JkV/f.ArFMr.PeVIG', 'parent', '2026-10-03 06:39:15'),
(21, 'shanto', 'shanto@g.com', '$2y$10$QDaoKYxWYaEIEVWs.JsBzevwP2Jr87WGxUsAgywGDxQAW5RDOFaNS', 'student', '2026-10-04 06:23:12');

-- --------------------------------------------------------

--
-- Table structure for table `admins`
--

CREATE TABLE `admins` (
  `id` int(10) UNSIGNED NOT NULL,
  `admin_code` varchar(30) NOT NULL,
  `account_id` int(10) UNSIGNED NOT NULL,
  `name` varchar(120) NOT NULL,
  `email` varchar(190) NOT NULL,
  `phone` varchar(30) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `admins`
--

INSERT INTO `admins` (`id`, `admin_code`, `account_id`, `name`, `email`, `phone`, `created_at`) VALUES
(1, 'ADM-2026-001', 1, 'huda sir', 'huda@g.com', '02392395239', '2026-10-02 21:47:08'),
(2, 'ADM-2026-002', 2, 'mamun sir', 'mamun@g.com', '09234792392', '2026-10-02 21:47:54'),
(3, 'ADM-DEMO-001', 14, 'Michael Torres', 'admin@school.edu', '+8801700000000', '2026-10-03 06:39:15');

-- --------------------------------------------------------

--
-- Table structure for table `attendance`
--

CREATE TABLE `attendance` (
  `attendance_id` int(10) UNSIGNED NOT NULL,
  `enrollment_id` int(10) UNSIGNED NOT NULL,
  `classes_held` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `classes_present` smallint(5) UNSIGNED NOT NULL DEFAULT 0
) ;

--
-- Dumping data for table `attendance`
--

INSERT INTO `attendance` (`attendance_id`, `enrollment_id`, `classes_held`, `classes_present`) VALUES
(1, 18, 24, 22),
(21, 8, 24, 22),
(30, 34, 24, 22),
(31, 35, 22, 20),
(32, 36, 24, 23),
(33, 37, 24, 24),
(186, 6, 24, 23),
(250, 10, 24, 20),
(267, 14, 24, 19),
(745, 12, 24, 18),
(766, 16, 24, 20),
(833, 5, 24, 18),
(1062, 7, 24, 18);

-- --------------------------------------------------------

--
-- Table structure for table `courses`
--

CREATE TABLE `courses` (
  `id` int(10) UNSIGNED NOT NULL,
  `course_name` varchar(120) NOT NULL,
  `course_code` varchar(30) NOT NULL,
  `credits` tinyint(3) UNSIGNED NOT NULL DEFAULT 3,
  `teacher_id` int(10) UNSIGNED DEFAULT NULL,
  `description` varchar(500) DEFAULT NULL,
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `courses`
--

INSERT INTO `courses` (`id`, `course_name`, `course_code`, `credits`, `teacher_id`, `description`, `status`, `created_at`, `updated_at`) VALUES
(1, 'Mathematics', 'MATH 101', 4, 1, NULL, 'active', '2026-10-02 21:42:36', '2026-10-03 05:18:24'),
(2, 'Physics', 'PHYS 101', 3, 1, NULL, 'active', '2026-10-02 21:42:36', '2026-10-03 05:18:50'),
(3, 'Computer Science', 'CS 101', 4, 3, NULL, 'active', '2026-10-02 21:42:36', '2026-10-03 05:20:18'),
(4, 'English', 'ENG 101', 3, 3, NULL, 'active', '2026-10-02 21:42:36', '2026-10-03 05:20:42'),
(5, 'Chemistry', 'CHEM 101', 3, 2, NULL, 'active', '2026-10-02 21:42:36', '2026-10-03 05:19:37'),
(6, 'Biology', 'BIO 101', 3, 2, NULL, 'active', '2026-10-02 21:42:36', '2026-10-03 05:19:53'),
(7, 'bangla', 'BANGLA 101', 3, 3, NULL, 'active', '2026-10-03 08:39:40', '2026-10-03 08:40:53');

-- --------------------------------------------------------

--
-- Table structure for table `course_section_assignments`
--

CREATE TABLE `course_section_assignments` (
  `id` int(10) UNSIGNED NOT NULL,
  `course_id` int(10) UNSIGNED NOT NULL,
  `section_id` int(10) UNSIGNED NOT NULL,
  `semester_id` int(10) UNSIGNED NOT NULL,
  `teacher_id` int(10) UNSIGNED NOT NULL,
  `assigned_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `course_section_assignments`
--

INSERT INTO `course_section_assignments` (`id`, `course_id`, `section_id`, `semester_id`, `teacher_id`, `assigned_at`) VALUES
(1, 1, 1, 1, 1, '2026-10-03 06:19:34'),
(2, 2, 1, 1, 1, '2026-10-03 05:19:08'),
(9, 5, 1, 1, 2, '2026-10-03 05:19:47'),
(13, 6, 1, 1, 2, '2026-10-03 05:20:00'),
(17, 3, 1, 1, 3, '2026-10-03 05:20:26'),
(21, 4, 1, 1, 3, '2026-10-03 05:20:58'),
(34, 7, 1, 1, 3, '2026-10-03 08:40:53');

-- --------------------------------------------------------

--
-- Table structure for table `grades`
--

CREATE TABLE `grades` (
  `grade_id` int(10) UNSIGNED NOT NULL,
  `enrollment_id` int(10) UNSIGNED NOT NULL,
  `marks` decimal(5,2) NOT NULL,
  `letter_grade` varchar(2) NOT NULL,
  `grade_point` decimal(3,2) NOT NULL,
  `teacher_comment` varchar(1000) DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `accepted_by` int(10) UNSIGNED DEFAULT NULL,
  `created_by` int(10) UNSIGNED DEFAULT NULL,
  `published` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ;

--
-- Dumping data for table `grades`
--

INSERT INTO `grades` (`grade_id`, `enrollment_id`, `marks`, `letter_grade`, `grade_point`, `teacher_comment`, `updated_at`, `accepted_by`, `created_by`, `published`, `created_at`) VALUES
(1, 18, 76.00, 'B', 3.00, 'good', '2026-10-04 07:58:39', 9, 9, 1, '2026-10-03 06:24:49'),
(21, 8, 67.00, 'C+', 2.30, 'nice', '2026-10-04 07:58:39', 7, 7, 1, '2026-10-03 06:36:09'),
(30, 34, 88.00, 'A-', 3.70, 'Great start to the semester.', '2026-10-04 07:58:39', 15, 15, 1, '2026-10-03 06:39:27'),
(31, 35, 81.00, 'B+', 3.30, 'Good work in the optics chapter.', '2026-10-04 07:58:39', 15, 15, 1, '2026-10-03 06:39:27'),
(32, 36, 86.00, 'A-', 3.70, 'Strong mid-term essay.', '2026-10-04 07:58:39', 16, 16, 1, '2026-10-03 06:39:27'),
(33, 37, 92.00, 'A', 4.00, 'Excellent problem solving.', '2026-10-04 07:58:39', 15, 15, 1, '2026-10-03 06:39:27'),
(34, 38, 89.00, 'A-', 3.70, 'great!!', '2026-10-04 07:58:39', 15, 15, 1, '2026-10-03 06:39:27'),
(219, 6, 56.00, 'C-', 1.70, 'wow', '2026-10-04 07:58:39', 7, 7, 1, '2026-10-03 07:00:39'),
(292, 10, 56.00, 'C-', 1.70, 'how', '2026-10-04 07:58:39', 8, 8, 1, '2026-10-03 07:05:06'),
(311, 14, 78.00, 'B', 3.00, 'sei', '2026-10-04 07:58:39', 8, 8, 1, '2026-10-03 07:06:39'),
(842, 12, 78.00, 'B', 3.00, 'good', '2026-10-04 07:58:39', 8, 8, 1, '2026-10-03 08:31:36'),
(865, 16, 65.00, 'C+', 2.30, 'why', '2026-10-04 07:58:39', 8, 8, 1, '2026-10-03 08:32:10'),
(938, 5, 90.00, 'A', 4.00, 'wow', '2026-10-04 07:58:39', 7, 7, 1, '2026-10-03 08:37:01'),
(1186, 7, 67.00, 'C+', 2.30, 'wow', '2026-10-04 07:58:39', 7, 7, 1, '2026-10-03 10:36:06');

-- --------------------------------------------------------

--
-- Table structure for table `grade_audit_log`
--

CREATE TABLE `grade_audit_log` (
  `audit_id` bigint(20) UNSIGNED NOT NULL,
  `grade_id` int(10) UNSIGNED NOT NULL,
  `changed_by` int(10) UNSIGNED DEFAULT NULL,
  `old_marks` decimal(5,2) DEFAULT NULL,
  `new_marks` decimal(5,2) NOT NULL,
  `old_grade` varchar(2) DEFAULT NULL,
  `new_grade` varchar(2) NOT NULL,
  `action` varchar(50) NOT NULL,
  `changed_at` datetime NOT NULL,
  `source_key` char(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `grade_audit_log`
--

INSERT INTO `grade_audit_log` (`audit_id`, `grade_id`, `changed_by`, `old_marks`, `new_marks`, `old_grade`, `new_grade`, `action`, `changed_at`, `source_key`) VALUES
(1, 1, 9, NULL, 76.00, NULL, 'B', 'Saved mark', '2026-10-03 12:24:00', '5ebbbac77f45963c32dbb6ee22b7072f16538e61c99b33e973165f27010697a0'),
(2, 1, 9, 76.00, 76.00, 'B', 'B', 'Published result', '2026-10-03 12:24:00', '297a1d3767d0033e92c80c355edac28a0075d7196ffedb496bb2b68fc41ad2cb'),
(38, 21, 7, NULL, 67.00, NULL, 'C+', 'Saved mark', '2026-10-03 12:36:00', '0c61e81a79cc139f89f1e750f8db71d68de8b0fd544a0b4a466c13300116437b'),
(41, 21, 7, 67.00, 67.00, 'C+', 'C+', 'Published result', '2026-10-03 12:36:00', '45196c9ab436fc6542c61b2c9da1de711ca04a821c5138c2edcb413640e6cc11'),
(61, 34, 15, 78.00, 89.00, 'B', 'A-', 'Updated mark', '2026-09-29 03:15:00', '3c4a049bfb1af42f1d9d169e4863ff3ffaf788e29a02b43ea3b17e87becf97bc'),
(62, 34, 15, 78.00, 78.00, 'B', 'B', 'Published result', '2026-09-29 02:19:00', '1754a5a52296fe099d7f67d589f24c2f14a70d647d9d703b3bd90b95c97a2b2f'),
(63, 31, 15, 81.00, 81.00, 'B+', 'B+', 'Updated mark', '2026-09-29 02:18:00', 'a244d62c628d4016d04b3de372aa2cab5d9e6ef2416d1d0bf52ec34df3cafa6a'),
(64, 34, 15, NULL, 78.00, NULL, 'B', 'Saved mark', '2026-09-29 02:18:00', 'a6249f1c432b86e12c63ce3be75b1b6645b075292e3a83d68634e73172c63c63'),
(65, 32, 16, NULL, 86.00, NULL, 'A-', 'Published result', '2024-11-17 16:05:00', '1b3472a160a46a0012995a24bfb78335fbf49e0dd80eceed459576f213de9a01'),
(66, 30, 15, NULL, 88.00, NULL, 'A-', 'Published result', '2024-11-17 11:42:00', 'b440602b8435967fe68aa4fbabdd8a6969004eafbec5d6c4ac12908d93a48133'),
(67, 31, 15, 78.00, 81.00, 'B', 'B+', 'Updated mark', '2024-11-17 10:18:00', '9ada9ed61d745f166fe6bade83e9ab5f81558e5dd8913006a6cd0df687be2c06'),
(332, 219, 7, NULL, 56.00, NULL, 'C-', 'Saved mark', '2026-10-03 13:00:00', 'a7f2e8b3ec8f93d99c170ed83fa6381ed9d568375424f1e6ae7d3e4fe3ff7159'),
(344, 219, 7, 56.00, 56.00, 'C-', 'C-', 'Published result', '2026-10-03 13:00:00', '603f13a1a87375b1da9bd36a27896cbd10d73d703ec7a08a09db97b71659964b'),
(448, 292, 8, NULL, 56.00, NULL, 'C-', 'Saved mark', '2026-10-03 13:05:00', 'c264b373ef97a2a8517e381870620300061380036b3a5c90f2ee9eed4fcec4eb'),
(462, 292, 8, 56.00, 56.00, 'C-', 'C-', 'Published result', '2026-10-03 13:05:00', '5ada8efcec205b0be10f03aa360830ab0a69ff5aebc15fc36d4a666300da71ac'),
(477, 311, 8, NULL, 78.00, NULL, 'B', 'Saved mark', '2026-10-03 13:06:00', '16f6f4b739ce93a9d377045a08cc86cb8d3a8c4031067e8cd147939cdc38ecbe'),
(493, 311, 8, 78.00, 78.00, 'B', 'B', 'Published result', '2026-10-03 13:06:00', 'a3bea7e428a500d83c1a70b75fcbca9032a0d79046ce829ad4a8463e1de19a71'),
(1377, 842, 8, NULL, 78.00, NULL, 'B', 'Saved mark', '2026-10-03 14:31:00', 'ea6ddb6ce756bc10f8b8c130294e60179951866cd23c31d97464ffaed6f4c419'),
(1395, 842, 8, 78.00, 78.00, 'B', 'B', 'Published result', '2026-10-03 14:31:00', '62e4a03545c499fb3818066d6cdf1cd0d933bcd30494d76063c9856691496b95'),
(1414, 865, 8, NULL, 65.00, NULL, 'C+', 'Saved mark', '2026-10-03 14:32:00', 'a28656ce4b2e96827ed26377e0ffb1ecb2beab2e9c89d6a1559acc6979158ef9'),
(1434, 865, 8, 65.00, 65.00, 'C+', 'C+', 'Published result', '2026-10-03 14:32:00', '28b8c81f966bfb6e1101996d37c2ba85f7ddc6d44a403551145efd780e589af9'),
(1539, 938, 7, NULL, 89.00, NULL, 'A-', 'Saved mark', '2026-10-03 14:37:00', '069dd3080590f968760b887a06c3db3f3a276ff96e5a74a51bfe443614a5bab7'),
(1561, 938, 7, 89.00, 89.00, 'A-', 'A-', 'Published result', '2026-10-03 14:37:00', '8bc79c5768d4651f5b4d30504b5abe269089eed9dcd1b6e21391f036928801c8'),
(1584, 938, 7, 89.00, 90.00, 'A-', 'A', 'Updated mark', '2026-10-03 14:37:00', '09ad1314169ca572df163c0ea86acb2b7a65de5d8e99e3e8697a67763ab1b38f'),
(1992, 1186, 7, NULL, 67.00, NULL, 'C+', 'Saved mark', '2026-10-03 16:36:00', '192404f2c997a890f5d92ef9777c162d7e32381605a3a6cd5816db1be8b099dc'),
(2017, 1186, 7, 67.00, 67.00, 'C+', 'C+', 'Published result', '2026-10-03 16:36:00', '10e1ce5c97ef7127955794374c92d0f81e9226be15d4c7a09d89ff62b7aa78ed');

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` int(10) UNSIGNED NOT NULL,
  `recipient_account_id` int(10) UNSIGNED NOT NULL,
  `notification_type` varchar(50) NOT NULL DEFAULT 'signup_request',
  `title` varchar(180) NOT NULL,
  `message` varchar(500) NOT NULL,
  `related_request_id` int(10) UNSIGNED DEFAULT NULL,
  `related_challenge_id` int(10) UNSIGNED DEFAULT NULL,
  `related_student_id` int(10) UNSIGNED DEFAULT NULL,
  `related_course_id` int(10) UNSIGNED DEFAULT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `read_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `recipient_account_id`, `notification_type`, `title`, `message`, `related_request_id`, `related_challenge_id`, `related_student_id`, `related_course_id`, `is_read`, `created_at`, `read_at`) VALUES
(1, 1, 'signup_request', 'New sign-up request', 'bijoy das gupta has requested a Student account.', 1, NULL, NULL, NULL, 1, '2026-10-02 21:48:43', '2026-10-02 21:49:03'),
(2, 2, 'signup_request', 'New sign-up request', 'bijoy das gupta has requested a Student account.', 1, NULL, NULL, NULL, 0, '2026-10-02 21:48:43', NULL),
(4, 1, 'signup_request', 'New sign-up request', 'mahmudul hasan has requested a Student account.', 2, NULL, NULL, NULL, 1, '2026-10-02 21:50:32', '2026-10-02 21:50:51'),
(5, 2, 'signup_request', 'New sign-up request', 'mahmudul hasan has requested a Student account.', 2, NULL, NULL, NULL, 0, '2026-10-02 21:50:32', NULL),
(7, 1, 'signup_request', 'New sign-up request', 'farhana sadika has requested a Student account.', 3, NULL, NULL, NULL, 1, '2026-10-02 21:51:38', '2026-10-02 21:51:53'),
(8, 2, 'signup_request', 'New sign-up request', 'farhana sadika has requested a Student account.', 3, NULL, NULL, NULL, 0, '2026-10-02 21:51:38', NULL),
(10, 1, 'signup_request', 'New sign-up request', 'asraful islam shanto has requested a Student account.', 4, NULL, NULL, NULL, 0, '2026-10-02 21:53:34', NULL),
(11, 2, 'signup_request', 'New sign-up request', 'asraful islam shanto has requested a Student account.', 4, NULL, NULL, NULL, 1, '2026-10-02 21:53:34', '2026-10-02 21:54:18'),
(13, 1, 'signup_request', 'New sign-up request', 'abcd has requested a Student account.', 5, NULL, NULL, NULL, 0, '2026-10-02 21:55:00', NULL),
(14, 2, 'signup_request', 'New sign-up request', 'abcd has requested a Student account.', 5, NULL, NULL, NULL, 1, '2026-10-02 21:55:00', '2026-10-02 21:56:16'),
(16, 1, 'signup_request', 'New sign-up request', 'dgdt has requested a Student account.', 6, NULL, NULL, NULL, 0, '2026-10-02 21:55:43', NULL),
(17, 2, 'signup_request', 'New sign-up request', 'dgdt has requested a Student account.', 6, NULL, NULL, NULL, 1, '2026-10-02 21:55:43', '2026-10-02 21:56:03'),
(19, 1, 'signup_request', 'New sign-up request', 'adnan sir has requested a Teacher account.', 7, NULL, NULL, NULL, 1, '2026-10-02 21:57:52', '2026-10-02 22:00:03'),
(20, 2, 'signup_request', 'New sign-up request', 'adnan sir has requested a Teacher account.', 7, NULL, NULL, NULL, 0, '2026-10-02 21:57:52', NULL),
(22, 1, 'signup_request', 'New sign-up request', 'faruk sir has requested a Teacher account.', 8, NULL, NULL, NULL, 1, '2026-10-02 21:58:28', '2026-10-02 22:00:10'),
(23, 2, 'signup_request', 'New sign-up request', 'faruk sir has requested a Teacher account.', 8, NULL, NULL, NULL, 0, '2026-10-02 21:58:28', NULL),
(25, 1, 'signup_request', 'New sign-up request', 'koli mam has requested a Teacher account.', 9, NULL, NULL, NULL, 1, '2026-10-02 21:59:27', '2026-10-02 22:00:15'),
(26, 2, 'signup_request', 'New sign-up request', 'koli mam has requested a Teacher account.', 9, NULL, NULL, NULL, 0, '2026-10-02 21:59:27', NULL),
(28, 1, 'signup_request', 'New sign-up request', 'badal das has requested a Parent account.', 10, NULL, NULL, NULL, 1, '2026-10-02 22:02:23', '2026-10-02 22:05:29'),
(29, 2, 'signup_request', 'New sign-up request', 'badal das has requested a Parent account.', 10, NULL, NULL, NULL, 0, '2026-10-02 22:02:23', NULL),
(31, 1, 'signup_request', 'New sign-up request', 'akbar ali has requested a Parent account.', 11, NULL, NULL, NULL, 1, '2026-10-02 22:04:12', '2026-10-02 22:05:32'),
(32, 2, 'signup_request', 'New sign-up request', 'akbar ali has requested a Parent account.', 11, NULL, NULL, NULL, 0, '2026-10-02 22:04:12', NULL),
(34, 1, 'signup_request', 'New sign-up request', 'anoar hossain has requested a Parent account.', 12, NULL, NULL, NULL, 1, '2026-10-02 22:05:12', '2026-10-02 22:05:37'),
(35, 2, 'signup_request', 'New sign-up request', 'anoar hossain has requested a Parent account.', 12, NULL, NULL, NULL, 0, '2026-10-02 22:05:12', NULL),
(37, 1, 'signup_request', 'New sign-up request', 'Sanjana Rahman has requested a Parent account.', 13, NULL, NULL, NULL, 1, '2026-10-02 22:07:09', '2026-10-02 22:07:36'),
(38, 2, 'signup_request', 'New sign-up request', 'Sanjana Rahman has requested a Parent account.', 13, NULL, NULL, NULL, 1, '2026-10-02 22:07:09', '2026-10-04 05:32:07'),
(39, 3, 'result_published', 'New result published', 'A new result has been published for bijoy das gupta. Open notifications to view the result overview.', NULL, NULL, 1, 3, 1, '2026-10-03 06:24:51', '2026-10-03 08:22:59'),
(40, 10, 'result_published', 'New result published', 'A new result has been published for bijoy das gupta. Open notifications to view the result overview.', NULL, NULL, 1, 3, 1, '2026-10-03 06:24:51', '2026-10-03 10:38:50'),
(41, 4, 'result_published', 'New result published', 'A new result has been published for mahmudul hasan. Open notifications to view the result overview.', NULL, NULL, 2, 1, 1, '2026-10-03 06:36:11', '2026-10-03 06:42:58'),
(42, 11, 'result_published', 'New result published', 'A new result has been published for mahmudul hasan. Open notifications to view the result overview.', NULL, NULL, 2, 1, 0, '2026-10-03 06:36:11', NULL),
(43, 1, 'result_challenge', 'New result challenge', 'mahmudul hasan challenged Mathematics.', NULL, 1, NULL, NULL, 1, '2026-10-03 06:56:42', '2026-10-04 06:26:17'),
(44, 2, 'result_challenge', 'New result challenge', 'mahmudul hasan challenged Mathematics.', NULL, 1, NULL, NULL, 1, '2026-10-03 06:56:42', '2026-10-04 05:32:05'),
(45, 14, 'result_challenge', 'New result challenge', 'mahmudul hasan challenged Mathematics.', NULL, 1, NULL, NULL, 1, '2026-10-03 06:56:42', '2026-10-03 06:56:58'),
(46, 3, 'result_published', 'New result published', 'A new result has been published for bijoy das gupta. Open notifications to view the result overview.', NULL, NULL, 1, 1, 1, '2026-10-03 07:00:40', '2026-10-03 08:22:57'),
(47, 10, 'result_published', 'New result published', 'A new result has been published for bijoy das gupta. Open notifications to view the result overview.', NULL, NULL, 1, 1, 0, '2026-10-03 07:00:40', NULL),
(48, 3, 'result_published', 'New result published', 'A new result has been published for bijoy das gupta. Open notifications to view the result overview.', NULL, NULL, 1, 5, 1, '2026-10-03 07:05:11', '2026-10-04 05:34:53'),
(49, 10, 'result_published', 'New result published', 'A new result has been published for bijoy das gupta. Open notifications to view the result overview.', NULL, NULL, 1, 5, 1, '2026-10-03 07:05:11', '2026-10-03 10:38:47'),
(50, 3, 'result_published', 'New result published', 'A new result has been published for bijoy das gupta. Open notifications to view the result overview.', NULL, NULL, 1, 6, 1, '2026-10-03 07:06:40', '2026-10-03 08:22:55'),
(51, 10, 'result_published', 'New result published', 'A new result has been published for bijoy das gupta. Open notifications to view the result overview.', NULL, NULL, 1, 6, 1, '2026-10-03 07:06:40', '2026-10-03 10:38:44'),
(52, 4, 'result_published', 'New result published', 'A new result has been published for mahmudul hasan. Open notifications to view the result overview.', NULL, NULL, 2, 5, 1, '2026-10-03 08:31:41', '2026-10-03 08:38:06'),
(53, 11, 'result_published', 'New result published', 'A new result has been published for mahmudul hasan. Open notifications to view the result overview.', NULL, NULL, 2, 5, 0, '2026-10-03 08:31:41', NULL),
(54, 4, 'result_published', 'New result published', 'A new result has been published for mahmudul hasan. Open notifications to view the result overview.', NULL, NULL, 2, 6, 1, '2026-10-03 08:32:16', '2026-10-03 08:38:12'),
(55, 11, 'result_published', 'New result published', 'A new result has been published for mahmudul hasan. Open notifications to view the result overview.', NULL, NULL, 2, 6, 0, '2026-10-03 08:32:16', NULL),
(56, 4, 'result_published', 'New result published', 'A new result has been published for mahmudul hasan. Open notifications to view the result overview.', NULL, NULL, 2, 2, 1, '2026-10-03 08:37:11', '2026-10-04 05:44:06'),
(57, 11, 'result_published', 'New result published', 'A new result has been published for mahmudul hasan. Open notifications to view the result overview.', NULL, NULL, 2, 2, 0, '2026-10-03 08:37:11', NULL),
(58, 1, 'result_challenge', 'New result challenge', 'mahmudul hasan challenged Mathematics.', NULL, 2, NULL, NULL, 1, '2026-10-03 08:38:30', '2026-10-03 08:38:55'),
(59, 2, 'result_challenge', 'New result challenge', 'mahmudul hasan challenged Mathematics.', NULL, 2, NULL, NULL, 1, '2026-10-03 08:38:30', '2026-10-04 05:32:03'),
(60, 14, 'result_challenge', 'New result challenge', 'mahmudul hasan challenged Mathematics.', NULL, 2, NULL, NULL, 0, '2026-10-03 08:38:30', NULL),
(61, 1, 'result_challenge', 'New result challenge', 'bijoy das gupta challenged Computer Science.', NULL, 3, NULL, NULL, 1, '2026-10-03 10:34:24', '2026-10-03 10:35:06'),
(62, 2, 'result_challenge', 'New result challenge', 'bijoy das gupta challenged Computer Science.', NULL, 3, NULL, NULL, 1, '2026-10-03 10:34:24', '2026-10-04 05:32:01'),
(63, 14, 'result_challenge', 'New result challenge', 'bijoy das gupta challenged Computer Science.', NULL, 3, NULL, NULL, 0, '2026-10-03 10:34:24', NULL),
(64, 5, 'result_published', 'New result published', 'A new result has been published for farhana sadika. Open notifications to view the result overview.', NULL, NULL, 3, 1, 1, '2026-10-03 10:36:12', '2026-10-03 10:36:40'),
(65, 12, 'result_published', 'New result published', 'A new result has been published for farhana sadika. Open notifications to view the result overview.', NULL, NULL, 3, 1, 0, '2026-10-03 10:36:12', NULL),
(66, 1, 'signup_request', 'New sign-up request', 'shanto has requested a Student account.', 14, NULL, NULL, NULL, 1, '2026-10-04 06:22:38', '2026-10-04 06:23:09'),
(67, 2, 'signup_request', 'New sign-up request', 'shanto has requested a Student account.', 14, NULL, NULL, NULL, 0, '2026-10-04 06:22:38', NULL),
(68, 14, 'signup_request', 'New sign-up request', 'shanto has requested a Student account.', 14, NULL, NULL, NULL, 0, '2026-10-04 06:22:38', NULL),
(69, 1, 'result_challenge', 'New result challenge', 'bijoy das gupta challenged Mathematics.', NULL, 4, NULL, NULL, 1, '2026-10-04 07:50:01', '2026-10-04 07:50:37'),
(70, 2, 'result_challenge', 'New result challenge', 'bijoy das gupta challenged Mathematics.', NULL, 4, NULL, NULL, 0, '2026-10-04 07:50:01', NULL),
(71, 14, 'result_challenge', 'New result challenge', 'bijoy das gupta challenged Mathematics.', NULL, 4, NULL, NULL, 0, '2026-10-04 07:50:01', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `parents`
--

CREATE TABLE `parents` (
  `id` int(10) UNSIGNED NOT NULL,
  `parent_code` varchar(30) NOT NULL,
  `account_id` int(10) UNSIGNED NOT NULL,
  `name` varchar(120) NOT NULL,
  `email` varchar(190) NOT NULL,
  `phone` varchar(30) DEFAULT NULL,
  `section_name` varchar(30) DEFAULT NULL,
  `child_student_code` varchar(30) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `parents`
--

INSERT INTO `parents` (`id`, `parent_code`, `account_id`, `name`, `email`, `phone`, `section_name`, `child_student_code`, `created_at`) VALUES
(1, 'PAR-2026-010', 10, 'badal das', 'badal@g.com', '02942559283', '10-A', 'STU-2026-003', '2026-10-02 22:05:30'),
(2, 'PAR-2026-011', 11, 'akbar ali', 'akbar@g.com', '019942398235', '10-A', 'STU-2026-006', '2026-10-02 22:05:34'),
(3, 'PAR-2026-012', 12, 'anoar hossain', 'anoar@g.com', '019472944423', '10-A', 'STU-2026-005', '2026-10-02 22:05:38'),
(4, 'PAR-2026-013', 13, 'Sanjana Rahman', 'sanjana@g.com', '01932483223', '10-A', 'STU-2026-006', '2026-10-02 22:07:39'),
(5, 'PAR-DEMO-001', 19, 'Robert Johnson', 'parent@school.edu', '+8801700000000', '10-A', 'STU-2024-001', '2026-10-03 06:39:15'),
(6, 'PAR-DEMO-002', 20, 'Priya Patel', 'parent2@school.edu', '+8801700000000', '10-A', 'STU-2024-002', '2026-10-03 06:39:15');

-- --------------------------------------------------------

--
-- Table structure for table `parent_student`
--

CREATE TABLE `parent_student` (
  `id` int(10) UNSIGNED NOT NULL,
  `parent_id` int(10) UNSIGNED NOT NULL,
  `student_id` int(10) UNSIGNED NOT NULL,
  `relationship` varchar(50) NOT NULL DEFAULT 'Guardian',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `parent_student`
--

INSERT INTO `parent_student` (`id`, `parent_id`, `student_id`, `relationship`, `created_at`) VALUES
(1, 1, 1, 'Father', '2026-10-02 22:05:51'),
(2, 3, 3, 'Guardian', '2026-10-02 22:06:13'),
(3, 2, 2, 'Father', '2026-10-02 22:06:29'),
(4, 4, 4, 'Mother', '2026-10-02 22:07:50'),
(6, 6, 6, 'Mother', '2026-10-03 07:47:56'),
(9, 2, 4, 'Father', '2026-10-04 05:42:09');

-- --------------------------------------------------------

--
-- Table structure for table `result_challenge`
--

CREATE TABLE `result_challenge` (
  `id` int(10) UNSIGNED NOT NULL,
  `student_id` int(10) UNSIGNED NOT NULL,
  `course_id` int(10) UNSIGNED NOT NULL,
  `reason` varchar(1000) NOT NULL,
  `current_marks` decimal(5,2) NOT NULL,
  `resolved_marks` decimal(5,2) DEFAULT NULL,
  `status` enum('pending','resolved','rejected') NOT NULL DEFAULT 'pending',
  `submitted_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `reviewed_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `result_challenge`
--

INSERT INTO `result_challenge` (`id`, `student_id`, `course_id`, `reason`, `current_marks`, `resolved_marks`, `status`, `submitted_at`, `reviewed_at`) VALUES
(1, 2, 1, 'need marks', 67.00, 85.00, 'resolved', '2026-10-03 06:56:42', '2026-10-03 06:57:05'),
(2, 2, 1, 'need grace', 67.00, NULL, 'rejected', '2026-10-03 08:38:30', '2026-10-03 08:39:02'),
(3, 1, 3, 'dsd', 76.00, NULL, 'rejected', '2026-10-03 10:34:24', '2026-10-03 10:35:11'),
(4, 1, 1, 'fghfgh', 56.00, 87.00, 'resolved', '2026-10-04 07:50:01', '2026-10-04 07:50:45');

-- --------------------------------------------------------

--
-- Table structure for table `sections`
--

CREATE TABLE `sections` (
  `id` int(10) UNSIGNED NOT NULL,
  `section_name` varchar(30) NOT NULL,
  `class_name` varchar(50) NOT NULL,
  `academic_year` varchar(20) NOT NULL,
  `room_no` varchar(30) DEFAULT NULL,
  `capacity` smallint(5) UNSIGNED DEFAULT NULL,
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sections`
--

INSERT INTO `sections` (`id`, `section_name`, `class_name`, `academic_year`, `room_no`, `capacity`, `status`, `created_at`, `updated_at`) VALUES
(1, '10-A', 'Grade 10', '2026', NULL, NULL, 'active', '2026-10-02 21:42:36', '2026-10-02 21:42:36'),
(2, '10-B', 'Grade 10', '2026', NULL, NULL, 'active', '2026-10-02 21:42:36', '2026-10-02 21:42:36');

-- --------------------------------------------------------

--
-- Table structure for table `semesters`
--

CREATE TABLE `semesters` (
  `id` int(10) UNSIGNED NOT NULL,
  `semester_name` varchar(80) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `status` enum('active','closed') NOT NULL DEFAULT 'closed',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ;

--
-- Dumping data for table `semesters`
--

INSERT INTO `semesters` (`id`, `semester_name`, `start_date`, `end_date`, `status`, `created_at`, `updated_at`) VALUES
(1, 'Fall 2024', '2024-09-01', '2024-12-31', 'active', '2026-10-02 21:42:36', '2026-10-02 21:42:36'),
(2, 'Spring 2024', '2024-01-01', '2024-05-31', 'closed', '2026-10-02 21:42:36', '2026-10-02 21:42:36'),
(3, 'Fall 2023', '2023-09-01', '2023-12-31', 'closed', '2026-10-02 21:42:36', '2026-10-02 21:42:36');

-- --------------------------------------------------------

--
-- Table structure for table `signup_requests`
--

CREATE TABLE `signup_requests` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(120) NOT NULL,
  `email` varchar(190) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `phone` varchar(30) DEFAULT NULL,
  `section_name` varchar(30) DEFAULT NULL,
  `role` enum('student','parent','teacher') NOT NULL,
  `status` enum('pending','approved','rejected') NOT NULL DEFAULT 'pending',
  `submitted_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `reviewed_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `signup_requests`
--

INSERT INTO `signup_requests` (`id`, `name`, `email`, `password_hash`, `phone`, `section_name`, `role`, `status`, `submitted_at`, `reviewed_at`) VALUES
(1, 'bijoy das gupta', 'bijoy@g.com', '$2y$10$6vTcRBJ.u5yhPrc6OsZ1P.rjGPTcJT5iIIHotHKgMafS4Mqgm6iLi', '023972935723', '10-A', 'student', 'approved', '2026-10-02 21:48:43', '2026-10-02 21:49:05'),
(2, 'mahmudul hasan', 'mahmud@g.com', '$2y$10$T1S9ARxCUuzOQbIago5FV.6AijxNyj9nB6HG5j2V6UxPDZvPyom/S', '0839423423', '10-A', 'student', 'approved', '2026-10-02 21:50:32', '2026-10-02 21:50:53'),
(3, 'farhana sadika', 'sadika@g.com', '$2y$10$qgpayyb.FgxzyyN20NbDXuCd7fHR2A2ueOxHKN5rbrlvjoRcy0MFm', '09392395239', '10-A', 'student', 'approved', '2026-10-02 21:51:38', '2026-10-02 21:51:56'),
(4, 'asraful islam shanto', 'shanto203@gmail.com', '$2y$10$WGBmOy0wXeOPIQE4GKCb8.RXFP3QlsJ80.PzDWqeV3AWIs9XIdciu', '09395434578', '10-A', 'student', 'approved', '2026-10-02 21:53:34', '2026-10-02 21:54:19'),
(5, 'abcd', 'sdfg@h.com', '$2y$10$dxt6aRe/7c80jQDdwEtVA.liwj3xrzXRb1RxL5y9mEVdJmv9ArxHy', '03835283', '10-A', 'student', 'rejected', '2026-10-02 21:55:00', '2026-10-02 21:56:08'),
(6, 'dgdt', 'dfg34@gmail.com', '$2y$10$OGdWLfxbbrVP/tVHhmH9rObzpCzNUBG5r50cm3AttKrWIzrCoEYOu', '0932948248', '10-A', 'student', 'rejected', '2026-10-02 21:55:43', '2026-10-02 21:56:20'),
(7, 'adnan sir', 'adnan@g.com', '$2y$10$nY9P98GLNSFqg2U0466X7uL9vWY7SPZwntROpMbjLKiH509d6LjUC', '09295293593', '10-A', 'teacher', 'approved', '2026-10-02 21:57:52', '2026-10-02 22:00:05'),
(8, 'faruk sir', 'faruk@g.com', '$2y$10$BRF.O33NzGFEr.zdzundwecVHqXSsi5Je.b8Q.mcNa0MGvV7NsNMa', '01942923893', '10-A', 'teacher', 'approved', '2026-10-02 21:58:28', '2026-10-02 22:00:12'),
(9, 'koli mam', 'koli@g.com', '$2y$10$w32QxxcSQ4jt68IKltl2Lu4/fVfQVAGcPtPdcSh0yXDnAu6b2Jzz6', '019493482342', '10-A', 'teacher', 'approved', '2026-10-02 21:59:27', '2026-10-02 22:00:16'),
(10, 'badal das', 'badal@g.com', '$2y$10$r048lEUNQjeG9MQIwU0aUetl1gwYZrk4xXB54YF3q14turmSaLKMy', '02942559283', '10-A', 'parent', 'approved', '2026-10-02 22:02:23', '2026-10-02 22:05:30'),
(11, 'akbar ali', 'akbar@g.com', '$2y$10$K6kH1xi4E1Du1FqUiqZLROHc9DPgD4.WOx6cPSCR9lcRwe5c0UzQO', '019942398235', '10-A', 'parent', 'approved', '2026-10-02 22:04:12', '2026-10-02 22:05:34'),
(12, 'anoar hossain', 'anoar@g.com', '$2y$10$SURFiCmwQhHYmzNfKdaOI.aqMHvtBnypW7DweDEW6avuhEOBHEsAe', '019472944423', '10-A', 'parent', 'approved', '2026-10-02 22:05:12', '2026-10-02 22:05:38'),
(13, 'Sanjana Rahman', 'sanjana@g.com', '$2y$10$Xl8Kh5FuzqVz.yzNvCGHnOsbo90ghyOgCumoxwGMx0P1rP1wgMd1.', '01932483223', '10-A', 'parent', 'approved', '2026-10-02 22:07:09', '2026-10-02 22:07:39'),
(14, 'shanto', 'shanto@g.com', '$2y$10$QDaoKYxWYaEIEVWs.JsBzevwP2Jr87WGxUsAgywGDxQAW5RDOFaNS', '032483249239', '10-A', 'student', 'approved', '2026-10-04 06:22:38', '2026-10-04 06:23:12');

-- --------------------------------------------------------

--
-- Table structure for table `sms_logs`
--

CREATE TABLE `sms_logs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `recipient_account_id` int(10) UNSIGNED DEFAULT NULL,
  `student_id` int(10) UNSIGNED NOT NULL,
  `course_id` int(10) UNSIGNED NOT NULL,
  `phone` varchar(30) DEFAULT NULL,
  `message` varchar(500) NOT NULL,
  `status` enum('queued','sent','failed') NOT NULL DEFAULT 'queued',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sms_logs`
--

INSERT INTO `sms_logs` (`id`, `recipient_account_id`, `student_id`, `course_id`, `phone`, `message`, `status`, `created_at`) VALUES
(1, 10, 1, 3, '02942559283', 'A new result has been published for bijoy das gupta. Open notifications to view the result overview.', 'queued', '2026-10-03 06:24:51'),
(2, 11, 2, 1, '019942398235', 'A new result has been published for mahmudul hasan. Open notifications to view the result overview.', 'queued', '2026-10-03 06:36:11'),
(3, 10, 1, 1, '02942559283', 'A new result has been published for bijoy das gupta. Open notifications to view the result overview.', 'queued', '2026-10-03 07:00:40'),
(4, 10, 1, 5, '02942559283', 'A new result has been published for bijoy das gupta. Open notifications to view the result overview.', 'queued', '2026-10-03 07:05:11'),
(5, 10, 1, 6, '02942559283', 'A new result has been published for bijoy das gupta. Open notifications to view the result overview.', 'queued', '2026-10-03 07:06:40'),
(6, 11, 2, 5, '019942398235', 'A new result has been published for mahmudul hasan. Open notifications to view the result overview.', 'queued', '2026-10-03 08:31:41'),
(7, 11, 2, 6, '019942398235', 'A new result has been published for mahmudul hasan. Open notifications to view the result overview.', 'queued', '2026-10-03 08:32:16'),
(8, 11, 2, 2, '019942398235', 'A new result has been published for mahmudul hasan. Open notifications to view the result overview.', 'queued', '2026-10-03 08:37:11'),
(9, 12, 3, 1, '019472944423', 'A new result has been published for farhana sadika. Open notifications to view the result overview.', 'queued', '2026-10-03 10:36:12');

-- --------------------------------------------------------

--
-- Table structure for table `srms_state`
--

CREATE TABLE `srms_state` (
  `id` tinyint(3) UNSIGNED NOT NULL,
  `state_json` longtext NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ;

--
-- Dumping data for table `srms_state`
--

INSERT INTO `srms_state` (`id`, `state_json`, `updated_at`) VALUES
(1, '{\"semester\":\"Fall 2024\",\"sections\":[\"10-A\",\"10-B\"],\"semesters\":[{\"id\":1,\"name\":\"Fall 2024\",\"startDate\":\"2024-09-01\",\"endDate\":\"2024-12-31\",\"active\":true},{\"id\":2,\"name\":\"Spring 2024\",\"startDate\":\"2024-01-01\",\"endDate\":\"2024-05-31\",\"active\":false},{\"id\":3,\"name\":\"Fall 2023\",\"startDate\":\"2023-09-01\",\"endDate\":\"2023-12-31\",\"active\":false}],\"users\":[{\"id\":1,\"name\":\"Michael Torres\",\"email\":\"admin@school.edu\",\"password\":\"demo123\",\"role\":\"admin\"},{\"id\":2,\"name\":\"David Chen\",\"email\":\"teacher@school.edu\",\"password\":\"demo123\",\"role\":\"teacher\"},{\"id\":3,\"name\":\"Sarah Kim\",\"email\":\"teacher2@school.edu\",\"password\":\"demo123\",\"role\":\"teacher\"},{\"id\":4,\"name\":\"Alex Johnson\",\"email\":\"student@school.edu\",\"password\":\"demo123\",\"role\":\"student\"},{\"id\":5,\"name\":\"Maya Patel\",\"email\":\"student2@school.edu\",\"password\":\"demo123\",\"role\":\"student\"},{\"id\":6,\"name\":\"Robert Johnson\",\"email\":\"parent@school.edu\",\"password\":\"demo123\",\"role\":\"parent\"},{\"id\":7,\"name\":\"Priya Patel\",\"email\":\"parent2@school.edu\",\"password\":\"demo123\",\"role\":\"parent\"},{\"id\":8,\"name\":\"Bijoy Das Gupta\",\"email\":\"bijoydasgupta595@gmail.com\",\"password\":\"12345678\",\"role\":\"student\"},{\"id\":9,\"name\":\"ekbal1\",\"email\":\"ekbal202@gmail.com\",\"password\":\"12345678\",\"role\":\"teacher\"},{\"id\":10,\"name\":\"Parent\",\"email\":\"parent202@gmail.com\",\"password\":\"12345678\",\"role\":\"parent\"},{\"id\":11,\"name\":\"asdf\",\"email\":\"asdf200@gmail.com\",\"password\":\"12345678\",\"role\":\"student\"},{\"id\":12,\"name\":\"sayem sir\",\"email\":\"sayem332@gmail.com\",\"password\":\"12345678\",\"role\":\"admin\"},{\"id\":13,\"name\":\"shanto\",\"email\":\"shanto202@gmail.com\",\"password\":\"12345678\",\"role\":\"student\"},{\"id\":14,\"name\":\"sayem sir\",\"email\":\"sayem200@gmail.com\",\"password\":\"12345678\",\"role\":\"teacher\"},{\"id\":15,\"name\":\"rahul\",\"email\":\"rahul233@gmail.com\",\"password\":\"12345678\",\"role\":\"student\"},{\"id\":16,\"name\":\"Daniel Miller\",\"email\":\"daniel@example.com\",\"password\":\"danielpass\",\"role\":\"student\"},{\"id\":17,\"name\":\"hasan\",\"email\":\"hasan123@gmail.com\",\"password\":\"12345678\",\"role\":\"teacher\"},{\"id\":18,\"name\":\"nurul huda sir\",\"email\":\"nurulhuda45@gmail.com\",\"password\":\"12345678\",\"role\":\"admin\"},{\"id\":19,\"name\":\"huda sir\",\"email\":\"huda@g.com\",\"password\":\"12345678\",\"role\":\"admin\"},{\"id\":20,\"name\":\"mamun sir\",\"email\":\"mamun@g.com\",\"password\":\"12345678\",\"role\":\"admin\"}],\"teachers\":[{\"id\":1,\"name\":\"David Chen\",\"subject\":\"Science & Mathematics\",\"email\":\"teacher@school.edu\"},{\"id\":2,\"name\":\"Sarah Kim\",\"subject\":\"English & Computer Science\",\"email\":\"teacher2@school.edu\"},{\"id\":3,\"name\":\"ekbal1\",\"subject\":\"Not assigned yet\",\"email\":\"ekbal202@gmail.com\"},{\"id\":4,\"name\":\"sayem sir\",\"subject\":\"Not assigned yet\",\"email\":\"sayem200@gmail.com\"},{\"id\":5,\"name\":\"hasan\",\"subject\":\"Not assigned yet\",\"email\":\"hasan123@gmail.com\"},{\"id\":6,\"name\":\"adnan sir\",\"subject\":\"Mathematics, Physics\",\"email\":\"adnan@g.com\"},{\"id\":7,\"name\":\"faruk sir\",\"subject\":\"Biology, Chemistry\",\"email\":\"faruk@g.com\"},{\"id\":8,\"name\":\"koli mam\",\"subject\":\"Computer Science, English\",\"email\":\"koli@g.com\"}],\"students\":[{\"id\":\"STU-2024-001\",\"name\":\"Alex Johnson\",\"email\":\"student@school.edu\",\"phone\":\"+8801700000000\",\"section\":\"10-A\",\"parentId\":null},{\"id\":\"STU-2024-002\",\"name\":\"Maya Patel\",\"email\":\"student2@school.edu\",\"phone\":\"+8801700000000\",\"section\":\"10-A\",\"parentId\":null},{\"id\":\"STU-2026-008\",\"name\":\"Bijoy Das Gupta\",\"email\":\"bijoydasgupta595@gmail.com\",\"phone\":\"+8801685253263\",\"section\":\"10-A\",\"parentId\":3},{\"id\":\"STU-2026-011\",\"name\":\"asdf\",\"email\":\"asdf200@gmail.com\",\"phone\":\"0126567789\",\"section\":\"10-A\",\"parentId\":null},{\"id\":\"STU-2026-013\",\"name\":\"shanto\",\"email\":\"shanto202@gmail.com\",\"phone\":\"0123456899\",\"section\":\"10-A\",\"parentId\":null},{\"id\":\"STU-2026-015\",\"name\":\"rahul\",\"email\":\"rahul233@gmail.com\",\"phone\":\"01329289329\",\"section\":\"10-A\",\"parentId\":null},{\"id\":\"STU-2026-016\",\"name\":\"Daniel Miller\",\"email\":\"daniel@example.com\",\"phone\":\"+8801700000000\",\"section\":\"10-B\",\"parentId\":null},{\"id\":\"STU-2026-001\",\"name\":\"asraful\",\"email\":\"aashanto202@gmai.com\",\"phone\":\"01768859202\",\"section\":\"10-B\",\"parentId\":null},{\"id\":\"STU-2026-003\",\"name\":\"bijoy das gupta\",\"email\":\"bijoy@g.com\",\"phone\":\"023972935723\",\"section\":\"10-A\",\"parentId\":null},{\"id\":\"STU-2026-024\",\"name\":\"fahad\",\"email\":\"fahad34@yahoo.com\",\"phone\":\"0392994927\",\"section\":\"10-B\",\"parentId\":null},{\"id\":\"STU-2026-027\",\"name\":\"rakib\",\"email\":\"r@g.com\",\"phone\":\"123456789\",\"section\":\"10-A\",\"parentId\":null},{\"id\":\"STU-2026-004\",\"name\":\"mahmudul hasan\",\"email\":\"mahmud@g.com\",\"phone\":\"0839423423\",\"section\":\"10-A\",\"parentId\":null},{\"id\":\"STU-2026-005\",\"name\":\"farhana sadika\",\"email\":\"sadika@g.com\",\"phone\":\"09392395239\",\"section\":\"10-A\",\"parentId\":null},{\"id\":\"STU-2026-006\",\"name\":\"asraful islam shanto\",\"email\":\"shanto203@gmail.com\",\"phone\":\"09395434578\",\"section\":\"10-A\",\"parentId\":null},{\"id\":\"STU-2026-021\",\"name\":\"shanto\",\"email\":\"shanto@g.com\",\"phone\":\"032483249239\",\"section\":\"10-A\",\"parentId\":null}],\"parents\":[{\"id\":5,\"name\":\"Robert Johnson\",\"email\":\"parent@school.edu\",\"phone\":\"+8801700000000\",\"childId\":\"STU-2024-001\",\"section\":\"10-A\"},{\"id\":6,\"name\":\"Priya Patel\",\"email\":\"parent2@school.edu\",\"phone\":\"+8801700000000\",\"childId\":\"STU-2024-002\",\"section\":\"10-A\"},{\"id\":3,\"name\":\"Parent\",\"email\":\"parent202@gmail.com\",\"phone\":\"01274648393\",\"childId\":\"STU-2026-008\",\"section\":\"10-A\"},{\"id\":1,\"name\":\"badal das\",\"email\":\"badal@g.com\",\"phone\":\"02942559283\",\"section\":\"10-A\",\"childId\":\"STU-2026-003\"},{\"id\":2,\"name\":\"akbar ali\",\"email\":\"akbar@g.com\",\"phone\":\"019942398235\",\"section\":\"10-A\",\"childId\":\"STU-2026-006\"},{\"id\":3,\"name\":\"anoar hossain\",\"email\":\"anoar@g.com\",\"phone\":\"019472944423\",\"section\":\"10-A\",\"childId\":\"STU-2026-005\"},{\"id\":4,\"name\":\"Sanjana Rahman\",\"email\":\"sanjana@g.com\",\"phone\":\"01932483223\",\"section\":\"10-A\",\"childId\":\"STU-2026-006\"}],\"courses\":[{\"id\":1,\"name\":\"Mathematics\",\"code\":\"MATH 101\",\"credits\":4,\"teacherId\":6},{\"id\":2,\"name\":\"Physics\",\"code\":\"PHYS 101\",\"credits\":3,\"teacherId\":6},{\"id\":3,\"name\":\"Computer Science\",\"code\":\"CS 101\",\"credits\":4,\"teacherId\":8},{\"id\":4,\"name\":\"English\",\"code\":\"ENG 101\",\"credits\":3,\"teacherId\":8},{\"id\":5,\"name\":\"Chemistry\",\"code\":\"CHEM 101\",\"credits\":3,\"teacherId\":7},{\"id\":6,\"name\":\"Biology\",\"code\":\"BIO 101\",\"credits\":3,\"teacherId\":7},{\"id\":7,\"name\":\"bangla 1st paper\",\"code\":\"bangla 101\",\"credits\":3,\"teacherId\":8}],\"grades\":[{\"id\":1,\"studentId\":\"STU-2024-001\",\"courseId\":1,\"marks\":88,\"grade\":\"A-\",\"gpa\":3.7,\"comment\":\"Great start to the semester.\",\"published\":true,\"teacherId\":1},{\"id\":2,\"studentId\":\"STU-2024-001\",\"courseId\":2,\"marks\":81,\"grade\":\"B+\",\"gpa\":3.3,\"comment\":\"Good work in the optics chapter.\",\"published\":true,\"teacherId\":1},{\"id\":3,\"studentId\":\"STU-2024-001\",\"courseId\":4,\"marks\":86,\"grade\":\"A-\",\"gpa\":3.7,\"comment\":\"Strong mid-term essay.\",\"published\":true,\"teacherId\":2},{\"id\":4,\"studentId\":\"STU-2024-002\",\"courseId\":1,\"marks\":92,\"grade\":\"A\",\"gpa\":4,\"comment\":\"Excellent problem solving.\",\"published\":true,\"teacherId\":1},{\"id\":5,\"studentId\":\"STU-2026-008\",\"courseId\":1,\"marks\":95,\"grade\":\"A\",\"gpa\":4,\"comment\":\"Outstanding\",\"published\":true,\"teacherId\":1},{\"id\":6,\"studentId\":\"STU-2026-013\",\"courseId\":1,\"marks\":76,\"grade\":\"B\",\"gpa\":3,\"comment\":\"good\",\"published\":true,\"teacherId\":1},{\"id\":7,\"studentId\":\"STU-2024-002\",\"courseId\":2,\"marks\":89,\"grade\":\"A-\",\"gpa\":3.7,\"comment\":\"great!!\",\"published\":true,\"teacherId\":1},{\"id\":8,\"studentId\":\"STU-2026-027\",\"courseId\":2,\"marks\":95,\"grade\":\"A\",\"gpa\":4,\"comment\":\"wonderful\",\"published\":true,\"teacherId\":1},{\"id\":9,\"studentId\":\"STU-2026-008\",\"courseId\":2,\"marks\":67,\"grade\":\"C+\",\"gpa\":2.3,\"comment\":\"need good marks \",\"published\":true,\"teacherId\":1},{\"id\":10,\"studentId\":\"STU-2026-011\",\"courseId\":2,\"marks\":45,\"grade\":\"F\",\"gpa\":0,\"comment\":\"so bad\",\"published\":false,\"teacherId\":1},{\"id\":11,\"studentId\":\"STU-2026-024\",\"courseId\":2,\"marks\":75,\"grade\":\"B\",\"gpa\":3,\"comment\":\"\",\"published\":true,\"teacherId\":1},{\"id\":12,\"studentId\":\"STU-2026-003\",\"courseId\":3,\"marks\":76,\"grade\":\"B\",\"gpa\":3,\"comment\":\"good\",\"published\":true,\"teacherId\":8},{\"id\":13,\"studentId\":\"STU-2026-004\",\"courseId\":1,\"marks\":67,\"grade\":\"C+\",\"gpa\":2.3,\"comment\":\"nice\",\"published\":true,\"teacherId\":6},{\"id\":14,\"studentId\":\"STU-2026-003\",\"courseId\":1,\"marks\":56,\"grade\":\"C-\",\"gpa\":1.7,\"comment\":\"wow\",\"published\":true,\"teacherId\":6},{\"id\":15,\"studentId\":\"STU-2026-003\",\"courseId\":5,\"marks\":56,\"grade\":\"C-\",\"gpa\":1.7,\"comment\":\"how\",\"published\":true,\"teacherId\":7},{\"id\":16,\"studentId\":\"STU-2026-003\",\"courseId\":6,\"marks\":78,\"grade\":\"B\",\"gpa\":3,\"comment\":\"sei\",\"published\":true,\"teacherId\":7},{\"id\":17,\"studentId\":\"STU-2026-004\",\"courseId\":5,\"marks\":78,\"grade\":\"B\",\"gpa\":3,\"comment\":\"good\",\"published\":true,\"teacherId\":7},{\"id\":18,\"studentId\":\"STU-2026-004\",\"courseId\":6,\"marks\":65,\"grade\":\"C+\",\"gpa\":2.3,\"comment\":\"why\",\"published\":true,\"teacherId\":7},{\"id\":19,\"studentId\":\"STU-2026-004\",\"courseId\":2,\"marks\":90,\"grade\":\"A\",\"gpa\":4,\"comment\":\"wow\",\"published\":true,\"teacherId\":6},{\"id\":20,\"studentId\":\"STU-2026-005\",\"courseId\":1,\"marks\":67,\"grade\":\"C+\",\"gpa\":2.3,\"comment\":\"wow\",\"published\":true,\"teacherId\":6}],\"attendance\":[{\"studentId\":\"STU-2024-001\",\"courseId\":1,\"present\":22,\"total\":24},{\"studentId\":\"STU-2024-001\",\"courseId\":2,\"present\":20,\"total\":22},{\"studentId\":\"STU-2024-001\",\"courseId\":4,\"present\":23,\"total\":24},{\"studentId\":\"STU-2024-002\",\"courseId\":1,\"present\":24,\"total\":24},{\"studentId\":\"STU-2026-008\",\"courseId\":2,\"total\":24,\"present\":24},{\"studentId\":\"STU-2026-024\",\"courseId\":2,\"total\":24,\"present\":22},{\"studentId\":\"STU-2026-003\",\"courseId\":3,\"total\":24,\"present\":22},{\"studentId\":\"STU-2026-004\",\"courseId\":1,\"total\":24,\"present\":22},{\"studentId\":\"STU-2026-003\",\"courseId\":1,\"total\":24,\"present\":23},{\"studentId\":\"STU-2026-003\",\"courseId\":5,\"total\":24,\"present\":20},{\"studentId\":\"STU-2026-003\",\"courseId\":6,\"total\":24,\"present\":19},{\"studentId\":\"STU-2026-004\",\"courseId\":5,\"total\":24,\"present\":18},{\"studentId\":\"STU-2026-004\",\"courseId\":6,\"total\":24,\"present\":20},{\"studentId\":\"STU-2026-004\",\"courseId\":2,\"total\":24,\"present\":18},{\"studentId\":\"STU-2026-005\",\"courseId\":1,\"total\":24,\"present\":18}],\"challenges\":[{\"id\":7,\"studentId\":\"STU-2024-001\",\"courseId\":1,\"reason\":\"abcd\",\"status\":\"Pending\",\"date\":\"2026-09-27 16:01\"},{\"id\":6,\"studentId\":\"STU-2024-001\",\"courseId\":1,\"reason\":\"abcd\",\"status\":\"Pending\",\"date\":\"2026-09-27 15:58\"},{\"id\":5,\"studentId\":\"STU-2024-001\",\"courseId\":1,\"reason\":\"asd\",\"status\":\"Pending\",\"date\":\"2026-09-27 11:24\"},{\"id\":4,\"studentId\":\"STU-2024-001\",\"courseId\":1,\"reason\":\"asda\",\"status\":\"Pending\",\"date\":\"2026-09-27 11:17\"},{\"id\":3,\"studentId\":\"STU-2024-001\",\"courseId\":1,\"reason\":\"need marks\",\"status\":\"Pending\",\"date\":\"2026-09-27 11:16\"},{\"id\":2,\"studentId\":\"STU-2024-001\",\"courseId\":2,\"reason\":\"need more marks\",\"status\":\"Pending\",\"date\":\"2026-09-27 11:09\"},{\"id\":1,\"studentId\":\"STU-2026-013\",\"courseId\":1,\"reason\":\"mark issue\",\"status\":\"Resolved\",\"date\":\"2026-09-13 13:39\"}],\"signupRequests\":[{\"id\":24,\"databaseRequestId\":14,\"name\":\"shanto\",\"email\":\"shanto@g.com\",\"password\":\"12345678\",\"phone\":\"032483249239\",\"role\":\"Student\",\"section\":\"10-A\",\"status\":\"Pending\",\"date\":\"2026-10-04 12:22\"},{\"id\":23,\"databaseRequestId\":13,\"name\":\"Sanjana Rahman\",\"email\":\"sanjana@g.com\",\"password\":\"12345678\",\"phone\":\"01932483223\",\"role\":\"Parent\",\"section\":\"10-A\",\"status\":\"Pending\",\"date\":\"2026-10-03 04:07\"},{\"id\":22,\"databaseRequestId\":12,\"name\":\"anoar hossain\",\"email\":\"anoar@g.com\",\"password\":\"12345678\",\"phone\":\"019472944423\",\"role\":\"Parent\",\"section\":\"10-A\",\"status\":\"Pending\",\"date\":\"2026-10-03 04:05\"},{\"id\":21,\"databaseRequestId\":11,\"name\":\"akbar ali\",\"email\":\"akbar@g.com\",\"password\":\"12345678\",\"phone\":\"019942398235\",\"role\":\"Parent\",\"section\":\"10-A\",\"status\":\"Pending\",\"date\":\"2026-10-03 04:04\"},{\"id\":20,\"databaseRequestId\":10,\"name\":\"badal das\",\"email\":\"badal@g.com\",\"password\":\"12345678\",\"phone\":\"02942559283\",\"role\":\"Parent\",\"section\":\"10-A\",\"status\":\"Pending\",\"date\":\"2026-10-03 04:02\"},{\"id\":19,\"databaseRequestId\":9,\"name\":\"koli mam\",\"email\":\"koli@g.com\",\"password\":\"12345678\",\"phone\":\"019493482342\",\"role\":\"Teacher\",\"section\":\"10-A\",\"status\":\"Pending\",\"date\":\"2026-10-03 03:59\"},{\"id\":18,\"databaseRequestId\":8,\"name\":\"faruk sir\",\"email\":\"faruk@g.com\",\"password\":\"12345678\",\"phone\":\"01942923893\",\"role\":\"Teacher\",\"section\":\"10-A\",\"status\":\"Pending\",\"date\":\"2026-10-03 03:58\"},{\"id\":17,\"databaseRequestId\":7,\"name\":\"adnan sir\",\"email\":\"adnan@g.com\",\"password\":\"12345678\",\"phone\":\"09295293593\",\"role\":\"Teacher\",\"section\":\"10-A\",\"status\":\"Pending\",\"date\":\"2026-10-03 03:57\"},{\"id\":16,\"databaseRequestId\":6,\"name\":\"dgdt\",\"email\":\"dfg34@gmail.com\",\"password\":\"12345678\",\"phone\":\"0932948248\",\"role\":\"Student\",\"section\":\"10-A\",\"status\":\"Pending\",\"date\":\"2026-10-03 03:55\"},{\"id\":15,\"databaseRequestId\":5,\"name\":\"abcd\",\"email\":\"sdfg@h.com\",\"password\":\"12345678\",\"phone\":\"03835283\",\"role\":\"Student\",\"section\":\"10-A\",\"status\":\"Pending\",\"date\":\"2026-10-03 03:55\"},{\"id\":14,\"databaseRequestId\":4,\"name\":\"asraful islam shanto\",\"email\":\"shanto203@gmail.com\",\"password\":\"12345678\",\"phone\":\"09395434578\",\"role\":\"Student\",\"section\":\"10-A\",\"status\":\"Pending\",\"date\":\"2026-10-03 03:53\"},{\"id\":13,\"databaseRequestId\":3,\"name\":\"farhana sadika\",\"email\":\"sadika@g.com\",\"password\":\"12345678\",\"phone\":\"09392395239\",\"role\":\"Student\",\"section\":\"10-A\",\"status\":\"Pending\",\"date\":\"2026-10-03 03:51\"},{\"id\":12,\"databaseRequestId\":2,\"name\":\"mahmudul hasan\",\"email\":\"mahmud@g.com\",\"password\":\"12345678\",\"phone\":\"0839423423\",\"role\":\"Student\",\"section\":\"10-A\",\"status\":\"Pending\",\"date\":\"2026-10-03 03:50\"},{\"id\":11,\"databaseRequestId\":1,\"name\":\"bijoy das gupta\",\"email\":\"bijoy@g.com\",\"password\":\"12345678\",\"phone\":\"023972935723\",\"role\":\"Student\",\"section\":\"10-A\",\"status\":\"Pending\",\"date\":\"2026-10-03 03:48\"},{\"id\":10,\"databaseRequestId\":6,\"name\":\"rakib\",\"email\":\"r@g.com\",\"password\":\"12345678\",\"phone\":\"123456789\",\"role\":\"Student\",\"section\":\"10-A\",\"status\":\"Pending\",\"date\":\"2026-09-26 16:24\"},{\"id\":9,\"databaseRequestId\":5,\"name\":\"naser\",\"email\":\"naser783@yahoo.com\",\"password\":\"12345678\",\"phone\":\"0292923235\",\"role\":\"Parent\",\"section\":\"10-B\",\"status\":\"Pending\",\"date\":\"2026-09-22 02:37\"},{\"id\":8,\"databaseRequestId\":4,\"name\":\"fahad\",\"email\":\"fahad34@yahoo.com\",\"password\":\"12345678\",\"phone\":\"0392994927\",\"role\":\"Student\",\"section\":\"10-B\",\"status\":\"Pending\",\"date\":\"2026-09-22 01:30\"},{\"id\":7,\"databaseRequestId\":3,\"name\":\"hacker\",\"email\":\"hacker567@gmail.com\",\"password\":\"12345678\",\"phone\":\"0139248293\",\"role\":\"Parent\",\"section\":\"10-A\",\"status\":\"Rejected\",\"date\":\"2026-09-19 18:55\"},{\"id\":6,\"databaseRequestId\":2,\"name\":\"bean tailor\",\"email\":\"beantailor456@gmail.com\",\"password\":\"12345678\",\"phone\":\"01249832934\",\"role\":\"Student\",\"section\":\"10-B\",\"status\":\"Rejected\",\"date\":\"2026-09-17 17:13\"},{\"id\":5,\"databaseRequestId\":1,\"name\":\"hasan\",\"email\":\"hasan123@gmail.com\",\"password\":\"12345678\",\"phone\":\"0183292392\",\"role\":\"Teacher\",\"section\":\"10-B\",\"status\":\"Approved\",\"date\":\"2026-09-17 17:03\"},{\"id\":4,\"databaseRequestId\":null,\"name\":\"joy\",\"email\":\"joy123@gmail.com\",\"password\":\"12345678\",\"phone\":\"+8801685253263\",\"role\":\"Student\",\"section\":\"10-B\",\"status\":\"Rejected\",\"date\":\"2026-09-17 14:48\"},{\"id\":3,\"databaseRequestId\":null,\"name\":\"bean\",\"email\":\"bean120@gmail.com\",\"password\":\"12345678\",\"phone\":\"+8801685253263\",\"role\":\"Student\",\"section\":\"10-A\",\"status\":\"Rejected\",\"date\":\"2026-09-17 14:21\"},{\"id\":2,\"name\":\"bean\",\"email\":\"bean120@gmail.com\",\"password\":\"12345678\",\"phone\":\"01329289329\",\"role\":\"Student\",\"section\":\"10-A\",\"status\":\"Rejected\",\"date\":\"2026-09-17 01:53\"},{\"id\":1,\"name\":\"Daniel Miller\",\"email\":\"daniel@example.com\",\"password\":\"danielpass\",\"phone\":\"+8801700000000\",\"role\":\"Student\",\"section\":\"10-B\",\"status\":\"Approved\",\"date\":\"2024-11-18 10:15\"}],\"sms\":[{\"id\":4,\"parentId\":3,\"studentId\":\"STU-2026-008\",\"phone\":\"01274648393\",\"message\":\"A new result has been published for Bijoy Das Gupta. Please log in to see the marks.\",\"status\":\"SENT\",\"time\":\"2026-10-02 00:45\"},{\"id\":3,\"parentId\":3,\"studentId\":\"STU-2026-008\",\"phone\":\"01274648393\",\"message\":\"A new result has been published for Bijoy Das Gupta. Please log in to see the marks.\",\"status\":\"SENT\",\"time\":\"2026-09-29 02:57\"},{\"id\":2,\"parentId\":1,\"studentId\":\"STU-2024-001\",\"phone\":\"+8801811000001\",\"message\":\"A new result has been published for Alex Johnson. Please log in to see the marks.\",\"status\":\"SENT\",\"time\":\"2026-09-16 22:43\"},{\"id\":1,\"parentId\":1,\"studentId\":\"STU-2024-001\",\"phone\":\"+8801811000001\",\"message\":\"A new result has been published for Alex Johnson. Please log in to see the marks.\",\"status\":\"SENT\",\"time\":\"2024-11-17 16:05\"}],\"notifications\":[{\"id\":4,\"parentId\":3,\"title\":\"New result published\",\"message\":\"A new result has been published for Bijoy Das Gupta. Please log in to see the marks.\",\"read\":false,\"time\":\"2026-10-02 00:45\"},{\"id\":3,\"parentId\":3,\"title\":\"New result published\",\"message\":\"A new result has been published for Bijoy Das Gupta. Please log in to see the marks.\",\"read\":false,\"time\":\"2026-09-29 02:57\"},{\"id\":2,\"parentId\":1,\"title\":\"New result published\",\"message\":\"A new result has been published for Alex Johnson. Please log in to see the marks.\",\"read\":false,\"time\":\"2026-09-16 22:43\"},{\"id\":1,\"parentId\":1,\"title\":\"New result published\",\"message\":\"A new result has been published for Alex Johnson. Please log in to see the marks.\",\"read\":false,\"time\":\"2024-11-17 16:05\"}],\"auditLog\":[{\"auditKey\":\"grade-audit-1791023771848-c0morjcltgn\",\"time\":\"2026-10-03 16:36\",\"who\":\"adnan sir\",\"actorEmail\":\"adnan@g.com\",\"action\":\"Published result\",\"student\":\"STU-2026-005\",\"change\":\"67 (C+) → 67 (C+)\",\"courseId\":1},{\"auditKey\":\"grade-audit-1791023766642-6kvxgctgcuw\",\"time\":\"2026-10-03 16:36\",\"who\":\"adnan sir\",\"actorEmail\":\"adnan@g.com\",\"action\":\"Saved mark\",\"student\":\"STU-2026-005\",\"change\":\"new → 67 (C+)\",\"courseId\":1},{\"auditKey\":\"grade-audit-1791016650729-2lqstpnypjb\",\"time\":\"2026-10-03 14:37\",\"who\":\"adnan sir\",\"actorEmail\":\"adnan@g.com\",\"action\":\"Updated mark\",\"student\":\"STU-2026-004\",\"change\":\"89 (A-) → 90 (A)\",\"courseId\":2},{\"auditKey\":\"grade-audit-1791016630912-wmanpfx2nr7\",\"time\":\"2026-10-03 14:37\",\"who\":\"adnan sir\",\"actorEmail\":\"adnan@g.com\",\"action\":\"Published result\",\"student\":\"STU-2026-004\",\"change\":\"89 (A-) → 89 (A-)\",\"courseId\":2},{\"auditKey\":\"grade-audit-1791016621833-3ofu9wjn8yb\",\"time\":\"2026-10-03 14:37\",\"who\":\"adnan sir\",\"actorEmail\":\"adnan@g.com\",\"action\":\"Saved mark\",\"student\":\"STU-2026-004\",\"change\":\"new → 89 (A-)\",\"courseId\":2},{\"auditKey\":\"grade-audit-1791016335953-15rcscsomwn\",\"time\":\"2026-10-03 14:32\",\"who\":\"faruk sir\",\"actorEmail\":\"faruk@g.com\",\"action\":\"Published result\",\"student\":\"STU-2026-004\",\"change\":\"65 (C+) → 65 (C+)\",\"courseId\":6},{\"auditKey\":\"grade-audit-1791016330313-90yl5xcmmsm\",\"time\":\"2026-10-03 14:32\",\"who\":\"faruk sir\",\"actorEmail\":\"faruk@g.com\",\"action\":\"Saved mark\",\"student\":\"STU-2026-004\",\"change\":\"new → 65 (C+)\",\"courseId\":6},{\"auditKey\":\"grade-audit-1791016301264-v6zysflzs5a\",\"time\":\"2026-10-03 14:31\",\"who\":\"faruk sir\",\"actorEmail\":\"faruk@g.com\",\"action\":\"Published result\",\"student\":\"STU-2026-004\",\"change\":\"78 (B) → 78 (B)\",\"courseId\":5},{\"auditKey\":\"grade-audit-1791016296600-l73f16z304p\",\"time\":\"2026-10-03 14:31\",\"who\":\"faruk sir\",\"actorEmail\":\"faruk@g.com\",\"action\":\"Saved mark\",\"student\":\"STU-2026-004\",\"change\":\"new → 78 (B)\",\"courseId\":5},{\"auditKey\":\"grade-audit-1791011200433-0i3xz4rl11k\",\"time\":\"2026-10-03 13:06\",\"who\":\"faruk sir\",\"actorEmail\":\"faruk@g.com\",\"action\":\"Published result\",\"student\":\"STU-2026-003\",\"change\":\"78 (B) → 78 (B)\",\"courseId\":6},{\"auditKey\":\"grade-audit-1791011199682-upfook7rfyi\",\"time\":\"2026-10-03 13:06\",\"who\":\"faruk sir\",\"actorEmail\":\"faruk@g.com\",\"action\":\"Saved mark\",\"student\":\"STU-2026-003\",\"change\":\"new → 78 (B)\",\"courseId\":6},{\"auditKey\":\"grade-audit-1791011111848-d1ae4quxi48\",\"time\":\"2026-10-03 13:05\",\"who\":\"faruk sir\",\"actorEmail\":\"faruk@g.com\",\"action\":\"Published result\",\"student\":\"STU-2026-003\",\"change\":\"56 (C-) → 56 (C-)\",\"courseId\":5},{\"auditKey\":\"grade-audit-1791011106135-iq6mvej2dw\",\"time\":\"2026-10-03 13:05\",\"who\":\"faruk sir\",\"actorEmail\":\"faruk@g.com\",\"action\":\"Saved mark\",\"student\":\"STU-2026-003\",\"change\":\"new → 56 (C-)\",\"courseId\":5},{\"auditKey\":\"grade-audit-1791010840713-m3nd20ztxcq\",\"time\":\"2026-10-03 13:00\",\"who\":\"adnan sir\",\"actorEmail\":\"adnan@g.com\",\"action\":\"Published result\",\"student\":\"STU-2026-003\",\"change\":\"56 (C-) → 56 (C-)\",\"courseId\":1},{\"auditKey\":\"grade-audit-1791010839217-vnm5r71fhoe\",\"time\":\"2026-10-03 13:00\",\"who\":\"adnan sir\",\"actorEmail\":\"adnan@g.com\",\"action\":\"Saved mark\",\"student\":\"STU-2026-003\",\"change\":\"new → 56 (C-)\",\"courseId\":1},{\"auditKey\":\"grade-audit-1791009371196-eczbc9oajae\",\"time\":\"2026-10-03 12:36\",\"who\":\"adnan sir\",\"actorEmail\":\"adnan@g.com\",\"action\":\"Published result\",\"student\":\"STU-2026-004\",\"change\":\"67 (C+) → 67 (C+)\",\"courseId\":1},{\"auditKey\":\"grade-audit-1791009369859-yqw03jnw85o\",\"time\":\"2026-10-03 12:36\",\"who\":\"adnan sir\",\"actorEmail\":\"adnan@g.com\",\"action\":\"Saved mark\",\"student\":\"STU-2026-004\",\"change\":\"new → 67 (C+)\",\"courseId\":1},{\"auditKey\":\"grade-audit-1791008691628-wn3jbddfe3\",\"time\":\"2026-10-03 12:24\",\"who\":\"koli mam\",\"actorEmail\":\"koli@g.com\",\"action\":\"Published result\",\"student\":\"STU-2026-003\",\"change\":\"76 (B) → 76 (B)\",\"courseId\":3},{\"auditKey\":\"grade-audit-1791008689175-1z0aj7k68gq\",\"time\":\"2026-10-03 12:24\",\"who\":\"koli mam\",\"actorEmail\":\"koli@g.com\",\"action\":\"Saved mark\",\"student\":\"STU-2026-003\",\"change\":\"new → 76 (B)\",\"courseId\":3},{\"auditKey\":\"grade-audit-1790884894992-a2q5j05kyl4\",\"time\":\"2026-10-02 02:01\",\"who\":\"David Chen\",\"actorEmail\":\"teacher@school.edu\",\"action\":\"Published result\",\"student\":\"STU-2026-024\",\"change\":\"75 (B) ? 75 (B)\",\"courseId\":2},{\"auditKey\":\"grade-audit-1790884889209-r4qy3kzfo8c\",\"time\":\"2026-10-02 02:01\",\"who\":\"David Chen\",\"actorEmail\":\"teacher@school.edu\",\"action\":\"Saved mark\",\"student\":\"STU-2026-024\",\"change\":\"new ? 75 (B)\",\"courseId\":2},{\"auditKey\":\"grade-audit-1790872791394-3xrusebbd8n\",\"time\":\"2026-10-01 22:39\",\"who\":\"David Chen\",\"actorEmail\":\"teacher@school.edu\",\"action\":\"Updated mark\",\"student\":\"STU-2026-008\",\"change\":\"67 (C+) ? 67 (C+)\",\"courseId\":2},{\"auditKey\":\"grade-audit-1790872738713-i7x31uqwvg\",\"time\":\"2026-10-01 22:38\",\"who\":\"David Chen\",\"actorEmail\":\"teacher@school.edu\",\"action\":\"Updated mark\",\"student\":\"STU-2026-008\",\"change\":\"67 (C+) ? 67 (C+)\",\"courseId\":2},{\"time\":\"2026-09-29 03:15\",\"who\":\"David Chen\",\"action\":\"Updated mark\",\"student\":\"STU-2024-002\",\"change\":\"78 (B) ? 89 (A-)\",\"courseId\":2},{\"time\":\"2026-09-29 03:14\",\"who\":\"David Chen\",\"action\":\"Saved mark\",\"student\":\"STU-2026-011\",\"change\":\"new ? 45 (F)\",\"courseId\":2},{\"time\":\"2026-09-29 02:57\",\"who\":\"David Chen\",\"action\":\"Published result\",\"student\":\"STU-2026-008\",\"change\":\"67 (C+) ? 67 (C+)\",\"courseId\":2},{\"time\":\"2026-09-29 02:46\",\"who\":\"David Chen\",\"action\":\"Saved mark\",\"student\":\"STU-2026-008\",\"change\":\"new ? 67 (C+)\",\"courseId\":2},{\"time\":\"2026-09-29 02:20\",\"who\":\"David Chen\",\"action\":\"Published result\",\"student\":\"STU-2026-027\",\"change\":\"new ? 95 (A)\",\"courseId\":2},{\"time\":\"2026-09-29 02:19\",\"who\":\"David Chen\",\"action\":\"Published result\",\"student\":\"STU-2024-002\",\"change\":\"78 (B) ? 78 (B)\",\"courseId\":2},{\"time\":\"2026-09-29 02:18\",\"who\":\"David Chen\",\"action\":\"Updated mark\",\"student\":\"STU-2024-001\",\"change\":\"81 (B+) ? 81 (B+)\",\"courseId\":2},{\"time\":\"2026-09-29 02:18\",\"who\":\"David Chen\",\"action\":\"Saved mark\",\"student\":\"STU-2024-002\",\"change\":\"new ? 78 (B)\",\"courseId\":2},{\"time\":\"2026-09-13 13:34\",\"who\":\"David Chen\",\"action\":\"Published result\",\"student\":\"STU-2026-013\",\"change\":\"76 (B) ? 76 (B)\",\"courseId\":1},{\"time\":\"2026-09-13 13:33\",\"who\":\"David Chen\",\"action\":\"Saved mark\",\"student\":\"STU-2026-013\",\"change\":\"new ? 76 (B)\",\"courseId\":1},{\"time\":\"2026-09-13 12:45\",\"who\":\"David Chen\",\"action\":\"Published result\",\"student\":\"STU-2026-008\",\"change\":\"95 (A) ? 95 (A)\",\"courseId\":1},{\"time\":\"2026-09-13 12:45\",\"who\":\"David Chen\",\"action\":\"Saved mark\",\"student\":\"STU-2026-008\",\"change\":\"new ? 95 (A)\",\"courseId\":1},{\"time\":\"2024-11-17 16:05\",\"who\":\"Sarah Kim\",\"action\":\"Published result\",\"student\":\"STU-2024-001\",\"change\":\"new ? 86 (A-)\",\"courseId\":4},{\"time\":\"2024-11-17 11:42\",\"who\":\"David Chen\",\"action\":\"Published result\",\"student\":\"STU-2024-001\",\"change\":\"new ? 88 (A-)\",\"courseId\":1},{\"time\":\"2024-11-17 10:18\",\"who\":\"David Chen\",\"action\":\"Updated mark\",\"student\":\"STU-2024-001\",\"change\":\"78 (B) ? 81 (B+)\",\"courseId\":2}],\"enrollments\":[{\"studentId\":\"STU-2026-003\",\"courseId\":1,\"sectionId\":1,\"section\":\"10-A\",\"semesterId\":1},{\"studentId\":\"STU-2026-003\",\"courseId\":2,\"sectionId\":1,\"section\":\"10-A\",\"semesterId\":1},{\"studentId\":\"STU-2026-003\",\"courseId\":3,\"sectionId\":1,\"section\":\"10-A\",\"semesterId\":1},{\"studentId\":\"STU-2026-003\",\"courseId\":4,\"sectionId\":1,\"section\":\"10-A\",\"semesterId\":1},{\"studentId\":\"STU-2026-003\",\"courseId\":5,\"sectionId\":1,\"section\":\"10-A\",\"semesterId\":1},{\"studentId\":\"STU-2026-003\",\"courseId\":6,\"sectionId\":1,\"section\":\"10-A\",\"semesterId\":1},{\"studentId\":\"STU-2026-003\",\"courseId\":7,\"sectionId\":1,\"section\":\"10-A\",\"semesterId\":1},{\"studentId\":\"STU-2026-004\",\"courseId\":1,\"sectionId\":1,\"section\":\"10-A\",\"semesterId\":1},{\"studentId\":\"STU-2026-004\",\"courseId\":2,\"sectionId\":1,\"section\":\"10-A\",\"semesterId\":1},{\"studentId\":\"STU-2026-004\",\"courseId\":3,\"sectionId\":1,\"section\":\"10-A\",\"semesterId\":1},{\"studentId\":\"STU-2026-004\",\"courseId\":4,\"sectionId\":1,\"section\":\"10-A\",\"semesterId\":1},{\"studentId\":\"STU-2026-004\",\"courseId\":5,\"sectionId\":1,\"section\":\"10-A\",\"semesterId\":1},{\"studentId\":\"STU-2026-004\",\"courseId\":6,\"sectionId\":1,\"section\":\"10-A\",\"semesterId\":1},{\"studentId\":\"STU-2026-005\",\"courseId\":1,\"sectionId\":1,\"section\":\"10-A\",\"semesterId\":1},{\"studentId\":\"STU-2026-005\",\"courseId\":2,\"sectionId\":1,\"section\":\"10-A\",\"semesterId\":1},{\"studentId\":\"STU-2026-005\",\"courseId\":3,\"sectionId\":1,\"section\":\"10-A\",\"semesterId\":1},{\"studentId\":\"STU-2026-005\",\"courseId\":4,\"sectionId\":1,\"section\":\"10-A\",\"semesterId\":1},{\"studentId\":\"STU-2026-005\",\"courseId\":5,\"sectionId\":1,\"section\":\"10-A\",\"semesterId\":1},{\"studentId\":\"STU-2026-005\",\"courseId\":6,\"sectionId\":1,\"section\":\"10-A\",\"semesterId\":1},{\"studentId\":\"STU-2026-006\",\"courseId\":1,\"sectionId\":1,\"section\":\"10-A\",\"semesterId\":1},{\"studentId\":\"STU-2026-006\",\"courseId\":2,\"sectionId\":1,\"section\":\"10-A\",\"semesterId\":1},{\"studentId\":\"STU-2026-006\",\"courseId\":3,\"sectionId\":1,\"section\":\"10-A\",\"semesterId\":1},{\"studentId\":\"STU-2026-006\",\"courseId\":4,\"sectionId\":1,\"section\":\"10-A\",\"semesterId\":1},{\"studentId\":\"STU-2026-006\",\"courseId\":5,\"sectionId\":1,\"section\":\"10-A\",\"semesterId\":1},{\"studentId\":\"STU-2026-006\",\"courseId\":6,\"sectionId\":1,\"section\":\"10-A\",\"semesterId\":1},{\"studentId\":\"STU-2024-001\",\"courseId\":1,\"sectionId\":1,\"section\":\"10-A\",\"semesterId\":1},{\"studentId\":\"STU-2024-001\",\"courseId\":2,\"sectionId\":1,\"section\":\"10-A\",\"semesterId\":1},{\"studentId\":\"STU-2024-001\",\"courseId\":4,\"sectionId\":1,\"section\":\"10-A\",\"semesterId\":1},{\"studentId\":\"STU-2024-002\",\"courseId\":1,\"sectionId\":1,\"section\":\"10-A\",\"semesterId\":1},{\"studentId\":\"STU-2024-002\",\"courseId\":2,\"sectionId\":1,\"section\":\"10-A\",\"semesterId\":1}]}', '2026-10-04 07:50:45');

-- --------------------------------------------------------

--
-- Table structure for table `students`
--

CREATE TABLE `students` (
  `id` int(10) UNSIGNED NOT NULL,
  `student_code` varchar(30) NOT NULL,
  `account_id` int(10) UNSIGNED NOT NULL,
  `name` varchar(120) NOT NULL,
  `email` varchar(190) NOT NULL,
  `phone` varchar(30) DEFAULT NULL,
  `section_name` varchar(30) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `students`
--

INSERT INTO `students` (`id`, `student_code`, `account_id`, `name`, `email`, `phone`, `section_name`, `created_at`) VALUES
(1, 'STU-2026-003', 3, 'bijoy das gupta', 'bijoy@g.com', '023972935723', '10-A', '2026-10-02 21:49:05'),
(2, 'STU-2026-004', 4, 'mahmudul hasan', 'mahmud@g.com', '0839423423', '10-A', '2026-10-02 21:50:53'),
(3, 'STU-2026-005', 5, 'farhana sadika', 'sadika@g.com', '09392395239', '10-A', '2026-10-02 21:51:56'),
(4, 'STU-2026-006', 6, 'asraful islam shanto', 'shanto203@gmail.com', '09395434578', '10-A', '2026-10-02 21:54:19'),
(5, 'STU-2024-001', 17, 'Alex Johnson', 'student@school.edu', '+8801700000000', '10-A', '2026-10-03 06:39:15'),
(6, 'STU-2024-002', 18, 'Maya Patel', 'student2@school.edu', '+8801700000000', '10-A', '2026-10-03 06:39:15'),
(7, 'STU-2026-021', 21, 'shanto', 'shanto@g.com', '032483249239', '10-A', '2026-10-04 06:23:12');

-- --------------------------------------------------------

--
-- Table structure for table `student_course_enrollments`
--

CREATE TABLE `student_course_enrollments` (
  `id` int(10) UNSIGNED NOT NULL,
  `student_id` int(10) UNSIGNED NOT NULL,
  `course_id` int(10) UNSIGNED NOT NULL,
  `section_id` int(10) UNSIGNED NOT NULL,
  `semester_id` int(10) UNSIGNED NOT NULL,
  `enrolled_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `student_course_enrollments`
--

INSERT INTO `student_course_enrollments` (`id`, `student_id`, `course_id`, `section_id`, `semester_id`, `enrolled_at`) VALUES
(1, 4, 1, 1, 1, '2026-10-03 06:19:24'),
(2, 4, 2, 1, 1, '2026-10-03 05:18:50'),
(3, 1, 2, 1, 1, '2026-10-03 05:18:59'),
(4, 3, 2, 1, 1, '2026-10-03 05:19:05'),
(5, 2, 2, 1, 1, '2026-10-03 05:19:08'),
(6, 1, 1, 1, 1, '2026-10-03 06:19:28'),
(7, 3, 1, 1, 1, '2026-10-03 06:19:31'),
(8, 2, 1, 1, 1, '2026-10-03 06:19:34'),
(9, 4, 5, 1, 1, '2026-10-03 05:19:37'),
(10, 1, 5, 1, 1, '2026-10-03 05:19:41'),
(11, 3, 5, 1, 1, '2026-10-03 05:19:44'),
(12, 2, 5, 1, 1, '2026-10-03 05:19:47'),
(13, 4, 6, 1, 1, '2026-10-03 05:19:53'),
(14, 1, 6, 1, 1, '2026-10-03 05:19:55'),
(15, 3, 6, 1, 1, '2026-10-03 05:19:57'),
(16, 2, 6, 1, 1, '2026-10-03 05:20:00'),
(17, 4, 3, 1, 1, '2026-10-03 05:20:18'),
(18, 1, 3, 1, 1, '2026-10-03 05:20:21'),
(19, 3, 3, 1, 1, '2026-10-03 05:20:24'),
(20, 2, 3, 1, 1, '2026-10-03 05:20:26'),
(21, 4, 4, 1, 1, '2026-10-03 05:20:42'),
(22, 1, 4, 1, 1, '2026-10-03 05:20:52'),
(23, 3, 4, 1, 1, '2026-10-03 05:20:55'),
(24, 2, 4, 1, 1, '2026-10-03 05:20:58'),
(34, 5, 1, 1, 1, '2026-10-03 06:39:27'),
(35, 5, 2, 1, 1, '2026-10-03 06:39:27'),
(36, 5, 4, 1, 1, '2026-10-03 06:39:27'),
(37, 6, 1, 1, 1, '2026-10-03 06:39:27'),
(38, 6, 2, 1, 1, '2026-10-03 06:39:27'),
(39, 1, 7, 1, 1, '2026-10-03 08:40:53');

-- --------------------------------------------------------

--
-- Stand-in structure for view `student_result_with_attendance`
-- (See below for the actual view)
--
CREATE TABLE `student_result_with_attendance` (
`student_id` int(10) unsigned
,`course_id` int(10) unsigned
,`section_id` int(10) unsigned
,`semester_id` int(10) unsigned
,`grade_id` int(10) unsigned
,`marks` decimal(5,2)
,`letter_grade` varchar(2)
,`grade_point` decimal(3,2)
,`teacher_comment` varchar(1000)
,`published` tinyint(1)
,`attendance_id` int(10) unsigned
,`classes_held` smallint(5) unsigned
,`classes_present` smallint(5) unsigned
,`attendance_percentage` decimal(11,2)
);

-- --------------------------------------------------------

--
-- Table structure for table `teachers`
--

CREATE TABLE `teachers` (
  `id` int(10) UNSIGNED NOT NULL,
  `teacher_code` varchar(30) NOT NULL,
  `account_id` int(10) UNSIGNED NOT NULL,
  `name` varchar(120) NOT NULL,
  `email` varchar(190) NOT NULL,
  `phone` varchar(30) DEFAULT NULL,
  `section_name` varchar(30) DEFAULT NULL,
  `subject_name` varchar(120) NOT NULL DEFAULT 'Not assigned yet',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `teachers`
--

INSERT INTO `teachers` (`id`, `teacher_code`, `account_id`, `name`, `email`, `phone`, `section_name`, `subject_name`, `created_at`) VALUES
(1, 'TCH-2026-007', 7, 'adnan sir', 'adnan@g.com', '09295293593', '10-A', 'Mathematics, Physics', '2026-10-02 22:00:05'),
(2, 'TCH-2026-008', 8, 'faruk sir', 'faruk@g.com', '01942923893', '10-A', 'Biology, Chemistry', '2026-10-02 22:00:12'),
(3, 'TCH-2026-009', 9, 'koli mam', 'koli@g.com', '019493482342', '10-A', 'bangla, Computer Science, English', '2026-10-02 22:00:16'),
(4, 'TCH-DEMO-001', 15, 'David Chen', 'teacher@school.edu', '+8801700000000', '10-A', 'Science & Mathematics', '2026-10-03 06:39:15'),
(5, 'TCH-DEMO-002', 16, 'Sarah Kim', 'teacher2@school.edu', '+8801700000000', '10-A', 'English & Computer Science', '2026-10-03 06:39:15');

-- --------------------------------------------------------

--
-- Structure for view `student_result_with_attendance`
--
DROP TABLE IF EXISTS `student_result_with_attendance`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `student_result_with_attendance`  AS SELECT `sce`.`student_id` AS `student_id`, `sce`.`course_id` AS `course_id`, `sce`.`section_id` AS `section_id`, `sce`.`semester_id` AS `semester_id`, `g`.`grade_id` AS `grade_id`, `g`.`marks` AS `marks`, `g`.`letter_grade` AS `letter_grade`, `g`.`grade_point` AS `grade_point`, `g`.`teacher_comment` AS `teacher_comment`, `g`.`published` AS `published`, `a`.`attendance_id` AS `attendance_id`, `a`.`classes_held` AS `classes_held`, `a`.`classes_present` AS `classes_present`, CASE WHEN `a`.`classes_held` > 0 THEN round(`a`.`classes_present` * 100.0 / `a`.`classes_held`,2) ELSE NULL END AS `attendance_percentage` FROM ((`student_course_enrollments` `sce` left join `grades` `g` on(`g`.`enrollment_id` = `sce`.`id`)) left join `attendance` `a` on(`a`.`enrollment_id` = `sce`.`id`)) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `accounts`
--
ALTER TABLE `accounts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `admin_code` (`admin_code`),
  ADD UNIQUE KEY `account_id` (`account_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `attendance`
--
ALTER TABLE `attendance`
  ADD PRIMARY KEY (`attendance_id`),
  ADD UNIQUE KEY `uq_attendance_enrollment` (`enrollment_id`);

--
-- Indexes for table `courses`
--
ALTER TABLE `courses`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `course_code` (`course_code`),
  ADD KEY `fk_courses_teacher` (`teacher_id`);

--
-- Indexes for table `course_section_assignments`
--
ALTER TABLE `course_section_assignments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_course_section_semester` (`course_id`,`section_id`,`semester_id`),
  ADD KEY `fk_csa_section` (`section_id`),
  ADD KEY `fk_csa_teacher` (`teacher_id`),
  ADD KEY `fk_csa_semester` (`semester_id`);

--
-- Indexes for table `grades`
--
ALTER TABLE `grades`
  ADD PRIMARY KEY (`grade_id`),
  ADD UNIQUE KEY `uq_grades_enrollment` (`enrollment_id`),
  ADD KEY `fk_grades_accepted_by` (`accepted_by`),
  ADD KEY `fk_grades_created_by` (`created_by`),
  ADD KEY `idx_grades_published_updated` (`published`,`updated_at`);

--
-- Indexes for table `grade_audit_log`
--
ALTER TABLE `grade_audit_log`
  ADD PRIMARY KEY (`audit_id`),
  ADD UNIQUE KEY `source_key` (`source_key`),
  ADD KEY `idx_grade_audit_grade_time` (`grade_id`,`changed_at`),
  ADD KEY `idx_grade_audit_actor_time` (`changed_by`,`changed_at`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_notifications_signup_request` (`related_request_id`),
  ADD KEY `fk_notifications_result_challenge` (`related_challenge_id`),
  ADD KEY `fk_notifications_result_student` (`related_student_id`),
  ADD KEY `fk_notifications_result_course` (`related_course_id`),
  ADD KEY `idx_notifications_recipient_read` (`recipient_account_id`,`is_read`,`created_at`);

--
-- Indexes for table `parents`
--
ALTER TABLE `parents`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `parent_code` (`parent_code`),
  ADD UNIQUE KEY `account_id` (`account_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `parent_student`
--
ALTER TABLE `parent_student`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_parent_student` (`parent_id`,`student_id`),
  ADD KEY `fk_parent_student_student` (`student_id`);

--
-- Indexes for table `result_challenge`
--
ALTER TABLE `result_challenge`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_result_challenge_student` (`student_id`),
  ADD KEY `fk_result_challenge_course` (`course_id`),
  ADD KEY `idx_result_challenge_status` (`status`,`submitted_at`);

--
-- Indexes for table `sections`
--
ALTER TABLE `sections`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_section_year` (`section_name`,`academic_year`);

--
-- Indexes for table `semesters`
--
ALTER TABLE `semesters`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `semester_name` (`semester_name`);

--
-- Indexes for table `signup_requests`
--
ALTER TABLE `signup_requests`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `sms_logs`
--
ALTER TABLE `sms_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_sms_logs_recipient` (`recipient_account_id`),
  ADD KEY `fk_sms_logs_student` (`student_id`),
  ADD KEY `fk_sms_logs_course` (`course_id`),
  ADD KEY `idx_sms_logs_created` (`created_at`);

--
-- Indexes for table `srms_state`
--
ALTER TABLE `srms_state`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `students`
--
ALTER TABLE `students`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `student_code` (`student_code`),
  ADD UNIQUE KEY `account_id` (`account_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `student_course_enrollments`
--
ALTER TABLE `student_course_enrollments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_student_course_section_semester` (`student_id`,`course_id`,`section_id`,`semester_id`),
  ADD KEY `fk_sce_course` (`course_id`),
  ADD KEY `fk_sce_section` (`section_id`),
  ADD KEY `fk_sce_semester` (`semester_id`);

--
-- Indexes for table `teachers`
--
ALTER TABLE `teachers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `teacher_code` (`teacher_code`),
  ADD UNIQUE KEY `account_id` (`account_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `accounts`
--
ALTER TABLE `accounts`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `admins`
--
ALTER TABLE `admins`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `attendance`
--
ALTER TABLE `attendance`
  MODIFY `attendance_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `courses`
--
ALTER TABLE `courses`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `course_section_assignments`
--
ALTER TABLE `course_section_assignments`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT for table `grades`
--
ALTER TABLE `grades`
  MODIFY `grade_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `grade_audit_log`
--
ALTER TABLE `grade_audit_log`
  MODIFY `audit_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3759;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=72;

--
-- AUTO_INCREMENT for table `parents`
--
ALTER TABLE `parents`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `parent_student`
--
ALTER TABLE `parent_student`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `result_challenge`
--
ALTER TABLE `result_challenge`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `sections`
--
ALTER TABLE `sections`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `semesters`
--
ALTER TABLE `semesters`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `signup_requests`
--
ALTER TABLE `signup_requests`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `sms_logs`
--
ALTER TABLE `sms_logs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `students`
--
ALTER TABLE `students`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `student_course_enrollments`
--
ALTER TABLE `student_course_enrollments`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT for table `teachers`
--
ALTER TABLE `teachers`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `admins`
--
ALTER TABLE `admins`
  ADD CONSTRAINT `fk_admins_account` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `attendance`
--
ALTER TABLE `attendance`
  ADD CONSTRAINT `fk_attendance_enrollment` FOREIGN KEY (`enrollment_id`) REFERENCES `student_course_enrollments` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `courses`
--
ALTER TABLE `courses`
  ADD CONSTRAINT `fk_courses_teacher` FOREIGN KEY (`teacher_id`) REFERENCES `teachers` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `course_section_assignments`
--
ALTER TABLE `course_section_assignments`
  ADD CONSTRAINT `fk_csa_course` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_csa_section` FOREIGN KEY (`section_id`) REFERENCES `sections` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_csa_semester` FOREIGN KEY (`semester_id`) REFERENCES `semesters` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_csa_teacher` FOREIGN KEY (`teacher_id`) REFERENCES `teachers` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `grades`
--
ALTER TABLE `grades`
  ADD CONSTRAINT `fk_grades_accepted_by` FOREIGN KEY (`accepted_by`) REFERENCES `accounts` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_grades_created_by` FOREIGN KEY (`created_by`) REFERENCES `accounts` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_grades_enrollment` FOREIGN KEY (`enrollment_id`) REFERENCES `student_course_enrollments` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `grade_audit_log`
--
ALTER TABLE `grade_audit_log`
  ADD CONSTRAINT `fk_grade_audit_actor` FOREIGN KEY (`changed_by`) REFERENCES `accounts` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_grade_audit_grade` FOREIGN KEY (`grade_id`) REFERENCES `grades` (`grade_id`) ON DELETE CASCADE;

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `fk_notifications_recipient` FOREIGN KEY (`recipient_account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_notifications_result_challenge` FOREIGN KEY (`related_challenge_id`) REFERENCES `result_challenge` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_notifications_result_course` FOREIGN KEY (`related_course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_notifications_result_student` FOREIGN KEY (`related_student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_notifications_signup_request` FOREIGN KEY (`related_request_id`) REFERENCES `signup_requests` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `parents`
--
ALTER TABLE `parents`
  ADD CONSTRAINT `fk_parents_account` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `parent_student`
--
ALTER TABLE `parent_student`
  ADD CONSTRAINT `fk_parent_student_parent` FOREIGN KEY (`parent_id`) REFERENCES `parents` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_parent_student_student` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `result_challenge`
--
ALTER TABLE `result_challenge`
  ADD CONSTRAINT `fk_result_challenge_course` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_result_challenge_student` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `sms_logs`
--
ALTER TABLE `sms_logs`
  ADD CONSTRAINT `fk_sms_logs_course` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_sms_logs_recipient` FOREIGN KEY (`recipient_account_id`) REFERENCES `accounts` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_sms_logs_student` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `students`
--
ALTER TABLE `students`
  ADD CONSTRAINT `fk_students_account` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `student_course_enrollments`
--
ALTER TABLE `student_course_enrollments`
  ADD CONSTRAINT `fk_sce_course` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_sce_section` FOREIGN KEY (`section_id`) REFERENCES `sections` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_sce_semester` FOREIGN KEY (`semester_id`) REFERENCES `semesters` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_sce_student` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `teachers`
--
ALTER TABLE `teachers`
  ADD CONSTRAINT `fk_teachers_account` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
