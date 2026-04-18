
DROP TABLE IF EXISTS exams;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS students;


CREATE TABLE students (
id SERIAL PRIMARY KEY,
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL,
birthday DATE NOT NULL,
phone_number VARCHAR(13) UNIQUE,
"group" VARCHAR(20) NOT NULL,
gender VARCHAR(10) CHECK (gender IN ('male', 'female', 'other')),
entered_at INTEGER CHECK (entered_at >= 2000 AND entered_at <= EXTRACT(YEAR FROM CURRENT_DATE)),
department VARCHAR(100) NOT NULL
);


CREATE TABLE courses (
id_course SERIAL PRIMARY KEY,
title VARCHAR(100),
description TEXT,
hours INTEGER
);


CREATE TABLE exams (
id_stud INTEGER,
id_course INTEGER,
mark NUMERIC(3,1),

FOREIGN KEY (id_stud) REFERENCES students(id)
ON DELETE CASCADE
ON UPDATE CASCADE,

FOREIGN KEY (id_course) REFERENCES courses(id_course)
ON DELETE CASCADE
ON UPDATE CASCADE
);

-- ДАНІ (СТУДЕНТИ)

INSERT INTO students
(first_name, last_name, birthday, phone_number, "group", gender, entered_at, department)
VALUES
('Іван', 'Петренко', '2004-06-12', '+380501234567', 'CS-101', 85.50, 'male', 2021, 'Комп’ютерні науки'),
('Степан', 'Сергієнко', '2003-05-14', '+380501255567', 'CS-100', 67.50, 'male', 2021, 'Комп’ютерні науки'),
('Сергій', 'Петренко', '2000-09-10', '+380555234567', 'CS-99', 78.50, 'male', 2021, 'Комп’ютерні науки'),
('Панас', 'Савченко', '1990-02-07', '+380507734567', 'CS-101', 85.40, 'male', 2021, 'Комп’ютерні науки'),

('Марія', 'Коваль', '2005-03-10', '+380931234567', 'CS-102', 91.20, 'female', 2022, 'Комп’ютерні науки'),
('Антон', 'Антонов', '2002-01-01', '+380981112233', 'CS-101', 88.00, 'male', 2020, 'Комп’ютерні науки'),
('Олена', 'Бойко', '2004-07-21', '+380661234567', 'CS-100', 95.50, 'female', 2022, 'Комп’ютерні науки'),
('Дмитро', 'Мельник', '2003-11-11', '+380671234567', 'CS-99', 72.30, 'male', 2021, 'Комп’ютерні науки'),

('Андрій', 'Шевченко', '2001-04-18', '+380631234567', 'ENG-101', 89.00, 'male', 2019, 'Інженерія'),
('Ірина', 'Левченко', '2002-08-25', '+380931112244', 'ENG-102', 93.70, 'female', 2020, 'Інженерія'),

('Mykola', 'Ivanov', '2006-05-05', '+380961234567', 'CS-103', 4.80, 'male', 2023, 'Комп’ютерні науки'),
('Vasya', 'Pupkin', '2007-06-06', '+380991234567', 'CS-104', 3.20, 'male', 2024, 'Комп’ютерні науки');


INSERT INTO courses (title, description, hours)
VALUES
('Основи програмування', 'Base', 60),
('Бази даних', 'SQL', 40),
('Математика', 'Math', 50),
('Алгоритми', 'Algo', 70);


INSERT INTO exams (id_stud, id_course, mark)
VALUES
(1,1,5),(1,2,4),(2,1,3),(3,2,5),(4,1,4),
(5,3,5),(6,1,4),(7,2,5),(8,3,3),
(9,4,4),(10,4,5),(11,1,4),(12,2,3);


-- Ім’я + дата народження
SELECT first_name || ' ' || last_name AS full_name, birthday
FROM students
ORDER BY birthday;

-- Унікальні групи
SELECT DISTINCT "group" 
FROM students;

-- Рейтинг студентів
SELECT s.first_name, s.last_name, AVG(e.mark) AS avg_mark
FROM students s 
JOIN exams e ON s.id = e.id_stud
GROUP BY s.id 
ORDER BY avg_mark DESC;

-- Топ 3
SELECT s.first_name, s.last_name, AVG(s.mark) AS avg_mark
FROM students s
JOIN exams e ON s.id = e.id_stud
GROUP BY s.id
ORDER BY avg_mark DESC
LIMIT 3;

-- Середній бал по факультетах
SELECT s.department, AVG(e.mark) AS avg_mark
FROM students s
JOIN exams e ON s.id = e.id_stud
GROUP BY s.department
ORDER BY avg_mark DESC;

-- Студенти + курси
SELECT s.first_name, s.last_name, c.title
FROM students s
JOIN exams e ON s.id = e.id_stud
JOIN courses c ON e.id_course = c.id_course;

-- Середній бал по студенту
SELECT s.first_name, AVG(e.mark) AS avg_mark
FROM students s
JOIN exams e ON s.id = e.id_stud
GROUP BY s.id;

-- Студенти з середнім > 4
SELECT s.first_name
FROM students s
JOIN exams e ON s.id = e.id_stud
GROUP BY s.id
HAVING AVG(e.mark) > 4;

-- ПІДЗАПИТ

SELECT s.first_name, s.last_name
FROM students s
WHERE (
   SELECT AVG(e.mark) 
   FROM exams e
   WHERE e.id_stud = s.id
) > (
    SELECT AVG(e2.mark)
    FROM exams e2
    JOIN students s2 ON s2.id = e2.id_stud
    WHERE s2.first_name = 'Петро'
        AND s2.last_name = 'Петренко'
);


SELECT s.first_name, c.title,
CASE
WHEN e.mark >= 4.5 THEN 'відмінно'
WHEN e.mark >= 3.5 THEN 'добре'
ELSE 'задовільно'
END AS grade_text
FROM students s
JOIN exams e ON s.id = e.id_stud
JOIN courses c ON e.id_course = c.id_course;
