# ai_hooks.sh

ai_pre_prompt_hook() {
    if [ -z "$FIRST_TURN" ]; then
        SYS_TOOLS="$(<./ai_tools.sh)"
        export FIRST_TURN=1
    fi
}

# Default plugin execution order
AI_RESPONSE_PLUGINS=(
    ai_feature_llm_safety_check
    ai_feature_activate_window
    ai_feature_confirm_execution
)

ai_handle_response_hook() {
    unset DONE
    source ./ai_tools.sh
    
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
            resp_id=$(sqlite3 -cmd ".timeout 5000" "$(llm logs path)" "SELECT id FROM responses ${u:+WHERE prompt LIKE '%U:$u%'} ORDER BY id DESC LIMIT 1")
            llm feedback+1 --prompt_id "$resp_id" "[ok:formatting]" > /dev/null 2>&1

            export HAD_FIRST_RESPONSE=1
        fi

        cat <<EOF > /tmp/ai_code_$u.sh
source ./ai_tools.sh
$c
EOF
        script -q -e -c "bash /tmp/ai_code_$u.sh" /tmp/ai_out_$u_$u_$u
        exit_code=$?
        o=$(cat /tmp/ai_out_$u_$u_$u)
        echo -e "\033[35mEXIT CODE:\033[0m $exit_code"
        d=$(sqlite3 -cmd ".timeout 5000" "$(llm logs path)" "SELECT conversation_id FROM responses ${u:+WHERE prompt LIKE '%U:$u%'} ORDER BY id DESC LIMIT 1")
    elif [[ -z $HAD_FIRST_RESPONSE ]]; then
        export HAD_FIRST_RESPONSE=1
        o="[SYSTEM WARNING]: No code block detected. Use \`\`\`\` to execute bash or reply 'NO OP'."
        d=$(sqlite3 -cmd ".timeout 5000" "$(llm logs path)" "SELECT conversation_id FROM responses ORDER BY id DESC LIMIT 1")
    else
        DONE=1
    fi
}

export P="ai_pre_prompt_hook"
export R="ai_handle_response_hook"

if [[ -d ./hooks.d ]]; then
    for plugin in ./hooks.d/*.sh; do source "$plugin"; done
fi
export -f ai_pre_prompt_hook ai_handle_response_hook
for f in ai_feature_llm_safety_check ai_feature_activate_window ai_feature_confirm_execution; do
    declare -f "$f" >/dev/null && export -f "$f"
done
