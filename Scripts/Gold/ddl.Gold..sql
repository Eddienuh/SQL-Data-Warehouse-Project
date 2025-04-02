/*
======================================================================================================
DDL Script: Create Gold View
======================================================================================================
Script Purpose:
	This script creates views for the Gold layer within the datawarehouse.
	The Gold layer represents the final dimension and fact tables (star schema).
	Each view performs transformations and combines data from the silver layer to produce a clean,
	enriched and business-ready dataset.

Usage:
	These views can be queried directly for analytics and reporting.
======================================================================================================
*/

-- Drop and recreate Gold.dim_customers view
IF OBJECT_ID('Gold.dim_customers', 'V') IS NOT NULL
	DROP VIEW Gold.dim_customers;
GO

CREATE VIEW Gold.dim_customers AS
SELECT
	ROW_NUMBER () OVER (ORDER BY ci.cust_id) AS customer_key, 
	ci.cust_id AS customer_id,
	ci.cust_key AS customer_number,
	ci.cust_firstname AS first_name,
	ci.cust_lastname AS last_name,
	la.CNTRY AS country,
	CASE 
		WHEN ci.cust_gender <> 'unknown' THEN ci.cust_gender --CRM is the master for gender 
		ELSE COALESCE(ca.GEN, 'Unknown') 
	END AS gender, -- Integrate new gender information
	ci.cust_marital_status AS marital_status,
	ca.BDATE AS birthdate,
	ci.cust_create_date AS create_date
FROM Silver.crm_cust_info ci
LEFT JOIN Silver.erp_CUST_AZ12 ca
	ON ci.cust_key = ca.CID
LEFT JOIN Silver.erp_LOC_A1O1 la
	ON ci.cust_key = la.CID;
GO

-- Drop and recreate Gold.dim_products view
IF OBJECT_ID('Gold.dim_products', 'V') IS NOT NULL
	DROP VIEW Gold.dim_products;
GO

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
WHERE pn.prd_end_date IS NULL; -- Filter out all historical data
GO

-- Drop and recreate Gold.fact_sales view
IF OBJECT_ID('Gold.fact_sales', 'V') IS NOT NULL
	DROP VIEW Gold.fact_sales;
GO

CREATE VIEW Gold.fact_sales AS
SELECT
	sd.sls_order_num AS order_number,
	pr.product_key,
	cu.customer_key,
	sd.sls_order_dt AS order_date,
	sd.sls_ship_dt AS shipping_date,
	sd.sls_due_dt AS due_date,
	sd.sls_sales AS sales_amount,
	sd.sls_quantity AS quantity,
	sd.sls_price AS price
FROM Silver.crm_sales_details sd
LEFT JOIN Gold.dim_products pr
	ON sd.sls_prd_key = pr.product_number  
LEFT JOIN Gold.dim_customers cu
	ON sd.sls_cust_id = cu.customer_id;
GO 
