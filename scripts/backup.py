#!/usr/bin/env python3
# Script de backup simple
# Usage: python backup_simple.py dossier_source

import os
import sys
import shutil
from datetime import datetime

def faire_backup(source):
    # Verif si le dossier existe
    if not os.path.exists(source):
        print("Erreur: le dossier n'existe pas")
        return False
    
    # Creer le dossier backups
    if not os.path.exists("backups"):
        os.makedirs("backups")
    
    # Nom du backup avec date/heure
    maintenant = datetime.now().strftime("%Y%m%d_%H%M%S")
    nom_dossier = os.path.basename(source.rstrip('/'))
    backup_nom = f"{nom_dossier}_backup_{maintenant}"
    backup_path = os.path.join("backups", backup_nom)
    
    # Copier le dossier
    print(f"Backup en cours de {source}...")
    try:
        shutil.copytree(source, backup_path)
        print(f"OK! Sauvegarde dans: {backup_path}")
        
        # Calcul taille
        taille = 0
        for root, dirs, files in os.walk(backup_path):
            for f in files:
                taille += os.path.getsize(os.path.join(root, f))
        
        # Affichage taille
        if taille < 1024:
            print(f"Taille: {taille} octets")
        elif taille < 1024*1024:
            print(f"Taille: {taille/1024:.1f} Ko")
        else:
            print(f"Taille: {taille/(1024*1024):.1f} Mo")
        
        return True
    except Exception as e:
        print(f"Erreur lors du backup: {e}")
        return False

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python backup_simple.py dossier_source")
        sys.exit(1)
    
    source = sys.argv[1]
    resultat = faire_backup(source)
    sys.exit(0 if resultat else 1)
