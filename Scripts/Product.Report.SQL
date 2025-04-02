/*
======================================================================
PRODUCT REPORT
======================================================================

Purpose:
	This script consolidates key product metrics and behaviours

Highlights:
	1. Gathers essential fields such as product names, category, subcategory and costs.
	2. Segments products by revenue to identify high-performers, mid-range, and low-performers.
	3. Aggregates product level metrics
		- total orders
		- total sales
		- total quantity sold
		- total customers (unique)
		- lifespan (in months)
	4. Calculates valuable KPI's 
		- recency (months since last sale)
		- average order revenue (AOR)
		- average monthly revenue

=========================================================================
*/ 
/*
-------------------------------------------------------------------------
--1. Base query: Retrieve Core Columns From Tables
-------------------------------------------------------------------------
*/

CREATE VIEW Gold.product_report AS

WITH base_query AS (
    -- 1. Base query: Retrieve core columns from fact_sales and dim_products tables
    SELECT 
        f.order_number,
        f.order_date,
        f.customer_key,
        f.sales_amount,
        f.quantity,
        p.product_key,
        p.product_name,
        p.category,
        p.subcategory,
        p.cost
    FROM Gold.fact_sales f
    LEFT JOIN Gold.dim_products p
        ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL  -- Ensure we only work with valid orders
),
-- 2. Product Aggregations: Calculate key metrics per product
product_aggregation AS (
    SELECT
        product_key,
        product_name,
        category,
        subcategory,
        cost,
        DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,  -- Calculate product lifespan in months
        MAX(order_date) AS last_sale_date,  -- Most recent sale date
        COUNT(DISTINCT order_number) AS total_orders,  -- Number of distinct orders
        COUNT(DISTINCT customer_key) AS total_customers,  -- Number of distinct customers
        SUM(sales_amount) AS total_sales,  -- Total sales amount
        SUM(quantity) AS total_quantity,  -- Total quantity sold
        ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0)), 1) AS avg_selling_price  -- Average price per unit sold, handling division by zero
    FROM base_query
    GROUP BY 
        product_key, 
        product_name, 
        category, 
        subcategory, 
        cost  -- Group by product attributes
)

-- 3. Combine all product results into one output
SELECT
    product_key, 
    product_name, 
    category, 
    subcategory, 
    cost,
    last_sale_date,
    DATEDIFF(MONTH, last_sale_date, GETDATE()) AS recency_in_months,
    CASE
        WHEN total_sales > 50000 THEN 'High-Performer'
        WHEN total_sales >= 10000 THEN 'Mid-range'
        ELSE 'Low-performer'
    END AS product_segment,
    lifespan,
    total_orders,
    total_sales,
    total_quantity,
    total_customers,
    avg_selling_price,

    -- Average Order Revenue (AOR)
    CASE
        WHEN total_orders = 0 THEN 0
        ELSE total_sales / total_orders
    END AS avg_order_revenue,

    -- Average Monthly Revenue
    CASE 
        WHEN lifespan = 0 THEN total_sales
        ELSE total_sales / lifespan
    END AS avg_monthly_revenue
FROM product_aggregation;


