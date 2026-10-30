# Storage

Declared NFS volumes are mounted by the Docker daemon; ad-hoc NFS/FUSE mounts run inside Toolbox. Remote data survives recreation, but ad-hoc attachments do not. Review [persistence boundaries](../reference/runtime.md#persistence-boundaries) before recreating the container.

## Declared NFS Mount

1. Adapt the commented service mount and top-level volume in [Compose](../../deployments/docker-compose.yml). No NFS volume is active by default.

    The example's writable `soft` mount can return I/O errors during network failures and risk data corruption. Prefer NFSv4 where supported. Export permissions depend on server policy and numeric user IDs.

2. Preserve container-local data, then start:

    ```sh
    make start
    ```

    **Expected**: Docker re-establishes the declared export. Startup can fail if the server/network is unavailable.

3. Check the configured destination:

    ```sh
    findmnt /mnt/nfs/data
    ```

    **Expected**: Source, filesystem type, and contents match the authorized export. Stop if they differ.

## Ad-Hoc Mount Constraints

Compose configures `SYS_ADMIN` and `apparmor:unconfined` for mount operations. `/dev/fuse` is mapped for SSHFS/rclone. Use upstream procedures for authentication and mount options.

- Verify each attachment with `findmnt` before use.
- No propagation is configured for `/home`; an in-container attachment is not established as a host mount.
- A lost attachment does not delete remote data.
- Remount ad-hoc attachments after recreation; declared mounts are re-established by Docker subject to availability.

Actual NFS/FUSE operation is not verified by smoke checks.
