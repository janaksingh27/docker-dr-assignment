#!/bin/bash

# Backup directory
BACKUP_DIR="./backups/volumes"
TIMESTAMP=$(date +%Y%m%d%H%M%S)

# Create backup folder if it doesn't exist
mkdir -p "$BACKUP_DIR"

# 1. Backup PostgreSQL database
docker exec docker-dr-db pg_dump -U postgres mydb | gzip > "$BACKUP_DIR/${TIMESTAMP}-db-data.sql.gz"

# 2. Backup database volume
docker run --rm \
  -v docker-dr-assignment_db-data:/data \
  -v "$PWD/backups/volumes":/backup \
  alpine \
  tar czf /backup/${TIMESTAMP}-db-volume.tar.gz -C /data .

echo "Backup completed at $TIMESTAMP"
