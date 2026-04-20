#!/usr/bin/env bash
# common.sh — shared helpers for repo-craft lib scripts
# Not standalone — meant to be sourced.

# Fail fast on unset vars and errors
set -euo pipefail

# Locate skill root regardless of where script is sourced from
_repo_craft_root() {
  local dir
  dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
  echo "$dir"
}
REPO_CRAFT_ROOT="${REPO_CRAFT_ROOT:-$(_repo_craft_root)}"
REPO_CRAFT_REFS_DIR="${REPO_CRAFT_REFS_DIR:-$REPO_CRAFT_ROOT/references}"
REPO_CRAFT_PLAYBOOKS_DIR="${REPO_CRAFT_PLAYBOOKS_DIR:-$REPO_CRAFT_ROOT/playbooks}"
REPO_CRAFT_STATE_DIR="${REPO_CRAFT_STATE_DIR:-$REPO_CRAFT_ROOT/state}"

# Log levels
log_info()  { echo "[repo-craft] $*"; }
log_warn()  { echo "[repo-craft] WARN: $*" >&2; }
log_error() { echo "[repo-craft] ERROR: $*" >&2; }

# Check for required commands; return 0/1
require_cmd() {
  local cmd="$1"
  command -v "$cmd" >/dev/null 2>&1
}

# Graceful degradation notice
note_missing() {
  local cmd="$1"
  local install_hint="$2"
  log_warn "required command '$cmd' not found. $install_hint"
  log_warn "continuing with degraded flow."
}

export REPO_CRAFT_ROOT REPO_CRAFT_REFS_DIR REPO_CRAFT_PLAYBOOKS_DIR REPO_CRAFT_STATE_DIR
