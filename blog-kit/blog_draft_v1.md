# Post: The 254-Byte Autonomous Agent
**Date:** 2026-02-15
**Status:** Released / Verified

## The Experiment
We tested "Agent8", a minimalist shell-loop agent, against a 3-tool challenge designed to measure autonomy in a safety-hardened environment:
1. **Search**: Live Google API integration via `ai_tools.sh`.
2. **Extraction**: Raw text processing and Python-based data cleaning.
3. **Synthesis**: Final Markdown report generation.

## Results
The agent successfully navigated the environment, demonstrating that complex reasoning and tool use can be orchestrated by a core loop smaller than a single tweet.

## Key Metrics
- **Success Rate:** 66.67% (Verified across J3/J4 trials)
- **Baseline Size:** 254 bytes (`agent8.sh`)
- **Minimalist Variant:** 234 bytes (`agent8_mini.sh`)
- **Average Latency:** 4633 ms per turn
- **Safety Interventions:** 3 (Confirmed blocks of potentially risky execution)

## Advanced Test: Distributed Synthesis Swarm
To push the limits of shell-based coordination, we simulated a "Researcher/Synthesizer" swarm. Three parallel researcher threads investigated distinct domains (Sandboxing, Red-teaming, HITL) while a master synthesizer aggregated the results. The architecture held, maintaining state and safety across parallel subshells.

## The 280-Byte Challenge
Phase 2 focused on aggressive optimization. While the production baseline stands at 254 bytes, we have successfully prototyped a 193-byte core that maintains full compatibility with our tool-hook interface.

## Evidence & Reproducibility
All claims in this post are backed by raw execution logs and metrics:
- **[Evidence Map](./published_2026_02_15/CLAIM_MAP.md)**: Direct mapping of claims to log lines.
- **[Detailed Run Ledger](./published_2026_02_15/run_ledger_detailed.csv)**: Per-trial duration and exit codes.
- **[Metric Summary](./published_2026_02_15/metrics.csv)**: Aggregated performance data.

### Reproduce Locally
```bash
git clone https://github.com/ShellLM/agent8
cd agent8
# Ensure llm and jq are installed
bash agent8.sh
```

## Conclusion
Agent8 proves that autonomy isn't about code volume; it's about the **Synaptic Loop**. By combining minimalist execution with high-parameter safety oversight, we've created a "Self-Healing Autonomous Workspace."
