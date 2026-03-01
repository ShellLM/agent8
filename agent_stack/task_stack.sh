#!/bin/bash
STATE_FILE="$HOME/ai/agent_stack/state.json"
ARCHIVE_PATH="$HOME/ai/agent_stack/Tasks/Archive"

# Check if slot available
has_slot() {
  local current=$(jq '.stack | length' "$STATE_FILE")
  local limit=$(jq '.limit' "$STATE_FILE")
  [ "$current" -lt "$limit" ]
}

# Push task to stack
push_task() {
  local id="$1"
  local title="$2"
  local branch="$3"
  local model="$4"
  local ts=$(date -Iseconds)
  
  if ! has_slot; then
    echo "ERROR: Stack full. Task queued."
    jq ".queue += [{\"id\": \"$id\", \"title\": \"$title\", \"branch\": \"$branch\", \"model\": \"$model\", \"queued_at\": \"$ts\"}]" "$STATE_FILE" > /tmp/state.json && mv /tmp/state.json "$STATE_FILE"
    return 1
  fi
  
  jq ".stack += [{\"id\": \"$id\", \"title\": \"$title\", \"status\": \"open\", \"branch\": \"$branch\", \"model\": \"$model\", \"opened_at\": \"$ts\", \"priority\": 1}]" "$STATE_FILE" > /tmp/state.json && mv /tmp/state.json "$STATE_FILE"
  echo "Task pushed: $id"
}

# Checkpoint task progress
checkpoint_task() {
  local id="$1"
  local files="$2"
  local ts=$(date -Iseconds)
  # Update last_activity for this task
  jq "(.stack[] | select(.id == \"$id\")) |= . + {\"last_activity\": \"$ts\", \"files\": \"$files\"}" "$STATE_FILE" > /tmp/state.json && mv /tmp/state.json "$STATE_FILE"
}

# Finalize task (ready to close)
finalize_task() {
  local id="$1"
  local report="$2"
  jq "(.stack[] | select(.id == \"$id\")) |= . + {\"status\": \"ready_to_close\", \"report\": \"$report\"}" "$STATE_FILE" > /tmp/state.json && mv /tmp/state.json "$STATE_FILE"
  echo "Task finalized: $id - awaiting human ACK"
}

# Close task (frees slot, archives)
close_task() {
  local id="$1"
  local ts=$(date -Iseconds)
  local task=$(jq -c ".stack[] | select(.id == \"$id\")" "$STATE_FILE")
  
  # Archive the task
  echo "$task" | jq ". + {\"closed_at\": \"$ts\"}" > "$ARCHIVE_PATH/${id}.json"
  
  # Remove from stack
  jq ".stack = [.stack[] | select(.id != \"$id\")]" "$STATE_FILE" > /tmp/state.json && mv /tmp/state.json "$STATE_FILE"
  
  # Promote from queue if available
  local next=$(jq -c '.queue[0]' "$STATE_FILE")
  if [ "$next" != "null" ]; then
    local qid=$(echo "$next" | jq -r '.id')
    local qtitle=$(echo "$next" | jq -r '.title')
    local qbranch=$(echo "$next" | jq -r '.branch')
    local qmodel=$(echo "$next" | jq -r '.model')
    jq ".queue = .queue[1:]" "$STATE_FILE" > /tmp/state.json && mv /tmp/state.json "$STATE_FILE"
    push_task "$qid" "$qtitle" "$qbranch" "$qmodel"
  fi
  
  echo "Task closed and archived: $id"
}

# Show status
status() {
  echo "=== ACTIVE STACK ==="
  jq -r '.stack[] | "\(.id): \(.title) [\(.status)]"' "$STATE_FILE" 2>/dev/null || echo "(empty)"
  echo ""
  echo "=== QUEUE ==="
  jq -r '.queue[] | "\(.id): \(.title)"' "$STATE_FILE" 2>/dev/null || echo "(empty)"
  echo ""
  echo "Slots: $(jq '.stack | length' "$STATE_FILE")/$(jq '.limit' "$STATE_FILE")"
}

case "$1" in
  push) push_task "$2" "$3" "$4" "$5" ;;
  checkpoint) checkpoint_task "$2" "$3" ;;
  finalize) finalize_task "$2" "$3" ;;
  close) close_task "$2" ;;
  status) status ;;
  has-slot) has_slot && echo "AVAILABLE" || echo "FULL" ;;
  *) echo "Usage: $0 {push|checkpoint|finalize|close|status|has-slot}" ;;
esac
