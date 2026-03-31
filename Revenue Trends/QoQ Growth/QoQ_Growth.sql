-- Calculate quarterly revenue and compare each quarter year-over-year (QoQ YoY comparison)
-- to evaluate performance trends across years. The analysis indicates stronger growth in 2004,
-- suggesting improved business performance compared to 2003.

WITH qoq_revenue AS
(
    SELECT 
        YEAR(orderDate) AS year,
        QUARTER(orderDate) AS quarter,
        
        -- Aggregate total revenue per year and quarter
        SUM(quantityOrdered * PriceEach) as revenue
        
	FROM orderdetails t1
    
        -- Join to access order date and filter by order status
		JOIN orders t2
			ON t1.orderNumber = t2.orderNumber 
            
	WHERE 
        -- Consider only completed (shipped) orders for accurate revenue calculation
        t2.status = 'Shipped' 
        AND YEAR(t2.orderDate) IN (2003,2004)
        
	GROUP BY 
        YEAR(orderDate), 
        QUARTER(orderDate) 
)

SELECT 
    year, 
    quarter, 
    revenue,

    -- Window function:
    -- LAG retrieves revenue from the same quarter in the previous year
    -- PARTITION BY quarter ensures comparison across same quarters (e.g., Q1 vs Q1)
    -- ORDER BY year defines chronological sequence
    LAG(revenue) OVER (PARTITION BY quarter ORDER BY year) AS previous_year_revenue,

    -- Year-over-Year growth calculation at quarterly level
    -- The LAG function is repeated to directly compute growth vs previous year
    ROUND(
        (revenue - LAG(revenue) OVER (PARTITION BY quarter ORDER BY year)) 
        / LAG(revenue) OVER (PARTITION BY quarter ORDER BY year) * 100, 
        2
    ) AS yoy_growth

FROM qoq_revenue

-- Ordering by quarter first allows easier comparison of the same quarter across years
ORDER BY quarter, year;