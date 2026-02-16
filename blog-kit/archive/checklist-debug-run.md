# Experiment Checklist: debug

Run ID: debug-run
Date: 2026-02-14
Primary model set: m1,m2
Primary audience: aud

## 0) Job Queue (execution order)
- [ ] J1: Freeze hypothesis, metrics, and threat model
- [ ] J2: Capture immutable run evidence (`llm` logs + asciinema + scripts)
- [ ] J3: Build model challenge matrix and execute repeats
- [ ] J4: Analyze logs and compute metrics/failure taxonomy
- [ ] J5: Publish artifact repo/gist with immutable tag
- [ ] J6: Draft blog with claim-evidence mapping

## 1) Research Question
- [ ] Hypothesis is falsifiable
- [ ] Success/failure criteria defined
- [ ] Threats to validity listed

## 2) Setup Freeze
- [ ] Prompt template saved and versioned
- [ ] Model IDs/options fixed (temp, seed, etc.)
- [ ] Environment metadata captured (OS, shell, versions)

## 3) Data Capture
- [ ] `llm` logging status verified (`llm logs status`)
- [ ] Run boundary IDs captured (start/end response IDs)
- [ ] Raw logs exported to JSON
- [ ] Scripts copied to artifact bundle
- [ ] Prompt versions copied to artifact bundle

## 4) Demonstration
- [ ] `asciinema rec` performed
- [ ] Cast file named with run ID
- [ ] Demo steps documented

## 5) Evaluation Suite
- [ ] Task set defined and versioned
- [ ] Baseline model included
- [ ] At least 3 repeats for variance
- [ ] Safety challenge tasks included
- [ ] Model matrix file saved (models x tasks x repeats)

## 6) Analysis
- [ ] Metrics table generated
- [ ] Failure taxonomy completed
- [ ] Representative transcripts linked
- [ ] Token/latency and retry stats computed

## 7) Publish Artifacts
- [ ] Repo or gist created
- [ ] All artifact file hashes recorded
- [ ] Reproduction script included
- [ ] Immutable release tag created

## 8) Blog Post Assembly
- [ ] Claims link to artifact evidence
- [ ] Method + limitations section present
- [ ] "How to reproduce" section present
- [ ] Next experiment backlog item added

## 9) Prompt/Eval Deep-Dive Section
- [ ] Side-by-side prompt variants included
- [ ] Multiple model responses shown for same prompt
- [ ] Evaluation rubric table included
- [ ] Why winning prompt worked (or failed) documented

## 10) Agent8-Specific Checks
- [ ] Byte-count + script snapshot captured (`wc -c`)
- [ ] Shell safety analysis included (`eval`, quoting, command boundaries)
- [ ] At least one failure demonstration in cast/transcript
- [ ] Improvement backlog for next iteration listed
