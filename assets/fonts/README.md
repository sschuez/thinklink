# Self-hosted fonts

The site serves two families locally — **Newsreader** (serif, roman + italic) and **Public Sans** (sans, roman). No requests to `fonts.googleapis.com` or `fonts.gstatic.com` at runtime.

## Files committed

Latin subset only. One `.woff2` file per weight that's actually used in the design.

- `Newsreader-300.woff2`, `Newsreader-400.woff2`, `Newsreader-500.woff2`, `Newsreader-600.woff2`
- `Newsreader-300-Italic.woff2`, `Newsreader-400-Italic.woff2`
- `PublicSans-400.woff2`, `PublicSans-500.woff2`, `PublicSans-600.woff2`

Total ~190 KB, hashed and gzipped by the browser cache. References live in `assets/css/tokens.css`.

## Source

Fetched via [Google Webfonts Helper](https://gwfh.mranftl.com) (a self-host bundler for Google Fonts). Both families are licensed under the **SIL Open Font License 1.1** — see:

- Newsreader: https://github.com/productiontype/Newsreader (OFL.txt)
- Public Sans: https://github.com/uswds/public-sans (OFL.txt)

## Refreshing the bundle

To re-fetch a different weight set, replace the URL parameters:

```
curl -L "https://gwfh.mranftl.com/api/fonts/newsreader?download=zip&subsets=latin&variants=300,regular,500,600,300italic,italic&formats=woff2" -o /tmp/n.zip
curl -L "https://gwfh.mranftl.com/api/fonts/public-sans?download=zip&subsets=latin&variants=regular,500,600&formats=woff2"      -o /tmp/p.zip
```

Then rename the extracted files to match the `Family-Weight[-Italic].woff2` pattern referenced in `tokens.css`.
