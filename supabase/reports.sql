-- CareFlow analytics reports
-- Paste into the Supabase SQL editor.

-- 1. Daily page views and clicks (last 14 days)
select
    date_trunc('day', created_at)::date as day,
    count(*) filter (where event = 'page_view') as page_views,
    count(*) filter (where event = 'whatsapp_click') as whatsapp_clicks,
    count(*) filter (where event = 'product_quote_click') as quote_clicks,
    count(*) filter (where event = 'lang_switch') as lang_switches
from public.site_events
where created_at >= now() - interval '14 days'
group by 1
order by 1 desc;

-- 2. Event totals (last 30 days)
select event, count(*) as events
from public.site_events
where created_at >= now() - interval '30 days'
group by 1
order by 2 desc;

-- 3. Language split (last 30 days)
select lang, count(*) as page_views
from public.site_events
where event = 'page_view'
  and created_at >= now() - interval '30 days'
group by 1
order by 2 desc;

-- 4. Product interest (last 30 days)
select product, count(*) as clicks
from public.site_events
where event = 'product_quote_click'
  and created_at >= now() - interval '30 days'
group by 1
order by 2 desc;

-- 5. Referrer hosts (last 30 days)
select coalesce(referrer_host, '(direct)') as source, count(*) as visits
from public.site_events
where event = 'page_view'
  and created_at >= now() - interval '30 days'
group by 1
order by 2 desc;
