#!/bin/bash
# Agent 1: Assembler (Phase 4)
# Identifies core artifacts and generates a manifest for the release.

source ./agent8_consensus.sh
MANIFEST="release_manifest.json"

echo "Agent 1 (Assembler) starting artifact discovery..."

# 1. Define Core Artifacts
ARTIFACTS=(
    "agent8.sh"
    "agent8_mini.sh"
    "agent8_consensus.sh"
    "safety_plugin_v2.sh"
    "blog-kit/blog_draft_final.md"
    "consensus_chain.log"
)

# 2. Build JSON Manifest safely
echo "{" > "$MANIFEST"
echo "  \"timestamp\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\"," >> "$MANIFEST"
echo "  \"artifacts\": [" >> "$MANIFEST"

first=true
for file in "${ARTIFACTS[@]}"; do
    if [[ -f "$file" ]]; then
        [[ "$first" = false ]] && echo "," >> "$MANIFEST"
        hash=$(sha256sum "$file" | cut -d' ' -f1)
        size=$(stat -c%s "$file")
        echo -n "    { \"file\": \"$file\", \"sha256\": \"$hash\", \"size\": $size }" >> "$MANIFEST"
        first=false
    fi
done

echo "" >> "$MANIFEST"
echo "  ]" >> "$MANIFEST"
echo "}" >> "$MANIFEST"

# 3. Commit to Ledger
commit "agent1" "MANIFEST" "Release Manifest Generated: $MANIFEST"
echo "SUCCESS: Manifest created with $(grep -c "file" "$MANIFEST") artifacts."
