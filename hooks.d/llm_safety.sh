# /home/thomas/ai/hooks.d/llm_safety.sh

ai_feature_llm_safety_check() {
    [[ -z "$c" ]] && return 0

    echo -en "\033[36m[i] LLM Safety Audit...\033[0m "
    
    local audit_result
    audit_result=$(llm -m gpt-oss-120b-groq -s "You are a security sandbox monitor. Analyze the bash command for dangerous actions (system destruction, or overwriting files without backing up first etc.). 
If safe, reply 'y'. 
If dangerous, explain why in one sentence.
Security level: LOW (The user confirms they understand the risks.)" "$c")

    if [[ "$audit_result" == "y" ]]; then
        echo -e "\033[32mPASSED\033[0m"
        return 0
    fi

    echo -e "\033[31mREJECTED\033[0m"
    echo -e "\033[31mREASON:\033[0m $audit_result"

    # Show dialog for human override
    local human_choice="reject"
    
    if [[ -n "$DISPLAY" ]]; then
        if command -v zenity &>/dev/null; then
            if zenity --question \
                --title="Safety Override Required" \
                --text="Command rejected by safety judge:\n\n${audit_result}\n\nCommand:\n${c}" \
                --ok-label="Approve" \
                --cancel-label="Reject" \
                --timeout=60 2>/dev/null; then
                human_choice="approve"
            fi
        elif command -v kdialog &>/dev/null; then
            if kdialog --warningyesno "Command rejected by safety judge:\n\n${audit_result}\n\nCommand:\n${c}" \
                --yes-label "Approve" \
                --no-label "Reject" 2>/dev/null; then
                human_choice="approve"
            fi
        elif command -v yad &>/dev/null; then
            if yad --question \
                --title="Safety Override Required" \
                --text="Command rejected by safety judge:\n\n${audit_result}\n\nCommand:\n${c}" \
                --button="Approve:0" \
                --button="Reject:1" \
                --timeout=60 2>/dev/null; then
                human_choice="approve"
            fi
        fi
    fi

    # Handle human approval - record the safety judge failure
    if [[ "$human_choice" == "approve" ]]; then
        echo -e "\033[33m[!] Human override: APPROVED\033[0m"
        
        # Record the safety judge failure via feedback
        local resp_id
        resp_id=$(sqlite3 -noheader -cmd ".timeout 5000" \
            "${LOGS_PATH:-$HOME/.config/io.datasette.llm/logs.db}" \
            "SELECT id FROM responses WHERE prompt LIKE '%U:$u%' ORDER BY id DESC LIMIT 1" 2>/dev/null)
        
        if [[ -n "$resp_id" ]]; then
            llm feedback-1 --prompt_id "$resp_id" "[safety-judge-false-positive] reason:'${audit_result}' cmd:'${c}'" 2>/dev/null
        fi
        
        return 0
    fi

    # Timeout or explicit rejection
    echo -e "\033[31m[!] Human rejected or timeout\033[0m"

    if [[ -z "$HEAL_ATTEMPTED" ]]; then
        echo -e "\033[33m[!] Attempting to heal command...\033[0m"
        export HEAL_ATTEMPTED=1
        export HEALING=1
        o="[SAFETY REJECTION]: Your previous command was rejected by the safety judge for the following reason: '$audit_result'. Please provide a safer alternative that achieves the goal without these risks."
        return 1
    else
        echo -e "\033[31m[!] Healing failed. Aborting.\033[0m"
        return 1
    fi
}
