CREATE OR REPLACE VIEW "activities_listing" AS
 SELECT activity.id,
    activity.created,
    activity.modified,
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
    cll.name AS label_name,
    card.description AS card_description,
    users.role_id AS user_role_id,
    checklist_item.name AS checklist_item_name,
    checklist.name AS checklist_item_parent_name,
    checklist1.name AS checklist_name,
    organizations.id AS organization_id,
    organizations.name AS organization_name,
    organizations.logo_url AS organization_logo_url
   FROM (((((((((activities activity
   LEFT JOIN boards board ON ((board.id = activity.board_id)))
   LEFT JOIN lists list ON ((list.id = activity.list_id)))
   LEFT JOIN cards card ON ((card.id = activity.card_id)))
   LEFT JOIN cards_labels_listing cll ON ((cll.id = activity.card_id)))
   LEFT JOIN checklist_items checklist_item ON ((checklist_item.id = activity.foreign_id)))
   LEFT JOIN checklists checklist ON ((checklist.id = checklist_item.checklist_id)))
   LEFT JOIN checklists checklist1 ON ((checklist1.id = activity.foreign_id)))
   LEFT JOIN users users ON ((users.id = activity.user_id)))
   LEFT JOIN organizations organizations ON ((organizations.id = activity.organization_id)));