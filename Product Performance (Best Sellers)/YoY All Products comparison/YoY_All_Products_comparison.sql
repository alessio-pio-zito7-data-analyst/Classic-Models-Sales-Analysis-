-- This analysis evaluates year-over-year product-level growth between 2003 and 2004,
-- with the objective of assessing whether sales performance improved across the entire product portfolio.
-- Overall, most products show positive growth compared to the previous year,
-- with only a limited number experiencing declines.
-- This suggests strong overall sales performance and indicates that the majority of products
-- are contributing positively, with minimal underperformance across the catalog.

WITH comparison_cte AS
(
SELECT 
    t2.productCode, 
    t3.productName, 
    t3.productLine, 
    t3.productScale, 
    
    YEAR(t1.orderDate) as year,
    
    -- Aggregate total quantity sold per product per year
    SUM(t2.quantityOrdered) AS sold_this_year 
    
FROM orders t1

    -- Join orders with order details to access product-level sales
	INNER JOIN orderdetails t2
		ON t1.orderNumber = t2.orderNumber
        
    -- Join with products to enrich with product attributes
	INNER JOIN products t3
        ON t3.productCode = t2.productCode
        
WHERE 
    -- Filter full period (2003–2004) using date range for accuracy
    t1.orderDate >= '2003-01-01' 
    AND t1.orderDate < '2005-01-01' 
    
    -- Include only shipped orders
    AND t1.status = 'Shipped'

GROUP BY 
    YEAR(t1.orderDate), 
    t2.productCode, 
    t3.productName, 
    t3.productLine, 
    t3.productScale
), 

sold_in_2003 AS
(
    SELECT 
        productCode, 
        productName, 
        productLine, 
        productScale, 
        year, 
        sold_this_year,

        -- Window function:
        -- LAG retrieves previous year's sales for each product
        -- PARTITION BY productCode ensures comparison is done per product
        -- ORDER BY year defines the time sequence (2003 → 2004)
        LAG(sold_this_year) 
            OVER (PARTITION BY productCode ORDER BY year) 
            as sold_previousely
            
    FROM comparison_cte
), 

YoY_cte AS 
(
    SELECT *,
    
        -- Year-over-Year growth calculation at product level
        ROUND(
            (sold_this_year - sold_previousely) / sold_previousely * 100, 
        2) AS YoY_growth
        
    FROM sold_in_2003
)
    
SELECT *
FROM YoY_cte

-- Ordering allows easy comparison of each product across years
ORDER BY productCode, year;