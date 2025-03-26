PRINT '----------------------------------------------';
PRINT 'Loading crm Tables';
PRINT '----------------------------------------------';

PRINT '>> CHECK AND DROP Silver.crm_cust_info IF TABLE EXISTS'; 
IF OBJECT_ID('Silver.crm_cust_info', 'U') IS NOT NULL
BEGIN
	DROP TABLE Silver.crm_cust_info;
END

PRINT '>> CREATE TABLE Silver.crm_cust_info';
Create Table Silver.crm_cust_info (

	cust_id INT,
	cust_key NVARCHAR (50),
	cust_firstname NVARCHAR (50),
	cust_lastname NVARCHAR (50),
	cust_marital_status NVARCHAR (50),
	cust_gender NVARCHAR (50),
	cust_create_date DATE,
	dwh_create_date DATETIME2 DEFAULT GETDATE ()
	); 

PRINT '>> CHECK AND DROP Silver.crm_prd_info IF EXISTS';
IF OBJECT_ID('Silver.crm_prd_info', 'U') IS NOT NULL
BEGIN
	DROP TABLE Silver.crm_prd_info;
END

PRINT '>> CREATE TABLE Silver.crm_prd_info';
CREATE TABLE Silver.crm_prd_info (

	prd_id INT,
	cat_id NVARCHAR (50),
	prd_key NVARCHAR (50),
	prd_nm NVARCHAR (50),
	prd_cost INT,
	prd_line NVARCHAR (50),
	prd_start_date DATE,
	prd_end_date DATE,
	dwh_create_date DATETIME2 DEFAULT GETDATE ()
	); 

PRINT '>> CHECK AND DROP Silver.crm_sales_details IF EXISTS';
IF OBJECT_ID('Silver.crm_sales_details', 'U') IS NOT NULL
BEGIN
	DROP TABLE Silver.crm_sales_details;
END

PRINT '>> CREATE TABLE Silver.crm_sales_details';
CREATE TABLE Silver.crm_sales_details (
	sls_order_num NVARCHAR(50),
	sls_prd_key NVARCHAR(50),
	sls_cust_id INT,
	sls_order_dt INT,
	sls_ship_dt INT,
	sls_due_dt INT,
	sls_sales INT,
	sls_quantity INT,
	sls_price INT,
	dwh_create_date DATETIME2 DEFAULT GETDATE ()
);

PRINT '----------------------------------------------';
PRINT 'Loading erp Tables';
PRINT '----------------------------------------------';

PRINT '>> CHECK AND DROP Silver.erp_CUST_AZ12 IF EXISTS';
IF OBJECT_ID('Silver.erp_CUST_AZ12', 'U') IS NOT NULL
BEGIN
	DROP TABLE Silver.erp_CUST_AZ12;
END

PRINT '>> CREATE TABLE Silver.erp_CUST_AZ12';
CREATE TABLE Silver.erp_CUST_AZ12 (
	CID NVARCHAR(50),
	BDATE DATE,
	GEN NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE ()
);

PRINT '>> CHECK AND DROP Silver.erp_LOC_A1O1 IF EXISTS';
IF OBJECT_ID('Silver.erp_LOC_A1O1' , 'U') IS NOT NULL
BEGIN
	DROP TABLE Silver.erp_LOC_A1O1;
END 

PRINT '>> CREATE TABLE Silver.erp_LOC_A1O1';
CREATE TABLE Silver.erp_LOC_A1O1 (

	CID NVARCHAR (50),
	CNTRY NVARCHAR (50),
	dwh_create_date DATETIME2 DEFAULT GETDATE ()
	);

PRINT '>> CHECK AND DROP Silver.erp_PX_CAT_G1V2 IF EXISTS';
IF OBJECT_ID('Silver.erp_PX_CAT_G1V2' , 'U') IS NOT NULL 
BEGIN
	DROP TABLE Silver.erp_PX_CAT_G1V2;
END

PRINT '>> CREATE TABLE Silver.erp_PX_CAT_G1V2';
CREATE TABLE Silver.erp_PX_CAT_G1V2 (

	ID NVARCHAR (50),
	CAT NVARCHAR (50),
	SUBCAT NVARCHAR (50),
	MAINTENANCE NVARCHAR (50),
	dwh_create_date DATETIME2 DEFAULT GETDATE ()
); 
