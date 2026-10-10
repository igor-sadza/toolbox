# Roadmap

Proposed next iterations are listed below; they are not scheduled commitments. Current boundaries and verification limits belong in the [runtime](reference/runtime.md), [clipboard](reference/terminal-clipboard.md), and [automation](reference/automation.md) references. Tool candidates, `.env` keys, download choices, and Renovate datasources below are proposals, not configured installation. Follow [image maintenance](playbooks/image-maintenance.md#adding-a-tool) if adopting a tool.

Legend - method: `GPG` vendor apt repo · `BIN` release binary + sha256 · `APT` Debian package · `PIPX` / `NPM` / `CARGO` / `GO` language package manager.

## Cloud

| | Tool | Method | Source | `.env` keys | Renovate datasource |
|:-:|:-----|:------:|:-------|:------------|:--------------------|
| [ ] | aws-cli v2 | `BIN` | `awscli.amazonaws.com/awscli-exe-linux-x86_64-<v>.zip` (+ GPG sig) | `INSTALL_AWS_CLI`, `AWS_CLI_VERSION`, `AWS_CLI_SHA256` | `github-tags aws/aws-cli` |
| [ ] | gcloud | `GPG` | `packages.cloud.google.com/apt` | `INSTALL_GCLOUD`, `GCLOUD_VERSION` | `deb` |
| [ ] | oci-cli | `PIPX` | PyPI `oci-cli` | `PIPX_OCI_CLI` | `pypi` |

## Lint and Quality

| | Tool | Method | Source | `.env` keys | Renovate datasource |
|:-:|:-----|:------:|:-------|:------------|:--------------------|
| [ ] | hadolint | `BIN` | `hadolint/hadolint` releases | `INSTALL_HADOLINT`, `HADOLINT_VERSION`, `HADOLINT_SHA256` | `github-releases` |
| [ ] | shellcheck | `APT` | Debian `shellcheck` | - | - |
| [ ] | shfmt | `BIN` | `mvdan/sh` releases | `INSTALL_SHFMT`, `SHFMT_VERSION`, `SHFMT_SHA256` | `github-releases` |
| [ ] | actionlint | `BIN` | `rhysd/actionlint` releases | `INSTALL_ACTIONLINT`, `ACTIONLINT_VERSION`, `ACTIONLINT_SHA256` | `github-releases` |
| [ ] | yamllint | `PIPX` | PyPI `yamllint` | `PIPX_YAMLLINT` | `pypi` |
| [ ] | tflint | `BIN` | `terraform-linters/tflint` releases | `INSTALL_TFLINT`, `TFLINT_VERSION`, `TFLINT_SHA256` | `github-releases` |
| [ ] | pre-commit | `PIPX` | PyPI `pre-commit` | `PIPX_PRE_COMMIT` | `pypi` |
| [ ] | markdownlint-cli2 | `NPM` | npm `markdownlint-cli2` | `NPM_MARKDOWNLINT_CLI2` | `npm` |

ShellCheck and shfmt must be available on the normal CLI `PATH`, not only through editor-managed tools. Mason already requests shfmt and tflint; editor provisioning does not establish ordinary-shell availability. Verify CLI commands from an ordinary Toolbox shell.

## Kubernetes

| | Tool | Method | Source | `.env` keys | Renovate datasource |
|:-:|:-----|:------:|:-------|:------------|:--------------------|
| [ ] | kubectx / kubens | `BIN` | `ahmetb/kubectx` releases | `INSTALL_KUBECTX`, `KUBECTX_VERSION`, `KUBECTX_SHA256` | `github-releases` |
| [ ] | stern | `BIN` | `stern/stern` releases | `INSTALL_STERN`, `STERN_VERSION`, `STERN_SHA256` | `github-releases` |
| [ ] | kustomize | `BIN` | `kubernetes-sigs/kustomize` releases | `INSTALL_KUSTOMIZE`, ... | `github-releases` |
| [ ] | helmfile | `BIN` | `helmfile/helmfile` releases | `INSTALL_HELMFILE`, ... | `github-releases` |
| [ ] | kind / k3d | `BIN` | `kubernetes-sigs/kind`, `k3d-io/k3d` | `INSTALL_KIND`, ... | `github-releases` |
| [ ] | argocd | `BIN` | `argoproj/argo-cd` releases | `INSTALL_ARGOCD`, ... | `github-releases` |
| [ ] | flux | `BIN` | `fluxcd/flux2` releases | `INSTALL_FLUX`, ... | `github-releases` |
| [ ] | velero | `BIN` | `vmware-tanzu/velero` releases | `INSTALL_VELERO`, ... | `github-releases` |
| [ ] | krew | `BIN` | `kubernetes-sigs/krew` releases | `INSTALL_KREW`, ... | `github-releases` |

## Infrastructure as Code

| | Tool | Method | Source | `.env` keys | Renovate datasource |
|:-:|:-----|:------:|:-------|:------------|:--------------------|
| [ ] | opentofu | `GPG` | `packages.opentofu.org` | `INSTALL_OPENTOFU`, `OPENTOFU_VERSION` | `deb` |
| [ ] | terragrunt | `BIN` | `gruntwork-io/terragrunt` releases | `INSTALL_TERRAGRUNT`, ... | `github-releases` |
| [ ] | packer | `GPG` | HashiCorp apt (same repo as terraform) | `INSTALL_PACKER`, `PACKER_VERSION` | `deb` |
| [ ] | vault | `GPG` | HashiCorp apt (same repo as terraform) | `INSTALL_VAULT`, `VAULT_VERSION` | `deb` |
| [ ] | terraform-docs | `BIN` | `terraform-docs/terraform-docs` releases | `INSTALL_TERRAFORM_DOCS`, ... | `github-releases` |

## Secrets and Supply Chain

| | Tool | Method | Source | `.env` keys | Renovate datasource |
|:-:|:-----|:------:|:-------|:------------|:--------------------|
| [ ] | sops | `BIN` | `getsops/sops` releases | `INSTALL_SOPS`, ... | `github-releases` |
| [ ] | age | `BIN` | `FiloSottile/age` releases | `INSTALL_AGE`, ... | `github-releases` |
| [ ] | cosign | `BIN` | `sigstore/cosign` releases | `INSTALL_COSIGN`, ... | `github-releases` |
| [ ] | trivy | `GPG` | `aquasecurity.github.io/trivy-repo` | `INSTALL_TRIVY`, `TRIVY_VERSION` | `deb` |
| [ ] | syft / grype | `BIN` | `anchore/syft`, `anchore/grype` releases | `INSTALL_SYFT`, ... | `github-releases` |
| [ ] | crane / skopeo | `BIN` / `APT` | `google/go-containerregistry` / Debian | `INSTALL_CRANE`, ... | `github-releases` |

## Git

| | Tool | Method | Source | `.env` keys | Renovate datasource |
|:-:|:-----|:------:|:-------|:------------|:--------------------|
| [ ] | gh | `GPG` | `cli.github.com/packages` | `INSTALL_GH`, `GH_VERSION` | `deb` |
| [ ] | glab | `BIN` | `gitlab.com/gitlab-org/cli` releases | `INSTALL_GLAB`, ... | `gitlab-releases` |
| [ ] | lazygit | `BIN` | `jesseduffield/lazygit` releases | `INSTALL_LAZYGIT`, ... | `github-releases` |
| [ ] | git-delta | `BIN` | `dandavison/delta` releases | `INSTALL_DELTA`, ... | `github-releases` |

## Containers

| | Tool | Method | Source | `.env` keys | Renovate datasource |
|:-:|:-----|:------:|:-------|:------------|:--------------------|
| [ ] | lazydocker | `BIN` | `jesseduffield/lazydocker` releases | `INSTALL_LAZYDOCKER`, ... | `github-releases` |
| [ ] | dive | `BIN` | `wagoodman/dive` releases | `INSTALL_DIVE`, ... | `github-releases` |

## Shell Quality of Life

| | Tool | Method | Source | `.env` keys | Renovate datasource |
|:-:|:-----|:------:|:-------|:------------|:--------------------|
| [ ] | fzf, bat, eza, zoxide, direnv, btop, httpie | `APT` | Debian | - | - |
| [ ] | yq v4 | `BIN` | `mikefarah/yq` releases | `INSTALL_YQ`, ... | `github-releases` |
| [ ] | curl (explicit core provisioning) | `APT` | Debian | - | - |
| [ ] | jq, rsync | `APT` | Debian | - | - |
| [ ] | procps, psmisc, lsof, strace | `APT` | Debian | - | - |
| [ ] | zip, unzip, xz-utils, bzip2, zstd, openssl | `APT` | Debian | - | - |
| [ ] | htop, entr, hyperfine | `APT` | Debian | - | - |
| [ ] | man-db and manpages | `APT` | Debian | - | - |
| [ ] | tcpdump | `APT` | Debian | - | - |

Keep packet capture optional. Check existing provisioning sections before adding packages to avoid duplicate installation.

Make core `curl` availability independent of optional tool sections; see [current core package provisioning](reference/tools.md#core-package-availability).

The yq v4 installation must pin the version, select downloads for the target architecture, and verify checksums. This requirement does not establish multi-architecture support for the rest of the image.

## Corporate Networks

- [ ] Proxy inside the running container (compose `environment:`, upper + lowercase, from `.env`)
- [ ] apt proxy config written by the entrypoint at runtime (removed when empty)
- [ ] Corporate root CA (TLS inspection): `update-ca-certificates`, `NODE_EXTRA_CA_CERTS`, `REQUESTS_CA_BUNDLE`, `SSL_CERT_FILE`, `CARGO_HTTP_CAINFO`, git `http.sslCAInfo`; CA as BuildKit secret for local builds
- [ ] `~/.docker/config.json` `proxies` guidance for containers started from the toolbox
- [ ] `NO_PROXY` guidance (internal domains, Kubernetes API endpoints, CIDR support per tool)

## Configuration and Clipboard

- [ ] Decide whether to expose `fd` alongside Debian's `fdfind`.
- [ ] Decide whether direct `nvim` and `vi` should select the same bundled configuration; see [entrypoint differences](reference/neovim-integration.md#entrypoints-and-persistence).
- [ ] Resolve [OpenCode executable, child configuration, and credential-forwarding gaps](reference/opencode.md#launch-and-configuration-boundaries), then verify authorized MCP reads.
- [ ] Review Git pager behavior for SSH use.
- [ ] Document diagnostic-tool permission limits; do not weaken container security just to enable `strace` or packet capture.
- [ ] Verify effective tmux, OpenCode, and Neovim clipboard behavior; see [terminal and clipboard](reference/terminal-clipboard.md).
- [ ] Design an opt-in authenticated PNG clipboard bridge for local Linux, SSH, and WSL use; preserve the security, platform, fallback, and acceptance criteria in the [image bridge proposal](notes/clipboard-image-bridge.md).

## Tooling and Smoke Checks

- [ ] Add smoke checks for promised core commands and archive creation/extraction.
- [ ] Add functional jq and yq transformation tests if those tools are adopted.
- [ ] Evaluate whether package and manual-page retention meets the image's size and usability goals.
