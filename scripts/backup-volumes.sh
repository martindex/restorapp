#!/bin/bash

# =================================================================
# SCRIPT DE BACKUP AUTOMATIZADO - VARES POS
# =================================================================

# Configuración
PROJECT_DIR="/home/martintapia/workspaces/amautek/restorapp"
VOLUMES_DIR="$PROJECT_DIR/volumes"
BACKUP_DIR="$VOLUMES_DIR/back"
DATE=$(date +%Y%m%d)
BACKUP_FILE="volumes.$DATE.tar.gz"

# Asegurar que el directorio de backups existe
mkdir -p "$BACKUP_DIR"

# Log de inicio
echo "[$(date)] Iniciando backup de volúmenes..."

# Realizar el backup comprimido
# Excluimos la carpeta 'back' para no incluir backups anteriores dentro del nuevo
cd "$PROJECT_DIR"
tar -czf "$BACKUP_DIR/$BACKUP_FILE" --exclude="volumes/back" volumes/

# Verificar resultado
if [ $? -eq 0 ]; then
    echo "[$(date)] Backup completado exitosamente: $BACKUP_FILE"
else
    echo "[$(date)] ERROR: Falló el backup de volúmenes"
    exit 1
fi

# Opcional: Eliminar backups más antiguos de 7 días (mantenimiento)
# find "$BACKUP_DIR" -name "volumes(*).tar.gz" -mtime +7 -delete

echo "-----------------------------------------------------------------"
