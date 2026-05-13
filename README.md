# ThinkLink Association — Homepage

Static site for the ThinkLink Association. German + English, built with **Jekyll** so that the header, footer and `<head>` aren't duplicated across pages. Jekyll runs on GitHub Pages natively — pushing to `main` is enough to deploy.

## Stack

- HTML5, CSS3 (custom properties, grid, flexbox)
- Vanilla JavaScript (single `IntersectionObserver` for scroll reveals)
- Self-hosted variable fonts: Newsreader (serif) + Public Sans (sans). **No** Google Fonts request at runtime.
- Jekyll 4 via the `github-pages` gem

No bundlers, no JavaScript frameworks, no analytics, no third-party requests, no cookies.

## Project structure

```
.
├── _config.yml             # Jekyll config (layout + lang defaults by path)
├── Gemfile                 # pins to the github-pages bundle
├── _layouts/
│   └── default.html        # <html><head>+header+content+footer+script
├── _includes/
│   ├── head.html
│   ├── header.html         # bilingual nav (switches on page.lang)
│   └── footer.html         # bilingual legal-page links + statutes
├── index.html              # DE home (front matter + body only)
├── impressum.html
├── datenschutz.html
├── en/
│   ├── index.html          # EN home
│   ├── imprint.html
│   └── privacy.html
└── assets/
    ├── css/
    │   ├── tokens.css      # @font-face + design tokens
    │   └── main.css        # layout, components, utilities
    ├── fonts/              # drop .woff2 files in here (see README.md inside)
    ├── img/
    └── js/
        └── main.js
```

## Local development

```
bundle install            # one-time, pulls Jekyll via github-pages gem
bundle exec jekyll serve  # http://localhost:4000
```

The `bundle install` step needs Ruby (macOS ships it; otherwise install via Homebrew or `mise` / `asdf`). After that, only `jekyll serve` is needed for day-to-day work.

## Fonts

The site references `assets/fonts/Newsreader.woff2`, `Newsreader-Italic.woff2`, and `PublicSans.woff2`. They're not in the repo — see `assets/fonts/README.md` for the simplest way to fetch them (Google Webfonts Helper). If the files are absent, the browser falls back to the system serif / sans stack and the site still renders.

## Deploying to GitHub Pages

Deployment is driven by `.github/workflows/jekyll.yml` — push to `main` and the workflow builds with Jekyll and publishes to Pages.

1. In the repo: **Settings → Pages → Build and deployment → Source: GitHub Actions**.
2. Push to `main`. The first run triggers automatically; manual re-runs are available from the Actions tab (`workflow_dispatch`).

### Custom domain (optional)

1. Add a `CNAME` file at the repo root containing only the domain.
2. Configure DNS at the registrar (apex `A` records or `www` `CNAME` to `<user>.github.io`).
3. In repo Settings → Pages, set the custom domain and enable **Enforce HTTPS**.

## Adding a page

1. Create `newpage.html` (DE) and `en/newpage.html` (EN) at the right level.
2. Add front matter to each:
   ```yaml
   ---
   title: "..."
   description: "..."
   alternate_url: /en/newpage.html   # or /newpage.html on the EN side
   ---
   ```
3. `_config.yml` auto-applies the layout and the language from the path — no need to repeat `layout:` or `lang:`.

## Adding a navigation link

The nav is defined once, in `_includes/header.html`. Add the label and anchor pair in both the EN and DE branches of the include. The anchors on the home page (`id="..."`) must match.

## Conventions

- Two-space indentation in HTML, CSS and Liquid.
- Class names follow a light BEM-influenced pattern: `block`, `block-element`, `is-state`.
- Selectors stay shallow. Design tokens go in `tokens.css`, everything else in `main.css`. The numbered table of contents at the top of `main.css` matches the `/* ====== N. Name ====== */` banners.
- Section banners (`/* ====== Name ====== */`) are used to navigate the CSS file.

## Privacy / data protection

The site sets no cookies, makes no third-party requests at runtime, and uses no analytics. Under the revised Swiss Federal Act on Data Protection (revFADP) **no cookie banner is required**. The `datenschutz.html` / `en/privacy.html` page discloses GitHub Pages server logs and the U.S. transfer, which is the only processing that occurs. Review with counsel before going live.

## License

All rights reserved unless stated otherwise.
