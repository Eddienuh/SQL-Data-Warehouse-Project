========================================================================================================
Silver.crm_cust_info
========================================================================================================
TRUNCATE TABLE Silver.crm_cust_info --To ensure the table is reset before use and data is not duplicated 

--Insert relevant columns into Silver.crm_cust_info Table
INSERT INTO Silver.crm_cust_info (
    cust_id,
    cust_key,
    cust_firstname,
    cust_lastname,
    cust_marital_status,
    cust_gender,
    cust_create_date
) 

SELECT
	cust_id,
    cust_key,
    TRIM(cust_firstname) AS cust_firstname, --Standardise firstname by trimming to remove unwanted spaces
    TRIM(cust_lastname) AS cust_lastname, --Standardise lastname by trimming to remove unwanted spaces 
	CASE 
        WHEN UPPER(TRIM(cust_marital_status)) = 'S' THEN 'Single' --Normalise marital status to readable format
        WHEN UPPER(TRIM(cust_marital_status)) = 'M' THEN 'Married'
        ELSE 'Unknown' --Cleanse and handle missing values by adding description 
    END AS cust_marital_status,
	CASE 
        WHEN UPPER(TRIM(cust_gender)) = 'F' THEN 'Female' --Normalise gender to readable format
        WHEN UPPER(TRIM(cust_gender)) = 'M' THEN 'Male'
        ELSE 'Unknown' --Cleanse and handle missing values by adding description
    END AS cust_gender,
    cust_create_date
FROM (
SELECT
    *,
	ROW_NUMBER() OVER (PARTITION BY cust_id ORDER BY cust_create_date DESC) AS flag_last
FROM Bronze.crm_cust_info
) t WHERE flag_last = 1 --Only select most recent record for each customer id to Filter data and ensure no duplicates are present

DELETE FROM Silver.crm_cust_info
WHERE cust_id IS NULL  --Delete any remaining rows where customer id is NULL
	
==================================================================================================================================
Silver.crm_prd_info
==================================================================================================================================
TRUNCATE TABLE Silver.crm_prd_info; -- Reset the table to ensure no previous data exists

INSERT INTO Silver.crm_prd_info (
    prd_id,
    cat_id,
    prd_key,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_date,
    prd_end_date
)
SELECT
    prd_id,
    REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,  -- Extract cat_id from Product Key & derive new column 
    SUBSTRING(prd_key, 7, LEN(prd_key) - 6) AS prd_key,  -- Extract remainder of prd_key
    prd_nm,
    ISNULL(prd_cost, 0) AS prd_cost,  -- Replace NULL prd_cost with 0
    CASE 
        WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
        WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
        WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales' --Normalise & map product line codes to descriptive values
        WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
        ELSE 'Unknown'
    END AS prd_line, 
    CAST(prd_start_date AS DATE) AS prd_start_date, --Convert data type using casting
    CAST(
        LEAD(prd_start_date) OVER (PARTITION BY prd_key ORDER BY prd_start_date) - 1 AS DATE --Add new relevant data by enriching data
    ) AS prd_end_date  --Calculate end date as one date before the next start date
FROM Bronze.crm_prd_info;

===================================================================================================================================
Silver.crm_sales_details
===================================================================================================================================
TRUNCATE TABLE Silver.crm_sales_details

INSERT INTO Silver.crm_sales_details (
	sls_order_num,
	sls_prd_key,
	sls_cust_id,
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price
)
SELECT 
    sls_order_num,
    sls_prd_key,
    sls_cust_id,
    
    -- Handle Invalid data in the form of order date utilising CAST function (sls_order_dt) 
    CASE 
        WHEN sls_order_dt = 0 OR LEN(CAST(sls_order_dt AS VARCHAR)) != 8 THEN NULL
        ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE) 
    END AS sls_order_dt,

    -- Handle the ship date (sls_ship_dt)
    CASE 
        WHEN sls_ship_dt = 0 OR LEN(CAST(sls_ship_dt AS VARCHAR)) != 8 THEN NULL
        ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
    END AS sls_ship_dt,

    -- Handle the due date (sls_due_dt)
    CASE 
        WHEN sls_due_dt = 0 OR LEN(CAST(sls_due_dt AS VARCHAR)) != 8 THEN NULL
        ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
    END AS sls_due_dt,

	--Calculate corrected sales

	CASE 
        WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
        THEN sls_quantity * ABS(sls_price)
        ELSE sls_sales
	END AS sls_sales, --Recalculate sales if original value is missing or incorrect
    sls_quantity,

	--Calculate corrected price

      CASE 
        WHEN sls_price IS NULL OR sls_price <= 0
        THEN sls_sales / NULLIF(sls_quantity, 0) 
        ELSE sls_price
	END AS sls_price --Derive price if original value is invalid
FROM 
    Bronze.crm_sales_details; 

=====================================================================================================
Silver.erp_CUST_AZ12
=====================================================================================================
-- Truncate the table to remove all existing data
TRUNCATE TABLE Silver.erp_CUST_AZ12;

-- Insert new data with cleaned values
INSERT INTO Silver.erp_CUST_AZ12 (
    CID,
    BDATE,
    GEN
)
SELECT
    CASE 
        WHEN CID LIKE 'NAS%' THEN SUBSTRING(CID, 4, LEN(CID) - 3)  -- Handle invalid values and Remove 'NAS' prefix
        ELSE CID
    END AS CID,
    CASE 
        WHEN BDATE > GETDATE() THEN NULL  -- Sets future BDATE values to NULL
        ELSE BDATE
    END AS BDATE,
    CASE
        WHEN UPPER(TRIM(GEN)) IN ('F', 'FEMALE') THEN 'Female'  -- Standardize GEN as Female
        WHEN UPPER(TRIM(GEN)) IN ('M', 'MALE') THEN 'Male'      -- Standardize GEN as Male
        ELSE 'Unknown'                                          -- Handle any other values as 'Unknown'
    END AS GEN
FROM 
    Bronze.erp_CUST_AZ12; 

