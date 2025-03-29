PRINT '-----------------------------------------------------'
PRINT 'Explore various tables and coluns within the database'
PRINT '-----------------------------------------------------'
--Explore all objects in Database
SELECT * FROM INFORMATION_SCHEMA.TABLES

--Explore all columns in Database
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers' --exploration example 
