# ThinkLink Association — Homepage

Static homepage for the ThinkLink Association. Plain HTML, CSS and a small JavaScript file. No build step.

## Stack

- HTML5
- CSS3 (custom properties, grid, flexbox)
- Vanilla JavaScript (single `IntersectionObserver` for scroll reveals)
- Google Fonts: Newsreader (serif) + Public Sans (sans)

No frameworks, no bundlers, no dependencies.

## Project structure

```
thinklink-homepage/
├── index.html
├── README.md
├── .gitignore
└── assets/
    ├── css/
    │   ├── tokens.css      # Design tokens (colors, fonts, spacing)
    │   └── main.css        # Layout, components, utilities
    ├── js/
    │   └── main.js         # Scroll reveal observer
    └── img/                # Portraits and other assets (add yours here)
```

## Local development

The site is fully static. Two options:

**Option 1, open the file directly**
```
open index.html
```
Works for most cases. Some browsers restrict things like local fonts when opened via `file://`.

**Option 2, serve it locally** (recommended)
```
python3 -m http.server 4000
```
Then open `http://localhost:4000`. Any static server works (Ruby `ruby -run -e httpd . -p 4000`, Node `npx serve`, etc.).

## Deploying to GitHub Pages

1. Create a new repository on GitHub, push this directory to `main`.
2. In the repo: **Settings → Pages**.
3. Under **Source**, select **Deploy from a branch**, branch `main`, folder `/ (root)`.
4. Save. The site will be live at `https://<user>.github.io/<repo>/` within a minute.

### Custom domain (optional)

1. Add a `CNAME` file at the repo root containing only the domain, e.g. `thinklinkassociation.org`.
2. Configure DNS at the registrar:
   - For an apex domain: `A` records pointing to GitHub Pages IPs (see GitHub docs).
   - For a subdomain (`www.`): `CNAME` to `<user>.github.io`.
3. In repo Settings → Pages, set the custom domain and enable **Enforce HTTPS**.

## Future considerations

- **Multiple pages.** When Impressum, Datenschutz and the EN version come, the cleanest move is to migrate to Jekyll (GitHub Pages runs it natively). Layouts and includes will remove duplication. The current HTML translates almost one to one.
- **Self hosting fonts.** Replace the Google Fonts `<link>` with downloaded `.woff2` files in `assets/fonts/` and `@font-face` declarations in `tokens.css`. Improves performance and removes a third party request (relevant for nDSG and Schrems II considerations on Swiss sites).
- **Portraits.** Drop images into `assets/img/`, replace the `.portrait-initials` divs in `index.html` with `<img>` tags.

## Conventions

- Two space indentation in HTML and CSS.
- Section banners in CSS use `/* ====== Name ====== */` for navigability.
- Class names follow a light BEM influenced pattern: `block`, `block-element`, `is-state`.
- Selectors stay shallow. Tokens go in `tokens.css`, everything else in `main.css`.

## License

All rights reserved unless stated otherwise.
