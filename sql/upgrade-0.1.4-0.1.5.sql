UPDATE "settings" SET "label" = 'Uid field' WHERE "name" = 'LDAP_UID_FIELD';
UPDATE "settings" SET "label" = 'Bind dn' WHERE "name" = 'LDAP_BIND_DN';
UPDATE "settings" SET "label" = 'Bind password' WHERE "name" = 'LDAP_BIND_PASSWD';
UPDATE "settings" SET "label" = 'Root dn' WHERE "name" = 'LDAP_ROOT_DN';

DROP VIEW "users_listing";
UPDATE users SET last_activity_id = 0 WHERE last_activity_id IS NULL;
ALTER TABLE "users" ALTER "last_activity_id" TYPE bigint, ALTER "last_activity_id" SET DEFAULT '0', ALTER "last_activity_id" SET NOT NULL;
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
    users.is_allow_desktop_notification,
    users.is_active,
    users.is_email_confirmed,
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
    users.is_productivity_beats,
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
    lci.name AS log_city_name,
    lst.name AS log_state_name,
    lco.name AS log_country_name,
    lower((lco.iso_alpha2)::text) AS log_country_iso2,
    i.ip AS registered_ip,
    rci.name AS reg_city_name,
    rst.name AS reg_state_name,
    rco.name AS reg_country_name,
    lower((rco.iso_alpha2)::text) AS reg_country_iso2,
    lt.name AS login_type,
    users.created,
    users.user_login_count
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