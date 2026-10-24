# Cursor and Antigravity as the IDE for Unreal C++ and UnrealSharp C#

**Last verified:** 2026-10-24 — research only (UnrealSharp source, Cursor and
Antigravity docs, extension READMEs). **No hands-on setup has been run yet.**
Items marked unverified must be checked on a real project before this doc is
trusted; record the result here.

Goal: get from Cursor or Antigravity what Rider and Visual Studio 2022 get out of
the box with UnrealSharp — open the solution, IntelliSense, hot reload, F5
debugging — plus C++ navigation for the native side.

---

## What Rider / VS get natively, and the fork equivalent

| Capability | Rider / VS 2022 | Cursor / Antigravity |
|---|---|---|
| Open C# solution from the editor | "Open C# Solution" → OS `.sln` association | Same button works only if `.sln` is associated with the fork — or open the script folder directly (preferred; see step 4) |
| C# language service | Built in | **DotRush** (`nromanov.dotrush`, MIT, Open VSX) or **ReSharper for VS Code** (JetBrains). Microsoft **C# Dev Kit is licensed for Microsoft VS Code only** and refuses to run in forks. |
| Hot reload | File watcher on save | **Identical** — UnrealSharp reloads on save regardless of IDE |
| F5 debug | `Properties/launchSettings.json` profiles | Forks ignore `launchSettings.json`; use the `launch.json` template here. Microsoft `vsdbg` is licence-restricted to Microsoft products, so use DotRush's debugger or ReSharper's. **Attach to the CoreCLR hosted in `UnrealEditor.exe` is unverified.** |
| C++ navigation | Built in | **clangd** with `compile_commands.json` from UBT. Microsoft C/C++ extension is licence-restricted in forks. |
| Unreal MCP in the IDE's agent | — | `.cursor/mcp.json` / Antigravity `mcp_config.json` (see `mcp.md`) |

## Setup

Templates live in `.claude/docs/templates/unreal/vscode/`. Copy them into the
game project's `.vscode/` and fill the `<PLACEHOLDERS>`.

1. **.NET 10 SDK** installed and on PATH (`dotnet --list-sdks`).
2. **Extensions** (from Open VSX — Antigravity's default; Cursor's marketplace
   also carries them): `nromanov.dotrush`, `llvm-vs-code-extensions.vscode-clangd`.
   Optional: JetBrains ReSharper for VS Code (C# debugging added July 2026,
   targets Cursor; Antigravity support unverified). `extensions.json` in the
   template recommends these and lists C# Dev Kit / `ms-vscode.cpptools` as
   unwanted so the fork does not nag.
3. **Generate the C# solution** once from the editor (UnrealSharp generates it on
   first enable) — it lands at `<ProjectDir>/<ScriptDirName>/<ManagedProjectName>.sln`.
4. **Open the project root as a folder** in Cursor/Antigravity, not the `.sln`
   file. DotRush picks the solution up from `settings.json` →
   `dotrush.roslyn.projectOrSolutionFiles`.
   *Optional:* associate `.sln` with the fork so UnrealSharp's "Open C# Solution"
   button launches it (Windows: right-click a `.sln` → Open with → choose
   `Cursor.exe` / `Antigravity.exe` → Always). Unverified that a fork handles a
   bare `.sln` path well — opening the folder is the reliable route.
5. **C++ IntelliSense**: generate `compile_commands.json` with the task
   *UE: Generate clang database* (runs UBT `-mode=GenerateClangDatabase`), then
   clangd finds it at the project root. Regenerating project files wipes clangd
   settings in some setups; keep them in `.clangd`, not the workspace file.
6. **Debug C#**: start the editor (or let the launch config start it), then run
   *UnrealSharp: Attach to editor* (DotRush `coreclr` attach, process picker).
   **Unverified:** whether DotRush's debug engine can attach to CoreCLR loaded via
   hostfxr inside `UnrealEditor.exe`. If it fails, record the error here; the
   fallback is Rider or Visual Studio for debugging sessions only, with
   Cursor/Antigravity for editing — hot reload is unaffected either way.
7. **Debug C++**: the *UE: Launch editor (C++ native)* config uses the `cppvsdbg`
   type, which needs Microsoft's C/C++ extension and therefore will not run in a
   fork. Use CodeLLDB (`vadimcn.vscode-lldb`) with `type: lldb` instead, or attach
   from Visual Studio. Unverified on UE 5.8 PDBs.

## Hands-on verification checklist (run once, then update this doc)

- [ ] DotRush resolves UnrealSharp generated glue types (go-to-definition into `UnrealSharp` assemblies)
- [ ] Save a `.cs` file → editor hot-reloads (look at the Output Log)
- [ ] DotRush attach to `UnrealEditor.exe` hits a breakpoint in a C# `BeginPlay`
- [ ] clangd resolves `#include "GMCAbilityComponent.h"` from a plugin
- [ ] Same four in Antigravity

## Sources

- UnrealSharp: `ManagedUnrealSharpEditorCallbacks.cs`, `LaunchSettingsUtilities.cs`,
  `CSHotReloadSubsystem.cpp`, issue #707
- https://cursor.com/for/csharp (C# Dev Kit licence; DotRush / ReSharper recommendation)
- https://github.com/dotnet/vscode-csharp/issues/8816 (Dev Kit refusing in Antigravity)
- https://github.com/JaneySprings/DotRush
- https://blog.jetbrains.com/dotnet/2026/07/13/rs-vsc-debugging (read via search snippet only)
