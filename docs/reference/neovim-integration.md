# Neovim Integration

Bundled configuration is image content, not automatically the configuration used by every entrypoint. Source inspection establishes settings and requested tooling, not successful interactive operation.

## Entrypoints and Persistence

The [`vi` wrapper](../../build/rootfs/opt/toolbox/bin/vi) selects shared configuration under `/opt/toolbox`; its state stays under `~/.local/state` and persists with the [mounted home](runtime.md#persistence-boundaries). Direct `nvim` uses XDG configuration/data paths instead. Whether both entrypoints should select the bundled configuration remains an open decision.

Edits to [bundled configuration](../../build/rootfs/opt/toolbox/config/nvim/) become durable through image changes. Shared plugin data is container-local. Do not assume runtime edits survive recreation.

## Integration Caveats

- Normal-mode macro recording with `q` is disabled by [general mappings](../../build/rootfs/opt/toolbox/config/nvim/lua/toolbox/keymaps.lua). Use the configured which-key menu.
- [AI plugins](../../build/rootfs/opt/toolbox/config/nvim/lua/toolbox/plugins/ai.lua) select Copilot integrations. Review provider disclosure before use.
- [Custom prompts](../../build/rootfs/opt/toolbox/config/nvim/prompts/) remain runtime resources. Prompt metadata may differ from action metadata.
- [Filetype detection](../../build/rootfs/opt/toolbox/config/nvim/lua/toolbox/filetypes.lua) distinguishes Compose YAML, Helm templates, and plain YAML. [Formatter configuration](../../build/rootfs/opt/toolbox/config/nvim/lua/toolbox/plugins/format.lua) does not explicitly cover subtypes.
- Pinned gopls defaults include `gotmpl` for go-template support; this is configured, not verified in every project.

## Updates and Verification

Review both [`lazy-lock.json`](../../build/rootfs/opt/toolbox/config/nvim/lazy-lock.json) and the [Mason registry pin](../../build/rootfs/opt/toolbox/config/nvim/lua/toolbox/plugins/lsp.lua). Follow [image maintenance](../playbooks/image-maintenance.md#review-an-update) and inspect checks on the final PR commit.
