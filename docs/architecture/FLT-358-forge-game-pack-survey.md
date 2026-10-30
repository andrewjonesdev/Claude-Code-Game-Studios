# FLT-358: Forge Game pack survey and implementation plan

Draft by Cedric Jones-Gaffney, 2026-10-30. Clahadore reviews this draft before the cross-family council chaired by the Forge lane, WT-3796. This document proposes work; it records no new gaming-PC execution results or council approval.

## 1. Summary and recommendation

Build the first engine adapter on **Epic's UE 5.8 Unreal MCP plugin**, identifier `ModelContextProtocol`, after a live smoke test on the gaming PC. Keep the Forge host, pack loader, dependency policy, security policy and UAT machinery shared with the other packs. CCGS supplies Game pack content and Unreal-specific adapters. Forge remains one C# product.

Epic's [official 5.8 MCP documentation](https://dev.epicgames.com/documentation/unreal-engine/unreal-mcp-in-unreal-editor?application_version=5.8) confirms an Experimental local HTTP integration, extensible toolsets and serialized game-thread execution. This gives Forge a protocol boundary independent of the user's IDE. Enable only the toolsets needed for the probe; discover actual tools before selecting operations. A custom IDE fork is unnecessary for this first slice.

Use UnrealSharp as the gameplay-language adapter inside the Game pack. Use C++ for engine-facing extensions and C#/.NET 10 for Forge tooling and gameplay. The fixed gameplay stack is GMCv2 + GMAS + Narrative Pro; do not substitute GAS. Keep BpGenerator as an optional Blueprint capability provider where a measured Epic-tool gap warrants it. Rider and Visual Studio remain possible debugging tools. Workspace generation supports VS Code, Cursor and Antigravity without making any one IDE the control plane.

The engine boundary is per-engine. Implement only Unreal now. Unity is far-future work.

### Evidence boundary

Read before drafting:

- [VERSION.md](../engine-reference/unreal/VERSION.md): target UE 5.8.3; installed hotfix still needs recording from the actual installation.
- [mcp.md](../engine-reference/unreal/mcp.md): installed-source inspection dated 2026-10-24; Epic live connection absent; BpGenerator `get_focused_content_browser_path` reportedly returned `/Game/` in Claude Desktop that day.
- [unrealsharp.md](../engine-reference/unreal/plugins/unrealsharp.md): source-derived behavior; its unattributed packaging report is explicitly unverified.
- [ide-cursor-antigravity.md](../engine-reference/unreal/ide-cursor-antigravity.md): research and templates, with no hands-on IDE/debugger verification.

Gaming-PC plugin inventory, Clahadore, 2026-10-30 (`mcpprobe.ps1` over SSH, read-only; raw output on [FLT-358](https://workwingman.atlassian.net/browse/FLT-358) comment 11492):

- `A:\Epic Games\UE_5.8` reports `version 5.8.3 CL 58210709`.
- `ModelContextProtocol` is present at `Engine\Plugins\Experimental\` with `exp=True`, `default=False`.
- `MCPClientToolset` is present with `beta=True`, `exp=True`.
- The RogueRoyale uproject has `ModelContextProtocol`, `UnrealSharp` and `BpGeneratorUltimate` enabled.

This inventory proves presence and enablement only. A live handshake and tool call remain Phase 0.2.

Task-supplied gaming-PC probe: **UnrealSharp `cb8577e3` builds on UE 5.8; Win64 + Mac only; NO cooked/packaged-build evidence; hot reload UNVERIFIED.** Preserve that boundary. Editor compilation does not establish cooking, deployment or runtime behavior. The short commit must be resolved to its full SHA in a receipt.

Public sources below were inspected for this draft. Moving `main` branches establish source availability, not compatibility of a selected binary. No UE/game execution was performed here. Core contract schemas were not found in CCGS; reads of FLT-347/351/350/354 through the Jira connector returned `UNAUTHORIZED` / reauthentication required. Their purposes below follow the task brief; concrete schema/API compatibility remains **UNVERIFIED** until WT-3796 supplies the producer contracts.

## 2. Candidate survey

“Fork allowed” describes the identified source license, subject to its conditions and dependency licenses. “Study-only” is this plan's reuse boundary where portable reuse rights are absent or unverified; it does not prohibit using an installed, licensed tool. No row authorizes bundling vendor binaries or Engine Tools into a public pack.

| Candidate | License, exact SPDX where known | Fork allowed vs study-only, and why | Integration surface / APIs | UE 5.8 status | UnrealSharp hooks | Source URL |
| --- | --- | --- | --- | --- | --- | --- |
| Epic UE 5.8 MCP Server plugin | Proprietary Unreal Engine EULA; no SPDX asserted. Check installed plugin/third-party notices. [EULA](https://www.unrealengine.com/eula/unreal). | **Restricted internal modification under the EULA; study-only for copying into generally distributed Forge code.** Engine-source access is not a permissive license; distribution has licensee/channel restrictions. Prefer a separately written client. | Streamable HTTP MCP, default local `/mcp` on port 8000; Toolset Registry. Installed-source details in [mcp.md](../engine-reference/unreal/mcp.md). | Official 5.8 docs confirm Experimental plugin. Local source inspected; live 5.8.3 handshake/tool coverage **UNVERIFIED**. | No dedicated UnrealSharp toolset verified. Reflected-object access may help, but managed compilation/reload/debugging hooks are **UNVERIFIED**. | [Epic MCP docs](https://dev.epicgames.com/documentation/unreal-engine/unreal-mcp-in-unreal-editor?application_version=5.8) |
| JetBrains UnrealLink / RiderLink | Repository: **Apache-2.0**, [License.txt](https://github.com/JetBrains/UnrealLink/blob/main/License.txt). Rider product/SDK and bundled dependencies have separate terms. | **Fork allowed for covered repository code** with notices, change notices and applicable attribution. No right inferred to fork Rider itself. Keep as a reference/optional IDE bridge; avoid a second primary editor protocol. | Rider-side UnrealLink + editor-side RiderLink; generated Kotlin/C#/C++ protocol models and IDE APIs. Exact externally supported automation contract **UNVERIFIED**; do not assume MCP parity. | UE integration documented; exact Rider/RiderLink version building and operating with 5.8.3 **UNVERIFIED**. | General C# IDE support is distinct from UnrealLink. Generated solution/launch profiles are potential entry points; hosted-CoreCLR attach and UnrealSharp-specific bridge support **UNVERIFIED**. | [Repository](https://github.com/JetBrains/UnrealLink), [protocol generation](https://github.com/JetBrains/UnrealLink/blob/main/build.gradle.kts), [Rider docs](https://www.jetbrains.com/help/rider/Unreal_Engine__UnrealLink_RiderLink.html) |
| VS Code Unreal workflow: UBT `.code-workspace`, clangd / C/C++ extension | Code OSS: **MIT**, [license](https://github.com/microsoft/vscode/blob/main/LICENSE.txt); Microsoft VS Code binary: [product terms](https://code.visualstudio.com/license). clangd: **Apache-2.0 WITH LLVM-exception**, [LLVM license](https://github.com/llvm/llvm-project/blob/main/LICENSE.TXT); vscode-clangd extension: **MIT**, [license](https://github.com/clangd/vscode-clangd/blob/master/LICENSE). Microsoft C/C++ runtime: proprietary [terms](https://github.com/microsoft/vscode-cpptools/blob/main/RuntimeLicenses/cpptools-srv-LICENSE.txt). UBT is covered by the [UE EULA](https://www.unrealengine.com/eula/unreal). | **Fork allowed for identified OSS components; study-only for proprietary product/runtime code and portable reuse of UBT source.** Generate our own config around the installed UBT. Microsoft extension binaries are not made permissive by an OSS repository. | UBT-generated workspace/build tasks; compilation database to clangd/LSP; debugger adapters separately. These provide code tooling, not editor asset control. | Epic's 5.8 workspace workflow documented; project-specific generated workspace, plugin includes and debugger behavior **UNVERIFIED** on gaming PC. | UnrealSharp solution location + managed language service + separate attach configuration. DotRush/fork debugger support needs a breakpoint receipt; C++ workspace generation alone provides no C# runtime integration. | [Epic VS Code setup](https://dev.epicgames.com/documentation/unreal-engine/setting-up-visual-studio-code-for-unreal-engine?application_version=5.8), [local IDE study](../engine-reference/unreal/ide-cursor-antigravity.md) |
| Visual Studio Integration Tool (Epic/Fab distribution) / VS Unreal Engine integration | Microsoft `vc-ue-extensions` source: **MIT**, [LICENSE](https://github.com/microsoft/vc-ue-extensions/blob/main/LICENSE). Visual Studio product terms separate; exact installed product license **UNVERIFIED**. Fab listing's license field is blank; do not apply MIT to arbitrary downloaded artifacts. | **Fork allowed for identified MIT plugin source** with notices. **Study-only for VS product internals and unverified marketplace artifacts.** Listing is by Microsoft Corp, despite delivery through Epic's marketplace. | `VisualStudioTools` editor plugin + VS Unreal tooling/test adapter/Blueprint debugging. Native tests, logs, macro expansion, Blueprint references; no MCP contract verified. | Microsoft documents UE 4.27/5.0+ generally; exact 5.8.3 plugin build/test integration **UNVERIFIED**. Listing now directs installation through VS configuration instead of requiring the old marketplace plugin. | Generated `.sln` and launch profiles are useful. UnrealSharp-specific debug/refresh automation and managed breakpoint reliability **UNVERIFIED**. | [Microsoft source](https://github.com/microsoft/vc-ue-extensions), [installation](https://learn.microsoft.com/en-us/visualstudio/gamedev/unreal/get-started/vs-tools-unreal-install), [Fab listing](https://www.fab.com/listings/8a639215-7f85-4cc7-b155-fa2137326209) |
| UnrealSharp's own editor/IDE tooling | **MIT**, [LICENSE](https://github.com/UnrealSharp/UnrealSharp/blob/main/LICENSE); snapshot the selected pin's license before importing. UE-facing distribution also needs EULA assessment. | **Fork allowed for MIT-covered code** with notices. Prefer a pinned dependency and a small internal patch set. Reuse its generation/reload pipeline rather than creating a competing binding generator. | Reflected C++ → generated C# bindings; editor callbacks; script watcher; managed solution/launch-profile generation. Exact callable APIs must be inspected at the selected pin. | Upstream advertises UE 5.6–5.8/.NET 10. Task probe says `cb8577e3` builds on 5.8. Win64/Mac only. Cooked builds and live hot reload **UNVERIFIED**. | Direct native/managed boundary. Source-derived paths and save-triggered reload described in the local reference; outcomes require the checks in section 4. | [Repository](https://github.com/UnrealSharp/UnrealSharp), [project docs](https://www.unrealsharp.com/), [local study](../engine-reference/unreal/plugins/unrealsharp.md) |
| BpGenerator Ultimate MCP, already `unreal-blueprints` | Commercial Fab asset/extension; exact acquired license and SPDX **UNVERIFIED**. [Listing](https://www.fab.com/listings/8d776721-5da3-44ce-b7ef-be17a023be59) has no readable specific license terms; [Fab Standard summary](https://www.fab.com/eula) is not proof of this purchase's terms. | **Study-only for Forge source reuse pending entitlement evidence.** No public fork/redistribution grant verified. Use the installed provider only if entitlement permits; never vendor its Python bridge or asset source by assumption. | Installed version: stdio FastMCP Python bridge → raw TCP localhost:9877, per local source inspection. Blueprint/asset commands; feasibility check precedes generation. | Local reference records installation for 5.5–5.8 and one live read call. Exact installed version, 5.8.3 mutation coverage and current listing/installed-version equivalence **UNVERIFIED**. | No C# bindings/reload/debugger contract verified. Blueprint interoperability with managed reflected types needs a separate probe. | [Vendor listing, now named Ultimate Engine CoPilot](https://www.fab.com/listings/8d776721-5da3-44ce-b7ef-be17a023be59), [installed bridge study](../engine-reference/unreal/mcp.md) |

The BpGenerator listing currently also displays “Allows usage with AI: No” alongside MCP-oriented product descriptions. Record the acquired asset's actual terms and meaning of that metadata before enabling this optional provider in a distributed pack. This draft makes no legal inference from the field.

For Cursor/Antigravity, prefer clangd and a separately verified managed debugger. The Microsoft C/C++ runtime [restricts use to listed Microsoft products](https://github.com/microsoft/vscode-cpptools/blob/main/RuntimeLicenses/cpptools-srv-LICENSE.txt); the local IDE study also flags C# Dev Kit/vsdbg restrictions. Never copy a Microsoft-only debugger configuration into fork templates and label it supported without checking its license and attach behavior.

## 3. Pack architecture

### Ownership and content

Forge core owns scheduling, run identity, dependency decisions, authorization, evidence storage, UAT evaluation and review routing. The Game pack registers content and adapters against those contracts. It does not implement parallel copies of core services.

| CCGS source | Proposed pack use | Import check |
| --- | --- | --- |
| `.claude/agents/unreal-specialist.md`, `ue-csharp-specialist.md`, `ue-blueprint-specialist.md`, `ue-gmc-specialist.md`, `ue-replication-specialist.md` | Unreal capability/routing content; translate harness-specific tool declarations. | Every declared operation resolves to an installed provider and an explicit policy capability; absent tools stay unavailable. |
| `.claude/agents/{qa-lead,qa-tester,security-engineer,release-manager}.md` | Game-specific QA/security/release responsibilities. | Reconcile with core roles; importing content cannot bypass core decisions. |
| `.claude/skills/{setup-engine,gate-check,smoke-check,test-evidence-review,regression-suite,perf-profile,playtest-report,release-checklist}/SKILL.md` | Versioned pack workflows with executable checks. | Inventory dependencies and translate Bash/Claude runtime behavior into C# host operations. |
| `.claude/skills/gate-check/references/gate-*.md`, `.claude/docs/director-gates/` | Game lifecycle criteria: systems design through release. | Each criterion maps to an observation/evidence requirement; helpers emit observations, never verdicts. |
| Root `project.yaml`; `.claude/docs/templates/unreal/` and its `vscode/` directory | Derive versioned Game templates and opt-in client/workspace recipes. | Validate against the actual Forge schema; retain sparse rigor configuration and local overrides. |

Existing `project.yaml` is the CCGS template source, not evidence that Forge accepts its schema. Do not seed `modes.review_mode`, `modes.workflow`, `modes.story_granularity`, `docs.density`, `qa.level` or `team.size` when deriving a rigor-led template: these explicit settings shadow rigor defaults. No secrets in project YAML. Keep machine paths and opt-in connection settings local. Review pack-content provenance and redistribution rights separately from the surveyed vendor licenses.

### Adapters inside the pack

- **UnrealEngineAdapter (C#):** discovers installation/project identity, normalizes capabilities and delegates approved operations to providers. It sends work only to the gaming-PC executor; Forge UI/orchestration may live elsewhere.
- **EpicMcpProvider (C#):** uses the [official MCP C# SDK](https://github.com/modelcontextprotocol/csharp-sdk) or the shared core client if one exists. Handles negotiated transport, discovery and observations. Pin the dependency. Connect on gaming-PC loopback, with bounded timeouts and explicit session lifetime.
- **UnrealBuildProvider (C#):** launches installed UBT/UAT tools with argument arrays, workspace-bound paths, hidden child processes, captured logs and exit codes. Build/cook is a process job, independent of IDE choice.
- **UnrealSharpAdapter (C#):** discovers the pinned plugin and generated projects, invokes its existing pipeline, measures reload and verifies packaged runtime behavior. Add minimal C++ reflected wrappers only where measured engine/plugin API gaps require them.
- **Workspace/debug adapters (C#):** generate local IDE recipes and record attach capabilities. No mandatory Rider/VS runtime dependency. **BpGeneratorProvider** is optional and remains disabled until license and security checks pass; its installed Python vendor bridge is an external dependency, not new Forge Python tooling.

### Engine-adapter interface sketch

Proposed signatures only; these are **not existing Forge APIs**. All parameter/result types below are placeholders to bind to WT-3796's actual contracts. An `AuthorizedOperation` must be issued/validated by core policy; it is never an unchecked caller-supplied approval flag.

```csharp
public interface IEngineAdapter
{
    string EngineId { get; }
    ValueTask<EngineProbe> ProbeAsync(ProjectContext project, CancellationToken ct);
    ValueTask<CapabilityCatalog> DiscoverAsync(EngineSession session, CancellationToken ct);
    ValueTask<OperationObservation> ExecuteAsync(
        EngineSession session, AuthorizedOperation operation, CancellationToken ct);
    ValueTask<BuildObservation> BuildAsync(
        EngineSession session, AuthorizedBuild request, CancellationToken ct);
    ValueTask<UatObservation> RunUatAsync(
        EngineSession session, AuthorizedUat request, CancellationToken ct);
    ValueTask<SurfaceEvidence> CaptureSurfaceAsync(
        EngineSession session, SurfaceCaptureRequest request, CancellationToken ct);
    ValueTask CloseAsync(EngineSession session, CancellationToken ct);
}

public interface IGameplayLanguageAdapter
{
    string LanguageId { get; }
    ValueTask<BindingObservation> GenerateBindingsAsync(
        EngineSession session, AuthorizedBindingRequest request, CancellationToken ct);
    ValueTask<ReloadObservation> CheckReloadAsync(
        EngineSession session, AuthorizedReloadProbe request, CancellationToken ct);
    ValueTask<RuntimeObservation> CheckPackagedRuntimeAsync(
        EngineSession session, AuthorizedRuntimeProbe request, CancellationToken ct);
}
```

`ProjectContext` identifies an authorized workspace and target machine. `EngineSession` pins project, editor PID, engine build and provider/schema versions. A capability describes provider, input schema, effects and availability. Unsupported capabilities return an explicit unavailable observation. No fabricated success or implicit provider fallback.

Serialize editor operations per session. Schema changes invalidate prior capability authorization. Treat tool output as untrusted data, not instructions. A timed-out mutation has an unknown outcome until state is inspected; do not blindly retry. On cancellation, record child-process/editor state and cleanup outcome. Evidence capture must also obey path/data policy.

### Shared-core contract use

The mappings are proposed obligations, not claims about field names or already shipped APIs.

| Shared contract | Game pack use | Executable acceptance check / done-state |
| --- | --- | --- |
| [FLT-347 run record](https://workwingman.atlassian.net/browse/FLT-347) | Associate discovery, approval, editor calls, builds, cook/runtime and UAT evidence with one core run. Include project/source identity, engine/plugin pins, gaming-PC identity, command/tool inputs, UTC timing, exits/errors, raw-output references and artifact hashes through supported fields/extensions. | Validate a complete probe run with the producer's validator. Reject missing/stale/mismatched evidence; pin a verbatim producer payload and assert the obsolete/wrong shape is absent. Done: a reviewer can trace an outcome to its actual producer. |
| [FLT-351 dependency gate](https://workwingman.atlassian.net/browse/FLT-351) | Check engine build, .NET SDK, toolchain, plugin pins, entitlements and required receipt dependencies before scheduling affected work. A .NET10 installation alone does not prove an acceptable patch; inspect the pinned plugin's requirements. | Run positive and missing/wrong-version cases through the real gate. Done: supported profile schedules on gaming PC; missing cook/reload evidence blocks the corresponding support claim; unavailable dependencies fail closed without improvising substitutions. |
| [FLT-350 security packs](https://workwingman.atlassian.net/browse/FLT-350) | Supply Unreal MCP, build-process and optional BpGenerator policy profiles to core enforcement. Scope tools, paths, effects, binaries and session lifetime. Transport discovery is not authorization. | Deny an unapproved tool, changed schema, outside-workspace path and exposed listener in isolated fixtures. Done: denials and cleanup enter the run record; no rejected action reaches the editor/process launcher. |
| [FLT-354 UAT](https://workwingman.atlassian.net/browse/FLT-354) | Register an **Unreal surface** through the core UAT extension mechanism: editor/PIE/packaged mode, level/object identity, actual interactions, expected observations, screenshots/video, logs and runtime provenance. Core evaluates results. | Run one real positive scenario and a deliberately failing expectation on gaming PC. Done: UAT detects the failure, identifies the tested revision/surface and requires interaction evidence; a compile-only result cannot satisfy it. |

**Provisional contract fields.** The Forge lane (WT-3796) sent these on 2026-10-30. All four tickets were filed that day and are **unbuilt**, so no producer payload exists yet. The fields below come from the ticket text. Every mapping in the table above is **PROVISIONAL-UNTIL-<ticket>**. Per the contract-test rule, no test fixtures are written from these fields: a consumer-invented payload would encode our own assumption. The first verbatim producer payload replaces each row.

| Contract | Provisional fields (ticket text) | Game pack mapping | Status |
| --- | --- | --- | --- |
| FLT-347 run record | `commitSha`, `planHash`, `policyVersion`, `toolchain`, `artifactDigest`, `attemptId` (fencing), `leaseHeartbeat` | `toolchain` carries the engine `Build.version`, full UnrealSharp SHA, .NET SDK and plugin pins. `artifactDigest` carries the build or archive hash. `attemptId` fences a single editor session; a stale attempt never writes. `leaseHeartbeat` follows long cook/UAT jobs. | PROVISIONAL-UNTIL-FLT-347 |
| FLT-351 dependency identity | `(ecosystem, normalizedName, version, sourceRegistry)`, plus `integrity`/`sourceUrl` on the resolved lockfile | Ecosystems in use: NuGet for UnrealSharp's managed deps; Fab or engine plugins (GMCv2, Narrative Pro, BpGenerator, WebUI) as a named ecosystem whose identity is the descriptor version plus archive hash; git-pinned sources (UnrealSharp, GMAS, NarrativeGMC) by full SHA. How Fab and engine plugins map to `sourceRegistry` is an open question for FLT-351. | PROVISIONAL-UNTIL-FLT-351 |
| FLT-350 security packs | Hashed required-control set per SecTier1/2/3, plus `waiver{approver, reason, scope, expiresUtc ≤ 24h}` | Proposed tiers: an MCP read-only session is SecTier1, editor mutation or build is SecTier2, and the no-auth listener or BpGenerator provider is SecTier3. A waiver never enables a provider that fails its licence check. | PROVISIONAL-UNTIL-FLT-350 |
| FLT-354 UAT row | `{milestone, checklistHash, sha, signer, perItemResult, screenshotHash}`; Unreal surface = packaged smoke artifact plus frame-time and leak checks | The Unreal surface row comes from the section 4 packaged-runtime check: archive hash, runtime log, frame-time budget result and leak check. `screenshotHash` covers the retained evidence image. Editor or PIE evidence cannot satisfy the packaged surface. | PROVISIONAL-UNTIL-FLT-354 |

Do not create permanent pack-owned versions of these schemas while their producer contracts are unavailable. Phase 1 must settle extension points and validators with the Forge lane.

## 4. UnrealSharp native support plan

### Reproducible probe environment

All UE/game checks run on the **gaming PC** against a disposable C++ probe project in an authorized worktree. Pin UE 5.8.3, UnrealSharp `cb8577e3` resolved to full SHA, .NET 10 SDK patch and the GMCv2/GMAS/Narrative Pro versions actually installed. Begin with a minimal project, then repeat against the full stack so integration failures have a baseline.

Every receipt contains machine identity, UTC, source tree, exact command or interaction sequence, engine `Build.version`, plugin descriptors/full SHAs, SDK/tool versions, exit codes, relevant raw logs and artifact hashes. Record failure as failure. Future implementation must launch builds/tests detached and hidden, with node reuse disabled and the standing .NET headless environment intact. An editor or game GUI appears only during an active usage pass.

The following are command payloads for that hidden executor, **not commands run for this draft**. Resolve and validate variables from the gaming-PC installation; `GamePackProbe` is a proposed fixture name. Treat missing entry points/options as probe failures requiring source inspection, not as permission to guess.

```powershell
# Read-only identity preflight; run on gaming PC.
Get-Content "$EngineRoot/Engine/Build/Build.version"
dotnet --list-sdks
git -C "$ProbeRoot/Plugins/UnrealSharp" rev-parse HEAD

# Native/editor build, then the generated managed solution discovered on disk.
& "$EngineRoot/Engine/Build/BatchFiles/Build.bat" `
    GamePackProbeEditor Win64 Development "-Project=$ProjectFile" -WaitMutex
dotnet build "$ManagedSolution" -c Debug

# Cook/package baseline; retain UAT exit code and full stdout/stderr.
& "$EngineRoot/Engine/Build/BatchFiles/RunUAT.bat" BuildCookRun `
    "-project=$ProjectFile" -noP4 -platform=Win64 -clientconfig=Development `
    -build -cook -stage -pak -archive "-archivedirectory=$ArchiveRoot" -utf8output
```

| Work item | Executable check on gaming PC | Done-state |
| --- | --- | --- |
| Native → managed glue generation | Add a fixture C++ reflected class/property/function and run the native/editor build through the pin's documented generation path. Discover generated files, then build C# that calls the fixture. Repeat using one reflected API from each installed GMCv2, GMAS and Narrative Pro plugin. If an API is not reflected, demonstrate a minimal C++ wrapper first. | Generated output and generator identity captured; managed build exits 0; PIE executes the calls and verifies return values. Repeat after a native signature change to prove glue is refreshed. No hand-edited generated files. |
| Managed → Blueprint integration | Create a fixture C# reflected actor using attributes copied from the installed pin; build it, make a Blueprint subclass and invoke/read its exposed member in PIE. Reopen the editor and repeat. | Real editor/PIE evidence proves reflection and persisted Blueprint references. Any unexposed plugin APIs are listed explicitly with a wrapper decision. |
| Hot reload: behavior | With `OnScriptSave` configured, run a fixture returning `Reload-A`; stop PIE, change its method to return `Reload-B`, save without restarting the editor, then start PIE again. Capture unchanged editor PID and raw watcher/compiler/reload logs. Repeat A→B→A. | Observed behavior changes each time in the same editor process. A successful standalone `dotnet build` cannot substitute for this receipt. Baseline stays **UNVERIFIED** until captured. |
| Hot reload: failure/recovery and state | Introduce a compile error, save, observe diagnostics, correct it, save and rerun PIE. Exercise a Blueprint-held C# object reference and UObject-owned state across the supported reload sequence. Treat live-PIE and reflected-layout changes as separate probes if support is claimed. | Error cannot be recorded as successful reload; corrected code executes without editor restart. Record reference/state behavior and unsupported cases. Do not promise preservation of static state or live-PIE/layout reload without evidence. |
| Cooked/packaged build and runtime | Execute the UAT payload above with the fixture map included in cook settings. Copy the archive to a fresh directory outside project/generated-output search paths. Launch the actual packaged executable, exercise the C# actor and reflected plugin calls, and capture its runtime log, interaction and exit status. Repeat with Shipping configuration before a Shipping claim. | UAT exits 0; staged files include the required managed/runtime artifacts; packaged gameplay executes the expected assertions without the editor or source-tree binaries. Archive hash, dependency manifest and runtime evidence attached. Baseline stays **NO EVIDENCE** until captured. |

A failed hot-reload probe limits that capability to rebuild/restart and blocks a hot-reload support claim. A failed cook/runtime probe blocks the UnrealSharp delivery profile; it does not erase the successful editor-build observation. Diagnose and rerun locally; any implementation-mode change requires an explicit reviewed decision. Mac support remains upstream/task context only, with no Mac execution in this ticket.

## 5. Risks and open questions

Severity reflects impact on this pack's proposed support claims. All engine/runtime/security integration receipts below run on the **gaming PC**; reviewers may inspect their artifacts elsewhere.

| Risk / question | Severity | Receipt needed to close or bound it | Where |
| --- | --- | --- | --- |
| Epic Experimental API drift, unavailable toolsets or failed handshake | High | Exact 5.8.3 plugin descriptor/build; raw initialize/discovery responses, schemas and a successful read tool. If discovery returns meta-tools, expand those schemas rather than assuming a flat tool list. Persist missing capability evidence. | Gaming PC |
| UnrealSharp cooked deployment has **NO EVIDENCE** | High / delivery blocker | Successful UAT cook/package plus independent archive launch executing C# and full-stack assertions; Shipping separately. Editor build is insufficient. | Gaming PC |
| UnrealSharp hot reload **UNVERIFIED** | High for reload support | Same-PID A→B→A behavior and compiler-error recovery logs; state/reference results and exact unsupported cases. | Gaming PC |
| Glue generation misses plugin APIs or ABI/reflection changes | High | Generated-file provenance, managed compilation and runtime assertions against GMCv2 + GMAS + Narrative Pro, including regeneration after a native change. | Gaming PC |
| No-auth MCP/TCP services allow unintended local control | High | Installed-source/bind inspection, task-scoped lifecycle, core deny-path tests and listener shutdown evidence. Wildcard/remote bind prevents use until resolved. Active adversarial testing requires separately approved named isolated scope/time window; this draft authorizes none. | Gaming PC, isolated probe |
| Optional BpGenerator version, entitlement and AI-use metadata unclear | High before redistribution/enabling provider | Acquired-version manifest and license/entitlement record; resolve listing metadata against applicable terms; capture live installed schemas and a permitted read operation. Otherwise keep provider disabled. | Gaming PC inventory; Clahadore/Forge review of evidence |
| UE-derived tools / non-C++ integration distribution obligations | High before release | Map intended artifacts to [UE EULA §§5(c), 6(d)](https://www.unrealengine.com/eula/unreal), installed notices and dependency licenses. Record review of language-integration source/free-distribution obligations and Engine Tools channel restrictions before bundling. | Gaming PC artifact inventory; Forge release review |
| Engine pin may differ from installed hotfix; short UnrealSharp pin incomplete | High | `Build.version`, full SHA, descriptors and captured command output. Repeat receipts after relevant pin changes. | Gaming PC |
| Managed debugger inside hosted CoreCLR, fork launch schema and Windows PDB support | Medium | Exact debugger-extension identity/license; actual breakpoint hit in C# `BeginPlay` and native code. Source navigation is insufficient. Mark unsupported IDE combinations explicitly. | Gaming PC |
| Shared-core schemas/extension APIs unavailable to this draft | High / implementation dependency | Producer schemas and verbatim run/gate/UAT payloads from WT-3796, compatibility validators and negative cases. Do not close with consumer-invented JSON. | Gaming PC integration run; WT-3796 supplies contracts |
| Pack import retains Claude-only hooks, permissive tool wildcards or rigor overrides | High | Content/runtime inventory, schema validation and deny tests; compare generated routing/config against CCGS behavior. Confirm provenance before distribution. | Gaming PC end-to-end pack fixture |
| Stale receipts, editor crash, ambiguous mutation timeout or failed cleanup | High | Core-record validation rejects different tree/pins; crash/timeout scenarios preserve unknown outcome and require inspection; cleanup logs show remaining processes/listeners. | Gaming PC |
| Game networking behavior differs after crossing the C#/C++ boundary | High for multiplayer profile | Two-client/server scenario exercising movement, GMAS ability and Narrative interaction; authority/replication assertions plus logs and UAT interaction evidence. | Gaming PC, isolated local instances |
| Win64 evidence overgeneralized to Mac/Linux/mobile/console | Medium | Win64-only support declaration in the pack manifest. Mac requires a future separately scoped receipt; Linux/mobile/consoles unavailable in this UnrealSharp profile. | Gaming PC verifies manifest and dispatch refusal |

For Epic/BpGenerator, retain the local reference's opt-in behavior: no committed auto-connect configuration, no port forwarding, inspect listeners with `Get-NetTCPConnection -LocalPort 8000,9877 -State Listen`, and stop providers after use. An inbound firewall rule does not authorize or isolate local callers. Verify current source behavior rather than treating localhost as authentication.

## 6. Phased plan

These are proposed tasks. Clahadore's draft review and the WT-3796 council review precede Phase 0 probe work. Every row has a check and a terminating condition. Commands for not-yet-built checks below describe required future test entry points, not existing executables. The implementation must publish their actual runnable invocations with receipts. All UE execution and Game pack integration runs target the gaming PC.

### Phase 0 — receipts before implementation commitments

| Step | Owner | Executable check | Done-state |
| --- | --- | --- | --- |
| 0.1 Establish identity and minimal/full-stack probe fixtures | Cedric; Clahadore coordinates gaming-PC access | Run the section 4 preflight, native/editor and managed builds; capture source/pin/SDK/platform data and fixture map configuration. | Engine is confirmed 5.8.3, full UnrealSharp SHA resolves `cb8577e3`, build exits/logs captured; minimal and full-stack identities distinguishable. |
| 0.2 Smoke Epic MCP **first** | Cedric | In the probe editor enable `ModelContextProtocol` and the required Toolset plugins; keep auto-start off; invoke `ModelContextProtocol.StartServer`. Inspect binding, connect the existing opt-in MCP client, capture `initialize`, `notifications/initialized`, paginated `tools/list`, and any meta-tool expansion. Invoke one discovered read-only tool with schema-valid arguments, then stop the server and verify the listener closes. | Live 5.8.3 handshake + useful read result + cleanup receipt, with exact tool/schema/version. Failure is documented before considering any fallback; BpGenerator success cannot satisfy this check. |
| 0.3 Prove cooked runtime | Cedric; Jenny independently checks the receipt | Execute section 4 UAT cook/package and launch the isolated archive; exercise managed behavior. | Raw UAT and packaged runtime evidence satisfy section 4. Failure leaves the delivery profile blocked and risk open. |
| 0.4 Prove hot reload | Cedric; Susie Franny checks the observation sequence | Execute both reload rows in section 4, including intentional compile failure/recovery. | Same-editor behavior evidence supports a precisely bounded capability, or an explicit unsupported result restricts the profile to rebuild/restart. |

Phase 0 exit: each required probe has an auditable result. A negative result can justify a restricted editor-only or no-reload profile, but cannot pass the failed delivery/reload capability. Clahadore and the WT-3796 council review any resulting scope decision before implementation proceeds.

### Phase 1 — bind pack content to shared-core contracts

| Step | Owner | Executable check | Done-state |
| --- | --- | --- | --- |
| 1.1 Review Phase 0 results and attack the updated implementation plan | Clahadore submits; WT-3796 chairs cross-family review | Review the concrete scope, checks, evidence and remaining failures with another model family; verify review artifacts identify this document revision/hash. | Council disposition recorded before implementation workers start; blockers resolved or bounded with explicit capability restrictions. This draft does not count as that review. |
| 1.2 Agree producer contracts and adapter boundary | Clahadore + Forge lane; Cedric drafts mappings | Compile the adapter signatures against supplied core contracts; validate captured FLT-347/351/350/354 producer payloads and wrong-shape negatives. | Real types/extension points replace placeholders; no pack-owned duplicate schemas; four contract acceptance checks in section 3 pass. |
| 1.3 Inventory and import CCGS pack content | Cedric | A C# manifest/content validator checks source paths, provenance, role/tool translation, sparse config, gate evidence dependencies and unsupported capabilities. Diff imported routing against the inventoried originals. | Versioned manifest, templates and translated operations load through the common pack loader; unresolved behaviors fail validation. |

### Phase 2 — one bounded end-to-end Unreal slice

| Step | Owner | Executable check | Done-state |
| --- | --- | --- | --- |
| 2.1 Implement Epic MCP/session and build providers | Cedric | C# provider tests replay verbatim Phase 0 traffic, then perform a live read/build on gaming PC. Check disconnect, schema change, timeout, cancellation and wrong-machine dispatch. | One core run links discovery, authorization, read result and build artifacts; unsupported/ambiguous outcomes cannot become success. |
| 2.2 Enforce FLT-350 profiles | Cedric; Jenny and Gronktayvius review | Run isolated denial cases for unapproved tools, changed schemas, workspace escape, remote binding and unapproved process arguments. Inspect that rejected calls never reach providers. | Enforcement and cleanup produce evidence; required security review findings resolved. No active pentest is implied by static review. |
| 2.3 Use the Unreal surface through FLT-354 | Cedric; Susie Franny independently replays | Run the real editor/PIE interaction scenario, capture screenshot/video/logs and a failing expected outcome; check stale-revision rejection. | Reachable feature demonstrated; core UAT rejects failure and stale evidence. A reviewer can replay the actual interaction sequence. |

### Phase 3 — UnrealSharp and the gameplay stack

| Step | Owner | Executable check | Done-state |
| --- | --- | --- | --- |
| 3.1 Integrate binding generation and narrow native wrappers | Cedric | Execute all glue/Blueprint checks in section 4 from a clean generated-output state, using the pinned full stack. | Reflected calls and regeneration work; C++ wrappers are limited to measured gaps; generated files remain disposable. |
| 3.2 Integrate supported reload and packaged profiles | Cedric; Jenny verifies | Rerun Phase 0 reload/cook/runtime through the adapter and real shared-core validators. Exercise failure/cleanup and profile gating. | Run records reproduce the baseline observations; unsupported modes are refused; packaged profile cannot pass on editor evidence. |
| 3.3 Validate gameplay/network scenario | Cedric; Gronktayvius examines authority boundaries | Run local server/two-client fixture exercising GMC movement, a GMAS ability and a Narrative Pro interaction across the native/managed boundary. Capture authority/replication expectations and UAT evidence. | Specified gameplay assertions pass in actual instances; failures block the multiplayer profile. |

### Phase 4 — IDE recipes and pack release readiness

| Step | Owner | Executable check | Done-state |
| --- | --- | --- | --- |
| 4.1 Verify workspace and debugger recipes | Cedric | Run installed UBT with `-vscode` project-file generation and `-mode=GenerateClangDatabase` using arguments checked against the installed tools/local task template. Open the workspace, resolve an installed plugin symbol, then hit native and C# breakpoints with each claimed debugger. | Generated config works for explicitly tested IDE/extension combinations, survives regeneration and carries no secrets/machine-specific committed paths; unsupported combinations remain labeled. |
| 4.2 Decide whether optional BpGenerator is needed | Clahadore; Cedric supplies measured gap | Compare required capability coverage against live Epic discovery. If a gap remains, validate entitlement/security, run the installed bridge's read probe and feasibility-before-generation sequence in the fixture. | Provider stays disabled if unnecessary or unverified. If enabled, it has distinct capability IDs, policy and receipts; no silent fallback or copied vendor bridge. |
| 4.3 Validate common-core coexistence and evidence bundle | Cedric; Jenny and Susie Franny independently check | Load Game plus existing packs through the same host; run core regression checks and the Win64 game scenario; validate artifact hashes, provenance, manifest support declarations and closed listeners. | No separate Forge fork; evidence supports only tested capabilities; all release-blocking risks resolved for the declared profile. |
| 4.4 Final review and handoff | Clahadore reviews; WT-3796 chairs council | Run the actual agreed gate/review commands against the exact candidate tree and inspect raw results, including required security seats. | Review disposition and reproducible gaming-PC receipts handed to the Forge lane. No commit, push or upstream action is part of this survey task. |

## 7. Out of scope

- Unity implementation, Unity packages or Unity-specific test infrastructure. Preserve the engine seam only.
- Forking Forge into a game-specific harness, duplicating FLT-347/351/350/354, or building a new IDE.
- Upstream vendor issues, pull requests or other contributions. Keep any needed patch and diagnosis internal.
- New broad Blueprint generation/runtime frameworks where Epic or the pinned dependency already supplies the capability.
- Linux, mobile, console or Mac validation in this ticket; generic .NET support does not establish UnrealSharp platform support.
- Deployment, commits, git write commands, live gaming-PC execution or installation changes during this drafting task.
