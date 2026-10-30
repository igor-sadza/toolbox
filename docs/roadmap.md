# Roadmap

Proposed next iterations are listed below; they are not scheduled commitments. Current boundaries and verification limits belong in the [runtime](reference/runtime.md), [clipboard](reference/terminal-clipboard.md), and [automation](reference/automation.md) references.

Legend - method: `GPG` vendor apt repo · `BIN` release binary + sha256 · `APT` Debian package.

## Cloud

| Tool | Method |
|:-----|:------:|
| [ ] aws-cli v2 | `BIN` |
| [ ] gcloud | `GPG` |
| [ ] oci-cli | `PIPX` |

## Lint and Quality

| Tool | Method |
|:-----|:------:|
| [ ] hadolint | `BIN` |
| [ ] shellcheck | `APT` |
| [ ] shfmt | `BIN` |
| [ ] actionlint | `BIN` |
| [ ] yamllint | `PIPX` |
| [ ] tflint | `BIN` |
| [ ] pre-commit | `PIPX` |
| [ ] markdownlint-cli2 | `NPM` |

ShellCheck and shfmt must be available on the normal CLI `PATH`, not only through editor-managed tools. Verify CLI commands from an ordinary Toolbox shell.

## Kubernetes

| Tool | Method |
|:-----|:------:|
| [ ] kubectx / kubens | `BIN` |
| [ ] stern | `BIN` |
| [ ] kustomize | `BIN` |
| [ ] helmfile | `BIN` |
| [ ] kind / k3d | `BIN` |
| [ ] argocd | `BIN` |
| [ ] flux | `BIN` |
| [ ] velero | `BIN` |
| [ ] krew | `BIN` |

## Infrastructure as Code

| Tool | Method |
|:-----|:------:|
| [ ] opentofu | `GPG` |
| [ ] terragrunt | `BIN` |
| [ ] packer | `GPG` |
| [ ] vault | `GPG` |
| [ ] terraform-docs | `BIN` |

## Secrets and Supply Chain

| Tool | Method |
|:-----|:------:|
| [ ] sops | `BIN` |
| [ ] age | `BIN` |
| [ ] cosign | `BIN` |
| [ ] trivy | `GPG` |
| [ ] syft / grype | `BIN` |
| [ ] crane / skopeo | `BIN` / `APT` |

## Git

| Tool | Method |
|:-----|:------:|
| [ ] gh | `GPG` |
| [ ] glab | `BIN` |
| [ ] lazygit | `BIN` |
| [ ] git-delta | `BIN` |

## Containers

| Tool | Method |
|:-----|:------:|
| [ ] lazydocker | `BIN` |
| [ ] dive | `BIN` |

## Shell Quality of Life

| Tool | Method |
|:-----|:------:|
| [ ] fzf, bat, eza, zoxide, direnv, btop, httpie | `APT` |
| [ ] yq v4 | `BIN` |
| [ ] curl (explicit core provisioning) | `APT` |
| [ ] jq, rsync | `APT` |
| [ ] procps, psmisc, lsof, strace | `APT` |
| [ ] zip, unzip, xz-utils, bzip2, zstd, openssl | `APT` |
| [ ] htop, entr, hyperfine | `APT` |
| [ ] man-db and manpages | `APT` |
| [ ] tcpdump | `APT` |

Keep packet capture optional. Check existing provisioning sections before adding packages to avoid duplicate installation.

Make core `curl` availability independent of optional tool sections; see [current core package provisioning](reference/tools.md#core-package-availability).

## Configuration and Clipboard

- [ ] Decide whether to expose `fd` alongside Debian's `fdfind`.
- [ ] Decide whether direct `nvim` and `vi` should select the same bundled configuration; see [entrypoint differences](reference/neovim-integration.md#entrypoints-and-persistence).
- [ ] Resolve [OpenCode executable, child configuration, and credential-forwarding gaps](reference/opencode.md#launch-and-configuration), then verify authorized MCP reads.
- [ ] Review Git pager behavior for SSH use.
- [ ] Document diagnostic-tool permission limits; do not weaken container security just to enable `strace` or packet capture.
- [ ] Verify effective tmux, OpenCode, and Neovim clipboard behavior; see [terminal and clipboard](reference/terminal-clipboard.md).
- [ ] Design an opt-in authenticated PNG clipboard bridge for local Linux, SSH, and WSL use; preserve the security, platform, fallback, and acceptance criteria in the [image bridge proposal](notes/clipboard-image-bridge.md).

## Corporate Networks

- [ ] Proxy inside the running container (compose `environment:`, upper + lowercase, from `.env`)
- [ ] apt proxy config written by the entrypoint at runtime (removed when empty)
- [ ] Corporate root CA (TLS inspection): `update-ca-certificates`, `NODE_EXTRA_CA_CERTS`, `REQUESTS_CA_BUNDLE`, `SSL_CERT_FILE`, `CARGO_HTTP_CAINFO`, git `http.sslCAInfo`; CA as BuildKit secret for local builds
- [ ] `~/.docker/config.json` `proxies` guidance for containers started from the toolbox
- [ ] `NO_PROXY` guidance (internal domains, Kubernetes API endpoints, CIDR support per tool)

## Tooling and Smoke Checks

- [ ] Add smoke checks for promised core commands and archive creation/extraction.
- [ ] Add functional jq and yq transformation tests if those tools are adopted.
- [ ] Evaluate whether package and manual-page retention meets the image's size and usability goals.
