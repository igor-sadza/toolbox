#!/usr/bin/env bash

############################################################
# Copyright (c) 2026 Igor Sadza
# Released under the GPLv3 license
# ----------------------------------------------------------
#
# FILE: ./build/rootfs/usr/bin/toolbox.sh
# DESC: Container main executable (per-user session)
#
############################################################

set -Eeuo pipefail

: "${TOOLBOX_UID:?}"
: "${TOOLBOX_GID:?}"
: "${TOOLBOX_GROUPS:?}"
: "${TOOLBOX_USER:?}"
: "${TOOLBOX_HOME:?}"
: "${TOOLBOX_CWD:?}"
: "${TOOLBOX_RUNTIME_ROOT:?}"
: "${TOOLBOX_SHARED_GID:?}"

# ===================================
# Runtime directory
# ===================================

runtime_dir="${TOOLBOX_RUNTIME_ROOT}/${TOOLBOX_UID}"

install \
    -d \
    -o "${TOOLBOX_UID}" \
    -g "${TOOLBOX_GID}" \
    -m 0700 \
    "${runtime_dir}" \
    "${runtime_dir}/go"

# ===================================
# Session environment
# ===================================

export HOME="${TOOLBOX_HOME}"
export USER="${TOOLBOX_USER}"
export LOGNAME="${TOOLBOX_USER}"

export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_STATE_HOME="${HOME}/.local/state"
export XDG_CACHE_HOME="${HOME}/.cache"

export XDG_RUNTIME_DIR="${runtime_dir}"

export GOTMPDIR="${runtime_dir}/go"

# ===================================
# Working directory
# ===================================

cd "${TOOLBOX_CWD}" 2>/dev/null || cd "${HOME}" 2>/dev/null || cd /

# ===================================
# User & primary group
# ===================================

# Primary group: keep the host GID so files created in the
# host home keep their usual group ownership.
if ! getent group "${TOOLBOX_GID}" >/dev/null; then
    group_name="${TOOLBOX_USER}"

    getent group "${group_name}" >/dev/null &&
        group_name="toolbox-${TOOLBOX_GID}"

    groupadd \
        --gid "${TOOLBOX_GID}" \
        "${group_name}"
fi

if ! getent passwd "${TOOLBOX_UID}" >/dev/null &&
   ! getent passwd "${TOOLBOX_USER}" >/dev/null; then
    useradd \
        --uid "${TOOLBOX_UID}" \
        --gid "${TOOLBOX_GID}" \
        --home-dir "${TOOLBOX_HOME}" \
        --shell /bin/bash \
        --no-create-home \
        "${TOOLBOX_USER}"
fi

# ===================================
# Supplementary groups
# ===================================

# Host groups + toolbox-shared (shared caches/tools) + sudo.
SUDO_GID="$(getent group sudo | awk -F: 'NR == 1 { print $3 }')"
test -n "${SUDO_GID}"

session_groups="$(
    printf '%s\n' \
        "${TOOLBOX_GROUPS//,/$'\n'}" \
        "${TOOLBOX_SHARED_GID}" \
        "${SUDO_GID}" |
    awk \
        -v primary="${TOOLBOX_GID}" \
        'NF && $0 != primary && !seen[$0]++' |
    paste -sd, -
)"

# ===================================
# Execute
# ===================================

umask 0002

exec setpriv \
    --reuid="${TOOLBOX_UID}" \
    --regid="${TOOLBOX_GID}" \
    --groups="${session_groups}" \
    --inh-caps=-all \
    /bin/bash
