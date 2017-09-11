UPDATE "setting_categories" SET "order" = 2 WHERE name = 'Third Party API';

UPDATE "setting_categories" SET "order" = 3 WHERE name = 'IMAP';

INSERT INTO "setting_categories" ("id", "created", "modified", "parent_id", "name", "description", "order") 
values (14, now(), now(), NULL, 'Notifications', NULL, '4');

INSERT INTO "settings" ("setting_category_id", "setting_category_parent_id", "name", "value", "description", "type", "options", "label", "order") 
VALUES
((select id from setting_categories where name = 'Notifications'), '0', 'AUTO_SUBSCRIBE_ON_BOARD', 'Enabled', '', 'select', 'Enabled,Disabled', 'Automatically subscribe a member when he''s added to a board', '1'),
((select id from setting_categories where name = 'Notifications'), '0', 'AUTO_SUBSCRIBE_ON_CARD', 'Enabled', '', 'select', 'Enabled,Disabled', 'Automatically subscribe a member when he''s added to a card', '2'), 
((select id from setting_categories where name = 'Notifications'), '0', 'DEFAULT_EMAIL_NOTIFICATION', 'Instantly', '', 'select', 'Never,Periodically,Instantly', 'Default Email Notification', '3'),
((select id from setting_categories where name = 'Notifications'), '0', 'DEFAULT_DESKTOP_NOTIFICATION', 'Enabled', '', 'select', 'Enabled,Disabled', 'Default Desktop Notification', '4'),
((select id from setting_categories where name = 'Notifications'), '0', 'IS_LIST_NOTIFICATIONS_ENABLED', 'true', '', 'checkbox', NULL, 'List level notification - when updating color, card, move, archive, unarchive, delete', '5'),
((select id from setting_categories where name = 'Notifications'), '0', 'IS_CARD_NOTIFICATIONS_ENABLED', 'true', '', 'checkbox', NULL, 'Card level notification #1 - when updating color, due date, description, move, archive, unarchive, delete', '6'),
((select id from setting_categories where name = 'Notifications'), '0', 'IS_CARD_MEMBERS_NOTIFICATIONS_ENABLED', 'true', '', 'checkbox', NULL, 'Card level notification #2 - when updating members', '7'),
((select id from setting_categories where name = 'Notifications'), '0', 'IS_CARD_LABELS_NOTIFICATIONS_ENABLED', 'true', '', 'checkbox', NULL, 'Card level notification #3 - when updating labels', '8'),
((select id from setting_categories where name = 'Notifications'), '0', 'IS_CARD_CHECKLISTS_NOTIFICATIONS_ENABLED', 'true', '', 'checkbox', NULL, 'Card level notification #4 - when updating checklist', '9'),
((select id from setting_categories where name = 'Notifications'), '0', 'IS_CARD_ATTACHMENTS_NOTIFICATIONS_ENABLED', 'true', '', 'checkbox', NULL, 'Card level notification #5 - when updating attachment', '10');

ALTER TABLE "boards" ADD "auto_subscribe_on_board" boolean NOT NULL DEFAULT 'true';

ALTER TABLE "boards" ADD "auto_subscribe_on_card" boolean NOT NULL DEFAULT 'true';

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
                    card_attachments.link
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
    board.auto_subscribe_on_card
   FROM ((boards board
     LEFT JOIN users users ON ((users.id = board.user_id)))
     LEFT JOIN organizations organizations ON ((organizations.id = board.organization_id)));

ALTER TABLE "users" ADD "default_desktop_notification" boolean NOT NULL DEFAULT 'true';
ALTER TABLE "users" ADD "is_list_notifications_enabled" boolean NOT NULL DEFAULT 'true';
ALTER TABLE "users" ADD "is_card_notifications_enabled" boolean NOT NULL DEFAULT 'true';
ALTER TABLE "users" ADD "is_card_members_notifications_enabled" boolean NOT NULL DEFAULT 'true';
ALTER TABLE "users" ADD "is_card_labels_notifications_enabled" boolean NOT NULL DEFAULT 'true';
ALTER TABLE "users" ADD "is_card_checklists_notifications_enabled" boolean NOT NULL DEFAULT 'true';
ALTER TABLE "users" ADD "is_card_attachments_notifications_enabled" boolean NOT NULL DEFAULT 'true';

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
    users.is_card_attachments_notifications_enabled
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

CREATE OR REPLACE VIEW activities_listing AS
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
    users.is_card_attachments_notifications_enabled
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

SELECT pg_catalog.setval('acl_organization_links_organizations_user_roles_seq', (SELECT MAX(id) FROM acl_organization_links_organizations_user_roles), true);

SELECT pg_catalog.setval('acl_board_links_boards_user_roles_seq', (SELECT MAX(id) FROM acl_board_links_boards_user_roles), true);

SELECT pg_catalog.setval('acl_links_roles_roles_id_seq', (SELECT MAX(id) FROM acl_links_roles), true);

--
-- Name: timezones_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE timezones_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--
-- Name: timezones; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE timezones (
    id bigint DEFAULT nextval('timezones_id_seq'::regclass) NOT NULL,
    created timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    country_iso2 character varying(255),
    country_id bigint,
    code character varying(255),
    utc_offset character varying(255) NOT NULL,
    utc_dst_offset character varying(255),
    name character varying(255)
);


--
-- Data for Name: timezones; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (1, '2017-08-22 16:34:35.976572', '2017-08-22 16:34:35.976572', 'AD', 6, 'Europe/Andorra', '+0200', '+0200', '(GMT+02:00) Andorra');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (2, '2017-08-22 16:34:36.037768', '2017-08-22 16:34:36.037768', 'AE', 238, 'Asia/Dubai', '+0400', '+0400', '(GMT+04:00) Dubai');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (3, '2017-08-22 16:34:36.045667', '2017-08-22 16:34:36.045667', 'AF', 1, 'Asia/Kabul', '+0430', '+0430', '(GMT+04:30) Kabul');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (4, '2017-08-22 16:34:36.054086', '2017-08-22 16:34:36.054086', 'AG', 10, 'America/Port_of_Spain', '-0400', '-0400', '(GMT-04:00) Port of Spain');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (5, '2017-08-22 16:34:36.062487', '2017-08-22 16:34:36.062487', 'AI', 8, 'America/Port_of_Spain', '-0400', '-0400', '(GMT-04:00) Port of Spain');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (6, '2017-08-22 16:34:36.070916', '2017-08-22 16:34:36.070916', 'AL', 3, 'Europe/Tirane', '+0200', '+0200', '(GMT+02:00) Tirane');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (7, '2017-08-22 16:34:36.079059', '2017-08-22 16:34:36.079059', 'AM', 12, 'Asia/Yerevan', '+0400', '+0400', '(GMT+04:00) Yerevan');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (8, '2017-08-22 16:34:36.087409', '2017-08-22 16:34:36.087409', 'AN', 157, 'America/Curacao', '-0400', '-0400', '(GMT-04:00) Curacao');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (9, '2017-08-22 16:34:36.095805', '2017-08-22 16:34:36.095805', 'AO', 7, 'Africa/Lagos', '+0100', '+0100', '(GMT+01:00) Lagos');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (10, '2017-08-22 16:34:36.104323', '2017-08-22 16:34:36.104323', 'AQ', 9, 'Antarctica/Palmer', '-0300', '-0300', '(GMT-03:00) Palmer');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (11, '2017-08-22 16:34:36.112467', '2017-08-22 16:34:36.112467', 'AQ', 9, 'Antarctica/Rothera', '-0300', '-0300', '(GMT-03:00) Rothera');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (12, '2017-08-22 16:34:36.120761', '2017-08-22 16:34:36.120761', 'AQ', 9, 'Antarctica/Syowa', '+0300', '+0300', '(GMT+03:00) Syowa');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (13, '2017-08-22 16:34:36.129199', '2017-08-22 16:34:36.129199', 'AQ', 9, 'Antarctica/Mawson', '+0500', '+0500', '(GMT+05:00) Mawson');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (14, '2017-08-22 16:34:36.137341', '2017-08-22 16:34:36.137341', 'AQ', 9, 'Antarctica/Vostok', '+0600', '+0600', '(GMT+06:00) Vostok');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (15, '2017-08-22 16:34:36.145721', '2017-08-22 16:34:36.145721', 'AQ', 9, 'Antarctica/Davis', '+0700', '+0700', '(GMT+07:00) Davis');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (16, '2017-08-22 16:34:36.154167', '2017-08-22 16:34:36.154167', 'AQ', 9, 'Antarctica/DumontDUrville', '+1000', '+1000', '(GMT+10:00) Dumont D''Urville');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (17, '2017-08-22 16:34:36.162551', '2017-08-22 16:34:36.162551', 'AQ', 9, 'Antarctica/Casey', '+1100', '+1100', '(GMT+11:00) Casey');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (18, '2017-08-22 16:34:36.171105', '2017-08-22 16:34:36.171105', 'AQ', 9, 'Pacific/Auckland', '+1200', '+1200', '(GMT+12:00) Auckland');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (19, '2017-08-22 16:34:36.179216', '2017-08-22 16:34:36.179216', 'AR', 11, 'America/Argentina/Buenos_Aires', '-0300', '-0300', '(GMT-03:00) Buenos Aires');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (20, '2017-08-22 16:34:36.187569', '2017-08-22 16:34:36.187569', 'AS', 5, 'Pacific/Pago_Pago', '-1100', '-1100', '(GMT-11:00) Pago Pago');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (21, '2017-08-22 16:34:36.19588', '2017-08-22 16:34:36.19588', 'AT', 15, 'Europe/Vienna', '+0200', '+0200', '(GMT+02:00) Vienna');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (22, '2017-08-22 16:34:36.204196', '2017-08-22 16:34:36.204196', 'AU', 14, 'Australia/Perth', '+0800', '+0800', '(GMT+08:00) Western Time - Perth');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (23, '2017-08-22 16:34:36.212544', '2017-08-22 16:34:36.212544', 'AU', 14, 'Australia/Adelaide', '+0930', '+0930', '(GMT+09:30) Central Time - Adelaide');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (24, '2017-08-22 16:34:36.221007', '2017-08-22 16:34:36.221007', 'AU', 14, 'Australia/Darwin', '+0930', '+0930', '(GMT+09:30) Central Time - Darwin');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (25, '2017-08-22 16:34:36.229216', '2017-08-22 16:34:36.229216', 'AU', 14, 'Australia/Brisbane', '+1000', '+1000', '(GMT+10:00) Eastern Time - Brisbane');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (26, '2017-08-22 16:34:36.237554', '2017-08-22 16:34:36.237554', 'AU', 14, 'Australia/Hobart', '+1000', '+1000', '(GMT+10:00) Eastern Time - Hobart');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (27, '2017-08-22 16:34:36.245945', '2017-08-22 16:34:36.245945', 'AU', 14, 'Australia/Sydney', '+1000', '+1000', '(GMT+10:00) Eastern Time - Melbourne, Sydney');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (28, '2017-08-22 16:34:36.254327', '2017-08-22 16:34:36.254327', 'AW', 13, 'America/Curacao', '-0400', '-0400', '(GMT-04:00) Curacao');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (29, '2017-08-22 16:34:36.262655', '2017-08-22 16:34:36.262655', 'AX', 2, 'Europe/Helsinki', '+0300', '+0300', '(GMT+03:00) Helsinki');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (30, '2017-08-22 16:34:36.271091', '2017-08-22 16:34:36.271091', 'AZ', 16, 'Asia/Baku', '+0400', '+0400', '(GMT+04:00) Baku');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (31, '2017-08-22 16:34:36.27924', '2017-08-22 16:34:36.27924', 'BA', 29, 'Europe/Belgrade', '+0200', '+0200', '(GMT+02:00) Central European Time - Belgrade');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (32, '2017-08-22 16:34:36.287439', '2017-08-22 16:34:36.287439', 'BB', 20, 'America/Barbados', '-0400', '-0400', '(GMT-04:00) Barbados');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (33, '2017-08-22 16:34:36.295827', '2017-08-22 16:34:36.295827', 'BD', 19, 'Asia/Dhaka', '+0600', '+0600', '(GMT+06:00) Dhaka');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (34, '2017-08-22 16:34:36.30423', '2017-08-22 16:34:36.30423', 'BE', 22, 'Europe/Brussels', '+0200', '+0200', '(GMT+02:00) Brussels');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (35, '2017-08-22 16:34:36.312621', '2017-08-22 16:34:36.312621', 'BF', 37, 'Africa/Abidjan', '+0000', '+0000', '(GMT+00:00) Abidjan');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (36, '2017-08-22 16:34:36.320713', '2017-08-22 16:34:36.320713', 'BG', 36, 'Europe/Sofia', '+0300', '+0300', '(GMT+03:00) Sofia');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (37, '2017-08-22 16:34:36.329322', '2017-08-22 16:34:36.329322', 'BH', 18, 'Asia/Qatar', '+0300', '+0300', '(GMT+03:00) Qatar');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (38, '2017-08-22 16:34:36.33766', '2017-08-22 16:34:36.33766', 'BI', 38, 'Africa/Maputo', '+0200', '+0200', '(GMT+02:00) Maputo');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (39, '2017-08-22 16:34:36.34599', '2017-08-22 16:34:36.34599', 'BJ', 24, 'Africa/Lagos', '+0100', '+0100', '(GMT+01:00) Lagos');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (40, '2017-08-22 16:34:36.354214', '2017-08-22 16:34:36.354214', 'BM', 25, 'Atlantic/Bermuda', '-0300', '-0300', '(GMT-03:00) Bermuda');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (41, '2017-08-22 16:34:36.362558', '2017-08-22 16:34:36.362558', 'BN', 35, 'Asia/Brunei', '+0800', '+0800', '(GMT+08:00) Brunei');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (42, '2017-08-22 16:34:36.370878', '2017-08-22 16:34:36.370878', 'BO', 27, 'America/La_Paz', '-0400', '-0400', '(GMT-04:00) La Paz');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (43, '2017-08-22 16:34:36.379067', '2017-08-22 16:34:36.379067', 'BQ', 28, 'America/Curacao', '-0400', '-0400', '(GMT-04:00) Curacao');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (44, '2017-08-22 16:34:36.387568', '2017-08-22 16:34:36.387568', 'BR', 32, 'America/Rio_Branco', '-0500', '-0500', '(GMT-05:00) Rio Branco');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (45, '2017-08-22 16:34:36.395876', '2017-08-22 16:34:36.395876', 'BR', 32, 'America/Boa_Vista', '-0400', '-0400', '(GMT-04:00) Boa Vista');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (46, '2017-08-22 16:34:36.404278', '2017-08-22 16:34:36.404278', 'BR', 32, 'America/Campo_Grande', '-0400', '-0400', '(GMT-04:00) Campo Grande');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (47, '2017-08-22 16:34:36.412421', '2017-08-22 16:34:36.412421', 'BR', 32, 'America/Cuiaba', '-0400', '-0400', '(GMT-04:00) Cuiaba');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (48, '2017-08-22 16:34:36.421006', '2017-08-22 16:34:36.421006', 'BR', 32, 'America/Manaus', '-0400', '-0400', '(GMT-04:00) Manaus');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (49, '2017-08-22 16:34:36.429232', '2017-08-22 16:34:36.429232', 'BR', 32, 'America/Porto_Velho', '-0400', '-0400', '(GMT-04:00) Porto Velho');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (50, '2017-08-22 16:34:36.437695', '2017-08-22 16:34:36.437695', 'BR', 32, 'America/Araguaina', '-0300', '-0300', '(GMT-03:00) Araguaina');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (51, '2017-08-22 16:34:36.445981', '2017-08-22 16:34:36.445981', 'BR', 32, 'America/Bahia', '-0300', '-0300', '(GMT-03:00) Salvador');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (52, '2017-08-22 16:34:36.454206', '2017-08-22 16:34:36.454206', 'BR', 32, 'America/Belem', '-0300', '-0300', '(GMT-03:00) Belem');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (53, '2017-08-22 16:34:36.462591', '2017-08-22 16:34:36.462591', 'BR', 32, 'America/Fortaleza', '-0300', '-0300', '(GMT-03:00) Fortaleza');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (54, '2017-08-22 16:34:36.470897', '2017-08-22 16:34:36.470897', 'BR', 32, 'America/Maceio', '-0300', '-0300', '(GMT-03:00) Maceio');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (55, '2017-08-22 16:34:36.479305', '2017-08-22 16:34:36.479305', 'BR', 32, 'America/Recife', '-0300', '-0300', '(GMT-03:00) Recife');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (56, '2017-08-22 16:34:36.487574', '2017-08-22 16:34:36.487574', 'BR', 32, 'America/Sao_Paulo', '-0300', '-0300', '(GMT-03:00) Sao Paulo');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (57, '2017-08-22 16:34:36.495978', '2017-08-22 16:34:36.495978', 'BR', 32, 'America/Noronha', '-0200', '-0200', '(GMT-02:00) Noronha');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (58, '2017-08-22 16:34:36.504571', '2017-08-22 16:34:36.504571', 'BS', 17, 'America/Nassau', '-0400', '-0400', '(GMT-04:00) Nassau');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (59, '2017-08-22 16:34:36.512711', '2017-08-22 16:34:36.512711', 'BT', 26, 'Asia/Thimphu', '+0600', '+0600', '(GMT+06:00) Thimphu');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (60, '2017-08-22 16:34:36.521159', '2017-08-22 16:34:36.521159', 'BV', 31, 'Africa/Abidjan', '+0000', '+0000', '(GMT+00:00) Abidjan');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (61, '2017-08-22 16:34:36.529386', '2017-08-22 16:34:36.529386', 'BW', 30, 'Africa/Maputo', '+0200', '+0200', '(GMT+02:00) Maputo');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (62, '2017-08-22 16:34:36.537668', '2017-08-22 16:34:36.537668', 'BY', 21, 'Europe/Minsk', '+0300', '+0300', '(GMT+03:00) Minsk');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (63, '2017-08-22 16:34:36.546038', '2017-08-22 16:34:36.546038', 'BZ', 23, 'America/Belize', '-0600', '-0600', '(GMT-06:00) Belize');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (64, '2017-08-22 16:34:36.554437', '2017-08-22 16:34:36.554437', 'CA', 41, 'America/Vancouver', '-0700', '-0700', '(GMT-07:00) Pacific Time - Vancouver');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (65, '2017-08-22 16:34:36.562742', '2017-08-22 16:34:36.562742', 'CA', 41, 'America/Whitehorse', '-0700', '-0700', '(GMT-07:00) Pacific Time - Whitehorse');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (66, '2017-08-22 16:34:36.571004', '2017-08-22 16:34:36.571004', 'CA', 41, 'America/Dawson_Creek', '-0700', '-0700', '(GMT-07:00) Mountain Time - Dawson Creek');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (67, '2017-08-22 16:34:36.579395', '2017-08-22 16:34:36.579395', 'CA', 41, 'America/Edmonton', '-0600', '-0600', '(GMT-06:00) Mountain Time - Edmonton');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (68, '2017-08-22 16:34:36.587808', '2017-08-22 16:34:36.587808', 'CA', 41, 'America/Yellowknife', '-0600', '-0600', '(GMT-06:00) Mountain Time - Yellowknife');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (69, '2017-08-22 16:34:36.596041', '2017-08-22 16:34:36.596041', 'CA', 41, 'America/Regina', '-0600', '-0600', '(GMT-06:00) Central Time - Regina');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (70, '2017-08-22 16:34:36.604222', '2017-08-22 16:34:36.604222', 'CA', 41, 'America/Winnipeg', '-0500', '-0500', '(GMT-05:00) Central Time - Winnipeg');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (71, '2017-08-22 16:34:36.612724', '2017-08-22 16:34:36.612724', 'CA', 41, 'America/Iqaluit', '-0400', '-0400', '(GMT-04:00) Eastern Time - Iqaluit');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (72, '2017-08-22 16:34:36.620968', '2017-08-22 16:34:36.620968', 'CA', 41, 'America/Toronto', '-0400', '-0400', '(GMT-04:00) Eastern Time - Toronto');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (73, '2017-08-22 16:34:36.629385', '2017-08-22 16:34:36.629385', 'CA', 41, 'America/Halifax', '-0300', '-0300', '(GMT-03:00) Atlantic Time - Halifax');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (74, '2017-08-22 16:34:36.637626', '2017-08-22 16:34:36.637626', 'CA', 41, 'America/St_Johns', '-0230', '-0230', '(GMT-02:30) Newfoundland Time - St. Johns');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (75, '2017-08-22 16:34:36.645989', '2017-08-22 16:34:36.645989', 'CC', 49, 'Indian/Cocos', '+0630', '+0630', '(GMT+06:30) Cocos');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (76, '2017-08-22 16:34:36.654293', '2017-08-22 16:34:36.654293', 'CD', 59, 'Africa/Lagos', '+0100', '+0100', '(GMT+01:00) Lagos');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (77, '2017-08-22 16:34:36.662631', '2017-08-22 16:34:36.662631', 'CD', 59, 'Africa/Maputo', '+0200', '+0200', '(GMT+02:00) Maputo');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (78, '2017-08-22 16:34:36.670903', '2017-08-22 16:34:36.670903', 'CF', 44, 'Africa/Lagos', '+0100', '+0100', '(GMT+01:00) Lagos');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (79, '2017-08-22 16:34:36.679364', '2017-08-22 16:34:36.679364', 'CG', 182, 'Africa/Lagos', '+0100', '+0100', '(GMT+01:00) Lagos');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (80, '2017-08-22 16:34:36.687491', '2017-08-22 16:34:36.687491', 'CH', 220, 'Europe/Zurich', '+0200', '+0200', '(GMT+02:00) Zurich');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (81, '2017-08-22 16:34:36.695954', '2017-08-22 16:34:36.695954', 'CI', 110, 'Africa/Abidjan', '+0000', '+0000', '(GMT+00:00) Abidjan');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (82, '2017-08-22 16:34:36.704241', '2017-08-22 16:34:36.704241', 'CK', 52, 'Pacific/Rarotonga', '-1000', '-1000', '(GMT-10:00) Rarotonga');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (83, '2017-08-22 16:34:36.712632', '2017-08-22 16:34:36.712632', 'CL', 46, 'Pacific/Easter', '-0500', '-0500', '(GMT-05:00) Easter Island');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (84, '2017-08-22 16:34:36.721126', '2017-08-22 16:34:36.721126', 'CL', 46, 'America/Punta_Arenas', '-0300', '-0300', '(GMT-03:00) Punta Arenas');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (85, '2017-08-22 16:34:36.743339', '2017-08-22 16:34:36.743339', 'CL', 46, 'America/Santiago', '-0300', '-0300', '(GMT-03:00) Santiago');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (86, '2017-08-22 16:34:36.754324', '2017-08-22 16:34:36.754324', 'CM', 40, 'Africa/Lagos', '+0100', '+0100', '(GMT+01:00) Lagos');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (87, '2017-08-22 16:34:36.762732', '2017-08-22 16:34:36.762732', 'CN', 47, 'Asia/Shanghai', '+0800', '+0800', '(GMT+08:00) China Time - Beijing');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (88, '2017-08-22 16:34:36.771116', '2017-08-22 16:34:36.771116', 'CO', 50, 'America/Bogota', '-0500', '-0500', '(GMT-05:00) Bogota');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (89, '2017-08-22 16:34:36.779393', '2017-08-22 16:34:36.779393', 'CR', 53, 'America/Costa_Rica', '-0600', '-0600', '(GMT-06:00) Costa Rica');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (90, '2017-08-22 16:34:36.787673', '2017-08-22 16:34:36.787673', 'CS', 200, 'Europe/Belgrade', '+0200', '+0200', '(GMT+02:00) Central European Time - Belgrade');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (91, '2017-08-22 16:34:36.796064', '2017-08-22 16:34:36.796064', 'CU', 55, 'America/Havana', '-0400', '-0400', '(GMT-04:00) Havana');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (92, '2017-08-22 16:34:36.804404', '2017-08-22 16:34:36.804404', 'CV', 42, 'Atlantic/Cape_Verde', '-0100', '-0100', '(GMT-01:00) Cape Verde');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (93, '2017-08-22 16:34:36.812727', '2017-08-22 16:34:36.812727', 'CW', 56, 'America/Curacao', '-0400', '-0400', '(GMT-04:00) Curacao');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (94, '2017-08-22 16:34:36.82097', '2017-08-22 16:34:36.82097', 'CX', 48, 'Indian/Christmas', '+0700', '+0700', '(GMT+07:00) Christmas');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (95, '2017-08-22 16:34:36.829133', '2017-08-22 16:34:36.829133', 'CY', 57, 'Asia/Nicosia', '+0300', '+0300', '(GMT+03:00) Nicosia');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (96, '2017-08-22 16:34:36.837672', '2017-08-22 16:34:36.837672', 'CZ', 58, 'Europe/Prague', '+0200', '+0200', '(GMT+02:00) Central European Time - Prague');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (97, '2017-08-22 16:34:36.846025', '2017-08-22 16:34:36.846025', 'DE', 83, 'Europe/Berlin', '+0200', '+0200', '(GMT+02:00) Berlin');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (98, '2017-08-22 16:34:36.854221', '2017-08-22 16:34:36.854221', 'DJ', 61, 'Africa/Nairobi', '+0300', '+0300', '(GMT+03:00) Nairobi');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (99, '2017-08-22 16:34:36.862735', '2017-08-22 16:34:36.862735', 'DK', 60, 'Europe/Copenhagen', '+0200', '+0200', '(GMT+02:00) Copenhagen');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (100, '2017-08-22 16:34:36.871305', '2017-08-22 16:34:36.871305', 'DM', 62, 'America/Port_of_Spain', '-0400', '-0400', '(GMT-04:00) Port of Spain');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (101, '2017-08-22 16:34:36.879202', '2017-08-22 16:34:36.879202', 'DO', 63, 'America/Santo_Domingo', '-0400', '-0400', '(GMT-04:00) Santo Domingo');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (102, '2017-08-22 16:34:36.88778', '2017-08-22 16:34:36.88778', 'DZ', 4, 'Africa/Algiers', '+0100', '+0100', '(GMT+01:00) Algiers');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (103, '2017-08-22 16:34:36.896105', '2017-08-22 16:34:36.896105', 'EC', 65, 'Pacific/Galapagos', '-0600', '-0600', '(GMT-06:00) Galapagos');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (104, '2017-08-22 16:34:36.904371', '2017-08-22 16:34:36.904371', 'EC', 65, 'America/Guayaquil', '-0500', '-0500', '(GMT-05:00) Guayaquil');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (105, '2017-08-22 16:34:36.912777', '2017-08-22 16:34:36.912777', 'EE', 70, 'Europe/Tallinn', '+0300', '+0300', '(GMT+03:00) Tallinn');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (106, '2017-08-22 16:34:36.921007', '2017-08-22 16:34:36.921007', 'EG', 66, 'Africa/Cairo', '+0200', '+0200', '(GMT+02:00) Cairo');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (107, '2017-08-22 16:34:36.929592', '2017-08-22 16:34:36.929592', 'ER', 69, 'Africa/Nairobi', '+0300', '+0300', '(GMT+03:00) Nairobi');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (108, '2017-08-22 16:34:36.937611', '2017-08-22 16:34:36.937611', 'ES', 213, 'Atlantic/Canary', '+0100', '+0100', '(GMT+01:00) Canary Islands');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (109, '2017-08-22 16:34:36.945991', '2017-08-22 16:34:36.945991', 'ES', 213, 'Africa/Ceuta', '+0200', '+0200', '(GMT+02:00) Ceuta');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (110, '2017-08-22 16:34:36.954608', '2017-08-22 16:34:36.954608', 'ES', 213, 'Europe/Madrid', '+0200', '+0200', '(GMT+02:00) Madrid');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (111, '2017-08-22 16:34:36.962729', '2017-08-22 16:34:36.962729', 'ET', 71, 'Africa/Nairobi', '+0300', '+0300', '(GMT+03:00) Nairobi');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (112, '2017-08-22 16:34:36.97095', '2017-08-22 16:34:36.97095', 'FI', 75, 'Europe/Helsinki', '+0300', '+0300', '(GMT+03:00) Helsinki');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (113, '2017-08-22 16:34:36.979405', '2017-08-22 16:34:36.979405', 'FJ', 74, 'Pacific/Fiji', '+1200', '+1200', '(GMT+12:00) Fiji');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (114, '2017-08-22 16:34:36.987741', '2017-08-22 16:34:36.987741', 'FK', 72, 'Atlantic/Stanley', '-0300', '-0300', '(GMT-03:00) Stanley');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (115, '2017-08-22 16:34:36.995964', '2017-08-22 16:34:36.995964', 'FM', 144, 'Pacific/Chuuk', '+1000', '+1000', '(GMT+10:00) Truk');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (116, '2017-08-22 16:34:37.004298', '2017-08-22 16:34:37.004298', 'FM', 144, 'Pacific/Kosrae', '+1100', '+1100', '(GMT+11:00) Kosrae');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (117, '2017-08-22 16:34:37.012627', '2017-08-22 16:34:37.012627', 'FM', 144, 'Pacific/Pohnpei', '+1100', '+1100', '(GMT+11:00) Ponape');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (118, '2017-08-22 16:34:37.021041', '2017-08-22 16:34:37.021041', 'FO', 73, 'Atlantic/Faroe', '+0100', '+0100', '(GMT+01:00) Faeroe');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (119, '2017-08-22 16:34:37.029421', '2017-08-22 16:34:37.029421', 'FR', 76, 'Europe/Paris', '+0200', '+0200', '(GMT+02:00) Paris');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (120, '2017-08-22 16:34:37.03762', '2017-08-22 16:34:37.03762', 'GA', 80, 'Africa/Lagos', '+0100', '+0100', '(GMT+01:00) Lagos');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (121, '2017-08-22 16:34:37.045996', '2017-08-22 16:34:37.045996', 'GB', 239, 'Europe/London', '+0100', '+0100', '(GMT+01:00) London');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (122, '2017-08-22 16:34:37.054672', '2017-08-22 16:34:37.054672', 'GD', 88, 'America/Port_of_Spain', '-0400', '-0400', '(GMT-04:00) Port of Spain');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (123, '2017-08-22 16:34:37.062643', '2017-08-22 16:34:37.062643', 'GE', 82, 'Asia/Tbilisi', '+0400', '+0400', '(GMT+04:00) Tbilisi');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (124, '2017-08-22 16:34:37.071044', '2017-08-22 16:34:37.071044', 'GF', 77, 'America/Cayenne', '-0300', '-0300', '(GMT-03:00) Cayenne');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (125, '2017-08-22 16:34:37.079404', '2017-08-22 16:34:37.079404', 'GG', 92, 'Europe/London', '+0100', '+0100', '(GMT+01:00) London');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (126, '2017-08-22 16:34:37.08769', '2017-08-22 16:34:37.08769', 'GH', 84, 'Africa/Accra', '+0000', '+0000', '(GMT+00:00) Accra');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (127, '2017-08-22 16:34:37.096093', '2017-08-22 16:34:37.096093', 'GI', 85, 'Europe/Gibraltar', '+0200', '+0200', '(GMT+02:00) Gibraltar');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (128, '2017-08-22 16:34:37.104465', '2017-08-22 16:34:37.104465', 'GL', 87, 'America/Thule', '-0300', '-0300', '(GMT-03:00) Thule');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (129, '2017-08-22 16:34:37.112718', '2017-08-22 16:34:37.112718', 'GL', 87, 'America/Godthab', '-0200', '-0200', '(GMT-02:00) Godthab');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (130, '2017-08-22 16:34:37.121086', '2017-08-22 16:34:37.121086', 'GL', 87, 'America/Scoresbysund', '+0000', '+0000', '(GMT+00:00) Scoresbysund');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (131, '2017-08-22 16:34:37.129348', '2017-08-22 16:34:37.129348', 'GL', 87, 'America/Danmarkshavn', '+0000', '+0000', '(GMT+00:00) Danmarkshavn');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (132, '2017-08-22 16:34:37.138092', '2017-08-22 16:34:37.138092', 'GM', 81, 'Africa/Abidjan', '+0000', '+0000', '(GMT+00:00) Abidjan');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (133, '2017-08-22 16:34:37.145948', '2017-08-22 16:34:37.145948', 'GN', 93, 'Africa/Abidjan', '+0000', '+0000', '(GMT+00:00) Abidjan');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (134, '2017-08-22 16:34:37.154179', '2017-08-22 16:34:37.154179', 'GP', 89, 'America/Port_of_Spain', '-0400', '-0400', '(GMT-04:00) Port of Spain');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (135, '2017-08-22 16:34:37.162572', '2017-08-22 16:34:37.162572', 'GQ', 68, 'Africa/Lagos', '+0100', '+0100', '(GMT+01:00) Lagos');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (136, '2017-08-22 16:34:37.171048', '2017-08-22 16:34:37.171048', 'GR', 86, 'Europe/Athens', '+0300', '+0300', '(GMT+03:00) Athens');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (137, '2017-08-22 16:34:37.17923', '2017-08-22 16:34:37.17923', 'GS', 210, 'Atlantic/South_Georgia', '-0200', '-0200', '(GMT-02:00) South Georgia');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (138, '2017-08-22 16:34:37.187575', '2017-08-22 16:34:37.187575', 'GT', 91, 'America/Guatemala', '-0600', '-0600', '(GMT-06:00) Guatemala');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (139, '2017-08-22 16:34:37.195897', '2017-08-22 16:34:37.195897', 'GU', 90, 'Pacific/Guam', '+1000', '+1000', '(GMT+10:00) Guam');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (140, '2017-08-22 16:34:37.204216', '2017-08-22 16:34:37.204216', 'GW', 94, 'Africa/Bissau', '+0000', '+0000', '(GMT+00:00) Bissau');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (141, '2017-08-22 16:34:37.212644', '2017-08-22 16:34:37.212644', 'GY', 95, 'America/Guyana', '-0400', '-0400', '(GMT-04:00) Guyana');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (142, '2017-08-22 16:34:37.220862', '2017-08-22 16:34:37.220862', 'HK', 99, 'Asia/Hong_Kong', '+0800', '+0800', '(GMT+08:00) Hong Kong');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (143, '2017-08-22 16:34:37.229913', '2017-08-22 16:34:37.229913', 'HM', 97, 'Indian/Kerguelen', '+0500', '+0500', '(GMT+05:00) Kerguelen');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (144, '2017-08-22 16:34:37.237564', '2017-08-22 16:34:37.237564', 'HN', 98, 'America/Tegucigalpa', '-0600', '-0600', '(GMT-06:00) Central Time - Tegucigalpa');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (145, '2017-08-22 16:34:37.246015', '2017-08-22 16:34:37.246015', 'HR', 54, 'Europe/Belgrade', '+0200', '+0200', '(GMT+02:00) Central European Time - Belgrade');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (146, '2017-08-22 16:34:37.254332', '2017-08-22 16:34:37.254332', 'HT', 96, 'America/Port-au-Prince', '-0400', '-0400', '(GMT-04:00) Port-au-Prince');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (147, '2017-08-22 16:34:37.262767', '2017-08-22 16:34:37.262767', 'HU', 100, 'Europe/Budapest', '+0200', '+0200', '(GMT+02:00) Budapest');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (148, '2017-08-22 16:34:37.271084', '2017-08-22 16:34:37.271084', 'ID', 103, 'Asia/Jakarta', '+0700', '+0700', '(GMT+07:00) Jakarta');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (149, '2017-08-22 16:34:37.279373', '2017-08-22 16:34:37.279373', 'ID', 103, 'Asia/Makassar', '+0800', '+0800', '(GMT+08:00) Makassar');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (150, '2017-08-22 16:34:37.287697', '2017-08-22 16:34:37.287697', 'ID', 103, 'Asia/Jayapura', '+0900', '+0900', '(GMT+09:00) Jayapura');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (151, '2017-08-22 16:34:37.296023', '2017-08-22 16:34:37.296023', 'IE', 106, 'Europe/Dublin', '+0100', '+0100', '(GMT+01:00) Dublin');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (152, '2017-08-22 16:34:37.304403', '2017-08-22 16:34:37.304403', 'IL', 108, 'Asia/Jerusalem', '+0300', '+0300', '(GMT+03:00) Jerusalem');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (153, '2017-08-22 16:34:37.312762', '2017-08-22 16:34:37.312762', 'IM', 107, 'Europe/London', '+0100', '+0100', '(GMT+01:00) London');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (154, '2017-08-22 16:34:37.321718', '2017-08-22 16:34:37.321718', 'IN', 102, 'Asia/Calcutta', '+0530', '+0530', '(GMT+05:30) India Standard Time');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (155, '2017-08-22 16:34:37.329298', '2017-08-22 16:34:37.329298', 'IO', 33, 'Indian/Chagos', '+0600', '+0600', '(GMT+06:00) Chagos');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (156, '2017-08-22 16:34:37.337606', '2017-08-22 16:34:37.337606', 'IQ', 105, 'Asia/Baghdad', '+0300', '+0300', '(GMT+03:00) Baghdad');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (157, '2017-08-22 16:34:37.346057', '2017-08-22 16:34:37.346057', 'IR', 104, 'Asia/Tehran', '+0430', '+0430', '(GMT+04:30) Tehran');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (158, '2017-08-22 16:34:37.354537', '2017-08-22 16:34:37.354537', 'IS', 101, 'Atlantic/Reykjavik', '+0000', '+0000', '(GMT+00:00) Reykjavik');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (159, '2017-08-22 16:34:37.362595', '2017-08-22 16:34:37.362595', 'IT', 109, 'Europe/Rome', '+0200', '+0200', '(GMT+02:00) Rome');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (160, '2017-08-22 16:34:37.370903', '2017-08-22 16:34:37.370903', 'JE', 113, 'Europe/London', '+0100', '+0100', '(GMT+01:00) London');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (161, '2017-08-22 16:34:37.379246', '2017-08-22 16:34:37.379246', 'JM', 111, 'America/Jamaica', '-0500', '-0500', '(GMT-05:00) Jamaica');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (162, '2017-08-22 16:34:37.387724', '2017-08-22 16:34:37.387724', 'JO', 114, 'Asia/Amman', '+0300', '+0300', '(GMT+03:00) Amman');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (163, '2017-08-22 16:34:37.395928', '2017-08-22 16:34:37.395928', 'JP', 112, 'Asia/Tokyo', '+0900', '+0900', '(GMT+09:00) Tokyo');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (164, '2017-08-22 16:34:37.404414', '2017-08-22 16:34:37.404414', 'KE', 116, 'Africa/Nairobi', '+0300', '+0300', '(GMT+03:00) Nairobi');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (165, '2017-08-22 16:34:37.412741', '2017-08-22 16:34:37.412741', 'KG', 120, 'Asia/Bishkek', '+0600', '+0600', '(GMT+06:00) Bishkek');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (166, '2017-08-22 16:34:37.42106', '2017-08-22 16:34:37.42106', 'KH', 39, 'Asia/Bangkok', '+0700', '+0700', '(GMT+07:00) Bangkok');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (167, '2017-08-22 16:34:37.4294', '2017-08-22 16:34:37.4294', 'KI', 117, 'Pacific/Tarawa', '+1200', '+1200', '(GMT+12:00) Tarawa');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (168, '2017-08-22 16:34:37.437718', '2017-08-22 16:34:37.437718', 'KI', 117, 'Pacific/Kiritimati', '+1400', '+1400', '(GMT+14:00) Kiritimati');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (169, '2017-08-22 16:34:37.445875', '2017-08-22 16:34:37.445875', 'KM', 51, 'Africa/Nairobi', '+0300', '+0300', '(GMT+03:00) Nairobi');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (170, '2017-08-22 16:34:37.454388', '2017-08-22 16:34:37.454388', 'KN', 189, 'America/Port_of_Spain', '-0400', '-0400', '(GMT-04:00) Port of Spain');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (171, '2017-08-22 16:34:37.462855', '2017-08-22 16:34:37.462855', 'KP', 165, 'Asia/Pyongyang', '+0830', '+0830', '(GMT+08:30) Pyongyang');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (172, '2017-08-22 16:34:37.471042', '2017-08-22 16:34:37.471042', 'KR', 211, 'Asia/Seoul', '+0900', '+0900', '(GMT+09:00) Seoul');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (173, '2017-08-22 16:34:37.479578', '2017-08-22 16:34:37.479578', 'KW', 119, 'Asia/Riyadh', '+0300', '+0300', '(GMT+03:00) Riyadh');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (174, '2017-08-22 16:34:37.487726', '2017-08-22 16:34:37.487726', 'KY', 43, 'America/Panama', '-0500', '-0500', '(GMT-05:00) Panama');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (175, '2017-08-22 16:34:37.496069', '2017-08-22 16:34:37.496069', 'KZ', 115, 'Asia/Aqtau', '+0500', '+0500', '(GMT+05:00) Aqtau');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (176, '2017-08-22 16:34:37.504391', '2017-08-22 16:34:37.504391', 'KZ', 115, 'Asia/Aqtobe', '+0500', '+0500', '(GMT+05:00) Aqtobe');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (177, '2017-08-22 16:34:37.512717', '2017-08-22 16:34:37.512717', 'KZ', 115, 'Asia/Almaty', '+0600', '+0600', '(GMT+06:00) Almaty');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (178, '2017-08-22 16:34:37.521098', '2017-08-22 16:34:37.521098', 'LA', 121, 'Asia/Bangkok', '+0700', '+0700', '(GMT+07:00) Bangkok');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (179, '2017-08-22 16:34:37.5294', '2017-08-22 16:34:37.5294', 'LB', 123, 'Asia/Beirut', '+0300', '+0300', '(GMT+03:00) Beirut');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (180, '2017-08-22 16:34:37.537828', '2017-08-22 16:34:37.537828', 'LC', 190, 'America/Port_of_Spain', '-0400', '-0400', '(GMT-04:00) Port of Spain');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (181, '2017-08-22 16:34:37.554368', '2017-08-22 16:34:37.554368', 'LI', 127, 'Europe/Zurich', '+0200', '+0200', '(GMT+02:00) Zurich');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (182, '2017-08-22 16:34:37.562804', '2017-08-22 16:34:37.562804', 'LK', 214, 'Asia/Colombo', '+0530', '+0530', '(GMT+05:30) Colombo');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (183, '2017-08-22 16:34:37.571064', '2017-08-22 16:34:37.571064', 'LR', 125, 'Africa/Monrovia', '+0000', '+0000', '(GMT+00:00) Monrovia');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (184, '2017-08-22 16:34:37.579226', '2017-08-22 16:34:37.579226', 'LS', 124, 'Africa/Johannesburg', '+0200', '+0200', '(GMT+02:00) Johannesburg');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (185, '2017-08-22 16:34:37.587544', '2017-08-22 16:34:37.587544', 'LT', 128, 'Europe/Vilnius', '+0300', '+0300', '(GMT+03:00) Vilnius');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (186, '2017-08-22 16:34:37.596067', '2017-08-22 16:34:37.596067', 'LU', 129, 'Europe/Luxembourg', '+0200', '+0200', '(GMT+02:00) Luxembourg');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (187, '2017-08-22 16:34:37.604343', '2017-08-22 16:34:37.604343', 'LV', 122, 'Europe/Riga', '+0300', '+0300', '(GMT+03:00) Riga');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (188, '2017-08-22 16:34:37.621056', '2017-08-22 16:34:37.621056', 'LY', 126, 'Africa/Tripoli', '+0200', '+0200', '(GMT+02:00) Tripoli');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (189, '2017-08-22 16:34:37.629509', '2017-08-22 16:34:37.629509', 'MA', 150, 'Africa/Casablanca', '+0100', '+0100', '(GMT+01:00) Casablanca');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (190, '2017-08-22 16:34:37.637624', '2017-08-22 16:34:37.637624', 'MC', 146, 'Europe/Monaco', '+0200', '+0200', '(GMT+02:00) Monaco');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (191, '2017-08-22 16:34:37.646178', '2017-08-22 16:34:37.646178', 'MD', 145, 'Europe/Chisinau', '+0300', '+0300', '(GMT+03:00) Chisinau');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (192, '2017-08-22 16:34:37.654567', '2017-08-22 16:34:37.654567', 'ME', 148, 'Europe/Belgrade', '+0200', '+0200', '(GMT+02:00) Central European Time - Belgrade');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (193, '2017-08-22 16:34:37.662903', '2017-08-22 16:34:37.662903', 'MF', 191, 'America/Port_of_Spain', '-0400', '-0400', '(GMT-04:00) Port of Spain');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (194, '2017-08-22 16:34:37.671029', '2017-08-22 16:34:37.671029', 'MG', 132, 'Africa/Nairobi', '+0300', '+0300', '(GMT+03:00) Nairobi');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (195, '2017-08-22 16:34:37.687909', '2017-08-22 16:34:37.687909', 'MH', 138, 'Pacific/Kwajalein', '+1200', '+1200', '(GMT+12:00) Kwajalein');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (196, '2017-08-22 16:34:37.696169', '2017-08-22 16:34:37.696169', 'MH', 138, 'Pacific/Majuro', '+1200', '+1200', '(GMT+12:00) Majuro');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (197, '2017-08-22 16:34:37.704474', '2017-08-22 16:34:37.704474', 'MK', 131, 'Europe/Belgrade', '+0200', '+0200', '(GMT+02:00) Central European Time - Belgrade');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (198, '2017-08-22 16:34:37.712992', '2017-08-22 16:34:37.712992', 'ML', 136, 'Africa/Abidjan', '+0000', '+0000', '(GMT+00:00) Abidjan');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (199, '2017-08-22 16:34:37.721435', '2017-08-22 16:34:37.721435', 'MM', 152, 'Asia/Yangon', '+0630', '+0630', '(GMT+06:30) Rangoon');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (200, '2017-08-22 16:34:37.729491', '2017-08-22 16:34:37.729491', 'MN', 147, 'Asia/Hovd', '+0700', '+0700', '(GMT+07:00) Hovd');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (201, '2017-08-22 16:34:37.737789', '2017-08-22 16:34:37.737789', 'MN', 147, 'Asia/Choibalsan', '+0800', '+0800', '(GMT+08:00) Choibalsan');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (202, '2017-08-22 16:34:37.754521', '2017-08-22 16:34:37.754521', 'MN', 147, 'Asia/Ulaanbaatar', '+0800', '+0800', '(GMT+08:00) Ulaanbaatar');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (203, '2017-08-22 16:34:37.76295', '2017-08-22 16:34:37.76295', 'MO', 130, 'Asia/Macau', '+0800', '+0800', '(GMT+08:00) Macau');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (204, '2017-08-22 16:34:37.771018', '2017-08-22 16:34:37.771018', 'MP', 166, 'Pacific/Guam', '+1000', '+1000', '(GMT+10:00) Guam');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (205, '2017-08-22 16:34:37.779346', '2017-08-22 16:34:37.779346', 'MQ', 139, 'America/Martinique', '-0400', '-0400', '(GMT-04:00) Martinique');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (206, '2017-08-22 16:34:37.787837', '2017-08-22 16:34:37.787837', 'MR', 140, 'Africa/Abidjan', '+0000', '+0000', '(GMT+00:00) Abidjan');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (207, '2017-08-22 16:34:37.796255', '2017-08-22 16:34:37.796255', 'MS', 149, 'America/Port_of_Spain', '-0400', '-0400', '(GMT-04:00) Port of Spain');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (208, '2017-08-22 16:34:37.804554', '2017-08-22 16:34:37.804554', 'MT', 137, 'Europe/Malta', '+0200', '+0200', '(GMT+02:00) Malta');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (209, '2017-08-22 16:34:37.812918', '2017-08-22 16:34:37.812918', 'MU', 141, 'Indian/Mauritius', '+0400', '+0400', '(GMT+04:00) Mauritius');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (210, '2017-08-22 16:34:37.821196', '2017-08-22 16:34:37.821196', 'MV', 135, 'Indian/Maldives', '+0500', '+0500', '(GMT+05:00) Maldives');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (211, '2017-08-22 16:34:37.829624', '2017-08-22 16:34:37.829624', 'MW', 133, 'Africa/Maputo', '+0200', '+0200', '(GMT+02:00) Maputo');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (212, '2017-08-22 16:34:37.837923', '2017-08-22 16:34:37.837923', 'MX', 143, 'America/Tijuana', '-0700', '-0700', '(GMT-07:00) Pacific Time - Tijuana');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (213, '2017-08-22 16:34:37.846247', '2017-08-22 16:34:37.846247', 'MX', 143, 'America/Hermosillo', '-0700', '-0700', '(GMT-07:00) Mountain Time - Hermosillo');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (214, '2017-08-22 16:34:37.854538', '2017-08-22 16:34:37.854538', 'MX', 143, 'America/Mazatlan', '-0600', '-0600', '(GMT-06:00) Mountain Time - Chihuahua, Mazatlan');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (215, '2017-08-22 16:34:37.862911', '2017-08-22 16:34:37.862911', 'MX', 143, 'America/Mexico_City', '-0500', '-0500', '(GMT-05:00) Central Time - Mexico City');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (216, '2017-08-22 16:34:37.871172', '2017-08-22 16:34:37.871172', 'MX', 143, 'America/Cancun', '-0500', '-0500', '(GMT-05:00) America Cancun');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (217, '2017-08-22 16:34:37.879574', '2017-08-22 16:34:37.879574', 'MY', 134, 'Asia/Kuala_Lumpur', '+0800', '+0800', '(GMT+08:00) Kuala Lumpur');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (218, '2017-08-22 16:34:37.887873', '2017-08-22 16:34:37.887873', 'MZ', 151, 'Africa/Maputo', '+0200', '+0200', '(GMT+02:00) Maputo');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (219, '2017-08-22 16:34:37.896253', '2017-08-22 16:34:37.896253', 'NA', 153, 'Africa/Windhoek', '+0100', '+0100', '(GMT+01:00) Windhoek');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (220, '2017-08-22 16:34:37.904591', '2017-08-22 16:34:37.904591', 'NC', 158, 'Pacific/Noumea', '+1100', '+1100', '(GMT+11:00) Noumea');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (221, '2017-08-22 16:34:37.912918', '2017-08-22 16:34:37.912918', 'NE', 161, 'Africa/Lagos', '+0100', '+0100', '(GMT+01:00) Lagos');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (222, '2017-08-22 16:34:37.921193', '2017-08-22 16:34:37.921193', 'NF', 164, 'Pacific/Norfolk', '+1100', '+1100', '(GMT+11:00) Norfolk');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (223, '2017-08-22 16:34:37.92958', '2017-08-22 16:34:37.92958', 'NG', 162, 'Africa/Lagos', '+0100', '+0100', '(GMT+01:00) Lagos');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (224, '2017-08-22 16:34:37.938075', '2017-08-22 16:34:37.938075', 'NI', 160, 'America/Managua', '-0600', '-0600', '(GMT-06:00) Managua');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (225, '2017-08-22 16:34:37.946257', '2017-08-22 16:34:37.946257', 'NL', 156, 'Europe/Amsterdam', '+0200', '+0200', '(GMT+02:00) Amsterdam');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (226, '2017-08-22 16:34:37.954589', '2017-08-22 16:34:37.954589', 'NO', 167, 'Europe/Oslo', '+0200', '+0200', '(GMT+02:00) Oslo');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (227, '2017-08-22 16:34:37.962863', '2017-08-22 16:34:37.962863', 'NP', 155, 'Asia/Katmandu', '+0545', '+0545', '(GMT+05:45) Katmandu');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (228, '2017-08-22 16:34:37.971218', '2017-08-22 16:34:37.971218', 'NR', 154, 'Pacific/Nauru', '+1200', '+1200', '(GMT+12:00) Nauru');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (229, '2017-08-22 16:34:37.979614', '2017-08-22 16:34:37.979614', 'NU', 163, 'Pacific/Niue', '-1100', '-1100', '(GMT-11:00) Niue');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (230, '2017-08-22 16:34:37.987921', '2017-08-22 16:34:37.987921', 'NZ', 159, 'Pacific/Auckland', '+1200', '+1200', '(GMT+12:00) Auckland');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (231, '2017-08-22 16:34:37.99614', '2017-08-22 16:34:37.99614', 'OM', 168, 'Asia/Dubai', '+0400', '+0400', '(GMT+04:00) Dubai');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (232, '2017-08-22 16:34:38.004442', '2017-08-22 16:34:38.004442', 'PA', 172, 'America/Panama', '-0500', '-0500', '(GMT-05:00) Panama');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (233, '2017-08-22 16:34:38.021909', '2017-08-22 16:34:38.021909', 'PE', 175, 'America/Lima', '-0500', '-0500', '(GMT-05:00) Lima');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (234, '2017-08-22 16:34:38.029583', '2017-08-22 16:34:38.029583', 'PF', 78, 'Pacific/Tahiti', '-1000', '-1000', '(GMT-10:00) Tahiti');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (235, '2017-08-22 16:34:38.037916', '2017-08-22 16:34:38.037916', 'PF', 78, 'Pacific/Marquesas', '-0930', '-0930', '(GMT-09:30) Marquesas');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (236, '2017-08-22 16:34:38.046261', '2017-08-22 16:34:38.046261', 'PF', 78, 'Pacific/Gambier', '-0900', '-0900', '(GMT-09:00) Gambier');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (237, '2017-08-22 16:34:38.05463', '2017-08-22 16:34:38.05463', 'PG', 173, 'Pacific/Port_Moresby', '+1000', '+1000', '(GMT+10:00) Port Moresby');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (238, '2017-08-22 16:34:38.063028', '2017-08-22 16:34:38.063028', 'PH', 176, 'Asia/Manila', '+0800', '+0800', '(GMT+08:00) Manila');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (239, '2017-08-22 16:34:38.071237', '2017-08-22 16:34:38.071237', 'PK', 169, 'Asia/Karachi', '+0500', '+0500', '(GMT+05:00) Karachi');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (240, '2017-08-22 16:34:38.08796', '2017-08-22 16:34:38.08796', 'PL', 178, 'Europe/Warsaw', '+0200', '+0200', '(GMT+02:00) Warsaw');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (241, '2017-08-22 16:34:38.096202', '2017-08-22 16:34:38.096202', 'PM', 192, 'America/Miquelon', '-0200', '-0200', '(GMT-02:00) Miquelon');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (242, '2017-08-22 16:34:38.104476', '2017-08-22 16:34:38.104476', 'PN', 177, 'Pacific/Pitcairn', '-0800', '-0800', '(GMT-08:00) Pitcairn');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (243, '2017-08-22 16:34:38.112865', '2017-08-22 16:34:38.112865', 'PR', 180, 'America/Puerto_Rico', '-0400', '-0400', '(GMT-04:00) Puerto Rico');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (244, '2017-08-22 16:34:38.121197', '2017-08-22 16:34:38.121197', 'PS', 171, 'Asia/Gaza', '+0300', '+0300', '(GMT+03:00) Gaza');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (245, '2017-08-22 16:34:38.129656', '2017-08-22 16:34:38.129656', 'PT', 179, 'Atlantic/Azores', '+0000', '+0000', '(GMT+00:00) Azores');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (246, '2017-08-22 16:34:38.137813', '2017-08-22 16:34:38.137813', 'PT', 179, 'Europe/Lisbon', '+0100', '+0100', '(GMT+01:00) Lisbon');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (247, '2017-08-22 16:34:38.154541', '2017-08-22 16:34:38.154541', 'PW', 170, 'Pacific/Palau', '+0900', '+0900', '(GMT+09:00) Palau');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (248, '2017-08-22 16:34:38.162971', '2017-08-22 16:34:38.162971', 'PY', 174, 'America/Asuncion', '-0400', '-0400', '(GMT-04:00) Asuncion');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (249, '2017-08-22 16:34:38.171063', '2017-08-22 16:34:38.171063', 'QA', 181, 'Asia/Qatar', '+0300', '+0300', '(GMT+03:00) Qatar');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (250, '2017-08-22 16:34:38.17955', '2017-08-22 16:34:38.17955', 'RE', 183, 'Indian/Reunion', '+0400', '+0400', '(GMT+04:00) Reunion');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (251, '2017-08-22 16:34:38.187781', '2017-08-22 16:34:38.187781', 'RO', 184, 'Europe/Bucharest', '+0300', '+0300', '(GMT+03:00) Bucharest');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (252, '2017-08-22 16:34:38.196195', '2017-08-22 16:34:38.196195', 'RS', 199, 'Europe/Belgrade', '+0200', '+0200', '(GMT+02:00) Central European Time - Belgrade');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (253, '2017-08-22 16:34:38.204536', '2017-08-22 16:34:38.204536', 'RU', 185, 'Europe/Kaliningrad', '+0200', '+0200', '(GMT+02:00) Moscow-01 - Kaliningrad');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (254, '2017-08-22 16:34:38.229518', '2017-08-22 16:34:38.229518', 'RU', 185, 'Europe/Moscow', '+0300', '+0300', '(GMT+03:00) Moscow+00 - Moscow');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (255, '2017-08-22 16:34:38.237696', '2017-08-22 16:34:38.237696', 'RU', 185, 'Europe/Samara', '+0400', '+0400', '(GMT+04:00) Moscow+01 - Samara');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (256, '2017-08-22 16:34:38.246159', '2017-08-22 16:34:38.246159', 'RU', 185, 'Asia/Yekaterinburg', '+0500', '+0500', '(GMT+05:00) Moscow+02 - Yekaterinburg');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (257, '2017-08-22 16:34:38.254595', '2017-08-22 16:34:38.254595', 'RU', 185, 'Asia/Omsk', '+0600', '+0600', '(GMT+06:00) Moscow+03 - Omsk');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (258, '2017-08-22 16:34:38.263039', '2017-08-22 16:34:38.263039', 'RU', 185, 'Asia/Krasnoyarsk', '+0700', '+0700', '(GMT+07:00) Moscow+04 - Krasnoyarsk');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (259, '2017-08-22 16:34:38.271188', '2017-08-22 16:34:38.271188', 'RU', 185, 'Asia/Irkutsk', '+0800', '+0800', '(GMT+08:00) Moscow+05 - Irkutsk');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (260, '2017-08-22 16:34:38.296189', '2017-08-22 16:34:38.296189', 'RU', 185, 'Asia/Yakutsk', '+0900', '+0900', '(GMT+09:00) Moscow+06 - Yakutsk');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (261, '2017-08-22 16:34:38.30464', '2017-08-22 16:34:38.30464', 'RU', 185, 'Asia/Vladivostok', '+1000', '+1000', '(GMT+10:00) Moscow+07 - Vladivostok');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (262, '2017-08-22 16:34:38.312856', '2017-08-22 16:34:38.312856', 'RU', 185, 'Asia/Magadan', '+1100', '+1100', '(GMT+11:00) Moscow+08 - Magadan');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (263, '2017-08-22 16:34:38.321292', '2017-08-22 16:34:38.321292', 'RU', 185, 'Asia/Kamchatka', '+1200', '+1200', '(GMT+12:00) Moscow+09 - Petropavlovsk-Kamchatskiy');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (264, '2017-08-22 16:34:38.331352', '2017-08-22 16:34:38.331352', 'RW', 186, 'Africa/Maputo', '+0200', '+0200', '(GMT+02:00) Maputo');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (265, '2017-08-22 16:34:38.337834', '2017-08-22 16:34:38.337834', 'SA', 197, 'Asia/Riyadh', '+0300', '+0300', '(GMT+03:00) Riyadh');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (266, '2017-08-22 16:34:38.347537', '2017-08-22 16:34:38.347537', 'SB', 207, 'Pacific/Guadalcanal', '+1100', '+1100', '(GMT+11:00) Guadalcanal');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (267, '2017-08-22 16:34:38.354536', '2017-08-22 16:34:38.354536', 'SC', 201, 'Indian/Mahe', '+0400', '+0400', '(GMT+04:00) Mahe');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (268, '2017-08-22 16:34:38.363942', '2017-08-22 16:34:38.363942', 'SD', 215, 'Africa/Khartoum', '+0300', '+0300', '(GMT+03:00) Khartoum');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (269, '2017-08-22 16:34:38.371061', '2017-08-22 16:34:38.371061', 'SE', 219, 'Europe/Stockholm', '+0200', '+0200', '(GMT+02:00) Stockholm');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (270, '2017-08-22 16:34:38.379541', '2017-08-22 16:34:38.379541', 'SG', 203, 'Asia/Singapore', '+0800', '+0800', '(GMT+08:00) Singapore');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (271, '2017-08-22 16:34:38.387919', '2017-08-22 16:34:38.387919', 'SH', 188, 'Africa/Abidjan', '+0000', '+0000', '(GMT+00:00) Abidjan');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (272, '2017-08-22 16:34:38.396153', '2017-08-22 16:34:38.396153', 'SI', 206, 'Europe/Belgrade', '+0200', '+0200', '(GMT+02:00) Central European Time - Belgrade');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (273, '2017-08-22 16:34:38.404383', '2017-08-22 16:34:38.404383', 'SJ', 217, 'Europe/Oslo', '+0200', '+0200', '(GMT+02:00) Oslo');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (274, '2017-08-22 16:34:38.412845', '2017-08-22 16:34:38.412845', 'SK', 205, 'Europe/Prague', '+0200', '+0200', '(GMT+02:00) Central European Time - Prague');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (275, '2017-08-22 16:34:38.421344', '2017-08-22 16:34:38.421344', 'SL', 202, 'Africa/Abidjan', '+0000', '+0000', '(GMT+00:00) Abidjan');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (276, '2017-08-22 16:34:38.429637', '2017-08-22 16:34:38.429637', 'SM', 195, 'Europe/Rome', '+0200', '+0200', '(GMT+02:00) Rome');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (277, '2017-08-22 16:34:38.437909', '2017-08-22 16:34:38.437909', 'SN', 198, 'Africa/Abidjan', '+0000', '+0000', '(GMT+00:00) Abidjan');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (278, '2017-08-22 16:34:38.446188', '2017-08-22 16:34:38.446188', 'SO', 208, 'Africa/Nairobi', '+0300', '+0300', '(GMT+03:00) Nairobi');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (279, '2017-08-22 16:34:38.456178', '2017-08-22 16:34:38.456178', 'SR', 216, 'America/Paramaribo', '-0300', '-0300', '(GMT-03:00) Paramaribo');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (280, '2017-08-22 16:34:38.464152', '2017-08-22 16:34:38.464152', 'SS', 212, 'Africa/Khartoum', '+0300', '+0300', '(GMT+03:00) Khartoum');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (281, '2017-08-22 16:34:38.472409', '2017-08-22 16:34:38.472409', 'ST', 196, 'Africa/Abidjan', '+0000', '+0000', '(GMT+00:00) Abidjan');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (282, '2017-08-22 16:34:38.480811', '2017-08-22 16:34:38.480811', 'SV', 67, 'America/El_Salvador', '-0600', '-0600', '(GMT-06:00) El Salvador');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (283, '2017-08-22 16:34:38.489084', '2017-08-22 16:34:38.489084', 'SX', 204, 'America/Curacao', '-0400', '-0400', '(GMT-04:00) Curacao');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (284, '2017-08-22 16:34:38.497453', '2017-08-22 16:34:38.497453', 'SY', 221, 'Asia/Damascus', '+0300', '+0300', '(GMT+03:00) Damascus');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (285, '2017-08-22 16:34:38.522574', '2017-08-22 16:34:38.522574', 'SZ', 218, 'Africa/Johannesburg', '+0200', '+0200', '(GMT+02:00) Johannesburg');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (286, '2017-08-22 16:34:38.530848', '2017-08-22 16:34:38.530848', 'TD', 45, 'Africa/Ndjamena', '+0100', '+0100', '(GMT+01:00) Ndjamena');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (287, '2017-08-22 16:34:38.555788', '2017-08-22 16:34:38.555788', 'TF', 79, 'Indian/Kerguelen', '+0500', '+0500', '(GMT+05:00) Kerguelen');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (288, '2017-08-22 16:34:38.564062', '2017-08-22 16:34:38.564062', 'TG', 226, 'Africa/Abidjan', '+0000', '+0000', '(GMT+00:00) Abidjan');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (289, '2017-08-22 16:34:38.580934', '2017-08-22 16:34:38.580934', 'TH', 225, 'Asia/Bangkok', '+0700', '+0700', '(GMT+07:00) Bangkok');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (290, '2017-08-22 16:34:38.589115', '2017-08-22 16:34:38.589115', 'TJ', 223, 'Asia/Dushanbe', '+0500', '+0500', '(GMT+05:00) Dushanbe');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (291, '2017-08-22 16:34:38.597557', '2017-08-22 16:34:38.597557', 'TK', 227, 'Pacific/Fakaofo', '+1300', '+1300', '(GMT+13:00) Fakaofo');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (292, '2017-08-22 16:34:38.614359', '2017-08-22 16:34:38.614359', 'TL', 64, 'Asia/Dili', '+0900', '+0900', '(GMT+09:00) Dili');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (293, '2017-08-22 16:34:38.622691', '2017-08-22 16:34:38.622691', 'TM', 232, 'Asia/Ashgabat', '+0500', '+0500', '(GMT+05:00) Ashgabat');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (294, '2017-08-22 16:34:38.630997', '2017-08-22 16:34:38.630997', 'TN', 230, 'Africa/Tunis', '+0100', '+0100', '(GMT+01:00) Tunis');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (295, '2017-08-22 16:34:38.639739', '2017-08-22 16:34:38.639739', 'TO', 228, 'Pacific/Tongatapu', '+1300', '+1300', '(GMT+13:00) Tongatapu');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (296, '2017-08-22 16:34:38.647646', '2017-08-22 16:34:38.647646', 'TR', 231, 'Europe/Istanbul', '+0300', '+0300', '(GMT+03:00) Istanbul');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (297, '2017-08-22 16:34:38.656459', '2017-08-22 16:34:38.656459', 'TT', 229, 'America/Port_of_Spain', '-0400', '-0400', '(GMT-04:00) Port of Spain');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (298, '2017-08-22 16:34:38.664823', '2017-08-22 16:34:38.664823', 'TV', 234, 'Pacific/Funafuti', '+1200', '+1200', '(GMT+12:00) Funafuti');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (299, '2017-08-22 16:34:38.672896', '2017-08-22 16:34:38.672896', 'TW', 222, 'Asia/Taipei', '+0800', '+0800', '(GMT+08:00) Taipei');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (300, '2017-08-22 16:34:38.681226', '2017-08-22 16:34:38.681226', 'TZ', 224, 'Africa/Nairobi', '+0300', '+0300', '(GMT+03:00) Nairobi');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (301, '2017-08-22 16:34:38.689555', '2017-08-22 16:34:38.689555', 'UA', 237, 'Europe/Kiev', '+0300', '+0300', '(GMT+03:00) Kiev');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (302, '2017-08-22 16:34:38.697872', '2017-08-22 16:34:38.697872', 'UG', 236, 'Africa/Nairobi', '+0300', '+0300', '(GMT+03:00) Nairobi');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (303, '2017-08-22 16:34:38.706228', '2017-08-22 16:34:38.706228', 'UM', 241, 'Pacific/Pago_Pago', '-1100', '-1100', '(GMT-11:00) Pago Pago');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (304, '2017-08-22 16:34:38.71483', '2017-08-22 16:34:38.71483', 'UM', 241, 'Pacific/Honolulu', '-1000', '-1000', '(GMT-10:00) Hawaii Time');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (305, '2017-08-22 16:34:38.722671', '2017-08-22 16:34:38.722671', 'UM', 241, 'Pacific/Wake', '+1200', '+1200', '(GMT+12:00) Wake');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (306, '2017-08-22 16:34:38.731414', '2017-08-22 16:34:38.731414', 'UM', 241, 'Pacific/Enderbury', '+1300', '+1300', '(GMT+13:00) Enderbury');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (307, '2017-08-22 16:34:38.739181', '2017-08-22 16:34:38.739181', 'US', 240, 'Pacific/Honolulu', '-1000', '-1000', '(GMT-10:00) Hawaii Time');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (308, '2017-08-22 16:34:38.747642', '2017-08-22 16:34:38.747642', 'US', 240, 'America/Anchorage', '-0800', '-0800', '(GMT-08:00) Alaska Time');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (309, '2017-08-22 16:34:38.755955', '2017-08-22 16:34:38.755955', 'US', 240, 'America/Los_Angeles', '-0700', '-0700', '(GMT-07:00) Pacific Time');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (310, '2017-08-22 16:34:38.764291', '2017-08-22 16:34:38.764291', 'US', 240, 'America/Denver', '-0600', '-0600', '(GMT-06:00) Mountain Time');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (311, '2017-08-22 16:34:38.772553', '2017-08-22 16:34:38.772553', 'US', 240, 'America/Phoenix', '-0700', '-0700', '(GMT-07:00) Mountain Time - Arizona');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (312, '2017-08-22 16:34:38.780887', '2017-08-22 16:34:38.780887', 'US', 240, 'America/Chicago', '-0500', '-0500', '(GMT-05:00) Central Time');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (313, '2017-08-22 16:34:38.789135', '2017-08-22 16:34:38.789135', 'US', 240, 'America/New_York', '-0400', '-0400', '(GMT-04:00) Eastern Time');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (314, '2017-08-22 16:34:38.797943', '2017-08-22 16:34:38.797943', 'UY', 242, 'America/Montevideo', '-0300', '-0300', '(GMT-03:00) Montevideo');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (315, '2017-08-22 16:34:38.805889', '2017-08-22 16:34:38.805889', 'UZ', 243, 'Asia/Tashkent', '+0500', '+0500', '(GMT+05:00) Tashkent');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (316, '2017-08-22 16:34:38.814223', '2017-08-22 16:34:38.814223', 'VA', 245, 'Europe/Rome', '+0200', '+0200', '(GMT+02:00) Rome');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (317, '2017-08-22 16:34:38.822937', '2017-08-22 16:34:38.822937', 'VC', 193, 'America/Port_of_Spain', '-0400', '-0400', '(GMT-04:00) Port of Spain');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (318, '2017-08-22 16:34:38.830595', '2017-08-22 16:34:38.830595', 'VE', 246, 'America/Caracas', '-0400', '-0400', '(GMT-04:00) Caracas');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (319, '2017-08-22 16:34:38.839184', '2017-08-22 16:34:38.839184', 'VG', 34, 'America/Port_of_Spain', '-0400', '-0400', '(GMT-04:00) Port of Spain');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (320, '2017-08-22 16:34:38.847556', '2017-08-22 16:34:38.847556', 'VI', 235, 'America/Port_of_Spain', '-0400', '-0400', '(GMT-04:00) Port of Spain');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (321, '2017-08-22 16:34:38.85574', '2017-08-22 16:34:38.85574', 'VN', 247, 'Asia/Saigon', '+0700', '+0700', '(GMT+07:00) Hanoi');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (322, '2017-08-22 16:34:38.864114', '2017-08-22 16:34:38.864114', 'VU', 244, 'Pacific/Efate', '+1100', '+1100', '(GMT+11:00) Efate');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (323, '2017-08-22 16:34:38.872445', '2017-08-22 16:34:38.872445', 'WF', 248, 'Pacific/Wallis', '+1200', '+1200', '(GMT+12:00) Wallis');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (324, '2017-08-22 16:34:38.881186', '2017-08-22 16:34:38.881186', 'WS', 194, 'Pacific/Apia', '+1300', '+1300', '(GMT+13:00) Apia');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (325, '2017-08-22 16:34:38.889322', '2017-08-22 16:34:38.889322', 'YE', 250, 'Asia/Riyadh', '+0300', '+0300', '(GMT+03:00) Riyadh');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (326, '2017-08-22 16:34:38.897532', '2017-08-22 16:34:38.897532', 'YT', 142, 'Africa/Nairobi', '+0300', '+0300', '(GMT+03:00) Nairobi');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (327, '2017-08-22 16:34:38.905857', '2017-08-22 16:34:38.905857', 'ZA', 209, 'Africa/Johannesburg', '+0200', '+0200', '(GMT+02:00) Johannesburg');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (328, '2017-08-22 16:34:38.9145', '2017-08-22 16:34:38.9145', 'ZM', 251, 'Africa/Maputo', '+0200', '+0200', '(GMT+02:00) Maputo');
INSERT INTO timezones (id, created, modified, country_iso2, country_id, code, utc_offset, utc_dst_offset, name) VALUES (329, '2017-08-22 16:34:38.922541', '2017-08-22 16:34:38.922541', 'ZW', 252, 'Africa/Maputo', '+0200', '+0200', '(GMT+02:00) Maputo');

UPDATE "settings" SET "type" = 'select' WHERE "name" = 'SITE_TIMEZONE';

ALTER TABLE "cards" ADD "is_due_date_notification_sent" boolean NOT NULL DEFAULT 'false';

CREATE OR REPLACE VIEW cards_listing AS
SELECT cards.id,
    to_char(cards.created, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS created,
    to_char(cards.modified, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS modified,
    cards.board_id,
    cards.list_id,
    cards.name,
    cards.description,
    to_char(cards.due_date, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS due_date,
    to_date(to_char(cards.due_date, 'YYYY/MM/DD'::text), 'YYYY/MM/DD'::text) AS to_date,
    cards."position",
    (cards.is_archived)::integer AS is_archived,
    cards.attachment_count,
    cards.checklist_count,
    cards.checklist_item_count,
    cards.checklist_item_completed_count,
    cards.label_count,
    cards.cards_user_count,
    cards.cards_subscriber_count,
    cards.card_voter_count,
    cards.activity_count,
    cards.user_id,
    cards.name AS title,
    cards.due_date AS start,
    cards.due_date AS "end",
    ( SELECT array_to_json(array_agg(row_to_json(cc.*))) AS array_to_json
           FROM ( SELECT checklists_listing.id,
                    checklists_listing.created,
                    checklists_listing.modified,
                    checklists_listing.user_id,
                    checklists_listing.card_id,
                    checklists_listing.name,
                    checklists_listing.checklist_item_count,
                    checklists_listing.checklist_item_completed_count,
                    checklists_listing."position",
                    checklists_listing.checklists_items
                   FROM checklists_listing checklists_listing
                  WHERE (checklists_listing.card_id = cards.id)
                  ORDER BY checklists_listing.id) cc) AS cards_checklists,
    ( SELECT array_to_json(array_agg(row_to_json(cc.*))) AS array_to_json
           FROM ( SELECT cards_users_listing.username,
                    cards_users_listing.profile_picture_path,
                    cards_users_listing.id,
                    cards_users_listing.created,
                    cards_users_listing.modified,
                    cards_users_listing.card_id,
                    cards_users_listing.user_id,
                    cards_users_listing.initials,
                    cards_users_listing.full_name,
                    cards_users_listing.email
                   FROM cards_users_listing cards_users_listing
                  WHERE (cards_users_listing.card_id = cards.id)
                  ORDER BY cards_users_listing.id) cc) AS cards_users,
    ( SELECT array_to_json(array_agg(row_to_json(cv.*))) AS array_to_json
           FROM ( SELECT card_voters_listing.id,
                    card_voters_listing.created,
                    card_voters_listing.modified,
                    card_voters_listing.user_id,
                    card_voters_listing.card_id,
                    card_voters_listing.username,
                    card_voters_listing.role_id,
                    card_voters_listing.profile_picture_path,
                    card_voters_listing.initials,
                    card_voters_listing.full_name
                   FROM card_voters_listing card_voters_listing
                  WHERE (card_voters_listing.card_id = cards.id)
                  ORDER BY card_voters_listing.id) cv) AS cards_voters,
    ( SELECT array_to_json(array_agg(row_to_json(cs.*))) AS array_to_json
           FROM ( SELECT cards_subscribers.id,
                    to_char(cards_subscribers.created, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS created,
                    to_char(cards_subscribers.modified, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS modified,
                    cards_subscribers.card_id,
                    cards_subscribers.user_id,
                    (cards_subscribers.is_subscribed)::integer AS is_subscribed
                   FROM card_subscribers cards_subscribers
                  WHERE (cards_subscribers.card_id = cards.id)
                  ORDER BY cards_subscribers.id) cs) AS cards_subscribers,
    ( SELECT array_to_json(array_agg(row_to_json(cl.*))) AS array_to_json
           FROM ( SELECT cards_labels.label_id,
                    cards_labels.card_id,
                    cards_labels.list_id,
                    cards_labels.board_id,
                    cards_labels.name,
                    cards_labels.color
                   FROM cards_labels_listing cards_labels
                  WHERE (cards_labels.card_id = cards.id)
                  ORDER BY cards_labels.name) cl) AS cards_labels,
    cards.comment_count,
    u.username,
    b.name AS board_name,
    l.name AS list_name,
    cards.custom_fields,
    cards.color,
    cards.due_date AS notification_due_date,
    cards.is_due_date_notification_sent
   FROM (((cards cards
     LEFT JOIN users u ON ((u.id = cards.user_id)))
     LEFT JOIN boards b ON ((b.id = cards.board_id)))
     LEFT JOIN lists l ON ((l.id = cards.list_id)));

-----------

CREATE OR REPLACE VIEW lists_listing AS
SELECT lists.id,
    to_char(lists.created, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS created,
    to_char(lists.modified, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS modified,
    lists.board_id,
    lists.name,
    lists."position",
    (lists.is_archived)::integer AS is_archived,
    lists.card_count,
    lists.lists_subscriber_count,
    ( SELECT array_to_json(array_agg(row_to_json(lc.*))) AS array_to_json
           FROM ( SELECT cards_listing.id,
                    cards_listing.created,
                    cards_listing.modified,
                    cards_listing.board_id,
                    cards_listing.list_id,
                    cards_listing.name,
                    cards_listing.description,
                    cards_listing.due_date,
                    cards_listing.to_date,
                    cards_listing."position",
                    ((cards_listing.is_archived)::boolean)::integer AS is_archived,
                    cards_listing.attachment_count,
                    cards_listing.checklist_count,
                    cards_listing.checklist_item_count,
                    cards_listing.checklist_item_completed_count,
                    cards_listing.label_count,
                    cards_listing.cards_user_count,
                    cards_listing.cards_subscriber_count,
                    cards_listing.card_voter_count,
                    cards_listing.activity_count,
                    cards_listing.user_id,
                    cards_listing.title,
                    cards_listing.start,
                    cards_listing."end",
                    cards_listing.cards_checklists,
                    cards_listing.cards_users,
                    cards_listing.cards_voters,
                    cards_listing.cards_subscribers,
                    cards_listing.cards_labels,
                    cards_listing.comment_count,
                    cards_listing.custom_fields,
                    cards_listing.color,
                    cards_listing.due_date AS notification_due_date,
                    cards_listing.is_due_date_notification_sent
                   FROM cards_listing cards_listing
                  WHERE (cards_listing.list_id = lists.id)
                  ORDER BY cards_listing."position") lc) AS cards,
    ( SELECT array_to_json(array_agg(row_to_json(ls.*))) AS array_to_json
           FROM ( SELECT lists_subscribers.id,
                    to_char(lists_subscribers.created, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS created,
                    to_char(lists_subscribers.modified, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS modified,
                    lists_subscribers.list_id,
                    lists_subscribers.user_id,
                    (lists_subscribers.is_subscribed)::integer AS is_subscribed
                   FROM list_subscribers lists_subscribers
                  WHERE (lists_subscribers.list_id = lists.id)
                  ORDER BY lists_subscribers.id) ls) AS lists_subscribers,
    lists.custom_fields,
    lists.color
   FROM lists lists;

ALTER TABLE "acl_links" ADD "is_default" boolean NOT NULL DEFAULT 'false';

CREATE OR REPLACE VIEW acl_links_listing AS
SELECT aclr.role_id,
    acl.slug,
    acl.url,
    acl.method,
    acl.is_default
   FROM (acl_links_roles aclr
     JOIN acl_links acl ON ((acl.id = aclr.acl_link_id)));

update acl_links set is_default = true where slug = any('{user_detail,
activities_listing,
connect_imap,
user_activation,
view_user,
add_user_profile_picture,
view_user_activities,
user_changepassword,
connect_my_inbox,
create_stripe_customer,
upgrade_downgraded_stripe_subscription,
view_search,
edit_user_details,
view_board_activities,
get_timezone,
view_board_listing,
view_user_board,
view_board,
view_my_boards,
load_settings,
view_card_isting,
view_assigned_cards,
view_user_cards,
view_card_activities,
view_organization_listing,
view_workflow_templates}');

update cards set is_due_date_notification_sent = true;