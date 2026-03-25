#!/bin/bash

clear_logo

gum style --foreground 3 "Theme Selection"

AVAILABLE_THEMES=()
while IFS= read -r theme; do
  theme_name=$(basename "$theme")
  [[ "$theme_name" == "current" || "$theme_name" == "templates" || "$theme_name" == "templates-user" ]] && continue
  AVAILABLE_THEMES+=("$theme_name")
done < <(find "$DOTFILES_PATH/themes" -mindepth 1 -maxdepth 1 -type d | sort)

if [[ ${#AVAILABLE_THEMES[@]} -eq 0 ]]; then
  gum style --foreground 1 "No themes found!"
  exit 1
fi

gum style "Available themes:"

SELECTED_THEME=$(gum choose "${AVAILABLE_THEMES[@]}" --header "Which theme would you like to install?")

if [[ -z "$SELECTED_THEME" ]]; then
  gum style "No theme selected, using default (nord)"
  SELECTED_THEME="nord"
fi

gum style "Setting up theme: $SELECTED_THEME"

rm -rf "$DOTFILES_PATH/themes/current"
mkdir -p "$DOTFILES_PATH/themes/current"
cp -r "$DOTFILES_PATH/themes/$SELECTED_THEME/"* "$DOTFILES_PATH/themes/current/"

"$DOTFILES_PATH/bin/generate-theme"

mkdir -p ~/.config/btop/themes
rm -f ~/.config/btop/themes/current.theme
cp "$DOTFILES_PATH/themes/current/btop.theme" ~/.config/btop/themes/current.theme

gum style --foreground 2 "Theme '$SELECTED_THEME' installed!"
