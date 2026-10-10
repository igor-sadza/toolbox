# Runtime and Persistence

Toolbox is a host-connected environment, not a security sandbox. The default [Compose configuration](../../deployments/docker-compose.yml) exposes writable host `/home`, the host Docker socket, host networking, and mount-related privileges. Trust the image and tools you run; Docker-daemon access is effectively root-equivalent on the host.

## Environment Selection

The [Makefile](../../Makefile) selects `.env.$(ENV)` (`ENV=dev` by default), then `.env`, then [`.env.example`](../../.env.example). Use `ENV=<name>` to select a profile. Make sources the selected file as Bash code: use only trusted files. Only command-line `TOOLBOX_IMAGE` and `TOOLBOX_VERSION` are explicitly reapplied after sourcing; do not assume other Make overrides replace profile values.

The host wrapper does not load these files or forward arbitrary host environment variables into `docker exec`. Direct wrapper commands do not start Bash or read `~/.bashrc`. Load application credentials in the actual application environment, not merely on the host; [OpenCode has a second container boundary](opencode.md).

## Identity and Trust

The [session script](../../build/rootfs/usr/bin/toolbox.sh) runs first as root, sets home and XDG environment paths, and drops to the caller's numeric UID/GID plus host groups, `toolbox-shared`, and `sudo`. It creates a passwd entry only when neither the UID nor username already exists; conflicting existing entries are not reconciled. Name-based behavior under collisions remains unverified. The working directory falls back from the caller's path to home, then `/`.

Passwordless sudo is configured inside Toolbox. Shared configuration, binaries, and supporting data are group-writable by `toolbox-shared`; users sharing a container can change tooling used by other sessions. The default umask `0002` permits group-writable and world-readable new files unless the application requests stricter permissions. Use restrictive permissions for secrets, including files in mounted home directories.

## Persistence Boundaries

`make start` and `make start-local` replace the Toolbox container; `make stop` removes it. Finish active work and preserve container-local data before any of these operations.

| Boundary | What survives recreation |
|---|---|
| Host home mounted at the same path | Personal files, configuration, and state beneath that mount |
| Remote storage | Remote data survives; declared mounts are re-established subject to availability, while ad-hoc attachments must be remounted |
| Host Docker daemon | Images and other daemon resources remain, except the Toolbox container being replaced or removed |
| Container filesystem | Changes to `/etc`, `/usr`, `/opt`, installed system packages, shared tool state/caches, and runtime directories are lost |

The default bind mount covers host `/home`. If `$HOME` is elsewhere, configure a read-write bind mount at the identical path before relying on home persistence. There is no configured propagation for `/home`: a mount made inside Toolbox is not established as a host mount. See the [storage playbook](../playbooks/storage.md) for NFS/FUSE constraints.

Personal binaries can live in `~/.local/bin`, but shared tool paths precede them on the image's `PATH`. Prepending a personal path in `~/.bashrc` affects interactive shells, not direct wrapper commands; use an explicit executable path when needed. Package-manager caches and supporting toolchains can remain container-local even when a binary destination is persistent. For uv tools, both `UV_TOOL_DIR` and `UV_TOOL_BIN_DIR` need personal destinations rather than the image's shared defaults.

Personal Liquidprompt preferences belong in `~/.liquidpromptrc` or the user configuration path. The shell loader advertises a shared fallback, but the current overlay places its file inside `config/liquidpromptrc/`; effective fallback loading is not verified. Neovim has separate [entrypoint and state rules](neovim-integration.md#entrypoints-and-persistence).

## Host Access

The normal [host wrapper](../../toolbox) enters an already-running container; Make/Compose create it. `toolbox --host` instead starts a temporary privileged container using the existing Toolbox container's image, mounts host `/` at `/host`, enters host namespaces, and runs `chroot /host`. It runs as host root and is removed on exit. Commands in that mode must exist on the host, not just in the image. Use it only for explicitly approved host work.

Host APT proxy settings do not configure image builds, running Toolbox sessions, or the Docker daemon. Corporate proxy and trust-store integration remains [proposed](../roadmap.md#corporate-networks); follow administrator guidance rather than bypassing certificate verification.
