# Supabase Project Pin

Dust Heist is pinned to Aimbotic's Supabase project:

- Project ref: `uotzmpttpekpkcjxurjj`
- Project URL: `https://uotzmpttpekpkcjxurjj.supabase.co`

Set local Supabase environment values from `.env.example`. The app must not connect unless the configured Supabase URL resolves to `https://uotzmpttpekpkcjxurjj.supabase.co`.

The Trusted Bums project ref `vaoqvtxqvbptyxddpoju` is explicitly blocked. Do not use it in this repo's app config, documentation, examples, deployment settings, or local environment.

Use `SupabaseConfig.is_connection_ready()` before any Supabase client is created. If `SupabaseConfig.configure()` or `SupabaseConfig.load_from_environment()` returns `false`, leave Supabase disabled for that run.
