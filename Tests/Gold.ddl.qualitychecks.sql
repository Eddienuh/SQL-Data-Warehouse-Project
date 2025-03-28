/*
=============================================================================
Quality Checks for Gold Layer:
=============================================================================
Script Purpose: 
        This script performs quality checks to validate the integrity, consistency,
        and accuracy of the Gold Layer. These checks ensure:
        - Uniqueness of surrogate keys in dimension tables.
        - Referential integrity between fact and dimension tables.
        - validation of relationships in the data model for analytical purposes.

Usage Notes: 
        - Run these checks after data loading Silver Layer.
        - Investigate and resolve any discrepancies found during the checks. 
============================================================================
*/

PRINT '=================================================='
PRINT 'Quality check for Gold.dim_customers'
PRINT '=================================================='

--Check for uniqueness of product_key in Gold.dim_customers
--Expectation: No Result

SELECT 
	customer_key,
	COUNT (*) AS duplicate_count
	FROM Gold.dim_customers 
	GROUP BY customer_key
	HAVING COUNT (*) > 1


PRINT '=================================================='
PRINT 'Quality check for Gold.dim_products'
PRINT '=================================================='

--Check for uniqueness of product_key in Gold.dim_products
--Expectation: No Result

SELECT 
	product_key,
	COUNT (*) AS duplicate_count
	FROM Gold.dim_products 
	GROUP BY product_key
	HAVING COUNT (*) > 1


PRINT '=================================================='
PRINT 'Quality check for Gold.fact_sales'
PRINT '=================================================='

--Check data model connectivity between fact table and dimension tables

SELECT * 
	FROM Gold.fact_sales f
	LEFT JOIN Gold.dim_customers c
	ON c.customer_key = f.customer_key
	LEFT JOIN Gold.dim_products d
	ON d.product_key = f.product_key
	WHERE d.product_key IS NULL
	OR c.customer_key IS NULL 
