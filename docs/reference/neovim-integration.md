# Neovim Integration

Bundled configuration is image content, not automatically the configuration used by every Neovim entrypoint. Source inspection establishes settings and requested tooling, not successful interactive operation. This reference preserves non-obvious integration guidance from the [historical cheatsheet](https://github.com/wsadza/toolbox/blob/2552cc89154201c5c27a7075112ca9c559afbf0b/build/rootfs/opt/toolbox/doc/cheatsheet.md); ordinary shortcuts and plugin defaults belong in source/help rather than a duplicate inventory.

## Entrypoints and Persistence

The [`vi` wrapper](../../build/rootfs/opt/toolbox/bin/vi) selects shared configuration and data under `/opt/toolbox`; its state stays under `~/.local/state` and persists with the [mounted home](runtime.md#persistence-boundaries). Direct `nvim` uses the user's XDG configuration/data paths instead. Whether both entrypoints should select the bundled configuration remains an open decision; test them independently using the [clipboard checklist](terminal-clipboard.md#remaining-verification).

Edits to [bundled configuration](../../build/rootfs/opt/toolbox/config/nvim/) become durable through image changes, not edits to shared files in a running container. Shared plugin data is container-local. Do not assume direct `nvim` loads these settings or that runtime edits survive recreation.

## Integration Caveats

- Normal-mode macro recording with `q` is disabled by [general mappings](../../build/rootfs/opt/toolbox/config/nvim/lua/toolbox/keymaps.lua). Use the configured which-key menu or mapping help to discover bundled shortcuts.
- [AI plugins](../../build/rootfs/opt/toolbox/config/nvim/lua/toolbox/plugins/ai.lua) select Copilot integrations. Review provider disclosure of code/context before use; authentication and credential storage are unverified.
- [Custom prompts](../../build/rootfs/opt/toolbox/config/nvim/prompts/) remain runtime resources at their source location. Review requests staged and unstaged changes against `HEAD`. The refactor mapping invokes `/refactor`, but prompt metadata declares `is_slash_cmd: false`; action resolution remains unverified.
- [Filetype detection](../../build/rootfs/opt/toolbox/config/nvim/lua/toolbox/filetypes.lua) distinguishes Compose YAML, Helm templates beneath `Chart.yaml`, and Helm values from plain YAML. [Formatter configuration](../../build/rootfs/opt/toolbox/config/nvim/lua/toolbox/plugins/format.lua) does not explicitly configure those subtypes; plain-YAML formatting choices do not prove subtype formatting or LSP fallback works.
- The [pinned gopls defaults](https://github.com/neovim/nvim-lspconfig/blob/3e8d598d3b5f8338a41699c436e5fa11d2666cf0/lsp/gopls.lua) include `gotmpl`. This supports the intended gomplate/Go-template relationship without proving attachment in every project.

## Updates and Verification

Review both [`lazy-lock.json`](../../build/rootfs/opt/toolbox/config/nvim/lazy-lock.json) and the [Mason registry pin](../../build/rootfs/opt/toolbox/config/nvim/lua/toolbox/plugins/lsp.lua) for updates. The current plugin specs include `persistence.nvim` without a matching lock entry; do not assume every plugin is already pinned. The [update workflow](../../.github/workflows/nvim-lock.yml) proposes plugin/registry changes independently of weekly image rebuilds. Follow [image maintenance](../playbooks/image-maintenance.md#review-an-update) and inspect checks on the final PR commit.

The [smoke checks](../../.cicd/tests/smoke.sh) test selected components and synthetic language probes; their [scope](../playbooks/image-maintenance.md#build-and-test) does not establish interactive mappings, formatting correctness, provider access, or equivalent `vi`/`nvim` configuration. Historical cheatsheet checks only configured mapping presence, not action correctness; the current smoke script no longer checks that inventory.

For plugin/Mason failures, inspect failing output and changed inputs, including installation/network access, permissions, and plugin APIs. Validate a targeted correction or reviewed rollback rather than presuming one cause. No such failure was reproduced during documentation review.
