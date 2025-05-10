#!/usr/bin/env bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print a message with a colored prefix
log() {
  local prefix="$1"
  local message="$2"
  local color="$3"
  echo -e "${color}[${prefix}]${NC} ${message}"
}

info() {
  log "INFO" "$1" "${BLUE}"
}

success() {
  log "SUCCESS" "$1" "${GREEN}"
}

warn() {
  log "WARNING" "$1" "${YELLOW}"
}

error() {
  log "ERROR" "$1" "${RED}"
}

# Function to check if a command exists
command_exists() {
  command -v "$1" &> /dev/null
}

# Function to get the OS type
get_os() {
  case "$(uname -s)" in
    Darwin*)
      echo "macos"
      ;;
    Linux*)
      if [ -f /etc/debian_version ]; then
        echo "debian"
      elif [ -f /etc/fedora-release ]; then
        echo "fedora"
      elif [ -f /etc/arch-release ]; then
        echo "arch"
      else
        echo "linux"
      fi
      ;;
    *)
      echo "unknown"
      ;;
  esac
}

# Function to ensure a directory exists
ensure_dir() {
  local dir="$1"
  if [ ! -d "$dir" ]; then
    mkdir -p "$dir"
  fi
}

# Function to create a backup of a file or directory
create_backup() {
  local path="$1"
  if [ -e "$path" ] && [ ! -L "$path" ]; then
    local backup_path="${path}.backup.$(date +%Y%m%d%H%M%S)"
    warn "Creating backup of $path at $backup_path"
    mv "$path" "$backup_path"
  fi
}

# Function to create a symlink
create_symlink() {
  local source="$1"
  local target="$2"
  
  create_backup "$target"
  ln -sf "$source" "$target"
  success "Created symlink: $target -> $source"
} 