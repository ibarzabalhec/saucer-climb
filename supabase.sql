-- Saucer Climb online high scores.
-- Run this once in Supabase: SQL Editor > New query > paste > Run.

create table if not exists public.scores (
  id          bigint generated always as identity primary key,
  -- the player's name: 1 to 24 characters, letters in any language, numbers, spaces, and . ' -
  name        text        not null check (char_length(name) between 1 and 24 and name ~ '^[[:alnum:] .''-]+$'),
  floor       integer     not null check (floor between 1 and 100000),
  -- a loose ceiling on what a real run can score at this floor
  score       integer     not null check (score > 0 and score <= 30 * floor + 2 * floor * floor + 5000),
  species     text        not null check (char_length(species) <= 20),
  created_at  timestamptz not null default now()
);

-- the board ranks by floor, then score
create index if not exists scores_rank_idx on public.scores (floor desc, score desc);
create index if not exists scores_created_idx on public.scores (created_at desc);

alter table public.scores enable row level security;

-- anyone can read the board
create policy "read scores" on public.scores
  for select to anon using (true);

-- anyone can add a score; nobody can edit or delete through the public key
create policy "add scores" on public.scores
  for insert to anon with check (true);
