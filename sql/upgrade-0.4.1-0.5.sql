UPDATE "acl_board_links" SET "url" = '/boards/?/lists/?/cards/?/cards_users/?' WHERE "slug" = 'delete_card_user';

SELECT pg_catalog.setval('acl_board_links_boards_user_roles_seq', (SELECT MAX(id) FROM acl_board_links_boards_user_roles), true);

delete from settings where name='STANDARD_LOGIN_ENABLED';