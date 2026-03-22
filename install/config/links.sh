#!/bin/bash

clear_logo

gum style --foreground 3 "Copying Config Files"

gum style "Copying configuration files to ~/.config/..."

mkdir -p "$HOME/.config"

for item in "$DOTFILES_PATH/config"/*; do
  if [ -e "$item" ]; then
    item_name=$(basename "$item")
    rm -rf "$HOME/.config/$item_name"
    cp -r "$DOTFILES_PATH/config/$item_name" "$HOME/.config/$item_name"
    gum style "  ~/.config/$item_name"
  fi
done

gum style --foreground 2 "Config files copied!"
