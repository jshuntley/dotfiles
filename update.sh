#!/bin/bash
#
# Update the dotfiles

#.zshrc
wget https://raw.githubusercontent.com/jshuntley/dotfiles/refs/heads/main/.zshrc -O $HOME/.zshrc

# starship
wget https://raw.githubusercontent.com/jshuntley/dotfiles/refs/heads/main/.config/starship.toml -O $HOME/.config/starship.toml

# helix
wget https://raw.githubusercontent.com/jshuntley/dotfiles/refs/heads/main/.config/helix/config.toml -O $HOME/.config/helix/config.toml

# kitty
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
wget https://raw.githubusercontent.com/jshuntley/dotfiles/refs/heads/main/.config/kitty/kitty.conf -O $HOME/.config/kitty/kitty.conf
wget https://raw.githubusercontent.com/jshuntley/dotfiles/refs/heads/main/.config/kitty/current-theme.conf -O $HOME/.config/kitty/current-theme.conf
