# Terminal and Clipboard

The bundled [tmux configuration](../../build/rootfs/opt/toolbox/config/tmux/tmux.conf) enables `set-clipboard` and `allow-passthrough`. Passthrough addresses OSC 52 sequences from wrapped tools. Effective behavior across terminals and nested tmux has not been verified here.

## Copy and Paste

With tmux loaded: `Ctrl-a [` enters vi copy mode, `v` selects, `y` copies and exits. `Ctrl-a ]` pastes the tmux buffer. `Ctrl-a R` reloads shared configuration if `TOOLBOX_CONFIG` is available.

Bundled [Neovim clipboard configuration](../../build/rootfs/opt/toolbox/config/nvim/lua/toolbox/options.lua) copies through OSC 52 and selects `unnamedplus`, but its custom paste handler reads Neovim's own register. Desktop paste, tmux buffer paste, and Neovim register paste are separate paths.

## Remaining Verification

- Test OpenCode copy, tmux copy-mode yank, and Neovim yank independently.
- Test large selections and nested tmux where applicable.
- Test desktop clipboard paste, tmux buffer paste, and Neovim register paste separately.
- Verify direct `nvim` and the `vi` wrapper independently.

## Image Bridge Proposal

An opt-in PNG clipboard bridge is tracked in the [roadmap](../roadmap.md#configuration-and-clipboard). The [image bridge proposal](../notes/clipboard-image-bridge.md) owns platform, security, fallback, and acceptance criteria.
