groq_chat () {
	local history_file=".groq_chat_history" 
	local continue_mode=0 
	local model="moonshotai/kimi-k2-instruct-0905"
	local user_prompt
	while [[ "$1" == "-"* ]]; do
		case "$1" in
			-c)
				continue_mode=1 
				shift
				;;
			-m)
				model="$2"
				shift 2
				;;
			*)
				break
				;;
		esac
	done
	if [ $# -gt 0 ]
	then
		user_prompt="$*" 
		[ ! -t 0 ] && user_prompt="$user_prompt

$(cat)" 
	else
		[ ! -t 0 ] && user_prompt=$(cat) 
	fi
	local messages_json
	if [[ $continue_mode -eq 1 && -f "$history_file" ]]
	then
		messages_json=$(cat "$history_file") 
	else
		messages_json='[]' 
	fi
	local response
	response=$(jq -n \
        --argjson history "$messages_json" \
        --arg content "$user_prompt" \
        --arg model "$model" \
        '{
            model: $model,
            messages: $history + [{ role: "user", content: $content }]
        }' | curl -sX POST https://api.groq.com/openai/v1/chat/completions \
            -H "Authorization: Bearer $GROQ_API_KEY" \
            -H "Content-Type: application/json" \
            --data-binary @- | jq -r '.choices[0].message.content // empty') 
	jq -n --argjson history "$messages_json" --arg user "$user_prompt" --arg assistant "$response" '$history + [{role: "user", content: $user}, {role: "assistant", content: $assistant}]' > "$history_file"
	printf '%s\n' "$response"
}
