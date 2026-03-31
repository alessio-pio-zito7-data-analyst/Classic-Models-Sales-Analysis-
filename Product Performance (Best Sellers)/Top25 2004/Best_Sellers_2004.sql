-- The "Ferrari 360 Spider" remains the best-performing product, with 729 units sold,
-- confirming its strong and consistent demand compared to the previous year.
-- The lowest-selling product recorded 279 units, indicating that sales are still
-- relatively well distributed across the product catalog.
-- Notably, a new product line, "Planes", appears among the top performers,
-- suggesting a shift or expansion in customer preferences compared to 2003.
-- This pattern may indicate potential opportunities for further analysis,
-- such as exploring products frequently purchased together (cross-selling behavior).

WITH best_sellers_04 AS
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

    -- Join orders with order details to analyze product-level sales
	INNER JOIN orderdetails t2
		ON t1.orderNumber = t2.orderNumber
        
    -- Join with products to include product attributes
	INNER JOIN products t3
        ON t3.productCode = t2.productCode
        
WHERE 
    -- Filter for full year 2004 using date range for accuracy
    t1.orderDate >= '2004-01-01'
    AND t1.orderDate < '2005-01-01' 
    
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
    -- ROW_NUMBER assigns a unique rank based on items sold
    -- Highest-selling products receive rank 1
    ROW_NUMBER() OVER (ORDER BY items_sold DESC) AS rank_count,

    productCode, 
    productName, 
    productLine, 
    productScale, 
    year, 
    items_sold

FROM best_sellers_04

-- Order results to display top-selling products first
ORDER BY items_sold DESC;

