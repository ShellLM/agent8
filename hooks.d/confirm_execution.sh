# /home/thomas/ai/hooks.d/confirm_execution.sh

ai_feature_confirm_execution() {
    # If AUTO_CONFIRM is set, skip the prompt
    if [[ "$AI_AUTO_CONFIRM" == "1" ]]; then
        return 0
    fi

    echo -e "\n\033[33m[?] Execute command? (y/N)\033[0m"
    echo -e "\033[34mCOMMAND:\033[0m $c"
    
    # Open /dev/tty on fd 3 and verify it's actually a terminal
    if exec 3</dev/tty 2>/dev/null && [[ -t 3 ]]; then
        if [[ -n $ZSH_VERSION ]]; then
            read -r -k 1 "REPLY?[Confirm] " <&3
        else
            read -r -p "[Confirm] " -n 1 <&3
        fi
        exec 3<&-
    else
        # No usable tty available
        exec 3<&- 2>/dev/null
        echo "[AUTO-CONFIRM] No tty available, proceeding"
        return 0
    fi
    echo
    
    [[ $REPLY =~ ^[Yy]$ ]] || return 1
    return 0
}
