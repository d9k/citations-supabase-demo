alter table "public"."country" drop constraint "countries_name_check";

alter table "public"."country" drop constraint "countries_name_key";

alter table "public"."town" drop constraint "towns_name_check";

drop view if exists "public"."view_rls_edit_for_table";

drop index if exists "public"."countries_name_key";

alter table "public"."author" drop column "lastname_name_patronymic";

alter table "public"."author" add column "name_en" text not null;

alter table "public"."citation" drop column "english_text";

alter table "public"."citation" add column "text_en" text;

alter table "public"."event" drop column "name";

alter table "public"."event" add column "name_en" text not null;

alter table "public"."place" drop column "name";

alter table "public"."place" add column "name_en" text not null default 'in'::text;

alter table "public"."town" drop column "name";

alter table "public"."town" add column "name_en" text not null;

alter table "public"."country" drop column "name";

alter table "public"."country" add column "name_en" text not null default ''::text;

CREATE UNIQUE INDEX countries_name_key ON public.country USING btree (name_en);

alter table "public"."country" add constraint "countries_name_check" CHECK ((length(name_en) > 0)) not valid;

alter table "public"."country" validate constraint "countries_name_check";

alter table "public"."country" add constraint "countries_name_key" UNIQUE using index "countries_name_key";

alter table "public"."town" add constraint "towns_name_check" CHECK ((length(name_en) > 0)) not valid;

alter table "public"."town" validate constraint "towns_name_check";

set check_function_bodies = off;

create or replace view "public"."view_id_name" as  SELECT 'author'::text AS table_name,
    author.id,
    author.name_en AS name,
    string_limit((author.name_en)::character varying, 20) AS short_name
   FROM author
UNION
 SELECT 'citation'::text AS table_name,
    citation.id,
    string_limit((citation.text_en)::character varying, 40) AS name,
    string_limit((citation.text_en)::character varying, 20) AS short_name
   FROM citation
UNION
 SELECT 'country'::text AS table_name,
    country.id,
    country.name_en AS name,
    string_limit((country.name_en)::character varying, 20) AS short_name
   FROM country
UNION
 SELECT 'place'::text AS table_name,
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
 SELECT 'town'::text AS table_name,
    town.id,
    town.name_en AS name,
    string_limit((town.name_en)::character varying, 20) AS short_name
   FROM town
  ORDER BY 1, 4;
;


