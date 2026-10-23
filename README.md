# AdventureWorks SQL Analysis

SQL queries on the **AdventureWorksDW2019** data warehouse (SQL Server), covering customer and sales analysis.

## Skills demonstrated
- Filtering with `WHERE`, `LIKE`, `BETWEEN`, `AND/OR`
- Aggregations: `COUNT`, `SUM`, `AVG`
- `GROUP BY` and `HAVING`
- `INNER JOIN` across fact and dimension tables
- `CASE WHEN` and date functions (`YEAR`, `DATEDIFF`)
- Window functions: `ROW_NUMBER`, `RANK`, `DENSE_RANK`, `LAG`, `SUM() OVER`
- Common Table Expressions (CTE)

## Files
| File | Content |
|---|---|
| `01_basic_queries.sql` | Filtering, pattern matching, date functions, `CASE WHEN` |
| `02_aggregations_group_by.sql` | Averages, counts, `GROUP BY`, `HAVING` |
| `03_joins.sql` | Joins between `DimCustomer`, `DimGeography`, `FactInternetSales` |
| `04_window_functions_cte.sql` | `ROW_NUMBER`, `RANK`, `DENSE_RANK`, `LAG`, running totals, CTEs |

## Example questions answered
- Who are the top 5 customers by total internet sales?
- Who are the top 3 customers in each country?
- How are cities ranked within their own country?
- How many customers are there in each city and in each country by gender?
- What is the average yearly income by education level?
- What is the year-over-year sales growth?

## How to run
1. Restore the AdventureWorksDW2019 sample database in SQL Server.
2. Open any `.sql` file in SQL Server Management Studio.
3. Run the queries.

## Related work
Power BI dashboards built on the same dataset: https://www.linkedin.com/in/yegane-karim-43288a337
