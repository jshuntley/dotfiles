#!/bin/bash

# Personalized app and dotfile bootstrapper for Linux systems

# Update
sudo apt update && sudo apt upgrade -y

# install zsh and switch shells
sudo apt install zsh

# configure .zshrc
mv $HOME/.zshrc $HOME/.zshrc.bak
wget https://raw.githubusercontent.com/jshuntley/dotfiles/refs/heads/main/.zshrc -O $HOME/.zshrc

# set shell to zsh
sudo chsh -s $(which zsh) $(whoami)

# install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# install starship
curl -sS https://starship.rs/install.sh | sh
wget https://raw.githubusercontent.com/jshuntley/dotfiles/refs/heads/main/.config/starship.toml -O $HOME/.config/starship.toml

# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo >> $HOME/.zshrc
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

source $HOME/.zshrc

# install brew packages & fonts
brew install helix eza lazygit
brew install --cask font-hack-nerd-font font-meslo-lg-nerd-font

# configure helix
wget https://raw.githubusercontent.com/jshuntley/dotfiles/refs/heads/main/.config/helix/config.toml -O $HOME/.config/helix/config.toml

# install zoxide
cargo install zoxide

# install and configure Kitty
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
ln -s $HOME/.local/kitty.app/bin/kitty $HOME/.local/bin/.
ln -s $HOME/.local/kitty.app/bin/kitten $HOME/.local/bin/.
wget https://raw.githubusercontent.com/jshuntley/dotfiles/refs/heads/main/.config/kitty/kitty.conf -O $HOME/.config/kitty/kitty.conf
wget https://raw.githubusercontent.com/jshuntley/dotfiles/refs/heads/main/.config/kitty/current-theme.conf -O $HOME/.config/kitty/current-theme.conf
