# Runtime and Persistence

This is a host-connected environment, not a security sandbox. The [Compose configuration](../../deployments/docker-compose.yml) exposes writable host `/home`, the host Docker socket, host networking, and mount-related privileges. Docker-daemon access is effectively root-equivalent on the host.

## Environment Profile

Make selects `.env.$(ENV)` (`ENV=dev` by default), then `.env`, then [`.env.example`](../../.env.example). Use `ENV=<name>` to select a profile. Make sources the selected file as Bash code — use only trusted files. Only command-line `TOOLBOX_IMAGE` and `TOOLBOX_VERSION` are explicitly reapplied after sourcing; do not assume other overrides replace profile values.

The host wrapper does not load these files or forward arbitrary host environment variables into `docker exec`. Direct wrapper commands do not start Bash or read `~/.bashrc`.

## Identity and Trust

The [session script](../../build/rootfs/usr/bin/toolbox.sh) runs first as root, sets home and XDG environment paths, and drops to the caller's numeric UID/GID plus host groups, `toolbox-shared`, and `sudo`. A passwd entry is created only when neither UID nor username already exists.

Passwordless sudo is configured inside Toolbox. Shared configuration, binaries, and supporting data are group-writable by `toolbox-shared`; users sharing a container can change tooling for other sessions. The default umask `0002` permits group-writable and world-readable new files. Use restrictive permissions for secrets, including files in mounted home directories.

## Persistence Boundaries

| Boundary | What survives recreation |
|---|---|
| Host home at the same mount path | Personal files, configuration, and state beneath that path |
| Remote storage | Declared mounts are re-established subject to availability; ad-hoc must be remounted |
| Host Docker daemon | Images and daemon resources remain, except the Toolbox container |
| Container filesystem | Everything inside the container is lost on recreation |

If `$HOME` is elsewhere, configure a read-write bind mount at the same path before relying on home persistence. There is no configured propagation for `/home`: a mount made inside Toolbox is not established as a host mount.

Personal binaries can live in `~/.local/bin`, but shared tool paths precede them on `PATH`. For uv tools, both `UV_TOOL_DIR` and `UV_TOOL_BIN_DIR` need personal destinations rather than image defaults.

## Host Access

`toolbox --host` starts a temporary privileged container using the existing Toolbox image, mounts host `/` at `/host`, enters host namespaces, and runs `chroot /host`. It runs as host root and is removed on exit. Commands must exist on the host, not just in the image. Use only for explicitly approved host work.
