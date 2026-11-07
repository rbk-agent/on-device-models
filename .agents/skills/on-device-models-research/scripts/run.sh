#!/usr/bin/env bash
set -euo pipefail

REPO=/home/richard/projects/on-device-models
SKILL=on-device-models-research
LOG="$HOME/.hermes/cron/logs/${SKILL}.log"
mkdir -p "$(dirname "$LOG")"

cd "$REPO"
git fetch origin
git checkout main
git pull --ff-only

PROMPT="Load and execute the skill at $REPO/.agents/skills/$SKILL/SKILL.md for the repository at $REPO. Cap at one PR; return summary, no-op, or PR URL."

OUTPUT=$(hermes -z "$PROMPT" --workdir "$REPO" -t terminal,web,file --accept-hooks 2>&1 | tee -a "$LOG")
STATUS=$?

if [ "$STATUS" -eq 0 ]; then
  hermes send discord "Home" "on-device-models research run complete: $(printf '%s' "$OUTPUT" | tail -n 8)"
else
  hermes send discord "Home" "on-device-models research run FAILED (exit $STATUS). See $LOG"
fi

exit "$STATUS"