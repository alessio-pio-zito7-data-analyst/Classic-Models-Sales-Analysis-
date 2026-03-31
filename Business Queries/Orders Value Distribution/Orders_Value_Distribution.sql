/* 
Order Value Distribution Analysis (2003–2004)

Goal:
Analyze the distribution of order values to understand:
- Typical order size
- Variability
- Presence of high-value outliers

Initial approach:
The analysis was originally designed using PERCENTILE_CONT() 
to compute median and percentiles directly.

Limitation:
MySQL does not support PERCENTILE_CONT(), therefore
percentiles were calculated manually using window functions.

Approach:
- Compute total order value per order
- Rank orders within each year
- Derive median and percentiles using row positions
*/

WITH cte_order_values AS 
(
    /* 
    Compute total value per order
    */
    
    SELECT 
        t1.orderNumber, 
        YEAR(t2.orderDate) AS year,
        SUM(t1.quantityOrdered * t1.priceEach) AS total_order_value
        
    FROM orderdetails t1
    INNER JOIN orders t2
        ON t1.orderNumber = t2.orderNumber
        
    WHERE YEAR(t2.orderDate) IN (2003, 2004)
      AND t2.status = 'Shipped'
      
    GROUP BY t1.orderNumber, YEAR(t2.orderDate)
),

cte_ranked AS
(
    /*
    Rank orders by value within each year
    and compute total number of orders
    */
    
    SELECT
        year,
        total_order_value,
        ROW_NUMBER() OVER (PARTITION BY year ORDER BY total_order_value) AS rn,
        COUNT(*) OVER (PARTITION BY year) AS total_rows
        
    FROM cte_order_values
)

SELECT
    year,

    -- Basic distribution metrics
    MIN(total_order_value) AS min_order,
    MAX(total_order_value) AS max_order,
    ROUND(AVG(total_order_value), 2) AS avg_order,

    /* 
    Median:
    Average of middle values (handles both odd and even cases)
    */
    ROUND(AVG(
        CASE 
            WHEN rn IN (
                FLOOR((total_rows + 1)/2), 
                FLOOR((total_rows + 2)/2)
            )
            THEN total_order_value
        END
    ),2) AS median_order,

    /*
    Percentiles:
    Approximated by selecting the value at the target rank
    */
    
    -- 90th percentile
    MAX(
        CASE 
            WHEN rn = FLOOR(0.90 * total_rows) 
            THEN total_order_value
        END
    ) AS p90,

    -- 95th percentile
    MAX(
        CASE 
            WHEN rn = FLOOR(0.95 * total_rows) 
            THEN total_order_value
        END
    ) AS p95,

    -- 99th percentile
    MAX(
        CASE 
            WHEN rn = FLOOR(0.99 * total_rows) 
            THEN total_order_value
        END
    ) AS p99

FROM cte_ranked
GROUP BY year
ORDER BY year;