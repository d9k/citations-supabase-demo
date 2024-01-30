# Supabase demo

## .env configuration for direct PostgreSQL connection

Copy `.env.template` to `.env`.

Fill environment variables `ULTRA_PUBLIC_SUPABASE_URL`, `ULTRA_PUBLIC_SUPABASE_ANON_KEY` at `.env` values from https://supabase.com/dashboard/project/_/settings/database.

`ULTRA_` prefix means variables will be available at `ultra` frontend.

## .env configuration for runtime

Supabase URL & anon key for `.env` configuration:

https://supabase.com/dashboard/project/_/settings/api

## Adding admin permissions

Get user id from schema `auth`, table `users`, column `id`. Id example: `ccdcd9a1-2df3-4cdf-8298-a37cd209dd0d`.

Example query to add claim:

```sql
SELECT set_claim('ccdcd9a1-2df3-4cdf-8298-a37cd209dd0d'::uuid, 'claim_edit_all_content', '1');
```

User must relogin to use updated permissions.

Function `set_claim` installed from [custom claims](https://github.com/supabase-community/supabase-custom-claims) project.

### Available claims:

- `claim_edit_all_content` - edit content created by other users
- `claim_delete_all_content` - delete content created by other users
- `claim_edit_all_profiles` - edit other users profiles
- `claim_publish` - publish and unpublish content rows (make visible for guests).

## Connecting (linking) to Supabase

### Login to Supabase

Generate access token at https://supabase.com/dashboard/account/tokens, then

```bash
pnpm exec supabase login
```

Then enter access token. Local system keyring password may be asked then.

### Link to Supabase project

Then go to your project subase settings -> Project settings -> general -> copy "<Reference_ID>"

and run

```bash
pnpm exec supabase link --project-ref=<Reference_ID>
```

If error `cannot read config in ...: open supabase/config.toml` run `pnpm exec supabase init` first.

## Installation

```bash
pnpm install
```

## Init schema

At first go to your project page at Supabase, choose "SQL editor" on left menu and init schema with schema you want to test, for example `demo.sql`.

### Data dump (via `supabase db dump ...`)

```bash
pnpm run db:dump:data
pnpm run db:dump:schema
pnpm run db:dump:migration
```

or just

```bash
pnpm run db:dump
```

### Data dump (via `pg_dump`)

[\`supabase db dump\` doesn't dump triggers | issue #1726 | cli](https://github.com/supabase/cli/issues/1726)

```bash
deno task run db-pg-dump
```

### Generate typescript types

```bash
pnpm exec supabase gen types typescript --linked > src/db/supabase-types-generated.ts
```

See

## Generate schema

Execute `pnpm run db:gen:json-schema`.

## Migrations: after remote change

After schema change on remote database:

```bash
pnpm exec supabase db pull
```

If scipt asks `Update remote migration history table? [Y/n]` choose `n` to not rename

New migration `supabase/migrations/NNNNNNNNNNNNNN_remote_schema.sql` will be created. Rename `remote_schema` to more meaningful name.

Then list migations with new one:

```bash
pnpm exec supabase migration list
```

If migration not marked remote as applied, then

```bash
pnpm exec supabase migration repair 202XXXXXXXXXX --status applied
```

when `202XXXXXXXXXX` is local migration timestamp

## See also

Related demo projects:

- [d9k-examples: supabase-demo](https://github.com/d9k/d9k-examples/tree/main/ts/supabase-demo)
- [d9k-examples: supabase-refine](https://github.com/d9k/d9k-examples/tree/main/ts/supabase-refine)
