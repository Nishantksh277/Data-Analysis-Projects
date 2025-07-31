/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    This script creates a new database named 'DataWarehouseAnalytics' after checking if it already exists. 
    If the database exists, it is dropped and recreated. Additionally, this script creates a schema called gold
	
WARNING:
    Running this script will drop the entire 'DataWarehouseAnalytics' database if it exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
*/

USE master;
GO

-- Drop and recreate the 'DataWarehouseAnalytics' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouseAnalytics')
BEGIN
    ALTER DATABASE DataWarehouseAnalytics SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouseAnalytics;
END;
GO

-- Create the 'DataWarehouseAnalytics' database
CREATE DATABASE DataWarehouseAnalytics;
GO

USE DataWarehouseAnalytics;
GO

-- Create Schemas

CREATE SCHEMA gold;
GO

CREATE TABLE gold.dim_customers(
	customer_key int,
	customer_id int,
	customer_number nvarchar(50),
	first_name nvarchar(50),
	last_name nvarchar(50),
	country nvarchar(50),
	marital_status nvarchar(50),
	gender nvarchar(50),
	birthdate date,
	create_date date
);
GO

CREATE TABLE gold.dim_products(
	product_key int ,
	product_id int ,
	product_number nvarchar(50) ,
	product_name nvarchar(50) ,
	category_id nvarchar(50) ,
	category nvarchar(50) ,
	subcategory nvarchar(50) ,
	maintenance nvarchar(50) ,
	cost int,
	product_line nvarchar(50),
	start_date date 
);
GO

CREATE TABLE gold.fact_sales(
	order_number nvarchar(50),
	product_key int,
	customer_key int,
	order_date date,
	shipping_date date,
	due_date date,
	sales_amount int,
	quantity tinyint,
	price int 
);
GO

TRUNCATE TABLE gold.dim_customers;
GO

BULK INSERT gold.dim_customers
FROM 'C:\Users\Nishs\OneDrive\Desktop\Portfolio Projects Fresh\SQL Data Analysis Project\sql-data-analytics-project\datasets\csv-files\gold.dim_customers.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);
GO

TRUNCATE TABLE gold.dim_products;
GO

BULK INSERT gold.dim_products
FROM 'C:\Users\Nishs\OneDrive\Desktop\Portfolio Projects Fresh\SQL Data Analysis Project\sql-data-analytics-project\datasets\csv-files\gold.dim_products.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);
GO

TRUNCATE TABLE gold.fact_sales;
GO

BULK INSERT gold.fact_sales
FROM 'C:\Users\Nishs\OneDrive\Desktop\Portfolio Projects Fresh\SQL Data Analysis Project\sql-data-analytics-project\datasets\csv-files\gold.fact_sales.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);
GO

-- Change Over Time

-- Analyse Sales Performance Over Time
SELECT
YEAR(order_date) as Order_Year,
sum(sales_amount) as Total_Sales,
COUNT(DISTINCT customer_key) as Total_customers,
SUM(quantity) as Total_Quantity
from gold.fact_sales
where order_date IS NOT NULL
group by YEAR(order_date)
order by YEAR(order_date)

SELECT
MONTH(order_date) as Order_Month,
sum(sales_amount) as Total_Sales,
COUNT(DISTINCT customer_key) as Total_customers,
SUM(quantity) as Total_Quantity
from gold.fact_sales
where order_date IS NOT NULL
group by MONTH(order_date)
order by MONTH(order_date)


SELECT
YEAR(order_date) as Order_Year,
MONTH(order_date) as Order_Month,
sum(sales_amount) as Total_Sales,
COUNT(DISTINCT customer_key) as Total_customers,
SUM(quantity) as Total_Quantity
from gold.fact_sales
where order_date IS NOT NULL
group by YEAR(order_date), MONTH(order_date)
order by YEAR(order_date), MONTH(order_date)

SELECT
DATETRUNC(MONTH, order_date) as Order_Date,
sum(sales_amount) as Total_Sales,
COUNT(DISTINCT customer_key) as Total_customers,
SUM(quantity) as Total_Quantity
from gold.fact_sales
where order_date IS NOT NULL
group by DATETRUNC(MONTH, order_date)
order by DATETRUNC(MONTH, order_date)

SELECT
DATETRUNC(YEAR, order_date) as Order_Date,
sum(sales_amount) as Total_Sales,
COUNT(DISTINCT customer_key) as Total_customers,
SUM(quantity) as Total_Quantity
from gold.fact_sales
where order_date IS NOT NULL
group by DATETRUNC(YEAR, order_date)
order by DATETRUNC(YEAR, order_date)

SELECT
FORMAT(order_date, 'yyyy-MMM') as Order_Date,
sum(sales_amount) as Total_Sales,
COUNT(DISTINCT customer_key) as Total_customers,
SUM(quantity) as Total_Quantity
from gold.fact_sales
where order_date IS NOT NULL
group by FORMAT(order_date, 'yyyy-MMM')
order by FORMAT(order_date, 'yyyy-MMM')

-- Comulative Analysis

-- Calculate the total sales per month and the running total of sales over time
Select
order_date,
Total_Sales,
SUM(Total_Sales) OVER (ORDER BY order_date) as Running_Total_Sales
from
(
Select
DATETRUNC(YEAR, order_date) as order_date,
SUM(sales_amount) as Total_Sales
from gold.fact_sales
where order_date IS NOT NULL
group by DATETRUNC(YEAR, order_date)
) t

--  Moving Average
Select
order_date,
Total_Sales,
SUM(Total_Sales) OVER (ORDER BY order_date) as Running_Total_Sales,
AVG(Avg_Price) OVER (ORDER BY order_date) as Moving_Average_Price
from
(
Select
DATETRUNC(YEAR, order_date) as order_date,
SUM(sales_amount) as Total_Sales,
AVG(price) as Avg_Price
from gold.fact_sales
where order_date IS NOT NULL
group by DATETRUNC(YEAR, order_date)
) t

-- Performance Analysis
-- Analyze the yearly performance of products by comparing each product's sales to both its average sales performance and the previous year's sales

WITH yearly_product_sales as (
Select
YEAR(f.order_date) as Order_Year,
p.product_name,
SUM(f.sales_amount) as Current_Sales
from gold.fact_sales f
LEFT JOIN gold.dim_products p
on f.product_key = p.product_key
where f.order_date IS NOT NULL
group by YEAR(f.order_date), p.product_name
)
select 
Order_Year,
product_name,
current_Sales,
AVG(current_Sales) OVER (Partition by product_name) avg_sales,
Current_Sales - AVG(current_Sales) OVER (Partition by product_name) as diff_avg,
CASE WHEN Current_Sales - AVG(current_Sales) OVER (Partition by product_name) > 0 THEN 'Above Avg'
	 WHEN Current_Sales - AVG(current_Sales) OVER (Partition by product_name) < 0 THEN 'Below Avg'
	 ELSE 'Avg'
END avg_change,
-- Year over Year Analysis
LAG(current_Sales) over (partition by product_name order by order_year) previous_year_sales,
current_Sales - LAG(current_Sales) over (partition by product_name order by order_year) as difference_previous_year,
CASE WHEN Current_Sales - LAG(current_Sales) over (partition by product_name order by order_year) > 0 THEN 'Increase'
	 WHEN Current_Sales - LAG(current_Sales) over (partition by product_name order by order_year) < 0 THEN 'Decrease'
	 ELSE 'No Change'
END previous_year_change
from yearly_product_sales
order by product_name, Order_Year

-- Part to Whole Analysis
-- Which categories contribute the most to overall sales

WITH Category_Sales as (
select
category,
SUM(sales_amount) as Total_Sales
from gold.fact_sales f
LEFT JOIN gold.dim_products p
on f.product_key = p.product_key
group by category)

select
category,
Total_Sales,
SUM(Total_Sales) over () overall_Sales,
concat(round((CAST (Total_Sales as float) / SUM(Total_Sales) over ())*100, 2), '%') as percentage_of_total
from Category_Sales
order by Total_Sales DESC

-- Data Segmentation
-- Segment products into cost ranges and count how many products fall into each segment

WITH product_segments as (
select
product_key,
product_name,
cost,
case when cost < 100 then 'Below 100'
	 when cost between 100 and 500 then '100-500'
	 when cost between 500 and 1000 then '500-1000'
	 else 'above 1000'
end cost_range
from gold.dim_products)

select
cost_range,
COUNT(product_key) as Total_Products
from product_segments
group by cost_range
order by Total_Products DESC

-- Group customers into three segments based on their spending behaviour
-- VIP: At least 12 months of history and spending more than 5000.
-- Regular: At least 12 months of history but spending 5000 or less.
-- New: Lifespan less than 12 months.
-- And find the total number of customers by each group

WITH customer_spending as (
select
c.customer_key,
SUM(f.sales_amount) as Total_Spending,
MIN(order_date) as first_order,
MAX(order_date) as last_order,
DATEDIFF (month, MIN(order_date), MAX(order_date)) as lifespan
from gold.fact_sales f
LEFT JOIN gold.dim_customers c
on f.customer_key = c.customer_key
group by c.customer_key)

select
customer_segment,
COUNT(customer_key) as Total_Customers
from (
	select
	customer_key,
	Total_Spending,
	lifespan,
	case when lifespan >= 12 and Total_Spending > 5000 then 'VIP'
		 when lifespan >= 12 and Total_Spending <= 5000 then 'Regular'
		 else 'New'
	end customer_segment
	from customer_spending) t
group by customer_segment
order by Total_Customers DESC

/* Build Customer Report
This report consolidates key customers metrics and behaviours

Highlights:
	1. Gathers essential fields such as names, ages, and transactional details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
	3. Aggregate customer - level metrics:
		- total orders
		- total sales
		- total quantity purchased
		- total products
		- lifespan (in months)
	4. Calculates valuable KPIs:
		- recency (months since last order)
		- average order value
		- average monthly spend

------------------------------------------------------------------------------------*/
WITH base_query as (
-- 1. Base Query: Retrieves core columns from tables
SELECT
f.order_number,
f.product_key,
f.order_date,
f.sales_amount,
f.quantity,
c.customer_key,
c.customer_number,
CONCAT(c.first_name, ' ' , c.last_name) as Customer_name,
DATEDIFF(YEAR, c.birthdate, GETDATE()) Age
from gold.fact_sales f
LEFT JOIN gold.dim_customers c
on c.customer_key = f.customer_key
where order_date IS NOT NULL)
, customer_aggregation as (
-- 2. Customer Aggregation: Summarizes key metrics at the customer level
Select
	customer_key,
	customer_number,
	Customer_name,
	age,
	COUNT(distinct order_number) as Total_Orders,
	SUM(sales_amount) as total_Sales,
	SUM(quantity) as Total_Quantity,
	COUNT(distinct product_key) as Total_Products,
	MAX(order_date) as last_order_date,
	DATEDIFF(month, MIN(order_date), MAX(order_date)) as lifespan
from base_query	
group by
	customer_key,
	customer_number,
	Customer_name,
	age
)
SELECT
customer_key,
customer_number,
customer_name,
age,
CASE
	WHEN age < 20 THEN 'Under 20'
	WHEN age between 20 and 29 THEN '20-29'
	WHEN age between 30 and 39 THEN '30-39'
	WHEN age between 40 and 49 THEN '40-49'
	ELSE '50 and above'
END as age_group,
CASE
	WHEN lifespan >= 12 AND total_Sales > 5000 THEN 'VIP'
	WHEN lifespan >= 12 AND total_Sales <= 5000 THEN 'Regular'
	ELSE 'New'
END AS Customer_Segment,
Last_order_Date,
DATEDIFF(month, last_order_date, GETDATE()) as Recency,
Total_Orders,
total_Sales,
Total_Quantity,
Total_Products,
last_order_Date,
lifespan,
-- Computing avrgae order value (AOV) - Total Sales / Total Numbers of Orders
CASE
	WHEN total_Sales = 0 THEN 0
	ELSE total_Sales / Total_Orders
END AS Avg_Order_Value,
-- Computing Average_Monthly_Spend
CASE
	WHEN lifespan = 0 THEN total_Sales
	ELSE total_Sales / lifespan
END AS Average_Monthly_Spend
from customer_aggregation

/* Product Report
	- This report consolidates key product metrics and behviours.

Highlights:
	1. Gathers essential fields such as product name, category, subcategory and cost
	2. Segments products by revenue to identify Hogh-Performers, Mid-Range or Low-Range
	3. Aggregates product-level metrics:
		- Total Orders
		- Total Sales
		- Total Quantity Sold
		- Total Customers (unique)
		- Lifespan (in Months)
	4. Calculates valuable KPIs:
		- Recency (Months since last sale)
		- Average Order Revenue (AOR)
		- Average Monthly Revenue
----------------------------------------------------------------------------------------------*/
WITH base_query AS (
-- 1. Base Query: Retrieves core columns from fact_sales and dim_products
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
	from gold.fact_sales f
	LEFT JOIN gold.dim_products p
		on f.product_key = p.product_key
	WHERE order_date IS NOT NULL)
, product_aggregation AS (
-- 2. Product Aggregation: Summarizes key metrics at the product level
SELECT
	product_key,
	product_name,
	category,
	subcategory,
	cost,
	DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) as lifespan,
	MAX(order_date) as last_sale_date,
	COUNT(distinct order_number) as Total_Orders,
	COUNT(distinct customer_key) as total_customers,
	SUM(sales_amount) as Total_Sales,
	SUM(quantity) as Total_Quantity,
	ROUND(AVG(CAST(sales_amount as FLOAT) / NULLIF(quantity, 0)), 1) as Avg_Selling_Price
from base_query
group by
	product_key,
	product_name,
	category,
	subcategory,
	cost)
-- 3. Final Query: Combines all product results into one output
SELECT
	product_key,
	product_name,
	category,
	subcategory,
	cost,
	last_sale_date,
	DATEDIFF(MONTH, last_sale_date, GETDATE()) AS Recency_in_Months,
	CASE
		WHEN Total_Sales > 50000 THEN 'High-Performer'
		WHEN Total_Sales >= 10000 THEN 'Mid-Range'
		ELSE 'Low-Performer'
	END AS Product_Segment,
	lifespan,
	Total_Orders,
	Total_Sales,
	Total_Quantity,
	total_customers,
	Avg_Selling_Price,
	-- Average Order Revenue (AOR)
	CASE
		WHEN Total_Orders = 0 THEN 0
		ELSE Total_Sales / Total_Orders
	END AS avg_order_revenue,
	-- Average Monthly Revenue
	CASE
		WHEN lifespan = 0 THEN Total_Sales
		ELSE Total_Sales / lifespan
	END as avg_monthly_revenue
from product_aggregation