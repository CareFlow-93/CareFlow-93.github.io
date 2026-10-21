# Supabase setup for CareFlow

The website is static (GitHub Pages). Supabase is used for anonymous usage
analytics and, optionally, quote storage.

## 1. Analytics

1. Create a Supabase project.
2. Open **SQL Editor** and run
   `supabase/migrations/20261022000000_site_events.sql`.
3. In **Project Settings → API**, copy:
   - Project URL
   - publishable (anon) key
4. Put them into `assets/analytics-config.js`:

```js
window.CAREFLOW_ANALYTICS = {
    url: "https://<project-ref>.supabase.co",
    key: "<publishable-key>"
};
```

5. Commit and push. The site starts sending:
   - `page_view`
   - `whatsapp_click`
   - `gmail_click`, `mailto_click`, `copy_click`
   - `product_quote_click` (with product index)
   - `lang_switch`
   - `quote_cta_click`

The key is a publishable key and safe to expose. RLS allows **insert only**;
the browser cannot read the table.

### Reports

Run `supabase/reports.sql` in the SQL editor, or query the
`site_events_daily` view in the Table editor.

## 2. Domain email (`sales@careflow.kr`)

Supabase is not a mailbox provider. Split the setup:

**Receiving**
- Gabia domain mail, or a forwarding service (ImprovMX / ForwardEmail)
- Forward `sales@careflow.kr` to the Naver inbox
- Add MX, SPF and DMARC records at Gabia

**Sending (optional)**
- Create a Resend account and verify `careflow.kr` at Gabia DNS
- Store the API key as a Supabase Edge Function secret
- Deploy an Edge Function that sends quote notifications with
  `From: CareFlow <sales@careflow.kr>`

Do not publish `sales@careflow.kr` on the site until receiving works.

## 3. Quote storage (optional, later)

The current quote form is client-side (`mailto:` / Gmail web / WhatsApp).
To store leads in Supabase later:

1. Create a `quote_requests` table with RLS enabled and **no** anon policies.
2. Deploy an Edge Function that inserts with the service role key.
3. Add a honeypot field and origin check.
4. Keep the mailto/WhatsApp buttons as fallbacks.
