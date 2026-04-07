--видалення таблиці

DROP TABLE students;
--створення таблиці 
CREATE DATABASE students;

CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birthday DATE NOT NULL,
    phone_number VARCHAR(13) UNIQUE,
    "group" VARCHAR(20) NOT NULL,
    avg_mark NUMERIC(5,2) CHECK (avg_mark >= 0 AND avg_mark <= 100),
    gender VARCHAR(10) CHECK (gender IN ('male', 'female', 'other')),
    entered_at INTEGER CHECK (entered_at >= 2000 AND entered_at <= EXTRACT(YEAR FROM CURRENT_DATE)),
    department VARCHAR(100) NOT NULL
);

--додавання студентів
 INSERT INTO students
(first_name, last_name, birthday, phone_number, "group", avg_mark, gender, entered_at, department)
VALUES
('Іван', 'Петренко', '2004-06-12', '+380501234567', 'CS-101', 85.50, 'male', 2021, 'Комп’ютерні науки'),
('Степан', 'Сергієнко', '2003-05-14', '+380501255567', 'CS-100', 67.50, 'male', 2021, 'Комп’ютерні науки'),
('Сергій', 'Петренко', '2000-09-10', '+380555234567', 'CS-99', 78.50, 'male', 2021, 'Комп’ютерні науки'),
('Панас', 'Савченко', '1990-02-07', '+380507734567', 'CS-101', 85.40, 'male', 2021, 'Комп’ютерні науки');

--перевірка данних
SELECT * FROM students;

-- студенти від старого до малого
SELECT first_name || '' || last_name, birthday
FROM students 
ORDER BY birthday ASC;

--унікальні групи
SELECT DISTINCT "group"
FROM students;

--рейтинг студентів
SELECT first_name, last_name, avg_mark
FROM students
ORDER BY avg_mark DESC;

--друга сторінка
SELECT * FROM students
LIMIT 6 OFFSET 6;

--топ 3 студенти
SELECT first_name, last_name, avg_mark, "group"
FROM students
ORDER BY avg_mark DESC
LIMIT 3;

--максимальний бал
SELECT MAX(avg_mark) FROM students;

--інфо студентів та маска телефону
SELECT
LEFT(first_name, 1) || '.' || last_name AS name,
SUBSTRING(phone_number FROM 1 FOR 6) || '*****' AS phone
FROM students;

--народжені 2005-2008
SELECT * FROM students

WHERE birthday BETWEEN '2005-01-01' AND '2008-12-31';



-- Mykola 
SELECT * FROM students

WHERE first_name = 'Mykola' AND avg_mark > 4.5;



--Кількість студентів у групах

SELECT "group", COUNT(*)

FROM students

GROUP BY "group";



--Вступ 2018

SELECT COUNT(*)

FROM students

WHERE entered_at = 2018;



--Найменший рік вступу

SELECT MIN(entered_at) FROM students;



--Київстар

SELECT * FROM students

WHERE phone_number LIKE '+38098%' 

   OR phone_number LIKE '+38096%';


--Середній бал дівчат по факультету

SELECT department, AVG(avg_mark) AS avg_avg_mark

FROM students

WHERE gender = 'female'

GROUP BY department

ORDER BY avg_avg_mark DESC;



-- Мінімальний бал

SELECT entered_at, MIN(avg_mark)

FROM students

WHERE department = 'Інформаційні технології'

AND EXTRACT(MONTH FROM birthday) IN (6,7,8)

GROUP BY entered_at

HAVING MIN(avg_mark) > 3.5;



--Додати колонку студентського квитка

ALTER TABLE students

ADD COLUMN student_card VARCHAR(10);



--Видалити студентів 2010 року

DELETE FROM students

WHERE entered_at = 2010;