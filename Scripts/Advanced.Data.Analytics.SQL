/*
=========================================================================================
Adavanced Data Analytics
=========================================================================================
Script Purpose:
        This script progresses on from the EDA script, providing more advanced queries to
        further analyse our data in order to uncover trends in our business. Each ADA section 
	includes a business-related task, our logic for the solution (formula), 
	and a step-by-step approach to solving it.

Usage:  Queries can be tailored to analyze various business metrics, leveraging window 
	functions to identify trends and support data-driven decision-making.
*/

---------------------------------------------------------------------------------------
--CHANGE-OVER-TIME (TRENDS)
---------------------------------------------------------------------------------------

--Task: Track trends and uncover seasonality in our data over time
--Formula: [measure] by [date dimension]
        
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
--Task: Calculate total sales per month
--and the running total of sales over time
	
--Formula: [cumulative measure] by [date dimension] 
	
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
--Task:Analyse the yearly performance of products by comparing each products
--sales to both its average sales performance and previous years sales
	
--Formula: current[measure] - target[measure] 

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
	
--2. Find the average yearly sales for each product using CTE window function 
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

--2b. Compare current year sales to previous year sales
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


------------------------------------------------------------------
--PART-TO-WHOLE ANALYSIS
------------------------------------------------------------------
--Task: Which categories contribute the most to overall sales	
--Formula: ([measure]/total[measure])*100 by [dimension]

-- 1. Select relevant information: Retrieve category and sales_amount
SELECT
    category,
    sales_amount
FROM Gold.fact_sales f
LEFT JOIN Gold.dim_products p
    ON f.product_key = p.product_key;

-- 2. Calculate total sales for each category
SELECT
    category,
    SUM(sales_amount) AS total_sales
FROM Gold.fact_sales f
LEFT JOIN Gold.dim_products p
    ON f.product_key = p.product_key
GROUP BY category;

-- 3. Calculate overall sales using CTE windows function
WITH category_sales AS (
    -- Calculate total sales for each category
    SELECT
        category,
        SUM(sales_amount) AS total_sales
    FROM Gold.fact_sales f
    LEFT JOIN Gold.dim_products p
        ON f.product_key = p.product_key
    GROUP BY category
)
-- 3b. Divide total sales by overall sales * 100 to get the part-to-whole percentage
SELECT 
    category,
    total_sales,
    SUM(total_sales) OVER () AS overall_sales,  -- Total sales across all categories
    CONCAT(ROUND((CAST(total_sales AS FLOAT) / SUM(total_sales) OVER ())*100, 2), '%') AS percentage_of_total  -- Percentage of total sales
FROM category_sales
ORDER BY total_sales DESC


---------------------------------------------------------------------
--DATA SEGMENTATION
---------------------------------------------------------------------

--Formula: [measure] by [measure]

--Task 1: segment products into cost ranges and count how
--many prodcuts fall into each segment

--1. create cost range column and aggregate the data based on cost range dimension

WITH product_segments AS (
	SELECT
		product_key,
		product_name,
		cost,
		CASE 
			WHEN cost < 100 THEN 'Below 100'
			WHEN cost BETWEEN 100 AND 500 THEN '100-500'
			WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
			WHEN cost BETWEEN 1000 AND 1500 THEN '1000-1500'
			ELSE 'Above 1500'
		END cost_range
	FROM Gold.dim_products)
--1b. aggregate the data based on cost range dimension
SELECT 
cost_range,
COUNT(product_key) AS total_products
FROM product_segments
GROUP BY cost_range 
ORDER BY total_products DESC


--Task 2. Group customers into three segments based on their spending behaviour
			-- VIP: customers with atleast 12 months of hgistory and spending more than £5000
			--Regular: customers with atleast 12 months of history but spending £5000 or less
			--New: customers with a life span of less than 12 months
			--And find the total number of customers for each group

--1.Select relevant information
WITH 
	customer_spending AS (	
	SELECT 
	c.customer_key,
	SUM(f.sales_amount) AS total_spend, --Find total spent for each customer
	MIN(order_date) AS first_order, --Find oldest and most recent order 
	MAX(order_date) AS last_order,
	DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan --Find lifespan in months
	FROM Gold.fact_sales f
	LEFT JOIN Gold.dim_customers c
	ON c.customer_key = f.customer_key
	GROUP BY c.customer_key)

--1b.Create segments based on results and find total number of customers for each segment
SELECT
customer_segment,
COUNT(customer_key) AS total_customers
FROM(
	SELECT 
	customer_key,
	CASE
		WHEN lifespan >= 12 AND total_spend > 5000 THEN 'VIP'
		WHEN lifespan >= 12 AND total_spend <= 5000 THEN 'Regular'
		ELSE 'New'
	END customer_segment
FROM customer_spending) t
GROUP BY customer_segment
ORDER BY total_customers DESC


