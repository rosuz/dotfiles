#!/bin/bash

ERROR_HANDLING=false

show_cursor() {
  printf "\033[?25h"
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

  show_cursor

  clear_logo

  gum style --foreground 1 "Installation stopped!"
  gum style "This command halted with exit code $exit_code:"
  show_failed_script_or_command
  echo ""

  gum style --foreground 6 "Press Enter to exit..."
  read

  exit 1
}

exit_handler() {
  local exit_code=$?

  if (( exit_code != 0 )) && [[ "$ERROR_HANDLING" != "true" ]]; then
    catch_errors
  else
    show_cursor
  fi
}

trap catch_errors ERR INT TERM
trap exit_handler EXIT
