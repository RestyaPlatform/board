delete from timezones tz where exists (select name from timezones t where t.name = tz.name and t.id < tz.id);

SELECT pg_catalog.setval('timezones_id_seq', (SELECT MAX(id) FROM timezones), true);