#!/usr/bin/env bash
# -------------------------------------------------
# Slot Machine – fixed detection + persistent credits
# -------------------------------------------------

MIN_ROWS=12
MIN_COLS=40
SYMBOLS=( "🍒" "🍋" "🍇" "🍉" "🍀" "💎" "7⃣" "🔔" "⭐" "🃏" )
COLORS=( '[1;31m' '[1;33m' '[1;35m' '[1;32m' '[1;36m'
         '[1;31m' '[1;33m' '[1;33m' '[1;33m' '[1;30m' )
NC='[0m'

CREDITS_FILE="${HOME}/.slot_credits"
DEFAULT_CREDITS=100
BET=5

load_credits() {
    if [[ -f "$CREDITS_FILE" ]]; then
        CREDITS=$(<"$CREDITS_FILE")
    else
        CREDITS=$DEFAULT_CREDITS
    fi
}
save_credits() { echo "$CREDITS" > "$CREDITS_FILE"; }

check_terminal() {
    local size; size=$(stty size 2>/dev/null || echo "24 80")
    read -r ROWS COLS <<<"$size"
    (( ROWS < MIN_ROWS )) && { echo -e "${COLORS[0]}❌ Too small${NC}"; exit 1; }
    (( COLS < MIN_COLS )) && { echo -e "${COLORS[0]}❌ Too small${NC}"; exit 1; }
}
optimize_display() {
    if (( COLS >= 100 )); then BOX_WIDTH=70; SPIN_DELAY=0.08;
    elif (( COLS >= 80 )); then BOX_WIDTH=60; SPIN_DELAY=0.12;
    else BOX_WIDTH=40; SPIN_DELAY=0.15; fi
}
draw_box() {
    local w=$1 title=$2 color=$3
    local top="┌$(printf '─%.0s' $(seq 1 $w))┐"
    local bot="└$(printf '─%.0s' $(seq 1 $w))┘"
    local pad=$(( (w - ${#title}) / 2 ))
    echo -e "${color}${top}${NC}"
    printf "${color}│${NC}%*s%s%*s${color}│${NC}
" "$pad" "" "$title" "$((w - pad - ${#title}))" ""
    echo -e "${color}${bot}${NC}"
}
get_symbol() { local i=$1; echo -e "${COLORS[$i]}${SYMBOLS[$i]}${NC}"; }

spin_reels() {
    (( CREDITS < BET )) && { echo -e "${COLORS[0]}❌ Not enough credits${NC}"; return 1; }
    (( CREDITS -= BET ))
    echo -e "${COLORS[4]}💰 Credits: $CREDITS | Bet: $BET${NC}"
    local spins=12 r1 r2 r3
    for ((i=0;i<spins;i++)); do
        r1=$((RANDOM % ${#SYMBOLS[@]}))
        r2=$((RANDOM % ${#SYMBOLS[@]}))
        r3=$((RANDOM % ${#SYMBOLS[@]}))
        printf "[K  %s  │  %s  │  %s  " "$(get_symbol $r1)" "$(get_symbol $r2)" "$(get_symbol $r3)"
        sleep $SPIN_DELAY
    done
    # final values (already in r1‑r3)
    printf "[K  %s  │  %s  │  %s  
" "$(get_symbol $r1)" "$(get_symbol $r2)" "$(get_symbol $r3)"
    if [[ $r1 == $r2 && $r2 == $r3 ]]; then
        draw_box $((BOX_WIDTH/2)) "🎰 JACKPOT! 🎰" "[1;33m"
        (( CREDITS += BET * 10 ))
        echo -e "  💰 +$((BET*10)) credits!"
    elif [[ $r1 == $r2 || $r2 == $r3 || $r1 == $r3 ]]; then
        draw_box $((BOX_WIDTH/2)) "✨ WIN! ✨" "[1;32m"
        (( CREDITS += BET * 2 ))
        echo -e "  💰 +$((BET*2)) credits!"
    else
        draw_box $((BOX_WIDTH/2)) "💔 TRY AGAIN" "[1;31m"
    fi
    save_credits
}
main() {
    check_terminal; optimize_display; load_credits
    while (( CREDITS > 0 )); do
        clear
        draw_box $BOX_WIDTH "🎰 LUCKY SLOTS 🎰" "[1;35m"
        echo -e "[90m Terminal: ${ROWS}×${COLS} | Credits: $CREDITS [0m"
        read -p "Press ENTER to spin (q to quit): " -r reply
        [[ $reply == q ]] && break
        spin_reels
        echo -e "  📊 Credits left: $CREDITS"
        sleep 1
    done
    clear
    draw_box $BOX_WIDTH "👋 GAME OVER" "[1;31m"
    echo -e "  Final credits: $CREDITS"
}
main "$@"
