drop policy "RLS: country: select" on "public"."country";

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


CREATE OR REPLACE FUNCTION public.content_item_publish(_table_name text, _id integer)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
-- DECLARE
--   exception_text TEXT;
BEGIN
  -- also is checked in before update trigger in content_item_edit_protect_generated_fields()
  -- exception_text := permission_publish_check();
  PERFORM permission_publish_check();

  -- IF exception_text IS NOT NULL THEN
  --   RETURN exception_text;
  -- END IF;

  -- SET session_replication_role = replica;

  UPDATE content_item
  SET published_at = NOW(),
      published_by = get_my_claim('profile_id')::int,
      unpublished_at = NULL,
      unpublished_by = NULL
  WHERE table_name = _table_name 
    AND id = _id;
  -- FORMAT('UPDATE %I VALUES ($1,$2)'::text ,v_partition_name) using NEW.id,NEW.datetime;

  -- RETURN NULL;
  -- SET session_replication_role = origin;
END;
$function$
;

create or replace view "public"."view_rls_edit_for_table" as  SELECT view_rls_content_item.table_name,
    view_rls_content_item.id,
    view_rls_content_item.editable,
    view_rls_content_item.deletable
   FROM view_rls_content_item
UNION
 SELECT 'author'::text AS table_name,
    author.id,
    rls_authors_edit(author.*) AS editable,
    rls_authors_delete(author.*) AS deletable
   FROM author
UNION
 SELECT 'citation'::text AS table_name,
    citation.id,
    rls_citations_edit(citation.*) AS editable,
    rls_citations_delete(citation.*) AS deletable
   FROM citation
UNION
 SELECT 'event'::text AS table_name,
    event.id,
    rls_events_edit(event.*) AS editable,
    rls_events_delete(event.*) AS deletable
   FROM event
UNION
 SELECT 'place'::text AS table_name,
    place.id,
    rls_places_edit(place.*) AS editable,
    rls_places_delete(place.*) AS deletable
   FROM place
UNION
 SELECT 'profile'::text AS table_name,
    profile.id,
    rls_profiles_edit(profile.*) AS editable,
    false AS deletable
   FROM profile
UNION
 SELECT 'town'::text AS table_name,
    town.id,
    rls_towns_edit(town.*) AS editable,
    rls_towns_delete(town.*) AS deletable
   FROM town
UNION
 SELECT 'trust'::text AS table_name,
    trust.id,
    rls_trusts_edit(trust.*) AS editable,
    rls_trusts_edit(trust.*) AS deletable
   FROM trust
  ORDER BY 1, 2;


create policy "RLS: country: select (guest)"
on "public"."country"
as permissive
for select
to anon
using (published);


create policy "RLS: country: select"
on "public"."country"
as permissive
for select
to authenticated
using (true);



