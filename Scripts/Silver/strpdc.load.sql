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
