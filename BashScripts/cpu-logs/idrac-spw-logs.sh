#!/bin/bash

# Configurações do iDRAC
IDRAC_HOST="192.168.1.100"
IDRAC_USER="root"
IDRAC_PASS="password"

# Diretório de log
LOG_DIR="/var/log/idrac"

# Nome do arquivo com data e hora
LOG_FILE="$LOG_DIR/power_log_$(date +'%Y-%m-%d_%H-%M-%S').log"

# Criação do diretório de log, se não existir
mkdir -p $LOG_DIR

# Capturando consumo de energia
{
    echo "===== Consumo de Energia - $(date) ====="
    sshpass -p "$IDRAC_PASS" ssh -o StrictHostKeyChecking=no $IDRAC_USER@$IDRAC_HOST racadm get system.Power
} >> $LOG_FILE