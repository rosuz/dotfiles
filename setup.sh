#!/bin/bash

set -e

if ! command -v gum &>/dev/null; then
  echo "Installing gum..."
  if command -v yay &>/dev/null; then
    yay -S --noconfirm gum
  elif command -v paru &>/dev/null; then
    paru -S --noconfirm gum
  elif command -v pacman &>/dev/null; then
    sudo pacman -S --noconfirm gum
  else
    echo "Error: gum not found and no package manager available"
    exit 1
  fi
fi

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
