#!/usr/bin/env bash

############################################################
# Copyright (c) 2026 Igor Sadza
# Released under the GPLv3 license
# ----------------------------------------------------------
#
# FILE: ./.cicd/github/build-args.sh
# DESC: Print KEY=VALUE build args from an env file
# USAGE: .cicd/github/build-args.sh [.env.example]
#
############################################################

set -Eeuo pipefail

ENV_FILE="${1:-.env.example}"

# Runtime-only keys are not build args.
SKIP_KEYS='^(LIQUIDPROMPT_THEME)$'

# ===================================
# Collect keys (in file order)
# ===================================

mapfile -t keys < <(
    grep -oE '^[A-Za-z_][A-Za-z0-9_]*=' "${ENV_FILE}" |
    tr -d '=' |
    awk '!seen[$0]++' |
    grep -vE "${SKIP_KEYS}"
)

# ===================================
# Resolve values (shell quoting rules)
# ===================================

set -a
# shellcheck source=/dev/null
source "${ENV_FILE}"
set +a

for key in "${keys[@]}"; do
    printf '%s=%s\n' "${key}" "${!key-}"
done
