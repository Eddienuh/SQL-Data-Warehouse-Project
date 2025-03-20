/*
===================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===================================================================
Script Purpose:
              This stored procedure loads data into the Bronze schema from local csv files.
              This script performs the following actions;
              1) Truncates the Bronze tables before loading data.
              2) Uses the 'BULK INSERT' command to load data from csv files to Bronze tables.

Paramenters: None
This stored procedure does not accept any parameters or rteurn any values.

Uasge example:
EXECUTE Bronze.load_Bronze;
======================================================================
*/ 

CREATE OR ALTER PROCEDURE Bronze.load_Bronze
AS
BEGIN
	DECLARE @START_TIME DATETIME, @END_TIME DATETIME, @BATCH_START_TIME DATETIME, @BATCH_END_TIME DATETIME;
	BEGIN TRY
		SET @BATCH_START_TIME = GETDATE ();

		PRINT '==============================================';
		PRINT 'Loading Bronze Layer';
		PRINT '==============================================';

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
 
