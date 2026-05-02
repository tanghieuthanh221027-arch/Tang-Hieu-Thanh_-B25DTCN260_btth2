CREATE DATABASE training_management;
USE training_management;

CREATE TABLE teachers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    salary DECIMAL(10 , 2 ) NOT NULL CHECK (salary >= 0)
);

CREATE TABLE courses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100) NOT NULL,
    teacher_id INT,
    credits INT CHECK (credits > 0),
    tuition_fee DECIMAL(10 , 2 ) CHECK (tuition_fee >= 0),
    FOREIGN KEY (teacher_id)
        REFERENCES teachers (id)
);

CREATE TABLE students (
    id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender ENUM('Male', 'Female', 'Other') NOT NULL
);

CREATE TABLE enrollments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    date DATE NOT NULL,
    score DECIMAL(4 , 2 ),
    FOREIGN KEY (student_id)
        REFERENCES students (id),
    FOREIGN KEY (course_id)
        REFERENCES courses (id)
);

INSERT INTO teachers (full_name, salary) VALUES
('Nguyen Van A', 1000),
('Tran Thi B', 1200),
('Le Van C', 1100);

INSERT INTO courses (course_name, teacher_id, credits, tuition_fee) VALUES
('IT Basics', 1, 3, 500),
('Advanced IT', 1, 4, 700),
('Database Systems', 2, 3, 600),
('Web Development', 2, 4, 800),
('Graphic Design', 3, 2, 400),
('Soft Skills', NULL, 2, 300);

INSERT INTO students (full_name, date_of_birth, gender) VALUES
('Student 1', '2000-01-01', 'Male'),
('Student 2', '2000-02-02', 'Female'),
('Student 3', '2000-03-03', 'Male'),
('Student 4', '2005-04-04', 'Female'),
('Student 5', '2000-05-05', 'Male'),
('Student 6', '2005-06-06', 'Female'),
('Student 7', '2000-07-07', 'Male'),
('Student 8', '2000-08-08', 'Female'),
('Student 9', '2005-09-09', 'Male'),
('Student 10', '2000-10-10', 'Female');

INSERT INTO enrollments (student_id, course_id, date, score) VALUES
(1,1,'2025-01-01',8.5),
(2,1,'2025-01-02',7.0),
(3,2,'2025-01-03',9.0),
(4,2,'2025-01-04',6.5),
(5,3,'2025-01-05',7.5),
(6,3,'2025-01-06',8.0),
(7,4,'2025-01-07',9.5),
(8,4,'2025-01-08',NULL),
(9,5,'2025-01-09',6.0),
(10,5,'2025-01-10',7.2),
(1,6,'2025-01-11',8.8),
(2,6,'2025-01-12',NULL),
(3,1,'2025-01-13',7.7),
(4,3,'2025-01-14',8.1),
(5,4,'2025-01-15',6.9);

UPDATE teachers 
SET 
    salary = salary * 1.10
WHERE
    id IN (SELECT DISTINCT
            teacher_id
        FROM
            courses
        WHERE
            course_name LIKE '%IT%');

SELECT 
    c.id AS course_id,
    c.course_name,
    t.full_name AS teacher_name
FROM
    courses c
        LEFT JOIN
    teachers t ON c.teacher_id = t.id;

SELECT 
    id, full_name, date_of_birth, gender
FROM
    students
WHERE
    YEAR(date_of_birth) = 2005;

SELECT 
    s.full_name, s.id, e.score
FROM
    enrollments e
        JOIN
    students s ON e.student_id = s.id
        JOIN
    courses c ON e.course_id = c.id
WHERE
    c.course_name = 'Web Development'
ORDER BY e.score DESC;

SELECT 
    s.full_name, c.course_name, t.full_name
FROM
    enrollments e
        JOIN
    students s ON e.student_id = s.id
        JOIN
    courses c ON e.course_id = c.id
        LEFT JOIN
    teachers t ON c.teacher_id = t.id;

SELECT 
    t.full_name AS teacher_name, COUNT(c.id) AS total_courses
FROM
    teachers t
        LEFT JOIN
    courses c ON t.id = c.teacher_id
GROUP BY t.id , t.full_name;

SELECT 
    c.id AS course_id,
    c.course_name,
    COUNT(e.id) AS total_students,
    c.tuition_fee,
    COUNT(e.id) * c.tuition_fee AS total_revenue
FROM
    courses c
        LEFT JOIN
    enrollments e ON c.id = e.course_id
GROUP BY c.id , c.course_name , c.tuition_fee;

SELECT 
    s.full_name, COUNT(e.course_id) AS total_courses
FROM
    students s
        JOIN
    enrollments e ON s.id = e.student_id
GROUP BY s.id , s.full_name
HAVING COUNT(e.course_id) >= 3;

SELECT 
    c.course_name, AVG(e.score) AS avg_score
FROM
    courses c
        JOIN
    enrollments e ON c.id = e.course_id
WHERE
    e.score IS NOT NULL
GROUP BY c.id , c.course_name
HAVING AVG(e.score) < 5.0;
