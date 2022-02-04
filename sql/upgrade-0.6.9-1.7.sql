DO $$ 
   BEGIN
        BEGIN
            ALTER TABLE "boards" ADD "is_expand_image_front_of_card" boolean NOT NULL DEFAULT 'false';
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column is_expand_image_front_of_card already exists in boards';
        END;  
  END;
$$;

DO $$ 
   BEGIN
        BEGIN
            ALTER TABLE "boards" ADD "show_pending_checklist_item" boolean NOT NULL DEFAULT 'false';
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column show_pending_checklist_item already exists in boards';
        END;  
  END;
$$;

UPDATE "users" SET "is_intro_video_skipped" = '0';

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
    board.is_expand_image_front_of_card,
    board.show_pending_checklist_item
   FROM ((boards board
     LEFT JOIN users users ON ((users.id = board.user_id)))
     LEFT JOIN organizations organizations ON ((organizations.id = board.organization_id)));

DROP TRIGGER IF EXISTS "label_card_count_update" ON "cards_labels";

CREATE TRIGGER label_card_count_update AFTER INSERT OR DELETE OR UPDATE ON cards_labels FOR EACH ROW EXECUTE PROCEDURE label_card_count_update();

DROP TRIGGER IF EXISTS "update_board_count" ON "boards";

CREATE TRIGGER update_board_count AFTER INSERT OR DELETE OR UPDATE ON boards FOR EACH ROW EXECUTE PROCEDURE update_board_count();

DROP TRIGGER IF EXISTS "update_board_star_count" ON "board_stars";

CREATE TRIGGER update_board_star_count AFTER INSERT OR DELETE OR UPDATE ON board_stars FOR EACH ROW EXECUTE PROCEDURE update_board_star_count();

DROP TRIGGER IF EXISTS "update_board_subscriber_count" ON "board_subscribers";

CREATE TRIGGER update_board_subscriber_count AFTER INSERT OR DELETE OR UPDATE ON board_subscribers FOR EACH ROW EXECUTE PROCEDURE update_board_subscriber_count();

DROP TRIGGER IF EXISTS "update_board_user_count" ON "boards_users";

CREATE TRIGGER update_board_user_count AFTER INSERT OR DELETE OR UPDATE ON boards_users FOR EACH ROW EXECUTE PROCEDURE update_board_user_count();

DROP TRIGGER IF EXISTS "update_card_attachment_count" ON "card_attachments";

CREATE TRIGGER update_card_attachment_count AFTER INSERT OR DELETE OR UPDATE ON card_attachments FOR EACH ROW EXECUTE PROCEDURE update_card_attachment_count();

DROP TRIGGER IF EXISTS "update_card_checklist_count" ON "checklists";

CREATE TRIGGER update_card_checklist_count AFTER INSERT OR DELETE OR UPDATE ON checklists FOR EACH ROW EXECUTE PROCEDURE update_card_checklist_count();

DROP TRIGGER IF EXISTS "update_card_checklist_item_count" ON "checklist_items";

CREATE TRIGGER update_card_checklist_item_count AFTER INSERT OR DELETE OR UPDATE ON checklist_items FOR EACH ROW EXECUTE PROCEDURE update_card_checklist_item_count();

DROP TRIGGER IF EXISTS "update_card_count" ON "cards";

CREATE TRIGGER update_card_count AFTER INSERT OR DELETE OR UPDATE ON cards FOR EACH ROW EXECUTE PROCEDURE update_card_count();

DROP TRIGGER IF EXISTS "update_card_subscriber_count" ON "card_subscribers";

CREATE TRIGGER update_card_subscriber_count AFTER INSERT OR DELETE OR UPDATE ON card_subscribers FOR EACH ROW EXECUTE PROCEDURE update_card_subscriber_count();

DROP TRIGGER IF EXISTS "update_card_user_count" ON "cards_users";

CREATE TRIGGER update_card_user_count AFTER INSERT OR DELETE OR UPDATE ON cards_users FOR EACH ROW EXECUTE PROCEDURE update_card_user_count();

DROP TRIGGER IF EXISTS "update_card_voters_count" ON "card_voters";

CREATE TRIGGER update_card_voters_count AFTER INSERT OR DELETE OR UPDATE ON card_voters FOR EACH ROW EXECUTE PROCEDURE update_card_voters_count();

DROP TRIGGER IF EXISTS "update_list_count" ON "lists";

CREATE TRIGGER update_list_count AFTER INSERT OR DELETE OR UPDATE ON lists FOR EACH ROW EXECUTE PROCEDURE update_list_count();

DROP TRIGGER IF EXISTS "update_list_subscriber_count" ON "list_subscribers";

CREATE TRIGGER update_list_subscriber_count AFTER INSERT OR DELETE OR UPDATE ON list_subscribers FOR EACH ROW EXECUTE PROCEDURE update_list_subscriber_count();

DROP TRIGGER IF EXISTS "update_organization_count" ON "organizations";

CREATE TRIGGER update_organization_count AFTER INSERT OR DELETE OR UPDATE ON organizations FOR EACH ROW EXECUTE PROCEDURE update_organization_count();

DROP TRIGGER IF EXISTS "update_organization_user_count" ON "organizations_users";

CREATE TRIGGER update_organization_user_count AFTER INSERT OR DELETE OR UPDATE ON organizations_users FOR EACH ROW EXECUTE PROCEDURE update_organization_user_count();

DROP TRIGGER IF EXISTS "update_user_delete" ON "users";

CREATE TRIGGER update_user_delete AFTER DELETE ON users FOR EACH ROW EXECUTE PROCEDURE update_user_delete();

DROP TRIGGER IF EXISTS "update_users_user_login_count" ON "user_logins";

CREATE TRIGGER update_users_user_login_count AFTER INSERT OR DELETE OR UPDATE ON user_logins FOR EACH ROW EXECUTE PROCEDURE update_users_user_login_count();

DELETE FROM "settings" WHERE "name" = 'UNSPLASH_API_KEY';

SELECT pg_catalog.setval('settings_id_seq', (SELECT MAX(id) FROM settings), true);

INSERT INTO "settings" ("setting_category_id", "setting_category_parent_id", "name", "value", "description", "type", "options", "label", "order") values ('6', '0', 'UNSPLASH_API_KEY', '', 'Get the Unsplash API Key  by visiting <a href="https://unsplash.com/developers" target="_blank">https://unsplash.com/developers</a>', 'text', NULL, 'Unsplash API Key', '2');

DELETE FROM "acl_board_links_boards_user_roles" WHERE acl_board_link_id = (select id from acl_board_links where slug='get_card_title');
DELETE FROM "acl_board_links" WHERE slug = 'get_card_title';

DELETE FROM "acl_board_links_boards_user_roles" WHERE acl_board_link_id = (select id from acl_board_links where slug='get_card_description');
DELETE FROM "acl_board_links" WHERE slug = 'get_card_description';

DELETE FROM "acl_board_links_boards_user_roles" WHERE acl_board_link_id = (select id from acl_board_links where slug='get_card_due_date');
DELETE FROM "acl_board_links" WHERE slug = 'get_card_due_date';

DELETE FROM "acl_board_links_boards_user_roles" WHERE acl_board_link_id = (select id from acl_board_links where slug='get_card_member');
DELETE FROM "acl_board_links" WHERE slug = 'get_card_member';

DELETE FROM "acl_board_links_boards_user_roles" WHERE acl_board_link_id = (select id from acl_board_links where slug='get_card_labels');
DELETE FROM "acl_board_links" WHERE slug = 'get_card_labels';

DELETE FROM "acl_board_links_boards_user_roles" WHERE acl_board_link_id = (select id from acl_board_links where slug='get_card_vote');
DELETE FROM "acl_board_links" WHERE slug = 'get_card_vote';

DELETE FROM "acl_board_links_boards_user_roles" WHERE acl_board_link_id = (select id from acl_board_links where slug='get_card_color');
DELETE FROM "acl_board_links" WHERE slug = 'get_card_color';

DELETE FROM "acl_board_links_boards_user_roles" WHERE acl_board_link_id = (select id from acl_board_links where slug='move_card');
DELETE FROM "acl_board_links" WHERE slug = 'move_card';

DELETE FROM "acl_board_links_boards_user_roles" WHERE acl_board_link_id = (select id from acl_board_links where slug='copy_cards');
DELETE FROM "acl_board_links" WHERE slug = 'copy_cards';

DELETE FROM "acl_board_links_boards_user_roles" WHERE acl_board_link_id = (select id from acl_board_links where slug='subscribe_cards');
DELETE FROM "acl_board_links" WHERE slug = 'subscribe_cards';

DELETE FROM "acl_board_links_boards_user_roles" WHERE acl_board_link_id = (select id from acl_board_links where slug='archive_cards');
DELETE FROM "acl_board_links" WHERE slug = 'archive_cards';

DELETE FROM "acl_board_links_boards_user_roles" WHERE acl_board_link_id = (select id from acl_board_links where slug='delete_cards');
DELETE FROM "acl_board_links" WHERE slug = 'delete_cards';

DELETE FROM "acl_board_links_boards_user_roles" WHERE acl_board_link_id = (select id from acl_board_links where slug='get_card_attachment');
DELETE FROM "acl_board_links" WHERE slug = 'get_card_attachment';

DELETE FROM "acl_board_links_boards_user_roles" WHERE acl_board_link_id = (select id from acl_board_links where slug='get_attachment_downloader');
DELETE FROM "acl_board_links" WHERE slug = 'get_attachment_downloader';

DELETE FROM "acl_board_links_boards_user_roles" WHERE acl_board_link_id = (select id from acl_board_links where slug='view_card_activity_feed');
DELETE FROM "acl_board_links" WHERE slug = 'view_card_activity_feed';

DELETE FROM "acl_board_links_boards_user_roles" WHERE acl_board_link_id = (select id from acl_board_links where slug='get_card_comments');
DELETE FROM "acl_board_links" WHERE slug = 'get_card_comments';

DELETE FROM "acl_board_links_boards_user_roles" WHERE acl_board_link_id = (select id from acl_board_links where slug='get_canned_response');
DELETE FROM "acl_board_links" WHERE slug = 'get_canned_response';

DELETE FROM "acl_board_links_boards_user_roles" WHERE acl_board_link_id = (select id from acl_board_links where slug='get_card_checklist');
DELETE FROM "acl_board_links" WHERE slug = 'get_card_checklist';

DELETE FROM "acl_board_links_boards_user_roles" WHERE acl_board_link_id = (select id from acl_board_links where slug='get_card_checklist_item');
DELETE FROM "acl_board_links" WHERE slug = 'get_card_checklist_item';

DELETE FROM "acl_board_links_boards_user_roles" WHERE acl_board_link_id = (select id from acl_board_links where slug='get_card_template');
DELETE FROM "acl_board_links" WHERE slug = 'get_card_template';

DELETE FROM "acl_board_links_boards_user_roles" WHERE acl_board_link_id = (select id from acl_board_links where slug='get_custom_field');
DELETE FROM "acl_board_links" WHERE slug = 'get_custom_field';

DELETE FROM "acl_board_links_boards_user_roles" WHERE acl_board_link_id = (select id from acl_board_links where slug='get_estimated_time');
DELETE FROM "acl_board_links" WHERE slug = 'get_estimated_time';

DELETE FROM "acl_board_links_boards_user_roles" WHERE acl_board_link_id = (select id from acl_board_links where slug='get_spent_time');
DELETE FROM "acl_board_links" WHERE slug = 'get_spent_time';

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

DELETE FROM "acl_board_links_boards_user_roles" WHERE acl_board_link_id = (select id from acl_board_links where slug='add_third_party_background');
DELETE FROM "acl_board_links" WHERE slug = 'add_third_party_background';

INSERT INTO "acl_board_links" ("created", "modified", "name", "url", "method", "slug", "group_id", "is_hide") VALUES (now(), now(), 'Upload third party background image to board', '/boards/?', 'PUT', 'add_third_party_background', '2', '0');

INSERT INTO "acl_board_links_boards_user_roles" ("created", "modified", "acl_board_link_id", "board_user_role_id") VALUES 
(now(), now(), (select id from acl_board_links where slug='add_third_party_background'), '1'),
(now(), now(), (select id from acl_board_links where slug='add_third_party_background'), '2');

--
-- Name: user_push_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_push_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--
-- Name: user_push_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE user_push_tokens (
    id bigint DEFAULT nextval('user_push_tokens_id_seq'::regclass) NOT NULL,
    created timestamp NOT NULL,
    modified timestamp NOT NULL,
    user_id bigint DEFAULT (0)::bigint NOT NULL,
    token character varying(255) NOT NULL,
    device_serial character varying(255) DEFAULT NULL,
    device_modal character varying(255) NOT NULL,
    device_brand character varying(255) NOT NULL,
    device_manufacturer character varying(255) NOT NULL,
    device_version character varying(255) NOT NULL,
    app_version character varying(255) NOT NULL,
    device_os character varying(255) NOT NULL,
    appname character varying(255) NOT NULL,
    last_push_notified timestamp DEFAULT NULL,
    is_active boolean NOT NULL DEFAULT true
);

CREATE OR REPLACE VIEW "user_push_tokens_listing" AS
 SELECT user_push_tokens.id,
    to_char(user_push_tokens.created, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS created,
    to_char(user_push_tokens.modified, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS modified,
    user_push_tokens.user_id,
    user_push_tokens.token,
    user_push_tokens.device_serial,
    user_push_tokens.device_modal,
    user_push_tokens.device_brand,
    user_push_tokens.device_manufacturer,
    user_push_tokens.device_version,
    user_push_tokens.app_version,
    user_push_tokens.device_os,
    user_push_tokens.appname,
    users.username,
    users.email,
    users.role_id,
    users.profile_picture_path,
    users.initials,
    users.full_name,
    to_char(user_push_tokens.last_push_notified, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS last_push_notified,
    (user_push_tokens.is_active)::integer AS is_active
   FROM ((user_push_tokens
     LEFT JOIN users ON ((users.id = user_push_tokens.user_id))));

DO $$ 
   BEGIN
        BEGIN
            ALTER TABLE "users" ADD COLUMN "is_saml" boolean NOT NULL DEFAULT 'false';
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column is_saml already exists in users';
        END;  
  END;
$$;

DO $$ 
   BEGIN
        BEGIN
            ALTER TABLE "users" ADD COLUMN "next_community_edition_popup_on" date NULL;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column next_community_edition_popup_on already exists in users';
        END;  
  END;
$$;

DO $$ 
   BEGIN
        BEGIN
            ALTER TABLE "users" ADD COLUMN "is_show_community_edition_popup" boolean NOT NULL DEFAULT 'false';
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column is_show_community_edition_popup already exists in users';
        END;  
  END;
$$;

CREATE OR REPLACE VIEW users_listing AS
 SELECT users.id,
    users.role_id,
    users.username,
    users.password,
    users.email,
    users.full_name,
    users.initials,
    users.about_me,
    users.profile_picture_path,
    users.notification_frequency,
    (users.is_allow_desktop_notification)::integer AS is_allow_desktop_notification,
    (users.is_active)::integer AS is_active,
    (users.is_email_confirmed)::integer AS is_email_confirmed,
    users.created_organization_count,
    users.created_board_count,
    users.joined_organization_count,
    users.list_count,
    users.joined_card_count,
    users.created_card_count,
    users.joined_board_count,
    users.checklist_count,
    users.checklist_item_completed_count,
    users.checklist_item_count,
    users.activity_count,
    users.card_voter_count,
    (users.is_productivity_beats)::integer AS is_productivity_beats,
    ( SELECT array_to_json(array_agg(row_to_json(o.*))) AS array_to_json
           FROM ( SELECT organizations_users_listing.organization_id AS id,
                    organizations_users_listing.name,
                    organizations_users_listing.description,
                    organizations_users_listing.website_url,
                    organizations_users_listing.logo_url,
                    organizations_users_listing.organization_visibility
                   FROM organizations_users_listing organizations_users_listing
                  WHERE (organizations_users_listing.user_id = users.id)
                  ORDER BY organizations_users_listing.id) o) AS organizations,
    users.last_activity_id,
    ( SELECT array_to_json(array_agg(row_to_json(o.*))) AS array_to_json
           FROM ( SELECT boards_stars.id,
                    boards_stars.board_id,
                    boards_stars.user_id,
                    (boards_stars.is_starred)::integer AS is_starred
                   FROM board_stars boards_stars
                  WHERE (boards_stars.user_id = users.id)
                  ORDER BY boards_stars.id) o) AS boards_stars,
    ( SELECT array_to_json(array_agg(row_to_json(o.*))) AS array_to_json
           FROM ( SELECT boards_users.id,
                    boards_users.board_id,
                    boards_users.user_id,
                    boards_users.board_user_role_id,
                    boards.name,
                    boards.background_picture_url,
                    boards.background_pattern_url,
                    boards.background_color
                   FROM (boards_users boards_users
                     JOIN boards ON ((boards.id = boards_users.board_id)))
                  WHERE (boards_users.user_id = users.id)
                  ORDER BY boards_users.id) o) AS boards_users,
    users.last_login_date,
    li.ip AS last_login_ip,
    lci.name AS login_city_name,
    lst.name AS login_state_name,
    lco.name AS login_country_name,
    lower((lco.iso_alpha2)::text) AS login_country_iso2,
    i.ip AS registered_ip,
    rci.name AS register_city_name,
    rst.name AS register_state_name,
    rco.name AS register_country_name,
    lower((rco.iso_alpha2)::text) AS register_country_iso2,
    lt.name AS login_type,
    to_char(users.created, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS created,
    users.user_login_count,
    users.is_send_newsletter,
    users.last_email_notified_activity_id,
    users.owner_board_count,
    users.member_board_count,
    users.owner_organization_count,
    users.member_organization_count,
    users.language,
    (users.is_ldap)::integer AS is_ldap,
    users.timezone,
    users.default_desktop_notification,
    users.is_list_notifications_enabled,
    users.is_card_notifications_enabled,
    users.is_card_members_notifications_enabled,
    users.is_card_labels_notifications_enabled,
    users.is_card_checklists_notifications_enabled,
    users.is_card_attachments_notifications_enabled,
    users.is_intro_video_skipped,
    users.is_invite_from_board,
    users.is_two_factor_authentication_enabled,
    users.persist_card_divider_position,
    (users.is_saml)::integer AS is_saml,
    users.next_community_edition_popup_on,
    users.is_show_community_edition_popup
   FROM (((((((((users users
     LEFT JOIN ips i ON ((i.id = users.ip_id)))
     LEFT JOIN cities rci ON ((rci.id = i.city_id)))
     LEFT JOIN states rst ON ((rst.id = i.state_id)))
     LEFT JOIN countries rco ON ((rco.id = i.country_id)))
     LEFT JOIN ips li ON ((li.id = users.last_login_ip_id)))
     LEFT JOIN cities lci ON ((lci.id = li.city_id)))
     LEFT JOIN states lst ON ((lst.id = li.state_id)))
     LEFT JOIN countries lco ON ((lco.id = li.country_id)))
     LEFT JOIN login_types lt ON ((lt.id = users.login_type_id)));

DELETE FROM "acl_links_roles" WHERE acl_link_id = (select id from acl_links where slug='users_login');

DELETE FROM "acl_links" WHERE slug = 'users_login';

SELECT pg_catalog.setval('acl_links_id_seq', (SELECT MAX(id) FROM acl_links), true);

INSERT INTO "acl_links" ("created", "modified", "name", "url", "method", "slug", "group_id", "is_user_action", "is_guest_action", "is_admin_action", "is_hide") values ('now()', 'now()', 'Login', '/users/login', 'POST', 'users_login', '1', '0', '1', '0', '0');

SELECT pg_catalog.setval('acl_links_roles_roles_id_seq', (SELECT MAX(id) FROM acl_links_roles), true);

INSERT INTO "acl_links_roles" ("created", "modified", "acl_link_id", "role_id") VALUES 
(now(), now(), (select id from acl_links where slug='users_login'), '3');

DELETE FROM "setting_categories" WHERE "name" = 'Mobile App';
INSERT INTO "setting_categories" ("created", "modified", "parent_id", "name", "description", "order") VALUES (now(), now(), NULL, 'Mobile App', NULL, '8');

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
    board.is_expand_image_front_of_card,
    board.show_pending_checklist_item
   FROM ((boards board
     LEFT JOIN users users ON ((users.id = board.user_id)))
     LEFT JOIN organizations organizations ON ((organizations.id = board.organization_id)));

DROP VIEW "organization_listing";
DROP VIEW "organizations_listing";
DROP VIEW "boards_listing";

ALTER TABLE "card_attachments"
ALTER "path" TYPE character varying(255),
ALTER "path" DROP DEFAULT,
ALTER "path" DROP NOT NULL;
COMMENT ON COLUMN "card_attachments"."path" IS '';
COMMENT ON TABLE "card_attachments" IS '';

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
    board.is_expand_image_front_of_card,
    board.show_pending_checklist_item
   FROM ((boards board
     LEFT JOIN users users ON ((users.id = board.user_id)))
     LEFT JOIN organizations organizations ON ((organizations.id = board.organization_id)));

CREATE OR REPLACE VIEW organizations_listing AS
SELECT organizations.id,
    to_char(organizations.created, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS created,
    to_char(organizations.modified, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS modified,
    organizations.user_id,
    organizations.name,
    organizations.website_url,
    organizations.description,
    organizations.logo_url,
    organizations.organization_visibility,
    organizations.organizations_user_count,
    organizations.board_count,
    ( SELECT array_to_json(array_agg(row_to_json(b.*))) AS array_to_json
           FROM ( SELECT boards_listing.id,
                    boards_listing.name,
                    boards_listing.user_id,
                    boards_listing.organization_id,
                    boards_listing.board_visibility,
                    boards_listing.background_color,
                    boards_listing.background_picture_url,
                    boards_listing.commenting_permissions,
                    boards_listing.voting_permissions,
                    ((boards_listing.is_closed)::boolean)::integer AS is_closed,
                    ((boards_listing.is_allow_organization_members_to_join)::boolean)::integer AS is_allow_organization_members_to_join,
                    boards_listing.boards_user_count,
                    boards_listing.list_count,
                    boards_listing.card_count,
                    boards_listing.boards_subscriber_count,
                    boards_listing.background_pattern_url,
                    ((boards_listing.is_show_image_front_of_card)::boolean)::integer AS is_show_image_front_of_card,
                    boards_listing.organization_name,
                    boards_listing.organization_website_url,
                    boards_listing.organization_description,
                    boards_listing.organization_logo_url,
                    boards_listing.organization_visibility,
                    boards_listing.attachments,
                    boards_listing.boards_users
                   FROM boards_listing boards_listing
                  WHERE (boards_listing.organization_id = organizations.id)
                  ORDER BY boards_listing.id) b) AS boards_listing,
    ( SELECT array_to_json(array_agg(row_to_json(c.*))) AS array_to_json
           FROM ( SELECT organizations_users_listing.id,
                    organizations_users_listing.created,
                    organizations_users_listing.modified,
                    organizations_users_listing.user_id,
                    organizations_users_listing.organization_id,
                    organizations_users_listing.organization_user_role_id,
                    organizations_users_listing.role_id,
                    organizations_users_listing.username,
                    organizations_users_listing.email,
                    organizations_users_listing.full_name,
                    organizations_users_listing.initials,
                    organizations_users_listing.about_me,
                    organizations_users_listing.created_organization_count,
                    organizations_users_listing.created_board_count,
                    organizations_users_listing.joined_organization_count,
                    organizations_users_listing.list_count,
                    organizations_users_listing.joined_card_count,
                    organizations_users_listing.created_card_count,
                    organizations_users_listing.joined_board_count,
                    organizations_users_listing.checklist_count,
                    organizations_users_listing.checklist_item_completed_count,
                    organizations_users_listing.checklist_item_count,
                    organizations_users_listing.activity_count,
                    organizations_users_listing.card_voter_count,
                    organizations_users_listing.name,
                    organizations_users_listing.website_url,
                    organizations_users_listing.description,
                    organizations_users_listing.logo_url,
                    organizations_users_listing.organization_visibility,
                    organizations_users_listing.profile_picture_path,
                    organizations_users_listing.boards_users,
                    organizations_users_listing.user_board_count
                   FROM organizations_users_listing organizations_users_listing
                  WHERE (organizations_users_listing.organization_id = organizations.id)
                  ORDER BY organizations_users_listing.id) c) AS organizations_users,
    u.username,
    u.full_name,
    u.initials,
    u.profile_picture_path
   FROM (organizations organizations
     LEFT JOIN users u ON ((u.id = organizations.user_id)));

CREATE OR REPLACE VIEW organization_listing AS
SELECT organizations.id,
    to_char(organizations.created, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS created,
    to_char(organizations.modified, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS modified,
    organizations.user_id,
    organizations.name,
    organizations.website_url,
    organizations.description,
    organizations.logo_url,
    organizations.organization_visibility,
    organizations.organizations_user_count,
    organizations.board_count,
    ( SELECT array_to_json(array_agg(row_to_json(b.*))) AS array_to_json
           FROM ( SELECT boards_listing.id,
                    boards_listing.name,
                    boards_listing.user_id,
                    boards_listing.organization_id,
                    boards_listing.board_visibility,
                    boards_listing.background_color,
                    boards_listing.background_picture_url,
                    boards_listing.commenting_permissions,
                    boards_listing.voting_permissions,
                    ((boards_listing.is_closed)::boolean)::integer AS is_closed,
                    ((boards_listing.is_allow_organization_members_to_join)::boolean)::integer AS is_allow_organization_members_to_join,
                    boards_listing.boards_user_count,
                    boards_listing.list_count,
                    boards_listing.card_count,
                    boards_listing.boards_subscriber_count,
                    boards_listing.background_pattern_url,
                    ((boards_listing.is_show_image_front_of_card)::boolean)::integer AS is_show_image_front_of_card,
                    boards_listing.organization_name,
                    boards_listing.organization_website_url,
                    boards_listing.organization_description,
                    boards_listing.organization_logo_url,
                    boards_listing.organization_visibility,
                    boards_listing.activities,
                    boards_listing.boards_subscribers,
                    boards_listing.boards_stars,
                    boards_listing.attachments,
                    boards_listing.lists,
                    boards_listing.boards_users
                   FROM boards_listing boards_listing
                  WHERE (boards_listing.organization_id = organizations.id)
                  ORDER BY boards_listing.id) b) AS boards_listing,
    ( SELECT array_to_json(array_agg(row_to_json(c.*))) AS array_to_json
           FROM ( SELECT organizations_users_listing.id,
                    organizations_users_listing.created,
                    organizations_users_listing.modified,
                    organizations_users_listing.user_id,
                    organizations_users_listing.organization_id,
                    organizations_users_listing.organization_user_role_id,
                    organizations_users_listing.role_id,
                    organizations_users_listing.username,
                    organizations_users_listing.email,
                    organizations_users_listing.full_name,
                    organizations_users_listing.initials,
                    organizations_users_listing.about_me,
                    organizations_users_listing.created_organization_count,
                    organizations_users_listing.created_board_count,
                    organizations_users_listing.joined_organization_count,
                    organizations_users_listing.list_count,
                    organizations_users_listing.joined_card_count,
                    organizations_users_listing.created_card_count,
                    organizations_users_listing.joined_board_count,
                    organizations_users_listing.checklist_count,
                    organizations_users_listing.checklist_item_completed_count,
                    organizations_users_listing.checklist_item_count,
                    organizations_users_listing.activity_count,
                    organizations_users_listing.card_voter_count,
                    organizations_users_listing.name,
                    organizations_users_listing.website_url,
                    organizations_users_listing.description,
                    organizations_users_listing.logo_url,
                    organizations_users_listing.organization_visibility,
                    organizations_users_listing.profile_picture_path,
                    organizations_users_listing.boards_users,
                    organizations_users_listing.user_board_count
                   FROM organizations_users_listing organizations_users_listing
                  WHERE (organizations_users_listing.organization_id = organizations.id)
                  ORDER BY organizations_users_listing.id) c) AS organizations_users,
    u.username,
    u.full_name,
    u.initials,
    u.profile_picture_path
   FROM (organizations organizations
     LEFT JOIN users u ON ((u.id = organizations.user_id)));

CREATE OR REPLACE VIEW users_listing AS
 SELECT users.id,
    users.role_id,
    users.username,
    users.password,
    users.email,
    users.full_name,
    users.initials,
    users.about_me,
    users.profile_picture_path,
    users.notification_frequency,
    (users.is_allow_desktop_notification)::integer AS is_allow_desktop_notification,
    (users.is_active)::integer AS is_active,
    (users.is_email_confirmed)::integer AS is_email_confirmed,
    users.created_organization_count,
    users.created_board_count,
    users.joined_organization_count,
    users.list_count,
    users.joined_card_count,
    users.created_card_count,
    users.joined_board_count,
    users.checklist_count,
    users.checklist_item_completed_count,
    users.checklist_item_count,
    users.activity_count,
    users.card_voter_count,
    (users.is_productivity_beats)::integer AS is_productivity_beats,
    ( SELECT array_to_json(array_agg(row_to_json(o.*))) AS array_to_json
           FROM ( SELECT organizations_users_listing.organization_id AS id,
                    organizations_users_listing.name,
                    organizations_users_listing.description,
                    organizations_users_listing.website_url,
                    organizations_users_listing.logo_url,
                    organizations_users_listing.organization_visibility
                   FROM organizations_users_listing organizations_users_listing
                  WHERE (organizations_users_listing.user_id = users.id)
                  ORDER BY organizations_users_listing.id) o) AS organizations,
    users.last_activity_id,
    ( SELECT array_to_json(array_agg(row_to_json(o.*))) AS array_to_json
           FROM ( SELECT boards_stars.id,
                    boards_stars.board_id,
                    boards_stars.user_id,
                    (boards_stars.is_starred)::integer AS is_starred
                   FROM board_stars boards_stars
                  WHERE (boards_stars.user_id = users.id)
                  ORDER BY boards_stars.id) o) AS boards_stars,
    ( SELECT array_to_json(array_agg(row_to_json(o.*))) AS array_to_json
           FROM ( SELECT boards_users.id,
                    boards_users.board_id,
                    boards_users.user_id,
                    boards_users.board_user_role_id,
                    boards.name,
                    boards.background_picture_url,
                    boards.background_pattern_url,
                    boards.background_color
                   FROM (boards_users boards_users
                     JOIN boards ON ((boards.id = boards_users.board_id)))
                  WHERE (boards_users.user_id = users.id)
                  ORDER BY boards_users.id) o) AS boards_users,
    users.last_login_date,
    li.ip AS last_login_ip,
    lci.name AS login_city_name,
    lst.name AS login_state_name,
    lco.name AS login_country_name,
    lower((lco.iso_alpha2)::text) AS login_country_iso2,
    i.ip AS registered_ip,
    rci.name AS register_city_name,
    rst.name AS register_state_name,
    rco.name AS register_country_name,
    lower((rco.iso_alpha2)::text) AS register_country_iso2,
    lt.name AS login_type,
    to_char(users.created, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS created,
    users.user_login_count,
    users.is_send_newsletter,
    users.last_email_notified_activity_id,
    users.owner_board_count,
    users.member_board_count,
    users.owner_organization_count,
    users.member_organization_count,
    users.language,
    (users.is_ldap)::integer AS is_ldap,
    users.timezone,
    users.default_desktop_notification,
    users.is_list_notifications_enabled,
    users.is_card_notifications_enabled,
    users.is_card_members_notifications_enabled,
    users.is_card_labels_notifications_enabled,
    users.is_card_checklists_notifications_enabled,
    users.is_card_attachments_notifications_enabled,
    users.is_intro_video_skipped,
    users.is_invite_from_board,
    users.is_two_factor_authentication_enabled,
    users.persist_card_divider_position,
    (users.is_saml)::integer AS is_saml,
    users.next_community_edition_popup_on,
    users.is_show_community_edition_popup
   FROM (((((((((users users
     LEFT JOIN ips i ON ((i.id = users.ip_id)))
     LEFT JOIN cities rci ON ((rci.id = i.city_id)))
     LEFT JOIN states rst ON ((rst.id = i.state_id)))
     LEFT JOIN countries rco ON ((rco.id = i.country_id)))
     LEFT JOIN ips li ON ((li.id = users.last_login_ip_id)))
     LEFT JOIN cities lci ON ((lci.id = li.city_id)))
     LEFT JOIN states lst ON ((lst.id = li.state_id)))
     LEFT JOIN countries lco ON ((lco.id = li.country_id)))
     LEFT JOIN login_types lt ON ((lt.id = users.login_type_id)));