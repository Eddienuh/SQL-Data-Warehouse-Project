/*
=========================================================================================
Adavanced Data Analytics
=========================================================================================
Script Purpose:
        This script progresses on from the EDA script, providing more advanced queries to
        further analyse our data in order to uncover trends in our business over time.

Usage:  Queries can be adjusted using appropriate window functions to analyse business trends 
        and support informed decision-making.
*/

---------------------------------------------------------------------------------------
--CHANGE-OVER-TIME (TRENDS)
---------------------------------------------------------------------------------------
--Task: Track trends and uncover seasonality in our data over time
        
--Solution 1        
SELECT
YEAR(order_date) AS order_year,
MONTH(order_date) AS order_month, 
SUM(sales_amount) AS total_sales,
COUNT (DISTINCT customer_key) AS total_customers,
SUM(quantity) AS total_quantity
FROM Gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date)


--Solution 2
SELECT
DATETRUNC(month, order_date) AS order_date,
SUM(sales_amount) AS total_sales,
COUNT (DISTINCT customer_key) AS total_customers,
SUM(quantity) AS total_quantity
FROM Gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_date)
ORDER BY DATETRUNC(month, order_date)

	
--Solution 3
SELECT
FORMAT(order_date, 'yyyy-MMM') AS order_date,
SUM(sales_amount) AS total_sales,
COUNT (DISTINCT customer_key) AS total_customers,
SUM(quantity) AS total_quantity
FROM Gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY FORMAT(order_date, 'yyyy-MMM')
ORDER BY FORMAT(order_date, 'yyyy-MMM')

------------------------------------------------------------------------
--CUMULATIVE ANALYSIS
------------------------------------------------------------------------
--Formula: [cumulative measure] by [date dimension] 
	
--Task: Calculate total sales per month
--and the running total of sales over time

--1. Find the value of total sales month on month
SELECT
order_date,
total_sales,
SUM(total_sales) OVER (PARTITION BY order_date ORDER BY order_date) AS running_total_sales --Window function for cumalitive measure
FROM 
(
	SELECT 
	DATETRUNC(MONTH, order_date) AS order_date,
	SUM(sales_amount) AS total_sales
	FROM Gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY DATETRUNC(MONTH, order_date)
)t

	
--2. Find the cumulative value of total sales year on year
SELECT
order_date,
total_sales,
SUM(total_sales) OVER (ORDER BY order_date) AS running_total_sales --Window function for cumalitive measure
FROM 
(
	SELECT 
	DATETRUNC(YEAR, order_date) AS order_date,
	SUM(sales_amount) AS total_sales
	FROM Gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY DATETRUNC(YEAR, order_date)
)t


--3. Calculate the moving average of total sales year on year
SELECT
order_date,
total_sales,
SUM(total_sales) OVER (ORDER BY order_date) AS running_total_sales,--Window function for cumalitive measure
AVG(avg_price) OVER (ORDER BY order_date) AS moving_avg_price     --Window function for moving average
FROM 
(
	SELECT 
	DATETRUNC(YEAR, order_date) AS order_date,
	SUM(sales_amount) AS total_sales,
	AVG(price) AS avg_price
	FROM Gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY DATETRUNC(YEAR, order_date)
)t


------------------------------------------------------------------
--PERFORMANCE ANALYSIS (YEAR ON YEAR)
------------------------------------------------------------------
--Formula: current[measure] - target[measure] 

--Task:Analyse the yearly performance of products by comparing each products
--sales to both its average sales performance and previous years sales

--1. Find the current yearly sales for each product 

WITH yearly_products_sales AS (
	SELECT
	YEAR(f.order_date) AS order_year,
	p.product_name,
	SUM(f.sales_amount) AS current_sales
	FROM Gold.fact_sales f
	LEFT JOIN Gold.dim_products p 
	ON f.product_key = p.product_key
	WHERE order_date IS NOT NULL
	GROUP BY
	YEAR(f.order_date),
	p.product_name
)

	
--2. Find the average yearly sales for each product 
SELECT 
	order_year,
	product_name,
	current_sales,
	AVG(current_sales) OVER (PARTITION BY product_name) AS avg_sales,
	current_sales - AVG(current_sales) OVER (PARTITION BY product_name) AS diff_avg,
	CASE 
		WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) > 0
		THEN 'Above Avg'
		WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) < 0
		THEN 'Below Avg'
		ELSE 'Avg'
	END avg_change,

--2b. Compare current years sales to previous year sales
	LAG (current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS prev_yr_sales,
	current_sales - LAG (current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS diff_per_yr,
	CASE 
		WHEN current_sales - LAG (current_sales) OVER (PARTITION BY product_name ORDER BY order_year) > 0
		THEN 'Increase'
		WHEN current_sales - LAG (current_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0
		THEN 'Decrease'
		ELSE 'Unchanged'
	END prev_yr_change
	FROM yearly_products_sales
	ORDER BY product_name, order_year
