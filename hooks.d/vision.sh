ai_feature_vision_announce() {
    # If this is the first turn, we append a capability notice to the system prompt
    # Since agent8.sh does: r=$(llm -s "$(<"$0")" ...), we can inject into the environment
    # that gets sourced.
    :
}

# We can actually use the P hook to inject a capability hint into the prompt
vision_pre_prompt() {
    if [[ -z "$HAD_FIRST_RESPONSE" ]]; then
        # This text will be seen by the LLM in the U: block on turn 1
        o="[CAPABILITY]: You have 'eyes'. If you need to see the screen to answer, execute \`read_screen\` But only do so when you need to visualy inspect something. You can also attach other image files using llm --cid cid -a path/to/image.
$o"
    fi
}

# Add to the pre-prompt hook chain
# We wrap the existing P if it exists
ORIG_P="$P"
P="vision_pre_prompt; $ORIG_P"
