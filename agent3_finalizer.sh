#!/bin/bash
# Agent 3: Consensus Finalizer (Safe Implementation)
# This script has fixed logic to close the consensus loop.

source ./agent8_consensus.sh
LEDGER="./consensus_chain.log"

if [[ ! -f "$LEDGER" ]]; then
    echo "Error: Ledger not found at $LEDGER"
    exit 1
fi

# 1. Read the last operation from the ledger
LAST_ENTRY=$(tail -n 1 "$LEDGER")
LAST_OP=$(echo "$LAST_ENTRY" | cut -d'|' -f4)

echo "Finalizer checking ledger... Last Op: $LAST_OP"

# 2. If the last entry was an AUDIT, finalize the chain
if [[ "$LAST_OP" == "AUDIT" ]]; then
    commit "agent3" "FINAL" "Consensus Reached: Phase 3 Verification Complete"
    echo "SUCCESS: FINAL block committed to ledger."
else
    echo "WAITING: No AUDIT block found to finalize."
fi
