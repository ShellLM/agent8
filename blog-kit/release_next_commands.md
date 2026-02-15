# Agent8 Remote Release Commands (2026-02-15)

## 1) Initialize and publish (replace placeholders)

```bash
cd ~/ai

# If not already initialized:
git init

# Stage publication artifacts and docs
git add blog-kit/blog_draft_v1.md \
        blog-kit/checklist-2026-02-14-agent8.md \
        blog-kit/next_session_plan.md \
        blog-kit/release_next_commands.md \
        blog-kit/published_2026_02_15

# Commit
git commit -m "Agent8: finalize publication-ready bundle and evidence reconciliation"

# Add remote (choose one)
# User site repo pattern:
# git remote add origin git@github.com:<USER>/<USER>.github.io.git

# Project site repo pattern:
# git remote add origin git@github.com:<USER>/agent8-publication.git

# If remote already exists, update it:
# git remote set-url origin git@github.com:<USER>/agent8-publication.git

# Push main branch
git branch -M main
git push -u origin main

# Immutable publication tag
git tag -a agent8-v2026-02-15 -m "Agent8 publication bundle 2026-02-15"
git push origin agent8-v2026-02-15
```

## 2) GitHub Pages options

### Option A: User site (repo name must be `<USER>.github.io`)
- Publish from `main` branch root.
- URL pattern: `https://<USER>.github.io/`

### Option B: Project site (any repo name)
- In repository settings, enable Pages from `main` branch, `/ (root)`.
- URL pattern: `https://<USER>.github.io/<REPO>/`

## 3) Exact post-release verification checklist

Run:

```bash
cd ~/ai

git fetch --tags --all
git rev-parse --verify main
git rev-parse --verify agent8-v2026-02-15

# Confirm tag points to latest intended commit
git log --oneline --decorate -n 3

# Verify publication bundle contents
ls -la blog-kit/published_2026_02_15
sha256sum -c blog-kit/published_2026_02_15/MANIFEST.txt

# Check key claim files are present and readable
test -f blog-kit/published_2026_02_15/POST.md
test -f blog-kit/published_2026_02_15/CLAIM_MAP.md
test -f blog-kit/published_2026_02_15/metrics.csv
test -f blog-kit/published_2026_02_15/run_ledger_detailed.csv

# Quick sanity read
grep -E "254|234|0.6667|4633.33|failed_runs|blocked_attempts" blog-kit/published_2026_02_15/metrics.csv
```

Manual checks:
- Confirm repo is public (if intended).
- Confirm Pages URL (if enabled) returns HTTP 200.
- Confirm release tag `agent8-v2026-02-15` is visible on remote.
