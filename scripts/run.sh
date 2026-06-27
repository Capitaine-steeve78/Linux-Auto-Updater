# shellcheck disable=SC2016
: '
#!/bin/bash

set -e

PROJECT_DIR="/opt/linux-auto-updater"

cd "$PROJECT_DIR" || {
  echo "ERROR: project directory not found: $PROJECT_DIR"
  exit 1
}

export PATH="$HOME/.local/bin:$PATH"

uv run python main.py
'

#!/bin/bash
set -e

PROJECT_DIR="/opt/linux-auto-updater"

cd "$PROJECT_DIR" || {
  echo "ERROR: project directory not found: $PROJECT_DIR"
  exit 1
}

# Récupération du HOME réel (robuste même si systemd ne le fournit pas)
HOME=$(getent passwd "$(id -u)" | cut -d: -f6)

# PATH standard + local user
export PATH="$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin"

# Vérification de uv
UV=$(command -v uv || true)

if [ -z "$UV" ]; then
  echo "ERROR: uv not found in PATH"
  echo "PATH=$PATH"
  exit 1
fi

# Exécution (remplace le shell, propre pour systemd)
exec "$UV" run python main.py