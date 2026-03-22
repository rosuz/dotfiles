#!/bin/bash

ERROR_HANDLING=false

show_cursor() {
  printf "\033[?25h"
}

show_log_tail() {
  if [[ -f "$DOTFILES_INSTALL_LOG_FILE" ]]; then
    tail -n 10 "$DOTFILES_INSTALL_LOG_FILE" 2>/dev/null | while IFS= read -r line; do
      gum style "$line"
    done
    echo
  fi
}

show_failed_script_or_command() {
  if [[ -n "${CURRENT_SCRIPT:-}" ]]; then
    gum style "Failed script: $CURRENT_SCRIPT"
  else
    gum style "Command failed"
  fi
}

catch_errors() {
  if [[ "$ERROR_HANDLING" == "true" ]]; then
    return
  else
    ERROR_HANDLING=true
  fi

  local exit_code=$?

  stop_log_output
  show_cursor

  clear_logo

  gum style --foreground 1 "Installation stopped!"
  show_log_tail

  gum style "This command halted with exit code $exit_code:"
  show_failed_script_or_command
  echo

  options=()
  options+=("Retry installation")
  options+=("View full log")
  options+=("Exit")

  choice=$(gum choose "${options[@]}" --header "What would you like to do?")

  case "$choice" in
    "Retry installation")
      bash "$DOTFILES_INSTALL/install.sh"
      ;;
    "View full log")
      if command -v less &>/dev/null; then
        less "$DOTFILES_INSTALL_LOG_FILE"
      else
        tail "$DOTFILES_INSTALL_LOG_FILE"
      fi
      ;;
    "Exit" | "")
      exit 1
      ;;
  esac
}

exit_handler() {
  local exit_code=$?

  if (( exit_code != 0 )) && [[ "$ERROR_HANDLING" != "true" ]]; then
    catch_errors
  else
    stop_log_output
    show_cursor
  fi
}

trap catch_errors ERR INT TERM
trap exit_handler EXIT
