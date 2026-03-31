-- This analysis evaluates year-over-year growth at product line level (2003 vs 2004)
-- to understand which categories are driving overall business performance

WITH comparison_cte AS
(
SELECT 
    t3.productLine,
    YEAR(t1.orderDate) as year,
    
    -- Aggregate total quantity sold per product line per year
    SUM(t2.quantityOrdered) AS sold_this_year 
    
FROM orders t1

    -- Join orders with order details
	INNER JOIN orderdetails t2
		ON t1.orderNumber = t2.orderNumber
        
    -- Join with products to access productLine
	INNER JOIN products t3
        ON t3.productCode = t2.productCode
        
WHERE 
    t1.orderDate >= '2003-01-01' 
    AND t1.orderDate < '2005-01-01' 
    
    AND t1.status = 'Shipped'

GROUP BY 
    YEAR(t1.orderDate), 
    t3.productLine
), 

lag_cte AS
(
    SELECT 
        productLine,
        year,
        sold_this_year,

        -- Retrieve previous year's sales for each product line
        LAG(sold_this_year) 
            OVER (PARTITION BY productLine ORDER BY year) 
            AS sold_previousely
            
    FROM comparison_cte
), 

YoY_cte AS 
(
    SELECT *,
    
        -- Year-over-Year growth calculation
        ROUND(
            (sold_this_year - sold_previousely) / sold_previousely * 100, 
        2) AS YoY_growth
        
    FROM lag_cte
)
    
SELECT *
FROM YoY_cte

ORDER BY productLine, year;