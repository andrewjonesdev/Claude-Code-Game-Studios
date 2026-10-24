# Agent Test Spec: ue-csharp-specialist

## Agent Summary
- **Domain**: C# gameplay code written with UnrealSharp — reflection attributes, the managed/native boundary, hot-reload-safe patterns, and the C# vs C++ vs Blueprint split
- **Does NOT own**: GMC predicted movement and GMAS ability internals (ue-gmc-specialist, C++ hot paths), general UE architecture (unreal-specialist), Blueprint graph structure (ue-blueprint-specialist), IDE licensing decisions beyond the project's documented setup
- **Gate IDs**: None; defers cross-domain calls to the appropriate specialist

---

## Static Assertions (Structural)

- [ ] `description:` field is present and domain-specific (references UnrealSharp, managed/native boundary, hot reload)
- [ ] `tools:` reads Read, Glob, Grep, Write, Edit, Bash, plus the Unreal MCP tool families — no `Agent` tool
- [ ] Model tier is `sonnet` — frontmatter `model:` reads exactly `sonnet` (tiers: `.claude/docs/model-tiers.md`)
- [ ] Agent definition includes the Language Split table and the UnrealSharp anti-patterns list

---

## Test Cases

### Case 1: Hot path routed to C++ — movement prediction in C#
**Input**: "Port the GMC predicted-movement correction step to C# so the gameplay team can tune it without recompiling."
**Expected behavior**:
- Refuses to port the GMC predicted-move path to C#, citing the Language Split table (hot per-frame movement is C++)
- Explains the managed transition cost and the move replay contract
- Proposes exposing a tunable value through a data asset or a C++ `Blueprintable` hook, with the logic kept in C++
- Hands the C++ side to ue-gmc-specialist or unreal-specialist

### Case 2: Static mutable state — round manager singleton
**Input**: "Make a static `RoundManager.Instance` that holds the current round number and alive player list so any class can read it."
**Expected behavior**:
- Flags static mutable state as unsafe under hot reload (assembly unload leaks or drops the state)
- Proposes a UObject-owned state holder (a subsystem or a game-state actor) reached through dependency injection, not a static singleton
- Keeps the data reachable from Blueprint through reflected properties

### Case 3: Boundary attributes — designer cannot see a property
**Input**: "The designer says the `MaxRespawnTime` field on our C# pawn doesn't show up in the editor. Can you just make it public?"
**Expected behavior**:
- Identifies the cause: an unattributed member is invisible to Blueprint, serialization and replication
- Adds the UnrealSharp reflection attribute (`[UProperty]` with `EditAnywhere | BlueprintReadWrite`), checking the exact flag names against `docs/engine-reference/unreal/plugins/unrealsharp.md` first
- Does NOT treat "public" as sufficient
- Asks before writing any file, naming the target path

### Case 4: Platform scope — Linux shipping target
**Input**: "Add a Linux dedicated server build target for the C# round logic this sprint."
**Expected behavior**:
- Flags that UnrealSharp support is Windows and macOS only; Linux is not supported yet
- Does NOT assume the Linux build will work
- Recommends keeping the server target out of scope or raising it as a risk with the producer

### Case 5: IDE guidance — Cursor setup
**Input**: "I'm using Cursor. Install the C# Dev Kit extension so I get debugging for the managed code."
**Expected behavior**:
- Does NOT tell the user to install C# Dev Kit in Cursor (licensed for Microsoft VS Code only)
- Points to the documented setup in `docs/engine-reference/unreal/ide-cursor-antigravity.md` (DotRush or ReSharper for VS Code)
- Notes that hot reload works from a file watcher on save, independent of the IDE

### Case 6: Version awareness — unverified attribute
**Input**: "Mark the field with `[UProperty(PropertyFlags.ReplicatedUsing = OnRep_Health)]` so it replicates."
**Expected behavior**:
- Reads `docs/engine-reference/unreal/plugins/unrealsharp.md` before asserting the attribute syntax
- If the flag or form is not verified there, says so and marks it unverified
- Routes replication design to ue-replication-specialist before any C# type replicates state

---

## Protocol Compliance

- [ ] Stays within declared domain (C# gameplay via UnrealSharp, the managed/native boundary)
- [ ] Refuses to move per-frame or GMC predicted-movement code into C#
- [ ] Rejects static mutable state and unattributed members visible to designers
- [ ] States UnrealSharp platform limits (Windows and macOS) whenever a target is named
- [ ] Gives the project's documented IDE guidance; does not recommend C# Dev Kit for Cursor or Antigravity
- [ ] Asks "May I write this to [filepath]?" naming the file before writing

---

## Coverage Notes
- Case 1 guards the Language Split; a regression here moves the move replay contract into managed code
- Case 4 and Case 5 are factual-boundary tests; they fail when the agent asserts support or licensing from memory
- Case 6 is the version-awareness test; UnrealSharp has no tagged releases, so verified facts live in the plugin reference
- No automated runner; review manually or via `/skill-test`
