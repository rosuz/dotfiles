#!/bin/bash

mkdir -p ~/.local/share/applications

if [ -d "$DOTFILES_PATH/applications" ]; then
    for desktop_file in "$DOTFILES_PATH/applications"/*.desktop; do
        if [ -f "$desktop_file" ]; then
            cp "$desktop_file" ~/.local/share/applications/
            gum style --foreground 3 "  Installed: $(basename "$desktop_file")"
        fi
    done
fi

mkdir -p ~/.config
if [ -f "$DOTFILES_PATH/config/xdg-terminals.list" ]; then
    cp "$DOTFILES_PATH/config/xdg-terminals.list" ~/.config/
    gum style --foreground 3 "  Installed: xdg-terminals.list"
fi
