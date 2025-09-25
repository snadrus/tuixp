#!/usr/bin/env bash
set -euo pipefail
# Render green-on-black ">_" and launch a new normal terminal on Enter
clear
printf "\033[42;30m >_ \033[0m  New Terminal (press Enter)\n"
echo "[q] Quit"
while true; do
  IFS= read -rsn1 k || break
  case "$k" in
    $'\n'|$'\r'|'')
      mkdir -p /workspace/zellij-config/state
      counter_file=/workspace/zellij-config/state/float_counter
      : > /workspace/zellij-config/state/floats.list || true
      if [ ! -f "$counter_file" ]; then echo 0 > "$counter_file"; fi
      id=$(($(cat "$counter_file") + 1))
      echo "$id" > "$counter_file"
      name="term-$id"
      grep -qxF "$name" /workspace/zellij-config/state/floats.list || echo "$name" >> /workspace/zellij-config/state/floats.list
      /workspace/bin/zellij run --floating --pinned --name "$name" -- ${SHELL:-bash} || true
      printf "Launched terminal: %s.\n" "$name"
      ;;
    q|Q) exit 0 ;;
  esac
done
