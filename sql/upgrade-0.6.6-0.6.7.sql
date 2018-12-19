DELETE FROM "acl_board_links_boards_user_roles" WHERE acl_board_link_id = (select id from acl_board_links where slug='get_board_lists');

DELETE FROM "acl_board_links" WHERE slug = 'get_board_lists';

SELECT pg_catalog.setval('acl_board_links_seq', (SELECT MAX(id) FROM acl_board_links), true);

INSERT INTO "acl_board_links" ("created", "modified", "name", "url", "method", "slug", "group_id", "is_hide")
VALUES (now(), now(), 'Get Board Lists', '/boards/?/lists', 'GET', 'get_board_lists', '3', '0');

SELECT pg_catalog.setval('acl_board_links_boards_user_roles_seq', (SELECT MAX(id) FROM acl_board_links_boards_user_roles), true);

INSERT INTO "acl_board_links_boards_user_roles" ("created", "modified", "acl_board_link_id", "board_user_role_id")
VALUES (now(), now(), (select id from acl_board_links where slug='get_board_lists'), '1');

INSERT INTO "acl_board_links_boards_user_roles" ("created", "modified", "acl_board_link_id", "board_user_role_id")
VALUES (now(), now(), (select id from acl_board_links where slug='get_board_lists'), '2');

DELETE FROM "acl_board_links_boards_user_roles" WHERE acl_board_link_id = (select id from acl_board_links where slug='view_card_isting');

DELETE FROM "acl_board_links" WHERE slug = 'view_card_isting';

SELECT pg_catalog.setval('acl_board_links_seq', (SELECT MAX(id) FROM acl_board_links), true);

INSERT INTO "acl_board_links" ("created", "modified", "name", "url", "method", "slug", "group_id", "is_hide")
VALUES (now(), now(), 'Get Board Lists', '/boards/?/lists/?/cards/?', 'GET', 'view_card_isting', '4', '0');

SELECT pg_catalog.setval('acl_board_links_boards_user_roles_seq', (SELECT MAX(id) FROM acl_board_links_boards_user_roles), true);

INSERT INTO "acl_board_links_boards_user_roles" ("created", "modified", "acl_board_link_id", "board_user_role_id")
VALUES (now(), now(), (select id from acl_board_links where slug='view_card_isting'), '1');

INSERT INTO "acl_board_links_boards_user_roles" ("created", "modified", "acl_board_link_id", "board_user_role_id")
VALUES (now(), now(), (select id from acl_board_links where slug='view_card_isting'), '2');

DELETE FROM "acl_board_links_boards_user_roles" WHERE acl_board_link_id = (select id from acl_board_links where slug='view_board_label_isting');

DELETE FROM "acl_board_links" WHERE slug = 'view_board_label_isting';

SELECT pg_catalog.setval('acl_board_links_seq', (SELECT MAX(id) FROM acl_board_links), true);

INSERT INTO "acl_board_links" ("created", "modified", "name", "url", "method", "slug", "group_id", "is_hide")
VALUES (now(), now(), 'Boards labels listing', '/boards/?/labels', 'GET', 'view_board_label_isting', '4', '0');

SELECT pg_catalog.setval('acl_board_links_boards_user_roles_seq', (SELECT MAX(id) FROM acl_board_links_boards_user_roles), true);

INSERT INTO "acl_board_links_boards_user_roles" ("created", "modified", "acl_board_link_id", "board_user_role_id")
VALUES (now(), now(), (select id from acl_board_links where slug='view_board_label_isting'), '1');

INSERT INTO "acl_board_links_boards_user_roles" ("created", "modified", "acl_board_link_id", "board_user_role_id")
VALUES (now(), now(), (select id from acl_board_links where slug='view_board_label_isting'), '2');

CREATE UNIQUE index users_unique_lower_email_idx on users (lower(email));
CREATE UNIQUE index users_unique_lower_username_idx on users(lower(username));
UPDATE users SET email = lower(email), username=lower(username);