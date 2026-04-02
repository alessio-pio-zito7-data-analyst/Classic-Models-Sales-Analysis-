-- Objective:
-- Detect if customers managed by top-performing sales reps in 2003
-- were reassigned to lower-performing reps (rank 11–15) in 2004

WITH revenue_2003 AS
(
    SELECT 
        t1.employeeNumber,
        CONCAT(t1.firstName, ' ', t1.lastName) AS sales_rep,
        SUM(t3.quantityOrdered * t3.priceEach) AS revenue
    FROM employees t1
    JOIN customers t4 ON t1.employeeNumber = t4.salesRepEmployeeNumber
    JOIN orders t2 ON t4.customerNumber = t2.customerNumber
    JOIN orderdetails t3 ON t2.orderNumber = t3.orderNumber
    WHERE t2.status = 'Shipped'
      AND YEAR(t2.orderDate) = 2003
    GROUP BY t1.employeeNumber, sales_rep
),

ranking_2003 AS
(
    SELECT *,
        ROW_NUMBER() OVER (ORDER BY revenue DESC) AS rank_2003
    FROM revenue_2003
),

top_reps_2003 AS
(
    SELECT employeeNumber
    FROM ranking_2003
    WHERE rank_2003 <= 5
),

bottom_reps_2003 AS
(
    SELECT employeeNumber
    FROM ranking_2003
    WHERE rank_2003 BETWEEN 11 AND 15
),

-- Customers handled by top reps in 2003
customers_top_2003 AS
(
    SELECT DISTINCT
        t4.customerNumber,
        t4.salesRepEmployeeNumber AS rep_2003
    FROM customers t4
    WHERE t4.salesRepEmployeeNumber IN (SELECT employeeNumber FROM top_reps_2003)
),

-- Customers handled in 2004 (same customers)
customers_2004 AS
(
    SELECT DISTINCT
        t4.customerNumber,
        t4.salesRepEmployeeNumber AS rep_2004
    FROM customers t4
)

-- Final check: did customers move from top reps → bottom reps?
SELECT 
    ct.customerNumber,
    ct.rep_2003 AS previous_rep_2003,
    c4.rep_2004 AS new_rep_2004

FROM customers_top_2003 ct

JOIN customers_2004 c4
    ON ct.customerNumber = c4.customerNumber

WHERE 
    c4.rep_2004 IN (SELECT employeeNumber FROM bottom_reps_2003)
    AND ct.rep_2003 <> c4.rep_2004;