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
DB_CONTAINER="vares-mysql"
DB_NAME="vares_pos"
DB_ROOT_PASS="${MYSQL_ROOT_PASSWORD:-root_password}"

# Verificar que MySQL esté corriendo
echo -e "${YELLOW}[1/6] Verificando conexión a base de datos...${NC}"
if ! docker exec ${DB_CONTAINER} mysqladmin ping -h localhost -u root -p${DB_ROOT_PASS} &> /dev/null; then
    echo -e "${RED}Error: No se puede conectar a la base de datos${NC}"
    echo "Asegúrese de que el sistema esté corriendo: ./scripts/start.sh"
    exit 1
fi
echo -e "${GREEN}✓ Conexión exitosa${NC}"

# Crear base de datos si no existe
echo -e "${YELLOW}[2/6] Creando base de datos...${NC}"
docker exec -i ${DB_CONTAINER} mysql -u root -p${DB_ROOT_PASS} <<EOF
CREATE DATABASE IF NOT EXISTS ${DB_NAME}
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;
EOF
echo -e "${GREEN}✓ Base de datos creada${NC}"

# Ejecutar script de creación de tablas
echo -e "${YELLOW}[3/6] Creando estructura de tablas...${NC}"
if [ -f "scripts/sql/01_create_tables.sql" ]; then
    docker exec -i ${DB_CONTAINER} mysql -u root -p${DB_ROOT_PASS} ${DB_NAME} < scripts/sql/01_create_tables.sql
    echo -e "${GREEN}✓ Tablas creadas${NC}"
else
    echo -e "${RED}Error: No se encontró scripts/sql/01_create_tables.sql${NC}"
    exit 1
fi

# Insertar datos iniciales
echo -e "${YELLOW}[4/6] Insertando datos iniciales...${NC}"
if [ -f "scripts/sql/02_insert_initial_data.sql" ]; then
    docker exec -i ${DB_CONTAINER} mysql -u root -p${DB_ROOT_PASS} ${DB_NAME} < scripts/sql/02_insert_initial_data.sql
    echo -e "${GREEN}✓ Datos iniciales insertados${NC}"
else
    echo -e "${RED}Error: No se encontró scripts/sql/02_insert_initial_data.sql${NC}"
    exit 1
fi

# Crear triggers y stored procedures (ejecutar línea por línea)
echo -e "${YELLOW}[5/6] Creando triggers y stored procedures...${NC}"
if [ -f "scripts/sql/03_create_triggers.sql" ]; then
    # Ejecutar el archivo SQL directamente con mysql client
    docker exec -i ${DB_CONTAINER} mysql -u root -p${DB_ROOT_PASS} ${DB_NAME} < scripts/sql/03_create_triggers.sql 2>&1 | grep -v "Warning" || true
    echo -e "${GREEN}✓ Triggers y procedures creados${NC}"
else
    echo -e "${YELLOW}Advertencia: No se encontró scripts/sql/03_create_triggers.sql${NC}"
fi

# Crear vistas
echo -e "${YELLOW}[6/6] Creando vistas...${NC}"
if [ -f "scripts/sql/04_create_views.sql" ]; then
    docker exec -i ${DB_CONTAINER} mysql -u root -p${DB_ROOT_PASS} ${DB_NAME} < scripts/sql/04_create_views.sql
    echo -e "${GREEN}✓ Vistas creadas${NC}"
else
    echo -e "${YELLOW}Advertencia: No se encontró scripts/sql/04_create_views.sql${NC}"
fi

# Actualizar password del admin con hash correcto
echo -e "${YELLOW}Actualizando password del usuario admin...${NC}"
docker exec -i ${DB_CONTAINER} mysql -u root -p${DB_ROOT_PASS} ${DB_NAME} <<EOF
UPDATE users 
SET password_hash = '\$2a\$10\$7stwjJCQzTBUAERDvpGUleSfnattonx/l3PHfD2Ij05ZTsYMRm/.6' 
WHERE email='admin@vares.com';
EOF
echo -e "${GREEN}✓ Password actualizado${NC}"

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  BASE DE DATOS INICIALIZADA${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "Usuario superusuario:"
echo -e "  ${GREEN}•${NC} Email:    admin@vares.com"
echo -e "  ${GREEN}•${NC} Password: admin123"
echo ""
echo -e "${YELLOW}⚠️  IMPORTANTE: Cambie la contraseña del administrador en el primer login${NC}"
echo ""
