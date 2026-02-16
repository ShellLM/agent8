#!/bin/bash

# EMERGENT_UX_OS v1.3.0 // The Synaptic Interface
# A pure bash TUI utilizing ANSI escape codes for high performance.

# Terminal Setup
tput civis # Hide cursor
trap 'tput cnorm; clear; exit' SIGINT SIGTERM

# Colors & Styles
C_BG='\033[48;5;232m'
C_HOT='\033[38;5;201m'  # Magenta/Pink
C_COLD='\033[38;5;51m'   # Cyan
C_NEURAL='\033[38;5;226m' # Yellow
C_VOID='\033[38;5;240m'   # Grey
C_TEXT='\033[38;5;253m'
C_STAB='\033[38;5;123m'
C_RESET='\033[0m'
BOLD='\033[1m'

# State Variables
ITER=0
STABILITY=98
LOAD=5
LOGS=()
MAX_LOGS=$(($(tput lines) / 3))

# Logic: Responsive Box Drawing (Fixes the printf error)
draw_hr() {
    local len=$1
    local char=${2:-"─"}
    local out=""
    for ((i=0; i<len; i++)); do out+="$char"; done
    echo -n "$out"
}

add_log() {
    LOGS+=("$(date +%H:%M:%S) >> $1")
    if [ ${#LOGS[@]} -gt $MAX_LOGS ]; then
        LOGS=("${LOGS[@]:1}")
    fi
}

# Initial Logs
add_log "SYNEPTIC_CORE_LOADED"
add_log "LATENT_SPACE_SURVEY_COMPLETE"
add_log "EMERGENT_UX_OS: STANDING BY"

render() {
    local cols=$(tput cols)
    local lines=$(tput lines)
    
    # Update state
    ((ITER++))
    STABILITY=$(( 90 + RANDOM % 10 ))
    LOAD=$(( (RANDOM % 40) + 10 ))
    
    # 1. Header
    echo -ne "${C_BG}\033[H" # Go home
    echo -ne "${BOLD}${C_HOT} ◢◤ EMERGENT_UX_OS ${C_VOID}v1.3.0${C_RESET}"
    printf "\033[1;%dH${C_STAB}SYS_STABILITY: %d%%${C_RESET}" $((cols - 20)) "$STABILITY"
    
    # 2. Topology Box (Left)
    local top_w=30
    local top_h=12
    echo -ne "\033[3;2H${C_COLD}┌─┤ ${BOLD}NEURAL_TOPOLOGY ${C_RESET}${C_COLD}"
    draw_hr $((top_w - 18))
    echo -ne "┐"
    for ((i=0; i<top_h; i++)); do
        echo -ne "\033[$((4+i));2H│"
        echo -ne "\033[$((4+i));$((top_w+1))H│"
    done
    echo -ne "\033[$((4+top_h));2H└"
    draw_hr $((top_w - 2))
    echo -ne "┘${C_RESET}"
    
    # Render "Emergent" Nodes
    for ((y=0; y<5; y++)); do
        for ((x=0; x<5; x++)); do
            local dot_col=$((5 + x * 5))
            local dot_row=$((5 + y * 2))
            # Logic for flickering nodes
            if [ $(( (RANDOM % 100) + (ITER % 10) )) -gt 70 ]; then
                echo -ne "\033[${dot_row};${dot_col}H${C_NEURAL}●"
            else
                echo -ne "\033[${dot_row};${dot_col}H${C_VOID}○"
            fi
        done
    done

    # 3. Data Stream Box (Right)
    local stream_x=$((top_w + 3))
    local stream_w=$((cols - stream_x - 2))
    echo -ne "\033[3;${stream_x}H${C_HOT}┌─┤ ${BOLD}DATA_STREAM ${C_RESET}${C_HOT}"
    draw_hr $((stream_w - 14))
    echo -ne "┐"
    for ((i=0; i<top_h; i++)); do
        echo -ne "\033[$((4+i));${stream_x}H│"
        echo -ne "\033[$((4+i));$((stream_x + stream_w - 1))H│"
    done
    echo -ne "\033[$((4+top_h));${stream_x}H└"
    draw_hr $((stream_w - 2))
    echo -ne "┘${C_RESET}"
    
    # Render Logs
    local log_idx=0
    for log in "${LOGS[@]}"; do
        echo -ne "\033[$((4 + log_idx));$((stream_x + 2))H${C_TEXT}${log:0:$((stream_w - 4))}${C_RESET}"
        ((log_idx++))
    done

    # 4. Progress Bar (Bottom)
    local bar_y=$((lines - 3))
    local bar_w=$((cols - 25))
    echo -ne "\033[${bar_y};4H${C_STAB}COGNITION_LOAD: ${C_RESET}["
    local fill=$(( LOAD * bar_w / 100 ))
    echo -ne "${C_NEURAL}"
    draw_hr "$fill" "#"
    echo -ne "${C_VOID}"
    draw_hr $((bar_w - fill)) "░"
    echo -ne "${C_RESET}]"

    # Footer
    echo -ne "\033[$((lines - 1));2H${C_VOID}Press Ctrl+C to abort...${C_RESET}"
}

# Main Loop
clear
while true; do
    render
    
    # Procedural log generation
    if [ $((ITER % 5)) -eq 0 ]; then
        case $((RANDOM % 4)) in
            0) add_log "HEURISTIC_BRANCH_SYNCED: $((RANDOM % 0xFFF))" ;;
            1) add_log "INTERFACE_EVOLUTION_STEP: $((ITER / 5))" ;;
            2) add_log "LATENT_SPACE_MAPPING..." ;;
            3) add_log "SYNAPTIC_WEIGHTS_ADJUSTED" ;;
        esac
    fi
    
    sleep 0.2
done
