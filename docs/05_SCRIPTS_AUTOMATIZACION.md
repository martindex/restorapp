# SCRIPTS DE AUTOMATIZACIÓN - SISTEMA VARES POS
## Scripts de Inicio, Inicialización y Backup

---

## 1. SCRIPT DE INICIO DEL SISTEMA

### 1.1 start.sh

**Ubicación:** `/scripts/start.sh`

**Propósito:** Levantar los 3 servicios (Frontend, Backend, Database) con Docker Compose

```bash
#!/bin/bash

# ============================================
# SCRIPT DE INICIO DEL SISTEMA VARES POS
# ============================================

set -e  # Salir si algún comando falla

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  INICIANDO SISTEMA VARES POS${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# Verificar que Docker esté instalado
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: Docker no está instalado${NC}"
    echo "Por favor instale Docker desde: https://docs.docker.com/get-docker/"
    exit 1
fi

# Verificar que Docker Compose esté instalado
if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}Error: Docker Compose no está instalado${NC}"
    echo "Por favor instale Docker Compose desde: https://docs.docker.com/compose/install/"
    exit 1
fi

# Verificar que Docker esté corriendo
if ! docker info &> /dev/null; then
    echo -e "${RED}Error: Docker no está corriendo${NC}"
    echo "Por favor inicie el servicio de Docker"
    exit 1
fi

echo -e "${YELLOW}[1/5] Verificando archivos de configuración...${NC}"
if [ ! -f "docker-compose.yml" ]; then
    echo -e "${RED}Error: No se encontró docker-compose.yml${NC}"
    exit 1
fi

if [ ! -f ".env" ]; then
    echo -e "${YELLOW}Advertencia: No se encontró .env, copiando desde .env.example${NC}"
    if [ -f ".env.example" ]; then
        cp .env.example .env
        echo -e "${GREEN}Archivo .env creado. Por favor revise las configuraciones.${NC}"
    else
        echo -e "${RED}Error: No se encontró .env.example${NC}"
        exit 1
    fi
fi

echo -e "${YELLOW}[2/5] Deteniendo contenedores existentes (si los hay)...${NC}"
docker-compose down 2>/dev/null || true

echo -e "${YELLOW}[3/5] Construyendo imágenes Docker...${NC}"
docker-compose build --no-cache

echo -e "${YELLOW}[4/5] Iniciando servicios...${NC}"
docker-compose up -d

echo -e "${YELLOW}[5/5] Esperando que los servicios estén listos...${NC}"

# Esperar a que la base de datos esté lista
echo -n "Esperando base de datos..."
for i in {1..30}; do
    if docker-compose exec -T database mysqladmin ping -h localhost -u root -proot_password &> /dev/null; then
        echo -e " ${GREEN}✓${NC}"
        break
    fi
    echo -n "."
    sleep 2
    if [ $i -eq 30 ]; then
        echo -e " ${RED}✗${NC}"
        echo -e "${RED}Error: La base de datos no respondió a tiempo${NC}"
        docker-compose logs database
        exit 1
    fi
done

# Esperar a que el backend esté listo
echo -n "Esperando backend..."
for i in {1..60}; do
    if curl -s http://localhost:8080/actuator/health &> /dev/null; then
        echo -e " ${GREEN}✓${NC}"
        break
    fi
    echo -n "."
    sleep 2
    if [ $i -eq 60 ]; then
        echo -e " ${RED}✗${NC}"
        echo -e "${RED}Error: El backend no respondió a tiempo${NC}"
        docker-compose logs backend
        exit 1
    fi
done

# Esperar a que el frontend esté listo
echo -n "Esperando frontend..."
for i in {1..30}; do
    if curl -s http://localhost:3000 &> /dev/null; then
        echo -e " ${GREEN}✓${NC}"
        break
    fi
    echo -n "."
    sleep 2
    if [ $i -eq 30 ]; then
        echo -e " ${RED}✗${NC}"
        echo -e "${RED}Error: El frontend no respondió a tiempo${NC}"
        docker-compose logs frontend
        exit 1
    fi
done

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  SISTEMA INICIADO CORRECTAMENTE${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "Servicios disponibles:"
echo -e "  ${GREEN}•${NC} Frontend:  http://localhost:3000"
echo -e "  ${GREEN}•${NC} Backend:   http://localhost:8080"
echo -e "  ${GREEN}•${NC} Database:  localhost:3306"
echo ""
echo -e "Credenciales por defecto:"
echo -e "  ${GREEN}•${NC} Email:     admin@vares.com"
echo -e "  ${GREEN}•${NC} Password:  admin123"
echo ""
echo -e "Para ver los logs:"
echo -e "  ${YELLOW}docker-compose logs -f${NC}"
echo ""
echo -e "Para detener el sistema:"
echo -e "  ${YELLOW}./scripts/stop.sh${NC}"
echo ""
```

**Permisos:**
```bash
chmod +x scripts/start.sh
```

**Uso:**
```bash
./scripts/start.sh
```

---

### 1.2 stop.sh

**Ubicación:** `/scripts/stop.sh`

**Propósito:** Detener todos los servicios

```bash
#!/bin/bash

# ============================================
# SCRIPT DE DETENCIÓN DEL SISTEMA VARES POS
# ============================================

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Deteniendo servicios...${NC}"
docker-compose down

echo -e "${GREEN}Sistema detenido correctamente${NC}"
```

**Permisos:**
```bash
chmod +x scripts/stop.sh
```

---

## 2. SCRIPT DE INICIALIZACIÓN DE BASE DE DATOS

### 2.1 init-db.sh

**Ubicación:** `/scripts/init-db.sh`

**Propósito:** Poblar la base de datos con datos iniciales

```bash
#!/bin/bash

# ============================================
# SCRIPT DE INICIALIZACIÓN DE BASE DE DATOS
# Sistema VARES POS
# ============================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  INICIALIZANDO BASE DE DATOS${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# Variables de conexión
DB_HOST="localhost"
DB_PORT="3306"
DB_NAME="vares_pos"
DB_USER="vares_user"
DB_PASS="vares_pass"
DB_ROOT_PASS="root_password"

# Verificar que MySQL esté corriendo
echo -e "${YELLOW}[1/6] Verificando conexión a base de datos...${NC}"
if ! docker-compose exec -T database mysqladmin ping -h localhost -u root -p${DB_ROOT_PASS} &> /dev/null; then
    echo -e "${RED}Error: No se puede conectar a la base de datos${NC}"
    echo "Asegúrese de que el sistema esté corriendo: ./scripts/start.sh"
    exit 1
fi
echo -e "${GREEN}✓ Conexión exitosa${NC}"

# Crear base de datos si no existe
echo -e "${YELLOW}[2/6] Creando base de datos...${NC}"
docker-compose exec -T database mysql -u root -p${DB_ROOT_PASS} <<EOF
CREATE DATABASE IF NOT EXISTS ${DB_NAME}
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;
EOF
echo -e "${GREEN}✓ Base de datos creada${NC}"

# Ejecutar script de creación de tablas
echo -e "${YELLOW}[3/6] Creando estructura de tablas...${NC}"
if [ -f "scripts/sql/01_create_tables.sql" ]; then
    docker-compose exec -T database mysql -u root -p${DB_ROOT_PASS} ${DB_NAME} < scripts/sql/01_create_tables.sql
    echo -e "${GREEN}✓ Tablas creadas${NC}"
else
    echo -e "${RED}Error: No se encontró scripts/sql/01_create_tables.sql${NC}"
    exit 1
fi

# Insertar datos iniciales
echo -e "${YELLOW}[4/6] Insertando datos iniciales...${NC}"
if [ -f "scripts/sql/02_insert_initial_data.sql" ]; then
    docker-compose exec -T database mysql -u root -p${DB_ROOT_PASS} ${DB_NAME} < scripts/sql/02_insert_initial_data.sql
    echo -e "${GREEN}✓ Datos iniciales insertados${NC}"
else
    echo -e "${RED}Error: No se encontró scripts/sql/02_insert_initial_data.sql${NC}"
    exit 1
fi

# Crear triggers y stored procedures
echo -e "${YELLOW}[5/6] Creando triggers y stored procedures...${NC}"
if [ -f "scripts/sql/03_create_triggers.sql" ]; then
    docker-compose exec -T database mysql -u root -p${DB_ROOT_PASS} ${DB_NAME} < scripts/sql/03_create_triggers.sql
    echo -e "${GREEN}✓ Triggers y procedures creados${NC}"
else
    echo -e "${YELLOW}Advertencia: No se encontró scripts/sql/03_create_triggers.sql${NC}"
fi

# Crear vistas
echo -e "${YELLOW}[6/6] Creando vistas...${NC}"
if [ -f "scripts/sql/04_create_views.sql" ]; then
    docker-compose exec -T database mysql -u root -p${DB_ROOT_PASS} ${DB_NAME} < scripts/sql/04_create_views.sql
    echo -e "${GREEN}✓ Vistas creadas${NC}"
else
    echo -e "${YELLOW}Advertencia: No se encontró scripts/sql/04_create_views.sql${NC}"
fi

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  BASE DE DATOS INICIALIZADA${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "Datos de conexión:"
echo -e "  ${GREEN}•${NC} Host:     ${DB_HOST}"
echo -e "  ${GREEN}•${NC} Puerto:   ${DB_PORT}"
echo -e "  ${GREEN}•${NC} Database: ${DB_NAME}"
echo -e "  ${GREEN}•${NC} Usuario:  ${DB_USER}"
echo ""
echo -e "Usuario superusuario creado:"
echo -e "  ${GREEN}•${NC} Email:    admin@vares.com"
echo -e "  ${GREEN}•${NC} Password: admin123"
echo ""
```

**Permisos:**
```bash
chmod +x scripts/init-db.sh
```

**Uso:**
```bash
./scripts/init-db.sh
```

---

## 3. SCRIPT DE BACKUP AUTOMÁTICO

### 3.1 backup.sh

**Ubicación:** `/scripts/backup.sh`

**Propósito:** Realizar backup diario de la base de datos con retención de 7 días

```bash
#!/bin/bash

# ============================================
# SCRIPT DE BACKUP AUTOMÁTICO
# Sistema VARES POS
# Retención: 7 días
# ============================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Configuración
BACKUP_DIR="/var/backups/vares-pos"
DB_NAME="vares_pos"
DB_USER="root"
DB_PASS="root_password"
RETENTION_DAYS=7
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="vares_pos_backup_${DATE}.sql"
BACKUP_ZIP="vares_pos_backup_${DATE}.tar.gz"

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  INICIANDO BACKUP${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# Crear directorio de backups si no existe
echo -e "${YELLOW}[1/5] Preparando directorio de backups...${NC}"
mkdir -p ${BACKUP_DIR}
echo -e "${GREEN}✓ Directorio listo: ${BACKUP_DIR}${NC}"

# Verificar que el contenedor de base de datos esté corriendo
echo -e "${YELLOW}[2/5] Verificando estado de la base de datos...${NC}"
if ! docker-compose ps | grep -q "vares-db.*Up"; then
    echo -e "${RED}Error: El contenedor de base de datos no está corriendo${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Base de datos activa${NC}"

# Realizar backup de la base de datos
echo -e "${YELLOW}[3/5] Realizando backup de la base de datos...${NC}"
docker-compose exec -T database mysqldump \
    -u ${DB_USER} \
    -p${DB_PASS} \
    --single-transaction \
    --routines \
    --triggers \
    --events \
    ${DB_NAME} > ${BACKUP_DIR}/${BACKUP_FILE}

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Backup de base de datos completado${NC}"
    echo -e "  Archivo: ${BACKUP_FILE}"
    echo -e "  Tamaño: $(du -h ${BACKUP_DIR}/${BACKUP_FILE} | cut -f1)"
else
    echo -e "${RED}Error: Falló el backup de la base de datos${NC}"
    exit 1
fi

# Backup de volúmenes Docker
echo -e "${YELLOW}[4/5] Realizando backup de volúmenes...${NC}"
cd ${BACKUP_DIR}
tar -czf ${BACKUP_ZIP} \
    ${BACKUP_FILE} \
    -C /var/lib/docker/volumes vares-pos_db_data/_data 2>/dev/null || true

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Backup de volúmenes completado${NC}"
    echo -e "  Archivo: ${BACKUP_ZIP}"
    echo -e "  Tamaño: $(du -h ${BACKUP_DIR}/${BACKUP_ZIP} | cut -f1)"
    
    # Eliminar archivo SQL temporal (ya está en el tar.gz)
    rm -f ${BACKUP_DIR}/${BACKUP_FILE}
else
    echo -e "${YELLOW}Advertencia: No se pudo incluir volúmenes en el backup${NC}"
    # Comprimir solo el SQL
    gzip ${BACKUP_DIR}/${BACKUP_FILE}
    mv ${BACKUP_DIR}/${BACKUP_FILE}.gz ${BACKUP_DIR}/${BACKUP_ZIP}
fi

# Eliminar backups antiguos (retención de 7 días)
echo -e "${YELLOW}[5/5] Eliminando backups antiguos (>${RETENTION_DAYS} días)...${NC}"
find ${BACKUP_DIR} -name "vares_pos_backup_*.tar.gz" -type f -mtime +${RETENTION_DAYS} -delete

DELETED_COUNT=$(find ${BACKUP_DIR} -name "vares_pos_backup_*.tar.gz" -type f -mtime +${RETENTION_DAYS} 2>/dev/null | wc -l)
echo -e "${GREEN}✓ Backups antiguos eliminados: ${DELETED_COUNT}${NC}"

# Listar backups existentes
BACKUP_COUNT=$(ls -1 ${BACKUP_DIR}/vares_pos_backup_*.tar.gz 2>/dev/null | wc -l)
echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  BACKUP COMPLETADO${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "Backup guardado en:"
echo -e "  ${GREEN}${BACKUP_DIR}/${BACKUP_ZIP}${NC}"
echo ""
echo -e "Total de backups almacenados: ${BACKUP_COUNT}"
echo -e "Espacio utilizado: $(du -sh ${BACKUP_DIR} | cut -f1)"
echo ""

# Registrar en log
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Backup completado: ${BACKUP_ZIP}" >> ${BACKUP_DIR}/backup.log
```

**Permisos:**
```bash
chmod +x scripts/backup.sh
```

**Uso manual:**
```bash
./scripts/backup.sh
```

---

### 3.2 restore.sh

**Ubicación:** `/scripts/restore.sh`

**Propósito:** Restaurar un backup específico

```bash
#!/bin/bash

# ============================================
# SCRIPT DE RESTAURACIÓN DE BACKUP
# Sistema VARES POS
# ============================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

BACKUP_DIR="/var/backups/vares-pos"
DB_NAME="vares_pos"
DB_USER="root"
DB_PASS="root_password"

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  RESTAURACIÓN DE BACKUP${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# Listar backups disponibles
echo -e "${YELLOW}Backups disponibles:${NC}"
echo ""
ls -lht ${BACKUP_DIR}/vares_pos_backup_*.tar.gz | awk '{print NR". "$9" ("$5", "$6" "$7" "$8")"}'
echo ""

# Solicitar selección
read -p "Ingrese el número del backup a restaurar (o 'q' para cancelar): " SELECTION

if [ "$SELECTION" = "q" ]; then
    echo "Restauración cancelada"
    exit 0
fi

# Obtener archivo seleccionado
BACKUP_FILE=$(ls -t ${BACKUP_DIR}/vares_pos_backup_*.tar.gz | sed -n "${SELECTION}p")

if [ -z "$BACKUP_FILE" ]; then
    echo -e "${RED}Error: Selección inválida${NC}"
    exit 1
fi

echo ""
echo -e "${YELLOW}Archivo seleccionado:${NC} $(basename $BACKUP_FILE)"
echo ""
echo -e "${RED}ADVERTENCIA: Esta operación sobrescribirá la base de datos actual${NC}"
read -p "¿Está seguro de continuar? (escriba 'SI' para confirmar): " CONFIRM

if [ "$CONFIRM" != "SI" ]; then
    echo "Restauración cancelada"
    exit 0
fi

# Descomprimir backup
echo -e "${YELLOW}[1/3] Descomprimiendo backup...${NC}"
TEMP_DIR=$(mktemp -d)
tar -xzf ${BACKUP_FILE} -C ${TEMP_DIR}
SQL_FILE=$(find ${TEMP_DIR} -name "*.sql" | head -1)

if [ -z "$SQL_FILE" ]; then
    echo -e "${RED}Error: No se encontró archivo SQL en el backup${NC}"
    rm -rf ${TEMP_DIR}
    exit 1
fi
echo -e "${GREEN}✓ Backup descomprimido${NC}"

# Detener backend temporalmente
echo -e "${YELLOW}[2/3] Deteniendo backend...${NC}"
docker-compose stop backend
echo -e "${GREEN}✓ Backend detenido${NC}"

# Restaurar base de datos
echo -e "${YELLOW}[3/3] Restaurando base de datos...${NC}"
docker-compose exec -T database mysql -u ${DB_USER} -p${DB_PASS} ${DB_NAME} < ${SQL_FILE}

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Base de datos restaurada${NC}"
else
    echo -e "${RED}Error: Falló la restauración${NC}"
    rm -rf ${TEMP_DIR}
    exit 1
fi

# Limpiar archivos temporales
rm -rf ${TEMP_DIR}

# Reiniciar backend
echo -e "${YELLOW}Reiniciando backend...${NC}"
docker-compose start backend
echo -e "${GREEN}✓ Backend reiniciado${NC}"

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  RESTAURACIÓN COMPLETADA${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
```

**Permisos:**
```bash
chmod +x scripts/restore.sh
```

---

## 4. CONFIGURACIÓN DE CRON

### 4.1 Instalación de Cron Job

**Archivo:** `/etc/cron.d/vares-backup`

```bash
# Backup diario a las 2:00 AM
0 2 * * * root /path/to/vares-pos/scripts/backup.sh >> /var/log/vares-backup.log 2>&1
```

**Instalación:**

```bash
# Crear archivo de cron
sudo nano /etc/cron.d/vares-backup

# Contenido:
0 2 * * * root /path/to/vares-pos/scripts/backup.sh >> /var/log/vares-backup.log 2>&1

# Dar permisos
sudo chmod 644 /etc/cron.d/vares-backup

# Reiniciar cron
sudo systemctl restart cron
```

**Verificar cron:**
```bash
# Ver logs de cron
sudo tail -f /var/log/vares-backup.log

# Listar cron jobs
sudo crontab -l
```

---

### 4.2 Script de Instalación de Cron

**Ubicación:** `/scripts/install-cron.sh`

```bash
#!/bin/bash

# ============================================
# SCRIPT DE INSTALACIÓN DE CRON JOB
# Sistema VARES POS
# ============================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  INSTALANDO CRON JOB${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# Verificar que se ejecute como root
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}Error: Este script debe ejecutarse como root${NC}"
    echo "Uso: sudo ./scripts/install-cron.sh"
    exit 1
fi

# Obtener ruta absoluta del proyecto
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKUP_SCRIPT="${PROJECT_DIR}/scripts/backup.sh"

# Verificar que el script de backup existe
if [ ! -f "$BACKUP_SCRIPT" ]; then
    echo -e "${RED}Error: No se encontró el script de backup${NC}"
    exit 1
fi

# Crear archivo de cron
CRON_FILE="/etc/cron.d/vares-backup"
echo -e "${YELLOW}Creando archivo de cron: ${CRON_FILE}${NC}"

cat > ${CRON_FILE} <<EOF
# Backup diario del sistema VARES POS
# Se ejecuta todos los días a las 2:00 AM

0 2 * * * root ${BACKUP_SCRIPT} >> /var/log/vares-backup.log 2>&1
EOF

# Dar permisos correctos
chmod 644 ${CRON_FILE}

# Reiniciar servicio de cron
echo -e "${YELLOW}Reiniciando servicio de cron...${NC}"
systemctl restart cron

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  CRON JOB INSTALADO${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "Configuración:"
echo -e "  ${GREEN}•${NC} Frecuencia: Diario a las 2:00 AM"
echo -e "  ${GREEN}•${NC} Script:     ${BACKUP_SCRIPT}"
echo -e "  ${GREEN}•${NC} Log:        /var/log/vares-backup.log"
echo ""
echo -e "Para ver el log de backups:"
echo -e "  ${YELLOW}sudo tail -f /var/log/vares-backup.log${NC}"
echo ""
```

**Permisos:**
```bash
chmod +x scripts/install-cron.sh
```

**Uso:**
```bash
sudo ./scripts/install-cron.sh
```

---

## 5. SCRIPT DE MONITOREO

### 5.1 health-check.sh

**Ubicación:** `/scripts/health-check.sh`

**Propósito:** Verificar el estado de todos los servicios

```bash
#!/bin/bash

# ============================================
# SCRIPT DE VERIFICACIÓN DE SALUD
# Sistema VARES POS
# ============================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  VERIFICACIÓN DE SALUD DEL SISTEMA${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# Función para verificar servicio
check_service() {
    SERVICE=$1
    URL=$2
    
    echo -n "Verificando ${SERVICE}... "
    
    if curl -s --max-time 5 ${URL} > /dev/null 2>&1; then
        echo -e "${GREEN}✓ OK${NC}"
        return 0
    else
        echo -e "${RED}✗ FALLO${NC}"
        return 1
    fi
}

# Verificar Docker
echo -n "Verificando Docker... "
if docker info > /dev/null 2>&1; then
    echo -e "${GREEN}✓ OK${NC}"
else
    echo -e "${RED}✗ FALLO${NC}"
    exit 1
fi

# Verificar contenedores
echo -n "Verificando contenedores... "
RUNNING=$(docker-compose ps | grep "Up" | wc -l)
EXPECTED=3

if [ $RUNNING -eq $EXPECTED ]; then
    echo -e "${GREEN}✓ OK (${RUNNING}/${EXPECTED})${NC}"
else
    echo -e "${RED}✗ FALLO (${RUNNING}/${EXPECTED})${NC}"
fi

# Verificar servicios
check_service "Base de datos" "http://localhost:3306" || true
check_service "Backend" "http://localhost:8080/actuator/health"
check_service "Frontend" "http://localhost:3000"

# Verificar espacio en disco
echo ""
echo -e "${YELLOW}Uso de disco:${NC}"
df -h | grep -E "Filesystem|/var/lib/docker"

# Verificar memoria
echo ""
echo -e "${YELLOW}Uso de memoria:${NC}"
free -h

# Verificar logs recientes
echo ""
echo -e "${YELLOW}Últimos errores en logs:${NC}"
docker-compose logs --tail=10 | grep -i error || echo "No se encontraron errores recientes"

echo ""
echo -e "${GREEN}Verificación completada${NC}"
```

**Permisos:**
```bash
chmod +x scripts/health-check.sh
```

---

## 6. RESUMEN DE SCRIPTS

| Script | Propósito | Frecuencia | Requiere Root |
|--------|-----------|------------|---------------|
| `start.sh` | Iniciar sistema | Manual | No |
| `stop.sh` | Detener sistema | Manual | No |
| `init-db.sh` | Inicializar BD | Una vez | No |
| `backup.sh` | Backup de datos | Diario (cron) | Sí |
| `restore.sh` | Restaurar backup | Manual | No |
| `install-cron.sh` | Instalar cron job | Una vez | Sí |
| `health-check.sh` | Verificar salud | Manual/Cron | No |

---

## 7. ESTRUCTURA DE DIRECTORIOS

```
vares-pos/
├── scripts/
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
├── docker-compose.yml
├── .env
└── .env.example
```

---

## 8. LOGS Y MONITOREO

### 8.1 Ubicación de Logs

```
/var/log/vares-backup.log          # Logs de backups
/var/lib/docker/volumes/           # Volúmenes de Docker
/var/backups/vares-pos/            # Backups almacenados
```

### 8.2 Comandos Útiles

```bash
# Ver logs en tiempo real
docker-compose logs -f

# Ver logs de un servicio específico
docker-compose logs -f backend

# Ver últimos 100 logs
docker-compose logs --tail=100

# Ver logs de backup
sudo tail -f /var/log/vares-backup.log

# Listar backups
ls -lht /var/backups/vares-pos/
```

---

**Documento creado por:** Sistema VARES  
**Versión:** 1.0  
**Fecha:** 2026-01-03
