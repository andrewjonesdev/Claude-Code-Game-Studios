#!/usr/bin/env bash
# model-slug-check.sh — report retired Gemini slugs and current model listings.
#
# EMITS OBSERVATIONS, NOT A VERDICT (per .claude/docs/context-management.md rule 2).
# Matches are observations; the caller applies .claude/docs/council.md.
# A live listing does not prove that a real seat run will succeed.
#
# Usage: bash .claude/scripts/model-slug-check.sh [--live]
#   --live  also check current slugs in agy models when agy is on PATH
#
# Output:
#   retired: <path>:<line>: <slug>
#   retired_total: <n>
#   current: gemini-4-argon-high gemini-3.8-flash-high
#   live: <slug> listed|missing

set -u
root=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
cd "$root" || exit 0
total=0
pattern='gemini-3\.(1-pro|5-flash|6-flash|7-flash)|Gemini 3\.(1 Pro|6 Flash|7 Flash)'
while IFS= read -r -d '' path; do
  case "$path" in
    CHANGELOG.md|*/CHANGELOG.md|studio-tests/*|.claude/scripts/model-slug-check.sh) continue ;;
  esac
  while IFS= read -r hit; do
    line=${hit%%:*}
    slug=${hit#*:}
    printf 'retired: %s:%s: %s\n' "$path" "$line" "$slug"
    total=$((total + 1))
  done < <(sed 's/not Gemini 3\.5 Flash Cyber//g' "$path" 2>/dev/null | grep -nEo "$pattern" || true)
done < <(git ls-files -z)
printf 'retired_total: %s\n' "$total"
echo 'current: gemini-4-argon-high gemini-3.8-flash-high'
if [ "${1:-}" = '--live' ] && command -v agy >/dev/null 2>&1; then
  models=$(agy models 2>/dev/null || true)
  for slug in gemini-4-argon-high gemini-3.8-flash-high; do
    status=missing
    if printf '%s\n' "$models" | grep -Fq -- "$slug"; then status=listed; fi
    printf 'live: %s %s\n' "$slug" "$status"
  done
fi
exit 0
