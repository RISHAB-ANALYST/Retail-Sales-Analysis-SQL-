-- Exploring inconsistency in data

SELECT * FROM retail_sales
WHERE transactions_id IS NULL

-- transactions_id contains no NULL value
-- 

SELECT * FROM retail_sales
WHERE sale_date IS NULL

-- sale_date contains no NULL value
--

SELECT * FROM retail_sales
WHERE sale_time IS NULL

-- sale_time contains no NULL value
--

SELECT * FROM retail_sales
WHERE customer_id IS NULL

-- customer_id contains no NULL value
--

SELECT * FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL

-- Method to check all NULL values together from all columns in a single query

-- Data cleaning
DELETE from retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;
-- Deleted all the null columns


-- Answering the Business questions

--Easy Questions
--What is the total number of transactions recorded?

SELECT COUNT(transactions_id) AS total_transactions FROM retail_sales


-- Count the number of unique transactions_id?

SELECT COUNT(DISTINCT(transactions_id)) AS total_unique_transactions FROM retail_sales

-- What is the total sales revenue generated?

SELECT SUM(total_sale) AS revenue FROM retail_sales

--What are the most popular product categories?

-- Popularity is based on quantity sold per category

SELECT category, SUM(quantity) FROM retail_sales
GROUP BY  category

-- Count the occurrences of each category and rank them.

SELECT category,COUNT(category) FROM retail_sales
GROUP BY category 
ORDER BY category DESC

-- What is the average price per unit across all transactions?

SELECT AVG(price_per_unit) FROM retail_sales


--What is the average quantity of items purchased per transaction?

SELECT AVG(quantity) FROM retail_sales 


-- What is the total number of sales?
SELECT COUNT(*) AS total_sale FROM retail_sales
SELECT * FROM retail_sales

-- What is the total number of each category sold?

SELECT DISTINCT category,COUNT(*) AS category FROM retail_sales
GROUP BY category

-- ok NOW SOLVING THE QUESTIONS RELATED TO DATA TO ANSWER BUSINESS QUERIES
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

SELECT * 
	FROM retail_sales
WHERE 
	category='Clothing' 
AND 
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
AND 
	quantity >= 4;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT category, 
	SUM(total_sale) AS net_sales, 
	COUNT(*) AS total_orders 
	FROM retail_sales
GROUP BY category

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT ROUND(AVG(age),2) 
FROM retail_sales
WHERE category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT transactions_id,total_sale FROM retail_sales
WHERE total_sale >1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT category,gender,COUNT(transactions_id) FROM retail_sales
GROUP BY category, gender
-- How much revenue is generated by each gender in each category?

SELECT gender,category,SUM(total_sale) AS revenue FROM retail_sales
GROUP BY gender, category 
ORDER BY gender, revenue 

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out the best-selling month in each year

SELECT year,month,avg_sales FROM
(
	SELECT 
		EXTRACT(YEAR FROM sale_date) AS year,
		EXTRACT(MONTH FROM sale_date) AS month,
		AVG(total_sale) as avg_sales,
		--Window function
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC)
	FROM retail_sales
	GROUP BY 1, 2
) AS t1
WHERE rank = 1


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT customer_id, SUM(total_sale) AS sales FROM retail_sales
GROUP BY customer_id
ORDER BY sales DESC 
LIMIT 5

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT category,COUNT(DISTINCT(customer_id)) AS count_unique_cs FROM retail_sales
GROUP BY category

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

-- Using CTE (Common table expression)

WITH hourly_sales
AS
(
SELECT *,
	CASE 
		WHEN EXTRACT(HOUR FROM sale_time)< 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS shift	
FROM retail_sales
)

SELECT shift,COUNT(transactions_id) FROM hourly_sales
GROUP BY shift

-- end of the project-- 