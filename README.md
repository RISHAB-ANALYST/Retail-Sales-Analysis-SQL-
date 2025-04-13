# Retail-Sales-Analysis-SQL-
text
# Retail Sales Data Analysis Project

## Overview

This project involves analyzing retail sales data using SQL to answer various business-oriented questions. The dataset includes information on transactions, sales dates, customer details, product categories, quantities, prices, costs, and total sales.

## Data Schema

The `retail_sales` table includes the following columns:

- `transactions_id`: Unique identifier for each transaction
- `sale_date`: Date of the sale
- `sale_time`: Time of the sale
- `customer_id`: Identifier for the customer
- `gender`: Gender of the customer
- `age`: Age of the customer
- `category`: Product category
- `quantity`: Quantity of items sold
- `price_per_unit`: Price per unit of the item
- `cogs`: Cost of goods sold
- `total_sale`: Total sale amount

## Project Structure

The project is structured as follows:

1.  **Data Exploration**:
    *   Checking for inconsistencies and NULL values in the data.

2.  **Data Cleaning**:
    *   Removing rows with NULL values.

3.  **Business Questions**:
    *   Answering a variety of business-oriented questions using SQL queries.

## SQL Queries

### Data Exploration

*   Checking for NULL values in each column:

SELECT * FROM retail_sales WHERE transactions_id IS NULL;
SELECT * FROM retail_sales WHERE sale_date IS NULL;
SELECT * FROM retail_sales WHERE sale_time IS NULL;
SELECT * FROM retail_sales WHERE customer_id IS NULL;

text

*   Method to check all NULL values together from all columns in a single query

SELECT * FROM retail_sales
WHERE transactions_id IS NULL
OR sale_date IS NULL
OR sale_time IS NULL
OR customer_id IS NULL
OR gender IS NULL
OR age IS NULL
OR category IS NULL
OR quantity IS NULL
OR price_per_unit IS NULL
OR cogs IS NULL
OR total_sale IS NULL;

text

### Data Cleaning

*   Deleting rows with any NULL values:

DELETE FROM retail_sales
WHERE transactions_id IS NULL
OR sale_date IS NULL
OR sale_time IS NULL
OR customer_id IS NULL
OR gender IS NULL
OR age IS NULL
OR category IS NULL
OR quantity IS NULL
OR price_per_unit IS NULL
OR cogs IS NULL
OR total_sale IS NULL;

text

### Business Questions and SQL Queries

#### Easy Questions

1.  **What is the total number of transactions recorded?**

SELECT COUNT(transactions_id) AS total_transactions FROM retail_sales;

text

2.  **Count the number of unique transactions_id?**

SELECT COUNT(DISTINCT(transactions_id)) AS total_unique_transactions FROM retail_sales;

text

3.  **What is the total sales revenue generated?**

SELECT SUM(total_sale) AS revenue FROM retail_sales;

text

4.  **What are the most popular product categories? (Popularity based on quantity sold per category)**

SELECT category, SUM(quantity) FROM retail_sales GROUP BY category;

text

*   Alternative: Count the occurrences of each category

SELECT category, COUNT(category) FROM retail_sales GROUP BY category ORDER BY category DESC;

text

5.  **What is the average price per unit across all transactions?**

SELECT AVG(price_per_unit) FROM retail_sales;

text

6.  **What is the average quantity of items purchased per transaction?**

SELECT AVG(quantity) FROM retail_sales;

text

#### Medium Questions

1.  **Write a SQL query to retrieve all columns for sales made on '2022-11-05'**

SELECT * FROM retail_sales WHERE sale_date = '2022-11-05';

text

2.  **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**

SELECT *
FROM retail_sales
WHERE category = 'Clothing'
AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
AND quantity >= 4;

text

3.  **Write a SQL query to calculate the total sales (total_sale) for each category.**

SELECT category,
SUM(total_sale) AS net_sales,
COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;

text

4.  **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**

SELECT ROUND(AVG(age), 2)
FROM retail_sales
WHERE category = 'Beauty';

text

5.  **Write a SQL query to find all transactions where the total_sale is greater than 1000.**

SELECT transactions_id, total_sale
FROM retail_sales
WHERE total_sale > 1000;

text

#### Hard Questions

1.  **Write a SQL query to calculate the average sale for each month and find out the best-selling month in each year**

SELECT year, month, avg_sales
FROM (
SELECT EXTRACT(YEAR FROM sale_date) AS year,
EXTRACT(MONTH FROM sale_date) AS month,
AVG(total_sale) as avg_sales,
RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC)
FROM retail_sales
GROUP BY 1, 2
) AS t1
WHERE rank = 1

text

2.  **Write a SQL query to find the top 5 customers based on the highest total sales**

SELECT customer_id, SUM(total_sale) AS sales
FROM retail_sales
GROUP BY customer_id
ORDER BY sales DESC
LIMIT 5;

text

3.  **Write a SQL query to find the number of unique customers who purchased items from each category.**

SELECT category, COUNT(DISTINCT (customer_id)) AS count_unique_cs
FROM retail_sales
GROUP BY category;

text

4.  **Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)**

WITH hourly_sales AS (
SELECT *,
CASE
WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
ELSE 'Evening'
END AS shift
FROM retail_sales
)
SELECT shift, COUNT(transactions_id)
FROM hourly_sales
GROUP BY shift;

text

## Conclusion

This project demonstrates the use of SQL to analyze retail sales data and extract valuable insights for business decision-making. By exploring and cleaning the data, and then answering specific business-oriented questions, this project provides a comprehensive overview of how SQL can be used in a retail context.
