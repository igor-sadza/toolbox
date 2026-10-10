# Tool Catalogue

This human-readable selected default-build catalogue is generated from [`.env.example`](../../.env.example) by [`.cicd/docs/update-tools.sh`](../../.cicd/docs/update-tools.sh). Existing [checksum automation](../../.github/workflows/checksums.yml) writes this file; it is retained without adding a parallel inventory. It lists configured inputs, not a complete installed-tool inventory or observed versions. Manual input/generator changes require the [refresh procedure and marker checks](../playbooks/image-maintenance.md#review-an-update); automation only handles matching Renovate PRs.

<!-- tools:start -->
| Tool | Method | Version |
|:-----|:------:|:--------|
| [Neovim](https://github.com/neovim/neovim) | `BIN` | `v0.12.4` |
| [Docker Engine](https://docs.docker.com/engine/) | `GPG` | `5:29.6.2-1~debian.13~trixie` |
| [Docker Buildx](https://github.com/docker/buildx) | `GPG` | `0.35.0-1~debian.13~trixie` |
| [Docker Compose](https://github.com/docker/compose) | `GPG` | `5.3.1-1~debian.13~trixie` |
| [K9s](https://github.com/derailed/k9s) | `BIN` | `v0.51.0` |
| [Helm](https://helm.sh) | `GPG` | `4.2.3-1` |
| [Kubectl](https://kubernetes.io/docs/reference/kubectl/) | `GPG` | `1.36.3-1.1` |
| [Terraform](https://www.terraform.io) | `GPG` | `1.15.8-1` |
| [Azure CLI](https://learn.microsoft.com/cli/azure/) | `GPG` | `2.88.0-1~bookworm` |
| [Node.js](https://nodejs.org) | `GPG` | `22.23.1-1nodesource1` |
| [Gomplate](https://github.com/hairyhenderson/gomplate) | `BIN` | `v5.2.0` |
| [Act](https://github.com/nektos/act) | `BIN` | `v0.2.89` |
| [Rust](https://www.rust-lang.org) | `RUSTUP` | `1.98.1` |
| [tree-sitter CLI](https://github.com/tree-sitter/tree-sitter) | `CARGO` | `0.26.11` |
| [OpenCode](https://opencode.ai) | `NPM` | `1.18.13` |
| [Codex CLI](https://github.com/openai/codex) | `NPM` | `0.153.4` |
| [uv](https://github.com/astral-sh/uv) | `PIPX` | `0.12.1` |
| Base image | `DOCKER` | `debian:trixie-slim` |
<!-- tools:end -->

## Core Package Availability

`less` and `iproute2` are provisioned unconditionally in the miscellaneous APT section of the [Dockerfile](../../build/Dockerfile). `curl` is installed by optional tool sections enabled in the default configuration; its availability therefore depends on those sections. These are provisioning facts, not observed runtime checks. Explicit core provisioning of `curl` is tracked in the [roadmap](../roadmap.md#shell-quality-of-life).
