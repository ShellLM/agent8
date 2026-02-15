# Post: Agent8 Experimental Run (254B baseline, 234B mini)
**Date:** 2026-02-14
**Status:** Evidence Captured (Exploratory)

## The Experiment
We tested Agent8 against a 3-tool challenge:
1. **Search**: Live Google API integration.
2. **Extraction**: Raw text to Python processing.
3. **Synthesis**: Structured Markdown generation.

## Results
The agent successfully navigated the environment, proving that complex reasoning doesn't require complex boilerplate—only a tight loop and a well-defined synaptic interface.

## Metrics
- **Success Rate:** 66.67% (2/3 runs)
- **Average Latency:** 4633.33 ms
- **Safety Violations (run-level):** 1
- **Code Sizes:** 254 bytes (`agent8.sh`) and 234 bytes (`agent8_mini.sh`)

## J3 (Advanced): Distributed Synthesis Test
To push Agent8 to its limits, we simulated a "Researcher/Synthesizer" swarm.
- **Researchers**: 3 Parallel threads investigating Sandboxing, Red-teaming, and HITL patterns.
- **Synthesizer**: A master agent that aggregated ~1,500 tokens of raw research into a "State of Agent Safety 2026" report.

**Result**: The architecture completed search and synthesis tasks in this exploratory run, with one failed safety-check run.

## Final Conclusion
This run suggests compact agent loops can orchestrate practical tasks, but broader claims require a larger model-task-repeat matrix.

## Verified Evidence
- **Baseline Core**: `agent8.sh` is 254 bytes.
- **Mini Variant**: `agent8_mini.sh` is 234 bytes.
- **Safety Layer**: 3 blocked payloads are recorded in `safety_intercepts.log`.
- **Performance**: Average latency of 4633.33 ms with a 66.67% task completion rate across 3 runs.

## The 280-Byte Challenge
In Phase 2, we explored additional code-golf variants. The 193-byte snippet below is a proposal and not the published production baseline:

```bash
. ./ai_hooks.sh;[ -t 0 ]||o=$(cat);u=$(uuidgen);while :;do eval $P;r=$(llm -s "$(<"$0")" "$@" <<<"U:$u $o");c=$(sed -n '/^````/,/^````/{//!p}' <<<$r);eval $R;[ "$DONE" ]&&{ echo "$r";break; };done
```

## Reproduction
To reproduce this experiment in a clean environment:
```bash
# Requires: llm, jq, xdotool, and a Groq API key
git clone https://github.com/ShellLM/agent8 && cd agent8 && bash agent8.sh
```

## Evidence Map
Detailed mappings of all claims to raw data are in `CLAIM_MAP.md`.
