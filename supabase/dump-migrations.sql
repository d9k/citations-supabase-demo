--
-- PostgreSQL database dump
--

-- Dumped from database version 15.1 (Ubuntu 15.1-1.pgdg20.04+1)
-- Dumped by pg_dump version 15.4 (Ubuntu 15.4-1.pgdg20.04+1)

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

--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: supabase_migrations; Owner: postgres
--

INSERT INTO "supabase_migrations"."schema_migrations" ("version", "statements", "name") VALUES
	('20231129030618', '{"SET statement_timeout = 0","SET lock_timeout = 0","SET idle_in_transaction_session_timeout = 0","SET client_encoding = ''UTF8''","SET standard_conforming_strings = on","SELECT pg_catalog.set_config(''search_path'', '''', false)","SET check_function_bodies = false","SET xmloption = content","SET client_min_messages = warning","SET row_security = off","CREATE EXTENSION IF NOT EXISTS \"pgsodium\" WITH SCHEMA \"pgsodium\"","CREATE EXTENSION IF NOT EXISTS \"pg_graphql\" WITH SCHEMA \"graphql\"","CREATE EXTENSION IF NOT EXISTS \"pg_stat_statements\" WITH SCHEMA \"extensions\"","CREATE EXTENSION IF NOT EXISTS \"pgcrypto\" WITH SCHEMA \"extensions\"","CREATE EXTENSION IF NOT EXISTS \"pgjwt\" WITH SCHEMA \"extensions\"","CREATE EXTENSION IF NOT EXISTS \"supabase_vault\" WITH SCHEMA \"vault\"","CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\" WITH SCHEMA \"extensions\"","SET default_tablespace = ''''","SET default_table_access_method = \"heap\"","CREATE TABLE IF NOT EXISTS \"public\".\"authors\" (
    \"id\" bigint NOT NULL,
    \"lastname_name_patronymic\" \"text\" NOT NULL,
    \"created_at\" timestamp with time zone DEFAULT \"now\"() NOT NULL,
    \"birth_year\" bigint,
    \"death_year\" bigint,
    \"approximate_years\" boolean DEFAULT false NOT NULL,
    \"updated_at\" timestamp with time zone DEFAULT \"now\"() NOT NULL
)","ALTER TABLE \"public\".\"authors\" OWNER TO \"postgres\"","ALTER TABLE \"public\".\"authors\" ALTER COLUMN \"id\" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME \"public\".\"author_id_seq\"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
)","CREATE TABLE IF NOT EXISTS \"public\".\"citations\" (
    \"id\" bigint NOT NULL,
    \"english_text\" \"text\",
    \"author_id\" bigint NOT NULL,
    \"year\" bigint,
    \"created_at\" timestamp with time zone DEFAULT \"now\"() NOT NULL,
    \"updated_at\" timestamp without time zone DEFAULT \"now\"() NOT NULL,
    \"original_language_text\" \"text\"
)","ALTER TABLE \"public\".\"citations\" OWNER TO \"postgres\"","ALTER TABLE \"public\".\"citations\" ALTER COLUMN \"id\" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME \"public\".\"citations_id_seq\"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
)","CREATE TABLE IF NOT EXISTS \"public\".\"country\" (
    \"id\" bigint NOT NULL,
    \"name\" \"text\",
    \"created_at\" timestamp with time zone DEFAULT \"now\"() NOT NULL,
    \"updated_at\" timestamp with time zone DEFAULT \"now\"(),
    \"found_year\" bigint,
    \"next_rename_year\" bigint
)","ALTER TABLE \"public\".\"country\" OWNER TO \"postgres\"","ALTER TABLE \"public\".\"country\" ALTER COLUMN \"id\" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME \"public\".\"country_id_seq\"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
)","CREATE TABLE IF NOT EXISTS \"public\".\"place\" (
    \"id\" bigint NOT NULL,
    \"name\" \"text\" DEFAULT ''in''::\"text\" NOT NULL,
    \"created_at\" timestamp with time zone DEFAULT \"now\"() NOT NULL,
    \"updated_at\" timestamp with time zone DEFAULT \"now\"() NOT NULL
)","ALTER TABLE \"public\".\"place\" OWNER TO \"postgres\"","ALTER TABLE \"public\".\"place\" ALTER COLUMN \"id\" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME \"public\".\"place_id_seq\"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
)","CREATE TABLE IF NOT EXISTS \"public\".\"province\" (
    \"id\" bigint NOT NULL,
    \"name\" \"text\" NOT NULL,
    \"country_id\" bigint NOT NULL,
    \"created_at\" timestamp with time zone DEFAULT \"now\"() NOT NULL,
    \"updated_at\" timestamp with time zone DEFAULT \"now\"() NOT NULL
)","ALTER TABLE \"public\".\"province\" OWNER TO \"postgres\"","ALTER TABLE \"public\".\"province\" ALTER COLUMN \"id\" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME \"public\".\"province_id_seq\"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
)","CREATE TABLE IF NOT EXISTS \"public\".\"town\" (
    \"id\" bigint NOT NULL,
    \"name\" \"text\" NOT NULL,
    \"province_id\" bigint NOT NULL,
    \"created_at\" timestamp with time zone DEFAULT \"now\"() NOT NULL,
    \"updated_at\" timestamp with time zone DEFAULT \"now\"() NOT NULL
)","ALTER TABLE \"public\".\"town\" OWNER TO \"postgres\"","ALTER TABLE \"public\".\"town\" ALTER COLUMN \"id\" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME \"public\".\"town_id_seq\"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
)","ALTER TABLE ONLY \"public\".\"authors\"
    ADD CONSTRAINT \"author_pkey\" PRIMARY KEY (\"id\")","ALTER TABLE ONLY \"public\".\"citations\"
    ADD CONSTRAINT \"citations_pkey\" PRIMARY KEY (\"id\")","ALTER TABLE ONLY \"public\".\"country\"
    ADD CONSTRAINT \"country_pkey\" PRIMARY KEY (\"id\")","ALTER TABLE ONLY \"public\".\"place\"
    ADD CONSTRAINT \"place_pkey\" PRIMARY KEY (\"id\")","ALTER TABLE ONLY \"public\".\"province\"
    ADD CONSTRAINT \"province_pkey\" PRIMARY KEY (\"id\")","ALTER TABLE ONLY \"public\".\"town\"
    ADD CONSTRAINT \"town_pkey\" PRIMARY KEY (\"id\")","ALTER TABLE ONLY \"public\".\"citations\"
    ADD CONSTRAINT \"citations_author_id_fkey\" FOREIGN KEY (\"author_id\") REFERENCES \"public\".\"authors\"(\"id\") ON UPDATE CASCADE ON DELETE RESTRICT","ALTER TABLE ONLY \"public\".\"province\"
    ADD CONSTRAINT \"province_country_id_fkey\" FOREIGN KEY (\"country_id\") REFERENCES \"public\".\"country\"(\"id\") ON UPDATE CASCADE ON DELETE RESTRICT","ALTER TABLE ONLY \"public\".\"town\"
    ADD CONSTRAINT \"town_province_id_fkey\" FOREIGN KEY (\"province_id\") REFERENCES \"public\".\"province\"(\"id\") ON UPDATE CASCADE ON DELETE RESTRICT","REVOKE USAGE ON SCHEMA \"public\" FROM PUBLIC","GRANT USAGE ON SCHEMA \"public\" TO \"postgres\"","GRANT USAGE ON SCHEMA \"public\" TO \"anon\"","GRANT USAGE ON SCHEMA \"public\" TO \"authenticated\"","GRANT USAGE ON SCHEMA \"public\" TO \"service_role\"","GRANT ALL ON TABLE \"public\".\"authors\" TO \"anon\"","GRANT ALL ON TABLE \"public\".\"authors\" TO \"authenticated\"","GRANT ALL ON TABLE \"public\".\"authors\" TO \"service_role\"","GRANT ALL ON SEQUENCE \"public\".\"author_id_seq\" TO \"anon\"","GRANT ALL ON SEQUENCE \"public\".\"author_id_seq\" TO \"authenticated\"","GRANT ALL ON SEQUENCE \"public\".\"author_id_seq\" TO \"service_role\"","GRANT ALL ON TABLE \"public\".\"citations\" TO \"anon\"","GRANT ALL ON TABLE \"public\".\"citations\" TO \"authenticated\"","GRANT ALL ON TABLE \"public\".\"citations\" TO \"service_role\"","GRANT ALL ON SEQUENCE \"public\".\"citations_id_seq\" TO \"anon\"","GRANT ALL ON SEQUENCE \"public\".\"citations_id_seq\" TO \"authenticated\"","GRANT ALL ON SEQUENCE \"public\".\"citations_id_seq\" TO \"service_role\"","GRANT ALL ON TABLE \"public\".\"country\" TO \"anon\"","GRANT ALL ON TABLE \"public\".\"country\" TO \"authenticated\"","GRANT ALL ON TABLE \"public\".\"country\" TO \"service_role\"","GRANT ALL ON SEQUENCE \"public\".\"country_id_seq\" TO \"anon\"","GRANT ALL ON SEQUENCE \"public\".\"country_id_seq\" TO \"authenticated\"","GRANT ALL ON SEQUENCE \"public\".\"country_id_seq\" TO \"service_role\"","GRANT ALL ON TABLE \"public\".\"place\" TO \"anon\"","GRANT ALL ON TABLE \"public\".\"place\" TO \"authenticated\"","GRANT ALL ON TABLE \"public\".\"place\" TO \"service_role\"","GRANT ALL ON SEQUENCE \"public\".\"place_id_seq\" TO \"anon\"","GRANT ALL ON SEQUENCE \"public\".\"place_id_seq\" TO \"authenticated\"","GRANT ALL ON SEQUENCE \"public\".\"place_id_seq\" TO \"service_role\"","GRANT ALL ON TABLE \"public\".\"province\" TO \"anon\"","GRANT ALL ON TABLE \"public\".\"province\" TO \"authenticated\"","GRANT ALL ON TABLE \"public\".\"province\" TO \"service_role\"","GRANT ALL ON SEQUENCE \"public\".\"province_id_seq\" TO \"anon\"","GRANT ALL ON SEQUENCE \"public\".\"province_id_seq\" TO \"authenticated\"","GRANT ALL ON SEQUENCE \"public\".\"province_id_seq\" TO \"service_role\"","GRANT ALL ON TABLE \"public\".\"town\" TO \"anon\"","GRANT ALL ON TABLE \"public\".\"town\" TO \"authenticated\"","GRANT ALL ON TABLE \"public\".\"town\" TO \"service_role\"","GRANT ALL ON SEQUENCE \"public\".\"town_id_seq\" TO \"anon\"","GRANT ALL ON SEQUENCE \"public\".\"town_id_seq\" TO \"authenticated\"","GRANT ALL ON SEQUENCE \"public\".\"town_id_seq\" TO \"service_role\"","ALTER DEFAULT PRIVILEGES FOR ROLE \"postgres\" IN SCHEMA \"public\" GRANT ALL ON SEQUENCES  TO \"postgres\"","ALTER DEFAULT PRIVILEGES FOR ROLE \"postgres\" IN SCHEMA \"public\" GRANT ALL ON SEQUENCES  TO \"anon\"","ALTER DEFAULT PRIVILEGES FOR ROLE \"postgres\" IN SCHEMA \"public\" GRANT ALL ON SEQUENCES  TO \"authenticated\"","ALTER DEFAULT PRIVILEGES FOR ROLE \"postgres\" IN SCHEMA \"public\" GRANT ALL ON SEQUENCES  TO \"service_role\"","ALTER DEFAULT PRIVILEGES FOR ROLE \"postgres\" IN SCHEMA \"public\" GRANT ALL ON FUNCTIONS  TO \"postgres\"","ALTER DEFAULT PRIVILEGES FOR ROLE \"postgres\" IN SCHEMA \"public\" GRANT ALL ON FUNCTIONS  TO \"anon\"","ALTER DEFAULT PRIVILEGES FOR ROLE \"postgres\" IN SCHEMA \"public\" GRANT ALL ON FUNCTIONS  TO \"authenticated\"","ALTER DEFAULT PRIVILEGES FOR ROLE \"postgres\" IN SCHEMA \"public\" GRANT ALL ON FUNCTIONS  TO \"service_role\"","ALTER DEFAULT PRIVILEGES FOR ROLE \"postgres\" IN SCHEMA \"public\" GRANT ALL ON TABLES  TO \"postgres\"","ALTER DEFAULT PRIVILEGES FOR ROLE \"postgres\" IN SCHEMA \"public\" GRANT ALL ON TABLES  TO \"anon\"","ALTER DEFAULT PRIVILEGES FOR ROLE \"postgres\" IN SCHEMA \"public\" GRANT ALL ON TABLES  TO \"authenticated\"","ALTER DEFAULT PRIVILEGES FOR ROLE \"postgres\" IN SCHEMA \"public\" GRANT ALL ON TABLES  TO \"service_role\"","RESET ALL"}', 'remote_schema'),
	('20231129093821', '{"alter table \"public\".\"province\" drop constraint \"province_country_id_fkey\"","alter table \"public\".\"town\" drop constraint \"town_province_id_fkey\"","alter table \"public\".\"citations\" drop constraint \"citations_author_id_fkey\"","alter table \"public\".\"province\" drop constraint \"province_pkey\"","drop index if exists \"public\".\"province_pkey\"","drop table \"public\".\"province\"","create table \"public\".\"event\" (
    \"id\" bigint generated by default as identity not null,
    \"name\" text not null,
    \"created_at\" timestamp with time zone not null default now(),
    \"updated_at\" timestamp with time zone not null default now(),
    \"start_year\" bigint not null,
    \"start_month\" smallint not null,
    \"end_year\" bigint,
    \"end_month\" smallint,
    \"place_id\" bigint
)","alter table \"public\".\"authors\" add column \"birth_town\" bigint","alter table \"public\".\"citations\" add column \"event_id\" bigint","alter table \"public\".\"citations\" add column \"place_id\" bigint","alter table \"public\".\"place\" add column \"town_id\" bigint not null","alter table \"public\".\"town\" drop column \"province_id\"","alter table \"public\".\"town\" add column \"country_id\" bigint not null","CREATE UNIQUE INDEX event_pkey ON public.event USING btree (id)","alter table \"public\".\"event\" add constraint \"event_pkey\" PRIMARY KEY using index \"event_pkey\"","alter table \"public\".\"authors\" add constraint \"authors_birth_town_fkey\" FOREIGN KEY (birth_town) REFERENCES town(id) ON UPDATE CASCADE not valid","alter table \"public\".\"authors\" validate constraint \"authors_birth_town_fkey\"","alter table \"public\".\"citations\" add constraint \"citations_event_id_fkey\" FOREIGN KEY (event_id) REFERENCES event(id) ON UPDATE CASCADE not valid","alter table \"public\".\"citations\" validate constraint \"citations_event_id_fkey\"","alter table \"public\".\"citations\" add constraint \"citations_place_id_fkey\" FOREIGN KEY (place_id) REFERENCES place(id) not valid","alter table \"public\".\"citations\" validate constraint \"citations_place_id_fkey\"","alter table \"public\".\"event\" add constraint \"event_place_id_fkey\" FOREIGN KEY (place_id) REFERENCES place(id) ON UPDATE CASCADE not valid","alter table \"public\".\"event\" validate constraint \"event_place_id_fkey\"","alter table \"public\".\"place\" add constraint \"place_town_id_fkey\" FOREIGN KEY (town_id) REFERENCES town(id) ON UPDATE CASCADE not valid","alter table \"public\".\"place\" validate constraint \"place_town_id_fkey\"","alter table \"public\".\"town\" add constraint \"town_country_id_fkey\" FOREIGN KEY (country_id) REFERENCES country(id) ON UPDATE CASCADE not valid","alter table \"public\".\"town\" validate constraint \"town_country_id_fkey\"","alter table \"public\".\"citations\" add constraint \"citations_author_id_fkey\" FOREIGN KEY (author_id) REFERENCES authors(id) ON UPDATE CASCADE not valid","alter table \"public\".\"citations\" validate constraint \"citations_author_id_fkey\""}', 'remote_schema'),
	('20231129114012', '{"create table \"public\".\"profiles\" (
    \"id\" uuid not null,
    \"updated_at\" timestamp with time zone,
    \"username\" text,
    \"full_name\" text,
    \"avatar_url\" text,
    \"website\" text
)","alter table \"public\".\"profiles\" enable row level security","CREATE UNIQUE INDEX profiles_pkey ON public.profiles USING btree (id)","CREATE UNIQUE INDEX profiles_username_key ON public.profiles USING btree (username)","alter table \"public\".\"profiles\" add constraint \"profiles_pkey\" PRIMARY KEY using index \"profiles_pkey\"","alter table \"public\".\"profiles\" add constraint \"profiles_id_fkey\" FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE not valid","alter table \"public\".\"profiles\" validate constraint \"profiles_id_fkey\"","alter table \"public\".\"profiles\" add constraint \"profiles_username_key\" UNIQUE using index \"profiles_username_key\"","alter table \"public\".\"profiles\" add constraint \"username_length\" CHECK ((char_length(username) >= 3)) not valid","alter table \"public\".\"profiles\" validate constraint \"username_length\"","set check_function_bodies = off","CREATE OR REPLACE FUNCTION public.handle_new_user()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
begin
  insert into public.profiles (id, full_name, avatar_url)
  values (new.id, new.raw_user_meta_data->>''full_name'', new.raw_user_meta_data->>''avatar_url'');
  return new;
end;
$function$","create policy \"Public profiles are viewable by everyone.\"
on \"public\".\"profiles\"
as permissive
for select
to public
using (true)","create policy \"Users can insert their own profile.\"
on \"public\".\"profiles\"
as permissive
for insert
to public
with check ((auth.uid() = id))","create policy \"Users can update own profile.\"
on \"public\".\"profiles\"
as permissive
for update
to public
using ((auth.uid() = id))"}', 'user_management_starter'),
	('20231207142347', '{"alter table \"public\".\"town\" drop constraint \"town_country_id_fkey\"","alter table \"public\".\"country\" drop constraint \"country_pkey\"","drop index if exists \"public\".\"country_pkey\"","drop table \"public\".\"country\"","create table \"public\".\"countries\" (
    \"id\" bigint generated by default as identity not null,
    \"name\" text,
    \"created_at\" timestamp with time zone not null default now(),
    \"updated_at\" timestamp with time zone default now(),
    \"found_year\" bigint,
    \"next_rename_year\" bigint
)","CREATE UNIQUE INDEX country_pkey ON public.countries USING btree (id)","alter table \"public\".\"countries\" add constraint \"country_pkey\" PRIMARY KEY using index \"country_pkey\"","alter table \"public\".\"town\" add constraint \"town_country_id_fkey\" FOREIGN KEY (country_id) REFERENCES countries(id) ON UPDATE CASCADE not valid","alter table \"public\".\"town\" validate constraint \"town_country_id_fkey\""}', 'rename_countries'),
	('20231209022533', '{"CREATE TRIGGER on_auth_user_new AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION handle_auth_user_new()","drop policy \"Users can insert their own profile.\" on \"public\".\"profiles\"","drop policy \"Users can update own profile.\" on \"public\".\"profiles\"","alter table \"public\".\"profiles\" drop constraint \"profiles_id_fkey\"","drop function if exists \"public\".\"handle_new_user\"()","alter table \"public\".\"countries\" enable row level security","alter table \"public\".\"profiles\" add column \"auth_user_id\" uuid not null","alter table \"public\".\"profiles\" alter column \"id\" add generated by default as identity","alter table \"public\".\"profiles\" alter column \"id\" set data type bigint using \"id\"::bigint","alter table \"public\".\"profiles\" add constraint \"profiles_id_fkey\" FOREIGN KEY (auth_user_id) REFERENCES auth.users(id) ON DELETE CASCADE not valid","alter table \"public\".\"profiles\" validate constraint \"profiles_id_fkey\"","set check_function_bodies = off","CREATE OR REPLACE FUNCTION public.delete_claim(uid uuid, claim text)
 RETURNS text
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''public''
AS $function$
    BEGIN
      IF NOT is_claims_admin() THEN
          RETURN ''error: access denied'';
      ELSE        
        update auth.users set raw_app_meta_data = 
          raw_app_meta_data - claim where id = uid;
        return ''OK'';
      END IF;
    END;
$function$","CREATE OR REPLACE FUNCTION public.get_claim(uid uuid, claim text)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''public''
AS $function$
    DECLARE retval jsonb;
    BEGIN
      IF NOT is_claims_admin() THEN
          RETURN ''{\"error\":\"access denied\"}''::jsonb;
      ELSE
        select coalesce(raw_app_meta_data->claim, null) from auth.users into retval where id = uid::uuid;
        return retval;
      END IF;
    END;
$function$","CREATE OR REPLACE FUNCTION public.get_claims(uid uuid)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''public''
AS $function$
    DECLARE retval jsonb;
    BEGIN
      IF NOT is_claims_admin() THEN
          RETURN ''{\"error\":\"access denied\"}''::jsonb;
      ELSE
        select raw_app_meta_data from auth.users into retval where id = uid::uuid;
        return retval;
      END IF;
    END;
$function$","CREATE OR REPLACE FUNCTION public.get_my_claim(claim text)
 RETURNS jsonb
 LANGUAGE sql
 STABLE
AS $function$
  select 
  	coalesce(nullif(current_setting(''request.jwt.claims'', true), '''')::jsonb -> ''app_metadata'' -> claim, null)
$function$","CREATE OR REPLACE FUNCTION public.get_my_claims()
 RETURNS jsonb
 LANGUAGE sql
 STABLE
AS $function$
  select 
  	coalesce(nullif(current_setting(''request.jwt.claims'', true), '''')::jsonb -> ''app_metadata'', ''{}''::jsonb)::jsonb
$function$","CREATE OR REPLACE FUNCTION public.handle_auth_user_new()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
  INSERT INTO public.profiles (auth_user_id, full_name, avatar_url)
	  VALUES (
		  NEW.id,
		  NEW.raw_user_meta_data->>''full_name'',
		  NEW.raw_user_meta_data->>''avatar_url''
	  );
  RETURN NEW;
END;
$function$","CREATE OR REPLACE FUNCTION public.handle_public_profile_new()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$

BEGIN

/**
 * see `set claim` at
 * https://github.com/supabase-community/supabase-custom-claims/blob/main/install.sql
 **/
  UPDATE auth.users
  SET
	  raw_app_meta_data = COALESCE(
		  raw_app_meta_data || JSON_BUILD_OBJECT(''profile_id'', NEW.id)::jsonb,
		  JSON_BUILD_OBJECT(''profile_id'', NEW.id)::jsonb
	  )
  WHERE id = NEW.auth_user_id;

  RETURN NEW;
END;
$function$","CREATE OR REPLACE FUNCTION public.is_claims_admin()
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
  BEGIN
    IF session_user = ''authenticator'' THEN
      --------------------------------------------
      -- To disallow any authenticated app users
      -- from editing claims, delete the following
      -- block of code and replace it with:
      -- RETURN FALSE;
      --------------------------------------------
      IF extract(epoch from now()) > coalesce((current_setting(''request.jwt.claims'', true)::jsonb)->>''exp'', ''0'')::numeric THEN
        return false; -- jwt expired
      END IF;
      If current_setting(''request.jwt.claims'', true)::jsonb->>''role'' = ''service_role'' THEN
        RETURN true; -- service role users have admin rights
      END IF;
      IF coalesce((current_setting(''request.jwt.claims'', true)::jsonb)->''app_metadata''->''claims_admin'', ''false'')::bool THEN
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
$function$","CREATE OR REPLACE FUNCTION public.set_claim(uid uuid, claim text, value jsonb)
 RETURNS text
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''public''
AS $function$
    BEGIN
      IF NOT is_claims_admin() THEN
          RETURN ''error: access denied'';
      ELSE        
        update auth.users set raw_app_meta_data = 
          raw_app_meta_data || 
            json_build_object(claim, value)::jsonb where id = uid;
        return ''OK'';
      END IF;
    END;
$function$","create policy \"countries: authed can read\"
on \"public\".\"countries\"
as permissive
for select
to authenticated
using (true)","create policy \"Users can insert their own profile.\"
on \"public\".\"profiles\"
as permissive
for insert
to public
with check ((auth.uid() = auth_user_id))","create policy \"Users can update own profile.\"
on \"public\".\"profiles\"
as permissive
for update
to public
using ((auth.uid() = auth_user_id))","CREATE TRIGGER on_public_profiles_new AFTER INSERT ON public.profiles FOR EACH ROW EXECUTE FUNCTION handle_public_profile_new()"}', 'profile_id'),
	('20231221015017', '{"drop policy \"countries: authed can read\" on \"public\".\"countries\"","alter table \"public\".\"profiles\" drop constraint \"profiles_pkey\"","drop index if exists \"public\".\"profiles_pkey\"","alter table \"public\".\"countries\" add column \"created_by\" bigint","alter table \"public\".\"countries\" add column \"updated_by\" bigint","alter table \"public\".\"countries\" alter column \"name\" set default ''''::text","alter table \"public\".\"countries\" alter column \"name\" set not null","CREATE UNIQUE INDEX profiles_pkey ON public.profiles USING btree (id)","alter table \"public\".\"profiles\" add constraint \"profiles_pkey\" PRIMARY KEY using index \"profiles_pkey\"","alter table \"public\".\"countries\" add constraint \"countries_created_by_fkey\" FOREIGN KEY (created_by) REFERENCES profiles(id) ON UPDATE CASCADE ON DELETE RESTRICT not valid","alter table \"public\".\"countries\" validate constraint \"countries_created_by_fkey\"","alter table \"public\".\"countries\" add constraint \"countries_name_check\" CHECK ((length(name) > 0)) not valid","alter table \"public\".\"countries\" validate constraint \"countries_name_check\"","alter table \"public\".\"countries\" add constraint \"countries_updated_by_fkey\" FOREIGN KEY (updated_by) REFERENCES profiles(id) ON UPDATE CASCADE ON DELETE RESTRICT not valid","alter table \"public\".\"countries\" validate constraint \"countries_updated_by_fkey\"","set check_function_bodies = off","CREATE OR REPLACE FUNCTION public.handle_fill_created_by()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
  NEW.created_by := get_my_claim(''profile_id'');
  RETURN NEW;
END;
$function$","CREATE OR REPLACE FUNCTION public.handle_fill_updated()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
  NEW.updated_by := get_my_claim(''profile_id'');
  NEW.updated_at := NOW();
  RETURN NEW;
END;
$function$","create policy \"countries: authed can all\"
on \"public\".\"countries\"
as permissive
for all
to authenticated
using (true)
with check (true)","CREATE TRIGGER on_country_edit_fill_update BEFORE UPDATE ON public.countries FOR EACH ROW EXECUTE FUNCTION handle_fill_updated()","CREATE TRIGGER on_country_new_fill_created_by BEFORE INSERT ON public.countries FOR EACH ROW EXECUTE FUNCTION handle_fill_created_by()"}', 'countries_fill_created_updated'),
	('20231223035856', '{"drop policy \"Users can update own profile.\" on \"public\".\"profiles\"","create table \"public\".\"trusts\" (
    \"id\" bigint generated by default as identity not null,
    \"who\" bigint not null,
    \"trusts_who\" bigint not null
)","alter table \"public\".\"trusts\" enable row level security","CREATE UNIQUE INDEX countries_name_key ON public.countries USING btree (name)","CREATE UNIQUE INDEX trusts_pkey ON public.trusts USING btree (id)","alter table \"public\".\"trusts\" add constraint \"trusts_pkey\" PRIMARY KEY using index \"trusts_pkey\"","alter table \"public\".\"countries\" add constraint \"countries_name_key\" UNIQUE using index \"countries_name_key\"","set check_function_bodies = off","CREATE OR REPLACE FUNCTION public.rls_profiles_edit(record profiles)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN
    RAISE LOG ''rls_profiles_edit: profile %'', record.id;
    RETURN auth.uid() = record.auth_user_id;
END;
$function$","CREATE OR REPLACE FUNCTION public.rls_profiles_edit(records profiles[])
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
DECLARE
    t profiles;
BEGIN
  FOREACH t IN ARRAY records LOOP
    RAISE LOG ''rls_profiles_edit: profiles %'', t.id;
    RETURN TRUE;
  END LOOP;
END;
$function$","CREATE OR REPLACE FUNCTION public.temporary_fn()
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN
  RAISE LOG ''This is an informational message'';
  RETURN TRUE;
END;
$function$","create or replace view \"public\".\"rls_edit_for_table\" as  SELECT ''profiles''::text AS table_name,
    profiles.id,
    rls_profiles_edit(profiles.*) AS editable
   FROM profiles","create policy \"Users can update own profile.\"
on \"public\".\"profiles\"
as permissive
for update
to public
using (rls_profiles_edit(profiles.*))"}', 'rls_profiles_edit'),
	('20231224133725', '{"drop policy \"countries: authed can all\" on \"public\".\"countries\"","alter table \"public\".\"trusts\" rename column \"trusts_who\" to \"trusts_whom\"","alter table \"public\".\"trusts\" add column \"end_at\" timestamp with time zone not null default (now() + ''1 day''::interval)","set check_function_bodies = off","CREATE OR REPLACE FUNCTION public.rls_check_edit_by_created_by(created_by bigint, allow_trust boolean DEFAULT true, claim_check character varying DEFAULT ''claim_edit_all_content''::character varying)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
DECLARE
	profile_id int8;
BEGIN
  profile_id := get_my_claim(''profile_id'')::int;
	-- RAISE WARNING ''rls_check_by_created_by: created_by: %, profile_id: %'', created_by, profile_id;
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
$function$","CREATE OR REPLACE FUNCTION public.rls_check_delete_by_created_by(created_by bigint, allow_trust boolean DEFAULT true, claim_check character varying DEFAULT ''claim_delete_all_content''::character varying)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN
	RETURN rls_check_edit_by_created_by(created_by, allow_trust, claim_check);
END;
$function$","CREATE OR REPLACE FUNCTION public.rls_countries_delete(record countries)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN rls_check_delete_by_created_by(record.created_by);
END;
$function$","CREATE OR REPLACE FUNCTION public.rls_countries_edit(record countries)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN rls_check_edit_by_created_by(record.created_by);
END;
$function$","create or replace view \"public\".\"rls_edit_for_table\" as  SELECT ''profiles''::text AS table_name,
    profiles.id,
    rls_profiles_edit(profiles.*) AS editable,
    false AS deletable
   FROM profiles
UNION
 SELECT ''countries''::text AS table_name,
    countries.id,
    rls_countries_edit(countries.*) AS editable,
    rls_countries_delete(countries.*) AS deletable
   FROM countries","CREATE OR REPLACE FUNCTION public.set_claim(uid uuid, claim text, value jsonb)
 RETURNS text
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''public''
AS $function$
    BEGIN
      IF NOT is_claims_admin() THEN
          RETURN ''error: access denied'';
      ELSE
        update auth.users set raw_app_meta_data =
          raw_app_meta_data ||
            json_build_object(claim, value)::jsonb where id = uid;
        return ''OK'';
      END IF;
    END;
$function$","create policy \"RLS: countries: delete\"
on \"public\".\"countries\"
as permissive
for delete
to authenticated
using (rls_countries_edit(countries.*))","create policy \"RLS: countries: insert\"
on \"public\".\"countries\"
as permissive
for insert
to authenticated
with check (rls_countries_edit(countries.*))","create policy \"RLS: countries: select\"
on \"public\".\"countries\"
as permissive
for select
to public
using (true)","create policy \"RLS: countries: update\"
on \"public\".\"countries\"
as permissive
for update
to authenticated
with check (rls_countries_edit(countries.*))","create policy \"Enable read access for all users\"
on \"public\".\"trusts\"
as permissive
for select
to public
using (true)"}', 'rls_check_edit_by_created_by_for_countries'),
	('20231224200604', '{"drop policy \"RLS: countries: delete\" on \"public\".\"countries\"","alter table \"public\".\"event\" drop constraint \"event_place_id_fkey\"","alter table \"public\".\"place\" drop constraint \"place_town_id_fkey\"","alter table \"public\".\"town\" drop constraint \"town_country_id_fkey\"","alter table \"public\".\"authors\" drop constraint \"authors_birth_town_fkey\"","alter table \"public\".\"citations\" drop constraint \"citations_event_id_fkey\"","alter table \"public\".\"citations\" drop constraint \"citations_place_id_fkey\"","alter table \"public\".\"event\" drop constraint \"event_pkey\"","alter table \"public\".\"place\" drop constraint \"place_pkey\"","alter table \"public\".\"town\" drop constraint \"town_pkey\"","drop index if exists \"public\".\"event_pkey\"","drop index if exists \"public\".\"place_pkey\"","drop index if exists \"public\".\"town_pkey\"","drop table \"public\".\"event\"","drop table \"public\".\"place\"","drop table \"public\".\"town\"","create table \"public\".\"events\" (
    \"id\" bigint generated by default as identity not null,
    \"name\" text not null,
    \"created_at\" timestamp with time zone not null default now(),
    \"updated_at\" timestamp with time zone not null default now(),
    \"start_year\" bigint not null,
    \"start_month\" smallint not null,
    \"end_year\" bigint,
    \"end_month\" smallint,
    \"place_id\" bigint,
    \"created_by\" bigint,
    \"updated_by\" bigint
)","create table \"public\".\"places\" (
    \"id\" bigint generated by default as identity not null,
    \"name\" text not null default ''in''::text,
    \"created_at\" timestamp with time zone not null default now(),
    \"updated_at\" timestamp with time zone not null default now(),
    \"town_id\" bigint not null,
    \"created_by\" bigint,
    \"updated_by\" bigint
)","create table \"public\".\"towns\" (
    \"id\" bigint generated by default as identity not null,
    \"name\" text not null,
    \"created_at\" timestamp with time zone not null default now(),
    \"updated_at\" timestamp with time zone not null default now(),
    \"country_id\" bigint not null,
    \"created_by\" bigint,
    \"updated_by\" bigint
)","alter table \"public\".\"authors\" add column \"created_by\" bigint","alter table \"public\".\"authors\" add column \"updated_by\" bigint","alter table \"public\".\"citations\" add column \"created_by\" bigint","alter table \"public\".\"citations\" add column \"updated_by\" bigint","alter table \"public\".\"profiles\" add column \"created_at\" timestamp with time zone default now()","CREATE UNIQUE INDEX event_pkey ON public.events USING btree (id)","CREATE UNIQUE INDEX place_pkey ON public.places USING btree (id)","CREATE UNIQUE INDEX town_pkey ON public.towns USING btree (id)","alter table \"public\".\"events\" add constraint \"event_pkey\" PRIMARY KEY using index \"event_pkey\"","alter table \"public\".\"places\" add constraint \"place_pkey\" PRIMARY KEY using index \"place_pkey\"","alter table \"public\".\"towns\" add constraint \"town_pkey\" PRIMARY KEY using index \"town_pkey\"","alter table \"public\".\"authors\" add constraint \"authors_created_by_fkey\" FOREIGN KEY (created_by) REFERENCES profiles(id) ON UPDATE CASCADE ON DELETE RESTRICT not valid","alter table \"public\".\"authors\" validate constraint \"authors_created_by_fkey\"","alter table \"public\".\"authors\" add constraint \"authors_updated_by_fkey\" FOREIGN KEY (updated_by) REFERENCES profiles(id) ON UPDATE CASCADE ON DELETE RESTRICT not valid","alter table \"public\".\"authors\" validate constraint \"authors_updated_by_fkey\"","alter table \"public\".\"citations\" add constraint \"citations_created_by_fkey\" FOREIGN KEY (created_by) REFERENCES profiles(id) ON UPDATE CASCADE ON DELETE RESTRICT not valid","alter table \"public\".\"citations\" validate constraint \"citations_created_by_fkey\"","alter table \"public\".\"citations\" add constraint \"citations_updated_by_fkey\" FOREIGN KEY (updated_by) REFERENCES profiles(id) ON UPDATE CASCADE ON DELETE RESTRICT not valid","alter table \"public\".\"citations\" validate constraint \"citations_updated_by_fkey\"","alter table \"public\".\"events\" add constraint \"events_created_by_fkey\" FOREIGN KEY (created_by) REFERENCES profiles(id) ON UPDATE CASCADE ON DELETE RESTRICT not valid","alter table \"public\".\"events\" validate constraint \"events_created_by_fkey\"","alter table \"public\".\"events\" add constraint \"events_place_id_fkey\" FOREIGN KEY (place_id) REFERENCES places(id) ON UPDATE CASCADE not valid","alter table \"public\".\"events\" validate constraint \"events_place_id_fkey\"","alter table \"public\".\"events\" add constraint \"events_updated_by_fkey\" FOREIGN KEY (updated_by) REFERENCES profiles(id) ON UPDATE CASCADE ON DELETE RESTRICT not valid","alter table \"public\".\"events\" validate constraint \"events_updated_by_fkey\"","alter table \"public\".\"places\" add constraint \"places_created_by_fkey\" FOREIGN KEY (created_by) REFERENCES profiles(id) ON UPDATE CASCADE ON DELETE RESTRICT not valid","alter table \"public\".\"places\" validate constraint \"places_created_by_fkey\"","alter table \"public\".\"places\" add constraint \"places_town_id_fkey\" FOREIGN KEY (town_id) REFERENCES towns(id) ON UPDATE CASCADE not valid","alter table \"public\".\"places\" validate constraint \"places_town_id_fkey\"","alter table \"public\".\"places\" add constraint \"places_updated_by_fkey\" FOREIGN KEY (updated_by) REFERENCES profiles(id) ON UPDATE CASCADE ON DELETE RESTRICT not valid","alter table \"public\".\"places\" validate constraint \"places_updated_by_fkey\"","alter table \"public\".\"towns\" add constraint \"towns_country_id_fkey\" FOREIGN KEY (country_id) REFERENCES countries(id) ON UPDATE CASCADE not valid","alter table \"public\".\"towns\" validate constraint \"towns_country_id_fkey\"","alter table \"public\".\"towns\" add constraint \"towns_created_by_fkey\" FOREIGN KEY (created_by) REFERENCES profiles(id) ON UPDATE CASCADE ON DELETE RESTRICT not valid","alter table \"public\".\"towns\" validate constraint \"towns_created_by_fkey\"","alter table \"public\".\"towns\" add constraint \"towns_updated_by_fkey\" FOREIGN KEY (updated_by) REFERENCES profiles(id) ON UPDATE CASCADE ON DELETE RESTRICT not valid","alter table \"public\".\"towns\" validate constraint \"towns_updated_by_fkey\"","alter table \"public\".\"authors\" add constraint \"authors_birth_town_fkey\" FOREIGN KEY (birth_town) REFERENCES towns(id) ON UPDATE CASCADE not valid","alter table \"public\".\"authors\" validate constraint \"authors_birth_town_fkey\"","alter table \"public\".\"citations\" add constraint \"citations_event_id_fkey\" FOREIGN KEY (event_id) REFERENCES events(id) ON UPDATE CASCADE not valid","alter table \"public\".\"citations\" validate constraint \"citations_event_id_fkey\"","alter table \"public\".\"citations\" add constraint \"citations_place_id_fkey\" FOREIGN KEY (place_id) REFERENCES places(id) not valid","alter table \"public\".\"citations\" validate constraint \"citations_place_id_fkey\"","set check_function_bodies = off","create policy \"RLS: countries: delete\"
on \"public\".\"countries\"
as permissive
for delete
to authenticated
using (rls_countries_delete(countries.*))","CREATE TRIGGER on_authors_edit_fill_update BEFORE UPDATE ON public.authors FOR EACH ROW EXECUTE FUNCTION handle_fill_updated()","CREATE TRIGGER on_authors_new_fill_created_by BEFORE INSERT ON public.authors FOR EACH ROW EXECUTE FUNCTION handle_fill_created_by()","CREATE TRIGGER on_citations_edit_fill_update BEFORE UPDATE ON public.citations FOR EACH ROW EXECUTE FUNCTION handle_fill_updated()","CREATE TRIGGER on_citations_new_fill_created_by BEFORE INSERT ON public.citations FOR EACH ROW EXECUTE FUNCTION handle_fill_created_by()","CREATE TRIGGER on_events_edit_fill_update BEFORE UPDATE ON public.events FOR EACH ROW EXECUTE FUNCTION handle_fill_updated()","CREATE TRIGGER on_events_new_fill_created_by BEFORE INSERT ON public.events FOR EACH ROW EXECUTE FUNCTION handle_fill_created_by()","CREATE TRIGGER on_places_edit_fill_update BEFORE UPDATE ON public.places FOR EACH ROW EXECUTE FUNCTION handle_fill_updated()","CREATE TRIGGER on_places_new_fill_created_by BEFORE INSERT ON public.places FOR EACH ROW EXECUTE FUNCTION handle_fill_created_by()","CREATE TRIGGER on_towns_edit_fill_update BEFORE UPDATE ON public.towns FOR EACH ROW EXECUTE FUNCTION handle_fill_updated()","CREATE TRIGGER on_towns_new_fill_created_by BEFORE INSERT ON public.towns FOR EACH ROW EXECUTE FUNCTION handle_fill_created_by()"}', 'content_tables_add_created_and_updated_by');


--
-- PostgreSQL database dump complete
--

RESET ALL;
