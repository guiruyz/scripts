#!/bin/bash

# verify if there's an argument
if [ "$#" -ne 3 ]; then
    echo "Uso: $0 <ip> <porta> <banda> <arquivo_log>"
    exit 1
fi

# informations sent by user
SERVER_IP=$1
PORT=$2
BANDA=$3
LOG_FILE=$54

# descriptions 
echo "Capturando saída do iperf do servidor $SERVER_IP na porta $PORT..."
echo "A saída será registrada em: $LOG_FILE"

# commands
iperf -c "$SERVER_IP" -u -i 1 -l 1300 -p "$PORT" -t 999 -b "$BANDA"M | while read line; do
    echo "$(date '+%Y-%m-%d %H:%M:%S') $line" | tee -a "$LOG_FILE"
done
