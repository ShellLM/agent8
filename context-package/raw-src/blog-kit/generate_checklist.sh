#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <title> <run_id> [models] [audience]"
  exit 1
fi

TITLE="$1"
RUN_ID="$2"
MODELS="${3:-gpt-5,gpt-5-mini,claude,gemini}"
AUDIENCE_DEFAULT="AI researchers, advanced users, future-you"
AUDIENCE="${4:-$AUDIENCE_DEFAULT}"
DATE_UTC="$(date -u +%F)"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE="$SCRIPT_DIR/templates/experiment_checklist.template.md"
OUT="$SCRIPT_DIR/checklist-${RUN_ID}.md"

if [[ ! -f "$TEMPLATE" ]]; then
  echo "Template not found: $TEMPLATE"
  exit 2
fi

sed \
  -e "s|{{title}}|$TITLE|g" \
  -e "s|{{run_id}}|$RUN_ID|g" \
  -e "s|{{date}}|$DATE_UTC|g" \
  -e "s|{{models}}|$MODELS|g" \
  -e "s|{{audience}}|$AUDIENCE|g" \
  "$TEMPLATE" > "$OUT"

echo "Created: $OUT"
