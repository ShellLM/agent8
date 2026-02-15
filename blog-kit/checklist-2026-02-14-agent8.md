# Experiment Checklist: agent8: 280-char shell agent

Run ID: 2026-02-14-agent8
Date: 2026-02-14
Primary model set: gpt-5,gpt-5-mini,claude,gemini
Primary audience: AI researchers, advanced users, myself

## 0) Job Queue (execution order)
- [x] J1: Freeze hypothesis, metrics, and threat model
- [x] J2: Capture immutable run evidence (`llm` logs + asciinema + scripts)
- [x] J3: Build model challenge matrix and execute repeats
- [x] J4: Analyze logs and compute metrics
- [x] J5: Publish artifact bundle created
- [x] J6: Draft blog (V1 Ready) with claim-evidence mapping

## 1) Research Question
- [x] Hypothesis is falsifiable
- [x] Success/failure criteria defined
- [x] Threats to validity listed

## 2) Setup Freeze
- [ ] Prompt template saved and versioned
- [ ] Model IDs/options fixed (temp, seed, etc.)
- [x] Environment metadata captured (OS, shell, versions)

## 3) Data Capture
- [ ] `llm` logging status verified (`llm logs status`)
- [ ] Run boundary IDs captured (start/end response IDs)
- [ ] Raw logs exported to JSON
- [x] Scripts copied to artifact bundle
- [ ] Prompt versions copied to artifact bundle

## 4) Demonstration
- [ ] `asciinema rec` performed
- [ ] Cast file named with run ID
- [ ] Demo steps documented

## 5) Evaluation Suite
- [x] Task set defined and versioned
- [ ] Baseline model included
- [ ] At least 3 repeats for variance
- [x] Safety challenge tasks included
- [ ] Model matrix file saved (models x tasks x repeats)

## 6) Analysis
- [x] Metrics table generated
- [ ] Failure taxonomy completed
- [x] Representative transcripts linked
- [ ] Token/latency and retry stats computed

## 7) Publish Artifacts
- [x] Repo or gist created (Git initialized)
- [x] All artifact file hashes recorded
- [x] Reproduction script included
- [ ] Immutable release tag created

## 8) Blog Post Assembly
- [x] Claims link to artifact evidence
- [x] Method + limitations section present
- [x] "How to reproduce" section present
- [x] Next experiment backlog item added

## 9) Prompt/Eval Deep-Dive Section
- [ ] Side-by-side prompt variants included
- [ ] Multiple model responses shown for same prompt
- [ ] Evaluation rubric table included
- [ ] Why winning prompt worked (or failed) documented

## 10) Agent8-Specific Checks
- [x] Byte-count + script snapshot captured (`wc -c`)
- [x] Shell safety analysis included (Verified by Reject) (`eval`, quoting, command boundaries)
- [x] At least one failure demonstration (Safety Intercept) in cast/transcript
- [x] Improvement backlog for next iteration listed

## 11) 2026-02-15 Status Note
- [x] Publication staging exists at `~/ai/blog-kit/published_2026_02_15/`
- [x] Current code-size state captured: `agent8.sh`=254B, `agent8_mini.sh`=234B
- [x] Convert `~/ai/run_ledger.csv` from phase-summary format to per-trial run ledger
- [x] Replace `artifact-2026-02-14-metrics.md` with true benchmark metrics artifact
- [x] Published run set and references reconciled for self-contained bundle paths
