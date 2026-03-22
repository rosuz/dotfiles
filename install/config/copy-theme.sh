#!/bin/bash

clear_logo

gum style --foreground 3 "Setting Up Default Files"

gum style "Creating directory structure in ~/.config/dotfiles/..."

mkdir -p "$HOME/.config/dotfiles"
rm -rf "$HOME/.config/dotfiles/themes"
mkdir -p "$HOME/.config/dotfiles/themes"
rm -rf "$HOME/.config/dotfiles/hypr"
mkdir -p "$HOME/.config/dotfiles/hypr"

cp -r "$DOTFILES_PATH/default/hypr"/* "$HOME/.config/dotfiles/hypr/"

gum style --foreground 2 "Default directories created at ~/.config/dotfiles/"
