drop view if exists "public"."view_id_name";

-- alter table "public"."author" drop column "created_at";

-- alter table "public"."author" drop column "created_by";

-- alter table "public"."author" drop column "id";

-- alter table "public"."author" drop column "updated_at";

-- alter table "public"."author" drop column "updated_by";

alter table "public"."author" add column "published_at" timestamp with time zone;

alter table "public"."author" add column "published_by" bigint;

alter table "public"."author" add column "table_name" text not null default 'author'::text;

alter table "public"."author" add column "unpublished_at" timestamp with time zone;

alter table "public"."author" add column "unpublished_by" bigint;

alter table "public"."author" add column "published" boolean generated always as (((published_at IS NOT NULL) AND (unpublished_at IS NULL))) stored;

-- alter table "public"."citation" drop column "created_at";

-- alter table "public"."citation" drop column "created_by";

-- alter table "public"."citation" drop column "id";

alter table "public"."citation" drop column "updated_at";
alter table "public"."citation" add column "updated_at" timestamp with time zone;

-- alter table "public"."citation" drop column "updated_by";

alter table "public"."citation" add column "published_at" timestamp with time zone;

alter table "public"."citation" add column "published_by" bigint;

alter table "public"."citation" add column "table_name" text not null default 'citation'::text;

alter table "public"."citation" add column "unpublished_at" timestamp with time zone;

alter table "public"."citation" add column "unpublished_by" bigint;

alter table "public"."citation" add column "published" boolean generated always as (((published_at IS NOT NULL) AND (unpublished_at IS NULL))) stored;

-- alter table "public"."event" drop column "created_at";

-- alter table "public"."event" drop column "created_by";

-- alter table "public"."event" drop column "id";

-- alter table "public"."event" drop column "updated_at";

-- alter table "public"."event" drop column "updated_by";

alter table "public"."event" add column "published_at" timestamp with time zone;

alter table "public"."event" add column "published_by" bigint;

alter table "public"."event" add column "table_name" text not null default 'event'::text;

alter table "public"."event" add column "unpublished_at" timestamp with time zone;

alter table "public"."event" add column "unpublished_by" bigint;

alter table "public"."event" add column "published" boolean generated always as (((published_at IS NOT NULL) AND (unpublished_at IS NULL))) stored;

-- alter table "public"."place" drop column "created_at";

-- alter table "public"."place" drop column "created_by";

-- alter table "public"."place" drop column "id";

-- alter table "public"."place" drop column "updated_at";

-- alter table "public"."place" drop column "updated_by";

alter table "public"."place" add column "published_at" timestamp with time zone;

alter table "public"."place" add column "published_by" bigint;

alter table "public"."place" add column "table_name" text not null default 'place'::text;

alter table "public"."place" add column "unpublished_at" timestamp with time zone;

alter table "public"."place" add column "unpublished_by" bigint;

alter table "public"."place" add column "published" boolean generated always as (((published_at IS NOT NULL) AND (unpublished_at IS NULL))) stored;

-- alter table "public"."town" drop column "created_at";

-- alter table "public"."town" drop column "created_by";

-- alter table "public"."town" drop column "id";

-- alter table "public"."town" drop column "updated_at";

-- alter table "public"."town" drop column "updated_by";

alter table "public"."town" add column "published_at" timestamp with time zone;

alter table "public"."town" add column "published_by" bigint;

alter table "public"."town" add column "table_name" text not null default 'town'::text;

alter table "public"."town" add column "unpublished_at" timestamp with time zone;

alter table "public"."town" add column "unpublished_by" bigint;

alter table "public"."town" add column "published" boolean generated always as (((published_at IS NOT NULL) AND (unpublished_at IS NULL))) stored;

alter table "public"."author" add constraint "author_table_name_check" CHECK ((table_name = 'author'::text)) NOT VALID not valid;

alter table "public"."author" validate constraint "author_table_name_check";

alter table "public"."citation" add constraint "citation_table_name_check" CHECK ((table_name = 'citation'::text)) NOT VALID not valid;

alter table "public"."citation" validate constraint "citation_table_name_check";

alter table "public"."event" add constraint "event_table_name_check" CHECK ((table_name = 'event'::text)) NOT VALID not valid;

alter table "public"."event" validate constraint "event_table_name_check";

alter table "public"."place" add constraint "place_table_name_check" CHECK ((table_name = 'place'::text)) NOT VALID not valid;

alter table "public"."place" validate constraint "place_table_name_check";

alter table "public"."town" add constraint "town_table_name_check" CHECK ((table_name = 'town'::text)) NOT VALID not valid;

alter table "public"."town" validate constraint "town_table_name_check";

alter table "public"."author" inherit "public"."content_item";

alter table "public"."citation" inherit "public"."content_item";

alter table "public"."event" inherit "public"."content_item";

alter table "public"."place" inherit "public"."content_item";

alter table "public"."town" inherit "public"."content_item";

set check_function_bodies = off;

create or replace view "public"."view_rls_edit_for_table" as  SELECT view_rls_content_item.table_name,
    view_rls_content_item.id,
    view_rls_content_item.editable,
    view_rls_content_item.deletable
   FROM view_rls_content_item
UNION
 SELECT 'profile'::text AS table_name,
    profile.id,
    rls_profiles_edit(profile.*) AS editable,
    false AS deletable
   FROM profile
UNION
 SELECT 'trust'::text AS table_name,
    trust.id,
    rls_trusts_edit(trust.*) AS editable,
    rls_trusts_edit(trust.*) AS deletable
   FROM trust
  ORDER BY 1, 2;

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
    town.name_en AS name,
    string_limit((town.name_en)::character varying, 20) AS short_name
   FROM town
  ORDER BY 1, 4;



