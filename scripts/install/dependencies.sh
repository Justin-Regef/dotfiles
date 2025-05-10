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
    go \
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
    python3-venv \
    python3-dev \
    python3-setuptools \
    python3-wheel \
    fzf \
    cowsay \
    ripgrep \
    fd-find \
    build-essential \
    golang-go \
    nodejs \
    npm
    
  # Create symlink for fd
  if ! command_exists fd && command_exists fdfind; then
    sudo ln -sf "$(which fdfind)" /usr/local/bin/fd
  fi
  
  # Install Node.js using n if not already installed
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
    go \
    ripgrep \
    fd \
    lazygit \
    fzf \
    cowsay \
    wget \
    curl \
    python \
    python-pip \
    python-setuptools \
    python-wheel \
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
    npm \
    golang \
    ripgrep \
    fd-find \
    fzf \
    cowsay \
    wget \
    curl \
    python3 \
    python3-pip \
    python3-devel \
    python3-setuptools \
    python3-wheel \
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
  
  # Install uv if not already installed
  if ! command_exists uv; then
    info "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
  fi
  
  # Use uv to install Python packages
  uv pip install --user \
    pynvim \
    setuptools \
    wheel \
    ruff \
    black \
    isort \
    mypy \
    python-lsp-server
    
  # Create a virtual environment for Mason
  if [ ! -d "$HOME/.local/share/nvim/mason/packages/python-lsp-server/venv" ]; then
    python3 -m venv "$HOME/.local/share/nvim/mason/packages/python-lsp-server/venv"
  fi
  
  success "Python packages installed"
}

install_node_packages() {
  info "Installing Node.js packages..."
  
  # Install global npm packages
  npm install -g \
    neovim \
    typescript \
    typescript-language-server \
    eslint \
    prettier \
    @typescript-eslint/parser \
    @typescript-eslint/eslint-plugin \
    eslint-plugin-prettier \
    eslint-config-prettier
    
  success "Node.js packages installed"
}

install_go_packages() {
  info "Installing Go packages..."
  
  # Install Go tools
  go install golang.org/x/tools/gopls@latest
  go install github.com/go-delve/delve/cmd/dlv@latest
  go install github.com/ramya-rao-a/go-outline@latest
  go install github.com/cweill/gotests/gotests@latest
  go install github.com/fatih/gomodifytags@latest
  go install github.com/josharian/impl@latest
  go install github.com/haya14busa/goplay/cmd/goplay@latest
  go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
  
  success "Go packages installed"
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
  install_go_packages
}

main 