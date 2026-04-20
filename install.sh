#!/usr/bin/env bash
# install.sh — copy repo-craft into ~/.claude/skills/repo-craft/
# Idempotent. No edits to settings.json. No hooks. No MCP servers.
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
TARGET="${REPO_CRAFT_INSTALL_DIR:-$HOME/.claude/skills/repo-craft}"

echo "[repo-craft] installing from $HERE → $TARGET"

# Required deps check
for cmd in git jq awk sed; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "[repo-craft] ERROR: required command '$cmd' not found in PATH" >&2
    exit 1
  fi
done

# Optional deps check (warn but do not fail)
for cmd in gh; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "[repo-craft] NOTE: optional command '$cmd' not found. Some flows will degrade."
  fi
done

# Preserve existing state/ before wiping target
BACKUP_STATE=""
if [ -d "$TARGET/state" ]; then
  BACKUP_STATE=$(mktemp -d)
  cp -a "$TARGET/state/." "$BACKUP_STATE/"
fi

# Create target dir and copy
mkdir -p "$TARGET"

if command -v rsync >/dev/null 2>&1; then
  rsync -a --delete \
    --exclude='.git/' \
    --exclude='.gitattributes' \
    --exclude='*.test.sh' \
    --exclude='install.log' \
    --exclude='e2e.sh' \
    "$HERE/" "$TARGET/"
else
  # Portable fallback: wipe target contents (preserve dir) then copy
  find "$TARGET" -mindepth 1 -maxdepth 1 -not -name 'state' -exec rm -rf {} +
  cp -r "$HERE/." "$TARGET/"
  rm -rf "$TARGET/.git" 2>/dev/null || true
  rm -f "$TARGET/.gitattributes" 2>/dev/null || true
  find "$TARGET" -name "*.test.sh" -type f -delete 2>/dev/null || true
  rm -f "$TARGET/install.log" "$TARGET/e2e.sh" 2>/dev/null || true
fi

# Restore state from backup
if [ -n "$BACKUP_STATE" ] && [ -d "$BACKUP_STATE" ]; then
  mkdir -p "$TARGET/state"
  cp -a "$BACKUP_STATE/." "$TARGET/state/"
  rm -rf "$BACKUP_STATE"
fi

# Chmod scripts
chmod +x "$TARGET"/*.sh 2>/dev/null || true
chmod +x "$TARGET"/lib/*.sh 2>/dev/null || true

# Ensure state dir + gitkeep
if [ ! -f "$TARGET/state/.gitkeep" ]; then
  mkdir -p "$TARGET/state"
  touch "$TARGET/state/.gitkeep"
fi

# Verify structure
for f in SKILL.md VERSION CHANGELOG.md README.md install.sh uninstall.sh update.sh \
         lib/sniff.sh lib/load-ref.sh lib/remember.sh lib/recall.sh lib/common.sh \
         references/INDEX.md \
         playbooks/02-first-time-contributor.md \
         playbooks/07-fork-contribute.md \
         playbooks/08-upstream-sync.md \
         playbooks/09-own-repo-health-audit.md; do
  if [ ! -f "$TARGET/$f" ]; then
    echo "[repo-craft] ERROR: missing file after install: $f" >&2
    exit 2
  fi
done

version=$(cat "$TARGET/VERSION")
echo "[repo-craft] install complete (v$version)"
echo "[repo-craft] installed to: $TARGET"
echo "[repo-craft] trigger keywords: contribute to, fork, upstream, repo health, author fit, ..."
echo "[repo-craft] test with: /repo-craft help"
