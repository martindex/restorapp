#!/bin/bash

# Script para construir y ejecutar VARES POS en Docker
# Solución al problema de conectividad de Maven dentro de Docker

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  BUILD & START VARES POS (Docker)${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# 1. Construir backend localmente
echo -e "${YELLOW}[1/5] Construyendo backend localmente...${NC}"
cd vares-backend
if mvn clean package -DskipTests; then
    echo -e "${GREEN}✓ Backend compilado${NC}"
else
    echo -e "${RED}✗ Error compilando backend${NC}"
    exit 1
fi
cd ..

# 2. Construir imagen Docker del backend
echo -e "${YELLOW}[2/5] Creando imagen Docker del backend...${NC}"
docker build -t vares-backend:latest -f vares-backend/Dockerfile.simple vares-backend/

# 3. Construir imagen Docker del frontend
echo -e "${YELLOW}[3/5] Creando imagen Docker del frontend...${NC}"
docker-compose build frontend

# 4. Iniciar todos los servicios
echo -e "${YELLOW}[4/5] Iniciando servicios...${NC}"
docker-compose up -d

# 5. Esperar a que estén listos
echo -e "${YELLOW}[5/5] Esperando servicios...${NC}"
sleep 10

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  SISTEMA INICIADO${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "Accede a: ${GREEN}http://localhost:3000${NC}"
echo -e "Credenciales: ${GREEN}admin@vares.com / admin123${NC}"
echo ""
