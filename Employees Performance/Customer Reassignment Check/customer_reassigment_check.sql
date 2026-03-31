-- Objective:
-- Detect if customers managed by top-performing sales reps in 2003
-- were reassigned to lower-performing reps (rank 11–15) in 2004

WITH revenue_2003 AS
(
    SELECT 
        e.employeeNumber,
        CONCAT(e.firstName, ' ', e.lastName) AS sales_rep,
        SUM(od.quantityOrdered * od.priceEach) AS revenue
    FROM employees e
    JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
    JOIN orders o ON c.customerNumber = o.customerNumber
    JOIN orderdetails od ON o.orderNumber = od.orderNumber
    WHERE o.status = 'Shipped'
      AND YEAR(o.orderDate) = 2003
    GROUP BY e.employeeNumber, sales_rep
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
        c.customerNumber,
        c.salesRepEmployeeNumber AS rep_2003
    FROM customers c
    WHERE c.salesRepEmployeeNumber IN (SELECT employeeNumber FROM top_reps_2003)
),

-- Customers handled in 2004 (same customers)
customers_2004 AS
(
    SELECT DISTINCT
        c.customerNumber,
        c.salesRepEmployeeNumber AS rep_2004
    FROM customers c
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