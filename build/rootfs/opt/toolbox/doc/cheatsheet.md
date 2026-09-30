<!---
############################################################
# Copyright (c) 2026 Igor Sadza
# Released under the GPLv3 license
# ----------------------------------------------------------
#
# FILE: ./build/rootfs/opt/toolbox/doc/cheatsheet.md
# DESC: Toolbox cheatsheet (shell: `cheat [topic]`, nvim: <leader>?)
#
# Rows between keymaps:check markers are verified against the
# Neovim config by .cicd/tests/smoke.sh - keep them in sync.
#
############################################################
--->
# Toolbox cheatsheet

`<leader>` = `Space` · tmux prefix = `C-a` · shell: `cheat [topic]` · Neovim: `<leader>?`

## Toolbox

| Command | What it does |
|:--------|:-------------|
| `toolbox` | Shell in the toolbox - as you, in `$PWD` |
| `toolbox <cmd>` | Run one command, e.g. `toolbox k9s` |
| `toolbox --host` | Root shell on the **host** (`chroot /`) |
| `make start` | Pull the image and (re)create the container |
| `make start TOOLBOX_VERSION=<tag>` | Run / roll back to a tag (`latest`, `X.Y.Z`, `weekly`, `edge`) |
| `make stop` / `make test` / `make help` | Stop / smoke test / list targets |
| `cheat [topic]` | This file (`cheat git`, `cheat tmux`, ...) |

Persists: `$HOME`, NFS volumes, `/host`. Lost on update: `sudo apt install`, `/etc`, `/opt/toolbox/*`.

## tmux (prefix `C-a`)

| Keys | Action |
|:-----|:-------|
| `prefix c` / `prefix t` / `prefix T` | New / next / previous window |
| `prefix Space` / `prefix BSpace` | Next / previous window |
| `prefix v` / `prefix s` | Split vertical / horizontal |
| `prefix h j k l` | Move between panes |
| `prefix a` / `prefix q` | Last pane / show pane numbers |
| `prefix Enter` / `prefix +` / `prefix =` | Next layout / main-horizontal / main-vertical |
| `prefix C-o` | Rotate panes |
| `prefix [` → `v` … `y` / `prefix ]` | Copy mode, select, copy (OSC 52) / paste |
| `prefix R` / `prefix r` / `prefix L` | Reload config / refresh / clear history |

## Neovim - general

<!-- keymaps:check -->
| Keys | Mode | Action |
|:-----|:----:|:-------|
| `<leader>?` | n | This cheatsheet |
| `<leader>w` | n | Save file |
| `<leader>q` | n | Quit |
| `<leader>Q` | n | Quit all without saving |
| `<S-h>` | n | Previous buffer |
| `<S-l>` | n | Next buffer |
| `<leader>bd` | n | Delete buffer |
| `<C-h>` | n | Window left |
| `<C-j>` | n | Window down |
| `<C-k>` | n | Window up |
| `<C-l>` | n | Window right |
| `<Esc>` | n | Clear search highlight |
| `J` | v | Move selection down |
| `K` | v | Move selection up |
| `<` | v | Indent left (keep selection) |
| `>` | v | Indent right (keep selection) |
<!-- /keymaps:check -->

Macro recording (`q`) is disabled. Press `<leader>` and wait: which-key shows every mapping.

## Neovim - files & search

<!-- keymaps:check -->
| Keys | Mode | Action |
|:-----|:----:|:-------|
| `<leader>e` | n | Toggle file tree |
| `<leader>ff` | n | Find files |
| `<leader>fg` | n | Search project (ripgrep) |
| `<leader>fb` | n | Find buffers |
| `<leader>fr` | n | Recent files |
| `<leader>fh` | n | Search help |
| `<leader>fd` | n | Search diagnostics |
| `<leader>fk` | n | Search keymaps |
<!-- /keymaps:check -->

In Telescope: `<C-j>` / `<C-k>` move, `<CR>` open, `<C-v>` / `<C-x>` open in split, `<Esc>` close.
File tree opens automatically for `nvim` / `nvim <dir>`; `g?` inside it shows its keys.

## Neovim - code

<!-- keymaps:check -->
| Keys | Mode | Action |
|:-----|:----:|:-------|
| `<leader>cf` | n | Format buffer (conform, falls back to LSP) |
| `<leader>cf` | v | Format selection |
| `[d` | n | Previous diagnostic (+ float) |
| `]d` | n | Next diagnostic (+ float) |
| `<leader>d` | n | Show diagnostic |
| `<leader>xx` | n | Project diagnostics (Trouble) |
| `<leader>xb` | n | Buffer diagnostics (Trouble) |
| `<leader>xs` | n | Document symbols (Trouble) |
<!-- /keymaps:check -->

**LSP** (when a server is attached):

| Keys | Mode | Action |
|:-----|:----:|:-------|
| `gd` / `gD` | n | Definition / declaration |
| `K` | n | Hover documentation |
| `grr` / `gri` | n | References / implementation |
| `grn` / `<leader>rn` | n | Rename symbol |
| `gra` / `<leader>ca` | n, v | Code action |
| `gO` | n | Document symbols |
| `<C-s>` | i | Signature help |
| `<leader>lwa` / `<leader>lwr` / `<leader>lwl` | n | Workspace folder add / remove / list |

**Completion & snippets** (insert mode): `<C-Space>` open · `<C-j>` / `<C-k>` or `<Tab>` / `<S-Tab>` select / jump in snippet · `<CR>` confirm · `<C-e>` abort.

**Editing:** `gcc` / `gc{motion}` comment · `ys{motion}{char}` / `ds{char}` / `cs{old}{new}` surround · brackets and quotes auto-pair.

## Neovim - git

Inside a git repository (buffer-local):

| Keys | Mode | Action |
|:-----|:----:|:-------|
| `]h` / `[h` | n | Next / previous hunk |
| `<leader>hs` | n | Stage hunk |
| `<leader>hr` | n | Reset hunk |
| `<leader>hp` | n | Preview hunk |
| `<leader>hb` | n | Blame line |

## Neovim - AI (GitHub Copilot)

Run `:Copilot setup` once (token is stored in `~/.config/github-copilot`).

<!-- keymaps:check -->
| Keys | Mode | Action |
|:-----|:----:|:-------|
| `<leader>ac` | n | AI chat (toggle) |
| `<leader>aa` | n | AI actions palette |
| `<leader>ae` | x | Explain selection |
| `<leader>af` | x | Fix selection |
| `<leader>ar` | x | Refactor selection |
| `<leader>at` | x | Generate tests for selection |
| `<leader>apr` | n | Review uncommitted changes |
| `<leader>apc` | n | Generate commit message (staged) |
<!-- /keymaps:check -->

Inline suggestions: `<C-l>` accept (insert mode). In chat: `/` slash commands, `#` context, `@` tools.

## Languages

| Language | LSP | Format (`<leader>cf`) | Detected as |
|:---------|:----|:----------------------|:------------|
| Python | basedpyright, ruff | ruff (imports + format) | `*.py` |
| Go | gopls | goimports + gofumpt | `*.go` |
| Terraform | terraform-ls, tflint | terraform fmt | `*.tf`, `*.tfvars` |
| Helm | helm-ls | - | `<chart>/templates/*`, `<chart>/values*.yaml` |
| Docker | dockerls, docker-compose-language-service | prettier (compose) | `Dockerfile`, `compose*.yaml` |
| GitHub Actions | gh-actions-language-server, yamlls | prettier | `.github/workflows/*.yml` |
| YAML / JSON | yamlls / jsonls | prettier | `*.yaml`, `*.json` |
| TOML | taplo | taplo | `*.toml` |
| Lua | lua_ls (+ lazydev) | stylua | `*.lua` |
| Bash | bashls | shfmt | `*.sh` |
| JS / TS / HTML / CSS | ts_ls / html / cssls | prettier | usual extensions |
| Markdown | marksman | prettier | `*.md` |
| SQL / C / C++ | sqls / clangd | LSP | usual extensions |
| gomplate | gopls | - | `*.tmpl`, `*.gotmpl` |

`:Mason` (installed tools) · `:checkhealth vim.lsp` · `:ConformInfo` · `:Lazy` (plugins, read-only: pinned by the image).

## Personal overrides (survive updates)

| What | Where |
|:-----|:------|
| Shell | `~/.bashrc` |
| Prompt | `~/.liquidpromptrc` |
| Scripts / tools | `~/.local/bin` (`cargo install --root ~/.local`, `uv tool install ...`) |
| Neovim / tmux changes | this repo (`build/rootfs/opt/toolbox/config/`) - pinned, tested, shipped |
