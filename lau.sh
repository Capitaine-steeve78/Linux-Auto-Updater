case "${1:-}" in
  install)
    source "$SCRIPT_DIR/scripts/install.sh"
    install_main
    ;;

  update)
    source "$SCRIPT_DIR/scripts/update.sh"
    update_main
    ;;

  self-update)
    source "$SCRIPT_DIR/scripts/self_update.sh"
    self_update
    ;;

  configure)
    source "$SCRIPT_DIR/scripts/configure.sh"
    configure_main "${@:2}"
    ;;

  *)
    CMD="$1"
    shift || true

    CMD_FILE="$SCRIPT_DIR/commands/$CMD.sh"

    if [[ -f "$CMD_FILE" ]]; then
      source "$CMD_FILE"
      main "$@"
    else
      echo "Unknown command: $CMD"
      exit 1
    fi
    ;;
esac