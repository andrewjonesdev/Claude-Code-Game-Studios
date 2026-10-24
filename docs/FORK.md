# This fork

`andrewjonesdev/Claude-Code-Game-Studios` is a fork of
[Donchitos/Claude-Code-Game-Studios](https://github.com/Donchitos/Claude-Code-Game-Studios)
(MIT), configured for the Jones-Gaffney studio stack:

- **Unreal Engine 5.8**, C# via **UnrealSharp**, C++ for engine-facing code
- **GMCv2 + GMAS + Narrative Pro** through the **NarrativeGMC** bridge
- **Editor MCP**: Epic's Unreal MCP and BpGenerator Ultimate (`.mcp.json`)
- **Cursor / Antigravity** as the IDE
- **The council** — cross-family review at gates (`.claude/docs/council.md`)

Fork-only files: `.claude/docs/council.md`, `.claude/scripts/council-preflight.sh`,
`.claude/agents/ue-csharp-specialist.md`, `.claude/agents/ue-gmc-specialist.md`,
`.mcp.json`, `.claude/docs/templates/unreal/`, `docs/engine-reference/unreal/{mcp,ide-cursor-antigravity}.md`,
`docs/engine-reference/unreal/plugins/{unrealsharp,gmc-narrative}.md`, this file.

## Taking upstream releases

Remotes: `origin` = this fork, `upstream` = Donchitos (push disabled).

```bash
git fetch upstream
git switch -c wt/WT_ID/upstream-VERSION main
git merge upstream/main
```

Replace WT_ID and VERSION.

Expect conflicts in files both sides edit: `.claude/hooks/yaml-helper.sh`
(the `council.tier` lines), `.claude/docs/effects-map.md`,
`.claude/docs/director-gates.md` (the "Council seats" subsection),
`.claude/skills/setup-engine/references/{4-claude-md-stack,5-technical-preferences,5.5-project-yaml}.md`,
the Unreal agents' `tools:` lines, `CLAUDE.md`, and the agent counts (51 here).
Keep upstream's change and re-apply ours. Run the council review before landing.

Never push to `upstream`, and never open issues or PRs there on the studio's
behalf (coordination rule 7); draft them for Andrew instead.
