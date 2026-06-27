#!/bin/bash

SCRIPT_NAME="$1"

if [ -z "$SCRIPT_NAME" ]; then
  echo "ERROR : no script specified"
  exit 1
fi

# CHEMIN FIXE DU PROJET (IMPORTANT)
PROJECT_DIR="/opt/linux-auto-updater"
SCRIPT_DIR="$PROJECT_DIR/scripts"

TARGET_SCRIPT="$SCRIPT_DIR/$SCRIPT_NAME.sh"

if [ -f "$TARGET_SCRIPT" ]; then
  bash "$TARGET_SCRIPT"
  exit 0
fi

echo "ERROR : script '$SCRIPT_NAME.sh' not found in $SCRIPT_DIR"
exit 1