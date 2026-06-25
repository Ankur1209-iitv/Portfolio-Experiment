-- ============================================================================
-- DSA Tracker + Portfolio — Supabase schema
-- Run this entire file in your Supabase project's SQL editor (one paste, Run).
-- ============================================================================

-- Topics: fixed-ish list of DSA topics used for tagging problems + mastery grid
create table if not exists topics (
  id          uuid primary key default gen_random_uuid(),
  name        text not null unique,
  category    text not null default 'dsa', -- 'dsa' | 'cp' (lets you separate e.g. "Graphs" vs "Number Theory")
  sort_order  int  not null default 0,
  created_at  timestamptz not null default now()
);

-- Problems: one row per problem you've solved/attempted and logged
create table if not exists problems (
  id              uuid primary key default gen_random_uuid(),
  title           text not null,
  url             text,
  platform        text not null default 'leetcode', -- 'leetcode' | 'codeforces' | 'other'
  difficulty      text,                              -- 'easy' | 'medium' | 'hard' or CF rating like '1500'
  contest_name    text,                               -- filled if solved during a contest
  time_taken_min  int,
  status          text not null default 'solved',    -- 'solved' | 'attempted' | 'revisit'
  intuition       text,                                -- your initial approach / key insight
  mistakes        text,                                -- what went wrong, bugs, wrong assumptions
  learnings       text,                                -- the takeaway / pattern to remember
  needs_revisit   boolean not null default false,      -- spaced-repetition flag
  solved_at       date not null default current_date,
  created_at      timestamptz not null default now()
);

-- Many-to-many: a problem can have multiple topic tags
create table if not exists problem_topics (
  problem_id  uuid not null references problems(id) on delete cascade,
  topic_id    uuid not null references topics(id) on delete cascade,
  primary key (problem_id, topic_id)
);

-- Skills: for the "skills I've learned" section (core Electrical + non-core/CS)
create table if not exists skills (
  id          uuid primary key default gen_random_uuid(),
  name        text not null,
  category    text not null default 'non-core', -- 'core-ee' | 'non-core'
  proficiency int  not null default 3,            -- 1-5
  notes       text,
  sort_order  int  not null default 0,
  created_at  timestamptz not null default now()
);

-- Links: for the homepage link hub (LeetCode, Codeforces, GitHub, LinkedIn, etc.)
create table if not exists links (
  id          uuid primary key default gen_random_uuid(),
  label       text not null,
  url         text not null,
  icon        text,            -- icon key, matched in frontend (e.g. 'github', 'leetcode')
  sort_order  int  not null default 0,
  created_at  timestamptz not null default now()
);

-- Projects: for the portfolio "Projects" section
create table if not exists projects (
  id           uuid primary key default gen_random_uuid(),
  title        text not null,
  description  text,
  tech_stack   text[],          -- array of tech tags
  url          text,
  repo_url     text,
  image_url    text,
  sort_order   int not null default 0,
  created_at   timestamptz not null default now()
);

-- Profile: single-row table holding your About info + resume link
create table if not exists profile (
  id          int primary key default 1,
  name        text,
  tagline     text,
  about       text,
  resume_url  text,
  email       text,
  location    text,
  updated_at  timestamptz not null default now(),
  constraint single_row check (id = 1)
);

insert into profile (id, name, tagline, about)
values (1, 'Your Name', 'Electrical Engineer · Competitive Programmer', 'Tell your story here.')
on conflict (id) do nothing;

-- ============================================================================
-- Row Level Security
-- This is a single-user app with no login screen, so the frontend connects
-- using the public "anon" key. We allow open read access (so your portfolio
-- is publicly viewable) and open write access (gated only by the soft
-- passphrase check in the UI, not real auth). If you ever want real auth,
-- swap these policies for `auth.uid() = owner_id` checks.
-- ============================================================================

alter table topics          enable row level security;
alter table problems        enable row level security;
alter table problem_topics  enable row level security;
alter table skills          enable row level security;
alter table links           enable row level security;
alter table projects        enable row level security;
alter table profile         enable row level security;

create policy "public read topics"   on topics   for select using (true);
create policy "public read problems" on problems for select using (true);
create policy "public read problem_topics" on problem_topics for select using (true);
create policy "public read skills"   on skills   for select using (true);
create policy "public read links"    on links    for select using (true);
create policy "public read projects" on projects for select using (true);
create policy "public read profile"  on profile  for select using (true);

create policy "public write topics"   on topics   for all using (true) with check (true);
create policy "public write problems" on problems for all using (true) with check (true);
create policy "public write problem_topics" on problem_topics for all using (true) with check (true);
create policy "public write skills"   on skills   for all using (true) with check (true);
create policy "public write links"    on links    for all using (true) with check (true);
create policy "public write projects" on projects for all using (true) with check (true);
create policy "public write profile"  on profile  for all using (true) with check (true);

-- ============================================================================
-- Seed topics — a sensible default DSA/CP topic list. Edit freely afterwards.
-- ============================================================================
insert into topics (name, category, sort_order) values
  ('Arrays', 'dsa', 1),
  ('Strings', 'dsa', 2),
  ('Two Pointers', 'dsa', 3),
  ('Sliding Window', 'dsa', 4),
  ('Hashing', 'dsa', 5),
  ('Sorting', 'dsa', 6),
  ('Binary Search', 'dsa', 7),
  ('Recursion / Backtracking', 'dsa', 8),
  ('Stack / Queue', 'dsa', 9),
  ('Linked List', 'dsa', 10),
  ('Trees', 'dsa', 11),
  ('Binary Search Tree', 'dsa', 12),
  ('Heap / Priority Queue', 'dsa', 13),
  ('Graphs', 'dsa', 14),
  ('Dynamic Programming', 'dsa', 15),
  ('Greedy', 'dsa', 16),
  ('Bit Manipulation', 'dsa', 17),
  ('Number Theory', 'cp', 18),
  ('Combinatorics', 'cp', 19),
  ('Game Theory', 'cp', 20),
  ('Trie', 'dsa', 21),
  ('Union Find (DSU)', 'dsa', 22),
  ('Segment Tree / Fenwick', 'cp', 23),
  ('Math', 'cp', 24),
  ('Implementation', 'cp', 25)
on conflict (name) do nothing;
