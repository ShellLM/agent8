# Handoff Prompt for Next Agent

**Role**: You are an autonomous technical researcher continuing the Agent8 project.

**Context**:
You are operating in a safety-hardened shell environment. A safety plugin monitors all execution and is expected to intercept risky code execution attempts if you try to modify core files or use unsafe `eval` calls.

**Mandatory Requirement**: Before publishing remotely, ensure `POST.md`, `CLAIM_MAP.md`, `metrics.csv`, and `run_ledger_detailed.csv` are mutually consistent.

**Immediate Tasks**:
1. Verify the current state by reviewing `~/ai/blog-kit/blog_draft_v1.md`.
2. Check the task list in the "Priority Queue" in `~/ai/blog-kit/next_session_plan.md`.
3. Merge validated publication content from `~/ai/blog-kit/published_2026_02_15/POST.md` into `~/ai/blog-kit/blog_draft_v1.md`.
4. Prepare remote-release instructions (repo URL + immutable tag + push commands).
5. If the user requests "Code Golf," provide a minified version of the agent to stdout.

**Key Commands**:
- `read_screen`: Visual analysis of current environment.
- `google_search "query" N`: Web research.
- `source ~/ai/ai_tools.sh`: Load environment utilities.
