#!/usr/bin/env fish

# setup config directories if they don't exist
mkdir -p ~/.config/fish/functions
mkdir -p ~/.config/fish/themes

# Create symlinks with stow
stow -R -t ~ fish
stow -R -t ~ tmux
