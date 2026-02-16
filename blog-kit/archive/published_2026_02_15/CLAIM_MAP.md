# Claim Map: Agent8 Experiment (v1.2)
| Blog Claim | Evidence File | Context |
|------------|---------------|---------|
| Baseline size is 254B | agent8.sh | File size captured in release artifact set |
| Mini variant size is 234B | agent8_mini.sh | File size captured in release artifact set |
| Task pass rate is 0.6667 | metrics.csv | `task_pass_rate` row |
| Average latency is 4633.33 ms | metrics.csv | `avg_latency_ms` row |
| Run-level failures are 1/3 | run_ledger_detailed.csv | 1 run with non-zero `exit_code` |
| Blocked attempts are 3 | safety_intercepts.log | 3 intercepted entries |
| Executed runs in this release use gpt-4o | run_ledger_detailed.csv | `model` column for all rows |
| Search and synthesis evidence are bundled | evidence/artifact-2026-02-14-search.txt; evidence/artifact-2026-02-14-distributed_synthesis.md | Referenced by run ledger artifact paths |
