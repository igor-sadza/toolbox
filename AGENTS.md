# Repository Guidance

- Treat source and configuration as evidence of behavior; distinguish implemented, configured, verified, planned, and unknown claims.
- Keep documentation concise and update links when moving documents. Do not duplicate generated tool versions.
- Preserve unrelated worktree changes. Do not modify runtime implementation when performing documentation work.

## Verification

- `make test IMAGE=<image>` runs the configured image smoke checks; it requires Docker and an available image.
- `bash -n .cicd/docs/update-tools.sh` checks the documentation generator's shell syntax.
- After documentation or generator changes, verify links and generated output consistency. Repository CI does not configure Markdown link validation.

## Task Map

| Task | Context |
|---|---|
| Understand repository scope and source locations | [Overview](docs/overview.md) |
| Maintain documentation and locate canonical topic guidance | [Document responsibilities](docs/overview.md#documentation-responsibilities) |
| Use or configure Toolbox | [Usage](docs/playbooks/usage.md), [runtime and persistence](docs/reference/runtime.md) |
| Configure storage | [Storage](docs/playbooks/storage.md) |
| Review OpenCode launch/configuration gaps or MCP access | [OpenCode integration](docs/reference/opencode.md) |
| Configure Neovim entrypoints or review plugin and Mason updates | [Neovim integration](docs/reference/neovim-integration.md) |
| Review cross-component clipboard verification and the image bridge proposal | [Terminal and clipboard](docs/reference/terminal-clipboard.md), [image bridge note](docs/notes/clipboard-image-bridge.md) |
| Build, test, release, or update the image | [Image maintenance](docs/playbooks/image-maintenance.md), [automation](docs/reference/automation.md), [tool catalogue](docs/reference/tools.md) |
| Review future work | [Roadmap](docs/roadmap.md) |
| Review proposed repository boundary | [Dotfiles proposal](docs/architecture/dotfiles-proposal.md) |
