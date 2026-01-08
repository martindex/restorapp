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
