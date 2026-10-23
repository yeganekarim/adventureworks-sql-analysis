/*
    File:     01_basic_queries.sql
    Database: AdventureWorksDW2019
    Topic:    Basic SELECT, WHERE, LIKE, BETWEEN, CASE WHEN, date functions
*/

USE AdventureWorksDW2019;
GO

-- 1. Customers whose first name starts with 'J'
SELECT *
FROM DimCustomer
WHERE FirstName LIKE 'J%';

-- 2. Customers whose first name starts with 'O'
SELECT *
FROM DimCustomer
WHERE FirstName LIKE 'O%';

-- 3. Products that are red or blue
SELECT *
FROM DimProduct
WHERE Color = 'Red' OR Color = 'Blue';

-- 4. Female customers with yearly income between 50,000 and 70,000
SELECT *
FROM DimCustomer
WHERE YearlyIncome BETWEEN 50000 AND 70000
  AND Gender = 'F';

-- 5. Customers born between 1980 and 1985
SELECT *
FROM DimCustomer
WHERE YEAR(BirthDate) BETWEEN 1980 AND 1985;

-- 6. Three oldest customers (age calculated with DATEDIFF)
SELECT TOP 3
    FirstName AS Name,
    BirthDate,
    DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age
FROM DimCustomer
ORDER BY Age DESC;

-- 7. Classify customers as 'Young' (<= 40) or 'Old' (> 40) using CASE WHEN
SELECT
    FirstName AS Name,
    BirthDate,
    DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age,
    CASE
        WHEN DATEDIFF(YEAR, BirthDate, GETDATE()) <= 40 THEN 'Young'
        ELSE 'Old'
    END AS AgeGroup
FROM DimCustomer
ORDER BY Age DESC;
