-- Only All Joins

-- Table 1
CREATE TABLE departments (
    dept_id     INT PRIMARY KEY,
    dept_name   VARCHAR(50),
    location    VARCHAR(50)
);

-- Table 2
CREATE TABLE employees (
    emp_id      INT PRIMARY KEY,
    name        VARCHAR(50),
    email       VARCHAR(100),
    dept_id     INT,
    manager_id  INT,
    salary      NUMERIC(10,2),
    hire_date   DATE
);

-- Table 3
CREATE TABLE sales (
    sale_id     INT PRIMARY KEY,
    emp_id      INT,
    sale_date   DATE,
    amount      NUMERIC(10,2),
    product     VARCHAR(50)
);

INSERT INTO departments VALUES
(1,'Sales','Surat'),
(2,'IT','Bengaluru'),
(3,'HR','Pune'),
(4,'Marketing',NULL);

INSERT INTO employees VALUES
(101,'Aarav Shah','aarav.shah@co.com',1,NULL,90000,'2020-01-10'),
(102,'Priya Mehta','priya.mehta@co.com',1,101,55000,'2021-03-15'),
(103,'Rohan Patel','rohan.patel@co.com',1,101,48000,'2022-06-01'),
(104,'Sneha Iyer','sneha.iyer@co.com',2,NULL,95000,'2019-11-20'),
(105,'Karan Verma','karan.verma@co.com',2,104,62000,'2021-07-19'),
(106,'Neha Joshi','neha.joshi@co.com',3,NULL,50000,'2020-09-05'),
(107,'Vikram Rao',NULL,3,106,45000,'2023-02-14'),
(108,'Anjali Desai','anjali.desai@co.com',NULL,NULL,40000,'2023-08-01');

INSERT INTO sales VALUES
(1,102,'2024-01-05',12000,'Laptop'),
(2,102,'2024-02-10',8000,'Mouse'),
(3,103,'2024-01-20',15000,'Monitor'),
(4,103,'2024-03-02',5000,'Keyboard'),
(5,105,'2024-01-15',20000,'Server'),
(6,105,'2024-02-25',9000,'Router'),
(7,107,'2024-01-08',3000,'Chair');

SELECT * FROM departments;
SELECT * FROM employees;
SELECT * FROM sales;

-- INNER JOIN
-- LEFT JOIN
-- RIGHT JOIN
-- FULL OUTER JOIN
-- CROSS JOIN
-- SELF JOIN

-- Inner Join
-- Only Consider Same row in both table (1 column data same with table 2 data)
SELECT * 
FROM departments d
JOIN employees e
ON d.dept_id = e.dept_id;

-- Questions

-- 🟢 Basic

-- Q1. Show each employee's name along with their department name.
-- Q2. List only employees who work in the 'IT' department.
-- Q3. Show employee name, department name, and location together.

-- 🟡 Intermediate

-- Q4. Count how many employees are in each department (only departments that have employees).
-- Q5. Find departments where the total salary paid exceeds 100,000.
-- Q6. Show each employee (who has a manager) along with their manager's name.
-- Q7. Show the highest-paid employee in each department.

-- 🔴 Advanced

-- Q8. Find employees who earn more than the average salary of their own department.
-- Q9. Show employee name, their manager's name, and their department name — all in one query.
-- Q10. Show employee name, department name, and salary — but only for employees earning above 50,000.

-- Solve Questions
-- Basic
-- Q1. Show each employee's name along with their department name.

SELECT e.name, d.dept_name
FROM departments d
JOIN employees e
ON d.dept_id = e.dept_id;

-- Q2. List only employees who work in the 'IT' department.

SELECT e.name, d.dept_name
FROM employees e
INNER JOIN departments d
ON d.dept_id = e.dept_id
WHERE dept_name = 'IT';

-- Q3. Show employee name, department name, and location together.

SELECT e.name, d.dept_name, d.location
FROM departments d
INNER JOIN employees e
ON d.dept_id = e.dept_id;

-- 🟡 Intermediate

-- Q4. Count how many employees are in each department (only departments that have employees).

SELECT d.dept_name, COUNT(e.name)
FROM departments d
JOIN employees e
ON d.dept_id = e.dept_id 
GROUP BY d.dept_name;

-- Q5. Find departments where the total salary paid exceeds 100,000.
-- Importent is sql does not allow aggregate function used in where so thier used having allow to sum, count, avg.....
/* WHERE filters rows before they get grouped. But SUM() doesn't exist yet at that point — it's only calculated after GROUP BY runs. 
   So SQL doesn't allow aggregate functions in WHERE.HAVING exists specifically for this — it filters groups after the SUM/COUNT/AVG has been calculated. */

SELECT d.dept_name, SUM(e.salary) AS Total_Salary
FROM departments d
INNER JOIN employees e
ON d.dept_id = e.dept_id
GROUP BY d.dept_name
HAVING SUM (e.salary) > 100000;

-- Q6. Show each employee (who has a manager) along with their manager's name.
-- When user join same table so give the table name first alphabet and number (Ex table name students --> s1. and s2. for second table)

SELECT e1.name AS employee, e2.name AS Manager
FROM employees e1
JOIN employees e2
ON e1.manager_id = e2.emp_id;

-- Q7. Show the highest-paid employee in each department.

SELECT d.dept_name, e.name, e.salary AS High_Salary
FROM departments d
JOIN employees e
ON d.dept_id = e.dept_id
WHERE e.salary = (
	SELECT MAX(e2.salary)
	FROM employees e2
	WHERE e2.dept_id = e.dept_id
);

-- Q8. Find employees who earn more than the average salary of their own department.

SELECT d.dept_name, e.name, e.salary
FROM departments d
INNER JOIN employees e
ON d.dept_id = e.dept_id
WHERE e.salary > (
	SELECT AVG(e2.salary)
	FROM employees e2
	WHERE e2.dept_id = e.dept_id
);

-- Q9. Show employee name, their manager's name, and their department name — all in one query.

SELECT e1.name, e2.name AS manager_name, d.dept_name
FROM employees e1
JOIN departments d
ON e1.dept_id = d.dept_id
JOIN employees e2
ON e2.emp_id = e1.manager_id;


-- Q10. Show employee name, department name, and salary — but only for employees earning above 50,000.

SELECT e.name, d.dept_name, e.salary
FROM employees e
INNER JOIN departments d
ON d.dept_id = e.dept_id
WHERE e.salary > 50000;


-- Q10. Rank employees by salary within each department, showing department name.

SELECT d.dept_name, e.name, e.salary,
       RANK() OVER (PARTITION BY e.dept_id ORDER BY e.salary DESC) 
	   AS dept_rank
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id;
