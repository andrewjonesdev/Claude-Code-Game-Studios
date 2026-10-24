# Unreal Engine 5.8 — MCP servers for the editor

**Last verified:** 2026-10-24 — read from the UE 5.8 install
(`Engine/Plugins/Experimental/ModelContextProtocol`) and the BlueprintsLab
extension source. BpGenerator answered a live call from Claude Desktop on
2026-10-24 (`get_focused_content_browser_path` → `/Game/`). Epic's server has
**not** been connected live yet.

Two servers. Both are declared in the repo's `.mcp.json`, which Claude Code
reads; Cursor and Antigravity need their own copy (see the bottom).

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

Setup per project: enable **Unreal MCP** (and its Toolset plugins) in
`Edit > Plugins`, restart, then either tick *Auto Start Server* in Editor
Preferences or run `ModelContextProtocol.StartServer`. The tool set comes from
the Toolset Registry, so read the live tool list (`/mcp` in Claude Code) rather
than assuming names.

Not available on 5.7. A 5.7 project uses BpGenerator only.

## `unreal-blueprints` — BlueprintsLab BpGenerator Ultimate

| Item | Value |
|---|---|
| Editor plugin | BpGenerator Ultimate (Fab) — installed for 5.5–5.8 under `Engine/Plugins/Marketplace/Ultimate…` |
| MCP server | `mcp_main_server.py` shipped as the Claude Desktop extension "Unreal Engine Pro Tools" (`%APPDATA%/Claude/Claude Extensions/local.mcpb.roly-blueprintslab.unreal-engine-pro-tools/`) |
| Transport | stdio (FastMCP), `--server-name unreal-handshake` |
| Editor link | raw TCP to `localhost:9877` (hard-coded) |
| Python | 3.10+, `pip install mcp`; no other deps |
| Tool prefix | `mcp__unreal-blueprints__*` from `.mcp.json`; `mcp__Unreal_Engine_Pro_Tools__*` from the Desktop extension |

In Claude Desktop the extension already provides these tools, so the
`.mcp.json` copy duplicates them; disable `unreal-blueprints` there
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

- **Cursor**: copy the same two servers into `.cursor/mcp.json`. Cursor expands
  `${env:APPDATA}`, not `${APPDATA}`. Template:
  `.claude/docs/templates/unreal/cursor-mcp.json`.
- **Antigravity**: MCP servers are configured in the agent panel's
  *Manage MCP Servers → View raw config* (`mcp_config.json`). Same entries,
  absolute paths. Template: `.claude/docs/templates/unreal/antigravity-mcp.json`.
  The HTTP key is written as `serverUrl` in the template — **unverified**;
  if Antigravity rejects it, try `url` and record which worked here.
