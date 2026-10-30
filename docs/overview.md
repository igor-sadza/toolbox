# Overview

Toolbox defines a Debian-based Docker image for a host-integrated development shell and configures workflows to build and publish it. Make/Compose create a long-lived container; the host wrapper enters it. This is one image/runtime repository.

## Components

| Component | Responsibility | Source |
|---|---|---|
| Image | Installs tools and runtime entrypoints | [`build/Dockerfile`](../build/Dockerfile), [`build/rootfs/`](../build/rootfs/) |
| Host wrapper | Enters container as invoking user or starts privileged host chroot | [`toolbox`](../toolbox) |
| Container orchestration | Image, mounts, network, capabilities, build args | [`deployments/docker-compose.yml`](../deployments/docker-compose.yml), [`.env.example`](../.env.example) |
| Build & smoke checks | GitHub Actions workflow, lint, scanning | [`.github/workflows/`](../.github/workflows/), [`.cicd/tests/smoke.sh`](../.cicd/tests/smoke.sh) |
| Release & dependency updates | Semantic release on `develop`; Renovate proposes versions | [`.releaserc.yml`](../.releaserc.yml), [`renovate.json`](../renovate.json) |

## Documentation Map

| Directory | Content |
|---|---|
| [`playbooks/`](playbooks/) | Actionable procedures: [usage](playbooks/usage.md), [image maintenance](playbooks/image-maintenance.md), [storage](playbooks/storage.md) |
| [`reference/`](reference/) | Boundaries and integration: [runtime](reference/runtime.md), [automation](reference/automation.md), [neovim](reference/neovim-integration.md), [opencode](reference/opencode.md), [terminal](reference/terminal-clipboard.md), [tools](reference/tools.md) |
| [`architecture/`](architecture/) | Design rationale: [dotfiles proposal](architecture/dotfiles-proposal.md) |
| [`notes/`](notes/) | Developing questions: [clipboard image bridge](notes/clipboard-image-bridge.md) |
| [Roadmap](roadmap.md) | Proposed future work |
| [CHANGELOG.md](../CHANGELOG.md) | Release history |

## Evidence Boundaries

Repository files show configured source and automation, not verified operation. No deployment or registry state is established here. Known gaps: [OpenCode integration](reference/opencode.md#launch-and-configuration), [interactive clipboard behavior](reference/terminal-clipboard.md#remaining-verification).
