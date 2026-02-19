---
title: "Agent8: A 254B Autonomous Synthesis Loop"
description: "Minimal self-sustaining AI agent loop with verified safety mechanisms"
pubDate: 2026-02-15
---

# Agent8: Autonomous Synthesis Loop

A minimal shell script implementing a self-sustaining AI agent loop in 254 bytes.

## The Core Loop

```bash
while :;do
  r=$(llm -s "$(<$0)" "$@" ${d:+--cid $d} <<<"$o")
  c=$(sed -n '/^```bash$/,/^```$/{//!p}' <<<"$r")
  eval "$c" || break
done
```

The insight: an LLM can generate its own prompts. By wrapping `llm` CLI in a tight loop with conversation ID persistence, we create an autonomous agent.

## Method

1. **Self-referential prompt**: The script reads itself (`"$0"`) as the system prompt
2. **State persistence**: `${d:+--cid $d}` maintains conversation continuity
3. **Output capture**: `$o` accumulates results across turns
4. **Code extraction**: `sed` extracts bash code blocks from responses
5. **Execution loop**: Runs until `eval` fails

## Results

| Metric | Value | Source |
|--------|-------|--------|
| Baseline size | 254 bytes | agent8.sh |
| Mini variant | 234 bytes | agent8_mini.sh |
| Task pass rate | 66.67% | metrics.csv |
| Avg latency | 4633.33ms | metrics.csv |
| Safety intercepts | 3 | safety_intercepts.log |

### Claim Verification

All claims are traced to evidence files:

- **254B baseline**: Verified in release artifact `agent8.sh`
- **66.67% pass rate**: Row `task_pass_rate,0.6667` in metrics.csv
- **3 blocked attempts**: Counted in safety_intercepts.log
- **Model used**: gpt-4o (verified in run_ledger_detailed.csv)

## Limitations

1. No explicit termination condition - runs until error
2. Minimal error handling
3. State grows unbounded in long sessions
4. Safety depends on external plugin

## Safety Mechanism

The `safety_plugin_v2.sh` intercepts dangerous patterns:
- Network exfiltration attempts
- File system destruction
- Privilege escalation

Three attempts were blocked during testing.

## Reproduction

```bash
git clone https://github.com/ShellLM/agent8.git
cd agent8
./agent8.sh "Your prompt here"
```

See [Evidence](/agent8/evidence) for full data. See [Reproduce](/agent8/reproduce) for detailed steps.
