Objective: finish all remaining Agent8 post-publication work end-to-end with minimal risk.

Context files to read first (in order):

release_next_commands.md
blog_draft_v1.md
checklist-2026-02-14-agent8.md
next_session_plan.md
POST.md
CLAIM_MAP.md
metrics.csv
run_ledger_detailed.csv
MANIFEST.txt
REPRODUCTION.md
Required execution:

Release completion
Execute the release flow from release_next_commands.md: commit, remote setup/update, push main, create and push immutable tag.
If remote URL placeholders exist, stop once to request only the exact missing remote value, then continue automatically.
Run the full post-release verification checklist and record results.
Post-release cleanup triage (non-destructive first)
Create branch post-release-cleanup.
Inventory all modified/untracked files.
Classify each into: KEEP (active), ARCHIVE (historical/experimental), DISCARD (generated noise).
Produce a triage report file: blog-kit/post_release_triage_2026-02-16.md with rationale per file/group.
Cleanup implementation (safe and reversible)
Apply only clearly safe moves:
Move ARCHIVE files to a dated folder under Archive preserving structure.
Remove only DISCARD files that are clearly generated/temporary.
Do not touch published bundle files under published_2026_02_15 except if verification requires metadata updates.
Keep a reversible trail (git history + report of moves/deletes).
Backlog reconciliation
Update checklist-2026-02-14-agent8.md to reflect true status after release (only evidence-backed changes).
Update next_session_plan.md “Immediate Next Step” to the real remaining work after cleanup.
Add a short “after-release roadmap” section if missing.
Final verification pass
Recheck internal consistency among:
POST.md
CLAIM_MAP.md
metrics.csv
run_ledger_detailed.csv
MANIFEST.txt
If any gap remains, add TODO entries with exact file path in the relevant doc (no fabrication).
Operating rules:

Be autonomous and continue until fully complete.
Keep edits minimal and evidence-based.
Do not fabricate metrics or outcomes.
Prefer surgical commits and clean commit messages.
Do not rewrite unrelated project files.
Definition of done:

Release is pushed and tagged, verification passed.
Triage report exists and cleanup applied safely.
Checklist and plan are reconciled to truth.
Final output includes:
files changed
commands executed
unresolved gaps/TODOs
exact next terminal command for me.
