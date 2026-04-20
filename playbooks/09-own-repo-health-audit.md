---
profile: 09-own-repo-health-audit
version: 0.1.0
requires_refs:
  - "01"
  - "09#repo-as-data-artifact-checklist"
  - "09#monthly-repo-health-query-pack"
  - "15#repo-security-baseline"
requires_skills:
  - github-automation
---

# Playbook 09 — Own-Repo Health Audit

**When:** user asks "audit my repo" / "check repo health" / monthly check-in.
**Time budget:** 20-30 min.
**Output:** a markdown audit report at `state/audit-reports/<repo>-<date>.md`.

## Setup

### Step 1 — Confirm own-repo

Sniff must report `locus: own-repo` or `locus: fork`. If `someone-elses-repo`: wrong
profile — route to 02 or 07.

### Step 2 — Prepare audit report file

```bash
AUDIT_DIR="$HOME/.claude/skills/repo-craft/state/audit-reports"
mkdir -p "$AUDIT_DIR"
REPO_SLUG="$(git remote get-url origin | sed -E 's|.*[:/]([^/]+/[^/]+)(\.git)?$|\1|')"
AUDIT="$AUDIT_DIR/${REPO_SLUG//\//-}-$(date +%Y%m%d).md"
echo "# Audit: $REPO_SLUG — $(date +%F)" > "$AUDIT"
```

## Artifact checklist (26 items)

### Step 3 — Load the checklist

```bash
bash ~/.claude/skills/repo-craft/lib/load-ref.sh 09#repo-as-data-artifact-checklist
```

For each of the 26 artifacts, record presence + quality in the audit report.

### Step 4 — Community files check

```bash
for f in README.md LICENSE CONTRIBUTING.md CODE_OF_CONDUCT.md SECURITY.md \
         CODEOWNERS SUPPORT.md .github/FUNDING.yml CHANGELOG.md; do
  if git ls-files | grep -q "^$f$\|^\.github/$f$"; then
    echo "✓ $f" >> "$AUDIT"
  else
    echo "✗ $f (missing)" >> "$AUDIT"
  fi
done
```

### Step 5 — CI + workflows

```bash
echo "## CI Workflows" >> "$AUDIT"
find .github/workflows -name "*.yml" -o -name "*.yaml" 2>/dev/null | while read f; do
  echo "- $f" >> "$AUDIT"
done
```

### Step 6 — Branch protection (requires gh)

```bash
if command -v gh >/dev/null 2>&1; then
  echo "## Branch Protection" >> "$AUDIT"
  gh api "repos/$REPO_SLUG/rulesets" 2>/dev/null | jq -r '.[].name' >> "$AUDIT" || echo "(none or API error)" >> "$AUDIT"
fi
```

## Monthly health query pack

### Step 7 — Load queries

```bash
bash ~/.claude/skills/repo-craft/lib/load-ref.sh 09#monthly-repo-health-query-pack
```

Execute each query (10+ gh/GraphQL queries). Append results to audit report under
"## Health Metrics".

### Step 8 — DORA-ish metrics

```bash
# Merge rate (last 30d)
echo "## Merge Rate (30d)" >> "$AUDIT"
gh pr list --state merged --json mergedAt --limit 100 -q '[.[] | select(.mergedAt > (now - 30*86400 | todate))] | length' >> "$AUDIT"

# Median PR review latency
echo "## Review Latency p50 (30d)" >> "$AUDIT"
# (Formula: details in ref 09#observability-analytics)
```

## Security baseline

### Step 9 — Load security baseline

```bash
bash ~/.claude/skills/repo-craft/lib/load-ref.sh 15#repo-security-baseline
```

Check each of the 12 security priorities against the repo. Record gaps.

### Step 10 — Secret scanning + push protection

```bash
echo "## Secret Scanning" >> "$AUDIT"
gh api "repos/$REPO_SLUG" -q '{secret_scanning:.security_and_analysis.secret_scanning.status, push_protection:.security_and_analysis.secret_scanning_push_protection.status}' >> "$AUDIT"
```

### Step 11 — Dependabot + CodeQL

```bash
echo "## Dependabot/CodeQL" >> "$AUDIT"
[ -f .github/dependabot.yml ] && echo "✓ dependabot.yml" >> "$AUDIT" || echo "✗ dependabot.yml" >> "$AUDIT"
find .github/workflows -name "codeql*.yml" 2>/dev/null | grep -q . && echo "✓ CodeQL workflow" >> "$AUDIT" || echo "✗ CodeQL workflow" >> "$AUDIT"
```

## Summary

### Step 12 — Traffic-light summary

At top of audit report, prepend a one-paragraph summary with G/Y/R counts:
- Green: present and good
- Yellow: present but needs work
- Red: missing entirely

### Step 13 — Propose next actions

List top 3-5 concrete next actions (file X, enable Y, audit Z).

### Step 14 — Single next-step recommendation

Pick the HIGHEST-ROI single action. Surface it as the ONE next step.

### Step 15 — Update memory

```bash
bash ~/.claude/skills/repo-craft/lib/remember.sh repos "$REPO_SLUG" "$(jq -n --arg p '09-own-repo-health-audit' --arg ts "$(date -u +%FT%TZ)" --arg audit "$AUDIT" '{profile:$p, ts:$ts, last_audit:$audit}')"
```

## Graceful degradation

If `gh` missing: skip API-requiring steps (6, 8, 10, 11). File-only audit is still
useful (steps 3-5, 9).
