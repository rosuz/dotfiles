#!/bin/bash
set -euo pipefail

mkdir -p ~/.local/share/applications

if [ -d "$DOTFILES_PATH/applications" ]; then
    for desktop_file in "$DOTFILES_PATH/applications"/*.desktop; do
        if [ -f "$desktop_file" ]; then
            cp "$desktop_file" ~/.local/share/applications/
            info "  Installed: $(basename "$desktop_file")"
        fi
    done
fi

mkdir -p ~/.config
if [ -f "$DOTFILES_PATH/config/xdg-terminals.list" ]; then
    cp "$DOTFILES_PATH/config/xdg-terminals.list" ~/.config/
    info "  Installed: xdg-terminals.list"
fi
