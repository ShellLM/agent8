#!/bin/bash
# Agent 3: Publisher (Phase 4)
source ./agent8_consensus.sh
LEDGER="./consensus_chain.log"
MANIFEST="release_manifest.json"
PUB_DIR="./publish"

echo "Agent 3 (Publisher) preparing final release..."

# Check Ledger for Auditor Approval
LAST_AUDIT=$(grep "AUDIT_PASSED" "$LEDGER" | tail -n 1)
if [[ -z "$LAST_AUDIT" ]]; then
    echo "ABORT: No 'AUDIT_PASSED' entry found in ledger."
    exit 1
fi

mkdir -p "$PUB_DIR"
FILES=$(grep -o '"file": "[^"]*"' "$MANIFEST" | cut -d'"' -f4)

for file in $FILES; do
    echo "Publishing $file -> $PUB_DIR/"
    cp "$file" "$PUB_DIR/"
done

# Generate final verification file
sha256sum "$PUB_DIR"/* > "$PUB_DIR/checksums.txt"

commit "agent3" "RELEASE" "Project published to $PUB_DIR. Release verified."
echo "=========================================================="
echo " RELEASE COMPLETE: Check the '$PUB_DIR' directory."
echo "=========================================================="
