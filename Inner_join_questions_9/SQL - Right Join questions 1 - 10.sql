SELECT * FROM departments;
SELECT * FROM employees;
SELECT * FROM sales;

-- Right Join 
-- RIGHT JOIN returns all rows from the right table, plus matching rows from the left table. If there's no match, left table columns show NULL.

-- Basic

-- 1. Get all departments along with their employees (show NULL if a department has no employees), using RIGHT JOIN.
-- 2. Get all employees along with their department name (show NULL if department is missing), using RIGHT JOIN.
-- 3. List all sales records along with the employee name who made them, using RIGHT JOIN.

-- Intermediate
-- 4. Find all departments that have no employees, using RIGHT JOIN.
-- 5. Find all employees who have not made any sales, using RIGHT JOIN.
-- 6. Get total sales amount per employee (show 0 instead of NULL for no sales), using RIGHT JOIN.
-- 7. List all departments along with the count of employees in each (including 0), using RIGHT JOIN.
-- Advanced
-- 8. Find departments where total sales made by employees is more than 4000 (include 0 for none), using RIGHT JOIN.
-- 9. Rewrite this LEFT JOIN query using RIGHT JOIN instead (keep the same result):


-- 10. Using RIGHT JOIN twice (sales → employees, employees → departments), produce a report showing emp_name, dept_name, total_sales, marking employees as 'No Dept' where applicable.

-- Solve Questions
-- Basic
-- Q1 Get all departments along with their employees (show NULL if a department has no employees), using RIGHT JOIN.
SELECT d.dept_name, e.name
FROM departments d
RIGHT JOIN employees e
ON d.dept_id = e.dept_id;

-- 2. Get all employees along with their department name (show NULL if department is missing), using RIGHT JOIN.
SELECT e.name, d.dept_name
FROM departments ds
RIGHT JOIN employees e
ON d.dept_id = e.dept_id;

-- 3. List all sales records along with the employee name who made them, using RIGHT JOIN.
SELECT s.sale_id, e.name, s.amount
FROM employees e
RIGHT JOIN sales s
ON e.emp_id = s.emp_id;

-- Intermediate
-- 4. Find all departments that have no employees, using RIGHT JOIN.
SELECT d.dept_name, e.name
FROM employees e
RIGHT JOIN departments d
ON d.dept_id = e.dept_id
WHERE e.name IS NULL;

-- 5. Find all employees who have not made any sales, using RIGHT JOIN.
SELECT e.name, s.amount
FROM sales s
RIGHT JOIN employees e
ON e.emp_id = s.emp_id
WHERE s.emp_id IS NULL;

-- 6. Get total sales amount per employee (show 0 instead of NULL for no sales), using RIGHT JOIN.
SELECT e.name, COALESCE(SUM(s.amount), 0) AS Status
FROM sales s
RIGHT JOIN employees e
ON e.emp_id = s.emp_id
GROUP BY e.name;

-- 7. List all departments along with the count of employees in each (including 0), using RIGHT JOIN.
SELECT d.dept_name, COUNT(e.emp_id) AS Total_Employees
FROM employees e
RIGHT JOIN  departments d
ON d.dept_id = e.dept_id
GROUP BY d.dept_name;

-- Advanced
-- 8. Find departments where total sales made by employees is more than 4000 (include 0 for none), using RIGHT JOIN.
SELECT d.dept_name, COALESCE(SUM (s.amount), 0) AS Total_Sales
FROM departments d
RIGHT JOIN employees e
ON d.dept_id = e.dept_id
RIGHT JOIN sales s
ON e.emp_id = s.emp_id
GROUP BY d.dept_name
HAVING COALESCE (SUM(s.amount), 0) > 4000;

-- 9. Rewrite this LEFT JOIN query using RIGHT JOIN instead (keep the same result):
SELECT e.name, d.dept_name
FROM departments d
RIGHT JOIN employees e
ON d.dept_id = e.dept_id

-- 10. Using RIGHT JOIN twice (sales → employees, employees → departments), produce a report showing emp_name, dept_name, total_sales, marking employees as 'No Dept' where applicable.
SELECT 
    e.name, 
    COALESCE(d.dept_name, 'No Dept') AS dept_name,
    COALESCE(SUM(s.amount), 0) AS total_sales,
    CASE 
        WHEN SUM(s.amount) IS NULL THEN 'No Sales'
        ELSE 'Has Sales'
    END AS sales_status
FROM departments d
RIGHT JOIN (
    sales s
    RIGHT JOIN employees e
    ON s.emp_id = e.emp_id
)
ON d.dept_id = e.dept_id
GROUP BY e.name, d.dept_name;

