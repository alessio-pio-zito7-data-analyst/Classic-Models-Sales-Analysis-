-- This analysis identifies the top-selling products for the year 2003.
-- It highlights how sales are distributed across the product catalog,
-- with a noticeable spread between the best and worst performing items.
-- The dataset includes 109 products, with the top seller reaching 672 units sold,
-- while the lowest performs at 221 units. Despite the relatively even distribution,
-- the "1992 Ferrari 360 Spider" clearly stands out as the best-performing product.

WITH best_sellers_03 AS
(
SELECT 
    t2.productCode, 
    t3.productName, 
    t3.productLine, 
    t3.productScale, 
    
    YEAR(t1.orderDate) as year,
    
    -- Aggregate total quantity sold per product
    SUM(t2.quantityOrdered) AS items_sold 
    
FROM orders t1

    -- Join orders with order details to access product-level sales
	INNER JOIN orderdetails t2
		ON t1.orderNumber = t2.orderNumber
        
    -- Join with products to enrich with product attributes
	INNER JOIN products t3
        ON t3.productCode = t2.productCode
        
WHERE 
    -- Filter for full year 2003 using date range (more precise than YEAR = 2003)
    t1.orderDate >= '2003-01-01'
    AND t1.orderDate < '2004-01-01'
    
    -- Include only shipped orders
    AND t1.status = 'Shipped'

GROUP BY 
    YEAR(t1.orderDate), 
    t2.productCode, 
    t3.productName, 
    t3.productLine, 
    t3.productScale
) 

SELECT 

    -- Window function:
    -- ROW_NUMBER assigns a unique rank to each product based on items sold
    -- ORDER BY DESC ensures the best-selling products receive rank 1
    ROW_NUMBER() OVER (ORDER BY items_sold DESC) AS rank_count,

    productCode, 
    productName, 
    productLine, 
    productScale, 
    year, 
    items_sold

FROM best_sellers_03

-- Sort results by sales volume to show top-performing products first
ORDER BY items_sold DESC;
