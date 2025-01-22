#!/bin/bash

# Verify if there's an argument
if [ "$#" -ne 2 ]; then
    echo "Uso: $0 <arquivo_log> <cpu_id>"
    exit 1
fi

# Information
LOGFILE=$1
CPU_ID=$2

# Create the log file if it does not exist
touch "$LOGFILE"

# Send commands and add data to logs
while true
do
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    echo "Timestamp: $timestamp" >> "$LOGFILE"
    
    mpstat -P ALL 1 1 | awk -v timestamp="$timestamp" -v cpu_id="$CPU_ID" '
    BEGIN { ORS="" }
    /CPU/ { for (i=1; i<=NF; i++) header[i]=$i }
    /^[0-9]+/ {
        for (i=1; i<=NF; i++) data[header[i]]=$i
        if (data["CPU"] == cpu_id) {
            usage = 100 - data["%idle"]
            printf "%s CPU%s Usage: %.2f%%\n", timestamp, cpu_id, usage
        }
    }' >> "$LOGFILE"

    sleep 1
done
