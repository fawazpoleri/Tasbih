# Tasbih — setup

## 1. Supabase
1. Create a project at supabase.com (free tier is fine).
2. Go to **SQL Editor**, paste the contents of `supabase-setup.sql`, and run it.
3. Go to **Authentication → Sign In / Providers → Anonymous Sign-Ins** and turn it on.
   (Without this, the app can't create a private per-device identity.)
4. Go to **Settings → API** and copy your **Project URL** and **anon public** key.
5. Open `index.html` and paste them in near the top:
   ```js
   window.SUPABASE_URL = 'https://xxxxx.supabase.co';
   window.SUPABASE_ANON_KEY = 'eyJ...';
   ```

## 2. How the privacy model works
The app signs each device in anonymously (no email/password). Supabase gives
that device a real `auth.uid()`. Row Level Security policies only let a
device read/write rows where `user_id` matches its own `auth.uid()`, so one
device can never see another's counters — even though everyone shares the
same public anon key.

Clearing browser data / reinstalling the app on that device will create a
new anonymous identity and start fresh, since there's no login to recover
the old one.

## 3. Deploy it so the PWA features work
Service workers and "Add to Home Screen" only work when the app is served
over HTTPS from a real domain — not from a local file or a sandboxed
preview. Easiest free options:
- **Netlify Drop**: drag the whole `tasbih-pwa` folder onto app.netlify.com/drop
- **GitHub Pages**: push the folder to a repo, enable Pages on it
- **Vercel**: `vercel deploy` from inside the folder

Once it's live, opening the URL on a phone will show an "Add to Home
Screen" / install prompt, and the app shell will keep working offline
(counter data itself still needs a connection to sync).

## Files
- `index.html` — the app
- `manifest.json` — PWA metadata (name, icons, colors)
- `sw.js` — service worker, caches the app shell for offline load
- `icons/` — app icons
- `supabase-setup.sql` — table + security policy
