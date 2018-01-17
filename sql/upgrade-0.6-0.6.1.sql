UPDATE acl_board_links SET url = '/boards/?/lists/?/cards/?' WHERE slug = 'move_list_cards';
UPDATE acl_board_links SET url = '/boards/?/lists/?/cards/?', method = 'PUT' WHERE slug = 'archive_card';
UPDATE acl_board_links SET url = '/boaards/?/lists/?', method = 'PUT' WHERE slug = 'archive_list';
UPDATE acl_board_links SET url = '/boards/?/lists/?/cards/?', method = 'PUT' WHERE slug = 'send_back_to_archived_card';
UPDATE acl_board_links SET url = '/boards/?/lists/?' WHERE slug = 'send_back_to_archived_list';
UPDATE users SET is_send_newsletter = 2, timezone = (SELECT value FROM settings WHERE name = 'SITE_TIMEZONE') WHERE id = 1;