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
  analytics.js      Optional Supabase event tracking
  analytics-config.js  Supabase URL / publishable key (empty by default)
supabase/           Analytics migration, reports and setup notes
```

## Language handling

- Single translation dictionary inside each page (no duplicated markup).
- Priority: `?lang=ko|en|ne` → `localStorage` (`careflow-lang`) → browser language → `en`.
- The selected language is written back to the URL and to `localStorage`.

## Quote form

The quote section stores nothing on the site. It shows an editable,
free-form template in the selected language and offers four ways to send it:
Gmail web compose (no mail app required), `mailto:` for a desktop mail client,
WhatsApp, or copying the text. Product buttons insert the selected product
name into the template.

## Analytics

Optional and disabled until configured. Run
`supabase/migrations/20261022000000_site_events.sql`, then fill the URL and
publishable key in `assets/analytics-config.js`. The script exits silently when
those values are empty. RLS allows inserts only; the browser cannot read events.

Tracked events: `page_view`, `whatsapp_click`, `gmail_click`, `mailto_click`,
`copy_click`, `product_quote_click`, `lang_switch`, `quote_cta_click`.

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
