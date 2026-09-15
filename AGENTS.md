# AGENTS.md

Working agreement for AI coding agents (and humans) in this repo.

## What this repo is

A curated, public index of small AI models that run offline on phones, Raspberry Pis, laptops, and browsers. Published at <https://rbk-agent.github.io/on-device-models/>. One hard rule for every entry: it must run on consumer hardware without a cloud service, and have a working public download.

## Source of truth

**`site/src/_data/models.json` is the data. Everything renders from it.**

- Adding/editing a model = editing that JSON. Never hand-edit `_site/` or generated HTML.
- `site/src/index.njk` is the only template — Eleventy renders it into a single page.
- `docs/model-notes.md` is the long-form reference (the original README, kept verbatim). When you add a model, add it there too with the full detail.
- `models.json` is also copied to the published site at `/models.json` as a machine-readable endpoint.

## Data rules (models.json)

A model qualifies only if it: (1) does something useful, (2) runs on consumer hardware without a cloud service, (3) has a working public download.

Required fields per model: `id` (unique, kebab-case), `name`, `task`, `input`, `size`, `license`, `links`, `summary`, `node_sdk`. Optional: `license_note`, `node_note`.

Non-negotiables:

- **Verify licenses against primary sources** (GitHub API, Hugging Face model card, official docs) — not search-result summaries. Many models have split licensing (MIT code, non-commercial weights — e.g. BirdNET) or per-variant licenses (e.g. MegaDetector). Say so explicitly in `license` / `license_note`.
- **Node SDK status is a first-class field.** Values: `native` (official npm package), `onnx` (runnable from Node via onnxruntime/ports), `cli` (spawn a binary), `none`. The site's owner prefers Node; this column is a key selector.
- **Sizes and specs must be real numbers from the source** — never guessed. If unknown, write what is known and nothing more.
- Link only to stable destinations: the repo, npm page, official docs, or HF model card. Avoid deep links that rot.

## Site

- **Generator:** Eleventy 3, Node 22. No other runtime deps for the site.
- **Styling/interaction:** DataTables via the pinned CDN build in `index.njk` (integrity hashes are mandatory — never strip them). No custom CSS files, no UI frameworks. Server-rendered HTML must stay valid without JS.
- **Build locally:** `cd site && npm install && npm run build` → output in `site/_site/`.

## Verification (no test suite — verify ad hoc before pushing)

1. `npm run build` succeeds and reports 1 file written.
2. Row count in `_site/index.html` matches model count in `models.json` (currently 37).
3. HTML tag balance is clean and nav/anchors resolve (a short Python html.parser check is fine).
4. Any new model: `json` parses, required fields present, ids unique.

CI runs the same build on every PR; deploy to GitHub Pages happens on merge to `main` (`.github/workflows/site.yml`).

## Git conventions

- Branch from fresh `main` as `ai/<topic>`. One PR per change; commit messages conventional (`feat:`, `docs:`, `fix:`).
- Never force-push `main`. Never delete issues/branches/PRs — close instead.
- Merge = squash.