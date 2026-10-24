# Unreal Engine 5.8 — GMCv2, GMAS, Narrative Pro and NarrativeGMC

**Last verified:** 2026-10-24 (builds on DESKTOP-D249KD4)
**Status:** Project gameplay framework. Owner agent: `ue-gmc-specialist`.

> The project moved its pin to UE 5.8 on 2026-10-24. The NarrativeGMC bridge
> builds on both 5.7.4 and 5.8.3, pending merge of NarrativeGMC PR #1.
> The table below records the verified combinations.

---

## The four pieces

| Layer | Vendor / source | Fork? | Notes |
|---|---|---|---|
| **GMCv2** — predicted, replicated movement on `APawn` | GRIMTEC, Fab (prebuilt binaries) | **Never** — Fab EULA | Installed for 5.7 and 5.8 (`Engine/Plugins/Marketplace/GMCv2Adv…`) |
| **GMAS** (GMCAbilitySystem) — abilities, attributes, effects on GMC's move loop | reznok/GMCAbilitySystem, source | Only if we must carry a patch upstream won't take | Pinned to upstream tag v1.4.1; 5.7 and 5.8 build verified |
| **Narrative Pro** — quests, dialogue, inventory, equipment, interaction | Narrative Tools, Fab | **Never** — Fab EULA | Installed for 5.7 and 5.8. Natively `ACharacter` + GAS; no official GMC support found (2026-10-24). |
| **NarrativeGMC** — our bridge | `andrewjonesdev/NarrativeGMC` | It is ours | Re-parents Narrative onto `AGMAS_Pawn`, ports GAS abilities to GMAS, vendors GMCExtended (Rooibot, MIT) and GMC-ALS patterns (Dixon6) |

Because nobody upstream bridges Narrative Pro onto GMC, **NarrativeGMC stays
necessary**. The fork question is only about GMAS, and the answer is "not unless
a patch forces it" — see `ue-gmc-specialist` → Forking Policy.

## Verified combinations

| Engine | GMCv2 | GMAS | Narrative Pro | NarrativeGMC | Status |
|---|---|---|---|---|---|
| 5.7.4 | 2.3.7 | 1.4.1 (tag v1.4.1, 0e91584, unmodified) | 2.2.6 | PR #1 branch | Build Succeeded, 0 errors (DESKTOP-D249KD4) |
| 5.8.3 | 2.3.9 | 1.4.1 (same tag, unmodified) | 2.4.2 | PR #1 branch | Clean rebuild 150 actions, 0 errors, 132 s; `NarrativeGMCPlayerPawn` spawned with `NarrativeGMCPlayerController` under `-game -RenderOffScreen` (DESKTOP-D249KD4) |

Build receipts: session WT-d340, [NarrativeGMC PR #1](https://github.com/andrewjonesdev/NarrativeGMC/pull/1), branch `wt/WT-d340/FLT-282-ue58`; details in that repo's `docs/ue58-port.md`.

- GMAS 1.3 is no longer supported (1.4 removed `PreRemoteMoveExecution` and the legacy `ApplyAbilityEffect` overload).
- StructUtils is deprecated but still ships in 5.7 and 5.8; GMAS 1.4.1 builds against it unpatched. **No GMAS fork needed — pin the upstream tag.**
- 5.8 engine break hit: the 2-arg `UAnimSequence::ExtractRootMotionFromRange` was removed (use `FAnimExtractContext`); `FPoseSearchQueryTrajectory` is still only deprecated on 5.8.
- Narrative Pro (2.2.6 and 2.4.2): using `ANarrativeGameState` directly from C++ asserts in LoadMap (`GetActorGUID` not implemented) — use `ANarrativeGMCGameState`.
- Build host: DESKTOP-D249KD4, UE at `A:\Epic Games\`, VS2022 BuildTools 14.44, hidden via `tools/Build-NGMCHost.ps1`.

Status: verified pending merge of NarrativeGMC PR #1.

Update this table from build receipts only.

## Entry points

- Pawn: `ANarrativeGMCPlayerPawn` (players), NPC pawn in the same module
- Game mode: `ANarrativeGMCGameMode`
- Movement: `UGMC_OrganicMovementCmp` → `UGMCE_OrganicMovementCmp` → `UNarrativeGMCMovementComponent`
- Abilities: GMAS `UGMCAbility` subclasses in NarrativeGMC (base, combat, movement, weapon)
- Narrative components composed on the pawn: Inventory, Equipment, Interaction, Tales

Read the headers in `Plugins/NarrativeGMC/Source/` for exact names before use.

## Character art

Narrative Pro and GMC-ALS animations target the **UE5 Mannequin** skeleton. Art on
any other skeleton needs an IK Retargeter to UE5 Manny and an animation blueprint
for the NarrativeGMC pawn. Known case: the `ModularAnimalKnightsPolyart` pack is
rigged to the UE4 Mannequin skeleton — retarget with the engine's UE4→UE5
retargeter assets, then verify in-editor.

## 5.8 port checklist (tracked in FLT-282)

- [x] C++20 minimum — verified by the 5.8.3 clean rebuild (150 actions, 0 errors).
- [x] Animation port — replaced the removed 2-arg `UAnimSequence::ExtractRootMotionFromRange` with `FAnimExtractContext`; `FPoseSearchQueryTrajectory` remains deprecated on 5.8.
- PhysicsMover removed from Mover — irrelevant unless something pulled Mover in
- Narrative Pro 2.4 / 3.x API changes — diff the 5.8 install's headers against 5.7
- [x] GMAS on 5.8 — upstream tag v1.4.1 (0e91584) builds unmodified on 5.7.4 and 5.8.3, including its deprecated StructUtils dependency; no fork needed.
