-- CareFlow site analytics (Supabase)
-- Run in the Supabase SQL editor, or apply with `supabase db push`.

create table if not exists public.site_events (
    id uuid primary key default gen_random_uuid(),
    created_at timestamptz not null default now(),
    event text not null,
    path text,
    lang text,
    label text,
    product text,
    referrer_host text,
    session_id uuid,
    device text,
    constraint site_events_event_len check (char_length(event) <= 40),
    constraint site_events_path_len check (char_length(path) <= 200),
    constraint site_events_lang_len check (char_length(lang) <= 8),
    constraint site_events_label_len check (char_length(label) <= 100),
    constraint site_events_product_len check (char_length(product) <= 100),
    constraint site_events_referrer_len check (char_length(referrer_host) <= 100),
    constraint site_events_device_len check (char_length(device) <= 12)
);

alter table public.site_events enable row level security;

-- The website may only insert. It cannot read or modify events.
revoke all on public.site_events from anon, authenticated;
grant insert on public.site_events to anon;

drop policy if exists "anon insert site events" on public.site_events;
create policy "anon insert site events"
    on public.site_events
    for insert
    to anon
    with check (true);

create index if not exists site_events_created_at_idx
    on public.site_events (created_at desc);

create index if not exists site_events_event_idx
    on public.site_events (event, created_at desc);

-- Daily rollup for quick reporting in the dashboard.
create or replace view public.site_events_daily as
select
    date_trunc('day', created_at) as day,
    event,
    lang,
    device,
    count(*) as events
from public.site_events
group by 1, 2, 3, 4
order by 1 desc;

revoke all on public.site_events_daily from anon, authenticated;
