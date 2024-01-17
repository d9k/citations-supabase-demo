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




--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."users" ("instance_id", "id", "aud", "role", "email", "encrypted_password", "email_confirmed_at", "invited_at", "confirmation_token", "confirmation_sent_at", "recovery_token", "recovery_sent_at", "email_change_token_new", "email_change", "email_change_sent_at", "last_sign_in_at", "raw_app_meta_data", "raw_user_meta_data", "is_super_admin", "created_at", "updated_at", "phone", "phone_confirmed_at", "phone_change", "phone_change_token", "phone_change_sent_at", "email_change_token_current", "email_change_confirm_status", "banned_until", "reauthentication_token", "reauthentication_sent_at", "is_sso_user", "deleted_at") VALUES
	('00000000-0000-0000-0000-000000000000', 'e76b244b-6f9e-42fc-b216-5ea74f94bd4c', 'authenticated', 'authenticated', 'gavriillarin263@inbox.lv', '$2a$10$W8/g0R7arxlSsdWrn.5hXOqbolOsyQrpCcAKTOEkoIy2Vekr3vgSS', '2023-12-09 05:25:02.817+00', NULL, '', '2023-12-09 05:24:14.076+00', '', '2023-12-24 13:21:13.896693+00', '', '', NULL, '2023-12-24 13:21:25.863108+00', '{"provider": "email", "providers": ["email"], "profile_id": 19}', NULL, NULL, '2023-12-09 05:24:14.065+00', '2023-12-24 23:26:51.847117+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL),
	('00000000-0000-0000-0000-000000000000', 'ccdcd9a1-2df3-4cdf-8298-a37cd209dd0d', 'authenticated', 'authenticated', 'd9kd9k@gmail.com', '$2a$10$Nn9Lq26n.a2r92jcs25UI./rgH5OBb1gV6db5GhX.phqVA//i/Lmy', '2023-12-21 14:03:46.059171+00', NULL, '', '2023-12-21 13:53:06.021026+00', '', '2023-12-24 23:31:21.017153+00', '', '', NULL, '2023-12-24 23:31:41.685951+00', '{"provider": "email", "providers": ["email"], "profile_id": 21, "claim_edit_all_content": 1}', '{}', NULL, '2023-12-21 13:53:06.009726+00', '2023-12-25 10:58:20.440871+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL),
	('00000000-0000-0000-0000-000000000000', '727a5d27-4b66-49ea-a2c1-0bccc7b8e2cd', 'authenticated', 'authenticated', 'd9k@ya.tu', '$2a$10$OR4GYiMa8vFpk1ywBfPrEeL8yj0TCJxO3joYXdlRezx8Kk6eBjmQ.', NULL, NULL, '45bc98dfe84800707f48a82df0ce417215a7869ba20ba657b46012c1', '2023-12-11 20:49:26.158057+00', '', NULL, '', '', NULL, NULL, '{"provider": "email", "providers": ["email"], "profile_id": 20}', '{}', NULL, '2023-12-11 20:49:26.145323+00', '2023-12-11 20:49:29.413083+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL),
	('00000000-0000-0000-0000-000000000000', 'b5f563a3-b794-49d0-a0e3-dbf9fffd2321', 'authenticated', 'authenticated', 'd9k@ya.ru', '$2a$10$BNL19FnvkC6EyYVshokk.e1R3HwylfiHqAp/PEtQY49PgNHxf0Nk2', '2023-11-30 13:20:52.160287+00', NULL, '', '2023-11-30 13:19:57.235919+00', '', '2024-01-17 00:45:30.788095+00', '', '', NULL, '2024-01-17 00:45:45.629306+00', '{"provider": "email", "providers": ["email"], "profile_id": 1, "claim_edit_all_profiles": 1}', '{}', NULL, '2023-11-30 13:19:57.22183+00', '2024-01-17 00:45:45.631061+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL);


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."identities" ("provider_id", "user_id", "identity_data", "provider", "last_sign_in_at", "created_at", "updated_at", "id") VALUES
	('b5f563a3-b794-49d0-a0e3-dbf9fffd2321', 'b5f563a3-b794-49d0-a0e3-dbf9fffd2321', '{"sub": "b5f563a3-b794-49d0-a0e3-dbf9fffd2321", "email": "d9k@ya.ru", "email_verified": false, "phone_verified": false}', 'email', '2023-11-30 13:19:57.231649+00', '2023-11-30 13:19:57.231688+00', '2023-11-30 13:19:57.231688+00', 'ef9a09b6-d37c-4ba9-a4d4-0682d78af774'),
	('727a5d27-4b66-49ea-a2c1-0bccc7b8e2cd', '727a5d27-4b66-49ea-a2c1-0bccc7b8e2cd', '{"sub": "727a5d27-4b66-49ea-a2c1-0bccc7b8e2cd", "email": "d9k@ya.tu", "email_verified": false, "phone_verified": false}', 'email', '2023-12-11 20:49:26.154423+00', '2023-12-11 20:49:26.154477+00', '2023-12-11 20:49:26.154477+00', 'c8974ccd-72ab-40e3-ac96-5997a55d45e5'),
	('ccdcd9a1-2df3-4cdf-8298-a37cd209dd0d', 'ccdcd9a1-2df3-4cdf-8298-a37cd209dd0d', '{"sub": "ccdcd9a1-2df3-4cdf-8298-a37cd209dd0d", "email": "d9kd9k@gmail.com", "email_verified": false, "phone_verified": false}', 'email', '2023-12-21 13:53:06.017681+00', '2023-12-21 13:53:06.017732+00', '2023-12-21 13:53:06.017732+00', 'a75bc2d3-6e20-4b67-b0b7-3fbc3154de60');


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--




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
-- Data for Name: profile; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."profile" ("auth_user_id", "updated_at", "username", "full_name", "avatar_url", "website", "id", "created_at") VALUES
	('e76b244b-6f9e-42fc-b216-5ea74f94bd4c', NULL, 'gavriillarin263', NULL, NULL, NULL, 19, '2023-12-24 19:26:15.651828+00'),
	('b5f563a3-b794-49d0-a0e3-dbf9fffd2321', NULL, 'd9k', 'y66y6y6767', NULL, NULL, 1, '2023-12-24 19:26:15.651828+00'),
	('ccdcd9a1-2df3-4cdf-8298-a37cd209dd0d', NULL, 'd9kd9k', 'D9kD9k', NULL, NULL, 21, '2023-12-24 19:26:15.651828+00'),
	('727a5d27-4b66-49ea-a2c1-0bccc7b8e2cd', NULL, '____1', 'mecheny', NULL, NULL, 20, '2023-12-24 19:26:15.651828+00');


--
-- Data for Name: country; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."country" ("id", "name", "created_at", "updated_at", "found_year", "next_rename_year", "created_by", "updated_by", "table_name", "published_at", "published_by", "unpublished_at", "unpublished_by") VALUES
	(15, 'Ireland 4', '2024-01-14 23:02:41.877146+00', '2024-01-16 22:14:10.656071+00', NULL, NULL, 1, 1, 'country', '2024-01-16 22:11:53.227693+00', 1, '2024-01-16 22:14:10.656071+00', 1),
	(1, 'Greece 1', '2023-11-28 06:50:37.146622+00', '2024-01-16 22:14:16.72311+00', -4000, 100, NULL, 1, 'country', '2024-01-16 22:14:16.72311+00', 1, NULL, NULL),
	(11, 'China 10', '2023-12-21 14:12:45.779946+00', '2024-01-16 22:14:35.744117+00', NULL, NULL, 21, 1, 'country', '2024-01-16 22:14:35.744117+00', 1, NULL, NULL),
	(10, 'Russia', '2023-12-21 10:02:21.791404+00', '2024-01-16 22:15:24.604677+00', NULL, NULL, 1, 1, 'country', '2024-01-16 22:15:24.604677+00', 1, NULL, NULL),
	(12, 'India', '2023-12-24 13:21:46.821053+00', '2024-01-16 22:31:09.410237+00', NULL, NULL, 19, NULL, 'country', '2024-01-16 22:31:09.410237+00', NULL, NULL, NULL),
	(8, 'Greece 5', '2023-12-21 10:00:36.790762+00', '2024-01-17 00:44:05.32167+00', NULL, NULL, 1, 1, 'country', '2024-01-17 00:43:55.107373+00', 1, '2024-01-17 00:44:05.32167+00', 1);


--
-- Data for Name: town; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."town" ("id", "name", "created_at", "updated_at", "country_id", "created_by", "updated_by") VALUES
	(8, 'Moscow', '2023-12-24 23:14:18.601477+00', '2023-12-24 23:53:06.468419+00', 10, NULL, 21),
	(10, 'Lipetsk', '2023-12-24 23:36:11.73928+00', '2023-12-26 04:07:48.785688+00', 10, 1, 1);


--
-- Data for Name: author; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: place; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: event; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: citation; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: content_item; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: trust; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."trust" ("id", "who", "trusts_whom", "end_at") VALUES
	(7, 21, 1, '2023-12-29 00:00:00+00');


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

SELECT pg_catalog.setval('"auth"."refresh_tokens_id_seq"', 1265, true);


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

SELECT pg_catalog.setval('"public"."country_id_seq"', 20, true);


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

SELECT pg_catalog.setval('"public"."profiles_id_seq"', 21, true);


--
-- Name: town_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."town_id_seq"', 11, true);


--
-- Name: trusts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."trusts_id_seq"', 9, true);


--
-- PostgreSQL database dump complete
--

RESET ALL;
