#!/usr/bin/env bash
set -euo pipefail
clear
printf "\033[97;44m  Start  \033[0m  Launch Floating Pane  (press Enter)\n"
echo "[q] Quit"
while true; do
  IFS= read -rsn1 key || break
  case "$key" in
    $'\n'|$'\r'|'') /workspace/bin/zellij action new-floating-pane || /workspace/bin/zellij action new-pane --floating true || /workspace/bin/zellij action new-pane -f; printf "Launched floating pane.\n" ;;
    q|Q) exit 0 ;;
    *) : ;;
  esac
 done
