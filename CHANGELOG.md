# Changelog

All notable changes to `repo-craft` are documented in this file.
Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Versioning: [SemVer](https://semver.org/).

## [Unreleased]

## [0.1.0] — 2026-04-20

### Deploy notes
- First deploy to `~/.claude/skills/repo-craft/` succeeded via `install.sh` (portable cp path; rsync optional).
- E2E passes: install, sniff, load-ref (full + anchor), memory round-trip, zero-residue uninstall.
- All 22 critical H2 anchors resolve through `load-ref.sh`.
- 14 reference files present (INDEX + 13 instrumented).
- 4 playbooks present (02, 07, 08, 09).
- Auto-activation verification (trigger phrase "help me contribute" in a fresh Claude Code session) deferred to first real use.

### Added
- Skill orchestrator (`SKILL.md`) with YAML auto-activation and explicit `/repo-craft` invocation
- Context sniffer (`lib/sniff.sh`): detects own-repo vs fork vs upstream vs off-repo
- Reference section loader (`lib/load-ref.sh`): extracts H2 sections on demand
- Local memory layer (`lib/remember.sh`, `lib/recall.sh`, `state/*.json`)
- 4 playbooks: first-time-contributor, fork-contribute, upstream-sync, own-repo-health-audit
- 13 instrumented references (01-10, 14, 15, 16) + `INDEX.md` master map
- `install.sh` / `update.sh` / `uninstall.sh` with zero-residue uninstall
- Non-overlap contract with existing skills + recursion guard
- Graceful degradation when `gh` CLI or required sub-skill is absent
