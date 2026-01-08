-- ============================================
-- VARES POS - DATABASE SCHEMA
-- MySQL 8.0
-- ============================================

USE vares_pos;

-- Disable foreign key checks for clean drop
SET FOREIGN_KEY_CHECKS = 0;

-- Drop tables if exist (for clean installation)
DROP TABLE IF EXISTS audit_log;

DROP TABLE IF EXISTS payments;

DROP TABLE IF EXISTS order_items;

DROP TABLE IF EXISTS orders;

DROP TABLE IF EXISTS products;

DROP TABLE IF EXISTS categories;

DROP TABLE IF EXISTS reservation_tables;

DROP TABLE IF EXISTS reservations;

DROP TABLE IF EXISTS customers;

DROP TABLE IF EXISTS table_joins;

DROP TABLE IF EXISTS tables;

DROP TABLE IF EXISTS zones;

DROP TABLE IF EXISTS users;

DROP TABLE IF EXISTS roles;

DROP TABLE IF EXISTS system_config;

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

-- ============================================
-- 1. ROLES TABLE
-- ============================================
CREATE TABLE roles (
    id CHAR(36) PRIMARY KEY DEFAULT(UUID()),
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_name (name)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- ============================================
-- 2. USERS TABLE
-- ============================================
CREATE TABLE users (
    id CHAR(36) PRIMARY KEY DEFAULT(UUID()),
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role_id CHAR(36) NOT NULL,
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES roles (id),
    INDEX idx_email (email),
    INDEX idx_role (role_id),
    INDEX idx_active (active)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- ============================================
-- 3. ZONES TABLE
-- ============================================
CREATE TABLE zones (
    id CHAR(36) PRIMARY KEY DEFAULT(UUID()),
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_name (name),
    INDEX idx_active (active)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- ============================================
-- 4. TABLES
-- ============================================
CREATE TABLE tables (
    id CHAR(36) PRIMARY KEY DEFAULT(UUID()),
    number INT NOT NULL,
    zone_id CHAR(36) NOT NULL,
    capacity INT DEFAULT 5,
    position_x DECIMAL(10, 2) NOT NULL,
    position_y DECIMAL(10, 2) NOT NULL,
    status ENUM(
        'AVAILABLE',
        'RESERVED',
        'OCCUPIED',
        'JOINED'
    ) DEFAULT 'AVAILABLE',
    main_table_id CHAR(36) NULL,
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (zone_id) REFERENCES zones (id),
    FOREIGN KEY (main_table_id) REFERENCES tables (id),
    UNIQUE KEY uk_number_zone (number, zone_id),
    INDEX idx_status (status),
    INDEX idx_zone (zone_id),
    INDEX idx_active (active)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- ============================================
-- 5. CUSTOMERS TABLE
-- ============================================
CREATE TABLE customers (
    id CHAR(36) PRIMARY KEY DEFAULT(UUID()),
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    password_hash VARCHAR(255),
    registered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    active BOOLEAN DEFAULT TRUE,
    INDEX idx_email (email),
    INDEX idx_phone (phone)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- ============================================
-- 6. RESERVATIONS TABLE
-- ============================================
CREATE TABLE reservations (
    id CHAR(36) PRIMARY KEY DEFAULT(UUID()),
    customer_id CHAR(36) NULL,
    party_size INT NOT NULL,
    date DATE NOT NULL,
    time TIME NOT NULL,
    status ENUM(
        'PENDING',
        'CONFIRMED',
        'CANCELLED',
        'COMPLETED'
    ) DEFAULT 'PENDING',
    type ENUM('ONLINE', 'ASSISTED') NOT NULL,
    reference_name VARCHAR(100) NULL,
    phone VARCHAR(20) NULL,
    notes TEXT,
    created_by CHAR(36) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers (id),
    FOREIGN KEY (created_by) REFERENCES users (id),
    INDEX idx_date_time (date, time),
    INDEX idx_status (status),
    INDEX idx_type (type),
    INDEX idx_customer (customer_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- ============================================
-- 7. RESERVATION_TABLES (N:M relationship)
-- ============================================
CREATE TABLE reservation_tables (
    id CHAR(36) PRIMARY KEY DEFAULT(UUID()),
    reservation_id CHAR(36) NOT NULL,
    table_id CHAR(36) NOT NULL,
    is_main BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (reservation_id) REFERENCES reservations (id) ON DELETE CASCADE,
    FOREIGN KEY (table_id) REFERENCES tables (id),
    UNIQUE KEY uk_reservation_table (reservation_id, table_id),
    INDEX idx_reservation (reservation_id),
    INDEX idx_table (table_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- ============================================
-- 8. CATEGORIES TABLE
-- ============================================
CREATE TABLE categories (
    id CHAR(36) PRIMARY KEY DEFAULT(UUID()),
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    type ENUM('FOOD', 'BEVERAGE') NOT NULL,
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_name (name),
    INDEX idx_type (type),
    INDEX idx_active (active)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- ============================================
-- 9. PRODUCTS TABLE
-- ============================================
CREATE TABLE products (
    id CHAR(36) PRIMARY KEY DEFAULT(UUID()),
    name VARCHAR(100) NOT NULL,
    description TEXT,
    category_id CHAR(36) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    type ENUM('FOOD', 'BEVERAGE') NOT NULL,
    available BOOLEAN DEFAULT TRUE,
    image_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories (id),
    INDEX idx_name (name),
    INDEX idx_category (category_id),
    INDEX idx_type (type),
    INDEX idx_available (available)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- ============================================
-- 10. ORDERS TABLE
-- ============================================
CREATE TABLE orders (
    id CHAR(36) PRIMARY KEY DEFAULT(UUID()),
    table_id CHAR(36) NOT NULL,
    waiter_id CHAR(36) NOT NULL,
    reservation_id CHAR(36) NULL,
    opened_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    closed_at TIMESTAMP NULL,
    status ENUM(
        'OPEN',
        'IN_PROGRESS',
        'SERVED',
        'PAID',
        'CLOSED'
    ) DEFAULT 'OPEN',
    subtotal DECIMAL(10, 2) DEFAULT 0.00,
    tip DECIMAL(10, 2) DEFAULT 0.00,
    total DECIMAL(10, 2) DEFAULT 0.00,
    FOREIGN KEY (table_id) REFERENCES tables (id),
    FOREIGN KEY (waiter_id) REFERENCES users (id),
    FOREIGN KEY (reservation_id) REFERENCES reservations (id),
    INDEX idx_table (table_id),
    INDEX idx_waiter (waiter_id),
    INDEX idx_status (status),
    INDEX idx_opened_at (opened_at)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- ============================================
-- 11. ORDER_ITEMS TABLE
-- ============================================
CREATE TABLE order_items (
    id CHAR(36) PRIMARY KEY DEFAULT(UUID()),
    order_id CHAR(36) NOT NULL,
    product_id CHAR(36) NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    unit_price DECIMAL(10, 2) NOT NULL,
    notes TEXT,
    type ENUM('FOOD', 'BEVERAGE') NOT NULL,
    status ENUM(
        'PENDING',
        'IN_KITCHEN',
        'READY',
        'SERVED'
    ) DEFAULT 'PENDING',
    ordered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    served_at TIMESTAMP NULL,
    FOREIGN KEY (order_id) REFERENCES orders (id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products (id),
    INDEX idx_order (order_id),
    INDEX idx_product (product_id),
    INDEX idx_type (type),
    INDEX idx_status (status),
    INDEX idx_ordered_at (ordered_at)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- ============================================
-- 12. PAYMENTS TABLE
-- ============================================
CREATE TABLE payments (
    id CHAR(36) PRIMARY KEY DEFAULT(UUID()),
    order_id CHAR(36) NOT NULL,
    cashier_id CHAR(36) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_method ENUM(
        'CASH',
        'DEBIT_CARD',
        'CREDIT_CARD',
        'TRANSFER',
        'QR'
    ) NOT NULL,
    paid_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM(
        'PENDING',
        'APPROVED',
        'REJECTED'
    ) DEFAULT 'APPROVED',
    reference VARCHAR(100),
    FOREIGN KEY (order_id) REFERENCES orders (id),
    FOREIGN KEY (cashier_id) REFERENCES users (id),
    INDEX idx_order (order_id),
    INDEX idx_cashier (cashier_id),
    INDEX idx_paid_at (paid_at),
    INDEX idx_method (payment_method)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- ============================================
-- 13. TABLE_JOINS TABLE
-- ============================================
CREATE TABLE table_joins (
    id CHAR(36) PRIMARY KEY DEFAULT(UUID()),
    main_table_id CHAR(36) NOT NULL,
    reservation_id CHAR(36) NULL,
    order_id CHAR(36) NULL,
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    separated_at TIMESTAMP NULL,
    active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (main_table_id) REFERENCES tables (id),
    FOREIGN KEY (reservation_id) REFERENCES reservations (id),
    FOREIGN KEY (order_id) REFERENCES orders (id),
    INDEX idx_main_table (main_table_id),
    INDEX idx_active (active)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- ============================================
-- 14. AUDIT_LOG TABLE
-- ============================================
CREATE TABLE audit_log (
    id CHAR(36) PRIMARY KEY DEFAULT(UUID()),
    user_id CHAR(36) NULL,
    event_type VARCHAR(100) NOT NULL,
    entity_type VARCHAR(100) NOT NULL,
    entity_id CHAR(36) NOT NULL,
    old_data JSON,
    new_data JSON,
    ip_address VARCHAR(45),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (id),
    INDEX idx_user (user_id),
    INDEX idx_event_type (event_type),
    INDEX idx_entity (entity_type, entity_id),
    INDEX idx_timestamp (timestamp)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- ============================================
-- 15. SYSTEM_CONFIG TABLE
-- ============================================
CREATE TABLE system_config (
    id CHAR(36) PRIMARY KEY DEFAULT(UUID()),
    config_key VARCHAR(100) NOT NULL UNIQUE,
    config_value TEXT NOT NULL,
    description TEXT,
    data_type ENUM(
        'STRING',
        'INTEGER',
        'DECIMAL',
        'BOOLEAN',
        'JSON'
    ) DEFAULT 'STRING',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_key (config_key)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;