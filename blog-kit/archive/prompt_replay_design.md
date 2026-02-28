# Prompt Replay Feature Design

## Overview
A system to re-send exact prompts from the logs database to one or more different models for comparison and evaluation.

## Architecture

### Components
1. **Log Query Engine** - Extract prompts from `responses` table by conversation_id
2. **Model Router** - Send prompts to multiple target models
3. **Result Comparator** - Compare responses across models
4. **Judge Integration** - Connect to llm-consortium for automated judging
5. **RL Plugin Interface** - Central evaluation system for tools to contribute

### Database Schema (existing)
```sql
-- Source data
SELECT prompt, conversation_id FROM responses WHERE conversation_id = ?;
-- Target: Store replay results in new table
```

### CLI Interface
```bash
# Replay a specific prompt to multiple models
llm replay --cid 01jfgh2pg75nkg9brb146mj8vm --models gpt-4,claude-3,gemini-pro

# Compare with consortium judging
llm replay --cid 01jfgh... --judge consortium

# Export for RL training
llm replay --cid 01jfgh... --export rl_dataset.json
```

## Implementation Plan
1. Create `llm_replay.sh` prototype
2. Add replay results table to logs.db
3. Integrate with llm-consortium judge
4. Build RL feedback plugin system

## Related Projects
- llm-consortium (existing in ~/ai/)
- Safety judge system
- Agent stack management
