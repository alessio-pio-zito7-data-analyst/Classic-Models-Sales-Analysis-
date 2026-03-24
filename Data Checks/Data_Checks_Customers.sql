-- Count total number of unique customers 
SELECT count(DISTINCT customerName) as total_customers_count 
FROM customers;

-- Check for duplicate customerNumber values
SELECT customerNumber, COUNT(*)
FROM customers
GROUP BY customerNumber
HAVING COUNT(*) > 1;

-- Check for NULL values across key customer fields
-- Observation: 22 NULL values found in salesRepEmployeeNumber
SELECT
    SUM(CASE WHEN customerNumber IS NULL THEN 1 ELSE 0 END) AS null_custNumber,
    SUM(CASE WHEN customerName IS NULL THEN 1 ELSE 0 END) AS null_CName,
    SUM(CASE WHEN contactFirstName IS NULL THEN 1 ELSE 0 END) AS null_Fname,
    SUM(CASE WHEN contactLastName IS NULL THEN 1 ELSE 0 END) AS null_Lname,
    SUM(CASE WHEN salesRepEmployeeNumber IS NULL THEN 1 ELSE 0 END) AS null_rep,
    SUM(CASE WHEN creditLimit IS NULL THEN 1 ELSE 0 END) AS null_CL
FROM customers;

-- Count customers with zero credit limit
SELECT
    SUM(CASE WHEN creditLimit = 0 THEN 1 ELSE 0 END) AS null_CL
FROM customers;

-- Check for NULL values in SalesRep and CreditLimit = 0
SELECT customerName, salesRepEmployeeNumber, creditLimit FROM customers
WHERE salesRepEmployeeNumber IS NULL
OR creditLimit = 0; 

-- Using ROW_NUMBER to varify if the count is equal to 24
SELECT 
	ROW_NUMBER() OVER (ORDER BY salesRepEmployeeNumber) AS row_count,
	salesRepEmployeeNumber,
    creditLimit
FROM customers
WHERE salesRepEmployeeNumber IS NULL
OR creditLimit = 0; 

-- next step is to check if these 22 Customers have placed at least an order
-- customers without assigned salesRep also have zero orders,
-- suggesting they may be inactive or newly created accounts 
WITH customers_orders_check AS
(
	SELECT t1.customerNumber, t1.CustomerName, t1.salesRepEmployeeNumber, COUNT(t2.orderNumber) as total_Orders
	from customers t1
	LEFT JOIN orders t2
	ON t1.customerNumber = t2.customerNumber
	WHERE t1.salesRepEmployeeNumber IS NULL
    OR creditLimit = 0
	GROUP BY t1.customerNumber, t1.customerName, t1.salesRepEmployeeNumber
)

SELECT 
ROW_NUMBER() OVER (ORDER BY customerNumber) as row_count,
customerNumber,
CustomerName,
salesRepEmployeeNumber,
total_Orders
FROM customers_orders_check;

-- checking if every active customer has an assigned salesRep.
SELECT 
	ROW_NUMBER() OVER (ORDER BY customerNumber) as row_count,
    customerNumber,
    salesRepEmployeeNumber,
    creditLimit
FROM customers
WHERE salesRepEmployeeNumber IS NOT NULL;

-- Validate referential integrity between customers and employees tables
-- Identify customers assigned to non-existing sales representatives
SELECT t1.customerNumber, t1.salesRepEmployeeNumber
FROM customers t1
LEFT JOIN employees t2
    ON t1.salesRepEmployeeNumber = t2.employeeNumber
WHERE t1.salesRepEmployeeNumber IS NOT NULL
  AND t2.employeeNumber IS NULL;
