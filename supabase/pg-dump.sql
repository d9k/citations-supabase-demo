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

SET default_tablespace = '';

SET default_table_access_method = heap;

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
    birth_town bigint
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
    event_id bigint
);


ALTER TABLE public.citations OWNER TO postgres;

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
-- Name: event; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.event (
    id bigint NOT NULL,
    name text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    start_year bigint NOT NULL,
    start_month smallint NOT NULL,
    end_year bigint,
    end_month smallint,
    place_id bigint
);


ALTER TABLE public.event OWNER TO postgres;

--
-- Name: event_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.event ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.event_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: place; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.place (
    id bigint NOT NULL,
    name text DEFAULT 'in'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    town_id bigint NOT NULL
);


ALTER TABLE public.place OWNER TO postgres;

--
-- Name: place_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.place ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.place_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


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
    CONSTRAINT username_length CHECK ((char_length(username) >= 3))
);


ALTER TABLE public.profiles OWNER TO postgres;

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
-- Name: town; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.town (
    id bigint NOT NULL,
    name text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    country_id bigint NOT NULL
);


ALTER TABLE public.town OWNER TO postgres;

--
-- Name: town_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.town ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.town_id_seq
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
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) FROM stdin;
00000000-0000-0000-0000-000000000000	a4135c80-3644-469a-aebf-ce9353e8cb0b	{"action":"user_confirmation_requested","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2023-11-30 13:19:57.232896+00	
00000000-0000-0000-0000-000000000000	812fa99f-abf6-4543-b8f5-3d95c9c7d706	{"action":"user_signedup","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"team"}	2023-11-30 13:20:52.159658+00	
00000000-0000-0000-0000-000000000000	daf1ff5b-ee21-4c16-8eeb-fe748263b95a	{"action":"user_recovery_requested","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"user"}	2023-11-30 13:38:54.885305+00	
00000000-0000-0000-0000-000000000000	d341f631-52e6-48db-a2b8-a0a209390701	{"action":"login","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"account"}	2023-11-30 13:39:17.678945+00	
00000000-0000-0000-0000-000000000000	46e44cb9-a6c2-459d-8a8e-21aed29abbb1	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-11-30 13:52:36.558289+00	
00000000-0000-0000-0000-000000000000	7bda9421-8bfc-4c38-a392-f0c1c0be8e13	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-11-30 13:52:36.558931+00	
00000000-0000-0000-0000-000000000000	9373345b-f106-40ba-8070-1a6b94d88962	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-11-30 13:52:36.581445+00	
00000000-0000-0000-0000-000000000000	e1c8e364-aad3-49a0-b68a-77227799c924	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 04:00:53.0263+00	
00000000-0000-0000-0000-000000000000	e200cf41-4b1c-469e-a9af-0acaadbd27b5	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 04:00:53.026948+00	
00000000-0000-0000-0000-000000000000	42a5ff7a-2891-4ac9-9092-e5839de621f6	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 04:00:53.037951+00	
00000000-0000-0000-0000-000000000000	60bc81c0-ffcb-4880-a0c0-8a73537f0064	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 04:14:53.575288+00	
00000000-0000-0000-0000-000000000000	6714410d-9d77-4c92-ae4c-9c752321f286	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 04:14:53.612702+00	
00000000-0000-0000-0000-000000000000	d771fc72-cf31-4bf3-a9fd-f5bce7c744a0	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 05:08:02.554287+00	
00000000-0000-0000-0000-000000000000	9781e840-9361-411b-a3bd-724cb790b275	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 05:08:02.554945+00	
00000000-0000-0000-0000-000000000000	3aca2753-d11a-422b-978b-66a2035bcde7	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 05:08:02.567581+00	
00000000-0000-0000-0000-000000000000	d29e1016-608e-4683-8c3c-1d2100ea0466	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 05:40:08.258099+00	
00000000-0000-0000-0000-000000000000	83c35d4e-ebd0-462d-928c-71268eeaac78	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 05:40:08.258731+00	
00000000-0000-0000-0000-000000000000	ccefbf2f-cd97-4bc1-8c93-51137a7056f6	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 05:40:14.735063+00	
00000000-0000-0000-0000-000000000000	6209f4c9-75f9-469c-8c19-000e4966af89	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 05:40:15.129802+00	
00000000-0000-0000-0000-000000000000	a15b9dfc-efea-4736-aeeb-4a1aa216131f	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 05:59:48.427417+00	
00000000-0000-0000-0000-000000000000	76a7b218-ca6f-448b-8b12-7c411801c2a3	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 05:59:48.428064+00	
00000000-0000-0000-0000-000000000000	dfd14eb4-9e8b-4cb7-b209-3d0333fbbe0d	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 05:59:48.578487+00	
00000000-0000-0000-0000-000000000000	7aca200a-b914-4875-b01f-26cef042e015	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 06:12:55.503195+00	
00000000-0000-0000-0000-000000000000	211c2b8c-2160-4df3-93a3-db2e01e8d4a1	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 06:12:55.504001+00	
00000000-0000-0000-0000-000000000000	eb334b0e-3a0f-44a0-ab88-7e02b1b139dc	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 06:26:25.597069+00	
00000000-0000-0000-0000-000000000000	859f5bfc-5a8d-4ff2-ae3c-8438053363af	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 06:26:25.597731+00	
00000000-0000-0000-0000-000000000000	7ba23e3f-2e97-4803-9b26-4702d1056110	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 06:39:55.612799+00	
00000000-0000-0000-0000-000000000000	90cde9e5-96f7-4c9e-9458-eff1312b5a9b	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 06:39:55.613545+00	
00000000-0000-0000-0000-000000000000	c02d223a-46e8-4117-b24a-49b39471e2de	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 06:53:25.628713+00	
00000000-0000-0000-0000-000000000000	5601b2d4-7b9a-4011-af59-8c032e5438da	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 06:53:25.629257+00	
00000000-0000-0000-0000-000000000000	ea0c0e54-d68b-494f-86ea-46c642b0a2f2	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 07:06:55.648826+00	
00000000-0000-0000-0000-000000000000	85901237-898a-41a3-90a2-dc97828c6fb3	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 07:06:55.649454+00	
00000000-0000-0000-0000-000000000000	e5dec2af-d58e-4e91-891c-d4dfb175b553	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 07:20:25.704152+00	
00000000-0000-0000-0000-000000000000	b2bad58c-c491-4311-b958-a45cf0cb7a01	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 07:20:25.704765+00	
00000000-0000-0000-0000-000000000000	c7082d95-0e8f-4df7-82cf-9fbe5a7a355c	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 07:33:55.886661+00	
00000000-0000-0000-0000-000000000000	0562d7b8-adbf-449a-bc3a-d5214625a5f0	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 07:33:55.887259+00	
00000000-0000-0000-0000-000000000000	b384d1bc-82d6-432b-8d92-a4731f96d1de	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 07:47:25.756688+00	
00000000-0000-0000-0000-000000000000	510085d0-d56b-4730-80f7-f6235145d342	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 07:47:25.757349+00	
00000000-0000-0000-0000-000000000000	57ba2785-1766-4ff4-9346-59568d23d87d	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 08:00:55.940704+00	
00000000-0000-0000-0000-000000000000	56836186-7046-4db9-aeda-8db9adba78b0	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 08:00:55.941292+00	
00000000-0000-0000-0000-000000000000	0118f6c2-046f-44c3-bcb4-093354f68cc5	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 08:13:55.847285+00	
00000000-0000-0000-0000-000000000000	19f87193-9125-42cb-a094-6afbe29f02bb	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 08:13:55.847889+00	
00000000-0000-0000-0000-000000000000	777940e6-59fc-45aa-a2fe-5a95ab9390fc	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 08:26:55.920386+00	
00000000-0000-0000-0000-000000000000	55b8108a-7e34-4d21-b4a2-e868f13a000a	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 08:26:55.921092+00	
00000000-0000-0000-0000-000000000000	36922172-203a-4a5c-9431-0c7a5ddf3458	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 08:39:55.903912+00	
00000000-0000-0000-0000-000000000000	04a4ec0e-6a7f-4417-873b-1e82444142d5	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 08:39:55.904553+00	
00000000-0000-0000-0000-000000000000	3b15922c-81a9-40ec-b179-6df468cd4389	{"action":"user_recovery_requested","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"user"}	2023-12-01 09:08:08.152349+00	
00000000-0000-0000-0000-000000000000	6d4129e3-340e-4fba-a5e7-0fb20ec0917a	{"action":"login","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"account"}	2023-12-01 09:08:48.218735+00	
00000000-0000-0000-0000-000000000000	265feac9-b63b-476b-a46e-753cf706ecdf	{"action":"user_recovery_requested","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"user"}	2023-12-01 09:13:59.88915+00	
00000000-0000-0000-0000-000000000000	72058cf1-c43b-4242-bf63-d9a01e7df2eb	{"action":"login","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"account"}	2023-12-01 09:14:19.500949+00	
00000000-0000-0000-0000-000000000000	216ade29-751d-4267-8cb0-404128bbce2e	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 09:27:47.792537+00	
00000000-0000-0000-0000-000000000000	714bb6ef-0ac1-4a57-b5cc-2bc23cdf2314	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 09:27:47.793248+00	
00000000-0000-0000-0000-000000000000	82d181ee-c682-4641-b6cd-2d9c9abfc690	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 09:27:47.813286+00	
00000000-0000-0000-0000-000000000000	4d3f51e0-c7bc-4730-87b1-684de222a7a9	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 09:40:48.153767+00	
00000000-0000-0000-0000-000000000000	a7c7a186-d604-4dcf-a27a-787c16298615	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 09:40:48.154534+00	
00000000-0000-0000-0000-000000000000	318a53e8-b367-471f-b4b3-ba34f990663e	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 09:51:42.953462+00	
00000000-0000-0000-0000-000000000000	c56ad1e3-d2f8-4c06-ae43-f461cef06d95	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 09:51:59.740693+00	
00000000-0000-0000-0000-000000000000	6e0d08f2-1a1d-4ef0-be99-735acb4b4c70	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 09:53:02.208353+00	
00000000-0000-0000-0000-000000000000	64c93825-4553-4e2a-86a0-e7dee3c311ee	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 09:53:18.428464+00	
00000000-0000-0000-0000-000000000000	8b01604c-de53-41e6-84f5-5db202f44849	{"action":"user_recovery_requested","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"user"}	2023-12-01 09:53:40.687571+00	
00000000-0000-0000-0000-000000000000	ef989743-ebdd-4dd8-b0c4-a30a0f322dd5	{"action":"login","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"account"}	2023-12-01 09:54:31.995629+00	
00000000-0000-0000-0000-000000000000	a1371028-b82c-4cfb-be27-4ce4a4fb31e3	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 09:54:32.785933+00	
00000000-0000-0000-0000-000000000000	ca2f6b74-0405-41ea-aef7-36492681c5ed	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 10:06:48.329454+00	
00000000-0000-0000-0000-000000000000	43529386-fca6-4064-a2eb-3f15231e5b6b	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 10:06:48.330188+00	
00000000-0000-0000-0000-000000000000	0ee51af5-ce2d-44e0-b700-803f60d7ba55	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 10:07:32.683346+00	
00000000-0000-0000-0000-000000000000	3d854090-9207-4f3f-8716-ea09e8ea4075	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 10:07:39.128268+00	
00000000-0000-0000-0000-000000000000	36f606a9-9e9a-4b11-865d-fd119e28965b	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 10:07:39.12888+00	
00000000-0000-0000-0000-000000000000	9c1d0821-2f56-4ebc-87f3-067a61d99f99	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 10:07:41.843264+00	
00000000-0000-0000-0000-000000000000	ac25d83d-1f88-4684-98e8-715118ab09f4	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 10:07:42.024449+00	
00000000-0000-0000-0000-000000000000	2e57b502-7f02-4643-b921-2ffc0dfcabcd	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 10:07:45.109616+00	
00000000-0000-0000-0000-000000000000	006ea003-12e5-4c47-802a-bd45d1b0a43b	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 16:49:09.292322+00	
00000000-0000-0000-0000-000000000000	c5460bf8-6184-4133-b919-d16db8414325	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 16:49:09.293161+00	
00000000-0000-0000-0000-000000000000	4ee997f3-e27b-48d3-b1b1-8fb6bbaffe63	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 16:49:09.319666+00	
00000000-0000-0000-0000-000000000000	74772e51-c294-4593-95b5-ab9b3d97fbaf	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 16:49:11.603287+00	
00000000-0000-0000-0000-000000000000	6c7a514d-4b45-448c-8cc9-8ed8feec93c6	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 16:49:11.609621+00	
00000000-0000-0000-0000-000000000000	cf6e7c7f-01bd-4c69-adca-215e3858621d	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 16:49:11.610498+00	
00000000-0000-0000-0000-000000000000	5f04c34a-8ce9-424a-a275-4cb76a034247	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 16:49:11.638014+00	
00000000-0000-0000-0000-000000000000	d9ca2b1e-5dc2-495e-af9a-405bf5a6011e	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 16:49:12.854662+00	
00000000-0000-0000-0000-000000000000	21ee59ae-cd9f-43f3-bdfa-5454d848293b	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 17:02:13.568864+00	
00000000-0000-0000-0000-000000000000	bbc285df-d5d3-48a5-ada2-6683871735ad	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 17:02:13.569483+00	
00000000-0000-0000-0000-000000000000	41c09b7d-8803-4f15-80bd-f2a264a9afd9	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 17:02:41.102999+00	
00000000-0000-0000-0000-000000000000	9560141e-5a14-4bbc-aecd-136beb681a33	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 17:02:41.103661+00	
00000000-0000-0000-0000-000000000000	f20a2406-c7b0-41f2-a8ea-5cc2811c12d5	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 17:02:41.316281+00	
00000000-0000-0000-0000-000000000000	c6c63b2b-f166-4b68-8ba7-e1038eb24ed6	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 17:02:41.413879+00	
00000000-0000-0000-0000-000000000000	c8126153-a6cd-409a-8172-d82faa2d3a0a	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 17:09:17.141952+00	
00000000-0000-0000-0000-000000000000	0d0463af-253f-44c5-a51e-06448681697d	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 17:09:17.150187+00	
00000000-0000-0000-0000-000000000000	7f610104-a684-4dd8-a3a5-de4ffef81720	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 17:15:43.632601+00	
00000000-0000-0000-0000-000000000000	063afbae-989c-4f46-879d-83874063f3c1	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 17:15:43.633196+00	
00000000-0000-0000-0000-000000000000	8c49fad3-9d78-40b0-bd00-94631f7b2af6	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 17:16:11.35709+00	
00000000-0000-0000-0000-000000000000	e3374e1a-2529-4d98-82dc-296bb356f360	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 17:16:11.44136+00	
00000000-0000-0000-0000-000000000000	5905aee3-f11a-45ce-ab7d-f79e2598d3c8	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 17:16:11.442333+00	
00000000-0000-0000-0000-000000000000	31f88dca-e07e-4124-828a-18a67ea61452	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 17:16:11.462768+00	
00000000-0000-0000-0000-000000000000	e4e6f247-b0d3-404f-8aa5-f1d95f2c91f8	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 17:22:32.661794+00	
00000000-0000-0000-0000-000000000000	53f82cfe-5951-4801-b750-535afe8b2fe0	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 17:22:35.549581+00	
00000000-0000-0000-0000-000000000000	a2d7eb48-f135-462a-9359-573af209fc37	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 17:22:35.854059+00	
00000000-0000-0000-0000-000000000000	ff90b1b3-0a3e-44e1-bf31-5a4739922b42	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 17:39:41.159778+00	
00000000-0000-0000-0000-000000000000	1410bebb-ca6e-464b-af0f-b2feb4f104af	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 17:39:41.160333+00	
00000000-0000-0000-0000-000000000000	66854640-02d5-4d45-9f2e-00b114053f91	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 17:39:41.179271+00	
00000000-0000-0000-0000-000000000000	d6ab94b3-8178-4ddf-8b04-2eb4886faba7	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 17:56:11.373911+00	
00000000-0000-0000-0000-000000000000	a9ec6ee8-0c9e-4874-94ef-adab736a7c87	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 17:56:11.374565+00	
00000000-0000-0000-0000-000000000000	3176cf75-762c-4cff-b528-39f16a0ad2ed	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 17:56:13.719464+00	
00000000-0000-0000-0000-000000000000	f1efddf1-3ef7-4663-92dd-be5ce307dea4	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 17:56:13.735736+00	
00000000-0000-0000-0000-000000000000	682de105-e71f-4dc6-a193-9d30093094f6	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 17:56:37.936389+00	
00000000-0000-0000-0000-000000000000	d14a4742-6563-4467-854f-1d3af7f0aa5f	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 17:56:38.250101+00	
00000000-0000-0000-0000-000000000000	ce2eeb45-000b-4394-88b6-c0e0c75d8021	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 17:57:20.647524+00	
00000000-0000-0000-0000-000000000000	ce72de9a-5d1d-4199-9caf-eb64646cae3c	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 17:57:21.918453+00	
00000000-0000-0000-0000-000000000000	9be67a3b-ceba-4c70-85b7-600dbeba2d1b	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 17:57:22.928397+00	
00000000-0000-0000-0000-000000000000	a281f6bd-f160-4a20-a7fb-2a05eae390fc	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 17:57:24.159859+00	
00000000-0000-0000-0000-000000000000	56cecde2-fa6d-44ed-8521-f5b828326b9c	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 17:57:24.624+00	
00000000-0000-0000-0000-000000000000	db5ecce4-60b5-4249-ade5-b9557f1b1635	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 17:57:26.123052+00	
00000000-0000-0000-0000-000000000000	dd89a3c8-579a-438b-8530-336889ca2d41	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 17:57:27.289175+00	
00000000-0000-0000-0000-000000000000	bf064a77-e3f7-48ce-8719-a848471eedf2	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 17:57:30.421344+00	
00000000-0000-0000-0000-000000000000	6f68c826-f573-4fc1-8879-e3e5cca8146d	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 17:57:30.772771+00	
00000000-0000-0000-0000-000000000000	bfd2470b-71b8-46b8-8224-757f5f91c29a	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 17:57:32.998318+00	
00000000-0000-0000-0000-000000000000	9cbfd358-ae61-4383-a05a-ee4455ce9655	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 17:57:33.009704+00	
00000000-0000-0000-0000-000000000000	22e006f0-e03d-45f3-849d-ef0f499a3fe8	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 18:26:18.987536+00	
00000000-0000-0000-0000-000000000000	3334e91c-9e29-4a94-9414-292c24da6e2f	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 18:26:18.988287+00	
00000000-0000-0000-0000-000000000000	a7a3feac-468b-4130-a8fe-37efffcd2173	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 18:26:19.005931+00	
00000000-0000-0000-0000-000000000000	29b64fdf-f4a5-44bc-a535-ba6fcf046ed4	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 18:52:22.250517+00	
00000000-0000-0000-0000-000000000000	3e720e04-278b-456a-976c-21edcb1de16f	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 18:52:22.251101+00	
00000000-0000-0000-0000-000000000000	a2a9f13a-ec24-4b88-a291-d471fbc55259	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 18:52:22.310604+00	
00000000-0000-0000-0000-000000000000	8d45e37b-a026-493b-8540-5685c4062155	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 18:52:22.967969+00	
00000000-0000-0000-0000-000000000000	444fc8d0-a353-4375-bf14-49c204eaa91f	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 18:52:37.054306+00	
00000000-0000-0000-0000-000000000000	552978cc-54c8-4e0a-bf24-266449458fe8	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 18:52:47.744479+00	
00000000-0000-0000-0000-000000000000	240b02d7-bf46-4c11-8a99-29cfd9b8bc06	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 18:52:51.148503+00	
00000000-0000-0000-0000-000000000000	22a8cb7b-d1cb-4fb9-8b28-5db048c0b89f	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 18:53:13.847318+00	
00000000-0000-0000-0000-000000000000	bef4e00f-c7a3-4c80-8f8d-878d921cd184	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 18:53:19.942823+00	
00000000-0000-0000-0000-000000000000	0059c8d1-3d6b-4937-ba51-82b37ba6f6e1	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 18:54:23.787128+00	
00000000-0000-0000-0000-000000000000	1eff220f-378b-4316-b649-a891a08ab6eb	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 18:54:31.020182+00	
00000000-0000-0000-0000-000000000000	545d8cef-07e4-4ac4-99a9-b2d903573671	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 19:05:23.300844+00	
00000000-0000-0000-0000-000000000000	757abe94-fd22-4efb-9054-8682fec6e134	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 19:05:23.301436+00	
00000000-0000-0000-0000-000000000000	dd727276-8f52-45c5-958f-d77d2d63532b	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 19:05:48.065779+00	
00000000-0000-0000-0000-000000000000	ab1d4ed9-1a87-446d-bcc8-9c2024070f46	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 19:05:51.195146+00	
00000000-0000-0000-0000-000000000000	3beae254-aabd-4b2f-84f6-22004bdc2342	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-01 19:06:07.37785+00	
00000000-0000-0000-0000-000000000000	79985818-8c0a-4da4-bc88-ffa04ff655ea	{"action":"user_recovery_requested","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"user"}	2023-12-02 06:31:37.002279+00	
00000000-0000-0000-0000-000000000000	8a4eb862-d681-4ca0-9505-86b2a0975e0a	{"action":"login","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"account"}	2023-12-02 06:31:58.445605+00	
00000000-0000-0000-0000-000000000000	8f447319-80ff-41b2-b0c9-ab42a7dd1c7a	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 16:52:02.118369+00	
00000000-0000-0000-0000-000000000000	bdc9abf3-180d-440a-9ab2-0efce35b7276	{"action":"user_recovery_requested","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"user"}	2023-12-02 06:50:14.0261+00	
00000000-0000-0000-0000-000000000000	aa708551-6711-431f-97aa-4aee9a0a7dcc	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 16:52:02.11961+00	
00000000-0000-0000-0000-000000000000	5dac9d18-803a-4703-97a7-246be3f3de1f	{"action":"login","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"account"}	2023-12-02 06:50:26.4165+00	
00000000-0000-0000-0000-000000000000	e9750531-e7d5-43c2-8516-d6a7282f2637	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 07:03:27.953024+00	
00000000-0000-0000-0000-000000000000	d110de3f-2569-4640-a981-cfe2e5f57827	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 07:03:27.953825+00	
00000000-0000-0000-0000-000000000000	3f44c25e-e320-4a63-9b74-442f97a74432	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 07:03:30.339639+00	
00000000-0000-0000-0000-000000000000	2e609ef2-7014-4463-984a-30b6cb7d6227	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 07:03:45.081955+00	
00000000-0000-0000-0000-000000000000	c4540a6e-6cae-40ab-a67c-083b201f35a8	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 07:03:47.441514+00	
00000000-0000-0000-0000-000000000000	666a336b-42c4-4768-802d-5265e34a3661	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 07:24:56.861971+00	
00000000-0000-0000-0000-000000000000	25243966-5069-4f0a-a45c-8f9407dd1cb8	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 07:24:56.862638+00	
00000000-0000-0000-0000-000000000000	ce56a12c-b945-4f98-b211-2844fc79bf43	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 07:40:56.498277+00	
00000000-0000-0000-0000-000000000000	8f0b6710-561f-4233-b4bb-4df9a3218747	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 07:40:56.498829+00	
00000000-0000-0000-0000-000000000000	31bcc566-1abe-4040-b2a3-6fdbff3f398c	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 07:41:04.060854+00	
00000000-0000-0000-0000-000000000000	9e8ac016-dcca-4d2b-b7cb-1cc3126d4810	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 07:54:14.634632+00	
00000000-0000-0000-0000-000000000000	a2bcc135-55bb-434b-8547-6742df100cfb	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 07:54:14.635327+00	
00000000-0000-0000-0000-000000000000	c22aa58c-e60e-4494-a858-5de1906ac3f0	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 07:54:16.605438+00	
00000000-0000-0000-0000-000000000000	6ec4c054-986b-4bac-b28f-830261c5e8c4	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 07:54:17.716686+00	
00000000-0000-0000-0000-000000000000	b0c9f894-3aa2-4291-83e8-d57f6b8183a5	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 07:54:20.37295+00	
00000000-0000-0000-0000-000000000000	59b2ddb8-8b6b-421b-a7b5-3ebc6bf7a5e2	{"action":"user_recovery_requested","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"user"}	2023-12-02 07:58:53.389251+00	
00000000-0000-0000-0000-000000000000	791dd92a-972f-487c-b8bd-72b7e371a569	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 16:52:02.761985+00	
00000000-0000-0000-0000-000000000000	dfc691df-a841-49d6-b85d-f4ba1599e34a	{"action":"user_recovery_requested","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"user"}	2023-12-02 08:00:59.504685+00	
00000000-0000-0000-0000-000000000000	f5ede003-216d-4e04-ae4a-00b1c3297b84	{"action":"user_recovery_requested","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"user"}	2023-12-02 08:04:46.20832+00	
00000000-0000-0000-0000-000000000000	3076eaba-1608-4cfc-afd1-812db83f382f	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 16:52:21.043608+00	
00000000-0000-0000-0000-000000000000	021e59a9-de7e-4f61-9bf2-c33ac7bd08c2	{"action":"login","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"account"}	2023-12-02 08:05:19.658944+00	
00000000-0000-0000-0000-000000000000	1e304296-e5c4-4d68-a594-39b1a9f1c5d0	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 08:11:07.967811+00	
00000000-0000-0000-0000-000000000000	0fa31a46-36b8-4285-a8a9-a969f5b351f4	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 08:11:07.968409+00	
00000000-0000-0000-0000-000000000000	a9eb7322-a174-4719-8efc-e5d50e474b67	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 08:18:36.048297+00	
00000000-0000-0000-0000-000000000000	371bac48-055d-41ad-b39f-6bfe2f90babf	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 08:18:36.048974+00	
00000000-0000-0000-0000-000000000000	f18253de-f67f-48d0-ae90-0a4733110831	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 08:32:06.123212+00	
00000000-0000-0000-0000-000000000000	49e8d7bb-df87-4a5e-9f1e-48d70050e135	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 08:32:06.123855+00	
00000000-0000-0000-0000-000000000000	4040e199-48dc-4ed4-94de-76999bf60b70	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 08:36:39.863485+00	
00000000-0000-0000-0000-000000000000	91a6b479-f675-4461-bb8d-1c5e00624b00	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 08:36:39.864071+00	
00000000-0000-0000-0000-000000000000	38b51dc6-0a67-4665-8eab-23761c0f8f66	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 08:45:36.081163+00	
00000000-0000-0000-0000-000000000000	0fb145c4-e813-46eb-adbf-dcfa861cf50e	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 08:45:36.08192+00	
00000000-0000-0000-0000-000000000000	06d79258-3edc-49f1-845e-01f62498abfa	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 08:59:06.052572+00	
00000000-0000-0000-0000-000000000000	d5d7e9c8-23e5-47ec-bc93-8e83ec7d552a	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 08:59:06.053255+00	
00000000-0000-0000-0000-000000000000	cfd48e6f-0a8e-4e7d-8dec-902bc6c9af88	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:08:31.279996+00	
00000000-0000-0000-0000-000000000000	b5bb7aff-b75f-4591-bb5b-2b12b3767044	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:08:31.280601+00	
00000000-0000-0000-0000-000000000000	49b2461f-c968-42eb-bd0c-69d6b15cc7ca	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:12:36.23067+00	
00000000-0000-0000-0000-000000000000	eb8fe455-c108-4477-833c-cdcf51090a11	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:12:36.231423+00	
00000000-0000-0000-0000-000000000000	3a923748-9b30-4f1d-b09f-0de575696ecf	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:21:34.980794+00	
00000000-0000-0000-0000-000000000000	3935b1fc-031e-42e3-837f-e69da99c27e8	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:21:34.981434+00	
00000000-0000-0000-0000-000000000000	30f95c51-23a4-435e-99cb-9890e8864e47	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:21:42.706141+00	
00000000-0000-0000-0000-000000000000	2def0340-531b-4997-ad40-d4067913fe33	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:21:51.44142+00	
00000000-0000-0000-0000-000000000000	e3567da2-f7fe-49d3-93de-aad033eca7d2	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:21:51.53377+00	
00000000-0000-0000-0000-000000000000	3cac1d94-3680-4ee1-a1a8-5187ef743c29	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:21:51.980199+00	
00000000-0000-0000-0000-000000000000	730fb1f2-2380-47d8-8a48-21060401fabe	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:21:52.046239+00	
00000000-0000-0000-0000-000000000000	edf02fb8-7022-4c90-924b-b279ab1fd0b0	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:21:52.45373+00	
00000000-0000-0000-0000-000000000000	4c1a7a60-b9de-4d01-93b1-ffa465966506	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:21:52.53231+00	
00000000-0000-0000-0000-000000000000	c0051b91-d281-4deb-9e4a-9372f0f0a423	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:21:52.727196+00	
00000000-0000-0000-0000-000000000000	a45cac73-2d03-4bd2-84d1-11c06c513d86	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:21:52.960535+00	
00000000-0000-0000-0000-000000000000	8539ebc4-829e-4883-aebd-268ac3d95955	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:21:53.200556+00	
00000000-0000-0000-0000-000000000000	a150dacc-a890-463e-b951-40957cbafc4f	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:21:53.405209+00	
00000000-0000-0000-0000-000000000000	5ffe7fe0-9c62-4019-947a-623523d6ee47	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:21:53.448659+00	
00000000-0000-0000-0000-000000000000	ac18fe8a-9eb0-43ba-8b67-6d27fabbad82	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:21:53.688159+00	
00000000-0000-0000-0000-000000000000	aa5dbb31-ac89-491a-87aa-d83bfb926041	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:21:53.862644+00	
00000000-0000-0000-0000-000000000000	0d58db1c-d57c-4df9-bd21-7aa3e159781f	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:21:53.981031+00	
00000000-0000-0000-0000-000000000000	0b39e154-8efb-4e25-ba7d-4da9b3255b21	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:21:54.046973+00	
00000000-0000-0000-0000-000000000000	2347b242-84de-4859-8d18-851094c3775c	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:21:54.277065+00	
00000000-0000-0000-0000-000000000000	cd437ccd-8445-4c61-99fa-61d8677ee13c	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:21:54.413713+00	
00000000-0000-0000-0000-000000000000	5839d700-fa57-45b5-8946-407d5f8db18e	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:21:54.44364+00	
00000000-0000-0000-0000-000000000000	5591b979-a069-4b95-a447-b410ed968145	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:21:54.545371+00	
00000000-0000-0000-0000-000000000000	40bbfe06-6967-4ab6-b3ff-6a647de0a6ab	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:21:54.665118+00	
00000000-0000-0000-0000-000000000000	b2dfc739-1fe7-4446-9649-1800c287da69	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:21:54.985681+00	
00000000-0000-0000-0000-000000000000	0134b9f5-8e70-4639-8d28-9880c9429378	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:21:57.21399+00	
00000000-0000-0000-0000-000000000000	626f0a15-1cc0-4605-b6da-e02d7df778d9	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:26:06.098583+00	
00000000-0000-0000-0000-000000000000	5be9026f-cafc-431e-9345-199819f187c9	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:26:06.099462+00	
00000000-0000-0000-0000-000000000000	b0bd837a-8315-490b-873f-25c625298e40	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:34:43.521818+00	
00000000-0000-0000-0000-000000000000	dc8fbed5-9a6a-4501-9d17-38a76d32e3cc	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:34:43.522502+00	
00000000-0000-0000-0000-000000000000	49c027f5-f75d-410b-83a5-e4776d017c61	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:34:51.517416+00	
00000000-0000-0000-0000-000000000000	f5e2df61-6400-4f34-a010-2ede4304b966	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:34:51.912923+00	
00000000-0000-0000-0000-000000000000	25480996-89be-4c08-88b4-42b1984bb342	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:34:51.936948+00	
00000000-0000-0000-0000-000000000000	af48f29f-8e2d-403e-94db-33d7e89a101b	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:34:52.503539+00	
00000000-0000-0000-0000-000000000000	6fb1f157-f51b-4cf6-a6e3-299b187cd9d8	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:34:52.526568+00	
00000000-0000-0000-0000-000000000000	22348c37-46f2-4c61-800e-686bb511ff12	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:34:52.753083+00	
00000000-0000-0000-0000-000000000000	f54311ae-d8e6-4ef0-81eb-cfc71d731fae	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:34:52.946706+00	
00000000-0000-0000-0000-000000000000	d281c5ba-3f6b-475e-b42e-9ceab5a4319c	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:34:53.224366+00	
00000000-0000-0000-0000-000000000000	012ea08e-ff62-4b51-8931-5b1f06eb481e	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:34:53.395639+00	
00000000-0000-0000-0000-000000000000	30fc9b58-5598-4c48-b21a-b43b48394cc8	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:34:53.560984+00	
00000000-0000-0000-0000-000000000000	68e1a011-c1c6-4c4c-839d-d6ac8e3b2a99	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:34:53.753435+00	
00000000-0000-0000-0000-000000000000	846cbe5e-d93e-462d-8312-c0b312df4d8f	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:34:53.82914+00	
00000000-0000-0000-0000-000000000000	e24dbe29-1c6e-41c3-81ff-2fbafbd3a913	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:34:54.380757+00	
00000000-0000-0000-0000-000000000000	78512937-8d80-4e5e-a6d2-dc35dea7448c	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:34:54.479454+00	
00000000-0000-0000-0000-000000000000	dbeaf97c-6ae1-4990-b81b-ce5da9485b76	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:34:54.860288+00	
00000000-0000-0000-0000-000000000000	2c05db46-a4ac-439b-8bb6-d72d321eefdb	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:34:54.915157+00	
00000000-0000-0000-0000-000000000000	c805b33e-bf93-4193-b36c-b777c4a7b180	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:34:55.06029+00	
00000000-0000-0000-0000-000000000000	62f4302d-e2df-4a4e-880f-97c27446299d	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:35:04.173799+00	
00000000-0000-0000-0000-000000000000	d7281bf8-ff85-4fe0-ba0c-bfa604f2e6fb	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:35:21.79489+00	
00000000-0000-0000-0000-000000000000	75bbd0d8-6c54-4b83-b87b-ba626ec08d6d	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:35:23.06936+00	
00000000-0000-0000-0000-000000000000	9b71cdd1-7550-4791-b801-32dd992f0440	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:35:23.98385+00	
00000000-0000-0000-0000-000000000000	2db5bcb6-ffa1-4d35-9620-85591aa6bba5	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:35:24.164184+00	
00000000-0000-0000-0000-000000000000	dbe68714-4b98-46a1-a2ca-6bbd8b9d7a6e	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:35:26.831104+00	
00000000-0000-0000-0000-000000000000	a5e5fb12-46c6-4b29-9c3b-b9e9de1973b7	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:39:36.232506+00	
00000000-0000-0000-0000-000000000000	839ad2e9-95a6-42e3-8955-ff81220d4252	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:39:36.233174+00	
00000000-0000-0000-0000-000000000000	4157fafc-7486-4da7-b00a-33c8d7babc1e	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:47:51.906301+00	
00000000-0000-0000-0000-000000000000	7d6a4988-ba35-4a82-80f5-8ed4bfbec438	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:47:51.907011+00	
00000000-0000-0000-0000-000000000000	293357e6-5d0c-4bf2-a59a-b40ae5548858	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:47:51.971949+00	
00000000-0000-0000-0000-000000000000	7979ec12-5c14-4318-800f-8d13aa2f9858	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:47:52.24559+00	
00000000-0000-0000-0000-000000000000	88819474-2823-4fdf-9ca8-009100d2f293	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:47:52.515375+00	
00000000-0000-0000-0000-000000000000	61f2c2c7-0db5-4b75-81db-714d077dbdf2	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:47:52.78505+00	
00000000-0000-0000-0000-000000000000	49beb012-6ab7-4741-a7bf-6f6aef11bb3e	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:47:52.813608+00	
00000000-0000-0000-0000-000000000000	ebfe04b0-e486-4e0f-801e-d9c4fcb20649	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:47:52.989868+00	
00000000-0000-0000-0000-000000000000	bf434dec-8aef-4e07-8c31-131b09bd00a0	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:47:53.315529+00	
00000000-0000-0000-0000-000000000000	c6c0123d-a47c-4a1c-af25-ad1ed8fa8775	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:47:53.560648+00	
00000000-0000-0000-0000-000000000000	4b72ae23-86ed-4173-982a-39265f061118	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:47:53.689159+00	
00000000-0000-0000-0000-000000000000	ce7183e2-b399-4186-b1b6-85451ccc2f8f	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:47:53.828316+00	
00000000-0000-0000-0000-000000000000	3bae2b45-6a46-4950-873d-48606d397733	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:47:54.000709+00	
00000000-0000-0000-0000-000000000000	74355ac2-b088-4d06-869d-0c3c8c014a20	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:47:54.300531+00	
00000000-0000-0000-0000-000000000000	b86ef5fd-607a-4358-8254-dd0089c601c8	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:47:54.527558+00	
00000000-0000-0000-0000-000000000000	f89eac3b-cad9-455d-878d-ca2e20a7afe2	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:47:54.768759+00	
00000000-0000-0000-0000-000000000000	9170e301-b70a-4e19-8682-2e730f49d987	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:47:54.926907+00	
00000000-0000-0000-0000-000000000000	44da16d4-661f-4d71-b6c4-fb2ecdf959c7	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:48:04.180113+00	
00000000-0000-0000-0000-000000000000	a0037330-f1e2-4707-b7f8-921c4a26ca45	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:48:12.797998+00	
00000000-0000-0000-0000-000000000000	01bf8f3f-7304-4e09-a792-48afd0e763f8	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:48:21.854305+00	
00000000-0000-0000-0000-000000000000	130cacd0-4930-4742-9509-074191336550	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:48:24.021255+00	
00000000-0000-0000-0000-000000000000	ba09c673-2de2-47ce-9d16-bc9fd8ec6fa5	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:48:24.171148+00	
00000000-0000-0000-0000-000000000000	6835573e-d11c-4302-9de5-9b4fc6e53338	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:48:25.070119+00	
00000000-0000-0000-0000-000000000000	d1b91d8e-4d61-46c8-8f85-a9b8c7105cec	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:48:26.886498+00	
00000000-0000-0000-0000-000000000000	826689b5-2224-48e1-b6d9-f9cc38940601	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:48:53.116524+00	
00000000-0000-0000-0000-000000000000	2e1c64ab-281f-4f03-9cee-8b8f33f8d55d	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:53:06.732735+00	
00000000-0000-0000-0000-000000000000	bf97c62c-0289-4033-8b44-c2a464156829	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 09:53:06.733969+00	
00000000-0000-0000-0000-000000000000	dcbb10b6-a5f6-4c80-9470-846e5a2d0e24	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:00:51.980116+00	
00000000-0000-0000-0000-000000000000	144e9a7f-50ec-44d6-92d0-78627b9c9c73	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:00:51.980729+00	
00000000-0000-0000-0000-000000000000	cf766213-0fa7-452a-9099-ea11da71dc21	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:00:52.020364+00	
00000000-0000-0000-0000-000000000000	85df8bc6-7bc9-4ae5-9d8c-e3d93707867a	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:00:52.548719+00	
00000000-0000-0000-0000-000000000000	7eaf1b04-ee49-428b-81d9-80789d7bdf3c	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:00:52.572446+00	
00000000-0000-0000-0000-000000000000	2ed5b7bb-baf4-4216-9cf6-875f6fb44235	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:00:53.032991+00	
00000000-0000-0000-0000-000000000000	18490133-0e1b-44b2-bac1-6072760001bc	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:00:53.126676+00	
00000000-0000-0000-0000-000000000000	e2d72090-4ce9-4fe4-9c60-f36f91a58a2b	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:00:53.476502+00	
00000000-0000-0000-0000-000000000000	e3c6a1da-2606-4b1e-bfc9-1915bbf4b277	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:00:53.552038+00	
00000000-0000-0000-0000-000000000000	83ff89a9-840a-41e3-80df-114f0ead5826	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:00:53.824416+00	
00000000-0000-0000-0000-000000000000	a6bc883f-3e5b-48fb-b81a-bf0db3943fc8	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:00:53.887338+00	
00000000-0000-0000-0000-000000000000	5c6ad8dc-1494-4a37-a237-ae4337acb108	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:00:54.362591+00	
00000000-0000-0000-0000-000000000000	2cc13129-37ec-493a-9bb0-38962d0a2b05	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:00:54.455635+00	
00000000-0000-0000-0000-000000000000	2662e7d6-20b3-4af9-b38c-21c2befb0cc8	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:00:54.667755+00	
00000000-0000-0000-0000-000000000000	526e8a33-54f6-4c28-bc1d-fdad12019288	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:00:54.780809+00	
00000000-0000-0000-0000-000000000000	ea6deffe-f78d-47be-b0b1-562c491e5b48	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:01:04.227297+00	
00000000-0000-0000-0000-000000000000	3f167d31-8362-4925-8264-73ebee69662a	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:01:12.820579+00	
00000000-0000-0000-0000-000000000000	149ee1ea-2a13-4216-8ab8-66f065e82122	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:01:21.847163+00	
00000000-0000-0000-0000-000000000000	12e8d3a9-1b07-4695-9066-84a9c2292243	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:01:21.957259+00	
00000000-0000-0000-0000-000000000000	2a83867e-c1ba-4760-b7c6-3ee1bdecbe48	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:01:23.913285+00	
00000000-0000-0000-0000-000000000000	5d317e1e-732b-4a71-bcfe-00d8f20b6f71	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:01:24.196025+00	
00000000-0000-0000-0000-000000000000	7241d959-fda4-44aa-983d-cee5982c63ce	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:01:54.13252+00	
00000000-0000-0000-0000-000000000000	47d3877e-68d8-4322-b4c4-4cdd91b5fc99	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:01:55.104222+00	
00000000-0000-0000-0000-000000000000	5aa7d4aa-daed-40b9-b2d7-0f1ab1128621	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:02:23.152428+00	
00000000-0000-0000-0000-000000000000	27d16c9c-1c27-49c8-bc7a-eba0fbd0b53b	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:06:36.436394+00	
00000000-0000-0000-0000-000000000000	9cff2d28-acf3-4aea-8a7c-dd6b74202989	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:06:36.437003+00	
00000000-0000-0000-0000-000000000000	5c0d6c86-75c1-4942-b6f0-4a6e9b641880	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:13:52.043013+00	
00000000-0000-0000-0000-000000000000	71d5a766-6615-4e2e-9fc8-617278c7f7b9	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:13:52.044243+00	
00000000-0000-0000-0000-000000000000	e03e9ac0-228e-4b27-a837-38db1c952e41	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:13:52.613094+00	
00000000-0000-0000-0000-000000000000	4296bf11-1e92-4d3d-aa87-7619629357bd	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:13:52.876039+00	
00000000-0000-0000-0000-000000000000	b420df5e-dd03-429f-81df-e5e7acd2d5df	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:13:53.617686+00	
00000000-0000-0000-0000-000000000000	e33dc3dc-d592-427a-955f-c01c634d2dda	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:13:53.760297+00	
00000000-0000-0000-0000-000000000000	2ad505f4-9a55-434f-ab2a-625241b6464c	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:13:53.882681+00	
00000000-0000-0000-0000-000000000000	aa5e4274-92af-47b4-a793-33c8e79a01c6	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:13:53.925412+00	
00000000-0000-0000-0000-000000000000	ffb1b695-8793-48e1-8c52-5ab40a3b1aa2	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:13:54.383386+00	
00000000-0000-0000-0000-000000000000	15866357-3d54-42d9-8b66-9a474b613213	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:13:54.548966+00	
00000000-0000-0000-0000-000000000000	70cb3d20-c558-4f49-b8ec-4ff6c6f1580c	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:13:54.702677+00	
00000000-0000-0000-0000-000000000000	de811e94-f79d-4e27-9220-b4d4c91f66f7	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:13:54.846734+00	
00000000-0000-0000-0000-000000000000	75253953-12c7-4e46-bb26-7c977afdd3df	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:14:04.262185+00	
00000000-0000-0000-0000-000000000000	aab3b9c1-d1d4-47d5-9594-f5dd1f11c867	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:14:12.865585+00	
00000000-0000-0000-0000-000000000000	0c6b1023-a63d-422e-a2f0-ca2c0b808c34	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:14:21.664819+00	
00000000-0000-0000-0000-000000000000	235d40e5-db3a-42e8-b493-9871e3960b6b	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:14:21.854659+00	
00000000-0000-0000-0000-000000000000	2c7c31a3-89f5-4575-9a3d-67fb03b73d61	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:14:22.029977+00	
00000000-0000-0000-0000-000000000000	4b32d8e9-06bd-4641-b046-0ade84b8b4d7	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:14:22.871231+00	
00000000-0000-0000-0000-000000000000	e1f3da09-3d81-4517-9e32-c2b3d1d9ed78	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:14:23.000919+00	
00000000-0000-0000-0000-000000000000	6d844294-491d-4024-9d2f-5af0ef56a92e	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:14:23.954856+00	
00000000-0000-0000-0000-000000000000	41492ba1-77e1-4838-a8e8-88c0fd7229dc	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:14:24.253731+00	
00000000-0000-0000-0000-000000000000	abf478aa-5c16-4156-b984-a7c9872ec628	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:15:23.245679+00	
00000000-0000-0000-0000-000000000000	00c3d60a-118a-42ce-bc0e-78fcb0ab0775	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:15:24.396173+00	
00000000-0000-0000-0000-000000000000	496a28d9-6c0a-4fe4-8574-539c96612641	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:15:25.137448+00	
00000000-0000-0000-0000-000000000000	fd6eb10a-2f3b-4b0c-883a-e3e40f5b4ba1	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:20:06.165709+00	
00000000-0000-0000-0000-000000000000	9d4c35af-b87e-416a-aa38-25d97f0491c5	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:20:06.166297+00	
00000000-0000-0000-0000-000000000000	b03e2ee7-f664-48bf-bd27-725cfc0c995a	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:26:52.984415+00	
00000000-0000-0000-0000-000000000000	aaff19c0-cdc8-4559-bb52-5e91527c8eed	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:26:52.985158+00	
00000000-0000-0000-0000-000000000000	612b17f5-b79c-4222-85d4-6a900c6df840	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:26:52.997622+00	
00000000-0000-0000-0000-000000000000	02bde897-9af9-45f8-8e4d-ac9628a8600d	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:26:53.353203+00	
00000000-0000-0000-0000-000000000000	fede64c8-3ce4-485b-bd94-1db7e13c344a	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:26:53.775399+00	
00000000-0000-0000-0000-000000000000	a3f97993-0733-42da-ab32-f7317109e4a4	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:26:53.914533+00	
00000000-0000-0000-0000-000000000000	c42d83fb-249a-4b6a-ae14-f27766f882f3	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:26:54.169788+00	
00000000-0000-0000-0000-000000000000	9c41d53a-9f56-4239-b9f9-130e16ca91fb	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:26:54.414526+00	
00000000-0000-0000-0000-000000000000	b5965a3b-8f19-453d-8d46-244b4e5c3498	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:26:54.567156+00	
00000000-0000-0000-0000-000000000000	e20a0542-347c-47a6-8d70-42a7ad3bcec4	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:26:54.705928+00	
00000000-0000-0000-0000-000000000000	b4b5513b-7bfc-41c7-9153-90e92467e548	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:26:54.827023+00	
00000000-0000-0000-0000-000000000000	9dc10e76-b07b-4fac-b783-bd3f4e05f02a	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:27:04.273754+00	
00000000-0000-0000-0000-000000000000	7302baa1-ccfa-47ec-a5bc-a1ab328b2b89	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:27:12.877643+00	
00000000-0000-0000-0000-000000000000	5a0d1f29-e84f-4389-b440-38d28b5b3243	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:27:21.311708+00	
00000000-0000-0000-0000-000000000000	23f5af2c-5e3d-4587-ac9d-c92baa92aefc	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:27:21.706974+00	
00000000-0000-0000-0000-000000000000	e4dd8bde-5089-4d8b-9f92-d3e26dab0d0d	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:27:21.869155+00	
00000000-0000-0000-0000-000000000000	efc5a870-4922-4077-a49a-fdd4d382830b	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:27:22.926408+00	
00000000-0000-0000-0000-000000000000	4492ddd1-054c-4794-995f-250c550d2be2	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:27:23.95487+00	
00000000-0000-0000-0000-000000000000	62eba2dc-560f-498e-8315-62d93a2a095c	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:27:24.261178+00	
00000000-0000-0000-0000-000000000000	52cd8b98-168f-4eae-9d44-b9835181a642	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:27:52.042836+00	
00000000-0000-0000-0000-000000000000	83226d6b-fa3b-4669-9d5f-ca2207bfce5f	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:27:53.100596+00	
00000000-0000-0000-0000-000000000000	39712e85-2054-4a17-ba81-b9f13e69a10d	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:28:23.215044+00	
00000000-0000-0000-0000-000000000000	91ef9e9b-5325-41dc-a169-5c8f1623fe2d	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:28:25.160607+00	
00000000-0000-0000-0000-000000000000	2396d251-6a66-4e6e-86af-891b294d9162	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:28:54.28153+00	
00000000-0000-0000-0000-000000000000	23797d74-e4ee-4cdd-8a1e-77b6426d21b4	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:33:36.123553+00	
00000000-0000-0000-0000-000000000000	d5a5524f-827d-4afa-8b9e-3ec4f3fdf74e	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:33:36.124269+00	
00000000-0000-0000-0000-000000000000	d1686e8d-e534-4e07-82f3-c4a9eabd9fc3	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:39:53.001966+00	
00000000-0000-0000-0000-000000000000	eb3962fd-4e9d-482a-bdb6-25a68e43cc3b	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:39:53.002829+00	
00000000-0000-0000-0000-000000000000	f8a5caea-e1c0-4f81-b6ef-b15e717a5ac3	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:39:53.031639+00	
00000000-0000-0000-0000-000000000000	e358bf9c-ff03-44e0-ae6d-94de2e0d3ff9	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:39:53.356454+00	
00000000-0000-0000-0000-000000000000	4f3d28c1-f979-4777-b694-f4faa8737ec5	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:39:53.550808+00	
00000000-0000-0000-0000-000000000000	25182f98-ee69-4e20-934a-6c741ce9c024	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:39:54.03342+00	
00000000-0000-0000-0000-000000000000	b017050d-e14b-4906-bbb5-43e1c841b023	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:39:54.423581+00	
00000000-0000-0000-0000-000000000000	6ce2138b-958c-4430-8a9d-426efa84cf9f	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:39:54.609102+00	
00000000-0000-0000-0000-000000000000	2e6e9990-9e70-4763-9683-9b98a77ea1c6	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:39:54.76716+00	
00000000-0000-0000-0000-000000000000	6db551a8-644c-4829-8b87-6bfe033a5d0f	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:39:55.171358+00	
00000000-0000-0000-0000-000000000000	b07dc5b6-d49d-47e8-989e-a241dc5b05b1	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:40:04.612302+00	
00000000-0000-0000-0000-000000000000	35e8fa43-d803-4c09-9c6d-113402ada8e2	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:40:12.94424+00	
00000000-0000-0000-0000-000000000000	d88a07c6-36b5-4bbe-bbf3-f5ca6b4b336e	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:40:21.358614+00	
00000000-0000-0000-0000-000000000000	02a9aa92-00ed-4528-a021-85a7bc353c5e	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:40:21.767825+00	
00000000-0000-0000-0000-000000000000	4655155b-840c-4643-a020-02ed45a8adf4	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:40:21.953455+00	
00000000-0000-0000-0000-000000000000	85ecd776-6fa2-4f65-baf8-589fbee874de	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:40:23.106923+00	
00000000-0000-0000-0000-000000000000	d9246e9f-5c0e-49ca-b72f-f548bbe890d8	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:40:23.94384+00	
00000000-0000-0000-0000-000000000000	ef55557c-04f1-410d-99f0-028ccb4a99b3	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:40:24.037762+00	
00000000-0000-0000-0000-000000000000	8f8877b4-2e3e-4c1e-a398-7fefdd08d611	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:40:24.324289+00	
00000000-0000-0000-0000-000000000000	080c0082-b256-4535-9e87-caa535c187e0	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:41:22.118099+00	
00000000-0000-0000-0000-000000000000	deca2ec7-dc8e-4f60-901c-cc178e6eafb4	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:41:23.263597+00	
00000000-0000-0000-0000-000000000000	cefc6e07-b25c-4703-b81f-5f606e3fc4d3	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:41:23.393943+00	
00000000-0000-0000-0000-000000000000	db3f91f9-85fe-450d-b38b-5a050c5d9df4	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:41:25.261475+00	
00000000-0000-0000-0000-000000000000	72818ec2-3a04-4364-a599-41bc40dea2ac	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:41:54.183771+00	
00000000-0000-0000-0000-000000000000	efd8fb2d-0e7c-4619-b2ea-bf4d74f36e6d	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:47:06.267891+00	
00000000-0000-0000-0000-000000000000	042d0697-2b25-44c7-98c8-50fa117abfdd	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:47:06.268548+00	
00000000-0000-0000-0000-000000000000	b9d9866e-1698-4552-82a5-e4e98413a5a2	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:52:54.491921+00	
00000000-0000-0000-0000-000000000000	6a441823-de48-4519-847e-edc21a40f5ca	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:52:54.492578+00	
00000000-0000-0000-0000-000000000000	62092fdd-4786-4fcc-a47e-3bf69373ce07	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:52:54.505899+00	
00000000-0000-0000-0000-000000000000	41006a68-4e4c-430f-bcf5-b705c7f62bc5	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:52:54.890584+00	
00000000-0000-0000-0000-000000000000	95f2d983-e8da-4ade-b5fc-d7ba459c51af	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:52:55.211439+00	
00000000-0000-0000-0000-000000000000	1044e91f-f3de-4076-a149-6051991f3cc2	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:52:55.386095+00	
00000000-0000-0000-0000-000000000000	5d4a6405-631d-4a1c-8f47-1e6ce0406674	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:53:04.519721+00	
00000000-0000-0000-0000-000000000000	0a66c21a-40bc-4f06-9516-28d2bacaeec6	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:53:12.99055+00	
00000000-0000-0000-0000-000000000000	fef8be1a-7d2a-4e94-9fb1-a24ce327e873	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:53:21.37741+00	
00000000-0000-0000-0000-000000000000	f5642bf0-a0e5-40ce-bb4b-6249e0dba3fe	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:53:21.81883+00	
00000000-0000-0000-0000-000000000000	d55e4515-013c-43c1-9224-8fb959c13950	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:53:22.243256+00	
00000000-0000-0000-0000-000000000000	753ca20c-b9a9-4df9-8848-cbff73d3c86b	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:53:22.665943+00	
00000000-0000-0000-0000-000000000000	c2c81598-cab0-4432-bb9a-08ff3fafc4ca	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:53:22.979077+00	
00000000-0000-0000-0000-000000000000	96adf036-c1dd-4529-8e67-b24171e7aef9	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:53:23.726692+00	
00000000-0000-0000-0000-000000000000	a66fcf61-8428-4346-a35d-dd2d371e9234	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:53:23.983136+00	
00000000-0000-0000-0000-000000000000	ce31f170-fc95-41ec-8a1d-9f7960bc636c	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:53:24.337543+00	
00000000-0000-0000-0000-000000000000	550ed25b-c49a-4e69-ac3f-601b6900b73f	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:53:24.965114+00	
00000000-0000-0000-0000-000000000000	2f4a6777-2e6f-4b22-8b42-aa8dfcc1c752	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:53:52.972963+00	
00000000-0000-0000-0000-000000000000	a1ffd466-2ad2-4cc5-9c3d-6ff5b6c0540f	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:53:54.070787+00	
00000000-0000-0000-0000-000000000000	bb8fe0bc-5d70-434b-8bc6-24733cfaaae8	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:54:23.381461+00	
00000000-0000-0000-0000-000000000000	ce66f9c8-2b38-4226-a430-e9451a1285ad	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:54:25.224381+00	
00000000-0000-0000-0000-000000000000	aa6f7bc0-be64-4053-a586-7480448b16b8	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:54:52.159105+00	
00000000-0000-0000-0000-000000000000	10972663-cfa7-40ee-b54f-22e3536d830e	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:54:53.154835+00	
00000000-0000-0000-0000-000000000000	f77416c9-2b93-4be1-8f72-c8e82f3904f5	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 10:54:54.266484+00	
00000000-0000-0000-0000-000000000000	0b368c13-aaff-4b5f-91d9-86e9ca67e8d0	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:00:36.280142+00	
00000000-0000-0000-0000-000000000000	5d34bfa5-8d5a-49f1-95b1-f60a06247718	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:00:36.28078+00	
00000000-0000-0000-0000-000000000000	57020892-955a-489a-abc1-3a7fbea0433a	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:05:55.345836+00	
00000000-0000-0000-0000-000000000000	613b3776-263d-4453-a4e0-5de246b5cfdf	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:05:55.346612+00	
00000000-0000-0000-0000-000000000000	82b3cf8d-2311-418d-bff9-f2d69bbec08b	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:06:04.685928+00	
00000000-0000-0000-0000-000000000000	3c894c76-c20b-45af-8531-70a89f5c1d6b	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:06:13.365843+00	
00000000-0000-0000-0000-000000000000	8e0d69bb-e117-4c31-8d7f-5317a68ec925	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:06:21.419965+00	
00000000-0000-0000-0000-000000000000	10b7ef7f-bc1c-4299-90d8-652ae50aeddc	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:06:21.811521+00	
00000000-0000-0000-0000-000000000000	3c1c8330-e87c-4b85-9187-666d45ae3d5e	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:06:22.733399+00	
00000000-0000-0000-0000-000000000000	6c2b5966-41d9-4be9-8a73-03c74aa4cbc9	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:06:23.01656+00	
00000000-0000-0000-0000-000000000000	dc27eafe-98e7-4607-bfe9-306c1f8a9784	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:06:23.455409+00	
00000000-0000-0000-0000-000000000000	ec05768f-bcd6-478b-82a3-00868b447d66	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:06:23.574504+00	
00000000-0000-0000-0000-000000000000	dc54ec74-e198-4b4e-8ad7-511095705128	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:06:23.736459+00	
00000000-0000-0000-0000-000000000000	9b5da524-e6f5-4bab-9dee-2f516393602b	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:06:24.01033+00	
00000000-0000-0000-0000-000000000000	242c99ca-586f-4339-af87-33f1e94d855d	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:06:24.385599+00	
00000000-0000-0000-0000-000000000000	a9271c31-2e2e-4763-85ee-47b6115fa4d9	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:06:24.509476+00	
00000000-0000-0000-0000-000000000000	62a3bb5d-6edb-427e-a398-c6b8966cd6a7	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:06:24.853513+00	
00000000-0000-0000-0000-000000000000	c94659c3-e7aa-4d59-80f5-3d77133f5643	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:06:24.943368+00	
00000000-0000-0000-0000-000000000000	82343706-69a9-46ac-9a65-72f10c042da8	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:06:52.020482+00	
00000000-0000-0000-0000-000000000000	06b98c14-e633-4e8f-afa7-ece8aac726b4	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:06:52.976083+00	
00000000-0000-0000-0000-000000000000	09a5b76d-d43d-44fa-aace-9bf38d24bea4	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:07:23.352551+00	
00000000-0000-0000-0000-000000000000	f99855c2-839f-432c-a4a1-735e8938dfa1	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:07:24.109201+00	
00000000-0000-0000-0000-000000000000	65ce7ddf-9e6f-4dda-a4d0-4b46a074bbf7	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:07:25.290058+00	
00000000-0000-0000-0000-000000000000	cd31f15d-bfbf-4330-93b0-f367739e47af	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:07:54.300657+00	
00000000-0000-0000-0000-000000000000	230611d0-0e45-4c04-b8dc-c450d3a29b5b	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:08:22.136745+00	
00000000-0000-0000-0000-000000000000	a87bf8d3-54bf-4016-964e-3d3503be6cc7	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:08:23.431132+00	
00000000-0000-0000-0000-000000000000	013d06ae-f994-4983-a2cb-2529b53bc2ab	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:14:06.208617+00	
00000000-0000-0000-0000-000000000000	3296bf1d-ade4-470d-90ff-94e42413be22	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:14:06.209352+00	
00000000-0000-0000-0000-000000000000	e2d38f7f-48b7-48a2-ac3d-14d425f67c00	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:19:05.256676+00	
00000000-0000-0000-0000-000000000000	553363eb-5f88-464e-b3ef-0db6d5cc591d	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:19:05.257326+00	
00000000-0000-0000-0000-000000000000	1b560a34-eba0-4c7d-b50a-bc9f414ac617	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:19:21.777183+00	
00000000-0000-0000-0000-000000000000	13cc5d29-0675-4177-80ad-f4eddcea7103	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:19:22.166649+00	
00000000-0000-0000-0000-000000000000	965a7f9f-3dde-4448-becb-6a34b748dacc	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:19:22.736612+00	
00000000-0000-0000-0000-000000000000	ba50d2b6-c083-4a81-83a8-918ecfc275f5	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:19:23.468403+00	
00000000-0000-0000-0000-000000000000	5a84ced3-29cc-4e16-8b8e-a9eb44baac77	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:19:23.611841+00	
00000000-0000-0000-0000-000000000000	76dfd120-e279-4817-bf91-1c45ebe3109d	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:19:23.821214+00	
00000000-0000-0000-0000-000000000000	3fccddfd-bf82-4cb3-9828-c1d01544bddb	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:19:24.415141+00	
00000000-0000-0000-0000-000000000000	04205388-aea8-4f56-b4fb-c30d76914bcb	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:19:24.717856+00	
00000000-0000-0000-0000-000000000000	bdd1d42f-986c-4e62-8a91-7e86f9b41dd5	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:19:24.845218+00	
00000000-0000-0000-0000-000000000000	4d068297-1c5e-4296-8215-674418ea8a6e	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:19:24.871469+00	
00000000-0000-0000-0000-000000000000	45189022-43f5-4cab-acce-1731d73ccc63	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:19:24.973273+00	
00000000-0000-0000-0000-000000000000	55ce97c4-a5d1-4742-aaad-c42f61652ac1	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:19:43.033802+00	
00000000-0000-0000-0000-000000000000	97b77885-ab88-48f9-98ee-c397e6f749c2	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:19:52.748161+00	
00000000-0000-0000-0000-000000000000	6d81182d-821d-4d79-bccb-82ace07bc2d8	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:19:53.014593+00	
00000000-0000-0000-0000-000000000000	8d49cee3-418b-46ca-b367-34b4bbfe47e2	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:19:54.053226+00	
00000000-0000-0000-0000-000000000000	d1d02db5-5ac8-4649-8d8f-7aeeca86261c	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:20:21.990468+00	
00000000-0000-0000-0000-000000000000	47f7b5f2-2db2-4e49-a779-9569f6a6d3de	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:20:23.332048+00	
00000000-0000-0000-0000-000000000000	a6c3fe1f-1aab-49d9-8dea-771b2c51f50f	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:20:25.340839+00	
00000000-0000-0000-0000-000000000000	94a6484b-c426-49ae-9bed-ed24e08af46e	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:20:54.201331+00	
00000000-0000-0000-0000-000000000000	926930ed-3abb-49e2-a751-0796c6e2768d	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:20:54.258786+00	
00000000-0000-0000-0000-000000000000	8fe07531-7bbf-4f8b-99cd-f12319b00bfe	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:21:23.177331+00	
00000000-0000-0000-0000-000000000000	1e59f74c-99a1-459d-aad0-db5289165f11	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:21:52.176894+00	
00000000-0000-0000-0000-000000000000	962d2a85-45a3-4446-a0ee-0ad026a8cd9c	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:27:36.206728+00	
00000000-0000-0000-0000-000000000000	e38977c8-7100-4d32-9461-2de76b9d1c0b	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:27:36.207369+00	
00000000-0000-0000-0000-000000000000	35a171bb-d5bb-49d5-ac10-83f87b7be1eb	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:32:22.344497+00	
00000000-0000-0000-0000-000000000000	a4e67884-9956-4b5b-b968-2ee6f4bd7066	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:32:22.345143+00	
00000000-0000-0000-0000-000000000000	b7259e47-52f2-427f-880d-7855b843e5ec	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:32:22.786756+00	
00000000-0000-0000-0000-000000000000	01d089fc-5a0e-4d61-8fa2-609df90ff351	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:32:23.496851+00	
00000000-0000-0000-0000-000000000000	6ee952e3-8c2e-474e-9ce1-5cd91f39ffdb	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:32:23.942267+00	
00000000-0000-0000-0000-000000000000	4180c986-143a-4eaf-83fd-b106a74e06eb	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:32:24.156481+00	
00000000-0000-0000-0000-000000000000	63d78523-f0d1-4d0b-a5e3-45cb79eee9c7	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:32:24.629198+00	
00000000-0000-0000-0000-000000000000	6f851eb4-7853-4480-a0d8-7a06633a0720	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:32:24.77932+00	
00000000-0000-0000-0000-000000000000	c95d715b-53bb-4484-ae27-b008040803f4	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:32:24.81943+00	
00000000-0000-0000-0000-000000000000	044ca0f3-9ade-4faf-9745-3b7ec8d2f00c	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:32:24.907874+00	
00000000-0000-0000-0000-000000000000	e0e1e233-7aea-4b8f-af77-1a01a0f7e61c	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:32:25.041217+00	
00000000-0000-0000-0000-000000000000	cfd9067e-6544-4afe-9f5a-e9173b8044b6	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 11:32:34.453832+00	
00000000-0000-0000-0000-000000000000	213651b2-a58e-4fc1-b86c-b384123663aa	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 13:23:47.438229+00	
00000000-0000-0000-0000-000000000000	1c58699f-4f72-4fcd-b812-83eb5a399537	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 13:23:47.439114+00	
00000000-0000-0000-0000-000000000000	e9cf1957-acc7-48b5-ab21-7b8803c034e7	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 13:37:17.443245+00	
00000000-0000-0000-0000-000000000000	3c905ec4-c080-444b-a53c-d0b5c0498fb9	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 13:37:17.443926+00	
00000000-0000-0000-0000-000000000000	95b3ea2c-748d-449d-b6a5-926e9e9b27a2	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 13:40:24.275895+00	
00000000-0000-0000-0000-000000000000	49486f7c-76d2-4efd-a07d-a22568331dd9	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 13:40:24.284672+00	
00000000-0000-0000-0000-000000000000	aea20848-1a0b-4d00-94f0-052618652175	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 13:40:24.290857+00	
00000000-0000-0000-0000-000000000000	3f6dbefa-9565-49e5-8b6f-7c7119e7edb1	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 13:40:24.292162+00	
00000000-0000-0000-0000-000000000000	2a292e34-d1ee-4a32-a26a-6218629515ac	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 13:40:24.302353+00	
00000000-0000-0000-0000-000000000000	fd1b69ec-5844-43e9-82f8-47ba937d3c26	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 13:40:24.340513+00	
00000000-0000-0000-0000-000000000000	d9ae4d9d-5cd1-4371-86a8-7699982ad0f6	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 13:40:24.38279+00	
00000000-0000-0000-0000-000000000000	72cd901f-2a40-4059-ad36-b9acb7b2ae35	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 13:40:24.404262+00	
00000000-0000-0000-0000-000000000000	605ace82-4982-415b-8bfa-c31a0fe79737	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 13:40:24.450418+00	
00000000-0000-0000-0000-000000000000	07f06316-e23b-4424-9d35-fc086a17f719	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 13:40:24.457803+00	
00000000-0000-0000-0000-000000000000	219b56c8-4205-4147-a0df-857e316f94b2	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 13:40:24.51415+00	
00000000-0000-0000-0000-000000000000	1efbeb34-ad9e-4c37-b7fc-2de1a2a91edf	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 13:40:24.536983+00	
00000000-0000-0000-0000-000000000000	dcf8c9a0-89fb-4fa5-b564-fa19b7618cda	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 13:40:24.560279+00	
00000000-0000-0000-0000-000000000000	328bc3bf-5c98-4e5e-9e5b-a613354b8036	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 13:40:24.613681+00	
00000000-0000-0000-0000-000000000000	58c52a1f-44cf-4daa-9485-29d3e3d2cc3e	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 13:50:47.096632+00	
00000000-0000-0000-0000-000000000000	2be23deb-f108-4659-bb75-f71b084f0545	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 13:50:47.097531+00	
00000000-0000-0000-0000-000000000000	600f4855-a93d-467c-9c8f-584d54b14e7c	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 13:53:24.473683+00	
00000000-0000-0000-0000-000000000000	0cb6135a-c110-4974-9529-f19b37c886de	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 13:53:46.754777+00	
00000000-0000-0000-0000-000000000000	508c586e-4645-4c99-99c8-d7adb52149e0	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 13:53:46.756395+00	
00000000-0000-0000-0000-000000000000	56ba894c-ecfa-44b2-bec4-c28f8cdee077	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 13:53:46.874828+00	
00000000-0000-0000-0000-000000000000	3d8474f2-44b1-4ca8-84a6-1bd6d9f49a8d	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 13:53:46.886422+00	
00000000-0000-0000-0000-000000000000	8e773101-64ca-4dea-96b1-7ec0c9160acb	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 13:53:46.940347+00	
00000000-0000-0000-0000-000000000000	d871ac08-b261-4000-8a14-5864485b08d4	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 13:53:46.957903+00	
00000000-0000-0000-0000-000000000000	8d1a57fd-5813-4f64-be1f-a6bdc29b6ba9	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 13:53:46.96841+00	
00000000-0000-0000-0000-000000000000	e4d38c76-dec2-4db5-94a5-d1cbfe075514	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 13:53:46.993846+00	
00000000-0000-0000-0000-000000000000	8d6c57a4-24a8-482f-a4f3-33c7f10bdcf5	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 13:53:47.190918+00	
00000000-0000-0000-0000-000000000000	16e550cd-d658-4c42-b687-395771777b3e	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 13:53:47.205007+00	
00000000-0000-0000-0000-000000000000	5e5c620f-270a-4e0c-bef6-af536022806a	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 13:53:47.214631+00	
00000000-0000-0000-0000-000000000000	873937c7-732b-4e83-95e3-01b7f070feab	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 13:53:47.246725+00	
00000000-0000-0000-0000-000000000000	e2ef754a-f881-4332-80a0-e4ececd40239	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:04:17.013505+00	
00000000-0000-0000-0000-000000000000	d82fe70d-be23-456e-9c65-b12db4afdd18	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:04:17.014428+00	
00000000-0000-0000-0000-000000000000	a1da9007-47bf-4844-aea0-3c5a84f03e38	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:06:24.5067+00	
00000000-0000-0000-0000-000000000000	9f00d003-3ee9-431a-a964-2b4c6574b499	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:06:46.821256+00	
00000000-0000-0000-0000-000000000000	df1ffe89-c7c8-4dbb-958c-c08efae7d8e9	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:06:46.822166+00	
00000000-0000-0000-0000-000000000000	28881060-fb7b-4cc0-8975-372eba43da64	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:06:46.920401+00	
00000000-0000-0000-0000-000000000000	89d33f3c-e20c-435a-bafd-04f97f058cb7	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:06:46.971675+00	
00000000-0000-0000-0000-000000000000	5111c25c-4aeb-4daf-8328-dc9c6a83de3a	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:06:46.994705+00	
00000000-0000-0000-0000-000000000000	f6d091ba-26c5-4e7e-8987-fd736014fc56	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:06:47.027471+00	
00000000-0000-0000-0000-000000000000	c778bc67-ec0b-4436-9266-ad1594f39da6	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:06:47.183681+00	
00000000-0000-0000-0000-000000000000	e763db8c-223d-4e35-b088-69656bc3e599	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:06:47.192266+00	
00000000-0000-0000-0000-000000000000	7d88614c-5d0c-459e-9b52-1f4960b722b2	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:07:16.962599+00	
00000000-0000-0000-0000-000000000000	6f9367c4-0e07-4a22-a153-f77e187fb19a	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:07:16.990815+00	
00000000-0000-0000-0000-000000000000	89f811e0-efa9-48e6-b131-11a12b4ef0d5	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:07:17.052012+00	
00000000-0000-0000-0000-000000000000	6d1ccf01-6020-418e-8bca-a43e7e959b3a	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:07:17.060851+00	
00000000-0000-0000-0000-000000000000	39fa3275-f178-450a-a748-b787e2974670	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:17:47.068072+00	
00000000-0000-0000-0000-000000000000	5c11f052-3f42-40c0-89bf-5f5fa6d669f4	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:17:47.068996+00	
00000000-0000-0000-0000-000000000000	69f4ad1a-bd52-4fa6-ad95-8bb7037822b1	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:19:24.553881+00	
00000000-0000-0000-0000-000000000000	26d5e83c-6788-43ed-8fab-b991909b5ade	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:19:46.870085+00	
00000000-0000-0000-0000-000000000000	92da026d-d10e-4506-80e6-062ebfe5ef90	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:19:46.870654+00	
00000000-0000-0000-0000-000000000000	e00569d4-d621-4b67-83b3-314d205dc1f0	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:19:47.002188+00	
00000000-0000-0000-0000-000000000000	2498957f-5720-45d0-a41b-95960c93ea7f	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:19:47.03922+00	
00000000-0000-0000-0000-000000000000	b7a8ee8e-906d-46fd-aff1-22dd11592502	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:19:47.078149+00	
00000000-0000-0000-0000-000000000000	d2803c9f-ac99-4253-9c08-89b9f6aed012	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:20:17.014568+00	
00000000-0000-0000-0000-000000000000	ace72d56-7803-42ed-aaac-f1c50ec4a2ee	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:20:17.078546+00	
00000000-0000-0000-0000-000000000000	a5796449-dce7-43ee-9b91-1be1214d53e7	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:20:17.093215+00	
00000000-0000-0000-0000-000000000000	e7676e3a-a32e-4c93-9755-c7ce93b1a2bf	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:20:17.131258+00	
00000000-0000-0000-0000-000000000000	d4903a7c-b862-4ad1-ae79-f2249948c72e	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:20:17.182356+00	
00000000-0000-0000-0000-000000000000	049341a0-8586-46f6-8e9e-84337d458289	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:20:47.01189+00	
00000000-0000-0000-0000-000000000000	5556ebd5-d135-4cc8-8034-15d649af65f4	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:20:47.032435+00	
00000000-0000-0000-0000-000000000000	eb96a338-7f69-46f7-829a-9a1254ff9eb4	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:31:17.04307+00	
00000000-0000-0000-0000-000000000000	b9a0fab8-22b4-4397-8119-ef30a987e7c8	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:31:17.044203+00	
00000000-0000-0000-0000-000000000000	63b0e15f-3a49-45f5-904c-0429e3275cc5	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:32:24.607523+00	
00000000-0000-0000-0000-000000000000	8c6681e3-2d42-4d78-bfb0-8cb4534cb241	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:32:46.938043+00	
00000000-0000-0000-0000-000000000000	95d9fca8-d4b0-4477-8586-8dd54a7bf8bc	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:32:46.939422+00	
00000000-0000-0000-0000-000000000000	5b0fa5f8-f705-4920-81b3-e949ffc325c4	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:33:16.927796+00	
00000000-0000-0000-0000-000000000000	345236c7-e770-47fc-8794-d49e79d7bbaa	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:33:17.024602+00	
00000000-0000-0000-0000-000000000000	e8dbdaee-e916-4fa5-82aa-bd2f974cedb4	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:33:17.03624+00	
00000000-0000-0000-0000-000000000000	5d126d34-c12d-4b82-a796-2f14e05c1cd5	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:33:47.057278+00	
00000000-0000-0000-0000-000000000000	63d981b4-5b55-4ee7-bcd7-3a1a0f94dcac	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:33:47.088395+00	
00000000-0000-0000-0000-000000000000	ebc110c1-4a2a-4bd5-9eae-acd950e4cfbb	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:33:47.324344+00	
00000000-0000-0000-0000-000000000000	088d2b92-f5b1-45c7-9f34-3bcd67cb0c4b	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:33:48.007938+00	
00000000-0000-0000-0000-000000000000	003c1bac-14d9-41c1-9464-6bb990d183b1	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:33:48.042604+00	
00000000-0000-0000-0000-000000000000	21d23029-d8b1-4fd3-8094-d63809262194	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:34:16.924461+00	
00000000-0000-0000-0000-000000000000	9fe79081-6a91-4082-a2f9-a82c630478dc	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:34:17.005801+00	
00000000-0000-0000-0000-000000000000	d3d308a1-5619-4bc7-9994-0c2e369ad7a2	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:44:54.594469+00	
00000000-0000-0000-0000-000000000000	7524c84c-73c7-4636-871d-f31d98dfff54	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:44:54.595526+00	
00000000-0000-0000-0000-000000000000	c30be578-1595-4a8c-97d4-ef1882214344	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:45:24.640598+00	
00000000-0000-0000-0000-000000000000	c6dc2ac6-8621-4cfa-a4b2-7f34b3c14534	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:45:46.95669+00	
00000000-0000-0000-0000-000000000000	d5fdd145-f4e7-41d9-92c4-c0c7c0b8b608	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:45:46.957356+00	
00000000-0000-0000-0000-000000000000	fe4b040a-8d9c-4edd-a1ae-a3d8ebb602e1	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:46:17.082294+00	
00000000-0000-0000-0000-000000000000	7a699dbc-f8c6-46da-aec9-cb7de096e914	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:46:47.031734+00	
00000000-0000-0000-0000-000000000000	9b5baf57-7a28-4028-ad41-6fd7cccc469c	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:46:47.317492+00	
00000000-0000-0000-0000-000000000000	741e2201-2ef0-43c3-96d5-4892bed6849c	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:47:17.057189+00	
00000000-0000-0000-0000-000000000000	a984434e-de21-4de4-92b0-ee1041765d77	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:47:17.100215+00	
00000000-0000-0000-0000-000000000000	07424ac1-a419-4d84-b659-060748483d5b	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:47:17.106435+00	
00000000-0000-0000-0000-000000000000	28a90ec1-6a68-44f8-844a-936068ee4db2	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:47:17.112882+00	
00000000-0000-0000-0000-000000000000	9c7478a8-0b5a-4b82-a7ed-f1ba151620cb	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:47:17.156614+00	
00000000-0000-0000-0000-000000000000	45b838d4-0802-4d2d-abee-0707095f2e22	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:47:17.317877+00	
00000000-0000-0000-0000-000000000000	45063bed-3538-4599-bf00-3256d9a65cd8	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:47:47.08056+00	
00000000-0000-0000-0000-000000000000	bea4e0df-2ea6-4455-b515-7d20fd1c1a8c	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:58:17.072068+00	
00000000-0000-0000-0000-000000000000	978ba5eb-e57d-4b4b-a264-8ac01794a451	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:58:17.079224+00	
00000000-0000-0000-0000-000000000000	94cc9b23-fa95-4259-91a3-fed77b56be24	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:58:24.504848+00	
00000000-0000-0000-0000-000000000000	c30518f1-255e-4bdd-a363-5682533c1e98	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:58:24.678628+00	
00000000-0000-0000-0000-000000000000	b458d984-e545-4921-8a77-861b512560b8	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:58:47.002508+00	
00000000-0000-0000-0000-000000000000	a19b1cd6-3060-48d1-893d-f91f32842be8	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:58:47.003426+00	
00000000-0000-0000-0000-000000000000	11472825-c18b-4362-8bae-7335220d1c13	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 14:59:47.075885+00	
00000000-0000-0000-0000-000000000000	8e319d47-a979-48cb-aa8b-95b23a5c646b	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 15:00:17.058048+00	
00000000-0000-0000-0000-000000000000	81cd753f-2e31-414e-a4f2-ba67921dc42d	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 15:00:17.105027+00	
00000000-0000-0000-0000-000000000000	ae5bfb6d-a2f3-4a3b-aa64-a0579b0f1e99	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 15:00:47.043733+00	
00000000-0000-0000-0000-000000000000	18636578-255e-4c75-a7bc-8aafad32bc04	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 15:00:47.105613+00	
00000000-0000-0000-0000-000000000000	d8116cd1-c4c3-4977-a16d-2ee8a86a6567	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 15:00:47.146139+00	
00000000-0000-0000-0000-000000000000	96803902-a179-43bd-8174-d7f1b129b7c4	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 15:00:47.164739+00	
00000000-0000-0000-0000-000000000000	f30d21c8-bb1c-4252-8b19-da62430515ea	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 15:00:47.364377+00	
00000000-0000-0000-0000-000000000000	fe7b46d3-cd00-4dc7-b8af-8925a903b055	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 15:00:47.390105+00	
00000000-0000-0000-0000-000000000000	6233c81b-9f7a-4b63-a756-4b91ff568836	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 15:01:17.355755+00	
00000000-0000-0000-0000-000000000000	c1c2bd1a-d045-4ac3-a762-2c2a9d95e35a	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 15:11:24.712066+00	
00000000-0000-0000-0000-000000000000	a92fc70f-da87-44fc-b921-99b4bcf10bba	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 15:11:47.069013+00	
00000000-0000-0000-0000-000000000000	45ebac9e-a885-4b89-aa30-f6c9ea37d5aa	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 15:11:47.069892+00	
00000000-0000-0000-0000-000000000000	40c34e01-e1c8-4f50-a40d-ec3a07a78daa	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 15:12:17.038802+00	
00000000-0000-0000-0000-000000000000	df2af104-3005-4ede-9ecc-87200d56f822	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 15:12:17.039403+00	
00000000-0000-0000-0000-000000000000	18bcac12-6bdd-47eb-b2a8-45c321456732	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 15:13:17.130511+00	
00000000-0000-0000-0000-000000000000	55532f10-04a8-4f41-b0b1-45f230545170	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 15:13:47.098092+00	
00000000-0000-0000-0000-000000000000	2a7038bf-1fac-4662-b39e-6c28340eaaf6	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 15:13:47.115475+00	
00000000-0000-0000-0000-000000000000	527afa74-b863-4f6f-b05f-65bb086846bd	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 15:14:17.181403+00	
00000000-0000-0000-0000-000000000000	af907df4-d974-4a19-aa93-a3d17d3391d1	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 15:14:17.234749+00	
00000000-0000-0000-0000-000000000000	ca0e03ac-76b2-4464-8512-55aba9555d5c	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 15:14:17.311731+00	
00000000-0000-0000-0000-000000000000	41140f29-c0fa-4e1f-aa38-f7ce248d3a16	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 15:14:17.32578+00	
00000000-0000-0000-0000-000000000000	fd8a2bd0-1e93-4cbb-8e1a-e30bb5ca5d71	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 15:14:17.349639+00	
00000000-0000-0000-0000-000000000000	26fc90d8-e992-4eed-bc86-6a46b29b7bef	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 15:14:17.360855+00	
00000000-0000-0000-0000-000000000000	7d1ae662-e6fe-4efb-a995-f8fa5739f890	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 15:14:47.135791+00	
00000000-0000-0000-0000-000000000000	f8ec8f2a-991b-48a1-be59-98e1a760175d	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 15:24:24.735682+00	
00000000-0000-0000-0000-000000000000	c3ed506b-1a99-4df5-9565-6bff7d4a6f19	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 15:25:17.44511+00	
00000000-0000-0000-0000-000000000000	2a3a1921-9e3f-49d6-a1c0-cfcbd18aedc5	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 15:25:17.446019+00	
00000000-0000-0000-0000-000000000000	0b9ad521-ec4f-4845-a30a-e963f1f51808	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 15:25:47.057813+00	
00000000-0000-0000-0000-000000000000	de81802d-71f7-419a-94a9-0c8e71d1057c	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 15:25:47.058633+00	
00000000-0000-0000-0000-000000000000	0865d332-f884-4ab4-88f3-4132a0edb10c	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 15:26:47.145926+00	
00000000-0000-0000-0000-000000000000	81edb7ee-983d-4666-bce7-bf5f6e84d300	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 15:27:17.122302+00	
00000000-0000-0000-0000-000000000000	5da9f4c5-f75c-4c5e-8cf2-dff3b0943168	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 15:27:17.142088+00	
00000000-0000-0000-0000-000000000000	5723d044-759d-45b4-aca9-a629abe3de2f	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 15:27:47.202197+00	
00000000-0000-0000-0000-000000000000	6d3526fd-0eec-41b4-8682-dd03b3dc62eb	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 15:27:47.245612+00	
00000000-0000-0000-0000-000000000000	7bcf2601-e9b2-4a38-b626-4041e8178321	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 15:27:47.288678+00	
00000000-0000-0000-0000-000000000000	ebd09f24-7c65-4448-877c-ed6b4f081fc6	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 15:27:47.312267+00	
00000000-0000-0000-0000-000000000000	9a3b0098-fa0c-468b-a0da-eb207dbf1caa	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 15:27:47.354085+00	
00000000-0000-0000-0000-000000000000	c6d41bed-07e5-46f3-9c34-d18c66c91963	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 15:27:47.497416+00	
00000000-0000-0000-0000-000000000000	c5f21aeb-e2a3-4e64-a680-86088d9c2c88	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 15:28:17.206828+00	
00000000-0000-0000-0000-000000000000	20f3c79c-c6be-4573-bf2b-1039458144c3	{"action":"user_recovery_requested","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"user"}	2023-12-02 15:35:32.411768+00	
00000000-0000-0000-0000-000000000000	0a64151a-167f-4dc3-8886-1b4c2eaf6ecc	{"action":"login","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"account"}	2023-12-02 15:35:46.124438+00	
00000000-0000-0000-0000-000000000000	9476b577-385f-4cb3-867c-390805fe6797	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 15:37:24.781589+00	
00000000-0000-0000-0000-000000000000	168bf4ce-b0dc-4937-bfee-959b06bfda01	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 15:38:47.417523+00	
00000000-0000-0000-0000-000000000000	a85fc63b-5c21-442e-a5e7-0bbbebc995cd	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 15:38:47.418433+00	
00000000-0000-0000-0000-000000000000	c58cdb77-b52d-4510-9efc-0bbb46230b90	{"action":"logout","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"account"}	2023-12-02 15:44:17.317605+00	
00000000-0000-0000-0000-000000000000	fbc6f88d-84df-43f8-bd86-3f25b70fd431	{"action":"logout","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"account"}	2023-12-02 15:44:19.23136+00	
00000000-0000-0000-0000-000000000000	05c7d5e4-40e4-4717-b7ee-31d5494a07ac	{"action":"user_recovery_requested","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"user"}	2023-12-02 15:44:55.855871+00	
00000000-0000-0000-0000-000000000000	79b184b6-34ee-4027-aafc-ba4c821adec8	{"action":"user_recovery_requested","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"user"}	2023-12-02 15:47:26.106535+00	
00000000-0000-0000-0000-000000000000	8a74e34d-da34-42d3-b0ed-c21c65e016c1	{"action":"login","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"account"}	2023-12-02 15:47:52.706309+00	
00000000-0000-0000-0000-000000000000	c5e84fa8-a5f3-43f1-a8e0-80a84cfb3c6b	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 16:01:09.802269+00	
00000000-0000-0000-0000-000000000000	a12fbe47-9dd0-4a6d-99d6-f7b2d58df61e	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 16:01:09.802976+00	
00000000-0000-0000-0000-000000000000	924dbcee-6c11-4b77-9370-e12cc720a29e	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 16:01:12.290969+00	
00000000-0000-0000-0000-000000000000	32662e53-7300-424f-8c2d-afb23bbc75d1	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 16:01:15.07456+00	
00000000-0000-0000-0000-000000000000	3159cd16-a939-472b-aafd-5df4a257906b	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-02 16:01:18.23808+00	
00000000-0000-0000-0000-000000000000	32e31f48-854b-4b86-93cf-10a64010b129	{"action":"logout","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"account"}	2023-12-02 16:06:03.588147+00	
00000000-0000-0000-0000-000000000000	3cd56c49-cc74-4a96-a141-77f6af02d01a	{"action":"logout","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"account"}	2023-12-02 16:06:04.586146+00	
00000000-0000-0000-0000-000000000000	d64c78d8-5a1a-4553-acd0-f2c99448ffd4	{"action":"user_recovery_requested","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"user"}	2023-12-02 17:32:45.813487+00	
00000000-0000-0000-0000-000000000000	e1c91df8-f619-417d-b44e-d95a57e602f5	{"action":"login","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"account"}	2023-12-02 17:33:09.126812+00	
00000000-0000-0000-0000-000000000000	a4f09105-4bf0-4502-8bd2-a1c14c3a9b83	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 17:05:03.001942+00	
00000000-0000-0000-0000-000000000000	2ba5d98f-22e2-4b3e-80f4-6ef2d6f25176	{"action":"user_recovery_requested","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"user"}	2023-12-02 17:34:12.929407+00	
00000000-0000-0000-0000-000000000000	6b4ec9e0-6d40-45a0-ad3e-ce76af85520d	{"action":"login","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"account"}	2023-12-02 17:34:23.854221+00	
00000000-0000-0000-0000-000000000000	35ea5d4c-0587-4389-a056-129e3af2a9dd	{"action":"logout","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"account"}	2023-12-02 17:35:27.959459+00	
00000000-0000-0000-0000-000000000000	6e62b8d6-2920-4805-8211-20f6e8049d6a	{"action":"logout","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"account"}	2023-12-02 17:35:28.753991+00	
00000000-0000-0000-0000-000000000000	77e07da7-e84c-475d-bf3e-f940abacb73c	{"action":"logout","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"account"}	2023-12-02 17:35:35.886284+00	
00000000-0000-0000-0000-000000000000	f0056b5d-45d5-49c2-9ed5-f7e062eb5a9b	{"action":"user_recovery_requested","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"user"}	2023-12-02 19:50:23.776192+00	
00000000-0000-0000-0000-000000000000	a6214657-f546-49ac-90d8-3af2d4dd4403	{"action":"login","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"account"}	2023-12-02 19:50:38.917787+00	
00000000-0000-0000-0000-000000000000	dc62f662-4d49-4b71-82cd-450712f4dcbf	{"action":"logout","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"account"}	2023-12-02 19:58:14.915345+00	
00000000-0000-0000-0000-000000000000	9d6d11f5-8772-45e9-82bc-acd72f7f2477	{"action":"logout","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"account"}	2023-12-02 19:58:16.037502+00	
00000000-0000-0000-0000-000000000000	8b10e8df-6f1f-40f6-9010-da1d8c7423cb	{"action":"user_recovery_requested","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"user"}	2023-12-02 19:58:36.862823+00	
00000000-0000-0000-0000-000000000000	df2c6dd8-5e5f-4dcf-9775-985c732dbcb4	{"action":"login","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"account"}	2023-12-02 19:58:46.127743+00	
00000000-0000-0000-0000-000000000000	6307b983-3bfd-47da-a78e-f5aafe49a461	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 14:56:06.528277+00	
00000000-0000-0000-0000-000000000000	45159262-1b9d-4b98-94d4-df77006c4ffd	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 14:56:06.529023+00	
00000000-0000-0000-0000-000000000000	9086b197-b838-4290-954b-2a064c4716af	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 14:56:08.984774+00	
00000000-0000-0000-0000-000000000000	7c590430-3d7f-4e5f-93fe-5d02548b7ee6	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 15:09:15.098622+00	
00000000-0000-0000-0000-000000000000	e7107036-b7ce-405f-a6d7-0628edf2e90c	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 15:09:15.09926+00	
00000000-0000-0000-0000-000000000000	d0260943-545c-4463-90da-808ace6df3b6	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 15:09:23.026332+00	
00000000-0000-0000-0000-000000000000	bb28d1fd-598f-4dbe-be6a-86b800e19851	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 15:09:23.480874+00	
00000000-0000-0000-0000-000000000000	9da4cafc-c9ad-46a7-92a5-bce92945ef76	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 15:09:34.507111+00	
00000000-0000-0000-0000-000000000000	63a8fac1-e2c4-47d0-b786-a463021ac016	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 15:22:24.12746+00	
00000000-0000-0000-0000-000000000000	7b3af785-d4f2-4e6c-803a-f63b304ed0a8	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 15:22:24.12823+00	
00000000-0000-0000-0000-000000000000	2f7a35b1-912e-48b5-824d-20b10eb44fcb	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 15:22:34.841817+00	
00000000-0000-0000-0000-000000000000	8badde56-2cb7-49f9-b7ef-501893031fb6	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 15:22:45.055587+00	
00000000-0000-0000-0000-000000000000	5beaabdf-d318-49ed-8ae7-1138e6e3b664	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 15:22:53.093917+00	
00000000-0000-0000-0000-000000000000	864c187f-e478-4109-ae85-162a0f495118	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 15:35:35.377601+00	
00000000-0000-0000-0000-000000000000	a3306a65-2710-49a0-8d2c-2efbc1ca352c	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 15:35:35.37823+00	
00000000-0000-0000-0000-000000000000	579820c1-c9d0-4782-a312-6951a7a07258	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 15:35:53.955626+00	
00000000-0000-0000-0000-000000000000	848eeb98-2713-4579-9b17-d25ece85904f	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 15:36:15.083451+00	
00000000-0000-0000-0000-000000000000	c310fdc7-b0bf-491b-b762-4d6ea95156b3	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 15:36:23.096284+00	
00000000-0000-0000-0000-000000000000	741e1da6-9ea7-438e-b88e-8fd66ad1e90d	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 15:48:54.184096+00	
00000000-0000-0000-0000-000000000000	26cf58b1-caa0-4b20-909f-4cec3baf650d	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 15:48:54.184823+00	
00000000-0000-0000-0000-000000000000	cf3f8d31-736f-42e2-92fc-7fa08f6728ed	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 15:49:05.281182+00	
00000000-0000-0000-0000-000000000000	3286919d-5aae-44bf-ab60-d12fb2864425	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 15:49:45.180141+00	
00000000-0000-0000-0000-000000000000	8a1163f0-b98b-425e-adef-9eb2633138cf	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 15:49:53.484041+00	
00000000-0000-0000-0000-000000000000	65648d84-e047-47e2-bd50-2bd076abd0de	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 16:02:24.16965+00	
00000000-0000-0000-0000-000000000000	373dcb59-17bc-48b3-8b8f-1d483a3f6ea7	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 16:02:24.17036+00	
00000000-0000-0000-0000-000000000000	707e7a10-6400-4a52-a678-7260db8dc33a	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 16:02:35.258488+00	
00000000-0000-0000-0000-000000000000	799a098d-a73a-4dc4-a6b2-1c1e16afd5af	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 16:02:53.19111+00	
00000000-0000-0000-0000-000000000000	a14612b2-7dcf-42e7-9b94-e47bec906a97	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 16:03:14.886415+00	
00000000-0000-0000-0000-000000000000	98428402-12bb-4519-ad3e-faac63b18be6	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 16:15:53.970994+00	
00000000-0000-0000-0000-000000000000	7ef902da-5b0a-4c7e-bc2f-36d12754369e	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 16:15:53.971696+00	
00000000-0000-0000-0000-000000000000	45f99782-154d-4584-88f1-62c8984de63d	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 16:15:54.114529+00	
00000000-0000-0000-0000-000000000000	737e45e9-2607-468a-aaca-453d4432af95	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 16:16:01.243387+00	
00000000-0000-0000-0000-000000000000	cceec0a0-4a6d-484b-9dfa-68347ab450a2	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 16:16:04.984017+00	
00000000-0000-0000-0000-000000000000	c3067146-94d8-482f-bc72-8fb98130418b	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 16:16:14.910683+00	
00000000-0000-0000-0000-000000000000	b0910263-1fae-4143-be66-b4d37f587b9a	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 16:29:05.0452+00	
00000000-0000-0000-0000-000000000000	4e360e46-1b72-4617-b8d0-16399ced9737	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 16:29:05.045994+00	
00000000-0000-0000-0000-000000000000	99538795-1390-4842-bdb6-33131cc725b3	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 16:29:15.233696+00	
00000000-0000-0000-0000-000000000000	651609db-c359-473c-894c-87074697bc1e	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 16:29:23.548687+00	
00000000-0000-0000-0000-000000000000	d7861710-dece-4e4c-a016-a4935a102f62	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 16:29:23.660584+00	
00000000-0000-0000-0000-000000000000	a52cc039-7a7b-4819-bb15-4f5aafbe84cb	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 16:42:23.616421+00	
00000000-0000-0000-0000-000000000000	58e1044e-529f-4dd1-b5c9-98ed1afb9699	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 16:42:23.617083+00	
00000000-0000-0000-0000-000000000000	f5f8cc28-6fa9-460f-9dbd-515b533e31f3	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 16:42:24.120265+00	
00000000-0000-0000-0000-000000000000	80da7999-36ce-4191-96ca-5fa0a2a9bc50	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 16:42:34.731917+00	
00000000-0000-0000-0000-000000000000	910f760d-e8e8-4bbd-956e-6bacd4df92ef	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 16:42:45.298274+00	
00000000-0000-0000-0000-000000000000	e5391422-9f49-4e0e-b900-164388b5b151	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 16:55:23.646846+00	
00000000-0000-0000-0000-000000000000	5cc6fb90-113a-44c7-85da-e416ca946fb7	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 16:55:23.64753+00	
00000000-0000-0000-0000-000000000000	1f4a99a4-4656-4741-9fb0-1d1a395bb3af	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 16:55:34.778033+00	
00000000-0000-0000-0000-000000000000	68947be6-8da0-472c-9906-0753b6fd6681	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 16:55:53.918391+00	
00000000-0000-0000-0000-000000000000	3addf55b-4713-4f51-8bb3-1a706e45ee62	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 16:56:01.554753+00	
00000000-0000-0000-0000-000000000000	268d9d59-7a27-44c2-b2a4-28a83351b495	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 16:56:15.017644+00	
00000000-0000-0000-0000-000000000000	1b76f96a-183e-4768-bc65-5ecbc99a6730	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 17:08:23.691011+00	
00000000-0000-0000-0000-000000000000	86dd4181-fd59-4d44-a01a-119e377ea0d1	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 17:08:23.691841+00	
00000000-0000-0000-0000-000000000000	bb4a953c-6a4b-43d3-b451-d7874ecb5b10	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 17:08:34.802967+00	
00000000-0000-0000-0000-000000000000	2cb90fcf-72aa-4e26-a262-e0a91e3af546	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 17:09:24.335534+00	
00000000-0000-0000-0000-000000000000	b15ba5cf-5cd0-451a-b65b-624207c9f476	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 17:09:45.343041+00	
00000000-0000-0000-0000-000000000000	c10f9709-7bf5-434d-88b3-283991bfa893	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 17:21:24.377084+00	
00000000-0000-0000-0000-000000000000	27c19654-7e7c-44f3-b368-0f0c30c00442	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 17:21:24.377758+00	
00000000-0000-0000-0000-000000000000	600b630f-e57b-4c17-b2ad-5b3a716fd6dc	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 17:21:34.835685+00	
00000000-0000-0000-0000-000000000000	1b4ff194-120d-4edc-bdca-c785c97656c0	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 17:22:53.969143+00	
00000000-0000-0000-0000-000000000000	fd520eca-88f1-468b-8305-055f7c60e2eb	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 17:23:15.435894+00	
00000000-0000-0000-0000-000000000000	a2021c81-8bad-485c-8c7d-3b3b201b38c4	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 17:34:35.529472+00	
00000000-0000-0000-0000-000000000000	f25bca0b-96cc-4013-b11e-14e517413a10	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 17:34:35.530071+00	
00000000-0000-0000-0000-000000000000	07a6eb38-3e38-48fb-a336-d12b26003ebd	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 17:34:53.443033+00	
00000000-0000-0000-0000-000000000000	13a3b993-ca93-4f0b-a9e1-8d339ef6d887	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 17:35:53.683066+00	
00000000-0000-0000-0000-000000000000	f888b01b-a495-49b0-84e2-36227769fd5d	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 17:36:50.97986+00	
00000000-0000-0000-0000-000000000000	2e9b85d0-b0c1-45ad-8d00-a5bc4c3992a7	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 17:47:54.284436+00	
00000000-0000-0000-0000-000000000000	4de1fbf3-451b-441e-8429-8f44d71ad0d7	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 17:47:54.28509+00	
00000000-0000-0000-0000-000000000000	19aa68d2-926f-4b8a-8802-e1226a349037	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 17:48:04.920303+00	
00000000-0000-0000-0000-000000000000	e9edd274-f74c-48b5-988c-26beea6cd088	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 17:48:53.940894+00	
00000000-0000-0000-0000-000000000000	235e5cfc-eff0-425e-be17-6058e68e230c	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 17:50:15.6367+00	
00000000-0000-0000-0000-000000000000	b08b6858-d04d-4618-a0e1-81426f461296	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 18:01:05.62387+00	
00000000-0000-0000-0000-000000000000	71c779c1-66f7-4f3e-a502-f5ff4c6f4d33	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 18:01:05.626499+00	
00000000-0000-0000-0000-000000000000	dffeff48-bd0d-450c-a065-ff5fa744e75a	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 18:01:23.498909+00	
00000000-0000-0000-0000-000000000000	cc642d53-e3ec-4ec1-bf85-1b48e1673ceb	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 18:01:54.083246+00	
00000000-0000-0000-0000-000000000000	9cc7e535-1d63-489b-a70f-1d1cf7cf2201	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 18:03:15.538313+00	
00000000-0000-0000-0000-000000000000	8c968b9f-16ec-4676-b722-cf5ae5b9ba90	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 18:14:35.901336+00	
00000000-0000-0000-0000-000000000000	0020ad5c-0c6f-44f5-9991-c1c4b811b986	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 18:14:35.901921+00	
00000000-0000-0000-0000-000000000000	eff79e72-6679-4da2-90d2-b0dd3ec3b573	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 18:15:30.955246+00	
00000000-0000-0000-0000-000000000000	19fe2734-2b47-4c08-970b-7c3ce9f56d03	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 18:16:16.12524+00	
00000000-0000-0000-0000-000000000000	34d143eb-32bc-4179-9009-02b0edd7a42c	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 18:28:05.664487+00	
00000000-0000-0000-0000-000000000000	138f7ca6-2b10-4d77-8c03-5c1ea5ccc8a1	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 18:28:05.66509+00	
00000000-0000-0000-0000-000000000000	1fead062-1f9a-4bc9-81e3-6b4b3dc4adc5	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 18:28:53.623808+00	
00000000-0000-0000-0000-000000000000	0f30617f-3f49-45e4-94ef-fb7c16846ab6	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 18:29:45.608092+00	
00000000-0000-0000-0000-000000000000	1acacb8b-8856-4e6a-8143-a795bbbe3018	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 18:41:35.659622+00	
00000000-0000-0000-0000-000000000000	9651923e-f79c-4921-b9cc-5657fa554fa6	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 18:41:35.660221+00	
00000000-0000-0000-0000-000000000000	de27bb13-035e-4e24-a7ff-78b67d3ef1c2	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 18:41:54.019796+00	
00000000-0000-0000-0000-000000000000	eb408d54-4133-4c3d-8925-469b8218f121	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 18:42:01.573731+00	
00000000-0000-0000-0000-000000000000	f6015846-7b16-4fbf-b459-5b43847c07f2	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 18:42:45.260784+00	
00000000-0000-0000-0000-000000000000	47587a1a-343f-4e6d-a52b-362c0769ae60	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 20:29:36.962468+00	
00000000-0000-0000-0000-000000000000	b0f987fa-44f1-46b8-88a3-9c8cf20959d8	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-03 20:29:36.96313+00	
00000000-0000-0000-0000-000000000000	0f56217c-6f08-4c66-a76e-6df51c6bf055	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 14:46:56.117479+00	
00000000-0000-0000-0000-000000000000	3a450201-a28c-44fb-b7f5-774a134537cb	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 14:46:58.838131+00	
00000000-0000-0000-0000-000000000000	436b2c71-4d45-474d-bf87-6471e23dd8ae	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 14:47:01.090553+00	
00000000-0000-0000-0000-000000000000	e2c1af7d-d0d2-4caa-9b8a-a32faebc4a63	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 14:47:01.544869+00	
00000000-0000-0000-0000-000000000000	ba8ff0a2-a69d-4490-9f2f-91de6ce89693	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 15:15:13.459702+00	
00000000-0000-0000-0000-000000000000	accc8885-d965-4af8-b747-2256b82d522d	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 15:15:13.460373+00	
00000000-0000-0000-0000-000000000000	8d3f1706-ea7c-441a-ba68-192b7efc4926	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 15:35:16.985688+00	
00000000-0000-0000-0000-000000000000	00c077d1-3474-4a09-9020-67fa8091ded7	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 15:35:16.986347+00	
00000000-0000-0000-0000-000000000000	445bcbbd-5d34-49ad-97bd-18eac9e594a6	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 15:48:24.945005+00	
00000000-0000-0000-0000-000000000000	4ed340e5-0eeb-4025-b1ae-90ea1d4648b0	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 15:48:24.945799+00	
00000000-0000-0000-0000-000000000000	8cf10812-7dc7-44ae-91bc-3678f6caf97b	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 16:01:51.246834+00	
00000000-0000-0000-0000-000000000000	ed410296-8931-4750-a9fc-4f9952702378	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 16:01:51.247478+00	
00000000-0000-0000-0000-000000000000	0ebbbc02-f335-4858-abff-36a58a9f9dc8	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 16:23:02.125136+00	
00000000-0000-0000-0000-000000000000	cf43eb67-6653-4916-bc8d-56f53a2cb0cd	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 16:23:02.125968+00	
00000000-0000-0000-0000-000000000000	f5b664c3-e175-4b7d-8532-2ae473772a54	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 16:36:17.282862+00	
00000000-0000-0000-0000-000000000000	a4ad2d4d-0315-4f2f-81e3-1fc44364abc7	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 16:36:17.283555+00	
00000000-0000-0000-0000-000000000000	e1d0f1f2-588f-416e-9e79-f39d9bf4021a	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 16:49:47.324854+00	
00000000-0000-0000-0000-000000000000	0af276a4-102c-413f-9762-e59e7da9455e	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 16:49:47.325498+00	
00000000-0000-0000-0000-000000000000	e44ad5b1-170f-44b5-b3ce-340163e17043	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 17:03:17.541186+00	
00000000-0000-0000-0000-000000000000	7a8910f3-5e1c-4cb1-8743-02e333ab8199	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 17:03:17.541775+00	
00000000-0000-0000-0000-000000000000	8958b288-88f6-4477-bca4-6d2bc07e1cbe	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 17:16:47.383618+00	
00000000-0000-0000-0000-000000000000	1eb4dd3c-8c7f-4379-a7fa-06e74ff033df	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 17:16:47.38425+00	
00000000-0000-0000-0000-000000000000	dad54990-bdb1-487d-8366-67eaa8171990	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 17:30:17.575778+00	
00000000-0000-0000-0000-000000000000	4ea95685-48dd-4da5-a896-fcbae62e6063	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 17:30:17.576482+00	
00000000-0000-0000-0000-000000000000	d7607892-e841-49f8-a048-7af76b8293a2	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 17:43:47.635712+00	
00000000-0000-0000-0000-000000000000	326b1409-225b-4434-b74f-fdef90b8c8f0	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 17:43:47.636401+00	
00000000-0000-0000-0000-000000000000	39023f10-d063-472d-a6ea-92884dafdaf5	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 17:57:17.475726+00	
00000000-0000-0000-0000-000000000000	42705616-c091-493c-9e8a-7ea576037f11	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 17:57:17.476333+00	
00000000-0000-0000-0000-000000000000	c139f941-49a7-42ea-b8c9-0a79b2cbdc8c	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 18:10:47.612558+00	
00000000-0000-0000-0000-000000000000	0e26f404-3c1d-4129-9054-eced49ffdd6c	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 18:10:47.61318+00	
00000000-0000-0000-0000-000000000000	be2551dd-588b-429b-a230-65a95b954115	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 18:24:17.701206+00	
00000000-0000-0000-0000-000000000000	5b8dbae1-a0b1-4149-b2d9-8fcc49a267ac	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 18:24:17.701825+00	
00000000-0000-0000-0000-000000000000	8c2e19af-0808-4174-8f71-aaf1ee606553	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 18:37:47.813066+00	
00000000-0000-0000-0000-000000000000	76388eb5-306a-419b-b013-88f97caad511	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 18:37:47.81376+00	
00000000-0000-0000-0000-000000000000	765c9f0d-6c57-48f0-824e-c18d6690fd17	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 18:51:17.609149+00	
00000000-0000-0000-0000-000000000000	a5de5c6b-8dad-4624-b5de-a07efb11ef82	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 18:51:17.609746+00	
00000000-0000-0000-0000-000000000000	42144ab8-8baa-404c-b4db-eb5bbc6c7f9d	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 19:04:47.610581+00	
00000000-0000-0000-0000-000000000000	7056a624-91e1-4e60-9e89-f7baf0cbac61	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 19:04:47.611232+00	
00000000-0000-0000-0000-000000000000	d5cde714-3ced-45f2-bc4e-4c5b78eee7f7	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 19:18:17.683512+00	
00000000-0000-0000-0000-000000000000	f93aeae6-0268-4fb1-8508-c138dc71a1af	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 19:18:17.68417+00	
00000000-0000-0000-0000-000000000000	2a8b0319-aea7-4847-b1a2-7767647755b0	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 19:31:47.740561+00	
00000000-0000-0000-0000-000000000000	86e25028-1d16-4d21-9efb-3bd940d7de11	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 19:31:47.741256+00	
00000000-0000-0000-0000-000000000000	c2df679d-6626-4a19-bd9e-a3a72ff1767c	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 19:45:17.958054+00	
00000000-0000-0000-0000-000000000000	26ad5759-5f3d-4575-9fa5-cf1c2ca27d07	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 19:45:17.958675+00	
00000000-0000-0000-0000-000000000000	40199cf1-1bbd-4298-950d-4db5942736b0	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 19:58:47.999441+00	
00000000-0000-0000-0000-000000000000	66bb14ff-477d-4670-93f3-85a065ff799f	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 19:58:48.000052+00	
00000000-0000-0000-0000-000000000000	93c80ab9-0e78-4850-91e5-42dd4a207081	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 20:12:17.814826+00	
00000000-0000-0000-0000-000000000000	8728467a-848b-4102-8e6d-4fc0663a746d	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 20:12:17.81557+00	
00000000-0000-0000-0000-000000000000	7f96bbc8-8fc2-400c-99ff-3790f94c6055	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 20:25:17.924227+00	
00000000-0000-0000-0000-000000000000	da1e7c8c-3266-4451-b1e7-f4b916f22fd9	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 20:25:17.92495+00	
00000000-0000-0000-0000-000000000000	68e03e92-95cf-4eb0-8c6d-ad59baae018b	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 20:38:18.027627+00	
00000000-0000-0000-0000-000000000000	c8d22bf6-79f0-45a9-ab9a-5e3bfaf93517	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 20:38:18.028215+00	
00000000-0000-0000-0000-000000000000	83507d08-ccce-4d15-b868-eeea97505a6e	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 20:51:48.005581+00	
00000000-0000-0000-0000-000000000000	c5830efd-9b85-428c-940c-561bef39a9d7	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 20:51:48.006189+00	
00000000-0000-0000-0000-000000000000	06990cdf-b21f-4d32-9690-e20048cc0e26	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 21:05:17.958112+00	
00000000-0000-0000-0000-000000000000	7533bc16-7d1c-499c-8136-7f170d1c38ae	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 21:05:17.958868+00	
00000000-0000-0000-0000-000000000000	8341e307-832f-46c7-bbd5-7038d4e35e77	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 21:18:18.02799+00	
00000000-0000-0000-0000-000000000000	f548863c-0e49-4ed5-bcc7-61415088eed5	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 21:18:18.028793+00	
00000000-0000-0000-0000-000000000000	d85a7bb0-db4d-4bb1-b8d1-9fc6867ff8f4	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 21:31:48.359934+00	
00000000-0000-0000-0000-000000000000	a93eb65b-7232-4539-8f6e-0c29a387dad6	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 21:31:48.360674+00	
00000000-0000-0000-0000-000000000000	99e15f4e-9dfe-4d63-bd8f-a3b5396fb020	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 21:45:18.10135+00	
00000000-0000-0000-0000-000000000000	7828261d-0c39-4c98-97f3-df54b2bd4317	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-05 21:45:18.102129+00	
00000000-0000-0000-0000-000000000000	a7ef912d-f197-4fbb-b19e-1c656e5863c6	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-06 07:59:00.262665+00	
00000000-0000-0000-0000-000000000000	5c3014d5-90d5-4f38-8af8-e6a16c68337c	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-06 07:59:00.263394+00	
00000000-0000-0000-0000-000000000000	3c013bd4-07fc-4ba5-a01c-dc205bf39efd	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-06 08:12:30.278744+00	
00000000-0000-0000-0000-000000000000	5ee4d670-098b-4d27-b02b-281dd70ddd0d	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-06 08:12:30.279398+00	
00000000-0000-0000-0000-000000000000	001aa824-5481-4023-b1a6-89303040a1ad	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-06 08:26:00.35418+00	
00000000-0000-0000-0000-000000000000	456fb52d-4b37-42d9-b706-aa45a3873886	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-06 08:26:00.354844+00	
00000000-0000-0000-0000-000000000000	984ab40e-dc94-4b7e-9840-cbc590582106	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-06 08:39:30.35019+00	
00000000-0000-0000-0000-000000000000	2414ce00-8c20-4e81-b2b7-64c854a322c9	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-06 08:39:30.350843+00	
00000000-0000-0000-0000-000000000000	1ce591b3-764e-4309-87a4-97d7085dde67	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-06 08:53:00.392996+00	
00000000-0000-0000-0000-000000000000	10c79bd7-f14a-487d-a279-d1aab5de4e51	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-06 08:53:00.393651+00	
00000000-0000-0000-0000-000000000000	01308b20-b344-43ea-a4a8-92693fd77430	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-06 09:06:30.512218+00	
00000000-0000-0000-0000-000000000000	9ccbc439-46af-492c-a562-9b824c659399	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-06 09:06:30.512817+00	
00000000-0000-0000-0000-000000000000	fdc538df-0e97-46cd-a0f5-ef1ea53e806c	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-06 09:20:00.385364+00	
00000000-0000-0000-0000-000000000000	6a7c7934-b528-4088-8110-5b86911be2e7	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-06 09:20:00.38603+00	
00000000-0000-0000-0000-000000000000	ddde63de-7f20-42d3-8b34-2543a16deed0	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-06 09:33:30.397893+00	
00000000-0000-0000-0000-000000000000	dd1be13e-6350-4148-9aa0-889797e744f1	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-06 09:33:30.398536+00	
00000000-0000-0000-0000-000000000000	8b6386c5-aab8-4ac0-8f23-beb03c8479c3	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-06 09:47:00.472152+00	
00000000-0000-0000-0000-000000000000	479252b4-c7bb-448d-a10d-7e1156f0d30b	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-06 09:47:00.472762+00	
00000000-0000-0000-0000-000000000000	0b50e444-e25a-4273-83c2-a3104ee2cf23	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-06 10:00:30.501191+00	
00000000-0000-0000-0000-000000000000	e784a73c-7deb-4360-8f8d-1cf2bebd648c	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-06 10:00:30.501871+00	
00000000-0000-0000-0000-000000000000	35d3c0d5-d845-4217-84e5-568d9d8f4741	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-06 10:14:00.575456+00	
00000000-0000-0000-0000-000000000000	37fca64f-5f11-437f-ad79-35a916e3f866	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-06 10:14:00.576163+00	
00000000-0000-0000-0000-000000000000	c06d8650-ece5-4095-ac2a-14eb2c7168d3	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-06 10:27:30.538058+00	
00000000-0000-0000-0000-000000000000	adfdf7d7-fad8-4514-a99b-baa4f7323add	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-06 10:27:30.53875+00	
00000000-0000-0000-0000-000000000000	0268349a-29be-4fbc-bfef-773d48f7a8f3	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-06 10:41:00.620023+00	
00000000-0000-0000-0000-000000000000	f05f977b-87c6-4a6b-85a6-f3e808f15129	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-06 10:41:00.6207+00	
00000000-0000-0000-0000-000000000000	e8bf6a06-605f-4e36-8e71-292cb6709321	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-06 10:54:30.690743+00	
00000000-0000-0000-0000-000000000000	486b51e2-65c1-4e0c-ae0d-652d0d325fb9	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-06 10:54:30.691436+00	
00000000-0000-0000-0000-000000000000	86e80cac-301f-46cf-a4f5-a2abd91031ad	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-06 11:08:00.660012+00	
00000000-0000-0000-0000-000000000000	6a84c191-6491-4009-b2f4-92e8e84bf708	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-06 11:08:00.660601+00	
00000000-0000-0000-0000-000000000000	382485b1-7d51-4b43-bfe5-5bdf0448dd53	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-06 11:21:30.606523+00	
00000000-0000-0000-0000-000000000000	9dfe064c-b208-43b8-8c90-849d661095a0	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-06 11:21:30.607209+00	
00000000-0000-0000-0000-000000000000	aef60191-c64d-4a63-934a-078e5a92574f	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-06 11:35:00.944519+00	
00000000-0000-0000-0000-000000000000	ea6d6829-6c43-401a-9e4c-2fb091dd6269	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-06 11:35:00.945173+00	
00000000-0000-0000-0000-000000000000	e3d327b5-cff1-459b-84e0-3753ce35249f	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-06 11:48:30.720073+00	
00000000-0000-0000-0000-000000000000	31a3836e-edf5-4dca-a95c-9a52764aba0a	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-06 11:48:30.720702+00	
00000000-0000-0000-0000-000000000000	d7a5a12d-deff-406d-bf8e-50d65d332e3b	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-06 12:02:00.814029+00	
00000000-0000-0000-0000-000000000000	94c6d261-21e1-49a8-b9d1-24c7973d2b87	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-06 12:02:00.814784+00	
00000000-0000-0000-0000-000000000000	b2d3e3e7-8d27-43cd-a972-a275f1f268e9	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-06 12:15:31.003748+00	
00000000-0000-0000-0000-000000000000	021df3ce-1b4d-4696-8a4c-8543952c61ce	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-06 12:15:31.004457+00	
00000000-0000-0000-0000-000000000000	14ae236f-41c8-4350-a0b0-a211528fd157	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-06 12:29:00.982547+00	
00000000-0000-0000-0000-000000000000	b9a646b9-e0cf-4859-ab6e-5a57e209ddfc	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-06 12:29:00.983217+00	
00000000-0000-0000-0000-000000000000	da4822a7-896b-4520-a74c-9e42f4fec2b2	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-06 12:42:31.035136+00	
00000000-0000-0000-0000-000000000000	3f0873e9-493f-4c31-b88d-2c4fcb0c7bd1	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-06 12:42:31.035759+00	
00000000-0000-0000-0000-000000000000	dd0f6f47-5eb1-4fbe-a5f4-439b5e3a82bb	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-06 12:56:01.120962+00	
00000000-0000-0000-0000-000000000000	f457633b-57d4-4842-8268-913f370f57d5	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-06 12:56:01.121688+00	
00000000-0000-0000-0000-000000000000	96d1dade-da90-4e91-8e1a-b41bc967d731	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-06 13:09:30.965347+00	
00000000-0000-0000-0000-000000000000	dff5271e-9d20-4261-af9e-39ce1127b05c	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-06 13:09:30.966011+00	
00000000-0000-0000-0000-000000000000	19017c4c-00fd-4221-a532-0788556a8f69	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-06 13:22:31.081543+00	
00000000-0000-0000-0000-000000000000	ed183ff7-38bd-4eb1-8154-c0e437f897b0	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-06 13:22:31.082181+00	
00000000-0000-0000-0000-000000000000	7df29b43-411a-437f-8f19-97c70fe8f630	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-06 13:36:00.970156+00	
00000000-0000-0000-0000-000000000000	cdf48e7c-17c5-4870-8244-29bbcf03f0ad	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-06 13:36:00.970832+00	
00000000-0000-0000-0000-000000000000	f0e62e59-c908-4863-b0ef-03bbbc998903	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-06 13:49:01.203751+00	
00000000-0000-0000-0000-000000000000	a114f5f4-5110-4bce-a3cb-daa77ba0229f	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-06 13:49:01.204463+00	
00000000-0000-0000-0000-000000000000	faefc6f2-f77e-4203-b44b-0ccb1888c7a9	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-06 14:02:31.048306+00	
00000000-0000-0000-0000-000000000000	e0794af9-c761-4835-be19-dbfa7d5f9580	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-06 14:02:31.049027+00	
00000000-0000-0000-0000-000000000000	521e5677-cd53-4248-9ed9-2759b209b969	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-06 14:16:01.283155+00	
00000000-0000-0000-0000-000000000000	46ebeae0-e8dd-457c-b8e7-3ee1fd455b47	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-06 14:16:01.283958+00	
00000000-0000-0000-0000-000000000000	a44b5bfa-5b2e-421b-a217-edccb9e5c09e	{"action":"user_recovery_requested","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"user"}	2023-12-08 23:53:57.627239+00	
00000000-0000-0000-0000-000000000000	5e312a23-4499-4003-8715-5d4572490ff5	{"action":"login","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"account"}	2023-12-08 23:55:03.710369+00	
00000000-0000-0000-0000-000000000000	a336f5a0-cc3d-4d14-9143-5e1a16b39077	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-09 00:08:10.996512+00	
00000000-0000-0000-0000-000000000000	6c5f5115-5b49-49af-827e-7d7322c433c2	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-09 00:08:10.997608+00	
00000000-0000-0000-0000-000000000000	b69642b2-2867-44b7-8c5c-5620f5be387f	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-09 00:21:41.072128+00	
00000000-0000-0000-0000-000000000000	4ec95b9a-a189-4c07-9e85-339e0a1804d5	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-09 00:21:41.073132+00	
00000000-0000-0000-0000-000000000000	a18cd616-04d1-480d-833a-297e92423aee	{"action":"user_confirmation_requested","actor_id":"e76b244b-6f9e-42fc-b216-5ea74f94bd4c","actor_username":"gavriillarin263@inbox.lv","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2023-12-09 00:24:14.075622+00	
00000000-0000-0000-0000-000000000000	af7dab5c-d11a-44a9-a942-d677cdf9e229	{"action":"user_signedup","actor_id":"e76b244b-6f9e-42fc-b216-5ea74f94bd4c","actor_username":"gavriillarin263@inbox.lv","actor_via_sso":false,"log_type":"team"}	2023-12-09 00:25:02.816375+00	
00000000-0000-0000-0000-000000000000	ee063634-2e46-42cf-8cd3-a26ae0723704	{"action":"user_recovery_requested","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"user"}	2023-12-09 02:11:13.104323+00	
00000000-0000-0000-0000-000000000000	08b378aa-efb0-4ac9-8349-516cf42299a7	{"action":"login","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"account"}	2023-12-09 02:11:26.255821+00	
00000000-0000-0000-0000-000000000000	69822687-128c-49d2-9e50-0adf504f5c46	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-10 10:29:58.600509+00	
00000000-0000-0000-0000-000000000000	8de6b565-24ce-4b77-9d42-bcaa87112cf4	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-10 10:29:58.60123+00	
00000000-0000-0000-0000-000000000000	8ef79f5b-5db4-4fb4-ba76-7a912b5aa119	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-11 17:17:49.688248+00	
00000000-0000-0000-0000-000000000000	3ba95927-5473-4c92-ac1e-a4e61e7c1666	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-11 17:17:49.690431+00	
00000000-0000-0000-0000-000000000000	a4ec0ea3-aecf-406d-9f6b-a14becdc91eb	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-11 17:52:37.078802+00	
00000000-0000-0000-0000-000000000000	98713c98-1d8d-43d6-a4e5-5dbae2d60dd5	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-11 17:52:37.080154+00	
00000000-0000-0000-0000-000000000000	e11ebae0-aaa4-4858-8893-5c2425d0c4fe	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-11 19:39:32.663511+00	
00000000-0000-0000-0000-000000000000	35649340-e0b1-49c3-b146-557ac6a3a1c8	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-11 19:39:34.017758+00	
00000000-0000-0000-0000-000000000000	d73b9819-5c70-4d0f-ad59-29d58f3db750	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-11 19:39:42.254111+00	
00000000-0000-0000-0000-000000000000	a5233f89-606e-461e-8460-5de8982ac7c3	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-11 19:53:02.313358+00	
00000000-0000-0000-0000-000000000000	a0379384-4e9f-44f3-bd19-3a7933d0218b	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-11 19:53:02.31517+00	
00000000-0000-0000-0000-000000000000	ca68846b-3be2-46e3-a720-ccbfb5ecbfb6	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-11 20:06:32.134497+00	
00000000-0000-0000-0000-000000000000	66c5113b-10dc-4caf-8d0d-8b6498f6740d	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-11 20:06:32.136384+00	
00000000-0000-0000-0000-000000000000	de07fdf0-a2a4-42f1-b97f-f18e81d0aa68	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-11 20:20:02.12198+00	
00000000-0000-0000-0000-000000000000	f0af7f71-98da-4830-8793-134034fc258c	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-11 20:20:02.123303+00	
00000000-0000-0000-0000-000000000000	7ea8aed9-9dc0-4084-878c-f067b63e081c	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-11 20:33:32.173444+00	
00000000-0000-0000-0000-000000000000	ef5abfc8-415e-44fd-b71d-97e5e81f99b4	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-11 20:33:32.176762+00	
00000000-0000-0000-0000-000000000000	f4e27627-4d9a-46d3-aac4-ae28980fae9a	{"action":"user_recovery_requested","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"user"}	2023-12-11 20:47:01.989957+00	
00000000-0000-0000-0000-000000000000	2ba2201e-dc8d-4ea3-af9f-a603d2ffdac3	{"action":"login","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"account"}	2023-12-11 20:47:32.715644+00	
00000000-0000-0000-0000-000000000000	c31c726a-1e81-4cf2-bfc2-9c0561561df8	{"action":"user_confirmation_requested","actor_id":"727a5d27-4b66-49ea-a2c1-0bccc7b8e2cd","actor_username":"d9k@ya.tu","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2023-12-11 20:49:26.156721+00	
00000000-0000-0000-0000-000000000000	55102578-a26e-42b7-b850-b75463a9b750	{"action":"user_recovery_requested","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"user"}	2023-12-11 20:49:35.679944+00	
00000000-0000-0000-0000-000000000000	aadf5956-0372-4048-a873-020658ef9dfc	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 17:05:03.004132+00	
00000000-0000-0000-0000-000000000000	dc1fcb05-3ee5-4dd1-9594-3edb5c273e63	{"action":"login","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"account"}	2023-12-11 20:49:56.229662+00	
00000000-0000-0000-0000-000000000000	0b0e0e32-3e7b-48ba-a88f-b4f3470e6b32	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-11 21:30:09.890296+00	
00000000-0000-0000-0000-000000000000	b3dbf69c-ff06-4c79-a0f7-1bf4c1693452	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-11 21:30:09.891769+00	
00000000-0000-0000-0000-000000000000	0c3cecb0-84ed-4045-ba53-ea4191e57bfa	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-11 21:30:10.676903+00	
00000000-0000-0000-0000-000000000000	3b30b33d-8921-4353-b4d0-5a36a053d86a	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-11 21:43:10.234056+00	
00000000-0000-0000-0000-000000000000	e76a6b07-a63c-4969-82ce-a92698fc4693	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-11 21:43:10.235449+00	
00000000-0000-0000-0000-000000000000	7b6972ac-f19c-44ea-8276-cd06e6dba70d	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-11 21:52:00.494911+00	
00000000-0000-0000-0000-000000000000	219ebd00-69ee-42b5-8564-714cb4b79251	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-11 21:56:40.009975+00	
00000000-0000-0000-0000-000000000000	dd69e4af-070b-488a-8b3d-255ec4f0d019	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-11 21:56:40.01215+00	
00000000-0000-0000-0000-000000000000	107b600c-899b-4ad9-8abd-a0bfd7881d87	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-11 22:10:10.005541+00	
00000000-0000-0000-0000-000000000000	163d9452-9d43-45ae-9b50-c49bed0141b7	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-11 22:10:10.007206+00	
00000000-0000-0000-0000-000000000000	16434958-a95f-44eb-9ea7-5b3ce788cc30	{"action":"user_recovery_requested","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"user"}	2023-12-11 23:40:33.118502+00	
00000000-0000-0000-0000-000000000000	8c553fe4-5733-41c3-862f-dd5eb6ac2f93	{"action":"login","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"account"}	2023-12-11 23:41:06.789329+00	
00000000-0000-0000-0000-000000000000	384ec0c6-0f33-46b9-9858-3a3677a83ebd	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-12 00:16:24.710794+00	
00000000-0000-0000-0000-000000000000	0818bd41-8754-4a6b-8788-d95eeb5dd524	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-12 00:16:24.711416+00	
00000000-0000-0000-0000-000000000000	e4316772-5638-4d79-a331-e8b3d5cfd302	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-12 00:16:25.277081+00	
00000000-0000-0000-0000-000000000000	277bbc9a-e52e-4073-b516-19ed83f2ae0e	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-12 00:16:25.879205+00	
00000000-0000-0000-0000-000000000000	7b1969a8-8a47-44eb-91c3-7a7e35db52ae	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-12 17:53:01.745533+00	
00000000-0000-0000-0000-000000000000	4bd9c15a-5f3c-4c48-98bf-2d01baf2f85d	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-12 17:53:01.747868+00	
00000000-0000-0000-0000-000000000000	84a5bb92-7f93-4cde-b34b-bc63de2e19c0	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-12 23:01:15.951168+00	
00000000-0000-0000-0000-000000000000	853e384d-3311-409c-858a-8a75a1fca8f3	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-12 23:01:15.952709+00	
00000000-0000-0000-0000-000000000000	72f12d4b-6535-44c8-a39b-f906e768d3b5	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-12 23:01:18.754413+00	
00000000-0000-0000-0000-000000000000	312dc033-678f-4c6f-a95b-ae8920a490f7	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-12 23:01:20.024034+00	
00000000-0000-0000-0000-000000000000	2038dd63-7bea-4748-a007-c858882a6126	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-12 23:01:21.837321+00	
00000000-0000-0000-0000-000000000000	e75c446e-340f-47c3-81d6-adc33690df37	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-12 23:01:26.058993+00	
00000000-0000-0000-0000-000000000000	d9a78488-0a97-4e0f-a645-52df4569abbf	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-12 23:01:28.307377+00	
00000000-0000-0000-0000-000000000000	2f177a5a-a7c2-473f-9bc2-11577b13567e	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-12 23:01:28.640491+00	
00000000-0000-0000-0000-000000000000	7239bd07-8b44-4bc5-84bd-06f64c4e0cca	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-12 23:01:30.794064+00	
00000000-0000-0000-0000-000000000000	76d9cea1-d9e1-4583-94a6-cc252369c5f8	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-12 23:01:33.443649+00	
00000000-0000-0000-0000-000000000000	1082aa9f-2840-40cf-8912-a485f1d64346	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-12 23:01:36.04747+00	
00000000-0000-0000-0000-000000000000	7848b38b-475d-47e7-8846-7a2c0302e8fc	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-12 23:02:20.203787+00	
00000000-0000-0000-0000-000000000000	9f2f6b10-93d0-4412-83d9-e192a7d14ec8	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-12 23:02:21.352798+00	
00000000-0000-0000-0000-000000000000	76ad4f39-1da9-4b17-a019-e52450c48e09	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-12 23:15:24.810628+00	
00000000-0000-0000-0000-000000000000	20df2f4a-45b8-4aba-89d2-bfe9bb8d336d	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-12 23:15:24.812841+00	
00000000-0000-0000-0000-000000000000	0fd87714-823f-46d5-97c8-9838da4cd27d	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-12 23:16:14.244763+00	
00000000-0000-0000-0000-000000000000	6883ae52-3c86-4ac4-8541-7cb2236b3a32	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-12 23:38:14.341012+00	
00000000-0000-0000-0000-000000000000	777ea7f1-513d-4914-a5f1-b71d4dee0f2f	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-12 23:38:14.342809+00	
00000000-0000-0000-0000-000000000000	847a5503-c2e0-4cf2-b241-5af9a557d291	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-12 23:51:29.930178+00	
00000000-0000-0000-0000-000000000000	03527cd5-18df-4b90-9768-7c8728bb2d77	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-12 23:51:29.933018+00	
00000000-0000-0000-0000-000000000000	2b856f3f-6f4b-4b83-9bfc-855825568286	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 00:04:31.355913+00	
00000000-0000-0000-0000-000000000000	89a65d52-77e4-4315-b123-601f25297a60	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 00:04:31.357343+00	
00000000-0000-0000-0000-000000000000	85e65b46-6572-45d9-9604-9c153dd78bc9	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 00:04:41.714415+00	
00000000-0000-0000-0000-000000000000	8098d15b-378e-45ee-a66d-0c1e45898f7a	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 00:04:44.412656+00	
00000000-0000-0000-0000-000000000000	7c0f31bf-13ea-4ad6-8ed2-15f1a49bfc4a	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 00:17:54.619378+00	
00000000-0000-0000-0000-000000000000	364566f6-0b70-4f0a-bff5-b4b26f8e46d3	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 00:17:54.620507+00	
00000000-0000-0000-0000-000000000000	65adea1f-696c-4c57-a8f6-856ee0c34894	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 00:17:55.287585+00	
00000000-0000-0000-0000-000000000000	bbfdb185-a0e9-46b7-94c5-7ee275db5628	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 00:17:57.617738+00	
00000000-0000-0000-0000-000000000000	077bf305-0868-4dad-9e6a-d10977a36efd	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 00:17:59.538905+00	
00000000-0000-0000-0000-000000000000	4ad1e84e-e59e-429d-a426-8171e2e1daea	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 00:18:00.296835+00	
00000000-0000-0000-0000-000000000000	204034a0-dd27-4859-8461-4d403c4759b0	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 00:18:05.777494+00	
00000000-0000-0000-0000-000000000000	3fc044be-8eda-4496-8310-20899db7bbf5	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 00:31:10.952983+00	
00000000-0000-0000-0000-000000000000	21f31d81-fde6-4e4d-ac0f-b11005e0df6a	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 00:31:10.954343+00	
00000000-0000-0000-0000-000000000000	88f4cab6-331b-4e90-898d-b2f6de770bbd	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 00:44:15.181767+00	
00000000-0000-0000-0000-000000000000	7e226b4c-b67d-4a38-8c53-28ad9761d164	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 00:44:15.183201+00	
00000000-0000-0000-0000-000000000000	93145f3c-b14f-472b-ba70-5bfb766ee12d	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 00:44:20.434594+00	
00000000-0000-0000-0000-000000000000	7a382c8a-cb9c-4a54-a30b-30239787662d	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 00:44:21.933654+00	
00000000-0000-0000-0000-000000000000	5c45727c-e376-4665-8a9e-c5b9049c56df	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 00:57:32.920567+00	
00000000-0000-0000-0000-000000000000	fc218656-f69e-4c2b-ab45-98adf50ff5f2	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 00:57:32.921248+00	
00000000-0000-0000-0000-000000000000	9381e7a3-88d0-454f-9c18-1860ae66e390	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 00:57:42.592143+00	
00000000-0000-0000-0000-000000000000	81950aaa-6071-4001-bcf2-c84e4a1efb70	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 13:37:18.802685+00	
00000000-0000-0000-0000-000000000000	643668dd-7727-4d89-8965-6c30e3411039	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 13:37:18.805051+00	
00000000-0000-0000-0000-000000000000	d407c6b5-632f-48c1-89a7-62000b6a16d0	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 13:50:27.3863+00	
00000000-0000-0000-0000-000000000000	2db1666e-d739-4c3d-8a13-4131695a2495	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 13:50:27.38762+00	
00000000-0000-0000-0000-000000000000	0a718f35-8938-4cda-b751-c725ed5a0c68	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 13:50:35.283758+00	
00000000-0000-0000-0000-000000000000	cb97e3dc-aa43-4b06-a89e-02181d6d2b8c	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 13:50:39.238834+00	
00000000-0000-0000-0000-000000000000	60e7df4b-cbb2-4ba1-8738-64828ba5c8c0	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 14:03:27.703266+00	
00000000-0000-0000-0000-000000000000	9878debd-7333-497d-8b48-d20e8df123c2	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 14:03:27.705611+00	
00000000-0000-0000-0000-000000000000	667b7838-3104-40b7-9d6c-1c77ec152afe	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 14:03:35.465443+00	
00000000-0000-0000-0000-000000000000	1e6f7f2b-5d34-4b46-917c-f58d681592d6	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 14:03:38.947748+00	
00000000-0000-0000-0000-000000000000	30a7d945-31bb-44e3-8d4d-5f041f684760	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 14:03:50.223358+00	
00000000-0000-0000-0000-000000000000	67d374f0-323c-4659-8605-5dbe022cb135	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 14:03:51.546681+00	
00000000-0000-0000-0000-000000000000	0f60af2c-27a2-4608-b502-2f468569ac01	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 14:03:56.796526+00	
00000000-0000-0000-0000-000000000000	6b0f181f-ea0f-4a50-9da8-e8d556219c86	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 14:16:57.552851+00	
00000000-0000-0000-0000-000000000000	4e47ff2e-d6dc-4024-8122-92f1e7ca6444	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 14:16:57.554888+00	
00000000-0000-0000-0000-000000000000	0e4d1b77-0039-4703-9da9-42dc481aeefa	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 14:16:57.586125+00	
00000000-0000-0000-0000-000000000000	9974f8cc-8b93-487e-81ae-86f72ce983d8	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 14:17:05.079889+00	
00000000-0000-0000-0000-000000000000	5c8952a4-34ed-43c9-b2b2-ae148a52a9ea	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 14:17:20.053548+00	
00000000-0000-0000-0000-000000000000	a1d40328-80ea-4d06-8b82-664438e429ab	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 14:17:21.141529+00	
00000000-0000-0000-0000-000000000000	2b84deab-fccb-4e47-8b80-4695a35a3a49	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 14:30:21.911938+00	
00000000-0000-0000-0000-000000000000	5bfe463a-fa39-4047-a66b-a1c6ddf555de	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 14:30:21.913255+00	
00000000-0000-0000-0000-000000000000	e4d1afef-5336-47c9-9f4a-75707bfaa974	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 14:30:26.783638+00	
00000000-0000-0000-0000-000000000000	b66dbea9-4ae6-4103-99a4-f61bc69edbc2	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 14:30:27.211255+00	
00000000-0000-0000-0000-000000000000	39fc25ba-5c19-48b7-8519-102b146555dd	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 14:30:35.122545+00	
00000000-0000-0000-0000-000000000000	bc01ae96-1b0d-4690-894a-c028af044d47	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 14:30:49.785573+00	
00000000-0000-0000-0000-000000000000	9d83c750-517c-4169-b26f-a4a953dd32f4	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 14:43:21.961622+00	
00000000-0000-0000-0000-000000000000	9d860544-d254-4552-9f1b-5e4a0f8c99e0	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 14:43:21.963288+00	
00000000-0000-0000-0000-000000000000	1c1156eb-e7ef-4c34-98b7-e7c87dcb75a3	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 14:43:27.294269+00	
00000000-0000-0000-0000-000000000000	aef28ba1-bfd9-4af4-98dc-bdca29f051d7	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 14:43:50.337631+00	
00000000-0000-0000-0000-000000000000	a332450e-0cf1-4d4b-bf6e-4d4d0047ba0a	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 14:43:57.420296+00	
00000000-0000-0000-0000-000000000000	7a791a5b-8304-4ef3-9bd5-6255a5a8ed09	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 14:44:05.586402+00	
00000000-0000-0000-0000-000000000000	f57c19a1-1990-4d47-a853-92c031f9e710	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 14:56:22.034586+00	
00000000-0000-0000-0000-000000000000	c0335768-5c59-44e7-96e5-27eb64c542de	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 14:56:22.036504+00	
00000000-0000-0000-0000-000000000000	4dd92c1b-1ca2-4c2d-9183-7d1f9eaed3b8	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 14:56:57.320116+00	
00000000-0000-0000-0000-000000000000	ba14d248-9c6c-41e7-943d-db4cc218748f	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 14:57:20.310772+00	
00000000-0000-0000-0000-000000000000	cd883161-f77d-41ee-a17f-95876f4c1e2e	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 14:57:27.421541+00	
00000000-0000-0000-0000-000000000000	61467ca4-a338-4d91-b0b6-d6dda506f322	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 14:57:35.164332+00	
00000000-0000-0000-0000-000000000000	dff0611f-b0f3-4177-a073-cf85cdcf4aba	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 15:09:52.263412+00	
00000000-0000-0000-0000-000000000000	61fccc04-71b8-4bf3-8069-f768ff740ead	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 15:09:52.264776+00	
00000000-0000-0000-0000-000000000000	27a3bc62-6c52-4a0f-9c73-75f4f28a846c	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 15:10:27.328107+00	
00000000-0000-0000-0000-000000000000	c2cc2ff3-b81e-4821-9382-a500f377220c	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 15:10:35.653593+00	
00000000-0000-0000-0000-000000000000	7ef52624-dbe9-43a3-8604-d820dd10876d	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 15:10:49.921365+00	
00000000-0000-0000-0000-000000000000	479ffff2-bca4-439b-abd9-24f85d054a45	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 15:10:57.447621+00	
00000000-0000-0000-0000-000000000000	a05facde-5306-4236-98ea-d767a2c87f60	{"action":"user_recovery_requested","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"user"}	2023-12-13 15:28:21.631229+00	
00000000-0000-0000-0000-000000000000	41a0aab0-0b23-4873-8545-3d1eb7f0b7a9	{"action":"login","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"account"}	2023-12-13 15:28:48.842391+00	
00000000-0000-0000-0000-000000000000	ddf1db1f-7690-44a5-bb9c-a3715403a9bb	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 16:08:54.087352+00	
00000000-0000-0000-0000-000000000000	f234d45f-4b2f-480c-9997-419f26eeea1b	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 16:08:54.088622+00	
00000000-0000-0000-0000-000000000000	855b00f2-8467-400c-93d3-f9092f1f4a5a	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 16:08:54.895132+00	
00000000-0000-0000-0000-000000000000	230d31b9-bff1-4e85-ab4b-60df2357a5fa	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 16:21:57.195557+00	
00000000-0000-0000-0000-000000000000	614b6a34-a26a-46a9-ace8-49505f26be4b	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 16:21:57.196922+00	
00000000-0000-0000-0000-000000000000	1fc94ca5-d9d7-4ecc-9b89-b777d32c61e9	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 16:21:57.789548+00	
00000000-0000-0000-0000-000000000000	d6cdea8c-1f2b-4664-85f8-a50f67bf6b6c	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 16:22:11.551119+00	
00000000-0000-0000-0000-000000000000	a41ef07a-f4a6-4be6-9c92-b3ba2b6fdffe	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 16:22:15.966917+00	
00000000-0000-0000-0000-000000000000	b031c322-b6b6-4068-ab05-85ded337aeab	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 16:22:23.46767+00	
00000000-0000-0000-0000-000000000000	eb1d2402-0adc-4a87-b20c-591e7886dc59	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 16:34:58.409638+00	
00000000-0000-0000-0000-000000000000	916176d6-7314-40ef-a0ae-2aa37c55a4ad	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 16:34:58.411703+00	
00000000-0000-0000-0000-000000000000	2e274ca8-fa00-4c28-ab6b-6bc6f176d809	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 16:35:11.597107+00	
00000000-0000-0000-0000-000000000000	0b9a07e9-e2c7-4ffc-9cf7-7731a55cb62d	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 16:35:16.0164+00	
00000000-0000-0000-0000-000000000000	db4fd61d-b052-4829-8266-341b837dc692	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 16:35:23.82256+00	
00000000-0000-0000-0000-000000000000	0a1f2bbe-e7c3-4036-bc91-178102b38b9c	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 16:35:26.533106+00	
00000000-0000-0000-0000-000000000000	32602fe2-fc4d-4c56-9d95-e014b00cfdd9	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 16:48:12.203405+00	
00000000-0000-0000-0000-000000000000	e1628a38-ddd0-4ae0-aec2-26995709090b	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 16:48:12.204586+00	
00000000-0000-0000-0000-000000000000	2eafc8a2-bf2a-4c4c-9001-5ae7c2d4e746	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 16:48:23.852637+00	
00000000-0000-0000-0000-000000000000	2586b7bd-7f8d-488f-9e36-abaaa1cdbfbe	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 16:48:26.899511+00	
00000000-0000-0000-0000-000000000000	ca8238eb-7b02-4528-b0ca-ae1baf0bfbab	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 16:48:27.898356+00	
00000000-0000-0000-0000-000000000000	16c83269-0ca1-46f8-b22e-46a1f377a976	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-13 16:48:45.811156+00	
00000000-0000-0000-0000-000000000000	ffaf8210-0d93-436d-a20f-3b7c046ab0e5	{"action":"user_recovery_requested","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"user"}	2023-12-14 12:19:11.321343+00	
00000000-0000-0000-0000-000000000000	bb21770d-50eb-4801-b732-6842111eff06	{"action":"login","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"account"}	2023-12-14 12:19:33.314451+00	
00000000-0000-0000-0000-000000000000	4d027d1a-dfcb-4085-a17e-fb12fb399553	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-14 12:32:39.647541+00	
00000000-0000-0000-0000-000000000000	cd895030-71b9-4cf6-8d34-ef883016e841	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-14 12:32:39.649465+00	
00000000-0000-0000-0000-000000000000	c732563d-b3fb-4434-9b36-8ac0a1304bce	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-14 12:46:10.712125+00	
00000000-0000-0000-0000-000000000000	eac7b42d-1156-4552-9548-ba3919f80469	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-14 12:46:10.714323+00	
00000000-0000-0000-0000-000000000000	36df6699-3dce-4ff9-bd56-401ded8de34b	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-14 12:59:39.743237+00	
00000000-0000-0000-0000-000000000000	64e19421-38de-438d-8bef-a33561d693ad	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-14 12:59:39.745188+00	
00000000-0000-0000-0000-000000000000	9620872f-1fea-441e-a2e8-4d6fa94715ba	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-14 13:13:09.650671+00	
00000000-0000-0000-0000-000000000000	67dec4b1-2581-4439-91e6-8d0ad6a3ac58	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-14 13:13:09.652255+00	
00000000-0000-0000-0000-000000000000	bbd5795f-afe1-4d29-97d6-cc0b5c337c98	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-14 13:26:39.839809+00	
00000000-0000-0000-0000-000000000000	a5d9e8e3-b38f-4db9-8842-412209a38bd9	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-14 13:26:39.840907+00	
00000000-0000-0000-0000-000000000000	1ec14713-d400-4bd3-854e-73d7c27cb9e5	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-14 13:40:09.772344+00	
00000000-0000-0000-0000-000000000000	257225e0-7fa8-4720-a74a-3fb943681c8e	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-14 13:40:09.774402+00	
00000000-0000-0000-0000-000000000000	98d74ab8-0b5f-4302-8c6c-9605a93fa82a	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-14 13:53:39.74293+00	
00000000-0000-0000-0000-000000000000	b71ced46-5fca-4d77-849e-d613c444d42e	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-14 13:53:39.744771+00	
00000000-0000-0000-0000-000000000000	52c7b695-a36e-4f62-8b14-d5618f15de9b	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-14 14:07:09.793101+00	
00000000-0000-0000-0000-000000000000	bcee6f77-7097-44df-b27d-d2f22656099d	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-14 14:07:09.794534+00	
00000000-0000-0000-0000-000000000000	d64dbc46-12ff-4626-abac-506de5e66cad	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-14 14:20:39.901696+00	
00000000-0000-0000-0000-000000000000	3de39041-3881-4b9a-90c6-0da1f5076f71	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-14 14:20:39.903785+00	
00000000-0000-0000-0000-000000000000	f3f3afa0-44ed-41d1-a722-e8e4f174c9fa	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-14 14:34:09.88524+00	
00000000-0000-0000-0000-000000000000	ef3394ed-4764-4f8f-8610-af93f270ff77	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-14 14:34:09.886728+00	
00000000-0000-0000-0000-000000000000	cca8b87a-b9c6-4855-b0e4-d601f04bd85b	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-14 14:47:39.937124+00	
00000000-0000-0000-0000-000000000000	75ca74d5-e952-40d8-871c-89d10a73da0a	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-14 14:47:39.938992+00	
00000000-0000-0000-0000-000000000000	772d8d51-5efc-4ee7-9a7c-b59f0631e9bd	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-14 15:00:39.927327+00	
00000000-0000-0000-0000-000000000000	bf3b4514-3b2a-42b9-a6a3-21179ce5c034	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-14 15:00:39.92889+00	
00000000-0000-0000-0000-000000000000	632294b2-457f-43b9-9884-11ce6899fa9b	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-14 15:13:39.989218+00	
00000000-0000-0000-0000-000000000000	88b6a9cc-5c28-4725-abee-acd118029c4b	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-14 15:13:39.989948+00	
00000000-0000-0000-0000-000000000000	10b7f974-599c-4766-b225-32a33f773d45	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-14 15:26:39.990035+00	
00000000-0000-0000-0000-000000000000	9eecdc06-f172-4ca0-bd64-7ef7abd93216	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-14 15:26:39.992285+00	
00000000-0000-0000-0000-000000000000	11227ec8-3875-4c74-b2da-53a70d5004f6	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-14 15:40:10.011809+00	
00000000-0000-0000-0000-000000000000	9e23c4b2-2a8d-431d-b612-afe994f0c3d9	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-14 15:40:10.012534+00	
00000000-0000-0000-0000-000000000000	6a25e4c1-de18-44bc-8d0e-d7233ebd4c46	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-14 15:53:40.340206+00	
00000000-0000-0000-0000-000000000000	9ca65589-ed00-4a93-af38-4af36b2319a2	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-14 15:53:40.342854+00	
00000000-0000-0000-0000-000000000000	f1890fc7-ced9-4bd6-afa5-d9e770ba03ef	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-14 16:07:10.33865+00	
00000000-0000-0000-0000-000000000000	0c475c55-9e58-4f45-9e5f-cb1e53fb8d27	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-14 16:07:10.339307+00	
00000000-0000-0000-0000-000000000000	2b3e6d7f-e8ca-484a-b32e-66bb86b9a91f	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-14 16:20:40.890471+00	
00000000-0000-0000-0000-000000000000	9f47546d-ed55-4c20-bf97-e008e5a87acb	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-14 16:20:40.892086+00	
00000000-0000-0000-0000-000000000000	8b69322a-f2f1-4e84-8899-dbcd6d894ef6	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-14 16:34:10.150528+00	
00000000-0000-0000-0000-000000000000	eef440df-eef0-426b-adc5-95fea09cc04a	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-14 16:34:10.151176+00	
00000000-0000-0000-0000-000000000000	c9c381b2-f319-4d63-ab05-a71d9ae97e53	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-14 16:47:40.172255+00	
00000000-0000-0000-0000-000000000000	f9e0861d-b0a8-4397-8c9a-041c2bcebfbe	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-14 16:47:40.173766+00	
00000000-0000-0000-0000-000000000000	c1a1c579-4766-4ff9-94e5-c2ad2028ef31	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-14 17:01:10.517566+00	
00000000-0000-0000-0000-000000000000	c55f27c8-dee8-46c2-937b-130c4c7b1fd5	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-14 17:01:10.518941+00	
00000000-0000-0000-0000-000000000000	aea111c0-518e-427b-8871-8bca7f7909d8	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-14 17:14:40.258803+00	
00000000-0000-0000-0000-000000000000	7f9b8e43-68d3-47f7-a971-89ef2b36b6ff	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-14 17:14:40.260917+00	
00000000-0000-0000-0000-000000000000	1742af98-0c73-4389-8596-32cf4879ca44	{"action":"user_recovery_requested","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"user"}	2023-12-15 15:10:20.480006+00	
00000000-0000-0000-0000-000000000000	a43a7d4f-cc90-4a56-8cd9-a5a32d27ea21	{"action":"login","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"account"}	2023-12-15 15:12:41.318444+00	
00000000-0000-0000-0000-000000000000	4d600586-0f6a-46ad-9456-cb94e1cd5116	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 15:25:43.896038+00	
00000000-0000-0000-0000-000000000000	e5540cb9-a4f6-4660-a90f-5bceb27321ec	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 15:25:43.897421+00	
00000000-0000-0000-0000-000000000000	4094648d-252a-41c8-a4ce-6cca81bb2aff	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 15:38:44.065544+00	
00000000-0000-0000-0000-000000000000	7f2256f5-e569-43fd-93cb-e48e2fea40cd	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 15:38:44.067072+00	
00000000-0000-0000-0000-000000000000	1ddb9a66-e483-49b5-98dc-cd68272efd00	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 15:38:46.631582+00	
00000000-0000-0000-0000-000000000000	5d4f73a1-a758-4cad-b3b2-da2e65bc0c81	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 15:38:48.209461+00	
00000000-0000-0000-0000-000000000000	92c96398-8805-4f7c-8523-b8a77030c19b	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 15:38:49.723256+00	
00000000-0000-0000-0000-000000000000	b618ad5d-bcae-419c-b205-094610753efa	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 15:51:47.484573+00	
00000000-0000-0000-0000-000000000000	4f18739a-8330-460f-8cbd-95e1748f0566	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 15:51:47.487384+00	
00000000-0000-0000-0000-000000000000	58e388cb-8f45-4ea3-9508-b1b68e111deb	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 15:51:59.515544+00	
00000000-0000-0000-0000-000000000000	e6c890bc-3c68-44fa-b3da-fd7483a7bc35	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 15:52:13.351289+00	
00000000-0000-0000-0000-000000000000	eb62df17-f21d-4743-b62a-7b4e0c8ffae1	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 16:05:11.036298+00	
00000000-0000-0000-0000-000000000000	73a237ab-1253-481e-9568-34808ab75312	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 16:05:11.038988+00	
00000000-0000-0000-0000-000000000000	55da558f-2d2a-4c49-ab76-55684c2a69c1	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 16:05:29.260693+00	
00000000-0000-0000-0000-000000000000	b9018502-4c72-423d-ae65-abdff1ec7125	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 16:18:40.93686+00	
00000000-0000-0000-0000-000000000000	24c8a77e-bef7-4447-9363-d03dc58d0fc0	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 16:18:40.937835+00	
00000000-0000-0000-0000-000000000000	546f2c26-5c84-44f7-8fe8-c78a26911cec	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 16:18:59.483911+00	
00000000-0000-0000-0000-000000000000	3e50f742-b0e5-40bb-9b1a-899b18d104e7	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 16:32:10.834692+00	
00000000-0000-0000-0000-000000000000	5132dc73-d407-4d3b-892b-9a0e55d5c7bc	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 16:32:10.837156+00	
00000000-0000-0000-0000-000000000000	c70efc00-2d19-45cd-bce6-ae57a32c3d43	{"action":"user_recovery_requested","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"user"}	2023-12-15 16:33:04.992345+00	
00000000-0000-0000-0000-000000000000	6192e5e6-e109-40f1-9c2b-b4068176ded8	{"action":"login","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"account"}	2023-12-15 16:34:01.758967+00	
00000000-0000-0000-0000-000000000000	af83f104-f52a-4edd-b25c-7d22ca3538ed	{"action":"user_recovery_requested","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"user"}	2023-12-15 16:35:02.542491+00	
00000000-0000-0000-0000-000000000000	f5756a3c-066d-4bf4-875f-8392503d3e0e	{"action":"login","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"account"}	2023-12-15 16:35:22.01141+00	
00000000-0000-0000-0000-000000000000	c9e5befd-f148-4c47-bae2-9b17148dcdfd	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 16:48:39.707005+00	
00000000-0000-0000-0000-000000000000	70679e82-08ba-46c0-b52b-3670ed60b270	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 16:48:39.710116+00	
00000000-0000-0000-0000-000000000000	71bf1513-9ea3-448e-b6e9-ce52363bc5f9	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 16:48:39.951596+00	
00000000-0000-0000-0000-000000000000	121854dc-6011-409a-9138-e5a711fd896b	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 16:48:48.285031+00	
00000000-0000-0000-0000-000000000000	e1a8b75e-2ce9-4c51-afc5-82ef0a62343d	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 17:01:40.368389+00	
00000000-0000-0000-0000-000000000000	7ba0668a-67ee-4301-82f0-115d2a387d7f	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 17:01:40.369775+00	
00000000-0000-0000-0000-000000000000	7da08ed1-6a8e-47ce-bea8-11419df172eb	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 17:02:03.881098+00	
00000000-0000-0000-0000-000000000000	3b7b7e03-a442-4d41-abcd-e2542c7d1c30	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 17:02:18.31307+00	
00000000-0000-0000-0000-000000000000	5c44e1c8-de1d-4a40-a7de-ecf53b4b0eaa	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 17:15:04.251693+00	
00000000-0000-0000-0000-000000000000	85a9e79d-e7ed-4187-87d4-e4bb4614fa85	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 17:15:04.254033+00	
00000000-0000-0000-0000-000000000000	7d16c0f3-8d23-4306-9a4d-60794dbea6eb	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 17:15:09.860236+00	
00000000-0000-0000-0000-000000000000	e9a89420-bee4-484a-8d81-7390f1343552	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 17:15:48.574194+00	
00000000-0000-0000-0000-000000000000	d1ba64d9-0b89-4a38-9286-a52ba370cf4f	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 17:28:10.463772+00	
00000000-0000-0000-0000-000000000000	f1873890-b086-40dd-b1e9-b382e0a8d47b	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 17:28:10.466339+00	
00000000-0000-0000-0000-000000000000	e88e645b-bd8d-4855-bc08-87683a646ef5	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 17:28:33.866474+00	
00000000-0000-0000-0000-000000000000	ba1728d3-b7e7-4122-bbce-373dfb4bf710	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 17:29:18.020937+00	
00000000-0000-0000-0000-000000000000	aed310d1-fc88-4be8-82a0-e6331b0e7923	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 17:41:34.205499+00	
00000000-0000-0000-0000-000000000000	069c18c7-2e6a-4ebb-9a14-ab42a579bb0a	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 17:41:34.206925+00	
00000000-0000-0000-0000-000000000000	831adc6f-9cf5-45d8-bc63-51e70a603b0f	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 17:41:39.980037+00	
00000000-0000-0000-0000-000000000000	40fc4230-8cf6-469b-8d35-46e2345a21e7	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 17:42:48.346267+00	
00000000-0000-0000-0000-000000000000	151d3b48-1d60-4be0-831d-e73cf1b70031	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 17:54:40.406438+00	
00000000-0000-0000-0000-000000000000	7873c8d5-6043-4ea8-be97-8c78c53e9a67	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 17:54:40.408589+00	
00000000-0000-0000-0000-000000000000	2a42cce0-f5de-484e-8096-a9a6d210c555	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 17:55:03.779356+00	
00000000-0000-0000-0000-000000000000	78714a4c-be4d-43bd-a2b7-c50421ade4eb	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 17:56:18.39486+00	
00000000-0000-0000-0000-000000000000	59446f51-c993-453e-aca0-131de23a7897	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 18:08:04.277982+00	
00000000-0000-0000-0000-000000000000	feaf0e05-5c4e-4295-9847-acbfbb06b0d1	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 18:08:04.278574+00	
00000000-0000-0000-0000-000000000000	04c7a49b-0806-474f-8484-ac5ec01dbb7b	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 18:08:10.019763+00	
00000000-0000-0000-0000-000000000000	be57556a-ef60-434e-b9dc-0bdeb5e8692b	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 18:09:48.978374+00	
00000000-0000-0000-0000-000000000000	50ba6759-9197-42da-b9c3-23a641f50fba	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 18:21:34.231795+00	
00000000-0000-0000-0000-000000000000	724f16d5-7455-4c78-afe2-19cec50ee5c6	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 18:21:34.233094+00	
00000000-0000-0000-0000-000000000000	4b2ecb03-cb12-4fd0-ad58-b05f1e12dd34	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 18:21:39.757104+00	
00000000-0000-0000-0000-000000000000	5c785837-5778-4ba7-b0bd-3fa175ed39f6	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 18:23:18.89863+00	
00000000-0000-0000-0000-000000000000	df96740a-937d-4bd7-a4e1-186bfd16df59	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 18:34:40.828+00	
00000000-0000-0000-0000-000000000000	ce286543-65c2-4819-86f5-c249bb8183f4	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 18:34:40.829921+00	
00000000-0000-0000-0000-000000000000	fe522345-d0ab-4392-9857-07ea067ac3c7	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 18:35:03.972022+00	
00000000-0000-0000-0000-000000000000	c19dc482-33ff-4b4c-b95b-f8e74447d52e	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 18:36:48.863923+00	
00000000-0000-0000-0000-000000000000	2cf787ec-9134-4ecb-b64b-7948659104e5	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 18:48:04.343991+00	
00000000-0000-0000-0000-000000000000	29e623e9-d804-4110-9e48-22a3af7d5782	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 18:48:04.345033+00	
00000000-0000-0000-0000-000000000000	5a488b22-ec83-492c-bca8-d9dd1a70d39a	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 18:48:10.168623+00	
00000000-0000-0000-0000-000000000000	438d7386-0906-41cf-9f27-9deaaf3d0bb2	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 18:49:48.992526+00	
00000000-0000-0000-0000-000000000000	b0ed2038-751a-4df4-891c-c141f267b728	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 19:01:34.540623+00	
00000000-0000-0000-0000-000000000000	ca0bcc14-206e-476e-82e1-b39109f824ae	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 19:01:34.541195+00	
00000000-0000-0000-0000-000000000000	dd2a92bc-bde7-4590-b53d-4ed42ee83516	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 19:01:39.859668+00	
00000000-0000-0000-0000-000000000000	e1513b96-acaf-4e11-b422-62fe821cbffd	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 19:02:48.846688+00	
00000000-0000-0000-0000-000000000000	0292d286-3034-488b-8836-09eccdab1e87	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 20:23:47.431297+00	
00000000-0000-0000-0000-000000000000	a8ddac1a-53dc-4f6a-834c-d4d507d468d6	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 20:23:47.432402+00	
00000000-0000-0000-0000-000000000000	264987ae-1990-4792-802b-18fdfef55126	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 20:23:47.445886+00	
00000000-0000-0000-0000-000000000000	9d207fcf-02fe-4ca7-86c6-fc314b78805f	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 20:23:55.622359+00	
00000000-0000-0000-0000-000000000000	4862eabf-bb2e-494e-8be1-4678714c42bf	{"action":"user_recovery_requested","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"user"}	2023-12-15 20:32:54.822787+00	
00000000-0000-0000-0000-000000000000	30fbf3e6-da3c-4db2-8d68-92c5d5e381a5	{"action":"login","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"account"}	2023-12-15 20:33:09.600186+00	
00000000-0000-0000-0000-000000000000	18cffd0b-fa2a-4585-a430-0beb0a259910	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 20:46:20.463793+00	
00000000-0000-0000-0000-000000000000	06a273a6-de51-42e3-b177-4bbef409fcb2	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 20:46:20.464896+00	
00000000-0000-0000-0000-000000000000	2db4e7c3-1c6f-4072-b3fc-8653d7cec2ae	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 20:47:37.669612+00	
00000000-0000-0000-0000-000000000000	f30b4b1d-9588-429b-ab08-3b57e81b20a6	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 21:25:52.915163+00	
00000000-0000-0000-0000-000000000000	dc46e394-f5e6-4828-953f-d55d255d1c25	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 21:25:52.917195+00	
00000000-0000-0000-0000-000000000000	87bbf4d6-76c5-457b-bf11-bb2b5ffbb6c7	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 21:39:24.614166+00	
00000000-0000-0000-0000-000000000000	be3ac3d9-cd2d-4978-a0d8-2f6417cd983f	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 21:39:24.616241+00	
00000000-0000-0000-0000-000000000000	dbf9e022-7289-4b89-8301-3d3998f1a736	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 22:00:29.451457+00	
00000000-0000-0000-0000-000000000000	5ba65d01-a167-4b82-9a66-4e1e95b533af	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 22:00:29.452557+00	
00000000-0000-0000-0000-000000000000	d9b21101-3165-4c63-9018-37900fba150f	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 22:00:30.577938+00	
00000000-0000-0000-0000-000000000000	63b9e112-18ce-48fc-bae6-94b08dd1337a	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 22:13:36.931033+00	
00000000-0000-0000-0000-000000000000	aee1e932-4ecc-44c8-b11e-b60911b18bfa	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 22:13:36.932329+00	
00000000-0000-0000-0000-000000000000	fcc1b53b-a532-4a69-81e4-e03a6b1783eb	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 22:26:40.499067+00	
00000000-0000-0000-0000-000000000000	75fab033-6d1b-4439-9305-0aaad5182625	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 22:26:40.499708+00	
00000000-0000-0000-0000-000000000000	c19b9541-b65b-4d2b-a14f-49d5f3e3dfa3	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 22:26:42.736856+00	
00000000-0000-0000-0000-000000000000	5f008b75-c2a8-4f56-9b14-556827aec9ec	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 22:26:42.807932+00	
00000000-0000-0000-0000-000000000000	447ce73b-692d-4c53-9bc5-d2df4340781e	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 22:26:49.449366+00	
00000000-0000-0000-0000-000000000000	87461717-0146-4d08-9bf8-01bb5b3fa52a	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 22:26:52.404573+00	
00000000-0000-0000-0000-000000000000	8dc7252d-57e2-4632-bdee-a5118e84fd49	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 22:26:52.900426+00	
00000000-0000-0000-0000-000000000000	40b9c78f-c290-4db3-9e26-78b5ed653818	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 22:26:54.835842+00	
00000000-0000-0000-0000-000000000000	b329a40a-c932-4163-93f6-316b50d932fd	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 22:26:55.742411+00	
00000000-0000-0000-0000-000000000000	67506404-5714-4e96-92c5-994870ade766	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 22:26:57.796464+00	
00000000-0000-0000-0000-000000000000	12890636-33ea-4ef7-a89d-a98e896288d6	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 22:27:02.467777+00	
00000000-0000-0000-0000-000000000000	d35a4521-c4d7-40df-9fd1-0ec878ee2f00	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 22:39:57.586552+00	
00000000-0000-0000-0000-000000000000	bda1d9d2-c7b5-432c-924d-1de8a13638e3	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 22:39:57.588559+00	
00000000-0000-0000-0000-000000000000	0a0e1e38-755d-46af-811f-a9d4adae51eb	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 22:39:58.798414+00	
00000000-0000-0000-0000-000000000000	22843664-a180-45ec-be0c-0201b1a82720	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 22:53:05.338684+00	
00000000-0000-0000-0000-000000000000	39188c1f-195c-44d8-9970-cb885a5d67cf	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 22:53:05.340164+00	
00000000-0000-0000-0000-000000000000	58497663-c6ff-4a85-bbb3-baf59f2ae1e9	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 22:53:10.200463+00	
00000000-0000-0000-0000-000000000000	2493af7a-add1-40b5-aa92-054dde8b4477	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 23:06:21.272127+00	
00000000-0000-0000-0000-000000000000	7394a0f2-6c8e-4dcf-a9b0-ab6df2fa9dfd	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 23:06:21.274285+00	
00000000-0000-0000-0000-000000000000	8abe464a-e2ec-4253-a0bb-62fe96cd1956	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 23:06:23.640886+00	
00000000-0000-0000-0000-000000000000	cfd2ebe5-5ce6-46d7-9957-e2820ff272b0	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 23:06:34.47943+00	
00000000-0000-0000-0000-000000000000	67799cd5-626f-4d6e-9b87-d05f3e51abc9	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 23:19:45.067306+00	
00000000-0000-0000-0000-000000000000	dba04600-5724-4793-a2c5-ae0c4239cb9a	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-15 23:19:45.068407+00	
00000000-0000-0000-0000-000000000000	48070de5-3ff4-4ebf-b72f-a29cefc5550d	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-16 13:38:41.952015+00	
00000000-0000-0000-0000-000000000000	26354415-6b32-44fb-abd1-1fb9d4de1b6c	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-16 13:38:41.954024+00	
00000000-0000-0000-0000-000000000000	ae872f5c-eb90-44a7-a61c-b4f89ada22fd	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-16 13:51:59.744684+00	
00000000-0000-0000-0000-000000000000	b84ca832-a346-4523-879e-4f46e490b301	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-16 13:51:59.745766+00	
00000000-0000-0000-0000-000000000000	463f1eef-c24c-4385-98ba-7e4fd7c4820c	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-16 14:05:29.737482+00	
00000000-0000-0000-0000-000000000000	3a492d61-e17d-4427-9e9a-909217db2a4b	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-16 14:05:29.739+00	
00000000-0000-0000-0000-000000000000	3bfda5d6-c808-440a-a25e-f8d00e208462	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-16 14:18:59.766052+00	
00000000-0000-0000-0000-000000000000	067262d8-97a4-429b-9ab0-944547e67c5d	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-16 14:18:59.768581+00	
00000000-0000-0000-0000-000000000000	3118e7b4-b264-4b70-b952-824768c322fa	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-16 14:32:29.809684+00	
00000000-0000-0000-0000-000000000000	bf58c6d2-f96a-4af0-b98a-ec31c3fb2533	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-16 14:32:29.811033+00	
00000000-0000-0000-0000-000000000000	b343e42b-1415-40e1-a362-f03662216e3d	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-16 14:45:59.778472+00	
00000000-0000-0000-0000-000000000000	82e175f8-f41f-406c-ab21-7bb3026e281c	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-16 14:45:59.780147+00	
00000000-0000-0000-0000-000000000000	bedc8182-51ff-4403-be6d-236a2fc1a4fc	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-16 14:58:59.90592+00	
00000000-0000-0000-0000-000000000000	79f658fe-ac0d-40a7-8947-f79f803c9718	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-16 14:58:59.906597+00	
00000000-0000-0000-0000-000000000000	e4e9becf-5b0d-4d22-be5e-9ff6cfa0ba43	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-16 15:11:59.863202+00	
00000000-0000-0000-0000-000000000000	447c07c0-57ca-4598-9585-2d9b8b2512c6	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-16 15:11:59.864694+00	
00000000-0000-0000-0000-000000000000	38a7b1eb-57f1-45eb-8443-476f11af8920	{"action":"user_recovery_requested","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"user"}	2023-12-16 15:34:10.303301+00	
00000000-0000-0000-0000-000000000000	9f0701de-17ed-433a-85d6-2f96684ef528	{"action":"login","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"account"}	2023-12-16 15:35:40.312366+00	
00000000-0000-0000-0000-000000000000	104679c7-895e-4a47-87fc-74b153b05a60	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-16 15:49:04.021878+00	
00000000-0000-0000-0000-000000000000	87ca2b83-9bf5-4e23-8fc6-85fb6a10c015	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-16 15:49:04.023909+00	
00000000-0000-0000-0000-000000000000	e45bc93a-2528-4a0a-8652-a10ef3a445d4	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-16 15:49:04.980439+00	
00000000-0000-0000-0000-000000000000	e47b5c09-1f5d-42a8-8985-a35fab4d936a	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-16 20:03:54.387667+00	
00000000-0000-0000-0000-000000000000	d3af768a-cc4e-409c-a91b-dee1f52850a6	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-16 20:03:54.389637+00	
00000000-0000-0000-0000-000000000000	fef02d98-f72d-45da-9466-31acf542e7a5	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-16 20:38:50.407278+00	
00000000-0000-0000-0000-000000000000	3bcb0505-90b8-4f94-bd17-b7d64cb9ca4c	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-16 20:38:50.408381+00	
00000000-0000-0000-0000-000000000000	72f8701c-e4de-4483-adce-632353bcd585	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-16 20:54:49.645465+00	
00000000-0000-0000-0000-000000000000	2794c6c4-406a-400e-a311-7ba1a36da4d0	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-16 20:54:49.646657+00	
00000000-0000-0000-0000-000000000000	cee7d95d-166b-4ebf-b773-3af4229f33ca	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-16 21:08:19.489686+00	
00000000-0000-0000-0000-000000000000	de31e355-6170-45e4-b101-df5db83d3c92	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-16 21:08:19.49172+00	
00000000-0000-0000-0000-000000000000	acf55059-58e4-4fc3-a372-f90f446b7108	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-16 21:21:49.595778+00	
00000000-0000-0000-0000-000000000000	a58913cb-5dcb-4224-9ba3-d99b2113b953	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-16 21:21:49.598575+00	
00000000-0000-0000-0000-000000000000	398c73d1-08ce-4498-b1d9-acebaf41af4f	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-16 21:35:19.566205+00	
00000000-0000-0000-0000-000000000000	e7fb8e99-c359-4337-9ee1-90ee8f74f60b	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-16 21:35:19.569425+00	
00000000-0000-0000-0000-000000000000	a16f90ac-36fa-4f84-9256-10eb1a313032	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-16 22:09:20.998501+00	
00000000-0000-0000-0000-000000000000	00c54bc0-731b-482a-9580-9534f3b4db61	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-16 22:09:21.000213+00	
00000000-0000-0000-0000-000000000000	d703d8c4-94ce-4477-a1c9-8fb703e61610	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-16 22:28:41.918122+00	
00000000-0000-0000-0000-000000000000	f157aaf0-73c2-4af3-95c4-8719887e530c	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-16 22:28:41.91953+00	
00000000-0000-0000-0000-000000000000	b2b9a132-e6a1-46ef-86ce-7aed2477b637	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-16 22:47:23.079416+00	
00000000-0000-0000-0000-000000000000	5ca1bd96-86ce-4c3a-9eb7-682856be6455	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-16 22:47:23.08108+00	
00000000-0000-0000-0000-000000000000	151823de-3e1f-4455-b2da-7866616e2219	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-16 23:15:30.907552+00	
00000000-0000-0000-0000-000000000000	e1367e4c-380b-460f-8602-094f02c67c8c	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-16 23:15:30.910185+00	
00000000-0000-0000-0000-000000000000	3811f1a2-0d9b-4d63-af87-fdb1c58336f5	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-16 23:31:40.370063+00	
00000000-0000-0000-0000-000000000000	2a995727-a6a3-473e-b07b-0a7c42c883fa	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-16 23:31:40.37185+00	
00000000-0000-0000-0000-000000000000	148dae33-1d41-4282-b2fb-bf4531848917	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-16 23:45:59.830217+00	
00000000-0000-0000-0000-000000000000	43be6a80-f3d3-4baa-9073-d0b57fcd23a9	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-16 23:45:59.831978+00	
00000000-0000-0000-0000-000000000000	bc28a069-88de-420d-9b17-c86c443b4044	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-16 23:46:00.218817+00	
00000000-0000-0000-0000-000000000000	7af5a454-8f9a-42de-8aae-d939f03c581f	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-16 23:59:17.746042+00	
00000000-0000-0000-0000-000000000000	a1f68924-a573-47ed-84b1-be3d26724dbd	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-16 23:59:17.746643+00	
00000000-0000-0000-0000-000000000000	70afe2cd-e5f6-434e-864c-4da19bd56384	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-16 23:59:21.646633+00	
00000000-0000-0000-0000-000000000000	a8acd43a-0a68-402a-b113-97a638d60fae	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-16 23:59:29.766351+00	
00000000-0000-0000-0000-000000000000	18692a4a-2ab8-4af2-85ad-37b077f53aa6	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 14:27:13.774594+00	
00000000-0000-0000-0000-000000000000	18d154c4-af50-4c8e-8602-9c4ba36635a4	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 14:27:13.777243+00	
00000000-0000-0000-0000-000000000000	24c5ffb3-36c6-4de9-bd80-8e10b7f8c946	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 14:27:14.199784+00	
00000000-0000-0000-0000-000000000000	97eab534-f798-4e90-91b5-20b19b827484	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 14:40:21.144521+00	
00000000-0000-0000-0000-000000000000	95b74e7c-ab09-47f1-a60c-fbab888083e6	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 14:40:21.147733+00	
00000000-0000-0000-0000-000000000000	d81651e2-7b19-4307-999f-ca398108b65e	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 14:40:31.440006+00	
00000000-0000-0000-0000-000000000000	f77107a9-1feb-499a-bad6-a15d1d965ce4	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 14:40:32.907023+00	
00000000-0000-0000-0000-000000000000	271477c2-fe67-4f87-a22b-d0b19d8cd420	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 14:53:33.059526+00	
00000000-0000-0000-0000-000000000000	3fd99fb6-202c-4754-895a-7268e3446365	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 14:53:33.062939+00	
00000000-0000-0000-0000-000000000000	e1e4b253-9a75-4e5a-83e3-aecd40c28155	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 14:53:51.170918+00	
00000000-0000-0000-0000-000000000000	11707ec6-4289-4bdf-9bb0-43219bbedf9b	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 14:54:01.152501+00	
00000000-0000-0000-0000-000000000000	5126393c-7f45-4d77-bccb-bec40bfb4457	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 15:07:03.036453+00	
00000000-0000-0000-0000-000000000000	dd091e5b-67d6-45b5-a71a-e6f7885e3ce0	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 15:07:03.037092+00	
00000000-0000-0000-0000-000000000000	ff809588-b1e4-4128-aa44-cfbc8afe491b	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 15:07:21.189263+00	
00000000-0000-0000-0000-000000000000	c52c03cb-59fa-4e0e-a6b5-1c4c71e4205e	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 15:07:31.46406+00	
00000000-0000-0000-0000-000000000000	06873bc0-2362-4d58-bbb7-1cb535e8140d	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 15:20:31.957296+00	
00000000-0000-0000-0000-000000000000	bc69109a-b288-4046-997a-c46198dadd48	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 15:20:31.958387+00	
00000000-0000-0000-0000-000000000000	675d8809-d6f4-4523-ad9a-b55f74355242	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 15:20:32.843848+00	
00000000-0000-0000-0000-000000000000	8dd9c471-ff3a-42e1-8521-abb2a36929a1	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 15:20:50.555864+00	
00000000-0000-0000-0000-000000000000	aea63bb3-3be4-4ca7-b3a9-e87be1e90500	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 15:33:31.872621+00	
00000000-0000-0000-0000-000000000000	07eb2339-d63d-44eb-a389-c82336b7ec4c	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 15:33:31.875077+00	
00000000-0000-0000-0000-000000000000	8833ff83-ec9d-4b22-9142-8acf59c52e95	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 15:33:32.772631+00	
00000000-0000-0000-0000-000000000000	eb6400a4-25f1-4875-9664-212a79aacf52	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 15:33:50.545366+00	
00000000-0000-0000-0000-000000000000	16813179-430a-4240-bde5-3597ef90626e	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 15:46:31.916003+00	
00000000-0000-0000-0000-000000000000	adf8c73d-54d2-4d22-8d1d-ef144069388a	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 15:46:31.916595+00	
00000000-0000-0000-0000-000000000000	d3cda0c5-e600-40b5-8b4f-a8f13ebf90c2	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 15:46:32.920954+00	
00000000-0000-0000-0000-000000000000	eb6452be-6365-4ea0-abfa-f45b62dc27f9	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 15:46:50.882827+00	
00000000-0000-0000-0000-000000000000	ca06d9f3-8867-4401-852d-82d02d42343c	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 15:59:31.930907+00	
00000000-0000-0000-0000-000000000000	85eb0676-4c43-4d50-b37d-857a70db1f41	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 15:59:31.934635+00	
00000000-0000-0000-0000-000000000000	1cd768ce-9758-4c0e-8624-4dbcddb0f24d	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 15:59:32.784535+00	
00000000-0000-0000-0000-000000000000	e24be63d-fc4e-4d2a-b2d1-95b241e45508	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 15:59:39.921844+00	
00000000-0000-0000-0000-000000000000	fafcc887-55da-4ac6-8e8b-076054a808b9	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 15:59:50.657285+00	
00000000-0000-0000-0000-000000000000	ca487d94-643f-421c-a9c9-52104e3818de	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 16:12:31.965737+00	
00000000-0000-0000-0000-000000000000	cad61770-a1d3-4197-8842-927f3d152a1d	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 16:12:31.966318+00	
00000000-0000-0000-0000-000000000000	26849366-a855-44d3-b1b8-8551d2e6559c	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 16:12:50.944778+00	
00000000-0000-0000-0000-000000000000	57c895da-818d-44f1-bbd5-cff8a7ed07e2	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 16:13:02.601877+00	
00000000-0000-0000-0000-000000000000	025da4b7-2574-4b8f-81ea-d4349313c5ef	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 16:25:31.973516+00	
00000000-0000-0000-0000-000000000000	336e0e4f-ec11-4df5-8a0d-aa8032b7e0b7	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 16:25:31.975397+00	
00000000-0000-0000-0000-000000000000	7911a05d-b604-4d5b-b529-7630ac7f3b96	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 16:25:50.973251+00	
00000000-0000-0000-0000-000000000000	37ee2e40-4615-4575-a8fc-b94a3cd34f95	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 16:26:02.487751+00	
00000000-0000-0000-0000-000000000000	a7a22f29-48d9-46c4-bd30-a9ce734dd5c7	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 16:38:32.060928+00	
00000000-0000-0000-0000-000000000000	c45ba4f0-874b-4e8c-9a32-9381e0959e8c	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 16:38:32.062204+00	
00000000-0000-0000-0000-000000000000	212403ab-27e1-4b4a-9505-497b536e888c	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 16:38:51.00038+00	
00000000-0000-0000-0000-000000000000	f5e2d242-460a-4cc0-ba23-600dce7d2cce	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 16:39:02.510723+00	
00000000-0000-0000-0000-000000000000	fd2b5f79-d051-4333-b77b-d5c72f58be80	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 17:05:32.218153+00	
00000000-0000-0000-0000-000000000000	bdb3154d-d153-4319-b92a-d0eaa8ba7502	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 17:05:51.087252+00	
00000000-0000-0000-0000-000000000000	0c6360d7-5bca-4f96-b972-958fb8f6447b	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 17:18:32.937451+00	
00000000-0000-0000-0000-000000000000	19a1840c-c724-4d93-96a0-607c721ea458	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 17:18:32.938674+00	
00000000-0000-0000-0000-000000000000	d0791869-2cef-4cc5-9121-6b6193078b9e	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 17:19:02.116448+00	
00000000-0000-0000-0000-000000000000	18632648-1181-4fb2-a44e-46b5f15ee6ec	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 17:19:20.800606+00	
00000000-0000-0000-0000-000000000000	6c4b2978-824a-43b0-9a6d-e5bfaa0b8e7d	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 17:31:33.045893+00	
00000000-0000-0000-0000-000000000000	0e7ee087-da68-42b6-8585-2bbbd7007461	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 17:31:33.047023+00	
00000000-0000-0000-0000-000000000000	d4e56c4f-a956-46d4-8201-a4ffca2f1436	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 17:32:21.435102+00	
00000000-0000-0000-0000-000000000000	e921545e-7c52-4572-9310-b736ad1b5240	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 17:32:31.543604+00	
00000000-0000-0000-0000-000000000000	f40a9dc2-6364-43d2-8284-bdef3f070944	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 17:45:02.944138+00	
00000000-0000-0000-0000-000000000000	65e9b41b-e5b3-4b84-aec1-ec9e946f25a1	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 17:45:02.94641+00	
00000000-0000-0000-0000-000000000000	581a7604-a255-480d-980e-d8d732ec81c5	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 17:45:32.202406+00	
00000000-0000-0000-0000-000000000000	27145973-e41f-43f1-a209-f43be34e8280	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 17:45:51.164575+00	
00000000-0000-0000-0000-000000000000	de7c6977-62e8-4d11-9a94-bca3d950732f	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 17:58:03.009101+00	
00000000-0000-0000-0000-000000000000	e20e156e-3b13-40fd-9c2b-aadec0925b4c	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 17:58:03.011593+00	
00000000-0000-0000-0000-000000000000	7d29c880-7def-4417-8756-938082b7710b	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 17:59:01.943258+00	
00000000-0000-0000-0000-000000000000	e838278f-f54d-4e4d-84e2-1af0b21227a2	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 17:59:21.2202+00	
00000000-0000-0000-0000-000000000000	1ef9319c-8210-4845-bbdf-6d8b5f6f207b	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 18:11:33.007816+00	
00000000-0000-0000-0000-000000000000	75e123e8-210e-40c5-93a9-cb0810f3a7bf	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 18:11:33.012419+00	
00000000-0000-0000-0000-000000000000	63462c01-d4b5-4eb9-86b0-0b12aeb77a70	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 18:12:02.27817+00	
00000000-0000-0000-0000-000000000000	9928ed1e-3fbf-4433-ae64-16f656949393	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 18:12:50.979752+00	
00000000-0000-0000-0000-000000000000	9795508d-5696-4714-bd5b-12ef8e10eacb	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 18:25:03.03957+00	
00000000-0000-0000-0000-000000000000	c3c24141-4c4f-4e75-b8f5-075058b8236b	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 18:25:03.04031+00	
00000000-0000-0000-0000-000000000000	4e2b2783-46f2-49b6-a7b2-b54d1518a225	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 18:25:32.449772+00	
00000000-0000-0000-0000-000000000000	dbf86b2b-ca13-45ee-b106-e3d4e7c1c712	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 18:25:50.956966+00	
00000000-0000-0000-0000-000000000000	2aa8a3b8-c4d1-4227-8962-e2cf10240354	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 18:38:32.9074+00	
00000000-0000-0000-0000-000000000000	94ef4254-54c0-40d7-9f24-0bd297c302df	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 18:38:32.908514+00	
00000000-0000-0000-0000-000000000000	262a918b-fb30-4bcb-9c36-73ab11541d49	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 18:38:51.659984+00	
00000000-0000-0000-0000-000000000000	37ea48c1-4044-43e0-aa84-263675045b2c	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 18:39:02.060406+00	
00000000-0000-0000-0000-000000000000	a03ea1c0-3f88-40df-86c2-2d27553c26db	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 18:51:32.830683+00	
00000000-0000-0000-0000-000000000000	b16da0a7-ba4d-416b-abcd-ef26d00a5862	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 18:51:32.831386+00	
00000000-0000-0000-0000-000000000000	65d2b3ab-0cac-4ba3-a267-ff09042f4a93	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 18:52:21.673888+00	
00000000-0000-0000-0000-000000000000	745ba425-01ac-4ebd-ad65-1e64691dd441	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 18:52:32.072045+00	
00000000-0000-0000-0000-000000000000	ce8a27c9-c03d-464a-884d-0e35c85b7faf	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 19:04:32.930034+00	
00000000-0000-0000-0000-000000000000	37135e3e-b854-4a0f-8dd6-86151f094a6f	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 19:04:32.931782+00	
00000000-0000-0000-0000-000000000000	671905d6-04e9-4bd1-9a83-421e0e178b0c	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 19:05:51.783423+00	
00000000-0000-0000-0000-000000000000	d72b3655-79c8-4ca6-a03c-09f3e275c819	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 19:06:02.13502+00	
00000000-0000-0000-0000-000000000000	0fb93419-f1be-494f-ba41-2c34b444a928	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 19:17:32.925632+00	
00000000-0000-0000-0000-000000000000	a3320f48-509d-4d25-b96e-53ffb8bd4531	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 19:17:32.927256+00	
00000000-0000-0000-0000-000000000000	f8c4709b-37ce-488e-a5aa-3e838d560c96	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 19:18:51.789055+00	
00000000-0000-0000-0000-000000000000	88be0403-2d53-4b84-ac71-5907e76f514e	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 19:19:32.173617+00	
00000000-0000-0000-0000-000000000000	6d9e6e75-d252-4aac-881d-92c2ee6386e2	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 19:30:37.281438+00	
00000000-0000-0000-0000-000000000000	ff9f352f-2119-4126-8a82-612b4480a1f6	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 19:30:37.282045+00	
00000000-0000-0000-0000-000000000000	452b17a4-2c51-4ee6-92cd-1f141a3e5cec	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 19:30:49.701341+00	
00000000-0000-0000-0000-000000000000	cc1e3967-5fe1-4692-80b1-3b79188a8d46	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 19:31:51.234624+00	
00000000-0000-0000-0000-000000000000	b23b11ad-6737-4391-8733-1090c4771f19	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 19:33:02.275349+00	
00000000-0000-0000-0000-000000000000	704517b9-3e91-4c9f-af5a-a0f50c2097ea	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 19:44:07.302605+00	
00000000-0000-0000-0000-000000000000	c66248cf-a8dc-427e-8264-7e6df6520bf7	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 19:44:07.303273+00	
00000000-0000-0000-0000-000000000000	5850dc62-35cd-47e5-b2d3-db34ed840877	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 19:44:19.329028+00	
00000000-0000-0000-0000-000000000000	5d6c93ab-214c-4d2f-8678-56fb92adc0fc	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 19:44:51.520643+00	
00000000-0000-0000-0000-000000000000	0206a760-77f9-4908-98a6-3d5c1278f176	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 19:46:32.58854+00	
00000000-0000-0000-0000-000000000000	c5be4836-dc6c-4b56-a8cd-b53db7daa48c	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 19:57:36.54336+00	
00000000-0000-0000-0000-000000000000	e13a2240-db5a-4b69-90d3-e4a920ec676c	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 19:57:36.544249+00	
00000000-0000-0000-0000-000000000000	fc633ac0-c263-4000-b00e-6494c8ea823d	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 19:57:36.716625+00	
00000000-0000-0000-0000-000000000000	470f6e6d-847e-4a40-a95e-519b5e145b3a	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 19:57:40.151797+00	
00000000-0000-0000-0000-000000000000	4ba7ace8-c7d4-4b8d-b926-6e395d7658fe	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 19:57:41.272063+00	
00000000-0000-0000-0000-000000000000	07e92ef6-da7f-43f4-aa95-cd338d9b36d7	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 19:57:51.261961+00	
00000000-0000-0000-0000-000000000000	cf824eb2-7f31-4ea7-89cf-fdc50605f38b	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 20:00:02.670548+00	
00000000-0000-0000-0000-000000000000	e3b1fb1a-18cb-4505-b8f7-60b10c87fdd6	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 20:10:52.626772+00	
00000000-0000-0000-0000-000000000000	72d4d95d-748a-44c5-b9c8-fd2d455a7f87	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 20:10:52.627371+00	
00000000-0000-0000-0000-000000000000	ae72cc4d-5367-4be7-b363-1c565e18b26f	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 20:11:04.796431+00	
00000000-0000-0000-0000-000000000000	d7c182a6-19c5-4f42-b34f-7d74b8187815	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 20:24:04.739348+00	
00000000-0000-0000-0000-000000000000	46be66e0-b1bc-4e6d-afd2-fdf24611e1ec	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 20:24:04.739956+00	
00000000-0000-0000-0000-000000000000	2f74f327-a862-446e-a7ca-29df303d92c3	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 20:24:21.151537+00	
00000000-0000-0000-0000-000000000000	a416469f-5ae6-43e5-9a5d-a7dea30e755d	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 20:24:33.617711+00	
00000000-0000-0000-0000-000000000000	00156e7c-7327-424d-865f-d812450b136d	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 20:37:26.665671+00	
00000000-0000-0000-0000-000000000000	6404883d-9d1b-445b-b5c3-38bcf64e6717	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 20:37:26.666275+00	
00000000-0000-0000-0000-000000000000	3cd6d7b1-18d0-4f39-90d3-4b136dcc135d	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 20:50:41.628075+00	
00000000-0000-0000-0000-000000000000	9b7ad9b2-af5a-4193-a51e-3711f148e177	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 20:50:41.629602+00	
00000000-0000-0000-0000-000000000000	8c0a0b14-39c7-4398-bcb3-7d60b6d4b867	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 21:03:54.730772+00	
00000000-0000-0000-0000-000000000000	0329ad0f-4815-4edf-8841-b0c92fd75a5a	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 21:03:54.731363+00	
00000000-0000-0000-0000-000000000000	7605981d-ba55-4c57-b5ad-67d85ce11c39	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 21:04:04.241976+00	
00000000-0000-0000-0000-000000000000	71e59cda-3525-4b68-9d69-1567895efff5	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 21:04:07.867955+00	
00000000-0000-0000-0000-000000000000	8e5be475-784b-4ac9-9f1a-76f2da6b3c0d	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 21:05:56.415852+00	
00000000-0000-0000-0000-000000000000	0526d20a-b3fb-481c-8a65-8dad98ebcf64	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 21:23:25.300026+00	
00000000-0000-0000-0000-000000000000	7de39cc2-6b2a-4c66-89a0-892449580713	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 21:23:25.301674+00	
00000000-0000-0000-0000-000000000000	98d25cde-e3c3-423c-92b0-928560357e36	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 21:36:26.050001+00	
00000000-0000-0000-0000-000000000000	d069e5f5-1e99-4545-8a68-183be593a600	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 21:36:26.050705+00	
00000000-0000-0000-0000-000000000000	32b1253b-5858-4d93-b9cb-3a7f307946fd	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 21:39:10.00776+00	
00000000-0000-0000-0000-000000000000	a8dd18f6-3e7c-4b70-bd9d-b36ea29b0fec	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 21:49:55.983819+00	
00000000-0000-0000-0000-000000000000	a46ba139-2731-4b0a-8504-6357be2f1a30	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 21:49:55.98454+00	
00000000-0000-0000-0000-000000000000	7c4b31a0-5963-4312-b21e-5478f3881664	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 21:52:30.704891+00	
00000000-0000-0000-0000-000000000000	228afc5e-6f5c-4412-92bc-059102ad9269	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 22:02:55.998945+00	
00000000-0000-0000-0000-000000000000	cfd13167-7f24-4476-b15c-0db8de0b66be	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 22:02:55.999552+00	
00000000-0000-0000-0000-000000000000	1ad0c874-f43c-4137-8e86-634491f11512	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 22:05:30.754013+00	
00000000-0000-0000-0000-000000000000	a61dbd61-ccc6-4506-b3e8-16ee05103fe7	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 22:16:26.08886+00	
00000000-0000-0000-0000-000000000000	334778e9-6771-4932-88e4-c000c67423c6	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 22:16:26.08951+00	
00000000-0000-0000-0000-000000000000	95d6e9f6-672a-4e6d-9d89-bdcdb44d12a3	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 22:18:30.685358+00	
00000000-0000-0000-0000-000000000000	59399d1d-348a-4eea-87d4-1634a9718b8b	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 22:29:56.111583+00	
00000000-0000-0000-0000-000000000000	32106722-5302-4e61-aab7-b66d7cdd9284	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 22:29:56.112795+00	
00000000-0000-0000-0000-000000000000	8134f937-5965-4860-b868-210d3d88668f	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 22:31:30.731046+00	
00000000-0000-0000-0000-000000000000	cd68c382-28e7-4ee8-bd59-138e49e35ac2	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 22:43:26.149419+00	
00000000-0000-0000-0000-000000000000	d2e86f14-b0c0-47e0-a476-91568c935cc4	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 22:43:26.150118+00	
00000000-0000-0000-0000-000000000000	c50ea0ac-51df-4b20-ab59-021b07537c9c	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 22:44:30.412535+00	
00000000-0000-0000-0000-000000000000	8744893f-c12d-4562-a8c5-4138580af66d	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 22:56:56.179783+00	
00000000-0000-0000-0000-000000000000	426eeadb-6c10-4f87-85df-68beac931e5d	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 22:56:56.180403+00	
00000000-0000-0000-0000-000000000000	8d747bb8-1eb3-454e-ae58-0c9f0de85354	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 22:57:30.687714+00	
00000000-0000-0000-0000-000000000000	54c6dd9b-7d87-4ef3-9830-c7bf736e7ff9	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 23:10:26.196051+00	
00000000-0000-0000-0000-000000000000	2aa5bcaf-752d-4362-ac6c-d0bcb8bb825d	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 23:10:26.196701+00	
00000000-0000-0000-0000-000000000000	479db0a4-f9c0-4ca2-ad09-61ed2978229f	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 23:10:30.685923+00	
00000000-0000-0000-0000-000000000000	e513fda5-7312-410d-b8e7-db73d59e878a	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 23:23:31.124987+00	
00000000-0000-0000-0000-000000000000	40f93376-4b09-407d-9324-a956b4be1ac3	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 23:23:31.12557+00	
00000000-0000-0000-0000-000000000000	b683dfc9-b3e5-44ea-9a7d-75c713d2637a	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 23:23:56.174192+00	
00000000-0000-0000-0000-000000000000	f5f13207-f463-474f-ab9e-97f29240d8f0	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 23:37:00.844977+00	
00000000-0000-0000-0000-000000000000	01a9c2b5-c3e6-4811-8415-c663a0333b75	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 23:37:00.846078+00	
00000000-0000-0000-0000-000000000000	a4b4e699-e234-4002-820e-737a40d42034	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 23:37:26.239443+00	
00000000-0000-0000-0000-000000000000	07e6fbe8-306c-4eee-920d-ad44610ce5e6	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 23:50:00.826081+00	
00000000-0000-0000-0000-000000000000	db4981a9-fa7d-4188-b39f-e1a4dfc64750	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 23:50:00.826748+00	
00000000-0000-0000-0000-000000000000	38d059b6-4116-407e-9846-4070d4b1f2aa	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-17 23:50:56.2407+00	
00000000-0000-0000-0000-000000000000	15e5d247-d42a-4367-a780-7a2c14f2c976	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 00:03:00.832439+00	
00000000-0000-0000-0000-000000000000	37be9de6-8180-46de-a61c-79e9cc539a56	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 00:03:00.833054+00	
00000000-0000-0000-0000-000000000000	897a2241-41b7-4db9-960a-fb57b548d758	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 00:04:26.373003+00	
00000000-0000-0000-0000-000000000000	b995ab92-c920-4cf2-b236-20c0b794777f	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 00:16:00.809316+00	
00000000-0000-0000-0000-000000000000	f18e915c-fd6a-4f76-80e1-8e44c059d76f	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 00:16:00.810922+00	
00000000-0000-0000-0000-000000000000	bef655ff-0fae-43b6-940f-c7e6bd9f02c0	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 00:17:56.362088+00	
00000000-0000-0000-0000-000000000000	8554720e-44ce-4fc3-aa29-bdbe007571f7	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 00:29:00.799749+00	
00000000-0000-0000-0000-000000000000	5ea00f0b-9ebd-432e-86f4-c03b0d622533	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 00:29:00.800367+00	
00000000-0000-0000-0000-000000000000	7575467f-e69d-4b3c-ae65-6c14b9769eb4	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 00:31:26.381083+00	
00000000-0000-0000-0000-000000000000	3947fcb9-4eb7-4b87-9bef-9068808b4043	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 00:42:00.862326+00	
00000000-0000-0000-0000-000000000000	cc8e6910-fcc5-4251-9729-ab1216c031bf	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 00:42:00.863564+00	
00000000-0000-0000-0000-000000000000	4c282744-72ae-47ed-9e25-b65d6454c17c	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 00:44:56.472717+00	
00000000-0000-0000-0000-000000000000	68ca1582-42e2-4c37-91b3-c901edb220bc	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 00:55:00.821679+00	
00000000-0000-0000-0000-000000000000	3c1fee3a-cfd0-4800-93a8-fdf6af0a01c9	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 00:55:00.822911+00	
00000000-0000-0000-0000-000000000000	b4631326-ddf0-4f3e-a9fb-48606f09473b	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 00:58:26.46782+00	
00000000-0000-0000-0000-000000000000	deb6bbd3-c957-4f87-a0ed-f2e2faf2661a	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 01:08:01.028921+00	
00000000-0000-0000-0000-000000000000	38b27609-5032-4a4c-a506-f4115c27dec6	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 01:08:01.031181+00	
00000000-0000-0000-0000-000000000000	d3475656-72da-44b6-bf4a-101f217ecf1d	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 01:11:56.485264+00	
00000000-0000-0000-0000-000000000000	dec76a4b-7160-4517-b334-03e9d524b4d6	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 01:22:52.275426+00	
00000000-0000-0000-0000-000000000000	c2ee51db-01cf-4b66-983a-c2d0bb1cd8ce	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 01:22:52.276104+00	
00000000-0000-0000-0000-000000000000	8aa821ba-71a0-425e-a349-2cf3738dda5b	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 01:22:53.142344+00	
00000000-0000-0000-0000-000000000000	0b3fd5f4-1ca4-4bc9-9a0f-ae91f480e0a6	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 01:22:54.28074+00	
00000000-0000-0000-0000-000000000000	150935e5-68f0-4197-b83b-6d032d2e26ac	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 01:36:23.262925+00	
00000000-0000-0000-0000-000000000000	fe2cd7ad-ffc0-4f5e-b3ef-e790e8d011b1	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 01:36:23.263544+00	
00000000-0000-0000-0000-000000000000	4543c397-b443-4e7c-97cc-954deaf22790	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 01:36:23.603885+00	
00000000-0000-0000-0000-000000000000	360c4325-857b-4605-af86-71d0ca6921ec	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 01:37:26.190288+00	
00000000-0000-0000-0000-000000000000	6a3df380-60dc-4618-bd09-02f95492cf7f	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 01:50:39.138994+00	
00000000-0000-0000-0000-000000000000	56b46368-d7cf-431e-99dc-b9f8bb5b35c6	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 01:50:39.140027+00	
00000000-0000-0000-0000-000000000000	840574b2-74ce-4323-83fb-0c1812637602	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 01:50:46.765377+00	
00000000-0000-0000-0000-000000000000	ff1f0d5d-e4f2-431a-aa60-ac08917273e2	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 01:52:53.66243+00	
00000000-0000-0000-0000-000000000000	9f71626f-2592-48f9-926c-4f9c7470abc6	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 02:09:44.498318+00	
00000000-0000-0000-0000-000000000000	730a0351-5eff-4624-9f7a-9e93b194eebe	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 02:09:44.498983+00	
00000000-0000-0000-0000-000000000000	2407ac16-9f68-4582-a347-007d59aea074	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 02:09:45.530967+00	
00000000-0000-0000-0000-000000000000	734369d3-571e-4672-86f8-173fdbcc2198	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 16:13:06.164485+00	
00000000-0000-0000-0000-000000000000	27860334-5605-493b-a069-2f88fad3eb1a	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 16:13:06.1661+00	
00000000-0000-0000-0000-000000000000	2bb03382-4d55-49e0-8186-5f4aad3fb733	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 16:19:50.504986+00	
00000000-0000-0000-0000-000000000000	4ef7b762-a8b2-4b64-9496-cb61df9547a7	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 16:26:35.834398+00	
00000000-0000-0000-0000-000000000000	d74acc02-d99b-4057-976a-1d1546b39915	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 16:26:35.83506+00	
00000000-0000-0000-0000-000000000000	0ef7c868-c9dc-496e-874c-4e96094868ee	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 16:40:05.916568+00	
00000000-0000-0000-0000-000000000000	21b1bb75-b53a-4aed-b9bc-3625c9393775	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 16:40:05.917881+00	
00000000-0000-0000-0000-000000000000	e032ff00-ca57-458d-b355-c50c6b0dd4a3	{"action":"user_recovery_requested","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"user"}	2023-12-18 16:45:28.444896+00	
00000000-0000-0000-0000-000000000000	db45e36e-8ea2-4bff-bee6-ff2415c3e293	{"action":"login","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"account"}	2023-12-18 16:45:54.108395+00	
00000000-0000-0000-0000-000000000000	213c7597-ef9f-423b-8aa5-d65249855594	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 16:58:56.781169+00	
00000000-0000-0000-0000-000000000000	028f49b8-93db-41e2-b048-88c7aa287ebb	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 16:58:56.781808+00	
00000000-0000-0000-0000-000000000000	c5d99d61-8a9d-40c6-a671-1fe1c8fb614d	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 16:58:59.852776+00	
00000000-0000-0000-0000-000000000000	74565352-8fd1-4d28-8d71-f41fe2c81a8c	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 17:03:56.134496+00	
00000000-0000-0000-0000-000000000000	e44f9b12-337a-4cdd-bd0d-1ec7a0c97fda	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 17:16:59.344318+00	
00000000-0000-0000-0000-000000000000	4bd1066b-dc48-4c38-9163-d9009063e680	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 17:16:59.346606+00	
00000000-0000-0000-0000-000000000000	603b4739-4ada-4160-a038-673da9c79840	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 17:17:07.516489+00	
00000000-0000-0000-0000-000000000000	6b78d311-98bb-4b8e-a27c-5f9afba0d380	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 17:17:09.16496+00	
00000000-0000-0000-0000-000000000000	20e6f6b3-60b6-4962-b784-842a2a60bcbe	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 17:30:39.161045+00	
00000000-0000-0000-0000-000000000000	67ce8da6-f3a9-4bc4-bf82-bdb55fd82b52	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 17:30:39.163244+00	
00000000-0000-0000-0000-000000000000	127a353e-63d5-47a2-8f85-71b4fbab65e3	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 17:43:43.611279+00	
00000000-0000-0000-0000-000000000000	d27fd1bf-1a50-469a-9b3a-d1382fd2a972	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 17:43:43.612299+00	
00000000-0000-0000-0000-000000000000	5b54d467-2d5d-4ffe-ac85-c4fd7e6e4924	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 18:18:40.107618+00	
00000000-0000-0000-0000-000000000000	d61dfd1d-91e6-4431-a096-4bc779bafbde	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 18:18:40.109178+00	
00000000-0000-0000-0000-000000000000	fb55cf81-4435-4a80-9162-0ee75ee64deb	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 18:31:46.008309+00	
00000000-0000-0000-0000-000000000000	c11ffe1e-b32d-4919-bae1-4378a79bd1f5	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 18:31:46.009086+00	
00000000-0000-0000-0000-000000000000	afa3650a-9224-48b8-ab3f-50776a10d10a	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 18:31:50.599489+00	
00000000-0000-0000-0000-000000000000	f1ecfd60-42bb-4f9e-baa2-8cef29bc1ece	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 18:34:57.576922+00	
00000000-0000-0000-0000-000000000000	5df8841b-395d-46f7-8b7e-96831c90f9a1	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 18:44:50.632227+00	
00000000-0000-0000-0000-000000000000	f31b1b01-664c-4a77-a330-6a7eccc74ce7	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 18:44:50.634432+00	
00000000-0000-0000-0000-000000000000	bfd76681-1002-47ee-9840-13bd7afe67e5	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 18:45:15.314138+00	
00000000-0000-0000-0000-000000000000	1eb3a0f9-e8a4-49b3-9296-70544af55cce	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 18:47:59.186221+00	
00000000-0000-0000-0000-000000000000	0c7b36d8-75ce-4391-baa9-04e26211c9e8	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 18:48:01.017651+00	
00000000-0000-0000-0000-000000000000	f91ca004-5319-4203-accb-d2a40fb0d62a	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 18:48:03.19595+00	
00000000-0000-0000-0000-000000000000	89fe44f2-6d04-4100-9dd9-097926049baf	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 18:48:05.405868+00	
00000000-0000-0000-0000-000000000000	85e56874-c1e2-435e-9c91-4099d72d9312	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 18:48:10.475619+00	
00000000-0000-0000-0000-000000000000	15d8f6e6-dfb7-4112-9654-d5ac13900320	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 18:48:12.001986+00	
00000000-0000-0000-0000-000000000000	1ed7b725-7679-48a2-bfda-5d90a26753c7	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 18:48:12.374592+00	
00000000-0000-0000-0000-000000000000	956b76b9-14f8-4177-8e15-7d53e0d35d39	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 18:48:19.531053+00	
00000000-0000-0000-0000-000000000000	a6cc35b6-306e-45eb-b8db-e69b17887cc6	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 18:48:21.230896+00	
00000000-0000-0000-0000-000000000000	507bb236-13f5-4a86-9fec-6f01b38dc97e	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 18:48:23.117408+00	
00000000-0000-0000-0000-000000000000	59b7654e-de35-401a-ab03-e3fb16a4ea2f	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 19:01:07.340813+00	
00000000-0000-0000-0000-000000000000	c9df6d6d-b16a-4b74-a0b1-05a6968dbe3b	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 19:01:07.342156+00	
00000000-0000-0000-0000-000000000000	80b4e04a-981e-41c0-a172-066ed547aafa	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 19:01:17.790887+00	
00000000-0000-0000-0000-000000000000	73ece5d5-eb4c-4419-b1e4-8901043d13fa	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 19:01:18.359939+00	
00000000-0000-0000-0000-000000000000	c1e3be94-ef45-4df7-83c8-9539a1a524a8	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 19:01:20.217984+00	
00000000-0000-0000-0000-000000000000	c493bf2f-801d-4fd3-97b6-0dcf35ba8314	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 19:01:27.008157+00	
00000000-0000-0000-0000-000000000000	1ee95c23-7ec2-41cd-9527-fe1239102c48	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 19:14:18.167619+00	
00000000-0000-0000-0000-000000000000	8a615cc9-6443-4ebd-8ef8-64e97f7bc2f8	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 19:14:18.169205+00	
00000000-0000-0000-0000-000000000000	d292487b-9f2d-4019-86d7-3e761e96ad71	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 19:14:36.718407+00	
00000000-0000-0000-0000-000000000000	402ec1b7-baae-4b73-b35d-75e5fc117fa0	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 19:14:48.391583+00	
00000000-0000-0000-0000-000000000000	92e8176c-3090-43f3-be58-e6dc97acdeb9	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 19:14:50.329388+00	
00000000-0000-0000-0000-000000000000	e5d3a57b-cb9f-4d83-bce7-203e4a8f5e21	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 19:14:57.048376+00	
00000000-0000-0000-0000-000000000000	883ed9b3-eafd-44c8-8166-571a52bfa6a3	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 19:27:37.454414+00	
00000000-0000-0000-0000-000000000000	0bab8b5f-c573-42a0-96ff-01c50c761899	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 19:27:37.456228+00	
00000000-0000-0000-0000-000000000000	74f3e5ea-1e6e-4b6d-93df-6d98a7801e69	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 19:27:47.834833+00	
00000000-0000-0000-0000-000000000000	2f613ee2-4d71-44f1-9a16-d0753c203733	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 19:28:18.133869+00	
00000000-0000-0000-0000-000000000000	77029a33-8f6a-4e1c-9b26-d3e365292bf6	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 19:28:27.368656+00	
00000000-0000-0000-0000-000000000000	83882a16-5f47-4c46-9ce7-83fc36b22263	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 19:40:48.292231+00	
00000000-0000-0000-0000-000000000000	f9642cf0-e0d9-4280-820e-f64f4c48f5f3	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 19:40:48.293377+00	
00000000-0000-0000-0000-000000000000	29922dfb-2273-4f43-8bea-7f54657ad748	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 19:41:07.057551+00	
00000000-0000-0000-0000-000000000000	df53f3c4-1ccb-4f35-945f-84a998f26604	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 19:41:18.182069+00	
00000000-0000-0000-0000-000000000000	f13d7eae-f392-498e-b449-755aca8c8177	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 19:41:57.167217+00	
00000000-0000-0000-0000-000000000000	598e0706-62fa-427f-956a-f542eb20f9a1	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 19:54:18.280452+00	
00000000-0000-0000-0000-000000000000	47e6e8bd-74ec-4483-b96e-25c199af72d8	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 19:54:18.282349+00	
00000000-0000-0000-0000-000000000000	e6f30ff4-4e08-4757-b9fe-3784f305f5ca	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 19:54:18.512684+00	
00000000-0000-0000-0000-000000000000	14e6537b-2dab-430c-a832-1ff17b41b95e	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 19:54:37.090603+00	
00000000-0000-0000-0000-000000000000	f24ca256-7731-48c3-9e9a-94831e8b7936	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 19:55:27.228712+00	
00000000-0000-0000-0000-000000000000	45ce5e51-0a12-4c71-8db2-b13a71697bee	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 20:07:19.122906+00	
00000000-0000-0000-0000-000000000000	b8b9173b-1c27-463f-a2ba-06d354328cb5	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 20:07:19.124012+00	
00000000-0000-0000-0000-000000000000	da6b3e6f-dd15-4ca1-a380-638be770e5d3	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 20:07:47.947033+00	
00000000-0000-0000-0000-000000000000	594e73f0-21c6-4788-a07a-6f4fe76caca5	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 20:08:07.110857+00	
00000000-0000-0000-0000-000000000000	0d2ee1be-dcac-49c4-a3e7-12d1c1dd62f5	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 20:08:27.200574+00	
00000000-0000-0000-0000-000000000000	313e75e7-d932-4afa-8b1c-c0713cfd7853	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 20:20:48.314122+00	
00000000-0000-0000-0000-000000000000	776f3098-9374-4066-85de-8d17a954fb0a	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 20:20:48.315865+00	
00000000-0000-0000-0000-000000000000	63f2c98a-98d0-4d53-865c-0b54c8a7f5d1	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 20:20:48.58006+00	
00000000-0000-0000-0000-000000000000	1a274307-3e0f-419c-93ab-7ac00a7fc14f	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 20:21:27.524701+00	
00000000-0000-0000-0000-000000000000	2de7ab24-87d0-4b35-922a-a9ff3137d084	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 20:21:37.137966+00	
00000000-0000-0000-0000-000000000000	3bc35386-366d-4f17-b01e-88aa71c10fc2	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 20:33:48.993655+00	
00000000-0000-0000-0000-000000000000	e626c7aa-3236-49cf-8cf7-a07e2ba2107a	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 20:33:48.996099+00	
00000000-0000-0000-0000-000000000000	a9040b5a-1c57-4a44-870e-28cf85d67d2f	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 20:34:17.710169+00	
00000000-0000-0000-0000-000000000000	9b9375a0-47a4-4d87-b3e8-89e9d46983cc	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 20:34:27.545959+00	
00000000-0000-0000-0000-000000000000	c48bc9fb-5682-41ee-b5e6-db4042161ff4	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 20:35:06.886133+00	
00000000-0000-0000-0000-000000000000	301e46b6-4006-4aa6-8ca8-0c388ac3b7c9	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 20:47:18.390602+00	
00000000-0000-0000-0000-000000000000	57db39d8-38ef-420f-bc3f-57e5aa39f6ac	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 20:47:18.392944+00	
00000000-0000-0000-0000-000000000000	99f38e48-9745-49b7-960d-66f46bccf611	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 20:47:18.66183+00	
00000000-0000-0000-0000-000000000000	d72807b1-101e-4a73-808a-e6b359876a1c	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 20:47:27.579442+00	
00000000-0000-0000-0000-000000000000	679b3b0a-5375-495e-bf16-c3d9f516fbd1	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 20:48:06.926551+00	
00000000-0000-0000-0000-000000000000	54a4fcf9-bced-41a1-8a48-446d69fc3d12	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 21:00:19.194939+00	
00000000-0000-0000-0000-000000000000	ac482e68-e5cb-4851-811c-089592902950	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 21:00:19.196129+00	
00000000-0000-0000-0000-000000000000	c5f59be6-3cf2-4e8c-94bf-ee6ff0ec1621	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 21:00:27.614013+00	
00000000-0000-0000-0000-000000000000	14905f69-40f8-444a-9e8a-bf0ef3775d62	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 21:00:47.795009+00	
00000000-0000-0000-0000-000000000000	30cf2d24-7ecc-4a62-8ede-0307a7b2ca62	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 21:01:07.24181+00	
00000000-0000-0000-0000-000000000000	105fd102-fc91-47c3-b223-c81944cf5f25	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 21:13:28.549524+00	
00000000-0000-0000-0000-000000000000	215a4703-e49f-45d4-b9c0-7395e52ec84b	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 21:13:28.550171+00	
00000000-0000-0000-0000-000000000000	e79f3855-e47c-494a-85b6-33ac11497b96	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 21:13:47.801475+00	
00000000-0000-0000-0000-000000000000	f84109e6-2b31-44bf-8543-70936c97244f	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 21:13:48.418951+00	
00000000-0000-0000-0000-000000000000	9a2054a2-660d-4ac5-9095-d7c8c0e7b026	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 21:14:37.16517+00	
00000000-0000-0000-0000-000000000000	964fbd21-63e3-45f3-88aa-f964cbe7f2bd	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 21:26:48.529112+00	
00000000-0000-0000-0000-000000000000	4c98182e-50a4-409a-add3-62d703b351ca	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 21:26:48.529722+00	
00000000-0000-0000-0000-000000000000	a84b832c-d513-456b-b0cb-b8ac0d782280	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 21:26:48.744365+00	
00000000-0000-0000-0000-000000000000	d3959e28-721b-411c-828c-e50191ba9aa2	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 21:26:57.3649+00	
00000000-0000-0000-0000-000000000000	019df10e-ff9c-4ada-a29f-e427879aa0b9	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 21:28:07.400566+00	
00000000-0000-0000-0000-000000000000	3ebb2512-64b1-4dc5-9cea-2afbd8cf9808	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 21:39:49.445023+00	
00000000-0000-0000-0000-000000000000	4620b54e-e4d1-4cd4-9133-c51a245309a0	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 21:39:49.446489+00	
00000000-0000-0000-0000-000000000000	ad6e6853-5c79-4bd3-9905-31ac16216130	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 21:39:57.71785+00	
00000000-0000-0000-0000-000000000000	c327b0c3-7fb5-409d-86fd-474e3faeac50	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 21:40:17.862326+00	
00000000-0000-0000-0000-000000000000	52e2387b-8b77-4c39-a4ee-a7db685c990a	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 21:41:37.38617+00	
00000000-0000-0000-0000-000000000000	c34afaa4-961b-4c3a-bc43-6d3373a63e77	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 21:52:58.393336+00	
00000000-0000-0000-0000-000000000000	5730f5fb-e43b-4ea0-a65f-d50373e040a4	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 21:52:58.394016+00	
00000000-0000-0000-0000-000000000000	f9e86bf4-eaae-4612-a9f6-0fd22cdf9df2	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 21:53:17.922527+00	
00000000-0000-0000-0000-000000000000	49c3443b-8886-4bc8-9765-4eb815ea5c90	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 21:53:18.839608+00	
00000000-0000-0000-0000-000000000000	1bdec682-337e-4d08-8384-37995f7068de	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 21:55:07.725018+00	
00000000-0000-0000-0000-000000000000	4f36c4fd-074f-4f08-9c2a-4198c0cbac45	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 22:06:18.603341+00	
00000000-0000-0000-0000-000000000000	d44ea632-3a5a-47f9-a441-435d2d2c2840	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 22:06:18.604554+00	
00000000-0000-0000-0000-000000000000	f6e4eb12-647d-450e-a17e-007efa63817d	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 22:06:18.862807+00	
00000000-0000-0000-0000-000000000000	9ad7ddce-65f8-476c-b681-278c70be616d	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 22:06:27.456078+00	
00000000-0000-0000-0000-000000000000	c219a9e3-dc12-4cc2-8998-47de67c0543c	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 22:08:37.786388+00	
00000000-0000-0000-0000-000000000000	ac9d2509-5f79-4a7c-aeba-49981a5129d8	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 22:19:19.275208+00	
00000000-0000-0000-0000-000000000000	24fe7aa8-bcdc-43bf-a945-902daafe5213	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 22:19:19.276378+00	
00000000-0000-0000-0000-000000000000	eabc89dc-8250-4207-b44f-5703fa181fe1	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 22:19:27.831031+00	
00000000-0000-0000-0000-000000000000	606614e9-ecd9-49cc-9c65-977e192c7ceb	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 22:19:48.269819+00	
00000000-0000-0000-0000-000000000000	0e94a8b2-76c1-4644-8dc6-60b63671a6ce	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 22:22:08.066261+00	
00000000-0000-0000-0000-000000000000	720f5012-cdb2-4ba2-81db-d361950cebca	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 22:32:28.481502+00	
00000000-0000-0000-0000-000000000000	2743b3cd-a38a-45b7-92f8-1023db496171	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 22:32:28.482177+00	
00000000-0000-0000-0000-000000000000	3e2d6172-8562-4813-b178-0be8f18640f3	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 22:32:48.61824+00	
00000000-0000-0000-0000-000000000000	e28834d1-321b-44ca-8769-611e69e0ae6e	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 22:33:18.297618+00	
00000000-0000-0000-0000-000000000000	264df87f-7c66-492f-a0aa-33f2c582a198	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 22:35:37.816244+00	
00000000-0000-0000-0000-000000000000	92df433e-b422-4d39-873c-e3a24b6d8626	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 22:45:49.269976+00	
00000000-0000-0000-0000-000000000000	916590ca-0032-40b0-b61f-d9fde57dbfe7	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 22:45:49.270589+00	
00000000-0000-0000-0000-000000000000	d0c386ae-2d95-4e30-b98b-253dfe12fafa	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 22:45:57.596326+00	
00000000-0000-0000-0000-000000000000	ec42babd-5975-4141-9d45-48b95f1ac6fa	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 22:46:48.029632+00	
00000000-0000-0000-0000-000000000000	e02b46f1-3c36-4570-8ac7-b46c1cb92582	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 22:48:37.8461+00	
00000000-0000-0000-0000-000000000000	9803da44-ecc5-494b-ad35-37d2057c9eb4	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 22:58:58.252407+00	
00000000-0000-0000-0000-000000000000	687e2a8d-e0dc-4c83-a9b3-f1e58adde473	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 22:58:58.253015+00	
00000000-0000-0000-0000-000000000000	1a1c5545-823c-4a83-a50e-c1c4503abb2b	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 22:59:18.974843+00	
00000000-0000-0000-0000-000000000000	d1410f24-1f2e-41e2-985b-aceb296a0cca	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 23:00:18.404506+00	
00000000-0000-0000-0000-000000000000	9fed6977-015b-4dbb-8ffa-9845be239b0f	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 23:01:37.602037+00	
00000000-0000-0000-0000-000000000000	031a84f6-5e8f-49f8-b1e5-d23c7606d21a	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 23:12:19.42572+00	
00000000-0000-0000-0000-000000000000	b7e56033-d481-44ac-8edc-3545ada8b65d	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 23:12:19.426325+00	
00000000-0000-0000-0000-000000000000	ac35a98a-8df7-4f9e-914a-0873e7518e75	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 23:12:27.957278+00	
00000000-0000-0000-0000-000000000000	8f6760d4-39b6-4228-8527-1bb5daf9c66f	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 23:13:48.452855+00	
00000000-0000-0000-0000-000000000000	d1013ad4-a786-49f6-b0ff-d371da7d3701	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 23:14:37.601874+00	
00000000-0000-0000-0000-000000000000	69496d70-ec6a-4823-a139-8ba90c2d5f13	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 23:25:28.368355+00	
00000000-0000-0000-0000-000000000000	455b9e70-5fe4-4a3b-a7fb-77b3b598ee1d	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 23:25:28.369052+00	
00000000-0000-0000-0000-000000000000	464da76c-2c70-490d-9c4c-5d55aede213e	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 23:25:49.06539+00	
00000000-0000-0000-0000-000000000000	7658fa3a-7fcb-45b7-92ad-46e81ca75af3	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 23:27:18.496548+00	
00000000-0000-0000-0000-000000000000	6fe9f4d3-24a7-4010-b832-023d97f00135	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 23:27:37.616967+00	
00000000-0000-0000-0000-000000000000	7906e855-ed4a-4cc4-8cd7-4f2f9b043e09	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 23:38:58.357361+00	
00000000-0000-0000-0000-000000000000	4d70553c-61db-4544-836d-fd66e6edc9b5	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 23:38:58.358396+00	
00000000-0000-0000-0000-000000000000	80300008-2136-4dcd-b42c-7962834730e2	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 23:39:19.090062+00	
00000000-0000-0000-0000-000000000000	73f10a37-82e7-4bad-b113-37b3eb3829b3	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 23:40:18.526365+00	
00000000-0000-0000-0000-000000000000	2d5a576b-bb1e-4264-a0b1-26126f75331a	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 23:40:37.674397+00	
00000000-0000-0000-0000-000000000000	3111fbcb-5c27-4b13-85a0-2ce380111f7e	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 23:52:28.373602+00	
00000000-0000-0000-0000-000000000000	34bc26a8-a40b-4b70-a462-94343bc07d6d	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 23:52:28.374415+00	
00000000-0000-0000-0000-000000000000	36ca5a6d-90f4-4076-a421-d1ff9a83e985	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 23:52:49.13182+00	
00000000-0000-0000-0000-000000000000	080080e8-f364-4c75-a262-c36407837c4f	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 23:53:18.51718+00	
00000000-0000-0000-0000-000000000000	0686d11d-5958-411f-bb96-840e66d2e511	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-18 23:53:37.381563+00	
00000000-0000-0000-0000-000000000000	4b96d0e6-887f-47f0-abd3-4a31c8ac568c	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 00:05:58.462823+00	
00000000-0000-0000-0000-000000000000	01ac6fb9-d563-46d0-a21c-7a529a621b0f	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 00:05:58.463489+00	
00000000-0000-0000-0000-000000000000	46c0c75b-7ac2-43b0-a9a2-4df1c2017587	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 00:06:18.536083+00	
00000000-0000-0000-0000-000000000000	dbbfc228-9da2-416c-b0c3-fd5bb54640f9	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 00:06:18.857776+00	
00000000-0000-0000-0000-000000000000	d9db4a95-a2b2-4e37-995f-7f26c3660f5d	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 00:06:37.411098+00	
00000000-0000-0000-0000-000000000000	5881ab21-def2-4c33-9121-d7fbcccfd00b	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 00:19:18.954198+00	
00000000-0000-0000-0000-000000000000	98a2926b-3d57-44b0-986a-10ccffde8291	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 00:19:18.955501+00	
00000000-0000-0000-0000-000000000000	1e5860a1-386a-40f7-baeb-a6ad7743e36a	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 00:19:19.184045+00	
00000000-0000-0000-0000-000000000000	3ac1df38-bc2d-4261-825c-dbf2edb5f2d1	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 00:19:27.82528+00	
00000000-0000-0000-0000-000000000000	3e540dc3-1eed-470b-a561-4ea7a9075735	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 00:19:37.757247+00	
00000000-0000-0000-0000-000000000000	fdda53f8-89c9-4bbf-9bd1-6fd29668c651	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 00:32:18.946001+00	
00000000-0000-0000-0000-000000000000	36756b42-e29d-47c2-9c50-993a1fbdeca4	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 00:32:18.946691+00	
00000000-0000-0000-0000-000000000000	290d40f6-cc68-4574-bb7f-4827f2876d5d	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 00:32:28.14117+00	
00000000-0000-0000-0000-000000000000	795fc83f-4992-422c-b6e0-ef901ea5f922	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 00:32:37.788419+00	
00000000-0000-0000-0000-000000000000	83bc0af5-b80b-4313-a516-e97ac5bc2925	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 00:32:48.922783+00	
00000000-0000-0000-0000-000000000000	df8b49db-ee9a-4ea4-89c9-7d28ac7f81d3	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 00:45:18.997733+00	
00000000-0000-0000-0000-000000000000	0396567a-75d2-4c33-b4bb-78b34550c6c7	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 00:45:18.999052+00	
00000000-0000-0000-0000-000000000000	9ef891e4-8877-4f6a-84cb-a808c09c54f6	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 00:45:37.828838+00	
00000000-0000-0000-0000-000000000000	dbe083fa-9815-413e-a71f-17d1ef17cbbe	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 00:45:48.996617+00	
00000000-0000-0000-0000-000000000000	8b312cef-dac0-4ad2-914c-e67789dc72d5	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 00:45:58.183186+00	
00000000-0000-0000-0000-000000000000	8b650829-846d-4098-ae7c-818133ebde60	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 00:58:38.186226+00	
00000000-0000-0000-0000-000000000000	4d8da091-9caf-408e-adbe-f39534eee9b4	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 00:58:38.186846+00	
00000000-0000-0000-0000-000000000000	3a6ca94e-e4a2-4e0a-bea2-8bcae05bda46	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 00:58:48.678611+00	
00000000-0000-0000-0000-000000000000	3ed3a474-f294-4bd1-a00a-88ccaeab56ec	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 00:58:49.290964+00	
00000000-0000-0000-0000-000000000000	8e479b18-c088-4c11-8292-bd10eb5f9f43	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 00:59:27.92286+00	
00000000-0000-0000-0000-000000000000	4227c955-65fa-48dd-abd5-1d820f8a1db7	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 01:11:49.080034+00	
00000000-0000-0000-0000-000000000000	7496fedc-ebcf-483e-b774-b19e47e53d18	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 01:11:49.080729+00	
00000000-0000-0000-0000-000000000000	65b29659-6b0d-4c5e-9d6c-1fecae67279e	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 01:12:07.893861+00	
00000000-0000-0000-0000-000000000000	d32b908a-a58b-4e6f-94bd-2a50f3ea2c02	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 01:12:19.334216+00	
00000000-0000-0000-0000-000000000000	881d9fd8-4d4b-4254-a9e6-9e5d80e73248	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 01:12:27.944036+00	
00000000-0000-0000-0000-000000000000	97b1cd2f-91dd-4584-9da9-73488c1d7ebd	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 01:25:08.620783+00	
00000000-0000-0000-0000-000000000000	52bdfc50-ee04-402c-a721-0174561927e7	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 01:25:08.622183+00	
00000000-0000-0000-0000-000000000000	dce7301b-4721-4e78-a8e5-961c69329758	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 01:25:18.737283+00	
00000000-0000-0000-0000-000000000000	97a85155-ff26-42a4-a0d7-3ee776d780b3	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 01:25:28.295411+00	
00000000-0000-0000-0000-000000000000	f6b01aeb-3be1-4dc5-871a-54f4be3fc3d8	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 01:25:49.086394+00	
00000000-0000-0000-0000-000000000000	6b520420-8b3a-4357-bb4f-a04693fda2b1	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 01:38:19.173096+00	
00000000-0000-0000-0000-000000000000	4e47f83d-7fdf-464c-b09e-d678b54d31bc	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 01:38:19.173729+00	
00000000-0000-0000-0000-000000000000	bdf46a6b-3b87-4887-b909-10919b5aa680	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 01:38:37.960777+00	
00000000-0000-0000-0000-000000000000	97ef3be6-2f60-462a-a685-6ecb14fdb909	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 01:38:58.318109+00	
00000000-0000-0000-0000-000000000000	6f22bc00-65d6-4983-addf-62228dd9afa5	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 01:39:19.111617+00	
00000000-0000-0000-0000-000000000000	b6f10cd5-b0c1-4522-97ca-8b1aec6f684d	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 01:51:38.518658+00	
00000000-0000-0000-0000-000000000000	425428cc-ee30-4359-b34a-d8db2640554a	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 01:51:38.519929+00	
00000000-0000-0000-0000-000000000000	e45a58db-3d96-428a-b3c5-7e4f47e4467a	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 01:51:48.807795+00	
00000000-0000-0000-0000-000000000000	f45c0728-cb3f-4bab-ae4e-54c385fedbfb	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 01:52:28.060676+00	
00000000-0000-0000-0000-000000000000	c4ec3cd2-f2cc-4432-8bda-ab484533a303	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 01:52:49.147229+00	
00000000-0000-0000-0000-000000000000	c2cf6878-6bb0-4b76-8c1a-a294720e8034	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 02:04:49.199329+00	
00000000-0000-0000-0000-000000000000	c89f1d0c-83fd-4a99-bfd7-c9fbdec55dea	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 02:04:49.199951+00	
00000000-0000-0000-0000-000000000000	75d5660c-a2da-4bdb-8b6b-94fe559f07ae	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 02:05:08.032256+00	
00000000-0000-0000-0000-000000000000	febc4af1-7b89-4695-80ec-eb1400976ded	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 02:05:49.230744+00	
00000000-0000-0000-0000-000000000000	71a48240-ceaf-4d04-8d74-639b1b3ecb47	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 02:05:58.088768+00	
00000000-0000-0000-0000-000000000000	2b9c51f7-9e98-4b65-ba82-2a530987fec1	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 02:18:19.217074+00	
00000000-0000-0000-0000-000000000000	01664b55-f70f-4df4-b57c-8851e17d5a8e	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 02:18:19.217703+00	
00000000-0000-0000-0000-000000000000	cd28b80d-09c2-4a33-9cf7-f093d53185af	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 02:18:38.065318+00	
00000000-0000-0000-0000-000000000000	46f85d03-cdc3-46db-af15-8429571605eb	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 02:18:49.509467+00	
00000000-0000-0000-0000-000000000000	cfc97abb-ef60-416e-bda4-133e45b5820d	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 02:19:28.164396+00	
00000000-0000-0000-0000-000000000000	9ccc67b7-ee16-4b00-8e9c-76f8fd7042a9	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 02:31:49.292925+00	
00000000-0000-0000-0000-000000000000	c4dcd4db-cc0c-4b9a-854a-ea53e4c02d06	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 02:31:49.29355+00	
00000000-0000-0000-0000-000000000000	d4e85392-6df1-49a4-8fc9-66b7314075c8	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 02:31:49.53276+00	
00000000-0000-0000-0000-000000000000	e815ab16-fbda-413f-b9ba-6b6974507b0f	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 02:32:08.111195+00	
00000000-0000-0000-0000-000000000000	074645c3-4026-48b1-8b0c-8c395b96e730	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 02:32:28.154324+00	
00000000-0000-0000-0000-000000000000	5fe6ad06-2973-44f2-8059-ab879294c16d	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 02:44:49.931798+00	
00000000-0000-0000-0000-000000000000	3cde423f-2918-46cb-aabb-41e0636dc9b9	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 02:44:49.93305+00	
00000000-0000-0000-0000-000000000000	a57fcf54-af9d-4629-973f-e8cc548d08aa	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 02:45:18.954568+00	
00000000-0000-0000-0000-000000000000	4bafeab5-5e6f-45e0-a85b-c46528b99363	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 02:45:28.200017+00	
00000000-0000-0000-0000-000000000000	bd22740e-d0af-438f-8d4e-8210e0e47816	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 02:45:38.128153+00	
00000000-0000-0000-0000-000000000000	f6b4b8c0-268f-4eeb-a0db-5ae356c796b3	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 02:57:50.006079+00	
00000000-0000-0000-0000-000000000000	8f4f1f8c-b6db-4776-b8c6-e89f93e86d34	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 02:57:50.007393+00	
00000000-0000-0000-0000-000000000000	1df05678-bb9e-451a-a078-83337b36f5d5	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 02:58:18.685804+00	
00000000-0000-0000-0000-000000000000	48a50692-ce03-4011-b3d0-b6edf76506f1	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 02:58:28.364285+00	
00000000-0000-0000-0000-000000000000	cd655766-7684-4136-bb62-7a684cbae290	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 02:59:08.173596+00	
00000000-0000-0000-0000-000000000000	78312756-de82-44fd-bec6-a58ef0b67814	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 03:11:19.552474+00	
00000000-0000-0000-0000-000000000000	a9197c74-69fc-46ee-8292-5a3d881ada29	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 03:11:19.553776+00	
00000000-0000-0000-0000-000000000000	26df7d58-80a1-47ce-976a-ab896768dce3	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 03:11:19.652138+00	
00000000-0000-0000-0000-000000000000	4bfa06e2-edab-4203-9f6b-43cb76b55858	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 03:11:28.543532+00	
00000000-0000-0000-0000-000000000000	23ffde58-57c5-4908-993b-5e74e2344b85	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 03:12:38.372422+00	
00000000-0000-0000-0000-000000000000	db6a7f78-c62a-4652-a649-52f5fbc86255	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 03:24:20.10184+00	
00000000-0000-0000-0000-000000000000	14376400-5f68-4b3f-95db-7f560afa119f	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 03:24:20.102509+00	
00000000-0000-0000-0000-000000000000	2707eb61-7701-412e-abec-d0107d47aae8	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 03:24:28.285461+00	
00000000-0000-0000-0000-000000000000	c1a23c39-2cad-4127-ae37-7c34ff7e99c9	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 03:24:49.045805+00	
00000000-0000-0000-0000-000000000000	446df3eb-ad1b-4742-be47-3139a6bdd913	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 03:26:08.286852+00	
00000000-0000-0000-0000-000000000000	f6a81206-7913-443b-b94d-088168c501b2	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 03:37:28.980938+00	
00000000-0000-0000-0000-000000000000	6fc5b1d3-3a60-4002-b801-00253cd7cb5f	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 03:37:28.981562+00	
00000000-0000-0000-0000-000000000000	a16cfd78-89d2-4464-8b67-13f0d86b7a2c	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 03:37:49.721045+00	
00000000-0000-0000-0000-000000000000	3db0b43e-41a2-470a-ac21-ebf50c098d8e	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 03:38:19.074626+00	
00000000-0000-0000-0000-000000000000	5ad02b10-efc2-434b-aaf7-847161adcbf9	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 03:39:38.333494+00	
00000000-0000-0000-0000-000000000000	a4fef86e-49c2-44fe-8e0e-cf43a9f7a1e2	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 03:50:29.021219+00	
00000000-0000-0000-0000-000000000000	8d1dd598-547e-4d67-8c36-f31407b1d2a2	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 03:50:29.02186+00	
00000000-0000-0000-0000-000000000000	eec1eb7e-af30-4996-b291-92a46e2fd677	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 03:50:49.775274+00	
00000000-0000-0000-0000-000000000000	6224af93-ab50-41fc-88da-283db73dbb25	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 03:51:49.157432+00	
00000000-0000-0000-0000-000000000000	10180bf4-be76-4143-84a2-fcc578f5203b	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 03:53:08.361001+00	
00000000-0000-0000-0000-000000000000	044c8770-8181-4321-99cf-e18791325b84	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 04:03:50.194619+00	
00000000-0000-0000-0000-000000000000	aa50d690-9abf-4f7b-860b-800df5f241e9	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 04:03:50.195315+00	
00000000-0000-0000-0000-000000000000	d28384e6-d1fe-4db3-bff9-33f139925be7	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 04:03:58.689965+00	
00000000-0000-0000-0000-000000000000	5087272a-13ab-4fad-aab7-565140ade1fc	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 04:05:19.214795+00	
00000000-0000-0000-0000-000000000000	4c649484-dd82-427b-9ee8-6443885b1e43	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 04:06:38.420251+00	
00000000-0000-0000-0000-000000000000	912ce77e-0a09-4b39-9f0f-4cc6d64d26e7	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 04:16:59.079282+00	
00000000-0000-0000-0000-000000000000	d62c47df-e720-4ec7-90b0-e1a794f2b0f0	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 04:16:59.079968+00	
00000000-0000-0000-0000-000000000000	48842b64-7534-42d5-bc87-e43e4e88430d	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 04:17:19.866204+00	
00000000-0000-0000-0000-000000000000	d999464f-e853-436d-a26f-b9aa2bfde71a	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 04:18:49.226893+00	
00000000-0000-0000-0000-000000000000	8c6e5a00-c897-4d02-adb7-bd4ee183acfe	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 04:20:08.424202+00	
00000000-0000-0000-0000-000000000000	566e6d1c-57d3-4679-b1cf-f3c1b4d4d251	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 04:30:20.242172+00	
00000000-0000-0000-0000-000000000000	a45ae545-52db-47ea-b5e5-b1636476cbef	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 04:30:20.242834+00	
00000000-0000-0000-0000-000000000000	9c97e8fc-7ab5-4a00-b836-ab084dbcad83	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 04:30:28.750417+00	
00000000-0000-0000-0000-000000000000	f8d73d02-3d03-4d2b-b9ac-f3c603722a37	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 04:32:19.571359+00	
00000000-0000-0000-0000-000000000000	7e48bfcd-321c-46e8-934e-da2681d51660	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 04:33:38.463169+00	
00000000-0000-0000-0000-000000000000	bf748ff5-6248-45d0-b88c-19e98acbdd21	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 04:43:29.16563+00	
00000000-0000-0000-0000-000000000000	e95298dd-2725-4161-a8f8-5b213c340c51	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 04:43:29.166282+00	
00000000-0000-0000-0000-000000000000	e28b09b5-8c43-4fd6-aad9-fd201426f955	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 04:43:49.88626+00	
00000000-0000-0000-0000-000000000000	a82bbe21-da51-40ed-b1fa-bfa507ac3c09	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 04:45:49.646909+00	
00000000-0000-0000-0000-000000000000	feabae73-316e-4fb9-8dff-ddeb2dc72c59	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 04:47:08.528714+00	
00000000-0000-0000-0000-000000000000	64f603c8-3643-4f12-b3a4-3b4fdf7448ee	{"action":"user_recovery_requested","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"user"}	2023-12-19 04:50:48.473134+00	
00000000-0000-0000-0000-000000000000	3965c549-b9f9-4973-a6ab-cc95bac63030	{"action":"login","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"account"}	2023-12-19 04:51:10.849274+00	
00000000-0000-0000-0000-000000000000	aa81dbab-2470-40d6-90dc-751cad376382	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 05:12:24.393578+00	
00000000-0000-0000-0000-000000000000	71e68f32-7094-4472-9402-5ede1a84d3a4	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 05:12:24.394304+00	
00000000-0000-0000-0000-000000000000	8c0b67cb-a498-4910-a028-9e5c5dde8c78	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 05:25:26.758857+00	
00000000-0000-0000-0000-000000000000	4ea0f3c9-fd07-44c2-ae48-e1ed15e8cf06	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 05:25:26.759523+00	
00000000-0000-0000-0000-000000000000	324c8cf9-bdfe-4252-afe9-d99643083b80	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 05:26:47.439278+00	
00000000-0000-0000-0000-000000000000	6ec736ef-3082-4d6f-8896-e99b8b121c9e	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 05:38:56.708615+00	
00000000-0000-0000-0000-000000000000	3ed9af78-cf27-4eb8-9b92-f1de77f626f8	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 05:38:56.709224+00	
00000000-0000-0000-0000-000000000000	1cedded5-8294-4109-ae11-baa678b07581	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 05:52:26.763845+00	
00000000-0000-0000-0000-000000000000	b7962c50-3375-434e-8748-dc9f30615ec2	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 05:52:26.764535+00	
00000000-0000-0000-0000-000000000000	6fa22092-ebdf-4492-b06f-449ba83c6259	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 06:05:56.772961+00	
00000000-0000-0000-0000-000000000000	23b72456-1241-49ba-8550-6a6475a1677a	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 06:05:56.773576+00	
00000000-0000-0000-0000-000000000000	24def446-8eab-45cc-9643-b95b3aa624c4	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 06:19:26.806365+00	
00000000-0000-0000-0000-000000000000	0e162ff9-60c0-481c-beef-75d1f18a1175	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 06:19:26.806974+00	
00000000-0000-0000-0000-000000000000	20cc7d75-ac78-406b-8d72-cefe07e67755	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 06:32:56.892055+00	
00000000-0000-0000-0000-000000000000	7b274938-3503-4666-ac33-3a01fba1ace0	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 06:32:56.892777+00	
00000000-0000-0000-0000-000000000000	f541f2e2-d065-4b6a-ac49-3fd36f9ce973	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 06:45:56.921026+00	
00000000-0000-0000-0000-000000000000	d16c74db-ea97-4aff-baed-52c55bea889f	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 06:45:56.92163+00	
00000000-0000-0000-0000-000000000000	9adb6ddd-d17a-4204-b7ca-a0d65d0dc3c2	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 06:58:56.942186+00	
00000000-0000-0000-0000-000000000000	64bd8298-0983-4122-88de-6f2458d97d28	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 06:58:56.942824+00	
00000000-0000-0000-0000-000000000000	a8de3041-430a-4fb8-81fc-1c3733a72729	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 07:11:56.949428+00	
00000000-0000-0000-0000-000000000000	353f09c8-f25a-4dcf-9196-e387d9588814	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 07:11:56.950052+00	
00000000-0000-0000-0000-000000000000	2d199e94-be3c-4c6b-8f28-8d9ee13e6aa2	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 07:24:57.028072+00	
00000000-0000-0000-0000-000000000000	c90dbde3-99e2-4acb-99c2-6ac6fe2a7bbd	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 07:24:57.028748+00	
00000000-0000-0000-0000-000000000000	653fc038-9545-48e1-9a0b-d71afdc33878	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 07:38:27.126996+00	
00000000-0000-0000-0000-000000000000	77532bfb-b273-462f-bf31-9724ea848ad9	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 07:38:27.127672+00	
00000000-0000-0000-0000-000000000000	17851be6-9e30-4586-ad05-3743306dbc88	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 07:51:57.096049+00	
00000000-0000-0000-0000-000000000000	1eb6c3fb-a2f1-40b6-9ef2-b0211352107d	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 07:51:57.096755+00	
00000000-0000-0000-0000-000000000000	c2c962b3-b26f-4e25-9054-fd51bc8caad1	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 08:05:27.069496+00	
00000000-0000-0000-0000-000000000000	9d4d235d-9d35-495d-b373-56ce1acd2eed	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 08:05:27.070113+00	
00000000-0000-0000-0000-000000000000	4a749adf-6d1e-414f-b178-d24cd419fcb3	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 08:18:57.087384+00	
00000000-0000-0000-0000-000000000000	fed5e761-6020-40c3-a613-838b6435c45c	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 08:18:57.088145+00	
00000000-0000-0000-0000-000000000000	d8ec3b9b-0343-46d7-be08-0024306a9e69	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 08:32:27.328132+00	
00000000-0000-0000-0000-000000000000	b3dc203d-b385-4d34-8520-171b9eb8a6f9	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 08:32:27.328795+00	
00000000-0000-0000-0000-000000000000	2a5107ea-70b3-420e-bc8c-1f521fae0355	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 08:45:57.288086+00	
00000000-0000-0000-0000-000000000000	6698080d-c205-4c9c-b157-6f2b3964ce5e	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 08:45:57.288703+00	
00000000-0000-0000-0000-000000000000	1f27cf01-4cc4-4ebc-ae01-90389cd87537	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 08:59:27.264997+00	
00000000-0000-0000-0000-000000000000	08b6e265-44de-43e8-a2b7-e37509bd9e01	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 08:59:27.265681+00	
00000000-0000-0000-0000-000000000000	f70365bf-07f0-4bb4-b6a2-df0fc609f8cb	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 09:12:57.229783+00	
00000000-0000-0000-0000-000000000000	6feaee4b-717c-4c9b-a865-1b9877f9f22f	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 09:12:57.230371+00	
00000000-0000-0000-0000-000000000000	990756ff-eff9-4714-b736-15b116fd3f9d	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 09:26:27.277894+00	
00000000-0000-0000-0000-000000000000	f94b8a61-6235-4c54-8a98-533015e092c0	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 09:26:27.278729+00	
00000000-0000-0000-0000-000000000000	6ee52724-8107-42b9-87bc-2015b83e9242	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 09:39:57.361832+00	
00000000-0000-0000-0000-000000000000	72047e0a-2540-4065-adba-44c359ab87c9	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 09:39:57.362443+00	
00000000-0000-0000-0000-000000000000	1c525200-fef5-4b2e-baf2-fd702a8166a2	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 09:53:27.392909+00	
00000000-0000-0000-0000-000000000000	4e506c5b-bc49-406f-a7f5-c9d5827619be	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 09:53:27.393493+00	
00000000-0000-0000-0000-000000000000	de5b275a-b12f-490b-9217-eec5fedbbb32	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 10:06:57.447727+00	
00000000-0000-0000-0000-000000000000	9e3ee1d3-d541-42ed-9816-b4dc91378f28	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 10:06:57.448392+00	
00000000-0000-0000-0000-000000000000	4f5379cf-28bc-49fe-98cd-eefa9e3d87d8	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 10:20:27.615914+00	
00000000-0000-0000-0000-000000000000	47f78bcc-831a-42ce-9b17-9962c54afd77	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 10:20:27.616509+00	
00000000-0000-0000-0000-000000000000	007a8f0a-982a-482c-b251-122625cbf42c	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 10:33:57.622729+00	
00000000-0000-0000-0000-000000000000	f35ffcf0-e045-4311-9f25-6112143c0973	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 10:33:57.623368+00	
00000000-0000-0000-0000-000000000000	13145db6-674d-4433-bbf3-8354f341d915	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 10:47:27.546065+00	
00000000-0000-0000-0000-000000000000	0539936d-7cb1-4a97-aa24-10a705772e78	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 10:47:27.546689+00	
00000000-0000-0000-0000-000000000000	a3627dec-3227-4f47-bbb3-76417a1b9260	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 11:00:57.608869+00	
00000000-0000-0000-0000-000000000000	3fde2522-9af6-4476-9d55-90cc3d09df0e	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 11:00:57.609503+00	
00000000-0000-0000-0000-000000000000	73e39b90-ba99-4d65-8f8c-da0bcd7a284d	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 11:14:27.710552+00	
00000000-0000-0000-0000-000000000000	4834460f-7d1d-4540-ab58-5aea5c6ac373	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 11:14:27.7112+00	
00000000-0000-0000-0000-000000000000	442368f5-a138-4498-85a8-134b997b0e19	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 11:27:57.841254+00	
00000000-0000-0000-0000-000000000000	2c4856b3-f819-4704-97eb-448d40e6f997	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 11:27:57.842023+00	
00000000-0000-0000-0000-000000000000	f13a9fe3-4b54-42eb-a043-bce12b9785cd	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 11:41:27.80663+00	
00000000-0000-0000-0000-000000000000	3545f04f-6b15-4f5d-a509-f8184b3c261b	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 11:41:27.807376+00	
00000000-0000-0000-0000-000000000000	d7dea63a-f1d2-42c3-b5ab-20fd98204b4e	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 11:54:57.848988+00	
00000000-0000-0000-0000-000000000000	1885e0cd-acb9-439a-b564-26797860dbb7	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 11:54:57.849591+00	
00000000-0000-0000-0000-000000000000	5dfffac2-f3a6-40a1-9c08-610122305320	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 12:08:27.940408+00	
00000000-0000-0000-0000-000000000000	61eb2ef7-1a55-47fe-b89b-84550db9561d	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 12:08:27.941066+00	
00000000-0000-0000-0000-000000000000	02d30ce6-72cc-470c-9b00-4402e7979434	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 12:21:57.834807+00	
00000000-0000-0000-0000-000000000000	81e1f05d-474b-4adf-bf21-189fa39bf7cd	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 12:21:57.835566+00	
00000000-0000-0000-0000-000000000000	59d993ea-b41c-40c1-8475-45b64e4f61f6	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 12:35:28.009778+00	
00000000-0000-0000-0000-000000000000	ea9d6556-fa3e-4f17-bed2-413842ca5e30	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 12:35:28.010386+00	
00000000-0000-0000-0000-000000000000	a3f5a466-cefe-482b-9330-325bb315e3bd	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 12:48:58.177933+00	
00000000-0000-0000-0000-000000000000	eeba8d0f-1955-4e1d-aaa3-0e57b0c06f53	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 12:48:58.178688+00	
00000000-0000-0000-0000-000000000000	4b46c100-24b6-447f-b1ba-b7d3b02479af	{"action":"user_recovery_requested","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"user"}	2023-12-19 14:45:15.48782+00	
00000000-0000-0000-0000-000000000000	00501120-fb2b-415d-9acc-3dbc73d61e67	{"action":"login","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"account"}	2023-12-19 14:46:23.082897+00	
00000000-0000-0000-0000-000000000000	3f1cb96e-7796-45fd-98ff-0a7c55e6fa91	{"action":"user_recovery_requested","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"user"}	2023-12-19 14:46:32.323167+00	
00000000-0000-0000-0000-000000000000	70b7beb2-1c4b-4def-a2ff-ff92f34f1c3f	{"action":"login","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"account"}	2023-12-19 14:47:33.182178+00	
00000000-0000-0000-0000-000000000000	5df3fd8b-9f47-4484-b0e8-3368df20fc9c	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 15:00:38.089464+00	
00000000-0000-0000-0000-000000000000	b31fd2a6-63d1-4551-ae16-3b06fd90f644	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 15:00:38.090037+00	
00000000-0000-0000-0000-000000000000	ccfa4f4f-4e59-4016-be43-815ec584aeaa	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 15:00:39.264321+00	
00000000-0000-0000-0000-000000000000	f7a8e9cb-feaf-45d7-add8-d55aca842a6d	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 15:13:42.063041+00	
00000000-0000-0000-0000-000000000000	2de131a7-6630-4dbe-9e5c-f60381752bd4	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 15:13:42.063708+00	
00000000-0000-0000-0000-000000000000	2392cd02-086e-4661-a57b-3043d83a8f76	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 15:14:44.343354+00	
00000000-0000-0000-0000-000000000000	423a0652-c922-4fc5-9302-938d7d2f1314	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 15:14:45.929821+00	
00000000-0000-0000-0000-000000000000	65c9a2ff-48e7-4584-82d3-b7223d1ac272	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 15:53:33.757+00	
00000000-0000-0000-0000-000000000000	2ec663e7-8891-4eae-ba1e-790661189371	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 15:53:33.757606+00	
00000000-0000-0000-0000-000000000000	5087d08f-c18b-47ee-904f-a7c836ab8896	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 15:53:42.081124+00	
00000000-0000-0000-0000-000000000000	95988d61-2ecb-415b-a02d-2b1c1add794b	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 16:06:50.811765+00	
00000000-0000-0000-0000-000000000000	33a11ed8-fe41-47c5-9b77-a6661425d583	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 16:06:50.812457+00	
00000000-0000-0000-0000-000000000000	7ae6c744-3e75-4ffc-8268-715cc6687883	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 16:06:56.755303+00	
00000000-0000-0000-0000-000000000000	8b94ead6-3cfc-47bc-baa7-a8ed94f41f7a	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 16:20:02.251449+00	
00000000-0000-0000-0000-000000000000	dc639eaa-553e-44e0-9959-512747f6e947	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 16:20:02.252077+00	
00000000-0000-0000-0000-000000000000	addb3477-1721-4265-89e9-419cd1df1b40	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 16:33:32.252207+00	
00000000-0000-0000-0000-000000000000	ba1380dc-33ec-408b-bcf8-478efe197144	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 16:33:32.252824+00	
00000000-0000-0000-0000-000000000000	544b1e20-f37e-4c45-8d31-9daaf80a1921	{"action":"user_recovery_requested","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"user"}	2023-12-19 19:11:19.212042+00	
00000000-0000-0000-0000-000000000000	6e2b6d17-a996-49cf-8936-5e8d20b9b23d	{"action":"login","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"account"}	2023-12-19 19:11:46.537804+00	
00000000-0000-0000-0000-000000000000	b63c14c1-b61a-47bd-b4cd-91517eb04e8a	{"action":"user_recovery_requested","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"user"}	2023-12-19 19:14:49.32361+00	
00000000-0000-0000-0000-000000000000	45799324-8f27-41af-bf72-cbbcb4cc8402	{"action":"login","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"account"}	2023-12-19 19:15:05.120811+00	
00000000-0000-0000-0000-000000000000	cf10a9d1-1768-4909-b140-dce08cb7b2af	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 19:28:12.512641+00	
00000000-0000-0000-0000-000000000000	31ffed99-62a2-47e1-878d-492300312966	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 19:28:12.513247+00	
00000000-0000-0000-0000-000000000000	0f58ba76-e1f1-4b69-a531-8d5e1bab9489	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 19:41:21.295207+00	
00000000-0000-0000-0000-000000000000	3ca9b001-6ca8-4972-90dc-a0deee1b8f15	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 19:41:21.296062+00	
00000000-0000-0000-0000-000000000000	effd5c04-15f8-4a1a-b94e-d33cf0ba714d	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 19:41:27.237806+00	
00000000-0000-0000-0000-000000000000	91d6efca-0eab-4c95-be74-21a998060647	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 19:54:52.666116+00	
00000000-0000-0000-0000-000000000000	668dc641-0f04-451f-bbd1-0d7777698c9b	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 19:54:52.666742+00	
00000000-0000-0000-0000-000000000000	2ec01609-0708-4094-ad99-5bed355efdf5	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 20:08:08.026042+00	
00000000-0000-0000-0000-000000000000	8e6d2da6-a076-4616-b44e-38b2cfcf5f85	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 20:08:08.027105+00	
00000000-0000-0000-0000-000000000000	fd4fa194-cf6a-460f-9e6b-9648b4ae8db8	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 20:08:46.926941+00	
00000000-0000-0000-0000-000000000000	e743041d-e34c-4133-b77c-4b86d53740d1	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 20:21:38.742226+00	
00000000-0000-0000-0000-000000000000	fb20d08a-90d0-4763-912b-9c8b2c8780c7	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 20:21:38.742875+00	
00000000-0000-0000-0000-000000000000	d0b066e8-3cd8-4517-a7a6-f24b314971a1	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 20:21:48.975674+00	
00000000-0000-0000-0000-000000000000	1137da2e-b6b2-4d4f-81d6-93734aec2680	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 20:21:59.752601+00	
00000000-0000-0000-0000-000000000000	4dd6e910-1c68-4e98-a076-c31469eb5919	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 20:34:49.479017+00	
00000000-0000-0000-0000-000000000000	6f3310ae-99ae-4f73-9870-3bf93db36974	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 20:34:49.479827+00	
00000000-0000-0000-0000-000000000000	7808fe63-c414-4db7-8f6d-9d85935b1ffd	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 20:34:59.784891+00	
00000000-0000-0000-0000-000000000000	d73b94d6-4273-4e0e-b56c-dca8871eb2dc	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 20:35:08.1115+00	
00000000-0000-0000-0000-000000000000	0ae79381-4910-4ee7-bd8a-31c52a7aac3d	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 20:48:00.166827+00	
00000000-0000-0000-0000-000000000000	7a4b0b56-8e41-4bad-8d16-ec94770c1d96	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 20:48:00.167516+00	
00000000-0000-0000-0000-000000000000	e8f7822d-7496-431e-9018-2bef339091d7	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 20:48:19.036529+00	
00000000-0000-0000-0000-000000000000	f77bc4da-f690-43fa-bd85-51fcc64ba02b	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 20:48:38.165082+00	
00000000-0000-0000-0000-000000000000	65e34a32-bb25-4896-855a-0fd596375087	{"action":"user_recovery_requested","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"user"}	2023-12-19 21:00:28.004305+00	
00000000-0000-0000-0000-000000000000	35b55e9c-d48c-4b93-8849-6c036469bb55	{"action":"login","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"account"}	2023-12-19 21:00:44.481686+00	
00000000-0000-0000-0000-000000000000	e3117b57-5532-4522-9e86-7acca09700e5	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 21:13:49.448549+00	
00000000-0000-0000-0000-000000000000	23bcd1b6-2344-48d6-be09-7edb6af2a739	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 21:13:49.449227+00	
00000000-0000-0000-0000-000000000000	2fd62198-2013-444d-8774-9130f47c83da	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 21:13:51.001011+00	
00000000-0000-0000-0000-000000000000	5e7032ad-4421-4651-b17e-d4e6ca89f9fc	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 21:27:01.92301+00	
00000000-0000-0000-0000-000000000000	f0572884-7eae-4eb8-808a-a25ff574b107	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 21:27:01.923653+00	
00000000-0000-0000-0000-000000000000	f26602ed-4ba0-4f21-8311-d115aec149f9	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 21:40:02.291231+00	
00000000-0000-0000-0000-000000000000	05a03f82-a4b9-45a3-9adf-9ff448cc39c9	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 21:40:02.291907+00	
00000000-0000-0000-0000-000000000000	e60a5a43-071a-4626-8493-a01d7d3df739	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 21:53:32.387585+00	
00000000-0000-0000-0000-000000000000	36af3156-24fd-4d15-a83e-8d3696a298c1	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 21:53:32.388245+00	
00000000-0000-0000-0000-000000000000	d46f8f61-ca0b-474d-b59d-5ce99f3b7e47	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 22:07:02.344738+00	
00000000-0000-0000-0000-000000000000	17580d90-5f96-44dc-b95b-3d1c2648602f	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-19 22:07:02.345361+00	
00000000-0000-0000-0000-000000000000	a23a585f-f058-4684-9658-f1be89103752	{"action":"user_recovery_requested","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"user"}	2023-12-20 11:50:27.150415+00	
00000000-0000-0000-0000-000000000000	d282b6bb-2b09-42b3-a54b-ed8619e312b8	{"action":"login","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"account"}	2023-12-20 11:50:40.522805+00	
00000000-0000-0000-0000-000000000000	6ab90e66-a985-41d9-bf59-7c1b79609401	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 12:03:45.570152+00	
00000000-0000-0000-0000-000000000000	7c102c0a-8ac1-4bf2-9304-a5dd51281a8f	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 12:03:45.572951+00	
00000000-0000-0000-0000-000000000000	3133747f-bf68-4961-b868-d49ca5368b1b	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 12:03:58.263307+00	
00000000-0000-0000-0000-000000000000	d21021a4-0e88-44a2-afd8-727e1b6ef89a	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 12:03:59.680616+00	
00000000-0000-0000-0000-000000000000	c59fbce4-2bf9-4b48-a8b2-cb5b676c3ab7	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 12:04:02.106181+00	
00000000-0000-0000-0000-000000000000	dbd86783-16fd-470e-b7f0-0bac10cf247e	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 12:04:07.335772+00	
00000000-0000-0000-0000-000000000000	e69bba2a-67a1-4368-87b3-c78f63c97cfd	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 12:16:59.577611+00	
00000000-0000-0000-0000-000000000000	640d5a3c-2c7a-44f5-9201-2cb1b5d60900	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 12:16:59.578277+00	
00000000-0000-0000-0000-000000000000	a219e55f-4820-4a2c-9f3a-399dcf3051d0	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 12:17:07.363771+00	
00000000-0000-0000-0000-000000000000	8ea4aac5-0a47-4866-b9d3-6eefb1164f09	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 12:17:15.160683+00	
00000000-0000-0000-0000-000000000000	8ff7f162-3327-4e44-9eda-5a6560bb32f3	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 12:17:27.818688+00	
00000000-0000-0000-0000-000000000000	25c47716-62b0-4e16-af93-4c689aaaa42e	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 12:17:31.670684+00	
00000000-0000-0000-0000-000000000000	b39e53d5-d8d2-462f-b504-d01d0ca422f0	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 12:29:59.291557+00	
00000000-0000-0000-0000-000000000000	2973d6c2-237e-437d-bcef-f222bbc31e95	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 12:29:59.292774+00	
00000000-0000-0000-0000-000000000000	a8db4c0d-8ecf-4abe-a118-0fb398ecc169	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 12:30:07.378117+00	
00000000-0000-0000-0000-000000000000	aed81619-adb6-4d93-8f14-3c010874d73f	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 12:30:15.178675+00	
00000000-0000-0000-0000-000000000000	9a6d9e09-9941-41c4-ba12-858305c6d3e6	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 12:30:27.844075+00	
00000000-0000-0000-0000-000000000000	8ac196e4-1203-4e94-98fd-ee4538982b50	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 12:30:31.711369+00	
00000000-0000-0000-0000-000000000000	0cf2db97-cc42-4446-8eae-49afe56a34d8	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 12:42:59.639734+00	
00000000-0000-0000-0000-000000000000	522ec8f2-090c-4936-bcb4-1226391c5b7f	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 12:42:59.640339+00	
00000000-0000-0000-0000-000000000000	82f908f9-2a88-4434-8edb-b4ebdab8cb31	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 12:43:07.74234+00	
00000000-0000-0000-0000-000000000000	cff3e9f0-2fb0-4d58-abd3-f875ff454412	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 12:43:15.553052+00	
00000000-0000-0000-0000-000000000000	221fe280-92bd-4036-9662-ff8e76fd72c1	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 12:43:27.881392+00	
00000000-0000-0000-0000-000000000000	5f894c75-f51c-4bd8-80cd-4f70f6c448a3	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 12:43:31.763395+00	
00000000-0000-0000-0000-000000000000	ad9dc077-b75a-43f9-ac64-b2698d16d979	{"action":"user_recovery_requested","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"user"}	2023-12-20 14:52:58.543628+00	
00000000-0000-0000-0000-000000000000	ecdd0a18-c8e1-4173-b338-b8d24930aa90	{"action":"login","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"account"}	2023-12-20 14:53:49.483692+00	
00000000-0000-0000-0000-000000000000	9af82a43-956a-472a-9729-7e348cacb996	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 15:06:55.125223+00	
00000000-0000-0000-0000-000000000000	cf5d5016-8fcf-4a27-bb44-fab75493fc91	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 15:06:55.125831+00	
00000000-0000-0000-0000-000000000000	5bb025c9-f540-40a6-ac34-ed739985e99b	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 15:06:56.488343+00	
00000000-0000-0000-0000-000000000000	33358dec-d91f-41e9-a744-d6cd08b3685b	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 15:19:57.433863+00	
00000000-0000-0000-0000-000000000000	f12e82ee-26fa-4595-862b-5aa2eda217b6	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 15:19:57.435268+00	
00000000-0000-0000-0000-000000000000	40d95562-6434-4b26-8fe1-1650272e17c4	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 15:20:24.685222+00	
00000000-0000-0000-0000-000000000000	b2f9af32-de55-4844-9bca-725a1176bac6	{"action":"user_recovery_requested","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"user"}	2023-12-20 15:29:37.369409+00	
00000000-0000-0000-0000-000000000000	2f4f3ed3-f0ca-473a-aa25-16a67915380e	{"action":"login","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"account"}	2023-12-20 15:31:21.144667+00	
00000000-0000-0000-0000-000000000000	f5938e3d-359c-4f2a-8935-f1c5600bf7f4	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 15:44:26.042076+00	
00000000-0000-0000-0000-000000000000	cd4d2abc-7db7-4075-8396-272cccdccb07	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 15:44:26.04319+00	
00000000-0000-0000-0000-000000000000	fe2aa905-3d54-4ccc-b146-b2d4104c7723	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 15:44:27.784293+00	
00000000-0000-0000-0000-000000000000	8b3a7c26-44a2-4398-8502-15234bc00cd1	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 15:45:18.83327+00	
00000000-0000-0000-0000-000000000000	a3b064c6-d83e-47c0-a517-8386ee385061	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 15:57:27.831008+00	
00000000-0000-0000-0000-000000000000	47f0f65b-8925-415b-b3fa-0d9d27bbeae9	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 15:57:27.831626+00	
00000000-0000-0000-0000-000000000000	7c2e6f81-362c-4ad8-9d65-e873bbcbf679	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 15:57:56.101956+00	
00000000-0000-0000-0000-000000000000	9ca68024-4900-4a15-8eae-f293b276e3a4	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 15:58:18.923188+00	
00000000-0000-0000-0000-000000000000	ec576541-cd2c-4eae-b661-3063c592d568	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 16:10:28.116089+00	
00000000-0000-0000-0000-000000000000	21eba97e-b16d-44b0-b4ba-a2ee173e7b48	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 16:10:28.117276+00	
00000000-0000-0000-0000-000000000000	31abdae3-d999-4ade-b5e4-58e22dbdc416	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 16:11:19.235121+00	
00000000-0000-0000-0000-000000000000	f60852dd-db65-4996-bd48-7ae72abaace5	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 16:11:26.110105+00	
00000000-0000-0000-0000-000000000000	cfb13ed9-49b6-4dd6-aa2c-9abf7e74e81a	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 16:11:49.287382+00	
00000000-0000-0000-0000-000000000000	34eec40c-36ee-403e-ad8d-950425fdd91b	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 16:11:56.808156+00	
00000000-0000-0000-0000-000000000000	6b92cab5-2617-46b8-8e85-09f581435c47	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 16:23:57.857446+00	
00000000-0000-0000-0000-000000000000	641b6e27-39e8-4537-8915-9ba26ec98a51	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 16:23:57.858048+00	
00000000-0000-0000-0000-000000000000	dff78949-5c82-4e11-a362-6978afc43341	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 16:24:56.154269+00	
00000000-0000-0000-0000-000000000000	bb1ad6f5-44a1-4877-9384-3098b7c9932f	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 16:25:19.548978+00	
00000000-0000-0000-0000-000000000000	242bd034-21a1-494e-8242-9ce32ba92a7e	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 16:36:57.906799+00	
00000000-0000-0000-0000-000000000000	f3b3f3e4-6868-433b-9524-1be16735511b	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 16:36:57.907437+00	
00000000-0000-0000-0000-000000000000	1f6ca5fb-5c3c-41e4-af11-314865b72a8c	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 16:37:56.203395+00	
00000000-0000-0000-0000-000000000000	663d2892-b41b-44fb-ac08-b8b92da0fee8	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 16:38:48.922421+00	
00000000-0000-0000-0000-000000000000	89a045d3-6199-4199-9ce0-562be3ef93d4	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 16:49:57.943962+00	
00000000-0000-0000-0000-000000000000	eac083d0-7ad8-4b28-81ad-9227f3d8abdb	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 16:49:57.94532+00	
00000000-0000-0000-0000-000000000000	bb5ba8f9-d35a-4880-b77b-30168d56cedb	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 16:50:56.22147+00	
00000000-0000-0000-0000-000000000000	93363c48-380e-4b21-b856-929c5bc5288b	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 16:51:48.879968+00	
00000000-0000-0000-0000-000000000000	02d7db0f-9a92-4577-bd67-2051ad6df34a	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 17:02:57.957897+00	
00000000-0000-0000-0000-000000000000	9e8c76c2-2323-46bd-acdc-967707a7de50	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 17:02:57.958876+00	
00000000-0000-0000-0000-000000000000	fdcba822-8cb8-47dc-9dcd-59f6bd1d05bd	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 17:03:56.26838+00	
00000000-0000-0000-0000-000000000000	fcfb96d8-1beb-4692-a75f-89e3af4dd542	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 17:04:49.291969+00	
00000000-0000-0000-0000-000000000000	ed1ec8ac-8dba-4fc1-aa09-cce96b29854f	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 17:15:58.329284+00	
00000000-0000-0000-0000-000000000000	87f6256b-544e-487d-9b73-356671bbc9bb	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 17:15:58.329903+00	
00000000-0000-0000-0000-000000000000	b019e6a7-2891-481b-807a-fa39d9d789fd	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 17:16:56.274503+00	
00000000-0000-0000-0000-000000000000	c0d72846-661e-43f1-aa70-c90e08a612b5	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 17:18:19.536485+00	
00000000-0000-0000-0000-000000000000	9774d157-8950-4ce7-a0ca-db38e988da0e	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 17:29:28.040169+00	
00000000-0000-0000-0000-000000000000	ecedf3e2-ee1a-4d22-8711-e067b9a2d347	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 17:29:28.041841+00	
00000000-0000-0000-0000-000000000000	59bb4456-4ba1-4b23-a71a-531d15965e00	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 17:29:56.324693+00	
00000000-0000-0000-0000-000000000000	7fb8cfc2-1a3d-4bc6-9397-366acfea05b4	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 17:31:49.358137+00	
00000000-0000-0000-0000-000000000000	39d78c34-6cce-469b-a205-27148d79edb4	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 17:42:56.358214+00	
00000000-0000-0000-0000-000000000000	c16f549b-4134-46e7-bbd0-010a6b3d5a4b	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 17:42:56.358829+00	
00000000-0000-0000-0000-000000000000	897b4c86-b33f-433d-b87c-c4a624cea507	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 17:42:58.369928+00	
00000000-0000-0000-0000-000000000000	27fae262-bd95-4397-9458-f6cd5027af5d	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 17:45:19.739475+00	
00000000-0000-0000-0000-000000000000	24c2ee8d-5daf-462c-9665-f52651692181	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 17:55:56.36809+00	
00000000-0000-0000-0000-000000000000	87a9a61f-dd63-41b8-b6e0-f357f744c3a4	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 17:55:56.368782+00	
00000000-0000-0000-0000-000000000000	439020a2-bfd4-4e79-856b-5d071f5975e7	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 17:56:28.090067+00	
00000000-0000-0000-0000-000000000000	f47b1ce8-3d82-45e6-a3e6-364d5f37697f	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 18:08:56.392024+00	
00000000-0000-0000-0000-000000000000	ced4da7a-9e6a-44b0-a071-9173c8b0fcd8	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 18:08:56.392689+00	
00000000-0000-0000-0000-000000000000	240c4e89-7617-46b2-8368-12cbd98c9f64	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 18:09:58.133261+00	
00000000-0000-0000-0000-000000000000	9f7158da-a899-429b-92ea-2627820bd17c	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 18:21:56.756062+00	
00000000-0000-0000-0000-000000000000	ac660d91-b111-423a-ad97-f25436fca925	{"action":"token_revoked","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 18:21:56.756721+00	
00000000-0000-0000-0000-000000000000	456cd482-c77c-4a90-a10b-95679ec6bbb6	{"action":"token_refreshed","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"token"}	2023-12-20 18:22:58.162374+00	
00000000-0000-0000-0000-000000000000	10876831-cd1b-44e9-8cc0-ea92d94dd86a	{"action":"user_recovery_requested","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"user"}	2023-12-20 18:26:02.176403+00	
\.


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
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.instances (id, uuid, raw_base_config, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_amr_claims (session_id, created_at, updated_at, authentication_method, id) FROM stdin;
6833ddc7-223d-4093-ad07-559f00b07419	2023-12-02 19:58:46.130137+00	2023-12-02 19:58:46.130137+00	otp	88a74b71-7813-45c4-8138-e24b0858407b
810df881-05f6-4234-a115-23a34045ebfb	2023-12-08 23:55:03.718962+00	2023-12-08 23:55:03.718962+00	otp	0cbf26e3-442c-4fc5-8cd2-c293f452cc61
5bba6304-8a77-4f59-9c0c-c00a6fd7ce91	2023-12-09 02:11:26.262948+00	2023-12-09 02:11:26.262948+00	otp	fdc0630b-421a-4ab7-b563-6ec8c8a04e2a
304ff5a0-aa7f-4be0-948a-574dfe3aab41	2023-12-11 20:47:32.718471+00	2023-12-11 20:47:32.718471+00	otp	d1335368-a139-47b7-abdd-19bb95869c1d
400376ed-2a52-4c6c-bd41-3e0535fd86d5	2023-12-11 20:49:56.232681+00	2023-12-11 20:49:56.232681+00	otp	22a0900d-a4ca-4ff2-884e-ebd2ba1e7075
b293f801-2282-4755-9e10-e5e8e1f8a21c	2023-12-11 23:41:06.793147+00	2023-12-11 23:41:06.793147+00	otp	7e53e9e4-c96a-42fc-9027-b30ef8e69133
2746d270-873f-483b-8db4-1463e50c336d	2023-12-13 15:28:48.851339+00	2023-12-13 15:28:48.851339+00	otp	ad2ec98c-e36c-4d3e-9b6e-8b505f388f97
90056874-e87c-4138-b381-d2b3ae119816	2023-12-14 12:19:33.323066+00	2023-12-14 12:19:33.323066+00	otp	248478e4-0b16-477c-b4e6-9b7a850b25b1
ed5401e1-9fd8-4304-b6ed-21129e618e6b	2023-12-15 15:12:41.32697+00	2023-12-15 15:12:41.32697+00	otp	2f9bbdfd-76cf-48d4-bea1-e67ac03e8e22
73a4d827-c6ea-4ba4-b341-601f97c11793	2023-12-15 16:34:01.761235+00	2023-12-15 16:34:01.761235+00	otp	4f4731ee-c6a8-40c5-b94e-1059db17b0c7
98e8b0f3-7942-4c17-9d87-7bebc75a3631	2023-12-15 16:35:22.018531+00	2023-12-15 16:35:22.018531+00	otp	f1fbe43b-bad0-4df7-92bd-dc6b2ea2a3cb
b6672a79-7255-44ba-92a3-40b84de08b3e	2023-12-15 20:33:09.603102+00	2023-12-15 20:33:09.603102+00	otp	a5d38c7a-a82c-475b-b167-62b394228546
73ca2c05-c30d-41a9-a3ca-0e0398e66175	2023-12-16 15:35:40.314824+00	2023-12-16 15:35:40.314824+00	otp	2edda6de-e9c5-47fb-93a9-af73dc62868a
eede4336-98b5-404f-927f-61c48d49dfbd	2023-12-18 16:45:54.119045+00	2023-12-18 16:45:54.119045+00	otp	04d9e2c3-1aa3-453c-a519-fef59d514d81
ba214b77-9e60-40e6-b4bb-aec101dd2e45	2023-12-19 04:51:10.852011+00	2023-12-19 04:51:10.852011+00	otp	51eab82d-c6ac-448d-98b6-9b31f4ec7e6e
e0b3d407-a2d3-44ef-aff8-ec38c7753e46	2023-12-19 14:46:23.08573+00	2023-12-19 14:46:23.08573+00	otp	56745639-40c6-479f-9f28-42c86034879f
6f26c1b0-f37c-4696-8cfb-be1cec797329	2023-12-19 14:47:33.184863+00	2023-12-19 14:47:33.184863+00	otp	7d235b8d-1b2e-4daa-b70e-b6cb15343bfd
9f1be8d2-db9a-4244-8d98-62ef0cdbb589	2023-12-19 19:11:46.540206+00	2023-12-19 19:11:46.540206+00	otp	21b8df08-3c2c-45fb-8126-b4fbf1419a4f
29752073-3cf1-4713-9698-013bd2d6982e	2023-12-19 19:15:05.123213+00	2023-12-19 19:15:05.123213+00	otp	80d9233c-70e9-45f5-9296-698c6b8b8647
deaf3216-fb7c-41cc-b908-7b7c826f2929	2023-12-19 21:00:44.484608+00	2023-12-19 21:00:44.484608+00	otp	29fad1ec-a97f-4140-9055-e4788b6099c6
946e79ab-b3dc-421b-b4da-c85aabb772f0	2023-12-20 11:50:40.532378+00	2023-12-20 11:50:40.532378+00	otp	7341a075-0750-401b-b757-5a5882bd72c3
ec442ecd-1e46-4dd3-8ceb-e8b6e12930a5	2023-12-20 14:53:49.488079+00	2023-12-20 14:53:49.488079+00	otp	34580c3d-b87c-4b5a-a1c6-40da7cea2d90
5956bfc6-bb95-49e8-97f9-08bd727dd997	2023-12-20 15:31:21.148947+00	2023-12-20 15:31:21.148947+00	otp	4213a7e1-a426-44e2-8a89-0a8316072709
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
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) FROM stdin;
00000000-0000-0000-0000-000000000000	140	jAxMefuhs3S03_0hU6karg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-05 20:12:17.816427+00	2023-12-05 20:25:17.925581+00	J7-Xf2y0cUl23IUVv0-RMw	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	141	dfJR5eH0r4LT5w_j67YtBw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-05 20:25:17.926008+00	2023-12-05 20:38:18.028712+00	jAxMefuhs3S03_0hU6karg	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	142	NTxp3J5091hHLS-eOf-YSg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-05 20:38:18.029003+00	2023-12-05 20:51:48.008946+00	dfJR5eH0r4LT5w_j67YtBw	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	143	R71BJ8jPEC3Y4sCQF6qHqw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-05 20:51:48.009276+00	2023-12-05 21:05:17.959445+00	NTxp3J5091hHLS-eOf-YSg	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	99	w00q0DndyeWwrGmUMstHeg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-02 19:58:46.129068+00	2023-12-03 14:56:06.529576+00	\N	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	100	63l-EUnpzYfwvihi8uFWgw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-03 14:56:06.529947+00	2023-12-03 15:09:15.099848+00	w00q0DndyeWwrGmUMstHeg	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	101	D0IxhsyRfW9yCn-OzvR3Aw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-03 15:09:15.100296+00	2023-12-03 15:22:24.128724+00	63l-EUnpzYfwvihi8uFWgw	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	102	iq5-4OwPF1wcUxDWKkkp7A	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-03 15:22:24.130248+00	2023-12-03 15:35:35.378785+00	D0IxhsyRfW9yCn-OzvR3Aw	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	103	_AFTcIsXQQZFNEoN5oAVvQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-03 15:35:35.3792+00	2023-12-03 15:48:54.185523+00	iq5-4OwPF1wcUxDWKkkp7A	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	104	UJz3U2czlHCdT1cTt6BFnA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-03 15:48:54.185851+00	2023-12-03 16:02:24.171052+00	_AFTcIsXQQZFNEoN5oAVvQ	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	105	X0Ep7VsTiajsXAeDmAWj6A	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-03 16:02:24.17137+00	2023-12-03 16:15:53.972235+00	UJz3U2czlHCdT1cTt6BFnA	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	106	hZbIzlfPcj-z3NmHu1YHcQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-03 16:15:53.972547+00	2023-12-03 16:29:05.046645+00	X0Ep7VsTiajsXAeDmAWj6A	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	107	h7zwZcPIWnD_8aYv18766Q	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-03 16:29:05.046949+00	2023-12-03 16:42:23.617806+00	hZbIzlfPcj-z3NmHu1YHcQ	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	108	KwlIseDcHO0_P-m5NcyjkQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-03 16:42:23.61812+00	2023-12-03 16:55:23.648132+00	h7zwZcPIWnD_8aYv18766Q	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	109	lqLqo5VU6yaCXWrFIKJLSg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-03 16:55:23.648415+00	2023-12-03 17:08:23.692422+00	KwlIseDcHO0_P-m5NcyjkQ	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	110	6YG7uOk6JKIYU8WSRByDeA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-03 17:08:23.692749+00	2023-12-03 17:21:24.378252+00	lqLqo5VU6yaCXWrFIKJLSg	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	111	SitOwQhUp_TGqjPhKcyXtw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-03 17:21:24.378579+00	2023-12-03 17:34:35.530603+00	6YG7uOk6JKIYU8WSRByDeA	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	112	Vv5RFaki1xC-RVdv2Yt-lA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-03 17:34:35.530922+00	2023-12-03 17:47:54.285586+00	SitOwQhUp_TGqjPhKcyXtw	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	113	7rfBITKUgxwkJO0pSp67rA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-03 17:47:54.285907+00	2023-12-03 18:01:05.627114+00	Vv5RFaki1xC-RVdv2Yt-lA	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	114	hDS6ihjE4bAorognOW2MGg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-03 18:01:05.627439+00	2023-12-03 18:14:35.902447+00	7rfBITKUgxwkJO0pSp67rA	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	115	gUsdsKdvaIUcG0p_2HPm3g	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-03 18:14:35.902758+00	2023-12-03 18:28:05.665567+00	hDS6ihjE4bAorognOW2MGg	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	116	WEtZvQ92VHRQDl-ZlcyJFg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-03 18:28:05.665863+00	2023-12-03 18:41:35.660721+00	gUsdsKdvaIUcG0p_2HPm3g	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	117	fBvfEjqj7POSjtt0SrXPYQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-03 18:41:35.661102+00	2023-12-03 20:29:36.963611+00	WEtZvQ92VHRQDl-ZlcyJFg	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	118	Vb3lFaQxEjueEq8R6EhFFg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-03 20:29:36.96392+00	2023-12-05 15:15:13.460909+00	fBvfEjqj7POSjtt0SrXPYQ	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	119	vCaqr_yx56rtOHEjgUY3Yw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-05 15:15:13.461213+00	2023-12-05 15:35:16.986968+00	Vb3lFaQxEjueEq8R6EhFFg	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	120	XCthgmbteery-_-Jj5JVyg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-05 15:35:16.987399+00	2023-12-05 15:48:24.946433+00	vCaqr_yx56rtOHEjgUY3Yw	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	121	GYHdKT3pLwEShcaOC8dBzQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-05 15:48:24.946747+00	2023-12-05 16:01:51.248049+00	XCthgmbteery-_-Jj5JVyg	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	122	rHaHsgj0pv9s9EIWXUmdMA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-05 16:01:51.248346+00	2023-12-05 16:23:02.126653+00	GYHdKT3pLwEShcaOC8dBzQ	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	123	frpAVpEiTlAqhqGtMYzAFg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-05 16:23:02.127007+00	2023-12-05 16:36:17.284113+00	rHaHsgj0pv9s9EIWXUmdMA	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	124	Oc0kXoA3anXr9JsSIIqgUg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-05 16:36:17.284417+00	2023-12-05 16:49:47.326024+00	frpAVpEiTlAqhqGtMYzAFg	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	125	BZuORHBOcpt3m-kArwqY9g	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-05 16:49:47.326408+00	2023-12-05 17:03:17.542266+00	Oc0kXoA3anXr9JsSIIqgUg	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	126	Kl3AMgmeMlFO02sCH9KWUg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-05 17:03:17.542578+00	2023-12-05 17:16:47.384789+00	BZuORHBOcpt3m-kArwqY9g	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	127	It18P7lxlHlSNK3AYv4hBg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-05 17:16:47.385137+00	2023-12-05 17:30:17.577276+00	Kl3AMgmeMlFO02sCH9KWUg	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	128	JsQKOUJdwuuakgU0yTzfng	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-05 17:30:17.577614+00	2023-12-05 17:43:47.636935+00	It18P7lxlHlSNK3AYv4hBg	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	129	8YfADuZ3Gl45w8Y-SAgoTQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-05 17:43:47.637231+00	2023-12-05 17:57:17.476832+00	JsQKOUJdwuuakgU0yTzfng	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	130	mzfNAlbsT9vj92K5DKFf3g	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-05 17:57:17.477178+00	2023-12-05 18:10:47.613683+00	8YfADuZ3Gl45w8Y-SAgoTQ	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	131	WSxzOvpFhfhWN-yT629zig	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-05 18:10:47.61403+00	2023-12-05 18:24:17.702536+00	mzfNAlbsT9vj92K5DKFf3g	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	132	ZwneuKr1lajooGe6Z39Dag	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-05 18:24:17.702891+00	2023-12-05 18:37:47.814234+00	WSxzOvpFhfhWN-yT629zig	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	133	0I5foBLzbgTuXnb-NK7LXQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-05 18:37:47.814522+00	2023-12-05 18:51:17.610275+00	ZwneuKr1lajooGe6Z39Dag	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	134	rGlMgnk0Vd9X1DQs89bdig	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-05 18:51:17.610623+00	2023-12-05 19:04:47.611762+00	0I5foBLzbgTuXnb-NK7LXQ	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	135	fzLimHHyVZc7tOvjEBI2TQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-05 19:04:47.612039+00	2023-12-05 19:18:17.684752+00	rGlMgnk0Vd9X1DQs89bdig	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	136	idoTEWRr82TWnxrq8DFTww	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-05 19:18:17.685054+00	2023-12-05 19:31:47.741837+00	fzLimHHyVZc7tOvjEBI2TQ	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	137	8BdQ-5y5EpJd9JEv9c-saw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-05 19:31:47.742153+00	2023-12-05 19:45:17.959181+00	idoTEWRr82TWnxrq8DFTww	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	138	FM-9LtO47Hv6GQOJsPvqOw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-05 19:45:17.959468+00	2023-12-05 19:58:48.000538+00	8BdQ-5y5EpJd9JEv9c-saw	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	139	J7-Xf2y0cUl23IUVv0-RMw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-05 19:58:48.000833+00	2023-12-05 20:12:17.81612+00	FM-9LtO47Hv6GQOJsPvqOw	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	214	O3YLcJg0cYvARN8lFlGX9g	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-13 15:09:52.267197+00	2023-12-13 15:15:09.094681+00	QZwWpqI2QZGQm6iWLHdTGQ	b293f801-2282-4755-9e10-e5e8e1f8a21c
00000000-0000-0000-0000-000000000000	144	U5KaUmbE2lRrclcs_sTjVA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-05 21:05:17.959748+00	2023-12-05 21:18:18.029414+00	R71BJ8jPEC3Y4sCQF6qHqw	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	145	i0pPD7Tj3zyXLoD-UN5ZBQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-05 21:18:18.029808+00	2023-12-05 21:31:48.361235+00	U5KaUmbE2lRrclcs_sTjVA	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	146	6PNcV4z9vGOc-ocBbX6SOQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-05 21:31:48.361521+00	2023-12-05 21:45:18.102661+00	i0pPD7Tj3zyXLoD-UN5ZBQ	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	147	vRAqYzoM6lz7Xu41HvqhhA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-05 21:45:18.102992+00	2023-12-06 07:59:00.264084+00	6PNcV4z9vGOc-ocBbX6SOQ	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	148	NB3qfeV67j2vhM_Ud8o4Rg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-06 07:59:00.264603+00	2023-12-06 08:12:30.280021+00	vRAqYzoM6lz7Xu41HvqhhA	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	149	vJrx4gg3hEuwcMRIBKUzQQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-06 08:12:30.28032+00	2023-12-06 08:26:00.355863+00	NB3qfeV67j2vhM_Ud8o4Rg	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	150	3nKHiPneIicgZoEXgNpFMQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-06 08:26:00.356208+00	2023-12-06 08:39:30.351333+00	vJrx4gg3hEuwcMRIBKUzQQ	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	151	TsnlMsQv-9mpMMxZF_bS1g	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-06 08:39:30.351636+00	2023-12-06 08:53:00.394163+00	3nKHiPneIicgZoEXgNpFMQ	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	152	X7DIfisGwV5cehfafGp1wA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-06 08:53:00.39453+00	2023-12-06 09:06:30.513322+00	TsnlMsQv-9mpMMxZF_bS1g	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	153	zT3OR8qvZ6Bmonwotmid3w	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-06 09:06:30.513619+00	2023-12-06 09:20:00.386667+00	X7DIfisGwV5cehfafGp1wA	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	154	TNQRwyDr8qokWBIu7wB2Kg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-06 09:20:00.387017+00	2023-12-06 09:33:30.399056+00	zT3OR8qvZ6Bmonwotmid3w	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	155	QPLibfIHFMVNgiXKZ9sB3A	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-06 09:33:30.399431+00	2023-12-06 09:47:00.473308+00	TNQRwyDr8qokWBIu7wB2Kg	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	156	XKsILzDSIg9Lp5b79pSqjA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-06 09:47:00.473648+00	2023-12-06 10:00:30.502422+00	QPLibfIHFMVNgiXKZ9sB3A	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	157	VqWpX7ikLeZ1ipOENJfi4w	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-06 10:00:30.502743+00	2023-12-06 10:14:00.576722+00	XKsILzDSIg9Lp5b79pSqjA	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	158	ZJB_-BldyCU_-zpR4Ue0Ow	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-06 10:14:00.57709+00	2023-12-06 10:27:30.539276+00	VqWpX7ikLeZ1ipOENJfi4w	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	159	WM90Kam7qP-JfPMQ6wkB6g	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-06 10:27:30.539613+00	2023-12-06 10:41:00.621193+00	ZJB_-BldyCU_-zpR4Ue0Ow	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	160	Uikc0ZJg8bxG_qvRlCIjTQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-06 10:41:00.621476+00	2023-12-06 10:54:30.692061+00	WM90Kam7qP-JfPMQ6wkB6g	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	161	Cgqqx4cFbmHmNYbtl3z2Aw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-06 10:54:30.692422+00	2023-12-06 11:08:00.661086+00	Uikc0ZJg8bxG_qvRlCIjTQ	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	162	tWbfGPZ7tqd3cLJ2C4HwPw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-06 11:08:00.661415+00	2023-12-06 11:21:30.608032+00	Cgqqx4cFbmHmNYbtl3z2Aw	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	163	4YW1RTdkFftu8F_7_h6VGQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-06 11:21:30.608432+00	2023-12-06 11:35:00.945687+00	tWbfGPZ7tqd3cLJ2C4HwPw	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	164	LICOQfeilCqmx3QlRgu7-A	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-06 11:35:00.946034+00	2023-12-06 11:48:30.72123+00	4YW1RTdkFftu8F_7_h6VGQ	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	165	_PLl9heIH9HyQdvqIVxLdg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-06 11:48:30.721534+00	2023-12-06 12:02:00.815435+00	LICOQfeilCqmx3QlRgu7-A	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	166	l6io_Ch_eL-51HDNB5y84A	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-06 12:02:00.815813+00	2023-12-06 12:15:31.005145+00	_PLl9heIH9HyQdvqIVxLdg	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	167	3T49l2rTAhVlPWZsKiKYbQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-06 12:15:31.005473+00	2023-12-06 12:29:00.983794+00	l6io_Ch_eL-51HDNB5y84A	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	168	nG5nn_HemiqeWDz2ZJOq2A	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-06 12:29:00.984157+00	2023-12-06 12:42:31.036443+00	3T49l2rTAhVlPWZsKiKYbQ	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	169	cnZHCrsOqbip_BSkYXe8lA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-06 12:42:31.03677+00	2023-12-06 12:56:01.122203+00	nG5nn_HemiqeWDz2ZJOq2A	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	170	sFdpjPHsM5qLkrT8ySgNNw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-06 12:56:01.122529+00	2023-12-06 13:09:30.966589+00	cnZHCrsOqbip_BSkYXe8lA	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	171	X6Nr9sVqrS6AnbBPlDU4Cw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-06 13:09:30.966982+00	2023-12-06 13:22:31.082886+00	sFdpjPHsM5qLkrT8ySgNNw	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	172	eUOPEz9PyEmtTyl_ymMyeA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-06 13:22:31.083279+00	2023-12-06 13:36:00.971384+00	X6Nr9sVqrS6AnbBPlDU4Cw	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	173	sd571IrbrsKdLXDrmHnr7g	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-06 13:36:00.971742+00	2023-12-06 13:49:01.20512+00	eUOPEz9PyEmtTyl_ymMyeA	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	174	QdbIRZN-fv1EECcFNKpEBQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-06 13:49:01.205543+00	2023-12-06 14:02:31.049605+00	sd571IrbrsKdLXDrmHnr7g	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	175	cpyVsMAh8t1c4SZQWsRIvQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-06 14:02:31.049935+00	2023-12-06 14:16:01.28454+00	QdbIRZN-fv1EECcFNKpEBQ	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	176	lX4ZRdaoKYlfStIucDq-4w	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-06 14:16:01.284979+00	2023-12-07 21:01:19.72161+00	cpyVsMAh8t1c4SZQWsRIvQ	6833ddc7-223d-4093-ad07-559f00b07419
00000000-0000-0000-0000-000000000000	177	S6E9CjrF2bjJxIUfG9DTJA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-08 23:55:03.715355+00	2023-12-09 00:08:10.9981+00	\N	810df881-05f6-4234-a115-23a34045ebfb
00000000-0000-0000-0000-000000000000	178	sq7kjAQuhlgwnU5tQ3VdgQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-09 00:08:11.000274+00	2023-12-09 00:21:41.073601+00	S6E9CjrF2bjJxIUfG9DTJA	810df881-05f6-4234-a115-23a34045ebfb
00000000-0000-0000-0000-000000000000	179	RHrU7052u_GAGRxsfw40NQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-09 00:21:41.075286+00	2023-12-09 00:22:29.030265+00	sq7kjAQuhlgwnU5tQ3VdgQ	810df881-05f6-4234-a115-23a34045ebfb
00000000-0000-0000-0000-000000000000	181	psgCYW6tHJYZlyCtBopQGQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-09 02:11:26.257194+00	2023-12-10 10:29:58.602193+00	\N	5bba6304-8a77-4f59-9c0c-c00a6fd7ce91
00000000-0000-0000-0000-000000000000	182	SMqrCEdAsLZlknmXpWdeFA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-10 10:29:58.603222+00	2023-12-11 17:17:49.691373+00	psgCYW6tHJYZlyCtBopQGQ	5bba6304-8a77-4f59-9c0c-c00a6fd7ce91
00000000-0000-0000-0000-000000000000	183	OOVD5VEbohLR_sZVHavQFw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-11 17:17:49.69284+00	2023-12-11 17:52:37.081162+00	SMqrCEdAsLZlknmXpWdeFA	5bba6304-8a77-4f59-9c0c-c00a6fd7ce91
00000000-0000-0000-0000-000000000000	184	TI6CSymcnEnBamMb3dXnAQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-11 17:52:37.083969+00	2023-12-11 19:53:02.315748+00	OOVD5VEbohLR_sZVHavQFw	5bba6304-8a77-4f59-9c0c-c00a6fd7ce91
00000000-0000-0000-0000-000000000000	185	HI8aLWXb-PUSeZLRYNy2_g	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-11 19:53:02.317111+00	2023-12-11 20:06:32.136946+00	TI6CSymcnEnBamMb3dXnAQ	5bba6304-8a77-4f59-9c0c-c00a6fd7ce91
00000000-0000-0000-0000-000000000000	186	GZ3-SxEL9UuDy-_j1UWlxw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-11 20:06:32.137894+00	2023-12-11 20:20:02.123839+00	HI8aLWXb-PUSeZLRYNy2_g	5bba6304-8a77-4f59-9c0c-c00a6fd7ce91
00000000-0000-0000-0000-000000000000	187	dKvFdYpC57g7q5OH-ejs1g	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-11 20:20:02.125295+00	2023-12-11 20:33:32.177323+00	GZ3-SxEL9UuDy-_j1UWlxw	5bba6304-8a77-4f59-9c0c-c00a6fd7ce91
00000000-0000-0000-0000-000000000000	188	N2AD3C-sj0UmLGQTI9U8Dg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-11 20:33:32.179763+00	2023-12-11 20:46:50.839949+00	dKvFdYpC57g7q5OH-ejs1g	5bba6304-8a77-4f59-9c0c-c00a6fd7ce91
00000000-0000-0000-0000-000000000000	189	BzXNlAgDsau2yVFRMgXHcQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	f	2023-12-11 20:47:32.717407+00	2023-12-11 20:47:32.717407+00	\N	304ff5a0-aa7f-4be0-948a-574dfe3aab41
00000000-0000-0000-0000-000000000000	190	qAHeATTUUeTMGBFVP62v6A	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-11 20:49:56.23118+00	2023-12-11 21:30:09.89296+00	\N	400376ed-2a52-4c6c-bd41-3e0535fd86d5
00000000-0000-0000-0000-000000000000	213	QZwWpqI2QZGQm6iWLHdTGQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-13 14:56:22.039777+00	2023-12-13 15:09:52.265324+00	jTSsFjffw7yiOJ6_6sushA	b293f801-2282-4755-9e10-e5e8e1f8a21c
00000000-0000-0000-0000-000000000000	191	aYXdp34cB4pZxbwpJqj8Vg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-11 21:30:09.893429+00	2023-12-11 21:43:10.23607+00	qAHeATTUUeTMGBFVP62v6A	400376ed-2a52-4c6c-bd41-3e0535fd86d5
00000000-0000-0000-0000-000000000000	300	Oj3X0muHke-L8Nb_VlHRRw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-17 14:53:33.067937+00	2023-12-17 15:07:03.038406+00	CefIy5DAXGCLVFb6lZnieA	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	192	Yw7-QX120349s5P5IJaHyg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-11 21:43:10.236943+00	2023-12-11 21:56:40.013611+00	aYXdp34cB4pZxbwpJqj8Vg	400376ed-2a52-4c6c-bd41-3e0535fd86d5
00000000-0000-0000-0000-000000000000	215	UTLIE7AjpaYMvvRA1rHadQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-13 15:28:48.848315+00	2023-12-13 16:08:54.08915+00	\N	2746d270-873f-483b-8db4-1463e50c336d
00000000-0000-0000-0000-000000000000	193	JhfPINOrm4w7CqfO99CPsg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-11 21:56:40.013977+00	2023-12-11 22:10:10.007866+00	Yw7-QX120349s5P5IJaHyg	400376ed-2a52-4c6c-bd41-3e0535fd86d5
00000000-0000-0000-0000-000000000000	194	gf3dbPngOQCJ9zml11e2DQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-11 22:10:10.00933+00	2023-12-11 22:13:04.458784+00	JhfPINOrm4w7CqfO99CPsg	400376ed-2a52-4c6c-bd41-3e0535fd86d5
00000000-0000-0000-0000-000000000000	216	y7sOI9UG7Rdsy_seb1mO8w	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-13 16:08:54.091775+00	2023-12-13 16:21:57.198006+00	UTLIE7AjpaYMvvRA1rHadQ	2746d270-873f-483b-8db4-1463e50c336d
00000000-0000-0000-0000-000000000000	195	f_NT28MB0bqqmH35N1iNcA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-11 23:41:06.790687+00	2023-12-12 00:16:24.711955+00	\N	b293f801-2282-4755-9e10-e5e8e1f8a21c
00000000-0000-0000-0000-000000000000	196	ScciNdJnIHT7icpEN4t7qQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-12 00:16:24.712788+00	2023-12-12 17:53:01.749201+00	f_NT28MB0bqqmH35N1iNcA	b293f801-2282-4755-9e10-e5e8e1f8a21c
00000000-0000-0000-0000-000000000000	217	awbmACNWi6lPNkbcGJlO4A	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-13 16:21:57.198402+00	2023-12-13 16:34:58.412384+00	y7sOI9UG7Rdsy_seb1mO8w	2746d270-873f-483b-8db4-1463e50c336d
00000000-0000-0000-0000-000000000000	197	rKE-vo-nYkaQjvOYDKfKwA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-12 17:53:01.752099+00	2023-12-12 23:01:15.953236+00	ScciNdJnIHT7icpEN4t7qQ	b293f801-2282-4755-9e10-e5e8e1f8a21c
00000000-0000-0000-0000-000000000000	198	Ubv_DKMas504icUjNC6nvw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-12 23:01:15.954077+00	2023-12-12 23:15:24.813841+00	rKE-vo-nYkaQjvOYDKfKwA	b293f801-2282-4755-9e10-e5e8e1f8a21c
00000000-0000-0000-0000-000000000000	218	TIa5TDGxF-hZTFBeM367Gg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-13 16:34:58.414063+00	2023-12-13 16:48:12.205104+00	awbmACNWi6lPNkbcGJlO4A	2746d270-873f-483b-8db4-1463e50c336d
00000000-0000-0000-0000-000000000000	199	YB4WFxQkG1Okst2eD3wR5w	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-12 23:15:24.814918+00	2023-12-12 23:38:14.343402+00	Ubv_DKMas504icUjNC6nvw	b293f801-2282-4755-9e10-e5e8e1f8a21c
00000000-0000-0000-0000-000000000000	200	B3UwXDeYA_HJgzZelYhEjg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-12 23:38:14.345723+00	2023-12-12 23:51:29.933677+00	YB4WFxQkG1Okst2eD3wR5w	b293f801-2282-4755-9e10-e5e8e1f8a21c
00000000-0000-0000-0000-000000000000	219	u-_ooF2z0XkTDny3Pv8HvA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-13 16:48:12.207379+00	2023-12-13 16:49:25.063836+00	TIa5TDGxF-hZTFBeM367Gg	2746d270-873f-483b-8db4-1463e50c336d
00000000-0000-0000-0000-000000000000	201	GBwhDhQOGN3PoGkMo_Qavw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-12 23:51:29.9353+00	2023-12-13 00:04:31.357926+00	B3UwXDeYA_HJgzZelYhEjg	b293f801-2282-4755-9e10-e5e8e1f8a21c
00000000-0000-0000-0000-000000000000	202	7xaPhWgPchrrqBrW5WsWXQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-13 00:04:31.360714+00	2023-12-13 00:17:54.62116+00	GBwhDhQOGN3PoGkMo_Qavw	b293f801-2282-4755-9e10-e5e8e1f8a21c
00000000-0000-0000-0000-000000000000	220	Ssq1ZSm0opSB5sNFI-gCpA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-14 12:19:33.318356+00	2023-12-14 12:32:39.650766+00	\N	90056874-e87c-4138-b381-d2b3ae119816
00000000-0000-0000-0000-000000000000	203	7_l5ww2XUSM-Qmua3DSLqw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-13 00:17:54.622189+00	2023-12-13 00:31:10.955329+00	7xaPhWgPchrrqBrW5WsWXQ	b293f801-2282-4755-9e10-e5e8e1f8a21c
00000000-0000-0000-0000-000000000000	204	wkcCAns56DK9nK-UClv2ZQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-13 00:31:10.957318+00	2023-12-13 00:44:15.183864+00	7_l5ww2XUSM-Qmua3DSLqw	b293f801-2282-4755-9e10-e5e8e1f8a21c
00000000-0000-0000-0000-000000000000	221	hmq6DWHIfq5MKntCVXuVxQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-14 12:32:39.652737+00	2023-12-14 12:46:10.714912+00	Ssq1ZSm0opSB5sNFI-gCpA	90056874-e87c-4138-b381-d2b3ae119816
00000000-0000-0000-0000-000000000000	205	HQT0OVmWQI2qyzU9K4L5Aw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-13 00:44:15.18685+00	2023-12-13 00:57:32.922429+00	wkcCAns56DK9nK-UClv2ZQ	b293f801-2282-4755-9e10-e5e8e1f8a21c
00000000-0000-0000-0000-000000000000	206	PCf2z0hT55PZQRL6MbHXxA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-13 00:57:32.924865+00	2023-12-13 13:37:18.805568+00	HQT0OVmWQI2qyzU9K4L5Aw	b293f801-2282-4755-9e10-e5e8e1f8a21c
00000000-0000-0000-0000-000000000000	222	-YaisrnEPNF5rIkPQ-NRAw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-14 12:46:10.71827+00	2023-12-14 12:59:39.746449+00	hmq6DWHIfq5MKntCVXuVxQ	90056874-e87c-4138-b381-d2b3ae119816
00000000-0000-0000-0000-000000000000	207	SceZwRRG7xLJ-z7kOLF2zg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-13 13:37:18.808773+00	2023-12-13 13:50:27.388134+00	PCf2z0hT55PZQRL6MbHXxA	b293f801-2282-4755-9e10-e5e8e1f8a21c
00000000-0000-0000-0000-000000000000	208	cQQv7mZUWNiF-PnTx6tRdg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-13 13:50:27.390493+00	2023-12-13 14:03:27.706187+00	SceZwRRG7xLJ-z7kOLF2zg	b293f801-2282-4755-9e10-e5e8e1f8a21c
00000000-0000-0000-0000-000000000000	223	CB1C39roETSWqXchqnHIEw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-14 12:59:39.748377+00	2023-12-14 13:13:09.653386+00	-YaisrnEPNF5rIkPQ-NRAw	90056874-e87c-4138-b381-d2b3ae119816
00000000-0000-0000-0000-000000000000	209	5-wRN24IED7TkOfQyscOhA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-13 14:03:27.707962+00	2023-12-13 14:16:57.555531+00	cQQv7mZUWNiF-PnTx6tRdg	b293f801-2282-4755-9e10-e5e8e1f8a21c
00000000-0000-0000-0000-000000000000	210	IA4XREMVsfSDGcFbh1383w	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-13 14:16:57.557991+00	2023-12-13 14:30:21.914657+00	5-wRN24IED7TkOfQyscOhA	b293f801-2282-4755-9e10-e5e8e1f8a21c
00000000-0000-0000-0000-000000000000	224	xP_Crgtmt4oRhs1jEmaXhQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-14 13:13:09.655283+00	2023-12-14 13:26:39.841446+00	CB1C39roETSWqXchqnHIEw	90056874-e87c-4138-b381-d2b3ae119816
00000000-0000-0000-0000-000000000000	211	lIv9p4NvYmD_e4lTK6il0w	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-13 14:30:21.917799+00	2023-12-13 14:43:21.963843+00	IA4XREMVsfSDGcFbh1383w	b293f801-2282-4755-9e10-e5e8e1f8a21c
00000000-0000-0000-0000-000000000000	212	jTSsFjffw7yiOJ6_6sushA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-13 14:43:21.967757+00	2023-12-13 14:56:22.037564+00	lIv9p4NvYmD_e4lTK6il0w	b293f801-2282-4755-9e10-e5e8e1f8a21c
00000000-0000-0000-0000-000000000000	225	Lnnk-z0TuZNbv73DxK5DFw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-14 13:26:39.842798+00	2023-12-14 13:40:09.77496+00	xP_Crgtmt4oRhs1jEmaXhQ	90056874-e87c-4138-b381-d2b3ae119816
00000000-0000-0000-0000-000000000000	226	BT9Jxel6_rmMJOLznf5lfw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-14 13:40:09.776847+00	2023-12-14 13:53:39.746045+00	Lnnk-z0TuZNbv73DxK5DFw	90056874-e87c-4138-b381-d2b3ae119816
00000000-0000-0000-0000-000000000000	227	7W5ejrFvMkPjw4Z6QSNf1A	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-14 13:53:39.748304+00	2023-12-14 14:07:09.796558+00	BT9Jxel6_rmMJOLznf5lfw	90056874-e87c-4138-b381-d2b3ae119816
00000000-0000-0000-0000-000000000000	228	HTDrCX0h7GD5f2X3yXOrsQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-14 14:07:09.799518+00	2023-12-14 14:20:39.904371+00	7W5ejrFvMkPjw4Z6QSNf1A	90056874-e87c-4138-b381-d2b3ae119816
00000000-0000-0000-0000-000000000000	229	fbWj71JQ7IPZ89zZ-gofyQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-14 14:20:39.905484+00	2023-12-14 14:34:09.887374+00	HTDrCX0h7GD5f2X3yXOrsQ	90056874-e87c-4138-b381-d2b3ae119816
00000000-0000-0000-0000-000000000000	230	ko_5lBmZJCEiDpHdRiDtSQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-14 14:34:09.889614+00	2023-12-14 14:47:39.940174+00	fbWj71JQ7IPZ89zZ-gofyQ	90056874-e87c-4138-b381-d2b3ae119816
00000000-0000-0000-0000-000000000000	231	WykgOEz2W6jxb6-hHvgGZQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-14 14:47:39.942447+00	2023-12-14 15:00:39.931172+00	ko_5lBmZJCEiDpHdRiDtSQ	90056874-e87c-4138-b381-d2b3ae119816
00000000-0000-0000-0000-000000000000	232	nPdT3WIOOxj8tDzw3BULJA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-14 15:00:39.934159+00	2023-12-14 15:13:39.990924+00	WykgOEz2W6jxb6-hHvgGZQ	90056874-e87c-4138-b381-d2b3ae119816
00000000-0000-0000-0000-000000000000	233	qodPA0fHPdWBNy7VVosNog	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-14 15:13:39.99292+00	2023-12-14 15:26:39.998707+00	nPdT3WIOOxj8tDzw3BULJA	90056874-e87c-4138-b381-d2b3ae119816
00000000-0000-0000-0000-000000000000	234	t6y4Cg0h5yD9lul_2lDjcw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-14 15:26:39.999907+00	2023-12-14 15:40:10.013797+00	qodPA0fHPdWBNy7VVosNog	90056874-e87c-4138-b381-d2b3ae119816
00000000-0000-0000-0000-000000000000	235	dS02xxcWNUGuqLe29_zPng	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-14 15:40:10.014895+00	2023-12-14 15:53:40.343488+00	t6y4Cg0h5yD9lul_2lDjcw	90056874-e87c-4138-b381-d2b3ae119816
00000000-0000-0000-0000-000000000000	236	WRyL5xASOBi8AqMOHomrZg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-14 15:53:40.345259+00	2023-12-14 16:07:10.340574+00	dS02xxcWNUGuqLe29_zPng	90056874-e87c-4138-b381-d2b3ae119816
00000000-0000-0000-0000-000000000000	407	_O_8fKhFjqMZOxBWkIzCOA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 04:51:10.850823+00	2023-12-19 05:12:24.394939+00	\N	ba214b77-9e60-40e6-b4bb-aec101dd2e45
00000000-0000-0000-0000-000000000000	237	6kZDnyrB1B4frReg_HF5FQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-14 16:07:10.343044+00	2023-12-14 16:20:40.8927+00	WRyL5xASOBi8AqMOHomrZg	90056874-e87c-4138-b381-d2b3ae119816
00000000-0000-0000-0000-000000000000	238	wi0aCsCa5J7VjZXgF5DZJw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-14 16:20:40.89402+00	2023-12-14 16:34:10.15228+00	6kZDnyrB1B4frReg_HF5FQ	90056874-e87c-4138-b381-d2b3ae119816
00000000-0000-0000-0000-000000000000	239	BgTzeZt_uEdDhiZjmuphzw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-14 16:34:10.154177+00	2023-12-14 16:47:40.1743+00	wi0aCsCa5J7VjZXgF5DZJw	90056874-e87c-4138-b381-d2b3ae119816
00000000-0000-0000-0000-000000000000	240	x5204L3kwTdWX2e0JyvIgg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-14 16:47:40.175677+00	2023-12-14 17:01:10.519528+00	BgTzeZt_uEdDhiZjmuphzw	90056874-e87c-4138-b381-d2b3ae119816
00000000-0000-0000-0000-000000000000	241	oi8IK0e7L3FusBOBdPg9ww	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-14 17:01:10.522282+00	2023-12-14 17:14:40.262287+00	x5204L3kwTdWX2e0JyvIgg	90056874-e87c-4138-b381-d2b3ae119816
00000000-0000-0000-0000-000000000000	242	2XLBwQT8CRONQIyM_xM7_A	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-14 17:14:40.264044+00	2023-12-14 17:20:21.940473+00	oi8IK0e7L3FusBOBdPg9ww	90056874-e87c-4138-b381-d2b3ae119816
00000000-0000-0000-0000-000000000000	243	InPEESA9qfSf4dRdfKZJ9A	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-15 15:12:41.321368+00	2023-12-15 15:25:43.897989+00	\N	ed5401e1-9fd8-4304-b6ed-21129e618e6b
00000000-0000-0000-0000-000000000000	244	SBN-2iksMACK7sxureYDaA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-15 15:25:43.899276+00	2023-12-15 15:38:44.068203+00	InPEESA9qfSf4dRdfKZJ9A	ed5401e1-9fd8-4304-b6ed-21129e618e6b
00000000-0000-0000-0000-000000000000	245	Jmew1fnhdqwPMrkS9m8nEw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-15 15:38:44.07031+00	2023-12-15 15:51:47.488876+00	SBN-2iksMACK7sxureYDaA	ed5401e1-9fd8-4304-b6ed-21129e618e6b
00000000-0000-0000-0000-000000000000	246	hBK5vvsCPoWRPoLKl9ROxQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-15 15:51:47.493124+00	2023-12-15 16:05:11.040864+00	Jmew1fnhdqwPMrkS9m8nEw	ed5401e1-9fd8-4304-b6ed-21129e618e6b
00000000-0000-0000-0000-000000000000	247	NDf948HyBu2wuIG-8MM1vw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-15 16:05:11.045392+00	2023-12-15 16:18:40.939116+00	hBK5vvsCPoWRPoLKl9ROxQ	ed5401e1-9fd8-4304-b6ed-21129e618e6b
00000000-0000-0000-0000-000000000000	248	0zGCINmRxnk6VFEfHgonQw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-15 16:18:40.943521+00	2023-12-15 16:32:10.837689+00	NDf948HyBu2wuIG-8MM1vw	ed5401e1-9fd8-4304-b6ed-21129e618e6b
00000000-0000-0000-0000-000000000000	249	o1s4TQAoyow7QwnyOcRwjw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-15 16:32:10.841094+00	2023-12-15 16:32:10.898617+00	0zGCINmRxnk6VFEfHgonQw	ed5401e1-9fd8-4304-b6ed-21129e618e6b
00000000-0000-0000-0000-000000000000	250	_q_tGv-3SCwemlGT8j47gA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	f	2023-12-15 16:34:01.760258+00	2023-12-15 16:34:01.760258+00	\N	73a4d827-c6ea-4ba4-b341-601f97c11793
00000000-0000-0000-0000-000000000000	251	Y4kzkbUvfPO5jpFsMnK1jA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-15 16:35:22.01321+00	2023-12-15 16:48:39.711101+00	\N	98e8b0f3-7942-4c17-9d87-7bebc75a3631
00000000-0000-0000-0000-000000000000	252	IDpI-L4j8ByRscFBqQDQRA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-15 16:48:39.714585+00	2023-12-15 17:01:40.370289+00	Y4kzkbUvfPO5jpFsMnK1jA	98e8b0f3-7942-4c17-9d87-7bebc75a3631
00000000-0000-0000-0000-000000000000	253	OKzPbSy47LllewtIexj1qQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-15 17:01:40.375595+00	2023-12-15 17:15:04.255897+00	IDpI-L4j8ByRscFBqQDQRA	98e8b0f3-7942-4c17-9d87-7bebc75a3631
00000000-0000-0000-0000-000000000000	254	-cZZsxvIrOt6fDZAIRB4Qw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-15 17:15:04.25953+00	2023-12-15 17:28:10.467412+00	OKzPbSy47LllewtIexj1qQ	98e8b0f3-7942-4c17-9d87-7bebc75a3631
00000000-0000-0000-0000-000000000000	255	5n_E7WPkP3gWs_tqdWz6ZQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-15 17:28:10.46907+00	2023-12-15 17:41:34.207456+00	-cZZsxvIrOt6fDZAIRB4Qw	98e8b0f3-7942-4c17-9d87-7bebc75a3631
00000000-0000-0000-0000-000000000000	256	KWR7E6caO7Xf2y9QqITKyg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-15 17:41:34.208645+00	2023-12-15 17:54:40.409564+00	5n_E7WPkP3gWs_tqdWz6ZQ	98e8b0f3-7942-4c17-9d87-7bebc75a3631
00000000-0000-0000-0000-000000000000	257	2LEYWLr7qCHf7FdMo0JReg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-15 17:54:40.411495+00	2023-12-15 18:08:04.279233+00	KWR7E6caO7Xf2y9QqITKyg	98e8b0f3-7942-4c17-9d87-7bebc75a3631
00000000-0000-0000-0000-000000000000	258	bnxBQUytybjMl9UD1vtc8Q	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-15 18:08:04.281353+00	2023-12-15 18:21:34.234458+00	2LEYWLr7qCHf7FdMo0JReg	98e8b0f3-7942-4c17-9d87-7bebc75a3631
00000000-0000-0000-0000-000000000000	259	Ef-Yv3Pv_Zw9d5lVCK185g	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-15 18:21:34.236498+00	2023-12-15 18:34:40.831161+00	bnxBQUytybjMl9UD1vtc8Q	98e8b0f3-7942-4c17-9d87-7bebc75a3631
00000000-0000-0000-0000-000000000000	260	G9noc2-DxksEo93yKqv4fw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-15 18:34:40.834504+00	2023-12-15 18:48:04.345502+00	Ef-Yv3Pv_Zw9d5lVCK185g	98e8b0f3-7942-4c17-9d87-7bebc75a3631
00000000-0000-0000-0000-000000000000	261	Zf1yCILd5Znkw_YLlsBxKA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-15 18:48:04.346829+00	2023-12-15 19:01:34.541646+00	G9noc2-DxksEo93yKqv4fw	98e8b0f3-7942-4c17-9d87-7bebc75a3631
00000000-0000-0000-0000-000000000000	262	5bVnDzo2wb1nEi23nfB7wA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-15 19:01:34.544413+00	2023-12-15 20:23:47.432899+00	Zf1yCILd5Znkw_YLlsBxKA	98e8b0f3-7942-4c17-9d87-7bebc75a3631
00000000-0000-0000-0000-000000000000	263	1hTu0pwq8teoomMsFk9gQA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-15 20:23:47.434099+00	2023-12-15 20:31:56.900179+00	5bVnDzo2wb1nEi23nfB7wA	98e8b0f3-7942-4c17-9d87-7bebc75a3631
00000000-0000-0000-0000-000000000000	264	H1eUnor73PnmSNbdoUO9MA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-15 20:33:09.602073+00	2023-12-15 20:46:20.465373+00	\N	b6672a79-7255-44ba-92a3-40b84de08b3e
00000000-0000-0000-0000-000000000000	265	v7aoTGE5fMM80_V-_X1f8A	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-15 20:46:20.467623+00	2023-12-15 21:25:52.917702+00	H1eUnor73PnmSNbdoUO9MA	b6672a79-7255-44ba-92a3-40b84de08b3e
00000000-0000-0000-0000-000000000000	266	mZSSq9fLME73Jy7vy_CZgw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-15 21:25:52.919596+00	2023-12-15 21:39:24.616807+00	v7aoTGE5fMM80_V-_X1f8A	b6672a79-7255-44ba-92a3-40b84de08b3e
00000000-0000-0000-0000-000000000000	267	bN2czIulxvOc88YmVx0Y7g	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-15 21:39:24.618197+00	2023-12-15 22:00:29.453054+00	mZSSq9fLME73Jy7vy_CZgw	b6672a79-7255-44ba-92a3-40b84de08b3e
00000000-0000-0000-0000-000000000000	268	g7NcwA3HPYkPRo5NUql_cg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-15 22:00:29.454116+00	2023-12-15 22:13:36.933628+00	bN2czIulxvOc88YmVx0Y7g	b6672a79-7255-44ba-92a3-40b84de08b3e
00000000-0000-0000-0000-000000000000	269	gTI16rcFZoVFLkQavfB4cA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-15 22:13:36.935407+00	2023-12-15 22:26:40.500191+00	g7NcwA3HPYkPRo5NUql_cg	b6672a79-7255-44ba-92a3-40b84de08b3e
00000000-0000-0000-0000-000000000000	270	94sCDyhHbaTPKZSYx_Kr8Q	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-15 22:26:40.502596+00	2023-12-15 22:39:57.589064+00	gTI16rcFZoVFLkQavfB4cA	b6672a79-7255-44ba-92a3-40b84de08b3e
00000000-0000-0000-0000-000000000000	271	weep5JL-JDZadCKpu7A98w	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-15 22:39:57.594069+00	2023-12-15 22:53:05.340736+00	94sCDyhHbaTPKZSYx_Kr8Q	b6672a79-7255-44ba-92a3-40b84de08b3e
00000000-0000-0000-0000-000000000000	272	nEA5RwzDMepHvK20j_MuSg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-15 22:53:05.344343+00	2023-12-15 23:06:21.274779+00	weep5JL-JDZadCKpu7A98w	b6672a79-7255-44ba-92a3-40b84de08b3e
00000000-0000-0000-0000-000000000000	273	B3Wgd6QJS3hIq6oEZCaAVw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-15 23:06:21.276282+00	2023-12-15 23:19:45.068956+00	nEA5RwzDMepHvK20j_MuSg	b6672a79-7255-44ba-92a3-40b84de08b3e
00000000-0000-0000-0000-000000000000	274	wzK20vn8AffAtluJCwBVvg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-15 23:19:45.071006+00	2023-12-16 13:38:41.954585+00	B3Wgd6QJS3hIq6oEZCaAVw	b6672a79-7255-44ba-92a3-40b84de08b3e
00000000-0000-0000-0000-000000000000	275	lJaH_TI8JcPAi7A__9LaBQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-16 13:38:41.956613+00	2023-12-16 13:51:59.746304+00	wzK20vn8AffAtluJCwBVvg	b6672a79-7255-44ba-92a3-40b84de08b3e
00000000-0000-0000-0000-000000000000	276	ecDeAiEXWBNVDVlNiBJ9FQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-16 13:51:59.747443+00	2023-12-16 14:05:29.739886+00	lJaH_TI8JcPAi7A__9LaBQ	b6672a79-7255-44ba-92a3-40b84de08b3e
00000000-0000-0000-0000-000000000000	277	-jTj4kcW0oRfsa31nPmasQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-16 14:05:29.7423+00	2023-12-16 14:18:59.770117+00	ecDeAiEXWBNVDVlNiBJ9FQ	b6672a79-7255-44ba-92a3-40b84de08b3e
00000000-0000-0000-0000-000000000000	278	wd26oBCv6CeCF7Pm9IuJJQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-16 14:18:59.7757+00	2023-12-16 14:32:29.812326+00	-jTj4kcW0oRfsa31nPmasQ	b6672a79-7255-44ba-92a3-40b84de08b3e
00000000-0000-0000-0000-000000000000	279	zohGjmC3FeCC8jFwfD2Sig	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-16 14:32:29.815061+00	2023-12-16 14:45:59.780796+00	wd26oBCv6CeCF7Pm9IuJJQ	b6672a79-7255-44ba-92a3-40b84de08b3e
00000000-0000-0000-0000-000000000000	280	opR89n73vtrviWUzguqF_A	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-16 14:45:59.782321+00	2023-12-16 14:58:59.90722+00	zohGjmC3FeCC8jFwfD2Sig	b6672a79-7255-44ba-92a3-40b84de08b3e
00000000-0000-0000-0000-000000000000	281	dmBpsLZnL0l4BdWNPov1CA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-16 14:58:59.90964+00	2023-12-16 15:11:59.865348+00	opR89n73vtrviWUzguqF_A	b6672a79-7255-44ba-92a3-40b84de08b3e
00000000-0000-0000-0000-000000000000	299	CefIy5DAXGCLVFb6lZnieA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-17 14:40:21.150709+00	2023-12-17 14:53:33.064239+00	nqmJySH6hjHdvS317qhfCw	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	282	1cPsqY6SZQaz8HnlTACcKQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-16 15:11:59.868791+00	2023-12-16 15:16:33.700682+00	dmBpsLZnL0l4BdWNPov1CA	b6672a79-7255-44ba-92a3-40b84de08b3e
00000000-0000-0000-0000-000000000000	301	b08NUsjdcKEeZlDSV7Lirg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-17 15:07:03.04206+00	2023-12-17 15:20:31.959994+00	Oj3X0muHke-L8Nb_VlHRRw	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	283	O_r41hgt6qfudR90Cg0JGw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-16 15:35:40.313763+00	2023-12-16 15:49:04.024515+00	\N	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	284	7mmhrHCICGP8FaK8FysHaA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-16 15:49:04.027657+00	2023-12-16 20:03:54.391166+00	O_r41hgt6qfudR90Cg0JGw	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	302	tn8cqC0Sep4mOBXpwrkH7w	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-17 15:20:31.961416+00	2023-12-17 15:33:31.876622+00	b08NUsjdcKEeZlDSV7Lirg	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	285	zNr8OPT3jeGCrt2Ehg2zbw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-16 20:03:54.395756+00	2023-12-16 20:38:50.409706+00	7mmhrHCICGP8FaK8FysHaA	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	286	U8k3VYQaUbGQmTndzMKSCw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-16 20:38:50.414557+00	2023-12-16 20:54:49.648034+00	zNr8OPT3jeGCrt2Ehg2zbw	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	303	8ibe9CCZckt7PrMTJuLdHQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-17 15:33:31.876952+00	2023-12-17 15:46:31.917695+00	tn8cqC0Sep4mOBXpwrkH7w	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	287	kwrh9ZaV4vTbPim9hYUTjg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-16 20:54:49.651853+00	2023-12-16 21:08:19.493048+00	U8k3VYQaUbGQmTndzMKSCw	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	288	EO_g0FETSVkGolMVq7XWvA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-16 21:08:19.497734+00	2023-12-16 21:21:49.599112+00	kwrh9ZaV4vTbPim9hYUTjg	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	304	jooWA_k4VKYEkZTC3k8Kmw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-17 15:46:31.919986+00	2023-12-17 15:59:31.935706+00	8ibe9CCZckt7PrMTJuLdHQ	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	289	E1GU2HB8IQiyOxOcUcMHZQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-16 21:21:49.602001+00	2023-12-16 21:35:19.569977+00	EO_g0FETSVkGolMVq7XWvA	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	290	Dbh2LfPJ08revGwBZ7_rPg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-16 21:35:19.574509+00	2023-12-16 22:09:21.000772+00	E1GU2HB8IQiyOxOcUcMHZQ	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	305	ex_eHKS3lSTRTF35BTIRpA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-17 15:59:31.936582+00	2023-12-17 16:12:31.966831+00	jooWA_k4VKYEkZTC3k8Kmw	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	291	JY1qAVK0fE0Gc2RebYH2bg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-16 22:09:21.002752+00	2023-12-16 22:28:41.920401+00	Dbh2LfPJ08revGwBZ7_rPg	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	292	9EhZowpeUVv_7PLoNltdMQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-16 22:28:41.924716+00	2023-12-16 22:47:23.082141+00	JY1qAVK0fE0Gc2RebYH2bg	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	306	e1HPh_-FvAEAbtzbRWlnpg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-17 16:12:31.968027+00	2023-12-17 16:25:31.975937+00	ex_eHKS3lSTRTF35BTIRpA	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	293	h1aWnOw_VOCvHYnb8x2oJA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-16 22:47:23.083341+00	2023-12-16 23:15:30.91152+00	9EhZowpeUVv_7PLoNltdMQ	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	294	ufZ4akOpkj_PdNuiris6ww	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-16 23:15:30.913253+00	2023-12-16 23:31:40.37239+00	h1aWnOw_VOCvHYnb8x2oJA	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	307	L1rEklVQZndYMZzQwQxfcg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-17 16:25:31.978149+00	2023-12-17 16:38:32.062715+00	e1HPh_-FvAEAbtzbRWlnpg	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	295	h4FNsjUcU45urROnuoTTXw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-16 23:31:40.375467+00	2023-12-16 23:45:59.832523+00	ufZ4akOpkj_PdNuiris6ww	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	296	toZkUFCpA7fEjlB5IPnSOA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-16 23:45:59.836331+00	2023-12-16 23:59:17.747134+00	h4FNsjUcU45urROnuoTTXw	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	308	x7z5ZF9TrhmBA1NaJFkloQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-17 16:38:32.063896+00	2023-12-17 16:52:02.120154+00	L1rEklVQZndYMZzQwQxfcg	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	297	8hP_QBf86K3iZaa4WpY-ng	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-16 23:59:17.749993+00	2023-12-17 14:27:13.777758+00	toZkUFCpA7fEjlB5IPnSOA	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	298	nqmJySH6hjHdvS317qhfCw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-17 14:27:13.780443+00	2023-12-17 14:40:21.148351+00	8hP_QBf86K3iZaa4WpY-ng	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	309	shC8dFnN4ayo_ymZdjIkJw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-17 16:52:02.120487+00	2023-12-17 17:05:03.004767+00	x7z5ZF9TrhmBA1NaJFkloQ	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	310	aVoXgGNbi8_2VopThPNWLw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-17 17:05:03.00737+00	2023-12-17 17:18:32.939181+00	shC8dFnN4ayo_ymZdjIkJw	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	311	rWxvSs-ZA3EBzstrIs6lcA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-17 17:18:32.942273+00	2023-12-17 17:31:33.048527+00	aVoXgGNbi8_2VopThPNWLw	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	312	WoW5HmQbBaMiWyUQkAmJTA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-17 17:31:33.051982+00	2023-12-17 17:45:02.947649+00	rWxvSs-ZA3EBzstrIs6lcA	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	313	4jhymiFmMomUu53SvZnE9g	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-17 17:45:02.949038+00	2023-12-17 17:58:03.012177+00	WoW5HmQbBaMiWyUQkAmJTA	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	314	ef2YjIQZfMKBz0bREBpMXA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-17 17:58:03.015026+00	2023-12-17 18:11:33.013038+00	4jhymiFmMomUu53SvZnE9g	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	315	SpSmP7IPlTAZOd8kUJNOig	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-17 18:11:33.017358+00	2023-12-17 18:25:03.040835+00	ef2YjIQZfMKBz0bREBpMXA	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	316	TGKwgySRWkjSAdDiH5Vu6A	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-17 18:25:03.042237+00	2023-12-17 18:38:32.909366+00	SpSmP7IPlTAZOd8kUJNOig	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	317	u60yit8qAapm2TNeya3M0w	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-17 18:38:32.911614+00	2023-12-17 18:51:32.831966+00	TGKwgySRWkjSAdDiH5Vu6A	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	318	ssAUEVs7BDhjSysGC1QiBw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-17 18:51:32.833796+00	2023-12-17 19:04:32.932385+00	u60yit8qAapm2TNeya3M0w	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	319	mHTDns4sZ6X5TXj6m05RzQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-17 19:04:32.934012+00	2023-12-17 19:17:32.927961+00	ssAUEVs7BDhjSysGC1QiBw	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	320	fDlCuXmiSUm-jzIPtVWD2g	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-17 19:17:32.928958+00	2023-12-17 19:30:37.282592+00	mHTDns4sZ6X5TXj6m05RzQ	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	321	9VN9x6SLPfpCef5slNP6Kw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-17 19:30:37.282947+00	2023-12-17 19:44:07.303799+00	fDlCuXmiSUm-jzIPtVWD2g	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	322	b5e0SCiqoqZWcdtVIE4Xlw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-17 19:44:07.304538+00	2023-12-17 19:57:36.544809+00	9VN9x6SLPfpCef5slNP6Kw	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	323	FfT__Qq7awXZi6V1tE9lzA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-17 19:57:36.54516+00	2023-12-17 20:10:52.627923+00	b5e0SCiqoqZWcdtVIE4Xlw	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	324	8Ehe9HnJGTHY9c3aGacB3Q	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-17 20:10:52.628245+00	2023-12-17 20:24:04.74047+00	FfT__Qq7awXZi6V1tE9lzA	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	325	Hd2rxW1_FLWbHmx-AweZpw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-17 20:24:04.740792+00	2023-12-17 20:37:26.666794+00	8Ehe9HnJGTHY9c3aGacB3Q	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	326	vtVujDZ1hA04xZ1-uqlE9Q	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-17 20:37:26.667188+00	2023-12-17 20:50:41.63015+00	Hd2rxW1_FLWbHmx-AweZpw	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	327	LocGOk4BOdrixIWwcV2AEA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-17 20:50:41.630526+00	2023-12-17 21:03:54.731933+00	vtVujDZ1hA04xZ1-uqlE9Q	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	408	IdP4COttU_29Dp2PG86Ifw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 05:12:24.395466+00	2023-12-19 05:25:26.760093+00	_O_8fKhFjqMZOxBWkIzCOA	ba214b77-9e60-40e6-b4bb-aec101dd2e45
00000000-0000-0000-0000-000000000000	328	y8pGaVg7ZYOcHYILLZurzw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-17 21:03:54.732229+00	2023-12-17 21:23:25.302183+00	LocGOk4BOdrixIWwcV2AEA	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	329	zIPgcNv884t6A-JsuOalDg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-17 21:23:25.302517+00	2023-12-17 21:36:26.051851+00	y8pGaVg7ZYOcHYILLZurzw	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	330	-R_HpVL5qvYrfss9o7L8Bg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-17 21:36:26.052211+00	2023-12-17 21:49:55.985084+00	zIPgcNv884t6A-JsuOalDg	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	331	Q5mtE3UdeYnFwjMjFhGKlw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-17 21:49:55.985452+00	2023-12-17 22:02:56.000099+00	-R_HpVL5qvYrfss9o7L8Bg	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	332	kdMfw2V0XXnBDeyRAHE8dw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-17 22:02:56.002639+00	2023-12-17 22:16:26.09013+00	Q5mtE3UdeYnFwjMjFhGKlw	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	333	ZQ8TOkMRgkBSFKae2AsPOA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-17 22:16:26.091373+00	2023-12-17 22:29:56.113347+00	kdMfw2V0XXnBDeyRAHE8dw	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	334	Lo4XZQMHbtMiC_uYxkcA0A	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-17 22:29:56.114859+00	2023-12-17 22:43:26.150609+00	ZQ8TOkMRgkBSFKae2AsPOA	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	335	vsCHxa-yG6B9WsiphHXyTw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-17 22:43:26.150988+00	2023-12-17 22:56:56.180931+00	Lo4XZQMHbtMiC_uYxkcA0A	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	336	oXPL9vcHYrCLj0sZyFydOQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-17 22:56:56.182855+00	2023-12-17 23:10:26.197221+00	vsCHxa-yG6B9WsiphHXyTw	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	337	O-6mA-ZDv0RLcXkVheHQTQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-17 23:10:26.19757+00	2023-12-17 23:23:31.126118+00	oXPL9vcHYrCLj0sZyFydOQ	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	338	PuEvjbPhxRaRPjOtAmwlrw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-17 23:23:31.127285+00	2023-12-17 23:37:00.847039+00	O-6mA-ZDv0RLcXkVheHQTQ	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	339	4SrF3BaAo1hKEA2K2o8ZFw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-17 23:37:00.848528+00	2023-12-17 23:50:00.827718+00	PuEvjbPhxRaRPjOtAmwlrw	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	340	iFm64mjUGgCSqZ0BnXb_vQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-17 23:50:00.830659+00	2023-12-18 00:03:00.833561+00	4SrF3BaAo1hKEA2K2o8ZFw	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	341	zFhUrRKUt-gRgex7EYkeZg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-18 00:03:00.836592+00	2023-12-18 00:16:00.811444+00	iFm64mjUGgCSqZ0BnXb_vQ	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	342	EwAKclq7OfHM9x4n6tOIwA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-18 00:16:00.812803+00	2023-12-18 00:29:00.800888+00	zFhUrRKUt-gRgex7EYkeZg	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	343	PnVh6FA9PV_7VTsLpI8U8g	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-18 00:29:00.801637+00	2023-12-18 00:42:00.864121+00	EwAKclq7OfHM9x4n6tOIwA	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	344	3gm_3BubkOXRhVyZdRWSmg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-18 00:42:00.86498+00	2023-12-18 00:55:00.823489+00	PnVh6FA9PV_7VTsLpI8U8g	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	345	wiB7gWkwpAe82j1-GHp-LQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-18 00:55:00.82501+00	2023-12-18 01:08:01.03262+00	3gm_3BubkOXRhVyZdRWSmg	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	346	d9LLK_4cy24pY1D0NLmT2Q	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-18 01:08:01.033878+00	2023-12-18 01:22:52.276619+00	wiB7gWkwpAe82j1-GHp-LQ	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	347	GoVYoEgaYJrvxjZKSMt7Sw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-18 01:22:52.276936+00	2023-12-18 01:36:23.264069+00	d9LLK_4cy24pY1D0NLmT2Q	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	348	I1bc5tV4jqd3UrtjDpTZ8Q	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-18 01:36:23.264361+00	2023-12-18 01:50:39.140658+00	GoVYoEgaYJrvxjZKSMt7Sw	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	349	qmQVxvgXCSSDquFgx-q69g	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-18 01:50:39.14233+00	2023-12-18 02:09:44.499484+00	I1bc5tV4jqd3UrtjDpTZ8Q	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	350	C2WKEweZUd1ZmIOH5Zjm8g	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-18 02:09:44.499835+00	2023-12-18 16:13:06.16701+00	qmQVxvgXCSSDquFgx-q69g	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	351	a8SN2PW-uSuRIfE7h-3x5Q	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-18 16:13:06.167891+00	2023-12-18 16:26:35.835637+00	C2WKEweZUd1ZmIOH5Zjm8g	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	352	dwmvSO1fXzTcD7WZiHNWiw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-18 16:26:35.837922+00	2023-12-18 16:40:05.918993+00	a8SN2PW-uSuRIfE7h-3x5Q	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	353	poYxZ707kLh8BIhcX6LRHg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-18 16:40:05.921281+00	2023-12-18 16:45:11.756723+00	dwmvSO1fXzTcD7WZiHNWiw	73ca2c05-c30d-41a9-a3ca-0e0398e66175
00000000-0000-0000-0000-000000000000	354	ns7-T9c458_3OdKhrufHrA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-18 16:45:54.113461+00	2023-12-18 16:58:56.782311+00	\N	eede4336-98b5-404f-927f-61c48d49dfbd
00000000-0000-0000-0000-000000000000	355	qr5GhXyBaFVCQcvMf7edgg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-18 16:58:56.783176+00	2023-12-18 17:16:59.347867+00	ns7-T9c458_3OdKhrufHrA	eede4336-98b5-404f-927f-61c48d49dfbd
00000000-0000-0000-0000-000000000000	356	mnB-eil9CDdvaWdBq5v-qQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-18 17:16:59.348212+00	2023-12-18 17:30:39.165296+00	qr5GhXyBaFVCQcvMf7edgg	eede4336-98b5-404f-927f-61c48d49dfbd
00000000-0000-0000-0000-000000000000	357	9z5V8J56qVvEwRVMS9e-xA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-18 17:30:39.167664+00	2023-12-18 17:43:43.612927+00	mnB-eil9CDdvaWdBq5v-qQ	eede4336-98b5-404f-927f-61c48d49dfbd
00000000-0000-0000-0000-000000000000	358	HVagdhRMuLZspC_k2qileA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-18 17:43:43.613745+00	2023-12-18 18:18:40.111034+00	9z5V8J56qVvEwRVMS9e-xA	eede4336-98b5-404f-927f-61c48d49dfbd
00000000-0000-0000-0000-000000000000	359	nfp2ykvXKR2i-e1MwvtMNg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-18 18:18:40.112117+00	2023-12-18 18:31:46.00978+00	HVagdhRMuLZspC_k2qileA	eede4336-98b5-404f-927f-61c48d49dfbd
00000000-0000-0000-0000-000000000000	360	amsbr-Zf6BjIxmBhMBZpWw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-18 18:31:46.011038+00	2023-12-18 18:44:50.635021+00	nfp2ykvXKR2i-e1MwvtMNg	eede4336-98b5-404f-927f-61c48d49dfbd
00000000-0000-0000-0000-000000000000	361	l2DTsgNXRDvOteDMRB-gaA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-18 18:44:50.63706+00	2023-12-18 19:01:07.342678+00	amsbr-Zf6BjIxmBhMBZpWw	eede4336-98b5-404f-927f-61c48d49dfbd
00000000-0000-0000-0000-000000000000	362	M95hQNKg9-1NXHsMJN1jgA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-18 19:01:07.345278+00	2023-12-18 19:14:18.169833+00	l2DTsgNXRDvOteDMRB-gaA	eede4336-98b5-404f-927f-61c48d49dfbd
00000000-0000-0000-0000-000000000000	363	GAl6SLgUk4YNgjs8-qMKVw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-18 19:14:18.171159+00	2023-12-18 19:27:37.456905+00	M95hQNKg9-1NXHsMJN1jgA	eede4336-98b5-404f-927f-61c48d49dfbd
00000000-0000-0000-0000-000000000000	364	17COx3pdaZYejAjt0u4t9Q	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-18 19:27:37.457225+00	2023-12-18 19:40:48.29389+00	GAl6SLgUk4YNgjs8-qMKVw	eede4336-98b5-404f-927f-61c48d49dfbd
00000000-0000-0000-0000-000000000000	365	PQAY8DFvBLFBIvzmV9ZWMw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-18 19:40:48.295969+00	2023-12-18 19:54:18.282921+00	17COx3pdaZYejAjt0u4t9Q	eede4336-98b5-404f-927f-61c48d49dfbd
00000000-0000-0000-0000-000000000000	366	bAE4gxfIZUkjcmZ_Fm2SAA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-18 19:54:18.285493+00	2023-12-18 20:07:19.125478+00	PQAY8DFvBLFBIvzmV9ZWMw	eede4336-98b5-404f-927f-61c48d49dfbd
00000000-0000-0000-0000-000000000000	367	SRlbrG-VtrZVK5eR2mgihg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-18 20:07:19.12912+00	2023-12-18 20:20:48.317068+00	bAE4gxfIZUkjcmZ_Fm2SAA	eede4336-98b5-404f-927f-61c48d49dfbd
00000000-0000-0000-0000-000000000000	368	OQ858l_gtQiM0Pl6JKU-dw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-18 20:20:48.319349+00	2023-12-18 20:33:48.997501+00	SRlbrG-VtrZVK5eR2mgihg	eede4336-98b5-404f-927f-61c48d49dfbd
00000000-0000-0000-0000-000000000000	369	sYq8Z7LS3Mz6qNqEfwIPyw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-18 20:33:48.998826+00	2023-12-18 20:47:18.393813+00	OQ858l_gtQiM0Pl6JKU-dw	eede4336-98b5-404f-927f-61c48d49dfbd
00000000-0000-0000-0000-000000000000	370	Cdw6qDYxL56kQyw5ZKiKzA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-18 20:47:18.396157+00	2023-12-18 21:00:19.19681+00	sYq8Z7LS3Mz6qNqEfwIPyw	eede4336-98b5-404f-927f-61c48d49dfbd
00000000-0000-0000-0000-000000000000	371	zX5urcZiQuXiahhziAiCKg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-18 21:00:19.198672+00	2023-12-18 21:13:28.550709+00	Cdw6qDYxL56kQyw5ZKiKzA	eede4336-98b5-404f-927f-61c48d49dfbd
00000000-0000-0000-0000-000000000000	372	iVSHIBjEitmYn05Yg26zaQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-18 21:13:28.551069+00	2023-12-18 21:26:48.530277+00	zX5urcZiQuXiahhziAiCKg	eede4336-98b5-404f-927f-61c48d49dfbd
00000000-0000-0000-0000-000000000000	406	xP1CyPmXoif5Ofeh0-95nw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 04:43:29.167348+00	2023-12-19 04:50:37.017503+00	DnqeW3-QgA3txerVj0ma0Q	eede4336-98b5-404f-927f-61c48d49dfbd
00000000-0000-0000-0000-000000000000	373	JawI3bQP_cnPesMv0i4Atg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-18 21:26:48.530576+00	2023-12-18 21:39:49.447049+00	iVSHIBjEitmYn05Yg26zaQ	eede4336-98b5-404f-927f-61c48d49dfbd
00000000-0000-0000-0000-000000000000	374	gzeBb5vYQITdujhr-csrXQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-18 21:39:49.447377+00	2023-12-18 21:52:58.394603+00	JawI3bQP_cnPesMv0i4Atg	eede4336-98b5-404f-927f-61c48d49dfbd
00000000-0000-0000-0000-000000000000	409	t6XhCK14v_p7RiayWVJcgg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 05:25:26.760405+00	2023-12-19 05:38:56.709736+00	IdP4COttU_29Dp2PG86Ifw	ba214b77-9e60-40e6-b4bb-aec101dd2e45
00000000-0000-0000-0000-000000000000	375	vPUU0XnvoSg9eJXyFqDIjw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-18 21:52:58.394935+00	2023-12-18 22:06:18.605128+00	gzeBb5vYQITdujhr-csrXQ	eede4336-98b5-404f-927f-61c48d49dfbd
00000000-0000-0000-0000-000000000000	376	5NjN3IqlAor4BnZ7e-gm9w	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-18 22:06:18.605876+00	2023-12-18 22:19:19.276935+00	vPUU0XnvoSg9eJXyFqDIjw	eede4336-98b5-404f-927f-61c48d49dfbd
00000000-0000-0000-0000-000000000000	410	ImE7_yZ1Of4R9WfoAfn0fA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 05:38:56.710032+00	2023-12-19 05:52:26.765143+00	t6XhCK14v_p7RiayWVJcgg	ba214b77-9e60-40e6-b4bb-aec101dd2e45
00000000-0000-0000-0000-000000000000	377	D7-D7Ui-GQCTr73KNamwXg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-18 22:19:19.277235+00	2023-12-18 22:32:28.483237+00	5NjN3IqlAor4BnZ7e-gm9w	eede4336-98b5-404f-927f-61c48d49dfbd
00000000-0000-0000-0000-000000000000	378	uXNMYZmkq_7oKU_RXeFqQA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-18 22:32:28.483946+00	2023-12-18 22:45:49.271072+00	D7-D7Ui-GQCTr73KNamwXg	eede4336-98b5-404f-927f-61c48d49dfbd
00000000-0000-0000-0000-000000000000	411	QwirtKrG6ERYNE8iVNKhLg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 05:52:26.765448+00	2023-12-19 06:05:56.774081+00	ImE7_yZ1Of4R9WfoAfn0fA	ba214b77-9e60-40e6-b4bb-aec101dd2e45
00000000-0000-0000-0000-000000000000	379	4Bfx6ySHWkvDK3_AXI3stw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-18 22:45:49.272732+00	2023-12-18 22:58:58.253524+00	uXNMYZmkq_7oKU_RXeFqQA	eede4336-98b5-404f-927f-61c48d49dfbd
00000000-0000-0000-0000-000000000000	380	VBXhLDmSV2VWm5GJP7EeMg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-18 22:58:58.255873+00	2023-12-18 23:12:19.426812+00	4Bfx6ySHWkvDK3_AXI3stw	eede4336-98b5-404f-927f-61c48d49dfbd
00000000-0000-0000-0000-000000000000	412	TTwoncY8F_TuP-tywZlMBA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 06:05:56.774401+00	2023-12-19 06:19:26.807534+00	QwirtKrG6ERYNE8iVNKhLg	ba214b77-9e60-40e6-b4bb-aec101dd2e45
00000000-0000-0000-0000-000000000000	381	H3CYiDnKjEyPtUZdkElU2w	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-18 23:12:19.427691+00	2023-12-18 23:25:28.369589+00	VBXhLDmSV2VWm5GJP7EeMg	eede4336-98b5-404f-927f-61c48d49dfbd
00000000-0000-0000-0000-000000000000	382	iNwQmuC9nS3x3JihDxyxMg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-18 23:25:28.369903+00	2023-12-18 23:38:58.358891+00	H3CYiDnKjEyPtUZdkElU2w	eede4336-98b5-404f-927f-61c48d49dfbd
00000000-0000-0000-0000-000000000000	413	V0vjkliYdNU__Jd1lIg1sA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 06:19:26.80783+00	2023-12-19 06:32:56.893337+00	TTwoncY8F_TuP-tywZlMBA	ba214b77-9e60-40e6-b4bb-aec101dd2e45
00000000-0000-0000-0000-000000000000	383	FdT9z8MeB1Kc4yUEqFnlXw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-18 23:38:58.360265+00	2023-12-18 23:52:28.375003+00	iNwQmuC9nS3x3JihDxyxMg	eede4336-98b5-404f-927f-61c48d49dfbd
00000000-0000-0000-0000-000000000000	384	7P5RNnNMeTeDFlSvody8sw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-18 23:52:28.376037+00	2023-12-19 00:05:58.464104+00	FdT9z8MeB1Kc4yUEqFnlXw	eede4336-98b5-404f-927f-61c48d49dfbd
00000000-0000-0000-0000-000000000000	414	CznypUEIMJ49JAi99BT3iw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 06:32:56.893649+00	2023-12-19 06:45:56.922122+00	V0vjkliYdNU__Jd1lIg1sA	ba214b77-9e60-40e6-b4bb-aec101dd2e45
00000000-0000-0000-0000-000000000000	385	sCOW87vrOuTJg7e468haKw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 00:05:58.464409+00	2023-12-19 00:19:18.956112+00	7P5RNnNMeTeDFlSvody8sw	eede4336-98b5-404f-927f-61c48d49dfbd
00000000-0000-0000-0000-000000000000	386	73nqSN36yucuYujtPGP0KQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 00:19:18.95644+00	2023-12-19 00:32:18.947266+00	sCOW87vrOuTJg7e468haKw	eede4336-98b5-404f-927f-61c48d49dfbd
00000000-0000-0000-0000-000000000000	415	J2HKZGzMxCnxpRZWQ6tHdA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 06:45:56.922493+00	2023-12-19 06:58:56.94347+00	CznypUEIMJ49JAi99BT3iw	ba214b77-9e60-40e6-b4bb-aec101dd2e45
00000000-0000-0000-0000-000000000000	387	mUaBTYmZR418CQvTlbRVeA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 00:32:18.947563+00	2023-12-19 00:45:18.99968+00	73nqSN36yucuYujtPGP0KQ	eede4336-98b5-404f-927f-61c48d49dfbd
00000000-0000-0000-0000-000000000000	388	kiGqQ6IXI6yIhpaB1mnAww	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 00:45:19.000958+00	2023-12-19 00:58:38.187342+00	mUaBTYmZR418CQvTlbRVeA	eede4336-98b5-404f-927f-61c48d49dfbd
00000000-0000-0000-0000-000000000000	416	RbugKEbEQIm6v-voFw-vqg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 06:58:56.943781+00	2023-12-19 07:11:56.950582+00	J2HKZGzMxCnxpRZWQ6tHdA	ba214b77-9e60-40e6-b4bb-aec101dd2e45
00000000-0000-0000-0000-000000000000	389	BhD3hKQbQ3UVZsSx5IeI5w	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 00:58:38.188581+00	2023-12-19 01:11:49.081227+00	kiGqQ6IXI6yIhpaB1mnAww	eede4336-98b5-404f-927f-61c48d49dfbd
00000000-0000-0000-0000-000000000000	390	XksJe4VHfx_pZv_Y3ieWtA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 01:11:49.081547+00	2023-12-19 01:25:08.622709+00	BhD3hKQbQ3UVZsSx5IeI5w	eede4336-98b5-404f-927f-61c48d49dfbd
00000000-0000-0000-0000-000000000000	417	6PPu1sspAh8kFu-rzQZf5g	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 07:11:56.950884+00	2023-12-19 07:24:57.029294+00	RbugKEbEQIm6v-voFw-vqg	ba214b77-9e60-40e6-b4bb-aec101dd2e45
00000000-0000-0000-0000-000000000000	391	iXfR6r-S1OD0LUQCdJTI6A	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 01:25:08.623553+00	2023-12-19 01:38:19.174371+00	XksJe4VHfx_pZv_Y3ieWtA	eede4336-98b5-404f-927f-61c48d49dfbd
00000000-0000-0000-0000-000000000000	392	q6IZ6SFVYlBeikUI5Sy_ug	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 01:38:19.17467+00	2023-12-19 01:51:38.520447+00	iXfR6r-S1OD0LUQCdJTI6A	eede4336-98b5-404f-927f-61c48d49dfbd
00000000-0000-0000-0000-000000000000	418	uBKy2UQqFrRIyNrbkiC-TQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 07:24:57.02961+00	2023-12-19 07:38:27.128177+00	6PPu1sspAh8kFu-rzQZf5g	ba214b77-9e60-40e6-b4bb-aec101dd2e45
00000000-0000-0000-0000-000000000000	393	xN-JEQzTz-9NVZ_AAdVo3w	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 01:51:38.522734+00	2023-12-19 02:04:49.200427+00	q6IZ6SFVYlBeikUI5Sy_ug	eede4336-98b5-404f-927f-61c48d49dfbd
00000000-0000-0000-0000-000000000000	394	o9PIRq4nGZ-A2tGPPeQ-Yw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 02:04:49.200729+00	2023-12-19 02:18:19.21819+00	xN-JEQzTz-9NVZ_AAdVo3w	eede4336-98b5-404f-927f-61c48d49dfbd
00000000-0000-0000-0000-000000000000	419	9tdtKl3-CQ4V-pASegFmNg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 07:38:27.128546+00	2023-12-19 07:51:57.097312+00	uBKy2UQqFrRIyNrbkiC-TQ	ba214b77-9e60-40e6-b4bb-aec101dd2e45
00000000-0000-0000-0000-000000000000	395	_80a8kdVCVQcl1zSkXacHA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 02:18:19.218476+00	2023-12-19 02:31:49.294054+00	o9PIRq4nGZ-A2tGPPeQ-Yw	eede4336-98b5-404f-927f-61c48d49dfbd
00000000-0000-0000-0000-000000000000	396	oLoh5gN-o-Wia86nfRoh1Q	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 02:31:49.295828+00	2023-12-19 02:44:49.933601+00	_80a8kdVCVQcl1zSkXacHA	eede4336-98b5-404f-927f-61c48d49dfbd
00000000-0000-0000-0000-000000000000	420	QPUlY_4-X1ThkGywBaJiuw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 07:51:57.097635+00	2023-12-19 08:05:27.070609+00	9tdtKl3-CQ4V-pASegFmNg	ba214b77-9e60-40e6-b4bb-aec101dd2e45
00000000-0000-0000-0000-000000000000	397	5d0S_s_2UysVrbp7P74HGg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 02:44:49.934505+00	2023-12-19 02:57:50.008028+00	oLoh5gN-o-Wia86nfRoh1Q	eede4336-98b5-404f-927f-61c48d49dfbd
00000000-0000-0000-0000-000000000000	398	c33FKqTrZZn51CVdYN43gw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 02:57:50.009831+00	2023-12-19 03:11:19.554853+00	5d0S_s_2UysVrbp7P74HGg	eede4336-98b5-404f-927f-61c48d49dfbd
00000000-0000-0000-0000-000000000000	399	ddw-KQhJu5Kh8qKHUlFFdQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 03:11:19.555834+00	2023-12-19 03:24:20.103114+00	c33FKqTrZZn51CVdYN43gw	eede4336-98b5-404f-927f-61c48d49dfbd
00000000-0000-0000-0000-000000000000	400	WRgzg8QuFwPdRbQQLGyoQw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 03:24:20.104237+00	2023-12-19 03:37:28.982064+00	ddw-KQhJu5Kh8qKHUlFFdQ	eede4336-98b5-404f-927f-61c48d49dfbd
00000000-0000-0000-0000-000000000000	401	64jIwL6tMjtevuwjdL0wYg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 03:37:28.982379+00	2023-12-19 03:50:29.023382+00	WRgzg8QuFwPdRbQQLGyoQw	eede4336-98b5-404f-927f-61c48d49dfbd
00000000-0000-0000-0000-000000000000	402	8F_WY6LbF6KoatkKvxQpIQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 03:50:29.023752+00	2023-12-19 04:03:50.195848+00	64jIwL6tMjtevuwjdL0wYg	eede4336-98b5-404f-927f-61c48d49dfbd
00000000-0000-0000-0000-000000000000	403	_lFv55QZsQuro7nu-jQTaw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 04:03:50.196155+00	2023-12-19 04:16:59.08051+00	8F_WY6LbF6KoatkKvxQpIQ	eede4336-98b5-404f-927f-61c48d49dfbd
00000000-0000-0000-0000-000000000000	404	lOHYwl76L9ogyk6RKivHWQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 04:16:59.080834+00	2023-12-19 04:30:20.244099+00	_lFv55QZsQuro7nu-jQTaw	eede4336-98b5-404f-927f-61c48d49dfbd
00000000-0000-0000-0000-000000000000	405	DnqeW3-QgA3txerVj0ma0Q	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 04:30:20.24451+00	2023-12-19 04:43:29.166987+00	lOHYwl76L9ogyk6RKivHWQ	eede4336-98b5-404f-927f-61c48d49dfbd
00000000-0000-0000-0000-000000000000	421	qVkFbaJMMC3PUTj-RiJMOw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 08:05:27.071008+00	2023-12-19 08:18:57.088815+00	QPUlY_4-X1ThkGywBaJiuw	ba214b77-9e60-40e6-b4bb-aec101dd2e45
00000000-0000-0000-0000-000000000000	422	_uN9_mPeqE_TQo9rD0sWPw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 08:18:57.089173+00	2023-12-19 08:32:27.329294+00	qVkFbaJMMC3PUTj-RiJMOw	ba214b77-9e60-40e6-b4bb-aec101dd2e45
00000000-0000-0000-0000-000000000000	423	-g5UGhT292Jsrj1LiNi2dw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 08:32:27.331803+00	2023-12-19 08:45:57.28934+00	_uN9_mPeqE_TQo9rD0sWPw	ba214b77-9e60-40e6-b4bb-aec101dd2e45
00000000-0000-0000-0000-000000000000	424	z3iqfqcRvtROQMcJuRel0A	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 08:45:57.289702+00	2023-12-19 08:59:27.266283+00	-g5UGhT292Jsrj1LiNi2dw	ba214b77-9e60-40e6-b4bb-aec101dd2e45
00000000-0000-0000-0000-000000000000	425	eiIrSPq9JemsabTmhQqIhQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 08:59:27.266599+00	2023-12-19 09:12:57.230852+00	z3iqfqcRvtROQMcJuRel0A	ba214b77-9e60-40e6-b4bb-aec101dd2e45
00000000-0000-0000-0000-000000000000	426	_6Ov_BB3cZ0n4knGyqx1vQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 09:12:57.23117+00	2023-12-19 09:26:27.27955+00	eiIrSPq9JemsabTmhQqIhQ	ba214b77-9e60-40e6-b4bb-aec101dd2e45
00000000-0000-0000-0000-000000000000	427	VOVUtO96BIXJ2cEs5inhrg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 09:26:27.279931+00	2023-12-19 09:39:57.362991+00	_6Ov_BB3cZ0n4knGyqx1vQ	ba214b77-9e60-40e6-b4bb-aec101dd2e45
00000000-0000-0000-0000-000000000000	428	EJhrnVE4digcsTGV1m9QWQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 09:39:57.363307+00	2023-12-19 09:53:27.393961+00	VOVUtO96BIXJ2cEs5inhrg	ba214b77-9e60-40e6-b4bb-aec101dd2e45
00000000-0000-0000-0000-000000000000	429	iX_IAsHjCPG-7sKqk8Wjrg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 09:53:27.394272+00	2023-12-19 10:06:57.44891+00	EJhrnVE4digcsTGV1m9QWQ	ba214b77-9e60-40e6-b4bb-aec101dd2e45
00000000-0000-0000-0000-000000000000	430	iiQPgXYMv2U7DMmU6OUgmw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 10:06:57.449218+00	2023-12-19 10:20:27.617014+00	iX_IAsHjCPG-7sKqk8Wjrg	ba214b77-9e60-40e6-b4bb-aec101dd2e45
00000000-0000-0000-0000-000000000000	431	DjUAqZ_gSY84hSOtxyIAYg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 10:20:27.617329+00	2023-12-19 10:33:57.623903+00	iiQPgXYMv2U7DMmU6OUgmw	ba214b77-9e60-40e6-b4bb-aec101dd2e45
00000000-0000-0000-0000-000000000000	432	56EbiPKoEJXFjplYjjG4gA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 10:33:57.624197+00	2023-12-19 10:47:27.547217+00	DjUAqZ_gSY84hSOtxyIAYg	ba214b77-9e60-40e6-b4bb-aec101dd2e45
00000000-0000-0000-0000-000000000000	433	x2JD-IyGl6MCfSd5a_7cBw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 10:47:27.547521+00	2023-12-19 11:00:57.60999+00	56EbiPKoEJXFjplYjjG4gA	ba214b77-9e60-40e6-b4bb-aec101dd2e45
00000000-0000-0000-0000-000000000000	434	akm0M9ZRWvM8-O1DKcoMpw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 11:00:57.610285+00	2023-12-19 11:14:27.711707+00	x2JD-IyGl6MCfSd5a_7cBw	ba214b77-9e60-40e6-b4bb-aec101dd2e45
00000000-0000-0000-0000-000000000000	435	Z2cde4NPpolY3xMdUsMXig	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 11:14:27.712005+00	2023-12-19 11:27:57.842712+00	akm0M9ZRWvM8-O1DKcoMpw	ba214b77-9e60-40e6-b4bb-aec101dd2e45
00000000-0000-0000-0000-000000000000	436	EXu-zWxKLr5UNoyte5WBfA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 11:27:57.843055+00	2023-12-19 11:41:27.807881+00	Z2cde4NPpolY3xMdUsMXig	ba214b77-9e60-40e6-b4bb-aec101dd2e45
00000000-0000-0000-0000-000000000000	437	BzmjHolZRUX1n52aJJVMBw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 11:41:27.808202+00	2023-12-19 11:54:57.85009+00	EXu-zWxKLr5UNoyte5WBfA	ba214b77-9e60-40e6-b4bb-aec101dd2e45
00000000-0000-0000-0000-000000000000	438	sLst10cQpTzHYGxEbEJpug	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 11:54:57.850414+00	2023-12-19 12:08:27.941762+00	BzmjHolZRUX1n52aJJVMBw	ba214b77-9e60-40e6-b4bb-aec101dd2e45
00000000-0000-0000-0000-000000000000	439	SpijOp-M10JdV3RlsvNuMw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 12:08:27.942117+00	2023-12-19 12:21:57.836118+00	sLst10cQpTzHYGxEbEJpug	ba214b77-9e60-40e6-b4bb-aec101dd2e45
00000000-0000-0000-0000-000000000000	440	6Y2QnLqGmBnEfSJ7OCVj3w	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 12:21:57.836462+00	2023-12-19 12:35:28.010893+00	SpijOp-M10JdV3RlsvNuMw	ba214b77-9e60-40e6-b4bb-aec101dd2e45
00000000-0000-0000-0000-000000000000	441	X-zPNa2sm7TOUW8vl6iEFA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 12:35:28.011225+00	2023-12-19 12:48:58.179281+00	6Y2QnLqGmBnEfSJ7OCVj3w	ba214b77-9e60-40e6-b4bb-aec101dd2e45
00000000-0000-0000-0000-000000000000	442	8vNOmmIUwhZCmV0aVzkqPQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 12:48:58.179638+00	2023-12-19 14:45:08.639501+00	X-zPNa2sm7TOUW8vl6iEFA	ba214b77-9e60-40e6-b4bb-aec101dd2e45
00000000-0000-0000-0000-000000000000	443	9a01PGhcU-8kPakQM9xz3A	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	f	2023-12-19 14:46:23.084514+00	2023-12-19 14:46:23.084514+00	\N	e0b3d407-a2d3-44ef-aff8-ec38c7753e46
00000000-0000-0000-0000-000000000000	444	jcDcIdVCU27S8cIUupnWaQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 14:47:33.183663+00	2023-12-19 15:00:38.090609+00	\N	6f26c1b0-f37c-4696-8cfb-be1cec797329
00000000-0000-0000-0000-000000000000	445	PfyRybtZ-Kf4bwVf1yjkVg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 15:00:38.090893+00	2023-12-19 15:13:42.064347+00	jcDcIdVCU27S8cIUupnWaQ	6f26c1b0-f37c-4696-8cfb-be1cec797329
00000000-0000-0000-0000-000000000000	446	ceF_vC6rIr85aaYaKhnqbw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 15:13:42.064771+00	2023-12-19 15:53:33.758123+00	PfyRybtZ-Kf4bwVf1yjkVg	6f26c1b0-f37c-4696-8cfb-be1cec797329
00000000-0000-0000-0000-000000000000	447	c4SwufhCnjlb0T249zmR1Q	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 15:53:33.758467+00	2023-12-19 16:06:50.813029+00	ceF_vC6rIr85aaYaKhnqbw	6f26c1b0-f37c-4696-8cfb-be1cec797329
00000000-0000-0000-0000-000000000000	448	-n38CJdoxij6bK8k5oC7PA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 16:06:50.81336+00	2023-12-19 16:20:02.252598+00	c4SwufhCnjlb0T249zmR1Q	6f26c1b0-f37c-4696-8cfb-be1cec797329
00000000-0000-0000-0000-000000000000	449	SNDVQvXAdHANodC6vXYlGg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 16:20:02.252911+00	2023-12-19 16:33:32.253939+00	-n38CJdoxij6bK8k5oC7PA	6f26c1b0-f37c-4696-8cfb-be1cec797329
00000000-0000-0000-0000-000000000000	450	LNt-ukwI9R_IJjZHLoDI0w	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 16:33:32.254312+00	2023-12-19 16:39:29.602034+00	SNDVQvXAdHANodC6vXYlGg	6f26c1b0-f37c-4696-8cfb-be1cec797329
00000000-0000-0000-0000-000000000000	451	yJamGJOvG9iBt0DLlIcUnQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	f	2023-12-19 19:11:46.539199+00	2023-12-19 19:11:46.539199+00	\N	9f1be8d2-db9a-4244-8d98-62ef0cdbb589
00000000-0000-0000-0000-000000000000	452	JFpILao6V2_eEWBalNmf9Q	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 19:15:05.122128+00	2023-12-19 19:28:12.513776+00	\N	29752073-3cf1-4713-9698-013bd2d6982e
00000000-0000-0000-0000-000000000000	453	d7-bTS6pbYZdbbNuRFqXrA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 19:28:12.51411+00	2023-12-19 19:41:21.296615+00	JFpILao6V2_eEWBalNmf9Q	29752073-3cf1-4713-9698-013bd2d6982e
00000000-0000-0000-0000-000000000000	454	pAsgW9xvk6Fz-MhmH24rOQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 19:41:21.296922+00	2023-12-19 19:54:52.667293+00	d7-bTS6pbYZdbbNuRFqXrA	29752073-3cf1-4713-9698-013bd2d6982e
00000000-0000-0000-0000-000000000000	455	LFq_6AMERr-OrRF0lft4fg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 19:54:52.667653+00	2023-12-19 20:08:08.027746+00	pAsgW9xvk6Fz-MhmH24rOQ	29752073-3cf1-4713-9698-013bd2d6982e
00000000-0000-0000-0000-000000000000	456	mfQDD67gyuz5T75ormcrcA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 20:08:08.028067+00	2023-12-19 20:21:38.743456+00	LFq_6AMERr-OrRF0lft4fg	29752073-3cf1-4713-9698-013bd2d6982e
00000000-0000-0000-0000-000000000000	457	nRu6XpMVouS3_4Sc_GtAhQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 20:21:38.743763+00	2023-12-19 20:34:49.480344+00	mfQDD67gyuz5T75ormcrcA	29752073-3cf1-4713-9698-013bd2d6982e
00000000-0000-0000-0000-000000000000	458	nTZrxtUjEms3PFv-HsafqA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 20:34:49.480674+00	2023-12-19 20:48:00.168211+00	nRu6XpMVouS3_4Sc_GtAhQ	29752073-3cf1-4713-9698-013bd2d6982e
00000000-0000-0000-0000-000000000000	459	6iJdLUqXCzxs5PzCcsRE9A	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 20:48:00.168629+00	2023-12-19 21:00:14.334258+00	nTZrxtUjEms3PFv-HsafqA	29752073-3cf1-4713-9698-013bd2d6982e
00000000-0000-0000-0000-000000000000	460	qLEHvRAyQzrS-H66jGt0vA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 21:00:44.483325+00	2023-12-19 21:13:49.449794+00	\N	deaf3216-fb7c-41cc-b908-7b7c826f2929
00000000-0000-0000-0000-000000000000	461	3-Zal06Mhx4bcMGdZHGKFw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 21:13:49.450142+00	2023-12-19 21:27:01.924152+00	qLEHvRAyQzrS-H66jGt0vA	deaf3216-fb7c-41cc-b908-7b7c826f2929
00000000-0000-0000-0000-000000000000	462	M_VAg9-Ve9wCz9eUElXAGw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 21:27:01.924479+00	2023-12-19 21:40:02.292515+00	3-Zal06Mhx4bcMGdZHGKFw	deaf3216-fb7c-41cc-b908-7b7c826f2929
00000000-0000-0000-0000-000000000000	463	toNieSFABXk-MT3IkdJJ3w	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 21:40:02.292831+00	2023-12-19 21:53:32.388828+00	M_VAg9-Ve9wCz9eUElXAGw	deaf3216-fb7c-41cc-b908-7b7c826f2929
00000000-0000-0000-0000-000000000000	464	bjckBbaZvecE30Nzm8cSWg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 21:53:32.389272+00	2023-12-19 22:07:02.345867+00	toNieSFABXk-MT3IkdJJ3w	deaf3216-fb7c-41cc-b908-7b7c826f2929
00000000-0000-0000-0000-000000000000	465	YvZrE7U-gO9juaWWVt8ApA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-19 22:07:02.346183+00	2023-12-19 22:15:01.039374+00	bjckBbaZvecE30Nzm8cSWg	deaf3216-fb7c-41cc-b908-7b7c826f2929
00000000-0000-0000-0000-000000000000	466	T1mL8oP4VeWHTCKmSvBb8Q	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-20 11:50:40.526355+00	2023-12-20 12:03:45.573551+00	\N	946e79ab-b3dc-421b-b4da-c85aabb772f0
00000000-0000-0000-0000-000000000000	467	MacouakIwoy_iHwu7aDXqA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-20 12:03:45.577943+00	2023-12-20 12:16:59.578854+00	T1mL8oP4VeWHTCKmSvBb8Q	946e79ab-b3dc-421b-b4da-c85aabb772f0
00000000-0000-0000-0000-000000000000	468	840BetlCabodNAiAcmucxw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-20 12:16:59.580406+00	2023-12-20 12:29:59.293781+00	MacouakIwoy_iHwu7aDXqA	946e79ab-b3dc-421b-b4da-c85aabb772f0
00000000-0000-0000-0000-000000000000	469	wM4I5wrPbO790kgg_4sxgQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-20 12:29:59.294785+00	2023-12-20 12:42:59.640819+00	840BetlCabodNAiAcmucxw	946e79ab-b3dc-421b-b4da-c85aabb772f0
00000000-0000-0000-0000-000000000000	470	H4QL3QwB0WX_hA-uW5xwoA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-20 12:42:59.641529+00	2023-12-20 12:45:22.869624+00	wM4I5wrPbO790kgg_4sxgQ	946e79ab-b3dc-421b-b4da-c85aabb772f0
00000000-0000-0000-0000-000000000000	471	I_7VIRjJsmHiIYmYU3pCGQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-20 14:53:49.485457+00	2023-12-20 15:06:55.126364+00	\N	ec442ecd-1e46-4dd3-8ceb-e8b6e12930a5
00000000-0000-0000-0000-000000000000	472	xXzMMBLTKiuZZCxWytU8iw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-20 15:06:55.127282+00	2023-12-20 15:19:57.435834+00	I_7VIRjJsmHiIYmYU3pCGQ	ec442ecd-1e46-4dd3-8ceb-e8b6e12930a5
00000000-0000-0000-0000-000000000000	473	flwiTkFqmFCqKRDu_vmxaQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-20 15:19:57.437123+00	2023-12-20 15:24:54.238311+00	xXzMMBLTKiuZZCxWytU8iw	ec442ecd-1e46-4dd3-8ceb-e8b6e12930a5
00000000-0000-0000-0000-000000000000	474	UYUa1eLvEbrGJhRpxTxGTw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-20 15:31:21.147142+00	2023-12-20 15:44:26.04385+00	\N	5956bfc6-bb95-49e8-97f9-08bd727dd997
00000000-0000-0000-0000-000000000000	475	Cet1G-j2fJb9XWLAOOuqIw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-20 15:44:26.044669+00	2023-12-20 15:57:27.832111+00	UYUa1eLvEbrGJhRpxTxGTw	5956bfc6-bb95-49e8-97f9-08bd727dd997
00000000-0000-0000-0000-000000000000	476	iro1f7vNw125faXXhf2j_A	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-20 15:57:27.832411+00	2023-12-20 16:10:28.117821+00	Cet1G-j2fJb9XWLAOOuqIw	5956bfc6-bb95-49e8-97f9-08bd727dd997
00000000-0000-0000-0000-000000000000	477	kr4KRupBFbouoXoJAuhAXw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-20 16:10:28.118153+00	2023-12-20 16:23:57.858517+00	iro1f7vNw125faXXhf2j_A	5956bfc6-bb95-49e8-97f9-08bd727dd997
00000000-0000-0000-0000-000000000000	478	DK0o2EWSjwxpSkvJVJqs3Q	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-20 16:23:57.858836+00	2023-12-20 16:36:57.908061+00	kr4KRupBFbouoXoJAuhAXw	5956bfc6-bb95-49e8-97f9-08bd727dd997
00000000-0000-0000-0000-000000000000	479	5hE_TiUaCJxvQ5YmHsZRIQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-20 16:36:57.908396+00	2023-12-20 16:49:57.945872+00	DK0o2EWSjwxpSkvJVJqs3Q	5956bfc6-bb95-49e8-97f9-08bd727dd997
00000000-0000-0000-0000-000000000000	480	XP5xcRYg5BXvtBvJgA0C7Q	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-20 16:49:57.946203+00	2023-12-20 17:02:57.959409+00	5hE_TiUaCJxvQ5YmHsZRIQ	5956bfc6-bb95-49e8-97f9-08bd727dd997
00000000-0000-0000-0000-000000000000	481	v2VpU1ZRD5FIKryqvkOnkw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-20 17:02:57.960837+00	2023-12-20 17:15:58.331251+00	XP5xcRYg5BXvtBvJgA0C7Q	5956bfc6-bb95-49e8-97f9-08bd727dd997
00000000-0000-0000-0000-000000000000	482	6TDBoAcYFBrK6aO-uJaFlw	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-20 17:15:58.333557+00	2023-12-20 17:29:28.042356+00	v2VpU1ZRD5FIKryqvkOnkw	5956bfc6-bb95-49e8-97f9-08bd727dd997
00000000-0000-0000-0000-000000000000	483	sx_UtFErsfVHLx0wjhKCUg	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-20 17:29:28.043359+00	2023-12-20 17:42:56.359945+00	6TDBoAcYFBrK6aO-uJaFlw	5956bfc6-bb95-49e8-97f9-08bd727dd997
00000000-0000-0000-0000-000000000000	484	n9Ku71Zu8_YqGCWxROKcow	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-20 17:42:56.360331+00	2023-12-20 17:55:56.369294+00	sx_UtFErsfVHLx0wjhKCUg	5956bfc6-bb95-49e8-97f9-08bd727dd997
00000000-0000-0000-0000-000000000000	485	wGTbdxIx60YtGU58_RKmpA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-20 17:55:56.370473+00	2023-12-20 18:08:56.393207+00	n9Ku71Zu8_YqGCWxROKcow	5956bfc6-bb95-49e8-97f9-08bd727dd997
00000000-0000-0000-0000-000000000000	486	0B06iFaBuIRfZHbLfxEJlA	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-20 18:08:56.394005+00	2023-12-20 18:21:56.757312+00	wGTbdxIx60YtGU58_RKmpA	5956bfc6-bb95-49e8-97f9-08bd727dd997
00000000-0000-0000-0000-000000000000	487	QHV6RtIHZkg1x6Dt20SDzQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	t	2023-12-20 18:21:56.75763+00	2023-12-20 18:25:17.965502+00	0B06iFaBuIRfZHbLfxEJlA	5956bfc6-bb95-49e8-97f9-08bd727dd997
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
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sessions (id, user_id, created_at, updated_at, factor_id, aal, not_after, refreshed_at, user_agent, ip, tag) FROM stdin;
e0b3d407-a2d3-44ef-aff8-ec38c7753e46	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	2023-12-19 14:46:23.083719+00	2023-12-19 14:46:23.083719+00	\N	aal1	\N	\N	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/118.0.0.0 Safari/537.36	94.25.187.158	\N
2746d270-873f-483b-8db4-1463e50c336d	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	2023-12-13 15:28:48.844754+00	2023-12-13 16:48:45.812337+00	\N	aal1	\N	2023-12-13 16:48:45.812262	Deno/1.38.4	94.25.187.158	\N
400376ed-2a52-4c6c-bd41-3e0535fd86d5	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	2023-12-11 20:49:56.230363+00	2023-12-11 22:10:10.011656+00	\N	aal1	\N	2023-12-11 22:10:10.011568	Deno/1.38.4	94.25.187.158	\N
eede4336-98b5-404f-927f-61c48d49dfbd	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	2023-12-18 16:45:54.110745+00	2023-12-19 04:47:08.529806+00	\N	aal1	\N	2023-12-19 04:47:08.529729	Deno/1.38.4	94.25.187.158	\N
deaf3216-fb7c-41cc-b908-7b7c826f2929	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	2023-12-19 21:00:44.482475+00	2023-12-19 22:07:02.347836+00	\N	aal1	\N	2023-12-19 22:07:02.347766	Deno/1.38.4	94.25.187.158	\N
73ca2c05-c30d-41a9-a3ca-0e0398e66175	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	2023-12-16 15:35:40.312985+00	2023-12-18 16:40:05.923945+00	\N	aal1	\N	2023-12-18 16:40:05.923868	Deno/1.38.4	94.25.187.158	\N
6f26c1b0-f37c-4696-8cfb-be1cec797329	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	2023-12-19 14:47:33.182859+00	2023-12-19 16:33:32.256169+00	\N	aal1	\N	2023-12-19 16:33:32.256096	Deno/1.38.4	94.25.187.158	\N
9f1be8d2-db9a-4244-8d98-62ef0cdbb589	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	2023-12-19 19:11:46.538513+00	2023-12-19 19:11:46.538513+00	\N	aal1	\N	\N	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/118.0.0.0 Safari/537.36	94.25.187.158	\N
5956bfc6-bb95-49e8-97f9-08bd727dd997	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	2023-12-20 15:31:21.14649+00	2023-12-20 18:22:58.163558+00	\N	aal1	\N	2023-12-20 18:22:58.163483	Deno/1.38.4	94.25.187.158	\N
b6672a79-7255-44ba-92a3-40b84de08b3e	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	2023-12-15 20:33:09.6014+00	2023-12-16 15:11:59.871459+00	\N	aal1	\N	2023-12-16 15:11:59.871382	Deno/1.38.4	94.25.187.158	\N
90056874-e87c-4138-b381-d2b3ae119816	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	2023-12-14 12:19:33.315826+00	2023-12-14 17:14:40.265963+00	\N	aal1	\N	2023-12-14 17:14:40.265892	Deno/1.38.4	94.25.187.158	\N
6833ddc7-223d-4093-ad07-559f00b07419	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	2023-12-02 19:58:46.128371+00	2023-12-06 14:16:01.286879+00	\N	aal1	\N	2023-12-06 14:16:01.28681	Deno/1.38.4	94.25.187.158	\N
810df881-05f6-4234-a115-23a34045ebfb	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	2023-12-08 23:55:03.711848+00	2023-12-09 00:21:41.077088+00	\N	aal1	\N	2023-12-09 00:21:41.077018	Deno/1.38.4	94.25.187.158	\N
b293f801-2282-4755-9e10-e5e8e1f8a21c	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	2023-12-11 23:41:06.790021+00	2023-12-13 15:10:57.449921+00	\N	aal1	\N	2023-12-13 15:10:57.449843	Deno/1.38.4	94.25.187.158	\N
98e8b0f3-7942-4c17-9d87-7bebc75a3631	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	2023-12-15 16:35:22.012435+00	2023-12-15 20:23:55.623473+00	\N	aal1	\N	2023-12-15 20:23:55.623399	Deno/1.38.4	94.25.187.158	\N
5bba6304-8a77-4f59-9c0c-c00a6fd7ce91	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	2023-12-09 02:11:26.256446+00	2023-12-11 20:33:32.182353+00	\N	aal1	\N	2023-12-11 20:33:32.18228	Deno/1.38.4	94.25.187.158	\N
304ff5a0-aa7f-4be0-948a-574dfe3aab41	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	2023-12-11 20:47:32.716261+00	2023-12-11 20:47:32.716261+00	\N	aal1	\N	\N	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/118.0.0.0 Safari/537.36	94.25.187.158	\N
ed5401e1-9fd8-4304-b6ed-21129e618e6b	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	2023-12-15 15:12:41.319869+00	2023-12-15 16:32:10.842692+00	\N	aal1	\N	2023-12-15 16:32:10.842622	Deno/1.38.4	94.25.187.158	\N
73a4d827-c6ea-4ba4-b341-601f97c11793	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	2023-12-15 16:34:01.759597+00	2023-12-15 16:34:01.759597+00	\N	aal1	\N	\N	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/118.0.0.0 Safari/537.36	94.25.187.158	\N
29752073-3cf1-4713-9698-013bd2d6982e	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	2023-12-19 19:15:05.121435+00	2023-12-19 20:48:38.166282+00	\N	aal1	\N	2023-12-19 20:48:38.166205	Deno/1.38.4	94.25.187.158	\N
946e79ab-b3dc-421b-b4da-c85aabb772f0	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	2023-12-20 11:50:40.524625+00	2023-12-20 12:43:31.764655+00	\N	aal1	\N	2023-12-20 12:43:31.764574	Deno/1.38.4	94.25.187.158	\N
ec442ecd-1e46-4dd3-8ceb-e8b6e12930a5	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	2023-12-20 14:53:49.484797+00	2023-12-20 15:20:24.686477+00	\N	aal1	\N	2023-12-20 15:20:24.686404	Deno/1.38.4	94.25.187.158	\N
ba214b77-9e60-40e6-b4bb-aec101dd2e45	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	2023-12-19 04:51:10.849971+00	2023-12-19 12:48:58.181591+00	\N	aal1	\N	2023-12-19 12:48:58.181518	Deno/1.38.4	94.25.187.158	\N
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
00000000-0000-0000-0000-000000000000	e76b244b-6f9e-42fc-b216-5ea74f94bd4c	authenticated	authenticated	gavriillarin263@inbox.lv	$2a$10$W8/g0R7arxlSsdWrn.5hXOqbolOsyQrpCcAKTOEkoIy2Vekr3vgSS	2023-12-09 05:25:02.817+00	\N		2023-12-09 05:24:14.076+00		\N			\N	2023-12-09 05:25:02.818+00	{"provider": "email", "providers": ["email"], "profile_id": 19}	\N	\N	2023-12-09 05:24:14.065+00	2023-12-09 05:25:02.819+00	\N	\N			\N		0	\N		\N	f	\N
00000000-0000-0000-0000-000000000000	727a5d27-4b66-49ea-a2c1-0bccc7b8e2cd	authenticated	authenticated	d9k@ya.tu	$2a$10$OR4GYiMa8vFpk1ywBfPrEeL8yj0TCJxO3joYXdlRezx8Kk6eBjmQ.	\N	\N	45bc98dfe84800707f48a82df0ce417215a7869ba20ba657b46012c1	2023-12-11 20:49:26.158057+00		\N			\N	\N	{"provider": "email", "providers": ["email"], "profile_id": 20}	{}	\N	2023-12-11 20:49:26.145323+00	2023-12-11 20:49:29.413083+00	\N	\N			\N		0	\N		\N	f	\N
00000000-0000-0000-0000-000000000000	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	authenticated	authenticated	d9k@ya.ru	$2a$10$BNL19FnvkC6EyYVshokk.e1R3HwylfiHqAp/PEtQY49PgNHxf0Nk2	2023-11-30 13:20:52.160287+00	\N		2023-11-30 13:19:57.235919+00	7f2a29538ce79186b557bd4686ded17471e6b935ec14af97e76550c6	2023-12-20 18:26:02.177042+00			\N	2023-12-20 15:31:21.146419+00	{"provider": "email", "providers": ["email"], "profile_id": 1}	{}	\N	2023-11-30 13:19:57.22183+00	2023-12-20 18:26:04.847678+00	\N	\N			\N		0	\N		\N	f	\N
\.


--
-- Data for Name: key; Type: TABLE DATA; Schema: pgsodium; Owner: supabase_admin
--

COPY pgsodium.key (id, status, created, expires, key_type, key_id, key_context, name, associated_data, raw_key, raw_key_nonce, parent_key, comment, user_data) FROM stdin;
\.


--
-- Data for Name: authors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.authors (id, lastname_name_patronymic, created_at, birth_year, death_year, approximate_years, updated_at, birth_town) FROM stdin;
\.


--
-- Data for Name: citations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.citations (id, english_text, author_id, year, created_at, updated_at, original_language_text, place_id, event_id) FROM stdin;
\.


--
-- Data for Name: countries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.countries (id, name, created_at, updated_at, found_year, next_rename_year, created_by, updated_by) FROM stdin;
1	Greece 1	2023-11-28 06:50:37.146622+00	2023-11-28 06:50:37.146622+00	-4000	100	\N	\N
2	Greece	2023-12-19 21:09:32.167558+00	2023-12-19 21:09:32.167558+00	-4005	100	\N	\N
7	Arztocka	2023-12-20 15:31:38.442098+00	2023-12-20 15:45:21.578367+00	\N	\N	1	1
\.


--
-- Data for Name: event; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.event (id, name, created_at, updated_at, start_year, start_month, end_year, end_month, place_id) FROM stdin;
\.


--
-- Data for Name: place; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.place (id, name, created_at, updated_at, town_id) FROM stdin;
\.


--
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.profiles (auth_user_id, updated_at, username, full_name, avatar_url, website, id) FROM stdin;
b5f563a3-b794-49d0-a0e3-dbf9fffd2321	\N	\N	\N	\N	\N	1
e76b244b-6f9e-42fc-b216-5ea74f94bd4c	\N	\N	\N	\N	\N	19
727a5d27-4b66-49ea-a2c1-0bccc7b8e2cd	\N	\N	\N	\N	\N	20
\.


--
-- Data for Name: town; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.town (id, name, created_at, updated_at, country_id) FROM stdin;
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
\.


--
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: supabase_admin
--

COPY vault.secrets (id, name, description, secret, key_id, nonce, created_at, updated_at) FROM stdin;
\.


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 487, true);


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

SELECT pg_catalog.setval('public.country_id_seq', 7, true);


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

SELECT pg_catalog.setval('public.profiles_id_seq', 20, true);


--
-- Name: town_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.town_id_seq', 1, false);


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
-- Name: countries country_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT country_pkey PRIMARY KEY (id);


--
-- Name: event event_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event
    ADD CONSTRAINT event_pkey PRIMARY KEY (id);


--
-- Name: place place_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.place
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
-- Name: town town_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.town
    ADD CONSTRAINT town_pkey PRIMARY KEY (id);


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
-- Name: countries on_country_edit_fill_update; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER on_country_edit_fill_update BEFORE UPDATE ON public.countries FOR EACH ROW EXECUTE FUNCTION public.handle_fill_updated();


--
-- Name: countries on_country_new_fill_created_by; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER on_country_new_fill_created_by BEFORE INSERT ON public.countries FOR EACH ROW EXECUTE FUNCTION public.handle_fill_created_by();


--
-- Name: profiles on_public_profiles_new; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER on_public_profiles_new AFTER INSERT ON public.profiles FOR EACH ROW EXECUTE FUNCTION public.handle_public_profile_new();


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
    ADD CONSTRAINT authors_birth_town_fkey FOREIGN KEY (birth_town) REFERENCES public.town(id) ON UPDATE CASCADE;


--
-- Name: citations citations_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.citations
    ADD CONSTRAINT citations_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.authors(id) ON UPDATE CASCADE;


--
-- Name: citations citations_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.citations
    ADD CONSTRAINT citations_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.event(id) ON UPDATE CASCADE;


--
-- Name: citations citations_place_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.citations
    ADD CONSTRAINT citations_place_id_fkey FOREIGN KEY (place_id) REFERENCES public.place(id);


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
-- Name: event event_place_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event
    ADD CONSTRAINT event_place_id_fkey FOREIGN KEY (place_id) REFERENCES public.place(id) ON UPDATE CASCADE;


--
-- Name: place place_town_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.place
    ADD CONSTRAINT place_town_id_fkey FOREIGN KEY (town_id) REFERENCES public.town(id) ON UPDATE CASCADE;


--
-- Name: profiles profiles_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_id_fkey FOREIGN KEY (auth_user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: town town_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.town
    ADD CONSTRAINT town_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.countries(id) ON UPDATE CASCADE;


--
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: profiles Public profiles are viewable by everyone.; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Public profiles are viewable by everyone." ON public.profiles FOR SELECT USING (true);


--
-- Name: profiles Users can insert their own profile.; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can insert their own profile." ON public.profiles FOR INSERT WITH CHECK ((auth.uid() = auth_user_id));


--
-- Name: profiles Users can update own profile.; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can update own profile." ON public.profiles FOR UPDATE USING ((auth.uid() = auth_user_id));


--
-- Name: countries; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.countries ENABLE ROW LEVEL SECURITY;

--
-- Name: countries countries: authed can all; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "countries: authed can all" ON public.countries TO authenticated USING (true) WITH CHECK (true);


--
-- Name: profiles; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

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
-- Name: FUNCTION set_claim(uid uuid, claim text, value jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.set_claim(uid uuid, claim text, value jsonb) TO anon;
GRANT ALL ON FUNCTION public.set_claim(uid uuid, claim text, value jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.set_claim(uid uuid, claim text, value jsonb) TO service_role;


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
-- Name: TABLE authors; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.authors TO anon;
GRANT ALL ON TABLE public.authors TO authenticated;
GRANT ALL ON TABLE public.authors TO service_role;


--
-- Name: SEQUENCE author_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.author_id_seq TO anon;
GRANT ALL ON SEQUENCE public.author_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.author_id_seq TO service_role;


--
-- Name: TABLE citations; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.citations TO anon;
GRANT ALL ON TABLE public.citations TO authenticated;
GRANT ALL ON TABLE public.citations TO service_role;


--
-- Name: SEQUENCE citations_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.citations_id_seq TO anon;
GRANT ALL ON SEQUENCE public.citations_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.citations_id_seq TO service_role;


--
-- Name: TABLE countries; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.countries TO anon;
GRANT ALL ON TABLE public.countries TO authenticated;
GRANT ALL ON TABLE public.countries TO service_role;


--
-- Name: SEQUENCE country_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.country_id_seq TO anon;
GRANT ALL ON SEQUENCE public.country_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.country_id_seq TO service_role;


--
-- Name: TABLE event; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.event TO anon;
GRANT ALL ON TABLE public.event TO authenticated;
GRANT ALL ON TABLE public.event TO service_role;


--
-- Name: SEQUENCE event_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.event_id_seq TO anon;
GRANT ALL ON SEQUENCE public.event_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.event_id_seq TO service_role;


--
-- Name: TABLE place; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.place TO anon;
GRANT ALL ON TABLE public.place TO authenticated;
GRANT ALL ON TABLE public.place TO service_role;


--
-- Name: SEQUENCE place_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.place_id_seq TO anon;
GRANT ALL ON SEQUENCE public.place_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.place_id_seq TO service_role;


--
-- Name: TABLE profiles; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.profiles TO anon;
GRANT ALL ON TABLE public.profiles TO authenticated;
GRANT ALL ON TABLE public.profiles TO service_role;


--
-- Name: SEQUENCE profiles_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.profiles_id_seq TO anon;
GRANT ALL ON SEQUENCE public.profiles_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.profiles_id_seq TO service_role;


--
-- Name: TABLE town; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.town TO anon;
GRANT ALL ON TABLE public.town TO authenticated;
GRANT ALL ON TABLE public.town TO service_role;


--
-- Name: SEQUENCE town_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.town_id_seq TO anon;
GRANT ALL ON SEQUENCE public.town_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.town_id_seq TO service_role;


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

