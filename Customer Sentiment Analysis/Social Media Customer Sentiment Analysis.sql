Create database Customer_sentiment;

use Customer_sentiment;

CREATE TABLE sentiment_data (
    id INT PRIMARY KEY,
    Text TEXT,
    Sentiment VARCHAR(20),
    Timestamp DATETIME,
    User VARCHAR(100),
    Platform VARCHAR(50),
    Hashtags TEXT,
    Retweets INT,
    Likes INT,
    Country VARCHAR(50),
    Year INT,
    Month INT,
    Day INT,
    Hour INT
);

SHOW VARIABLES LIKE "secure_file_priv";

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Cleaned_sentimentdataset.csv"
INTO TABLE sentiment_data
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

Select * from Sentiment_data;

-- Q1. Sentiment Distribution
select sentiment, count(*) as Total_Posts
from Sentiment_data
group by sentiment;

-- Q2. Top 5 Countries by Post Count
select Country , count(*) as Total_Posts
from Sentiment_data
group by country;

-- Q3. Hourly Activity
select Hour, count(*) as Total_Posts
from Sentiment_data
group by Hour
order by Hour;

-- Q4. Average Likes & Retweets by Sentiment
Select Sentiment,
	round(Avg(Likes), 2) as Avg_Likes,
    round(Avg(Retweets), 2) as Avg_Retweets
from Sentiment_data
group by Sentiment;

-- Q5. Posts by Platforms and Sentiment
select sentiment, Platform, count(*) as Total_Posts
from Sentiment_data
group by Sentiment, Platform
order by Platform;

-- Q6. Monthly Sentiment Trend
select year, month, sentiment, count(*) as Post_Count
from Sentiment_data
group by year, month, sentiment
order by year, month;

-- Q7. Most posts from which Platform?
Select count(*) as Post_Count, platform
from Sentiment_data
group by platform;

-- Q8. positive Post Count
Select count(*) as Post_Count
from sentiment_data
where sentiment = "Positive";

-- Q9. Negative Post Count
Select count(*) as Post_Count
from sentiment_data
where sentiment = "Negative";

-- Q10. Neutral Post Count
Select count(*) as Post_Count
from sentiment_data
where sentiment = "Neutral";

Select count(id)
from sentiment_data