ALTER TABLE "custom_fields" ADD "color" character varying(255) NULL;

DROP VIEW "custom_fields_listing";
CREATE VIEW custom_fields_listing AS
    SELECT custom_field.id,
        to_char(custom_field.created, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS created,
        to_char(custom_field.modified, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS modified,
        custom_field.user_id,
        custom_field.type,
        custom_field.name,
        custom_field.description,
        custom_field.options,
        custom_field.label,
        custom_field."position",
        custom_field.visibility,
        ( SELECT array_to_json(array_agg(row_to_json(ccf.*))) AS array_to_json
            FROM ( SELECT cards_custom_field.id,
                        to_char(cards_custom_field.created, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS created,
                        to_char(cards_custom_field.modified, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS modified,
                        cards_custom_field.card_id,
                        cards_custom_field.value,
                        cards_custom_field.is_active,
                        cards_custom_field.custom_field_id
                    FROM cards_custom_fields cards_custom_field
                    WHERE (cards_custom_field.custom_field_id = custom_field.id)
                    ORDER BY cards_custom_field.id) ccf) AS cards_custom_fields,
        custom_field.color
    FROM custom_fields custom_field;

DROP VIEW "cards_elasticsearch_listing";
CREATE VIEW cards_elasticsearch_listing AS
    SELECT card.id,
    row_to_json(card.*) AS json
   FROM ( SELECT cards.id,
            cards.board_id,
            boards.name AS board,
            cards.list_id,
            lists.name AS list,
            cards.name,
            boards.organization_id AS organizations,
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
            cards.color,
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
                          ORDER BY activities.id) cl) AS activities,
            ( SELECT array_to_json(array_agg(row_to_json(cf.*))) AS array_to_json
                   FROM ( SELECT custom_fields.name,
                            custom_fields.color,
                            cards_custom_fields.value
                           FROM (cards_custom_fields cards_custom_fields
                             LEFT JOIN custom_fields custom_fields ON ((custom_fields.id = cards_custom_fields.custom_field_id)))
                          WHERE (cards_custom_fields.card_id = cards.id)
                          ORDER BY cards_custom_fields.id) cf) AS cards_custom_fields
           FROM ((cards cards
             LEFT JOIN boards boards ON ((boards.id = cards.board_id)))
             LEFT JOIN lists lists ON ((lists.id = cards.list_id)))
          WHERE (boards.name IS NOT NULL)) card;