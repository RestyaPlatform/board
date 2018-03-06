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
    cards.is_due_date_notification_sent,
    cards.archived_date,
    to_char((select created from activities where card_id = cards.id and type='move_card' order by activities.id desc limit 1), 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS list_moved_date
   FROM (((cards cards
     LEFT JOIN users u ON ((u.id = cards.user_id)))
     LEFT JOIN boards b ON ((b.id = cards.board_id)))
     LEFT JOIN lists l ON ((l.id = cards.list_id)));


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
                    cards_listing.is_due_date_notification_sent,
                    cards_listing.archived_date,
                    cards_listing.list_moved_date
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