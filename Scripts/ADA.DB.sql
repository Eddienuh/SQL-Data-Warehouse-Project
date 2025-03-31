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

=======================================================================================
--CHANGE-OVER-TIME (TRENDS)
========================================================================================
--Track trends and uncover seasonality in our data over time
        
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

========================================================================
--CUMULATIVE ANALYSIS
========================================================================
--Calculate total sales per month
--and the running total of sales over time

--Value of total sales month on month
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

--Cumulative value of total sales year on year
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


--Moving average of total sales year on year
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
