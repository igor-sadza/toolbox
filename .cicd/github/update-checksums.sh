#!/usr/bin/env bash

############################################################
# Copyright (c) 2026 Igor Sadza
# Released under the GPLv3 license
# ----------------------------------------------------------
#
# FILE: ./.cicd/github/update-checksums.sh
# DESC: Refresh *_SHA256 values of BIN tools in .env.example
# USAGE: .cicd/github/update-checksums.sh [.env.example]
#
############################################################

set -Eeuo pipefail

ENV_FILE="${1:-.env.example}"

# ===================================
# BIN tools
# : <PREFIX> <asset URL> [upstream checksum file URL]
# : {v} = version ({V} = version without leading 'v')
# : keep in sync with the (BIN) sections in build/Dockerfile
# ===================================

GH="https://github.com"

TOOLS=(
    "NEOVIM   ${GH}/neovim/neovim/releases/download/{v}/nvim-linux-x86_64.tar.gz"
    "K9S      ${GH}/derailed/k9s/releases/download/{v}/k9s_Linux_amd64.tar.gz            ${GH}/derailed/k9s/releases/download/{v}/checksums.sha256"
    "GOMPLATE ${GH}/hairyhenderson/gomplate/releases/download/{v}/gomplate_linux-amd64    ${GH}/hairyhenderson/gomplate/releases/download/{v}/checksums-{v}_sha256.txt"
    "ACT      ${GH}/nektos/act/releases/download/{v}/act_Linux_x86_64.tar.gz              ${GH}/nektos/act/releases/download/{v}/checksums.txt"
)

# ===================================
# Helpers
# ===================================

env_value() {
    grep -E "^$1=" "${ENV_FILE}" | tail -n1 | cut -d= -f2- | tr -d '"'
}

# ===================================
# Execute
# ===================================

changed=0

for entry in "${TOOLS[@]}"; do
    read -r prefix template sums_template <<<"${entry}"

    version="$(env_value "${prefix}_VERSION")"
    current="$(env_value "${prefix}_SHA256")"
    url="${template//\{v\}/${version}}"

    sha="$(curl -fsSL --retry 3 "${url}" | sha256sum | cut -d' ' -f1)"

    # Cross-check with the checksum file published upstream (if any).
    if [[ -n "${sums_template:-}" ]]; then
        sums_url="${sums_template//\{v\}/${version}}"
        asset="${url##*/}"

        if ! curl -fsSL --retry 3 "${sums_url}" |
            grep -E "(^|[[:space:]/*])${asset}\$" |
            grep -qi "^${sha}"; then
            printf '  [FAIL] %-10s %-10s %s\n' "${prefix}" "${version}" "does not match ${sums_url}"
            exit 1
        fi
    fi

    if [[ "${sha}" != "${current}" ]]; then
        sed -i "s|^${prefix}_SHA256=.*|${prefix}_SHA256=${sha}|" "${ENV_FILE}"
        printf '  [UPD ] %-10s %-10s %s\n' "${prefix}" "${version}" "${sha}"
        changed=$((changed + 1))
    else
        printf '  [ OK ] %-10s %-10s %s\n' "${prefix}" "${version}" "${sha}"
    fi
done

echo "  ${changed} checksum(s) updated"
