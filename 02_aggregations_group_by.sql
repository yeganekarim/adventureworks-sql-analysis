/*
    File:     02_aggregations_group_by.sql
    Database: AdventureWorksDW2019
    Topic:    Aggregate functions, GROUP BY, HAVING
*/

USE AdventureWorksDW2019;
GO

-- 1. Average yearly income by gender
SELECT
    Gender,
    AVG(YearlyIncome) AS AverageIncome
FROM DimCustomer
GROUP BY Gender;

-- 2. Average yearly income by education level
SELECT
    EnglishEducation,
    AVG(YearlyIncome) AS AverageIncome
FROM DimCustomer
GROUP BY EnglishEducation;

-- 3. Number of employees hired in each year
SELECT
    YEAR(StartDate) AS HireYear,
    COUNT(EmployeeKey) AS EmployeeCount
FROM DimEmployee
GROUP BY YEAR(StartDate)
ORDER BY HireYear;

-- 4. Years in which more than 40 employees were hired (HAVING)
SELECT
    YEAR(StartDate) AS HireYear,
    COUNT(EmployeeKey) AS EmployeeCount
FROM DimEmployee
GROUP BY YEAR(StartDate)
HAVING COUNT(EmployeeKey) > 40
ORDER BY HireYear;

-- 5. Number of distinct cities in each country
SELECT
    EnglishCountryRegionName AS Country,
    COUNT(DISTINCT City) AS CityCount
FROM DimGeography
GROUP BY EnglishCountryRegionName
ORDER BY CityCount DESC;
