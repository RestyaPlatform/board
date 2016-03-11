ALTER TABLE "users" ADD "is_send_newsletter" smallint NULL DEFAULT '0', ADD "last_email_notified_activity_id" bigint NULL DEFAULT '0'; 
ALTER TABLE "card_attachments" ADD "link" character varying(255) NULL;
ALTER TABLE "users" ALTER "is_send_newsletter" TYPE smallint, ALTER "is_send_newsletter" SET DEFAULT '2', ALTER "is_send_newsletter" DROP NOT NULL;
ALTER TABLE "boards" ADD "archived_list_count" bigint NULL DEFAULT '0';
ALTER TABLE "boards" ADD "archived_card_count" bigint NULL DEFAULT '0';
ALTER TABLE "users" ADD "owner_board_count" bigint NULL DEFAULT '0';
ALTER TABLE "users" ADD "member_board_count" bigint NULL DEFAULT '0';
ALTER TABLE "users" ADD "owner_organization_count" bigint NULL DEFAULT '0';
ALTER TABLE "users" ADD "member_organization_count" bigint NULL DEFAULT '0';

UPDATE "acl_links" SET "method" = 'DELETE' WHERE "name" = 'Unvote card';
DELETE FROM "acl_links_roles" WHERE "acl_link_id" = '5' AND "role_id" = '3';

INSERT INTO "acl_links" ("created", "modified", "name", "url", "method", "slug", "group_id", "is_allow_only_to_admin", "is_allow_only_to_user")
VALUES (now(), now(), 'Users Bulk Action', '/users/bulk_action', 'POST', 'users_bulk_action', '6', '1', '0');

INSERT INTO "acl_links_roles" ("created", "modified", "acl_link_id", "role_id")
VALUES (now(), now(), '120', '1');

INSERT INTO "acl_links_roles" ("created", "modified", "acl_link_id", "role_id")
VALUES (now(), now(), '120', '2');

INSERT INTO "acl_links_roles" ("created", "modified", "acl_link_id", "role_id")
VALUES (now(), now(), '120', '3');

INSERT INTO "acl_links" ("created", "modified", "name", "url", "method", "slug", "group_id", "is_allow_only_to_admin", "is_allow_only_to_user")
VALUES (now(), now(), 'Boards management', '/boards/list', 'GET', 'view_board_listing', '1', '1', '0');

INSERT INTO "acl_links_roles" ("created", "modified", "acl_link_id", "role_id")
VALUES (now(), now(), '121', '1');

INSERT INTO "acl_links" ("created", "modified", "name", "url", "method", "slug", "group_id", "is_allow_only_to_admin", "is_allow_only_to_user")
VALUES (now(), now(), 'Boards Bulk Action', '/boards/bulk_action', 'POST', 'boards_bulk_action', '6', '1', '0');

INSERT INTO "acl_links_roles" ("created", "modified", "acl_link_id", "role_id")
VALUES (now(), now(), '122', '1');

INSERT INTO "acl_links_roles" ("created", "modified", "acl_link_id", "role_id")
VALUES (now(), now(), '122', '2');

INSERT INTO "acl_links_roles" ("created", "modified", "acl_link_id", "role_id")
VALUES (now(), now(), '122', '3');

INSERT INTO "settings" ("id", "setting_category_id", "setting_category_parent_id", "name", "value", "description", "type", "options", "label", "order")
VALUES ('29', '3', '0', 'DEFAULT_REPLY_TO_EMAIL_ADDRESS', 'board@restya.com', NULL, 'text', NULL, 'Reply To Email Address', '3');

INSERT INTO "settings" ("id", "setting_category_id", "setting_category_parent_id", "name", "value", "description", "type", "options", "label", "order")
VALUES ('30', '3', '0', 'DEFAULT_CONTACT_EMAIL_ADDRESS', 'board@restya.com', NULL, 'text', NULL, 'Contact Email Address', '4');

UPDATE "settings" SET "name" = 'DEFAULT_FROM_EMAIL_ADDRESS', "label" = 'From Email Address' WHERE "name" = 'DEFAULT_FROM_EMAIL';
DELETE FROM "settings" WHERE "name" = 'SECRET_KEY';
DELETE FROM "settings" WHERE "name" = 'ELASTICSEARCH_HOST';

UPDATE "email_templates" SET
"subject" = 'Restyaboard / Account confirmation',
"from_email" = '##SITE_NAME## Restyaboard <##FROM_EMAIL##>',
"email_variables" = 'SITE_URL, SITE_NAME, CONTACT_EMAIL, NAME, ACTIVATION_URL',
"email_text_content" = '<html>
<head></head>
<body style="margin:0">
<header style="display:block;width:100%;padding-left:0;padding-right:0; border-bottom:solid 1px #dedede; float:left;background-color: #f7f7f7;">
<div style="border: 1px solid #EEEEEE;">
<h1 style="text-align:center;margin:10px 15px 5px;"> <a href="##SITE_URL##" title="##SITE_NAME##"><img src="##SITE_URL##/img/logo.png" alt="[Image: Restyaboard]" title="##SITE_NAME##"></a> </h1>
</div>
</header>
<main style="width:100%;padding-top:10px; padding-bottom:10px; margin:0 auto; float:left;">
<div style="background-color:#f3f5f7;padding:10px;border: 1px solid #EEEEEE;">
<div style="width: 500px;background-color: #f3f5f7;margin:0 auto;">
<pre style="font-family: Arial, Helvetica, sans-serif; font-size: 13px;line-height:20px;"><h2 style="font-size:16px; font-family:Arial, Helvetica, sans-serif; margin: 20px 0px 0px;padding:10px 0px 0px 0px;">Hi ##NAME##,
</h2><p style="white-space: normal; width: 100%;margin: 10px 0px 0px; font-family:Arial, Helvetica, sans-serif;"><br></p><p style="white-space: normal; width: 100%;margin: 0px 0px 0px; font-family:Arial, Helvetica, sans-serif;">You are one step ahead. Please click the below URL to activate your account.<br>##ACTIVATION_URL##<br>If you didn''t create a ##SITE_NAME## account and feel this is an error, please contact us at ##CONTACT_EMAIL##.<br></p><br><p style="white-space: normal; width: 100%;margin: 0px 0px 0px;font-family:Arial, Helvetica, sans-serif;">Thanks,<br>
Restyaboard<br>
##SITE_URL##</p>
</pre>
</div>
</div>
</main>
<footer style="width:100%;padding-left:0;margin:0px auto;border-top: solid 1px #dedede; padding-bottom:10px; background:#fff;clear: both;padding-top: 10px;border-bottom: solid 1px #dedede;background-color: #f7f7f7;">
<h6 style="text-align:center;margin:5px 15px;"> 
<a href="http://restya.com/board" title="Open source. Trello like kanban board." rel="generator" style="font-size: 11px;text-align: center;text-decoration: none;color: #000;font-family: arial; padding-left:10px;">Powered by Restyaboard</a></h6>
</footer>
</body>
</html>'
WHERE "id" = '1';

UPDATE "email_templates" SET
"subject" = 'Restyaboard / Welcome',
"from_email" = '##SITE_NAME## Restyaboard <##FROM_EMAIL##>',
"email_variables" = 'SITE_URL, SITE_NAME, CONTACT_EMAIL, NAME',
"email_text_content" = '<html>
<head></head>
<body style="margin:0">
<header style="display:block;width:100%;padding-left:0;padding-right:0; border-bottom:solid 1px #dedede; float:left;background-color: #f7f7f7;">
<div style="border: 1px solid #EEEEEE;">
<h1 style="text-align:center;margin:10px 15px 5px;"> <a href="##SITE_URL##" title="##SITE_NAME##"><img src="##SITE_URL##/img/logo.png" alt="[Image: Restyaboard]" title="##SITE_NAME##"></a> </h1>
</div>
</header>
<main style="width:100%;padding-top:10px; padding-bottom:10px; margin:0 auto; float:left;">
<div style="background-color:#f3f5f7;padding:10px;border: 1px solid #EEEEEE;">
<div style="width: 500px;background-color: #f3f5f7;margin:0 auto;">
<pre style="font-family: Arial, Helvetica, sans-serif; font-size: 13px;line-height:20px;"><h2 style="font-size:16px; font-family:Arial, Helvetica, sans-serif; margin: 20px 0px 0px;padding:10px 0px 0px 0px;">Hi ##NAME##,</h2><p style="white-space: normal; width: 100%;margin: 10px 0px 0px; font-family:Arial, Helvetica, sans-serif;"><br></p><p style="white-space: normal; width: 100%;margin: 0px 0px 0px; font-family:Arial, Helvetica, sans-serif;">We wish to say a quick hello and thanks for registering at ##SITE_NAME##.<br>If you didn''t create a ##SITE_NAME## account and feel this is an error, please contact us at ##CONTACT_EMAIL##.<br></p><br><p style="white-space: normal; width: 100%;margin: 0px 0px 0px;font-family:Arial, Helvetica, sans-serif;">Thanks,<br>
Restyaboard<br>
##SITE_URL##</p>
</pre>
</div>
</div>
</main>
<footer style="width:100%;padding-left:0;margin:0px auto;border-top: solid 1px #dedede; padding-bottom:10px; background:#fff;clear: both;padding-top: 10px;border-bottom: solid 1px #dedede;background-color: #f7f7f7;">
<h6 style="text-align:center;margin:5px 15px;"> 
<a href="http://restya.com/board" title="Open source. Trello like kanban board." rel="generator" style="font-size: 11px;text-align: center;text-decoration: none;color: #000;font-family: arial; padding-left:10px;">Powered by Restyaboard</a></h6>
</footer>
</body>
</html>'
WHERE "id" = '2';

UPDATE "email_templates" SET
"subject" = 'Restyaboard / Password reset',
"from_email" = '##SITE_NAME## Restyaboard <##FROM_EMAIL##>',
"email_variables" = 'SITE_NAME, SITE_URL, CONTACT_EMAIL, NAME, PASSWORD',
"email_text_content" = '<html>
<head></head>
<body style="margin:0">
<header style="display:block;width:100%;padding-left:0;padding-right:0; border-bottom:solid 1px #dedede; float:left;background-color: #f7f7f7;">
<div style="border: 1px solid #EEEEEE;">
<h1 style="text-align:center;margin:10px 15px 5px;"> <a href="##SITE_URL##" title="##SITE_NAME##"><img src="##SITE_URL##/img/logo.png" alt="[Image: Restyaboard]" title="##SITE_NAME##"></a> </h1>
</div>
</header>
<main style="width:100%;padding-top:10px; padding-bottom:10px; margin:0 auto; float:left;">
<div style="background-color:#f3f5f7;padding:10px;border: 1px solid #EEEEEE;">
<div style="width: 500px;background-color: #f3f5f7;margin:0 auto;">
<pre style="font-family: Arial, Helvetica, sans-serif; font-size: 13px;line-height:20px;"><h2 style="font-size:16px; font-family:Arial, Helvetica, sans-serif; margin: 20px 0px 0px;padding:10px 0px 0px 0px;">Hi ##NAME##,</h2><p style="white-space: normal; width: 100%;margin: 10px 0px 0px; font-family:Arial, Helvetica, sans-serif;"><br></p><p style="white-space: normal; width: 100%;margin: 0px 0px 0px; font-family:Arial, Helvetica, sans-serif;">We have received a password reset request for your account at ##SITE_NAME##.<br>New password: ##PASSWORD##<br>If you didn''t requested this action and feel this is an error, please contact us at ##CONTACT_EMAIL##.<br></p><br><p style="white-space: normal; width: 100%;margin: 0px 0px 0px;font-family:Arial, Helvetica, sans-serif;">Thanks,<br>
Restyaboard<br>
##SITE_URL##</p>
</pre>
</div>
</div>
</main>
<footer style="width:100%;padding-left:0;margin:0px auto;border-top: solid 1px #dedede; padding-bottom:10px; background:#fff;clear: both;padding-top: 10px;border-bottom: solid 1px #dedede;background-color: #f7f7f7;">
<h6 style="text-align:center;margin:5px 15px;"> 
<a href="http://restya.com/board" title="Open source. Trello like kanban board." rel="generator" style="font-size: 11px;text-align: center;text-decoration: none;color: #000;font-family: arial; padding-left:10px;">Powered by Restyaboard</a></h6>
</footer>
</body>
</html>'
WHERE "id" = '3';

UPDATE "email_templates" SET
"subject" = 'Restyaboard / Password changed',
"from_email" = '##SITE_NAME## Restyaboard <##FROM_EMAIL##>',
"email_variables" = 'SITE_NAME, SITE_URL, PASSWORD',
"email_text_content" = '<html>
<head></head>
<body style="margin:0">
<header style="display:block;width:100%;padding-left:0;padding-right:0; border-bottom:solid 1px #dedede; float:left;background-color: #f7f7f7;">
<div style="border: 1px solid #EEEEEE;">
<h1 style="text-align:center;margin:10px 15px 5px;"> <a href="##SITE_URL##" title="##SITE_NAME##"><img src="##SITE_URL##/img/logo.png" alt="[Image: Restyaboard]" title="##SITE_NAME##"></a> </h1>
</div>
</header>
<main style="width:100%;padding-top:10px; padding-bottom:10px; margin:0 auto; float:left;">
<div style="background-color:#f3f5f7;padding:10px;border: 1px solid #EEEEEE;">
<div style="width: 500px;background-color: #f3f5f7;margin:0 auto;">
<pre style="font-family: Arial, Helvetica, sans-serif; font-size: 13px;line-height:20px;"><h2 style="font-size:16px; font-family:Arial, Helvetica, sans-serif; margin: 20px 0px 0px;padding:10px 0px 0px 0px;">Hi,</h2><p style="white-space: normal; width: 100%;margin: 10px 0px 0px; font-family:Arial, Helvetica, sans-serif;"><br></p><p style="white-space: normal; width: 100%;margin: 0px 0px 0px; font-family:Arial, Helvetica, sans-serif;">Admin reset your password for your ##SITE_NAME## account.<br>Your new password: ##PASSWORD##<br></p><br><p style="white-space: normal; width: 100%;margin: 0px 0px 0px;font-family:Arial, Helvetica, sans-serif;">Thanks,<br>
Restyaboard<br>
##SITE_URL##</p>
</pre>
</div>
</div>
</main>
<footer style="width:100%;padding-left:0;margin:0px auto;border-top: solid 1px #dedede; padding-bottom:10px; background:#fff;clear: both;padding-top: 10px;border-bottom: solid 1px #dedede;background-color: #f7f7f7;">
<h6 style="text-align:center;margin:5px 15px;"> 
<a href="http://restya.com/board" title="Open source. Trello like kanban board." rel="generator" style="font-size: 11px;text-align: center;text-decoration: none;color: #000;font-family: arial; padding-left:10px;">Powered by Restyaboard</a></h6>
</footer>
</body>
</html>'
WHERE "id" = '4';

UPDATE "email_templates" SET
"subject" = 'Restyaboard / ##BOARD_NAME## assigned by ##CURRENT_USER##',
"from_email" = '##SITE_NAME## Restyaboard <##FROM_EMAIL##>',
"email_variables" = 'SITE_URL, SITE_NAME, NAME, BOARD_NAME, CURRENT_USER, BOARD_URL',
"email_text_content" = '<html>
<head></head>
<body style="margin:0">
<header style="display:block;width:100%;padding-left:0;padding-right:0; border-bottom:solid 1px #dedede; float:left;background-color: #f7f7f7;">
<div style="border: 1px solid #EEEEEE;">
<h1 style="text-align:center;margin:10px 15px 5px;"> <a href="##SITE_URL##" title="##SITE_NAME##"><img src="##SITE_URL##/img/logo.png" alt="[Image: Restyaboard]" title="##SITE_NAME##"></a> </h1>
</div>
</header>
<main style="width:100%;padding-top:10px; padding-bottom:10px; margin:0 auto; float:left;">
<div style="background-color:#f3f5f7;padding:10px;border: 1px solid #EEEEEE;">
<div style="width: 500px;background-color: #f3f5f7;margin:0 auto;">
<pre style="font-family: Arial, Helvetica, sans-serif; font-size: 13px;line-height:20px;"><h2 style="font-size:16px; font-family:Arial, Helvetica, sans-serif; margin: 20px 0px 0px;padding:10px 0px 0px 0px;">Hi ##NAME##,</h2>
<p style="white-space: normal; width: 100%;margin: 0px 0px 0px; font-family:Arial, Helvetica, sans-serif;">##CURRENT_USER## has added you to the board ##BOARD_NAME## ##BOARD_URL##<br></p><br><p style="white-space: normal; width: 100%;margin: 0px 0px 0px;font-family:Arial, Helvetica, sans-serif;">Thanks,<br>
Restyaboard<br>
##SITE_URL##</p>
</pre>
</div>
</div>
</main>
<footer style="width:100%;padding-left:0;margin:0px auto;border-top: solid 1px #dedede; padding-bottom:10px; background:#fff;clear: both;padding-top: 10px;border-bottom: solid 1px #dedede;background-color: #f7f7f7;">
<h6 style="text-align:center;margin:5px 15px;"> 
<a href="http://restya.com/board" title="Open source. Trello like kanban board." rel="generator" style="font-size: 11px;text-align: center;text-decoration: none;color: #000;font-family: arial; padding-left:10px;">Powered by Restyaboard</a></h6>
</footer>
</body>
</html>',
"display_name" = 'New Board User'
WHERE "id" = '5';

INSERT INTO "email_templates" ("id", "created", "modified", "from_email", "reply_to_email", "name", "description", "subject", "email_text_content", "email_variables", "display_name") VALUES
(6,	'2015-10-09 06:15:49.891',	'2015-10-09 06:15:49.891',	'##SITE_NAME## Restyaboard <##FROM_EMAIL##>',	'##REPLY_TO_EMAIL##',	'email_notification',	'We will send this mail, when user activities in this site.',	'Restyaboard / ##NOTIFICATION_COUNT## new notifications since ##SINCE##',	'<html>
<head></head>
<body style="margin:0">
<header style="display:block;width:100%;padding-left:0;padding-right:0; border-bottom:solid 1px #dedede; float:left;background-color: #f7f7f7;">
<div style="border: 1px solid #EEEEEE;">
<h1 style="text-align:center;margin:10px 15px 5px;"> <a href="##SITE_URL##" title="##SITE_NAME##"><img src="##SITE_URL##/img/logo.png" alt="[Image: Restyaboard]" title="##SITE_NAME##"></a> </h1>
</div>
</header>
<main style="width:100%;padding-top:10px; padding-bottom:10px; margin:0 auto; float:left;">
<div style="background-color:#f3f5f7;padding:10px;border: 1px solid #EEEEEE;">
<div style="width: 500px;background-color: #f3f5f7;margin:0 auto;">
<pre style="font-family: Arial, Helvetica, sans-serif; font-size: 13px;line-height:20px;"><h2 style="font-size:16px; font-family:Arial, Helvetica, sans-serif; margin: 20px 0px 0px;padding:10px 0px 0px 0px;">Here''s what you missed...</h2>
<p style="white-space: normal; width: 100%;margin: 10px 0px 0px; font-family:Arial, Helvetica, sans-serif;">##CONTENT##</p>
</pre>
</div>
</div>
<div style="text-align:center;margin:5px 15px;padding:10px 0px;">
<a href="##SITE_URL##/#/user/##USER_ID##/settings">Change email preferences</a>
</div>
</main>
<footer style="width:100%;padding-left:0;margin:0px auto;border-top: solid 1px #dedede; padding-bottom:10px; background:#fff;clear: both;padding-top: 10px;border-bottom: solid 1px #dedede;background-color: #f7f7f7;">
<h6 style="text-align:center;margin:5px 15px;"> 
<a href="http://restya.com/board" title="Open source. Trello like kanban board." rel="generator" style="font-size: 11px;text-align: center;text-decoration: none;color: #000;font-family: arial; padding-left:10px;">Powered by Restyaboard</a>
</h6>
</footer>
</body>
</html>', 'SITE_URL, SITE_NAME, CONTENT, NAME, NOTIFICATION_COUNT, SINCE', 'Email Notification');

CREATE OR REPLACE VIEW "card_voters_listing" AS
 SELECT card_voters.id, 
    card_voters.created, 
    card_voters.modified, 
    card_voters.user_id, 
    card_voters.card_id, 
    users.username, 
    users.role_id, 
    users.profile_picture_path, 
    users.initials,
    users.full_name
   FROM (card_voters card_voters
   LEFT JOIN users users ON ((users.id = card_voters.user_id)));
   
CREATE OR REPLACE VIEW "cards_users_listing" AS
 SELECT u.username, 
    u.profile_picture_path, 
    cu.id, 
    cu.created, 
    cu.modified, 
    cu.card_id, 
    cu.user_id, 
    u.initials,
    u.full_name
   FROM (cards_users cu
   LEFT JOIN users u ON ((u.id = cu.user_id)));

DROP VIEW "users_cards_listing";
CREATE OR REPLACE VIEW users_cards_listing AS
 SELECT b.name AS board_name, 
    l.name AS list_name, 
    c.id, 
    c.created, 
    c.modified, 
    c.board_id, 
    c.list_id, 
    c.name, 
    c.description, 
    c.due_date, 
    c."position", 
    c.is_archived::boolean::int, 
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
    c.is_deleted::boolean::int, 
    cu.user_id, 
    c.comment_count
   FROM (((cards_users cu
   JOIN cards c ON ((c.id = cu.card_id)))
   JOIN boards b ON ((b.id = c.board_id)))
   JOIN lists l ON ((l.id = c.list_id)));

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
    board.is_closed::boolean::int, 
    board.is_allow_organization_members_to_join::boolean::int,  
    board.boards_user_count, 
    board.list_count, 
    board.card_count, 
    board.boards_subscriber_count, 
    board.background_pattern_url, 
    ( SELECT array_to_json(array_agg(row_to_json(l.*))) AS array_to_json
           FROM ( SELECT lists.id, 
                    lists.created, 
                    lists.modified, 
                    lists.board_id, 
                    lists.user_id, 
                    lists.name, 
                    lists."position", 
                    lists.is_archived, 
                    lists.card_count, 
                    lists.lists_subscriber_count, 
                    lists.is_deleted
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
                    bs.is_starred
                   FROM board_stars bs
                  WHERE (bs.board_id = board.id)
                  ORDER BY bs.id) l) AS stars, 
    org.name AS organization_name, 
    ( SELECT array_to_json(array_agg(row_to_json(l.*))) AS array_to_json
           FROM ( SELECT bu.id, 
                    bu.board_id, 
                    bu.user_id, 
                    bu.is_admin
                   FROM boards_users bu
                  WHERE (bu.board_id = board.id)
                  ORDER BY bu.id) l) AS users, 
    org.logo_url AS organization_logo_url, 
    board.music_content, 
    board.music_name
   FROM (boards board
   LEFT JOIN organizations org ON ((org.id = board.organization_id)))
  ORDER BY board.name;

DROP VIEW "organizations_users_listing" CASCADE;
CREATE OR REPLACE VIEW organizations_users_listing AS
 SELECT organizations_users.id, 
    organizations_users.created, 
    organizations_users.modified, 
    organizations_users.user_id, 
    organizations_users.organization_id, 
    organizations_users.is_admin::boolean::int, 
    users.role_id, 
    users.username, 
    users.email, 
    users.full_name, 
    users.initials, 
    users.about_me, 
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
    organizations.name, 
    organizations.website_url, 
    organizations.description, 
    organizations.logo_url, 
    organizations.organization_visibility, 
    users.profile_picture_path, 
    ( SELECT array_to_json(array_agg(row_to_json(o.*))) AS array_to_json
           FROM ( SELECT boards_users.id, 
                    boards_users.board_id, 
                    boards_users.user_id, 
                    boards_users.is_admin,
                    boards.name
                   FROM (boards_users boards_users
              JOIN boards ON ((boards.id = boards_users.board_id)))
             WHERE ((boards_users.user_id = organizations_users.user_id) AND (boards_users.board_id IN ( SELECT boards_1.id
                      FROM boards boards_1
                     WHERE (boards_1.organization_id = organizations_users.organization_id))))
             ORDER BY boards_users.id) o) AS boards_users, 
    ( SELECT count(boards.id) AS count
           FROM (boards
      JOIN boards_users bu ON ((bu.board_id = boards.id)))
     WHERE ((boards.organization_id = organizations_users.organization_id) AND (bu.user_id = organizations_users.user_id))) AS user_board_count
   FROM ((organizations_users organizations_users
   LEFT JOIN users users ON ((users.id = organizations_users.user_id)))
   LEFT JOIN organizations organizations ON ((organizations.id = organizations_users.organization_id)));

DROP VIEW "cards_listing" CASCADE;
CREATE OR REPLACE VIEW cards_listing AS
 SELECT cards.id,
    cards.created,
    cards.modified,
    cards.board_id,
    cards.list_id,
    cards.name,
    cards.description,
    cards.due_date,
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
		    cards_users_listing.full_name
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
                    cards_subscribers.created,
                    cards_subscribers.modified,
                    cards_subscribers.card_id,
                    cards_subscribers.user_id,
                    cards_subscribers.is_subscribed
                   FROM card_subscribers cards_subscribers
                  WHERE (cards_subscribers.card_id = cards.id)
                  ORDER BY cards_subscribers.id) cs) AS cards_subscribers,
    ( SELECT array_to_json(array_agg(row_to_json(cl.*))) AS array_to_json
           FROM ( SELECT cards_labels.label_id,
                    cards_labels.card_id,
                    cards_labels.list_id,
                    cards_labels.board_id,
                    cards_labels.name
                   FROM cards_labels_listing cards_labels
                  WHERE (cards_labels.card_id = cards.id)
                  ORDER BY cards_labels.id) cl) AS cards_labels,
    cards.comment_count,
    u.username,
    b.name AS board_name,
    l.name AS list_name
   FROM (((cards cards
   LEFT JOIN users u ON ((u.id = cards.user_id)))
   LEFT JOIN boards b ON ((b.id = cards.board_id)))
   LEFT JOIN lists l ON ((l.id = cards.list_id)));

CREATE OR REPLACE VIEW lists_listing AS
 SELECT lists.id, 
    lists.created, 
    lists.modified, 
    lists.board_id, 
    lists.name, 
    lists."position", 
    lists.is_archived::boolean::int, 
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
                    cards_listing.is_archived, 
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
                    cards_listing.comment_count
                   FROM cards_listing cards_listing
                  WHERE (cards_listing.list_id = lists.id)
                  ORDER BY cards_listing."position") lc) AS cards, 
    ( SELECT array_to_json(array_agg(row_to_json(ls.*))) AS array_to_json
           FROM ( SELECT lists_subscribers.id, 
                    lists_subscribers.created, 
                    lists_subscribers.modified, 
                    lists_subscribers.list_id, 
                    lists_subscribers.user_id, 
                    lists_subscribers.is_subscribed
                   FROM list_subscribers lists_subscribers
                  WHERE (lists_subscribers.list_id = lists.id)
                  ORDER BY lists_subscribers.id) ls) AS lists_subscribers
   FROM lists lists;

DROP VIEW "boards_users_listing" CASCADE;
CREATE OR REPLACE VIEW boards_users_listing AS
 SELECT bu.id, 
    bu.created, 
    bu.modified, 
    bu.board_id, 
    bu.user_id, 
    bu.is_admin::boolean::int, 
    u.username, 
    u.email, 
    u.full_name, 
    u.is_active::boolean::int, 
    u.is_email_confirmed::boolean::int, 
    b.name AS board_name, 
    u.profile_picture_path, 
    u.initials
   FROM ((boards_users bu
   JOIN users u ON ((u.id = bu.user_id)))
   JOIN boards b ON ((b.id = bu.board_id)));
   
CREATE OR REPLACE VIEW boards_listing AS
 SELECT board.id, 
    board.name,
    board.created,
    board.modified,
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
    board.is_closed::boolean::int,
    board.is_allow_organization_members_to_join::boolean::int,
    board.boards_user_count, 
    board.list_count, 
    board.card_count, 
    board.archived_list_count,
    board.archived_card_count,
    board.boards_subscriber_count, 
    board.background_pattern_url, 
    board.is_show_image_front_of_card::boolean::int,
    board.music_name, 
    board.music_content, 
    organizations.name AS organization_name, 
    organizations.website_url AS organization_website_url, 
    organizations.description AS organization_description, 
    organizations.logo_url AS organization_logo_url, 
    organizations.organization_visibility, 
    ( SELECT array_to_json(array_agg(row_to_json(ba.*))) AS array_to_json
           FROM ( SELECT activities.id, 
                    activities.created, 
                    activities.modified, 
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
                    users.username, 
                    users.role_id, 
                    users.profile_picture_path, 
                    users.initials
                   FROM (activities activities
              LEFT JOIN users users ON ((users.id = activities.user_id)))
             WHERE (activities.board_id = board.id)
             ORDER BY activities.freshness_ts DESC, activities.materialized_path
            OFFSET 0
            LIMIT 20) ba) AS activities, 
    ( SELECT array_to_json(array_agg(row_to_json(bs.*))) AS array_to_json
           FROM ( SELECT boards_subscribers.id, 
                    boards_subscribers.created, 
                    boards_subscribers.modified, 
                    boards_subscribers.board_id, 
                    boards_subscribers.user_id, 
                    boards_subscribers.is_subscribed
                   FROM board_subscribers boards_subscribers
                  WHERE (boards_subscribers.board_id = board.id)
                  ORDER BY boards_subscribers.id) bs) AS boards_subscribers, 
    ( SELECT array_to_json(array_agg(row_to_json(bs.*))) AS array_to_json
           FROM ( SELECT boards_stars.id, 
                    boards_stars.created, 
                    boards_stars.modified, 
                    boards_stars.board_id, 
                    boards_stars.user_id, 
                    boards_stars.is_starred
                   FROM board_stars boards_stars
                  WHERE (boards_stars.board_id = board.id)
                  ORDER BY boards_stars.id) bs) AS boards_stars, 
    ( SELECT array_to_json(array_agg(row_to_json(batt.*))) AS array_to_json
           FROM ( SELECT card_attachments.id, 
                    card_attachments.created, 
                    card_attachments.modified, 
                    card_attachments.card_id, 
                    card_attachments.name, 
                    card_attachments.path, 
                    card_attachments.mimetype, 
                    card_attachments.list_id, 
                    card_attachments.board_id
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
                    lists_listing.is_archived,
                    lists_listing.card_count, 
                    lists_listing.lists_subscriber_count, 
                    lists_listing.cards, 
                    lists_listing.lists_subscribers
                   FROM lists_listing lists_listing
                  WHERE (lists_listing.board_id = board.id)
                  ORDER BY lists_listing."position") bl) AS lists, 
    ( SELECT array_to_json(array_agg(row_to_json(bu.*))) AS array_to_json
           FROM ( SELECT boards_users.id, 
                    boards_users.created, 
                    boards_users.modified, 
                    boards_users.board_id, 
                    boards_users.user_id, 
                    boards_users.is_admin, 
                    boards_users.username, 
                    boards_users.email, 
                    boards_users.full_name, 
                    boards_users.is_active, 
                    boards_users.is_email_confirmed, 
                    boards_users.board_name, 
                    boards_users.profile_picture_path, 
                    boards_users.initials
                   FROM boards_users_listing boards_users
                  WHERE (boards_users.board_id = board.id)
                  ORDER BY boards_users.id) bu) AS boards_users
   FROM ((boards board
   LEFT JOIN users users ON ((users.id = board.user_id)))
   LEFT JOIN organizations organizations ON ((organizations.id = board.organization_id)));

CREATE OR REPLACE VIEW organizations_listing AS
  SELECT organizations.id, 
    organizations.created, 
    organizations.modified, 
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
                    boards_listing.is_closed, 
                    boards_listing.is_allow_organization_members_to_join, 
                    boards_listing.boards_user_count, 
                    boards_listing.list_count, 
                    boards_listing.card_count, 
                    boards_listing.boards_subscriber_count, 
                    boards_listing.background_pattern_url, 
                    boards_listing.is_show_image_front_of_card, 
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
                    organizations_users_listing.is_admin, 
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
    users.is_allow_desktop_notification::boolean::int, 
    users.is_active::boolean::int, 
    users.is_email_confirmed::boolean::int, 
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
    users.is_productivity_beats::boolean::int, 
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
                    boards_stars.is_starred
                   FROM board_stars boards_stars
                  WHERE (boards_stars.user_id = users.id)
                  ORDER BY boards_stars.id) o) AS boards_stars, 
    ( SELECT array_to_json(array_agg(row_to_json(o.*))) AS array_to_json
           FROM ( SELECT boards_users.id, 
                    boards_users.board_id, 
                    boards_users.user_id, 
                    boards_users.is_admin, 
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
    users.created, 
    users.user_login_count, 
    users.is_send_newsletter, 
    users.last_email_notified_activity_id,
    users.owner_board_count,
    users.member_board_count,
    users.owner_organization_count,
    users.member_organization_count
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

CREATE OR REPLACE FUNCTION update_card_count() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
	IF (TG_OP = 'DELETE') THEN
		UPDATE "lists" SET "card_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "cards" WHERE "list_id" = OLD."list_id" AND "is_archived" = false) t WHERE "id" = OLD."list_id";
	        UPDATE "boards" SET "card_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "cards" WHERE "board_id" = OLD."board_id") t WHERE "id" = OLD."board_id";
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
		UPDATE "boards" SET "card_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "cards" WHERE "board_id" = NEW."board_id") t WHERE "id" = NEW."list_id";
		UPDATE "users" SET "created_card_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "cards" WHERE "user_id" = NEW."user_id") t WHERE "id" = NEW."user_id";
		RETURN NEW;
	END IF;
END;
$$;

CREATE OR REPLACE FUNCTION update_list_count() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
	IF (TG_OP = 'DELETE') THEN
		UPDATE "boards" SET "list_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "lists" WHERE "board_id" = OLD."board_id") t WHERE "id" = OLD."board_id";
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

CREATE OR REPLACE FUNCTION update_board_user_count() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
	IF (TG_OP = 'DELETE') THEN
		UPDATE "boards" SET "boards_user_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "boards_users" WHERE "board_id" = OLD."board_id") t WHERE "id" = OLD."board_id";
		UPDATE "users" SET "joined_board_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "boards_users" WHERE "user_id" = OLD."user_id") t WHERE "id" = OLD."user_id";
		UPDATE "users" SET "owner_board_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "boards_users" WHERE "user_id" = OLD."user_id" AND "is_admin" = true) t WHERE "id" = OLD."user_id";
	        UPDATE "users" SET "member_board_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "boards_users" WHERE "user_id" = OLD."user_id" AND "is_admin" = false) t WHERE "id" = OLD."user_id";
		RETURN OLD;
	ELSIF (TG_OP = 'UPDATE') THEN
		UPDATE "boards" SET "boards_user_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "boards_users" WHERE "board_id" = OLD."board_id") t WHERE "id" = OLD."board_id";
	        UPDATE "users" SET "joined_board_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "boards_users" WHERE "user_id" = OLD."user_id") t WHERE "id" = OLD."user_id";
		UPDATE "users" SET "owner_board_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "boards_users" WHERE "user_id" = OLD."user_id" AND "is_admin" = true) t WHERE "id" = OLD."user_id";
	        UPDATE "users" SET "member_board_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "boards_users" WHERE "user_id" = OLD."user_id" AND "is_admin" = false) t WHERE "id" = OLD."user_id";
		RETURN OLD;
	ELSIF (TG_OP = 'INSERT') THEN
		UPDATE "boards" SET "boards_user_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "boards_users" WHERE "board_id" = NEW."board_id") t WHERE "id" = NEW."board_id";
	        UPDATE "users" SET "joined_board_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "boards_users" WHERE "user_id" = NEW."user_id") t WHERE "id" = NEW."user_id";
	        UPDATE "users" SET "owner_board_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "boards_users" WHERE "user_id" = NEW."user_id" AND "is_admin" = true) t WHERE "id" = NEW."user_id";
	        UPDATE "users" SET "member_board_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "boards_users" WHERE "user_id" = NEW."user_id" AND "is_admin" = false) t WHERE "id" = NEW."user_id";
		RETURN NEW;
	END IF;
END;
$$;

CREATE OR REPLACE FUNCTION update_organization_user_count() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
	IF (TG_OP = 'DELETE') THEN
		UPDATE "organizations" SET "organizations_user_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "organizations_users" WHERE "organization_id" = OLD."organization_id") t WHERE "id" = OLD."organization_id";
	        UPDATE "users" SET "joined_organization_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "organizations_users" WHERE "user_id" = OLD."user_id") t WHERE "id" = OLD."user_id";
		UPDATE "users" SET "owner_organization_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "organizations_users" WHERE "user_id" = OLD."user_id" AND "is_admin" = true) t WHERE "id" = OLD."user_id";
	        UPDATE "users" SET "member_organization_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "organizations_users" WHERE "user_id" = OLD."user_id" AND "is_admin" = false) t WHERE "id" = OLD."user_id";
		RETURN OLD;
	ELSIF (TG_OP = 'UPDATE') THEN
		UPDATE "organizations" SET "organizations_user_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "organizations_users" WHERE "organization_id" = OLD."organization_id") t WHERE "id" = OLD."organization_id";
	        UPDATE "users" SET "joined_organization_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "organizations_users" WHERE "user_id" = OLD."user_id") t WHERE "id" = OLD."user_id";
		UPDATE "users" SET "owner_organization_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "organizations_users" WHERE "user_id" = OLD."user_id" AND "is_admin" = true) t WHERE "id" = OLD."user_id";
	        UPDATE "users" SET "member_organization_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "organizations_users" WHERE "user_id" = OLD."user_id" AND "is_admin" = false) t WHERE "id" = OLD."user_id";
		RETURN OLD;
	ELSIF (TG_OP = 'INSERT') THEN
		UPDATE "organizations" SET "organizations_user_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "organizations_users" WHERE "organization_id" = NEW."organization_id") t WHERE "id" = NEW."organization_id";
	        UPDATE "users" SET "joined_organization_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "organizations_users" WHERE "user_id" = NEW."user_id") t WHERE "id" = NEW."user_id";
	        UPDATE "users" SET "owner_organization_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "organizations_users" WHERE "user_id" = NEW."user_id" AND "is_admin" = true) t WHERE "id" = NEW."user_id";
	        UPDATE "users" SET "member_organization_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "organizations_users" WHERE "user_id" = NEW."user_id" AND "is_admin" = false) t WHERE "id" = NEW."user_id";
		RETURN NEW;
	END IF;
END;
$$;

ALTER TABLE users ADD CONSTRAINT username CHECK (char_length(username) > 0);
ALTER TABLE users ADD CONSTRAINT password CHECK (char_length(password) > 0);
ALTER TABLE boards ADD CONSTRAINT name CHECK (char_length(name) > 0);
ALTER TABLE lists ADD CONSTRAINT name CHECK (char_length(name) > 0);
ALTER TABLE cards ADD CONSTRAINT name CHECK (char_length(name) > 0);
ALTER TABLE checklists ADD CONSTRAINT name CHECK (char_length(name) > 0);
ALTER TABLE checklist_items ADD CONSTRAINT name CHECK (char_length(name) > 0);
ALTER TABLE organizations ADD CONSTRAINT name CHECK (char_length(name) > 0);
ALTER TABLE labels ADD CONSTRAINT name CHECK (char_length(name) > 0);

CREATE OR REPLACE VIEW cards_elasticsearch_listing AS 
 SELECT card.id,
 row_to_json(card.*) AS json
 FROM (
	SELECT 
	cards.id,
	cards.board_id,
	boards.name AS board,
	cards.list_id,
	lists.name AS list,
	cards.name,
	cards.description,
	cards.due_date,
	cards.created,
	cards.modified,
	(cards.is_archived)::integer AS is_archived,
	cards.attachment_count,
	( SELECT array_to_json(array_agg(row_to_json(cc.*))) AS array_to_json
		FROM ( SELECT boards_users.user_id
			FROM boards_users boards_users
			WHERE (boards_users.board_id = cards.board_id)
			ORDER BY boards_users.id) cc
	) AS board_users,
	( SELECT array_to_json(array_agg(row_to_json(cc.*))) AS array_to_json
		FROM ( SELECT board_stars.user_id
			FROM board_stars board_stars
			WHERE (board_stars.board_id = cards.board_id)
			ORDER BY board_stars.id) cc
	) AS board_stars,
	( SELECT array_to_json(array_agg(row_to_json(cc.*))) AS array_to_json
		FROM ( SELECT checklists.name,
			checklist_items.name as checklist_item_name
			FROM checklists checklists
			LEFT JOIN checklist_items checklist_items ON ((checklist_items.checklist_id = checklists.id))
			WHERE checklists.card_id = cards.id
	ORDER BY checklists.id) cc) AS cards_checklists,
	( SELECT array_to_json(array_agg(row_to_json(cc.*))) AS array_to_json
		FROM ( SELECT cards_users_listing.username,
			cards_users_listing.user_id
			FROM cards_users_listing cards_users_listing
			WHERE cards_users_listing.card_id = cards.id
	ORDER BY cards_users_listing.id) cc) AS cards_users,
	( SELECT array_to_json(array_agg(row_to_json(cl.*))) AS array_to_json
		FROM ( SELECT cards_labels.name
			FROM cards_labels_listing cards_labels
			WHERE cards_labels.card_id = cards.id
	ORDER BY cards_labels.id) cl) AS cards_labels,
	( SELECT array_to_json(array_agg(row_to_json(cl.*))) AS array_to_json
		FROM ( SELECT activities.comment
			FROM activities activities
			WHERE (activities.type = 'add_comment' AND activities.card_id = cards.id)
	ORDER BY activities.id) cl) AS activities
	FROM cards cards
	LEFT JOIN boards boards ON boards.id = cards.board_id
	LEFT JOIN lists lists ON lists.id = cards.list_id
 ) card;
