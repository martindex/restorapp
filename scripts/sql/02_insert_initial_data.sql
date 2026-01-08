-- ============================================
-- VARES POS - INITIAL DATA
-- ============================================

USE vares_pos;

-- ============================================
-- 1. INSERT ROLES
-- ============================================
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

-- ============================================
-- 2. INSERT DEFAULT SUPERUSER
-- Password: admin123 (hashed with BCrypt)
-- ============================================
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

-- ============================================
-- 3. INSERT ZONES
-- ============================================
INSERT INTO
    zones (id, name, description, active)
VALUES (
        UUID(),
        'Main Hall',
        'Main restaurant area with central tables',
        TRUE
    ),
    (
        UUID(),
        'Bar',
        'Bar area with high stools and counter',
        TRUE
    ),
    (
        UUID(),
        'Patio',
        'Outdoor area with garden view',
        TRUE
    ),
    (
        UUID(),
        'VIP',
        'Reserved area for special guests and events',
        TRUE
    );

-- ============================================
-- 4. INSERT SAMPLE TABLES
-- ============================================
-- Main Hall Tables (15 tables)
INSERT INTO
    tables (
        id,
        number,
        zone_id,
        capacity,
        position_x,
        position_y,
        status,
        active
    )
VALUES (
        UUID(),
        1,
        (
            SELECT id
            FROM zones
            WHERE
                name = 'Main Hall'
        ),
        5,
        2.0,
        2.0,
        'AVAILABLE',
        TRUE
    ),
    (
        UUID(),
        2,
        (
            SELECT id
            FROM zones
            WHERE
                name = 'Main Hall'
        ),
        5,
        6.0,
        2.0,
        'AVAILABLE',
        TRUE
    ),
    (
        UUID(),
        3,
        (
            SELECT id
            FROM zones
            WHERE
                name = 'Main Hall'
        ),
        5,
        10.0,
        2.0,
        'AVAILABLE',
        TRUE
    ),
    (
        UUID(),
        4,
        (
            SELECT id
            FROM zones
            WHERE
                name = 'Main Hall'
        ),
        5,
        14.0,
        2.0,
        'AVAILABLE',
        TRUE
    ),
    (
        UUID(),
        5,
        (
            SELECT id
            FROM zones
            WHERE
                name = 'Main Hall'
        ),
        5,
        18.0,
        2.0,
        'AVAILABLE',
        TRUE
    ),
    (
        UUID(),
        6,
        (
            SELECT id
            FROM zones
            WHERE
                name = 'Main Hall'
        ),
        5,
        2.0,
        6.0,
        'AVAILABLE',
        TRUE
    ),
    (
        UUID(),
        7,
        (
            SELECT id
            FROM zones
            WHERE
                name = 'Main Hall'
        ),
        5,
        6.0,
        6.0,
        'AVAILABLE',
        TRUE
    ),
    (
        UUID(),
        8,
        (
            SELECT id
            FROM zones
            WHERE
                name = 'Main Hall'
        ),
        5,
        10.0,
        6.0,
        'AVAILABLE',
        TRUE
    ),
    (
        UUID(),
        9,
        (
            SELECT id
            FROM zones
            WHERE
                name = 'Main Hall'
        ),
        5,
        14.0,
        6.0,
        'AVAILABLE',
        TRUE
    ),
    (
        UUID(),
        10,
        (
            SELECT id
            FROM zones
            WHERE
                name = 'Main Hall'
        ),
        5,
        18.0,
        6.0,
        'AVAILABLE',
        TRUE
    ),
    (
        UUID(),
        11,
        (
            SELECT id
            FROM zones
            WHERE
                name = 'Main Hall'
        ),
        5,
        2.0,
        10.0,
        'AVAILABLE',
        TRUE
    ),
    (
        UUID(),
        12,
        (
            SELECT id
            FROM zones
            WHERE
                name = 'Main Hall'
        ),
        5,
        6.0,
        10.0,
        'AVAILABLE',
        TRUE
    ),
    (
        UUID(),
        13,
        (
            SELECT id
            FROM zones
            WHERE
                name = 'Main Hall'
        ),
        5,
        10.0,
        10.0,
        'AVAILABLE',
        TRUE
    ),
    (
        UUID(),
        14,
        (
            SELECT id
            FROM zones
            WHERE
                name = 'Main Hall'
        ),
        5,
        14.0,
        10.0,
        'AVAILABLE',
        TRUE
    ),
    (
        UUID(),
        15,
        (
            SELECT id
            FROM zones
            WHERE
                name = 'Main Hall'
        ),
        5,
        18.0,
        10.0,
        'AVAILABLE',
        TRUE
    );

-- Bar Tables (5 tables)
INSERT INTO
    tables (
        id,
        number,
        zone_id,
        capacity,
        position_x,
        position_y,
        status,
        active
    )
VALUES (
        UUID(),
        16,
        (
            SELECT id
            FROM zones
            WHERE
                name = 'Bar'
        ),
        5,
        2.0,
        2.0,
        'AVAILABLE',
        TRUE
    ),
    (
        UUID(),
        17,
        (
            SELECT id
            FROM zones
            WHERE
                name = 'Bar'
        ),
        5,
        5.0,
        2.0,
        'AVAILABLE',
        TRUE
    ),
    (
        UUID(),
        18,
        (
            SELECT id
            FROM zones
            WHERE
                name = 'Bar'
        ),
        5,
        8.0,
        2.0,
        'AVAILABLE',
        TRUE
    ),
    (
        UUID(),
        19,
        (
            SELECT id
            FROM zones
            WHERE
                name = 'Bar'
        ),
        5,
        11.0,
        2.0,
        'AVAILABLE',
        TRUE
    ),
    (
        UUID(),
        20,
        (
            SELECT id
            FROM zones
            WHERE
                name = 'Bar'
        ),
        5,
        14.0,
        2.0,
        'AVAILABLE',
        TRUE
    );

-- Patio Tables (8 tables)
INSERT INTO
    tables (
        id,
        number,
        zone_id,
        capacity,
        position_x,
        position_y,
        status,
        active
    )
VALUES (
        UUID(),
        21,
        (
            SELECT id
            FROM zones
            WHERE
                name = 'Patio'
        ),
        5,
        2.0,
        2.0,
        'AVAILABLE',
        TRUE
    ),
    (
        UUID(),
        22,
        (
            SELECT id
            FROM zones
            WHERE
                name = 'Patio'
        ),
        5,
        6.0,
        2.0,
        'AVAILABLE',
        TRUE
    ),
    (
        UUID(),
        23,
        (
            SELECT id
            FROM zones
            WHERE
                name = 'Patio'
        ),
        5,
        10.0,
        2.0,
        'AVAILABLE',
        TRUE
    ),
    (
        UUID(),
        24,
        (
            SELECT id
            FROM zones
            WHERE
                name = 'Patio'
        ),
        5,
        14.0,
        2.0,
        'AVAILABLE',
        TRUE
    ),
    (
        UUID(),
        25,
        (
            SELECT id
            FROM zones
            WHERE
                name = 'Patio'
        ),
        5,
        2.0,
        6.0,
        'AVAILABLE',
        TRUE
    ),
    (
        UUID(),
        26,
        (
            SELECT id
            FROM zones
            WHERE
                name = 'Patio'
        ),
        5,
        6.0,
        6.0,
        'AVAILABLE',
        TRUE
    ),
    (
        UUID(),
        27,
        (
            SELECT id
            FROM zones
            WHERE
                name = 'Patio'
        ),
        5,
        10.0,
        6.0,
        'AVAILABLE',
        TRUE
    ),
    (
        UUID(),
        28,
        (
            SELECT id
            FROM zones
            WHERE
                name = 'Patio'
        ),
        5,
        14.0,
        6.0,
        'AVAILABLE',
        TRUE
    );

-- VIP Tables (4 tables)
INSERT INTO
    tables (
        id,
        number,
        zone_id,
        capacity,
        position_x,
        position_y,
        status,
        active
    )
VALUES (
        UUID(),
        29,
        (
            SELECT id
            FROM zones
            WHERE
                name = 'VIP'
        ),
        5,
        2.0,
        2.0,
        'AVAILABLE',
        TRUE
    ),
    (
        UUID(),
        30,
        (
            SELECT id
            FROM zones
            WHERE
                name = 'VIP'
        ),
        5,
        6.0,
        2.0,
        'AVAILABLE',
        TRUE
    ),
    (
        UUID(),
        31,
        (
            SELECT id
            FROM zones
            WHERE
                name = 'VIP'
        ),
        5,
        10.0,
        2.0,
        'AVAILABLE',
        TRUE
    ),
    (
        UUID(),
        32,
        (
            SELECT id
            FROM zones
            WHERE
                name = 'VIP'
        ),
        5,
        14.0,
        2.0,
        'AVAILABLE',
        TRUE
    );

-- ============================================
-- 5. INSERT CATEGORIES
-- ============================================
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
    ),
    (
        UUID(),
        'Wines',
        'Red, white, and rosé wines',
        'BEVERAGE',
        TRUE
    ),
    (
        UUID(),
        'Soft Drinks',
        'Non-alcoholic beverages',
        'BEVERAGE',
        TRUE
    ),
    (
        UUID(),
        'Cocktails',
        'Mixed drinks and cocktails',
        'BEVERAGE',
        TRUE
    );

-- ============================================
-- 6. INSERT SAMPLE PRODUCTS
-- ============================================
-- Appetizers
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
        'Empanadas (6 pcs)',
        'Traditional Argentine empanadas - beef, chicken, or cheese',
        (
            SELECT id
            FROM categories
            WHERE
                name = 'Appetizers'
        ),
        1200.00,
        'FOOD',
        TRUE
    ),
    (
        UUID(),
        'Provoleta',
        'Grilled provolone cheese with oregano and olive oil',
        (
            SELECT id
            FROM categories
            WHERE
                name = 'Appetizers'
        ),
        1500.00,
        'FOOD',
        TRUE
    ),
    (
        UUID(),
        'French Fries',
        'Crispy golden french fries',
        (
            SELECT id
            FROM categories
            WHERE
                name = 'Appetizers'
        ),
        800.00,
        'FOOD',
        TRUE
    );

-- Main Courses
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
        'Classic Burger',
        'Beef patty, lettuce, tomato, onion, cheese, special sauce',
        (
            SELECT id
            FROM categories
            WHERE
                name = 'Main Courses'
        ),
        2400.00,
        'FOOD',
        TRUE
    ),
    (
        UUID(),
        'Milanesa Napolitana',
        'Breaded beef with ham, tomato sauce, and mozzarella',
        (
            SELECT id
            FROM categories
            WHERE
                name = 'Main Courses'
        ),
        3200.00,
        'FOOD',
        TRUE
    ),
    (
        UUID(),
        'Grilled Chicken',
        'Marinated grilled chicken breast with vegetables',
        (
            SELECT id
            FROM categories
            WHERE
                name = 'Main Courses'
        ),
        2800.00,
        'FOOD',
        TRUE
    ),
    (
        UUID(),
        'Pizza Margherita',
        'Tomato sauce, mozzarella, basil',
        (
            SELECT id
            FROM categories
            WHERE
                name = 'Main Courses'
        ),
        2000.00,
        'FOOD',
        TRUE
    );

-- Desserts
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
        'Flan',
        'Classic caramel flan with dulce de leche',
        (
            SELECT id
            FROM categories
            WHERE
                name = 'Desserts'
        ),
        900.00,
        'FOOD',
        TRUE
    ),
    (
        UUID(),
        'Ice Cream',
        'Artisan ice cream - 2 scoops',
        (
            SELECT id
            FROM categories
            WHERE
                name = 'Desserts'
        ),
        1000.00,
        'FOOD',
        TRUE
    );

-- Beers
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
        'Quilmes Beer',
        'Argentine lager - 1L',
        (
            SELECT id
            FROM categories
            WHERE
                name = 'Beers'
        ),
        1200.00,
        'BEVERAGE',
        TRUE
    ),
    (
        UUID(),
        'Stella Artois',
        'Premium lager - 473ml',
        (
            SELECT id
            FROM categories
            WHERE
                name = 'Beers'
        ),
        1000.00,
        'BEVERAGE',
        TRUE
    ),
    (
        UUID(),
        'IPA Craft Beer',
        'Local craft IPA - 473ml',
        (
            SELECT id
            FROM categories
            WHERE
                name = 'Beers'
        ),
        1400.00,
        'BEVERAGE',
        TRUE
    );

-- Wines
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
        'Malbec - Glass',
        'Argentine Malbec wine',
        (
            SELECT id
            FROM categories
            WHERE
                name = 'Wines'
        ),
        800.00,
        'BEVERAGE',
        TRUE
    ),
    (
        UUID(),
        'Malbec - Bottle',
        'Argentine Malbec wine - 750ml',
        (
            SELECT id
            FROM categories
            WHERE
                name = 'Wines'
        ),
        3500.00,
        'BEVERAGE',
        TRUE
    );

-- Soft Drinks
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
        'Coca Cola',
        'Coca Cola - 500ml',
        (
            SELECT id
            FROM categories
            WHERE
                name = 'Soft Drinks'
        ),
        500.00,
        'BEVERAGE',
        TRUE
    ),
    (
        UUID(),
        'Sprite',
        'Sprite - 500ml',
        (
            SELECT id
            FROM categories
            WHERE
                name = 'Soft Drinks'
        ),
        500.00,
        'BEVERAGE',
        TRUE
    ),
    (
        UUID(),
        'Water',
        'Mineral water - 500ml',
        (
            SELECT id
            FROM categories
            WHERE
                name = 'Soft Drinks'
        ),
        400.00,
        'BEVERAGE',
        TRUE
    ),
    (
        UUID(),
        'Orange Juice',
        'Fresh squeezed orange juice',
        (
            SELECT id
            FROM categories
            WHERE
                name = 'Soft Drinks'
        ),
        700.00,
        'BEVERAGE',
        TRUE
    );

-- Cocktails
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
        'Mojito',
        'Rum, mint, lime, soda',
        (
            SELECT id
            FROM categories
            WHERE
                name = 'Cocktails'
        ),
        1800.00,
        'BEVERAGE',
        TRUE
    ),
    (
        UUID(),
        'Fernet con Cola',
        'Fernet Branca with Coca Cola',
        (
            SELECT id
            FROM categories
            WHERE
                name = 'Cocktails'
        ),
        1500.00,
        'BEVERAGE',
        TRUE
    );

-- ============================================
-- 7. INSERT SYSTEM CONFIGURATION
-- ============================================
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
        '5',
        'Standard capacity of each table',
        'INTEGER'
    ),
    (
        UUID(),
        'MAX_JOIN_DISTANCE',
        '8.0',
        'Maximum distance in meters to join tables',
        'DECIMAL'
    ),
    (
        UUID(),
        'RESERVATION_DURATION_HOURS',
        '2',
        'Estimated duration of a reservation in hours',
        'INTEGER'
    ),
    (
        UUID(),
        'KITCHEN_ALERT_TIME',
        '15',
        'Minutes to alert urgent order in kitchen',
        'INTEGER'
    ),
    (
        UUID(),
        'SUGGESTED_TIP_PERCENTAGE',
        '10',
        'Suggested tip percentage',
        'INTEGER'
    );