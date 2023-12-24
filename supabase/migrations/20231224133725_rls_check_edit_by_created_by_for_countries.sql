drop policy "countries: authed can all" on "public"."countries";

alter table "public"."trusts" rename column "trusts_who" to "trusts_whom";

alter table "public"."trusts" add column "end_at" timestamp with time zone not null default (now() + '1 day'::interval);

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.rls_check_edit_by_created_by(created_by bigint, allow_trust boolean DEFAULT true, claim_check character varying DEFAULT 'claim_edit_all_content'::character varying)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
DECLARE
	profile_id int8;
BEGIN
  profile_id := get_my_claim('profile_id')::int;
	-- RAISE WARNING 'rls_check_by_created_by: created_by: %, profile_id: %', created_by, profile_id;
	-- RETURN TRUE;
	RETURN get_my_claim(claim_check)::varchar::boolean
	    OR (profile_id = created_by)
	   	OR (
				allow_trust AND ((
					SELECT TRUE
					FROM trusts
					WHERE NOW() < trusts.end_at
					AND created_by = trusts.who
						AND profile_id = trusts.trusts_whom
				))
			);
END;
$function$
;

CREATE OR REPLACE FUNCTION public.rls_check_delete_by_created_by(created_by bigint, allow_trust boolean DEFAULT true, claim_check character varying DEFAULT 'claim_delete_all_content'::character varying)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN
	RETURN rls_check_edit_by_created_by(created_by, allow_trust, claim_check);
END;
$function$
;

CREATE OR REPLACE FUNCTION public.rls_countries_delete(record countries)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN rls_check_delete_by_created_by(record.created_by);
END;
$function$
;

CREATE OR REPLACE FUNCTION public.rls_countries_edit(record countries)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN rls_check_edit_by_created_by(record.created_by);
END;
$function$
;

create or replace view "public"."rls_edit_for_table" as  SELECT 'profiles'::text AS table_name,
    profiles.id,
    rls_profiles_edit(profiles.*) AS editable,
    false AS deletable
   FROM profiles
UNION
 SELECT 'countries'::text AS table_name,
    countries.id,
    rls_countries_edit(countries.*) AS editable,
    rls_countries_delete(countries.*) AS deletable
   FROM countries;


CREATE OR REPLACE FUNCTION public.set_claim(uid uuid, claim text, value jsonb)
 RETURNS text
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
    BEGIN
      IF NOT is_claims_admin() THEN
          RETURN 'error: access denied';
      ELSE
        update auth.users set raw_app_meta_data =
          raw_app_meta_data ||
            json_build_object(claim, value)::jsonb where id = uid;
        return 'OK';
      END IF;
    END;
$function$
;

create policy "RLS: countries: delete"
on "public"."countries"
as permissive
for delete
to authenticated
using (rls_countries_edit(countries.*));


create policy "RLS: countries: insert"
on "public"."countries"
as permissive
for insert
to authenticated
with check (rls_countries_edit(countries.*));


create policy "RLS: countries: select"
on "public"."countries"
as permissive
for select
to public
using (true);


create policy "RLS: countries: update"
on "public"."countries"
as permissive
for update
to authenticated
with check (rls_countries_edit(countries.*));


create policy "Enable read access for all users"
on "public"."trusts"
as permissive
for select
to public
using (true);



