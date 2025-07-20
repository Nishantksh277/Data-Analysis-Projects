Create Database Amazon_sales;

use Amazon_sales;

Create table Sales_data (
idx INT,
Order_ID VARCHAR(255),
Date date,
Status VARCHAR(255),
Fulfilment VARCHAR(255),
Sales_Channel VARCHAR(255),
ship_service_level VARCHAR(255),
Style VARCHAR(255),
SKU VARCHAR(255),
Category VARCHAR(255),
Size VARCHAR(255),
ASIN VARCHAR(255),
Courier_Status VARCHAR(255),
Qty INT,
Amount FLOAT,
ship_city VARCHAR(255),
ship_state VARCHAR(255),
Total_Sales INT
);

Select * from sales_data;

SHOW VARIABLES LIKE "secure_file_priv";

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Amazon Sales Clean data.csv'
INTO TABLE sales_data
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Running Total of Sales
select 
date, Total_Sales,
sum(Total_Sales) over (partition by date) as Sales_Running_total
from sales_data;

-- Rank Sales
select
date, Total_Sales,
RANK() over (partition by date order by Total_Sales DESC) as Sales_Rank
from sales_data;

-- Sales of shipped Items
Select sum(Total_Sales)
from sales_data
where status = 'Shipped';

-- Total Orders
Select count(order_ID) as Total_Orders
from sales_data;

-- Non Amazon Orders count and Total Sales
Select count(sales_Channel), sum(Total_Sales) as Total_Sales
from sales_data
where Sales_channel != 'Amazon.in';

-- Amazon orders count and Total Sales
Select count(sales_Channel), sum(Total_Sales) as Total_Sales
from sales_data
where Sales_channel = 'Amazon.in';

-- March Month Sales
Select Month(Date) as Month, sum(Total_Sales) as Total_Sales
from Sales_Data
where Month(Date) = 03
group by Month(Date);

-- June Month Sales
Select Month(Date) as Month, sum(Total_Sales) as Total_Sales
from Sales_Data
where Month(Date) = 06
group by Month(Date);

-- March - June total Sales
Select Month(Date) as Month, Sum(Total_Sales) as Total_Sales
from Sales_data
where Month(Date) between 03 AND 06
group by Month(Date)
Order by Month(Date) ASC;

-- Using Case to check sales of each month as Month Name
Select
CASE
WHEN Month(Date) = 3 THEN 'March'
WHEN Month(Date) = 4 THEN 'April'
WHEN Month(Date) = 5 THEN 'MAY'
WHEN Month(Date) = 6 THEN 'June'
End as Months,
Sum(Total_sales)
from Sales_Data
group by Months;

-- total Sales of Kurta
Select Category, Sum(Total_Sales) as Total_Sales
from Sales_Data
Where Category = "Kurta";

-- Top 3 categories
Select Distinct(Category), sum(Total_Sales) as Total_Sales
from Sales_Data
group by Category;

-- Count of Cancelled Orders
Select Count(Status)
from Sales_Data
where Status = 'Cancelled';

-- Canclled Items Sales
Select sum(Total_Sales)
from Sales_Data
where Status = 'Cancelled';

-- Total Sales
Select sum(total_Sales)
from sales_data;

-- Sales of each City
select distinct(ship_city), sum(Total_Sales) as Total_Sales
from Sales_Data
group by ship_city
Limit 5;

-- Sales of each state
Select distinct(ship_state), Sum(Total_Sales) as Total_Sales
from Sales_data
group by ship_state;

-- Sales of each sizes
Select distinct(Size), Sum(Total_Sales) as Total_Sales
from Sales_Data
group by Size;

-- Category Rank()
Select Category, sum(Total_Sales) as Total_sales,
RANK() OVER (Order by sum(Total_Sales) DESC) as Category_Rank
from Sales_data
group by Category;

-- Category Dense_Rank()
SELECT 
  Category,
  SUM(Total_Sales) AS Total_Sales,
  DENSE_RANK() OVER (ORDER BY SUM(Total_Sales) DESC) AS Category_Rank
FROM 
  Sales_data
GROUP BY 
  Category;

-- Category ROW_NUMBER()
Select Category, sum(Total_Sales) as Total_sales,
ROW_NUMBER() OVER (Order by sum(Total_Sales) DESC) as Category_Rank
from Sales_data
group by Category;

-- Avg Sales of category
With AvgSalesbyCategory AS (
	Select Category, Avg(Total_Sales) AS Avg_Sales
    From Sales_Data
    Group by Category
)
Select *
From AvgSalesbyCategory;

-- INDEX of Order_ID
create INDEX idx_Order_id
on Sales_Data (Order_ID);

-- Each Category Sales B/W 1000000 AND 10000000
Select Category, Sum(Total_Sales) as Total_Sales
from sales_data
group by Category
having Total_Sales between 1000000 AND 10000000;

-- % contribution of each category
Select Category,
sum(Total_sales) as Total_Sales, 
round(100.0 * sum(Total_Sales) / (Select Sum(Total_Sales) from Sales_Data), 2) as Percentage_Contribution
from Sales_Data
group by Category;

-- Moving Average of Sales (7-day window) – Advanced Window Function
select Date,
Total_Sales,
AVG(Total_Sales) OVER (ORDER BY Date ROWS BETWEEN 6 PRECEDING and Current Row) as Moving_Avg
from Sales_data;

-- Monthly Growth Rate
WITH MonthlySales AS (
  SELECT 
    EXTRACT(MONTH FROM Date) AS Month,
    SUM(Total_Sales) AS Sales
  FROM Sales_data
  GROUP BY EXTRACT(MONTH FROM Date)
)
SELECT 
  Month,
  Sales,
  LAG(Sales) OVER (ORDER BY Month) AS Prev_Month_Sales,
  ROUND(100.0 * (Sales - LAG(Sales) OVER (ORDER BY Month)) / NULLIF(LAG(Sales) OVER (ORDER BY Month), 0), 2) AS Growth_Percentage
FROM MonthlySales;

-- Find Duplicate Orders
Select order_id, count(*) as count
from Sales_Data
group by Order_ID
having count(*) > 1;

-- Filter Only Weekend Orders
Select * 
from Sales_Data
where dayofweek(Date) IN (1,7); -- 1 = Sunday, 7 = Saturday

-- Time Between Orders
SELECT 
  Order_ID,
  Date,
  LAG(Date) OVER (ORDER BY Date) AS Prev_Order_Date,
  DATEDIFF(Date, LAG(Date) OVER (ORDER BY Date)) AS Days_Between_Orders
FROM Sales_data;

