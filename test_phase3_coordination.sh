#!/bin/bash
source ./agent8_consensus.sh
BASE_DIR=$(pwd)
AGENT="./agent8_mini.sh"

echo "[Phase 3] Starting Peer-Review Coordination Test..."

# Agent 1: Generate and Commit Hypothesis
echo "[Agent 1] Generating Hypothesis..."
P="source $BASE_DIR/agent8_consensus.sh; commit 'agent1' 'PROPOSE' 'Hypothesis: 234-byte agents achieve 90% task parity with full frameworks.'; echo 'AGENT1_COMPLETE'" bash -c "source ./ai_hooks.sh; $AGENT" > worker1.log 2>&1 &
A1_PID=$!

# Wait for Agent 1 to commit
sleep 5

# Agent 2: Monitor Ledger and Audit
echo "[Agent 2] Auditing Ledger..."
P="source $BASE_DIR/agent8_consensus.sh; last=\$(tail -n 1 consensus_chain.log); if [[ \$last == *'PROPOSE'* ]]; then commit 'agent2' 'AUDIT' 'Hypothesis Validated via Ledger Analysis'; echo 'AGENT2_COMPLETE'; fi" bash -c "source ./ai_hooks.sh; $AGENT" > worker2.log 2>&1 &
A2_PID=$!

wait $A1_PID $A2_PID

echo "[Phase 3] Test Complete. Consensus Chain State:"
cat consensus_chain.log
