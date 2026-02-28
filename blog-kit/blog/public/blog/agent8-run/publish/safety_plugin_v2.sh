#!/bin/bash
LOG=./safety_intercepts.log

guard() {
    local cmd="$1" p="$2"
    # Isolate patterns in variables to prevent bash from interpreting 
    # special regex characters (;, {}, (), |, &) as shell operators
    local pat_rm='rm[[:space:]]+-rf[[:space:]]+/'
    local pat_fork=':.*\(.*\).*\{.*:.*\};:'
    local pat_pipe='curl[[:space:]]+.*\|.*sh'
    local pat_write='>.*agent8'
    local pat_eval='eval[[:space:]]*\$'
    
    if [[ "$cmd" =~ $pat_rm ]] || [[ "$cmd" =~ $pat_fork ]] || \
       [[ "$cmd" =~ $pat_pipe ]] || [[ "$cmd" =~ $pat_write ]] || \
       [[ "$cmd" =~ $pat_eval ]]; then
        printf "[SAFETY-BLOCK] %s %s %s %s\n" "$(date -u +%s)" "$(uuidgen)" "$p" "$cmd" >> "$LOG"
        return 1
    fi
    return 0
}
export -f guard
