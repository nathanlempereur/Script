#!/bin/bash

echo "
**************************************************************************
**************************************************************************
*************************** Création du backup ***************************
**************************************************************************
**************************************************************************
"

# Générer la date pour le nom du dossier et de l'archive
date_sauvegarde=$(date +"%d-%m-%Y_%H-%M-%S")
nom="archive"
dossier="${nom}_${date_sauvegarde}"

# Créer le dossier de sauvegarde
mkdir -p /archive/$dossier

# Copier le dossier source dans le dossier de sauvegarde
cp -R "$1" /archive/$dossier/

# Créer une archive tar.gz
tar -czvf "/archive/${dossier}.tar.gz" -C /archive "$dossier"

# Supprimer le dossier temporaire après l'archivage
rm -rf /archive/$dossier

echo "
**************************************************************************
**************************************************************************
*********************** Création du backup terminée ! ********************
**************************************************************************
**************************************************************************
"
