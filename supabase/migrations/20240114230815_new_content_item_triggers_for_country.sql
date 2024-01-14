drop trigger if exists "on_country_edit_fill_update" on "public"."country";

drop policy "RLS: countries: delete" on "public"."country";

drop policy "RLS: countries: insert" on "public"."country";

drop policy "RLS: countries: select" on "public"."country";

drop policy "RLS: countries: update" on "public"."country";

drop view if exists "public"."view_rls_edit_for_table";

drop function if exists "public"."rls_countries_delete"(record country);

drop function if exists "public"."rls_countries_edit"(record country);

alter table "public"."country" inherit "public"."content_item"

alter table "public"."content_item" enable row level security;

alter table "public"."country" drop column "created_at";

alter table "public"."country" drop column "created_by";

alter table "public"."country" drop column "id";

alter table "public"."country" drop column "updated_at";

alter table "public"."country" drop column "updated_by";

alter table "public"."country" add column "published_at" timestamp with time zone;

alter table "public"."country" add column "published_by" bigint;

alter table "public"."country" add column "table_name" text not null default 'country'::text;

alter table "public"."country" add column "unpublished_at" timestamp with time zone;

alter table "public"."country" add column "unpublished_by" bigint;

alter table "public"."country" add constraint "country_table_name_check" CHECK ((table_name = 'country'::text)) not valid;

alter table "public"."country" validate constraint "country_table_name_check";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.fn_any_type(r record)
 RETURNS record
 LANGUAGE plpgsql
AS $function$
DECLARE
	t record;
BEGIN
  t := r;
  t.updated_at := NOW();
	RETURN t;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.handle_content_item_edit()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
  RETURN record_fill_updated_by(record_fill_updated_at(NEW));
END;
$function$
;

CREATE OR REPLACE FUNCTION public.handle_content_item_new()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
  RETURN record_fill_created_by(NEW);
END;
$function$
;

CREATE OR REPLACE FUNCTION public.record_fill_created_by(r record)
 RETURNS record
 LANGUAGE plpgsql
AS $function$
DECLARE
	t record;
BEGIN
  t := r;
  t.created_by := get_my_claim('profile_id');
	RETURN t;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.record_fill_updated_at(r record)
 RETURNS record
 LANGUAGE plpgsql
AS $function$
DECLARE
	t record;
BEGIN
  t := r;
  t.updated_at := NOW();
	RETURN t;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.record_fill_updated_by(r record)
 RETURNS record
 LANGUAGE plpgsql
AS $function$
DECLARE
	t record;
BEGIN
  t := r;
  t.updated_by := get_my_claim('profile_id');
	RETURN t;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.rls_content_item_check_delete(record content_item)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN
	RETURN rls_check_delete_by_created_by(record.created_by);
END;
$function$
;

CREATE OR REPLACE FUNCTION public.rls_content_item_check_edit(record content_item)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN
	RETURN rls_check_edit_by_created_by(record.created_by);
END;
$function$
;

create or replace view "public"."view_rls_content_item" as  SELECT content_item.table_name,
    content_item.id,
    rls_content_item_check_edit(content_item.*) AS editable,
    rls_content_item_check_delete(content_item.*) AS deletable
   FROM content_item
  ORDER BY content_item.table_name, content_item.id;


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

create or replace view "public"."view_rls_edit_for_table" as  SELECT view_rls_content_item.table_name,
    view_rls_content_item.id,
    view_rls_content_item.editable,
    view_rls_content_item.deletable
   FROM view_rls_content_item
UNION
 SELECT 'author'::text AS table_name,
    author.id,
    rls_authors_edit(author.*) AS editable,
    rls_authors_delete(author.*) AS deletable
   FROM author
UNION
 SELECT 'citation'::text AS table_name,
    citation.id,
    rls_citations_edit(citation.*) AS editable,
    rls_citations_delete(citation.*) AS deletable
   FROM citation
UNION
 SELECT 'event'::text AS table_name,
    event.id,
    rls_events_edit(event.*) AS editable,
    rls_events_delete(event.*) AS deletable
   FROM event
UNION
 SELECT 'place'::text AS table_name,
    place.id,
    rls_places_edit(place.*) AS editable,
    rls_places_delete(place.*) AS deletable
   FROM place
UNION
 SELECT 'profile'::text AS table_name,
    profile.id,
    rls_profiles_edit(profile.*) AS editable,
    false AS deletable
   FROM profile
UNION
 SELECT 'town'::text AS table_name,
    town.id,
    rls_towns_edit(town.*) AS editable,
    rls_towns_delete(town.*) AS deletable
   FROM town
UNION
 SELECT 'trust'::text AS table_name,
    trust.id,
    rls_trusts_edit(trust.*) AS editable,
    rls_trusts_edit(trust.*) AS deletable
   FROM trust
  ORDER BY 1, 2;


create policy "RLS: content_item: select"
on "public"."content_item"
as permissive
for select
to public
using (true);


create policy "RLS: country: delete"
on "public"."country"
as permissive
for delete
to authenticated
using (rls_content_item_check_delete((country.*)::content_item));


create policy "RLS: country: insert"
on "public"."country"
as permissive
for insert
to authenticated
with check (rls_content_item_check_edit((country.*)::content_item));


create policy "RLS: country: select"
on "public"."country"
as permissive
for select
to public
using (true);


create policy "RLS: country: update"
on "public"."country"
as permissive
for update
to authenticated
using (rls_content_item_check_edit((country.*)::content_item))
with check (rls_content_item_check_edit((country.*)::content_item));


CREATE TRIGGER on_country_edit BEFORE UPDATE ON public.country FOR EACH ROW EXECUTE FUNCTION handle_content_item_edit();

CREATE TRIGGER on_country_new BEFORE UPDATE ON public.country FOR EACH ROW EXECUTE FUNCTION handle_content_item_new();


