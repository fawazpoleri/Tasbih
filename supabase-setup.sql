-- Run this once in Supabase: Dashboard → SQL Editor → New query → paste → Run

create table if not exists counters (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  name text not null,
  count integer not null default 0,
  target integer check (target is null or target > 0),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- If you already created the table before target existed, run this too:
alter table counters add column if not exists target integer check (target is null or target > 0);

alter table counters enable row level security;

drop policy if exists "Users manage their own counters" on counters;
create policy "Users manage their own counters"
on counters
for all
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

create index if not exists counters_user_id_idx on counters(user_id);
