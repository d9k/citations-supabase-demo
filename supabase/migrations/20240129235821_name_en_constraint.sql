alter table "public"."country" drop constraint "countries_name_check";

alter table "public"."town" drop constraint "towns_name_check";

alter table "public"."author" drop constraint "author_name_en_check";

alter table "public"."author" drop constraint "author_table_name_check";

alter table "public"."citation" drop constraint "citation_table_name_check";

alter table "public"."event" drop constraint "event_table_name_check";

alter table "public"."place" drop constraint "place_table_name_check";

alter table "public"."town" drop constraint "town_table_name_check";

alter table "public"."citation" add constraint "citation_text_en_check" CHECK ((length(text_en) >= 5)) not valid;

alter table "public"."citation" validate constraint "citation_text_en_check";

alter table "public"."country" add constraint "country_name_en_check" CHECK ((length(name_en) >= 2)) not valid;

alter table "public"."country" validate constraint "country_name_en_check";

alter table "public"."event" add constraint "event_name_en_check" CHECK ((length(name_en) >= 2)) not valid;

alter table "public"."event" validate constraint "event_name_en_check";

alter table "public"."place" add constraint "place_name_en_check" CHECK ((length(name_en) >= 2)) not valid;

alter table "public"."place" validate constraint "place_name_en_check";

alter table "public"."town" add constraint "town_name_en_check" CHECK ((length(name_en) >= 2)) not valid;

alter table "public"."town" validate constraint "town_name_en_check";

alter table "public"."author" add constraint "author_name_en_check" CHECK ((length(name_en) >= 2)) not valid;

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


