

CREATE DATABASE CustomerAnalytics;
GO

USE CustomerAnalytics;


--Calculate Year-over-Year (YoY) sales growth  and compare them with the previous year to measure sales growth.

WITH YearlySales AS (
SELECT
DATEPART(YEAR, transaction_date) AS SalesYear,
SUM(amount) AS TotalSales
FROM Transactions
GROUP BY DATEPART(YEAR, transaction_date)
)

SELECT SalesYear,TotalSales,
LAG(TotalSales) OVER(ORDER BY SalesYear) AS PreviousYearSales,
TotalSales - LAG(TotalSales) OVER(ORDER BY SalesYear) AS Growth
FROM YearlySales;

-----------------------------------------------------------------------------

--Customers who have not made any purchase in the last 90 days

WITH LastPurchase AS (
SELECT
customer_id,
MAX(transaction_date) AS LastPurchase
FROM Transactions
GROUP BY customer_id
)

SELECT
customer_id,
DATEDIFF(day, LastPurchase, GETDATE()) AS DaysInactive
FROM LastPurchase
WHERE DATEDIFF(day, LastPurchase, GETDATE()) > 90
--------------------------------------------------------------------------------------------------------