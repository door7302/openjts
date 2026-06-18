#!/usr/bin/env bash

set -euo pipefail

BACKUP_DIR="/tmp/jts-tmp"
LOG_FILE="/tmp/jts_backup.log"
USE_COLOR=1

if [ ! -t 1 ]; then
  USE_COLOR=0
fi

if [ "$USE_COLOR" -eq 1 ]; then
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  YELLOW='\033[1;33m'
  BLUE='\033[0;34m'
  NC='\033[0m'
else
  RED=''
  GREEN=''
  YELLOW=''
  BLUE=''
  NC=''
fi

log() {
  local level="$1"
  shift
  local message="$*"
  printf '%s [%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$level" "$message" | tee -a "$LOG_FILE"
}

info() {
  printf '%b%s%b\n' "$BLUE" "$*" "$NC"
  log "INFO" "$*"
}

success() {
  printf '%b%s%b\n' "$GREEN" "$*" "$NC"
  log "SUCCESS" "$*"
}

warn() {
  printf '%b%s%b\n' "$YELLOW" "$*" "$NC"
  log "WARN" "$*"
}

error() {
  printf '%b%s%b\n' "$RED" "$*" "$NC" >&2
  log "ERROR" "$*"
}

require_file() {
  local path="$1"
  if [ ! -f "$path" ]; then
    error "Required file not found: $path"
    exit 1
  fi
}

require_dir() {
  local path="$1"
  if [ ! -d "$path" ]; then
    error "Required directory not found: $path"
    exit 1
  fi
}

copy_dir_contents_if_any() {
  local src_dir="$1"
  local dst_dir="$2"

  mkdir -p "$dst_dir"

  if find "$src_dir" -mindepth 1 -maxdepth 1 | read -r _; then
    cp -a "$src_dir"/. "$dst_dir"/
    info "Copied content from $src_dir to $dst_dir"
  else
    warn "Directory $src_dir is empty, nothing to copy"
  fi
}

precheck_backup() {
  require_file "compose/.env"
  require_file "compose/jtso/db/jtso.db"
  require_file "compose/jtso/config.yml"
  require_file "compose/grafana/grafana.ini"
  require_file "compose/chronograf/chronograf.ini"
  require_dir "compose/grafana/cert"
  require_dir "compose/jtso/cert"
}

precheck_restore() {
  require_dir "$BACKUP_DIR"
  require_file "$BACKUP_DIR/.env"
  require_file "$BACKUP_DIR/jtso.db"
  require_file "$BACKUP_DIR/config.yml"
  require_file "$BACKUP_DIR/grafana.ini"
  require_file "$BACKUP_DIR/chronograf.ini"
}

backup_environment() {
  info "Starting backup..."
  precheck_backup

  mkdir -p "$BACKUP_DIR"
  mkdir -p "$BACKUP_DIR/gCerts"
  mkdir -p "$BACKUP_DIR/jCerts"

  cp "compose/.env" "$BACKUP_DIR/"
  cp "compose/jtso/db/jtso.db" "$BACKUP_DIR/"
  cp "compose/jtso/config.yml" "$BACKUP_DIR/"
  cp "compose/grafana/grafana.ini" "$BACKUP_DIR/"
  cp "compose/chronograf/chronograf.ini" "$BACKUP_DIR/"

  copy_dir_contents_if_any "compose/grafana/cert" "$BACKUP_DIR/gCerts"
  copy_dir_contents_if_any "compose/jtso/cert" "$BACKUP_DIR/jCerts"

  success "Backup completed in $BACKUP_DIR"
}

restore_environment() {
  precheck_restore

  read -r -p "Do you really want to restore? (yes/no): " confirm
  case "$confirm" in
    yes|y|Y|YES)
      info "Starting restore..."
      mkdir -p "compose/jtso/db"
      mkdir -p "compose/grafana"
      mkdir -p "compose/chronograf"
      mkdir -p "compose/grafana/cert"
      mkdir -p "compose/jtso/cert"

      cp "$BACKUP_DIR/.env" "compose/"
      cp "$BACKUP_DIR/jtso.db" "compose/jtso/db/"
      cp "$BACKUP_DIR/config.yml" "compose/jtso/"
      cp "$BACKUP_DIR/grafana.ini" "compose/grafana/"
      cp "$BACKUP_DIR/chronograf.ini" "compose/chronograf/"

      copy_dir_contents_if_any "$BACKUP_DIR/gCerts" "compose/grafana/cert"
      copy_dir_contents_if_any "$BACKUP_DIR/jCerts" "compose/jtso/cert"

      rm -rf "$BACKUP_DIR"
      success "Restore completed and temporary backup removed"
      ;;
    *)
      warn "Restore cancelled"
      ;;
  esac
}

usage() {
  cat <<'USAGE'
Usage:
  ./jts_backup.sh            Interactive mode
  ./jts_backup.sh backup     Run backup directly
  ./jts_backup.sh restore    Run restore directly
  ./jts_backup.sh -h         Show this help
USAGE
}

main() {
  : > "$LOG_FILE"

  if [ $# -gt 0 ]; then
    case "$1" in
      backup)
        backup_environment
        ;;
      restore)
        restore_environment
        ;;
      -h|--help)
        usage
        ;;
      *)
        error "Invalid argument: $1"
        usage
        exit 1
        ;;
    esac
    return
  fi

  echo "Choose an action:"
  echo "1) Backup environment files"
  echo "2) Restore environment files"
  read -r -p "Enter your choice (1/2): " choice

  case "$choice" in
    1)
      backup_environment
      ;;
    2)
      restore_environment
      ;;
    *)
      error "Invalid choice. Exiting."
      exit 1
      ;;
  esac
}

main "$@"