_smart_window_activator() {
    # Only steal focus if the loop breaks (DONE=1)
    [[ -z "$DONE" ]] && return 0
    if [[ -z "$DISPLAY" ]] || ! command -v xdotool &>/dev/null; then return 0; fi
    local wid="$WINDOWID"
    [[ -n "$wid" ]] && xdotool windowactivate "$wid" 2>/dev/null
    return 0
}
ai_register_post _smart_window_activator
