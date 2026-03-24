-- Analysis: Top Customers Performance (Year 2004)
-- Objective: Identify top-performing customers based on revenue and compare results with the previous year (2003)
-- in order to assess potential concentration risk and evaluate customer trends and retention
WITH top_customers_04 AS
(
	SELECT 
        t1.orderNumber,
        t2.customerNumber,
        t3.customerName,
        t3.city,
        t3.country,
		SUM(t1.quantityOrdered * t1.priceEach) AS orders_revenue
	FROM orderdetails t1
	INNER JOIN orders t2
		ON t1.orderNumber = t2.orderNumber
	INNER JOIN customers t3
		ON t2.customerNumber = t3.customerNumber
	WHERE YEAR(t2.orderDate) = 2004
	AND t2.status = 'Shipped'
	GROUP BY 
        t1.orderNumber,
        t2.customerNumber,
        t3.customerName,
        t3.city,
        t3.country
), 

customer_stats AS
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
	FROM top_customers_04
	GROUP BY 
        customerNumber,
        customerName,
        city,
        country
)
-- Observation: 2 of the top 3 customers from 2003 remain top contributors in 2004, generating significantly higher volumes
-- This confirms a dependency on a small number of high-value customers (concentration risk)
-- Smaller customers show lower engagement, but higher average order value, suggesting an opportunity to increase order frequency
-- Potential actions could include incentives such as free shipping based on minimum order value
-- Further validation is recommended through additional analysis
SELECT 
ROW_NUMBER() OVER (ORDER BY customer_revenue DESC) AS row_count,
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