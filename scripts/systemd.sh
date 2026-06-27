SERVICE_FILE="/etc/systemd/system/mon-projet.service"
TIMER_FILE="/etc/systemd/system/mon-projet.timer"

create_systemd() {
  local interval="$1"

  cat > "$SERVICE_FILE" <<EOF
[Unit]
Description=Mon Projet

[Service]
Type=oneshot
User=root
WorkingDirectory=/opt/mon-projet
ExecStart=/opt/mon-projet/.venv/bin/python /opt/mon-projet/main.py

NoNewPrivileges=true
PrivateTmp=true
ProtectSystem=strict
ProtectHome=true
ReadWritePaths=/opt/mon-projet /var/log/mon-projet.log
StandardOutput=journal
StandardError=journal
EOF

  cat > "$TIMER_FILE" <<EOF
[Unit]
Description=Mon Projet Timer

[Timer]
OnBootSec=30s
OnUnitActiveSec=${interval}min
Persistent=true

[Install]
WantedBy=timers.target
EOF
}