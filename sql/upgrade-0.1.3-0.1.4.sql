UPDATE "email_templates" SET
"from_email" = '##SITE_NAME## Restyaboard ##FROM_EMAIL##',
"subject" = 'Restyaboard / ##SITE_NAME## Account confirmation',
"email_text_content" = 'Hi ##NAME##,

You are one step ahead. Please click the below URL to activate your account.
##ACTIVATION_URL##
If you didn''t create a ##SITE_NAME## account and feel this is an error, please contact us at ##CONTACT_MAIL##.

Thanks,
Restyaboard
##SITE_URL##',
"email_variables" = 'SITE_URL, SITE_NAME, ACTIVATION_URL, NAME' WHERE "id" = '1';

UPDATE "email_templates" SET
"from_email" = '##SITE_NAME## Restyaboard ##FROM_EMAIL##',
"subject" = 'Welcome to Restyaboard / ##SITE_NAME##',
"email_text_content" = 'Hi ##NAME##,

We wish to say a quick hello and thanks for registering at ##SITE_NAME##.

If you didn''t create a ##SITE_NAME## account and feel this is an error, please contact us at ##CONTACT_MAIL##.

Thanks,
Restyaboard
##SITE_URL##',
"email_variables" = 'SITE_NAME, SITE_URL, CONTACT_MAIL, NAME' WHERE "id" = '2';

UPDATE "email_templates" SET
"from_email" = '##SITE_NAME## Restyaboard ##FROM_EMAIL##',
"subject" = 'Restyaboard / [##SITE_NAME##] Password reset',
"email_text_content" = 'Hi ##NAME##,

We have received a password reset request for your account at ##SITE_NAME##.

New password: ##PASSWORD##

If you didn''t requested this action and feel this is an error, please contact us at ##CONTACT_MAIL##.

Thanks,
Restyaboard
##SITE_URL##',
"email_variables" = 'SITE_NAME, SITE_URL, CONTACT_MAIL, PASSWORD, NAME' WHERE "id" = '3';

UPDATE "email_templates" SET
"from_email" = '##SITE_NAME## Restyaboard ##FROM_EMAIL##',
"subject" = 'Restyaboard / ##BOARD_NAME## assigned by ##CURRENT_USER##',
"email_text_content" = 'Hi ##NAME##,

##CURRENT_USER## has added you to the board ##BOARD_NAME## ##BOARD_URL##

Thanks,
Restyaboard
##SITE_URL##',
"email_variables" = 'SITE_NAME, SITE_URL, CONTACT_MAIL, NAME, CURRENT_USER' WHERE "id" = '5';

UPDATE "setting_categories" SET "name" = 'Login' WHERE "id" = '2';

INSERT INTO "setting_categories" ("id", "created", "modified", "parent_id", "name", "description", "order") VALUES ('9', NULL, NULL, '2', 'Enabled Login Options', 'Enabled Login Options', '1');

UPDATE "settings" SET "order" = "order" + 2 WHERE "setting_category_parent_id" = 2 and "id" NOT IN ('3','22');

UPDATE "settings" SET "label" = 'LDAP', "order" = 2, "setting_category_id" = 9 WHERE "id" = '3';

UPDATE "settings" SET "label" = 'Standard', "order" = 1, "setting_category_id" = 9 WHERE "id" = '22';