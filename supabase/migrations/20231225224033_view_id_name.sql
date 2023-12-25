drop view if exists "public"."rls_edit_for_table";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.string_limit(s character varying, max_length integer)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN CASE WHEN length(s) > max_length
      THEN substring(s, 1, max_length - 3) || '...'
      ELSE s
      END;
END;
$function$
;

create or replace view "public"."view_id_name" as  SELECT 'authors'::text AS table_name,
    authors.id,
    authors.lastname_name_patronymic AS name,
    string_limit((authors.lastname_name_patronymic)::character varying, 20) AS short_name
   FROM authors
UNION
 SELECT 'citations'::text AS table_name,
    citations.id,
    string_limit((citations.english_text)::character varying, 40) AS name,
    string_limit((citations.english_text)::character varying, 20) AS short_name
   FROM citations
UNION
 SELECT 'countries'::text AS table_name,
    countries.id,
    countries.name,
    string_limit((countries.name)::character varying, 20) AS short_name
   FROM countries
UNION
 SELECT 'places'::text AS table_name,
    places.id,
    places.name,
    string_limit((places.name)::character varying, 20) AS short_name
   FROM places
UNION
 SELECT 'profiles'::text AS table_name,
    profiles.id,
    (((profiles.full_name || ' ('::text) || profiles.username) || ')'::text) AS name,
    profiles.username AS short_name
   FROM profiles
UNION
 SELECT 'towns'::text AS table_name,
    towns.id,
    towns.name,
    string_limit((towns.name)::character varying, 20) AS short_name
   FROM towns;


create or replace view "public"."view_rls_edit_for_table" as  SELECT 'authors'::text AS table_name,
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



