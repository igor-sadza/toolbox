<!---
############################################################
# Copyright (c) 2026 Igor Sadza
# Released under the GPLv3 license
# ----------------------------------------------------------
#
# FILE: ./docs/persistence.md
# DESC: Persistence - what survives an image update
#
############################################################
--->
<!---
 /$$$$$$$                              /$$             /$$
| $$__  $$                            |__/            | $$
| $$  \ $$ /$$$$$$   /$$$$$$   /$$$$$$$ /$$  /$$$$$$$ /$$$$$$
| $$$$$$$//$$__  $$ /$$__  $$ /$$_____/| $$ /$$_____/|_  $$_/
| $$____/| $$$$$$$$| $$  \__/|  $$$$$$ | $$|  $$$$$$   | $$
| $$     | $$_____/| $$       \____  $$| $$ \____  $$  | $$ /$$
| $$     |  $$$$$$$| $$       /$$$$$$$/| $$ /$$$$$$$/  |  $$$$/
|__/      \_______/|__/      |_______/ |__/|_______/    \___/
--->
# Persistence
<sup>[(Back to README)](../README.md#configuration)</sup>

- [Persistence - `What survives`](#persistence---what-survives)
- [Persistence - `Personal additions`](#persistence---personal-additions)

##
<h3 id="persistence---what-survives">
   $\large\color{Goldenrod}{\textbf{Persistence - What survives}}$
</h3>

`make start` **recreates** the container from the image. Only mounted paths survive:

| Location | Survives update? | Notes |
|:---------|:----------------:|:------|
| `/home/**` (your `$HOME`, projects, `~/.config`, `~/.local`, ...) | yes | bind mount of host `/home` |
| NFS volumes declared in compose | yes | mounted by the Docker daemon |
| `/host/**` | yes | it *is* the host filesystem |
| Docker images / containers you start | yes | they live in the host daemon |
| `sudo apt install ...` | **no** | add it to the Dockerfile instead |
| Changes in `/etc`, `/usr`, `/opt` | **no** | image content |
| `/opt/toolbox/{share,state,cache}` (Neovim plugins, Mason, cargo, go, uv tools, Neovim undo/shada) | **no** | baked into the image / reset |
| Ad-hoc `mount` / `sshfs` / `rclone mount` | **no** | remount after recreate |

> [!TIP]
> Rule of thumb: **anything you need every day belongs in the image** (Dockerfile + `.env.example`, pinned and tested by CI). Everything personal belongs in `$HOME`.

##
<h3 id="persistence---personal-additions">
   $\large\color{Goldenrod}{\textbf{Persistence - Personal additions}}$
</h3>

| What | Where (persists) |
|:-----|:-----------------|
| Personal scripts / binaries | `~/.local/bin` (add to `PATH` in `~/.bashrc`) |
| Python CLIs | `uv tool install --tool-dir ~/.local/share/uv/tools --tool-bin-dir ~/.local/bin <pkg>` |
| npm CLIs | `npm install --prefix ~/.local <pkg>` |
| Cargo CLIs | `cargo install --root ~/.local <crate>` |
| Go CLIs | `GOBIN=~/.local/bin go install <module>@<version>` |
| Prompt | `~/.liquidpromptrc` (overrides `/opt/toolbox/config/liquidpromptrc`) |
| Shell | `~/.bashrc` (sourced after `/etc/bash.bashrc.d/*`) |

The shared toolbox Neovim config lives in `/opt/toolbox/config/nvim` (image). Change it in this repo (`build/rootfs/opt/toolbox/config/nvim/`, one file per area in `lua/toolbox/`) so the change is pinned, tested and shipped to every machine.
