#!/usr/bin/env bash
set -euo pipefail
# Render green-on-black ">_" and launch a new normal terminal on Enter
clear
printf "\033[42;30m >_ \033[0m  New Terminal (press Enter)\n"
echo "[q] Quit"
while true; do
  IFS= read -rsn1 k || break
  case "$k" in
    $'\n'|$'\r'|'') /workspace/bin/zellij action new-pane || true ;;
    q|Q) exit 0 ;;
  esac
done
