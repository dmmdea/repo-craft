> **Consult this if:** any security-sensitive decision — setting repo security baseline, reviewing a dependency, evaluating a Claude skill / MCP server / plugin before install, handling a disclosed vulnerability, or planning post-quantum migration.
>
> **Cross-refs:** [03](./03-tooling.md) · [07#security-supply-chain](./07-adjacent.md#security-supply-chain) · [16](./16-security-sources.md)

## Table of Contents

- [Repo Security Baseline](#repo-security-baseline)
- [Supply Chain](#supply-chain)
- [AI-Era Threats](#ai-era-threats)
- [Post-Quantum](#post-quantum)
- [Cryptographic Hygiene](#cryptographic-hygiene)
- [Incident Response](#incident-response)
- [Contribution Security Checklist](#contribution-security-checklist)
- [Management Security Checklist](#management-security-checklist)
- [Security Trigger Map](#security-trigger-map)
- [Top 12 Security Priorities](#top-12-security-priorities)

---

# Repo Security + Cyber-Security Playbook

Security playbook tailored to contribution and repo-management decisions, with emphasis on the two acceleration fronts: **AI-era threats** and **post-quantum readiness**. Every non-obvious claim is cited to a primary source. Companion: `16-security-sources.md`. Cross-refs: `03-tooling.md` (candidate skills), `08-influence.md` (anti-patterns), `12-troubleshooting.md` (failure recovery).

Writing convention: links are inline so a triage decision can be made without leaving this file. Stability of a cited URL should be verified against `16-security-sources.md`.

---

## Repo Security Baseline

The minimum security configuration every repo should reach, in ROI-ordered priority. Treat these as gates: if any are missing, open a SECURITY hardening issue before accepting large contributions.

### 1.1 Secret scanning + push protection
The cheapest, highest-leverage control: block credentials *before* they enter history. GitHub's [Secret Scanning + Push Protection](https://docs.github.com/en/code-security/secret-scanning/introduction/about-secret-scanning) ships with partner patterns for 200+ providers and rejects pushes containing matched secrets at `git push` time. Even post-commit detection is expensive because revocation + rotation + history rewrite is a multi-hour chore. Supplement for non-GitHub providers with [trufflehog](https://github.com/trufflesecurity/trufflehog) (entropy + verification-based) and [gitleaks](https://github.com/gitleaks/gitleaks) (regex + entropy, pre-commit friendly). Run gitleaks in CI against the PR diff, not the full history, to keep runtime under 30 s.

### 1.2 Signed commits — Sigstore / gitsign preferred
Commit signing proves author identity and is the only defense against a compromised developer account producing backdated commits. Three options, in descending order of 2026-era suitability:
- **[gitsign](https://github.com/sigstore/gitsign)** (Sigstore) — keyless, OIDC-backed, short-lived certificates logged to the [Rekor](https://docs.sigstore.dev/logging/overview/) transparency log. No key to lose. Works with GitHub's [Sigstore verification](https://docs.github.com/en/authentication/managing-commit-signature-verification/about-commit-signature-verification).
- **SSH signing** — reuses the key you already use for auth; simpler than GPG but still private-key risk. [Git SSH signing docs](https://git-scm.com/docs/git-config#Documentation/git-config.txt-gpgssh).
- **GPG** — legacy; only justified if your project already has a web-of-trust in place or you need detached artifact signatures. [GPG commit signing](https://docs.github.com/en/authentication/managing-commit-signature-verification/signing-commits).

Enforce via [repository rulesets](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets) — "require signed commits" is a branch-ruleset toggle.

### 1.3 Branch protection + CODEOWNERS for security paths
Branch protection prevents direct pushes to default, force-pushes, and merges without required reviews ([docs](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches)). Pair with a [CODEOWNERS](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners) file that routes *security-sensitive paths* (`/.github/workflows/`, `SECURITY.md`, crypto modules, auth modules) to a security-specific reviewer team. Security paths should require **two** approvals and CODEOWNER approval — configured via rulesets, not the legacy "Protected branches" UI, because rulesets support layered org enforcement.

### 1.4 Dependency automation — Dependabot or Renovate
Automated dependency upgrades close the window between upstream disclosure and your downstream patch. [Dependabot](https://docs.github.com/en/code-security/dependabot/working-with-dependabot/dependabot-options-reference) is zero-config for GitHub; [Renovate](https://docs.renovatebot.com/) is more flexible (supports 90+ managers, group rules, auto-merge with status-check gates). Both should be tuned to: group non-breaking patches, require CI green before auto-merge, and **never** auto-merge major bumps or new transitive packages.

### 1.5 SAST — CodeQL plus one third-party
[CodeQL](https://codeql.github.com/) is free for public repos and integrates natively; it catches taint, injection, and insecure-API patterns across 10+ languages. Complement with one of:
- **[Semgrep](https://semgrep.dev/docs/)** — fast, rule-writable, community registry of 3000+ rules.
- **[Snyk Code](https://docs.snyk.io/scan-with-snyk/snyk-code)** — commercial, strong JavaScript/TypeScript coverage.
- **[SonarQube](https://www.sonarsource.com/products/sonarqube/)** — on-prem option with code-quality overlap.

CodeQL alone produces ~70 % of the value; adding a second tool catches category-miss gaps, especially configuration-level issues CodeQL doesn't model.

### 1.6 Pin GitHub Actions by SHA, scope permissions
Every `uses:` in a workflow must pin to a commit SHA, not a tag. Tags are mutable — a maintainer takeover or account compromise can silently redirect a `@v3` tag to malicious code, a class exemplified by the March 2025 [tj-actions/changed-files compromise](https://www.stepsecurity.io/blog/harden-runner-detection-tj-actions-changed-files-action-is-compromised). Use [StepSecurity's Harden-Runner](https://github.com/step-security/harden-runner) or [pinact](https://github.com/suzuki-shunsuke/pinact) to enforce. Scope `permissions:` at the job level — default token should be `read-all` with explicit `write` scopes only where needed, per [GitHub Actions security hardening guide](https://docs.github.com/en/actions/security-for-github-actions/security-guides/security-hardening-for-github-actions).

### 1.7 SLSA provenance + SBOM attachment
Provenance = cryptographic attestation of *how* an artifact was built. [SLSA](https://slsa.dev/spec/v1.0/) (Supply-chain Levels for Software Artifacts) defines four levels; L3 is achievable on GitHub with the [slsa-github-generator](https://github.com/slsa-framework/slsa-github-generator) reusable workflows. Attach an SBOM (CycloneDX or SPDX) to every release via [GitHub's dependency-graph SBOM export](https://docs.github.com/en/code-security/supply-chain-security/understanding-your-software-supply-chain/exporting-a-software-bill-of-materials-for-your-repository) or [syft](https://github.com/anchore/syft).

### 1.8 Private vulnerability reporting (GHSA) + SECURITY.md
Enable [private vulnerability reporting](https://docs.github.com/en/code-security/security-advisories/guidance-on-reporting-and-writing-information-about-vulnerabilities/privately-reporting-a-security-vulnerability) so researchers have a protected channel. Publish a [SECURITY.md](https://docs.github.com/en/code-security/getting-started/adding-a-security-policy-to-your-repository) with: supported versions, disclosure email, expected response time, PGP/age pubkey for encrypted reports, and whether CVE assignment is handled by GitHub (GHSA) or MITRE.

### 1.9 Secret rotation discipline
Never revoke without rotating *and* rotating doesn't mean generating a new secret with the same scope — audit whether the scope was ever justified. A rotation runbook should enumerate: credential inventory, blast-radius assumption, rotation order (dependencies last), verification step (service still green), post-mortem if external. The [OWASP Secrets Management Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Secrets_Management_Cheat_Sheet.html) covers lifecycle in depth.

A subtle trap: revoking a leaked token without rotation leaves any dependent automation broken, which triggers a frantic re-grant — often at broader scope than before. Sequence matters: mint new credential, deploy to consumers, verify green, then revoke the old. Treat revocation of a shared CI token as a change-management event, not a security-team reflex.

### 1.10 Runtime attestation + OIDC federation
Long-lived cloud credentials in `GITHUB_SECRETS` are a footgun — one workflow-injection and the entire cloud account is at risk. OIDC federation ([AWS guide](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_create_for-idp_oidc.html), [GCP guide](https://cloud.google.com/iam/docs/workload-identity-federation), [Azure guide](https://learn.microsoft.com/en-us/entra/workload-id/workload-identity-federation)) replaces stored secrets with short-lived tokens minted per-run by GitHub's IdP, with trust policies pinned to specific repo + branch + workflow. Required `permissions:` scope: `id-token: write`. This single change eliminates the most-exploited class of CI leaks.

---

## Supply Chain

Concrete attack classes that have landed in the wild, with the mitigation that *would have* blocked them. Cross-reference `08-influence.md` for the social-engineering half of most of these — the xz-utils case is the canonical example of a multi-year trust-building op.

### 2.1 Typosquatting
Malicious packages published under names that collide visually/typo-adjacently with real packages. [ReversingLabs 2024](https://www.reversinglabs.com/blog/rl-releases-software-supply-chain-security-report-2024) documented 32 % year-over-year growth in typosquatting on npm + PyPI. Mitigate with: [Socket.dev](https://socket.dev/) or [Snyk Advisor](https://snyk.io/advisor/) for automated name-similarity + maintainer-reputation checks; pin exact versions + hashes (`package-lock.json`, `uv.lock`, `poetry.lock`); audit new transitive deps explicitly.

### 2.2 Dependency confusion
Attacker publishes a public package matching the name of your *internal* private package; the default resolver fetches the public one because it has a higher version. Coined by Alex Birsan in 2021 ([write-up](https://medium.com/@alex.birsan/dependency-confusion-4a5d60fec610)), still live. Mitigate: scoped packages with verified publisher, registry scope routing (npm `.npmrc` + PyPI `--index-url`), and Artifactory/Nexus virtual repos that reject public names matching internal prefixes.

### 2.3 Maintainer takeover
Single-maintainer package is transferred or credentials compromised. Canonical: **event-stream (2018)** — maintainer handed off to an attacker who injected a Bitcoin-wallet-stealing payload targeting Copay ([postmortem](https://blog.npmjs.org/post/180565383195/details-about-the-event-stream-incident)). Mitigate: require 2FA on package publishing ([npm enforces this](https://docs.npmjs.com/configuring-two-factor-authentication) for high-reach packages), prefer packages with ≥3 active maintainers, watch `npm diff` / `pnpm why` on upgrades.

### 2.4 Protestware / sabotage
Maintainer themselves ships malicious behavior for ideological reasons. Canonical: **colors.js / faker.js (January 2022)** — maintainer pushed infinite-loop + zalgo output ([coverage](https://snyk.io/blog/open-source-npm-packages-colors-faker/)); **node-ipc (March 2022)** — `peacenotwar` overwrote files on systems with Russia/Belarus IPs ([write-up](https://snyk.io/blog/peacenotwar-malicious-npm-node-ipc-package/)). Mitigate: pin versions, read changelogs before upgrading low-churn dependencies, prefer packages without political risk in their maintainer base (hard to predict).

### 2.5 Compromised CI secrets
CI tokens exfiltrated via a malicious step become registry-publish credentials. The **SolarWinds / SUNBURST (December 2020)** pattern — though not GitHub-specific — shows the attack: compromise the build pipeline, inject backdoor into the artifact ([CISA advisory](https://www.cisa.gov/news-events/cybersecurity-advisories/aa20-352a)). On GitHub: the [tj-actions/changed-files](https://www.stepsecurity.io/blog/harden-runner-detection-tj-actions-changed-files-action-is-compromised) March 2025 compromise dumped CI secrets from 23,000+ repos. Mitigate: pin Actions by SHA (§1.6), use OIDC federation ([GitHub OIDC docs](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect)) instead of long-lived cloud creds, use `harden-runner` audit mode to detect anomalous outbound.

### 2.6 Malicious PR with obfuscated intent
The **xz-utils backdoor (CVE-2024-3094)** — Jia Tan (a persona operated for 2+ years) gained co-maintainer status, then landed a backdoor hidden in test-fixture binary blobs + build-system macros that injected into `sshd` via `liblzma`. Discovered by Andres Freund on 2024-03-29 via a 500 ms ssh latency regression ([original disclosure](https://www.openwall.com/lists/oss-security/2024/03/29/4)). Mitigate: hostile social engineering defense — skeptical review of "new maintainer" onboarding, reject binary test fixtures without provenance, require reproducible builds for anything installed at package-install time.

---

## AI-Era Threats

Attack surface that did not exist in 2022 and is now top-priority. Critical principle: **any LLM with filesystem or network tools is a confused-deputy attack surface**.

### 3.1 Prompt injection on CI/CD
AI code-review bots (Claude Code Action, Copilot Autofix, CodeRabbit) read PR diffs + issue bodies + comment threads as context. Attacker-controlled content in that context can hijack the agent. Concrete examples:
- **GitHub's MCP injection (May 2025)** — Invariant Labs showed a malicious issue could exfiltrate private repo data via an AI agent using the GitHub MCP server ([write-up](https://invariantlabs.ai/blog/mcp-github-vulnerability)).
- **Supabase Cursor incident (July 2025)** — prompt-injected database content caused an AI assistant to leak other tenants' data ([analysis](https://www.generalanalysis.com/blog/supabase-mcp-blog)).
- **Perplexity Comet (August 2025)** — Brave demonstrated hijacking the agent via instructions embedded in page content ([disclosure](https://brave.com/blog/comet-prompt-injection/)).

Mitigations:
- Run AI reviewers with `read-only` GITHUB_TOKEN scope; no `write`, no `packages:write`, no `id-token:write`.
- Scope the context the model sees — do not concatenate untrusted issue bodies into system prompts.
- Use [Anthropic's prompt-injection mitigation guidance](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/mitigate-jailbreaks-and-prompt-injections) as the baseline pattern (clear role boundaries, untrusted-content fencing, pre-flight classifier).
- Review AI-generated diffs with a *human* before any `write` action merges.

### 3.2 Slopsquatting — AI-generated malicious dependencies
LLMs hallucinate package names that don't exist; attackers register those names with malicious payloads. [Lanyado et al. 2024](https://arxiv.org/abs/2406.10279) ("We Have a Package for You!") demonstrated reproducible hallucinations at ~20 % rate on Python, ~5 % on JS, and showed attackers could pre-register hallucinated names. Also covered by [Socket](https://socket.dev/blog/slopsquatting-how-ai-hallucinations-are-fueling-a-new-class-of-supply-chain-attacks). Mitigate: **never** let `pip install $(llm_output)` run without a resolve-check step; reject install of any package with no existing install history; constrain LLM tool-calling to a vetted package list when possible.

### 3.3 Model / weights supply chain
ML models are code — specifically, [pickle](https://docs.python.org/3/library/pickle.html) (and similar) deserialization formats that execute arbitrary Python on load. [JFrog's 2024 report](https://jfrog.com/blog/data-scientists-targeted-by-malicious-hugging-face-ml-models-with-silent-backdoor/) identified 100+ malicious Hugging Face models with silent RCE payloads. [ReversingLabs 2024](https://www.reversinglabs.com/blog/hugging-face-malicious-ml-models) found similar. Mitigate:
- Prefer [safetensors](https://github.com/huggingface/safetensors) format over `.pt` / `.bin` / `.pkl`.
- Use [picklescan](https://github.com/mmaitre314/picklescan) or [modelscan](https://github.com/protectai/modelscan) to pre-flight any pickle.
- Pin model revisions by SHA; never use `main`-branch model references in production.
- Treat `trust_remote_code=True` in `transformers` as equivalent to `curl | sh`.

### 3.4 Agentic-tool abuse
MCP servers, Claude Code skills, plugins — all execute with the user's privileges. The **OpenClaw incident** (documented in the Zora project README) involved 800+ malicious skills being submitted to a public registry, attempting to exfiltrate credentials and poison memory. Patterns to audit before installing any skill/plugin/MCP server:
- What filesystem paths does it read?
- What processes does it spawn (`bash`, `node`, network clients)?
- Does it phone home on load or first-use?
- Is it signed / does the author have provenance?
- What's the update model — does it auto-pull, and from where?

Applies the same standard as `03-tooling.md` candidate-skill evaluation. See [Anthropic's MCP security guidance](https://modelcontextprotocol.io/docs/concepts/architecture#security) and [Simon Willison's MCP + prompt-injection analysis](https://simonwillison.net/2025/Apr/9/mcp-prompt-injection/).

### 3.5 Skills/plugins as a threat surface
Skill installation equals code execution at the permissions of the host runtime. Before accepting any skill into a repo's `.claude/` or `~/.claude/skills/`:
1. Diff against a known-good copy if one exists.
2. Grep the skill for process-spawn primitives (`exec`, `spawn`, `subprocess`, `os.system`) and outbound network calls.
3. Check the origin commit's signature + the author's maintainer history.
4. Run it first in a sandboxed user (e.g., a disposable WSL distro) with no access to credentials.
5. Review any hook registrations — hooks fire *before* user confirmation and are the highest-privilege surface.

### 3.6 Training-data poisoning
Code you publish may be scraped into future training corpora; adversarial contributors can submit PRs designed to teach models bad patterns (insecure-by-default idioms, backdoored example code). Discussed in [Carlini et al. 2023 "Poisoning Web-Scale Training Datasets"](https://arxiv.org/abs/2302.10149). Low priority for most repos; relevant for highly-starred reference repos whose patterns propagate. Mitigate by code review discipline and rejecting PRs that introduce patterns contrary to project conventions even when "functionally correct."

### 3.7 Output-integrity attacks on AI reviewers
Adversarial code designed to make AI reviewers approve it — e.g., comments styled as approval signals, whitespace steganography in diffs, unicode homoglyphs (Trojan Source: [Boucher & Anderson 2021](https://trojansource.codes/)). [Schuster et al. 2024](https://arxiv.org/abs/2401.15268) showed adversarial prompts in PR bodies bypass LLM code review. Mitigate: AI review is a *signal*, never the sole approver; require at least one human CODEOWNER review; enable Unicode normalization / bidi detection checks ([GitHub auto-flags bidi characters](https://github.blog/2021-10-31-git-2-34-released/) in diffs).

---

## Post-Quantum

As of 2026 NIST has finalized the first-wave PQC standards. "Harvest now, decrypt later" (HNDL) is the operative threat model: adversaries capture long-lived ciphertexts and signatures today, intending to break them with future quantum computers.

### 4.1 NIST PQC standards (finalized August 2024)
- **[FIPS 203 — ML-KEM](https://csrc.nist.gov/pubs/fips/203/final)** (Module-Lattice-Based Key-Encapsulation Mechanism, formerly CRYSTALS-Kyber). Key exchange / key establishment.
- **[FIPS 204 — ML-DSA](https://csrc.nist.gov/pubs/fips/204/final)** (Module-Lattice-Based Digital Signature Algorithm, formerly CRYSTALS-Dilithium). Primary PQC signing.
- **[FIPS 205 — SLH-DSA](https://csrc.nist.gov/pubs/fips/205/final)** (Stateless Hash-Based Digital Signature Algorithm, formerly SPHINCS+). Conservative hash-based backup signing (larger signatures, assumption-minimal).
- **FN-DSA** (FIPS 206, formerly Falcon) — draft pending; lattice-based signing with smaller signatures than ML-DSA but harder to implement safely.

### 4.2 Hybrid signing posture
The consensus transition path is *hybrid*: classical + PQC in parallel, verifier accepts either/both. Status today:
- **TLS 1.3**: [X25519MLKEM768](https://datatracker.ietf.org/doc/draft-kwiatkowski-tls-ecdhe-mlkem/) hybrid key exchange is shipping in Chrome and Cloudflare ([deployment data](https://blog.cloudflare.com/pq-2024/)).
- **SSH**: OpenSSH 9.9+ defaults to [mlkem768x25519-sha256](https://www.openssh.com/txt/release-9.9) hybrid for key exchange.
- **Sigstore / GPG / code-signing**: still classical (Ed25519 / ECDSA / RSA). ML-DSA integration is actively discussed; no production hybrid-signing for commits or releases today.
- **X.509 certificates**: IETF drafting hybrid schemes; no deployed PKI roots with PQC signatures as of 2026.

### 4.3 HNDL implications for long-lived signed releases
If your project ships signed artifacts with ≥5-year verification horizons (LTS releases, firmware, archival software):
- Long-term confidentiality (anything encrypted with classical KEX today) is already at HNDL risk.
- Long-term signature validity is at risk once a CRQC (cryptographically relevant quantum computer) exists — most estimates place this 2030–2040; [NSA CNSA 2.0 timeline](https://www.nsa.gov/Press-Room/Press-Releases-Statements/Press-Release-View/Article/3148990/) requires PQC for national security systems by 2035.
- Plan for signature re-attestation: archive raw artifacts + be ready to re-sign with PQC when tooling lands.

### 4.4 Crypto-agility patterns in repo security
Hard-coded algorithm choices are the bug to fix now:
- Pin algorithms in config, not code — `sig_algorithm: ed25519` in a YAML, not `Ed25519.sign(...)` in source.
- Abstract verification behind an interface that supports multiple algorithms simultaneously.
- Record algorithm in the signed artifact metadata (JWS `alg` header, Sigstore bundle `mediaType`).
- Support multi-signature artifacts (detached `.sig` + `.pqsig` both accepted).

Reference: [IETF PQUIP (Post-Quantum Use In Protocols)](https://datatracker.ietf.org/wg/pquip/about/) working group.

### 4.5 What maintainers should do in 2026 (vs research-only)
**Do now:**
- Upgrade to OpenSSH 9.9+ for hybrid KEX.
- Enable PQ-capable TLS at your git host / release CDN (Cloudflare, Fastly already support).
- Inventory your cryptographic primitives — every hash, KDF, signature verifier — in a `CRYPTO.md`.
- Prefer SHA-256/SHA-3 over SHA-1 everywhere (SHA-1 broken for collisions since [SHAttered 2017](https://shattered.io/)).
- Use Sigstore (gitsign) for commits — when Sigstore adopts ML-DSA you inherit the upgrade.

**Don't yet (research, not production):**
- ML-DSA commit signing (no widely-deployed verifier).
- SLH-DSA for high-frequency signing (signature size prohibitive: ~8–50 KB).
- Custom hybrid schemes — use IETF-standardized combinations only.

Guidance: [NSA CNSA 2.0](https://media.defense.gov/2022/Sep/07/2003071836/-1/-1/0/CSA_CNSA_2.0_ALGORITHMS_.PDF), [CISA PQC roadmap](https://www.cisa.gov/quantum).

---

## Cryptographic Hygiene

When encrypted content needs to live in the repo itself.

- **`.gitattributes` + [git-crypt](https://github.com/AGWA/git-crypt)** — transparent per-file encryption keyed to GPG or symmetric key. Good for: a small number of config files in a trusted-maintainer repo. Bad for: large teams (key distribution is manual), binary diffs (encrypted blobs are opaque in PRs).
- **[git-secret](https://git-secret.io/)** — similar but file-granular, GPG-based. Largely superseded by SOPS.
- **[SOPS](https://github.com/getsops/sops)** + KMS / age / PGP — Mozilla's format: JSON/YAML structured files where *values* are encrypted but *keys* stay readable, so diffs remain reviewable. Integrates with AWS KMS, GCP KMS, Azure Key Vault, HashiCorp Vault, age. Current 2026 best practice for secret-tracking.
- **[age](https://age-encryption.org/) / [rage](https://github.com/str4d/rage)** — modern GPG replacement. Small keys, no web-of-trust, no cipher negotiation. Use for: backup encryption, file-at-rest secrets, SOPS recipient keys. `age` is the C reference; `rage` is the Rust port with identical format.
- **When each:** SOPS for structured config secrets, age for opaque files, git-crypt only if SOPS is overkill for a solo project. Never commit raw secrets "encrypted" with symmetric passwords typed by a human — that's `.env.example` with a false sense of safety.

---

## Incident Response

When something has gone wrong. Link to `12-troubleshooting.md` for Git-mechanics failure recovery; this section is specifically for *security* incidents.

### 6.1 Detected compromise — history rewrite vs disclosure
If a backdoor is found in existing merged code:
- **Force-push rewriting history** is appealing but *breaks every contributor's checkout*, causes hash changes that invalidate signed tags, and signals weakness to attackers watching. Reserve for pre-release internal branches only.
- **Disclosure + revert + rotate** is the norm: publish a GHSA advisory, revert the malicious commit in a new commit, rotate any secrets that may have been exposed, assign a CVE via GHSA or MITRE. See [coordinated disclosure playbook](https://github.com/nuhmanpk/awesome-security-response).

### 6.2 Credential leak in history
- Rotate *first*, rewrite *after* — a leaked credential stays compromised forever regardless of git history changes (it's on attacker's caches, clones, GitHub's fork network).
- [git filter-repo](https://github.com/newren/git-filter-repo) is the 2026 tool (replaces the deprecated `filter-branch`). Example: `git filter-repo --replace-text passwords.txt`.
- After rewrite, force secret-scanning rescan via GitHub's UI — dashboard will re-evaluate against new history.
- Notify forks and downstream consumers; a fork retains the leaked blob unless the fork relationship is severed.

### 6.3 Malicious merge — revert strategy
- `git revert -m 1 <merge-sha>` reverses a merge commit. The *revert* becomes the record; the malicious code stays in history (by design — rewriting is worse, see §6.1).
- Post-mortem template: timeline, detection mechanism, blast radius, credentials/data exposed, remediation steps, preventive controls added. Publish publicly when possible; [GitHub's own incident postmortems](https://github.com/github/archive-program) are one exemplar.

### 6.4 Communication during an incident
Assume email is compromised if the attacker had repo write access — attackers often pivot into maintainer inboxes to monitor the response. Use an out-of-band channel (Signal group, Matrix room, phone) for initial coordination. [Signal](https://signal.org/docs/) and [Matrix](https://spec.matrix.org/) are both credible choices; Matrix self-hosted via [Element](https://element.io/) is preferred if you need auditable logs. The `SECURITY.md` emergency contacts should list the *out-of-band* channel, not just email.

### 6.5 Forensics before rotation
When time permits (minutes, not hours), capture evidence before rotating: clone the repo at the compromised commit, export CI run logs via `gh run view --log`, snapshot any Actions artifacts, pull the audit log via [GitHub's audit log API](https://docs.github.com/en/enterprise-cloud@latest/admin/monitoring-activity-in-your-enterprise/reviewing-audit-logs-for-your-enterprise/about-the-audit-log-for-your-enterprise). Rotation destroys token-bound context (which repos did the token access during what window); evidence collection takes <10 minutes and enables a real post-mortem.

---

## Contribution Security Checklist

Before contributing to someone else's repo:

1. **License compatibility** — does your patch import code or patterns from incompatibly-licensed work? Check the project's license against your employer's OSS policy. See [SPDX identifiers](https://spdx.org/licenses/).
2. **CLA / DCO** — does the project require a CLA (e.g., Apache CLA, Google CLA) or DCO sign-off (`git commit -s`)? Check `CONTRIBUTING.md`.
3. **Export-control check** — cryptography and some ML contributions are covered by [BIS EAR 742.15](https://www.bis.doc.gov/index.php/documents/regulations-docs/federal-register-notices/federal-register-2020/2637-86-fr-54757/file) (US) and similar in other jurisdictions. If contributing to a crypto library from an OFAC-restricted location, the PR itself can be a violation.
4. **PII scrub** — logs, backtraces, usernames, email addresses, customer IDs, internal hostnames, IP addresses, JWTs. Re-read every line of every log output before pasting into an issue body.
5. **Sign commits** — appropriate to the project (gitsign, GPG, SSH, DCO). Unsigned commits on security-sensitive repos may be rejected by rulesets.
6. **No internal paths** — `/home/yourname/...`, `C:\Users\corp-name\...`, internal URLs in diffs or comments leak corporate org structure and sometimes actual credentials.
7. **Check secret scanner before push** — `gitleaks detect --staged` as a pre-push hook.
8. **Small, focused PRs** — security reviewers reject unreadable 4000-line PRs; if you have a large patch, split it.

---

## Management Security Checklist

If you own a repo:

1. **[Private vulnerability reporting](https://docs.github.com/en/code-security/security-advisories/guidance-on-reporting-and-writing-information-about-vulnerabilities/privately-reporting-a-security-vulnerability) enabled** and someone monitors the inbox with ≤72 h SLA.
2. **Secrets rotation runbook** — documented, dry-runnable, tested at least annually. Each credential has a named owner.
3. **Emergency contact list in SECURITY.md** — at least two humans reachable by email + one alternative channel (Signal, Matrix). Assume email will be down during an incident.
4. **Backup + DR posture** — mirror to at least one second git host (Codeberg, GitLab) or S3/B2 snapshot. The bus-factor is a security concern: if your one maintainer disappears, is the project recoverable without you? See [Software Heritage](https://www.softwareheritage.org/) for archival.
5. **Code-signing key ceremony for releases** — documented key-generation, storage (HSM or YubiKey), rotation schedule, compromise response. If your project ships binaries, assume your signing key is a state-level target.
6. **Supply-chain attestation in CI** — SLSA L3 via `slsa-github-generator`, SBOM on every release, provenance URL in release notes.
7. **Regular dependency audit** — quarterly review of transitive dependencies with [OSV-Scanner](https://github.com/google/osv-scanner) or [Trivy](https://trivy.dev/), not just Dependabot alerts.
8. **OpenSSF Scorecard** — run [scorecard](https://github.com/ossf/scorecard) and publish the badge; aim for 7+/10.
9. **OpenSSF Best Practices Badge** — apply for the [badge](https://www.bestpractices.dev/) at least at Passing level; the checklist alone is worth the exercise.

---

## Security Trigger Map

| Signal observed | Security topic | Quick action |
|---|---|---|
| Leaked API key in a pushed commit | §1.1 secret scanning, §6.2 credential leak | Rotate secret first; then `git filter-repo` + GHSA if external impact |
| PR from a brand-new contributor touches `/.github/workflows/` | §1.3 CODEOWNERS, §2.6 xz-pattern | Require security-team review; pin any new Actions by SHA |
| Dependabot flags a transitive dependency CVE | §1.4, §2 supply-chain | Check OSV.dev + KEV; if exploited, prioritize patch or pin-and-deploy |
| AI code-review bot approves a PR with no human review | §3.1 prompt injection, §3.7 AI-integrity | Require human CODEOWNER approval; never merge AI-only-approved changes |
| User asks to install a new Claude Code skill / MCP server | §3.4, §3.5 agentic-tool abuse | Audit skill against §3.5 checklist; sandbox first |
| Contributor submits binary test-fixture with no provenance | §2.6 xz-utils pattern | Reject or require reproduction recipe + upstream source |
| `npm install` of a package nobody has heard of recommended by an LLM | §3.2 slopsquatting | Check npm stats (downloads, age, maintainers); reject if <90 days old, no history |
| Release candidate is about to be signed | §1.7 SLSA, §4 PQC | Generate provenance; plan PQC upgrade path for long-term artifacts |
| SSH key ≥3 years old in use | §1.2, §4.2 hybrid signing | Rotate to Ed25519; enable OpenSSH 9.9+ hybrid KEX |
| A GitHub Action uses a mutable tag (`@v3`) | §1.6 Action pinning | Replace with SHA; enable pinact pre-commit |
| Hugging Face model loaded with `trust_remote_code=True` | §3.3 pickle RCE | Replace with safetensors + pinned revision; modelscan pre-flight |
| New contributor requests maintainer / commit access | §2.6 maintainer-takeover | Staged trust: commit bit only, no release-sign access for ≥6 months |
| SECURITY.md missing on a repo being adopted | §1.8 | Draft minimal version before first external PR |
| PR body contains what looks like a prompt (`You are a...`) | §3.1, §3.7 prompt injection | Treat as hostile; scrub before passing to any AI reviewer |
| Release uses RSA-2048 or SHA-1 anywhere in the pipeline | §4.5 crypto hygiene | Upgrade: Ed25519 for signing, SHA-256 for hashing |
| Contributor's commits are unsigned on a repo requiring signing | §1.2 | Point to gitsign setup docs; do not waive the requirement |
| CI secrets present in `env:` at workflow level | §2.5 CI compromise | Scope to job level; prefer OIDC federation |
| `pickle.load` on any file in a PR | §3.3 deserialization | Reject or require safetensors/JSON migration |
| Two-factor not enforced on org | §2.3 maintainer takeover | Enable org-wide 2FA requirement in GitHub settings |

---

## Top 12 Security Priorities

1. Enable GitHub Secret Scanning + Push Protection on every repo.
2. Require signed commits (prefer gitsign / Sigstore, fall back to SSH signing).
3. Configure branch protection + CODEOWNERS for `/.github/workflows/`, `SECURITY.md`, and any crypto/auth modules.
4. Pin every GitHub Action by commit SHA; scope `GITHUB_TOKEN` permissions per job.
5. Turn on Dependabot/Renovate with auto-merge gated on CI green + no major bumps.
6. Run CodeQL plus one third-party SAST (Semgrep or Snyk) on every PR.
7. Publish SECURITY.md + enable Private Vulnerability Reporting; monitor the inbox with a named owner.
8. Enforce 2FA across the org; require it for all maintainers with publish rights.
9. Treat AI code reviewers as signals, never sole approvers; require human CODEOWNER review.
10. Audit every new Claude Code skill / MCP server / plugin against the §3.5 checklist *before* installation.
11. Generate SLSA provenance and SBOMs on every release; attach to the GitHub Release.
12. Inventory cryptographic primitives; upgrade to OpenSSH 9.9+ hybrid KEX; plan PQC transition for long-lived signed artifacts.
