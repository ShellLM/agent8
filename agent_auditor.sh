#!/bin/bash
# Agent 2: Security Auditor (Phase 4 - Refined)
source ./agent8_consensus.sh
LEDGER="./consensus_chain.log" 
MANIFEST="release_manifest.json"

echo "Agent 2 (Auditor) starting refined security scan..."

# Target: Remote fetch piped directly to execution
DANGEROUS_PATTERNS=(
    "curl.*|.*bash"
    "wget.*|.*bash"
    "rm -rf /"
    "> /dev/sd[a-z]"
)

FILES=$(grep -o '"file": "[^"]*"' "$MANIFEST" | cut -d'"' -f4)
FAILURE=0

for file in $FILES; do
    echo "Auditing $file..."
    # Check for remote-to-shell specifically
    if grep -qiE "curl|wget" "$file" && grep -qi "bash" "$file"; then
        # We allow it in the blog post as a demonstration, but not in scripts
        if [[ "$file" == *.md ]]; then
            echo "  [INFO] Documentation contains installation examples. Proceeding."
        else
            echo "  [!!] WARNING: Remote fetch-to-shell pattern in script: $file"
            FAILURE=1
        fi
    fi
    
    # Check for destructive patterns
    if grep -qiE "rm -rf /|> /dev/sd" "$file"; then
        echo "  [!!] CRITICAL: Destructive command in $file"
        FAILURE=1
    fi
done

if [ $FAILURE -eq 0 ]; then
    echo "SUCCESS: Security scan passed."
    commit "agent2" "AUDIT_PASSED" "Security scan complete. No remote-exec risks found."
else
    echo "FAILURE: Security scan failed."
    commit "agent2" "AUDIT_FAILED" "Remote-exec or destructive risk detected."
    exit 1
fi
