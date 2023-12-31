drop policy "Users can update own profile." on "public"."profiles";

create table "public"."trusts" (
    "id" bigint generated by default as identity not null,
    "who" bigint not null,
    "trusts_who" bigint not null
);

alter table "public"."trusts" enable row level security;

CREATE UNIQUE INDEX countries_name_key ON public.countries USING btree (name);

CREATE UNIQUE INDEX trusts_pkey ON public.trusts USING btree (id);

alter table "public"."trusts" add constraint "trusts_pkey" PRIMARY KEY using index "trusts_pkey";

alter table "public"."countries" add constraint "countries_name_key" UNIQUE using index "countries_name_key";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.rls_profiles_edit(record profiles)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN
    RAISE LOG 'rls_profiles_edit: profile %', record.id;
    RETURN auth.uid() = record.auth_user_id;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.rls_profiles_edit(records profiles[])
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
DECLARE
    t profiles;
BEGIN
  FOREACH t IN ARRAY records LOOP
    RAISE LOG 'rls_profiles_edit: profiles %', t.id;
    RETURN TRUE;
  END LOOP;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.temporary_fn()
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN
  RAISE LOG 'This is an informational message';
  RETURN TRUE;
END;
$function$
;

create or replace view "public"."rls_edit_for_table" as  SELECT 'profiles'::text AS table_name,
    profiles.id,
    rls_profiles_edit(profiles.*) AS editable
   FROM profiles;


create policy "Users can update own profile."
on "public"."profiles"
as permissive
for update
to public
using (rls_profiles_edit(profiles.*));



