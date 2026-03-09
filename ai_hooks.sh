# ai_hooks.sh

ai_pre_prompt_hook() {
    if [ -z "$FIRST_TURN" ]; then
        # Populate SYS_TOOLS with the FULL content of ai_tools.sh
        SYS_TOOLS="$(cat ~/ai/ai_tools.sh)"
        source ~/ai/ai_tools.sh
        export FIRST_TURN=1
        # Call attachment injection hook
        ai_feature_attachment_inject 2>/dev/null || true
        # Inject full source code as few-shot prompt
        o="[TOOLS]: Full source code follows as few-shot prompt for bash style:
"
        o="${o}
\`\`\`\`bash
$SYS_TOOLS
\`\`\`\`

$o"
    fi
}

ai_feature_clipboard_report() {
    # If this is a spawned sub-agent with a clipboard task ID
    if [[ -n "${CLIPBOARD_TASK_ID:-}" && -f ~/ai/Clip_agent/clip_queue.db ]]; then
        local status="failed"
        local exit_code="${PIPESTATUS:-1}"
        
        if [[ "$DONE" == "1" ]]; then
            status="completed"
            exit_code=0
        elif [[ "$HEALING" == "1" ]]; then
            status="healing"
        fi
        
        sqlite3 ~/ai/Clip_agent/clip_queue.db <<EOSQL
UPDATE clip_queue 
SET status='$status', 
    exit_code=$exit_code, 
    completed_at=$(date +%s),
    healing_attempts = CASE WHEN '$status' = 'healing' THEN healing_attempts + 1 ELSE healing_attempts END
WHERE id='$(echo "$CLIPBOARD_TASK_ID" | sed "s/'/''/g")';
EOSQL
    fi
}

# Default plugin execution order
AI_RESPONSE_PLUGINS=(
    ai_feature_llm_safety_check
    ai_feature_activate_window
    ai_feature_confirm_execution
    ai_feature_clipboard_report
)

ai_handle_response_hook() {
    unset DONE
    source ~/ai/ai_tools.sh
    
    if [[ $c ]]; then
        # Run plugins
        for p in "${AI_RESPONSE_PLUGINS[@]}"; do
            if declare -f "$p" >/dev/null; then
                if ! "$p"; then
                    # If the plugin fails, we check if it requested a 'healing' retry
                    if [[ "$HEALING" == "1" ]]; then
                        unset HEALING
                        return # Return to agent8.sh loop without setting DONE=1
                    else
                        DONE=1
                        return
                    fi
                fi
            fi
        done

        # Reset heal counter on successful execution
        unset HEAL_ATTEMPTED

        # Case 1: Correction on Turn 2
        if [[ -n "$PENDING_FEEDBACK_ID" ]]; then
            llm feedback-1 --prompt_id "$PENDING_FEEDBACK_ID" "[err:formatting] turn:1" > /dev/null 2>&1
            unset PENDING_FEEDBACK_ID
        elif [[ -z "$HAD_FIRST_RESPONSE" ]]; then
            resp_id=$(sqlite3 -noheader -cmd ".timeout 5000" /home/thomas/.config/io.datasette.llm/logs.db "SELECT id FROM responses ${u:+WHERE prompt LIKE '%U:$u%'} ORDER BY id DESC LIMIT 1" 2>/dev/null)
            llm feedback+1 --prompt_id "$resp_id" "[ok:formatting]" > /dev/null 2>&1
            export HAD_FIRST_RESPONSE=1
        fi


        printf '%s\n' "source ~/ai/ai_tools.sh" "$c" > /tmp/ai_code_$u.sh
        script -q -e -c "bash /tmp/ai_code_$u.sh" /tmp/ai_out_$u
        exit_code=$?
        o=$(cat /tmp/ai_out_$u)
        echo -e "\033[35mEXIT CODE:\033[0m $exit_code"
        d=$(sqlite3 -noheader -cmd ".timeout 5000" /home/thomas/.config/io.datasette.llm/logs.db "SELECT conversation_id FROM responses ${u:+WHERE prompt LIKE '%U:$u%'} ORDER BY id DESC LIMIT 1" 2>/dev/null)
    elif [[ -z $HAD_FIRST_RESPONSE ]]; then
        export HAD_FIRST_RESPONSE=1 
        o="[SYSTEM WARNING]: No code block detected. Use \`\`\`\` to execute bash or reply 'NO OP'."
        d=$(sqlite3 -noheader -cmd ".timeout 5000" /home/thomas/.config/io.datasette.llm/logs.db "SELECT conversation_id FROM responses ORDER BY id DESC LIMIT 1" 2>/dev/null)
    else
        DONE=1
    fi
}

export P="ai_pre_prompt_hook"
export R="ai_handle_response_hook"

if [[ -d ~/ai/hooks.d ]]; then
    for plugin in ~/ai/hooks.d/*.sh; do source "$plugin"; done
fi

export -f ai_pre_prompt_hook ai_handle_response_hook

for f in ai_feature_llm_safety_check ai_feature_activate_window ai_feature_confirm_execution ai_feature_clipboard_report; do
    declare -f "$f" >/dev/null && export -f "$f"
done

# Inject attachment flags into the llm command via P hook
ai_feature_attachment_inject() {
    if [[ ${#ATTACHMENT_QUEUE[@]} -gt 0 ]]; then
        local attach_flags=""
        for f in "${ATTACHMENT_QUEUE[@]}"; do
            attach_flags="$attach_flags -a $f"
        done
        # Store for agent8.sh to use - we set a variable it can read
        export ATTACH_FLAGS="$attach_flags"
        echo "[HOOK] Attachment flags prepared: $attach_flags"
    fi
}

# Prepend to pre-prompt hooks
AI_PRE_PROMPT_HOOKS=("ai_feature_attachment_inject" "${AI_PRE_PROMPT_HOOKS[@]:-}")
