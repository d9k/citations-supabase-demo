drop policy "RLS: countries: update" on "public"."countries";

alter table "public"."authors" enable row level security;

alter table "public"."citations" enable row level security;

alter table "public"."events" enable row level security;

alter table "public"."places" enable row level security;

alter table "public"."towns" enable row level security;

alter table "public"."towns" add constraint "towns_name_check" CHECK ((length(name) > 0)) not valid;

alter table "public"."towns" validate constraint "towns_name_check";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.rls_authors_delete(record authors)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN rls_check_delete_by_created_by(record.created_by);
END;
$function$
;

CREATE OR REPLACE FUNCTION public.rls_authors_edit(record authors)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN rls_check_edit_by_created_by(record.created_by);
END;
$function$
;

CREATE OR REPLACE FUNCTION public.rls_citations_delete(record citations)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN rls_check_delete_by_created_by(record.created_by);
END;
$function$
;

CREATE OR REPLACE FUNCTION public.rls_citations_edit(record citations)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN rls_check_edit_by_created_by(record.created_by);
END;
$function$
;

CREATE OR REPLACE FUNCTION public.rls_events_delete(record events)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN rls_check_delete_by_created_by(record.created_by);
END;
$function$
;

CREATE OR REPLACE FUNCTION public.rls_events_edit(record events)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN rls_check_edit_by_created_by(record.created_by);
END;
$function$
;

CREATE OR REPLACE FUNCTION public.rls_places_delete(record places)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN rls_check_delete_by_created_by(record.created_by);
END;
$function$
;

CREATE OR REPLACE FUNCTION public.rls_places_edit(record places)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN rls_check_edit_by_created_by(record.created_by);
END;
$function$
;

CREATE OR REPLACE FUNCTION public.rls_towns_delete(record towns)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN rls_check_delete_by_created_by(record.created_by);
END;
$function$
;

CREATE OR REPLACE FUNCTION public.rls_towns_edit(record towns)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN rls_check_edit_by_created_by(record.created_by);
END;
$function$
;

CREATE OR REPLACE FUNCTION public.delete_claim(uid uuid, claim text)
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
          raw_app_meta_data - claim where id = uid;
        return 'OK';
      END IF;
    END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_my_claim(claim text)
 RETURNS jsonb
 LANGUAGE sql
 STABLE
AS $function$
  select 
  	coalesce(nullif(current_setting('request.jwt.claims', true), '')::jsonb -> 'app_metadata' -> claim, null)
$function$
;

CREATE OR REPLACE FUNCTION public.get_my_claims()
 RETURNS jsonb
 LANGUAGE sql
 STABLE
AS $function$
  select 
  	coalesce(nullif(current_setting('request.jwt.claims', true), '')::jsonb -> 'app_metadata', '{}'::jsonb)::jsonb
$function$
;

CREATE OR REPLACE FUNCTION public.is_claims_admin()
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
  BEGIN
    IF session_user = 'authenticator' THEN
      --------------------------------------------
      -- To disallow any authenticated app users
      -- from editing claims, delete the following
      -- block of code and replace it with:
      -- RETURN FALSE;
      --------------------------------------------
      IF extract(epoch from now()) > coalesce((current_setting('request.jwt.claims', true)::jsonb)->>'exp', '0')::numeric THEN
        return false; -- jwt expired
      END IF;
      If current_setting('request.jwt.claims', true)::jsonb->>'role' = 'service_role' THEN
        RETURN true; -- service role users have admin rights
      END IF;
      IF coalesce((current_setting('request.jwt.claims', true)::jsonb)->'app_metadata'->'claims_admin', 'false')::bool THEN
        return true; -- user has claims_admin set to true
      ELSE
        return false; -- user does NOT have claims_admin set to true
      END IF;
      --------------------------------------------
      -- End of block 
      --------------------------------------------
    ELSE -- not a user session, probably being called from a trigger or something
      return true;
    END IF;
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
   FROM countries
UNION
 SELECT 'towns'::text AS table_name,
    towns.id,
    rls_towns_edit(towns.*) AS editable,
    rls_towns_delete(towns.*) AS deletable
   FROM towns;


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

create policy "RLS: authors: delete"
on "public"."authors"
as permissive
for delete
to authenticated
using (rls_authors_edit(authors.*));


create policy "RLS: authors: insert"
on "public"."authors"
as permissive
for insert
to authenticated
with check (rls_authors_edit(authors.*));


create policy "RLS: authors: select"
on "public"."authors"
as permissive
for select
to public
using (true);


create policy "RLS: authors: update"
on "public"."authors"
as permissive
for update
to authenticated
using (rls_authors_edit(authors.*))
with check (rls_authors_edit(authors.*));


create policy "RLS: citations: delete"
on "public"."citations"
as permissive
for delete
to authenticated
using (rls_citations_edit(citations.*));


create policy "RLS: citations: insert"
on "public"."citations"
as permissive
for insert
to authenticated
with check (rls_citations_edit(citations.*));


create policy "RLS: citations: select"
on "public"."citations"
as permissive
for select
to public
using (true);


create policy "RLS: citations: update"
on "public"."citations"
as permissive
for update
to authenticated
using (rls_citations_edit(citations.*))
with check (rls_citations_edit(citations.*));


create policy "RLS: events: delete"
on "public"."events"
as permissive
for delete
to authenticated
using (rls_events_edit(events.*));


create policy "RLS: events: insert"
on "public"."events"
as permissive
for insert
to authenticated
with check (rls_events_edit(events.*));


create policy "RLS: events: select"
on "public"."events"
as permissive
for select
to public
using (true);


create policy "RLS: events: update"
on "public"."events"
as permissive
for update
to authenticated
using (rls_events_edit(events.*))
with check (rls_events_edit(events.*));


create policy "RLS: places: delete"
on "public"."places"
as permissive
for delete
to authenticated
using (rls_places_edit(places.*));


create policy "RLS: places: insert"
on "public"."places"
as permissive
for insert
to authenticated
with check (rls_places_edit(places.*));


create policy "RLS: places: select"
on "public"."places"
as permissive
for select
to public
using (true);


create policy "RLS: places: update"
on "public"."places"
as permissive
for update
to authenticated
using (rls_places_edit(places.*))
with check (rls_places_edit(places.*));


create policy "RLS: towns: delete"
on "public"."towns"
as permissive
for delete
to authenticated
using (rls_towns_edit(towns.*));


create policy "RLS: towns: insert"
on "public"."towns"
as permissive
for insert
to authenticated
with check (rls_towns_edit(towns.*));


create policy "RLS: towns: select"
on "public"."towns"
as permissive
for select
to public
using (true);


create policy "RLS: towns: update"
on "public"."towns"
as permissive
for update
to authenticated
using (rls_towns_edit(towns.*))
with check (rls_towns_edit(towns.*));


create policy "RLS: countries: update"
on "public"."countries"
as permissive
for update
to authenticated
using (rls_countries_edit(countries.*))
with check (rls_countries_edit(countries.*));



