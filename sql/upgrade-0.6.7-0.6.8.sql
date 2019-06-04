ALTER TABLE "users"
ALTER "is_productivity_beats" TYPE boolean,
ALTER "is_productivity_beats" SET DEFAULT 'true',
ALTER "is_productivity_beats" SET NOT NULL;
UPDATE "users" SET "is_productivity_beats" = '1';
INSERT INTO "settings" ("setting_category_id", "setting_category_parent_id", "name", "value", "description", "type", "options", "label", "order")
VALUES ('17', '0', 'CALENDAR_VIEW_CARD_COLOR', 'Default Color', NULL, 'select', 'Card Color,Label Color,Default Color', 'Calendar View Card Color ', '4')