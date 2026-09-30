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

# Expected lists are read from the config itself (single source).
NVIM_PLUGINS='${TOOLBOX_CONFIG}/nvim/lua/toolbox/plugins'

check mason \
    'missing=""; n=0
     for t in $(sed -n "/ensure_installed = {/,/},/p" '"${NVIM_PLUGINS}"'/lsp.lua | grep -oE "\"[a-z0-9-]+\"" | tr -d "\""); do
       n=$((n + 1)); test -d "${TOOLBOX_DATA}/nvim/mason/packages/${t}" || missing="${missing} ${t}"
     done
     echo "${n} tools${missing:+, missing:${missing}}"; test -z "${missing}" && test "${n}" -gt 0'

check parsers \
    'missing=""; n=0
     for p in $(sed -n "/local parsers = {/,/}/p" '"${NVIM_PLUGINS}"'/treesitter.lua | grep -oE "\"[a-z_]+\"" | tr -d "\""); do
       n=$((n + 1)); test -f "${TOOLBOX_DATA}/nvim/site/parser/${p}.so" || missing="${missing} ${p}"
     done
     echo "${n} parsers${missing:+, missing:${missing}}"; test -z "${missing}" && test "${n}" -gt 0'

# ===================================
# Languages (filetype, treesitter, LSP attach, no errors)
# ===================================

section "Languages"

# Runs inside the image; prints: <file> <filetype> <ts> <lsp,...> <errors>
languages_output="$(
    docker run --rm -i --entrypoint bash "${IMAGE}" -s <<'SCRIPT' 2>/dev/null
set -u
W=/tmp/langs
mkdir -p "${W}/.github/workflows" "${W}/chart/templates" "${W}/py"
cd "${W}" && git init -q

printf 'services:\n  a:\n    image: debian\n'                        > compose.yaml
printf 'on: push\njobs:\n  a:\n    runs-on: ubuntu-latest\n    steps:\n      - run: echo\n' > .github/workflows/ci.yml
printf 'apiVersion: v2\nname: c\nversion: 0.1.0\n'                  > chart/Chart.yaml
printf 'kind: ConfigMap\nmetadata:\n  name: {{ .Release.Name }}\n'  > chart/templates/cm.yaml
printf 'replicas: 1\n'                                               > chart/values.yaml
printf 'import os\nprint(os.name)\n'                                 > py/a.py
printf '[a]\nb = 1\n'                                                > a.toml
printf 'resource "a" "b" {}\n'                                       > main.tf
printf '{{ .Env.HOME }}\n'                                           > a.tmpl
printf 'FROM debian\n'                                               > Dockerfile
printf 'local x = vim.uv\nprint(x)\n'                                > a.lua
printf 'package main\n\nfunc main() {}\n'                            > main.go
printf 'echo hi\n'                                                   > a.sh

cat > /tmp/probe.lua <<'LUA'
vim.defer_fn(function()
  local names = {}
  for _, c in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    names[#names + 1] = c.name
  end
  table.sort(names)
  local msgs = vim.api.nvim_exec2("messages", { output = true }).output
  local errors = select(2, msgs:gsub("E%d+:", "")) + select(2, msgs:gsub("[Ee]rror", ""))
  io.stdout:write(string.format("%s %s %s %s %d\n",
    vim.fn.expand("%"), vim.bo.filetype, tostring(pcall(vim.treesitter.get_parser, 0)),
    #names > 0 and table.concat(names, ",") or "-", errors))
  vim.cmd("qa!")
end, 10000)
LUA

for f in compose.yaml .github/workflows/ci.yml chart/templates/cm.yaml chart/values.yaml \
         py/a.py a.toml main.tf a.tmpl Dockerfile a.lua main.go a.sh; do
    timeout 60 vi --headless "${f}" "+luafile /tmp/probe.lua" 2>/dev/null | tail -n1
done
SCRIPT
)"

# <file> <expected filetype> <expected LSP (one of the attached)>
while read -r file ft lsp; do
    line="$(grep -E "^${file//./\\.} " <<<"${languages_output}" || true)"
    read -r _ got_ft got_ts got_lsp got_err <<<"${line:-x - false - 1}"

    if [[ "${got_ft}" == "${ft}" && "${got_ts}" == "true" &&
          ",${got_lsp}," == *",${lsp},"* && "${got_err}" == "0" ]]; then
        printf '  [ OK ] %-14s %s\n' "${file##*/}" "${got_ft} | ${got_lsp}"
    else
        printf '  [FAIL] %-14s expected %s/%s, got ft=%s ts=%s lsp=%s errors=%s\n' \
            "${file##*/}" "${ft}" "${lsp}" "${got_ft}" "${got_ts}" "${got_lsp}" "${got_err}"
        failures=$((failures + 1))
    fi
done <<'EXPECTED'
compose.yaml yaml.docker-compose docker_compose_language_service
.github/workflows/ci.yml yaml gh_actions_ls
chart/templates/cm.yaml helm helm_ls
chart/values.yaml yaml.helm-values helm_ls
py/a.py python basedpyright
a.toml toml taplo
main.tf terraform terraformls
a.tmpl gotmpl gopls
Dockerfile dockerfile dockerls
a.lua lua lua_ls
main.go go gopls
a.sh sh bashls
EXPECTED

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
