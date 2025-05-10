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

## Installed Packages

### Core Tools
- Neovim (latest version)
- Git
- LazyGit (Git TUI)
- ripgrep (fast code search)
- fd (fast file finder)
- fzf (fuzzy finder)
- cowsay (fun messages)

### Python Development
- Python 3
- uv (fast Python package installer)
- pip
- Virtual Environment support
- Development headers
- Essential packages:
  - pynvim
  - ruff (linter)
  - black (formatter)
  - isort (import sorter)
  - mypy (type checker)
  - python-lsp-server

### Node.js Development
- Node.js
- npm
- TypeScript
- Essential packages:
  - typescript-language-server
  - eslint
  - prettier
  - @typescript-eslint/parser
  - @typescript-eslint/eslint-plugin
  - eslint-plugin-prettier
  - eslint-config-prettier

### Go Development
- Go
- Essential tools:
  - gopls (Go language server)
  - dlv (Go debugger)
  - go-outline (code outline)
  - gotests (test generator)
  - gomodifytags (struct tag modifier)
  - impl (interface implementation)
  - goplay (playground)
  - golangci-lint (linter)

### Build Tools
- CMake
- Make
- GCC/G++ (C/C++ compiler)
- Build essentials

### System Utilities
- wget
- curl
- unzip
- luajit

## Features

### Language Support
- Python LSP with:
  - Code completion
  - Type checking
  - Linting
  - Formatting
  - Import sorting

- TypeScript/JavaScript LSP with:
  - Code completion
  - Type checking
  - Linting
  - Formatting
  - ESLint integration

- Go LSP with:
  - Code completion
  - Type checking
  - Linting
  - Debugging
  - Test generation
  - Interface implementation

### Development Tools
- Git integration with LazyGit
- Fast code search with ripgrep
- Fuzzy file finding with fzf
- Code formatting with Prettier
- Linting with ESLint and golangci-lint
- Debugging support for JavaScript and Go

## Requirements

The installation script supports the following operating systems:
- macOS
- Debian/Ubuntu
- Arch Linux
- Fedora

For other Linux distributions, you may need to install the required packages manually.
