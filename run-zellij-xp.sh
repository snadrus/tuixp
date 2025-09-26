#!/usr/bin/env bash
set -euo pipefail
cd /workspace
export PATH=/workspace/bin:$PATH
export ZELLIJ_CONFIG_DIR=/workspace/zellij-config
exec /workspace/bin/zellij --layout /workspace/zellij-config/layouts/windows_xp.kdl "$@"
