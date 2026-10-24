# Security baseline (games)

Adapted from the studio-wide baseline on Jira FLT-281 (items 1–40, 2026-10-24). Each item below is a requirement before the matching feature ships; the FLT-281 item number is in brackets.

## Process gates

- Security-sensitive changes get the full security council per `.claude/docs/council.md` (Regular Jenny `gemini-4-argon-high`, Cyber Jenny `gemini-3.8-flash-high`, Gronktayvius General + Red Team, Cedric adjudicating). For games, security-sensitive also means: save-file and config loading, mod/UGC loading, network replication and RPC validation, anti-cheat, matchmaking/session code, in-engine web UI (WebUI) content, editor MCP servers and tooling, packaging/signing/update channel, store and platform credentials (Steam, EOS, console). Evidence-backed High/Critical findings block. [1]
- Active pentesting only against an isolated, explicitly authorized test build/server — never live players or production services. [2]
- Scanners must be able to fail: gitleaks baseline green on every PR; mutation testing (if used) has `break > 0`. CI scanner workflow (gitleaks, Semgrep, CodeQL for C#/C++) is tracked separately and must be shown green before it is required. [3][4]
- Gates (feature flags, capability checks, council/review gates) get contract tests against verbatim payloads from the real producer plus a negative test. [5]
- Agent output is a claim: paste build/test receipts; run full suites, not narrow filters. [37] "Master green" can hide latent reds — fix CI failures one at a time. [38]
- Verify on the real build: a fix is done only when reproduced against the running game/editor (see `.claude/docs/run-and-observe.md`). [25]
- `/create-architecture` and `/security-audit` produce a repo-resident data-flow diagram with trust boundaries and a STRIDE-per-element table; risk acceptances name an owner and expire. [threat-modeling deck ch.1, 9, 10, 12]

## Safe by construction

- If a surface must not do something, delete the capability instead of switching it off. Editor MCP servers (`docs/engine-reference/unreal/mcp.md`) are off unless a task needs them — Epic's Unreal MCP keeps `bAutoStartServer=False`; start it per task and stop it after. [9]
- Put each control on the process that makes the request: the dedicated server validates every client RPC; never trust the client. Editor-side MCP limits belong in the editor plugin config, not only in agent instructions. [10]
- Presence is not reachability: an MCP server, build host or plugin listed somewhere is not working until a real call/build succeeds. [29]
- Editor MCP servers bind only to localhost (`127.0.0.1`), default off and start per task; validate `Origin`/`Host` and allow-list exposed tools/tokens where supported. MCP/editor plugins never ship in packaged builds (editor-only `TargetAllowList`). [websec: CORS, CSRF, Host header]
- A player-hosted co-op listen server is untrusted for persistent progression, currency and cross-session inventory; a dedicated server or backend validates persistent state. [threat-modeling deck ch.2, 3, 9]
- When online lands, verify Steam/EOS tickets server-side in `PreLogin`, bind RPCs to `UniqueNetId`, rotate session tokens and authorize lobby/squad invites (no IDOR). [websec: Authentication, Access control]

## Content and data

- Save files, config files, mods and any downloaded content are untrusted input: validate sizes and versions, no path traversal from file contents, no code execution from data. [21]
- WebUI (in-engine Chromium) pages: ship local HTML only, strict CSP (`script-src 'self'`, no inline handlers), no remote script, allowlist any embedded URLs, sanitize any player-provided text before it reaches the page. [11][12][13]
- Telemetry/analytics properties are a closed set: no free text, player names, chat or IDs beyond a pseudonymous ID; errors map to codes. [16]
- Minors and online play: when co-op/online/chat lands, plan age rating (ESRB/PEGI/IARC), report/block, and safe defaults. [17]
- If anything ships an overlay or injects into other processes, check anti-cheat and overlay platform terms first (FLT-281 gamer council). [overlay]
- The Chromium↔UE/C# WebUI bridge exposes only a narrow allow-listed DTO API, never raw UObject reflection or console commands; validate `postMessage` origin/source and JSON schema. CSP includes `frame-ancestors 'none'` and `require-trusted-types-for 'script'`. [websec: DOM-based, Clickjacking]
- Save/mod parsing bounds bytes before buffering, caps archive entries and decompression ratio, forbids polymorphic type instantiation from data, enforces schema depth/value ranges and disables XML DTDs; fuzz custom parsers in CI. [websec: File upload, Insecure deserialization, XXE]
- Save/mod storage uses engine-generated IDs instead of user filenames; canonicalize paths with trailing-separator checks, reject symlinks/junctions and TOCTOU races, and quarantine/scan UGC before mounting. [websec: File upload, Directory traversal]
- Backend or WebUI WebSockets use `wss://`, authenticated handshakes, a strict Origin allow-list, maximum payload sizes before parsing and rate limits; enforce per-message session/room authorization and expiring, revocable access. [websec: WebSockets]
- Audit auth, RPC rejections, economy/save changes and MCP calls with `UniqueNetId`, action, time and result in an append-only server store that survives `USE_LOGGING_IN_SHIPPING=0`. [threat-modeling deck ch.4 Repudiation]

## Builds, secrets, distribution

- Shipped game builds, launchers and tools are code-signed, with a signed update channel. [22]
- Secrets (Steam/EOS keys, signing certs, store tokens, API keys) live in a secret manager, never in the repo or `project.yaml`; rotation is scripted and single-writer. [24][35]
- Installer/packaging tests that install, uninstall or overwrite run only on disposable VMs or peer PCs, never on a working install. [36]
- No local-only dependencies in cloud builds: CI must not reference a developer's engine path (e.g. `A:\Epic Games\…`), local models or unpinned plugin checkouts; pin plugins (GMAS tag, UnrealSharp commit). [34]
- Third-party "draft"/preview hosting is public: never upload Fab plugin binaries, unreleased builds or licensed assets to third-party hosts; internal artifacts stay in private storage. [32]
- Timeouts bound the wait, not just the call: build, MCP, model and fleet-dispatch waits each have a deadline. [33]
- Agents act only on the rails: no publishing to Steam/Fab/stores, posting, or purchasing without the user present and approving. [26]
- Retired model IDs fail or redirect silently: model slugs are pinned in `council.md`; `.claude/scripts/model-slug-check.sh` reports retired slugs anywhere in the repo. [39]
- Block secrets at pre-commit and through push protection, with a rotation runbook for leaks; check SLSA-style build provenance between build and deploy and enforce anti-rollback version checks on the signed update channel. [websec: Secure SDLC; threat-modeling deck ch.3, 8]
- Shipped UnrealSharp C# assemblies are signed; save files, mods and WebUI input never drive dynamic `Assembly.Load`, reflection or P/Invoke. [threat-modeling deck ch.11; websec: Insecure deserialization]

## Not applicable yet

Revisit when the feature exists: data-layer tenant isolation and IDOR tests, OAuth token storage, SSRF on imports, overlay ingestion auth, licensed-text rules, multi-login-path tests, authenticated-prod verification, data export/delete, email rules, Angular traps. [6–8, 15, 18–20, 23, 27–28, 30–31, 40]
