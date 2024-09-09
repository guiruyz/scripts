#!/bin/bash

# Log file location
LOGFILE="/path/to/cpu_usage_per_core.log"

# Create the log file if it doesn't exist
touch "$LOGFILE"

# Infinite loop to log CPU usage every second
while true
do
    # Get the current timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    # Get the CPU usage per core using mpstat
    echo "Timestamp: $timestamp" >> "$LOGFILE"
    
    mpstat -P ALL 1 1 | awk -v timestamp="$timestamp" '
    BEGIN { ORS="" }
    /CPU/ { for (i=1; i<=NF; i++) header[i]=$i }
    /^[0-9]+/ {
        for (i=1; i<=NF; i++) data[header[i]]=$i
        usage = 100 - data["%idle"]
        printf "%s CPU%s Usage: %.2f%%\n", timestamp, data["CPU"], usage
    }' >> "$LOGFILE"

    # Sleep for 1 second before the next iteration
    sleep 1
done
