/* =========================================================
   PROJECT: E-Commerce Sales Analys
   DATABASE: grid_sales
   OBJECTIVE:
   - Combine multi-year order data
   - Join customer & product details
   - Create KPIs (Revenue, Profit, Margin)
   - Perform business analysis
========================================================= 
   -- Run this entire script to generate all reports
========================================================= */

-- 1️ Use Database
USE grid_sales;

-- Explore Datasets
select * from orders_2023;
select * from orders_2024;
select * from orders_2025;
select * from customers;
select * from products;

-- 2️  Create Temporary Combined Table (Reusable)
DROP TEMPORARY TABLE IF EXISTS order_all;

CREATE TEMPORARY TABLE order_all AS
SELECT OrderID, CustomerID, ProductID, OrderDate, Quantity, Revenue, COGS FROM orders_2023
UNION ALL
SELECT OrderID, CustomerID, ProductID, OrderDate, Quantity, Revenue, COGS FROM orders_2024
UNION ALL
SELECT OrderID, CustomerID, ProductID, OrderDate, Quantity, Revenue, COGS FROM orders_2025;

-- =========================================================
--  3️ OVERALL KPI SUMMARY
-- =========================================================
SELECT 
    'Overall KPI Summary' AS Report,
    COUNT(DISTINCT OrderID) AS Total_Orders,
    COUNT(DISTINCT CustomerID) AS Total_Customers,
    ROUND(SUM(Revenue),2) AS Total_Revenue,
    ROUND(SUM(COGS),2) AS Total_Cost,
    ROUND(SUM(Revenue - COGS),2) AS Total_Profit,
    ROUND(AVG(Revenue),2) AS Avg_Order_Value,
    ROUND((SUM(Revenue - COGS)/SUM(Revenue))*100,2) AS Profit_Margin
FROM order_all;

-- =========================================================
-- 4 REVENUE BY CATEGORY
-- =========================================================
SELECT 
    'Revenue by Category' AS Report,
    c.ProductCategory,
    ROUND(SUM(o.Revenue),2) AS Revenue
FROM order_all o
JOIN products c ON o.ProductID = c.ProductID
GROUP BY c.ProductCategory
ORDER BY Revenue DESC;

-- =========================================================
--  5️ TOP 5 PRODUCTS
-- =========================================================
SELECT 
    'Top 5 Products' AS Report,
    c.ProductName,
    ROUND(SUM(o.Revenue),2) AS Revenue
FROM order_all o
JOIN products c ON o.ProductID = c.ProductID
GROUP BY c.ProductName
ORDER BY Revenue DESC
LIMIT 5;

-- =========================================================
--  6️ REGION PERFORMANCE
-- =========================================================
SELECT 
    'Region Performance' AS Report,
    cu.Region,
    ROUND(SUM(o.Revenue),2) AS Revenue,
    ROUND(SUM(o.Revenue - o.COGS),2) AS Profit
FROM order_all o
JOIN customers cu ON o.CustomerID = cu.CustomerID
GROUP BY cu.Region
ORDER BY Revenue DESC;

-- =========================================================
-- 📊 7️ MONTHLY TREND
-- =========================================================
SELECT 
    'Monthly Trend' AS Report,
    YEAR(OrderDate) AS Year,
    MONTH(OrderDate) AS Month,
    ROUND(SUM(Revenue),2) AS Revenue
FROM order_all
GROUP BY Year, Month
ORDER BY Year, Month;

-- =========================================================
-- 📊 8️ CUSTOMER ANALYSIS (CLV)
-- =========================================================
SELECT 
    'Customer Analysis' AS Report,
    CustomerID,
    ROUND(SUM(Revenue),2) AS Customer_Value,
    COUNT(OrderID) AS Orders
FROM order_all
GROUP BY CustomerID
ORDER BY Customer_Value DESC;

-- =========================================================
-- 9️ PROFIT BY CATEGORY
-- =========================================================
SELECT 
    'Profit by Category' AS Report,
    c.ProductCategory,
    ROUND(SUM(o.Revenue - o.COGS),2) AS Profit
FROM order_all o
JOIN products c ON o.ProductID = c.ProductID
GROUP BY c.ProductCategory
ORDER BY Profit DESC;

-- =========================================================
-- PRODUCT RANKING
-- =========================================================
SELECT 
    'Product Ranking' AS Report,
    ProductName,
    Revenue,
    RANK() OVER (ORDER BY Revenue DESC) AS Rank_Position
FROM (
    SELECT 
        c.ProductName,
        SUM(o.Revenue) AS Revenue
    FROM order_all o
    JOIN products c ON o.ProductID = c.ProductID
    GROUP BY c.ProductName
) t;

-- =========================================================
-- END OF SCRIPT
-- =========================================================