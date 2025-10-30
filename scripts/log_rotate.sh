#!/bin/bash

################################################################################
# Script: log_rotate.sh
# Description: Rotation et nettoyage automatique des logs
# Auteur: HR60-inf
# Date: 2025-10-30
# Version: 1.0
################################################################################

# Configuration par défaut
DOSSIER_LOGS="../logs"
JOURS_CONSERVATION=7
TAILLE_MAX_MO=10
LOG_SCRIPT="../logs/log_rotate.log"

# Affichage de l'aide
afficher_aide() {
    cat << EOF
Usage: $0 [OPTIONS]

Options:
    -d DOSSIER    Dossier des logs (défaut: ../logs)
    -j JOURS      Nombre de jours de conservation (défaut: 7)
    -t TAILLE     Taille max en Mo (défaut: 10)
    -h            Afficher cette aide

Exemples:
    $0
    $0 -d /var/log -j 30 -t 50
EOF
}

# Traitement des paramètres
while getopts "d:j:t:h" option; do
    case $option in
        d) DOSSIER_LOGS=$OPTARG ;;
        j) JOURS_CONSERVATION=$OPTARG ;;
        t) TAILLE_MAX_MO=$OPTARG ;;
        h) afficher_aide; exit 0 ;;
        *) afficher_aide; exit 1 ;;
    esac
done

# Vérifications
if [ ! -d "$DOSSIER_LOGS" ]; then
    echo "❌ ERREUR: Le dossier '$DOSSIER_LOGS' n'existe pas"
    exit 1
fi

# Création du log du script
mkdir -p "$(dirname "$LOG_SCRIPT")"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

echo "=========================================="
echo "  ROTATION DES LOGS"
echo "  Date: $DATE"
echo "=========================================="
echo ""
echo "Configuration:"
echo "  - Dossier: $DOSSIER_LOGS"
echo "  - Conservation: $JOURS_CONSERVATION jours"
echo "  - Taille max: $TAILLE_MAX_MO Mo"
echo ""

# Compteurs
nb_supprimes=0
nb_archives=0

# Suppression des logs anciens
echo "🔍 Recherche des logs de plus de $JOURS_CONSERVATION jours..."
while IFS= read -r fichier; do
    if [ -f "$fichier" ]; then
        echo "  ➜ Suppression: $(basename "$fichier")"
        rm "$fichier"
        ((nb_supprimes++))
    fi
done < <(find "$DOSSIER_LOGS" -name "*.log" -type f -mtime +$JOURS_CONSERVATION 2>/dev/null)

# Compression des gros logs
echo ""
echo "🔍 Recherche des logs dépassant $TAILLE_MAX_MO Mo..."
while IFS= read -r fichier; do
    if [ -f "$fichier" ]; then
        taille_mo=$(du -m "$fichier" | cut -f1)
        if [ "$taille_mo" -gt "$TAILLE_MAX_MO" ]; then
            echo "  ➜ Compression: $(basename "$fichier") (${taille_mo}Mo)"
            gzip "$fichier"
            ((nb_archives++))
        fi
    fi
done < <(find "$DOSSIER_LOGS" -name "*.log" -type f 2>/dev/null)

# Résumé
echo ""
echo "=========================================="
echo "  RÉSUMÉ"
echo "=========================================="
echo "  ✓ Fichiers supprimés: $nb_supprimes"
echo "  ✓ Fichiers compressés: $nb_archives"
echo ""

# Log dans le fichier
echo "[$DATE] Rotation effectuée - Supprimés: $nb_supprimes, Compressés: $nb_archives" >> "$LOG_SCRIPT"
