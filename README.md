# Toolbox

Docker-based development environment with pinned tool versions and host-integrated shell. This repository defines the Debian image, runtime wrapper, and build/release automation.

## Prerequisites

Linux, Bash, GNU Make, Docker with Docker Compose. `/dev/fuse` is required when the device mapping (`/dev/fuse:/dev/fuse`) is present in the Compose file; remove the mapping if FUSE is not needed.

## Quick Start

```sh
# 1. Build locally or pull pre-built image
make start-local    # Build locally, recreate container
# OR
make start          # Pull from GHCR, recreate container

# 2. Enter the container
./toolbox           # Interactive shell
./toolbox id        # Run a command

# 3. Stop when done (optional)
make stop
```

## Lifecycle

`make start` (pull) and `make start-local` (build) are **alternatives** -- choose one to obtain the image and (re)create the container. They are not sequential steps.

```
Lifecycle (ASCII)

  make start          pull image -> docker compose up -> (re)create container
  make start-local    build image -> docker compose up -> (re)create container
  make stop           docker compose stop + rm -f
  make host           ./toolbox --host  (privileged chroot into host)

Quick start:

  make start                  # OR: make start-local (pull/build)
  ./toolbox                   # shell  (docker exec into running container)
  ./toolbox <cmd>             # run command (docker exec)
  make stop                   # (optional) stop and remove container
```

## Architecture

```
host
|
|-- ./toolbox           # wrapper: inspect container, then "docker exec"
|    |                  #    into the long-lived running container.
|    +-->/usr/bin/toolbox.sh (inside container)
|
|-- make start/start-local    -> docker compose up --detach --force-recreate
|                                 |
|                                 +-->"toolbox" container (network_mode: host)
|                                    |
|                                    |-- mounts: /home
|                                    |-- mounts: /var/run/docker.sock
|                                    |-- device: /dev/fuse
|                                    |
|                                    +-- ENTRYPOINT: /entrypoint.sh
|                                    +-- CMD:        sleep infinity
|
+-- make host -> ./toolbox --host -> docker run --privileged (chroot /)
```

## Make Commands

| Command | Does |
|---|---|
| `make start` | Pull image, recreate container |
| `make start-local` | Build image locally, recreate container |
| `make pull` | Pull image only (no container action) |
| `make build` | Build image locally only (no container action) |
| `make stop` | Stop and remove container |
| `make host` | Privileged chroot to host root filesystem |
| `make test IMAGE=...` | Smoke test an image |
| `make install` | Install wrapper to `/usr/local/bin` |
| `make cicd` | Run CI workflow locally via `act` |
| `make help` | List all targets |

## Overrides

| Override | Example | Description |
|---|---|---|
| Image/Tag | `make start TOOLBOX_VERSION=<tag>` | Pull a specific version |
| ENV Profile | `ENV=prod make start` | Use `.env.prod` instead of `.env.dev` |
| Build Args | `make build ARGS=--no-cache` | Pass extra Docker build flags |
| Install Path | `make install PREFIX=/opt/toolbox` | Install wrapper to custom location |

## Warnings

**NOT A SANDBOX**: Container has **read-write access to your host `/home`** and **root-equivalent Docker socket access**. Trust the image and tools.

**CONTAINER-LOCAL LOSS**: Files inside the container (not mounted) are lost on `make stop` or container recreation. Only `/home` and declared volumes persist.

**HOST ROOT**: `make host` gives privileged access to your host filesystem (`chroot /`) and host namespaces. Use only for explicitly approved maintenance.

## Documentation

- [Overview](docs/overview.md) - Scope and documentation structure
- [Usage](docs/playbooks/usage.md) - Setup and daily use
- [Image Maintenance](docs/playbooks/image-maintenance.md) - Build, test, update
- [Runtime & Persistence](docs/reference/runtime.md) - Boundaries and trust
- [Automation](docs/reference/automation.md) - CI/CD and releases
- [Neovim](docs/reference/neovim-integration.md) - Configuration entrypoints
- [OpenCode](docs/reference/opencode.md) - MCP integration
- [Clipboard](docs/reference/terminal-clipboard.md) - Terminal behavior
- [Roadmap](docs/roadmap.md) - Planned work
