# dotfiles

Personal dotfiles — managed with symlinks via `install.sh`.

## Structure

| Directory | Config for |
|-----------|------------|
| `nvim/` | Neovim (LazyVim) |
| `ghostty/` | Ghostty terminal |
| `zshrc/` | Zsh + Oh My Zsh + p10k |
| `doom.d/` | Doom Emacs |
| `archive/` | Archived configs (i3, picom) |

## Install

```bash
git clone <repo> ~/dotfiles
cd ~/dotfiles
./install.sh
```

## Notes

- Shell: zsh + Oh My Zsh + Powerlevel10k
- Editor: Neovim (LazyVim) + Doom Emacs
- Terminal: Ghostty
- Colorscheme: Catppuccin Mocha
