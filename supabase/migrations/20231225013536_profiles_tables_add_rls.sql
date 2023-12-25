drop policy "Public profiles are viewable by everyone." on "public"."profiles";

drop policy "Users can insert their own profile." on "public"."profiles";

drop policy "Users can update own profile." on "public"."profiles";

drop policy "Enable read access for all users" on "public"."trusts";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.rls_trusts_edit(record trusts)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN
    -- RAISE LOG 'rls_profiles_edit: profile %', record.id;
    RETURN rls_check_edit_by_created_by(record.who, FALSE, 'claim_edit_all_profiles');
END;
$function$
;

CREATE OR REPLACE FUNCTION public.rls_profiles_edit(record profiles)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN
    -- RAISE LOG 'rls_profiles_edit: profile %', record.id;
    RETURN rls_check_edit_by_created_by(record.id, FALSE, 'claim_edit_all_profiles');
END;
$function$
;

create or replace view "public"."rls_edit_for_table" as  SELECT 'authors'::text AS table_name,
    authors.id,
    rls_authors_edit(authors.*) AS editable,
    rls_authors_delete(authors.*) AS deletable
   FROM authors
UNION
 SELECT 'citations'::text AS table_name,
    citations.id,
    rls_citations_edit(citations.*) AS editable,
    rls_citations_delete(citations.*) AS deletable
   FROM citations
UNION
 SELECT 'countries'::text AS table_name,
    countries.id,
    rls_countries_edit(countries.*) AS editable,
    rls_countries_delete(countries.*) AS deletable
   FROM countries
UNION
 SELECT 'events'::text AS table_name,
    events.id,
    rls_events_edit(events.*) AS editable,
    rls_events_delete(events.*) AS deletable
   FROM events
UNION
 SELECT 'places'::text AS table_name,
    places.id,
    rls_places_edit(places.*) AS editable,
    rls_places_delete(places.*) AS deletable
   FROM places
UNION
 SELECT 'profiles'::text AS table_name,
    profiles.id,
    rls_profiles_edit(profiles.*) AS editable,
    false AS deletable
   FROM profiles
UNION
 SELECT 'towns'::text AS table_name,
    towns.id,
    rls_towns_edit(towns.*) AS editable,
    rls_towns_delete(towns.*) AS deletable
   FROM towns
UNION
 SELECT 'trusts'::text AS table_name,
    trusts.id,
    rls_trusts_edit(trusts.*) AS editable,
    rls_trusts_edit(trusts.*) AS deletable
   FROM trusts;


create policy " RLS: profiles: insert"
on "public"."profiles"
as permissive
for insert
to public
with check ((auth.uid() = auth_user_id));


create policy " RLS: profiles: update"
on "public"."profiles"
as permissive
for update
to public
using (rls_profiles_edit(profiles.*));


create policy "RLS: profiles: select"
on "public"."profiles"
as permissive
for select
to public
using (true);


create policy "RLS: trusts: delete"
on "public"."trusts"
as permissive
for delete
to authenticated
using (rls_trusts_edit(trusts.*));


create policy "RLS: trusts: insert"
on "public"."trusts"
as permissive
for insert
to authenticated
with check (rls_trusts_edit(trusts.*));


create policy "RLS: trusts: select"
on "public"."trusts"
as permissive
for select
to authenticated
using (true);


create policy "RLS: trusts: update"
on "public"."trusts"
as permissive
for update
to authenticated
using (rls_trusts_edit(trusts.*))
with check (rls_trusts_edit(trusts.*));



