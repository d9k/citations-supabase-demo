-- WARNING: DATA LOSS!
--
-- Why singular names?
-- - good for ORM, ERD
-- - PSQL functions arguments types
-- - More readable SQL queries: https://stackoverflow.com/a/716269

drop trigger if exists "on_authors_edit_fill_update" on "public"."authors";

drop trigger if exists "on_authors_new_fill_created_by" on "public"."authors";

drop trigger if exists "on_citations_edit_fill_update" on "public"."citations";

drop trigger if exists "on_citations_new_fill_created_by" on "public"."citations";

drop trigger if exists "on_country_edit_fill_update" on "public"."countries";

drop trigger if exists "on_country_new_fill_created_by" on "public"."countries";

drop trigger if exists "on_events_edit_fill_update" on "public"."events";

drop trigger if exists "on_events_new_fill_created_by" on "public"."events";

drop trigger if exists "on_places_edit_fill_update" on "public"."places";

drop trigger if exists "on_places_new_fill_created_by" on "public"."places";

drop trigger if exists "on_public_profiles_new" on "public"."profiles";

drop trigger if exists "on_towns_edit_fill_update" on "public"."towns";

drop trigger if exists "on_towns_new_fill_created_by" on "public"."towns";

drop policy "RLS: authors: delete" on "public"."authors";

drop policy "RLS: authors: insert" on "public"."authors";

drop policy "RLS: authors: select" on "public"."authors";

drop policy "RLS: authors: update" on "public"."authors";

drop policy "RLS: citations: delete" on "public"."citations";

drop policy "RLS: citations: insert" on "public"."citations";

drop policy "RLS: citations: select" on "public"."citations";

drop policy "RLS: citations: update" on "public"."citations";

drop policy "RLS: countries: delete" on "public"."countries";

drop policy "RLS: countries: insert" on "public"."countries";

drop policy "RLS: countries: select" on "public"."countries";

drop policy "RLS: countries: update" on "public"."countries";

drop policy "RLS: events: delete" on "public"."events";

drop policy "RLS: events: insert" on "public"."events";

drop policy "RLS: events: select" on "public"."events";

drop policy "RLS: events: update" on "public"."events";

drop policy "RLS: places: delete" on "public"."places";

drop policy "RLS: places: insert" on "public"."places";

drop policy "RLS: places: select" on "public"."places";

drop policy "RLS: places: update" on "public"."places";

drop policy " RLS: profiles: insert" on "public"."profiles";

drop policy " RLS: profiles: update" on "public"."profiles";

drop policy "RLS: profiles: select" on "public"."profiles";

drop policy "RLS: towns: delete" on "public"."towns";

drop policy "RLS: towns: insert" on "public"."towns";

drop policy "RLS: towns: select" on "public"."towns";

drop policy "RLS: towns: update" on "public"."towns";

drop policy "RLS: trusts: delete" on "public"."trusts";

drop policy "RLS: trusts: insert" on "public"."trusts";

drop policy "RLS: trusts: select" on "public"."trusts";

drop policy "RLS: trusts: update" on "public"."trusts";

alter table "public"."authors" drop constraint "authors_birth_town_fkey";

alter table "public"."authors" drop constraint "authors_created_by_fkey";

alter table "public"."authors" drop constraint "authors_updated_by_fkey";

alter table "public"."citations" drop constraint "citations_author_id_fkey";

alter table "public"."citations" drop constraint "citations_created_by_fkey";

alter table "public"."citations" drop constraint "citations_event_id_fkey";

alter table "public"."citations" drop constraint "citations_place_id_fkey";

alter table "public"."citations" drop constraint "citations_updated_by_fkey";

alter table "public"."countries" drop constraint "countries_created_by_fkey";

alter table "public"."countries" drop constraint "countries_name_check";

alter table "public"."countries" drop constraint "countries_name_key";

alter table "public"."countries" drop constraint "countries_updated_by_fkey";

alter table "public"."events" drop constraint "events_created_by_fkey";

alter table "public"."events" drop constraint "events_place_id_fkey";

alter table "public"."events" drop constraint "events_updated_by_fkey";

alter table "public"."places" drop constraint "places_created_by_fkey";

alter table "public"."places" drop constraint "places_town_id_fkey";

alter table "public"."places" drop constraint "places_updated_by_fkey";

alter table "public"."profiles" drop constraint "profiles_id_fkey";

alter table "public"."profiles" drop constraint "profiles_username_key";

alter table "public"."profiles" drop constraint "username_length";

alter table "public"."towns" drop constraint "towns_country_id_fkey";

alter table "public"."towns" drop constraint "towns_created_by_fkey";

alter table "public"."towns" drop constraint "towns_name_check";

alter table "public"."towns" drop constraint "towns_updated_by_fkey";

drop function if exists "public"."rls_profiles_edit"(records profiles[]);

drop view if exists "public"."view_id_name";

drop view if exists "public"."view_rls_edit_for_table";

drop function if exists "public"."rls_authors_delete"(record authors);

drop function if exists "public"."rls_authors_edit"(record authors);

drop function if exists "public"."rls_citations_delete"(record citations);

drop function if exists "public"."rls_citations_edit"(record citations);

drop function if exists "public"."rls_countries_delete"(record countries);

drop function if exists "public"."rls_countries_edit"(record countries);

drop function if exists "public"."rls_events_delete"(record events);

drop function if exists "public"."rls_events_edit"(record events);

drop function if exists "public"."rls_places_delete"(record places);

drop function if exists "public"."rls_places_edit"(record places);

drop function if exists "public"."rls_profiles_edit"(record profiles);

drop function if exists "public"."rls_towns_delete"(record towns);

drop function if exists "public"."rls_towns_edit"(record towns);

drop function if exists "public"."rls_trusts_edit"(record trusts);

alter table "public"."authors" drop constraint "author_pkey";

alter table "public"."citations" drop constraint "citations_pkey";

alter table "public"."countries" drop constraint "country_pkey";

alter table "public"."events" drop constraint "event_pkey";

alter table "public"."places" drop constraint "place_pkey";

alter table "public"."profiles" drop constraint "profiles_pkey";

alter table "public"."towns" drop constraint "town_pkey";

alter table "public"."trusts" drop constraint "trusts_pkey";

drop index if exists "public"."author_pkey";

drop index if exists "public"."citations_pkey";

drop index if exists "public"."countries_name_key";

drop index if exists "public"."country_pkey";

drop index if exists "public"."event_pkey";

drop index if exists "public"."place_pkey";

drop index if exists "public"."profiles_pkey";

drop index if exists "public"."profiles_username_key";

drop index if exists "public"."town_pkey";

drop index if exists "public"."trusts_pkey";

drop table "public"."authors";

drop table "public"."citations";

drop table "public"."countries";

drop table "public"."events";

drop table "public"."places";

drop table "public"."profiles";

drop table "public"."towns";

drop table "public"."trusts";

create table "public"."author" (
    "id" bigint generated by default as identity not null,
    "lastname_name_patronymic" text not null,
    "created_at" timestamp with time zone not null default now(),
    "birth_year" bigint,
    "death_year" bigint,
    "approximate_years" boolean not null default false,
    "updated_at" timestamp with time zone not null default now(),
    "birth_town" bigint,
    "created_by" bigint,
    "updated_by" bigint
);


alter table "public"."author" enable row level security;

create table "public"."citation" (
    "id" bigint generated by default as identity not null,
    "english_text" text,
    "author_id" bigint not null,
    "year" bigint,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp without time zone not null default now(),
    "original_language_text" text,
    "place_id" bigint,
    "event_id" bigint,
    "created_by" bigint,
    "updated_by" bigint
);


alter table "public"."citation" enable row level security;

create table "public"."content_item" (
    "table_name" text not null,
    "id" bigint not null,
    "created_at" timestamp with time zone not null default now(),
    "created_by" bigint,
    "updated_at" timestamp with time zone,
    "updated_by" bigint,
    "published_at" timestamp with time zone,
    "published_by" bigint,
    "unpublished_at" timestamp with time zone,
    "unpublished_by" bigint
);


create table "public"."country" (
    "id" bigint generated by default as identity not null,
    "name" text not null default ''::text,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone default now(),
    "found_year" bigint,
    "next_rename_year" bigint,
    "created_by" bigint,
    "updated_by" bigint
);


alter table "public"."country" enable row level security;

create table "public"."event" (
    "id" bigint generated by default as identity not null,
    "name" text not null,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now(),
    "start_year" bigint not null,
    "start_month" smallint not null,
    "end_year" bigint,
    "end_month" smallint,
    "place_id" bigint,
    "created_by" bigint,
    "updated_by" bigint
);


alter table "public"."event" enable row level security;

create table "public"."place" (
    "id" bigint generated by default as identity not null,
    "name" text not null default 'in'::text,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now(),
    "town_id" bigint not null,
    "created_by" bigint,
    "updated_by" bigint
);


alter table "public"."place" enable row level security;

create table "public"."profile" (
    "auth_user_id" uuid not null,
    "updated_at" timestamp with time zone,
    "username" text,
    "full_name" text,
    "avatar_url" text,
    "website" text,
    "id" bigint generated by default as identity not null,
    "created_at" timestamp with time zone default now()
);


alter table "public"."profile" enable row level security;

create table "public"."town" (
    "id" bigint generated by default as identity not null,
    "name" text not null,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now(),
    "country_id" bigint not null,
    "created_by" bigint,
    "updated_by" bigint
);


alter table "public"."town" enable row level security;

create table "public"."trust" (
    "id" bigint generated by default as identity not null,
    "who" bigint not null,
    "trusts_whom" bigint not null,
    "end_at" timestamp with time zone not null default (now() + '1 day'::interval)
);


alter table "public"."trust" enable row level security;

CREATE UNIQUE INDEX content_item_pkey ON public.content_item USING btree (table_name, id);

CREATE UNIQUE INDEX author_pkey ON public.author USING btree (id);

CREATE UNIQUE INDEX citations_pkey ON public.citation USING btree (id);

CREATE UNIQUE INDEX countries_name_key ON public.country USING btree (name);

CREATE UNIQUE INDEX country_pkey ON public.country USING btree (id);

CREATE UNIQUE INDEX event_pkey ON public.event USING btree (id);

CREATE UNIQUE INDEX place_pkey ON public.place USING btree (id);

CREATE UNIQUE INDEX profiles_pkey ON public.profile USING btree (id);

CREATE UNIQUE INDEX profiles_username_key ON public.profile USING btree (username);

CREATE UNIQUE INDEX town_pkey ON public.town USING btree (id);

CREATE UNIQUE INDEX trusts_pkey ON public.trust USING btree (id);

alter table "public"."author" add constraint "author_pkey" PRIMARY KEY using index "author_pkey";

alter table "public"."citation" add constraint "citations_pkey" PRIMARY KEY using index "citations_pkey";

alter table "public"."content_item" add constraint "content_item_pkey" PRIMARY KEY using index "content_item_pkey";

alter table "public"."country" add constraint "country_pkey" PRIMARY KEY using index "country_pkey";

alter table "public"."event" add constraint "event_pkey" PRIMARY KEY using index "event_pkey";

alter table "public"."place" add constraint "place_pkey" PRIMARY KEY using index "place_pkey";

alter table "public"."profile" add constraint "profiles_pkey" PRIMARY KEY using index "profiles_pkey";

alter table "public"."town" add constraint "town_pkey" PRIMARY KEY using index "town_pkey";

alter table "public"."trust" add constraint "trusts_pkey" PRIMARY KEY using index "trusts_pkey";

alter table "public"."author" add constraint "author_birth_town_fkey" FOREIGN KEY (birth_town) REFERENCES town(id) ON UPDATE CASCADE not valid;

alter table "public"."author" validate constraint "author_birth_town_fkey";

alter table "public"."author" add constraint "author_created_by_fkey" FOREIGN KEY (created_by) REFERENCES profile(id) ON UPDATE CASCADE ON DELETE RESTRICT not valid;

alter table "public"."author" validate constraint "author_created_by_fkey";

alter table "public"."author" add constraint "author_updated_by_fkey" FOREIGN KEY (updated_by) REFERENCES profile(id) ON UPDATE CASCADE ON DELETE RESTRICT not valid;

alter table "public"."author" validate constraint "author_updated_by_fkey";

alter table "public"."citation" add constraint "citation_author_id_fkey" FOREIGN KEY (author_id) REFERENCES author(id) ON UPDATE CASCADE not valid;

alter table "public"."citation" validate constraint "citation_author_id_fkey";

alter table "public"."citation" add constraint "citation_created_by_fkey" FOREIGN KEY (created_by) REFERENCES profile(id) ON UPDATE CASCADE ON DELETE RESTRICT not valid;

alter table "public"."citation" validate constraint "citation_created_by_fkey";

alter table "public"."citation" add constraint "citation_event_id_fkey" FOREIGN KEY (event_id) REFERENCES event(id) ON UPDATE CASCADE not valid;

alter table "public"."citation" validate constraint "citation_event_id_fkey";

alter table "public"."citation" add constraint "citation_place_id_fkey" FOREIGN KEY (place_id) REFERENCES place(id) not valid;

alter table "public"."citation" validate constraint "citation_place_id_fkey";

alter table "public"."citation" add constraint "citation_updated_by_fkey" FOREIGN KEY (updated_by) REFERENCES profile(id) ON UPDATE CASCADE ON DELETE RESTRICT not valid;

alter table "public"."citation" validate constraint "citation_updated_by_fkey";

alter table "public"."country" add constraint "countries_name_check" CHECK ((length(name) > 0)) not valid;

alter table "public"."country" validate constraint "countries_name_check";

alter table "public"."country" add constraint "countries_name_key" UNIQUE using index "countries_name_key";

alter table "public"."country" add constraint "country_created_by_fkey" FOREIGN KEY (created_by) REFERENCES profile(id) ON UPDATE CASCADE ON DELETE RESTRICT not valid;

alter table "public"."country" validate constraint "country_created_by_fkey";

alter table "public"."country" add constraint "country_updated_by_fkey" FOREIGN KEY (updated_by) REFERENCES profile(id) ON UPDATE CASCADE ON DELETE RESTRICT not valid;

alter table "public"."country" validate constraint "country_updated_by_fkey";

alter table "public"."event" add constraint "event_created_by_fkey" FOREIGN KEY (created_by) REFERENCES profile(id) ON UPDATE CASCADE ON DELETE RESTRICT not valid;

alter table "public"."event" validate constraint "event_created_by_fkey";

alter table "public"."event" add constraint "event_place_id_fkey" FOREIGN KEY (place_id) REFERENCES place(id) ON UPDATE CASCADE not valid;

alter table "public"."event" validate constraint "event_place_id_fkey";

alter table "public"."event" add constraint "event_updated_by_fkey" FOREIGN KEY (updated_by) REFERENCES profile(id) ON UPDATE CASCADE ON DELETE RESTRICT not valid;

alter table "public"."event" validate constraint "event_updated_by_fkey";

alter table "public"."place" add constraint "place_created_by_fkey" FOREIGN KEY (created_by) REFERENCES profile(id) ON UPDATE CASCADE ON DELETE RESTRICT not valid;

alter table "public"."place" validate constraint "place_created_by_fkey";

alter table "public"."place" add constraint "place_town_id_fkey" FOREIGN KEY (town_id) REFERENCES town(id) ON UPDATE CASCADE not valid;

alter table "public"."place" validate constraint "place_town_id_fkey";

alter table "public"."place" add constraint "place_updated_by_fkey" FOREIGN KEY (updated_by) REFERENCES profile(id) ON UPDATE CASCADE ON DELETE RESTRICT not valid;

alter table "public"."place" validate constraint "place_updated_by_fkey";

alter table "public"."profile" add constraint "profile_auth_user_id_fkey" FOREIGN KEY (auth_user_id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."profile" validate constraint "profile_auth_user_id_fkey";

alter table "public"."profile" add constraint "profiles_username_key" UNIQUE using index "profiles_username_key";

alter table "public"."profile" add constraint "username_length" CHECK ((char_length(username) >= 3)) not valid;

alter table "public"."profile" validate constraint "username_length";

alter table "public"."town" add constraint "town_country_id_fkey" FOREIGN KEY (country_id) REFERENCES country(id) ON UPDATE CASCADE not valid;

alter table "public"."town" validate constraint "town_country_id_fkey";

alter table "public"."town" add constraint "town_created_by_fkey" FOREIGN KEY (created_by) REFERENCES profile(id) ON UPDATE CASCADE ON DELETE RESTRICT not valid;

alter table "public"."town" validate constraint "town_created_by_fkey";

alter table "public"."town" add constraint "town_updated_by_fkey" FOREIGN KEY (updated_by) REFERENCES profile(id) ON UPDATE CASCADE ON DELETE RESTRICT not valid;

alter table "public"."town" validate constraint "town_updated_by_fkey";

alter table "public"."town" add constraint "towns_name_check" CHECK ((length(name) > 0)) not valid;

alter table "public"."town" validate constraint "towns_name_check";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.rls_authors_delete(record author)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN rls_check_delete_by_created_by(record.created_by);
END;
$function$
;

CREATE OR REPLACE FUNCTION public.rls_authors_edit(record author)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN rls_check_edit_by_created_by(record.created_by);
END;
$function$
;

CREATE OR REPLACE FUNCTION public.rls_citations_delete(record citation)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN rls_check_delete_by_created_by(record.created_by);
END;
$function$
;

CREATE OR REPLACE FUNCTION public.rls_citations_edit(record citation)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN rls_check_edit_by_created_by(record.created_by);
END;
$function$
;

CREATE OR REPLACE FUNCTION public.rls_countries_delete(record country)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN rls_check_delete_by_created_by(record.created_by);
END;
$function$
;

CREATE OR REPLACE FUNCTION public.rls_countries_edit(record country)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN rls_check_edit_by_created_by(record.created_by);
END;
$function$
;

CREATE OR REPLACE FUNCTION public.rls_events_delete(record event)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN rls_check_delete_by_created_by(record.created_by);
END;
$function$
;

CREATE OR REPLACE FUNCTION public.rls_events_edit(record event)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN rls_check_edit_by_created_by(record.created_by);
END;
$function$
;

CREATE OR REPLACE FUNCTION public.rls_places_delete(record place)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN rls_check_delete_by_created_by(record.created_by);
END;
$function$
;

CREATE OR REPLACE FUNCTION public.rls_places_edit(record place)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN rls_check_edit_by_created_by(record.created_by);
END;
$function$
;

CREATE OR REPLACE FUNCTION public.rls_profiles_edit(record profile)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN
    -- RAISE LOG 'rls_profiles_edit: profile %', record.id;
    RETURN rls_check_edit_by_created_by(record.id, FALSE, 'claim_edit_all_profiles');
END;
$function$
;

CREATE OR REPLACE FUNCTION public.rls_profiles_edit(records profile[])
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
DECLARE
    t profiles;
BEGIN
  FOREACH t IN ARRAY records LOOP
    RAISE LOG 'rls_profiles_edit: profiles %', t.id;
    RETURN TRUE;
  END LOOP;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.rls_towns_delete(record town)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN rls_check_delete_by_created_by(record.created_by);
END;
$function$
;

CREATE OR REPLACE FUNCTION public.rls_towns_edit(record town)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN rls_check_edit_by_created_by(record.created_by);
END;
$function$
;

CREATE OR REPLACE FUNCTION public.rls_trusts_edit(record trust)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN
    -- RAISE LOG 'rls_profiles_edit: profile %', record.id;
    RETURN rls_check_edit_by_created_by(record.who, FALSE, 'claim_edit_all_profiles');
END;
$function$
;

CREATE OR REPLACE FUNCTION public.handle_auth_user_new()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
  INSERT INTO public.profile (auth_user_id, full_name, avatar_url)
	  VALUES (
		  NEW.id,
		  NEW.raw_user_meta_data->>'full_name',
		  NEW.raw_user_meta_data->>'avatar_url'
	  );
  RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.rls_check_edit_by_created_by(created_by bigint, allow_trust boolean DEFAULT true, claim_check character varying DEFAULT 'claim_edit_all_content'::character varying)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
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
$function$
;

CREATE OR REPLACE FUNCTION public.string_limit(s character varying, max_length integer)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN CASE WHEN length(s) > max_length
      THEN substring(s, 1, max_length - 3) || '...'
      ELSE s
      END;
END;
$function$
;

create or replace view "public"."view_id_name" as  SELECT 'author'::text AS table_name,
    author.id,
    author.lastname_name_patronymic AS name,
    string_limit((author.lastname_name_patronymic)::character varying, 20) AS short_name
   FROM author
UNION
 SELECT 'citation'::text AS table_name,
    citation.id,
    string_limit((citation.english_text)::character varying, 40) AS name,
    string_limit((citation.english_text)::character varying, 20) AS short_name
   FROM citation
UNION
 SELECT 'country'::text AS table_name,
    country.id,
    country.name,
    string_limit((country.name)::character varying, 20) AS short_name
   FROM country
UNION
 SELECT 'place'::text AS table_name,
    place.id,
    place.name,
    string_limit((place.name)::character varying, 20) AS short_name
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
    town.name,
    string_limit((town.name)::character varying, 20) AS short_name
   FROM town
  ORDER BY 1, 4;


create or replace view "public"."view_rls_edit_for_table" as  SELECT 'authors'::text AS table_name,
    author.id,
    rls_authors_edit(author.*) AS editable,
    rls_authors_delete(author.*) AS deletable
   FROM author
UNION
 SELECT 'citations'::text AS table_name,
    citation.id,
    rls_citations_edit(citation.*) AS editable,
    rls_citations_delete(citation.*) AS deletable
   FROM citation
UNION
 SELECT 'countries'::text AS table_name,
    country.id,
    rls_countries_edit(country.*) AS editable,
    rls_countries_delete(country.*) AS deletable
   FROM country
UNION
 SELECT 'events'::text AS table_name,
    event.id,
    rls_events_edit(event.*) AS editable,
    rls_events_delete(event.*) AS deletable
   FROM event
UNION
 SELECT 'places'::text AS table_name,
    place.id,
    rls_places_edit(place.*) AS editable,
    rls_places_delete(place.*) AS deletable
   FROM place
UNION
 SELECT 'profiles'::text AS table_name,
    profile.id,
    rls_profiles_edit(profile.*) AS editable,
    false AS deletable
   FROM profile
UNION
 SELECT 'towns'::text AS table_name,
    town.id,
    rls_towns_edit(town.*) AS editable,
    rls_towns_delete(town.*) AS deletable
   FROM town
UNION
 SELECT 'trusts'::text AS table_name,
    trust.id,
    rls_trusts_edit(trust.*) AS editable,
    rls_trusts_edit(trust.*) AS deletable
   FROM trust;


create policy "RLS: authors: delete"
on "public"."author"
as permissive
for delete
to authenticated
using (rls_authors_edit(author.*));


create policy "RLS: authors: insert"
on "public"."author"
as permissive
for insert
to authenticated
with check (rls_authors_edit(author.*));


create policy "RLS: authors: select"
on "public"."author"
as permissive
for select
to public
using (true);


create policy "RLS: authors: update"
on "public"."author"
as permissive
for update
to authenticated
using (rls_authors_edit(author.*))
with check (rls_authors_edit(author.*));


create policy "RLS: citations: delete"
on "public"."citation"
as permissive
for delete
to authenticated
using (rls_citations_edit(citation.*));


create policy "RLS: citations: insert"
on "public"."citation"
as permissive
for insert
to authenticated
with check (rls_citations_edit(citation.*));


create policy "RLS: citations: select"
on "public"."citation"
as permissive
for select
to public
using (true);


create policy "RLS: citations: update"
on "public"."citation"
as permissive
for update
to authenticated
using (rls_citations_edit(citation.*))
with check (rls_citations_edit(citation.*));


create policy "RLS: countries: delete"
on "public"."country"
as permissive
for delete
to authenticated
using (rls_countries_delete(country.*));


create policy "RLS: countries: insert"
on "public"."country"
as permissive
for insert
to authenticated
with check (rls_countries_edit(country.*));


create policy "RLS: countries: select"
on "public"."country"
as permissive
for select
to public
using (true);


create policy "RLS: countries: update"
on "public"."country"
as permissive
for update
to authenticated
using (rls_countries_edit(country.*))
with check (rls_countries_edit(country.*));


create policy "RLS: events: delete"
on "public"."event"
as permissive
for delete
to authenticated
using (rls_events_edit(event.*));


create policy "RLS: events: insert"
on "public"."event"
as permissive
for insert
to authenticated
with check (rls_events_edit(event.*));


create policy "RLS: events: select"
on "public"."event"
as permissive
for select
to public
using (true);


create policy "RLS: events: update"
on "public"."event"
as permissive
for update
to authenticated
using (rls_events_edit(event.*))
with check (rls_events_edit(event.*));


create policy "RLS: places: delete"
on "public"."place"
as permissive
for delete
to authenticated
using (rls_places_edit(place.*));


create policy "RLS: places: insert"
on "public"."place"
as permissive
for insert
to authenticated
with check (rls_places_edit(place.*));


create policy "RLS: places: select"
on "public"."place"
as permissive
for select
to public
using (true);


create policy "RLS: places: update"
on "public"."place"
as permissive
for update
to authenticated
using (rls_places_edit(place.*))
with check (rls_places_edit(place.*));


create policy " RLS: profiles: insert"
on "public"."profile"
as permissive
for insert
to public
with check ((auth.uid() = auth_user_id));


create policy " RLS: profiles: update"
on "public"."profile"
as permissive
for update
to public
using (rls_profiles_edit(profile.*));


create policy "RLS: profiles: select"
on "public"."profile"
as permissive
for select
to public
using (true);


create policy "RLS: towns: delete"
on "public"."town"
as permissive
for delete
to authenticated
using (rls_towns_edit(town.*));


create policy "RLS: towns: insert"
on "public"."town"
as permissive
for insert
to authenticated
with check (rls_towns_edit(town.*));


create policy "RLS: towns: select"
on "public"."town"
as permissive
for select
to public
using (true);


create policy "RLS: towns: update"
on "public"."town"
as permissive
for update
to authenticated
using (rls_towns_edit(town.*))
with check (rls_towns_edit(town.*));


create policy "RLS: trusts: delete"
on "public"."trust"
as permissive
for delete
to authenticated
using (rls_trusts_edit(trust.*));


create policy "RLS: trusts: insert"
on "public"."trust"
as permissive
for insert
to authenticated
with check (rls_trusts_edit(trust.*));


create policy "RLS: trusts: select"
on "public"."trust"
as permissive
for select
to authenticated
using (true);


create policy "RLS: trusts: update"
on "public"."trust"
as permissive
for update
to authenticated
using (rls_trusts_edit(trust.*))
with check (rls_trusts_edit(trust.*));


CREATE TRIGGER on_authors_edit_fill_update BEFORE UPDATE ON public.author FOR EACH ROW EXECUTE FUNCTION handle_fill_updated();

CREATE TRIGGER on_authors_new_fill_created_by BEFORE INSERT ON public.author FOR EACH ROW EXECUTE FUNCTION handle_fill_created_by();

CREATE TRIGGER on_citations_edit_fill_update BEFORE UPDATE ON public.citation FOR EACH ROW EXECUTE FUNCTION handle_fill_updated();

CREATE TRIGGER on_citations_new_fill_created_by BEFORE INSERT ON public.citation FOR EACH ROW EXECUTE FUNCTION handle_fill_created_by();

CREATE TRIGGER on_country_edit_fill_update BEFORE UPDATE ON public.country FOR EACH ROW EXECUTE FUNCTION handle_fill_updated();

CREATE TRIGGER on_country_new_fill_created_by BEFORE INSERT ON public.country FOR EACH ROW EXECUTE FUNCTION handle_fill_created_by();

CREATE TRIGGER on_events_edit_fill_update BEFORE UPDATE ON public.event FOR EACH ROW EXECUTE FUNCTION handle_fill_updated();

CREATE TRIGGER on_events_new_fill_created_by BEFORE INSERT ON public.event FOR EACH ROW EXECUTE FUNCTION handle_fill_created_by();

CREATE TRIGGER on_places_edit_fill_update BEFORE UPDATE ON public.place FOR EACH ROW EXECUTE FUNCTION handle_fill_updated();

CREATE TRIGGER on_places_new_fill_created_by BEFORE INSERT ON public.place FOR EACH ROW EXECUTE FUNCTION handle_fill_created_by();

CREATE TRIGGER on_public_profile_new AFTER INSERT ON public.profile FOR EACH ROW EXECUTE FUNCTION handle_public_profile_new();

CREATE TRIGGER on_towns_edit_fill_update BEFORE UPDATE ON public.town FOR EACH ROW EXECUTE FUNCTION handle_fill_updated();

CREATE TRIGGER on_towns_new_fill_created_by BEFORE INSERT ON public.town FOR EACH ROW EXECUTE FUNCTION handle_fill_created_by();


