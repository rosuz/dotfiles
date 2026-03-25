#!/bin/bash

clear_logo
gum style --foreground 3 "Network Configuration"

if ! command -v iwctl &>/dev/null; then
    gum style "Installing iwd..."
    sudo pacman -S --noconfirm iwd
fi

if command -v NetworkManager &>/dev/null; then
    sudo mkdir -p /etc/NetworkManager/conf.d
    if [[ ! -f /etc/NetworkManager/conf.d/10-iwd.conf ]]; then
        echo -e "[device]\nwifi.backend=iwd" | sudo tee /etc/NetworkManager/conf.d/10-iwd.conf > /dev/null
        gum style "Configured NetworkManager to use iwd"
    fi
fi

if ! systemctl is-enabled --quiet iwd 2>/dev/null; then
    sudo systemctl enable iwd
fi

if ! systemctl is-active --quiet iwd; then
    sudo systemctl start iwd
fi

gum style --foreground 2 "Network configured!"
gum style "Use 'launch-wifi' or Super+Shift+W to connect to WiFi"
