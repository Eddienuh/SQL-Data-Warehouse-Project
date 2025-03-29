/*
======================================================================
Exploratory Data Analysis
======================================================================
Script Purpose:
	This script contains multiple queries designed to explore various tables within our database.
	The goal is to answer business-related analytical questions by querying the data and extracting relevant insights.
======================================================================
*/

--EXPLORING COLUMNS & TABLES WITHIN THE DATABASE

--Explore all objects in Database
SELECT * FROM INFORMATION_SCHEMA.TABLES

--Explore all columns in Database
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers' --exploration example 
-----------------------------------------------------------------------------------------------

--EXPLORING COUNTRY & CATEGORY DIMENSIONS

--Explore all countries our customers come from 
SELECT DISTINCT country FROM Gold.dim_customers 

--Explore all categories "The Major Divisions"
SELECT DISTINCT category, subcategory, product_name FROM Gold.dim_products 
ORDER BY 1, 2, 3
-------------------------------------------------------------------------------------------------

--EXPLORING DATE BOUNDARIES

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
	
--GENERATING KEY BUSINESS METRICS

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

