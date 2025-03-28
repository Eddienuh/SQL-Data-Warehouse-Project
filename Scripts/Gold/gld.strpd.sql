CREATE VIEW Gold.dim_customers AS
SELECT
	ROW_NUMBER () OVER (ORDER BY cust_id) AS customer_key, 
	ci.cust_id AS customer_id,
	ci.cust_key AS customer_number,
	ci.cust_firstname AS first_name,
	ci.cust_lastname AS last_name,
	la.CNTRY AS country,
	CASE 
	WHEN ci.cust_gender ! = 'unknown' THEN ci.cust_gender --CRM is the master for gender information
	 ELSE COALESCE (ca.GEN, 'Unknown') 
END AS gender, --Intergrate new gender information
	ci.cust_marital_status AS marital_status,
	ca.BDATE AS birthdate,
	ci.cust_create_date AS create_date
FROM Silver.crm_cust_info ci
LEFT JOIN Silver.erp_CUST_AZ12 ca
ON		ci.cust_key = ca.CID
LEFT JOIN Silver.erp_LOC_A1O1 la
ON		ci.cust_key = la.CID 
