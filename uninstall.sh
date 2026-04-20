#!/usr/bin/env bash
# uninstall.sh — remove repo-craft. Zero residue by default.
# Usage: uninstall.sh [--keep-state] [--yes]
set -euo pipefail

TARGET="${REPO_CRAFT_INSTALL_DIR:-$HOME/.claude/skills/repo-craft}"
KEEP_STATE=0
AUTO_YES=0

while [ $# -gt 0 ]; do
  case "$1" in
    --keep-state) KEEP_STATE=1; shift ;;
    --yes|-y)     AUTO_YES=1; shift ;;
    *) echo "Unknown arg: $1" >&2; exit 2 ;;
  esac
done

if [ ! -d "$TARGET" ]; then
  echo "[repo-craft] not installed at $TARGET — nothing to do"
  exit 0
fi

# Confirm unless --yes
if [ "$AUTO_YES" -eq 0 ]; then
  echo "This will remove $TARGET"
  [ "$KEEP_STATE" -eq 1 ] && echo "(state/ will be moved to ~/.repo-craft-state-backup-*)"
  read -p "Continue? [y/N] " -n 1 -r
  echo
  [[ ! "$REPLY" =~ ^[Yy]$ ]] && { echo "aborted"; exit 0; }
fi

# Optional state preservation
if [ "$KEEP_STATE" -eq 1 ] && [ -d "$TARGET/state" ]; then
  BACKUP="$HOME/.repo-craft-state-backup-$(date +%Y%m%d_%H%M%S)"
  mv "$TARGET/state" "$BACKUP"
  echo "[repo-craft] state preserved at: $BACKUP"
fi

# Remove
rm -rf "$TARGET"
echo "[repo-craft] uninstalled. Zero residue."
echo "[repo-craft] (no edits to settings.json were made; nothing else to clean up)"
