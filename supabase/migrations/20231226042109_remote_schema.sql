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
   FROM towns
  ORDER BY 1, 4;



