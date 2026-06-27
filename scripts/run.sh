#!/bin/bash

set -e

PROJECT_DIR="/opt/linux-auto-updater"

cd "$PROJECT_DIR" || {
  echo "ERROR: project directory not found: $PROJECT_DIR"
  exit 1
}

export PATH="$HOME/.local/bin:$PATH"

uv run python main.py