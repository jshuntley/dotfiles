#!/usr/bin/env bash
set -euo pipefail

# ------- Helpers -------
log() { printf "\n\033[1;36m==> %s\033[0m\n" "$*"; }
backup() {
  local p="$1"
  if [[ -e "$p" && ! -L "$p" ]]; then
    mv -f "$p" "$p.bak.$(date +%s)"
  fi
}

# ------- Sanity / dirs -------
log "Preparing directories"
mkdir -p "$HOME/.local/bin" "$HOME/.config/helix"

# Ensure ~/.local/bin is on PATH for current and future shells
if ! grep -q 'PATH=.*\.local/bin' "$HOME/.zshrc" 2>/dev/null; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
fi

# ------- APT base -------
log "Updating apt and installing base packages"
sudo apt update -y
sudo apt install -y zsh tmux curl wget git build-essential pkg-config ca-certificates fontconfig unzip tree

# ------- Zsh config -------
log "Installing .zshrc"
backup "$HOME/.zshrc"
wget -q https://raw.githubusercontent.com/jshuntley/dotfiles/refs/heads/main/.zshrc -O "$HOME/.zshrc" || true

# Set default shell to zsh (non-interactive)
if [[ "$(echo $SHELL)" != "$(command -v zsh)" ]]; then
  log "Setting default shell to zsh"
  chsh -s "$(command -v zsh)" "$USER" || sudo chsh -s "$(command -v zsh)" "$USER" || true
fi

# ------- Rust (non-interactive) -------
if ! command -v rustup >/dev/null 2>&1; then
  log "Installing Rust (rustup) non-interactively"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  # shellcheck source=/dev/null
  source "$HOME/.cargo/env"
fi

# ------- Starship (non-interactive) -------
if ! command -v starship >/dev/null 2>&1; then
  log "Installing Starship"
  curl -fsSL https://starship.rs/install.sh | sh -s -- -y
fi

log "Configuring Starship"
mkdir -p "$HOME/.config"
wget -q https://raw.githubusercontent.com/jshuntley/dotfiles/refs/heads/main/.config/starship.toml -O "$HOME/.config/starship.toml" || true

# ------- Homebrew (Linuxbrew) -------
if ! command -v brew >/dev/null 2>&1; then
  log "Installing Homebrew (Linuxbrew)"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# shellcheck source=/dev/null
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# ------- Brew CLI packages -------
log "Installing brew packages"
brew update
brew install helix eza lazygit bat || true

# Nerd Fonts via cask are not supported on Linuxbrew; install manually instead
log "Installing Nerd Fonts manually (Hack + Meslo)"
NF_DIR="$HOME/.local/share/fonts"
mkdir -p "$NF_DIR"

# Hack Nerd Font
if [[ ! -f "$NF_DIR/Hack Regular Nerd Font Complete.ttf" ]]; then
  curl -fsSL -o /tmp/Hack.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip
  unzip -o /tmp/Hack.zip -d "$NF_DIR"
fi

# Meslo Nerd Font
if [[ ! -f "$NF_DIR/MesloLGS NF Regular.ttf" ]]; then
  curl -fsSL -o /tmp/Meslo.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip
  unzip -o /tmp/Meslo.zip -d "$NF_DIR"
fi

fc-cache -f "$NF_DIR" || true

# ------- Helix config -------
log "Configuring Helix"
wget -q https://raw.githubusercontent.com/jshuntley/dotfiles/refs/heads/main/.config/helix/config.toml -O "$HOME/.config/helix/config.toml" || true

# ------- zoxide via cargo (fast) -------
if ! command -v zoxide >/dev/null 2>&1; then
  log "Installing zoxide via cargo"
  cargo install zoxide || true
  if ! grep -q 'zoxide init' "$HOME/.zshrc" 2>/dev/null; then
    echo 'eval "$(zoxide init zsh)"' >> "$HOME/.zshrc"
  fi
fi

# ------- Kitty terminal -------
# if [[ ! -d "$HOME/.local/kitty.app" ]]; then
#   log "Installing Kitty"
#   curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
# fi

# ln -sf "$HOME/.local/kitty.app/bin/kitty"  "$HOME/.local/bin/kitty"
# ln -sf "$HOME/.local/kitty.app/bin/kitten" "$HOME/.local/bin/kitten"

# log "Configuring Kitty"
# wget -q https://raw.githubusercontent.com/jshuntley/dotfiles/refs/heads/main/.config/kitty/kitty.conf -O "$HOME/.config/kitty/kitty.conf" || true
# wget -q https://raw.githubusercontent.com/jshuntley/dotfiles/refs/heads/main/.config/kitty/current-theme.conf -O "$HOME/.config/kitty/current-theme.conf" || true

# ------- tmux config -------
log "Configuring tmux"
backup "$HOME/.tmux.conf"
wget -q https://raw.githubusercontent.com/jshuntley/dotfiles/refs/heads/main/.tmux.conf -O "$HOME/.tmux.conf" || true

# If you actually keep a .tmux directory in your repo, fetch it via git (wget can’t fetch directories)
# Example:
# git clone --depth=1 https://github.com/jshuntley/dotfiles /tmp/dotfiles
# rsync -a /tmp/dotfiles/.tmux/ "$HOME/.tmux/"

# ------- Final touch -------
log "Done. Loading zsh environment"
# shellcheck source=/dev/null
source "$HOME/.zshrc" || true
