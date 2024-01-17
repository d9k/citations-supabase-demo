drop policy "RLS: country: select" on "public"."country";

set check_function_bodies = off;

create policy "RLS: country: select (guest)"
on "public"."country"
as permissive
for select
to anon
using (published);


create policy "RLS: country: select"
on "public"."country"
as permissive
for select
to authenticated
using (true);



