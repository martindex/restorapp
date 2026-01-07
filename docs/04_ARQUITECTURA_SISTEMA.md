# SYSTEM ARCHITECTURE - VARES POS
## Complete Technical Design

---

## 1. OVERVIEW

### 1.1 3-Layer Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                    │
│                      (Frontend - React)                  │
├─────────────────────────────────────────────────────────┤
│  • Responsive User Interface                             │
│  • State Management (Redux/Context)                      │
│  • API Communication (Axios)                             │
│  • Client-side Validations                               │
└────────────────────┬────────────────────────────────────┘
                     │ HTTP/REST
                     │ (JSON)
┌────────────────────▼────────────────────────────────────┐
│                   APPLICATION LAYER                      │
│                (Backend - Spring Boot)                   │
├─────────────────────────────────────────────────────────┤
│  • REST API Controllers                                  │
│  • Business Logic (Services)                             │
│  • Security & Authentication (JWT)                       │
│  • Server-side Validations                               │
└────────────────────┬────────────────────────────────────┘
                     │ JDBC
                     │ (SQL)
┌────────────────────▼────────────────────────────────────┐
│                   PERSISTENCE LAYER                      │
│                    (MySQL Database)                      │
├─────────────────────────────────────────────────────────┤
│  • Data Storage                                          │
│  • Triggers & Stored Procedures                          │
│  • Audit & Logs                                          │
│  • Automated Backups                                     │
└─────────────────────────────────────────────────────────┘
```

---

## 2. TECHNOLOGY STACK

### 2.1 Frontend

**Main Framework:**
- React 18.x
- React Router 6.x for navigation
- Redux Toolkit or Context API for global state

**UI/UX:**
- Material-UI (MUI) or Ant Design
- Tailwind CSS for custom styles
- React Icons for iconography

**Communication:**
- Axios for HTTP requests
- Socket.io-client for real-time updates

**Development Tools:**
- Vite as bundler
- ESLint + Prettier for linting
- Jest + React Testing Library for testing

### 2.2 Backend

**Main Framework:**
- Java 17 LTS
- Spring Boot 3.x
- Spring Data JPA
- Spring Security

**Security:**
- JWT (JSON Web Tokens) for authentication
- BCrypt for password hashing
- CORS configured

**Communication:**
- Spring Web (REST API)
- WebSocket for real-time notifications

**Tools:**
- Maven for dependency management
- Lombok to reduce boilerplate
- MapStruct for DTO mapping
- JUnit 5 + Mockito for testing

### 2.3 Database

- MySQL 8.0
- InnoDB storage engine
- UTF-8mb4 for full character support

### 2.4 Infrastructure

- Docker 24.x
- Docker Compose for orchestration
- Nginx as reverse proxy (optional)

---

## 3. PROJECT STRUCTURE

### 3.1 Frontend Structure (React)

```
vares-frontend/
├── public/
│   ├── index.html
│   └── assets/
│       ├── images/
│       └── icons/
├── src/
│   ├── components/
│   │   ├── common/
│   │   │   ├── Button.jsx
│   │   │   ├── Input.jsx
│   │   │   ├── Modal.jsx
│   │   │   └── Loader.jsx
│   │   ├── layout/
│   │   │   ├── Header.jsx
│   │   │   ├── Sidebar.jsx
│   │   │   └── Footer.jsx
│   │   ├── tables/
│   │   │   ├── FloorMap.jsx
│   │   │   ├── TableCard.jsx
│   │   │   └── TableJoin.jsx
│   │   ├── reservations/
│   │   │   ├── ReservationForm.jsx
│   │   │   ├── ReservationList.jsx
│   │   │   └── ReservationDetail.jsx
│   │   ├── orders/
│   │   │   ├── OrderForm.jsx
│   │   │   ├── OrderList.jsx
│   │   │   └── OrderDetail.jsx
│   │   ├── kitchen/
│   │   │   ├── KitchenDisplay.jsx
│   │   │   └── OrderItemCard.jsx
│   │   └── users/
│   │       ├── UserForm.jsx
│   │       └── UserList.jsx
│   ├── pages/
│   │   ├── Login.jsx
│   │   ├── Dashboard.jsx
│   │   ├── Tables.jsx
│   │   ├── Reservations.jsx
│   │   ├── Orders.jsx
│   │   ├── Kitchen.jsx
│   │   ├── Cashier.jsx
│   │   └── Admin.jsx
│   ├── services/
│   │   ├── api.js
│   │   ├── authService.js
│   │   ├── tableService.js
│   │   ├── reservationService.js
│   │   ├── orderService.js
│   │   └── userService.js
│   ├── store/
│   │   ├── index.js
│   │   ├── slices/
│   │   │   ├── authSlice.js
│   │   │   ├── tableSlice.js
│   │   │   ├── reservationSlice.js
│   │   │   └── orderSlice.js
│   │   └── middleware/
│   ├── utils/
│   │   ├── constants.js
│   │   ├── validators.js
│   │   └── formatters.js
│   ├── hooks/
│   │   ├── useAuth.js
│   │   ├── useTables.js
│   │   └── useWebSocket.js
│   ├── App.jsx
│   ├── main.jsx
│   └── routes.jsx
├── .env
├── .env.example
├── package.json
├── vite.config.js
└── README.md
```

### 3.2 Backend Structure (Spring Boot)

```
vares-backend/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/
│   │   │       └── vares/
│   │   │           └── pos/
│   │   │               ├── VaresPosApplication.java
│   │   │               ├── config/
│   │   │               │   ├── SecurityConfig.java
│   │   │               │   ├── WebSocketConfig.java
│   │   │               │   └── CorsConfig.java
│   │   │               ├── controller/
│   │   │               │   ├── AuthController.java
│   │   │               │   ├── TableController.java
│   │   │               │   ├── ReservationController.java
│   │   │               │   ├── OrderController.java
│   │   │               │   ├── ProductController.java
│   │   │               │   ├── UserController.java
│   │   │               │   └── KitchenController.java
│   │   │               ├── service/
│   │   │               │   ├── AuthService.java
│   │   │               │   ├── TableService.java
│   │   │               │   ├── ReservationService.java
│   │   │               │   ├── OrderService.java
│   │   │               │   ├── ProductService.java
│   │   │               │   ├── UserService.java
│   │   │               │   ├── TableAssignmentService.java
│   │   │               │   └── AuditService.java
│   │   │               ├── repository/
│   │   │               │   ├── TableRepository.java
│   │   │               │   ├── ReservationRepository.java
│   │   │               │   ├── OrderRepository.java
│   │   │               │   ├── ProductRepository.java
│   │   │               │   ├── UserRepository.java
│   │   │               │   └── AuditLogRepository.java
│   │   │               ├── model/
│   │   │               │   ├── entity/
│   │   │               │   │   ├── User.java
│   │   │               │   │   ├── Role.java
│   │   │               │   │   ├── Table.java
│   │   │               │   │   ├── Zone.java
│   │   │               │   │   ├── Reservation.java
│   │   │               │   │   ├── Order.java
│   │   │               │   │   ├── OrderItem.java
│   │   │               │   │   ├── Product.java
│   │   │               │   │   ├── Category.java
│   │   │               │   │   └── AuditLog.java
│   │   │               │   └── dto/
│   │   │               │       ├── LoginRequest.java
│   │   │               │       ├── LoginResponse.java
│   │   │               │       ├── TableDTO.java
│   │   │               │       ├── ReservationDTO.java
│   │   │               │       ├── OrderDTO.java
│   │   │               │       └── ProductDTO.java
│   │   │               ├── exception/
│   │   │               │   ├── GlobalExceptionHandler.java
│   │   │               │   ├── ResourceNotFoundException.java
│   │   │               │   ├── BusinessException.java
│   │   │               │   └── UnauthorizedException.java
│   │   │               ├── security/
│   │   │               │   ├── JwtTokenProvider.java
│   │   │               │   ├── JwtAuthenticationFilter.java
│   │   │               │   └── CustomUserDetailsService.java
│   │   │               └── util/
│   │   │                   ├── Constants.java
│   │   │                   ├── DateUtils.java
│   │   │                   └── ValidationUtils.java
│   │   └── resources/
│   │       ├── application.properties
│   │       ├── application-dev.properties
│   │       ├── application-prod.properties
│   │       └── db/
│   │           └── migration/
│   │               ├── V1__create_initial_schema.sql
│   │               ├── V2__insert_initial_data.sql
│   │               └── V3__create_triggers.sql
│   └── test/
│       └── java/
│           └── com/
│               └── vares/
│                   └── pos/
│                       ├── service/
│                       ├── controller/
│                       └── repository/
├── pom.xml
├── Dockerfile
└── README.md
```

---

## 4. BACKEND MODULES

### 4.1 Authentication Module

**Responsibilities:**
- Login/Logout
- JWT generation and validation
- Session management
- Refresh tokens

**Endpoints:**
```
POST   /api/auth/login
POST   /api/auth/logout
POST   /api/auth/refresh
GET    /api/auth/me
```

**Example Entity:**
```java
@Entity
@Table(name = "users")
public class User {
    @Id
    private String id;
    
    private String name;
    
    @Column(unique = true)
    private String email;
    
    private String passwordHash;
    
    @ManyToOne
    @JoinColumn(name = "role_id")
    private Role role;
    
    private Boolean active;
    
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
```

### 4.2 User Module

**Responsibilities:**
- User CRUD operations
- Role assignment
- Activation/deactivation
- Password changes

**Endpoints:**
```
GET    /api/users
GET    /api/users/{id}
POST   /api/users
PUT    /api/users/{id}
DELETE /api/users/{id}
PUT    /api/users/{id}/activate
PUT    /api/users/{id}/deactivate
PUT    /api/users/{id}/change-password
```

**Example Service:**
```java
@Service
public class UserService {
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private PasswordEncoder passwordEncoder;
    
    public UserDTO createUser(CreateUserRequest request) {
        // Validate email uniqueness
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new BusinessException("Email already exists");
        }
        
        User user = new User();
        user.setId(UUID.randomUUID().toString());
        user.setName(request.getName());
        user.setEmail(request.getEmail());
        user.setPasswordHash(passwordEncoder.encode(request.getPassword()));
        user.setRole(roleRepository.findById(request.getRoleId())
            .orElseThrow(() -> new ResourceNotFoundException("Role not found")));
        user.setActive(true);
        user.setCreatedAt(LocalDateTime.now());
        
        User savedUser = userRepository.save(user);
        return mapToDTO(savedUser);
    }
    
    public void activateUser(String userId) {
        User user = findUserById(userId);
        user.setActive(true);
        userRepository.save(user);
    }
    
    public void deactivateUser(String userId) {
        User user = findUserById(userId);
        user.setActive(false);
        userRepository.save(user);
    }
}
```

### 4.3 Table Module

**Responsibilities:**
- Table CRUD operations
- Status management
- Table joining and separation
- Availability queries

**Endpoints:**
```
GET    /api/tables
GET    /api/tables/{id}
POST   /api/tables
PUT    /api/tables/{id}
DELETE /api/tables/{id}
GET    /api/tables/available
POST   /api/tables/join
POST   /api/tables/separate/{mainTableId}
GET    /api/tables/zone/{zoneId}
```

**Example Entity:**
```java
@Entity
@Table(name = "tables")
public class Table {
    @Id
    private String id;
    
    private Integer number;
    
    @ManyToOne
    @JoinColumn(name = "zone_id")
    private Zone zone;
    
    private Integer capacity;
    
    private BigDecimal positionX;
    private BigDecimal positionY;
    
    @Enumerated(EnumType.STRING)
    private TableStatus status;
    
    @ManyToOne
    @JoinColumn(name = "main_table_id")
    private Table mainTable;
    
    private Boolean active;
    
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}

public enum TableStatus {
    AVAILABLE,
    RESERVED,
    OCCUPIED,
    JOINED
}
```

**Example Service:**
```java
@Service
public class TableService {
    
    @Autowired
    private TableRepository tableRepository;
    
    public List<TableDTO> getAvailableTables(String zoneId, LocalDate date, LocalTime time) {
        List<Table> tables = tableRepository.findByZoneIdAndActive(zoneId, true);
        
        return tables.stream()
            .filter(table -> isTableAvailable(table, date, time))
            .map(this::mapToDTO)
            .collect(Collectors.toList());
    }
    
    public void joinTables(String mainTableId, List<String> tableIds, String reservationId) {
        Table mainTable = findTableById(mainTableId);
        mainTable.setStatus(TableStatus.OCCUPIED);
        tableRepository.save(mainTable);
        
        for (String tableId : tableIds) {
            if (!tableId.equals(mainTableId)) {
                Table table = findTableById(tableId);
                table.setStatus(TableStatus.JOINED);
                table.setMainTable(mainTable);
                tableRepository.save(table);
            }
        }
        
        // Create join record
        TableJoin join = new TableJoin();
        join.setId(UUID.randomUUID().toString());
        join.setMainTable(mainTable);
        join.setReservationId(reservationId);
        join.setJoinedAt(LocalDateTime.now());
        join.setActive(true);
        tableJoinRepository.save(join);
    }
    
    public void separateTables(String mainTableId) {
        Table mainTable = findTableById(mainTableId);
        mainTable.setStatus(TableStatus.AVAILABLE);
        tableRepository.save(mainTable);
        
        List<Table> joinedTables = tableRepository.findByMainTableId(mainTableId);
        for (Table table : joinedTables) {
            table.setStatus(TableStatus.AVAILABLE);
            table.setMainTable(null);
            tableRepository.save(table);
        }
        
        // Mark join as inactive
        tableJoinRepository.deactivateByMainTableId(mainTableId);
    }
}
```

### 4.4 Reservation Module

**Responsibilities:**
- Create reservations (online and assisted)
- Automatic table assignment
- Reservation status management
- Availability queries

**Endpoints:**
```
GET    /api/reservations
GET    /api/reservations/{id}
POST   /api/reservations/online
POST   /api/reservations/assisted
PUT    /api/reservations/{id}
DELETE /api/reservations/{id}
PUT    /api/reservations/{id}/confirm
PUT    /api/reservations/{id}/cancel
GET    /api/reservations/availability
GET    /api/reservations/date/{date}
```

**Example Entity:**
```java
@Entity
@Table(name = "reservations")
public class Reservation {
    @Id
    private String id;
    
    @ManyToOne
    @JoinColumn(name = "customer_id")
    private Customer customer;
    
    private Integer partySize;
    
    private LocalDate date;
    private LocalTime time;
    
    @Enumerated(EnumType.STRING)
    private ReservationStatus status;
    
    @Enumerated(EnumType.STRING)
    private ReservationType type;
    
    private String referenceName;
    private String phone;
    private String notes;
    
    @ManyToOne
    @JoinColumn(name = "created_by")
    private User createdBy;
    
    @OneToMany(mappedBy = "reservation")
    private List<ReservationTable> reservationTables;
    
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}

public enum ReservationStatus {
    PENDING,
    CONFIRMED,
    CANCELLED,
    COMPLETED
}

public enum ReservationType {
    ONLINE,
    ASSISTED
}
```

**Example Service:**
```java
@Service
public class ReservationService {
    
    @Autowired
    private ReservationRepository reservationRepository;
    
    @Autowired
    private TableAssignmentService tableAssignmentService;
    
    public ReservationDTO createOnlineReservation(CreateReservationRequest request) {
        // Validate customer
        Customer customer = customerRepository.findById(request.getCustomerId())
            .orElseThrow(() -> new ResourceNotFoundException("Customer not found"));
        
        // Find available tables
        List<Table> assignedTables = tableAssignmentService.assignTables(
            request.getPartySize(),
            request.getDate(),
            request.getTime(),
            request.getPreferredZoneId()
        );
        
        if (assignedTables.isEmpty()) {
            throw new BusinessException("No tables available for the requested date and time");
        }
        
        // Create reservation
        Reservation reservation = new Reservation();
        reservation.setId(UUID.randomUUID().toString());
        reservation.setCustomer(customer);
        reservation.setPartySize(request.getPartySize());
        reservation.setDate(request.getDate());
        reservation.setTime(request.getTime());
        reservation.setStatus(ReservationStatus.PENDING);
        reservation.setType(ReservationType.ONLINE);
        reservation.setNotes(request.getNotes());
        reservation.setCreatedAt(LocalDateTime.now());
        
        Reservation savedReservation = reservationRepository.save(reservation);
        
        // Link tables to reservation
        for (Table table : assignedTables) {
            ReservationTable rt = new ReservationTable();
            rt.setReservation(savedReservation);
            rt.setTable(table);
            rt.setIsMain(table.equals(assignedTables.get(0)));
            reservationTableRepository.save(rt);
            
            // Update table status
            table.setStatus(TableStatus.RESERVED);
            tableRepository.save(table);
        }
        
        return mapToDTO(savedReservation);
    }
    
    public ReservationDTO createAssistedReservation(CreateAssistedReservationRequest request) {
        // Similar to online but without customer_id
        // Uses referenceName and phone instead
        
        Reservation reservation = new Reservation();
        reservation.setId(UUID.randomUUID().toString());
        reservation.setCustomer(null); // Anonymous customer
        reservation.setPartySize(request.getPartySize());
        reservation.setDate(request.getDate());
        reservation.setTime(request.getTime());
        reservation.setStatus(ReservationStatus.PENDING);
        reservation.setType(ReservationType.ASSISTED);
        reservation.setReferenceName(request.getReferenceName());
        reservation.setPhone(request.getPhone());
        reservation.setNotes(request.getNotes());
        reservation.setCreatedBy(getCurrentUser());
        reservation.setCreatedAt(LocalDateTime.now());
        
        // ... rest of the logic
        
        return mapToDTO(savedReservation);
    }
}
```

### 4.5 Order Module

**Responsibilities:**
- Open/close orders
- Add items
- Calculate totals
- Status management

**Endpoints:**
```
GET    /api/orders
GET    /api/orders/{id}
POST   /api/orders/open
POST   /api/orders/{id}/items
PUT    /api/orders/{id}/items/{itemId}
DELETE /api/orders/{id}/items/{itemId}
PUT    /api/orders/{id}/close
GET    /api/orders/active
GET    /api/orders/waiter/{waiterId}
```

**Example Entity:**
```java
@Entity
@Table(name = "orders")
public class Order {
    @Id
    private String id;
    
    @ManyToOne
    @JoinColumn(name = "table_id")
    private Table table;
    
    @ManyToOne
    @JoinColumn(name = "waiter_id")
    private User waiter;
    
    @ManyToOne
    @JoinColumn(name = "reservation_id")
    private Reservation reservation;
    
    private LocalDateTime openedAt;
    private LocalDateTime closedAt;
    
    @Enumerated(EnumType.STRING)
    private OrderStatus status;
    
    private BigDecimal subtotal;
    private BigDecimal tip;
    private BigDecimal total;
    
    @OneToMany(mappedBy = "order", cascade = CascadeType.ALL)
    private List<OrderItem> items;
}

public enum OrderStatus {
    OPEN,
    IN_PROGRESS,
    SERVED,
    PAID,
    CLOSED
}

@Entity
@Table(name = "order_items")
public class OrderItem {
    @Id
    private String id;
    
    @ManyToOne
    @JoinColumn(name = "order_id")
    private Order order;
    
    @ManyToOne
    @JoinColumn(name = "product_id")
    private Product product;
    
    private Integer quantity;
    private BigDecimal unitPrice;
    private String notes;
    
    @Enumerated(EnumType.STRING)
    private ProductType type;
    
    @Enumerated(EnumType.STRING)
    private OrderItemStatus status;
    
    private LocalDateTime orderedAt;
    private LocalDateTime servedAt;
}

public enum OrderItemStatus {
    PENDING,
    IN_KITCHEN,
    READY,
    SERVED
}
```

**Example Service:**
```java
@Service
public class OrderService {
    
    @Autowired
    private OrderRepository orderRepository;
    
    @Autowired
    private NotificationService notificationService;
    
    public OrderDTO openOrder(OpenOrderRequest request) {
        // Validate table is available
        Table table = tableRepository.findById(request.getTableId())
            .orElseThrow(() -> new ResourceNotFoundException("Table not found"));
        
        if (table.getStatus() != TableStatus.AVAILABLE) {
            throw new BusinessException("Table is not available");
        }
        
        // Create order
        Order order = new Order();
        order.setId(UUID.randomUUID().toString());
        order.setTable(table);
        order.setWaiter(getCurrentUser());
        order.setReservation(request.getReservationId() != null ? 
            reservationRepository.findById(request.getReservationId()).orElse(null) : null);
        order.setOpenedAt(LocalDateTime.now());
        order.setStatus(OrderStatus.OPEN);
        order.setSubtotal(BigDecimal.ZERO);
        order.setTip(BigDecimal.ZERO);
        order.setTotal(BigDecimal.ZERO);
        
        Order savedOrder = orderRepository.save(order);
        
        // Update table status
        table.setStatus(TableStatus.OCCUPIED);
        tableRepository.save(table);
        
        return mapToDTO(savedOrder);
    }
    
    public OrderItemDTO addItem(String orderId, AddItemRequest request) {
        Order order = findOrderById(orderId);
        Product product = productRepository.findById(request.getProductId())
            .orElseThrow(() -> new ResourceNotFoundException("Product not found"));
        
        OrderItem item = new OrderItem();
        item.setId(UUID.randomUUID().toString());
        item.setOrder(order);
        item.setProduct(product);
        item.setQuantity(request.getQuantity());
        item.setUnitPrice(product.getPrice());
        item.setNotes(request.getNotes());
        item.setType(product.getType());
        item.setStatus(OrderItemStatus.PENDING);
        item.setOrderedAt(LocalDateTime.now());
        
        OrderItem savedItem = orderItemRepository.save(item);
        
        // If it's food, send to kitchen
        if (product.getType() == ProductType.FOOD) {
            item.setStatus(OrderItemStatus.IN_KITCHEN);
            orderItemRepository.save(item);
            notificationService.notifyKitchen(savedItem);
        }
        
        // Update order total
        updateOrderTotal(order);
        
        return mapToDTO(savedItem);
    }
    
    private void updateOrderTotal(Order order) {
        BigDecimal subtotal = order.getItems().stream()
            .map(item -> item.getUnitPrice().multiply(BigDecimal.valueOf(item.getQuantity())))
            .reduce(BigDecimal.ZERO, BigDecimal::add);
        
        order.setSubtotal(subtotal);
        order.setTotal(subtotal.add(order.getTip()));
        orderRepository.save(order);
    }
}
```

### 4.6 Kitchen Module

**Responsibilities:**
- Order queue
- Item status changes
- Waiter notifications
- Urgent order alerts

**Endpoints:**
```
GET    /api/kitchen/queue
PUT    /api/kitchen/items/{itemId}/status
GET    /api/kitchen/items/urgent
POST   /api/kitchen/items/{itemId}/notify
```

**Example Service:**
```java
@Service
public class KitchenService {
    
    @Autowired
    private OrderItemRepository orderItemRepository;
    
    @Autowired
    private WebSocketNotificationService webSocketService;
    
    public List<KitchenQueueItemDTO> getKitchenQueue() {
        List<OrderItem> items = orderItemRepository.findByTypeAndStatusIn(
            ProductType.FOOD,
            Arrays.asList(OrderItemStatus.PENDING, OrderItemStatus.IN_KITCHEN)
        );
        
        return items.stream()
            .map(this::mapToKitchenQueueDTO)
            .sorted(Comparator.comparing(KitchenQueueItemDTO::getOrderedAt))
            .collect(Collectors.toList());
    }
    
    public void updateItemStatus(String itemId, OrderItemStatus newStatus) {
        OrderItem item = orderItemRepository.findById(itemId)
            .orElseThrow(() -> new ResourceNotFoundException("Order item not found"));
        
        item.setStatus(newStatus);
        
        if (newStatus == OrderItemStatus.READY) {
            item.setServedAt(LocalDateTime.now());
            
            // Notify waiter
            String waiterId = item.getOrder().getWaiter().getId();
            webSocketService.notifyWaiter(waiterId, item);
        }
        
        orderItemRepository.save(item);
    }
    
    public List<KitchenQueueItemDTO> getUrgentItems() {
        LocalDateTime urgentThreshold = LocalDateTime.now().minusMinutes(15);
        
        List<OrderItem> items = orderItemRepository.findByTypeAndStatusInAndOrderedAtBefore(
            ProductType.FOOD,
            Arrays.asList(OrderItemStatus.PENDING, OrderItemStatus.IN_KITCHEN),
            urgentThreshold
        );
        
        return items.stream()
            .map(this::mapToKitchenQueueDTO)
            .collect(Collectors.toList());
    }
}
```

### 4.7 Product Module

**Responsibilities:**
- Product CRUD operations
- Category management
- Availability control
- Price management

**Endpoints:**
```
GET    /api/products
GET    /api/products/{id}
POST   /api/products
PUT    /api/products/{id}
DELETE /api/products/{id}
GET    /api/products/category/{categoryId}
GET    /api/products/type/{type}
GET    /api/categories
POST   /api/categories
```

**Example Entity:**
```java
@Entity
@Table(name = "products")
public class Product {
    @Id
    private String id;
    
    private String name;
    private String description;
    
    @ManyToOne
    @JoinColumn(name = "category_id")
    private Category category;
    
    private BigDecimal price;
    
    @Enumerated(EnumType.STRING)
    private ProductType type;
    
    private Boolean available;
    private String imageUrl;
    
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}

public enum ProductType {
    FOOD,
    BEVERAGE
}
```

### 4.8 Payment Module

**Responsibilities:**
- Process payments
- Generate receipts/invoices
- Sales history
- Reports

**Endpoints:**
```
POST   /api/payments
GET    /api/payments/{id}
GET    /api/payments/order/{orderId}
GET    /api/payments/report/date/{date}
GET    /api/payments/report/month/{month}
```

**Example Entity:**
```java
@Entity
@Table(name = "payments")
public class Payment {
    @Id
    private String id;
    
    @ManyToOne
    @JoinColumn(name = "order_id")
    private Order order;
    
    @ManyToOne
    @JoinColumn(name = "cashier_id")
    private User cashier;
    
    private BigDecimal amount;
    
    @Enumerated(EnumType.STRING)
    private PaymentMethod paymentMethod;
    
    private LocalDateTime paidAt;
    
    @Enumerated(EnumType.STRING)
    private PaymentStatus status;
    
    private String reference;
}

public enum PaymentMethod {
    CASH,
    DEBIT_CARD,
    CREDIT_CARD,
    TRANSFER,
    QR
}

public enum PaymentStatus {
    PENDING,
    APPROVED,
    REJECTED
}
```

---

## 5. FRONTEND COMPONENTS

### 5.1 Key Component Examples

**FloorMap.jsx:**
```jsx
import React, { useState, useEffect } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { fetchTables } from '../store/slices/tableSlice';
import TableCard from './TableCard';

const FloorMap = () => {
  const dispatch = useDispatch();
  const { tables, loading } = useSelector(state => state.tables);
  const [selectedZone, setSelectedZone] = useState('all');

  useEffect(() => {
    dispatch(fetchTables());
  }, [dispatch]);

  const filteredTables = selectedZone === 'all' 
    ? tables 
    : tables.filter(table => table.zoneId === selectedZone);

  return (
    <div className="floor-map">
      <div className="zone-filter">
        <button onClick={() => setSelectedZone('all')}>All</button>
        <button onClick={() => setSelectedZone('main-hall')}>Main Hall</button>
        <button onClick={() => setSelectedZone('bar')}>Bar</button>
        <button onClick={() => setSelectedZone('patio')}>Patio</button>
        <button onClick={() => setSelectedZone('vip')}>VIP</button>
      </div>
      
      <div className="tables-grid">
        {filteredTables.map(table => (
          <TableCard 
            key={table.id} 
            table={table}
            style={{
              left: `${table.positionX}px`,
              top: `${table.positionY}px`
            }}
          />
        ))}
      </div>
    </div>
  );
};

export default FloorMap;
```

**TableCard.jsx:**
```jsx
import React from 'react';
import { useDispatch } from 'react-redux';
import { openTable } from '../store/slices/tableSlice';

const TableCard = ({ table, style }) => {
  const dispatch = useDispatch();

  const getStatusColor = (status) => {
    switch (status) {
      case 'AVAILABLE': return 'green';
      case 'OCCUPIED': return 'red';
      case 'RESERVED': return 'yellow';
      case 'JOINED': return 'blue';
      default: return 'gray';
    }
  };

  const handleOpenTable = () => {
    if (table.status === 'AVAILABLE') {
      dispatch(openTable(table.id));
    }
  };

  return (
    <div 
      className={`table-card status-${table.status.toLowerCase()}`}
      style={style}
      onClick={handleOpenTable}
    >
      <div className="table-number">Table {table.number}</div>
      <div className="table-capacity">{table.capacity} seats</div>
      <div 
        className="status-indicator" 
        style={{ backgroundColor: getStatusColor(table.status) }}
      />
    </div>
  );
};

export default TableCard;
```

**KitchenDisplay.jsx:**
```jsx
import React, { useState, useEffect } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { fetchKitchenQueue, updateItemStatus } from '../store/slices/kitchenSlice';
import OrderItemCard from './OrderItemCard';

const KitchenDisplay = () => {
  const dispatch = useDispatch();
  const { queueItems, loading } = useSelector(state => state.kitchen);

  useEffect(() => {
    dispatch(fetchKitchenQueue());
    
    // Poll every 10 seconds
    const interval = setInterval(() => {
      dispatch(fetchKitchenQueue());
    }, 10000);
    
    return () => clearInterval(interval);
  }, [dispatch]);

  const handleStartCooking = (itemId) => {
    dispatch(updateItemStatus({ itemId, status: 'IN_KITCHEN' }));
  };

  const handleMarkReady = (itemId) => {
    dispatch(updateItemStatus({ itemId, status: 'READY' }));
  };

  const pendingItems = queueItems.filter(item => item.status === 'PENDING');
  const inProgressItems = queueItems.filter(item => item.status === 'IN_KITCHEN');

  return (
    <div className="kitchen-display">
      <h1>Kitchen Queue</h1>
      
      <div className="queue-section">
        <h2>Pending ({pendingItems.length})</h2>
        <div className="items-grid">
          {pendingItems.map(item => (
            <OrderItemCard 
              key={item.id}
              item={item}
              onAction={() => handleStartCooking(item.id)}
              actionLabel="Start Cooking"
            />
          ))}
        </div>
      </div>
      
      <div className="queue-section">
        <h2>In Progress ({inProgressItems.length})</h2>
        <div className="items-grid">
          {inProgressItems.map(item => (
            <OrderItemCard 
              key={item.id}
              item={item}
              onAction={() => handleMarkReady(item.id)}
              actionLabel="Mark Ready"
            />
          ))}
        </div>
      </div>
    </div>
  );
};

export default KitchenDisplay;
```

---

## 6. SECURITY

### 6.1 JWT Authentication

```java
@Component
public class JwtTokenProvider {
    
    @Value("${jwt.secret}")
    private String jwtSecret;
    
    @Value("${jwt.expiration}")
    private long jwtExpiration;
    
    public String generateToken(Authentication authentication) {
        UserPrincipal userPrincipal = (UserPrincipal) authentication.getPrincipal();
        
        Date now = new Date();
        Date expiryDate = new Date(now.getTime() + jwtExpiration);
        
        return Jwts.builder()
            .setSubject(userPrincipal.getId())
            .claim("role", userPrincipal.getRole().getName())
            .setIssuedAt(now)
            .setExpiration(expiryDate)
            .signWith(SignatureAlgorithm.HS512, jwtSecret)
            .compact();
    }
    
    public String getUserIdFromToken(String token) {
        Claims claims = Jwts.parser()
            .setSigningKey(jwtSecret)
            .parseClaimsJws(token)
            .getBody();
        
        return claims.getSubject();
    }
    
    public boolean validateToken(String authToken) {
        try {
            Jwts.parser().setSigningKey(jwtSecret).parseClaimsJws(authToken);
            return true;
        } catch (SignatureException | MalformedJwtException | ExpiredJwtException | 
                 UnsupportedJwtException | IllegalArgumentException ex) {
            return false;
        }
    }
}
```

### 6.2 Role-Based Access Control

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {
    
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .csrf().disable()
            .cors()
            .and()
            .sessionManagement()
                .sessionCreationPolicy(SessionCreationPolicy.STATELESS)
            .and()
            .authorizeHttpRequests()
                .requestMatchers("/api/auth/**").permitAll()
                .requestMatchers("/api/users/**").hasRole("SUPERUSER")
                .requestMatchers("/api/tables/**").hasAnyRole("SUPERUSER", "WAITER")
                .requestMatchers("/api/orders/**").hasAnyRole("SUPERUSER", "WAITER")
                .requestMatchers("/api/kitchen/**").hasAnyRole("SUPERUSER", "COOK")
                .requestMatchers("/api/payments/**").hasAnyRole("SUPERUSER", "CASHIER")
                .anyRequest().authenticated()
            .and()
            .addFilterBefore(jwtAuthenticationFilter(), UsernamePasswordAuthenticationFilter.class);
        
        return http.build();
    }
}
```

---

## 7. REAL-TIME COMMUNICATION

### 7.1 WebSocket Configuration

```java
@Configuration
@EnableWebSocketMessageBroker
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {
    
    @Override
    public void configureMessageBroker(MessageBrokerRegistry config) {
        config.enableSimpleBroker("/topic", "/queue");
        config.setApplicationDestinationPrefixes("/app");
    }
    
    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        registry.addEndpoint("/ws")
            .setAllowedOrigins("*")
            .withSockJS();
    }
}
```

### 7.2 Notification Service

```java
@Service
public class WebSocketNotificationService {
    
    @Autowired
    private SimpMessagingTemplate messagingTemplate;
    
    public void notifyKitchen(OrderItem item) {
        KitchenNotification notification = new KitchenNotification();
        notification.setItemId(item.getId());
        notification.setTableNumber(item.getOrder().getTable().getNumber());
        notification.setProductName(item.getProduct().getName());
        notification.setQuantity(item.getQuantity());
        notification.setNotes(item.getNotes());
        
        messagingTemplate.convertAndSend("/topic/kitchen/new-order", notification);
    }
    
    public void notifyWaiter(String waiterId, OrderItem item) {
        WaiterNotification notification = new WaiterNotification();
        notification.setItemId(item.getId());
        notification.setTableNumber(item.getOrder().getTable().getNumber());
        notification.setProductName(item.getProduct().getName());
        notification.setStatus("READY");
        
        messagingTemplate.convertAndSendToUser(
            waiterId, 
            "/queue/orders/ready", 
            notification
        );
    }
    
    public void notifyTableStatusChange(String tableId, TableStatus newStatus) {
        TableStatusNotification notification = new TableStatusNotification();
        notification.setTableId(tableId);
        notification.setStatus(newStatus);
        
        messagingTemplate.convertAndSend("/topic/tables/status", notification);
    }
}
```

### 7.3 Frontend WebSocket Hook

```javascript
// hooks/useWebSocket.js
import { useEffect, useRef } from 'react';
import { useDispatch } from 'react-redux';
import SockJS from 'sockjs-client';
import { Stomp } from '@stomp/stompjs';

export const useWebSocket = () => {
  const dispatch = useDispatch();
  const stompClient = useRef(null);

  useEffect(() => {
    const socket = new SockJS('http://localhost:8080/ws');
    stompClient.current = Stomp.over(socket);

    stompClient.current.connect({}, (frame) => {
      console.log('Connected: ' + frame);

      // Subscribe to kitchen notifications
      stompClient.current.subscribe('/topic/kitchen/new-order', (message) => {
        const notification = JSON.parse(message.body);
        dispatch(addKitchenNotification(notification));
      });

      // Subscribe to waiter notifications
      const userId = localStorage.getItem('userId');
      stompClient.current.subscribe(`/user/${userId}/queue/orders/ready`, (message) => {
        const notification = JSON.parse(message.body);
        dispatch(addWaiterNotification(notification));
      });

      // Subscribe to table status changes
      stompClient.current.subscribe('/topic/tables/status', (message) => {
        const notification = JSON.parse(message.body);
        dispatch(updateTableStatus(notification));
      });
    });

    return () => {
      if (stompClient.current) {
        stompClient.current.disconnect();
      }
    };
  }, [dispatch]);

  return stompClient.current;
};
```

---

**Document created by:** VARES System  
**Version:** 2.0 (English Nomenclature)  
**Date:** 2026-01-05
