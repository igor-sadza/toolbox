#!/usr/bin/env bash
# Markdown backticks in printf formats are intended.
# shellcheck disable=SC2016

############################################################
# Copyright (c) 2026 Igor Sadza
# Released under the GPLv3 license
# ----------------------------------------------------------
#
# FILE: ./.cicd/docs/update-readme.sh
# DESC: Regenerate the tools table in README.md from .env.example
# USAGE: .cicd/docs/update-readme.sh [.env.example] [README.md]
#
############################################################

set -Eeuo pipefail

ENV_FILE="${1:-.env.example}"
README="${2:-README.md}"

START='<!-- tools:start -->'
END='<!-- tools:end -->'

# ===================================
# Tools: <Name> <Method> <VERSION key> <INSTALL key|-> <Upstream>
# ===================================

TOOLS=(
    "Neovim|BIN|NEOVIM_VERSION|INSTALL_NEOVIM|https://github.com/neovim/neovim"
    "Docker Engine|GPG|DOCKER_CE_VERSION|INSTALL_DOCKER|https://docs.docker.com/engine/"
    "Docker Buildx|GPG|DOCKER_BUILDX_VERSION|INSTALL_DOCKER|https://github.com/docker/buildx"
    "Docker Compose|GPG|DOCKER_COMPOSE_VERSION|INSTALL_DOCKER|https://github.com/docker/compose"
    "K9s|BIN|K9S_VERSION|INSTALL_K9S|https://github.com/derailed/k9s"
    "Helm|GPG|HELM_VERSION|INSTALL_HELM|https://helm.sh"
    "Kubectl|GPG|KUBECTL_VERSION|INSTALL_KUBECTL|https://kubernetes.io/docs/reference/kubectl/"
    "Terraform|GPG|TERRAFORM_VERSION|INSTALL_TERRAFORM|https://www.terraform.io"
    "Azure CLI|GPG|AZURE_CLI_VERSION|INSTALL_AZURE_CLI|https://learn.microsoft.com/cli/azure/"
    "Node.js|GPG|NODE_JS_VERSION|INSTALL_NODE_JS|https://nodejs.org"
    "Gomplate|BIN|GOMPLATE_VERSION|INSTALL_GOMPLATE|https://github.com/hairyhenderson/gomplate"
    "Act|BIN|ACT_VERSION|INSTALL_ACT|https://github.com/nektos/act"
    "Rust|RUSTUP|RUST_TOOLCHAIN|-|https://www.rust-lang.org"
    "tree-sitter CLI|CARGO|CARGO_TREE_SITTER_CLI|-|https://github.com/tree-sitter/tree-sitter"
    "OpenCode|NPM|NPM_OPENCODE_AI|INSTALL_NODE_JS|https://opencode.ai"
    "Codex CLI|NPM|NPM_CODEX|INSTALL_NODE_JS|https://github.com/openai/codex"
    "uv|PIPX|PIPX_UV|-|https://github.com/astral-sh/uv"
)

# ===================================
# Helpers
# ===================================

env_value() {
    grep -E "^$1=" "${ENV_FILE}" | tail -n1 | cut -d= -f2- | tr -d '"'
}

# ===================================
# Render table
# ===================================

table="$(
    echo "| Tool | Method | Version |"
    echo "|:-----|:------:|:--------|"
    for entry in "${TOOLS[@]}"; do
        IFS='|' read -r name method key install url <<<"${entry}"
        if [[ "${install}" != "-" && "$(env_value "${install}")" != "true" ]]; then
            continue
        fi
        printf '| [%s](%s) | `%s` | `%s` |\n' \
            "${name}" "${url}" "${method}" "$(env_value "${key}")"
    done
    printf '| Base image | `DOCKER` | `%s:%s` |\n' \
        "$(env_value DISTRIBUTION)" "$(env_value SUITE)"
)"

# ===================================
# Replace block between markers
# ===================================

grep -qF "${START}" "${README}" || {
    echo "markers not found in ${README}" >&2
    exit 1
}

TABLE="${table}" awk \
    -v start="${START}" \
    -v end="${END}" '
    $0 == start { print; print ENVIRON["TABLE"]; skip = 1; next }
    $0 == end   { skip = 0 }
    !skip       { print }
' "${README}" > "${README}.tmp"

mv "${README}.tmp" "${README}"
