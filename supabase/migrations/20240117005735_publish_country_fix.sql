drop view if exists "public"."view_id_name";

alter table "public"."content_item" add column "published" boolean generated always as (((published_at IS NOT NULL) AND (unpublished_at IS NULL))) stored;

-- -- ERROR: column "published" of relation "country" already exists (SQLSTATE 42701)
-- alter table "public"."country" add column "published" boolean generated always as (((published_at IS NOT NULL) AND (unpublished_at IS NULL))) stored;

set check_function_bodies = off;

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

CREATE OR REPLACE FUNCTION public.permission_publish_check()
 RETURNS void
 LANGUAGE plpgsql
AS $function$
-- DECLARE
--   exception_text TEXT;
BEGIN
  IF NOT permission_publish_get() THEN
    -- exception_text := 'Publish permission required';
    RAISE EXCEPTION 'Publish permission required';
    -- RETURN exception_text;
  END IF;
  -- RETURN NULL;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.permission_publish_get()
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN
  RETURN COALESCE(get_my_claim('claim_publish')::varchar::boolean, FALSE) OR is_claims_admin();
END;
$function$
;

-- create or replace view "public"."view_id_name" as  SELECT 'author'::text AS table_name,
--     author.id,
--     author.lastname_name_patronymic AS name,
--     string_limit((author.lastname_name_patronymic)::character varying, 20) AS short_name
--    FROM author
-- UNION
--  SELECT 'citation'::text AS table_name,
--     citation.id,
--     string_limit((citation.english_text)::character varying, 40) AS name,
--     string_limit((citation.english_text)::character varying, 20) AS short_name
--    FROM citation
-- UNION
--  SELECT 'country'::text AS table_name,
--     country.id,
--     country.name,
--     string_limit((country.name)::character varying, 20) AS short_name
--    FROM country
-- UNION
--  SELECT 'place'::text AS table_name,
--     place.id,
--     place.name,
--     string_limit((place.name)::character varying, 20) AS short_name
--    FROM place
-- UNION
--  SELECT 'profile'::text AS table_name,
--     profile.id,
--     (((profile.full_name || ' ('::text) || profile.username) || ')'::text) AS name,
--     profile.username AS short_name
--    FROM profile
-- UNION
--  SELECT 'town'::text AS table_name,
--     town.id,
--     town.name,
--     string_limit((town.name)::character varying, 20) AS short_name
--    FROM town
--   ORDER BY 1, 4;



