# syntax=docker/dockerfile:1.14

############################################################
# Copyright (c) 2026 Igor Sadza 
# Released under the GPLv3 license
# ----------------------------------------------------------
# 
# FILE: ./build/Dockerfile
# DESC: Toolbox image definition
#
############################################################

# =============================================================================
# : Preflight 
# =============================================================================

ARG \
    DISTRIBUTION=debian \
    SUITE=trixie-slim \
    DIGEST=

# =============================================================================
# : Base 
# =============================================================================

FROM ${DISTRIBUTION}:${SUITE}${DIGEST:+@${DIGEST}}

# Build Time Arguments 
ARG \
    DEBIAN_FRONTEND=noninteractive

# ---------------------
# Base: Configure APT (network)
#
# Network hardening only (no host specific settings):
# - HTTPS Debian sources (large packages over plain HTTP are
#   fragile on filtering networks)
# - no pipelining, retries, longer timeouts

RUN \
    echo "**** Base: Configure APT (network) ****" \
    && \
    echo "**** Retries & timeouts ****" \
        && printf '%s\n' \
            'Acquire::http::Pipeline-Depth "0";' \
            'Acquire::https::Pipeline-Depth "0";' \
            'Acquire::Retries "5";' \
            'Acquire::http::Timeout "60";' \
            'Acquire::https::Timeout "180";' \
            > /etc/apt/apt.conf.d/80-network \
    && \
    echo "**** Bootstrap CA bundle (over the original HTTP source) ****" \
        && if ! test -s /etc/ssl/certs/ca-certificates.crt; \
           then \
             apt-get update \
             && apt-get install --reinstall --no-install-recommends -y \
                 ca-certificates \
             && update-ca-certificates --fresh; \
           fi \
        && test -s /etc/ssl/certs/ca-certificates.crt \
    && \
    echo "**** Use HTTPS Debian sources ****" \
        && sed -i \
            's|http://deb.debian.org|https://deb.debian.org|g' \
            /etc/apt/sources.list.d/debian.sources \
    && \
    echo "**** Section cleanup ****" \
        && rm -rf \
            /var/lib/apt/lists/* \
            /var/cache/apt/* \
            /var/tmp/* \
            /tmp/*

# ---------------------
# Base: Configure Locales

ARG \
    TZ=UTC \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    LC_CTYPE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8"

ENV \
    LANG=${LANG} \
    LC_ALL=${LC_ALL} \
    LANGUAGE=${LANGUAGE} \
    TZ=${TZ}

RUN \
    echo "**** Base: User Tools ****" \
        && apt-get update \
        && apt-get install --no-install-recommends -y \
            ca-certificates \
            locales \
            ssl-cert \
            lsb-release \
            tzdata \
            sudo \
    && \
    echo "**** Set locale and timezone ****" \
        && sed -i -e "s/# $LANG.*/$LANG UTF-8/" /etc/locale.gen \
        && locale-gen ${LANG} \
        && ln -snf "/usr/share/zoneinfo/${TZ}" /etc/localtime \
        && echo "${TZ}" > /etc/timezone \
        && localedef -i en_US -f UTF-8 en_US.UTF-8 \
        && dpkg-reconfigure --frontend=noninteractive locales \
        && update-locale LANG=$LANG \
    && \
    echo "**** Section cleanup ****" \
        && rm -rf \
            /var/lib/apt/lists/* \
            /var/cache/apt/* \
            /var/tmp/* \
            /tmp/*

# ---------------------
# Base: Security updates (optional)
#
# Pinned base digest = reproducible. The weekly CI build sets
# APT_UPGRADE=true to pull the latest Debian security fixes.

ARG \
    APT_UPGRADE="false"

RUN \
    echo "**** Base: Security updates | Enabled: ${APT_UPGRADE} ****" \
    && \
    if [ "${APT_UPGRADE}" = "true" ]; \
    then \
    echo "**** Upgrading ****" \
        && apt-get update \
        && apt-get upgrade -y --no-install-recommends \
    && \
    echo "**** Section cleanup ****" \
        && apt-get clean autoclean -y \
        && rm -rf \
            /var/lib/apt/lists/* \
            /var/tmp/* \
            /tmp/*; \
    fi

# =============================================================================
# : Core
# =============================================================================

# -----------------------------------------------
# Core: Neovim (BIN)

ARG \
    INSTALL_NEOVIM="false" \
    NEOVIM_VERSION="" \
    NEOVIM_SHA256=""

RUN \
    echo "**** Core: Install Neovim | Version: ${NEOVIM_VERSION} ****" \
    && \
    if [ "${INSTALL_NEOVIM}" = "true" ]; \
    then \
    echo "**** Prepare ****" \
        && apt-get update \
        && apt-get install --no-install-recommends -y \
            ca-certificates \
            curl \
    && \
    echo "**** Fetching Release ****" \
        && : "${NEOVIM_VERSION:?NEOVIM_VERSION is required}" \
        && : "${NEOVIM_SHA256:?NEOVIM_SHA256 is required}" \
        && RELEASE_URL="https://github.com/neovim/neovim/releases/download/${NEOVIM_VERSION}/nvim-linux-x86_64.tar.gz" \
        && curl -o /tmp/nvim.tar.gz -fsSL "${RELEASE_URL}" \
    && \
    echo "**** Verifying Checksum ****" \
        && printf '%s  %s\n' "${NEOVIM_SHA256}" /tmp/nvim.tar.gz | sha256sum -c - \
    && \
    echo "**** Installing Release ****" \
        && mkdir -p /opt/neovim \
        && tar -xzf /tmp/nvim.tar.gz \
            --strip-components=1 \
            --directory=/opt/neovim \
        && ln -sf /opt/neovim/bin/nvim /usr/local/bin/nvim \
        && ln -sf /usr/local/bin/nvim /usr/local/bin/vi \
        && vi --version \
    && \
    echo "**** Section cleanup ****" \
        && apt-get clean autoclean -y \
        && apt-get autoremove -y \
        && rm -rf \
            /var/lib/apt/lists/* \
            /var/tmp/* \
            /tmp/*; \
    fi

# -----------------------------------------------
# Core: Docker (GPG)

ARG \
    INSTALL_DOCKER="false" \
    DOCKER_CE_VERSION="" \
    DOCKER_CE_CLI_VERSION="" \
    CONTAINERD_VERSION="" \
    DOCKER_BUILDX_VERSION="" \
    DOCKER_COMPOSE_VERSION=""

RUN \
    echo "**** Core: Install Docker | Version: ${DOCKER_CE_VERSION:-latest} ****" \
    && \
    if [ "${INSTALL_DOCKER}" = "true" ]; \
    then \
    echo "**** Prepare ****" \
        && apt-get update \
        && apt-get install --no-install-recommends -y \
            ca-certificates \
            curl \
    && \
    echo "**** Fetching GPG ****" \
      && install -m 0755 -d /etc/apt/keyrings \
      && curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc \
      && chmod a+r /etc/apt/keyrings/docker.asc \
    && \
    echo "**** Configure Sources ****" \
      && SUITE=$(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) \
      && printf '%s\n' \
          'Types: deb' \
          'URIs: https://download.docker.com/linux/debian' \
          "Suites: ${SUITE}" \
          'Components: stable' \
          "Architectures: $(dpkg --print-architecture)" \
          'Signed-By: /etc/apt/keyrings/docker.asc' \
         > /etc/apt/sources.list.d/docker.sources \
    && \
    echo "**** Installing ****" \
        && apt-get update \
        && apt-get install --no-install-recommends -y \
            docker-ce${DOCKER_CE_VERSION:+=${DOCKER_CE_VERSION}} \
            docker-ce-cli${DOCKER_CE_CLI_VERSION:+=${DOCKER_CE_CLI_VERSION}} \
            containerd.io${CONTAINERD_VERSION:+=${CONTAINERD_VERSION}} \
            docker-buildx-plugin${DOCKER_BUILDX_VERSION:+=${DOCKER_BUILDX_VERSION}} \
            docker-compose-plugin${DOCKER_COMPOSE_VERSION:+=${DOCKER_COMPOSE_VERSION}} \
    && \
    echo "**** Section cleanup ****" \
        && apt-get clean autoclean -y \
        && apt-get autoremove -y \
        && rm -rf \
            /var/lib/apt/lists/* \
            /var/tmp/* \
            /tmp/*; \
    fi

# -----------------------------------------------
# Core: K9S (BIN)

ARG \
    INSTALL_K9S="false" \
    K9S_VERSION="" \
    K9S_SHA256=""

RUN \
    echo "**** Core: Install K9S | Version: ${K9S_VERSION} ****" \
    && \
    if [ "${INSTALL_K9S}" = "true" ]; \
    then \
    echo "**** Prepare ****" \
        && apt-get update \
        && apt-get install --no-install-recommends -y \
            ca-certificates \
            curl \
    && \
    echo "**** Fetching Release ****" \
        && : "${K9S_VERSION:?K9S_VERSION is required}" \
        && : "${K9S_SHA256:?K9S_SHA256 is required}" \
        && RELEASE_URL="https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_Linux_amd64.tar.gz" \
        && curl -o /tmp/k9s.tar.gz -fsSL "${RELEASE_URL}" \
    && \
    echo "**** Verifying Checksum ****" \
        && printf '%s  %s\n' "${K9S_SHA256}" /tmp/k9s.tar.gz | sha256sum -c - \
    && \
    echo "**** Installing Release ****" \
        && mkdir -p /opt/k9s \
        && tar -xzf /tmp/k9s.tar.gz \
            --directory=/opt/k9s \
        && ln -sf \
            /opt/k9s/k9s \
            /usr/local/bin/k9s \
        && k9s version --short \
    && \
    echo "**** Section cleanup ****" \
        && apt-get clean autoclean -y \
        && apt-get autoremove -y \
        && rm -rf \
            /var/lib/apt/lists/* \
            /var/tmp/* \
            /tmp/*; \
    fi

# -----------------------------------------------
# Core: Helm (GPG)

ARG \
    INSTALL_HELM="false" \
    HELM_VERSION=""

RUN \
    echo "**** Core: Install Helm | Version: ${HELM_VERSION:-latest} ****" \
    && \
    if [ "${INSTALL_HELM}" = "true" ]; \
    then \
    echo "**** Prepare ****" \
        && apt-get update \
        && apt-get install --no-install-recommends -y \
            ca-certificates \
            curl \
            gpg  \
            apt-transport-https \
    && \
    echo "**** Fetching GPG ****" \
      && curl -fsSL https://packages.buildkite.com/helm-linux/helm-debian/gpgkey -o "${TMPDIR:-/tmp}/helm.gpg" \
      && gpg --dearmor --output /usr/share/keyrings/helm.gpg "${TMPDIR:-/tmp}/helm.gpg" > /dev/null \
    && \
    echo "**** Configure Sources ****" \
      && GPG_URL="https://packages.buildkite.com/helm-linux/helm-debian/any/" \
      && printf '%s\n' \
          "deb [signed-by=/usr/share/keyrings/helm.gpg] ${GPG_URL} any main" \
         > /etc/apt/sources.list.d/helm.list \
    && \
    echo "**** Installing ****" \
        && apt-get update \
        && apt-get install --no-install-recommends -y \
          helm${HELM_VERSION:+=${HELM_VERSION}} \
    && \
    echo "**** Section cleanup ****" \
        && apt-get clean autoclean -y \
        && apt-get autoremove -y \
        && rm -rf \
            /var/lib/apt/lists/* \
            /var/tmp/* \
            /tmp/*; \
    fi

# -----------------------------------------------
# Core: Kubectl (GPG)

ARG \
    INSTALL_KUBECTL="false" \
    KUBECTL_VERSION=""

RUN \
    echo "**** Core: Install Kubectl | Version: ${KUBECTL_VERSION:-latest} ****" \
    && \
    if [ "${INSTALL_KUBECTL}" = "true" ]; \
    then \
    echo "**** Prepare ****" \
        && apt-get update \
        && apt-get install --no-install-recommends -y \
            ca-certificates \
            curl \
            gpg  \
            apt-transport-https \
    && \
    echo "**** Fetching GPG ****" \
      && KUBECTL_MINOR="v$(printf '%s' "${KUBECTL_VERSION}" | cut -d. -f1,2)" \
      && curl -fsSL https://pkgs.k8s.io/core:/stable:/${KUBECTL_MINOR}/deb/Release.key -o "${TMPDIR:-/tmp}/kubernetes.gpg" \
      && gpg --dearmor --output /usr/share/keyrings/kubernetes.gpg "${TMPDIR:-/tmp}/kubernetes.gpg" > /dev/null \
    && \
    echo "**** Configure Sources ****" \
      && GPG_URL="https://pkgs.k8s.io/core:/stable:/${KUBECTL_MINOR}/deb/" \
      && printf '%s\n' \
          "deb [signed-by=/usr/share/keyrings/kubernetes.gpg] ${GPG_URL} /" \
         > /etc/apt/sources.list.d/kubernetes.list \
    && \
    echo "**** Installing ****" \
        && apt-get update \
        && apt-get install --no-install-recommends -y \
          kubectl${KUBECTL_VERSION:+=${KUBECTL_VERSION}} \
    && \
    echo "**** Section cleanup ****" \
        && apt-get clean autoclean -y \
        && apt-get autoremove -y \
        && rm -rf \
            /var/lib/apt/lists/* \
            /var/tmp/* \
            /tmp/*; \
    fi

# -----------------------------------------------
# Core: Terraform (GPG)

ARG \
    INSTALL_TERRAFORM="false" \
    TERRAFORM_VERSION=""

RUN \
    echo "**** Core: Install Terraform | Version: ${TERRAFORM_VERSION:-latest} ****" \
    && \
    if [ "${INSTALL_TERRAFORM}" = "true" ]; \
    then \
    echo "**** Prepare ****" \
        && apt-get update \
        && apt-get install --no-install-recommends -y \
            ca-certificates \
            curl \
            gpg  \
            apt-transport-https \
    && \
    echo "**** Fetching GPG ****" \
      && curl -fsSL https://apt.releases.hashicorp.com/gpg -o "${TMPDIR:-/tmp}/terraform.gpg" \
      && gpg --dearmor --output /usr/share/keyrings/terraform.gpg "${TMPDIR:-/tmp}/terraform.gpg" > /dev/null \
    && \
    echo "**** Configure Sources ****" \
      && SUITE=$(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) \
      && GPG_URL="https://apt.releases.hashicorp.com ${SUITE} main" \
      && printf '%s\n' \
          "deb [signed-by=/usr/share/keyrings/terraform.gpg] ${GPG_URL}" \
         > /etc/apt/sources.list.d/terraform.list \
    && \
    echo "**** Installing ****" \
        && apt-get update \
        && apt-get install --no-install-recommends -y \
          terraform${TERRAFORM_VERSION:+=${TERRAFORM_VERSION}} \
    && \
    echo "**** Section cleanup ****" \
        && apt-get clean autoclean -y \
        && apt-get autoremove -y \
        && rm -rf \
            /var/lib/apt/lists/* \
            /var/tmp/* \
            /tmp/*; \
    fi

# -----------------------------------------------
# Core: Azure-CLI (GPG)

ARG \
    INSTALL_AZURE_CLI="false" \
    AZURE_CLI_SUITE="bookworm" \
    AZURE_CLI_VERSION="" 

RUN \
    echo "**** Core: Install Azure-CLI | Version: ${AZURE_CLI_VERSION:-latest} ****" \
    && \
    if [ "${INSTALL_AZURE_CLI}" = "true" ]; \
    then \
    echo "**** Prepare ****" \
        && apt-get update \
        && apt-get install --no-install-recommends -y \
            ca-certificates \
            curl \
    && \
    echo "**** Fetching GPG ****" \
      && install -m 0755 -d /etc/apt/keyrings \
      && curl -fsSL https://packages.microsoft.com/keys/microsoft.asc -o /etc/apt/keyrings/microsoft.asc \
      && chmod a+r /etc/apt/keyrings/microsoft.asc \
    && \
    echo "**** Configure Sources ****" \
      && printf '%s\n' \
          'Types: deb' \
          'URIs: https://packages.microsoft.com/repos/azure-cli/' \
          "Suites: ${AZURE_CLI_SUITE}" \
          'Components: main' \
          "Architectures: $(dpkg --print-architecture)" \
          'Signed-By: /etc/apt/keyrings/microsoft.asc' \
         > /etc/apt/sources.list.d/microsoft.azure-cli.sources \
    && \
    echo "**** Installing ****" \
        && apt-get update \
        && apt-get install --no-install-recommends -y \
            azure-cli${AZURE_CLI_VERSION:+=${AZURE_CLI_VERSION}} \
        && test -x /opt/az/bin/python3 \
        && /opt/az/bin/python3 --version \
        && az version \
    && \
    echo "**** Section cleanup ****" \
        && apt-get clean autoclean -y \
        && apt-get autoremove -y \
        && rm -rf \
            /var/lib/apt/lists/* \
            /var/tmp/* \
            /tmp/*; \
    fi

# -----------------------------------------------
# Core: Node.js (GPG)

ARG \
    INSTALL_NODE_JS="false" \
    NODE_JS_VERSION="" \
    NODE_JS_MAJOR=22

RUN \
    echo "**** Core: Install Node.js | Version: ${NODE_JS_VERSION:-latest} ****" \
    && \
    if [ "${INSTALL_NODE_JS}" = "true" ]; \
    then \
    echo "**** Prepare ****" \
        && apt-get update \
        && apt-get install --no-install-recommends -y \
            ca-certificates \
            curl \
            gpg \
    && \
    echo "**** Fetching GPG ****" \
      && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key -o "${TMPDIR:-/tmp}/node.gpg" \
      && gpg --dearmor --output /usr/share/keyrings/node.gpg "${TMPDIR:-/tmp}/node.gpg" > /dev/null \
    && \
    echo "**** Configure Sources ****" \
      && GPG_URL="https://deb.nodesource.com/node_${NODE_JS_MAJOR}.x" \
      && printf '%s\n' \
          "deb [signed-by=/usr/share/keyrings/node.gpg] ${GPG_URL} nodistro main" \
         > /etc/apt/sources.list.d/node.list \
    && \
    echo "**** Installing ****" \
        && apt-get update \
        && apt-get install --no-install-recommends -y \
            nodejs${NODE_JS_VERSION:+=${NODE_JS_VERSION}} \
    && \
    echo "**** Section cleanup ****" \
        && apt-get clean autoclean -y \
        && apt-get autoremove -y \
        && rm -rf \
            /var/lib/apt/lists/* \
            /var/tmp/* \
            /tmp/*; \
    fi

# -----------------------------------------------
# Core: Gomplate (BIN)

ARG \
    INSTALL_GOMPLATE="false" \
    GOMPLATE_VERSION="" \
    GOMPLATE_SHA256=""

RUN \
    echo "**** Core: Install Gomplate | Version: ${GOMPLATE_VERSION} ****" \
    && \
    if [ "${INSTALL_GOMPLATE}" = "true" ]; \
    then \
    echo "**** Prepare ****" \
        && apt-get update \
        && apt-get install --no-install-recommends -y \
            ca-certificates \
            curl \
    && \
    echo "**** Fetching Release ****" \
        && : "${GOMPLATE_VERSION:?GOMPLATE_VERSION is required}" \
        && : "${GOMPLATE_SHA256:?GOMPLATE_SHA256 is required}" \
        && RELEASE_URL="https://github.com/hairyhenderson/gomplate/releases/download/${GOMPLATE_VERSION}/gomplate_linux-amd64" \
        && curl -o /tmp/gomplate -fsSL "${RELEASE_URL}" \
    && \
    echo "**** Verifying Checksum ****" \
        && printf '%s  %s\n' "${GOMPLATE_SHA256}" /tmp/gomplate | sha256sum -c - \
    && \
    echo "**** Installing Release ****" \
        && install -m 0755 /tmp/gomplate /usr/local/bin/gomplate \
        && gomplate --version \
    && \
    echo "**** Section cleanup ****" \
        && apt-get clean autoclean -y \
        && apt-get autoremove -y \
        && rm -rf \
            /var/lib/apt/lists/* \
            /var/tmp/* \
            /tmp/*; \
    fi

# -----------------------------------------------
# Core: ACT (BIN)

ARG \
    INSTALL_ACT="false" \
    ACT_VERSION="" \
    ACT_SHA256=""

RUN \
    echo "**** Core: Install ACT | Version: ${ACT_VERSION} ****" \
    && \
    if [ "${INSTALL_ACT}" = "true" ]; \
    then \
    echo "**** Prepare ****" \
        && apt-get update \
        && apt-get install --no-install-recommends -y \
            ca-certificates \
            curl \
    && \
    echo "**** Fetching Release ****" \
        && : "${ACT_VERSION:?ACT_VERSION is required}" \
        && : "${ACT_SHA256:?ACT_SHA256 is required}" \
        && RELEASE_URL="https://github.com/nektos/act/releases/download/${ACT_VERSION}/act_Linux_x86_64.tar.gz" \
        && curl -o /tmp/act.tar.gz -fsSL "${RELEASE_URL}" \
    && \
    echo "**** Verifying Checksum ****" \
        && printf '%s  %s\n' "${ACT_SHA256}" /tmp/act.tar.gz | sha256sum -c - \
    && \
    echo "**** Installing Release ****" \
        && mkdir -p /opt/act \
        && tar -xzf /tmp/act.tar.gz \
            --directory=/opt/act \
        && ln -sf \
            /opt/act/act \
            /usr/local/bin/act \
        && act --version \
    && \
    echo "**** Section cleanup ****" \
        && apt-get clean autoclean -y \
        && apt-get autoremove -y \
        && rm -rf \
            /var/lib/apt/lists/* \
            /var/tmp/* \
            /tmp/*; \
    fi

# -----------------------------------------------
# Core: Miscellaneous (APT)

RUN \
    echo "**** Core: Install Miscellaneous (apt) ****" \
    && \
    echo "**** Installing ****" \
        && apt-get update \
        && apt-get install --no-install-recommends -y \
            socat \
            dnsutils \
            bash-completion \
            git \
            tmux \
            lua5.1 \
            luarocks \
            golang \
            ripgrep \
            fd-find \
            libicu76 \
            pipx \
            python3 \
            python3-dev \
            build-essential \
            file \
            sqlite3 \
            rustup \
            libclang-dev \
            clang \
            supervisor \
            liquidprompt \
            ncurses-bin \
            figlet \
            lolcat \
            boxes \
            python3-pip \
            tree \
            iputils-ping \
            acl \
            ssh \
            nfs-common \
            fuse3 \
            sshfs \
            rclone \
            netcat-openbsd \
            iproute2 \
    && \
    echo "**** Section cleanup ****" \
        && apt-get clean autoclean -y \
        && apt-get autoremove -y \
        && rm -rf \
            /var/lib/apt/lists/* \
            /var/tmp/* \
            /tmp/*

# =============================================================================
# : Config
# =============================================================================

# -----------------------------------------------
# Config: Groups
# -----------------------------------------------

ARG \
    TOOLBOX_SHARED_GID=29999

ENV \
    TOOLBOX_SHARED_GID=${TOOLBOX_SHARED_GID}

RUN \
    echo "**** Config: User & Groups  ****" \
        && groupadd \
            --gid "${TOOLBOX_SHARED_GID}" \
            toolbox-shared

# -----------------------------------------------
# Config: Base
# -----------------------------------------------

ENV \
    SHELL=/bin/bash \
    TERM=xterm-256color

# -----------------------------------------------
# Config: Toolbox filesystem
# -----------------------------------------------

ENV \
    TOOLBOX_ROOT=/opt/toolbox \
    TOOLBOX_CONFIG=/opt/toolbox/config \
    TOOLBOX_DATA=/opt/toolbox/share \
    TOOLBOX_STATE=/opt/toolbox/state \
    TOOLBOX_CACHE=/opt/toolbox/cache \
    TOOLBOX_BIN=/opt/toolbox/bin \
    TOOLBOX_RUNTIME_ROOT=/run/toolbox

# -----------------------------------------------
# Config: Node.js / npm
# -----------------------------------------------

ENV \
    NPM_CONFIG_CACHE=${TOOLBOX_CACHE}/npm \
    NPM_CONFIG_PYTHON=/usr/bin/python3

# -----------------------------------------------
# Config: Go
# -----------------------------------------------

ENV \
    GOPATH=${TOOLBOX_DATA}/go \
    GOBIN=${TOOLBOX_BIN} \
    GOCACHE=${TOOLBOX_CACHE}/go/build \
    GOMODCACHE=${TOOLBOX_CACHE}/go/modules

# GOTMPDIR is configured per runtime user by toolbox.sh.

# -----------------------------------------------
# Config: Rust
# -----------------------------------------------

ENV \
    CARGO_HOME=${TOOLBOX_DATA}/cargo \
    CARGO_TARGET_DIR=${TOOLBOX_CACHE}/cargo/target \
    RUSTUP_HOME=${TOOLBOX_DATA}/rustup

# -----------------------------------------------
# Config: uv
# -----------------------------------------------

ENV \
    UV_TOOL_DIR=${TOOLBOX_DATA}/uv/tools \
    UV_TOOL_BIN_DIR=${TOOLBOX_BIN} \
    UV_CACHE_DIR=${TOOLBOX_CACHE}/uv

# -----------------------------------------------
# Config: Liquidprompt
# -----------------------------------------------

ENV \
    LIQUIDPROMPT_THEME=powerline

# -----------------------------------------------
# Config: OpenCode
# -----------------------------------------------

ENV \
    OPENCODE_CONFIG=${TOOLBOX_CONFIG}/opencode/opencode.json

# -----------------------------------------------
# Config: Git
# -----------------------------------------------

ENV \
    GIT_EDITOR=vi

# -----------------------------------------------
# Config: PATH
# -----------------------------------------------

ENV \
    PATH=${TOOLBOX_BIN}:${CARGO_HOME}/bin:${GOPATH}/bin:${PATH}

# =============================================================================
# : Postflight
# =============================================================================

# -----------------------------------------------
# Postflight: Create toolbox filesystem
# -----------------------------------------------

RUN \
    echo "**** Postflight: Create toolbox filesystem ****" \
    && install \
        -d \
        -o root \
        -g root \
        -m 0755 \
        "${TOOLBOX_ROOT}" \
        "${TOOLBOX_CONFIG}" \
        "${TOOLBOX_RUNTIME_ROOT}" \
    && \
    echo "**** Postflight: Create shared workspace targets ****" \
    && install \
        -d \
        -o root \
        -g toolbox-shared \
        -m 2775 \
        "${TOOLBOX_DATA}" \
        "${TOOLBOX_STATE}" \
        "${TOOLBOX_CACHE}" \
        "${TOOLBOX_BIN}" \
        "${NPM_CONFIG_CACHE}" \
        "${GOPATH}" \
        "${GOCACHE}" \
        "${GOMODCACHE}" \
        "${CARGO_HOME}" \
        "${CARGO_TARGET_DIR}" \
        "${RUSTUP_HOME}" \
        "${UV_TOOL_DIR}" \
        "${UV_CACHE_DIR}" \
    && setfacl \
        -m g:toolbox-shared:rwx \
        -m d:g:toolbox-shared:rwx \
        -m d:m:rwx \
        "${TOOLBOX_DATA}" \
        "${TOOLBOX_STATE}" \
        "${TOOLBOX_CACHE}" \
        "${TOOLBOX_BIN}" \
        "${NPM_CONFIG_CACHE}" \
        "${GOPATH}" \
        "${GOCACHE}" \
        "${GOMODCACHE}" \
        "${CARGO_HOME}" \
        "${CARGO_TARGET_DIR}" \
        "${RUSTUP_HOME}" \
        "${UV_TOOL_DIR}" \
        "${UV_CACHE_DIR}"

# -----------------------------------------------
# Postflight: Python, npm, and Cargo packages
# -----------------------------------------------

ARG \
    RUST_TOOLCHAIN="" \
    CARGO_TREE_SITTER_CLI="" \
    NPM_NEOVIM="" \
    NPM_OPENCODE_AI="" \
    NPM_CODEX="" \
    PIPX_UV=""

RUN \
    echo "**** Postflight: Install extra packages (pipx / npm / cargo) ****" \
    && umask 0002 \
    && \
    echo "**** Install extra Python packages ****" \
        && : "${PIPX_UV:?PIPX_UV is required}" \
        && pipx install \
            --global \
            "uv==${PIPX_UV}" \
    && \
    echo "**** Install extra Node packages ****" \
        && if [ "${INSTALL_NODE_JS}" = "true" ]; \
           then \
             : "${NPM_OPENCODE_AI:?NPM_OPENCODE_AI is required}" \
             && : "${NPM_NEOVIM:?NPM_NEOVIM is required}" \
             && : "${NPM_CODEX:?NPM_CODEX is required}" \
             && npm install \
                 --global \
                 "opencode-ai@${NPM_OPENCODE_AI}" \
                 "neovim@${NPM_NEOVIM}" \
                 "@openai/codex@${NPM_CODEX}" \
             && npm cache clean --force; \
           fi \
    && \
    echo "**** Install Rust toolchain | Version: ${RUST_TOOLCHAIN} ****" \
        && : "${RUST_TOOLCHAIN:?RUST_TOOLCHAIN is required}" \
        && rustup toolchain install \
            "${RUST_TOOLCHAIN}" \
            --profile minimal \
        && rustup default "${RUST_TOOLCHAIN}" \
    && \
    echo "**** Install extra Cargo packages ****" \
        && : "${CARGO_TREE_SITTER_CLI:?CARGO_TREE_SITTER_CLI is required}" \
        && cargo install \
            tree-sitter-cli \
            --locked \
            --root /usr/local \
            --version "${CARGO_TREE_SITTER_CLI}" \
    && \
    echo "**** Section cleanup ****" \
        && python3 -m pip cache purge \
        && rm -rf -- "${CARGO_HOME:?}/registry" "${CARGO_HOME:?}/git"

# -----------------------------------------------
# Postflight: Copy overlays
# -----------------------------------------------

COPY \
    rootfs/ /

# -----------------------------------------------
# Postflight: Configure overlay
# -----------------------------------------------

# hadolint ignore=SC2016
RUN \
    echo "**** Postflight: Configure overlay ****" \
    && \
    echo "**** Executable permissions ****" \
        && chmod 0755 \
            /entrypoint.sh \
            /usr/bin/toolbox.sh \
            "${TOOLBOX_BIN}/vi" \
            "${TOOLBOX_BIN}/tmux" \
            "${TOOLBOX_BIN}/cheat" \
    && \
    echo "**** Load /etc/bash.bashrc.d fragments ****" \
        && printf '%s\n' \
            '' \
            '# BEGIN bash.bashrc.d loader' \
            '# Load global interactive Bash configuration fragments.' \
            'if [[ $- == *i* ]] && [[ -d /etc/bash.bashrc.d ]]; then' \
            '    for file in /etc/bash.bashrc.d/*.sh; do' \
            '        [[ -r "${file}" ]] && source "${file}"' \
            '    done' \
            '    unset file' \
            'fi' \
            '# END bash.bashrc.d loader' \
            >> /etc/bash.bashrc \
    && \
    echo "**** Passwordless sudo ****" \
        && printf '%s\n' \
            '%sudo ALL=(ALL:ALL) NOPASSWD: ALL' \
            > /etc/sudoers.d/toolbox \
        && chmod 0440 /etc/sudoers.d/toolbox \
        && visudo -q -cf /etc/sudoers.d/toolbox

# -----------------------------------------------
# Postflight: Install Neovim plugins
# -----------------------------------------------

RUN \
    echo "**** Postflight: Install Neovim plugins | ${INSTALL_NEOVIM} ****" \
    && umask 0002 \
    && \
    if [ "${INSTALL_NEOVIM}" = "true" ]; \
    then \
    echo "**** Restore plugins (lazy-lock.json), Mason tools, Treesitter parsers ****" \
        && export XDG_CONFIG_HOME="${TOOLBOX_CONFIG}" \
        && export XDG_DATA_HOME="${TOOLBOX_DATA}" \
        && export XDG_STATE_HOME="${TOOLBOX_STATE}" \
        && export XDG_CACHE_HOME="${TOOLBOX_CACHE}" \
        && git config --global --add safe.directory '*' \
        && /usr/local/bin/vi \
            --headless \
            "+Lazy! sync" \
            "+MasonToolsInstallSync" \
            "+lua require('nvim-treesitter').install(vim.g.toolbox_parsers):wait(600000)" \
            +qa \
    && \
    echo "**** Section cleanup ****" \
        && rm -rf -- "${TOOLBOX_CACHE:?}/nvim"; \
    fi

# -----------------------------------------------
# Postflight: Clear build caches
# -----------------------------------------------

RUN \
    echo "**** Postflight: Clear toolbox caches ****" \
    && test "${TOOLBOX_CACHE}" = "/opt/toolbox/cache" \
    && rm -rf -- "${TOOLBOX_CACHE}" \
    && install \
        -d \
        -o root \
        -g toolbox-shared \
        -m 2775 \
        "${TOOLBOX_CACHE}" \
    && setfacl \
        -m g:toolbox-shared:rwx \
        -m d:g:toolbox-shared:rwx \
        -m d:m:rwx \
        "${TOOLBOX_CACHE}"

# -----------------------------------------------
# Postflight: Finalize user-writable targets
# -----------------------------------------------

RUN \
    echo "**** Finalize shared toolbox permissions ****" \
    && chgrp -R toolbox-shared \
        "${TOOLBOX_CONFIG}" \
        "${TOOLBOX_DATA}" \
        "${TOOLBOX_STATE}" \
        "${TOOLBOX_CACHE}" \
        "${TOOLBOX_BIN}" \
    && chmod -R g+rwX \
        "${TOOLBOX_CONFIG}" \
        "${TOOLBOX_DATA}" \
        "${TOOLBOX_STATE}" \
        "${TOOLBOX_CACHE}" \
        "${TOOLBOX_BIN}" \
    && find \
        "${TOOLBOX_CONFIG}" \
        "${TOOLBOX_DATA}" \
        "${TOOLBOX_STATE}" \
        "${TOOLBOX_CACHE}" \
        "${TOOLBOX_BIN}" \
        -xdev \
        -type d \
        -exec chmod g+s {} + \
        -exec setfacl \
            -m g:toolbox-shared:rwx \
            -m d:g:toolbox-shared:rwx \
            -m d:m:rwx \
            {} + \
    && find "${TOOLBOX_BIN}" \
        -xdev \
        -type f \
        -exec chmod g+x {} +

# =============================================================================
# : Execute
# =============================================================================

WORKDIR \
    /

ENTRYPOINT \
    ["/entrypoint.sh"]

CMD \
    ["sleep", "infinity"]
