# Write your MySQL query statement below
WITH latest_change AS (
    SELECT 
        product_id, 
        MAX(change_date) AS last_change_date
    FROM Products
    WHERE change_date <= '2019-08-16'
    GROUP BY product_id
)
SELECT 
    p.product_id,
    COALESCE(pr.new_price, 10) AS price
FROM (
    -- get all distinct products from the table
    SELECT DISTINCT product_id FROM Products
    UNION
    -- in case a product never had a price change (not in Products table), 
    -- we can add more products if known from a Product list table
    SELECT product_id FROM Products
) p
LEFT JOIN latest_change lc
    ON p.product_id = lc.product_id
LEFT JOIN Products pr
    ON pr.product_id = lc.product_id 
   AND pr.change_date = lc.last_change_date
ORDER BY p.product_id;