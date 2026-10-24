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
| **Cedric "Cody"** | Codex / ChatGPT (`gpt-5.6-sol`, reasoning high) | Chair (synthesis) + seat | `codex exec` |
| **Jenny** (Regular) | Gemini 3.1 Pro, high | Correctness / design / regression | `agy` |
| **Jenny** (Cyber) | Gemini 3.6 Flash, high, adversarial-security prompt | Security seat — **not** Gemini 3.5 Flash Cyber | `agy` |
| **Gronktayvius "Gronk"** (General) | Grok | Correctness, architecture, contracts | `UsageGovernor.exe grok-exec` |
| **Gronktayvius** (Red Team) | Grok | Abuse cases, trust boundaries, exploitability | `UsageGovernor.exe grok-exec` |
| **Susie Franny** | Meta Muse Spark | Seat (probation) | `muse exec` |

Families, for quorum: Claude, OpenAI, Google, xAI, Meta. **Two seats from one
family count as one vote** — both Jenny roles are one Google vote, both
Gronktayvius roles one xAI vote.

If the user's machine has the fleet skills `/council-code-review` and
`/llm-council` installed (`~/.claude/skills/`), **use them** — they carry the
seat isolation, validation and failure contract. The rules below are the
contract those skills implement; they apply directly only where the skills are
absent.

## Tiers — `council.tier`

One setting, in `project.yaml` or (per machine) `project.local.yaml`. Values:
`full` | `available` | `off`. **Unset means `available`.** Resolve it with
`bash .claude/hooks/yaml-helper.sh resolve_config --keys council_tier`.

### `full` — the whole council

Built first; the target structure.

- Seats: Cedric, Regular Jenny, Gronktayvius General, Susie Franny, Clahadore
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
2. Seat every family that is present, in this order: Cedric, Jenny, Susie
   Franny, Gronktayvius. A seat the usage governor denies counts as absent.
3. Chair: Cedric if seated and not the author; otherwise the strongest non-author
   seat; otherwise Clahadore.
4. **Quorum: 2 independent non-author families.** Claude counts only when it
   did not author the work.
5. Below quorum:
   - Ordinary gates proceed, and the verdict is stamped **`DEGRADED (n/2 families)`**
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

`modes.review_mode` decides **whether** a gate runs. `council.tier` decides
**who besides the director** reviews it. A gate skipped by `review_mode` gets no
council either. Two exceptions run at every `review_mode` unless the tier is
`off`: the commit gate and security-sensitive work.

| Gate point | Director gate | Council mode |
|---|---|---|
| Every commit of code, config, tests or CI | — | `/council-code-review` (diff review) |
| `/code-review`, `/story-done` | LP-CODE-REVIEW, QL-TEST-COVERAGE | `/council-code-review` on the story's diff |
| `/create-architecture` sign-off | TD-ARCHITECTURE | `/llm-council` on the architecture doc |
| `/architecture-decision` before Accepted | TD-ADR | `/llm-council` on the ADR |
| `/gate-check` phase transitions | CD/TD/PR/AD-PHASE-GATE | `/llm-council` on the gate packet |
| `/security-audit`, any security-sensitive change | — | Security seats (Cyber Jenny + Gronktayvius Red Team + Regular Jenny, Cedric adjudicates) |
| `/release-checklist` | — | Full available panel **and** both security seats |

Security-sensitive means: auth, crypto, secrets, permissions, input validation,
parsers, save-file loading, network boundaries, anti-cheat, or any material
change to attack surface. When unsure, it is security-sensitive.

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
