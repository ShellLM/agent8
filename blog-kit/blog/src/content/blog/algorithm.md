---
title: 'The Algorithm: Reproducible LLM Experiments'
description: 'A step-by-step protocol for mapping LLM claims to immutable evidence.'
pubDate: 'Feb 28 2026'
heroImage: './blog-placeholder-4.jpg'
---

This post documents the **"Algorithm"**—the non-negotiable protocol we use for every Agent8 experiment to ensure absolute reproducibility.

## Why an Algorithm?
In AI research, particularly with autonomous agents, "vibe-based" evaluation is no longer sufficient. Every claim made in a narrative writeup must be traceable back to a script, a raw log entry, or a verified metric.

---

### Step 0: Repository Structure
Every experiment must reside in a structured folder:
- `config/`: Frozen prompts and model parameters.
- `raw/`: Unmodified LLM log JSONs.
- `derived/`: Computed metrics (pass_rate, tokens).
- `publish/`: The claim-evidence map.

### Step 1: Immutable Capture
We use `asciinema` to record the live terminal session and `llm` CLI hooks to log every token. These are captured *at run time* and never edited.

### Step 2: The Claim-Evidence Map
The most critical artifact is `claim_map.md`. It is a simple table where every sentence in the blog post is assigned an evidence file. 

| Blog Claim | Evidence File |
|------------|---------------|
| "Spent 5s on task X" | `metrics.csv` |
| "Failed to parse Y" | `raw/logs.json` |

---

## Download the Checklist
To implement this protocol in your own projects, you can use our official template:
[Download experiment_checklist.template.md](/templates/experiment_checklist.template.md)

## Conclusion
By following a strict algorithm, we move from "telling stories about AI" to "documenting the behavior of autonomous systems." 

Explore the [Toolkit](/toolkit) to see the scripts that power this process.
