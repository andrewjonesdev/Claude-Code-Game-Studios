#!/usr/bin/env bash
# council-preflight.sh — report which council seats this machine can reach.
#
# EMITS OBSERVATIONS, NOT A VERDICT (per .claude/docs/context-management.md rule 2).
# It does not decide quorum, pick a chair, or say a gate may proceed: the
# caller applies .claude/docs/council.md to these lines. "present" means the
# CLI is on PATH, not that it is logged in or under its usage limit -- only a
# real seat run proves that, and a seat that then fails is FAILED, not present.
#
# Usage: bash .claude/scripts/council-preflight.sh [--versions]
#   --versions  also run each present CLI's --version (cheap, no model call)
#
# Output:
#   tier: <full|available|off|unset> (<source>)
#   seat: <teammate> family=<family> cli=<name> status=<present|absent> [version=...]
#   skill: <name> status=<present|absent>
#   families_present: <n> (<list>)

set -u
want_versions=0
[ "${1:-}" = "--versions" ] && want_versions=1

root=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
tier_line=$(bash "$root/.claude/hooks/yaml-helper.sh" resolve_config --keys council_tier 2>/dev/null | grep '^council_tier:' || true)
echo "tier: ${tier_line#council_tier: }"

grok_cli=grok
if command -v grok >/dev/null 2>&1; then
  grok_exe=grok
elif [ -n "${COUNCIL_GROK_EXE:-}" ]; then
  grok_exe="$COUNCIL_GROK_EXE"
  grok_cli="$grok_exe"
else
  grok_exe="$HOME/source/repos/usage-governor/publish/UsageGovernor.exe"
  grok_cli="$grok_exe"
fi
# Muse Code installs a .cmd launcher outside PATH on Windows.
muse_cli=muse
if ! command -v muse >/dev/null 2>&1 && [ -n "${LOCALAPPDATA:-}" ]; then
  m="$(cygpath -u "$LOCALAPPDATA" 2>/dev/null || echo "$LOCALAPPDATA")/Programs/muse/muse.cmd"
  [ -f "$m" ] && muse_cli="$m"
fi

families=""
seat() {  # teammate family cli-name probe
  local who="$1" fam="$2" cli="$3" probe="$4" status=absent ver=""
  if [ -n "$probe" ] && { command -v "$probe" >/dev/null 2>&1 || [ -f "$probe" ]; }; then
    status=present
    case " $families " in *" $fam "*) ;; *) families="$families $fam" ;; esac
    if [ "$want_versions" = 1 ]; then
      ver=$("$probe" --version 2>/dev/null | head -1 | tr -d '\r')
      [ -n "$ver" ] && ver=" version=$ver"
    fi
  fi
  echo "seat: $who family=$fam cli=$cli status=$status$ver"
}

seat "Clahadore"            claude  claude-code  "claude"
seat "Cedric"               openai  codex        "codex"
seat "Jenny"                google  agy          "agy"
seat "Gronktayvius"         xai     "$grok_cli"  "$grok_exe"
seat "Susie-Franny"         meta    muse         "$muse_cli"

for s in council-code-review llm-council; do
  if [ -f "$HOME/.claude/skills/$s/SKILL.md" ]; then st=present; else st=absent; fi
  echo "skill: $s status=$st"
done

set -- $families
echo "families_present: $# (${families# })"
