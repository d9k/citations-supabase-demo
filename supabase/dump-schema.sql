
SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

CREATE EXTENSION IF NOT EXISTS "pgsodium" WITH SCHEMA "pgsodium";

CREATE EXTENSION IF NOT EXISTS "pg_graphql" WITH SCHEMA "graphql";

CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";

CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";

CREATE EXTENSION IF NOT EXISTS "pgjwt" WITH SCHEMA "extensions";

CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";

SET default_tablespace = '';

SET default_table_access_method = "heap";

CREATE TABLE IF NOT EXISTS "public"."content_item" (
    "table_name" "text" NOT NULL,
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "created_by" bigint,
    "updated_at" timestamp with time zone,
    "updated_by" bigint,
    "published_at" timestamp with time zone,
    "published_by" bigint,
    "unpublished_at" timestamp with time zone,
    "unpublished_by" bigint,
    "published" boolean GENERATED ALWAYS AS ((("published_at" IS NOT NULL) AND ("unpublished_at" IS NULL))) STORED
);

ALTER TABLE "public"."content_item" OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."content_item_edit_protect_generated_fields"("new" "public"."content_item", "old" "public"."content_item") RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  PERFORM protect_generated_field_from_change(new.id, old.id, 'id');
  PERFORM protect_generated_field_from_change(new.table_name, old.table_name, 'table_name');
  PERFORM protect_generated_field_from_change(new.created_at, old.created_at, 'created_at');
  PERFORM protect_generated_field_from_change(new.created_by, old.created_by, 'created_by');
  PERFORM protect_generated_field_from_change(new.updated_at, old.updated_at, 'updated_at');
  PERFORM protect_generated_field_from_change(new.updated_by, old.updated_by, 'updated_by');

  IF NOT permission_publish_get() THEN
    PERFORM protect_generated_field_from_change(new.published_at, old.published_at, 'published_at');
    PERFORM protect_generated_field_from_change(new.published_by, old.published_by, 'published_by');  
    PERFORM protect_generated_field_from_change(new.unpublished_at, old.unpublished_at, 'unpublished_at');  
    PERFORM protect_generated_field_from_change(new.unpublished_by, old.unpublished_by, 'unpublished_by');  
  END IF;
END;
$$;

ALTER FUNCTION "public"."content_item_edit_protect_generated_fields"("new" "public"."content_item", "old" "public"."content_item") OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."content_item_new_protect_generated_fields"("new" "public"."content_item") RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  -- PERFORM protect_generated_field_from_init(new.table_name, 'table_name');
  -- PERFORM protect_generated_field_from_init(new.created_at, 'created_at');
  PERFORM protect_generated_field_from_init(new.created_by, 'created_by');
  -- PERFORM protect_generated_field_from_init(new.updated_at, 'updated_at');
  PERFORM protect_generated_field_from_init(new.updated_by, 'updated_by');
  PERFORM protect_generated_field_from_init(new.published_at, 'published_at');
  PERFORM protect_generated_field_from_init(new.published_by, 'published_by');  
  PERFORM protect_generated_field_from_init(new.published_by, 'unpublished_at');  
  PERFORM protect_generated_field_from_init(new.published_by, 'unpublished_by');  
END;
$$;

ALTER FUNCTION "public"."content_item_new_protect_generated_fields"("new" "public"."content_item") OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."content_item_publish"("_table_name" "text", "_id" integer) RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $_$
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
$_$;

ALTER FUNCTION "public"."content_item_publish"("_table_name" "text", "_id" integer) OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."content_item_unpublish"("_table_name" "text", "_id" integer) RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
  -- also is checked in before update trigger in content_item_edit_protect_generated_fields()
  PERFORM permission_publish_check();

  UPDATE content_item
  SET unpublished_at = NOW(),
      unpublished_by = get_my_claim('profile_id')::int
  WHERE table_name = _table_name 
    AND id = _id;
END;
$$;

ALTER FUNCTION "public"."content_item_unpublish"("_table_name" "text", "_id" integer) OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."delete_claim"("uid" "uuid", "claim" "text") RETURNS "text"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
    BEGIN
      IF NOT is_claims_admin() THEN
          RETURN 'error: access denied';
      ELSE        
        update auth.users set raw_app_meta_data = 
          raw_app_meta_data - claim where id = uid;
        return 'OK';
      END IF;
    END;
$$;

ALTER FUNCTION "public"."delete_claim"("uid" "uuid", "claim" "text") OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."equal_or_both_null"("a" "anycompatible", "b" "anycompatible") RETURNS boolean
    LANGUAGE "plpgsql"
    AS $$
DECLARE
  result BOOLEAN;
BEGIN
  result := (a = b) OR (a IS NULL AND b IS NULL);
  IF result IS NULL THEN 
    RETURN FALSE;
  END IF;
  RETURN result;
END;
$$;

ALTER FUNCTION "public"."equal_or_both_null"("a" "anycompatible", "b" "anycompatible") OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."fn_any_type"("r" "record") RETURNS "record"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
	t record;
BEGIN
  t := r;
  t.updated_at := NOW();
	RETURN t;
END;
$$;

ALTER FUNCTION "public"."fn_any_type"("r" "record") OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."get_claim"("uid" "uuid", "claim" "text") RETURNS "jsonb"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
    DECLARE retval jsonb;
    BEGIN
      IF NOT is_claims_admin() THEN
          RETURN '{"error":"access denied"}'::jsonb;
      ELSE
        select coalesce(raw_app_meta_data->claim, null) from auth.users into retval where id = uid::uuid;
        return retval;
      END IF;
    END;
$$;

ALTER FUNCTION "public"."get_claim"("uid" "uuid", "claim" "text") OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."get_claims"("uid" "uuid") RETURNS "jsonb"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
    DECLARE retval jsonb;
    BEGIN
      IF NOT is_claims_admin() THEN
          RETURN '{"error":"access denied"}'::jsonb;
      ELSE
        select raw_app_meta_data from auth.users into retval where id = uid::uuid;
        return retval;
      END IF;
    END;
$$;

ALTER FUNCTION "public"."get_claims"("uid" "uuid") OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."get_my_claim"("claim" "text") RETURNS "jsonb"
    LANGUAGE "sql" STABLE
    AS $$
  select 
  	coalesce(nullif(current_setting('request.jwt.claims', true), '')::jsonb -> 'app_metadata' -> claim, null)
$$;

ALTER FUNCTION "public"."get_my_claim"("claim" "text") OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."get_my_claims"() RETURNS "jsonb"
    LANGUAGE "sql" STABLE
    AS $$
  select 
  	coalesce(nullif(current_setting('request.jwt.claims', true), '')::jsonb -> 'app_metadata', '{}'::jsonb)::jsonb
$$;

ALTER FUNCTION "public"."get_my_claims"() OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."handle_auth_user_new"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
  INSERT INTO public.profile (auth_user_id, full_name, avatar_url)
	  VALUES (
		  NEW.id,
		  NEW.raw_user_meta_data->>'full_name',
		  NEW.raw_user_meta_data->>'avatar_url'
	  );
  RETURN NEW;
END;
$$;

ALTER FUNCTION "public"."handle_auth_user_new"() OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."handle_content_item_edit"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
DECLARE
	check_result BOOLEAN;  
BEGIN
  -- check_result := content_item_protect_generated_fields(NEW, OLD);

  -- IF NOT check_result THEN
  --   RETURN NULL;
  -- END IF;

  -- IF NEW.published_at <> OLD.published_at THEN
  --   RAISE EXCEPTION 'published_at is autogenerated field. Change not allowed';
  --   RETURN NULL;
  --   -- RETURN FALSE;
  -- END IF;

  PERFORM content_item_edit_protect_generated_fields(NEW, OLD);

  RETURN record_fill_updated_by(record_fill_updated_at(NEW));
END;
$$;

ALTER FUNCTION "public"."handle_content_item_edit"() OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."handle_content_item_new"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
  PERFORM content_item_new_protect_generated_fields(NEW);

  RETURN record_fill_created_by(NEW);
END;
$$;

ALTER FUNCTION "public"."handle_content_item_new"() OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."handle_fill_created_by"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
  NEW.created_by := get_my_claim('profile_id');
  RETURN NEW;
END;
$$;

ALTER FUNCTION "public"."handle_fill_created_by"() OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."handle_fill_updated"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
  NEW.updated_by := get_my_claim('profile_id');
  NEW.updated_at := NOW();
  RETURN NEW;
END;
$$;

ALTER FUNCTION "public"."handle_fill_updated"() OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."handle_public_profile_new"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$

BEGIN

/**
 * see `set claim` at
 * https://github.com/supabase-community/supabase-custom-claims/blob/main/install.sql
 **/
  UPDATE auth.users
  SET
	  raw_app_meta_data = COALESCE(
		  raw_app_meta_data || JSON_BUILD_OBJECT('profile_id', NEW.id)::jsonb,
		  JSON_BUILD_OBJECT('profile_id', NEW.id)::jsonb
	  )
  WHERE id = NEW.auth_user_id;

  RETURN NEW;
END;
$$;

ALTER FUNCTION "public"."handle_public_profile_new"() OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."is_claims_admin"() RETURNS boolean
    LANGUAGE "plpgsql"
    AS $$
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
$$;

ALTER FUNCTION "public"."is_claims_admin"() OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."permission_publish_check"() RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  IF NOT permission_publish_get() THEN
    -- exception_text := 'Publish permission required';
    RAISE EXCEPTION 'Publish permission required';
    -- RETURN exception_text;
  END IF;
  -- RETURN NULL;
END;
$$;

ALTER FUNCTION "public"."permission_publish_check"() OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."permission_publish_get"() RETURNS boolean
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  RETURN COALESCE(get_my_claim('claim_publish')::varchar::boolean, FALSE) OR is_claims_admin();
END;
$$;

ALTER FUNCTION "public"."permission_publish_get"() OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."protect_generated_field_from_change"("a" "anyelement", "b" "anyelement", "variable_name" "text") RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  IF NOT (equal_or_both_null(a, b)) THEN
    RAISE EXCEPTION '"%" is autogenerated field. Change not allowed', variable_name;
  END IF;
END;
$$;

ALTER FUNCTION "public"."protect_generated_field_from_change"("a" "anyelement", "b" "anyelement", "variable_name" "text") OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."protect_generated_field_from_init"("a" "anyelement", "variable_name" "text") RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  IF a IS NOT NULL THEN
    RAISE EXCEPTION '"%" is autogenerated field. Init is not allowed', variable_name;
  END IF;
END;
$$;

ALTER FUNCTION "public"."protect_generated_field_from_init"("a" "anyelement", "variable_name" "text") OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."record_fill_created_by"("r" "record") RETURNS "record"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
	t record;
BEGIN
  t := r;
  t.created_by := get_my_claim('profile_id');
	RETURN t;
END;
$$;

ALTER FUNCTION "public"."record_fill_created_by"("r" "record") OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."record_fill_updated_at"("r" "record") RETURNS "record"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
	t record;
BEGIN
  t := r;
  t.updated_at := NOW();
	RETURN t;
END;
$$;

ALTER FUNCTION "public"."record_fill_updated_at"("r" "record") OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."record_fill_updated_by"("r" "record") RETURNS "record"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
	t record;
BEGIN
  t := r;
  t.updated_by := get_my_claim('profile_id');
	RETURN t;
END;
$$;

ALTER FUNCTION "public"."record_fill_updated_by"("r" "record") OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."author" (
    "id" bigint NOT NULL,
    "lastname_name_patronymic" "text" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "birth_year" bigint,
    "death_year" bigint,
    "approximate_years" boolean DEFAULT false NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "birth_town" bigint,
    "created_by" bigint,
    "updated_by" bigint
);

ALTER TABLE "public"."author" OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."rls_authors_delete"("record" "public"."author") RETURNS boolean
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    RETURN rls_check_delete_by_created_by(record.created_by);
END;
$$;

ALTER FUNCTION "public"."rls_authors_delete"("record" "public"."author") OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."rls_authors_edit"("record" "public"."author") RETURNS boolean
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    RETURN rls_check_edit_by_created_by(record.created_by);
END;
$$;

ALTER FUNCTION "public"."rls_authors_edit"("record" "public"."author") OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."rls_check_delete_by_created_by"("created_by" bigint, "allow_trust" boolean DEFAULT true, "claim_check" character varying DEFAULT 'claim_delete_all_content'::character varying) RETURNS boolean
    LANGUAGE "plpgsql"
    AS $$
BEGIN
	RETURN rls_check_edit_by_created_by(created_by, allow_trust, claim_check);
END;
$$;

ALTER FUNCTION "public"."rls_check_delete_by_created_by"("created_by" bigint, "allow_trust" boolean, "claim_check" character varying) OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."rls_check_edit_by_created_by"("created_by" bigint, "allow_trust" boolean DEFAULT true, "claim_check" character varying DEFAULT 'claim_edit_all_content'::character varying) RETURNS boolean
    LANGUAGE "plpgsql"
    AS $$
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
					FROM trust
					WHERE NOW() < trust.end_at
					AND created_by = trust.who
						AND profile_id = trust.trusts_whom
				))
			);
END;
$$;

ALTER FUNCTION "public"."rls_check_edit_by_created_by"("created_by" bigint, "allow_trust" boolean, "claim_check" character varying) OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."citation" (
    "id" bigint NOT NULL,
    "english_text" "text",
    "author_id" bigint NOT NULL,
    "year" bigint,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp without time zone DEFAULT "now"() NOT NULL,
    "original_language_text" "text",
    "place_id" bigint,
    "event_id" bigint,
    "created_by" bigint,
    "updated_by" bigint
);

ALTER TABLE "public"."citation" OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."rls_citations_delete"("record" "public"."citation") RETURNS boolean
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    RETURN rls_check_delete_by_created_by(record.created_by);
END;
$$;

ALTER FUNCTION "public"."rls_citations_delete"("record" "public"."citation") OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."rls_citations_edit"("record" "public"."citation") RETURNS boolean
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    RETURN rls_check_edit_by_created_by(record.created_by);
END;
$$;

ALTER FUNCTION "public"."rls_citations_edit"("record" "public"."citation") OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."rls_content_item_check_delete"("record" "public"."content_item") RETURNS boolean
    LANGUAGE "plpgsql"
    AS $$
BEGIN
	RETURN rls_check_delete_by_created_by(record.created_by);
END;
$$;

ALTER FUNCTION "public"."rls_content_item_check_delete"("record" "public"."content_item") OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."rls_content_item_check_edit"("record" "public"."content_item") RETURNS boolean
    LANGUAGE "plpgsql"
    AS $$
BEGIN
	RETURN rls_check_edit_by_created_by(record.created_by);
END;
$$;

ALTER FUNCTION "public"."rls_content_item_check_edit"("record" "public"."content_item") OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."event" (
    "id" bigint NOT NULL,
    "name" "text" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "start_year" bigint NOT NULL,
    "start_month" smallint NOT NULL,
    "end_year" bigint,
    "end_month" smallint,
    "place_id" bigint,
    "created_by" bigint,
    "updated_by" bigint
);

ALTER TABLE "public"."event" OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."rls_events_delete"("record" "public"."event") RETURNS boolean
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    RETURN rls_check_delete_by_created_by(record.created_by);
END;
$$;

ALTER FUNCTION "public"."rls_events_delete"("record" "public"."event") OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."rls_events_edit"("record" "public"."event") RETURNS boolean
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    RETURN rls_check_edit_by_created_by(record.created_by);
END;
$$;

ALTER FUNCTION "public"."rls_events_edit"("record" "public"."event") OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."place" (
    "id" bigint NOT NULL,
    "name" "text" DEFAULT 'in'::"text" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "town_id" bigint NOT NULL,
    "created_by" bigint,
    "updated_by" bigint
);

ALTER TABLE "public"."place" OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."rls_places_delete"("record" "public"."place") RETURNS boolean
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    RETURN rls_check_delete_by_created_by(record.created_by);
END;
$$;

ALTER FUNCTION "public"."rls_places_delete"("record" "public"."place") OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."rls_places_edit"("record" "public"."place") RETURNS boolean
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    RETURN rls_check_edit_by_created_by(record.created_by);
END;
$$;

ALTER FUNCTION "public"."rls_places_edit"("record" "public"."place") OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."profile" (
    "auth_user_id" "uuid" NOT NULL,
    "updated_at" timestamp with time zone,
    "username" "text",
    "full_name" "text",
    "avatar_url" "text",
    "website" "text",
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"(),
    CONSTRAINT "username_length" CHECK (("char_length"("username") >= 3))
);

ALTER TABLE "public"."profile" OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."rls_profiles_edit"("records" "public"."profile"[]) RETURNS boolean
    LANGUAGE "plpgsql"
    AS $$
DECLARE
    t profiles;
BEGIN
  FOREACH t IN ARRAY records LOOP
    RAISE LOG 'rls_profiles_edit: profiles %', t.id;
    RETURN TRUE;
  END LOOP;
END;
$$;

ALTER FUNCTION "public"."rls_profiles_edit"("records" "public"."profile"[]) OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."rls_profiles_edit"("record" "public"."profile") RETURNS boolean
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    -- RAISE LOG 'rls_profiles_edit: profile %', record.id;
    RETURN rls_check_edit_by_created_by(record.id, FALSE, 'claim_edit_all_profiles');
END;
$$;

ALTER FUNCTION "public"."rls_profiles_edit"("record" "public"."profile") OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."town" (
    "id" bigint NOT NULL,
    "name" "text" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "country_id" bigint NOT NULL,
    "created_by" bigint,
    "updated_by" bigint,
    CONSTRAINT "towns_name_check" CHECK (("length"("name") > 0))
);

ALTER TABLE "public"."town" OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."rls_towns_delete"("record" "public"."town") RETURNS boolean
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    RETURN rls_check_delete_by_created_by(record.created_by);
END;
$$;

ALTER FUNCTION "public"."rls_towns_delete"("record" "public"."town") OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."rls_towns_edit"("record" "public"."town") RETURNS boolean
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    RETURN rls_check_edit_by_created_by(record.created_by);
END;
$$;

ALTER FUNCTION "public"."rls_towns_edit"("record" "public"."town") OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."trust" (
    "id" bigint NOT NULL,
    "who" bigint NOT NULL,
    "trusts_whom" bigint NOT NULL,
    "end_at" timestamp with time zone DEFAULT ("now"() + '1 day'::interval) NOT NULL
);

ALTER TABLE "public"."trust" OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."rls_trusts_edit"("record" "public"."trust") RETURNS boolean
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    -- RAISE LOG 'rls_profiles_edit: profile %', record.id;
    RETURN rls_check_edit_by_created_by(record.who, FALSE, 'claim_edit_all_profiles');
END;
$$;

ALTER FUNCTION "public"."rls_trusts_edit"("record" "public"."trust") OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."set_claim"("uid" "uuid", "claim" "text", "value" "jsonb") RETURNS "text"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
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
$$;

ALTER FUNCTION "public"."set_claim"("uid" "uuid", "claim" "text", "value" "jsonb") OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."string_limit"("s" character varying, "max_length" integer) RETURNS character varying
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    RETURN CASE WHEN length(s) > max_length 
      THEN substring(s, 1, max_length - 3) || '...' 
      ELSE s
      END;
END;
$$;

ALTER FUNCTION "public"."string_limit"("s" character varying, "max_length" integer) OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."temporary_fn"() RETURNS boolean
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  RAISE LOG 'This is an informational message';
  RETURN TRUE;
END;
$$;

ALTER FUNCTION "public"."temporary_fn"() OWNER TO "postgres";

ALTER TABLE "public"."author" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."author_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

ALTER TABLE "public"."citation" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."citations_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

CREATE TABLE IF NOT EXISTS "public"."country" (
    "id" bigint,
    "name" "text" DEFAULT ''::"text" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"(),
    "found_year" bigint,
    "next_rename_year" bigint,
    "created_by" bigint,
    "updated_by" bigint,
    "table_name" "text" DEFAULT 'country'::"text",
    "published_at" timestamp with time zone,
    "published_by" bigint,
    "unpublished_at" timestamp with time zone,
    "unpublished_by" bigint,
    CONSTRAINT "countries_name_check" CHECK (("length"("name") > 0)),
    CONSTRAINT "country_table_name_check" CHECK (("table_name" = 'country'::"text"))
)
INHERITS ("public"."content_item");

ALTER TABLE "public"."country" OWNER TO "postgres";

ALTER TABLE "public"."country" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."country_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

ALTER TABLE "public"."event" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."event_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

ALTER TABLE "public"."place" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."place_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

ALTER TABLE "public"."profile" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."profiles_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

ALTER TABLE "public"."town" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."town_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

ALTER TABLE "public"."trust" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."trusts_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

CREATE OR REPLACE VIEW "public"."view_id_name" AS
 SELECT 'author'::"text" AS "table_name",
    "author"."id",
    "author"."lastname_name_patronymic" AS "name",
    "public"."string_limit"(("author"."lastname_name_patronymic")::character varying, 20) AS "short_name"
   FROM "public"."author"
UNION
 SELECT 'citation'::"text" AS "table_name",
    "citation"."id",
    "public"."string_limit"(("citation"."english_text")::character varying, 40) AS "name",
    "public"."string_limit"(("citation"."english_text")::character varying, 20) AS "short_name"
   FROM "public"."citation"
UNION
 SELECT 'country'::"text" AS "table_name",
    "country"."id",
    "country"."name",
    "public"."string_limit"(("country"."name")::character varying, 20) AS "short_name"
   FROM "public"."country"
UNION
 SELECT 'place'::"text" AS "table_name",
    "place"."id",
    "place"."name",
    "public"."string_limit"(("place"."name")::character varying, 20) AS "short_name"
   FROM "public"."place"
UNION
 SELECT 'profile'::"text" AS "table_name",
    "profile"."id",
    ((("profile"."full_name" || ' ('::"text") || "profile"."username") || ')'::"text") AS "name",
    "profile"."username" AS "short_name"
   FROM "public"."profile"
UNION
 SELECT 'town'::"text" AS "table_name",
    "town"."id",
    "town"."name",
    "public"."string_limit"(("town"."name")::character varying, 20) AS "short_name"
   FROM "public"."town"
  ORDER BY 1, 4;

ALTER TABLE "public"."view_id_name" OWNER TO "postgres";

CREATE OR REPLACE VIEW "public"."view_rls_content_item" AS
 SELECT "content_item"."table_name",
    "content_item"."id",
    "public"."rls_content_item_check_edit"("content_item".*) AS "editable",
    "public"."rls_content_item_check_delete"("content_item".*) AS "deletable"
   FROM "public"."content_item"
  ORDER BY "content_item"."table_name", "content_item"."id";

ALTER TABLE "public"."view_rls_content_item" OWNER TO "postgres";

CREATE OR REPLACE VIEW "public"."view_rls_edit_for_table" AS
 SELECT "view_rls_content_item"."table_name",
    "view_rls_content_item"."id",
    "view_rls_content_item"."editable",
    "view_rls_content_item"."deletable"
   FROM "public"."view_rls_content_item"
UNION
 SELECT 'author'::"text" AS "table_name",
    "author"."id",
    "public"."rls_authors_edit"("author".*) AS "editable",
    "public"."rls_authors_delete"("author".*) AS "deletable"
   FROM "public"."author"
UNION
 SELECT 'citation'::"text" AS "table_name",
    "citation"."id",
    "public"."rls_citations_edit"("citation".*) AS "editable",
    "public"."rls_citations_delete"("citation".*) AS "deletable"
   FROM "public"."citation"
UNION
 SELECT 'event'::"text" AS "table_name",
    "event"."id",
    "public"."rls_events_edit"("event".*) AS "editable",
    "public"."rls_events_delete"("event".*) AS "deletable"
   FROM "public"."event"
UNION
 SELECT 'place'::"text" AS "table_name",
    "place"."id",
    "public"."rls_places_edit"("place".*) AS "editable",
    "public"."rls_places_delete"("place".*) AS "deletable"
   FROM "public"."place"
UNION
 SELECT 'profile'::"text" AS "table_name",
    "profile"."id",
    "public"."rls_profiles_edit"("profile".*) AS "editable",
    false AS "deletable"
   FROM "public"."profile"
UNION
 SELECT 'town'::"text" AS "table_name",
    "town"."id",
    "public"."rls_towns_edit"("town".*) AS "editable",
    "public"."rls_towns_delete"("town".*) AS "deletable"
   FROM "public"."town"
UNION
 SELECT 'trust'::"text" AS "table_name",
    "trust"."id",
    "public"."rls_trusts_edit"("trust".*) AS "editable",
    "public"."rls_trusts_edit"("trust".*) AS "deletable"
   FROM "public"."trust"
  ORDER BY 1, 2;

ALTER TABLE "public"."view_rls_edit_for_table" OWNER TO "postgres";

ALTER TABLE ONLY "public"."author"
    ADD CONSTRAINT "author_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."citation"
    ADD CONSTRAINT "citations_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."content_item"
    ADD CONSTRAINT "content_item_pkey" PRIMARY KEY ("table_name", "id");

ALTER TABLE ONLY "public"."country"
    ADD CONSTRAINT "countries_name_key" UNIQUE ("name");

ALTER TABLE ONLY "public"."country"
    ADD CONSTRAINT "country_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."event"
    ADD CONSTRAINT "event_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."place"
    ADD CONSTRAINT "place_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."profile"
    ADD CONSTRAINT "profiles_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."profile"
    ADD CONSTRAINT "profiles_username_key" UNIQUE ("username");

ALTER TABLE ONLY "public"."town"
    ADD CONSTRAINT "town_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."trust"
    ADD CONSTRAINT "trusts_pkey" PRIMARY KEY ("id");

CREATE OR REPLACE TRIGGER "on_authors_edit_fill_update" BEFORE UPDATE ON "public"."author" FOR EACH ROW EXECUTE FUNCTION "public"."handle_fill_updated"();

CREATE OR REPLACE TRIGGER "on_authors_new_fill_created_by" BEFORE INSERT ON "public"."author" FOR EACH ROW EXECUTE FUNCTION "public"."handle_fill_created_by"();

CREATE OR REPLACE TRIGGER "on_citations_edit_fill_update" BEFORE UPDATE ON "public"."citation" FOR EACH ROW EXECUTE FUNCTION "public"."handle_fill_updated"();

CREATE OR REPLACE TRIGGER "on_citations_new_fill_created_by" BEFORE INSERT ON "public"."citation" FOR EACH ROW EXECUTE FUNCTION "public"."handle_fill_created_by"();

CREATE OR REPLACE TRIGGER "on_country_edit" BEFORE UPDATE ON "public"."country" FOR EACH ROW EXECUTE FUNCTION "public"."handle_content_item_edit"();

CREATE OR REPLACE TRIGGER "on_country_new" BEFORE INSERT ON "public"."country" FOR EACH ROW EXECUTE FUNCTION "public"."handle_content_item_new"();

CREATE OR REPLACE TRIGGER "on_country_new_fill_created_by" BEFORE INSERT ON "public"."country" FOR EACH ROW EXECUTE FUNCTION "public"."handle_fill_created_by"();

CREATE OR REPLACE TRIGGER "on_events_edit_fill_update" BEFORE UPDATE ON "public"."event" FOR EACH ROW EXECUTE FUNCTION "public"."handle_fill_updated"();

CREATE OR REPLACE TRIGGER "on_events_new_fill_created_by" BEFORE INSERT ON "public"."event" FOR EACH ROW EXECUTE FUNCTION "public"."handle_fill_created_by"();

CREATE OR REPLACE TRIGGER "on_places_edit_fill_update" BEFORE UPDATE ON "public"."place" FOR EACH ROW EXECUTE FUNCTION "public"."handle_fill_updated"();

CREATE OR REPLACE TRIGGER "on_places_new_fill_created_by" BEFORE INSERT ON "public"."place" FOR EACH ROW EXECUTE FUNCTION "public"."handle_fill_created_by"();

CREATE OR REPLACE TRIGGER "on_public_profile_new" AFTER INSERT ON "public"."profile" FOR EACH ROW EXECUTE FUNCTION "public"."handle_public_profile_new"();

CREATE OR REPLACE TRIGGER "on_towns_edit_fill_update" BEFORE UPDATE ON "public"."town" FOR EACH ROW EXECUTE FUNCTION "public"."handle_fill_updated"();

CREATE OR REPLACE TRIGGER "on_towns_new_fill_created_by" BEFORE INSERT ON "public"."town" FOR EACH ROW EXECUTE FUNCTION "public"."handle_fill_created_by"();

ALTER TABLE ONLY "public"."author"
    ADD CONSTRAINT "author_birth_town_fkey" FOREIGN KEY ("birth_town") REFERENCES "public"."town"("id") ON UPDATE CASCADE;

ALTER TABLE ONLY "public"."author"
    ADD CONSTRAINT "author_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "public"."profile"("id") ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY "public"."author"
    ADD CONSTRAINT "author_updated_by_fkey" FOREIGN KEY ("updated_by") REFERENCES "public"."profile"("id") ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY "public"."citation"
    ADD CONSTRAINT "citation_author_id_fkey" FOREIGN KEY ("author_id") REFERENCES "public"."author"("id") ON UPDATE CASCADE;

ALTER TABLE ONLY "public"."citation"
    ADD CONSTRAINT "citation_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "public"."profile"("id") ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY "public"."citation"
    ADD CONSTRAINT "citation_event_id_fkey" FOREIGN KEY ("event_id") REFERENCES "public"."event"("id") ON UPDATE CASCADE;

ALTER TABLE ONLY "public"."citation"
    ADD CONSTRAINT "citation_place_id_fkey" FOREIGN KEY ("place_id") REFERENCES "public"."place"("id");

ALTER TABLE ONLY "public"."citation"
    ADD CONSTRAINT "citation_updated_by_fkey" FOREIGN KEY ("updated_by") REFERENCES "public"."profile"("id") ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY "public"."country"
    ADD CONSTRAINT "country_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "public"."profile"("id") ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY "public"."country"
    ADD CONSTRAINT "country_updated_by_fkey" FOREIGN KEY ("updated_by") REFERENCES "public"."profile"("id") ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY "public"."event"
    ADD CONSTRAINT "event_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "public"."profile"("id") ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY "public"."event"
    ADD CONSTRAINT "event_place_id_fkey" FOREIGN KEY ("place_id") REFERENCES "public"."place"("id") ON UPDATE CASCADE;

ALTER TABLE ONLY "public"."event"
    ADD CONSTRAINT "event_updated_by_fkey" FOREIGN KEY ("updated_by") REFERENCES "public"."profile"("id") ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY "public"."place"
    ADD CONSTRAINT "place_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "public"."profile"("id") ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY "public"."place"
    ADD CONSTRAINT "place_town_id_fkey" FOREIGN KEY ("town_id") REFERENCES "public"."town"("id") ON UPDATE CASCADE;

ALTER TABLE ONLY "public"."place"
    ADD CONSTRAINT "place_updated_by_fkey" FOREIGN KEY ("updated_by") REFERENCES "public"."profile"("id") ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY "public"."profile"
    ADD CONSTRAINT "profile_auth_user_id_fkey" FOREIGN KEY ("auth_user_id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."town"
    ADD CONSTRAINT "town_country_id_fkey" FOREIGN KEY ("country_id") REFERENCES "public"."country"("id") ON UPDATE CASCADE;

ALTER TABLE ONLY "public"."town"
    ADD CONSTRAINT "town_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "public"."profile"("id") ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY "public"."town"
    ADD CONSTRAINT "town_updated_by_fkey" FOREIGN KEY ("updated_by") REFERENCES "public"."profile"("id") ON UPDATE CASCADE ON DELETE RESTRICT;

CREATE POLICY " RLS: profiles: insert" ON "public"."profile" FOR INSERT WITH CHECK (("auth"."uid"() = "auth_user_id"));

CREATE POLICY " RLS: profiles: update" ON "public"."profile" FOR UPDATE USING ("public"."rls_profiles_edit"("profile".*));

CREATE POLICY "RLS: authors: delete" ON "public"."author" FOR DELETE TO "authenticated" USING ("public"."rls_authors_edit"("author".*));

CREATE POLICY "RLS: authors: insert" ON "public"."author" FOR INSERT TO "authenticated" WITH CHECK ("public"."rls_authors_edit"("author".*));

CREATE POLICY "RLS: authors: select" ON "public"."author" FOR SELECT USING (true);

CREATE POLICY "RLS: authors: update" ON "public"."author" FOR UPDATE TO "authenticated" USING ("public"."rls_authors_edit"("author".*)) WITH CHECK ("public"."rls_authors_edit"("author".*));

CREATE POLICY "RLS: citations: delete" ON "public"."citation" FOR DELETE TO "authenticated" USING ("public"."rls_citations_edit"("citation".*));

CREATE POLICY "RLS: citations: insert" ON "public"."citation" FOR INSERT TO "authenticated" WITH CHECK ("public"."rls_citations_edit"("citation".*));

CREATE POLICY "RLS: citations: select" ON "public"."citation" FOR SELECT USING (true);

CREATE POLICY "RLS: citations: update" ON "public"."citation" FOR UPDATE TO "authenticated" USING ("public"."rls_citations_edit"("citation".*)) WITH CHECK ("public"."rls_citations_edit"("citation".*));

CREATE POLICY "RLS: content_item: select" ON "public"."content_item" FOR SELECT USING (true);

CREATE POLICY "RLS: country: delete" ON "public"."country" FOR DELETE TO "authenticated" USING ("public"."rls_content_item_check_delete"(("country".*)::"public"."content_item"));

CREATE POLICY "RLS: country: insert" ON "public"."country" FOR INSERT TO "authenticated" WITH CHECK ("public"."rls_content_item_check_edit"(("country".*)::"public"."content_item"));

CREATE POLICY "RLS: country: select" ON "public"."country" FOR SELECT USING (true);

CREATE POLICY "RLS: country: update" ON "public"."country" FOR UPDATE TO "authenticated" USING ("public"."rls_content_item_check_edit"(("country".*)::"public"."content_item")) WITH CHECK ("public"."rls_content_item_check_edit"(("country".*)::"public"."content_item"));

CREATE POLICY "RLS: events: delete" ON "public"."event" FOR DELETE TO "authenticated" USING ("public"."rls_events_edit"("event".*));

CREATE POLICY "RLS: events: insert" ON "public"."event" FOR INSERT TO "authenticated" WITH CHECK ("public"."rls_events_edit"("event".*));

CREATE POLICY "RLS: events: select" ON "public"."event" FOR SELECT USING (true);

CREATE POLICY "RLS: events: update" ON "public"."event" FOR UPDATE TO "authenticated" USING ("public"."rls_events_edit"("event".*)) WITH CHECK ("public"."rls_events_edit"("event".*));

CREATE POLICY "RLS: places: delete" ON "public"."place" FOR DELETE TO "authenticated" USING ("public"."rls_places_edit"("place".*));

CREATE POLICY "RLS: places: insert" ON "public"."place" FOR INSERT TO "authenticated" WITH CHECK ("public"."rls_places_edit"("place".*));

CREATE POLICY "RLS: places: select" ON "public"."place" FOR SELECT USING (true);

CREATE POLICY "RLS: places: update" ON "public"."place" FOR UPDATE TO "authenticated" USING ("public"."rls_places_edit"("place".*)) WITH CHECK ("public"."rls_places_edit"("place".*));

CREATE POLICY "RLS: profiles: select" ON "public"."profile" FOR SELECT USING (true);

CREATE POLICY "RLS: towns: delete" ON "public"."town" FOR DELETE TO "authenticated" USING ("public"."rls_towns_edit"("town".*));

CREATE POLICY "RLS: towns: insert" ON "public"."town" FOR INSERT TO "authenticated" WITH CHECK ("public"."rls_towns_edit"("town".*));

CREATE POLICY "RLS: towns: select" ON "public"."town" FOR SELECT USING (true);

CREATE POLICY "RLS: towns: update" ON "public"."town" FOR UPDATE TO "authenticated" USING ("public"."rls_towns_edit"("town".*)) WITH CHECK ("public"."rls_towns_edit"("town".*));

CREATE POLICY "RLS: trusts: delete" ON "public"."trust" FOR DELETE TO "authenticated" USING ("public"."rls_trusts_edit"("trust".*));

CREATE POLICY "RLS: trusts: insert" ON "public"."trust" FOR INSERT TO "authenticated" WITH CHECK ("public"."rls_trusts_edit"("trust".*));

CREATE POLICY "RLS: trusts: select" ON "public"."trust" FOR SELECT TO "authenticated" USING (true);

CREATE POLICY "RLS: trusts: update" ON "public"."trust" FOR UPDATE TO "authenticated" USING ("public"."rls_trusts_edit"("trust".*)) WITH CHECK ("public"."rls_trusts_edit"("trust".*));

ALTER TABLE "public"."author" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."citation" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."content_item" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."country" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."event" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."place" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."profile" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."town" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."trust" ENABLE ROW LEVEL SECURITY;

REVOKE USAGE ON SCHEMA "public" FROM PUBLIC;
GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";

GRANT ALL ON TABLE "public"."content_item" TO "anon";
GRANT ALL ON TABLE "public"."content_item" TO "authenticated";
GRANT ALL ON TABLE "public"."content_item" TO "service_role";

GRANT ALL ON FUNCTION "public"."content_item_edit_protect_generated_fields"("new" "public"."content_item", "old" "public"."content_item") TO "anon";
GRANT ALL ON FUNCTION "public"."content_item_edit_protect_generated_fields"("new" "public"."content_item", "old" "public"."content_item") TO "authenticated";
GRANT ALL ON FUNCTION "public"."content_item_edit_protect_generated_fields"("new" "public"."content_item", "old" "public"."content_item") TO "service_role";

GRANT ALL ON FUNCTION "public"."content_item_new_protect_generated_fields"("new" "public"."content_item") TO "anon";
GRANT ALL ON FUNCTION "public"."content_item_new_protect_generated_fields"("new" "public"."content_item") TO "authenticated";
GRANT ALL ON FUNCTION "public"."content_item_new_protect_generated_fields"("new" "public"."content_item") TO "service_role";

GRANT ALL ON FUNCTION "public"."content_item_publish"("_table_name" "text", "_id" integer) TO "anon";
GRANT ALL ON FUNCTION "public"."content_item_publish"("_table_name" "text", "_id" integer) TO "authenticated";
GRANT ALL ON FUNCTION "public"."content_item_publish"("_table_name" "text", "_id" integer) TO "service_role";

GRANT ALL ON FUNCTION "public"."content_item_unpublish"("_table_name" "text", "_id" integer) TO "anon";
GRANT ALL ON FUNCTION "public"."content_item_unpublish"("_table_name" "text", "_id" integer) TO "authenticated";
GRANT ALL ON FUNCTION "public"."content_item_unpublish"("_table_name" "text", "_id" integer) TO "service_role";

GRANT ALL ON FUNCTION "public"."delete_claim"("uid" "uuid", "claim" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."delete_claim"("uid" "uuid", "claim" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."delete_claim"("uid" "uuid", "claim" "text") TO "service_role";

GRANT ALL ON FUNCTION "public"."equal_or_both_null"("a" "anycompatible", "b" "anycompatible") TO "anon";
GRANT ALL ON FUNCTION "public"."equal_or_both_null"("a" "anycompatible", "b" "anycompatible") TO "authenticated";
GRANT ALL ON FUNCTION "public"."equal_or_both_null"("a" "anycompatible", "b" "anycompatible") TO "service_role";

GRANT ALL ON FUNCTION "public"."fn_any_type"("r" "record") TO "anon";
GRANT ALL ON FUNCTION "public"."fn_any_type"("r" "record") TO "authenticated";
GRANT ALL ON FUNCTION "public"."fn_any_type"("r" "record") TO "service_role";

GRANT ALL ON FUNCTION "public"."get_claim"("uid" "uuid", "claim" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."get_claim"("uid" "uuid", "claim" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_claim"("uid" "uuid", "claim" "text") TO "service_role";

GRANT ALL ON FUNCTION "public"."get_claims"("uid" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."get_claims"("uid" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_claims"("uid" "uuid") TO "service_role";

GRANT ALL ON FUNCTION "public"."get_my_claim"("claim" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."get_my_claim"("claim" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_my_claim"("claim" "text") TO "service_role";

GRANT ALL ON FUNCTION "public"."get_my_claims"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_my_claims"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_my_claims"() TO "service_role";

GRANT ALL ON FUNCTION "public"."handle_auth_user_new"() TO "anon";
GRANT ALL ON FUNCTION "public"."handle_auth_user_new"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."handle_auth_user_new"() TO "service_role";

GRANT ALL ON FUNCTION "public"."handle_content_item_edit"() TO "anon";
GRANT ALL ON FUNCTION "public"."handle_content_item_edit"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."handle_content_item_edit"() TO "service_role";

GRANT ALL ON FUNCTION "public"."handle_content_item_new"() TO "anon";
GRANT ALL ON FUNCTION "public"."handle_content_item_new"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."handle_content_item_new"() TO "service_role";

GRANT ALL ON FUNCTION "public"."handle_fill_created_by"() TO "anon";
GRANT ALL ON FUNCTION "public"."handle_fill_created_by"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."handle_fill_created_by"() TO "service_role";

GRANT ALL ON FUNCTION "public"."handle_fill_updated"() TO "anon";
GRANT ALL ON FUNCTION "public"."handle_fill_updated"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."handle_fill_updated"() TO "service_role";

GRANT ALL ON FUNCTION "public"."handle_public_profile_new"() TO "anon";
GRANT ALL ON FUNCTION "public"."handle_public_profile_new"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."handle_public_profile_new"() TO "service_role";

GRANT ALL ON FUNCTION "public"."is_claims_admin"() TO "anon";
GRANT ALL ON FUNCTION "public"."is_claims_admin"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."is_claims_admin"() TO "service_role";

GRANT ALL ON FUNCTION "public"."permission_publish_check"() TO "anon";
GRANT ALL ON FUNCTION "public"."permission_publish_check"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."permission_publish_check"() TO "service_role";

GRANT ALL ON FUNCTION "public"."permission_publish_get"() TO "anon";
GRANT ALL ON FUNCTION "public"."permission_publish_get"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."permission_publish_get"() TO "service_role";

GRANT ALL ON FUNCTION "public"."protect_generated_field_from_change"("a" "anyelement", "b" "anyelement", "variable_name" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."protect_generated_field_from_change"("a" "anyelement", "b" "anyelement", "variable_name" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."protect_generated_field_from_change"("a" "anyelement", "b" "anyelement", "variable_name" "text") TO "service_role";

GRANT ALL ON FUNCTION "public"."protect_generated_field_from_init"("a" "anyelement", "variable_name" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."protect_generated_field_from_init"("a" "anyelement", "variable_name" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."protect_generated_field_from_init"("a" "anyelement", "variable_name" "text") TO "service_role";

GRANT ALL ON FUNCTION "public"."record_fill_created_by"("r" "record") TO "anon";
GRANT ALL ON FUNCTION "public"."record_fill_created_by"("r" "record") TO "authenticated";
GRANT ALL ON FUNCTION "public"."record_fill_created_by"("r" "record") TO "service_role";

GRANT ALL ON FUNCTION "public"."record_fill_updated_at"("r" "record") TO "anon";
GRANT ALL ON FUNCTION "public"."record_fill_updated_at"("r" "record") TO "authenticated";
GRANT ALL ON FUNCTION "public"."record_fill_updated_at"("r" "record") TO "service_role";

GRANT ALL ON FUNCTION "public"."record_fill_updated_by"("r" "record") TO "anon";
GRANT ALL ON FUNCTION "public"."record_fill_updated_by"("r" "record") TO "authenticated";
GRANT ALL ON FUNCTION "public"."record_fill_updated_by"("r" "record") TO "service_role";

GRANT ALL ON TABLE "public"."author" TO "anon";
GRANT ALL ON TABLE "public"."author" TO "authenticated";
GRANT ALL ON TABLE "public"."author" TO "service_role";

GRANT ALL ON FUNCTION "public"."rls_authors_delete"("record" "public"."author") TO "anon";
GRANT ALL ON FUNCTION "public"."rls_authors_delete"("record" "public"."author") TO "authenticated";
GRANT ALL ON FUNCTION "public"."rls_authors_delete"("record" "public"."author") TO "service_role";

GRANT ALL ON FUNCTION "public"."rls_authors_edit"("record" "public"."author") TO "anon";
GRANT ALL ON FUNCTION "public"."rls_authors_edit"("record" "public"."author") TO "authenticated";
GRANT ALL ON FUNCTION "public"."rls_authors_edit"("record" "public"."author") TO "service_role";

GRANT ALL ON FUNCTION "public"."rls_check_delete_by_created_by"("created_by" bigint, "allow_trust" boolean, "claim_check" character varying) TO "anon";
GRANT ALL ON FUNCTION "public"."rls_check_delete_by_created_by"("created_by" bigint, "allow_trust" boolean, "claim_check" character varying) TO "authenticated";
GRANT ALL ON FUNCTION "public"."rls_check_delete_by_created_by"("created_by" bigint, "allow_trust" boolean, "claim_check" character varying) TO "service_role";

GRANT ALL ON FUNCTION "public"."rls_check_edit_by_created_by"("created_by" bigint, "allow_trust" boolean, "claim_check" character varying) TO "anon";
GRANT ALL ON FUNCTION "public"."rls_check_edit_by_created_by"("created_by" bigint, "allow_trust" boolean, "claim_check" character varying) TO "authenticated";
GRANT ALL ON FUNCTION "public"."rls_check_edit_by_created_by"("created_by" bigint, "allow_trust" boolean, "claim_check" character varying) TO "service_role";

GRANT ALL ON TABLE "public"."citation" TO "anon";
GRANT ALL ON TABLE "public"."citation" TO "authenticated";
GRANT ALL ON TABLE "public"."citation" TO "service_role";

GRANT ALL ON FUNCTION "public"."rls_citations_delete"("record" "public"."citation") TO "anon";
GRANT ALL ON FUNCTION "public"."rls_citations_delete"("record" "public"."citation") TO "authenticated";
GRANT ALL ON FUNCTION "public"."rls_citations_delete"("record" "public"."citation") TO "service_role";

GRANT ALL ON FUNCTION "public"."rls_citations_edit"("record" "public"."citation") TO "anon";
GRANT ALL ON FUNCTION "public"."rls_citations_edit"("record" "public"."citation") TO "authenticated";
GRANT ALL ON FUNCTION "public"."rls_citations_edit"("record" "public"."citation") TO "service_role";

GRANT ALL ON FUNCTION "public"."rls_content_item_check_delete"("record" "public"."content_item") TO "anon";
GRANT ALL ON FUNCTION "public"."rls_content_item_check_delete"("record" "public"."content_item") TO "authenticated";
GRANT ALL ON FUNCTION "public"."rls_content_item_check_delete"("record" "public"."content_item") TO "service_role";

GRANT ALL ON FUNCTION "public"."rls_content_item_check_edit"("record" "public"."content_item") TO "anon";
GRANT ALL ON FUNCTION "public"."rls_content_item_check_edit"("record" "public"."content_item") TO "authenticated";
GRANT ALL ON FUNCTION "public"."rls_content_item_check_edit"("record" "public"."content_item") TO "service_role";

GRANT ALL ON TABLE "public"."event" TO "anon";
GRANT ALL ON TABLE "public"."event" TO "authenticated";
GRANT ALL ON TABLE "public"."event" TO "service_role";

GRANT ALL ON FUNCTION "public"."rls_events_delete"("record" "public"."event") TO "anon";
GRANT ALL ON FUNCTION "public"."rls_events_delete"("record" "public"."event") TO "authenticated";
GRANT ALL ON FUNCTION "public"."rls_events_delete"("record" "public"."event") TO "service_role";

GRANT ALL ON FUNCTION "public"."rls_events_edit"("record" "public"."event") TO "anon";
GRANT ALL ON FUNCTION "public"."rls_events_edit"("record" "public"."event") TO "authenticated";
GRANT ALL ON FUNCTION "public"."rls_events_edit"("record" "public"."event") TO "service_role";

GRANT ALL ON TABLE "public"."place" TO "anon";
GRANT ALL ON TABLE "public"."place" TO "authenticated";
GRANT ALL ON TABLE "public"."place" TO "service_role";

GRANT ALL ON FUNCTION "public"."rls_places_delete"("record" "public"."place") TO "anon";
GRANT ALL ON FUNCTION "public"."rls_places_delete"("record" "public"."place") TO "authenticated";
GRANT ALL ON FUNCTION "public"."rls_places_delete"("record" "public"."place") TO "service_role";

GRANT ALL ON FUNCTION "public"."rls_places_edit"("record" "public"."place") TO "anon";
GRANT ALL ON FUNCTION "public"."rls_places_edit"("record" "public"."place") TO "authenticated";
GRANT ALL ON FUNCTION "public"."rls_places_edit"("record" "public"."place") TO "service_role";

GRANT ALL ON TABLE "public"."profile" TO "anon";
GRANT ALL ON TABLE "public"."profile" TO "authenticated";
GRANT ALL ON TABLE "public"."profile" TO "service_role";

GRANT ALL ON FUNCTION "public"."rls_profiles_edit"("records" "public"."profile"[]) TO "anon";
GRANT ALL ON FUNCTION "public"."rls_profiles_edit"("records" "public"."profile"[]) TO "authenticated";
GRANT ALL ON FUNCTION "public"."rls_profiles_edit"("records" "public"."profile"[]) TO "service_role";

GRANT ALL ON FUNCTION "public"."rls_profiles_edit"("record" "public"."profile") TO "anon";
GRANT ALL ON FUNCTION "public"."rls_profiles_edit"("record" "public"."profile") TO "authenticated";
GRANT ALL ON FUNCTION "public"."rls_profiles_edit"("record" "public"."profile") TO "service_role";

GRANT ALL ON TABLE "public"."town" TO "anon";
GRANT ALL ON TABLE "public"."town" TO "authenticated";
GRANT ALL ON TABLE "public"."town" TO "service_role";

GRANT ALL ON FUNCTION "public"."rls_towns_delete"("record" "public"."town") TO "anon";
GRANT ALL ON FUNCTION "public"."rls_towns_delete"("record" "public"."town") TO "authenticated";
GRANT ALL ON FUNCTION "public"."rls_towns_delete"("record" "public"."town") TO "service_role";

GRANT ALL ON FUNCTION "public"."rls_towns_edit"("record" "public"."town") TO "anon";
GRANT ALL ON FUNCTION "public"."rls_towns_edit"("record" "public"."town") TO "authenticated";
GRANT ALL ON FUNCTION "public"."rls_towns_edit"("record" "public"."town") TO "service_role";

GRANT ALL ON TABLE "public"."trust" TO "anon";
GRANT ALL ON TABLE "public"."trust" TO "authenticated";
GRANT ALL ON TABLE "public"."trust" TO "service_role";

GRANT ALL ON FUNCTION "public"."rls_trusts_edit"("record" "public"."trust") TO "anon";
GRANT ALL ON FUNCTION "public"."rls_trusts_edit"("record" "public"."trust") TO "authenticated";
GRANT ALL ON FUNCTION "public"."rls_trusts_edit"("record" "public"."trust") TO "service_role";

GRANT ALL ON FUNCTION "public"."set_claim"("uid" "uuid", "claim" "text", "value" "jsonb") TO "anon";
GRANT ALL ON FUNCTION "public"."set_claim"("uid" "uuid", "claim" "text", "value" "jsonb") TO "authenticated";
GRANT ALL ON FUNCTION "public"."set_claim"("uid" "uuid", "claim" "text", "value" "jsonb") TO "service_role";

GRANT ALL ON FUNCTION "public"."string_limit"("s" character varying, "max_length" integer) TO "anon";
GRANT ALL ON FUNCTION "public"."string_limit"("s" character varying, "max_length" integer) TO "authenticated";
GRANT ALL ON FUNCTION "public"."string_limit"("s" character varying, "max_length" integer) TO "service_role";

GRANT ALL ON FUNCTION "public"."temporary_fn"() TO "anon";
GRANT ALL ON FUNCTION "public"."temporary_fn"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."temporary_fn"() TO "service_role";

GRANT ALL ON SEQUENCE "public"."author_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."author_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."author_id_seq" TO "service_role";

GRANT ALL ON SEQUENCE "public"."citations_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."citations_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."citations_id_seq" TO "service_role";

GRANT ALL ON TABLE "public"."country" TO "anon";
GRANT ALL ON TABLE "public"."country" TO "authenticated";
GRANT ALL ON TABLE "public"."country" TO "service_role";

GRANT ALL ON SEQUENCE "public"."country_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."country_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."country_id_seq" TO "service_role";

GRANT ALL ON SEQUENCE "public"."event_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."event_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."event_id_seq" TO "service_role";

GRANT ALL ON SEQUENCE "public"."place_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."place_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."place_id_seq" TO "service_role";

GRANT ALL ON SEQUENCE "public"."profiles_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."profiles_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."profiles_id_seq" TO "service_role";

GRANT ALL ON SEQUENCE "public"."town_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."town_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."town_id_seq" TO "service_role";

GRANT ALL ON SEQUENCE "public"."trusts_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."trusts_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."trusts_id_seq" TO "service_role";

GRANT ALL ON TABLE "public"."view_id_name" TO "anon";
GRANT ALL ON TABLE "public"."view_id_name" TO "authenticated";
GRANT ALL ON TABLE "public"."view_id_name" TO "service_role";

GRANT ALL ON TABLE "public"."view_rls_content_item" TO "anon";
GRANT ALL ON TABLE "public"."view_rls_content_item" TO "authenticated";
GRANT ALL ON TABLE "public"."view_rls_content_item" TO "service_role";

GRANT ALL ON TABLE "public"."view_rls_edit_for_table" TO "anon";
GRANT ALL ON TABLE "public"."view_rls_edit_for_table" TO "authenticated";
GRANT ALL ON TABLE "public"."view_rls_edit_for_table" TO "service_role";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "service_role";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "service_role";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "service_role";

RESET ALL;
