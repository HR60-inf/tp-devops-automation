#!/bin/bash

################################################################################
# Script: monitoring_disque.sh
# Description: Surveille l'espace disque et alerte si seuil dépassé
# Auteur: HR60-inf
# Date: 2025-10-30
# Version: 1.0
################################################################################

# Configuration
SEUIL=80
LOG_FILE="../logs/monitoring_disque.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

# Création du dossier logs si inexistant
mkdir -p ../logs

# Fonction d'écriture dans le log
log_message() {
    echo "[$DATE] $1" >> "$LOG_FILE"
}

# Affichage de l'en-tête
echo "=========================================="
echo "  Surveillance de l'espace disque"
echo "  Date: $DATE"
echo "=========================================="
echo ""

# Récupération et affichage de l'espace disque
df -h | grep -vE '^Filesystem|tmpfs|cdrom'

echo ""
echo "=========================================="

# Vérification du seuil pour chaque partition
df -h | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{print $5 " " $6}' | while read ligne
do
    utilisation=$(echo $ligne | awk '{print $1}' | sed 's/%//g')
    partition=$(echo $ligne | awk '{print $2}')
    
    if [ "$utilisation" -ge "$SEUIL" ]; then
        message="ALERTE: La partition $partition est utilisée à $utilisation% (seuil: $SEUIL%)"
        echo "⚠️  $message"
        log_message "$message"
    fi
done

# Log de l'exécution normale
log_message "Surveillance effectuée - Seuil: $SEUIL%"

echo ""
echo "Logs enregistrés dans: $LOG_FILE"
