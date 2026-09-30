#!/usr/bin/env bash

############################################################
# Copyright (c) 2026 Igor Sadza
# Released under the GPLv3 license
# ----------------------------------------------------------
#
# FILE: ./.cicd/github/act.sh
# DESC: Local CICD Entrypoint
# TIPS: https://nektosact.com/usage/index.html
#
############################################################

set -euo pipefail

# ===================================
# Arguments
# ===================================

# Runner image (avoids act's interactive first-run prompt).
RUNNER_IMAGE="${ACT_RUNNER_IMAGE:-catthehacker/ubuntu:act-latest}"

act_args=(
  --platform "ubuntu-latest=${RUNNER_IMAGE}"
  --workflows "${PWD}/.github/workflows/build.yml"
)

# Token is optional: pull_request mode never publishes.
if command -v gh >/dev/null 2>&1 && token="$(gh auth token 2>/dev/null)"; then
  act_args+=(--secret "WORKFLOW_TOKEN=${token}")
fi

# ===================================
# Execute
# ===================================

# pull_request = build + test only (never publishes)
exec act pull_request "${act_args[@]}" "$@"
