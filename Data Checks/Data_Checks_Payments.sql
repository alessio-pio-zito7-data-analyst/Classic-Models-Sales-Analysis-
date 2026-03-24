-- Check for NULL values across key Payments fields
-- No NULL were found
SELECT
    SUM(CASE WHEN customerNumber IS NULL THEN 1 ELSE 0 END) AS null_CustNumber,
    SUM(CASE WHEN checkNumber IS NULL THEN 1 ELSE 0 END) AS null_check,
    SUM(CASE WHEN paymentDate IS NULL THEN 1 ELSE 0 END) AS null_payment,
    SUM(CASE WHEN amount IS NULL THEN 1 ELSE 0 END) AS null_amount
FROM payments;

-- Data Quality Check: Duplicate Payments
-- Ensure each (customerNumber, checkNumber) combination is unique
SELECT customerNumber, checkNumber, COUNT(*) as duplicates
	FROM payments
	GROUP BY customerNumber, checkNumber
	HAVING COUNT(*) > 1;
    
-- Data Quality Check: Payment Amount Validity
-- Identify invalid or non-positive payment amounts
SELECT amount
FROM payments
WHERE amount <= 0; 
    
-- Data Quality Check: Customer Referential Integrity
-- Verify that each payment is linked to a valid customer
SELECT t1.checkNumber, t2.customerNumber, t2.customerName, t3.orderNumber
FROM payments t1
LEFT JOIN customers t2
ON t1.customerNumber = t2.customerNumber
LEFT JOIN orders t3
ON t3.customerNumber = t1.customerNumber
WHERE t2.customerNumber IS NULL;
