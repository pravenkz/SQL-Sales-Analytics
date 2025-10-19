# 🛍️ Fashion Retail Sales Analytics (SQL Project)

## 🏁 Project Goal
The goal of this project is to perform a comprehensive **sales analysis for a fashion retail business** using SQL.  
The analysis focuses on uncovering key performance drivers such as **monthly revenue growth (MoM)**, **product category contributions**, **profit margins by product and category**, **customer loyalty**, and **channel effectiveness**.

In addition, advanced analytical models like **RFM segmentation**, **Customer Lifetime Value (CLV)**, and **customer churn indicators** were implemented to evaluate retention and long-term business health.

By combining these insights, the project delivers a detailed **sales performance report** that highlights how the business is performing across sales, customer, and product dimensions — enabling data-driven decisions to **optimize revenue, improve marketing strategies, identify high-margin products, and enhance customer engagement**.

---

## 🧱 Step 2: Data Collection & Preparation
The dataset was sourced from [**Kaggle – European Fashion Store Multi-table Dataset**](https://www.kaggle.com/datasets/joycemara/european-fashion-store-multitable-dataset).

The data was first loaded into **Excel** for initial cleaning and structuring.  
Using **Power Query**, several preprocessing tasks were performed:
- Replaced numerical values in the **size** column with text categories (e.g., `36-38` → `M`, `38-40` → `L`).
- Validated column integrity to ensure there were no mismatched or erroneous values.
- Checked for missing or duplicate records.
- **Extracted `customer_id`** from an aggregated customer table and merged it into the main fact table (`sales`) using Power Query.
- Renamed and organized columns for SQL schema alignment.
- Saved the cleaned files in **CSV format** for easy SQL import.

---

## 🗃️ Step 3: Database Creation & Data Loading
A new SQL Server database named **`fashionDB`** was created.

**Key steps:**
- Created a **schema** named `fashion` for logical organization.
- Defined **three core tables** — `fashion.sales`, `fashion.customers`, and `fashion.products`.
- Applied **primary** and **foreign key** constraints for referential integrity.
- Imported data using **`BULK INSERT`** for efficiency.

This formed a strong relational foundation for subsequent analysis.

---

## 🔍 Step 4: Exploratory Data Analysis (EDA)
An **EDA** was conducted to understand the structure, quality, and distribution of data before performing business analysis.

**Steps performed:**
- **Schema Exploration:** Verified tables and columns via `INFORMATION_SCHEMA`.
- **Date Exploration:** Identified min/max sale dates, time span, and months covered.
- **Dimension Exploration:** Counted unique values in customers, products, and countries.
- **Measure Exploration:** Calculated total, average, and standard deviation for key measures.

✅ This ensured data completeness and reliability before deeper analysis.

---

## 💡 Step 5: Business Analysis & Insights

### 🧾 Sales Insights
- **Total Revenue:** ₹324,236  
- **Transactions:** 2,253  
- **Quantity Sold:** 6,715  
- **AOV:** ₹143  
- **Highest Revenue Month:** May  
- **Top Channel:** Website Banner – **52%** revenue  
- **ASP:** ₹649  

💬 *Insight:* May showed peak performance.

---

### 👤 Customer Insights
- **Active Customers:** 580 / 1,000  
- **Signup Spike:** March–April  
- **Avg Days to First Order:** 51  
- **ARPC:** ₹559  
- **Top Countries:** France (23%) and Germany (22%)  
- **Highest Repeat Purchase Rate:** 22.98% (May)  
- **Customer Segments:** VIP, Loyal, Regular  

💬 *Insight:* France and Germany are high-value markets; engagement peaks mid-year.

---

### 🛍️ Product Insights
- **Top Categories:** Dress Shoes & T-Shirts  
- **Most Profitable Category:** T-Shirts  
- **Most Sold Size:** S  
- **Product Life Cycle:** Short-Lived, Lasting, Evergreen  
- **Popularity Trend:** Identified gaining vs. losing products via MoM comparison  

💬 *Insight:* T-Shirts have the best margin; Dress Shoes sustain long-term sales.

---

### 📈 Advanced Analytics
- **RFM Segmentation:** VIP, Loyal, Regular  
- **CLV Calculation:** Based on AOV × Purchase Frequency × Duration  
- **Churn Segmentation:** Active (<45 days), At Risk (45–90 days), Churned (>90 days)  
- **Churn Rate:** ~29%

💬 *Insight:* ~1/3 of customers show inactivity — retention strategy needed.

---

### 🧩 Key Takeaways
- May drives top performance and customer engagement.  
- Website Banner is the most profitable campaign.  
- France & Germany contribute nearly half of total revenue.  
- 29% churn rate → potential for loyalty & retention campaigns.

---

## ⚙️ Step 6: Data Modeling & Performance Optimization

### 🧩 View Creation
- Created reusable SQL **views** for summaries across `sales`, `customers`, and `products`.
- Reduced complexity and improved query readability.

### ⚡ Indexing Strategy
Applied a **hybrid indexing model**:
- **Fact Table (`fashion.sales`):**
  - **Clustered Columnstore Index** for analytical aggregation.
  - **Nonclustered Indexes** on `customer_id`, `product_id` for faster joins.
- **Dimension Tables (`fashion.customers`, `fashion.products`):**
  - **Nonclustered Indexes** on `country`, `category` for grouping/filtering.


---

## 🧠 Key Learnings
- Built an end-to-end SQL analytics pipeline.
- Learned efficient schema design & hybrid indexing.  
- Strengthened business understanding (RFM, CLV, churn).  
- Enhanced ability to derive actionable insights for data-driven strategy.

---

## 🧩 Project Execution Order

| Step | File | Description |
|------|------|-------------|
| 1️⃣ | `01_Data_Setup.sql` | Create DB, schema, tables, and bulk insert data |
| 2️⃣ | `02_EDA Analysis.sql` | Define views and performance indexes |
| 3️⃣ | `03_Business_Insights.sql` | Perform EDA and validate data |
| 4️⃣ | `04_views and indexes.sql` | Generate business insights |

---

## 🛠️ Tech Stack
- **SQL Server (T-SQL)** – database & analytics  
- **Excel + Power Query** – data cleaning   
- **GitHub** – version control  

---

## 🚀 Future Goals
- Introduce **campaign and discount impact analysis** to understand promotional effectiveness.  
- Integrate additional datasets to explore **seasonal trends and price elasticity**.  
- Develop a **Power BI dashboard** for visual storytelling of key KPIs and trends.  

---

## ✨ Conclusion
This project demonstrates a complete **end-to-end SQL analytics workflow** — from data preparation and modeling to performance tuning and business insights.  
It highlights practical skills in **data transformation, advanced querying, and analytical storytelling**, forming a solid foundation for data-driven business decision-making.
