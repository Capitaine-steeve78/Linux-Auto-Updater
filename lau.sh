#!/bin/bash

# =========================
# SCRIPT LAUNCHER
# =========================

SCRIPT_NAME="$1"

# Vérifie si un argument est fourni
if [ -z "$SCRIPT_NAME" ]; then
  echo "ERROR : no script specified"
  exit 1
fi

# Dossier scripts (au même niveau que ce script)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)/scripts"

# Transforme "exemple/test" en chemin réel
TARGET_SCRIPT="$SCRIPT_DIR/$SCRIPT_NAME.sh"

# Vérifie si le fichier existe
if [ -f "$TARGET_SCRIPT" ]; then
  bash "$TARGET_SCRIPT"
  exit 0
fi

# Si pas trouvé → erreur claire
echo "ERROR : script '$SCRIPT_NAME.sh' not found in $SCRIPT_DIR"
exit 1