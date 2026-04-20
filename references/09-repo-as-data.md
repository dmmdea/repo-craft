> **Consult this if:** auditing repo artifacts, designing a label taxonomy or issue ontology, setting up ADRs/RFCs, planning DORA/CHAOSS metrics, or running a monthly repo health check.
>
> **Cross-refs:** [01](./01-repo-management.md) · [10](./10-templates.md)

## Table of Contents

- [Repo as Structured Data](#repo-as-structured-data)
- [Knowledge Preservation](#knowledge-preservation)
- [Observability Analytics](#observability-analytics)
- [Organization Hygiene](#organization-hygiene)
- [Analytics Loops](#analytics-loops)
- [Repo-as-Data Artifact Checklist](#repo-as-data-artifact-checklist)
- [Monthly Repo Health Query Pack](#monthly-repo-health-query-pack)

---

# 09 — Repo as Data + Knowledge System

**Research slice:** Managing a GitHub repository as a structured data + knowledge system, not a code dump.
**Framing:** Most "repo management" guides stop at CI + branch protection. This document extends into the repo as a knowledge base whose label taxonomy, issue ontology, milestone schema, decision log, and metrics dashboard are first-class data artifacts.
**Audience:** The GitHub management + contribution skill orchestrator.
**Date:** 2026-04-20

---

## Repo as Structured Data

### A.1 Label taxonomy as a schema

A repository's labels are a flat classifier with no native grouping, so the only way to get structure is through a naming convention that encodes orthogonal axes. Good schemas separate at minimum five axes: **type** (`type/bug`, `type/feature`, `type/rfc`), **area** (`area/api`, `area/docs`), **priority** (`priority/p0..p3`), **status** (`status/needs-triage`, `status/blocked`), and **triage** (`good first issue`, `help wanted`).

Canonical exemplars:

- **Kubernetes** uses the `kind/`, `area/`, `sig/`, `priority/`, `triage/`, `lifecycle/` prefix scheme. The scheme is documented in `kubernetes/community` and enforced by Prow via the `labels.yaml` file (https://github.com/kubernetes/test-infra/blob/master/label_sync/labels.yaml). Labels are a machine-readable routing layer for the bot.
- **GitHub's default label set** is deliberately minimal: `bug`, `documentation`, `duplicate`, `enhancement`, `good first issue`, `help wanted`, `invalid`, `question`, `wontfix`. It is a starting point, not a target (https://docs.github.com/en/issues/using-labels-and-milestones-to-track-work/managing-labels#about-default-labels).
- **Angular** uses `type:`, `comp:`, `freq:`, `severity:`, `state:` prefixes. The schema is documented in `angular/angular/.github/CONTRIBUTING.md` and mirrored in the Angular dev-infra tooling.

**Orthogonality rule:** any label on axis X should be combinable with any label on axis Y. If two labels conflict on the same axis (e.g. `bug` + `feature`), the taxonomy is broken.

**When to add a label:** a new label is justified only if it (a) unlocks a query you actually run, (b) maps to a specific automation, or (c) marks an ownership boundary. Labels added "because it felt right" become noise within a quarter.

**When to deprecate:** run the monthly audit described in Part E.1. Labels with zero use in 90 days should be archived; duplicates should be merged via `gh api -X PATCH /repos/:owner/:repo/labels/:name` with the canonical name.

### A.2 Issue ontology

Issues are not homogeneous. A mature repo distinguishes:

- **Bug** — observed defect with reproduction.
- **Feature request** — desired capability, not yet designed.
- **RFC / design doc** — substantive change that requires architectural review before implementation (see B.2).
- **Discussion** — open-ended, no action item. Use GitHub Discussions (https://docs.github.com/en/discussions), not Issues, to keep the Issues tracker actionable.
- **Question** — support request. Route to Discussions or Stack Overflow with a saved reply.
- **Task / chore** — internal work unit, often from a parent epic.

**Issue Forms** (`.github/ISSUE_TEMPLATE/bug_report.yml`, `feature_request.yml`) turn free-text into structured fields (dropdowns, required textareas, checkbox consents). Every required field is a column you can query. Docs: https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/syntax-for-issue-forms.

**Projects v2 custom fields** extend this further. Beyond the defaults (Status, Assignee, Milestone), you can add typed fields: Single-select, Number, Date, Iteration, Text. These fields are queryable via GraphQL's `ProjectV2Item` (https://docs.github.com/en/graphql/reference/objects#projectv2item) and are the only way to get true relational views over issues.

### A.3 Milestones + Projects v2

**Milestones** are lightweight scoping buckets — one issue, one milestone, due-date + percent-complete. They work for release gating (everything tagged `v1.4.0` ships together) but not for cross-cutting planning.

**Projects v2** (the GraphQL-backed successor to Projects Classic) is the real relational layer:

- **Rollups:** a custom Number field can sum across items in a group (e.g., "total story points per iteration").
- **Iteration fields:** built-in sprint/cycle support with automatic rollover (https://docs.github.com/en/issues/planning-and-tracking-with-projects/understanding-fields/about-iteration-fields).
- **Group-bys:** board, table, and roadmap views can group by any field.
- **Workflows:** built-in automation for auto-adding items, auto-archiving, auto-closing.

Projects v2 **replaces** an external PM (Jira, Linear) for repos where contributors already live in GitHub; it **complements** an external PM when the external tool is the source of truth for non-code work (sales, marketing, support).

### A.4 CODEOWNERS as an ownership graph

`CODEOWNERS` (at `.github/CODEOWNERS`, `/docs/CODEOWNERS`, or root) declares a directed graph: path-glob → owner-set (user or team). When a PR touches a path, GitHub auto-requests review from the matching owner(s) (https://docs.github.com/en/repositories/managing-your-repositories-settings-and-features/customizing-your-repository/about-code-owners).

What it codifies:

- **Expertise boundary** — who knows this code.
- **Approval authority** — combined with a branch protection rule requiring CODEOWNERS review, it becomes a merge gate.
- **Routing** — the reviewer-inbox signal replaces "who should I @-mention?" tribal knowledge.

Anti-patterns: a single catch-all `* @org/everyone` line disables the routing value; deeply nested globs without ownership leave paths uncovered. A good CODEOWNERS file is reviewed quarterly, matches `tree -d -L 2`, and has zero overlapping rules for the same path.

### A.5 Branching as a data lifecycle

Branch names are tags. A disciplined prefix scheme turns them into queryable state:

- `main` — trunk.
- `release/x.y` — release branches (backport target).
- `lts/x.y` — long-term support branches with a separate support window.
- `docs/*` — doc-only work (can be gated by lighter CI).
- `renovate/*` / `dependabot/*` — automated dep updates; can be auto-merged by policy.
- `feat/*`, `fix/*`, `chore/*` — short-lived topic branches matching Conventional Commits types.

GitHub's **rulesets** (https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets) let you attach protection rules to glob patterns (`release/*`, `lts/*`) instead of individual branches, so the lifecycle policy auto-applies as new release branches are cut.

### A.6 Semantic commit messages as structured events

**Conventional Commits 1.0** (https://www.conventionalcommits.org/en/v1.0.0/) defines a grammar: `<type>(<scope>)!: <description>`, with required/optional footers (`BREAKING CHANGE:`, `Refs: #123`). Types map to changelog sections (`feat` → Added, `fix` → Fixed, `perf` → Changed, etc.).

Query surfaces unlocked:

- **Semantic-release** (https://github.com/semantic-release/semantic-release) reads commit types to compute the next semver bump automatically.
- **release-please** (https://github.com/googleapis/release-please) opens PRs with computed version bumps and generated changelog entries.
- **git-cliff** (https://github.com/orhun/git-cliff) generates templated changelogs from commit ranges.
- **commitlint** (https://commitlint.js.org/) enforces the grammar at commit or PR-title time.

Once commits are structured, `git log --grep='^feat' v1.3.0..HEAD` becomes a product-readable query, not an archaeology expedition.

---

## Knowledge Preservation

### B.1 ADRs — Architecture Decision Records

An ADR captures a single architecturally-significant decision, its context, the alternatives considered, and the consequences accepted. Michael Nygard's original essay (https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions) set the four-section template (Context, Decision, Status, Consequences); **MADR** (https://adr.github.io/madr/) extends it with "Considered Options" and "Decision Drivers" and numbers files as `0001-record-architecture-decisions.md`.

Placement: `docs/adr/` or `docs/decisions/`. Status values: `Proposed`, `Accepted`, `Deprecated`, `Superseded by #NNNN`. The key property is **append-only**: a decision is never rewritten, only superseded, because the rationale at the time of the decision matters even if the decision is later reversed.

Why ADRs matter: decisions decay, rationale rots, and the "why didn't you just…" question in year three has no answer without them. ThoughtWorks Technology Radar has moved ADRs to **Adopt** (https://www.thoughtworks.com/radar/techniques/lightweight-architecture-decision-records).

### B.2 RFCs / design docs in-repo

For changes bigger than a single ADR — language features, protocol changes, major API evolution — an in-repo RFC process scales. Exemplars:

- **Rust RFCs** — `rust-lang/rfcs` repo; PR-based; `Text` field mandatory; `Status: active|postponed|rejected|accepted|withdrawn` (https://github.com/rust-lang/rfcs).
- **Kubernetes Enhancement Proposals (KEPs)** — numbered under `keps/sig-*/NNNN-title/`, with `kep.yaml` metadata and phased `provisional|implementable|implemented|deferred|rejected|withdrawn|replaced` status (https://github.com/kubernetes/enhancements).
- **React RFCs** — `reactjs/rfcs`, lightweight Markdown template (https://github.com/reactjs/rfcs).
- **TC39 proposals** — staged 0→4 process (https://tc39.es/process-document/), repo `tc39/proposals`.

Common pattern: submit as PR, reviewers comment inline, a "final comment period" (FCP) is announced, and the RFC is merged in Accepted or Rejected state. The merged file is the artifact; the PR thread is its audit log.

### B.3 CHANGELOG.md discipline

**Keep a Changelog** (https://keepachangelog.com/en/1.1.0/) is the de facto spec. Sections: `Added`, `Changed`, `Deprecated`, `Removed`, `Fixed`, `Security`. Rules: written for humans, one entry per release, `[Unreleased]` section at the top, ISO dates, reverse-chronological order, links to diffs.

What makes a changelog useless: "misc fixes", "various improvements", commit-hash dumps, auto-generated lists that repeat the commit subject with no translation to user impact. The fix: the changelog is a **translation layer** from engineering commits to user-visible effects.

### B.4 Commit message quality as documentation

The Tim Pope 50/72 convention (https://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html) — subject ≤ 50 chars, imperative mood, blank line, body wrapped at 72 — exists because `git log` renders in an 80-column pager. The subject is a headline, the body answers "why", and trailers (`Refs: #123`, `Fixes: #456`, `Co-authored-by:`) are machine-queryable.

Linus Torvalds's enduring advice on the topic is in the kernel's `Documentation/process/submitting-patches.rst` (https://www.kernel.org/doc/html/latest/process/submitting-patches.html): a good commit message "describes the problem that the patch is trying to solve" before the solution.

### B.5 Release notes — human-written vs auto-generated

GitHub's auto-generated release notes (https://docs.github.com/en/repositories/releasing-projects-on-github/automatically-generated-release-notes) use PR titles and labels grouped by category, configured via `.github/release.yml`. This is excellent as a **draft** — it is terrible as the final artifact, because PR titles are written for reviewers, not users.

Curate when: breaking changes, security fixes, migration guides, deprecation timelines. Auto-generate when: patch releases, internal refactors, dependency bumps.

### B.6 Post-mortems as repo artifacts

`docs/postmortems/YYYY-MM-DD-incident-slug.md`. Google's SRE book chapter on blameless postmortems is the canonical reference (https://sre.google/sre-book/postmortem-culture/). Structure: summary, impact (users affected, duration, revenue), timeline (UTC timestamps), root cause, contributing factors, what went well, what went badly, action items.

Critical: every action item is a **linked issue** with an owner and a due date. An action item without a tracking issue is a wish.

### B.7 In-repo glossary + domain docs

`docs/glossary.md`. One line per term. Orders of magnitude cheaper than onboarding calls. Especially valuable where the product domain has jargon the code does not (health care, finance, logistics). See the C4 model's glossary (https://c4model.com/abstractions/) for a canonical example.

### B.8 DEPRECATED.md / ROADMAP.md / NON-GOALS.md

- **DEPRECATED.md** — every deprecated feature with removal version and replacement. Semver requires this.
- **ROADMAP.md** — public, dated, with confidence levels ("committed", "planned", "exploring"). If the roadmap is private, GitHub Discussions with the `roadmap` category works.
- **NON-GOALS.md** — what the project explicitly will not do. This is the highest-signal document in the repo: it shuts down 80% of feature-creep proposals with a single link. The Zig project's "What Zig is not" (https://ziglang.org/learn/overview/) and Rust's `NOTE.md` patterns illustrate the form.

---

## Observability Analytics

### C.1 DORA metrics

The four DORA metrics (https://cloud.google.com/blog/products/devops-sre/using-the-four-keys-to-measure-your-devops-performance):

1. **Deployment Frequency** — production deploys per day/week.
2. **Lead Time for Changes** — commit → production latency.
3. **Change Failure Rate** — % deploys that cause an incident/hotfix/rollback.
4. **Mean Time To Restore (MTTR)** — incident open → resolved.

Measurement from GitHub:

- Deployment Frequency = count of successful Deployments via `GET /repos/:owner/:repo/deployments` filtered by `environment=production`.
- Lead Time = `merged_at` of PR − earliest `committed_date` of its commits, joined to the deploy that shipped it.
- Change Failure Rate = share of deploys followed by a revert commit, incident label, or hotfix branch.
- MTTR = time between an incident-labeled issue `created_at` and `closed_at`.

**Four Keys** (Google, https://github.com/dora-team/fourkeys) is an open-source reference implementation that ingests GitHub webhooks into BigQuery.
**Sleuth** (https://www.sleuth.io/) and **LinearB** (https://linearb.io/) are commercial offerings that wrap DORA with impact reporting.

### C.2 Repo health metrics (beyond DORA)

- **PR merge time** — p50/p95 from `created_at` to `merged_at`.
- **PR size distribution** — `additions + deletions` histogram; large PRs correlate with defect rate.
- **Review latency** — `created_at` to first non-author review.
- **Stale-issue ratio** — `open and updated_at < now-90d` / `total_open`.
- **Triage latency** — `created_at` to first label or assignment.
- **New-contributor conversion** — first-time authors who return for a second PR within 90 days.
- **Bus factor** — Gini coefficient on commit authorship over the last 12 months. A Gini above ~0.7 means the project is highly concentrated; below 0.4 is well-distributed.

### C.3 Contributor metrics ecosystems

- **CHAOSS** (https://chaoss.community/) — open-source community health metrics project under the Linux Foundation. Metrics model is documented as "CHAOSS Metrics Models" with categorical groupings (Evolution, Risk, Value, Common).
- **GrimoireLab** (https://chaoss.github.io/grimoirelab/) — CHAOSS's reference toolchain; ingests Git/GitHub/Jira/Slack, stores in Elasticsearch, dashboards in Kibana.
- **Mozilla's Community Health Metrics** (https://wiki.mozilla.org/Open_Source_Metrics) — earlier work on open-source health.
- **LFX Insights** (https://insights.lfx.linuxfoundation.org/) — hosted CHAOSS-powered dashboard for LF projects.

### C.4 GitHub-native analytics

- **Insights tab:**
  - **Pulse** — 1-week summary.
  - **Contributors** — commits/additions/deletions per author.
  - **Traffic** — clones, unique visitors, popular paths, referrers (last 14 days).
  - **Commits / Code frequency / Network / Forks** — activity over time.
  - **Dependency graph** — parsed package manifests.
- **Security tab:**
  - **Dependabot alerts** (https://docs.github.com/en/code-security/dependabot/dependabot-alerts/about-dependabot-alerts).
  - **Code scanning** (CodeQL; https://docs.github.com/en/code-security/code-scanning).
  - **Secret scanning** (https://docs.github.com/en/code-security/secret-scanning/about-secret-scanning).

### C.5 Third-party analytics

- **OSSInsight** (https://ossinsight.io/) — TiDB-backed analytics over the GH Archive dataset.
- **Star History** (https://star-history.com/) — star growth over time; a rough popularity proxy.
- **Repobeats** (https://repobeats.axiom.co/) — embeddable activity image for READMEs.
- **Sourcegraph Batch Changes** (https://sourcegraph.com/docs/batch-changes) — not analytics, but mass-change tracking across repos is an analytics-adjacent capability.

### C.6 Cost/time analytics

- **Actions usage** — `GET /repos/:owner/:repo/actions/workflows/:id/timing` returns billable minutes per workflow.
- **Cache hit rate** — `actions/cache` logs include hit/miss; aggregate via the run logs API.
- **Job duration histograms** — `GET /repos/:owner/:repo/actions/runs/:id/jobs` with `steps[].started_at` / `completed_at` gives per-step durations.

### C.7 Data extraction tools

- **`gh api --paginate`** — simplest path, handles pagination for REST endpoints.
- **GitHub GraphQL API** (https://docs.github.com/en/graphql) — necessary for Projects v2, more efficient for nested queries.
- **ghtorrent** (https://ghtorrent.org/) — archived 2021, but historical dumps through 2021 remain useful for longitudinal research.
- **GH Archive** (https://www.gharchive.org/) — hourly JSON archive of every public event since 2011.
- **ClickHouse `github_events` public dataset** (https://ghe.clickhouse.tech/) — GH Archive loaded into ClickHouse, queryable over HTTP.
- **BigQuery `githubarchive` public dataset** (https://console.cloud.google.com/marketplace/product/github/github-repos) — SQL over the full archive.

---

## Organization Hygiene

### D.1 Label audits

Quarterly. Steps: (1) `gh api /repos/:o/:r/labels --paginate > labels.json`; (2) join with `gh api /search/issues?q=repo:o/r+label:X` counts per label; (3) retire labels with zero 90-day use; (4) merge near-duplicates (`bug` vs `type:bug`); (5) re-check orthogonality against the axes in A.1.

### D.2 Stale issues + PRs policy

`actions/stale` (https://github.com/actions/stale) auto-comments and auto-closes inactive issues/PRs on a schedule. Reasonable defaults: 60 days to stale, 14 more to close, exempt labels for `pinned`, `security`, `good first issue`.

**Jason Etco's critique** — the same author who originally wrote `probot/stale` later argued in "Stale bots are a footgun" (https://jasonet.co/posts/stale-bot/, 2021) that auto-closing silences users without solving the underlying triage debt. The nuanced position: use stale bots only on **PRs awaiting author response**, and handle stale **issues** via real triage. Closing a bug report because no one replied is a signal about the project, not the user.

### D.3 Archiving vs deletion

Archive (https://docs.github.com/en/repositories/archiving-a-github-repository/archiving-repositories) sets the repo read-only, preserves history, issues, PRs, and the URL. Deletion breaks every inbound link and forfeits SEO / discoverability. Default to archive; delete only for legal, private, or malicious-content reasons.

### D.4 Monorepo vs polyrepo reorganization

Split when: teams independently deploy, test cycles diverge, languages don't share tooling, access control diverges. Merge when: cross-cutting refactors are painful, versioning is tangled, CI redundancy dominates cost. Tooling:

- **Nx** (https://nx.dev/) — task graph, affected-projects, caching.
- **Turborepo** (https://turborepo.com/) — remote cache, minimal config.
- **pnpm workspaces** (https://pnpm.io/workspaces) — package-manager-level.
- **Bazel** (https://bazel.build/) — true monorepo at scale (Google, Pinterest, Stripe).

### D.5 Repo templates + org-level defaults

- **Org `.github` repo** (https://docs.github.com/en/communities/setting-up-your-project-for-healthy-contributions/creating-a-default-community-health-file) — org-wide defaults for `CODE_OF_CONDUCT.md`, `CONTRIBUTING.md`, `SECURITY.md`, issue/PR templates that apply to every repo without a local override.
- **Template repos** — set `is_template: true`; users "Use this template" to clone structure without inheriting commit history (https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template).
- **Org-level rulesets** (https://docs.github.com/en/organizations/managing-organization-settings/managing-rulesets-for-repositories-in-your-organization) — apply branch protection, tag protection, push rules across the org with targeting by repo-name pattern.

---

## Analytics Loops

### E.1 Monthly repo health checkup

**Run monthly on every tier-1 repo.**

| Query | Threshold | Action if breached |
|---|---|---|
| Median PR merge time | ≤ 3 business days | Investigate review bottleneck; check CODEOWNERS coverage |
| % PRs with ≥ 1 review before merge | ≥ 95% | Enforce via branch protection |
| Open-issue triage latency p95 | ≤ 72h | Add triage rotation; add issue forms |
| Stale-issue ratio | ≤ 30% | Label sweep, stale-bot tuning, or honest bug backlog closure |
| Dependabot open alerts (high/critical) | 0 | Schedule upgrade sprint |
| CI p95 duration | flat or down QoQ | Cache audit, job parallelization |
| Actions minutes vs budget | ≤ 80% | Investigate noisy workflows |
| Gini on commit authorship (12mo) | ≤ 0.7 | Invest in contributor onboarding |
| New-contributor 2nd-PR conversion | ≥ 20% | Review "good first issue" queue freshness |
| Labels with zero 90-day usage | ≤ 10% of total | Deprecate them |

Propose: concrete issues with suggested owners, not abstract advice.

### E.2 Pre-release audit

**Required green before cutting a release:**

- CI on the release branch: all required checks green on HEAD.
- CHANGELOG: `[Unreleased]` section moved to the new version with date.
- Version bump consistent across `package.json`, `pyproject.toml`, `Cargo.toml`, `version.go`, container tags, Helm chart, docs site.
- Dependency security: `gh api /repos/:o/:r/dependabot/alerts?state=open&severity=critical` returns zero; high-severity alerts acknowledged or deferred with an issue link.
- Deprecation notices: anything marked for removal in this version is gone from the code **and** documented in `DEPRECATED.md` and the release notes.
- ADRs: any architectural decision shipped in this release has a merged ADR.
- Migration guide: if there are breaking changes, `docs/migrations/vX.md` exists and is linked from the release notes.
- Tag signature: `git tag -s` used; tag matches semver (`vX.Y.Z` or `X.Y.Z` per repo convention, not both).
- GitHub Release: draft created with curated notes, not just auto-generated.

### E.3 Contributor pipeline health

Four stages:

1. **Issue opened** (first-time contributor) → ack within 24h, labeled within 72h.
2. **First PR** — target time-to-first-review ≤ 48h, time-to-merge ≤ 7 days.
3. **Second PR within 90 days** — the conversion metric that matters most (CHAOSS "Contributor Retention", https://chaoss.community/kb/metric-contributor-retention/).
4. **Trusted reviewer / maintainer** — added to CODEOWNERS or a reviewer team after N merged PRs and maintainer vouching.

Leading indicators to monitor: time-to-first-response, "good first issue" queue depth and freshness, percentage of first-time PRs that close without merge (rejection rate), CONTRIBUTING.md last-modified date.

Interventions: office hours / contributor call; explicit mentor assignment on good-first-issue; "new contributor" welcome comment via `actions/first-interaction`.

---

## Repo-as-Data Artifact Checklist

Every healthy repo should contain or expose:

- **`README.md`** — one-screen value prop, install, first-run, link hub.
- **`LICENSE`** — SPDX-identifiable.
- **`CONTRIBUTING.md`** — how to file an issue, open a PR, run tests.
- **`CODE_OF_CONDUCT.md`** — Contributor Covenant or equivalent.
- **`SECURITY.md`** — private disclosure channel; supported versions.
- **`CODEOWNERS`** — path-to-owner graph; quarterly audited.
- **`.github/ISSUE_TEMPLATE/*.yml`** — issue forms with required structured fields.
- **`.github/PULL_REQUEST_TEMPLATE.md`** — checklist: tests, docs, changelog, linked issue.
- **`.github/workflows/*.yml`** — CI, lint, release, stale bot, pinned by SHA.
- **`CHANGELOG.md`** — Keep a Changelog format; `[Unreleased]` at top.
- **`docs/adr/`** — numbered ADRs, append-only, status-tracked.
- **`docs/rfcs/`** — for projects with design-doc culture.
- **`docs/postmortems/`** — incident records with linked action-item issues.
- **`docs/glossary.md`** — domain terms one-liner each.
- **`ROADMAP.md`** — dated, confidence-tagged public plan.
- **`NON-GOALS.md`** — explicit out-of-scope list.
- **`DEPRECATED.md`** — removal schedule with replacements.
- **Label taxonomy** — orthogonal axes (`type/`, `area/`, `priority/`, `status/`, triage labels), synced to `labels.yaml`.
- **Milestones** — one per upcoming release, with due dates.
- **Projects v2 board** — with custom fields (iteration, priority, estimate, risk).
- **Branch protection / rulesets** — on `main`, `release/*`, `lts/*`: required reviews, required checks, required signatures, linear history.
- **Dependabot / Renovate config** — `dependabot.yml` or `renovate.json` with grouped updates.
- **Secret scanning + push protection enabled.**
- **Repository topics** — discoverability metadata.
- **`FUNDING.yml`** — if accepting sponsorship.
- **Branch/tag signing policy** — sigstore/gitsign or GPG.

---

## Monthly Repo Health Query Pack

Ten concrete queries. All use `gh` CLI and assume `REPO=owner/name`.

1. **Median PR merge time (last 30 days)**
   ```bash
   gh pr list -R $REPO --state merged --limit 200 --search "merged:>$(date -d '30 days ago' +%Y-%m-%d)" \
     --json createdAt,mergedAt \
     --jq '[.[] | ((.mergedAt | fromdateiso8601) - (.createdAt | fromdateiso8601))] | sort | .[length/2|floor]'
   ```
   *Purpose:* DORA Lead Time proxy; flag if rising.

2. **PR size distribution**
   ```bash
   gh pr list -R $REPO --state merged --limit 200 --json additions,deletions \
     --jq '[.[] | .additions + .deletions] | sort'
   ```
   *Purpose:* large PRs correlate with defect risk.

3. **Review latency p95 (first review after open)**
   ```bash
   gh api graphql -f query='
     query($q:String!){ search(type:ISSUE, query:$q, first:100){ nodes{ ... on PullRequest {
       createdAt reviews(first:1){nodes{submittedAt}} }}}}' \
     -f q="repo:$REPO is:pr created:>$(date -d '30 days ago' +%Y-%m-%d)"
   ```
   *Purpose:* reviewer-bandwidth signal.

4. **Open-issue triage latency (unlabeled age)**
   ```bash
   gh issue list -R $REPO --state open --search "no:label" --limit 100 \
     --json createdAt --jq '[.[] | (now - (.createdAt|fromdateiso8601))/86400] | add/length'
   ```
   *Purpose:* how long before new issues get classified.

5. **Stale-issue ratio**
   ```bash
   gh issue list -R $REPO --state open --search "updated:<$(date -d '90 days ago' +%Y-%m-%d)" --limit 1000 --json number --jq length
   gh issue list -R $REPO --state open --limit 1000 --json number --jq length
   ```
   *Purpose:* backlog rot.

6. **Dependabot open alerts by severity**
   ```bash
   gh api -X GET /repos/$REPO/dependabot/alerts --paginate -f state=open \
     --jq 'group_by(.security_advisory.severity) | map({sev:.[0].security_advisory.severity, n:length})'
   ```
   *Purpose:* pre-release security gate.

7. **Commit-authorship Gini (bus factor, last 12 mo)**
   ```bash
   gh api /repos/$REPO/stats/contributors --jq 'map(.total) | sort | . as $x | [range(0;length)] as $i
     | (reduce ($i[]) as $k (0; . + ($x[$k] * ($k+1))) * 2 / ((length) * (add))) - ((length+1)/length)'
   ```
   *Purpose:* ownership concentration.

8. **Actions minutes burn (per-workflow, last month)**
   ```bash
   gh api /repos/$REPO/actions/workflows --jq '.workflows[] | .id' | \
     while read id; do
       gh api /repos/$REPO/actions/workflows/$id/timing \
         --jq '{id:'$id', ubuntu:.billable.UBUNTU.total_ms, macos:.billable.MACOS.total_ms}'
     done
   ```
   *Purpose:* CI cost hotspots.

9. **Labels with zero 90-day usage**
   ```bash
   gh api /repos/$REPO/labels --paginate --jq '.[].name' | while read L; do
     N=$(gh api "/search/issues?q=repo:$REPO+label:\"$L\"+updated:>$(date -d '90 days ago' +%Y-%m-%d)" --jq .total_count)
     [ "$N" = "0" ] && echo "$L"
   done
   ```
   *Purpose:* label-taxonomy cleanup input.

10. **New-contributor 2nd-PR conversion (last 180 days)**
    ```bash
    gh api graphql -f query='
      query($q:String!){ search(type:ISSUE, query:$q, first:100){ nodes{ ... on PullRequest {
        author{login} createdAt authorAssociation }}}}' \
      -f q="repo:$REPO is:pr is:merged author-association:FIRST_TIME_CONTRIBUTOR merged:>$(date -d '180 days ago' +%Y-%m-%d)"
    # then join against the same author's later PRs to compute conversion rate
    ```
    *Purpose:* contributor pipeline health (CHAOSS Contributor Retention).

---

## Primary Source Index

- Keep a Changelog — https://keepachangelog.com/en/1.1.0/
- Conventional Commits — https://www.conventionalcommits.org/en/v1.0.0/
- MADR (Markdown ADR) — https://adr.github.io/madr/
- Nygard ADR essay — https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions
- Kubernetes labels source of truth — https://github.com/kubernetes/test-infra/blob/master/label_sync/labels.yaml
- KEPs — https://github.com/kubernetes/enhancements
- Rust RFCs — https://github.com/rust-lang/rfcs
- React RFCs — https://github.com/reactjs/rfcs
- TC39 Process — https://tc39.es/process-document/
- GitHub Issue Forms syntax — https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/syntax-for-issue-forms
- GitHub Projects v2 iteration fields — https://docs.github.com/en/issues/planning-and-tracking-with-projects/understanding-fields/about-iteration-fields
- GitHub CODEOWNERS — https://docs.github.com/en/repositories/managing-your-repositories-settings-and-features/customizing-your-repository/about-code-owners
- GitHub Rulesets — https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets
- GitHub auto-release-notes — https://docs.github.com/en/repositories/releasing-projects-on-github/automatically-generated-release-notes
- DORA / Four Keys — https://cloud.google.com/blog/products/devops-sre/using-the-four-keys-to-measure-your-devops-performance
- Four Keys reference impl — https://github.com/dora-team/fourkeys
- CHAOSS — https://chaoss.community/
- GrimoireLab — https://chaoss.github.io/grimoirelab/
- LFX Insights — https://insights.lfx.linuxfoundation.org/
- OSSInsight — https://ossinsight.io/
- GH Archive — https://www.gharchive.org/
- ClickHouse GH events — https://ghe.clickhouse.tech/
- BigQuery githubarchive — https://console.cloud.google.com/marketplace/product/github/github-repos
- Google SRE Postmortem chapter — https://sre.google/sre-book/postmortem-culture/
- Tim Pope commit-message note — https://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html
- Linux submitting-patches — https://www.kernel.org/doc/html/latest/process/submitting-patches.html
- Jason Etco "Stale bots are a footgun" — https://jasonet.co/posts/stale-bot/
- actions/stale — https://github.com/actions/stale
- Dependabot alerts — https://docs.github.com/en/code-security/dependabot/dependabot-alerts/about-dependabot-alerts
- CodeQL code scanning — https://docs.github.com/en/code-security/code-scanning
- Secret scanning — https://docs.github.com/en/code-security/secret-scanning/about-secret-scanning
- Archiving repos — https://docs.github.com/en/repositories/archiving-a-github-repository/archiving-repositories
- Nx — https://nx.dev/
- Turborepo — https://turborepo.com/
- Bazel — https://bazel.build/
- Org-level default health files — https://docs.github.com/en/communities/setting-up-your-project-for-healthy-contributions/creating-a-default-community-health-file
- Template repos — https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template
- Org-level rulesets — https://docs.github.com/en/organizations/managing-organization-settings/managing-rulesets-for-repositories-in-your-organization
- CHAOSS Contributor Retention metric — https://chaoss.community/kb/metric-contributor-retention/
- semantic-release — https://github.com/semantic-release/semantic-release
- release-please — https://github.com/googleapis/release-please
- git-cliff — https://github.com/orhun/git-cliff
- commitlint — https://commitlint.js.org/
- ThoughtWorks Radar, Lightweight ADRs — https://www.thoughtworks.com/radar/techniques/lightweight-architecture-decision-records
