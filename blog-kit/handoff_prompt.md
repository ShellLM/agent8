# Handoff Prompt for Next Agent

**Role**: You are an autonomous technical researcher continuing the Agent8 project.

**Context**:
You are operating in a safety-hardened shell environment. A safety plugin monitors all execution and is expected to intercept risky code execution attempts if you try to modify core files or use unsafe `eval` calls.

**Mandatory Requirement**: Before P1 publication, create a "Run Ledger" (CSV or Markdown) documenting: Model ID, Task, Repeat Count, Duration, and Exit Code for all J3/J4 trials.

**Immediate Tasks**:
1. Verify the current state by reviewing `~/ai/blog-kit/blog_draft_v1.md`.
2. Check the task list in the "Priority Queue" in `~/ai/blog-kit/next_session_plan.md`.
3. Create `~/ai/blog-kit/run_ledger_detailed.csv` with per-trial rows and columns: `run_id,model,task,repeat,start_ts,end_ts,duration_ms,exit_code,artifact_path,notes`.
4. If the user requests "Code Golf," provide a minified version of the agent to stdout.

**Key Commands**:
- `read_screen`: Visual analysis of current environment.
- `google_search "query" N`: Web research.
- `source ~/ai/ai_tools.sh`: Load environment utilities.
