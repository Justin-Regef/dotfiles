# dotfiles
Just a dump of my dot files

## Installation

This repository contains my personal dotfiles and configuration, including:

- Neovim configuration with LazyVim
- Various tools and utilities

### Automated Setup

To install everything (Neovim, dependencies, and configuration):

```bash
git clone https://github.com/yourusername/dotfiles.git
cd dotfiles
chmod +x install.sh
./install.sh
```

### Manual Installation

If you prefer to install components individually, you can run the scripts in the `scripts/install` directory:

1. Install dependencies:
```bash
./scripts/install/dependencies.sh
```

2. Install Neovim and its configuration:
```bash
./scripts/install/neovim.sh
```

Each script is modular and can be run independently. The scripts will automatically detect your operating system and install the appropriate packages.
