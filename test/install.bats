#!/usr/bin/env bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'

bats_require_minimum_version 1.5.0

DOTREPO="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"

setup() {
  export HOME="$(mktemp -d)"
  # fake project dir inside fake HOME
  mkdir -p "$HOME/dotfiles/zshrc"
  cp -r "$DOTREPO"/* "$HOME/dotfiles/" 2>/dev/null || true
  # minimal repo layout for sourcing
  mkdir -p "$HOME/dotfiles/nvim" "$HOME/dotfiles/ghostty"
  touch "$HOME/dotfiles/ghostty/config"
  echo "# test zshrc" > "$HOME/dotfiles/zshrc/.zshrc"
  echo "# p10k" > "$HOME/dotfiles/zshrc/.p10k.zsh"

  # Make install.sh's DOTFILES point at the copy by sourcing a copy
  cp "$DOTREPO/install.sh" "$HOME/install.sh"
}

teardown() {
  [ -n "$HOME" ] && rm -rf "$HOME"
}

# ---- backup_and_link ----

@test "backup_and_link creates symlink for new destination" {
  source "$HOME/install.sh"
  mkdir -p "$HOME/dotfiles"
  backup_and_link "$HOME/dotfiles/zshrc/.zshrc" "$HOME/.zshrc"
  [ -L "$HOME/.zshrc" ]
  [ "$(readlink -f "$HOME/.zshrc")" = "$(readlink -f "$HOME/dotfiles/zshrc/.zshrc")" ]
}

@test "backup_and_link backs up existing file before linking" {
  source "$HOME/install.sh"
  echo "original" > "$HOME/.zshrc"
  backup_and_link "$HOME/dotfiles/zshrc/.zshrc" "$HOME/.zshrc"
  [ -L "$HOME/.zshrc" ]
  grep -q "original" "$BACKUP_DIR/.zshrc"
}

@test "backup_and_link skips when already correctly linked" {
  source "$HOME/install.sh"
  ln -s "$HOME/dotfiles/zshrc/.zshrc" "$HOME/.zshrc"
  run backup_and_link "$HOME/dotfiles/zshrc/.zshrc" "$HOME/.zshrc"
  assert_success
  assert_output --partial "already linked"
}

@test "link_all links nvim, ghostty, zshrc and p10k" {
  source "$HOME/install.sh"
  link_all
  [ -L "$HOME/.config/nvim" ]
  [ -L "$HOME/.config/ghostty/config" ]
  [ -L "$HOME/.zshrc" ]
  [ -L "$HOME/.p10k.zsh" ]
}

# ---- nvim arch detection ----

@test "nvim tarball url uses x86_64 arch" {
  source "$HOME/install.sh"
  run nvim_tarball_name "x86_64"
  assert_output "nvim-linux-x86_64.tar.gz"
}

@test "nvim tarball url uses aarch64 arch" {
  source "$HOME/install.sh"
  run nvim_tarball_name "aarch64"
  assert_output "nvim-linux-aarch64.tar.gz"
}

@test "nvim tarball url falls back to x86_64 for unknown arch" {
  source "$HOME/install.sh"
  run nvim_tarball_name "armv7l"
  assert_output "nvim-linux-x86_64.tar.gz"
}

@test "nvim version parse: 0.9 triggers needs_nvim" {
  source "$HOME/install.sh"
  run -0 nvim_needs_upgrade "0.9.5"
}

@test "nvim version parse: 0.10 does not trigger needs_nvim" {
  source "$HOME/install.sh"
  run -1 nvim_needs_upgrade "0.10.2"
}

@test "nvim version parse: 1.2 does not trigger needs_nvim" {
  source "$HOME/install.sh"
  run -1 nvim_needs_upgrade "1.2.0"
}

# ---- conditional plugins in .zshrc (syntax check is plain zsh) ----

@test ".zshrc plugin list excludes plugins when binaries missing" {
  # Source plugin-list logic with docker/go/npm absent from PATH
  local out
  out=$(env -i HOME="$HOME" /bin/bash -c '
    function command { case "$2" in docker|go|npm) return 1;; *) return 0;; esac; }
    eval "$(sed -n "/Build plugin list conditionally/,/^plugins=/p" '"$DOTREPO"'/zshrc/.zshrc)"
    echo "${plugins[*]}"
  ')
  assert_equal "$out" "git zsh-autosuggestions zsh-syntax-highlighting"
}
