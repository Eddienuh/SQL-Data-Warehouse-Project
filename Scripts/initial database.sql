/*
---------------------------------------
Create Database and Schemas
---------------------------------------
**Script Purpose**:
This script creates a new database called "Datawarehouse" after checking if the database already exists. If the databse exists, drop the database and recreate it. Furthermore this scripts goes on to create three new schemas, 
Bronze, Silver and Gold.

**Warning**:
Running this script will drop the entire "Datawarehouse" database if it already exists. All data in the database will be permenently deleted if executed.
Ensure proper back ups are in place before running this script.
*/

-Create Database Datawarehouse--

USE MASTER;
GO

IF exists (SELECT * fROM sys.databases WHERE NAME = 'Datawarehouse')
BEGIN
   
    DROP DATABASE Datawarehouse;
END

CREATE DATABASE Datawarehouse;

USE Datawarehouse;


GO

--CREATE SCHEMAS
CREATE SCHEMA Bronze

GO

CREATE SCHEMA Silver

GO

CREATE SCHEMA Gold


 

