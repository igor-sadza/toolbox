# Overview

Toolbox defines a Debian-based Docker image for a host-integrated development shell and configures workflows to build and publish it. Make/Compose create a long-lived container; the host wrapper enters it. This is one image/runtime repository, not a monorepository of independently maintained applications.

The repository uses Bash and Make for runtime/build orchestration, Docker Compose for container configuration, GitHub Actions for image and release workflows, and Node.js `semantic-release` for release automation. Renovate is configured for dependency updates; these files establish configuration, not successful operation.

## Components

| Component | Responsibility | Source |
|---|---|---|
| Image | Installs tools, configuration, and runtime entrypoints | [`build/Dockerfile`](../build/Dockerfile), [`build/rootfs/`](../build/rootfs/) |
| Host wrapper | Runs commands in the container as the invoking user, or starts a privileged host chroot for `--host` | [`toolbox`](../toolbox) |
| Container orchestration | Defines image, mounts, network, capabilities, and build arguments | [`deployments/docker-compose.yml`](../deployments/docker-compose.yml), [`.env.example`](../.env.example) |
| Build and smoke checks | Configures image lint, scanning, build, and smoke-test workflows | [`.github/workflows/`](../.github/workflows/), [`.cicd/tests/smoke.sh`](../.cicd/tests/smoke.sh) |
| Release and dependency updates | Configures semantic releases and Renovate updates | [`.releaserc.yml`](../.releaserc.yml), [`renovate.json`](../renovate.json) |

## Documentation Responsibilities

The [README](../README.md) is the entry point; this overview owns project scope and selective navigation. Keep durable, project-specific knowledge by purpose, linking to source for ordinary settings and tool inventories.

| Area | Responsibility |
|---|---|
| [`reference/`](reference/) | Non-obvious boundaries and configured integration: [runtime and persistence](reference/runtime.md), [automation](reference/automation.md), [Neovim](reference/neovim-integration.md), [OpenCode](reference/opencode.md), and [terminal/clipboard](reference/terminal-clipboard.md). The selected [tool catalogue](reference/tools.md) remains because existing automation refreshes it |
| [`playbooks/`](playbooks/) | Actionable procedures and recovery: [usage](playbooks/usage.md), [image maintenance](playbooks/image-maintenance.md), and [storage](playbooks/storage.md) |
| [`architecture/`](architecture/) | System boundaries and design rationale; the [Dotfiles separation](architecture/dotfiles-proposal.md) remains a proposal |
| [`notes/`](notes/) | Developing questions, observations, and proposals with evidence and uncertainty, including the [clipboard image bridge](notes/clipboard-image-bridge.md) |
| [Roadmap](roadmap.md) | Proposed future work, not an inventory of current capabilities or a release history |

Keep purpose directories flat until topic grouping improves navigation; bundled application settings do not require a separate documentation hierarchy. Agent skills and Neovim prompts under `build/rootfs/` are runtime resources, not maintained repository guidance. Historical source links identify planning or earlier configuration, not corroboration of current operation.

Current behavior and verification gaps belong with their canonical topic; proposals do not establish implemented behavior. [CHANGELOG.md](../CHANGELOG.md) records release history.

## Evidence Boundaries

Repository files show implemented source and configured automation, not successful operation. No deployment or registry state is established by this documentation. See [image maintenance](playbooks/image-maintenance.md#build-and-test) for configured check scope. [OpenCode launch/configuration](reference/opencode.md) and interactive clipboard behavior have explicit verification gaps.
