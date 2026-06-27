configure_main() {
  require_root

  CONFIG="/etc/linux-auto-updater/config.yaml"

  echo "Current interval:"
  grep interval_minutes "$CONFIG"

  read -rp "New interval (min): " val

  sed -i "s/^interval_minutes:.*/interval_minutes: $val/" "$CONFIG"

  source "$SCRIPT_DIR/lib/config.sh"
  load_config

  source "$SCRIPT_DIR/lib/systemd.sh"
  create_systemd "$val"

  systemctl daemon-reload
  systemctl restart linux-auto-updater.timer

  info "Updated interval to $val min"
}