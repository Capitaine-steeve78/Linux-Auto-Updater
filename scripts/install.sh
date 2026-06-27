REPO_URL="https://github.com/Capitaine-steeve78/Linux-Auto-Updater.git"
INSTALL_DIR="/opt/linux-auto-updater"

install_main() {
  require_root

  info "Installing..."

  command -v git >/dev/null || apt install -y git
  command -v curl >/dev/null || apt install -y curl

  if ! command -v uv >/dev/null; then
    info "Installing uv"
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.local/bin:$PATH"
  fi

  if [[ -d "$INSTALL_DIR/.git" ]]; then
    git -C "$INSTALL_DIR" pull
  else
    git clone "$REPO_URL" "$INSTALL_DIR"
  fi

  cd "$INSTALL_DIR"

  uv sync

  CONFIG="/etc/linux-auto-updater/config.yaml"
  if [[ ! -f "$CONFIG" ]]; then
    mkdir -p /etc/linux-auto-updater
    cat > "$CONFIG" <<EOF
install_dir=/opt/linux-auto-updater
interval_minutes=60
branch=main
auto_update_installer=true
require_signed_commits=false
EOF
  fi

  load_config

  source "$SCRIPT_DIR/lib/systemd.sh"
  create_systemd "$INTERVAL_MINUTES"

  systemctl daemon-reload
  systemctl enable linux-auto-updater.timer
  systemctl start linux-auto-updater.timer

  info "Installed successfully"
}