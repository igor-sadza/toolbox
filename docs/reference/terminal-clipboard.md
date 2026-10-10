# Terminal and Clipboard

The bundled [tmux configuration](../../build/rootfs/opt/toolbox/config/tmux/tmux.conf) enables `set-clipboard` and `allow-passthrough`. Passthrough addresses OpenCode's wrapped OSC 52 sequences, as recorded in [October 7, 2026 planning](https://github.com/wsadza/toolbox/blob/8fb3f07e7d639cc613a2bc04b5bef27dc3bade8c/TODO_07_10_2026.md). Effective behavior across terminals, nested tmux, OpenCode, and Neovim has not been verified here.

Application passthrough can allow applications inside tmux to emit terminal control sequences, including clipboard-related sequences. Treat this as a trust boundary: only run applications and projects whose terminal output you trust, especially when passthrough is enabled.

## Copy and Paste Boundaries

With the bundled tmux configuration loaded, the prefix is `Ctrl-a`: prefix `[` enters vi copy mode, `v` selects, and `y` or `Enter` copies and exits. Prefix `]` pastes the tmux buffer, not an independent read of the desktop clipboard. Prefix `Ctrl-a` sends the prefix through to an application or nested session. Prefix `R` reloads the shared configuration only if `TOOLBOX_CONFIG` is available to the server; user settings and already-running servers can differ. This retains the relevant orientation and [historical cheatsheet provenance](https://github.com/wsadza/toolbox/blob/2552cc89154201c5c27a7075112ca9c559afbf0b/build/rootfs/opt/toolbox/doc/cheatsheet.md), not a second full keybinding inventory.

Bundled [Neovim clipboard configuration](../../build/rootfs/opt/toolbox/config/nvim/lua/toolbox/options.lua) copies through OSC 52 and selects `unnamedplus`, but its custom paste handler reads Neovim's own register. It does not request the desktop clipboard through OSC 52. Terminal desktop paste, tmux buffer paste, and Neovim register paste are therefore separate paths; configured copying does not prove clipboard reading or image retrieval.

## Remaining Verification

- Test OpenCode copy, tmux copy-mode yank, and Neovim yank independently.
- Test large selections and nested tmux where applicable.
- Test desktop clipboard paste, tmux buffer paste, and Neovim register paste separately.
- Check terminal-specific mouse-selection behavior and whether it bypasses tmux.
- Verify direct `nvim` and the `vi` wrapper independently; see their [configuration differences and open entrypoint decision](neovim-integration.md#entrypoints-and-persistence).

## Image Bridge Proposal

The developing [image bridge proposal](../notes/clipboard-image-bridge.md) owns proposal status, platform, security, fallback, and acceptance criteria separately from the configured terminal behavior.
