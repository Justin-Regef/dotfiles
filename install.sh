#!/usr/bin/env bash

set -e

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

# Function to install packages on macOS
install_macos_packages() {
  info "Installing required packages on macOS..."

  # Check if Homebrew is installed
  if ! command_exists brew; then
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for the current session
    if [ -f "/opt/homebrew/bin/brew" ]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -f "/usr/local/bin/brew" ]; then
      eval "$(/usr/local/bin/brew shellenv)"
    fi
  fi

  # Install packages using Homebrew
  brew update

  # Install Neovim
  if ! command_exists nvim; then
    info "Installing Neovim..."
    brew install neovim
  else
    info "Updating Neovim..."
    brew upgrade neovim
  fi

  # Install dependencies
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

  success "All required packages installed on macOS."
}

# Function to install packages on Debian/Ubuntu
install_debian_packages() {
  info "Installing required packages on Debian/Ubuntu..."

  # Update package lists
  sudo apt-get update

  # Install dependencies
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

  # Install Neovim from source (for latest version)
  if ! command_exists nvim; then
    info "Building Neovim from source..."

    # Install build dependencies
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

    # Clone and build Neovim
    git clone https://github.com/neovim/neovim /tmp/neovim
    cd /tmp/neovim
    git checkout stable
    make CMAKE_BUILD_TYPE=Release
    sudo make install
    cd -
    rm -rf /tmp/neovim
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

  success "All required packages installed on Debian/Ubuntu."
}

# Function to install packages on Arch Linux
install_arch_packages() {
  info "Installing required packages on Arch Linux..."

  # Update package database
  sudo pacman -Syu --noconfirm

  # Install packages
  sudo pacman -S --needed --noconfirm \
    neovim \
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

  success "All required packages installed on Arch Linux."
}

# Function to install packages on Fedora
install_fedora_packages() {
  info "Installing required packages on Fedora..."

  # Update package database
  sudo dnf check-update

  # Install packages
  sudo dnf install -y \
    neovim \
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

  success "All required packages installed on Fedora."
}

# Function to install packages on unknown Linux distributions
install_linux_packages() {
  error "Automatic installation is not supported for your Linux distribution."
  error "Please install the following packages manually:"
  echo "- neovim (latest version)"
  echo "- git"
  echo "- lazygit"
  echo "- nodejs"
  echo "- ripgrep"
  echo "- fd"
  echo "- fzf"
  echo "- cowsay"
  echo "- python3"
  echo "- pip"
  echo "- cmake"
  echo "- Compiler toolchain (GCC, Make, etc.)"
  exit 1
}

# Function to install extra Python packages
install_python_packages() {
  info "Installing Python packages..."

  python3 -m pip install --user --upgrade pynvim

  success "Python packages installed."
}

# Function to install extra Node.js packages
install_node_packages() {
  info "Installing Node.js packages..."

  npm install -g neovim

  success "Node.js packages installed."
}

# Function to setup Neovim configuration
setup_neovim_config() {
  info "Setting up Neovim configuration..."

  # Create Neovim config directory if it doesn't exist
  NVIM_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
  mkdir -p "$NVIM_CONFIG_DIR"

  # Copy configuration files
  SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

  if [ -d "$SCRIPT_DIR/nvim" ]; then
    # Backup existing configuration if it exists and is not a symlink
    if [ -d "$NVIM_CONFIG_DIR" ] && [ ! -L "$NVIM_CONFIG_DIR" ]; then
      BACKUP_DIR="$NVIM_CONFIG_DIR.backup.$(date +%Y%m%d%H%M%S)"
      warn "Existing Neovim configuration found. Backing up to $BACKUP_DIR"
      mv "$NVIM_CONFIG_DIR" "$BACKUP_DIR"
      mkdir -p "$NVIM_CONFIG_DIR"
    fi

    # Create symlinks to Neovim configuration files
    info "Creating symlinks to Neovim configuration files..."

    for file in "$SCRIPT_DIR"/nvim/*; do
      filename=$(basename "$file")
      if [ ! -e "$NVIM_CONFIG_DIR/$filename" ]; then
        ln -sf "$file" "$NVIM_CONFIG_DIR/$filename"
      fi
    done

    # Create symlinks for directories
    for dir in "$SCRIPT_DIR"/nvim/*/; do
      dirname=$(basename "$dir")
      if [ ! -e "$NVIM_CONFIG_DIR/$dirname" ]; then
        ln -sf "$dir" "$NVIM_CONFIG_DIR/$dirname"
      fi
    done

    success "Neovim configuration set up successfully."
  else
    error "Neovim configuration directory not found in the repository."
    exit 1
  fi
}

# Function to print a summary of installed tools
print_summary() {
  success "Installation complete!"
  echo ""
  echo "Installed tools:"
  echo "- Neovim: $(nvim --version | head -n1)"

  if command_exists node; then
    echo "- Node.js: $(node --version)"
  fi

  if command_exists npm; then
    echo "- npm: $(npm --version)"
  fi

  if command_exists lazygit; then
    echo "- lazygit: $(lazygit --version | cut -d ' ' -f 3)"
  fi

  if command_exists fzf; then
    echo "- fzf: $(fzf --version)"
  fi

  if command_exists cowsay; then
    cowsay "Installation complete! Your Neovim is ready to use."
  fi

  echo ""
  echo "To start using Neovim, simply run: nvim"
  echo "The first time you run Neovim, it will install all the plugins configured in your setup."
}

# Main function
main() {
  info "Starting installation..."

  # Get OS type
  OS=$(get_os)
  info "Detected OS: $OS"

  # Install packages based on OS
  case "$OS" in
    macos)
      install_macos_packages
      ;;
    debian)
      install_debian_packages
      ;;
    arch)
      install_arch_packages
      ;;
    fedora)
      install_fedora_packages
      ;;
    *)
      install_linux_packages
      ;;
  esac

  # Install extra Python packages
  install_python_packages

  # Install extra Node.js packages
  install_node_packages

  # Setup Neovim configuration
  setup_neovim_config

  # Print summary
  print_summary
}

# Run the main function
main
