---
title: "Agent8: A 254B Autonomous Synthesis Loop"
description: "Minimal self-sustaining AI agent loop with verified safety mechanisms"
pubDate: 2026-02-15
---

# Agent8: Autonomous Synthesis Loop

A minimal shell script implementing a self-sustaining AI agent loop.

## Method

The core insight: an LLM can generate its own prompts. By wrapping the `llm` CLI in a tight loop with state persistence, we create an autonomous agent in 254 bytes.

```bash
while :;do r=$(llm -s "$(<$0)" "$@" ${d:+--cid $d} <<<"$o");d=$(sed -n '/^````bash$/,/^````$/{//!p}' <<<"$r")
o=$(echo "$d"|bash 2>&1)||break;done
```

## Results

| Metric | Value |
|--------|-------|
| Baseline size | 254 bytes |
| Mini variant | 234 bytes |
| Task pass rate | 66.67% |
| Safety intercepts | 3 |

## Limitations

1. No explicit termination condition
2. Error handling is minimal
3. State grows unbounded in long sessions

## How to Reproduce

See the [Reproduce](/reproduce) page for step-by-step instructions.

All artifacts and evidence are available in the [Evidence](/evidence) section.
