# Technical Preferences

<!-- project.yaml at the repo root is the machine-readable source of truth for
     engine, specialists, naming, performance, platform, and testing.framework.
     This file is the human-readable LEGACY FALLBACK: agents and skills resolve
     each key from project.yaml first and fall back here only when the
     project.yaml key is absent. /setup-engine dual-writes both.
     Forbidden patterns and allowed libraries are NOT migrated — they live only
     in this file. Populated by /setup-engine; updated as decisions are made. -->

## Engine & Language

- **Engine**: Unreal Engine 5.7
- **Language**: C++ (systems/engine), Blueprint (gameplay/prototyping), HTML/CSS/JS (UI via WebUI plugin)
- **Rendering**: Lumen GI, Nanite, Virtual Shadow Maps (UE 5.7 defaults)
- **Physics**: Chaos Physics (UE 5.7 default)

## Plugin Stack

- **GMCv2** v2.3.7 (GRIMTEC) — Advanced replicated movement framework
- **GMCAbilitySystem** v1.3 (reznok) — Ability/effect/attribute system built on GMC
- **NarrativePro** (Narrative Tools) — Quest, dialogue, NPC, faction, inventory systems
- **WebUI** — Web-based UI rendering (HTML/CSS/JS in-engine via Chromium)
- **JsonLibrary** — JSON parsing/creation for Blueprint ↔ WebUI communication
- **BpGeneratorUltimate** — Blueprint Copilot MCP bridge

## Input & Platform

<!-- Written by /setup-engine. Read by /ux-design, /ux-review, /test-setup, /team-ui, and /dev-story -->
<!-- to scope interaction specs, test helpers, and implementation to the correct input methods. -->

- **Target Platforms**: [TO BE CONFIGURED — e.g., PC, Console, Mobile, Web]
- **Input Methods**: [TO BE CONFIGURED — e.g., Keyboard/Mouse, Gamepad, Touch, Mixed]
- **Primary Input**: [TO BE CONFIGURED — the dominant input for this game]
- **Gamepad Support**: [TO BE CONFIGURED — Full / Partial / None]
- **Touch Support**: [TO BE CONFIGURED — Full / Partial / None]
- **Platform Notes**: [TO BE CONFIGURED — any platform-specific UX constraints]

## Naming Conventions

- **C++ Classes**: Prefixed PascalCase (`A` = Actor, `U` = UObject, `F` = struct, `E` = enum)
- **Variables**: PascalCase (e.g., `MoveSpeed`, `MaxHealth`)
- **Booleans**: `b` prefix (e.g., `bIsAlive`, `bCanSprint`)
- **Functions**: PascalCase (e.g., `TakeDamage()`, `GetMoveSpeed()`)
- **Files**: Match class without prefix (e.g., `PlayerController.h/.cpp`)
- **Blueprints**: `BP_` prefix (e.g., `BP_PlayerCharacter`)
- **Widget Blueprints**: `WBP_` prefix (e.g., `WBP_MainHUD`)
- **Data Assets**: `DA_` prefix (e.g., `DA_WeaponStats`)
- **Enums**: `E_` prefix (e.g., `E_WeaponType`)
- **Structs**: `S_` or `F` prefix (e.g., `FWeaponData`)
- **Materials**: `M_` prefix (e.g., `M_Character_Base`)
- **Material Instances**: `MI_` prefix (e.g., `MI_Character_Red`)
- **Textures**: `T_` prefix (e.g., `T_Character_Diffuse`)
- **Gameplay Tags**: Dot-separated hierarchy (e.g., `Ability.Sprint`, `Attribute.Health`)
- **Constants**: UPPER_SNAKE_CASE or static constexpr

## Performance Budgets

- **Target Framerate**: [TO BE CONFIGURED — typical: 60fps for gameplay, 30fps minimum]
- **Frame Budget**: [TO BE CONFIGURED — 16.6ms at 60fps]
- **Draw Calls**: [TO BE CONFIGURED — depends on target platform]
- **Memory Ceiling**: [TO BE CONFIGURED — depends on target platform]

## Testing

- **Framework**: Unreal Automation Framework (C++ functional tests + Blueprint tests)
- **Minimum Coverage**: [TO BE CONFIGURED]
- **Required Tests**: Balance formulas, gameplay systems, ability effects, weapon stats

## Forbidden Patterns

<!-- Add patterns that should never appear in this project's codebase -->
- Direct UMG widget creation for game UI (use WebUI instead)
- Hardcoded gameplay values (use Data Assets or config)
- Tick-heavy logic without profiling justification
- Raw `UGameplayStatics::GetAllActorsOfClass` in hot paths

## Allowed Libraries / Addons

- GMCv2 v2.3.7 (movement framework)
- GMCAbilitySystem v1.3 (ability system)
- NarrativePro (quest/dialogue)
- WebUI (web-based UI)
- JsonLibrary (JSON for Blueprint)
- BpGeneratorUltimate (MCP Blueprint tooling)
- Fab/Marketplace asset packs (approved per-pack basis)

## Architecture Decisions Log

<!-- Quick reference linking to full ADRs in docs/architecture/ -->
- ADR-001: WebUI for game UI instead of UMG (rationale: web tech flexibility, easier iteration)
- ADR-002: GMC for movement instead of CMC (rationale: advanced replication, prediction)
- ADR-003: GMAS for abilities instead of GAS (rationale: native GMC integration, client prediction)
- [Use /architecture-decision to create formal ADRs]

## Engine Specialists

<!-- Written by /setup-engine when engine is configured. -->
<!-- Read by /code-review, /architecture-decision, /architecture-review, and team skills -->
<!-- to know which specialist to spawn for engine-specific validation. -->

- **Primary**: [TO BE CONFIGURED — run /setup-engine]
- **Language/Code Specialist**: [TO BE CONFIGURED]
- **Shader Specialist**: [TO BE CONFIGURED]
- **UI Specialist**: [TO BE CONFIGURED]
- **Additional Specialists**: [TO BE CONFIGURED]
- **Routing Notes**: [TO BE CONFIGURED]

### File Extension Routing

<!-- Skills use this table to select the right specialist per file type. -->
<!-- If a row says [TO BE CONFIGURED], fall back to Primary for that file type. -->

| File Extension / Type | Specialist to Spawn |
|-----------------------|---------------------|
| Game code (primary language) | [TO BE CONFIGURED] |
| Shader / material files | [TO BE CONFIGURED] |
| UI / screen files | [TO BE CONFIGURED] |
| Scene / prefab / level files | [TO BE CONFIGURED] |
| Native extension / plugin files | [TO BE CONFIGURED] |
| General architecture review | Primary |
