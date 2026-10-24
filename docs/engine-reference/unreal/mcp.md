# Unreal Engine 5.8 — MCP servers for the editor

**Last verified:** 2026-10-24 — read from the UE 5.8 install
(`Engine/Plugins/Experimental/ModelContextProtocol`) and the BlueprintsLab
extension source. BpGenerator answered a live call from Claude Desktop on
2026-10-24 (`get_focused_content_browser_path` → `/Game/`). Epic's server has
**not** been connected live yet.

Two servers. Only `unreal` is declared in the repo's `.mcp.json`, which Claude
Code reads. `unreal-blueprints` is opt-in; Cursor and Antigravity need their own
local config (see below).

---

## `unreal` — Epic's Unreal MCP (UE 5.8, Experimental)

| Item | Value | Source |
|---|---|---|
| Plugin | `ModelContextProtocol` ("Unreal MCP"), `EnabledByDefault: false`, Experimental | `ModelContextProtocol.uplugin` |
| Depends on | `ToolsetRegistry`, `EngineAssetDefinitions` | same |
| Transport | Streamable HTTP — POST, GET (SSE) and DELETE on one path | `Private/ModelContextProtocolServer.cpp:435-442` |
| URL | `http://localhost:8000/mcp` | `Public/ModelContextProtocol.h:45-46` |
| Settings | `UModelContextProtocolSettings` (Editor Per-Project User Settings): `ServerUrlPath`, `ServerPortNumber`, `bAutoStartServer` (**false** by default), `bEnableToolSearch` | `ModelContextProtocolSettings.h:17-47` |
| Port override | `-ModelContextProtocolPort=N` on the editor command line (then change the port in `.mcp.json` too) | `ModelContextProtocolSettings.cpp:20` |
| Start by hand | console `ModelContextProtocol.StartServer [port]` | `ModelContextProtocolModule.cpp:33` |
| Security | localhost Origin only; requests with no Origin header pass | `ModelContextProtocolServer.cpp:73-119` |

**Security:** No authentication; requests without an `Origin` header are accepted, and MCP clients normally send none, so any process on the machine can drive the editor while the server runs. Start it only when needed, keep the port bound to localhost, never forward/expose it, and stop it (or close the editor) when done.

Setup per project: enable **Unreal MCP** (and its Toolset plugins) in
`Edit > Plugins`, restart, keep *Auto Start Server* off in Editor
Preferences and run `ModelContextProtocol.StartServer` only for the task. The tool set comes from
the Toolset Registry, so read the live tool list (`/mcp` in Claude Code) rather
than assuming names. New tools appearing in the Toolset Registry are not
pre-approved: agents ask before calling a tool they have not used in this session.

**Firewall:** Add an inbound-deny rule for TCP 9877 and 8000 on every dev machine: `New-NetFirewallRule -DisplayName "Deny UE MCP 9877" -Direction Inbound -LocalPort 9877 -Protocol TCP -Action Block` and `New-NetFirewallRule -DisplayName "Deny UE MCP 8000" -Direction Inbound -LocalPort 8000 -Protocol TCP -Action Block`. Before use, verify the listener bind with `Get-NetTCPConnection -LocalPort 9877,8000 -State Listen`; if it shows `0.0.0.0` or `::`, do not run it on an untrusted network.

**DNS rebinding/CSRF:** No browser tabs to untrusted sites while the Epic MCP
server runs; the server accepts requests without an Origin header.

Not available on 5.7. A 5.7 project uses BpGenerator only.

## `unreal-blueprints` — BlueprintsLab BpGenerator Ultimate

**Opt-in:** Copy `.claude/docs/templates/unreal/mcp-blueprints.example.json`
into your local, gitignored MCP config only on a machine where you have verified
the extension folder. Prefer an absolute path to a specific `python.exe` over
bare `python`; the extension script lives under user-writable `%APPDATA%`.

| Item | Value |
|---|---|
| Editor plugin | BpGenerator Ultimate (Fab) — installed for 5.5–5.8 under `Engine/Plugins/Marketplace/Ultimate…` |
| MCP server | `mcp_main_server.py` shipped as the Claude Desktop extension "Unreal Engine Pro Tools" (`%APPDATA%/Claude/Claude Extensions/local.mcpb.roly-blueprintslab.unreal-engine-pro-tools/`) |
| Transport | stdio (FastMCP), `--server-name unreal-handshake` |
| Editor link | raw TCP to `localhost:9877` (hard-coded) |
| Python | 3.10+, `pip install mcp`; no other deps |
| Tool prefix | `mcp__unreal-blueprints__*` from `.mcp.json`; `mcp__Unreal_Engine_Pro_Tools__*` from the Desktop extension |

**Security:** The raw TCP 9877 channel is unauthenticated; any local process can send it commands and drive the editor while the server runs. Start it only when needed, keep the port bound to localhost, never forward/expose it, and stop it (or close the editor) when done.

In Claude Desktop the extension already provides these tools, so a local
MCP config copy duplicates them; disable `unreal-blueprints` there
(`/mcp`) if both show. The sibling extension `custom-filesystem-access` runs the
same script as a file reader/writer for C++ outside the project — not needed,
the agents have file tools.

Highlights: `how_to_use` (90 KB master prompt — don't call it into the main
context), `check_request_feasibility` (must precede Blueprint generation),
`generate_blueprint_logic`, `create_new_blueprint`, `add_component_to_blueprint`,
`add_variable_to_blueprint`, `create_struct`, `create_enum`, `create_material`,
`create_widget_from_layout`, `spawn_actor_in_level`, `get_asset_summary`,
`list_assets_in_folder`, `scan_and_index_project_blueprints`,
`get_project_performance_report`.

## Which agents can use them

`unreal-specialist`, `ue-blueprint-specialist`, `ue-gmc-specialist` and
`ue-csharp-specialist` list `mcp__unreal__*`, `mcp__unreal-blueprints__*` and
`mcp__Unreal_Engine_Pro_Tools__*` in their `tools:`. Any agent with an explicit
`tools:` list and no `mcp__` entry cannot see MCP tools at all — add the
entries rather than removing the list. Usage rules live in `unreal-specialist`
→ "Unreal MCP Tools".

## Other IDEs

- **Cursor**: copy the required servers into a local, gitignored `.cursor/mcp.json`,
  following the opt-in checks above for `unreal-blueprints`. Cursor expands
  `${env:APPDATA}`, not `${APPDATA}`. Template:
  `.claude/docs/templates/unreal/cursor-mcp.json`.
- **Antigravity**: MCP servers are configured in the agent panel's
  *Manage MCP Servers → View raw config* (`mcp_config.json`). Same entries,
  following the opt-in checks above. Template: `.claude/docs/templates/unreal/antigravity-mcp.json`.
  Antigravity may need the `${env:APPDATA}` placeholder expanded to an absolute
  path locally — never commit a real username.
  The HTTP key is written as `serverUrl` in the template, following the
  Windsurf-style `mcp_config.json` convention — **unverified**. Cursor uses `url`.
