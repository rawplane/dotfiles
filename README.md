# dotfiles

Personal dotfiles for Linux Mint / Debian-based systems — managed via `install.sh` with automatic backups.

## Structure

| Directory | Configuration |
|-----------|---------------|
| `nvim/` | Neovim (LazyVim, Neovim >= 0.10) |
| `ghostty/` | Ghostty terminal |
| `zshrc/` | Zsh + Oh My Zsh + Powerlevel10k + plugins |
| `archive/` | Configuration archive (i3, picom, doom emacs) |

### Ghostty Terminal

Ghostty is not available via APT on Linux Mint. Install it manually:
- **Flatpak** (recommended): `flatpak install flathub com.mitchellh.ghostty`
- Or download a package from [ghostty.org](https://ghostty.org/download)

## Installation (Linux Mint)

### 1. Fresh Install (Install dependencies + link configurations)
```bash
git clone https://github.com/rawplane/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh -a
```
The `-a` / `--all` flag automatically:
- Installs system packages: `git`, `curl`, `zsh`, `ripgrep`, `fd-find`, `build-essential`.
- Installs/updates stable Neovim (>= 0.10) if the APT version is outdated.
- Installs Oh My Zsh + Powerlevel10k theme + autosuggestions & syntax-highlighting plugins.
- Backs up existing configs and creates symlinks.

### 2. Link Configurations Only (Without modifying system packages)
```bash
./install.sh -l
```

### `install.sh` CLI Options
- `-a, --all`: Install dependencies and link configs.
- `-d, --deps`: Install system dependencies & zsh plugins only.
- `-l, --link`: Link configs only with automatic backup.
- `-h, --help`: Show help message.

## Important Notes

- **Font:** Install [JetBrainsMono Nerd Font](https://www.nerdfonts.com/font-downloads) so Powerlevel10k and Neovim glyphs and icons render properly.
- **Backup:** Replaced configuration files are automatically saved to `~/.dotfiles_backup/<timestamp>/`.
- **Restore:** To restore previous configs if needed:
  ```bash
  cp -r ~/.dotfiles_backup/<timestamp>/* ~/
  ```
