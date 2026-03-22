#!/bin/bash

monitor_pid=""

start_log_output() {
  # Don't start if already running
  [[ -n "$monitor_pid" ]] && return

  local ANSI_SAVE_CURSOR="\033[s"
  local ANSI_RESTORE_CURSOR="\033[u"
  local ANSI_CLEAR_LINE="\033[2K"
  local ANSI_HIDE_CURSOR="\033[?25l"
  local ANSI_RESET="\033[0m"
  local ANSI_GRAY="\033[90m"

  printf $ANSI_SAVE_CURSOR 2>/dev/null
  printf $ANSI_HIDE_CURSOR 2>/dev/null

  (
    local log_lines=8
    local max_line_width=$((LOGO_WIDTH - 4))

    while true; do
      if [[ ! -f "$DOTFILES_INSTALL_LOG_FILE" ]]; then
        sleep 0.5
        continue
      fi

      mapfile -t current_lines < <(tail -n $log_lines "$DOTFILES_INSTALL_LOG_FILE" 2>/dev/null)

      output=""
      for ((i = 0; i < log_lines; i++)); do
        line="${current_lines[i]:-}"
        if (( ${#line} > max_line_width )) && [[ max_line_width -gt 0 ]]; then
          line="${line:0:$max_line_width}..."
        fi
        if [[ -n $line ]]; then
          output+="${ANSI_CLEAR_LINE}${ANSI_GRAY}  → ${line}${ANSI_RESET}\n"
        else
          output+="${ANSI_CLEAR_LINE}\n"
        fi
      done

      printf "${ANSI_RESTORE_CURSOR}%b" "$output" 2>/dev/null
      sleep 0.5
    done
  ) &
  monitor_pid=$!
}

stop_log_output() {
  if [[ -n "$monitor_pid" ]]; then
    kill "$monitor_pid" 2>/dev/null || true
    wait "$monitor_pid" 2>/dev/null || true
    monitor_pid=""
  fi
}

pause_log_output() {
  stop_log_output
  show_cursor
}

resume_log_output() {
  start_log_output
}

start_install_log() {
  mkdir -p "$(dirname "$DOTFILES_INSTALL_LOG_FILE")" 2>/dev/null || true
  touch "$DOTFILES_INSTALL_LOG_FILE"
  chmod 666 "$DOTFILES_INSTALL_LOG_FILE" 2>/dev/null || true

  export DOTFILES_START_TIME=$(date '+%Y-%m-%d %H:%M:%S')
  echo "=== Dotfiles Installation Started: $DOTFILES_START_TIME ===" >>"$DOTFILES_INSTALL_LOG_FILE"
}

stop_install_log() {
  stop_log_output
  show_cursor

  if [[ -n ${DOTFILES_INSTALL_LOG_FILE:-} ]]; then
    DOTFILES_END_TIME=$(date '+%Y-%m-%d %H:%M:%S')
    echo "=== Dotfiles Installation Completed: $DOTFILES_END_TIME ===" >>"$DOTFILES_INSTALL_LOG_FILE"
    echo "" >>"$DOTFILES_INSTALL_LOG_FILE"

    if [[ -n $DOTFILES_START_TIME ]]; then
      START_EPOCH=$(date -d "$DOTFILES_START_TIME" +%s)
      END_EPOCH=$(date -d "$DOTFILES_END_TIME" +%s)
      DURATION=$((END_EPOCH - START_EPOCH))

      MINS=$((DURATION / 60))
      SECS=$((DURATION % 60))

      echo "Installation completed in ${MINS}m ${SECS}s" >>"$DOTFILES_INSTALL_LOG_FILE"
    fi
  fi
}

run_logged() {
  local script="$1"
  export CURRENT_SCRIPT="$script"

  echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting: $script" >>"$DOTFILES_INSTALL_LOG_FILE"

  bash -c "source '$script'" </dev/null >>"$DOTFILES_INSTALL_LOG_FILE" 2>&1

  local exit_code=$?

  if (( exit_code == 0 )); then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Completed: $script" >>"$DOTFILES_INSTALL_LOG_FILE"
  else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Failed: $script (exit code: $exit_code)" >>"$DOTFILES_INSTALL_LOG_FILE"
  fi

  unset CURRENT_SCRIPT
  return $exit_code
}
