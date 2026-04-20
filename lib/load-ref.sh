#!/usr/bin/env bash
# load-ref.sh — extract a reference file or a specific H2 section
# Usage:
#   load-ref.sh 06                        → full file 06-*.md
#   load-ref.sh 06#author-mind-model      → just that H2 section
set -euo pipefail

SELF_DIR="$(cd "$(dirname "$0")" && pwd)"
REFS_DIR="${REPO_CRAFT_REFS_DIR:-$SELF_DIR/../references}"

ARG="${1:-}"
if [ -z "$ARG" ]; then
  echo "Usage: load-ref.sh NN[#section-anchor]" >&2
  exit 2
fi

# Parse NN and optional #anchor
NN="${ARG%%#*}"
ANCHOR=""
if [[ "$ARG" == *"#"* ]]; then
  ANCHOR="${ARG#*#}"
fi

# Find file by NN prefix
FILE=$(find "$REFS_DIR" -maxdepth 1 -name "${NN}-*.md" | head -n 1)
if [ -z "$FILE" ] || [ ! -f "$FILE" ]; then
  echo "Reference file ${NN}-*.md not found in $REFS_DIR" >&2
  exit 1
fi

# No anchor → emit whole file
if [ -z "$ANCHOR" ]; then
  cat "$FILE"
  exit 0
fi

# Extract H2 section matching the anchor
# Anchor matches any H2 whose slugified text equals $ANCHOR.
# Slug rule: lowercase, spaces → dashes, strip punctuation.
awk -v anchor="$ANCHOR" '
function slug(s,   t) {
  t = tolower(s);
  gsub(/[^a-z0-9 -]/, "", t);
  gsub(/ +/, "-", t);
  gsub(/-+/, "-", t);
  sub(/^-/, "", t); sub(/-$/, "", t);
  return t;
}
/^## / {
  title = substr($0, 4);
  gsub(/^[ \t]+|[ \t]+$/, "", title);
  current = slug(title);
  if (in_section) { exit }
  if (current == anchor) { in_section = 1; print; next }
}
in_section { print }
' "$FILE"
