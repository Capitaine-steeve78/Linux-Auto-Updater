CONFIG_FILE="/etc/linux-auto-updater/config.yaml"

load_config() {
  INSTALL_DIR=$(grep "^install_dir:" "$CONFIG_FILE" | awk '{print $2}')
  INTERVAL_MINUTES=$(grep "^interval_minutes:" "$CONFIG_FILE" | awk '{print $2}')
  BRANCH=$(grep "^branch:" "$CONFIG_FILE" | awk '{print $2}')
}