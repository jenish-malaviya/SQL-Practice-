SELECT * FROM employees_2;

-- Basic (Aggregate functions)

-- 1. Find the total number of employees, total salary, and average salary in each department. Use COUNT, SUM, AVG with GROUP BY.
-- 2. Find the department(s) where the average salary is greater than 60,000. Use GROUP BY + HAVING.
-- 3. Find the maximum and minimum salary in each department, and the salary range (max - min) per department.

-- Intermediate (Basic Window Functions)

-- 4. Rank employees within each department by salary (highest = rank 1) using RANK(). Also show DENSE_RANK() and ROW_NUMBER() side by side so you can see the difference on the tied salaries (e.g., Priya Mehta & Rohan Patel, both 62000).
-- 5. For each employee, show their salary along with the department's average salary (using AVG(salary) OVER (PARTITION BY department)), and calculate how far their salary is from that average.
-- 6. Calculate a running total (cumulative sum) of salaries within each department, ordered by join_date. Use SUM(salary) OVER (...).

-- Advanced (Combining aggregate + window logic)

-- 7. Find each employee's salary as a percentage of their department's total salary (i.e., salary / SUM(salary) OVER (PARTITION BY department) * 100).
-- 8. Calculate a 2-hire moving average of salary within each department (average of current + previous hire's salary), using AVG(...) OVER (... ROWS BETWEEN 1 PRECEDING AND CURRENT ROW).
-- 9. For each department, identify the top 2 highest-paid employees only (using RANK() or DENSE_RANK() wrapped in a CTE/subquery, filtered with WHERE rank <= 2).
-- 10. Find, for each department, what percentage of employees earn above the department's average salary — combine a window function (AVG() OVER) with a CASE flag, then aggregate (COUNT/SUM with GROUP BY) to get the final percentage per department.

-- Basic (Aggregate functions)

-- 1. Find the total number of employees, total salary, and average salary in each department. Use COUNT, SUM, AVG with GROUP BY.

SELECT department,
	COUNT(*) AS Count_employees,
	SUM(salary) AS Total_salary,
	AVG(salary) AS Avg_salary
FROM employees_2
GROUP BY department;

-- 2. Find the department(s) where the average salary is greater than 60,000. Use GROUP BY + HAVING.

SELECT department,
	AVG(salary) AS avg_salary 
FROM employees_2
GROUP BY department
HAVING avg(salary) > 60000 ;

-- 3. Find the maximum and minimum salary in each department, and the salary range (max - min) per department.

SELECT department,
	MIN(salary) AS Min_salary,
	MAX(salary) AS Max_salary,
	MAX(salary) - MIN(salary) AS Range_salary
FROM employees_2
GROUP BY department;

-- Intermediate (Basic Window Functions)

/* 4. Rank employees within each department by salary (highest = rank 1) using RANK(). Also show DENSE_RANK() and ROW_NUMBER() 
side by side so you can see the difference on the tied salaries (e.g., Priya Mehta & Rohan Patel, both 62000). */

SELECT emp_name, department, salary,
    RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rank_salary,
    DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS dense_rank_salary,
    ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) AS row_num
FROM employees_2
ORDER BY department, salary DESC;

-- 5. For each employee, show their salary along with the department's average salary (using AVG(salary) OVER 
-- (PARTITION BY department)), and calculate how far their salary is from that average.

SELECT emp_name, department, salary,
	AVG(salary) OVER (PARTITION BY department) AS Avg_salary,
	salary - AVG(salary) OVER (PARTITION BY department) AS Range_salary
FROM employees_2
ORDER BY department, salary DESC;

-- 6. Calculate a running total (cumulative sum) of salaries within each department, ordered by join_date. Use SUM(salary) OVER (...).

SELECT emp_name, department, salary, join_date,
    SUM(salary) OVER (
        PARTITION BY department 
        ORDER BY join_date
        RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM employees_2
ORDER BY department, join_date;

-- Advanced (Combining aggregate + window logic)

-- 7. Find each employee's salary as a percentage of their department's total salary (i.e., salary / SUM(salary) OVER (PARTITION BY department) * 100).

SELECT emp_name, department, salary,
	SUM(salary) OVER (PARTITION BY department) AS Avg_salary,
	salary * 100 / SUM(salary) OVER (PARTITION BY department) AS Percetage_salary
FROM employees_2
ORDER BY department, salary ASC;


SELECT emp_name, department, salary,
    SUM(salary) OVER (PARTITION BY department) AS total_salary,
    ROUND(salary * 100.00/ SUM(salary) OVER (PARTITION BY department), 2) AS percentage_salary
FROM employees_2
ORDER BY department, salary ASC;

-- 8. Calculate a 2-hire moving average of salary within each department (average of current + previous hire's salary), using AVG(...) OVER (... ROWS BETWEEN 1 PRECEDING AND CURRENT ROW).

SELECT emp_name, department, salary, join_date,
    AVG(salary) OVER (
        PARTITION BY department 
        ORDER BY join_date
        ROWS BETWEEN 1 PRECEDING AND CURRENT ROW
    ) AS moving_avg_2
FROM employees_2
ORDER BY department, join_date;

-- 9. For each department, identify the top 2 highest-paid employees only (using RANK() or DENSE_RANK() wrapped in a CTE/subquery, filtered with WHERE rank <= 2).

WITH highest_rank_employees AS (
    SELECT emp_name, department, salary,
        RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rank_number,
        DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS dense_rank_number
    FROM employees_2
)
SELECT emp_name, department, salary, dense_rank_number
FROM highest_rank_employees
WHERE dense_rank_number <= 2;

-- 10. Find, for each department, what percentage of employees earn above the department's average salary — combine a window function (AVG() OVER) with a CASE flag, 
-- then aggregate (COUNT/SUM with GROUP BY) to get the final percentage per department.

WITH employee_flags AS (
    SELECT emp_name, department, salary,
        AVG(salary) OVER (PARTITION BY department) AS dept_avg,
        CASE 
            WHEN salary > AVG(salary) OVER (PARTITION BY department) THEN 1
            ELSE 0
        END AS above_avg_flag
    FROM employees_2
)
SELECT department,
    COUNT(*) AS total_employees,
    SUM(above_avg_flag) AS employees_above_avg,
    ROUND(SUM(above_avg_flag) * 100.0 / COUNT(*), 2) AS percentage_above_avg
FROM employee_flags
GROUP BY department;



	

