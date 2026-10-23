/*
    File:     04_window_functions_cte.sql
    Database: AdventureWorksDW2019
    Topic:    Window functions (ROW_NUMBER, RANK, DENSE_RANK, SUM OVER, LAG) and CTEs
*/

USE AdventureWorksDW2019;
GO

-- 1. Rank countries by total internet sales (RANK)
SELECT
    dg.EnglishCountryRegionName AS Country,
    SUM(f.SalesAmount) AS TotalSales,
    RANK() OVER (ORDER BY SUM(f.SalesAmount) DESC) AS SalesRank
FROM FactInternetSales AS f
INNER JOIN DimCustomer AS dc
    ON f.CustomerKey = dc.CustomerKey
INNER JOIN DimGeography AS dg
    ON dc.GeographyKey = dg.GeographyKey
GROUP BY dg.EnglishCountryRegionName
ORDER BY SalesRank;

-- 2. Rank cities within their own country (RANK + PARTITION BY, using a CTE)
WITH CitySales AS (
    SELECT
        dg.EnglishCountryRegionName AS Country,
        dg.City,
        SUM(f.SalesAmount) AS TotalSales
    FROM FactInternetSales AS f
    INNER JOIN DimCustomer AS dc
        ON f.CustomerKey = dc.CustomerKey
    INNER JOIN DimGeography AS dg
        ON dc.GeographyKey = dg.GeographyKey
    GROUP BY dg.EnglishCountryRegionName, dg.City
)
SELECT
    Country,
    City,
    TotalSales,
    RANK() OVER (PARTITION BY Country ORDER BY TotalSales DESC) AS RankInCountry
FROM CitySales
ORDER BY Country, RankInCountry;

-- 3. Top 3 customers in each country (ROW_NUMBER + PARTITION BY, using a CTE)
WITH CustomerSales AS (
    SELECT
        dg.EnglishCountryRegionName AS Country,
        dc.CustomerKey,
        CONCAT(dc.FirstName, ' ', dc.LastName) AS CustomerName,
        SUM(f.SalesAmount) AS TotalSales
    FROM FactInternetSales AS f
    INNER JOIN DimCustomer AS dc
        ON f.CustomerKey = dc.CustomerKey
    INNER JOIN DimGeography AS dg
        ON dc.GeographyKey = dg.GeographyKey
    GROUP BY dg.EnglishCountryRegionName, dc.CustomerKey, dc.FirstName, dc.LastName
),
Ranked AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Country ORDER BY TotalSales DESC) AS RowNum
    FROM CustomerSales
)
SELECT Country, CustomerName, TotalSales, RowNum
FROM Ranked
WHERE RowNum <= 3
ORDER BY Country, RowNum;

-- 4. ROW_NUMBER vs RANK vs DENSE_RANK on product subcategories by units sold
--    (shows how each function treats ties)
SELECT
    ps.EnglishProductSubcategoryName AS Subcategory,
    SUM(f.OrderQuantity) AS UnitsSold,
    ROW_NUMBER() OVER (ORDER BY SUM(f.OrderQuantity) DESC) AS RowNum,
    RANK()       OVER (ORDER BY SUM(f.OrderQuantity) DESC) AS RankNum,
    DENSE_RANK() OVER (ORDER BY SUM(f.OrderQuantity) DESC) AS DenseRankNum
FROM FactInternetSales AS f
INNER JOIN DimProduct AS p
    ON f.ProductKey = p.ProductKey
INNER JOIN DimProductSubcategory AS ps
    ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
GROUP BY ps.EnglishProductSubcategoryName
ORDER BY UnitsSold DESC;

-- 5. Monthly sales with running total inside each year (SUM OVER)
WITH MonthlySales AS (
    SELECT
        d.CalendarYear,
        d.MonthNumberOfYear AS MonthNo,
        SUM(f.SalesAmount) AS MonthlySales
    FROM FactInternetSales AS f
    INNER JOIN DimDate AS d
        ON f.OrderDateKey = d.DateKey
    GROUP BY d.CalendarYear, d.MonthNumberOfYear
)
SELECT
    CalendarYear,
    MonthNo,
    MonthlySales,
    SUM(MonthlySales) OVER (PARTITION BY CalendarYear ORDER BY MonthNo) AS RunningTotal
FROM MonthlySales
ORDER BY CalendarYear, MonthNo;

-- 6. Year-over-year sales growth (LAG)
WITH YearlySales AS (
    SELECT
        d.CalendarYear,
        SUM(f.SalesAmount) AS TotalSales
    FROM FactInternetSales AS f
    INNER JOIN DimDate AS d
        ON f.OrderDateKey = d.DateKey
    GROUP BY d.CalendarYear
)
SELECT
    CalendarYear,
    TotalSales,
    LAG(TotalSales) OVER (ORDER BY CalendarYear) AS PreviousYearSales,
    CAST(
        (TotalSales - LAG(TotalSales) OVER (ORDER BY CalendarYear)) * 100.0
        / NULLIF(LAG(TotalSales) OVER (ORDER BY CalendarYear), 0)
        AS DECIMAL(10, 2)
    ) AS YoYGrowthPercent
FROM YearlySales
ORDER BY CalendarYear;
