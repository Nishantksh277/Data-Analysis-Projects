Create Database Customer_Churn;

use Customer_Churn;

CREATE TABLE customer_churn (
  customerID VARCHAR(20),
  gender VARCHAR(10),
  SeniorCitizen INT,
  Partner VARCHAR(10),
  Dependents VARCHAR(10),
  tenure INT,
  PhoneService VARCHAR(10),
  MultipleLines VARCHAR(20),
  InternetService VARCHAR(20),
  OnlineSecurity VARCHAR(20),
  OnlineBackup VARCHAR(20),
  DeviceProtection VARCHAR(20),
  TechSupport VARCHAR(20),
  StreamingTV VARCHAR(20),
  StreamingMovies VARCHAR(20),
  Contract VARCHAR(20),
  PaperlessBilling VARCHAR(10),
  PaymentMethod VARCHAR(30),
  MonthlyCharges FLOAT,
  TotalCharges FLOAT,
  Churn VARCHAR(10),
  AvgMonthlyRevenue FLOAT,
  ChurnFlag INT,
  RevenueLost FLOAT,
  CustomerSegment VARCHAR(20)
);

SHOW VARIABLES LIKE "secure_file_priv";

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Customer Churn.csv'
INTO TABLE customer_churn
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

Select * from customer_churn;

-- Basic KPI's
-- Find Total Customers, Churned Customers and Churn Rate
Select
	count(*) as Total_Customers, -- Total Customers
	sum(ChurnFlag) as Churned_Customers, -- Churned Customers
	round(sum(ChurnFlag) * 100.0 / count(*), 2) as Churn_Rate -- Churn Rate
from customer_churn;

-- Churn By Contract Type
select
	 Contract,
	count(*) as Total_Customers,
	sum(ChurnFlag) as Churned_Customers,
    round(sum(ChurnFlag) * 100.0 / count(*), 2) as Churn_Rate
from customer_churn
group by Contract
order by Churn_Rate DESC;

-- Revenue Lost due to Churn
Select
	round(Sum(RevenueLost), 2) as Total_Revenue_Lost
from customer_churn
where Churn = "Yes";

-- Churn by Gender
Select
	Gender,
    count(*) as Total_Customers,
	sum(ChurnFlag) as Churned_Customers,
    round(sum(ChurnFlag) * 100.0 / count(*), 2) as Churn_Rate
from customer_churn
group by Gender;

-- Churn Rate by Tenure Band (New vs Loyal vs Very Loyal)
select
	CASE
    when tenure < 12 then "New"
    when tenure between 12 and 36 then "Loyal"
    Else "VeryLoyal"
    End as Tenure_Segments,
    count(*) as Total_Customers,
	sum(ChurnFlag) as Churned_Customers,
    round(sum(ChurnFlag) * 100.0 / count(*), 2) as Churn_Rate
    from customer_churn
    group by Tenure_Segments;
    
-- Churn due to Internet Service
Select
	InternetService,
    count(*) as Total_Customers,
	sum(ChurnFlag) as Churned_Customers,
    round(sum(ChurnFlag) * 100.0 / count(*), 2) as Churn_Rate
from customer_churn
group by InternetService;

-- churn vs Senior Citizens
Select 
	SeniorCitizen,
    count(*) as Total_Customers,
	sum(ChurnFlag) as Churned_Customers,
    round(sum(ChurnFlag) * 100.0 / count(*), 2) as Churn_Rate
from customer_churn
group by SeniorCitizen;
-- Note: 0 shows 'No SeniorCitizen' while 1 shows 'SeniorCitizen' 

-- Churn due to Tech Support
select
	TechSupport,
    count(*) as Total_Customers,
	sum(ChurnFlag) as Churned_Customers,
    round(sum(ChurnFlag) * 100.0 / count(*), 2) as Churn_Rate
from customer_churn
group by TechSupport;

-- churn due to Payment Method
select
	PaymentMethod,
    count(*) as Total_Customers,
	sum(ChurnFlag) as Churned_Customers,
    round(sum(ChurnFlag) * 100.0 / count(*), 2) as Churn_Rate
from customer_churn
group by PaymentMethod;

-- Monthly Charges Distribution for Churned vs Non-Churned
Select
	churn,
    round(Avg(MonthlyCharges), 2) as Avg_Monthly_Charges,
    round(max(MonthlyCharges), 2) as Max_Monthly_Charges,
    round(min(MonthlyCharges), 2) as Min_Monthly_Charges
from customer_churn
group by Churn;

-- Average Tenure by Churn Status
Select
	Churn,
	round(Avg(tenure), 2) as Avg_Tenure
from customer_churn
group by Churn;

-- Customers Without Tech Support and Their Churn Rate
Select
	count(*) as Total_Customers,
	sum(ChurnFlag) as Churned_Customers,
    round(sum(ChurnFlag) * 100.0 / count(*), 2) as Churn_Rate
from customer_churn
where TechSupport = "No";

-- Top 10 High Revenue Lost Custoers
Select
	CustomerID,
    RevenueLost,
    MonthlyCharges,
    tenure
from customer_churn
where churn = "Yes"
order by RevenueLost DESC
limit 10;

-- Customers with MonthlyCharges > ₹80 and Churned
select 
count(*) as High_Value_Churned
from customer_churn
where MonthlyCharges > 80 and Churn = "Yes";

-- Churn by Streaming Services
Select
	StreamingTV,
    StreamingMovies,
	count(*) as Total_Customers,
	sum(ChurnFlag) as Churned_Customers,
    round(sum(ChurnFlag) * 100.0 / count(*), 2) as Churn_Rate
from customer_churn
group by StreamingTV, StreamingMovies
order by Churn_Rate DESC;

select count(SeniorCitizen)
from customer_churn


    
    
