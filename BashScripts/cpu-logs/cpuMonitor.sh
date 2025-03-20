#!/bin/bash

# Verifica se os argumentos foram passados corretamente
if [ "$#" -ne 3 ]; then
    echo "Uso: $0 <arquivo_csv> <cpu_id> <pid>"
    exit 1
fi

LOGFILE=$1
CPU_ID=$2
PID=$3

# Cria o arquivo CSV e adiciona cabeçalho se for novo
if [ ! -f "$LOGFILE" ]; then
    echo "timestamp,cpu_usage,process_cpu,process_mem" > "$LOGFILE"
fi

# Função para capturar sinal de interrupção e sair graciosamente
trap "echo 'Script interrompido.'; exit 0" SIGINT SIGTERM

# Loop para registrar os dados no CSV
while true; do
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    # Captura o uso da CPU específica
    cpu_usage=$(mpstat -P "$CPU_ID" 1 1 | awk '/Average:/ {print 100 - $NF}')

    # Captura o uso de CPU e memória do processo específico
    read process_cpu process_mem <<< $(pidstat -p "$PID" 1 1 | awk 'NR>3 {print $7, $8}')

    # Se os valores forem vazios, define como 0
    cpu_usage=${cpu_usage:-0}
    process_cpu=${process_cpu:-0}
    process_mem=${process_mem:-0}

    # Escreve os dados no arquivo CSV
    echo "$timestamp,$cpu_usage,$process_cpu,$process_mem" >> "$LOGFILE"

    # Limita o número de linhas no log para evitar crescimento infinito
    tail -n 1000 "$LOGFILE" > "$LOGFILE.tmp" && mv "$LOGFILE.tmp" "$LOGFILE"

    sleep 1
done

