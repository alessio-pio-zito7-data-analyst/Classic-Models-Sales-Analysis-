/* 
Customer Retention & Churn Analysis (Year-over-Year)

Goal:
Measure customer behavior across years:
- Retention (customers who return)
- Churn (customers who do not return)
- New or reactivated customers

Approach:
- Identify active customers per year
- Compare customer presence between consecutive years

Note:
"New or reactivated" includes both:
- First-time customers
- Previously inactive customers returning
*/

WITH years AS 
(
    /* Extract available years */
    
    SELECT DISTINCT YEAR(orderDate) AS year
    FROM orders
),

customers AS 
(
    /*
    Unique customer activity per year
    (deduplicated to avoid multiple orders per customer)
    */
    
    SELECT DISTINCT 
        customerNumber, 
        YEAR(orderDate) AS year
    FROM orders
),

churn_retention AS 
(
    /*
    Compare customer activity between consecutive years
    */
    
    SELECT
        y.year,
        
        -- Customers active in previous year
        COUNT(DISTINCT c_prev.customerNumber) AS customers_prev_year,
        
        -- Customers retained (present in both years)
        COUNT(DISTINCT c_curr.customerNumber) AS retained_customers,
        
        -- Customers lost (present last year but not this year)
        COUNT(DISTINCT c_prev.customerNumber) 
        - COUNT(DISTINCT c_curr.customerNumber) AS lost_customers,
        
        -- New or reactivated customers
        COUNT(DISTINCT c_new.customerNumber) AS new_or_reactivated
        
    FROM years y

    LEFT JOIN customers c_prev
        ON c_prev.year = y.year - 1

    LEFT JOIN customers c_curr
        ON c_curr.customerNumber = c_prev.customerNumber
        AND c_curr.year = y.year

    LEFT JOIN customers c_new
        ON c_new.year = y.year
        AND c_new.customerNumber NOT IN (
            SELECT customerNumber 
            FROM customers 
            WHERE year = y.year - 1
        )

    GROUP BY y.year
)

SELECT
    year,
    customers_prev_year,
    retained_customers,
    lost_customers,
    new_or_reactivated,

    -- Retention rate
    ROUND(retained_customers / customers_prev_year * 100, 2) 
    AS retention_percentage,

    -- Churn rate
    ROUND(lost_customers / customers_prev_year * 100, 2) 
    AS churn_percentage

FROM churn_retention
ORDER BY year;