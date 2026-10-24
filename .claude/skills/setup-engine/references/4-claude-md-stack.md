# /setup-engine — Section 4: Update CLAUDE.md Technology Stack

> Part of `/setup-engine`. `SKILL.md` names when to read this file; the settings it
> resolved and the rules under its later headings still apply here.

## 4. Update CLAUDE.md Technology Stack

### Language Selection (Godot only)

If Godot was chosen, ask the user which language to use **before** showing the proposed Technology Stack:

> "Godot supports two primary languages:
>
>   **A) GDScript** — Python-like, Godot-native, fastest iteration. Best for beginners, solo devs, and teams coming from Python or Lua.
>   **B) C#** — .NET 8+, familiar to Unity developers, stronger IDE tooling (Rider / Visual Studio), slight performance advantage on heavy logic.
>   **C) Both** — GDScript for gameplay/UI scripting, C# for performance-critical systems. Advanced setup — requires .NET SDK alongside Godot.
>
> Which will this project primarily use?"

Record the choice. It determines the CLAUDE.md template, naming conventions, specialist routing, and which agent is spawned for code files throughout the project.

### Primary Language (Unreal)

If Unreal was chosen, ask via `AskUserQuestion`: "Where will most gameplay logic
live?" — `[A] C++ (Blueprints for tuning and prototyping)` /
`[B] C# via UnrealSharp (C++ for engine-facing and per-frame code)` /
`[C] Blueprint-primary (C++ only where needed)`. Default to C++ if the user has no
preference. The answer sets `engine.language` (`"C++"`, `"C#"` or `"Blueprint"`).

For `[B]`, tell the user before recording it: UnrealSharp is a third-party MIT
plugin with no tagged releases, supports UE 5.6–5.8 on Windows and macOS only,
needs .NET 10 and a C++ project, and its shipping-build support is undocumented
(`docs/engine-reference/unreal/plugins/unrealsharp.md`). If the target platforms
include Linux, mobile or console, recommend `[A]` instead.

Then ask: "Which gameplay framework?" — `[1] Epic's Gameplay Ability System
(Character Movement Component + GAS)` / `[2] GMCv2 + GMAS + Narrative Pro (via the
NarrativeGMC bridge)`. `[2]` routes ability, movement and Narrative work to
`ue-gmc-specialist` instead of `ue-gas-specialist`
(`docs/engine-reference/unreal/plugins/gmc-narrative.md`).

---

Read `CLAUDE.md` and show the user the proposed Technology Stack changes.
Ask: "May I write these engine settings to `CLAUDE.md`?"

Wait for confirmation before making any edits.

Update the Technology Stack section, replacing the `[CHOOSE]` placeholders with the actual values:

**For Godot** — use the template matching the language chosen above. See `references/godot-language-config.md` (**A1**) for all three variants (GDScript, C#, Both).

**For Unity:**
```markdown
- **Engine**: Unity [version]
- **Language**: C#
- **Build System**: Unity Build Pipeline
- **Asset Pipeline**: Unity Asset Import Pipeline + Addressables
```

**For Unreal:**
```markdown
- **Engine**: Unreal Engine [version]
- **Language**: [C++ (primary), Blueprint (gameplay prototyping) | C# via UnrealSharp (gameplay), C++ (engine-facing), Blueprint (content) | Blueprint (primary), C++ where needed]
- **Build System**: Unreal Build Tool (UBT)
- **Asset Pipeline**: Unreal Content Pipeline
```
The Language line follows the primary-language answer above: the first form for
`[A]` (`engine.language: "C++"`), the second for `[B]` (`"C#"`), the third for
`[C]` (`"Blueprint"`). With framework `[2]`, add a line
`- **Gameplay Framework**: GMCv2 + GMAS + Narrative Pro (NarrativeGMC bridge)`.

### Engine reference import

In the same CLAUDE.md write, set the **Engine Version Reference** import to the
chosen engine. Find the line marked `ENGINE-REFERENCE-IMPORT` (an
`@docs/engine-reference/<engine>/VERSION.md` line under its comment) and Edit it
to point at the configured engine:
- Godot → `@docs/engine-reference/godot/VERSION.md`
- Unity → `@docs/engine-reference/unity/VERSION.md`
- Unreal → `@docs/engine-reference/unreal/VERSION.md`

This keeps a Unity or Unreal project from loading the Godot reference in every
session. It is idempotent — re-running `/setup-engine` for a different
engine rewrites the same line. (The target `docs/engine-reference/<engine>/`
directory is created in Section 7, Populate Engine Reference Docs, if it does not yet exist.)

---
