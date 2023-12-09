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
    name text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now(),
    found_year bigint,
    next_rename_year bigint
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
00000000-0000-0000-0000-000000000000	bdc9abf3-180d-440a-9ab2-0efce35b7276	{"action":"user_recovery_requested","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"user"}	2023-12-02 06:50:14.0261+00	
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
00000000-0000-0000-0000-000000000000	dfc691df-a841-49d6-b85d-f4ba1599e34a	{"action":"user_recovery_requested","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"user"}	2023-12-02 08:00:59.504685+00	
00000000-0000-0000-0000-000000000000	f5ede003-216d-4e04-ae4a-00b1c3297b84	{"action":"user_recovery_requested","actor_id":"b5f563a3-b794-49d0-a0e3-dbf9fffd2321","actor_username":"d9k@ya.ru","actor_via_sso":false,"log_type":"user"}	2023-12-02 08:04:46.20832+00	
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
00000000-0000-0000-0000-000000000000	181	psgCYW6tHJYZlyCtBopQGQ	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	f	2023-12-09 02:11:26.257194+00	2023-12-09 02:11:26.257194+00	\N	5bba6304-8a77-4f59-9c0c-c00a6fd7ce91
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
6833ddc7-223d-4093-ad07-559f00b07419	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	2023-12-02 19:58:46.128371+00	2023-12-06 14:16:01.286879+00	\N	aal1	\N	2023-12-06 14:16:01.28681	Deno/1.38.4	94.25.187.158	\N
810df881-05f6-4234-a115-23a34045ebfb	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	2023-12-08 23:55:03.711848+00	2023-12-09 00:21:41.077088+00	\N	aal1	\N	2023-12-09 00:21:41.077018	Deno/1.38.4	94.25.187.158	\N
5bba6304-8a77-4f59-9c0c-c00a6fd7ce91	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	2023-12-09 02:11:26.256446+00	2023-12-09 02:11:26.256446+00	\N	aal1	\N	\N	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/118.0.0.0 Safari/537.36	94.25.187.158	\N
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
00000000-0000-0000-0000-000000000000	b5f563a3-b794-49d0-a0e3-dbf9fffd2321	authenticated	authenticated	d9k@ya.ru	$2a$10$BNL19FnvkC6EyYVshokk.e1R3HwylfiHqAp/PEtQY49PgNHxf0Nk2	2023-11-30 13:20:52.160287+00	\N		2023-11-30 13:19:57.235919+00		2023-12-09 02:11:13.105958+00			\N	2023-12-09 02:11:26.256371+00	{"provider": "email", "providers": ["email"], "profile_id": 1}	{}	\N	2023-11-30 13:19:57.22183+00	2023-12-09 02:11:26.26131+00	\N	\N			\N		0	\N		\N	f	\N
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

COPY public.countries (id, name, created_at, updated_at, found_year, next_rename_year) FROM stdin;
1	Greece	2023-11-28 06:50:37.146622+00	2023-11-28 06:50:37.146622+00	\N	\N
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

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 181, true);


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

SELECT pg_catalog.setval('public.country_id_seq', 1, true);


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

SELECT pg_catalog.setval('public.profiles_id_seq', 19, true);


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
-- Name: countries countries: authed can read; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "countries: authed can read" ON public.countries FOR SELECT TO authenticated USING (true);


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

