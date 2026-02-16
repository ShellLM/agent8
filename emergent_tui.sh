#!/bin/bash

# Emergent UX Architect v1.1.0
# Features: Non-blocking UI loop, dynamic system vitals, "alive" log stream.

TERM_WIDTH=$(tput cols)
TERM_HEIGHT=$(tput lines)
C_BG=$(tput setab 0)
C_FG=$(tput setaf 6)
C_ACC=$(tput setaf 5)
C_DIM=$(tput setaf 8)
C_WARN=$(tput setaf 1)
C_RES=$(tput sgr0)
BOLD=$(tput bold)

# State
MODE="NEURAL"
LOG_MESSAGES=("Core synchronized." "Awaiting intent signal...")
CPU_LOAD=0
ITERATION=0
OSCILLATOR=0

# Helper for drawing boxes
draw_box() {
    local y=$1 x=$2 h=$3 w=$4 title=$5
    tput cup $y $x
    echo -n "${C_ACC}┌─┤ ${BOLD}$title ${C_RES}${C_ACC}$(printf '─%.0s' $(seq 1 $((w - 6 - ${#title}))))┐"
    for ((i=1; i<h-1; i++)); do
        tput cup $((y + i)) $x
        echo -n "│$(printf ' %.0s' $(seq 1 $((w - 2))))│"
    done
    tput cup $((y + h - 1)) $x
    echo -n "└$(printf '─%.0s' $(seq 1 $((w - 2))))┘${C_RES}"
}

update_vitals() {
    ITERATION=$((ITERATION + 1))
    OSCILLATOR=$(echo "scale=2; s($ITERATION/5)*50 + 50" | bc -l | cut -d. -f1)
    CPU_LOAD=$(( (RANDOM % 15) + 5 ))
    if [ $((ITERATION % 20)) -eq 0 ]; then
        add_log "Entropy shift detected: $((RANDOM % 100))ms latency."
    fi
}

draw_ui() {
    # Header
    tput cup 0 0
    echo -n "${BOLD}${C_ACC} ▟████▙ EMERGENT_UX_OS // ${C_FG}SYS_ID: 0x$(date +%s | tail -c 4) // MODE: $MODE ${C_RES}"
    
    # Sidebar: Nodes
    draw_box 2 2 $((TERM_HEIGHT - 6)) 25 "TOPOLOGY"
    for ((i=0; i<TERM_HEIGHT-10; i++)); do
        tput cup $((3 + i)) 4
        if [ $((OSCILLATOR % (i+1))) -eq 0 ]; then
            echo -n "${C_FG}●${C_RES} NODE_$(printf "%03d" $i) ${C_DIM}ACTIVE"
        else
            echo -n "${C_DIM}○ NODE_$(printf "%03d" $i) STANDBY"
        fi
    done

    # Main Log
    draw_box 2 29 $((TERM_HEIGHT - 10)) $((TERM_WIDTH - 32)) "LOG_STREAM"
    local count=0
    for msg in "${LOG_MESSAGES[@]}"; do
        tput cup $((3 + count)) 31
        echo -n "${C_FG}» ${C_RES}$msg"
        ((count++))
    done

    # Vitals
    draw_box $((TERM_HEIGHT - 7)) 29 4 $((TERM_WIDTH - 32)) "VITALS"
    tput cup $((TERM_HEIGHT - 6)) 31
    echo -n "${C_FG}NEURAL_SYNC: ${C_RES}[$(printf '#%.0s' $(seq 1 $((OSCILLATOR/5))))$(printf ' %.0s' $(seq 1 $((20 - OSCILLATOR/5))))] ${OSCILLATOR}%"
    tput cup $((TERM_HEIGHT - 5)) 31
    echo -n "${C_FG}THOUGHT_LOAD: ${C_RES}${CPU_LOAD}.$(($RANDOM%9)) Gflops"

    # Input area
    tput cup $((TERM_HEIGHT - 2)) 2
    echo -n "${BOLD}${C_ACC}CMD_INPUT_λ:${C_RES} "
}

add_log() {
    LOG_MESSAGES+=("$1")
    local max_logs=$((TERM_HEIGHT - 13))
    if [ ${#LOG_MESSAGES[@]} -gt $max_logs ]; then
        LOG_MESSAGES=("${LOG_MESSAGES[@]:1}")
    fi
}

# Main Loop
clear
tput civis
trap 'tput cnorm; clear; exit' SIGINT SIGTERM

while true; do
    update_vitals
    draw_ui
    
    # Non-blocking input trick
    read -t 0.5 -p "" cmd
    if [ $? -eq 0 ]; then
        if [[ "$cmd" == "exit" ]]; then break; fi
        if [[ -n "$cmd" ]]; then
            add_log "Executing: $cmd"
            # Interactive responses
            if [[ "$cmd" == "pulse" ]]; then 
                MODE="PULSING"
                add_log "Broadcasting neural pulse..."
            elif [[ "$cmd" == "clear" ]]; then
                LOG_MESSAGES=()
            else
                add_log "Result: SUCCESS (L-$(($RANDOM%9)) )"
            fi
        fi
        clear
    fi
done

tput cnorm
clear
