DROP VIEW "users_listing";
DROP VIEW "admin_users_listing";


DO $$ 
   BEGIN
        BEGIN
            ALTER TABLE "users" ADD COLUMN "persist_card_divider_position" character varying(255) NULL;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column persist_card_divider_position already exists in users';
        END;  
  END;
$$;

ALTER TABLE "users"
ALTER "is_productivity_beats" TYPE boolean,
ALTER "is_productivity_beats" SET DEFAULT 'true',
ALTER "is_productivity_beats" SET NOT NULL;
UPDATE "users" SET "is_productivity_beats" = '1';

INSERT INTO "settings" ("setting_category_id", "setting_category_parent_id", "name", "value", "description", "type", "options", "label", "order")
VALUES ('17', '0', 'CALENDAR_VIEW_CARD_COLOR', 'Default Color', NULL, 'select', 'Past Present Future colors based on Due Date, Card Color, Color of first Label', 'Calendar View Card Color ', '4');

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
    users.persist_card_divider_position
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
     
     
 CREATE OR REPLACE VIEW admin_users_listing AS
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
    users.last_activity_id,
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
    users.timezone
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

UPDATE "settings" SET "options" = 'Never,Periodically,Instantly,Daily,Weekly' WHERE "name" = 'DEFAULT_EMAIL_NOTIFICATION';

ALTER TABLE "oauth_clients"
ADD "is_expirable_token" bigint NULL DEFAULT '1';
COMMENT ON TABLE "oauth_clients" IS '';

UPDATE "oauth_clients" SET "is_expirable_token" = '0' WHERE "client_id" != '7742632501382313';

INSERT INTO "email_templates" ("created", "modified", "from_email", "reply_to_email", "name", "description", "subject", "email_text_content", "email_variables", "display_name")
VALUES (now(), now(), '##SITE_NAME## Restyaboard <##FROM_EMAIL##>', '##REPLY_TO_EMAIL##', 'board_import_user_notification', 'We will send this mail to user, when user import the boards ', 'Restyaboard / Board imported', '<html>
<head></head>
<body style="margin:0">
<header style="display:block;width:100%;padding-left:0;padding-right:0; border-bottom:solid 1px #dedede; float:left;background-color: #f7f7f7;">
<div style="border: 1px solid #EEEEEE;">
<h1 style="text-align:center;margin:10px 15px 5px;"> <a href="##SITE_URL##" title="##SITE_NAME##"><img src="##SITE_URL##/img/logo.png" alt="[Restyaboard]" title="##SITE_NAME##"></a> </h1>
</div>
</header>
<main style="width:100%;padding-top:10px; padding-bottom:10px; margin:0 auto; float:left;">
<div style="background-color:#f3f5f7;padding:10px;border: 1px solid #EEEEEE;">
<div style="width: 500px;background-color: #f3f5f7;margin:0 auto;">
<pre style="font-family: Arial, Helvetica, sans-serif; font-size: 13px;line-height:20px;"><h2 style="font-size:16px; font-family:Arial, Helvetica, sans-serif; margin: 20px 0px 0px;padding:10px 0px 0px 0px;">Hi ##NAME##,</h2><p style="white-space: normal; width: 100%;margin: 10px 0px 0px; font-family:Arial, Helvetica, sans-serif;"><br></p><p style="white-space: normal; width: 100%;margin: 0px 0px 0px; font-family:Arial, Helvetica, sans-serif;">"##BOARD_NAME##" board has been successfully imported from ##BOARD_IMPORT_OPTION## ##BOARD_URL##<br></p><br><p style="white-space: normal; width: 100%;margin: 0px 0px 0px;font-family:Arial, Helvetica, sans-serif;">Thanks,<br>
Restyaboard<br>
##SITE_URL##</p>
</pre>
</div>
</div>
</main>
<footer style="width:100%;padding-left:0;margin:0px auto;border-top: solid 1px #dedede; padding-bottom:10px; background:#fff;clear: both;padding-top: 10px;border-bottom: solid 1px #dedede;background-color: #f7f7f7;">
<h6 style="text-align:center;margin:5px 15px;"> 
<a href="http://restya.com/board/?utm_source=Restyaboard - ##SITE_NAME##&utm_medium=email&utm_campaign=welcome_email" title="Open source. Trello like kanban board." rel="generator" style="font-size: 11px;text-align: center;text-decoration: none;color: #000;font-family: arial; padding-left:10px;">Powered by Restyaboard</a></h6>
</footer>
</body>
</html>', 'SITE_NAME, SITE_URL, BOARD_IMPORT_OPTION, NAME, BOARD_URL, BOARD_NAME', 'Board Import User Notification');

DELETE FROM "acl_links_roles" WHERE acl_link_id = (select id from acl_links where slug='unsubscribe_board');
DELETE FROM "acl_links_roles" WHERE acl_link_id = (select id from acl_links where slug='unsubscribe_list');
DELETE FROM "acl_links_roles" WHERE acl_link_id = (select id from acl_links where slug='unsubscribe_card');

DELETE FROM "acl_links" WHERE slug = 'unsubscribe_board';
DELETE FROM "acl_links" WHERE slug = 'unsubscribe_list';
DELETE FROM "acl_links" WHERE slug = 'unsubscribe_card';

SELECT pg_catalog.setval('acl_links_id_seq', (SELECT MAX(id) FROM acl_links), true);

INSERT INTO "acl_links" ("created", "modified", "name", "url", "method", "slug", "group_id", "is_user_action", "is_guest_action", "is_admin_action", "is_hide") values (now(), now(), 'Allow to unsubscribe board in public board', '/boards/?/board_subscribers/?', 'PUT', 'unsubscribe_board', '2', '1', '0', '0', '0'),
(now(), now(), 'Allow to unsubscribe list in public board', '/boards/?/lists/?/list_subscribers/?', 'PUT', 'unsubscribe_list', '2', '1', '0', '0', '0'),
(now(), now(), 'Allow to unsubscribe card in public board', '/boards/?/lists/?/cards/?/card_subscribers/?', 'POST', 'unsubscribe_card', '2', '1', '0', '0', '0');

INSERT INTO "acl_links_roles" ("created", "modified", "acl_link_id", "role_id") VALUES 
(now(), now(), (select id from acl_links where slug='unsubscribe_board'), '1'),
(now(), now(), (select id from acl_links where slug='unsubscribe_board'), '2'),
(now(), now(), (select id from acl_links where slug='unsubscribe_list'), '1'),
(now(), now(), (select id from acl_links where slug='unsubscribe_list'), '2'),
(now(), now(), (select id from acl_links where slug='unsubscribe_card'), '1'),
(now(), now(), (select id from acl_links where slug='unsubscribe_card'), '2');

DROP VIEW "simple_board_listing";

CREATE OR REPLACE VIEW simple_board_listing AS
SELECT board.id,
    board.name,
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
    board.boards_subscriber_count,
    board.background_pattern_url,
    ( SELECT array_to_json(array_agg(row_to_json(l.*))) AS array_to_json
           FROM ( SELECT lists.id,
                    to_char(lists.created, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS created,
                    to_char(lists.modified, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS modified,
                    lists.board_id,
                    lists.user_id,
                    lists.name,
                    lists."position",
                    (lists.is_archived)::integer AS is_archived,
                    lists.card_count,
                    lists.lists_subscriber_count,
                    lists.color,
                    (lists.is_deleted)::integer AS is_deleted,
                    lists.custom_fields
                   FROM lists lists
                  WHERE (lists.board_id = board.id)
                  ORDER BY lists."position") l) AS lists,
    ( SELECT array_to_json(array_agg(row_to_json(l.*))) AS array_to_json
           FROM ( SELECT cll.label_id,
                    cll.name
                   FROM cards_labels_listing cll
                  WHERE (cll.board_id = board.id)
                  ORDER BY cll.name) l) AS labels,
    ( SELECT array_to_json(array_agg(row_to_json(l.*))) AS array_to_json
           FROM ( SELECT bs.id,
                    bs.board_id,
                    bs.user_id,
                    (bs.is_starred)::integer AS is_starred
                   FROM board_stars bs
                  WHERE (bs.board_id = board.id)
                  ORDER BY bs.id) l) AS stars,
    org.name AS organization_name,
    org.organization_visibility,
    org.logo_url AS organization_logo_url,
    board.music_content,
    board.music_name,
    board.sort_by,
    board.sort_direction,
    ( SELECT array_to_json(array_agg(row_to_json(cl.*))) AS array_to_json
      FROM ( SELECT cards_listing.id,
              cards_listing.created,
              cards_listing.modified,
              cards_listing.board_id,
              cards_listing.list_id,
              cards_listing.name,
              cards_listing.due_date,
              cards_listing."position",
              cards_listing.list_moved_date,
              ((cards_listing.is_archived)::boolean)::integer AS is_archived,
              cards_listing.card_voter_count,
              cards_listing.attachment_count,
              cards_listing.comment_count,
              cards_listing.checklist_item_count,
              cards_listing.checklist_item_completed_count,
              ((cards_listing.checklist_item_count)::integer - (cards_listing.checklist_item_completed_count)::integer) AS checklist_item_pending_count,
              cards_listing.custom_fields
              FROM public.cards_listing cards_listing
            WHERE (cards_listing.board_id = board.id)
            ORDER BY cards_listing."position") cl) AS cards
   FROM (boards board
     LEFT JOIN organizations org ON ((org.id = board.organization_id)))
  ORDER BY board.name;






DROP TRIGGER "update_card_count" ON "cards";

DROP FUNCTION "update_card_count"();

CREATE FUNCTION public.update_card_count() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN

	IF (TG_OP = 'DELETE') THEN

		UPDATE "lists" SET "card_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "cards" WHERE "list_id" = OLD."list_id" AND "is_archived" = false) t WHERE "id" = OLD."list_id";

	        UPDATE "boards" SET "card_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "cards" WHERE "board_id" = OLD."board_id" AND "is_archived" = false) t WHERE "id" = OLD."board_id";

            UPDATE "boards" SET "archived_card_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "cards" WHERE "board_id" = OLD."board_id"  AND "is_archived" = true) t WHERE "id" = OLD."board_id";

		UPDATE "users" SET "created_card_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "cards" WHERE "user_id" = OLD."user_id") t WHERE "id" = OLD."user_id";

		RETURN OLD;

	ELSIF (TG_OP = 'UPDATE') THEN

		UPDATE "lists" SET "card_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "cards" WHERE "list_id" = OLD."list_id" AND "is_archived" = false) t WHERE "id" = OLD."list_id";

		UPDATE "lists" SET "card_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "cards" WHERE "list_id" = NEW."list_id" AND "is_archived" = false) t WHERE "id" = NEW."list_id";

		UPDATE "boards" SET "card_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "cards" WHERE "board_id" = OLD."board_id") t WHERE "id" = OLD."board_id";

		UPDATE "boards" SET "card_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "cards" WHERE "board_id" = NEW."board_id") t WHERE "id" = NEW."board_id";

		UPDATE "boards" SET "archived_card_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "cards" WHERE "board_id" = OLD."board_id" AND "is_archived" = true) t WHERE "id" = OLD."board_id";

		UPDATE "users" SET "created_card_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "cards" WHERE "user_id" = OLD."user_id") t WHERE "id" = OLD."user_id";

		UPDATE "users" SET "created_card_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "cards" WHERE "user_id" = NEW."user_id") t WHERE "id" = NEW."user_id";

		RETURN OLD;

	ELSIF (TG_OP = 'INSERT') THEN

		UPDATE "lists" SET "card_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "cards" WHERE "list_id" = NEW."list_id" AND "is_archived" = false) t WHERE "id" = NEW."list_id";

		UPDATE "boards" SET "card_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "cards" WHERE "board_id" = NEW."board_id" AND "is_archived" = false) t WHERE "id" = NEW."board_id";

		UPDATE "users" SET "created_card_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "cards" WHERE "user_id" = NEW."user_id") t WHERE "id" = NEW."user_id";

		RETURN NEW;

	END IF;

END;

$$;

CREATE TRIGGER update_card_count AFTER INSERT OR DELETE OR UPDATE ON public.cards FOR EACH ROW EXECUTE PROCEDURE public.update_card_count();





DROP TRIGGER "update_list_count" ON "lists";

DROP FUNCTION "update_list_count"();

CREATE FUNCTION public.update_list_count() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN

	IF (TG_OP = 'DELETE') THEN

		UPDATE "boards" SET "list_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "lists" WHERE "board_id" = OLD."board_id") t WHERE "id" = OLD."board_id";

        UPDATE "boards" SET "archived_list_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "lists" WHERE  "board_id" = OLD."board_id" AND "is_archived" = true) t WHERE "id" = OLD."board_id";

		UPDATE "users" SET "list_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "lists" WHERE "user_id" = OLD."user_id") t WHERE "id" = OLD."user_id";

		RETURN OLD;

	ELSIF (TG_OP = 'UPDATE') THEN

		UPDATE "boards" SET "list_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "lists" WHERE  "board_id" = OLD."board_id") t WHERE "id" = OLD."board_id";

		UPDATE "boards" SET "archived_list_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "lists" WHERE  "board_id" = NEW."board_id" AND "is_archived" = true) t WHERE "id" = NEW."board_id";

		UPDATE "users" SET "list_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "lists" WHERE "user_id" = OLD."user_id") t WHERE "id" = OLD."user_id";

		RETURN OLD;

	ELSIF (TG_OP = 'INSERT') THEN

		UPDATE "boards" SET "list_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "lists" WHERE "board_id" = NEW."board_id") t WHERE "id" = NEW."board_id";

		UPDATE "users" SET "list_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "lists" WHERE "user_id" = NEW."user_id") t WHERE "id" = NEW."user_id";

		RETURN NEW;

	END IF;

END;

$$;

CREATE TRIGGER update_list_count AFTER INSERT OR DELETE OR UPDATE ON public.lists FOR EACH ROW EXECUTE PROCEDURE public.update_list_count();

CREATE OR REPLACE VIEW "cards_listing" AS
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
                    cards_labels.id,
                    cards_labels.card_id,
                    cards_labels.list_id,
                    cards_labels.board_id,
                    cards_labels.name,
                    cards_labels.color
                   FROM cards_labels_listing cards_labels
                  WHERE (cards_labels.card_id = cards.id)
                  ORDER BY cards_labels.id) cl) AS cards_labels,
    cards.comment_count,
    u.username,
    b.name AS board_name,
    l.name AS list_name,
    cards.custom_fields,
    cards.color,
    cards.due_date AS notification_due_date,
    cards.is_due_date_notification_sent,
    cards.archived_date,
    to_char(( SELECT activities.created
           FROM activities
          WHERE ((activities.card_id = cards.id) AND ((activities.type)::text = 'move_card'::text))
          ORDER BY activities.id DESC
         LIMIT 1), 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS list_moved_date,
    u.full_name AS card_created_user
   FROM (((cards cards
     LEFT JOIN users u ON ((u.id = cards.user_id)))
     LEFT JOIN boards b ON ((b.id = cards.board_id)))
     LEFT JOIN lists l ON ((l.id = cards.list_id)));