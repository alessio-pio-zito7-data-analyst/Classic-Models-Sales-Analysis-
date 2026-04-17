-- Note: Product referential integrity validated in orderdetails table -- 

-- Count total number of unique products
SELECT COUNT(DISTINCT productCode) AS total_products 
FROM products;

-- Count total number of unique vendors
SELECT COUNT(DISTINCT productVendor) AS total_vendors 
FROM products;

-- Data Quality Check: NULL Values in products
-- Verify absence of NULL values across key product fields
SELECT
    SUM(CASE WHEN productCode IS NULL THEN 1 ELSE 0 END) AS null_p_code,
    SUM(CASE WHEN productName IS NULL THEN 1 ELSE 0 END) AS null_p_name,
    SUM(CASE WHEN productLine IS NULL THEN 1 ELSE 0 END) AS null_p_line,
    SUM(CASE WHEN productScale IS NULL THEN 1 ELSE 0 END) AS null_p_scale,
    SUM(CASE WHEN productVendor IS NULL THEN 1 ELSE 0 END) AS null_p_vendor,
    SUM(CASE WHEN productDescription IS NULL THEN 1 ELSE 0 END) AS null_P_descp,
    SUM(CASE WHEN quantityInStock IS NULL THEN 1 ELSE 0 END) AS null_stock,
    SUM(CASE WHEN buyPrice IS NULL THEN 1 ELSE 0 END) AS null_buy_price,
    SUM(CASE WHEN MSRP IS NULL THEN 1 ELSE 0 END) AS null_MSRP
FROM products;

-- Data Quality Check: Duplicate Products
-- Ensure productCode is unique
SELECT productCode, COUNT(*) AS duplicates
FROM products
GROUP BY productCode
HAVING COUNT(*) > 1;

-- Data Validation: Pricing Consistency
-- Identify products where buyPrice exceeds MSRP (potential data issue)
SELECT buyPrice, MSRP
FROM products
WHERE buyPrice > MSRP; 

-- Data Validation: Low Inventory
-- Identify products with low stock levels (<= 30 units)
SELECT *
FROM products
WHERE quantityInStock >= 0
AND quantityInStock <=30;
