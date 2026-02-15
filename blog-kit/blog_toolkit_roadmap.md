# Blog Toolkit Roadmap (GitHub Pages, zero hosting cost)

Audience: AI researchers, advanced users, and future-you.

## Goal
Build a site that is both:
1) a publication surface for LLM-agent experiments, and
2) an operational toolkit you can reuse for future runs.

## Chosen baseline stack
- Astro + MDX for content and interactive experiment pages
- GitHub Pages + GitHub Actions for free hosting/deploy
- Artifacts in per-experiment repos (preferred) or gists (small add-ons)
- `llm` CLI logs + `asciinema` casts as primary evidence sources

## Information architecture (MVP)
- `/posts/` narrative writeups
- `/experiments/` run index with metrics snapshots
- `/prompts/` prompt variants + side-by-side model responses
- `/toolkit/` scripts, templates, and reusable eval utilities
- `/reproduce/` one-command rerun docs per experiment

## Reproducibility protocol (non-negotiable)
Every post must include:
- Run ID and immutable artifact tag
- Exact scripts/prompts/config used
- Raw logs + derived metrics
- At least one failure case
- Reproduction instructions on Linux

## Experiment-to-post pipeline
1. Generate checklist with `generate_checklist.sh`
2. Freeze hypothesis/metrics/model matrix
3. Record demo (`asciinema rec`) and capture `llm` logs
4. Run challenge suite across model panel + repeats
5. Compute metrics/failure taxonomy
6. Publish artifact repo/gist + immutable tag
7. Draft post from claim-evidence map only

## Agent8 first-post plan
Question:
- Can a tiny shell agent pattern reliably complete Linux automation tasks with acceptable safety and reproducibility?

Minimum benchmark set:
- Log parsing/summarization
- Quoting/escaping recovery
- Multi-step package/install verification
- Safe refusal boundary checks

Output requirements:
- Side-by-side responses for same prompt across models
- Pass-rate + retry + token + latency tables
- Explicit shell-safety analysis of `eval` and command boundaries
- Linked cast + logs + scripts + metric files

## 2-week execution sequence
Week 1:
- Finalize challenge matrix and scoring rubric
- Run 3 repeats per model-task pair
- Publish raw and derived artifacts

Week 2:
- Write post using claim-evidence map
- Build prompt/eval comparison section
- Publish and add backlog for next experiment

## Definition of done
- Checklist complete for run ID
- Artifact bundle is reproducible on clean Linux shell
- Blog post includes evidence links for every substantive claim
- Next experiment is pre-seeded with checklist and task matrix
