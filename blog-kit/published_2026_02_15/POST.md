# Post: The 254-Byte Autonomous Agent
**Date:** 2026-02-15
**Status:** Released / Verified

## Method
Agent8 was evaluated on a 3-task challenge in a safety-hardened shell environment: Search, Synthesis, and Safety-Check. Planned scope was broader than this release run set; this publication reports executed runs contained in the bundled ledger.

## Results
- **Baseline size:** 254 bytes (`agent8.sh`)
- **Mini size:** 234 bytes (`agent8_mini.sh`)
- **Task pass rate:** 0.6667 (2/3)
- **Average latency:** 4633.33 ms
- **Run-level failures:** 1/3 (non-zero `exit_code` in ledger)
- **Blocked attempts:** 3 (from `safety_intercepts.log`)

## Limitations
- Sample size is limited to 3 runs.
- Safety metrics are dual-defined and intentionally separate: failed runs vs blocked attempts.
- This post avoids unsupported token-level conclusions as canonical metrics.

## How to Reproduce
See `REPRODUCTION.md` in this same folder.

## Evidence Map
- `CLAIM_MAP.md`
- `metrics.csv`
- `run_ledger_detailed.csv`
- `MANIFEST.txt`
