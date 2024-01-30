drop trigger if exists "on_authors_edit_fill_update" on "public"."author";

drop trigger if exists "on_authors_new_fill_created_by" on "public"."author";

drop trigger if exists "on_citations_edit_fill_update" on "public"."citation";

drop trigger if exists "on_citations_new_fill_created_by" on "public"."citation";

drop trigger if exists "on_country_new_fill_created_by" on "public"."country";

drop trigger if exists "on_events_edit_fill_update" on "public"."event";

drop trigger if exists "on_events_new_fill_created_by" on "public"."event";

drop trigger if exists "on_places_edit_fill_update" on "public"."place";

drop trigger if exists "on_places_new_fill_created_by" on "public"."place";

drop trigger if exists "on_towns_edit_fill_update" on "public"."town";

drop trigger if exists "on_towns_new_fill_created_by" on "public"."town";

drop policy "RLS: authors: delete" on "public"."author";

drop policy "RLS: authors: insert" on "public"."author";

drop policy "RLS: authors: select" on "public"."author";

drop policy "RLS: authors: update" on "public"."author";

drop policy "RLS: citations: delete" on "public"."citation";

drop policy "RLS: citations: insert" on "public"."citation";

drop policy "RLS: citations: select" on "public"."citation";

drop policy "RLS: citations: update" on "public"."citation";

drop policy "RLS: events: delete" on "public"."event";

drop policy "RLS: events: insert" on "public"."event";

drop policy "RLS: events: select" on "public"."event";

drop policy "RLS: events: update" on "public"."event";

drop policy "RLS: places: delete" on "public"."place";

drop policy "RLS: places: insert" on "public"."place";

drop policy "RLS: places: select" on "public"."place";

drop policy "RLS: places: update" on "public"."place";

drop policy "RLS: towns: delete" on "public"."town";

drop policy "RLS: towns: insert" on "public"."town";

drop policy "RLS: towns: select" on "public"."town";

drop policy "RLS: towns: update" on "public"."town";

drop policy "RLS: content_item: select" on "public"."content_item";

alter table "public"."author" drop constraint "author_table_name_check";

alter table "public"."citation" drop constraint "citation_table_name_check";

alter table "public"."event" drop constraint "event_table_name_check";

alter table "public"."place" drop constraint "place_table_name_check";

alter table "public"."town" drop constraint "town_table_name_check";

drop view if exists "public"."view_id_name";

alter table "public"."author" alter column "updated_at" drop default;

alter table "public"."author" alter column "updated_at" drop not null;

alter table "public"."citation" alter column "updated_at" set not null;

alter table "public"."author" add constraint "author_name_en_check" CHECK ((length(name_en) > 0)) not valid;

alter table "public"."author" validate constraint "author_name_en_check";

alter table "public"."author" add constraint "author_table_name_check" CHECK ((table_name = 'author'::text)) NOT VALID not valid;

alter table "public"."author" validate constraint "author_table_name_check";

alter table "public"."citation" add constraint "citation_table_name_check" CHECK ((table_name = 'citation'::text)) NOT VALID not valid;

alter table "public"."citation" validate constraint "citation_table_name_check";

alter table "public"."event" add constraint "event_table_name_check" CHECK ((table_name = 'event'::text)) NOT VALID not valid;

alter table "public"."event" validate constraint "event_table_name_check";

alter table "public"."place" add constraint "place_table_name_check" CHECK ((table_name = 'place'::text)) NOT VALID not valid;

alter table "public"."place" validate constraint "place_table_name_check";

alter table "public"."town" add constraint "town_table_name_check" CHECK ((table_name = 'town'::text)) NOT VALID not valid;

alter table "public"."town" validate constraint "town_table_name_check";

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

create or replace view "public"."view_id_name" as  SELECT author.table_name,
    author.id,
    author.name_en AS name,
    string_limit((author.name_en)::character varying, 20) AS short_name
   FROM author
UNION
 SELECT citation.table_name,
    citation.id,
    string_limit((citation.text_en)::character varying, 40) AS name,
    string_limit((citation.text_en)::character varying, 20) AS short_name
   FROM citation
UNION
 SELECT country.table_name,
    country.id,
    country.name_en AS name,
    string_limit((country.name_en)::character varying, 20) AS short_name
   FROM country
UNION
 SELECT place.table_name,
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
 SELECT town.table_name,
    town.id,
    town.name_en AS name,
    string_limit((town.name_en)::character varying, 20) AS short_name
   FROM town
  ORDER BY 1, 4;


create policy "RLS: author: delete"
on "public"."author"
as permissive
for delete
to authenticated
using (rls_content_item_check_delete((author.*)::content_item));


create policy "RLS: author: insert"
on "public"."author"
as permissive
for insert
to authenticated
with check (rls_content_item_check_edit((author.*)::content_item));


create policy "RLS: author: select (guest)"
on "public"."author"
as permissive
for select
to anon
using (published);


create policy "RLS: author: select"
on "public"."author"
as permissive
for select
to authenticated
using (true);


create policy "RLS: author: update"
on "public"."author"
as permissive
for update
to authenticated
using (rls_content_item_check_edit((author.*)::content_item))
with check (rls_content_item_check_edit((author.*)::content_item));


create policy "RLS: citation: delete"
on "public"."citation"
as permissive
for delete
to authenticated
using (rls_content_item_check_delete((citation.*)::content_item));


create policy "RLS: citation: insert"
on "public"."citation"
as permissive
for insert
to authenticated
with check (rls_content_item_check_edit((citation.*)::content_item));


create policy "RLS: citation: select (guest)"
on "public"."citation"
as permissive
for select
to anon
using (published);


create policy "RLS: citation: select"
on "public"."citation"
as permissive
for select
to authenticated
using (true);


create policy "RLS: citation: update"
on "public"."citation"
as permissive
for update
to authenticated
using (rls_content_item_check_edit((citation.*)::content_item))
with check (rls_content_item_check_edit((citation.*)::content_item));


create policy "RLS: content_item: select (guest)"
on "public"."content_item"
as permissive
for select
to anon
using (published);


create policy "RLS: event: delete"
on "public"."event"
as permissive
for delete
to authenticated
using (rls_content_item_check_delete((event.*)::content_item));


create policy "RLS: event: insert"
on "public"."event"
as permissive
for insert
to authenticated
with check (rls_content_item_check_edit((event.*)::content_item));


create policy "RLS: event: select (guest)"
on "public"."event"
as permissive
for select
to anon
using (published);


create policy "RLS: event: select"
on "public"."event"
as permissive
for select
to authenticated
using (true);


create policy "RLS: event: update"
on "public"."event"
as permissive
for update
to authenticated
using (rls_content_item_check_edit((event.*)::content_item))
with check (rls_content_item_check_edit((event.*)::content_item));


create policy "RLS: place: delete"
on "public"."place"
as permissive
for delete
to authenticated
using (rls_content_item_check_delete((place.*)::content_item));


create policy "RLS: place: insert"
on "public"."place"
as permissive
for insert
to authenticated
with check (rls_content_item_check_edit((place.*)::content_item));


create policy "RLS: place: select (guest)"
on "public"."place"
as permissive
for select
to anon
using (published);


create policy "RLS: place: select"
on "public"."place"
as permissive
for select
to authenticated
using (true);


create policy "RLS: place: update"
on "public"."place"
as permissive
for update
to authenticated
using (rls_content_item_check_edit((place.*)::content_item))
with check (rls_content_item_check_edit((place.*)::content_item));


create policy "RLS: town: delete"
on "public"."town"
as permissive
for delete
to authenticated
using (rls_content_item_check_delete((town.*)::content_item));


create policy "RLS: town: insert"
on "public"."town"
as permissive
for insert
to authenticated
with check (rls_content_item_check_edit((town.*)::content_item));


create policy "RLS: town: select (guest)"
on "public"."town"
as permissive
for select
to anon
using (published);


create policy "RLS: town: select"
on "public"."town"
as permissive
for select
to authenticated
using (true);


create policy "RLS: town: update"
on "public"."town"
as permissive
for update
to authenticated
using (rls_content_item_check_edit((town.*)::content_item))
with check (rls_content_item_check_edit((town.*)::content_item));


create policy "RLS: content_item: select"
on "public"."content_item"
as permissive
for select
to authenticated
using (true);


CREATE TRIGGER on_author_edit BEFORE UPDATE ON public.author FOR EACH ROW EXECUTE FUNCTION handle_content_item_edit();

CREATE TRIGGER on_author_new BEFORE INSERT ON public.author FOR EACH ROW EXECUTE FUNCTION handle_content_item_new();

CREATE TRIGGER on_citation_edit BEFORE UPDATE ON public.citation FOR EACH ROW EXECUTE FUNCTION handle_content_item_edit();

CREATE TRIGGER on_citation_new BEFORE INSERT ON public.citation FOR EACH ROW EXECUTE FUNCTION handle_content_item_new();

CREATE TRIGGER on_event_edit BEFORE UPDATE ON public.event FOR EACH ROW EXECUTE FUNCTION handle_content_item_edit();

CREATE TRIGGER on_event_new BEFORE INSERT ON public.event FOR EACH ROW EXECUTE FUNCTION handle_content_item_new();

CREATE TRIGGER on_place_edit BEFORE UPDATE ON public.place FOR EACH ROW EXECUTE FUNCTION handle_content_item_edit();

CREATE TRIGGER on_place_new BEFORE INSERT ON public.place FOR EACH ROW EXECUTE FUNCTION handle_content_item_new();

CREATE TRIGGER on_town_edit BEFORE UPDATE ON public.town FOR EACH ROW EXECUTE FUNCTION handle_content_item_edit();

CREATE TRIGGER on_town_new BEFORE INSERT ON public.town FOR EACH ROW EXECUTE FUNCTION handle_content_item_new();


