############################################################
# Copyright (c) 2026 Igor Sadza 
# Released under the GPLv3 license
# ----------------------------------------------------------
#  
# FILE: ./Makefile
# DESC: Building orchestrator
# 
############################################################

############################################################
# Configuration & Metadata
############################################################

# ------------------------
# Shell Flags
# ------------------------
SHELL := /bin/bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c

# ------------------------
# Files
# ------------------------
COMPOSE_FILE := deployments/docker-compose.yml
CMD_COMPOSE := docker compose -f $(COMPOSE_FILE)
ACT_FILE := .cicd/github/act.sh

ENV ?= dev
ENV_FILE := .env.$(ENV)

# ------------------------
# Fall back to .env, then .env.example
# ------------------------
ifeq ($(wildcard $(ENV_FILE)),)
ENV_FILE := .env
endif

ifeq ($(wildcard $(ENV_FILE)),)
ENV_FILE := .env.example
endif

# ------------------------
# Source environment before every recipe
# ------------------------
define LOAD_ENV
set -a
source "$(ENV_FILE)"
$(if $(filter command line,$(origin TOOLBOX_VERSION)),TOOLBOX_VERSION="$(TOOLBOX_VERSION)")
$(if $(filter command line,$(origin TOOLBOX_IMAGE)),TOOLBOX_IMAGE="$(TOOLBOX_IMAGE)")
set +a
endef

# ------------------------
# Makefile Default Goal 
# ------------------------
.DEFAULT_GOAL := help

# ------------------------
# Arguments
# ------------------------
ARGS     ?=
APP_NAME ?= toolbox

# ------------------------
# Installation
# ------------------------
PREFIX  ?= /usr/local
BINDIR  ?= $(PREFIX)/bin
INSTALL ?= install

############################################################
# Help
# ----------------------------------------------------------
# 	Desc:
# 		- List targets (default goal)
# 	Usage:
# 		- make
# 		- make help
#
############################################################

.PHONY: help
help:
	@echo "------------------------"
	@echo " > $(APP_NAME) targets"
	@echo "------------------------"
	@echo "  start        pull GHCR image and (re)create container"
	@echo "  start-local  build image locally and (re)create container"
	@echo "  pull         pull GHCR image only"
	@echo "  build        build image locally"
	@echo "  stop         stop and remove container"
	@echo "  host         privileged root shell on the host"
	@echo "  test         smoke test an image (IMAGE=...)"
	@echo "  install      install 'toolbox' wrapper into $(BINDIR)"
	@echo "  cicd         run CI workflow locally (act)"

############################################################
# Start
# ----------------------------------------------------------
# 	Desc:
# 		- Pull GHCR image and (re)create container
# 	Usage:
# 		- make start
# 		- make start TOOLBOX_VERSION=<tag>
# 	Tips:
# 		- tags: latest | X.Y.Z | weekly | edge
#
############################################################

.PHONY: start
start: pull
	@echo "------------------------"
	@echo " > Starting $(APP_NAME)..."
	@echo "------------------------"
	@$(LOAD_ENV)
	@$(CMD_COMPOSE) up --detach --force-recreate --pull never $(ARGS) $(APP_NAME)

############################################################
# Start (local)
# ----------------------------------------------------------
# 	Desc:
# 		- Build image locally and (re)create container
# 	Usage:
# 		- make start-local
# 	Tips:
# 		- make start-local ARGS=--progress=plain
#
############################################################

.PHONY: start-local
start-local: build
	@echo "------------------------"
	@echo " > Starting $(APP_NAME) (local build)..."
	@echo "------------------------"
	@$(LOAD_ENV)
	@$(CMD_COMPOSE) up --detach --force-recreate --pull never $(APP_NAME)

############################################################
# Pull
# ----------------------------------------------------------
# 	Desc:
# 		- Pull GHCR image
# 	Usage:
# 		- make pull
# 		- make pull TOOLBOX_VERSION=<tag>
#
############################################################

.PHONY: pull
pull:
	@echo "------------------------"
	@echo " > Pulling $(APP_NAME)..."
	@echo "------------------------"
	@$(LOAD_ENV)
	@$(CMD_COMPOSE) pull $(APP_NAME)

############################################################
# Build 
# ----------------------------------------------------------
# 	Desc:
# 		- Build application image locally
# 	Usage:
# 		- make build 
# 		- make build APP_NAME=<app>
# 	Tips:
# 		- make build ARGS=--no-cache
#
############################################################

.PHONY: build
build:
	@echo "------------------------"
	@echo " > Building $(APP_NAME)..."
	@echo "------------------------"
	@$(LOAD_ENV)
	@$(CMD_COMPOSE) build $(ARGS) $(APP_NAME)

############################################################
# Host
# ----------------------------------------------------------
# 	Desc:
# 		- Privileged root shell on the host (chroot /)
# 	Usage:
# 		- make host
#
############################################################

.PHONY: host
host:
	@./toolbox --host

############################################################
# Stop 
# ----------------------------------------------------------
# 	Desc:
# 		- Stop application 
# 	Usage:
# 		- make stop
# 		- make stop APP_NAME=<app>
#
############################################################

.PHONY: stop
stop:
	@echo "------------------------"
	@echo " > Stopping $(APP_NAME)..."
	@echo "------------------------"
	@$(LOAD_ENV)
	@$(CMD_COMPOSE) stop $(APP_NAME)
	@$(CMD_COMPOSE) rm -f $(APP_NAME)

############################################################
# Install 
# ----------------------------------------------------------
# 	Desc: 
# 		- Install `toolbox` into user bin directory
#
# 	Usage:
# 		- make install
# 		- sudo make install
#
############################################################

.PHONY: install
install:
	@echo "------------------------"
	@echo " > Install toolbox..."
	@echo "------------------------"
	@$(INSTALL) -d "$(BINDIR)"
	@$(INSTALL) -m 755 toolbox "$(BINDIR)/toolbox"

############################################################
# Test
# ---------------------------------------------------------
# 	Desc:
# 		- Smoke test a local image (tools, neovim, hygiene)
# 	Usage:
# 		- make test
# 		- make test IMAGE=ghcr.io/igor-sadza/toolbox:edge
#
############################################################

IMAGE ?= toolbox

.PHONY: test
test:
	@echo "------------------------"
	@echo " > Testing $(IMAGE)..."
	@echo "------------------------"
	@.cicd/tests/smoke.sh "$(IMAGE)"

############################################################
# CICD 
# ---------------------------------------------------------
# 	Desc:
# 		- Test cicd logic 
# 	Usage:
# 		- make cicd
#
############################################################

.PHONY: cicd 
cicd:
	@echo "------------------------"
	@echo " > Running cicd..."
	@echo "------------------------"
	@$(LOAD_ENV)
	@bash -c $(ACT_FILE)
