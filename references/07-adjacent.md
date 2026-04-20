> **Consult this if:** an adjacent signal fires — project lifecycle, LTS, security advisory, bus factor, attribution/credit norms, community channels, legal/compliance, or project hygiene.
>
> **Cross-refs:** [15](./15-security.md) (deep security) · [09](./09-repo-as-data.md) (hygiene)

## Table of Contents

- [Lifecycle Stability](#lifecycle-stability)
- [Security Supply Chain](#security-supply-chain)
- [Human Factors](#human-factors)
- [Community Communication](#community-communication)
- [Legal Compliance](#legal-compliance)
- [Project Hygiene](#project-hygiene)
- [Adjacent-Topic Trigger Map](#adjacent-topic-trigger-map)

---

# 07 — Adjacent Subjects: Grab-Bag Reference for GitHub Skill

Scope: topics adjacent to core repo management + contribution that are easy to forget but frequently load-bearing in real-world open-source work. Each entry is self-contained. The skill consults this file when a specific situation matches a trigger. The final section is a Trigger Map table for fast lookup.

---

## Lifecycle Stability

### 1. Project lifecycle stages

**What it is.** Software projects move through rough stages — pre-alpha, alpha, beta, release candidate, 1.0 stable, maintenance/LTS, deprecated, archived, abandoned — each signaling a different contract between maintainers and contributors.

**When it matters.** Before investing in a non-trivial PR, large refactor, or new integration; when deciding whether to adopt the library at all; when picking an issue to tackle.

**What to do.**
1. Check README, website, and most recent release notes for an explicit stability statement (e.g. "alpha, API will change" or "production-ready").
2. Cross-check with Semantic Versioning: `0.x.y` usually means unstable public API per semver.org rule 4; `1.0.0+` implies stability commitments.
3. For maintenance-mode / deprecated projects, scope contributions narrowly — bug fixes and docs over features. For archived/abandoned, consider a fork (see §4).
4. If GitHub shows the "Archived" banner at repo top, treat as read-only.

Citations: https://semver.org/ ; https://docs.github.com/en/repositories/archiving-a-github-repository/archiving-repositories ; https://endoflife.date/ for tracking lifecycle dates.

### 2. LTS / backporting

**What it is.** Long-Term Support branches receive security + critical fixes for a defined window (often 2-5 years) after the feature-tracking main branch has moved on. Exemplars: Node.js even-number releases at nodejs.org/en/about/previous-releases, Ubuntu X.04 LTS (5 yrs + 5 yrs ESM), Django LTS every 3rd feature release (3 yrs), Python final minor in each series (5 yrs).

**When it matters.** Reporting a bug found on an LTS version; wanting to propose a fix backport; writing production code that must target an LTS.

**What to do.**
1. Identify LTS branches by naming convention (`v18.x`, `stable-3.2`, `release/4.2`, `24.04`) and repo banners.
2. Open the fix against the main/default branch first; once merged, propose a cherry-pick PR targeting the LTS branch.
3. Label appropriately (`backport`, `needs-backport`, or use bots like Mergify/backport-bot).
4. For LTS branches, restrict yourself to security or regression fixes — no feature additions, no API changes. Django's backporting policy is explicit at docs.djangoproject.com/en/dev/internals/release-process/.

Citations: https://nodejs.org/en/about/previous-releases ; https://ubuntu.com/about/release-cycle ; https://docs.djangoproject.com/en/dev/internals/release-process/ ; https://devguide.python.org/versions/.

### 3. Deprecation policy

**What it is.** A deprecation marks a feature for future removal. *Soft* deprecation emits a runtime or compile warning without behavior change; *hard* deprecation actually removes the feature in a future version.

**When it matters.** Contributing behavior changes that break public API; retiring an old option; bumping a minimum-version requirement.

**What to do.**
1. Read project's deprecation policy first (often in CONTRIBUTING.md or governance docs).
2. Stage it: add a visible warning (`DeprecationWarning` in Python, console.warn in Node, `@deprecated` JSDoc/JavaDoc, Rust `#[deprecated]`) in version N. Document in CHANGELOG.
3. Keep the soft deprecation for at least one minor (preferably one major) release cycle so downstream can migrate.
4. Only remove in a major version bump with clear migration docs and a "Removed" section in release notes.

Citations: https://peps.python.org/pep-0387/ ; https://doc.rust-lang.org/reference/attributes/diagnostics.html#the-deprecated-attribute ; https://jsdoc.app/tags-deprecated.

### 4. Abandonment detection

**What it is.** Determining whether a project is effectively dead before you rely on it or try to contribute.

**When it matters.** Evaluating a dependency; wondering if your PR will ever get reviewed; deciding whether to fork.

**What to do.**
1. Signals: last commit >12 months, last release >18 months, open issues accumulating with no maintainer replies, open PRs untriaged >6 months, maintainer last active (profile page) >6 months.
2. Check `SECURITY.md`, `MAINTAINERS.md`, and recent release notes for any "looking for maintainers" call.
3. Heuristics: isitmaintained.com for response-time metrics; Libraries.io SourceRank; OpenSSF Scorecard "Maintained" check (>=1 commit/month averaged over 90 days).
4. Fork etiquette: preserve attribution, keep original LICENSE, open an issue on the original offering to hand back or coordinate, rename if there is brand risk (see §22), and announce on community channels.

Citations: https://github.com/ossf/scorecard/blob/main/docs/checks.md#maintained ; https://isitmaintained.com/ ; https://opensource.guide/leadership-and-governance/#transferring-ownership-of-a-project.

---

## Security Supply Chain

### 5. Security advisories (private reporting)

**What it is.** GitHub's mechanism for privately reporting, discussing, and patching vulnerabilities before public disclosure — GitHub Security Advisories (GHSA).

**When it matters.** You found a vulnerability (auth bypass, RCE, SSRF, privilege escalation, data exposure) in a repo. Public issue = irresponsible disclosure. Use private channel.

**What to do.**
1. Check repo's `SECURITY.md` or the `Security` tab for preferred reporting channel. If "Private vulnerability reporting" is enabled, click `Security > Advisories > Report a vulnerability`.
2. If not enabled, email the address in SECURITY.md, or use huntr.com/openbugbounty, or contact the maintainer privately.
3. Provide: affected versions, reproduction steps, impact assessment, suggested CVSS.
4. Agree on an embargo/disclosure timeline (often 90 days, industry norm per Google Project Zero).

Citations: https://docs.github.com/en/code-security/security-advisories/guidance-on-reporting-and-writing-information-about-vulnerabilities/about-coordinated-disclosure-of-security-vulnerabilities ; https://docs.github.com/en/code-security/security-advisories/working-with-repository-security-advisories/configuring-private-vulnerability-reporting-for-a-repository.

### 6. CVE assignment flow

**What it is.** A CVE ID uniquely labels a vulnerability for global tracking. GitHub is a CNA (CVE Numbering Authority), so GHSAs on GitHub-hosted repos can request a CVE without involving MITRE directly.

**When it matters.** Fix is ready; you want the issue indexed in the NVD and scanner databases (Dependabot, Snyk, OSV).

**What to do.**
1. Within the GHSA draft, click "Request CVE ID" (GitHub CNA handles MITRE assignment).
2. If project is not on GitHub, request via MITRE's form at cveform.mitre.org.
3. Complete the advisory (CWE, CVSS vector, patched versions, workarounds, credits) before publishing. Once published, it flows to NVD and the OSV/GitHub Advisory Database within ~24h.
4. For package ecosystems, add CVE metadata to release notes and push a patch release.

Citations: https://docs.github.com/en/code-security/security-advisories/working-with-repository-security-advisories/publishing-a-repository-security-advisory ; https://cve.mitre.org/cve/request_id.html ; https://osv.dev/.

### 7. SBOM (Software Bill of Materials)

**What it is.** A machine-readable inventory of all components, versions, and licenses that make up a software artifact. Two dominant formats: CycloneDX (OWASP) and SPDX (Linux Foundation, ISO/IEC 5962:2021).

**When it matters.** Release pipeline for production software; compliance (US EO 14028, EU CRA); any time you ship a binary and want downstreams to audit it; when a CVE drops and you need to know "are we affected".

**What to do.**
1. Generate at build time with `syft` (anchore/syft) or language-native tools (`cdxgen`, `npm sbom`, `pip-audit --format=cyclonedx`).
2. Attach the SBOM as a release asset (JSON). GitHub also exposes a built-in SBOM via repo `Insights > Dependency graph > Export SBOM`.
3. Sign it (cosign attest) so downstreams can verify authenticity.
4. Re-generate per release; never hand-edit.

Citations: https://cyclonedx.org/specification/overview/ ; https://spdx.dev/ ; https://docs.github.com/en/code-security/supply-chain-security/understanding-your-software-supply-chain/exporting-a-software-bill-of-materials-for-your-repository ; https://www.cisa.gov/sbom.

### 8. SLSA levels 1-4

**What it is.** Supply-chain Levels for Software Artifacts — a graduated framework (L1-L4, plus L0) for build-integrity assurance. v1.0 published 2023.

**When it matters.** Hardening a release pipeline; meeting enterprise procurement requirements; publishing artifacts others depend on.

**What to do.** (build track)
1. **L1** — Document build process; emit provenance (who built what, from which source). Easily done via GitHub Actions + `slsa-github-generator`.
2. **L2** — Hosted build platform generates signed provenance. Use GitHub-hosted runners + Sigstore attestations (`actions/attest-build-provenance`).
3. **L3** — Hardened build: isolated, non-falsifiable provenance, no mutable dependencies, no shared caches between builds. Use reusable workflows with restricted permissions.
4. **L4** — (removed from v1.0 build track; hermetic/reproducible builds now tracked separately).

Citations: https://slsa.dev/spec/v1.0/levels ; https://github.com/slsa-framework/slsa-github-generator ; https://docs.github.com/en/actions/security-guides/using-artifact-attestations-to-establish-provenance-for-builds.

### 9. Signed commits + Sigstore/gitsign

**What it is.** Cryptographic commit signing proves authorship. Historic path is GPG/SSH keys. Modern path: keyless signing via Sigstore (OIDC identity from GitHub/Google → short-lived cert → transparency log).

**When it matters.** Projects that require "Verified" badges, enterprise audits, supply-chain hardening, reproducible provenance.

**What to do.**
1. GPG path: `gpg --full-gen-key`, `git config --global user.signingkey <keyid>`, `git config --global commit.gpgsign true`, upload pub key to github.com/settings/keys. SSH signing: set `gpg.format ssh`.
2. Sigstore path: install `gitsign` (sigstore/gitsign), configure `gpg.x509.program=gitsign` and `gpg.format=x509`. Commits get ephemeral cert tied to your OIDC identity — no long-term key.
3. For tags: `git tag -s`. For release artifacts: `cosign sign` / `cosign sign-blob`.
4. Enforce via branch protection: "Require signed commits".

Citations: https://docs.github.com/en/authentication/managing-commit-signature-verification ; https://docs.sigstore.dev/cosign/signing/gitsign/ ; https://www.sigstore.dev/.

### 10. Dependency pinning

**What it is.** Locking dependencies to specific versions (and ideally hashes) so builds are reproducible and supply-chain attacks are resisted.

**When it matters.** Library vs application distinction. Libraries use loose ranges; applications and CI pipelines should pin tightly.

**What to do.**
1. Commit the lockfile: `package-lock.json` / `yarn.lock` / `pnpm-lock.yaml` / `poetry.lock` / `uv.lock` / `Cargo.lock` (apps only) / `Gemfile.lock` / `go.sum`.
2. Pin GitHub Actions by SHA, not tag: `uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683 # v4.2.2`. Tags are mutable.
3. Automate upgrades with Dependabot (`.github/dependabot.yml`) or Renovate (`renovate.json`) — both support SHA pinning and grouping.
4. For Python, also use `pip-tools` / `uv pip compile` with `--generate-hashes` so `pip install --require-hashes` verifies content.

Citations: https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions#using-third-party-actions ; https://docs.renovatebot.com/configuration-options/ ; https://github.com/dependabot/dependabot-core ; https://pip-tools.readthedocs.io/.

---

## Human Factors

### 11. Bus factor / maintainer burnout

**What it is.** "Bus factor" = number of people who would have to be hit by a bus to stall the project. Burnout shows when solo maintainers run out of energy.

**When it matters.** Deciding whether the project is healthy enough to adopt; deciding how to file that 12th bug report this week.

**What to do.**
1. Signals: single-name `git shortlog -sn` distribution, long response delays, terse/irritable replies, explicit calls for help in README/issues, maintainer blog posts about burnout.
2. Be the contributor you'd want: minimal reproductions, proposed fixes with tests, don't bump/ping.
3. Offer triage help via issue labels, PR reviews of other contributors. Ask "how can I help?" — not "when will you fix this?".
4. Sponsor via GitHub Sponsors / OpenCollective / Tidelift if that's available.

Citations: https://opensource.guide/leadership-and-governance/ ; https://www.rkoster.org/maintaining-open-source ; https://github.com/readme/featured/open-source-mental-health.

### 12. Graceful exits

**What it is.** How to end a contribution relationship cleanly: closing your own stale PRs, abandoning or archiving a fork, handing off a project.

**When it matters.** Your PR has been open 6+ months with unresolved feedback; you no longer use your fork; you're stepping down as maintainer.

**What to do.**
1. Stale PRs: leave a one-paragraph comment summarizing current state, close with `gh pr close --comment "Closing for hygiene; happy to reopen if priorities change"`, preserve the branch if someone may pick it up.
2. Abandoned fork: prefer archive over delete (preserves links, shows state). `gh repo archive`. Add a banner to README pointing to the upstream or successor.
3. Maintainership handoff: document in MAINTAINERS.md, transfer repo via `Settings > Transfer ownership`, rotate secrets, update CODEOWNERS, announce on community channels.
4. Don't silently disappear — a one-line "I can no longer maintain this" note is better than ghosting.

Citations: https://docs.github.com/en/repositories/archiving-a-github-repository/archiving-repositories ; https://docs.github.com/en/repositories/creating-and-managing-repositories/transferring-a-repository.

### 13. Attribution + credit norms

**What it is.** Mechanisms for recording who contributed what.

**When it matters.** Merging PRs; releasing versions; recognizing non-code contributors (docs, design, review).

**What to do.**
1. `Co-authored-by: Name <email>` trailer in commit messages — GitHub renders both contributors.
2. Maintain AUTHORS / CONTRIBUTORS files; package manifests support this: `package.json` `contributors` array, `pyproject.toml` `authors`, `Cargo.toml` `authors`.
3. For non-code contributions, adopt the all-contributors bot (github.com/all-contributors/all-contributors) — it recognizes docs, design, ideas, review, etc.
4. Source-file level: use SPDX headers (`SPDX-FileCopyrightText: 2026 Name <email>`, `SPDX-License-Identifier: MIT`) — machine-readable and REUSE-compliant.

Citations: https://docs.github.com/en/pull-requests/committing-changes-to-your-project/creating-and-editing-commits/creating-a-commit-with-multiple-authors ; https://allcontributors.org/ ; https://reuse.software/spec/.

### 14. Conflict resolution

**What it is.** Process for disagreement between contributor and maintainer (or between maintainers).

**When it matters.** Your PR is rejected; a design discussion stalls; feedback feels wrong.

**What to do.**
1. Separate technical from personal. Restate the other's position in your words before rebutting. Provide evidence (benchmarks, RFC precedent, linked discussions).
2. Request a second opinion from another maintainer or call for a broader discussion (issue tag, mailing list, RFC repo).
3. Escalate through project governance: steering committee, TSC, foundation TAC. Most CNCF/Apache projects have formal processes.
4. Accept "no" with grace when it comes. File the work in your fork; it may become the seed of a successor project, or the decision may be revisited later.

Citations: https://www.contributor-covenant.org/version/2/1/code_of_conduct/ ; https://www.apache.org/foundation/voting.html ; https://github.com/cncf/foundation/blob/main/governance.md.

### 15. Hostile environments

**What it is.** Communities where tone, gatekeeping, or absent enforcement make contribution unsafe or unproductive.

**When it matters.** Early read of a repo before investing time.

**What to do.**
1. Signals: no CODE_OF_CONDUCT.md, or one that's never enforced; public shaming of contributors in issues; cliquey maintainer cabal; personal attacks; minimized responses ("RTFM", "not a bug", immediate close).
2. Check issue archives for the tone of rejection; look at how first-time contributors are treated.
3. Have a "walk away" signal in advance: one rude exchange, you close your PR and leave a neutral note. Your time is limited.
4. Report CoC violations through the documented channel; if none exists, that is itself the signal.

Citations: https://www.contributor-covenant.org/ ; https://opensource.guide/code-of-conduct/.

---

## Community Communication

### 16. Community channels

**What it is.** Synchronous/asynchronous venues distinct from GitHub issues.

**When it matters.** Design discussion too open-ended for an issue; quick question; real-time debugging help; following project direction.

**What to do.**
1. Find them: README, website `Community` page, or `CONTRIBUTING.md`.
2. Common venues: Discord (gamedev, web3, hobby), Slack (enterprise-adjacent, Kubernetes at slack.k8s.io), Zulip (topic-threaded — Rust at rust-lang.zulipchat.com, Lean), Matrix (FOSS-friendly), Gitter (legacy, now Matrix-backed), IRC (Libera.Chat for GNU/Linux stack), Discourse forums (Rust users, Julia, Elixir), mailing lists (GNU Mailman, lore.kernel.org for Linux, Python discuss).
3. Follow venue norms: IRC = one line, no screenshots; Zulip = topic per thread; Discourse = searchable, write a clean opening post.
4. Move decisions back to GitHub issues/PRs — chat is ephemeral and un-searchable for non-members.

Citations: https://zulip.com/why-zulip/ ; https://libera.chat/ ; https://lore.kernel.org/ ; https://www.kernel.org/doc/html/latest/process/submitting-patches.html (for mailing-list workflow).

### 17. Response-time expectations by project type

**What it is.** Calibration of polling cadence to the project's resourcing model.

**When it matters.** Wondering whether to bump your PR.

**What to do.**
1. Solo hobbyist, no funding: weeks to months is normal. Do not bump before 2 weeks.
2. Sponsored solo (GitHub Sponsors / Tidelift): days to ~1 week.
3. Corporate-backed single-vendor project: 1-3 business days typical, SLA in CONTRIBUTING.md sometimes.
4. Foundation project (CNCF, Apache, Linux Foundation): varies by SIG/working group; check WG meeting cadence (often biweekly) and tag the appropriate reviewer group.
5. Calibration heuristic: match the project's own response time to previous PRs in the archive before deciding to nudge.

Citations: https://opensource.guide/best-practices/#its-okay-to-put-a-pause-on-your-project ; https://www.cncf.io/projects/ project maturity levels.

### 18. Cross-timezone etiquette

**What it is.** Norms for async-first collaboration across the globe.

**When it matters.** Maintainers in different timezones; contributing to a project whose core team is abroad.

**What to do.**
1. Assume async: don't @-mention expecting same-day response outside the person's working hours.
2. Compose in one long message rather than many short ones — let them catch up in one pass.
3. Include all context a reviewer needs (repro, expected vs actual, versions) so they don't have to ping you back.
4. For scheduled nudges, pick their daytime: everytimezone.com or World Clock in GitHub profile bio.

Citations: https://about.gitlab.com/company/culture/all-remote/asynchronous/ ; https://github.com/readme/guides/remote-work.

### 19. Inclusive language audit

**What it is.** Replacing exclusionary or ambiguous terms with clearer, inclusive alternatives.

**When it matters.** Writing docs; renaming branches; reviewing PRs.

**What to do.**
1. Common swaps: `master` → `main` (branches, see GitHub 2020 change), `blacklist/whitelist` → `denylist/allowlist`, `slave` → `replica/secondary/follower`, `man hours` → `person-hours`, gendered pronouns → singular they / role nouns.
2. Accessibility: alt text on all images/screenshots, avoid color-only meaning, describe diagrams in prose.
3. Tools: `inclusivelint`, `woke`, `alex` linter in CI.
4. For long-established terms in protocols (e.g., `MASTER` in SPI), follow upstream's lead — the IETF has guidance in RFC draft-knodel-terminology.

Citations: https://github.blog/changelog/2020-10-01-the-default-branch-for-newly-created-repositories-is-now-main/ ; https://datatracker.ietf.org/doc/draft-knodel-terminology/ ; https://github.com/get-alex/alex.

### 20. Translating contribution

**What it is.** i18n (internationalization) vs l10n (localization) contributions — different workflows from code.

**When it matters.** You want to add/improve a language; you found a typo in a translated string.

**What to do.**
1. Check if project uses a translation platform: Crowdin (Electron, Nextcloud), Weblate (KDE, libre), Transifex (Django, historical), Pontoon (Mozilla).
2. If yes, register there and submit via their UI — strings sync back to repo via bot PRs. Direct PRs editing `.po`/`.xliff`/`.json` are often rejected because they'll be overwritten.
3. If no platform, follow `CONTRIBUTING.md` for locale files (`locales/es.json`, `i18n/fr.po`). Ensure you follow ICU message format / gettext plural rules.
4. For docs translation, check for a sibling repo or `docs-translations/` subtree.

Citations: https://crowdin.com/ ; https://weblate.org/ ; https://pontoon.mozilla.org/ ; https://www.w3.org/International/questions/qa-i18n.

---

## Legal Compliance

### 21. Export controls

**What it is.** US ITAR (defense articles), EAR (dual-use), EU dual-use regulation, plus country-specific sanctions (OFAC SDN list) restrict who can receive certain technology — including cryptography and certain AI/ML.

**When it matters.** Strong crypto, ML models over certain compute thresholds, projects with military applications, or contributions from sanctioned jurisdictions.

**What to do.**
1. Check `LICENSE` and `README` for export-control notice (`ECCN 5D002`, "subject to EAR"). Many projects publish under TSU exception (§740.13(e)) for publicly available source.
2. If you are in a sanctioned country, GitHub may restrict your account — see the GitHub trade controls FAQ.
3. Don't contribute military-specific enhancements without legal advice.
4. Maintainers of crypto projects: file BIS notification under TSU if required for non-public builds.

Citations: https://docs.github.com/en/site-policy/other-site-policies/github-and-trade-controls ; https://www.bis.doc.gov/index.php/policy-guidance/encryption ; https://www.ecfr.gov/current/title-15/subtitle-B/chapter-VII/subchapter-C.

### 22. Trademark separate from license

**What it is.** Software licenses (MIT, Apache-2.0, GPL) grant copyright + patent rights, but **not** trademark rights. The project name, logo, and marks are separately protected.

**When it matters.** Forking, renaming, distributing modified builds, creating "compatible" products.

**What to do.**
1. Read the project's trademark policy (often `TRADEMARK.md` or on the foundation website — e.g. linuxfoundation.org/trademarks, apache.org/foundation/marks/).
2. If forking and redistributing with modifications: rename the fork. Don't use the upstream logo on your marketing. Use phrasing like "compatible with X" or "based on X" carefully.
3. Apache-2.0 §6 explicitly disclaims trademark rights — assume the same for all licenses.
4. Commercial distributions often require a trademark license agreement (Red Hat/Rocky/AlmaLinux dynamics, HashiCorp BUSL moves).

Citations: https://www.apache.org/foundation/marks/ ; https://www.linuxfoundation.org/legal/trademark-usage ; https://opensource.org/faq#trademarks.

### 23. Employer IP assignment

**What it is.** Most employment contracts assign employee inventions/code to the employer, sometimes including side projects.

**When it matters.** Contributing on personal time to an external repo while employed, especially in a related field.

**What to do.**
1. Read your employment agreement (PIIA / CIIA / inventions clauses). Look for `prior inventions schedule`, `scope of assignment`, `outside activities`.
2. If the contribution is related to employer's field, request written permission or use the company's open-source contribution program.
3. File new side projects on the "prior inventions" list when you join a new employer.
4. Some states (e.g., California Labor Code §2870) limit assignment when work is done on your own time with your own equipment and unrelated to employer's business — but prove it in writing in advance.

Citations: https://leginfo.legislature.ca.gov/faces/codes_displaySection.xhtml?sectionNum=2870&lawCode=LAB ; https://opensource.google/documentation/reference/releasing (as an example corporate OSS policy) ; https://cla.opensource.microsoft.com/ (CLA signals employer-aware contribution).

### 24. GDPR + data privacy in issue reports

**What it is.** EU GDPR, UK GDPR, CCPA and similar laws restrict processing of personal data (emails, IPs, usernames, logs with PII, tokens, session data).

**When it matters.** Pasting logs/stack traces/screenshots into public issues; collecting telemetry; handling user-submitted bug reports.

**What to do.**
1. Redact before pasting: emails, user IDs, IPs, access tokens, JWT payloads, session cookies. Replace with `<redacted>`, `user@example.com`, `192.0.2.1` (documentation IP).
2. For screenshots, blur UI regions; use `pngquant`/manual tools. Consider browser devtools to scrub network panels before recording.
3. If a reporter pastes PII, edit the issue promptly and delete the email notification contents via GitHub support if severe.
4. For maintainers: add a note to `CONTRIBUTING.md` and issue templates asking for redacted logs; never store bug-report data outside the issue without a retention policy.

Citations: https://gdpr.eu/ ; https://www.rfc-editor.org/rfc/rfc5737 (documentation IP addresses) ; https://docs.github.com/en/site-policy/privacy-policies/github-general-privacy-statement.

---

## Project Hygiene

### 25. Repository archiving

**What it is.** Marking a repo read-only on GitHub; preserved and visible but no new issues/PRs/pushes.

**When it matters.** Project is done (feature-complete, superseded, or abandoned). Better than deletion (preserves links, SEO, history).

**What to do.**
1. Settings → Danger zone → Archive this repository, or `gh repo archive owner/name`.
2. Update README banner: "This project is no longer maintained. See <successor> for ongoing work." before archiving.
3. For contributors: `archived: true` means no new issues/PRs; you can still fork. If you urgently need a fix, fork-and-patch is your only path.
4. Unarchive is possible (Settings again) but signals indecision — avoid flip-flopping.

Citations: https://docs.github.com/en/repositories/archiving-a-github-repository/archiving-repositories ; https://cli.github.com/manual/gh_repo_archive.

### 26. Repo renames and redirects

**What it is.** GitHub preserves redirects when you rename a user/org or repo. Old URLs HTTP 301 to new ones; git remote URLs continue to work.

**When it matters.** Renaming to a more descriptive name; migrating from personal account to org; rebranding.

**What to do.**
1. Settings → Rename. GitHub auto-redirects web URLs and git operations. Old issue/PR links and clones keep working.
2. **Gotchas:** hardcoded URLs in CI configs that expect exact names; webhooks tied to old repo URL (re-authorize); badge URLs in READMEs; `go get` paths (add `go-import` meta or import rewrite).
3. Update `package.json` repository/homepage/bugs URLs, `pyproject.toml` project URLs, `Cargo.toml` repository field.
4. Communicate in README, release notes, and community channels. Tag a final release under the old name with a note.

Citations: https://docs.github.com/en/repositories/creating-and-managing-repositories/renaming-a-repository ; https://go.dev/ref/mod#vcs-find.

### 27. Monorepo primer

**What it is.** Single repo containing multiple related packages/services/apps. Tools: Nx, Turborepo, pnpm workspaces, Yarn workspaces, Lerna-Lite, Bazel, Pants, Buck2, Rush.

**When it matters.** Contributing to a large project like React, Babel, Next.js, NestJS, Angular — or any foundation-scale repo.

**What to do.**
1. Read the `README.md` and root config (`nx.json`, `turbo.json`, `pnpm-workspace.yaml`, `WORKSPACE`). Orient to packages under `packages/*` or `apps/*` + `libs/*`.
2. Scope your changes: test and CI may run only affected packages via `nx affected` / `turbo run --filter`. Path filters in GitHub Actions (`paths:`) also common.
3. Respect CODEOWNERS at the per-package level — reviewers auto-assigned by path.
4. Use package-scoped commit messages where required (Conventional Commits `feat(my-package): ...`).

Citations: https://nx.dev/concepts/mental-model ; https://turborepo.com/docs ; https://pnpm.io/workspaces ; https://bazel.build/about/intro.

### 28. Subtree + submodule

**What it is.** Two ways to embed an upstream dependency's source inside your repo. `git submodule` links to a specific commit of another repo (lightweight pointer). `git subtree` copies the upstream history into your tree (heavier but self-contained).

**When it matters.** You need to vendor an upstream that has no package release, must modify it, or want atomic snapshots.

**What to do.**
1. **Submodule** when upstream is stable, independently tracked, and contributors have network access. `git submodule add <url> path/to/sub`. Downsides: extra clone step, detached HEADs confuse contributors.
2. **Subtree** when you want a single-repo clone, occasional merge-ups from upstream, and simpler contributor experience. `git subtree add --prefix=path/to/sub <url> main --squash`.
3. Vendoring alternative for lockstep control: copy files, record upstream commit in `VENDOR.md`, re-sync via script.
4. Document the choice in README so future contributors know how to update.

Citations: https://git-scm.com/book/en/v2/Git-Tools-Submodules ; https://git-scm.com/book/en/v2/Git-Tools-Advanced-Merging#_subtree_merging ; https://www.atlassian.com/git/tutorials/git-subtree.

### 29. Documentation-as-code sites

**What it is.** Static documentation sites generated from Markdown/MDX in the repo. Docusaurus (React, FB), VitePress (Vue, lightweight), Starlight (Astro), Mintlify (hosted), MkDocs + Material (Python), ReadTheDocs (hosted, Sphinx-based), Nextra.

**When it matters.** Contributing to docs separately from code; fixing a typo on the website.

**What to do.**
1. Find docs source: often in `docs/`, `website/`, or a separate `-docs` repo linked from the main site footer.
2. Preview locally: `npm run docs:dev` / `mkdocs serve` / `sphinx-autobuild docs _build`. Check the deploy preview (Vercel/Netlify/CF Pages) posted by the PR bot.
3. Follow the project's writing style guide (tone, headings, code-sample conventions).
4. Doc-only PRs should be labeled and can usually bypass heavy code review.

Citations: https://docusaurus.io/docs ; https://vitepress.dev/ ; https://starlight.astro.build/ ; https://www.mkdocs.org/ ; https://docs.readthedocs.io/.

### 30. Benchmarks + regression tracking

**What it is.** Automated performance measurement on PRs to prevent regressions. Tools: CodSpeed (PR comment with flame graphs), Criterion.rs (Rust), Google Benchmark (C++), JMH (Java), pytest-benchmark (Python), hyperfine (CLI), `cargo bench`, `go test -bench`.

**When it matters.** Performance-sensitive libraries (parsers, compilers, web frameworks, crypto, ML kernels); any PR touching hot paths.

**What to do.**
1. Run the project's benchmark suite before and after your change. Post deltas in the PR description.
2. Respect hardware noise: multiple runs, report median + stddev. Use `taskset`/`cpupower` on Linux to pin CPU.
3. For big changes, add a new benchmark case covering the change.
4. If CI runs benchmarks, don't fight the bot — investigate any regression >threshold (often 2-5%) before asking for review.

Citations: https://codspeed.io/docs ; https://bheisler.github.io/criterion.rs/book/ ; https://github.com/google/benchmark ; https://pytest-benchmark.readthedocs.io/.

---

## Adjacent-Topic Trigger Map

| Signal (what you observe) | Topic to consult | Quick action |
|---|---|---|
| README says "alpha" or version `0.x` | §1 Lifecycle stages | Scope PR small; expect API churn; avoid large refactors |
| Branch named `v18.x`, `stable-*`, `release/*` | §2 LTS / backporting | Land on main first, then cherry-pick PR to LTS; security/regression only |
| Want to remove/change a public API | §3 Deprecation policy | Warn for ≥1 minor cycle; remove only in major bump |
| Last commit >12 mo, issues piling up | §4 Abandonment detection | Verify with Scorecard/isitmaintained; fork with attribution if needed |
| Found a vulnerability (auth/RCE/SSRF/etc) | §5 Security advisories | Use `Security > Report a vulnerability`, not public issue |
| Advisory ready, want global tracking | §6 CVE flow | Request CVE inside GHSA draft (GitHub is a CNA) |
| Release pipeline / compliance requirement | §7 SBOM | Generate with `syft` / `cdxgen`, attach to release, sign |
| Enterprise procurement / EO 14028 | §8 SLSA levels | Add `slsa-github-generator`; target L2 via Sigstore attestations |
| "Verified" badge required, enterprise audit | §9 Signed commits | Set up `gitsign` (keyless) or GPG; enforce via branch protection |
| `uses: actions/checkout@v4` unpinned in CI | §10 Dependency pinning | Pin to full SHA + version comment; add Dependabot config |
| Solo maintainer, terse replies, long silences | §11 Bus factor / burnout | File clean repros + patches; don't bump; sponsor if possible |
| Your PR is 6+ months stale | §12 Graceful exits | Close with neutral summary; preserve branch; offer to reopen |
| Merging a multi-author PR | §13 Attribution | Add `Co-authored-by:` trailers; update AUTHORS / all-contributors |
| Design disagreement with maintainer | §14 Conflict resolution | Request second reviewer; escalate to governance; accept "no" |
| No CoC, hostile tone in issue history | §15 Hostile environments | Calibrate risk; pre-commit to a walk-away threshold |
| Need real-time help beyond GitHub issues | §16 Community channels | Check README for Discord/Zulip/Matrix/IRC/Discourse |
| Wondering whether to bump a stale PR | §17 Response-time expectations | Calibrate to project type (hobbyist weeks / corp days) |
| Maintainer obviously in different TZ | §18 Cross-TZ etiquette | Send one complete async message; no sync expectations |
| Writing/reviewing docs with old terminology | §19 Inclusive language | Prefer main/denylist/replica; run `alex`/`woke` |
| Want to add a translation | §20 Translating contribution | Use Crowdin/Weblate/Pontoon if set up; don't edit `.po` directly |
| Strong crypto / ML / dual-use code | §21 Export controls | Check repo's TSU notice; avoid military-specific enhancements |
| Forking and rebranding | §22 Trademark | Rename; don't use upstream logo; read TRADEMARK policy |
| Contributing externally while employed | §23 Employer IP assignment | Check PIIA clauses; get written permission if related |
| Log/screenshot in issue contains emails/tokens | §24 GDPR / PII redaction | Edit issue to redact; replace with `<redacted>` / RFC5737 IPs |
| Project done or superseded | §25 Archiving | Archive, don't delete; banner pointing to successor |
| Renaming repo or org | §26 Rename + redirects | GitHub handles 301s; still update CI, badges, package manifests |
| Contributing to multi-package repo | §27 Monorepo | Read `nx.json`/`turbo.json`; use `--filter`/`affected`; respect CODEOWNERS |
| Need to vendor upstream inline | §28 Subtree / submodule | Submodule for stable pin; subtree for self-contained; document choice |
| Typo on project's documentation website | §29 Docs-as-code | Find `docs/` or `-docs` repo; run local preview; label doc-only |
| PR touches performance-sensitive code path | §30 Benchmarks | Run bench before+after; report deltas; investigate CI perf CI regressions |
