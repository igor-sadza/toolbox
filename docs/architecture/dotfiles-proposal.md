# Dotfiles Proposal

**Status: Proposed.** This document records a possible separation of user-level configuration from the Toolbox runtime. No Dotfiles repository or migration is established by this proposal.

## Boundary

| Repository | Proposed responsibility |
|---|---|
| Toolbox | Runtime, container image, application installation, system dependencies, and initialization |
| Dotfiles | User-level application configuration, AI agents and skills, preferences, and distribution |

The intent is independent maintenance and versioning: Toolbox provides a runtime, while Dotfiles distributes user configuration. Toolbox should not need Dotfiles to operate, and Dotfiles should not build or install the complete runtime.

This is a proposed boundary, not the current implementation. Toolbox currently copies configuration into `/opt/toolbox/config` from [`build/rootfs/`](../../build/rootfs/) and sets `/opt/toolbox/config` as its shared configuration path in the [Dockerfile](../../build/Dockerfile). For example, the Neovim, tmux, Liquidprompt, and OpenCode configuration is currently image content.

## Proposed Distribution

Configuration could be installed by symlinks or another simple, repeatable mechanism into conventional user paths, including `~/.config/nvim`, `~/.config/tmux`, and `~/.config/opencode`. Installation should be idempotent, detect conflicts rather than silently overwrite user files, support compatible Linux and WSL environments, avoid requiring Docker or Node.js for basic setup, and avoid network access on each shell startup. Secrets and machine-specific values must remain local.

Reusable AI skills and prompts could be versioned alongside application settings, while each consuming project retains its own `AGENTS.md` and project documentation. Global instructions and skills should remain project-agnostic. Possible initial capabilities include a default engineering agent, architecture and documentation workflows, infrastructure review/debug skills, and reusable prompts.

An illustrative minimal layout could group application settings under `apps/`, reusable agent skills under `ai/skills/`, prompts under `ai/prompts/`, and idempotent installation/validation helpers under `scripts/`. Application topics might initially include Neovim (including its lockfile), tmux, OpenCode, and Liquidprompt. Add directories only when actual content requires them. Optional public HTTP distribution, for example at `https://igor-sadza.github.io/dotfiles/`, could expose selected public OpenCode instructions, skill catalogues, prompts, and documentation; it should not be required for local configuration, and secret or local override files must never be published.

## Proposed Maintenance

Conventional Commits and semantic release automation could version the repository and generate changelogs and GitHub releases. Dependency automation should avoid duplicating the responsibility of a Neovim plugin update workflow. Plugin updates should be validated and proposed through pull requests rather than deployed without review. Validation could cover shell scripts, configuration syntax, and Neovim headless startup. These are possible design choices, not configured automation.

## Migration Risks and Criteria

Before extraction, audit configuration paths, wrapper commands, shell initialization, image dependencies, and application behavior. Copying or symlinking files alone is insufficient: Neovim/tmux wrappers, OpenCode image variables, and build-time plugin installation select or provision shared configuration. Preserve runtime initialization that is required independently of user preferences. Validate both Toolbox without external configuration and Toolbox with it installed, including clean container recreation, before removing embedded files.

| Current Toolbox source | Possible Dotfiles destination |
|---|---|
| [`build/rootfs/opt/toolbox/config/nvim/`](../../build/rootfs/opt/toolbox/config/nvim/) | `apps/nvim/` |
| [`build/rootfs/opt/toolbox/config/tmux/`](../../build/rootfs/opt/toolbox/config/tmux/) | `apps/tmux/` |
| [`build/rootfs/opt/toolbox/config/opencode/`](../../build/rootfs/opt/toolbox/config/opencode/) | `apps/opencode/` |
| [`build/rootfs/opt/toolbox/config/liquidpromptrc/`](../../build/rootfs/opt/toolbox/config/liquidpromptrc/) | `apps/liquidprompt/` |

The source locations above are current; all destinations and migration steps are proposed.

Possible work stages are repository bootstrap and supported-environment conventions; configuration audit and extraction; safe installation and synchronization; reusable AI resources; optional Pages distribution; then validation and release automation. Bootstrap would establish the minimal layout, Makefile, and installation conventions. Extraction would audit dependencies, migrate the listed application settings, exclude environment-specific secrets, and verify behavior. Installation work could add idempotent install/update/doctor commands, safe symlinks and conflict backups, and tests on WSL and inside Toolbox, including persistence across recreation. AI resources could include a default `auto` engineering agent, architecture/documentation roles, Terraform-review and Kubernetes-debug skills, and reusable prompts, while keeping global content project-agnostic. Optional Pages work could validate resource discovery, HTTP access, and caching, while publishing only selected public files. CI and release work could add shell/configuration/Neovim validation, reviewed plugin-update pull requests, Renovate, semantic release, Conventional Commit rules, and checks for required GitHub permissions and branch protection.

A first usable version would need repeatable installation on a fresh compatible Linux environment, correct application configuration loading, Toolbox operation both with and without Dotfiles, reviewed plugin updates, documented install/update/validation/rollback procedures, and no exposed credentials. These are proposal criteria, not scheduled commitments.

For Toolbox's tracked work, see the [roadmap](../roadmap.md). Current image and component boundaries are described in the [repository overview](../overview.md).
