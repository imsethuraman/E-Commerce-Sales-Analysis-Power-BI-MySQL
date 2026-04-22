/* =========================================================
   PROJECT: E-Commerce Sales Analysis (MySQL)
   DATABASE: grid_sales
   OBJECTIVE:
   - Combine multi-year order data
   - Join customer & product details
   - Create KPIs (Revenue, Profit, Margin)
   - Perform business analysis
========================================================= */

-- Use Database
USE grid_sales;

-- Explore Datasets
select * from orders_2023;
select * from orders_2024;
select * from orders_2025;
select * from customers;
select * from products;

-- =========================================================
-- 2️.Combine Data from Multiple Years
-- =========================================================
/*
We combine orders from 2023, 2024, and 2025
UNION ALL is used to Combine the datasets
*/

WITH order_all AS (
    SELECT OrderID, CustomerID, ProductID, OrderDate, Quantity, Revenue, COGS FROM orders_2023
    UNION ALL
    SELECT OrderID, CustomerID, ProductID, OrderDate, Quantity, Revenue, COGS FROM orders_2024
    UNION ALL
    SELECT OrderID, CustomerID, ProductID, OrderDate, Quantity, Revenue, COGS FROM orders_2025
)

-- =========================================================
-- 3️ Create Final Dataset (JOIN + Calculations)
-- =========================================================
/*
Join:
- customers → Region, Join Date
- products → Product details

Create:
- Profit
- Profit Margin
- Year & Month for analysis
*/

with Cleaned_data as(
SELECT 
    a.OrderID,
    a.CustomerID,
    a.ProductID,
    a.OrderDate,

    YEAR(a.OrderDate) AS Year,
    MONTH(a.OrderDate) AS Month,

    a.Quantity,
    a.Revenue,
    a.COGS,

    -- Profit Calculation
    (a.Revenue - a.COGS) AS Profit,

    -- Profit Margin %
    ROUND(((a.Revenue - a.COGS) / a.Revenue) * 100, 2) AS Profit_Margin,

    b.Region,
    b.CustomerJoinDate,

    c.ProductName,
    c.ProductCategory,
    c.Price,
    c.Base_Cost

FROM order_all a
LEFT JOIN customers b 
    ON a.CustomerID = b.CustomerID
LEFT JOIN products c 
    ON a.ProductID = c.ProductID);



-- =========================================================
-- 4️ KPI: Overall Business Performance
-- =========================================================
/*
Key Metrics:
- Total Orders
- Revenue
- Cost
- Profit
*/

SELECT 
    COUNT(DISTINCT OrderID) AS Total_Orders,
    SUM(Revenue) AS Total_Revenue,
    SUM(COGS) AS Total_Cost,
    SUM(Revenue - COGS) AS Total_Profit
FROM order_all;

-- =========================================================
-- 5️ Revenue by Product Category
-- =========================================================
/*
Identify best-performing categories
*/

SELECT 
    c.ProductCategory,
    SUM(a.Revenue) AS Revenue
FROM order_all a
JOIN products c ON a.ProductID = c.ProductID
GROUP BY c.ProductCategory
ORDER BY Revenue DESC;

-- =========================================================
-- 6️ Top 5 Products by Revenue
-- =========================================================
/*
Find high-performing products
*/

SELECT 
    c.ProductName,
    SUM(a.Revenue) AS Revenue
FROM order_all a
JOIN products c ON a.ProductID = c.ProductID
GROUP BY c.ProductName
ORDER BY Revenue DESC
LIMIT 5;

-- =========================================================
-- 7️ Region-wise Performance
-- =========================================================
/*
Compare regions (East, West, etc.)
*/

SELECT 
    b.Region,
    SUM(a.Revenue) AS Revenue,
    SUM(a.Revenue - a.COGS) AS Profit
FROM order_all a
JOIN customers b ON a.CustomerID = b.CustomerID
GROUP BY b.Region
ORDER BY Revenue DESC;

-- =========================================================
-- 8️ Monthly Sales Trend
-- =========================================================
/*
Track business growth over time
*/

SELECT 
    YEAR(OrderDate) AS Year,
    MONTH(OrderDate) AS Month,
    SUM(Revenue) AS Revenue
FROM order_all
GROUP BY Year, Month
ORDER BY Year, Month;

-- =========================================================
-- 9️ Customer Lifetime Value (CLV)
-- =========================================================
/*
Identify valuable customers
*/

SELECT 
    CustomerID,
    SUM(Revenue) AS Customer_Value,
    COUNT(OrderID) AS Total_Orders
FROM order_all
GROUP BY CustomerID
ORDER BY Customer_Value DESC;

-- =========================================================
-- 10.Profitability by Category
-- =========================================================
/*
Find which categories generate most profit
*/

SELECT 
    c.ProductCategory,
    SUM(a.Revenue - a.COGS) AS Profit
FROM order_all a
JOIN products c ON a.ProductID = c.ProductID
GROUP BY c.ProductCategory
ORDER BY Profit DESC;

-- =========================================================
-- 11️ Advanced: Ranking Products (Window Function)
-- =========================================================
/*
Rank products by revenue
*/

SELECT 
    ProductName,
    Revenue,
    RANK() OVER (ORDER BY Revenue DESC) AS Rank_Position
FROM (
    SELECT 
        c.ProductName,
        SUM(a.Revenue) AS Revenue
    FROM order_all a
    JOIN products c ON a.ProductID = c.ProductID
    GROUP BY c.ProductName
) t;

-- =========================================================
-- END OF SCRIPT
-- =========================================================