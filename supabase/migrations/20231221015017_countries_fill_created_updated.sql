drop policy "countries: authed can read" on "public"."countries";

alter table "public"."profiles" drop constraint "profiles_pkey";

drop index if exists "public"."profiles_pkey";

alter table "public"."countries" add column "created_by" bigint;

alter table "public"."countries" add column "updated_by" bigint;

alter table "public"."countries" alter column "name" set default ''::text;

alter table "public"."countries" alter column "name" set not null;

CREATE UNIQUE INDEX profiles_pkey ON public.profiles USING btree (id);

alter table "public"."profiles" add constraint "profiles_pkey" PRIMARY KEY using index "profiles_pkey";

alter table "public"."countries" add constraint "countries_created_by_fkey" FOREIGN KEY (created_by) REFERENCES profiles(id) ON UPDATE CASCADE ON DELETE RESTRICT not valid;

alter table "public"."countries" validate constraint "countries_created_by_fkey";

alter table "public"."countries" add constraint "countries_name_check" CHECK ((length(name) > 0)) not valid;

alter table "public"."countries" validate constraint "countries_name_check";

alter table "public"."countries" add constraint "countries_updated_by_fkey" FOREIGN KEY (updated_by) REFERENCES profiles(id) ON UPDATE CASCADE ON DELETE RESTRICT not valid;

alter table "public"."countries" validate constraint "countries_updated_by_fkey";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.handle_fill_created_by()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
  NEW.created_by := get_my_claim('profile_id');
  RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.handle_fill_updated()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
  NEW.updated_by := get_my_claim('profile_id');
  NEW.updated_at := NOW();
  RETURN NEW;
END;
$function$
;


create policy "countries: authed can all"
on "public"."countries"
as permissive
for all
to authenticated
using (true)
with check (true);


CREATE TRIGGER on_country_edit_fill_update BEFORE UPDATE ON public.countries FOR EACH ROW EXECUTE FUNCTION handle_fill_updated();

CREATE TRIGGER on_country_new_fill_created_by BEFORE INSERT ON public.countries FOR EACH ROW EXECUTE FUNCTION handle_fill_created_by();


