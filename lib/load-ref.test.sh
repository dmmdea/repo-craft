#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
LOADER="$HERE/load-ref.sh"
REFS="$HERE/../references"

fail() { echo "FAIL: $1" >&2; exit 1; }
pass() { echo "PASS: $1"; }

# Create a fixture reference file
mkdir -p "$REFS"
cat > "$REFS/99-fixture.md" <<'EOF'
# Fixture

## intro-section

This is the intro.

## body-section

This is the body.
Multiple lines here.

## tail-section

Tail content.
EOF

# Test 1: extract full file
out=$("$LOADER" "99")
echo "$out" | grep -q "# Fixture" || fail "extract full file"
pass "extract full file"

# Test 2: extract named section
out=$("$LOADER" "99#body-section")
echo "$out" | grep -q "This is the body" || fail "extract body-section"
if echo "$out" | grep -q "This is the intro"; then
  fail "should NOT include intro"
fi
pass "extract body-section only"

# Test 3: missing file → exit 1
if "$LOADER" "999" 2>/dev/null; then
  fail "missing file should exit 1"
fi
pass "missing file error"

# Cleanup
rm -f "$REFS/99-fixture.md"
echo "ALL TESTS PASSED"
