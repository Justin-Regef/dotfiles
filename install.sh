#!/usr/bin/env bash

set -e

# Source common utilities
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source "$SCRIPT_DIR/scripts/install/utils.sh"

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

main() {
  info "Starting installation..."

  # Make all scripts executable
  chmod +x "$SCRIPT_DIR/scripts/install/"*.sh

  # Install dependencies
  info "Installing dependencies..."
  "$SCRIPT_DIR/scripts/install/dependencies.sh"

  # Install Neovim and its configuration
  info "Installing Neovim and its configuration..."
  "$SCRIPT_DIR/scripts/install/neovim.sh"

  # Print summary
  print_summary
}

main
