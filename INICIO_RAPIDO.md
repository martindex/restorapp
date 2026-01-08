# 🚀 GUÍA DE INICIO RÁPIDO - VARES POS

Esta guía te ayudará a poner en marcha el sistema VARES POS en minutos.

---

## ⚡ Inicio Rápido (Docker)

### Requisitos Previos
- Docker 24.x o superior
- Docker Compose 2.x o superior
- 4GB de RAM disponible
- 10GB de espacio en disco

### Pasos

#### 1. Verificar Requisitos
```bash
docker --version
docker-compose --version
```

#### 2. Iniciar el Sistema
```bash
./scripts/start.sh
```

Este script:
- ✅ Verifica dependencias
- ✅ Construye las imágenes Docker
- ✅ Inicia los 3 servicios (Database, Backend, Frontend)
- ✅ Espera a que estén listos

**Tiempo estimado**: 3-5 minutos (primera vez)

#### 3. Inicializar la Base de Datos
```bash
./scripts/init-db.sh
```

Este script:
- ✅ Crea la estructura de 15 tablas
- ✅ Inserta datos iniciales (roles, admin, zonas, mesas, productos)
- ✅ Crea triggers y stored procedures
- ✅ Crea vistas

**Tiempo estimado**: 30 segundos

#### 4. Acceder al Sistema

**Frontend (Aplicación Web)**:
- URL: http://localhost:3000
- Email: `admin@vares.com`
- Password: `admin123`

**Backend (API)**:
- URL: http://localhost:8080/api
- Health Check: http://localhost:8080/api/actuator/health

**Base de Datos**:
- Host: `localhost`
- Puerto: `3306`
- Database: `vares_pos`
- Usuario: `vares_user`
- Password: `vares_pass`

---

## 🛑 Detener el Sistema

```bash
./scripts/stop.sh
```

---

## 🔄 Reiniciar el Sistema

```bash
./scripts/stop.sh
./scripts/start.sh
```

---

## 📊 Ver Logs

### Todos los servicios
```bash
docker-compose logs -f
```

### Solo Backend
```bash
docker-compose logs -f backend
```

### Solo Frontend
```bash
docker-compose logs -f frontend
```

### Solo Base de Datos
```bash
docker-compose logs -f database
```

---

## 🧪 Verificar Estado del Sistema

```bash
# Ver contenedores corriendo
docker-compose ps

# Ver uso de recursos
docker stats

# Verificar salud del backend
curl http://localhost:8080/api/actuator/health
```

---

## 🐛 Solución de Problemas

### El sistema no inicia

**Problema**: Docker no está corriendo
```bash
# Verificar Docker
docker info

# Si falla, iniciar Docker Desktop o el servicio Docker
```

**Problema**: Puerto 3000, 8080 o 3306 ya está en uso
```bash
# Ver qué proceso usa el puerto
lsof -i :3000
lsof -i :8080
lsof -i :3306

# Detener el proceso o cambiar el puerto en .env
```

### La base de datos no se conecta

```bash
# Ver logs de la base de datos
docker-compose logs database

# Reiniciar solo la base de datos
docker-compose restart database

# Esperar 10 segundos y verificar
docker-compose exec database mysqladmin ping -h localhost -u root -proot_password
```

### El backend no responde

```bash
# Ver logs del backend
docker-compose logs backend

# Verificar que la base de datos esté lista
docker-compose exec database mysqladmin ping -h localhost -u root -proot_password

# Reiniciar backend
docker-compose restart backend
```

### El frontend no carga

```bash
# Ver logs del frontend
docker-compose logs frontend

# Reconstruir la imagen del frontend
docker-compose build frontend
docker-compose up -d frontend
```

### Limpiar y empezar de cero

```bash
# Detener y eliminar todo
docker-compose down -v

# Eliminar imágenes
docker-compose down --rmi all

# Volver a iniciar
./scripts/start.sh
./scripts/init-db.sh
```

---

## 📱 Acceso desde otros dispositivos

Para acceder desde otros dispositivos en la misma red:

1. Obtén tu IP local:
```bash
# Linux/Mac
ifconfig | grep "inet "

# Windows
ipconfig
```

2. Accede desde otro dispositivo:
```
http://TU_IP:3000
```

Ejemplo: `http://192.168.1.100:3000`

---

## 🔐 Cambiar Credenciales

### Cambiar Password del Admin

1. Accede al sistema con las credenciales por defecto
2. Ve a tu perfil
3. Cambia la contraseña

O directamente en la base de datos:
```bash
docker-compose exec database mysql -u root -proot_password vares_pos

# Generar hash BCrypt de tu nueva password en: https://bcrypt-generator.com/
# Luego ejecutar:
UPDATE users SET password_hash = 'TU_HASH_BCRYPT' WHERE email = 'admin@vares.com';
```

### Cambiar Credenciales de Base de Datos

1. Edita el archivo `.env`
2. Cambia `MYSQL_ROOT_PASSWORD`, `MYSQL_PASSWORD`
3. Reinicia el sistema:
```bash
./scripts/stop.sh
docker-compose down -v
./scripts/start.sh
./scripts/init-db.sh
```

---

## 📚 Próximos Pasos

Después de iniciar el sistema:

1. **Explorar el Dashboard**
   - Inicia sesión con las credenciales por defecto
   - Explora las diferentes secciones

2. **Revisar la Documentación**
   - Lee `/docs/01_ANALISIS_FUNCIONAL.md` para entender el sistema
   - Revisa `/docs/07_MANUAL_USUARIO.md` para guías de uso

3. **Probar Funcionalidades**
   - La autenticación está completamente funcional
   - El dashboard muestra las opciones según el rol

4. **Desarrollo**
   - Lee `ESTADO_PROYECTO.md` para ver qué está implementado
   - Revisa los READMEs de backend y frontend para desarrollo local

---

## 🆘 Ayuda

- **Documentación completa**: Ver carpeta `/docs`
- **Estado del proyecto**: Ver `ESTADO_PROYECTO.md`
- **Issues conocidos**: Ver `ESTADO_PROYECTO.md`

---

## ✅ Checklist de Verificación

Después de iniciar, verifica que todo funcione:

- [ ] Los 3 contenedores están corriendo (`docker-compose ps`)
- [ ] El frontend carga en http://localhost:3000
- [ ] Puedes hacer login con admin@vares.com / admin123
- [ ] El dashboard muestra las opciones del menú
- [ ] El backend responde en http://localhost:8080/api/actuator/health
- [ ] La base de datos acepta conexiones

Si todos los checks están ✅, ¡el sistema está listo!

---

**¡Bienvenido a VARES POS!** 🍽️
