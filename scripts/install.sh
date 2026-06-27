#!/bin/bash

set -e

# =========================
# GESTION ROOT / SUDO
# =========================
if [ "$EUID" -eq 0 ]; then
  SUDO=""
else
  SUDO="sudo"
fi

# =========================
# CONFIG À MODIFIER
# =========================
REPO_URL="https://github.com/Capitaine-steeve78/Linux-auto-updater.git"
NOM_APP="linux-auto-updater"
DOSSIER_INSTALL="/opt/$NOM_APP"

# =========================
# FONCTION INSTALLATION
# =========================
installer_paquet() {
  PAQUET=$1
  echo "Initializing $PAQUET..."

  if command -v apt >/dev/null 2>&1; then
    $SUDO apt update && $SUDO apt install -y "$PAQUET"
  elif command -v dnf >/dev/null 2>&1; then
    $SUDO dnf install -y "$PAQUET"
  elif command -v pacman >/dev/null 2>&1; then
    $SUDO pacman -S --noconfirm "$PAQUET"
  else
    echo "ERROR: Unsupported package manager."
    exit 1
  fi
}

# =========================
# VÉRIFICATION DÉPENDANCES
# =========================
for cmd in git uv; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "The '$cmd' program isn't installed."
    read -p "Do you want to install it? (y/n) : " rep

    if [[ "$rep" != "y" && "$rep" != "Y" && "$rep" != "Yes" && "$rep" != "yes" ]]; then
      echo "ERROR: Installation refused. Linux-Auto-Updater install stopped."
      exit 1
    fi

    installer_paquet "$cmd"
  fi
done

# =========================
# VERSION DU REPO
# =========================
VERSION="main"

# =========================
# CLONAGE REPO
# =========================
echo "Cloning repo..."

$SUDO rm -rf "$DOSSIER_INSTALL"

$SUDO git clone -b "$VERSION" "$REPO_URL" "$DOSSIER_INSTALL"

cd "$DOSSIER_INSTALL" || exit 1

# =========================
# INSTALLATION UV
# =========================
echo "Installing dependencies with uv..."
uv sync || true

# =========================
# INTERVALLE SYSTEMD
# =========================
read -p "How often should the service run? (in minutes) : " MINUTES

if ! [[ "$MINUTES" =~ ^[0-9]+$ ]]; then
  echo "ERROR: Invalid Value."
  exit 1
fi

# =========================
# SERVICE SYSTEMD
# =========================
SERVICE_PATH="/etc/systemd/system/${NOM_APP}.service"
TIMER_PATH="/etc/systemd/system/${NOM_APP}.timer"

echo "Creating systemd service..."

$SUDO tee "$SERVICE_PATH" > /dev/null <<EOF
[Unit]
Description=Service $NOM_APP

[Service]
Type=oneshot
WorkingDirectory=$DOSSIER_INSTALL
ExecStart=/usr/bin/env bash $DOSSIER_INSTALL/lau.sh run
EOF

# =========================
# TIMER SYSTEMD
# =========================
$SUDO tee "$TIMER_PATH" > /dev/null <<EOF
[Unit]
Description=Timer $NOM_APP

[Timer]
OnBootSec=1min
OnUnitActiveSec=${MINUTES}min
Unit=${NOM_APP}.service

[Install]
WantedBy=timers.target
EOF

# =========================
# ACTIVATION
# =========================
echo "Activating service..."

$SUDO systemctl daemon-reload
$SUDO systemctl enable --now "${NOM_APP}.timer"

echo "Creating command..."
$SUDO ln -sf "$DOSSIER_INSTALL/lau.sh" /usr/local/bin/lau

echo "Command created."

echo "SUCCESS: Installation completed successfully !"
echo " "
echo "-----NOTE-----"
echo "Now you can use 'lau <command>' to use Linux auto Updater."
echo " "
echo "thanks for using Linux Auto Updater !"
echo "--------------"