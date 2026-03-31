-- Calculate quarterly revenue to analyze business performance and identify potential seasonal trends,
-- such as increased revenue towards the end of the year

SELECT 
    YEAR(orderDate) AS year,
    QUARTER(orderDate) AS quarter,
    
    -- Aggregate total revenue per quarter
    SUM(quantityOrdered * priceEach) AS revenue
    
FROM orderdetails t1

-- Join order details with orders to access date and status
JOIN orders t2
    ON t1.orderNumber = t2.orderNumber

WHERE 
    -- Include only shipped orders to reflect actual realized revenue
    t2.status = 'Shipped' 
    AND YEAR(t2.orderDate) IN (2003,2004)

GROUP BY 
    YEAR(orderDate),
    QUARTER(orderDate)

-- Chronological ordering for time series analysis
ORDER BY 
    year, quarter;