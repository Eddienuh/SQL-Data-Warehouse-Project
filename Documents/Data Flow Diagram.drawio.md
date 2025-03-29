***DATA FLOW DIAGRAM***

The DFD illustrates the data engineering process, moving data from CRM and ERP systems to business-ready formats.

**Sources**: CRM and ERP systems provide raw data (e.g., customer and operational data). This relates to the Bronze Layer.

**ETL/ELT**: Data is extracted, cleaned, and transformed for consistency and structure but still exists across multiple tables. 
This relates to the Silver Layer

**Storage**: These cleaned tables are joined in the datawarehouse into a single, integrated table. The relationship between tables is established using primary keys 
(unique identifiers in each table) and foreign keys (links to other tables). This ensures that data from multiple sources is correctly joined 
and structured for business use. This relates to the Gold Layer.

![image](https://github.com/user-attachments/assets/86e90afd-be74-4f0b-99f1-42425a3e3096)
