# Unreal Engine 5.8 — GMCv2, GMAS, Narrative Pro and NarrativeGMC

**Last verified:** 2026-10-24 (installed engine Marketplace folders and the NarrativeGMC repo; 5.8 build of the stack **not yet done**)
**Status:** Project gameplay framework. Owner agent: `ue-gmc-specialist`.

> The project moved its pin to UE 5.8 on 2026-10-24 and is porting the
> NarrativeGMC bridge concurrently. Until the port lands, **5.7 is the only
> engine this stack has been built on**. The table below says which
> combinations are verified.

---

## The four pieces

| Layer | Vendor / source | Fork? | Notes |
|---|---|---|---|
| **GMCv2** — predicted, replicated movement on `APawn` | GRIMTEC, Fab (prebuilt binaries) | **Never** — Fab EULA | Installed for 5.7 and 5.8 (`Engine/Plugins/Marketplace/GMCv2Adv…`) |
| **GMAS** (GMCAbilitySystem) — abilities, attributes, effects on GMC's move loop | reznok/GMCAbilitySystem, source | Only if we must carry a patch upstream won't take | Source plugin in project `Plugins/`. Upstream 1.4.x (Oct 2026, unverified). **No 5.8 install yet.** |
| **Narrative Pro** — quests, dialogue, inventory, equipment, interaction | Narrative Tools, Fab | **Never** — Fab EULA | Installed for 5.7 and 5.8. Natively `ACharacter` + GAS; no official GMC support found (2026-10-24). |
| **NarrativeGMC** — our bridge | `andrewjonesdev/NarrativeGMC` | It is ours | Re-parents Narrative onto `AGMAS_Pawn`, ports GAS abilities to GMAS, vendors GMCExtended (Rooibot, MIT) and GMC-ALS patterns (Dixon6) |

Because nobody upstream bridges Narrative Pro onto GMC, **NarrativeGMC stays
necessary**. The fork question is only about GMAS, and the answer is "not unless
a patch forces it" — see `ue-gmc-specialist` → Forking Policy.

## Verified combinations

| Engine | GMCv2 | GMAS | Narrative Pro | NarrativeGMC | Status |
|---|---|---|---|---|---|
| 5.7 | 2.3.7 | 1.3 | 2.2.6+ | 0.1.0 (master, 2026-03-25) + WT-9561 audit fixes | Built (host project `NGMCHost`) |
| 5.8 | installed | not installed | installed (2.4/3.x — confirm) | port in progress (FLT-282) | **Unverified** |

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

- C++20 minimum — drop any `CppStandardVersion.Cpp17` in `.Build.cs` / `.Target.cs`
- Removed deprecated animation / Control Rig / Live Link symbols (GMC-ALS code is most exposed)
- PhysicsMover removed from Mover — irrelevant unless something pulled Mover in
- Narrative Pro 2.4 / 3.x API changes — diff the 5.8 install's headers against 5.7
- GMAS on 5.8 — build upstream first, then decide fork vs no fork
