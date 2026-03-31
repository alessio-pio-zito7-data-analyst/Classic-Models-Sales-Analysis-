-- This analysis focuses on customers managed by offices in San Francisco and Tokyo,
-- aiming to compare geographical coverage and customer distribution across the two locations.

SELECT 
    t1.customerName, 
    t3.city as office_city, 
    t3.country as office_country, 
    t1.country as customer_country, 
    t1.city as customer_city, 
    t3.territory

FROM customers t1

-- Link customers to their assigned sales representatives
INNER JOIN employees t2
    ON t1.salesRepEmployeeNumber = t2.employeeNumber

-- Link employees to their office location
INNER JOIN offices t3
    ON t2.officeCode = t3.officeCode

WHERE 
    -- Filter only San Francisco and Tokyo offices
    t3.city IN ('Tokyo', 'San Francisco');

-- Insights:
-- San Francisco appears to have a more geographically concentrated customer base,
-- suggesting potential opportunities for regional expansion (e.g., nearby states such as Nevada).

-- Tokyo shows a more geographically diverse customer distribution,
-- but with a relatively smaller customer base.

-- The limited number of customers in Tokyo could also suggest higher market competition,
-- indicating the need for targeted marketing strategies, even within Japan only.