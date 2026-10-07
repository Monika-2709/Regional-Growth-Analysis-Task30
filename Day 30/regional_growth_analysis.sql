-- Regional Growth Analysis – Task 30
-- Dataset: Superstore-style regional sales data
-- Assumed table name: superstore_sales

-- 1. Annual sales by region
SELECT
    Region,
    EXTRACT(YEAR FROM Order_Date) AS Sales_Year,
    SUM(Sales) AS Total_Sales
FROM superstore_sales
GROUP BY Region, EXTRACT(YEAR FROM Order_Date)
ORDER BY Region, Sales_Year;

-- 2. Period-over-period growth by region
-- MySQL 8+ version using LAG()
WITH yearly_sales AS (
    SELECT
        Region,
        YEAR(Order_Date) AS Sales_Year,
        SUM(Sales) AS Total_Sales
    FROM superstore_sales
    GROUP BY Region, YEAR(Order_Date)
),
growth AS (
    SELECT
        Region,
        Sales_Year,
        Total_Sales,
        LAG(Total_Sales) OVER (
            PARTITION BY Region ORDER BY Sales_Year
        ) AS Previous_Year_Sales
    FROM yearly_sales
)
SELECT
    Region,
    Sales_Year,
    ROUND(Total_Sales, 2) AS Total_Sales,
    ROUND(Previous_Year_Sales, 2) AS Previous_Year_Sales,
    ROUND(
        (Total_Sales - Previous_Year_Sales) / NULLIF(Previous_Year_Sales, 0) * 100,
        2
    ) AS Growth_Percent
FROM growth
ORDER BY Region, Sales_Year;

-- 3. Compare 2023 vs 2024
WITH yearly_sales AS (
    SELECT
        Region,
        YEAR(Order_Date) AS Sales_Year,
        SUM(Sales) AS Total_Sales
    FROM superstore_sales
    WHERE YEAR(Order_Date) IN (2023, 2024)
    GROUP BY Region, YEAR(Order_Date)
),
wide AS (
    SELECT
        Region,
        MAX(CASE WHEN Sales_Year = 2023 THEN Total_Sales END) AS Sales_2023,
        MAX(CASE WHEN Sales_Year = 2024 THEN Total_Sales END) AS Sales_2024
    FROM yearly_sales
    GROUP BY Region
)
SELECT
    Region,
    ROUND(Sales_2023, 2) AS Sales_2023,
    ROUND(Sales_2024, 2) AS Sales_2024,
    ROUND((Sales_2024 - Sales_2023) / NULLIF(Sales_2023, 0) * 100, 2) AS Growth_2023_2024
FROM wide
ORDER BY Growth_2023_2024 DESC;

-- 4. Rank regions by latest-year growth
WITH yearly_sales AS (
    SELECT
        Region,
        YEAR(Order_Date) AS Sales_Year,
        SUM(Sales) AS Total_Sales
    FROM superstore_sales
    GROUP BY Region, YEAR(Order_Date)
),
growth AS (
    SELECT
        Region,
        Sales_Year,
        Total_Sales,
        LAG(Total_Sales) OVER (PARTITION BY Region ORDER BY Sales_Year) AS Previous_Sales
    FROM yearly_sales
)
SELECT
    Region,
    ROUND((Total_Sales - Previous_Sales) / NULLIF(Previous_Sales, 0) * 100, 2) AS Growth_Percent,
    RANK() OVER (
        ORDER BY (Total_Sales - Previous_Sales) / NULLIF(Previous_Sales, 0) DESC
    ) AS Growth_Rank
FROM growth
WHERE Sales_Year = 2024;

-- 5. Interview concept:
-- Growth rate can mislead when the previous-period base is very small.
