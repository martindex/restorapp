# SCRIPT DE AUTOMATIZACIÓN DE BACKUPS (CRON)

Este documento detalla la configuración para el backup automático diario de los volúmenes del sistema VARES POS.

## 1. Script de Backup
El script se encuentra en: `/scripts/backup-volumes.sh`
Este script realiza lo siguiente:
- Comprime todo el contenido del directorio `volumes/` (excepto la propia carpeta de backups).
- Guarda el archivo en `volumes/back/volumes.YYYYMMDD.tar.gz`.

## 2. Configuración de Cron
Para ejecutar el backup todos los días a las **20:00 hs (Hora Argentina)**:

### Paso 1: Abrir el editor de crontab
Ejecuta el siguiente comando en la terminal:
```bash
crontab -e
```

### Paso 2: Copiar y pegar la siguiente línea
Al final del archivo, pega esta línea (se utiliza `sudo` para que tenga permisos de lectura sobre los datos de MySQL):

```bash
# Backup diario VARES POS - 20:00 hs Argentina
0 20 * * * sudo /home/martintapia/workspaces/amautek/restorapp/scripts/backup-volumes.sh >> /home/martintapia/workspaces/amautek/restorapp/volumes/back/backup.log 2>&1
```

> **Nota:** Para que el cron funcione con `sudo` sin pedir contraseña, o para evitar el uso de `sudo`, lo más recomendable es editar el crontab del usuario **root**: `sudo crontab -e`. Si lo haces así, no necesitas poner `sudo` dentro de la línea.

> **Nota:** Se utiliza `0 20 * * *` asumiendo que el servidor está configurado en hora local de Argentina. Si el servidor está en UTC, deberás ajustar la hora (ej: `0 23 * * *` para UTC-3).

### Paso 3: Guardar y Salir
- Si usas `nano`: Presiona `Ctrl+O`, `Enter`, y luego `Ctrl+X`.
- Si usas `vi`: Presiona `Esc`, escribe `:wq` y `Enter`.

## 3. Verificación
Puedes verificar que el cron quedó programado listándolos:
```bash
crontab -l
```

Los logs del proceso se guardarán en:
`volumes/back/backup.log`
