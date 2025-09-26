#!/usr/bin/env bash
set -euo pipefail
clear
printf "\033[97;44m  Start  \033[0m  Launch Floating Pane  (press Enter)\n"
echo "[q] Quit"
while true; do
  IFS= read -rsn1 key || break
  case "$key" in
    $'\n'|$'\r'|'')
      mkdir -p zellij-config/state
      counter_file=zellij-config/state/float_counter
      : > zellij-config/state/floats.list || true
      if [ ! -f "$counter_file" ]; then echo 0 > "$counter_file"; fi
      id=$(($(cat "$counter_file") + 1))
      echo "$id" > "$counter_file"
      name="float-$id"
      grep -qxF "$name" zellij-config/state/floats.list || echo "$name" >> zellij-config/state/floats.list
      bin/zellij run --floating --pinned --name "$name" -- zellij-config/float_shell.sh || true
      printf "Launched floating pane: %s.\n" "$name"
      ;;
    q|Q) exit 0 ;;
    *) : ;;
  esac
 done
