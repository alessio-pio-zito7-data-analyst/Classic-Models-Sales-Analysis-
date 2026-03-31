-- Check for NULL values across key Orders fields
-- 14 NULLs found in shippedDate
SELECT
    SUM(CASE WHEN orderNumber IS NULL THEN 1 ELSE 0 END) AS null_orderNumber,
    SUM(CASE WHEN orderDate IS NULL THEN 1 ELSE 0 END) AS null_orderdate,
    SUM(CASE WHEN requiredDate IS NULL THEN 1 ELSE 0 END) AS null_reqdate,
    SUM(CASE WHEN shippedDate IS NULL THEN 1 ELSE 0 END) AS null_shipdate,
    SUM(CASE WHEN status IS NULL THEN 1 ELSE 0 END) AS null_status,
    SUM(CASE WHEN customerNumber IS NULL THEN 1 ELSE 0 END) AS null_cNumber
FROM orders;

-- Data Validation: shippedDate NULL analysis
-- NULL shippedDate values correspond to orders not yet shipped (e.g., Cancelled, On Hold, In Process)
-- These cases are expected based on order lifecycle status
SELECT *
FROM orders
WHERE shippedDate IS NULL
OR status = 'Cancelled';

-- Data Quality Check: Duplicate Orders
-- Ensure orderNumber is unique
SELECT orderNumber,
COUNT(*) as duplicate_count
	FROM orders
	GROUP BY orderNumber
	HAVING COUNT(*) > 1;

-- Data Quality Check: Customer Referential Integrity
-- Verify that each customerNumber exists in the customers table
SELECT t1.orderNumber, t1.customerNumber
FROM orders t1
LEFT JOIN customers t2
ON t1.customerNumber = t2.customerNumber
WHERE t2.customerNumber IS NULL;
