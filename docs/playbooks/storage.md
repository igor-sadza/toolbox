# Storage

Declared NFS volumes are mounted by the Docker daemon; ad-hoc NFS/FUSE mounts run inside Toolbox. Remote data survives recreation, but ad-hoc attachments do not. Prerequisites are an authorized endpoint, network access, and host filesystem/device support. Review [persistence boundaries](../reference/runtime.md#persistence-boundaries) before recreating the container.

## Declared NFS Mount

1. Adapt the commented service mount and top-level volume in [Compose](../../deployments/docker-compose.yml). No NFS volume is active by default. Choose server/export and options for the actual workload; do not maintain a second copy of the source example.

The example's writable `soft` mount can return I/O errors during network/server failures and risk data corruption. Evaluate that trade-off before using it for important data. Prefer NFSv4 where supported; NFSv3 can additionally require `rpcbind` and `statd`. Export permissions depend on server policy and numeric user IDs.

2. Finish active work and preserve container-local data, then run from the checkout:

   ```sh
   make start
   ```

Expected: Docker re-establishes the declared export. Startup or data availability can fail if the server/network is unavailable.

3. Inside Toolbox, check the configured destination; the source example uses:

   ```sh
   findmnt /mnt/nfs/data
   ```

Expected: source, filesystem type, and inspected contents match the authorized export. Stop if they differ; a populated local directory is not proof that the remote mount succeeded.

## Ad-Hoc Mount Constraints

Compose configures `SYS_ADMIN` and `apparmor:unconfined` for mount operations, subject to host policy, and maps `/dev/fuse` for SSHFS/rclone. The image provisions those tools; use their upstream procedures for authentication and mount options rather than duplicating generic tutorials here.

Verify each attachment with `findmnt` before use. On failure, check host support, device availability, network/authentication, and remote permissions before changing security settings. No propagation is configured for the bind-mounted `/home`; an in-container attachment is not established as a host mount. Losing an attachment does not delete remote data.

Finish users of a mount before unmounting. Remount ad-hoc attachments after recreation; declared mounts are re-established by Docker subject to availability. Actual NFS/FUSE operation is not verified by the image smoke checks.
