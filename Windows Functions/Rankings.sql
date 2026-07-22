SELECT * FROM employees_1;

-- Ranking
-- ROW_NUMBER()	 — unique sequential number
-- RANK() 		 — ties share rank, skips next
-- DENSE_RANK()  — ties share rank, no skip
-- NTILE(n)	     — splits into n buckets

-- Row Number according to different departments
SELECT name, department,salary,
	ROW_NUMBER() OVER(PARTITION BY department ORDER BY salary) AS Row_Number
FROM employees_1;

-- Rank 
SELECT name, department, salary,
	RANK() OVER(PARTITION BY department ORDER BY salary) AS Rank_Number
FROM employees_1;

-- Dense Rank 
SELECT name, department, salary,
	DENSE_RANK() OVER(PARTITION BY department ORDER BY salary DESC) AS Dense_rank
FROM employees_1;

-- Ntile(n) 
-- NTILE(n) divides the rows in a partition into n roughly equal-sized groups (buckets) and assigns each row a bucket number from 1 to n.
-- Think of it like: "line up all the rows in order, then cut the line into n equal pieces."

SELECT name, department, salary,
	ntile(2) OVER(PARTITION BY department ORDER BY salary) AS Salry_tier
FROM employees_1;