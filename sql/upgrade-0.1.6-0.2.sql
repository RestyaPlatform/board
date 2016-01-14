INSERT INTO "acl_links" ("id", "created", "modified", "name", "url", "method", "slug", "group_id", "is_allow_only_to_admin", "is_allow_only_to_user") VALUES ('127', now(), now(), 'Plugin', '/plugins', 'GET', 'plugin', '6', '1', '0');

INSERT INTO "acl_links_roles" ("created", "modified", "acl_link_id", "role_id") VALUES (now(), now(), '127', '1');

INSERT INTO "acl_links" ("id", "created", "modified", "name", "url", "method", "slug", "group_id", "is_allow_only_to_admin", "is_allow_only_to_user") VALUES ('128', now(), now(), 'Plugin Settings', '/plugins/settings', 'GET', 'plugin_settings', '6', '1', '0');

INSERT INTO "acl_links_roles" ("created", "modified", "acl_link_id", "role_id") VALUES (now(), now(), '128', '1');

INSERT INTO "acl_links" ("id", "created", "modified", "name", "url", "method", "slug", "group_id", "is_allow_only_to_admin", "is_allow_only_to_user") VALUES ('129', now(), now(), 'Plugin Settings', '/plugins/settings', 'POST', 'plugin_settings', '6', '1', '0');

INSERT INTO "acl_links_roles" ("created", "modified", "acl_link_id", "role_id") VALUES (now(), now(), '129', '1');

INSERT INTO "settings" ("id", "setting_category_id", "setting_category_parent_id", "name", "value", "description", "type", "options", "label", "order")
VALUES ('31', '3', '0', 'DEFAULT_LANGUAGE', 'en', NULL, 'text', NULL, 'Default Language', '6');

ALTER TABLE "users" ADD "language" character varying(10) NULL;

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
    users.member_organization_count,
    users.language
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

CREATE SEQUENCE languages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE TABLE languages (
    id bigint DEFAULT nextval('languages_id_seq'::regclass) NOT NULL,
    created timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    name character varying(80) NOT NULL,
    iso2 character varying(5) NOT NULL,
    iso3 character varying(5) NOT NULL,
    is_active smallint DEFAULT 1 NOT NULL
);

INSERT INTO "languages" ("id", "created", "modified", "name", "iso2", "iso3", "is_active") VALUES
(1,	'2009-07-01 13:52:24',	'2013-04-11 17:09:26.043',	'Abkhazian',	'ab',	'abk',	0),
(2,	'2009-07-01 13:52:24',	'2009-07-01 13:52:24',	'Afar',	'aa',	'aar',	0),
(3,	'2009-07-01 13:52:24',	'2009-07-01 13:52:24',	'Afrikaans',	'af',	'afr',	0),
(4,	'2009-07-01 13:52:24',	'2009-07-01 13:52:24',	'Akan',	'ak',	'aka',	0),
(5,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Albanian',	'sq',	'sqi',	0),
(6,	'2009-07-01 13:52:24',	'2009-07-01 13:52:24',	'Amharic',	'am',	'amh',	0),
(7,	'2009-07-01 13:52:24',	'2009-07-01 13:52:24',	'Arabic',	'ar',	'ara',	0),
(8,	'2009-07-01 13:52:24',	'2009-07-01 13:52:24',	'Aragonese',	'an',	'arg',	0),
(9,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Armenian',	'hy',	'hye',	0),
(10,	'2009-07-01 13:52:24',	'2009-07-01 13:52:24',	'Assamese',	'as',	'asm',	0),
(11,	'2009-07-01 13:52:24',	'2009-07-01 13:52:24',	'Avaric',	'av',	'ava',	0),
(12,	'2009-07-01 13:52:24',	'2009-07-01 13:52:24',	'Avestan',	'ae',	'ave',	0),
(13,	'2009-07-01 13:52:24',	'2009-07-01 13:52:24',	'Aymara',	'ay',	'aym',	0),
(14,	'2009-07-01 13:52:24',	'2009-07-01 13:52:24',	'Azerbaijani',	'az',	'aze',	0),
(15,	'2009-07-01 13:52:24',	'2009-07-01 13:52:24',	'Bambara',	'bm',	'bam',	0),
(16,	'2009-07-01 13:52:24',	'2009-07-01 13:52:24',	'Bashkir',	'ba',	'bak',	0),
(17,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Basque',	'eu',	'eus',	0),
(18,	'2009-07-01 13:52:24',	'2009-07-01 13:52:24',	'Belarusian',	'be',	'bel',	0),
(19,	'2009-07-01 13:52:24',	'2009-07-01 13:52:24',	'Bengali',	'bn',	'ben',	0),
(20,	'2009-07-01 13:52:24',	'2009-07-01 13:52:24',	'Bihari',	'bh',	'bih',	0),
(21,	'2009-07-01 13:52:24',	'2009-07-01 13:52:24',	'Bislama',	'bi',	'bis',	0),
(22,	'2009-07-01 13:52:24',	'2009-07-01 13:52:24',	'Bosnian',	'bs',	'bos',	0),
(23,	'2009-07-01 13:52:24',	'2009-07-01 13:52:24',	'Breton',	'br',	'bre',	0),
(24,	'2009-07-01 13:52:24',	'2009-07-01 13:52:24',	'Bulgarian',	'bg',	'bul',	0),
(25,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Burmese',	'my',	'mya',	0),
(26,	'2009-07-01 13:52:24',	'2009-07-01 13:52:24',	'Catalan',	'ca',	'cat',	0),
(27,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Chamorro',	'ch',	'cha',	0),
(28,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Chechen',	'ce',	'che',	0),
(29,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Chichewa',	'ny',	'nya',	0),
(30,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Chinese',	'zh',	'zho',	0),
(31,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Church Slavic',	'cu',	'chu',	0),
(32,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Chuvash',	'cv',	'chv',	0),
(33,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Cornish',	'kw',	'cor',	0),
(34,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Corsican',	'co',	'cos',	0),
(35,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Cree',	'cr',	'cre',	0),
(36,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Croatian',	'hr',	'hrv',	0),
(37,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Czech',	'cs',	'ces',	0),
(38,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Danish',	'da',	'dan',	0),
(39,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Divehi',	'dv',	'div',	0),
(40,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Dutch',	'nl',	'nld',	1),
(41,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Dzongkha',	'dz',	'dzo',	0),
(42,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'English',	'en',	'eng',	1),
(43,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Esperanto',	'eo',	'epo',	0),
(44,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Estonian',	'et',	'est',	0),
(45,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Ewe',	'ee',	'ewe',	0),
(46,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Faroese',	'fo',	'fao',	0),
(47,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Fijian',	'fj',	'fij',	0),
(48,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Finnish',	'fi',	'fin',	0),
(49,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'French',	'fr',	'fra',	0),
(50,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Fulah',	'ff',	'ful',	0),
(51,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Galician',	'gl',	'glg',	0),
(52,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Ganda',	'lg',	'lug',	0),
(53,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Georgian',	'ka',	'kat',	0),
(54,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'German',	'de',	'deu',	0),
(55,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Greek',	'el',	'ell',	0),
(56,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Guaraní',	'gn',	'grn',	0),
(57,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Gujarati',	'gu',	'guj',	0),
(58,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Haitian',	'ht',	'hat',	0),
(59,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Hausa',	'ha',	'hau',	0),
(60,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Hebrew',	'he',	'heb',	0),
(61,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Herero',	'hz',	'her',	0),
(62,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Hindi',	'hi',	'hin',	0),
(63,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Hiri Motu',	'ho',	'hmo',	0),
(64,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Hungarian',	'hu',	'hun',	0),
(65,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Icelandic',	'is',	'isl',	0),
(66,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Ido',	'io',	'ido',	0),
(67,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Igbo',	'ig',	'ibo',	0),
(68,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Indonesian',	'id',	'ind',	0),
(69,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Interlingua (International Auxiliary Language Association)',	'ia',	'ina',	0),
(70,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Interlingue',	'ie',	'ile',	0),
(71,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Inuktitut',	'iu',	'iku',	0),
(72,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Inupiaq',	'ik',	'ipk',	0),
(73,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Irish',	'ga',	'gle',	0),
(74,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Italian',	'it',	'ita',	1),
(75,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Japanese',	'ja',	'jpn',	1),
(76,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Javanese',	'jv',	'jav',	0),
(77,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Kalaallisut',	'kl',	'kal',	0),
(78,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Kannada',	'kn',	'kan',	0),
(79,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Kanuri',	'kr',	'kau',	0),
(80,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Kashmiri',	'ks',	'kas',	0),
(81,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Kazakh',	'kk',	'kaz',	0),
(82,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Khmer',	'km',	'khm',	0),
(83,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Kikuyu',	'ki',	'kik',	0),
(84,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Kinyarwanda',	'rw',	'kin',	0),
(85,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Kirghiz',	'ky',	'kir',	0),
(86,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Kirundi',	'rn',	'run',	0),
(87,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Komi',	'kv',	'kom',	0),
(88,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Kongo',	'kg',	'kon',	0),
(89,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Korean',	'ko',	'kor',	0),
(90,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Kurdish',	'ku',	'kur',	0),
(91,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Kwanyama',	'kj',	'kua',	0),
(92,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Lao',	'lo',	'lao',	0),
(93,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Latin',	'la',	'lat',	0),
(94,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Latvian',	'lv',	'lav',	0),
(95,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Limburgish',	'li',	'lim',	0),
(96,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Lingala',	'ln',	'lin',	0),
(97,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Lithuanian',	'lt',	'lit',	0),
(98,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Luba-Katanga',	'lu',	'lub',	0),
(99,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Luxembourgish',	'lb',	'ltz',	0),
(100,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Macedonian',	'mk',	'mkd',	0),
(101,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Malagasy',	'mg',	'mlg',	0),
(102,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Malay',	'ms',	'msa',	0),
(103,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Malayalam',	'ml',	'mal',	0),
(104,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Maltese',	'mt',	'mlt',	0),
(105,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Manx',	'gv',	'glv',	0),
(106,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Māori',	'mi',	'mri',	0),
(107,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Marathi',	'mr',	'mar',	0),
(108,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Marshallese',	'mh',	'mah',	0),
(109,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Mongolian',	'mn',	'mon',	0),
(110,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Nauru',	'na',	'nau',	0),
(111,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Navajo',	'nv',	'nav',	0),
(112,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Ndonga',	'ng',	'ndo',	0),
(113,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Nepali',	'ne',	'nep',	0),
(114,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'North Ndebele',	'nd',	'nde',	0),
(115,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Northern Sami',	'se',	'sme',	0),
(116,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Norwegian',	'no',	'nor',	0),
(117,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Norwegian Bokmål',	'nb',	'nob',	0),
(118,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Norwegian Nynorsk',	'nn',	'nno',	0),
(119,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Occitan',	'oc',	'oci',	0),
(120,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Ojibwa',	'oj',	'oji',	0),
(121,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Oriya',	'or',	'ori',	0),
(122,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Oromo',	'om',	'orm',	0),
(123,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Ossetian',	'os',	'oss',	0),
(124,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Pāli',	'pi',	'pli',	0),
(125,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Panjabi',	'pa',	'pan',	0),
(126,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Pashto',	'ps',	'pus',	0),
(127,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Persian',	'fa',	'fas',	0),
(128,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Polish',	'pl',	'pol',	0),
(129,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Portuguese',	'pt',	'por',	1),
(130,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Quechua',	'qu',	'que',	0),
(131,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Raeto-Romance',	'rm',	'roh',	0),
(132,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Romanian',	'ro',	'ron',	0),
(133,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Russian',	'ru',	'rus',	1),
(134,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Samoan',	'sm',	'smo',	0),
(135,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Sango',	'sg',	'sag',	0),
(136,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Sanskrit',	'sa',	'san',	0),
(137,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Sardinian',	'sc',	'srd',	0),
(138,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Scottish Gaelic',	'gd',	'gla',	0),
(139,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Serbian',	'sr',	'srp',	0),
(140,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Shona',	'sn',	'sna',	0),
(141,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Sichuan Yi',	'ii',	'iii',	0),
(142,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Sindhi',	'sd',	'snd',	0),
(143,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Sinhala',	'si',	'sin',	0),
(144,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Slovak',	'sk',	'slk',	0),
(145,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Slovenian',	'sl',	'slv',	0),
(146,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Somali',	'so',	'som',	0),
(147,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'South Ndebele',	'nr',	'nbl',	0),
(148,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Southern Sotho',	'st',	'sot',	0),
(149,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Spanish',	'es',	'spa',	1),
(150,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Sundanese',	'su',	'sun',	0),
(151,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Swahili',	'sw',	'swa',	0),
(152,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Swati',	'ss',	'ssw',	0),
(153,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Swedish',	'sv',	'swe',	0),
(154,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Tagalog',	'tl',	'tgl',	0),
(155,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Tahitian',	'ty',	'tah',	0),
(156,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Tajik',	'tg',	'tgk',	0),
(157,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Tamil',	'ta',	'tam',	0),
(158,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Tatar',	'tt',	'tat',	0),
(159,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Telugu',	'te',	'tel',	0),
(160,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Thai',	'th',	'tha',	0),
(161,	'2009-07-01 13:52:24',	'2009-07-01 13:52:24',	'Tibetan',	'bo',	'bod',	0),
(162,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Tigrinya',	'ti',	'tir',	0),
(163,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Tonga',	'to',	'ton',	0),
(164,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Traditional Chinese',	'zh-TW',	'zh-TW',	0),
(165,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Tsonga',	'ts',	'tso',	0),
(166,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Tswana',	'tn',	'tsn',	0),
(167,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Turkish',	'tr',	'tur',	0),
(168,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Turkmen',	'tk',	'tuk',	0),
(169,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Twi',	'tw',	'twi',	0),
(170,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Uighur',	'ug',	'uig',	0),
(171,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Ukrainian',	'uk',	'ukr',	0),
(172,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Urdu',	'ur',	'urd',	0),
(173,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Uzbek',	'uz',	'uzb',	0),
(174,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Venda',	've',	'ven',	0),
(175,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Vietnamese',	'vi',	'vie',	0),
(176,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Volapük',	'vo',	'vol',	0),
(177,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Walloon',	'wa',	'wln',	0),
(178,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Welsh',	'cy',	'cym',	0),
(179,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Western Frisian',	'fy',	'fry',	0),
(180,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Wolof',	'wo',	'wol',	0),
(181,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Xhosa',	'xh',	'xho',	0),
(182,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Yiddish',	'yi',	'yid',	0),
(183,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Yoruba',	'yo',	'yor',	0),
(184,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Zhuang',	'za',	'zha',	0),
(185,	'2009-07-01 13:52:25',	'2009-07-01 13:52:25',	'Zulu',	'zu',	'zul',	0);

ALTER TABLE "boards" ADD "default_email_list_id" bigint NOT NULL DEFAULT '0';
ALTER TABLE "boards" ADD "is_default_email_position_as_bottom" boolean NOT NULL DEFAULT 'false';

CREATE OR REPLACE VIEW boards_users_listing AS
 SELECT bu.id, 
    bu.created, 
    bu.modified, 
    bu.board_id, 
    bu.user_id, 
    (bu.is_admin)::integer AS is_admin, 
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
   
INSERT INTO "setting_categories" ("id", "created", "modified", "name", "order")
VALUES (10, now(), now(), 'IMAP', '5');
   
INSERT INTO "settings" ("id", "setting_category_id", "setting_category_parent_id", "name", "value", "description", "type", "options", "label", "order")
VALUES ('32', '10', '0', 'IMAP_HOST', '', NULL, 'text', NULL, 'IMAP Host', '1');

INSERT INTO "settings" ("id", "setting_category_id", "setting_category_parent_id", "name", "value", "description", "type", "options", "label", "order")
VALUES ('33', '10', '0', 'IMAP_PORT', '', NULL, 'text', NULL, 'IMAP Port', '2');

INSERT INTO "settings" ("id", "setting_category_id", "setting_category_parent_id", "name", "value", "description", "type", "options", "label", "order")
VALUES ('34', '10', '0', 'IMAP_EMAIL', '', NULL, 'text', NULL, 'IMAP Email', '3');

INSERT INTO "settings" ("id", "setting_category_id", "setting_category_parent_id", "name", "value", "description", "type", "options", "label", "order")
VALUES ('35', '10', '0', 'IMAP_EMAIL_PASSWORD', '', NULL, 'text', NULL, 'IMAP Email Password', '4');

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
                  ORDER BY boards_users.id) bu) AS boards_users,
    board.default_email_list_id,
    board.is_default_email_position_as_bottom
   FROM ((boards board
   LEFT JOIN users users ON ((users.id = board.user_id)))
   LEFT JOIN organizations organizations ON ((organizations.id = board.organization_id)));

UPDATE "email_templates" SET
"email_text_content" = '<html>
<head></head>
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
<a href="http://restya.com/board" title="Open source. Trello like kanban board." rel="generator" style="font-size: 11px;text-align: center;text-decoration: none;color: #000;font-family: arial; padding-left:10px;">Powered by Restyaboard</a>
</h6>
</footer>
</body>
</html>'
WHERE "id" = '6';

UPDATE boards bd SET default_email_list_id = (SELECT l.id FROM boards b LEFT JOIN lists l ON l.board_id = bd.id WHERE default_email_list_id = 0 ORDER BY id DESC OFFSET 0 LIMIT 1) WHERE default_email_list_id = 0;

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
		RETURN OLD;
	ELSIF (TG_OP = 'INSERT') THEN
		UPDATE "lists" SET "card_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "cards" WHERE "list_id" = NEW."list_id" AND "is_archived" = false) t WHERE "id" = NEW."list_id";
		UPDATE "boards" SET "card_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "cards" WHERE "board_id" = NEW."board_id") t WHERE "id" = NEW."list_id";
		UPDATE "users" SET "created_card_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "cards" WHERE "user_id" = NEW."user_id") t WHERE "id" = NEW."user_id";
		RETURN NEW;
	END IF;
END;
$$;

UPDATE "acl_links" SET "is_allow_only_to_admin" = '1', "is_allow_only_to_user" = '1';
UPDATE "acl_links" SET "is_allow_only_to_admin" = '0', "is_allow_only_to_user" = '0' WHERE "name" = 'Forgot password';
UPDATE "acl_links" SET "is_allow_only_to_admin" = '0', "is_allow_only_to_user" = '0' WHERE "name" = 'Register';
UPDATE "acl_links" SET "is_allow_only_to_admin" = '0', "is_allow_only_to_user" = '0' WHERE "name" = 'Login';
UPDATE "acl_links" SET "is_allow_only_to_admin" = '1', "is_allow_only_to_user" = '0' WHERE "name" = 'Users management';
UPDATE "acl_links" SET "is_allow_only_to_admin" = '1', "is_allow_only_to_user" = '0' WHERE "name" = 'Create user';
UPDATE "acl_links" SET "is_allow_only_to_admin" = '1', "is_allow_only_to_user" = '0' WHERE "name" = 'Boards management';
UPDATE "acl_links" SET "is_allow_only_to_admin" = '1', "is_allow_only_to_user" = '0' WHERE "name" = 'All activities';
UPDATE "acl_links" SET "is_allow_only_to_admin" = '1', "is_allow_only_to_user" = '0' WHERE "name" = 'Download attachment from card';
UPDATE "acl_links" SET "is_allow_only_to_admin" = '1', "is_allow_only_to_user" = '0' WHERE "group_id" = 6;

UPDATE "acl_links" SET "name" = 'App', "url" = '/apps', "slug" = 'app' WHERE "slug" = 'plugin';
UPDATE "acl_links" SET "name" = 'App Settings', "url" = '/apps/settings', "slug" = 'app_settings' WHERE "slug" = 'plugin_settings';