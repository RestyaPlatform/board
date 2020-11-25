DO $$ 
   BEGIN
        BEGIN
            ALTER TABLE "boards" ADD "is_expand_image_front_of_card" boolean NOT NULL DEFAULT 'false';
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column is_expand_image_front_of_card already exists in boards';
        END;  
  END;
$$;

CREATE OR REPLACE VIEW boards_listing AS
 SELECT board.id,
    board.name,
    to_char(board.created, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS created,
    to_char(board.modified, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS modified,
    users.username,
    users.full_name,
    users.profile_picture_path,
    users.initials,
    board.user_id,
    board.organization_id,
    board.board_visibility,
    board.background_color,
    board.background_picture_url,
    board.commenting_permissions,
    board.voting_permissions,
    (board.is_closed)::integer AS is_closed,
    (board.is_allow_organization_members_to_join)::integer AS is_allow_organization_members_to_join,
    board.boards_user_count,
    board.list_count,
    board.card_count,
    board.archived_list_count,
    board.archived_card_count,
    board.boards_subscriber_count,
    board.background_pattern_url,
    (board.is_show_image_front_of_card)::integer AS is_show_image_front_of_card,
    board.music_name,
    board.music_content,
    organizations.name AS organization_name,
    organizations.website_url AS organization_website_url,
    organizations.description AS organization_description,
    organizations.logo_url AS organization_logo_url,
    organizations.organization_visibility,
    ( SELECT array_to_json(array_agg(row_to_json(ba.*))) AS array_to_json
           FROM ( SELECT activities.id,
                    to_char(activities.created, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS created,
                    to_char(activities.modified, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS modified,
                    activities.board_id,
                    activities.list_id,
                    activities.card_id,
                    activities.user_id,
                    activities.foreign_id AS attachment_id,
                    activities.type,
                    activities.comment,
                    activities.revisions,
                    activities.root,
                    activities.freshness_ts,
                    activities.depth,
                    activities.path,
                    activities.materialized_path,
                    users_1.username,
                    users_1.role_id,
                    users_1.profile_picture_path,
                    users_1.initials
                   FROM (activities activities
                     LEFT JOIN users users_1 ON ((users_1.id = activities.user_id)))
                  WHERE (activities.board_id = board.id)
                  ORDER BY activities.freshness_ts DESC, activities.materialized_path
                 OFFSET 0
                 LIMIT 20) ba) AS activities,
    ( SELECT array_to_json(array_agg(row_to_json(bs.*))) AS array_to_json
           FROM ( SELECT boards_subscribers.id,
                    to_char(boards_subscribers.created, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS created,
                    to_char(boards_subscribers.modified, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS modified,
                    boards_subscribers.board_id,
                    boards_subscribers.user_id,
                    (boards_subscribers.is_subscribed)::integer AS is_subscribed
                   FROM board_subscribers boards_subscribers
                  WHERE (boards_subscribers.board_id = board.id)
                  ORDER BY boards_subscribers.id) bs) AS boards_subscribers,
    ( SELECT array_to_json(array_agg(row_to_json(bs.*))) AS array_to_json
           FROM ( SELECT boards_stars.id,
                    to_char(boards_stars.created, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS created,
                    to_char(boards_stars.modified, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS modified,
                    boards_stars.created,
                    boards_stars.modified,
                    boards_stars.board_id,
                    boards_stars.user_id,
                    (boards_stars.is_starred)::integer AS is_starred
                   FROM board_stars boards_stars
                  WHERE (boards_stars.board_id = board.id)
                  ORDER BY boards_stars.id) bs(id, created, modified, created_1, modified_1, board_id, user_id, is_starred)) AS boards_stars,
    ( SELECT array_to_json(array_agg(row_to_json(batt.*))) AS array_to_json
           FROM ( SELECT card_attachments.id,
                    to_char(card_attachments.created, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS created,
                    to_char(card_attachments.modified, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS modified,
                    card_attachments.card_id,
                    card_attachments.name,
                    card_attachments.path,
                    card_attachments.mimetype,
                    card_attachments.list_id,
                    card_attachments.board_id,
                    card_attachments.link,
                    card_attachments.doc_image_path
                   FROM card_attachments card_attachments
                  WHERE (card_attachments.board_id = board.id)
                  ORDER BY card_attachments.id DESC) batt) AS attachments,
    ( SELECT array_to_json(array_agg(row_to_json(bl.*))) AS array_to_json
           FROM ( SELECT lists_listing.id,
                    lists_listing.created,
                    lists_listing.modified,
                    lists_listing.board_id,
                    lists_listing.name,
                    lists_listing."position",
                    ((lists_listing.is_archived)::boolean)::integer AS is_archived,
                    lists_listing.card_count,
                    lists_listing.lists_subscriber_count,
                    lists_listing.cards,
                    lists_listing.lists_subscribers,
                    lists_listing.custom_fields,
                    lists_listing.color
                   FROM lists_listing lists_listing
                  WHERE (lists_listing.board_id = board.id)
                  ORDER BY lists_listing."position") bl) AS lists,
    ( SELECT array_to_json(array_agg(row_to_json(bu.*))) AS array_to_json
           FROM ( SELECT boards_users.id,
                    boards_users.created,
                    boards_users.modified,
                    boards_users.board_id,
                    boards_users.user_id,
                    boards_users.board_user_role_id,
                    boards_users.username,
                    boards_users.email,
                    boards_users.full_name,
                    ((boards_users.is_active)::boolean)::integer AS is_active,
                    ((boards_users.is_email_confirmed)::boolean)::integer AS is_email_confirmed,
                    boards_users.board_name,
                    boards_users.profile_picture_path,
                    boards_users.initials
                   FROM boards_users_listing boards_users
                  WHERE (boards_users.board_id = board.id)
                  ORDER BY boards_users.id) bu) AS boards_users,
    board.default_email_list_id,
    board.is_default_email_position_as_bottom,
    board.custom_fields,
    board.auto_subscribe_on_board,
    board.auto_subscribe_on_card,
    board.sort_by,
    board.sort_direction,
    board.support_list_id,
    board.support_custom_fields,
    board.is_expand_image_front_of_card
   FROM ((boards board
     LEFT JOIN users users ON ((users.id = board.user_id)))
     LEFT JOIN organizations organizations ON ((organizations.id = board.organization_id)));

INSERT INTO "settings" ("setting_category_id", "setting_category_parent_id", "name", "value", "description", "type", "options", "label", "order") values ('6', '0', 'UNSPLASH_API_KEY', '', 'Get the Unsplash API Key  by visiting <a href="https://unsplash.com/developers" target="_blank">https://unsplash.com/developers</a>', 'text', NULL, 'Unsplash API Key', '2');

SELECT pg_catalog.setval('acl_board_links_seq', (SELECT MAX(id) FROM acl_board_links), true);

INSERT INTO "acl_board_links" ("created", "modified", "name", "url", "method", "slug", "group_id", "is_hide") VALUES 
(now(), now(), 'Title', '/boards/?/lists/?/cards', 'GET', 'get_card_title', '5', '0'),
(now(), now(), 'Description', '/boards/?/lists/?/cards', 'GET', 'get_card_description', '5', '0'),
(now(), now(), 'Due Date', '/boards/?/lists/?/cards', 'GET', 'get_card_due_date', '5', '0'),
(now(), now(), 'Member', '/boards/?/lists/?/cards', 'GET', 'get_card_member', '5', '0'),
(now(), now(), 'Labels', '/boards/?/lists/?/cards', 'GET', 'get_card_labels', '5', '0'),
(now(), now(), 'Vote', '/boards/?/lists/?/cards', 'GET', 'get_card_vote', '5', '0'),
(now(), now(), 'Color', '/boards/?/lists/?/cards', 'GET', 'get_card_color', '5', '0'),
(now(), now(), 'Move', '/boards/?/lists/?/cards/?', 'PUT', 'move_card', '5', '0'),
(now(), now(), 'Copy', '/boards/?/lists/?/cards/?/copy', 'POST', 'copy_cards', '5', '0'),
(now(), now(), 'Subscribe', '/boards/?/lists/?/cards/?/card_subscribers', 'POST', 'subscribe_cards', '5', '0'),
(now(), now(), 'Archive', '/boards/?/lists/?/cards/?', 'PUT', 'archive_cards', '5', '0'),
(now(), now(), 'Delete', '/boards/?/lists/?/cards/?', 'PUT', 'delete_cards', '5', '0'),
(now(), now(), 'Attachment', '/boards/?/lists/?/cards', 'GET', 'get_card_attachment', '5', '0'),
(now(), now(), 'Attachment Downloader', '/boards/?/lists/?/cards', 'GET', 'get_attachment_downloader', '5', '0'),
(now(), now(), 'Activity Feed - Display', '/boards/?/lists/?/cards/?/activities', 'GET', 'view_card_activity_feed', '5', '0'),
(now(), now(), 'Comment', '/boards/?/lists/?/cards/?/comments', 'GET', 'get_card_comments', '5', '0'),
(now(), now(), 'Canned Response', '/boards/?/lists/?/cards', 'GET', 'get_canned_response', '5', '0'),
(now(), now(), 'Checklist', '/boards/?/lists/?/cards', 'GET', 'get_card_checklist', '5', '0'),
(now(), now(), 'Checklist Item', '/boards/?/lists/?/cards', 'GET', 'get_card_checklist_item', '5', '0'),
(now(), now(), 'Card Template', '/boards/?/lists/?/cards', 'GET', 'get_card_template', '5', '0'),
(now(), now(), 'Add Custom Field', '/boards/?/lists/?/cards', 'GET', 'get_custom_field', '5', '0'),
(now(), now(), 'Estimated Time Tracking', '/boards/?/lists/?/cards', 'GET', 'get_estimated_time', '5', '0'),
(now(), now(), 'Gantt View', '/boards/?/lists/?/cards', 'GET', 'get_gantt_view', '5', '0'),
(now(), now(), 'Spent Time Tracking', '/boards/?/lists/?/cards', 'GET', 'get_spent_time', '5', '0');

SELECT pg_catalog.setval('acl_board_links_boards_user_roles_seq', (SELECT MAX(id) FROM acl_board_links_boards_user_roles), true);

INSERT INTO "acl_board_links_boards_user_roles" ("created", "modified", "acl_board_link_id", "board_user_role_id") VALUES 
(now(), now(), (select id from acl_board_links where slug='get_card_title'), '1'),
(now(), now(), (select id from acl_board_links where slug='get_card_title'), '2'),
(now(), now(), (select id from acl_board_links where slug='get_card_description'), '1'),
(now(), now(), (select id from acl_board_links where slug='get_card_description'), '2'),
(now(), now(), (select id from acl_board_links where slug='get_card_due_date'), '1'),
(now(), now(), (select id from acl_board_links where slug='get_card_due_date'), '2'),
(now(), now(), (select id from acl_board_links where slug='get_card_member'), '1'),
(now(), now(), (select id from acl_board_links where slug='get_card_member'), '2'),
(now(), now(), (select id from acl_board_links where slug='get_card_labels'), '1'),
(now(), now(), (select id from acl_board_links where slug='get_card_labels'), '2'),
(now(), now(), (select id from acl_board_links where slug='get_card_vote'), '1'),
(now(), now(), (select id from acl_board_links where slug='get_card_vote'), '2'),
(now(), now(), (select id from acl_board_links where slug='get_card_attachment'), '1'),
(now(), now(), (select id from acl_board_links where slug='get_card_attachment'), '2'),
(now(), now(), (select id from acl_board_links where slug='get_card_color'), '1'),
(now(), now(), (select id from acl_board_links where slug='get_card_color'), '2'),
(now(), now(), (select id from acl_board_links where slug='get_card_checklist'), '1'),
(now(), now(), (select id from acl_board_links where slug='get_card_checklist'), '2'),
(now(), now(), (select id from acl_board_links where slug='get_card_checklist_item'), '1'),
(now(), now(), (select id from acl_board_links where slug='get_card_checklist_item'), '2'),
(now(), now(), (select id from acl_board_links where slug='move_card'), '1'),
(now(), now(), (select id from acl_board_links where slug='move_card'), '2'),
(now(), now(), (select id from acl_board_links where slug='copy_cards'), '1'),
(now(), now(), (select id from acl_board_links where slug='copy_cards'), '2'),
(now(), now(), (select id from acl_board_links where slug='subscribe_cards'), '1'),
(now(), now(), (select id from acl_board_links where slug='subscribe_cards'), '2'),
(now(), now(), (select id from acl_board_links where slug='archive_cards'), '1'),
(now(), now(), (select id from acl_board_links where slug='archive_cards'), '2'),
(now(), now(), (select id from acl_board_links where slug='delete_cards'), '1'),
(now(), now(), (select id from acl_board_links where slug='delete_cards'), '2'),
(now(), now(), (select id from acl_board_links where slug='view_card_activity_feed'), '1'),
(now(), now(), (select id from acl_board_links where slug='view_card_activity_feed'), '2'),
(now(), now(), (select id from acl_board_links where slug='get_card_comments'), '1'),
(now(), now(), (select id from acl_board_links where slug='get_card_comments'), '2'),
(now(), now(), (select id from acl_board_links where slug='get_attachment_downloader'), '1'),
(now(), now(), (select id from acl_board_links where slug='get_attachment_downloader'), '2'),
(now(), now(), (select id from acl_board_links where slug='get_canned_response'), '1'),
(now(), now(), (select id from acl_board_links where slug='get_canned_response'), '2'),
(now(), now(), (select id from acl_board_links where slug='get_card_template'), '1'),
(now(), now(), (select id from acl_board_links where slug='get_card_template'), '2'),
(now(), now(), (select id from acl_board_links where slug='get_custom_field'), '1'),
(now(), now(), (select id from acl_board_links where slug='get_custom_field'), '2'),
(now(), now(), (select id from acl_board_links where slug='get_estimated_time'), '1'),
(now(), now(), (select id from acl_board_links where slug='get_estimated_time'), '2'),
(now(), now(), (select id from acl_board_links where slug='get_gantt_view'), '1'),
(now(), now(), (select id from acl_board_links where slug='get_gantt_view'), '2'),
(now(), now(), (select id from acl_board_links where slug='get_spent_time'), '1'),
(now(), now(), (select id from acl_board_links where slug='get_spent_time'), '2');
