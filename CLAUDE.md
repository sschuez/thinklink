# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Static homepage for the ThinkLink Association — a non-profit Swiss Verein based in Zürich. **Jekyll** site (built natively by GitHub Pages), bilingual (DE + EN). Pages: home, Impressum, Datenschutzerklärung in each language. Self-hosted fonts, no analytics, no cookies, no third-party requests at runtime.

## Setting up a new machine

If the repository isn't on the machine yet (the user is starting from an empty folder
and asks you to "fetch"/"download" the website), first clone it —
`git clone https://github.com/sschuez/thinklink` (install git if the OS prompts for it)
— then open the resulting `thinklink` folder as the working directory before continuing.

If the person is setting this up on a fresh machine (or anything below fails), run the
setup script instead of installing by hand — `./script/setup` on macOS/Linux,
`powershell -ExecutionPolicy Bypass -File script/setup.ps1` on Windows. It's a
re-runnable doctor: it checks Git, the GitHub CLI + login, Ruby 3.3, the C toolchain
and the project gems, installs what it safely can, and prints `ACTION NEEDED` lines for
the steps that need a human (Xcode tools dialog, `gh auth login`, etc.). Read its
output, relay each action to the person in their language, wait for them to do it, then
re-run until it reports the machine is ready. Full reference + a "when it breaks" guide
live in `SETUP.md`.

## Local development

```
bundle install            # one-time
bundle exec jekyll serve  # http://localhost:4000
```

The local preview lives at **http://localhost:4000/** (English at `http://localhost:4000/en/`). Do **not** append `/thinklink/` — that path only exists in the production Pages build (`--baseurl /thinklink`); locally the dev server serves from the root and `/thinklink/` 404s. When handing a preview link to someone who isn't reading the code, give them the bare root URL.

Two checks, both run locally and in CI: `bundle exec jekyll build` (Liquid errors, broken includes and bad front matter surface here) and `bundle exec htmlproofer ./_site --disable-external --allow-hash-href` (dead internal links, broken anchors, missing images — things the build alone misses). External-link checking is off on purpose: it keeps the check fast, offline, and free of third-party requests. The same proof runs in `.github/workflows/jekyll.yml` and **blocks the deploy** if it fails.

## Deployment

GitHub Pages, driven by `.github/workflows/jekyll.yml`. On push to `main`, the workflow installs Ruby, runs `bundle exec jekyll build --baseurl <pages-base-path>` and uploads the result to Pages. Total turnaround push → live is ~60 seconds. No build output is committed. Custom domain handled via a `CNAME` file at repo root.

## Working with this repo from a prompt

Assume the person prompting is not reading the diff and not running anything locally — they want a working website, and they want to **see and approve** a change before it goes public.

**Session preflight — do this before the first edit of a session.** Run `./script/check` (macOS/Linux) or `powershell -ExecutionPolicy Bypass -File script/check.ps1` (Windows) to confirm the machine is ready. If it prints `NOT READY`, **do not start editing** — run the setup script (`./script/setup` / `script/setup.ps1`), walk the user through any `ACTION NEEDED` items in their language, and re-run until ready. Run the check once per session; skip it for later edits in the same session.

Default workflow for any prompted content change:

1. **Sync first.** Before editing, run `git pull --rebase --autostash origin main` so this machine has the latest — several people edit this site from different machines, and working on a stale tree causes rejected pushes and conflicts later. (`--autostash` makes this safe to run even if edits are already in progress.) If the pull reports a conflict (rare — two people changed the same lines), resolve it only when the intent is unambiguous; otherwise stop and explain the clash to the user in their language and ask how to proceed.
2. **Make the change.** Edit only what the request asks for. Don't refactor surrounding code. Mirror DE/EN.
3. **Verify it builds and links resolve.** Run `bundle exec jekyll build`, then `bundle exec htmlproofer ./_site --disable-external --allow-hash-href`. Both must pass. **If either fails, fix the cause and re-run until green — do not preview or publish a red build.** Common fixes: repair the broken link or anchor, restore the missing image, or add a new non-page file (e.g. a new `*.md` doc) to `exclude:` in `_config.yml` so it isn't published. State plainly what failed and what you changed.
4. **Preview.** Make sure `bundle exec jekyll serve` is running (start it in the background if not) and hand the user the local link — `http://localhost:4000/` for DE, `http://localhost:4000/en/` for EN — pointing at the exact page/section that changed. If they're not on this machine (e.g. driving from claude.ai/code, where `localhost` won't reach them), describe precisely what changed and show the relevant snippet instead.
5. **Ask before publishing.** Proactively ask, in the user's language, whether to publish — e.g. "Soll ich das jetzt veröffentlichen?" / "Publish this now?" Do **not** commit or push until they confirm. If they want tweaks, iterate on the preview and ask again.
6. **Publish on confirmation.** Commit (subject ~50 chars, plain language — "Update president bio", "Add 2027 conference to activities", "Fix typo in Datenschutz"; **never mention Claude or AI**, see `~/.claude/CLAUDE.md`) and push to `main`. **If the push is rejected because the branch is behind** (someone else published while you were working), run `git pull --rebase --autostash origin main`, re-run the build + link check, then push again. The workflow does the rest — live at https://sschuez.github.io/thinklink/ in about a minute.
7. **Tell the user** it's published, where to look, and roughly when it'll be live.

The preview + confirm step is the default for content edits. If the user says something like "just publish this directly," skip the preview/ask for that one change. **Ask first** before:
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
