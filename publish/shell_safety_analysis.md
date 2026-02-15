# Shell Safety Analysis
The agent uses a dual-layer safety approach:
1. **Pattern Matching**: Intercepts known dangerous patterns (rm -rf, fork bombs) via 'guard' function.
2. **LLM Audit**: Commands are audited by a high-parameter model (gpt-oss-120b) before execution.
3. **Healing Loop**: If a command is rejected, the agent receives the reasoning and attempts to reformulate a safe alternative.
