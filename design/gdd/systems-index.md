# Systems Index: Rogue Royale 3D

> **Status**: Draft
> **Created**: 2026-03-25
> **Last Updated**: 2026-03-25
> **Source Concept**: design/gdd/game-concept.md

---

## Overview

Rogue Royale 3D is a roguelike FPS with 31 identified systems spanning movement
physics, arena FPS combat, procedural world generation, hero-based character
design, and roguelike progression. The game's identity is built on three
bottleneck systems: **Hero Movement** (8 unique arena FPS physics implementations),
**FPS Combat Core** (hitscan-heavy arena gunplay), and **Procedural Arena**
(sector-based generation with Hyper Scape collapse). These must be designed and
prototyped first.

---

## Systems Enumeration

| # | System Name | Category | Priority | Status | Design Doc | Depends On |
|---|-------------|----------|----------|--------|------------|------------|
| 1 | Hero Movement System | Core | MVP | Not Started | — | Input System |
| 2 | FPS Combat Core | Core | MVP | Not Started | — | Input System, Camera System |
| 3 | Weapon System | Gameplay | MVP | Not Started | — | FPS Combat Core |
| 4 | Hero Ability System | Gameplay | MVP | Not Started | — | FPS Combat Core, Hero Movement |
| 5 | Perk Card System | Gameplay | MVP | Not Started | — | FPS Combat Core |
| 6 | Procedural Arena Generator | World | MVP | Not Started | — | — |
| 7 | Sector Collapse System | World | MVP | Not Started | — | Procedural Arena |
| 8 | Round Manager | Gameplay | MVP | Not Started | — | Sector Collapse, Enemy Wave Spawner |
| 9 | Loot Spawner | Gameplay | MVP | Not Started | — | Weapon System, Perk Cards, Procedural Arena |
| 10 | Enemy AI System | AI | MVP | Not Started | — | FPS Combat Core, Procedural Arena |
| 11 | Enemy Wave Spawner | AI | MVP | Not Started | — | Enemy AI, Enemy Type Database |
| 12 | Enemy Type Database | AI | MVP | Not Started | — | FPS Combat Core |
| 13 | Input System | Core | MVP | Not Started | — | — |
| 14 | Camera System | Core | MVP | Not Started | — | — |
| 15 | Run State Manager | Core | MVP | Not Started | — | Round Manager |
| 16 | HUD System (WebUI) | UI | MVP | Not Started | — | FPS Combat Core, Weapon System, Hero Ability |
| 17 | Weapon Fusion System | Gameplay | MVP | Not Started | — | Weapon System |
| 18 | Difficulty System | Gameplay | MVP | Not Started | — | Enemy Wave Spawner, Round Manager |
| 19 | Hero Selection System | UI | Vertical Slice | Not Started | — | Hero Movement, Hero Ability |
| 20 | Crown Mechanic | Gameplay | Vertical Slice | Not Started | — | Round Manager, Sector Collapse |
| 21 | Co-op Session System | Networking | Vertical Slice | Not Started | — | GMCv2 Networking |
| 22 | Co-op Gameplay | Networking | Vertical Slice | Not Started | — | Co-op Session, FPS Combat Core |
| 23 | Meta-Progression System | Progression | Vertical Slice | Not Started | — | Run State Manager |
| 24 | Challenge/Achievement System | Progression | Alpha | Not Started | — | Meta-Progression |
| 25 | Weapon Audio/VFX System | Presentation | Vertical Slice | Not Started | — | Weapon System |
| 26 | Game Feel / Juice System | Presentation | Vertical Slice | Not Started | — | FPS Combat Core |
| 27 | Menu System (WebUI) | UI | Vertical Slice | Not Started | — | Hero Selection |
| 28 | Between-Round UI | UI | MVP | Not Started | — | Round Manager, Perk Cards |
| 29 | Save/Load System | Persistence | Alpha | Not Started | — | Meta-Progression, NarrativePro |
| 30 | Narrative/Quest System | Persistence | Alpha | Not Started | — | NarrativePro TalesComponent |
| 31 | Movement Training System | Gameplay | Alpha | Not Started | — | Hero Movement |
| 32 | Scoring/Leaderboard System | Progression | Alpha | Not Started | — | Run State Manager |

---

## Categories

| Category | Count | Systems |
|----------|-------|---------|
| **Core** | 5 | Hero Movement, FPS Combat Core, Input, Camera, Run State |
| **Gameplay** | 9 | Weapons, Abilities, Perks, Rounds, Loot, Fusion, Crown, Difficulty, Training |
| **World** | 2 | Procedural Arena, Sector Collapse |
| **AI** | 3 | Enemy AI, Wave Spawner, Enemy Types |
| **UI** | 4 | HUD, Menu, Hero Select, Between-Round |
| **Networking** | 2 | Co-op Session, Co-op Gameplay |
| **Progression** | 3 | Meta-Progression, Challenges, Leaderboards |
| **Persistence** | 2 | Save/Load, Narrative/Quests |
| **Presentation** | 2 | Weapon Audio/VFX, Game Feel |

---

## Dependency Layers

### Layer 0 — Foundation (no dependencies)
- Input System
- Camera System
- Procedural Arena Generator

### Layer 1 — Core (depends on Foundation)
- **Hero Movement System** ← Input System
- **FPS Combat Core** ← Input System, Camera System
- Enemy Type Database ← (standalone data)

### Layer 2 — Gameplay Core (depends on Layer 1)
- Weapon System ← FPS Combat Core
- Hero Ability System ← FPS Combat Core, Hero Movement
- Perk Card System ← FPS Combat Core
- Enemy AI System ← FPS Combat Core, Procedural Arena
- Sector Collapse ← Procedural Arena

### Layer 3 — Gameplay Features (depends on Layer 2)
- Weapon Fusion ← Weapon System
- Loot Spawner ← Weapon System, Perk Cards, Procedural Arena
- Enemy Wave Spawner ← Enemy AI, Enemy Types
- Round Manager ← Sector Collapse, Enemy Wave Spawner

### Layer 4 — Session/Meta (depends on Layer 3)
- Run State Manager ← Round Manager
- Crown Mechanic ← Round Manager, Sector Collapse
- Between-Round UI ← Round Manager, Perk Cards
- HUD System ← FPS Combat, Weapons, Abilities
- Difficulty System ← Enemy Waves, Round Manager

### Layer 5 — Extended Features
- Hero Selection ← Hero Movement, Hero Ability
- Co-op Session ← GMCv2 Networking
- Co-op Gameplay ← Co-op Session, FPS Combat
- Meta-Progression ← Run State Manager
- Game Feel / Juice ← FPS Combat
- Weapon Audio/VFX ← Weapon System

### Layer 6 — Late Features
- Menu System ← Hero Selection
- Movement Training ← Hero Movement
- Challenges/Achievements ← Meta-Progression
- Save/Load ← Meta-Progression, NarrativePro
- Narrative/Quests ← NarrativePro TalesComponent
- Scoring/Leaderboards ← Run State Manager

---

## High-Risk Systems (Bottlenecks)

| System | Risk | Dependents | Mitigation |
|--------|------|-----------|-----------|
| **Hero Movement** | HIGH — 8 unique physics implementations | Hero Ability, Training, Hero Select | Prototype VQ3 strafe jump first. If it feels right, others follow the solver pattern. |
| **FPS Combat Core** | HIGH — 8 systems depend on it | Weapons, Abilities, Perks, Enemy AI, HUD, Game Feel | Get basic hitscan + health working ASAP. Iterate from there. |
| **Procedural Arena** | HIGH — 4 systems depend on it | Sector Collapse, Loot Spawner, Enemy AI | Start with hand-crafted sectors, add procedural variation. |
| **Enemy AI** | MEDIUM — sector-aware pathfinding | Wave Spawner | Use UE5 NavMesh with dynamic updates for collapsing sectors. |

---

## Recommended Design Order

Priority: Movement first, then Combat, then Arena. Each system gets a full GDD
via `/design-system` before implementation begins.

### MVP Design Sprint (Systems 1-18)
1. **Hero Movement System** — The game's identity. Design all 8 movement physics.
2. **FPS Combat Core** — Hitscan tracking, damage, health, death. The 30-second loop.
3. **Weapon System** — 21 weapons, fusion levels, round reset, scavenging rules.
4. **Procedural Arena Generator** — Sector-based generation from polyart assets.
5. **Sector Collapse System** — Hyper Scape dissolution, per-round collapse.
6. **Enemy Type Database** — 5+ enemy archetypes with stats and behaviors.
7. **Enemy AI System** — Pathfinding, target selection, sector awareness.
8. **Hero Ability System** — GMAS passive + tactical + ultimate per hero.
9. **Perk Card System** — Pickup buffs, stacking, per-run reset.
10. **Enemy Wave Spawner** — Wave composition, escalation, spawn points.
11. **Round Manager** — Round lifecycle, weapon reset, between-round phase.
12. **Loot Spawner** — Weapon/perk/ammo placement, sector-aware distribution.
13. **Weapon Fusion** — Duplicate pickup upgrades, fusion level persistence.
14. **Run State Manager** — Run lifecycle, scoring, death/restart.
15. **Input System** — Enhanced Input per hero, movement key binding.
16. **Camera System** — FPS camera, ADS, death cam.
17. **HUD System** — WebUI health/ammo/ability/perk/round display.
18. **Difficulty System** — Scaling parameters per difficulty tier.

### Vertical Slice Design Sprint (Systems 19-27)
19. Hero Selection System
20. Crown Mechanic
21. Co-op Session System
22. Co-op Gameplay
23. Meta-Progression System
24. Between-Round UI
25. Weapon Audio/VFX System
26. Game Feel / Juice System
27. Menu System

### Alpha Design Sprint (Systems 28-32)
28. Movement Training System
29. Challenge/Achievement System
30. Save/Load System
31. Narrative/Quest System
32. Scoring/Leaderboard System

---

## Progress Tracker

| Priority Tier | Total | Designed | In Progress | Not Started |
|--------------|-------|----------|-------------|-------------|
| MVP | 18 | 0 | 0 | 18 |
| Vertical Slice | 9 | 0 | 0 | 9 |
| Alpha | 5 | 0 | 0 | 5 |
| **Total** | **32** | **0** | **0** | **32** |

---

## Next Steps

1. Run `/design-system hero-movement` — Design the Hero Movement System (highest priority)
2. Run `/design-system fps-combat` — Design the FPS Combat Core
3. Run `/design-system weapons` — Design the Weapon System
4. Run `/prototype movement-vq3` — Prototype VQ3 strafe jumping with Soldier
