-- =================================================================================
-- Student Name: Tran Thi Trang
-- Student ID: 22070501
-- Assignment: INS306402 — Homework 4
-- =================================================================================

DROP DATABASE IF EXISTS university_db;
CREATE DATABASE university_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE university_db;

DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS semesters;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS instructors;
DROP TABLE IF EXISTS departments;

-- 1. Table: departments (Cấu trúc ban đầu)
CREATE TABLE departments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    department_code VARCHAR(20) NOT NULL UNIQUE,
    department_name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 2. Table: instructors
CREATE TABLE instructors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    instructor_code VARCHAR(20) NOT NULL UNIQUE,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    gender ENUM('Male', 'Female', 'Other') DEFAULT 'Other',
    department_id INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 3. Table: students
CREATE TABLE students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_code VARCHAR(20) NOT NULL UNIQUE,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    gender ENUM('Male', 'Female', 'Other') NOT NULL,
    dob DATE,
    gpa DECIMAL(3,2) DEFAULT 0.00,
    department_id INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_gpa CHECK (gpa >= 0.00 AND gpa <= 4.00),
    FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 4. Table: semesters
CREATE TABLE semesters (
    id INT AUTO_INCREMENT PRIMARY KEY,
    semester_code VARCHAR(20) NOT NULL UNIQUE,
    semester_name VARCHAR(50) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_dates CHECK (end_date > start_date)
) ENGINE=InnoDB;

-- 5. Table: courses
CREATE TABLE courses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    course_code VARCHAR(20) NOT NULL UNIQUE,
    title VARCHAR(150) NOT NULL,
    credits INT NOT NULL,
    department_id INT NOT NULL,
    instructor_id INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_credits CHECK (credits > 0),
    FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (instructor_id) REFERENCES instructors(id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 6. Table: enrollments
CREATE TABLE enrollments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    semester_id INT NOT NULL,
    enrollment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    grade DECIMAL(3,2),
    grade_letter ENUM('A', 'B', 'C', 'D', 'F'),
    UNIQUE KEY unique_enrollment (student_id, course_id, semester_id),
    CONSTRAINT chk_course_grade CHECK (grade >= 0.00 AND grade <= 4.00),
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (semester_id) REFERENCES semesters(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;


-- Chèn 5 Khoa 
INSERT INTO departments (department_code, department_name, description) VALUES
('IS', 'Khoa Các khoa học ứng dụng', 'Phụ trách môn Lập trình, Hệ thống thông tin'),
('ECO', 'Khoa Kinh tế và Quản lý', 'Phụ trách môn Kinh tế vĩ mô, Quản trị KD'),
('LANG', 'Khoa Ngôn ngữ ứng dụng', 'Phụ trách các môn Ngoại ngữ'),
('BASIC', 'Bộ môn Khoa học cơ bản', 'Phụ trách Toán, Chính trị, Pháp luật'),
('SKILL', 'Bộ môn Kỹ năng bổ trợ', 'Phụ trách Kỹ năng mềm');

-- Chèn 5 Giảng viên
INSERT INTO instructors (instructor_code, full_name, email, gender, department_id) VALUES
('GV001', 'Nguyen Quang Thuan', 'thuan.nq@vnu.edu.vn', 'Male', 1),
('GV002', 'Nguyen Thu Ha', 'ha.nt@vnu.edu.vn', 'Female', 2),
('GV003', 'Tran Anh Nguyet', 'nguyet.ta@vnu.edu.vn', 'Female', 4),
('GV004', 'Truong Cong Doan', 'doan.tc@vnu.edu.vn', 'Male', 5),
('GV005', 'Hoang Trong Tien', 'tien.ht@vnu.edu.vn', 'Male', 3);

-- Chèn 5 Sinh viên
INSERT INTO students (student_code, full_name, email, gender, dob, gpa, department_id) VALUES
('22070499', 'Nguyen Bao An', '22070499@vnu.edu.vn', 'Male', '2004-03-30', 3.20, 1),
('22207103', 'Pham Nhat Anh', '22207103@vnu.edu.vn', 'Female', '2004-01-11', 3.80, 2),
('23073281', 'Tran Minh Duc', '23073281@vnu.edu.vn', 'Male', '2005-06-16', 2.90, 1),
('23079313', 'Hoang Thao May', '23079313@vnu.edu.vn', 'Female', '2005-04-30', 3.50, 1),
('23071910', 'Le Duc Manh', '23071910@vnu.edu.vn', 'Male', '2005-05-19', 3.10, 2);

-- Chèn 5 Học kỳ
INSERT INTO semesters (semester_code, semester_name, start_date, end_date) VALUES
('Fall 2025', 'Mua Thu 2025', '2025-09-01', '2025-12-31'),
('Spring 2026','Mua Xuan 2026', '2026-01-01', '2026-05-31'),
('Summer 2026', 'Mua He 2026', '2026-06-01', '2026-08-31'),
('Fall 2026','Mua Thu 2026', '2026-09-01', '2026-12-31'),
('Spring 2027','Mua Xuan 2027', '2027-01-01', '2027-05-31');

-- Chèn 5 Môn học
INSERT INTO courses (course_code, title, credits, department_id, instructor_id) VALUES
('INS1073', 'Tin học cơ sở', 3, 1, 1),
('INS2080', 'Cơ sở dữ liệu', 4, 2, 2),
('INS3080', 'Trí tuệ nhân tạo', 3, 3, 5),
('INS3281', 'Dự án I', 3, 4, 3),
('INS3009', 'Khởi nghiệp', 2, 5, 4),
('INS2098', 'Nguyên lý kế toán', 3, 2, 2);
```

-- Chèn 10 Đăng ký học
INSERT INTO enrollments (student_id, course_id, semester_id, grade, grade_letter) VALUES
(2, 2, 3, 3.60, 'A'),
(3, 1, 3, 3.20, 'B'),
(4, 5, 3, 2.80, 'B'),
(5, 3, 2, 3.90, 'A'),
(2, 4, 2, 3.40, 'B'),
(3, 6, 1, 2.50, 'C'),
(4, 1, 1, 3.70, 'A'),
(5, 2, 2, 3.00, 'B'),
(1, 5, 1, 3.80, 'A'),
(2, 6, 3, 2.20, 'C');
