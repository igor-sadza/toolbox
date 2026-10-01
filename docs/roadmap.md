<!---
############################################################
# Copyright (c) 2026 Igor Sadza
# Released under the GPLv3 license
# ----------------------------------------------------------
#
# FILE: ./docs/roadmap.md
# DESC: Roadmap - next CLI tools & features (TODO list)
#
############################################################
--->
<!---
 /$$$$$$$                            /$$
| $$__  $$                          | $$
| $$  \ $$  /$$$$$$   /$$$$$$   /$$$$$$$ /$$$$$$/$$$$   /$$$$$$   /$$$$$$
| $$$$$$$/ /$$__  $$ |____  $$ /$$__  $$| $$_  $$_  $$ |____  $$ /$$__  $$
| $$__  $$| $$  \ $$  /$$$$$$$| $$  | $$| $$ \ $$ \ $$  /$$$$$$$| $$  \ $$
| $$  \ $$| $$  | $$ /$$__  $$| $$  | $$| $$ | $$ | $$ /$$__  $$| $$  | $$
| $$  | $$|  $$$$$$/|  $$$$$$$|  $$$$$$$| $$ | $$ | $$|  $$$$$$$| $$$$$$$/
|__/  |__/ \______/  \_______/ \_______/|__/ |__/ |__/ \_______/| $$____/
                                                                | $$
                                                                |__/
--->
# Roadmap
<sup>[(Back to README)](../README.md#miscellaneous)</sup>

<h3 id="roadmap---todo-list">
   $\large\color{Goldenrod}{\textbf{Roadmap - TODO List}}$
</h3>

Next iterations. Every tool is added with the **same section formula** as the existing ones - see [Updates - Adding a tool](./updates.md#updates---adding-a-tool).

Legend - method: `GPG` vendor apt repo · `BIN` release binary + sha256 · `APT` Debian package · `PIPX` / `NPM` / `CARGO` / `GO` language package manager.

##
<h3 id="cloud">
   $\large\color{Goldenrod}{\textbf{Cloud}}$
</h3>

| | Tool | Method | Source | `.env` keys | Renovate datasource |
|:-:|:-----|:------:|:-------|:------------|:--------------------|
| [ ] | aws-cli v2 | `BIN` | `awscli.amazonaws.com/awscli-exe-linux-x86_64-<v>.zip` (+ GPG sig) | `INSTALL_AWS_CLI`, `AWS_CLI_VERSION`, `AWS_CLI_SHA256` | `github-tags aws/aws-cli` |
| [ ] | gcloud | `GPG` | `packages.cloud.google.com/apt` | `INSTALL_GCLOUD`, `GCLOUD_VERSION` | `deb` |
| [ ] | oci-cli | `PIPX` | PyPI `oci-cli` | `PIPX_OCI_CLI` | `pypi` |

##
<h3 id="lint">
   $\large\color{Goldenrod}{\textbf{Lint & quality}}$
</h3>

| | Tool | Method | Source | `.env` keys | Renovate datasource |
|:-:|:-----|:------:|:-------|:------------|:--------------------|
| [ ] | hadolint | `BIN` | `hadolint/hadolint` releases | `INSTALL_HADOLINT`, `HADOLINT_VERSION`, `HADOLINT_SHA256` | `github-releases` |
| [ ] | shellcheck | `APT` | Debian `shellcheck` | - | - |
| [ ] | actionlint | `BIN` | `rhysd/actionlint` releases | `INSTALL_ACTIONLINT`, `ACTIONLINT_VERSION`, `ACTIONLINT_SHA256` | `github-releases` |
| [ ] | yamllint | `PIPX` | PyPI `yamllint` | `PIPX_YAMLLINT` | `pypi` |
| [ ] | tflint | `BIN` | `terraform-linters/tflint` releases | `INSTALL_TFLINT`, `TFLINT_VERSION`, `TFLINT_SHA256` | `github-releases` |
| [ ] | pre-commit | `PIPX` | PyPI `pre-commit` | `PIPX_PRE_COMMIT` | `pypi` |
| [ ] | markdownlint-cli2 | `NPM` | npm `markdownlint-cli2` | `NPM_MARKDOWNLINT_CLI2` | `npm` |

##
<h3 id="kubernetes">
   $\large\color{Goldenrod}{\textbf{Kubernetes}}$
</h3>

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

##
<h3 id="iac">
   $\large\color{Goldenrod}{\textbf{IaC}}$
</h3>

| | Tool | Method | Source | `.env` keys | Renovate datasource |
|:-:|:-----|:------:|:-------|:------------|:--------------------|
| [ ] | opentofu | `GPG` | `packages.opentofu.org` | `INSTALL_OPENTOFU`, `OPENTOFU_VERSION` | `deb` |
| [ ] | terragrunt | `BIN` | `gruntwork-io/terragrunt` releases | `INSTALL_TERRAGRUNT`, ... | `github-releases` |
| [ ] | packer | `GPG` | HashiCorp apt (same repo as terraform) | `INSTALL_PACKER`, `PACKER_VERSION` | `deb` |
| [ ] | vault | `GPG` | HashiCorp apt (same repo as terraform) | `INSTALL_VAULT`, `VAULT_VERSION` | `deb` |
| [ ] | terraform-docs | `BIN` | `terraform-docs/terraform-docs` releases | `INSTALL_TERRAFORM_DOCS`, ... | `github-releases` |

##
<h3 id="security">
   $\large\color{Goldenrod}{\textbf{Secrets & supply chain}}$
</h3>

| | Tool | Method | Source | `.env` keys | Renovate datasource |
|:-:|:-----|:------:|:-------|:------------|:--------------------|
| [ ] | sops | `BIN` | `getsops/sops` releases | `INSTALL_SOPS`, ... | `github-releases` |
| [ ] | age | `BIN` | `FiloSottile/age` releases | `INSTALL_AGE`, ... | `github-releases` |
| [ ] | cosign | `BIN` | `sigstore/cosign` releases | `INSTALL_COSIGN`, ... | `github-releases` |
| [ ] | trivy | `GPG` | `aquasecurity.github.io/trivy-repo` | `INSTALL_TRIVY`, `TRIVY_VERSION` | `deb` |
| [ ] | syft / grype | `BIN` | `anchore/syft`, `anchore/grype` releases | `INSTALL_SYFT`, ... | `github-releases` |
| [ ] | crane / skopeo | `BIN` / `APT` | `google/go-containerregistry` / Debian | `INSTALL_CRANE`, ... | `github-releases` |

##
<h3 id="git">
   $\large\color{Goldenrod}{\textbf{Git}}$
</h3>

| | Tool | Method | Source | `.env` keys | Renovate datasource |
|:-:|:-----|:------:|:-------|:------------|:--------------------|
| [ ] | gh | `GPG` | `cli.github.com/packages` | `INSTALL_GH`, `GH_VERSION` | `deb` |
| [ ] | glab | `BIN` | `gitlab.com/gitlab-org/cli` releases | `INSTALL_GLAB`, ... | `gitlab-releases` |
| [ ] | lazygit | `BIN` | `jesseduffield/lazygit` releases | `INSTALL_LAZYGIT`, ... | `github-releases` |
| [ ] | git-delta | `BIN` | `dandavison/delta` releases | `INSTALL_DELTA`, ... | `github-releases` |

##
<h3 id="containers">
   $\large\color{Goldenrod}{\textbf{Containers}}$
</h3>

| | Tool | Method | Source | `.env` keys | Renovate datasource |
|:-:|:-----|:------:|:-------|:------------|:--------------------|
| [ ] | lazydocker | `BIN` | `jesseduffield/lazydocker` releases | `INSTALL_LAZYDOCKER`, ... | `github-releases` |
| [ ] | dive | `BIN` | `wagoodman/dive` releases | `INSTALL_DIVE`, ... | `github-releases` |

##
<h3 id="shell">
   $\large\color{Goldenrod}{\textbf{Shell quality of life}}$
</h3>

| | Tool | Method | Source | `.env` keys | Renovate datasource |
|:-:|:-----|:------:|:-------|:------------|:--------------------|
| [ ] | fzf, bat, eza, zoxide, direnv, btop, httpie | `APT` | Debian | - | - |
| [ ] | yq | `BIN` | `mikefarah/yq` releases | `INSTALL_YQ`, ... | `github-releases` |

##
<h3 id="corporate">
   $\large\color{Goldenrod}{\textbf{Corporate}}$
</h3>

- [ ] Proxy inside the running container (compose `environment:`, upper + lowercase, from `.env`)
- [ ] apt proxy config written by the entrypoint at runtime (removed when empty)
- [ ] Corporate root CA (TLS inspection): `update-ca-certificates`, `NODE_EXTRA_CA_CERTS`, `REQUESTS_CA_BUNDLE`, `SSL_CERT_FILE`, `CARGO_HTTP_CAINFO`, git `http.sslCAInfo`; CA as BuildKit secret for local builds
- [ ] `~/.docker/config.json` `proxies` guidance for containers started from the toolbox
- [ ] `NO_PROXY` guidance (internal domains, Kubernetes API endpoints, CIDR support per tool)

##
<h3 id="done">
   $\large\color{Goldenrod}{\textbf{Done}}$
</h3>

- [x] FUSE: `fuse3`, `sshfs`, `rclone` (+ `/dev/fuse`)
- [x] NFS: daemon-mounted volumes + ad-hoc mounts
- [x] Reproducible build: every input pinned, BIN checksums, `lazy-lock.json`, Mason registry
- [x] Automation: Renovate, checksums, nvim-lock, weekly rebuild, semantic release -> GHCR
