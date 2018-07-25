SELECT pg_catalog.setval('setting_categories_id_seq', (SELECT MAX(id) FROM setting_categories), true);
INSERT INTO "setting_categories" ("created", "modified", "parent_id", "name", "description", "order") VALUES (now(), now(), NULL, 'Board', NULL, '6');
INSERT INTO "setting_categories" ("created", "modified", "parent_id", "name", "description", "order") VALUES (now(), now(), NULL, 'User', NULL, '7');
UPDATE "settings" SET "setting_category_id" = (select id from setting_categories where name = 'Board'),"order"='1' WHERE name = 'LABEL_ICON';
UPDATE "settings" SET "setting_category_id" = (select id from setting_categories where name = 'Board'),"order"='2' WHERE name = 'DEFAULT_CARD_VIEW';
UPDATE "settings" SET "setting_category_id" = (select id from setting_categories where name = 'Board'),"order"='3' WHERE name = 'ALLOWED_FILE_EXTENSIONS';
UPDATE "settings" SET "setting_category_id" = (select id from setting_categories where name = 'User'),"order"='2' WHERE name = 'SITE_TIMEZONE';
UPDATE "settings" SET "setting_category_id" = (select id from setting_categories where name = 'User'),"order"='3' WHERE name = 'DEFAULT_LANGUAGE';
INSERT INTO "settings" ("setting_category_id", "setting_category_parent_id", "name", "value", "description", "type", "options", "label", "order")
VALUES ((select id from setting_categories where name = 'User'), NULL, 'IS_TWO_FACTOR_AUTHENTICATION_ENABLED', 'true', 'Is Two Way Factor Authentication is Enabled', 'checkbox', NULL, 'Is Two Way Factor Authentication is Enabled', '1');

 ALTER TABLE "users" ADD "is_two_factor_authentication_enabled" boolean NOT NULL DEFAULT 'false';
ALTER TABLE "users" ADD "two_factor_authentication_hash" character varying(16) NULL;

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

CREATE VIEW created_cards_listing AS
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