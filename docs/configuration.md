<!---
############################################################
# Copyright (c) 2026 Igor Sadza
# Released under the GPLv3 license
# ----------------------------------------------------------
#
# FILE: ./docs/configuration.md
# DESC: Configuration - runtime, storage, host access
#
############################################################
--->
<!---
  /$$$$$$                       /$$$$$$  /$$
 /$$__  $$                     /$$__  $$|__/
| $$  \__/  /$$$$$$  /$$$$$$$ | $$  \__/ /$$  /$$$$$$
| $$       /$$__  $$| $$__  $$| $$$$    | $$ /$$__  $$
| $$      | $$  \ $$| $$  \ $$| $$_/    | $$| $$  \ $$
| $$    $$| $$  | $$| $$  | $$| $$      | $$| $$  | $$
|  $$$$$$/|  $$$$$$/| $$  | $$| $$      | $$|  $$$$$$$
 \______/  \______/ |__/  |__/|__/      |__/ \____  $$
                                             /$$  \ $$
                                            |  $$$$$$/
                                             \______/
--->
# Configuration
<sup>[(Back to README)](../README.md#configuration)</sup>

- [Configuration - `Runtime`](#configuration---runtime)
- [Configuration - `Storage`](#configuration---storage)
- [Configuration - `Host access`](#configuration---host-access)

All settings live in [`.env.example`](../.env.example). Copy it to `.env` for local overrides (`.env` is git-ignored; the Makefile falls back to `.env.example` if there is no `.env`).

##
<h3 id="configuration---runtime">
   $\large\color{Goldenrod}{\textbf{Configuration - Runtime}}$
</h3>

| Variable | Default | Meaning |
|:---------|:--------|:--------|
| `TOOLBOX_IMAGE` | `ghcr.io/igor-sadza/toolbox` | Image used by `make start` |
| `TOOLBOX_VERSION` | `latest` | Tag: `latest`, `X.Y.Z`, `X.Y`, `X`, `weekly`, `edge` |
| `LIQUIDPROMPT_THEME` | `powerline` | Prompt theme |

The container runs **one long-lived process** (`sleep infinity` under `init`). Every `toolbox` call is a `docker exec` which runs `/usr/bin/toolbox.sh` as root; that script:

1. creates your user/group inside the container (same UID, GID, name, `$HOME`),
2. adds your host groups + `toolbox-shared` (29999) + `sudo` as supplementary groups,
3. drops to your UID with `setpriv` (`umask 0002`) and starts `bash` or the given command in `$PWD`.

`sudo` is passwordless inside the container.

> [!IMPORTANT]
> Mounting `/var/run/docker.sock` gives root-equivalent access to the host. This is by design (docker + host work from the toolbox); treat the toolbox like your host shell.

##
<h3 id="configuration---storage">
   $\large\color{Goldenrod}{\textbf{Configuration - Storage}}$
</h3>

**NFS - permanent shares (recommended).** Declared in [`deployments/docker-compose.yml`](../deployments/docker-compose.yml); the Docker daemon mounts them, they survive container recreate / image updates and need no extra capabilities:

```yaml
services:
  toolbox:
    volumes:
      - nfs-data:/mnt/nfs/data

volumes:
  nfs-data:
    driver: local
    driver_opts:
      type:   nfs
      o:      "addr=nas.example.lan,nfsvers=4.2,rw,soft,timeo=150"
      device: ":/export/data"
```

**NFS - ad-hoc.** `SYS_ADMIN` + `apparmor:unconfined` are enabled, so inside the toolbox:

```sh
sudo mkdir -p /mnt/tmp && sudo mount -t nfs -o nfsvers=4.2 nas.example.lan:/export/tmp /mnt/tmp
```

Ad-hoc mounts live only in the container and are **gone after `make start`** (recreate). Prefer NFSv4 (v3 additionally needs `rpcbind`/`statd`).

**FUSE.** `/dev/fuse` is passed through; `sshfs` and `rclone` are installed:

```sh
mkdir -p ~/mnt/server && sshfs user@server:/srv ~/mnt/server
rclone mount remote:bucket ~/mnt/bucket --daemon
```

The host must provide `/dev/fuse` (`modprobe fuse`), otherwise the container will not start - remove the `devices:` entry in that case.

`/home` and `/host` are mounted with `rslave` propagation: mounts created later **on the host** become visible in the toolbox without a restart.

##
<h3 id="configuration---host-access">
   $\large\color{Goldenrod}{\textbf{Configuration - Host access}}$
</h3>

| Need | How |
|:-----|:----|
| Read / edit host files | `/host` (host `/`, read-write) |
| Root shell **on the host** (systemd, packages, kernel modules, ...) | `toolbox --host` or `make host` |
| Run one host command as root | `toolbox --host systemctl status docker` |

`toolbox --host` starts a short-lived `--privileged --pid=host --net=host` container from the toolbox image and `chroot`s into the host `/`. Nothing keeps running afterwards.
