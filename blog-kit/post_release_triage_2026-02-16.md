# Post-Release Triage Report - 2026-02-16

## Summary
This report documents the cleanup and reorganization following the Agent8 v1.0.0 release.

## Classification

### ARCHIVE (moved to blog-kit/archive/)
Historical/experimental files preserved for reference:

| File/Group | Rationale |
|------------|-----------|
| `artifact_bundle_2026_02_14/` | Earlier bundle version, superseded by published_2026_02_15 |
| `published_2026_02_15/` | Published bundle moved to archive - tag references the commit, not working tree |
| `blog_draft_v1.md`, `blog_draft_final.md` | Draft iterations, replaced by v2 |
| `checklist-2026-02-14-agent8.md` | Pre-release checklist, historical |
| `checklist-debug-run.md` | Debug artifact |
| `artifact-2026-02-14-*.md/csv/txt` | Intermediate experiment artifacts |
| `hypothesis_v1.md` | Early hypothesis draft |
| `handoff_prompt.md` | Session handoff artifact |
| `release_next_commands.md` | Release instructions - completed |
| `run_ledger_detailed.csv` | Superseded by published version |

### KEEP (active files in working tree)
| File | Rationale |
|------|-----------|
| `blog-kit/TODO.md` | Active task tracking |
| `blog-kit/next_session_plan.md` | Updated session plan |
| `blog-kit/blog_draft_v2.md` | Current draft in progress |
| `blog-kit/session_resume.sh` | Utility for session continuity |
| `blog-kit/validate_artifact.sh` | New validation tool |
| `ai_hooks.sh`, `ai_tools.sh` | Active tooling (modified) |
| `agent8_v1_300b_backup.sh` | Backup reference (modified) |
| `hooks.d/vision.sh` | Active hook (modified) |
| `test_note_sqlite3_*.sh` | New test file |

### DISCARD
None identified - all files have archival or active value.

## Actions Taken
1. Created branch `post-release-cleanup` from `v1.0.0-agent8` tag commit
2. Moved ARCHIVE files to `blog-kit/archive/` preserving structure
3. Staged new KEEP files for commit

## Verification
- Git detected renames correctly (no data loss)
- Published bundle content preserved in archive/
- Release tags (`v1.0.0-agent8`, `agent8-v2026-02-15`) point to immutable commits

## Next Steps
- Commit this triage
- Merge to master
- Push master and tags to origin
