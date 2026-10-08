#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  ln -sf "$src" "$dst"
  echo "linked: $dst -> $src"
}

# Neovim
link "$DOTFILES/nvim" "$HOME/.config/nvim"

# Ghostty
link "$DOTFILES/ghostty/config" "$HOME/.config/ghostty/config"

# Zsh
link "$DOTFILES/zshrc/.zshrc" "$HOME/.zshrc"

# Doom Emacs
link "$DOTFILES/doom.d" "$HOME/.doom.d"

echo "Done."
