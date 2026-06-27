BACKUP_DIR="/opt/linux-auto-updater-BACKUP"

update_main() {
  require_root
  info "Updating project..."

  cd /opt/linux-auto-updater

  cp -a /opt/linux-auto-updater "$BACKUP_DIR"

  OLD=$(git rev-parse HEAD)

  if ! git pull; then
    error "Git failed → rollback"
    rm -rf /opt/linux-auto-updater
    mv "$BACKUP_DIR" /opt/linux-auto-updater
    exit 1
  fi

  if ! uv sync; then
    error "uv failed → rollback"
    rm -rf /opt/linux-auto-updater
    mv "$BACKUP_DIR" /opt/linux-auto-updater
    exit 1
  fi

  NEW=$(git rev-parse HEAD)

  if [[ "$OLD" != "$NEW" ]]; then
    systemctl restart linux-auto-updater.timer
  fi

  info "Update complete"
}