---
name: on-device-models-research
description: "Audit, update, and improve the on-device-models index."
version: 1.0.0
author: Hermes Agent
license: MIT
---

# On-device models research

## When to use
- Run the scheduled research and improvement pass for this repository.
- Audit existing entries, discover additions, and open one PR.

## Rules
- Edit only `site/src/_data/models.json`, `docs/model-notes.md`, and README only if a category changes.
- Never edit `site/_site/` or generated HTML.
- Verify licenses, sizes, specs, and download status against primary sources.
- Keep changes to one PR; report no-op when nothing changed.

## Workflow
1. Sync `main`: `git fetch origin && git checkout main && git pull --ff-only`.
2. Create branch `ai/research-YYYYMMDD`.
3. Audit each model in `site/src/_data/models.json`:
   - release/version changed
   - license (code vs weights, split licensing)
   - size/specs
   - Node SDK status
   - download URL validity
4. Discover candidates that fit the charter: useful, runs on consumer hardware without cloud, public download.
5. Update `models.json` and `docs/model-notes.md`.
6. Validate:
   - JSON parses
   - required fields present
   - ids unique
   - `cd site && npm ci && npm run build` succeeds, 1 file written
   - row count equals model count
   - HTML tag balance clean
7. Commit conventionally and push branch.
8. Open one PR with summary and validation result.

## Verification commands
```bash
node -e 'const d=require("./site/src/_data/models.json"); console.log(d.categories.reduce((n,c)=>n+c.models.length,0))'
cd site && npm ci && npm run build
```

## Reporting
Return added/changed/removed counts, validation result, PR URL, or no-op. Flag licensing/category decisions needing human judgment.