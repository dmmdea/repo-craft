#!/usr/bin/env bash
# remember.sh — write a key/value into state/$1.json
# Usage: remember.sh <bucket> <key> <json-value>
#
# Schema (bucket: repos)
#   key:   "<owner>/<repo>"
#   value: arbitrary JSON object. Recommended fields (none required):
#     profile       string  e.g. "02-first-time-contributor"
#     ts            string  UTC ISO-8601 of last update
#     cla           string  "yes" | "no" | "unknown"
#     dco           string  "yes" | "no" | "unknown"
#     status        string  "awaiting-reporter-response" | "pr-open" | "merged" | "rejected" | "stale"
#     pending_issue string  issue number this flow is gated on
#     comment_url   string  URL of coordinating comment, if any
#   Custom fields are allowed; readers MUST ignore unknown keys.
#
# Schema (bucket: open_prs)
#   key:   "<owner>/<repo>#<N>"
#   value: { url, opened_ts, [merged_ts], [status] }
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
