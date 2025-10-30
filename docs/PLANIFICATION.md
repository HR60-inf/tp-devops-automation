# Planification du TP DevOps

## Tâches à automatiser

### 1. Surveillance de l'espace disque
- **Objectif** : Surveiller l'espace disque et alerter en cas de dépassement
- **Technologie** : Bash/Shell
- **Raison** : Simple, rapide, natif Linux, parfait pour les commandes système
- **Fréquence** : Toutes les heures via cron

### 2. Sauvegarde de dossiers
- **Objectif** : Créer des sauvegardes automatiques avec horodatage
- **Technologie** : Python
- **Raison** : Meilleure gestion des erreurs, manipulation de fichiers plus robuste
- **Fréquence** : Quotidienne via cron

### 3. Rotation des logs
- **Objectif** : Nettoyer les vieux logs pour économiser l'espace
- **Technologie** : Bash/Shell
- **Raison** : Manipulation de fichiers simple, commandes find/rm efficaces
- **Fréquence** : Hebdomadaire

## Structure du dépôt Git
```
tp-devops-automation/
├── README.md
├── scripts/
│   ├── monitoring_disque.sh
│   ├── backup.py
│   └── log_rotate.sh
├── docs/
│   ├── PLANIFICATION.md
│   └── NOTICES.md
├── logs/
└── backups/
```

## Conventions de nommage
- Scripts : `nom_descriptif.extension`
- Logs : `script_name_YYYYMMDD.log`
- Commits : `[TYPE] Description courte`
