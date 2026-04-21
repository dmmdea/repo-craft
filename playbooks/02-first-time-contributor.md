---
profile: 02-first-time-contributor
version: 0.1.0
requires_refs:
  - "02"
  - "06#pre-pr-ritual"
  - "08#anti-patterns"
  - "10"
  - "14"
requires_skills:
  - superpowers:brainstorming
  - create-branch
  - commit
  - pr-writer
  - create-pr
  - superpowers:requesting-code-review
---

# Playbook 02 — First-Time Contributor

**When:** non-trivial change + never merged to this repo before.
**Time budget:** 30-45 min ritual + implementation time.
**Goal:** first PR that matches maintainer expectations; build trust for future work.

## Pre-ritual (do before writing any code)

### Step 1 — Load refs

```bash
bash ~/.claude/skills/repo-craft/lib/load-ref.sh 06#pre-pr-ritual
```

Follow the 10-step pre-PR ritual with G/Y/R scoring. Step 10 (full local test
suite) is expensive; for issue-first paths (4a, 4c), defer step 10 until after
maintainer engagement lands. Score steps 1-9 first and decide the path.

If ≥2 reds, STOP. If an issue does not yet exist, open one (path 4a). If an issue
does exist, post a coordination comment (path 4c) — do not open a new meta-issue.

### Step 2 — Author profile

Is the maintainer profiled in ref 14? If yes:

```bash
bash ~/.claude/skills/repo-craft/lib/load-ref.sh 14#<maintainer-slug>
```

If not profiled: build a quick profile by sampling last 3 merged PRs + maintainer's
last blog/tweet if available. 5 min max.

### Step 3 — CONTRIBUTING + CODE_OF_CONDUCT

Read fully, not skim. Note: issue-first required? CLA required? Conventional Commits
enforced? Branch naming convention? DCO? Test requirements?

Record findings in memory:

```bash
bash ~/.claude/skills/repo-craft/lib/remember.sh repos <owner>/<repo> "$(jq -n --arg p '02-first-time-contributor' --arg ts "$(date -u +%FT%TZ)" --arg cla "<yes|no>" --arg dco "<yes|no>" '{profile:$p, ts:$ts, cla:$cla, dco:$dco}')"
```

### Step 4 — Issue-first path (branch on existing issue state)

First determine which branch applies:

**4a. No issue exists for this change.**

Load templates and create one:

```bash
bash ~/.claude/skills/repo-craft/lib/load-ref.sh 10#issue-body-templates
```

Invoke `github-issue-creator` or `issues` skill. Wait for maintainer engagement
before PR unless you're 100% sure of direction and CONTRIBUTING waives issue-first.

**4b. Issue exists, no prior reporter patch or PR.**

Proceed to PR flow (step 5+). Reference the issue in PR body (`Closes #N`).

**4c. Issue exists AND the reporter already has a patch or opened/closed PR.**

DO NOT open a competing PR. Coordinate first:

1. Post ONE comment on the issue asking the reporter if they still intend to
   submit, and the maintainer for scoping direction. Offer `Co-authored-by:`
   attribution if you proceed. Keep under 150 words, no status-bump language,
   no off-hours @-mentions (see ref 08#anti-patterns).
2. Record the coordination state:
   ```bash
   bash ~/.claude/skills/repo-craft/lib/remember.sh repos <owner>/<repo> \
     "$(jq -n --arg p '02-first-time-contributor' --arg ts "$(date -u +%FT%TZ)" \
        --arg status 'awaiting-reporter-response' --arg issue '<N>' \
        --arg comment_url '<url>' \
        '{profile:$p, ts:$ts, status:$status, pending_issue:$issue, comment_url:$comment_url}')"
   ```
3. Wait 3-5 business days. On resumption: if reporter consents or stays silent,
   proceed to step 5+ with full attribution. If reporter reopens their own PR,
   close this flow and offer review instead.

**4d. Ritual rubric override.**

If the pre-PR ritual (step 1) scored 0R/≥4Y AND an issue already exists, prefer
path 4c (coordinate-via-comment) over opening yet another issue. A new meta-issue
adds noise; a comment on the existing issue is the correct remedy.

## PR flow

### Step 5 — Brainstorm the approach

Invoke `superpowers:brainstorming` to scope the change. Surface alternatives.
Check `05#roadmap-alignment` (ref 05, if loaded) for any explicit non-goals.

### Step 6 — Create branch

Invoke `create-branch`. Branch name format: match existing convention in recent
merged PRs (common: `fix/<short-desc>`, `feat/<short-desc>`).

### Step 7 — Implement + commit

For each atomic change: invoke `commit` with Conventional Commits, DCO sign-off if
required. Keep PRs < 400 LOC (see ref 02).

### Step 8 — Write PR body

Load templates:

```bash
bash ~/.claude/skills/repo-craft/lib/load-ref.sh 10#pr-body-templates
```

Invoke `pr-writer`. Body MUST include: problem, approach, test plan, linked issue.

### Step 9 — Open PR

Invoke `create-pr`. Mark as draft if large or if you want preview feedback.

### Step 10 — Record outcome

```bash
bash ~/.claude/skills/repo-craft/lib/remember.sh open_prs <owner>/<repo>#<N> "$(jq -n --arg url "<pr-url>" --arg ts "$(date -u +%FT%TZ)" '{url:$url, opened_ts:$ts}')"
```

## After PR

### Step 11 — Review response

When review lands: invoke `superpowers:receiving-code-review`. Use fixup commits,
not amend+force on shared branches. See ref 02#commit-discipline.

### Step 12 — Update memory on merge/close

On merge or close, update `state/repos.json` with outcome (merged/rejected/stale)
for future profile picking (profile 03-known-repo-contributor).

## Anti-patterns to avoid

Load:

```bash
bash ~/.claude/skills/repo-craft/lib/load-ref.sh 08#anti-patterns
```

Do not: status-bump, @-mention across weekends, reopen closed PRs, lecture
maintainers, submit unsolicited rewrites, drive-by LGTM, litigate CoC.
