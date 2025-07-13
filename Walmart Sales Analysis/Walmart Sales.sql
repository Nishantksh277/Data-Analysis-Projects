Create database Walmart;

use Walmart;

CREATE TABLE Walmart_Sales (
    invoice_id INT PRIMARY KEY,
    branch VARCHAR(20),
    city VARCHAR(20),
    category VARCHAR(255),
    unit_price float,
    quantity float,
    date TEXT,
    time TEXT,
    payment_method VARCHAR(20),
    rating float,
    profit_margin float,
    total_sales INT
    );

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Walmart_Clean_Data.csv"
INTO TABLE Walmart_Sales
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

Select * from walmart_Sales;

-- 1. Top 5 Cities/Branches by Total Sales
Select city, branch, sum(total_sales) as Total_Sales
from walmart_sales
group by city, branch
order by total_sales DESC
Limit 5;

-- 2. Monthly Sales Trend
Select
date_format(date, '%y-%m') as Sales_Month,
sum(total_sales) as Total_Sales
from walmart_Sales
Group by Sales_Month
order by Sales_Month;

-- 3. Store-Wise Average Rating
Select branch, 
round(avg(rating), 2) as Avg_Rating
from walmart_sales
Group by branch;

-- 4. Payment Method Usage Distribution
Select payment_method,
Count(*) as Total_Transactions,
round(100 * count(*) / (Select count(*) from walmart_Sales), 2) as percentage
from Walmart_Sales
group by payment_method
order by Total_Transactions DESC;

-- 5. Top 5 Product Categories by Sales
Select Category,
sum(total_sales) as Total_Sales
from Walmart_Sales
group by Category
order by Total_Sales DESC;

-- 6. Sales by Day of the Week
Select 
dayname(date) as day_of_week,
sum(total_sales) as TotaL_Sales
from walmart_Sales
group by day_of_week
order by field(day_of_week, 'Monday', 'Tuesday', 'Wednesday', 'Thrusday', 'Friday', 'Saturday', 'Sunday');

-- 7. Profit Margin by Store
Select branch,
round(avg(profit_margin), 2) as Avg_Profit_Margin,
round(avg(total_sales), 2) as Avg_Total_Sales
from walmart_Sales
group by branch
order by Avg_Profit_Margin, Avg_Total_Sales DESC;

-- 8. Total transactions
Select count(invoice_id)
from walmart_sales;

-- 9. Avg_Order_value
select
round((sum(total_sales) / count(invoice_id)), 2) as Avg_Order_Value
from walmart_Sales








