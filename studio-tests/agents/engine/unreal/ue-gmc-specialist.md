# Agent Test Spec: ue-gmc-specialist

## Agent Summary
- **Domain**: GMCv2 predicted movement (UGMC_OrganicMovementCmp and the GMCExtended / NarrativeGMC movement hierarchy), GMCAbilitySystem (GMAS) abilities, attributes and effects, Narrative Pro components (inventory, equipment, interaction, quests, dialogue), and the NarrativeGMC bridge plugin that joins them
- **Does NOT own**: general UE architecture (unreal-specialist), replication outside GMC's move contract (ue-replication-specialist), C# gameplay code (ue-csharp-specialist), UMG widgets (ue-umg-specialist), skeleton retargeting art pipeline (technical-artist)
- **Gate IDs**: None; defers cross-domain calls to the appropriate specialist

---

## Static Assertions (Structural)

- [ ] `description:` field is present and domain-specific (references GMC, GMAS, Narrative Pro, NarrativeGMC)
- [ ] `tools:` reads Read, Glob, Grep, Write, Edit, Bash, plus the Unreal MCP tool families — no `Agent` tool
- [ ] Model tier is `sonnet` — frontmatter `model:` reads exactly `sonnet` (tiers: `.claude/docs/model-tiers.md`)
- [ ] Agent definition states the stack layers and their base types (GMCv2, GMCExtended, GMAS, Narrative Pro, NarrativeGMC)

---

## Test Cases

### Case 1: Forbidden base class — story character subclassing ACharacter
**Input**: "Make the new companion character extend ANarrativeCharacter so it picks up the Narrative Pro dialogue hooks."
**Expected behavior**:
- Refuses to subclass `ACharacter` / `ANarrativeCharacter` directly, because the project replaces stock Narrative Pro characters with the NarrativeGMC pawn hierarchy
- Redirects the request to the NarrativeGMC pawn type (`ANarrativeGMCPlayerPawn` or its NPC equivalent) and the Narrative components composed onto it
- Does NOT use `UCharacterMovementComponent` for the companion's movement
- Asks before writing any file, naming the target path

### Case 2: Ability routing — GAS request routed to GMAS
**Input**: "Add a GameplayAbility for a ground slam that applies a GameplayEffect to nearby enemies, using the standard GAS setup."
**Expected behavior**:
- Does NOT write a `UGameplayAbility`, `UAbilitySystemComponent`, or GAS `UAttributeSet`
- States that abilities, effects and attributes in this project are GMAS (`UGMC_AbilitySystemComponent`, GMAS ability types)
- Plans the ground slam as a GMAS ability running inside GMC's move loop, with any state that affects movement bound through GMC
- Notes that if a Narrative Pro GAS ability already exists, its GMAS port in NarrativeGMC is the work, not a GAS fallback

### Case 3: Fork policy — request to patch Narrative Pro source
**Input**: "Narrative Pro's inventory has a bug. Just edit the plugin source under Plugins/ to fix it and we'll move on."
**Expected behavior**:
- Refuses to edit or vendor Narrative Pro source (Fab product; lost on the next Fab update, and redistribution is not allowed)
- Proposes the change in NarrativeGMC instead, as a subclass, composition or redirect
- If that is impossible, offers to draft a vendor bug report via `/bug-report`, and does NOT file anything itself (coordination rule 7)
- Does not create a GitHub fork

### Case 4: Predicted-move contract — teleport and side-channel movement
**Input**: "The dash ability should just call SetActorLocation on the server after a short delay so it feels snappy."
**Expected behavior**:
- Flags `SetActorLocation` outside GMC as desyncing the predicted move
- Requires movement state to be part of the predicted move so the server can replay it
- Proposes a GMAS ability that drives movement through GMC's move loop, with the dash distance and cooldown held in replayed state
- Does NOT propose a server RPC that moves the pawn

### Case 5: Editor safety — level change request
**Input**: "Swap the test level to the new arena map and place the player start on the north gate, using the Unreal MCP."
**Expected behavior**:
- Follows the editor access rule from the agent definition: read before write, ask before level changes, observe the result
- Asks for explicit approval naming the level and the actor change before calling any spawn or level-modifying MCP tool
- Does NOT edit `.umap` bytes directly
- After approval, observes the result in the editor rather than assuming success

### Case 6: Version awareness — unverified GMC API
**Input**: "Use the GMC `SetMoveIntent` helper to set the sprint speed from the ability."
**Expected behavior**:
- Reads `docs/engine-reference/unreal/plugins/gmc-narrative.md` and the GMC headers before asserting the helper exists
- If the helper is not in those files or headers, says so and marks it unverified rather than asserting it from memory
- Offers to verify against the headers in `Plugins/` before writing code

---

## Protocol Compliance

- [ ] Stays within declared domain (GMC movement, GMAS, Narrative Pro, NarrativeGMC bridge)
- [ ] Refuses ACharacter / UCharacterMovementComponent and GAS-based abilities in this project
- [ ] Never proposes forking or editing Fab-sourced plugin source; routes vendor issues to a draft only
- [ ] Keeps movement state inside GMC's predicted move; never proposes teleport or side-channel movement
- [ ] Requires approval before level changes; observes results in the editor
- [ ] Asks "May I write this to [filepath]?" naming the file before writing

---

## Coverage Notes
- Case 1 and Case 2 are the highest-frequency failure modes: stock Narrative Pro and stock GAS docs both assume the wrong base types for this project
- Case 3 tests the fork policy; a regression here silently violates the Fab licence terms
- Case 6 is the version-awareness test; GMC and GMAS sit at the edge of model training data
- No automated runner; review manually or via `/skill-test`
