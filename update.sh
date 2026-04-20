#!/usr/bin/env bash
# update.sh — update installed repo-craft to latest source, preserving state/
# Usage: update.sh [--source <path>] [--force]
set -euo pipefail

TARGET="${REPO_CRAFT_INSTALL_DIR:-$HOME/.claude/skills/repo-craft}"
SOURCE="${REPO_CRAFT_SOURCE_DIR:-D:/My Drive/AI Ecosystem/Skill and Gem Creation/Skills/_current/repo-craft}"
FORCE=0

while [ $# -gt 0 ]; do
  case "$1" in
    --source) SOURCE="$2"; shift 2 ;;
    --force)  FORCE=1; shift ;;
    *) echo "Unknown arg: $1" >&2; exit 2 ;;
  esac
done

if [ ! -d "$TARGET" ]; then
  echo "[repo-craft] ERROR: not installed at $TARGET. Run install.sh first." >&2
  exit 1
fi

# Backup state/ before touching anything
BACKUP="$TARGET/state.backup.$(date +%Y%m%d_%H%M%S)"
if [ -d "$TARGET/state" ]; then
  cp -a "$TARGET/state" "$BACKUP"
  echo "[repo-craft] state backup: $BACKUP"
fi

# Read versions
old_version=$(cat "$TARGET/VERSION" 2>/dev/null || echo "unknown")
new_version=$(cat "$SOURCE/VERSION" 2>/dev/null || echo "unknown")
echo "[repo-craft] updating: $old_version → $new_version"

# Refuse no-op unless --force
if [ "$old_version" = "$new_version" ] && [ "$FORCE" -eq 0 ]; then
  echo "[repo-craft] already at $new_version. Use --force to reinstall." >&2
  exit 0
fi

# Apply via install.sh for consistency
REPO_CRAFT_INSTALL_DIR="$TARGET" bash "$SOURCE/install.sh"

# Restore state from backup (safety net)
if [ -d "$BACKUP" ]; then
  mkdir -p "$TARGET/state"
  cp -a "$BACKUP/." "$TARGET/state/"
fi

chmod +x "$TARGET"/*.sh 2>/dev/null || true
chmod +x "$TARGET"/lib/*.sh 2>/dev/null || true

echo "[repo-craft] update complete (now at $new_version)"
echo "[repo-craft] state preserved; backup at $BACKUP"
