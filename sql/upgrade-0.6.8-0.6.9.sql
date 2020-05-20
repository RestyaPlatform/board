INSERT INTO "acl_links" ("created", "modified", "name", "url", "method", "slug", "group_id", "is_user_action", "is_guest_action", "is_admin_action", "is_hide") values ('now()', 'now()', 'Card search with Custom Field', '/cards/search', 'GET', 'view_card_search_custom_field', '3', '1', '0', '1', '0');

INSERT INTO "acl_links_roles" ("created", "modified", "acl_link_id", "role_id") VALUES 
(now(), now(), (select id from acl_links where slug='view_card_search_custom_field'), '1'),
(now(), now(), (select id from acl_links where slug='view_card_search_custom_field'), '2');