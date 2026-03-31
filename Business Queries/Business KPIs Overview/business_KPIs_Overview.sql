/* 
Complete business metrics analysis (2003–2004)

Goal:
Build a yearly overview of key business KPIs:
- Revenue
- Orders & customers
- AOV (Average Order Value)
- Purchase Frequency (orders per customer)
- Gross Margin
- LTV (simplified model)

Note:
LTV is calculated as:
AOV * Purchase Frequency * Margin

This is a simplified proxy and does not include customer retention over time.
*/

WITH cte_orders_summary AS
(
    /* 
    Aggregate core order-level metrics
    */
    
	SELECT  
        YEAR(t2.orderDate) AS year,
        COUNT(DISTINCT t1.orderNumber) AS total_orders,
        COUNT(DISTINCT t2.customerNumber) AS total_customers,
        SUM(t1.quantityOrdered * t1.priceEach) AS revenue,
        
        -- Average number of items per order
        ROUND(SUM(t1.quantityOrdered) / COUNT(DISTINCT t1.orderNumber),2) 
        AS items_per_order
        
	FROM orderdetails t1
	INNER JOIN orders t2
		ON t1.orderNumber = t2.orderNumber

	WHERE YEAR(t2.orderDate) IN (2003,2004)
      AND t2.status = 'Shipped'
      
	GROUP BY YEAR(t2.orderDate)
),

cte_cogs AS
(
    /*
    Calculate Cost of Goods Sold (COGS)
    Used to derive profitability metrics
    */
    
	SELECT 
        YEAR(t2.orderDate) AS year,
        SUM(t1.quantityOrdered * t3.buyPrice) AS cogs
        
	FROM orderdetails t1
	INNER JOIN orders t2
		ON t1.orderNumber = t2.orderNumber
	INNER JOIN products t3
		ON t1.productCode = t3.productCode
        
	WHERE YEAR(t2.orderDate) IN (2003,2004)
      AND t2.status = 'Shipped'
      
	GROUP BY YEAR(t2.orderDate)
),

cte_metrics AS
(
    /*
    Combine revenue and cost data
    and compute key business KPIs
    */
    
	SELECT 
        a.year, 
        a.total_customers, 
        a.total_orders, 
        a.items_per_order, 
        a.revenue, 
        b.cogs,
        
        -- Average Order Value
        ROUND(a.revenue / a.total_orders,2) AS aov,
        
        /* 
        Purchase Frequency:
        Average number of orders per customer
        */
        ROUND(a.total_orders * 1.0 / a.total_customers, 2) AS purchase_frequency,
        
        -- Gross Margin
        ROUND((a.revenue - b.cogs) / a.revenue, 2) AS gm,
        
        /*
        Simplified LTV:
        AOV * Purchase Frequency * Margin
        
        This metric estimates customer value 
        without considering retention or time dimension.
        */
        ROUND(
            (a.revenue / a.total_orders) *
            (a.total_orders * 1.0 / a.total_customers) *
            ((a.revenue - b.cogs) / a.revenue),
        2) AS ltv

	FROM cte_orders_summary a
	INNER JOIN cte_cogs b
		ON a.year = b.year
)

SELECT * 
FROM cte_metrics;