# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# zsh-syntax-highlighting must stay last in this list
plugins=(git docker npm golang zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

export EDITOR=nvim

# Go
export PATH=$PATH:/usr/local/go/bin

# Homebrew (must come before fzf/zoxide so brew-installed tools are on PATH)
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Zoxide
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"

# fzf: use the built-in `--zsh` only when this fzf version supports it (0.48+),
# otherwise fall back to the older ~/.fzf.zsh. This removes "unknown option: --zsh".
if command -v fzf >/dev/null 2>&1; then
  if fzf --zsh >/dev/null 2>&1; then
    source <(fzf --zsh)
  elif [[ -f ~/.fzf.zsh ]]; then
    source ~/.fzf.zsh
  fi
fi

# p10k config (run `p10k configure` to regenerate)
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# ---------------------------------------------------------------
# Aliases & helpers
# ---------------------------------------------------------------

alias reload='exec zsh'          # reload shell after editing this file
alias zshconfig='$EDITOR ~/.zshrc'

# update: system packages, Homebrew, Oh My Zsh, and custom themes/plugins
update() {
  if command -v apt >/dev/null 2>&1; then
    echo "==> apt"
    sudo apt update && sudo apt upgrade -y
  fi

  if command -v brew >/dev/null 2>&1; then
    echo "==> brew"
    brew update && brew upgrade
  fi

  echo "==> oh-my-zsh"
  omz update --unattended

  echo "==> custom theme & plugins"
  local d
  for d in "${ZSH_CUSTOM:-$ZSH/custom}"/themes/powerlevel10k "${ZSH_CUSTOM:-$ZSH/custom}"/plugins/*(N/); do
    if [[ -d "$d/.git" ]]; then
      echo "  - ${d:t}"
      git -C "$d" pull --quiet
    fi
  done

  echo "==> done. Run 'reload' to apply."
}

# clearcache: safe cleanup of package, tool, and shell caches
clearcache() {
  if command -v apt >/dev/null 2>&1; then
    echo "==> apt"
    sudo apt autoremove -y && sudo apt clean
  fi

  if command -v brew >/dev/null 2>&1; then
    echo "==> brew"
    brew cleanup --prune=all
  fi

  command -v npm >/dev/null 2>&1 && { echo "==> npm"; npm cache clean --force; }
  command -v go  >/dev/null 2>&1 && { echo "==> go";  go clean -cache; }

  echo "==> zsh / p10k caches (regenerated automatically)"
  rm -f ~/.zcompdump*
  rm -f "${XDG_CACHE_HOME:-$HOME/.cache}"/p10k-*

  echo "==> done. Run 'reload' to rebuild the completion cache."
}

# Docker cleanup is separate because it removes unused images and containers
alias dprune='docker system prune -af --volumes'

#9router
export PATH="$PATH:$HOME/.9router/bin"

#opencode
export PATH="$HOME/.opencode/bin:$PATH"

#herdr
export PATH="$HOME/.local/bin:$PATH"

#bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
