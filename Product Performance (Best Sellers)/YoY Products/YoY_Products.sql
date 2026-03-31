-- This analysis compares total items sold between 2003 and 2004.
-- The results show a +33.72% year-over-year growth, indicating a strong increase in sales volume.
-- This represents a significant performance improvement and highlights a positive business trend.

WITH yearly_sales AS
(
    SELECT
        YEAR(t1.orderDate) AS year,
        
        -- Aggregate total quantity sold per year
        SUM(t2.quantityOrdered) AS items_sold
        
    FROM orders t1
    
        -- Join with order details to access product-level quantities
        INNER JOIN orderdetails t2
            ON t1.orderNumber = t2.orderNumber
            
        -- Join with products (not strictly required for aggregation, but ensures consistency with product-level data)
        INNER JOIN products t3
            ON t3.productCode = t2.productCode
            
    WHERE 
        -- Filter full period (2003–2004) using date range for accuracy
        t1.orderDate >= '2003-01-01' 
        AND t1.orderDate < '2005-01-01' 
        
        -- Include only shipped orders
        AND t1.status = 'Shipped'
        
    GROUP BY 
        YEAR(t1.orderDate)
)

SELECT
    year,
    items_sold,

    -- Window function:
    -- LAG retrieves total items sold in the previous year
    -- ORDER BY ensures correct chronological comparison
    LAG(items_sold) OVER (ORDER BY year) AS prev_year_items,

    -- Year-over-Year growth calculation based on sales volume
    ROUND(
        (items_sold - LAG(items_sold) OVER (ORDER BY year))
        / LAG(items_sold) OVER (ORDER BY year) * 100, 
    2) AS YoY_growth

FROM yearly_sales;