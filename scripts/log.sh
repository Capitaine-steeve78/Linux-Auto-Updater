LOG_FILE="/var/log/linux-auto-updater.log"

DEBUG="${DEBUG:-0}"

log() {
  local level="$1"
  shift
  local msg="$*"

  echo "[$level] $msg"
  logger -t mon-projet "[$level] $msg"

  mkdir -p "$(dirname "$LOG_FILE")"
  echo "[$(date '+%F %T')] [$level] $msg" >> "$LOG_FILE"
}

info()  { log "INFO" "$@"; }
warn()  { log "WARN" "$@"; }
error() { log "ERROR" "$@"; }
debug() { [[ "$DEBUG" == "1" ]] && log "DEBUG" "$@"; }

require_root() {
  if [[ "$EUID" -ne 0 ]]; then
    error "Root required"
    exit 1
  fi
}