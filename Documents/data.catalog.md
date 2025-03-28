*****Data Catalog for Gold Layer*****
----------------------------------------------------------------------------------------------------------------------
**Overview**
----------------------------------------------------------------------------------------------------------------------
The Gold Layer is the business-level data representation structured to support analytical and reporting use cases.
It consists od two dimension tables and one fact table for specific business metrics

****1. Gold.dim_customers****

**Purpose**: Stores customer details enriched with demographic and geographic data.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
|customer_key | INT       | Surrogate key uniquely identifying each customer record in the dimension table|
|customer_id  | INT       | Unique numerical identifier assigned to each customer| 
|customer_number| NVARCHAR (50) | Alphanumeric idenifier representing the customer, used for tracking and referencing |
|first_name   | NVARCHAR (50)   | The customers first name as recorded in the system |
|last_name    | NVARCHAR (50)   | The customers last name as recorded in the system |
|country      | NVARCHAR (50)   | Country of residence of the customer (e.g United States) |
|marital_status | NVARCHAR (50) | Marital status of the customer (e.g 'Married', 'Single', 'Unknown') |
|gender       | NVARCHAR (50)   | Gender of the customer (e.g 'Male', 'Female', 'Unknown')
|birthdate    | DATE      | Date of birth of customer, formatted as YYYY-MM-DD (e.g 1970-01-01) |
|create_date  | DATE      | The date and time the customer record was created in the system | 

-------------------------------------------------------------------------------------------------------------------------
****2. Gold.dim_products****

**Purpose**: Stores product information and attributes.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
|product_key  | INT       | Surrogate key uniquely identifying each product record in the dimension table |
|product_id | INT     | A uinque identifier assigned to the product for internal tracking and referencing | 
|product_number |NVARCHAR (50) | A structured alphanumeric code, representing the product, often used for categorisation or inventory |
|product_name | NVARCHAR (50) | Descriptive name of the product, including key details such as type, colour and size |
|category_id  | NVARCHAR (50) | A unique identifier for the product's category, linking it to it's high-level classification |
|category     | NVARCHAR (50) | The broader classification of the products to group related items (e.g 'Bikes', 'Components') | 
|subcategory  | NVARCHAR (50) | A more detailed classification of the product within the category, such as type |
|maintenance  | NVARCHAR (50) | Indicates whether the product needs maintenance (e.g 'Yes', 'No') |
|cost         | INT           | The cost or base price of the product, measured in monetary units |
|product_line | NVARCHAR (50) | The specific product line or series to which the product belongs (e.g 'Road', 'Mountain') |
|start_date   | DATE          | The date when the product became available for sale or use, formatted as YYYY-MM-DD (e.g 2003-01-01) |

------------------------------------------------------------------------------------------------------------------------------
****3. Gold.fact_sales****

**Purpose**: Stores transactional sales data for analytical purposes.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
|order_number | NVARCHAR (50) | A unique alphanumeric identifier for each sales order (e.g 'S03752') |
|product_key  | INT       | Surrogate key linking the order to the product dimension table | 
|customer_key | INT       | Surrogate key linking the order to the customer dimension table | 
|order_date   | DATE      | The date when the order was placed, formatted as YYYY-MM-DD |
|shipping_date| DATE      | The date when the order was shipped YYYY-MM-DD |
|due_date     | DATE      | The date when the order payment was due YYYY-MM-DD |
|sales_amount | INT       | The total monetary value of the sale for the line item, in whole currency units (e.g 30) | 
|quantity     | INT       | The number of units ordered for the line item (e.g 5) |
|price        | INT       | The price per unit of the product for the line item, in whole currency units (e.g 30) |

------------------------------------------------------------------------------------------------------------------------------
