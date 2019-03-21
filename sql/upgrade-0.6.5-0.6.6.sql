SELECT pg_catalog.setval('setting_categories_id_seq', (SELECT MAX(id) FROM setting_categories), true);

DELETE FROM "setting_categories" WHERE "name" = 'Board';
INSERT INTO "setting_categories" ("created", "modified", "parent_id", "name", "description", "order") VALUES (now(), now(), NULL, 'Board', NULL, '6');

DELETE FROM "setting_categories" WHERE "name" = 'User';
INSERT INTO "setting_categories" ("created", "modified", "parent_id", "name", "description", "order") VALUES (now(), now(), NULL, 'User', NULL, '7');

UPDATE "settings" SET "setting_category_id" = (select id from setting_categories where name = 'Board'),"order"='1' WHERE name = 'LABEL_ICON';
UPDATE "settings" SET "setting_category_id" = (select id from setting_categories where name = 'Board'),"order"='2' WHERE name = 'DEFAULT_CARD_VIEW';
UPDATE "settings" SET "setting_category_id" = (select id from setting_categories where name = 'Board'),"order"='3' WHERE name = 'ALLOWED_FILE_EXTENSIONS';

UPDATE "settings" SET "setting_category_id" = (select id from setting_categories where name = 'User'),"order"='2' WHERE name = 'SITE_TIMEZONE';
UPDATE "settings" SET "setting_category_id" = (select id from setting_categories where name = 'User'),"order"='3' WHERE name = 'DEFAULT_LANGUAGE';

DELETE FROM "settings" WHERE "name" = 'IS_TWO_FACTOR_AUTHENTICATION_ENABLED';
INSERT INTO "settings" ("setting_category_id", "setting_category_parent_id", "name", "value", "description", "type", "options", "label", "order")
VALUES ((select id from setting_categories where name = 'User'), NULL, 'IS_TWO_FACTOR_AUTHENTICATION_ENABLED', 'true', 'Is Two Way Factor Authentication is Enabled', 'checkbox', NULL, 'Is Two Way Factor Authentication is Enabled', '1');

DO $$ 
   BEGIN

        BEGIN
            ALTER TABLE "users" ADD COLUMN "is_two_factor_authentication_enabled" boolean NOT NULL DEFAULT 'false';
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column is_two_factor_authentication_enabled already exists in users';
        END;  

        BEGIN
            ALTER TABLE "users" ADD COLUMN "two_factor_authentication_hash" character varying(16) NULL;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column two_factor_authentication_hash already exists in users';
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
    users.is_two_factor_authentication_enabled
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

CREATE OR REPLACE VIEW created_cards_listing AS
SELECT b.name AS board_name,
    l.name AS list_name,
    c.id,
    to_char(c.created, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS created,
    to_char(c.modified, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS modified,
    c.board_id,
    c.list_id,
    c.name,
    c.description,
    c.due_date,
    c."position",
    (c.is_archived)::integer AS is_archived,
    c.attachment_count,
    c.checklist_count,
    c.checklist_item_count,
    c.checklist_item_completed_count,
    c.label_count,
    c.cards_user_count,
    c.cards_subscriber_count,
    c.card_voter_count,
    c.activity_count,
    c.user_id AS created_user_id,
    c.color AS card_color,
    (c.is_deleted)::integer AS is_deleted,
    c.comment_count
   FROM cards c
     JOIN boards b ON b.id = c.board_id
     JOIN lists l ON l.id = c.list_id;

DO $$ 
   BEGIN

        BEGIN
            ALTER TABLE "card_attachments" ADD "doc_image_path" character varying(255) NULL;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column doc_image_path already exists in card_attachments';
        END; 
  END;
$$;

CREATE OR REPLACE VIEW "boards_listing" AS
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
    board.sort_direction
   FROM ((boards board
     LEFT JOIN users users ON ((users.id = board.user_id)))
     LEFT JOIN organizations organizations ON ((organizations.id = board.organization_id)));

SELECT pg_catalog.setval('acl_board_links_seq', (SELECT MAX(id) FROM acl_board_links), true);

DELETE FROM "acl_board_links" WHERE "method" = 'DELETE' AND "url" = '/boards/?';

INSERT INTO "acl_board_links" ("created", "modified", "name", "url", "method", "slug", "group_id", "is_hide")
VALUES (now(), now(), 'Delete board', '/boards/?', 'DELETE', 'delete_board', '2', '0');

SELECT pg_catalog.setval('acl_board_links_boards_user_roles_seq', (SELECT MAX(id) FROM acl_board_links_boards_user_roles), true);

INSERT INTO "acl_board_links_boards_user_roles" ("created", "modified", "acl_board_link_id", "board_user_role_id")
VALUES (now(), now(), (select id from acl_board_links where slug='delete_board'), '1');

DO $$ 
   BEGIN

        BEGIN
            ALTER TABLE "user_logins" ADD "is_login_failed" boolean NOT NULL DEFAULT 'false';
            COMMENT ON TABLE "user_logins" IS '';
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column is_login_failed already exists in user_logins';
        END; 
  END;
$$;

CREATE OR REPLACE VIEW "user_logins_listing" AS
 SELECT user_logins.id,
    to_char(user_logins.created, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS created,
    to_char(user_logins.modified, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS modified,
    user_logins.user_agent,
    user_logins.is_login_failed,
    user_logins.user_id,
    user_logins.ip_id,
    users.username,
    users.email,
    users.role_id,
    users.profile_picture_path,
    users.initials,
    users.full_name,
    ips.ip AS login_ip
   FROM ((user_logins
     LEFT JOIN users ON ((users.id = user_logins.user_id)))
     LEFT JOIN ips ON ((ips.id = user_logins.ip_id)));

DO $$ 
   BEGIN

        BEGIN
            ALTER TABLE "activities" ADD "token" character varying(255) NULL; 
            COMMENT ON TABLE "activities" IS '';
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column token already exists in activities';
        END; 
  END;
$$;

CREATE OR REPLACE VIEW "activities_listing" AS
 SELECT activity.id,
    to_char(activity.created, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS created,
    to_char(activity.modified, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS modified,
    activity.board_id,
    activity.list_id,
    activity.card_id,
    activity.user_id,
    activity.foreign_id,
    activity.type,
    activity.comment,
    activity.revisions,
    activity.root,
    activity.freshness_ts,
    activity.depth,
    activity.path,
    activity.materialized_path,
    board.name AS board_name,
    list.name AS list_name,
    card.name AS card_name,
    users.username,
    users.full_name,
    users.profile_picture_path,
    users.initials,
    la.name AS label_name,
    card.description AS card_description,
    users.role_id AS user_role_id,
    checklist_item.name AS checklist_item_name,
    checklist.name AS checklist_item_parent_name,
    checklist1.name AS checklist_name,
    organizations.id AS organization_id,
    organizations.name AS organization_name,
    organizations.logo_url AS organization_logo_url,
    list1.name AS moved_list_name,
    to_char(activity.created, 'HH24:MI'::text) AS created_time,
    card."position" AS card_position,
    card.comment_count,
    users.default_desktop_notification,
    users.is_list_notifications_enabled,
    users.is_card_notifications_enabled,
    users.is_card_members_notifications_enabled,
    users.is_card_labels_notifications_enabled,
    users.is_card_checklists_notifications_enabled,
    users.is_card_attachments_notifications_enabled,
    card.color,
    activity.token
   FROM ((((((((((activities activity
     LEFT JOIN boards board ON ((board.id = activity.board_id)))
     LEFT JOIN lists list ON ((list.id = activity.list_id)))
     LEFT JOIN lists list1 ON ((list1.id = activity.foreign_id)))
     LEFT JOIN cards card ON ((card.id = activity.card_id)))
     LEFT JOIN labels la ON (((la.id = activity.foreign_id) AND ((activity.type)::text = 'add_card_label'::text))))
     LEFT JOIN checklist_items checklist_item ON ((checklist_item.id = activity.foreign_id)))
     LEFT JOIN checklists checklist ON ((checklist.id = checklist_item.checklist_id)))
     LEFT JOIN checklists checklist1 ON ((checklist1.id = activity.foreign_id)))
     LEFT JOIN users users ON ((users.id = activity.user_id)))
     LEFT JOIN organizations organizations ON ((organizations.id = activity.organization_id)));

DO $$ 
   BEGIN

        BEGIN
            ALTER TABLE "boards"
            ADD "support_list_id" bigint NULL,
            ADD "support_custom_fields" text NULL;
            COMMENT ON TABLE "boards" IS '';
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column support_list_id, support_custom_fields already exists in boards';
        END; 
  END;
$$;   

UPDATE "settings" SET
"id" = '18',
"setting_category_id" = '6',
"setting_category_parent_id" = '0',
"name" = 'DROPBOX_APPKEY',
"value" = '',
"description" = 'Get the Dropbox App Key by visiting <a href="https://www.dropbox.com/developers/apps/" target="_blank">https://www.dropbox.com/developers/apps/</a>',
"type" = 'text',
"options" = NULL,
"label" = 'Dropbox App Key',
"order" = '1'
WHERE "id" = '18';



UPDATE "settings" SET
"id" = '20',
"setting_category_id" = '6',
"setting_category_parent_id" = '0',
"name" = 'FLICKR_API_KEY',
"value" = '',
"description" = 'Get the Flickr API Key  by visiting <a href="https://www.flickr.com/services/apps/" target="_blank">https://www.flickr.com/services/apps/</a>',
"type" = 'text',
"options" = NULL,
"label" = 'Flickr API Key',
"order" = '2'
WHERE "id" = '20';

DO $$ 
   BEGIN

        BEGIN
            ALTER TABLE "webhooks"
            ADD "board_id" bigint NULL,
            ADD "type" character varying(255) NOT NULL DEFAULT 'Default',
            ADD "custom_fields" text NOT NULL DEFAULT '';
            COMMENT ON COLUMN "webhooks"."type" IS 'Mattermost, Default';
            COMMENT ON TABLE "webhooks" IS '';
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'board_id,type,custom_fields already exists in webhooks';
        END; 
  END;
$$;   

DO $$ 
   BEGIN
        BEGIN
            ALTER TABLE "webhooks"
            ALTER "name" TYPE character varying(255),
            ALTER "name" DROP DEFAULT,
            ALTER "name" DROP NOT NULL,
            ALTER "description" TYPE character varying(255),
            ALTER "description" DROP DEFAULT,
            ALTER "description" DROP NOT NULL,
            ALTER "secret" TYPE character varying(255),
            ALTER "secret" DROP DEFAULT,
            ALTER "secret" DROP NOT NULL;
            COMMENT ON COLUMN "webhooks"."name" IS '';
            COMMENT ON COLUMN "webhooks"."description" IS '';
            COMMENT ON COLUMN "webhooks"."secret" IS '';
            COMMENT ON TABLE "webhooks" IS '';
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'name,type,description,secret already exists in webhooks';
        END; 
  END;
$$;   

DO $$ 
   BEGIN
        BEGIN
            ALTER TABLE "webhooks"
            ADD "activities_enabled" text NOT NULL DEFAULT '';
            COMMENT ON TABLE "webhooks" IS '';
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'activities_enabled already exists in webhooks';
        END; 
  END;
$$; 