-- ============================================
-- VARES POS - DATABASE VIEWS
-- ============================================

USE vares_pos;

-- ============================================
-- VIEW: Available Tables
-- ============================================
CREATE OR REPLACE VIEW v_available_tables AS
SELECT t.id, t.number, z.name AS zone_name, t.capacity, t.position_x, t.position_y, t.status
FROM tables t
    INNER JOIN zones z ON t.zone_id = z.id
WHERE
    t.active = TRUE
    AND t.status = 'AVAILABLE';

-- ============================================
-- VIEW: Active Orders
-- ============================================
CREATE OR REPLACE VIEW v_active_orders AS
SELECT
    o.id,
    o.table_id,
    t.number AS table_number,
    z.name AS zone_name,
    u.name AS waiter_name,
    o.opened_at,
    o.status,
    o.subtotal,
    o.tip,
    o.total,
    COUNT(oi.id) AS item_count
FROM
    orders o
    INNER JOIN tables t ON o.table_id = t.id
    INNER JOIN zones z ON t.zone_id = z.id
    INNER JOIN users u ON o.waiter_id = u.id
    LEFT JOIN order_items oi ON o.id = oi.order_id
WHERE
    o.status != 'CLOSED'
GROUP BY
    o.id,
    o.table_id,
    t.number,
    z.name,
    u.name,
    o.opened_at,
    o.status,
    o.subtotal,
    o.tip,
    o.total;

-- ============================================
-- VIEW: Kitchen Queue
-- ============================================
CREATE OR REPLACE VIEW v_kitchen_queue AS
SELECT
    oi.id,
    oi.order_id,
    t.number AS table_number,
    p.name AS product_name,
    oi.quantity,
    oi.notes,
    oi.status,
    oi.ordered_at,
    TIMESTAMPDIFF(MINUTE, oi.ordered_at, NOW()) AS minutes_elapsed
FROM
    order_items oi
    INNER JOIN products p ON oi.product_id = p.id
    INNER JOIN orders o ON oi.order_id = o.id
    INNER JOIN tables t ON o.table_id = t.id
WHERE
    oi.type = 'FOOD'
    AND oi.status IN ('PENDING', 'IN_KITCHEN')
ORDER BY oi.ordered_at ASC;

-- ============================================
-- VIEW: Today's Reservations
-- ============================================
CREATE OR REPLACE VIEW v_today_reservations AS
SELECT
    r.id,
    COALESCE(c.name, r.reference_name) AS customer_name,
    r.party_size,
    r.time,
    r.status,
    r.type,
    GROUP_CONCAT(
        t.number
        ORDER BY t.number SEPARATOR ', '
    ) AS table_numbers
FROM
    reservations r
    LEFT JOIN customers c ON r.customer_id = c.id
    INNER JOIN reservation_tables rt ON r.id = rt.reservation_id
    INNER JOIN tables t ON rt.table_id = t.id
WHERE
    r.date = CURDATE()
    AND r.status IN ('PENDING', 'CONFIRMED')
GROUP BY
    r.id,
    customer_name,
    r.party_size,
    r.time,
    r.status,
    r.type
ORDER BY r.time ASC;

-- ============================================
-- VIEW: Daily Sales Summary
-- ============================================
CREATE OR REPLACE VIEW v_daily_sales AS
SELECT
    DATE(o.closed_at) AS sale_date,
    COUNT(DISTINCT o.id) AS total_orders,
    SUM(o.subtotal) AS total_subtotal,
    SUM(o.tip) AS total_tips,
    SUM(o.total) AS total_sales,
    AVG(o.total) AS average_ticket
FROM orders o
WHERE
    o.status = 'CLOSED'
    AND o.closed_at IS NOT NULL
GROUP BY
    DATE(o.closed_at);

-- ============================================
-- VIEW: Product Sales Ranking
-- ============================================
CREATE OR REPLACE VIEW v_product_ranking AS
SELECT
    p.id,
    p.name,
    c.name AS category_name,
    p.type,
    COUNT(oi.id) AS times_ordered,
    SUM(oi.quantity) AS total_quantity,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM
    products p
    INNER JOIN categories c ON p.category_id = c.id
    LEFT JOIN order_items oi ON p.id = oi.product_id
GROUP BY
    p.id,
    p.name,
    c.name,
    p.type
ORDER BY total_revenue DESC;