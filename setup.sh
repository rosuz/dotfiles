#!/bin/bash
set -euo pipefail

if ! command -v git &>/dev/null; then
  echo "Installing git..."
  sudo pacman -S --noconfirm git
fi

detect_aur_helper() {
  if command -v yay &>/dev/null; then
    echo "yay"
  elif command -v paru &>/dev/null; then
    echo "paru"
  else
    echo "none"
  fi
}

install_aur_helper() {
  local choice="$1"
  local temp_dir="$(mktemp -d)"
  local start_dir="$(pwd)"
  
  echo "Installing $choice..."
  
  if ! command -v fakeroot &>/dev/null; then
    echo "Installing base-devel (required for building AUR packages)..."
    sudo pacman -S --noconfirm base-devel
  fi
  
  if [[ "$choice" == "yay" ]]; then
    git clone https://aur.archlinux.org/yay.git "$temp_dir/yay" 2>/dev/null || {
      echo "Error: Failed to clone yay repository"
      cd "$start_dir"
      rm -rf "$temp_dir"
      exit 1
    }
    cd "$temp_dir/yay" && makepkg -si --noconfirm
  else
    git clone https://aur.archlinux.org/paru.git "$temp_dir/paru" 2>/dev/null || {
      echo "Error: Failed to clone paru repository"
      cd "$start_dir"
      rm -rf "$temp_dir"
      exit 1
    }
    cd "$temp_dir/paru" && makepkg -si --noconfirm
  fi
  
  cd "$start_dir"
  rm -rf "$temp_dir"
}

aur_helper=$(detect_aur_helper)

if [[ "$aur_helper" == "none" ]]; then
  echo "No AUR helper found."
  echo "Select an option:"
  echo "  1) Install yay"
  echo "  2) Install paru"
  read -p "Choice [1]: " choice
  choice="${choice:-1}"
  
  if [[ "$choice" == "1" ]]; then
    install_aur_helper "yay"
  else
    install_aur_helper "paru"
  fi
  
  aur_helper=$(detect_aur_helper)
fi

export AUR_HELPER="$aur_helper"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$HOME/.local/share/dotfiles"
BACKUP_DIR="$HOME/Backups"

if [[ "$SCRIPT_DIR" == "$TARGET_DIR" ]]; then
  exec bash "$SCRIPT_DIR/install/install.sh"
fi

echo "Installing dotfiles to $TARGET_DIR..."

if [[ -d "$TARGET_DIR" ]] || [[ -d "$HOME/.config/" ]]; then
  echo "Backing up existing configurations..."
  
  mkdir -p "$BACKUP_DIR/config"
  mkdir -p "$BACKUP_DIR/dotfiles"
  
  TIMESTAMP=$(date +%Y%m%d_%H%M%S)
  
  if [[ -d "$HOME/.config" ]]; then
    echo "  Compressing ~/.config/ to ~/Backups/config/config.backup_$TIMESTAMP.tar.gz"
    tar -czf "$BACKUP_DIR/config/config.backup_$TIMESTAMP.tar.gz" -C "$HOME" .config
  fi
  
  if [[ -d "$HOME/.local/share/dotfiles" ]]; then
    echo "  Compressing ~/.local/share/dotfiles/ to ~/Backups/dotfiles/dotfiles.backup_$TIMESTAMP.tar.gz"
    tar -czf "$BACKUP_DIR/dotfiles/dotfiles.backup_$TIMESTAMP.tar.gz" -C "$HOME/.local/share" dotfiles
    rm -rf "$HOME/.config/hypr/"
  fi

  rm -rf "$TARGET_DIR"
fi

mkdir -p "$(dirname "$TARGET_DIR")"
cp -r "$SCRIPT_DIR" "$TARGET_DIR"

export DOTFILES_INSTALL_RUNNING=1
exec bash "$TARGET_DIR/install/install.sh"
