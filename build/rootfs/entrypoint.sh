#!/usr/bin/env bash

############################################################
# Copyright (c) 2026 Igor Sadza
# Released under the GPLv3 license
# ----------------------------------------------------------
#
# FILE: ./build/rootfs/entrypoint.sh
# DESC: Container initialization entrypoint
#
############################################################

set -Eeuo pipefail

# ===================================
# Shared filesystem permissions
# ===================================

umask 0022

# ===================================
# Execute all container init scripts
# ===================================

run_init_scripts() {
    local directory="$1"
    local pattern="$2"
    local script

    [[ -d "${directory}" ]] || return 0

    while IFS= read -r -d '' script; do
        bash "${script}"
    done < <(
        find "${directory}" \
            -maxdepth 1 \
            -type f \
            -name "${pattern}" \
            -print0 |
        sort -z
    )
}

run_init_scripts \
    '/etc/cont-init.d/core' \
    '*.sh'

run_init_scripts \
    '/etc/cont-init.d/optional' \
    '*.sh'

# ===================================
# Execute
# ===================================

exec "$@"
