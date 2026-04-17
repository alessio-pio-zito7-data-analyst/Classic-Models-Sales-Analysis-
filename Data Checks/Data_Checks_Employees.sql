-- Count total number of unique employees 
SELECT COUNT(DISTINCT employeeNumber) FROM employees;

-- Check for duplicate employeeNumber values
SELECT employeeNumber, COUNT(*)
FROM employees
GROUP BY employeeNumber
HAVING COUNT(*) > 1;

-- Count total number of Sales Representative
SELECT COUNT(*) total_sales_rep
FROM employees
WHERE jobTitle = 'Sales Rep';

-- Data Quality Check: reportsTo field
-- Only one NULL value found, corresponding to the President role, who does not report to any manager
-- This is expected and does not indicate a data quality issue
SELECT
    SUM(CASE WHEN reportsTo IS NULL THEN 1 ELSE 0 END) AS null_rep_to
FROM employees;

-- Data Quality Check: Employee–Office Referential Integrity
-- Validate that each employee is assigned to an existing office
-- Expected result: 0 rows (no missing office references)
SELECT t1.officeCode, t2.city, t1.firstName, t1.lastName
FROM employees t1
LEFT JOIN offices t2
ON t1.officeCode = t2.officeCode
WHERE t1.officeCode IS NOT NULL
  AND t2.officeCode IS NULL;

-- Data Quality Check: Reporting Hierarchy Integrity
-- Validate that each non-NULL reportsTo value references an existing employee
-- Expected result: 0 rows (all reporting relationships are valid)
SELECT t1.employeeNumber, t1.reportsTo
FROM employees t1
LEFT JOIN employees t2
    ON t1.reportsTo = t2.employeeNumber
WHERE t1.reportsTo IS NOT NULL
  AND t2.employeeNumber IS NULL;
