--
-- PostgreSQL database dump
--

-- Dumped from database version 15.1 (Ubuntu 15.1-1.pgdg20.04+1)
-- Dumped by pg_dump version 15.4 (Ubuntu 15.4-1.pgdg20.04+1)

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
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--




--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."flow_state" ("id", "user_id", "auth_code", "code_challenge_method", "code_challenge", "provider_type", "provider_access_token", "provider_refresh_token", "created_at", "updated_at", "authentication_method") VALUES
	('1f34cdf7-e7f0-4970-b263-19eb162bd846', 'b5f563a3-b794-49d0-a0e3-dbf9fffd2321', '74d7e329-90c8-4d0b-b2d6-b75ecbd9cd57', 's256', 'OnWj5HXsonAXWE8-k2YDItq11wbqjXrtFJej8NkAO1g', 'email', '', '', '2023-11-30 13:19:57.233808+00', '2023-11-30 13:19:57.233808+00', 'email/signup');


--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."users" ("instance_id", "id", "aud", "role", "email", "encrypted_password", "email_confirmed_at", "invited_at", "confirmation_token", "confirmation_sent_at", "recovery_token", "recovery_sent_at", "email_change_token_new", "email_change", "email_change_sent_at", "last_sign_in_at", "raw_app_meta_data", "raw_user_meta_data", "is_super_admin", "created_at", "updated_at", "phone", "phone_confirmed_at", "phone_change", "phone_change_token", "phone_change_sent_at", "email_change_token_current", "email_change_confirm_status", "banned_until", "reauthentication_token", "reauthentication_sent_at", "is_sso_user", "deleted_at") VALUES
	('00000000-0000-0000-0000-000000000000', 'e76b244b-6f9e-42fc-b216-5ea74f94bd4c', 'authenticated', 'authenticated', 'gavriillarin263@inbox.lv', '$2a$10$W8/g0R7arxlSsdWrn.5hXOqbolOsyQrpCcAKTOEkoIy2Vekr3vgSS', '2023-12-09 05:25:02.817+00', NULL, '', '2023-12-09 05:24:14.076+00', '', NULL, '', '', NULL, '2023-12-09 05:25:02.818+00', '{"provider": "email", "providers": ["email"], "profile_id": 19}', NULL, NULL, '2023-12-09 05:24:14.065+00', '2023-12-09 05:25:02.819+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL),
	('00000000-0000-0000-0000-000000000000', '727a5d27-4b66-49ea-a2c1-0bccc7b8e2cd', 'authenticated', 'authenticated', 'd9k@ya.tu', '$2a$10$OR4GYiMa8vFpk1ywBfPrEeL8yj0TCJxO3joYXdlRezx8Kk6eBjmQ.', NULL, NULL, '45bc98dfe84800707f48a82df0ce417215a7869ba20ba657b46012c1', '2023-12-11 20:49:26.158057+00', '', NULL, '', '', NULL, NULL, '{"provider": "email", "providers": ["email"], "profile_id": 20}', '{}', NULL, '2023-12-11 20:49:26.145323+00', '2023-12-11 20:49:29.413083+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL),
	('00000000-0000-0000-0000-000000000000', 'b5f563a3-b794-49d0-a0e3-dbf9fffd2321', 'authenticated', 'authenticated', 'd9k@ya.ru', '$2a$10$BNL19FnvkC6EyYVshokk.e1R3HwylfiHqAp/PEtQY49PgNHxf0Nk2', '2023-11-30 13:20:52.160287+00', NULL, '', '2023-11-30 13:19:57.235919+00', '7f2a29538ce79186b557bd4686ded17471e6b935ec14af97e76550c6', '2023-12-20 18:26:02.177042+00', '', '', NULL, '2023-12-20 15:31:21.146419+00', '{"provider": "email", "providers": ["email"], "profile_id": 1}', '{}', NULL, '2023-11-30 13:19:57.22183+00', '2023-12-20 18:26:04.847678+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL);


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."identities" ("provider_id", "user_id", "identity_data", "provider", "last_sign_in_at", "created_at", "updated_at", "id") VALUES
	('b5f563a3-b794-49d0-a0e3-dbf9fffd2321', 'b5f563a3-b794-49d0-a0e3-dbf9fffd2321', '{"sub": "b5f563a3-b794-49d0-a0e3-dbf9fffd2321", "email": "d9k@ya.ru", "email_verified": false, "phone_verified": false}', 'email', '2023-11-30 13:19:57.231649+00', '2023-11-30 13:19:57.231688+00', '2023-11-30 13:19:57.231688+00', 'ef9a09b6-d37c-4ba9-a4d4-0682d78af774'),
	('727a5d27-4b66-49ea-a2c1-0bccc7b8e2cd', '727a5d27-4b66-49ea-a2c1-0bccc7b8e2cd', '{"sub": "727a5d27-4b66-49ea-a2c1-0bccc7b8e2cd", "email": "d9k@ya.tu", "email_verified": false, "phone_verified": false}', 'email', '2023-12-11 20:49:26.154423+00', '2023-12-11 20:49:26.154477+00', '2023-12-11 20:49:26.154477+00', 'c8974ccd-72ab-40e3-ac96-5997a55d45e5');


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

 Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/118.0.0.0 Safari/537.36', '94.25.187.158', NULL),
	('2746d270-873f-483b-8db4-1463e50c336d', 'b5f563a3-b794-49d0-a0e3-dbf9fffd2321', '2023-12-13 15:28:48.844754+00', '2023-12-13 16:48:45.812337+00', NULL, 'aal1', NULL, '2023-12-13 16:48:45.812262', 'Deno/1.38.4', '94.25.187.158', NULL),
	('400376ed-2a52-4c6c-bd41-3e0535fd86d5', 'b5f563a3-b794-49d0-a0e3-dbf9fffd2321', '2023-12-11 20:49:56.230363+00', '2023-12-11 22:10:10.011656+00', NULL, 'aal1', NULL, '2023-12-11 22:10:10.011568', 'Deno/1.38.4', '94.25.187.158', NULL),
	('eede4336-98b5-404f-927f-61c48d49dfbd', 'b5f563a3-b794-49d0-a0e3-dbf9fffd2321', '2023-12-18 16:45:54.110745+00', '2023-12-19 04:47:08.529806+00', NULL, 'aal1', NULL, '2023-12-19 04:47:08.529729', 'Deno/1.38.4', '94.25.187.158', NULL),
	('deaf3216-fb7c-41cc-b908-7b7c826f2929', 'b5f563a3-b794-49d0-a0e3-dbf9fffd2321', '2023-12-19 21:00:44.482475+00', '2023-12-19 22:07:02.347836+00', NULL, 'aal1', NULL, '2023-12-19 22:07:02.347766', 'Deno/1.38.4', '94.25.187.158', NULL),
	('73ca2c05-c30d-41a9-a3ca-0e0398e66175', 'b5f563a3-b794-49d0-a0e3-dbf9fffd2321', '2023-12-16 15:35:40.312985+00', '2023-12-18 16:40:05.923945+00', NULL, 'aal1', NULL, '2023-12-18 16:40:05.923868', 'Deno/1.38.4', '94.25.187.158', NULL),
	('6f26c1b0-f37c-4696-8cfb-be1cec797329', 'b5f563a3-b794-49d0-a0e3-dbf9fffd2321', '2023-12-19 14:47:33.182859+00', '2023-12-19 16:33:32.256169+00', NULL, 'aal1', NULL, '2023-12-19 16:33:32.256096', 'Deno/1.38.4', '94.25.187.158', NULL),
	('9f1be8d2-db9a-4244-8d98-62ef0cdbb589', 'b5f563a3-b794-49d0-a0e3-dbf9fffd2321', '2023-12-19 19:11:46.538513+00', '2023-12-19 19:11:46.538513+00', NULL, 'aal1', NULL, NULL, 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/118.0.0.0 Safari/537.36', '94.25.187.158', NULL),
	('5956bfc6-bb95-49e8-97f9-08bd727dd997', 'b5f563a3-b794-49d0-a0e3-dbf9fffd2321', '2023-12-20 15:31:21.14649+00', '2023-12-20 18:22:58.163558+00', NULL, 'aal1', NULL, '2023-12-20 18:22:58.163483', 'Deno/1.38.4', '94.25.187.158', NULL),
	('b6672a79-7255-44ba-92a3-40b84de08b3e', 'b5f563a3-b794-49d0-a0e3-dbf9fffd2321', '2023-12-15 20:33:09.6014+00', '2023-12-16 15:11:59.871459+00', NULL, 'aal1', NULL, '2023-12-16 15:11:59.871382', 'Deno/1.38.4', '94.25.187.158', NULL),
	('90056874-e87c-4138-b381-d2b3ae119816', 'b5f563a3-b794-49d0-a0e3-dbf9fffd2321', '2023-12-14 12:19:33.315826+00', '2023-12-14 17:14:40.265963+00', NULL, 'aal1', NULL, '2023-12-14 17:14:40.265892', 'Deno/1.38.4', '94.25.187.158', NULL),
	('6833ddc7-223d-4093-ad07-559f00b07419', 'b5f563a3-b794-49d0-a0e3-dbf9fffd2321', '2023-12-02 19:58:46.128371+00', '2023-12-06 14:16:01.286879+00', NULL, 'aal1', NULL, '2023-12-06 14:16:01.28681', 'Deno/1.38.4', '94.25.187.158', NULL),
	('810df881-05f6-4234-a115-23a34045ebfb', 'b5f563a3-b794-49d0-a0e3-dbf9fffd2321', '2023-12-08 23:55:03.711848+00', '2023-12-09 00:21:41.077088+00', NULL, 'aal1', NULL, '2023-12-09 00:21:41.077018', 'Deno/1.38.4', '94.25.187.158', NULL),
	('b293f801-2282-4755-9e10-e5e8e1f8a21c', 'b5f563a3-b794-49d0-a0e3-dbf9fffd2321', '2023-12-11 23:41:06.790021+00', '2023-12-13 15:10:57.449921+00', NULL, 'aal1', NULL, '2023-12-13 15:10:57.449843', 'Deno/1.38.4', '94.25.187.158', NULL),
	('98e8b0f3-7942-4c17-9d87-7bebc75a3631', 'b5f563a3-b794-49d0-a0e3-dbf9fffd2321', '2023-12-15 16:35:22.012435+00', '2023-12-15 20:23:55.623473+00', NULL, 'aal1', NULL, '2023-12-15 20:23:55.623399', 'Deno/1.38.4', '94.25.187.158', NULL),
	('5bba6304-8a77-4f59-9c0c-c00a6fd7ce91', 'b5f563a3-b794-49d0-a0e3-dbf9fffd2321', '2023-12-09 02:11:26.256446+00', '2023-12-11 20:33:32.182353+00', NULL, 'aal1', NULL, '2023-12-11 20:33:32.18228', 'Deno/1.38.4', '94.25.187.158', NULL),
	('304ff5a0-aa7f-4be0-948a-574dfe3aab41', 'b5f563a3-b794-49d0-a0e3-dbf9fffd2321', '2023-12-11 20:47:32.716261+00', '2023-12-11 20:47:32.716261+00', NULL, 'aal1', NULL, NULL, 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/118.0.0.0 Safari/537.36', '94.25.187.158', NULL),
	('ed5401e1-9fd8-4304-b6ed-21129e618e6b', 'b5f563a3-b794-49d0-a0e3-dbf9fffd2321', '2023-12-15 15:12:41.319869+00', '2023-12-15 16:32:10.842692+00', NULL, 'aal1', NULL, '2023-12-15 16:32:10.842622', 'Deno/1.38.4', '94.25.187.158', NULL),
	('73a4d827-c6ea-4ba4-b341-601f97c11793', 'b5f563a3-b794-49d0-a0e3-dbf9fffd2321', '2023-12-15 16:34:01.759597+00', '2023-12-15 16:34:01.759597+00', NULL, 'aal1', NULL, NULL, 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/118.0.0.0 Safari/537.36', '94.25.187.158', NULL),
	('29752073-3cf1-4713-9698-013bd2d6982e', 'b5f563a3-b794-49d0-a0e3-dbf9fffd2321', '2023-12-19 19:15:05.121435+00', '2023-12-19 20:48:38.166282+00', NULL, 'aal1', NULL, '2023-12-19 20:48:38.166205', 'Deno/1.38.4', '94.25.187.158', NULL),
	('946e79ab-b3dc-421b-b4da-c85aabb772f0', 'b5f563a3-b794-49d0-a0e3-dbf9fffd2321', '2023-12-20 11:50:40.524625+00', '2023-12-20 12:43:31.764655+00', NULL, 'aal1', NULL, '2023-12-20 12:43:31.764574', 'Deno/1.38.4', '94.25.187.158', NULL),
	('ec442ecd-1e46-4dd3-8ceb-e8b6e12930a5', 'b5f563a3-b794-49d0-a0e3-dbf9fffd2321', '2023-12-20 14:53:49.484797+00', '2023-12-20 15:20:24.686477+00', NULL, 'aal1', NULL, '2023-12-20 15:20:24.686404', 'Deno/1.38.4', '94.25.187.158', NULL),
	('ba214b77-9e60-40e6-b4bb-aec101dd2e45', 'b5f563a3-b794-49d0-a0e3-dbf9fffd2321', '2023-12-19 04:51:10.849971+00', '2023-12-19 12:48:58.181591+00', NULL, 'aal1', NULL, '2023-12-19 12:48:58.181518', 'Deno/1.38.4', '94.25.187.158', NULL);


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--




--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--




--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: key; Type: TABLE DATA; Schema: pgsodium; Owner: supabase_admin
--



--
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."profiles" ("auth_user_id", "updated_at", "username", "full_name", "avatar_url", "website", "id") VALUES
	('b5f563a3-b794-49d0-a0e3-dbf9fffd2321', NULL, NULL, NULL, NULL, NULL, 1),
	('e76b244b-6f9e-42fc-b216-5ea74f94bd4c', NULL, NULL, NULL, NULL, NULL, 19),
	('727a5d27-4b66-49ea-a2c1-0bccc7b8e2cd', NULL, NULL, NULL, NULL, NULL, 20);


--
-- Data for Name: countries; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."countries" ("id", "name", "created_at", "updated_at", "found_year", "next_rename_year", "created_by", "updated_by") VALUES
	(1, 'Greece 1', '2023-11-28 06:50:37.146622+00', '2023-11-28 06:50:37.146622+00', -4000, 100, NULL, NULL),
	(2, 'Greece', '2023-12-19 21:09:32.167558+00', '2023-12-19 21:09:32.167558+00', -4005, 100, NULL, NULL),
	(7, 'Arztocka', '2023-12-20 15:31:38.442098+00', '2023-12-20 15:45:21.578367+00', NULL, NULL, 1, 1);


--
-- Data for Name: town; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: authors; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: place; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: event; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: citations; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

INSERT INTO "storage"."buckets" ("id", "name", "owner", "created_at", "updated_at", "public", "avif_autodetection", "file_size_limit", "allowed_mime_types", "owner_id") VALUES
	('avatars', 'avatars', NULL, '2023-11-29 11:39:09.672841+00', '2023-11-29 11:39:09.672841+00', false, false, NULL, NULL, NULL);


--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: supabase_admin
--



--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('"auth"."refresh_tokens_id_seq"', 487, true);


--
-- Name: key_key_id_seq; Type: SEQUENCE SET; Schema: pgsodium; Owner: supabase_admin
--

SELECT pg_catalog.setval('"pgsodium"."key_key_id_seq"', 1, false);


--
-- Name: author_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."author_id_seq"', 1, false);


--
-- Name: citations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."citations_id_seq"', 1, false);


--
-- Name: country_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."country_id_seq"', 7, true);


--
-- Name: event_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."event_id_seq"', 1, false);


--
-- Name: place_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."place_id_seq"', 1, false);


--
-- Name: profiles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."profiles_id_seq"', 20, true);


--
-- Name: town_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."town_id_seq"', 1, false);


--
-- PostgreSQL database dump complete
--

RESET ALL;
