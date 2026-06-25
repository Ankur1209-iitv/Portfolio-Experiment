# Portfolio & DSA Tracker

A personal site with two halves:

- **Portfolio** — About, Skills (Core Electrical + Non-core/CS), Projects, Links
- **Tracker** — log every LeetCode/Codeforces problem you solve: your intuition,
  mistakes, learnings, topic tags, and a "needs revisit" flag, plus a topic-wise
  mastery grid on the dashboard.

It's a single-user app — no sign-up flow, no login screen. Your data lives in a
free Supabase database, and a simple passphrase (set by you) gates editing so
randoms can't mess with your data if you ever share the link publicly.

## 1. Set up Supabase (free, ~5 minutes)

1. Go to [supabase.com](https://supabase.com) and create a free account + new project.
2. Once it's ready, open the **SQL Editor** (left sidebar) → **New query**.
3. Open `supabase_schema.sql` from this project, copy the whole file, paste it
   into the SQL editor, and click **Run**. This creates all the tables and
   seeds a default list of DSA/CP topics.
4. Go to **Project Settings → API**. You'll need two values:
   - **Project URL** (looks like `https://xxxxx.supabase.co`)
   - **anon public** key (a long string)

## 2. Configure the project

```bash
cp .env.example .env
```

Open `.env` and fill in:

```
VITE_SUPABASE_URL=https://your-project-ref.supabase.co
VITE_SUPABASE_ANON_KEY=your-anon-public-key
VITE_EDIT_PASSPHRASE=pick-something-only-you-know
```

`VITE_EDIT_PASSPHRASE` is just a soft lock — it's not real authentication
(there's no backend checking it), but it stops casual visitors from editing
your data if you ever share your deployed link. Treat it like a light privacy
lock, not a security boundary — anyone determined enough could bypass it, so
don't put anything truly sensitive behind it.

## 3. Run it locally

```bash
npm install
npm run dev
```

Visit `http://localhost:5173`. Click the lock icon (top right) and enter your
passphrase to unlock editing — that's how you'll add your links, skills,
projects, and log problems.

## 4. Deploy it

This is a static Vite app, so it deploys anywhere static sites are hosted —
[Vercel](https://vercel.com) and [Netlify](https://netlify.com) both have
free tiers and a "drag and drop" or "import from GitHub" flow:

1. Push this folder to a GitHub repo.
2. Import it on Vercel/Netlify.
3. Add the same three `VITE_...` environment variables in the host's project
   settings (Settings → Environment Variables).
4. Deploy. Your site is now live and reachable from any device — and since
   the data lives in Supabase, it'll be the same data no matter what device
   or browser you open it from.

## How the data is structured

- **Topics**: a fixed-ish list of DSA/CP topics (Arrays, Graphs, DP, etc.),
  seeded by the schema. You can add more from the "Log a problem" form.
- **Problems**: one row per problem, with platform, difficulty, optional
  contest name, time taken, your intuition/mistakes/learnings text, and a
  `needs_revisit` flag. Each problem can have multiple topic tags.
- **Skills**: tagged as `core-ee` or `non-core`, each with a 1–5 proficiency
  rating you set yourself.
- **Links** and **Projects**: straightforward — add/remove freely from their
  pages while unlocked.
- **Profile**: a single row holding your name, tagline, about text, email,
  location, and résumé link.

## Notes on the "no login" design

Because there's no real authentication, the **anon** Supabase key is exposed
in the frontend bundle (this is normal for Supabase's intended public-anon-key
usage, not a leak) and the database's row-level security policies allow open
read/write. This is the right tradeoff for a single-user personal site you
control — but it does mean: don't store anything truly private in here (no
passwords, no financial info), and if you ever want real multi-device login
security beyond the soft passphrase, you'd add Supabase Auth and tighten the
RLS policies to check `auth.uid()`.

## Tech stack

- React + Vite
- Tailwind CSS
- Supabase (Postgres + auto-generated REST API)
- React Router
- lucide-react (icons)
