# 🛒 E-Commerce Sales Analysis | Power BI + MySQL

## 📊 End-to-End Data Analytics Project

The project demonstrates an end-to-end data analytics workflow using **MySQL and Power BI** to analyze sales performance, customer behavior, and product trends.

---

## 🚀 Project Overview

- Analyze multi-year sales data (2023–2025)
- Identify top-performing products and customers
- Evaluate regional performance
- Improve profitability through data-driven insights

---

## 🧱 Tech Stack

- 🗄️ MySQL → Data extraction, transformation, analysis  
- 📊 Power BI → Dashboard & visualization  
- 📐 DAX → KPI calculations and dynamic metrics  

---

## 📂 Dataset

The dataset includes:

- Orders (2023–2025)
- Customers (Region, Join Date)
- Products (Category, Cost, Price)

---

## ⚙️ Key Features

- Multi-year data consolidation using SQL (CTE)
- Dynamic KPI switching (Revenue / Profit / Margin)
- Drill-through product analysis
- Regional and category insights
- Time-series trend analysis

---

## 📊 Dashboard Preview

<img width="1388" height="799" alt="Sales Analysis Dashboard" src="https://github.com/user-attachments/assets/0ba5a811-a0ac-4b97-9021-d7a7eb2f3bf2" />

Product Performance

<img width="1400" height="809" alt="Sales Analysis Dashboard 11" src="https://github.com/user-attachments/assets/2f80db9b-a3bc-4c25-b182-3158e36ace2e" />


---

## 📈 Key KPIs

- Total Revenue: **$863K**
- Total Profit: **$473K**
- Profit Margin: **54.81%**
- Total Orders: **4K**
- Total Customers: **200**
- Avg Order Value: **196.70**

---

## 🧠 Key Insights

### 💰 Revenue & Trends
- Strong seasonal spikes observed (Q4 peaks)
- Consistent revenue growth trend

### 🛍️ Product Performance
- Grinders & Brewers is the top-performing category
- Top 5 products contribute the majority of revenue

### 🌍 Regional Analysis
- The West region dominates revenue and profit
- Other regions show growth potential

### 👥 Customer Insights
- High-value customers drive significant revenue
- Strong repeat purchase behavior

### 📉 Profitability
- Some products generate high revenue but low margins
- Opportunity to optimize pricing and costs

---

## 🔍 Advanced Analysis

- Revenue Contribution %
- Revenue Growth %
- Product Ranking
- Profit Segmentation

---

## 📦 SQL Analysis

- Data cleaning & transformation
- KPI calculations
- Category, region, and customer analysis
- One-click summary report

---

## ⚡ DAX Measures Metric Selector

``` DAX
KPI = 
SWITCH(
    SELECTEDVALUE('Metric'[Metric Selector]),
    "Revenue", [Total Revenue],
    "Profit", [Profit],
    "Margin", [Profit Margin %]
)
