> **Consult this if:** citing security guidance, verifying CVE/advisory details, or researching PQC/SLSA/SBOM standards.
>
> **Cross-refs:** [04](./04-sources.md) (general sources) · [15](./15-security.md)

## Table of Contents

- [Core Standards](#core-standards)
- [Vulnerability Databases](#vulnerability-databases)
- [Supply-Chain Security](#supply-chain-security)
- [Threat Reports](#threat-reports)
- [Cryptographic Standards](#cryptographic-standards)
- [AI-Security Sources](#ai-security-sources)
- [Post-Quantum](#post-quantum)
- [Repo-Specific](#repo-specific)
- [Awesome Lists](#awesome-lists)

---

# Security Skill — External Source Map

Canonical external references for the repo-craft skill's **security** slice. Parallel to `04-sources.md` but security-focused. Consult this map when hardening a repo, responding to an incident, or evaluating an AI/supply-chain risk.

**Column order:** Title | URL | What it is | Consult when | Stability

Stability legend:
- **STABLE** — versioned spec / finalized standard, rarely changes
- **LIVE** — continuously-updated docs, advisory feeds, or product pages
- **DEPRECATED** — superseded but still encountered in the wild

---

## Core Standards

| Title | URL | What it is | Consult when | Stability |
|---|---|---|---|---|
| NIST Cybersecurity Framework 2.0 | https://www.nist.gov/cyberframework | Top-level policy framework (Govern/Identify/Protect/Detect/Respond/Recover) with mappings to controls. | IF justifying a security program structure or mapping a repo's controls to exec-level framework. | STABLE |
| NIST SP 800-218 — SSDF | https://csrc.nist.gov/pubs/sp/800/218/final | Secure Software Development Framework — practices for producing secure software. | IF the project falls under US federal consumption (M-22-18) or needs an SSDF-aligned attestation. | STABLE |
| NIST SP 800-207 — Zero Trust Architecture | https://csrc.nist.gov/pubs/sp/800/207/final | Foundational ZTA definitions used by EO 14028 + CISA ZTMM. | IF designing auth/access boundaries for multi-tenant OSS infra. | STABLE |
| Executive Order 14028 | https://www.whitehouse.gov/briefing-room/presidential-actions/2021/05/12/executive-order-on-improving-the-nations-cybersecurity/ | 2021 US EO mandating SBOM, SSDF, ZTA for federal software supply chains. | IF justifying supply-chain controls for a project consumed by US federal customers. | STABLE |
| OMB M-22-18 | https://www.whitehouse.gov/wp-content/uploads/2022/09/M-22-18.pdf | US OMB memo requiring SSDF attestation from federal-used software producers. | IF writing a self-attestation or SBOM deliverable for a federal consumer. | STABLE |
| CISA Secure by Design | https://www.cisa.gov/securebydesign | Principles + pledges for building security into products by default. | IF setting product-security posture for a library that many downstream apps import. | LIVE |
| CISA KEV Catalog | https://www.cisa.gov/known-exploited-vulnerabilities-catalog | Actively-exploited CVEs with patch deadlines. | IF a Dependabot alert references a CVE — check KEV to triage urgency. | LIVE |
| CISA Zero Trust Maturity Model 2.0 | https://www.cisa.gov/zero-trust-maturity-model | CISA's reference model across identity, device, network, application, data pillars. | IF planning a maturity roadmap for repo-infra access control. | LIVE |
| ENISA Threat Landscape | https://www.enisa.europa.eu/topics/cyber-threats/threats-and-trends | Annual EU threat report including supply-chain + AI threats. | IF cross-checking US-sourced threat data with EU perspective. | LIVE |

## Vulnerability Databases

| Title | URL | What it is | Consult when | Stability |
|---|---|---|---|---|
| NVD (National Vulnerability Database) | https://nvd.nist.gov/ | US-government CVE database with CVSS scores, CPE mappings. | IF looking up a specific CVE's CVSS/impact or CPE match. | LIVE |
| CVE.org (MITRE) | https://www.cve.org/ | Authoritative CVE record source (MITRE as root CNA). | IF filing a new CVE, or fetching the canonical record before NVD enrichment. | LIVE |
| OSV.dev | https://osv.dev/ | Google-maintained open-source vuln DB; per-ecosystem, machine-readable. | IF scanning dependencies programmatically or cross-checking npm/PyPI/Go vulns. | LIVE |
| GitHub Advisory Database | https://github.com/advisories | GitHub-curated advisories feeding Dependabot; includes GHSA-only (not in CVE). | IF a Dependabot alert needs triage, or you need GHSA detail GitHub hasn't syndicated to NVD. | LIVE |
| MITRE CWE | https://cwe.mitre.org/ | Weakness taxonomy (e.g., CWE-79 XSS, CWE-798 hardcoded cred). | IF classifying a defect for an advisory or a SAST rule. | STABLE |
| SANS/CWE Top 25 | https://www.sans.org/top25-software-errors/ | Annual ranking of most dangerous CWEs. | IF prioritizing rule coverage in SAST/code review checklists. | LIVE |
| OWASP Top 10 | https://owasp.org/www-project-top-ten/ | Top web-app risk categories, updated every few years. | IF building a threat model for a web service; a baseline for secure-review checklists. | STABLE |
| OWASP ASVS | https://owasp.org/www-project-application-security-verification-standard/ | Verifiable security controls for apps; levels 1-3. | IF writing detailed security acceptance criteria for a web app. | STABLE |
| OWASP SAMM | https://owaspsamm.org/ | Software Assurance Maturity Model for SDLC. | IF assessing a team's overall secure-dev maturity. | STABLE |
| VulnCheck KEV | https://vulncheck.com/kev | Expanded exploit intelligence beyond CISA KEV. | IF CISA KEV is too narrow; VulnCheck adds earlier + broader signals. | LIVE |
| ExploitDB | https://www.exploit-db.com/ | Archive of public exploit code. | IF assessing whether a CVE has weaponized PoC in the wild. | LIVE |

## Supply-Chain Security

| Title | URL | What it is | Consult when | Stability |
|---|---|---|---|---|
| SLSA Framework | https://slsa.dev/spec/v1.0/ | Supply-chain Levels for Software Artifacts — four levels of provenance + integrity. | IF adding build-provenance attestation or picking a SLSA target level. | STABLE |
| slsa-github-generator | https://github.com/slsa-framework/slsa-github-generator | Reusable GitHub workflows for SLSA L3 provenance. | IF adding SLSA-compliant releases on GitHub Actions. | LIVE |
| OpenSSF | https://openssf.org/ | Linux Foundation umbrella for OSS security (Scorecard, Alpha-Omega, Sigstore). | IF evaluating overall OSS security initiatives or funding sources. | LIVE |
| OpenSSF Scorecard | https://github.com/ossf/scorecard | Automated repo-security scoring across 18 checks. | IF benchmarking a repo's security posture or adding a Scorecard badge. | LIVE |
| OpenSSF Best Practices Badge | https://www.bestpractices.dev/ | Criteria-based badge (Passing/Silver/Gold) for OSS security hygiene. | IF a project wants a visible, audited security-posture signal. | LIVE |
| OpenSSF Alpha-Omega | https://openssf.org/community/alpha-omega/ | Funded program improving security of the most-depended-on OSS. | IF a critical dep needs security resources; Alpha-Omega is a referral path. | LIVE |
| Sigstore | https://www.sigstore.dev/ | Keyless signing for software (cosign, gitsign, Rekor, Fulcio). | IF adopting keyless commit or artifact signing. | LIVE |
| cosign | https://docs.sigstore.dev/signing/quickstart/ | Sigstore CLI for signing/verifying containers + artifacts. | IF signing release artifacts (tar/zip/containers). | LIVE |
| gitsign | https://github.com/sigstore/gitsign | Sigstore for git commit signing with OIDC. | IF replacing GPG with keyless commit signing. | LIVE |
| Rekor transparency log | https://docs.sigstore.dev/logging/overview/ | Append-only signature transparency log. | IF verifying signatures were recorded at a point in time; evidence preservation. | LIVE |
| Fulcio CA | https://docs.sigstore.dev/certificate_authority/overview/ | Sigstore's short-lived cert authority tied to OIDC identities. | IF evaluating trust model of keyless signing. | LIVE |
| in-toto | https://in-toto.io/ | Supply-chain attestation framework used by SLSA. | IF building custom attestation (e.g., for ML pipelines). | STABLE |
| OSV-Scanner | https://github.com/google/osv-scanner | Google CLI scanning deps against OSV.dev. | IF running local/CI dep-vuln scans. | LIVE |
| Trivy | https://trivy.dev/ | Aquasec's all-in-one scanner (deps, containers, IaC, secrets). | IF scanning containers or IaC in addition to deps. | LIVE |
| Syft | https://github.com/anchore/syft | SBOM generator (CycloneDX + SPDX) from images/dirs. | IF generating SBOMs for releases. | LIVE |
| Grype | https://github.com/anchore/grype | Vuln scanner that consumes Syft SBOMs. | IF running SBOM-driven vuln scans. | LIVE |
| Dependency-Track | https://dependencytrack.org/ | OWASP SBOM-centric vuln management platform. | IF managing SBOMs across many projects centrally. | LIVE |
| Socket.dev | https://socket.dev/ | Supply-chain analysis (typosquatting, suspicious behaviors) for npm/PyPI/etc. | IF evaluating a new package pre-install for risk signals. | LIVE |
| Snyk Advisor | https://snyk.io/advisor/ | Package health + security scoring. | IF picking between similar packages. | LIVE |
| Sonatype OSSIndex | https://ossindex.sonatype.org/ | Free vuln API for deps. | IF you need a free programmatic vuln feed beyond OSV. | LIVE |
| StepSecurity Harden-Runner | https://github.com/step-security/harden-runner | Anomaly-detection agent for GitHub Actions runners. | IF securing Actions runners; detects egress + tampering. | LIVE |
| pinact | https://github.com/suzuki-shunsuke/pinact | Tool to pin GitHub Actions by SHA. | IF enforcing SHA pinning across workflows. | LIVE |
| Reproducible Builds | https://reproducible-builds.org/ | Project documenting bit-for-bit reproducible builds. | IF a release must be verifiable by independent rebuild. | STABLE |

## Threat Reports

| Title | URL | What it is | Consult when | Stability |
|---|---|---|---|---|
| ReversingLabs 2024 Supply Chain Report | https://www.reversinglabs.com/blog/rl-releases-software-supply-chain-security-report-2024 | Annual threat trends across npm, PyPI, Maven. | IF quoting supply-chain trend data to justify controls. | LIVE |
| JFrog Malicious HuggingFace Models | https://jfrog.com/blog/data-scientists-targeted-by-malicious-hugging-face-ml-models-with-silent-backdoor/ | 2024 analysis of 100+ backdoored Hugging Face models. | IF justifying safetensors/modelscan adoption. | LIVE |
| Socket Threat Research | https://socket.dev/blog | Ongoing npm/PyPI malicious-package disclosures. | IF investigating a specific malicious package report. | LIVE |
| Snyk Security Research | https://snyk.io/blog/category/security/ | Vuln + supply-chain research blog. | IF cross-referencing a CVE or supply-chain case. | LIVE |
| Sonatype State of the Software Supply Chain | https://www.sonatype.com/state-of-the-software-supply-chain/introduction | Annual report with supply-chain attack counts. | IF needing trend-line stats for business cases. | LIVE |
| GitHub Security Lab | https://securitylab.github.com/ | GitHub's offensive-security research + CodeQL advisories. | IF researching a CodeQL rule or a GitHub-disclosed vuln. | LIVE |
| Project Zero | https://googleprojectzero.blogspot.com/ | Google's elite vuln-research team's writeups. | IF reading deep vuln-exploitation research. | LIVE |
| Andres Freund xz Disclosure | https://www.openwall.com/lists/oss-security/2024/03/29/4 | The original disclosure of CVE-2024-3094 (xz-utils backdoor). | IF teaching the xz case or auditing a suspicious maintainer onboarding. | STABLE |
| JFrog xz Analysis | https://jfrog.com/blog/xz-backdoor-attack-cve-2024-3094-all-you-need-to-know/ | Post-incident technical breakdown. | IF understanding the xz attack chain in detail. | STABLE |
| tj-actions/changed-files Compromise | https://www.stepsecurity.io/blog/harden-runner-detection-tj-actions-changed-files-action-is-compromised | March 2025 GitHub Actions supply-chain attack exfiltrating CI secrets. | IF justifying SHA-pinning + harden-runner deployment. | STABLE |
| event-stream npm postmortem | https://blog.npmjs.org/post/180565383195/details-about-the-event-stream-incident | 2018 maintainer-takeover case study. | IF teaching maintainer-handoff risks. | STABLE |
| node-ipc peacenotwar | https://snyk.io/blog/peacenotwar-malicious-npm-node-ipc-package/ | 2022 protestware incident. | IF discussing protestware / ideological maintainer risk. | STABLE |
| colors.js / faker.js | https://snyk.io/blog/open-source-npm-packages-colors-faker/ | 2022 maintainer self-sabotage case. | IF discussing maintainer-as-attacker scenarios. | STABLE |

## Cryptographic Standards

| Title | URL | What it is | Consult when | Stability |
|---|---|---|---|---|
| RFC 8446 — TLS 1.3 | https://www.rfc-editor.org/rfc/rfc8446 | Current TLS spec. | IF configuring TLS on a release CDN or debugging handshake. | STABLE |
| RFC 9110 — HTTP Semantics | https://www.rfc-editor.org/rfc/rfc9110 | Foundational HTTP spec. | IF reasoning about security headers, status codes, method semantics. | STABLE |
| RFC 7515 — JWS | https://www.rfc-editor.org/rfc/rfc7515 | JSON Web Signatures. | IF handling signed tokens or webhook signatures. | STABLE |
| RFC 7516 — JWE | https://www.rfc-editor.org/rfc/rfc7516 | JSON Web Encryption. | IF encrypting structured payloads (rare but appears in some MCP auth flows). | STABLE |
| RFC 9580 — OpenPGP v6 | https://www.rfc-editor.org/rfc/rfc9580 | Current OpenPGP spec (supersedes 4880). | IF implementing or debugging modern GPG interop. | STABLE |
| RFC 7519 — JWT | https://www.rfc-editor.org/rfc/rfc7519 | JSON Web Token. | IF handling auth tokens (OIDC, federated CI). | STABLE |
| RFC 8032 — EdDSA | https://www.rfc-editor.org/rfc/rfc8032 | Ed25519/Ed448 signature schemes. | IF adopting Ed25519 signing keys. | STABLE |
| IANA TLS Parameters | https://www.iana.org/assignments/tls-parameters/tls-parameters.xhtml | Authoritative list of TLS cipher suites / extensions. | IF enabling specific hybrid KEX codepoints. | LIVE |
| Mozilla SSL Configuration Generator | https://ssl-config.mozilla.org/ | Opinionated server-config snippets for nginx/apache/etc. | IF configuring a server for "Modern/Intermediate/Old" TLS profiles. | LIVE |
| Mozilla Observatory | https://observatory.mozilla.org/ | Free security-header scanner. | IF checking a site's header hygiene. | LIVE |
| SSL Labs Test | https://www.ssllabs.com/ssltest/ | Qualys's TLS configuration scanner. | IF grading a TLS endpoint's config. | LIVE |
| age encryption | https://age-encryption.org/ | Modern GPG replacement for file encryption. | IF picking a file-encryption tool for repo-tracked secrets. | STABLE |
| SOPS | https://github.com/getsops/sops | Mozilla/CNCF secrets encryption for structured files. | IF managing encrypted YAML/JSON secrets in a repo. | LIVE |

## AI-Security Sources

| Title | URL | What it is | Consult when | Stability |
|---|---|---|---|---|
| OWASP Top 10 for LLM Applications | https://owasp.org/www-project-top-10-for-large-language-model-applications/ | LLM-specific risk taxonomy (prompt injection, training-data poisoning, etc.). | IF building or reviewing an LLM-powered app / agent. | LIVE |
| MITRE ATLAS | https://atlas.mitre.org/ | MITRE's ATT&CK-style matrix for ML adversarial tactics. | IF threat-modeling ML systems or agents. | LIVE |
| Anthropic Prompt-Injection Mitigations | https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/mitigate-jailbreaks-and-prompt-injections | Canonical Anthropic guidance for untrusted-input handling. | IF designing prompts that consume user/third-party content. | LIVE |
| Invariant Labs GitHub MCP Disclosure | https://invariantlabs.ai/blog/mcp-github-vulnerability | May 2025 prompt-injection attack on GitHub MCP. | IF scoping permissions on AI agents with repo tool access. | STABLE |
| Brave Comet Hijack | https://brave.com/blog/comet-prompt-injection/ | Aug 2025 agent-hijack demo via web-page content. | IF reasoning about agentic browsing safety. | STABLE |
| Simon Willison on MCP + Injection | https://simonwillison.net/2025/Apr/9/mcp-prompt-injection/ | Practitioner analysis of MCP security pitfalls. | IF evaluating a new MCP server for install. | STABLE |
| Lanyado et al. — Package Hallucination | https://arxiv.org/abs/2406.10279 | Foundational slopsquatting research. | IF justifying install-time hallucination controls. | STABLE |
| Socket on Slopsquatting | https://socket.dev/blog/slopsquatting-how-ai-hallucinations-are-fueling-a-new-class-of-supply-chain-attacks | Practitioner writeup with attack examples. | IF needing concrete slopsquatting cases. | LIVE |
| Trojan Source | https://trojansource.codes/ | Boucher & Anderson 2021 — bidi + homoglyph source attacks. | IF auditing diffs for Unicode-based obfuscation. | STABLE |
| Carlini et al. — Web-Scale Poisoning | https://arxiv.org/abs/2302.10149 | Training-data poisoning research. | IF reasoning about long-term training-corpus risks. | STABLE |
| modelscan | https://github.com/protectai/modelscan | Pre-flight scanner for serialized ML models. | IF loading third-party `.pt`/`.pkl` models. | LIVE |
| picklescan | https://github.com/mmaitre314/picklescan | Targeted pickle-bomb detector. | IF scanning Python pickle files specifically. | LIVE |
| safetensors | https://github.com/huggingface/safetensors | Safe binary format for model weights (no code exec on load). | IF migrating pickle models to a safe format. | STABLE |
| NIST AI Risk Management Framework | https://www.nist.gov/itl/ai-risk-management-framework | AI-RMF 1.0 — govern/map/measure/manage cycle for AI risk. | IF scoping an org-level AI risk program. | STABLE |

## Post-Quantum

| Title | URL | What it is | Consult when | Stability |
|---|---|---|---|---|
| FIPS 203 — ML-KEM | https://csrc.nist.gov/pubs/fips/203/final | NIST's finalized PQC key-encapsulation standard (Kyber). | IF evaluating PQC KEX adoption. | STABLE |
| FIPS 204 — ML-DSA | https://csrc.nist.gov/pubs/fips/204/final | NIST's finalized PQC signature standard (Dilithium). | IF planning PQC signing migration. | STABLE |
| FIPS 205 — SLH-DSA | https://csrc.nist.gov/pubs/fips/205/final | NIST's hash-based PQC signature standard (SPHINCS+). | IF long-term signatures needing conservative security assumptions. | STABLE |
| NIST PQC Project Hub | https://csrc.nist.gov/projects/post-quantum-cryptography | Umbrella page for PQC standardization + future rounds. | IF tracking PQC status across all algorithms. | LIVE |
| NSA CNSA 2.0 | https://media.defense.gov/2022/Sep/07/2003071836/-1/-1/0/CSA_CNSA_2.0_ALGORITHMS_.PDF | NSA PQC-transition timeline for national security systems. | IF setting org-wide PQC deadlines (2030–2035 targets). | STABLE |
| NSA Quantum-Readiness Guidance | https://www.nsa.gov/Press-Room/Press-Releases-Statements/Press-Release-View/Article/3148990/ | NSA advisory on preparing for quantum transition. | IF briefing stakeholders on quantum timelines. | STABLE |
| CISA PQC Roadmap | https://www.cisa.gov/quantum | CISA's quantum-preparedness resources + roadmap. | IF writing an org migration plan. | LIVE |
| IETF PQUIP WG | https://datatracker.ietf.org/wg/pquip/about/ | IETF working group for PQC in protocols. | IF tracking PQC in TLS, SSH, CMS, X.509. | LIVE |
| Cloudflare PQC Deployment | https://blog.cloudflare.com/pq-2024/ | Production data on hybrid KEX rollout. | IF defending "PQ KEX is production-ready" claim. | LIVE |
| OpenSSH 9.9 Release Notes | https://www.openssh.com/txt/release-9.9 | First OpenSSH release defaulting to hybrid PQ KEX. | IF upgrading SSH for PQ readiness. | STABLE |
| Open Quantum Safe (liboqs) | https://openquantumsafe.org/ | Reference implementations of PQC algorithms. | IF prototyping or integrating PQC primitives. | LIVE |

## Repo-Specific

| Title | URL | What it is | Consult when | Stability |
|---|---|---|---|---|
| GitHub Secret Scanning | https://docs.github.com/en/code-security/secret-scanning/introduction/about-secret-scanning | GH native secret detection + push protection. | IF enabling or debugging secret scanning. | LIVE |
| GitHub CodeQL | https://codeql.github.com/ | GH native SAST. | IF setting up CodeQL workflows or writing custom queries. | LIVE |
| GitHub Advisory Database Docs | https://docs.github.com/en/code-security/security-advisories | Authoring private advisories + CVE requests. | IF disclosing a vuln privately via GHSA. | LIVE |
| GitHub Actions Security Hardening | https://docs.github.com/en/actions/security-for-github-actions/security-guides/security-hardening-for-github-actions | Canonical Actions security practices. | IF securing workflows (permissions, pinning, secrets). | LIVE |
| GitHub OIDC for Cloud | https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect | OIDC federation replacing long-lived cloud creds. | IF CI needs cloud access without stored secrets. | LIVE |
| Repository Rulesets | https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets | Next-gen branch/tag protection. | IF migrating from classic branch protection. | LIVE |
| trufflehog | https://github.com/trufflesecurity/trufflehog | Secret scanner with credential verification. | IF scanning repos/history outside GitHub or for non-partner providers. | LIVE |
| gitleaks | https://github.com/gitleaks/gitleaks | Lightweight regex+entropy secret scanner. | IF running a fast pre-commit secret check. | LIVE |
| git-crypt | https://github.com/AGWA/git-crypt | Transparent file-level encryption in git. | IF encrypting a small number of tracked files. | STABLE |
| git filter-repo | https://github.com/newren/git-filter-repo | Modern history-rewrite tool (replaces filter-branch). | IF removing leaked secrets or large files from history. | LIVE |
| Semgrep | https://semgrep.dev/docs/ | Pattern-based static analysis. | IF adding a second SAST tool or writing custom rules. | LIVE |
| Snyk | https://docs.snyk.io/ | Commercial dep + code + IaC scanner. | IF a commercial SAST/SCA with strong JS coverage is needed. | LIVE |
| SonarQube | https://www.sonarsource.com/products/sonarqube/ | Code-quality + security platform. | IF needing on-prem SAST with quality overlap. | LIVE |
| OWASP Dependency-Check | https://owasp.org/www-project-dependency-check/ | SCA scanner mapping deps to CVEs. | IF running an OWASP-branded SCA in CI. | LIVE |
| OWASP ZAP | https://www.zaproxy.org/ | OWASP DAST tool. | IF running dynamic scans against a web app. | LIVE |
| OSSF Secure Repositories Guide | https://best.openssf.org/Concise-Guide-for-Developing-More-Secure-Software | Practical concise security guide from OpenSSF. | IF onboarding a contributor to security practices. | LIVE |

## Awesome Lists

| Title | URL | What it is | Consult when | Stability |
|---|---|---|---|---|
| awesome-opensource-security | https://github.com/paragonie-scott/awesome-appsec | Curated appsec resource list. | IF exploring resources for a security area. | LIVE |
| awesome-cve-poc | https://github.com/qazbnm456/awesome-cve-poc | PoC-by-CVE index. | IF looking up exploit-availability for a CVE. | LIVE |
| awesome-security | https://github.com/sbilly/awesome-security | General security curated list. | IF exploring tools across categories. | LIVE |
| awesome-threat-modeling | https://github.com/hysnsec/awesome-threat-modeling | Threat-modeling methodology + tool resources. | IF building a threat model. | LIVE |
| SANS Reading Room | https://www.sans.org/white-papers/ | SANS-published whitepapers across security topics. | IF researching a specific topic with detailed writeups. | LIVE |
| HackerOne Hacktivity | https://hackerone.com/hacktivity | Public disclosed H1 reports. | IF studying disclosure norms + realistic finding quality. | LIVE |
| Bugcrowd Program Index | https://bugcrowd.com/programs | Public bug-bounty program list. | IF studying program scoping examples. | LIVE |
| Matrix Spec | https://spec.matrix.org/ | Federated secure messaging spec used for incident comms. | IF picking an out-of-band incident channel. | LIVE |
| Signal Protocol | https://signal.org/docs/ | Double-ratchet secure-messaging protocol docs. | IF reasoning about E2EE messaging properties. | STABLE |
| Linux Kernel Security | https://docs.kernel.org/admin-guide/security-bugs.html | Kernel security-bug reporting process. | IF reporting a kernel vuln. | STABLE |
| OSS-Fuzz | https://google.github.io/oss-fuzz/ | Google's continuous fuzzing for OSS. | IF onboarding a C/C++/Rust/Go project to free fuzzing. | LIVE |
| Rust Security WG | https://www.rust-lang.org/governance/wgs/wg-secure-code | Rust's secure-code working group + advisory DB. | IF contributing to Rust ecosystem security. | LIVE |
| Node.js Security WG | https://github.com/nodejs/security-wg | Node.js security-vuln handling + security-releases. | IF reporting Node.js vulns or tracking advisories. | LIVE |
| Python PSF Security | https://www.python.org/dev/security/ | PSF security policy + reporting. | IF reporting a CPython or stdlib vuln. | STABLE |
| Software Heritage | https://www.softwareheritage.org/ | Universal source-code archive. | IF preserving a project against bus-factor / DR. | LIVE |
