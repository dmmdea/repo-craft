#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
export REPO_CRAFT_STATE_DIR="$(mktemp -d)"
REMEMBER="$HERE/remember.sh"
RECALL="$HERE/recall.sh"

fail() { echo "FAIL: $1" >&2; exit 1; }
pass() { echo "PASS: $1"; }

# Test 1: remember + recall a repos entry
"$REMEMBER" repos ryaker/zora '{"profile":"07-fork-contribute","ts":"2026-04-20T00:00:00Z"}'
val=$("$RECALL" repos ryaker/zora)
echo "$val" | jq -e '.profile == "07-fork-contribute"' >/dev/null || fail "repos round-trip"
pass "repos round-trip"

# Test 2: remember + recall preferences
"$REMEMBER" preferences signing '"gitsign"'
val=$("$RECALL" preferences signing)
[ "$val" = '"gitsign"' ] || fail "preferences round-trip"
pass "preferences round-trip"

# Test 3: recall missing key → empty + exit 1
if "$RECALL" repos nonexistent 2>/dev/null; then
  fail "missing key should exit 1"
fi
pass "missing key error"

rm -rf "$REPO_CRAFT_STATE_DIR"
echo "ALL TESTS PASSED"
