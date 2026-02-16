#!/bin/bash
# Agent8 Orchestrator v1.1 - Phase 3 Core
# Monitoring the synaptic swarm.

# Path Resolution
BASE_DIR=$(pwd)
AGENT_CORE="$BASE_DIR/agent8_mini.sh"
CONSENSUS_LOG="$HOME/ai/consensus_chain.log"
[[ ! -f "$CONSENSUS_LOG" ]] && CONSENSUS_LOG="$BASE_DIR/consensus_chain.log"

# UI Setup
TERM_WIDTH=$(tput cols); TERM_HEIGHT=$(tput lines)
C_FG=$(tput setaf 6); C_ACC=$(tput setaf 5); C_DIM=$(tput setaf 8); C_RES=$(tput sgr0); BOLD=$(tput bold)
trap 'tput cnorm; clear; exit' SIGINT SIGTERM

# State
LOG_MESSAGES=("Orchestrator Online." "Searching for Ledger: $CONSENSUS_LOG")
WORKER_PIDS=()
PREV_LOG_HASH=""

add_log() {
    LOG_MESSAGES+=("$(date +%H:%M:%S) » $1")
    [[ ${#LOG_MESSAGES[@]} -gt $((TERM_HEIGHT - 13)) ]] && LOG_MESSAGES=("${LOG_MESSAGES[@]:1}")
}

draw_box() {
    local y=$1 x=$2 h=$3 w=$4 title=$5
    tput cup $y $x
    echo -n "${C_ACC}┌─┤ ${BOLD}$title ${C_RES}${C_ACC}$(printf '─%.0s' $(seq 1 $((w - 6 - ${#title}))))┐"
    for ((i=1; i<h-1; i++)); do tput cup $((y + i)) $x; echo -n "│$(printf ' %.0s' $(seq 1 $((w - 2))))│"; done
    tput cup $((y + h - 1)) $x; echo -n "└$(printf '─%.0s' $(seq 1 $((w - 2))))┘${C_RES}"
}

spawn_agent() {
    local id=$1
    local task=$2
    add_log "DISPATCH: Agent $id -> $task"
    ( P="$task" bash "$AGENT_CORE" >> "worker$id.log" 2>&1 ) &
    WORKER_PIDS[$id]=$!
}

render() {
    tput cup 0 0
    echo -n "${BOLD}${C_ACC} ▟████▙ AGENT8_ORCHESTRATOR // ${C_FG}LEDGER: $([[ -f "$CONSENSUS_LOG" ]] && echo "SYNCED" || echo "LOST") ${C_RES}"
    
    # Status Sidebar
    draw_box 2 2 $((TERM_HEIGHT - 6)) 28 "SUB_NETWORKS"
    for i in {1..5}; do
        tput cup $((2 + i)) 4
        if [[ -n "${WORKER_PIDS[$i]}" ]] && kill -0 "${WORKER_PIDS[$i]}" 2>/dev/null; then
            echo -n "${C_FG}●${C_RES} AGENT_$i ${C_FG}[BUSY]${C_RES}"
        else
            echo -n "${C_DIM}○ AGENT_$i [IDLE]${C_RES}"
        fi
    done

    # Live Log Stream
    draw_box 2 32 $((TERM_HEIGHT - 10)) $((TERM_WIDTH - 35)) "SYNAPTIC_STREAM"
    local count=0
    for msg in "${LOG_MESSAGES[@]}"; do
        tput cup $((3 + count)) 34
        echo -n "${C_FG}${msg:0:$((TERM_WIDTH - 38))}${C_RES}"
        ((count++))
    done

    # Vitals
    tput cup $((TERM_HEIGHT - 8)) 34
    echo -n "${C_DIM}Last Consensus Block: $(tail -n 1 "$CONSENSUS_LOG" 2>/dev/null | cut -c1-40)${C_RES}"

    # Footer
    tput cup $((TERM_HEIGHT - 2)) 2
    echo -n "${BOLD}${C_ACC}COMMAND (ID TASK):${C_RES} "
}

# Initial Check
[[ -f "$CONSENSUS_LOG" ]] && add_log "Ledger linked successfully."

# Main Loop
clear; tput civis
while true; do
    render
    read -t 0.8 -p "" cmd
    if [[ $? -eq 0 && -n "$cmd" ]]; then
        if [[ "$cmd" == "exit" ]]; then break; fi
        if [[ "$cmd" =~ ^([1-5])\ (.*) ]]; then
            spawn_agent "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}"
        else
            add_log "Invalid Format. Use: '1 status check'"
        fi
        clear
    fi
    
    # Check for Ledger Updates
    if [[ -f "$CONSENSUS_LOG" ]]; then
        NEW_HASH=$(md5sum "$CONSENSUS_LOG")
        if [[ "$NEW_HASH" != "$PREV_LOG_HASH" ]]; then
            add_log "NEW_BLOCK: $(tail -n 1 "$CONSENSUS_LOG" | awk -F'|' '{print $2 " -> " $4}')"
            PREV_LOG_HASH="$NEW_HASH"
        fi
    fi
done
