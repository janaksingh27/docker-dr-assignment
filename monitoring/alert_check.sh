#!/bin/bash

LOG_FILE="/home/janaksingh/docker-dr-assignment/monitoring/monitor.log"
ALERT_FILE="/home/janaksingh/docker-dr-assignment/monitoring/alert.log"
DATE=$(date)

if grep -q "DOWN" "$LOG_FILE"; then
  echo "[ALERT] Service DOWN detected at $DATE" >> $ALERT_FILE
fi
