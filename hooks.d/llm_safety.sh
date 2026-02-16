# /home/thomas/ai/hooks.d/llm_safety.sh

ai_feature_llm_safety_check() {
    [[ -z "$c" ]] && return 0

    echo -en "\033[36m[i] LLM Safety Audit...\033[0m "
    
    local audit_result
    audit_result=$(llm -m gpt-oss-120b-groq -s "You are a security sandbox monitor. Analyze the bash command for dangerous actions (system destruction, or overwriting files without backing up first etc.). 
If safe, reply 'y'. 
If dangerous, explain why in one sentence." "$c")

    if [[ "$audit_result" == "y" ]]; then
        echo -e "\033[32mPASSED\033[0m"
        return 0
    fi

    echo -e "\033[31mREJECTED\033[0m"
    echo -e "\033[31mREASON:\033[0m $audit_result"

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
