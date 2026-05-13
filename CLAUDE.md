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

GitHub Pages from `main` at repo root. GitHub runs Jekyll on its side — no committed build output. Custom domain handled via a `CNAME` file at repo root.

## Architecture

Three layers that together compose every page:

- **`_config.yml`** sets path-scoped defaults: anything under `/` gets `layout: default` + `lang: de`; anything under `/en/` gets `lang: en`. Individual page front matter only declares `title`, `description`, and `alternate_url` (the URL of the same page in the other language).
- **`_layouts/default.html`** is the only layout. It wraps a page's body content with `<head>`, header, footer and the JS script tag.
- **`_includes/header.html`** and **`_includes/footer.html`** branch on `page.lang` at the top of the file (`{% if page.lang == 'en' %}...{% else %}...{% endif %}`) to assign locale-specific labels and anchors, then render once. **All bilingual chrome lives in these two files** — to add or rename a nav link, edit only these.

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

The `@font-face` declarations in `tokens.css` point at:

- `assets/fonts/Newsreader.woff2`
- `assets/fonts/Newsreader-Italic.woff2`
- `assets/fonts/PublicSans.woff2`

The files themselves are not in the repo. See `assets/fonts/README.md` for where to get them. Missing files cause a fallback to the system serif / sans stack — site still renders.

## Adding a new page

1. Create `<slug>.html` (DE) at root and `en/<slug>.html` (EN) under `en/`.
2. Front matter on each: `title`, `description`, `alternate_url` pointing at the other-language version.
3. `_config.yml` auto-applies layout + lang. No need to repeat them.
4. If the page should appear in the main nav, add the entry to both branches of `_includes/header.html`.
