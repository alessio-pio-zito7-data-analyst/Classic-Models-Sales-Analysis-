-- This query identifies Sales Representatives who do not appear in the performance analysis.
-- It is important to note that the project analyzes the database as if we were at the beginning of 2005,
-- evaluating business performance over the previous two years (2003–2004).

-- Since the dataset spans from early 2003 to mid-2005, some employees (e.g. newly hired Sales Reps in 2005)
-- may not appear in the analysis simply because they did not generate any revenue in the selected time period.

-- NOTE:
-- This query was adapted from previous analyses and partially reused to quickly identify
-- the missing Sales Representatives. Some components were simplified and modified
-- specifically for this purpose.
-- It is included for completeness, but it would not have been written in this form
-- without building upon the logic and structure developed in the earlier queries.

WITH missing_employees AS
(
	SELECT 
        t1.employeeNumber, 
        t1.firstName, 
        t1.lastName, 
        t1.jobTitle, 
        t5.officeCode, 
        t5.city, 
        t5.country,

	    YEAR(t3.orderdate) as year,

        -- Total revenue generated per employee per year
	    SUM(t4.quantityOrdered * t4.priceEach) AS employee_revenue,
        
        -- Number of distinct orders handled
	    COUNT(DISTINCT t3.orderNumber) AS total_orders
        
	FROM employees t1

        -- Link employees to their customers
		INNER JOIN customers t2
			ON t1.employeeNumber = t2.salesRepEmployeeNumber
            
        -- Join office information
		INNER JOIN offices t5 
			ON t1.officeCode = t5.officeCode
            
        -- Join customer orders
		INNER JOIN orders t3
			ON t2.customerNumber = t3.customerNumber
            
        -- Join order details to compute revenue
		INNER JOIN orderdetails t4 
			ON t3.orderNumber = t4.orderNumber

	WHERE 
        -- Filter analysis period (2003–2004)
        YEAR(t3.orderdate) >= '2003-01-01' AND
        YEAR(t3.orderDate) < '2005-01-01'AND
		t3.status = 'Shipped'

	GROUP BY 
        t1.employeeNumber, 
        t1.firstName, 
        t1.lastName, 
        t1.jobTitle, 
        t5.officeCode, 
        t5.city, 
        t5.country, 
        year 
), 

previous_revenue_cte AS
(
	SELECT
        employeeNumber, 
        firstName, 
        lastName, 
        city, 
        country, 
        total_orders,
        year, 
        employee_revenue,

        -- Window function to retrieve previous year revenue per employee
		LAG(employee_revenue) 
            OVER (PARTITION BY employeeNumber ORDER BY year) 
            AS previous_revenue
            
	FROM top_employees 
    
	ORDER BY employeeNumber, year
), 
		
YoY_cte AS 
(
	SELECT *,
    
        -- Year-over-Year growth calculation
        ROUND(
            (employee_revenue - previous_revenue) / previous_revenue * 100, 
        2) AS YoY_growth
        
	FROM previous_revenue_cte
)

-- Identify Sales Reps not present in the analyzed dataset
SELECT 
    e.employeeNumber, 
    e.firstName, 
    e.lastName, 
    e.officeCode

FROM employees e

WHERE 
    e.jobTitle = 'Sales Rep'

    -- Exclude employees that appear in the revenue analysis
    AND e.employeeNumber NOT IN (
        SELECT DISTINCT employeeNumber 
        FROM missing_employees
    );