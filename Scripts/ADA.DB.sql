/*
=========================================================================================
Adavanced Data Analytics
=========================================================================================
Script Purpose:
        This script progresses on from the EDA script, providing more advanced queries to
        further analyse our data in order to uncover trends in our business over time.
*/



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
