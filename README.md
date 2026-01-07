# 🍽️ VARES POS - Point of Sale System for Bars and Restaurants

Comprehensive management system for bars and restaurants that handles the entire operational flow: from reservations to payments, including table management, orders, and kitchen operations.

---

## 📋 Table of Contents

- [Key Features](#-key-features)
- [Architecture](#-architecture)
- [Prerequisites](#-prerequisites)
- [Installation](#-installation)
- [Usage](#-usage)
- [Documentation](#-documentation)
- [Project Structure](#-project-structure)
- [Technologies](#-technologies)
- [Contributing](#-contributing)
- [License](#-license)

---

## ✨ Key Features

### 🪑 Intelligent Table Management
- Automatic assignment based on optimization algorithm
- Dynamic table joining for large groups
- Interactive real-time floor map
- Status management (Available, Reserved, Occupied, Joined)

### 📅 Reservation System
- **Online Reservations:** Registered customers can book through the web
- **Assisted Reservations:** For anonymous customers (via phone)
- Automatic table assignment
- Reservation calendar
- Email notifications

### 🍔 Order Management
- Digital order taking
- Automatic food/beverage separation
- Add items at any time
- Automatic total calculation
- Special notes management

### 👨‍🍳 Kitchen Display
- Real-time order queue
- Chronological preparation order
- Statuses: Pending, In Kitchen, Ready, Served
- Urgent order alerts (>15 min)
- Automatic waiter notifications

### 💰 Payment Processing
- Multiple payment methods
- Tip calculation
- Receipt/invoice generation
- Sales reports
- Daily cash closing

### 👥 User Management
- 4 roles: Superuser, Waiter, Cook, Cashier
- Granular permissions per role
- Complete action audit
- JWT session management

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                    │
│                      (Frontend - React)                  │
└────────────────────┬────────────────────────────────────┘
                     │ HTTP/REST (JSON)
┌────────────────────▼────────────────────────────────────┐
│                   APPLICATION LAYER                      │
│                (Backend - Spring Boot)                   │
└────────────────────┬────────────────────────────────────┘
                     │ JDBC (SQL)
┌────────────────────▼────────────────────────────────────┐
│                   PERSISTENCE LAYER                      │
│                    (MySQL Database)                      │
└─────────────────────────────────────────────────────────┘
```

### Components

- **Frontend:** React 18, Redux, Material-UI, WebSocket
- **Backend:** Java 17, Spring Boot 3, Spring Security, JWT
- **Database:** MySQL 8.0, InnoDB
- **Infrastructure:** Docker, Docker Compose

---

## 📦 Prerequisites

- **Docker:** 24.x or higher
- **Docker Compose:** 2.x or higher
- **Git:** To clone the repository

**Verify installation:**
```bash
docker --version
docker-compose --version
git --version
```

---

## 🚀 Installation

### 1. Clone the Repository

```bash
git clone https://github.com/your-user/vares-pos.git
cd vares-pos
```

### 2. Configure Environment Variables

```bash
cp .env.example .env
```

Edit `.env` with your configurations:

```env
# Database
MYSQL_ROOT_PASSWORD=root_password
MYSQL_DATABASE=vares_pos
MYSQL_USER=vares_user
MYSQL_PASSWORD=vares_pass

# Backend
JWT_SECRET=your_jwt_secret_here
SPRING_PROFILE=prod

# Frontend
VITE_API_URL=http://localhost:8080/api
VITE_WS_URL=ws://localhost:8080/ws
```

### 3. Start the System

```bash
./scripts/start.sh
```

This script:
- ✅ Verifies dependencies
- ✅ Builds Docker images
- ✅ Starts the 3 containers
- ✅ Waits for services to be ready
- ✅ Shows access URLs

### 4. Initialize the Database

```bash
./scripts/init-db.sh
```

This script:
- ✅ Creates table structure
- ✅ Inserts initial data
- ✅ Creates triggers and stored procedures
- ✅ Creates views
- ✅ Creates superuser

### 5. Access the System

**Frontend:** http://localhost:3000  
**Backend API:** http://localhost:8080  
**Database:** localhost:3306

**Default credentials:**
- Email: `admin@vares.com`
- Password: `admin123`

⚠️ **Important:** Change the password on first login.

---

## 💻 Usage

### Start the System

```bash
./scripts/start.sh
```

### Stop the System

```bash
./scripts/stop.sh
```

### View Logs

```bash
# All services
docker-compose logs -f

# Backend only
docker-compose logs -f backend

# Frontend only
docker-compose logs -f frontend

# Database only
docker-compose logs -f database
```

### Verify System Status

```bash
./scripts/health-check.sh
```

### Manual Backup

```bash
./scripts/backup.sh
```

### Restore Backup

```bash
./scripts/restore.sh
```

---

## 📚 Documentation

Complete documentation is in the `/docs` folder:

### Functional Documentation (Spanish)

- **[01_ANALISIS_FUNCIONAL.md](docs/01_ANALISIS_FUNCIONAL.md)**
  - Detailed use cases
  - Business rules
  - Operational flows
  - Permission matrix

- **[02_ALGORITMO_MESAS.md](docs/02_ALGORITMO_MESAS.md)**
  - Table assignment algorithm
  - Complete pseudocode
  - Practical examples
  - Complexity analysis

### Technical Documentation (English Code)

- **[03_MODELO_BASE_DATOS.md](docs/03_MODELO_BASE_DATOS.md)**
  - Complete ER diagram
  - 15 relational tables (English names)
  - Triggers and stored procedures
  - Optimized indexes

- **[04_ARQUITECTURA_SISTEMA.md](docs/04_ARQUITECTURA_SISTEMA.md)**
  - 3-layer architecture
  - 8 backend modules
  - REST API specification
  - Docker configuration

- **[05_SCRIPTS_AUTOMATIZACION.md](docs/05_SCRIPTS_AUTOMATIZACION.md)**
  - Start/stop scripts
  - DB initialization script
  - Automatic backup script
  - Cron configuration

### Project Documentation (Spanish)

- **[06_PLAN_IMPLEMENTACION.md](docs/06_PLAN_IMPLEMENTACION.md)**
  - 6 development phases
  - Estimation: 12-16 weeks
  - Milestones and deliverables
  - Risks and mitigations

- **[07_MANUAL_USUARIO.md](docs/07_MANUAL_USUARIO.md)**
  - Complete guide per role
  - Practical use cases
  - Frequently asked questions
  - Troubleshooting

---

## 📁 Project Structure

```
vares-pos/
├── docs/                           # Complete documentation
│   ├── 01_ANALISIS_FUNCIONAL.md
│   ├── 02_ALGORITMO_MESAS.md
│   ├── 03_MODELO_BASE_DATOS.md    # English DB schema
│   ├── 04_ARQUITECTURA_SISTEMA.md  # English code
│   ├── 05_SCRIPTS_AUTOMATIZACION.md
│   ├── 06_PLAN_IMPLEMENTACION.md
│   └── 07_MANUAL_USUARIO.md
├── scripts/                        # Automation scripts
│   ├── start.sh
│   ├── stop.sh
│   ├── init-db.sh
│   ├── backup.sh
│   ├── restore.sh
│   ├── install-cron.sh
│   ├── health-check.sh
│   └── sql/
│       ├── 01_create_tables.sql
│       ├── 02_insert_initial_data.sql
│       ├── 03_create_triggers.sql
│       └── 04_create_views.sql
├── vares-backend/                  # Spring Boot Backend
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/
│   │   │   │   └── com/vares/pos/
│   │   │   │       ├── controller/
│   │   │   │       ├── service/
│   │   │   │       ├── repository/
│   │   │   │       ├── model/
│   │   │   │       │   ├── entity/
│   │   │   │       │   └── dto/
│   │   │   │       ├── security/
│   │   │   │       └── util/
│   │   │   └── resources/
│   │   └── test/
│   ├── pom.xml
│   └── Dockerfile
├── vares-frontend/                 # React Frontend
│   ├── src/
│   │   ├── components/
│   │   │   ├── tables/
│   │   │   │   ├── FloorMap.jsx
│   │   │   │   ├── TableCard.jsx
│   │   │   │   └── TableJoin.jsx
│   │   │   ├── orders/
│   │   │   │   ├── OrderForm.jsx
│   │   │   │   └── OrderList.jsx
│   │   │   └── kitchen/
│   │   │       └── KitchenDisplay.jsx
│   │   ├── pages/
│   │   ├── services/
│   │   ├── store/
│   │   └── utils/
│   ├── package.json
│   └── Dockerfile
├── docker-compose.yml
├── .env.example
├── .gitignore
├── LICENSE
└── README.md
```

---

## 🛠️ Technologies

### Frontend
- **Framework:** React 18.x
- **State:** Redux Toolkit
- **UI:** Material-UI / Ant Design
- **Styles:** Tailwind CSS
- **Build:** Vite
- **WebSocket:** Socket.io-client

### Backend
- **Language:** Java 17 LTS
- **Framework:** Spring Boot 3.x
- **Security:** Spring Security + JWT
- **ORM:** Spring Data JPA
- **Database:** MySQL 8.0
- **WebSocket:** Spring WebSocket
- **Build:** Maven

### DevOps
- **Containers:** Docker 24.x
- **Orchestration:** Docker Compose
- **CI/CD:** GitHub Actions
- **Proxy:** Nginx

---

## 🔧 Development

### Setup Development Environment

#### Backend

```bash
cd vares-backend

# Install dependencies
mvn clean install

# Run tests
mvn test

# Run in development mode
mvn spring-boot:run
```

#### Frontend

```bash
cd vares-frontend

# Install dependencies
npm install

# Run in development mode
npm run dev

# Run tests
npm test

# Build for production
npm run build
```

---

## 🔐 Security

### Authentication

- JWT (JSON Web Tokens) with 24-hour expiration
- Passwords hashed with BCrypt (factor 10)
- Refresh tokens for automatic renewal

### Authorization

- Role-based access control (RBAC)
- Granular permissions per endpoint
- Validation in frontend and backend

### Audit

- Logging of all critical operations
- Storage of source IP
- Log retention for 1 year

---

## 📊 Backups

### Automatic Backup

The system performs automatic daily backups:

- **Frequency:** Every day at 2:00 AM
- **Retention:** 7 days
- **Location:** `/var/backups/vares-pos/`
- **Format:** Compressed tar.gz

### Configure Automatic Backup

```bash
sudo ./scripts/install-cron.sh
```

### Verify Backups

```bash
# List backups
ls -lh /var/backups/vares-pos/

# View backup log
sudo tail -f /var/log/vares-backup.log
```

---

## 🐛 Troubleshooting

### System won't start

```bash
# Verify Docker
docker info

# Check logs
docker-compose logs

# Restart services
./scripts/stop.sh
./scripts/start.sh
```

### Database won't connect

```bash
# Check container status
docker-compose ps database

# View database logs
docker-compose logs database

# Restart database only
docker-compose restart database
```

### Frontend won't load

```bash
# Check frontend logs
docker-compose logs frontend

# Rebuild image
docker-compose build frontend
docker-compose up -d frontend
```

---

## 📈 Metrics and Monitoring

### Health Check

```bash
./scripts/health-check.sh
```

### System Metrics

- **API response time:** < 500ms (p95)
- **Frontend load time:** < 3s
- **Availability:** > 99.5%
- **Test coverage:** > 80%

---

## 🤝 Contributing

### Contribution Process

1. Fork the repository
2. Create a branch for your feature (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Style Guide

- **Java:** Google Java Style Guide
- **JavaScript/React:** Airbnb JavaScript Style Guide
- **Commits:** Conventional Commits

### Report Bugs

Use GitHub Issues with the bug report template.

---

## 📝 License

This project is under the MIT License. See the [LICENSE](LICENSE) file for more details.

---

## 👥 Team

- **Architect/Tech Lead:** [Name]
- **Backend Developers:** [Names]
- **Frontend Developers:** [Names]
- **DevOps Engineer:** [Name]
- **QA Engineer:** [Name]
- **Product Owner:** [Name]

---

## 📞 Contact

- **Email:** support@vares.com
- **Website:** https://vares.com
- **Documentation:** https://docs.vares.com

---

## 🙏 Acknowledgments

- All project contributors
- Spring Boot and React community
- Beta testers who helped improve the system

---

## 🗺️ Roadmap

### Version 1.0 (Current)
- ✅ Table and reservation management
- ✅ Order system
- ✅ Kitchen display
- ✅ Payment processing
- ✅ User management

### Version 1.1 (Next)
- [ ] Payment system integration (Mercado Pago, Stripe)
- [ ] Native mobile app
- [ ] Loyalty system

### Version 2.0 (Future)
- [ ] Inventory management
- [ ] Advanced BI reports
- [ ] Delivery integration
- [ ] Multi-location (franchises)

---

## 📌 Naming Conventions

### Database (MySQL)
- **Tables:** snake_case, plural (users, orders, order_items)
- **Columns:** snake_case (created_at, party_size, table_id)
- **Enums:** UPPER_CASE (AVAILABLE, IN_PROGRESS, FOOD)

### Backend (Java)
- **Classes:** PascalCase (User, Table, Order, OrderItem)
- **Methods:** camelCase (openTable, closeOrder, assignTables)
- **Variables:** camelCase (userId, tableId, partySize)

### Frontend (React)
- **Components:** PascalCase (FloorMap, TableCard, OrderList)
- **Functions:** camelCase (fetchTables, updateStatus)
- **Variables:** camelCase (availableTables, selectedZone)

---

## ⭐ If you like this project, give it a star on GitHub!

---

**Created with ❤️ by the VARES team**

**Last update:** 2026-01-05
