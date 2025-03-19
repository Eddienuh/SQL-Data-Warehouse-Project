/*
---------------------------------------
Create Database and Schemas
---------------------------------------
**Script Purpose**:
This script creates a new database called "Datawarehouse" after checkong if the database already exists. If it exists the database is dropped then recreated. Furthermore this scripts goes on to create three new schemas, 
Bronze, Silver and Gold.

**Warning**:
Running this script will drop the entire "Datawarehouse" database if it already exists. All data in the database will be permenently deleted if executed.
Ensure proper back ups are in place before running this script.
*/

--Create Database Datawarehouse--

use master;
Go

--Check if "Datawarehouse" already exists
--If true Drop "Datawarehouse"
IF exists (Select * from sys.databases where name = 'Datawarehouse')
BEGIN
   
    Drop database Datawarehouse;
END

Create database Datawarehouse;

Use Datawarehouse;

Go

--Create Schemas
Create Schema Bronze

Go

Create Schema Silver

Go

Create Schema Gold
 

