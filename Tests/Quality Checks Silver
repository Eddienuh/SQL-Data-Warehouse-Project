/* 
==================================================================================
Data Quality Checks
==================================================================================
Script Purpose:
              This script performs various quality checks for data consistency
accuracy and standardisation accross the Silver schemas. It includes checks for:
              - Null and duplicate primary keys
              - Unwanted spaces in string fields
              - Data standardisation and consistency 
              - Invalid data ranges and orders
              - Data consistency between related fields 

Usage Notes:
              - Run these checks after data loading Silver.
              - Investigate and resolve any discrepancies found during the checks. 
==================================================================================
*/ 

PRINT '======================================================';
PRINT 'DATA QUALITY CHECKS FOR SILVER SCHEMA ';
PRINT '======================================================';

PRINT '-----------------------------------------------------';
PRINT 'Test for Silver.crm_cust_info';
PRINT '-----------------------------------------------------';
--Check for NULLS and Duplicates in Primary Key
--Expectation: No Result 
	SELECT 
		cust_id,
		COUNT(*)
	FROM Silver.crm_cust_info
	GROUP BY cust_id
	HAVING COUNT(*) > 1 OR cust_id IS NULL

--Check for Unwanted Spaces
--Expectation: No Result
	SELECT cust_key
		FROM Silver.crm_cust_info
		WHERE cust_key ! = TRIM(cust_key)

	SELECT cust_firstname
		FROM Silver.crm_cust_info
		WHERE cust_key ! = TRIM(cust_key)

	SELECT cust_lastname
		FROM Silver.crm_cust_info
		WHERE cust_key ! = TRIM(cust_key)

--Data Standardisation & Consistency 
	SELECT DISTINCT cust_marital_status
	FROM Silver.crm_cust_info


PRINT '-----------------------------------------------------';
PRINT 'Test for Silver.crm_prd_info';
PRINT '-----------------------------------------------------';
--Check for NULLS and Duplicates in Primary Key
--Expectation: No Result 
	SELECT 
	prd_id,
	COUNT(*)
		FROM Silver.crm_prd_info
		GROUP BY prd_id
		HAVING COUNT(*) > 1 OR prd_id IS NULL

--Check for Unwanted Spaces
--Expectation: No Result
	SELECT prd_nm
		FROM Silver.crm_prd_info
		WHERE prd_nm ! = TRIM(prd_nm);

--Check for Negative Numbers
--Expectation: No Result
	SELECT prd_cost
		FROM Silver.crm_prd_info
		WHERE prd_cost < 0 OR prd_cost IS NULL

--Data Standardisation & Consistency 
	SELECT DISTINCT prd_line
	FROM Silver.crm_prd_info

--Check for invalid date orders (start date > end date)
--Expectation: No Results
	SELECT * FROM Silver.crm_prd_info
	WHERE prd_end_date < prd_start_date 


PRINT '-----------------------------------------------------';
PRINT 'Test for Silver.crm_sales_details';
PRINT '-----------------------------------------------------';
--Check for invalid date orders
--Expectation: No Results
	SELECT  
		NULLIF(sls_ship_dt, '1900-01-01') AS sls_ship_dt 
	FROM Silver.crm_sales_details
	WHERE sls_ship_dt IS NULL
	   OR sls_ship_dt < '1900-01-01'
	   OR sls_ship_dt > '2050-01-01'
	   OR LEN(CONVERT(VARCHAR, sls_ship_dt, 112)) != 8;

--Check for invalid date orders
--Expectation: No Results
	SELECT * 
		FROM Silver.crm_sales_details
		WHERE sls_order_dt > sls_ship_dt 
		OR sls_order_dt > sls_due_dt

--Check for data consistency: Sales = Quantity * Price
--Expectation: No Results
	SELECT DISTINCT
		sls_sales,
		sls_quantity,
		sls_price 
	FROM Silver.crm_sales_details
		WHERE sls_sales ! = sls_quantity * sls_price
			OR sls_sales IS NULL 
			OR sls_quantity IS NULL 
			OR sls_price IS NULL
			OR sls_sales < = 0 OR sls_quantity < = 0 OR sls_price < = 0
	ORDER BY sls_sales, sls_quantity, sls_price


PRINT '-----------------------------------------------------';
PRINT 'Test for Silver.erp_CUST_AZ12';
PRINT '-----------------------------------------------------';
--Identify out of range dates
--Expectation: No Results
	SELECT DISTINCT 
	BDATE
		FROM Silver.erp_CUST_AZ12
		WHERE BDATE < '1924-01-01' 
		OR BDATE > GETDATE ()

--Data Standardisation & Consistency 
	SELECT DISTINCT GEN 
	FROM Silver.erp_CUST_AZ12


PRINT '-----------------------------------------------------';
PRINT 'Test for Silver.erp_LOC_A1O1';
PRINT '-----------------------------------------------------';

--Data Standardisation & Consistency 
	SELECT DISTINCT CNTRY
		FROM Silver.erp_LOC_A1O1
		ORDER BY CNTRY;


PRINT '-----------------------------------------------------';
PRINT 'Test for Silver.erp_PX_CAT_G1V2';
PRINT '-----------------------------------------------------';
--Check for Unwanted Spaces
--Expectation: No Results
	SELECT * FROM Silver.erp_PX_CAT_G1V2
		WHERE CAT ! = TRIM(CAT) 
		OR SUBCAT ! = TRIM(SUBCAT) 
		OR MAINTENANCE ! = TRIM(MAINTENANCE)

--Standardisation & Consistency 
	SELECT DISTINCT MAINTENANCE
		FROM Silver.erp_PX_CAT_G1V2
			WHERE REPLACE (SUBSTRING(MAINTENANCE, 1, 5), '-', '_') NOT IN
			(SELECT DISTINCT id FROM Silver.erp_PX_CAT_G1V2)
 
