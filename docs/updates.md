<!---
############################################################
# Copyright (c) 2026 Igor Sadza
# Released under the GPLv3 license
# ----------------------------------------------------------
#
# FILE: ./docs/updates.md
# DESC: Updates - automation pipeline, adding tools, rollback
#
############################################################
--->
<!---
 /$$   /$$                 /$$             /$$
| $$  | $$                | $$            | $$
| $$  | $$  /$$$$$$   /$$$$$$$  /$$$$$$  /$$$$$$    /$$$$$$   /$$$$$$$
| $$  | $$ /$$__  $$ /$$__  $$ |____  $$|_  $$_/   /$$__  $$ /$$_____/
| $$  | $$| $$  \ $$| $$  | $$  /$$$$$$$  | $$    | $$$$$$$$|  $$$$$$
| $$  | $$| $$  | $$| $$  | $$ /$$__  $$  | $$ /$$| $$_____/ \____  $$
|  $$$$$$/| $$$$$$$/|  $$$$$$$|  $$$$$$$  |  $$$$/|  $$$$$$$ /$$$$$$$/
 \______/ | $$____/  \_______/ \_______/   \___/   \_______/|_______/
          | $$
          |__/
--->
# Updates
<sup>[(Back to README)](../README.md#configuration)</sup>

- [Updates - `Pipeline`](#updates---pipeline)
- [Updates - `Adding a tool`](#updates---adding-a-tool)
- [Updates - `Rollback & failures`](#updates---rollback--failures)

##
<h3 id="updates---pipeline">
   $\large\color{Goldenrod}{\textbf{Updates - Pipeline}}$
</h3>

Every input is pinned (base image digest, apt package versions, release binaries + sha256, npm / cargo / pipx versions, Rust toolchain, `lazy-lock.json`, Mason registry). Bots move the pins forward; CI proves every move.

```
Renovate (Mondays)        ──► PR "dep: update weekly toolbox updates"
                                   │  (.env.example, workflows, package.json)
checksums.yml             ──► recompute BIN *_SHA256 + README tools table,
                                   │  push to the PR branch
build.yml (PR)            ──► hadolint + gitleaks + build + smoke test
                                   │ green
auto-merge                ──► develop ──► build.yml :edge
                                   │
release.yml               ──► semantic-release (dep/fix -> patch, feat -> minor)
                                   │  tag vX.Y.Z + CHANGELOG.md + GitHub release
                                   ▼
build.yml (release)       ──► :X.Y.Z  :X.Y  :X  :latest

nvim-lock.yml (monthly)   ──► PR "dep: update neovim plugins and mason registry"
build.yml (weekly cron)   ──► last release + Debian security updates ──► :weekly
```

| Workflow | Trigger | Result |
|:---------|:--------|:-------|
| `build.yml` | PR to `develop` | build + test only |
| `build.yml` | push to `develop` | `:edge`, `:edge-<sha>` |
| `build.yml` | called by `release.yml` | `:X.Y.Z`, `:X.Y`, `:X`, `:latest` |
| `build.yml` | Mondays 04:00 UTC | `:weekly`, `:weekly-YYYYMMDD` |
| `release.yml` | push to `develop` | semantic release |
| `checksums.yml` | Renovate PR touching `.env.example` | checksum + README commit |
| `nvim-lock.yml` | 1st of month | Neovim lock PR |

Automerge rules ([`renovate.json`](../renovate.json)): patch / minor / digest are grouped in one weekly PR and merged automatically once CI is green. Majors and `kubectl` minors (cluster version skew) always wait for you.

##
<h3 id="updates---adding-a-tool">
   $\large\color{Goldenrod}{\textbf{Updates - Adding a tool}}$
</h3>

Pick the formula that matches the upstream distribution and copy an existing section:

| Method | Copy from | Renovate marker in `.env.example` |
|:-------|:----------|:----------------------------------|
| `GPG` (vendor apt repo) | `Core: Terraform (GPG)` | `datasource=deb depName=<pkg> registryUrl=<repo>?suite=<s>&components=<c>&binaryArch=amd64` |
| `BIN` (release binary) | `Core: K9S (BIN)` | `datasource=github-releases depName=<owner>/<repo>` |
| `APT` (Debian) | `Core: Miscellaneous (APT)` | none (follows the base image) |
| `NPM` / `PIPX` / `CARGO` | `Postflight: Python, npm, and Cargo packages` | `datasource=npm` / `pypi` / `crate` |

Checklist:

1. `build/Dockerfile` - new section: `ARG INSTALL_<TOOL>`, `<TOOL>_VERSION` (+ `<TOOL>_SHA256` for BIN), phases `Prepare` / `Fetching` / (`Verifying Checksum`) / `Installing` / `Section cleanup`.
2. `.env.example` - `INSTALL_<TOOL>=true`, `# renovate:` marker line, version (+ checksum).
3. `deployments/docker-compose.yml` - pass the new build args.
4. BIN only: add the tool to `.cicd/github/update-checksums.sh`, then run it.
5. `.cicd/tests/smoke.sh` - add a `check <tool> '<tool> --version'` line.
6. `.cicd/docs/update-readme.sh` - add the tool, then run it.
7. Tick it off in [`docs/roadmap.md`](./roadmap.md).

##
<h3 id="updates---rollback--failures">
   $\large\color{Goldenrod}{\textbf{Updates - Rollback & failures}}$
</h3>

**Rollback.** Published tags are never deleted:

```sh
make start TOOLBOX_VERSION=1.8.2      # one-off
# or pin it permanently in .env: TOOLBOX_VERSION=1.8.2
```

**When a build fails** (GitHub e-mails you):

| Symptom | Typical cause | Fix |
|:--------|:--------------|:----|
| `sha256sum: WARNING: 1 computed checksum did NOT match` | upstream re-uploaded an asset, or version bumped without checksum | `.cicd/github/update-checksums.sh` (it cross-checks upstream checksum files) |
| `apt-get install ... Version '...' for '...' was not found` | vendor removed an old version | bump the version in `.env.example` |
| `NO_PUBKEY` / `EXPKEYSIG` | vendor rotated its GPG key | nothing to pin - rebuild picks up the new key; check vendor notice |
| weekly build fails, release builds fine | Debian security update broke something | stay on `:latest`, investigate, pin package if needed |
| smoke test `plugins` / `mason` fails | plugin API change | revert the `nvim-lock` PR or fix `init.lua` |
