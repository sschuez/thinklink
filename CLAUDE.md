# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Static homepage for the ThinkLink Association — a non-profit Swiss Verein based in Zürich. **Jekyll** site (built natively by GitHub Pages), bilingual (DE + EN). Pages: home, Impressum, Datenschutzerklärung in each language. Self-hosted fonts, no analytics, no cookies, no third-party requests at runtime.

## Local development

```
bundle install            # one-time
bundle exec jekyll serve  # http://localhost:4000
```

There is no separate lint / test command — `jekyll build` is the only check (`bundle exec jekyll build` from CI's perspective). Liquid errors and broken includes surface here.

## Deployment

GitHub Pages, driven by `.github/workflows/jekyll.yml`. On push to `main`, the workflow installs Ruby, runs `bundle exec jekyll build --baseurl <pages-base-path>` and uploads the result to Pages. Total turnaround push → live is ~60 seconds. No build output is committed. Custom domain handled via a `CNAME` file at repo root.

## Working with this repo from a prompt

Assume the person prompting is not reading the diff and not running anything locally — they want a working website. Default workflow for any prompted change:

1. **Make the change.** Edit only what the request asks for. Don't refactor surrounding code.
2. **Verify it builds.** `bundle exec jekyll build --baseurl /thinklink` should finish without warnings.
3. **Commit.** Subject line ~50 chars, plain language ("Update president bio", "Add 2027 conference to activities", "Fix typo in Datenschutz"). **Never mention Claude or AI in commit messages** (see `~/.claude/CLAUDE.md`).
4. **Push to `main`.** The workflow does the rest. The change is live at https://sschuez.github.io/thinklink/ in about a minute.
5. **Tell the user** what changed, where to look, and roughly when it'll be live.

For routine content edits (text, dates, names, new sections, new pages), proceed end-to-end without asking for confirmation. **Ask first** before:
- Adding any third-party request (analytics, embedded video, externally hosted assets) — this breaks the no-banner privacy posture and requires updating `datenschutz.html` and `en/privacy.html`.
- Adding gems, JS libraries or build steps — the site's lightness is a feature.
- Changing the deploy workflow or Pages settings.

### Clean-code expectations for any change

- Match the existing conventions — two-space indent, BEM-influenced class names, shallow selectors, tokens in `tokens.css` only, section banners in CSS.
- Touch the minimum. A bug fix doesn't need surrounding cleanup. A new page reuses existing primitives (`.legal-prose`, `.section-head`, `.reveal`) instead of inventing classes.
- No abstractions for hypothetical future requirements.
- No comments that restate the code. Add a comment only when the *why* is non-obvious.
- Mirror everything bilingually — if you edit `index.html`, edit `en/index.html`; same for legal pages. Keep anchor IDs localised (`#zweck` ↔ `#purpose`).
- When you change navigation labels, footer links, or anything in `_includes/header.html` / `_includes/footer.html`, you only edit *one* file but you change both languages — verify both branches.

## Architecture

Three layers that together compose every page:

- **`_config.yml`** sets path-scoped defaults: anything under `/` gets `layout: default` + `lang: de`; anything under `/en/` gets `lang: en`. Individual page front matter only declares `title`, `description`, and `alternate_url` (the URL of the same page in the other language).
- **`_layouts/default.html`** is the only layout. It wraps a page's body content with `<head>`, header, footer and the JS script tag.
- **`_includes/header.html`** and **`_includes/footer.html`** branch on `page.lang` at the top of the file (`{% if page.lang == 'en' %}...{% else %}...{% endif %}`) to assign locale-specific labels and anchors, then render once. **All bilingual chrome lives in these two files** — to add or rename a nav link, edit only these.
- **`_includes/head.html`** delegates titles, descriptions, canonical URL, Open Graph and Twitter card tags to the `{% seo %}` tag from the `jekyll-seo-tag` plugin (auto-loaded via `github-pages`). Hreflang is hand-rolled because seo-tag doesn't emit per-language alternates. Organization JSON-LD lives in **`_includes/structured-data.html`** and is included on every page.

### Anchor IDs are localised by language

DE home uses `id="zweck"`, `id="aktivitaeten"`, `id="buchreihe"`, `id="team"`, `id="partnerschaft"`. EN home mirrors with `id="purpose"`, `id="activities"`, `id="book-series"`, `id="team"`, `id="partnership"`. The header include emits the right anchors per language. If you rename an anchor, update both the page (`id=`) **and** the matching `anchor_*` assign in `_includes/header.html`.

### CSS

- `assets/css/tokens.css` — `@font-face` declarations for the self-hosted Newsreader + Public Sans woff2 files in `assets/fonts/`, then design tokens. Change values **here**, never inline in `main.css`.
- `assets/css/main.css` — layout, components, utilities. Numbered section banners (`/* ====== 5. Header ====== */`) match the table of contents at the top of the file. Legal pages live in section 19, with a narrow `.legal-prose` column.

### JS

`assets/js/main.js` is a single `IntersectionObserver`: any element with class `.reveal` gets `.is-in` added once when scrolled into view (then unobserved). The animation is defined in section 18 of `main.css`. **To animate a new element on scroll, add `class="reveal"` — no JS change needed.**

### Paper-grain effect

`body::before` uses an inline SVG turbulence filter; keep `pointer-events: none` and `z-index: 1` so it does not intercept clicks. Content containers use `z-index: 2`.

## Conventions

- Two-space indentation in HTML, CSS and Liquid.
- Class names: BEM-influenced — `block`, `block-element`, `is-state` (e.g. `activity-row.is-upcoming`, `reveal.is-in`).
- Selectors stay shallow.
- Tokens **only** in `tokens.css`. Do not introduce hard-coded colors or font stacks in `main.css`.
- Section banners (`/* ====== Name ====== */`) are the primary navigation aid in CSS — keep the numbered TOC at the top of `main.css` in sync when adding sections.

## Privacy / Swiss compliance

The site is deliberately built to require **no cookie banner** under revFADP:

- No cookies set by the site.
- No analytics, no tag managers, no embeds.
- Fonts are self-hosted — no request to `fonts.googleapis.com` / `fonts.gstatic.com`.
- The only processing disclosed in `datenschutz.html` is GitHub Pages server logs and the U.S. transfer (covered by SCCs + DPF).

If you add anything that issues a third-party request (analytics, maps embed, social embed, externally hosted font/CDN), the cookie-banner-free status no longer holds. Update `datenschutz.html` and `en/privacy.html` accordingly.

## Fonts

Self-hosted and committed to the repo under `assets/fonts/` — one `.woff2` per weight actually used (e.g. `Newsreader-400.woff2`, `Newsreader-400-Italic.woff2`, `PublicSans-500.woff2`). The `@font-face` declarations in `tokens.css` reference these by the `Family-Weight[-Italic].woff2` pattern. No request to `fonts.googleapis.com` / `fonts.gstatic.com` at runtime — this is what keeps the site cookie-banner-free, so keep fonts self-hosted. See `assets/fonts/README.md` to refresh the bundle. If a file were missing, the browser falls back to the system serif / sans stack and the site still renders.

## Adding a new page

1. Create `<slug>.html` (DE) at root and `en/<slug>.html` (EN) under `en/`.
2. Front matter on each: `title` (page-specific only — `jekyll-seo-tag` appends `| ThinkLink Association`), `description`, `alternate_url` pointing at the other-language version.
3. `_config.yml` auto-applies layout + lang + locale. No need to repeat them.
4. If the page should appear in the main nav, add the entry to both branches of `_includes/header.html`.
5. `jekyll-sitemap` picks the new page up automatically; nothing else to wire.
