# Unreal Engine 5.8 — UnrealSharp (C# scripting)

**Last verified:** 2026-10-24 (README, editor settings and launch-settings source on GitHub `main`; no hands-on build yet)
**Status:** Third-party, actively developed, **no tagged releases** — pin a commit
**Plugin:** `UnrealSharp` (github.com/UnrealSharp/UnrealSharp, MIT), installed into the project's `Plugins/`

> Everything below was read from upstream source and docs, not from a build in
> this project. Lines marked **unverified** need a hands-on check before an agent
> relies on them. Update `Last verified` when a build confirms them.

---

## Overview

UnrealSharp hosts .NET inside the Unreal Editor and runtime. C# classes become
real reflected `UClass`es: Blueprint can subclass them, call their functions and
read their properties, the same as a C++ class. It is the project's C# language
option (`engine.language: "C#"`), routed to `ue-csharp-specialist`.

| Fact | Value | Source |
|---|---|---|
| Engines | UE 5.6 – 5.8 | README |
| .NET | 10 (FAQ still says 9 — README wins) | README, FAQ |
| Platforms | Windows, macOS. Linux PR #734 open. No iOS/Android. | README, PR #734 |
| Project type | C++ project strongly recommended; Blueprint-only works but is harder to support | README |
| License | MIT | repo |
| Releases | None tagged. Commits land daily. | GitHub releases page |
| Packaging / shipping | reported by session WT-9561 (receipt not attached here): a spike built and packaged on UE 5.8 on DESKTOP-D249KD4 (2026-10-24) — unverified until its commit and log are recorded | — |

**Pinned commit:** not yet recorded. When UnrealSharp is added to a project, record the exact upstream SHA and date here and in the project's submodule; never track `main`.

## Where C# lives

- Solution: `<ProjectDir>/<ScriptDirName>/<ManagedProjectName>.sln` (classic `.sln`,
  not `.slnx`). `ScriptDirName` is a project setting. Source:
  `Source/UnrealSharpUtilities/Private/CSPathsUtilities.cpp`.
- The editor command "merge managed and native sln" writes `<Project>.Mixed.sln`
  holding the C++ and C# projects together.
- Never put C# under `Source/` or `Content/`.

## Hot reload

- Setting `UnrealSharp | Hot Reload`: `OnScriptSave` (default), on editor focus, or off.
  Source: `Source/UnrealSharpEditor/Public/CSUnrealSharpEditorSettings.h`.
- Driven by a directory watcher on the script folders
  (`HotReload/CSHotReloadSubsystem.cpp`). **It triggers on file save, not on an
  IDE build**, so every editor — Rider, Visual Studio, Cursor, Antigravity —
  gets the same hot reload.
- Static state does not survive a reload. Keep game state on `UObject`s.

## IDE integration

- "Open C# Solution" runs `cmd /c start "" "<sln>"` on Windows — the OS `.sln`
  file association picks the IDE, not the editor's Source Code Editor setting
  (`Managed/UnrealSharp/UnrealSharp.Editor/ManagedUnrealSharpEditorCallbacks.cs`;
  upstream issue #707).
- Each C# project gets `Properties/launchSettings.json` with `Development` and
  `Debug` profiles that launch `UnrealEditor.exe` (Debug: `UnrealEditor-Win64-DebugGame.exe`)
  with the `.uproject` path (`Build/Scripts/Utilities/LaunchSettingsUtilities.cs`).
  Rider and Visual Studio read that file; VS Code forks do not.
- Cursor / Antigravity setup: `docs/engine-reference/unreal/ide-cursor-antigravity.md`.

## Reflection attributes

**Unverified until checked against the installed plugin's managed assemblies.**
UnrealSharp marks reflected members with attributes (`UClass`, `UProperty`,
`UFunction`, `UStruct`, `UEnum`) and property/function flag enums. Before writing
a flag name, open the plugin's `Managed/UnrealSharp/UnrealSharp/Attributes/`
(or wherever the installed version keeps them) and copy the exact spelling, then
record it here.

## Known limits

- No Linux / mobile / console.
- Shipping builds unverified.
- Debugger attach from Cursor/Antigravity to the CoreCLR hosted inside
  `UnrealEditor.exe` is **unverified** (see the IDE doc).

## Sources

- https://github.com/UnrealSharp/UnrealSharp
- https://www.unrealsharp.com/
- Issue #707 (IDE selection), PR #734 (Linux)
