#!/usr/bin/env bash
# Test lib/sniff.sh
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
SNIFF="$HERE/sniff.sh"

fail() { echo "FAIL: $1" >&2; exit 1; }
pass() { echo "PASS: $1"; }

# Test 1: outside any git repo → "off-repo"
tmp=$(mktemp -d)
cd "$tmp"
out=$("$SNIFF")
echo "$out" | grep -q '"locus":"off-repo"\|"locus": "off-repo"' || fail "off-repo detection"
pass "off-repo detection"

# Test 2: inside a fresh git repo with no remote → "own-repo"
cd "$tmp"
git init -q repo-own
cd repo-own
out=$("$SNIFF")
echo "$out" | grep -q '"locus":"own-repo"\|"locus": "own-repo"' || fail "own-repo detection"
pass "own-repo detection"

# Test 3: JSON is valid
echo "$out" | jq -e . >/dev/null || fail "JSON output is valid"
pass "JSON output is valid"

# Cleanup
cd /
rm -rf "$tmp"
echo "ALL TESTS PASSED"
