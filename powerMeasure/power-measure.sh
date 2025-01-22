#!/bin/bash

# Configurações do iDRAC
IDRAC_HOST="192.168.10.100"
IDRAC_USER="root"
IDRAC_PASS="senha"

NOW=$(date +"%Y-%m-%d_%H-%M-%S")
LOG_DIR="/var/log/idrac"
LOG_FILE="$LOG_DIR/power_log_$NOW.csv"

INTERVAL=10

mkdir -p $LOG_DIR

if [ ! -f "$LOG_FILE" ]; then
    echo "timestamp,realtime_power,cpu_power" > $LOG_FILE
fi

while true; do
    # Capturando dados do consumo de energia
    OUTPUT=$(sshpass -p "$IDRAC_PASS" ssh -o StrictHostKeyChecking=no $IDRAC_USER@$IDRAC_HOST racadm get system.Power)
    OUTPUT1=$(sudo timeout -s SIGINT 1s /local/do/cpu-energy-meter/cpu-energy-meter -r)

    CPU0_j=$(echo "$OUTPU1" | grep 'cpu0_package_joules' | awk -F= '{print $2}')
    ts=$(echo "$OUTPUT1" | grep 'duration_seconds' | awk -F= '{print $2}')
    CPU_REALTIME_POWER=$(echo "scale=6; $CPU0_j / $ts" | bc -l)
    TOTAL_REALTIME_POWER=$(echo "$OUTPUT" | grep "#Realtime.Power" | awk -F= '{print $2}' | awk '{print $1}')
    #MAX_LAST_DAY=$(echo "$OUTPUT" | grep "#Max.LastDay=" | awk -F= '{print $2}' | awk '{print $1}')
    #MIN_LAST_DAY=$(echo "$OUTPUT" | grep "#Min.LastDay=" | awk -F= '{print $2}' | awk '{print $1}')

    echo "$(date +'%Y-%m-%d %H:%M:%S'),$TOTAL_REALTIME_POWER,$CPU_REALTIME_POWER" >> $LOG_FILE

    sleep $INTERVAL
done

