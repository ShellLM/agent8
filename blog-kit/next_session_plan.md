# Next Session Plan: Phase 2 - Agent8 Evolution

## Current State Summary (2026-02-14)
The project now has two active variants: `agent8.sh` (254B hook-enabled baseline) and `agent8_mini.sh` (234B minimal reference). A publication staging bundle exists at `~/ai/blog-kit/published_2026_02_15/` with README, manifest, and tarball. Safety controls are active and logs show multiple blocked dangerous command attempts.

### Key Files
- `~/ai/agent8.sh`: Main agent script (254 bytes).
- `~/ai/agent8_mini.sh`: Minimal reference (234 bytes).
- `~/ai/ai_tools.sh`: Utility functions (includes `read_screen` and `google_search`).
- `~/ai/blog-kit/blog_draft_v1.md`: Experimentally generated synthesis "State of Agent Safety 2026" (Model Output).
- `~/ai/blog-kit/artifact_bundle_2026_02_14/`: Staged evidence logs and scripts.
- `~/ai/blog-kit/published_2026_02_15/`: Publication staging bundle.

---

## Priority Queue for Phase 2

### P1: Publication (J7/J8 Completion)
- [x] Publication assets staged locally (`published_2026_02_15`).
- [x] Build true per-trial run ledger (`model,task,repeat,duration,exit_code`) from J3/J4 evidence.
- [x] Replace source-links placeholder metrics with actual benchmark metrics file.
- [ ] Finalize `~/ai/blog-kit/blog_draft_v1.md` with evidence-linked claims and a reproduction section.
- [ ] Create remote GitHub repo URL and immutable release tag.

### P2: The 280-Byte Challenge
- **Goal**: Keep production `agent8.sh` <= 280 bytes while preserving safety behavior (current: 254 bytes).
- **Constraint**: The safety plugin blocks self-modification. You must output the candidate code as a proposal for manual review.

### P3: Parallel Execution & Coordination
- Implement true background subshells with `wait` commands to replace sequential loops.

## Immediate Next Step
1. Merge publication-safe content from `~/ai/blog-kit/published_2026_02_15/POST.md` into `~/ai/blog-kit/blog_draft_v1.md`.
2. Add explicit links to `~/ai/blog-kit/published_2026_02_15/CLAIM_MAP.md`, `metrics.csv`, and `run_ledger_detailed.csv`.
3. Create remote GitHub repo and tag this publication set.
