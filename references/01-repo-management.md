> **Consult this if:** setting up a new repo, auditing your own repo's health, picking a release automation tool, configuring branch protection / CODEOWNERS / community files, or scaling governance from solo to TSC.
>
> **Cross-refs:** [05#release-tool-decision](./05-methodology-business.md#release-tool-decision) · [09](./09-repo-as-data.md) · [15#repo-security-baseline](./15-security.md#repo-security-baseline)

## Table of Contents

- [Branch Strategy](#branch-strategy)
- [Branch Protection](#branch-protection)
- [CODEOWNERS](#codeowners)
- [Issue and PR Templates](#issue-and-pr-templates)
- [Release Automation](#release-automation)
- [Community Health Files](#community-health-files)
- [CI CD Patterns](#ci-cd-patterns)
- [Automation Bots](#automation-bots)
- [Security Posture](#security-posture)
- [Governance Models](#governance-models)
- [Case Studies](#case-studies)
- [Top 10 Actionable Practices](#top-10-actionable-practices)

---

# Repo Management: How Best-in-Class Maintainers Run Repos They Own

Reference material for the GitHub orchestration skill. Target user: experienced engineer running personal + commercial repos. Every claim cites a URL; durability > cleverness.

---

## Branch Strategy

There are three canonical models. The choice is a function of release cadence, engineering maturity, and compliance constraints — not personal preference.

- **GitHub Flow** — one long-lived `main` branch, short-lived feature branches, PR + CI, deploy on merge. Simple, fast, assumes continuous deployment and solid CI. Originally documented by GitHub; Scott Chacon's 2011 essay is the canonical source ([github-flow](https://githubflow.github.io/)). Best for SaaS, web apps, small teams, anything deployed frequently.
- **GitFlow** — Vincent Driessen's 2010 model with `main`, `develop`, `feature/*`, `release/*`, `hotfix/*`. Heavy; built for versioned, shippable software with parallel releases. Driessen himself added a "reflections" note in 2020 recommending GitHub Flow for most modern teams ([nvie.com — A successful Git branching model](https://nvie.com/posts/a-successful-git-branching-model/)). Use only when shipping installable artifacts with multiple simultaneously-supported versions (embedded, enterprise on-prem, SDKs with LTS lines).
- **Trunk-Based Development (TBD)** — everyone integrates to `main` at least daily, using short-lived branches (<24h) or direct commits, plus feature flags to decouple deploy from release. See [trunkbaseddevelopment.com](https://trunkbaseddevelopment.com/) and [Atlassian's overview](https://www.atlassian.com/continuous-delivery/continuous-integration/trunk-based-development). Unlocks highest throughput but requires strong CI, feature flags, and team discipline.

**Decision heuristic.** Solo maintainer on a web app / library with CI? Default to **GitHub Flow**. Library with N supported major versions or on-prem customers? **GitFlow** (or GitHub Flow + long-lived release branches). Team ≥10 with multi-deploy-per-day throughput and LaunchDarkly-style flags? **TBD** ([LaunchDarkly comparison](https://launchdarkly.com/blog/git-branching-strategies-vs-trunk-based-development/)).

---

## Branch Protection

The modern path is **repository rulesets**, not legacy branch protection rules. Rulesets layer, support tags + branches, apply at org-level, and don't have a mutually-exclusive priority model — the most restrictive rule wins across aggregated rulesets ([GitHub Docs — About rulesets](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets), [Available rules for rulesets](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/available-rules-for-rulesets)).

Minimum viable protection for a default branch:

1. **Require a pull request before merging** with at least 1 approving review (2 for commercial / revenue-critical repos).
2. **Dismiss stale reviews on new commits** — prevents rubber-stamping old diffs.
3. **Require review from Code Owners** — only fires if a `CODEOWNERS` file exists ([About code owners](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners)).
4. **Require status checks to pass** and **require branches to be up to date** before merge.
5. **Require linear history** — forces squash or rebase merges, no merge commits; this plays nicely with release-please and semantic-release changelog generation ([Managing a branch protection rule](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/managing-a-branch-protection-rule)).
6. **Require signed commits** — verified GPG, SSH, or Sigstore/gitsign signatures only.
7. **Require conversation resolution** before merge.
8. **Block force pushes** and **deletions**.
9. **Require merge queue** for repos with >5 merges/day to avoid semantic conflicts in CI ([Managing a merge queue](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges/managing-a-merge-queue)).

## CODEOWNERS

`CODEOWNERS` lives at `.github/CODEOWNERS` (preferred), root, or `docs/`. Syntax follows gitignore globbing; **last matching pattern wins** ([Graphite in-depth CODEOWNERS guide](https://graphite.com/guides/in-depth-guide-github-codeowners)). Best practices: assign ownership to **teams**, not individuals; require owner review on `.github/CODEOWNERS` itself to prevent silent removal ([Arnica CODEOWNERS guide](https://www.arnica.io/blog/what-every-developer-should-know-about-github-codeowners)); teams need write permission for approvals to count.

---

## Issue and PR Templates

**Classic templates** (markdown) live at `.github/ISSUE_TEMPLATE/*.md` and `.github/PULL_REQUEST_TEMPLATE.md`. **Issue forms** (recommended since 2022 GA) live at `.github/ISSUE_TEMPLATE/*.yml` and use GitHub's form schema ([Syntax for issue forms](https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/syntax-for-issue-forms), [Syntax for GitHub's form schema](https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/syntax-for-githubs-form-schema)). Forms enforce structure (input, textarea, dropdown, checkboxes) and auto-apply labels via the `labels:` frontmatter — always prefer forms for bug reports and feature requests. A `.github/ISSUE_TEMPLATE/config.yml` can disable blank issues and add `contact_links` to Discussions / Discord / Stack Overflow.

**Label taxonomy** (copy from Kubernetes — they run the most-studied labeling system in OSS):

- `kind/*` — `kind/bug`, `kind/feature`, `kind/cleanup`, `kind/documentation`, `kind/flake`.
- `priority/*` — `priority/critical-urgent`, `priority/important-soon`, `priority/important-longterm`, `priority/backlog`, `priority/awaiting-more-evidence`.
- `area/*` — functional area (e.g. `area/cli`, `area/api`, `area/docs`).
- `sig/*` — special interest group ownership (use for multi-team repos).
- `triage/*` — `triage/needs-information`, `triage/duplicate`, `triage/not-reproducible`.
- `good first issue`, `help wanted` — GitHub's [well-known labels](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/creating-an-issue#creating-an-issue-from-a-repository) that power Explore surfacing.
- Source: [kubernetes/test-infra label_sync](https://github.com/kubernetes/test-infra/blob/master/label_sync/labels.md).

**Milestones** map to releases (e.g. `v2.3.0`) or time-boxed sprints (`2026-Q2`). Keep ≤3 open at a time; stale milestones signal project drift.

---

## Release Automation

Four live tools plus one deprecated. Pick one; don't mix.

| Tool | Versioning signal | Monorepo story | Best for |
|---|---|---|---|
| **semantic-release** ([repo](https://github.com/semantic-release/semantic-release)) | Conventional Commits parsed at release time | Weak; community `semantic-release-monorepo` plugin last updated 2022 ([Hamza comparison](https://www.hamzak.xyz/blog-posts/release-management-for-nx-monorepos-semantic-release-vs-changesets-vs-release-it-)) | Single-package Node libraries wanting full automation and fastest "commit → published" path |
| **release-please** ([repo](https://github.com/googleapis/release-please), [manifest docs](https://github.com/googleapis/release-please/blob/main/docs/manifest-releaser.md)) | Conventional Commits, but materialized as a **release PR** | First-class monorepo via `release-please-config.json` + `.release-please-manifest.json`; supports Node, Python, Go, Rust/Cargo, Java, Elixir, Ruby, PHP | Polyglot repos, monorepos, anyone who wants a human-reviewable release PR before publishing |
| **Changesets** ([repo](https://github.com/changesets/changesets), [decisions doc](https://github.com/changesets/changesets/blob/main/docs/decisions.md)) | **Contributor-authored** `.md` intent files in `.changeset/` | Best-in-class for JS/TS monorepos (pnpm, npm workspaces, Yarn) | npm monorepos (Next.js, Remix, shadcn-ui, Vercel SDKs); decouples versioning from commit messages ([Oleksii Popov guide](https://oleksiipopov.com/blog/npm-release-automation/)) |
| **release-drafter** ([repo](https://github.com/release-drafter/release-drafter)) | **Label-based**, categorizes merged PRs into a draft | Weak — not a versioner, a notes generator | Teams that manually cut versions but want auto-drafted release notes |
| **standard-version** | Conventional Commits, local CLI | None | **Deprecated** — [repo explicitly recommends release-please](https://github.com/conventional-changelog/standard-version) |

**Decision tree.**

- Single-package Node library, you trust Conventional Commits, you want zero friction → **semantic-release**.
- Monorepo OR polyglot OR regulated environment wanting a release-PR checkpoint → **release-please**.
- JS/TS monorepo with 3+ packages and independent versioning → **Changesets**.
- App (not library) with no npm publish, just tagged releases → **release-drafter** + manual tag, or a tiny GitHub Actions workflow.

---

## Community Health Files

GitHub surfaces these in the "Community Standards" tab. Defaults can be set once in an org-level `.github` repo ([Creating a default community health file](https://docs.github.com/en/communities/setting-up-your-project-for-healthy-contributions/creating-a-default-community-health-file)); repo-specific versions override.

- **`README.md`** — what, why, install, quickstart, links.
- **`LICENSE`** — SPDX-identified; MIT/Apache-2.0 for permissive, AGPL/GPL for copyleft, BSL/Elastic for commercial-OSS hybrid.
- **`CONTRIBUTING.md`** — dev setup, test commands, branch strategy, commit conventions, PR expectations.
- **`CODE_OF_CONDUCT.md`** — Contributor Covenant 2.1 is the de-facto standard.
- **`SECURITY.md`** — supported versions, private vuln reporting channel (prefer GitHub Private Vulnerability Reporting over email).
- **`SUPPORT.md`** — where to get help (NOT GitHub Issues for usage questions).
- **`.github/FUNDING.yml`** — GitHub Sponsors, Open Collective, Ko-fi, Patreon, Tidelift, custom URLs; surfaces the Sponsor button ([Display a sponsor button](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/displaying-a-sponsor-button-in-your-repository)).
- **`CITATION.cff`** — Citation File Format YAML; GitHub parses it and shows "Cite this repository" on the sidebar. Mandatory for academic/research projects ([About CITATION files](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-citation-files)).
- **`GOVERNANCE.md`** — roles, decision rights, voting. Required once a second maintainer joins. Example: [withastro/.github GOVERNANCE.md](https://github.com/withastro/.github/blob/main/GOVERNANCE.md).

Reference orgs to copy from: [github/.github](https://github.com/github/.github), [doocs/.github](https://github.com/doocs/.github).

---

## CI CD Patterns

- **Reusable workflows** (`workflow_call`) are the DRY primitive. Centralize `build+test+lint` as a reusable workflow in a `.github` repo and call it from each project; pin by SHA, not tag ([Control the concurrency of workflows and jobs](https://docs.github.com/actions/writing-workflows/choosing-what-your-workflow-does/control-the-concurrency-of-workflows-and-jobs)).
- **Matrix** — run across Node/Python/OS/DB versions in parallel; use `fail-fast: false` in libraries so one cell failure doesn't hide others; `max-parallel` to throttle paid runners ([Matrix Builds](https://www.blacksmith.sh/blog/matrix-builds-with-github-actions)).
- **Concurrency groups** — `group: ${{ github.workflow }}-${{ github.ref }}` + `cancel-in-progress: true` for PR CI (kill superseded runs). For deploys, use `cancel-in-progress: false` to avoid partial deploys; shared external resources get dedicated groups ([Concurrency docs](https://docs.github.com/en/actions/concepts/workflows-and-actions/concurrency)).
- **Required checks** — configured in the ruleset, not in the workflow. The check name must match the job name exactly. Remember to include the `merge_group` event in triggers if using merge queue ([Merge queue docs](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges/managing-a-merge-queue)).
- **Caching** — `actions/cache` with language-specific keys (`hashFiles('**/pnpm-lock.yaml')`); prefer the bundled cache in `setup-node`/`setup-python`/`setup-go`.
- **Artifacts** — `actions/upload-artifact@v4` for coverage, builds, test reports; set `retention-days: 7` for non-release artifacts to control storage cost.
- **Permissions** — default `permissions: {}` at workflow level, grant per-job (`contents: read`, `id-token: write` for OIDC).
- **Pin third-party actions by SHA**, not `@v1` — protects against tag rewrite supply-chain attacks (historical Tj-actions/changed-files incident).

---

## Automation Bots

| Bot | Purpose | Config location |
|---|---|---|
| **Dependabot** | Dependency PRs, security updates, version updates | `.github/dependabot.yml` |
| **Renovate** | Superset of Dependabot — 90+ managers, custom regex, merge-confidence, dashboard issue ([Renovate docs bot comparison](https://docs.renovatebot.com/bot-comparison/)) | `renovate.json` or `.github/renovate.json5` |
| **CodeQL** | SAST via GitHub Advanced Security | `.github/workflows/codeql.yml` |
| **stale** ([actions/stale](https://github.com/actions/stale)) | Auto-close inactive issues/PRs | `.github/workflows/stale.yml` |
| **lock-threads** ([dessant/lock-threads](https://github.com/dessant/lock-threads)) | Lock resolved issues/PRs after N days to prevent necromancy | `.github/workflows/lock.yml` |
| **auto-assign** ([kentaro-m/auto-assign-action](https://github.com/kentaro-m/auto-assign-action)) | Assign reviewers on PR open | `.github/auto_assign.yml` |
| **triage-action** ([actions/labeler](https://github.com/actions/labeler)) | Auto-label PRs by path | `.github/labeler.yml` |
| **release-please-action** | Release PR automation | `.github/workflows/release-please.yml` |

**Dependabot vs Renovate.** Dependabot is the zero-config default for GitHub-only repos (UI toggle, free, covers 30+ ecosystems). Renovate is the choice when you need grouped PRs by default, a dashboard issue, merge-confidence scoring, or cross-platform support (GitLab, Bitbucket, Gitea) ([PullNotifier comparison](https://blog.pullnotifier.com/blog/dependabot-vs-renovate-dependency-update-tools)). Don't run both simultaneously.

---

## Security Posture

Ordered by ROI; enable top-down until you run out of time budget.

1. **Secret scanning + push protection** — free on public repos, part of GitHub Secret Protection on private. Blocks secrets at push time, not after ([About push protection](https://docs.github.com/en/code-security/secret-scanning/introduction/about-push-protection)). GA'd pattern configuration in August 2025 ([GitHub changelog](https://github.blog/changelog/2025-08-19-secret-scanning-configuring-patterns-in-push-protection-is-now-generally-available/)).
2. **Signed commits** — GPG, SSH, or Sigstore/gitsign (keyless, OIDC-backed). Enforce via ruleset "Require signed commits."
3. **CodeQL** — GitHub-native SAST; enable default setup from Security tab. Scales to 10+ languages.
4. **Dependabot security alerts + auto-PRs** — free on all repos.
5. **Pin Actions by SHA + `permissions: {}`** — hardens workflow execution against compromised upstream actions.
6. **OpenSSF Scorecard Action** — scheduled workflow that scores your repo against 18+ checks (dependency-update-tool, token-permissions, pinned-dependencies, signed-releases, etc.). Publishes to [scorecard.dev](https://scorecard.dev/) ([ossf/scorecard](https://github.com/ossf/scorecard)).
7. **SLSA Level 3 provenance** — use [slsa-framework/slsa-github-generator](https://github.com/slsa-framework/slsa-github-generator) to sign releases with Sigstore; dedicated Node.js builder for npm with `npm provenance` flag ([SLSA 3 compliance blog post](https://github.blog/security/supply-chain-security/slsa-3-compliance-with-github-actions/)).
8. **OpenSSF Best Practices Badge** — three metal tiers (passing: 67 criteria, silver: +55, gold: +23) ([bestpractices.dev](https://www.bestpractices.dev/en), [openssf.org/projects/best-practices-badge](https://openssf.org/projects/best-practices-badge/)). Worth it for commercial libraries where procurement asks.
9. **Private Vulnerability Reporting** — enable in Security tab; replaces `security@` inbox, gives a structured, CVE-linked intake.

---

## Governance Models

Source: [Open Source Guides — Leadership and Governance](https://opensource.guide/leadership-and-governance/), [Red Hat overview](https://www.redhat.com/en/blog/understanding-open-source-governance-models).

- **BDFL (Benevolent Dictator for Life)** — one person with final authority. Works 1–5 maintainers; becomes bottleneck beyond. Python ran BDFL until Guido stepped down in 2018, then adopted a Steering Council ([Open Source Guides](https://opensource.guide/leadership-and-governance/)).
- **Meritocracy / Do-ocracy** — influence follows contribution. Apache Software Foundation pioneered it. Ambiguous on tie-breaking; pairs well with a thin TSC layer.
- **TSC (Technical Steering Committee)** — elected/appointed small group (3–9) with defined voting rules, tie-breakers, term limits. Node.js, Astro, OpenJS Foundation projects. Documented in `GOVERNANCE.md`.
- **SIG/WG model** — Kubernetes-style federation of persistent Special Interest Groups (SIGs) and time-boxed Working Groups (WGs) under a top-level Steering Committee ([kubernetes/community governance.md](https://github.com/kubernetes/community/blob/master/governance.md)). Scales to hundreds of maintainers; heavy overhead for <20.
- **Layered (Linux)** — BDFL-adjacent top (Linus), meritocracy subsystem maintainers listed in `MAINTAINERS`, email-driven patch flow ([docs.kernel.org submitting-patches](https://docs.kernel.org/process/submitting-patches.html)).

**Heuristic.** Solo/duo: BDFL implicit, no `GOVERNANCE.md` needed. 3–8 maintainers: document BDFL-with-lieutenants in `GOVERNANCE.md`. 9+: elect a TSC. >30: adopt SIG model or split the repo.

---

## Case Studies

- **Kubernetes** — SIG + Steering Committee model ([governance.md](https://github.com/kubernetes/community/blob/master/governance.md)). Copy: (a) the `sig/*` + `area/*` + `priority/*` + `kind/*` label hierarchy ([test-infra labels](https://github.com/kubernetes/test-infra/blob/master/label_sync/labels.md)); (b) Kubernetes Enhancement Proposals (KEPs) as a numbered, templated RFC process living in-repo; (c) SIG charters documenting scope, leadership selection, and meeting cadence.
- **React / Meta** — corporate-sponsored with internal-to-GitHub bridge; Meta engineers' changes sync from internal source control, community PRs tested against Facebook's codebase before sync-back. Copy: (a) a `facebook/react` style `CONTRIBUTING.md` with explicit "how we merge" section; (b) the RFC repo pattern ([reactjs/rfcs](https://github.com/reactjs/rfcs)); (c) sister-repo split (`react` / `react-native` / `rfcs` / `react.dev`).
- **Vue (Evan You)** — independent BDFL + sponsorship-funded core team ([Vue team page](https://vuejs.org/about/team.html), [vuejs/governance](https://github.com/vuejs/governance/blob/master/Team-Charter.md)). Copy: (a) the three-tier role system (Contributor, Committer, Maintainer); (b) public funding via GitHub Sponsors + Patreon in `FUNDING.yml`; (c) a separate `governance` repo for the charter.
- **TypeScript (Microsoft)** — BDFL-ish with a public design team. Copy: (a) [Design Meeting Notes](https://github.com/microsoft/TypeScript/issues?q=label%3A%22Design+Notes%22) published as labeled issues; (b) a documented proposal lifecycle (Suggestion → In Discussion → Committed); (c) CLA gate via Microsoft's cla-bot.
- **Rust** — team-based meritocracy with RFC process ([rust-lang/rfcs](https://github.com/rust-lang/rfcs), [Rust Governance RFC 1068](https://rust-lang.github.io/rfcs/1068-rust-governance.html)). Copy: (a) numbered RFCs with templated sections (Summary, Motivation, Guide-level explanation, Reference-level explanation, Drawbacks, Alternatives, Unresolved questions); (b) team-per-domain structure with shepherds; (c) Final Comment Period (FCP) with explicit 10-day clock before merge.
- **Node.js** — TSC with elected chair, public YouTube-streamed meetings ([nodejs/node GOVERNANCE.md](https://github.com/nodejs/node/blob/main/GOVERNANCE.md), [TSC issue 962 on RFC interest](https://github.com/nodejs/TSC/issues/962)). Copy: (a) recorded public meetings; (b) `GOVERNANCE.md` with voting thresholds; (c) the collaborator onboarding pipeline.
- **Astro** — TSC capped at 5, explicit L1/L2/L3 maintainer ladder ([withastro/.github GOVERNANCE.md](https://github.com/withastro/.github/blob/main/GOVERNANCE.md), [withastro/roadmap](https://github.com/withastro/roadmap)). Copy: (a) RFC roadmap repo; (b) level-gated voting rights; (c) L2+ champion requirement before RFC acceptance.
- **Svelte** — BDFL-lite with concise `CONTRIBUTING.md` ([svelte/CONTRIBUTING.md](https://github.com/sveltejs/svelte/blob/main/CONTRIBUTING.md)). Copy: (a) `pnpm` + Changesets monorepo layout; (b) short tests-first contributor guide; (c) using GitHub Discussions for design, not Issues.
- **Linux kernel** — subsystem-maintainer hierarchy with email-based patch flow. Copy (adapted to GitHub): (a) a `MAINTAINERS` file mapping paths to owners — GitHub's `CODEOWNERS` is the modern equivalent ([docs.kernel.org MAINTAINERS](https://docs.kernel.org/process/maintainers.html)); (b) Signed-off-by / DCO enforcement via [DCO app](https://github.com/apps/dco); (c) subsystem profile documents describing what each owner expects from patches.

---

## Top 10 Actionable Practices

1. Default to GitHub Flow + linear history; only adopt GitFlow if you ship multiple supported versions, or TBD if you deploy multiple times per day with feature flags.
2. Configure protection via repository rulesets (not legacy branch protection): required PR review, Code Owner review, status checks, linear history, signed commits, conversation resolution, no force-push.
3. Put `CODEOWNERS` in `.github/CODEOWNERS`, assign to teams not individuals, and make the CODEOWNERS file itself owned by engineering leadership.
4. Use YAML issue forms (`.github/ISSUE_TEMPLATE/*.yml`) with auto-applied labels, and disable blank issues via `config.yml`.
5. Adopt the Kubernetes `kind/* priority/* area/* triage/*` label taxonomy plus the well-known `good first issue` and `help wanted` labels.
6. For releases, choose release-please for polyglot/monorepo, Changesets for JS monorepos, semantic-release for single-package Node libraries; never mix tools; treat standard-version as deprecated.
7. Ship the full community-health file set (`CONTRIBUTING`, `CODE_OF_CONDUCT`, `SECURITY`, `SUPPORT`, `FUNDING.yml`, `CITATION.cff` when applicable, `GOVERNANCE.md` once you have 3+ maintainers).
8. Centralize CI as reusable workflows, use concurrency groups with `cancel-in-progress: true` on PRs, pin third-party Actions by SHA, default `permissions: {}`, and enable merge queue once you exceed ~5 merges/day.
9. Enable, in order: secret scanning + push protection, signed commits, CodeQL, Dependabot, SHA-pinned Actions, OpenSSF Scorecard Action, SLSA-3 provenance via slsa-github-generator, Private Vulnerability Reporting; target OpenSSF Best Practices "passing" badge minimum for commercial libs.
10. Document governance explicitly in `GOVERNANCE.md`: solo → BDFL implicit; 3–8 → BDFL-with-lieutenants; 9+ → elected TSC; 30+ → adopt Kubernetes-style SIGs, with a numbered in-repo RFC process (copy Rust's template) for any change touching public API.
