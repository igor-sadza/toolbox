# Dotfiles Proposal

**Status: Proposed.** This document records a possible separation of user-level configuration from the Toolbox runtime. No Dotfiles repository or migration is established by this proposal.

## Goal

To separate user-level configuration (preferences, AI agents, and skills) from the Toolbox runtime (container image and system dependencies), allowing for independent maintenance, distribution, and versioning.

## Boundaries and Constraints

| Repository | Proposed Responsibility |
|---|---|
| Toolbox | Runtime, container image, application installation, system dependencies, and initialization. |
| Dotfiles | User-level configuration, AI agents, skills, preferences, and distribution. |

- Toolbox should not need Dotfiles to operate.
- Dotfiles should not build or install the complete runtime.
- Configuration should be installed via symlinks or a simple, repeatable mechanism into conventional user paths (`~/.config/nvim`, `~/.config/tmux`, etc.).
- Installation must be idempotent, detect conflicts (no silent overwrites), and support Linux and WSL.
- No Docker, Node.js, or network access should be required for basic setup.

## Distribution and Maintenance

Possible initial layout: `apps/` for application settings, `ai/skills/`, `ai/prompts/`, and `scripts/` for installation helpers.

Maintenance should use semantic release and PR-based updates for plugins, with validation covering shell scripts, configuration syntax, and Neovim headless startup.

## Migration Risks

Before extraction, audit wrapper commands, shell initialization, and image dependencies. Copying files is insufficient; shared binaries and plugin installation scripts are deeply integrated into the image.

| Current Toolbox Source | Possible Destination |
|---|---|
| `.../nvim/` | `apps/nvim/` |
| `.../tmux/` | `apps/tmux/` |
| `.../opencode/` | `apps/opencode/` |
| `.../liquidpromptrc/` | `apps/liquidprompt/` |

## Open Decisions

- Whether to extract tmux/Nvim configuration or manage it within the image.
- Migration steps and validation criteria for "clean container recreation".

## Acceptance Criteria

- Repeatable installation on a fresh compatible Linux environment.
- Correct application configuration loading.
- Verified Toolbox operation with and without Dotfiles.
- Documented install, update, validation, and rollback procedures.
- No exposed credentials.

For Toolbox's tracked work, see the [roadmap](../roadmap.md). Current image boundaries are described in the [overview](../overview.md).
