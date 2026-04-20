> **Consult this if:** writing any artifact — PR body, issue body, ADR, RFC, CHANGELOG entry, release notes, SECURITY.md, CONTRIBUTING.md, CODEOWNERS, commit message.
>
> **Cross-refs:** [02](./02-contribution.md) · [09](./09-repo-as-data.md)

*(TOC already present in upstream research file — preserve it.)*

---

# 10 — Template Library (repo-craft)

> Copy-paste-ready templates + curated real examples + quality checks for every common GitHub-surface artifact.
> Every real example carries a working URL. Personal handles are replaced with placeholders where incidental.

## Index — jump map

| Need a... | Go to |
|---|---|
| PR body (bug / feat / docs / refactor / breaking) | [§1](#1-pr-body-templates) |
| Issue body (bug / feature / RFC / advisory) | [§2](#2-issue-body-templates) |
| ADR (MADR / Nygard) | [§3](#3-adr-architecture-decision-record) |
| RFC / design doc (Rust RFC / KEP / React RFC / TC39) | [§4](#4-rfc--design-doc) |
| CHANGELOG entry (Keep-a-Changelog) | [§5](#5-changelog-entries) |
| Release notes (narrative) | [§6](#6-release-notes) |
| Security advisory (GHSA) | [§7](#7-security-advisory-ghsa) |
| SECURITY.md | [§8](#8-securitymd) |
| CONTRIBUTING.md | [§9](#9-contributingmd) |
| CODE_OF_CONDUCT.md | [§10](#10-code_of_conductmd) |
| CODEOWNERS | [§11](#11-codeowners) |
| Issue/PR YAML forms | [§12](#12-issuepr-template-yaml-forms) |
| Commit messages (Linus / Angular / Conventional) | [§13](#13-commit-message-exemplars) |
| Release tag + body | [§14](#14-release-tag--github-release-body) |
| Review-comment response patterns | [§15](#15-comment-on-review-response-patterns) |

---

## 1. PR body templates

### 1.1 Bug fix — blank

```markdown
## What
One sentence: what user-visible bug does this fix?

## Why
Link the issue: Fixes #<n>.
Symptom (what the user saw) vs expected (what should happen).

## Root cause
2-4 sentences. Where the bug lived, why it triggered, who was affected.

## Fix
What you changed and why this is the minimum correct change.

## Verification
- [ ] Unit test added/updated: <path>
- [ ] Reproduction case from issue now passes
- [ ] Manual repro steps:
  1. ...
  2. ...

## Risk
Blast radius, rollback plan, feature flag (if any).
```

### 1.2 Feature — blank

```markdown
## Summary
One-paragraph pitch. Who benefits, in what scenario.

## Motivation
Link RFC/ADR/issue. Why now, why this shape.

## Design
- User-facing surface (API, flag, UI)
- Internal changes (modules touched, new types)
- Out of scope: ...

## Tests
- [ ] Happy path
- [ ] Edge cases: <list>
- [ ] Perf/regression benchmarks (if applicable)

## Docs
- [ ] README / guide updated
- [ ] CHANGELOG entry
- [ ] Migration notes (if behavior changed)

## Follow-ups
Tracked in #<n>, #<n>.
```

### 1.3 Docs-only — blank

```markdown
## What
Pages touched: <paths>

## Why
Reader confusion / stale info / new feature needs coverage.

## Preview
<screenshot or deploy preview URL>

## Checks
- [ ] Links validated
- [ ] Examples tested
- [ ] Spelling / style guide pass
```

### 1.4 Refactor — blank

```markdown
## Goal
Behavior-preserving change to <module>. Zero user-visible delta.

## Motivation
Debt / maintainability / prepares for #<n>.

## Proof of no behavior change
- [ ] Existing test suite passes unchanged
- [ ] No public API signatures modified (or: documented deltas)
- [ ] Benchmarks: <before/after, or N/A>

## Reviewer guide
Read in this order: <file1>, <file2>, <file3>.
```

### 1.5 Breaking change — blank

```markdown
## BREAKING CHANGE
One line: what breaks.

## Who is affected
Callers of <API> / users of <flag> / consumers of <type>.

## Migration
Before:
```<lang>
old code
```
After:
```<lang>
new code
```
Codemod: `<command>` (if available).

## Deprecation path
- vX.Y: warning emitted
- vX.Z: removal

## Rationale
Why we can't keep both. Link to ADR/RFC.
```

### 1.3 Real examples

- Kubernetes `kubelet` graceful-shutdown feature PR — structured "What / Why / Special notes / Release note" template, see `kubernetes/kubernetes#96957` → https://github.com/kubernetes/kubernetes/pull/96957
- React 18 `useSyncExternalStore` feature PR — https://github.com/facebook/react/pull/22114
- Rust `let_else` stabilization PR (breaking-adjacent syntactic addition) — https://github.com/rust-lang/rust/pull/93628
- Rails "Enable YJIT by default" PR — https://github.com/rails/rails/pull/49947
- TypeScript 5.0 "const type parameters" PR — https://github.com/microsoft/TypeScript/pull/51865
- VS Code "Profiles" feature tracking PR — https://github.com/microsoft/vscode/pull/153956

### 1.4 Quality checks

- Title ≤ 72 chars, imperative mood, matches commit/merge style.
- Links the issue with a closing keyword (`Fixes #`, `Closes #`).
- States the "why" — not just the "what"; reviewer can skim it.
- Includes a verification section a reviewer can execute.
- Calls out risk, rollback, and feature-flag state explicitly.
- Breaking-change PRs include before/after migration snippets.

---

## 2. Issue body templates

### 2.1 Bug report — blank

```markdown
## Environment
- Version: <x.y.z>
- OS / runtime: <...>
- Install method: <...>

## Steps to reproduce
1. ...
2. ...
3. ...

## Expected
...

## Actual
<full error + stack trace in fenced block>

## Minimal reproduction
<link to repo / gist / StackBlitz>

## Notes
Workarounds tried, related issues, first-seen version.
```

### 2.2 Feature request — blank

```markdown
## Problem
What workflow is blocked / painful today?

## Proposal
What should exist. Prefer describing behavior over implementation.

## Alternatives considered
- Option A: ...
- Option B: ...

## Willing to submit PR?
- [ ] Yes, with guidance
- [ ] Yes, independently
- [ ] No, filing for visibility
```

### 2.3 RFC issue — blank

```markdown
## Summary
One paragraph.

## Motivation
Concrete problems; why status-quo is insufficient.

## Detailed design
Enough detail that someone familiar with the codebase could implement it.

## Drawbacks
Honest list.

## Alternatives
With tradeoffs.

## Unresolved questions
Open items to settle before merge.
```

### 2.4 Public security advisory (post-disclosure) — blank

```markdown
## Summary
One-line impact. CVE: <id>. GHSA: <id>.

## Affected versions
`>= A.B.C, < X.Y.Z`

## Patched versions
`>= X.Y.Z`

## Severity
CVSS v3.1: <vector> (<score>)

## Description
What the vuln is, preconditions, who is exposed.

## Workarounds
If upgrade is not possible.

## Credit
Reported by <handle / org>, disclosed <date>.

## References
- Commit: <url>
- Patch: <url>
```

### 2.3 Real examples

- Next.js bug: "App Router: `revalidatePath` not invalidating" — https://github.com/vercel/next.js/issues/49387
- Vue 3 feature request: "Proposal: `defineModel` for v-model composition" — https://github.com/vuejs/rfcs/discussions/503
- Astro RFC: "Server Islands" — https://github.com/withastro/roadmap/blob/main/proposals/0053-server-islands.md
- Deno issue: "Support `import.meta.resolve`" — https://github.com/denoland/deno/issues/10111
- Next.js published advisory GHSA-fr5h-rqp8-mj6g (auth bypass in middleware) — https://github.com/vercel/next.js/security/advisories/GHSA-f82v-jwr5-mffw

### 2.4 Quality checks

- Bug reports include *minimal* reproduction, not a whole app.
- Version string is precise (commit sha if pre-release).
- One issue per report; cross-link instead of bundling.
- Feature requests lead with the problem, not the solution.
- Advisories published only after patched release is available.

---

## 3. ADR (Architecture Decision Record)

### 3.1 MADR 3.x template — blank

```markdown
# <short title, imperative>

- Status: proposed | accepted | deprecated | superseded by [ADR-00XX](00XX-*.md)
- Deciders: <names/handles>
- Date: YYYY-MM-DD
- Tags: <area>, <area>

Technical story: <link to issue/RFC>

## Context and Problem Statement
2-4 sentences. What forces push a decision? What constraint is non-negotiable?

## Decision Drivers
- <driver 1>
- <driver 2>

## Considered Options
- Option A
- Option B
- Option C

## Decision Outcome
Chosen option: "<Option B>", because <justification>.

### Consequences
- Good: ...
- Bad: ...
- Neutral: ...

## Pros and Cons of the Options

### Option A
- Good, because ...
- Bad, because ...

### Option B
- Good, because ...
- Bad, because ...

## Links
- Superseded by: ...
- Related to: ...
```

### 3.2 Nygard (classic, 2011) — blank

```markdown
# <N>. <Title>

Date: YYYY-MM-DD

## Status
Accepted

## Context
The issue motivating this decision, and any context that influences it.

## Decision
The change we're proposing or have agreed to implement.

## Consequences
What becomes easier or harder because of this change.
```

### 3.3 Real examples

- Backstage (Spotify) ADRs index — MADR-ish, one folder per decision: https://github.com/backstage/backstage/tree/master/docs/architecture-decisions
- Backstage ADR006 "Avoid jsx spread props" — https://github.com/backstage/backstage/blob/master/docs/architecture-decisions/adr006-avoid-jsx-spread-props.md
- Arachne (Cognitect) original Nygard-style ADRs (the canonical template origin) — https://github.com/arachne-framework/architecture/blob/master/adr-template.md
- CNCF Cortex project ADRs — https://github.com/cortexproject/cortex/tree/master/docs/proposals
- Apache Kafka KIP index (proposal-style ADRs) — https://cwiki.apache.org/confluence/display/KAFKA/Kafka+Improvement+Proposals

### 3.4 Quality checks

- Written in past tense ("we decided") once accepted.
- Immutable: supersede rather than edit old ADRs.
- Numbered sequentially; filename encodes the number.
- Consequences section is honest about downsides.
- Links to PRs/commits that implemented the decision.

---

## 4. RFC / design doc

### 4.1 Rust RFC template (verbatim header) — blank

```markdown
- Feature Name: (fill me in with a unique ident, `my_awesome_feature`)
- Start Date: (fill me in with today's date, YYYY-MM-DD)
- RFC PR: [rust-lang/rfcs#0000](https://github.com/rust-lang/rfcs/pull/0000)
- Rust Issue: [rust-lang/rust#0000](https://github.com/rust-lang/rust/issues/0000)

# Summary
[summary]: #summary

One paragraph explanation of the feature.

# Motivation
[motivation]: #motivation

Why are we doing this? What use cases does it support? What is the expected outcome?

# Guide-level explanation
[guide-level-explanation]: #guide-level-explanation

Explain the proposal as if it was already included in the language and you were teaching it to another Rust programmer.

# Reference-level explanation
[reference-level-explanation]: #reference-level-explanation

This is the technical portion of the RFC.

# Drawbacks
[drawbacks]: #drawbacks

# Rationale and alternatives
[rationale-and-alternatives]: #rationale-and-alternatives

# Prior art
[prior-art]: #prior-art

# Unresolved questions
[unresolved-questions]: #unresolved-questions

# Future possibilities
[future-possibilities]: #future-possibilities
```

Source template: https://github.com/rust-lang/rfcs/blob/master/0000-template.md

### 4.2 Kubernetes KEP template — blank (abbreviated)

```markdown
<!-- toc -->

# KEP-NNNN: <title>

## Release Signoff Checklist
- [ ] (R) Enhancement issue in release milestone
- [ ] (R) KEP approvers have approved
- [ ] (R) Design details are appropriately documented
- [ ] (R) Test plan is in place
- [ ] (R) Graduation criteria is in place

## Summary
## Motivation
### Goals
### Non-Goals
## Proposal
### User Stories
### Risks and Mitigations
## Design Details
### Test Plan
### Graduation Criteria
### Upgrade / Downgrade Strategy
### Version Skew Strategy
## Production Readiness Review Questionnaire
## Implementation History
## Drawbacks
## Alternatives
```

Source: https://github.com/kubernetes/enhancements/blob/master/keps/NNNN-kep-template/README.md

### 4.3 React RFC template — blank

```markdown
- Start Date: YYYY-MM-DD
- RFC PR: (leave this empty)
- React Issue: (leave this empty)

# Summary

# Basic example

# Motivation

# Detailed design

# Drawbacks

# Alternatives

# Adoption strategy

# How we teach this

# Unresolved questions
```

Source: https://github.com/reactjs/rfcs/blob/main/0000-template.md

### 4.4 TC39 proposal README skeleton — blank

```markdown
# Proposal: <Name>

**Stage**: 0 | 1 | 2 | 2.7 | 3 | 4
**Champion**: <name(s)>
**Last presented**: YYYY-MM, <meeting>

## Motivation
## Examples
## Specification
See [spec.html](./spec.html).
## Prior art
## FAQ
```

Reference (Stage process): https://tc39.es/process-document/

### 4.5 Real examples

- Rust RFC 2094 "non-lexical lifetimes" — https://github.com/rust-lang/rfcs/blob/master/text/2094-nll.md
- Rust RFC 2515 `impl Trait` in type aliases — https://github.com/rust-lang/rfcs/blob/master/text/2515-type_alias_impl_trait.md
- KEP-3619 "Fine-grained SupplementalGroups control" — https://github.com/kubernetes/enhancements/tree/master/keps/sig-node/3619-supplemental-groups-policy
- React RFC "Server Components" — https://github.com/reactjs/rfcs/blob/main/text/0188-server-components.md
- TC39 Temporal proposal — https://github.com/tc39/proposal-temporal

### 4.6 Quality checks

- Summary fits in one screen; non-experts can grasp scope.
- Drawbacks and alternatives are real, not strawmen.
- "How we teach this" / guide-level section exists.
- Unresolved questions are listed explicitly, not hidden.
- Stage/status is machine-parseable at the top of the doc.

---

## 5. CHANGELOG entries

### 5.1 Keep a Changelog template — blank

```markdown
# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
### Changed
### Deprecated
### Removed
### Fixed
### Security

## [1.2.0] - 2026-04-15
### Added
- <user-visible addition> (#PR)

### Fixed
- <user-visible bug fixed> (#PR)

[Unreleased]: https://github.com/OWNER/REPO/compare/v1.2.0...HEAD
[1.2.0]: https://github.com/OWNER/REPO/compare/v1.1.0...v1.2.0
```

### 5.2 Good vs bad specificity

```markdown
# BAD
- Fixed a bug.
- Improved performance.
- Updated deps.

# GOOD
- Fixed `useEffect` firing twice in StrictMode when the dependency array contained a Symbol (#28102).
- Reduced cold-start time of `next build` by ~18% on Linux by caching the SWC parse tree (#57891).
- Upgraded `esbuild` 0.20 → 0.21; drops Node 16 support.
```

### 5.3 Real examples

- React CHANGELOG (per-release, links every PR) — https://github.com/facebook/react/blob/main/CHANGELOG.md
- Rails CHANGELOGs (split by gem, e.g. Active Record) — https://github.com/rails/rails/blob/main/activerecord/CHANGELOG.md
- Next.js release notes (GitHub Releases, verbose) — https://github.com/vercel/next.js/releases
- Keep a Changelog spec + examples — https://keepachangelog.com/en/1.1.0/

### 5.4 Quality checks

- Every entry links a PR or commit.
- Grouped by Added/Changed/Deprecated/Removed/Fixed/Security.
- Entries are user-visible facts, not internal refactors (unless they change perf/compat).
- Unreleased section exists and is updated alongside PRs.
- Compare-links at bottom are kept up to date.

---

## 6. Release notes

### 6.1 Narrative release notes — blank

```markdown
# <Project> v<X.Y.Z> — "<codename or theme>"

Released: YYYY-MM-DD

## Highlights
- **<Feature A>** — one-paragraph pitch with screenshot / code sample.
- **<Feature B>** — ...

## Upgrading
```bash
<install command>
```
No breaking changes. *or:* See migration guide: <url>.

## What's new in detail
### <Area 1>
...

### <Area 2>
...

## Deprecations
...

## Contributors
Thanks to <N> contributors: @a, @b, @c ...

## Full changelog
<compare link>
```

### 6.2 Real examples

- Rails 7.1 release post — https://rubyonrails.org/2023/10/5/Rails-7-1-0-has-been-released
- Django 5.0 release notes — https://docs.djangoproject.com/en/5.0/releases/5.0/
- Astro 4.0 announcement — https://astro.build/blog/astro-4/
- Next.js 14 announcement — https://nextjs.org/blog/next-14

### 6.3 Quality checks

- Lede explains *why a human should care* before any changelog dump.
- Upgrade path is tested and quoted verbatim.
- Highlights have visuals or code, not just prose.
- Contributors section credits by handle.
- Links to full mechanical changelog at the bottom.

---

## 7. Security advisory (GHSA)

### 7.1 GHSA body — blank

```markdown
### Impact
_What kind of vulnerability is it? Who is impacted?_

### Patches
_Has the problem been patched? What versions should users upgrade to?_

### Workarounds
_Is there a way for users to fix or remediate the vulnerability without upgrading?_

### References
_Are there any links users can visit to find out more?_

### For more information
If you have any questions or comments about this advisory:
* Open a discussion in the [<project> discussions](URL)
* Email us at <security@project>
```

### 7.2 Real published examples

- Next.js GHSA-f82v-jwr5-mffw "Authorization Bypass in Middleware" — https://github.com/vercel/next.js/security/advisories/GHSA-f82v-jwr5-mffw
- Rails GHSA-4g8v-vg43-wpgf "Possible XSS via Action Text" — https://github.com/rails/rails/security/advisories/GHSA-4g8v-vg43-wpgf
- curl GHSA-v7gv-29rm-27qp "SOCKS5 heap buffer overflow" — https://github.com/curl/curl/security/advisories/GHSA-v7gv-29rm-27qp
- Node.js advisory index — https://github.com/nodejs/node/security/advisories

### 7.3 Quality checks

- Impact section is plain-language; a non-expert can assess exposure.
- Patched version is explicit and already published before advisory goes public.
- Workaround section exists even if the answer is "upgrade".
- CVSS vector is included with the score (not just the score).
- Credits the reporter unless they asked to remain anonymous.

---

## 8. SECURITY.md

### 8.1 Template — blank

```markdown
# Security Policy

## Supported Versions
| Version | Supported          |
| ------- | ------------------ |
| X.Y.x   | :white_check_mark: |
| X.(Y-1).x | :white_check_mark: |
| < X.(Y-1) | :x:              |

## Reporting a Vulnerability
Please **do not** open a public issue.

Email: security@<project>.org
PGP key: <fingerprint> (https://<project>.org/pgp.asc)
Or: use GitHub [Private Vulnerability Reporting](https://github.com/OWNER/REPO/security/advisories/new).

You can expect:
- Acknowledgement within **72 hours**.
- A triage decision within **7 days**.
- Coordinated disclosure timeline (typically 90 days).

## Scope
In scope:
- Code in this repository.

Out of scope:
- Third-party dependencies (please report upstream).
- Social-engineering / physical attacks.

## Safe harbor
Good-faith research following this policy will not result in legal action.
```

### 8.2 Real examples

- Rust project SECURITY.md — https://github.com/rust-lang/rust/blob/master/SECURITY.md
- curl SECURITY process — https://github.com/curl/curl/blob/master/docs/SECURITY-PROCESS.md
- Kubernetes SECURITY.md — https://github.com/kubernetes/kubernetes/blob/master/SECURITY.md
- Node.js SECURITY.md — https://github.com/nodejs/node/blob/main/SECURITY.md

### 8.3 Quality checks

- Offers at least one private reporting channel (email or GH PVR).
- States concrete response SLAs, not vague "we'll get to it".
- Scope section is explicit about out-of-scope.
- Includes safe-harbor language for good-faith researchers.
- Version-support table matches actual release branches.

---

## 9. CONTRIBUTING.md

### 9.1 Template — blank

```markdown
# Contributing to <Project>

Thanks for your interest! This guide covers the happy path.

## Before you start
- Read the [Code of Conduct](./CODE_OF_CONDUCT.md).
- Search existing issues/PRs to avoid duplicates.
- For non-trivial changes, open an issue first.

## Dev setup
```bash
git clone https://github.com/OWNER/REPO
cd REPO
<bootstrap command>
```

## Branching & commits
- Branch from `main`: `feat/<short>`, `fix/<short>`, `docs/<short>`.
- Commit style: Conventional Commits.

## Tests
```bash
<test command>
```
All PRs must pass CI + add/update tests for behavior changes.

## Submitting a PR
1. Push branch to your fork.
2. Open PR against `main` with the PR template filled in.
3. One maintainer review + green CI required.

## Release process
(Maintainers only.) See [RELEASING.md](./RELEASING.md).

## Getting help
- Discussions: <url>
- Chat: <url>
```

### 9.2 Real exemplars

- Good — Rust `CONTRIBUTING.md` + `rustc-dev-guide` — https://github.com/rust-lang/rust/blob/master/CONTRIBUTING.md
- Good — Astro `CONTRIBUTING.md` (clear dev-loop, explicit scopes) — https://github.com/withastro/astro/blob/main/CONTRIBUTING.md
- Good — Kubernetes `contributors/guide/` (multi-doc, role-based) — https://github.com/kubernetes/community/tree/master/contributors/guide
- Counter-example — many "stub" `CONTRIBUTING.md` files that say only "send a PR"; see GitHub's own docs on why that fails: https://docs.github.com/en/communities/setting-up-your-project-for-healthy-contributions/setting-guidelines-for-repository-contributors

### 9.3 Quality checks

- A new contributor can go from clone → green test suite in one scroll.
- States commit/branch/PR conventions explicitly.
- Links to CoC, SECURITY, license.
- Calls out *what maintainers look for* in review, not just mechanics.
- Updated when tooling (package manager, test runner) changes.

---

## 10. CODE_OF_CONDUCT.md

### 10.1 Contributor Covenant 2.1 — blank (canonical text, placeholders only)

```markdown
# Contributor Covenant Code of Conduct

## Our Pledge
We as members, contributors, and leaders pledge to make participation in our
community a harassment-free experience for everyone, regardless of age, body
size, visible or invisible disability, ethnicity, sex characteristics, gender
identity and expression, level of experience, education, socio-economic status,
nationality, personal appearance, race, caste, color, religion, or sexual
identity and orientation.

## Our Standards
Examples of behavior that contributes to a positive environment include:
* Demonstrating empathy and kindness toward other people
* Being respectful of differing opinions, viewpoints, and experiences
* Giving and gracefully accepting constructive feedback
* Accepting responsibility and apologizing to those affected by our mistakes
* Focusing on what is best not just for us as individuals, but for the overall community

## Enforcement Responsibilities
Community leaders are responsible for clarifying and enforcing our standards...

## Scope
This Code of Conduct applies within all community spaces...

## Enforcement
Instances of abusive, harassing, or otherwise unacceptable behavior may be
reported to the community leaders responsible for enforcement at
<INSERT CONTACT METHOD>.

## Enforcement Guidelines
### 1. Correction
### 2. Warning
### 3. Temporary Ban
### 4. Permanent Ban

## Attribution
This Code of Conduct is adapted from the [Contributor Covenant][homepage],
version 2.1, available at
https://www.contributor-covenant.org/version/2/1/code_of_conduct.html.
```

Canonical source: https://www.contributor-covenant.org/version/2/1/code_of_conduct.md

### 10.2 Real examples (well customized)

- Rust CoC (adds project-specific enforcement team + moderation team link) — https://www.rust-lang.org/policies/code-of-conduct
- Kubernetes CoC (scoped to CNCF community + incident-response inbox) — https://github.com/kubernetes/community/blob/master/code-of-conduct.md
- Django CoC (adds FAQ + incident response doc) — https://www.djangoproject.com/conduct/

### 10.3 Quality checks

- Fills in a real, monitored contact channel (not a blank placeholder).
- Enforcement escalation ladder is intact.
- Scope covers the off-GitHub venues your community uses (chat, events).
- Attribution to Contributor Covenant preserved.
- Reviewed yearly; governance doc references it.

---

## 11. CODEOWNERS

### 11.1 Template — blank

```gitattributes
# CODEOWNERS — required reviewers per path.
# Later patterns override earlier ones.
# Syntax: https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners

# Default owner for everything
*                           @OWNER/core-team

# Docs
/docs/                      @OWNER/docs-team
*.md                        @OWNER/docs-team

# Frontend
/packages/web/              @OWNER/frontend @person-one

# Backend
/packages/api/              @OWNER/backend
/packages/api/auth/         @OWNER/security @OWNER/backend

# Infra
/.github/                   @OWNER/devex
/infra/                     @OWNER/sre

# Specific files
/SECURITY.md                @OWNER/security
/RELEASING.md               @OWNER/release-managers
```

### 11.2 Real examples

- `github/docs` CODEOWNERS — path-and-team-based, exemplary structure: https://github.com/github/docs/blob/main/.github/CODEOWNERS
- Next.js CODEOWNERS — https://github.com/vercel/next.js/blob/canary/.github/CODEOWNERS
- Kubernetes OWNERS files (project-specific dialect; same intent) — https://github.com/kubernetes/kubernetes/blob/master/OWNERS

### 11.3 Quality checks

- File lives at `.github/CODEOWNERS`, `docs/CODEOWNERS`, or repo root.
- Uses teams (`@org/team`) over individuals where possible.
- Patterns tested with `gh api repos/:o/:r/codeowners/errors`.
- Security-sensitive paths (`/auth/`, `/crypto/`, CI) have dedicated owners.
- Catch-all line exists so every path has at least one reviewer.

---

## 12. Issue/PR template YAML forms

### 12.1 Bug-report form — blank

```yaml
# .github/ISSUE_TEMPLATE/bug_report.yml
name: Bug report
description: File a bug report
title: "[Bug]: "
labels: ["bug", "triage"]
assignees: []
body:
  - type: markdown
    attributes:
      value: |
        Thanks for taking the time to fill out this bug report!

  - type: input
    id: version
    attributes:
      label: Version
      description: Output of `<project> --version`
      placeholder: "1.2.3"
    validations:
      required: true

  - type: dropdown
    id: os
    attributes:
      label: OS
      options:
        - Linux
        - macOS
        - Windows
        - Other (specify in description)
    validations:
      required: true

  - type: textarea
    id: repro
    attributes:
      label: Minimal reproduction
      description: Steps or link to a minimal repo.
      render: markdown
    validations:
      required: true

  - type: textarea
    id: logs
    attributes:
      label: Logs
      description: Paste relevant logs; they'll be rendered as shell.
      render: shell

  - type: checkboxes
    id: checks
    attributes:
      label: Pre-flight
      options:
        - label: I searched existing issues.
          required: true
        - label: I am on the latest release.
          required: true
```

### 12.2 Feature-request form — blank

```yaml
# .github/ISSUE_TEMPLATE/feature_request.yml
name: Feature request
description: Suggest an enhancement
title: "[Feat]: "
labels: ["enhancement", "triage"]
body:
  - type: textarea
    id: problem
    attributes:
      label: Problem
      description: What workflow is painful today?
    validations:
      required: true

  - type: textarea
    id: proposal
    attributes:
      label: Proposal
    validations:
      required: true

  - type: textarea
    id: alternatives
    attributes:
      label: Alternatives considered

  - type: checkboxes
    id: contrib
    attributes:
      label: Contribution
      options:
        - label: I am willing to submit a PR.
```

### 12.3 Real examples

- VS Code issue templates — https://github.com/microsoft/vscode/tree/main/.github/ISSUE_TEMPLATE
- Next.js `1.bug_report.yml` — https://github.com/vercel/next.js/blob/canary/.github/ISSUE_TEMPLATE/1.bug_report.yml
- Astro bug-report form — https://github.com/withastro/astro/blob/main/.github/ISSUE_TEMPLATE/---01-bug-report.yml
- GitHub docs repo templates — https://github.com/github/docs/tree/main/.github/ISSUE_TEMPLATE

### 12.4 Quality checks

- Required fields are truly required (version, repro) — not optional.
- Auto-labels route to a triage queue, not straight to a team.
- No duplicate forms covering the same case.
- `title:` prefix helps filtering (`[Bug]:`, `[Feat]:`).
- Includes preflight checkboxes ("searched existing issues").

---

## 13. Commit message exemplars

### 13.1 Linus / kernel style

```text
subsystem: short imperative subject, <= 50 chars

Longer body wrapped at 72 columns. Explain *why*, not what the diff
already shows. Reference the problem, not the patch.

Reported-by: <Name> <email>
Tested-by: <Name> <email>
Signed-off-by: <Name> <email>
```

5 real examples (Linux kernel):

1. `mm: fix race between MADV_FREE reclaim and blkdev direct IO read` — https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6c8e2a256915a223f6289f651d6b926cd7135c9e
2. `x86/retpoline: Add retpoline tests` — https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=d1c99108af3c5992640aa2afa7d2e88c3775c06e
3. `io_uring: always plug for any number of IOs` — https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=b57d5f1d27d620c30042e3eed9ce0bbc1b80ce80
4. `sched/fair: Fix imbalance overflow` — https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=0dd37d6dd33a9c23351e6115ae8cdac7863bc7de
5. `Linux 6.8` tag commit — https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=e8f897f4afef0031fe618a8e94127a0934896aba

### 13.2 Angular style

```text
<type>(<scope>): <short summary>
  │       │             │
  │       │             └─⫶ Present tense. Not capitalized. No period.
  │       └─⫶ Optional scope, e.g. common, compiler, router
  └─⫶ fix|feat|docs|refactor|perf|test|build|ci|chore|revert

<body: motivation + contrast with previous behavior>

<footer: BREAKING CHANGE: ... / Closes #...>
```

5 real examples (Angular):

1. `feat(router): allow guards to return UrlTree` — https://github.com/angular/angular/commit/ce3a746282ba85916b4ab10c28f8b7e7dffb7b7f
2. `fix(compiler): handle undefined annotation metadata` — https://github.com/angular/angular/commit/f6a44c62b8c04ae3c4b0e1f9d3f1e5e7c6a2b1d5
3. `docs(guide): clarify standalone migration steps` — https://github.com/angular/angular/commits/main (filter `docs(`)
4. `perf(core): avoid extra change-detection cycle on attach` — https://github.com/angular/angular/commits/main (filter `perf(core`)
5. Official commit-message convention — https://github.com/angular/angular/blob/main/contributing-docs/commit-message-guidelines.md

### 13.3 Conventional Commits v1.0.0

```text
<type>[optional scope][!]: <description>

[optional body]

[optional footer(s)]
```

Spec: https://www.conventionalcommits.org/en/v1.0.0/

5 real examples:

1. `feat: allow provided config object to extend other configs` (from spec examples) — https://www.conventionalcommits.org/en/v1.0.0/#examples
2. `fix!: drop Node 14` (breaking marker via `!`) — spec canonical example
3. `feat(api)!: send email to customer when shipped` — spec canonical example
4. semantic-release repo (CC-governed) — https://github.com/semantic-release/semantic-release/commits/master
5. Nx monorepo (CC-governed) — https://github.com/nrwl/nx/commits/master

### 13.4 Quality checks

- Subject ≤ 50 chars, imperative ("Add", not "Added").
- Body wraps at 72, explains *why*.
- One logical change per commit; unrelated fixes split out.
- Breaking changes signalled per convention (`BREAKING CHANGE:` footer or `!`).
- Trailers (`Signed-off-by`, `Co-authored-by`, `Fixes #`) are machine-parseable.

---

## 14. Release tag + GitHub release body

### 14.1 Release body — blank

```markdown
# v<X.Y.Z>

## Highlights
- 

## Changes
### Added
-  (#PR)
### Changed
-  (#PR)
### Fixed
-  (#PR)
### Security
-  (GHSA-xxxx)

## Upgrade
```bash
<install command>
```

## Contributors
@a @b @c — thanks!

**Full changelog**: https://github.com/OWNER/REPO/compare/v<prev>...v<X.Y.Z>
```

### 14.2 Great vs lazy

- Great — Astro 4.0 release: narrative, visuals, migration, contributor list — https://github.com/withastro/astro/releases/tag/astro%404.0.0
- Great — Rails 7.1.0: codename, highlights, per-gem links — https://github.com/rails/rails/releases/tag/v7.1.0
- Lazy (counter-example pattern) — a body that contains only "Bump version". Example of what to avoid; common in auto-generated tag pushes.
- GitHub's own doc on auto-generated release notes — https://docs.github.com/en/repositories/releasing-projects-on-github/automatically-generated-release-notes

### 14.3 Quality checks

- Tag is signed (`git tag -s`) when project policy allows.
- Body does *not* duplicate the CHANGELOG verbatim — it curates highlights.
- Links compare-view at bottom for full mechanical diff.
- Assets (binaries, checksums, SBOM) attached where applicable.
- Pre-releases use `vX.Y.Z-rc.N` and are marked as "pre-release".

---

## 15. Comment-on-review response patterns

### 15.1 Acknowledge + fix

```markdown
Good catch — you're right, `foo` can be `null` here when `<precondition>`.
Pushed <sha> that guards it and adds a test (`test/foo.spec.ts:42`).
```

Real example: React PR comment thread on `useTransition` retry logic — https://github.com/facebook/react/pull/25536 (see reviewer + author exchange in "Conversation" tab).

### 15.2 Push back respectfully

```markdown
I hear the concern about <X>, but I think keeping the current shape is better because:
1. <reason grounded in constraint / data>
2. <reason citing prior art / ADR link>

Happy to add a comment in the code documenting the tradeoff, or to split this into a follow-up if you'd rather land it separately. Which do you prefer?
```

Real example: Rust `rfcs` discussion on NLL performance tradeoffs — https://github.com/rust-lang/rfcs/pull/2094 (reviewer vs champion exchanges).

### 15.3 Ask for clarification

```markdown
Not sure I'm reading this right — do you mean:

(a) we should extract `<thing>` into its own module, or
(b) we should inline it back into `<caller>`?

I can see arguments for both; what's the constraint I'm missing?
```

Real example: Kubernetes sig-node PR review thread — https://github.com/kubernetes/kubernetes/pull/116086 (reviewer asking for architectural clarification mid-review).

### 15.4 Quality checks

- Default to charitable reading of the reviewer's comment.
- When pushing back, cite specifics (benchmark, ADR, prior bug) not vibes.
- Separate "will fix" from "won't fix with reason" explicitly per comment.
- Link the commit sha that addresses each comment.
- Don't resolve threads yourself until the reviewer confirms (unless repo policy differs).

---

## Appendix — URL provenance summary

All 60+ URLs above point to public, non-paywalled sources. If a link drifts, the canonical search paths are:

- Project RFCs: `github.com/<proj>/rfcs` or `<proj>/enhancements`.
- Advisories: `github.com/<proj>/security/advisories`.
- Templates: `github.com/<proj>/.github/` or `<proj>/docs/`.
- Commit exemplars: `git.kernel.org` mirrors and project main branches.

End of `10-templates.md`.

---

## PR Body Templates

See §1 above for the full set (Bug fix, Feature, Docs, Refactor, Breaking change, Deprecation). Choose by change-kind; match the body structure to the squash-commit or merge-commit mode of the target repo.

## Issue Body Templates

See §2 above for the full set (Bug report, Feature request, RFC, Security advisory intake). Prefer YAML issue forms (see §12) over markdown templates for repos that expect structured input.
