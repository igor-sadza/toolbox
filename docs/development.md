<!---
############################################################
# Copyright (c) 2026 Igor Sadza
# Released under the GPLv3 license
# ----------------------------------------------------------
#
# FILE: ./docs/development.md
# DESC: Development - local build/test, releases, GitHub setup
#
############################################################
--->
<!---
 /$$$$$$$
| $$__  $$
| $$  \ $$  /$$$$$$  /$$    /$$
| $$  | $$ /$$__  $$|  $$  /$$/
| $$  | $$| $$$$$$$$ \  $$/$$/
| $$  | $$| $$_____/  \  $$$/
| $$$$$$$/|  $$$$$$$   \  $/
|_______/  \_______/    \_/
--->
# Development
<sup>[(Back to README)](../README.md#configuration)</sup>

- [Development - `Local build & test`](#development---local-build--test)
- [Development - `Releases`](#development---releases)
- [Development - `GitHub setup`](#development---github-setup)

##
<h3 id="development---local-build--test">
   $\large\color{Goldenrod}{\textbf{Development - Local build & test}}$
</h3>

```sh
make build                              # docker compose build (tag: TOOLBOX_IMAGE:TOOLBOX_VERSION)
make test IMAGE=ghcr.io/igor-sadza/toolbox:latest
make start-local                        # build + run the local image
make cicd                               # run build.yml locally with act (pull_request: never publishes)
```

Lint exactly like CI:

```sh
docker run --rm -i hadolint/hadolint:v2.15.1 hadolint \
  --ignore DL3008 --ignore DL4006 --ignore SC2086 \
  --ignore DL3003 --ignore SC1008 --ignore SC2174 - < build/Dockerfile
docker run --rm -v "$PWD:/mnt" -w /mnt koalaman/shellcheck:stable -s bash \
  toolbox build/rootfs/entrypoint.sh build/rootfs/usr/bin/toolbox.sh .cicd/*/*.sh
docker run --rm -v "$PWD:/repo" -w /repo --entrypoint /usr/local/bin/actionlint rhysd/actionlint:1.7.12
```

Helper scripts:

| Script | Purpose |
|:-------|:--------|
| `.cicd/github/build-args.sh` | `.env.example` -> `KEY=VALUE` build args (CI) |
| `.cicd/github/update-checksums.sh` | refresh BIN `*_SHA256` (cross-checked upstream) |
| `.cicd/docs/update-readme.sh` | regenerate the README tools table |
| `.cicd/tests/smoke.sh <image>` | tools, Neovim, session mapping, image hygiene |

##
<h3 id="development---releases">
   $\large\color{Goldenrod}{\textbf{Development - Releases}}$
</h3>

Releases are created by [semantic-release](../.releaserc.yml) on every push to `develop`, based on commit types:

| Type | Release | Used for |
|:-----|:--------|:---------|
| `feat:` | minor | new tool / feature |
| `fix:`, `dep:`, `build:`, `perf:`, `docs:`, `style:`, `revert:` | patch | fixes, dependency bumps (Renovate uses `dep:`) |
| `cicd:`, `ci:`, `chore:`, `refactor:`, `test:` | none | pipeline / housekeeping |
| `BREAKING CHANGE:` footer or `!` | major | incompatible changes |

The release job tags `vX.Y.Z`, commits `CHANGELOG.md` (`[skip ci]`), creates the GitHub release and calls `build.yml` to publish `:X.Y.Z`, `:X.Y`, `:X`, `:latest`.

##
<h3 id="development---github-setup">
   $\large\color{Goldenrod}{\textbf{Development - GitHub setup}}$
</h3>

One-time setup of the repository (`igor-sadza/toolbox`):

| Item | Value |
|:-----|:------|
| Secret `WORKFLOW_TOKEN` | PAT of `igor-sadza` with `write:packages` + `repo` (GHCR push, releases, pushes that must trigger workflows) |
| Secret `SEMANTIC_RELEASE_TOKEN` | PAT allowed to push to `develop` (changelog commit + tags); needs bypass if `develop` is protected |
| Variable `GHCR_USERNAME` | `igor-sadza` (optional, it is the default) |
| Renovate | install the [Renovate GitHub App](https://github.com/apps/renovate) for the repository |
| Settings -> General | enable **Allow auto-merge** |
| Branch protection `develop` | require status check **Build Docker** |
| GHCR package | visibility public (or grant pull access), keep all versions |

> [!NOTE]
> After the repository lives under `igor-sadza`, GHCR login could use the built-in `GITHUB_TOKEN` (`username: ${{ github.actor }}`) instead of the PAT; the PAT is still needed for pushes that must trigger other workflows (checksums, nvim-lock, release).
