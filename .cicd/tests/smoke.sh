#!/usr/bin/env bash
# Commands are evaluated inside the image (single quotes intended).
# shellcheck disable=SC2016

############################################################
# Copyright (c) 2026 Igor Sadza
# Released under the GPLv3 license
# ----------------------------------------------------------
#
# FILE: ./.cicd/tests/smoke.sh
# DESC: Image smoke test (tools, neovim, secrets in history)
# USAGE: .cicd/tests/smoke.sh <image>
#
############################################################

set -Eeuo pipefail

IMAGE="${1:?usage: $0 <image>}"

failures=0

# ===================================
# Helpers
# ===================================

section() {
    printf '\n------------------------\n > %s\n------------------------\n' "$1"
}

in_image() {
    docker run \
        --rm \
        --entrypoint bash \
        "${IMAGE}" \
        -c "$1"
}

check() {
    local name="$1"
    local cmd="$2"
    local output

    if output="$(in_image "${cmd}" 2>&1)"; then
        printf '  [ OK ] %-14s %s\n' "${name}" "$(head -n1 <<<"${output}")"
    else
        printf '  [FAIL] %-14s %s\n' "${name}" "$(tail -n3 <<<"${output}")"
        failures=$((failures + 1))
    fi
}

# ===================================
# Tools
# ===================================

section "Tools"

check neovim     'vi --version'
check docker     'docker --version && docker compose version && docker buildx version'
check k9s        'k9s version --short'
check helm       'helm version --short'
check kubectl    'kubectl version --client'
check terraform  'terraform version'
check azure-cli  'az version --output tsv'
check node       'node --version && npm --version'
check gomplate   'gomplate --version'
check act        'act --version'
check opencode   'opencode --version'
check codex      'codex --version'
check uv         'uv --version'
check rust       'rustc --version && cargo --version'
check tree-sitter 'tree-sitter --version'
check go         'go version'
check git        'git --version'
check tmux       'tmux -V'

# ===================================
# Neovim
# ===================================

section "Neovim"

check plugins \
    'vi --headless "+lua for _, m in ipairs({\"lazy\", \"telescope\", \"lualine\", \"cmp\", \"conform\", \"mason\"}) do require(m) end" +qa'

check lockfile \
    'test -s "${TOOLBOX_CONFIG}/nvim/lazy-lock.json"'

check mason \
    'n="$(find "${TOOLBOX_DATA}/nvim/mason/bin" -mindepth 1 | wc -l)"; echo "${n} tools"; test "${n}" -ge 15'

# ===================================
# Session (toolbox.sh user mapping)
# ===================================

section "Session"

cid="$(docker run --detach --rm "${IMAGE}")"
trap 'docker rm -f "${cid}" >/dev/null 2>&1 || true' EXIT

session() {
    docker exec \
        --user 0:0 \
        --env TOOLBOX_UID=4242 \
        --env TOOLBOX_GID=4343 \
        --env TOOLBOX_GROUPS=4343,4444 \
        --env TOOLBOX_USER=smoke \
        --env TOOLBOX_HOME=/tmp \
        --env TOOLBOX_CWD=/tmp \
        "${cid}" \
        /usr/bin/toolbox.sh "$@"
}

check_session() {
    local name="$1"
    local expected="$2"
    shift 2
    local output

    output="$(session "$@" 2>&1 || true)"

    if [[ "${output}" == *"${expected}"* ]]; then
        printf '  [ OK ] %-14s %s\n' "${name}" "${expected}"
    else
        printf '  [FAIL] %-14s expected "%s", got "%s"\n' "${name}" "${expected}" "${output}"
        failures=$((failures + 1))
    fi
}

check_session uid      "4242"  id -u
check_session gid      "4343"  id -g
check_session groups   "29999" id -G
check_session umask    "0002"  bash -c umask
check_session cwd      "/tmp"  pwd
check_session sudo     "0"     sudo -n id -u
check_session path     "/opt/toolbox/bin" bash -c 'echo "${PATH}"'

# ===================================
# Image hygiene
# ===================================

section "Image hygiene"

if docker history --no-trunc --format '{{.CreatedBy}}' "${IMAGE}" |
    grep -Eq 'ghp_|gho_|ghs_|github_pat_|https?://[^/[:space:]]+:[^@[:space:]]+@'; then
    printf '  [FAIL] %-14s %s\n' "history" "secret-like value found in docker history"
    failures=$((failures + 1))
else
    printf '  [ OK ] %-14s %s\n' "history" "no tokens / proxy credentials"
fi

check apt-proxy \
    'test -z "$(grep -rhs "Acquire::.*Proxy" /etc/apt/apt.conf.d/)"'

# ===================================
# Result
# ===================================

section "Result"

if (( failures > 0 )); then
    echo "  ${failures} check(s) failed"
    exit 1
fi

echo "  all checks passed"
