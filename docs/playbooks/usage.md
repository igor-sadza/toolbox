# Usage

Run from the checkout with Bash, GNU Make, Docker, and Compose. Defaults target Linux amd64; ARM and Docker Desktop portability are not established. The host must provide `/dev/fuse` unless that device mapping is removed. Review [runtime boundaries](../reference/runtime.md) before starting.

## Start and Use

1. Copy `.env.example` to `.env` for local overrides. Check [profile precedence](../reference/runtime.md#environment-profile) first; Make may select a profile instead of `.env`.

    ```sh
    cp .env.example .env
    ```

2. Pull the configured image and create the long-lived container.

    ```sh
    make start
    ```

    **Expected**: Compose creates a running `toolbox` container from the selected image.

3. Open a session or run commands as the invoking host user.

    ```sh
    ./toolbox              # Interactive shell
    ./toolbox id           # Run a command
    ```

    **Expected**: Numeric UID/GID match the caller. Working directory falls back: caller path → home → `/`. A missing working directory falls back to home.

For a system-wide wrapper installation, `sudo make install` writes `/usr/local/bin/toolbox`. Thereafter use `toolbox` directly from project directories. See `make help` and `./toolbox --help` rather than maintaining a duplicate command inventory.

## Update, Roll Back, and Stop

These operations replace or remove the container and lose its writable filesystem. Preserve [container-local data](../reference/runtime.md#persistence-boundaries) first.

1. Update or roll back to a specific tag:

    ```sh
    make start TOOLBOX_VERSION=v1.8.3
    docker inspect --format '{{.Config.Image}}' toolbox
    ```

    **Expected**: The selected image is reported. Rollback requires an older tag that remains available; it does not undo changes to mounted files. For a lasting pin, set `TOOLBOX_VERSION` in the environment file Make selects.

2. Stop and remove the container:

    ```sh
    make stop
    ```

    **Expected**: Container is removed; host-mounted files remain.

## Troubleshooting

| Symptom | Action |
|---|---|
| Missing/stopped container | Run `make start` with the intended profile |
| Startup failure | Check Docker access and `/dev/fuse`. Remove only the FUSE device mapping if unnecessary |
| Wrong image/settings | Inspect Compose configuration; be aware `--env-file` parsing differs from Bash sourcing |
| `toolbox --host` missing host command | Check that the command exists on the host |
