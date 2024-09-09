#!/bin/bash

# verify if there's an argument
if [ "$#" -ne 1 ]; then
    echo "Uso: $0 <arquivo_log>"
    exit 1
fi

# informations
LOG_FILE=$1

touch "$LOGFILE"

# send commands and add datas to logs
while true
do

    timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    echo "Timestamp: $timestamp" >> "$LOGFILE"
    
    mpstat -P ALL 1 1 | awk -v timestamp="$timestamp" '
    BEGIN { ORS="" }
    /CPU/ { for (i=1; i<=NF; i++) header[i]=$i }
    /^[0-9]+/ {
        for (i=1; i<=NF; i++) data[header[i]]=$i
        usage = 100 - data["%idle"]
        printf "%s CPU%s Usage: %.2f%%\n", timestamp, data["CPU"], usage
    }' >> "$LOGFILE"

    sleep 1
done
