
CREATE DATABASE CustomerAnalytics;
GO

USE CustomerAnalytics;

/*

Customer CustomerAnalytics is the process of dividing customers into groups
based on their behavior, preferences
*/

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(50),
    signup_date DATE
);

CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY,
    customer_id INT,
    transaction_date DATE,
    amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);


INSERT INTO Customers VALUES
(1,'Ravi','Hyderabad','2022-01-10'),
(2,'Sita','Vizag','2022-02-15'),
(3,'Rahul','Chennai','2023-03-20'),
(4,'Anjali','Bangalore','2023-04-18'),
(5,'Kiran','Hyderabad','2023-05-25');


SELECT  * FROM Customers

INSERT INTO Transactions VALUES
(101,1,'2024-01-05',5000),
(102,1,'2024-02-10',2000),
(103,2,'2024-02-15',3000),
(104,3,'2024-03-10',7000),
(105,4,'2024-04-05',1500),
(106,5,'2024-04-10',2500);

SELECT * FROM Transactions

WITH RFM AS (
SELECT
customer_id,
MAX(transaction_date) AS LastPurchase,
COUNT(transaction_id) AS Frequency,
SUM(amount) AS Monetary
FROM Transactions
GROUP BY customer_id
)

SELECT
customer_id,
DATEDIFF(day, LastPurchase, GETDATE()) AS Recency,
Frequency,
Monetary
FROM RFM;

--------------------------------------------------------------------------------
--find the total amount spent by each customer?

SELECT c.customer_id,c.customer_name, SUM(t.amount) AS Total_Spent
FROM Customers c
JOIN Transactions t
ON c.customer_id = t.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY Total_Spent DESC;
-------------------------------------------------------------------------------------

--Display the number of transactions made by each customer?

SELECT customer_id,
COUNT(transaction_id) AS Total_Transactions
FROM Transactions
GROUP BY customer_id;
------------------------------------------------------------------------------------------

--Top 3 Highest Spending Customers

SELECT TOP 3 c.customer_id, c.customer_name, SUM(t.amount) AS Total_Spent
FROM Customers c
JOIN Transactions t
ON c.customer_id = t.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY Total_Spent DESC;

-------------------------------------------------------------------------------------------
--find the top 3 customers who spent the highest amount?

SELECT c.customer_id, c.customer_name
FROM Customers c
LEFT JOIN Transactions t
ON c.customer_id = t.customer_id
WHERE t.transaction_id IS NULL;

-------------------------------------------------------------------------------------------
--Average Transaction Amount 

SELECT 
AVG(amount) AS Avg_Transaction_Amount
FROM Transactions;
------------------------------------------------------------------------------------------

--find the latest transaction date for each customer.

SELECT city, COUNT(customer_id) AS Total_Customers
FROM Customers
GROUP BY city;
-------------------------------------------------------------------------------------------

--Monthly Sales Analysis
SELECT MONTH(transaction_date) AS Month, SUM(amount) AS Total_Sales
FROM Transactions
GROUP BY MONTH(transaction_date)
ORDER BY Month
----------------------------------------------------------------------------------------------

--Segment customers into High Value, Medium Value, and Low Value customers based on their total spending amount.

SELECT customer_id, SUM(amount) AS Total_Spent,
CASE
WHEN SUM(amount) >= 6000 THEN 'High Value Customer'
WHEN SUM(amount) >= 3000 THEN 'Medium Value Customer'
ELSE 'Low Value Customer'
END AS Customer_Segment
FROM Transactions
GROUP BY customer_id

------------------------------------------------------------------------------------------

--Identify customers who have not made any purchases in the last 60 days

SELECT customer_id, MAX(transaction_date) AS Last_Purchase,
DATEDIFF(day, MAX(transaction_date), GETDATE()) AS Days_Inactive
FROM Transactions
GROUP BY customer_id
HAVING DATEDIFF(day, MAX(transaction_date), GETDATE()) > 60
----------------------------------------------------------------------------------------