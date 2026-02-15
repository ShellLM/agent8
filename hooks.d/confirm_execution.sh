# /home/thomas/ai/hooks.d/confirm_execution.sh

ai_feature_confirm_execution() {
    # If AUTO_CONFIRM is set, skip the prompt
    if [[ "$AI_AUTO_CONFIRM" == "1" ]]; then
        return 0
    fi

    echo -e "\n\033[33m[?] Execute command? (y/N)\033[0m"
    echo -e "\033[34mCOMMAND:\033[0m $c"
    
    local input_src="/dev/stdin"
    [[ -t 0 ]] && input_src="/dev/tty"

    if [[ -n $ZSH_VERSION ]]; then
        read -r -k 1 "REPLY?[Confirm] " -u 3 3<"$input_src"
    else
        read -r -p "[Confirm] " -n 1 -u 3 3<"$input_src"
    fi
    echo
    
    [[ $REPLY =~ ^[Yy]$ ]] || return 1
    return 0
}
