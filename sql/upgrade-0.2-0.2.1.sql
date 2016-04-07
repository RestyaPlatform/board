UPDATE "settings" SET "name" = 'elasticsearch.last_processed_activity_id' WHERE "name" = 'elasticsearch.last_processed_activtiy_id';
UPDATE settings SET value = replace(value, 'ldap://', '') WHERE name = 'LDAP_SERVER';
UPDATE "settings" SET "name" = 'webhooks.last_processed_activity_id' WHERE "name" = 'webhooks.last_processed_activtiy_id';