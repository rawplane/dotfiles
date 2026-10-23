#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR=""

log() {
  echo -e "\033[1;34m::\033[0m $*"
}

warn() {
  echo -e "\033[1;33mwarning:\033[0m $*"
}

success() {
  echo -e "\033[1;32m==>\033[0m $*"
}

backup_and_link() {
  local src="$1" dst="$2"

  if [[ -L "$dst" ]] && [[ "$(readlink -f "$dst")" == "$(readlink -f "$src")" ]]; then
    echo "  already linked: $dst"
    return 0
  fi

  if [[ -e "$dst" || -L "$dst" ]]; then
    if [[ -z "$BACKUP_DIR" ]]; then
      BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"
      mkdir -p "$BACKUP_DIR"
      log "Backup folder created at $BACKUP_DIR"
    fi
    mv "$dst" "$BACKUP_DIR/"
    echo "  backup: $dst -> $BACKUP_DIR/"
  fi

  mkdir -p "$(dirname "$dst")"
  ln -sf "$src" "$dst"
  echo "  linked: $dst -> $src"
}

install_deps() {
  log "Checking and installing dependencies for Linux Mint / Debian..."

  if command -v apt >/dev/null 2>&1; then
    sudo apt update
    sudo apt install -y git curl zsh ripgrep fd-find build-essential
  else
    warn "APT not found. Install git, curl, zsh, ripgrep, fd-find manually."
  fi

  # Fix fd name on Ubuntu/Debian
  if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
    mkdir -p "$HOME/.local/bin"
    ln -sf "$(which fdfind)" "$HOME/.local/bin/fd"
    echo "  aliased: fdfind -> ~/.local/bin/fd"
  fi

  # Neovim >= 0.10 check
  local needs_nvim=0
  if ! command -v nvim >/dev/null 2>&1; then
    needs_nvim=1
  else
    local v maj min
    v=$(nvim --version | head -n1 | grep -oE '[0-9]+\.[0-9]+' | head -n1 || echo "0.0")
    maj=$(echo "$v" | cut -d. -f1)
    min=$(echo "$v" | cut -d. -f2)
    if (( maj == 0 && min < 10 )); then
      needs_nvim=1
    fi
  fi

  if [[ "$needs_nvim" -eq 1 ]]; then
    log "Installing latest Neovim to ~/.local..."
    mkdir -p "$HOME/.local"
    curl -sSL "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz" | tar -C "$HOME/.local" --strip-components=1 -xz
    echo "  neovim installed in ~/.local/bin/nvim"
  fi

  # Oh My Zsh
  if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    log "Installing Oh My Zsh..."
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi

  # Zsh theme & plugins
  local custom_zsh="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
  if [[ ! -d "$custom_zsh/themes/powerlevel10k" ]]; then
    log "Cloning Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$custom_zsh/themes/powerlevel10k"
  fi

  if [[ ! -d "$custom_zsh/plugins/zsh-autosuggestions" ]]; then
    log "Cloning zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$custom_zsh/plugins/zsh-autosuggestions"
  fi

  if [[ ! -d "$custom_zsh/plugins/zsh-syntax-highlighting" ]]; then
    log "Cloning zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$custom_zsh/plugins/zsh-syntax-highlighting"
  fi

  # Set default shell to zsh
  if [[ "$SHELL" != *"zsh"* ]] && command -v zsh >/dev/null 2>&1; then
    log "Changing default shell to zsh..."
    chsh -s "$(which zsh)" || warn "Failed to change shell automatically. Run: chsh -s \$(which zsh)"
  fi
}

link_all() {
  log "Linking configuration files..."

  # Neovim
  backup_and_link "$DOTFILES/nvim" "$HOME/.config/nvim"

  # Ghostty
  backup_and_link "$DOTFILES/ghostty/config" "$HOME/.config/ghostty/config"

  # Zsh
  backup_and_link "$DOTFILES/zshrc/.zshrc" "$HOME/.zshrc"
  backup_and_link "$DOTFILES/zshrc/.p10k.zsh" "$HOME/.p10k.zsh"
}

usage() {
  echo "Usage: $0 [OPTIONS]"
  echo "Options:"
  echo "  -d, --deps     Install dependencies (packages, OMZ, plugins, Neovim)"
  echo "  -l, --link     Only link configuration files (with backup)"
  echo "  -a, --all      Install dependencies and link configurations"
  echo "  -h, --help     Show this help message"
}

main() {
  case "${1:-}" in
    -d|--deps)
      install_deps
      ;;
    -l|--link)
      link_all
      ;;
    -a|--all)
      install_deps
      link_all
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    "")
      # Interactive default or link if not interactive
      if [[ -t 0 ]]; then
        read -rp "Install system dependencies & zsh plugins? [y/N]: " answer
        if [[ "$answer" =~ ^[Yy]$ ]]; then
          install_deps
        fi
      fi
      link_all
      ;;
    *)
      echo "Unknown option: $1"
      usage
      exit 1
      ;;
  esac

  success "Dotfiles setup completed!"
  if [[ -n "$BACKUP_DIR" ]]; then
    echo "Existing configs were safely backed up to: $BACKUP_DIR"
  fi
}

main "$@"
