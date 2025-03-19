#!/bin/bash

# Dotfile bootstrapper for Linux systems because I'm lazy

# Update
sudo apt update && sudo apt upgrade -y

# install zsh and switch shells
sudo apt install zsh

# configure .zshrc
cp ~/.zshrc ~/.zshrc.bak
wget https://raw.githubusercontent.com/jshuntley/dotfiles/refs/heads/main/.zshrc -O ~/.zshrc

sudo chsh -s $(which zsh) $(whoami)

# install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# install zoxide
cargo install zoxide

# install Starship
curl -sS https://starship.rs/install.sh | sh
wget https://raw.githubusercontent.com/jshuntley/dotfiles/refs/heads/main/.config/starship.toml -O ~/.config/starship.toml

source ~/.zshrc

# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# install packages
brew install helix eza lazygit

# configure helix
wget https://raw.githubusercontent.com/jshuntley/dotfiles/refs/heads/main/.config/helix/config.toml -O ~/.config/helix/config.toml

# install and configure Kitty
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

# echo "" > ~/.config/kitty/
