#!/bin/bash

# Configurações do iDRAC
IDRAC_HOST="192.168.10.100"
IDRAC_USER="root"
IDRAC_PASS="senha"

LOG_DIR="/var/log/idrac"
LOG_FILE="$LOG_DIR/power_log.csv"

INTERVAL=10

mkdir -p $LOG_DIR

if [ ! -f "$LOG_FILE" ]; then
    echo "timestamp,realtime_power,max_last_day,min_last_day" > $LOG_FILE
fi

while true; do
    # Capturando dados do consumo de energia
    OUTPUT=$(sshpass -p "$IDRAC_PASS" ssh -o StrictHostKeyChecking=no $IDRAC_USER@$IDRAC_HOST racadm get system.Power)

    REALTIME_POWER=$(echo "$OUTPUT" | grep "#Realtime.Power" | awk -F= '{print $2}' | awk '{print $1}')
    MAX_LAST_DAY=$(echo "$OUTPUT" | grep "#Max.LastDay=" | awk -F= '{print $2}' | awk '{print $1}')
    MIN_LAST_DAY=$(echo "$OUTPUT" | grep "#Min.LastDay=" | awk -F= '{print $2}' | awk '{print $1}')

    echo "$(date +'%Y-%m-%d %H:%M:%S'),$REALTIME_POWER,$MAX_LAST_DAY,$MIN_LAST_DAY" >> $LOG_FILE

    sleep $INTERVAL
done

