#!/usr/bin/env bash
# e2e.sh — end-to-end install → validate → uninstall
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
SCRATCH="${REPO_CRAFT_E2E_DIR:-/tmp/repo-craft-e2e}"

pass() { echo "PASS: $1"; }
fail() { echo "FAIL: $1" >&2; exit 1; }

rm -rf "$SCRATCH"

echo "=== INSTALL ==="
REPO_CRAFT_INSTALL_DIR="$SCRATCH" bash "$HERE/install.sh"

echo "=== STRUCTURE CHECK ==="
required=(
  SKILL.md VERSION CHANGELOG.md README.md install.sh uninstall.sh update.sh
  lib/sniff.sh lib/load-ref.sh lib/remember.sh lib/recall.sh lib/common.sh
  references/INDEX.md references/01-repo-management.md references/16-security-sources.md
  playbooks/02-first-time-contributor.md playbooks/09-own-repo-health-audit.md
)
for f in "${required[@]}"; do
  [ -f "$SCRATCH/$f" ] || fail "missing: $f"
done
pass "all required files present"

echo "=== SNIFF ==="
bash "$SCRATCH/lib/sniff.sh" | jq -e .locus >/dev/null || fail "sniff JSON"
pass "sniff JSON valid"

echo "=== LOAD-REF ==="
bash "$SCRATCH/lib/load-ref.sh" 02 | grep -qi "contribut" || fail "load-ref full"
pass "load-ref full"

bash "$SCRATCH/lib/load-ref.sh" 06#pre-pr-ritual | grep -q "Pre-PR Ritual" || fail "load-ref anchor"
pass "load-ref anchor (06#pre-pr-ritual)"

echo "=== MEMORY ==="
REPO_CRAFT_STATE_DIR="$SCRATCH/state" bash "$SCRATCH/lib/remember.sh" repos test/e2e '{"p":"t"}'
REPO_CRAFT_STATE_DIR="$SCRATCH/state" bash "$SCRATCH/lib/recall.sh" repos test/e2e | grep -q '"p":"t"\|"p": "t"' || fail "memory roundtrip"
pass "memory roundtrip"

echo "=== UNINSTALL ==="
REPO_CRAFT_INSTALL_DIR="$SCRATCH" bash "$HERE/uninstall.sh" --yes
[ -d "$SCRATCH" ] && fail "residue remains" || pass "zero residue"

echo ""
echo "ALL E2E TESTS PASSED"
