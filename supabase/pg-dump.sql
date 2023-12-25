--
-- PostgreSQL database dump
--

-- Dumped from database version 15.1 (Ubuntu 15.1-1.pgdg20.04+1)
-- Dumped by pg_dump version 16.1 (Ubuntu 16.1-1.pgdg22.04+1)

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
-- Name: auth; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA auth;


ALTER SCHEMA auth OWNER TO supabase_admin;

--
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA extensions;


ALTER SCHEMA extensions OWNER TO postgres;

--
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql;


ALTER SCHEMA graphql OWNER TO supabase_admin;

--
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql_public;


ALTER SCHEMA graphql_public OWNER TO supabase_admin;

--
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: pgbouncer
--

CREATE SCHEMA pgbouncer;


ALTER SCHEMA pgbouncer OWNER TO pgbouncer;

--
-- Name: pgsodium; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA pgsodium;


ALTER SCHEMA pgsodium OWNER TO supabase_admin;

--
-- Name: pgsodium; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgsodium WITH SCHEMA pgsodium;


--
-- Name: EXTENSION pgsodium; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgsodium IS 'Pgsodium is a modern cryptography library for Postgres.';


--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS '';


--
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA realtime;


ALTER SCHEMA realtime OWNER TO supabase_admin;

--
-- Name: storage; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA storage;


ALTER SCHEMA storage OWNER TO supabase_admin;

--
-- Name: supabase_migrations; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA supabase_migrations;


ALTER SCHEMA supabase_migrations OWNER TO postgres;

--
-- Name: vault; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA vault;


ALTER SCHEMA vault OWNER TO supabase_admin;

--
-- Name: pg_graphql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_graphql WITH SCHEMA graphql;


--
-- Name: EXTENSION pg_graphql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_graphql IS 'pg_graphql: GraphQL support';


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: pgjwt; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgjwt WITH SCHEMA extensions;


--
-- Name: EXTENSION pgjwt; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgjwt IS 'JSON Web Token API for Postgresql';


--
-- Name: supabase_vault; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS supabase_vault WITH SCHEMA vault;


--
-- Name: EXTENSION supabase_vault; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION supabase_vault IS 'Supabase Vault Extension';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


ALTER TYPE auth.aal_level OWNER TO supabase_auth_admin;

--
-- Name: code_challenge_method; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.code_challenge_method AS ENUM (
    's256',
    'plain'
);


ALTER TYPE auth.code_challenge_method OWNER TO supabase_auth_admin;

--
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


ALTER TYPE auth.factor_status OWNER TO supabase_auth_admin;

--
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn'
);


ALTER TYPE auth.factor_type OWNER TO supabase_auth_admin;

--
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.email() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.email', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
  )::text
$$;


ALTER FUNCTION auth.email() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
    coalesce(
        nullif(current_setting('request.jwt.claim', true), ''),
        nullif(current_setting('request.jwt.claims', true), '')
    )::jsonb
$$;


ALTER FUNCTION auth.jwt() OWNER TO supabase_auth_admin;

--
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.role', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
  )::text
$$;


ALTER FUNCTION auth.role() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
  )::uuid
$$;


ALTER FUNCTION auth.uid() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: postgres
--

CREATE FUNCTION extensions.grant_pg_cron_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_cron'
  )
  THEN
    grant usage on schema cron to postgres with grant option;

    alter default privileges in schema cron grant all on tables to postgres with grant option;
    alter default privileges in schema cron grant all on functions to postgres with grant option;
    alter default privileges in schema cron grant all on sequences to postgres with grant option;

    alter default privileges for user supabase_admin in schema cron grant all
        on sequences to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on tables to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on functions to postgres with grant option;

    grant all privileges on all tables in schema cron to postgres with grant option;
    revoke all on table cron.job from postgres;
    grant select on table cron.job to postgres with grant option;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_cron_access() OWNER TO postgres;

--
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: postgres
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_graphql_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
    func_is_graphql_resolve bool;
BEGIN
    func_is_graphql_resolve = (
        SELECT n.proname = 'resolve'
        FROM pg_event_trigger_ddl_commands() AS ev
        LEFT JOIN pg_catalog.pg_proc AS n
        ON ev.objid = n.oid
    );

    IF func_is_graphql_resolve
    THEN
        -- Update public wrapper to pass all arguments through to the pg_graphql resolve func
        DROP FUNCTION IF EXISTS graphql_public.graphql;
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language sql
        as $$
            select graphql.resolve(
                query := query,
                variables := coalesce(variables, '{}'),
                "operationName" := "operationName",
                extensions := extensions
            );
        $$;

        -- This hook executes when `graphql.resolve` is created. That is not necessarily the last
        -- function in the extension so we need to grant permissions on existing entities AND
        -- update default permissions to any others that are created after `graphql.resolve`
        grant usage on schema graphql to postgres, anon, authenticated, service_role;
        grant select on all tables in schema graphql to postgres, anon, authenticated, service_role;
        grant execute on all functions in schema graphql to postgres, anon, authenticated, service_role;
        grant all on all sequences in schema graphql to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on tables to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on functions to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on sequences to postgres, anon, authenticated, service_role;

        -- Allow postgres role to allow granting usage on graphql and graphql_public schemas to custom roles
        grant usage on schema graphql_public to postgres with grant option;
        grant usage on schema graphql to postgres with grant option;
    END IF;

END;
$_$;


ALTER FUNCTION extensions.grant_pg_graphql_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: postgres
--

CREATE FUNCTION extensions.grant_pg_net_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_net'
  )
  THEN
    IF NOT EXISTS (
      SELECT 1
      FROM pg_roles
      WHERE rolname = 'supabase_functions_admin'
    )
    THEN
      CREATE USER supabase_functions_admin NOINHERIT CREATEROLE LOGIN NOREPLICATION;
    END IF;

    GRANT USAGE ON SCHEMA net TO supabase_functions_admin, postgres, anon, authenticated, service_role;

    ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
    ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;

    ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
    ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;

    REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
    REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;

    GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_net_access() OWNER TO postgres;

--
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: postgres
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN SELECT * FROM pg_event_trigger_ddl_commands()
  LOOP
    IF cmd.command_tag IN (
      'CREATE SCHEMA', 'ALTER SCHEMA'
    , 'CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO', 'ALTER TABLE'
    , 'CREATE FOREIGN TABLE', 'ALTER FOREIGN TABLE'
    , 'CREATE VIEW', 'ALTER VIEW'
    , 'CREATE MATERIALIZED VIEW', 'ALTER MATERIALIZED VIEW'
    , 'CREATE FUNCTION', 'ALTER FUNCTION'
    , 'CREATE TRIGGER'
    , 'CREATE TYPE', 'ALTER TYPE'
    , 'CREATE RULE'
    , 'COMMENT'
    )
    -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
    AND cmd.schema_name is distinct from 'pg_temp'
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_ddl_watch() OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  obj record;
BEGIN
  FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
  LOOP
    IF obj.object_type IN (
      'schema'
    , 'table'
    , 'foreign table'
    , 'view'
    , 'materialized view'
    , 'function'
    , 'trigger'
    , 'type'
    , 'rule'
    )
    AND obj.is_temporary IS false -- no pg_temp objects
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_drop_watch() OWNER TO supabase_admin;

--
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.set_graphql_placeholder() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
    DECLARE
    graphql_is_dropped bool;
    BEGIN
    graphql_is_dropped = (
        SELECT ev.schema_name = 'graphql_public'
        FROM pg_event_trigger_dropped_objects() AS ev
        WHERE ev.schema_name = 'graphql_public'
    );

    IF graphql_is_dropped
    THEN
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language plpgsql
        as $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;
    END IF;

    END;
$_$;


ALTER FUNCTION extensions.set_graphql_placeholder() OWNER TO supabase_admin;

--
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: postgres
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RAISE WARNING 'PgBouncer auth request: %', p_usename;

    RETURN QUERY
    SELECT usename::TEXT, passwd::TEXT FROM pg_catalog.pg_shadow
    WHERE usename = p_usename;
END;
$$;


ALTER FUNCTION pgbouncer.get_auth(p_usename text) OWNER TO postgres;

--
-- Name: delete_claim(uuid, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.delete_claim(uid uuid, claim text) RETURNS text
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
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


ALTER FUNCTION public.delete_claim(uid uuid, claim text) OWNER TO postgres;

--
-- Name: get_claim(uuid, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_claim(uid uuid, claim text) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
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


ALTER FUNCTION public.get_claim(uid uuid, claim text) OWNER TO postgres;

--
-- Name: get_claims(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_claims(uid uuid) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
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


ALTER FUNCTION public.get_claims(uid uuid) OWNER TO postgres;

--
-- Name: get_my_claim(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_my_claim(claim text) RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
  	coalesce(nullif(current_setting('request.jwt.claims', true), '')::jsonb -> 'app_metadata' -> claim, null)
$$;


ALTER FUNCTION public.get_my_claim(claim text) OWNER TO postgres;

--
-- Name: get_my_claims(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_my_claims() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
  	coalesce(nullif(current_setting('request.jwt.claims', true), '')::jsonb -> 'app_metadata', '{}'::jsonb)::jsonb
$$;


ALTER FUNCTION public.get_my_claims() OWNER TO postgres;

--
-- Name: handle_auth_user_new(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.handle_auth_user_new() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
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


ALTER FUNCTION public.handle_auth_user_new() OWNER TO postgres;

--
-- Name: handle_fill_created_by(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.handle_fill_created_by() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  NEW.created_by := get_my_claim('profile_id');
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.handle_fill_created_by() OWNER TO postgres;

--
-- Name: handle_fill_updated(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.handle_fill_updated() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  NEW.updated_by := get_my_claim('profile_id');
  NEW.updated_at := NOW();
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.handle_fill_updated() OWNER TO postgres;

--
-- Name: handle_public_profile_new(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.handle_public_profile_new() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
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


ALTER FUNCTION public.handle_public_profile_new() OWNER TO postgres;

--
-- Name: is_claims_admin(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.is_claims_admin() RETURNS boolean
    LANGUAGE plpgsql
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


ALTER FUNCTION public.is_claims_admin() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: authors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.authors (
    id bigint NOT NULL,
    lastname_name_patronymic text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    birth_year bigint,
    death_year bigint,
    approximate_years boolean DEFAULT false NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    birth_town bigint,
    created_by bigint,
    updated_by bigint
);


ALTER TABLE public.authors OWNER TO postgres;

--
-- Name: COLUMN authors.lastname_name_patronymic; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.authors.lastname_name_patronymic IS 'separated by spaces';


--
-- Name: COLUMN authors.birth_town; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.authors.birth_town IS 'town of birth (test description)';


--
-- Name: rls_authors_delete(public.authors); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.rls_authors_delete(record public.authors) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN rls_check_delete_by_created_by(record.created_by);
END;
$$;


ALTER FUNCTION public.rls_authors_delete(record public.authors) OWNER TO postgres;

--
-- Name: rls_authors_edit(public.authors); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.rls_authors_edit(record public.authors) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN rls_check_edit_by_created_by(record.created_by);
END;
$$;


ALTER FUNCTION public.rls_authors_edit(record public.authors) OWNER TO postgres;

--
-- Name: rls_check_delete_by_created_by(bigint, boolean, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.rls_check_delete_by_created_by(created_by bigint, allow_trust boolean DEFAULT true, claim_check character varying DEFAULT 'claim_delete_all_content'::character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN rls_check_edit_by_created_by(created_by, allow_trust, claim_check);
END;
$$;


ALTER FUNCTION public.rls_check_delete_by_created_by(created_by bigint, allow_trust boolean, claim_check character varying) OWNER TO postgres;

--
-- Name: rls_check_edit_by_created_by(bigint, boolean, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.rls_check_edit_by_created_by(created_by bigint, allow_trust boolean DEFAULT true, claim_check character varying DEFAULT 'claim_edit_all_content'::character varying) RETURNS boolean
    LANGUAGE plpgsql
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


ALTER FUNCTION public.rls_check_edit_by_created_by(created_by bigint, allow_trust boolean, claim_check character varying) OWNER TO postgres;

--
-- Name: citations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.citations (
    id bigint NOT NULL,
    english_text text,
    author_id bigint NOT NULL,
    year bigint,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    original_language_text text,
    place_id bigint,
    event_id bigint,
    created_by bigint,
    updated_by bigint
);


ALTER TABLE public.citations OWNER TO postgres;

--
-- Name: rls_citations_delete(public.citations); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.rls_citations_delete(record public.citations) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN rls_check_delete_by_created_by(record.created_by);
END;
$$;


ALTER FUNCTION public.rls_citations_delete(record public.citations) OWNER TO postgres;

--
-- Name: rls_citations_edit(public.citations); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.rls_citations_edit(record public.citations) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN rls_check_edit_by_created_by(record.created_by);
END;
$$;


ALTER FUNCTION public.rls_citations_edit(record public.citations) OWNER TO postgres;

--
-- Name: countries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.countries (
    id bigint NOT NULL,
    name text DEFAULT ''::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now(),
    found_year bigint,
    next_rename_year bigint,
    created_by bigint,
    updated_by bigint,
    CONSTRAINT countries_name_check CHECK ((length(name) > 0))
);


ALTER TABLE public.countries OWNER TO postgres;

--
-- Name: COLUMN countries.found_year; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.countries.found_year IS 'minimum found year';


--
-- Name: COLUMN countries.next_rename_year; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.countries.next_rename_year IS 'maximum next rename year';


--
-- Name: rls_countries_delete(public.countries); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.rls_countries_delete(record public.countries) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN rls_check_delete_by_created_by(record.created_by);
END;
$$;


ALTER FUNCTION public.rls_countries_delete(record public.countries) OWNER TO postgres;

--
-- Name: rls_countries_edit(public.countries); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.rls_countries_edit(record public.countries) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN rls_check_edit_by_created_by(record.created_by);
END;
$$;


ALTER FUNCTION public.rls_countries_edit(record public.countries) OWNER TO postgres;

--
-- Name: events; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.events (
    id bigint NOT NULL,
    name text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    start_year bigint NOT NULL,
    start_month smallint NOT NULL,
    end_year bigint,
    end_month smallint,
    place_id bigint,
    created_by bigint,
    updated_by bigint
);


ALTER TABLE public.events OWNER TO postgres;

--
-- Name: rls_events_delete(public.events); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.rls_events_delete(record public.events) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN rls_check_delete_by_created_by(record.created_by);
END;
$$;


ALTER FUNCTION public.rls_events_delete(record public.events) OWNER TO postgres;

--
-- Name: rls_events_edit(public.events); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.rls_events_edit(record public.events) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN rls_check_edit_by_created_by(record.created_by);
END;
$$;


ALTER FUNCTION public.rls_events_edit(record public.events) OWNER TO postgres;

--
-- Name: places; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.places (
    id bigint NOT NULL,
    name text DEFAULT 'in'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    town_id bigint NOT NULL,
    created_by bigint,
    updated_by bigint
);


ALTER TABLE public.places OWNER TO postgres;

--
-- Name: rls_places_delete(public.places); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.rls_places_delete(record public.places) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN rls_check_delete_by_created_by(record.created_by);
END;
$$;


ALTER FUNCTION public.rls_places_delete(record public.places) OWNER TO postgres;

--
-- Name: rls_places_edit(public.places); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.rls_places_edit(record public.places) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN rls_check_edit_by_created_by(record.created_by);
END;
$$;


ALTER FUNCTION public.rls_places_edit(record public.places) OWNER TO postgres;

--
-- Name: profiles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.profiles (
    auth_user_id uuid NOT NULL,
    updated_at timestamp with time zone,
    username text,
    full_name text,
    avatar_url text,
    website text,
    id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT username_length CHECK ((char_length(username) >= 3))
);


ALTER TABLE public.profiles OWNER TO postgres;

--
-- Name: rls_profiles_edit(public.profiles[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.rls_profiles_edit(records public.profiles[]) RETURNS boolean
    LANGUAGE plpgsql
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


ALTER FUNCTION public.rls_profiles_edit(records public.profiles[]) OWNER TO postgres;

--
-- Name: rls_profiles_edit(public.profiles); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.rls_profiles_edit(record public.profiles) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    RAISE LOG 'rls_profiles_edit: profile %', record.id;
    RETURN auth.uid() = record.auth_user_id;
END;
$$;


ALTER FUNCTION public.rls_profiles_edit(record public.profiles) OWNER TO postgres;

--
-- Name: towns; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.towns (
    id bigint NOT NULL,
    name text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    country_id bigint NOT NULL,
    created_by bigint,
    updated_by bigint,
    CONSTRAINT towns_name_check CHECK ((length(name) > 0))
);


ALTER TABLE public.towns OWNER TO postgres;

--
-- Name: rls_towns_delete(public.towns); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.rls_towns_delete(record public.towns) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN rls_check_delete_by_created_by(record.created_by);
END;
$$;


ALTER FUNCTION public.rls_towns_delete(record public.towns) OWNER TO postgres;

--
-- Name: rls_towns_edit(public.towns); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.rls_towns_edit(record public.towns) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN rls_check_edit_by_created_by(record.created_by);
END;
$$;


ALTER FUNCTION public.rls_towns_edit(record public.towns) OWNER TO postgres;

--
-- Name: set_claim(uuid, text, jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.set_claim(uid uuid, claim text, value jsonb) RETURNS text
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
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


ALTER FUNCTION public.set_claim(uid uuid, claim text, value jsonb) OWNER TO postgres;

--
-- Name: temporary_fn(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.temporary_fn() RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
  RAISE LOG 'This is an informational message';
  RETURN TRUE;
END;
$$;


ALTER FUNCTION public.temporary_fn() OWNER TO postgres;

--
-- Name: can_insert_object(text, text, uuid, jsonb); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO "storage"."objects" ("bucket_id", "name", "owner", "metadata") VALUES (bucketid, name, owner, metadata);
  -- hack to rollback the successful insert
  RAISE sqlstate 'PT200' using
  message = 'ROLLBACK',
  detail = 'rollback successful insert';
END
$$;


ALTER FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) OWNER TO supabase_storage_admin;

--
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
_filename text;
BEGIN
    select string_to_array(name, '/') into _parts;
    select _parts[array_length(_parts,1)] into _filename;
    -- @todo return the last part instead of 2
    return split_part(_filename, '.', 2);
END
$$;


ALTER FUNCTION storage.extension(name text) OWNER TO supabase_storage_admin;

--
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
    select string_to_array(name, '/') into _parts;
    return _parts[array_length(_parts,1)];
END
$$;


ALTER FUNCTION storage.filename(name text) OWNER TO supabase_storage_admin;

--
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
    select string_to_array(name, '/') into _parts;
    return _parts[1:array_length(_parts,1)-1];
END
$$;


ALTER FUNCTION storage.foldername(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query
        select sum((metadata->>'size')::int) as size, obj.bucket_id
        from "storage".objects as obj
        group by obj.bucket_id;
END
$$;


ALTER FUNCTION storage.get_size_by_bucket() OWNER TO supabase_storage_admin;

--
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
declare
  v_order_by text;
  v_sort_order text;
begin
  case
    when sortcolumn = 'name' then
      v_order_by = 'name';
    when sortcolumn = 'updated_at' then
      v_order_by = 'updated_at';
    when sortcolumn = 'created_at' then
      v_order_by = 'created_at';
    when sortcolumn = 'last_accessed_at' then
      v_order_by = 'last_accessed_at';
    else
      v_order_by = 'name';
  end case;

  case
    when sortorder = 'asc' then
      v_sort_order = 'asc';
    when sortorder = 'desc' then
      v_sort_order = 'desc';
    else
      v_sort_order = 'asc';
  end case;

  v_order_by = v_order_by || ' ' || v_sort_order;

  return query execute
    'with folders as (
       select path_tokens[$1] as folder
       from storage.objects
         where objects.name ilike $2 || $3 || ''%''
           and bucket_id = $4
           and array_length(regexp_split_to_array(objects.name, ''/''), 1) <> $1
       group by folder
       order by folder ' || v_sort_order || '
     )
     (select folder as "name",
            null as id,
            null as updated_at,
            null as created_at,
            null as last_accessed_at,
            null as metadata from folders)
     union all
     (select path_tokens[$1] as "name",
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
     from storage.objects
     where objects.name ilike $2 || $3 || ''%''
       and bucket_id = $4
       and array_length(regexp_split_to_array(objects.name, ''/''), 1) = $1
     order by ' || v_order_by || ')
     limit $5
     offset $6' using levels, prefix, search, bucketname, limits, offsets;
end;
$_$;


ALTER FUNCTION storage.search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) OWNER TO supabase_storage_admin;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


ALTER FUNCTION storage.update_updated_at_column() OWNER TO supabase_storage_admin;

--
-- Name: secrets_encrypt_secret_secret(); Type: FUNCTION; Schema: vault; Owner: supabase_admin
--

CREATE FUNCTION vault.secrets_encrypt_secret_secret() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
		BEGIN
		        new.secret = CASE WHEN new.secret IS NULL THEN NULL ELSE
			CASE WHEN new.key_id IS NULL THEN NULL ELSE pg_catalog.encode(
			  pgsodium.crypto_aead_det_encrypt(
				pg_catalog.convert_to(new.secret, 'utf8'),
				pg_catalog.convert_to((new.id::text || new.description::text || new.created_at::text || new.updated_at::text)::text, 'utf8'),
				new.key_id::uuid,
				new.nonce
			  ),
				'base64') END END;
		RETURN new;
		END;
		$$;


ALTER FUNCTION vault.secrets_encrypt_secret_secret() OWNER TO supabase_admin;

--
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone,
    ip_address character varying(64) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE auth.audit_log_entries OWNER TO supabase_auth_admin;

--
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- Name: flow_state; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.flow_state (
    id uuid NOT NULL,
    user_id uuid,
    auth_code text NOT NULL,
    code_challenge_method auth.code_challenge_method NOT NULL,
    code_challenge text NOT NULL,
    provider_type text NOT NULL,
    provider_access_token text,
    provider_refresh_token text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    authentication_method text NOT NULL
);


ALTER TABLE auth.flow_state OWNER TO supabase_auth_admin;

--
-- Name: TABLE flow_state; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.flow_state IS 'stores metadata for pkce logins';


--
-- Name: identities; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.identities (
    provider_id text NOT NULL,
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text NOT NULL,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    email text GENERATED ALWAYS AS (lower((identity_data ->> 'email'::text))) STORED,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE auth.identities OWNER TO supabase_auth_admin;

--
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- Name: instances; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE auth.instances OWNER TO supabase_auth_admin;

--
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- Name: mfa_amr_claims; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_amr_claims (
    session_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authentication_method text NOT NULL,
    id uuid NOT NULL
);


ALTER TABLE auth.mfa_amr_claims OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- Name: mfa_challenges; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_challenges (
    id uuid NOT NULL,
    factor_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    verified_at timestamp with time zone,
    ip_address inet NOT NULL
);


ALTER TABLE auth.mfa_challenges OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- Name: mfa_factors; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_factors (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    friendly_name text,
    factor_type auth.factor_type NOT NULL,
    status auth.factor_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    secret text
);


ALTER TABLE auth.mfa_factors OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.refresh_tokens (
    instance_id uuid,
    id bigint NOT NULL,
    token character varying(255),
    user_id character varying(255),
    revoked boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    parent character varying(255),
    session_id uuid
);


ALTER TABLE auth.refresh_tokens OWNER TO supabase_auth_admin;

--
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: supabase_auth_admin
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE auth.refresh_tokens_id_seq OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: supabase_auth_admin
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- Name: saml_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_providers (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    entity_id text NOT NULL,
    metadata_xml text NOT NULL,
    metadata_url text,
    attribute_mapping jsonb,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "entity_id not empty" CHECK ((char_length(entity_id) > 0)),
    CONSTRAINT "metadata_url not empty" CHECK (((metadata_url = NULL::text) OR (char_length(metadata_url) > 0))),
    CONSTRAINT "metadata_xml not empty" CHECK ((char_length(metadata_xml) > 0))
);


ALTER TABLE auth.saml_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- Name: saml_relay_states; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_relay_states (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    request_id text NOT NULL,
    for_email text,
    redirect_to text,
    from_ip_address inet,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    flow_state_id uuid,
    CONSTRAINT "request_id not empty" CHECK ((char_length(request_id) > 0))
);


ALTER TABLE auth.saml_relay_states OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE auth.schema_migrations OWNER TO supabase_auth_admin;

--
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- Name: sessions; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    factor_id uuid,
    aal auth.aal_level,
    not_after timestamp with time zone,
    refreshed_at timestamp without time zone,
    user_agent text,
    ip inet,
    tag text
);


ALTER TABLE auth.sessions OWNER TO supabase_auth_admin;

--
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- Name: sso_domains; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_domains (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    domain text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "domain not empty" CHECK ((char_length(domain) > 0))
);


ALTER TABLE auth.sso_domains OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- Name: sso_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_providers (
    id uuid NOT NULL,
    resource_id text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "resource_id not empty" CHECK (((resource_id = NULL::text) OR (char_length(resource_id) > 0)))
);


ALTER TABLE auth.sso_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- Name: users; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.users (
    instance_id uuid,
    id uuid NOT NULL,
    aud character varying(255),
    role character varying(255),
    email character varying(255),
    encrypted_password character varying(255),
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying(255),
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying(255),
    email_change character varying(255),
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone text DEFAULT NULL::character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change text DEFAULT ''::character varying,
    phone_change_token character varying(255) DEFAULT ''::character varying,
    phone_change_sent_at timestamp with time zone,
    confirmed_at timestamp with time zone GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
    email_change_token_current character varying(255) DEFAULT ''::character varying,
    email_change_confirm_status smallint DEFAULT 0,
    banned_until timestamp with time zone,
    reauthentication_token character varying(255) DEFAULT ''::character varying,
    reauthentication_sent_at timestamp with time zone,
    is_sso_user boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT users_email_change_confirm_status_check CHECK (((email_change_confirm_status >= 0) AND (email_change_confirm_status <= 2)))
);


ALTER TABLE auth.users OWNER TO supabase_auth_admin;

--
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- Name: author_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.authors ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.author_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: citations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.citations ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.citations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: country_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.countries ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.country_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: event_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.events ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.event_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: place_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.places ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.place_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.profiles ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: rls_edit_for_table; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.rls_edit_for_table AS
 SELECT 'profiles'::text AS table_name,
    profiles.id,
    public.rls_profiles_edit(profiles.*) AS editable,
    false AS deletable
   FROM public.profiles
UNION
 SELECT 'countries'::text AS table_name,
    countries.id,
    public.rls_countries_edit(countries.*) AS editable,
    public.rls_countries_delete(countries.*) AS deletable
   FROM public.countries
UNION
 SELECT 'towns'::text AS table_name,
    towns.id,
    public.rls_towns_edit(towns.*) AS editable,
    public.rls_towns_delete(towns.*) AS deletable
   FROM public.towns;


ALTER VIEW public.rls_edit_for_table OWNER TO postgres;

--
-- Name: town_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.towns ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.town_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: trusts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trusts (
    id bigint NOT NULL,
    who bigint NOT NULL,
    trusts_whom bigint NOT NULL,
    end_at timestamp with time zone DEFAULT (now() + '1 day'::interval) NOT NULL
);


ALTER TABLE public.trusts OWNER TO postgres;

--
-- Name: trusts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.trusts ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.trusts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: buckets; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false,
    avif_autodetection boolean DEFAULT false,
    file_size_limit bigint,
    allowed_mime_types text[],
    owner_id text
);


ALTER TABLE storage.buckets OWNER TO supabase_storage_admin;

--
-- Name: COLUMN buckets.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: migrations; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE storage.migrations OWNER TO supabase_storage_admin;

--
-- Name: objects; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.objects (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED,
    version text,
    owner_id text
);


ALTER TABLE storage.objects OWNER TO supabase_storage_admin;

--
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: schema_migrations; Type: TABLE; Schema: supabase_migrations; Owner: postgres
--

CREATE TABLE supabase_migrations.schema_migrations (
    version text NOT NULL,
    statements text[],
    name text
);


ALTER TABLE supabase_migrations.schema_migrations OWNER TO postgres;

--
-- Name: decrypted_secrets; Type: VIEW; Schema: vault; Owner: supabase_admin
--

CREATE VIEW vault.decrypted_secrets AS
 SELECT secrets.id,
    secrets.name,
    secrets.description,
    secrets.secret,
        CASE
            WHEN (secrets.secret IS NULL) THEN NULL::text
            ELSE
            CASE
                WHEN (secrets.key_id IS NULL) THEN NULL::text
                ELSE convert_from(pgsodium.crypto_aead_det_decrypt(decode(secrets.secret, 'base64'::text), convert_to(((((secrets.id)::text || secrets.description) || (secrets.created_at)::text) || (secrets.updated_at)::text), 'utf8'::name), secrets.key_id, secrets.nonce), 'utf8'::name)
            END
        END AS decrypted_secret,
    secrets.key_id,
    secrets.nonce,
    secrets.created_at,
    secrets.updated_at
   FROM vault.secrets;


ALTER VIEW vault.decrypted_secrets OWNER TO supabase_admin;

--
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.flow_state (id, user_id, auth_code, code_challenge_method, code_challenge, provider_type, provider_access_token, provider_refresh_token, created_at, updated_at, authentication_method) FROM stdin;
1f34cdf7-e7f0-4970-b263-19eb162bd846	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	74d7e329-90c8-4d0b-b2d6-b75ecbd9cd57	s256	OnWj5HXsonAXWE8-k2YDItq11wbqjXrtFJej8NkAO1g	email			2023-11-30 13:19:57.233808+00	2023-11-30 13:19:57.233808+00	email/signup
\.


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.identities (provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at, id) FROM stdin;
b5f563a3-b794-49d0-a0e3-dbf9fffd2321	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	{"sub": "b5f563a3-b794-49d0-a0e3-dbf9fffd2321", "email": "d9k@ya.ru", "email_verified": false, "phone_verified": false}	email	2023-11-30 13:19:57.231649+00	2023-11-30 13:19:57.231688+00	2023-11-30 13:19:57.231688+00	ef9a09b6-d37c-4ba9-a4d4-0682d78af774
727a5d27-4b66-49ea-a2c1-0bccc7b8e2cd	727a5d27-4b66-49ea-a2c1-0bccc7b8e2cd	{"sub": "727a5d27-4b66-49ea-a2c1-0bccc7b8e2cd", "email": "d9k@ya.tu", "email_verified": false, "phone_verified": false}	email	2023-12-11 20:49:26.154423+00	2023-12-11 20:49:26.154477+00	2023-12-11 20:49:26.154477+00	c8974ccd-72ab-40e3-ac96-5997a55d45e5
ccdcd9a1-2df3-4cdf-8298-a37cd209dd0d	ccdcd9a1-2df3-4cdf-8298-a37cd209dd0d	{"sub": "ccdcd9a1-2df3-4cdf-8298-a37cd209dd0d", "email": "d9kd9k@gmail.com", "email_verified": false, "phone_verified": false}	email	2023-12-21 13:53:06.017681+00	2023-12-21 13:53:06.017732+00	2023-12-21 13:53:06.017732+00	a75bc2d3-6e20-4b67-b0b7-3fbc3154de60
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.instances (id, uuid, raw_base_config, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_challenges (id, factor_id, created_at, verified_at, ip_address) FROM stdin;
\.


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_factors (id, user_id, friendly_name, factor_type, status, created_at, updated_at, secret) FROM stdin;
\.


--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_providers (id, sso_provider_id, entity_id, metadata_xml, metadata_url, attribute_mapping, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_relay_states (id, sso_provider_id, request_id, for_email, redirect_to, from_ip_address, created_at, updated_at, flow_state_id) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.schema_migrations (version) FROM stdin;
20171026211738
20171026211808
20171026211834
20180103212743
20180108183307
20180119214651
20180125194653
00
20210710035447
20210722035447
20210730183235
20210909172000
20210927181326
20211122151130
20211124214934
20211202183645
20220114185221
20220114185340
20220224000811
20220323170000
20220429102000
20220531120530
20220614074223
20220811173540
20221003041349
20221003041400
20221011041400
20221020193600
20221021073300
20221021082433
20221027105023
20221114143122
20221114143410
20221125140132
20221208132122
20221215195500
20221215195800
20221215195900
20230116124310
20230116124412
20230131181311
20230322519590
20230402418590
20230411005111
20230508135423
20230523124323
20230818113222
20230914180801
20231027141322
20231114161723
20231117164230
\.


--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_domains (id, sso_provider_id, domain, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_providers (id, resource_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at) FROM stdin;
00000000-0000-0000-0000-000000000000	e76b244b-6f9e-42fc-b216-5ea74f94bd4c	authenticated	authenticated	gavriillarin263@inbox.lv	$2a$10$W8/g0R7arxlSsdWrn.5hXOqbolOsyQrpCcAKTOEkoIy2Vekr3vgSS	2023-12-09 05:25:02.817+00	\N		2023-12-09 05:24:14.076+00		2023-12-24 13:21:13.896693+00			\N	2023-12-24 13:21:25.863108+00	{"provider": "email", "providers": ["email"], "profile_id": 19}	\N	\N	2023-12-09 05:24:14.065+00	2023-12-24 23:26:51.847117+00	\N	\N			\N		0	\N		\N	f	\N
00000000-0000-0000-0000-000000000000	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	authenticated	authenticated	d9k@ya.ru	$2a$10$BNL19FnvkC6EyYVshokk.e1R3HwylfiHqAp/PEtQY49PgNHxf0Nk2	2023-11-30 13:20:52.160287+00	\N		2023-11-30 13:19:57.235919+00		2023-12-24 23:21:28.93605+00			\N	2023-12-24 23:21:40.11827+00	{"provider": "email", "providers": ["email"], "profile_id": 1}	{}	\N	2023-11-30 13:19:57.22183+00	2023-12-24 23:48:47.458928+00	\N	\N			\N		0	\N		\N	f	\N
00000000-0000-0000-0000-000000000000	ccdcd9a1-2df3-4cdf-8298-a37cd209dd0d	authenticated	authenticated	d9kd9k@gmail.com	$2a$10$Nn9Lq26n.a2r92jcs25UI./rgH5OBb1gV6db5GhX.phqVA//i/Lmy	2023-12-21 14:03:46.059171+00	\N		2023-12-21 13:53:06.021026+00		2023-12-24 23:31:21.017153+00			\N	2023-12-24 23:31:41.685951+00	{"provider": "email", "providers": ["email"], "profile_id": 21, "claim_edit_all_content": 1}	{}	\N	2023-12-21 13:53:06.009726+00	2023-12-24 23:58:36.937126+00	\N	\N			\N		0	\N		\N	f	\N
00000000-0000-0000-0000-000000000000	727a5d27-4b66-49ea-a2c1-0bccc7b8e2cd	authenticated	authenticated	d9k@ya.tu	$2a$10$OR4GYiMa8vFpk1ywBfPrEeL8yj0TCJxO3joYXdlRezx8Kk6eBjmQ.	\N	\N	45bc98dfe84800707f48a82df0ce417215a7869ba20ba657b46012c1	2023-12-11 20:49:26.158057+00		\N			\N	\N	{"provider": "email", "providers": ["email"], "profile_id": 20}	{}	\N	2023-12-11 20:49:26.145323+00	2023-12-11 20:49:29.413083+00	\N	\N			\N		0	\N		\N	f	\N
\.


--
-- Data for Name: key; Type: TABLE DATA; Schema: pgsodium; Owner: supabase_admin
--

COPY pgsodium.key (id, status, created, expires, key_type, key_id, key_context, name, associated_data, raw_key, raw_key_nonce, parent_key, comment, user_data) FROM stdin;
\.


--
-- Data for Name: authors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.authors (id, lastname_name_patronymic, created_at, birth_year, death_year, approximate_years, updated_at, birth_town, created_by, updated_by) FROM stdin;
\.


--
-- Data for Name: citations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.citations (id, english_text, author_id, year, created_at, updated_at, original_language_text, place_id, event_id, created_by, updated_by) FROM stdin;
\.


--
-- Data for Name: countries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.countries (id, name, created_at, updated_at, found_year, next_rename_year, created_by, updated_by) FROM stdin;
1	Greece 1	2023-11-28 06:50:37.146622+00	2023-11-28 06:50:37.146622+00	-4000	100	\N	\N
8	Greece	2023-12-21 10:00:36.790762+00	2023-12-21 10:00:36.790762+00	\N	\N	1	\N
10	Russia	2023-12-21 10:02:21.791404+00	2023-12-21 10:02:21.791404+00	\N	\N	1	\N
11	China 10	2023-12-21 14:12:45.779946+00	2023-12-21 14:14:11.220697+00	\N	\N	21	1
12	India	2023-12-24 13:21:46.821053+00	2023-12-24 13:21:46.821053+00	\N	\N	19	\N
7	Arztocka	2023-12-20 15:31:38.442098+00	2023-12-24 23:44:15.988928+00	\N	\N	1	1
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.events (id, name, created_at, updated_at, start_year, start_month, end_year, end_month, place_id, created_by, updated_by) FROM stdin;
\.


--
-- Data for Name: places; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.places (id, name, created_at, updated_at, town_id, created_by, updated_by) FROM stdin;
\.


--
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.profiles (auth_user_id, updated_at, username, full_name, avatar_url, website, id, created_at) FROM stdin;
e76b244b-6f9e-42fc-b216-5ea74f94bd4c	\N	gavriillarin263	\N	\N	\N	19	2023-12-24 19:26:15.651828+00
b5f563a3-b794-49d0-a0e3-dbf9fffd2321	\N	d9k	y66y6y6767	\N	\N	1	2023-12-24 19:26:15.651828+00
ccdcd9a1-2df3-4cdf-8298-a37cd209dd0d	\N	d9kd9k	\N	\N	\N	21	2023-12-24 19:26:15.651828+00
727a5d27-4b66-49ea-a2c1-0bccc7b8e2cd	\N	____1	\N	\N	\N	20	2023-12-24 19:26:15.651828+00
\.


--
-- Data for Name: towns; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.towns (id, name, created_at, updated_at, country_id, created_by, updated_by) FROM stdin;
8	Moscow	2023-12-24 23:14:18.601477+00	2023-12-24 23:53:06.468419+00	10	\N	21
10	Lipetsk	2023-12-24 23:36:11.73928+00	2023-12-24 23:53:13.291223+00	10	1	21
\.


--
-- Data for Name: trusts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.trusts (id, who, trusts_whom, end_at) FROM stdin;
2	21	1	2023-12-25 03:43:44.908317+00
\.


--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets (id, name, owner, created_at, updated_at, public, avif_autodetection, file_size_limit, allowed_mime_types, owner_id) FROM stdin;
avatars	avatars	\N	2023-11-29 11:39:09.672841+00	2023-11-29 11:39:09.672841+00	f	f	\N	\N	\N
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.migrations (id, name, hash, executed_at) FROM stdin;
0	create-migrations-table	e18db593bcde2aca2a408c4d1100f6abba2195df	2023-09-30 14:57:55.230971
1	initialmigration	6ab16121fbaa08bbd11b712d05f358f9b555d777	2023-09-30 14:57:55.233989
2	pathtoken-column	49756be03be4c17bb85fe70d4a861f27de7e49ad	2023-09-30 14:57:55.235646
3	add-migrations-rls	bb5d124c53d68635a883e399426c6a5a25fc893d	2023-09-30 14:57:55.25644
4	add-size-functions	6d79007d04f5acd288c9c250c42d2d5fd286c54d	2023-09-30 14:57:55.264052
5	change-column-name-in-get-size	fd65688505d2ffa9fbdc58a944348dd8604d688c	2023-09-30 14:57:55.266722
6	add-rls-to-buckets	63e2bab75a2040fee8e3fb3f15a0d26f3380e9b6	2023-09-30 14:57:55.269521
7	add-public-to-buckets	82568934f8a4d9e0a85f126f6fb483ad8214c418	2023-09-30 14:57:55.271418
8	fix-search-function	1a43a40eddb525f2e2f26efd709e6c06e58e059c	2023-09-30 14:57:55.27366
9	search-files-search-function	34c096597eb8b9d077fdfdde9878c88501b2fafc	2023-09-30 14:57:55.27584
10	add-trigger-to-auto-update-updated_at-column	37d6bb964a70a822e6d37f22f457b9bca7885928	2023-09-30 14:57:55.280227
11	add-automatic-avif-detection-flag	bd76c53a9c564c80d98d119c1b3a28e16c8152db	2023-09-30 14:57:55.282798
12	add-bucket-custom-limits	cbe0a4c32a0e891554a21020433b7a4423c07ee7	2023-09-30 14:57:55.284853
13	use-bytes-for-max-size	7a158ebce8a0c2801c9c65b7e9b2f98f68b3874e	2023-09-30 14:57:55.287117
14	add-can-insert-object-function	273193826bca7e0990b458d1ba72f8aa27c0d825	2023-09-30 14:57:55.298843
15	add-version	e821a779d26612899b8c2dfe20245f904a327c4f	2023-09-30 14:57:55.301151
16	drop-owner-foreign-key	536b33f8878eed09d0144219777dcac96bdb25da	2023-11-27 23:24:15.501288
17	add_owner_id_column_deprecate_owner	7545f216a39358b5487df75d941d05dbcd75eb46	2023-11-27 23:24:15.507358
\.


--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata, version, owner_id) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: supabase_migrations; Owner: postgres
--

COPY supabase_migrations.schema_migrations (version, statements, name) FROM stdin;
20231129030618	{"SET statement_timeout = 0","SET lock_timeout = 0","SET idle_in_transaction_session_timeout = 0","SET client_encoding = 'UTF8'","SET standard_conforming_strings = on","SELECT pg_catalog.set_config('search_path', '', false)","SET check_function_bodies = false","SET xmloption = content","SET client_min_messages = warning","SET row_security = off","CREATE EXTENSION IF NOT EXISTS \\"pgsodium\\" WITH SCHEMA \\"pgsodium\\"","CREATE EXTENSION IF NOT EXISTS \\"pg_graphql\\" WITH SCHEMA \\"graphql\\"","CREATE EXTENSION IF NOT EXISTS \\"pg_stat_statements\\" WITH SCHEMA \\"extensions\\"","CREATE EXTENSION IF NOT EXISTS \\"pgcrypto\\" WITH SCHEMA \\"extensions\\"","CREATE EXTENSION IF NOT EXISTS \\"pgjwt\\" WITH SCHEMA \\"extensions\\"","CREATE EXTENSION IF NOT EXISTS \\"supabase_vault\\" WITH SCHEMA \\"vault\\"","CREATE EXTENSION IF NOT EXISTS \\"uuid-ossp\\" WITH SCHEMA \\"extensions\\"","SET default_tablespace = ''","SET default_table_access_method = \\"heap\\"","CREATE TABLE IF NOT EXISTS \\"public\\".\\"authors\\" (\n    \\"id\\" bigint NOT NULL,\n    \\"lastname_name_patronymic\\" \\"text\\" NOT NULL,\n    \\"created_at\\" timestamp with time zone DEFAULT \\"now\\"() NOT NULL,\n    \\"birth_year\\" bigint,\n    \\"death_year\\" bigint,\n    \\"approximate_years\\" boolean DEFAULT false NOT NULL,\n    \\"updated_at\\" timestamp with time zone DEFAULT \\"now\\"() NOT NULL\n)","ALTER TABLE \\"public\\".\\"authors\\" OWNER TO \\"postgres\\"","ALTER TABLE \\"public\\".\\"authors\\" ALTER COLUMN \\"id\\" ADD GENERATED BY DEFAULT AS IDENTITY (\n    SEQUENCE NAME \\"public\\".\\"author_id_seq\\"\n    START WITH 1\n    INCREMENT BY 1\n    NO MINVALUE\n    NO MAXVALUE\n    CACHE 1\n)","CREATE TABLE IF NOT EXISTS \\"public\\".\\"citations\\" (\n    \\"id\\" bigint NOT NULL,\n    \\"english_text\\" \\"text\\",\n    \\"author_id\\" bigint NOT NULL,\n    \\"year\\" bigint,\n    \\"created_at\\" timestamp with time zone DEFAULT \\"now\\"() NOT NULL,\n    \\"updated_at\\" timestamp without time zone DEFAULT \\"now\\"() NOT NULL,\n    \\"original_language_text\\" \\"text\\"\n)","ALTER TABLE \\"public\\".\\"citations\\" OWNER TO \\"postgres\\"","ALTER TABLE \\"public\\".\\"citations\\" ALTER COLUMN \\"id\\" ADD GENERATED BY DEFAULT AS IDENTITY (\n    SEQUENCE NAME \\"public\\".\\"citations_id_seq\\"\n    START WITH 1\n    INCREMENT BY 1\n    NO MINVALUE\n    NO MAXVALUE\n    CACHE 1\n)","CREATE TABLE IF NOT EXISTS \\"public\\".\\"country\\" (\n    \\"id\\" bigint NOT NULL,\n    \\"name\\" \\"text\\",\n    \\"created_at\\" timestamp with time zone DEFAULT \\"now\\"() NOT NULL,\n    \\"updated_at\\" timestamp with time zone DEFAULT \\"now\\"(),\n    \\"found_year\\" bigint,\n    \\"next_rename_year\\" bigint\n)","ALTER TABLE \\"public\\".\\"country\\" OWNER TO \\"postgres\\"","ALTER TABLE \\"public\\".\\"country\\" ALTER COLUMN \\"id\\" ADD GENERATED BY DEFAULT AS IDENTITY (\n    SEQUENCE NAME \\"public\\".\\"country_id_seq\\"\n    START WITH 1\n    INCREMENT BY 1\n    NO MINVALUE\n    NO MAXVALUE\n    CACHE 1\n)","CREATE TABLE IF NOT EXISTS \\"public\\".\\"place\\" (\n    \\"id\\" bigint NOT NULL,\n    \\"name\\" \\"text\\" DEFAULT 'in'::\\"text\\" NOT NULL,\n    \\"created_at\\" timestamp with time zone DEFAULT \\"now\\"() NOT NULL,\n    \\"updated_at\\" timestamp with time zone DEFAULT \\"now\\"() NOT NULL\n)","ALTER TABLE \\"public\\".\\"place\\" OWNER TO \\"postgres\\"","ALTER TABLE \\"public\\".\\"place\\" ALTER COLUMN \\"id\\" ADD GENERATED BY DEFAULT AS IDENTITY (\n    SEQUENCE NAME \\"public\\".\\"place_id_seq\\"\n    START WITH 1\n    INCREMENT BY 1\n    NO MINVALUE\n    NO MAXVALUE\n    CACHE 1\n)","CREATE TABLE IF NOT EXISTS \\"public\\".\\"province\\" (\n    \\"id\\" bigint NOT NULL,\n    \\"name\\" \\"text\\" NOT NULL,\n    \\"country_id\\" bigint NOT NULL,\n    \\"created_at\\" timestamp with time zone DEFAULT \\"now\\"() NOT NULL,\n    \\"updated_at\\" timestamp with time zone DEFAULT \\"now\\"() NOT NULL\n)","ALTER TABLE \\"public\\".\\"province\\" OWNER TO \\"postgres\\"","ALTER TABLE \\"public\\".\\"province\\" ALTER COLUMN \\"id\\" ADD GENERATED BY DEFAULT AS IDENTITY (\n    SEQUENCE NAME \\"public\\".\\"province_id_seq\\"\n    START WITH 1\n    INCREMENT BY 1\n    NO MINVALUE\n    NO MAXVALUE\n    CACHE 1\n)","CREATE TABLE IF NOT EXISTS \\"public\\".\\"town\\" (\n    \\"id\\" bigint NOT NULL,\n    \\"name\\" \\"text\\" NOT NULL,\n    \\"province_id\\" bigint NOT NULL,\n    \\"created_at\\" timestamp with time zone DEFAULT \\"now\\"() NOT NULL,\n    \\"updated_at\\" timestamp with time zone DEFAULT \\"now\\"() NOT NULL\n)","ALTER TABLE \\"public\\".\\"town\\" OWNER TO \\"postgres\\"","ALTER TABLE \\"public\\".\\"town\\" ALTER COLUMN \\"id\\" ADD GENERATED BY DEFAULT AS IDENTITY (\n    SEQUENCE NAME \\"public\\".\\"town_id_seq\\"\n    START WITH 1\n    INCREMENT BY 1\n    NO MINVALUE\n    NO MAXVALUE\n    CACHE 1\n)","ALTER TABLE ONLY \\"public\\".\\"authors\\"\n    ADD CONSTRAINT \\"author_pkey\\" PRIMARY KEY (\\"id\\")","ALTER TABLE ONLY \\"public\\".\\"citations\\"\n    ADD CONSTRAINT \\"citations_pkey\\" PRIMARY KEY (\\"id\\")","ALTER TABLE ONLY \\"public\\".\\"country\\"\n    ADD CONSTRAINT \\"country_pkey\\" PRIMARY KEY (\\"id\\")","ALTER TABLE ONLY \\"public\\".\\"place\\"\n    ADD CONSTRAINT \\"place_pkey\\" PRIMARY KEY (\\"id\\")","ALTER TABLE ONLY \\"public\\".\\"province\\"\n    ADD CONSTRAINT \\"province_pkey\\" PRIMARY KEY (\\"id\\")","ALTER TABLE ONLY \\"public\\".\\"town\\"\n    ADD CONSTRAINT \\"town_pkey\\" PRIMARY KEY (\\"id\\")","ALTER TABLE ONLY \\"public\\".\\"citations\\"\n    ADD CONSTRAINT \\"citations_author_id_fkey\\" FOREIGN KEY (\\"author_id\\") REFERENCES \\"public\\".\\"authors\\"(\\"id\\") ON UPDATE CASCADE ON DELETE RESTRICT","ALTER TABLE ONLY \\"public\\".\\"province\\"\n    ADD CONSTRAINT \\"province_country_id_fkey\\" FOREIGN KEY (\\"country_id\\") REFERENCES \\"public\\".\\"country\\"(\\"id\\") ON UPDATE CASCADE ON DELETE RESTRICT","ALTER TABLE ONLY \\"public\\".\\"town\\"\n    ADD CONSTRAINT \\"town_province_id_fkey\\" FOREIGN KEY (\\"province_id\\") REFERENCES \\"public\\".\\"province\\"(\\"id\\") ON UPDATE CASCADE ON DELETE RESTRICT","REVOKE USAGE ON SCHEMA \\"public\\" FROM PUBLIC","GRANT USAGE ON SCHEMA \\"public\\" TO \\"postgres\\"","GRANT USAGE ON SCHEMA \\"public\\" TO \\"anon\\"","GRANT USAGE ON SCHEMA \\"public\\" TO \\"authenticated\\"","GRANT USAGE ON SCHEMA \\"public\\" TO \\"service_role\\"","GRANT ALL ON TABLE \\"public\\".\\"authors\\" TO \\"anon\\"","GRANT ALL ON TABLE \\"public\\".\\"authors\\" TO \\"authenticated\\"","GRANT ALL ON TABLE \\"public\\".\\"authors\\" TO \\"service_role\\"","GRANT ALL ON SEQUENCE \\"public\\".\\"author_id_seq\\" TO \\"anon\\"","GRANT ALL ON SEQUENCE \\"public\\".\\"author_id_seq\\" TO \\"authenticated\\"","GRANT ALL ON SEQUENCE \\"public\\".\\"author_id_seq\\" TO \\"service_role\\"","GRANT ALL ON TABLE \\"public\\".\\"citations\\" TO \\"anon\\"","GRANT ALL ON TABLE \\"public\\".\\"citations\\" TO \\"authenticated\\"","GRANT ALL ON TABLE \\"public\\".\\"citations\\" TO \\"service_role\\"","GRANT ALL ON SEQUENCE \\"public\\".\\"citations_id_seq\\" TO \\"anon\\"","GRANT ALL ON SEQUENCE \\"public\\".\\"citations_id_seq\\" TO \\"authenticated\\"","GRANT ALL ON SEQUENCE \\"public\\".\\"citations_id_seq\\" TO \\"service_role\\"","GRANT ALL ON TABLE \\"public\\".\\"country\\" TO \\"anon\\"","GRANT ALL ON TABLE \\"public\\".\\"country\\" TO \\"authenticated\\"","GRANT ALL ON TABLE \\"public\\".\\"country\\" TO \\"service_role\\"","GRANT ALL ON SEQUENCE \\"public\\".\\"country_id_seq\\" TO \\"anon\\"","GRANT ALL ON SEQUENCE \\"public\\".\\"country_id_seq\\" TO \\"authenticated\\"","GRANT ALL ON SEQUENCE \\"public\\".\\"country_id_seq\\" TO \\"service_role\\"","GRANT ALL ON TABLE \\"public\\".\\"place\\" TO \\"anon\\"","GRANT ALL ON TABLE \\"public\\".\\"place\\" TO \\"authenticated\\"","GRANT ALL ON TABLE \\"public\\".\\"place\\" TO \\"service_role\\"","GRANT ALL ON SEQUENCE \\"public\\".\\"place_id_seq\\" TO \\"anon\\"","GRANT ALL ON SEQUENCE \\"public\\".\\"place_id_seq\\" TO \\"authenticated\\"","GRANT ALL ON SEQUENCE \\"public\\".\\"place_id_seq\\" TO \\"service_role\\"","GRANT ALL ON TABLE \\"public\\".\\"province\\" TO \\"anon\\"","GRANT ALL ON TABLE \\"public\\".\\"province\\" TO \\"authenticated\\"","GRANT ALL ON TABLE \\"public\\".\\"province\\" TO \\"service_role\\"","GRANT ALL ON SEQUENCE \\"public\\".\\"province_id_seq\\" TO \\"anon\\"","GRANT ALL ON SEQUENCE \\"public\\".\\"province_id_seq\\" TO \\"authenticated\\"","GRANT ALL ON SEQUENCE \\"public\\".\\"province_id_seq\\" TO \\"service_role\\"","GRANT ALL ON TABLE \\"public\\".\\"town\\" TO \\"anon\\"","GRANT ALL ON TABLE \\"public\\".\\"town\\" TO \\"authenticated\\"","GRANT ALL ON TABLE \\"public\\".\\"town\\" TO \\"service_role\\"","GRANT ALL ON SEQUENCE \\"public\\".\\"town_id_seq\\" TO \\"anon\\"","GRANT ALL ON SEQUENCE \\"public\\".\\"town_id_seq\\" TO \\"authenticated\\"","GRANT ALL ON SEQUENCE \\"public\\".\\"town_id_seq\\" TO \\"service_role\\"","ALTER DEFAULT PRIVILEGES FOR ROLE \\"postgres\\" IN SCHEMA \\"public\\" GRANT ALL ON SEQUENCES  TO \\"postgres\\"","ALTER DEFAULT PRIVILEGES FOR ROLE \\"postgres\\" IN SCHEMA \\"public\\" GRANT ALL ON SEQUENCES  TO \\"anon\\"","ALTER DEFAULT PRIVILEGES FOR ROLE \\"postgres\\" IN SCHEMA \\"public\\" GRANT ALL ON SEQUENCES  TO \\"authenticated\\"","ALTER DEFAULT PRIVILEGES FOR ROLE \\"postgres\\" IN SCHEMA \\"public\\" GRANT ALL ON SEQUENCES  TO \\"service_role\\"","ALTER DEFAULT PRIVILEGES FOR ROLE \\"postgres\\" IN SCHEMA \\"public\\" GRANT ALL ON FUNCTIONS  TO \\"postgres\\"","ALTER DEFAULT PRIVILEGES FOR ROLE \\"postgres\\" IN SCHEMA \\"public\\" GRANT ALL ON FUNCTIONS  TO \\"anon\\"","ALTER DEFAULT PRIVILEGES FOR ROLE \\"postgres\\" IN SCHEMA \\"public\\" GRANT ALL ON FUNCTIONS  TO \\"authenticated\\"","ALTER DEFAULT PRIVILEGES FOR ROLE \\"postgres\\" IN SCHEMA \\"public\\" GRANT ALL ON FUNCTIONS  TO \\"service_role\\"","ALTER DEFAULT PRIVILEGES FOR ROLE \\"postgres\\" IN SCHEMA \\"public\\" GRANT ALL ON TABLES  TO \\"postgres\\"","ALTER DEFAULT PRIVILEGES FOR ROLE \\"postgres\\" IN SCHEMA \\"public\\" GRANT ALL ON TABLES  TO \\"anon\\"","ALTER DEFAULT PRIVILEGES FOR ROLE \\"postgres\\" IN SCHEMA \\"public\\" GRANT ALL ON TABLES  TO \\"authenticated\\"","ALTER DEFAULT PRIVILEGES FOR ROLE \\"postgres\\" IN SCHEMA \\"public\\" GRANT ALL ON TABLES  TO \\"service_role\\"","RESET ALL"}	remote_schema
20231129093821	{"alter table \\"public\\".\\"province\\" drop constraint \\"province_country_id_fkey\\"","alter table \\"public\\".\\"town\\" drop constraint \\"town_province_id_fkey\\"","alter table \\"public\\".\\"citations\\" drop constraint \\"citations_author_id_fkey\\"","alter table \\"public\\".\\"province\\" drop constraint \\"province_pkey\\"","drop index if exists \\"public\\".\\"province_pkey\\"","drop table \\"public\\".\\"province\\"","create table \\"public\\".\\"event\\" (\n    \\"id\\" bigint generated by default as identity not null,\n    \\"name\\" text not null,\n    \\"created_at\\" timestamp with time zone not null default now(),\n    \\"updated_at\\" timestamp with time zone not null default now(),\n    \\"start_year\\" bigint not null,\n    \\"start_month\\" smallint not null,\n    \\"end_year\\" bigint,\n    \\"end_month\\" smallint,\n    \\"place_id\\" bigint\n)","alter table \\"public\\".\\"authors\\" add column \\"birth_town\\" bigint","alter table \\"public\\".\\"citations\\" add column \\"event_id\\" bigint","alter table \\"public\\".\\"citations\\" add column \\"place_id\\" bigint","alter table \\"public\\".\\"place\\" add column \\"town_id\\" bigint not null","alter table \\"public\\".\\"town\\" drop column \\"province_id\\"","alter table \\"public\\".\\"town\\" add column \\"country_id\\" bigint not null","CREATE UNIQUE INDEX event_pkey ON public.event USING btree (id)","alter table \\"public\\".\\"event\\" add constraint \\"event_pkey\\" PRIMARY KEY using index \\"event_pkey\\"","alter table \\"public\\".\\"authors\\" add constraint \\"authors_birth_town_fkey\\" FOREIGN KEY (birth_town) REFERENCES town(id) ON UPDATE CASCADE not valid","alter table \\"public\\".\\"authors\\" validate constraint \\"authors_birth_town_fkey\\"","alter table \\"public\\".\\"citations\\" add constraint \\"citations_event_id_fkey\\" FOREIGN KEY (event_id) REFERENCES event(id) ON UPDATE CASCADE not valid","alter table \\"public\\".\\"citations\\" validate constraint \\"citations_event_id_fkey\\"","alter table \\"public\\".\\"citations\\" add constraint \\"citations_place_id_fkey\\" FOREIGN KEY (place_id) REFERENCES place(id) not valid","alter table \\"public\\".\\"citations\\" validate constraint \\"citations_place_id_fkey\\"","alter table \\"public\\".\\"event\\" add constraint \\"event_place_id_fkey\\" FOREIGN KEY (place_id) REFERENCES place(id) ON UPDATE CASCADE not valid","alter table \\"public\\".\\"event\\" validate constraint \\"event_place_id_fkey\\"","alter table \\"public\\".\\"place\\" add constraint \\"place_town_id_fkey\\" FOREIGN KEY (town_id) REFERENCES town(id) ON UPDATE CASCADE not valid","alter table \\"public\\".\\"place\\" validate constraint \\"place_town_id_fkey\\"","alter table \\"public\\".\\"town\\" add constraint \\"town_country_id_fkey\\" FOREIGN KEY (country_id) REFERENCES country(id) ON UPDATE CASCADE not valid","alter table \\"public\\".\\"town\\" validate constraint \\"town_country_id_fkey\\"","alter table \\"public\\".\\"citations\\" add constraint \\"citations_author_id_fkey\\" FOREIGN KEY (author_id) REFERENCES authors(id) ON UPDATE CASCADE not valid","alter table \\"public\\".\\"citations\\" validate constraint \\"citations_author_id_fkey\\""}	remote_schema
20231129114012	{"create table \\"public\\".\\"profiles\\" (\n    \\"id\\" uuid not null,\n    \\"updated_at\\" timestamp with time zone,\n    \\"username\\" text,\n    \\"full_name\\" text,\n    \\"avatar_url\\" text,\n    \\"website\\" text\n)","alter table \\"public\\".\\"profiles\\" enable row level security","CREATE UNIQUE INDEX profiles_pkey ON public.profiles USING btree (id)","CREATE UNIQUE INDEX profiles_username_key ON public.profiles USING btree (username)","alter table \\"public\\".\\"profiles\\" add constraint \\"profiles_pkey\\" PRIMARY KEY using index \\"profiles_pkey\\"","alter table \\"public\\".\\"profiles\\" add constraint \\"profiles_id_fkey\\" FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE not valid","alter table \\"public\\".\\"profiles\\" validate constraint \\"profiles_id_fkey\\"","alter table \\"public\\".\\"profiles\\" add constraint \\"profiles_username_key\\" UNIQUE using index \\"profiles_username_key\\"","alter table \\"public\\".\\"profiles\\" add constraint \\"username_length\\" CHECK ((char_length(username) >= 3)) not valid","alter table \\"public\\".\\"profiles\\" validate constraint \\"username_length\\"","set check_function_bodies = off","CREATE OR REPLACE FUNCTION public.handle_new_user()\n RETURNS trigger\n LANGUAGE plpgsql\n SECURITY DEFINER\nAS $function$\nbegin\n  insert into public.profiles (id, full_name, avatar_url)\n  values (new.id, new.raw_user_meta_data->>'full_name', new.raw_user_meta_data->>'avatar_url');\n  return new;\nend;\n$function$","create policy \\"Public profiles are viewable by everyone.\\"\non \\"public\\".\\"profiles\\"\nas permissive\nfor select\nto public\nusing (true)","create policy \\"Users can insert their own profile.\\"\non \\"public\\".\\"profiles\\"\nas permissive\nfor insert\nto public\nwith check ((auth.uid() = id))","create policy \\"Users can update own profile.\\"\non \\"public\\".\\"profiles\\"\nas permissive\nfor update\nto public\nusing ((auth.uid() = id))"}	user_management_starter
20231207142347	{"alter table \\"public\\".\\"town\\" drop constraint \\"town_country_id_fkey\\"","alter table \\"public\\".\\"country\\" drop constraint \\"country_pkey\\"","drop index if exists \\"public\\".\\"country_pkey\\"","drop table \\"public\\".\\"country\\"","create table \\"public\\".\\"countries\\" (\n    \\"id\\" bigint generated by default as identity not null,\n    \\"name\\" text,\n    \\"created_at\\" timestamp with time zone not null default now(),\n    \\"updated_at\\" timestamp with time zone default now(),\n    \\"found_year\\" bigint,\n    \\"next_rename_year\\" bigint\n)","CREATE UNIQUE INDEX country_pkey ON public.countries USING btree (id)","alter table \\"public\\".\\"countries\\" add constraint \\"country_pkey\\" PRIMARY KEY using index \\"country_pkey\\"","alter table \\"public\\".\\"town\\" add constraint \\"town_country_id_fkey\\" FOREIGN KEY (country_id) REFERENCES countries(id) ON UPDATE CASCADE not valid","alter table \\"public\\".\\"town\\" validate constraint \\"town_country_id_fkey\\""}	rename_countries
20231209022533	{"CREATE TRIGGER on_auth_user_new AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION handle_auth_user_new()","drop policy \\"Users can insert their own profile.\\" on \\"public\\".\\"profiles\\"","drop policy \\"Users can update own profile.\\" on \\"public\\".\\"profiles\\"","alter table \\"public\\".\\"profiles\\" drop constraint \\"profiles_id_fkey\\"","drop function if exists \\"public\\".\\"handle_new_user\\"()","alter table \\"public\\".\\"countries\\" enable row level security","alter table \\"public\\".\\"profiles\\" add column \\"auth_user_id\\" uuid not null","alter table \\"public\\".\\"profiles\\" alter column \\"id\\" add generated by default as identity","alter table \\"public\\".\\"profiles\\" alter column \\"id\\" set data type bigint using \\"id\\"::bigint","alter table \\"public\\".\\"profiles\\" add constraint \\"profiles_id_fkey\\" FOREIGN KEY (auth_user_id) REFERENCES auth.users(id) ON DELETE CASCADE not valid","alter table \\"public\\".\\"profiles\\" validate constraint \\"profiles_id_fkey\\"","set check_function_bodies = off","CREATE OR REPLACE FUNCTION public.delete_claim(uid uuid, claim text)\n RETURNS text\n LANGUAGE plpgsql\n SECURITY DEFINER\n SET search_path TO 'public'\nAS $function$\n    BEGIN\n      IF NOT is_claims_admin() THEN\n          RETURN 'error: access denied';\n      ELSE        \n        update auth.users set raw_app_meta_data = \n          raw_app_meta_data - claim where id = uid;\n        return 'OK';\n      END IF;\n    END;\n$function$","CREATE OR REPLACE FUNCTION public.get_claim(uid uuid, claim text)\n RETURNS jsonb\n LANGUAGE plpgsql\n SECURITY DEFINER\n SET search_path TO 'public'\nAS $function$\n    DECLARE retval jsonb;\n    BEGIN\n      IF NOT is_claims_admin() THEN\n          RETURN '{\\"error\\":\\"access denied\\"}'::jsonb;\n      ELSE\n        select coalesce(raw_app_meta_data->claim, null) from auth.users into retval where id = uid::uuid;\n        return retval;\n      END IF;\n    END;\n$function$","CREATE OR REPLACE FUNCTION public.get_claims(uid uuid)\n RETURNS jsonb\n LANGUAGE plpgsql\n SECURITY DEFINER\n SET search_path TO 'public'\nAS $function$\n    DECLARE retval jsonb;\n    BEGIN\n      IF NOT is_claims_admin() THEN\n          RETURN '{\\"error\\":\\"access denied\\"}'::jsonb;\n      ELSE\n        select raw_app_meta_data from auth.users into retval where id = uid::uuid;\n        return retval;\n      END IF;\n    END;\n$function$","CREATE OR REPLACE FUNCTION public.get_my_claim(claim text)\n RETURNS jsonb\n LANGUAGE sql\n STABLE\nAS $function$\n  select \n  \tcoalesce(nullif(current_setting('request.jwt.claims', true), '')::jsonb -> 'app_metadata' -> claim, null)\n$function$","CREATE OR REPLACE FUNCTION public.get_my_claims()\n RETURNS jsonb\n LANGUAGE sql\n STABLE\nAS $function$\n  select \n  \tcoalesce(nullif(current_setting('request.jwt.claims', true), '')::jsonb -> 'app_metadata', '{}'::jsonb)::jsonb\n$function$","CREATE OR REPLACE FUNCTION public.handle_auth_user_new()\n RETURNS trigger\n LANGUAGE plpgsql\n SECURITY DEFINER\nAS $function$\nBEGIN\n  INSERT INTO public.profiles (auth_user_id, full_name, avatar_url)\n\t  VALUES (\n\t\t  NEW.id,\n\t\t  NEW.raw_user_meta_data->>'full_name',\n\t\t  NEW.raw_user_meta_data->>'avatar_url'\n\t  );\n  RETURN NEW;\nEND;\n$function$","CREATE OR REPLACE FUNCTION public.handle_public_profile_new()\n RETURNS trigger\n LANGUAGE plpgsql\n SECURITY DEFINER\nAS $function$\n\nBEGIN\n\n/**\n * see `set claim` at\n * https://github.com/supabase-community/supabase-custom-claims/blob/main/install.sql\n **/\n  UPDATE auth.users\n  SET\n\t  raw_app_meta_data = COALESCE(\n\t\t  raw_app_meta_data || JSON_BUILD_OBJECT('profile_id', NEW.id)::jsonb,\n\t\t  JSON_BUILD_OBJECT('profile_id', NEW.id)::jsonb\n\t  )\n  WHERE id = NEW.auth_user_id;\n\n  RETURN NEW;\nEND;\n$function$","CREATE OR REPLACE FUNCTION public.is_claims_admin()\n RETURNS boolean\n LANGUAGE plpgsql\nAS $function$\n  BEGIN\n    IF session_user = 'authenticator' THEN\n      --------------------------------------------\n      -- To disallow any authenticated app users\n      -- from editing claims, delete the following\n      -- block of code and replace it with:\n      -- RETURN FALSE;\n      --------------------------------------------\n      IF extract(epoch from now()) > coalesce((current_setting('request.jwt.claims', true)::jsonb)->>'exp', '0')::numeric THEN\n        return false; -- jwt expired\n      END IF;\n      If current_setting('request.jwt.claims', true)::jsonb->>'role' = 'service_role' THEN\n        RETURN true; -- service role users have admin rights\n      END IF;\n      IF coalesce((current_setting('request.jwt.claims', true)::jsonb)->'app_metadata'->'claims_admin', 'false')::bool THEN\n        return true; -- user has claims_admin set to true\n      ELSE\n        return false; -- user does NOT have claims_admin set to true\n      END IF;\n      --------------------------------------------\n      -- End of block \n      --------------------------------------------\n    ELSE -- not a user session, probably being called from a trigger or something\n      return true;\n    END IF;\n  END;\n$function$","CREATE OR REPLACE FUNCTION public.set_claim(uid uuid, claim text, value jsonb)\n RETURNS text\n LANGUAGE plpgsql\n SECURITY DEFINER\n SET search_path TO 'public'\nAS $function$\n    BEGIN\n      IF NOT is_claims_admin() THEN\n          RETURN 'error: access denied';\n      ELSE        \n        update auth.users set raw_app_meta_data = \n          raw_app_meta_data || \n            json_build_object(claim, value)::jsonb where id = uid;\n        return 'OK';\n      END IF;\n    END;\n$function$","create policy \\"countries: authed can read\\"\non \\"public\\".\\"countries\\"\nas permissive\nfor select\nto authenticated\nusing (true)","create policy \\"Users can insert their own profile.\\"\non \\"public\\".\\"profiles\\"\nas permissive\nfor insert\nto public\nwith check ((auth.uid() = auth_user_id))","create policy \\"Users can update own profile.\\"\non \\"public\\".\\"profiles\\"\nas permissive\nfor update\nto public\nusing ((auth.uid() = auth_user_id))","CREATE TRIGGER on_public_profiles_new AFTER INSERT ON public.profiles FOR EACH ROW EXECUTE FUNCTION handle_public_profile_new()"}	profile_id
20231221015017	{"drop policy \\"countries: authed can read\\" on \\"public\\".\\"countries\\"","alter table \\"public\\".\\"profiles\\" drop constraint \\"profiles_pkey\\"","drop index if exists \\"public\\".\\"profiles_pkey\\"","alter table \\"public\\".\\"countries\\" add column \\"created_by\\" bigint","alter table \\"public\\".\\"countries\\" add column \\"updated_by\\" bigint","alter table \\"public\\".\\"countries\\" alter column \\"name\\" set default ''::text","alter table \\"public\\".\\"countries\\" alter column \\"name\\" set not null","CREATE UNIQUE INDEX profiles_pkey ON public.profiles USING btree (id)","alter table \\"public\\".\\"profiles\\" add constraint \\"profiles_pkey\\" PRIMARY KEY using index \\"profiles_pkey\\"","alter table \\"public\\".\\"countries\\" add constraint \\"countries_created_by_fkey\\" FOREIGN KEY (created_by) REFERENCES profiles(id) ON UPDATE CASCADE ON DELETE RESTRICT not valid","alter table \\"public\\".\\"countries\\" validate constraint \\"countries_created_by_fkey\\"","alter table \\"public\\".\\"countries\\" add constraint \\"countries_name_check\\" CHECK ((length(name) > 0)) not valid","alter table \\"public\\".\\"countries\\" validate constraint \\"countries_name_check\\"","alter table \\"public\\".\\"countries\\" add constraint \\"countries_updated_by_fkey\\" FOREIGN KEY (updated_by) REFERENCES profiles(id) ON UPDATE CASCADE ON DELETE RESTRICT not valid","alter table \\"public\\".\\"countries\\" validate constraint \\"countries_updated_by_fkey\\"","set check_function_bodies = off","CREATE OR REPLACE FUNCTION public.handle_fill_created_by()\n RETURNS trigger\n LANGUAGE plpgsql\n SECURITY DEFINER\nAS $function$\nBEGIN\n  NEW.created_by := get_my_claim('profile_id');\n  RETURN NEW;\nEND;\n$function$","CREATE OR REPLACE FUNCTION public.handle_fill_updated()\n RETURNS trigger\n LANGUAGE plpgsql\n SECURITY DEFINER\nAS $function$\nBEGIN\n  NEW.updated_by := get_my_claim('profile_id');\n  NEW.updated_at := NOW();\n  RETURN NEW;\nEND;\n$function$","create policy \\"countries: authed can all\\"\non \\"public\\".\\"countries\\"\nas permissive\nfor all\nto authenticated\nusing (true)\nwith check (true)","CREATE TRIGGER on_country_edit_fill_update BEFORE UPDATE ON public.countries FOR EACH ROW EXECUTE FUNCTION handle_fill_updated()","CREATE TRIGGER on_country_new_fill_created_by BEFORE INSERT ON public.countries FOR EACH ROW EXECUTE FUNCTION handle_fill_created_by()"}	countries_fill_created_updated
20231223035856	{"drop policy \\"Users can update own profile.\\" on \\"public\\".\\"profiles\\"","create table \\"public\\".\\"trusts\\" (\n    \\"id\\" bigint generated by default as identity not null,\n    \\"who\\" bigint not null,\n    \\"trusts_who\\" bigint not null\n)","alter table \\"public\\".\\"trusts\\" enable row level security","CREATE UNIQUE INDEX countries_name_key ON public.countries USING btree (name)","CREATE UNIQUE INDEX trusts_pkey ON public.trusts USING btree (id)","alter table \\"public\\".\\"trusts\\" add constraint \\"trusts_pkey\\" PRIMARY KEY using index \\"trusts_pkey\\"","alter table \\"public\\".\\"countries\\" add constraint \\"countries_name_key\\" UNIQUE using index \\"countries_name_key\\"","set check_function_bodies = off","CREATE OR REPLACE FUNCTION public.rls_profiles_edit(record profiles)\n RETURNS boolean\n LANGUAGE plpgsql\nAS $function$\nBEGIN\n    RAISE LOG 'rls_profiles_edit: profile %', record.id;\n    RETURN auth.uid() = record.auth_user_id;\nEND;\n$function$","CREATE OR REPLACE FUNCTION public.rls_profiles_edit(records profiles[])\n RETURNS boolean\n LANGUAGE plpgsql\nAS $function$\nDECLARE\n    t profiles;\nBEGIN\n  FOREACH t IN ARRAY records LOOP\n    RAISE LOG 'rls_profiles_edit: profiles %', t.id;\n    RETURN TRUE;\n  END LOOP;\nEND;\n$function$","CREATE OR REPLACE FUNCTION public.temporary_fn()\n RETURNS boolean\n LANGUAGE plpgsql\nAS $function$\nBEGIN\n  RAISE LOG 'This is an informational message';\n  RETURN TRUE;\nEND;\n$function$","create or replace view \\"public\\".\\"rls_edit_for_table\\" as  SELECT 'profiles'::text AS table_name,\n    profiles.id,\n    rls_profiles_edit(profiles.*) AS editable\n   FROM profiles","create policy \\"Users can update own profile.\\"\non \\"public\\".\\"profiles\\"\nas permissive\nfor update\nto public\nusing (rls_profiles_edit(profiles.*))"}	rls_profiles_edit
20231224133725	{"drop policy \\"countries: authed can all\\" on \\"public\\".\\"countries\\"","alter table \\"public\\".\\"trusts\\" rename column \\"trusts_who\\" to \\"trusts_whom\\"","alter table \\"public\\".\\"trusts\\" add column \\"end_at\\" timestamp with time zone not null default (now() + '1 day'::interval)","set check_function_bodies = off","CREATE OR REPLACE FUNCTION public.rls_check_edit_by_created_by(created_by bigint, allow_trust boolean DEFAULT true, claim_check character varying DEFAULT 'claim_edit_all_content'::character varying)\n RETURNS boolean\n LANGUAGE plpgsql\nAS $function$\nDECLARE\n\tprofile_id int8;\nBEGIN\n  profile_id := get_my_claim('profile_id')::int;\n\t-- RAISE WARNING 'rls_check_by_created_by: created_by: %, profile_id: %', created_by, profile_id;\n\t-- RETURN TRUE;\n\tRETURN get_my_claim(claim_check)::varchar::boolean\n\t    OR (profile_id = created_by)\n\t   \tOR (\n\t\t\t\tallow_trust AND ((\n\t\t\t\t\tSELECT TRUE\n\t\t\t\t\tFROM trusts\n\t\t\t\t\tWHERE NOW() < trusts.end_at\n\t\t\t\t\tAND created_by = trusts.who\n\t\t\t\t\t\tAND profile_id = trusts.trusts_whom\n\t\t\t\t))\n\t\t\t);\nEND;\n$function$","CREATE OR REPLACE FUNCTION public.rls_check_delete_by_created_by(created_by bigint, allow_trust boolean DEFAULT true, claim_check character varying DEFAULT 'claim_delete_all_content'::character varying)\n RETURNS boolean\n LANGUAGE plpgsql\nAS $function$\nBEGIN\n\tRETURN rls_check_edit_by_created_by(created_by, allow_trust, claim_check);\nEND;\n$function$","CREATE OR REPLACE FUNCTION public.rls_countries_delete(record countries)\n RETURNS boolean\n LANGUAGE plpgsql\nAS $function$\nBEGIN\n    RETURN rls_check_delete_by_created_by(record.created_by);\nEND;\n$function$","CREATE OR REPLACE FUNCTION public.rls_countries_edit(record countries)\n RETURNS boolean\n LANGUAGE plpgsql\nAS $function$\nBEGIN\n    RETURN rls_check_edit_by_created_by(record.created_by);\nEND;\n$function$","create or replace view \\"public\\".\\"rls_edit_for_table\\" as  SELECT 'profiles'::text AS table_name,\n    profiles.id,\n    rls_profiles_edit(profiles.*) AS editable,\n    false AS deletable\n   FROM profiles\nUNION\n SELECT 'countries'::text AS table_name,\n    countries.id,\n    rls_countries_edit(countries.*) AS editable,\n    rls_countries_delete(countries.*) AS deletable\n   FROM countries","CREATE OR REPLACE FUNCTION public.set_claim(uid uuid, claim text, value jsonb)\n RETURNS text\n LANGUAGE plpgsql\n SECURITY DEFINER\n SET search_path TO 'public'\nAS $function$\n    BEGIN\n      IF NOT is_claims_admin() THEN\n          RETURN 'error: access denied';\n      ELSE\n        update auth.users set raw_app_meta_data =\n          raw_app_meta_data ||\n            json_build_object(claim, value)::jsonb where id = uid;\n        return 'OK';\n      END IF;\n    END;\n$function$","create policy \\"RLS: countries: delete\\"\non \\"public\\".\\"countries\\"\nas permissive\nfor delete\nto authenticated\nusing (rls_countries_edit(countries.*))","create policy \\"RLS: countries: insert\\"\non \\"public\\".\\"countries\\"\nas permissive\nfor insert\nto authenticated\nwith check (rls_countries_edit(countries.*))","create policy \\"RLS: countries: select\\"\non \\"public\\".\\"countries\\"\nas permissive\nfor select\nto public\nusing (true)","create policy \\"RLS: countries: update\\"\non \\"public\\".\\"countries\\"\nas permissive\nfor update\nto authenticated\nwith check (rls_countries_edit(countries.*))","create policy \\"Enable read access for all users\\"\non \\"public\\".\\"trusts\\"\nas permissive\nfor select\nto public\nusing (true)"}	rls_check_edit_by_created_by_for_countries
20231224200604	{"drop policy \\"RLS: countries: delete\\" on \\"public\\".\\"countries\\"","alter table \\"public\\".\\"event\\" drop constraint \\"event_place_id_fkey\\"","alter table \\"public\\".\\"place\\" drop constraint \\"place_town_id_fkey\\"","alter table \\"public\\".\\"town\\" drop constraint \\"town_country_id_fkey\\"","alter table \\"public\\".\\"authors\\" drop constraint \\"authors_birth_town_fkey\\"","alter table \\"public\\".\\"citations\\" drop constraint \\"citations_event_id_fkey\\"","alter table \\"public\\".\\"citations\\" drop constraint \\"citations_place_id_fkey\\"","alter table \\"public\\".\\"event\\" drop constraint \\"event_pkey\\"","alter table \\"public\\".\\"place\\" drop constraint \\"place_pkey\\"","alter table \\"public\\".\\"town\\" drop constraint \\"town_pkey\\"","drop index if exists \\"public\\".\\"event_pkey\\"","drop index if exists \\"public\\".\\"place_pkey\\"","drop index if exists \\"public\\".\\"town_pkey\\"","drop table \\"public\\".\\"event\\"","drop table \\"public\\".\\"place\\"","drop table \\"public\\".\\"town\\"","create table \\"public\\".\\"events\\" (\n    \\"id\\" bigint generated by default as identity not null,\n    \\"name\\" text not null,\n    \\"created_at\\" timestamp with time zone not null default now(),\n    \\"updated_at\\" timestamp with time zone not null default now(),\n    \\"start_year\\" bigint not null,\n    \\"start_month\\" smallint not null,\n    \\"end_year\\" bigint,\n    \\"end_month\\" smallint,\n    \\"place_id\\" bigint,\n    \\"created_by\\" bigint,\n    \\"updated_by\\" bigint\n)","create table \\"public\\".\\"places\\" (\n    \\"id\\" bigint generated by default as identity not null,\n    \\"name\\" text not null default 'in'::text,\n    \\"created_at\\" timestamp with time zone not null default now(),\n    \\"updated_at\\" timestamp with time zone not null default now(),\n    \\"town_id\\" bigint not null,\n    \\"created_by\\" bigint,\n    \\"updated_by\\" bigint\n)","create table \\"public\\".\\"towns\\" (\n    \\"id\\" bigint generated by default as identity not null,\n    \\"name\\" text not null,\n    \\"created_at\\" timestamp with time zone not null default now(),\n    \\"updated_at\\" timestamp with time zone not null default now(),\n    \\"country_id\\" bigint not null,\n    \\"created_by\\" bigint,\n    \\"updated_by\\" bigint\n)","alter table \\"public\\".\\"authors\\" add column \\"created_by\\" bigint","alter table \\"public\\".\\"authors\\" add column \\"updated_by\\" bigint","alter table \\"public\\".\\"citations\\" add column \\"created_by\\" bigint","alter table \\"public\\".\\"citations\\" add column \\"updated_by\\" bigint","alter table \\"public\\".\\"profiles\\" add column \\"created_at\\" timestamp with time zone default now()","CREATE UNIQUE INDEX event_pkey ON public.events USING btree (id)","CREATE UNIQUE INDEX place_pkey ON public.places USING btree (id)","CREATE UNIQUE INDEX town_pkey ON public.towns USING btree (id)","alter table \\"public\\".\\"events\\" add constraint \\"event_pkey\\" PRIMARY KEY using index \\"event_pkey\\"","alter table \\"public\\".\\"places\\" add constraint \\"place_pkey\\" PRIMARY KEY using index \\"place_pkey\\"","alter table \\"public\\".\\"towns\\" add constraint \\"town_pkey\\" PRIMARY KEY using index \\"town_pkey\\"","alter table \\"public\\".\\"authors\\" add constraint \\"authors_created_by_fkey\\" FOREIGN KEY (created_by) REFERENCES profiles(id) ON UPDATE CASCADE ON DELETE RESTRICT not valid","alter table \\"public\\".\\"authors\\" validate constraint \\"authors_created_by_fkey\\"","alter table \\"public\\".\\"authors\\" add constraint \\"authors_updated_by_fkey\\" FOREIGN KEY (updated_by) REFERENCES profiles(id) ON UPDATE CASCADE ON DELETE RESTRICT not valid","alter table \\"public\\".\\"authors\\" validate constraint \\"authors_updated_by_fkey\\"","alter table \\"public\\".\\"citations\\" add constraint \\"citations_created_by_fkey\\" FOREIGN KEY (created_by) REFERENCES profiles(id) ON UPDATE CASCADE ON DELETE RESTRICT not valid","alter table \\"public\\".\\"citations\\" validate constraint \\"citations_created_by_fkey\\"","alter table \\"public\\".\\"citations\\" add constraint \\"citations_updated_by_fkey\\" FOREIGN KEY (updated_by) REFERENCES profiles(id) ON UPDATE CASCADE ON DELETE RESTRICT not valid","alter table \\"public\\".\\"citations\\" validate constraint \\"citations_updated_by_fkey\\"","alter table \\"public\\".\\"events\\" add constraint \\"events_created_by_fkey\\" FOREIGN KEY (created_by) REFERENCES profiles(id) ON UPDATE CASCADE ON DELETE RESTRICT not valid","alter table \\"public\\".\\"events\\" validate constraint \\"events_created_by_fkey\\"","alter table \\"public\\".\\"events\\" add constraint \\"events_place_id_fkey\\" FOREIGN KEY (place_id) REFERENCES places(id) ON UPDATE CASCADE not valid","alter table \\"public\\".\\"events\\" validate constraint \\"events_place_id_fkey\\"","alter table \\"public\\".\\"events\\" add constraint \\"events_updated_by_fkey\\" FOREIGN KEY (updated_by) REFERENCES profiles(id) ON UPDATE CASCADE ON DELETE RESTRICT not valid","alter table \\"public\\".\\"events\\" validate constraint \\"events_updated_by_fkey\\"","alter table \\"public\\".\\"places\\" add constraint \\"places_created_by_fkey\\" FOREIGN KEY (created_by) REFERENCES profiles(id) ON UPDATE CASCADE ON DELETE RESTRICT not valid","alter table \\"public\\".\\"places\\" validate constraint \\"places_created_by_fkey\\"","alter table \\"public\\".\\"places\\" add constraint \\"places_town_id_fkey\\" FOREIGN KEY (town_id) REFERENCES towns(id) ON UPDATE CASCADE not valid","alter table \\"public\\".\\"places\\" validate constraint \\"places_town_id_fkey\\"","alter table \\"public\\".\\"places\\" add constraint \\"places_updated_by_fkey\\" FOREIGN KEY (updated_by) REFERENCES profiles(id) ON UPDATE CASCADE ON DELETE RESTRICT not valid","alter table \\"public\\".\\"places\\" validate constraint \\"places_updated_by_fkey\\"","alter table \\"public\\".\\"towns\\" add constraint \\"towns_country_id_fkey\\" FOREIGN KEY (country_id) REFERENCES countries(id) ON UPDATE CASCADE not valid","alter table \\"public\\".\\"towns\\" validate constraint \\"towns_country_id_fkey\\"","alter table \\"public\\".\\"towns\\" add constraint \\"towns_created_by_fkey\\" FOREIGN KEY (created_by) REFERENCES profiles(id) ON UPDATE CASCADE ON DELETE RESTRICT not valid","alter table \\"public\\".\\"towns\\" validate constraint \\"towns_created_by_fkey\\"","alter table \\"public\\".\\"towns\\" add constraint \\"towns_updated_by_fkey\\" FOREIGN KEY (updated_by) REFERENCES profiles(id) ON UPDATE CASCADE ON DELETE RESTRICT not valid","alter table \\"public\\".\\"towns\\" validate constraint \\"towns_updated_by_fkey\\"","alter table \\"public\\".\\"authors\\" add constraint \\"authors_birth_town_fkey\\" FOREIGN KEY (birth_town) REFERENCES towns(id) ON UPDATE CASCADE not valid","alter table \\"public\\".\\"authors\\" validate constraint \\"authors_birth_town_fkey\\"","alter table \\"public\\".\\"citations\\" add constraint \\"citations_event_id_fkey\\" FOREIGN KEY (event_id) REFERENCES events(id) ON UPDATE CASCADE not valid","alter table \\"public\\".\\"citations\\" validate constraint \\"citations_event_id_fkey\\"","alter table \\"public\\".\\"citations\\" add constraint \\"citations_place_id_fkey\\" FOREIGN KEY (place_id) REFERENCES places(id) not valid","alter table \\"public\\".\\"citations\\" validate constraint \\"citations_place_id_fkey\\"","set check_function_bodies = off","create policy \\"RLS: countries: delete\\"\non \\"public\\".\\"countries\\"\nas permissive\nfor delete\nto authenticated\nusing (rls_countries_delete(countries.*))","CREATE TRIGGER on_authors_edit_fill_update BEFORE UPDATE ON public.authors FOR EACH ROW EXECUTE FUNCTION handle_fill_updated()","CREATE TRIGGER on_authors_new_fill_created_by BEFORE INSERT ON public.authors FOR EACH ROW EXECUTE FUNCTION handle_fill_created_by()","CREATE TRIGGER on_citations_edit_fill_update BEFORE UPDATE ON public.citations FOR EACH ROW EXECUTE FUNCTION handle_fill_updated()","CREATE TRIGGER on_citations_new_fill_created_by BEFORE INSERT ON public.citations FOR EACH ROW EXECUTE FUNCTION handle_fill_created_by()","CREATE TRIGGER on_events_edit_fill_update BEFORE UPDATE ON public.events FOR EACH ROW EXECUTE FUNCTION handle_fill_updated()","CREATE TRIGGER on_events_new_fill_created_by BEFORE INSERT ON public.events FOR EACH ROW EXECUTE FUNCTION handle_fill_created_by()","CREATE TRIGGER on_places_edit_fill_update BEFORE UPDATE ON public.places FOR EACH ROW EXECUTE FUNCTION handle_fill_updated()","CREATE TRIGGER on_places_new_fill_created_by BEFORE INSERT ON public.places FOR EACH ROW EXECUTE FUNCTION handle_fill_created_by()","CREATE TRIGGER on_towns_edit_fill_update BEFORE UPDATE ON public.towns FOR EACH ROW EXECUTE FUNCTION handle_fill_updated()","CREATE TRIGGER on_towns_new_fill_created_by BEFORE INSERT ON public.towns FOR EACH ROW EXECUTE FUNCTION handle_fill_created_by()"}	content_tables_add_created_and_updated_by
\.


--
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: supabase_admin
--

COPY vault.secrets (id, name, description, secret, key_id, nonce, created_at, updated_at) FROM stdin;
\.


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 787, true);


--
-- Name: key_key_id_seq; Type: SEQUENCE SET; Schema: pgsodium; Owner: supabase_admin
--

SELECT pg_catalog.setval('pgsodium.key_key_id_seq', 1, false);


--
-- Name: author_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.author_id_seq', 1, false);


--
-- Name: citations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.citations_id_seq', 1, false);


--
-- Name: country_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.country_id_seq', 12, true);


--
-- Name: event_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.event_id_seq', 1, false);


--
-- Name: place_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.place_id_seq', 1, false);


--
-- Name: profiles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.profiles_id_seq', 21, true);


--
-- Name: town_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.town_id_seq', 10, true);


--
-- Name: trusts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.trusts_id_seq', 2, true);


--
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- Name: flow_state flow_state_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.flow_state
    ADD CONSTRAINT flow_state_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: identities identities_provider_id_provider_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_provider_id_provider_unique UNIQUE (provider_id, provider);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: authors author_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authors
    ADD CONSTRAINT author_pkey PRIMARY KEY (id);


--
-- Name: citations citations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.citations
    ADD CONSTRAINT citations_pkey PRIMARY KEY (id);


--
-- Name: countries countries_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_name_key UNIQUE (name);


--
-- Name: countries country_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT country_pkey PRIMARY KEY (id);


--
-- Name: events event_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT event_pkey PRIMARY KEY (id);


--
-- Name: places place_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.places
    ADD CONSTRAINT place_pkey PRIMARY KEY (id);


--
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- Name: profiles profiles_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_username_key UNIQUE (username);


--
-- Name: towns town_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.towns
    ADD CONSTRAINT town_pkey PRIMARY KEY (id);


--
-- Name: trusts trusts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trusts
    ADD CONSTRAINT trusts_pkey PRIMARY KEY (id);


--
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: supabase_migrations; Owner: postgres
--

ALTER TABLE ONLY supabase_migrations.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- Name: flow_state_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX flow_state_created_at_idx ON auth.flow_state USING btree (created_at DESC);


--
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- Name: idx_auth_code; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_auth_code ON auth.flow_state USING btree (auth_code);


--
-- Name: idx_user_id_auth_method; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_user_id_auth_method ON auth.flow_state USING btree (user_id, authentication_method);


--
-- Name: mfa_challenge_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_challenge_created_at_idx ON auth.mfa_challenges USING btree (created_at DESC);


--
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- Name: mfa_factors_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_factors_user_id_idx ON auth.mfa_factors USING btree (user_id);


--
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- Name: refresh_tokens_updated_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_updated_at_idx ON auth.refresh_tokens USING btree (updated_at DESC);


--
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- Name: saml_relay_states_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_created_at_idx ON auth.saml_relay_states USING btree (created_at DESC);


--
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- Name: sessions_not_after_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_not_after_idx ON auth.sessions USING btree (not_after DESC);


--
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- Name: bname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- Name: users on_auth_user_new; Type: TRIGGER; Schema: auth; Owner: supabase_auth_admin
--

CREATE TRIGGER on_auth_user_new AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION public.handle_auth_user_new();


--
-- Name: authors on_authors_edit_fill_update; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER on_authors_edit_fill_update BEFORE UPDATE ON public.authors FOR EACH ROW EXECUTE FUNCTION public.handle_fill_updated();


--
-- Name: authors on_authors_new_fill_created_by; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER on_authors_new_fill_created_by BEFORE INSERT ON public.authors FOR EACH ROW EXECUTE FUNCTION public.handle_fill_created_by();


--
-- Name: citations on_citations_edit_fill_update; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER on_citations_edit_fill_update BEFORE UPDATE ON public.citations FOR EACH ROW EXECUTE FUNCTION public.handle_fill_updated();


--
-- Name: citations on_citations_new_fill_created_by; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER on_citations_new_fill_created_by BEFORE INSERT ON public.citations FOR EACH ROW EXECUTE FUNCTION public.handle_fill_created_by();


--
-- Name: countries on_country_edit_fill_update; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER on_country_edit_fill_update BEFORE UPDATE ON public.countries FOR EACH ROW EXECUTE FUNCTION public.handle_fill_updated();


--
-- Name: countries on_country_new_fill_created_by; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER on_country_new_fill_created_by BEFORE INSERT ON public.countries FOR EACH ROW EXECUTE FUNCTION public.handle_fill_created_by();


--
-- Name: events on_events_edit_fill_update; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER on_events_edit_fill_update BEFORE UPDATE ON public.events FOR EACH ROW EXECUTE FUNCTION public.handle_fill_updated();


--
-- Name: events on_events_new_fill_created_by; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER on_events_new_fill_created_by BEFORE INSERT ON public.events FOR EACH ROW EXECUTE FUNCTION public.handle_fill_created_by();


--
-- Name: places on_places_edit_fill_update; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER on_places_edit_fill_update BEFORE UPDATE ON public.places FOR EACH ROW EXECUTE FUNCTION public.handle_fill_updated();


--
-- Name: places on_places_new_fill_created_by; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER on_places_new_fill_created_by BEFORE INSERT ON public.places FOR EACH ROW EXECUTE FUNCTION public.handle_fill_created_by();


--
-- Name: profiles on_public_profiles_new; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER on_public_profiles_new AFTER INSERT ON public.profiles FOR EACH ROW EXECUTE FUNCTION public.handle_public_profile_new();


--
-- Name: towns on_towns_edit_fill_update; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER on_towns_edit_fill_update BEFORE UPDATE ON public.towns FOR EACH ROW EXECUTE FUNCTION public.handle_fill_updated();


--
-- Name: towns on_towns_new_fill_created_by; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER on_towns_new_fill_created_by BEFORE INSERT ON public.towns FOR EACH ROW EXECUTE FUNCTION public.handle_fill_created_by();


--
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_flow_state_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_flow_state_id_fkey FOREIGN KEY (flow_state_id) REFERENCES auth.flow_state(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: authors authors_birth_town_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authors
    ADD CONSTRAINT authors_birth_town_fkey FOREIGN KEY (birth_town) REFERENCES public.towns(id) ON UPDATE CASCADE;


--
-- Name: authors authors_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authors
    ADD CONSTRAINT authors_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.profiles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: authors authors_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authors
    ADD CONSTRAINT authors_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.profiles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: citations citations_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.citations
    ADD CONSTRAINT citations_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.authors(id) ON UPDATE CASCADE;


--
-- Name: citations citations_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.citations
    ADD CONSTRAINT citations_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.profiles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: citations citations_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.citations
    ADD CONSTRAINT citations_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(id) ON UPDATE CASCADE;


--
-- Name: citations citations_place_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.citations
    ADD CONSTRAINT citations_place_id_fkey FOREIGN KEY (place_id) REFERENCES public.places(id);


--
-- Name: citations citations_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.citations
    ADD CONSTRAINT citations_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.profiles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: countries countries_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.profiles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: countries countries_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.profiles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: events events_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.profiles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: events events_place_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_place_id_fkey FOREIGN KEY (place_id) REFERENCES public.places(id) ON UPDATE CASCADE;


--
-- Name: events events_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.profiles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: places places_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.places
    ADD CONSTRAINT places_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.profiles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: places places_town_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.places
    ADD CONSTRAINT places_town_id_fkey FOREIGN KEY (town_id) REFERENCES public.towns(id) ON UPDATE CASCADE;


--
-- Name: places places_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.places
    ADD CONSTRAINT places_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.profiles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: profiles profiles_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_id_fkey FOREIGN KEY (auth_user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: towns towns_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.towns
    ADD CONSTRAINT towns_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.countries(id) ON UPDATE CASCADE;


--
-- Name: towns towns_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.towns
    ADD CONSTRAINT towns_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.profiles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: towns towns_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.towns
    ADD CONSTRAINT towns_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.profiles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: trusts Enable read access for all users; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable read access for all users" ON public.trusts FOR SELECT USING (true);


--
-- Name: profiles Public profiles are viewable by everyone.; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Public profiles are viewable by everyone." ON public.profiles FOR SELECT USING (true);


--
-- Name: authors RLS: authors: delete; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "RLS: authors: delete" ON public.authors FOR DELETE TO authenticated USING (public.rls_authors_edit(authors.*));


--
-- Name: authors RLS: authors: insert; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "RLS: authors: insert" ON public.authors FOR INSERT TO authenticated WITH CHECK (public.rls_authors_edit(authors.*));


--
-- Name: authors RLS: authors: select; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "RLS: authors: select" ON public.authors FOR SELECT USING (true);


--
-- Name: authors RLS: authors: update; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "RLS: authors: update" ON public.authors FOR UPDATE TO authenticated USING (public.rls_authors_edit(authors.*)) WITH CHECK (public.rls_authors_edit(authors.*));


--
-- Name: citations RLS: citations: delete; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "RLS: citations: delete" ON public.citations FOR DELETE TO authenticated USING (public.rls_citations_edit(citations.*));


--
-- Name: citations RLS: citations: insert; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "RLS: citations: insert" ON public.citations FOR INSERT TO authenticated WITH CHECK (public.rls_citations_edit(citations.*));


--
-- Name: citations RLS: citations: select; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "RLS: citations: select" ON public.citations FOR SELECT USING (true);


--
-- Name: citations RLS: citations: update; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "RLS: citations: update" ON public.citations FOR UPDATE TO authenticated USING (public.rls_citations_edit(citations.*)) WITH CHECK (public.rls_citations_edit(citations.*));


--
-- Name: countries RLS: countries: delete; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "RLS: countries: delete" ON public.countries FOR DELETE TO authenticated USING (public.rls_countries_delete(countries.*));


--
-- Name: countries RLS: countries: insert; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "RLS: countries: insert" ON public.countries FOR INSERT TO authenticated WITH CHECK (public.rls_countries_edit(countries.*));


--
-- Name: countries RLS: countries: select; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "RLS: countries: select" ON public.countries FOR SELECT USING (true);


--
-- Name: countries RLS: countries: update; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "RLS: countries: update" ON public.countries FOR UPDATE TO authenticated USING (public.rls_countries_edit(countries.*)) WITH CHECK (public.rls_countries_edit(countries.*));


--
-- Name: events RLS: events: delete; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "RLS: events: delete" ON public.events FOR DELETE TO authenticated USING (public.rls_events_edit(events.*));


--
-- Name: events RLS: events: insert; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "RLS: events: insert" ON public.events FOR INSERT TO authenticated WITH CHECK (public.rls_events_edit(events.*));


--
-- Name: events RLS: events: select; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "RLS: events: select" ON public.events FOR SELECT USING (true);


--
-- Name: events RLS: events: update; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "RLS: events: update" ON public.events FOR UPDATE TO authenticated USING (public.rls_events_edit(events.*)) WITH CHECK (public.rls_events_edit(events.*));


--
-- Name: places RLS: places: delete; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "RLS: places: delete" ON public.places FOR DELETE TO authenticated USING (public.rls_places_edit(places.*));


--
-- Name: places RLS: places: insert; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "RLS: places: insert" ON public.places FOR INSERT TO authenticated WITH CHECK (public.rls_places_edit(places.*));


--
-- Name: places RLS: places: select; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "RLS: places: select" ON public.places FOR SELECT USING (true);


--
-- Name: places RLS: places: update; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "RLS: places: update" ON public.places FOR UPDATE TO authenticated USING (public.rls_places_edit(places.*)) WITH CHECK (public.rls_places_edit(places.*));


--
-- Name: towns RLS: towns: delete; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "RLS: towns: delete" ON public.towns FOR DELETE TO authenticated USING (public.rls_towns_edit(towns.*));


--
-- Name: towns RLS: towns: insert; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "RLS: towns: insert" ON public.towns FOR INSERT TO authenticated WITH CHECK (public.rls_towns_edit(towns.*));


--
-- Name: towns RLS: towns: select; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "RLS: towns: select" ON public.towns FOR SELECT USING (true);


--
-- Name: towns RLS: towns: update; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "RLS: towns: update" ON public.towns FOR UPDATE TO authenticated USING (public.rls_towns_edit(towns.*)) WITH CHECK (public.rls_towns_edit(towns.*));


--
-- Name: profiles Users can insert their own profile.; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can insert their own profile." ON public.profiles FOR INSERT WITH CHECK ((auth.uid() = auth_user_id));


--
-- Name: profiles Users can update own profile.; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can update own profile." ON public.profiles FOR UPDATE USING (public.rls_profiles_edit(profiles.*));


--
-- Name: authors; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.authors ENABLE ROW LEVEL SECURITY;

--
-- Name: citations; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.citations ENABLE ROW LEVEL SECURITY;

--
-- Name: countries; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.countries ENABLE ROW LEVEL SECURITY;

--
-- Name: events; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.events ENABLE ROW LEVEL SECURITY;

--
-- Name: places; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.places ENABLE ROW LEVEL SECURITY;

--
-- Name: profiles; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

--
-- Name: towns; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.towns ENABLE ROW LEVEL SECURITY;

--
-- Name: trusts; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.trusts ENABLE ROW LEVEL SECURITY;

--
-- Name: objects Anyone can upload an avatar.; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Anyone can upload an avatar." ON storage.objects FOR INSERT WITH CHECK ((bucket_id = 'avatars'::text));


--
-- Name: objects Avatar images are publicly accessible.; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Avatar images are publicly accessible." ON storage.objects FOR SELECT USING ((bucket_id = 'avatars'::text));


--
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: postgres
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


ALTER PUBLICATION supabase_realtime OWNER TO postgres;

--
-- Name: SCHEMA auth; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA auth TO anon;
GRANT USAGE ON SCHEMA auth TO authenticated;
GRANT USAGE ON SCHEMA auth TO service_role;
GRANT ALL ON SCHEMA auth TO supabase_auth_admin;
GRANT ALL ON SCHEMA auth TO dashboard_user;
GRANT ALL ON SCHEMA auth TO postgres;


--
-- Name: SCHEMA extensions; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA extensions TO anon;
GRANT USAGE ON SCHEMA extensions TO authenticated;
GRANT USAGE ON SCHEMA extensions TO service_role;
GRANT ALL ON SCHEMA extensions TO dashboard_user;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT USAGE ON SCHEMA public TO postgres;
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;


--
-- Name: SCHEMA realtime; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA realtime TO postgres;


--
-- Name: SCHEMA storage; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT ALL ON SCHEMA storage TO postgres;
GRANT USAGE ON SCHEMA storage TO anon;
GRANT USAGE ON SCHEMA storage TO authenticated;
GRANT USAGE ON SCHEMA storage TO service_role;
GRANT ALL ON SCHEMA storage TO supabase_storage_admin;
GRANT ALL ON SCHEMA storage TO dashboard_user;


--
-- Name: FUNCTION email(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.email() TO dashboard_user;
GRANT ALL ON FUNCTION auth.email() TO postgres;


--
-- Name: FUNCTION jwt(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.jwt() TO postgres;
GRANT ALL ON FUNCTION auth.jwt() TO dashboard_user;


--
-- Name: FUNCTION role(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.role() TO dashboard_user;
GRANT ALL ON FUNCTION auth.role() TO postgres;


--
-- Name: FUNCTION uid(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.uid() TO dashboard_user;
GRANT ALL ON FUNCTION auth.uid() TO postgres;


--
-- Name: FUNCTION algorithm_sign(signables text, secret text, algorithm text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.algorithm_sign(signables text, secret text, algorithm text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.algorithm_sign(signables text, secret text, algorithm text) TO dashboard_user;


--
-- Name: FUNCTION armor(bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.armor(bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.armor(bytea) TO dashboard_user;


--
-- Name: FUNCTION armor(bytea, text[], text[]); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO dashboard_user;


--
-- Name: FUNCTION crypt(text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.crypt(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.crypt(text, text) TO dashboard_user;


--
-- Name: FUNCTION dearmor(text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.dearmor(text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.dearmor(text) TO dashboard_user;


--
-- Name: FUNCTION decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION decrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION digest(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION digest(text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.digest(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.digest(text, text) TO dashboard_user;


--
-- Name: FUNCTION encrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION encrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION gen_random_bytes(integer); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO dashboard_user;


--
-- Name: FUNCTION gen_random_uuid(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO dashboard_user;


--
-- Name: FUNCTION gen_salt(text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.gen_salt(text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_salt(text) TO dashboard_user;


--
-- Name: FUNCTION gen_salt(text, integer); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO dashboard_user;


--
-- Name: FUNCTION grant_pg_cron_access(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.grant_pg_cron_access() FROM postgres;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO dashboard_user;


--
-- Name: FUNCTION grant_pg_graphql_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.grant_pg_graphql_access() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION grant_pg_net_access(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.grant_pg_net_access() FROM postgres;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO dashboard_user;


--
-- Name: FUNCTION hmac(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION hmac(text, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT blk_read_time double precision, OUT blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT blk_read_time double precision, OUT blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT blk_read_time double precision, OUT blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements_reset(userid oid, dbid oid, queryid bigint); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint) TO dashboard_user;


--
-- Name: FUNCTION pgp_armor_headers(text, OUT key text, OUT value text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO dashboard_user;


--
-- Name: FUNCTION pgp_key_id(bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgrst_ddl_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_ddl_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgrst_drop_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_drop_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION set_graphql_placeholder(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.set_graphql_placeholder() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION sign(payload json, secret text, algorithm text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.sign(payload json, secret text, algorithm text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.sign(payload json, secret text, algorithm text) TO dashboard_user;


--
-- Name: FUNCTION try_cast_double(inp text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.try_cast_double(inp text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.try_cast_double(inp text) TO dashboard_user;


--
-- Name: FUNCTION url_decode(data text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.url_decode(data text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.url_decode(data text) TO dashboard_user;


--
-- Name: FUNCTION url_encode(data bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.url_encode(data bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.url_encode(data bytea) TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v1(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v1mc(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v3(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v4(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v5(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO dashboard_user;


--
-- Name: FUNCTION uuid_nil(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_nil() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_nil() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_dns(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_oid(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_url(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_x500(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO dashboard_user;


--
-- Name: FUNCTION verify(token text, secret text, algorithm text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.verify(token text, secret text, algorithm text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.verify(token text, secret text, algorithm text) TO dashboard_user;


--
-- Name: FUNCTION comment_directive(comment_ text); Type: ACL; Schema: graphql; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql.comment_directive(comment_ text) TO postgres;
GRANT ALL ON FUNCTION graphql.comment_directive(comment_ text) TO anon;
GRANT ALL ON FUNCTION graphql.comment_directive(comment_ text) TO authenticated;
GRANT ALL ON FUNCTION graphql.comment_directive(comment_ text) TO service_role;


--
-- Name: FUNCTION exception(message text); Type: ACL; Schema: graphql; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql.exception(message text) TO postgres;
GRANT ALL ON FUNCTION graphql.exception(message text) TO anon;
GRANT ALL ON FUNCTION graphql.exception(message text) TO authenticated;
GRANT ALL ON FUNCTION graphql.exception(message text) TO service_role;


--
-- Name: FUNCTION graphql("operationName" text, query text, variables jsonb, extensions jsonb); Type: ACL; Schema: graphql_public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO postgres;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO anon;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO authenticated;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO service_role;


--
-- Name: FUNCTION get_auth(p_usename text); Type: ACL; Schema: pgbouncer; Owner: postgres
--

REVOKE ALL ON FUNCTION pgbouncer.get_auth(p_usename text) FROM PUBLIC;
GRANT ALL ON FUNCTION pgbouncer.get_auth(p_usename text) TO pgbouncer;


--
-- Name: FUNCTION crypto_aead_det_decrypt(message bytea, additional bytea, key_uuid uuid, nonce bytea); Type: ACL; Schema: pgsodium; Owner: pgsodium_keymaker
--

GRANT ALL ON FUNCTION pgsodium.crypto_aead_det_decrypt(message bytea, additional bytea, key_uuid uuid, nonce bytea) TO service_role;


--
-- Name: FUNCTION crypto_aead_det_encrypt(message bytea, additional bytea, key_uuid uuid, nonce bytea); Type: ACL; Schema: pgsodium; Owner: pgsodium_keymaker
--

GRANT ALL ON FUNCTION pgsodium.crypto_aead_det_encrypt(message bytea, additional bytea, key_uuid uuid, nonce bytea) TO service_role;


--
-- Name: FUNCTION crypto_aead_det_keygen(); Type: ACL; Schema: pgsodium; Owner: supabase_admin
--

GRANT ALL ON FUNCTION pgsodium.crypto_aead_det_keygen() TO service_role;


--
-- Name: FUNCTION delete_claim(uid uuid, claim text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.delete_claim(uid uuid, claim text) TO anon;
GRANT ALL ON FUNCTION public.delete_claim(uid uuid, claim text) TO authenticated;
GRANT ALL ON FUNCTION public.delete_claim(uid uuid, claim text) TO service_role;


--
-- Name: FUNCTION get_claim(uid uuid, claim text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_claim(uid uuid, claim text) TO anon;
GRANT ALL ON FUNCTION public.get_claim(uid uuid, claim text) TO authenticated;
GRANT ALL ON FUNCTION public.get_claim(uid uuid, claim text) TO service_role;


--
-- Name: FUNCTION get_claims(uid uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_claims(uid uuid) TO anon;
GRANT ALL ON FUNCTION public.get_claims(uid uuid) TO authenticated;
GRANT ALL ON FUNCTION public.get_claims(uid uuid) TO service_role;


--
-- Name: FUNCTION get_my_claim(claim text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_my_claim(claim text) TO anon;
GRANT ALL ON FUNCTION public.get_my_claim(claim text) TO authenticated;
GRANT ALL ON FUNCTION public.get_my_claim(claim text) TO service_role;


--
-- Name: FUNCTION get_my_claims(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_my_claims() TO anon;
GRANT ALL ON FUNCTION public.get_my_claims() TO authenticated;
GRANT ALL ON FUNCTION public.get_my_claims() TO service_role;


--
-- Name: FUNCTION handle_auth_user_new(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.handle_auth_user_new() TO anon;
GRANT ALL ON FUNCTION public.handle_auth_user_new() TO authenticated;
GRANT ALL ON FUNCTION public.handle_auth_user_new() TO service_role;


--
-- Name: FUNCTION handle_fill_created_by(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.handle_fill_created_by() TO anon;
GRANT ALL ON FUNCTION public.handle_fill_created_by() TO authenticated;
GRANT ALL ON FUNCTION public.handle_fill_created_by() TO service_role;


--
-- Name: FUNCTION handle_fill_updated(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.handle_fill_updated() TO anon;
GRANT ALL ON FUNCTION public.handle_fill_updated() TO authenticated;
GRANT ALL ON FUNCTION public.handle_fill_updated() TO service_role;


--
-- Name: FUNCTION handle_public_profile_new(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.handle_public_profile_new() TO anon;
GRANT ALL ON FUNCTION public.handle_public_profile_new() TO authenticated;
GRANT ALL ON FUNCTION public.handle_public_profile_new() TO service_role;


--
-- Name: FUNCTION is_claims_admin(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.is_claims_admin() TO anon;
GRANT ALL ON FUNCTION public.is_claims_admin() TO authenticated;
GRANT ALL ON FUNCTION public.is_claims_admin() TO service_role;


--
-- Name: TABLE authors; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.authors TO anon;
GRANT ALL ON TABLE public.authors TO authenticated;
GRANT ALL ON TABLE public.authors TO service_role;


--
-- Name: FUNCTION rls_authors_delete(record public.authors); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.rls_authors_delete(record public.authors) TO anon;
GRANT ALL ON FUNCTION public.rls_authors_delete(record public.authors) TO authenticated;
GRANT ALL ON FUNCTION public.rls_authors_delete(record public.authors) TO service_role;


--
-- Name: FUNCTION rls_authors_edit(record public.authors); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.rls_authors_edit(record public.authors) TO anon;
GRANT ALL ON FUNCTION public.rls_authors_edit(record public.authors) TO authenticated;
GRANT ALL ON FUNCTION public.rls_authors_edit(record public.authors) TO service_role;


--
-- Name: FUNCTION rls_check_delete_by_created_by(created_by bigint, allow_trust boolean, claim_check character varying); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.rls_check_delete_by_created_by(created_by bigint, allow_trust boolean, claim_check character varying) TO anon;
GRANT ALL ON FUNCTION public.rls_check_delete_by_created_by(created_by bigint, allow_trust boolean, claim_check character varying) TO authenticated;
GRANT ALL ON FUNCTION public.rls_check_delete_by_created_by(created_by bigint, allow_trust boolean, claim_check character varying) TO service_role;


--
-- Name: FUNCTION rls_check_edit_by_created_by(created_by bigint, allow_trust boolean, claim_check character varying); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.rls_check_edit_by_created_by(created_by bigint, allow_trust boolean, claim_check character varying) TO anon;
GRANT ALL ON FUNCTION public.rls_check_edit_by_created_by(created_by bigint, allow_trust boolean, claim_check character varying) TO authenticated;
GRANT ALL ON FUNCTION public.rls_check_edit_by_created_by(created_by bigint, allow_trust boolean, claim_check character varying) TO service_role;


--
-- Name: TABLE citations; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.citations TO anon;
GRANT ALL ON TABLE public.citations TO authenticated;
GRANT ALL ON TABLE public.citations TO service_role;


--
-- Name: FUNCTION rls_citations_delete(record public.citations); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.rls_citations_delete(record public.citations) TO anon;
GRANT ALL ON FUNCTION public.rls_citations_delete(record public.citations) TO authenticated;
GRANT ALL ON FUNCTION public.rls_citations_delete(record public.citations) TO service_role;


--
-- Name: FUNCTION rls_citations_edit(record public.citations); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.rls_citations_edit(record public.citations) TO anon;
GRANT ALL ON FUNCTION public.rls_citations_edit(record public.citations) TO authenticated;
GRANT ALL ON FUNCTION public.rls_citations_edit(record public.citations) TO service_role;


--
-- Name: TABLE countries; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.countries TO anon;
GRANT ALL ON TABLE public.countries TO authenticated;
GRANT ALL ON TABLE public.countries TO service_role;


--
-- Name: FUNCTION rls_countries_delete(record public.countries); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.rls_countries_delete(record public.countries) TO anon;
GRANT ALL ON FUNCTION public.rls_countries_delete(record public.countries) TO authenticated;
GRANT ALL ON FUNCTION public.rls_countries_delete(record public.countries) TO service_role;


--
-- Name: FUNCTION rls_countries_edit(record public.countries); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.rls_countries_edit(record public.countries) TO anon;
GRANT ALL ON FUNCTION public.rls_countries_edit(record public.countries) TO authenticated;
GRANT ALL ON FUNCTION public.rls_countries_edit(record public.countries) TO service_role;


--
-- Name: TABLE events; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.events TO anon;
GRANT ALL ON TABLE public.events TO authenticated;
GRANT ALL ON TABLE public.events TO service_role;


--
-- Name: FUNCTION rls_events_delete(record public.events); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.rls_events_delete(record public.events) TO anon;
GRANT ALL ON FUNCTION public.rls_events_delete(record public.events) TO authenticated;
GRANT ALL ON FUNCTION public.rls_events_delete(record public.events) TO service_role;


--
-- Name: FUNCTION rls_events_edit(record public.events); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.rls_events_edit(record public.events) TO anon;
GRANT ALL ON FUNCTION public.rls_events_edit(record public.events) TO authenticated;
GRANT ALL ON FUNCTION public.rls_events_edit(record public.events) TO service_role;


--
-- Name: TABLE places; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.places TO anon;
GRANT ALL ON TABLE public.places TO authenticated;
GRANT ALL ON TABLE public.places TO service_role;


--
-- Name: FUNCTION rls_places_delete(record public.places); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.rls_places_delete(record public.places) TO anon;
GRANT ALL ON FUNCTION public.rls_places_delete(record public.places) TO authenticated;
GRANT ALL ON FUNCTION public.rls_places_delete(record public.places) TO service_role;


--
-- Name: FUNCTION rls_places_edit(record public.places); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.rls_places_edit(record public.places) TO anon;
GRANT ALL ON FUNCTION public.rls_places_edit(record public.places) TO authenticated;
GRANT ALL ON FUNCTION public.rls_places_edit(record public.places) TO service_role;


--
-- Name: TABLE profiles; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.profiles TO anon;
GRANT ALL ON TABLE public.profiles TO authenticated;
GRANT ALL ON TABLE public.profiles TO service_role;


--
-- Name: FUNCTION rls_profiles_edit(records public.profiles[]); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.rls_profiles_edit(records public.profiles[]) TO anon;
GRANT ALL ON FUNCTION public.rls_profiles_edit(records public.profiles[]) TO authenticated;
GRANT ALL ON FUNCTION public.rls_profiles_edit(records public.profiles[]) TO service_role;


--
-- Name: FUNCTION rls_profiles_edit(record public.profiles); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.rls_profiles_edit(record public.profiles) TO anon;
GRANT ALL ON FUNCTION public.rls_profiles_edit(record public.profiles) TO authenticated;
GRANT ALL ON FUNCTION public.rls_profiles_edit(record public.profiles) TO service_role;


--
-- Name: TABLE towns; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.towns TO anon;
GRANT ALL ON TABLE public.towns TO authenticated;
GRANT ALL ON TABLE public.towns TO service_role;


--
-- Name: FUNCTION rls_towns_delete(record public.towns); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.rls_towns_delete(record public.towns) TO anon;
GRANT ALL ON FUNCTION public.rls_towns_delete(record public.towns) TO authenticated;
GRANT ALL ON FUNCTION public.rls_towns_delete(record public.towns) TO service_role;


--
-- Name: FUNCTION rls_towns_edit(record public.towns); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.rls_towns_edit(record public.towns) TO anon;
GRANT ALL ON FUNCTION public.rls_towns_edit(record public.towns) TO authenticated;
GRANT ALL ON FUNCTION public.rls_towns_edit(record public.towns) TO service_role;


--
-- Name: FUNCTION set_claim(uid uuid, claim text, value jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.set_claim(uid uuid, claim text, value jsonb) TO anon;
GRANT ALL ON FUNCTION public.set_claim(uid uuid, claim text, value jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.set_claim(uid uuid, claim text, value jsonb) TO service_role;


--
-- Name: FUNCTION temporary_fn(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.temporary_fn() TO anon;
GRANT ALL ON FUNCTION public.temporary_fn() TO authenticated;
GRANT ALL ON FUNCTION public.temporary_fn() TO service_role;


--
-- Name: FUNCTION can_insert_object(bucketid text, name text, owner uuid, metadata jsonb); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) TO postgres;


--
-- Name: FUNCTION extension(name text); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.extension(name text) TO anon;
GRANT ALL ON FUNCTION storage.extension(name text) TO authenticated;
GRANT ALL ON FUNCTION storage.extension(name text) TO service_role;
GRANT ALL ON FUNCTION storage.extension(name text) TO dashboard_user;
GRANT ALL ON FUNCTION storage.extension(name text) TO postgres;


--
-- Name: FUNCTION filename(name text); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.filename(name text) TO anon;
GRANT ALL ON FUNCTION storage.filename(name text) TO authenticated;
GRANT ALL ON FUNCTION storage.filename(name text) TO service_role;
GRANT ALL ON FUNCTION storage.filename(name text) TO dashboard_user;
GRANT ALL ON FUNCTION storage.filename(name text) TO postgres;


--
-- Name: FUNCTION foldername(name text); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.foldername(name text) TO anon;
GRANT ALL ON FUNCTION storage.foldername(name text) TO authenticated;
GRANT ALL ON FUNCTION storage.foldername(name text) TO service_role;
GRANT ALL ON FUNCTION storage.foldername(name text) TO dashboard_user;
GRANT ALL ON FUNCTION storage.foldername(name text) TO postgres;


--
-- Name: FUNCTION get_size_by_bucket(); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.get_size_by_bucket() TO postgres;


--
-- Name: FUNCTION search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) TO postgres;


--
-- Name: FUNCTION update_updated_at_column(); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.update_updated_at_column() TO postgres;


--
-- Name: TABLE audit_log_entries; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.audit_log_entries TO dashboard_user;
GRANT ALL ON TABLE auth.audit_log_entries TO postgres;


--
-- Name: TABLE flow_state; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.flow_state TO postgres;
GRANT ALL ON TABLE auth.flow_state TO dashboard_user;


--
-- Name: TABLE identities; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.identities TO postgres;
GRANT ALL ON TABLE auth.identities TO dashboard_user;


--
-- Name: TABLE instances; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.instances TO dashboard_user;
GRANT ALL ON TABLE auth.instances TO postgres;


--
-- Name: TABLE mfa_amr_claims; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.mfa_amr_claims TO postgres;
GRANT ALL ON TABLE auth.mfa_amr_claims TO dashboard_user;


--
-- Name: TABLE mfa_challenges; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.mfa_challenges TO postgres;
GRANT ALL ON TABLE auth.mfa_challenges TO dashboard_user;


--
-- Name: TABLE mfa_factors; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.mfa_factors TO postgres;
GRANT ALL ON TABLE auth.mfa_factors TO dashboard_user;


--
-- Name: TABLE refresh_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.refresh_tokens TO dashboard_user;
GRANT ALL ON TABLE auth.refresh_tokens TO postgres;


--
-- Name: SEQUENCE refresh_tokens_id_seq; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO dashboard_user;
GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO postgres;


--
-- Name: TABLE saml_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.saml_providers TO postgres;
GRANT ALL ON TABLE auth.saml_providers TO dashboard_user;


--
-- Name: TABLE saml_relay_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.saml_relay_states TO postgres;
GRANT ALL ON TABLE auth.saml_relay_states TO dashboard_user;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.schema_migrations TO dashboard_user;
GRANT ALL ON TABLE auth.schema_migrations TO postgres;


--
-- Name: TABLE sessions; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.sessions TO postgres;
GRANT ALL ON TABLE auth.sessions TO dashboard_user;


--
-- Name: TABLE sso_domains; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.sso_domains TO postgres;
GRANT ALL ON TABLE auth.sso_domains TO dashboard_user;


--
-- Name: TABLE sso_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.sso_providers TO postgres;
GRANT ALL ON TABLE auth.sso_providers TO dashboard_user;


--
-- Name: TABLE users; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.users TO dashboard_user;
GRANT ALL ON TABLE auth.users TO postgres;


--
-- Name: TABLE pg_stat_statements; Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON TABLE extensions.pg_stat_statements TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE extensions.pg_stat_statements TO dashboard_user;


--
-- Name: TABLE pg_stat_statements_info; Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON TABLE extensions.pg_stat_statements_info TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE extensions.pg_stat_statements_info TO dashboard_user;


--
-- Name: TABLE decrypted_key; Type: ACL; Schema: pgsodium; Owner: supabase_admin
--

GRANT ALL ON TABLE pgsodium.decrypted_key TO pgsodium_keyholder;


--
-- Name: TABLE masking_rule; Type: ACL; Schema: pgsodium; Owner: supabase_admin
--

GRANT ALL ON TABLE pgsodium.masking_rule TO pgsodium_keyholder;


--
-- Name: TABLE mask_columns; Type: ACL; Schema: pgsodium; Owner: supabase_admin
--

GRANT ALL ON TABLE pgsodium.mask_columns TO pgsodium_keyholder;


--
-- Name: SEQUENCE author_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.author_id_seq TO anon;
GRANT ALL ON SEQUENCE public.author_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.author_id_seq TO service_role;


--
-- Name: SEQUENCE citations_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.citations_id_seq TO anon;
GRANT ALL ON SEQUENCE public.citations_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.citations_id_seq TO service_role;


--
-- Name: SEQUENCE country_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.country_id_seq TO anon;
GRANT ALL ON SEQUENCE public.country_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.country_id_seq TO service_role;


--
-- Name: SEQUENCE event_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.event_id_seq TO anon;
GRANT ALL ON SEQUENCE public.event_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.event_id_seq TO service_role;


--
-- Name: SEQUENCE place_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.place_id_seq TO anon;
GRANT ALL ON SEQUENCE public.place_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.place_id_seq TO service_role;


--
-- Name: SEQUENCE profiles_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.profiles_id_seq TO anon;
GRANT ALL ON SEQUENCE public.profiles_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.profiles_id_seq TO service_role;


--
-- Name: TABLE rls_edit_for_table; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.rls_edit_for_table TO anon;
GRANT ALL ON TABLE public.rls_edit_for_table TO authenticated;
GRANT ALL ON TABLE public.rls_edit_for_table TO service_role;


--
-- Name: SEQUENCE town_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.town_id_seq TO anon;
GRANT ALL ON SEQUENCE public.town_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.town_id_seq TO service_role;


--
-- Name: TABLE trusts; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.trusts TO anon;
GRANT ALL ON TABLE public.trusts TO authenticated;
GRANT ALL ON TABLE public.trusts TO service_role;


--
-- Name: SEQUENCE trusts_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.trusts_id_seq TO anon;
GRANT ALL ON SEQUENCE public.trusts_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.trusts_id_seq TO service_role;


--
-- Name: TABLE buckets; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.buckets TO anon;
GRANT ALL ON TABLE storage.buckets TO authenticated;
GRANT ALL ON TABLE storage.buckets TO service_role;
GRANT ALL ON TABLE storage.buckets TO postgres;


--
-- Name: TABLE migrations; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.migrations TO anon;
GRANT ALL ON TABLE storage.migrations TO authenticated;
GRANT ALL ON TABLE storage.migrations TO service_role;
GRANT ALL ON TABLE storage.migrations TO postgres;


--
-- Name: TABLE objects; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.objects TO anon;
GRANT ALL ON TABLE storage.objects TO authenticated;
GRANT ALL ON TABLE storage.objects TO service_role;
GRANT ALL ON TABLE storage.objects TO postgres;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON SEQUENCES TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON FUNCTIONS TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON TABLES TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: pgsodium; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA pgsodium GRANT ALL ON SEQUENCES TO pgsodium_keyholder;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: pgsodium; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA pgsodium GRANT ALL ON TABLES TO pgsodium_keyholder;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: pgsodium_masks; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA pgsodium_masks GRANT ALL ON SEQUENCES TO pgsodium_keyiduser;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: pgsodium_masks; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA pgsodium_masks GRANT ALL ON FUNCTIONS TO pgsodium_keyiduser;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: pgsodium_masks; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA pgsodium_masks GRANT ALL ON TABLES TO pgsodium_keyiduser;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO service_role;


--
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


ALTER EVENT TRIGGER issue_graphql_placeholder OWNER TO supabase_admin;

--
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


ALTER EVENT TRIGGER issue_pg_cron_access OWNER TO supabase_admin;

--
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE FUNCTION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


ALTER EVENT TRIGGER issue_pg_graphql_access OWNER TO supabase_admin;

--
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: postgres
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


ALTER EVENT TRIGGER issue_pg_net_access OWNER TO postgres;

--
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


ALTER EVENT TRIGGER pgrst_ddl_watch OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


ALTER EVENT TRIGGER pgrst_drop_watch OWNER TO supabase_admin;

--
-- PostgreSQL database dump complete
--

