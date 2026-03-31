-- Check for NULL values across key OrderDetails fields
-- No NULL were found 
SELECT
    SUM(CASE WHEN orderNumber IS NULL THEN 1 ELSE 0 END) AS null_orderNumber,
    SUM(CASE WHEN productCode IS NULL THEN 1 ELSE 0 END) AS null_productCode,
    SUM(CASE WHEN quantityOrdered IS NULL THEN 1 ELSE 0 END) AS null_quantity,
    SUM(CASE WHEN priceEach IS NULL THEN 1 ELSE 0 END) AS null_price,
    SUM(CASE WHEN orderLineNumber IS NULL THEN 1 ELSE 0 END) AS null_line
FROM orderdetails;

-- Identify invalid or suspicious values (non-positive quantities or prices)
SELECT *
FROM orderdetails
WHERE quantityOrdered <= 0
   OR priceEach <= 0;
   
-- Check for duplicate combinations of orderNumber and productCode
SELECT orderNumber, productCode, 
COUNT(*) AS duplicate_count
	FROM orderdetails
	GROUP BY orderNumber, productCode
	HAVING COUNT(*) > 1;

-- Verify that each orderNumber exists in the orders table
SELECT * 
FROM orderdetails t1
LEFT JOIN orders t2
	ON t1.orderNumber = t2.orderNumber
WHERE t2.orderNumber IS NULL;

-- Verify that each productCode exists in the products table
SELECT t1.productCode, t2.productName
FROM orderdetails t1
LEFT JOIN products t2
ON t1.productCode = t2.productCode
WHERE t2.productCode IS NULL;

/*Orderdetails table passed all critical data quality checks.
No null values, duplicates, or referential integrity issues were found.*/
