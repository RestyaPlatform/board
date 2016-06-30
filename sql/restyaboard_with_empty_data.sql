--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: label_card_count_update(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION label_card_count_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN

	IF (TG_OP = 'DELETE') THEN

		UPDATE "labels" SET "card_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "cards_labels" WHERE "label_id" = OLD."label_id") t WHERE "id" = OLD."label_id";

	        UPDATE "cards" SET "label_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "cards_labels" WHERE "label_id" = OLD."card_id") t WHERE "id" = OLD."card_id";

		RETURN OLD;

	ELSIF (TG_OP = 'UPDATE') THEN

		UPDATE "labels" SET "card_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "cards_labels" WHERE "label_id" = OLD."label_id") t WHERE "id" = OLD."label_id";

	        UPDATE "labels" SET "card_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "cards_labels" WHERE "label_id" = NEW."label_id") t WHERE "id" = NEW."label_id";

		UPDATE "cards" SET "label_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "cards_labels" WHERE "label_id" = OLD."card_id") t WHERE "id" = OLD."card_id";

	        UPDATE "cards" SET "label_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "cards_labels" WHERE "label_id" = NEW."label_id") t WHERE "id" = NEW."card_id";

		RETURN OLD;

	ELSIF (TG_OP = 'INSERT') THEN

		UPDATE "labels" SET "card_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "cards_labels" WHERE "label_id" = NEW."label_id") t WHERE "id" = NEW."label_id";

	        UPDATE "cards" SET "label_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "cards_labels" WHERE "label_id" = NEW."label_id") t WHERE "id" = NEW."card_id";

		RETURN NEW;

	END IF;

END;

$$;


--
-- Name: update_board_count(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION update_board_count() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN

	IF (TG_OP = 'DELETE') THEN

		UPDATE "organizations" SET "board_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "boards" WHERE "organization_id" = OLD."organization_id") t WHERE "id" = OLD."organization_id";

	        UPDATE "users" SET "created_board_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "boards" WHERE "user_id" = OLD."user_id") t WHERE "id" = OLD."user_id";

		RETURN OLD;

	ELSIF (TG_OP = 'UPDATE') THEN

		UPDATE "organizations" SET "board_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "boards" WHERE "organization_id" = OLD."organization_id") t WHERE "id" = OLD."organization_id";

		UPDATE "organizations" SET "board_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "boards" WHERE "organization_id" = NEW."organization_id") t WHERE "id" = NEW."organization_id";

	        UPDATE "users" SET "created_board_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "boards" WHERE "user_id" = OLD."user_id") t WHERE "id" = OLD."user_id";

	        UPDATE "users" SET "created_board_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "boards" WHERE "user_id" = NEW."user_id") t WHERE "id" = NEW."user_id";

		RETURN OLD;

	ELSIF (TG_OP = 'INSERT') THEN

		UPDATE "organizations" SET "board_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "boards" WHERE "organization_id" = NEW."organization_id") t WHERE "id" = NEW."organization_id";

	         UPDATE "users" SET "created_board_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "boards" WHERE "user_id" = NEW."user_id") t WHERE "id" = NEW."user_id";

		RETURN NEW;

	END IF;

END;

$$;


--
-- Name: update_board_star_count(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION update_board_star_count() RETURNS trigger
    LANGUAGE plpgsql
    AS $$


BEGIN


	IF (TG_OP = 'DELETE') THEN


		UPDATE "boards" SET "boards_star_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "board_stars" WHERE "board_id" = OLD."board_id") t WHERE "id" = OLD."board_id";


		RETURN OLD;


	ELSIF (TG_OP = 'UPDATE') THEN


		UPDATE "boards" SET "boards_star_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "board_stars" WHERE "board_id" = OLD."board_id") t WHERE "id" = OLD."board_id";


		UPDATE "boards" SET "boards_star_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "board_stars" WHERE "board_id" = NEW."board_id") t WHERE "id" = NEW."board_id";


		RETURN OLD;


	ELSIF (TG_OP = 'INSERT') THEN


		UPDATE "boards" SET "boards_star_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "board_stars" WHERE "board_id" = NEW."board_id") t WHERE "id" = NEW."board_id";


		RETURN NEW;


	END IF;


END;


$$;


--
-- Name: update_board_subscriber_count(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION update_board_subscriber_count() RETURNS trigger
    LANGUAGE plpgsql
    AS $$


BEGIN


	IF (TG_OP = 'DELETE') THEN


		UPDATE "boards" SET "boards_subscriber_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "board_subscribers" WHERE "board_id" = OLD."board_id") t WHERE "id" = OLD."board_id";


		RETURN OLD;


	ELSIF (TG_OP = 'UPDATE') THEN


		UPDATE "boards" SET "boards_subscriber_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "board_subscribers" WHERE "board_id" = OLD."board_id") t WHERE "id" = OLD."board_id";


		UPDATE "boards" SET "boards_subscriber_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "board_subscribers" WHERE "board_id" = NEW."board_id") t WHERE "id" = NEW."board_id";


		RETURN OLD;


	ELSIF (TG_OP = 'INSERT') THEN


		UPDATE "boards" SET "boards_subscriber_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "board_subscribers" WHERE "board_id" = NEW."board_id") t WHERE "id" = NEW."board_id";


		RETURN NEW;


	END IF;


END;


$$;


--
-- Name: update_board_user_count(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION update_board_user_count() RETURNS trigger
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


--
-- Name: update_card_activity_count(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION update_card_activity_count() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN

	IF (TG_OP = 'DELETE') THEN

		UPDATE "cards" SET "activity_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "activities" WHERE "card_id" = OLD."card_id") t WHERE "id" = OLD."card_id";

	        UPDATE "users" SET "activity_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "activities" WHERE "user_id" = OLD."user_id") t WHERE "id" = OLD."user_id";

		RETURN OLD;

	ELSIF (TG_OP = 'UPDATE') THEN

		UPDATE "cards" SET "activity_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "activities" WHERE "card_id" = OLD."card_id") t WHERE "id" = OLD."card_id";

		UPDATE "cards" SET "activity_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "activities" WHERE "card_id" = NEW."card_id") t WHERE "id" = NEW."card_id";

	        UPDATE "users" SET "activity_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "activities" WHERE "user_id" = OLD."user_id") t WHERE "id" = OLD."user_id";

	        UPDATE "users" SET "activity_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "activities" WHERE "user_id" = NEW."user_id") t WHERE "id" = NEW."user_id";

		RETURN OLD;

	ELSIF (TG_OP = 'INSERT') THEN

		UPDATE "cards" SET "activity_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "activities" WHERE "card_id" = NEW."card_id") t WHERE "id" = NEW."card_id";

	        UPDATE "users" SET "activity_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "activities" WHERE "user_id" = NEW."user_id") t WHERE "id" = NEW."user_id";

		RETURN NEW;

	END IF;

END;

$$;


--
-- Name: update_card_attachment_count(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION update_card_attachment_count() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN

	IF (TG_OP = 'DELETE') THEN

		UPDATE "cards" SET "attachment_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "card_attachments" WHERE "card_id" = OLD."card_id") t WHERE "id" = OLD."card_id";

		RETURN OLD;

	ELSIF (TG_OP = 'UPDATE') THEN

		UPDATE "cards" SET "attachment_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "card_attachments" WHERE "card_id" = OLD."card_id") t WHERE "id" = OLD."card_id";

		UPDATE "cards" SET "attachment_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "card_attachments" WHERE "card_id" = NEW."card_id") t WHERE "id" = NEW."card_id";

		RETURN OLD;

	ELSIF (TG_OP = 'INSERT') THEN

		UPDATE "cards" SET "attachment_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "card_attachments" WHERE "card_id" = NEW."card_id") t WHERE "id" = NEW."card_id";

		RETURN NEW;

	END IF;

END;

$$;


--
-- Name: update_card_checklist_count(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION update_card_checklist_count() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN

	IF (TG_OP = 'DELETE') THEN

		UPDATE "cards" SET "checklist_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "checklists" WHERE "card_id" = OLD."card_id") t WHERE "id" = OLD."card_id";

	        UPDATE "users" SET "checklist_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "checklists" WHERE "user_id" = OLD."user_id") t WHERE "id" = OLD."user_id";

		RETURN OLD;

	ELSIF (TG_OP = 'UPDATE') THEN

		UPDATE "cards" SET "checklist_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "checklists" WHERE "card_id" = OLD."card_id") t WHERE "id" = OLD."card_id";

		UPDATE "cards" SET "checklist_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "checklists" WHERE "card_id" = NEW."card_id") t WHERE "id" = NEW."card_id";

	        UPDATE "users" SET "checklist_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "checklists" WHERE "user_id" = OLD."user_id") t WHERE "id" = OLD."user_id";

		UPDATE "users" SET "checklist_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "checklists" WHERE "user_id" = NEW."user_id") t WHERE "id" = NEW."user_id";

		RETURN OLD;

	ELSIF (TG_OP = 'INSERT') THEN

		UPDATE "cards" SET "checklist_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "checklists" WHERE "card_id" = NEW."card_id") t WHERE "id" = NEW."card_id";

	        UPDATE "users" SET "checklist_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "checklists" WHERE "user_id" = NEW."user_id") t WHERE "id" = NEW."user_id";

		RETURN NEW;

	END IF;

END;

$$;


--
-- Name: update_card_checklist_item_count(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION update_card_checklist_item_count() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN

	IF (TG_OP = 'DELETE') THEN

		UPDATE "cards" SET "checklist_item_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "checklist_items" WHERE "card_id" = OLD."card_id") t WHERE "id" = OLD."card_id";

	        UPDATE "cards" SET "checklist_item_completed_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "checklist_items" WHERE "card_id" = OLD."card_id" AND "is_completed" = TRUE) t WHERE "id" = OLD."card_id";

		UPDATE "checklists" SET "checklist_item_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "checklist_items" WHERE "checklist_id" = OLD."checklist_id") t WHERE "id" = OLD."checklist_id";

	        UPDATE "checklists" SET "checklist_item_completed_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "checklist_items" WHERE "checklist_id" = OLD."checklist_id" AND "is_completed" = TRUE) t WHERE "id" = OLD."checklist_id";

	        UPDATE "users" SET "checklist_item_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "checklist_items" WHERE "user_id" = OLD."user_id") t WHERE "id" = OLD."user_id";

	        UPDATE "users" SET "checklist_item_completed_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "checklist_items" WHERE "user_id" = OLD."user_id" AND "is_completed" = TRUE) t WHERE "id" = OLD."user_id";

		RETURN OLD;

	ELSIF (TG_OP = 'UPDATE') THEN

		UPDATE "cards" SET "checklist_item_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "checklist_items" WHERE "card_id" = OLD."card_id") t WHERE "id" = OLD."card_id";

	        UPDATE "cards" SET "checklist_item_completed_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "checklist_items" WHERE "card_id" = OLD."card_id" AND "is_completed" = TRUE) t WHERE "id" = OLD."card_id";

		UPDATE "cards" SET "checklist_item_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "checklist_items" WHERE "card_id" = NEW."card_id") t WHERE "id" = NEW."card_id";

	        UPDATE "cards" SET "checklist_item_completed_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "checklist_items" WHERE "card_id" = NEW."card_id" AND "is_completed" = TRUE) t WHERE "id" = NEW."card_id";

	        UPDATE "checklists" SET "checklist_item_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "checklist_items" WHERE "checklist_id" = OLD."checklist_id") t WHERE "id" = OLD."checklist_id";

	        UPDATE "checklists" SET "checklist_item_completed_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "checklist_items" WHERE "checklist_id" = OLD."checklist_id" AND "is_completed" = TRUE) t WHERE "id" = OLD."checklist_id";

		UPDATE "checklists" SET "checklist_item_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "checklist_items" WHERE "checklist_id" = NEW."checklist_id") t WHERE "id" = NEW."checklist_id";

	        UPDATE "checklists" SET "checklist_item_completed_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "checklist_items" WHERE "checklist_id" = NEW."checklist_id" AND "is_completed" = TRUE) t WHERE "id" = NEW."checklist_id";

	         UPDATE "users" SET "checklist_item_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "checklist_items" WHERE "user_id" = OLD."user_id") t WHERE "id" = OLD."user_id";

	        UPDATE "users" SET "checklist_item_completed_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "checklist_items" WHERE "user_id" = OLD."user_id" AND "is_completed" = TRUE) t WHERE "id" = OLD."user_id";

	        UPDATE "users" SET "checklist_item_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "checklist_items" WHERE "user_id" = NEW."user_id") t WHERE "id" = NEW."user_id";

	        UPDATE "users" SET "checklist_item_completed_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "checklist_items" WHERE "user_id" = NEW."user_id" AND "is_completed" = TRUE) t WHERE "id" = NEW."user_id";

		RETURN NEW;

	ELSIF (TG_OP = 'INSERT') THEN

		UPDATE "cards" SET "checklist_item_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "checklist_items" WHERE "card_id" = NEW."card_id") t WHERE "id" = NEW."card_id";

	        UPDATE "cards" SET "checklist_item_completed_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "checklist_items" WHERE "card_id" = NEW."card_id" AND "is_completed" = TRUE) t WHERE "id" = NEW."card_id";

	        UPDATE "checklists" SET "checklist_item_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "checklist_items" WHERE "checklist_id" = NEW."checklist_id") t WHERE "id" = NEW."checklist_id";

	        UPDATE "checklists" SET "checklist_item_completed_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "checklist_items" WHERE "checklist_id" = NEW."checklist_id" AND "is_completed" = TRUE) t WHERE "id" = NEW."checklist_id";

	        UPDATE "users" SET "checklist_item_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "checklist_items" WHERE "user_id" = NEW."user_id") t WHERE "id" = NEW."user_id";

	        UPDATE "users" SET "checklist_item_completed_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "checklist_items" WHERE "user_id" = NEW."user_id" AND "is_completed" = TRUE) t WHERE "id" = NEW."user_id";

		RETURN NEW;

	END IF;

END;

$$;


--
-- Name: update_card_count(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION update_card_count() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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


--
-- Name: update_card_subscriber_count(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION update_card_subscriber_count() RETURNS trigger
    LANGUAGE plpgsql
    AS $$


BEGIN


	IF (TG_OP = 'DELETE') THEN


		UPDATE "cards" SET "cards_subscriber_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "card_subscribers" WHERE "card_id" = OLD."card_id") t WHERE "id" = OLD."card_id";


		RETURN OLD;


	ELSIF (TG_OP = 'UPDATE') THEN


		UPDATE "cards" SET "cards_subscriber_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "card_subscribers" WHERE "card_id" = OLD."card_id") t WHERE "id" = OLD."card_id";


		UPDATE "cards" SET "cards_subscriber_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "card_subscribers" WHERE "card_id" = NEW."card_id") t WHERE "id" = NEW."card_id";


		RETURN OLD;


	ELSIF (TG_OP = 'INSERT') THEN


		UPDATE "cards" SET "cards_subscriber_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "card_subscribers" WHERE "card_id" = NEW."card_id") t WHERE "id" = NEW."card_id";


		RETURN NEW;


	END IF;


END;


$$;


--
-- Name: update_card_user_count(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION update_card_user_count() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN

	IF (TG_OP = 'DELETE') THEN

		UPDATE "cards" SET "cards_user_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "cards_users" WHERE "card_id" = OLD."card_id") t WHERE "id" = OLD."card_id";

	        UPDATE "users" SET "joined_card_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "cards_users" WHERE "user_id" = OLD."user_id") t WHERE "id" = OLD."user_id";

		RETURN OLD;

	ELSIF (TG_OP = 'UPDATE') THEN

		UPDATE "cards" SET "cards_user_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "cards_users" WHERE "card_id" = OLD."card_id") t WHERE "id" = OLD."card_id";

		UPDATE "cards" SET "cards_user_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "cards_users" WHERE "card_id" = NEW."card_id") t WHERE "id" = NEW."card_id";

		UPDATE "users" SET "joined_card_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "cards_users" WHERE "user_id" = OLD."user_id") t WHERE "id" = OLD."user_id";

		UPDATE "users" SET "joined_card_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "cards_users" WHERE "user_id" = NEW."user_id") t WHERE "id" = NEW."user_id";

		RETURN OLD;

	ELSIF (TG_OP = 'INSERT') THEN

		UPDATE "cards" SET "cards_user_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "cards_users" WHERE "card_id" = NEW."card_id") t WHERE "id" = NEW."card_id";

		UPDATE "users" SET "joined_card_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "cards_users" WHERE "user_id" = NEW."user_id") t WHERE "id" = NEW."user_id";

		RETURN NEW;

	END IF;

END;

$$;


--
-- Name: update_card_voters_count(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION update_card_voters_count() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN

	IF (TG_OP = 'DELETE') THEN

		UPDATE "cards" SET "card_voter_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "card_voters" WHERE "card_id" = OLD."card_id") t WHERE "id" = OLD."card_id";

		UPDATE "users" SET "card_voter_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "card_voters" WHERE "user_id" = OLD."user_id") t WHERE "id" = OLD."user_id";

		RETURN OLD;

	ELSIF (TG_OP = 'UPDATE') THEN

		UPDATE "cards" SET "card_voter_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "card_voters" WHERE "card_id" = OLD."card_id") t WHERE "id" = OLD."card_id";

		UPDATE "cards" SET "card_voter_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "card_voters" WHERE "card_id" = NEW."card_id") t WHERE "id" = NEW."card_id";

		UPDATE "users" SET "card_voter_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "card_voters" WHERE "user_id" = OLD."user_id") t WHERE "id" = OLD."user_id";

		UPDATE "users" SET "card_voter_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "card_voters" WHERE "user_id" = NEW."user_id") t WHERE "id" = NEW."user_id";

		RETURN OLD;

	ELSIF (TG_OP = 'INSERT') THEN

		UPDATE "cards" SET "card_voter_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "card_voters" WHERE "card_id" = NEW."card_id") t WHERE "id" = NEW."card_id";

		UPDATE "users" SET "card_voter_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "card_voters" WHERE "user_id" = NEW."user_id") t WHERE "id" = NEW."user_id";

		RETURN NEW;

	END IF;

END;

$$;


--
-- Name: update_comment_count(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION update_comment_count() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN

	IF (TG_OP = 'DELETE') THEN

		UPDATE "cards" SET "comment_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "activities" WHERE "type" = 'add_comment' AND "card_id" = OLD."card_id") t WHERE "id" = OLD."card_id";

		RETURN OLD;

	ELSIF (TG_OP = 'UPDATE') THEN

		UPDATE "cards" SET "comment_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "activities" WHERE "type" = 'add_comment' AND "card_id" = OLD."card_id") t WHERE "id" = OLD."card_id";

		UPDATE "cards" SET "comment_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "activities" WHERE "type" = 'add_comment' AND "card_id" = NEW."card_id") t WHERE "id" = NEW."card_id";

		RETURN OLD;

	ELSIF (TG_OP = 'INSERT') THEN

		UPDATE "cards" SET "comment_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "activities" WHERE "type" = 'add_comment' AND "card_id" = NEW."card_id") t WHERE "id" = NEW."card_id";

		RETURN NEW;

	END IF;

END;

$$;


--
-- Name: update_list_count(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION update_list_count() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF (TG_OP = 'DELETE') THEN
		UPDATE "boards" SET "list_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "lists" WHERE "board_id" = OLD."board_id") t WHERE "id" = OLD."board_id";
		UPDATE "users" SET "list_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "lists" WHERE "user_id" = OLD."user_id") t WHERE "id" = OLD."user_id";
		RETURN OLD;
	ELSIF (TG_OP = 'UPDATE') THEN
		UPDATE "boards" SET "list_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "lists" WHERE  "board_id" = OLD."board_id") t WHERE "id" = OLD."board_id";
		UPDATE "boards" SET "archived_list_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "lists" WHERE  "board_id" = NEW."board_id" AND "is_archived" = true) t WHERE "id" = NEW."board_id";
		UPDATE "users" SET "list_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "lists" WHERE "user_id" = OLD."user_id") t WHERE "id" = OLD."user_id";
		RETURN OLD;
	ELSIF (TG_OP = 'INSERT') THEN
		UPDATE "boards" SET "list_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "lists" WHERE "board_id" = NEW."board_id") t WHERE "id" = NEW."board_id";
		UPDATE "users" SET "list_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "lists" WHERE "user_id" = NEW."user_id") t WHERE "id" = NEW."user_id";
		RETURN NEW;
	END IF;
END;
$$;


--
-- Name: update_list_subscriber_count(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION update_list_subscriber_count() RETURNS trigger
    LANGUAGE plpgsql
    AS $$


BEGIN


	IF (TG_OP = 'DELETE') THEN


		UPDATE "lists" SET "lists_subscriber_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "list_subscribers" WHERE "list_id" = OLD."list_id") t WHERE "id" = OLD."list_id";


		RETURN OLD;


	ELSIF (TG_OP = 'UPDATE') THEN


		UPDATE "lists" SET "lists_subscriber_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "list_subscribers" WHERE "list_id" = OLD."list_id") t WHERE "id" = OLD."list_id";


		UPDATE "lists" SET "lists_subscriber_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "list_subscribers" WHERE "list_id" = NEW."list_id") t WHERE "id" = NEW."list_id";


		RETURN OLD;


	ELSIF (TG_OP = 'INSERT') THEN


		UPDATE "lists" SET "lists_subscriber_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "list_subscribers" WHERE "list_id" = NEW."list_id") t WHERE "id" = NEW."list_id";


		RETURN NEW;


	END IF;


END;


$$;


--
-- Name: update_organization_count(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION update_organization_count() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN

	IF (TG_OP = 'DELETE') THEN

		UPDATE "users" SET "created_organization_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "organizations" WHERE "user_id" = OLD."user_id") t WHERE "id" = OLD."user_id";

		RETURN OLD;

	ELSIF (TG_OP = 'UPDATE') THEN

		UPDATE "users" SET "created_organization_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "organizations" WHERE "user_id" = OLD."user_id") t WHERE "id" = OLD."user_id";

		UPDATE "users" SET "created_organization_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "organizations" WHERE "user_id" = NEW."user_id") t WHERE "id" = NEW."user_id";

		RETURN OLD;

	ELSIF (TG_OP = 'INSERT') THEN

		UPDATE "users" SET "created_organization_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "organizations" WHERE "user_id" = NEW."user_id") t WHERE "id" = NEW."user_id";

		RETURN NEW;

	END IF;

END;

$$;


--
-- Name: update_organization_user_count(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION update_organization_user_count() RETURNS trigger
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


--
-- Name: update_user_delete(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION update_user_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$


BEGIN


	IF (TG_OP = 'DELETE') THEN


		DELETE FROM "organizations_users" WHERE "user_id" = OLD."id";


		DELETE FROM "boards_users" WHERE "user_id" = OLD."id";


		DELETE FROM "cards_users" WHERE "user_id" = OLD."id";


		DELETE FROM "card_voters" WHERE "user_id" = OLD."id";


		RETURN OLD;


	END IF;


END;


$$;


--
-- Name: update_users_user_login_count(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION update_users_user_login_count() RETURNS trigger
    LANGUAGE plpgsql
    AS $$


BEGIN


	IF (TG_OP = 'DELETE') THEN


		UPDATE "users" SET "user_login_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "user_logins" WHERE "user_id" = OLD."user_id") t WHERE "id" = OLD."user_id";


		RETURN OLD;


    ELSIF (TG_OP = 'UPDATE') THEN


		UPDATE "users" SET "user_login_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "user_logins" WHERE "user_id" = OLD."user_id") t WHERE "id" = OLD."user_id";


		RETURN OLD;


		RETURN NEW;


	ELSIF (TG_OP = 'INSERT') THEN


		UPDATE "users" SET "user_login_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "user_logins" WHERE "user_id" = NEW."user_id") t WHERE "id" = NEW."user_id";


		RETURN NEW;


	END IF;


END;


$$;


--
-- Name: acl_board_links_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE acl_board_links_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: acl_board_links; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

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


--
-- Name: acl_board_links_boards_user_roles_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE acl_board_links_boards_user_roles_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: acl_board_links_boards_user_roles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE acl_board_links_boards_user_roles (
    id bigint DEFAULT nextval('acl_board_links_boards_user_roles_seq'::regclass) NOT NULL,
    created timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    acl_board_link_id bigint NOT NULL,
    board_user_role_id bigint NOT NULL
);


--
-- Name: acl_board_links_listing; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW acl_board_links_listing AS
 SELECT ablbur.board_user_role_id,
    abl.slug,
    abl.url,
    abl.method
   FROM (acl_board_links_boards_user_roles ablbur
     JOIN acl_board_links abl ON ((abl.id = ablbur.acl_board_link_id)));


--
-- Name: acl_links_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE acl_links_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: acl_links; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

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


--
-- Name: acl_links_roles_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE acl_links_roles_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: acl_links_roles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE acl_links_roles (
    id bigint DEFAULT nextval('acl_links_roles_roles_id_seq'::regclass) NOT NULL,
    created timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    acl_link_id bigint NOT NULL,
    role_id bigint NOT NULL
);


--
-- Name: acl_links_listing; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW acl_links_listing AS
 SELECT aclr.role_id,
    acl.slug,
    acl.url,
    acl.method
   FROM (acl_links_roles aclr
     JOIN acl_links acl ON ((acl.id = aclr.acl_link_id)));


--
-- Name: acl_organization_links_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE acl_organization_links_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: acl_organization_links; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

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


--
-- Name: acl_organization_links_organizations_user_roles_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE acl_organization_links_organizations_user_roles_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: acl_organization_links_organizations_user_roles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE acl_organization_links_organizations_user_roles (
    id bigint DEFAULT nextval('acl_organization_links_organizations_user_roles_seq'::regclass) NOT NULL,
    created timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    acl_organization_link_id bigint NOT NULL,
    organization_user_role_id bigint NOT NULL
);


--
-- Name: acl_organization_links_listing; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW acl_organization_links_listing AS
 SELECT aolour.organization_user_role_id,
    aol.slug,
    aol.url,
    aol.method
   FROM (acl_organization_links_organizations_user_roles aolour
     JOIN acl_organization_links aol ON ((aol.id = aolour.acl_organization_link_id)));


--
-- Name: activities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE activities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: activities; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE activities (
    id bigint DEFAULT nextval('activities_id_seq'::regclass) NOT NULL,
    created timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    board_id bigint DEFAULT 0,
    list_id bigint DEFAULT 0,
    card_id bigint DEFAULT 0,
    user_id bigint NOT NULL,
    foreign_id bigint,
    type character varying(255) NOT NULL,
    comment text NOT NULL,
    revisions text,
    root bigint DEFAULT 0,
    freshness_ts timestamp without time zone,
    depth integer DEFAULT 0,
    path text,
    materialized_path character varying(255) DEFAULT NULL::character varying,
    organization_id bigint DEFAULT (0)::bigint
);


--
-- Name: boards_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE boards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: boards; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE boards (
    id bigint DEFAULT nextval('boards_id_seq'::regclass) NOT NULL,
    created timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    user_id bigint NOT NULL,
    organization_id bigint DEFAULT 0,
    name text NOT NULL,
    board_visibility smallint,
    background_color character varying(255),
    background_picture_url text,
    commenting_permissions smallint,
    voting_permissions smallint,
    inivitation_permissions smallint,
    is_closed boolean DEFAULT false NOT NULL,
    is_allow_organization_members_to_join boolean DEFAULT false NOT NULL,
    boards_user_count bigint DEFAULT 0,
    list_count bigint DEFAULT 0,
    card_count bigint DEFAULT 0,
    boards_subscriber_count bigint DEFAULT 0,
    background_pattern_url character varying(255),
    boards_star_count bigint DEFAULT 0,
    is_show_image_front_of_card boolean DEFAULT true,
    background_picture_path character varying(255),
    music_name character varying(255),
    music_content text,
    archived_list_count bigint DEFAULT (0)::bigint,
    archived_card_count bigint DEFAULT (0)::bigint,
    default_email_list_id bigint DEFAULT (0)::bigint NOT NULL,
    is_default_email_position_as_bottom boolean DEFAULT false NOT NULL,
    custom_fields text,
    CONSTRAINT name CHECK ((char_length(name) > 0))
);


--
-- Name: cards_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE cards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cards; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE cards (
    id bigint DEFAULT nextval('cards_id_seq'::regclass) NOT NULL,
    created timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    board_id bigint NOT NULL,
    list_id bigint NOT NULL,
    name text NOT NULL,
    description text,
    due_date timestamp without time zone,
    "position" double precision NOT NULL,
    is_archived boolean DEFAULT false NOT NULL,
    attachment_count bigint DEFAULT 0,
    checklist_count bigint DEFAULT 0,
    checklist_item_count bigint DEFAULT 0,
    checklist_item_completed_count bigint DEFAULT 0,
    label_count bigint DEFAULT 0,
    cards_user_count bigint DEFAULT 0,
    cards_subscriber_count bigint DEFAULT 0,
    card_voter_count bigint DEFAULT 0,
    activity_count bigint DEFAULT 0,
    user_id bigint NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    comment_count bigint DEFAULT (0)::bigint,
    custom_fields text,
    CONSTRAINT name CHECK ((char_length(name) > 0))
);


--
-- Name: checklist_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE checklist_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: checklist_items; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE checklist_items (
    id bigint DEFAULT nextval('checklist_items_id_seq'::regclass) NOT NULL,
    created timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    user_id bigint NOT NULL,
    card_id bigint NOT NULL,
    checklist_id bigint NOT NULL,
    name text NOT NULL,
    is_completed boolean DEFAULT false NOT NULL,
    "position" double precision NOT NULL,
    CONSTRAINT name CHECK ((char_length(name) > 0))
);


--
-- Name: checklists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE checklists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: checklists; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE checklists (
    id bigint DEFAULT nextval('checklists_id_seq'::regclass) NOT NULL,
    created timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    user_id bigint NOT NULL,
    card_id bigint NOT NULL,
    name character varying(255) NOT NULL,
    checklist_item_count bigint DEFAULT 0,
    checklist_item_completed_count bigint DEFAULT 0,
    "position" double precision NOT NULL,
    CONSTRAINT name CHECK ((char_length((name)::text) > 0))
);


--
-- Name: labels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE labels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: labels; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE labels (
    id bigint DEFAULT nextval('labels_id_seq'::regclass) NOT NULL,
    created timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    name character varying(255) NOT NULL,
    card_count bigint DEFAULT 0 NOT NULL,
    CONSTRAINT name CHECK ((char_length((name)::text) > 0))
);


--
-- Name: lists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE lists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lists; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE lists (
    id bigint DEFAULT nextval('lists_id_seq'::regclass) NOT NULL,
    created timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    board_id bigint NOT NULL,
    user_id bigint NOT NULL,
    name character varying(255) NOT NULL,
    "position" double precision NOT NULL,
    is_archived boolean DEFAULT false NOT NULL,
    card_count bigint DEFAULT 0,
    lists_subscriber_count bigint DEFAULT 0,
    is_deleted boolean DEFAULT false NOT NULL,
    custom_fields text,
    CONSTRAINT name CHECK ((char_length((name)::text) > 0))
);


--
-- Name: organizations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE organizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organizations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE organizations (
    id bigint DEFAULT nextval('organizations_id_seq'::regclass) NOT NULL,
    created timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    user_id bigint NOT NULL,
    name character varying(255) NOT NULL,
    website_url character varying(255),
    description text,
    logo_url character varying(255),
    organization_visibility smallint DEFAULT 1,
    organizations_user_count bigint DEFAULT 0,
    board_count bigint DEFAULT 0,
    CONSTRAINT name CHECK ((char_length((name)::text) > 0))
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 2
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id bigint DEFAULT nextval('users_id_seq'::regclass) NOT NULL,
    created timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    role_id integer DEFAULT 0 NOT NULL,
    username character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    full_name character varying(255),
    initials character varying(10),
    about_me text,
    profile_picture_path character varying(255),
    notification_frequency smallint,
    is_allow_desktop_notification boolean DEFAULT false NOT NULL,
    is_active boolean DEFAULT false NOT NULL,
    is_email_confirmed boolean DEFAULT false NOT NULL,
    created_organization_count bigint DEFAULT 0,
    created_board_count bigint DEFAULT 0,
    joined_organization_count bigint DEFAULT 0,
    list_count bigint DEFAULT 0,
    joined_card_count bigint DEFAULT 0,
    created_card_count bigint DEFAULT 0,
    joined_board_count bigint DEFAULT 0,
    checklist_count bigint DEFAULT 0,
    checklist_item_completed_count bigint DEFAULT 0,
    checklist_item_count bigint DEFAULT 0,
    activity_count bigint DEFAULT 0,
    card_voter_count bigint DEFAULT 0,
    last_activity_id bigint DEFAULT (0)::bigint NOT NULL,
    last_login_date timestamp without time zone,
    last_login_ip_id bigint,
    ip_id bigint,
    login_type_id smallint,
    is_productivity_beats boolean DEFAULT false NOT NULL,
    user_login_count bigint DEFAULT (0)::bigint NOT NULL,
    is_ldap boolean DEFAULT false NOT NULL,
    is_send_newsletter smallint DEFAULT (2)::smallint,
    last_email_notified_activity_id bigint DEFAULT (0)::bigint,
    owner_board_count bigint DEFAULT (0)::bigint,
    member_board_count bigint DEFAULT (0)::bigint,
    owner_organization_count bigint DEFAULT (0)::bigint,
    member_organization_count bigint DEFAULT (0)::bigint,
    language character varying(10),
    timezone character varying,
    CONSTRAINT password CHECK ((char_length((password)::text) > 0)),
    CONSTRAINT username CHECK ((char_length((username)::text) > 0))
);


--
-- Name: activities_listing; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW activities_listing AS
 SELECT activity.id,
    to_char(activity.created, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS created,
    to_char(activity.modified, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS modified,
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
    organizations.logo_url AS organization_logo_url,
    list1.name AS moved_list_name,
    to_char(activity.created, 'HH24:MI'::text) AS created_time
   FROM ((((((((((activities activity
     LEFT JOIN boards board ON ((board.id = activity.board_id)))
     LEFT JOIN lists list ON ((list.id = activity.list_id)))
     LEFT JOIN lists list1 ON ((list1.id = activity.foreign_id)))
     LEFT JOIN cards card ON ((card.id = activity.card_id)))
     LEFT JOIN labels la ON (((la.id = activity.foreign_id) AND ((activity.type)::text = 'add_card_label'::text))))
     LEFT JOIN checklist_items checklist_item ON ((checklist_item.id = activity.foreign_id)))
     LEFT JOIN checklists checklist ON ((checklist.id = checklist_item.checklist_id)))
     LEFT JOIN checklists checklist1 ON ((checklist1.id = activity.foreign_id)))
     LEFT JOIN users users ON ((users.id = activity.user_id)))
     LEFT JOIN organizations organizations ON ((organizations.id = activity.organization_id)));


--
-- Name: boards_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE boards_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: boards_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE boards_users (
    id bigint DEFAULT nextval('boards_users_id_seq'::regclass) NOT NULL,
    created timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    board_id bigint NOT NULL,
    user_id bigint NOT NULL,
    board_user_role_id smallint DEFAULT (0)::smallint NOT NULL
);


--
-- Name: boards_users_listing; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW boards_users_listing AS
 SELECT bu.id,
    to_char(bu.created, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS created,
    to_char(bu.modified, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS modified,
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


--
-- Name: admin_boards_listing; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW admin_boards_listing AS
 SELECT board.id,
    board.name,
    to_char(board.created, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS created,
    to_char(board.modified, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS modified,
    users.username,
    users.full_name,
    users.profile_picture_path,
    users.initials,
    board.user_id,
    board.organization_id,
    board.board_visibility,
    board.background_color,
    board.background_picture_url,
    (board.is_closed)::integer AS is_closed,
    board.boards_user_count,
    board.list_count,
    board.card_count,
    board.archived_list_count,
    board.archived_card_count,
    board.boards_subscriber_count,
    board.background_pattern_url,
    board.music_name,
    organizations.name AS organization_name,
    organizations.website_url AS organization_website_url,
    organizations.description AS organization_description,
    organizations.logo_url AS organization_logo_url,
    organizations.organization_visibility,
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


--
-- Name: attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE attachments_id_seq
    START WITH 2
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: boards_stars_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE boards_stars_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: board_stars; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE board_stars (
    id bigint DEFAULT nextval('boards_stars_id_seq'::regclass) NOT NULL,
    created timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    board_id bigint NOT NULL,
    user_id bigint NOT NULL,
    is_starred boolean NOT NULL
);


--
-- Name: boards_subscribers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE boards_subscribers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: board_subscribers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE board_subscribers (
    id bigint DEFAULT nextval('boards_subscribers_id_seq'::regclass) NOT NULL,
    created timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    board_id bigint NOT NULL,
    user_id bigint NOT NULL,
    is_subscribed boolean NOT NULL
);


--
-- Name: board_user_roles_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE board_user_roles_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: board_user_roles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE board_user_roles (
    id bigint DEFAULT nextval('board_user_roles_seq'::regclass) NOT NULL,
    created timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    name character varying(255) NOT NULL,
    description character varying
);


--
-- Name: cards_labels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE cards_labels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cards_labels; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE cards_labels (
    id bigint DEFAULT nextval('cards_labels_id_seq'::regclass) NOT NULL,
    created timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    label_id bigint NOT NULL,
    card_id bigint NOT NULL,
    list_id bigint,
    board_id bigint
);


--
-- Name: boards_labels_listing; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW boards_labels_listing AS
 SELECT cards_labels.id,
    to_char(cards_labels.created, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS created,
    to_char(cards_labels.modified, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS modified,
    cards_labels.label_id,
    cards_labels.card_id,
    cards_labels.list_id,
    cards_labels.board_id,
    labels.name
   FROM (cards_labels cards_labels
     LEFT JOIN labels labels ON ((labels.id = cards_labels.label_id)));


--
-- Name: card_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE card_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: card_attachments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE card_attachments (
    id bigint DEFAULT nextval('card_attachments_id_seq'::regclass) NOT NULL,
    created timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    card_id bigint,
    name character varying(255) NOT NULL,
    path character varying(255) NOT NULL,
    list_id bigint,
    board_id bigint DEFAULT 1,
    mimetype character varying(255),
    link character varying(255)
);


--
-- Name: cards_subscribers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE cards_subscribers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: card_subscribers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE card_subscribers (
    id bigint DEFAULT nextval('cards_subscribers_id_seq'::regclass) NOT NULL,
    created timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    card_id bigint NOT NULL,
    user_id bigint NOT NULL,
    is_subscribed boolean NOT NULL
);


--
-- Name: card_voters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE card_voters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: card_voters; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE card_voters (
    id bigint DEFAULT nextval('card_voters_id_seq'::regclass) NOT NULL,
    created timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    card_id bigint NOT NULL,
    user_id bigint NOT NULL
);


--
-- Name: card_voters_listing; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW card_voters_listing AS
 SELECT card_voters.id,
    to_char(card_voters.created, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS created,
    to_char(card_voters.modified, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS modified,
    card_voters.user_id,
    card_voters.card_id,
    users.username,
    users.role_id,
    users.profile_picture_path,
    users.initials,
    users.full_name
   FROM (card_voters card_voters
     LEFT JOIN users users ON ((users.id = card_voters.user_id)));


--
-- Name: cards_labels_listing; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW cards_labels_listing AS
 SELECT cl.id,
    to_char(cl.created, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS created,
    to_char(cl.modified, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS modified,
    cl.label_id,
    cl.card_id,
    c.name AS card_name,
    c.list_id,
    l.name,
    cl.board_id
   FROM ((cards_labels cl
     LEFT JOIN cards c ON ((c.id = cl.card_id)))
     LEFT JOIN labels l ON ((l.id = cl.label_id)));


--
-- Name: cards_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE cards_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cards_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE cards_users (
    id bigint DEFAULT nextval('cards_users_id_seq'::regclass) NOT NULL,
    created timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    card_id bigint NOT NULL,
    user_id bigint NOT NULL
);


--
-- Name: cards_users_listing; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW cards_users_listing AS
 SELECT u.username,
    u.profile_picture_path,
    cu.id,
    to_char(cu.created, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS created,
    to_char(cu.modified, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS modified,
    cu.card_id,
    cu.user_id,
    u.initials,
    u.full_name,
    u.email
   FROM (cards_users cu
     LEFT JOIN users u ON ((u.id = cu.user_id)));


--
-- Name: checklists_listing; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW checklists_listing AS
 SELECT checklists.id,
    to_char(checklists.created, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS created,
    to_char(checklists.modified, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS modified,
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
                    (checklist_items.is_completed)::integer AS is_completed,
                    checklist_items."position"
                   FROM checklist_items checklist_items
                  WHERE (checklist_items.checklist_id = checklists.id)
                  ORDER BY checklist_items."position") ci) AS checklists_items,
    checklists."position"
   FROM checklists checklists;


--
-- Name: cards_listing; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW cards_listing AS
 SELECT cards.id,
    to_char(cards.created, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS created,
    to_char(cards.modified, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS modified,
    cards.board_id,
    cards.list_id,
    cards.name,
    cards.description,
    to_char(cards.due_date, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS due_date,
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
                    to_char(cards_subscribers.created, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS created,
                    to_char(cards_subscribers.modified, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS modified,
                    cards_subscribers.card_id,
                    cards_subscribers.user_id,
                    (cards_subscribers.is_subscribed)::integer AS is_subscribed
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
    l.name AS list_name,
    cards.custom_fields
   FROM (((cards cards
     LEFT JOIN users u ON ((u.id = cards.user_id)))
     LEFT JOIN boards b ON ((b.id = cards.board_id)))
     LEFT JOIN lists l ON ((l.id = cards.list_id)));


--
-- Name: lists_subscribers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE lists_subscribers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: list_subscribers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE list_subscribers (
    id bigint DEFAULT nextval('lists_subscribers_id_seq'::regclass) NOT NULL,
    created timestamp without time zone NOT NULL,
    modified timestamp without time zone,
    list_id bigint NOT NULL,
    user_id bigint NOT NULL,
    is_subscribed boolean DEFAULT false NOT NULL
);


--
-- Name: lists_listing; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW lists_listing AS
 SELECT lists.id,
    to_char(lists.created, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS created,
    to_char(lists.modified, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS modified,
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
                    ((cards_listing.is_archived)::boolean)::integer AS is_archived,
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
                    cards_listing.comment_count,
                    cards_listing.custom_fields
                   FROM cards_listing cards_listing
                  WHERE (cards_listing.list_id = lists.id)
                  ORDER BY cards_listing."position") lc) AS cards,
    ( SELECT array_to_json(array_agg(row_to_json(ls.*))) AS array_to_json
           FROM ( SELECT lists_subscribers.id,
                    to_char(lists_subscribers.created, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS created,
                    to_char(lists_subscribers.modified, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS modified,
                    lists_subscribers.list_id,
                    lists_subscribers.user_id,
                    (lists_subscribers.is_subscribed)::integer AS is_subscribed
                   FROM list_subscribers lists_subscribers
                  WHERE (lists_subscribers.list_id = lists.id)
                  ORDER BY lists_subscribers.id) ls) AS lists_subscribers,
    lists.custom_fields
   FROM lists lists;


--
-- Name: boards_listing; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW boards_listing AS
 SELECT board.id,
    board.name,
    to_char(board.created, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS created,
    to_char(board.modified, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS modified,
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
                    to_char(activities.created, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS created,
                    to_char(activities.modified, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS modified,
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
                    to_char(boards_subscribers.created, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS created,
                    to_char(boards_subscribers.modified, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS modified,
                    boards_subscribers.board_id,
                    boards_subscribers.user_id,
                    (boards_subscribers.is_subscribed)::integer AS is_subscribed
                   FROM board_subscribers boards_subscribers
                  WHERE (boards_subscribers.board_id = board.id)
                  ORDER BY boards_subscribers.id) bs) AS boards_subscribers,
    ( SELECT array_to_json(array_agg(row_to_json(bs.*))) AS array_to_json
           FROM ( SELECT boards_stars.id,
                    to_char(boards_stars.created, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS created,
                    to_char(boards_stars.modified, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS modified,
                    boards_stars.created,
                    boards_stars.modified,
                    boards_stars.board_id,
                    boards_stars.user_id,
                    (boards_stars.is_starred)::integer AS is_starred
                   FROM board_stars boards_stars
                  WHERE (boards_stars.board_id = board.id)
                  ORDER BY boards_stars.id) bs(id, created, modified, created_1, modified_1, board_id, user_id, is_starred)) AS boards_stars,
    ( SELECT array_to_json(array_agg(row_to_json(batt.*))) AS array_to_json
           FROM ( SELECT card_attachments.id,
                    to_char(card_attachments.created, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS created,
                    to_char(card_attachments.modified, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS modified,
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
                    lists_listing.lists_subscribers,
                    lists_listing.custom_fields
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
    board.is_default_email_position_as_bottom,
    board.custom_fields
   FROM ((boards board
     LEFT JOIN users users ON ((users.id = board.user_id)))
     LEFT JOIN organizations organizations ON ((organizations.id = board.organization_id)));


--
-- Name: cards_elasticsearch_listing; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW cards_elasticsearch_listing AS
 SELECT card.id,
    row_to_json(card.*) AS json
   FROM ( SELECT cards.id,
            cards.board_id,
            boards.name AS board,
            cards.list_id,
            lists.name AS list,
            cards.name,
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
                          ORDER BY activities.id) cl) AS activities
           FROM ((cards cards
             LEFT JOIN boards boards ON ((boards.id = cards.board_id)))
             LEFT JOIN lists lists ON ((lists.id = cards.list_id)))
          WHERE (boards.name IS NOT NULL)) card;


--
-- Name: checklist_add_listing; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW checklist_add_listing AS
 SELECT c.id,
    c.name,
    c.board_id,
    cl.checklist_item_count,
    cl.name AS checklist_name,
    cl.id AS checklist_id
   FROM (cards c
     LEFT JOIN checklists cl ON ((cl.card_id = c.id)))
  WHERE (c.checklist_item_count > 0)
  ORDER BY c.id;


--
-- Name: cities; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE cities (
    id bigint NOT NULL,
    created timestamp without time zone,
    modified timestamp without time zone,
    country_id bigint,
    state_id bigint,
    latitude character varying(255),
    longitude character varying(255),
    name character varying(255),
    is_active boolean DEFAULT false
);


--
-- Name: cities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE cities_id_seq
    START WITH 15178
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cities_id_seq1; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE cities_id_seq1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cities_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE cities_id_seq1 OWNED BY cities.id;


--
-- Name: countries; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE countries (
    id bigint NOT NULL,
    iso_alpha2 character(2) DEFAULT NULL::bpchar,
    iso_alpha3 character(3) DEFAULT NULL::bpchar,
    iso_numeric bigint,
    fips_code character varying(3) DEFAULT NULL::character varying,
    name character varying(200) DEFAULT NULL::character varying,
    capital character varying(200) DEFAULT NULL::character varying,
    areainsqkm double precision,
    population bigint,
    continent character(2) DEFAULT NULL::bpchar,
    tld character(3) DEFAULT NULL::bpchar,
    currency character(3) DEFAULT NULL::bpchar,
    currencyname character(20) DEFAULT NULL::bpchar,
    phone character(10) DEFAULT NULL::bpchar,
    postalcodeformat character(20) DEFAULT NULL::bpchar,
    postalcoderegex character(20) DEFAULT NULL::bpchar,
    languages character varying(200) DEFAULT NULL::character varying,
    geonameid bigint,
    neighbours character(20) DEFAULT NULL::bpchar,
    equivalentfipscode character(10) DEFAULT NULL::bpchar,
    created timestamp without time zone,
    iso2 character varying(2),
    iso3 character varying(3),
    modified timestamp without time zone
);


--
-- Name: countries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE countries_id_seq
    START WITH 262
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: countries_id_seq1; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE countries_id_seq1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: countries_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE countries_id_seq1 OWNED BY countries.id;


--
-- Name: email_templates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE email_templates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: email_templates; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE email_templates (
    id bigint DEFAULT nextval('email_templates_id_seq'::regclass) NOT NULL,
    created timestamp without time zone,
    modified timestamp without time zone,
    from_email character varying(500) DEFAULT NULL::character varying,
    reply_to_email character varying(500) DEFAULT NULL::character varying,
    name character varying(150) DEFAULT NULL::character varying,
    description text,
    subject character varying(255) DEFAULT NULL::character varying,
    email_text_content text,
    email_variables character varying(1000) DEFAULT NULL::character varying,
    display_name text
);


--
-- Name: gadget_users_listing; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW gadget_users_listing AS
 SELECT checklists.id,
    to_char(checklists.created, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS created,
    to_char(checklists.modified, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS modified,
    checklists.user_id,
    checklists.card_id,
    checklists.name,
    checklists.checklist_item_count,
    checklists.checklist_item_completed_count,
    ( SELECT array_to_json(array_agg(row_to_json(ci.*))) AS array_to_json
           FROM ( SELECT checklist_items.id,
                    to_char(checklist_items.created, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS created,
                    to_char(checklist_items.modified, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS modified,
                    checklist_items.user_id,
                    checklist_items.card_id,
                    checklist_items.checklist_id,
                    checklist_items.name,
                    (checklist_items.is_completed)::integer AS is_completed
                   FROM checklist_items checklist_items
                  WHERE (checklist_items.checklist_id = checklists.id)
                  ORDER BY checklist_items.id) ci) AS checklist_items
   FROM checklists checklists;


--
-- Name: ips_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ips_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ips; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ips (
    id bigint DEFAULT nextval('ips_id_seq'::regclass) NOT NULL,
    created timestamp without time zone,
    modified timestamp without time zone,
    ip character varying(255) NOT NULL,
    host character varying(255) NOT NULL,
    user_agent character varying(255) NOT NULL,
    "order" integer DEFAULT 0,
    city_id bigint,
    state_id bigint,
    country_id bigint,
    latitude double precision,
    longitude double precision
);


--
-- Name: languages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE languages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: languages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE languages (
    id bigint DEFAULT nextval('languages_id_seq'::regclass) NOT NULL,
    created timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    name character varying(80) NOT NULL,
    iso2 character varying(25) NOT NULL,
    iso3 character varying(25) NOT NULL,
    is_active smallint DEFAULT 1 NOT NULL
);


--
-- Name: list_subscribers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE list_subscribers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: login_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE login_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: login_types; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE login_types (
    id bigint DEFAULT nextval('login_types_id_seq'::regclass) NOT NULL,
    created timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    name character varying(255) NOT NULL
);


--
-- Name: oauth_access_tokens; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE oauth_access_tokens (
    access_token character varying(40) NOT NULL,
    client_id character varying(80),
    user_id character varying(255),
    expires timestamp without time zone,
    scope character varying(2000)
);


--
-- Name: oauth_authorization_codes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE oauth_authorization_codes (
    authorization_code character varying(40) NOT NULL,
    client_id character varying(80),
    user_id character varying(255),
    redirect_uri character varying(2000),
    expires timestamp without time zone,
    scope character varying(2000)
);


--
-- Name: oauth_clients; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE oauth_clients (
    client_id character varying(80) NOT NULL,
    client_secret character varying(80),
    redirect_uri character varying(2000),
    grant_types character varying(80),
    scope character varying(100),
    user_id character varying(80),
    client_name character varying(255),
    client_url character varying(255),
    logo_url character varying(255),
    tos_url character varying(255),
    policy_url character varying(2000),
    modified timestamp without time zone,
    created timestamp without time zone,
    id integer NOT NULL
);


--
-- Name: oauth_clients_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE oauth_clients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: oauth_clients_id_seq1; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE oauth_clients_id_seq1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: oauth_clients_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE oauth_clients_id_seq1 OWNED BY oauth_clients.id;


--
-- Name: oauth_jwt; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE oauth_jwt (
    client_id character varying(80) NOT NULL,
    subject character varying(80),
    public_key character varying(2000)
);


--
-- Name: oauth_refresh_tokens; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE oauth_refresh_tokens (
    refresh_token character varying(40) NOT NULL,
    client_id character varying(80),
    user_id character varying(255),
    expires timestamp without time zone,
    scope character varying(2000)
);


--
-- Name: oauth_scopes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE oauth_scopes (
    scope text NOT NULL,
    is_default boolean
);


--
-- Name: organization_user_roles_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE organization_user_roles_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organization_user_roles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE organization_user_roles (
    id bigint DEFAULT nextval('organization_user_roles_seq'::regclass) NOT NULL,
    created timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    name character varying(255) NOT NULL,
    description character varying
);


--
-- Name: organizations_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE organizations_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organizations_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE organizations_users (
    id bigint DEFAULT nextval('organizations_users_id_seq'::regclass) NOT NULL,
    created timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    organization_id bigint NOT NULL,
    user_id bigint NOT NULL,
    organization_user_role_id smallint DEFAULT (0)::smallint NOT NULL
);


--
-- Name: organizations_users_listing; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW organizations_users_listing AS
 SELECT organizations_users.id,
    to_char(organizations_users.created, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS created,
    to_char(organizations_users.modified, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS modified,
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


--
-- Name: organizations_listing; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW organizations_listing AS
 SELECT organizations.id,
    to_char(organizations.created, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS created,
    to_char(organizations.modified, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS modified,
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


--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE roles (
    id bigint DEFAULT nextval('roles_id_seq'::regclass) NOT NULL,
    created timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    name character varying(255) NOT NULL
);


--
-- Name: role_links_listing; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW role_links_listing AS
 SELECT role.id,
    ( SELECT array_to_json(array_agg(link.*)) AS array_to_json
           FROM ( SELECT alls.slug
                   FROM acl_links_listing alls
                  WHERE (alls.role_id = role.id)) link) AS links
   FROM roles role;


--
-- Name: setting_categories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE setting_categories (
    id integer NOT NULL,
    created timestamp without time zone,
    modified timestamp without time zone,
    parent_id bigint,
    name character varying(255),
    description text,
    "order" integer DEFAULT 0 NOT NULL
);


--
-- Name: setting_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE setting_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: setting_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE setting_categories_id_seq OWNED BY setting_categories.id;


--
-- Name: settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: settings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE settings (
    id bigint DEFAULT nextval('settings_id_seq'::regclass) NOT NULL,
    setting_category_id bigint NOT NULL,
    setting_category_parent_id bigint DEFAULT 0,
    name character varying(255),
    value text,
    description text,
    type character varying(8),
    options text,
    label character varying(255),
    "order" integer DEFAULT 0 NOT NULL
);


--
-- Name: settings_listing; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW settings_listing AS
 SELECT setting_categories.id,
    to_char(setting_categories.created, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS created,
    to_char(setting_categories.modified, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS modified,
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


--
-- Name: simple_board_listing; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW simple_board_listing AS
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
                    to_char(lists.created, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS created,
                    to_char(lists.modified, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS modified,
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


--
-- Name: states; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE states (
    id bigint NOT NULL,
    created timestamp without time zone,
    modified timestamp without time zone,
    country_id bigint,
    name character varying(45),
    is_active boolean DEFAULT false
);


--
-- Name: states_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE states_id_seq
    START WITH 15138
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: states_id_seq1; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE states_id_seq1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: states_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE states_id_seq1 OWNED BY states.id;


--
-- Name: user_logins; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE user_logins (
    id integer NOT NULL,
    created timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    user_id bigint DEFAULT (0)::bigint NOT NULL,
    ip_id bigint DEFAULT (0)::bigint NOT NULL,
    user_agent character varying(255)
);


--
-- Name: user_logins_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_logins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_logins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_logins_id_seq OWNED BY user_logins.id;


--
-- Name: users_cards_listing; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW users_cards_listing AS
 SELECT b.name AS board_name,
    l.name AS list_name,
    c.id,
    to_char(c.created, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS created,
    to_char(c.modified, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS modified,
    c.board_id,
    c.list_id,
    c.name,
    c.description,
    c.due_date,
    c."position",
    (c.is_archived)::integer AS is_archived,
    c.attachment_count,
    c.checklist_count,
    c.checklist_item_count,
    c.checklist_item_completed_count,
    c.label_count,
    c.cards_user_count,
    c.cards_subscriber_count,
    c.card_voter_count,
    c.activity_count,
    c.user_id AS created_user_id,
    (c.is_deleted)::integer AS is_deleted,
    cu.user_id,
    c.comment_count
   FROM (((cards_users cu
     JOIN cards c ON ((c.id = cu.card_id)))
     JOIN boards b ON ((b.id = c.board_id)))
     JOIN lists l ON ((l.id = c.list_id)));


--
-- Name: users_listing; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW users_listing AS
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
    to_char(users.created, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS created,
    users.user_login_count,
    users.is_send_newsletter,
    users.last_email_notified_activity_id,
    users.owner_board_count,
    users.member_board_count,
    users.owner_organization_count,
    users.member_organization_count,
    users.language,
    (users.is_ldap)::integer AS is_ldap,
    users.timezone
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


--
-- Name: webhooks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE webhooks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: webhooks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE webhooks (
    id bigint DEFAULT nextval('webhooks_id_seq'::regclass) NOT NULL,
    created timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255) NOT NULL,
    url character varying(255) NOT NULL,
    secret character varying(255) NOT NULL,
    is_active boolean DEFAULT false NOT NULL
);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY cities ALTER COLUMN id SET DEFAULT nextval('cities_id_seq1'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY countries ALTER COLUMN id SET DEFAULT nextval('countries_id_seq1'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY oauth_clients ALTER COLUMN id SET DEFAULT nextval('oauth_clients_id_seq1'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY setting_categories ALTER COLUMN id SET DEFAULT nextval('setting_categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY states ALTER COLUMN id SET DEFAULT nextval('states_id_seq1'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_logins ALTER COLUMN id SET DEFAULT nextval('user_logins_id_seq'::regclass);


--
-- Data for Name: acl_board_links; Type: TABLE DATA; Schema: public; Owner: -
--

COPY acl_board_links (id, created, modified, name, url, method, slug, group_id, is_hide) FROM stdin;
1	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Add board member	/boards/?/users	POST	add_board_users	2	0
2	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Add card	/boards/?/lists/?/cards	POST	add_card	4	0
3	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Add checklist to card	/boards/?/lists/?/cards/?/checklists	POST	add_checklists	4	0
4	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Add item to checklist	/boards/?/lists/?/cards/?/checklists/?/items	POST	add_checklist_item	4	0
5	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Add list	/boards/?/lists	POST	add_list	3	0
7	2016-02-19 16:21:04.718	2016-02-19 16:21:04.718	Archive card			archive_card	4	0
8	2016-02-19 16:21:04.687	2016-02-19 16:21:04.687	Archive list			archive_list	3	0
9	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Archived card send back to board	/boards/?/lists/?/cards	POST	send_back_to_archived_card	4	0
10	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Archived list send back to board	/lists/?	PUT	send_back_to_archived_list	2	0
12	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Assign member to card	/boards/?/lists/?/cards/?/users/?	POST	add_card_user	4	0
14	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Board subscribers	/boards/?/board_subscribers	GET	view_board_subscribers	2	1
15	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Board sync Google calendar URL	/boards/?/sync_calendar	GET	view_sync_calendar	2	0
16	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Card activities	/boards/?/lists/?/cards/?/activities	GET	view_card_activities	4	0
17	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Cards listing	/boards/?/lists/?/cards/?	GET	view_card_isting	4	1
18	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Checklist listing	/boards/?/lists/?/cards/?/checklists	GET	view_checklist_listing	4	0
19	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Convert item to card	/boards/?/lists/?/cards/?/checklists/?/items/?/convert_to_card	POST	convert_item_to_card	4	0
20	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Copy board	/boards/?/copy	POST	copy_board	2	0
21	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Copy card	/boards/?/lists/?/cards/?/copy	POST	copy_card	4	0
22	2016-02-16 16:57:48.45	2016-02-16 16:57:48.45	Delete all archived cards	/boards/?/cards	DELETE	delete_all_archived_cards	2	0
23	2016-02-16 16:57:48.372	2016-02-16 16:57:48.372	Delete all archived lists	/boards/?/lists	DELETE	delete_all_archived_lists	2	0
25	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Delete card	/boards/?/lists/?/cards/?	DELETE	delete_card	4	0
26	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Delete checklist	/boards/?/lists/?/cards/?/checklists/?	DELETE	delete_checklist	4	0
27	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Delete comment	/boards/?/lists/?/cards/?/comments/?	DELETE	delete_comment	4	0
28	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Delete item in checklist	/boards/?/lists/?/cards/?/checklists/?/items/?	DELETE	delete_checklist_item	4	0
30	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Delete list	/boards/?/lists/?	DELETE	delete_list	3	0
31	2014-08-25 13:14:18.2	2014-08-25 13:14:18.2	Download attachment from card	/download/?	GET	download_attachment_card	4	0
32	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Edit board	/boards/?	PUT	edit_board	2	0
33	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Edit card	/boards/?/lists/?/cards/?	PUT	edit_card	4	0
34	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Edit checklist	/boards/?/lists/?/cards/?/checklists/?	PUT	edit_checklist	4	0
35	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Edit comment	/boards/?/lists/?/cards/?/comments/?	PUT	edit_comment	4	0
36	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Edit item in checklist	/boards/?/lists/?/cards/?/checklists/?/items/?	PUT	edit_checklist_item	4	0
37	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Edit list	/boards/?/lists/?	PUT	edit_list	3	0
38	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Move list cards	/boards/?/lists/?/cards	PUT	move_list_cards	4	0
39	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Post comment to card	/boards/?/lists/?/cards/?/comments	POST	comment_card	4	0
40	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Remove attachment from card	/boards/?/lists/?/cards/?/attachments/?	DELETE	remove_card_attachment	4	0
42	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Remove card member	/boards/?/lists/?/cards/?/users/?	DELETE	delete_card_user	4	0
45	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Subscribe board	/boards/?/board_subscribers	POST	subscribe_board	2	0
46	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Subscribe card	/boards/?/lists/?/cards/?/card_subscribers	POST	subscribe_card	4	0
47	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Subscribe list	/boards/?/lists/?/list_subscribers	POST	subscribe_list	3	0
49	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Unsubscribe board	/boards/?/board_subscribers/?	PUT	board_subscriber	2	0
50	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Unsubscribe card	/boards/?/lists/?/cards/?/card_subscribers/?	PUT	unsubscribe_card	4	0
51	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Unsubscribe list	/boards/?/lists/?/list_subscribers/?	PUT	unsubscribe_list	3	0
52	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Unvote card	/boards/?/lists/?/cards/?/card_voters/?	DELETE	unvote_card	4	0
53	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Update board member permission	/boards_users/?	PUT	edit_board_user	2	0
54	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Upload attachment to card	/boards/?/lists/?/cards/?/attachments	POST	add_card_attachment	4	0
55	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Upload custom background to board	/boards/?/custom_backgrounds	POST	add_custom_background	2	0
56	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	View Archived card	/boards/?/archived_cards	GET	view_archived_cards	4	0
57	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	View archived list	/boards/?/archived_lists	GET	view_archived_lists	3	0
58	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	View board activities	/boards/?/activities	GET	view_board_activities	2	0
59	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	View card labels	/boards/?/lists/?/cards/?/labels	GET	view_card_labels	4	0
61	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Vote card	/boards/?/lists/?/cards/?/card_voters	POST	vote_card	4	0
29	2016-02-16 16:57:48.45	2016-02-16 16:57:48.45	Add / Delete Labels	/boards/?/labels/?	DELETE	delete_labels	2	0
44	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Search card to add in comment	/boards/?/cards/search	GET	view_card_search	4	0
11	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Assign labels to card	/boards/?/lists/?/cards/?/labels	POST	add_labels	4	1
41	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Remove board member	/boards/?/boards_users/?	DELETE	remove_board_user	2	0
\.


--
-- Data for Name: acl_board_links_boards_user_roles; Type: TABLE DATA; Schema: public; Owner: -
--

COPY acl_board_links_boards_user_roles (id, created, modified, acl_board_link_id, board_user_role_id) FROM stdin;
1	2016-02-22 12:43:35.008	2016-02-22 12:43:35.008	1	1
3	2016-02-22 12:43:36.131	2016-02-22 12:43:36.131	10	1
5	2016-02-22 12:43:37.17	2016-02-22 12:43:37.17	15	1
6	2016-02-22 12:43:37.888	2016-02-22 12:43:37.888	20	1
7	2016-02-22 12:43:38.505	2016-02-22 12:43:38.505	22	1
8	2016-02-22 12:43:39.931	2016-02-22 12:43:39.931	23	1
10	2016-02-22 12:43:40.966	2016-02-22 12:43:40.966	29	1
11	2016-02-22 12:43:41.585	2016-02-22 12:43:41.585	32	1
12	2016-02-22 12:43:42.23	2016-02-22 12:43:42.23	41	1
13	2016-02-22 12:43:42.736	2016-02-22 12:43:42.736	45	1
14	2016-02-22 12:43:43.589	2016-02-22 12:43:43.589	49	1
15	2016-02-22 12:43:45.065	2016-02-22 12:43:45.065	53	1
16	2016-02-22 12:43:45.646	2016-02-22 12:43:45.646	55	1
17	2016-02-22 12:43:46.14	2016-02-22 12:43:46.14	58	1
18	2016-02-22 12:43:47.394	2016-02-22 12:43:47.394	5	1
19	2016-02-22 12:43:47.942	2016-02-22 12:43:47.942	8	1
20	2016-02-22 12:43:48.548	2016-02-22 12:43:48.548	30	1
21	2016-02-22 12:43:49.176	2016-02-22 12:43:49.176	37	1
22	2016-02-22 12:43:49.848	2016-02-22 12:43:49.848	47	1
23	2016-02-22 12:43:51.762	2016-02-22 12:43:51.762	51	1
24	2016-02-22 12:43:52.402	2016-02-22 12:43:52.402	57	1
25	2016-02-22 12:43:53.654	2016-02-22 12:43:53.654	2	1
26	2016-02-22 12:43:55.821	2016-02-22 12:43:55.821	3	1
27	2016-02-22 12:43:56.556	2016-02-22 12:43:56.556	4	1
28	2016-02-22 12:43:57.59	2016-02-22 12:43:57.59	7	1
29	2016-02-22 12:43:58.523	2016-02-22 12:43:58.523	9	1
30	2016-02-22 12:43:59.332	2016-02-22 12:43:59.332	11	1
31	2016-02-22 12:44:00.126	2016-02-22 12:44:00.126	12	1
32	2016-02-22 12:44:00.853	2016-02-22 12:44:00.853	16	1
33	2016-02-22 12:44:01.581	2016-02-22 12:44:01.581	18	1
34	2016-02-22 12:44:03.168	2016-02-22 12:44:03.168	19	1
35	2016-02-22 12:44:03.774	2016-02-22 12:44:03.774	21	1
36	2016-02-22 12:44:04.428	2016-02-22 12:44:04.428	25	1
37	2016-02-22 12:44:05.131	2016-02-22 12:44:05.131	26	1
38	2016-02-22 12:44:05.738	2016-02-22 12:44:05.738	27	1
39	2016-02-22 12:44:06.437	2016-02-22 12:44:06.437	28	1
40	2016-02-22 12:44:08.372	2016-02-22 12:44:08.372	31	1
41	2016-02-22 12:44:08.95	2016-02-22 12:44:08.95	33	1
42	2016-02-22 12:44:09.715	2016-02-22 12:44:09.715	34	1
43	2016-02-22 12:44:10.4	2016-02-22 12:44:10.4	35	1
44	2016-02-22 12:44:11.628	2016-02-22 12:44:11.628	36	1
45	2016-02-22 12:44:13.156	2016-02-22 12:44:13.156	38	1
46	2016-02-22 12:44:13.809	2016-02-22 12:44:13.809	39	1
47	2016-02-22 12:44:15.24	2016-02-22 12:44:15.24	40	1
48	2016-02-22 12:44:15.774	2016-02-22 12:44:15.774	42	1
50	2016-02-22 12:44:18.192	2016-02-22 12:44:18.192	44	1
51	2016-02-22 12:44:18.738	2016-02-22 12:44:18.738	46	1
53	2016-02-22 12:44:20.659	2016-02-22 12:44:20.659	50	1
54	2016-02-22 12:44:21.955	2016-02-22 12:44:21.955	52	1
55	2016-02-22 12:44:22.802	2016-02-22 12:44:22.802	54	1
56	2016-02-22 12:44:23.529	2016-02-22 12:44:23.529	56	1
57	2016-02-22 12:44:24.402	2016-02-22 12:44:24.402	59	1
59	2016-02-22 12:44:26.051	2016-02-22 12:44:26.051	61	1
62	2016-02-22 12:46:11.58	2016-02-22 12:46:11.58	15	2
63	2016-02-22 12:46:14.307	2016-02-22 12:46:14.307	20	2
64	2016-02-22 12:46:45.613	2016-02-22 12:46:45.613	32	2
65	2016-02-22 12:46:50.203	2016-02-22 12:46:50.203	45	2
66	2016-02-22 12:46:51.058	2016-02-22 12:46:51.058	49	2
67	2016-02-22 12:47:00.281	2016-02-22 12:47:00.281	58	2
68	2016-02-22 12:47:04.274	2016-02-22 12:47:04.274	55	2
69	2016-02-22 12:47:06.413	2016-02-22 12:47:06.413	5	2
70	2016-02-22 12:47:08.035	2016-02-22 12:47:08.035	8	2
71	2016-02-22 12:47:09.228	2016-02-22 12:47:09.228	30	2
72	2016-02-22 12:47:10.195	2016-02-22 12:47:10.195	37	2
73	2016-02-22 12:47:11.524	2016-02-22 12:47:11.524	47	2
74	2016-02-22 12:47:12.297	2016-02-22 12:47:12.297	51	2
75	2016-02-22 12:47:13.172	2016-02-22 12:47:13.172	57	2
76	2016-02-22 12:47:16.28	2016-02-22 12:47:16.28	2	2
77	2016-02-22 12:47:17.203	2016-02-22 12:47:17.203	3	2
78	2016-02-22 12:47:17.917	2016-02-22 12:47:17.917	4	2
79	2016-02-22 12:47:19.217	2016-02-22 12:47:19.217	7	2
80	2016-02-22 12:47:24.908	2016-02-22 12:47:24.908	11	2
81	2016-02-22 12:47:25.573	2016-02-22 12:47:25.573	12	2
82	2016-02-22 12:47:26.632	2016-02-22 12:47:26.632	16	2
83	2016-02-22 12:47:27.406	2016-02-22 12:47:27.406	18	2
84	2016-02-22 12:47:28.325	2016-02-22 12:47:28.325	19	2
85	2016-02-22 12:47:30.053	2016-02-22 12:47:30.053	21	2
86	2016-02-22 12:47:31.461	2016-02-22 12:47:31.461	25	2
87	2016-02-22 12:47:32.572	2016-02-22 12:47:32.572	26	2
88	2016-02-22 12:47:34.276	2016-02-22 12:47:34.276	27	2
89	2016-02-22 12:47:36.189	2016-02-22 12:47:36.189	28	2
90	2016-02-22 12:47:37.972	2016-02-22 12:47:37.972	31	2
91	2016-02-22 12:47:38.728	2016-02-22 12:47:38.728	33	2
92	2016-02-22 12:47:39.751	2016-02-22 12:47:39.751	34	2
93	2016-02-22 12:47:40.498	2016-02-22 12:47:40.498	35	2
94	2016-02-22 12:47:41.485	2016-02-22 12:47:41.485	36	2
95	2016-02-22 12:47:42.15	2016-02-22 12:47:42.15	38	2
96	2016-02-22 12:47:43.781	2016-02-22 12:47:43.781	39	2
97	2016-02-22 12:47:44.712	2016-02-22 12:47:44.712	40	2
98	2016-02-22 12:47:45.469	2016-02-22 12:47:45.469	42	2
100	2016-02-22 12:47:47.076	2016-02-22 12:47:47.076	44	2
101	2016-02-22 12:47:48.52	2016-02-22 12:47:48.52	46	2
103	2016-02-22 12:47:58.03	2016-02-22 12:47:58.03	50	2
104	2016-02-22 12:47:59.63	2016-02-22 12:47:59.63	52	2
105	2016-02-22 12:48:01.776	2016-02-22 12:48:01.776	54	2
106	2016-02-22 12:48:02.615	2016-02-22 12:48:02.615	56	2
107	2016-02-22 12:48:03.725	2016-02-22 12:48:03.725	59	2
109	2016-02-22 12:48:07.046	2016-02-22 12:48:07.046	61	2
112	2016-02-22 12:48:30.485	2016-02-22 12:48:30.485	15	3
113	2016-02-22 12:48:37.553	2016-02-22 12:48:37.553	45	3
114	2016-02-22 12:48:38.118	2016-02-22 12:48:38.118	49	3
115	2016-02-22 12:48:43.07	2016-02-22 12:48:43.07	58	3
116	2016-02-22 12:48:47.487	2016-02-22 12:48:47.487	47	3
117	2016-02-22 12:48:48.016	2016-02-22 12:48:48.016	51	3
118	2016-02-22 12:48:49.539	2016-02-22 12:48:49.539	57	3
119	2016-02-22 12:49:05.555	2016-02-22 12:49:05.555	16	3
120	2016-02-22 12:49:07.169	2016-02-22 12:49:07.169	18	3
121	2016-02-22 12:49:13.259	2016-02-22 12:49:13.259	31	3
123	2016-02-22 12:49:27.487	2016-02-22 12:49:27.487	46	3
124	2016-02-22 12:49:29.363	2016-02-22 12:49:29.363	50	3
125	2016-02-22 12:49:43.194	2016-02-22 12:49:43.194	56	3
126	2016-02-22 12:49:44.285	2016-02-22 12:49:44.285	59	3
128	2016-02-22 12:49:49.309	2016-02-22 12:49:49.309	61	3
\.


--
-- Name: acl_board_links_boards_user_roles_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('acl_board_links_boards_user_roles_seq', 1, false);


--
-- Name: acl_board_links_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('acl_board_links_seq', 1, false);


--
-- Data for Name: acl_links; Type: TABLE DATA; Schema: public; Owner: -
--

COPY acl_links (id, created, modified, name, url, method, slug, group_id, is_user_action, is_guest_action, is_admin_action, is_hide) FROM stdin;
1	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Add board	/boards	POST	add_board	2	1	0	0	0
2	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Add organization	/organizations	POST	add_organization	2	1	0	0	0
3	2016-02-09 16:51:25.779	2016-02-09 16:51:25.779	Add webhooks	/webhooks	POST	add_webhook	2	1	0	0	0
4	2014-08-25 13:14:18.2	2014-08-25 13:14:18.2	All activities	/activities	GET	activities_listing	2	1	0	0	0
5	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Board search	/boards/search	GET	view_board_search	2	1	0	0	0
6	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Board visibility	/boards/?/visibility	GET	view_board_visibility	2	1	0	0	0
7	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Change password	/users/?/changepassword	POST	user_changepassword	2	1	0	0	0
8	2016-02-09 16:51:25.779	2016-02-09 16:51:25.779	Delete webhooks	/webhooks/?	DELETE	delete_webhook	2	1	0	0	0
9	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Edit user details	/users/?	PUT	edit_user_details	2	1	0	0	0
10	2016-02-09 16:51:25.779	2016-02-09 16:51:25.779	Edit webhooks	/webhooks/?	PUT	edit_webhook	2	1	0	0	0
11	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Forgot password	/users/forgotpassword	POST	users_forgotpassword	1	0	1	0	0
12	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Load workflow templates	/workflow_templates	GET	view_workflow_templates	2	1	0	0	0
13	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Login	/users/login	POST	users_login	1	0	1	0	1
14	2016-02-16 20:04:41.092	2016-02-16 20:04:41.092	My boards listing	/boards/my_boards	GET	view_my_boards	2	1	0	0	0
15	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Organization visibility	/organizations/?/visibility	GET	view_organization_visibility	2	1	0	0	0
16	2016-02-09 16:51:26.139	2016-02-09 16:51:26.139	Post oauth token	/oauth/token	POST	post_oauth_token	1	0	1	0	0
17	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Register	/users/register	POST	users_register	1	0	1	0	0
18	2016-02-09 16:51:25.217	2016-02-09 16:51:25.217	Revoke OAuth authorized applications	/oauth/applications/?	DELETE	delete_connected_applications	2	1	0	0	0
19	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Search	/search	GET	view_search	2	1	0	0	0
20	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Settings management	/settings	GET	load_settings	3	0	0	1	1
22	2016-02-16 20:06:48.576	2016-02-16 20:06:48.576	Starred boards listing	/boards/starred	GET	view_stared_boards	2	1	0	0	0
24	2016-02-18 17:45:14.983	2016-02-18 17:45:14.983	Unstar board	/boards/?/boards_stars/?	PUT	unstarred_board	2	1	0	0	0
23	2016-02-18 17:24:25.733	2016-02-18 17:24:25.733	Unstar board	/boards/?/boards_stars/?	PUT	board_star	2	1	0	0	0
25	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Upload profile picture	/users/?	POST	add_user_profile_picture	2	1	0	0	0
26	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	User activation	/users/?/activation	PUT	user_activation	1	0	1	0	0
27	2016-02-18 20:11:14.482	2016-02-18 20:11:14.482	View board	/boards/?	GET	view_board	2	1	1	0	0
28	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	View boards listing	/boards	GET	view_board_listing	2	1	0	0	0
29	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	View closed boards	/boards/closed_boards	GET	view_closed_boards	2	1	0	0	0
30	2016-02-09 16:51:25.217	2016-02-09 16:51:25.217	View OAuth authorized applications	/oauth/applications	GET	view_connected_applications	2	1	0	0	0
31	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	View organization	/organizations/?	GET	view_organization	2	1	0	0	0
32	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	View organizations listing	/organizations	GET	view_organization_listing	2	1	0	0	0
33	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	View starred boards listing	/boards/?/boards_stars	GET	view_board_star	2	1	0	0	0
34	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	View user	/users/?	GET	view_user	2	1	0	0	0
35	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	View user activities	/users/?/activities	GET	view_user_activities	2	1	0	0	0
36	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	View user assigned boards	/users/?/boards	GET	view_user_board	2	1	0	0	0
37	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	View user assigned cards	/users/?/cards	GET	view_user_cards	2	1	0	0	0
38	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	View user search	/users/search	GET	view_user_search	2	1	0	0	0
39	2016-02-09 16:51:25.779	2016-02-09 16:51:25.779	View webhooks	/webhooks	GET	view_webhooks	2	1	0	0	0
122	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Undo activity	/activities/undo/?	PUT	undo_activity	2	1	0	0	0
123	2016-03-07 11:45:43.8	2016-03-07 11:45:43.8	User detail	/users/me	GET	user_detail	0	1	0	1	1
40	2016-06-22 04:50:42.011	2016-06-22 04:50:42.011	Allow to post comments in public board	/boards/?/lists/?/cards/?/comments	POST	comment_card	2	1	0	0	0
41	2016-06-22 04:50:42.011	2016-06-22 04:50:42.011	Allow to subscribe board in public board	/boards/?/board_subscribers	POST	subscribe_board	2	1	0	0	0
42	2016-06-22 04:50:42.011	2016-06-22 04:50:42.011	Allow to subscribe list in public board	/boards/?/lists/?/list_subscribers	POST	subscribe_list	2	1	0	0	0
43	2016-06-22 04:50:42.011	2016-06-22 04:50:42.011	Allow to subscribe card in public board	/boards/?/lists/?/cards/?/card_subscribers	POST	subscribe_card	2	1	0	0	0
124	2015-10-05 13:14:18.2	2015-10-05 13:14:18.2	XMPP chat login	/xmpp_login	GET	xmpp_login	2	1	0	1	0
126	2016-06-22 04:50:42.236	2016-06-22 04:50:42.236	Role add	/roles	POST	role_add	1	0	0	1	1
127	2016-06-22 04:50:42.236	2016-06-22 04:50:42.236	Board user role add	/board_user_roles	POST	board_user_role_add	1	0	0	1	1
128	2016-06-22 04:50:42.236	2016-06-22 04:50:42.236	Organization user role add	/organization_user_roles	POST	organization_user_role_add	1	0	0	1	1
129	2016-06-22 04:50:42.239	2016-06-22 04:50:42.239	Role edit	/roles/?	PUT	role_edit	1	0	0	1	1
130	2016-06-22 04:50:42.239	2016-06-22 04:50:42.239	Board user role edit	/board_user_roles/?	PUT	board_user_role_edit	1	0	0	1	1
131	2016-06-22 04:50:42.239	2016-06-22 04:50:42.239	Organization user role edit	/organization_user_roles/?	PUT	organization_user_role_edit	1	0	0	1	1
40	2016-06-28 07:47:21.424	2016-06-28 07:47:21.424	Allow to post comments in public board	/boards/?/lists/?/cards/?/comments	POST	comment_card	2	1	0	0	0
41	2016-06-28 07:47:21.424	2016-06-28 07:47:21.424	Allow to subscribe board in public board	/boards/?/board_subscribers	POST	subscribe_board	2	1	0	0	0
42	2016-06-28 07:47:21.424	2016-06-28 07:47:21.424	Allow to subscribe list in public board	/boards/?/lists/?/list_subscribers	POST	subscribe_list	2	1	0	0	0
43	2016-06-28 07:47:21.424	2016-06-28 07:47:21.424	Allow to subscribe card in public board	/boards/?/lists/?/cards/?/card_subscribers	POST	subscribe_card	2	1	0	0	0
21	2016-02-18 17:42:32.045	2016-02-18 17:42:32.045	Allow to star/unstar in public board, card in public board	/boards/?/boards_stars	POST	starred_board	2	1	0	0	0
132	2015-10-05 13:14:18.2	2015-10-05 13:14:18.2	XMPP chat login	/xmpp_login	GET	xmpp_login	2	1	0	1	0
134	2016-06-28 07:47:21.742	2016-06-28 07:47:21.742	Role add	/roles	POST	role_add	1	0	0	1	1
135	2016-06-28 07:47:21.742	2016-06-28 07:47:21.742	Board user role add	/board_user_roles	POST	board_user_role_add	1	0	0	1	1
136	2016-06-28 07:47:21.742	2016-06-28 07:47:21.742	Organization user role add	/organization_user_roles	POST	organization_user_role_add	1	0	0	1	1
137	2016-06-28 07:47:21.747	2016-06-28 07:47:21.747	Role edit	/roles/?	PUT	role_edit	1	0	0	1	1
138	2016-06-28 07:47:21.747	2016-06-28 07:47:21.747	Board user role edit	/board_user_roles/?	PUT	board_user_role_edit	1	0	0	1	1
139	2016-06-28 07:47:21.747	2016-06-28 07:47:21.747	Organization user role edit	/organization_user_roles/?	PUT	organization_user_role_edit	1	0	0	1	1
125	2015-10-05 13:14:18.2	2015-10-05 13:14:18.2	Chat History	/boards/?/chat_history	GET	chat_history	2	1	0	1	0
133	2015-10-05 13:14:18.2	2015-10-05 13:14:18.2	Chat History	/boards/?/chat_history	GET	chat_history	2	1	0	1	0
\.


--
-- Name: acl_links_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('acl_links_id_seq', 139, true);


--
-- Data for Name: acl_links_roles; Type: TABLE DATA; Schema: public; Owner: -
--

COPY acl_links_roles (id, created, modified, acl_link_id, role_id) FROM stdin;
1	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	23	1
2	2016-02-20 19:08:19.584	2016-02-20 19:08:19.584	24	2
3	2016-02-20 19:08:19.584	2016-02-20 19:08:19.584	24	1
4	2016-02-20 19:07:31.102	2016-02-20 19:07:31.102	25	2
5	2016-02-20 19:07:31.102	2016-02-20 19:07:31.102	25	1
6	2016-02-20 19:07:27.124	2016-02-20 19:07:27.124	26	3
7	2016-02-20 19:08:20.385	2016-02-20 19:08:20.385	27	2
8	2016-02-20 19:08:21.237	2016-02-20 19:08:21.237	27	3
9	2016-02-20 19:08:20.385	2016-02-20 19:08:20.385	27	1
10	2016-02-20 19:07:57.812	2016-02-20 19:07:57.812	39	2
11	2016-02-20 19:07:57.812	2016-02-20 19:07:57.812	39	1
12	2016-02-20 19:07:29.971	2016-02-20 19:07:29.971	1	2
13	2016-02-20 19:07:29.971	2016-02-20 19:07:29.971	1	1
14	2016-02-20 19:07:29.324	2016-02-20 19:07:29.324	2	2
15	2016-02-20 19:07:29.324	2016-02-20 19:07:29.324	2	1
16	2016-02-20 19:07:58.59	2016-02-20 19:07:58.59	3	2
17	2016-02-20 19:07:58.59	2016-02-20 19:07:58.59	3	1
18	2016-02-20 19:07:47.43	2016-02-20 19:07:47.43	4	1
19	2016-02-20 19:07:36.217	2016-02-20 19:07:36.217	5	2
20	2016-02-20 19:07:36.217	2016-02-20 19:07:36.217	5	1
21	2016-02-20 19:07:38.318	2016-02-20 19:07:38.318	6	2
22	2016-02-20 19:07:31.771	2016-02-20 19:07:31.771	9	1
23	2016-02-20 19:08:16.346	2016-02-20 19:08:16.346	10	2
24	2016-02-20 19:08:16.346	2016-02-20 19:08:16.346	10	1
25	2016-02-20 19:07:25.664	2016-02-20 19:07:25.664	11	3
26	2016-02-20 19:07:39.589	2016-02-20 19:07:39.589	12	2
27	2016-02-20 19:07:26.404	2016-02-20 19:07:26.404	17	3
28	2016-02-20 19:07:57.006	2016-02-20 19:07:57.006	18	2
29	2016-02-20 19:07:57.006	2016-02-20 19:07:57.006	18	1
30	2016-02-20 19:07:41.054	2016-02-20 19:07:41.054	19	2
31	2016-02-20 19:07:41.054	2016-02-20 19:07:41.054	19	1
32	2016-02-22 10:58:31.89	2016-02-22 10:58:31.89	20	3
33	2016-02-22 12:17:06.002	2016-02-22 12:17:06.002	20	1
34	2016-02-20 19:08:18.616	2016-02-20 19:08:18.616	21	1
35	2016-02-20 19:07:32.362	2016-02-20 19:07:32.362	28	2
36	2016-02-20 19:07:32.362	2016-02-20 19:07:32.362	28	1
37	2016-02-20 19:07:34.351	2016-02-20 19:07:34.351	31	2
38	2016-02-20 19:07:34.351	2016-02-20 19:07:34.351	31	1
39	2016-02-20 19:07:45.749	2016-02-20 19:07:45.749	32	2
40	2016-02-20 19:07:45.749	2016-02-20 19:07:45.749	32	1
41	2016-02-20 19:07:43.927	2016-02-20 19:07:43.927	33	2
42	2016-02-20 19:07:43.927	2016-02-20 19:07:43.927	33	1
43	2016-02-20 19:07:41.755	2016-02-20 19:07:41.755	34	2
44	2016-02-20 19:07:41.755	2016-02-20 19:07:41.755	34	1
45	2016-02-20 19:07:47.43	2016-02-20 19:07:47.43	4	2
46	2016-02-20 19:07:39.589	2016-02-20 19:07:39.589	12	1
47	2016-02-20 19:07:38.318	2016-02-20 19:07:38.318	6	1
48	2016-02-22 10:59:06.81	2016-02-22 10:59:06.81	13	3
49	2016-02-20 19:07:48.396	2016-02-20 19:07:48.396	14	2
50	2016-02-20 19:07:48.396	2016-02-20 19:07:48.396	14	1
51	2016-02-20 19:07:45.001	2016-02-20 19:07:45.001	29	2
52	2016-02-20 19:07:45.001	2016-02-20 19:07:45.001	29	1
53	2016-02-20 19:07:52.525	2016-02-20 19:07:52.525	30	2
54	2016-02-20 19:07:52.525	2016-02-20 19:07:52.525	30	1
55	2016-02-20 19:07:39.029	2016-02-20 19:07:39.029	15	2
56	2016-02-20 19:07:39.029	2016-02-20 19:07:39.029	15	1
57	2016-02-20 19:07:27.772	2016-02-20 19:07:27.772	16	3
58	2016-02-20 19:07:35.269	2016-02-20 19:07:35.269	35	2
59	2016-02-20 19:07:35.269	2016-02-20 19:07:35.269	35	1
60	2016-02-20 19:07:43.227	2016-02-20 19:07:43.227	36	2
61	2016-02-20 19:07:43.227	2016-02-20 19:07:43.227	36	1
62	2016-02-20 19:07:42.416	2016-02-20 19:07:42.416	37	2
63	2016-02-20 19:07:42.416	2016-02-20 19:07:42.416	37	1
64	2016-02-20 19:07:37.681	2016-02-20 19:07:37.681	38	2
65	2016-02-20 19:07:37.681	2016-02-20 19:07:37.681	38	1
66	2016-02-20 19:07:50.147	2016-02-20 19:07:50.147	22	2
67	2016-02-20 19:07:50.147	2016-02-20 19:07:50.147	22	1
68	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	23	2
69	2016-02-20 19:07:30.541	2016-02-20 19:07:30.541	7	2
70	2016-02-20 19:08:18.616	2016-02-20 19:08:18.616	21	2
71	2016-02-22 12:58:43.86	2016-02-22 12:58:43.86	20	2
72	2016-02-20 19:07:30.541	2016-02-20 19:07:30.541	7	1
73	2016-02-20 19:08:17.963	2016-02-20 19:08:17.963	8	2
74	2016-02-20 19:08:17.963	2016-02-20 19:08:17.963	8	1
75	2016-02-20 19:07:31.771	2016-02-20 19:07:31.771	9	2
1218	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	122	1
1219	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	123	2
1220	2016-06-22 04:50:42.032	2016-06-22 04:50:42.032	40	1
1221	2016-06-22 04:50:42.032	2016-06-22 04:50:42.032	40	2
1222	2016-06-22 04:50:42.032	2016-06-22 04:50:42.032	41	1
1223	2016-06-22 04:50:42.032	2016-06-22 04:50:42.032	41	2
1224	2016-06-22 04:50:42.032	2016-06-22 04:50:42.032	42	1
1225	2016-06-22 04:50:42.032	2016-06-22 04:50:42.032	42	2
1226	2016-06-22 04:50:42.032	2016-06-22 04:50:42.032	43	1
1227	2016-06-22 04:50:42.032	2016-06-22 04:50:42.032	43	2
1228	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	124	1
1229	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	124	2
1230	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	125	1
1231	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	125	2
1232	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	126	1
1233	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	127	1
1234	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	128	1
1235	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	129	1
1236	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	130	1
1237	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	131	1
1238	2016-06-28 07:47:21.437	2016-06-28 07:47:21.437	40	1
1239	2016-06-28 07:47:21.437	2016-06-28 07:47:21.437	40	2
1240	2016-06-28 07:47:21.437	2016-06-28 07:47:21.437	41	1
1241	2016-06-28 07:47:21.437	2016-06-28 07:47:21.437	41	2
1242	2016-06-28 07:47:21.437	2016-06-28 07:47:21.437	42	1
1243	2016-06-28 07:47:21.437	2016-06-28 07:47:21.437	42	2
1244	2016-06-28 07:47:21.437	2016-06-28 07:47:21.437	43	1
1245	2016-06-28 07:47:21.437	2016-06-28 07:47:21.437	43	2
1246	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	124	1
1247	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	132	1
1248	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	124	2
1249	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	132	2
1250	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	125	1
1251	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	133	1
1252	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	125	2
1253	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	133	2
1254	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	126	1
1255	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	134	1
1256	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	127	1
1257	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	135	1
1258	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	128	1
1259	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	136	1
1260	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	129	1
1261	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	137	1
1262	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	130	1
1263	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	138	1
1264	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	131	1
1265	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	139	1
\.


--
-- Name: acl_links_roles_roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('acl_links_roles_roles_id_seq', 1265, true);


--
-- Data for Name: acl_organization_links; Type: TABLE DATA; Schema: public; Owner: -
--

COPY acl_organization_links (id, created, modified, name, url, method, slug, group_id, is_hide) FROM stdin;
1	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Add organization member	/organizations/?/users/?	POST	add_organization_user	5	0
2	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Delete organization	/organizations/?	DELETE	delete_organization	5	0
3	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Edit organization	/organizations/?	PUT	edit_organization	5	0
4	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Organization members listing	/organizations_users/?	GET	view_organization_user_listing	5	0
5	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Organization visibility	/organizations/?/visibility	GET	view_organization_visibility	5	0
6	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Remove organization member	/organizations/?/organizations_users/?	DELETE	remove_organization_user	5	0
7	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Update organization member permission	/organizations_users/?	PUT	edit_organization_user	5	0
8	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Upload organization logo	/organizations/?/upload_logo	POST	upload_organization_logo	5	0
\.


--
-- Data for Name: acl_organization_links_organizations_user_roles; Type: TABLE DATA; Schema: public; Owner: -
--

COPY acl_organization_links_organizations_user_roles (id, created, modified, acl_organization_link_id, organization_user_role_id) FROM stdin;
1	2016-02-22 12:44:27.98	2016-02-22 12:44:27.98	1	1
2	2016-02-22 12:44:28.532	2016-02-22 12:44:28.532	2	1
3	2016-02-22 12:44:29.562	2016-02-22 12:44:29.562	3	1
4	2016-02-22 12:44:30.3	2016-02-22 12:44:30.3	4	1
5	2016-02-22 12:44:30.946	2016-02-22 12:44:30.946	5	1
6	2016-02-22 12:44:32.307	2016-02-22 12:44:32.307	6	1
7	2016-02-22 12:44:33.987	2016-02-22 12:44:33.987	7	1
8	2016-02-22 12:44:34.861	2016-02-22 12:44:34.861	8	1
9	2016-02-22 12:45:11.11	2016-02-22 12:45:11.11	4	2
10	2016-02-22 12:45:12.731	2016-02-22 12:45:12.731	5	2
11	2016-02-22 12:45:18.662	2016-02-22 12:45:18.662	8	2
12	2016-02-22 12:45:19.841	2016-02-22 12:45:19.841	3	2
13	2016-02-22 12:45:30.059	2016-02-22 12:45:30.059	4	3
14	2016-02-22 12:45:36.157	2016-02-22 12:45:36.157	5	3
\.


--
-- Name: acl_organization_links_organizations_user_roles_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('acl_organization_links_organizations_user_roles_seq', 1, false);


--
-- Name: acl_organization_links_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('acl_organization_links_seq', 1, false);


--
-- Data for Name: activities; Type: TABLE DATA; Schema: public; Owner: -
--

COPY activities (id, created, modified, board_id, list_id, card_id, user_id, foreign_id, type, comment, revisions, root, freshness_ts, depth, path, materialized_path, organization_id) FROM stdin;
\.


--
-- Name: activities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('activities_id_seq', 2, true);


--
-- Name: attachments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('attachments_id_seq', 1, false);


--
-- Data for Name: board_stars; Type: TABLE DATA; Schema: public; Owner: -
--

COPY board_stars (id, created, modified, board_id, user_id, is_starred) FROM stdin;
\.


--
-- Data for Name: board_subscribers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY board_subscribers (id, created, modified, board_id, user_id, is_subscribed) FROM stdin;
\.


--
-- Data for Name: board_user_roles; Type: TABLE DATA; Schema: public; Owner: -
--

COPY board_user_roles (id, created, modified, name, description) FROM stdin;
1	2016-02-22 17:39:17.68	2016-02-22 17:39:17.68	Owner	Can view and edit cards, remove members, and change settings for the board.
2	2016-02-22 17:39:17.68	2016-02-22 17:39:17.68	Editor	Can view and edit cards, remove members, but not change settings.
3	2016-02-22 17:39:17.68	2016-02-22 17:39:17.68	Viewer	Can view only.
\.


--
-- Name: board_user_roles_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('board_user_roles_seq', 1, false);


--
-- Data for Name: boards; Type: TABLE DATA; Schema: public; Owner: -
--

COPY boards (id, created, modified, user_id, organization_id, name, board_visibility, background_color, background_picture_url, commenting_permissions, voting_permissions, inivitation_permissions, is_closed, is_allow_organization_members_to_join, boards_user_count, list_count, card_count, boards_subscriber_count, background_pattern_url, boards_star_count, is_show_image_front_of_card, background_picture_path, music_name, music_content, archived_list_count, archived_card_count, default_email_list_id, is_default_email_position_as_bottom, custom_fields) FROM stdin;
\.


--
-- Name: boards_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('boards_id_seq', 2, true);


--
-- Name: boards_stars_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('boards_stars_id_seq', 1, false);


--
-- Name: boards_subscribers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('boards_subscribers_id_seq', 1, true);


--
-- Data for Name: boards_users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY boards_users (id, created, modified, board_id, user_id, board_user_role_id) FROM stdin;
\.


--
-- Name: boards_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('boards_users_id_seq', 2, true);


--
-- Data for Name: card_attachments; Type: TABLE DATA; Schema: public; Owner: -
--

COPY card_attachments (id, created, modified, card_id, name, path, list_id, board_id, mimetype, link) FROM stdin;
\.


--
-- Name: card_attachments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('card_attachments_id_seq', 1, true);


--
-- Data for Name: card_subscribers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY card_subscribers (id, created, modified, card_id, user_id, is_subscribed) FROM stdin;
\.


--
-- Data for Name: card_voters; Type: TABLE DATA; Schema: public; Owner: -
--

COPY card_voters (id, created, modified, card_id, user_id) FROM stdin;
\.


--
-- Name: card_voters_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('card_voters_id_seq', 1, true);


--
-- Data for Name: cards; Type: TABLE DATA; Schema: public; Owner: -
--

COPY cards (id, created, modified, board_id, list_id, name, description, due_date, "position", is_archived, attachment_count, checklist_count, checklist_item_count, checklist_item_completed_count, label_count, cards_user_count, cards_subscriber_count, card_voter_count, activity_count, user_id, is_deleted, comment_count, custom_fields) FROM stdin;
\.


--
-- Name: cards_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('cards_id_seq', 1, true);


--
-- Data for Name: cards_labels; Type: TABLE DATA; Schema: public; Owner: -
--

COPY cards_labels (id, created, modified, label_id, card_id, list_id, board_id) FROM stdin;
\.


--
-- Name: cards_labels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('cards_labels_id_seq', 1, true);


--
-- Name: cards_subscribers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('cards_subscribers_id_seq', 1, true);


--
-- Data for Name: cards_users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY cards_users (id, created, modified, card_id, user_id) FROM stdin;
\.


--
-- Name: cards_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('cards_users_id_seq', 1, true);


--
-- Data for Name: checklist_items; Type: TABLE DATA; Schema: public; Owner: -
--

COPY checklist_items (id, created, modified, user_id, card_id, checklist_id, name, is_completed, "position") FROM stdin;
\.


--
-- Name: checklist_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('checklist_items_id_seq', 1, true);


--
-- Data for Name: checklists; Type: TABLE DATA; Schema: public; Owner: -
--

COPY checklists (id, created, modified, user_id, card_id, name, checklist_item_count, checklist_item_completed_count, "position") FROM stdin;
\.


--
-- Name: checklists_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('checklists_id_seq', 1, true);


--
-- Data for Name: cities; Type: TABLE DATA; Schema: public; Owner: -
--

COPY cities (id, created, modified, country_id, state_id, latitude, longitude, name, is_active) FROM stdin;
1	2015-05-21 11:45:47.245	2015-05-21 11:45:47.245	102	1	20	77	undefined	f
\.


--
-- Name: cities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('cities_id_seq', 15178, false);


--
-- Name: cities_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('cities_id_seq1', 1, true);


--
-- Data for Name: countries; Type: TABLE DATA; Schema: public; Owner: -
--

COPY countries (id, iso_alpha2, iso_alpha3, iso_numeric, fips_code, name, capital, areainsqkm, population, continent, tld, currency, currencyname, phone, postalcodeformat, postalcoderegex, languages, geonameid, neighbours, equivalentfipscode, created, iso2, iso3, modified) FROM stdin;
1	AF	AFG	4	AF	Afghanistan	Kabul	647500	29121286	AS	.af	AFN	Afghani             	93        	                    	                    	fa-AF,ps,uz-AF,tk	1149361	TM,CN,IR,TJ,PK,UZ   	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
2	AX	ALA	248		Aland Islands	Mariehamn	0	26711	EU	.ax	EUR	Euro                	+358-18   	                    	                    	sv-AX	661882	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
4	DZ	DZA	12	AG	Algeria	Algiers	2381740	34586184	AF	.dz	DZD	Dinar               	213       	#####               	^(d{5})$            	ar-DZ	2589581	NE,EH,LY,MR,TN,MA,ML	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
5	AS	ASM	16	AQ	American Samoa	Pago Pago	199	57881	OC	.as	USD	Dollar              	+1-684    	                    	                    	en-AS,sm,to	5880801	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
6	AD	AND	20	AN	Andorra	Andorra la Vella	468	84000	EU	.ad	EUR	Euro                	376       	AD###               	^(?:AD)*(d{3})$     	ca	3041565	ES,FR               	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
7	AO	AGO	24	AO	Angola	Luanda	1246700	13068161	AF	.ao	AOA	Kwanza              	244       	                    	                    	pt-AO	3351879	CD,NA,ZM,CG         	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
8	AI	AIA	660	AV	Anguilla	The Valley	102	13254	NA	.ai	XCD	Dollar              	+1-264    	                    	                    	en-AI	3573511	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
9	AQ	ATA	10	AY	Antarctica		14000000	0	AN	.aq	   	                    	          	                    	                    		6697173	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
10	AG	ATG	28	AC	Antigua and Barbuda	St. John's	443	86754	NA	.ag	XCD	Dollar              	+1-268    	                    	                    	en-AG	3576396	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
11	AR	ARG	32	AR	Argentina	Buenos Aires	2766890	41343201	SA	.ar	ARS	Peso                	54        	@####@@@            	^([A-Z]d{4}[A-Z]{3})	es-AR,en,it,de,fr,gn	3865483	CL,BO,UY,PY,BR      	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
12	AM	ARM	51	AM	Armenia	Yerevan	29800	2968000	AS	.am	AMD	Dram                	374       	######              	^(d{6})$            	hy	174982	GE,IR,AZ,TR         	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
13	AW	ABW	533	AA	Aruba	Oranjestad	193	71566	NA	.aw	AWG	Guilder             	297       	                    	                    	nl-AW,es,en	3577279	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
14	AU	AUS	36	AS	Australia	Canberra	7686850	21515754	OC	.au	AUD	Dollar              	61        	####                	^(d{4})$            	en-AU	2077456	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
15	AT	AUT	40	AU	Austria	Vienna	83858	8205000	EU	.at	EUR	Euro                	43        	####                	^(d{4})$            	de-AT,hr,hu,sl	2782113	CH,DE,HU,SK,CZ,IT,SI	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
16	AZ	AZE	31	AJ	Azerbaijan	Baku	86600	8303512	AS	.az	AZN	Manat               	994       	AZ ####             	^(?:AZ)*(d{4})$     	az,ru,hy	587116	GE,IR,AM,TR,RU      	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
17	BS	BHS	44	BF	Bahamas	Nassau	13940	301790	NA	.bs	BSD	Dollar              	+1-242    	                    	                    	en-BS	3572887	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
18	BH	BHR	48	BA	Bahrain	Manama	665	738004	AS	.bh	BHD	Dinar               	973       	####|###            	^(d{3}d?)$          	ar-BH,en,fa,ur	290291	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
19	BD	BGD	50	BG	Bangladesh	Dhaka	144000	156118464	AS	.bd	BDT	Taka                	880       	####                	^(d{4})$            	bn-BD,en	1210997	MM,IN               	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
20	BB	BRB	52	BB	Barbados	Bridgetown	431	285653	NA	.bb	BBD	Dollar              	+1-246    	BB#####             	^(?:BB)*(d{5})$     	en-BB	3374084	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
21	BY	BLR	112	BO	Belarus	Minsk	207600	9685000	EU	.by	BYR	Ruble               	375       	######              	^(d{6})$            	be,ru	630336	PL,LT,UA,RU,LV      	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
22	BE	BEL	56	BE	Belgium	Brussels	30510	10403000	EU	.be	EUR	Euro                	32        	####                	^(d{4})$            	nl-BE,fr-BE,de-BE	2802361	DE,NL,LU,FR         	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
23	BZ	BLZ	84	BH	Belize	Belmopan	22966	314522	NA	.bz	BZD	Dollar              	501       	                    	                    	en-BZ,es	3582678	GT,MX               	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
24	BJ	BEN	204	BN	Benin	Porto-Novo	112620	9056010	AF	.bj	XOF	Franc               	229       	                    	                    	fr-BJ	2395170	NE,TG,BF,NG         	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
25	BM	BMU	60	BD	Bermuda	Hamilton	53	65365	NA	.bm	BMD	Dollar              	+1-441    	@@ ##               	^([A-Z]{2}d{2})$    	en-BM,pt	3573345	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
26	BT	BTN	64	BT	Bhutan	Thimphu	47000	699847	AS	.bt	BTN	Ngultrum            	975       	                    	                    	dz	1252634	CN,IN               	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
27	BO	BOL	68	BL	Bolivia	Sucre	1098580	9947418	SA	.bo	BOB	Boliviano           	591       	                    	                    	es-BO,qu,ay	3923057	PE,CL,PY,BR,AR      	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
28	BQ	BES	535		Bonaire, Saint Eustatius and Saba 		0	18012	NA	.bq	USD	Dollar              	599       	                    	                    	nl,pap,en	7626844	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
29	BA	BIH	70	BK	Bosnia and Herzegovina	Sarajevo	51129	4590000	EU	.ba	BAM	Marka               	387       	#####               	^(d{5})$            	bs,hr-BA,sr-BA	3277605	CS,HR,ME,RS         	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
30	BW	BWA	72	BC	Botswana	Gaborone	600370	2029307	AF	.bw	BWP	Pula                	267       	                    	                    	en-BW,tn-BW	933860	ZW,ZA,NA            	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
31	BV	BVT	74	BV	Bouvet Island		0	0	AN	.bv	NOK	Krone               	          	                    	                    		3371123	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
33	IO	IOT	86	IO	British Indian Ocean Territory	Diego Garcia	60	4000	AS	.io	USD	Dollar              	246       	                    	                    	en-IO	1282588	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
34	VG	VGB	92	VI	British Virgin Islands	Road Town	153	21730	NA	.vg	USD	Dollar              	+1-284    	                    	                    	en-VG	3577718	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
35	BN	BRN	96	BX	Brunei	Bandar Seri Begawan	5770	395027	AS	.bn	BND	Dollar              	673       	@@####              	^([A-Z]{2}d{4})$    	ms-BN,en-BN	1820814	MY                  	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
36	BG	BGR	100	BU	Bulgaria	Sofia	110910	7148785	EU	.bg	BGN	Lev                 	359       	####                	^(d{4})$            	bg,tr-BG	732800	MK,GR,RO,CS,TR,RS   	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
37	BF	BFA	854	UV	Burkina Faso	Ouagadougou	274200	16241811	AF	.bf	XOF	Franc               	226       	                    	                    	fr-BF	2361809	NE,BJ,GH,CI,TG,ML   	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
38	BI	BDI	108	BY	Burundi	Bujumbura	27830	9863117	AF	.bi	BIF	Franc               	257       	                    	                    	fr-BI,rn	433561	TZ,CD,RW            	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
39	KH	KHM	116	CB	Cambodia	Phnom Penh	181040	14453680	AS	.kh	KHR	Riels               	855       	#####               	^(d{5})$            	km,fr,en	1831722	LA,TH,VN            	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
40	CM	CMR	120	CM	Cameroon	Yaounde	475440	19294149	AF	.cm	XAF	Franc               	237       	                    	                    	en-CM,fr-CM	2233387	TD,CF,GA,GQ,CG,NG   	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
41	CA	CAN	124	CA	Canada	Ottawa	9984670	33679000	NA	.ca	CAD	Dollar              	1         	@#@ #@#             	^([a-zA-Z]d[a-zA-Z]d	en-CA,fr-CA,iu	6251999	US                  	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
42	CV	CPV	132	CV	Cape Verde	Praia	4033	508659	AF	.cv	CVE	Escudo              	238       	####                	^(d{4})$            	pt-CV	3374766	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
43	KY	CYM	136	CJ	Cayman Islands	George Town	262	44270	NA	.ky	KYD	Dollar              	+1-345    	                    	                    	en-KY	3580718	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
44	CF	CAF	140	CT	Central African Republic	Bangui	622984	4844927	AF	.cf	XAF	Franc               	236       	                    	                    	fr-CF,sg,ln,kg	239880	TD,SD,CD,SS,CM,CG   	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
45	TD	TCD	148	CD	Chad	N'Djamena	1284000	10543464	AF	.td	XAF	Franc               	235       	                    	                    	fr-TD,ar-TD,sre	2434508	NE,LY,CF,SD,CM,NG   	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
46	CL	CHL	152	CI	Chile	Santiago	756950	16746491	SA	.cl	CLP	Peso                	56        	#######             	^(d{7})$            	es-CL	3895114	PE,BO,AR            	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
47	CN	CHN	156	CH	China	Beijing	9596960	1330044000	AS	.cn	CNY	Yuan Renminbi       	86        	######              	^(d{6})$            	zh-CN,yue,wuu,dta,ug,za	1814991	LA,BT,TJ,KZ,MN,AF,NP	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
48	CX	CXR	162	KT	Christmas Island	Flying Fish Cove	135	1500	AS	.cx	AUD	Dollar              	61        	####                	^(d{4})$            	en,zh,ms-CC	2078138	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
49	CC	CCK	166	CK	Cocos Islands	West Island	14	628	AS	.cc	AUD	Dollar              	61        	                    	                    	ms-CC,en	1547376	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
50	CO	COL	170	CO	Colombia	Bogota	1138910	44205293	SA	.co	COP	Peso                	57        	                    	                    	es-CO	3686110	EC,PE,PA,BR,VE      	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
51	KM	COM	174	CN	Comoros	Moroni	2170	773407	AF	.km	KMF	Franc               	269       	                    	                    	ar,fr-KM	921929	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
52	CK	COK	184	CW	Cook Islands	Avarua	240	21388	OC	.ck	NZD	Dollar              	682       	                    	                    	en-CK,mi	1899402	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
53	CR	CRI	188	CS	Costa Rica	San Jose	51100	4516220	NA	.cr	CRC	Colon               	506       	####                	^(d{4})$            	es-CR,en	3624060	PA,NI               	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
54	HR	HRV	191	HR	Croatia	Zagreb	56542	4491000	EU	.hr	HRK	Kuna                	385       	HR-#####            	^(?:HR)*(d{5})$     	hr-HR,sr	3202326	HU,SI,CS,BA,ME,RS   	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
55	CU	CUB	192	CU	Cuba	Havana	110860	11423000	NA	.cu	CUP	Peso                	53        	CP #####            	^(?:CP)*(d{5})$     	es-CU	3562981	US                  	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
56	CW	CUW	531	UC	Curacao	 Willemstad	0	141766	NA	.cw	ANG	Guilder             	599       	                    	                    	nl,pap	7626836	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
57	CY	CYP	196	CY	Cyprus	Nicosia	9250	1102677	EU	.cy	EUR	Euro                	357       	####                	^(d{4})$            	el-CY,tr-CY,en	146669	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
58	CZ	CZE	203	EZ	Czech Republic	Prague	78866	10476000	EU	.cz	CZK	Koruna              	420       	### ##              	^(d{5})$            	cs,sk	3077311	PL,DE,SK,AT         	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
59	CD	COD	180	CG	Democratic Republic of the Congo	Kinshasa	2345410	70916439	AF	.cd	CDF	Franc               	243       	                    	                    	fr-CD,ln,kg	203312	TZ,CF,SS,RW,ZM,BI,UG	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
60	DK	DNK	208	DA	Denmark	Copenhagen	43094	5484000	EU	.dk	DKK	Krone               	45        	####                	^(d{4})$            	da-DK,en,fo,de-DK	2623032	DE                  	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
61	DJ	DJI	262	DJ	Djibouti	Djibouti	23000	740528	AF	.dj	DJF	Franc               	253       	                    	                    	fr-DJ,ar,so-DJ,aa	223816	ER,ET,SO            	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
62	DM	DMA	212	DO	Dominica	Roseau	754	72813	NA	.dm	XCD	Dollar              	+1-767    	                    	                    	en-DM	3575830	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
63	DO	DOM	214	DR	Dominican Republic	Santo Domingo	48730	9823821	NA	.do	DOP	Peso                	+1-809 and	#####               	^(d{5})$            	es-DO	3508796	HT                  	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
64	TL	TLS	626	TT	East Timor	Dili	15007	1154625	OC	.tl	USD	Dollar              	670       	                    	                    	tet,pt-TL,id,en	1966436	ID                  	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
65	EC	ECU	218	EC	Ecuador	Quito	283560	14790608	SA	.ec	USD	Dollar              	593       	@####@              	^([a-zA-Z]d{4}[a-zA-	es-EC	3658394	PE,CO               	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
66	EG	EGY	818	EG	Egypt	Cairo	1001450	80471869	AF	.eg	EGP	Pound               	20        	#####               	^(d{5})$            	ar-EG,en,fr	357994	LY,SD,IL            	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
67	SV	SLV	222	ES	El Salvador	San Salvador	21040	6052064	NA	.sv	USD	Dollar              	503       	CP ####             	^(?:CP)*(d{4})$     	es-SV	3585968	GT,HN               	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
68	GQ	GNQ	226	EK	Equatorial Guinea	Malabo	28051	1014999	AF	.gq	XAF	Franc               	240       	                    	                    	es-GQ,fr	2309096	GA,CM               	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
69	ER	ERI	232	ER	Eritrea	Asmara	121320	5792984	AF	.er	ERN	Nakfa               	291       	                    	                    	aa-ER,ar,tig,kun,ti-ER	338010	ET,SD,DJ            	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
70	EE	EST	233	EN	Estonia	Tallinn	45226	1291170	EU	.ee	EUR	Euro                	372       	#####               	^(d{5})$            	et,ru	453733	RU,LV               	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
71	ET	ETH	231	ET	Ethiopia	Addis Ababa	1127127	88013491	AF	.et	ETB	Birr                	251       	####                	^(d{4})$            	am,en-ET,om-ET,ti-ET,so-ET,sid	337996	ER,KE,SD,SS,SO,DJ   	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
72	FK	FLK	238	FK	Falkland Islands	Stanley	12173	2638	SA	.fk	FKP	Pound               	500       	                    	                    	en-FK	3474414	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
73	FO	FRO	234	FO	Faroe Islands	Torshavn	1399	48228	EU	.fo	DKK	Krone               	298       	FO-###              	^(?:FO)*(d{3})$     	fo,da-FO	2622320	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
74	FJ	FJI	242	FJ	Fiji	Suva	18270	875983	OC	.fj	FJD	Dollar              	679       	                    	                    	en-FJ,fj	2205218	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
75	FI	FIN	246	FI	Finland	Helsinki	337030	5244000	EU	.fi	EUR	Euro                	358       	#####               	^(?:FI)*(d{5})$     	fi-FI,sv-FI,smn	660013	NO,RU,SE            	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
76	FR	FRA	250	FR	France	Paris	547030	64768389	EU	.fr	EUR	Euro                	33        	#####               	^(d{5})$            	fr-FR,frp,br,co,ca,eu,oc	3017382	CH,DE,BE,LU,IT,AD,MC	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
77	GF	GUF	254	FG	French Guiana	Cayenne	91000	195506	SA	.gf	EUR	Euro                	594       	#####               	^((97)|(98)3d{2})$  	fr-GF	3381670	SR,BR               	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
78	PF	PYF	258	FP	French Polynesia	Papeete	4167	270485	OC	.pf	XPF	Franc               	689       	#####               	^((97)|(98)7d{2})$  	fr-PF,ty	4030656	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
79	TF	ATF	260	FS	French Southern Territories	Port-aux-Francais	7829	140	AN	.tf	EUR	Euro                	          	                    	                    	fr	1546748	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
80	GA	GAB	266	GB	Gabon	Libreville	267667	1545255	AF	.ga	XAF	Franc               	241       	                    	                    	fr-GA	2400553	CM,GQ,CG            	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
81	GM	GMB	270	GA	Gambia	Banjul	11300	1593256	AF	.gm	GMD	Dalasi              	220       	                    	                    	en-GM,mnk,wof,wo,ff	2413451	SN                  	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
82	GE	GEO	268	GG	Georgia	Tbilisi	69700	4630000	AS	.ge	GEL	Lari                	995       	####                	^(d{4})$            	ka,ru,hy,az	614540	AM,AZ,TR,RU         	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
83	DE	DEU	276	GM	Germany	Berlin	357021	81802257	EU	.de	EUR	Euro                	49        	#####               	^(d{5})$            	de	2921044	CH,PL,NL,DK,BE,CZ,LU	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
84	GH	GHA	288	GH	Ghana	Accra	239460	24339838	AF	.gh	GHS	Cedi                	233       	                    	                    	en-GH,ak,ee,tw	2300660	CI,TG,BF            	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
85	GI	GIB	292	GI	Gibraltar	Gibraltar	6.5	27884	EU	.gi	GIP	Pound               	350       	                    	                    	en-GI,es,it,pt	2411586	ES                  	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
86	GR	GRC	300	GR	Greece	Athens	131940	11000000	EU	.gr	EUR	Euro                	30        	### ##              	^(d{5})$            	el-GR,en,fr	390903	AL,MK,TR,BG         	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
87	GL	GRL	304	GL	Greenland	Nuuk	2166086	56375	NA	.gl	DKK	Krone               	299       	####                	^(d{4})$            	kl,da-GL,en	3425505	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
88	GD	GRD	308	GJ	Grenada	St. George's	344	107818	NA	.gd	XCD	Dollar              	+1-473    	                    	                    	en-GD	3580239	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
89	GP	GLP	312	GP	Guadeloupe	Basse-Terre	1780	443000	NA	.gp	EUR	Euro                	590       	#####               	^((97)|(98)d{3})$   	fr-GP	3579143	AN                  	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
90	GU	GUM	316	GQ	Guam	Hagatna	549	159358	OC	.gu	USD	Dollar              	+1-671    	969##               	^(969d{2})$         	en-GU,ch-GU	4043988	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
91	GT	GTM	320	GT	Guatemala	Guatemala City	108890	13550440	NA	.gt	GTQ	Quetzal             	502       	#####               	^(d{5})$            	es-GT	3595528	MX,HN,BZ,SV         	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
92	GG	GGY	831	GK	Guernsey	St Peter Port	78	65228	EU	.gg	GBP	Pound               	+44-1481  	@# #@@|@## #@@|@@# #	^(([A-Z]d{2}[A-Z]{2}	en,fr	3042362	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
93	GN	GIN	324	GV	Guinea	Conakry	245857	10324025	AF	.gn	GNF	Franc               	224       	                    	                    	fr-GN	2420477	LR,SN,SL,CI,GW,ML   	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
94	GW	GNB	624	PU	Guinea-Bissau	Bissau	36120	1565126	AF	.gw	XOF	Franc               	245       	####                	^(d{4})$            	pt-GW,pov	2372248	SN,GN               	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
95	GY	GUY	328	GY	Guyana	Georgetown	214970	748486	SA	.gy	GYD	Dollar              	592       	                    	                    	en-GY	3378535	SR,BR,VE            	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
96	HT	HTI	332	HA	Haiti	Port-au-Prince	27750	9648924	NA	.ht	HTG	Gourde              	509       	HT####              	^(?:HT)*(d{4})$     	ht,fr-HT	3723988	DO                  	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
97	HM	HMD	334	HM	Heard Island and McDonald Islands		412	0	AN	.hm	AUD	Dollar              	          	                    	                    		1547314	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
98	HN	HND	340	HO	Honduras	Tegucigalpa	112090	7989415	NA	.hn	HNL	Lempira             	504       	@@####              	^([A-Z]{2}d{4})$    	es-HN	3608932	GT,NI,SV            	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
99	HK	HKG	344	HK	Hong Kong	Hong Kong	1092	6898686	AS	.hk	HKD	Dollar              	852       	                    	                    	zh-HK,yue,zh,en	1819730	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
100	HU	HUN	348	HU	Hungary	Budapest	93030	9930000	EU	.hu	HUF	Forint              	36        	####                	^(d{4})$            	hu-HU	719819	SK,SI,RO,UA,CS,HR,AT	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
101	IS	ISL	352	IC	Iceland	Reykjavik	103000	308910	EU	.is	ISK	Krona               	354       	###                 	^(d{3})$            	is,en,de,da,sv,no	2629691	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
102	IN	IND	356	IN	India	New Delhi	3287590	1173108018	AS	.in	INR	Rupee               	91        	######              	^(d{6})$            	en-IN,hi,bn,te,mr,ta,ur,gu,kn,ml,or,pa,as,bh,sat,ks,ne,sd,kok,doi,mni,sit,sa,fr,lus,inc	1269750	CN,NP,MM,BT,PK,BD   	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
103	ID	IDN	360	ID	Indonesia	Jakarta	1919440	242968342	AS	.id	IDR	Rupiah              	62        	#####               	^(d{5})$            	id,en,nl,jv	1643084	PG,TL,MY            	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
104	IR	IRN	364	IR	Iran	Tehran	1648000	76923300	AS	.ir	IRR	Rial                	98        	##########          	^(d{10})$           	fa-IR,ku	130758	TM,AF,IQ,AM,PK,AZ,TR	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
105	IQ	IRQ	368	IZ	Iraq	Baghdad	437072	29671605	AS	.iq	IQD	Dinar               	964       	#####               	^(d{5})$            	ar-IQ,ku,hy	99237	SY,SA,IR,JO,TR,KW   	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
106	IE	IRL	372	EI	Ireland	Dublin	70280	4622917	EU	.ie	EUR	Euro                	353       	                    	                    	en-IE,ga-IE	2963597	GB                  	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
107	IM	IMN	833	IM	Isle of Man	Douglas, Isle of Man	572	75049	EU	.im	GBP	Pound               	+44-1624  	@# #@@|@## #@@|@@# #	^(([A-Z]d{2}[A-Z]{2}	en,gv	3042225	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
108	IL	ISR	376	IS	Israel	Jerusalem	20770	7353985	AS	.il	ILS	Shekel              	972       	#####               	^(d{5})$            	he,ar-IL,en-IL,	294640	SY,JO,LB,EG,PS      	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
109	IT	ITA	380	IT	Italy	Rome	301230	60340328	EU	.it	EUR	Euro                	39        	#####               	^(d{5})$            	it-IT,de-IT,fr-IT,sc,ca,co,sl	3175395	CH,VA,SI,SM,FR,AT   	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
110	CI	CIV	384	IV	Ivory Coast	Yamoussoukro	322460	21058798	AF	.ci	XOF	Franc               	225       	                    	                    	fr-CI	2287781	LR,GH,GN,BF,ML      	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
111	JM	JAM	388	JM	Jamaica	Kingston	10991	2847232	NA	.jm	JMD	Dollar              	+1-876    	                    	                    	en-JM	3489940	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
113	JE	JEY	832	JE	Jersey	Saint Helier	116	90812	EU	.je	GBP	Pound               	+44-1534  	@# #@@|@## #@@|@@# #	^(([A-Z]d{2}[A-Z]{2}	en,pt	3042142	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
114	JO	JOR	400	JO	Jordan	Amman	92300	6407085	AS	.jo	JOD	Dinar               	962       	#####               	^(d{5})$            	ar-JO,en	248816	SY,SA,IQ,IL,PS      	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
115	KZ	KAZ	398	KZ	Kazakhstan	Astana	2717300	15340000	AS	.kz	KZT	Tenge               	7         	######              	^(d{6})$            	kk,ru	1522867	TM,CN,KG,UZ,RU      	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
116	KE	KEN	404	KE	Kenya	Nairobi	582650	40046566	AF	.ke	KES	Shilling            	254       	#####               	^(d{5})$            	en-KE,sw-KE	192950	ET,TZ,SS,SO,UG      	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
117	KI	KIR	296	KR	Kiribati	Tarawa	811	92533	OC	.ki	AUD	Dollar              	686       	                    	                    	en-KI,gil	4030945	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
118	XK	XKX	0	KV	Kosovo	Pristina	0	1800000	EU	   	EUR	Euro                	          	                    	                    	sq,sr	831053	RS,AL,MK,ME         	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
119	KW	KWT	414	KU	Kuwait	Kuwait City	17820	2789132	AS	.kw	KWD	Dinar               	965       	#####               	^(d{5})$            	ar-KW,en	285570	SA,IQ               	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
120	KG	KGZ	417	KG	Kyrgyzstan	Bishkek	198500	5508626	AS	.kg	KGS	Som                 	996       	######              	^(d{6})$            	ky,uz,ru	1527747	CN,TJ,UZ,KZ         	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
121	LA	LAO	418	LA	Laos	Vientiane	236800	6368162	AS	.la	LAK	Kip                 	856       	#####               	^(d{5})$            	lo,fr,en	1655842	CN,MM,KH,TH,VN      	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
122	LV	LVA	428	LG	Latvia	Riga	64589	2217969	EU	.lv	LVL	Lat                 	371       	LV-####             	^(?:LV)*(d{4})$     	lv,ru,lt	458258	LT,EE,BY,RU         	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
123	LB	LBN	422	LE	Lebanon	Beirut	10400	4125247	AS	.lb	LBP	Pound               	961       	#### ####|####      	^(d{4}(d{4})?)$     	ar-LB,fr-LB,en,hy	272103	SY,IL               	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
124	LS	LSO	426	LT	Lesotho	Maseru	30355	1919552	AF	.ls	LSL	Loti                	266       	###                 	^(d{3})$            	en-LS,st,zu,xh	932692	ZA                  	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
125	LR	LBR	430	LI	Liberia	Monrovia	111370	3685076	AF	.lr	LRD	Dollar              	231       	####                	^(d{4})$            	en-LR	2275384	SL,CI,GN            	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
126	LY	LBY	434	LY	Libya	Tripolis	1759540	6461454	AF	.ly	LYD	Dinar               	218       	                    	                    	ar-LY,it,en	2215636	TD,NE,DZ,SD,TN,EG   	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
127	LI	LIE	438	LS	Liechtenstein	Vaduz	160	35000	EU	.li	CHF	Franc               	423       	####                	^(d{4})$            	de-LI	3042058	CH,AT               	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
128	LT	LTU	440	LH	Lithuania	Vilnius	65200	3565000	EU	.lt	LTL	Litas               	370       	LT-#####            	^(?:LT)*(d{5})$     	lt,ru,pl	597427	PL,BY,RU,LV         	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
129	LU	LUX	442	LU	Luxembourg	Luxembourg	2586	497538	EU	.lu	EUR	Euro                	352       	####                	^(d{4})$            	lb,de-LU,fr-LU	2960313	DE,BE,FR            	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
130	MO	MAC	446	MC	Macao	Macao	254	449198	AS	.mo	MOP	Pataca              	853       	                    	                    	zh,zh-MO,pt	1821275	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
131	MK	MKD	807	MK	Macedonia	Skopje	25333	2061000	EU	.mk	MKD	Denar               	389       	####                	^(d{4})$            	mk,sq,tr,rmm,sr	718075	AL,GR,CS,BG,RS,XK   	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
132	MG	MDG	450	MA	Madagascar	Antananarivo	587040	21281844	AF	.mg	MGA	Ariary              	261       	###                 	^(d{3})$            	fr-MG,mg	1062947	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
133	MW	MWI	454	MI	Malawi	Lilongwe	118480	15447500	AF	.mw	MWK	Kwacha              	265       	                    	                    	ny,yao,tum,swk	927384	TZ,MZ,ZM            	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
134	MY	MYS	458	MY	Malaysia	Kuala Lumpur	329750	28274729	AS	.my	MYR	Ringgit             	60        	#####               	^(d{5})$            	ms-MY,en,zh,ta,te,ml,pa,th	1733045	BN,TH,ID            	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
135	MV	MDV	462	MV	Maldives	Male	300	395650	AS	.mv	MVR	Rufiyaa             	960       	#####               	^(d{5})$            	dv,en	1282028	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
136	ML	MLI	466	ML	Mali	Bamako	1240000	13796354	AF	.ml	XOF	Franc               	223       	                    	                    	fr-ML,bm	2453866	SN,NE,DZ,CI,GN,MR,BF	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
137	MT	MLT	470	MT	Malta	Valletta	316	403000	EU	.mt	EUR	Euro                	356       	@@@ ###|@@@ ##      	^([A-Z]{3}d{2}d?)$  	mt,en-MT	2562770	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
138	MH	MHL	584	RM	Marshall Islands	Majuro	181.30000000000001	65859	OC	.mh	USD	Dollar              	692       	                    	                    	mh,en-MH	2080185	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
139	MQ	MTQ	474	MB	Martinique	Fort-de-France	1100	432900	NA	.mq	EUR	Euro                	596       	#####               	^(d{5})$            	fr-MQ	3570311	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
140	MR	MRT	478	MR	Mauritania	Nouakchott	1030700	3205060	AF	.mr	MRO	Ouguiya             	222       	                    	                    	ar-MR,fuc,snk,fr,mey,wo	2378080	SN,DZ,EH,ML         	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
141	MU	MUS	480	MP	Mauritius	Port Louis	2040	1294104	AF	.mu	MUR	Rupee               	230       	                    	                    	en-MU,bho,fr	934292	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
142	YT	MYT	175	MF	Mayotte	Mamoudzou	374	159042	AF	.yt	EUR	Euro                	262       	#####               	^(d{5})$            	fr-YT	1024031	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
143	MX	MEX	484	MX	Mexico	Mexico City	1972550	112468855	NA	.mx	MXN	Peso                	52        	#####               	^(d{5})$            	es-MX	3996063	GT,US,BZ            	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
144	FM	FSM	583	FM	Micronesia	Palikir	702	107708	OC	.fm	USD	Dollar              	691       	#####               	^(d{5})$            	en-FM,chk,pon,yap,kos,uli,woe,nkr,kpg	2081918	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
145	MD	MDA	498	MD	Moldova	Chisinau	33843	4324000	EU	.md	MDL	Leu                 	373       	MD-####             	^(?:MD)*(d{4})$     	ro,ru,gag,tr	617790	RO,UA               	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
146	MC	MCO	492	MN	Monaco	Monaco	1.95	32965	EU	.mc	EUR	Euro                	377       	#####               	^(d{5})$            	fr-MC,en,it	2993457	FR                  	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
147	MN	MNG	496	MG	Mongolia	Ulan Bator	1565000	3086918	AS	.mn	MNT	Tugrik              	976       	######              	^(d{6})$            	mn,ru	2029969	CN,RU               	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
148	ME	MNE	499	MJ	Montenegro	Podgorica	14026	666730	EU	.me	EUR	Euro                	382       	#####               	^(d{5})$            	sr,hu,bs,sq,hr,rom	3194884	AL,HR,BA,RS,XK      	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
149	MS	MSR	500	MH	Montserrat	Plymouth	102	9341	NA	.ms	XCD	Dollar              	+1-664    	                    	                    	en-MS	3578097	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
150	MA	MAR	504	MO	Morocco	Rabat	446550	31627428	AF	.ma	MAD	Dirham              	212       	#####               	^(d{5})$            	ar-MA,fr	2542007	DZ,EH,ES            	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
151	MZ	MOZ	508	MZ	Mozambique	Maputo	801590	22061451	AF	.mz	MZN	Metical             	258       	####                	^(d{4})$            	pt-MZ,vmw	1036973	ZW,TZ,SZ,ZA,ZM,MW   	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
152	MM	MMR	104	BM	Myanmar	Nay Pyi Taw	678500	53414374	AS	.mm	MMK	Kyat                	95        	#####               	^(d{5})$            	my	1327865	CN,LA,TH,BD,IN      	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
153	NA	NAM	516	WA	Namibia	Windhoek	825418	2128471	AF	.na	NAD	Dollar              	264       	                    	                    	en-NA,af,de,hz,naq	3355338	ZA,BW,ZM,AO         	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
154	NR	NRU	520	NR	Nauru	Yaren	21	10065	OC	.nr	AUD	Dollar              	674       	                    	                    	na,en-NR	2110425	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
155	NP	NPL	524	NP	Nepal	Kathmandu	140800	28951852	AS	.np	NPR	Rupee               	977       	#####               	^(d{5})$            	ne,en	1282988	CN,IN               	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
156	NL	NLD	528	NL	Netherlands	Amsterdam	41526	16645000	EU	.nl	EUR	Euro                	31        	#### @@             	^(d{4}[A-Z]{2})$    	nl-NL,fy-NL	2750405	DE,BE               	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
157	AN	ANT	530	NT	Netherlands Antilles	Willemstad	960	136197	NA	.an	ANG	Guilder             	599       	                    	                    	nl-AN,en,es	0	GP                  	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
158	NC	NCL	540	NC	New Caledonia	Noumea	19060	216494	OC	.nc	XPF	Franc               	687       	#####               	^(d{5})$            	fr-NC	2139685	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
159	NZ	NZL	554	NZ	New Zealand	Wellington	268680	4252277	OC	.nz	NZD	Dollar              	64        	####                	^(d{4})$            	en-NZ,mi	2186224	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
160	NI	NIC	558	NU	Nicaragua	Managua	129494	5995928	NA	.ni	NIO	Cordoba             	505       	###-###-#           	^(d{7})$            	es-NI,en	3617476	CR,HN               	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
161	NE	NER	562	NG	Niger	Niamey	1267000	15878271	AF	.ne	XOF	Franc               	227       	####                	^(d{4})$            	fr-NE,ha,kr,dje	2440476	TD,BJ,DZ,LY,BF,NG,ML	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
162	NG	NGA	566	NI	Nigeria	Abuja	923768	154000000	AF	.ng	NGN	Naira               	234       	######              	^(d{6})$            	en-NG,ha,yo,ig,ff	2328926	TD,NE,BJ,CM         	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
163	NU	NIU	570	NE	Niue	Alofi	260	2166	OC	.nu	NZD	Dollar              	683       	                    	                    	niu,en-NU	4036232	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
164	NF	NFK	574	NF	Norfolk Island	Kingston	34.600000000000001	1828	OC	.nf	AUD	Dollar              	672       	                    	                    	en-NF	2155115	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
165	KP	PRK	408	KN	North Korea	Pyongyang	120540	22912177	AS	.kp	KPW	Won                 	850       	###-###             	^(d{6})$            	ko-KP	1873107	CN,KR,RU            	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
166	MP	MNP	580	CQ	Northern Mariana Islands	Saipan	477	53883	OC	.mp	USD	Dollar              	+1-670    	                    	                    	fil,tl,zh,ch-MP,en-MP	4041468	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
167	NO	NOR	578	NO	Norway	Oslo	324220	4985870	EU	.no	NOK	Krone               	47        	####                	^(d{4})$            	no,nb,nn,se,fi	3144096	FI,RU,SE            	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
168	OM	OMN	512	MU	Oman	Muscat	212460	2967717	AS	.om	OMR	Rial                	968       	###                 	^(d{3})$            	ar-OM,en,bal,ur	286963	SA,YE,AE            	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
169	PK	PAK	586	PK	Pakistan	Islamabad	803940	184404791	AS	.pk	PKR	Rupee               	92        	#####               	^(d{5})$            	ur-PK,en-PK,pa,sd,ps,brh	1168579	CN,AF,IR,IN         	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
170	PW	PLW	585	PS	Palau	Melekeok	458	19907	OC	.pw	USD	Dollar              	680       	96940               	^(96940)$           	pau,sov,en-PW,tox,ja,fil,zh	1559582	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
171	PS	PSE	275	WE	Palestinian Territory	East Jerusalem	5970	3800000	AS	.ps	ILS	Shekel              	970       	                    	                    	ar-PS	6254930	JO,IL               	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
172	PA	PAN	591	PM	Panama	Panama City	78200	3410676	NA	.pa	PAB	Balboa              	507       	                    	                    	es-PA,en	3703430	CR,CO               	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
173	PG	PNG	598	PP	Papua New Guinea	Port Moresby	462840	6064515	OC	.pg	PGK	Kina                	675       	###                 	^(d{3})$            	en-PG,ho,meu,tpi	2088628	ID                  	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
174	PY	PRY	600	PA	Paraguay	Asuncion	406750	6375830	SA	.py	PYG	Guarani             	595       	####                	^(d{4})$            	es-PY,gn	3437598	BO,BR,AR            	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
175	PE	PER	604	PE	Peru	Lima	1285220	29907003	SA	.pe	PEN	Sol                 	51        	                    	                    	es-PE,qu,ay	3932488	EC,CL,BO,BR,CO      	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
176	PH	PHL	608	RP	Philippines	Manila	300000	99900177	AS	.ph	PHP	Peso                	63        	####                	^(d{4})$            	tl,en-PH,fil	1694008	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
177	PN	PCN	612	PC	Pitcairn	Adamstown	47	46	OC	.pn	NZD	Dollar              	870       	                    	                    	en-PN	4030699	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
178	PL	POL	616	PL	Poland	Warsaw	312685	38500000	EU	.pl	PLN	Zloty               	48        	##-###              	^(d{5})$            	pl	798544	DE,LT,SK,CZ,BY,UA,RU	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
179	PT	PRT	620	PO	Portugal	Lisbon	92391	10676000	EU	.pt	EUR	Euro                	351       	####-###            	^(d{7})$            	pt-PT,mwl	2264397	ES                  	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
180	PR	PRI	630	RQ	Puerto Rico	San Juan	9104	3916632	NA	.pr	USD	Dollar              	+1-787 and	#####-####          	^(d{9})$            	en-PR,es-PR	4566966	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
181	QA	QAT	634	QA	Qatar	Doha	11437	840926	AS	.qa	QAR	Rial                	974       	                    	                    	ar-QA,es	289688	SA                  	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
182	CG	COG	178	CF	Republic of the Congo	Brazzaville	342000	3039126	AF	.cg	XAF	Franc               	242       	                    	                    	fr-CG,kg,ln-CG	2260494	CF,GA,CD,CM,AO      	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
183	RE	REU	638	RE	Reunion	Saint-Denis	2517	776948	AF	.re	EUR	Euro                	262       	#####               	^((97)|(98)(4|7|8)d{	fr-RE	935317	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
184	RO	ROU	642	RO	Romania	Bucharest	237500	21959278	EU	.ro	RON	Leu                 	40        	######              	^(d{6})$            	ro,hu,rom	798549	MD,HU,UA,CS,BG,RS   	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
185	RU	RUS	643	RS	Russia	Moscow	17100000	140702000	EU	.ru	RUB	Ruble               	7         	######              	^(d{6})$            	ru,tt,xal,cau,ady,kv,ce,tyv,cv,udm,tut,mns,bua,myv,mdf,chm,ba,inh,tut,kbd,krc,ava,sah,nog	2017370	GE,CN,BY,UA,KZ,LV,PL	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
186	RW	RWA	646	RW	Rwanda	Kigali	26338	11055976	AF	.rw	RWF	Franc               	250       	                    	                    	rw,en-RW,fr-RW,sw	49518	TZ,CD,BI,UG         	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
187	BL	BLM	652	TB	Saint Barthelemy	Gustavia	21	8450	NA	.gp	EUR	Euro                	590       	### ###             	                    	fr	3578476	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
188	SH	SHN	654	SH	Saint Helena	Jamestown	410	7460	AF	.sh	SHP	Pound               	290       	STHL 1ZZ            	^(STHL1ZZ)$         	en-SH	3370751	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
189	KN	KNA	659	SC	Saint Kitts and Nevis	Basseterre	261	49898	NA	.kn	XCD	Dollar              	+1-869    	                    	                    	en-KN	3575174	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
190	LC	LCA	662	ST	Saint Lucia	Castries	616	160922	NA	.lc	XCD	Dollar              	+1-758    	                    	                    	en-LC	3576468	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
191	MF	MAF	663	RN	Saint Martin	Marigot	53	35925	NA	.gp	EUR	Euro                	590       	### ###             	                    	fr	3578421	SX                  	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
192	PM	SPM	666	SB	Saint Pierre and Miquelon	Saint-Pierre	242	7012	NA	.pm	EUR	Euro                	508       	#####               	^(97500)$           	fr-PM	3424932	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
193	VC	VCT	670	VC	Saint Vincent and the Grenadines	Kingstown	389	104217	NA	.vc	XCD	Dollar              	+1-784    	                    	                    	en-VC,fr	3577815	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
194	WS	WSM	882	WS	Samoa	Apia	2944	192001	OC	.ws	WST	Tala                	685       	                    	                    	sm,en-WS	4034894	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
195	SM	SMR	674	SM	San Marino	San Marino	61.200000000000003	31477	EU	.sm	EUR	Euro                	378       	4789#               	^(4789d)$           	it-SM	3168068	IT                  	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
196	ST	STP	678	TP	Sao Tome and Principe	Sao Tome	1001	175808	AF	.st	STD	Dobra               	239       	                    	                    	pt-ST	2410758	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
197	SA	SAU	682	SA	Saudi Arabia	Riyadh	1960582	25731776	AS	.sa	SAR	Rial                	966       	#####               	^(d{5})$            	ar-SA	102358	QA,OM,IQ,YE,JO,AE,KW	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
198	SN	SEN	686	SG	Senegal	Dakar	196190	12323252	AF	.sn	XOF	Franc               	221       	#####               	^(d{5})$            	fr-SN,wo,fuc,mnk	2245662	GN,MR,GW,GM,ML      	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
199	RS	SRB	688	RI	Serbia	Belgrade	88361	7344847	EU	.rs	RSD	Dinar               	381       	######              	^(d{6})$            	sr,hu,bs,rom	6290252	AL,HU,MK,RO,HR,BA,BG	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
200	CS	SCG	891	YI	Serbia and Montenegro	Belgrade	102350	10829175	EU	.cs	RSD	Dinar               	381       	#####               	^(d{5})$            	cu,hu,sq,sr	0	AL,HU,MK,RO,HR,BA,BG	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
201	SC	SYC	690	SE	Seychelles	Victoria	455	88340	AF	.sc	SCR	Rupee               	248       	                    	                    	en-SC,fr-SC	241170	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
202	SL	SLE	694	SL	Sierra Leone	Freetown	71740	5245695	AF	.sl	SLL	Leone               	232       	                    	                    	en-SL,men,tem	2403846	LR,GN               	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
203	SG	SGP	702	SN	Singapore	Singapur	692.70000000000005	4701069	AS	.sg	SGD	Dollar              	65        	######              	^(d{6})$            	cmn,en-SG,ms-SG,ta-SG,zh-SG	1880251	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
204	SX	SXM	534	NN	Sint Maarten	Philipsburg	0	37429	NA	.sx	ANG	Guilder             	599       	                    	                    	nl,en	7609695	MF                  	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
205	SK	SVK	703	LO	Slovakia	Bratislava	48845	5455000	EU	.sk	EUR	Euro                	421       	###  ##             	^(d{5})$            	sk,hu	3057568	PL,HU,CZ,UA,AT      	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
206	SI	SVN	705	SI	Slovenia	Ljubljana	20273	2007000	EU	.si	EUR	Euro                	386       	SI- ####            	^(?:SI)*(d{4})$     	sl,sh	3190538	HU,IT,HR,AT         	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
207	SB	SLB	90	BP	Solomon Islands	Honiara	28450	559198	OC	.sb	SBD	Dollar              	677       	                    	                    	en-SB,tpi	2103350	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
208	SO	SOM	706	SO	Somalia	Mogadishu	637657	10112453	AF	.so	SOS	Shilling            	252       	@@  #####           	^([A-Z]{2}d{5})$    	so-SO,ar-SO,it,en-SO	51537	ET,KE,DJ            	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
209	ZA	ZAF	710	SF	South Africa	Pretoria	1219912	49000000	AF	.za	ZAR	Rand                	27        	####                	^(d{4})$            	zu,xh,af,nso,en-ZA,tn,st,ts,ss,ve,nr	953987	ZW,SZ,MZ,BW,NA,LS   	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
210	GS	SGS	239	SX	South Georgia and the South Sandwich Islands	Grytviken	3903	30	AN	.gs	GBP	Pound               	          	                    	                    	en	3474415	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
211	KR	KOR	410	KS	South Korea	Seoul	98480	48422644	AS	.kr	KRW	Won                 	82        	SEOUL ###-###       	^(?:SEOUL)*(d{6})$  	ko-KR,en	1835841	KP                  	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
212	SS	SSD	728	OD	South Sudan	Juba	644329	8260490	AF	   	SSP	Pound               	211       	                    	                    	en	7909807	CD,CF,ET,KE,SD,UG,  	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
213	ES	ESP	724	SP	Spain	Madrid	504782	46505963	EU	.es	EUR	Euro                	34        	#####               	^(d{5})$            	es-ES,ca,gl,eu,oc	2510769	AD,PT,GI,FR,MA      	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
214	LK	LKA	144	CE	Sri Lanka	Colombo	65610	21513990	AS	.lk	LKR	Rupee               	94        	#####               	^(d{5})$            	si,ta,en	1227603	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
215	SD	SDN	729	SU	Sudan	Khartoum	1861484	35000000	AF	.sd	SDG	Pound               	249       	#####               	^(d{5})$            	ar-SD,en,fia	366755	SS,TD,EG,ET,ER,LY,CF	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
216	SR	SUR	740	NS	Suriname	Paramaribo	163270	492829	SA	.sr	SRD	Dollar              	597       	                    	                    	nl-SR,en,srn,hns,jv	3382998	GY,BR,GF            	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
217	SJ	SJM	744	SV	Svalbard and Jan Mayen	Longyearbyen	62049	2550	EU	.sj	NOK	Krone               	47        	                    	                    	no,ru	607072	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
218	SZ	SWZ	748	WZ	Swaziland	Mbabane	17363	1354051	AF	.sz	SZL	Lilangeni           	268       	@###                	^([A-Z]d{3})$       	en-SZ,ss-SZ	934841	ZA,MZ               	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
219	SE	SWE	752	SW	Sweden	Stockholm	449964	9045000	EU	.se	SEK	Krona               	46        	SE-### ##           	^(?:SE)*(d{5})$     	sv-SE,se,sma,fi-SE	2661886	NO,FI               	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
220	CH	CHE	756	SZ	Switzerland	Berne	41290	7581000	EU	.ch	CHF	Franc               	41        	####                	^(d{4})$            	de-CH,fr-CH,it-CH,rm	2658434	DE,IT,LI,FR,AT      	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
221	SY	SYR	760	SY	Syria	Damascus	185180	22198110	AS	.sy	SYP	Pound               	963       	                    	                    	ar-SY,ku,hy,arc,fr,en	163843	IQ,JO,IL,TR,LB      	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
222	TW	TWN	158	TW	Taiwan	Taipei	35980	22894384	AS	.tw	TWD	Dollar              	886       	#####               	^(d{5})$            	zh-TW,zh,nan,hak	1668284	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
223	TJ	TJK	762	TI	Tajikistan	Dushanbe	143100	7487489	AS	.tj	TJS	Somoni              	992       	######              	^(d{6})$            	tg,ru	1220409	CN,AF,KG,UZ         	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
224	TZ	TZA	834	TZ	Tanzania	Dodoma	945087	41892895	AF	.tz	TZS	Shilling            	255       	                    	                    	sw-TZ,en,ar	149590	MZ,KE,CD,RW,ZM,BI,UG	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
225	TH	THA	764	TH	Thailand	Bangkok	514000	67089500	AS	.th	THB	Baht                	66        	#####               	^(d{5})$            	th,en	1605651	LA,MM,KH,MY         	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
226	TG	TGO	768	TO	Togo	Lome	56785	6587239	AF	.tg	XOF	Franc               	228       	                    	                    	fr-TG,ee,hna,kbp,dag,ha	2363686	BJ,GH,BF            	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
227	TK	TKL	772	TL	Tokelau		10	1466	OC	.tk	NZD	Dollar              	690       	                    	                    	tkl,en-TK	4031074	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
228	TO	TON	776	TN	Tonga	Nuku'alofa	748	122580	OC	.to	TOP	Pa'anga             	676       	                    	                    	to,en-TO	4032283	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
229	TT	TTO	780	TD	Trinidad and Tobago	Port of Spain	5128	1228691	NA	.tt	TTD	Dollar              	+1-868    	                    	                    	en-TT,hns,fr,es,zh	3573591	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
230	TN	TUN	788	TS	Tunisia	Tunis	163610	10589025	AF	.tn	TND	Dinar               	216       	####                	^(d{4})$            	ar-TN,fr	2464461	DZ,LY               	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
231	TR	TUR	792	TU	Turkey	Ankara	780580	77804122	AS	.tr	TRY	Lira                	90        	#####               	^(d{5})$            	tr-TR,ku,diq,az,av	298795	SY,GE,IQ,IR,GR,AM,AZ	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
232	TM	TKM	795	TX	Turkmenistan	Ashgabat	488100	4940916	AS	.tm	TMT	Manat               	993       	######              	^(d{6})$            	tk,ru,uz	1218197	AF,IR,UZ,KZ         	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
234	TV	TUV	798	TV	Tuvalu	Funafuti	26	10472	OC	.tv	AUD	Dollar              	688       	                    	                    	tvl,en,sm,gil	2110297	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
235	VI	VIR	850	VQ	U.S. Virgin Islands	Charlotte Amalie	352	108708	NA	.vi	USD	Dollar              	+1-340    	                    	                    	en-VI	4796775	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
236	UG	UGA	800	UG	Uganda	Kampala	236040	33398682	AF	.ug	UGX	Shilling            	256       	                    	                    	en-UG,lg,sw,ar	226074	TZ,KE,SS,CD,RW      	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
237	UA	UKR	804	UP	Ukraine	Kiev	603700	45415596	EU	.ua	UAH	Hryvnia             	380       	#####               	^(d{5})$            	uk,ru-UA,rom,pl,hu	690791	PL,MD,HU,SK,BY,RO,RU	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
238	AE	ARE	784	AE	United Arab Emirates	Abu Dhabi	82880	4975593	AS	.ae	AED	Dirham              	971       	                    	                    	ar-AE,fa,en,hi,ur	290557	SA,OM               	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
241	UM	UMI	581		United States Minor Outlying Islands		0	0	OC	.um	USD	Dollar              	1         	                    	                    	en-UM	5854968	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
242	UY	URY	858	UY	Uruguay	Montevideo	176220	3477000	SA	.uy	UYU	Peso                	598       	#####               	^(d{5})$            	es-UY	3439705	BR,AR               	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
243	UZ	UZB	860	UZ	Uzbekistan	Tashkent	447400	27865738	AS	.uz	UZS	Som                 	998       	######              	^(d{6})$            	uz,ru,tg	1512440	TM,AF,KG,TJ,KZ      	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
244	VU	VUT	548	NH	Vanuatu	Port Vila	12200	221552	OC	.vu	VUV	Vatu                	678       	                    	                    	bi,en-VU,fr-VU	2134431	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
245	VA	VAT	336	VT	Vatican	Vatican City	0.44	921	EU	.va	EUR	Euro                	379       	                    	                    	la,it,fr	3164670	IT                  	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
246	VE	VEN	862	VE	Venezuela	Caracas	912050	27223228	SA	.ve	VEF	Bolivar             	58        	####                	^(d{4})$            	es-VE	3625428	GY,BR,CO            	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
247	VN	VNM	704	VM	Vietnam	Hanoi	329560	89571130	AS	.vn	VND	Dong                	84        	######              	^(d{6})$            	vi,en,fr,zh,km	1562822	CN,LA,KH            	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
248	WF	WLF	876	WF	Wallis and Futuna	Mata Utu	274	16025	OC	.wf	XPF	Franc               	681       	#####               	^(986d{2})$         	wls,fud,fr-WF	4034749	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
250	YE	YEM	887	YM	Yemen	Sanaa	527970	23495361	AS	.ye	YER	Rial                	967       	                    	                    	ar-YE	69543	SA,OM               	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
251	ZM	ZMB	894	ZA	Zambia	Lusaka	752614	13460305	AF	.zm	ZMK	Kwacha              	260       	#####               	^(d{5})$            	en-ZM,bem,loz,lun,lue,ny,toi	895949	ZW,TZ,MZ,CD,NA,MW,AO	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
3	AL	ALB	8	AL	Albania	Tirana	28748	2986952	EU	.al	ALL	Lek                 	355       	                    	                    	sq,el	783754	MK,GR,CS,ME,RS,XK   	          	2013-02-07 10:11:00	2	3	2013-04-11 16:15:53.73
32	BR	BRA	76	BR	Brazil	Brasilia	8511965	201103330	SA	.br	BRL	Real                	55        	#####-###           	^(d{8})$            	pt-BR,es,en,fr	3469034	SR,PE,BO,UY,GY,PY,GF	          	2013-02-07 10:11:00	BR	BRZ	2013-09-19 14:52:25.866
112	JP	JPN	392	JA	Japan	Tokyo	377835	127288000	AS	.jp	JPY	Yen                 	81        	###-####            	^(d{7})$            	ja	1861060	                    	          	2013-02-07 10:11:00	JA	JAP	2013-09-19 14:53:54.835
239	GB	GBR	826	UK	United Kingdom	London	244820	62348447	EU	.uk	GBP	Pound               	44        	@# #@@|@## #@@|@@# #	^(([A-Z]d{2}[A-Z]{2}	en-GB,cy-GB,gd	2635167	IE                  	          	2013-02-07 10:11:00	UK	UKS	2013-09-19 14:55:04.538
252	ZW	ZWE	716	ZI	Zimbabwe	Harare	390580	0	AF	.zw	ZWL	Dollar              	263       	                    	                    	en-ZW,sn,nr,nd	878675	ZA,MZ,BW,ZM         	          	2013-02-07 10:11:00	\N	\N	2013-11-19 14:03:16.283
240	US	USA	840	US	United States	Washington	9629091	310232863	NA	.us	USD	Dollar              	1         	#####-####          	^(d{9})$            	en-US,es-US,haw,fr	6252001	CA,MX,CU            	          	2013-02-07 10:11:00	US	USA	2013-09-19 16:10:20.878
\.


--
-- Name: countries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('countries_id_seq', 262, false);


--
-- Name: countries_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('countries_id_seq1', 1, false);


--
-- Data for Name: email_templates; Type: TABLE DATA; Schema: public; Owner: -
--

COPY email_templates (id, created, modified, from_email, reply_to_email, name, description, subject, email_text_content, email_variables, display_name) FROM stdin;
2	2014-05-08 12:14:07.472	2014-05-08 12:14:07.472	##SITE_NAME## Restyaboard <##FROM_EMAIL##>	##REPLY_TO_EMAIL##	welcome	We will send this mail, when user register in this site and get activate.	Restyaboard / Welcome	<html>\r\n<head></head>\r\n<body style="margin:0">\r\n<header style="display:block;width:100%;padding-left:0;padding-right:0; border-bottom:solid 1px #dedede; float:left;background-color: #f7f7f7;">\r\n<div style="border: 1px solid #EEEEEE;">\r\n<h1 style="text-align:center;margin:10px 15px 5px;"> <a href="##SITE_URL##" title="##SITE_NAME##"><img src="##SITE_URL##/img/logo.png" alt="[Restyaboard]" title="##SITE_NAME##"></a> </h1>\r\n</div>\r\n</header>\r\n<main style="width:100%;padding-top:10px; padding-bottom:10px; margin:0 auto; float:left;">\r\n<div style="background-color:#f3f5f7;padding:10px;border: 1px solid #EEEEEE;">\r\n<div style="width: 500px;background-color: #f3f5f7;margin:0 auto;">\r\n<pre style="font-family: Arial, Helvetica, sans-serif; font-size: 13px;line-height:20px;"><h2 style="font-size:16px; font-family:Arial, Helvetica, sans-serif; margin: 20px 0px 0px;padding:10px 0px 0px 0px;">Hi ##NAME##,</h2><p style="white-space: normal; width: 100%;margin: 10px 0px 0px; font-family:Arial, Helvetica, sans-serif;"><br></p><p style="white-space: normal; width: 100%;margin: 0px 0px 0px; font-family:Arial, Helvetica, sans-serif;">We wish to say a quick hello and thanks for registering at ##SITE_NAME##.<br>If you didn't create a ##SITE_NAME## account and feel this is an error, please contact us at ##CONTACT_EMAIL##.<br></p><br><p style="white-space: normal; width: 100%;margin: 0px 0px 0px;font-family:Arial, Helvetica, sans-serif;">Thanks,<br>\r\nRestyaboard<br>\r\n##SITE_URL##</p>\r\n</pre>\r\n</div>\r\n</div>\r\n</main>\r\n<footer style="width:100%;padding-left:0;margin:0px auto;border-top: solid 1px #dedede; padding-bottom:10px; background:#fff;clear: both;padding-top: 10px;border-bottom: solid 1px #dedede;background-color: #f7f7f7;">\r\n<h6 style="text-align:center;margin:5px 15px;"> \r\n<a href="http://restya.com/board/?utm_source=Restyaboard - ##SITE_NAME##&utm_medium=email&utm_campaign=welcome_email" title="Open source. Trello like kanban board." rel="generator" style="font-size: 11px;text-align: center;text-decoration: none;color: #000;font-family: arial; padding-left:10px;">Powered by Restyaboard</a></h6>\r\n</footer>\r\n</body>\r\n</html>	SITE_URL, SITE_NAME, CONTACT_EMAIL, NAME	Welcome
4	2014-05-08 12:13:50.69	2014-05-08 12:13:50.69	##SITE_NAME## Restyaboard <##FROM_EMAIL##>	##REPLY_TO_EMAIL##	changepassword	We will send this mail to user, when admin change users password.	Restyaboard / Password changed	<html>\r\n<head></head>\r\n<body style="margin:0">\r\n<header style="display:block;width:100%;padding-left:0;padding-right:0; border-bottom:solid 1px #dedede; float:left;background-color: #f7f7f7;">\r\n<div style="border: 1px solid #EEEEEE;">\r\n<h1 style="text-align:center;margin:10px 15px 5px;"> <a href="##SITE_URL##" title="##SITE_NAME##"><img src="##SITE_URL##/img/logo.png" alt="[Restyaboard]" title="##SITE_NAME##"></a> </h1>\r\n</div>\r\n</header>\r\n<main style="width:100%;padding-top:10px; padding-bottom:10px; margin:0 auto; float:left;">\r\n<div style="background-color:#f3f5f7;padding:10px;border: 1px solid #EEEEEE;">\r\n<div style="width: 500px;background-color: #f3f5f7;margin:0 auto;">\r\n<pre style="font-family: Arial, Helvetica, sans-serif; font-size: 13px;line-height:20px;"><h2 style="font-size:16px; font-family:Arial, Helvetica, sans-serif; margin: 20px 0px 0px;padding:10px 0px 0px 0px;">Hi,</h2><p style="white-space: normal; width: 100%;margin: 10px 0px 0px; font-family:Arial, Helvetica, sans-serif;"><br></p><p style="white-space: normal; width: 100%;margin: 0px 0px 0px; font-family:Arial, Helvetica, sans-serif;">Admin reset your password for your ##SITE_NAME## account.<br>Your new password: ##PASSWORD##<br></p><br><p style="white-space: normal; width: 100%;margin: 0px 0px 0px;font-family:Arial, Helvetica, sans-serif;">Thanks,<br>\r\nRestyaboard<br>\r\n##SITE_URL##</p>\r\n</pre>\r\n</div>\r\n</div>\r\n</main>\r\n<footer style="width:100%;padding-left:0;margin:0px auto;border-top: solid 1px #dedede; padding-bottom:10px; background:#fff;clear: both;padding-top: 10px;border-bottom: solid 1px #dedede;background-color: #f7f7f7;">\r\n<h6 style="text-align:center;margin:5px 15px;"> \r\n<a href="http://restya.com/board/?utm_source=Restyaboard - ##SITE_NAME##&utm_medium=email&utm_campaign=change_password_email" title="Open source. Trello like kanban board." rel="generator" style="font-size: 11px;text-align: center;text-decoration: none;color: #000;font-family: arial; padding-left:10px;">Powered by Restyaboard</a></h6>\r\n</footer>\r\n</body>\r\n</html>	SITE_NAME, SITE_URL, PASSWORD	Change Password
5	2014-05-08 12:14:07.472	2014-05-08 12:14:07.472	##SITE_NAME## Restyaboard <##FROM_EMAIL##>	##REPLY_TO_EMAIL##	newprojectuser	We will send this mail, when user added for board.	Restyaboard / ##BOARD_NAME## assigned by ##CURRENT_USER##	<html>\r\n<head></head>\r\n<body style="margin:0">\r\n<header style="display:block;width:100%;padding-left:0;padding-right:0; border-bottom:solid 1px #dedede; float:left;background-color: #f7f7f7;">\r\n<div style="border: 1px solid #EEEEEE;">\r\n<h1 style="text-align:center;margin:10px 15px 5px;"> <a href="##SITE_URL##" title="##SITE_NAME##"><img src="##SITE_URL##/img/logo.png" alt="[Restyaboard]" title="##SITE_NAME##"></a> </h1>\r\n</div>\r\n</header>\r\n<main style="width:100%;padding-top:10px; padding-bottom:10px; margin:0 auto; float:left;">\r\n<div style="background-color:#f3f5f7;padding:10px;border: 1px solid #EEEEEE;">\r\n<div style="width: 500px;background-color: #f3f5f7;margin:0 auto;">\r\n<pre style="font-family: Arial, Helvetica, sans-serif; font-size: 13px;line-height:20px;"><h2 style="font-size:16px; font-family:Arial, Helvetica, sans-serif; margin: 20px 0px 0px;padding:10px 0px 0px 0px;">Hi ##NAME##,</h2>\r\n<p style="white-space: normal; width: 100%;margin: 0px 0px 0px; font-family:Arial, Helvetica, sans-serif;">##CURRENT_USER## has added you to the board ##BOARD_NAME## ##BOARD_URL##<br></p><br><p style="white-space: normal; width: 100%;margin: 0px 0px 0px;font-family:Arial, Helvetica, sans-serif;">Thanks,<br>\r\nRestyaboard<br>\r\n##SITE_URL##</p>\r\n</pre>\r\n</div>\r\n</div>\r\n</main>\r\n<footer style="width:100%;padding-left:0;margin:0px auto;border-top: solid 1px #dedede; padding-bottom:10px; background:#fff;clear: both;padding-top: 10px;border-bottom: solid 1px #dedede;background-color: #f7f7f7;">\r\n<h6 style="text-align:center;margin:5px 15px;"> \r\n<a href="http://restya.com/board/?utm_source=Restyaboard - ##SITE_NAME##&utm_medium=email&utm_campaign=new_board_member_email" title="Open source. Trello like kanban board." rel="generator" style="font-size: 11px;text-align: center;text-decoration: none;color: #000;font-family: arial; padding-left:10px;">Powered by Restyaboard</a></h6>\r\n</footer>\r\n</body>\r\n</html>	SITE_URL, SITE_NAME, NAME, BOARD_NAME, CURRENT_USER, BOARD_URL	New Board User
6	2015-10-09 06:15:49.891	2015-10-09 06:15:49.891	##SITE_NAME## Restyaboard <##FROM_EMAIL##>	##REPLY_TO_EMAIL##	email_notification	We will send this mail, when user activities in this site.	Restyaboard / ##NOTIFICATION_COUNT## new notifications since ##SINCE##	<html>\r\n<head></head>\r\n<body style="margin:0">\r\n<header style="display:block;width:100%;padding-left:0;padding-right:0; border-bottom:solid 1px #dedede; float:left;background-color: #f7f7f7;">\r\n<div style="border: 1px solid #EEEEEE;">\r\n<h1 style="text-align:center;margin:10px 15px 5px;"> <a href="##SITE_URL##" title="Restyaboard"><img src="##SITE_URL##/img/logo.png" alt="[Restyaboard]" title="Restyaboard"></a> </h1>\r\n</div>\r\n</header>\r\n<main style="width:100%;padding-top:10px; padding-bottom:10px; margin:0 auto; float:left;">\r\n<div style="background-color:#f3f5f7;padding:10px;border: 1px solid #EEEEEE;">\r\n<div style="width: 500px;background-color: #f3f5f7;margin:0 auto;">\r\n<div style="font-family: Arial, Helvetica, sans-serif; font-size: 13px;line-height:20px;margin-top:30px;"><h2 style="font-size:16px; font-family:Arial, Helvetica, sans-serif; margin: 7px 0px 0px 43px;padding:35px 0px 0px 0px;">Here's what you missed…</h2>\r\n<div style="white-space: normal; width: 100%;margin: 10px 0px 0px; font-family:Arial, Helvetica, sans-serif;">##CONTENT##</div>\r\n</div>\r\n</div>\r\n</div>\r\n<div style="text-align:center;margin:5px 15px;padding:10px 0px;">\r\n<a href="##SITE_URL##/#/user/##USER_ID##/settings">Change email preferences</a>\r\n</div>\r\n</main>\r\n<footer style="width:100%;padding-left:0;margin:0px auto;border-top: solid 1px #dedede; padding-bottom:10px; background:#fff;clear: both;padding-top: 10px;border-bottom: solid 1px #dedede;background-color: #f7f7f7;">\r\n<h6 style="text-align:center;margin:5px 15px;"> \r\n<a href="http://restya.com/board/?utm_source=Restyaboard - ##SITE_NAME##&utm_medium=email&utm_campaign=notification_email" title="Open source. Trello like kanban board." rel="generator" style="font-size: 11px;text-align: center;text-decoration: none;color: #000;font-family: arial; padding-left:10px;">Powered by Restyaboard</a>\r\n</h6>\r\n</footer>\r\n</body>\r\n</html>	SITE_URL, SITE_NAME, CONTENT, NAME, NOTIFICATION_COUNT, SINCE	Email Notification
1	2014-05-08 12:13:37.268	2014-05-08 12:13:37.268	##SITE_NAME## Restyaboard <##FROM_EMAIL##>	##REPLY_TO_EMAIL##	activation	We will send this mail, when user registering an account he/she will get an activation request.	Restyaboard / Account confirmation	<html>\r\n<head></head>\r\n<body style="margin:0">\r\n<header style="display:block;width:100%;padding-left:0;padding-right:0; border-bottom:solid 1px #dedede; float:left;background-color: #f7f7f7;">\r\n<div style="border: 1px solid #EEEEEE;">\r\n<h1 style="text-align:center;margin:10px 15px 5px;"> <a href="##SITE_URL##" title="##SITE_NAME##"><img src="##SITE_URL##/img/logo.png" alt="[Restyaboard]" title="##SITE_NAME##"></a> </h1>\r\n</div>\r\n</header>\r\n<main style="width:100%;padding-top:10px; padding-bottom:10px; margin:0 auto; float:left;">\r\n<div style="background-color:#f3f5f7;padding:10px;border: 1px solid #EEEEEE;">\r\n<div style="width: 500px;background-color: #f3f5f7;margin:0 auto;">\r\n<pre style="font-family: Arial, Helvetica, sans-serif; font-size: 13px;line-height:20px;"><h2 style="font-size:16px; font-family:Arial, Helvetica, sans-serif; margin: 20px 0px 0px;padding:10px 0px 0px 0px;">Hi ##NAME##,\r\n</h2><p style="white-space: normal; width: 100%;margin: 10px 0px 0px; font-family:Arial, Helvetica, sans-serif;"><br></p><p style="white-space: normal; width: 100%;margin: 0px 0px 0px; font-family:Arial, Helvetica, sans-serif;">You are one step ahead. Please click the below URL to activate your account.<br>##ACTIVATION_URL##<br>If you didn't create a ##SITE_NAME## account and feel this is an error, please contact us at ##CONTACT_EMAIL##.<br></p><br><p style="white-space: normal; width: 100%;margin: 0px 0px 0px;font-family:Arial, Helvetica, sans-serif;">Thanks,<br>\r\nRestyaboard<br>\r\n##SITE_URL##</p>\r\n</pre>\r\n</div>\r\n</div>\r\n</main>\r\n<footer style="width:100%;padding-left:0;margin:0px auto;border-top: solid 1px #dedede; padding-bottom:10px; background:#fff;clear: both;padding-top: 10px;border-bottom: solid 1px #dedede;background-color: #f7f7f7;">\r\n<h6 style="text-align:center;margin:5px 15px;"> \r\n<a href="http://restya.com/board/?utm_source=Restyaboard - ##SITE_NAME##&utm_medium=email&utm_campaign=activation_email" title="Open source. Trello like kanban board." rel="generator" style="font-size: 11px;text-align: center;text-decoration: none;color: #000;font-family: arial; padding-left:10px;">Powered by Restyaboard</a></h6>\r\n</footer>\r\n</body>\r\n</html>	SITE_URL, SITE_NAME, CONTACT_EMAIL, NAME, ACTIVATION_URL	Activation
3	2014-05-08 12:13:59.784	2014-05-08 12:13:59.784	##SITE_NAME## Restyaboard <##FROM_EMAIL##>	##REPLY_TO_EMAIL##	forgetpassword	We will send this mail, when user submit the forgot password form	Restyaboard / Password reset	<html>\r\n<head></head>\r\n<body style="margin:0">\r\n<header style="display:block;width:100%;padding-left:0;padding-right:0; border-bottom:solid 1px #dedede; float:left;background-color: #f7f7f7;">\r\n<div style="border: 1px solid #EEEEEE;">\r\n<h1 style="text-align:center;margin:10px 15px 5px;"> <a href="##SITE_URL##" title="##SITE_NAME##"><img src="##SITE_URL##/img/logo.png" alt="[Restyaboard]" title="##SITE_NAME##"></a> </h1>\r\n</div>\r\n</header>\r\n<main style="width:100%;padding-top:10px; padding-bottom:10px; margin:0 auto; float:left;">\r\n<div style="background-color:#f3f5f7;padding:10px;border: 1px solid #EEEEEE;">\r\n<div style="width: 500px;background-color: #f3f5f7;margin:0 auto;">\r\n<pre style="font-family: Arial, Helvetica, sans-serif; font-size: 13px;line-height:20px;"><h2 style="font-size:16px; font-family:Arial, Helvetica, sans-serif; margin: 20px 0px 0px;padding:10px 0px 0px 0px;">Hi ##NAME##,</h2><p style="white-space: normal; width: 100%;margin: 10px 0px 0px; font-family:Arial, Helvetica, sans-serif;"><br></p><p style="white-space: normal; width: 100%;margin: 0px 0px 0px; font-family:Arial, Helvetica, sans-serif;">We have received a password reset request for your account at ##SITE_NAME##.<br>New password: ##PASSWORD##<br>If you didn't requested this action and feel this is an error, please contact us at ##CONTACT_EMAIL##.<br></p><br><p style="white-space: normal; width: 100%;margin: 0px 0px 0px;font-family:Arial, Helvetica, sans-serif;">Thanks,<br>\r\nRestyaboard<br>\r\n##SITE_URL##</p>\r\n</pre>\r\n</div>\r\n</div>\r\n</main>\r\n<footer style="width:100%;padding-left:0;margin:0px auto;border-top: solid 1px #dedede; padding-bottom:10px; background:#fff;clear: both;padding-top: 10px;border-bottom: solid 1px #dedede;background-color: #f7f7f7;">\r\n<h6 style="text-align:center;margin:5px 15px;"> \r\n<a href="http://restya.com/board/?utm_source=Restyaboard - ##SITE_NAME##&utm_medium=email&utm_campaign=forgot_password_email" title="Open source. Trello like kanban board." rel="generator" style="font-size: 11px;text-align: center;text-decoration: none;color: #000;font-family: arial; padding-left:10px;">Powered by Restyaboard</a></h6>\r\n</footer>\r\n</body>\r\n</html>	SITE_NAME, SITE_URL, CONTACT_EMAIL, NAME, PASSWORD	Forgot Password
7	2016-01-10 06:15:49.891	2016-01-10 06:15:49.891	##SITE_NAME## Restyaboard <##FROM_EMAIL##>	##REPLY_TO_EMAIL##	due_date_notification	We will send this mail, One day before when the card due date end.	##SUBJECT##	<html>\r\n<head></head>\r\n<body style="margin:0">\r\n<header style="display:block;width:100%;padding-left:0;padding-right:0; border-bottom:solid 1px #dedede; float:left;background-color: #f7f7f7;">\r\n<div style="border: 1px solid #EEEEEE;">\r\n<h1 style="text-align:center;margin:10px 15px 5px;"> <a href="##SITE_URL##" title="##SITE_NAME##"><img src="##SITE_URL##/img/logo.png" alt="[Restyaboard]" title="##SITE_NAME##"></a> </h1>\r\n</div>\r\n</header>\r\n<main style="width:100%;padding-top:10px; padding-bottom:10px; margin:0 auto; float:left;">\r\n<div style="background-color:#f3f5f7;padding:10px;border: 1px solid #EEEEEE;">\r\n<div style="width: 500px;background-color: #f3f5f7;margin:0 auto;">\r\n<pre style="font-family: Arial, Helvetica, sans-serif; font-size: 13px;line-height:20px;">\r\n<h2 style="font-size:16px; font-family:Arial, Helvetica, sans-serif; margin: 7px 0px 0px 43px;padding:35px 0px 0px 0px;">Due soon…</h2>\r\n<p style="white-space: normal; width: 100%;margin: 10px 0px 0px; font-family:Arial, Helvetica, sans-serif;">##CONTENT##</p>\r\n</pre>\r\n</div>\r\n</div>\r\n</main>\r\n<footer style="width:100%;padding-left:0;margin:0px auto;border-top: solid 1px #dedede; padding-bottom:10px; background:#fff;clear: both;padding-top: 10px;border-bottom: solid 1px #dedede;background-color: #f7f7f7;">\r\n<h6 style="text-align:center;margin:5px 15px;"> \r\n<a href="http://restya.com/board/?utm_source=Restyaboard - ##SITE_NAME##&utm_medium=email&utm_campaign=due_date_notification_email" title="Open source. Trello like kanban board." rel="generator" style="font-size: 11px;text-align: center;text-decoration: none;color: #000;font-family: arial; padding-left:10px;">Powered by Restyaboard</a>\r\n</h6>\r\n</footer>\r\n</body>\r\n</html>	SITE_URL, SITE_NAME, SUBJECT, CONTENT	Due Date Notification
\.


--
-- Name: email_templates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('email_templates_id_seq', 1, true);


--
-- Data for Name: ips; Type: TABLE DATA; Schema: public; Owner: -
--

COPY ips (id, created, modified, ip, host, user_agent, "order", city_id, state_id, country_id, latitude, longitude) FROM stdin;
1	2015-05-21 11:45:47.262	2015-05-21 11:45:47.262	::1	115.111.183.202	Mozilla/5.0 (Windows NT 6.3; WOW64; rv:38.0) Gecko/20100101 Firefox/38.0	0	1	1	102	20	77
\.


--
-- Name: ips_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('ips_id_seq', 1, true);


--
-- Data for Name: labels; Type: TABLE DATA; Schema: public; Owner: -
--

COPY labels (id, created, modified, name, card_count) FROM stdin;
\.


--
-- Name: labels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('labels_id_seq', 1, true);


--
-- Data for Name: languages; Type: TABLE DATA; Schema: public; Owner: -
--

COPY languages (id, created, modified, name, iso2, iso3, is_active) FROM stdin;
1	2016-03-10 16:24:44.693	2016-03-10 16:24:44.693	Acoli	ach	ach	0
2	2016-03-10 16:24:44.72	2016-03-10 16:24:44.72	Adyghe	ady	ady	0
3	2016-03-10 16:24:44.721	2016-03-10 16:24:44.721	Afrikaans	af	af	0
4	2016-03-10 16:24:44.721	2016-03-10 16:24:44.721	Afrikaans (South Africa)	af_ZA	af_ZA	0
5	2016-03-10 16:24:44.722	2016-03-10 16:24:44.722	Akan	ak	ak	0
6	2016-03-10 16:24:44.722	2016-03-10 16:24:44.722	Albanian	sq	sq	0
7	2016-03-10 16:24:44.723	2016-03-10 16:24:44.723	Albanian (Albania)	sq_AL	sq_AL	0
8	2016-03-10 16:24:44.723	2016-03-10 16:24:44.723	Albanian Gheg	aln	aln	0
9	2016-03-10 16:24:44.723	2016-03-10 16:24:44.723	Amharic	am	am	0
10	2016-03-10 16:24:44.724	2016-03-10 16:24:44.724	Amharic (Ethiopia)	am_ET	am_ET	0
11	2016-03-10 16:24:44.724	2016-03-10 16:24:44.724	Arabic	ar	ar	0
12	2016-03-10 16:24:44.725	2016-03-10 16:24:44.725	Arabic (Egypt)	ar_EG	ar_EG	0
13	2016-03-10 16:24:44.725	2016-03-10 16:24:44.725	Arabic (Saudi Arabia)	ar_SA	ar_SA	0
14	2016-03-10 16:24:44.725	2016-03-10 16:24:44.725	Arabic (Sudan)	ar_SD	ar_SD	0
15	2016-03-10 16:24:44.726	2016-03-10 16:24:44.726	Arabic (Syria)	ar_SY	ar_SY	0
16	2016-03-10 16:24:44.726	2016-03-10 16:24:44.726	Arabic (Unitag)	ar_AA	ar_AA	0
17	2016-03-10 16:24:44.727	2016-03-10 16:24:44.727	Aragonese	an	an	0
18	2016-03-10 16:24:44.727	2016-03-10 16:24:44.727	Armenian	hy	hy	0
19	2016-03-10 16:24:44.727	2016-03-10 16:24:44.727	Armenian (Armenia)	hy_AM	hy_AM	0
20	2016-03-10 16:24:44.728	2016-03-10 16:24:44.728	Assamese	as	as	0
21	2016-03-10 16:24:44.728	2016-03-10 16:24:44.728	Assamese (India)	as_IN	as_IN	0
22	2016-03-10 16:24:44.728	2016-03-10 16:24:44.728	Asturian	ast	ast	0
23	2016-03-10 16:24:44.729	2016-03-10 16:24:44.729	Asturian (Spain)	ast_ES	ast_ES	0
24	2016-03-10 16:24:44.729	2016-03-10 16:24:44.729	Azerbaijani	az	az	0
25	2016-03-10 16:24:44.729	2016-03-10 16:24:44.729	Azerbaijani (Arabic)	az@Arab	az@Arab	0
26	2016-03-10 16:24:44.729	2016-03-10 16:24:44.729	Azerbaijani (Azerbaijan)	az_AZ	az_AZ	0
27	2016-03-10 16:24:44.73	2016-03-10 16:24:44.73	Azerbaijani (Iran)	az_IR	az_IR	0
28	2016-03-10 16:24:44.73	2016-03-10 16:24:44.73	Azerbaijani (Latin)	az@latin	az@latin	0
29	2016-03-10 16:24:44.73	2016-03-10 16:24:44.73	Balochi	bal	bal	0
30	2016-03-10 16:24:44.731	2016-03-10 16:24:44.731	Bashkir	ba	ba	0
31	2016-03-10 16:24:44.732	2016-03-10 16:24:44.732	Basque	eu	eu	0
32	2016-03-10 16:24:44.732	2016-03-10 16:24:44.732	Basque (Spain)	eu_ES	eu_ES	0
33	2016-03-10 16:24:44.732	2016-03-10 16:24:44.732	Bavarian	bar	bar	0
34	2016-03-10 16:24:44.733	2016-03-10 16:24:44.733	Belarusian	be	be	0
35	2016-03-10 16:24:44.733	2016-03-10 16:24:44.733	Belarusian (Belarus)	be_BY	be_BY	0
36	2016-03-10 16:24:44.733	2016-03-10 16:24:44.733	Belarusian (Tarask)	be@tarask	be@tarask	0
37	2016-03-10 16:24:44.734	2016-03-10 16:24:44.734	Bengali	bn	bn	0
38	2016-03-10 16:24:44.734	2016-03-10 16:24:44.734	Bengali (Bangladesh)	bn_BD	bn_BD	0
39	2016-03-10 16:24:44.734	2016-03-10 16:24:44.734	Bengali (India)	bn_IN	bn_IN	0
40	2016-03-10 16:24:44.735	2016-03-10 16:24:44.735	Bodo	brx	brx	0
41	2016-03-10 16:24:44.735	2016-03-10 16:24:44.735	Bosnian	bs	bs	0
42	2016-03-10 16:24:44.735	2016-03-10 16:24:44.735	Bosnian (Bosnia and Herzegovina)	bs_BA	bs_BA	0
43	2016-03-10 16:24:44.736	2016-03-10 16:24:44.736	Breton	br	br	0
44	2016-03-10 16:24:44.736	2016-03-10 16:24:44.736	Bulgarian	bg	bg	0
45	2016-03-10 16:24:44.739	2016-03-10 16:24:44.739	Bulgarian (Bulgaria)	bg_BG	bg_BG	0
46	2016-03-10 16:24:44.739	2016-03-10 16:24:44.739	Burmese	my	my	0
47	2016-03-10 16:24:44.739	2016-03-10 16:24:44.739	Burmese (Myanmar)	my_MM	my_MM	0
48	2016-03-10 16:24:44.74	2016-03-10 16:24:44.74	Catalan	ca	ca	0
49	2016-03-10 16:24:44.74	2016-03-10 16:24:44.74	Catalan (Spain)	ca_ES	ca_ES	0
50	2016-03-10 16:24:44.74	2016-03-10 16:24:44.74	Catalan (Valencian)	ca@valencia	ca@valencia	0
51	2016-03-10 16:24:44.741	2016-03-10 16:24:44.741	Cebuano	ceb	ceb	0
52	2016-03-10 16:24:44.741	2016-03-10 16:24:44.741	Central Atlas Tamazight	tzm	tzm	0
53	2016-03-10 16:24:44.741	2016-03-10 16:24:44.741	Chhattisgarhi	hne	hne	0
54	2016-03-10 16:24:44.742	2016-03-10 16:24:44.742	Chiga	cgg	cgg	0
55	2016-03-10 16:24:44.742	2016-03-10 16:24:44.742	Chinese	zh	zh	0
56	2016-03-10 16:24:44.743	2016-03-10 16:24:44.743	Chinese (China)	zh_CN	zh_CN	0
57	2016-03-10 16:24:44.743	2016-03-10 16:24:44.743	Chinese (China) (GB2312)	zh_CN.GB2312	zh_CN.GB2312	0
58	2016-03-10 16:24:44.743	2016-03-10 16:24:44.743	Chinese (Gan)	gan	gan	0
59	2016-03-10 16:24:44.744	2016-03-10 16:24:44.744	Chinese (Hakka)	hak	hak	0
60	2016-03-10 16:24:44.744	2016-03-10 16:24:44.744	Chinese (Hong Kong)	zh_HK	zh_HK	0
61	2016-03-10 16:24:44.744	2016-03-10 16:24:44.744	Chinese (Huizhou)	czh	czh	0
62	2016-03-10 16:24:44.745	2016-03-10 16:24:44.745	Chinese (Jinyu)	cjy	cjy	0
63	2016-03-10 16:24:44.745	2016-03-10 16:24:44.745	Chinese (Literary)	lzh	lzh	0
64	2016-03-10 16:24:44.746	2016-03-10 16:24:44.746	Chinese (Mandarin)	cmn	cmn	0
65	2016-03-10 16:24:44.746	2016-03-10 16:24:44.746	Chinese (Min Bei)	mnp	mnp	0
66	2016-03-10 16:24:44.747	2016-03-10 16:24:44.747	Chinese (Min Dong)	cdo	cdo	0
67	2016-03-10 16:24:44.747	2016-03-10 16:24:44.747	Chinese (Min Nan)	nan	nan	0
68	2016-03-10 16:24:44.747	2016-03-10 16:24:44.747	Chinese (Min Zhong)	czo	czo	0
69	2016-03-10 16:24:44.748	2016-03-10 16:24:44.748	Chinese (Pu-Xian)	cpx	cpx	0
70	2016-03-10 16:24:44.748	2016-03-10 16:24:44.748	Chinese Simplified	zh-Hans	zh-Hans	0
71	2016-03-10 16:24:44.749	2016-03-10 16:24:44.749	Chinese (Taiwan)	zh_TW	zh_TW	0
72	2016-03-10 16:24:44.749	2016-03-10 16:24:44.749	Chinese (Taiwan) (Big5) 	zh_TW.Big5	zh_TW.Big5	0
73	2016-03-10 16:24:44.749	2016-03-10 16:24:44.749	Chinese Traditional	zh-Hant	zh-Hant	0
74	2016-03-10 16:24:44.75	2016-03-10 16:24:44.75	Chinese (Wu)	wuu	wuu	0
75	2016-03-10 16:24:44.75	2016-03-10 16:24:44.75	Chinese (Xiang)	hsn	hsn	0
76	2016-03-10 16:24:44.75	2016-03-10 16:24:44.75	Chinese (Yue)	yue	yue	0
77	2016-03-10 16:24:44.751	2016-03-10 16:24:44.751	Chuvash	cv	cv	0
78	2016-03-10 16:24:44.751	2016-03-10 16:24:44.751	Colognian	ksh	ksh	0
79	2016-03-10 16:24:44.751	2016-03-10 16:24:44.751	Cornish	kw	kw	0
80	2016-03-10 16:24:44.752	2016-03-10 16:24:44.752	Corsican	co	co	0
81	2016-03-10 16:24:44.752	2016-03-10 16:24:44.752	Crimean Turkish	crh	crh	0
82	2016-03-10 16:24:44.752	2016-03-10 16:24:44.752	Croatian	hr	hr	0
83	2016-03-10 16:24:44.752	2016-03-10 16:24:44.752	Croatian (Croatia)	hr_HR	hr_HR	0
84	2016-03-10 16:24:44.752	2016-03-10 16:24:44.752	Czech	cs	cs	0
85	2016-03-10 16:24:44.753	2016-03-10 16:24:44.753	Czech (Czech Republic)	cs_CZ	cs_CZ	0
86	2016-03-10 16:24:44.753	2016-03-10 16:24:44.753	Danish	da	da	0
87	2016-03-10 16:24:44.753	2016-03-10 16:24:44.753	Danish (Denmark)	da_DK	da_DK	0
88	2016-03-10 16:24:44.754	2016-03-10 16:24:44.754	Divehi	dv	dv	0
89	2016-03-10 16:24:44.754	2016-03-10 16:24:44.754	Dogri	doi	doi	0
90	2016-03-10 16:24:44.754	2016-03-10 16:24:44.754	Dutch	nl	nl	0
91	2016-03-10 16:24:44.755	2016-03-10 16:24:44.755	Dutch (Belgium)	nl_BE	nl_BE	0
92	2016-03-10 16:24:44.755	2016-03-10 16:24:44.755	Dutch (Netherlands)	nl_NL	nl_NL	0
93	2016-03-10 16:24:44.755	2016-03-10 16:24:44.755	Dzongkha	dz	dz	0
94	2016-03-10 16:24:44.756	2016-03-10 16:24:44.756	Dzongkha (Bhutan)	dz_BT	dz_BT	0
95	2016-03-10 16:24:44.756	2016-03-10 16:24:44.756	English (Australia)	en_AU	en_AU	0
96	2016-03-10 16:24:44.757	2016-03-10 16:24:44.757	English (Austria)	en_AT	en_AT	0
97	2016-03-10 16:24:44.757	2016-03-10 16:24:44.757	English (Bangladesh)	en_BD	en_BD	0
98	2016-03-10 16:24:44.757	2016-03-10 16:24:44.757	English (Belgium)	en_BE	en_BE	0
99	2016-03-10 16:24:44.758	2016-03-10 16:24:44.758	English (Canada)	en_CA	en_CA	0
100	2016-03-10 16:24:44.758	2016-03-10 16:24:44.758	English (Chile)	en_CL	en_CL	0
101	2016-03-10 16:24:44.759	2016-03-10 16:24:44.759	English (Croatia)	en_HR	en_HR	0
102	2016-03-10 16:24:44.76	2016-03-10 16:24:44.76	English (Czech Republic)	en_CZ	en_CZ	0
103	2016-03-10 16:24:44.76	2016-03-10 16:24:44.76	English (Egypt)	en_EG	en_EG	0
104	2016-03-10 16:24:44.761	2016-03-10 16:24:44.761	English (Estonia)	en_ee	en_ee	0
105	2016-03-10 16:24:44.761	2016-03-10 16:24:44.761	English (Finland)	en_FI	en_FI	0
106	2016-03-10 16:24:44.761	2016-03-10 16:24:44.761	English (Germany)	en_DE	en_DE	0
107	2016-03-10 16:24:44.762	2016-03-10 16:24:44.762	English (Ghana)	en_GH	en_GH	0
108	2016-03-10 16:24:44.762	2016-03-10 16:24:44.762	English (Greece)	en_GR	en_GR	0
109	2016-03-10 16:24:44.763	2016-03-10 16:24:44.763	English (Hong Kong)	en_HK	en_HK	0
110	2016-03-10 16:24:44.763	2016-03-10 16:24:44.763	English (Hungary)	en_HU	en_HU	0
111	2016-03-10 16:24:44.763	2016-03-10 16:24:44.763	English (India)	en_IN	en_IN	0
112	2016-03-10 16:24:44.764	2016-03-10 16:24:44.764	English (Ireland)	en_IE	en_IE	0
113	2016-03-10 16:24:44.764	2016-03-10 16:24:44.764	English (Italy)	en_IT	en_IT	0
114	2016-03-10 16:24:44.764	2016-03-10 16:24:44.764	English (Latvia)	en_lv	en_lv	0
115	2016-03-10 16:24:44.764	2016-03-10 16:24:44.764	English (Lithuania)	en_lt	en_lt	0
116	2016-03-10 16:24:44.764	2016-03-10 16:24:44.764	English (Netherlands)	en_NL	en_NL	0
117	2016-03-10 16:24:44.764	2016-03-10 16:24:44.764	English (New Zealand)	en_NZ	en_NZ	0
118	2016-03-10 16:24:44.766	2016-03-10 16:24:44.766	English (Nigeria)	en_NG	en_NG	0
119	2016-03-10 16:24:44.766	2016-03-10 16:24:44.766	English (Norway)	en_NO	en_NO	0
120	2016-03-10 16:24:44.766	2016-03-10 16:24:44.766	English (Pakistan)	en_PK	en_PK	0
121	2016-03-10 16:24:44.767	2016-03-10 16:24:44.767	English (Poland)	en_PL	en_PL	0
122	2016-03-10 16:24:44.767	2016-03-10 16:24:44.767	English (Portugal)	en_PT	en_PT	0
123	2016-03-10 16:24:44.767	2016-03-10 16:24:44.767	English (Romania)	en_RO	en_RO	0
124	2016-03-10 16:24:44.768	2016-03-10 16:24:44.768	English (Slovakia)	en_SK	en_SK	0
125	2016-03-10 16:24:44.768	2016-03-10 16:24:44.768	English (South Africa)	en_ZA	en_ZA	0
126	2016-03-10 16:24:44.768	2016-03-10 16:24:44.768	English (Spain)	en_ES	en_ES	0
127	2016-03-10 16:24:44.768	2016-03-10 16:24:44.768	English (Sri Lanka)	en_LK	en_LK	0
128	2016-03-10 16:24:44.768	2016-03-10 16:24:44.768	English (Sweden)	en_SE	en_SE	0
129	2016-03-10 16:24:44.768	2016-03-10 16:24:44.768	English (Switzerland)	en_CH	en_CH	0
130	2016-03-10 16:24:44.769	2016-03-10 16:24:44.769	English (United Kingdom)	en_GB	en_GB	0
131	2016-03-10 16:24:44.769	2016-03-10 16:24:44.769	English (United States)	en_US	en_US	0
132	2016-03-10 16:24:44.769	2016-03-10 16:24:44.769	Erzya	myv	myv	0
133	2016-03-10 16:24:44.77	2016-03-10 16:24:44.77	Esperanto	eo	eo	0
134	2016-03-10 16:24:44.77	2016-03-10 16:24:44.77	Estonian	et	et	0
135	2016-03-10 16:24:44.771	2016-03-10 16:24:44.771	Estonian (Estonia)	et_EE	et_EE	0
136	2016-03-10 16:24:44.771	2016-03-10 16:24:44.771	Faroese	fo	fo	0
137	2016-03-10 16:24:44.771	2016-03-10 16:24:44.771	Faroese (Faroe Islands)	fo_FO	fo_FO	0
138	2016-03-10 16:24:44.772	2016-03-10 16:24:44.772	Filipino	fil	fil	0
139	2016-03-10 16:24:44.772	2016-03-10 16:24:44.772	Finnish	fi	fi	0
140	2016-03-10 16:24:44.773	2016-03-10 16:24:44.773	Finnish (Finland)	fi_FI	fi_FI	0
141	2016-03-10 16:24:44.774	2016-03-10 16:24:44.774	Franco-Provencal (Arpitan)	frp	frp	0
142	2016-03-10 16:24:44.774	2016-03-10 16:24:44.774	French	fr	fr	0
143	2016-03-10 16:24:44.774	2016-03-10 16:24:44.774	French (Belgium)	fr_BE	fr_BE	0
144	2016-03-10 16:24:44.774	2016-03-10 16:24:44.774	French (Canada)	fr_CA	fr_CA	0
145	2016-03-10 16:24:44.774	2016-03-10 16:24:44.774	French (France)	fr_FR	fr_FR	0
146	2016-03-10 16:24:44.775	2016-03-10 16:24:44.775	French (Switzerland)	fr_CH	fr_CH	0
147	2016-03-10 16:24:44.775	2016-03-10 16:24:44.775	Friulian	fur	fur	0
148	2016-03-10 16:24:44.775	2016-03-10 16:24:44.775	Fulah	ff	ff	0
149	2016-03-10 16:24:44.777	2016-03-10 16:24:44.777	Fulah (Senegal)	ff_SN	ff_SN	0
150	2016-03-10 16:24:44.777	2016-03-10 16:24:44.777	Gaelic, Scottish	gd	gd	0
151	2016-03-10 16:24:44.777	2016-03-10 16:24:44.777	Galician	gl	gl	0
152	2016-03-10 16:24:44.778	2016-03-10 16:24:44.778	Galician (Spain)	gl_ES	gl_ES	0
153	2016-03-10 16:24:44.778	2016-03-10 16:24:44.778	Ganda	lg	lg	0
154	2016-03-10 16:24:44.778	2016-03-10 16:24:44.778	Georgian	ka	ka	0
155	2016-03-10 16:24:44.779	2016-03-10 16:24:44.779	Georgian (Georgia)	ka_GE	ka_GE	0
156	2016-03-10 16:24:44.779	2016-03-10 16:24:44.779	German	de	de	0
157	2016-03-10 16:24:44.779	2016-03-10 16:24:44.779	German (Austria)	de_AT	de_AT	0
158	2016-03-10 16:24:44.78	2016-03-10 16:24:44.78	German (Germany)	de_DE	de_DE	0
159	2016-03-10 16:24:44.78	2016-03-10 16:24:44.78	German (Switzerland)	de_CH	de_CH	0
160	2016-03-10 16:24:44.78	2016-03-10 16:24:44.78	Greek	el	el	0
161	2016-03-10 16:24:44.78	2016-03-10 16:24:44.78	Greek (Greece)	el_GR	el_GR	0
162	2016-03-10 16:24:44.78	2016-03-10 16:24:44.78	Greenlandic	kl	kl	0
163	2016-03-10 16:24:44.78	2016-03-10 16:24:44.78	Gujarati	gu	gu	0
164	2016-03-10 16:24:44.782	2016-03-10 16:24:44.782	Gujarati (India)	gu_IN	gu_IN	0
165	2016-03-10 16:24:44.782	2016-03-10 16:24:44.782	Gun	gun	gun	0
166	2016-03-10 16:24:44.782	2016-03-10 16:24:44.782	Haitian (Haitian Creole)	ht	ht	0
167	2016-03-10 16:24:44.783	2016-03-10 16:24:44.783	Haitian (Haitian Creole) (Haiti)	ht_HT	ht_HT	0
168	2016-03-10 16:24:44.783	2016-03-10 16:24:44.783	Hausa	ha	ha	0
169	2016-03-10 16:24:44.783	2016-03-10 16:24:44.783	Hawaiian	haw	haw	0
170	2016-03-10 16:24:44.784	2016-03-10 16:24:44.784	Hebrew	he	he	0
171	2016-03-10 16:24:44.784	2016-03-10 16:24:44.784	Hebrew (Israel)	he_IL	he_IL	0
172	2016-03-10 16:24:44.785	2016-03-10 16:24:44.785	Hindi	hi	hi	0
173	2016-03-10 16:24:44.785	2016-03-10 16:24:44.785	Hindi (India)	hi_IN	hi_IN	0
174	2016-03-10 16:24:44.785	2016-03-10 16:24:44.785	Hungarian	hu	hu	0
175	2016-03-10 16:24:44.785	2016-03-10 16:24:44.785	Hungarian (Hungary)	hu_HU	hu_HU	0
176	2016-03-10 16:24:44.785	2016-03-10 16:24:44.785	Hungarian (Romanian)	hu_RO	hu_RO	0
177	2016-03-10 16:24:44.785	2016-03-10 16:24:44.785	Icelandic	is	is	0
178	2016-03-10 16:24:44.786	2016-03-10 16:24:44.786	Icelandic (Iceland)	is_IS	is_IS	0
179	2016-03-10 16:24:44.786	2016-03-10 16:24:44.786	Ido	io	io	0
180	2016-03-10 16:24:44.788	2016-03-10 16:24:44.788	Igbo	ig	ig	0
181	2016-03-10 16:24:44.788	2016-03-10 16:24:44.788	Iloko	ilo	ilo	0
182	2016-03-10 16:24:44.788	2016-03-10 16:24:44.788	Indonesian	id	id	0
183	2016-03-10 16:24:44.789	2016-03-10 16:24:44.789	Indonesian (Indonesia)	id_ID	id_ID	0
184	2016-03-10 16:24:44.789	2016-03-10 16:24:44.789	Interlingua	ia	ia	0
185	2016-03-10 16:24:44.789	2016-03-10 16:24:44.789	Inuktitut	iu	iu	0
186	2016-03-10 16:24:44.79	2016-03-10 16:24:44.79	Irish	ga	ga	0
187	2016-03-10 16:24:44.79	2016-03-10 16:24:44.79	Irish (Ireland)	ga_IE	ga_IE	0
188	2016-03-10 16:24:44.79	2016-03-10 16:24:44.79	Italian	it	it	0
189	2016-03-10 16:24:44.791	2016-03-10 16:24:44.791	Italian (Italy)	it_IT	it_IT	0
190	2016-03-10 16:24:44.791	2016-03-10 16:24:44.791	Italian (Switzerland)	it_CH	it_CH	0
191	2016-03-10 16:24:44.791	2016-03-10 16:24:44.791	Japanese	ja	ja	0
192	2016-03-10 16:24:44.791	2016-03-10 16:24:44.791	Japanese (Japan)	ja_JP	ja_JP	0
193	2016-03-10 16:24:44.791	2016-03-10 16:24:44.791	Javanese	jv	jv	0
194	2016-03-10 16:24:44.792	2016-03-10 16:24:44.792	Kabyle	kab	kab	0
195	2016-03-10 16:24:44.792	2016-03-10 16:24:44.792	Kannada	kn	kn	0
196	2016-03-10 16:24:44.792	2016-03-10 16:24:44.792	Kannada (India)	kn_IN	kn_IN	0
197	2016-03-10 16:24:44.793	2016-03-10 16:24:44.793	Kapampangan	pam	pam	0
198	2016-03-10 16:24:44.793	2016-03-10 16:24:44.793	Kashmiri	ks	ks	0
199	2016-03-10 16:24:44.793	2016-03-10 16:24:44.793	Kashmiri (India)	ks_IN	ks_IN	0
200	2016-03-10 16:24:44.795	2016-03-10 16:24:44.795	Kashubian	csb	csb	0
201	2016-03-10 16:24:44.795	2016-03-10 16:24:44.795	Kazakh	kk	kk	0
202	2016-03-10 16:24:44.795	2016-03-10 16:24:44.795	Kazakh (Arabic)	kk@Arab	kk@Arab	0
203	2016-03-10 16:24:44.796	2016-03-10 16:24:44.796	Kazakh (Cyrillic)	kk@Cyrl	kk@Cyrl	0
204	2016-03-10 16:24:44.796	2016-03-10 16:24:44.796	Kazakh (Kazakhstan)	kk_KZ	kk_KZ	0
205	2016-03-10 16:24:44.796	2016-03-10 16:24:44.796	Kazakh (Latin)	kk@latin	kk@latin	0
206	2016-03-10 16:24:44.797	2016-03-10 16:24:44.797	Khmer	km	km	0
207	2016-03-10 16:24:44.797	2016-03-10 16:24:44.797	Khmer (Cambodia)	km_KH	km_KH	0
208	2016-03-10 16:24:44.797	2016-03-10 16:24:44.797	Kinyarwanda	rw	rw	0
209	2016-03-10 16:24:44.797	2016-03-10 16:24:44.797	Klingon	tlh	tlh	0
210	2016-03-10 16:24:44.797	2016-03-10 16:24:44.797	Konkani	kok	kok	0
211	2016-03-10 16:24:44.798	2016-03-10 16:24:44.798	Korean	ko	ko	0
212	2016-03-10 16:24:44.798	2016-03-10 16:24:44.798	Korean (Korea)	ko_KR	ko_KR	0
213	2016-03-10 16:24:44.798	2016-03-10 16:24:44.798	Kurdish	ku	ku	0
214	2016-03-10 16:24:44.799	2016-03-10 16:24:44.799	Kurdish (Iraq)	ku_IQ	ku_IQ	0
215	2016-03-10 16:24:44.8	2016-03-10 16:24:44.8	Kyrgyz	ky	ky	0
216	2016-03-10 16:24:44.8	2016-03-10 16:24:44.8	Ladino	lad	lad	0
217	2016-03-10 16:24:44.8	2016-03-10 16:24:44.8	Lao	lo	lo	0
218	2016-03-10 16:24:44.801	2016-03-10 16:24:44.801	Lao (Laos)	lo_LA	lo_LA	0
219	2016-03-10 16:24:44.801	2016-03-10 16:24:44.801	Latgalian	ltg	ltg	0
220	2016-03-10 16:24:44.802	2016-03-10 16:24:44.802	Latin	la	la	0
221	2016-03-10 16:24:44.802	2016-03-10 16:24:44.802	Latvian	lv	lv	0
222	2016-03-10 16:24:44.803	2016-03-10 16:24:44.803	Latvian (Latvia)	lv_LV	lv_LV	0
223	2016-03-10 16:24:44.803	2016-03-10 16:24:44.803	Lezghian	lez	lez	0
224	2016-03-10 16:24:44.803	2016-03-10 16:24:44.803	Ligurian	lij	lij	0
225	2016-03-10 16:24:44.803	2016-03-10 16:24:44.803	Limburgian	li	li	0
226	2016-03-10 16:24:44.803	2016-03-10 16:24:44.803	Lingala	ln	ln	0
227	2016-03-10 16:24:44.804	2016-03-10 16:24:44.804	Lithuanian	lt	lt	0
228	2016-03-10 16:24:44.804	2016-03-10 16:24:44.804	Lithuanian (Lithuania)	lt_LT	lt_LT	0
229	2016-03-10 16:24:44.804	2016-03-10 16:24:44.804	Lojban	jbo	jbo	0
230	2016-03-10 16:24:44.805	2016-03-10 16:24:44.805	LOLCAT English	en@lolcat	en@lolcat	0
231	2016-03-10 16:24:44.805	2016-03-10 16:24:44.805	Lombard	lmo	lmo	0
232	2016-03-10 16:24:44.805	2016-03-10 16:24:44.805	Lower Sorbian	dsb	dsb	0
233	2016-03-10 16:24:44.807	2016-03-10 16:24:44.807	Low German	nds	nds	0
234	2016-03-10 16:24:44.807	2016-03-10 16:24:44.807	Luxembourgish	lb	lb	0
235	2016-03-10 16:24:44.807	2016-03-10 16:24:44.807	Macedonian	mk	mk	0
236	2016-03-10 16:24:44.808	2016-03-10 16:24:44.808	Macedonian (Macedonia)	mk_MK	mk_MK	0
237	2016-03-10 16:24:44.808	2016-03-10 16:24:44.808	Maithili	mai	mai	0
238	2016-03-10 16:24:44.808	2016-03-10 16:24:44.808	Malagasy	mg	mg	0
239	2016-03-10 16:24:44.808	2016-03-10 16:24:44.808	Malay	ms	ms	0
240	2016-03-10 16:24:44.808	2016-03-10 16:24:44.808	Malayalam	ml	ml	0
241	2016-03-10 16:24:44.808	2016-03-10 16:24:44.808	Malayalam (India)	ml_IN	ml_IN	0
242	2016-03-10 16:24:44.809	2016-03-10 16:24:44.809	Malay (Malaysia)	ms_MY	ms_MY	0
243	2016-03-10 16:24:44.809	2016-03-10 16:24:44.809	Maltese	mt	mt	0
244	2016-03-10 16:24:44.809	2016-03-10 16:24:44.809	Maltese (Malta)	mt_MT	mt_MT	0
245	2016-03-10 16:24:44.81	2016-03-10 16:24:44.81	Manipuri	mni	mni	0
246	2016-03-10 16:24:44.81	2016-03-10 16:24:44.81	Maori	mi	mi	0
247	2016-03-10 16:24:44.81	2016-03-10 16:24:44.81	Mapudungun	arn	arn	0
248	2016-03-10 16:24:44.812	2016-03-10 16:24:44.812	Marathi	mr	mr	0
249	2016-03-10 16:24:44.812	2016-03-10 16:24:44.812	Marathi (India)	mr_IN	mr_IN	0
250	2016-03-10 16:24:44.813	2016-03-10 16:24:44.813	Marshallese	mh	mh	0
251	2016-03-10 16:24:44.813	2016-03-10 16:24:44.813	Mirandese	mw1	mw1	0
252	2016-03-10 16:24:44.813	2016-03-10 16:24:44.813	Mongolian	mn	mn	0
253	2016-03-10 16:24:44.814	2016-03-10 16:24:44.814	Mongolian (Mongolia)	mn_MN	mn_MN	0
254	2016-03-10 16:24:44.814	2016-03-10 16:24:44.814	Nahuatl	nah	nah	0
255	2016-03-10 16:24:44.815	2016-03-10 16:24:44.815	Navajo	nv	nv	0
256	2016-03-10 16:24:44.815	2016-03-10 16:24:44.815	Ndebele, South	nr	nr	0
257	2016-03-10 16:24:44.815	2016-03-10 16:24:44.815	Neapolitan	nap	nap	0
258	2016-03-10 16:24:44.816	2016-03-10 16:24:44.816	Nepali	ne	ne	0
259	2016-03-10 16:24:44.816	2016-03-10 16:24:44.816	Nepali (Nepal)	ne_NP	ne_NP	0
260	2016-03-10 16:24:44.816	2016-03-10 16:24:44.816	Nias	nia	nia	0
261	2016-03-10 16:24:44.817	2016-03-10 16:24:44.817	N'ko	nqo	nqo	0
262	2016-03-10 16:24:44.817	2016-03-10 16:24:44.817	Northern Sami	se	se	0
263	2016-03-10 16:24:44.818	2016-03-10 16:24:44.818	Northern Sotho	nso	nso	0
264	2016-03-10 16:24:44.818	2016-03-10 16:24:44.818	Norwegian	no	no	0
265	2016-03-10 16:24:44.818	2016-03-10 16:24:44.818	Norwegian Bokmal	nb	nb	0
266	2016-03-10 16:24:44.818	2016-03-10 16:24:44.818	Norwegian Bokmal (Norway)	nb_NO	nb_NO	0
267	2016-03-10 16:24:44.818	2016-03-10 16:24:44.818	Norwegian (Norway)	no_NO	no_NO	0
268	2016-03-10 16:24:44.819	2016-03-10 16:24:44.819	Norwegian Nynorsk	nn	nn	0
269	2016-03-10 16:24:44.819	2016-03-10 16:24:44.819	Norwegian Nynorsk (Norway)	nn_NO	nn_NO	0
270	2016-03-10 16:24:44.819	2016-03-10 16:24:44.819	Nyanja	ny	ny	0
271	2016-03-10 16:24:44.82	2016-03-10 16:24:44.82	Occitan (post 1500)	oc	oc	0
272	2016-03-10 16:24:44.82	2016-03-10 16:24:44.82	Oriya	or	or	0
273	2016-03-10 16:24:44.82	2016-03-10 16:24:44.82	Oriya (India)	or_IN	or_IN	0
274	2016-03-10 16:24:44.822	2016-03-10 16:24:44.822	Oromo	om	om	0
275	2016-03-10 16:24:44.822	2016-03-10 16:24:44.822	Ossetic	os	os	0
276	2016-03-10 16:24:44.822	2016-03-10 16:24:44.822	Palatinate German	pfl	pfl	0
277	2016-03-10 16:24:44.822	2016-03-10 16:24:44.822	Panjabi (Punjabi)	pa	pa	0
278	2016-03-10 16:24:44.822	2016-03-10 16:24:44.822	Panjabi (Punjabi) (India)	pa_IN	pa_IN	0
279	2016-03-10 16:24:44.823	2016-03-10 16:24:44.823	Papiamento	pap	pap	0
280	2016-03-10 16:24:44.823	2016-03-10 16:24:44.823	Persian	fa	fa	0
281	2016-03-10 16:24:44.823	2016-03-10 16:24:44.823	Persian (Afghanistan)	fa_AF	fa_AF	0
282	2016-03-10 16:24:44.825	2016-03-10 16:24:44.825	Persian (Iran)	fa_IR	fa_IR	0
283	2016-03-10 16:24:44.825	2016-03-10 16:24:44.825	Piemontese	pms	pms	0
284	2016-03-10 16:24:44.825	2016-03-10 16:24:44.825	Pirate English	en@pirate	en@pirate	0
285	2016-03-10 16:24:44.826	2016-03-10 16:24:44.826	Polish	pl	pl	0
286	2016-03-10 16:24:44.826	2016-03-10 16:24:44.826	Polish (Poland)	pl_PL	pl_PL	0
287	2016-03-10 16:24:44.826	2016-03-10 16:24:44.826	Portuguese	pt	pt	0
288	2016-03-10 16:24:44.827	2016-03-10 16:24:44.827	Portuguese (Brazil)	pt_BR	pt_BR	0
289	2016-03-10 16:24:44.827	2016-03-10 16:24:44.827	Portuguese (Portugal)	pt_PT	pt_PT	0
290	2016-03-10 16:24:44.827	2016-03-10 16:24:44.827	Pushto	ps	ps	0
291	2016-03-10 16:24:44.828	2016-03-10 16:24:44.828	Romanian	ro	ro	0
292	2016-03-10 16:24:44.828	2016-03-10 16:24:44.828	Romanian (Romania)	ro_RO	ro_RO	0
293	2016-03-10 16:24:44.828	2016-03-10 16:24:44.828	Romansh	rm	rm	0
294	2016-03-10 16:24:44.829	2016-03-10 16:24:44.829	Russian	ru	ru	0
295	2016-03-10 16:24:44.829	2016-03-10 16:24:44.829	Russian (Estonia)	ru_ee	ru_ee	0
296	2016-03-10 16:24:44.829	2016-03-10 16:24:44.829	Russian (Latvia)	ru_lv	ru_lv	0
297	2016-03-10 16:24:44.83	2016-03-10 16:24:44.83	Russian (Lithuania)	ru_lt	ru_lt	0
298	2016-03-10 16:24:44.83	2016-03-10 16:24:44.83	Russian Petrine orthography	ru@petr1708	ru@petr1708	0
299	2016-03-10 16:24:44.83	2016-03-10 16:24:44.83	Russian (Russia)	ru_RU	ru_RU	0
300	2016-03-10 16:24:44.831	2016-03-10 16:24:44.831	Sakha (Yakut)	sah	sah	0
301	2016-03-10 16:24:44.831	2016-03-10 16:24:44.831	Samoan	sm	sm	0
302	2016-03-10 16:24:44.831	2016-03-10 16:24:44.831	Sango	sg	sg	0
303	2016-03-10 16:24:44.832	2016-03-10 16:24:44.832	Sanskrit	sa	sa	0
304	2016-03-10 16:24:44.832	2016-03-10 16:24:44.832	Santali	sat	sat	0
305	2016-03-10 16:24:44.832	2016-03-10 16:24:44.832	Sardinian	sc	sc	0
306	2016-03-10 16:24:44.833	2016-03-10 16:24:44.833	Scots	sco	sco	0
307	2016-03-10 16:24:44.833	2016-03-10 16:24:44.833	Serbian	sr	sr	0
308	2016-03-10 16:24:44.834	2016-03-10 16:24:44.834	Serbian (Ijekavian)	sr@Ijekavian	sr@Ijekavian	0
309	2016-03-10 16:24:44.834	2016-03-10 16:24:44.834	Serbian (Ijekavian Latin)	sr@ijekavianlatin	sr@ijekavianlatin	0
310	2016-03-10 16:24:44.834	2016-03-10 16:24:44.834	Serbian (Latin)	sr@latin	sr@latin	0
311	2016-03-10 16:24:44.835	2016-03-10 16:24:44.835	Serbian (Latin) (Serbia)	sr_RS@latin	sr_RS@latin	0
312	2016-03-10 16:24:44.835	2016-03-10 16:24:44.835	Serbian (Serbia)	sr_RS	sr_RS	0
313	2016-03-10 16:24:44.835	2016-03-10 16:24:44.835	Shona	sn	sn	0
314	2016-03-10 16:24:44.836	2016-03-10 16:24:44.836	Sicilian	scn	scn	0
315	2016-03-10 16:24:44.836	2016-03-10 16:24:44.836	Silesian	szl	szl	0
316	2016-03-10 16:24:44.836	2016-03-10 16:24:44.836	Sindhi	sd	sd	0
317	2016-03-10 16:24:44.837	2016-03-10 16:24:44.837	Sinhala	si	si	0
318	2016-03-10 16:24:44.837	2016-03-10 16:24:44.837	Sinhala (Sri Lanka)	si_LK	si_LK	0
319	2016-03-10 16:24:44.837	2016-03-10 16:24:44.837	Slovak	sk	sk	0
320	2016-03-10 16:24:44.838	2016-03-10 16:24:44.838	Slovak (Slovakia)	sk_SK	sk_SK	0
321	2016-03-10 16:24:44.838	2016-03-10 16:24:44.838	Slovenian	sl	sl	0
322	2016-03-10 16:24:44.838	2016-03-10 16:24:44.838	Slovenian (Slovenia)	sl_SI	sl_SI	0
323	2016-03-10 16:24:44.839	2016-03-10 16:24:44.839	Somali	so	so	0
324	2016-03-10 16:24:44.839	2016-03-10 16:24:44.839	Songhay	son	son	0
325	2016-03-10 16:24:44.84	2016-03-10 16:24:44.84	Sotho, Southern	st	st	0
326	2016-03-10 16:24:44.84	2016-03-10 16:24:44.84	Sotho, Southern (South Africa)	st_ZA	st_ZA	0
327	2016-03-10 16:24:44.84	2016-03-10 16:24:44.84	Southern Sami	sma	sma	0
328	2016-03-10 16:24:44.841	2016-03-10 16:24:44.841	Spanish	es	es	0
329	2016-03-10 16:24:44.841	2016-03-10 16:24:44.841	Spanish (Argentina)	es_AR	es_AR	0
330	2016-03-10 16:24:44.841	2016-03-10 16:24:44.841	Spanish (Bolivia)	es_BO	es_BO	0
331	2016-03-10 16:24:44.842	2016-03-10 16:24:44.842	Spanish (Chile)	es_CL	es_CL	0
332	2016-03-10 16:24:44.842	2016-03-10 16:24:44.842	Spanish (Colombia)	es_CO	es_CO	0
333	2016-03-10 16:24:44.842	2016-03-10 16:24:44.842	Spanish (Costa Rica)	es_CR	es_CR	0
334	2016-03-10 16:24:44.843	2016-03-10 16:24:44.843	Spanish (Dominican Republic)	es_DO	es_DO	0
335	2016-03-10 16:24:44.843	2016-03-10 16:24:44.843	Spanish (Ecuador)	es_EC	es_EC	0
336	2016-03-10 16:24:44.843	2016-03-10 16:24:44.843	Spanish (El Salvador)	es_SV	es_SV	0
337	2016-03-10 16:24:44.844	2016-03-10 16:24:44.844	Spanish (Guatemala)	es_GT	es_GT	0
338	2016-03-10 16:24:44.844	2016-03-10 16:24:44.844	Spanish (Honduras)	es_HN	es_HN	0
339	2016-03-10 16:24:44.844	2016-03-10 16:24:44.844	Spanish (Latin America)	es_419	es_419	0
340	2016-03-10 16:24:44.845	2016-03-10 16:24:44.845	Spanish (Mexico)	es_MX	es_MX	0
341	2016-03-10 16:24:44.845	2016-03-10 16:24:44.845	Spanish (Nicaragua)	es_NI	es_NI	0
342	2016-03-10 16:24:44.845	2016-03-10 16:24:44.845	Spanish (Panama)	es_PA	es_PA	0
343	2016-03-10 16:24:44.846	2016-03-10 16:24:44.846	Spanish (Paraguay)	es_PY	es_PY	0
344	2016-03-10 16:24:44.846	2016-03-10 16:24:44.846	Spanish (Peru)	es_PE	es_PE	0
345	2016-03-10 16:24:44.847	2016-03-10 16:24:44.847	Spanish (Puerto Rico)	es_PR	es_PR	0
346	2016-03-10 16:24:44.847	2016-03-10 16:24:44.847	Spanish (Spain)	es_ES	es_ES	0
347	2016-03-10 16:24:44.847	2016-03-10 16:24:44.847	Spanish (United States)	es_US	es_US	0
348	2016-03-10 16:24:44.848	2016-03-10 16:24:44.848	Spanish (Uruguay)	es_UY	es_UY	0
349	2016-03-10 16:24:44.848	2016-03-10 16:24:44.848	Spanish (Venezuela)	es_VE	es_VE	0
350	2016-03-10 16:24:44.848	2016-03-10 16:24:44.848	Sundanese	su	su	0
351	2016-03-10 16:24:44.849	2016-03-10 16:24:44.849	Swahili	sw	sw	0
352	2016-03-10 16:24:44.849	2016-03-10 16:24:44.849	Swahili (Democratic Republic of the Congo)	sw_CD	sw_CD	0
353	2016-03-10 16:24:44.849	2016-03-10 16:24:44.849	Swahili (Kenya)	sw_KE	sw_KE	0
354	2016-03-10 16:24:44.85	2016-03-10 16:24:44.85	Swati	ss	ss	0
355	2016-03-10 16:24:44.85	2016-03-10 16:24:44.85	Swedish	sv	sv	0
356	2016-03-10 16:24:44.851	2016-03-10 16:24:44.851	Swedish (Finland)	sv_FI	sv_FI	0
357	2016-03-10 16:24:44.851	2016-03-10 16:24:44.851	Swedish (Sweden)	sv_SE	sv_SE	0
358	2016-03-10 16:24:44.851	2016-03-10 16:24:44.851	Tagalog	tl	tl	0
359	2016-03-10 16:24:44.851	2016-03-10 16:24:44.851	Tagalog (Philippines)	tl_PH	tl_PH	0
360	2016-03-10 16:24:44.852	2016-03-10 16:24:44.852	Tajik	tg	tg	0
361	2016-03-10 16:24:44.852	2016-03-10 16:24:44.852	Tajik (Tajikistan)	tg_TJ	tg_TJ	0
362	2016-03-10 16:24:44.853	2016-03-10 16:24:44.853	Talossan	tzl	tzl	0
363	2016-03-10 16:24:44.853	2016-03-10 16:24:44.853	Tamil	ta	ta	0
364	2016-03-10 16:24:44.853	2016-03-10 16:24:44.853	Tamil (India)	ta_IN	ta_IN	0
365	2016-03-10 16:24:44.854	2016-03-10 16:24:44.854	Tamil (Sri-Lanka)	ta_LK	ta_LK	0
366	2016-03-10 16:24:44.854	2016-03-10 16:24:44.854	Tatar	tt	tt	0
367	2016-03-10 16:24:44.854	2016-03-10 16:24:44.854	Telugu	te	te	0
368	2016-03-10 16:24:44.854	2016-03-10 16:24:44.854	Telugu (India)	te_IN	te_IN	0
369	2016-03-10 16:24:44.854	2016-03-10 16:24:44.854	Tetum (Tetun)	tet	tet	0
370	2016-03-10 16:24:44.854	2016-03-10 16:24:44.854	Thai	th	th	0
371	2016-03-10 16:24:44.855	2016-03-10 16:24:44.855	Thai (Thailand)	th_TH	th_TH	0
372	2016-03-10 16:24:44.855	2016-03-10 16:24:44.855	Tibetan	bo	bo	0
373	2016-03-10 16:24:44.856	2016-03-10 16:24:44.856	Tibetan (China)	bo_CN	bo_CN	0
374	2016-03-10 16:24:44.856	2016-03-10 16:24:44.856	Tigrinya	ti	ti	0
375	2016-03-10 16:24:44.857	2016-03-10 16:24:44.857	Tongan	to	to	0
376	2016-03-10 16:24:44.858	2016-03-10 16:24:44.858	Tsonga	ts	ts	0
377	2016-03-10 16:24:44.858	2016-03-10 16:24:44.858	Tswana	tn	tn	0
378	2016-03-10 16:24:44.859	2016-03-10 16:24:44.859	Turkish	tr	tr	0
379	2016-03-10 16:24:44.859	2016-03-10 16:24:44.859	Turkish (Turkey)	tr_TR	tr_TR	0
380	2016-03-10 16:24:44.859	2016-03-10 16:24:44.859	Turkmen	tk	tk	0
381	2016-03-10 16:24:44.86	2016-03-10 16:24:44.86	Turkmen (Turkmenistan)	tk_TM	tk_TM	0
382	2016-03-10 16:24:44.86	2016-03-10 16:24:44.86	Udmurt	udm	udm	0
383	2016-03-10 16:24:44.86	2016-03-10 16:24:44.86	Uighur	ug	ug	0
384	2016-03-10 16:24:44.86	2016-03-10 16:24:44.86	Uighur (Arabic)	ug@Arab	ug@Arab	0
385	2016-03-10 16:24:44.86	2016-03-10 16:24:44.86	Uighur (Cyrillic)	ug@Cyrl	ug@Cyrl	0
386	2016-03-10 16:24:44.86	2016-03-10 16:24:44.86	Uighur (Latin)	ug@Latin	ug@Latin	0
387	2016-03-10 16:24:44.861	2016-03-10 16:24:44.861	Ukrainian	uk	uk	0
388	2016-03-10 16:24:44.861	2016-03-10 16:24:44.861	Ukrainian (Ukraine)	uk_UA	uk_UA	0
389	2016-03-10 16:24:44.863	2016-03-10 16:24:44.863	Upper Franconian	vmf	vmf	0
390	2016-03-10 16:24:44.863	2016-03-10 16:24:44.863	Upper Sorbian	hsb	hsb	0
391	2016-03-10 16:24:44.863	2016-03-10 16:24:44.863	Urdu	ur	ur	0
392	2016-03-10 16:24:44.863	2016-03-10 16:24:44.863	Urdu (Pakistan)	ur_PK	ur_PK	0
393	2016-03-10 16:24:44.863	2016-03-10 16:24:44.863	Uzbek	uz	uz	0
394	2016-03-10 16:24:44.863	2016-03-10 16:24:44.863	Uzbek (Arabic)	uz@Arab	uz@Arab	0
395	2016-03-10 16:24:44.864	2016-03-10 16:24:44.864	Uzbek (Cyrillic)	uz@Cyrl	uz@Cyrl	0
396	2016-03-10 16:24:44.864	2016-03-10 16:24:44.864	Uzbek (Latin)	uz@Latn	uz@Latn	0
397	2016-03-10 16:24:44.864	2016-03-10 16:24:44.864	Uzbek (Uzbekistan)	uz_UZ	uz_UZ	0
398	2016-03-10 16:24:44.865	2016-03-10 16:24:44.865	Venda	ve	ve	0
399	2016-03-10 16:24:44.865	2016-03-10 16:24:44.865	Venetian	vec	vec	0
400	2016-03-10 16:24:44.865	2016-03-10 16:24:44.865	Vietnamese	vi	vi	0
401	2016-03-10 16:24:44.866	2016-03-10 16:24:44.866	Vietnamese (Viet Nam)	vi_VN	vi_VN	0
402	2016-03-10 16:24:44.866	2016-03-10 16:24:44.866	Vlaams	vls	vls	0
403	2016-03-10 16:24:44.867	2016-03-10 16:24:44.867	Walloon	wa	wa	0
404	2016-03-10 16:24:44.867	2016-03-10 16:24:44.867	Waray-Waray	war	war	0
405	2016-03-10 16:24:44.867	2016-03-10 16:24:44.867	Welsh	cy	cy	0
406	2016-03-10 16:24:44.868	2016-03-10 16:24:44.868	Welsh (United Kingdom)	cy_GB	cy_GB	0
407	2016-03-10 16:24:44.868	2016-03-10 16:24:44.868	Western Frisian	fy	fy	0
408	2016-03-10 16:24:44.868	2016-03-10 16:24:44.868	Western Frisian (Netherlands)	fy_NL	fy_NL	0
409	2016-03-10 16:24:44.87	2016-03-10 16:24:44.87	Wolof	wo	wo	0
410	2016-03-10 16:24:44.87	2016-03-10 16:24:44.87	Wolof (Senegal)	wo_SN	wo_SN	0
411	2016-03-10 16:24:44.87	2016-03-10 16:24:44.87	Xhosa	xh	xh	0
412	2016-03-10 16:24:44.87	2016-03-10 16:24:44.87	Yiddish	yi	yi	0
413	2016-03-10 16:24:44.87	2016-03-10 16:24:44.87	Yoruba	yo	yo	0
414	2016-03-10 16:24:44.871	2016-03-10 16:24:44.871	Zulu	zu	zu	0
415	2016-03-10 16:24:44.871	2016-03-10 16:24:44.871	Zulu (South Africa)	zu_ZA	zu_ZA	0
\.


--
-- Name: languages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('languages_id_seq', 1, false);


--
-- Data for Name: list_subscribers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY list_subscribers (id, created, modified, list_id, user_id, is_subscribed) FROM stdin;
\.


--
-- Name: list_subscribers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('list_subscribers_id_seq', 1, false);


--
-- Data for Name: lists; Type: TABLE DATA; Schema: public; Owner: -
--

COPY lists (id, created, modified, board_id, user_id, name, "position", is_archived, card_count, lists_subscriber_count, is_deleted, custom_fields) FROM stdin;
\.


--
-- Name: lists_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('lists_id_seq', 196, true);


--
-- Name: lists_subscribers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('lists_subscribers_id_seq', 1, true);


--
-- Data for Name: login_types; Type: TABLE DATA; Schema: public; Owner: -
--

COPY login_types (id, created, modified, name) FROM stdin;
1	2015-04-07 18:42:59.514	2015-04-07 18:42:59.514	LDAP
2	2015-04-07 18:42:59.515	2015-04-07 18:42:59.515	Normal
\.


--
-- Name: login_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('login_types_id_seq', 2, true);


--
-- Data for Name: oauth_access_tokens; Type: TABLE DATA; Schema: public; Owner: -
--

COPY oauth_access_tokens (access_token, client_id, user_id, expires, scope) FROM stdin;
\.


--
-- Data for Name: oauth_authorization_codes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY oauth_authorization_codes (authorization_code, client_id, user_id, redirect_uri, expires, scope) FROM stdin;
\.


--
-- Data for Name: oauth_clients; Type: TABLE DATA; Schema: public; Owner: -
--

COPY oauth_clients (client_id, client_secret, redirect_uri, grant_types, scope, user_id, client_name, client_url, logo_url, tos_url, policy_url, modified, created, id) FROM stdin;
7742632501382313	4g7C4l1Y2b0S6a7L8c1E7B3K0e		client_credentials password refresh_token authorization_code		2	Web App	\N	\N	\N	\N	\N	\N	2
6664115227792148	hw3wpe2cfsxxygogwue47cwnf7	\N	client_credentials refresh_token authorization_code	\N	\N	Mobile App	\N	\N	\N	\N	2016-02-22 17:39:17.208	2016-02-22 17:39:17.208	3
7857596005287233	n0l2wlujcpkj0bd7gk8918gm6b	\N	client_credentials refresh_token authorization_code	\N	\N	Zapier	\N	\N	\N	\N	2016-02-22 17:39:17.208	2016-02-22 17:39:17.208	4
1193674816623028	zhxzlbts63ecvs2ybwb2m26vew		client_credentials refresh_token authorization_code	\N	\N	Amazon Echo App	http://amazon.com	\N	\N	\N	2016-03-09 07:14:29.165491	2016-03-09 07:13:57.717503	5
\.


--
-- Name: oauth_clients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('oauth_clients_id_seq', 1, false);


--
-- Name: oauth_clients_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('oauth_clients_id_seq1', 5, true);


--
-- Data for Name: oauth_jwt; Type: TABLE DATA; Schema: public; Owner: -
--

COPY oauth_jwt (client_id, subject, public_key) FROM stdin;
\.


--
-- Data for Name: oauth_refresh_tokens; Type: TABLE DATA; Schema: public; Owner: -
--

COPY oauth_refresh_tokens (refresh_token, client_id, user_id, expires, scope) FROM stdin;
8adf4daa06961f18d2afda535b2f4463193c62f5	7742632501382313	admin	2015-04-16 12:55:32	\N
b43d289f47100a9c70ebd21f31c15db059ef82bb	7742632501382313	admin	2015-06-04 08:15:47	\N
52831802ce6fbd12bfbe34f1def7b679a0822a18	7742632501382313	admin	2015-06-20 07:23:34	\N
\.


--
-- Data for Name: oauth_scopes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY oauth_scopes (scope, is_default) FROM stdin;
read	t
write	f
\.


--
-- Data for Name: organization_user_roles; Type: TABLE DATA; Schema: public; Owner: -
--

COPY organization_user_roles (id, created, modified, name, description) FROM stdin;
1	2016-02-22 17:39:17.743	2016-02-22 17:39:17.743	Owner	Can view, create and edit org boards, and change settings for the organization.
2	2016-02-22 17:39:17.743	2016-02-22 17:39:17.743	Editor	Can view, create, and edit org boards, but not change settings.
3	2016-02-22 17:39:17.743	2016-02-22 17:39:17.743	Viewer	Can view only.
\.


--
-- Name: organization_user_roles_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('organization_user_roles_seq', 1, false);


--
-- Data for Name: organizations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY organizations (id, created, modified, user_id, name, website_url, description, logo_url, organization_visibility, organizations_user_count, board_count) FROM stdin;
\.


--
-- Name: organizations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('organizations_id_seq', 1, true);


--
-- Data for Name: organizations_users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY organizations_users (id, created, modified, organization_id, user_id, organization_user_role_id) FROM stdin;
\.


--
-- Name: organizations_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('organizations_users_id_seq', 1, true);


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: -
--

COPY roles (id, created, modified, name) FROM stdin;
1	2014-09-02 19:43:15.815	2014-09-02 19:43:15.815	Admin
2	2014-09-02 19:43:15.815	2014-09-02 19:43:15.815	User
3	2014-09-02 19:43:15.815	2014-09-02 19:43:15.815	Guest
\.


--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('roles_id_seq', 3, true);


--
-- Data for Name: setting_categories; Type: TABLE DATA; Schema: public; Owner: -
--

COPY setting_categories (id, created, modified, parent_id, name, description, "order") FROM stdin;
4	2014-11-21 02:52:08.822706	2014-11-21 02:52:08.822706	2	Server Details	\N	0
5	2014-11-21 02:52:08.822706	2014-11-21 02:52:08.822706	2	Connection Details	\N	0
7	2015-04-25 19:58:48.845	2015-04-25 19:58:48.845	6	Dropbox	\N	0
3	2014-11-21 02:52:08.822706	2014-11-21 02:52:08.822706	\N	System	\N	1
6	2015-04-25 19:58:48.845	2015-04-25 19:58:48.845	\N	Third Party API	\N	3
1	2014-04-23 16:30:20.121	2014-04-23 16:30:20.121	\N	ElasticSearch		4
9	\N	\N	2	Enabled Login Options	Enabled Login Options	1
2	2014-11-08 02:52:08.822706	2014-04-28 17:01:11	\N	Login	\N	2
10	2016-02-22 17:39:16.971	2016-02-22 17:39:16.971	\N	IMAP	\N	5
11	2015-09-26 13:14:18	2015-09-26 13:14:18	\N	XMPP Chat	\N	5
12	2016-06-22 04:50:42.248	2016-06-22 04:50:42.248	\N	Cards Workflow	\N	7
13	2016-06-28 07:47:21.765	2016-06-28 07:47:21.765	\N	Cards Workflow	\N	7
\.


--
-- Name: setting_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('setting_categories_id_seq', 13, true);


--
-- Data for Name: settings; Type: TABLE DATA; Schema: public; Owner: -
--

COPY settings (id, setting_category_id, setting_category_parent_id, name, value, description, type, options, label, "order") FROM stdin;
11	3	0	SITE_NAME	Restyaboard	\N	text	\N	Site Name	1
19	3	0	LABEL_ICON	icon-circle	<a href="http://fortawesome.github.io/Font-Awesome/icons/" target="_blank">Font\r\nAwesome</a> class name. Recommended: icon-circle, icon-bullhorn,\r\nicon-tag, icon-bookmark, icon-pushpin, icon-star	text	\N	Label Icon	3
12	3	0	PAGING_COUNT	20	\N	text	\N	Paging Count	4
21	3	0	SITE_TIMEZONE	+0200	\N	text	\N	Site Timezone	5
18	6	0	DROPBOX_APPKEY		\N	text	\N	Dropbox App Key	1
20	6	0	FLICKR_API_KEY		\N	text	\N	Flickr API Key	2
3	9	2	LDAP_LOGIN_ENABLED	false	\N	checkbox	\N	LDAP	2
22	9	2	STANDARD_LOGIN_ENABLED	true	\N	checkbox	\N	Standard	1
29	3	0	DEFAULT_REPLY_TO_EMAIL_ADDRESS	board@restya.com	\N	text	\N	Reply To Email Address	3
13	3	0	DEFAULT_FROM_EMAIL_ADDRESS	board@restya.com	\N	text	\N	From Email Address	2
31	3	0	DEFAULT_LANGUAGE	en_US	\N	text	\N	Default Language	6
24	4	2	ENABLE_SSL_CONNECTIVITY	\N	Use encryption (SSL, ldaps:// URL) when connects to server?	checkbox	\N	Enable SSL Connectivity	3
5	4	2	LDAP_PORT	\N	Server port (e.g., 389 for LDAP and 636 for LDAP using SSL)	text	\N	Port	5
8	5	2	LDAP_UID_FIELD	\N	You can use different field from the username here. For pre-windows 2000 style login, use sAMAccountName and for a UPN style login use userPrincipalName.	text	\N	Account Filter	9
9	5	2	LDAP_BIND_DN	\N	Enter a valid user account/DN to pre-bind with if your LDAP server does not allow anonymous profile searches, or requires a user with specific privileges to search.	text	\N	Bind DN	10
10	5	2	LDAP_BIND_PASSWD	\N	Enter a password for the above Bind DN.	password	\N	Bind password	11
4	4	2	LDAP_PROTOCOL_VERSION	\N	Difference between LDAPv3 and LDAPv2 https://msdn.microsoft.com/en-us/library/windows/desktop/aa366099%28v=vs.85%29.aspx (e.g., 3)	text	\N	Protocol Version	6
6	4	2	LDAP_ROOT_DN	\N	This is your search base for LDAP queries. This should be at least your domain root, (e.g., dc=domain,dc=local) You can define this as a Organizational Unit if you want to narrow down the search base (e.g., ou=team,ou=company,dc=domain,dc=local)	text	\N	Base DN	7
16	1	0	ELASTICSEARCH_URL		e.g., http://localhost:9200/	text	\N	Server URL	3
17	1	0	ELASTICSEARCH_INDEX		Used to prefix index names to avoid potential collisions. e.g., restya	text	\N	Index Name	4
32	10	0	IMAP_HOST		\N	text	\N	Incoming Mail Server	1
33	10	0	IMAP_PORT		e.g., 993	text	\N	Port	2
34	10	0	IMAP_EMAIL		\N	text	\N	Email address	3
35	10	0	IMAP_EMAIL_PASSWORD		\N	password	\N	Password	4
23	0	0	elasticsearch.last_processed_activity_id	0	\N	hidden	\N	Last Activity ID	3
2	4	2	LDAP_SERVER	\N	The DNS name or IP address of the server (e.g., dc.domain.local)	text	\N	Server	4
36	0	0	webhooks.last_processed_activity_id	0	\N	hidden	\N	Webhook Activity ID	0
37	11	0	BOSH_SERVICE_URL		\N	text	\N	Bosh Service URL	1
38	11	0	JABBER_HOST		\N	text	\N	Jabber Host	2
39	11	0	XMPP_CLIENT_RESOURCE_NAME		\N	text	\N	Client Resource Name	3
41	0	0	chat.last_processed_chat_id	0	\N	hidden	\N	Last Chat ID	1
43	12	0	TODO	To do, Todo, New, Probable sale		textarea	\N	Todo	8
45	12	0	DONE	Done, Resolved, Closed, Completed sale		textarea	\N	Done	10
44	12	0	DOING	Doing, Feedback, Confirmed, Assigned, Pending sale		textarea	\N	Doing	9
30	3	0	DEFAULT_CONTACT_EMAIL_ADDRESS	board@restya.com	It is used in all outgoing emails	text	\N	Contact Email Address	4
52	11	0	BOSH_SERVICE_URL		\N	text	\N	Bosh Service URL	1
53	11	0	JABBER_HOST		\N	text	\N	Jabber Host	2
54	11	0	XMPP_CLIENT_RESOURCE_NAME		\N	text	\N	Client Resource Name	3
56	0	0	chat.last_processed_chat_id	0	\N	hidden	\N	Last Chat ID	1
58	3	0	TODO	To do, Todo, New, Probable sale		textarea	\N	Todo	8
59	3	0	DOING	Doing, Feedback, Confirmed, Assigned, Pending sale		textarea	\N	Doing	9
60	3	0	DONE	Done, Resolved, Closed, Completed sale		textarea	\N	Done	10
42	3	0	DEFAULT_CARD_VIEW	Maximized	\N	select	Maximized,Normal Dockmodal	Default Card Open	7
57	3	0	DEFAULT_CARD_VIEW	Maximized	\N	select	Maximized,Normal Dockmodal	Default Card Open	7
46	12	0	TODO_COLOR	#f47564		text	\N	Todo Color	1
47	12	0	DOING_COLOR	#27c5c3		text	\N	Doing Color	2
48	12	0	DONE_COLOR	#8dca35		text	\N	Done Color	3
49	12	0	TODO_ICON	icon-tasks icon-large		text	\N	Todo Icon	4
50	12	0	DOING_ICON	icon-spinner icon-large		text	\N	Doing Icon	5
51	12	0	DONE_ICON	icon-ok-circle icon-large		text	\N	Done Icon	6
\.


--
-- Name: settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('settings_id_seq', 60, true);


--
-- Data for Name: states; Type: TABLE DATA; Schema: public; Owner: -
--

COPY states (id, created, modified, country_id, name, is_active) FROM stdin;
1	2015-05-21 11:45:47.229	2015-05-21 11:45:47.229	102	undefined	f
\.


--
-- Name: states_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('states_id_seq', 15138, false);


--
-- Name: states_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('states_id_seq1', 1, true);


--
-- Data for Name: user_logins; Type: TABLE DATA; Schema: public; Owner: -
--

COPY user_logins (id, created, modified, user_id, ip_id, user_agent) FROM stdin;
1	2015-05-21 11:45:47.266	2015-05-21 11:45:47.266	1	1	Mozilla/5.0 (Windows NT 6.3; WOW64; rv:38.0) Gecko/20100101 Firefox/38.0
2	2015-06-06 10:53:34.529	2015-06-06 10:53:34.529	1	1	Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.81 Safari/537.36
\.


--
-- Name: user_logins_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('user_logins_id_seq', 2, true);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY users (id, created, modified, role_id, username, email, password, full_name, initials, about_me, profile_picture_path, notification_frequency, is_allow_desktop_notification, is_active, is_email_confirmed, created_organization_count, created_board_count, joined_organization_count, list_count, joined_card_count, created_card_count, joined_board_count, checklist_count, checklist_item_completed_count, checklist_item_count, activity_count, card_voter_count, last_activity_id, last_login_date, last_login_ip_id, ip_id, login_type_id, is_productivity_beats, user_login_count, is_ldap, is_send_newsletter, last_email_notified_activity_id, owner_board_count, member_board_count, owner_organization_count, member_organization_count, language, timezone) FROM stdin;
1	2014-06-03 12:40:41.189	2015-04-02 16:26:03.939	1	admin	board@restya.com	$2y$12$QiJW6TjPKzDZPAuoWEex9OjPHQF33YzfkdC09FhasgPO.MjZ5btKe	New Admin	PA	Added About Me	media/User/1/default-admin-user.png	\N	f	t	t	0	0	0	0	0	0	0	0	0	0	0	0	2	2015-06-06 10:53:34.46	1	\N	2	t	2	f	0	0	0	0	0	0	\N	\N
2	2014-07-05 11:46:40.804	2014-07-05 11:46:40.804	2	user	board+user@restya.com	$2y$12$QiJW6TjPKzDZPAuoWEex9OjPHQF33YzfkdC09FhasgPO.MjZ5btKe	User	U	\N	\N	\N	f	t	t	0	0	0	0	0	0	0	0	0	0	0	0	0	\N	\N	\N	\N	f	0	f	0	0	0	0	0	0	\N	\N
\.


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('users_id_seq', 2, true);


--
-- Data for Name: webhooks; Type: TABLE DATA; Schema: public; Owner: -
--

COPY webhooks (id, created, modified, name, description, url, secret, is_active) FROM stdin;
\.


--
-- Name: webhooks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('webhooks_id_seq', 1, false);


--
-- Name: acl_board_links_id; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY acl_board_links
    ADD CONSTRAINT acl_board_links_id PRIMARY KEY (id);


--
-- Name: acl_organization_links_id; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY acl_organization_links
    ADD CONSTRAINT acl_organization_links_id PRIMARY KEY (id);


--
-- Name: activities_id; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY activities
    ADD CONSTRAINT activities_id PRIMARY KEY (id);


--
-- Name: board_subscribers_id; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY board_subscribers
    ADD CONSTRAINT board_subscribers_id PRIMARY KEY (id);


--
-- Name: board_users_id; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY boards_users
    ADD CONSTRAINT board_users_id PRIMARY KEY (id);


--
-- Name: boards_id; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY boards
    ADD CONSTRAINT boards_id PRIMARY KEY (id);


--
-- Name: card_attachments_id; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY card_attachments
    ADD CONSTRAINT card_attachments_id PRIMARY KEY (id);


--
-- Name: card_subscribers_id; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY card_subscribers
    ADD CONSTRAINT card_subscribers_id PRIMARY KEY (id);


--
-- Name: card_users_id; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cards_users
    ADD CONSTRAINT card_users_id PRIMARY KEY (id);


--
-- Name: card_voters_id; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY card_voters
    ADD CONSTRAINT card_voters_id PRIMARY KEY (id);


--
-- Name: cards_id; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cards
    ADD CONSTRAINT cards_id PRIMARY KEY (id);


--
-- Name: cards_labels_id; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cards_labels
    ADD CONSTRAINT cards_labels_id PRIMARY KEY (id);


--
-- Name: checklist_items_id; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY checklist_items
    ADD CONSTRAINT checklist_items_id PRIMARY KEY (id);


--
-- Name: checklists_id; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY checklists
    ADD CONSTRAINT checklists_id PRIMARY KEY (id);


--
-- Name: cities_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cities
    ADD CONSTRAINT cities_pkey PRIMARY KEY (id);


--
-- Name: countries_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (id);


--
-- Name: email_templates_id; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY email_templates
    ADD CONSTRAINT email_templates_id PRIMARY KEY (id);


--
-- Name: ips_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ips
    ADD CONSTRAINT ips_pkey PRIMARY KEY (id);


--
-- Name: labels_id; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY labels
    ADD CONSTRAINT labels_id PRIMARY KEY (id);


--
-- Name: lists_id; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY lists
    ADD CONSTRAINT lists_id PRIMARY KEY (id);


--
-- Name: lists_subscribers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY list_subscribers
    ADD CONSTRAINT lists_subscribers_pkey PRIMARY KEY (id);


--
-- Name: oauth_access_tokens_access_token; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY oauth_access_tokens
    ADD CONSTRAINT oauth_access_tokens_access_token PRIMARY KEY (access_token);


--
-- Name: oauth_authorization_codes_authorization_code; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY oauth_authorization_codes
    ADD CONSTRAINT oauth_authorization_codes_authorization_code PRIMARY KEY (authorization_code);


--
-- Name: oauth_clients_client_id; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY oauth_clients
    ADD CONSTRAINT oauth_clients_client_id PRIMARY KEY (client_id);


--
-- Name: oauth_jwt_client_id; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY oauth_jwt
    ADD CONSTRAINT oauth_jwt_client_id PRIMARY KEY (client_id);


--
-- Name: oauth_refresh_tokens_refresh_token; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY oauth_refresh_tokens
    ADD CONSTRAINT oauth_refresh_tokens_refresh_token PRIMARY KEY (refresh_token);


--
-- Name: organization_users_id; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY organizations_users
    ADD CONSTRAINT organization_users_id PRIMARY KEY (id);


--
-- Name: organizations_id; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY organizations
    ADD CONSTRAINT organizations_id PRIMARY KEY (id);


--
-- Name: roles_id; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT roles_id PRIMARY KEY (id);


--
-- Name: setting_categories_id; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY setting_categories
    ADD CONSTRAINT setting_categories_id PRIMARY KEY (id);


--
-- Name: settings_id; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY settings
    ADD CONSTRAINT settings_id PRIMARY KEY (id);


--
-- Name: states_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY states
    ADD CONSTRAINT states_pkey PRIMARY KEY (id);


--
-- Name: users_id; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_id PRIMARY KEY (id);


--
-- Name: acl_board_links_group_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX acl_board_links_group_id ON acl_board_links USING btree (group_id);


--
-- Name: acl_board_links_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX acl_board_links_slug ON acl_board_links USING btree (slug);


--
-- Name: acl_board_links_url; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX acl_board_links_url ON acl_board_links USING btree (url);


--
-- Name: acl_organization_links_group_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX acl_organization_links_group_id ON acl_organization_links USING btree (group_id);


--
-- Name: acl_organization_links_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX acl_organization_links_slug ON acl_organization_links USING btree (slug);


--
-- Name: acl_organization_links_url; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX acl_organization_links_url ON acl_organization_links USING btree (url);


--
-- Name: activities_attachment_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX activities_attachment_id ON activities USING btree (foreign_id);


--
-- Name: activities_board_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX activities_board_id ON activities USING btree (board_id);


--
-- Name: activities_card_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX activities_card_id ON activities USING btree (card_id);


--
-- Name: activities_depth; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX activities_depth ON activities USING btree (depth);


--
-- Name: activities_freshness_ts; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX activities_freshness_ts ON activities USING btree (freshness_ts);


--
-- Name: activities_list_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX activities_list_id ON activities USING btree (list_id);


--
-- Name: activities_materialized_path; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX activities_materialized_path ON activities USING btree (materialized_path);


--
-- Name: activities_path; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX activities_path ON activities USING btree (path);


--
-- Name: activities_root; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX activities_root ON activities USING btree (root);


--
-- Name: activities_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX activities_type ON activities USING btree (type);


--
-- Name: activities_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX activities_user_id ON activities USING btree (user_id);


--
-- Name: attachments_card_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX attachments_card_id ON card_attachments USING btree (card_id);


--
-- Name: board_stars_board_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX board_stars_board_id ON board_stars USING btree (board_id);


--
-- Name: board_stars_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX board_stars_user_id ON board_stars USING btree (user_id);


--
-- Name: board_subscribers_board_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX board_subscribers_board_id ON board_subscribers USING btree (board_id);


--
-- Name: board_subscribers_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX board_subscribers_user_id ON board_subscribers USING btree (user_id);


--
-- Name: board_users_board_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX board_users_board_id ON boards_users USING btree (board_id);


--
-- Name: board_users_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX board_users_user_id ON boards_users USING btree (user_id);


--
-- Name: boards_organization_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX boards_organization_id ON boards USING btree (organization_id);


--
-- Name: boards_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX boards_user_id ON boards USING btree (user_id);


--
-- Name: card_attachments_board_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX card_attachments_board_id ON card_attachments USING btree (board_id);


--
-- Name: card_attachments_list_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX card_attachments_list_id ON card_attachments USING btree (list_id);


--
-- Name: card_subscribers_card_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX card_subscribers_card_id ON card_subscribers USING btree (card_id);


--
-- Name: card_subscribers_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX card_subscribers_user_id ON card_subscribers USING btree (user_id);


--
-- Name: card_users_card_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX card_users_card_id ON cards_users USING btree (card_id);


--
-- Name: card_users_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX card_users_user_id ON cards_users USING btree (user_id);


--
-- Name: card_voters_card_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX card_voters_card_id ON card_voters USING btree (card_id);


--
-- Name: card_voters_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX card_voters_user_id ON card_voters USING btree (user_id);


--
-- Name: cards_board_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX cards_board_id ON cards USING btree (board_id);


--
-- Name: cards_labels_board_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX cards_labels_board_id ON cards_labels USING btree (board_id);


--
-- Name: cards_labels_card_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX cards_labels_card_id ON cards_labels USING btree (card_id);


--
-- Name: cards_labels_label_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX cards_labels_label_id ON cards_labels USING btree (label_id);


--
-- Name: cards_labels_list_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX cards_labels_list_id ON cards_labels USING btree (list_id);


--
-- Name: cards_list_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX cards_list_id ON cards USING btree (list_id);


--
-- Name: cards_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX cards_user_id ON cards USING btree (user_id);


--
-- Name: checklist_items_card_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX checklist_items_card_id ON checklist_items USING btree (card_id);


--
-- Name: checklist_items_checklist_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX checklist_items_checklist_id ON checklist_items USING btree (checklist_id);


--
-- Name: checklist_items_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX checklist_items_user_id ON checklist_items USING btree (user_id);


--
-- Name: checklists_card_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX checklists_card_id ON checklists USING btree (card_id);


--
-- Name: checklists_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX checklists_user_id ON checklists USING btree (user_id);


--
-- Name: email_templates_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX email_templates_name ON email_templates USING btree (name);


--
-- Name: labels_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX labels_name ON labels USING btree (name);


--
-- Name: list_subscribers_list_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX list_subscribers_list_id ON list_subscribers USING btree (list_id);


--
-- Name: list_subscribers_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX list_subscribers_user_id ON list_subscribers USING btree (user_id);


--
-- Name: lists_board_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX lists_board_id ON lists USING btree (board_id);


--
-- Name: lists_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX lists_user_id ON lists USING btree (user_id);


--
-- Name: oauth_access_tokens_client_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX oauth_access_tokens_client_id ON oauth_access_tokens USING btree (client_id);


--
-- Name: oauth_access_tokens_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX oauth_access_tokens_user_id ON oauth_access_tokens USING btree (user_id);


--
-- Name: oauth_authorization_codes_client_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX oauth_authorization_codes_client_id ON oauth_authorization_codes USING btree (client_id);


--
-- Name: oauth_authorization_codes_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX oauth_authorization_codes_user_id ON oauth_authorization_codes USING btree (user_id);


--
-- Name: oauth_clients_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX oauth_clients_user_id ON oauth_clients USING btree (user_id);


--
-- Name: oauth_refresh_tokens_client_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX oauth_refresh_tokens_client_id ON oauth_refresh_tokens USING btree (client_id);


--
-- Name: oauth_refresh_tokens_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX oauth_refresh_tokens_user_id ON oauth_refresh_tokens USING btree (user_id);


--
-- Name: organization_users_organization_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX organization_users_organization_id ON organizations_users USING btree (organization_id);


--
-- Name: organization_users_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX organization_users_user_id ON organizations_users USING btree (user_id);


--
-- Name: organizations_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX organizations_user_id ON organizations USING btree (user_id);


--
-- Name: roles_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX roles_name ON roles USING btree (name);


--
-- Name: setting_categories_parent_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX setting_categories_parent_id ON setting_categories USING btree (parent_id);


--
-- Name: settings_setting_category_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX settings_setting_category_id ON settings USING btree (setting_category_id);


--
-- Name: settings_setting_category_parent_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX settings_setting_category_parent_id ON settings USING btree (setting_category_parent_id);


--
-- Name: users_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX users_email ON users USING btree (email);


--
-- Name: users_last_activity_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX users_last_activity_id ON users USING btree (last_activity_id);


--
-- Name: users_role_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX users_role_id ON users USING btree (role_id);


--
-- Name: users_username; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX users_username ON users USING btree (username);


--
-- Name: label_card_count_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER label_card_count_update AFTER INSERT OR DELETE OR UPDATE ON cards_labels FOR EACH ROW EXECUTE PROCEDURE label_card_count_update();


--
-- Name: update_board_count; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_board_count AFTER INSERT OR DELETE OR UPDATE ON boards FOR EACH ROW EXECUTE PROCEDURE update_board_count();


--
-- Name: update_board_star_count; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_board_star_count AFTER INSERT OR DELETE OR UPDATE ON board_stars FOR EACH ROW EXECUTE PROCEDURE update_board_star_count();


--
-- Name: update_board_subscriber_count; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_board_subscriber_count AFTER INSERT OR DELETE OR UPDATE ON board_subscribers FOR EACH ROW EXECUTE PROCEDURE update_board_subscriber_count();


--
-- Name: update_board_user_count; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_board_user_count AFTER INSERT OR DELETE OR UPDATE ON boards_users FOR EACH ROW EXECUTE PROCEDURE update_board_user_count();


--
-- Name: update_card_activity_count; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_card_activity_count AFTER INSERT OR DELETE OR UPDATE ON activities FOR EACH ROW EXECUTE PROCEDURE update_card_activity_count();


--
-- Name: update_card_attachment_count; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_card_attachment_count AFTER INSERT OR DELETE OR UPDATE ON card_attachments FOR EACH ROW EXECUTE PROCEDURE update_card_attachment_count();


--
-- Name: update_card_checklist_count; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_card_checklist_count AFTER INSERT OR DELETE OR UPDATE ON checklists FOR EACH ROW EXECUTE PROCEDURE update_card_checklist_count();


--
-- Name: update_card_checklist_item_count; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_card_checklist_item_count AFTER INSERT OR DELETE OR UPDATE ON checklist_items FOR EACH ROW EXECUTE PROCEDURE update_card_checklist_item_count();


--
-- Name: update_card_count; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_card_count AFTER INSERT OR DELETE OR UPDATE ON cards FOR EACH ROW EXECUTE PROCEDURE update_card_count();


--
-- Name: update_card_subscriber_count; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_card_subscriber_count AFTER INSERT OR DELETE OR UPDATE ON card_subscribers FOR EACH ROW EXECUTE PROCEDURE update_card_subscriber_count();


--
-- Name: update_card_user_count; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_card_user_count AFTER INSERT OR DELETE OR UPDATE ON cards_users FOR EACH ROW EXECUTE PROCEDURE update_card_user_count();


--
-- Name: update_card_voters_count; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_card_voters_count AFTER INSERT OR DELETE OR UPDATE ON card_voters FOR EACH ROW EXECUTE PROCEDURE update_card_voters_count();


--
-- Name: update_comment_count; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_comment_count AFTER INSERT OR DELETE OR UPDATE ON activities FOR EACH ROW EXECUTE PROCEDURE update_comment_count();


--
-- Name: update_list_count; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_list_count AFTER INSERT OR DELETE OR UPDATE ON lists FOR EACH ROW EXECUTE PROCEDURE update_list_count();


--
-- Name: update_list_subscriber_count; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_list_subscriber_count AFTER INSERT OR DELETE OR UPDATE ON list_subscribers FOR EACH ROW EXECUTE PROCEDURE update_list_subscriber_count();


--
-- Name: update_organization_count; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_organization_count AFTER INSERT OR DELETE OR UPDATE ON organizations FOR EACH ROW EXECUTE PROCEDURE update_organization_count();


--
-- Name: update_organization_user_count; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_organization_user_count AFTER INSERT OR DELETE OR UPDATE ON organizations_users FOR EACH ROW EXECUTE PROCEDURE update_organization_user_count();


--
-- Name: update_user_delete; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_user_delete AFTER DELETE ON users FOR EACH ROW EXECUTE PROCEDURE update_user_delete();


--
-- Name: update_users_user_login_count; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_users_user_login_count AFTER INSERT OR DELETE OR UPDATE ON user_logins FOR EACH ROW EXECUTE PROCEDURE update_users_user_login_count();


--
-- Name: cities_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cities
    ADD CONSTRAINT cities_country_id_fkey FOREIGN KEY (country_id) REFERENCES countries(id) ON DELETE CASCADE;


--
-- Name: cities_state_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cities
    ADD CONSTRAINT cities_state_id_fkey FOREIGN KEY (state_id) REFERENCES states(id) ON DELETE CASCADE;


--
-- Name: states_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY states
    ADD CONSTRAINT states_country_id_fkey FOREIGN KEY (country_id) REFERENCES countries(id) ON DELETE CASCADE;


--
-- Name: public; Type: ACL; Schema: -; Owner: -
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- Name: acl_links_id_seq; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON SEQUENCE acl_links_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE acl_links_id_seq FROM postgres;
GRANT ALL ON SEQUENCE acl_links_id_seq TO postgres;


--
-- Name: acl_links_roles_roles_id_seq; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON SEQUENCE acl_links_roles_roles_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE acl_links_roles_roles_id_seq FROM postgres;
GRANT ALL ON SEQUENCE acl_links_roles_roles_id_seq TO postgres;


--
-- Name: activities_id_seq; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON SEQUENCE activities_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE activities_id_seq FROM postgres;
GRANT ALL ON SEQUENCE activities_id_seq TO postgres;


--
-- Name: activities; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE activities FROM PUBLIC;
REVOKE ALL ON TABLE activities FROM postgres;
GRANT ALL ON TABLE activities TO postgres;


--
-- Name: boards_id_seq; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON SEQUENCE boards_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE boards_id_seq FROM postgres;
GRANT ALL ON SEQUENCE boards_id_seq TO postgres;


--
-- Name: boards; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE boards FROM PUBLIC;
REVOKE ALL ON TABLE boards FROM postgres;
GRANT ALL ON TABLE boards TO postgres;


--
-- Name: cards_id_seq; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON SEQUENCE cards_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE cards_id_seq FROM postgres;
GRANT ALL ON SEQUENCE cards_id_seq TO postgres;


--
-- Name: cards; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE cards FROM PUBLIC;
REVOKE ALL ON TABLE cards FROM postgres;
GRANT ALL ON TABLE cards TO postgres;


--
-- Name: checklist_items_id_seq; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON SEQUENCE checklist_items_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE checklist_items_id_seq FROM postgres;
GRANT ALL ON SEQUENCE checklist_items_id_seq TO postgres;


--
-- Name: checklist_items; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE checklist_items FROM PUBLIC;
REVOKE ALL ON TABLE checklist_items FROM postgres;
GRANT ALL ON TABLE checklist_items TO postgres;


--
-- Name: checklists_id_seq; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON SEQUENCE checklists_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE checklists_id_seq FROM postgres;
GRANT ALL ON SEQUENCE checklists_id_seq TO postgres;


--
-- Name: checklists; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE checklists FROM PUBLIC;
REVOKE ALL ON TABLE checklists FROM postgres;
GRANT ALL ON TABLE checklists TO postgres;


--
-- Name: labels_id_seq; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON SEQUENCE labels_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE labels_id_seq FROM postgres;
GRANT ALL ON SEQUENCE labels_id_seq TO postgres;


--
-- Name: labels; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE labels FROM PUBLIC;
REVOKE ALL ON TABLE labels FROM postgres;
GRANT ALL ON TABLE labels TO postgres;


--
-- Name: lists_id_seq; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON SEQUENCE lists_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE lists_id_seq FROM postgres;
GRANT ALL ON SEQUENCE lists_id_seq TO postgres;


--
-- Name: lists; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE lists FROM PUBLIC;
REVOKE ALL ON TABLE lists FROM postgres;
GRANT ALL ON TABLE lists TO postgres;


--
-- Name: organizations_id_seq; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON SEQUENCE organizations_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE organizations_id_seq FROM postgres;
GRANT ALL ON SEQUENCE organizations_id_seq TO postgres;


--
-- Name: organizations; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE organizations FROM PUBLIC;
REVOKE ALL ON TABLE organizations FROM postgres;
GRANT ALL ON TABLE organizations TO postgres;


--
-- Name: users_id_seq; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON SEQUENCE users_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE users_id_seq FROM postgres;
GRANT ALL ON SEQUENCE users_id_seq TO postgres;


--
-- Name: users; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE users FROM PUBLIC;
REVOKE ALL ON TABLE users FROM postgres;
GRANT ALL ON TABLE users TO postgres;


--
-- Name: boards_users_id_seq; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON SEQUENCE boards_users_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE boards_users_id_seq FROM postgres;
GRANT ALL ON SEQUENCE boards_users_id_seq TO postgres;


--
-- Name: boards_users; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE boards_users FROM PUBLIC;
REVOKE ALL ON TABLE boards_users FROM postgres;
GRANT ALL ON TABLE boards_users TO postgres;


--
-- Name: attachments_id_seq; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON SEQUENCE attachments_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE attachments_id_seq FROM postgres;
GRANT ALL ON SEQUENCE attachments_id_seq TO postgres;


--
-- Name: boards_stars_id_seq; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON SEQUENCE boards_stars_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE boards_stars_id_seq FROM postgres;
GRANT ALL ON SEQUENCE boards_stars_id_seq TO postgres;


--
-- Name: board_stars; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE board_stars FROM PUBLIC;
REVOKE ALL ON TABLE board_stars FROM postgres;
GRANT ALL ON TABLE board_stars TO postgres;


--
-- Name: boards_subscribers_id_seq; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON SEQUENCE boards_subscribers_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE boards_subscribers_id_seq FROM postgres;
GRANT ALL ON SEQUENCE boards_subscribers_id_seq TO postgres;


--
-- Name: board_subscribers; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE board_subscribers FROM PUBLIC;
REVOKE ALL ON TABLE board_subscribers FROM postgres;
GRANT ALL ON TABLE board_subscribers TO postgres;


--
-- Name: cards_labels_id_seq; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON SEQUENCE cards_labels_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE cards_labels_id_seq FROM postgres;
GRANT ALL ON SEQUENCE cards_labels_id_seq TO postgres;


--
-- Name: cards_labels; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE cards_labels FROM PUBLIC;
REVOKE ALL ON TABLE cards_labels FROM postgres;
GRANT ALL ON TABLE cards_labels TO postgres;


--
-- Name: card_attachments_id_seq; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON SEQUENCE card_attachments_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE card_attachments_id_seq FROM postgres;
GRANT ALL ON SEQUENCE card_attachments_id_seq TO postgres;


--
-- Name: card_attachments; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE card_attachments FROM PUBLIC;
REVOKE ALL ON TABLE card_attachments FROM postgres;
GRANT ALL ON TABLE card_attachments TO postgres;


--
-- Name: cards_subscribers_id_seq; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON SEQUENCE cards_subscribers_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE cards_subscribers_id_seq FROM postgres;
GRANT ALL ON SEQUENCE cards_subscribers_id_seq TO postgres;


--
-- Name: card_subscribers; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE card_subscribers FROM PUBLIC;
REVOKE ALL ON TABLE card_subscribers FROM postgres;
GRANT ALL ON TABLE card_subscribers TO postgres;


--
-- Name: card_voters_id_seq; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON SEQUENCE card_voters_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE card_voters_id_seq FROM postgres;
GRANT ALL ON SEQUENCE card_voters_id_seq TO postgres;


--
-- Name: card_voters; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE card_voters FROM PUBLIC;
REVOKE ALL ON TABLE card_voters FROM postgres;
GRANT ALL ON TABLE card_voters TO postgres;


--
-- Name: cards_users_id_seq; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON SEQUENCE cards_users_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE cards_users_id_seq FROM postgres;
GRANT ALL ON SEQUENCE cards_users_id_seq TO postgres;


--
-- Name: cards_users; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE cards_users FROM PUBLIC;
REVOKE ALL ON TABLE cards_users FROM postgres;
GRANT ALL ON TABLE cards_users TO postgres;


--
-- Name: lists_subscribers_id_seq; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON SEQUENCE lists_subscribers_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE lists_subscribers_id_seq FROM postgres;
GRANT ALL ON SEQUENCE lists_subscribers_id_seq TO postgres;


--
-- Name: list_subscribers; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE list_subscribers FROM PUBLIC;
REVOKE ALL ON TABLE list_subscribers FROM postgres;
GRANT ALL ON TABLE list_subscribers TO postgres;


--
-- Name: checklist_add_listing; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE checklist_add_listing FROM PUBLIC;
REVOKE ALL ON TABLE checklist_add_listing FROM postgres;
GRANT ALL ON TABLE checklist_add_listing TO postgres;


--
-- Name: cities; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE cities FROM PUBLIC;
REVOKE ALL ON TABLE cities FROM postgres;
GRANT ALL ON TABLE cities TO postgres;


--
-- Name: cities_id_seq; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON SEQUENCE cities_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE cities_id_seq FROM postgres;
GRANT ALL ON SEQUENCE cities_id_seq TO postgres;


--
-- Name: cities_id_seq1; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON SEQUENCE cities_id_seq1 FROM PUBLIC;
REVOKE ALL ON SEQUENCE cities_id_seq1 FROM postgres;
GRANT ALL ON SEQUENCE cities_id_seq1 TO postgres;


--
-- Name: countries; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE countries FROM PUBLIC;
REVOKE ALL ON TABLE countries FROM postgres;
GRANT ALL ON TABLE countries TO postgres;


--
-- Name: countries_id_seq; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON SEQUENCE countries_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE countries_id_seq FROM postgres;
GRANT ALL ON SEQUENCE countries_id_seq TO postgres;


--
-- Name: countries_id_seq1; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON SEQUENCE countries_id_seq1 FROM PUBLIC;
REVOKE ALL ON SEQUENCE countries_id_seq1 FROM postgres;
GRANT ALL ON SEQUENCE countries_id_seq1 TO postgres;


--
-- Name: email_templates_id_seq; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON SEQUENCE email_templates_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE email_templates_id_seq FROM postgres;
GRANT ALL ON SEQUENCE email_templates_id_seq TO postgres;


--
-- Name: email_templates; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE email_templates FROM PUBLIC;
REVOKE ALL ON TABLE email_templates FROM postgres;
GRANT ALL ON TABLE email_templates TO postgres;


--
-- Name: ips_id_seq; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON SEQUENCE ips_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE ips_id_seq FROM postgres;
GRANT ALL ON SEQUENCE ips_id_seq TO postgres;


--
-- Name: ips; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE ips FROM PUBLIC;
REVOKE ALL ON TABLE ips FROM postgres;
GRANT ALL ON TABLE ips TO postgres;


--
-- Name: list_subscribers_id_seq; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON SEQUENCE list_subscribers_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE list_subscribers_id_seq FROM postgres;
GRANT ALL ON SEQUENCE list_subscribers_id_seq TO postgres;


--
-- Name: login_types_id_seq; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON SEQUENCE login_types_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE login_types_id_seq FROM postgres;
GRANT ALL ON SEQUENCE login_types_id_seq TO postgres;


--
-- Name: login_types; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE login_types FROM PUBLIC;
REVOKE ALL ON TABLE login_types FROM postgres;
GRANT ALL ON TABLE login_types TO postgres;


--
-- Name: oauth_access_tokens; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE oauth_access_tokens FROM PUBLIC;
REVOKE ALL ON TABLE oauth_access_tokens FROM postgres;
GRANT ALL ON TABLE oauth_access_tokens TO postgres;


--
-- Name: oauth_authorization_codes; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE oauth_authorization_codes FROM PUBLIC;
REVOKE ALL ON TABLE oauth_authorization_codes FROM postgres;
GRANT ALL ON TABLE oauth_authorization_codes TO postgres;


--
-- Name: oauth_clients; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE oauth_clients FROM PUBLIC;
REVOKE ALL ON TABLE oauth_clients FROM postgres;
GRANT ALL ON TABLE oauth_clients TO postgres;


--
-- Name: oauth_jwt; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE oauth_jwt FROM PUBLIC;
REVOKE ALL ON TABLE oauth_jwt FROM postgres;
GRANT ALL ON TABLE oauth_jwt TO postgres;


--
-- Name: oauth_refresh_tokens; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE oauth_refresh_tokens FROM PUBLIC;
REVOKE ALL ON TABLE oauth_refresh_tokens FROM postgres;
GRANT ALL ON TABLE oauth_refresh_tokens TO postgres;


--
-- Name: oauth_scopes; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE oauth_scopes FROM PUBLIC;
REVOKE ALL ON TABLE oauth_scopes FROM postgres;
GRANT ALL ON TABLE oauth_scopes TO postgres;


--
-- Name: organizations_users_id_seq; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON SEQUENCE organizations_users_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE organizations_users_id_seq FROM postgres;
GRANT ALL ON SEQUENCE organizations_users_id_seq TO postgres;


--
-- Name: organizations_users; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE organizations_users FROM PUBLIC;
REVOKE ALL ON TABLE organizations_users FROM postgres;
GRANT ALL ON TABLE organizations_users TO postgres;


--
-- Name: roles_id_seq; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON SEQUENCE roles_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE roles_id_seq FROM postgres;
GRANT ALL ON SEQUENCE roles_id_seq TO postgres;


--
-- Name: roles; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE roles FROM PUBLIC;
REVOKE ALL ON TABLE roles FROM postgres;
GRANT ALL ON TABLE roles TO postgres;


--
-- Name: setting_categories; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE setting_categories FROM PUBLIC;
REVOKE ALL ON TABLE setting_categories FROM postgres;
GRANT ALL ON TABLE setting_categories TO postgres;


--
-- Name: setting_categories_id_seq; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON SEQUENCE setting_categories_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE setting_categories_id_seq FROM postgres;
GRANT ALL ON SEQUENCE setting_categories_id_seq TO postgres;


--
-- Name: settings_id_seq; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON SEQUENCE settings_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE settings_id_seq FROM postgres;
GRANT ALL ON SEQUENCE settings_id_seq TO postgres;


--
-- Name: settings; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE settings FROM PUBLIC;
REVOKE ALL ON TABLE settings FROM postgres;
GRANT ALL ON TABLE settings TO postgres;


--
-- Name: states; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE states FROM PUBLIC;
REVOKE ALL ON TABLE states FROM postgres;
GRANT ALL ON TABLE states TO postgres;


--
-- Name: states_id_seq; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON SEQUENCE states_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE states_id_seq FROM postgres;
GRANT ALL ON SEQUENCE states_id_seq TO postgres;


--
-- Name: states_id_seq1; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON SEQUENCE states_id_seq1 FROM PUBLIC;
REVOKE ALL ON SEQUENCE states_id_seq1 FROM postgres;
GRANT ALL ON SEQUENCE states_id_seq1 TO postgres;


--
-- Name: user_logins; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE user_logins FROM PUBLIC;
REVOKE ALL ON TABLE user_logins FROM postgres;
GRANT ALL ON TABLE user_logins TO postgres;


--
-- Name: user_logins_id_seq; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON SEQUENCE user_logins_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE user_logins_id_seq FROM postgres;
GRANT ALL ON SEQUENCE user_logins_id_seq TO postgres;


--
-- PostgreSQL database dump complete
--

