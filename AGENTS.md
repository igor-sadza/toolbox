# Repository Guidance

- Treat source and configuration as evidence; distinguish implemented, configured, verified, planned, and unknown.
- Keep documentation concise. Update links when moving documents. Do not duplicate generated tool versions.
- Preserve unrelated worktree changes. Do not modify runtime implementation when performing documentation work.

## Verification

- `make test IMAGE=<image>` runs smoke checks; requires Docker and an available image.
- `bash -n .cicd/docs/update-tools.sh` validates the documentation generator syntax.
- After documentation changes, verify link integrity and generated output consistency.

## Task Map

| Task | Context |
|---|---|
| Scope and documentation structure | [Overview](docs/overview.md) |
| Daily use and setup | [Usage](docs/playbooks/usage.md), [Runtime](docs/reference/runtime.md) |
| Storage and NFS | [Storage](docs/playbooks/storage.md) |
| OpenCode and MCP access | [OpenCode](docs/reference/opencode.md) |
| Neovim configuration | [Neovim](docs/reference/neovim-integration.md) |
| Clipboard behavior | [Terminal](docs/reference/terminal-clipboard.md), [Image Bridge Note](docs/notes/clipboard-image-bridge.md) |
| Build, test, release | [Image Maintenance](docs/playbooks/image-maintenance.md), [Automation](docs/reference/automation.md), [Tools](docs/reference/tools.md) |
| Planned work | [Roadmap](docs/roadmap.md) |
| Proposed boundaries | [Dotfiles Proposal](docs/architecture/dotfiles-proposal.md) |
