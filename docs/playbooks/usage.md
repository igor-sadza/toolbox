# Usage

Run from the checkout with Bash, GNU Make, Docker access, and the Compose plugin. Defaults target Linux and amd64/x86-64 assets; ARM and Docker Desktop portability is not established. The host must provide `/dev/fuse` unless that device mapping is removed. Review the [host-connected trust and persistence boundaries](../reference/runtime.md) before starting.

## Start and Use

1. Optionally copy `.env.example` to the Git-ignored `.env` for local settings. Check [profile precedence](../reference/runtime.md#environment-selection) first; Make may select a profile instead of `.env`.

   ```sh
   cp .env.example .env
   ```

2. Pull the configured image and create the long-lived container.

   ```sh
   make start
   ```

Expected: Compose creates a running `toolbox` container from the selected image. Do not continue if startup fails.

3. Open a session or run a command as the invoking host user.

   ```sh
   ./toolbox
   ./toolbox id
   ```

Expected: numeric user/group credentials match the caller and mounted working-directory files are available. A missing working directory falls back to home, then `/`. Nonstandard home paths require the mount described in the runtime reference. [OpenCode integration](../reference/opencode.md) has unresolved launch/configuration blockers; ordinary wrapper access does not prove MCP access.

For an optional system-wide wrapper installation, `sudo make install` writes `/usr/local/bin/toolbox` and requires administrator approval. Thereafter use `toolbox` from mounted project directories. See `make help` and `./toolbox --help` rather than maintaining a duplicate command inventory.

## Update, Roll Back, and Stop

These operations replace or remove the container and lose its writable filesystem. Finish active work and preserve [container-local data](../reference/runtime.md#persistence-boundaries) first.

1. For an update or rollback, select an available registry tag and recreate the container. Set `VERSION` to the desired tag; `latest` below is an example, not a rollback target.

   ```sh
   VERSION='latest'
   make start TOOLBOX_VERSION="$VERSION"
   docker inspect --format '{{.Config.Image}}' toolbox
   ./toolbox id
   ```

Expected: the selected image is reported and normal wrapper access works. Rollback requires an older tag that remains available; it does not undo changes to mounted files. For a lasting pin, set `TOOLBOX_VERSION` in the environment file Make actually selects.

2. To stop and remove the Toolbox container:

   ```sh
   make stop
   ```

Expected: the container is removed; host-mounted files remain. Image publication and retention must be checked separately in the [maintenance procedure](image-maintenance.md).

## Troubleshooting

- Missing/stopped container: run `make start` with the intended profile; the host wrapper never starts it automatically.
- Startup failure: check Docker-daemon access and `/dev/fuse` availability. If FUSE is unnecessary, remove only its device mapping from local configuration rather than weakening security elsewhere.
- Wrong image/settings: inspect Compose configuration using the same trusted Bash profile and explicit image/version overrides as Make. Compose's `--env-file` parser is not equivalent to Bash sourcing; output may expose sensitive configuration.
- Host command missing under `toolbox --host`: check that it exists on the host. This privileged mode uses the host root filesystem and requires explicit approval; see [host access](../reference/runtime.md#host-access).
