PRINT '-----------------------------------------------------';
PRINT 'Explore Various Tables and Coluns Within the Database';
PRINT '-----------------------------------------------------';

--Explore all objects in Database
SELECT * FROM INFORMATION_SCHEMA.TABLES

--Explore all columns in Database
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers' --exploration example 

PRINT '------------------------------------------------------------------';
PRINT 'Explore Country and Category Dimensions';
PRINT '------------------------------------------------------------------';

--Explore all countries our customers come from 
SELECT DISTINCT country FROM Gold.dim_customers 

--Explore all categories "The Major Divisions"
SELECT DISTINCT category, subcategory, product_name FROM Gold.dim_products 
ORDER BY 1, 2, 3

PRINT '------------------------------------------------------------------';
PRINT 'Explore Date Boundaries and Scope';
PRINT '------------------------------------------------------------------';

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
