-- ============================================
-- VARES POS - INITIAL DATA (GRID-BASED)
-- ============================================

USE vares_pos;

-- 1. INSERT ROLES
INSERT INTO
    roles (id, name, description)
VALUES (
        UUID(),
        'SUPERUSER',
        'General administrator with full system control'
    ),
    (
        UUID(),
        'WAITER',
        'Service staff who take orders and manage tables'
    ),
    (
        UUID(),
        'COOK',
        'Kitchen staff who process food orders'
    ),
    (
        UUID(),
        'CASHIER',
        'Staff who process payments and close orders'
    );

-- 2. INSERT DEFAULT SUPERUSER
INSERT INTO
    users (
        id,
        name,
        email,
        password_hash,
        role_id,
        active
    )
VALUES (
        UUID(),
        'Administrator',
        'admin@vares.com',
        '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
        (
            SELECT id
            FROM roles
            WHERE
                name = 'SUPERUSER'
        ),
        TRUE
    );

-- 3. INSERT ZONES
INSERT INTO
    zones (id, name, description, active)
VALUES (
        'zone-main-hall',
        'Main Hall',
        'Main restaurant area with central tables',
        TRUE
    ),
    (
        'zone-bar',
        'Bar',
        'Bar area with high stools and counter',
        TRUE
    ),
    (
        'zone-patio',
        'Patio',
        'Outdoor area with garden view',
        TRUE
    ),
    (
        'zone-vip',
        'VIP',
        'Reserved area for special guests and events',
        TRUE
    );

-- 4. INSERT SAMPLE TABLES & GRID
-- We use fixed IDs for initial layout cells for easier mapping
-- Main Hall
INSERT INTO
    tables (
        id,
        number,
        zone_id,
        capacity,
        status
    )
VALUES (
        'table-1',
        1,
        'zone-main-hall',
        4,
        'AVAILABLE'
    ),
    (
        'table-2',
        2,
        'zone-main-hall',
        4,
        'AVAILABLE'
    ),
    (
        'table-3',
        3,
        'zone-main-hall',
        4,
        'AVAILABLE'
    ),
    (
        'table-4',
        4,
        'zone-main-hall',
        4,
        'AVAILABLE'
    );

-- Setup Grid for Main Hall (0-9 row, 0-9 col)
INSERT INTO
    layout_cells (
        id,
        zone_id,
        grid_row,
        grid_col,
        cell_type,
        table_id
    )
VALUES (
        UUID(),
        'zone-main-hall',
        1,
        1,
        'TABLE',
        'table-1'
    ),
    (
        UUID(),
        'zone-main-hall',
        1,
        3,
        'TABLE',
        'table-2'
    ),
    (
        UUID(),
        'zone-main-hall',
        3,
        1,
        'TABLE',
        'table-3'
    ),
    (
        UUID(),
        'zone-main-hall',
        3,
        3,
        'TABLE',
        'table-4'
    ),
    -- Add some fixed elements
    (
        UUID(),
        'zone-main-hall',
        0,
        0,
        'KITCHEN',
        NULL
    ),
    (
        UUID(),
        'zone-main-hall',
        0,
        1,
        'KITCHEN',
        NULL
    ),
    (
        UUID(),
        'zone-main-hall',
        0,
        2,
        'KITCHEN',
        NULL
    ),
    (
        UUID(),
        'zone-main-hall',
        5,
        5,
        'COLUMN',
        NULL
    ),
    (
        UUID(),
        'zone-main-hall',
        9,
        0,
        'RESTROOM',
        NULL
    );

-- 5. CATEGORIES
INSERT INTO
    categories (
        id,
        name,
        description,
        type,
        active
    )
VALUES (
        UUID(),
        'Appetizers',
        'Starters and small plates',
        'FOOD',
        TRUE
    ),
    (
        UUID(),
        'Main Courses',
        'Main dishes and entrees',
        'FOOD',
        TRUE
    ),
    (
        UUID(),
        'Desserts',
        'Sweet treats and desserts',
        'FOOD',
        TRUE
    ),
    (
        UUID(),
        'Beers',
        'Draft and bottled beers',
        'BEVERAGE',
        TRUE
    );

-- 6. PRODUCTS (Simplified for now)
INSERT INTO
    products (
        id,
        name,
        description,
        category_id,
        price,
        type,
        available
    )
VALUES (
        UUID(),
        'Empanadas',
        'Tradicional',
        (
            SELECT id
            FROM categories
            WHERE
                name = 'Appetizers'
        ),
        1200,
        'FOOD',
        TRUE
    ),
    (
        UUID(),
        'Classic Burger',
        'Beef patty',
        (
            SELECT id
            FROM categories
            WHERE
                name = 'Main Courses'
        ),
        2400,
        'FOOD',
        TRUE
    );

-- 7. SYSTEM CONFIG
INSERT INTO
    system_config (
        id,
        config_key,
        config_value,
        description,
        data_type
    )
VALUES (
        UUID(),
        'STANDARD_TABLE_CAPACITY',
        '4',
        'Standard capacity of each table',
        'INTEGER'
    ),
    (
        UUID(),
        'MAX_GRID_ROWS',
        '20',
        'Max rows in layout',
        'INTEGER'
    ),
    (
        UUID(),
        'MAX_GRID_COLS',
        '20',
        'Max columns in layout',
        'INTEGER'
    );