INSERT INTO "settings" ("id", "setting_category_id", "setting_category_parent_id", "name", "value", "description", "type", "options", "label", "order")
VALUES ('31', '3', '0', 'DEFAULT_LANGUAGE', 'en', NULL, 'text', NULL, 'Default Language', '6');

ALTER TABLE "users" ADD "language" character varying(10) NULL;

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
UPDATE boards bd SET default_email_list_id = (SELECT l.id FROM boards b LEFT JOIN lists l ON l.board_id = bd.id WHERE default_email_list_id = 0 ORDER BY id DESC OFFSET 0 LIMIT 1) WHERE default_email_list_id = 0;

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

UPDATE "email_templates" SET
"email_text_content" = '<html>
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
<a href="http://restya.com/board/?utm_source=Restyaboard ##SITE_NAME##&utm_medium=email&utm_campaign=activation_email" title="Open source. Trello like kanban board." rel="generator" style="font-size: 11px;text-align: center;text-decoration: none;color: #000;font-family: arial; padding-left:10px;">Powered by Restyaboard</a></h6>
</footer>
</body>
</html>'
WHERE "id" = '1';

UPDATE "email_templates" SET
"email_text_content" = '<html>
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
<pre style="font-family: Arial, Helvetica, sans-serif; font-size: 13px;line-height:20px;"><h2 style="font-size:16px; font-family:Arial, Helvetica, sans-serif; margin: 20px 0px 0px;padding:10px 0px 0px 0px;">Hi ##NAME##,</h2><p style="white-space: normal; width: 100%;margin: 10px 0px 0px; font-family:Arial, Helvetica, sans-serif;"><br></p><p style="white-space: normal; width: 100%;margin: 0px 0px 0px; font-family:Arial, Helvetica, sans-serif;">We wish to say a quick hello and thanks for registering at ##SITE_NAME##.<br>If you didn''t create a ##SITE_NAME## account and feel this is an error, please contact us at ##CONTACT_EMAIL##.<br></p><br><p style="white-space: normal; width: 100%;margin: 0px 0px 0px;font-family:Arial, Helvetica, sans-serif;">Thanks,<br>
Restyaboard<br>
##SITE_URL##</p>
</pre>
</div>
</div>
</main>
<footer style="width:100%;padding-left:0;margin:0px auto;border-top: solid 1px #dedede; padding-bottom:10px; background:#fff;clear: both;padding-top: 10px;border-bottom: solid 1px #dedede;background-color: #f7f7f7;">
<h6 style="text-align:center;margin:5px 15px;"> 
<a href="http://restya.com/board/?utm_source=Restyaboard ##SITE_NAME##&utm_medium=email&utm_campaign=welcome_email" title="Open source. Trello like kanban board." rel="generator" style="font-size: 11px;text-align: center;text-decoration: none;color: #000;font-family: arial; padding-left:10px;">Powered by Restyaboard</a></h6>
</footer>
</body>
</html>'
WHERE "id" = '2';

UPDATE "email_templates" SET
"email_text_content" = '<html>
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
<pre style="font-family: Arial, Helvetica, sans-serif; font-size: 13px;line-height:20px;"><h2 style="font-size:16px; font-family:Arial, Helvetica, sans-serif; margin: 20px 0px 0px;padding:10px 0px 0px 0px;">Hi ##NAME##,</h2><p style="white-space: normal; width: 100%;margin: 10px 0px 0px; font-family:Arial, Helvetica, sans-serif;"><br></p><p style="white-space: normal; width: 100%;margin: 0px 0px 0px; font-family:Arial, Helvetica, sans-serif;">We have received a password reset request for your account at ##SITE_NAME##.<br>New password: ##PASSWORD##<br>If you didn''t requested this action and feel this is an error, please contact us at ##CONTACT_EMAIL##.<br></p><br><p style="white-space: normal; width: 100%;margin: 0px 0px 0px;font-family:Arial, Helvetica, sans-serif;">Thanks,<br>
Restyaboard<br>
##SITE_URL##</p>
</pre>
</div>
</div>
</main>
<footer style="width:100%;padding-left:0;margin:0px auto;border-top: solid 1px #dedede; padding-bottom:10px; background:#fff;clear: both;padding-top: 10px;border-bottom: solid 1px #dedede;background-color: #f7f7f7;">
<h6 style="text-align:center;margin:5px 15px;"> 
<a href="http://restya.com/board/?utm_source=Restyaboard ##SITE_NAME##&utm_medium=email&utm_campaign=forgetpassword_email" title="Open source. Trello like kanban board." rel="generator" style="font-size: 11px;text-align: center;text-decoration: none;color: #000;font-family: arial; padding-left:10px;">Powered by Restyaboard</a></h6>
</footer>
</body>
</html>'
WHERE "id" = '3';

UPDATE "email_templates" SET
"email_text_content" = '<html>
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
<pre style="font-family: Arial, Helvetica, sans-serif; font-size: 13px;line-height:20px;"><h2 style="font-size:16px; font-family:Arial, Helvetica, sans-serif; margin: 20px 0px 0px;padding:10px 0px 0px 0px;">Hi,</h2><p style="white-space: normal; width: 100%;margin: 10px 0px 0px; font-family:Arial, Helvetica, sans-serif;"><br></p><p style="white-space: normal; width: 100%;margin: 0px 0px 0px; font-family:Arial, Helvetica, sans-serif;">Admin reset your password for your ##SITE_NAME## account.<br>Your new password: ##PASSWORD##<br></p><br><p style="white-space: normal; width: 100%;margin: 0px 0px 0px;font-family:Arial, Helvetica, sans-serif;">Thanks,<br>
Restyaboard<br>
##SITE_URL##</p>
</pre>
</div>
</div>
</main>
<footer style="width:100%;padding-left:0;margin:0px auto;border-top: solid 1px #dedede; padding-bottom:10px; background:#fff;clear: both;padding-top: 10px;border-bottom: solid 1px #dedede;background-color: #f7f7f7;">
<h6 style="text-align:center;margin:5px 15px;"> 
<a href="http://restya.com/board/?utm_source=Restyaboard ##SITE_NAME##&utm_medium=email&utm_campaign=changepassword_email" title="Open source. Trello like kanban board." rel="generator" style="font-size: 11px;text-align: center;text-decoration: none;color: #000;font-family: arial; padding-left:10px;">Powered by Restyaboard</a></h6>
</footer>
</body>
</html>'
WHERE "id" = '4';

UPDATE "email_templates" SET
"email_text_content" = '<html>
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
<a href="http://restya.com/board/?utm_source=Restyaboard ##SITE_NAME##&utm_medium=email&utm_campaign=newprojectuser_email" title="Open source. Trello like kanban board." rel="generator" style="font-size: 11px;text-align: center;text-decoration: none;color: #000;font-family: arial; padding-left:10px;">Powered by Restyaboard</a></h6>
</footer>
</body>
</html>'
WHERE "id" = '5';

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
<a href="http://restya.com/board/?utm_source=Restyaboard ##SITE_NAME##&utm_medium=email&utm_campaign=email_notification_email" title="Open source. Trello like kanban board." rel="generator" style="font-size: 11px;text-align: center;text-decoration: none;color: #000;font-family: arial; padding-left:10px;">Powered by Restyaboard</a>
</h6>
</footer>
</body>
</html>'
WHERE "id" = '6';

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

CREATE OR REPLACE VIEW activities_listing AS
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
    la.name AS label_name, 
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
   LEFT JOIN labels la ON (((la.id = activity.foreign_id) AND ((activity.type)::text = 'add_card_label'::text))))
   LEFT JOIN checklist_items checklist_item ON ((checklist_item.id = activity.foreign_id)))
   LEFT JOIN checklists checklist ON ((checklist.id = checklist_item.checklist_id)))
   LEFT JOIN checklists checklist1 ON ((checklist1.id = activity.foreign_id)))
   LEFT JOIN users users ON ((users.id = activity.user_id)))
   LEFT JOIN organizations organizations ON ((organizations.id = activity.organization_id)));

CREATE OR REPLACE VIEW "cards_users_listing" AS
 SELECT u.username,
    u.profile_picture_path,
    cu.id,
    cu.created,
    cu.modified,
    cu.card_id,
    cu.user_id,
    u.initials,
    u.full_name,
    u.email
   FROM (cards_users cu
   LEFT JOIN users u ON ((u.id = cu.user_id)));

CREATE OR REPLACE VIEW "cards_listing" AS
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
                    cards_subscribers.created,
                    cards_subscribers.modified,
                    cards_subscribers.card_id,
                    cards_subscribers.user_id,
                    cards_subscribers.is_subscribed::boolean::int
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

CREATE OR REPLACE VIEW "checklists_listing" AS
 SELECT checklists.id,
    checklists.created,
    checklists.modified,
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
                    checklist_items.is_completed::boolean::int,
                    checklist_items."position"
                   FROM checklist_items checklist_items
                  WHERE (checklist_items.checklist_id = checklists.id)
                  ORDER BY checklist_items."position") ci) AS checklists_items,
    checklists."position"
   FROM checklists checklists;

CREATE OR REPLACE VIEW "gadget_users_listing" AS
 SELECT checklists.id,
    checklists.created,
    checklists.modified,
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
                    checklist_items.is_completed::boolean::int
                   FROM checklist_items checklist_items
                  WHERE (checklist_items.checklist_id = checklists.id)
                  ORDER BY checklist_items.id) ci) AS checklist_items
   FROM checklists checklists;

CREATE OR REPLACE VIEW "lists_listing" AS
 SELECT lists.id,
    lists.created,
    lists.modified,
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
                    cards_listing.is_archived::boolean::int,
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
                    lists_subscribers.is_subscribed::boolean::int
                   FROM list_subscribers lists_subscribers
                  WHERE (lists_subscribers.list_id = lists.id)
                  ORDER BY lists_subscribers.id) ls) AS lists_subscribers
   FROM lists lists;

CREATE SEQUENCE OAUTH_clients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE "oauth_clients" ADD "client_name" character varying(255) NULL, ADD "client_url" character varying(255) NULL, ADD "logo_url" character varying(255) NULL, ADD "tos_url" character varying(255) NULL, ADD "policy_url" character varying(2000) NULL, ADD "modified" timestamp NULL, ADD "created" timestamp NULL;

ALTER TABLE oauth_clients ADD COLUMN id SERIAL;
UPDATE oauth_clients SET id = nextval(pg_get_serial_sequence('oauth_clients','id'));

UPDATE "oauth_clients" SET "redirect_uri" = '', "client_name" = 'Web App', "grant_types" = 'client_credentials password refresh_token authorization_code' WHERE "client_id" = '7742632501382313';

INSERT INTO "oauth_clients" ("client_id", "client_secret", "redirect_uri", "grant_types", "scope", "user_id", "client_name", "client_url", "logo_url", "tos_url", "policy_url", "modified", "created")
VALUES ('6664115227792148', 'hw3wpe2cfsxxygogwue47cwnf7', NULL, 'client_credentials refresh_token authorization_code', NULL, NULL, 'Mobile App', NULL, NULL, NULL, NULL, now(), now()),('7857596005287233', 'n0l2wlujcpkj0bd7gk8918gm6b', NULL, 'client_credentials refresh_token authorization_code', NULL, NULL, 'Zapier', NULL, NULL, NULL, NULL, now(), now());

CREATE SEQUENCE webhooks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE TABLE webhooks (
    id bigint DEFAULT nextval('webhooks_id_seq'::regclass) NOT NULL,
    created timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255) NOT NULL,
    url character varying(255) NOT NULL,
    secret character varying(255) NOT NULL,
    is_active boolean NOT NULL DEFAULT 'false'
);

INSERT INTO "settings" ("id", "setting_category_id", "setting_category_parent_id", "name", "value", "description", "type", "options", "label", "order")
VALUES ('36', '0', '0', 'webhooks.last_processed_activtiy_id', 0, NULL, 'hidden', NULL, 'Webhook Activity ID', '0');

INSERT INTO "oauth_scopes" ("scope", "is_default") VALUES ('read', 't'),('write', 'f');

INSERT INTO "email_templates" ("id", "created", "modified", "from_email", "reply_to_email", "name", "description", "subject", "email_text_content", "email_variables", "display_name") VALUES
(7,	'2016-01-10 06:15:49.891',	'2016-01-10 06:15:49.891',	'##SITE_NAME## Restyaboard <##FROM_EMAIL##>',	'##REPLY_TO_EMAIL##',	'due_date_notification',	'We will send this mail, One day before when the card due date end.',	'##SUBJECT##',	'<html>
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
<pre style="font-family: Arial, Helvetica, sans-serif; font-size: 13px;line-height:20px;">
<h2 style="font-size:16px; font-family:Arial, Helvetica, sans-serif; margin: 7px 0px 0px 43px;padding:35px 0px 0px 0px;">Due soon…</h2>
<p style="white-space: normal; width: 100%;margin: 10px 0px 0px; font-family:Arial, Helvetica, sans-serif;">##CONTENT##</p>
</pre>
</div>
</div>
</main>
<footer style="width:100%;padding-left:0;margin:0px auto;border-top: solid 1px #dedede; padding-bottom:10px; background:#fff;clear: both;padding-top: 10px;border-bottom: solid 1px #dedede;background-color: #f7f7f7;">
<h6 style="text-align:center;margin:5px 15px;"> 
<a href="http://restya.com/board/?utm_source=Restyaboard ##SITE_NAME##&utm_medium=email&utm_campaign=due_date_notification_email" title="Open source. Trello like kanban board." rel="generator" style="font-size: 11px;text-align: center;text-decoration: none;color: #000;font-family: arial; padding-left:10px;">Powered by Restyaboard</a>
</h6>
</footer>
</body>
</html>', 'SITE_URL, SITE_NAME, SUBJECT, CONTENT', 'Due Date Notification');

CREATE SEQUENCE acl_board_links_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
	
CREATE TABLE acl_board_links (
    id bigint DEFAULT nextval('acl_board_links_seq'::regclass) NOT NULL,
    created timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    name character varying(255) NOT NULL,
    url character varying(255) NOT NULL,
    method character varying(255) NOT NULL,
    slug character varying(255) NOT NULL,
    group_id smallint,
    is_hide smallint DEFAULT (0)::smallint NOT NULL
);

ALTER TABLE "acl_board_links" ADD CONSTRAINT "acl_board_links_id" PRIMARY KEY ("id");
CREATE INDEX "acl_board_links_slug" ON "acl_board_links" ("slug");
CREATE INDEX "acl_board_links_group_id" ON "acl_board_links" ("group_id");
CREATE INDEX "acl_board_links_url" ON "acl_board_links" ("url");

CREATE SEQUENCE acl_organization_links_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
	
CREATE TABLE acl_organization_links (
    id bigint DEFAULT nextval('acl_organization_links_seq'::regclass) NOT NULL,
    created timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    name character varying(255) NOT NULL,
    url character varying(255) NOT NULL,
    method character varying(255) NOT NULL,
    slug character varying(255) NOT NULL,
    group_id smallint,
    is_hide smallint DEFAULT (0)::smallint NOT NULL
);

ALTER TABLE "acl_organization_links" ADD CONSTRAINT "acl_organization_links_id" PRIMARY KEY ("id");
CREATE INDEX "acl_organization_links_slug" ON "acl_organization_links" ("slug");
CREATE INDEX "acl_organization_links_group_id" ON "acl_organization_links" ("group_id");
CREATE INDEX "acl_organization_links_url" ON "acl_organization_links" ("url");

CREATE SEQUENCE board_user_roles_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE TABLE board_user_roles (
    id bigint DEFAULT nextval('board_user_roles_seq'::regclass) NOT NULL,
    created timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    name character varying(255) NOT NULL,
    description character varying
);

INSERT INTO "board_user_roles" ("id", "created", "modified", "name", "description") VALUES 
(1, now(), now(), 'Owner', 'Can view and edit cards, remove members, and change settings for the board.'),
(2, now(), now(), 'Editor', 'Can view and edit cards, remove members, but not change settings.'),
(3, now(), now(), 'Viewer', 'Can view only.');

CREATE SEQUENCE organization_user_roles_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE TABLE organization_user_roles (
    id bigint DEFAULT nextval('organization_user_roles_seq'::regclass) NOT NULL,
    created timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    name character varying(255) NOT NULL,
    description character varying
);

INSERT INTO "organization_user_roles" ("id", "created", "modified", "name", "description") VALUES 
(1, now(), now(), 'Owner', 'Can view, create and edit org boards, and change settings for the organization.'),
(2, now(), now(), 'Editor', 'Can view, create, and edit org boards, but not change settings.'),
(3, now(), now(), 'Viewer', 'Can view only.');

CREATE SEQUENCE acl_board_links_boards_user_roles_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE TABLE acl_board_links_boards_user_roles (
    id bigint DEFAULT nextval('acl_board_links_boards_user_roles_seq'::regclass) NOT NULL,
    created timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    acl_board_link_id bigint NOT NULL,
    board_user_role_id bigint NOT NULL
);

INSERT INTO "acl_board_links_boards_user_roles" ("id", "created", "modified", "acl_board_link_id", "board_user_role_id") VALUES
(1,	'2016-02-22 12:43:35.008',	'2016-02-22 12:43:35.008',	1,	1),
(2,	'2016-02-22 12:43:35.599',	'2016-02-22 12:43:35.599',	6,	1),
(3,	'2016-02-22 12:43:36.131',	'2016-02-22 12:43:36.131',	10,	1),
(4,	'2016-02-22 12:43:36.649',	'2016-02-22 12:43:36.649',	13,	1),
(5,	'2016-02-22 12:43:37.17',	'2016-02-22 12:43:37.17',	15,	1),
(6,	'2016-02-22 12:43:37.888',	'2016-02-22 12:43:37.888',	20,	1),
(7,	'2016-02-22 12:43:38.505',	'2016-02-22 12:43:38.505',	22,	1),
(8,	'2016-02-22 12:43:39.931',	'2016-02-22 12:43:39.931',	23,	1),
(9,	'2016-02-22 12:43:40.462',	'2016-02-22 12:43:40.462',	24,	1),
(10,	'2016-02-22 12:43:40.966',	'2016-02-22 12:43:40.966',	29,	1),
(11,	'2016-02-22 12:43:41.585',	'2016-02-22 12:43:41.585',	32,	1),
(12,	'2016-02-22 12:43:42.23',	'2016-02-22 12:43:42.23',	41,	1),
(13,	'2016-02-22 12:43:42.736',	'2016-02-22 12:43:42.736',	45,	1),
(14,	'2016-02-22 12:43:43.589',	'2016-02-22 12:43:43.589',	49,	1),
(15,	'2016-02-22 12:43:45.065',	'2016-02-22 12:43:45.065',	53,	1),
(16,	'2016-02-22 12:43:45.646',	'2016-02-22 12:43:45.646',	55,	1),
(17,	'2016-02-22 12:43:46.14',	'2016-02-22 12:43:46.14',	58,	1),
(18,	'2016-02-22 12:43:47.394',	'2016-02-22 12:43:47.394',	5,	1),
(19,	'2016-02-22 12:43:47.942',	'2016-02-22 12:43:47.942',	8,	1),
(20,	'2016-02-22 12:43:48.548',	'2016-02-22 12:43:48.548',	30,	1),
(21,	'2016-02-22 12:43:49.176',	'2016-02-22 12:43:49.176',	37,	1),
(22,	'2016-02-22 12:43:49.848',	'2016-02-22 12:43:49.848',	47,	1),
(23,	'2016-02-22 12:43:51.762',	'2016-02-22 12:43:51.762',	51,	1),
(24,	'2016-02-22 12:43:52.402',	'2016-02-22 12:43:52.402',	57,	1),
(25,	'2016-02-22 12:43:53.654',	'2016-02-22 12:43:53.654',	2,	1),
(26,	'2016-02-22 12:43:55.821',	'2016-02-22 12:43:55.821',	3,	1),
(27,	'2016-02-22 12:43:56.556',	'2016-02-22 12:43:56.556',	4,	1),
(28,	'2016-02-22 12:43:57.59',	'2016-02-22 12:43:57.59',	7,	1),
(29,	'2016-02-22 12:43:58.523',	'2016-02-22 12:43:58.523',	9,	1),
(30,	'2016-02-22 12:43:59.332',	'2016-02-22 12:43:59.332',	11,	1),
(31,	'2016-02-22 12:44:00.126',	'2016-02-22 12:44:00.126',	12,	1),
(32,	'2016-02-22 12:44:00.853',	'2016-02-22 12:44:00.853',	16,	1),
(33,	'2016-02-22 12:44:01.581',	'2016-02-22 12:44:01.581',	18,	1),
(34,	'2016-02-22 12:44:03.168',	'2016-02-22 12:44:03.168',	19,	1),
(35,	'2016-02-22 12:44:03.774',	'2016-02-22 12:44:03.774',	21,	1),
(36,	'2016-02-22 12:44:04.428',	'2016-02-22 12:44:04.428',	25,	1),
(37,	'2016-02-22 12:44:05.131',	'2016-02-22 12:44:05.131',	26,	1),
(38,	'2016-02-22 12:44:05.738',	'2016-02-22 12:44:05.738',	27,	1),
(39,	'2016-02-22 12:44:06.437',	'2016-02-22 12:44:06.437',	28,	1),
(40,	'2016-02-22 12:44:08.372',	'2016-02-22 12:44:08.372',	31,	1),
(41,	'2016-02-22 12:44:08.95',	'2016-02-22 12:44:08.95',	33,	1),
(42,	'2016-02-22 12:44:09.715',	'2016-02-22 12:44:09.715',	34,	1),
(43,	'2016-02-22 12:44:10.4',	'2016-02-22 12:44:10.4',	35,	1),
(44,	'2016-02-22 12:44:11.628',	'2016-02-22 12:44:11.628',	36,	1),
(45,	'2016-02-22 12:44:13.156',	'2016-02-22 12:44:13.156',	38,	1),
(46,	'2016-02-22 12:44:13.809',	'2016-02-22 12:44:13.809',	39,	1),
(47,	'2016-02-22 12:44:15.24',	'2016-02-22 12:44:15.24',	40,	1),
(48,	'2016-02-22 12:44:15.774',	'2016-02-22 12:44:15.774',	42,	1),
(49,	'2016-02-22 12:44:16.735',	'2016-02-22 12:44:16.735',	43,	1),
(50,	'2016-02-22 12:44:18.192',	'2016-02-22 12:44:18.192',	44,	1),
(51,	'2016-02-22 12:44:18.738',	'2016-02-22 12:44:18.738',	46,	1),
(52,	'2016-02-22 12:44:19.81',	'2016-02-22 12:44:19.81',	48,	1),
(53,	'2016-02-22 12:44:20.659',	'2016-02-22 12:44:20.659',	50,	1),
(54,	'2016-02-22 12:44:21.955',	'2016-02-22 12:44:21.955',	52,	1),
(55,	'2016-02-22 12:44:22.802',	'2016-02-22 12:44:22.802',	54,	1),
(56,	'2016-02-22 12:44:23.529',	'2016-02-22 12:44:23.529',	56,	1),
(57,	'2016-02-22 12:44:24.402',	'2016-02-22 12:44:24.402',	59,	1),
(58,	'2016-02-22 12:44:25.099',	'2016-02-22 12:44:25.099',	60,	1),
(59,	'2016-02-22 12:44:26.051',	'2016-02-22 12:44:26.051',	61,	1),
(60,	'2016-02-22 12:46:06.23',	'2016-02-22 12:46:06.23',	6,	2),
(61,	'2016-02-22 12:46:08.972',	'2016-02-22 12:46:08.972',	13,	2),
(62,	'2016-02-22 12:46:11.58',	'2016-02-22 12:46:11.58',	15,	2),
(63,	'2016-02-22 12:46:14.307',	'2016-02-22 12:46:14.307',	20,	2),
(64,	'2016-02-22 12:46:45.613',	'2016-02-22 12:46:45.613',	32,	2),
(65,	'2016-02-22 12:46:50.203',	'2016-02-22 12:46:50.203',	45,	2),
(66,	'2016-02-22 12:46:51.058',	'2016-02-22 12:46:51.058',	49,	2),
(67,	'2016-02-22 12:47:00.281',	'2016-02-22 12:47:00.281',	58,	2),
(68,	'2016-02-22 12:47:04.274',	'2016-02-22 12:47:04.274',	55,	2),
(69,	'2016-02-22 12:47:06.413',	'2016-02-22 12:47:06.413',	5,	2),
(70,	'2016-02-22 12:47:08.035',	'2016-02-22 12:47:08.035',	8,	2),
(71,	'2016-02-22 12:47:09.228',	'2016-02-22 12:47:09.228',	30,	2),
(72,	'2016-02-22 12:47:10.195',	'2016-02-22 12:47:10.195',	37,	2),
(73,	'2016-02-22 12:47:11.524',	'2016-02-22 12:47:11.524',	47,	2),
(74,	'2016-02-22 12:47:12.297',	'2016-02-22 12:47:12.297',	51,	2),
(75,	'2016-02-22 12:47:13.172',	'2016-02-22 12:47:13.172',	57,	2),
(76,	'2016-02-22 12:47:16.28',	'2016-02-22 12:47:16.28',	2,	2),
(77,	'2016-02-22 12:47:17.203',	'2016-02-22 12:47:17.203',	3,	2),
(78,	'2016-02-22 12:47:17.917',	'2016-02-22 12:47:17.917',	4,	2),
(79,	'2016-02-22 12:47:19.217',	'2016-02-22 12:47:19.217',	7,	2),
(80,	'2016-02-22 12:47:24.908',	'2016-02-22 12:47:24.908',	11,	2),
(81,	'2016-02-22 12:47:25.573',	'2016-02-22 12:47:25.573',	12,	2),
(82,	'2016-02-22 12:47:26.632',	'2016-02-22 12:47:26.632',	16,	2),
(83,	'2016-02-22 12:47:27.406',	'2016-02-22 12:47:27.406',	18,	2),
(84,	'2016-02-22 12:47:28.325',	'2016-02-22 12:47:28.325',	19,	2),
(85,	'2016-02-22 12:47:30.053',	'2016-02-22 12:47:30.053',	21,	2),
(86,	'2016-02-22 12:47:31.461',	'2016-02-22 12:47:31.461',	25,	2),
(87,	'2016-02-22 12:47:32.572',	'2016-02-22 12:47:32.572',	26,	2),
(88,	'2016-02-22 12:47:34.276',	'2016-02-22 12:47:34.276',	27,	2),
(89,	'2016-02-22 12:47:36.189',	'2016-02-22 12:47:36.189',	28,	2),
(90,	'2016-02-22 12:47:37.972',	'2016-02-22 12:47:37.972',	31,	2),
(91,	'2016-02-22 12:47:38.728',	'2016-02-22 12:47:38.728',	33,	2),
(92,	'2016-02-22 12:47:39.751',	'2016-02-22 12:47:39.751',	34,	2),
(93,	'2016-02-22 12:47:40.498',	'2016-02-22 12:47:40.498',	35,	2),
(94,	'2016-02-22 12:47:41.485',	'2016-02-22 12:47:41.485',	36,	2),
(95,	'2016-02-22 12:47:42.15',	'2016-02-22 12:47:42.15',	38,	2),
(96,	'2016-02-22 12:47:43.781',	'2016-02-22 12:47:43.781',	39,	2),
(97,	'2016-02-22 12:47:44.712',	'2016-02-22 12:47:44.712',	40,	2),
(98,	'2016-02-22 12:47:45.469',	'2016-02-22 12:47:45.469',	42,	2),
(99,	'2016-02-22 12:47:46.325',	'2016-02-22 12:47:46.325',	43,	2),
(100,	'2016-02-22 12:47:47.076',	'2016-02-22 12:47:47.076',	44,	2),
(101,	'2016-02-22 12:47:48.52',	'2016-02-22 12:47:48.52',	46,	2),
(103,	'2016-02-22 12:47:58.03',	'2016-02-22 12:47:58.03',	50,	2),
(104,	'2016-02-22 12:47:59.63',	'2016-02-22 12:47:59.63',	52,	2),
(105,	'2016-02-22 12:48:01.776',	'2016-02-22 12:48:01.776',	54,	2),
(106,	'2016-02-22 12:48:02.615',	'2016-02-22 12:48:02.615',	56,	2),
(107,	'2016-02-22 12:48:03.725',	'2016-02-22 12:48:03.725',	59,	2),
(108,	'2016-02-22 12:48:05.749',	'2016-02-22 12:48:05.749',	60,	2),
(109,	'2016-02-22 12:48:07.046',	'2016-02-22 12:48:07.046',	61,	2),
(110,	'2016-02-22 12:48:20.14',	'2016-02-22 12:48:20.14',	6,	3),
(111,	'2016-02-22 12:48:22.81',	'2016-02-22 12:48:22.81',	13,	3),
(112,	'2016-02-22 12:48:30.485',	'2016-02-22 12:48:30.485',	15,	3),
(113,	'2016-02-22 12:48:37.553',	'2016-02-22 12:48:37.553',	45,	3),
(114,	'2016-02-22 12:48:38.118',	'2016-02-22 12:48:38.118',	49,	3),
(115,	'2016-02-22 12:48:43.07',	'2016-02-22 12:48:43.07',	58,	3),
(116,	'2016-02-22 12:48:47.487',	'2016-02-22 12:48:47.487',	47,	3),
(117,	'2016-02-22 12:48:48.016',	'2016-02-22 12:48:48.016',	51,	3),
(118,	'2016-02-22 12:48:49.539',	'2016-02-22 12:48:49.539',	57,	3),
(119,	'2016-02-22 12:49:05.555',	'2016-02-22 12:49:05.555',	16,	3),
(120,	'2016-02-22 12:49:07.169',	'2016-02-22 12:49:07.169',	18,	3),
(121,	'2016-02-22 12:49:13.259',	'2016-02-22 12:49:13.259',	31,	3),
(122,	'2016-02-22 12:49:20.998',	'2016-02-22 12:49:20.998',	43,	3),
(123,	'2016-02-22 12:49:27.487',	'2016-02-22 12:49:27.487',	46,	3),
(124,	'2016-02-22 12:49:29.363',	'2016-02-22 12:49:29.363',	50,	3),
(125,	'2016-02-22 12:49:43.194',	'2016-02-22 12:49:43.194',	56,	3),
(126,	'2016-02-22 12:49:44.285',	'2016-02-22 12:49:44.285',	59,	3),
(127,	'2016-02-22 12:49:46.076',	'2016-02-22 12:49:46.076',	60,	3),
(128,	'2016-02-22 12:49:49.309',	'2016-02-22 12:49:49.309',	61,	3);

CREATE SEQUENCE acl_organization_links_organizations_user_roles_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE TABLE acl_organization_links_organizations_user_roles (
    id bigint DEFAULT nextval('acl_organization_links_organizations_user_roles_seq'::regclass) NOT NULL,
    created timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    acl_organization_link_id bigint NOT NULL,
    organization_user_role_id bigint NOT NULL
);

INSERT INTO "acl_organization_links_organizations_user_roles" ("id", "created", "modified", "acl_organization_link_id", "organization_user_role_id") VALUES
(1,	'2016-02-22 12:44:27.98',	'2016-02-22 12:44:27.98',	1,	1),
(2,	'2016-02-22 12:44:28.532',	'2016-02-22 12:44:28.532',	2,	1),
(3,	'2016-02-22 12:44:29.562',	'2016-02-22 12:44:29.562',	3,	1),
(4,	'2016-02-22 12:44:30.3',	'2016-02-22 12:44:30.3',	4,	1),
(5,	'2016-02-22 12:44:30.946',	'2016-02-22 12:44:30.946',	5,	1),
(6,	'2016-02-22 12:44:32.307',	'2016-02-22 12:44:32.307',	6,	1),
(7,	'2016-02-22 12:44:33.987',	'2016-02-22 12:44:33.987',	7,	1),
(8,	'2016-02-22 12:44:34.861',	'2016-02-22 12:44:34.861',	8,	1),
(9,	'2016-02-22 12:45:11.11',	'2016-02-22 12:45:11.11',	4,	2),
(10,	'2016-02-22 12:45:12.731',	'2016-02-22 12:45:12.731',	5,	2),
(11,	'2016-02-22 12:45:18.662',	'2016-02-22 12:45:18.662',	8,	2),
(12,	'2016-02-22 12:45:19.841',	'2016-02-22 12:45:19.841',	3,	2),
(13,	'2016-02-22 12:45:30.059',	'2016-02-22 12:45:30.059',	4,	3),
(14,	'2016-02-22 12:45:36.157',	'2016-02-22 12:45:36.157',	5,	3);

CREATE VIEW acl_board_links_listing AS
 SELECT ablbur.board_user_role_id,
    abl.slug,
    abl.url,
    abl.method
   FROM (acl_board_links_boards_user_roles ablbur
     JOIN acl_board_links abl ON ((abl.id = ablbur.acl_board_link_id)));
	 
CREATE VIEW acl_organization_links_listing AS
 SELECT aolour.organization_user_role_id,
    aol.slug,
    aol.url,
    aol.method
   FROM (acl_organization_links_organizations_user_roles aolour
     JOIN acl_organization_links aol ON ((aol.id = aolour.acl_organization_link_id)));

DROP VIEW "boards_users_listing" CASCADE;
DROP VIEW "organizations_users_listing" CASCADE;
DROP VIEW "simple_board_listing" CASCADE;

ALTER TABLE "boards_users" DROP "is_admin";
ALTER TABLE "boards_users" ADD "board_user_role_id" smallint NOT NULL DEFAULT '0';
ALTER TABLE "organizations_users" DROP "is_admin"; 
ALTER TABLE "organizations_users" ADD "organization_user_role_id" smallint NOT NULL DEFAULT '0';

INSERT INTO "acl_organization_links" ("id", "created", "modified", "name", "url", "method", "slug", "group_id") VALUES
(1,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Add organization member',	'/organizations/?/users/?',	'POST',	'add_organization_user',	5),
(2,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Delete organization',	'/organizations/?',	'DELETE',	'delete_organization',	5),
(3,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Edit organization',	'/organizations/?',	'PUT',	'edit_organization',	5),
(4,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Organization members listing',	'/organizations_users/?',	'GET',	'view_organization_user_listing',	5),
(5,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Organization visibility',	'/organizations/?/visibility',	'GET',	'view_organization_visibility',	5),
(6,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Remove organization member',	'/organizations/?/organizations_users/?',	'DELETE',	'remove_organization_user',	5),
(7,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Update organization member permission',	'/organizations_users/?',	'PUT',	'edit_organization_user',	5),
(8,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Upload organization logo',	'/organizations/?/upload_logo',	'POST',	'upload_organization_logo',	5);

INSERT INTO "acl_board_links" ("id", "created", "modified", "name", "url", "method", "slug", "group_id", "is_hide") VALUES
(1,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Add board member',	'/boards/?/users',	'POST',	'add_board_users',	2,	0),
(2,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Add card',	'/boards/?/lists/?/cards',	'POST',	'add_card',	4,	0),
(3,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Add checklist to card',	'/boards/?/lists/?/cards/?/checklists',	'POST',	'add_checklists',	4,	0),
(4,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Add item to checklist',	'/boards/?/lists/?/cards/?/checklists/?/items',	'POST',	'add_checklist_item',	4,	0),
(5,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Add list',	'/boards/?/lists',	'POST',	'add_list',	3,	0),
(6,	'2014-08-25 13:14:18.2',	'2014-08-25 13:14:18.2',	'All activities',	'/activities',	'GET',	'activities_listing',	2,	0),
(7,	'2016-02-19 16:21:04.718',	'2016-02-19 16:21:04.718',	'Archive card',	'',	'',	'archive_card',	4,	0),
(8,	'2016-02-19 16:21:04.687',	'2016-02-19 16:21:04.687',	'Archive list',	'',	'',	'archive_list',	3,	0),
(9,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Archived card send back to board',	'/boards/?/lists/?/cards',	'POST',	'send_back_to_archived_card',	4,	0),
(10,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Archived list send back to board',	'/lists/?',	'PUT',	'send_back_to_archived_list',	2,	0),
(11,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Assign labels to card',	'/boards/?/lists/?/cards/?/labels',	'POST',	'add_labels',	4,	0),
(12,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Assign member to card',	'/boards/?/lists/?/cards/?/users/?',	'POST',	'add_card_user',	4,	0),
(13,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Board members listing',	'/board_users/?',	'GET',	'view_board_listing',	2,	0),
(14,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Board subscribers',	'/boards/?/board_subscribers',	'GET',	'view_board_subscribers',	2,	1),
(15,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Board sync Google calendar URL',	'/boards/?/sync_calendar',	'GET',	'view_sync_calendar',	2,	0),
(16,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Card activities',	'/boards/?/lists/?/cards/?/activities',	'GET',	'view_card_activities',	4,	0),
(17,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Cards listing',	'/boards/?/lists/?/cards/?',	'GET',	'view_card_isting',	4,	1),
(18,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Checklist listing',	'/boards/?/lists/?/cards/?/checklists',	'GET',	'view_checklist_listing',	4,	0),
(19,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Convert item to card',	'/boards/?/lists/?/cards/?/checklists/?/items/?/convert_to_card',	'POST',	'convert_item_to_card',	4,	0),
(20,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Copy board',	'/boards/?/copy',	'POST',	'copy_board',	2,	0),
(21,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Copy card',	'/boards/?/lists/?/cards/?/copy',	'POST',	'copy_card',	4,	0),
(22,	'2016-02-16 16:57:48.45',	'2016-02-16 16:57:48.45',	'Delete all archived cards',	'/boards/?/cards',	'DELETE',	'delete_all_archived_cards',	2,	0),
(23,	'2016-02-16 16:57:48.372',	'2016-02-16 16:57:48.372',	'Delete all archived lists',	'/boards/?/lists',	'DELETE',	'delete_all_archived_lists',	2,	0),
(24,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Delete board',	'/boards/?/boards_users/?',	'DELETE',	'delete_board',	2,	0),
(25,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Delete card',	'/boards/?/lists/?/cards/?',	'DELETE',	'delete_card',	4,	0),
(26,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Delete checklist',	'/boards/?/lists/?/cards/?/checklists/?',	'DELETE',	'delete_checklist',	4,	0),
(27,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Delete comment',	'/boards/?/lists/?/cards/?/comments/?',	'DELETE',	'delete_comment',	4,	0),
(28,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Delete item in checklist',	'/boards/?/lists/?/cards/?/checklists/?/items/?',	'DELETE',	'delete_checklist_item',	4,	0),
(29,	'2016-02-16 16:57:48.45',	'2016-02-16 16:57:48.45',	'Delete Labels',	'/boards/?/labels/?',	'DELETE',	'delete_labels',	2,	0),
(30,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Delete list',	'/boards/?/lists/?',	'DELETE',	'delete_list',	3,	0),
(31,	'2014-08-25 13:14:18.2',	'2014-08-25 13:14:18.2',	'Download attachment from card',	'/download/?',	'GET',	'download_attachment_card',	4,	0),
(32,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Edit board',	'/boards/?',	'PUT',	'edit_board',	2,	0),
(33,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Edit card',	'/boards/?/lists/?/cards/?',	'PUT',	'edit_card',	4,	0),
(34,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Edit checklist',	'/boards/?/lists/?/cards/?/checklists/?',	'PUT',	'edit_checklist',	4,	0),
(35,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Edit comment',	'/boards/?/lists/?/cards/?/comments/?',	'PUT',	'edit_comment',	4,	0),
(36,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Edit item in checklist',	'/boards/?/lists/?/cards/?/checklists/?/items/?',	'PUT',	'edit_checklist_item',	4,	0),
(37,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Edit list',	'/boards/?/lists/?',	'PUT',	'edit_list',	3,	0),
(38,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Move list cards',	'/boards/?/lists/?/cards',	'PUT',	'move_list_cards',	4,	0),
(39,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Post comment to card',	'/boards/?/lists/?/cards/?/comments',	'POST',	'comment_card',	4,	0),
(40,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Remove attachment from card',	'/boards/?/lists/?/cards/?/attachments/?',	'DELETE',	'remove_card_attachment',	4,	0),
(41,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Remove board member',	'/boards_users/?',	'DELETE',	'remove_board_user',	2,	0),
(42,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Remove card member',	'/boards/?/lists/?/cards/?/users/?',	'DELETE',	'delete_card_user',	4,	0),
(43,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Search card',	'/cards/search',	'GET',	'search_card',	4,	0),
(44,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Search card to add in comment',	'/boards/?/lists/?/cards/?/search',	'GET',	'view_card_search',	4,	0),
(45,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Subscribe board',	'/boards/?/board_subscribers',	'POST',	'subscribe_board',	2,	0),
(46,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Subscribe card',	'/boards/?/lists/?/cards/?/card_subscribers',	'POST',	'subscribe_card',	4,	0),
(47,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Subscribe list',	'/boards/?/lists/?/list_subscribers',	'POST',	'subscribe_list',	3,	0),
(48,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Undo activity',	'/activities/undo/?',	'PUT',	'undo_activity',	4,	0),
(49,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Unsubscribe board',	'/boards/?/board_subscribers/?',	'PUT',	'board_subscriber',	2,	0),
(50,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Unsubscribe card',	'/boards/?/lists/?/cards/?/card_subscribers/?',	'PUT',	'unsubscribe_card',	4,	0),
(51,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Unsubscribe list',	'/boards/?/lists/?/list_subscribers/?',	'PUT',	'unsubscribe_list',	3,	0),
(52,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Unvote card',	'/boards/?/lists/?/cards/?/card_voters/?',	'DELETE',	'unvote_card',	4,	0),
(53,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Update board member permission',	'/boards_users/?',	'PUT',	'edit_board_user',	2,	0),
(54,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Upload attachment to card',	'/boards/?/lists/?/cards/?/attachments',	'POST',	'add_card_attachment',	4,	0),
(55,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Upload custom background to board',	'/boards/?/custom_backgrounds',	'POST',	'add_custom_background',	2,	0),
(56,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'View Archived card',	'/boards/?/archived_cards',	'GET',	'view_archived_cards',	4,	0),
(57,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'View archived list',	'/boards/?/archived_lists',	'GET',	'view_archived_lists',	3,	0),
(58,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'View board activities',	'/boards/?/activities',	'GET',	'view_board_activities',	2,	0),
(59,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'View card labels',	'/boards/?/lists/?/cards/?/labels',	'GET',	'view_card_labels',	4,	0),
(60,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'View user assigned cards',	'/users/?/cards',	'GET',	'view_user_cards',	4,	0),
(61,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Vote card',	'/boards/?/lists/?/cards/?/card_voters',	'POST',	'vote_card',	4,	0);

CREATE OR REPLACE VIEW boards_users_listing AS
 SELECT bu.id,
    bu.created,
    bu.modified,
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
                    boards_subscribers.created,
                    boards_subscribers.modified,
                    boards_subscribers.board_id,
                    boards_subscribers.user_id,
                    (boards_subscribers.is_subscribed)::integer AS is_subscribed
                   FROM board_subscribers boards_subscribers
                  WHERE (boards_subscribers.board_id = board.id)
                  ORDER BY boards_subscribers.id) bs) AS boards_subscribers,
    ( SELECT array_to_json(array_agg(row_to_json(bs.*))) AS array_to_json
           FROM ( SELECT boards_stars.id,
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
                    card_attachments.created,
                    card_attachments.modified,
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

CREATE OR REPLACE VIEW organizations_users_listing AS
 SELECT organizations_users.id,
    organizations_users.created,
    organizations_users.modified,
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
                    lists.created,
                    lists.modified,
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

CREATE OR REPLACE FUNCTION update_organization_user_count() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN
	IF (TG_OP = 'DELETE') THEN
		UPDATE "organizations" SET "organizations_user_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "organizations_users" WHERE "organization_id" = OLD."organization_id") t WHERE "id" = OLD."organization_id";
	        UPDATE "users" SET "joined_organization_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "organizations_users" WHERE "user_id" = OLD."user_id") t WHERE "id" = OLD."user_id";
		UPDATE "users" SET "owner_organization_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "organizations_users" WHERE "user_id" = OLD."user_id" AND "organization_user_role_id" = 1) t WHERE "id" = OLD."user_id";
	        UPDATE "users" SET "member_organization_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "organizations_users" WHERE "user_id" = OLD."user_id" AND "organization_user_role_id" = 2) t WHERE "id" = OLD."user_id";
		RETURN OLD;
	ELSIF (TG_OP = 'UPDATE') THEN
		UPDATE "organizations" SET "organizations_user_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "organizations_users" WHERE "organization_id" = OLD."organization_id") t WHERE "id" = OLD."organization_id";
	        UPDATE "users" SET "joined_organization_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "organizations_users" WHERE "user_id" = OLD."user_id") t WHERE "id" = OLD."user_id";
		UPDATE "users" SET "owner_organization_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "organizations_users" WHERE "user_id" = OLD."user_id" AND "organization_user_role_id" = 1) t WHERE "id" = OLD."user_id";
	        UPDATE "users" SET "member_organization_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "organizations_users" WHERE "user_id" = OLD."user_id" AND "organization_user_role_id" = 2) t WHERE "id" = OLD."user_id";
		RETURN OLD;
	ELSIF (TG_OP = 'INSERT') THEN
		UPDATE "organizations" SET "organizations_user_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "organizations_users" WHERE "organization_id" = NEW."organization_id") t WHERE "id" = NEW."organization_id";
	        UPDATE "users" SET "joined_organization_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "organizations_users" WHERE "user_id" = NEW."user_id") t WHERE "id" = NEW."user_id";
	        UPDATE "users" SET "owner_organization_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "organizations_users" WHERE "user_id" = NEW."user_id" AND "organization_user_role_id" = 1) t WHERE "id" = NEW."user_id";
	        UPDATE "users" SET "member_organization_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "organizations_users" WHERE "user_id" = NEW."user_id" AND "organization_user_role_id" = 2) t WHERE "id" = NEW."user_id";
		RETURN NEW;
	END IF;
END;
$$;

CREATE OR REPLACE FUNCTION update_board_user_count() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN
	IF (TG_OP = 'DELETE') THEN
		UPDATE "boards" SET "boards_user_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "boards_users" WHERE "board_id" = OLD."board_id") t WHERE "id" = OLD."board_id";
		UPDATE "users" SET "joined_board_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "boards_users" WHERE "user_id" = OLD."user_id") t WHERE "id" = OLD."user_id";
		UPDATE "users" SET "owner_board_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "boards_users" WHERE "user_id" = OLD."user_id" AND "board_user_role_id" = 1) t WHERE "id" = OLD."user_id";
	        UPDATE "users" SET "member_board_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "boards_users" WHERE "user_id" = OLD."user_id" AND "board_user_role_id" = 2) t WHERE "id" = OLD."user_id";
		RETURN OLD;
	ELSIF (TG_OP = 'UPDATE') THEN
		UPDATE "boards" SET "boards_user_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "boards_users" WHERE "board_id" = OLD."board_id") t WHERE "id" = OLD."board_id";
	        UPDATE "users" SET "joined_board_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "boards_users" WHERE "user_id" = OLD."user_id") t WHERE "id" = OLD."user_id";
		UPDATE "users" SET "owner_board_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "boards_users" WHERE "user_id" = OLD."user_id" AND "board_user_role_id" = 1) t WHERE "id" = OLD."user_id";
	        UPDATE "users" SET "member_board_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "boards_users" WHERE "user_id" = OLD."user_id" AND "board_user_role_id" = 2) t WHERE "id" = OLD."user_id";
		RETURN OLD;
	ELSIF (TG_OP = 'INSERT') THEN
		UPDATE "boards" SET "boards_user_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "boards_users" WHERE "board_id" = NEW."board_id") t WHERE "id" = NEW."board_id";
	        UPDATE "users" SET "joined_board_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "boards_users" WHERE "user_id" = NEW."user_id") t WHERE "id" = NEW."user_id";
	        UPDATE "users" SET "owner_board_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "boards_users" WHERE "user_id" = NEW."user_id" AND "board_user_role_id" = 1) t WHERE "id" = NEW."user_id";
	        UPDATE "users" SET "member_board_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "boards_users" WHERE "user_id" = NEW."user_id" AND "board_user_role_id" = 2) t WHERE "id" = NEW."user_id";
		RETURN NEW;
	END IF;
END;
$$;

DROP VIEW settings_listing;

ALTER TABLE "settings" ALTER "label" TYPE character varying(255), ALTER "label" DROP DEFAULT, ALTER "label" DROP NOT NULL;

CREATE OR REPLACE VIEW settings_listing AS
 SELECT setting_categories.id,
    setting_categories.created,
    setting_categories.modified,
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

UPDATE "settings" SET "description" = 'The DNS name or IP address of the server. For example dc.domain.local.' WHERE "name" = 'LDAP_SERVER';
UPDATE "settings" SET "description" = 'Server port (e.g., 389 for LDAP and 636 for LDAP using SSL)' WHERE "name" = 'LDAP_PORT';
UPDATE "settings" SET "description" = 'Difference betwen LDAPv3 and LDAPv2 https://msdn.microsoft.com/en-us/library/windows/desktop/aa366099%28v=vs.85%29.aspx' WHERE "name" = 'LDAP_PROTOCOL_VERSION';
UPDATE "settings" SET "label" = 'Base DN', "description" = 'This is your search base for LDAP queries. This should be at least your domain root, for example dc=domain,dc=local You can define this as a Organizational Unit if you want to narrow down the search base. For example: ou=team,ou=company,dc=domain,dc=local' WHERE "name" = 'LDAP_ROOT_DN';
UPDATE "settings" SET "label" = 'Account Filter', "description" = 'You can use different field from the username here. For pre-windows 2000 style login, use sAMAccountName and for a UPN style login use userPrincipalName.' WHERE "name" = 'LDAP_UID_FIELD';
UPDATE "settings" SET "label" = 'Bind DN', "description" = 'Enter a valid user account/DN to pre-bind with if your LDAP server does not allow anonymous profile searches, or requires a user with specific privileges to search.' WHERE "name" = 'LDAP_BIND_DN';
UPDATE "settings" SET "type" = 'password', "description" = 'Enter a password for the above Bind DN.' WHERE "name" = 'LDAP_BIND_PASSWD';

INSERT INTO "settings" ("setting_category_id", "setting_category_parent_id", "name", "value", "description", "type", "options", "label", "order") VALUES ('4', '2', 'ENABLE_SSL_CONNECTIVITY', NULL, 'Use encryption (SSL, ldaps:// URL) when connects to server?', 'checkbox', NULL, 'Enable SSL Connectivity', '2');

UPDATE "settings" SET "order" = '3' WHERE "name" = 'ENABLE_SSL_CONNECTIVITY';
UPDATE "settings" SET "order" = '4' WHERE "name" = 'LDAP_SERVER';
UPDATE "settings" SET "order" = '5' WHERE "name" = 'LDAP_PORT';
UPDATE "settings" SET "order" = '6' WHERE "name" = 'LDAP_PROTOCOL_VERSION';
UPDATE "settings" SET "order" = '7' WHERE "name" = 'LDAP_ROOT_DN';
UPDATE "settings" SET "order" = '8' WHERE "name" = 'LDAP_ORGANISATION';
UPDATE "settings" SET "order" = '9' WHERE "name" = 'LDAP_UID_FIELD';
UPDATE "settings" SET "order" = '10' WHERE "name" = 'LDAP_BIND_DN';
UPDATE "settings" SET "order" = '11' WHERE "name" = 'LDAP_BIND_PASSWD';

DROP VIEW "role_links_listing";
DROP VIEW "acl_links_listing";
DROP TABLE "acl_links";
DROP TABLE "acl_links_roles";

CREATE TABLE acl_links (
    id bigint DEFAULT nextval('acl_links_id_seq'::regclass) NOT NULL,
    created timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    name character varying(255) NOT NULL,
    url character varying(255) NOT NULL,
    method character varying(255) NOT NULL,
    slug character varying(255) NOT NULL,
    group_id smallint,
    is_user_action smallint DEFAULT (0)::smallint NOT NULL,
    is_guest_action smallint DEFAULT (0)::smallint NOT NULL,
    is_admin_action smallint DEFAULT (0)::smallint NOT NULL,
    is_hide smallint DEFAULT (0)::smallint NOT NULL
);

INSERT INTO "acl_links" ("id", "created", "modified", "name", "url", "method", "slug", "group_id", "is_user_action", "is_guest_action", "is_admin_action", "is_hide") VALUES
(1,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Add board',	'/boards',	'POST',	'add_board',	2,	1,	0,	0,	0),
(2,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Add organization',	'/organizations',	'POST',	'add_organization',	2,	1,	0,	0,	0),
(3,	'2016-02-09 16:51:25.779',	'2016-02-09 16:51:25.779',	'Add webhooks',	'/webhooks',	'POST',	'add_webhook',	2,	1,	0,	0,	0),
(4,	'2014-08-25 13:14:18.2',	'2014-08-25 13:14:18.2',	'All activities',	'/activities',	'GET',	'activities_listing',	2,	1,	0,	0,	0),
(5,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Board search',	'/boards/search',	'GET',	'view_board_search',	2,	1,	0,	0,	0),
(6,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Board visibility',	'/boards/?/visibility',	'GET',	'view_board_visibility',	2,	1,	0,	0,	0),
(7,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Change password',	'/users/?/changepassword',	'POST',	'user_changepassword',	2,	1,	0,	0,	0),
(8,	'2016-02-09 16:51:25.779',	'2016-02-09 16:51:25.779',	'Delete webhooks',	'/webhooks/?',	'DELETE',	'delete_webhook',	2,	1,	0,	0,	0),
(9,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Edit user details',	'/users/?',	'PUT',	'edit_user_details',	2,	1,	0,	0,	0),
(10,	'2016-02-09 16:51:25.779',	'2016-02-09 16:51:25.779',	'Edit webhooks',	'/webhooks/?',	'PUT',	'edit_webhook',	2,	1,	0,	0,	0),
(11,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Forgot password',	'/users/forgotpassword',	'POST',	'users_forgotpassword',	1,	0,	1,	0,	0),
(12,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Load workflow templates',	'/workflow_templates',	'GET',	'view_workflow_templates',	2,	1,	0,	0,	0),
(13,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Login',	'/users/login',	'POST',	'users_login',	1,	0,	1,	0,	1),
(14,	'2016-02-16 20:04:41.092',	'2016-02-16 20:04:41.092',	'My boards listing',	'/boards/my_boards',	'GET',	'view_my_boards',	2,	1,	0,	0,	0),
(15,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Organization visibility',	'/organizations/?/visibility',	'GET',	'view_organization_visibility',	2,	1,	0,	0,	0),
(16,	'2016-02-09 16:51:26.139',	'2016-02-09 16:51:26.139',	'Post oauth token',	'/oauth/token',	'POST',	'post_oauth_token',	1,	0,	1,	0,	0),
(17,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Register',	'/users/register',	'POST',	'users_register',	1,	0,	1,	0,	0),
(18,	'2016-02-09 16:51:25.217',	'2016-02-09 16:51:25.217',	'Revoke OAuth authorized applications',	'/oauth/applications/?',	'DELETE',	'delete_connected_applications',	2,	1,	0,	0,	0),
(19,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Search',	'/search',	'GET',	'view_search',	2,	1,	0,	0,	0),
(20,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Settings management',	'/settings',	'GET',	'load_settings',	3,	0,	0,	1,	1),
(21,	'2016-02-18 17:42:32.045',	'2016-02-18 17:42:32.045',	'Starred board',	'/boards/?/boards_stars',	'POST',	'starred_board',	2,	1,	0,	0,	0),
(22,	'2016-02-16 20:06:48.576',	'2016-02-16 20:06:48.576',	'Starred boards listing',	'/boards/starred',	'GET',	'view_stared_boards',	2,	1,	0,	0,	0),
(24,	'2016-02-18 17:45:14.983',	'2016-02-18 17:45:14.983',	'Unstar board',	'/boards/?/boards_stars/?',	'PUT',	'unstarred_board',	2,	1,	0,	0,	0),
(23,	'2016-02-18 17:24:25.733',	'2016-02-18 17:24:25.733',	'Unstar board',	'/boards/?/boards_stars/?',	'PUT',	'board_star',	2,	1,	0,	0,	0),
(25,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Upload profile picture',	'/users/?',	'POST',	'add_user_profile_picture',	2,	1,	0,	0,	0),
(26,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'User activation',	'/users/?/activation',	'PUT',	'user_activation',	1,	0,	1,	0,	0),
(27,	'2016-02-18 20:11:14.482',	'2016-02-18 20:11:14.482',	'View board',	'/boards/?',	'GET',	'view_board',	2,	1,	1,	0,	0),
(28,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'View boards listing',	'/boards',	'GET',	'view_board_listing',	2,	1,	0,	0,	0),
(29,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'View closed boards',	'/boards/closed_boards',	'GET',	'view_closed_boards',	2,	1,	0,	0,	0),
(30,	'2016-02-09 16:51:25.217',	'2016-02-09 16:51:25.217',	'View OAuth authorized applications',	'/oauth/applications',	'GET',	'view_connected_applications',	2,	1,	0,	0,	0),
(31,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'View organization',	'/organizations/?',	'GET',	'view_organization',	2,	1,	0,	0,	0),
(32,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'View organizations listing',	'/organizations',	'GET',	'view_organization_listing',	2,	1,	0,	0,	0),
(33,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'View starred boards listing',	'/boards/?/boards_stars',	'GET',	'view_board_star',	2,	1,	0,	0,	0),
(34,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'View user',	'/users/?',	'GET',	'view_user',	2,	1,	0,	0,	0),
(35,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'View user activities',	'/users/?/activities',	'GET',	'view_user_activities',	2,	1,	0,	0,	0),
(36,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'View user assigned boards',	'/users/?/boards',	'GET',	'view_user_board',	2,	1,	0,	0,	0),
(37,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'View user assigned cards',	'/users/?/cards',	'GET',	'view_user_cards',	2,	1,	0,	0,	0),
(38,	'2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'View user search',	'/users/search',	'GET',	'view_user_search',	2,	1,	0,	0,	0),
(39,	'2016-02-09 16:51:25.779',	'2016-02-09 16:51:25.779',	'View webhooks',	'/webhooks',	'GET',	'view_webhooks',	2,	1,	0,	0,	0);

CREATE TABLE acl_links_roles (
    id bigint DEFAULT nextval('acl_links_roles_roles_id_seq'::regclass) NOT NULL,
    created timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    acl_link_id bigint NOT NULL,
    role_id bigint NOT NULL
);

INSERT INTO "acl_links_roles" ("id", "created", "modified", "acl_link_id", "role_id") VALUES
(1,	'2016-02-20 19:07:50.849',	'2016-02-20 19:07:50.849',	23,	1),
(2,	'2016-02-20 19:08:19.584',	'2016-02-20 19:08:19.584',	24,	2),
(3,	'2016-02-20 19:08:19.584',	'2016-02-20 19:08:19.584',	24,	1),
(4,	'2016-02-20 19:07:31.102',	'2016-02-20 19:07:31.102',	25,	2),
(5,	'2016-02-20 19:07:31.102',	'2016-02-20 19:07:31.102',	25,	1),
(6,	'2016-02-20 19:07:27.124',	'2016-02-20 19:07:27.124',	26,	3),
(7,	'2016-02-20 19:08:20.385',	'2016-02-20 19:08:20.385',	27,	2),
(8,	'2016-02-20 19:08:21.237',	'2016-02-20 19:08:21.237',	27,	3),
(9,	'2016-02-20 19:08:20.385',	'2016-02-20 19:08:20.385',	27,	1),
(10,	'2016-02-20 19:07:57.812',	'2016-02-20 19:07:57.812',	39,	2),
(11,	'2016-02-20 19:07:57.812',	'2016-02-20 19:07:57.812',	39,	1),
(12,	'2016-02-20 19:07:29.971',	'2016-02-20 19:07:29.971',	1,	2),
(13,	'2016-02-20 19:07:29.971',	'2016-02-20 19:07:29.971',	1,	1),
(14,	'2016-02-20 19:07:29.324',	'2016-02-20 19:07:29.324',	2,	2),
(15,	'2016-02-20 19:07:29.324',	'2016-02-20 19:07:29.324',	2,	1),
(16,	'2016-02-20 19:07:58.59',	'2016-02-20 19:07:58.59',	3,	2),
(17,	'2016-02-20 19:07:58.59',	'2016-02-20 19:07:58.59',	3,	1),
(18,	'2016-02-20 19:07:47.43',	'2016-02-20 19:07:47.43',	4,	1),
(19,	'2016-02-20 19:07:36.217',	'2016-02-20 19:07:36.217',	5,	2),
(20,	'2016-02-20 19:07:36.217',	'2016-02-20 19:07:36.217',	5,	1),
(21,	'2016-02-20 19:07:38.318',	'2016-02-20 19:07:38.318',	6,	2),
(22,	'2016-02-20 19:07:31.771',	'2016-02-20 19:07:31.771',	9,	1),
(23,	'2016-02-20 19:08:16.346',	'2016-02-20 19:08:16.346',	10,	2),
(24,	'2016-02-20 19:08:16.346',	'2016-02-20 19:08:16.346',	10,	1),
(25,	'2016-02-20 19:07:25.664',	'2016-02-20 19:07:25.664',	11,	3),
(26,	'2016-02-20 19:07:39.589',	'2016-02-20 19:07:39.589',	12,	2),
(27,	'2016-02-20 19:07:26.404',	'2016-02-20 19:07:26.404',	17,	3),
(28,	'2016-02-20 19:07:57.006',	'2016-02-20 19:07:57.006',	18,	2),
(29,	'2016-02-20 19:07:57.006',	'2016-02-20 19:07:57.006',	18,	1),
(30,	'2016-02-20 19:07:41.054',	'2016-02-20 19:07:41.054',	19,	2),
(31,	'2016-02-20 19:07:41.054',	'2016-02-20 19:07:41.054',	19,	1),
(32,	'2016-02-22 10:58:31.89',	'2016-02-22 10:58:31.89',	20,	3),
(33,	'2016-02-22 12:17:06.002',	'2016-02-22 12:17:06.002',	20,	1),
(34,	'2016-02-20 19:08:18.616',	'2016-02-20 19:08:18.616',	21,	1),
(35,	'2016-02-20 19:07:32.362',	'2016-02-20 19:07:32.362',	28,	2),
(36,	'2016-02-20 19:07:32.362',	'2016-02-20 19:07:32.362',	28,	1),
(37,	'2016-02-20 19:07:34.351',	'2016-02-20 19:07:34.351',	31,	2),
(38,	'2016-02-20 19:07:34.351',	'2016-02-20 19:07:34.351',	31,	1),
(39,	'2016-02-20 19:07:45.749',	'2016-02-20 19:07:45.749',	32,	2),
(40,	'2016-02-20 19:07:45.749',	'2016-02-20 19:07:45.749',	32,	1),
(41,	'2016-02-20 19:07:43.927',	'2016-02-20 19:07:43.927',	33,	2),
(42,	'2016-02-20 19:07:43.927',	'2016-02-20 19:07:43.927',	33,	1),
(43,	'2016-02-20 19:07:41.755',	'2016-02-20 19:07:41.755',	34,	2),
(44,	'2016-02-20 19:07:41.755',	'2016-02-20 19:07:41.755',	34,	1),
(45,	'2016-02-20 19:07:47.43',	'2016-02-20 19:07:47.43',	4,	2),
(46,	'2016-02-20 19:07:39.589',	'2016-02-20 19:07:39.589',	12,	1),
(47,	'2016-02-20 19:07:38.318',	'2016-02-20 19:07:38.318',	6,	1),
(48,	'2016-02-22 10:59:06.81',	'2016-02-22 10:59:06.81',	13,	3),
(49,	'2016-02-20 19:07:48.396',	'2016-02-20 19:07:48.396',	14,	2),
(50,	'2016-02-20 19:07:48.396',	'2016-02-20 19:07:48.396',	14,	1),
(51,	'2016-02-20 19:07:45.001',	'2016-02-20 19:07:45.001',	29,	2),
(52,	'2016-02-20 19:07:45.001',	'2016-02-20 19:07:45.001',	29,	1),
(53,	'2016-02-20 19:07:52.525',	'2016-02-20 19:07:52.525',	30,	2),
(54,	'2016-02-20 19:07:52.525',	'2016-02-20 19:07:52.525',	30,	1),
(55,	'2016-02-20 19:07:39.029',	'2016-02-20 19:07:39.029',	15,	2),
(56,	'2016-02-20 19:07:39.029',	'2016-02-20 19:07:39.029',	15,	1),
(57,	'2016-02-20 19:07:27.772',	'2016-02-20 19:07:27.772',	16,	3),
(58,	'2016-02-20 19:07:35.269',	'2016-02-20 19:07:35.269',	35,	2),
(59,	'2016-02-20 19:07:35.269',	'2016-02-20 19:07:35.269',	35,	1),
(60,	'2016-02-20 19:07:43.227',	'2016-02-20 19:07:43.227',	36,	2),
(61,	'2016-02-20 19:07:43.227',	'2016-02-20 19:07:43.227',	36,	1),
(62,	'2016-02-20 19:07:42.416',	'2016-02-20 19:07:42.416',	37,	2),
(63,	'2016-02-20 19:07:42.416',	'2016-02-20 19:07:42.416',	37,	1),
(64,	'2016-02-20 19:07:37.681',	'2016-02-20 19:07:37.681',	38,	2),
(65,	'2016-02-20 19:07:37.681',	'2016-02-20 19:07:37.681',	38,	1),
(66,	'2016-02-20 19:07:50.147',	'2016-02-20 19:07:50.147',	22,	2),
(67,	'2016-02-20 19:07:50.147',	'2016-02-20 19:07:50.147',	22,	1),
(68,	'2016-02-20 19:07:50.849',	'2016-02-20 19:07:50.849',	23,	2),
(69,	'2016-02-20 19:07:30.541',	'2016-02-20 19:07:30.541',	7,	2),
(70,	'2016-02-20 19:08:18.616',	'2016-02-20 19:08:18.616',	21,	2),
(71,	'2016-02-22 12:58:43.86',	'2016-02-22 12:58:43.86',	20,	2),
(72,	'2016-02-20 19:07:30.541',	'2016-02-20 19:07:30.541',	7,	1),
(73,	'2016-02-20 19:08:17.963',	'2016-02-20 19:08:17.963',	8,	2),
(74,	'2016-02-20 19:08:17.963',	'2016-02-20 19:08:17.963',	8,	1),
(75,	'2016-02-20 19:07:31.771',	'2016-02-20 19:07:31.771',	9,	2);

CREATE OR REPLACE VIEW acl_links_listing AS
 SELECT aclr.role_id,
    acl.slug,
    acl.url,
    acl.method
   FROM (acl_links_roles aclr
   JOIN acl_links acl ON ((acl.id = aclr.acl_link_id)));

CREATE OR REPLACE VIEW role_links_listing AS
 SELECT role.id,
    ( SELECT array_to_json(array_agg(link.*)) AS array_to_json
           FROM ( SELECT alls.slug
                   FROM acl_links_listing alls
                  WHERE (alls.role_id = role.id)) link) AS links
   FROM roles role;

UPDATE "roles" SET "name" = 'Admin' WHERE "id" = '1';
UPDATE "roles" SET "name" = 'User' WHERE "id" = '2';
UPDATE "roles" SET "name" = 'Guest' WHERE "id" = '3';

UPDATE "acl_board_links" SET "name" = 'Add / Delete Labels' WHERE "id" = '29';
DELETE from acl_board_links WHERE id = 24;
DELETE from acl_board_links_boards_user_roles WHERE acl_board_link_id = 24;

DELETE from acl_board_links WHERE id = 60;
DELETE from acl_board_links_boards_user_roles WHERE acl_board_link_id = 60;
DELETE FROM "acl_board_links_boards_user_roles" WHERE acl_board_link_id = (select id from "acl_board_links" WHERE "name" = 'All activities');
DELETE FROM "acl_board_links" WHERE "name" = 'All activities';

DELETE FROM "acl_board_links_boards_user_roles" WHERE acl_board_link_id = (select id from "acl_board_links" WHERE "name" = 'Board members listing');
DELETE FROM "acl_board_links" WHERE "name" = 'Board members listing';

DELETE FROM "acl_board_links_boards_user_roles" WHERE acl_board_link_id = (select id from "acl_board_links" WHERE "slug" = 'search_card');
DELETE FROM "acl_board_links" WHERE "slug" = 'search_card';

UPDATE "acl_board_links" SET "url" = '/boards/?/cards/search' WHERE "slug" = 'view_card_search';

DELETE from acl_links WHERE id = 126;
DELETE from acl_links_roles WHERE acl_link_id = 126;
DELETE from acl_links WHERE id = 142;
DELETE from acl_links_roles WHERE acl_link_id = 142;
UPDATE "acl_links" SET "name" = 'Star / Unstar board' WHERE "id" = '141';

UPDATE "acl_board_links" SET "is_hide" = '1' WHERE "id" = '11';

DELETE from acl_board_links WHERE id = 48;
DELETE from acl_board_links_boards_user_roles WHERE acl_board_link_id = 48;

INSERT INTO "acl_links" ("created", "modified", "name", "url", "method", "slug", "group_id", "is_user_action", "is_guest_action", "is_admin_action", "is_hide") VALUES
('2014-08-25 13:14:18.247',	'2014-08-25 13:14:18.247',	'Undo activity',	'/activities/undo/?',	'PUT',	'undo_activity',	2,	1,	0,	0,	0);

INSERT INTO "acl_links_roles" ("created", "modified", "acl_link_id", "role_id") SELECT '2016-02-20 19:07:50.849',	'2016-02-20 19:07:50.849',	id,	1 FROM acl_links WHERE slug = 'undo_activity';

DELETE FROM "settings" WHERE "name" = 'LDAP_ORGANISATION';

UPDATE "settings" SET "description" = 'The DNS name or IP address of the server (e.g., dc.domain.local)' WHERE "name" = 'LDAP_SERVER';

UPDATE "settings" SET "description" = 'Difference between LDAPv3 and LDAPv2 https://msdn.microsoft.com/en-us/library/windows/desktop/aa366099%28v=vs.85%29.aspx (e.g., 3)' WHERE "name" = 'LDAP_PROTOCOL_VERSION';

UPDATE "settings" SET "description" = 'This is your search base for LDAP queries. This should be at least your domain root, (e.g., dc=domain,dc=local) You can define this as a Organizational Unit if you want to narrow down the search base (e.g., ou=team,ou=company,dc=domain,dc=local)' WHERE "name" = 'LDAP_ROOT_DN';

INSERT INTO "acl_links" ("created", "modified", "name", "url", "method", "slug", "group_id", "is_user_action", "is_guest_action", "is_admin_action", "is_hide")
VALUES (now(), now(), 'User detail', '/users/me', 'GET', 'user_detail', '0', '1', '0', '1', '1');

INSERT INTO "acl_links_roles" ("created", "modified", "acl_link_id", "role_id") SELECT '2016-02-20 19:07:50.849',	'2016-02-20 19:07:50.849', id, 2 FROM acl_links WHERE slug = 'user_detail';

UPDATE "settings" SET "type" = 'password' WHERE "name" = 'IMAP_EMAIL_PASSWORD';

UPDATE "settings" SET "label" = 'Server URL', "description" = 'e.g., http://localhost:9200/' WHERE "name" = 'ELASTICSEARCH_URL';

UPDATE "settings" SET "label" = 'Index Name', "description" = 'Used to prefix index names to avoid potential collisions. e.g., restya' WHERE "name" = 'ELASTICSEARCH_INDEX';

UPDATE "settings" SET "label" = 'Incoming Mail Server' WHERE "name" = 'IMAP_HOST';

UPDATE "settings" SET "description" = 'e.g., 993', "label" = 'Port' WHERE "name" = 'IMAP_PORT';

UPDATE "settings" SET "label" = 'Email address' WHERE "name" = 'IMAP_EMAIL';

UPDATE "settings" SET "label" = 'Password' WHERE "name" = 'IMAP_EMAIL_PASSWORD';

UPDATE "email_templates" SET
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
</h2><p style="white-space: normal; width: 100%;margin: 10px 0px 0px; font-family:Arial, Helvetica, sans-serif;"><br></p><p style="white-space: normal; width: 100%;margin: 0px 0px 0px; font-family:Arial, Helvetica, sans-serif;">You are one step ahead. Please click the below URL to activate your account.<br>##ACTIVATION_URL##<br>If you didn't create a ##SITE_NAME## account and feel this is an error, please contact us at ##CONTACT_EMAIL##.<br></p><br><p style="white-space: normal; width: 100%;margin: 0px 0px 0px;font-family:Arial, Helvetica, sans-serif;">Thanks,<br>
Restyaboard<br>
##SITE_URL##</p>
</pre>
</div>
</div>
</main>
<footer style="width:100%;padding-left:0;margin:0px auto;border-top: solid 1px #dedede; padding-bottom:10px; background:#fff;clear: both;padding-top: 10px;border-bottom: solid 1px #dedede;background-color: #f7f7f7;">
<h6 style="text-align:center;margin:5px 15px;"> 
<a href="http://restya.com/board/?utm_source=Restyaboard ##SITE_NAME##&utm_medium=email&utm_campaign=activation_email" title="Open source. Trello like kanban board." rel="generator" style="font-size: 11px;text-align: center;text-decoration: none;color: #000;font-family: arial; padding-left:10px;">Powered by Restyaboard</a></h6>
</footer>
</body>
</html>'
WHERE "id" = 1;


UPDATE "email_templates" SET
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
<pre style="font-family: Arial, Helvetica, sans-serif; font-size: 13px;line-height:20px;"><h2 style="font-size:16px; font-family:Arial, Helvetica, sans-serif; margin: 20px 0px 0px;padding:10px 0px 0px 0px;">Hi ##NAME##,</h2><p style="white-space: normal; width: 100%;margin: 10px 0px 0px; font-family:Arial, Helvetica, sans-serif;"><br></p><p style="white-space: normal; width: 100%;margin: 0px 0px 0px; font-family:Arial, Helvetica, sans-serif;">We wish to say a quick hello and thanks for registering at ##SITE_NAME##.<br>If you didn't create a ##SITE_NAME## account and feel this is an error, please contact us at ##CONTACT_EMAIL##.<br></p><br><p style="white-space: normal; width: 100%;margin: 0px 0px 0px;font-family:Arial, Helvetica, sans-serif;">Thanks,<br>
Restyaboard<br>
##SITE_URL##</p>
</pre>
</div>
</div>
</main>
<footer style="width:100%;padding-left:0;margin:0px auto;border-top: solid 1px #dedede; padding-bottom:10px; background:#fff;clear: both;padding-top: 10px;border-bottom: solid 1px #dedede;background-color: #f7f7f7;">
<h6 style="text-align:center;margin:5px 15px;"> 
<a href="http://restya.com/board/?utm_source=Restyaboard ##SITE_NAME##&utm_medium=email&utm_campaign=welcome_email" title="Open source. Trello like kanban board." rel="generator" style="font-size: 11px;text-align: center;text-decoration: none;color: #000;font-family: arial; padding-left:10px;">Powered by Restyaboard</a></h6>
</footer>
</body>
</html>'
WHERE "id" = 2;

UPDATE "email_templates" SET
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
<pre style="font-family: Arial, Helvetica, sans-serif; font-size: 13px;line-height:20px;"><h2 style="font-size:16px; font-family:Arial, Helvetica, sans-serif; margin: 20px 0px 0px;padding:10px 0px 0px 0px;">Hi ##NAME##,</h2><p style="white-space: normal; width: 100%;margin: 10px 0px 0px; font-family:Arial, Helvetica, sans-serif;"><br></p><p style="white-space: normal; width: 100%;margin: 0px 0px 0px; font-family:Arial, Helvetica, sans-serif;">We have received a password reset request for your account at ##SITE_NAME##.<br>New password: ##PASSWORD##<br>If you didn't requested this action and feel this is an error, please contact us at ##CONTACT_EMAIL##.<br></p><br><p style="white-space: normal; width: 100%;margin: 0px 0px 0px;font-family:Arial, Helvetica, sans-serif;">Thanks,<br>
Restyaboard<br>
##SITE_URL##</p>
</pre>
</div>
</div>
</main>
<footer style="width:100%;padding-left:0;margin:0px auto;border-top: solid 1px #dedede; padding-bottom:10px; background:#fff;clear: both;padding-top: 10px;border-bottom: solid 1px #dedede;background-color: #f7f7f7;">
<h6 style="text-align:center;margin:5px 15px;"> 
<a href="http://restya.com/board/?utm_source=Restyaboard ##SITE_NAME##&utm_medium=email&utm_campaign=forgetpassword_email" title="Open source. Trello like kanban board." rel="generator" style="font-size: 11px;text-align: center;text-decoration: none;color: #000;font-family: arial; padding-left:10px;">Powered by Restyaboard</a></h6>
</footer>
</body>
</html>'
WHERE "id" = 3;


UPDATE "email_templates" SET
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
<a href="http://restya.com/board/?utm_source=Restyaboard ##SITE_NAME##&utm_medium=email&utm_campaign=changepassword_email" title="Open source. Trello like kanban board." rel="generator" style="font-size: 11px;text-align: center;text-decoration: none;color: #000;font-family: arial; padding-left:10px;">Powered by Restyaboard</a></h6>
</footer>
</body>
</html>'
WHERE "id" = 4;


UPDATE "email_templates" SET
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
<a href="http://restya.com/board/?utm_source=Restyaboard ##SITE_NAME##&utm_medium=email&utm_campaign=newprojectuser_email" title="Open source. Trello like kanban board." rel="generator" style="font-size: 11px;text-align: center;text-decoration: none;color: #000;font-family: arial; padding-left:10px;">Powered by Restyaboard</a></h6>
</footer>
</body>
</html>'
WHERE "id" = 5;

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
<div style="font-family: Arial, Helvetica, sans-serif; font-size: 13px;line-height:20px;margin-top:30px;"><h2 style="font-size:16px; font-family:Arial, Helvetica, sans-serif; margin: 7px 0px 0px 43px;padding:35px 0px 0px 0px;">Here's what you missed…</h2>
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
<a href="http://restya.com/board/?utm_source=Restyaboard ##SITE_NAME##&utm_medium=email&utm_campaign=email_notification_email" title="Open source. Trello like kanban board." rel="generator" style="font-size: 11px;text-align: center;text-decoration: none;color: #000;font-family: arial; padding-left:10px;">Powered by Restyaboard</a>
</h6>
</footer>
</body>
</html>'
WHERE "id" = 6;