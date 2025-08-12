-- Esquema esperado (ajuste nomes se preciso):
-- customers(customer_id, created_at)
-- orders(order_id, customer_id, order_date, status)
-- order_items(order_id, product_id, category, price, qty)

-- 1) Receita mensal
WITH items AS (
  SELECT oi.order_id,
         oi.price * oi.qty AS line_total,
         DATE_TRUNC('month', o.order_date) AS mth
  FROM order_items oi
  JOIN orders o USING(order_id)
  WHERE o.status = 'completed'
)
SELECT mth, ROUND(SUM(line_total), 2) AS revenue
FROM items
GROUP BY mth
ORDER BY mth;

-- 2) Top 10 categorias por receita
SELECT oi.category,
       ROUND(SUM(oi.price * oi.qty), 2) AS revenue
FROM order_items oi
JOIN orders o USING(order_id)
WHERE o.status = 'completed'
GROUP BY oi.category
ORDER BY revenue DESC
LIMIT 10;

-- 3) Clientes novos x recorrentes por mês
WITH first_order AS (
  SELECT customer_id, MIN(order_date) AS first_dt
  FROM orders WHERE status='completed'
  GROUP BY customer_id
),
orders_m AS (
  SELECT o.customer_id,
         DATE_TRUNC('month', o.order_date) AS mth,
         CASE WHEN o.order_date = fo.first_dt THEN 'new' ELSE 'returning' END AS kind,
         SUM(oi.price * oi.qty) AS revenue
  FROM orders o
  JOIN first_order fo USING(customer_id)
  JOIN order_items oi USING(order_id)
  WHERE o.status='completed'
  GROUP BY 1,2,3
)
SELECT mth, kind, ROUND(SUM(revenue),2) AS revenue
FROM orders_m
GROUP BY 1,2
ORDER BY 1,2;

-- 4) RFM simplificado (última compra, frequência, valor)
WITH base AS (
  SELECT o.customer_id,
         MAX(o.order_date) AS last_order,
         COUNT(DISTINCT o.order_id) AS freq,
         SUM(oi.price * oi.qty) AS monetary
  FROM orders o
  JOIN order_items oi USING(order_id)
  WHERE o.status='completed'
  GROUP BY o.customer_id
)
SELECT customer_id,
       DATE_PART('day', CURRENT_DATE - last_order) AS recency_days,
       freq, ROUND(monetary,2) AS monetary
FROM base
ORDER BY monetary DESC;
