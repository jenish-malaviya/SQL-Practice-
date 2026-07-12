-- Que 1

UPDATE students
SET student_id = 1
WHERE name = 'Jenish';

UPDATE students
SET student_id = 2
WHERE grade = 'B';

UPDATE students
SET student_id = 3
WHERE grade = 'C';

-- Que 2

CREATE TABLE students(
	student_id INT AUTO_INCREMENT,
	name VARCHAR(50),
	age INT,
	grade CHAR(1)
);

-- Que 3

CREATE TABLE students(
	student_id CHAR(10) AUTO_INCREMENT,
	name VARCHAR(50),
	age INT,
	grade CHAR(1)
);




