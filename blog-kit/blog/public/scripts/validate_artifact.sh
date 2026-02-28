#!/bin/bash

# validate_artifact.sh - Ensures consistency in experiment artifacts

usage() {
    echo "Usage: $0 [-d directory] [-b blog_draft.md]"
    exit 1
}

DIR="."
BLOG_DRAFT=""

while getopts "d:b:" opt; do
    case $opt in
        d) DIR="$OPTARG" ;;
        b) BLOG_DRAFT="$OPTARG" ;;
        *) usage ;;
    esac
done

echo "--- Validating Artifacts in $DIR ---"

# 1. File existence checks
REQUIRED_FILES=("metrics.csv" "experiment_plan.md" "run_ledger_detailed.csv")
MISSING=0

# Note: In this repo, files are often prefixed. We look for files containing these strings.
for req in "${REQUIRED_FILES[@]}"; do
    if ! ls "$DIR"/*"$req"* >/dev/null 2>&1; then
        echo "[ERROR] Missing file matching: $req"
        MISSING=$((MISSING + 1))
    else
        echo "[OK] Found $req"
    fi
done

if [ $MISSING -gt 0 ]; then
    echo "Validation failed: $MISSING required files missing."
    # exit 1 # Not exiting yet to show all errors
fi

# 2. Header validation
METRICS_FILE=$(ls "$DIR"/*metrics.csv* 2>/dev/null | head -n 1)
LEDGER_FILE=$(ls "$DIR"/*run_ledger_detailed.csv* 2>/dev/null | head -n 1)

if [ -f "$METRICS_FILE" ]; then
    EXPECTED="timestamp,metric_name,value,unit"
    ACTUAL=$(head -n 1 "$METRICS_FILE" | tr -d '\r')
    if [ "$ACTUAL" == "$EXPECTED" ]; then
        echo "[OK] metrics.csv headers valid."
    else
        echo "[ERROR] metrics.csv header mismatch."
        echo "  Expected: $EXPECTED"
        echo "  Actual:   $ACTUAL"
    fi
fi

if [ -f "$LEDGER_FILE" ]; then
    EXPECTED="timestamp,node_id,task_type,duration_ms,status"
    ACTUAL=$(head -n 1 "$LEDGER_FILE" | tr -d '\r')
    if [ "$ACTUAL" == "$EXPECTED" ]; then
        echo "[OK] run_ledger_detailed.csv headers valid."
    else
        echo "[ERROR] run_ledger_detailed.csv header mismatch."
        echo "  Expected: $EXPECTED"
        echo "  Actual:   $ACTUAL"
    fi
fi

# 3. Blog draft cross-reference
if [ -n "$BLOG_DRAFT" ] && [ -f "$BLOG_DRAFT" ]; then
    echo "--- Cross-referencing with $BLOG_DRAFT ---"
    if [ -f "$METRICS_FILE" ]; then
        # Get unique metric names from CSV (excluding header)
        METRICS=$(tail -n +2 "$METRICS_FILE" | cut -d',' -f2 | sort -u)
        for m in $METRICS; do
            if grep -q "$m" "$BLOG_DRAFT"; then
                echo "[OK] Metric '$m' found in blog draft."
            else
                echo "[WARN] Metric '$m' NOT mentioned in blog draft."
            fi
        done
    fi
fi

echo "--- Validation Complete ---"
