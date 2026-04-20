---
profile: 07-fork-contribute
version: 0.1.0
requires_refs:
  - "02"
  - "07#lifecycle-stability"
  - "07#security-supply-chain"
requires_skills:
  - create-branch
  - commit
  - pr-writer
  - create-pr
  - git-advanced-workflows
---

# Playbook 07 — Fork Contribute (long-lived fork)

**When:** maintaining a fork of a project you don't own (upstream may/may not accept changes).
**Goal:** upstream-first contribution with local patch hygiene for anything upstream won't accept.

## Setup (once per fork)

### Step 1 — Verify fork remotes

```bash
git remote -v
```

Expected: `origin` = your fork, `upstream` = original. If `upstream` missing:

```bash
git remote add upstream <original-url>
git fetch upstream
```

### Step 2 — Record fork in memory

```bash
bash ~/.claude/skills/repo-craft/lib/remember.sh repos <owner>/<upstream-repo> "$(jq -n --arg p '07-fork-contribute' --arg ts "$(date -u +%FT%TZ)" --arg fork_of '<owner>/<repo>' '{profile:$p, ts:$ts, fork_of:$fork_of}')"
```

## Per-change flow

### Step 3 — Sync fork with upstream FIRST

```bash
git fetch upstream
git checkout main
git merge --ff-only upstream/main || git rebase upstream/main
git push origin main
```

If conflicts: route to [Playbook 08 — upstream-sync](./08-upstream-sync.md).

### Step 4 — Identify: upstream-able or local-only?

Decision:
- **Upstream-able** (bug fix, small feature, maintainer-aligned) → normal PR flow
- **Local-only** (local config, org-specific branding) → keep on a local `patches/*` branch, never PR

### Step 5 — Branch

Invoke `create-branch`. For upstream-able: `fix/<short>` or `feat/<short>`.
For local-only: `patches/<short>` — clearly marked.

### Step 6 — Commit discipline

Invoke `commit`. For upstream-able: Conventional Commits + DCO/signing per upstream.
For local-only: same conventions but label subject with `[local]`.

### Step 7 — For upstream-able, open PR to upstream (not to your fork)

Invoke `pr-writer` + `create-pr` with `--repo <upstream-owner>/<upstream-repo>`.

### Step 8 — For local-only: tag in your fork

```bash
git tag local/<version>-<date> -m "local patches on top of upstream <upstream-tag>"
git push origin --tags
```

### Step 9 — Persist patches log

Maintain `~/.claude/skills/repo-craft/state/fork-patches/<owner>-<repo>.md`
listing local-only patches with: purpose, upstream-catchup-condition, risk.

## Upstream catch-up ritual (monthly)

### Step 10 — Check for upstream catch-up

For each local-only patch, check: has upstream shipped an equivalent? If yes:
retire the local patch.

### Step 11 — Report drift

```bash
git log --oneline upstream/main..origin/main | head -20
```

If drift exceeds threshold (30+ commits behind), escalate — may need a rebase window.

## Anti-patterns

- Never force-push to `upstream/*` refs (you can't anyway, but don't try)
- Never mix upstream-able and local-only commits on the same branch
- Never PR local-only patches to upstream
