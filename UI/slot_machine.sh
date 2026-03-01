#!/usr/bin/env bash
set -euo pipefail

# -------------------------------------------------
# Configuration
# -------------------------------------------------
FRUITS=("CHERRY" "LEMON" "ORANGE" "PLUM" "BELL" "BAR" "SEVEN")
declare -A PAYOUT=(
    ["CHERRY CHERRY CHERRY"]=2
    ["LEMON   LEMON   LEMON"]=3
    ["ORANGE  ORANGE  ORANGE"]=4
    ["PLUM    PLUM    PLUM"]=5
    ["BELL    BELL    BELL"]=10
    ["BAR     BAR     BAR"]=20
    ["SEVEN   SEVEN   SEVEN"]=50
    ["MATCH2"]=1
)

CREDITS=100
BET=5
SPIN_ROUNDS_MIN=12
SPIN_ROUNDS_MAX=20
SLEEP_START=0.03
SLEEP_END=0.20

# -------------------------------------------------
# Helper functions
# -------------------------------------------------
clear_screen() { printf "[2J[H"; }

draw_frame() {
    local r1="$1" r2="$2" r3="$3" msg="$4"
    # Pad fruit names so the box stays aligned
    printf -v r1 "%-7s" "$r1"
    printf -v r2 "%-7s" "$r2"
    printf -v r3 "%-7s" "$r3"

    clear_screen
    printf "╔════════════════════════════════════════════════╗
"
    printf "║      🎰  TERMINAL SLOT MACHINE  🎰             ║
"
    printf "╠════════════════════════════════════════════════╣
"
    printf "║   [ %s ]   [ %s ]   [ %s ]   ║
" "$r1" "$r2" "$r3"
    printf "╠════════════════════════════════════════════════╣
"
    printf "║ Credits: %3s   Bet: %2s per spin               ║
" "$CREDITS" "$BET"
    printf "║ %-46s ║
" "$msg"
    printf "╚════════════════════════════════════════════════╝
"
    printf "
Press <ENTER> to spin, or 'q' then <ENTER> to quit.
"
}

spin_animation() {
    local rounds=$((RANDOM % (SPIN_ROUNDS_MAX - SPIN_ROUNDS_MIN + 1) + SPIN_ROUNDS_MIN))
    local sleep_time=$SLEEP_START
    for ((i=0; i<rounds; i++)); do
        local a=${FRUITS[$RANDOM % ${#FRUITS[@]}]}
        local b=${FRUITS[$RANDOM % ${#FRUITS[@]}]}
        local c=${FRUITS[$RANDOM % ${#FRUITS[@]}]}   # fixed typo (was $RITS)
        draw_frame "$a" "$b" "$c" "Spinning..."
        if (( i > rounds-5 )) && (( $(awk "BEGIN{print ($sleep_time<$SLEEP_END)}") )); then
            sleep_time=$(awk "BEGIN{print $sleep_time+0.03}")
        fi
        sleep "$sleep_time"
    done
}

final_result() {
    local a=${FRUITS[$RANDOM % ${#FRUITS[@]}]}
    local b=${FRUITS[$RANDOM % ${#FRUITS[@]}]}
    local c=${FRUITS[$RANDOM % ${#FRUITS[@]}]}
    echo "$a $b $c"
}

evaluate() {
    local a="$1" b="$2" c="$3"
    if [[ "$a" == "$b" && "$b" == "$c" ]]; then
        local key="$a $b $c"
        local multiplier=${PAYOUT[$key]:-0}
        echo "JACKPOT! ($multiplier×)|$((BET * multiplier))"
    elif [[ "$a" == "$b" || "$b" == "$c" || "$a" == "$c" ]]; then
        local multiplier=${PAYOUT["MATCH2"]}
        echo "Small win! ($multiplier×)|$((BET * multiplier))"
    else
        echo "No win.|0"
    fi
}

# -------------------------------------------------
# Main loop
# -------------------------------------------------
while true; do
    draw_frame "———" "———" "———" "Welcome! Press <ENTER> to spin."
    read -r line
    [[ "$line" == "q" ]] && {
        clear_screen
        echo "Thanks for playing! Final credits: $CREDITS"
        exit 0
    }

    if (( CREDITS < BET )); then
        draw_frame "!!!" "!!!" "!!!" "Insufficient credits."
        sleep 2
        continue
    fi

    ((CREDITS -= BET))
    spin_animation

    # Get the final result
    read -r r1 r2 r3 <<< "$(final_result)"
    draw_frame "$r1" "$r2" "$r3" "Result!"

    # Parse the pipe‑delimited output from evaluate
    IFS='|' read -r result_msg win <<< "$(evaluate "$r1" "$r2" "$r3")"
    ((CREDITS += win))

    draw_frame "$r1" "$r2" "$r3" "$result_msg (+$win)"
    sleep 2
done
