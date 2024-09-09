#!/bin/bash

# Verifica se o número correto de argumentos foi passado
if [ "$#" -ne 3 ]; then
    echo "Uso: $0 <servidor_ip> <porta> <arquivo_log>"
    exit 1
fi

# Parâmetros de entrada
SERVER_IP=$1
PORT=$2
LOG_FILE=$3

# Exibe mensagem de início
echo "Capturando saída do iperf do servidor $SERVER_IP na porta $PORT..."
echo "A saída será registrada em: $LOG_FILE"

# Executa o iperf e captura a saída com timestamp
iperf -c "$SERVER_IP" -p "$PORT" | while read line; do
    # Adiciona o timestamp antes de cada linha da saída
    echo "$(date '+%Y-%m-%d %H:%M:%S') $line" | tee -a "$LOG_FILE"
done
