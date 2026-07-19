-- Left Join

SELECT * FROM departments;
SELECT * FROM employees;
SELECT * FROM sales;

-- Left Join
-- Right side data table match left side table data which data same this data show
-- Show all the value but Which value cant be same this is value show only null 

-- Syntax

-- SELECT columns
-- FROM table1
-- LEFT JOIN table2
-- ON table1.common_column = table2.common_column;

-- Basic

-- 1. Get all employees along with their department name (show NULL if no department assigned).
-- 2. Get all departments along with employees working in them (show departments even if no employees).
-- 3. List all employees and their sales amount, if any.

-- Intermediate
-- 4. Find all departments that have no employees.
-- 5. Find all employees who have not made any sales.
-- 6. Get the total sales amount per employee, including employees with zero sales (show 0 instead of NULL).
-- 7. List all departments along with the count of employees in each (including departments with 0 employees).
-- Advanced
-- 8. Find departments where the total sales amount made by their employees is more than 4000 (include departments with 0 sales as 0).
-- 9. Get a list of all employees, their department name, and total sales — sorted so employees with no sales appear first.
-- 10. Using LEFT JOIN twice (employees → departments, employees → sales), produce a report showing emp_name, dept_name, total_sales, and mark employees as 'No Dept' or 'No Sales' where applicable.

-- Solve Questions

-- Basic

-- 1. Get all employees along with their department name (show NULL if no department assigned).
SELECT e.name, d.dept_name
FROM employees e
LEFT JOIN departments d
ON d.dept_id = e.dept_id;

-- 2. Get all departments along with employees working in them (show departments even if no employees).
SELECT d.dept_name, e.name
FROM departments d
LEFT JOIN employees e
ON d.dept_id = e.dept_id;

-- 3. List all employees and their sales amount, if any.
SELECT e.name, s.amount
FROM employees e
LEFT JOIN sales s
ON e.emp_id = s.emp_id;

-- Intermediate

-- 4. Find all departments that have no employees.
SELECT d.dept_name , e.name
FROM departments d
LEFT JOIN employees e
ON d.dept_id = e.dept_id
WHERE emp_id IS NULL;

-- 5. Find all employees who have not made any sales.
SELECT e.name, s.amount
FROM employees e
LEFT JOIN sales s
ON e.emp_id = s.emp_id
WHERE amount IS NULL;

-- 6. Get the total sales amount per employee, including employees with zero sales (show 0 instead of NULL).
SELECT e.name, COALESCE(SUM(s.amount),0)
FROM employees e
LEFT JOIN sales s
ON e.emp_id = s.emp_id
GROUP BY e.name;

-- 7. List all departments along with the count of employees in each (including departments with 0 employees).
SELECT d.dept_name, COUNT(e.emp_id) AS Employee_count
FROM departments d
LEFT JOIN employees e
ON d.dept_id = e.dept_id
GROUP BY d.dept_name;

-- Advanced

-- 8. Find departments where the total sales amount made by their employees is more than 4000 (include departments with 0 sales as 0).
SELECT d.dept_name, COALESCE(SUM (s.amount), 0) AS Total_Sales
FROM departments d
LEFT JOIN employees e
ON d.dept_id = e.dept_id
LEFT JOIN sales s
ON e.emp_id = s.emp_id
GROUP BY d.dept_name
HAVING COALESCE(SUM (s.amount), 0) > 4000;

-- 9. Get a list of all employees, their department name, and total sales — sorted so employees with no sales appear first.
SELECT d.dept_name, e.name, COALESCE(SUM(s.amount),0) AS Total_Sales
FROM departments d
LEFT JOIN employees e
ON d.dept_id = e.dept_id
LEFT JOIN sales s
ON e.emp_id = s.emp_id
GROUP BY d.dept_name , e.name
ORDER BY Total_Sales 
ASC;

-- 10. Using LEFT JOIN twice (employees → departments, employees → sales), produce a report showing emp_name, dept_name, total_sales, and mark employees as 'No Dept' or 'No Sales' where applicable.
SELECT e.name,
	COALESCE(d.dept_name, 'No Debt') AS dept_name,
	COALESCE(SUM(s.amount), 0) AS Total_sales,
	CASE 
		WHEN SUM(s.amount) IS NULL THEN 'No Sales'
		ELSE 'Has Sales'
		END AS Sales_Status
FROM employees e
LEFT JOIN departments d
ON d.dept_id = e.dept_id
LEFT JOIN sales s
ON e.emp_id = s.emp_id
GROUP BY d.dept_name , e.name;








