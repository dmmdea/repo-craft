#!/usr/bin/env bash
# remember.sh — write a key/value into state/$1.json
# Usage: remember.sh <bucket> <key> <json-value>
set -euo pipefail

SELF_DIR="$(cd "$(dirname "$0")" && pwd)"
STATE_DIR="${REPO_CRAFT_STATE_DIR:-$SELF_DIR/../state}"
mkdir -p "$STATE_DIR"

BUCKET="${1:?bucket required}"
KEY="${2:?key required}"
VAL="${3:?value required (JSON)}"

FILE="$STATE_DIR/${BUCKET}.json"
[ -f "$FILE" ] || echo '{}' > "$FILE"

tmp=$(mktemp)
jq --arg k "$KEY" --argjson v "$VAL" '.[$k] = $v' "$FILE" > "$tmp" && mv "$tmp" "$FILE"
