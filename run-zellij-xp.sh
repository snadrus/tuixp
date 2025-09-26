#!/usr/bin/env bash
set -euo pipefail
export PATH=bin:$PATH
export ZELLIJ_CONFIG_DIR=zellij-config
exec zellij/target/release/zellij --layout zellij-config/layouts/windows_xp.kdl "$@"
