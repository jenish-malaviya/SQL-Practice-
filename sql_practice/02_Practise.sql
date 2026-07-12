SELECT * FROM products;
-- Q1
SELECT product_id, price FROM products;

--Q2
SELECT *
FROM products
WHERE category = 'Electronics';

--Q3
SELECT category
FROM products
GROUP BY category;

--Q4
SELECT category, COUNT(*) 
FROM products
GROUP BY category 
HAVING COUNT(*) >= 1;

--Q5
SELECT *
FROM products
ORDER BY price
ASC;

--Q6
SELECT * 
FROM products
LIMIT 3;

--Q7
SELECT product_name AS item_Name, price AS item_Price
FROM products;

--Q8
SELECT category
FROM products
GROUP BY category;
--&
SELECT DISTINCT category
FROM products;
