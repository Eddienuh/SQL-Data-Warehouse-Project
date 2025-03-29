/*
======================================================================
Exploratory Data Analysis
======================================================================
Script Purpose:
	This script contains multiple queries designed to explore various tables within our database.
	The goal is to answer business-related analytical questions by querying the data and extracting relevant insights.
======================================================================
*/

--DATABASE EXPLORATION OF COLUMNS & TABLES

--Explore all objects in Database
SELECT * FROM INFORMATION_SCHEMA.TABLES

--Explore all columns in Database
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers' --exploration example 
-----------------------------------------------------------------------------------------------

--DIMENSION EXPLORATION OF COUNTRIES & CATEGORIES

--Explore all countries our customers come from 
SELECT DISTINCT country FROM Gold.dim_customers 

--Explore all categories "The Major Divisions"
SELECT DISTINCT category, subcategory, product_name FROM Gold.dim_products 
ORDER BY 1, 2, 3
-------------------------------------------------------------------------------------------------

--DATE EXPLORATION

--Find the date of the first and last order
--Find how many years of sales data is available 

SELECT 
	MIN(order_date) AS first_order,
	MAX(order_date) AS last_order,
	DATEDIFF(YEAR, MIN(order_date), MAX(order_date)) AS order_range_years,
	DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS order_range_months
	FROM Gold.fact_sales


--Find the youngest and the oldest customer
SELECT
	MIN(birthdate) AS oldest_customer,
	DATEDIFF (YEAR, MIN(birthdate), GETDATE ()) AS oldest_customer_age,
	MAX(birthdate) AS youngest_customer,
	DATEDIFF (YEAR, MAX(birthdate), GETDATE ()) AS youngest_customer_age
	FROM Gold.dim_customers
----------------------------------------------------------------------------------------------------
	
--MEASURE EXPLORATION OF KEY BUSINESS METRICS

--Find total sales
SELECT SUM(sales_amount) AS total_sales FROM Gold.fact_sales

--Find how many items are sold
SELECT SUM(quantity) AS total_quantity FROM Gold.fact_sales

--Find the average selling price
SELECT AVG(price) AS avg_price FROM Gold.fact_sales

--Find the total number of orders
SELECT COUNT(DISTINCT order_number) AS total_orders FROM Gold.fact_sales --We use the Distict function to eliminate duplicates
                                                                         --& batch/bundle orders 

--Find the total number of products
SELECT COUNT(product_key) AS total_products FROM Gold.dim_products
SELECT COUNT(DISTINCT product_key) AS total_products FROM Gold.dim_products

--Find the total number of customers
SELECT COUNT(customer_id) AS total_customers FROM Gold.dim_customers

--Find the total number of customers that have placed an order
SELECT COUNT(DISTINCT customer_key) AS orders_placed FROM Gold.fact_sales

--Generate a report that shows all key metrics of the business

SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value FROM Gold.fact_sales
UNION ALL
SELECT 'Total Quantity', SUM(quantity) FROM Gold.fact_sales
UNION ALL
SELECT 'Average Price', AVG(price) FROM Gold.fact_sales
UNION ALL
SELECT 'Total Num Orders', COUNT(DISTINCT order_number) FROM Gold.fact_sales
UNION ALL
SELECT 'Total Num Products', COUNT(product_name) FROM Gold.dim_products
UNION ALL
SELECT 'Total Num Customers', COUNT(customer_key) FROM Gold.dim_customers;
-------------------------------------------------------------------------------------------------------------------

--MAGNITUDE: GENERATING KEY BUSINESS METRICS USING MEASURES AND DIMENSIONS

--Find total customers by country
SELECT 
country,
COUNT (customer_key) AS total_customers
FROM Gold.dim_customers
GROUP BY country
ORDER BY total_customers DESC

--Find total customers by gender
SELECT 
gender,
COUNT (customer_key) AS total_customers
FROM Gold.dim_customers
GROUP BY gender
ORDER BY total_customers DESC

--Find total products by category
SELECT 
category,
COUNT(product_key) AS total_products
FROM Gold.dim_products
GROUP BY category
ORDER BY total_products DESC

--What is the average cost in each category? 
SELECT
category,
AVG(cost) AS avg_cost
FROM Gold.dim_products
GROUP BY category
ORDER BY avg_cost DESC

--What is the total revenue generated by each category?
SELECT
p.category,
SUM (f.sales_amount) AS total_revenue
FROM Gold.fact_sales f
LEFT JOIN
Gold.dim_products p
ON p.product_key = f.product_key
GROUP BY p.category
ORDER BY total_revenue DESC

--What is the total revenue generated by each customer?
SELECT
c.customer_key,
c.first_name,
c.last_name,
SUM(f.sales_amount) AS total_revenue 
FROM Gold.fact_sales f
LEFT JOIN
Gold.dim_customers c
ON c.customer_key = f.customer_key
GROUP BY 
c.customer_key,
c.first_name,
c.last_name
ORDER BY total_revenue DESC

--What is the distribution of sold items across countries? 
SELECT
c.country,
SUM(f.quantity) AS total_sold_items
FROM Gold.fact_sales f
LEFT JOIN
Gold.dim_customers c
ON c.customer_key = f.customer_key
GROUP BY c.country
ORDER BY total_sold_items DESC
--------------------------------------------------------------------------------------

--RANKING PRODUCTS BY PERFORMANCE

--Which 5 products generate the highest revenue?
SELECT TOP 5
p.product_name, --dimensions are interchangeable for further qeuries
SUM (f.sales_amount) AS total_revenue
FROM Gold.fact_sales f
LEFT JOIN
Gold.dim_products p
ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC

--solution using windows function (for more complex reports)
SELECT *
FROM (
	SELECT
	p.product_name, 
	SUM (f.sales_amount) AS total_revenue,
	RANK () OVER (ORDER BY SUM (f.sales_amount) DESC) AS rank_products
	FROM Gold.fact_sales f
	LEFT JOIN Gold.dim_products p
	ON p.product_key = f.product_key
	GROUP BY p.product_name)t
WHERE rank_products <= 5



--What are the 5 worst-performing products in terms of sales?
SELECT TOP 5
p.product_name,
SUM (f.sales_amount) AS total_revenue
FROM Gold.fact_sales f
LEFT JOIN
Gold.dim_products p
ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue 

--Find the top 10 customers who have generated the highest sales
SELECT TOP 10
c.customer_key,
c.first_name,
c.last_name,
SUM(f.sales_amount) AS total_revenue 
FROM Gold.fact_sales f
LEFT JOIN
Gold.dim_customers c
ON c.customer_key = f.customer_key
GROUP BY 
c.customer_key,
c.first_name,
c.last_name
ORDER BY total_revenue DESC

--Find the top 3 customers who have generated the lowest sales
SELECT TOP 3
c.customer_key,
c.first_name,
c.last_name,
COUNT (DISTINCT order_number) AS total_orders
FROM Gold.fact_sales f
LEFT JOIN
Gold.dim_customers c
ON c.customer_key = f.customer_key
GROUP BY 
c.customer_key,
c.first_name,
c.last_name
ORDER BY total_orders 



