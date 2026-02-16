count_tokens () {
	[ ! -t 0 ] && i=$(cat) 
	echo $((${#1}/4 + ${#i}/4))
}
alias tk=count_tokens

get_cid_from_response () {
	local search_string="$1" 
	sqlite3 -noheader -init /dev/null $LOGS_PATH "SELECT conversation_id FROM (SELECT * FROM responses 
ORDER BY id DESC LIMIT 10) 
WHERE response LIKE '%${search_string}%' 
ORDER BY datetime_utc DESC LIMIT 1;" 2> /dev/null
}

llm-last-cid () {
	sqlite3 -noheader "$LLM_LOGS_DB" "
    SELECT conversation_id 
    FROM responses 
    ORDER BY datetime_utc DESC 
    LIMIT 1;"
}

get_cid_from_prompt () {
	local search_string="$1" 
	sqlite3 -noheader -init /dev/null $(llm logs path) \
	"SELECT conversation_id FROM (SELECT * FROM responses ORDER BY id DESC LIMIT 10) \
	WHERE prompt LIKE '%${search_string}%' \
	ORDER BY datetime_utc DESC LIMIT 1;" 2> /dev/null
}

focusactive () {
	local wid="${1:-$(xdotool getactivewindow)}" 
	if [ -z "$1" ]
	then
		echo "$wid"
	else
		xdotool windowmap --sync "$wid"
		xdotool windowactivate "$wid"
	fi
}

recai() { 
 local dir_name=$(basename "$(pwd)" | cut -c1-15)
 local datetime=$(date +%Y%m%d%H%M) 
 local filename="ai_${dir_name}_${datetime}.cast"
 local filepath="$HOME/ai/Recordings/$filename"
 mkdir -p "$HOME/ai" 
 asciinema rec "$filepath" --return --append --quiet --idle-time-limit 3 --capture-input --log-file $HOME/ai/recai.log
}

google_search() {

	if [ -z "$GOOGLE_SEARCH_KEY" ] || [ -z "$GOOGLE_SEARCH_ID" ]; then
		echo "Error: Set GOOGLE_SEARCH_KEY and GOOGLE_SEARCH_ID environment variables"
		exit 1
	fi

	QUERY="$1"
	NUM="${2:-10}"

	if [ -z "$QUERY" ]; then
		echo "Usage: $0 <search_query> [num_results]"
		exit 1
	fi

	# URL encode the query (simple version)
	ENCODED_QUERY=$(echo "$QUERY" | sed 's/ /%20/g' | sed 's/!/%21/g' | sed 's/#/%23/g' | sed 's/\$/%24/g' | sed 's/&/%26/g' | sed "s/'/%27/g" | sed 's/(/%28/g' | sed 's/)/%29/g' | sed 's/\*/%2A/g' | sed 's/+/%2B/g' | sed 's/,/%2C/g' | sed 's/:/%3A/g' | sed 's/;/%3B/g' | sed 's/=/%3D/g' | sed 's/?/%3F/g' | sed 's/@/%40/g')

	# Build API URL
	API_URL="https://www.googleapis.com/customsearch/v1?key=${GOOGLE_SEARCH_KEY}&cx=${GOOGLE_SEARCH_ID}&q=${ENCODED_QUERY}&num=${NUM}"

	# Make the API call and display results
	curl -s "$API_URL" | jq -r '.items[] | "Title: \(.title)\nLink: \(.link)\nSnippet: \(.snippet)\n"'
}

read_screen() {
    local t=$(date +%s); local img="$HOME/.cache/ai_screen/$t.png"
    if command -v scrot >/dev/null 2>&1; then scrot -o "$img" >/dev/null 2>&1
    elif command -v spectacle >/dev/null 2>&1; then spectacle -b -n -o "$img" >/dev/null 2>&1
    else import -window root "$img" >/dev/null 2>&1; fi

    [ ! -f "$img" ] && sleep 1
    if [ -f "$img" ]; then
        local cid=$(sqlite3 -noheader "$(llm logs path)" "SELECT conversation_id FROM responses ORDER BY id DESC LIMIT 1")
        echo "--- SCREEN ANALYSIS START ---"
        llm -a "$img" "Analyze screen capture $t. Describe the active task context."
        echo "--- SCREEN ANALYSIS END ---"
        # We don't delete to avoid [Errno 2] when llm continues the conversation
    else echo "Error: Capture tool failed."; fi
}



# Agent Spawn Tool for Parallel Execution
spawn() {
    local task_desc="$1"
    local sub_u=$(uuidgen)
    echo "[SPAWN] Launching sub-agent for task: $task_desc"
    # Execute a sub-agent with a specific task-focused system prompt
    (o="[SUB-TASK]: $task_desc" bash ./agent8.sh --cid "$(llm-last-cid)" > "logs/sub-agents/$sub_u.log" 2>&1) &
    echo "[SPAWN] Sub-agent PID $! started. Output: logs/sub-agents/$sub_u.log"
}

# Sync tool to wait for background workers
gather() {
    echo "[SYNC] Waiting for all background tasks to complete..."
    wait
    echo "[SYNC] All tasks finished."
}
