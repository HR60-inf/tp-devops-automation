#!/usr/bin/env python3

"""
================================================================================
Script: backup.py
Description: Sauvegarde un dossier avec horodatage et gestion d'erreurs
Auteur: HR60-inf
Date: 2025-10-30
Version: 1.0
================================================================================
"""

import os
import sys
import shutil
from datetime import datetime
import argparse

def creer_backup(source, destination_base):
    """
    Crée une sauvegarde d'un dossier avec timestamp
    """
    try:
        # Vérification que la source existe
        if not os.path.exists(source):
            print(f"❌ ERREUR: Le dossier source '{source}' n'existe pas")
            return False
        
        # Création du dossier de destination si nécessaire
        if not os.path.exists(destination_base):
            os.makedirs(destination_base)
            print(f"✓ Dossier de destination créé: {destination_base}")
        
        # Génération du nom de backup avec timestamp
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        nom_source = os.path.basename(source.rstrip('/'))
        nom_backup = f"{nom_source}_backup_{timestamp}"
        chemin_backup = os.path.join(destination_base, nom_backup)
        
        # Copie du dossier
        print(f"🔄 Sauvegarde en cours...")
        print(f"   Source: {source}")
        print(f"   Destination: {chemin_backup}")
        
        shutil.copytree(source, chemin_backup)
        
        # Calcul de la taille
        taille = obtenir_taille_dossier(chemin_backup)
        
        print(f"✅ Sauvegarde réussie!")
        print(f"   Taille: {taille}")
        print(f"   Emplacement: {chemin_backup}")
        
        # Simulation d'envoi d'email
        envoyer_email_simulation(True, chemin_backup, taille)
        
        return True
        
    except PermissionError:
        print(f"❌ ERREUR: Permission refusée")
        envoyer_email_simulation(False, source, "Permission refusée")
        return False
    except Exception as e:
        print(f"❌ ERREUR: {str(e)}")
        envoyer_email_simulation(False, source, str(e))
        return False

def obtenir_taille_dossier(chemin):
    """Calcule la taille d'un dossier"""
    taille_totale = 0
    for dirpath, dirnames, filenames in os.walk(chemin):
        for f in filenames:
            fp = os.path.join(dirpath, f)
            if os.path.exists(fp):
                taille_totale += os.path.getsize(fp)
    
    # Conversion en unités lisibles
    for unite in ['octets', 'Ko', 'Mo', 'Go']:
        if taille_totale < 1024.0:
            return f"{taille_totale:.2f} {unite}"
        taille_totale /= 1024.0
    return f"{taille_totale:.2f} To"

def envoyer_email_simulation(succes, chemin, info):
    """Simule l'envoi d'un email de notification"""
    print("\n" + "="*50)
    print("📧 SIMULATION D'ENVOI D'EMAIL")
    print("="*50)
    print(f"À: admin@exemple.com")
    print(f"Sujet: {'✅ Sauvegarde réussie' if succes else '❌ Échec de sauvegarde'}")
    print(f"Corps:")
    if succes:
        print(f"  La sauvegarde a été effectuée avec succès.")
        print(f"  Emplacement: {chemin}")
        print(f"  Taille: {info}")
    else:
        print(f"  La sauvegarde a échoué.")
        print(f"  Source: {chemin}")
        print(f"  Erreur: {info}")
    print("="*50 + "\n")

def main():
    """Fonction principale"""
    parser = argparse.ArgumentParser(
        description='Script de sauvegarde automatique avec timestamp'
    )
    parser.add_argument(
        'source',
        help='Chemin du dossier à sauvegarder'
    )
    parser.add_argument(
        '-d', '--destination',
        default='../backups',
        help='Dossier de destination (défaut: ../backups)'
    )
    
    args = parser.parse_args()
    
    print("\n" + "="*50)
    print("  SCRIPT DE SAUVEGARDE AUTOMATIQUE")
    print("="*50 + "\n")
    
    succes = creer_backup(args.source, args.destination)
    
    sys.exit(0 if succes else 1)

if __name__ == "__main__":
    main()
