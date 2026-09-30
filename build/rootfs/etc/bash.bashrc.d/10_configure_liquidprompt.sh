############################################################
# Copyright (c) 2026 Igor Sadza
# Released under the GPLv3 license
# ----------------------------------------------------------
#
# FILE: ./build/rootfs/etc/bash.bashrc.d/10_configure_liquidprompt.sh
# DESC: Interactive shells - liquidprompt
#
############################################################

# -----------------------------------
# This file is sourced by interactive Bash shells only.
# -----------------------------------

LIQUIDPROMPT_DIR=/usr/share/liquidprompt

# Config lookup order (first match wins):
#   ~/.liquidpromptrc -> ~/.config/liquidpromptrc -> ${TOOLBOX_CONFIG}/liquidpromptrc
if [[ -r "${LIQUIDPROMPT_DIR}/liquidprompt" ]]; then
    _LP_XDG_CONFIG_DIRS="${XDG_CONFIG_DIRS-}"
    XDG_CONFIG_DIRS="${TOOLBOX_CONFIG:-/opt/toolbox/config}:${XDG_CONFIG_DIRS:-/etc/xdg}"
    # shellcheck source=/dev/null
    source "${LIQUIDPROMPT_DIR}/liquidprompt"
    if [[ -n "${_LP_XDG_CONFIG_DIRS}" ]]; then
        XDG_CONFIG_DIRS="${_LP_XDG_CONFIG_DIRS}"
    else
        unset XDG_CONFIG_DIRS
    fi
    unset _LP_XDG_CONFIG_DIRS
fi

if declare -F lp_theme >/dev/null 2>&1 \
    && [[ -r "${LIQUIDPROMPT_DIR}/${LIQUIDPROMPT_THEME}.theme" ]]; then
    # shellcheck source=/dev/null
    source "${LIQUIDPROMPT_DIR}/${LIQUIDPROMPT_THEME}.theme"
    lp_theme "${LIQUIDPROMPT_THEME}"
fi

unset LIQUIDPROMPT_DIR
