# MODELO DE BASE DE DATOS - SISTEMA POS VARES
## Diseño Relacional para MySQL

---

## 1. DIAGRAMA ENTIDAD-RELACIÓN (ER)

```
┌─────────────────┐
│     USERS       │
├─────────────────┤
│ id (PK)         │
│ name            │
│ email           │
│ password_hash   │
│ role_id (FK)    │
│ active          │
│ created_at      │
└────────┬────────┘
         │
         │ 1:N
         │
┌────────▼────────┐
│      ROLES      │
├─────────────────┤
│ id (PK)         │
│ name            │
│ description     │
└─────────────────┘


┌─────────────────┐         ┌─────────────────┐
│      ZONES      │         │     TABLES      │
├─────────────────┤         ├─────────────────┤
│ id (PK)         │ 1:N     │ id (PK)         │
│ name            ├─────────┤ number          │
│ description     │         │ zone_id (FK)    │
│ active          │         │ capacity        │
└─────────────────┘         │ position_x      │
                            │ position_y      │
                            │ status          │
                            │ main_table_id   │
                            │ active          │
                            └────────┬────────┘
                                     │
                                     │ 1:N
                                     │
                            ┌────────▼────────┐
                            │  RESERVATIONS   │
                            ├─────────────────┤
                            │ id (PK)         │
                            │ customer_id(FK) │
                            │ party_size      │
                            │ date            │
                            │ time            │
                            │ status          │
                            │ type            │
                            │ reference_name  │
                            │ phone           │
                            │ notes           │
                            │ created_by (FK) │
                            └────────┬────────┘
                                     │
                                     │ N:M
                                     │
                            ┌────────▼──────────────┐
                            │ RESERVATION_TABLES    │
                            ├───────────────────────┤
                            │ id (PK)               │
                            │ reservation_id (FK)   │
                            │ table_id (FK)         │
                            │ is_main               │
                            └───────────────────────┘


┌─────────────────┐
│     ORDERS      │
├─────────────────┤
│ id (PK)         │
│ table_id (FK)   │
│ waiter_id (FK)  │
│ reservation_id  │
│ opened_at       │
│ closed_at       │
│ status          │
│ subtotal        │
│ tip             │
│ total           │
└────────┬────────┘
         │
         │ 1:N
         │
┌────────▼────────────┐
│   ORDER_ITEMS       │
├─────────────────────┤
│ id (PK)             │
│ order_id (FK)       │
│ product_id (FK)     │
│ quantity            │
│ unit_price          │
│ notes               │
│ type                │
│ status              │
│ ordered_at          │
│ served_at           │
└─────────────────────┘
         │
         │ N:1
         │
┌────────▼────────┐         ┌─────────────────┐
│    PRODUCTS     │         │   CATEGORIES    │
├─────────────────┤         ├─────────────────┤
│ id (PK)         │ N:1     │ id (PK)         │
│ name            ├─────────┤ name            │
│ description     │         │ description     │
│ category_id     │         │ type            │
│ price           │         │ active          │
│ type            │         └─────────────────┘
│ available       │
│ image_url       │
└─────────────────┘


┌─────────────────┐
│    PAYMENTS     │
├─────────────────┤
│ id (PK)         │
│ order_id (FK)   │
│ cashier_id (FK) │
│ amount          │
│ payment_method  │
│ paid_at         │
│ status          │
└─────────────────┘


┌─────────────────────┐
│   AUDIT_LOG         │
├─────────────────────┤
│ id (PK)             │
│ user_id (FK)        │
│ event_type          │
│ entity_type         │
│ entity_id           │
│ old_data            │
│ new_data            │
│ ip_address          │
│ timestamp           │
└─────────────────────┘
```

---

## 2. DEFINICIÓN DE TABLAS

### 2.1 Tabla: ROLES

```sql
CREATE TABLE roles (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

**Datos iniciales:**
```sql
INSERT INTO roles (name, description) VALUES
('SUPERUSER', 'General administrator with full system control'),
('WAITER', 'Service staff who take orders and manage tables'),
('COOK', 'Kitchen staff who process food orders'),
('CASHIER', 'Staff who process payments and close orders');
```

---

### 2.2 Tabla: USERS

```sql
CREATE TABLE users (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role_id CHAR(36) NOT NULL,
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES roles(id),
    INDEX idx_email (email),
    INDEX idx_role (role_id),
    INDEX idx_active (active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

**Campos:**
- `id`: Unique UUID identifier
- `name`: Full name of the user
- `email`: Unique email for login
- `password_hash`: Hashed password (bcrypt)
- `role_id`: Reference to user role
- `active`: Indicates if user is active
- `created_at`: Creation timestamp
- `updated_at`: Last modification timestamp

---

### 2.3 Tabla: ZONES

```sql
CREATE TABLE zones (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_name (name),
    INDEX idx_active (active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

**Datos iniciales:**
```sql
INSERT INTO zones (name, description) VALUES
('Main Hall', 'Main restaurant area'),
('Bar', 'Bar area with stools'),
('Patio', 'Outdoor area with tables'),
('VIP', 'Reserved area for special guests');
```

---

### 2.4 Tabla: TABLES

```sql
CREATE TABLE tables (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    number INT NOT NULL,
    zone_id CHAR(36) NOT NULL,
    capacity INT DEFAULT 5,
    position_x DECIMAL(10,2) NOT NULL,
    position_y DECIMAL(10,2) NOT NULL,
    status ENUM('AVAILABLE', 'RESERVED', 'OCCUPIED', 'JOINED') DEFAULT 'AVAILABLE',
    main_table_id CHAR(36) NULL,
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (zone_id) REFERENCES zones(id),
    FOREIGN KEY (main_table_id) REFERENCES tables(id),
    UNIQUE KEY uk_number_zone (number, zone_id),
    INDEX idx_status (status),
    INDEX idx_zone (zone_id),
    INDEX idx_active (active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

**Campos:**
- `number`: Table identifier number (visible to users)
- `zone_id`: Zone to which the table belongs
- `capacity`: Number of people it can accommodate (default: 5)
- `position_x`, `position_y`: Coordinates in the room layout
- `status`: Current table status
- `main_table_id`: If joined, reference to main table
- `active`: Indicates if table is active in the system

---

### 2.5 Tabla: CUSTOMERS

```sql
CREATE TABLE customers (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    registered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    active BOOLEAN DEFAULT TRUE,
    INDEX idx_email (email),
    INDEX idx_phone (phone)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

**Nota:** Anonymous customers are NOT registered in this table. Only customers who create an account are registered.

---

### 2.6 Tabla: RESERVATIONS

```sql
CREATE TABLE reservations (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    customer_id CHAR(36) NULL,
    party_size INT NOT NULL,
    date DATE NOT NULL,
    time TIME NOT NULL,
    status ENUM('PENDING', 'CONFIRMED', 'CANCELLED', 'COMPLETED') DEFAULT 'PENDING',
    type ENUM('ONLINE', 'ASSISTED') NOT NULL,
    reference_name VARCHAR(100) NULL,
    phone VARCHAR(20) NULL,
    notes TEXT,
    created_by CHAR(36) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(id),
    FOREIGN KEY (created_by) REFERENCES users(id),
    INDEX idx_date_time (date, time),
    INDEX idx_status (status),
    INDEX idx_type (type),
    INDEX idx_customer (customer_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

**Campos:**
- `customer_id`: NULL for assisted reservations (anonymous customers)
- `type`: 'ONLINE' for registered customers, 'ASSISTED' for anonymous
- `reference_name`: Anonymous customer name (only for ASSISTED type)
- `phone`: Anonymous customer phone (optional)
- `created_by`: User who created the reservation (Superuser for assisted)

---

### 2.7 Tabla: RESERVATION_TABLES

```sql
CREATE TABLE reservation_tables (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    reservation_id CHAR(36) NOT NULL,
    table_id CHAR(36) NOT NULL,
    is_main BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (reservation_id) REFERENCES reservations(id) ON DELETE CASCADE,
    FOREIGN KEY (table_id) REFERENCES tables(id),
    UNIQUE KEY uk_reservation_table (reservation_id, table_id),
    INDEX idx_reservation (reservation_id),
    INDEX idx_table (table_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

**N:M relationship between Reservations and Tables**

---

### 2.8 Tabla: ORDERS

```sql
CREATE TABLE orders (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    table_id CHAR(36) NOT NULL,
    waiter_id CHAR(36) NOT NULL,
    reservation_id CHAR(36) NULL,
    opened_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    closed_at TIMESTAMP NULL,
    status ENUM('OPEN', 'IN_PROGRESS', 'SERVED', 'PAID', 'CLOSED') DEFAULT 'OPEN',
    subtotal DECIMAL(10,2) DEFAULT 0.00,
    tip DECIMAL(10,2) DEFAULT 0.00,
    total DECIMAL(10,2) DEFAULT 0.00,
    FOREIGN KEY (table_id) REFERENCES tables(id),
    FOREIGN KEY (waiter_id) REFERENCES users(id),
    FOREIGN KEY (reservation_id) REFERENCES reservations(id),
    INDEX idx_table (table_id),
    INDEX idx_waiter (waiter_id),
    INDEX idx_status (status),
    INDEX idx_opened_at (opened_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

**Business rule:** A table can only have ONE active order (status != 'CLOSED')

---

### 2.9 Tabla: CATEGORIES

```sql
CREATE TABLE categories (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    type ENUM('FOOD', 'BEVERAGE') NOT NULL,
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_name (name),
    INDEX idx_type (type),
    INDEX idx_active (active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

---

### 2.10 Tabla: PRODUCTS

```sql
CREATE TABLE products (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    name VARCHAR(100) NOT NULL,
    description TEXT,
    category_id CHAR(36) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    type ENUM('FOOD', 'BEVERAGE') NOT NULL,
    available BOOLEAN DEFAULT TRUE,
    image_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id),
    INDEX idx_name (name),
    INDEX idx_category (category_id),
    INDEX idx_type (type),
    INDEX idx_available (available)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

---

### 2.11 Tabla: ORDER_ITEMS

```sql
CREATE TABLE order_items (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    order_id CHAR(36) NOT NULL,
    product_id CHAR(36) NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    unit_price DECIMAL(10,2) NOT NULL,
    notes TEXT,
    type ENUM('FOOD', 'BEVERAGE') NOT NULL,
    status ENUM('PENDING', 'IN_KITCHEN', 'READY', 'SERVED') DEFAULT 'PENDING',
    ordered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    served_at TIMESTAMP NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id),
    INDEX idx_order (order_id),
    INDEX idx_product (product_id),
    INDEX idx_type (type),
    INDEX idx_status (status),
    INDEX idx_ordered_at (ordered_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

**Campos:**
- `type`: Copied from product at order time
- `status`: Status flow according to type
- `unit_price`: Price frozen at order time

---

### 2.12 Tabla: PAYMENTS

```sql
CREATE TABLE payments (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    order_id CHAR(36) NOT NULL,
    cashier_id CHAR(36) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_method ENUM('CASH', 'DEBIT_CARD', 'CREDIT_CARD', 'TRANSFER', 'QR') NOT NULL,
    paid_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('PENDING', 'APPROVED', 'REJECTED') DEFAULT 'APPROVED',
    reference VARCHAR(100),
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (cashier_id) REFERENCES users(id),
    INDEX idx_order (order_id),
    INDEX idx_cashier (cashier_id),
    INDEX idx_paid_at (paid_at),
    INDEX idx_method (payment_method)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

---

### 2.13 Tabla: AUDIT_LOG

```sql
CREATE TABLE audit_log (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    user_id CHAR(36) NULL,
    event_type VARCHAR(100) NOT NULL,
    entity_type VARCHAR(100) NOT NULL,
    entity_id CHAR(36) NOT NULL,
    old_data JSON,
    new_data JSON,
    ip_address VARCHAR(45),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    INDEX idx_user (user_id),
    INDEX idx_event_type (event_type),
    INDEX idx_entity (entity_type, entity_id),
    INDEX idx_timestamp (timestamp)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

**Audited events:**
- `USER_CREATED`, `USER_UPDATED`, `USER_DELETED`
- `TABLE_CREATED`, `TABLE_UPDATED`, `TABLE_JOINED`, `TABLE_SEPARATED`
- `RESERVATION_CREATED`, `RESERVATION_UPDATED`, `RESERVATION_CANCELLED`
- `ORDER_OPENED`, `ORDER_UPDATED`, `ORDER_CLOSED`
- `ITEM_CREATED`, `ITEM_UPDATED`, `ITEM_SERVED`
- `PAYMENT_PROCESSED`
- `PRODUCT_CREATED`, `PRODUCT_UPDATED`, `PRODUCT_DELETED`

---

### 2.14 Tabla: TABLE_JOINS

```sql
CREATE TABLE table_joins (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    main_table_id CHAR(36) NOT NULL,
    reservation_id CHAR(36) NULL,
    order_id CHAR(36) NULL,
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    separated_at TIMESTAMP NULL,
    active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (main_table_id) REFERENCES tables(id),
    FOREIGN KEY (reservation_id) REFERENCES reservations(id),
    FOREIGN KEY (order_id) REFERENCES orders(id),
    INDEX idx_main_table (main_table_id),
    INDEX idx_active (active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

**Control table for temporary table joins**

---

### 2.15 Tabla: SYSTEM_CONFIG

```sql
CREATE TABLE system_config (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    config_key VARCHAR(100) NOT NULL UNIQUE,
    config_value TEXT NOT NULL,
    description TEXT,
    data_type ENUM('STRING', 'INTEGER', 'DECIMAL', 'BOOLEAN', 'JSON') DEFAULT 'STRING',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_key (config_key)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

**System configurations:**
```sql
INSERT INTO system_config (config_key, config_value, description, data_type) VALUES
('STANDARD_TABLE_CAPACITY', '5', 'Standard capacity of each table', 'INTEGER'),
('MAX_JOIN_DISTANCE', '8.0', 'Maximum distance in meters to join tables', 'DECIMAL'),
('RESERVATION_DURATION_HOURS', '2', 'Estimated duration of a reservation in hours', 'INTEGER'),
('KITCHEN_ALERT_TIME', '15', 'Minutes to alert urgent order in kitchen', 'INTEGER'),
('SUGGESTED_TIP_PERCENTAGE', '10', 'Suggested tip percentage', 'INTEGER');
```

---

## 3. VISTAS ÚTILES

### 3.1 Vista: Available Tables

```sql
CREATE VIEW v_available_tables AS
SELECT 
    t.id,
    t.number,
    z.name AS zone_name,
    t.capacity,
    t.position_x,
    t.position_y,
    t.status
FROM tables t
INNER JOIN zones z ON t.zone_id = z.id
WHERE t.active = TRUE 
  AND t.status = 'AVAILABLE';
```

### 3.2 Vista: Active Orders

```sql
CREATE VIEW v_active_orders AS
SELECT 
    o.id,
    o.table_id,
    t.number AS table_number,
    z.name AS zone_name,
    u.name AS waiter_name,
    o.opened_at,
    o.status,
    o.total,
    COUNT(oi.id) AS item_count
FROM orders o
INNER JOIN tables t ON o.table_id = t.id
INNER JOIN zones z ON t.zone_id = z.id
INNER JOIN users u ON o.waiter_id = u.id
LEFT JOIN order_items oi ON o.id = oi.order_id
WHERE o.status != 'CLOSED'
GROUP BY o.id, o.table_id, t.number, z.name, u.name, o.opened_at, o.status, o.total;
```

### 3.3 Vista: Kitchen Queue

```sql
CREATE VIEW v_kitchen_queue AS
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
FROM order_items oi
INNER JOIN products p ON oi.product_id = p.id
INNER JOIN orders o ON oi.order_id = o.id
INNER JOIN tables t ON o.table_id = t.id
WHERE oi.type = 'FOOD'
  AND oi.status IN ('PENDING', 'IN_KITCHEN')
ORDER BY oi.ordered_at ASC;
```

### 3.4 Vista: Today's Reservations

```sql
CREATE VIEW v_today_reservations AS
SELECT 
    r.id,
    COALESCE(c.name, r.reference_name) AS customer_name,
    r.party_size,
    r.time,
    r.status,
    r.type,
    GROUP_CONCAT(t.number ORDER BY t.number SEPARATOR ', ') AS table_numbers
FROM reservations r
LEFT JOIN customers c ON r.customer_id = c.id
INNER JOIN reservation_tables rt ON r.id = rt.reservation_id
INNER JOIN tables t ON rt.table_id = t.id
WHERE r.date = CURDATE()
  AND r.status IN ('PENDING', 'CONFIRMED')
GROUP BY r.id, customer_name, r.party_size, r.time, r.status, r.type
ORDER BY r.time ASC;
```

---

## 4. TRIGGERS

### 4.1 Trigger: Update Order Total

```sql
DELIMITER //

CREATE TRIGGER trg_update_order_total
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
    UPDATE orders
    SET subtotal = (
        SELECT SUM(quantity * unit_price)
        FROM order_items
        WHERE order_id = NEW.order_id
    ),
    total = subtotal + tip
    WHERE id = NEW.order_id;
END//

DELIMITER ;
```

### 4.2 Trigger: Audit User Changes

```sql
DELIMITER //

CREATE TRIGGER trg_audit_user_update
AFTER UPDATE ON users
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (
        user_id,
        event_type,
        entity_type,
        entity_id,
        old_data,
        new_data
    ) VALUES (
        NEW.id,
        'USER_UPDATED',
        'users',
        NEW.id,
        JSON_OBJECT(
            'name', OLD.name,
            'email', OLD.email,
            'role_id', OLD.role_id,
            'active', OLD.active
        ),
        JSON_OBJECT(
            'name', NEW.name,
            'email', NEW.email,
            'role_id', NEW.role_id,
            'active', NEW.active
        )
    );
END//

DELIMITER ;
```

### 4.3 Trigger: Validate Single Active Order

```sql
DELIMITER //

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
END//

DELIMITER ;
```

---

## 5. STORED PROCEDURES

### 5.1 Procedure: Open Table

```sql
DELIMITER //

CREATE PROCEDURE sp_open_table(
    IN p_table_id CHAR(36),
    IN p_waiter_id CHAR(36),
    IN p_reservation_id CHAR(36)
)
BEGIN
    DECLARE v_order_id CHAR(36);
    
    -- Validate table is available
    IF (SELECT status FROM tables WHERE id = p_table_id) != 'AVAILABLE' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Table is not available';
    END IF;
    
    -- Create order
    SET v_order_id = UUID();
    INSERT INTO orders (id, table_id, waiter_id, reservation_id)
    VALUES (v_order_id, p_table_id, p_waiter_id, p_reservation_id);
    
    -- Update table status
    UPDATE tables SET status = 'OCCUPIED' WHERE id = p_table_id;
    
    -- Audit
    INSERT INTO audit_log (event_type, entity_type, entity_id)
    VALUES ('ORDER_OPENED', 'orders', v_order_id);
    
    SELECT v_order_id AS order_id;
END//

DELIMITER ;
```

### 5.2 Procedure: Close Order

```sql
DELIMITER //

CREATE PROCEDURE sp_close_order(
    IN p_order_id CHAR(36)
)
BEGIN
    DECLARE v_table_id CHAR(36);
    DECLARE v_main_table_id CHAR(36);
    
    -- Validate all items are served
    IF EXISTS (
        SELECT 1 FROM order_items
        WHERE order_id = p_order_id
          AND status != 'SERVED'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'There are pending items to serve';
    END IF;
    
    -- Get table
    SELECT table_id INTO v_table_id
    FROM orders
    WHERE id = p_order_id;
    
    -- Close order
    UPDATE orders
    SET status = 'CLOSED',
        closed_at = NOW()
    WHERE id = p_order_id;
    
    -- Release table
    UPDATE tables SET status = 'AVAILABLE' WHERE id = v_table_id;
    
    -- If it was a joined table, separate
    SELECT main_table_id INTO v_main_table_id
    FROM tables
    WHERE id = v_table_id;
    
    IF v_main_table_id IS NOT NULL THEN
        CALL sp_separate_tables(v_main_table_id);
    END IF;
    
    -- Audit
    INSERT INTO audit_log (event_type, entity_type, entity_id)
    VALUES ('ORDER_CLOSED', 'orders', p_order_id);
END//

DELIMITER ;
```

### 5.3 Procedure: Join Tables

```sql
DELIMITER //

CREATE PROCEDURE sp_join_tables(
    IN p_main_table_id CHAR(36),
    IN p_table_ids JSON,
    IN p_reservation_id CHAR(36)
)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE v_table_id CHAR(36);
    DECLARE v_join_id CHAR(36);
    
    -- Create join record
    SET v_join_id = UUID();
    INSERT INTO table_joins (id, main_table_id, reservation_id)
    VALUES (v_join_id, p_main_table_id, p_reservation_id);
    
    -- Mark main table as OCCUPIED
    UPDATE tables
    SET status = 'OCCUPIED'
    WHERE id = p_main_table_id;
    
    -- Mark other tables as JOINED
    WHILE i < JSON_LENGTH(p_table_ids) DO
        SET v_table_id = JSON_UNQUOTE(JSON_EXTRACT(p_table_ids, CONCAT('$[', i, ']')));
        
        IF v_table_id != p_main_table_id THEN
            UPDATE tables
            SET status = 'JOINED',
                main_table_id = p_main_table_id
            WHERE id = v_table_id;
        END IF;
        
        SET i = i + 1;
    END WHILE;
    
    -- Audit
    INSERT INTO audit_log (event_type, entity_type, entity_id)
    VALUES ('TABLES_JOINED', 'table_joins', v_join_id);
END//

DELIMITER ;
```

### 5.4 Procedure: Separate Tables

```sql
DELIMITER //

CREATE PROCEDURE sp_separate_tables(
    IN p_main_table_id CHAR(36)
)
BEGIN
    -- Release main table
    UPDATE tables
    SET status = 'AVAILABLE'
    WHERE id = p_main_table_id;
    
    -- Release joined tables
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
    
    -- Audit
    INSERT INTO audit_log (event_type, entity_type, entity_id)
    VALUES ('TABLES_SEPARATED', 'tables', p_main_table_id);
END//

DELIMITER ;
```

---

## 6. ÍNDICES ADICIONALES PARA OPTIMIZACIÓN

```sql
-- Composite index for available tables search
CREATE INDEX idx_tables_availability ON tables(status, zone_id, active);

-- Composite index for reservations by date
CREATE INDEX idx_reservations_date_status ON reservations(date, time, status);

-- Composite index for active orders by waiter
CREATE INDEX idx_orders_waiter_status ON orders(waiter_id, status);

-- Composite index for order items by type and status
CREATE INDEX idx_items_type_status ON order_items(type, status, ordered_at);

-- Index for audit by date
CREATE INDEX idx_audit_date ON audit_log(timestamp DESC);
```

---

## 7. SCRIPT DE INICIALIZACIÓN COMPLETO

```sql
-- ============================================
-- DATABASE INITIALIZATION SCRIPT
-- VARES POS System
-- ============================================

-- Create database
CREATE DATABASE IF NOT EXISTS vares_pos
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE vares_pos;

-- [All tables in dependency order]
-- [Then triggers]
-- [Then stored procedures]
-- [Then views]
-- [Then initial data]

-- Initial role data
INSERT INTO roles (name, description) VALUES
('SUPERUSER', 'General administrator with full system control'),
('WAITER', 'Service staff who take orders and manage tables'),
('COOK', 'Kitchen staff who process food orders'),
('CASHIER', 'Staff who process payments and close orders');

-- Initial zone data
INSERT INTO zones (name, description) VALUES
('Main Hall', 'Main restaurant area'),
('Bar', 'Bar area with stools'),
('Patio', 'Outdoor area with tables'),
('VIP', 'Reserved area for special guests');

-- System configuration
INSERT INTO system_config (config_key, config_value, description, data_type) VALUES
('STANDARD_TABLE_CAPACITY', '5', 'Standard capacity of each table', 'INTEGER'),
('MAX_JOIN_DISTANCE', '8.0', 'Maximum distance in meters to join tables', 'DECIMAL'),
('RESERVATION_DURATION_HOURS', '2', 'Estimated duration of a reservation in hours', 'INTEGER'),
('KITCHEN_ALERT_TIME', '15', 'Minutes to alert urgent order in kitchen', 'INTEGER'),
('SUGGESTED_TIP_PERCENTAGE', '10', 'Suggested tip percentage', 'INTEGER');

-- Initial superuser (password: admin123)
INSERT INTO users (name, email, password_hash, role_id)
SELECT 'Administrator', 'admin@vares.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', id
FROM roles WHERE name = 'SUPERUSER';

COMMIT;
```

---

## 8. NOMENCLATURA Y CONVENCIONES

### 8.1 Nombres de Tablas
- **Formato:** snake_case, plural
- **Ejemplos:** `users`, `orders`, `order_items`, `reservation_tables`

### 8.2 Nombres de Columnas
- **Formato:** snake_case
- **IDs:** Siempre `id` para clave primaria, `{tabla}_id` para foreign keys
- **Timestamps:** `created_at`, `updated_at`, `deleted_at`
- **Booleanos:** `is_active`, `is_main`, `available`

### 8.3 Nombres de Índices
- **Formato:** `idx_{tabla}_{columnas}`
- **Ejemplos:** `idx_users_email`, `idx_orders_waiter_status`

### 8.4 Nombres de Foreign Keys
- **Formato:** `fk_{tabla_origen}_{tabla_destino}`
- **Ejemplos:** `fk_orders_users`, `fk_order_items_products`

### 8.5 Nombres de Triggers
- **Formato:** `trg_{accion}_{tabla}_{evento}`
- **Ejemplos:** `trg_update_order_total`, `trg_audit_user_update`

### 8.6 Nombres de Stored Procedures
- **Formato:** `sp_{accion}_{entidad}`
- **Ejemplos:** `sp_open_table`, `sp_close_order`, `sp_join_tables`

### 8.7 Nombres de Vistas
- **Formato:** `v_{descripcion}`
- **Ejemplos:** `v_available_tables`, `v_active_orders`, `v_kitchen_queue`

---

**Documento creado por:** Sistema VARES  
**Versión:** 2.0 (English Database Schema)  
**Fecha:** 2026-01-03  
**Última actualización:** 2026-01-05
