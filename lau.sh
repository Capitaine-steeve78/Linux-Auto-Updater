#!/bin/bash

# Récupère le nom du script à exécuter
SCRIPT_NAME="$1"

# Dossier scripts situé au même endroit que ce script
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)/scripts"

# Chemin complet du script cible
TARGET_SCRIPT="$SCRIPT_DIR/$SCRIPT_NAME.sh"

# Vérifie si un argument a été fourni
if [ -z "$SCRIPT_NAME" ]; then
  echo "ERROR : no script specified"
  exit 1
fi

# Vérifie si le fichier existe
if [ -f "$TARGET_SCRIPT" ]; then
  bash "$TARGET_SCRIPT"
else
  echo "ERROR : script '$SCRIPT_NAME.sh' not found"
  exit 1
fi