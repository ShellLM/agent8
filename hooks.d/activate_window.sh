# /home/thomas/ai/hooks.d/activate_window.sh

ai_feature_activate_window() {
    # Only run if X11 is available and xdotool is installed
    if [[ -z "$DISPLAY" ]] || ! command -v xdotool &>/dev/null; then
        return 0
    fi
    
    local wid="$WINDOWID"
    if [[ -z $wid ]]; then
        local cp=$$
        while [[ $cp -gt 1 ]]; do
            # Search for windows owned by this process ID or its parents
            wid=$(xdotool search --pid "$cp" 2>/dev/null | tail -n 1)
            [[ -n $wid ]] && break
            cp=$(ps -o ppid= -p "$cp" | tr -d ' ')
        done
    fi
    
    if [[ -n $wid ]]; then
        xdotool windowactivate "$wid" 2>/dev/null
    fi
    return 0
}
