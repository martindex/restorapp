-- ============================================
-- VARES POS - TRIGGERS AND STORED PROCEDURES
-- ============================================

USE vares_pos;

-- Drop existing triggers if they exist
DROP TRIGGER IF EXISTS trg_update_order_total_insert;

DROP TRIGGER IF EXISTS trg_update_order_total_update;

DROP TRIGGER IF EXISTS trg_update_order_total_delete;

DROP TRIGGER IF EXISTS trg_validate_single_order;

-- Drop existing procedures if they exist
DROP PROCEDURE IF EXISTS sp_open_table;

DROP PROCEDURE IF EXISTS sp_close_order;

DROP PROCEDURE IF EXISTS sp_join_tables;

DROP PROCEDURE IF EXISTS sp_separate_tables;

DELIMITER / /

-- ============================================
-- TRIGGER: Update Order Total
-- ============================================
CREATE TRIGGER trg_update_order_total_insert
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
    UPDATE orders
    SET subtotal = (
        SELECT COALESCE(SUM(quantity * unit_price), 0)
        FROM order_items
        WHERE order_id = NEW.order_id
    ),
    total = subtotal + tip,
    status = CASE 
        WHEN status = 'OPEN' THEN 'IN_PROGRESS'
        ELSE status
    END
    WHERE id = NEW.order_id;
END //

CREATE TRIGGER trg_update_order_total_update
AFTER UPDATE ON order_items
FOR EACH ROW
BEGIN
    UPDATE orders
    SET subtotal = (
        SELECT COALESCE(SUM(quantity * unit_price), 0)
        FROM order_items
        WHERE order_id = NEW.order_id
    ),
    total = subtotal + tip
    WHERE id = NEW.order_id;
END //

CREATE TRIGGER trg_update_order_total_delete
AFTER DELETE ON order_items
FOR EACH ROW
BEGIN
    UPDATE orders
    SET subtotal = (
        SELECT COALESCE(SUM(quantity * unit_price), 0)
        FROM order_items
        WHERE order_id = OLD.order_id
    ),
    total = subtotal + tip
    WHERE id = OLD.order_id;
END //

-- ============================================
-- TRIGGER: Validate Single Active Order per Table
-- ============================================
CREATE TRIGGER trg_validate_single_order
BEFORE INSERT ON orders
FOR EACH ROW
BEGIN
    DECLARE active_orders INT;
    
    SELECT COUNT(*) INTO active_orders
    FROM orders
    WHERE table_id = NEW.table_id
      AND status != 'CLOSED';
    
    IF active_orders > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Table already has an active order';
    END IF;
END //

-- ============================================
-- STORED PROCEDURE: Open Table and Create Order
-- ============================================
CREATE PROCEDURE sp_open_table(
    IN p_table_id CHAR(36),
    IN p_waiter_id CHAR(36),
    IN p_reservation_id CHAR(36)
)
BEGIN
    DECLARE v_order_id CHAR(36);
    DECLARE v_table_status VARCHAR(20);
    
    -- Check table status
    SELECT status INTO v_table_status
    FROM tables
    WHERE id = p_table_id;
    
    IF v_table_status != 'AVAILABLE' AND v_table_status != 'RESERVED' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Table is not available';
    END IF;
    
    -- Create order
    SET v_order_id = UUID();
    INSERT INTO orders (id, table_id, waiter_id, reservation_id, status)
    VALUES (v_order_id, p_table_id, p_waiter_id, p_reservation_id, 'OPEN');
    
    -- Update table status
    UPDATE tables SET status = 'OCCUPIED' WHERE id = p_table_id;
    
    -- If table is joined, update main table
    UPDATE tables t1
    SET t1.status = 'OCCUPIED'
    WHERE t1.id = (SELECT main_table_id FROM tables WHERE id = p_table_id AND main_table_id IS NOT NULL);
    
    -- Return order ID
    SELECT v_order_id AS order_id;
END //

-- ============================================
-- STORED PROCEDURE: Close Order and Free Table
-- ============================================
CREATE PROCEDURE sp_close_order(
    IN p_order_id CHAR(36)
)
BEGIN
    DECLARE v_table_id CHAR(36);
    DECLARE v_main_table_id CHAR(36);
    DECLARE pending_items INT;
    
    -- Check for pending items
    SELECT COUNT(*) INTO pending_items
    FROM order_items
    WHERE order_id = p_order_id
      AND status != 'SERVED';
    
    IF pending_items > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'There are pending items to serve';
    END IF;
    
    -- Get table ID
    SELECT table_id INTO v_table_id
    FROM orders
    WHERE id = p_order_id;
    
    -- Close order
    UPDATE orders
    SET status = 'CLOSED',
        closed_at = NOW()
    WHERE id = p_order_id;
    
    -- Get main table if joined
    SELECT main_table_id INTO v_main_table_id
    FROM tables
    WHERE id = v_table_id;
    
    -- Free table
    UPDATE tables SET status = 'AVAILABLE' WHERE id = v_table_id;
    
    -- If table was joined, separate
    IF v_main_table_id IS NOT NULL THEN
        CALL sp_separate_tables(v_main_table_id);
    END IF;
END //

-- ============================================
-- STORED PROCEDURE: Join Tables
-- ============================================
CREATE PROCEDURE sp_join_tables(
    IN p_main_table_id CHAR(36),
    IN p_table_ids JSON,
    IN p_reservation_id CHAR(36)
)
BEGIN
    DECLARE v_join_id CHAR(36);
    DECLARE i INT DEFAULT 0;
    DECLARE table_count INT;
    DECLARE current_table_id CHAR(36);
    
    -- Create join record
    SET v_join_id = UUID();
    INSERT INTO table_joins (id, main_table_id, reservation_id, active)
    VALUES (v_join_id, p_main_table_id, p_reservation_id, TRUE);
    
    -- Update main table
    UPDATE tables 
    SET status = 'OCCUPIED'
    WHERE id = p_main_table_id;
    
    -- Get count of tables to join
    SET table_count = JSON_LENGTH(p_table_ids);
    
    -- Update joined tables
    WHILE i < table_count DO
        SET current_table_id = JSON_UNQUOTE(JSON_EXTRACT(p_table_ids, CONCAT('$[', i, ']')));
        
        IF current_table_id != p_main_table_id THEN
            UPDATE tables
            SET status = 'JOINED',
                main_table_id = p_main_table_id
            WHERE id = current_table_id;
        END IF;
        
        SET i = i + 1;
    END WHILE;
END //

-- ============================================
-- STORED PROCEDURE: Separate Tables
-- ============================================
CREATE PROCEDURE sp_separate_tables(
    IN p_main_table_id CHAR(36)
)
BEGIN
    -- Free main table
    UPDATE tables
    SET status = 'AVAILABLE'
    WHERE id = p_main_table_id;
    
    -- Free joined tables
    UPDATE tables
    SET status = 'AVAILABLE',
        main_table_id = NULL
    WHERE main_table_id = p_main_table_id;
    
    -- Mark join as inactive
    UPDATE table_joins
    SET active = FALSE,
        separated_at = NOW()
    WHERE main_table_id = p_main_table_id
      AND active = TRUE;
END //