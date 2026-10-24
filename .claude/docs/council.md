# The Council — cross-family review at studio gates

The studio's 51 agents all run on one model family. A creative-director PASS and
a technical-director PASS are two opinions from the same model, so they share
its blind spots. The **council** adds reviewers from other model families at the
points where a shared blind spot is most expensive: architecture, phase gates,
security and every commit.

The council **adds** seats beside the director gates in
`.claude/docs/director-gates.md`. It never replaces a director, never skips one,
and never softens a director's verdict.

---

## Who sits

Each teammate is a model family run through its own CLI. Names are the
teammates; the second column is the tool they run on.

| Teammate | Runs on | Seat(s) | CLI |
|---|---|---|---|
| **Clahadore** | Claude (this session) | Implementer; council seat (advisory-only when Claude wrote the work) | — |
| **Cedric** | Codex / ChatGPT (`gpt-5.6-sol`, reasoning high) | Chair (synthesis) + seat | `codex exec` |
| **Regular Jenny** | Gemini 4 Argon High (`gemini-4-argon-high`) | Correctness / design / regression | `agy` |
| **Cyber Jenny** | Gemini 3.8 Flash High (`gemini-3.8-flash-high`), adversarial-security prompt, "do not use any tool" | Security seat — not Gemini 3.5 Flash Cyber | `agy` |
| **Gronktayvius General** | Grok | Correctness, architecture, contracts | `UsageGovernor.exe grok-exec` |
| **Gronktayvius Red Team** | Grok | Abuse cases, trust boundaries, exploitability | `UsageGovernor.exe grok-exec` |
| **Susie Franny** | Meta Muse Spark | **Red Team** (standing, Andrew 2026-10-24) — abuse cases, trust boundaries, exploitability, prompt-injection paths | `muse exec` read-only (`--disable-write --disable-shell --disable-web-tools`), material inlined in the prompt |

Families, for quorum: Claude, OpenAI, Google, xAI, Meta. **Two seats from one
family count as one vote** — both Jenny roles are one Google vote, both
Gronktayvius roles one xAI vote. Susie Franny is the Meta family and carries
her own vote, independent of Gronktayvius Red Team (xAI).

If the user's machine has the fleet skills `/council-code-review` and
`/llm-council` installed (`~/.claude/skills/`), **use them** — they carry the
seat isolation, validation and failure contract. The rules below are the
contract those skills implement; they apply directly only where the skills are
absent.

### Author family

The author family is the model family that wrote the change under review. Read
the git commit `Author` and every `Co-Authored-By` line plus the PR authorship
line. Map model names to families: Claude/Clahadore → Claude;
Codex/ChatGPT/GPT/Cedric → OpenAI; Gemini/Jenny/agy → Google;
Grok/Gronktayvius → xAI; Muse/Susie Franny → Meta. When work is mixed, every
contributing family is an author family. A human-only author line maps to no
family; if no model family is identifiable, treat Claude as the author.

## Tiers — `council.tier`

One setting, in `project.yaml` or (per machine) `project.local.yaml`. Values:
`full` | `available` | `off`. **Unset means `available`.** Resolve it with
`bash .claude/hooks/yaml-helper.sh resolve_config --keys council_tier`.
YAML key `council.tier`, resolver label `council_tier`.

### `full` — the whole council

Built first; the target structure.

- Seats: Cedric, Regular Jenny, Gronktayvius General, Susie Franny (Red Team), Clahadore
  (advisory when Claude authored). Security-sensitive work adds Cyber Jenny and
  Gronktayvius Red Team.
- Chair: Cedric. When Codex authored the work, Clahadore chairs. The author
  never chairs.
- **Quorum: 3 independent families**, the author's family excluded.
- A required seat that fails (no output, truncated, wrong model resolved) fails
  the gate. No silent fallback, no relabelling one seat as another.

### `available` — the default: whoever is reachable

The structure we run today: Claude and Codex reliably, Gemini and Muse usually,
Grok when its limits allow. Same roles as `full`, seated from whoever answers.

1. Run `bash .claude/scripts/council-preflight.sh`. It reports which CLIs are
   installed and which fleet skills exist. It does not decide anything.
2. Seat every family that is present, in this order: Cedric, Regular Jenny, Susie
   Franny (Red Team), Gronktayvius General. On security-sensitive or release work also seat Cyber Jenny and Gronktayvius Red Team (same families as Regular Jenny / Gronktayvius General: they add coverage, not votes).
   A seat the usage governor denies counts as absent.
3. Chair: Cedric if seated and not the author; otherwise the strongest seated
   non-author; if no non-author seat exists,
   there is no chair and the gate fails.
4. **Quorum: 2 independent non-author families.** Claude counts only when it
   did not author the work.
5. n = number of non-author families with at least one seated seat. Quorum is
   met at n ≥ 2. Below quorum:
   - Ordinary gates may proceed **only when n = 1** (one non-author family
     seated and producing findings); with **n = 0 the gate fails**.
     The verdict is stamped **`DEGRADED (n/2 families)`**
     with the missing seats named. A degraded PASS is reported as degraded, never
     as a plain PASS.
   - **Security-sensitive and release gates fail closed.** They may proceed only
     with a logged waiver: approver, reason, gate, story/commit, ISO-8601 UTC
     expiry no more than 24 hours away. An expired or incomplete waiver fails.

### `off` — Claude directors only

Upstream CCGS behaviour. For jams and throwaway prototypes.

### Choosing

| Situation | Tier |
|---|---|
| Fleet machine with all CLIs logged in, release or milestone work | `full` |
| Day-to-day production | `available` |
| Machine with no other CLIs; game jam; `/prototype` | `off` |

## Where the council sits

`council.tier` decides **who besides the director** reviews a gate. Unless the
tier is `off`, the commit gate and security-sensitive work convene the council
even when `review_mode` skips the director gate. All other rows follow the
director gate's mode check.

0. Before any diff or document goes to a seat, scan it for secrets: run
   `gitleaks detect --no-git --source <file>` when gitleaks is installed; otherwise
   grep for private keys, `AKIA`, `ghp_`, `sk-`, `xox`, `password=`, and `.env`
   content. Exclude `.env*`, `*.pem`, `*.key`, and `project.local.yaml` from seat
   packets. A hit stops the sitting until the secret is removed.

| Gate point | Director gate | Council mode |
|---|---|---|
| Every commit of code, config, tests or CI | — | `/council-code-review` (diff review) |
| `/code-review`, `/story-done` | LP-CODE-REVIEW, QL-TEST-COVERAGE | `/council-code-review` on the story's diff |
| `/create-architecture` sign-off | TD-ARCHITECTURE | `/llm-council` on the architecture doc |
| `/architecture-decision` before Accepted | TD-ADR | `/llm-council` on the ADR |
| `/gate-check` phase transitions | CD/TD/PR/AD-PHASE-GATE | `/llm-council` on the gate packet |
| `/security-audit`, any security-sensitive change | — | Security seats: Regular Jenny, Cyber Jenny, Gronktayvius Red Team, Susie Franny (Red Team); Cedric adjudicates. Security quorum: at least two non-author families among the security seats; Google (either Jenny) counts once, xAI once, Meta once. Susie Franny's Red Team seat never substitutes for, or is relabelled as, Gronktayvius Red Team |
| `/release-checklist` | — | Full available panel **and** all security seats including Susie Franny (Red Team) |

TD-ARCHITECTURE and `/security-audit` sittings require the data-flow diagram + STRIDE table from `security-baseline.md`. [threat-modeling deck ch.1, 9, 10, 12]

Security-sensitive means: auth, crypto, secrets, permissions, input validation,
parsers, save-file loading, network boundaries, anti-cheat, or any material
change to attack surface. For games, this also includes save-file and config loading,
mod/UGC loading, network replication and RPC validation, anti-cheat,
matchmaking/session code, in-engine web UI (WebUI) content, editor MCP servers
and tooling, packaging/signing/update channel, store and platform credentials
(Steam, EOS, console); see `.claude/docs/security-baseline.md`.
When unsure, it is security-sensitive.

## Combining verdicts

- The **most severe verdict wins**: FAIL over CONCERNS over PASS. A council FAIL
  over a director PASS is a FAIL.
- An evidence-backed **High or Critical** finding fails the gate on its own, from
  any single seat.
- The chair dedupes and ranks findings; the chair does not get a veto over a
  seat's High/Critical finding.
- Clahadore implements fixes from the chair's list. No seat edits the working tree.

## Recording

Write one file per council sitting to `production/council/<YYYY-MM-DD>-<gate-id>.md`:

- Gate, story/commit, tier, quorum met or `DEGRADED (n/m)`
- Per seat: teammate, requested model, resolved model, prompt hash, status
  (`OK` / `FAILED` / `ABSENT` / `ADVISORY`), finding count by severity
- Chair, final verdict, waiver (if any)
- Findings, or a link to the fleet skill's own report

A seat that produced no tokens is `FAILED`, never "no objections".

## Never

- Fabricate a seat's output, or predict what a seat would have said
- Count a seat that did not run
- Let the author chair, or count the author's family toward quorum
- Run a seat with the live working tree as its writable cwd (the fleet skills
  use a disposable checkout; do the same by hand)
- Send secrets, credentials, `.env` files or real player data to any seat
- Send any diff or document to a seat before it has passed the secret scan in step 0
