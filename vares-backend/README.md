# VARES POS - Backend

Spring Boot backend for the VARES Point of Sale system.

## Technology Stack

- **Java**: 17 LTS
- **Framework**: Spring Boot 3.2.1
- **Database**: MySQL 8.0
- **Security**: Spring Security + JWT
- **ORM**: Spring Data JPA
- **Build Tool**: Maven

## Project Structure

```
src/main/java/com/vares/pos/
├── config/              # Configuration classes
│   ├── SecurityConfig.java
│   └── CorsConfig.java
├── controller/          # REST API controllers
│   └── AuthController.java
├── service/             # Business logic
│   └── AuthService.java
├── repository/          # JPA repositories
│   ├── UserRepository.java
│   ├── RoleRepository.java
│   └── ...
├── model/
│   ├── entity/          # JPA entities
│   │   ├── User.java
│   │   ├── Role.java
│   │   ├── TableEntity.java
│   │   ├── Order.java
│   │   └── ...
│   └── dto/             # Data Transfer Objects
│       ├── LoginRequest.java
│       └── LoginResponse.java
├── security/            # Security components
│   ├── JwtTokenProvider.java
│   ├── JwtAuthenticationFilter.java
│   └── CustomUserDetailsService.java
└── VaresPosApplication.java
```

## API Endpoints

### Authentication
- `POST /api/auth/login` - User login
- `GET /api/auth/me` - Get current user
- `POST /api/auth/logout` - Logout

### Health Check
- `GET /api/actuator/health` - Application health status

## Running Locally

### Prerequisites
- Java 17
- Maven 3.9+
- MySQL 8.0

### Steps

1. **Configure database** in `application.properties`

2. **Build the project**:
```bash
mvn clean install
```

3. **Run the application**:
```bash
mvn spring-boot:run
```

The API will be available at `http://localhost:8080/api`

## Running with Docker

The backend is containerized and runs as part of the docker-compose setup.

See main README for instructions.

## Default Credentials

- **Email**: admin@vares.com
- **Password**: admin123

⚠️ **Change these credentials in production!**

## Environment Variables

- `SPRING_DATASOURCE_URL` - Database connection URL
- `SPRING_DATASOURCE_USERNAME` - Database username
- `SPRING_DATASOURCE_PASSWORD` - Database password
- `JWT_SECRET` - Secret key for JWT signing (min 32 characters)
- `JWT_EXPIRATION` - Token expiration time in milliseconds

## Security

- Passwords are hashed using BCrypt
- JWT tokens expire after 24 hours
- CORS is configured for frontend communication
- All endpoints except `/auth/**` require authentication

## Database Schema

The application uses the following main entities:
- Users & Roles
- Zones & Tables
- Customers & Reservations
- Categories & Products
- Orders & OrderItems
- Payments

See `/docs/03_MODELO_BASE_DATOS.md` for complete schema.
