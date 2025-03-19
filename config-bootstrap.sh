#!/bin/bash

# Dotfile bootstrapper for Linux systems because I'm lazy

# Update
sudo apt update && sudo apt upgrade -y

# install zsh and switch shells
sudo apt install zsh

cp ~/.zshrc ~/.zshrc.bak

# TODO clone from git repo instead of hardcoding
#.zshrc clone

sudo chsh -s $(which zsh) $(whoami)

# install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# install zoxide
cargo install zoxide

# install Starship
curl -sS https://starship.rs/install.sh | sh

# starship.toml clone

source ~/.zshrc

# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# install packages
brew install helix eza lazygit

# configure helix
# git clone

# install and configure Kitty
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

# echo "" > ~/.config/kitty/
