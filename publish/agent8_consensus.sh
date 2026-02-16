#!/bin/bash
LEDGER=./consensus_chain.log
LOCK=/tmp/agent8_consensus.lock

commit() {
    local agent="$1" op="$2" data="$3"
    ( flock -x 200 || exit 1
      echo "$(date -u +%s)|$agent|$(echo "$data"|sha256sum|cut -c1-8)|$op" >> "$LEDGER"
    ) 200>"$LOCK"
}

verify_chain() {
    local prev=""
    echo "--- Consensus Chain Audit ---"
    while IFS='|' read ts agent hash op; do
        echo "Block: $ts | Agent: $agent | Hash: $hash | Op: $op"
        prev="$hash"
    done <"$LEDGER"
}
export -f commit verify_chain
