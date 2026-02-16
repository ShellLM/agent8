# Post: The 254-Byte Autonomous Agent
**Date:** 2026-02-15
**Status:** Publication Draft (Evidence-Bounded)

## Method
Agent8 was evaluated on a 3-task shell workflow in a safety-hardened environment:
1. **Search** via tool integration.
2. **Synthesis** via multi-step generation.
3. **Safety-Check** under policy interception.

This publication distinguishes planned scope from executed scope: the original plan targeted a broader model matrix, while the release evidence in this bundle reflects executed runs only.

## Results
- **Baseline size:** 254 bytes (`agent8.sh`)
- **Mini size:** 234 bytes (`agent8_mini.sh`)
- **Task pass rate:** 0.6667 (2/3 runs successful)
- **Average latency:** 4633.33 ms
- **Run-level failures:** 1/3 runs (from non-zero `exit_code`)
- **Blocked attempts:** 3 intercepted actions (from safety intercept log)

All claims are evidence-linked in:
- `~/ai/blog-kit/published_2026_02_15/CLAIM_MAP.md`
- `~/ai/blog-kit/published_2026_02_15/metrics.csv`
- `~/ai/blog-kit/published_2026_02_15/run_ledger_detailed.csv`

## Limitations
- This is an exploratory run set (`n=3`) and not a full model-task-repeat matrix.
- Run-level failures and blocked-attempt counts measure different safety properties and are reported separately.
- Token-level metrics are not asserted as canonical in this draft because they are not uniformly available in the current run ledger.

## How to Reproduce
Use the bundled instructions and artifacts:
- `~/ai/blog-kit/published_2026_02_15/REPRODUCTION.md`
- `~/ai/blog-kit/published_2026_02_15/MANIFEST.txt`

Minimal local run:
```bash
cd ~/ai/blog-kit/published_2026_02_15
bash agent8.sh
```
