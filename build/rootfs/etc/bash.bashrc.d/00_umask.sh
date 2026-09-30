############################################################
# Copyright (c) 2026 Igor Sadza
# Released under the GPLv3 license
# ----------------------------------------------------------
#
# FILE: ./build/rootfs/etc/bash.bashrc.d/00_umask.sh
# DESC: Interactive shells - default file mode mask
#
############################################################

# -----------------------------------
# This file is sourced by interactive Bash shells only.
# -----------------------------------

# Group-writable, never world-writable (rw-rw-r-- / rwxrwxr-x).
umask 0002
