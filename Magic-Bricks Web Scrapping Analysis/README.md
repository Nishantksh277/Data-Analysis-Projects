# 🏡 Real Estate Web Scraping & Data Analysis – MagicBricks (Noida)

## 📌 Objective
To extract real-time real estate property listings from [MagicBricks](https://www.magicbricks.com) for Noida, and perform insightful data analysis using Python.

---

## 🛠️ Tools & Technologies Used
- **Python**
- **Selenium** – For browser automation and interaction
- **BeautifulSoup** – For HTML parsing
- **Pandas** – For data manipulation and analysis
- **Jupyter Notebook**

---

## 📥 Data Collection (Web Scraping)

### Steps Followed:
1. Used **Selenium** to open MagicBricks and search properties in *Noida*.
2. Waited for the results to load and fetched HTML using `driver.page_source`.
3. Parsed the HTML content using **BeautifulSoup**.
4. Extracted:
   - Property Title
   - Price (₹)
   - Area (sqft)
   - BHK
   - Sector
   - Project Name
   - Property Type
   - Status (e.g., New/Resale, Under Construction)

---

## 📊 Data Processing

- Cleaned and parsed prices into numeric (float) values.
- Extracted numeric area (super area in sqft).
- Parsed BHK (e.g., 2 BHK → 2), Sector (e.g., Sector 121 → 121).
- Created a final DataFrame with relevant fields.

---

## 📈 Data Analysis Highlights

### Top 5 Cheapest Properties (₹/sqft)
Properties sorted by lowest price per square foot.

### Top 5 Costliest Properties (₹/sqft)
Properties sorted by highest price per square foot.

### Top 5 Value-for-Money Properties
Properties with:
- **Large area**
- **Low price per sqft**

Calculated using a custom score = `area / (price per sqft)`

---

## 🔍 Sample Insight

| Title | Price (Cr) | Area (sqft) | ₹/sqft | BHK | Sector |
|-------|-------------|--------------|--------|-----|--------|
| 3 BHK in Sector 115 | 4.06 Cr | 2304 | 17622 | 3 | 115 |
| 2 BHK in Noida Ext. | 1.25 Cr | 1385 | 9025 | 2 | — |

---

## 📌 Conclusion

- Successfully scraped **120+ properties** from MagicBricks.
- Extracted and cleaned valuable data for real estate buyers/investors.
- Filtered insights for best value, lowest price/sqft, and luxury options.
- This project simulates a **real-world data analyst task** with **ETL + EDA**.

---

## 🧠 Skills Demonstrated

- Web Scraping Automation
- Data Cleaning & Parsing
- DataFrame Manipulation
- Insight Extraction & Ranking
- Real-world Data Analysis Workflow

---


