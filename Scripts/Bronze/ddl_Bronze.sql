/*
========================================================================================
DDL Script: Create Bronze Tables
=======================================================================================

Script Purpose:
		This script creates tables within the Bronze schema, dropping any previous tables if they already exist.
		Run this script to re-define the DDL structure of Bronze tables.
		Description of events are provided throughout table creation.

=========================================================================================
*/ 

                PRINT '----------------------------------------------';
		PRINT 'Loading crm Tables';
		PRINT '----------------------------------------------';

		PRINT '>> CHECK AND DROP Bronze.crm_cust_info IF TABLE EXISTS'; 
		IF OBJECT_ID('Bronze.crm_cust_info', 'U') IS NOT NULL
		BEGIN
			DROP TABLE Bronze.crm_cust_info;
		END

		PRINT '>> CREATE TABLE Bronze.crm_cust_info';
		Create Table Bronze.crm_cust_info (

		cust_id INT,
		cust_key NVARCHAR (50),
		cust_firstname NVARCHAR (50),
		cust_lastname NVARCHAR (50),
		cust_marital_status NVARCHAR (50),
		cust_gender NVARCHAR (50),
		cust_create_date DATE 
		); 

		PRINT '>> CHECK AND DROP Bronze.crm_prd_info IF EXISTS';
		IF OBJECT_ID('Bronze.crm_prd_info', 'U') IS NOT NULL
		BEGIN
			DROP TABLE Bronze.crm_prd_info;
		END

		PRINT '>> CREATE TABLE Bronze.crm_prd_info';
		CREATE TABLE Bronze.crm_prd_info (

		prd_id INT,
		prd_key NVARCHAR (50),
		prd_nm NVARCHAR (50),
		prd_cost INT,
		prd_line NVARCHAR (50),
		prd_start_date DATETIME,
		prd_end_date DATETIME
		); 

		PRINT '>> CHECK AND DROP Bronze.crm_sales_details IF EXISTS';
		IF OBJECT_ID('Bronze.crm_sales_details', 'U') IS NOT NULL
		BEGIN
			DROP TABLE Bronze.crm_sales_details;
		END

		PRINT '>> CREATE TABLE Bronze.crm_sales_details';
		CREATE TABLE Bronze.crm_sales_details (
			sls_order_num NVARCHAR(50),
			sls_prd_key NVARCHAR(50),
			sls_cust_id INT,
			sls_order_dt INT,
			sls_ship_dt INT,
			sls_due_dt INT,
			sls_sales INT,
			sls_quantity INT,
			sls_price INT
		);

		PRINT '----------------------------------------------';
		PRINT 'Loading erp Tables';
		PRINT '----------------------------------------------';

		PRINT '>> CHECK AND DROP Bronze.erp_CUST_AZ12 IF EXISTS';
		IF OBJECT_ID('Bronze.erp_CUST_AZ12', 'U') IS NOT NULL
		BEGIN
			DROP TABLE Bronze.erp_CUST_AZ12;
		END

		PRINT '>> CREATE TABLE Bronze.erp_CUST_AZ12';
		CREATE TABLE Bronze.erp_CUST_AZ12 (
			CID NVARCHAR(50),
			BDATE DATE,
			GEN NVARCHAR(50)
		);

		PRINT '>> CHECK AND DROP Bronze.erp_LOC_A1O1 IF EXISTS';
		IF OBJECT_ID('Bronze.erp_LOC_A1O1' , 'U') IS NOT NULL
		BEGIN
			DROP TABLE Bronze.erp_LOC_A1O1;
		END 

		PRINT '>> CREATE TABLE Bronze.erp_LOC_A1O1';
		CREATE TABLE Bronze.erp_LOC_A1O1 (

		CID NVARCHAR (50),
		CNTRY NVARCHAR (50),
		);

		PRINT '>> CHECK AND DROP Bronze.erp_PX_CAT_G1V2 IF EXISTS';
		IF OBJECT_ID('Bronze.erp_PX_CAT_G1V2' , 'U') IS NOT NULL 
		BEGIN
			DROP TABLE Bronze.erp_PX_CAT_G1V2;
		END

		PRINT '>> CREATE TABLE Bronze.erp_PX_CAT_G1V2';
		CREATE TABLE Bronze.erp_PX_CAT_G1V2 (

		ID NVARCHAR (50),
		CAT NVARCHAR (50),
		SUBCAT NVARCHAR (50),
		MAINTENANCE NVARCHAR (50),
		);
