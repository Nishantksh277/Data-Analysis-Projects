# 🛒 E-Commerce Sales Analysis (Amazon Sales Project)

## 📊 Project Overview

This project focuses on analyzing Amazon e-commerce sales data to derive actionable insights that can help in business decision-making. Using a combination of **Python (Pandas, Seaborn, Matplotlib)** for data cleaning and EDA, and **MySQL** for deep SQL analysis, the project demonstrates a full-cycle data analysis pipeline from raw data to business intelligence.

---

## 🎯 Objective

The goal was to:
- Clean and preprocess e-commerce sales data.
- Perform exploratory data analysis (EDA) to understand customer behavior and sales patterns.
- Use SQL to uncover business insights like best-performing categories, city/state-wise sales, monthly trends, and customer order behaviors.

---

## 🧰 Tools & Technologies

| Tool          | Purpose                                |
|---------------|----------------------------------------|
| Python (Jupyter Notebook) | Data Cleaning, Feature Engineering, EDA |
| Pandas & NumPy | Data manipulation & wrangling          |
| Seaborn & Matplotlib | Data visualization                 |
| MySQL         | Advanced sales analysis using SQL      |

---

## 🔍 Project Workflow

### 1. **Data Cleaning & Preprocessing** (Python)
- Checked for null values and missing data.
- Converted date formats and ensured consistency.
- Created new feature: `Total_Sales` = `Qty * Amount`.
- Exported the cleaned data into a CSV file and imported it into MySQL.

### 2. **Exploratory Data Analysis (EDA)** (Python)
- Analyzed sales by category, state, city, size.
- Time series visualization of daily and monthly sales trends.
- Visualized sales distribution and top/bottom performing product categories.

### 3. **SQL Business Analysis**
Using MySQL queries:
- ✔ Total Orders, Shipped Orders, Cancelled Orders
- ✔ Sales trend from March to June
- ✔ Category-wise, City-wise, and State-wise Sales
- ✔ Sales Channel comparison (Amazon.in vs Non-Amazon)
- ✔ Moving Average and Monthly Growth % using Window Functions
- ✔ % Contribution of Categories to Total Sales
- ✔ RANK, DENSE_RANK, and ROW_NUMBER for category ranking
- ✔ Identified Duplicate Orders and Weekend Sales
- ✔ Time Difference Between Orders (Customer Buying Behavior)

---

## 📈 Key Insights

- **Top Performing Categories** contributed over 60% of total sales.
- **Non-Amazon channels** had significantly lower contribution compared to **Amazon.in**.
- **March to June** showed seasonal sales trends with visible growth peaks.
- **Category “Kurta”** stood out as one of the highest selling products.
- **Moving Average & Growth %** helped highlight strong and weak months.
- **City-level analysis** allowed identification of high-demand regions.

---

## 📂 File Structure

```bash
E-Commerce-Sales-Analysis/
│
├── E-Commerce Sales Analysis.ipynb   # Python Notebook for data cleaning & EDA
├── E-Commerce Sales Queries.sql      # SQL queries for business analysis
└── README.md                         # Project Documentation
