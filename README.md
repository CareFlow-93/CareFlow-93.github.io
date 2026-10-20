# CareFlow — careflow.kr

Korea aesthetic & wellness B2B sourcing and purchasing agency for Nepal, Cambodia, Myanmar and Thailand.

## Structure

```
index.html          Main page (KR / EN / नेपाली, runtime language switch)
privacy.html        Privacy policy (KR / EN / NE)
terms.html          Terms of service (KR / EN / NE)
404.html            Not found page (GitHub Pages fallback)
CNAME               careflow.kr
robots.txt          Crawler rules
sitemap.xml         Sitemap
assets/
  cheongkwanjang.webp
  currentbody.webp
  dualsonic.webp
  og-image.jpg      Open Graph image (1200x630)
  favicon.svg
  apple-touch-icon.png
  legal.css         Shared styles for legal pages
```

## Language handling

- Single translation dictionary inside each page (no duplicated markup).
- Priority: `?lang=ko|en|ne` → `localStorage` (`careflow-lang`) → browser language → `en`.
- The selected language is written back to the URL and to `localStorage`.

## Quote form

The form has no backend. On submit it validates the fields and opens the user's
email app with a prefilled `mailto:` message to `tjdals3982@naver.com`; a
WhatsApp fallback with the same content is also provided.

## Deployment

Static site served by GitHub Pages from the `main` branch root (`.nojekyll`
present). Custom domain `careflow.kr` via `CNAME`; HTTPS enforced.

To publish changes:

```sh
git add -A
git commit -m "..."
git push origin main
```

GitHub Pages rebuilds in about 30–60 seconds.
