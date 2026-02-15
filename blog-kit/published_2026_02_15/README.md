# Agent8: Minimalist Autonomous Workspace
A hardened, shell-based agent framework under 300 bytes.

## Variants
- **Standard (254B)**: Hook-enabled for safety auditing and tool integration (`agent8.sh`).
- **Minimalist (234B)**: Hardcoded core for maximum weight reduction (`agent8_mini.sh`).
- **Optimized (193B)**: Proposed next-gen core (see POST.md).

## Quick Start
```bash
# Install dependencies: llm, jq, xdotool
# Set your LLM API key
bash agent8.sh
```

## Capabilities
- **Safety**: Dual-layer audit (Pattern matching + LLM verification).
- **Parallelism**: Native `spawn` and `gather` tools for multi-agent tasks.
- **Portability**: Fully relative paths for clean environment reproduction.
