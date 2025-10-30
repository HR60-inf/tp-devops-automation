#!/bin/bash
# Script pour surveiller l'espace disque
# Usage: ./verif_disque.sh

SEUIL=80
LOG_FILE="disque.log"

echo "Vérification de l'espace disque"
echo "--------------------------------"
echo ""

# Afficher l'espace disque
df -h | grep -v "tmpfs\|Filesystem"

echo ""
echo "--------------------------------"

# Verifier chaque partition
df -h | grep -v "tmpfs\|Filesystem" | while read ligne; do
    utilisation=$(echo $ligne | awk '{print $5}' | sed 's/%//g')
    partition=$(echo $ligne | awk '{print $6}')
    
    if [ "$utilisation" -ge "$SEUIL" ]; then
        echo "ATTENTION: $partition est plein à $utilisation%"
        echo "$(date '+%Y-%m-%d %H:%M:%S') - ALERTE: $partition à $utilisation%" >> "$LOG_FILE"
    fi
done

echo ""
echo "Vérification terminée"

# Enregistrer dans le log
echo "$(date '+%Y-%m-%d %H:%M:%S') - Vérification OK" >> "$LOG_FILE"
