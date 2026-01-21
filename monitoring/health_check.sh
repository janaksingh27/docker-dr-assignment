#!/bin/bash

LOG_FILE="/home/janaksingh/docker-dr-assignment/monitoring/monitor.log"
DATE=$(date)

echo "===== Health Check at $DATE =====" >> $LOG_FILE

# Backend check
if curl -s http://localhost:3000 >/dev/null; then
  echo "Backend OK" >> $LOG_FILE
else
  echo "Backend DOWN" >> $LOG_FILE
fi

# Frontend check
if curl -s http://localhost:8080 >/dev/null; then
  echo "Frontend OK" >> $LOG_FILE
else
  echo "Frontend DOWN" >> $LOG_FILE
fi

# Database check
if docker exec docker-dr-db pg_isready -U postgres >/dev/null 2>&1; then
  echo "Database OK" >> $LOG_FILE
else
  echo "Database DOWN" >> $LOG_FILE
fi

echo "" >> $LOG_FILE
