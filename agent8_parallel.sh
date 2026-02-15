#!/bin/bash
# Agent8 P3: Coordination Wrapper
u=$(uuidgen)
p=~/ai/agent8_mini.sh
# Function to launch background workers with unique prompt environment
spawn_worker() {
    local id=$1
    local p_env=$2
    echo "[LAUNCH] Worker $id starting..."
    (P="$p_env" bash "$p" <<< "U:$u-worker$id") &
}

# Example: Execute parallel investigation
spawn_worker 1 "Research subshell concurrency patterns"
spawn_worker 2 "Investigate flock-based locking for shell agents"
spawn_worker 3 "Analyze wait exit code propagation"

wait
echo "[PARALLEL] All workers synchronised and completed."
