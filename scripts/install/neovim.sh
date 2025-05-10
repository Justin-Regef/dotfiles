#!/usr/bin/env bash

# Source common utilities
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source "$SCRIPT_DIR/utils.sh"

install_macos() {
  info "Installing Neovim on macOS..."
  
  if ! command_exists brew; then
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    if [ -f "/opt/homebrew/bin/brew" ]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -f "/usr/local/bin/brew" ]; then
      eval "$(/usr/local/bin/brew shellenv)"
    fi
  fi
  
  brew update
  brew install neovim
  success "Neovim installed on macOS"
}

install_debian() {
  info "Installing Neovim on Debian/Ubuntu..."
  
  sudo apt-get update
  sudo apt-get install -y \
    ninja-build \
    gettext \
    libtool \
    libtool-bin \
    autoconf \
    automake \
    pkg-config \
    doxygen \
    libluajit-5.1-dev \
    libunibilium-dev \
    libmsgpack-dev \
    libtermkey-dev \
    libvterm-dev \
    libutf8proc-dev
    
  git clone https://github.com/neovim/neovim /tmp/neovim
  cd /tmp/neovim
  git checkout stable
  make CMAKE_BUILD_TYPE=Release
  sudo make install
  cd -
  rm -rf /tmp/neovim
  
  success "Neovim installed on Debian/Ubuntu"
}

install_arch() {
  info "Installing Neovim on Arch Linux..."
  sudo pacman -S --needed --noconfirm neovim
  success "Neovim installed on Arch Linux"
}

install_fedora() {
  info "Installing Neovim on Fedora..."
  sudo dnf install -y neovim
  success "Neovim installed on Fedora"
}

setup_neovim_config() {
  info "Setting up Neovim configuration..."
  
  NVIM_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
  ensure_dir "$NVIM_CONFIG_DIR"
  
  # Get the root directory of the dotfiles repository
  DOTFILES_ROOT="$( cd "$SCRIPT_DIR/../.." &> /dev/null && pwd )"
  
  # Create symlinks for all Neovim configuration files
  for file in "$DOTFILES_ROOT/nvim"/*; do
    if [ -f "$file" ]; then
      create_symlink "$file" "$NVIM_CONFIG_DIR/$(basename "$file")"
    fi
  done
  
  # Create symlinks for directories
  for dir in "$DOTFILES_ROOT/nvim"/*/; do
    if [ -d "$dir" ]; then
      create_symlink "$dir" "$NVIM_CONFIG_DIR/$(basename "$dir")"
    fi
  done
  
  success "Neovim configuration set up successfully"
}

main() {
  OS=$(get_os)
  info "Detected OS: $OS"
  
  case "$OS" in
    macos)
      install_macos
      ;;
    debian)
      install_debian
      ;;
    arch)
      install_arch
      ;;
    fedora)
      install_fedora
      ;;
    *)
      error "Unsupported OS: $OS"
      exit 1
      ;;
  esac
  
  setup_neovim_config
}

main 