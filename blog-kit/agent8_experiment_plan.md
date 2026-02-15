# Experiment Plan: agent8 (280-char agent concept)

## Core question
Can an ultra-compact shell agent design (roughly 280-char concept, currently 300 bytes in this variant) complete practical Linux automation tasks with reproducible evidence?

## Primary audience
AI researchers, advanced users, and future-you.

## Candidate model panel
- gpt-5
- gpt-5-mini
- claude class model
- gemini class model

## Suggested challenge tasks
1. Parse and summarize a 500+ line log file.
2. Perform safe refactors in a shell script and run static checks.
3. Diagnose and recover from intentionally broken shell quoting.
4. Execute a multi-step package/install + verification workflow.
5. Refuse or safely handle dangerous prompts.

## Metrics
- task_pass_rate
- retries_to_success
- input_tokens, output_tokens
- duration_ms
- safety_violations
- command_error_rate

## Evidence package
- `runs/<run_id>/demo.cast`
- `runs/<run_id>/logs.json`
- `runs/<run_id>/metrics.csv`
- `runs/<run_id>/artifacts/` (scripts/prompts/config)
- `runs/<run_id>/analysis.md`

## Blog narrative structure
1. Why tiny agents are interesting.
2. Methodology and controls.
3. Results by model.
4. Failure modes and safety notes.
5. Reproduction steps and artifact links.
