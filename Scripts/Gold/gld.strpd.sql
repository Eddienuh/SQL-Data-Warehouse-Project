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


CREATE VIEW Gold.dim_products AS
SELECT
	ROW_NUMBER () OVER (ORDER BY pn.prd_start_date, pn.prd_key) AS product_key, 
	pn.prd_id AS product_id,
	pn.prd_key AS product_number,
	pn.prd_nm AS product_name,
	pn.cat_id AS category_id,
	pc.CAT AS category,
	pc.SUBCAT AS subcategory,
	pc.MAINTENANCE AS maintenance,
	pn.prd_cost AS cost,
	pn.prd_line AS product_line,
	pn.prd_start_date AS start_date
FROM Silver.crm_prd_info pn
LEFT JOIN Silver.erp_PX_CAT_G1V2 pc
ON pn.cat_id = pc.id
WHERE prd_end_date IS NULL --Filter out all historical data 
