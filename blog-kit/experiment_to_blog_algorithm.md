# Reproducible LLM Experiment -> Blog Algorithm

Audience: AI researchers, advanced users, and future-you.

This process is intentionally LLM-driven but artifact-first: every claim in the post must map to a script, log row, cast recording, or generated metric.

## 0) One-time repository structure

Use one experiment repo per blog post (or one monorepo with per-run folders):

```
runs/<run_id>/
  config/
   experiment.yaml
   model_matrix.yaml
  prompts/
  scripts/
  raw/
   llm_logs.json
   transcript.txt
  derived/
   metrics.csv
   failures.csv
   summary.json
  demos/
   demo.cast
  publish/
   blog_claim_map.md
   reproduction.md
```

## 1) Protocol definition (before running anything)

1. Define a falsifiable question.
   - Example: "Can a 300-byte shell agent reliably complete N-step Linux tasks without manual edits?"
2. Define success and failure criteria.
   - Success metrics: task completion rate, token usage, wall-clock time, command accuracy, retries.
   - Failure metrics: unsafe commands, hallucinated paths, infinite loops, broken shell state.
3. Freeze configuration in `config/experiment.yaml`.
   - Required: model IDs, options (temperature/seed), prompt hash, allowed tools, task-set version.

## 2) Capture immutable run evidence

4. Start terminal recording.
   - `asciinema rec runs/<run_id>/demos/demo.cast`
5. Keep `llm` logging enabled and note run boundaries.
   - Save first/last response IDs and any conversation IDs.
6. Snapshot scripts/prompts at run time.
   - Include exact copies of `agent8.sh`, hooks, prompt files, and harness scripts.

## 3) Extract and normalize logs

7. Export relevant `llm` logs to `raw/llm_logs.json`.
8. Normalize rows to a strict schema.
   - Minimum columns: response_id, datetime, model, prompt, response, input_tokens, output_tokens, duration_ms.
9. Extract tool/code events.
   - Parse fenced code blocks, command attempts, failures, and recoveries.

## 4) Design model challenge suite

10. Build a versioned challenge set with labels.
   - Categories: file ops, text transforms, package management, debugging, shell quoting, safety refusal.
11. Run all tasks across model matrix and repeats.
   - Minimum recommendation: 3 repeats per model-task pair.
12. Score automatically.
   - Pass/fail + partial credit + safety penalty rules in code, not prose.

## 5) Analyze and package evidence

13. Generate summary tables per model.
   - pass_rate, avg_tokens, avg_latency_ms, retry_rate, safety_violations.
14. Build a failure taxonomy.
   - planning_error, syntax_error, state_loss, unsafe_action, recovery_failure.
15. Package reproducibility bundle.
   - `derived/*.csv`, `derived/*.json`, SQL queries, scripts, config files, cast recording.

## 6) Publish artifacts and map claims

16. Publish artifacts to a Git repo (preferred) or gist (small single-file add-ons).
   - Create immutable tag: `exp-YYYYMMDD-<slug>`.
17. Create a claim-evidence map in `publish/blog_claim_map.md`.
   - Every blog claim references exact artifact file(s).
18. Build post sections in fixed order.
   - problem -> method -> controls -> results -> failures -> limitations -> reproduction.
19. Add one-command rerun instructions in `publish/reproduction.md`.

## 7) LLM-driven writing loop (controlled)

20. Prompt LLM to draft from claim-evidence map only.
21. Automatically reject any sentence without linked evidence.
22. Regenerate until all claims pass evidence checks.

## 8) Publication quality gates

- [ ] Every claim has a linked artifact.
- [ ] Includes at least one negative/failure result.
- [ ] Rerun instructions work on clean Linux environment.
- [ ] Safety notes are explicit for autonomous shell execution.
- [ ] Demo cast and metrics table are both present.
- [ ] Artifact repo/gist URL and immutable tag are included in post.
