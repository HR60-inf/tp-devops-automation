#!/bin/bash
# Script pour nettoyer les vieux logs
# Usage: ./nettoyer_logs.sh [dossier_logs]

DOSSIER=${1:-"../logs"}
JOURS=7
TAILLE_MAX=10

# Verif si le dossier existe
if [ ! -d "$DOSSIER" ]; then
    echo "Erreur: le dossier $DOSSIER n'existe pas"
    exit 1
fi

echo "Nettoyage des logs dans $DOSSIER"
echo "-----------------------------------"

# Compteurs
supprimes=0
comprimes=0

# Supprimer les vieux logs
echo "Suppression des logs de plus de $JOURS jours..."
for fichier in $(find "$DOSSIER" -name "*.log" -mtime +$JOURS 2>/dev/null); do
    echo "  - $(basename $fichier)"
    rm "$fichier"
    supprimes=$((supprimes + 1))
done

# Compresser les gros logs
echo ""
echo "Compression des logs de plus de ${TAILLE_MAX}Mo..."
for fichier in $(find "$DOSSIER" -name "*.log" -type f 2>/dev/null); do
    taille=$(du -m "$fichier" | cut -f1)
    if [ "$taille" -gt "$TAILLE_MAX" ]; then
        echo "  - $(basename $fichier) (${taille}Mo)"
        gzip "$fichier"
        comprimes=$((comprimes + 1))
    fi
done

# Recap
echo ""
echo "-----------------------------------"
echo "Terminé!"
echo "Fichiers supprimés: $supprimes"
echo "Fichiers compressés: $comprimes"
echo ""

# Log dans fichier
echo "$(date '+%Y-%m-%d %H:%M:%S') - Supprimés: $supprimes, Compressés: $comprimes" >> "$DOSSIER/nettoyage.log"
