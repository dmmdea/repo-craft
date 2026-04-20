#!/usr/bin/env bash
# recall.sh — read a key from state/$1.json
# Usage: recall.sh <bucket> <key>
# Exit 1 if key absent.
set -euo pipefail

SELF_DIR="$(cd "$(dirname "$0")" && pwd)"
STATE_DIR="${REPO_CRAFT_STATE_DIR:-$SELF_DIR/../state}"

BUCKET="${1:?bucket required}"
KEY="${2:?key required}"

FILE="$STATE_DIR/${BUCKET}.json"
[ -f "$FILE" ] || { echo "bucket not found" >&2; exit 1; }

val=$(jq --arg k "$KEY" '.[$k]' "$FILE")
if [ "$val" = "null" ]; then
  echo "key not found" >&2
  exit 1
fi
echo "$val"
