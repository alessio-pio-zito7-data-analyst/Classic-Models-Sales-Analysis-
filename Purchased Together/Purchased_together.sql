-- This analysis explores products frequently purchased together by identifying combinations
-- of product lines within the same order.
-- The results were validated using a pivot table in Excel, enabling flexible filtering
-- by individual years or a combined view of 2003 and 2004.

WITH prod_sales AS
(
SELECT  
    t1.orderNumber, 
    t1.productCode, 
    t3.productName, 
    t3.productLine, 
    t3.productScale,
    
    YEAR(t2.orderDate) as year
    
FROM orderdetails t1

    -- Join to access order-level information (date and status)
	INNER JOIN orders t2
		ON t1.orderNumber = t2.orderNumber
        
    -- Join with products to include product attributes
	INNER JOIN products t3
		ON t1.productCode = t3.productCode 
        
WHERE 
    -- Filter full period (2003–2004)
    t2.orderDate >= '2003-01-01' 
    AND t2.orderDate < '2005-01-01' 
    
    -- Include only shipped orders
    AND t2.status = 'Shipped'
)

SELECT DISTINCT 
    t1.ordernumber, 
    
    -- First product line in the combination
    t1.productLine as prod_one, 
    
    -- Second product line from the same order
    t2.productLine as product_two, 
    
    t1.year

FROM prod_sales t1

-- Self-join:
-- The table is joined with itself to generate combinations of product lines within the same order
LEFT JOIN prod_sales t2
    ON t1.ordernumber = t2.ordernumber 
    
    -- Exclude same product line to avoid pairing identical items
    AND t1.productLine <> t2.productLine;

    
/* NOTE 
It is important to note that the analysis may include logical duplicates,
where product combinations are represented in both directions (A–B and B–A).
While this does not affect the overall trend or the interpretation of cross-selling patterns,
it may slightly inflate the frequency of certain combinations.
However, since the objective of this analysis is to identify general purchasing behavior
rather than precise pair frequencies, this limitation does not compromise the overall insights.
*/

