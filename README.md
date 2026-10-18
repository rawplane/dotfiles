# dotfiles

Personal dotfiles untuk Linux Mint / Debian-based — dikelola via `install.sh` dengan backup otomatis.

## Struktur

| Direktori | Konfigurasi |
|-----------|-------------|
| `nvim/` | Neovim (LazyVim, Neovim >= 0.10) |
| `ghostty/` | Ghostty terminal |
| `zshrc/` | Zsh + Oh My Zsh + Powerlevel10k + plugins |
| `archive/` | Arsip konfigurasi (i3, picom, doom emacs) |

## Cara Pasang (Linux Mint)

### 1. Mesin Baru (Pasang dependensi + tautkan konfigurasi)
```bash
git clone <repo-url> ~/dotfiles
cd ~/dotfiles
./install.sh -a
```
Flag `-a` / `--all` otomatis:
- Pasang paket sistem: `git`, `curl`, `zsh`, `ripgrep`, `fd-find`, `build-essential`.
- Pasang/update Neovim stable (>= 0.10) jika versi APT lawas.
- Pasang Oh My Zsh + tema Powerlevel10k + plugin autosuggestions & syntax-highlighting.
- Buat backup config lama dan buat symlink.

### 2. Hanya Tautkan Konfigurasi (Tanpa sentuh paket sistem)
```bash
./install.sh -l
```

### Opsi CLI `install.sh`
- `-a, --all`: Pasang dependensi dan tautkan config.
- `-d, --deps`: Hanya pasang dependensi sistem & plugin zsh.
- `-l, --link`: Hanya tautkan config dengan backup otomatis.
- `-h, --help`: Tampilkan bantuan.

## Catatan Penting

- **Font:** Pasang [JetBrainsMono Nerd Font](https://www.nerdfonts.com/font-downloads) agar glyph dan icon Powerlevel10k / Neovim tampil sempurna.
- **Backup:** File konfigurasi lama yang tertimpa otomatis disimpan di `~/.dotfiles_backup/<timestamp>/`.
- **Restore:** Untuk memulihkan config lama jika diperlukan:
  ```bash
  cp -r ~/.dotfiles_backup/<timestamp>/* ~/
  ```
