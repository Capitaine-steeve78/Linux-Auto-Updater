#!/usr/bin/env bash
set -Eeuo pipefail

# 🧠 Dossier du script (CRUCIAL)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 🧰 Sécurité : vérifier que les dossiers existent
if [[ ! -d "$SCRIPT_DIR/scripts" ]]; then
  echo "[ERROR] scripts/ folder not found in $SCRIPT_DIR"
  exit 1
fi

if [[ ! -d "$SCRIPT_DIR/commands" ]]; then
  echo "[WARN] commands/ folder not found (optional)"
fi


case "${1:-}" in

  install)
    source "$SCRIPT_DIR/scripts/install.sh" || {
      echo "[ERROR] failed to load install.sh"
      exit 1
    }
    install_main
    ;;

  update)
    source "$SCRIPT_DIR/scripts/update.sh" || {
      echo "[ERROR] failed to load update.sh"
      exit 1
    }
    update_main
    ;;

  self-update)
    source "$SCRIPT_DIR/scripts/self_update.sh" || {
      echo "[ERROR] failed to load self_update.sh"
      exit 1
    }
    self_update
    ;;

  configure)
    source "$SCRIPT_DIR/scripts/configure.sh" || {
      echo "[ERROR] failed to load configure.sh"
      exit 1
    }
    configure_main "${@:2}"
    ;;

  *)
    CMD="${1:-}"

    if [[ -z "$CMD" ]]; then
      echo "Usage: $0 {install|update|self-update|configure|<command>}"
      exit 1
    fi

    shift || true

    CMD_FILE="$SCRIPT_DIR/commands/$CMD.sh"

    if [[ -f "$CMD_FILE" ]]; then
      source "$CMD_FILE" || {
        echo "[ERROR] failed to load command: $CMD"
        exit 1
      }
      main "$@"
    else
      echo "Unknown command: $CMD"
      exit 1
    fi
    ;;
esac