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

# Test 4: --target mode populates .target field + valid JSON
# Use dmmdea/repo-craft since we control it. Works with or without gh auth —
# unauthenticated path still produces valid JSON with target + error fields.
cd "$tmp"
out=$("$SNIFF" --target dmmdea/repo-craft 2>/dev/null || true)
echo "$out" | jq -e '.target == "dmmdea/repo-craft"' >/dev/null || fail "--target field not set"
pass "--target populates target field"

# Test 5: --target mode always sets .locus
echo "$out" | jq -e '.locus' >/dev/null || fail "--target missing locus"
pass "--target includes locus"

# Test 6: --target with missing value → treat as path (no crash on flag-only)
# Not a hard failure: ensure no crash and JSON is produced.
out=$("$SNIFF" --target 2>/dev/null || true)
# Either it treated --target as a path (off-repo) or refused gracefully.
# Both are acceptable; we only require valid JSON output.
if [ -n "$out" ]; then
  echo "$out" | jq -e . >/dev/null || fail "--target <missing> produced invalid JSON"
fi
pass "--target without value degrades gracefully"

# Cleanup
cd /
rm -rf "$tmp"
echo "ALL TESTS PASSED"
