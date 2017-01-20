UPDATE "email_templates" SET "email_text_content" = '<html>
<head><meta http-equiv="Content-Type" content="text/html; charset=utf-8" /></head>
<body style="margin:0">
<header style="display:block;width:100%;padding-left:0;padding-right:0; border-bottom:solid 1px #dedede; float:left;background-color: #f7f7f7;">
<div style="border: 1px solid #EEEEEE;">
<h1 style="text-align:center;margin:10px 15px 5px;"> <a href="##SITE_URL##" title="##SITE_NAME##"><img src="##SITE_URL##/img/logo.png" alt="[Restyaboard]" title="##SITE_NAME##"></a> </h1>
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
<a href="http://restya.com/board/?utm_source=Restyaboard - ##SITE_NAME##&utm_medium=email&utm_campaign=welcome_email" title="Open source. Trello like kanban board." rel="generator" style="font-size: 11px;text-align: center;text-decoration: none;color: #000;font-family: arial; padding-left:10px;">Powered by Restyaboard</a></h6>
</footer>
</body>
</html>' WHERE "name" = 'welcome';

UPDATE "email_templates" SET "email_text_content" = '<html>
<head><meta http-equiv="Content-Type" content="text/html; charset=utf-8" /></head>
<body style="margin:0">
<header style="display:block;width:100%;padding-left:0;padding-right:0; border-bottom:solid 1px #dedede; float:left;background-color: #f7f7f7;">
<div style="border: 1px solid #EEEEEE;">
<h1 style="text-align:center;margin:10px 15px 5px;"> <a href="##SITE_URL##" title="##SITE_NAME##"><img src="##SITE_URL##/img/logo.png" alt="[Restyaboard]" title="##SITE_NAME##"></a> </h1>
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
<a href="http://restya.com/board/?utm_source=Restyaboard - ##SITE_NAME##&utm_medium=email&utm_campaign=change_password_email" title="Open source. Trello like kanban board." rel="generator" style="font-size: 11px;text-align: center;text-decoration: none;color: #000;font-family: arial; padding-left:10px;">Powered by Restyaboard</a></h6>
</footer>
</body>
</html>' WHERE "name" = 'changepassword';

UPDATE "email_templates" SET "email_text_content" = '<html>
<head><meta http-equiv="Content-Type" content="text/html; charset=utf-8" /></head>
<body style="margin:0">
<header style="display:block;width:100%;padding-left:0;padding-right:0; border-bottom:solid 1px #dedede; float:left;background-color: #f7f7f7;">
<div style="border: 1px solid #EEEEEE;">
<h1 style="text-align:center;margin:10px 15px 5px;"> <a href="##SITE_URL##" title="##SITE_NAME##"><img src="##SITE_URL##/img/logo.png" alt="[Restyaboard]" title="##SITE_NAME##"></a> </h1>
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
<a href="http://restya.com/board/?utm_source=Restyaboard - ##SITE_NAME##&utm_medium=email&utm_campaign=new_board_member_email" title="Open source. Trello like kanban board." rel="generator" style="font-size: 11px;text-align: center;text-decoration: none;color: #000;font-family: arial; padding-left:10px;">Powered by Restyaboard</a></h6>
</footer>
</body>
</html>' WHERE "name" = 'newprojectuser';

UPDATE "email_templates" SET "email_text_content" = '<html>
<head><meta http-equiv="Content-Type" content="text/html; charset=utf-8" /></head>
<body style="margin:0">
<header style="display:block;width:100%;padding-left:0;padding-right:0; border-bottom:solid 1px #dedede; float:left;background-color: #f7f7f7;">
<div style="border: 1px solid #EEEEEE;">
<h1 style="text-align:center;margin:10px 15px 5px;"> <a href="##SITE_URL##" title="Restyaboard"><img src="##SITE_URL##/img/logo.png" alt="[Restyaboard]" title="Restyaboard"></a> </h1>
</div>
</header>
<main style="width:100%;padding-top:10px; padding-bottom:10px; margin:0 auto; float:left;">
<div style="background-color:#f3f5f7;padding:10px;border: 1px solid #EEEEEE;">
<div style="width: 500px;background-color: #f3f5f7;margin:0 auto;">
<div style="font-family: Arial, Helvetica, sans-serif; font-size: 13px;line-height:20px;margin-top:30px;"><h2 style="font-size:16px; font-family:Arial, Helvetica, sans-serif; margin: 7px 0px 0px 43px;padding:35px 0px 0px 0px;">Here''s what you missed…</h2>
<div style="white-space: normal; width: 100%;margin: 10px 0px 0px; font-family:Arial, Helvetica, sans-serif;">##CONTENT##</div>
</div>
</div>
</div>
<div style="text-align:center;margin:5px 15px;padding:10px 0px;">
<a href="##SITE_URL##/#/user/##USER_ID##/settings">Change email preferences</a>
</div>
</main>
<footer style="width:100%;padding-left:0;margin:0px auto;border-top: solid 1px #dedede; padding-bottom:10px; background:#fff;clear: both;padding-top: 10px;border-bottom: solid 1px #dedede;background-color: #f7f7f7;">
<h6 style="text-align:center;margin:5px 15px;"> 
<a href="http://restya.com/board/?utm_source=Restyaboard - ##SITE_NAME##&utm_medium=email&utm_campaign=notification_email" title="Open source. Trello like kanban board." rel="generator" style="font-size: 11px;text-align: center;text-decoration: none;color: #000;font-family: arial; padding-left:10px;">Powered by Restyaboard</a>
</h6>
</footer>
</body>
</html>' WHERE "name" = 'email_notification';

UPDATE "email_templates" SET "email_text_content" = '<html>
<head><meta http-equiv="Content-Type" content="text/html; charset=utf-8" /></head>
<body style="margin:0">
<header style="display:block;width:100%;padding-left:0;padding-right:0; border-bottom:solid 1px #dedede; float:left;background-color: #f7f7f7;">
<div style="border: 1px solid #EEEEEE;">
<h1 style="text-align:center;margin:10px 15px 5px;"> <a href="##SITE_URL##" title="##SITE_NAME##"><img src="##SITE_URL##/img/logo.png" alt="[Restyaboard]" title="##SITE_NAME##"></a> </h1>
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
<a href="http://restya.com/board/?utm_source=Restyaboard - ##SITE_NAME##&utm_medium=email&utm_campaign=activation_email" title="Open source. Trello like kanban board." rel="generator" style="font-size: 11px;text-align: center;text-decoration: none;color: #000;font-family: arial; padding-left:10px;">Powered by Restyaboard</a></h6>
</footer>
</body>
</html>' WHERE "name" = 'activation';

UPDATE "email_templates" SET "email_text_content" = '<html>
<head><meta http-equiv="Content-Type" content="text/html; charset=utf-8" /></head>
<body style="margin:0">
<header style="display:block;width:100%;padding-left:0;padding-right:0; border-bottom:solid 1px #dedede; float:left;background-color: #f7f7f7;">
<div style="border: 1px solid #EEEEEE;">
<h1 style="text-align:center;margin:10px 15px 5px;"> <a href="##SITE_URL##" title="##SITE_NAME##"><img src="##SITE_URL##/img/logo.png" alt="[Restyaboard]" title="##SITE_NAME##"></a> </h1>
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
<a href="http://restya.com/board/?utm_source=Restyaboard - ##SITE_NAME##&utm_medium=email&utm_campaign=forgot_password_email" title="Open source. Trello like kanban board." rel="generator" style="font-size: 11px;text-align: center;text-decoration: none;color: #000;font-family: arial; padding-left:10px;">Powered by Restyaboard</a></h6>
</footer>
</body>
</html>' WHERE "name" = 'forgetpassword';

UPDATE "email_templates" SET "email_text_content" = '<html>
<head><meta http-equiv="Content-Type" content="text/html; charset=utf-8" /></head>
<body style="margin:0">
<header style="display:block;width:100%;padding-left:0;padding-right:0; border-bottom:solid 1px #dedede; float:left;background-color: #f7f7f7;">
<div style="border: 1px solid #EEEEEE;">
<h1 style="text-align:center;margin:10px 15px 5px;"> <a href="##SITE_URL##" title="##SITE_NAME##"><img src="##SITE_URL##/img/logo.png" alt="[Restyaboard]" title="##SITE_NAME##"></a> </h1>
</div>
</header>
<main style="width:100%;padding-top:10px; padding-bottom:10px; margin:0 auto; float:left;">
<div style="background-color:#f3f5f7;padding:10px;border: 1px solid #EEEEEE;">
<div style="width: 500px;background-color: #f3f5f7;margin:0 auto;">
<pre style="font-family: Arial, Helvetica, sans-serif; font-size: 13px;line-height:20px;">
<h2 style="font-size:16px; font-family:Arial, Helvetica, sans-serif; margin: 7px 0px 0px 43px;padding:35px 0px 0px 0px;">Due soon…</h2>
<p style="white-space: normal; width: 100%;margin: 10px 0px 0px; font-family:Arial, Helvetica, sans-serif;">##CONTENT##</p>
</pre>
</div>
</div>
</main>
<footer style="width:100%;padding-left:0;margin:0px auto;border-top: solid 1px #dedede; padding-bottom:10px; background:#fff;clear: both;padding-top: 10px;border-bottom: solid 1px #dedede;background-color: #f7f7f7;">
<h6 style="text-align:center;margin:5px 15px;"> 
<a href="http://restya.com/board/?utm_source=Restyaboard - ##SITE_NAME##&utm_medium=email&utm_campaign=due_date_notification_email" title="Open source. Trello like kanban board." rel="generator" style="font-size: 11px;text-align: center;text-decoration: none;color: #000;font-family: arial; padding-left:10px;">Powered by Restyaboard</a>
</h6>
</footer>
</body>
</html>' WHERE "name" = 'due_date_notification';

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
                    cards_labels.card_id,
                    cards_labels.list_id,
                    cards_labels.board_id,
                    cards_labels.name
                   FROM cards_labels_listing cards_labels
                  WHERE (cards_labels.card_id = cards.id)
                  ORDER BY cards_labels.name) cl) AS cards_labels,
    cards.comment_count,
    u.username,
    b.name AS board_name,
    l.name AS list_name,
    cards.custom_fields,
    cards.due_date as notification_due_date
   FROM (((cards cards
     LEFT JOIN users u ON ((u.id = cards.user_id)))
     LEFT JOIN boards b ON ((b.id = cards.board_id)))
     LEFT JOIN lists l ON ((l.id = cards.list_id)));

UPDATE users SET timezone = '+0530';

DELETE FROM setting_categories WHERE id = 13;
DELETE FROM settings WHERE id >= 52;

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
    card.position AS card_position,
    card.comment_count AS comment_count
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

INSERT INTO "email_templates" ("id", "created", "modified", "from_email", "reply_to_email", "name", "description", "subject", "email_text_content", "email_variables", "display_name") values ('8', '2014-05-08 12:14:07.472', '2014-05-08 12:14:07.472', '##SITE_NAME## Restyaboard <##FROM_EMAIL##>', '##REPLY_TO_EMAIL##', 'ldap_welcome', 'We will send this mail, when admin imports from LDAP.', 'Restyaboard / Welcome', '<html>
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
<pre style="font-family: Arial, Helvetica, sans-serif; font-size: 13px;line-height:20px;"><h2 style="font-size:16px; font-family:Arial, Helvetica, sans-serif; margin: 20px 0px 0px;padding:10px 0px 0px 0px;">Hi ##NAME##,</h2><p style="white-space: normal; width: 100%;margin: 10px 0px 0px; font-family:Arial, Helvetica, sans-serif;"><br></p><p style="white-space: normal; width: 100%;margin: 0px 0px 0px; font-family:Arial, Helvetica, sans-serif;">Admin imported your LDAP account in ##SITE_NAME##. You can login with your LDAP username and password in ##SITE_URL##.<br></p><br><p style="white-space: normal; width: 100%;margin: 0px 0px 0px;font-family:Arial, Helvetica, sans-serif;">Thanks,<br>
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
</html>', 'SITE_URL, SITE_NAME, CONTACT_EMAIL, NAME', 'LDAP Welcome');

DELETE FROM acl_links_roles WHERE id IN (SELECT id FROM  acl_links WHERE name='Unstar board' ORDER BY id DESC LIMIT 1);

DELETE FROM acl_links WHERE id  = (SELECT id FROM acl_links WHERE name='Unstar board' ORDER BY id DESC LIMIT 1);

DELETE FROM acl_links_roles WHERE id IN (SELECT id FROM  acl_links WHERE name='XMPP chat login' ORDER BY id DESC LIMIT 1);

DELETE FROM acl_links WHERE id  = (SELECT id FROM acl_links WHERE name='XMPP chat login' ORDER BY id DESC LIMIT 1);

DELETE FROM acl_links_roles WHERE id IN (SELECT id FROM  acl_links WHERE name='Chat History' ORDER BY id DESC LIMIT 1);

DELETE FROM acl_links WHERE id  = (SELECT id FROM acl_links WHERE name='Chat History' ORDER BY id DESC LIMIT 1);

DELETE FROM "settings"
WHERE (("name" = 'elasticsearch.last_processed_activity_id') OR ("name" = 'chat.last_processed_chat_id') );

DELETE FROM "settings"
WHERE (("name" = 'LDAP_LOGIN_ENABLED') OR ("name" = 'LDAP_PORT') OR ("name" = 'LDAP_UID_FIELD') OR ("name" = 'LDAP_BIND_DN')  
OR ("name" = 'LDAP_BIND_PASSWD') OR ("name" = 'LDAP_PROTOCOL_VERSION') OR ("name" = 'LDAP_ROOT_DN')  
OR ("name" = 'LDAP_SERVER'));

DELETE FROM "settings"
WHERE (("name" = 'TODO') OR ("name" = 'DOING') OR ("name" = 'DONE') OR ("name" = 'TODO_COLOR')  
OR ("name" = 'DOING_COLOR') OR ("name" = 'DONE_COLOR') OR ("name" = 'TODO_ICON')  
OR ("name" = 'DOING_ICON') OR ("name" = 'DONE_ICON'));

DELETE FROM "settings"
WHERE (("name" = 'ELASTICSEARCH_URL') OR ("name" = 'ELASTICSEARCH_INDEX'));

DELETE FROM "settings"
WHERE (("name" = 'JABBER_HOST') OR ("name" = 'BOSH_SERVICE_URL'));

DELETE FROM "setting_categories"
WHERE (("name" = 'XMPP Chat') OR ("name" = 'Cards Workflow') OR ("name" = 'ElasticSearch'));

UPDATE "settings" SET "setting_category_parent_id" = '0', "setting_category_id" = '3', "label" = 'Standard login/register', "order" = '8' WHERE "name" = 'STANDARD_LOGIN_ENABLED';

DELETE FROM "settings" WHERE"name" = 'ENABLE_SSL_CONNECTIVITY';

DELETE FROM "setting_categories" WHERE "name" = 'Login';

ALTER TABLE "acl_board_links_boards_user_roles" ADD CONSTRAINT "acl_board_links_boards_user_roles_id" PRIMARY KEY ("id");
CREATE INDEX "acl_board_links_boards_user_roles_acl_board_link_id" ON "acl_board_links_boards_user_roles" ("acl_board_link_id");
CREATE INDEX "acl_board_links_boards_user_roles_board_user_role_id" ON "acl_board_links_boards_user_roles" ("board_user_role_id");

ALTER TABLE "acl_links" ADD CONSTRAINT "acl_links_id" PRIMARY KEY ("id");
CREATE INDEX "acl_links_slug" ON "acl_links" ("slug");
CREATE INDEX "acl_links_group_id" ON "acl_links" ("group_id");

ALTER TABLE "acl_links_roles" ADD CONSTRAINT "acl_links_roles_id" PRIMARY KEY ("id");
CREATE INDEX "acl_links_roles_acl_link_id" ON "acl_links_roles" ("acl_link_id");
CREATE INDEX "acl_links_roles_role_id" ON "acl_links_roles" ("role_id");

ALTER TABLE "acl_organization_links_organizations_user_roles" ADD CONSTRAINT "acl_organization_links_organizations_user_roles_id" PRIMARY KEY ("id");
CREATE INDEX "acl_organization_links_organizations_user_roles_acl_organization_link_id" ON "acl_organization_links_organizations_user_roles" ("acl_organization_link_id");
CREATE INDEX "acl_organization_links_organizations_user_roles_organization_user_role_id" ON "acl_organization_links_organizations_user_roles" ("organization_user_role_id");

ALTER TABLE "board_stars" ADD CONSTRAINT "board_stars_id" PRIMARY KEY ("id");

ALTER TABLE "board_user_roles" ADD CONSTRAINT "board_user_roles_id" PRIMARY KEY ("id");

CREATE INDEX "boards_users_board_user_role_id" ON "boards_users" ("board_user_role_id");

ALTER TABLE "login_types" ADD CONSTRAINT "login_types_id" PRIMARY KEY ("id");

ALTER TABLE "organization_user_roles" ADD CONSTRAINT "organization_user_roles_id" PRIMARY KEY ("id");

CREATE INDEX "organizations_users_organization_user_role_id" ON "organizations_users" ("organization_user_role_id");

CREATE INDEX "users_last_email_notified_activity_id" ON "users" ("last_email_notified_activity_id");
CREATE INDEX "users_login_type_id" ON "users" ("login_type_id");
CREATE INDEX "users_ip_id" ON "users" ("ip_id");
CREATE INDEX "users_last_login_ip_id" ON "users" ("last_login_ip_id");

ALTER TABLE "webhooks" ADD CONSTRAINT "webhooks_id" PRIMARY KEY ("id");
CREATE INDEX "webhooks_url" ON "webhooks" ("url");

ALTER TABLE "user_logins" ADD CONSTRAINT "user_logins_id" PRIMARY KEY ("id");
CREATE INDEX "user_logins_user_id" ON "user_logins" ("user_id");
CREATE INDEX "user_logins_ip_id" ON "user_logins" ("ip_id");

CREATE INDEX "ips_ip" ON "ips" ("ip");
CREATE INDEX "ips_city_id" ON "ips" ("city_id");
CREATE INDEX "ips_state_id" ON "ips" ("state_id");
CREATE INDEX "ips_country_id" ON "ips" ("country_id");

DROP VIEW simple_board_listing;
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
                    (lists.is_deleted)::integer AS is_deleted
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
    org.logo_url AS organization_logo_url,
    board.music_content,
    board.music_name
   FROM (boards board
     LEFT JOIN organizations org ON ((org.id = board.organization_id)))
  ORDER BY board.name;

DROP VIEW users_listing;

ALTER TABLE "users" ALTER "password" TYPE character varying(256), ALTER "password" DROP DEFAULT, ALTER "password" SET NOT NULL;

CREATE VIEW "users_listing" AS
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
