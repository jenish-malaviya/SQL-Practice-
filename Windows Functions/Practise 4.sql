SELECT * FROM employees_2;

-- Basic

-- 1. For each department, calculate PERCENT_RANK() of employees based on salary (ascending order). Observe what value the lowest-paid employee gets.
-- 2. For each department, calculate CUME_DIST() of employees based on salary (ascending order). Observe what value the highest-paid employee gets.
-- 3. Show PERCENT_RANK() and CUME_DIST() side by side for the same department, ordered by salary, and note the difference in values for the same row.

-- Intermediate

-- 4. For each department, find employees whose PERCENT_RANK() is greater than 0.5 (i.e., in the top half by salary within their department).
-- 5. For each department, find employees whose CUME_DIST() is less than or equal to 0.5 (i.e., in the bottom 50% by salary, inclusive).
-- 6. Using tied salaries (e.g., Priya Mehta & Rohan Patel, both 62000 in Sales), compare how PERCENT_RANK() and CUME_DIST() handle the tie differently — do they give the same value to both tied rows, or different?

-- Advanced

-- 7. For each department, identify employees in the "top 25%" by salary using PERCENT_RANK() >= 0.75, and compare this result against using CUME_DIST() >= 0.75 on the same data — are the returned employees the same or different?
-- 8. Combine PERCENT_RANK() with a CASE statement to label each employee as 'Top Tier' (percent_rank >= 0.75), 'Mid Tier' (0.25–0.75), or 'Low Tier' (< 0.25) within their department.
-- 9. For each department, find the employee(s) at exactly CUME_DIST() = 1 — explain in your query/comments why this will always be the highest-paid employee(s) in that department (including ties).
-- 10. Wrap a PERCENT_RANK() calculation in a CTE, then in the outer query use GROUP BY to count how many employees fall above vs. below the department median (percent_rank > 0.5 vs <= 0.5) — producing one summary row per department.


-- Basic

-- 1 For each department, calculate PERCENT_RANK() of employees based on salary (ascending order). Observe what value the lowest-paid employee gets.

SELECT emp_name, department, salary,
	PERCENT_RANK() OVER (PARTITION BY department ORDER BY salary ASC) AS Percentage_Rank
FROM employees_2;

-- 2. For each department, calculate CUME_DIST() of employees based on salary (ascending order). Observe what value the highest-paid employee gets.
-- CUME_DIST() = (number of rows with value <= current row's value) / (total rows in partition)

SELECT emp_name, department, salary,
	DENSE_RANK() OVER (PARTITION BY department ORDER BY salary) AS Rank_num,
	CUME_DIST() OVER (PARTITION BY department ORDER BY salary ASC) cumulative_desk
FROM employees_2;

-- 3. Show PERCENT_RANK() and CUME_DIST() side by side for the same department, ordered by salary, and note the difference in values for the same row.

SELECT emp_name, department, salary,
	PERCENT_RANK() OVER (PARTITION BY department ORDER BY salary ASC) AS Percetage_rank,
	CUME_DIST() OVER (PARTITION BY department ORDER BY salary ASC) AS cumalative_Percentage_rank
FROM employees_2;


-- Intermediate

-- 4. For each department, find employees whose PERCENT_RANK() is greater than 0.5 (i.e., in the top half by salary within their department).

WITH Rankeed_employee AS (
	SELECT emp_name, department, salary,
		PERCENT_RANK() OVER (PARTITION BY department ORDER BY salary ASC) AS Percentage_Number
	FROM employees_2
)
SELECT emp_name,department, salary, Percentage_Number
FROM Rankeed_employee
WHERE Percentage_Number > 0.5;

-- 5. For each department, find employees whose CUME_DIST() is less than or equal to 0.5 (i.e., in the bottom 50% by salary, inclusive).

WITH rankeed_employee AS (
	SELECT emp_name,department,salary,
	CUME_DIST() OVER (PARTITION BY department ORDER BY salary ASC) AS Cumalative_rank
	FROM employees_2
)
SELECT emp_name,department, salary, Cumalative_rank
FROM rankeed_employee
WHERE Cumalative_rank <= 0.5;

-- 6. Using tied salaries (e.g., Priya Mehta & Rohan Patel, both 62000 in Sales), compare how PERCENT_RANK() and CUME_DIST() handle the tie differently 
-- — do they give the same value to both tied rows, or different?

-- PERCENT_RANK() = (rank - 1) / (total_rows_in_partition - 1)
-- CUME_DIST() = (number of rows with value <= current row's value) / (total rows in partition)

SELECT emp_name, department, salary,
	PERCENT_RANK() OVER (PARTITION BY department ORDER BY salary) AS percentage_rank,
	CUME_DIST() OVER (PARTITION BY department ORDER BY salary) AS Cumalative_rank
FROM employees_2
ORDER BY department, salary;

-- Advanced

-- 7. For each department, identify employees in the "top 25%" by salary using PERCENT_RANK() >= 0.75, and compare this result against using CUME_DIST() >= 0.75 on the same data — 
-- are the returned employees the same or different?

WITH Percentage_rank AS (
	SELECT emp_name, department, salary,
		PERCENT_RANK() OVER (PARTITION BY department ORDER BY salary ASC) AS Per_rank
	FROM employees_2
)
SELECT * 
FROM Percentage_rank
WHERE Per_rank >= 0.75;

WITH Cumalative_rank AS (
	SELECT emp_name, department, salary,
	CUME_DIST() OVER (PARTITION BY department ORDER BY salary ASC) AS Cum_rank
	FROM employees_2
) 
SELECT * 
FROM Cumalative_rank
WHERE Cum_rank >= 0.75;

-- 8. Combine PERCENT_RANK() with a CASE statement to label each employee as 'Top Tier' (percent_rank >= 0.75), 'Mid Tier' (0.25–0.75), or 'Low Tier' (< 0.25) within their department.

WITH Percentage_rank AS (
	SELECT emp_name, department, salary,
	PERCENT_RANK() OVER (PARTITION BY department ORDER BY salary) AS Percentage_Rank
	FROM employees_2
)
SELECT emp_name, department, salary, Percentage_rank,
	CASE 
		WHEN Percentage_Rank >= 0.75 THEN 'Top Tier'
		WHEN Percentage_Rank BETWEEN 0.25 AND 0.75 THEN 'Mid Tier'
		ELSE 'Low Tier'
	END AS salary_tier
FROM Percentage_rank
ORDER BY department, salary;

-- 9. For each department, find the employee(s) at exactly CUME_DIST() = 1 — explain in your query/comments why this will always be the highest-paid employee(s) in that department (including ties).

WITH Cumalative_rank AS (
	SELECT emp_name, department, salary,
		CUME_DIST() OVER (PARTITION BY department ORDER BY salary) AS Rank_number
	FROM employees_2
)
SELECT emp_name, department, salary, Rank_number
FROM Cumalative_rank
WHERE Rank_number = 1
ORDER BY department, salary;

-- 10. Wrap a PERCENT_RANK() calculation in a CTE, then in the outer query use GROUP BY to count how many employees fall above vs. 
-- below the department median (percent_rank > 0.5 vs <= 0.5) — producing one summary row per department.

WITH Percent_ranking AS (
	SELECT emp_name, department, salary,
		PERCENT_RANK() OVER (PARTITION BY department ORDER BY salary) AS Percentage_rank
	FROM employees_2
),
flagged AS (
	SELECT emp_name, department, salary, Percentage_rank,
		CASE 
			WHEN Percentage_rank > 0.5 THEN 1
			ELSE 0
		END AS Median_flag
	FROM Percent_ranking
)
SELECT department,
	COUNT(*) AS Total_employees,
	SUM(Median_flag) AS above_median_count,
	COUNT(*) - SUM(Median_flag) AS Below_or_at_median_count
FROM flagged
GROUP BY department;




