# Supabase demo

## Init schema

At first go to your project page at Supabase, choose "SQL editor" on left menu and init schema with schema you want to test, for example `demo.sql`.

## Installation

```bash
pnpm install
```

## Connecting to Supabase

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

### Data dump

```bash
pnpm run db:dump:data
pnpm run db:dump:schema
```

### Generate typescript types

```bash
pnpm exec supabase gen types typescript --linked > src/db/supabase-types-generated.ts
```

See

## Generate schema

Copy `.env.template` to `.env`. Fill environment variables values from https://supabase.com/dashboard/project/_/settings/database.

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

## .env configuration for runtime

Supabase URL & anon key for `.env` configuration:

https://supabase.com/dashboard/project/_/settings/api

## See also

Related demo projects:

- [d9k-examples: supabase-demo](https://github.com/d9k/d9k-examples/tree/main/ts/supabase-demo)
- [d9k-examples: supabase-refine](https://github.com/d9k/d9k-examples/tree/main/ts/supabase-refine)
