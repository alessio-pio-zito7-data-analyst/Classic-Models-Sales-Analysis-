-- Analysis: Top Customers Performance (Year 2003)
-- Objective: Identify top-performing customers based on revenue and analyze purchasing behavior
WITH top_customers_03 AS
(
	SELECT 
        t1.orderNumber,
        t2.customerNumber,
        t3.customerName,
        t3.city,
        t3.country,
		SUM(t1.quantityOrdered * t1.priceEach) AS orders_revenue -- Calculate revenue at order level
	FROM orderdetails t1
	INNER JOIN orders t2
		ON t1.orderNumber = t2.orderNumber
	INNER JOIN customers t3
		ON t2.customerNumber = t3.customerNumber
	WHERE YEAR(t2.orderDate) = 2003 
	AND t2.status = 'Shipped' -- Include only completed (shipped) orders
	GROUP BY 
        t1.orderNumber,
        t2.customerNumber,
        t3.customerName,
        t3.city,
        t3.country
), 

customer_stats AS -- Aggregate customer-level metrics to evaluate performance
(
	SELECT 
        customerNumber,
        customerName,
        city,
        country,
		SUM(orders_revenue) AS customer_revenue,
		COUNT(orderNumber) AS total_orders,
		MIN(orders_revenue) AS min_order_value,
		MAX(orders_revenue) AS max_order_value,
		ROUND(AVG(orders_revenue),2) AS avg_order_value
	FROM top_customers_03
	GROUP BY 
        customerNumber,
        customerName,
        city,
        country
)
-- Ranking customers based on total revenue contribution
-- Observation: Most customers place 1–2 orders per year, while the top 3 generate significantly higher volume
-- This indicates a potential dependency on a small number of high-value customers (concentration risk)
-- Additionally, some customers show higher average order values, suggesting strong growth potential
-- Further analysis on subsequent years (e.g., 2004) will follow.
SELECT 
ROW_NUMBER() OVER (ORDER BY customer_revenue DESC) AS rank_count,
customerName,
city,
country,
total_orders,
customer_revenue,
min_order_value,
max_order_value,
avg_order_value
FROM customer_stats
ORDER BY customer_revenue DESC;