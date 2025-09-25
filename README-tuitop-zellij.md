TuiTop on Zellij (prototype)

What this provides
- Taskbar-like plugin at the bottom with clock and pane buttons
- Click a button to focus the associated pane
- Layout loader to run the plugin

Prereqs
- Rust toolchain installed (we auto-installed in CI/dev)
- Zellij v0.41+

Build the plugin
```bash
source /usr/local/cargo/env
cargo build --release --manifest-path /workspace/tuitop-zellij-plugin/Cargo.toml --target wasm32-wasi
```

Run with layout
```bash
zellij --layout /workspace/zellij-layouts/tuitop.kdl
```

Notes
- The plugin uses the Zellij plugin API to list panes and focus by id.
- Next steps: add app button click to spawn a new floating terminal and drag interactions.
