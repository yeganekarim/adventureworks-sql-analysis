/*
    File:     03_joins.sql
    Database: AdventureWorksDW2019
    Topic:    INNER JOIN across fact and dimension tables, with aggregation
*/

USE AdventureWorksDW2019;
GO

-- 1. Number of customers in each city, sorted from highest to lowest
SELECT
    dg.City,
    COUNT(dc.CustomerKey) AS CustomerCount
FROM DimGeography AS dg
INNER JOIN DimCustomer AS dc
    ON dg.GeographyKey = dc.GeographyKey
GROUP BY dg.City
ORDER BY CustomerCount DESC;

-- 2. Number of customers by country and gender
SELECT
    dg.EnglishCountryRegionName AS Country,
    dc.Gender,
    COUNT(dc.CustomerKey) AS CustomerCount
FROM DimCustomer AS dc
INNER JOIN DimGeography AS dg
    ON dg.GeographyKey = dc.GeographyKey
GROUP BY dg.EnglishCountryRegionName, dc.Gender
ORDER BY Country, dc.Gender;

-- 3. Top 5 customers by total internet sales
--    (grouped by CustomerKey so customers with the same first name are not merged)
SELECT TOP 5
    dc.CustomerKey,
    CONCAT(dc.FirstName, ' ', dc.LastName) AS CustomerName,
    SUM(f.SalesAmount) AS TotalSales
FROM FactInternetSales AS f
INNER JOIN DimCustomer AS dc
    ON f.CustomerKey = dc.CustomerKey
GROUP BY dc.CustomerKey, dc.FirstName, dc.LastName
ORDER BY TotalSales DESC;
