> **Consult this if:** preparing a first non-trivial PR, needing to understand a project beyond surface metadata, or modeling a maintainer's mental model before engaging.
>
> **Cross-refs:** [02](./02-contribution.md) · [08](./08-influence.md) · [14](./14-maintainer-profiles.md)

## Table of Contents

- [Project Archaeology](#project-archaeology)
- [Author Mind-Model](#author-mind-model)
- [ADR RFC Reading](#adr-rfc-reading)
- [Closed PR Analysis](#closed-pr-analysis)
- [Label Taxonomy Reading](#label-taxonomy-reading)
- [GitHub Projects and Milestones](#github-projects-and-milestones)
- [Pre-PR Ritual](#pre-pr-ritual)

---

# Project Archaeology and Author Mind-Modeling

*Research slice for the GitHub contribution skill — how to deeply understand a project and its author(s) before contributing, so contributions flow in the author's grain rather than against it.*

---

## Framing

Structural metadata (language, license, LOC, CI config) tells you *what* a project is. It does not tell you *how the maintainers think*. A pull request written against structural metadata reads like a stranger at a dinner party — technically present, tonally off. The contributions that land cleanly are written by people who have internalized the project's voice: its decision taste, its rhetorical register, its list of pre-rejected ideas, its unwritten "we don't do that here" rules.

This document is a playbook the skill can execute on any target repo. It has three parts:

- **Part A** — Project archaeology: thirteen signals the repository itself emits, where to find them, what they mean, and how to surface them.
- **Part B** — Author mind-modeling: twelve external channels that reveal the human behind the keyboard, with extraction guidance.
- **Part C** — A concrete 30-minute pre-PR ritual with green/yellow/red criteria for "author-fit".

Design constraint: every signal must be extractable by an agent with `gh`, `git`, `curl`, and an HTML parser. When a signal requires human judgement (tone, posture), the skill summarizes raw excerpts and asks the user to score. The skill never fabricates sentiment it cannot back with quotes.

---

## Project Archaeology

### A1. Architecture Decision Records (ADRs)

**Where.** `docs/adr/`, `docs/decisions/`, `adr/`, `.adr/`, `architecture/decisions/`, sometimes `doc/arch/`. Usually markdown, numbered `0001-title.md`, `ADR-001-title.md`, or `0001-title.md` following Michael Nygard's template (Status, Context, Decision, Consequences). Some projects put them in a wiki or in a single `DECISIONS.md`.

**What it tells you.** ADRs document *irrevocable* choices and — critically — the *alternatives that were rejected*. They are the single highest-signal artifact for understanding the project's taste. If a project has ADRs, proposing something that contradicts an accepted ADR without first arguing against the ADR is a guaranteed rejection.

**Extract.** For each ADR: status (Proposed / Accepted / Deprecated / Superseded), the one-line decision, and the "Alternatives considered" section verbatim. Cross-index so the skill can answer "is there an ADR that touches X?".

**Surface as.** A compact table in the pre-PR briefing: `ADR-0012 (Accepted) — We use SQLite, not Postgres. Rejected: Postgres, DuckDB. Reason: zero-install footprint.`

### A2. CHANGELOG tone and granularity

**Where.** `CHANGELOG.md`, `HISTORY.md`, `NEWS.md`, `docs/changelog/`, or auto-generated release notes on GitHub.

**What it tells you.** Does the project follow [Keep a Changelog](https://keepachangelog.com) with strict Added / Changed / Deprecated / Removed / Fixed / Security headers? Terse bullets ("fix: off-by-one in `foo`") vs. prose ("This release reworks how we handle…")? User-facing vs. developer-facing language? Are breaking changes called out with `BREAKING:` prefixes or dedicated sections? Do they write in first-person plural ("we"), second-person ("you can now"), or passive voice?

**Extract.** Last 5 entries fully. Tag: format (semantic / prose / hybrid), voice (we/you/passive), breaking-change convention, contributor-credit convention (`@handle`, `#PR`, both, neither).

**Surface as.** A short style card: "CHANGELOG = Keep a Changelog format; second-person voice; always credits contributors as `@handle (#123)`; breaking changes get their own subsection above Added."

### A3. Commit message archaeology

**Where.** `git log`.

**Commands.**
- `git log --oneline -n 200` — subject-line granularity.
- `git log -n 30` — full bodies on recent commits.
- `git log -n 20 --author="<maintainer>"` — maintainer's own style.
- `git log -n 20 -- <hot-file>` — style on files you're likely to touch.
- `git log --grep='^fix\|^feat\|^chore'` — does Conventional Commits rule?

**What it tells you.** Subject-line length cap (often 50 or 72 chars). Imperative vs. past tense ("Add" vs. "Added"). Conventional Commits adoption (`feat(scope):`). Whether commits reference issue/PR numbers (`Fixes #123`). Body prose: do they explain *why*, or just *what*? Do they quote the bug? Include benchmark numbers?

**Extract.** Subject-line median length; tense; scope pattern; body presence rate; issue-reference rate; sign-off usage (`Signed-off-by:`, DCO).

**Surface as.** A commit-message template the skill will use: `"feat(parser): <50-char imperative>\n\n<why prose, 2-3 sentences>\n\nFixes #<n>\nSigned-off-by: <you>"`.

### A4. Closed but not merged PRs

**Where.** `gh pr list --state closed --limit 100 --json number,title,mergedAt,author,labels,closedAt --jq '.[] | select(.mergedAt == null)'`.

**What it tells you.** The project's no-go list. Rejection reasons reveal values: "out of scope", "we don't want to maintain this", "please open an issue first", "against ADR-0007", "duplicate of #123", "stale, closing — open a fresh one when ready". The tone used — patient/educational vs. terse/annoyed — tells you the maintainer's bandwidth and politics.

**Extract.** For each: title, closer, final comment from a maintainer (verbatim), label tags (`wontfix`, `invalid`, `stale`, `needs-discussion`).

**Surface as.** A "how PRs die here" note listing the top 5 rejection categories with example quotes. E.g., "Most-rejected: missing tests (12/30), out-of-scope (8/30), bypassed RFC (5/30)."

### A5. Issue triage patterns

**Where.** `gh issue list --state closed --limit 200 --json number,title,labels,closedAt,comments`.

**What it tells you.** What gets labelled `wontfix`, `by-design`, `duplicate`, `needs-repro`, `help wanted`, `good first issue`, `triage`. Median time-to-first-response. Whether issues close with a comment or silently. Whether the bot closes stale issues automatically.

**Extract.** Label frequency histogram; time-to-first-response p50 and p90; stale-bot presence; close-with-comment rate.

**Surface as.** A responsiveness card: "Median time-to-first-response: 3 days. Stale bot closes after 30 days of no activity. `wontfix` is rare (6% of closed) — used only for deliberate scope decisions."

### A6. Label taxonomy

**Where.** `gh label list --limit 200`.

**What it tells you.** Density of the labelling system is a leading indicator of project maturity. Kubernetes-style prefixed labels (`kind/bug`, `area/api`, `priority/p1`, `triage/accepted`, `sig/network`) signal a formal SIG-based governance. A flat list of 6 labels signals a personal project. Some projects use labels to auto-route: `needs-triage`, `needs-review`, `needs-merge`.

**Extract.** Prefixed vs. flat; total count; usage density (labels per issue/PR); auto-routing presence.

**Surface as.** A one-liner: "Label system: Kubernetes-style prefixed, 47 labels. You'll want to self-apply `kind/bug` and `area/parser` on the PR; `triage/accepted` is maintainer-only."

### A7. Projects, Milestones, Roadmap

**Where.** `/projects` tab on GitHub; `gh project list`; `MILESTONES.md`, `ROADMAP.md`; pinned issues; GitHub Discussions "Announcements" category.

**What it tells you.** What's explicitly *planned*, and — more usefully — what's explicitly *out of scope*. A public roadmap with a "Not doing" section is pure gold. Milestones with due dates tell you the release cadence. Pinned issues are the maintainer's "please read before opening an issue" billboard.

**Extract.** Active milestone name, due date, open/closed ratio. Roadmap items. Any "Out of scope" / "Non-goals" section.

**Surface as.** "Current milestone: v0.14 (due May 15, 38% complete). Explicit non-goal: Windows support — rejected twice."

### A8. Discussions tab usage

**Where.** GitHub Discussions. `gh api /repos/:owner/:repo/discussions` (requires scope).

**What it tells you.** Active Discussions = community-driven project where early-stage ideas belong. Empty Discussions with an active Issues tab = top-down project where ideas belong in issues (or nowhere before an RFC). Q&A-heavy Discussions with maintainer-marked answers = maintainer wants support questions out of Issues.

**Extract.** Total discussions; last-30-days activity; answer-marked rate; category distribution (Ideas / Q&A / Show and tell / Announcements).

**Surface as.** "Discussions: 12 posts/month, 68% in Q&A with maintainer answers. → Open support questions here, not in Issues."

### A9. Release cadence

**Where.** `gh release list --limit 30 --json tagName,publishedAt,isPrerelease`.

**What it tells you.** Time-deltas between releases: steady weekly (high operational discipline), monthly (typical), quarterly (slower, more conservative), or bursty (personal project). Prerelease rate tells you whether breaking-change PRs need to target a `next` branch.

**Extract.** Median and p90 time-between-releases; prerelease rate; semver adherence (major bumps on breaking changes?).

**Surface as.** "Release cadence: ~monthly, p90 = 48 days. Last 3 majors preceded by 2-4 weeks of `-rc` tags. → Your breaking change should target `main` but expect a release cycle before it ships."

### A10. CODEOWNERS

**Where.** `.github/CODEOWNERS`, `CODEOWNERS`, `docs/CODEOWNERS`.

**What it tells you.** Who actually reviews what. This is often different from who shows up in `git log --author`. Path-scoped ownership (`/src/parser/ @alice @bob`) tells you whom to @-mention or whose review is blocking.

**Extract.** For each path glob you'll touch, the owner(s).

**Surface as.** "Files touched by your PR: `/src/parser/*.rs` → owners `@alice @bob`. Either one's approval unblocks merge per branch-protection."

### A11. Test coverage and test style

**Where.** `tests/`, `test/`, `__tests__/`, `spec/`, `*_test.go`, `*.test.ts`, `test_*.py`. CI config for coverage thresholds.

**What it tells you.** What passes for "done" here. Ratio of unit to integration to e2e tests. Whether tests use fixtures, factories, snapshots, or property-based generators. Presence of a coverage threshold in CI (`if coverage < 85: fail`) — hard signal that "done = coverage-preserving".

**Extract.** Test framework; unit:integration:e2e ratio; fixture style; coverage threshold; mutation-testing presence; presence of a `testing/` helper package.

**Surface as.** "Testing style: 70% unit, 25% integration, 5% e2e. Uses `insta` snapshots heavily. Coverage gate at 80%. → Your PR needs a snapshot update and a unit test; an integration test is a bonus but not required."

### A12. `.github/` metadata

**Where.** `.github/ISSUE_TEMPLATE/`, `.github/PULL_REQUEST_TEMPLATE.md`, `.github/workflows/`, `.github/FUNDING.yml`, `.github/CODE_OF_CONDUCT.md`, `.github/SECURITY.md`, `.github/SUPPORT.md`, `.github/CONTRIBUTING.md`, `.github/actions/` (composite actions).

**What it tells you.** Issue templates signal which classes of issue are welcome and in what shape. A `bug_report.yml` with a mandatory "Minimal reproducer" field means "no repro = auto-close". A PR template with a checklist means your PR body must enumerate those items. Workflow files tell you which lint/format/test gates must be green before review.

**Extract.** Template fields; PR checklist items; CI job names and their required-check status.

**Surface as.** "PR template requires: [ ] tests added, [ ] CHANGELOG updated, [ ] ADR if architectural, [ ] docs updated. Required CI checks: `lint`, `test-linux`, `test-macos`, `coverage`. → Copy the template verbatim; don't delete checklist boxes."

### A13. Deprecation and removal patterns

**Where.** `git log --grep='deprecat'`; `CHANGELOG.md` Deprecated section; `#[deprecated]` attributes in source; `@deprecated` JSDoc tags; migration guides in `docs/migrations/`.

**What it tells you.** Does the project do "flag-day" removals (v2.0 drops the old API outright) or soft deprecation (warn for 2 minors, remove in next major)? Do they provide codemods? A "migration guide" for every breaking change signals a project that values user trust over velocity.

**Extract.** Deprecation-to-removal lag (versions between `@deprecated` and removal); migration-guide presence; codemod presence.

**Surface as.** "Deprecation discipline: warns for 2 minor versions, removes in next major. Always ships a migration guide in `docs/migrations/`. → If your PR renames a public API, include a deprecated re-export and a migration note."

---

## Author Mind-Model

The goal is not to surveil the author but to read what they've already published about how they think, so your PR language meets them where they are.

### B1. Public writing

**Where.** Personal blog (link from GitHub profile or README), Substack, dev.to, Medium, Hacker News submissions (`https://news.ycombinator.com/submitted?id=<user>`), Lobsters.

**Extract.** Last 10 posts, titles + first paragraph. Recurring themes. Positions they've publicly staked out ("why I prefer X over Y"). Tone: academic / conversational / polemical / tutorial.

**Signal.** If they wrote a 4,000-word essay titled "Why we'll never add type inference to X", don't propose type inference.

### B2. Talks

**Where.** YouTube (search `"<name>" "<project>" talk`), conference pages (StrangeLoop, GOTO, RustConf, PyCon, FOSDEM, etc.), Internet Archive.

**Extract.** Their "elevator pitch" for the project (often in the first 3 minutes). Slides where they explicitly say "this is what the project is *not*". Questions from the floor that they dismissed vs. engaged with.

**Signal.** Their self-description of the project is the phrase to echo in your PR description.

### B3. Social

**Where.** Twitter/X, Mastodon (often `@<user>@hachyderm.io` for devs), Bluesky, Threads. Link from GitHub profile.

**Extract.** Tone register (professional/personal/shitposting). Which PRs/issues they RT or quote-tweet. Who they defer to ("ask @X, they know this better"). Pinned post. Last 30 days of activity relevant to the project.

**Signal.** If their recent tone has shifted to frustration ("burnout season, please be patient"), don't ship a non-urgent PR that needs hand-holding.

### B4. Podcast appearances

**Where.** Search `"<name> site:overcast.fm"`, `"<name>" podcast`, the project's website "Press" page, Changelog.com, Oxide and Friends, Software Engineering Daily.

**Extract.** Long-form interviews reveal values and rejected paths that don't appear in writing. Timestamps where they talk about "things we tried and reverted".

**Signal.** Podcast confessions ("I regret adding feature X") are the strongest possible signal for PRs that double down on X.

### B5. Chat platforms

**Where.** Discord (link in README), Slack (link in README), Zulip (common in Rust/Lean ecosystems), Matrix (`#project:matrix.org`), Gitter (legacy), IRC (`#project on Libera.Chat` for Linux/older projects).

**Extract.** Which channels are real design discussion vs. user support. Lurk before speaking — the skill should instruct the user to read a channel for 15 minutes before posting. Pinned messages in each channel.

**Signal.** If `#dev` has the actual architecture conversations and `#general` is support, a feature proposal belongs in `#dev` — but only after reading its backlog.

### B6. Mailing lists and forums

**Where.** Common in Linux kernel (`lore.kernel.org`), Apache (`lists.apache.org`), Postgres (`pgsql-hackers@lists.postgresql.org`), Rust (`internals.rust-lang.org`), Python (`discuss.python.org`), Emacs, Debian.

**Extract.** Whether decisions are *made* on the list or merely *announced*. For list-native projects, a GitHub PR without a prior list thread is often rejected with "please discuss on the list first".

**Signal.** If the project has a `-hackers` list, your PR's first step is a list thread, not a branch.

### B7. Timezone and activity rhythm

**Command.** `git log --author="<maintainer>" --pretty=format:'%ad' --date=iso-strict | cut -d'T' -f2 | cut -c1-2 | sort | uniq -c | sort -rn`.

**Extract.** Hour-of-day histogram (UTC). Weekday vs. weekend ratio. Back-to-back active days vs. sporadic.

**Signal.** If 80% of commits are 14:00-22:00 UTC, the maintainer is probably Europe-based and evenings-active. Don't expect a response to a Friday-19:00-UTC PR until Monday. Don't @-mention at 03:00 local.

### B8. Past review tone

**Where.** `gh pr list --state all --limit 100 --search "reviewed-by:<maintainer>"` then fetch review bodies.

**Extract.** What they praise ("nice test!", "clean refactor"). What they flag ("this needs a test", "factor this into a helper", "rename to match the codebase"). Are they terse ("nit: rename", "LGTM") or discursive (paragraphs explaining the reasoning)?

**Signal.** If they consistently flag "missing tests", your PR must have tests *before* requesting review. If they write paragraphs, your PR description should too — they'll read it.

### B9. Issue response patterns

**Extract.** Do they engage deeply with new issues, triage quickly to `wontfix`, or need polite bumps? Response-rate histogram. Do they ask for repro, or attempt repro themselves?

**Signal.** Low response rate + high triage-to-`wontfix` rate = pitch the issue very carefully, with a minimal reproducer and a one-sentence thesis.

### B10. Philosophy statements

**Where.** README "Why this exists" / "Design goals" / "Non-goals" sections. `PHILOSOPHY.md`, `VISION.md`, `MANIFESTO.md`. FAQ pages. "Rejected ideas" docs (TC39 maintains `tc39/proposal-*` repos with dead proposals; Rust has lang-team FAQs and the `rust-lang/rfcs` repo's closed-unmerged PRs).

**Extract.** The explicit non-goals. The manifesto sentence ("X is a *minimal* Y that does *only* Z").

**Signal.** Align your PR's framing with the manifesto sentence. Cite non-goals when scoping — "this PR deliberately does not do W because W is a non-goal per README §2".

### B11. Public rejections

**Where.** Blog posts titled "Why we said no to X", "Why we won't add Y". Twitter threads with "long rant incoming". HN comments by the maintainer defending a rejected PR.

**Extract.** The argument shape. Is it "scope creep"? "maintenance burden"? "contradicts our philosophy"? "we tried it and reverted"?

**Signal.** Your PR pre-empts their rejection argument. If they always say "maintenance burden", your PR description has a "Maintenance" section.

### B12. BDFL vs. team

**Extract.** If single maintainer (BDFL — benevolent dictator for life): their mood and bandwidth are everything. If team: who carries which decisions? CODEOWNERS is the map; review-approval patterns are the territory. Do merges require one approval or two? Who has force-merge? Is there an RFC process (`<project>/rfcs` repo)?

**Signal.** For BDFLs, optimize for their specific taste and don't cc the world. For teams, cc the area owner and be prepared to iterate with multiple reviewers.

---

## Pre-PR Ritual

Ten steps, ~3 minutes each, that together build an author-fit score. The skill walks the user through each step, surfaces evidence, and asks for a green/yellow/red judgement. If ≥2 reds or ≥4 yellows: stop, open an issue first.

### Step 1. Read CONTRIBUTING.md and CODE_OF_CONDUCT.md fully (3 min)

Not skim — read. Note every "must" and "never".
- **Green:** You can recite the PR checklist and know the commit-message format.
- **Yellow:** You read it but one requirement is ambiguous (e.g., "meaningful tests" — what counts?).
- **Red:** The doc says "open an issue first for non-trivial changes" and you haven't.

### Step 2. Read the last 3 merged PRs that touched files near yours (3 min)

`gh pr list --state merged --limit 20 --search "<path-glob>"`.
- **Green:** Your PR title, body, and commit style match all three.
- **Yellow:** Two out of three match; one differs (e.g., one used Conventional Commits, two didn't).
- **Red:** Your style is visibly different — wrong tense, missing issue reference, no tests.

### Step 3. Sample 2 rejected (closed-unmerged) PRs in the last 90 days (3 min)

Read the closing comment verbatim.
- **Green:** Neither rejection reason applies to your PR.
- **Yellow:** One rejection reason *could* apply (e.g., "out of scope" — is yours in scope?). Add a pre-empting sentence to your PR body.
- **Red:** Your PR looks structurally identical to a just-rejected one. Stop; revise the framing or open an issue to negotiate scope.

### Step 4. Read 1 ADR if any exist; skim the index regardless (3 min)

Pick the ADR closest to what you're changing.
- **Green:** No ADR contradicts your change, or an ADR explicitly endorses the direction.
- **Yellow:** An ADR is adjacent but not directly on-point; decide whether your PR needs a new ADR.
- **Red:** An Accepted ADR contradicts your change. Either write a superseding ADR first or open an issue.

### Step 5. Check the last milestone and any "non-goals" list (2 min)

Roadmap, pinned issues, README "Non-goals".
- **Green:** Your change is on the roadmap or in an active milestone.
- **Yellow:** Not on the roadmap but not excluded; note this in your PR body.
- **Red:** Your change is in the "non-goals" list.

### Step 6. Check the maintainer's recent public posture (3 min)

Last 30 days of Twitter/Mastodon/blog/podcast. Recent Discussions posts.
- **Green:** Steady, engaged tone; has responded to PRs in the last week.
- **Yellow:** Busy season — last PR response >14 days ago, or a "taking a break" post. Your PR will wait; set expectations in the body.
- **Red:** Recent "burned out / stepping back" or a visible feud / governance crisis. Don't add to their pile.

### Step 7. Check timezone and expected response window (2 min)

Activity histogram from `git log`. Cross-check with profile location.
- **Green:** You know their working hours and will not @-mention outside them.
- **Yellow:** Activity is diffuse / unclear; set a soft expectation of 3-5 business days.
- **Red:** You were about to @-mention at 02:00 their time. Reschedule.

### Step 8. Confirm the issue-first question (3 min)

Is your change trivial (typo, one-line obvious bug fix, doc clarification)? Or does CONTRIBUTING.md require an issue first?
- **Green:** Trivial, or an issue/discussion already exists with maintainer buy-in.
- **Yellow:** Borderline; err on the side of opening an issue or Discussion with a short pitch.
- **Red:** Non-trivial, no issue, and CONTRIBUTING says "open an issue first". Stop; open the issue.

### Step 9. Dry-run the PR body against the template (3 min)

Check every box in `.github/PULL_REQUEST_TEMPLATE.md`. Write the CHANGELOG entry in the project's exact format. Match commit-message style.
- **Green:** Every box honestly checked; CHANGELOG line mimics last 5 entries' format; commits pass lint.
- **Yellow:** One box unchecked with a justification in the body.
- **Red:** Boxes deleted or ignored; CHANGELOG format wrong; commits fail conventional-commits lint.

### Step 10. Run the full local check suite, then read your own diff out loud (3 min)

`make check` / `cargo test` / `pnpm test` / whatever the project uses. Then read the diff as if you were reviewing it.
- **Green:** All checks pass locally; self-review surfaces no obvious "why is this here?" moments.
- **Yellow:** Checks pass but one spot looks slightly off-idiom; note it in the PR body with "open to feedback on X".
- **Red:** Checks fail locally, or self-review surfaces a scope-creep chunk. Trim or fix before opening.

### Scoring

- **0 reds, ≤2 yellows:** Ship the PR.
- **0 reds, 3 yellows:** Ship with explicit acknowledgement of each yellow in the PR body.
- **0 reds, ≥4 yellows OR any 1 red:** Open an issue or Discussion first. Do not open the PR.
- **≥2 reds:** Do not contribute yet. Lurk, read, and re-run the ritual next week.

---

## Archaeology Checklist

1. ADRs located, indexed, and any adjacent-to-change ADR read in full.
2. CHANGELOG format, voice, and granularity captured as a style card.
3. Commit-message archaeology done: subject format, tense, Conventional Commits, body expectations, issue-reference rate, sign-off convention.
4. At least 5 closed-unmerged PRs reviewed for rejection reasons and maintainer tone.
5. Issue triage patterns summarized: time-to-first-response, `wontfix` rate, stale-bot behaviour.
6. Label taxonomy captured: prefixed vs. flat, self-applicable vs. maintainer-only.
7. Current milestone, roadmap, and explicit non-goals extracted.
8. Discussions tab activity assessed: is it where ideas go, or dormant?
9. Release cadence measured (p50 and p90 time-between-releases), prerelease convention noted.
10. CODEOWNERS mapped for every path your PR touches.
11. Test style characterized: unit/integration/e2e ratio, fixture style, coverage gate.
12. `.github/` metadata scanned: issue templates, PR template, required CI checks, workflows.
13. Deprecation and removal discipline documented: soft vs. flag-day, migration guides, codemods.
14. CI and branch-protection rules captured: required checks, required reviews, linear history, signed commits.

## Author Mind-Model Checklist (detail)

1. Public writing sampled (last 10 posts across blog / HN / Lobsters) and recurring positions extracted.
2. Talks reviewed for the maintainer's own elevator pitch and "what this project is not" slides.
3. Social presence read for tone register, recent posture, and deference patterns.
4. Podcast appearances scanned for value statements and rejected-path confessions.
5. Chat platform identified; backlog of relevant channel read for 15+ minutes before posting.
6. Mailing list / forum presence checked; list-first decision cultures flagged.
7. Timezone and activity-hour histogram computed from git log.
8. Past review tone sampled: praise patterns, flag patterns, terse vs. discursive.
9. Issue response rhythm: engagement depth, triage speed, repro norms.
10. Philosophy / manifesto / non-goals statements located and the project's one-sentence self-description extracted verbatim.
11. Public rejections gathered: the maintainer's recurring rejection arguments.
12. Governance model classified: BDFL vs. team; CODEOWNERS map; RFC process presence; force-merge holders.
13. Burnout / bandwidth signal: is the maintainer in a healthy window right now?

## Pre-PR Ritual Summary Card

1. Read CONTRIBUTING + CODE_OF_CONDUCT fully — not just skim.
2. Read last 3 merged PRs near your files — match title / body / commit style.
3. Sample 2 rejected PRs from last 90 days — note reasons, pre-empt them.
4. Read 1 ADR if present; skim the ADR index regardless.
5. Check current milestone and explicit non-goals.
6. Check maintainer's last-30-days posture (social, blog, Discussions).
7. Check timezone — calibrate response expectation and @-mention timing.
8. Issue-first check: trivial change, or does CONTRIBUTING require an issue?
9. Dry-run PR body against the template; match CHANGELOG format; lint commits.
10. Run full local checks, then read your own diff out loud.

Score green/yellow/red. Ship only on 0 reds and ≤3 yellows.

---

## ADR RFC Reading

See §Project Archaeology A1 above. ADRs (`docs/adr/`, `docs/decisions/`, `adr/`) document irrevocable decisions and rejected alternatives. RFCs (`rfcs/`, `proposals/`, `rfc/`) document proposed changes still open for comment. Before proposing anything non-trivial, index both folders and read any adjacent to your change in full.

## Closed PR Analysis

See §Project Archaeology A4 above. Closed-unmerged PRs are the single best signal of *what gets rejected*. Sample at least 5 from the last 90 days; extract the maintainer's rejection reason verbatim; cluster into recurring rejection categories (scope, style, philosophy, duplicate).

## Label Taxonomy Reading

See §Project Archaeology A6 above. Read the label list before opening an issue. Distinguish prefixed taxonomies (`kind/*`, `priority/*`, `area/*`) from flat labels. Note which labels are self-applicable vs. maintainer-only; note whether `good first issue` and `help wanted` are actively curated or stale.

## GitHub Projects and Milestones

See §Project Archaeology A7 above. Open the Projects tab and current Milestones before proposing new work. A proposal that lands on this cycle's roadmap gets prioritized; one that doesn't waits or gets deferred to Discussions.
