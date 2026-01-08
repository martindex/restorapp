# 🏗️ ARQUITECTURA HÍBRIDA - VARES POS

## 📋 ARQUITECTURA ACTUAL

Debido a limitaciones de conectividad con repositorios Maven desde Docker, el sistema usa una **arquitectura híbrida**:

---

## 🐳 SERVICIOS

### 1. MySQL Database (Docker)
- **Contenedor**: `vares-mysql` 
- **Puerto**: 3306
- **Estado**: ✅ Corriendo en Docker
- **Volúmenes**: Datos y logs persistentes

### 2. Spring Boot Backend (Local)
- **Puerto**: 8080 (API), 5005 (Debug)
- **Estado**: ✅ Corriendo localmente con Maven
- **Comando**: `cd vares-backend && mvn spring-boot:run`

### 3. React Frontend (Local)
- **Puerto**: 3000
- **Estado**: ✅ Corriendo localmente con npm
- **Comando**: `cd vares-frontend && npm run dev`

---

## 🚀 CÓMO USAR EL SISTEMA

### Opción 1: Sistema Ya Corriendo (ACTUAL)

Si ya tienes todo corriendo (como ahora):

```bash
# Verificar estado
docker ps                    # Ver MySQL
ps aux | grep mvn           # Ver backend
ps aux | grep npm           # Ver frontend

# Acceder al sistema
http://localhost:3000
```

### Opción 2: Iniciar desde Cero

```bash
# 1. Iniciar MySQL en Docker
docker-compose up -d mysql

# 2. Esperar a que MySQL esté listo
docker-compose exec mysql mysqladmin ping -h localhost -u root -proot_password

# 3. Inicializar base de datos (solo primera vez)
./scripts/init-db.sh

# 4. Iniciar backend (en una terminal)
cd vares-backend
mvn spring-boot:run

# 5. Iniciar frontend (en otra terminal)
cd vares-frontend
npm install  # solo primera vez
npm run dev
```

---

## 🛑 DETENER EL SISTEMA

```bash
# Detener MySQL
docker-compose down

# Detener backend y frontend
# Presiona Ctrl+C en cada terminal
# O usa:
pkill -f "mvn spring-boot:run"
pkill -f "npm run dev"
```

---

## 📊 ESTADO ACTUAL

```
✅ MySQL (Docker)     - Puerto 3306 - CORRIENDO
✅ Backend (Local)    - Puerto 8080 - CORRIENDO  
✅ Frontend (Local)   - Puerto 3000 - CORRIENDO
```

---

## 🔐 CREDENCIALES

**Usuario Admin:**
- Email: `admin@vares.com`
- Password: `admin123`

**Base de Datos:**
- Host: `localhost:3306`
- Database: `vares_pos`
- User: `vares_user`
- Password: `vares_pass`

---

## 💡 POR QUÉ ESTA ARQUITECTURA

### Ventajas:
- ✅ **MySQL aislado** en Docker (fácil de resetear)
- ✅ **Hot-reload** inmediato en backend y frontend
- ✅ **Debug fácil** con tu IDE
- ✅ **Sin problemas de conectividad** de Maven/npm
- ✅ **Desarrollo rápido** sin reconstruir contenedores

### Desventajas:
- ⚠️ Requiere Java 17 y Node.js instalados
- ⚠️ No es completamente portable

---

## 🔄 MIGRAR A DOCKER COMPLETO (Futuro)

Cuando tengas mejor conectividad a internet:

1. Construir imágenes con cache local de Maven
2. Usar un mirror de Maven Repository
3. O pre-descargar dependencias

---

## 📝 COMANDOS ÚTILES

### MySQL (Docker)
```bash
# Ver logs
docker-compose logs -f mysql

# Conectarse a MySQL
docker-compose exec mysql mysql -u root -proot_password vares_pos

# Backup
docker-compose exec mysql mysqldump -u root -proot_password vares_pos > backup.sql

# Restore
docker-compose exec -i mysql mysql -u root -proot_password vares_pos < backup.sql
```

### Backend (Local)
```bash
# Ver logs en tiempo real
cd vares-backend && mvn spring-boot:run

# Compilar sin ejecutar
mvn clean package -DskipTests

# Health check
curl http://localhost:8080/actuator/health
```

### Frontend (Local)
```bash
# Desarrollo
npm run dev

# Build producción
npm run build

# Preview build
npm run preview
```

---

## ✅ VERIFICACIÓN RÁPIDA

```bash
# 1. MySQL
docker ps | grep vares-mysql

# 2. Backend
curl http://localhost:8080/actuator/health

# 3. Frontend
curl -I http://localhost:3000

# 4. Login
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@vares.com","password":"admin123"}'
```

---

**Última actualización**: 2026-01-08  
**Arquitectura**: Híbrida (MySQL Docker + Backend/Frontend Local)  
**Estado**: ✅ Funcional y Óptimo para Desarrollo
