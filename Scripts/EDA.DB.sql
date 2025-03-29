PRINT '-----------------------------------------------------';
PRINT 'Explore various tables and coluns within the database';
PRINT '-----------------------------------------------------';

--Explore all objects in Database
SELECT * FROM INFORMATION_SCHEMA.TABLES

--Explore all columns in Database
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers' --exploration example 

PRINT '------------------------------------------------------------------';
PRINT 'Explore country and category dimensions';
PRINT '------------------------------------------------------------------';

--Explore all countries our customers come from 
SELECT DISTINCT country FROM Gold.dim_customers 

--Explore all categories "The Major Divisions"
SELECT DISTINCT category, subcategory, product_name FROM Gold.dim_products 
ORDER BY 1, 2, 3
