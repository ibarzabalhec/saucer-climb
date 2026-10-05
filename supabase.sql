-- Saucer Climb high scores table.
-- Run this once in Supabase: SQL Editor > New query > paste > Run.

create table if not exists public.scores (
  id          bigint generated always as identity primary key,
  initials    text        not null check (initials ~ '^[A-Z0-9.]{3}$'),
  floor       integer     not null check (floor between 1 and 100000),
  -- a loose ceiling on what a real run can score at this floor:
  -- 10 per floor, 10 more per floor in negative mode, plus combo floors squared
  score       integer     not null check (score > 0 and score <= 30 * floor + 2 * floor * floor),
  species     text        not null check (char_length(species) <= 20),
  created_at  timestamptz not null default now()
);

create index if not exists scores_score_idx on public.scores (score desc);
create index if not exists scores_created_idx on public.scores (created_at desc);

alter table public.scores enable row level security;

-- anyone can read the board
create policy "read scores" on public.scores
  for select to anon using (true);

-- anyone can add a score; nobody can edit or delete through the public key
create policy "add scores" on public.scores
  for insert to anon with check (true);
