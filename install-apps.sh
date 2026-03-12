#!/bin/bash

set -e

detect_aur_helper() {
    if command -v yay &>/dev/null; then
        echo "yay"
    elif command -v paru &>/dev/null; then
        echo "paru"
    else
        echo "none"
    fi
}

install_with_helper() {
    local helper="$1"
    shift
    local packages=("$@")

    if ((${#packages[@]} == 0)); then
        return
    fi

    echo "Installing: ${packages[*]}"
    $helper -S --needed --noconfirm "${packages[@]}"
}

main() {
    local aur_helper
    aur_helper=$(detect_aur_helper)

    if [[ "$aur_helper" == "none" ]]; then
        echo "No AUR helper found. Please choose one to install:"
        echo "1) yay"
        echo "2) paru"
        read -p "Choice [1/2]: " choice

        case "$choice" in
            1)
                echo "Installing yay..."
                git clone https://aur.archlinux.org/yay-bin.git /tmp/yay
                cd /tmp/yay
                makepkg -si --noconfirm
                aur_helper="yay"
                ;;
            2)
                echo "Installing paru..."
                git clone https://aur.archlinux.org/paru.git /tmp/paru
                cd /tmp/paru
                makepkg -si --noconfirm
                aur_helper="paru"
                ;;
            *)
                echo "Invalid choice. Exiting."
                exit 1
                ;;
        esac
    fi

    echo "Using AUR helper: $aur_helper"

    local hyprland_extras=(
        hypridle
        hyprlock
        hyprpaper
        hyprsunset
        hyprpicker
    )

    local screenshot=(
        grim
        wf-recorder
        slurp
        wayfreeze
    )

    local clipboard=(
        wl-clipboard
    )

    local status_notifications=(
        waybar
        mako
    )

    local tui_apps=(
        btop
        lazydocker
        bluetui
        wiremix
        impala
    )

    local tools=(
        cliphist
        rofi
        playerctl
        swayosd-hid
        uwsm
        jq
        libnotify
        fcitx5
        polkit-gnome
        kvantum
    )

    local apps=(
        nautilus
        obsidian
        signal-desktop
    )

    echo ""
    echo "=== Installing Hyprland Extras ==="
    install_with_helper "$aur_helper" "${hyprland_extras[@]}"

    echo ""
    echo "=== Installing Screenshot/Screenrecord ==="
    install_with_helper "$aur_helper" "${screenshot[@]}"

    echo ""
    echo "=== Installing Clipboard ==="
    install_with_helper "$aur_helper" "${clipboard[@]}"

    echo ""
    echo "=== Installing Status/Notifications ==="
    install_with_helper "$aur_helper" "${status_notifications[@]}"

    echo ""
    echo "=== Installing TUI Apps ==="
    install_with_helper "$aur_helper" "${tui_apps[@]}"

    echo ""
    echo "=== Installing Tools ==="
    install_with_helper "$aur_helper" "${tools[@]}"

    echo ""
    echo "=== Installing Apps ==="
    install_with_helper "$aur_helper" "${apps[@]}"

    echo ""
    echo "Done!"
}

main "$@"
