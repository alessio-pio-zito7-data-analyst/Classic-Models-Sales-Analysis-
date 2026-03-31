-- Calculate yearly revenue and year-over-year (YoY) growth to evaluate overall business performance 
-- and measure how revenue evolves compared to the previous year.
-- The analysis highlights a significant increase in 2004, with approximately +33.43% growth vs 2003.

WITH yearly_revenue_growth AS
(
    SELECT 
        YEAR(orderDate) AS year,
        
        -- Aggregate total revenue per year
        SUM(quantityOrdered * PriceEach) as revenue
        
	FROM orderdetails t1
    
        -- Join to access order date and filter by order status
		JOIN orders t2
			ON t1.orderNumber = t2.orderNumber 
            
	WHERE 
        -- Include only shipped orders to reflect actual revenue
        t2.status = 'Shipped' 
        AND YEAR(t2.orderDate) IN (2003,2004)
        
	GROUP BY 
        YEAR(orderDate) 
)

SELECT 
    year, 
    revenue,

    -- Window function:
    -- LAG retrieves revenue from the previous year
    -- ORDER BY year ensures correct chronological comparison
	LAG(revenue) OVER (ORDER BY year) as previous_year_revenue,
    
    -- Year-over-Year growth calculation
    -- LAG is reused to compare current revenue with previous year
    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY year)) 
        / LAG(revenue) OVER (ORDER BY year) * 100, 
        2
    ) as YoY_growth

FROM yearly_revenue_growth

-- Chronological ordering for trend analysis
ORDER BY year;