ALTER TABLE "activities" ADD "organization_id" bigint NULL DEFAULT '0';

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
	organizations.name AS organization_name
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
    board.is_closed, 
    board.is_allow_organization_members_to_join, 
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
  ORDER BY board.name ASC;
  
 
INSERT INTO "settings" ("setting_category_id", "setting_category_parent_id", "name", "value", "description", "type", "options", "label", "order")
VALUES ('5', '2', 'STANDARD_LOGIN_ENABLED', 'true', NULL, 'checkbox', NULL, 'Standard Login Enabled', '10');  

ALTER TABLE "users" ADD "is_ldap" boolean NOT NULL DEFAULT 'false';

UPDATE "acl_links" SET url = '/users' WHERE url = '/users/admin_user_add'; 

UPDATE "acl_links" SET url = '/users/?/activation' WHERE url = '/users/activation/?';