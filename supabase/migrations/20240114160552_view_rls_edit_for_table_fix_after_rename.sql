create or replace view "public"."view_rls_edit_for_table" as  SELECT 'author'::text AS table_name,
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
 SELECT 'country'::text AS table_name,
    country.id,
    rls_countries_edit(country.*) AS editable,
    rls_countries_delete(country.*) AS deletable
   FROM country
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
   FROM trust;



