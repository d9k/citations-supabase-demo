drop view if exists "public"."view_id_name";

alter table "public"."author" add column "name_orig" text;

alter table "public"."country" add column "name_orig" text;

alter table "public"."event" add column "name_orig" text;

alter table "public"."town" add column "name_orig" text;

create or replace view "public"."view_id_name" as  SELECT author.table_name,
    author.id,
    author.name_en AS name,
    string_limit((author.name_en)::character varying, 20) AS short_name
   FROM author
UNION
 SELECT citation.table_name,
    citation.id,
    string_limit((citation.text_en)::character varying, 40) AS name,
    string_limit((citation.text_en)::character varying, 20) AS short_name
   FROM citation
UNION
 SELECT country.table_name,
    country.id,
    country.name_en AS name,
    string_limit((country.name_en)::character varying, 20) AS short_name
   FROM country
UNION
 SELECT place.table_name,
    place.id,
    place.name_en AS name,
    string_limit((place.name_en)::character varying, 20) AS short_name
   FROM place
UNION
 SELECT 'profile'::text AS table_name,
    profile.id,
    (((profile.full_name || ' ('::text) || profile.username) || ')'::text) AS name,
    profile.username AS short_name
   FROM profile
UNION
 SELECT town.table_name,
    town.id,
    (((town.name_en || ' ('::text) || country.name_en) || ')'::text) AS name,
    ((((string_limit((town.name_en)::character varying, 20))::text || ' ('::text) || (string_limit((country.name_en)::character varying, 10))::text) || ')'::text) AS short_name
   FROM (town
     LEFT JOIN country ON ((town.country_id = country.id)))
  ORDER BY 1, 4;



