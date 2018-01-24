UPDATE acl_board_links SET url = '/boards/?/lists/?/cards/?' WHERE slug = 'move_list_cards';
UPDATE acl_board_links SET url = '/boards/?/lists/?/cards/?', method = 'PUT' WHERE slug = 'archive_card';
UPDATE acl_board_links SET url = '/boaards/?/lists/?', method = 'PUT' WHERE slug = 'archive_list';
UPDATE acl_board_links SET url = '/boards/?/lists/?/cards/?', method = 'PUT' WHERE slug = 'send_back_to_archived_card';
UPDATE acl_board_links SET url = '/boards/?/lists/?' WHERE slug = 'send_back_to_archived_list';
UPDATE users SET is_send_newsletter = 2, timezone = (SELECT value FROM settings WHERE name = 'SITE_TIMEZONE') WHERE id = 1;
SELECT setval('board_user_roles_seq', (SELECT MAX(id)+1 FROM board_user_roles), false);
SELECT setval('organization_user_roles_seq', (SELECT MAX(id)+1 FROM organization_user_roles), false);

INSERT INTO "oauth_clients" ("client_id", "client_secret", "redirect_uri", "grant_types", "scope", "user_id", "client_name", "client_url", "logo_url", "tos_url", "policy_url", "modified", "created") VALUES ('6728003996146168', '1xqu3wl3bhwffs7j9polccgce2', '', 'client_credentials refresh_token authorization_code', NULL, NULL, 'Gmail Add-on', '', NULL, NULL, NULL, '2018-01-18 12:18:03', '2018-01-18 12:18:03');