
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
  INSERT INTO public.profiles (auth_user_id, full_name, avatar_url)
	  VALUES (
		  NEW.id,
		  NEW.raw_user_meta_data->>'full_name',
		  NEW.raw_user_meta_data->>'avatar_url'
	  );
  RETURN NEW;
END;
$$;

ALTER FUNCTION "public"."handle_auth_user_new"() OWNER TO "postgres";

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

SET default_tablespace = '';

SET default_table_access_method = "heap";

CREATE TABLE IF NOT EXISTS "public"."authors" (
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

ALTER TABLE "public"."authors" OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."rls_authors_delete"("record" "public"."authors") RETURNS boolean
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    RETURN rls_check_delete_by_created_by(record.created_by);
END;
$$;

ALTER FUNCTION "public"."rls_authors_delete"("record" "public"."authors") OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."rls_authors_edit"("record" "public"."authors") RETURNS boolean
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    RETURN rls_check_edit_by_created_by(record.created_by);
END;
$$;

ALTER FUNCTION "public"."rls_authors_edit"("record" "public"."authors") OWNER TO "postgres";

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
					FROM trusts
					WHERE NOW() < trusts.end_at
					AND created_by = trusts.who
						AND profile_id = trusts.trusts_whom
				))
			);
END;
$$;

ALTER FUNCTION "public"."rls_check_edit_by_created_by"("created_by" bigint, "allow_trust" boolean, "claim_check" character varying) OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."citations" (
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

ALTER TABLE "public"."citations" OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."rls_citations_delete"("record" "public"."citations") RETURNS boolean
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    RETURN rls_check_delete_by_created_by(record.created_by);
END;
$$;

ALTER FUNCTION "public"."rls_citations_delete"("record" "public"."citations") OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."rls_citations_edit"("record" "public"."citations") RETURNS boolean
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    RETURN rls_check_edit_by_created_by(record.created_by);
END;
$$;

ALTER FUNCTION "public"."rls_citations_edit"("record" "public"."citations") OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."countries" (
    "id" bigint NOT NULL,
    "name" "text" DEFAULT ''::"text" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"(),
    "found_year" bigint,
    "next_rename_year" bigint,
    "created_by" bigint,
    "updated_by" bigint,
    CONSTRAINT "countries_name_check" CHECK (("length"("name") > 0))
);

ALTER TABLE "public"."countries" OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."rls_countries_delete"("record" "public"."countries") RETURNS boolean
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    RETURN rls_check_delete_by_created_by(record.created_by);
END;
$$;

ALTER FUNCTION "public"."rls_countries_delete"("record" "public"."countries") OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."rls_countries_edit"("record" "public"."countries") RETURNS boolean
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    RETURN rls_check_edit_by_created_by(record.created_by);
END;
$$;

ALTER FUNCTION "public"."rls_countries_edit"("record" "public"."countries") OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."events" (
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

ALTER TABLE "public"."events" OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."rls_events_delete"("record" "public"."events") RETURNS boolean
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    RETURN rls_check_delete_by_created_by(record.created_by);
END;
$$;

ALTER FUNCTION "public"."rls_events_delete"("record" "public"."events") OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."rls_events_edit"("record" "public"."events") RETURNS boolean
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    RETURN rls_check_edit_by_created_by(record.created_by);
END;
$$;

ALTER FUNCTION "public"."rls_events_edit"("record" "public"."events") OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."places" (
    "id" bigint NOT NULL,
    "name" "text" DEFAULT 'in'::"text" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "town_id" bigint NOT NULL,
    "created_by" bigint,
    "updated_by" bigint
);

ALTER TABLE "public"."places" OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."rls_places_delete"("record" "public"."places") RETURNS boolean
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    RETURN rls_check_delete_by_created_by(record.created_by);
END;
$$;

ALTER FUNCTION "public"."rls_places_delete"("record" "public"."places") OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."rls_places_edit"("record" "public"."places") RETURNS boolean
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    RETURN rls_check_edit_by_created_by(record.created_by);
END;
$$;

ALTER FUNCTION "public"."rls_places_edit"("record" "public"."places") OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."profiles" (
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

ALTER TABLE "public"."profiles" OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."rls_profiles_edit"("records" "public"."profiles"[]) RETURNS boolean
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

ALTER FUNCTION "public"."rls_profiles_edit"("records" "public"."profiles"[]) OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."rls_profiles_edit"("record" "public"."profiles") RETURNS boolean
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    -- RAISE LOG 'rls_profiles_edit: profile %', record.id;
    RETURN rls_check_edit_by_created_by(record.id, FALSE, 'claim_edit_all_profiles');
END;
$$;

ALTER FUNCTION "public"."rls_profiles_edit"("record" "public"."profiles") OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."towns" (
    "id" bigint NOT NULL,
    "name" "text" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "country_id" bigint NOT NULL,
    "created_by" bigint,
    "updated_by" bigint,
    CONSTRAINT "towns_name_check" CHECK (("length"("name") > 0))
);

ALTER TABLE "public"."towns" OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."rls_towns_delete"("record" "public"."towns") RETURNS boolean
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    RETURN rls_check_delete_by_created_by(record.created_by);
END;
$$;

ALTER FUNCTION "public"."rls_towns_delete"("record" "public"."towns") OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."rls_towns_edit"("record" "public"."towns") RETURNS boolean
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    RETURN rls_check_edit_by_created_by(record.created_by);
END;
$$;

ALTER FUNCTION "public"."rls_towns_edit"("record" "public"."towns") OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."trusts" (
    "id" bigint NOT NULL,
    "who" bigint NOT NULL,
    "trusts_whom" bigint NOT NULL,
    "end_at" timestamp with time zone DEFAULT ("now"() + '1 day'::interval) NOT NULL
);

ALTER TABLE "public"."trusts" OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."rls_trusts_edit"("record" "public"."trusts") RETURNS boolean
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    -- RAISE LOG 'rls_profiles_edit: profile %', record.id;
    RETURN rls_check_edit_by_created_by(record.who, FALSE, 'claim_edit_all_profiles');
END;
$$;

ALTER FUNCTION "public"."rls_trusts_edit"("record" "public"."trusts") OWNER TO "postgres";

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

ALTER TABLE "public"."authors" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."author_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

ALTER TABLE "public"."citations" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."citations_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

ALTER TABLE "public"."countries" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."country_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

ALTER TABLE "public"."events" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."event_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

ALTER TABLE "public"."places" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."place_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

ALTER TABLE "public"."profiles" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."profiles_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

ALTER TABLE "public"."towns" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."town_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

ALTER TABLE "public"."trusts" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."trusts_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

CREATE OR REPLACE VIEW "public"."view_id_name" AS
 SELECT 'authors'::"text" AS "table_name",
    "authors"."id",
    "authors"."lastname_name_patronymic" AS "name",
    "public"."string_limit"(("authors"."lastname_name_patronymic")::character varying, 20) AS "short_name"
   FROM "public"."authors"
UNION
 SELECT 'citations'::"text" AS "table_name",
    "citations"."id",
    "public"."string_limit"(("citations"."english_text")::character varying, 40) AS "name",
    "public"."string_limit"(("citations"."english_text")::character varying, 20) AS "short_name"
   FROM "public"."citations"
UNION
 SELECT 'countries'::"text" AS "table_name",
    "countries"."id",
    "countries"."name",
    "public"."string_limit"(("countries"."name")::character varying, 20) AS "short_name"
   FROM "public"."countries"
UNION
 SELECT 'places'::"text" AS "table_name",
    "places"."id",
    "places"."name",
    "public"."string_limit"(("places"."name")::character varying, 20) AS "short_name"
   FROM "public"."places"
UNION
 SELECT 'profiles'::"text" AS "table_name",
    "profiles"."id",
    ((("profiles"."full_name" || ' ('::"text") || "profiles"."username") || ')'::"text") AS "name",
    "profiles"."username" AS "short_name"
   FROM "public"."profiles"
UNION
 SELECT 'towns'::"text" AS "table_name",
    "towns"."id",
    "towns"."name",
    "public"."string_limit"(("towns"."name")::character varying, 20) AS "short_name"
   FROM "public"."towns"
  ORDER BY 1, 4;

ALTER TABLE "public"."view_id_name" OWNER TO "postgres";

CREATE OR REPLACE VIEW "public"."view_rls_edit_for_table" AS
 SELECT 'authors'::"text" AS "table_name",
    "authors"."id",
    "public"."rls_authors_edit"("authors".*) AS "editable",
    "public"."rls_authors_delete"("authors".*) AS "deletable"
   FROM "public"."authors"
UNION
 SELECT 'citations'::"text" AS "table_name",
    "citations"."id",
    "public"."rls_citations_edit"("citations".*) AS "editable",
    "public"."rls_citations_delete"("citations".*) AS "deletable"
   FROM "public"."citations"
UNION
 SELECT 'countries'::"text" AS "table_name",
    "countries"."id",
    "public"."rls_countries_edit"("countries".*) AS "editable",
    "public"."rls_countries_delete"("countries".*) AS "deletable"
   FROM "public"."countries"
UNION
 SELECT 'events'::"text" AS "table_name",
    "events"."id",
    "public"."rls_events_edit"("events".*) AS "editable",
    "public"."rls_events_delete"("events".*) AS "deletable"
   FROM "public"."events"
UNION
 SELECT 'places'::"text" AS "table_name",
    "places"."id",
    "public"."rls_places_edit"("places".*) AS "editable",
    "public"."rls_places_delete"("places".*) AS "deletable"
   FROM "public"."places"
UNION
 SELECT 'profiles'::"text" AS "table_name",
    "profiles"."id",
    "public"."rls_profiles_edit"("profiles".*) AS "editable",
    false AS "deletable"
   FROM "public"."profiles"
UNION
 SELECT 'towns'::"text" AS "table_name",
    "towns"."id",
    "public"."rls_towns_edit"("towns".*) AS "editable",
    "public"."rls_towns_delete"("towns".*) AS "deletable"
   FROM "public"."towns"
UNION
 SELECT 'trusts'::"text" AS "table_name",
    "trusts"."id",
    "public"."rls_trusts_edit"("trusts".*) AS "editable",
    "public"."rls_trusts_edit"("trusts".*) AS "deletable"
   FROM "public"."trusts";

ALTER TABLE "public"."view_rls_edit_for_table" OWNER TO "postgres";

ALTER TABLE ONLY "public"."authors"
    ADD CONSTRAINT "author_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."citations"
    ADD CONSTRAINT "citations_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."countries"
    ADD CONSTRAINT "countries_name_key" UNIQUE ("name");

ALTER TABLE ONLY "public"."countries"
    ADD CONSTRAINT "country_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."events"
    ADD CONSTRAINT "event_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."places"
    ADD CONSTRAINT "place_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."profiles"
    ADD CONSTRAINT "profiles_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."profiles"
    ADD CONSTRAINT "profiles_username_key" UNIQUE ("username");

ALTER TABLE ONLY "public"."towns"
    ADD CONSTRAINT "town_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."trusts"
    ADD CONSTRAINT "trusts_pkey" PRIMARY KEY ("id");

CREATE OR REPLACE TRIGGER "on_authors_edit_fill_update" BEFORE UPDATE ON "public"."authors" FOR EACH ROW EXECUTE FUNCTION "public"."handle_fill_updated"();

CREATE OR REPLACE TRIGGER "on_authors_new_fill_created_by" BEFORE INSERT ON "public"."authors" FOR EACH ROW EXECUTE FUNCTION "public"."handle_fill_created_by"();

CREATE OR REPLACE TRIGGER "on_citations_edit_fill_update" BEFORE UPDATE ON "public"."citations" FOR EACH ROW EXECUTE FUNCTION "public"."handle_fill_updated"();

CREATE OR REPLACE TRIGGER "on_citations_new_fill_created_by" BEFORE INSERT ON "public"."citations" FOR EACH ROW EXECUTE FUNCTION "public"."handle_fill_created_by"();

CREATE OR REPLACE TRIGGER "on_country_edit_fill_update" BEFORE UPDATE ON "public"."countries" FOR EACH ROW EXECUTE FUNCTION "public"."handle_fill_updated"();

CREATE OR REPLACE TRIGGER "on_country_new_fill_created_by" BEFORE INSERT ON "public"."countries" FOR EACH ROW EXECUTE FUNCTION "public"."handle_fill_created_by"();

CREATE OR REPLACE TRIGGER "on_events_edit_fill_update" BEFORE UPDATE ON "public"."events" FOR EACH ROW EXECUTE FUNCTION "public"."handle_fill_updated"();

CREATE OR REPLACE TRIGGER "on_events_new_fill_created_by" BEFORE INSERT ON "public"."events" FOR EACH ROW EXECUTE FUNCTION "public"."handle_fill_created_by"();

CREATE OR REPLACE TRIGGER "on_places_edit_fill_update" BEFORE UPDATE ON "public"."places" FOR EACH ROW EXECUTE FUNCTION "public"."handle_fill_updated"();

CREATE OR REPLACE TRIGGER "on_places_new_fill_created_by" BEFORE INSERT ON "public"."places" FOR EACH ROW EXECUTE FUNCTION "public"."handle_fill_created_by"();

CREATE OR REPLACE TRIGGER "on_public_profiles_new" AFTER INSERT ON "public"."profiles" FOR EACH ROW EXECUTE FUNCTION "public"."handle_public_profile_new"();

CREATE OR REPLACE TRIGGER "on_towns_edit_fill_update" BEFORE UPDATE ON "public"."towns" FOR EACH ROW EXECUTE FUNCTION "public"."handle_fill_updated"();

CREATE OR REPLACE TRIGGER "on_towns_new_fill_created_by" BEFORE INSERT ON "public"."towns" FOR EACH ROW EXECUTE FUNCTION "public"."handle_fill_created_by"();

ALTER TABLE ONLY "public"."authors"
    ADD CONSTRAINT "authors_birth_town_fkey" FOREIGN KEY ("birth_town") REFERENCES "public"."towns"("id") ON UPDATE CASCADE;

ALTER TABLE ONLY "public"."authors"
    ADD CONSTRAINT "authors_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "public"."profiles"("id") ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY "public"."authors"
    ADD CONSTRAINT "authors_updated_by_fkey" FOREIGN KEY ("updated_by") REFERENCES "public"."profiles"("id") ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY "public"."citations"
    ADD CONSTRAINT "citations_author_id_fkey" FOREIGN KEY ("author_id") REFERENCES "public"."authors"("id") ON UPDATE CASCADE;

ALTER TABLE ONLY "public"."citations"
    ADD CONSTRAINT "citations_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "public"."profiles"("id") ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY "public"."citations"
    ADD CONSTRAINT "citations_event_id_fkey" FOREIGN KEY ("event_id") REFERENCES "public"."events"("id") ON UPDATE CASCADE;

ALTER TABLE ONLY "public"."citations"
    ADD CONSTRAINT "citations_place_id_fkey" FOREIGN KEY ("place_id") REFERENCES "public"."places"("id");

ALTER TABLE ONLY "public"."citations"
    ADD CONSTRAINT "citations_updated_by_fkey" FOREIGN KEY ("updated_by") REFERENCES "public"."profiles"("id") ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY "public"."countries"
    ADD CONSTRAINT "countries_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "public"."profiles"("id") ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY "public"."countries"
    ADD CONSTRAINT "countries_updated_by_fkey" FOREIGN KEY ("updated_by") REFERENCES "public"."profiles"("id") ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY "public"."events"
    ADD CONSTRAINT "events_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "public"."profiles"("id") ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY "public"."events"
    ADD CONSTRAINT "events_place_id_fkey" FOREIGN KEY ("place_id") REFERENCES "public"."places"("id") ON UPDATE CASCADE;

ALTER TABLE ONLY "public"."events"
    ADD CONSTRAINT "events_updated_by_fkey" FOREIGN KEY ("updated_by") REFERENCES "public"."profiles"("id") ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY "public"."places"
    ADD CONSTRAINT "places_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "public"."profiles"("id") ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY "public"."places"
    ADD CONSTRAINT "places_town_id_fkey" FOREIGN KEY ("town_id") REFERENCES "public"."towns"("id") ON UPDATE CASCADE;

ALTER TABLE ONLY "public"."places"
    ADD CONSTRAINT "places_updated_by_fkey" FOREIGN KEY ("updated_by") REFERENCES "public"."profiles"("id") ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY "public"."profiles"
    ADD CONSTRAINT "profiles_id_fkey" FOREIGN KEY ("auth_user_id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."towns"
    ADD CONSTRAINT "towns_country_id_fkey" FOREIGN KEY ("country_id") REFERENCES "public"."countries"("id") ON UPDATE CASCADE;

ALTER TABLE ONLY "public"."towns"
    ADD CONSTRAINT "towns_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "public"."profiles"("id") ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY "public"."towns"
    ADD CONSTRAINT "towns_updated_by_fkey" FOREIGN KEY ("updated_by") REFERENCES "public"."profiles"("id") ON UPDATE CASCADE ON DELETE RESTRICT;

CREATE POLICY " RLS: profiles: insert" ON "public"."profiles" FOR INSERT WITH CHECK (("auth"."uid"() = "auth_user_id"));

CREATE POLICY " RLS: profiles: update" ON "public"."profiles" FOR UPDATE USING ("public"."rls_profiles_edit"("profiles".*));

CREATE POLICY "RLS: authors: delete" ON "public"."authors" FOR DELETE TO "authenticated" USING ("public"."rls_authors_edit"("authors".*));

CREATE POLICY "RLS: authors: insert" ON "public"."authors" FOR INSERT TO "authenticated" WITH CHECK ("public"."rls_authors_edit"("authors".*));

CREATE POLICY "RLS: authors: select" ON "public"."authors" FOR SELECT USING (true);

CREATE POLICY "RLS: authors: update" ON "public"."authors" FOR UPDATE TO "authenticated" USING ("public"."rls_authors_edit"("authors".*)) WITH CHECK ("public"."rls_authors_edit"("authors".*));

CREATE POLICY "RLS: citations: delete" ON "public"."citations" FOR DELETE TO "authenticated" USING ("public"."rls_citations_edit"("citations".*));

CREATE POLICY "RLS: citations: insert" ON "public"."citations" FOR INSERT TO "authenticated" WITH CHECK ("public"."rls_citations_edit"("citations".*));

CREATE POLICY "RLS: citations: select" ON "public"."citations" FOR SELECT USING (true);

CREATE POLICY "RLS: citations: update" ON "public"."citations" FOR UPDATE TO "authenticated" USING ("public"."rls_citations_edit"("citations".*)) WITH CHECK ("public"."rls_citations_edit"("citations".*));

CREATE POLICY "RLS: countries: delete" ON "public"."countries" FOR DELETE TO "authenticated" USING ("public"."rls_countries_delete"("countries".*));

CREATE POLICY "RLS: countries: insert" ON "public"."countries" FOR INSERT TO "authenticated" WITH CHECK ("public"."rls_countries_edit"("countries".*));

CREATE POLICY "RLS: countries: select" ON "public"."countries" FOR SELECT USING (true);

CREATE POLICY "RLS: countries: update" ON "public"."countries" FOR UPDATE TO "authenticated" USING ("public"."rls_countries_edit"("countries".*)) WITH CHECK ("public"."rls_countries_edit"("countries".*));

CREATE POLICY "RLS: events: delete" ON "public"."events" FOR DELETE TO "authenticated" USING ("public"."rls_events_edit"("events".*));

CREATE POLICY "RLS: events: insert" ON "public"."events" FOR INSERT TO "authenticated" WITH CHECK ("public"."rls_events_edit"("events".*));

CREATE POLICY "RLS: events: select" ON "public"."events" FOR SELECT USING (true);

CREATE POLICY "RLS: events: update" ON "public"."events" FOR UPDATE TO "authenticated" USING ("public"."rls_events_edit"("events".*)) WITH CHECK ("public"."rls_events_edit"("events".*));

CREATE POLICY "RLS: places: delete" ON "public"."places" FOR DELETE TO "authenticated" USING ("public"."rls_places_edit"("places".*));

CREATE POLICY "RLS: places: insert" ON "public"."places" FOR INSERT TO "authenticated" WITH CHECK ("public"."rls_places_edit"("places".*));

CREATE POLICY "RLS: places: select" ON "public"."places" FOR SELECT USING (true);

CREATE POLICY "RLS: places: update" ON "public"."places" FOR UPDATE TO "authenticated" USING ("public"."rls_places_edit"("places".*)) WITH CHECK ("public"."rls_places_edit"("places".*));

CREATE POLICY "RLS: profiles: select" ON "public"."profiles" FOR SELECT USING (true);

CREATE POLICY "RLS: towns: delete" ON "public"."towns" FOR DELETE TO "authenticated" USING ("public"."rls_towns_edit"("towns".*));

CREATE POLICY "RLS: towns: insert" ON "public"."towns" FOR INSERT TO "authenticated" WITH CHECK ("public"."rls_towns_edit"("towns".*));

CREATE POLICY "RLS: towns: select" ON "public"."towns" FOR SELECT USING (true);

CREATE POLICY "RLS: towns: update" ON "public"."towns" FOR UPDATE TO "authenticated" USING ("public"."rls_towns_edit"("towns".*)) WITH CHECK ("public"."rls_towns_edit"("towns".*));

CREATE POLICY "RLS: trusts: delete" ON "public"."trusts" FOR DELETE TO "authenticated" USING ("public"."rls_trusts_edit"("trusts".*));

CREATE POLICY "RLS: trusts: insert" ON "public"."trusts" FOR INSERT TO "authenticated" WITH CHECK ("public"."rls_trusts_edit"("trusts".*));

CREATE POLICY "RLS: trusts: select" ON "public"."trusts" FOR SELECT TO "authenticated" USING (true);

CREATE POLICY "RLS: trusts: update" ON "public"."trusts" FOR UPDATE TO "authenticated" USING ("public"."rls_trusts_edit"("trusts".*)) WITH CHECK ("public"."rls_trusts_edit"("trusts".*));

ALTER TABLE "public"."authors" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."citations" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."countries" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."events" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."places" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."profiles" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."towns" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."trusts" ENABLE ROW LEVEL SECURITY;

REVOKE USAGE ON SCHEMA "public" FROM PUBLIC;
GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";

GRANT ALL ON FUNCTION "public"."delete_claim"("uid" "uuid", "claim" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."delete_claim"("uid" "uuid", "claim" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."delete_claim"("uid" "uuid", "claim" "text") TO "service_role";

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

GRANT ALL ON TABLE "public"."authors" TO "anon";
GRANT ALL ON TABLE "public"."authors" TO "authenticated";
GRANT ALL ON TABLE "public"."authors" TO "service_role";

GRANT ALL ON FUNCTION "public"."rls_authors_delete"("record" "public"."authors") TO "anon";
GRANT ALL ON FUNCTION "public"."rls_authors_delete"("record" "public"."authors") TO "authenticated";
GRANT ALL ON FUNCTION "public"."rls_authors_delete"("record" "public"."authors") TO "service_role";

GRANT ALL ON FUNCTION "public"."rls_authors_edit"("record" "public"."authors") TO "anon";
GRANT ALL ON FUNCTION "public"."rls_authors_edit"("record" "public"."authors") TO "authenticated";
GRANT ALL ON FUNCTION "public"."rls_authors_edit"("record" "public"."authors") TO "service_role";

GRANT ALL ON FUNCTION "public"."rls_check_delete_by_created_by"("created_by" bigint, "allow_trust" boolean, "claim_check" character varying) TO "anon";
GRANT ALL ON FUNCTION "public"."rls_check_delete_by_created_by"("created_by" bigint, "allow_trust" boolean, "claim_check" character varying) TO "authenticated";
GRANT ALL ON FUNCTION "public"."rls_check_delete_by_created_by"("created_by" bigint, "allow_trust" boolean, "claim_check" character varying) TO "service_role";

GRANT ALL ON FUNCTION "public"."rls_check_edit_by_created_by"("created_by" bigint, "allow_trust" boolean, "claim_check" character varying) TO "anon";
GRANT ALL ON FUNCTION "public"."rls_check_edit_by_created_by"("created_by" bigint, "allow_trust" boolean, "claim_check" character varying) TO "authenticated";
GRANT ALL ON FUNCTION "public"."rls_check_edit_by_created_by"("created_by" bigint, "allow_trust" boolean, "claim_check" character varying) TO "service_role";

GRANT ALL ON TABLE "public"."citations" TO "anon";
GRANT ALL ON TABLE "public"."citations" TO "authenticated";
GRANT ALL ON TABLE "public"."citations" TO "service_role";

GRANT ALL ON FUNCTION "public"."rls_citations_delete"("record" "public"."citations") TO "anon";
GRANT ALL ON FUNCTION "public"."rls_citations_delete"("record" "public"."citations") TO "authenticated";
GRANT ALL ON FUNCTION "public"."rls_citations_delete"("record" "public"."citations") TO "service_role";

GRANT ALL ON FUNCTION "public"."rls_citations_edit"("record" "public"."citations") TO "anon";
GRANT ALL ON FUNCTION "public"."rls_citations_edit"("record" "public"."citations") TO "authenticated";
GRANT ALL ON FUNCTION "public"."rls_citations_edit"("record" "public"."citations") TO "service_role";

GRANT ALL ON TABLE "public"."countries" TO "anon";
GRANT ALL ON TABLE "public"."countries" TO "authenticated";
GRANT ALL ON TABLE "public"."countries" TO "service_role";

GRANT ALL ON FUNCTION "public"."rls_countries_delete"("record" "public"."countries") TO "anon";
GRANT ALL ON FUNCTION "public"."rls_countries_delete"("record" "public"."countries") TO "authenticated";
GRANT ALL ON FUNCTION "public"."rls_countries_delete"("record" "public"."countries") TO "service_role";

GRANT ALL ON FUNCTION "public"."rls_countries_edit"("record" "public"."countries") TO "anon";
GRANT ALL ON FUNCTION "public"."rls_countries_edit"("record" "public"."countries") TO "authenticated";
GRANT ALL ON FUNCTION "public"."rls_countries_edit"("record" "public"."countries") TO "service_role";

GRANT ALL ON TABLE "public"."events" TO "anon";
GRANT ALL ON TABLE "public"."events" TO "authenticated";
GRANT ALL ON TABLE "public"."events" TO "service_role";

GRANT ALL ON FUNCTION "public"."rls_events_delete"("record" "public"."events") TO "anon";
GRANT ALL ON FUNCTION "public"."rls_events_delete"("record" "public"."events") TO "authenticated";
GRANT ALL ON FUNCTION "public"."rls_events_delete"("record" "public"."events") TO "service_role";

GRANT ALL ON FUNCTION "public"."rls_events_edit"("record" "public"."events") TO "anon";
GRANT ALL ON FUNCTION "public"."rls_events_edit"("record" "public"."events") TO "authenticated";
GRANT ALL ON FUNCTION "public"."rls_events_edit"("record" "public"."events") TO "service_role";

GRANT ALL ON TABLE "public"."places" TO "anon";
GRANT ALL ON TABLE "public"."places" TO "authenticated";
GRANT ALL ON TABLE "public"."places" TO "service_role";

GRANT ALL ON FUNCTION "public"."rls_places_delete"("record" "public"."places") TO "anon";
GRANT ALL ON FUNCTION "public"."rls_places_delete"("record" "public"."places") TO "authenticated";
GRANT ALL ON FUNCTION "public"."rls_places_delete"("record" "public"."places") TO "service_role";

GRANT ALL ON FUNCTION "public"."rls_places_edit"("record" "public"."places") TO "anon";
GRANT ALL ON FUNCTION "public"."rls_places_edit"("record" "public"."places") TO "authenticated";
GRANT ALL ON FUNCTION "public"."rls_places_edit"("record" "public"."places") TO "service_role";

GRANT ALL ON TABLE "public"."profiles" TO "anon";
GRANT ALL ON TABLE "public"."profiles" TO "authenticated";
GRANT ALL ON TABLE "public"."profiles" TO "service_role";

GRANT ALL ON FUNCTION "public"."rls_profiles_edit"("records" "public"."profiles"[]) TO "anon";
GRANT ALL ON FUNCTION "public"."rls_profiles_edit"("records" "public"."profiles"[]) TO "authenticated";
GRANT ALL ON FUNCTION "public"."rls_profiles_edit"("records" "public"."profiles"[]) TO "service_role";

GRANT ALL ON FUNCTION "public"."rls_profiles_edit"("record" "public"."profiles") TO "anon";
GRANT ALL ON FUNCTION "public"."rls_profiles_edit"("record" "public"."profiles") TO "authenticated";
GRANT ALL ON FUNCTION "public"."rls_profiles_edit"("record" "public"."profiles") TO "service_role";

GRANT ALL ON TABLE "public"."towns" TO "anon";
GRANT ALL ON TABLE "public"."towns" TO "authenticated";
GRANT ALL ON TABLE "public"."towns" TO "service_role";

GRANT ALL ON FUNCTION "public"."rls_towns_delete"("record" "public"."towns") TO "anon";
GRANT ALL ON FUNCTION "public"."rls_towns_delete"("record" "public"."towns") TO "authenticated";
GRANT ALL ON FUNCTION "public"."rls_towns_delete"("record" "public"."towns") TO "service_role";

GRANT ALL ON FUNCTION "public"."rls_towns_edit"("record" "public"."towns") TO "anon";
GRANT ALL ON FUNCTION "public"."rls_towns_edit"("record" "public"."towns") TO "authenticated";
GRANT ALL ON FUNCTION "public"."rls_towns_edit"("record" "public"."towns") TO "service_role";

GRANT ALL ON TABLE "public"."trusts" TO "anon";
GRANT ALL ON TABLE "public"."trusts" TO "authenticated";
GRANT ALL ON TABLE "public"."trusts" TO "service_role";

GRANT ALL ON FUNCTION "public"."rls_trusts_edit"("record" "public"."trusts") TO "anon";
GRANT ALL ON FUNCTION "public"."rls_trusts_edit"("record" "public"."trusts") TO "authenticated";
GRANT ALL ON FUNCTION "public"."rls_trusts_edit"("record" "public"."trusts") TO "service_role";

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
