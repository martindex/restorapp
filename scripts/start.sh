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
echo -e "${YELLOW}Nota: La primera vez puede tardar varios minutos...${NC}"
docker-compose build

echo -e "${YELLOW}[4/5] Iniciando servicios...${NC}"
docker-compose up -d

echo -e "${YELLOW}[5/5] Esperando que los servicios estén listos...${NC}"

# Esperar a que la base de datos esté lista
echo -n "Esperando base de datos..."
for i in {1..30}; do
    if docker-compose exec -T mysql mysqladmin ping -h localhost -u root -p${MYSQL_ROOT_PASSWORD:-root_password} &> /dev/null; then
        echo -e " ${GREEN}✓${NC}"
        break
    fi
    echo -n "."
    sleep 2
    if [ $i -eq 30 ]; then
        echo -e " ${RED}✗${NC}"
        echo -e "${RED}Error: La base de datos no respondió a tiempo${NC}"
        docker-compose logs mysql
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
echo -e "  ${GREEN}•${NC} Backend:   http://localhost:8080/api"
echo -e "  ${GREEN}•${NC} Database:  localhost:3306"
echo ""
echo -e "Credenciales de acceso:"
echo -e "  ${GREEN}•${NC} Email:     admin@vares.com"
echo -e "  ${GREEN}•${NC} Password:  admin123"
echo ""
echo -e "Para ver los logs:"
echo -e "  ${YELLOW}docker-compose logs -f${NC}"
echo ""
echo -e "Para detener el sistema:"
echo -e "  ${YELLOW}./scripts/stop.sh${NC}"
echo ""
