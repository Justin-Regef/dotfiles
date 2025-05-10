#!/usr/bin/env bash

# Source common utilities
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source "$SCRIPT_DIR/utils.sh"

install_macos() {
  info "Installing dependencies on macOS..."
  
  brew install \
    ripgrep \
    fd \
    lazygit \
    node \
    fzf \
    cowsay \
    wget \
    curl \
    git \
    cmake \
    python \
    luajit \
    unzip
    
  # Install fzf key bindings
  $(brew --prefix)/opt/fzf/install --all
  
  success "Dependencies installed on macOS"
}

install_debian() {
  info "Installing dependencies on Debian/Ubuntu..."
  
  sudo apt-get update
  sudo apt-get install -y \
    git \
    curl \
    wget \
    unzip \
    cmake \
    python3 \
    python3-pip \
    fzf \
    cowsay \
    ripgrep \
    fd-find \
    build-essential
    
  # Create symlink for fd
  if ! command_exists fd && command_exists fdfind; then
    sudo ln -sf "$(which fdfind)" /usr/local/bin/fd
  fi
  
  # Install Node.js using n
  if ! command_exists node; then
    info "Installing Node.js..."
    curl -fsSL https://raw.githubusercontent.com/mklement0/n-install/master/bin/n-install | bash -s -- -y lts
    export PATH="$HOME/n/bin:$PATH"
  fi
  
  # Install lazygit
  if ! command_exists lazygit; then
    info "Installing lazygit..."
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit /usr/local/bin
    rm lazygit lazygit.tar.gz
  fi
  
  success "Dependencies installed on Debian/Ubuntu"
}

install_arch() {
  info "Installing dependencies on Arch Linux..."
  
  sudo pacman -S --needed --noconfirm \
    git \
    nodejs \
    npm \
    ripgrep \
    fd \
    lazygit \
    fzf \
    cowsay \
    wget \
    curl \
    python \
    python-pip \
    cmake \
    unzip \
    base-devel
    
  success "Dependencies installed on Arch Linux"
}

install_fedora() {
  info "Installing dependencies on Fedora..."
  
  sudo dnf install -y \
    git \
    nodejs \
    ripgrep \
    fd-find \
    fzf \
    cowsay \
    wget \
    curl \
    python3 \
    python3-pip \
    cmake \
    unzip \
    make \
    gcc \
    gcc-c++
    
  # Create symlink for fd
  if ! command_exists fd && command_exists fdfind; then
    sudo ln -sf "$(which fdfind)" /usr/local/bin/fd
  fi
  
  # Install lazygit
  if ! command_exists lazygit; then
    info "Installing lazygit..."
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit /usr/local/bin
    rm lazygit lazygit.tar.gz
  fi
  
  success "Dependencies installed on Fedora"
}

install_python_packages() {
  info "Installing Python packages..."
  python3 -m pip install --user --upgrade pynvim
  success "Python packages installed"
}

install_node_packages() {
  info "Installing Node.js packages..."
  npm install -g neovim
  success "Node.js packages installed"
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
  
  install_python_packages
  install_node_packages
}

main 