#!/bin/bash
# ai_assistant_safe.sh - A safe, non-persistent AI command generator.

# Check if the 'llm' CLI tool is available
if ! command -v llm &> /dev/null; then
    echo "Error: 'llm' CLI tool not found. Please ensure it is installed and configured."
    exit 1
fi

echo "--- AI Command Advisor ---"
echo "Describe the task you want to perform (or type 'exit' to quit)."

while true; do
    read -p "Task > " TASK
    [[ "$TASK" == "exit" ]] && break
    [[ -z "$TASK" ]] && continue

    # Fetch suggestion from the LLM
    # The prompt is strictly scoped to return only the command.
    SUGGESTION=$(llm "Provide a single-line bash command to: $TASK. Return ONLY the command text, no markdown.")

    echo -e "\n\033[1;33mProposed Command:\033[0m"
    echo -e "\033[1;32m  $SUGGESTION\033[0m"
    echo "--------------------------------------------------------"
    echo "Review the command above. You can copy and run it manually"
    echo "if it matches your expectations."
    echo ""
done
