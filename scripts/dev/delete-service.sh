#!/bin/bash

set -e

if [ "$EUID" -eq 0 ]; then
  SUDO=""
else
  SUDO="sudo"
fi

echo "1 - Stopping services..."

$SUDO systemctl stop linux-auto-updater.service
$SUDO systemctl stop linux-auto-updater.timer

echo "1 - Services Stopped."
echo "2 - Disabling services..."

$SUDO systemctl disable linux-auto-updater.service
$SUDO systemctl disable linux-auto-updater.timer

echo "2 - Services disabled."
echo "3 - Delete Services..."

$SUDO rm /etc/systemd/system/linux-auto-updater.service
$SUDO rm /etc/systemd/system/linux-auto-updater.timer

echo "3 - Services deleted"
echo "4 - Reloading daemon"

$SUDO systemctl daemon-reload

echo "4 - Daemon reloaded"

echo "OK."
