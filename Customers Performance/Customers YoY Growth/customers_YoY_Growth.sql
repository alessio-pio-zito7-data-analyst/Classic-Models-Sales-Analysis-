-- Analysis: Customer Revenue Growth (Year-over-Year)
-- Objective: Evaluate customer revenue trends between 2003 and 2004 and identify growth patterns

WITH top_customers AS
(
	SELECT 
        t2.customerNumber, 
        t3.customerName, 
        t3.city, 
        t3.country,
		YEAR(t2.orderDate) AS year,
        
        -- Calculate total revenue per customer per year
		SUM(t1.quantityOrdered * t1.priceEach) AS customer_revenue,
        
        -- Count distinct orders to measure customer activity level
        COUNT(DISTINCT t1.orderNumber) AS total_orders
        
	FROM orderdetails t1
	
        -- Join order details with orders to access order date and status
		INNER JOIN orders t2
			ON t1.orderNumber = t2.orderNumber
            
        -- Join with customers to enrich data with customer attributes
		INNER JOIN customers t3
			ON t2.customerNumber = t3.customerNumber
            
	WHERE 
        -- Filter only shipped orders to ensure revenue is realized
        YEAR(t2.orderDate) IN (2003, 2004) 
        AND t2.status = 'Shipped'
        
	GROUP BY 
        year, 
        t2.customerNumber, 
        t3.customerName, 
        t3.city, 
        t3.country
), 

previous_revenue_cte AS
(
	SELECT 
        customerNumber, 
        customerName, 
        city, 
        country,  
        year, 
        total_orders, 
        customer_revenue,

        -- Window function:
        -- LAG retrieves the previous year's revenue for each customer
        -- PARTITION BY ensures the calculation is done per customer
        -- ORDER BY year defines the chronological order
		LAG(customer_revenue) 
            OVER (PARTITION BY customerNumber ORDER BY year) 
            AS previous_revenue
            
	FROM top_customers
    
    -- Ordering helps readability but does not affect window calculation
	ORDER BY customerNumber, year
),
        
YoY_cte AS 
(
	SELECT *,
    
        -- Compute Year-over-Year growth percentage
        -- Formula: (current - previous) / previous
        -- ROUND used for readability
        ROUND((customer_revenue - previous_revenue) / previous_revenue * 100, 2) 
        AS YoY_growth
        
	FROM previous_revenue_cte
)

-- Insights:
-- Overall, top-performing customers show stable and positive YoY growth, confirming their importance to the business
-- Mid-tier customers also demonstrate growth, contributing to overall revenue expansion
-- In contrast, lower-tier customers show declining activity or no purchases in 2004, indicating potential churn risk
-- This suggests a dependency on a limited number of high-value customers, while smaller customers exhibit lower engagement
-- Business implication: strategies should focus both on retaining top customers and increasing engagement among lower-tier segments

SELECT *
FROM YoY_cte
ORDER BY customerNumber, year;
