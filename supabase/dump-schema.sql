
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
    "birth_town" bigint
);

ALTER TABLE "public"."authors" OWNER TO "postgres";

ALTER TABLE "public"."authors" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."author_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

CREATE TABLE IF NOT EXISTS "public"."citations" (
    "id" bigint NOT NULL,
    "english_text" "text",
    "author_id" bigint NOT NULL,
    "year" bigint,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp without time zone DEFAULT "now"() NOT NULL,
    "original_language_text" "text",
    "place_id" bigint,
    "event_id" bigint
);

ALTER TABLE "public"."citations" OWNER TO "postgres";

ALTER TABLE "public"."citations" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."citations_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

CREATE TABLE IF NOT EXISTS "public"."countries" (
    "id" bigint NOT NULL,
    "name" "text",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"(),
    "found_year" bigint,
    "next_rename_year" bigint
);

ALTER TABLE "public"."countries" OWNER TO "postgres";

ALTER TABLE "public"."countries" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."country_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

CREATE TABLE IF NOT EXISTS "public"."event" (
    "id" bigint NOT NULL,
    "name" "text" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "start_year" bigint NOT NULL,
    "start_month" smallint NOT NULL,
    "end_year" bigint,
    "end_month" smallint,
    "place_id" bigint
);

ALTER TABLE "public"."event" OWNER TO "postgres";

ALTER TABLE "public"."event" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."event_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

CREATE TABLE IF NOT EXISTS "public"."place" (
    "id" bigint NOT NULL,
    "name" "text" DEFAULT 'in'::"text" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "town_id" bigint NOT NULL
);

ALTER TABLE "public"."place" OWNER TO "postgres";

ALTER TABLE "public"."place" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."place_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

CREATE TABLE IF NOT EXISTS "public"."profiles" (
    "auth_user_id" "uuid" NOT NULL,
    "updated_at" timestamp with time zone,
    "username" "text",
    "full_name" "text",
    "avatar_url" "text",
    "website" "text",
    "id" bigint NOT NULL,
    CONSTRAINT "username_length" CHECK (("char_length"("username") >= 3))
);

ALTER TABLE "public"."profiles" OWNER TO "postgres";

ALTER TABLE "public"."profiles" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."profiles_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

CREATE TABLE IF NOT EXISTS "public"."town" (
    "id" bigint NOT NULL,
    "name" "text" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "country_id" bigint NOT NULL
);

ALTER TABLE "public"."town" OWNER TO "postgres";

ALTER TABLE "public"."town" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."town_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

ALTER TABLE ONLY "public"."authors"
    ADD CONSTRAINT "author_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."citations"
    ADD CONSTRAINT "citations_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."countries"
    ADD CONSTRAINT "country_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."event"
    ADD CONSTRAINT "event_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."place"
    ADD CONSTRAINT "place_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."profiles"
    ADD CONSTRAINT "profiles_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."profiles"
    ADD CONSTRAINT "profiles_username_key" UNIQUE ("username");

ALTER TABLE ONLY "public"."town"
    ADD CONSTRAINT "town_pkey" PRIMARY KEY ("id");

CREATE OR REPLACE TRIGGER "on_public_profiles_new" AFTER INSERT ON "public"."profiles" FOR EACH ROW EXECUTE FUNCTION "public"."handle_public_profile_new"();

ALTER TABLE ONLY "public"."authors"
    ADD CONSTRAINT "authors_birth_town_fkey" FOREIGN KEY ("birth_town") REFERENCES "public"."town"("id") ON UPDATE CASCADE;

ALTER TABLE ONLY "public"."citations"
    ADD CONSTRAINT "citations_author_id_fkey" FOREIGN KEY ("author_id") REFERENCES "public"."authors"("id") ON UPDATE CASCADE;

ALTER TABLE ONLY "public"."citations"
    ADD CONSTRAINT "citations_event_id_fkey" FOREIGN KEY ("event_id") REFERENCES "public"."event"("id") ON UPDATE CASCADE;

ALTER TABLE ONLY "public"."citations"
    ADD CONSTRAINT "citations_place_id_fkey" FOREIGN KEY ("place_id") REFERENCES "public"."place"("id");

ALTER TABLE ONLY "public"."event"
    ADD CONSTRAINT "event_place_id_fkey" FOREIGN KEY ("place_id") REFERENCES "public"."place"("id") ON UPDATE CASCADE;

ALTER TABLE ONLY "public"."place"
    ADD CONSTRAINT "place_town_id_fkey" FOREIGN KEY ("town_id") REFERENCES "public"."town"("id") ON UPDATE CASCADE;

ALTER TABLE ONLY "public"."profiles"
    ADD CONSTRAINT "profiles_id_fkey" FOREIGN KEY ("auth_user_id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."town"
    ADD CONSTRAINT "town_country_id_fkey" FOREIGN KEY ("country_id") REFERENCES "public"."countries"("id") ON UPDATE CASCADE;

CREATE POLICY "Public profiles are viewable by everyone." ON "public"."profiles" FOR SELECT USING (true);

CREATE POLICY "Users can insert their own profile." ON "public"."profiles" FOR INSERT WITH CHECK (("auth"."uid"() = "auth_user_id"));

CREATE POLICY "Users can update own profile." ON "public"."profiles" FOR UPDATE USING (("auth"."uid"() = "auth_user_id"));

ALTER TABLE "public"."countries" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "countries: authed can read" ON "public"."countries" FOR SELECT TO "authenticated" USING (true);

ALTER TABLE "public"."profiles" ENABLE ROW LEVEL SECURITY;

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

GRANT ALL ON FUNCTION "public"."handle_public_profile_new"() TO "anon";
GRANT ALL ON FUNCTION "public"."handle_public_profile_new"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."handle_public_profile_new"() TO "service_role";

GRANT ALL ON FUNCTION "public"."is_claims_admin"() TO "anon";
GRANT ALL ON FUNCTION "public"."is_claims_admin"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."is_claims_admin"() TO "service_role";

GRANT ALL ON FUNCTION "public"."set_claim"("uid" "uuid", "claim" "text", "value" "jsonb") TO "anon";
GRANT ALL ON FUNCTION "public"."set_claim"("uid" "uuid", "claim" "text", "value" "jsonb") TO "authenticated";
GRANT ALL ON FUNCTION "public"."set_claim"("uid" "uuid", "claim" "text", "value" "jsonb") TO "service_role";

GRANT ALL ON TABLE "public"."authors" TO "anon";
GRANT ALL ON TABLE "public"."authors" TO "authenticated";
GRANT ALL ON TABLE "public"."authors" TO "service_role";

GRANT ALL ON SEQUENCE "public"."author_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."author_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."author_id_seq" TO "service_role";

GRANT ALL ON TABLE "public"."citations" TO "anon";
GRANT ALL ON TABLE "public"."citations" TO "authenticated";
GRANT ALL ON TABLE "public"."citations" TO "service_role";

GRANT ALL ON SEQUENCE "public"."citations_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."citations_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."citations_id_seq" TO "service_role";

GRANT ALL ON TABLE "public"."countries" TO "anon";
GRANT ALL ON TABLE "public"."countries" TO "authenticated";
GRANT ALL ON TABLE "public"."countries" TO "service_role";

GRANT ALL ON SEQUENCE "public"."country_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."country_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."country_id_seq" TO "service_role";

GRANT ALL ON TABLE "public"."event" TO "anon";
GRANT ALL ON TABLE "public"."event" TO "authenticated";
GRANT ALL ON TABLE "public"."event" TO "service_role";

GRANT ALL ON SEQUENCE "public"."event_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."event_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."event_id_seq" TO "service_role";

GRANT ALL ON TABLE "public"."place" TO "anon";
GRANT ALL ON TABLE "public"."place" TO "authenticated";
GRANT ALL ON TABLE "public"."place" TO "service_role";

GRANT ALL ON SEQUENCE "public"."place_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."place_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."place_id_seq" TO "service_role";

GRANT ALL ON TABLE "public"."profiles" TO "anon";
GRANT ALL ON TABLE "public"."profiles" TO "authenticated";
GRANT ALL ON TABLE "public"."profiles" TO "service_role";

GRANT ALL ON SEQUENCE "public"."profiles_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."profiles_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."profiles_id_seq" TO "service_role";

GRANT ALL ON TABLE "public"."town" TO "anon";
GRANT ALL ON TABLE "public"."town" TO "authenticated";
GRANT ALL ON TABLE "public"."town" TO "service_role";

GRANT ALL ON SEQUENCE "public"."town_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."town_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."town_id_seq" TO "service_role";

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
