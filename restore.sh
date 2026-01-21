#!/bin/bash
set -e

echo "=== Starting Restore Process ==="

# 1️⃣ Stop all containers
echo "[1] Stopping all containers..."
docker compose down

# 2️⃣ Remove old DB volume
echo "[2] Removing old DB volume..."
docker volume rm docker-dr-assignment_db-data || true

# 3️⃣ Create a new volume
echo "[3] Creating DB volume..."
docker volume create docker-dr-assignment_db-data

# 4️⃣ Restore latest DB volume snapshot
LATEST_VOL=$(ls -t ./backups/volumes/*-db-volume.tar.gz | head -1)
echo "[4] Restoring volume snapshot: $LATEST_VOL"
sudo mkdir -p /var/lib/docker/volumes/docker-dr-assignment_db-data/_data
sudo tar -xzf "$LATEST_VOL" -C /var/lib/docker/volumes/docker-dr-assignment_db-data/_data

# 5️⃣ Start DB container only
echo "[5] Starting DB container..."
docker compose up -d db

# Wait until PostgreSQL is ready
echo "Waiting for PostgreSQL to be ready..."
until docker exec docker-dr-db pg_isready -U postgres -d mydb > /dev/null 2>&1; do
  sleep 2
  echo -n "."
done
echo "PostgreSQL is ready!"

# 6️⃣ Restore latest SQL dump
LATEST_DB=$(ls -t ./backups/volumes/*-db-data.sql.gz | head -1)
echo "[6] Restoring SQL dump: $LATEST_DB"
docker run --rm \
  -v "$PWD/backups/volumes":/backup \
  --network docker-dr-assignment_dr-network \
  -e PGPASSWORD=postgres \
  postgres:15 \
  sh -c "gunzip -c /backup/$(basename $LATEST_DB) | psql -h docker-dr-db -U postgres -d mydb"

# 7️⃣ Start backend + frontend
echo "[7] Starting backend + frontend..."
docker compose up -d backend frontend

echo "=== Restore Completed Successfully ==="

