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
    u.full_name AS card_created_user,
    cards.cover_image_id,
    (l.is_archived)::integer AS list_is_archived
   FROM (((cards cards
     LEFT JOIN users u ON ((u.id = cards.user_id)))
     LEFT JOIN boards b ON ((b.id = cards.board_id)))
     LEFT JOIN lists l ON ((l.id = cards.list_id)));

DELETE FROM "acl_links_roles" WHERE acl_link_id = (select id from acl_links where slug='user_activities_listing');
DELETE FROM "acl_links" WHERE slug = 'user_activities_listing';

SELECT pg_catalog.setval('acl_links_id_seq', (SELECT MAX(id) FROM acl_links), true);

INSERT INTO "acl_links" ("created", "modified", "name", "url", "method", "slug", "group_id", "is_user_action", "is_guest_action", "is_admin_action", "is_hide", "is_default") values ('now()', 'now()', 'User activities', '/users/?/activities', 'GET', 'user_activities_listing', '2', '1', '0', '0', '0', 't');

SELECT pg_catalog.setval('acl_links_roles_roles_id_seq', (SELECT MAX(id) FROM acl_links_roles), true);

INSERT INTO "acl_links_roles" ("created", "modified", "acl_link_id", "role_id") VALUES 
(now(), now(), (select id from acl_links where slug='user_activities_listing'), '1'),
(now(), now(), (select id from acl_links where slug='user_activities_listing'), '2');