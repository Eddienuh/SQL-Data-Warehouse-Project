/*
========================================================================================
DDL Script: Create Bronze Tables
========================================================================================

Script Purpose:
              This script creates tables in the bronze schema by firstly dropping tables if they already exist, and then recreating tables.
              This script also utilises bulk insert for each table load, ensuring to truncate each table before the load is executed.
              The time for each table load and for the batch load are both defined within the script.
              Run this script to re-define the DDL structure of Bronze tables.
              
=========================================================================================
/* 

CREATE OR ALTER PROCEDURE Bronze.load_Bronze
AS
BEGIN
	DECLARE @START_TIME DATETIME, @END_TIME DATETIME, @BATCH_START_TIME DATETIME, @BATCH_END_TIME DATETIME;
	BEGIN TRY
		SET @BATCH_START_TIME = GETDATE ();

		PRINT '==============================================';
		PRINT 'Loading Bronze Layer';
		PRINT '==============================================';

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

		PRINT '-----------------------------------------------------';
		PRINT ' TRUNCATE AND BULK INSERT DATA INTO TABLES';
		PRINT '-----------------------------------------------------';

		SET @START_TIME = GETDATE ();
		PRINT '>> TRUNCATE TABLE: Bronze.crm_cust_info';
		TRUNCATE TABLE Bronze.crm_cust_info

		PRINT '>> BULK INSERT DATA INTO TABLE Bronze.crm_cust_info';
		BULK INSERT Bronze.crm_cust_info

		FROM 'C:\Users\eddie\OneDrive\Documents\cust_info.csv'

		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n', 
			TABLOCK
		);
		SET @END_TIME = GETDATE ();
		PRINT 'LOAD DURATION: ' + CAST(DATEDIFF (SECOND, @START_TIME, @END_TIME) AS NVARCHAR) + ' SECONDS';
		PRINT '------------------------------------------------------'

		SET @START_TIME = GETDATE ();
		PRINT '>> TRUNCATE TABLE: Bronze.crm_prd_info';
		TRUNCATE TABLE Bronze.crm_prd_info

		PRINT '>> BULK INSERT DATA INTO TABLE Bronze.crm_prd_info';
		BULK INSERT Bronze.crm_prd_info 

		FROM 'C:\Users\eddie\OneDrive\Documents\prd_info.csv'

		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			TABLOCK
		);
		SET @END_TIME = GETDATE ();
		PRINT 'LOAD DURATION: ' + CAST(DATEDIFF (SECOND, @START_TIME, @END_TIME) AS NVARCHAR) + ' SECONDS';
		PRINT '------------------------------------------------------'

		SET @START_TIME = GETDATE ();
		PRINT '>> TRUNCATE TABLE: Bronze.crm_sales_details';
		TRUNCATE TABLE Bronze.crm_sales_details;

		PRINT '>> BULK INSERT DATA INTO TABLE Bronze.crm_sales_details'; 
		BULK INSERT Bronze.crm_sales_details

		FROM 'C:\Users\eddie\OneDrive\Documents\sales_details.csv'

		WITH (
			FIRSTROW = 2,             
			FIELDTERMINATOR = ',',    
			ROWTERMINATOR = '\n',     
			TABLOCK                  
		);
		SET @END_TIME = GETDATE ();
		PRINT 'LOAD DURATION: ' + CAST(DATEDIFF (SECOND, @START_TIME, @END_TIME) AS NVARCHAR) + ' SECONDS';
		PRINT '------------------------------------------------------'


		SET @START_TIME = GETDATE ();
		PRINT '>> TRUNCATE TABLE: Bronze.erp_CUST_AZ12';
		TRUNCATE TABLE Bronze.erp_CUST_AZ12

		PRINT '>> BULK INSERT DATA INTO TABLE Bronze.erp_CUST_AZ12';
		BULK INSERT Bronze.erp_CUST_AZ12

		FROM 'C:\Users\eddie\OneDrive\Documents\CUST_AZ12.csv'

		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR =',',
			ROWTERMINATOR = '\n', 
			TABLOCK
		);
		SET @END_TIME = GETDATE ();
		PRINT 'LOAD DURATION: ' + CAST(DATEDIFF (SECOND, @START_TIME, @END_TIME) AS NVARCHAR) + ' SECONDS';
		PRINT '------------------------------------------------------'


		SET @START_TIME = GETDATE ();
		PRINT '>> TRUNCATE TABLE: Bronze.erp_LOC_A1O1';
		TRUNCATE TABLE Bronze.erp_LOC_A1O1;

		PRINT '>> BULK INSERT DATA INTO TABLE Bronze.erp_LOC_A1O1';
		BULK INSERT Bronze.erp_LOC_A1O1

		FROM 'C:\Users\eddie\OneDrive\Documents\LOC_A101.csv'

		WITH (
			FIRSTROW = 2, 
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',      
			TABLOCK                   
		);
		SET @END_TIME = GETDATE ();
		PRINT 'LOAD DURATION: ' + CAST(DATEDIFF (SECOND, @START_TIME, @END_TIME) AS NVARCHAR) + ' SECONDS';
		PRINT '------------------------------------------------------'


		SET @START_TIME = GETDATE ();
		PRINT '>> TRUNCATE TABLE: Bronze.erp_PX_CAT_G1V2';
		TRUNCATE TABLE Bronze.erp_PX_CAT_G1V2;

		PRINT '>> BULK INSERT DATA INTO TABLE Bronze.erp_PX_CAT_G1V2';
		BULK INSERT Bronze.erp_PX_CAT_G1V2

		FROM 'C:\Users\eddie\OneDrive\Documents\PX_CAT_G1V2.csv'

		WITH (
			FIRSTROW = 2,            
			FIELDTERMINATOR = ',',   
			ROWTERMINATOR = '\n',    
			TABLOCK                 
		);
		SET @END_TIME = GETDATE ();
		PRINT 'LOAD DURATION: ' + CAST(DATEDIFF (SECOND, @START_TIME, @END_TIME) AS NVARCHAR) + ' SECONDS';
		PRINT '------------------------------------------------------'

		SET @BATCH_END_TIME = GETDATE ();
		PRINT '======================================================'
		PRINT 'LOADING BRONZE LAYER IS COMPLETE';
		PRINT ' - TOTAL DURATION: ' + CAST( DATEDIFF (SECOND, @BATCH_START_TIME, @BATCH_END_TIME) AS NVARCHAR) + ' SECONDS'; 
		PRINT '======================================================'

	END TRY 
	BEGIN CATCH
		PRINT '======================================================='
		PRINT 'ERROR MESSAGE OCCURED WHULE LOADING BRONZE LAYER'
		PRINT 'ERROR MESSAGE' + ERROR_MESSAGE ();
		PRINT 'ERROR MESSAGE' + CAST (ERROR_NUMBER () AS NVARCHAR);
		PRINT 'ERROR MESSAGE' + CAST (ERROR_STATE () AS NVARCHAR);
		PRINT '======================================================='
	END CATCH
END 
