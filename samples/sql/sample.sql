SELECT
  c.customer_id,
  c.customer_name,
  c.email,
  o.order_id,
  o.order_date,
  o.total_amount,
  p.product_name,
  p.category,
  oi.quantity,
  oi.unit_price,
  r.rating,
  r.review_text,
  s.shipment_status,
  s.delivery_date
FROM
  customers c
  -- INNER JOIN: Only customers who have placed orders
  INNER JOIN orders o ON c.customer_id = o.customer_id
  -- INNER JOIN: Get order line items
  INNER JOIN order_items oi ON o.order_id = oi.order_id
  -- LEFT JOIN: Include products even if not in any orders (shows all products)
  LEFT JOIN products p ON oi.product_id = p.product_id
  -- LEFT JOIN: Include orders even without reviews (not all orders are reviewed)
  LEFT JOIN reviews r ON o.order_id = r.order_id
  AND r.customer_id = c.customer_id
  -- RIGHT JOIN: Ensure all shipments are included, even orphaned ones
  RIGHT JOIN shipments s ON o.order_id = s.order_id
WHERE
  o.order_date >= '2024-01-01'
  AND (
    p.category IN ('Electronics', 'Books', 'Clothing')
    OR p.category IS NULL
  )
ORDER BY
  c.customer_name,
  o.order_date DESC;

-- Example of FULL OUTER JOIN (supported in PostgreSQL, not MySQL)
-- This would show ALL customers and ALL orders, matching where possible
/*
SELECT 
c.customer_id,
c.customer_name,
o.order_id,
o.order_date,
CASE 
WHEN o.order_id IS NULL THEN 'No orders placed'
WHEN c.customer_id IS NULL THEN 'Order without customer record'
ELSE 'Matched'
END AS match_status
FROM 
customers c
FULL OUTER JOIN orders o 
ON c.customer_id = o.customer_id;
*/
