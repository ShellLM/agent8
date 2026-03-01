_core_executor() {
    if [[ -n "$c" ]]; then
        export HAD_FIRST_RESPONSE=1
        cat <<INNEREOF > "/tmp/ai_code_$u.sh"
source ~/ai/ai_tools.sh 2>/dev/null
$c
INNEREOF
        script -q -e -c "bash /tmp/ai_code_$u.sh" "/tmp/ai_out_$u"
        local exit_code=$?
        o=$(cat "/tmp/ai_out_$u")
        echo -e "[35mEXIT CODE:[0m $exit_code"
        d=$(sqlite3 -noheader -cmd ".timeout 5000" ~/.config/io.datasette.llm/logs.db "SELECT conversation_id FROM responses ${u:+WHERE prompt LIKE '%U:$u%'} ORDER BY id DESC LIMIT 1" 2>/dev/null)
        unset HEAL_ATTEMPTED
    elif [[ -z "$HAD_FIRST_RESPONSE" ]]; then
        export HAD_FIRST_RESPONSE=1 
        o="[SYSTEM WARNING]: No code block detected. Use \`\`\`\` to execute bash or reply 'NO OP'."
        d=$(sqlite3 -noheader -cmd ".timeout 5000" ~/.config/io.datasette.llm/logs.db "SELECT conversation_id FROM responses ORDER BY id DESC LIMIT 1" 2>/dev/null)
    else
        DONE=1
    fi
    return 0
}
ai_register_post _core_executor
