SELECT pg_catalog.setval('settings_id_seq', (SELECT MAX(id) FROM settings), true);
SELECT pg_catalog.setval('setting_categories_id_seq', (SELECT MAX(id) FROM setting_categories), true);

UPDATE "settings" SET "description" = 'It is used in all outgoing emails' WHERE "name" = 'DEFAULT_CONTACT_EMAIL_ADDRESS';

UPDATE "countries" SET "name" = 'United States' WHERE "name" = 'UnitedStates';

INSERT INTO "acl_links" ("id", "created", "modified", "name", "url", "method", "slug", "group_id", "is_user_action", "is_guest_action", "is_admin_action", "is_hide")
VALUES ('40', now(), now(), 'Allow to post comments in public board', '/boards/?/lists/?/cards/?/comments', 'POST', 'comment_card', '2', '1', '0', '0', '0'),
('41', now(), now(), 'Allow to subscribe board in public board', '/boards/?/board_subscribers', 'POST', 'subscribe_board', '2', '1', '0', '0', '0'),
('42', now(), now(), 'Allow to subscribe list in public board', '/boards/?/lists/?/list_subscribers', 'POST', 'subscribe_list', '2', '1', '0', '0', '0'),
('43', now(), now(), 'Allow to subscribe card in public board', '/boards/?/lists/?/cards/?/card_subscribers', 'POST', 'subscribe_card', '2', '1', '0', '0', '0');

INSERT INTO "acl_links_roles" ("created", "modified", "acl_link_id", "role_id")
VALUES (now(), now(), '40', '1'),
(now(), now(), '40', '2'),
(now(), now(), '41', '1'),
(now(), now(), '41', '2'),
(now(), now(), '42', '1'),
(now(), now(), '42', '2'),
(now(), now(), '43', '1'),
(now(), now(), '43', '2');

UPDATE "acl_links" SET "name" = 'Allow to star/unstar in public board, card in public board' WHERE "slug" = 'starred_board';

DROP VIEW activities_listing;
CREATE OR REPLACE VIEW "activities_listing" AS
 SELECT activity.id,
    to_char(activity.created, 'YYYY-MM-DD"T"HH24:MI:SS') as created,
    to_char(activity.modified, 'YYYY-MM-DD"T"HH24:MI:SS') as modified,
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
    to_char(activity.created, 'HH24:MI'::text) AS created_time
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

DROP VIEW boards_labels_listing;
CREATE OR REPLACE VIEW "boards_labels_listing" AS
 SELECT cards_labels.id,
    to_char(cards_labels.created, 'YYYY-MM-DD"T"HH24:MI:SS') as created,
    to_char(cards_labels.modified, 'YYYY-MM-DD"T"HH24:MI:SS') as modified,
    cards_labels.label_id,
    cards_labels.card_id,
    cards_labels.list_id,
    cards_labels.board_id,
    labels.name
   FROM (cards_labels cards_labels
   LEFT JOIN labels labels ON ((labels.id = cards_labels.label_id)));

DROP VIEW boards_users_listing CASCADE;
CREATE OR REPLACE VIEW "boards_users_listing" AS
 SELECT bu.id,
    to_char(bu.created, 'YYYY-MM-DD"T"HH24:MI:SS') as created,
    to_char(bu.modified, 'YYYY-MM-DD"T"HH24:MI:SS') as modified,
    bu.board_id,
    bu.user_id,
    bu.board_user_role_id,
    u.username,
    u.email,
    u.full_name,
    (u.is_active)::integer AS is_active,
    (u.is_email_confirmed)::integer AS is_email_confirmed,
    b.name AS board_name,
    u.profile_picture_path,
    u.initials,
    b.default_email_list_id,
    (b.is_default_email_position_as_bottom)::integer AS is_default_email_position_as_bottom
   FROM ((boards_users bu
   JOIN users u ON ((u.id = bu.user_id)))
   JOIN boards b ON ((b.id = bu.board_id)));

DROP VIEW card_voters_listing CASCADE;
CREATE OR REPLACE VIEW "card_voters_listing" AS
 SELECT card_voters.id,
    to_char(card_voters.created, 'YYYY-MM-DD"T"HH24:MI:SS') as created,
    to_char(card_voters.modified, 'YYYY-MM-DD"T"HH24:MI:SS') as modified,
    card_voters.user_id,
    card_voters.card_id,
    users.username,
    users.role_id,
    users.profile_picture_path,
    users.initials,
    users.full_name
   FROM (card_voters card_voters
   LEFT JOIN users users ON ((users.id = card_voters.user_id)));



DROP VIEW cards_labels_listing CASCADE;
CREATE OR REPLACE VIEW "cards_labels_listing" AS
 SELECT cl.id,
    to_char(cl.created, 'YYYY-MM-DD"T"HH24:MI:SS') as created,
    to_char(cl.modified, 'YYYY-MM-DD"T"HH24:MI:SS') as modified,
    cl.label_id,
    cl.card_id,
    c.name AS card_name,
    c.list_id,
    l.name,
    cl.board_id
   FROM ((cards_labels cl
   LEFT JOIN cards c ON ((c.id = cl.card_id)))
   LEFT JOIN labels l ON ((l.id = cl.label_id)));

CREATE OR REPLACE VIEW "simple_board_listing" AS
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
		    to_char(lists.created, 'YYYY-MM-DD"T"HH24:MI:SS') as created,
		    to_char(lists.modified, 'YYYY-MM-DD"T"HH24:MI:SS') as modified,
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
    ( SELECT array_to_json(array_agg(row_to_json(l.*))) AS array_to_json
           FROM ( SELECT bu.id,
                    bu.board_id,
                    bu.user_id,
                    bu.board_user_role_id
                   FROM boards_users bu
                  WHERE (bu.board_id = board.id)
                  ORDER BY bu.id) l) AS users,
    org.logo_url AS organization_logo_url,
    board.music_content,
    board.music_name
   FROM (boards board
   LEFT JOIN organizations org ON ((org.id = board.organization_id)))
  ORDER BY board.name;

DROP VIEW cards_users_listing CASCADE;
CREATE OR REPLACE VIEW "cards_users_listing" AS
 SELECT u.username,
    u.profile_picture_path,
    cu.id,
    to_char(cu.created, 'YYYY-MM-DD"T"HH24:MI:SS') as created,
    to_char(cu.modified, 'YYYY-MM-DD"T"HH24:MI:SS') as modified,
    cu.card_id,
    cu.user_id,
    u.initials,
    u.full_name,
    u.email
   FROM (cards_users cu
   LEFT JOIN users u ON ((u.id = cu.user_id)));

CREATE OR REPLACE VIEW "cards_elasticsearch_listing" AS
 SELECT card.id,
    row_to_json(card.*) AS json
   FROM ( SELECT cards.id,
            cards.board_id,
            boards.name AS board,
            cards.list_id,
            lists.name AS list,
            cards.name,
            cards.description,
            cards.due_date,
	    to_char(cards.created, 'YYYY-MM-DD"T"HH24:MI:SS') as created,
	    to_char(cards.modified, 'YYYY-MM-DD"T"HH24:MI:SS') as modified,
            (cards.is_archived)::integer AS is_archived,
            cards.attachment_count,
            ( SELECT array_to_json(array_agg(row_to_json(cc.*))) AS array_to_json
                   FROM ( SELECT boards_users.user_id
                           FROM boards_users boards_users
                          WHERE (boards_users.board_id = cards.board_id)
                          ORDER BY boards_users.id) cc) AS board_users,
            ( SELECT array_to_json(array_agg(row_to_json(cc.*))) AS array_to_json
                   FROM ( SELECT board_stars.user_id
                           FROM board_stars board_stars
                          WHERE (board_stars.board_id = cards.board_id)
                          ORDER BY board_stars.id) cc) AS board_stars,
            ( SELECT array_to_json(array_agg(row_to_json(cc.*))) AS array_to_json
                   FROM ( SELECT checklists.name,
                            checklist_items.name AS checklist_item_name
                           FROM (checklists checklists
                      LEFT JOIN checklist_items checklist_items ON ((checklist_items.checklist_id = checklists.id)))
                     WHERE (checklists.card_id = cards.id)
                     ORDER BY checklists.id) cc) AS cards_checklists,
            ( SELECT array_to_json(array_agg(row_to_json(cc.*))) AS array_to_json
                   FROM ( SELECT cards_users_listing.username,
                            cards_users_listing.user_id
                           FROM cards_users_listing cards_users_listing
                          WHERE (cards_users_listing.card_id = cards.id)
                          ORDER BY cards_users_listing.id) cc) AS cards_users,
            ( SELECT array_to_json(array_agg(row_to_json(cl.*))) AS array_to_json
                   FROM ( SELECT cards_labels.name
                           FROM cards_labels_listing cards_labels
                          WHERE (cards_labels.card_id = cards.id)
                          ORDER BY cards_labels.id) cl) AS cards_labels,
            ( SELECT array_to_json(array_agg(row_to_json(cl.*))) AS array_to_json
                   FROM ( SELECT activities.comment
                           FROM activities activities
                          WHERE (((activities.type)::text = 'add_comment'::text) AND (activities.card_id = cards.id))
                          ORDER BY activities.id) cl) AS activities
           FROM ((cards cards
      LEFT JOIN boards boards ON ((boards.id = cards.board_id)))
   LEFT JOIN lists lists ON ((lists.id = cards.list_id)))) card;


DROP VIEW checklists_listing CASCADE;
CREATE OR REPLACE VIEW "checklists_listing" AS
 SELECT checklists.id,
    to_char(checklists.created, 'YYYY-MM-DD"T"HH24:MI:SS') as created,
    to_char(checklists.modified, 'YYYY-MM-DD"T"HH24:MI:SS') as modified,
    checklists.user_id,
    checklists.card_id,
    checklists.name,
    checklists.checklist_item_count,
    checklists.checklist_item_completed_count,
    ( SELECT array_to_json(array_agg(row_to_json(ci.*))) AS array_to_json
           FROM ( SELECT checklist_items.id,
                    checklist_items.created,
                    checklist_items.modified,
                    checklist_items.user_id,
                    checklist_items.card_id,
                    checklist_items.checklist_id,
                    checklist_items.name,
                    (checklist_items.is_completed)::integer AS is_completed,
                    checklist_items."position"
                   FROM checklist_items checklist_items
                  WHERE (checklist_items.checklist_id = checklists.id)
                  ORDER BY checklist_items."position") ci) AS checklists_items,
    checklists."position"
   FROM checklists checklists;
   
ALTER TABLE "boards" ADD "custom_fields" text NULL;
ALTER TABLE "cards" ADD "custom_fields" text NULL;
ALTER TABLE "lists" ADD "custom_fields" text NULL;

CREATE OR REPLACE VIEW "cards_listing" AS
 SELECT cards.id,
    to_char(cards.created, 'YYYY-MM-DD"T"HH24:MI:SS') as created,
    to_char(cards.modified, 'YYYY-MM-DD"T"HH24:MI:SS') as modified,
    cards.board_id,
    cards.list_id,
    cards.name,
    cards.description,
    to_char(cards.due_date, 'YYYY-MM-DD"T"HH24:MI:SS') as due_date,
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
		    to_char(cards_subscribers.created, 'YYYY-MM-DD"T"HH24:MI:SS') as created,
		    to_char(cards_subscribers.modified, 'YYYY-MM-DD"T"HH24:MI:SS') as modified,
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
                  ORDER BY cards_labels.id) cl) AS cards_labels,
    cards.comment_count,
    u.username,
    b.name AS board_name,
    l.name AS list_name,
	cards.custom_fields
   FROM (((cards cards
   LEFT JOIN users u ON ((u.id = cards.user_id)))
   LEFT JOIN boards b ON ((b.id = cards.board_id)))
   LEFT JOIN lists l ON ((l.id = cards.list_id)));

CREATE OR REPLACE VIEW "lists_listing" AS
 SELECT lists.id,
    to_char(lists.created, 'YYYY-MM-DD"T"HH24:MI:SS') as created,
    to_char(lists.modified, 'YYYY-MM-DD"T"HH24:MI:SS') as modified,
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
					cards_listing.custom_fields
                   FROM cards_listing cards_listing
                  WHERE (cards_listing.list_id = lists.id)
                  ORDER BY cards_listing."position") lc) AS cards,
    ( SELECT array_to_json(array_agg(row_to_json(ls.*))) AS array_to_json
           FROM ( SELECT lists_subscribers.id,
		    to_char(lists_subscribers.created, 'YYYY-MM-DD"T"HH24:MI:SS') as created,
		    to_char(lists_subscribers.modified, 'YYYY-MM-DD"T"HH24:MI:SS') as modified,
                    lists_subscribers.list_id,
                    lists_subscribers.user_id,
                    (lists_subscribers.is_subscribed)::integer AS is_subscribed
                   FROM list_subscribers lists_subscribers
                  WHERE (lists_subscribers.list_id = lists.id)
                  ORDER BY lists_subscribers.id) ls) AS lists_subscribers,
	lists.custom_fields
   FROM lists lists;

CREATE OR REPLACE VIEW "boards_listing" AS
 SELECT board.id,
    board.name,
    to_char(board.created, 'YYYY-MM-DD"T"HH24:MI:SS') as created,
    to_char(board.modified, 'YYYY-MM-DD"T"HH24:MI:SS') as modified,
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
		    to_char(activities.created, 'YYYY-MM-DD"T"HH24:MI:SS') as created,
		    to_char(activities.modified, 'YYYY-MM-DD"T"HH24:MI:SS') as modified,
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
		    to_char(boards_subscribers.created, 'YYYY-MM-DD"T"HH24:MI:SS') as created,
		    to_char(boards_subscribers.modified, 'YYYY-MM-DD"T"HH24:MI:SS') as modified,
                    boards_subscribers.board_id,
                    boards_subscribers.user_id,
                    (boards_subscribers.is_subscribed)::integer AS is_subscribed
                   FROM board_subscribers boards_subscribers
                  WHERE (boards_subscribers.board_id = board.id)
                  ORDER BY boards_subscribers.id) bs) AS boards_subscribers,
    ( SELECT array_to_json(array_agg(row_to_json(bs.*))) AS array_to_json
           FROM ( SELECT boards_stars.id,
		    to_char(boards_stars.created, 'YYYY-MM-DD"T"HH24:MI:SS') as created,
		    to_char(boards_stars.modified, 'YYYY-MM-DD"T"HH24:MI:SS') as modified,
                    boards_stars.created,
                    boards_stars.modified,
                    boards_stars.board_id,
                    boards_stars.user_id,
                    (boards_stars.is_starred)::integer AS is_starred
                   FROM board_stars boards_stars
                  WHERE (boards_stars.board_id = board.id)
                  ORDER BY boards_stars.id) bs) AS boards_stars,
    ( SELECT array_to_json(array_agg(row_to_json(batt.*))) AS array_to_json
           FROM ( SELECT card_attachments.id,
		    to_char(card_attachments.created, 'YYYY-MM-DD"T"HH24:MI:SS') as created,
		    to_char(card_attachments.modified, 'YYYY-MM-DD"T"HH24:MI:SS') as modified,
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
					lists_listing.custom_fields
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
	board.custom_fields
   FROM ((boards board
   LEFT JOIN users users ON ((users.id = board.user_id)))
   LEFT JOIN organizations organizations ON ((organizations.id = board.organization_id)));

DROP VIEW gadget_users_listing;
CREATE OR REPLACE VIEW "gadget_users_listing" AS
 SELECT checklists.id,
    to_char(checklists.created, 'YYYY-MM-DD"T"HH24:MI:SS') as created,
    to_char(checklists.modified, 'YYYY-MM-DD"T"HH24:MI:SS') as modified,
    checklists.user_id,
    checklists.card_id,
    checklists.name,
    checklists.checklist_item_count,
    checklists.checklist_item_completed_count,
    ( SELECT array_to_json(array_agg(row_to_json(ci.*))) AS array_to_json
           FROM ( SELECT checklist_items.id,
		    to_char(checklist_items.created, 'YYYY-MM-DD"T"HH24:MI:SS') as created,
		    to_char(checklist_items.modified, 'YYYY-MM-DD"T"HH24:MI:SS') as modified,
                    checklist_items.user_id,
                    checklist_items.card_id,
                    checklist_items.checklist_id,
                    checklist_items.name,
                    (checklist_items.is_completed)::integer AS is_completed
                   FROM checklist_items checklist_items
                  WHERE (checklist_items.checklist_id = checklists.id)
                  ORDER BY checklist_items.id) ci) AS checklist_items
   FROM checklists checklists;


DROP VIEW organizations_users_listing CASCADE;
CREATE OR REPLACE VIEW "organizations_users_listing" AS
 SELECT organizations_users.id,
    to_char(organizations_users.created, 'YYYY-MM-DD"T"HH24:MI:SS') as created,
    to_char(organizations_users.modified, 'YYYY-MM-DD"T"HH24:MI:SS') as modified,
    organizations_users.user_id,
    organizations_users.organization_id,
    organizations_users.organization_user_role_id,
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
                    boards_users.board_user_role_id,
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


CREATE OR REPLACE VIEW "organizations_listing" AS
 SELECT organizations.id,
    to_char(organizations.created, 'YYYY-MM-DD"T"HH24:MI:SS') as created,
    to_char(organizations.modified, 'YYYY-MM-DD"T"HH24:MI:SS') as modified,
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

CREATE OR REPLACE VIEW "users_listing" AS
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
    to_char(users.created, 'YYYY-MM-DD"T"HH24:MI:SS') as created,
    users.user_login_count,
    users.is_send_newsletter,
    users.last_email_notified_activity_id,
    users.owner_board_count,
    users.member_board_count,
    users.owner_organization_count,
    users.member_organization_count,
    users.language,
    (users.is_ldap)::integer AS is_ldap
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

DROP VIEW settings_listing;
CREATE OR REPLACE VIEW "settings_listing" AS
 SELECT setting_categories.id,
    to_char(setting_categories.created, 'YYYY-MM-DD"T"HH24:MI:SS') as created,
    to_char(setting_categories.modified, 'YYYY-MM-DD"T"HH24:MI:SS') as modified,
    setting_categories.parent_id,
    setting_categories.name,
    setting_categories.description,
    ( SELECT array_to_json(array_agg(row_to_json(o.*))) AS array_to_json
           FROM ( SELECT settings.id,
                    settings.name,
                    settings.setting_category_id,
                    settings.setting_category_parent_id,
                    settings.value,
                    settings.type,
                    settings.options,
                    settings.label,
                    settings."order"
                   FROM settings settings
                  WHERE (settings.setting_category_id = setting_categories.id)
                  ORDER BY settings."order") o) AS settings
   FROM setting_categories setting_categories;

DROP VIEW users_cards_listing;
CREATE OR REPLACE VIEW "users_cards_listing" AS
 SELECT b.name AS board_name,
    l.name AS list_name,
    c.id,
    to_char(c.created, 'YYYY-MM-DD"T"HH24:MI:SS') as created,
    to_char(c.modified, 'YYYY-MM-DD"T"HH24:MI:SS') as modified,
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
    (c.is_deleted)::integer AS is_deleted,
    cu.user_id,
    c.comment_count
   FROM (((cards_users cu
   JOIN cards c ON ((c.id = cu.card_id)))
   JOIN boards b ON ((b.id = c.board_id)))
   JOIN lists l ON ((l.id = c.list_id)));
   
INSERT INTO "setting_categories" ("id", "created", "modified", "parent_id", "name", "description", "order")
VALUES (11, '2015-09-26 13:14:18', '2015-09-26 13:14:18', NULL, 'XMPP Chat', NULL, '5');

INSERT INTO "settings" ("setting_category_id", "setting_category_parent_id", "name", "value", "description", "type", "options", "label", "order") VALUES ('11', '0', 'BOSH_SERVICE_URL', '', NULL, 'text', NULL, 'Bosh Service URL', '1');

INSERT INTO "settings" ("setting_category_id", "setting_category_parent_id", "name", "value", "description", "type", "options", "label", "order") VALUES ('11', '0', 'JABBER_HOST', '', NULL, 'text', NULL, 'Jabber Host', '2');

INSERT INTO "acl_links" ("created", "modified", "name", "url", "method", "slug", "group_id", "is_user_action", "is_guest_action", "is_admin_action", "is_hide")
VALUES ('2015-10-05 13:14:18.2', '2015-10-05 13:14:18.2', 'XMPP chat login', '/xmpp_login', 'GET', 'xmpp_login', '2', '1', '0', '1', '0');

INSERT INTO "acl_links_roles" ("created", "modified", "acl_link_id", "role_id") SELECT '2016-02-20 19:07:50.849',	'2016-02-20 19:07:50.849',	id,	1 FROM acl_links WHERE slug = 'xmpp_login';

INSERT INTO "acl_links_roles" ("created", "modified", "acl_link_id", "role_id") SELECT '2016-02-20 19:07:50.849',	'2016-02-20 19:07:50.849',	id,	2 FROM acl_links WHERE slug = 'xmpp_login';

INSERT INTO "settings" ("setting_category_id", "setting_category_parent_id", "name", "value", "description", "type", "options", "label", "order") VALUES ('11', '0', 'XMPP_CLIENT_RESOURCE_NAME', '', NULL, 'text', NULL, 'Client Resource Name', '3');

INSERT INTO "settings" ("setting_category_id", "setting_category_parent_id", "name", "value", "description", "type", "options", "label", "order") VALUES ('11', '0', 'JABBER_PATH', '', NULL, 'text', NULL, 'Jabber Path', '4');

INSERT INTO "acl_links" ("created", "modified", "name", "url", "method", "slug", "group_id",  "is_user_action", "is_guest_action", "is_admin_action", "is_hide")
VALUES ('2015-10-05 13:14:18.2', '2015-10-05 13:14:18.2', 'Chat History', '/chat_history', 'GET', 'chat_history', '2',  '1', '0', '1', '0');

INSERT INTO "acl_links_roles" ("created", "modified", "acl_link_id", "role_id") SELECT '2016-02-20 19:07:50.849',	'2016-02-20 19:07:50.849',	id,	1 FROM acl_links WHERE slug = 'chat_history';

INSERT INTO "acl_links_roles" ("created", "modified", "acl_link_id", "role_id") SELECT '2016-02-20 19:07:50.849',	'2016-02-20 19:07:50.849',	id,	2 FROM acl_links WHERE slug = 'chat_history';

INSERT INTO "settings" ("setting_category_id", "setting_category_parent_id", "name", "value", "description", "type", "options", "label", "order") VALUES ('0', '0', 'chat.last_processed_chat_id', '0', NULL, 'hidden', NULL, 'Last Chat ID', '1');

UPDATE "acl_board_links" SET "url" = '/boards/?/boards_users/?' WHERE "slug" = 'remove_board_user';

INSERT INTO "acl_links" ("created", "modified", "name", "url", "method", "slug", "group_id", "is_user_action", "is_guest_action", "is_admin_action", "is_hide")
VALUES (now(), now(), 'Role add', '/roles', 'POST', 'role_add', '1', '0', '0', '1', '1'),
(now(), now(), 'Board user role add', '/board_user_roles', 'POST', 'board_user_role_add', '1', '0', '0', '1', '1'),
(now(), now(), 'Organization user role add', '/organization_user_roles', 'POST', 'organization_user_role_add', '1', '0', '0', '1', '1');


INSERT INTO "acl_links_roles" ("created", "modified", "acl_link_id", "role_id") SELECT '2016-02-20 19:07:50.849', '2016-02-20 19:07:50.849', id, 1 FROM acl_links WHERE slug = 'role_add';
INSERT INTO "acl_links_roles" ("created", "modified", "acl_link_id", "role_id") SELECT '2016-02-20 19:07:50.849', '2016-02-20 19:07:50.849', id, 1 FROM acl_links WHERE slug = 'board_user_role_add';
INSERT INTO "acl_links_roles" ("created", "modified", "acl_link_id", "role_id") SELECT '2016-02-20 19:07:50.849', '2016-02-20 19:07:50.849', id, 1 FROM acl_links WHERE slug = 'organization_user_role_add';


INSERT INTO "acl_links" ("created", "modified", "name", "url", "method", "slug", "group_id", "is_user_action", "is_guest_action", "is_admin_action", "is_hide")
VALUES (now(), now(), 'Role edit', '/roles/?', 'PUT', 'role_edit', '1', '0', '0', '1', '1'),
(now(), now(), 'Board user role edit', '/board_user_roles/?', 'PUT', 'board_user_role_edit', '1', '0', '0', '1', '1'),
(now(), now(), 'Organization user role edit', '/organization_user_roles/?', 'PUT', 'organization_user_role_edit', '1', '0', '0', '1', '1');


INSERT INTO "acl_links_roles" ("created", "modified", "acl_link_id", "role_id") SELECT '2016-02-20 19:07:50.849', '2016-02-20 19:07:50.849', id, 1 FROM acl_links WHERE slug = 'role_edit';
INSERT INTO "acl_links_roles" ("created", "modified", "acl_link_id", "role_id") SELECT '2016-02-20 19:07:50.849', '2016-02-20 19:07:50.849', id, 1 FROM acl_links WHERE slug = 'board_user_role_edit';
INSERT INTO "acl_links_roles" ("created", "modified", "acl_link_id", "role_id") SELECT '2016-02-20 19:07:50.849', '2016-02-20 19:07:50.849', id, 1 FROM acl_links WHERE slug = 'organization_user_role_edit';

CREATE VIEW "admin_boards_listing" AS
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
    (board.is_closed)::integer AS is_closed,
    board.boards_user_count,
    board.list_count,
    board.card_count,
    board.archived_list_count,
    board.archived_card_count,
    board.boards_subscriber_count,
    board.background_pattern_url,
    board.music_name,
    organizations.name AS organization_name,
    organizations.website_url AS organization_website_url,
    organizations.description AS organization_description,
    organizations.logo_url AS organization_logo_url,
    organizations.organization_visibility,
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
    board.is_default_email_position_as_bottom
   FROM ((boards board
   LEFT JOIN users users ON ((users.id = board.user_id)))
   LEFT JOIN organizations organizations ON ((organizations.id = board.organization_id)));

INSERT INTO "settings" ("setting_category_id", "setting_category_parent_id", "name", "value", "description", "type", "options", "label", "order")
VALUES ('3', '0', 'DEFAULT_CARD_VIEW', 'Dockmodal', NULL, 'select', 'Dockmodal,Popup', 'Default Card View', '7');

INSERT INTO "settings" ("setting_category_id", "setting_category_parent_id", "name", "value", "description", "type", "options", "label", "order") VALUES ('3', '0', 'TODO', 'To do, Todo, New, Probable sale', '', 'textarea', NULL, 'Todo', '8'), ('3', '0', 'DOING', 'Doing, Feedback, Confirmed, Assigned, Pending sale', '', 'textarea', NULL, 'Doing', '9'), ('3', '0', 'DONE', 'Done, Resolved, Closed, Completed sale', '', 'textarea', NULL, 'Done', '10');

SELECT pg_catalog.setval('setting_categories_id_seq', (SELECT MAX(id) FROM setting_categories), true);

INSERT INTO "setting_categories" ("created", "modified", "parent_id", "name", "description", "order") 
values (now(), now(), NULL, 'Cards Workflow', NULL, '7');

UPDATE "settings" SET "setting_category_id" = (select id from setting_categories where name = 'Cards Workflow') WHERE name = 'TODO';
UPDATE "settings" SET "setting_category_id" = (select id from setting_categories where name = 'Cards Workflow') WHERE name = 'DONE';
UPDATE "settings" SET "setting_category_id" = (select id from setting_categories where name = 'Cards Workflow') WHERE name = 'DOING';

DROP VIEW "cards_elasticsearch_listing";

CREATE VIEW "cards_elasticsearch_listing" AS
 SELECT card.id, 
    row_to_json(card.*) AS json
   FROM ( SELECT cards.id, 
            cards.board_id, 
            boards.name AS board, 
            cards.list_id, 
            lists.name AS list, 
            cards.name, 
            cards.description, 
            cards.due_date, 
            to_char(cards.created, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS created, 
            to_char(cards.modified, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS modified, 
            (cards.is_archived)::integer AS is_archived, 
            cards.attachment_count, 
            cards.checklist_item_count, 
            cards.checklist_item_completed_count, 
            ( SELECT array_to_json(array_agg(row_to_json(cc.*))) AS array_to_json
                   FROM ( SELECT boards_users.user_id
                           FROM boards_users boards_users
                          WHERE (boards_users.board_id = cards.board_id)
                          ORDER BY boards_users.id) cc) AS board_users, 
            ( SELECT array_to_json(array_agg(row_to_json(cc.*))) AS array_to_json
                   FROM ( SELECT board_stars.user_id
                           FROM board_stars board_stars
                          WHERE (board_stars.board_id = cards.board_id)
                          ORDER BY board_stars.id) cc) AS board_stars, 
            ( SELECT array_to_json(array_agg(row_to_json(cc.*))) AS array_to_json
                   FROM ( SELECT checklists.name, 
                            checklist_items.name AS checklist_item_name
                           FROM (checklists checklists
                      LEFT JOIN checklist_items checklist_items ON ((checklist_items.checklist_id = checklists.id)))
                     WHERE (checklists.card_id = cards.id)
                     ORDER BY checklists.id) cc) AS cards_checklists, 
            ( SELECT array_to_json(array_agg(row_to_json(cc.*))) AS array_to_json
                   FROM ( SELECT cards_users_listing.username, 
                            cards_users_listing.user_id
                           FROM cards_users_listing cards_users_listing
                          WHERE (cards_users_listing.card_id = cards.id)
                          ORDER BY cards_users_listing.id) cc) AS cards_users, 
            ( SELECT array_to_json(array_agg(row_to_json(cl.*))) AS array_to_json
                   FROM ( SELECT cards_labels.name
                           FROM cards_labels_listing cards_labels
                          WHERE (cards_labels.card_id = cards.id)
                          ORDER BY cards_labels.id) cl) AS cards_labels, 
            ( SELECT array_to_json(array_agg(row_to_json(cl.*))) AS array_to_json
                   FROM ( SELECT activities.comment
                           FROM activities activities
                          WHERE (((activities.type)::text = 'add_comment'::text) AND (activities.card_id = cards.id))
                          ORDER BY activities.id) cl) AS activities
           FROM ((cards cards
      LEFT JOIN boards boards ON ((boards.id = cards.board_id)))
   LEFT JOIN lists lists ON ((lists.id = cards.list_id)))) card;
   
UPDATE "settings" SET "label" = 'Default Card Open', "value" = 'Maximized', "options" = 'Maximized,Normal Dockmodal' WHERE "name" = 'DEFAULT_CARD_VIEW';

SELECT pg_catalog.setval('settings_id_seq', (SELECT MAX(id) FROM settings), true);

INSERT INTO "settings" ("setting_category_id", "setting_category_parent_id", "name", "value", "description", "type", "options", "label", "order") 
VALUES 
((select id from setting_categories where name = 'Cards Workflow'), '0', 'TODO_COLOR', '', '', 'text', NULL, 'Todo Color', '1'), 
((select id from setting_categories where name = 'Cards Workflow'), '0', 'DOING_COLOR', '', '', 'text', NULL, 'Doing Color', '2'), 
((select id from setting_categories where name = 'Cards Workflow'), '0', 'DONE_COLOR', '', '', 'text', NULL, 'Done Color', '3'),
((select id from setting_categories where name = 'Cards Workflow'), '0', 'TODO_ICON', '', '', 'text', NULL, 'Todo Icon', '4'), 
((select id from setting_categories where name = 'Cards Workflow'), '0', 'DOING_ICON', '', '', 'text', NULL, 'Doing Icon', '5'), 
((select id from setting_categories where name = 'Cards Workflow'), '0', 'DONE_ICON', '', '', 'text', NULL, 'Done Icon', '6');

UPDATE "settings" SET "value" = '#f47564' WHERE "name" = 'TODO_COLOR';
UPDATE "settings" SET "value" = '#27c5c3' WHERE "name" = 'DOING_COLOR';
UPDATE "settings" SET "value" = '#8dca35' WHERE "name" = 'DONE_COLOR';

UPDATE "settings" SET "value" = 'icon-tasks icon-large' WHERE "name" = 'TODO_ICON';
UPDATE "settings" SET "value" = 'icon-spinner icon-large' WHERE "name" = 'DOING_ICON';
UPDATE "settings" SET "value" = 'icon-ok-circle icon-large' WHERE "name" = 'DONE_ICON';

DROP VIEW "cards_elasticsearch_listing";

CREATE VIEW "cards_elasticsearch_listing" AS
 SELECT card.id, 
    row_to_json(card.*) AS json
   FROM ( SELECT cards.id, 
            cards.board_id, 
            boards.name AS board, 
            cards.list_id, 
            lists.name AS list, 
            cards.name, 
            cards.description, 
            to_char(cards.due_date, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS due_date, 
            to_char(cards.created, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS created, 
            to_char(cards.modified, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS modified, 
            (cards.is_archived)::integer AS is_archived, 
            cards.attachment_count, 
            cards.checklist_item_count, 
            cards.checklist_item_completed_count, 
            ( SELECT array_to_json(array_agg(row_to_json(cc.*))) AS array_to_json
                   FROM ( SELECT boards_users.user_id
                           FROM boards_users boards_users
                          WHERE (boards_users.board_id = cards.board_id)
                          ORDER BY boards_users.id) cc) AS board_users, 
            ( SELECT array_to_json(array_agg(row_to_json(cc.*))) AS array_to_json
                   FROM ( SELECT board_stars.user_id
                           FROM board_stars board_stars
                          WHERE (board_stars.board_id = cards.board_id)
                          ORDER BY board_stars.id) cc) AS board_stars, 
            ( SELECT array_to_json(array_agg(row_to_json(cc.*))) AS array_to_json
                   FROM ( SELECT checklists.name, 
                            checklist_items.name AS checklist_item_name
                           FROM (checklists checklists
                      LEFT JOIN checklist_items checklist_items ON ((checklist_items.checklist_id = checklists.id)))
                     WHERE (checklists.card_id = cards.id)
                     ORDER BY checklists.id) cc) AS cards_checklists, 
            ( SELECT array_to_json(array_agg(row_to_json(cc.*))) AS array_to_json
                   FROM ( SELECT cards_users_listing.username, 
                            cards_users_listing.user_id
                           FROM cards_users_listing cards_users_listing
                          WHERE (cards_users_listing.card_id = cards.id)
                          ORDER BY cards_users_listing.id) cc) AS cards_users, 
            ( SELECT array_to_json(array_agg(row_to_json(cl.*))) AS array_to_json
                   FROM ( SELECT cards_labels.name
                           FROM cards_labels_listing cards_labels
                          WHERE (cards_labels.card_id = cards.id)
                          ORDER BY cards_labels.id) cl) AS cards_labels, 
            ( SELECT array_to_json(array_agg(row_to_json(cl.*))) AS array_to_json
                   FROM ( SELECT activities.comment
                           FROM activities activities
                          WHERE (((activities.type)::text = 'add_comment'::text) AND (activities.card_id = cards.id))
                          ORDER BY activities.id) cl) AS activities
           FROM ((cards cards
      LEFT JOIN boards boards ON ((boards.id = cards.board_id)))
   LEFT JOIN lists lists ON ((lists.id = cards.list_id)))) card;
   
DROP VIEW "cards_elasticsearch_listing";

CREATE VIEW "cards_elasticsearch_listing" AS
    SELECT card.id, 
    row_to_json(card.*) AS json
   FROM ( SELECT cards.id, 
            cards.board_id, 
            boards.name AS board, 
            cards.list_id, 
            lists.name AS list, 
            cards.name, 
            cards.description, 
            to_char(cards.due_date, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS due_date, 
            to_char(cards.created, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS created, 
            to_char(cards.modified, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS modified, 
            (cards.is_archived)::integer AS is_archived, 
            cards.attachment_count, 
            cards.checklist_item_count, 
            cards.checklist_item_completed_count, 
            cards.card_voter_count, 
			cards.cards_user_count, 
            ( SELECT array_to_json(array_agg(row_to_json(cc.*))) AS array_to_json
                   FROM ( SELECT boards_users.user_id
                           FROM boards_users boards_users
                          WHERE (boards_users.board_id = cards.board_id)
                          ORDER BY boards_users.id) cc) AS board_users, 
            ( SELECT array_to_json(array_agg(row_to_json(cc.*))) AS array_to_json
                   FROM ( SELECT board_stars.user_id
                           FROM board_stars board_stars
                          WHERE (board_stars.board_id = cards.board_id)
                          ORDER BY board_stars.id) cc) AS board_stars, 
            ( SELECT array_to_json(array_agg(row_to_json(cc.*))) AS array_to_json
                   FROM ( SELECT checklists.name, 
                            checklist_items.name AS checklist_item_name
                           FROM (checklists checklists
                      LEFT JOIN checklist_items checklist_items ON ((checklist_items.checklist_id = checklists.id)))
                     WHERE (checklists.card_id = cards.id)
                     ORDER BY checklists.id) cc) AS cards_checklists, 
            ( SELECT array_to_json(array_agg(row_to_json(cc.*))) AS array_to_json
                   FROM ( SELECT cards_users_listing.username, 
                            cards_users_listing.user_id
                           FROM cards_users_listing cards_users_listing
                          WHERE (cards_users_listing.card_id = cards.id)
                          ORDER BY cards_users_listing.id) cc) AS cards_users, 
            ( SELECT array_to_json(array_agg(row_to_json(cl.*))) AS array_to_json
                   FROM ( SELECT cards_labels.name
                           FROM cards_labels_listing cards_labels
                          WHERE (cards_labels.card_id = cards.id)
                          ORDER BY cards_labels.id) cl) AS cards_labels, 
            ( SELECT array_to_json(array_agg(row_to_json(cl.*))) AS array_to_json
                   FROM ( SELECT activities.comment
                           FROM activities activities
                          WHERE (((activities.type)::text = 'add_comment'::text) AND (activities.card_id = cards.id))
                          ORDER BY activities.id) cl) AS activities
           FROM ((cards cards
      LEFT JOIN boards boards ON ((boards.id = cards.board_id)))
   LEFT JOIN lists lists ON ((lists.id = cards.list_id)))) card;
   
DROP VIEW "cards_elasticsearch_listing";

CREATE VIEW "cards_elasticsearch_listing" AS
    SELECT card.id, 
    row_to_json(card.*) AS json
   FROM ( SELECT cards.id, 
            cards.board_id, 
            boards.name AS board, 
            cards.list_id, 
            lists.name AS list, 
            cards.name, 
            cards.description, 
            to_char(cards.due_date, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS due_date, 
            to_char(cards.created, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS created, 
            to_char(cards.modified, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS modified, 
            (cards.is_archived)::integer AS is_archived, 
            cards.attachment_count, 
            cards.checklist_item_count, 
            cards.checklist_item_completed_count, 
            cards.card_voter_count, 
			cards.cards_user_count, 
            ( SELECT array_to_json(array_agg(row_to_json(cc.*))) AS array_to_json
                   FROM ( SELECT boards_users.user_id
                           FROM boards_users boards_users
                          WHERE (boards_users.board_id = cards.board_id)
                          ORDER BY boards_users.id) cc) AS board_users, 
            ( SELECT array_to_json(array_agg(row_to_json(cc.*))) AS array_to_json
                   FROM ( SELECT board_stars.user_id
                           FROM board_stars board_stars
                          WHERE (board_stars.board_id = cards.board_id)
                          ORDER BY board_stars.id) cc) AS board_stars, 
            ( SELECT array_to_json(array_agg(row_to_json(cc.*))) AS array_to_json
                   FROM ( SELECT checklists.name, 
                            checklist_items.name AS checklist_item_name
                           FROM (checklists checklists
                      LEFT JOIN checklist_items checklist_items ON ((checklist_items.checklist_id = checklists.id)))
                     WHERE (checklists.card_id = cards.id)
                     ORDER BY checklists.id) cc) AS cards_checklists, 
            ( SELECT array_to_json(array_agg(row_to_json(cc.*))) AS array_to_json
                   FROM ( SELECT cards_users_listing.username, 
                            cards_users_listing.user_id
                           FROM cards_users_listing cards_users_listing
                          WHERE (cards_users_listing.card_id = cards.id)
                          ORDER BY cards_users_listing.id) cc) AS cards_users, 
            ( SELECT array_to_json(array_agg(row_to_json(cl.*))) AS array_to_json
                   FROM ( SELECT cards_labels.name
                           FROM cards_labels_listing cards_labels
                          WHERE (cards_labels.card_id = cards.id)
                          ORDER BY cards_labels.id) cl) AS cards_labels, 
            ( SELECT array_to_json(array_agg(row_to_json(cl.*))) AS array_to_json
                   FROM ( SELECT activities.comment
                           FROM activities activities
                          WHERE (((activities.type)::text = 'add_comment'::text) AND (activities.card_id = cards.id))
                          ORDER BY activities.id) cl) AS activities
           FROM ((cards cards
      LEFT JOIN boards boards ON ((boards.id = cards.board_id)))
   LEFT JOIN lists lists ON ((lists.id = cards.list_id))) WHERE boards.name IS NOT NULL) card;
   
   UPDATE "acl_links" SET "url" = '/boards/?/chat_history' WHERE "name" = 'Chat History';
   
DELETE from settings where name = 'JABBER_PATH';

ALTER TABLE "users" ADD "timezone" character varying NULL; COMMENT ON TABLE "users" IS '';

DROP VIEW "users_listing";
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