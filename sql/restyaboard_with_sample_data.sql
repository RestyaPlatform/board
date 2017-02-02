--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.4
-- Dumped by pg_dump version 9.5.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

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
-- Name: acl_board_links; Type: TABLE; Schema: public; Owner: -
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
-- Name: acl_board_links_boards_user_roles; Type: TABLE; Schema: public; Owner: -
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
-- Name: acl_links; Type: TABLE; Schema: public; Owner: -
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
-- Name: acl_links_roles; Type: TABLE; Schema: public; Owner: -
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
-- Name: acl_organization_links; Type: TABLE; Schema: public; Owner: -
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
-- Name: acl_organization_links_organizations_user_roles; Type: TABLE; Schema: public; Owner: -
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
-- Name: activities; Type: TABLE; Schema: public; Owner: -
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
-- Name: boards; Type: TABLE; Schema: public; Owner: -
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
-- Name: cards; Type: TABLE; Schema: public; Owner: -
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
-- Name: checklist_items; Type: TABLE; Schema: public; Owner: -
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
-- Name: checklists; Type: TABLE; Schema: public; Owner: -
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
-- Name: labels; Type: TABLE; Schema: public; Owner: -
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
-- Name: lists; Type: TABLE; Schema: public; Owner: -
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
-- Name: organizations; Type: TABLE; Schema: public; Owner: -
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
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users (
    id bigint DEFAULT nextval('users_id_seq'::regclass) NOT NULL,
    created timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    role_id integer DEFAULT 0 NOT NULL,
    username character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    password character varying(256) NOT NULL,
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
    to_char(activity.created, 'HH24:MI'::text) AS created_time,
    card."position" AS card_position,
    card.comment_count
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
-- Name: boards_users; Type: TABLE; Schema: public; Owner: -
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
-- Name: cities; Type: TABLE; Schema: public; Owner: -
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
-- Name: countries; Type: TABLE; Schema: public; Owner: -
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
-- Name: ips_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ips_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ips; Type: TABLE; Schema: public; Owner: -
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
-- Name: login_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE login_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: login_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE login_types (
    id bigint DEFAULT nextval('login_types_id_seq'::regclass) NOT NULL,
    created timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    name character varying(255) NOT NULL
);


--
-- Name: states; Type: TABLE; Schema: public; Owner: -
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
-- Name: admin_users_listing; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW admin_users_listing AS
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
    users.last_activity_id,
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
-- Name: board_stars; Type: TABLE; Schema: public; Owner: -
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
-- Name: board_subscribers; Type: TABLE; Schema: public; Owner: -
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
-- Name: board_user_roles; Type: TABLE; Schema: public; Owner: -
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
-- Name: cards_labels; Type: TABLE; Schema: public; Owner: -
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
-- Name: card_attachments; Type: TABLE; Schema: public; Owner: -
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
-- Name: card_subscribers; Type: TABLE; Schema: public; Owner: -
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
-- Name: card_voters; Type: TABLE; Schema: public; Owner: -
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
-- Name: cards_users; Type: TABLE; Schema: public; Owner: -
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
                  ORDER BY cards_labels.name) cl) AS cards_labels,
    cards.comment_count,
    u.username,
    b.name AS board_name,
    l.name AS list_name,
    cards.custom_fields,
    cards.due_date AS notification_due_date
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
-- Name: list_subscribers; Type: TABLE; Schema: public; Owner: -
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
-- Name: email_templates; Type: TABLE; Schema: public; Owner: -
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
-- Name: languages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE languages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: languages; Type: TABLE; Schema: public; Owner: -
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
-- Name: oauth_access_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE oauth_access_tokens (
    access_token character varying(40) NOT NULL,
    client_id character varying(80),
    user_id character varying(255),
    expires timestamp without time zone,
    scope character varying(2000)
);


--
-- Name: oauth_authorization_codes; Type: TABLE; Schema: public; Owner: -
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
-- Name: oauth_clients; Type: TABLE; Schema: public; Owner: -
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
-- Name: oauth_jwt; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE oauth_jwt (
    client_id character varying(80) NOT NULL,
    subject character varying(80),
    public_key character varying(2000)
);


--
-- Name: oauth_refresh_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE oauth_refresh_tokens (
    refresh_token character varying(40) NOT NULL,
    client_id character varying(80),
    user_id character varying(255),
    expires timestamp without time zone,
    scope character varying(2000)
);


--
-- Name: oauth_scopes; Type: TABLE; Schema: public; Owner: -
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
-- Name: organization_user_roles; Type: TABLE; Schema: public; Owner: -
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
-- Name: organizations_users; Type: TABLE; Schema: public; Owner: -
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
-- Name: roles; Type: TABLE; Schema: public; Owner: -
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
-- Name: setting_categories; Type: TABLE; Schema: public; Owner: -
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
-- Name: settings; Type: TABLE; Schema: public; Owner: -
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
    org.logo_url AS organization_logo_url,
    board.music_content,
    board.music_name
   FROM (boards board
     LEFT JOIN organizations org ON ((org.id = board.organization_id)))
  ORDER BY board.name;


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
-- Name: user_logins; Type: TABLE; Schema: public; Owner: -
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
-- Name: webhooks; Type: TABLE; Schema: public; Owner: -
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
23	2016-02-18 17:24:25.733	2016-02-18 17:24:25.733	Unstar board	/boards/?/boards_stars/?	PUT	board_star	2	1	0	0	0
25	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Upload profile picture	/users/?	POST	add_user_profile_picture	2	1	0	0	0
26	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	User activation	/users/?/activation	PUT	user_activation	1	0	1	0	0
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
123	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Undo activity	/activities/undo/?	PUT	undo_activity	2	1	0	0	0
124	2016-03-07 11:46:41.662	2016-03-07 11:46:41.662	User detail	/users/me	GET	user_detail	0	1	0	1	1
40	2016-06-22 04:58:43.865	2016-06-22 04:58:43.865	Allow to post comments in public board	/boards/?/lists/?/cards/?/comments	POST	comment_card	2	1	0	0	0
41	2016-06-22 04:58:43.865	2016-06-22 04:58:43.865	Allow to subscribe board in public board	/boards/?/board_subscribers	POST	subscribe_board	2	1	0	0	0
42	2016-06-22 04:58:43.865	2016-06-22 04:58:43.865	Allow to subscribe list in public board	/boards/?/lists/?/list_subscribers	POST	subscribe_list	2	1	0	0	0
43	2016-06-22 04:58:43.865	2016-06-22 04:58:43.865	Allow to subscribe card in public board	/boards/?/lists/?/cards/?/card_subscribers	POST	subscribe_card	2	1	0	0	0
125	2015-10-05 13:14:18.2	2015-10-05 13:14:18.2	XMPP chat login	/xmpp_login	GET	xmpp_login	2	1	0	1	0
127	2016-06-22 04:58:44.125	2016-06-22 04:58:44.125	Role add	/roles	POST	role_add	1	0	0	1	1
128	2016-06-22 04:58:44.125	2016-06-22 04:58:44.125	Board user role add	/board_user_roles	POST	board_user_role_add	1	0	0	1	1
129	2016-06-22 04:58:44.125	2016-06-22 04:58:44.125	Organization user role add	/organization_user_roles	POST	organization_user_role_add	1	0	0	1	1
130	2016-06-22 04:58:44.128	2016-06-22 04:58:44.128	Role edit	/roles/?	PUT	role_edit	1	0	0	1	1
131	2016-06-22 04:58:44.128	2016-06-22 04:58:44.128	Board user role edit	/board_user_roles/?	PUT	board_user_role_edit	1	0	0	1	1
132	2016-06-22 04:58:44.128	2016-06-22 04:58:44.128	Organization user role edit	/organization_user_roles/?	PUT	organization_user_role_edit	1	0	0	1	1
40	2016-06-28 07:52:34.31	2016-06-28 07:52:34.31	Allow to post comments in public board	/boards/?/lists/?/cards/?/comments	POST	comment_card	2	1	0	0	0
41	2016-06-28 07:52:34.31	2016-06-28 07:52:34.31	Allow to subscribe board in public board	/boards/?/board_subscribers	POST	subscribe_board	2	1	0	0	0
42	2016-06-28 07:52:34.31	2016-06-28 07:52:34.31	Allow to subscribe list in public board	/boards/?/lists/?/list_subscribers	POST	subscribe_list	2	1	0	0	0
43	2016-06-28 07:52:34.31	2016-06-28 07:52:34.31	Allow to subscribe card in public board	/boards/?/lists/?/cards/?/card_subscribers	POST	subscribe_card	2	1	0	0	0
21	2016-02-18 17:42:32.045	2016-02-18 17:42:32.045	Allow to star/unstar in public board, card in public board	/boards/?/boards_stars	POST	starred_board	2	1	0	0	0
135	2016-06-28 07:52:34.541	2016-06-28 07:52:34.541	Role add	/roles	POST	role_add	1	0	0	1	1
136	2016-06-28 07:52:34.541	2016-06-28 07:52:34.541	Board user role add	/board_user_roles	POST	board_user_role_add	1	0	0	1	1
137	2016-06-28 07:52:34.541	2016-06-28 07:52:34.541	Organization user role add	/organization_user_roles	POST	organization_user_role_add	1	0	0	1	1
138	2016-06-28 07:52:34.545	2016-06-28 07:52:34.545	Role edit	/roles/?	PUT	role_edit	1	0	0	1	1
139	2016-06-28 07:52:34.545	2016-06-28 07:52:34.545	Board user role edit	/board_user_roles/?	PUT	board_user_role_edit	1	0	0	1	1
140	2016-06-28 07:52:34.545	2016-06-28 07:52:34.545	Organization user role edit	/organization_user_roles/?	PUT	organization_user_role_edit	1	0	0	1	1
126	2015-10-05 13:14:18.2	2015-10-05 13:14:18.2	Chat History	/boards/?/chat_history	GET	chat_history	2	1	0	1	0
27	2016-02-18 20:11:14.482	2016-02-18 20:11:14.482	View board	/boards/?	GET	view_board	2	1	0	0	0
\.


--
-- Name: acl_links_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('acl_links_id_seq', 140, true);


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
1224	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	123	1
1225	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	124	2
1226	2016-06-22 04:58:43.872	2016-06-22 04:58:43.872	40	1
1227	2016-06-22 04:58:43.872	2016-06-22 04:58:43.872	40	2
1228	2016-06-22 04:58:43.872	2016-06-22 04:58:43.872	41	1
1229	2016-06-22 04:58:43.872	2016-06-22 04:58:43.872	41	2
1230	2016-06-22 04:58:43.872	2016-06-22 04:58:43.872	42	1
1231	2016-06-22 04:58:43.872	2016-06-22 04:58:43.872	42	2
1232	2016-06-22 04:58:43.872	2016-06-22 04:58:43.872	43	1
1233	2016-06-22 04:58:43.872	2016-06-22 04:58:43.872	43	2
1234	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	125	1
1235	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	125	2
1236	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	126	1
1237	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	126	2
1238	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	127	1
1239	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	128	1
1240	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	129	1
1241	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	130	1
1242	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	131	1
1243	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	132	1
1244	2016-06-28 07:52:34.316	2016-06-28 07:52:34.316	40	1
1245	2016-06-28 07:52:34.316	2016-06-28 07:52:34.316	40	2
1246	2016-06-28 07:52:34.316	2016-06-28 07:52:34.316	41	1
1247	2016-06-28 07:52:34.316	2016-06-28 07:52:34.316	41	2
1248	2016-06-28 07:52:34.316	2016-06-28 07:52:34.316	42	1
1249	2016-06-28 07:52:34.316	2016-06-28 07:52:34.316	42	2
1250	2016-06-28 07:52:34.316	2016-06-28 07:52:34.316	43	1
1251	2016-06-28 07:52:34.316	2016-06-28 07:52:34.316	43	2
1252	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	125	1
1253	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	133	1
1254	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	125	2
1255	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	133	2
1256	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	126	1
1257	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	134	1
1258	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	126	2
1259	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	134	2
1260	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	127	1
1261	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	135	1
1262	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	128	1
1263	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	136	1
1264	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	129	1
1265	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	137	1
1266	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	130	1
1267	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	138	1
1268	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	131	1
1269	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	139	1
1270	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	132	1
1271	2016-02-20 19:07:50.849	2016-02-20 19:07:50.849	140	1
\.


--
-- Name: acl_links_roles_roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('acl_links_roles_roles_id_seq', 1271, true);


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
1036	2015-05-25 15:04:04.138381	2015-05-25 15:04:04.138381	7	0	0	12	15	add_board_user	BlakeRoss added member to board		0	2015-05-25 03:04:04	0	P1036	000000ss	0
1035	2015-05-25 15:03:23.384726	2015-05-25 15:03:23.384726	7	207	456	12	149	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 03:03:23	0	P1035	000000sr	0
1034	2015-05-25 15:03:20.132901	2015-05-25 15:03:20.132901	7	207	456	12	150	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 03:03:20	0	P1034	000000sq	0
1033	2015-05-25 15:03:16.743208	2015-05-25 15:03:16.743208	7	207	456	12	151	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 03:03:16	0	P1033	000000sp	0
1032	2015-05-25 15:02:54.833279	2015-05-25 15:02:54.833279	7	207	456	12	148	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 03:02:54	0	P1032	000000so	0
1031	2015-05-25 15:02:50.361438	2015-05-25 15:02:50.361438	7	211	604	12	198	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 03:02:50	0	P1031	000000sn	0
1030	2015-05-25 15:02:39.79576	2015-05-25 15:02:39.79576	7	207	456	12	148	update_card_checklist_item	BlakeRoss updated checklist item to incomplete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"t";}s:9:"new_value";a:1:{s:12:"is_completed";s:5:"false";}}	0	2015-05-25 03:02:39	0	P1030	000000sm	0
1029	2015-05-25 15:02:17.296864	2015-05-25 15:02:17.296864	7	207	456	12	148	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 03:02:17	0	P1029	000000sl	0
1028	2015-05-25 15:01:41.633154	2015-05-25 15:01:41.633154	7	207	456	12	147	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 03:01:41	0	P1028	000000sk	0
1027	2015-05-25 15:01:32.61565	2015-05-25 15:01:32.61565	7	212	606	12	203	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 03:01:32	0	P1027	000000sj	0
1026	2015-05-25 15:01:24.054355	2015-05-25 15:01:24.054355	7	207	456	12	146	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 03:01:24	0	P1026	000000si	0
1025	2015-05-25 15:01:05.11857	2015-05-25 15:01:05.11857	7	207	456	12	145	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 03:01:05	0	P1025	000000sh	0
1024	2015-05-25 15:00:57.124828	2015-05-25 15:00:57.124828	7	207	456	12	144	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 03:00:57	0	P1024	000000sg	0
1023	2015-05-25 15:00:46.369435	2015-05-25 15:00:46.369435	7	207	456	12	143	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 03:00:46	0	P1023	000000sf	0
1022	2015-05-25 15:00:39.847304	2015-05-25 15:00:39.847304	7	207	456	12	142	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 03:00:39	0	P1022	000000se	0
1021	2015-05-25 15:00:35.584951	2015-05-25 15:00:35.584951	7	207	456	12	141	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 03:00:35	0	P1021	000000sd	0
1020	2015-05-25 14:59:22.938262	2015-05-25 14:59:22.938262	7	212	606	12	202	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 02:59:22	0	P1020	000000sc	0
1019	2015-05-25 14:59:13.595438	2015-05-25 14:59:13.595438	7	212	606	12	201	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 02:59:13	0	P1019	000000sb	0
1018	2015-05-25 14:59:05.383829	2015-05-25 14:59:05.383829	7	212	606	12	200	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 02:59:05	0	P1018	000000sa	0
1017	2015-05-25 14:59:02.986748	2015-05-25 14:59:02.986748	7	207	456	12	140	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 02:59:03	0	P1017	000000s9	0
1016	2015-05-25 14:58:52.559784	2015-05-25 14:58:52.559784	7	207	456	12	139	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 02:58:52	0	P1016	000000s8	0
1015	2015-05-25 14:58:27.219329	2015-05-25 14:58:27.219329	7	207	456	12	138	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 02:58:27	0	P1015	000000s7	0
1014	2015-05-25 14:58:13.122309	2015-05-25 14:58:13.122309	7	210	554	12	179	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 02:58:13	0	P1014	000000s6	0
906	2015-05-25 13:47:28.872097	2015-05-25 13:47:28.872097	6	203	609	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Exited".		0	2015-05-25 01:47:28	0	P906	000000p6	0
901	2015-05-25 13:47:03.264711	2015-05-25 13:47:03.264711	7	212	606	12	203	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:47:03	0	P901	000000p1	0
1013	2015-05-25 14:58:10.939277	2015-05-25 14:58:10.939277	7	210	554	12	178	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 02:58:10	0	P1013	000000s5	0
1012	2015-05-25 14:58:09.190372	2015-05-25 14:58:09.190372	7	210	554	12	177	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 02:58:09	0	P1012	000000s4	0
1011	2015-05-25 14:57:58.232785	2015-05-25 14:57:58.232785	7	209	552	12	176	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 02:57:58	0	P1011	000000s3	0
1010	2015-05-25 14:57:35.745111	2015-05-25 14:57:35.745111	7	206	357	12	109	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"t";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 02:57:35	0	P1010	000000s2	0
1009	2015-05-25 14:57:33.472775	2015-05-25 14:57:33.472775	7	206	357	12	111	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"t";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 02:57:33	0	P1009	000000s1	0
1008	2015-05-25 14:57:31.030492	2015-05-25 14:57:31.030492	7	206	357	12	110	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"t";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 02:57:31	0	P1008	000000s0	0
1007	2015-05-25 14:56:25.570703	2015-05-25 14:56:25.570703	7	212	607	12	7	add_card_user	BlakeRoss added "MikedeBoer" as member to this card ##CARD_LINK##		0	2015-05-25 02:56:25	0	P1007	000000rz	0
1006	2015-05-25 14:56:18.366912	2015-05-25 14:56:18.366912	7	211	605	12	6	add_card_user	BlakeRoss added "BrianGrinstead" as member to this card ##CARD_LINK##		0	2015-05-25 02:56:18	0	P1006	000000ry	0
1005	2015-05-25 14:55:59.488403	2015-05-25 14:55:59.488403	7	207	492	12	5	add_card_user	BlakeRoss added "MarkBanner" as member to this card ##CARD_LINK##		0	2015-05-25 02:55:59	0	P1005	000000rx	0
1004	2015-05-25 14:55:49.871527	2015-05-25 14:55:49.871527	7	206	397	12	4	add_card_user	BlakeRoss added "MikedeBoer" as member to this card ##CARD_LINK##		0	2015-05-25 02:55:49	0	P1004	000000rw	0
1003	2015-05-25 14:55:29.679566	2015-05-25 14:55:29.679566	7	205	342	12	3	add_card_user	BlakeRoss added "BrianGrinstead" as member to this card ##CARD_LINK##		0	2015-05-25 02:55:29	0	P1003	000000rv	0
1002	2015-05-25 14:55:20.29927	2015-05-25 14:55:20.29927	7	204	207	12	2	add_card_user	BlakeRoss added "MarkBanner" as member to this card ##CARD_LINK##		0	2015-05-25 02:55:20	0	P1002	000000ru	0
1001	2015-05-25 14:54:47.767912	2015-05-25 14:54:47.767912	7	206	357	12	110	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 02:54:47	0	P1001	000000rt	0
1000	2015-05-25 14:54:47.208348	2015-05-25 14:54:47.208348	7	206	357	12	111	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 02:54:47	0	P1000	000000rs	0
999	2015-05-25 14:54:43.747076	2015-05-25 14:54:43.747076	7	206	357	12	109	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 02:54:43	0	P999	000000rr	0
998	2015-05-25 14:54:30.754544	2015-05-25 14:54:30.754544	7	0	0	12	14	add_board_user	BlakeRoss added member to board		0	2015-05-25 02:54:30	0	P998	000000rq	0
997	2015-05-25 14:53:47.307302	2015-05-25 14:53:47.307302	7	0	0	12	13	add_board_user	BlakeRoss added member to board		0	2015-05-25 02:53:47	0	P997	000000rp	0
996	2015-05-25 14:53:34.014728	2015-05-25 14:53:34.014728	7	0	0	12	12	add_board_user	BlakeRoss added member to board		0	2015-05-25 02:53:34	0	P996	000000ro	0
995	2015-05-25 14:48:25.219174	2015-05-25 14:48:25.219174	7	0	0	12	11	delete_board_user	BlakeRoss removed member "DaveHyatt " from board		0	2015-05-25 02:48:25	0	P995	000000rn	0
994	2015-05-25 14:47:50.210586	2015-05-25 14:47:50.210586	7	206	357	12	108	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 02:47:50	0	P994	000000rm	0
993	2015-05-25 14:47:25.449665	2015-05-25 14:47:25.449665	7	0	0	12	11	add_board_user	BlakeRoss added member to board		0	2015-05-25 02:47:25	0	P993	000000rl	0
992	2015-05-25 14:46:28.344744	2015-05-25 14:46:28.344744	7	206	357	12	107	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 02:46:28	0	P992	000000rk	0
991	2015-05-25 14:46:05.630042	2015-05-25 14:46:05.630042	7	206	357	12	106	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 02:46:05	0	P991	000000rj	0
990	2015-05-25 14:44:48.006825	2015-05-25 14:44:48.006825	7	206	357	12	106	update_card_checklist_item	BlakeRoss updated checklist item to incomplete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"t";}s:9:"new_value";a:1:{s:12:"is_completed";s:5:"false";}}	0	2015-05-25 02:44:48	0	P990	000000ri	0
989	2015-05-25 14:44:27.294627	2015-05-25 14:44:27.294627	7	206	357	12	106	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 02:44:27	0	P989	000000rh	0
988	2015-05-25 14:44:22.578543	2015-05-25 14:44:22.578543	7	206	357	12	105	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 02:44:22	0	P988	000000rg	0
987	2015-05-25 14:44:10.340688	2015-05-25 14:44:10.340688	7	206	357	12	104	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 02:44:10	0	P987	000000rf	0
905	2015-05-25 13:47:27.884975	2015-05-25 13:47:27.884975	7	212	607	12	204	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:47:27	0	P905	000000p5	0
900	2015-05-25 13:46:57.769457	2015-05-25 13:46:57.769457	7	212	606	12	202	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:46:57	0	P900	000000p0	0
986	2015-05-25 14:44:09.063156	2015-05-25 14:44:09.063156	7	206	357	12	103	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 02:44:09	0	P986	000000re	0
985	2015-05-25 14:44:02.444208	2015-05-25 14:44:02.444208	7	206	357	12	102	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 02:44:02	0	P985	000000rd	0
984	2015-05-25 14:44:00.371826	2015-05-25 14:44:00.371826	7	206	357	12	101	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 02:44:00	0	P984	000000rc	0
983	2015-05-25 14:40:33.448225	2015-05-25 14:40:33.448225	7	206	357	12	101	update_card_checklist_item	BlakeRoss updated checklist item to incomplete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"t";}s:9:"new_value";a:1:{s:12:"is_completed";s:5:"false";}}	0	2015-05-25 02:40:33	0	P983	000000rb	0
982	2015-05-25 14:37:43.5971	2015-05-25 14:37:43.5971	7	206	357	12	101	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 02:37:43	0	P982	000000ra	0
981	2015-05-25 14:31:10.063716	2015-05-25 14:31:10.063716	7	206	357	12	100	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 02:31:10	0	P981	000000r9	0
980	2015-05-25 14:26:35.245808	2015-05-25 14:26:35.245808	7	206	357	12	99	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 02:26:35	0	P980	000000r8	0
979	2015-05-25 13:59:55.247819	2015-05-25 13:59:55.247819	7	209	552	12	176	update_card_checklist_item	BlakeRoss updated checklist item to incomplete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"t";}s:9:"new_value";a:1:{s:12:"is_completed";s:5:"false";}}	0	2015-05-25 01:59:55	0	P979	000000r7	0
978	2015-05-25 13:58:38.634301	2015-05-25 13:58:38.634301	7	209	552	12	176	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 01:58:38	0	P978	000000r6	0
977	2015-05-25 13:58:09.866857	2015-05-25 13:58:09.866857	7	209	552	12	175	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 01:58:09	0	P977	000000r5	0
976	2015-05-25 13:56:54.771601	2015-05-25 13:56:54.771601	7	208	550	12	173	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 01:56:54	0	P976	000000r4	0
975	2015-05-25 13:55:58.030701	2015-05-25 13:55:58.030701	7	205	279	12	72	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 01:55:58	0	P975	000000r3	0
964	2015-05-25 13:54:43.352328	2015-05-25 13:54:43.352328	7	205	279	12	72	update_card_checklist_item	BlakeRoss updated checklist item to incomplete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"t";}s:9:"new_value";a:1:{s:12:"is_completed";s:5:"false";}}	0	2015-05-25 01:54:43	0	P964	000000qs	0
962	2015-05-25 13:54:35.670604	2015-05-25 13:54:35.670604	7	205	279	12	72	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 01:54:35	0	P962	000000qq	0
306	2015-05-25 12:58:51.276956	2015-05-25 12:58:51.276956	7	205	235	12	\N	add_card	BlakeRoss added card ##CARD_LINK## to list "36.0.1".		0	2015-05-25 12:58:51	0	P306	0000008i	0
953	2015-05-25 13:54:06.474934	2015-05-25 13:54:06.474934	7	205	279	12	71	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 01:54:06	0	P953	000000qh	0
951	2015-05-25 13:54:01.929887	2015-05-25 13:54:01.929887	7	205	279	12	70	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 01:54:01	0	P951	000000qf	0
946	2015-05-25 13:53:49.278611	2015-05-25 13:53:49.278611	7	205	279	12	63	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 01:53:49	0	P946	000000qa	0
945	2015-05-25 13:53:47.525525	2015-05-25 13:53:47.525525	6	203	637	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Exited".		0	2015-05-25 01:53:47	0	P945	000000q9	0
944	2015-05-25 13:53:43.834074	2015-05-25 13:53:43.834074	6	203	636	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Exited".		0	2015-05-25 01:53:43	0	P944	000000q8	0
943	2015-05-25 13:53:40.6677	2015-05-25 13:53:40.6677	6	203	635	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Exited".		0	2015-05-25 01:53:40	0	P943	000000q7	0
942	2015-05-25 13:53:39.134174	2015-05-25 13:53:39.134174	7	205	279	12	62	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 01:53:39	0	P942	000000q6	0
941	2015-05-25 13:53:37.59627	2015-05-25 13:53:37.59627	6	203	634	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Exited".		0	2015-05-25 01:53:37	0	P941	000000q5	0
940	2015-05-25 13:53:33.976187	2015-05-25 13:53:33.976187	6	203	633	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Exited".		0	2015-05-25 01:53:33	0	P940	000000q4	0
939	2015-05-25 13:53:31.131262	2015-05-25 13:53:31.131262	7	205	279	12	61	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 01:53:31	0	P939	000000q3	0
904	2015-05-25 13:47:25.788836	2015-05-25 13:47:25.788836	6	203	608	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Exited".		0	2015-05-25 01:47:25	0	P904	000000p4	0
899	2015-05-25 13:46:47.115337	2015-05-25 13:46:47.115337	7	212	606	12	201	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:46:47	0	P899	000000oz	0
938	2015-05-25 13:53:23.443826	2015-05-25 13:53:23.443826	7	205	279	12	60	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 01:53:23	0	P938	000000q2	0
937	2015-05-25 13:53:16.502458	2015-05-25 13:53:16.502458	7	205	279	12	59	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 01:53:16	0	P937	000000q1	0
936	2015-05-25 13:53:14.997243	2015-05-25 13:53:14.997243	7	205	279	12	58	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 01:53:15	0	P936	000000q0	0
935	2015-05-25 13:53:01.789369	2015-05-25 13:53:01.789369	7	205	279	12	57	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 01:53:01	0	P935	000000pz	0
934	2015-05-25 13:53:00.325624	2015-05-25 13:53:00.325624	7	205	279	12	56	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 01:53:00	0	P934	000000py	0
933	2015-05-25 13:52:59.31914	2015-05-25 13:52:59.31914	7	205	279	12	55	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 01:52:59	0	P933	000000px	0
932	2015-05-25 13:52:49.255175	2015-05-25 13:52:49.255175	7	204	180	12	28	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 01:52:49	0	P932	000000pw	0
931	2015-05-25 13:52:48.305338	2015-05-25 13:52:48.305338	7	204	180	12	27	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 01:52:48	0	P931	000000pv	0
930	2015-05-25 13:52:47.03322	2015-05-25 13:52:47.03322	7	204	180	12	26	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 01:52:47	0	P930	000000pu	0
929	2015-05-25 13:52:41.486434	2015-05-25 13:52:41.486434	6	203	632	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Exited".		0	2015-05-25 01:52:41	0	P929	000000pt	0
928	2015-05-25 13:52:29.328376	2015-05-25 13:52:29.328376	6	203	631	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Exited".		0	2015-05-25 01:52:29	0	P928	000000ps	0
927	2015-05-25 13:52:26.402565	2015-05-25 13:52:26.402565	6	203	630	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Exited".		0	2015-05-25 01:52:26	0	P927	000000pr	0
926	2015-05-25 13:52:22.903682	2015-05-25 13:52:22.903682	6	203	629	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Exited".		0	2015-05-25 01:52:22	0	P926	000000pq	0
925	2015-05-25 13:52:19.12054	2015-05-25 13:52:19.12054	6	203	628	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Exited".		0	2015-05-25 01:52:19	0	P925	000000pp	0
924	2015-05-25 13:52:15.762283	2015-05-25 13:52:15.762283	6	203	627	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Exited".		0	2015-05-25 01:52:15	0	P924	000000po	0
923	2015-05-25 13:51:52.488221	2015-05-25 13:51:52.488221	6	203	626	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Exited".		0	2015-05-25 01:51:52	0	P923	000000pn	0
922	2015-05-25 13:51:48.179955	2015-05-25 13:51:48.179955	6	203	625	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Exited".		0	2015-05-25 01:51:48	0	P922	000000pm	0
921	2015-05-25 13:50:51.752597	2015-05-25 13:50:51.752597	6	203	624	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Exited".		0	2015-05-25 01:50:51	0	P921	000000pl	0
920	2015-05-25 13:50:47.969216	2015-05-25 13:50:47.969216	6	203	623	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Exited".		0	2015-05-25 01:50:47	0	P920	000000pk	0
919	2015-05-25 13:50:44.281837	2015-05-25 13:50:44.281837	6	203	622	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Exited".		0	2015-05-25 01:50:44	0	P919	000000pj	0
918	2015-05-25 13:50:40.645759	2015-05-25 13:50:40.645759	6	203	621	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Exited".		0	2015-05-25 01:50:40	0	P918	000000pi	0
917	2015-05-25 13:50:37.361368	2015-05-25 13:50:37.361368	6	203	620	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Exited".		0	2015-05-25 01:50:37	0	P917	000000ph	0
916	2015-05-25 13:50:33.665881	2015-05-25 13:50:33.665881	6	203	619	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Exited".		0	2015-05-25 01:50:33	0	P916	000000pg	0
915	2015-05-25 13:50:29.957818	2015-05-25 13:50:29.957818	6	203	618	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Exited".		0	2015-05-25 01:50:29	0	P915	000000pf	0
914	2015-05-25 13:50:26.59159	2015-05-25 13:50:26.59159	6	203	617	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Exited".		0	2015-05-25 01:50:26	0	P914	000000pe	0
913	2015-05-25 13:50:23.111977	2015-05-25 13:50:23.111977	6	203	616	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Exited".		0	2015-05-25 01:50:23	0	P913	000000pd	0
912	2015-05-25 13:50:18.041353	2015-05-25 13:50:18.041353	6	203	615	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Exited".		0	2015-05-25 01:50:18	0	P912	000000pc	0
911	2015-05-25 13:50:13.835343	2015-05-25 13:50:13.835343	6	203	614	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Exited".		0	2015-05-25 01:50:13	0	P911	000000pb	0
910	2015-05-25 13:50:05.092016	2015-05-25 13:50:05.092016	6	203	613	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Exited".		0	2015-05-25 01:50:05	0	P910	000000pa	0
909	2015-05-25 13:49:55.321043	2015-05-25 13:49:55.321043	6	203	612	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Exited".		0	2015-05-25 01:49:55	0	P909	000000p9	0
908	2015-05-25 13:49:47.958955	2015-05-25 13:49:47.958955	6	203	611	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Exited".		0	2015-05-25 01:49:47	0	P908	000000p8	0
907	2015-05-25 13:49:43.709333	2015-05-25 13:49:43.709333	6	203	610	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Exited".		0	2015-05-25 01:49:43	0	P907	000000p7	0
903	2015-05-25 13:47:20.277327	2015-05-25 13:47:20.277327	7	212	607	12	41	add_card_checklist	BlakeRoss added checklist to this card ##CARD_LINK##		0	2015-05-25 01:47:20	0	P903	000000p3	0
902	2015-05-25 13:47:14.914421	2015-05-25 13:47:14.914421	7	212	607	12	\N	add_card	BlakeRoss added card ##CARD_LINK## to list "38.0.1".		0	2015-05-25 01:47:14	0	P902	000000p2	0
898	2015-05-25 13:46:42.044968	2015-05-25 13:46:42.044968	7	212	606	12	200	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:46:42	0	P898	000000oy	0
897	2015-05-25 13:46:33.295699	2015-05-25 13:46:33.295699	7	212	606	12	40	add_card_checklist	BlakeRoss added checklist to this card ##CARD_LINK##		0	2015-05-25 01:46:33	0	P897	000000ox	0
896	2015-05-25 13:46:26.641042	2015-05-25 13:46:26.641042	7	212	606	12	\N	add_card	BlakeRoss added card ##CARD_LINK## to list "38.0.1".		0	2015-05-25 01:46:26	0	P896	000000ow	0
895	2015-05-25 13:46:13.807901	2015-05-25 13:46:13.807901	7	212	0	12	\N	add_list	BlakeRoss added list "38.0.1".		0	2015-05-25 01:46:13	0	P895	000000ov	0
894	2015-05-25 13:45:40.209282	2015-05-25 13:45:40.209282	7	211	605	12	199	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:45:40	0	P894	000000ou	0
893	2015-05-25 13:45:31.735004	2015-05-25 13:45:31.735004	7	211	605	12	39	add_card_checklist	BlakeRoss added checklist to this card ##CARD_LINK##		0	2015-05-25 01:45:31	0	P893	000000ot	0
892	2015-05-25 13:45:18.809939	2015-05-25 13:45:18.809939	7	211	605	12	\N	add_card	BlakeRoss added card ##CARD_LINK## to list "38".		0	2015-05-25 01:45:18	0	P892	000000os	0
891	2015-05-25 13:45:08.78546	2015-05-25 13:45:08.78546	7	211	604	12	198	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:45:08	0	P891	000000or	0
890	2015-05-25 13:45:01.044503	2015-05-25 13:45:01.044503	7	211	604	12	38	add_card_checklist	BlakeRoss added checklist to this card ##CARD_LINK##		0	2015-05-25 01:45:01	0	P890	000000oq	0
889	2015-05-25 13:44:55.027745	2015-05-25 13:44:55.027745	7	211	604	12	\N	add_card	BlakeRoss added card ##CARD_LINK## to list "38".		0	2015-05-25 01:44:55	0	P889	000000op	0
888	2015-05-25 13:44:44.886279	2015-05-25 13:44:44.886279	7	211	601	12	197	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:44:44	0	P888	000000oo	0
887	2015-05-25 13:44:40.40775	2015-05-25 13:44:40.40775	7	211	601	12	196	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:44:40	0	P887	000000on	0
886	2015-05-25 13:44:33.420009	2015-05-25 13:44:33.420009	7	211	601	12	195	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:44:33	0	P886	000000om	0
885	2015-05-25 13:44:28.361761	2015-05-25 13:44:28.361761	7	211	601	12	194	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:44:28	0	P885	000000ol	0
883	2015-05-25 13:44:19.970901	2015-05-25 13:44:19.970901	7	211	601	12	37	add_card_checklist	BlakeRoss added checklist to this card ##CARD_LINK##		0	2015-05-25 01:44:19	0	P883	000000oj	0
881	2015-05-25 13:44:14.658552	2015-05-25 13:44:14.658552	7	211	601	12	\N	add_card	BlakeRoss added card ##CARD_LINK## to list "38".		0	2015-05-25 01:44:14	0	P881	000000oh	0
878	2015-05-25 13:44:07.275661	2015-05-25 13:44:07.275661	7	211	587	12	193	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:44:07	0	P878	000000oe	0
876	2015-05-25 13:44:01.862877	2015-05-25 13:44:01.862877	7	211	587	12	192	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:44:01	0	P876	000000oc	0
873	2015-05-25 13:43:54.817792	2015-05-25 13:43:54.817792	7	211	587	12	191	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:43:54	0	P873	000000o9	0
871	2015-05-25 13:43:49.654917	2015-05-25 13:43:49.654917	7	211	587	12	190	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:43:49	0	P871	000000o7	0
868	2015-05-25 13:43:42.79749	2015-05-25 13:43:42.79749	7	211	587	12	189	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:43:42	0	P868	000000o4	0
866	2015-05-25 13:43:37.638619	2015-05-25 13:43:37.638619	7	211	587	12	188	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:43:37	0	P866	000000o2	0
864	2015-05-25 13:43:33.260249	2015-05-25 13:43:33.260249	7	211	587	12	187	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:43:33	0	P864	000000o0	0
861	2015-05-25 13:43:25.839477	2015-05-25 13:43:25.839477	7	211	587	12	36	add_card_checklist	BlakeRoss added checklist to this card ##CARD_LINK##		0	2015-05-25 01:43:25	0	P861	000000nx	0
859	2015-05-25 13:43:20.872334	2015-05-25 13:43:20.872334	7	211	587	12	\N	add_card	BlakeRoss added card ##CARD_LINK## to list "38".		0	2015-05-25 01:43:20	0	P859	000000nv	0
857	2015-05-25 13:43:14.019354	2015-05-25 13:43:14.019354	6	202	585	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Dead".		0	2015-05-25 01:43:14	0	P857	000000nt	0
856	2015-05-25 13:43:09.014719	2015-05-25 13:43:09.014719	7	211	577	12	186	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:43:09	0	P856	000000ns	0
855	2015-05-25 13:43:05.631313	2015-05-25 13:43:05.631313	6	202	584	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Dead".		0	2015-05-25 01:43:05	0	P855	000000nr	0
854	2015-05-25 13:43:04.005797	2015-05-25 13:43:04.005797	7	211	577	12	185	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:43:04	0	P854	000000nq	0
853	2015-05-25 13:43:00.756717	2015-05-25 13:43:00.756717	6	202	583	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Dead".		0	2015-05-25 01:43:00	0	P853	000000np	0
852	2015-05-25 13:42:58.144911	2015-05-25 13:42:58.144911	7	211	577	12	184	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:42:58	0	P852	000000no	0
851	2015-05-25 13:42:56.882564	2015-05-25 13:42:56.882564	6	202	582	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Dead".		0	2015-05-25 01:42:56	0	P851	000000nn	0
850	2015-05-25 13:42:53.407024	2015-05-25 13:42:53.407024	6	202	581	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Dead".		0	2015-05-25 01:42:53	0	P850	000000nm	0
849	2015-05-25 13:42:52.623554	2015-05-25 13:42:52.623554	7	211	577	12	183	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:42:52	0	P849	000000nl	0
848	2015-05-25 13:42:49.473855	2015-05-25 13:42:49.473855	6	202	580	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Dead".		0	2015-05-25 01:42:49	0	P848	000000nk	0
847	2015-05-25 13:42:45.278934	2015-05-25 13:42:45.278934	6	202	579	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Dead".		0	2015-05-25 01:42:45	0	P847	000000nj	0
846	2015-05-25 13:42:41.39544	2015-05-25 13:42:41.39544	6	202	578	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Dead".		0	2015-05-25 01:42:41	0	P846	000000ni	0
845	2015-05-25 13:42:41.02913	2015-05-25 13:42:41.02913	7	211	577	12	35	add_card_checklist	BlakeRoss added checklist to this card ##CARD_LINK##		0	2015-05-25 01:42:41	0	P845	000000nh	0
844	2015-05-25 13:42:36.464102	2015-05-25 13:42:36.464102	7	211	577	12	\N	add_card	BlakeRoss added card ##CARD_LINK## to list "38".		0	2015-05-25 01:42:36	0	P844	000000ng	0
843	2015-05-25 13:42:36.207596	2015-05-25 13:42:36.207596	6	202	576	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Dead".		0	2015-05-25 01:42:36	0	P843	000000nf	0
842	2015-05-25 13:42:33.157675	2015-05-25 13:42:33.157675	6	202	575	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Dead".		0	2015-05-25 01:42:33	0	P842	000000ne	0
841	2015-05-25 13:42:29.949408	2015-05-25 13:42:29.949408	6	202	574	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Dead".		0	2015-05-25 01:42:29	0	P841	000000nd	0
840	2015-05-25 13:42:26.742357	2015-05-25 13:42:26.742357	6	202	573	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Dead".		0	2015-05-25 01:42:26	0	P840	000000nc	0
839	2015-05-25 13:42:22.716047	2015-05-25 13:42:22.716047	6	202	572	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Dead".		0	2015-05-25 01:42:22	0	P839	000000nb	0
838	2015-05-25 13:42:21.291121	2015-05-25 13:42:21.291121	7	211	564	12	182	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:42:21	0	P838	000000na	0
837	2015-05-25 13:42:18.766526	2015-05-25 13:42:18.766526	6	202	571	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Dead".		0	2015-05-25 01:42:18	0	P837	000000n9	0
836	2015-05-25 13:42:16.308084	2015-05-25 13:42:16.308084	7	211	564	12	181	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:42:16	0	P836	000000n8	0
835	2015-05-25 13:42:13.908692	2015-05-25 13:42:13.908692	6	202	570	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Dead".		0	2015-05-25 01:42:13	0	P835	000000n7	0
834	2015-05-25 13:42:11.521356	2015-05-25 13:42:11.521356	7	211	564	12	180	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:42:11	0	P834	000000n6	0
833	2015-05-25 13:42:09.940455	2015-05-25 13:42:09.940455	6	202	569	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Dead".		0	2015-05-25 01:42:09	0	P833	000000n5	0
832	2015-05-25 13:42:04.825286	2015-05-25 13:42:04.825286	6	202	568	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Dead".		0	2015-05-25 01:42:04	0	P832	000000n4	0
831	2015-05-25 13:42:04.001384	2015-05-25 13:42:04.001384	7	211	564	12	34	add_card_checklist	BlakeRoss added checklist to this card ##CARD_LINK##		0	2015-05-25 01:42:04	0	P831	000000n3	0
830	2015-05-25 13:42:00.850298	2015-05-25 13:42:00.850298	6	202	567	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Dead".		0	2015-05-25 01:42:00	0	P830	000000n2	0
829	2015-05-25 13:41:57.275587	2015-05-25 13:41:57.275587	6	202	566	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Dead".		0	2015-05-25 01:41:57	0	P829	000000n1	0
828	2015-05-25 13:41:53.880605	2015-05-25 13:41:53.880605	6	202	565	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Dead".		0	2015-05-25 01:41:53	0	P828	000000n0	0
827	2015-05-25 13:41:52.392468	2015-05-25 13:41:52.392468	7	211	564	12	\N	add_card	BlakeRoss added card ##CARD_LINK## to list "38".		0	2015-05-25 01:41:52	0	P827	000000mz	0
826	2015-05-25 13:41:50.767269	2015-05-25 13:41:50.767269	6	202	563	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Dead".		0	2015-05-25 01:41:50	0	P826	000000my	0
825	2015-05-25 13:41:47.609245	2015-05-25 13:41:47.609245	6	202	562	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Dead".		0	2015-05-25 01:41:47	0	P825	000000mx	0
824	2015-05-25 13:41:43.617393	2015-05-25 13:41:43.617393	6	202	561	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Dead".		0	2015-05-25 01:41:43	0	P824	000000mw	0
823	2015-05-25 13:41:40.942345	2015-05-25 13:41:40.942345	7	211	0	12	\N	add_list	BlakeRoss added list "38".		0	2015-05-25 01:41:40	0	P823	000000mv	0
822	2015-05-25 13:41:40.201041	2015-05-25 13:41:40.201041	6	202	560	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Dead".		0	2015-05-25 01:41:40	0	P822	000000mu	0
821	2015-05-25 13:41:36.809348	2015-05-25 13:41:36.809348	6	202	559	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Dead".		0	2015-05-25 01:41:36	0	P821	000000mt	0
820	2015-05-25 13:41:32.717881	2015-05-25 13:41:32.717881	6	202	558	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Dead".		0	2015-05-25 01:41:32	0	P820	000000ms	0
819	2015-05-25 13:41:29.60968	2015-05-25 13:41:29.60968	6	202	557	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Dead".		0	2015-05-25 01:41:29	0	P819	000000mr	0
818	2015-05-25 13:41:24.351503	2015-05-25 13:41:24.351503	6	202	556	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Dead".		0	2015-05-25 01:41:24	0	P818	000000mq	0
817	2015-05-25 13:41:20.010031	2015-05-25 13:41:20.010031	6	202	555	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Dead".		0	2015-05-25 01:41:20	0	P817	000000mp	0
816	2015-05-25 13:41:12.035391	2015-05-25 13:41:12.035391	7	210	554	12	179	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:41:12	0	P816	000000mo	0
815	2015-05-25 13:41:06.677292	2015-05-25 13:41:06.677292	7	210	554	12	178	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:41:06	0	P815	000000mn	0
814	2015-05-25 13:41:01.991727	2015-05-25 13:41:01.991727	7	210	554	12	177	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:41:01	0	P814	000000mm	0
813	2015-05-25 13:40:54.203749	2015-05-25 13:40:54.203749	7	210	554	12	33	add_card_checklist	BlakeRoss added checklist to this card ##CARD_LINK##		0	2015-05-25 01:40:54	0	P813	000000ml	0
812	2015-05-25 13:40:48.902919	2015-05-25 13:40:48.902919	7	210	554	12	\N	add_card	BlakeRoss added card ##CARD_LINK## to list "37.0.2".		0	2015-05-25 01:40:48	0	P812	000000mk	0
810	2015-05-25 13:40:37.747703	2015-05-25 13:40:37.747703	7	210	0	12	\N	add_list	BlakeRoss added list "37.0.2".		0	2015-05-25 01:40:37	0	P810	000000mi	0
809	2015-05-25 13:40:09.087461	2015-05-25 13:40:09.087461	6	202	553	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Dead".		0	2015-05-25 01:40:09	0	P809	000000mh	0
808	2015-05-25 13:40:05.662649	2015-05-25 13:40:05.662649	7	209	552	12	176	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:40:05	0	P808	000000mg	0
807	2015-05-25 13:40:01.257791	2015-05-25 13:40:01.257791	7	209	552	12	175	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:40:01	0	P807	000000mf	0
806	2015-05-25 13:39:53.938443	2015-05-25 13:39:53.938443	7	209	552	12	32	add_card_checklist	BlakeRoss added checklist to this card ##CARD_LINK##		0	2015-05-25 01:39:53	0	P806	000000me	0
805	2015-05-25 13:39:49.229883	2015-05-25 13:39:49.229883	7	209	552	12	\N	add_card	BlakeRoss added card ##CARD_LINK## to list "37.0.1".		0	2015-05-25 01:39:49	0	P805	000000md	0
804	2015-05-25 13:39:38.18019	2015-05-25 13:39:38.18019	7	209	551	12	174	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:39:38	0	P804	000000mc	0
803	2015-05-25 13:39:29.420543	2015-05-25 13:39:29.420543	7	209	551	12	31	add_card_checklist	BlakeRoss added checklist to this card ##CARD_LINK##		0	2015-05-25 01:39:29	0	P803	000000mb	0
802	2015-05-25 13:39:15.928712	2015-05-25 13:39:15.928712	7	209	551	12	\N	add_card	BlakeRoss added card ##CARD_LINK## to list "37.0.1".		0	2015-05-25 01:39:15	0	P802	000000ma	0
801	2015-05-25 13:38:58.364073	2015-05-25 13:38:58.364073	7	209	0	12	\N	add_list	BlakeRoss added list "37.0.1".		0	2015-05-25 01:38:58	0	P801	000000m9	0
800	2015-05-25 13:38:27.716064	2015-05-25 13:38:27.716064	7	208	550	12	173	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:38:27	0	P800	000000m8	0
799	2015-05-25 13:38:17.733523	2015-05-25 13:38:17.733523	7	208	550	12	30	add_card_checklist	BlakeRoss added checklist to this card ##CARD_LINK##		0	2015-05-25 01:38:17	0	P799	000000m7	0
798	2015-05-25 13:38:12.291609	2015-05-25 13:38:12.291609	7	208	550	12	\N	add_card	BlakeRoss added card ##CARD_LINK## to list "37".		0	2015-05-25 01:38:12	0	P798	000000m6	0
797	2015-05-25 13:37:59.242058	2015-05-25 13:37:59.242058	7	208	549	12	172	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:37:59	0	P797	000000m5	0
796	2015-05-25 13:37:52.639554	2015-05-25 13:37:52.639554	7	208	549	12	171	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:37:52	0	P796	000000m4	0
795	2015-05-25 13:37:47.217462	2015-05-25 13:37:47.217462	7	208	549	12	170	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:37:47	0	P795	000000m3	0
794	2015-05-25 13:37:42.117814	2015-05-25 13:37:42.117814	7	208	549	12	169	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:37:42	0	P794	000000m2	0
793	2015-05-25 13:37:37.023977	2015-05-25 13:37:37.023977	7	208	549	12	168	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:37:37	0	P793	000000m1	0
792	2015-05-25 13:37:27.516565	2015-05-25 13:37:27.516565	7	208	549	12	29	add_card_checklist	BlakeRoss added checklist to this card ##CARD_LINK##		0	2015-05-25 01:37:27	0	P792	000000m0	0
791	2015-05-25 13:37:17.710149	2015-05-25 13:37:17.710149	7	208	549	12	\N	add_card	BlakeRoss added card ##CARD_LINK## to list "37".		0	2015-05-25 01:37:17	0	P791	000000lz	0
788	2015-05-25 13:37:05.21693	2015-05-25 13:37:05.21693	7	208	538	12	167	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:37:05	0	P788	000000lw	0
786	2015-05-25 13:37:00.719993	2015-05-25 13:37:00.719993	7	208	538	12	166	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:37:00	0	P786	000000lu	0
783	2015-05-25 13:36:55.76093	2015-05-25 13:36:55.76093	7	208	538	12	165	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:36:55	0	P783	000000lr	0
779	2015-05-25 13:36:45.461712	2015-05-25 13:36:45.461712	7	208	538	12	28	add_card_checklist	BlakeRoss added checklist to this card ##CARD_LINK##		0	2015-05-25 01:36:45	0	P779	000000ln	0
776	2015-05-25 13:36:36.3875	2015-05-25 13:36:36.3875	7	208	538	12	\N	add_card	BlakeRoss added card ##CARD_LINK## to list "37".		0	2015-05-25 01:36:36	0	P776	000000lk	0
770	2015-05-25 13:36:19.526309	2015-05-25 13:36:19.526309	7	208	524	12	164	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:36:19	0	P770	000000le	0
766	2015-05-25 13:35:59.687905	2015-05-25 13:35:59.687905	7	208	524	12	163	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:35:59	0	P766	000000la	0
764	2015-05-25 13:35:54.688066	2015-05-25 13:35:54.688066	7	208	524	12	162	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:35:54	0	P764	000000l8	0
762	2015-05-25 13:35:50.213365	2015-05-25 13:35:50.213365	7	208	524	12	161	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:35:50	0	P762	000000l6	0
761	2015-05-25 13:35:43.930102	2015-05-25 13:35:43.930102	7	208	524	12	160	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:35:43	0	P761	000000l5	0
760	2015-05-25 13:35:07.357516	2015-05-25 13:35:07.357516	7	208	524	12	27	add_card_checklist	BlakeRoss added checklist to this card ##CARD_LINK##		0	2015-05-25 01:35:07	0	P760	000000l4	0
756	2015-05-25 13:34:50.77398	2015-05-25 13:34:50.77398	7	208	524	12	\N	add_card	BlakeRoss added card ##CARD_LINK## to list "37".		0	2015-05-25 01:34:50	0	P756	000000l0	0
751	2015-05-25 13:34:34.255189	2015-05-25 13:34:34.255189	7	208	510	12	159	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:34:34	0	P751	000000kv	0
748	2015-05-25 13:34:28.649464	2015-05-25 13:34:28.649464	7	208	510	12	158	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:34:28	0	P748	000000ks	0
746	2015-05-25 13:34:22.85809	2015-05-25 13:34:22.85809	7	208	510	12	157	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:34:22	0	P746	000000kq	0
744	2015-05-25 13:34:17.922495	2015-05-25 13:34:17.922495	7	208	510	12	156	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:34:17	0	P744	000000ko	0
1069	2016-01-12 18:55:56.964	2016-01-12 18:55:56.964	7	205	223	12	2	add_card_voter	##USER_NAME## voted on ##CARD_LINK##		0	2016-01-12 02:25:57	0	P1069	000000tp	0
741	2015-05-25 13:34:12.816848	2015-05-25 13:34:12.816848	7	208	510	12	155	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:34:12	0	P741	000000kl	0
738	2015-05-25 13:34:02.202379	2015-05-25 13:34:02.202379	7	208	510	12	26	add_card_checklist	BlakeRoss added checklist to this card ##CARD_LINK##		0	2015-05-25 01:34:02	0	P738	000000ki	0
736	2015-05-25 13:33:55.850757	2015-05-25 13:33:55.850757	7	208	510	12	\N	add_card	BlakeRoss added card ##CARD_LINK## to list "37".		0	2015-05-25 01:33:55	0	P736	000000kg	0
735	2015-05-25 13:33:45.275586	2015-05-25 13:33:45.275586	7	208	0	12	\N	add_list	BlakeRoss added list "37".		0	2015-05-25 01:33:45	0	P735	000000kf	0
725	2015-05-25 13:31:53.896906	2015-05-25 13:31:53.896906	7	207	492	12	154	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:31:53	0	P725	000000k5	0
722	2015-05-25 13:31:47.954981	2015-05-25 13:31:47.954981	7	207	492	12	153	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:31:47	0	P722	000000k2	0
720	2015-05-25 13:31:42.469756	2015-05-25 13:31:42.469756	7	207	492	12	152	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:31:42	0	P720	000000k0	0
716	2015-05-25 13:31:33.237993	2015-05-25 13:31:33.237993	7	207	492	12	25	add_card_checklist	BlakeRoss added checklist to this card ##CARD_LINK##		0	2015-05-25 01:31:33	0	P716	000000jw	0
713	2015-05-25 13:31:27.305835	2015-05-25 13:31:27.305835	7	207	492	12	\N	add_card	BlakeRoss added card ##CARD_LINK## to list "36.0.4".		0	2015-05-25 01:31:27	0	P713	000000jt	0
708	2015-05-25 13:31:15.664498	2015-05-25 13:31:15.664498	7	207	456	12	151	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:31:15	0	P708	000000jo	0
705	2015-05-25 13:31:10.329437	2015-05-25 13:31:10.329437	7	207	456	12	150	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:31:10	0	P705	000000jl	0
703	2015-05-25 13:31:06.323251	2015-05-25 13:31:06.323251	7	207	456	12	149	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:31:06	0	P703	000000jj	0
701	2015-05-25 13:31:01.615691	2015-05-25 13:31:01.615691	7	207	456	12	148	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:31:01	0	P701	000000jh	0
698	2015-05-25 13:30:54.935124	2015-05-25 13:30:54.935124	7	207	456	12	147	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:30:54	0	P698	000000je	0
694	2015-05-25 13:30:46.823823	2015-05-25 13:30:46.823823	7	207	456	12	146	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:30:46	0	P694	000000ja	0
691	2015-05-25 13:30:40.298915	2015-05-25 13:30:40.298915	7	207	456	12	145	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:30:40	0	P691	000000j7	0
687	2015-05-25 13:30:31.740989	2015-05-25 13:30:31.740989	7	207	456	12	144	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:30:31	0	P687	000000j3	0
684	2015-05-25 13:30:26.091135	2015-05-25 13:30:26.091135	7	207	456	12	143	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:30:26	0	P684	000000j0	0
682	2015-05-25 13:30:19.670867	2015-05-25 13:30:19.670867	7	207	456	12	142	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:30:19	0	P682	000000iy	0
681	2015-05-25 13:29:58.123634	2015-05-25 13:29:58.123634	7	207	456	12	141	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:29:58	0	P681	000000ix	0
680	2015-05-25 13:29:51.984029	2015-05-25 13:29:51.984029	7	207	456	12	140	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:29:52	0	P680	000000iw	0
675	2015-05-25 13:29:23.71133	2015-05-25 13:29:23.71133	7	207	456	12	138	update_card_checklist_item	BlakeRoss updated checklist item to incomplete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:4:"name";s:80:"Security fixes for issues disclosed at HP Zero Day Initiative''s Pwn2Own contest";}s:9:"new_value";a:1:{s:4:"name";s:87:"36.0.4: Security fixes for issues disclosed at HP Zero Day Initiative's Pwn2Own contest";}}	0	2015-05-25 01:29:23	0	P675	000000ir	0
673	2015-05-25 13:29:13.375321	2015-05-25 13:29:13.375321	7	207	456	12	139	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:29:13	0	P673	000000ip	0
667	2015-05-25 13:28:21.65565	2015-05-25 13:28:21.65565	7	207	456	12	138	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:28:21	0	P667	000000ij	0
662	2015-05-25 13:28:07.455572	2015-05-25 13:28:07.455572	7	207	456	12	24	add_card_checklist	BlakeRoss added checklist to this card ##CARD_LINK##		0	2015-05-25 01:28:07	0	P662	000000ie	0
661	2015-05-25 13:28:02.623808	2015-05-25 13:28:02.623808	7	207	456	12	\N	add_card	BlakeRoss added card ##CARD_LINK## to list "36.0.4".		0	2015-05-25 01:28:02	0	P661	000000id	0
658	2015-05-25 13:27:48.996555	2015-05-25 13:27:48.996555	7	207	447	12	137	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:27:49	0	P658	000000ia	0
655	2015-05-25 13:27:43.630044	2015-05-25 13:27:43.630044	7	207	447	12	136	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:27:43	0	P655	000000i7	0
651	2015-05-25 13:27:28.552329	2015-05-25 13:27:28.552329	7	207	447	12	135	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:27:28	0	P651	000000i3	0
650	2015-05-25 13:27:28.47919	2015-05-25 13:27:28.47919	7	207	447	12	134	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:27:28	0	P650	000000i2	0
648	2015-05-25 13:27:19.465719	2015-05-25 13:27:19.465719	7	207	447	12	23	add_card_checklist	BlakeRoss added checklist to this card ##CARD_LINK##		0	2015-05-25 01:27:19	0	P648	000000i0	0
647	2015-05-25 13:27:12.747788	2015-05-25 13:27:12.747788	7	207	447	12	\N	add_card	BlakeRoss added card ##CARD_LINK## to list "36.0.4".		0	2015-05-25 01:27:12	0	P647	000000hz	0
644	2015-05-25 13:26:57.233541	2015-05-25 13:26:57.233541	7	207	435	12	133	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:26:57	0	P644	000000hw	0
643	2015-05-25 13:26:57.18169	2015-05-25 13:26:57.18169	7	207	435	12	132	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:26:57	0	P643	000000hv	0
640	2015-05-25 13:26:49.040479	2015-05-25 13:26:49.040479	7	207	435	12	131	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:26:49	0	P640	000000hs	0
638	2015-05-25 13:26:43.101169	2015-05-25 13:26:43.101169	7	207	435	12	130	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:26:43	0	P638	000000hq	0
637	2015-05-25 13:26:43.055798	2015-05-25 13:26:43.055798	7	207	435	12	129	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:26:43	0	P637	000000hp	0
635	2015-05-25 13:26:35.431096	2015-05-25 13:26:35.431096	7	207	435	12	128	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:26:35	0	P635	000000hn	0
634	2015-05-25 13:26:35.382615	2015-05-25 13:26:35.382615	7	207	435	12	127	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:26:35	0	P634	000000hm	0
633	2015-05-25 13:26:29.630043	2015-05-25 13:26:29.630043	7	207	435	12	126	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:26:29	0	P633	000000hl	0
632	2015-05-25 13:26:29.557797	2015-05-25 13:26:29.557797	7	207	435	12	125	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:26:29	0	P632	000000hk	0
630	2015-05-25 13:25:46.984405	2015-05-25 13:25:46.984405	7	207	435	12	124	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:25:47	0	P630	000000hi	0
629	2015-05-25 13:25:42.317819	2015-05-25 13:25:42.317819	7	207	435	12	123	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:25:42	0	P629	000000hh	0
627	2015-05-25 13:25:37.641658	2015-05-25 13:25:37.641658	7	207	435	12	122	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:25:37	0	P627	000000hf	0
624	2015-05-25 13:25:28.752678	2015-05-25 13:25:28.752678	7	207	435	12	22	add_card_checklist	BlakeRoss added checklist to this card ##CARD_LINK##		0	2015-05-25 01:25:28	0	P624	000000hc	0
622	2015-05-25 13:25:23.451942	2015-05-25 13:25:23.451942	7	207	435	12	\N	add_card	BlakeRoss added card ##CARD_LINK## to list "36.0.4".		0	2015-05-25 01:25:23	0	P622	000000ha	0
619	2015-05-25 13:25:11.258712	2015-05-25 13:25:11.258712	7	207	426	12	121	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:25:11	0	P619	000000h7	0
618	2015-05-25 13:21:05.744117	2015-05-25 13:21:05.744117	7	207	426	12	120	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:21:05	0	P618	000000h6	0
617	2015-05-25 13:20:59.002736	2015-05-25 13:20:59.002736	7	207	426	12	119	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:20:59	0	P617	000000h5	0
615	2015-05-25 13:20:53.861243	2015-05-25 13:20:53.861243	7	207	426	12	118	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:20:53	0	P615	000000h3	0
611	2015-05-25 13:20:40.403209	2015-05-25 13:20:40.403209	7	207	426	12	21	add_card_checklist	BlakeRoss added checklist to this card ##CARD_LINK##		0	2015-05-25 01:20:40	0	P611	000000gz	0
608	2015-05-25 13:20:35.403335	2015-05-25 13:20:35.403335	7	207	426	12	\N	add_card	BlakeRoss added card ##CARD_LINK## to list "36.0.4".		0	2015-05-25 01:20:35	0	P608	000000gw	0
602	2015-05-25 13:20:15.0543	2015-05-25 13:20:15.0543	7	207	415	12	117	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:20:15	0	P602	000000gq	0
600	2015-05-25 13:20:09.862108	2015-05-25 13:20:09.862108	7	207	415	12	116	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:20:09	0	P600	000000go	0
597	2015-05-25 13:20:04.663011	2015-05-25 13:20:04.663011	7	207	415	12	115	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:20:04	0	P597	000000gl	0
594	2015-05-25 13:19:57.329086	2015-05-25 13:19:57.329086	7	207	415	12	20	add_card_checklist	BlakeRoss added checklist to this card ##CARD_LINK##		0	2015-05-25 01:19:57	0	P594	000000gi	0
593	2015-05-25 13:19:51.338141	2015-05-25 13:19:51.338141	7	207	415	12	\N	add_card	BlakeRoss added card ##CARD_LINK## to list "36.0.4".		0	2015-05-25 01:19:51	0	P593	000000gh	0
590	2015-05-25 13:19:41.573565	2015-05-25 13:19:41.573565	7	207	0	12	\N	add_list	BlakeRoss added list "36.0.4".		0	2015-05-25 01:19:41	0	P590	000000ge	0
580	2015-05-25 13:18:16.96658	2015-05-25 13:18:16.96658	7	206	397	12	114	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:18:16	0	P580	000000g4	0
579	2015-05-25 13:18:08.525277	2015-05-25 13:18:08.525277	7	206	397	12	113	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:18:08	0	P579	000000g3	0
576	2015-05-25 13:17:59.491831	2015-05-25 13:17:59.491831	7	206	397	12	112	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:17:59	0	P576	000000g0	0
572	2015-05-25 13:17:48.659666	2015-05-25 13:17:48.659666	7	206	397	12	19	add_card_checklist	BlakeRoss added checklist to this card ##CARD_LINK##		0	2015-05-25 01:17:48	0	P572	000000fw	0
570	2015-05-25 13:17:44.267775	2015-05-25 13:17:44.267775	7	206	397	12	\N	add_card	BlakeRoss added card ##CARD_LINK## to list "36.0.3".		0	2015-05-25 01:17:44	0	P570	000000fu	0
553	2015-05-25 13:15:58.163255	2015-05-25 13:15:58.163255	7	206	357	12	111	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:15:58	0	P553	000000fd	0
550	2015-05-25 13:15:50.846795	2015-05-25 13:15:50.846795	7	206	357	12	110	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:15:50	0	P550	000000fa	0
548	2015-05-25 13:15:45.101669	2015-05-25 13:15:45.101669	7	206	357	12	109	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:15:45	0	P548	000000f8	0
545	2015-05-25 13:15:39.98044	2015-05-25 13:15:39.98044	7	206	357	12	108	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:15:40	0	P545	000000f5	0
542	2015-05-25 13:15:32.260864	2015-05-25 13:15:32.260864	7	206	357	12	107	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:15:32	0	P542	000000f2	0
541	2015-05-25 13:15:26.730954	2015-05-25 13:15:26.730954	7	206	357	12	106	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:15:26	0	P541	000000f1	0
538	2015-05-25 13:15:20.239497	2015-05-25 13:15:20.239497	7	206	357	12	105	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:15:20	0	P538	000000ey	0
535	2015-05-25 13:15:12.498048	2015-05-25 13:15:12.498048	7	206	357	12	104	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:15:12	0	P535	000000ev	0
532	2015-05-25 13:15:06.564911	2015-05-25 13:15:06.564911	7	206	357	12	103	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:15:06	0	P532	000000es	0
530	2015-05-25 13:14:59.976941	2015-05-25 13:14:59.976941	7	206	357	12	102	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:14:59	0	P530	000000eq	0
528	2015-05-25 13:14:54.390694	2015-05-25 13:14:54.390694	7	206	357	12	101	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:14:54	0	P528	000000eo	0
525	2015-05-25 13:14:48.815617	2015-05-25 13:14:48.815617	7	206	357	12	100	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:14:48	0	P525	000000el	0
522	2015-05-25 13:14:37.865784	2015-05-25 13:14:37.865784	7	206	357	12	99	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:14:37	0	P522	000000ei	0
518	2015-05-25 13:14:24.633611	2015-05-25 13:14:24.633611	7	206	357	12	18	add_card_checklist	BlakeRoss added checklist to this card ##CARD_LINK##		0	2015-05-25 01:14:24	0	P518	000000ee	0
516	2015-05-25 13:14:18.624724	2015-05-25 13:14:18.624724	7	206	357	12	\N	add_card	BlakeRoss added card ##CARD_LINK## to list "36.0.3".		0	2015-05-25 01:14:18	0	P516	000000ec	0
513	2015-05-25 13:14:06.508817	2015-05-25 13:14:06.508817	7	206	354	12	98	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:14:06	0	P513	000000e9	0
512	2015-05-25 13:14:00.358941	2015-05-25 13:14:00.358941	7	206	354	12	97	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:14:00	0	P512	000000e8	0
511	2015-05-25 13:13:52.333645	2015-05-25 13:13:52.333645	7	206	354	12	96	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:13:52	0	P511	000000e7	0
510	2015-05-25 13:13:52.26773	2015-05-25 13:13:52.26773	7	206	354	12	95	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:13:52	0	P510	000000e6	0
509	2015-05-25 13:13:42.710029	2015-05-25 13:13:42.710029	7	206	354	12	17	add_card_checklist	BlakeRoss added checklist to this card ##CARD_LINK##		0	2015-05-25 01:13:42	0	P509	000000e5	0
508	2015-05-25 13:13:36.593242	2015-05-25 13:13:36.593242	7	206	354	12	\N	add_card	BlakeRoss added card ##CARD_LINK## to list "36.0.3".		0	2015-05-25 01:13:36	0	P508	000000e4	0
507	2015-05-25 13:13:20.884	2015-05-25 13:13:20.884	7	206	353	12	94	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:13:20	0	P507	000000e3	0
506	2015-05-25 13:13:20.81042	2015-05-25 13:13:20.81042	7	206	353	12	93	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:13:20	0	P506	000000e2	0
505	2015-05-25 13:13:14.293949	2015-05-25 13:13:14.293949	7	206	353	12	92	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:13:14	0	P505	000000e1	0
504	2015-05-25 13:13:07.696809	2015-05-25 13:13:07.696809	7	206	353	12	91	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:13:07	0	P504	000000e0	0
503	2015-05-25 13:13:07.665159	2015-05-25 13:13:07.665159	7	206	353	12	90	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:13:07	0	P503	000000dz	0
502	2015-05-25 13:13:01.525274	2015-05-25 13:13:01.525274	7	206	353	12	89	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:13:01	0	P502	000000dy	0
501	2015-05-25 13:13:01.461096	2015-05-25 13:13:01.461096	7	206	353	12	88	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:13:01	0	P501	000000dx	0
500	2015-05-25 13:12:55.079915	2015-05-25 13:12:55.079915	7	206	353	12	87	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:12:55	0	P500	000000dw	0
499	2015-05-25 13:12:55.027925	2015-05-25 13:12:55.027925	7	206	353	12	86	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:12:55	0	P499	000000dv	0
498	2015-05-25 13:12:50.249799	2015-05-25 13:12:50.249799	7	0	0	1	7	add_background	admin added background photo to board (Firefox)	a:2:{s:9:"old_value";a:3:{s:16:"background_color";N;s:22:"background_picture_url";N;s:22:"background_pattern_url";N;}s:9:"new_value";a:4:{s:15:"background_name";s:12:"Firefox logo";s:16:"background_color";s:4:"NULL";s:22:"background_picture_url";s:66:"http://farm3.static.flickr.com/2586/4064851076_394f588099_XXXX.jpg";s:22:"background_pattern_url";s:4:"NULL";}}	0	2015-05-25 01:12:50	0	P498	000000du	0
497	2015-05-25 13:12:49.519723	2015-05-25 13:12:49.519723	7	206	353	12	85	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:12:49	0	P497	000000dt	0
496	2015-05-25 13:12:44.436521	2015-05-25 13:12:44.436521	7	206	353	12	84	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:12:44	0	P496	000000ds	0
495	2015-05-25 13:12:39.795195	2015-05-25 13:12:39.795195	7	206	353	12	83	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:12:39	0	P495	000000dr	0
494	2015-05-25 13:12:14.113767	2015-05-25 13:12:14.113767	7	206	353	12	16	add_card_checklist	BlakeRoss added checklist to this card ##CARD_LINK##		0	2015-05-25 01:12:14	0	P494	000000dq	0
493	2015-05-25 13:12:08.318551	2015-05-25 13:12:08.318551	7	206	353	12	\N	add_card	BlakeRoss added card ##CARD_LINK## to list "36.0.3".		0	2015-05-25 01:12:08	0	P493	000000dp	0
492	2015-05-25 13:11:39.630714	2015-05-25 13:11:39.630714	7	206	352	12	82	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:11:39	0	P492	000000do	0
491	2015-05-25 13:11:33.564251	2015-05-25 13:11:33.564251	7	206	352	12	81	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:11:33	0	P491	000000dn	0
490	2015-05-25 13:11:28.35614	2015-05-25 13:11:28.35614	7	206	352	12	80	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:11:28	0	P490	000000dm	0
489	2015-05-25 13:11:23.364508	2015-05-25 13:11:23.364508	7	206	352	12	79	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:11:23	0	P489	000000dl	0
488	2015-05-25 13:11:12.357082	2015-05-25 13:11:12.357082	7	206	352	12	15	add_card_checklist	BlakeRoss added checklist to this card ##CARD_LINK##		0	2015-05-25 01:11:12	0	P488	000000dk	0
487	2015-05-25 13:11:07.337538	2015-05-25 13:11:07.337538	7	206	352	12	\N	add_card	BlakeRoss added card ##CARD_LINK## to list "36.0.3".		0	2015-05-25 01:11:07	0	P487	000000dj	0
486	2015-05-25 13:10:52.5491	2015-05-25 13:10:52.5491	7	206	351	12	78	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:10:52	0	P486	000000di	0
485	2015-05-25 13:10:47.374075	2015-05-25 13:10:47.374075	7	206	351	12	77	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:10:47	0	P485	000000dh	0
484	2015-05-25 13:10:42.224237	2015-05-25 13:10:42.224237	7	206	351	12	76	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:10:42	0	P484	000000dg	0
483	2015-05-25 13:10:32.342304	2015-05-25 13:10:32.342304	7	206	351	12	14	add_card_checklist	BlakeRoss added checklist to this card ##CARD_LINK##		0	2015-05-25 01:10:32	0	P483	000000df	0
482	2015-05-25 13:10:25.799702	2015-05-25 13:10:25.799702	7	206	351	12	\N	add_card	BlakeRoss added card ##CARD_LINK## to list "36.0.3".		0	2015-05-25 01:10:25	0	P482	000000de	0
481	2015-05-25 13:10:10.583682	2015-05-25 13:10:10.583682	7	206	0	12	\N	add_list	BlakeRoss added list "36.0.3".		0	2015-05-25 01:10:10	0	P481	000000dd	0
478	2015-05-25 13:09:20.035915	2015-05-25 13:09:20.035915	7	205	342	12	75	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:09:20	0	P478	000000da	0
476	2015-05-25 13:09:14.394501	2015-05-25 13:09:14.394501	7	205	342	12	74	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:09:14	0	P476	000000d8	0
474	2015-05-25 13:09:08.059203	2015-05-25 13:09:08.059203	7	205	342	12	73	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:09:08	0	P474	000000d6	0
470	2015-05-25 13:08:57.295811	2015-05-25 13:08:57.295811	7	205	342	12	13	add_card_checklist	BlakeRoss added checklist to this card ##CARD_LINK##		0	2015-05-25 01:08:57	0	P470	000000d2	0
468	2015-05-25 13:08:51.721087	2015-05-25 13:08:51.721087	7	205	342	12	\N	add_card	BlakeRoss added card ##CARD_LINK## to list "36.0.1".		0	2015-05-25 01:08:51	0	P468	000000d0	0
465	2015-05-25 13:08:04.870692	2015-05-25 13:08:04.870692	7	205	279	12	66	delete_checklist_item	BlakeRoss deleted checklist item from card ##CARD_LINK##		0	2015-05-25 01:08:04	0	P465	000000cx	0
464	2015-05-25 13:07:55.092032	2015-05-25 13:07:55.092032	7	205	279	12	65	delete_checklist_item	BlakeRoss deleted checklist item from card ##CARD_LINK##		0	2015-05-25 01:07:55	0	P464	000000cw	0
463	2015-05-25 13:07:49.394575	2015-05-25 13:07:49.394575	7	205	279	12	64	delete_checklist_item	BlakeRoss deleted checklist item from card ##CARD_LINK##		0	2015-05-25 01:07:49	0	P463	000000cv	0
459	2015-05-25 13:07:33.439891	2015-05-25 13:07:33.439891	7	205	279	12	72	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:07:33	0	P459	000000cr	0
457	2015-05-25 13:07:28.423318	2015-05-25 13:07:28.423318	7	205	279	12	71	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:07:28	0	P457	000000cp	0
454	2015-05-25 13:07:19.206925	2015-05-25 13:07:19.206925	7	205	279	12	70	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:07:19	0	P454	000000cm	0
440	2015-05-25 13:06:15.158309	2015-05-25 13:06:15.158309	7	205	279	12	68	delete_checklist_item	BlakeRoss deleted checklist item from card ##CARD_LINK##		0	2015-05-25 01:06:15	0	P440	000000c8	0
438	2015-05-25 13:06:07.386144	2015-05-25 13:06:07.386144	7	205	279	12	69	delete_checklist_item	BlakeRoss deleted checklist item from card ##CARD_LINK##		0	2015-05-25 01:06:07	0	P438	000000c6	0
437	2015-05-25 13:06:00.276593	2015-05-25 13:06:00.276593	7	205	279	12	68	update_card_checklist_item	BlakeRoss updated checklist item to incomplete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:5:"false";}}	0	2015-05-25 01:06:00	0	P437	000000c5	0
436	2015-05-25 13:05:56.663939	2015-05-25 13:05:56.663939	7	205	279	12	69	update_card_checklist_item	BlakeRoss updated checklist item to incomplete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:5:"false";}}	0	2015-05-25 01:05:56	0	P436	000000c4	0
434	2015-05-25 13:05:53.364844	2015-05-25 13:05:53.364844	7	205	279	12	68	update_card_checklist_item	BlakeRoss updated checklist item to incomplete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:5:"false";}}	0	2015-05-25 01:05:53	0	P434	000000c2	0
429	2015-05-25 13:05:02.58473	2015-05-25 13:05:02.58473	7	205	279	12	67	delete_checklist_item	BlakeRoss deleted checklist item from card ##CARD_LINK##		0	2015-05-25 01:05:02	0	P429	000000bx	0
422	2015-05-25 13:03:58.791682	2015-05-25 13:03:58.791682	7	205	279	12	69	update_card_checklist_item	BlakeRoss updated checklist item to incomplete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"t";}s:9:"new_value";a:1:{s:12:"is_completed";s:5:"false";}}	0	2015-05-25 01:03:58	0	P422	000000bq	0
420	2015-05-25 13:03:54.762502	2015-05-25 13:03:54.762502	7	205	279	12	69	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 01:03:54	0	P420	000000bo	0
415	2015-05-25 13:03:37.036465	2015-05-25 13:03:37.036465	7	205	279	12	69	update_card_checklist_item	BlakeRoss updated checklist item to incomplete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"t";}s:9:"new_value";a:1:{s:12:"is_completed";s:5:"false";}}	0	2015-05-25 01:03:37	0	P415	000000bj	0
413	2015-05-25 13:03:35.925049	2015-05-25 13:03:35.925049	7	205	279	12	69	update_card_checklist_item	BlakeRoss updated checklist item to complete on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2015-05-25 01:03:35	0	P413	000000bh	0
412	2015-05-25 13:03:28.81611	2015-05-25 13:03:28.81611	7	205	279	12	69	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:03:28	0	P412	000000bg	0
410	2015-05-25 13:03:22.915509	2015-05-25 13:03:22.915509	7	205	279	12	68	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:03:22	0	P410	000000be	0
409	2015-05-25 13:03:17.403615	2015-05-25 13:03:17.403615	7	205	279	12	67	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:03:17	0	P409	000000bd	0
406	2015-05-25 13:03:12.074322	2015-05-25 13:03:12.074322	7	205	279	12	66	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:03:12	0	P406	000000ba	0
404	2015-05-25 13:03:07.190552	2015-05-25 13:03:07.190552	7	205	279	12	65	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:03:07	0	P404	000000b8	0
402	2015-05-25 13:03:00.26678	2015-05-25 13:03:00.26678	7	205	279	12	64	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:03:00	0	P402	000000b6	0
399	2015-05-25 13:02:53.825127	2015-05-25 13:02:53.825127	7	205	279	12	63	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:02:53	0	P399	000000b3	0
397	2015-05-25 13:02:48.340756	2015-05-25 13:02:48.340756	7	205	279	12	62	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:02:48	0	P397	000000b1	0
394	2015-05-25 13:02:41.095321	2015-05-25 13:02:41.095321	7	205	279	12	61	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:02:41	0	P394	000000ay	0
392	2015-05-25 13:02:34.482906	2015-05-25 13:02:34.482906	7	205	279	12	60	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:02:34	0	P392	000000aw	0
389	2015-05-25 13:02:27.501063	2015-05-25 13:02:27.501063	7	205	279	12	59	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:02:27	0	P389	000000at	0
387	2015-05-25 13:02:21.476247	2015-05-25 13:02:21.476247	7	205	279	12	58	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:02:21	0	P387	000000ar	0
384	2015-05-25 13:02:14.343228	2015-05-25 13:02:14.343228	7	205	279	12	57	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:02:14	0	P384	000000ao	0
382	2015-05-25 13:02:07.826674	2015-05-25 13:02:07.826674	7	205	279	12	56	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:02:07	0	P382	000000am	0
379	2015-05-25 13:02:02.053111	2015-05-25 13:02:02.053111	7	205	279	12	55	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:02:02	0	P379	000000aj	0
375	2015-05-25 13:01:49.060526	2015-05-25 13:01:49.060526	7	205	279	12	12	add_card_checklist	BlakeRoss added checklist to this card ##CARD_LINK##		0	2015-05-25 01:01:49	0	P375	000000af	0
373	2015-05-25 13:01:42.394579	2015-05-25 13:01:42.394579	7	205	279	12	\N	add_card	BlakeRoss added card ##CARD_LINK## to list "36.0.1".		0	2015-05-25 01:01:42	0	P373	000000ad	0
370	2015-05-25 13:01:25.020083	2015-05-25 13:01:25.020083	7	205	269	12	54	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:01:25	0	P370	000000aa	0
367	2015-05-25 13:01:18.870325	2015-05-25 13:01:18.870325	7	205	269	12	53	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:01:18	0	P367	000000a7	0
365	2015-05-25 13:01:13.115501	2015-05-25 13:01:13.115501	7	205	269	12	52	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:01:13	0	P365	000000a5	0
364	2015-05-25 13:01:13.048091	2015-05-25 13:01:13.048091	7	205	269	12	51	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:01:13	0	P364	000000a4	0
361	2015-05-25 13:01:03.51969	2015-05-25 13:01:03.51969	7	205	269	12	11	add_card_checklist	BlakeRoss added checklist to this card ##CARD_LINK##		0	2015-05-25 01:01:03	0	P361	000000a1	0
358	2015-05-25 13:00:57.619407	2015-05-25 13:00:57.619407	7	205	269	12	\N	add_card	BlakeRoss added card ##CARD_LINK## to list "36.0.1".		0	2015-05-25 01:00:57	0	P358	0000009y	0
353	2015-05-25 13:00:44.129416	2015-05-25 13:00:44.129416	7	205	246	12	50	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:00:44	0	P353	0000009t	0
352	2015-05-25 13:00:44.05345	2015-05-25 13:00:44.05345	7	205	246	12	49	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:00:44	0	P352	0000009s	0
349	2015-05-25 13:00:34.163548	2015-05-25 13:00:34.163548	7	205	246	12	48	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:00:34	0	P349	0000009p	0
346	2015-05-25 13:00:28.025505	2015-05-25 13:00:28.025505	7	205	246	12	47	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:00:28	0	P346	0000009m	0
345	2015-05-25 13:00:27.962264	2015-05-25 13:00:27.962264	7	205	246	12	46	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:00:27	0	P345	0000009l	0
343	2015-05-25 13:00:22.993451	2015-05-25 13:00:22.993451	7	205	246	12	45	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:00:23	0	P343	0000009j	0
342	2015-05-25 13:00:22.925476	2015-05-25 13:00:22.925476	7	205	246	12	44	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:00:22	0	P342	0000009i	0
339	2015-05-25 13:00:12.971308	2015-05-25 13:00:12.971308	7	205	246	12	43	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:00:12	0	P339	0000009f	0
338	2015-05-25 13:00:12.930948	2015-05-25 13:00:12.930948	7	205	246	12	42	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:00:12	0	P338	0000009e	0
335	2015-05-25 13:00:06.164597	2015-05-25 13:00:06.164597	7	205	246	12	41	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:00:06	0	P335	0000009b	0
333	2015-05-25 13:00:01.252794	2015-05-25 13:00:01.252794	7	205	246	12	40	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 01:00:01	0	P333	00000099	0
330	2015-05-25 12:59:57.473017	2015-05-25 12:59:57.473017	7	205	246	12	39	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 12:59:57	0	P330	00000096	0
325	2015-05-25 12:59:44.925484	2015-05-25 12:59:44.925484	7	205	246	12	10	add_card_checklist	BlakeRoss added checklist to this card ##CARD_LINK##		0	2015-05-25 12:59:44	0	P325	00000091	0
322	2015-05-25 12:59:38.883793	2015-05-25 12:59:38.883793	7	205	246	12	\N	add_card	BlakeRoss added card ##CARD_LINK## to list "36.0.1".		0	2015-05-25 12:59:38	0	P322	0000008y	0
319	2015-05-25 12:59:24.384133	2015-05-25 12:59:24.384133	7	205	235	12	38	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 12:59:24	0	P319	0000008v	0
317	2015-05-25 12:59:18.05107	2015-05-25 12:59:18.05107	7	205	235	12	37	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 12:59:18	0	P317	0000008t	0
314	2015-05-25 12:59:13.184539	2015-05-25 12:59:13.184539	7	205	235	12	36	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 12:59:13	0	P314	0000008q	0
313	2015-05-25 12:59:08.478288	2015-05-25 12:59:08.478288	7	205	235	12	35	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 12:59:08	0	P313	0000008p	0
308	2015-05-25 12:58:57.260444	2015-05-25 12:58:57.260444	7	205	235	12	9	add_card_checklist	BlakeRoss added checklist to this card ##CARD_LINK##		0	2015-05-25 12:58:57	0	P308	0000008k	0
300	2015-05-25 12:58:29.802981	2015-05-25 12:58:29.802981	7	205	223	12	34	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 12:58:29	0	P300	0000008c	0
298	2015-05-25 12:58:24.044834	2015-05-25 12:58:24.044834	7	205	223	12	33	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 12:58:24	0	P298	0000008a	0
297	2015-05-25 12:58:18.118114	2015-05-25 12:58:18.118114	7	205	223	12	32	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 12:58:18	0	P297	00000089	0
295	2015-05-25 12:58:05.704221	2015-05-25 12:58:05.704221	7	205	223	12	8	add_card_checklist	BlakeRoss added checklist to this card ##CARD_LINK##		0	2015-05-25 12:58:05	0	P295	00000087	0
290	2015-05-25 12:57:53.13778	2015-05-25 12:57:53.13778	7	205	223	12	\N	add_card	BlakeRoss added card ##CARD_LINK## to list "36.0.1".		0	2015-05-25 12:57:53	0	P290	00000082	0
286	2015-05-25 12:56:26.04058	2015-05-25 12:56:26.04058	7	205	0	12	\N	add_list	BlakeRoss added list "36.0.1".		0	2015-05-25 12:56:26	0	P286	0000007y	0
282	2015-05-25 12:55:07.720716	2015-05-25 12:55:07.720716	7	204	207	12	31	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 12:55:07	0	P282	0000007u	0
278	2015-05-25 12:55:00.858488	2015-05-25 12:55:00.858488	7	204	207	12	30	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 12:55:00	0	P278	0000007q	0
277	2015-05-25 12:54:55.225339	2015-05-25 12:54:55.225339	7	204	207	12	29	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 12:54:55	0	P277	0000007p	0
272	2015-05-25 12:54:30.985537	2015-05-25 12:54:30.985537	7	204	207	12	7	add_card_checklist	BlakeRoss added checklist to this card ##CARD_LINK##		0	2015-05-25 12:54:31	0	P272	0000007k	0
269	2015-05-25 12:54:24.328809	2015-05-25 12:54:24.328809	7	204	207	12	\N	add_card	BlakeRoss added card ##CARD_LINK## to list "36".		0	2015-05-25 12:54:24	0	P269	0000007h	0
264	2015-05-25 12:54:10.66842	2015-05-25 12:54:10.66842	7	204	180	12	28	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 12:54:10	0	P264	0000007c	0
263	2015-05-25 12:54:05.895077	2015-05-25 12:54:05.895077	7	204	180	12	27	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 12:54:05	0	P263	0000007b	0
261	2015-05-25 12:54:01.09158	2015-05-25 12:54:01.09158	7	204	180	12	26	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 12:54:01	0	P261	00000079	0
241	2015-05-25 12:52:36.675192	2015-05-25 12:52:36.675192	7	204	180	12	6	add_card_checklist	BlakeRoss added checklist to this card ##CARD_LINK##		0	2015-05-25 12:52:36	0	P241	0000006p	0
238	2015-05-25 12:52:30.430493	2015-05-25 12:52:30.430493	7	204	180	12	\N	add_card	BlakeRoss added card ##CARD_LINK## to list "36".		0	2015-05-25 12:52:30	0	P238	0000006m	0
236	2015-05-25 12:52:13.800189	2015-05-25 12:52:13.800189	7	204	174	12	25	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 12:52:13	0	P236	0000006k	0
235	2015-05-25 12:52:07.507162	2015-05-25 12:52:07.507162	7	204	174	12	24	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 12:52:07	0	P235	0000006j	0
230	2015-05-25 12:51:27.9653	2015-05-25 12:51:27.9653	7	204	174	12	23	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 12:51:27	0	P230	0000006e	0
229	2015-05-25 12:51:27.924154	2015-05-25 12:51:27.924154	7	204	174	12	22	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 12:51:27	0	P229	0000006d	0
228	2015-05-25 12:51:19.535728	2015-05-25 12:51:19.535728	7	204	174	12	5	add_card_checklist	BlakeRoss added checklist to this card ##CARD_LINK##		0	2015-05-25 12:51:19	0	P228	0000006c	0
227	2015-05-25 12:51:14.033119	2015-05-25 12:51:14.033119	7	204	174	12	\N	add_card	BlakeRoss added card ##CARD_LINK## to list "36".		0	2015-05-25 12:51:14	0	P227	0000006b	0
226	2015-05-25 12:50:22.742803	2015-05-25 12:50:22.742803	7	204	173	12	21	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 12:50:22	0	P226	0000006a	0
225	2015-05-25 12:50:22.693075	2015-05-25 12:50:22.693075	7	204	173	12	20	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 12:50:22	0	P225	00000069	0
224	2015-05-25 12:50:09.762984	2015-05-25 12:50:09.762984	7	204	173	12	19	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 12:50:09	0	P224	00000068	0
223	2015-05-25 12:50:08.735853	2015-05-25 12:50:08.735853	6	201	74	7	74	change_card_position	TrevorBlackwell moved this card to different position.	a:2:{s:9:"old_value";b:0;s:9:"new_value";a:0:{}}	0	2015-05-25 12:50:08	0	P223	00000067	0
222	2015-05-25 12:49:54.523381	2015-05-25 12:49:54.523381	7	204	173	12	18	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 12:49:54	0	P222	00000066	0
221	2015-05-25 12:49:54.485521	2015-05-25 12:49:54.485521	7	204	173	12	17	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 12:49:54	0	P221	00000065	0
220	2015-05-25 12:49:46.993694	2015-05-25 12:49:46.993694	7	204	173	12	16	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 12:49:47	0	P220	00000064	0
219	2015-05-25 12:49:46.9194	2015-05-25 12:49:46.9194	7	204	173	12	15	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 12:49:46	0	P219	00000063	0
218	2015-05-25 12:49:38.569785	2015-05-25 12:49:38.569785	7	204	173	12	14	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 12:49:38	0	P218	00000062	0
217	2015-05-25 12:49:38.51121	2015-05-25 12:49:38.51121	7	204	173	12	13	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 12:49:38	0	P217	00000061	0
216	2015-05-25 12:49:29.531201	2015-05-25 12:49:29.531201	7	204	173	12	12	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 12:49:29	0	P216	00000060	0
215	2015-05-25 12:49:22.428586	2015-05-25 12:49:22.428586	7	204	173	12	11	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 12:49:22	0	P215	0000005z	0
214	2015-05-25 12:49:15.178817	2015-05-25 12:49:15.178817	7	204	173	12	10	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 12:49:15	0	P214	0000005y	0
213	2015-05-25 12:49:02.394245	2015-05-25 12:49:02.394245	7	204	173	12	4	add_card_checklist	BlakeRoss added checklist to this card ##CARD_LINK##		0	2015-05-25 12:49:02	0	P213	0000005x	0
212	2015-05-25 12:49:00.26784	2015-05-25 12:49:00.26784	6	0	0	7	10	add_board_user	TrevorBlackwell added member to board		0	2015-05-25 12:49:00	0	P212	0000005w	0
211	2015-05-25 12:48:55.090923	2015-05-25 12:48:55.090923	7	204	173	12	\N	add_card	BlakeRoss added card ##CARD_LINK## to list "36".		0	2015-05-25 12:48:55	0	P211	0000005v	0
210	2015-05-25 12:48:50.195264	2015-05-25 12:48:50.195264	6	0	0	7	9	add_board_user	TrevorBlackwell added member to board		0	2015-05-25 12:48:50	0	P210	0000005u	0
209	2015-05-25 12:48:40.841403	2015-05-25 12:48:40.841403	7	204	164	12	9	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 12:48:40	0	P209	0000005t	0
208	2015-05-25 12:48:40.221046	2015-05-25 12:48:40.221046	6	0	0	7	8	add_board_user	TrevorBlackwell added member to board		0	2015-05-25 12:48:40	0	P208	0000005s	0
207	2015-05-25 12:48:32.016524	2015-05-25 12:48:32.016524	7	204	164	12	8	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 12:48:32	0	P207	0000005r	0
206	2015-05-25 12:48:22.247326	2015-05-25 12:48:22.247326	7	204	164	12	7	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 12:48:22	0	P206	0000005q	0
205	2015-05-25 12:48:14.758974	2015-05-25 12:48:14.758974	7	204	164	12	6	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 12:48:14	0	P205	0000005p	0
204	2015-05-25 12:48:06.00852	2015-05-25 12:48:06.00852	7	204	164	12	5	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 12:48:06	0	P204	0000005o	0
200	2015-05-25 12:47:51.914547	2015-05-25 12:47:51.914547	7	204	164	12	3	add_card_checklist	BlakeRoss added checklist to this card ##CARD_LINK##		0	2015-05-25 12:47:52	0	P200	0000005k	0
196	2015-05-25 12:47:40.126716	2015-05-25 12:47:40.126716	7	204	163	12	4	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 12:47:40	0	P196	0000005g	0
193	2015-05-25 12:47:30.860541	2015-05-25 12:47:30.860541	7	204	163	12	3	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 12:47:30	0	P193	0000005d	0
192	2015-05-25 12:47:18.024572	2015-05-25 12:47:18.024572	7	204	163	12	2	add_checklist_item	BlakeRoss added checklist item to this card ##CARD_LINK##		0	2015-05-25 12:47:18	0	P192	0000005c	0
191	2015-05-25 12:47:07.825954	2015-05-25 12:47:07.825954	7	204	163	12	2	add_card_checklist	BlakeRoss added checklist to this card ##CARD_LINK##		0	2015-05-25 12:47:07	0	P191	0000005b	0
190	2015-05-25 12:46:39.876043	2015-05-25 12:46:39.876043	7	204	164	12	\N	add_card	BlakeRoss added card ##CARD_LINK## to list "36".		0	2015-05-25 12:46:39	0	P190	0000005a	0
189	2015-05-25 12:46:28.793115	2015-05-25 12:46:28.793115	7	204	163	12	\N	add_card	BlakeRoss added card ##CARD_LINK## to list "36".		0	2015-05-25 12:46:28	0	P189	00000059	0
170	2015-05-25 12:43:53.264615	2015-05-25 12:43:53.264615	7	204	0	12	\N	add_list	BlakeRoss added list "36".		0	2015-05-25 12:43:53	0	P170	0000004q	0
169	2015-05-25 12:43:40.685441	2015-05-25 12:43:40.685441	7	0	0	12	\N	add_board	BlakeRoss created board		0	2015-05-25 12:43:40	0	P169	0000004p	0
126	2015-05-25 12:37:57.210765	2015-05-25 12:37:57.210765	6	201	102	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Active".		0	2015-05-25 12:37:57	0	P126	0000003i	0
1115	2016-01-12 19:22:13.836	2016-01-12 19:22:13.836	4	0	0	5	18	add_board_user	##USER_NAME## added member to board		0	2016-01-12 02:52:13	0	P1115	000000uz	0
125	2015-05-25 12:37:52.807147	2015-05-25 12:37:52.807147	6	201	101	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Active".		0	2015-05-25 12:37:52	0	P125	0000003h	0
124	2015-05-25 12:37:48.723889	2015-05-25 12:37:48.723889	6	201	100	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Active".		0	2015-05-25 12:37:48	0	P124	0000003g	0
123	2015-05-25 12:37:45.811527	2015-05-25 12:37:45.811527	6	201	99	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Active".		0	2015-05-25 12:37:45	0	P123	0000003f	0
122	2015-05-25 12:37:42.740412	2015-05-25 12:37:42.740412	6	201	98	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Active".		0	2015-05-25 12:37:42	0	P122	0000003e	0
121	2015-05-25 12:37:36.103341	2015-05-25 12:37:36.103341	6	201	97	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Active".		0	2015-05-25 12:37:36	0	P121	0000003d	0
120	2015-05-25 12:37:33.012445	2015-05-25 12:37:33.012445	6	201	96	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Active".		0	2015-05-25 12:37:33	0	P120	0000003c	0
119	2015-05-25 12:37:28.330765	2015-05-25 12:37:28.330765	6	201	95	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Active".		0	2015-05-25 12:37:28	0	P119	0000003b	0
118	2015-05-25 12:37:25.041032	2015-05-25 12:37:25.041032	6	201	94	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Active".		0	2015-05-25 12:37:25	0	P118	0000003a	0
117	2015-05-25 12:37:20.461259	2015-05-25 12:37:20.461259	6	201	93	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Active".		0	2015-05-25 12:37:20	0	P117	00000039	0
116	2015-05-25 12:37:15.874927	2015-05-25 12:37:15.874927	6	201	92	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Active".		0	2015-05-25 12:37:15	0	P116	00000038	0
115	2015-05-25 12:37:09.695672	2015-05-25 12:37:09.695672	6	201	91	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Active".		0	2015-05-25 12:37:09	0	P115	00000037	0
114	2015-05-25 12:37:05.520747	2015-05-25 12:37:05.520747	6	201	90	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Active".		0	2015-05-25 12:37:05	0	P114	00000036	0
113	2015-05-25 12:36:57.11269	2015-05-25 12:36:57.11269	6	201	89	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Active".		0	2015-05-25 12:36:57	0	P113	00000035	0
112	2015-05-25 12:36:52.796284	2015-05-25 12:36:52.796284	6	201	88	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Active".		0	2015-05-25 12:36:52	0	P112	00000034	0
111	2015-05-25 12:36:49.34625	2015-05-25 12:36:49.34625	6	201	87	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Active".		0	2015-05-25 12:36:49	0	P111	00000033	0
110	2015-05-25 12:36:44.721712	2015-05-25 12:36:44.721712	6	201	86	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Active".		0	2015-05-25 12:36:44	0	P110	00000032	0
109	2015-05-25 12:36:41.626087	2015-05-25 12:36:41.626087	6	201	85	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Active".		0	2015-05-25 12:36:41	0	P109	00000031	0
108	2015-05-25 12:36:38.684732	2015-05-25 12:36:38.684732	6	201	84	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Active".		0	2015-05-25 12:36:38	0	P108	00000030	0
107	2015-05-25 12:36:35.334447	2015-05-25 12:36:35.334447	6	201	83	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Active".		0	2015-05-25 12:36:35	0	P107	0000002z	0
106	2015-05-25 12:36:31.821088	2015-05-25 12:36:31.821088	6	201	82	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Active".		0	2015-05-25 12:36:31	0	P106	0000002y	0
105	2015-05-25 12:36:28.634813	2015-05-25 12:36:28.634813	6	201	81	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Active".		0	2015-05-25 12:36:28	0	P105	0000002x	0
104	2015-05-25 12:36:24.293456	2015-05-25 12:36:24.293456	6	201	80	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Active".		0	2015-05-25 12:36:24	0	P104	0000002w	0
103	2015-05-25 12:36:20.185395	2015-05-25 12:36:20.185395	6	201	79	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Active".		0	2015-05-25 12:36:20	0	P103	0000002v	0
102	2015-05-25 12:36:16.593681	2015-05-25 12:36:16.593681	6	201	78	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Active".		0	2015-05-25 12:36:16	0	P102	0000002u	0
101	2015-05-25 12:36:10.894592	2015-05-25 12:36:10.894592	6	201	77	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Active".		0	2015-05-25 12:36:10	0	P101	0000002t	0
100	2015-05-25 12:35:31.478604	2015-05-25 12:35:31.478604	6	201	76	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Active".		0	2015-05-25 12:35:31	0	P100	0000002s	0
99	2015-05-25 12:35:31.215673	2015-05-25 12:35:31.215673	6	201	73	7	5	add_card_attachment	TrevorBlackwell added attachment to this card ##CARD_LINK##		0	2015-05-25 12:35:31	0	P99	0000002r	0
98	2015-05-25 12:35:27.498427	2015-05-25 12:35:27.498427	6	201	75	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Active".		0	2015-05-25 12:35:27	0	P98	0000002q	0
97	2015-05-25 12:35:27.303653	2015-05-25 12:35:27.303653	6	201	73	7	4	add_card_attachment	TrevorBlackwell added attachment to this card ##CARD_LINK##		0	2015-05-25 12:35:27	0	P97	0000002p	0
96	2015-05-25 12:35:24.482744	2015-05-25 12:35:24.482744	6	201	74	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Active".		0	2015-05-25 12:35:24	0	P96	0000002o	0
95	2015-05-25 12:35:23.254278	2015-05-25 12:35:23.254278	6	201	73	7	3	add_card_attachment	TrevorBlackwell added attachment to this card ##CARD_LINK##		0	2015-05-25 12:35:23	0	P95	0000002n	0
94	2015-05-25 12:35:16.545713	2015-05-25 12:35:16.545713	6	201	73	7	2	add_card_attachment	TrevorBlackwell added attachment to this card ##CARD_LINK##		0	2015-05-25 12:35:16	0	P94	0000002m	0
93	2015-05-25 12:34:52.684193	2015-05-25 12:34:52.684193	6	201	73	7	\N	add_card	TrevorBlackwell added card ##CARD_LINK## to list "Active".		0	2015-05-25 12:34:52	0	P93	0000002l	0
92	2015-05-25 12:29:18.361423	2015-05-25 12:29:18.361423	6	0	0	1	6	add_background	admin added background photo to board (Y Combinator)	a:2:{s:9:"old_value";a:3:{s:16:"background_color";N;s:22:"background_picture_url";N;s:22:"background_pattern_url";N;}s:9:"new_value";a:4:{s:15:"background_name";s:12:"Y Combinator";s:16:"background_color";s:4:"NULL";s:22:"background_picture_url";s:66:"http://farm6.static.flickr.com/5217/5475205694_0893571d52_XXXX.jpg";s:22:"background_pattern_url";s:4:"NULL";}}	0	2015-05-25 12:29:18	0	P92	0000002k	0
91	2015-05-25 12:20:30.963696	2015-05-25 12:20:30.963696	6	203	0	7	\N	add_list	TrevorBlackwell added list "Exited".		0	2015-05-25 12:20:30	0	P91	0000002j	0
90	2015-05-25 12:20:26.830549	2015-05-25 12:20:26.830549	6	202	0	7	\N	add_list	TrevorBlackwell added list "Dead".		0	2015-05-25 12:20:26	0	P90	0000002i	0
89	2015-05-25 12:20:22.367844	2015-05-25 12:20:22.367844	6	201	0	7	\N	add_list	TrevorBlackwell added list "Active".		0	2015-05-25 12:20:22	0	P89	0000002h	0
88	2015-05-25 12:20:12.045631	2015-05-25 12:20:12.045631	6	0	0	7	\N	add_board	TrevorBlackwell created board		0	2015-05-25 12:20:12	0	P88	0000002g	0
87	2015-05-25 11:46:26.896697	2015-05-25 11:46:26.896697	5	200	72	6	\N	add_card	MarissaMayer added card ##CARD_LINK## to list "Acquired Cards".		0	2015-05-25 11:46:26	0	P87	0000002f	0
86	2015-05-25 11:46:14.915879	2015-05-25 11:46:14.915879	5	200	71	6	71	edit_card	MarissaMayer renamed ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:4:"name";s:10:"BrightRoll";}s:9:"new_value";a:1:{s:4:"name";s:21:"BrightRoll @ $640000m";}}	0	2015-05-25 11:46:14	0	P86	0000002e	0
85	2015-05-25 11:45:29.536498	2015-05-25 11:45:29.536498	5	200	71	6	\N	add_card	MarissaMayer added card ##CARD_LINK## to list "Acquired Cards".		0	2015-05-25 11:45:29	0	P85	0000002d	0
84	2015-05-25 11:45:25.155202	2015-05-25 11:45:25.155202	5	200	70	6	\N	add_card	MarissaMayer added card ##CARD_LINK## to list "Acquired Cards".		0	2015-05-25 11:45:25	0	P84	0000002c	0
83	2015-05-25 11:45:20.690545	2015-05-25 11:45:20.690545	5	200	69	6	\N	add_card	MarissaMayer added card ##CARD_LINK## to list "Acquired Cards".		0	2015-05-25 11:45:20	0	P83	0000002b	0
82	2015-05-25 11:44:24.95715	2015-05-25 11:44:24.95715	5	200	68	6	\N	add_card	MarissaMayer added card ##CARD_LINK## to list "Acquired Cards".		0	2015-05-25 11:44:24	0	P82	0000002a	0
81	2015-05-25 11:44:21.347507	2015-05-25 11:44:21.347507	5	200	67	6	\N	add_card	MarissaMayer added card ##CARD_LINK## to list "Acquired Cards".		0	2015-05-25 11:44:21	0	P81	00000029	0
80	2015-05-25 11:43:02.462869	2015-05-25 11:43:02.462869	5	200	66	6	\N	add_card	MarissaMayer added card ##CARD_LINK## to list "Acquired Cards".		0	2015-05-25 11:43:02	0	P80	00000028	0
79	2015-05-25 11:41:45.288206	2015-05-25 11:41:45.288206	5	200	65	6	\N	add_card	MarissaMayer added card ##CARD_LINK## to list "Acquired Cards".		0	2015-05-25 11:41:45	0	P79	00000027	0
78	2015-05-25 11:41:23.061725	2015-05-25 11:41:23.061725	5	200	64	6	\N	add_card	MarissaMayer added card ##CARD_LINK## to list "Acquired Cards".		0	2015-05-25 11:41:23	0	P78	00000026	0
77	2015-05-25 11:41:16.261678	2015-05-25 11:41:16.261678	5	200	63	6	\N	add_card	MarissaMayer added card ##CARD_LINK## to list "Acquired Cards".		0	2015-05-25 11:41:16	0	P77	00000025	0
76	2015-05-25 11:41:11.120424	2015-05-25 11:41:11.120424	5	200	62	6	\N	add_card	MarissaMayer added card ##CARD_LINK## to list "Acquired Cards".		0	2015-05-25 11:41:11	0	P76	00000024	0
75	2015-05-25 11:41:06.881273	2015-05-25 11:41:06.881273	5	200	61	6	\N	add_card	MarissaMayer added card ##CARD_LINK## to list "Acquired Cards".		0	2015-05-25 11:41:06	0	P75	00000023	0
74	2015-05-25 11:41:01.545758	2015-05-25 11:41:01.545758	5	200	60	6	\N	add_card	MarissaMayer added card ##CARD_LINK## to list "Acquired Cards".		0	2015-05-25 11:41:01	0	P74	00000022	0
73	2015-05-25 11:40:48.240231	2015-05-25 11:40:48.240231	5	200	59	6	\N	add_card	MarissaMayer added card ##CARD_LINK## to list "Acquired Cards".		0	2015-05-25 11:40:48	0	P73	00000021	0
72	2015-05-25 11:40:44.165258	2015-05-25 11:40:44.165258	5	200	58	6	\N	add_card	MarissaMayer added card ##CARD_LINK## to list "Acquired Cards".		0	2015-05-25 11:40:44	0	P72	00000020	0
71	2015-05-25 11:40:26.822134	2015-05-25 11:40:26.822134	5	200	57	6	\N	add_card	MarissaMayer added card ##CARD_LINK## to list "Acquired Cards".		0	2015-05-25 11:40:26	0	P71	0000001z	0
70	2015-05-25 11:40:21.832725	2015-05-25 11:40:21.832725	5	200	56	6	\N	add_card	MarissaMayer added card ##CARD_LINK## to list "Acquired Cards".		0	2015-05-25 11:40:21	0	P70	0000001y	0
69	2015-05-25 11:40:15.541482	2015-05-25 11:40:15.541482	5	200	55	6	\N	add_card	MarissaMayer added card ##CARD_LINK## to list "Acquired Cards".		0	2015-05-25 11:40:15	0	P69	0000001x	0
68	2015-05-25 11:40:08.644946	2015-05-25 11:40:08.644946	5	200	54	6	\N	add_card	MarissaMayer added card ##CARD_LINK## to list "Acquired Cards".		0	2015-05-25 11:40:08	0	P68	0000001w	0
67	2015-05-25 11:40:04.791804	2015-05-25 11:40:04.791804	5	200	53	6	\N	add_card	MarissaMayer added card ##CARD_LINK## to list "Acquired Cards".		0	2015-05-25 11:40:04	0	P67	0000001v	0
66	2015-05-25 11:40:00.839782	2015-05-25 11:40:00.839782	5	200	52	6	\N	add_card	MarissaMayer added card ##CARD_LINK## to list "Acquired Cards".		0	2015-05-25 11:40:00	0	P66	0000001u	0
65	2015-05-25 11:39:51.350609	2015-05-25 11:39:51.350609	5	200	51	6	\N	add_card	MarissaMayer added card ##CARD_LINK## to list "Acquired Cards".		0	2015-05-25 11:39:51	0	P65	0000001t	0
64	2015-05-25 11:38:59.091916	2015-05-25 11:38:59.091916	5	200	50	6	\N	add_card	MarissaMayer added card ##CARD_LINK## to list "Acquired Cards".		0	2015-05-25 11:38:59	0	P64	0000001s	0
63	2015-05-25 11:38:26.75956	2015-05-25 11:38:26.75956	5	200	49	6	\N	add_card	MarissaMayer added card ##CARD_LINK## to list "Acquired Cards".		0	2015-05-25 11:38:26	0	P63	0000001r	0
62	2015-05-25 11:38:23.23452	2015-05-25 11:38:23.23452	5	200	48	6	\N	add_card	MarissaMayer added card ##CARD_LINK## to list "Acquired Cards".		0	2015-05-25 11:38:23	0	P62	0000001q	0
61	2015-05-25 11:38:18.809689	2015-05-25 11:38:18.809689	5	200	47	6	\N	add_card	MarissaMayer added card ##CARD_LINK## to list "Acquired Cards".		0	2015-05-25 11:38:18	0	P61	0000001p	0
60	2015-05-25 11:38:14.346024	2015-05-25 11:38:14.346024	5	200	46	6	\N	add_card	MarissaMayer added card ##CARD_LINK## to list "Acquired Cards".		0	2015-05-25 11:38:14	0	P60	0000001o	0
59	2015-05-25 11:38:10.021053	2015-05-25 11:38:10.021053	5	200	45	6	\N	add_card	MarissaMayer added card ##CARD_LINK## to list "Acquired Cards".		0	2015-05-25 11:38:10	0	P59	0000001n	0
58	2015-05-25 11:38:00.921198	2015-05-25 11:38:00.921198	5	200	44	6	\N	add_card	MarissaMayer added card ##CARD_LINK## to list "Acquired Cards".		0	2015-05-25 11:38:00	0	P58	0000001m	0
57	2015-05-25 11:37:45.34518	2015-05-25 11:37:45.34518	5	0	0	1	5	change_background	admin changed board (Yahoo! Acquisitions) backgound	a:2:{s:9:"old_value";a:3:{s:16:"background_color";s:4:"NULL";s:22:"background_picture_url";s:66:"http://farm8.static.flickr.com/7139/7592795682_a0d230bbf3_XXXX.jpg";s:22:"background_pattern_url";s:4:"NULL";}s:9:"new_value";a:4:{s:15:"background_name";s:23:"Marissa Mayer of Google";s:16:"background_color";s:4:"NULL";s:22:"background_picture_url";s:64:"http://farm1.static.flickr.com/101/295989204_3d3f895ecd_XXXX.jpg";s:22:"background_pattern_url";s:4:"NULL";}}	0	2015-05-25 11:37:45	0	P57	0000001l	0
56	2015-05-25 11:36:54.91566	2015-05-25 11:36:54.91566	5	200	43	6	\N	add_card	MarissaMayer added card ##CARD_LINK## to list "Acquired Cards".		0	2015-05-25 11:36:54	0	P56	0000001k	0
55	2015-05-25 11:36:51.62641	2015-05-25 11:36:51.62641	5	0	0	1	5	change_background	admin changed board (Yahoo! Acquisitions) backgound	a:2:{s:9:"old_value";a:3:{s:16:"background_color";s:4:"NULL";s:22:"background_picture_url";s:66:"http://farm3.static.flickr.com/2597/3998285658_fc58d7f27c_XXXX.jpg";s:22:"background_pattern_url";s:4:"NULL";}s:9:"new_value";a:4:{s:15:"background_name";s:13:"Marissa Mayer";s:16:"background_color";s:4:"NULL";s:22:"background_picture_url";s:66:"http://farm8.static.flickr.com/7139/7592795682_a0d230bbf3_XXXX.jpg";s:22:"background_pattern_url";s:4:"NULL";}}	0	2015-05-25 11:36:51	0	P55	0000001j	0
54	2015-05-25 11:36:36.63292	2015-05-25 11:36:36.63292	5	200	42	6	\N	add_card	MarissaMayer added card ##CARD_LINK## to list "Acquired Cards".		0	2015-05-25 11:36:36	0	P54	0000001i	0
53	2015-05-25 11:36:02.006169	2015-05-25 11:36:02.006169	5	200	41	6	\N	add_card	MarissaMayer added card ##CARD_LINK## to list "Acquired Cards".		0	2015-05-25 11:36:02	0	P53	0000001h	0
17	2015-05-25 11:05:06.570921	2015-05-25 11:05:06.570921	4	197	12	5	\N	add_card	SteveJobs added card ##CARD_LINK## to list "Wishlist".		0	2015-05-25 11:05:06	0	P17	0000000h	0
16	2015-05-25 11:05:03.371	2015-05-25 11:05:03.371	4	197	11	5	\N	add_card	SteveJobs added card ##CARD_LINK## to list "Wishlist".		0	2015-05-25 11:05:03	0	P16	0000000g	0
52	2015-05-25 11:35:50.698615	2015-05-25 11:35:50.698615	5	0	0	1	5	add_background	admin added background photo to board (Yahoo! Acquisitions)	a:2:{s:9:"old_value";a:3:{s:16:"background_color";N;s:22:"background_picture_url";N;s:22:"background_pattern_url";N;}s:9:"new_value";a:4:{s:15:"background_name";s:13:"Marissa Mayer";s:16:"background_color";s:4:"NULL";s:22:"background_picture_url";s:66:"http://farm3.static.flickr.com/2597/3998285658_fc58d7f27c_XXXX.jpg";s:22:"background_pattern_url";s:4:"NULL";}}	0	2015-05-25 11:35:50	0	P52	0000001g	0
51	2015-05-25 11:35:10.219165	2015-05-25 11:35:10.219165	5	200	40	6	\N	add_card	MarissaMayer added card ##CARD_LINK## to list "Acquired Cards".		0	2015-05-25 11:35:10	0	P51	0000001f	0
50	2015-05-25 11:35:02.551227	2015-05-25 11:35:02.551227	5	200	39	6	\N	add_card	MarissaMayer added card ##CARD_LINK## to list "Acquired Cards".		0	2015-05-25 11:35:02	0	P50	0000001e	0
49	2015-05-25 11:34:55.842151	2015-05-25 11:34:55.842151	5	200	38	6	\N	add_card	MarissaMayer added card ##CARD_LINK## to list "Acquired Cards".		0	2015-05-25 11:34:55	0	P49	0000001d	0
48	2015-05-25 11:34:49.733657	2015-05-25 11:34:49.733657	5	200	37	6	\N	add_card	MarissaMayer added card ##CARD_LINK## to list "Acquired Cards".		0	2015-05-25 11:34:49	0	P48	0000001c	0
47	2015-05-25 11:34:13.43	2015-05-25 11:34:13.43	4	0	0	1	4	add_background	admin added background photo to board (iOS 9)	a:2:{s:9:"old_value";a:3:{s:16:"background_color";N;s:22:"background_picture_url";N;s:22:"background_pattern_url";N;}s:9:"new_value";a:4:{s:15:"background_name";s:26:"Steve Jobs 1955 - 2011 RIP";s:16:"background_color";s:4:"NULL";s:22:"background_picture_url";s:66:"http://farm7.static.flickr.com/6099/6218459362_29eafafe97_XXXX.jpg";s:22:"background_pattern_url";s:4:"NULL";}}	0	2015-05-25 11:34:13	0	P47	0000001b	0
46	2015-05-25 11:33:37.716115	2015-05-25 11:33:37.716115	5	200	36	6	\N	add_card	MarissaMayer added card ##CARD_LINK## to list "Acquired Cards".		0	2015-05-25 11:33:37	0	P46	0000001a	0
45	2015-05-25 11:30:34.625816	2015-05-25 11:30:34.625816	5	200	35	6	\N	add_card	MarissaMayer added card ##CARD_LINK## to list "Acquired Cards".		0	2015-05-25 11:30:34	0	P45	00000019	0
44	2015-05-25 11:30:29.917641	2015-05-25 11:30:29.917641	5	200	34	6	\N	add_card	MarissaMayer added card ##CARD_LINK## to list "Acquired Cards".		0	2015-05-25 11:30:29	0	P44	00000018	0
43	2015-05-25 11:30:25.568105	2015-05-25 11:30:25.568105	5	200	33	6	\N	add_card	MarissaMayer added card ##CARD_LINK## to list "Acquired Cards".		0	2015-05-25 11:30:25	0	P43	00000017	0
42	2015-05-25 11:30:21.205504	2015-05-25 11:30:21.205504	5	200	32	6	\N	add_card	MarissaMayer added card ##CARD_LINK## to list "Acquired Cards".		0	2015-05-25 11:30:21	0	P42	00000016	0
41	2015-05-25 11:29:50.107448	2015-05-25 11:29:50.107448	5	200	31	6	31	edit_card	MarissaMayer renamed ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:4:"name";s:6:"Summly";}s:9:"new_value";a:1:{s:4:"name";s:16:"Summly @ $30000m";}}	0	2015-05-25 11:29:50	0	P41	00000015	0
40	2015-05-25 11:29:18.119535	2015-05-25 11:29:18.119535	5	200	31	6	\N	add_card	MarissaMayer added card ##CARD_LINK## to list "Acquired Cards".		0	2015-05-25 11:29:18	0	P40	00000014	0
39	2015-05-25 11:28:46.655567	2015-05-25 11:28:46.655567	5	200	30	6	\N	add_card	MarissaMayer added card ##CARD_LINK## to list "Acquired Cards".		0	2015-05-25 11:28:46	0	P39	00000013	0
38	2015-05-25 11:28:26.281033	2015-05-25 11:28:26.281033	5	200	29	6	\N	add_card	MarissaMayer added card ##CARD_LINK## to list "Acquired Cards".		0	2015-05-25 11:28:26	0	P38	00000012	0
37	2015-05-25 11:27:37.760399	2015-05-25 11:27:37.760399	5	200	28	6	\N	add_card	MarissaMayer added card ##CARD_LINK## to list "Acquired Cards".		0	2015-05-25 11:27:37	0	P37	00000011	0
36	2015-05-25 11:23:16.566311	2015-05-25 11:23:16.566311	5	200	27	6	\N	add_card	MarissaMayer added card ##CARD_LINK## to list "Acquired Cards".		0	2015-05-25 11:23:16	0	P36	00000010	0
35	2015-05-25 11:20:33.33888	2015-05-25 11:20:33.33888	5	200	26	6	\N	add_card	MarissaMayer added card ##CARD_LINK## to list "Acquired Cards".		0	2015-05-25 11:20:33	0	P35	0000000z	0
34	2015-05-25 11:15:12.14651	2015-05-25 11:15:12.14651	5	200	0	6	\N	add_list	MarissaMayer added list "Acquired Cards".		0	2015-05-25 11:15:12	0	P34	0000000y	0
33	2015-05-25 11:15:03.783161	2015-05-25 11:15:03.783161	5	199	0	6	\N	add_list	MarissaMayer added list "Deal".		0	2015-05-25 11:15:03	0	P33	0000000x	0
32	2015-05-25 11:14:59.90845	2015-05-25 11:14:59.90845	5	198	0	6	\N	add_list	MarissaMayer added list "Watch List".		0	2015-05-25 11:14:59	0	P32	0000000w	0
31	2015-05-25 11:13:14.770335	2015-05-25 11:13:14.770335	5	0	0	6	\N	add_board	MarissaMayer created board		0	2015-05-25 11:13:14	0	P31	0000000v	0
30	2015-05-25 11:06:05.019056	2015-05-25 11:06:05.019056	4	197	25	5	\N	add_card	SteveJobs added card ##CARD_LINK## to list "Wishlist".		0	2015-05-25 11:06:05	0	P30	0000000u	0
29	2015-05-25 11:06:02.442093	2015-05-25 11:06:02.442093	4	197	24	5	\N	add_card	SteveJobs added card ##CARD_LINK## to list "Wishlist".		0	2015-05-25 11:06:02	0	P29	0000000t	0
28	2015-05-25 11:05:58.544044	2015-05-25 11:05:58.544044	4	197	23	5	\N	add_card	SteveJobs added card ##CARD_LINK## to list "Wishlist".		0	2015-05-25 11:05:58	0	P28	0000000s	0
27	2015-05-25 11:05:54.817328	2015-05-25 11:05:54.817328	4	197	22	5	\N	add_card	SteveJobs added card ##CARD_LINK## to list "Wishlist".		0	2015-05-25 11:05:54	0	P27	0000000r	0
26	2015-05-25 11:05:40.736276	2015-05-25 11:05:40.736276	4	197	21	5	\N	add_card	SteveJobs added card ##CARD_LINK## to list "Wishlist".		0	2015-05-25 11:05:40	0	P26	0000000q	0
25	2015-05-25 11:05:36.861373	2015-05-25 11:05:36.861373	4	197	20	5	\N	add_card	SteveJobs added card ##CARD_LINK## to list "Wishlist".		0	2015-05-25 11:05:36	0	P25	0000000p	0
24	2015-05-25 11:05:32.26987	2015-05-25 11:05:32.26987	4	197	19	5	\N	add_card	SteveJobs added card ##CARD_LINK## to list "Wishlist".		0	2015-05-25 11:05:32	0	P24	0000000o	0
23	2015-05-25 11:05:26.360746	2015-05-25 11:05:26.360746	4	197	18	5	\N	add_card	SteveJobs added card ##CARD_LINK## to list "Wishlist".		0	2015-05-25 11:05:26	0	P23	0000000n	0
22	2015-05-25 11:05:22.59524	2015-05-25 11:05:22.59524	4	197	17	5	\N	add_card	SteveJobs added card ##CARD_LINK## to list "Wishlist".		0	2015-05-25 11:05:22	0	P22	0000000m	0
21	2015-05-25 11:05:19.052142	2015-05-25 11:05:19.052142	4	197	16	5	\N	add_card	SteveJobs added card ##CARD_LINK## to list "Wishlist".		0	2015-05-25 11:05:19	0	P21	0000000l	0
20	2015-05-25 11:05:15.628833	2015-05-25 11:05:15.628833	4	197	15	5	\N	add_card	SteveJobs added card ##CARD_LINK## to list "Wishlist".		0	2015-05-25 11:05:15	0	P20	0000000k	0
19	2015-05-25 11:05:12.470893	2015-05-25 11:05:12.470893	4	197	14	5	\N	add_card	SteveJobs added card ##CARD_LINK## to list "Wishlist".		0	2015-05-25 11:05:12	0	P19	0000000j	0
18	2015-05-25 11:05:09.637334	2015-05-25 11:05:09.637334	4	197	13	5	\N	add_card	SteveJobs added card ##CARD_LINK## to list "Wishlist".		0	2015-05-25 11:05:09	0	P18	0000000i	0
15	2015-05-25 11:05:00.112718	2015-05-25 11:05:00.112718	4	197	10	5	\N	add_card	SteveJobs added card ##CARD_LINK## to list "Wishlist".		0	2015-05-25 11:05:00	0	P15	0000000f	0
14	2015-05-25 11:04:53.354163	2015-05-25 11:04:53.354163	4	197	9	5	\N	add_card	SteveJobs added card ##CARD_LINK## to list "Wishlist".		0	2015-05-25 11:04:53	0	P14	0000000e	0
13	2015-05-25 11:04:50.805085	2015-05-25 11:04:50.805085	4	197	8	5	\N	add_card	SteveJobs added card ##CARD_LINK## to list "Wishlist".		0	2015-05-25 11:04:50	0	P13	0000000d	0
12	2015-05-25 11:04:46.710832	2015-05-25 11:04:46.710832	4	197	7	5	\N	add_card	SteveJobs added card ##CARD_LINK## to list "Wishlist".		0	2015-05-25 11:04:46	0	P12	0000000c	0
11	2015-05-25 11:04:43.895338	2015-05-25 11:04:43.895338	4	197	6	5	\N	add_card	SteveJobs added card ##CARD_LINK## to list "Wishlist".		0	2015-05-25 11:04:43	0	P11	0000000b	0
10	2015-05-25 11:04:39.836757	2015-05-25 11:04:39.836757	4	197	5	5	\N	add_card	SteveJobs added card ##CARD_LINK## to list "Wishlist".		0	2015-05-25 11:04:39	0	P10	0000000a	0
9	2015-05-25 11:04:36.682455	2015-05-25 11:04:36.682455	4	197	4	5	\N	add_card	SteveJobs added card ##CARD_LINK## to list "Wishlist".		0	2015-05-25 11:04:36	0	P9	00000009	0
8	2015-05-25 11:04:31.928633	2015-05-25 11:04:31.928633	4	197	3	5	\N	add_card	SteveJobs added card ##CARD_LINK## to list "Wishlist".		0	2015-05-25 11:04:31	0	P8	00000008	0
7	2015-05-25 11:04:23.789285	2015-05-25 11:04:23.789285	4	197	2	5	\N	add_card	SteveJobs added card ##CARD_LINK## to list "Wishlist".		0	2015-05-25 11:04:23	0	P7	00000007	0
6	2015-05-25 11:04:17.970638	2015-05-25 11:04:17.970638	4	197	0	5	\N	add_list	SteveJobs added list "Wishlist".		0	2015-05-25 11:04:17	0	P6	00000006	0
5	2015-05-25 11:04:09.83921	2015-05-25 11:04:09.83921	4	0	0	5	\N	add_board	SteveJobs created board		0	2015-05-25 11:04:09	0	P5	00000005	0
4	2015-05-25 10:55:41.839178	2015-05-25 10:55:41.839178	3	0	0	1	3	reopen_board	admin reopened ##BOARD_NAME## board.		0	2015-05-25 10:55:41	0	P4	00000004	0
3	2015-05-25 10:54:58.929847	2015-05-25 10:54:58.929847	3	0	0	1	\N	add_board	admin created board		0	2015-05-25 10:54:58	0	P3	00000003	0
1037	2015-06-08 07:53:00.060859	2015-06-08 07:53:00.060859	7	0	0	1	7	change_visibility	admin changed visibility to Organization	a:2:{s:9:"old_value";a:2:{s:15:"organization_id";s:1:"0";s:16:"board_visibility";s:1:"2";}s:9:"new_value";a:2:{s:15:"organization_id";s:1:"2";s:16:"board_visibility";i:1;}}	0	2015-06-08 07:53:00	0	P1037	000000st	0
1038	2015-06-08 07:58:51.172317	2015-06-08 07:58:51.172317	5	0	0	1	5	change_visibility	admin changed visibility to Organization	a:2:{s:9:"old_value";a:2:{s:15:"organization_id";s:1:"0";s:16:"board_visibility";s:1:"2";}s:9:"new_value";a:2:{s:15:"organization_id";s:1:"3";s:16:"board_visibility";i:1;}}	0	2015-06-08 07:58:51	0	P1038	000000su	0
1070	2016-01-12 18:56:12.85	2016-01-12 18:56:12.85	7	206	353	12	3	add_card_voter	##USER_NAME## voted on ##CARD_LINK##		0	2016-01-12 02:26:12	0	P1070	000000tq	0
1039	2015-06-08 07:58:55.951744	2015-06-08 07:58:55.951744	4	0	0	1	4	change_visibility	admin changed visibility to Organization	a:2:{s:9:"old_value";a:2:{s:15:"organization_id";s:1:"0";s:16:"board_visibility";s:1:"2";}s:9:"new_value";a:2:{s:15:"organization_id";s:1:"4";s:16:"board_visibility";i:1;}}	0	2015-06-08 07:58:55	0	P1039	000000sv	0
1040	2015-06-10 17:26:05.709	2015-06-10 17:26:05.709	5	200	28	6	6	add_card_attachment	MarissaMayer added attachment to this card ##CARD_LINK##	\N	0	2015-06-10 01:56:05	0	P1040	000000sw	0
1041	2015-06-24 11:41:01.88	2015-06-24 11:41:01.88	6	203	608	1	7	add_card_attachment	admin added attachment to this card ##CARD_LINK##	\N	0	2015-06-24 08:11:01	0	P1041	000000sx	0
1042	2015-06-24 11:41:11.891	2015-06-24 11:41:11.891	6	201	98	1	8	add_card_attachment	admin added attachment to this card ##CARD_LINK##	\N	0	2015-06-24 08:11:11	0	P1042	000000sy	0
1043	2015-06-24 11:41:35.454	2015-06-24 11:41:35.454	4	197	8	1	9	add_card_attachment	admin added attachment to this card ##CARD_LINK##	\N	0	2015-06-24 08:11:35	0	P1043	000000sz	0
1044	2015-06-24 11:41:48.145	2015-06-24 11:41:48.145	4	197	13	1	10	add_card_attachment	admin added attachment to this card ##CARD_LINK##	\N	0	2015-06-24 08:11:48	0	P1044	000000t0	0
1045	2015-06-24 11:42:01.888	2015-06-24 11:42:01.888	4	197	23	1	11	add_card_attachment	admin added attachment to this card ##CARD_LINK##	\N	0	2015-06-24 08:12:01	0	P1045	000000t1	0
1046	2015-06-24 11:42:26.867	2015-06-24 11:42:26.867	4	197	23	1	23	change_card_position	##USER_NAME## moved this card to different position.	a:2:{s:9:"old_value";a:0:{}s:9:"new_value";a:0:{}}	0	2015-06-24 08:12:26	0	P1046	000000t2	0
1047	2016-01-12 18:34:05.372	2016-01-12 18:34:05.372	7	0	0	12	16	add_board_user	##USER_NAME## added member to board		0	2016-01-12 02:04:05	0	P1047	000000t3	0
1048	2016-01-12 18:35:48.116	2016-01-12 18:35:48.116	7	204	163	12	12	add_card_attachment	##USER_NAME## added attachment to this card ##CARD_LINK##	\N	0	2016-01-12 02:05:48	0	P1048	000000t4	0
1049	2016-01-12 18:37:43.106	2016-01-12 18:37:43.106	7	204	173	12	13	add_card_attachment	##USER_NAME## added attachment to this card ##CARD_LINK##	\N	0	2016-01-12 02:07:43	0	P1049	000000t5	0
1050	2016-01-12 18:38:02.696	2016-01-12 18:38:02.696	7	204	173	12	13	delete_card_attachment	##USER_NAME## deleted attachment from card ##CARD_LINK##	\N	0	2016-01-12 02:08:02	0	P1050	000000t6	0
1051	2016-01-12 18:38:49.61	2016-01-12 18:38:49.61	7	204	173	12	14	add_card_attachment	##USER_NAME## added attachment to this card ##CARD_LINK##	\N	0	2016-01-12 02:08:49	0	P1051	000000t7	0
1052	2016-01-12 18:44:35.374	2016-01-12 18:44:35.374	7	204	164	12	8	add_card_user	##USER_NAME## added "BrianGrinstead" as member to this card ##CARD_LINK##		0	2016-01-12 02:14:35	0	P1052	000000t8	0
1053	2016-01-12 18:44:38.171	2016-01-12 18:44:38.171	7	204	164	12	9	add_card_user	##USER_NAME## added "DaveHyatt " as member to this card ##CARD_LINK##		0	2016-01-12 02:14:38	0	P1053	000000t9	0
1054	2016-01-12 18:44:44.121	2016-01-12 18:44:44.121	7	205	223	12	10	add_card_user	##USER_NAME## added "DaveHyatt " as member to this card ##CARD_LINK##		0	2016-01-12 02:14:44	0	P1054	000000ta	0
1055	2016-01-12 18:44:48.362	2016-01-12 18:44:48.362	7	205	223	12	11	add_card_user	##USER_NAME## added "user" as member to this card ##CARD_LINK##		0	2016-01-12 02:14:48	0	P1055	000000tb	0
1056	2016-01-12 18:44:55.454	2016-01-12 18:44:55.454	7	205	269	12	12	add_card_user	##USER_NAME## added "BrianGrinstead" as member to this card ##CARD_LINK##		0	2016-01-12 02:14:55	0	P1056	000000tc	0
1057	2016-01-12 18:44:58.131	2016-01-12 18:44:58.131	7	205	269	12	12	delete_card_users	##USER_NAME## deleted member from card ##CARD_LINK##	\N	0	2016-01-12 02:14:58	0	P1057	000000td	0
1058	2016-01-12 18:44:59.943	2016-01-12 18:44:59.943	7	205	269	12	13	add_card_user	##USER_NAME## added "BlakeRoss" as member to this card ##CARD_LINK##		0	2016-01-12 02:14:59	0	P1058	000000te	0
1059	2016-01-12 18:45:02.4	2016-01-12 18:45:02.4	7	205	269	12	14	add_card_user	##USER_NAME## added "MikedeBoer" as member to this card ##CARD_LINK##		0	2016-01-12 02:15:02	0	P1059	000000tf	0
1060	2016-01-12 18:45:46.825	2016-01-12 18:45:46.825	7	206	351	12	5	add_card_label	##USER_NAME## added label(s) to this card ##CARD_LINK## - ##LABEL_NAME##	\N	0	2016-01-12 02:15:46	0	P1060	000000tg	0
1061	2016-01-12 18:46:39.76	2016-01-12 18:46:39.76	7	206	352	12	352	add_card_desc	##USER_NAME## added card description in ##CARD_LINK## - ##DESCRIPTION##	a:2:{s:9:"old_value";a:1:{s:11:"description";N;}s:9:"new_value";a:1:{s:11:"description";s:55:"No longer accept insecure RC4 ciphers whenever possible";}}	0	2016-01-12 02:16:39	0	P1061	000000th	0
1062	2016-01-12 18:46:56.184	2016-01-12 18:46:56.184	7	206	352	12	352	add_card_duedate	##USER_NAME## set due date to this card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:8:"due_date";N;}s:9:"new_value";a:2:{s:7:"to_date";s:10:"2016-01-12";s:8:"due_date";s:16:"2016-01-12 18:45";}}	0	2016-01-12 02:16:56	0	P1062	000000ti	0
1063	2016-01-12 18:47:13.286	2016-01-12 18:47:13.286	7	205	246	12	246	add_card_duedate	##USER_NAME## set due date to this card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:8:"due_date";N;}s:9:"new_value";a:2:{s:7:"to_date";s:10:"2016-01-22";s:8:"due_date";s:16:"2016-01-22 18:55";}}	0	2016-01-12 02:17:13	0	P1063	000000tj	0
1064	2016-01-12 18:47:51.805	2016-01-12 18:47:51.805	7	206	354	12	354	add_card_duedate	##USER_NAME## set due date to this card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:8:"due_date";N;}s:9:"new_value";a:2:{s:7:"to_date";s:10:"2016-01-29";s:8:"due_date";s:16:"2016-01-29 04:50";}}	0	2016-01-12 02:17:51	0	P1064	000000tk	0
1065	2016-01-12 18:48:10.153	2016-01-12 18:48:10.153	7	207	415	12	415	add_card_duedate	##USER_NAME## set due date to this card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:8:"due_date";N;}s:9:"new_value";a:2:{s:7:"to_date";s:10:"2016-02-14";s:8:"due_date";s:16:"2016-02-14 01:45";}}	0	2016-01-12 02:18:10	0	P1065	000000tl	0
1066	2016-01-12 18:48:29.311	2016-01-12 18:48:29.311	7	204	164	12	164	add_card_duedate	##USER_NAME## set due date to this card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:8:"due_date";N;}s:9:"new_value";a:2:{s:7:"to_date";s:10:"2016-03-18";s:8:"due_date";s:16:"2016-03-18 00:05";}}	0	2016-01-12 02:18:29	0	P1066	000000tm	0
1067	2016-01-12 18:49:57.562	2016-01-12 18:49:57.562	7	204	164	12	8	add_card_label	##USER_NAME## added label(s) to this card ##CARD_LINK## - ##LABEL_NAME##	\N	0	2016-01-12 02:19:57	0	P1067	000000tn	0
1068	2016-01-12 18:55:34.204	2016-01-12 18:55:34.204	7	207	435	12	15	add_card_attachment	##USER_NAME## added attachment to this card ##CARD_LINK##	\N	0	2016-01-12 02:25:34	0	P1068	000000to	0
1071	2016-01-12 18:58:02.594	2016-01-12 18:58:02.594	7	206	352	12	15	add_card_user	##USER_NAME## added "BrianGrinstead" as member to this card ##CARD_LINK##		0	2016-01-12 02:28:02	0	P1071	000000tr	0
1072	2016-01-12 18:58:05.541	2016-01-12 18:58:05.541	7	206	352	12	16	add_card_user	##USER_NAME## added "DaveHyatt " as member to this card ##CARD_LINK##		0	2016-01-12 02:28:05	0	P1072	000000ts	0
1073	2016-01-12 18:58:26.556	2016-01-12 18:58:26.556	7	205	269	12	17	add_card_user	##USER_NAME## added "BrianGrinstead" as member to this card ##CARD_LINK##		0	2016-01-12 02:28:26	0	P1073	000000tt	0
1074	2016-01-12 18:58:32.193	2016-01-12 18:58:32.193	7	205	269	12	18	add_card_user	##USER_NAME## added "DaveHyatt " as member to this card ##CARD_LINK##		0	2016-01-12 02:28:32	0	P1074	000000tu	0
1075	2016-01-12 18:58:39.674	2016-01-12 18:58:39.674	7	205	246	12	246	change_card_position	##USER_NAME## moved the card ##CARD_LINK## to 36.0.1	a:2:{s:9:"old_value";a:0:{}s:9:"new_value";a:0:{}}	0	2016-01-12 02:28:39	0	P1075	000000tv	0
1076	2016-01-12 18:59:00.198	2016-01-12 18:59:00.198	7	205	235	12	235	add_card_desc	##USER_NAME## added card description in ##CARD_LINK## - ##DESCRIPTION##	a:2:{s:9:"old_value";a:1:{s:11:"description";N;}s:9:"new_value";a:1:{s:11:"description";s:55:"No longer accept insecure RC4 ciphers whenever possible";}}	0	2016-01-12 02:29:00	0	P1076	000000tw	0
1077	2016-01-12 18:59:07.406	2016-01-12 18:59:07.406	7	208	538	12	538	add_card_desc	##USER_NAME## added card description in ##CARD_LINK## - ##DESCRIPTION##	a:2:{s:9:"old_value";a:1:{s:11:"description";N;}s:9:"new_value";a:1:{s:11:"description";s:55:"No longer accept insecure RC4 ciphers whenever possible";}}	0	2016-01-12 02:29:07	0	P1077	000000tx	0
1078	2016-01-12 18:59:17.377	2016-01-12 18:59:17.377	7	207	426	12	426	add_card_desc	##USER_NAME## added card description in ##CARD_LINK## - ##DESCRIPTION##	a:2:{s:9:"old_value";a:1:{s:11:"description";N;}s:9:"new_value";a:1:{s:11:"description";s:55:"No longer accept insecure RC4 ciphers whenever possible";}}	0	2016-01-12 02:29:17	0	P1078	000000ty	0
1079	2016-01-12 18:59:40.719	2016-01-12 18:59:40.719	7	207	415	12	19	add_card_user	##USER_NAME## added "BrianGrinstead" as member to this card ##CARD_LINK##		0	2016-01-12 02:29:40	0	P1079	000000tz	0
1080	2016-01-12 18:59:43.176	2016-01-12 18:59:43.176	7	207	415	12	20	add_card_user	##USER_NAME## added "DaveHyatt " as member to this card ##CARD_LINK##		0	2016-01-12 02:29:43	0	P1080	000000u0	0
1081	2016-01-12 19:00:08.173	2016-01-12 19:00:08.173	7	207	426	12	426	add_card_duedate	##USER_NAME## set due date to this card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:8:"due_date";N;}s:9:"new_value";a:2:{s:7:"to_date";s:10:"2016-03-23";s:8:"due_date";s:16:"2016-03-23 18:55";}}	0	2016-01-12 02:30:08	0	P1081	000000u1	0
1082	2016-01-12 19:00:16.53	2016-01-12 19:00:16.53	7	207	426	12	42	add_card_checklist	##USER_NAME## added checklist Checklist to this card ##CARD_LINK##		0	2016-01-12 02:30:16	0	P1082	000000u2	0
1083	2016-01-12 19:00:27.565	2016-01-12 19:00:27.565	7	207	426	12	42	delete_checklist	##USER_NAME## deleted checklist Checklist from card ##CARD_LINK##	\N	0	2016-01-12 02:30:27	0	P1083	000000u3	0
1084	2016-01-12 19:00:40.73	2016-01-12 19:00:40.73	7	207	426	12	426	change_card_position	##USER_NAME## moved the card ##CARD_LINK## to 36.0.4	a:2:{s:9:"old_value";a:0:{}s:9:"new_value";a:0:{}}	0	2016-01-12 02:30:40	0	P1084	000000u4	0
1085	2016-01-12 19:00:46.398	2016-01-12 19:00:46.398	7	205	352	12	352	change_card_position	##USER_NAME## moved this card ##CARD_LINK## from 36.0.3 list to 36.0.1.	a:2:{s:9:"old_value";a:1:{s:7:"list_id";s:3:"206";}s:9:"new_value";a:1:{s:7:"list_id";i:205;}}	0	2016-01-12 02:30:46	0	P1085	000000u5	0
1086	2016-01-12 19:00:58.812	2016-01-12 19:00:58.812	7	205	223	12	223	change_card_position	##USER_NAME## moved the card ##CARD_LINK## to 36.0.1	a:2:{s:9:"old_value";a:0:{}s:9:"new_value";a:0:{}}	0	2016-01-12 02:30:58	0	P1086	000000u6	0
1087	2016-01-12 19:01:02.053	2016-01-12 19:01:02.053	7	206	354	12	21	add_card_user	##USER_NAME## added "MarkBanner" as member to this card ##CARD_LINK##		0	2016-01-12 02:31:02	0	P1087	000000u7	0
1088	2016-01-12 19:01:05.162	2016-01-12 19:01:05.162	7	206	354	12	22	add_card_user	##USER_NAME## added "MikedeBoer" as member to this card ##CARD_LINK##		0	2016-01-12 02:31:05	0	P1088	000000u8	0
1089	2016-01-12 19:01:09.359	2016-01-12 19:01:09.359	7	206	351	12	23	add_card_user	##USER_NAME## added "MikedeBoer" as member to this card ##CARD_LINK##		0	2016-01-12 02:31:09	0	P1089	000000u9	0
1090	2016-01-12 19:01:12.253	2016-01-12 19:01:12.253	7	206	351	12	24	add_card_user	##USER_NAME## added "user" as member to this card ##CARD_LINK##		0	2016-01-12 02:31:12	0	P1090	000000ua	0
1091	2016-01-12 19:01:29.622	2016-01-12 19:01:29.622	7	208	524	12	25	add_card_user	##USER_NAME## added "MarkBanner" as member to this card ##CARD_LINK##		0	2016-01-12 02:31:29	0	P1091	000000ub	0
1092	2016-01-12 19:01:31.387	2016-01-12 19:01:31.387	7	208	524	12	26	add_card_user	##USER_NAME## added "DaveHyatt " as member to this card ##CARD_LINK##		0	2016-01-12 02:31:31	0	P1092	000000uc	0
1093	2016-01-12 19:01:41.571	2016-01-12 19:01:41.571	7	208	524	12	524	add_card_duedate	##USER_NAME## set due date to this card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:8:"due_date";N;}s:9:"new_value";a:2:{s:7:"to_date";s:10:"2016-03-04";s:8:"due_date";s:16:"2016-03-04 02:10";}}	0	2016-01-12 02:31:41	0	P1093	000000ud	0
1094	2016-01-12 19:02:30.811	2016-01-12 19:02:30.811	7	208	510	12	510	add_card_desc	##USER_NAME## added card description in ##CARD_LINK## - ##DESCRIPTION##	a:2:{s:9:"old_value";a:1:{s:11:"description";N;}s:9:"new_value";a:1:{s:11:"description";s:55:"No longer accept insecure RC4 ciphers whenever possible";}}	0	2016-01-12 02:32:30	0	P1094	000000ue	0
1095	2016-01-12 19:02:36.962	2016-01-12 19:02:36.962	7	208	510	12	4	add_card_voter	##USER_NAME## voted on ##CARD_LINK##		0	2016-01-12 02:32:36	0	P1095	000000uf	0
1096	2016-01-12 19:03:03.027	2016-01-12 19:03:03.027	7	209	552	12	27	add_card_user	##USER_NAME## added "BrianGrinstead" as member to this card ##CARD_LINK##		0	2016-01-12 02:33:03	0	P1096	000000ug	0
1097	2016-01-12 19:03:11.645	2016-01-12 19:03:11.645	7	209	552	12	552	add_card_duedate	##USER_NAME## set due date to this card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:8:"due_date";N;}s:9:"new_value";a:2:{s:7:"to_date";s:10:"2016-01-22";s:8:"due_date";s:16:"2016-01-22 10:50";}}	0	2016-01-12 02:33:11	0	P1097	000000uh	0
1124	2016-01-12 19:24:20.035	2016-01-12 19:24:20.035	4	197	23	5	32	add_card_user	##USER_NAME## added "MarissaMayer" as member to this card ##CARD_LINK##		0	2016-01-12 02:54:20	0	P1124	000000v8	0
1125	2016-01-12 19:24:27.082	2016-01-12 19:24:27.082	4	197	23	5	33	add_card_user	##USER_NAME## added "user" as member to this card ##CARD_LINK##		0	2016-01-12 02:54:27	0	P1125	000000v9	0
1098	2016-01-12 19:03:30.998	2016-01-12 19:03:30.998	7	208	538	12	165	update_card_checklist_item	##USER_NAME## updated ##CHECKLIST_ITEM_NAME## as completed on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2016-01-12 02:33:31	0	P1098	000000ui	0
1099	2016-01-12 19:03:33.087	2016-01-12 19:03:33.087	7	208	538	12	167	update_card_checklist_item	##USER_NAME## updated ##CHECKLIST_ITEM_NAME## as completed on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2016-01-12 02:33:33	0	P1099	000000uj	0
1100	2016-01-12 19:03:39.764	2016-01-12 19:03:39.764	7	207	435	12	122	update_card_checklist_item	##USER_NAME## updated ##CHECKLIST_ITEM_NAME## as completed on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2016-01-12 02:33:39	0	P1100	000000uk	0
1101	2016-01-12 19:03:44.77	2016-01-12 19:03:44.77	7	207	435	12	124	update_card_checklist_item	##USER_NAME## updated ##CHECKLIST_ITEM_NAME## as completed on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2016-01-12 02:33:44	0	P1101	000000ul	0
1102	2016-01-12 19:03:48.821	2016-01-12 19:03:48.821	7	207	435	12	128	update_card_checklist_item	##USER_NAME## updated ##CHECKLIST_ITEM_NAME## as completed on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2016-01-12 02:33:48	0	P1102	000000um	0
1103	2016-01-12 19:04:00.527	2016-01-12 19:04:00.527	7	205	223	12	33	update_card_checklist_item	##USER_NAME## updated ##CHECKLIST_ITEM_NAME## as completed on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2016-01-12 02:34:00	0	P1103	000000un	0
1104	2016-01-12 19:04:09.533	2016-01-12 19:04:09.533	7	205	235	12	38	update_card_checklist_item	##USER_NAME## updated ##CHECKLIST_ITEM_NAME## as completed on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2016-01-12 02:34:09	0	P1104	000000uo	0
1105	2016-01-12 19:04:10.808	2016-01-12 19:04:10.808	7	205	235	12	36	update_card_checklist_item	##USER_NAME## updated ##CHECKLIST_ITEM_NAME## as completed on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2016-01-12 02:34:10	0	P1105	000000up	0
1106	2016-01-12 19:05:50.13	2016-01-12 19:05:50.13	7	205	223	12	16	add_card_attachment	##USER_NAME## added attachment to this card ##CARD_LINK##	\N	0	2016-01-12 02:35:50	0	P1106	000000uq	0
1107	2016-01-12 19:06:10.282	2016-01-12 19:06:10.282	7	209	223	12	223	change_card_position	##USER_NAME## moved this card ##CARD_LINK## from 36.0.1 list to 37.0.1.	a:2:{s:9:"old_value";a:1:{s:7:"list_id";s:3:"205";}s:9:"new_value";a:1:{s:7:"list_id";i:209;}}	0	2016-01-12 02:36:10	0	P1107	000000ur	0
1108	2016-01-12 19:06:34.12	2016-01-12 19:06:34.12	7	210	554	12	554	add_card_duedate	##USER_NAME## set due date to this card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:8:"due_date";N;}s:9:"new_value";a:2:{s:7:"to_date";s:10:"2016-02-11";s:8:"due_date";s:16:"2016-02-11 18:05";}}	0	2016-01-12 02:36:34	0	P1108	000000us	0
1109	2016-01-12 19:06:45.113	2016-01-12 19:06:45.113	7	211	577	12	577	add_card_duedate	##USER_NAME## set due date to this card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:8:"due_date";N;}s:9:"new_value";a:2:{s:7:"to_date";s:10:"2016-02-25";s:8:"due_date";s:16:"2016-02-25 19:05";}}	0	2016-01-12 02:36:45	0	P1109	000000ut	0
1110	2016-01-12 19:06:47.602	2016-01-12 19:06:47.602	7	211	577	12	185	update_card_checklist_item	##USER_NAME## updated ##CHECKLIST_ITEM_NAME## as completed on card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:12:"is_completed";s:1:"f";}s:9:"new_value";a:1:{s:12:"is_completed";s:4:"true";}}	0	2016-01-12 02:36:47	0	P1110	000000uu	0
1111	2016-01-12 19:06:58.056	2016-01-12 19:06:58.056	7	210	554	12	28	add_card_user	##USER_NAME## added "BrianGrinstead" as member to this card ##CARD_LINK##		0	2016-01-12 02:36:58	0	P1111	000000uv	0
1112	2016-01-12 19:07:23.989	2016-01-12 19:07:23.989	7	210	554	12	9	add_card_label	##USER_NAME## added label(s) to this card ##CARD_LINK## - ##LABEL_NAME##	\N	0	2016-01-12 02:37:24	0	P1112	000000uw	0
1113	2016-01-12 19:07:44.789	2016-01-12 19:07:44.789	7	210	554	12	10	add_card_label	##USER_NAME## added label(s) to this card ##CARD_LINK## - ##LABEL_NAME##	\N	0	2016-01-12 02:37:44	0	P1113	000000ux	0
1114	2016-01-12 19:22:08.808	2016-01-12 19:22:08.808	4	0	0	5	17	add_board_user	##USER_NAME## added member to board		0	2016-01-12 02:52:08	0	P1114	000000uy	0
1116	2016-01-12 19:22:18.925	2016-01-12 19:22:18.925	4	0	0	5	19	add_board_user	##USER_NAME## added member to board		0	2016-01-12 02:52:18	0	P1116	000000v0	0
1117	2016-01-12 19:22:31.834	2016-01-12 19:22:31.834	4	197	2	5	29	add_card_user	##USER_NAME## added "SteveJobs" as member to this card ##CARD_LINK##		0	2016-01-12 02:52:31	0	P1117	000000v1	0
1118	2016-01-12 19:22:33.77	2016-01-12 19:22:33.77	4	197	2	5	30	add_card_user	##USER_NAME## added "MarissaMayer" as member to this card ##CARD_LINK##		0	2016-01-12 02:52:33	0	P1118	000000v2	0
1119	2016-01-12 19:22:55.45	2016-01-12 19:22:55.45	4	197	3	5	3	add_card_duedate	##USER_NAME## set due date to this card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:8:"due_date";N;}s:9:"new_value";a:2:{s:7:"to_date";s:10:"2016-01-29";s:8:"due_date";s:16:"2016-01-29 23:20";}}	0	2016-01-12 02:52:55	0	P1119	000000v3	0
1120	2016-01-12 19:23:37.272	2016-01-12 19:23:37.272	4	197	2	5	2	add_card_duedate	##USER_NAME## set due date to this card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:8:"due_date";N;}s:9:"new_value";a:2:{s:7:"to_date";s:10:"2016-02-11";s:8:"due_date";s:16:"2016-02-11 06:30";}}	0	2016-01-12 02:53:37	0	P1120	000000v4	0
1121	2016-01-12 19:23:54.732	2016-01-12 19:23:54.732	4	197	2	5	2	add_card_desc	##USER_NAME## added card description in ##CARD_LINK## - ##DESCRIPTION##	a:2:{s:9:"old_value";a:1:{s:11:"description";N;}s:9:"new_value";a:1:{s:11:"description";s:64:"Steve Jobs set due date to this card Contact availability status";}}	0	2016-01-12 02:53:54	0	P1121	000000v5	0
1122	2016-01-12 19:24:00.391	2016-01-12 19:24:00.391	4	197	2	5	5	add_card_voter	##USER_NAME## voted on ##CARD_LINK##		0	2016-01-12 02:54:00	0	P1122	000000v6	0
1123	2016-01-12 19:24:17.475	2016-01-12 19:24:17.475	4	197	23	5	31	add_card_user	##USER_NAME## added "SteveJobs" as member to this card ##CARD_LINK##		0	2016-01-12 02:54:17	0	P1123	000000v7	0
1126	2016-01-12 19:26:02.823	2016-01-12 19:26:02.823	6	201	100	1	34	add_card_user	##USER_NAME## added "TrevorBlackwell" as member to this card ##CARD_LINK##		0	2016-01-12 02:56:02	0	P1126	000000va	0
1127	2016-01-12 19:26:07.061	2016-01-12 19:26:07.061	6	201	100	1	34	delete_card_users	##USER_NAME## deleted member from card ##CARD_LINK##	\N	0	2016-01-12 02:56:07	0	P1127	000000vb	0
1128	2016-01-12 19:27:07.831	2016-01-12 19:27:07.831	6	0	0	7	20	add_board_user	##USER_NAME## added member to board		0	2016-01-12 02:57:07	0	P1128	000000vc	0
1129	2016-01-12 19:27:53.399	2016-01-12 19:27:53.399	6	201	98	7	98	change_card_position	##USER_NAME## moved the card ##CARD_LINK## to Active	a:2:{s:9:"old_value";a:0:{}s:9:"new_value";a:0:{}}	0	2016-01-12 02:57:53	0	P1129	000000vd	0
1130	2016-01-12 19:27:58.346	2016-01-12 19:27:58.346	6	201	98	7	98	change_card_position	##USER_NAME## moved the card ##CARD_LINK## to Active	a:2:{s:9:"old_value";a:0:{}s:9:"new_value";a:0:{}}	0	2016-01-12 02:57:58	0	P1130	000000ve	0
1131	2016-01-12 19:28:03.883	2016-01-12 19:28:03.883	6	201	98	7	98	change_card_position	##USER_NAME## moved the card ##CARD_LINK## to Active	a:2:{s:9:"old_value";a:0:{}s:9:"new_value";a:0:{}}	0	2016-01-12 02:58:03	0	P1131	000000vf	0
1132	2016-01-12 19:28:08.11	2016-01-12 19:28:08.11	6	201	98	7	98	change_card_position	##USER_NAME## moved the card ##CARD_LINK## to Active	a:2:{s:9:"old_value";a:0:{}s:9:"new_value";a:0:{}}	0	2016-01-12 02:58:08	0	P1132	000000vg	0
1133	2016-01-12 19:28:13.176	2016-01-12 19:28:13.176	6	201	98	7	98	change_card_position	##USER_NAME## moved the card ##CARD_LINK## to Active	a:2:{s:9:"old_value";a:0:{}s:9:"new_value";a:0:{}}	0	2016-01-12 02:58:13	0	P1133	000000vh	0
1134	2016-01-12 19:28:19.516	2016-01-12 19:28:19.516	6	201	98	7	98	change_card_position	##USER_NAME## moved the card ##CARD_LINK## to Active	a:2:{s:9:"old_value";a:0:{}s:9:"new_value";a:0:{}}	0	2016-01-12 02:58:19	0	P1134	000000vi	0
1135	2016-01-12 19:28:37.192	2016-01-12 19:28:37.192	6	201	98	7	98	add_card_duedate	##USER_NAME## set due date to this card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:8:"due_date";N;}s:9:"new_value";a:2:{s:7:"to_date";s:10:"2016-01-28";s:8:"due_date";s:16:"2016-01-28 18:25";}}	0	2016-01-12 02:58:37	0	P1135	000000vj	0
1136	2016-01-12 19:29:17.885	2016-01-12 19:29:17.885	6	202	555	7	17	add_card_attachment	##USER_NAME## added attachment to this card ##CARD_LINK##	\N	0	2016-01-12 02:59:17	0	P1136	000000vk	0
1137	2016-01-12 19:29:25.89	2016-01-12 19:29:25.89	6	202	555	7	17	delete_card_attachment	##USER_NAME## deleted attachment from card ##CARD_LINK##	\N	0	2016-01-12 02:59:25	0	P1137	000000vl	0
1138	2016-01-12 19:30:03.639	2016-01-12 19:30:03.639	6	202	555	7	18	add_card_attachment	##USER_NAME## added attachment to this card ##CARD_LINK##	\N	0	2016-01-12 03:00:03	0	P1138	000000vm	0
1139	2016-01-12 19:30:14.231	2016-01-12 19:30:14.231	6	201	98	7	98	change_card_position	##USER_NAME## moved the card ##CARD_LINK## to Active	a:2:{s:9:"old_value";a:0:{}s:9:"new_value";a:0:{}}	0	2016-01-12 03:00:14	0	P1139	000000vn	0
1140	2016-01-12 19:30:38.378	2016-01-12 19:30:38.378	6	201	99	7	12	add_card_label	##USER_NAME## added label(s) to this card ##CARD_LINK## - ##LABEL_NAME##	\N	0	2016-01-12 03:00:38	0	P1140	000000vo	0
1141	2016-01-12 19:30:48.016	2016-01-12 19:30:48.016	6	201	99	7	35	add_card_user	##USER_NAME## added "PaulGraham" as member to this card ##CARD_LINK##		0	2016-01-12 03:00:48	0	P1141	000000vp	0
1142	2016-01-12 19:30:49.755	2016-01-12 19:30:49.755	6	201	99	7	36	add_card_user	##USER_NAME## added "RobertMorris" as member to this card ##CARD_LINK##		0	2016-01-12 03:00:49	0	P1142	000000vq	0
1143	2016-01-12 19:30:57.282	2016-01-12 19:30:57.282	6	201	99	7	99	add_card_duedate	##USER_NAME## set due date to this card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:8:"due_date";N;}s:9:"new_value";a:2:{s:7:"to_date";s:10:"2016-01-13";s:8:"due_date";s:16:"2016-01-13 19:30";}}	0	2016-01-12 03:00:57	0	P1143	000000vr	0
1144	2016-01-12 19:31:05.062	2016-01-12 19:31:05.062	6	201	97	7	37	add_card_user	##USER_NAME## added "TrevorBlackwell" as member to this card ##CARD_LINK##		0	2016-01-12 03:01:05	0	P1144	000000vs	0
1145	2016-01-12 19:31:07.457	2016-01-12 19:31:07.457	6	201	97	7	38	add_card_user	##USER_NAME## added "RobertMorris" as member to this card ##CARD_LINK##		0	2016-01-12 03:01:07	0	P1145	000000vt	0
1146	2016-01-12 19:31:09.827	2016-01-12 19:31:09.827	6	201	97	7	39	add_card_user	##USER_NAME## added "PaulGraham" as member to this card ##CARD_LINK##		0	2016-01-12 03:01:09	0	P1146	000000vu	0
1147	2016-01-12 19:31:13.828	2016-01-12 19:31:13.828	6	201	97	7	40	add_card_user	##USER_NAME## added "user" as member to this card ##CARD_LINK##		0	2016-01-12 03:01:13	0	P1147	000000vv	0
1148	2016-01-12 19:33:08.827	2016-01-12 19:33:08.827	6	201	96	7	19	add_card_attachment	##USER_NAME## added attachment to this card ##CARD_LINK##	\N	0	2016-01-12 03:03:08	0	P1148	000000vw	0
1149	2016-01-12 19:33:21.471	2016-01-12 19:33:21.471	6	201	96	7	96	change_card_position	##USER_NAME## moved the card ##CARD_LINK## to Active	a:2:{s:9:"old_value";a:0:{}s:9:"new_value";a:0:{}}	0	2016-01-12 03:03:21	0	P1149	000000vx	0
1150	2016-01-12 19:33:23.536	2016-01-12 19:33:23.536	6	202	555	7	555	change_card_position	##USER_NAME## moved the card ##CARD_LINK## to Dead	a:2:{s:9:"old_value";a:0:{}s:9:"new_value";a:0:{}}	0	2016-01-12 03:03:23	0	P1150	000000vy	0
1151	2016-01-12 19:33:29.862	2016-01-12 19:33:29.862	6	201	96	7	96	change_card_position	##USER_NAME## moved the card ##CARD_LINK## to Active	a:2:{s:9:"old_value";a:0:{}s:9:"new_value";a:0:{}}	0	2016-01-12 03:03:29	0	P1151	000000vz	0
1152	2016-01-12 19:33:34.209	2016-01-12 19:33:34.209	6	202	555	7	555	change_card_position	##USER_NAME## moved the card ##CARD_LINK## to Dead	a:2:{s:9:"old_value";a:0:{}s:9:"new_value";a:0:{}}	0	2016-01-12 03:03:34	0	P1152	000000w0	0
1153	2016-01-12 19:33:35.277	2016-01-12 19:33:35.277	6	202	555	7	555	change_card_position	##USER_NAME## moved the card ##CARD_LINK## to Dead	a:2:{s:9:"old_value";a:0:{}s:9:"new_value";a:0:{}}	0	2016-01-12 03:03:35	0	P1153	000000w1	0
1154	2016-01-12 19:33:36.885	2016-01-12 19:33:36.885	6	203	608	7	608	change_card_position	##USER_NAME## moved the card ##CARD_LINK## to Exited	a:2:{s:9:"old_value";a:0:{}s:9:"new_value";a:0:{}}	0	2016-01-12 03:03:36	0	P1154	000000w2	0
1155	2016-01-12 19:33:38.984	2016-01-12 19:33:38.984	6	203	608	7	608	change_card_position	##USER_NAME## moved the card ##CARD_LINK## to Exited	a:2:{s:9:"old_value";a:0:{}s:9:"new_value";a:0:{}}	0	2016-01-12 03:03:39	0	P1155	000000w3	0
1156	2016-01-12 19:33:57.614	2016-01-12 19:33:57.614	6	202	553	7	41	add_card_user	##USER_NAME## added "TrevorBlackwell" as member to this card ##CARD_LINK##		0	2016-01-12 03:03:57	0	P1156	000000w4	0
1157	2016-01-12 19:34:00.23	2016-01-12 19:34:00.23	6	202	553	7	42	add_card_user	##USER_NAME## added "user" as member to this card ##CARD_LINK##		0	2016-01-12 03:04:00	0	P1157	000000w5	0
1158	2016-01-12 19:34:04.885	2016-01-12 19:34:04.885	6	201	95	7	43	add_card_user	##USER_NAME## added "TrevorBlackwell" as member to this card ##CARD_LINK##		0	2016-01-12 03:04:04	0	P1158	000000w6	0
1159	2016-01-12 19:34:07.807	2016-01-12 19:34:07.807	6	201	95	7	44	add_card_user	##USER_NAME## added "PaulGraham" as member to this card ##CARD_LINK##		0	2016-01-12 03:04:07	0	P1159	000000w7	0
1160	2016-01-12 19:34:10.39	2016-01-12 19:34:10.39	6	201	95	7	45	add_card_user	##USER_NAME## added "RobertMorris" as member to this card ##CARD_LINK##		0	2016-01-12 03:04:10	0	P1160	000000w8	0
1161	2016-01-12 19:34:14.651	2016-01-12 19:34:14.651	6	202	553	7	46	add_card_user	##USER_NAME## added "JessicaLivings" as member to this card ##CARD_LINK##		0	2016-01-12 03:04:14	0	P1161	000000w9	0
1162	2016-01-12 19:34:59.74	2016-01-12 19:34:59.74	6	203	609	7	47	add_card_user	##USER_NAME## added "TrevorBlackwell" as member to this card ##CARD_LINK##		0	2016-01-12 03:04:59	0	P1162	000000wa	0
1163	2016-01-12 19:35:01.253	2016-01-12 19:35:01.253	6	203	609	7	48	add_card_user	##USER_NAME## added "JessicaLivings" as member to this card ##CARD_LINK##		0	2016-01-12 03:05:01	0	P1163	000000wb	0
1164	2016-01-12 19:35:25.742	2016-01-12 19:35:25.742	6	202	556	7	6	add_card_voter	##USER_NAME## voted on ##CARD_LINK##		0	2016-01-12 03:05:25	0	P1164	000000wc	0
1165	2016-01-12 19:35:33.554	2016-01-12 19:35:33.554	6	202	556	7	556	add_card_duedate	##USER_NAME## set due date to this card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:8:"due_date";N;}s:9:"new_value";a:2:{s:7:"to_date";s:10:"2016-01-13";s:8:"due_date";s:16:"2016-01-13 19:35";}}	0	2016-01-12 03:05:33	0	P1165	000000wd	0
1166	2016-01-12 19:35:39.555	2016-01-12 19:35:39.555	6	202	556	7	49	add_card_user	##USER_NAME## added "TrevorBlackwell" as member to this card ##CARD_LINK##		0	2016-01-12 03:05:39	0	P1166	000000we	0
1167	2016-01-12 19:35:41.385	2016-01-12 19:35:41.385	6	202	556	7	50	add_card_user	##USER_NAME## added "PaulGraham" as member to this card ##CARD_LINK##		0	2016-01-12 03:05:41	0	P1167	000000wf	0
1168	2016-01-12 19:35:44.51	2016-01-12 19:35:44.51	6	202	556	7	51	add_card_user	##USER_NAME## added "RobertMorris" as member to this card ##CARD_LINK##		0	2016-01-12 03:05:44	0	P1168	000000wg	0
1169	2016-01-12 19:36:11.606	2016-01-12 19:36:11.606	6	202	553	7	553	add_card_desc	##USER_NAME## added card description in ##CARD_LINK## - ##DESCRIPTION##	a:2:{s:9:"old_value";a:1:{s:11:"description";N;}s:9:"new_value";a:1:{s:11:"description";s:149:"NUGANIC - CUSTOMIZE PORE CONTROL ESSENCE | 30ML FULL SIZE - WORTH $46.- This is a pore control essence which reduces the appearance of dilated pores.";}}	0	2016-01-12 03:06:11	0	P1169	000000wh	0
1170	2016-01-12 19:36:35.021	2016-01-12 19:36:35.021	6	203	609	7	43	add_card_checklist	##USER_NAME## added checklist Checklist to this card ##CARD_LINK##		0	2016-01-12 03:06:35	0	P1170	000000wi	0
1171	2016-01-12 19:36:46.091	2016-01-12 19:36:46.091	6	203	609	7	205	add_checklist_item	##USER_NAME## added item ##CHECKLIST_ITEM_NAME## in checklist ##CHECKLIST_ITEM_PARENT_NAME## of card ##CARD_LINK##		0	2016-01-12 03:06:46	0	P1171	000000wj	0
1172	2016-01-12 19:36:58.864	2016-01-12 19:36:58.864	6	203	610	7	610	change_card_position	##USER_NAME## moved the card ##CARD_LINK## to Exited	a:2:{s:9:"old_value";a:0:{}s:9:"new_value";a:0:{}}	0	2016-01-12 03:06:58	0	P1172	000000wk	0
1173	2016-01-12 19:38:09.017	2016-01-12 19:38:09.017	5	0	0	6	21	add_board_user	##USER_NAME## added member to board		0	2016-01-12 03:08:09	0	P1173	000000wl	0
1174	2016-01-12 19:38:14.091	2016-01-12 19:38:14.091	5	0	0	6	22	add_board_user	##USER_NAME## added member to board		0	2016-01-12 03:08:14	0	P1174	000000wm	0
1175	2016-01-12 19:38:24.296	2016-01-12 19:38:24.296	5	0	0	6	23	add_board_user	##USER_NAME## added member to board		0	2016-01-12 03:08:24	0	P1175	000000wn	0
1176	2016-01-12 19:38:42.395	2016-01-12 19:38:42.395	5	200	28	6	52	add_card_user	##USER_NAME## added "MikedeBoer" as member to this card ##CARD_LINK##		0	2016-01-12 03:08:42	0	P1176	000000wo	0
1177	2016-01-12 19:38:52.124	2016-01-12 19:38:52.124	5	200	28	6	28	add_card_duedate	##USER_NAME## set due date to this card ##CARD_LINK##	a:2:{s:9:"old_value";a:1:{s:8:"due_date";N;}s:9:"new_value";a:2:{s:7:"to_date";s:10:"2016-02-04";s:8:"due_date";s:16:"2016-02-04 06:35";}}	0	2016-01-12 03:08:52	0	P1177	000000wp	0
1178	2016-01-12 19:38:54.635	2016-01-12 19:38:54.635	5	200	28	6	53	add_card_user	##USER_NAME## added "MarissaMayer" as member to this card ##CARD_LINK##		0	2016-01-12 03:08:54	0	P1178	000000wq	0
1179	2016-01-12 19:39:10.132	2016-01-12 19:39:10.132	5	200	28	6	44	add_card_checklist	##USER_NAME## added checklist Checklist to this card ##CARD_LINK##		0	2016-01-12 03:09:10	0	P1179	000000wr	0
1180	2016-01-12 19:39:33.54	2016-01-12 19:39:33.54	5	200	28	6	7	add_card_voter	##USER_NAME## voted on ##CARD_LINK##		0	2016-01-12 03:09:33	0	P1180	000000ws	0
1181	2016-01-12 19:40:06.819	2016-01-12 19:40:06.819	5	200	29	6	8	add_card_voter	##USER_NAME## voted on ##CARD_LINK##		0	2016-01-12 03:10:06	0	P1181	000000wt	0
1182	2016-01-12 19:40:13.626	2016-01-12 19:40:13.626	5	200	26	6	26	archived_card	##USER_NAME## archived Snip.it @ $10000m	a:2:{s:9:"old_value";a:1:{s:11:"is_archived";s:1:"f";}s:9:"new_value";a:1:{s:11:"is_archived";i:1;}}	0	2016-01-12 03:10:13	0	P1182	000000wu	0
1183	2016-01-12 19:40:23.326	2016-01-12 19:40:23.326	5	200	27	6	54	add_card_user	##USER_NAME## added "MarissaMayer" as member to this card ##CARD_LINK##		0	2016-01-12 03:10:23	0	P1183	000000wv	0
1184	2016-01-12 19:40:25.103	2016-01-12 19:40:25.103	5	200	27	6	55	add_card_user	##USER_NAME## added "user" as member to this card ##CARD_LINK##		0	2016-01-12 03:10:25	0	P1184	000000ww	0
1185	2016-01-12 19:40:27.376	2016-01-12 19:40:27.376	5	200	27	6	56	add_card_user	##USER_NAME## added "MarkBanner" as member to this card ##CARD_LINK##		0	2016-01-12 03:10:27	0	P1185	000000wx	0
1186	2016-01-12 19:42:01.12	2016-01-12 19:42:01.12	0	0	0	6	6	productivity_beat_update	##USER_NAME## updated the profile.	a:2:{s:9:"old_value";a:1:{s:21:"is_productivity_beats";s:1:"t";}s:9:"new_value";a:1:{s:21:"is_productivity_beats";b:0;}}	0	2016-01-12 03:12:01	0	P1186	000000wy	0
1187	2016-01-12 19:42:03.146	2016-01-12 19:42:03.146	0	0	0	1	1	productivity_beat_update	##USER_NAME## updated the profile.	a:2:{s:9:"old_value";a:1:{s:21:"is_productivity_beats";s:1:"t";}s:9:"new_value";a:1:{s:21:"is_productivity_beats";b:0;}}	0	2016-01-12 03:12:03	0	P1187	000000wz	0
1188	2016-01-12 19:42:04.363	2016-01-12 19:42:04.363	0	0	0	1	1	productivity_beat_update	##USER_NAME## updated the profile.	a:2:{s:9:"old_value";a:1:{s:21:"is_productivity_beats";s:1:"f";}s:9:"new_value";a:1:{s:21:"is_productivity_beats";b:1;}}	0	2016-01-12 03:12:04	0	P1188	000000x0	0
1189	2016-01-12 19:42:06.398	2016-01-12 19:42:06.398	0	0	0	6	6	productivity_beat_update	##USER_NAME## updated the profile.	a:2:{s:9:"old_value";a:1:{s:21:"is_productivity_beats";s:1:"f";}s:9:"new_value";a:1:{s:21:"is_productivity_beats";b:1;}}	0	2016-01-12 03:12:06	0	P1189	000000x1	0
1190	2016-01-12 19:42:24.823	2016-01-12 19:42:24.823	0	0	0	1	1	productivity_beat_update	##USER_NAME## updated the profile.	a:2:{s:9:"old_value";a:1:{s:21:"is_productivity_beats";s:1:"t";}s:9:"new_value";a:1:{s:21:"is_productivity_beats";b:0;}}	0	2016-01-12 03:12:24	0	P1190	000000x2	0
1191	2016-01-12 19:42:25.664	2016-01-12 19:42:25.664	0	0	0	1	1	productivity_beat_update	##USER_NAME## updated the profile.	a:2:{s:9:"old_value";a:1:{s:21:"is_productivity_beats";s:1:"f";}s:9:"new_value";a:1:{s:21:"is_productivity_beats";b:1;}}	0	2016-01-12 03:12:25	0	P1191	000000x3	0
1192	2016-01-12 19:56:24.023	2016-01-12 19:56:24.023	4	197	23	1	32	delete_card_users	##USER_NAME## deleted member from card ##CARD_LINK##	\N	0	2016-01-12 03:26:24	0	P1192	000000x4	0
1193	2016-01-12 19:56:34.35	2016-01-12 19:56:34.35	4	0	0	1	18	delete_board_user	##USER_NAME## removed member "MarissaMayer" from board		0	2016-01-12 03:26:34	0	P1193	000000x5	0
1194	2016-01-12 19:56:59.789	2016-01-12 19:56:59.789	5	0	0	6	22	delete_board_user	##USER_NAME## removed member "MarkBanner" from board		0	2016-01-12 03:26:59	0	P1194	000000x6	0
1195	2016-01-12 19:57:15.658	2016-01-12 19:57:15.658	5	0	0	6	23	delete_board_user	##USER_NAME## removed member "MikedeBoer" from board		0	2016-01-12 03:27:15	0	P1195	000000x7	0
1196	2016-01-12 19:57:19.482	2016-01-12 19:57:19.482	5	0	0	6	21	delete_board_user	##USER_NAME## removed member "user" from board		0	2016-01-12 03:27:19	0	P1196	000000x8	0
1197	2016-01-12 19:58:03.087	2016-01-12 19:58:03.087	6	0	0	1	8	delete_board_user	##USER_NAME## removed member "PaulGraham" from board		0	2016-01-12 03:28:03	0	P1197	000000x9	0
1198	2016-01-12 19:58:06.461	2016-01-12 19:58:06.461	6	0	0	1	9	delete_board_user	##USER_NAME## removed member "JessicaLivings" from board		0	2016-01-12 03:28:06	0	P1198	000000xa	0
1199	2016-01-12 19:58:11.28	2016-01-12 19:58:11.28	6	0	0	1	20	delete_board_user	##USER_NAME## removed member "user" from board		0	2016-01-12 03:28:11	0	P1199	000000xb	0
1200	2016-01-12 19:58:31.359	2016-01-12 19:58:31.359	6	0	0	1	10	delete_board_user	##USER_NAME## removed member "RobertMorris" from board		0	2016-01-12 03:28:31	0	P1200	000000xc	0
1201	2016-01-12 19:58:51.981	2016-01-12 19:58:51.981	4	0	0	1	19	delete_board_user	##USER_NAME## removed member "MarkBanner" from board		0	2016-01-12 03:28:51	0	P1201	000000xd	0
1202	2016-01-12 19:58:55.594	2016-01-12 19:58:55.594	4	0	0	1	17	delete_board_user	##USER_NAME## removed member "user" from board		0	2016-01-12 03:28:55	0	P1202	000000xe	0
1203	2016-01-12 20:02:20.95	2016-01-12 20:02:20.95	4	0	0	5	24	add_board_user	##USER_NAME## added member to board		0	2016-01-12 03:32:20	0	P1203	000000xf	0
1204	2016-01-12 20:03:01.343	2016-01-12 20:03:01.343	6	0	0	7	25	add_board_user	##USER_NAME## added member to board		0	2016-01-12 03:33:01	0	P1204	000000xg	0
1205	2016-01-12 20:03:50.035	2016-01-12 20:03:50.035	5	0	0	6	26	add_board_user	##USER_NAME## added member to board		0	2016-01-12 03:33:50	0	P1205	000000xh	0
1206	2016-01-13 12:15:29.207	2016-01-13 12:15:29.207	0	0	0	1	1	productivity_beat_update	##USER_NAME## updated the profile.	a:2:{s:9:"old_value";a:1:{s:21:"is_productivity_beats";s:1:"t";}s:9:"new_value";a:1:{s:21:"is_productivity_beats";b:0;}}	0	2016-01-13 07:45:29	0	P1206	000000xi	0
1207	2016-01-13 13:23:24.887	2016-01-13 13:23:24.887	0	0	0	1	1	productivity_beat_update	##USER_NAME## updated the profile.	a:2:{s:9:"old_value";a:1:{s:21:"is_productivity_beats";s:1:"f";}s:9:"new_value";a:1:{s:21:"is_productivity_beats";b:1;}}	0	2016-01-13 08:53:24	0	P1207	000000xj	0
\.


--
-- Name: activities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('activities_id_seq', 1207, true);


--
-- Name: attachments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('attachments_id_seq', 1, false);


--
-- Data for Name: board_stars; Type: TABLE DATA; Schema: public; Owner: -
--

COPY board_stars (id, created, modified, board_id, user_id, is_starred) FROM stdin;
1	2015-06-11 14:25:23.114	2015-06-11 14:25:23.114	5	1	t
2	2015-06-11 14:25:39.398	2015-06-11 14:25:39.398	5	6	t
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
1	2016-02-22 17:36:33.355	2016-02-22 17:36:33.355	Owner	Can view and edit cards, remove members, and change settings for the board.
2	2016-02-22 17:36:33.355	2016-02-22 17:36:33.355	Editor	Can view and edit cards, remove members, but not change settings.
3	2016-02-22 17:36:33.355	2016-02-22 17:36:33.355	Viewer	Can view only.
\.


--
-- Name: board_user_roles_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('board_user_roles_seq', 1, false);


--
-- Data for Name: boards; Type: TABLE DATA; Schema: public; Owner: -
--

COPY boards (id, created, modified, user_id, organization_id, name, board_visibility, background_color, background_picture_url, commenting_permissions, voting_permissions, inivitation_permissions, is_closed, is_allow_organization_members_to_join, boards_user_count, list_count, card_count, boards_subscriber_count, background_pattern_url, boards_star_count, is_show_image_front_of_card, background_picture_path, music_name, music_content, archived_list_count, archived_card_count, default_email_list_id, is_default_email_position_as_bottom, custom_fields) FROM stdin;
4	2015-05-25 11:04:09.818746	2015-06-08 07:58:56.005723	5	4	iOS 9	1	NULL	http://farm7.static.flickr.com/6099/6218459362_29eafafe97_XXXX.jpg	\N	\N	\N	f	f	2	1	24	0	NULL	0	t	\N	Bee Gees - Stayin Alive	X: 1\nT: Bee Gees - Stayin Alive [Genwen, Meneldor]\nN: Prim Reapers, Meneldor\nL: 1/4\nQ: 104\nK: C\n^D,/4 [F,5/8z/2] ^G,/4 z/2 ^D,/4 z/4 F,/2 C,/4 z/4 ^A,/4 C,/4 ^D,/4\nz/4 [^D,/4^A,/4] [F,/2C,/4] z/4 ^D,/4 z/4  z/4 ^A,/2 C,/2 ^D,/2 F,/2\n^G,/2 ^A,/2 ^A,3/8 z/8 ^A,3/8 z5/8 F,/8 z/8 ^G,/8 z3/8 F,/8 z/8\n[F,/4^G,/4] [^G,/2z/4] F,/8 z/8 F,/4 ^A,/2 ^A,3/8 z/8 ^A,3/8 z3/8\n^G,/8 z3/8 ^G,/8 z/8 ^D,/4 F,/8 z/8 [^G,3/8^D,3/8] z/8 [F,/8^D,/4]\nz3/8 ^D,/4 F,/4 z/4 ^G,/4 z/2 ^D,/4 z/4 F,/2 C,/4 z/4 ^A,/4 C,/4\n^D,/4 z/4 [^A,/4^D,/4] [F,3/8C,/4] z/4 ^D,/4 z/4  z/4 ^A,/2 C,/2\n[^D,/2f/2F/2] [F,/2^g/4^G/4] [^a/2^A/2z/4] [^G,/2z/4] [c'3/4c3/4z/4]\n^D,/4 [F,3/8z/4] [^a/4^A/4] [^g/4^G/4^G,/8] z/8 [^a/4^A/4]\n[f/2F/2z/4] ^D,/4 [^g/2^G/2F,/8] z/8 [F,5/8z/4] [^g3/8^G/2z/4] C,/4\n[^a3/8^A/2z/4] ^A,/4 [f/4F/4C,/4] [f/4F/4^D,/4] [^g/2^G/2z/4]\n[^D,3/4^A,/4] [C,/4^g/4^G/4] [f3/8F3/8z/4] ^D,/4 z/4  z/4\n[^A,/2^d/2^D/2] [C,/2f/2F/2] [^D,/2f/4F/4] [f3/8F3/8z/4] F,/2\n[^G,/2z/4] [^a/4^A/4] [^D,/4c'/4c/4] [F,3/8c'3/8c/2] z/8\n[c'5/8c3/4^G,/8] z5/8 [f/4F/4^D,/4] [F,/8^g/2^G/2] z/8 [F,5/8z/4]\n[^g/2^G/2z/4] C,/8 z/8 [^a3/8^A3/8z/4] ^A,/4 [C,/4f/4F/4]\n[^D,/4f3/8F/2] z/4 [C,/4^A,/4^g3/8^G/2] [C,/4^D,3/8] [^g/4^G/4]\n[^D,/8^g5/8^G3/4] z3/8  z/4 [^A,/2^d3/8^D/4] [f3/8F/2z/4] [C,/2z/4]\n[f/2F/2z/4] [^D,/2z/4] [f3/8F/2z/4] [F,/2z/4] [f/4F/4]\n[^G,/2^g/4^G/4] [^g/4^G/4] [^A,^a3/4^A3/4] [^a5/8^A5/8z/4] ^A,3/8 z/8\n^A,/4 [^G,/8F,/4] z/8 [^g/4^G/4^A,7/8] [^a/2^A/2^G,/8] z3/8\n[^a/2^A/2F,/8] z/8 [^A,3/8^G,/2] z/8 [^A,/2F,/4] [f/4F/4]\n[^g/4^G/4^A,7/8] [^a/2^A/2] [^a3/8^A/2z/4] [^A,5/4z/4] [^g/2^G/2]\n[^G,/8c'3/8c/2] z3/8 [^A,/4^a/2^A/2^G,/8] z/8 F,/4 [^a5/8^A5/8F,/4]\n^G,/2 [=A,/2F,/4] [f/4F/4^G/4] [c/4^g3/8^G/4^A,3/4] [^a/2^A/2=d/2]\n[d/2^a5/8^A5/8z/4] ^A,3/4 [^G/4^G,/8f3/8F/4F,/4] z/8\n[c/4^g3/8^G/4^A,7/4] [^a/2d/2^A/2^G,/8] z3/8 [d5/8F,/8^a5/8^A5/8] z/8\n^G,/2 F,/8 z/8 [^G/4f3/8F/4] [c/4^G/4^g3/8^A,] [d/2^A/2^a/2]\n[d/2^A/2^a/2z/4] [^A,5/4z/4] [c/2^G/2^g3/8] z/8 [c'/2^d/2c/2^G,/8]\nz3/8 [F,/4=d/2^A/2^a/2^G,/8] z/8 [^A,3/8z/4] [^a/2F,/8d5/8^A5/8] z/8\n[^A,/4^G,3/8] C,/4 [F,/8^D,3/8] z3/8 [^D/4^G/4^d/4c'/4F,/2]\n[^D/4^G/4^d/4c'/4] [^D/4^G/4^d/4^G,/2c'/4] [^G/4^D/4^d/4c'/4]\n[^G/4^D/4^d/4c'/4] [=D/4=G/4=d/4^a/4] [D/4G/4d/4F,3/8^a/4]\n[G/2D/2d/2^a3/8z/4] [F,/2z/4] [F/4C/4c/4^g/4] [F/4C/4c/4^D,3/8^g/4]\n[F/4C/4c/4^g/4] [F/4C/4c/4^g/4] [^A,/4^D/4^A/4=g/4]\n[g/4^A,/4^D/4^A/4C,3/8] [^A,/2^D/2^A/2g/2z/4] [C,7/8z/4]\n[C/4F/4c/4^g/4] [C/4F/4c/4^g/4] [C/2F/2c/2^g/2] z/4 F,/2\n[^D/4^A,/4^A/4=g/4F,/2] [F/4C/4c/4^g/4] [C/4F/4c/4^g/4^A,/2]\n[C3/4F3/4c3/4^g3/4z/4] C,/2 ^D,/2 [^G/4^D/4^d/4c'/4F,/2]\n[^D/4^G/4^d/4c'/4] [^D/4^G/4^d/4c'/4^G,3/8] [^D/4^G/4^d/4c'/4]\n[^G/4^D/4^d/4c'/4] [=G/4=D/4=d/4^a/4] [G/4D/4d/4F,3/8^a/4]\n[G/2D/2d/2^a3/8z/4] [F,/2z/4] [F/4C/4c/4^g/4] [C/4F/4c/4^D,3/8^g/4]\n[C/4F/4c/4^g/4] [C/4F/4c/4^g/8] z/8 [^A,/4^D/4^A/4=g/4]\n[^A,/4^D/4^A/4g/4C,3/8] [^D/4^A,/4^A/4g/4] [^A,/4^D/4^A/4g/4F,17/8]\n[C/4F/4c/4^g/4] [C/4F/4c/4^g/4] [C5/8F5/8c5/8^g/2] z3/4\n[^A,/4^D/4^A/4=g/4] [F,/4F/4C/4c/4^g/4] [^A,/2C/4F/4c/4^g/4]\n[F/2C/2c/2^g5/8z/4] C,/2 ^D,/2 [^D/2^G/2^d/2c'/2F,/2] ^G,3/8 z/8\n[=D5/8=G/2=d5/8^a/2] F,3/8 z/8 [F/2C/2c/2^g/2F,/2] ^D,3/8 z/8\n[^D/2^A,/2^A/2=g/2^D,/2] C,3/8 z/8 [^D/4^A,/4^A/4C,7/8g/4]\n[C/4F/4c/4^g/4] [C/4F/4c/4^g/4] [C5/8F5/8c5/8^g/2] z/4 F,/2\n[^D/4^A,/4^A/4=g/4F,/4] [F/4C/4c/4^g/4F,/4] [F/4C/4c/4^A,/2^g/4]\n[F5/8C5/8c5/8^g5/8z/4] C,/2 ^D,/2 [^G/2^D/2^d/2c'/2F,/2] ^G,3/8 z/8\n[^a/2=G/2=D/2=d/2] F,3/8 z/8 [F/2C/2c/2^g/2F,/2] ^D,/4 z/4\n[^D/2^A,/2^A/2=g/2] C,3/8 z/8 [C/4F/4c/4^g/4F,12] [F/4C/4c/4^g/4]\n[F/4C/4c/4^g/4] [F13/4^G13/4f13/4c'13/4] [^a7/2^D7/2=G7/2^d7/2]\n[^G/4F/4f/4c'/4] [^D/4=G/4^d/4^a/4] [C4F4c4^g4]\n[^D21/8^A,21/8^A21/8=g9/4C,9/4] F,/4 [c'5/8=G,/2] [^A,/2z/4]\n[c'3/8z/4] [C,/2^a/2] [^D,/4c'/4z/8] [^a3/8z/8] [F,3/8z/8] ^g3/8\n^G,3/8 z3/8 ^D,3/8 z/8 F,/2 C,/4 z/4 ^A,/4 C,/4 ^D,/4 z/4\n[^D,/4^A,/4] [F,/4C,/4] z/4 ^D,/4 z/4  z/4 ^A,/2 C,/2 ^D,/2\n[^a/4^A/4F,/2] [c'/2c/2z/4] [^G,3/8z/4] [^d3/4z/4] ^D,/4 [F,/2z/4]\n[c'/4c/4] [^a/4^A/4^G,/8] z/8 [c'/4c/4] [^a/4^A/4] [^D,/4^g/4^G/4]\n[^a/4^A/2] [F,/2z/4] [^a3/8^A/2z/4] C,/8 z/8 [c'3/8c/2z/4] ^A,/4\n[f/4F/4C,/4] [f/4F/4^D,/4] [f/4F/4] [^D,/2^A,/4^g3/8^G/2] C,/4\n[^g3/8^G/4] [^D,/4^a3/8^A/2] z/8 [^a/4z/8] ^D,/4 [^A,/2z/4]\n[^d/4^D/4] [C,/2f/4F/4] [f/4F/4] [^D,/2f3/8F/2] z/8 F,/2\n[^G,/2c'/4c/4] [c'/4c/4] [^D,/4^d/4] [F,/4c'/2c/2] z/4\n[^G,/4^a/2^A/2] z/4 [^g/2^G/2z/4] ^D,/4 [^a/2^A/2z/4] [F,/2z/4]\n[^g/2^G/2z/4] C,/4 [c'3/8c/2z/4] ^A,/4 [f/4F/4C,/4] [f/4F/4^D,/4]\n[^g3/8^G/2z/4] [C,/4^A,/4] [^D,3/8^g/4^G/4C,3/8] [^d3/8^D/2z/4] ^D,/4\nz/4 [^d/4^D/4] z/4 [^A,/2^d/4^D/4] [f/2F/2z/4] [C,/2z/4] [f/2F/2z/4]\n[^D,/2z/4] [f/2F/2z/4] [F,/2z/4] [f/4F/2] [^G,/2^g/4] [^g/4^G/4]\n[^A,^a3/4^A3/4] [^a3/8^A/2z/4] ^A,/4 z/4 ^A,/4 F,/4\n[^A,F,/8^g3/8^G/4] z/8 [^G,/8^a/2^A/2] z3/8 [^a3/8^A/2F,/8] z/8\n[^G,/2^A,/2] [^A,/2F,/8] z/8 [f/4F/4] [^A,7/8^g/4^G/4] [^a/2^A/2]\n[^a/2^A/2z/4] [^A,z/4] [^g3/8^G/2] z/8 [c'3/8c/2z/4] ^A,/4\n[^a/2^A/2^A,/4^G,/8] z/8 F,/4 [F,/4^a/2^A/2] ^G,/2 [=A,3/8F,/8] z/8\n[f/4^G/4F/4] [^A,/2^g/4c/4^G/4] [^a/2^A/2=d/2z/4] [^A,3/8z/4]\n[^a3/8d/2^A3/8z/4] ^A,3/8 z/8 ^A,/4 [^G/4F,/4f/4F/4]\n[^A,3/2^g3/8c/4^G/4] [^a/2^A/2d/2^G,/8] z3/8 [^a3/8^A3/8d5/8F,/8] z/8\n^G,/2 F,/8 z/8 [f/4F/4^G/4F,/4] [^g3/8c/4^G/4^A,/2] [^a/2d/2^A/2z/4]\n[^A,/2z/4] [d/2^A/2^a/2z/4] [^A,3/4z/4] [^g/2c/2^G/2]\n[c'/2^d/2c/2^A,/4] F,/8 z/8 [^G,/8^A,/4^a/2=d/2^A/2] z/8 [^A,3/8z/4]\n[^a/4F,/8d/8^A/8] [^g/4c/8^G/8] [^A,/4^G,/2f/2^G/2F/2] C,/4\n[^D,3/8F,/8] z3/8 [^D/4^G/4^d/4c'/4F,/2] [^D/4^G/4^d/4c'/4]\n[^D/4^G/4^d/4^G,3/8c'/4] [^G/4^D/4^d/4c'/4] [^D/4^G/4^d/4c'/4]\n[=G/4=D/4=d/4^a/4] [D/4G/4d/4^a/4F,/4] [G/2D/2d/2^a3/8z/4] [F,/2z/4]\n[F/4C/4c/4^g/4] [F/4C/4c/4^g/4^D,3/8] [F/4C/4c/4^g/4] [F/4C/4c/4^g/4]\n[^A,/4^D/4^A/4=g/4] [g/4^A,/4^D/4^A/4C,/4] [^A,/2^D/2^A/2g/2z/4]\n[C,7/8z/4] [F/4C/4c/4^g/4] [C/4F/4c/4^g/4] [C/2F/2c/2^g/2] z/4 F,3/8\nz/8 [^D/4^A,/4^A/4=g/4F,/2] [C/4F/4c/4^g/4] [C/4F/4c/4^g/4^A,/2]\n[C3/4F3/4c3/4^g3/4z/4] C,/2 ^D,/4 z/4 [^G/4^D/4^d/4F,/2c'/4]\n[^D/4^G/4^d/4c'/4] [^D/4^G/4^d/4^G,3/8c'/4] [^D/4^G/4^d/4c'/4]\n[^G/4^D/4^d/4c'/4] [=G/4=D/4=d/4^a/4] [D/4G/4d/4^a/4F,/4]\n[G/2D/2d/2^a3/8z/4] [F,/2z/4] [C/4F/4c/4^g/4] [C/4F/4c/4^D,3/8^g/4]\n[C/4F/4c/4^g/4] [C/4F/4c/4^g/8] z/8 [^A,/4^D/4^A/4=g/4]\n[^A,/4^D/4^A/4g/4C,3/8] [^D/4^A,/4^A/4g/4] [^A,/4^D/4^A/4g/4F,15/8]\n[F/4C/4c/4^g/4] [C/4F/4c/4^g/4] [C5/8F5/8c5/8^g/2] z3/4\n[^A,/4^D/4^A/4=g/4] [C/4F/4c/4F,/4^g/4] [C/4F/4c/4^g/4^A,/2]\n[C/2F/2c/2^g5/8z/4] C,/2 ^D,/2 [c'/2^D5/8^G5/8^d5/8F,/2] ^G,3/8 z/8\n[^a/2=D5/8=G5/8=d5/8] F,3/8 z/8 [^g/2F/2C/2c/2F,/2] ^D,3/8 z/8\n[^A,/2^D/2^A/2=g/2^D,/2] C,3/8 z/8 [^D/4^A,/4^A/4g/4C,9/8]\n[C/4F/4c/4^g/4] [C/4F/4c/4^g/4] [C5/8F5/8c5/8^g/2] z/4 F,/4 z/4\n[^D/4^A,/4^A/4=g/4F,/8] z/8 [F/4C/4c/4^g/4F,/4] [C/4F/4c/4^A,/2^g/4]\n[F5/8C5/8c5/8^g5/8z/4] C,/2 ^D,3/8 z/8 [c'/2^G/2^D/2^d/2F,/2] ^G,3/8\nz/8 [^a/2=D/2=G/2=d/2] F,/4 z/4 [C/2F/2c/2F,/2^g/2] ^D,/2\n[^D/2^A,/2^A/2=g/2] C,3/8 z/8 [C/4F/4c/4^g/4F,12] [F/4C/4c/4^g/4]\n[C/4F/4c/4^g/4] [F13/4^G13/4f13/4c'13/4] [^a13/4^D13/4=G13/4^d13/4]\n[^G/4F/4f/4c'3/8] [=G/4^D/4^d/4^a/4] [^g/8F/4C/4c/4] z/8 [C4F4c4^g4]\n[^A,2^D2^A2=g5/4C,9/4] z/4 [f15/8z3/4] F,/4 =G,/2 ^A,/2 [f/2C,3/8]\nz/8 [^D,/4f] F,/4 z/4 ^G,/8 z/8 ^d/4 z/4 ^D,/4 z/4 [F,5/8z/2] C,/8\nz3/8 ^A,/4 C,/4 ^D,/4 z/4 [^D,/4^A,/4] [F,/4C,/4] z/4 ^D,/8 z3/8  z/4\n^A,3/8 z/8 C,/2 ^D,/2 F,/2 ^G,/2 ^A,/2 [^A,3/8^a/2^A/2] z/8\n[^a/2^A/2^A,3/8] z/8 [^g/4^G/2] z/4 [c'3/4c3/4] [^a/2^A/2z/4]\n[F,/4^G,/4] [^G,3/8^g/4^G/4] [f/4F/4F,/8] z/8 F,/8 z/8 ^A,/2\n[^A,3/8^a/2^A/2] z/8 [^A,3/8^a/2^A/2] z/8 [^g/4^G/2] z/4\n[c'3/4c3/4z/4] [^G,/8^A,/4] z/8 F,/4 [F,/4^a/2^A/2] [^G,/2z/4]\n[^g/4^G/4] [f3/8F3/8F,/8C,3/8] z3/8 ^A,/2 ^A,3/8 z5/8 [^g/2^G/2z/4]\n^G,/8 z/8 [^a/2^A/2z/4] ^G,/8 z/8 [^D,3/8^g/4^G/4] [F,/8^a/2^A/2] z/8\n[^D,3/8^G,/2z/4] [^g/4^G/4] [F,/8^D,3/8^a/4^A/4] z/8 [^g/4^G/4]\n[^D,/4f3/8F3/8] F,3/8 z/8 ^G,/4 z/2 ^D,/4 z/4 [F,5/8z/2] C,/8 z3/8\n^A,/4 C,/4 ^D,/4 z/4 [^A,/4^D,/4] [C,/4F,/4] z/4 ^D,/8 z3/8  z/4\n^A,/2 C,/2 ^D,/2 F,/2 ^G,3/8 z/8 ^A,/2 [^A,3/8^a/2^A/2] z/8\n[^A,3/8^a/2^A/2] z/8 [^g3/8^G/2] z/8 [c'3/4c3/4z/4] ^G,/8 z3/8\n[^a/2^A/2F,/8] z/8 [F,/4^G,/4] [^G,3/8^g/4^G/4] [f3/8F3/8F,/8] z/8\nF,/4 ^A,/2 ^A,3/8 z/8 ^A,/4 z/4 [^g/2^G/2^G,/8] z/8 ^G,/8 z/8\n[^a/2^A/2z/4] [^A,/4^G,/8] z/8 [F,/4^g/4^G/4] [F,/4^a/2^A/2]\n[^G,/2z/4] [^g/4^G/4] [F,/8C,3/8^a/4^A/4] z/8 [^g/4^G3/8] ^A,/2 ^A,/2\nz3/4 ^G,/8 z3/8 ^G,/8 z/8 [^D,3/8c'/2c/2z/4] F,/8 z/8\n[^G,/2^D,3/8c'/4c/4] [^a/4^A/4] [^g3/8^G/4^D,3/8F,/8] z/8 [c'6c6z/4]\n^D,/4 F,3/8 z/8 ^G,/4 z/2 ^D,/4 z/4 F,/2 C,/8 z3/8 ^A,/4 C,/4 ^D,/4\nz/4 [^A,/4^D,/4] [C,3/8F,/4] z/4 ^D,/8 z3/8  z/4 [^A,/2z/4]\n[^a/4^A/4] [^g3/8^G3/8C,/2] z/8 [^D,/2f/2F/2] [F,/2^g/4^G/4]\n[^a/2^A/2z/4] [^G,3/8z/4] [c'3/4c3/4z/4] ^D,/4 [F,3/8z/4] [^a/4^A/4]\n[^g/4^G/4^G,/4] [^a/4^A/4] [f/2F/2z/4] ^D,/4 [^g/2^G/2z/4] [F,/2z/4]\n[^g/2^G/2z/4] C,/8 z/8 [^a3/8^A/2z/4] ^A,/4 [f/4F/4C,/4]\n[f/4F/4^D,/4] [^g/2^G/2z/4] [^D,/2^A,/4] [^g/4^G/4C,/4] [f/2F3/4z/4]\n^D,/8 z3/8 [^d/2^D/2] z/4 [^A,/2z/4] [f/2F/2z/4] [C,/2z/4] [f/4F/4]\n[f3/8F3/8^D,/2] z/8 F,/2 ^G,3/8 z/8 [c'/4c/4^D,/4] [F,3/8c'/2c/2] z/8\n[c'5/8c3/4^G,/4] z/2 [^D,/4f/4F/4] [^g/2^G/2z/4] [F,/2z/4]\n[^g/2^G/2z/4] C,/4 [^a3/8^A/2z/4] ^A,/4 [C,/4f/4F/4] [^D,/8f/2F/2]\nz3/8 [^D,5/8^A,/4^g/2^G/2] C,/4 [^g/4^G/4] [^g/2^G/2^D,/4] z/4  z/4\n[^d/4^D/4^A,/2] [f/2F/2z/4] [C,/2z/4] [f/2F/2z/4] [^D,/2z/4]\n[f/2F/2z/4] [F,/2z/4] [f/4F/4] [^G,3/8^g/4^G/4] [^g/4^G/4]\n[^a3/4^A3/4^A,] [^a3/8^A3/8z/4] ^A,3/8 z/8 ^A,/4 F,/4\n[^A,7/8F,/8^g3/8^G/4] z/8 [^G,/8^a/2^A/2] z3/8 [^a3/8^A/2F,/8] z/8\n[^A,3/8^G,/2] z/8 [^A,/2F,/8] z/8 [f/4F/4] [^g3/8^G/4^A,] [^a/2^A/2]\n[^a/2^A/2z/4] [^A,7/8z/4] [^g/2^G/2] [c'/2c/2^G,/8] z/8 ^A,/4\n[^A,/4^a/2^A/2^G,/8] z/8 F,/4 [F,/4^a/2^A/2] ^G,/2 [=A,3/8F,/8] z/8\n[f/4F/4^G/4] [^A,^g3/8c/4^G/4] [^a/2^A/2=d/2] [d/2^a/2^A/2z/4] ^A,3/8\nz/8 ^A,/4 [F,/4^G/4f/4F/4] [^A,c/4F,/8^g3/8^G/4] z/8\n[^G,/8d/2^a/2^A/2] z3/8 [^a/2^A/2d5/8F,/8] z/8 [^G,/2^A,3/8] z/8\n[F,/8^A,/2] z/8 [f/4F/4^G/4] [^g/4c/4^G/4^A,7/8] [^a/2d/2^A/2]\n[d/2^a/2^A/2z/4] [^A,5/4z/4] [c/2^g5/8^G/2] [^d/2c'/2c/2z/4] F,/8 z/8\n[^a/2^A/2F,/4^G,/8=d/2] z/8 [^A,3/8z/4] [^a/4^A/8d/8F,/8]\n[^g/4^G/8c/8] [^A,/4f/2F/2^G,/2^G/2] C,/4 [^D,3/8F,/8] z3/8\n[c'/4^D/4^G/4^d/4F,/2] [^D/4^G/4^d/4c'/4] [^G,/2^D/4^G/4^d/4c'/4]\n[^G/4^D/4^d/4c'/4] [^G/4^D/4^d/4c'/4] [=D/4=G/4=d/4^a/4]\n[D/4G/4d/4^a/4F,3/8] [^a3/8G/2D/2d/2z/4] [F,/2z/4] [F/4C/4c/4^g/4]\n[^g/4F/4C/4c/4^D,/2] [^g/4F/4C/4c/4] [^g/4F/4C/4c/4]\n[=g/4^A,/4^D/4^A/4] [g/4^A,/4^D/4^A/4C,3/8] [g/2^A,/2^D/2^A/2z/4]\n[C,z/4] [^g/4C/4F/4c/4] [C/4F/4c/4^g/4] [^g/2C/2F/2c/2] z/4 F,3/8 z/8\n[=g/4^D/4^A,/4^A/4F,/2] [^g/4F/4C/4c/4] [^g/4C/4F/4c/4^A,3/8]\n[^g3/4C3/4F3/4c3/4z/4] C,/2 ^D,3/8 z/8 [c'/4^G/4^D/4^d/4F,/2]\n[c'/4^D/4^G/4^d/4] [c'/4^D/4^G/4^d/4^G,3/8] [c'/4^D/4^G/4^d/4]\n[c'/4^G/4^D/4^d/4] [^a/4=G/4=D/4=d/4] [F,/4G/4D/4d/4^a/4]\n[^a3/8G/2D/2d/2z/4] [F,/2z/4] [F/4C/4c/4^g/4] [C/4F/4c/4^g/4^D,/2]\n[C/4F/4c/4^g/4] [C/4F/4c/4^g/8] z/8 [=g/4^A,/4^D/4^A/4]\n[g/4^A,/4^D/4^A/4C,3/8] [g/4^D/4^A,/4^A/4] [^A,/4^D/4^A/4F,15/8g/4]\n[^g/4C/4F/4c/4] [^g/4C/4F/4c/4] [^g/2C5/8F5/8c5/8] z3/4\n[=g/4^A,/4^D/4^A/4] [^g/4F/4C/4c/4F,/4] [^g/4C/4F/4c/4^A,/2]\n[^g5/8F/2C/2c/2z/4] C,/2 ^D,3/8 z/8 [c'/2^D/2^G/2^d/2F,/2] ^G,3/8 z/8\n[^a/2=D/2=G/2=d/2] F,/2 [^g/2F/2C/2c/2F,/2] ^D,/2\n[^D/2^A,/2^A/2=g/2^D,/2] C,3/8 z/8 [^D/4^A,/4^A/4g/4C,7/8]\n[C/4F/4c/4^g/4] [C/4F/4c/4^g/4] [C5/8F5/8c5/8^g/2] z/4 F,/4 z/4\n[=g/4^D/4^A,/4^A/4F,/4] [^g/4F/4C/4c/4F,/4] [F/4C/4c/4^A,/2^g/4]\n[F3/4C3/4c3/4^g5/8z/4] C,/2 ^D,/2 [F,/2c'/2^G/2^D/2^d/2] ^G,/2\n[^a/2=G/2=D/2=d/2] F,3/8 z/8 [F/2C/2c/2F,/2^g/2] ^D,/2\n[^D/2^A,/2^A/2=g/2] C,/2 [C/4F/4c/4F,93/8^g/4] [F/4C/4c/4^g/4]\n[F/4C/4c/4^g/4] [F13/4^G13/4f13/4c'13/4] [^a13/4^D13/4=G13/4^d13/4]\n[^G/4F/4f/4c'3/8] [=G/4^D/4^d/4^a/4] [^g/8C/4F/4c/4] z/8 [^g4C4F4c4]\n[=g9/4^D9/4^A,9/4^A9/4C,9/4] F,/4 [c'3/2=G,/2] ^A,/2 C,3/8 z/8\n[^a/4^D,/4z/8] [^g3/8z/8] F,3/8 z/8 ^G,/4 z/2 ^D,/4 z/4 [F,7/8z/2]\nC,/8 z3/8 ^A,/4 C,/4 ^D,/4 z/4 [^A,/4^D,/4] [F,3/8C,/4] z/4 ^D,/8\nz3/8  z/4 ^A,/2 C,/2 ^D,/2 F,/2 ^G,/4 z/4 ^A,/2 [^A,3/8^a/2^A/2] z/8\n[^A,/2^a/2^A/2] [^g/2^G/2] [c'3/4c3/4F,/8] z/8 ^G,/8 z3/8\n[^a/2^A/2F,/8] z/8 [F,/4^G,/4] [^G,/2^g/4^G/4] [f3/8F/2F,/8] z/8 F,/4\n^A,/2 [^A,/2^a/2^A/2] [^A,3/8^a3/8^A/2] z/8 [^g/2^G/2]\n[c'3/4c3/4F,/8] z/8 [^G,/8^A,/4] z/8 F,/4 [^a/2^A/2F,/4] [^G,/2z/4]\n[^g/4^G/4] [C,/4f/4F/4F,/8] z3/8 ^A,/2 ^A,3/8 z5/8 [^g/2^G/2]\n[^a/2^A/2F,/8] z/8 ^G,/8 z/8 [^D,3/8^g/4^G/4] [F,/8^a/2^A/2] z/8\n[^G,3/8^D,3/8z/4] [^g/4^G/4] [F,/8^D,3/8^a3/8^A/4] z/8 [^g/4^G/4]\n[^D,/4f5/8F5/8] F,3/8 z/8 ^G,/4 z/2 ^D,/4 z/4 F,3/8 z/8 C,/8 z3/8\n^A,/4 C,/4 ^D,/4 z/4 [^D,/4^A,/4] [F,/4C,/4] z/4 ^D,/8 z3/8  z/4\n^A,/2 C,/2 ^D,/2 F,/2 ^G,3/8 z/8 ^A,/2 [^A,3/8^a/2^A/2] z/8\n[^a/2^A/2^A,/2] [^g/2^G/2] [c'3/4c3/4F,/8] z/8 ^G,/8 z3/8\n[F,/8^a/2^A/2] z/8 [^G,/4F,/4] [^g/4^G/4^G,3/8] [f3/8F3/8F,/8] z/8\nF,/4 ^A,/2 ^A,3/8 z5/8 [^G,/4^g/2^G/2] ^G,/8 z/8 [^a/2^A/2z/4] ^G,/8\nz/8 [^g/4^G/4^D,/8] z/8 [^a/2^A/2F,/8^D,/4] z/8 [^G,3/8z/4]\n[^g/4^G/4^D,/8] z/8 [^a/4^A/4^D,/4F,/8] z/8 [^g/4^G/4]\n[f7/8F7/8^D,/4] F,3/8 z/8 ^G,/8 z5/8 ^D,/8 z3/8 F,3/8 z/8\n[C,/8c'/2c/2] z3/8 [^A,/4c'3/8c/4] [C,/4^a3/8^A/4] [^D,/8^g3/8^G/4]\nz/8 [c'81/8c41/4z/4] [^D,/4^A,/4] [C,/4F,/4] z/4 ^D,/8 z3/8  z/4\n^A,/2 C,/2 ^D,/2 F,/2 ^G,3/8 z/8 ^D,/4 F,/4 z/4 ^G,/4 z/2 ^D,/4 z/4\nF,/2 C,/8 z3/8 ^A,/4 C,/4 ^D,/8 z3/8 [^D,/4^A,/4] [C,/4F,3/8] z/4\n^D,/4 z/4  z/4 ^A,/2 [C,/2c'5/8c/2] [^D,/2^a3/8^A/2] z/8\n[F,/2^a/2^A/2] [^g/4^G3/8^G,3/8] z/4 ^A,/2 [^A,3/8^a/2^A/2] z/8\n[^a/2^A/2] [^g/2^G/2] [F,/8^A,/8c'3/4c3/4] z/8 ^G,/8 z3/8\n[^a/2^A/2F,/8] z/8 [^G,/4F,/4] [^g/4^G/4^G,3/8] [f3/8F/2F,/8] z/8\nF,/4 ^A,/2 [^A,/4^a/2^A/2] z/4 [^a3/8^A/2] z/8 [^g/2^G/2]\n[c'3/4c3/4F,/8] z/8 [^A,/4^G,/8] z/8 F,/4 [^a/2^A/2F,/4] [^G,/2z/4]\n[^g/4^G/4] [F,/8f/4F/4C,/2] z3/8 ^A,/2 ^A,3/8 z5/8 [^g/2^G/2]\n[^a/2^A/2F,/8] z/8 ^G,/8 z/8 [^D,3/8^g/4^G/4] [^a/2^A/2F,/8] z/8\n[^D,3/8^G,/2z/4] [^g/4^G/4] [^D,/4^a3/8^A/4F,/8] z/8 [^g/4^G/4]\n[^D,/4f5/8F5/8] F,/4 z/4 ^G,/4 z/4 [^d/4^D/4] [^D,/4f3/8F/4]\n[^g/4^G3/8] F,/2 C,/8 z3/8 ^A,/4 C,/4 ^D,/4 z/4 [^D,/4f/4F/4^A,/4]\n[C,/4F,/4^g/4^G/4] [^a/4^A/4] [c'/4c3/8^D,/8] z3/8  z/4 ^A,/2\n[C,/2^a/4^A/4] [c'3/8c/4] [^D,/2^d/4] f/4 F,/2 ^G,3/8 z/8 ^A,/2\n[^A,3/8^a/2^A/2] z/8 [^a/2^A/2] [^g/2^G/2] [c'3/4c3/4F,/8] z/8 ^G,/8\nz3/8 [F,/8^a/2^A/2] z/8 [^G,/4F,/4] [^G,3/8^g/4^G/4] [f3/8F3/8F,/8]\nz/8 F,/8 z/8 ^A,/2 ^A,/2 z/2 [^g/2^G/2^G,/8] z/8 ^G,/8 z/8\n[^G,/4^a/2^A/2] ^G,/4 [^g/4^G/4] [^a/2^A/2F,/8] z/8 [^D,/4^G,/2]\n[^g/4^G/4] [^a/4^A/4^D,/4F,/8] z/8 [^g/4^G/4] [f7/8F7/8^D,/4] F,3/8\nz/8 ^G,/4 z/2 ^D,/4 z/4 F,/2 [C,/8c'/2c/2] z3/8 [^A,/4c'3/8c/4]\n[C,/4^a3/8^A/4] [^g3/8^G/4^D,/8] z/8 [c'81/8c81/8z/4] [^A,/4^D,/4]\n[C,/4F,/4] z/4 ^D,/8 z3/8  z/4 ^A,/2 C,/2 ^D,/2 F,/2 ^G,/4 z/4 ^D,/4\nF,3/8 z/8 ^G,/4 z/2 ^D,/4 z/4 F,/2 C,/8 z3/8 ^A,/4 C,/4 ^D,/8 z3/8\n[^A,/4^D,/4] [C,/4F,3/8] z/4 ^D,/8 z3/8  z/4 ^A,/2 [C,/2c'5/8c5/8]\n[^a3/8^A5/8^D,/2] z/8 [F,/2c'/2c5/8] [^G,3/8^a3/8^A3/8z/4]\n[^g/4^G3/8] ^A,/2 [^A,/2^a/2^A/2] [^a/2^A/2] [^g/2^G5/8]\n[c'3/4c7/8z/4] ^G,/8 z3/8 [^a/2^A/2F,/8] z/8 [^G,/4F,/4]\n[^g/4^G/4^G,3/8] [f3/8F/2F,/8] z/8 F,/4 ^A,/2 [^A,3/8^a/2^A/2] z/8\n[^a3/8^A5/8] z/8 [^g/2^G/2z/4] ^G,/8 z/8 [c'3/4cz/4] [^A,/4^G,/8] z/8\nF,/4 [F,/4^a/2^A/2] [^G,/2z/4] [^g/4^G/4] [C,3/8F,/8f/4F3/8] z3/8\n^A,/2 ^A,3/8 z5/8 [^g/2^G5/8^G,/8] z/8 ^G,/8 z/8 [^a/2^A/2z/4] ^G,/8\nz/8 [^D,/4^g/4^G3/8] [F,/8^a/2^A5/8] z/8 [^G,/2^D,/4] [^g/4^G3/8]\n[F,/8^D,/4^a3/8^A3/8] z/8 [^g/4^G3/8] [^D,/4f/2F/2] [F,3/8z/4]\n[f3/8F3/8z/4] [^g/4^G3/8^G,/4] z/2 ^D,/4 z/4 F,/2 C,/8 z/8\n[^a3/8^A3/8z/4] [c'3/8c3/8^A,/4] C,/4 ^D,/8 z3/8 [^D,/4^A,/4]\n[C,/4F,3/8] [f/2z/4] ^D,/8 z/8 [f3/4z/4]  z/4 [^A,/2^d3/8] z/8 C,/2\n[c'/2c5/8^D,/2] [F,/2^a/2^A5/8] [^G,3/8^g/8^G/8] z3/8 ^A,/2\n[^A,3/8^a/2^A/2] z/8 [^a/2^A5/8] [^g/2^G5/8] [c'3/4c7/8F,/8] z/8\n^G,/8 z3/8 [^a/2^A/2F,/8] z/8 [F,/4^G,/4] [^g/4^G3/8^G,/2]\n[f3/8F3/8F,/8] z/8 F,/4 ^A,/2 ^A,3/8 z5/8 [^g/2^G3/4^G,/4] ^G,/8 z/8\n[^a/2^A5/8z/4] ^G,/8 z/8 [^g/4^G3/8^D,3/8] [^a/2^A5/8F,/8] z/8\n[^G,/2z/4] [^g/4^G3/8] [^a/4^A3/8F,/8^D,/4] z/8 [^g/4^G/4]\n[f7/8F7/8^D,/4] F,3/8 z/8 ^G,/4 z/2 ^D,3/8 z/8 F,/2 [C,/8c'/2c/2]\nz3/8 [^A,/4c'3/8c3/8] [C,/4^a3/8^A3/8] [^g3/8^G3/8^D,/4]\n[c'81/8c81/8z/4] [^D,/4^A,/4] [F,/4C,/4] z/4 ^D,/8 z3/8  z/4 ^A,/2\nC,/2 ^D,/2 F,/2 ^G,/2 ^D,/4 F,3/8 z/8 ^G,/4 z/2 ^D,/4 z/4 F,3/8 z/8\nC,/8 z3/8 ^A,/4 C,/4 ^D,/8 z3/8 [^A,/4^D,/4] [F,/4C,/4] z/4 ^D,/8\nz3/8  z/4 ^A,/2 [C,/2c'5/8c/2] [^a3/8^A3/8^D,/2] z/8 [F,/2c'/2c/2]\n[^G,3/8^a3/8^A/4] [^g/4^G/4] ^A,/2 [^A,3/8^a/2^A/2] z/8 [^a/2^A/2]\n[^g/2^G/2] [c'3/4c3/4z/4] ^G,/8 z3/8 [^a/2^A/2F,/8] z/8 [F,/4^G,/4]\n[^G,/2^g/4^G/4] [f3/8F3/8F,/8] z/8 F,/4 ^A,/2 [^A,/4^a/2^A/2] z/4\n[^a3/8^A3/8] z/8 [^g/2^G/2^G,/8] z/8 ^G,/8 z/8 [c'3/4c3/4z/4] [^A,/4]\nz/4 F,/4 [F,/4^a/2^A/2] [^G,/2z/4] [^g/4^G/4] [C,/2F,/8f/4F/4] z3/8\n^A,/2 ^A,3/8 z5/8 [^g/2^G/2^G,/8] z3/8 [^a/2^A/2]\n[^D,3/8^g/4^G/4^G,/8] z/8 [^a/2^A/2z/4] [^D,/4^G,/2] [^g/4^G/4]\n[F,/8^a3/8^A/4^D,/4] z/8 [^g/4^G/4] [^D,/4f5/8F5/8] [F,3/8z/4]\n[^g13/4z/4] ^G,/4 z/2 ^D,/4 z/4 F,/2 C,/8 z3/8 ^A,/4 C,/4 ^D,/8 z/8\n^d/4 [^D,/4f/2^A,/4] [F,/4C,/4] ^d/4 ^D,/8 z3/8  z/4 [^A,/2c'/2c/2]\n[^a/2^A/2C,/2] [^g3/8^G/2^D,/2] z/8 [F,/2c'/2c/2] [^a/4^A/4^G,/4] z/4\n^A,/2 [^A,3/8^a/2^A/2] z/8 [^a/2^A/2] [^g/2^G/2] [c'3/4c3/4z/4] ^G,/8\nz3/8 [^a/2^A/2F,/8] z/8 [F,/4^G,/4] [^G,/2^g/4^G/4] [f3/8F3/8F,/8]\nz/8 F,/4 ^A,/2 ^A,3/8 z5/8 [^g/2^G/2^G,/4] ^G,/8 z/8 [^a/2^A/2z/4] \nz/4 [^g/4^G/4^D,/2] [^a/2^A/2F,/8] z/8 [^G,/2z/4] [^g/4^G/4]\n[^a/4^A/4^D,/4F,/8] z/8 [^g/4^G/4] [f7/8F7/8^D,/4] F,/4 z/4 ^G,/4 z/2\n^D,/4 z/4 F,/2 [C,/8c'/2c/2] z3/8 [c'3/8c/4^A,/4] [C,/4^a3/8^A/4]\n[^g3/8^G/4^D,/4] [c'81/8c81/8z/4] [^A,/4^D,/4] [F,/4C,/4] z/4 ^D,/8\nz3/8  z/4 ^A,/2 C,/2 ^D,/2 F,/2 ^G,/4 z/4 ^D,/4 F,3/8 z/8 ^G,/4 z/2\n^D,/4 z/4 F,3/8 z/8 C,/8 z3/8 ^A,/4 C,/4 ^D,/4 z/4 [^D,/4^A,/4]\n[C,/4F,/4] z/4 ^D,/8 z3/8  z/4 ^A,/2 [C,/2c'5/8c/2z/4] ^G,/8 z/8\n[^a3/8^A/2^D,/2z/4] F,/8 z/8 [F,/2^G,/2c'/2c/2] [^G,3/8^a3/8^A/4F,/8]\nz/8 [^g/4^G/4] ^A,/2 ^A,3/8 z5/8 ^G,/8 z/8 ^G,/8 z3/8  z/2 F,/8 z/8\n[F,/4^G,/4] [^G,/2z/4] F,/8 z/8 F,/4 ^A,/2 ^A,/4 z3/4 ^G,/8 z5/8\n^A,/4 [F,/2^G,/8] z3/8 ^G,/2 F,/2 F,/2 F,3/8 	0	0	197	f	\N
5	2015-05-25 11:13:14.744409	2015-06-08 07:58:51.202619	6	3	Yahoo! Acquisitions	1	NULL	http://farm1.static.flickr.com/101/295989204_3d3f895ecd_XXXX.jpg	\N	\N	\N	f	f	2	3	47	0	NULL	2	t	\N	Metallica - Nothing else matters	X: 1\nT: nem (6:32)\nZ: Transcribed by LotRO MIDI Player: http://lotro.acasylum.com/midi\n%  Original file: nem.mid\n%  Transpose: -7\nL: 1/4\nQ: 92\nK: C\n\nA,5/8 C3/4 E5/8 A5/8 E3/4 C5/8 A,5/8 C3/4 E5/8 A5/8 E3/4 C5/8 A,5/8\nC3/4 E5/8 A5/8 E3/4 C5/8 A,5/8 C3/4 E5/8 A5/8 E3/4 e5/8 [A,5/8e5/8]\nE3/4 C5/8 [E3/8e3/8] A/4 E3/4 C5/8 [A,5/8E5/8] C3/4 [e5/8E5/8]\n[E5/8f5/8] e/2 f/4 d5/8 [E5/8e5/8] d/4 c/4 B/4 A5/8 [D,5/8A5/8] F3/4\nA5/8 B3/8 A/4 A3/4 F5/8 D,5/8 F3/4 A5/8 A5/8 [D,3/4F3/4A3/4]\n[D,5/8F5/8A5/8] [F,5/8F5/8A5/8] F,3/8 F3/8 A/4 F3/8 c3/8 A/4 A3/8\nF3/8 [F,5/8F5/8A5/8] [G,5/8G5/8B5/8A5/8] G,3/8 G3/8 B/4 G3/8 A3/8 d/8\nA/8 B3/8 E3/8 E/4 A3/8 A,5/8 [e3/4c3/4] e5/8 a5/8 E3/4 C5/8 A,5/8\nC3/4 E5/8 A5/8 E3/4 C5/8 A,5/8 C3/4 E5/8 A5/8 E3/4 C5/8 A,5/8 C3/4\nE5/8 A5/8 E3/4 C5/8 A, A,3/8 E/4 A3/8 [e2c2] G,5/8 D3/4 [B5/8G5/8]\nF,5/8 C3/4 [F5/8A5/8] A, A,3/8 E/4 A3/8 [e2c2] G,5/8 D3/4 [B5/8G5/8]\nF,5/8 C3/4 [F5/8A5/8] A, A,3/8 [E/4A/4] [A3/8c3/8] [e2c2] G,5/8\n[D3/4d3/8] B3/8 [G5/8B5/8] F,5/8 [C3/4c3/8] A3/8 [F5/8A5/8] C,5/8\n[C3/4c3/8] G3/8 [E5/8G5/8] E,5/8 [B,3/4B3/8] ^G3/8 [D5/8^G5/8]\n[A,5/8D/4] C/4 B,/8 [C11/8z3/4] E5/8 A5/8 E3/4 C5/8 [A,5/8a4e4c4]\nC3/4 E5/8 A5/8 E3/4 C5/8 A,5/8 C3/4 [E5/8A5/8] [c5/8A] C3/8 A3/8\n[E/4A/4] [C3/8A3/8] [B5/8G,5/8z3/8] A/4 [G,3/8A11/8] c3/8 =G/4 C3/8\n[A2F,5/8] G3/8 C3/8 C,/4 B,3/8 A,5/8 C3/4 [E5/8G/4] A3/8 [c5/8A5/8]\n[C3/8A3/8] A3/8 [E/4A/4] [C3/8G3/8] [G,5/8B5/8G5/8] [G,3/8G3/8] G3/8\n[D/4A21/8] C3/8 [G5/8F,5/8] C3/8 G3/8 C,/4 B,3/8 A,5/8 C3/4 [E5/8z/4]\nB3/8 c3/8 [c5/8z/4] C3/8 [A3/8c5/8] E/4 [C3/8G3/8] [G,5/8B5/8G5/8]\n[G,3/8G3/8] [c3/8G3/8] [G/4A21/8] C3/8 [c5/8F,5/8] G3/4 C5/8 C,5/8\nC3/4 [c5/8G5/8] [E,5/8E5/8D5/8B5/8] [E,3/8B3/8] B3/8 [E5/8c5/8]\n[A,5/8A3/8B3/8] [A13/8z/4] C3/4 E5/8 [A2z5/8] E3/4 C5/8 A,5/8 C3/4\nE5/8 A5/8 E3/4 C,/4 B,3/8 [A,5/8c2A11/8] [C3/4z5/8] G/8 [E5/8A/4]\nA3/8 [c2A5/8] [C3/8A3/8] [Az3/8] E/4 C3/8 [BG,5/8d] [G,3/8c3/8]\n[cez3/8] G/4 [C3/8A3/8] [A29/8F,5/8c4] G3/8 C3/8 C,/4 B,3/8 A,5/8\nC3/4 [E5/8G/4] A3/8 [c2Az5/8] C3/8 A3/8 [E/4A5/8] [C3/8E3/8]\n[G,5/8BdG5/8] [G,3/8G3/8] [G3/8ecA3] D/4 C3/8 [G5/8F,5/8f2c2] C3/8\nG3/8 C,/4 B,3/8 [A,5/8c2A3] [C3/4d3/8] e3/8 [E5/8d5/8] [c2B5/8]\n[C3/8B3/4] A3/8 [E/4A5/8] C3/8 [G,5/8Bd] [G,3/8c3/8] [cez3/8] G/4\nC3/8 [c2F,5/8A2] G3/4 C5/8 [C,5/8c11/8E2] C3/4 [c5/8G5/8e5/8]\n[E,5/8E11/8D5/8B5/8d5/8] [E,3/8d3/8B3/8] [Bd3/8] [E2e5/8c5/8]\n[A,5/8A3/8d3/8B3/8] [c29/8A13/8z/4] C3/4 [E5/4z5/8] [A4z5/8]\n[E11/4z3/4] C5/8 A,5/8 C3/4 [E5/4z5/8] [A2z5/8] [E11/8z3/4] C,/4\nB,3/8 A,5/8 [C3/4c3/4A3/4] [E5/8C5/8A,5/8c5/8A5/8]\n[c5/8A,3/8C3/8A5/8] [D5/8B,5/8z/4] C3/8 [A3/8B,3/8D3/8c3/8]\n[E/4A,5/8C/4c5/8A5/8] C3/8 [B5/8G,5/8B,d5/8] [G,3/8e3/8c3/8]\n[c3/8A,A3/8] [G/4c21/8A5/8] C3/8 [A2F,5/8A,2] G3/8 C3/8 C,/4 B,3/8\nA,5/8 C3/4 [E5/8C5/8A,5/8a/4e/4] [e3/8c3/8] [c5/8A,3/8C3/8e3/8]\n[D5/8B,5/8f/4d/4] [C3/8f3/8d3/8] [AB,3/8D3/8d] [E/4C/4A,5/8] C3/8\n[G,5/8B5/8B,d5/8] [G,3/8e3/4c3/4] [G3/8G,] [D/4ec] C3/8\n[G5/8F,5/8G,2z3/8] [f13/8z/4] C3/8 G3/8 C,/4 B,3/8 A,5/8 C3/4\n[E5/8A,5/8C5/8d/4B/4] [e3/8c3/8] [c3/8C3/8A,3/8d3/8B3/8]\n[B,5/8D5/8e5/8c5/8z/4] C3/8 [A3/8D3/8B,3/8d5/8B5/8] [E/4A,5/8C/4]\n[C3/8c3/8A3/8] [G,5/8B5/8B,d5/8] [G,3/8e3/4c3/8] [c3/8C5/8]\n[G/4c5/8A21/8] C3/8 [c2F,2A,2z5/8] G3/4 C5/8 [C,5/8E,5/8G,5/8]\n[C3/4E,3/8] F,3/8 [c5/8G5/8E,5/8e5/8] [E,5/8E5/8D5/8B5/8d5/8]\n[E,3/8d3/8B3/8] [BF,3/8d] [E5/8E,5/8] [A,5/8A5/8d3/8B3/8] [d/4B/4]\n[C3/4A3/4e27/8c11/8] [E5/8B5/8] [A5/8c2] [E3/4B3/4] [C5/8A5/8]\n[A11/8F2C2A,2F,2c5/8] B3/4 A5/8 [F2^C2^G,2D,2d2] [BGD=G,]\n[G,3/8D3/8G3/8B3/8] [B/4G/4D/4G,/4d/4b/4] [B3/8G3/8D3/8G,3/8d3/8b3/8]\n[d/8b5/8c3/8G3/8D3/8G,3/8] z/4 [G,5/8D5/8G5/8B5/8z/4] [d3/8b3/8]\n[^c5/8G5/8D5/8G,5/8=c/2a/2] [d/2b/2z/8] [B3/8G3/8D3/8G,3/8]\n[A2F2=C2A,2F,2d3/8] [c29/8a29/8z13/8] [^F2D2A,2D,2] [BGDG,]\n[G,3/8D3/8G3/8B3/8] [B/4G/4D/4G,/4d/4b/4] [B3/8G3/8D3/8G,3/8d3/8b3/8]\n[d/8b5/8c3/8G3/8D3/8G,3/8] z/4 [G,5/8D5/8G5/8B5/8z/4] [d3/8b3/8]\n[^c5/8G5/8D5/8G,5/8=c/2a/2] [d/2b/2z/8] [B3/8G3/8D3/8G,3/8]\n[A2=F2C11/8A,F,5/8d3/8] [e/4c'/4] [F,11/8c3a3z3/8] [A,z3/8]\n[C5/4z5/8] [^F2D11/8A,D,5/8] [D,11/8z3/8] [A,z3/8] [D5/8z/4]\n[d3/8b3/8] [B5/8G5/8D5/8G,5/8d5/8b5/8] [G,3/8D3/8G3/8B3/8]\n[D3/8B3/8G3/8G,3/8d3/8b3/8] [G5/8B5/8D5/8G,5/8d5/8b5/8]\n[A,4A2e3/8E11/8C5/8E,4] [e17/4a29/8z/4] [C11/4z3/4] [E5/4z5/8]\n[A2z5/8] [E11/8z3/4] C5/8 A,5/8 [C3/4d3/4] [E5/8c5/8] [A5/8B5/8]\n[E3/4c3/4] [C5/8d5/8] [A,5/8A2] C3/4 [E5/8G5/8] [c5/8A] C3/8 A3/8\n[E/4A/4] [C3/8A3/8] [B5/8G,5/8z3/8] A/4 [G,3/8G3/8] [c3/8A] G/4 C3/8\n[A2F,5/8] G3/8 C3/8 C,/4 B,3/8 A,5/8 C3/4 [E5/8G/4] A3/8 [c5/8A5/8]\n[C3/8A3/8] A3/8 [E/4A/4] [C3/8G3/8] [G,5/8B5/8G5/8] [G,3/8A3/8]\n[G3/8^A3/8] [D/4c4] C3/8 [G5/8F,5/8] C3/8 G3/8 C,/4 B,3/8 A,5/8 C3/4\n[E5/8z/4] B3/8 c3/8 [c5/8z/4] C3/8 [=A3/8c5/8] E/4 [C3/8G3/8]\n[G,5/8B5/8G5/8] [G,3/8G3/8] [c3/8G3/8] [G5/4z/4] C3/8 [c5/8F,5/8]\n[G11/8z3/4] C5/8 C,5/8 C3/4 [c5/8G5/8e5/8] [E,5/8E5/8D5/8B5/8d5/8]\n[E,3/8d3/8B3/8] [B3/8d3/8] [E5/8e5/8c5/8] [A,5/8A3/8d3/8B3/8]\n[c29/8A13/8z/4] C3/4 E5/8 [A2z5/8] E3/4 C5/8 [A4=F4C4A,2F,4]\n[^F2D2A,2D,2] [BGDG,] [G,3/8D3/8G3/8B3/8] [B/4G/4D/4G,/4d/4b/4]\n[B3/8G3/8D3/8G,3/8d3/8b3/8] [d5/8b5/8c3/8G3/8D3/8G,3/8]\n[G,5/8D5/8G5/8B5/8z/4] [b3/8d3/8] [^c5/8G5/8D5/8G,5/8=c/2a/2]\n[b/2d/2z/8] [B3/8G3/8D3/8G,3/8] [A2=F2C2A,2F,2d3/8] [c29/8a29/8z13/8]\n[^F2D2A,2D,2] [BGDG,] [G,3/8D3/8G3/8B3/8] [B/4G/4D/4G,/4d/4b/4]\n[B3/8G3/8D3/8G,3/8d3/8b3/8] [d5/8b5/8c3/8G3/8D3/8G,3/8]\n[G,5/8D5/8G5/8B5/8z/4] [b3/8d3/8] [^c5/8G5/8D5/8G,5/8=c/2a/2]\n[b/2d/2z/8] [B3/8G3/8D3/8G,3/8] [A2=F2C11/8A,F,5/8d3/8] [e/4c'/4]\n[F,11/8c27/8a27/8z3/8] [A,z3/8] [C5/4z5/8] [^F2D11/8A,D,5/8]\n[D,11/8z3/8] [A,z3/8] D5/8 [B5/8G5/8D5/8G,5/8db5/8]\n[G,3/8D3/8G3/8B3/8] [D3/8B3/8G3/8G,3/8d3/8b3/8]\n[G5/8B5/8D5/8G,5/8d5/8b5/8] [A,4A2E11/8C5/8E,4d3/8] [e29/8a29/8z/4]\n[C11/4z3/4] [E5/4z5/8] [A2z5/8] [E11/8c11/8z3/4] C5/8 [A,5/8d11/8]\nC3/4 [E5/8e5/4] A5/8 [E3/4g11/8] C5/8 [a5/8c'5/8] [e11/8a11/8]\n[b2d5/8] [e11/8a11/8] [c'2e5/8] [e11/8a11/8] [d2f5/8] [e11/8a11/8]\n[f5/8a5/8] [A3/4f11/8] =F5/8 [f2z5/8] A3/4 F5/8 z5/8 F3/4 A5/8 f5/8\nA3/4 F5/8 [A5/8a5/8] [F3/4f3/4] [C5/4c21/8] A3/4 F5/8 [a5/8A5/8b5/8]\n[G3/4g3/4] [D5/4d21/8] A3/4 G5/8 [A3/8e3/8] [e/4a13/8] E3/4 C5/8\n[e3/8a3/8] [A/4e13/8] E3/4 C5/8 A,5/8 C3/4 E5/8 A2 [a5/8c'5/8]\n[e11/8a11/8] [b5/8d5/8] [e11/8a11/8] [c'5/8e5/8] [e11/8a11/8]\n[d5/8f5/8] [e11/8a11/8] [f5/8a5/8] [A3/4f11/8] F5/8 [f2z5/8] A3/4\nF5/8 z5/8 F3/4 A5/8 f5/8 A3/4 F5/8 [A5/8a5/8] [F3/4f3/4] [C5/4c21/8]\nA3/4 F5/8 A5/8 [G3/4c3/4] [D5/4c/4] d [A3/4c3/8] d3/8 [G5/8d5/8]\n[A3/8c3/8] [e13/8z/4] E3/4 C5/8 e3/8 [A13/8z/4] E3/4 C5/8 A,5/8\n[C3/4g3/4d3/8] z3/8 [E5/8d5/8g5/8] [A5/8g/4d/4] d/4 c/8 [E3/4A3/4]\n[C,/4G/8] A/8 [B,3/8c3/8] [A,5/8A11/8c2] [C3/4z3/8] G3/8 [E5/8A/4]\nA3/8 [c2A5/8] [C3/8A3/8] [Az3/8] E/4 C3/8 [BG,5/8d] [G,3/8c3/8]\n[cez3/8] [G/4A5/8] C3/8 [A27/8F,5/8c4] G3/8 C3/8 C,/4 B,3/8 A,5/8\nC3/4 [E5/8A/4] A3/8 [c2Az5/8] C3/8 A3/8 [E/4A5/8] [C3/8E3/8]\n[G,5/8BdG5/8] [G,3/8G3/8] [G3/8ecA] D/4 C3/8 [G5/8F,5/8f2c2]\n[C3/8z/8] [B5/4z/8] [A9/8z/8] G3/8 C,/4 B,3/8 [A,5/8c2A3] [C3/4d3/8]\ne3/8 [E5/8d5/8] [c2Bz5/8] C3/8 [A3/8B3/8] [E/4A5/8] C3/8 [G,5/8Bd]\n[G,3/8c3/8] [cez3/8] G/4 C3/8 [c2F,5/8A2] G3/4 C5/8 [C,5/8c11/8E2]\nC3/4 [c5/8G5/8d/4] e3/8 [E,5/8E11/8D5/8Bd5/8] [E,3/8d3/8] [Bdz3/8]\n[E2z5/8] [A,5/8A2d3/8] d/4 [C3/4e19/4] [E5/4z5/8] [A4z5/8]\n[E11/4z3/4] C5/8 A,5/8 C3/4 [E5/4z5/8] [A2z5/8] [E11/8z3/4] C,/4\nB,3/8 A,5/8 [C3/4c3/4] [E5/8C5/8A,5/8c5/8] [c5/8A,3/8C3/8]\n[D5/8B,5/8z/4] C3/8 [A3/8B,3/8D3/8c3/8] [E/4A,5/8C/4c5/8] C3/8\n[B5/8G,5/8B,d5/8] [G,3/8e3/8] [c3/8A,] [G/4c21/8] C3/8 [A5/8F,5/8A,2]\nG3/8 C3/8 C,/4 B,3/8 A,5/8 C3/4 [E5/8C5/8A,5/8a/4] a3/8\n[c5/8A,3/8C3/8g3/8] [D5/8B,5/8a/4] [C3/8e3/8] [A3/8B,3/8D3/8c3/8]\n[E/4C/4A,5/8c5/8] C3/8 [G,5/8B5/8B,d5/8] [G,3/8e3/4] [G3/8G,]\n[D/4e5/8] C3/8 [G5/8F,5/8G,2f2] C3/8 G3/8 C,/4 B,3/8 A,5/8 [C3/4z5/8]\nd/8 [E5/8A,5/8C5/8e/4] e3/8 [c5/8C3/8A,3/8d3/8] [B,5/8D5/8e5/8z/4]\nC3/8 [A3/8D3/8B,3/8d5/8] [E/4A,5/8C/4] [C3/8c3/8] [G,5/8B5/8B,d5/8]\n[G,3/8e3/4] [c3/8C5/8] [G/4c5/8] C3/8 [c2F,2A,2z5/8] G3/4 C5/8\n[C,5/8E,5/8G,5/8] [C3/4E,3/8] F,3/8 [c/4G5/8E,5/8e/4] c3/8\n[E,5/8E5/8D5/8B5/8d5/8] [E,3/8d3/8] [B3/8F,3/8d] [E5/8E,5/8]\n[A,5/8A5/8d3/8] d/4 [C3/4e43/8] E5/8 A5/8 E3/4 C5/8 [A4F4C4A,2F,4]\n[^F2D2A,2D,2] [BGDG,] [G,3/8D3/8G3/8B3/8] [B/4G/4D/4G,/4d/4b/4]\n[B3/8G3/8D3/8G,3/8b3/8d3/8] [d/8b/8c3/8G3/8D3/8G,3/8] z/4\n[G,5/8D5/8G5/8B5/8z/4] [b3/8d3/8] [^c5/8G5/8D5/8G,5/8=c/2a/2]\n[b/2d/2z/8] [B3/8G3/8D3/8G,3/8] [A2=F2C2A,2F,2d3/8] [c3a3z13/8]\n[^F2D2A,2D,2] [BGDG,] [G,3/8D3/8G3/8B3/8] [B/4G/4D/4G,/4d/4b/4]\n[B3/8G3/8D3/8G,3/8b3/8d3/8] [d/8b/8c3/8G3/8D3/8G,3/8] z/4\n[G,5/8D5/8G5/8B5/8z/4] [b3/8d3/8] [^c5/8G5/8D5/8G,5/8=c/2a/2]\n[b/2d/2z/8] [B3/8G3/8D3/8G,3/8] [A2=F2C2A,2F,2d3/8] [e/4c'/4]\n[c27/8a27/8z11/8] [^F2D2A,2D,2] [BGDG,] [G,3/8D3/8G3/8B3/8]\n[B/4G/4D/4G,/4d/4b/4] [B3/8G3/8D3/8G,3/8b3/8d3/8]\n[d/8b/8c3/8G3/8D3/8G,3/8] z/4 [G,5/8D5/8G5/8B5/8z/4] [a3/8c3/8]\n[^c5/8G5/8D5/8G,5/8g/2B/2] [b/2d/2z/8] [B3/8G3/8D3/8G,3/8]\n[A2=F2C2A,2F,2d3/8] [=c29/8a29/8z13/8] [^F2D2A,2D,2] [BGDG,]\n[G,3/8D3/8G3/8B3/8] [B/4G/4D/4G,/4d/4b/4] [B3/8G3/8D3/8G,3/8b3/8d3/8]\n[d/8b/8c3/8G3/8D3/8G,3/8] z/4 [G,5/8D5/8G5/8B5/8z/4] [b3/8d3/8]\n[^c5/8G5/8D5/8G,5/8=c/2a/2] [b/2d/2z/8] [B3/8G3/8D3/8G,3/8]\n[A2=F2C11/8A,F,5/8d3/8] [e/4c'/4] [F,11/8c27/8a27/8z3/8] [A,z3/8]\n[C5/4z5/8] [^F2D11/8A,D,5/8] [D,11/8z3/8] [A,z3/8] D5/8\n[B5/8G5/8D5/8G,5/8db5/8] [G,3/8D3/8G3/8B3/8]\n[D3/8B3/8G3/8G,3/8b3/8d3/8] [G5/8B5/8D5/8G,5/8b5/8d5/8]\n[A,4A2E11/8C5/8E,4d3/8] [e5c'45/8z/4] [C11/4z3/4] [E5/4z5/8]\n[A2B2z5/8] [E11/8z3/4] C5/8 [A,3/8c2] A,/4 [C3/4A,3/8] A,3/8\n[E5/8A,/4] A,3/8 [A5/8E,5/8A,5/8d2c'/4] c'/8 [c'13/8z/4]\n[E3/4A,3/4E,3/4] [C5/8A,5/8E,5/8] [E,11/8A,11/8g11/8d11/8] [E,/4d5/8]\nA,3/8 [E11/8A,11/8c11/8] [A,5/8E5/8d/4] c3/8 [D11/8G,11/8B3/8] c/4\nB3/8 A3/8 [G,5/8D5/8B/4] G3/8 [C11/8F,11/8A] c3/8 [C,/4d/4]\n[B,3/8c3/8] [E,11/8A,11/8d3/8] e/4 a3/8 d3/8 [E,/4e/4] [A,3/8a3/8]\n[E11/8A,11/8g3/8] e/4 ^d3/8 e3/8 [A,5/8E5/8^d/4] =d3/8\n[D11/8G,11/8c7/8] A/8 [^f3/8d3/8] [G,5/8D5/8z/4] [^f3/8d3/8]\n[C11/8F,11/8=f3/8^c3/8] [=c13/8z] C,/4 B,3/8 [E,11/8A,11/8c'5/8] b3/4\n[E,/4e5/8] A,3/8 [E11/8A,11/8c'5/8] b/2 c'/4 [A,5/8E5/8d/2] d/8\n[D11/8G,11/8c'3/8] b/8 [c'/8b/8] a3/8 e3/8 [G,5/8D5/8c'/4] b3/8\n[C11/8F,11/8e] c3/8 [C,/4d/4] [B,3/8c3/8] [G,2C,2g/2d/2] c/8 A3/8\nc3/8 d/4 e3/8 [B,2E,2a5/8] g3/8 g7/8 e/8 [A,4E,49/4g8z5/8] C3/4 E5/8\nA5/8 E3/4 C5/8 [A,4z5/8] C3/4 E5/8 A5/8 E3/4 C5/8 [A,4e3/8] g/4\n[C3/4e11/4] E5/8 A5/8 E3/4 [C5/8B5/8] [A,4A3/8z/4] [E,15/4z/8] B/4\n[C3/4A11/8] E5/8 [A4z5/8] E3/4 C5/8 A,5/8 C3/4 [E5/8G5/8] [c5/8A]\nC3/8 A3/8 [E/4A/4] [C3/8A3/8] [BG,5/8z3/8] A/4 [G,3/8G3/8] [cAz3/8]\nG/4 C3/8 [A29/8F,5/8] G3/8 C3/8 C,/4 B,3/8 A,5/8 C3/4 [E5/8G/4] A3/8\n[c5/8A5/8] [C3/8A3/8] A3/8 [E/4A5/8] [C3/8G3/8] [G,5/8BG5/8]\n[G,3/8G3/8] [G3/8c] [D/4A/4] [C3/8B3/8] [GF,5/8c/8] B/4 [A13/8z/4]\nC3/8 [G5z3/8] C,/4 B,3/8 A,5/8 C3/4 [E5/8z/4] B3/8 c3/8 [c5/8z/4]\nC3/8 [A5/8z3/8] E/4 [C3/8E3/8] [G,5/8BG5/8] [G,3/8G3/8] [cG3/8]\n[G5/4z/4] C3/8 [c5/8F,5/8e49/4] G3/4 C5/8 C,5/8 C3/4 [c5/8G5/8]\n[E,DEB5/8] B3/8 [E,EDBz3/8] c5/8 [A,5/8=F5/8B3/8] [A13/8z/4] C3/4\nE5/8 [A2z5/8] E3/4 C5/8 A,5/8 C3/4 E5/8 [A5/8z/4] [e9/8z3/8] E3/4\ne5/8 [A,5/8e5/8] E3/4 C5/8 e3/8 A/4 E3/4 C5/8 A,5/8 C3/4 [e5/8E5/8]\n[E5/8f5/8] e/2 f/8 e/8 d/4 [E3/4e3/4] d/4 c3/8 A5/8 [A,3/4A3/4] C5/8\nE5/8 A3/4 E5/8 C5/8 A,3/4 C5/8 E5/8 A3/4 E5/8 e5/8 [A,3/4e3/4] E5/8\nC5/8 e3/8 A3/8 E5/8 C5/8 A,3/4 C5/8 [e5/8E5/8] [E3/4f3/4] e3/8 f/8\ne/8 d3/8 [E5/8e5/8] d3/8 c/4 A3/4 [A,5/8A5/8] C5/8 E3/4 A5/8 E5/8\nC3/4 A,5/8 C5/8 E3/4 A5/8 E5/8 e3/4 [A,5/8e5/8] E5/8 C3/4 e/4 A3/8\nE5/8 C3/4 A,5/8 C5/8 [e3/4E3/4] [E5/8f5/8] e/2 [f/8e/8] d3/8\n[E5/8e5/8] d3/8 c3/8 A5/8 [A,5/8A5/8] C3/4 E5/8 A5/8 E3/4 C5/8 A,5/8\nC3/4 E5/8 A5/8 E3/4 e5/8 	0	1	200	f	\N
6	2015-05-25 12:20:12.032805	2015-06-06 16:32:27.452936	7	0	Y Combinator	2	NULL	http://farm6.static.flickr.com/5217/5475205694_0893571d52_XXXX.jpg	\N	\N	\N	f	f	2	3	90	0	NULL	0	t	\N	Richard Marx - Right Here Waiting	X: 1\nT: richardmarx rightherewaiting (3:58)\nZ: Transcribed by LotRO MIDI Player: http://lotro.acasylum.com/midi\n%  Original file: richardmarx_rightherewaiting.mid\n%  Transpose: -4\nL: 1/4\nQ: 120\nK: C\n\n[^G21/4z5/8] [^d11/8z5/8] [^g4z3/4] ^d5/8 [^d21/8z3/4] [^c5/4z5/8]\n[c'5/4z3/4] [^a5/2z5/8] [^D41/8z5/8] [^A9/2z3/4] [^d15/4z/2] ^a3/8\nz3/8 [^a9/8z5/8] [c'9/8z5/8] [^c5/4z3/4] [c'2z5/8] [F21/4z3/4]\n[=c37/8z/2] [f4z3/4] ^g11/8 [^a11/8z5/4] [c'3/2z5/8] [^C31/8z3/4]\n[^a11/8z5/8] [^G21/8z3/4] ^g5/4 [=g3/4z5/8] [f3/4^D,5/4z/8] ^D/2 z/8\n[^d9/4z/2] ^G,/8 [^G,19/4z5/8] [^D4z3/4] [^G25/8z5/8] ^d3/8 z3/8\n[^d3/4z5/8] ^c3/4 [=c5/8z/2] [C,5/8z/8] [^A9/4z/2] ^D,/4 [^D,35/8z/2]\n[^A,13/4z3/4] [^D13/4z/2] ^A/2 z/8 [^A5/4z3/4] [cz5/8] [^cz5/8]\n[C,3/4z/8] [=c19/8z5/8] [F,21/4z3/4] [=C9/2z5/8] [F31/8z5/8]\n[^G19/8z3/2] [^A11/8z/2] [^D,11/8z/8] [c9/8z3/4] [^c5/4z/2] ^C,/8\n[^C,31/8z5/8] [=c11/8z5/8] [^G,5/2z5/8] ^A11/8 [^G3/4z5/8]\n[^D,11/8z/8] =G5/8 [^G3/4z/2] F,/8 [F,21/4z5/8] [C23/8z3/4]\n[F27/8z5/8] [c39/8=G11/8z5/4] [^G29/8z11/8] [C3/4z5/8] [F,43/8z3/4]\n[C37/8z5/8] [F4z3/4] [c13/4=G25/8z11/8] ^G7/4 z/8 ^G,/8 [^G,37/8z/2]\n[^D19/4z3/4] [^G4z5/8] [^d27/8^A27/8z21/8] =C,/8 [C,3/4z/2] ^C,/8\n[^C,19/4z5/8] [^D39/8z3/4] [^G17/4z5/8] [^d29/8^A29/8z21/8] =C,/8\n[C,5/8z/2] ^A,/8 [^A,37/8z5/8] [F35/8z5/8] [^G7/2z5/8]\n[^A23/8^d23/8z11/4] ^C,5/8 [^D,33/8z5/8] [^D7/8z5/8] [F7/8^A9/4z3/4]\n[=G25/8z11/8] [^G3/4z5/8] [^A13/8z/8] ^D,5/4 [^G,37/8z5/8]\n[^D19/4z5/8] [^G4z3/4] [^d13/4^A13/4z21/8] =C,5/8 [^C,19/4z5/8]\n[^D5z3/4] [^G17/4z5/8] [^A29/8^d29/8z11/4] =C,5/8 [^A,37/8z5/8]\n[F19/4z5/8] [^G31/8z3/4] [^A25/8^d25/8z21/8] ^G,5/8 [=G,21/4z5/8]\n[^D3/4z5/8] [^A9/4F7/8z3/4] [=G9/4z3/2] [^G3/4z5/8] [^A3/2z5/4] F,/8\n[F,21/4z3/4] [C9/2z5/8] [F5/2z5/8] [=G11/8c25/8z5/4] ^G15/8 ^A,/8\n[^A,7/2F17/4^G35/8^C17/4] ^A,/2 [^G,3/4z5/8] [=G,3/4z5/8] F,/8\n[F,37/8z/2] [=C31/8z3/4] [F5/2z3/4] [c25/8=G11/8z5/4] [^G15/8z11/8]\n^G,/2 z/8 [F17/4^A,3/2^C33/8^G17/4] z/2 ^D,/8 ^D,3/4 z/2 ^D,5/8\n^D,3/4 ^D,/2 z/8 ^G,/8 [^G,19/4z5/8] [^D4z5/8] [^G13/4z5/8] ^d3/8 z/4\n^d3/4 ^c5/8 [=c3/4z5/8] [C,5/8^A9/4] ^D,/8 [^D,37/8z5/8]\n[^A,29/8z3/4] [^D7/2z5/8] ^A3/8 z/4 ^A5/8 c3/4 [^c3/4z/2] [C,3/4z/8]\n[=c13/8z5/8] [F,37/8z3/4] [=C15/4z/2] [F25/8z3/4] ^G3/2 [^A5/4z9/8]\n[^D,5/8z/8] [c11/8z/2] ^C,/8 [^C,4z3/4] [^A11/8z/2] [^G,11/4z3/4]\n[^G11/8z5/4] =G3/4 [^D,11/8F3/4z5/8] [^D7/8z5/8] ^G,/8 ^G,5/8\n[^D15/4^G,4z5/8] [^G3z3/4] ^d3/8 z/4 ^d5/8 [^c3/4z5/8] [=c3/4z5/8]\n[=C,5/8z/8] [^A9/4z5/8] ^D,/8 [^D,9/2z5/8] [^A,29/8z5/8] [^D7/2z3/4]\n^A/4 z3/8 ^A5/8 [c3/4z5/8] [^c3/4z5/8] [C,3/4z/8] [=c17/8z5/8]\n[F,9/2z5/8] [C7/2z3/4] [F11/4z5/8] ^G11/8 [^A3/4z5/8] [c7/8z5/8]\n[^D,3/4z/8] [^c3/2z5/8] [^C,4z5/8] [=c3/2z3/4] [^G,21/8z5/8] ^A11/8\n[^G3/4z5/8] [^D,11/8=G3/4z5/8] [^G7/8z5/8] F,/8 [F,5=G,/8] z/2\n[C13/4z5/8] [F27/8z5/8] [=G3/2c5] [^G27/8z5/4] [C3/4z5/8]\n[F,43/8z3/4] [C9/2z5/8] [F15/4z5/8] [c13/4=G3/2z11/8] ^G15/8 z/8\n^G,5/8 [^D19/4^G,33/8z5/8] [^G33/8z3/4] [^d27/8^A13/4z21/8]\n[=C,3/4z5/8] ^C,/8 [^C,37/8z5/8] [^D39/8z5/8] [^G35/8z3/4]\n[^d29/8^A7/2z21/8] =C,5/8 [^A,19/4z3/4] [F35/8z5/8] [^G7/2z5/8]\n[^A23/8^d11/4z21/8] ^C,/8 [^C,5/8z/2] ^D,/8 [^D,43/8z5/8] [^D3/4z5/8]\n[F3/4^A17/8] [=G2z11/8] [^G3/4z5/8] [^A3/2z5/4] ^G,/8 ^G,5/8\n[^G,4^D37/8z5/8] [^G4z3/4] [^d13/4^A13/4z5/2] =C,/8 C,5/8\n[^C,19/4z5/8] [^D5z5/8] [^G17/4z3/4] [^A7/2^d29/8z21/8] [=C,3/4z5/8]\n^A,/8 [^A,37/8z5/8] [F19/4z5/8] [^G31/8z3/4] [^A25/8^d3z5/2]\n[^G,3/4z5/8] =G,/8 [G,21/4z5/8] [^D3/4z5/8] [^A17/8F7/8z3/4]\n[=G17/8z11/8] [^G7/8z3/4] [^A3/2z5/4] F,/8 [F,41/8z3/4] [C17/4z/2]\n[F31/8z3/4] [=G5/4c25/8] [^G15/8z11/8] ^G,3/8 z/8 ^A,/8\n[^A,4F17/4^G35/8^C17/4] ^G,5/8 [=G,3/4z5/8] [F,21/4z5/8] [=C9/2z3/4]\n[F5/2z3/4] [c13/4=G11/8z5/4] [^G7/4z5/4] ^G,5/8\n[F17/4^A,17/8^C17/4^G35/8] ^D, z3/8 ^D,3/4 ^D,5/8 ^D,5/8\n[^G,19/4z5/8] [^D4z5/8] [^G27/8z3/4] ^d3/8 z/4 ^d3/4 ^c5/8 =c5/8\n[^A9/4z/8] ^G,5/8 ^D,/8 [^D,17/4z/2] [^A,29/8z5/8] [^D7/2z3/4] ^A/4\nz3/8 ^A5/8 c5/8 [^c7/8z5/8] [C,3/4z/8] [=c3/2z5/8] [F,19/4z5/8]\n[=C15/4z5/8] [F25/8z5/8] [^G13/8z3/2] [^A11/8z5/4] [c3/2z/8] ^D,/2\n^C,/8 [^C,4z5/8] [^A11/8z5/8] [^G,21/8z3/4] ^G5/4 [=G3/4z5/8]\n[^D,5/4F3/4] ^D/2 z/8 ^G,5/8 [^G,4z/8] [^D29/8z5/8] [^G23/8z5/8]\n^d3/8 z3/8 ^d5/8 ^c5/8 =c5/8 [^C,5/8^A19/8] ^D,/8 [^D,37/8z3/4]\n[^A,7/2z5/8] [^D7/2z5/8] ^A3/8 z/4 ^A3/4 c5/8 [^c3/4z5/8]\n[=C,3/4=c17/8z5/8] F,/8 [F,37/8z5/8] [C7/2z5/8] [F23/8z3/4] ^G11/8\n[^A3/4z5/8] [c7/8z5/8] [^D,5/8z/8] [^c11/8z/2] [^C,33/8z3/4]\n[=c11/8z5/8] [^G,21/8z3/4] ^A11/8 ^G5/8 [^D,9/8=G3/4z5/8] [^G3/4z5/8]\n^A,/8 [^C13/8^G3/2^A,15/8F13/8] z3/8 [F11/4^C11/4^G11/4^A,5/4]\n[^A,7/8z5/8] ^d5/8 ^A,5/8 [=C,11/4^G3/2^D13/8=C13/8] z3/8\n[^G,17/8z/8] [C3/2^D3/2^G3/2z11/8] C,5/8 [C,5/8^DC3/4^G7/8z/2]\n[^G,5/8z/4] [C,/2z3/8] ^C,/4 [^C,2F7/4^C13/8z/8] ^G3/2 z3/8\n[^C,3/2z/8] [F3/2^C3/2^G3/2z11/8] [^C,7/8z5/8] [F^G9/8^C7/8z5/8]\n^C,5/8 ^D,/8 [^D,9/2z5/4] [^g5/4z9/8] [=g7/4z3/2] ^d3/8 z/4\n[^D,3/4z5/8] ^A,/8 [F2^C15/8^G15/8^A,15/8] [^A,7/4z/4] [F3z/8]\n[^C23/8^G11/4z11/8] [^A,3/4z/2] [^d7/8z5/8] ^A,/8 ^A,/2 =C,/8\n[C,7/4^D3/2^G3/2=C13/8] z/4 [C,3/2z/8] [^D13/8z/8] [^G3/2C3/2z5/4]\n[^G,5/8C,5/8] [C,3/4z/8] [^G3/4C5/8^D7/8z/2] [^G,3/4z/8] C,/2 ^C,/8\n[F5/4^C,2^C11/8^G11/8] z5/8 [F3/2^C3/2^G3/2z/8] ^C,11/8 ^C,/2\n[^C,/2z/8] [F27/4^C27/4^G27/4z/2] ^C,5/8 ^D,/4 ^D,3/4 ^D,5/8 ^D,3/4\n[^D,5/8z/2] F,/8 F,3/8 F,3/8 [F,/2z/4] =G,/4 G,/2 G,/4 G,/2\n[^G,39/8z2] [c'/2z/8] ^d/2 z/8 [^d7/8c'7/8z5/8] [^a7/8^c7/8z5/8]\n[^g7/8c'z5/8] [^a21/8=g11/4z/8] ^D,3/8 z/4 [^D,19/4z17/8] [^a3/8g3/8]\nz/4 [g7/8^a7/8z3/4] [^g7/8c'3/4z5/8] [^c3/4^a3/4z/2] [=C,3/4z/8]\n[c'9/4^g5/2z5/8] [F,11/2z11/8] f/2 z/8 [f3/2^g3/2z11/8]\n[=g11/8^a11/8z5/4] [c'3/2^g3/2z3/4] [^C,31/8z3/4] [^a11/8=g5/4]\n[^g3/2f5/4] z/8 [=g3/4z/2] [^D,3/2z/8] [f3/4z5/8] [^d9/4z3/4] ^G,/2\n[^G,33/8z3/2] [c'/4^d/4] z3/8 [^d5/8c'5/8] [^a5/8^c5/8]\n[^g3/4c'3/4z5/8] [^a5/2^C,3/4] [^D,19/4z2] [=g3/8^a/2] z/4\n[g5/8^a3/4] [^g3/8c'/2] z/4 [c'3/8^g3/8] [^c/4^a3/8] [c'17/8z/8]\n[^g15/8=C,3/4] [F,19/4z11/8] [^g5/8f/2] z/8 [=g9/8^a11/8] z/4\n[^g9/8c'7/8] z3/8 [^D,3/4f5/4^c11/8] [^C,21/8z5/8] [c'11/8^d11/8]\n[^c5/4^az5/8] [^D,21/8z5/8] [c'3/4^g3/8] z/4 [^a/2=g/2] z/8 ^g3/4\n[F,19/4z3/4] [=C15/4z5/8] [F5/2z5/8] [=G11/8=c13/4] [^G15/8z9/8]\n^G,5/8 ^A,/8 [^A,4z/8] [F17/4^G35/8^C33/8z4] [^G,5/8z/2] =G,/8\n[G,5/8z/2] F,/8 [F,37/8z5/8] [=C15/4z5/8] [F21/8z3/4] [c25/8=G11/8]\n[^G7/4z5/4] ^G,/2 ^A,/8 [F17/4^C17/4^A,2^G17/4] z/8 ^D,9/8 z/8 ^D,/8\n^D,5/8 ^D,5/8 ^D,5/8 ^G,/8 [^G,19/4z5/8] [^D4z5/8] [^G27/8z3/4] ^d3/8\nz/4 [^d3/4z5/8] [^c3/4z5/8] [=c3/4z5/8] [=C,3/4z/8] [^A9/4z5/8]\n[^D,19/4z3/4] [^A,29/8z5/8] [^D7/2z5/8] ^A3/8 z3/8 ^A5/8 c5/8\n[^c3/4z5/8] [C,3/4z/8] [=c3/2z5/8] [F,37/8z5/8] [=C15/4z5/8]\n[F25/8z5/8] ^G3/2 [^A11/8z5/4] [c11/8^D,5/8] [^C,4z3/4] [^A11/8z5/8]\n[^G,21/8z5/8] ^G11/8 =G5/8 [^D,5/4F3/4z5/8] ^D3/8 z/4 ^G,/8 ^G,5/8\n[^G,4^D15/4z3/4] [^G23/8z5/8] ^d3/8 z/4 [^d3/4z5/8] ^c3/4 =c5/8\n[^C,5/8^A9/4] ^D,/8 [^D,37/8z3/4] [^A,7/2z/2] [^D29/8z3/4] ^A3/8 z/4\n[^A3/4z5/8] [c3/4z5/8] [^c7/8z5/8] [=C,3/4z/8] [=c17/8z5/8]\n[F,17/4z5/8] [C7/2z3/4] [F11/4z5/8] [^G3/2z11/8] [^A3/4z5/8]\n[^D,11/8z/8] [c3/4z5/8] [^c3/2z5/8] [^C,33/8z3/4] [=c11/8z5/8]\n[^G,21/8z3/4] [^A11/8z5/4] [^G3/4z5/8] ^D,/8 [^D,9/8=G5/8] ^G5/8\n[^G37/8z5/8] [^d11/8z3/4] [^g3z5/8] ^d3/4 [^d13/8z5/8] ^c3/4 c'5/8\n[^a9/4z5/8] [^D17/4z3/4] [^A7/2z5/8] [^d7/2z5/8] ^a3/8 z/4 ^a5/8\n[c'3/4z5/8] ^c3/4 [c'7/4z5/8] [F35/8z3/4] [=c7/2z5/8] [f23/8z5/8]\n[^g3/2z11/8] [^a11/8z5/4] [c'3/2z3/4] [^C15/4z5/8] [^a11/8z5/8]\n[^G21/8z3/4] [^g11/8z5/4] =g3/4 [f5/8^D,5/4^D/2] z/8 [^d9/4z5/8]\n^G,3/4 [^G,4^D31/8z5/8] [^G13/4z5/8] ^d/2 z/4 ^d3/4 ^c5/8 [=c3/4z5/8]\n[^C,5/8^A9/4] ^D,/8 [^D,31/8z5/8] [^A,25/8z5/8] [^D13/4z5/8] ^A3/8\nz/4 [^A3/4z5/8] [c3/4z5/8] [=C,13/8z/8] ^c3/4 [=c17/8z5/8]\n[F,39/8z5/8] [=C7/2z5/8] [F23/8z3/4] [^G3/2z11/8] ^A3/4 c5/8\n[^c11/8^D,5/8] [^C,31/8z5/8] [=c11/8z3/4] [^G,5/2z5/8] ^A5/4\n[^G7/8z5/8] ^D,/8 [^D,5/4=G3/4z5/8] [^G27/4z5/8] ^G,51/8 	0	0	203	f	\N
7	2015-05-25 12:43:40.674051	2015-06-08 07:53:00.475176	12	2	Firefox	1	NULL	http://farm3.static.flickr.com/2586/4064851076_394f588099_XXXX.jpg	\N	\N	\N	f	f	6	9	40	0	NULL	0	t	\N	Michael Jackson - Smooth Criminal	X: 1\nT: SmoothCriminal (3:27)\nZ: Transcribed by LotRO MIDI Player: http://lotro.acasylum.com/midi\n%  Original file: SmoothCriminal.mid\n%  Transpose: -2\nL: 1/4\nQ: 116\nK: C\n\nz9/2 G/8 z3/8 G/8 z/8 G/8 z/8 F/4 G/4 A/2 A/4 z3/4 G/4 A/4 ^A/2 ^A/4\nz3/4 =A/4 ^A/4 =A/4 A/8 z/8 F3/4 z/4 G/4 z3/4 G/8 z3/8 G/8 z/8 G/4\nF/4 G/4 A/2 A/4 z3/4 G/4 A/4 ^A/2 ^A/4 z3/4 =A/4 ^A/4 =A/4 A/8 z/8\nF7/8 z/8 G/4 z3/4 G/4 z/4 G/8 z/8 G/8 z/8 F/4 G/4 A/2 A/4 z3/4 G/4\nA/4 ^A/2 ^A/4 z3/4 =A/4 ^A/4 =A3/8 z/8 F G/4 z3/4 G/4 z/4 G/8 z/8 G/8\nz/8 F/4 G/4 A/2 A/4 z3/4 G/4 A/4 ^A/2 ^A/4 z3/4 =A/4 ^A/4 =A/2 F G/4\nz3/4 G/8 z/8 G/8 z/8 G/8 z/8 G/8 z/8 F/4 G/4 A3/8 z/8 A/4 z/2 G/8 z/8\nG/8 z/8 A/8 z/8 ^A3/8 z/8 ^A/4 z3/4 =A/8 z/8 [^A3/8z/4] =A/2 F3/8\nz13/8 G/8 z/8 G/8 z/8 G/8 z/8 G/8 z/8 F/4 G/4 A3/8 z/8 A/4 z/2 G/8\nz/8 G/4 A/8 z/8 ^A/4 z/4 ^A/4 z3/4 =A/4 ^A/4 =A/2 F3/8 z13/8 G/8 z/8\nG/8 z/8 G/8 z/8 G/8 z/8 F/4 [G3/8z/4] A3/8 z/8 A/4 z3/4 G/4 A/4 ^A3/8\nz/8 ^A/4 z3/4 =A/4 [^A3/8z/4] =A/2 F/4 z7/4 G/8 z/8 G/8 z/8 G/8 z/8\nG/8 z/8 F/4 G/4 A/4 z/4 A/4 z3/4 G/4 A/4 ^A/4 z/4 ^A/4 z3/4 =A/4\n[^A3/8z/4] =A3/8 z/8 F3/8 z5/8 [^A,51/8G/2^D51/8] G/4 G/4 [Gz/4] d/4\nc3/8 z/8 G G/2 [G/4G,/8] z/8 [G/4G,/8] z/8 [GF,/8] z/8 [d/4F,/8] z/8\n[c3/8G,/8] z3/8 [GF,/8] z/8 G,/8 z3/8 F,/4 [G/4G,/8] z/8 G/8 z/8\n[A3/2F/2C11/8] F/2 [F/2z/4] G/8 z/8 [^D51/8^A,25/4G/2] G/4 G/4 [Gz/4]\nd/4 c3/8 z/8 G G/2 [G/4G,/8] z/8 [G/4G,/8] z/8 [GF,/8] z/8 [d/4F,/8]\nz/8 [c/2G,/8] z3/8 [GF,/8] z/8 G,/8 z3/8 F,/8 z/8 [G,/8G/4] z/8\n[G/8G,/8] z/8 [f13/8=A,/8A5/4F/2C11/8] z3/8 F/2 [F/2z/4] A/4\n[^d13/2^D25/4^A,25/4G/2] G/4 G/4 [Gz/4] =d/4 c/2 G G/2 [G,/8G/4] z/8\n[G/4G,/8] z/8 [GF,/8] z/8 [d/4F,/8] z/8 [G,/4c/2] z/4 [GF,/8] z/8\nG,/8 z3/8 F,/8 z/8 [G/4G,/8] z/8 G/4 [f7/4A11/8F/2C11/8] F/2 [F/2z/4]\nG/4 [^d9/2^D9/2^A,9/2G/2] G/4 G/4 [Gz/4] =d/4 c/2 [G5/2z] d/8 z3/8\n[G,/8d/8] z/8 [G,/8d/8] z/8 [G,/8d/8] z/8 [G,/8d/4] z/8\n[^F,/8d/2^F7/2=A,3/4=D7/2f/2] z3/8 [d5/4^F,/8] z/8 [A,3/4z/2] ^F,/4\n[A,2^d/4] [=d3/4z/4] f/2 [dz/2] f/2 [^a3/2g19/8d3/2^A,5/2^A5/2]\n[^a/4d/4] [^a/4d/4] [^a/4d/4] [^a3/8d/4] [=a7/4=A,17/8=A/2c7/4f/2]\n[A3/2f3/2z] [g/4^A/8] z/8 [a3/8c3/8z/4] [G,2G/2g3/2^A3/2^d/2]\n[G13/8^d11/8z] [^A/4g/4] [^A/4g3/8] [A,13/8a13/8=A3/2f3/2c3/2z/2]\n[=d/4=F/4] z3/4 [^a^A,5/2^A5/2g9/4d] [^a/4d/4] [^a/4d/4] [^a/2d/2]\n[^a/4d/4] [^a/4d/4] [=a17/8=A,17/8=A/2c7/4f/2] [f3/2A13/8z]\n[^A/4^a/4] [c3/8c'3/8z/4] [G,17/8G/2g3/2^A3/2^d/2] [^d5/4G3/2z]\n[^A/4g/4] [g/4^A/8] z/8 [^F,13/8^f/2^F13/8=A/2=d] [^f9/8Az/2]\n[=a/2d/2] [^ad^A,5/2^A5/2g5/2] [^a/4d/4] [^a/4d/4] [^a/4d/4]\n[^a/4d/4] [^a/4d/4] [^a/4d/4] [=A,17/8=A/2=a7/4c7/4=f/2]\n[f3/2A3/2z3/4] [g/8^A/8] z/8 [g/8^A/8] z/8 [a/4^A/8c/4] z/8\n[g3/2G,2G/2^A3/2^d/2] [^d3/2G13/8z] [g/4^A/4] [^A/8g3/8] z/8\n[a3/2A,13/8c3/2=A/2f/2] [fA9/8] [^a^A5/2^A,5/2g5/2=d] [^a/4d/4]\n[^a/4d/4] [d/4^a/4] [d/4^a/4] [d/4^a/4] [^a/4d/4]\n[=a7/4=A,17/8=A/2c7/4f/2] [f3/2A13/8z] [^A/8g/4] z/8 [a3/8c3/8z/4]\n[G,17/8G/2g3/2^A3/2^d/2] [^d11/8G13/8z] [g/4^A/4] [g/4^A/4]\n[^f/2a5/8^F,13/8=d3/2=A/2^F13/8] [^f9/8A] [^A51/8^d13/2G/2g13/2] G/4\nG/4 [Gz/4] =d/4 c/2 G G/2 [G,/8G/4] z/8 [G/4G,/8] z/8 [G=F,/8] z/8\n[d3/8F,/8] z/8 [c/2G,/8] z3/8 [GF,/8] z/8 G,/8 z3/8 F,/8 z/8\n[G,/8G/4] z/8 [G,/8G3/8] z/8 [a3/2A,/4=A11/8=f3/2c11/8] z/4 =F/8 z3/8\nF/4 G/8 z/8 [g13/2G/2^A13/2^d13/2] G/4 G/4 [Gz/4] =d/4 c/2 G G/2\n[G,/8G/4] z/8 [G,/8G/4] z/8 [GF,/8] z/8 [F,/8d/4] z/8 [c/2G,/8] z3/8\n[F,/8G] z/8 G,/8 z3/8 F,/8 z/8 [G/4G,/8] z/8 [G/4G,/8] z/8\n[a13/8A,/8=A11/8c11/8f11/8] z3/8 F/4 z/4 F/4 G/4\n[g53/8^d13/2G/2^A13/2] G/4 G/4 [Gz/4] =d/4 c/2 G G/2 [G/4G,/8] z/8\n[G,/8G/4] z/8 [GF,/8] z/8 [d/4F,/8] z/8 [c/2G,/8] z3/8 [GF,/8] z/8\nG,/8 z3/8 F,/8 z/8 [G/4G,/8] z/8 [G/4G,/8] z/8\n[=A3/2a13/8A,/8c3/2f3/2] z3/8 F/4 z/4 F/4 G/4 [g5/8G/2^A/2^d/2]\n[^f3/8=d/2^F/4=A/4] z/4 ^A3/8 z/8 c3/8 z/8 c3/8 z9/8 d/2 ^A/4 z/4\nc3/8 z/8 c/4 z3/4 ^A/4 z/4 d3/8 z5/8 c/4 ^A/4 G/4 z123/8 z11/8 G/8\nz/8 G/8 z/8 G/8 z/8 G/8 z/8 =F/8 z/8 F/8 z/8 =A3/8 z/8 A/8 z7/8 G/4\nA/8 z/8 ^A/4 z/4 ^A/4 z3/4 =A/4 ^A/4 =A/2 F3/8 z13/8 G/8 z/8 G/8 z/8\nG/8 z/8 G/8 z/8 F/8 z/8 G/8 z/8 A/4 z/4 A/4 z3/4 G/4 A/8 z/8 ^A/4 z/4\n^A/8 z5/8 ^A/4 =A/4 ^A/4 c3/8 z/8 F/4 z3/4 [^A,51/8G/2^D51/8] G/4 G/4\n[Gz/4] [d3/8z/4] c/2 G G/2 [G,/8G/4] z/8 [G,/8G/4] z/8 [GF,/8] z/8\n[d3/8F,/8] z/8 [c/2G,/8] z3/8 [GF,/8] z/8 G,/8 z3/8 F,/4 [G/4G,/8]\nz/8 G/4 [=A3/2F/2C11/8] F/2 [F/2z/4] G/4 [^D51/8^A,25/4G/2] G/4 G/4\n[Gz/4] [d3/8z/4] c/2 G G/2 [G,/8G/4] z/8 [G,/8G/4] z/8 [GF,/8] z/8\n[d3/8F,/8] z/8 [c/2G,/8] z3/8 [GF,/8] z/8 G,/8 z3/8 F,/8 z/8\n[G,/8G/4] z/8 [G/4G,/8] z/8 [=f13/8A3/2=A,/8F/2C11/8] z3/8 F/2\n[F/2z/4] G/8 z/8 [^d13/2^D25/4^A,25/4G/2] G/4 G/4 [Gz/4] [=d3/8z/4]\nc/2 G G/2 [G,/8G/4] z/8 [G,/8G/4] z/8 [F,/8G] z/8 [d/4F,/8] z/8\n[G,/4c/2] z/4 [GF,/8] z/8 G,/8 z3/8 F,/8 z/8 [G/4G,/8] z/8 G/8 z/8\n[f7/4A11/8F/2C11/8] F/2 [F/2z/4] G/8 z/8 [^d9/2^D9/2^A,9/2G/2] G/4\nG/4 [Gz/4] =d/4 c/2 G [G3/2z/2] [G,/8d/8] z/8 [G,/8d/8] z/8 [G,/8d/8]\nz/8 [G,/8d/8] z/8 [^F,/8d/2f3/8^F7/2=A,3/4=D7/2] z3/8 [d5/4^F,/8] z/8\n[A,3/4z/2] ^F,/4 [A,2^d/4] [=d3/4z/4] f/2 [dz/2] f/2\n[^a3/2g19/8d3/2^A,5/2^A5/2] [^a/4d/4] [^a/4d/4] [^a/4d/4] [^a3/8d/8]\nz/8 [=a7/4=A,17/8=A/2c7/4f/2] [f3/2A3/2z] [g/4^A/8] z/8 [a3/8c/4]\n[G,2G/2g3/2^A3/2^d/2] [^d11/8G13/8z] [g/4^A/4] [g3/8^A/8] z/8\n[A,13/8a13/8=A/2c3/2f/2] [fA] [^a^A,5/2^A5/2g9/4=d] [^a/4d/4]\n[^a/4d/4] [^a/2d/2] [^a/4d/4] [^a3/8d/8] z/8\n[=a7/4=A,17/8=A/2c7/4f/2] [A13/8f3/2z] [g/4^A/8] z/8 [a3/8c/4]\n[g3/2G,17/8G/2^A3/2^d/2] [^d5/4G3/2z] [g/4^A/4] [g/4^A/4]\n[^F,13/8^f/2^F13/8=A/2=d] [A^f9/8z/2] [a/2d/2] [^ad^A,5/2^A5/2g5/2]\n[^a/4d/4] [^a/4d/4] [^a/4d/4] [^a/4d/4] [^a/4d/4] [^a/4d/4]\n[=A,17/8=A/2=a7/4c7/4=f/2] [f3/2A3/2z] [g/4^A/4] [a3/8c3/8z/4]\n[G,2G/2g3/2^A3/2^d/2] [^d3/2G13/8z] [g/4^A/4] [g3/8^A/4]\n[A,13/8a3/2c3/2=A/2f/2] [fA9/8] [^a^A5/2^A,5/2g5/2=d] [d/4^a/4]\n[^a/4d/4] [^a/4d/4] [d/4^a/4] [d/4^a/4] [^a/4d/4]\n[=a7/4=A,17/8=A/2c7/4f/2] [f3/2A13/8z] [g/4^A/8] z/8 [c3/8a3/8z/4]\n[G,17/8G/2g3/2^A3/2^d/2] [^d11/8G13/8z] [g/4^A/4] [g/4^A/4]\n[^f/2^F,13/8a5/8=d3/2=A/2^F13/8] [^f9/8A] [^A51/8^d13/2G/2g13/2] G/4\nG/4 [Gz/4] =d/4 c/2 G G/2 [G,/8G/4] z/8 [G,/8G/4] z/8 [G=F,/8] z/8\n[d/4F,/8] z/8 [c/2G,/8] z3/8 [GF,/8] z/8 G,/8 z3/8 F,/8 z/8 [G,/8G/4]\nz/8 [G,/8G/4] z/8 [a3/2A,/4=A11/8=f3/2c11/8] z/4 =F/8 z3/8 F/4 G/4\n[g/2G/2^A/2^d/2] [=d/2^f3/8^F/4=A/4] z/4 ^A/4 z/4 d/2 c/4 ^A/8 z9/8\nd/2 ^A/2 c/4 z/4 c/4 z3/4 ^A/4 z/4 d3/8 z5/8 [c/2z/4] ^A/4 G/4 z11/4\n=f/8 z/8 f/8 z3/8 f/8 z/8 g/8 z55/8 f/8 z/8 f/4 z/4 f/4 g/8 z7/8 f/8\nz/8 f/8 z3/8 f/8 z/8 g/8 z/8 ^a/8 z/8 c'/8 z/8 ^a/8 z/8 =a/8 z/8 g/8\nz/8 f/4 d/8 z/8 [G,31/8g/4a/8] z/8 [g61/4z29/8] [G,4z/8] [^d25/2z5/2]\n[a19/2z3/2] [G,31/8e51/8] G,29/8 z/2 [^A/8=d/8] z/8 [^A/4^A,/2] z/4\n[D,/4^A/8] z/8 [=A,/4=A/4] D,/4 [G,/4G/8] z/8 D,/4 [F,/4=F/8] z/8\n[D,/8D/8] z/8 [F,/8^A/8] z/8 [F,/8^A/4] z3/8 [G,/8G/8] z3/8 D,/4\n[^A/8F,/8] z/8 [^A,/2^A/8] z3/8 [D,/4^A/8] z/8 [=A,/4=A/8] z/8 D,/4\n[G,/4G/8] z/8 D,/4 [F,/4F/8] z/8 [D,/8D/8] z/8 [A/8F,/8] z/8\n[A/8F,/8] z3/8 [G,/8G/8] z3/8 D,/4 [^A/8F,/4] z/8 [^A,/2^A/8] z3/8\n[D,/4^A/8] z/8 [=A,/4=A/8] z/8 D,/4 [G,/4G/8] z/8 D,/4 [F,/4F/8] z/8\n[D,/8D/8] z/8 [F,/8^A/8] z/8 [F,/8^A/4] z3/8 [G,/8G/8] z3/8 D,/4\n[F,/4^A/8] z/8 [^A,/2^A/8] z3/8 [D,/4^A/8] z/8 [=A,/4=A/8] z/8 D,/4\n[G,/4G/8] z/8 D,/4 [F,/4F/8] z/8 [D,/8D/8] z/8 [F,/8A/8] z/8\n[F,/8A/8] z3/8 [G,/8G/8] z/8 D,/4 F,/4 [^A/8G,/4] z/8 [^A/8^A,/2]\nz3/8 [D,/4^A/8] z/8 [=A,/4=A/8] z/8 D,/4 [G,/4G/8] z/8 D,/4 [F,/4F/8]\nz/8 [D,/8D/8] z/8 [F,/8^A/8] z/8 [F,/8^A/4] z3/8 [G,/8G/8] z3/8 D,/4\n[^A/8F,/8] z/8 [^A,/2^A/8] z3/8 [D,/4^A/8] z/8 [=A,/4=A/8] z/8 D,/4\n[G,/4G/8] z/8 D,/4 [F,/4F/8] z/8 [D,/8D/8] z/8 [A/8F,/8] z/8\n[A/8F,/8] z3/8 [G,/8G/8] z3/8 D,/4 [^A/8F,/4] z/8 [^A,/2^A/8] z3/8\n[D,/4^A/8] z/8 [=A,/4=A/8] z/8 D,/4 [G,/4G/8] z/8 D,/4 [F,/4F/8] z/8\n[D,/8D/8] z/8 [F,/8^A/8] z/8 [F,/8^A/4] z3/8 [G,/8G/8] z3/8 D,/4\n[F,/4^A/8] z/8 [^A,/2^A/4] z/4 [D,/4^A/8] z/8 [=A,/4=A/8] z/8 D,/4\n[G,/4G/8] z/8 D,/4 [F,/4F/8] z/8 [D,/8D/8] z/8 [F,/8A/8] z/8\n[F,/8A/8] z3/8 [G,/8G/8] z5/8 [^a3/2g19/8d3/2^A,5/2^A5/2] [^a/4d/4]\n[^a/4d/4] [^a/4d/4] [^a3/8d/4] [=a7/4=A,17/8=A/2f/2c7/4] [f3/2A3/2z]\n[^A/8g/4] z/8 [a/4c3/8] [G,2G/2g3/2^A3/2^d/2] [G13/8^d11/8z]\n[g/4^A/4] [g3/8^A/4] [A,13/8a13/8=A/2c3/2f/2] [fA]\n[^a^A,5/2^A5/2g9/4=d] [^a/4d/4] [^a/4d/4] [^a/2d/2] [^a/4d/4]\n[^a/4d/8] z/8 [=a7/4=A,17/8=A/2c7/4f/2] [f3/2A13/8z] [g/4^A/4]\n[a3/8c3/8z/4] [G,17/8G/2g3/2^A3/2^d/2] [^d5/4G3/2z] [g/4^A/4]\n[g/4^A/4] [^F,13/8^f/2^F13/8=A/2=d] [^f9/8Az/2] [a/2d/2]\n[^ad^A,5/2^A5/2g5/2] [^a/4d/4] [^a/4d/4] [^a/4d/4] [^a/4d/4]\n[^a/4d/4] [^a/4d/4] [=A,17/8=A/2=a7/4c7/4=f/2] [f3/2A3/2z] [g/4^A/8]\nz/8 [a3/8c/4] [G,2G/2g3/2^A3/2^d/2] [^d3/2G13/8z] [^A/4g/4]\n[g3/8^A/4] [a3/2A,13/8c3/2=A/2f/2] [fA9/8] [^a^A5/2^A,5/2g5/2=d]\n[^a/4d/4] [^a/4d/4] [^a/4d/4] [^a/4d/4] [^a/4d/4] [^a/4d/4]\n[=a7/4=A,17/8=A/2c7/4f/2] [f3/2A13/8z] [g/4^A/8] z/8 [a3/8c3/8z/4]\n[G,17/8g3/2^A3/2G/2^d/2] [^d11/8G13/8z] [g/4^A/4] [g/4^A/4]\n[^f3/2^F,13/8=A/2=d^F13/8] [g/2A] [a5/8d/2]\n[^a3/2d3/2^A,5/2g5/2^A5/2] [^a/4d/4] [^a/4d/4] [^a/4d/4] [^a3/8d/4]\n[=a7/4=A,17/8=A/2=f/2c7/4] [f3/2A3/2z] [^A/8g/4] z/8 [a/4c3/8]\n[G,2G/2g3/2^A3/2^d/2] [G13/8^d11/8z] [g/4^A/4] [g3/8^A/4]\n[A,13/8a13/8=A/2c3/2f/2] [fA] [^a^A,5/2^A5/2g9/4=d] [^a/4d/4]\n[^a/4d/4] [^a/2d/2] [^a/4d/4] [^a/4d/8] z/8 [=a7/4=A,17/8=A/2c7/4f/2]\n[f3/2A13/8z] [g/4^A/4] [a3/8c3/8z/4] [G,17/8G/2g3/2^A3/2^d/2]\n[^d5/4G3/2z] [g/4^A/4] [g/4^A/4] [^F,13/8^f/2^F13/8=A/2=d]\n[^f9/8Az/2] [a/2d/2] [^ad^A,5/2^A5/2g5/2] [^a/4d/4] [^a/4d/4]\n[^a/4d/4] [^a/4d/4] [^a/4d/4] [^a/4d/4] [=A,17/8=A/2=a7/4c7/4=f/2]\n[f3/2A3/2z] [g/4^A/8] z/8 [a3/8c/4] [G,2G/2g3/2^A3/2^d/2]\n[^d3/2G13/8z] [^A/4g/4] [g3/8^A/4] [a3/2A,13/8c3/2=A/2f/2] [fA9/8]\n[^a^A5/2^A,5/2g5/2=d] [^a/4d/4] [^a/4d/4] [^a/4d/4] [^a/4d/4]\n[^a/4d/4] [^a/4d/4] [=a17/8=A,17/8=A/2c2f/2] [f3/2A13/8] 	0	0	212	f	\N
\.


--
-- Name: boards_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('boards_id_seq', 7, true);


--
-- Name: boards_stars_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('boards_stars_id_seq', 2, true);


--
-- Name: boards_subscribers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('boards_subscribers_id_seq', 1, true);


--
-- Data for Name: boards_users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY boards_users (id, created, modified, board_id, user_id, board_user_role_id) FROM stdin;
4	2015-05-25 11:04:09.851878	2015-05-25 11:04:09.851878	4	5	1
24	2016-01-12 20:02:20.842	2016-01-12 20:02:20.842	4	2	1
26	2016-01-12 20:03:49.929	2016-01-12 20:03:49.929	5	2	1
25	2016-01-12 20:03:01.212	2016-01-12 20:03:01.212	6	2	1
16	2016-01-12 18:34:04.342	2016-01-12 18:34:04.342	7	2	1
5	2015-05-25 11:13:14.788897	2015-05-25 11:13:14.788897	5	6	1
6	2015-05-25 12:20:12.066553	2015-05-25 12:20:12.066553	6	7	1
15	2015-05-25 15:04:03.986154	2015-05-25 15:04:03.986154	7	11	1
14	2015-05-25 14:54:30.622028	2015-05-25 14:54:30.622028	7	14	2
13	2015-05-25 14:53:47.114251	2015-05-25 14:53:47.114251	7	13	2
12	2015-05-25 14:53:33.831006	2015-05-25 14:53:33.831006	7	15	2
7	2015-05-25 12:43:40.704123	2015-05-25 12:43:40.704123	7	12	2
\.


--
-- Name: boards_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('boards_users_id_seq', 26, true);


--
-- Data for Name: card_attachments; Type: TABLE DATA; Schema: public; Owner: -
--

COPY card_attachments (id, created, modified, card_id, name, path, list_id, board_id, mimetype, link) FROM stdin;
6	2015-06-10 17:26:05.687	2015-06-10 17:26:05.687	28	YahooStamped.jpg	media/Card/28/YahooStamped.jpg	200	5	image/jpeg	\N
7	2015-06-24 11:41:01.842	2015-06-24 11:41:01.842	608	og-logo.png	media/Card/608/og-logo.png	203	6	image/png	\N
8	2015-06-24 11:41:11.867	2015-06-24 11:41:11.867	98	nextcaller.png	media/Card/98/nextcaller.png	201	6	image/png	\N
9	2015-06-24 11:41:35.421	2015-06-24 11:41:35.421	8	iPad_Pro_Ramotion_concept_600e.jpg	media/Card/8/iPad_Pro_Ramotion_concept_600e.jpg	197	4	image/jpeg	\N
10	2015-06-24 11:41:48.112	2015-06-24 11:41:48.112	13	iOS_8_Extensions_1000.jpg	media/Card/13/iOS_8_Extensions_1000.jpg	197	4	image/jpeg	\N
11	2015-06-24 11:42:01.853	2015-06-24 11:42:01.853	23	iOS_8_games_folder_1000.jpg	media/Card/23/iOS_8_games_folder_1000.jpg	197	4	image/jpeg	\N
12	2016-01-12 18:35:48.019	2016-01-12 18:35:48.019	163	Firefox2B362Bbeta.jpg	media/Card/163/Firefox2B362Bbeta.jpg	204	7	\N	\N
14	2016-01-12 18:38:49.583	2016-01-12 18:38:49.583	173	ecmascript2015-8522x.png	media/Card/173/ecmascript2015-8522x.png	204	7	\N	\N
15	2016-01-12 18:55:34.165	2016-01-12 18:55:34.165	435	profiler.png	media/Card/435/profiler.png	207	7	\N	\N
16	2016-01-12 19:05:50.083	2016-01-12 19:05:50.083	223	Firefox2B362Bbeta.jpg	media/Card/223/Firefox2B362Bbeta.jpg	209	7	\N	\N
18	2016-01-12 19:30:03.605	2016-01-12 19:30:03.605	555	18ixl3mwmu46rpng.png	media/Card/555/18ixl3mwmu46rpng.png	202	6	\N	\N
19	2016-01-12 19:33:08.786	2016-01-12 19:33:08.786	96	memebox5unbox.png	media/Card/96/memebox5unbox.png	201	6	\N	\N
\.


--
-- Name: card_attachments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('card_attachments_id_seq', 19, true);


--
-- Data for Name: card_subscribers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY card_subscribers (id, created, modified, card_id, user_id, is_subscribed) FROM stdin;
2	2016-01-12 19:27:27.012	2016-01-12 19:27:27.012	100	7	t
3	2016-01-12 19:36:28	2016-01-12 19:36:28	609	7	t
4	2016-01-12 19:40:03.907	2016-01-12 19:40:03.907	29	6	t
\.


--
-- Data for Name: card_voters; Type: TABLE DATA; Schema: public; Owner: -
--

COPY card_voters (id, created, modified, card_id, user_id) FROM stdin;
2	2016-01-12 18:55:56.871	2016-01-12 18:55:56.871	223	12
3	2016-01-12 18:56:12.822	2016-01-12 18:56:12.822	353	12
4	2016-01-12 19:02:36.936	2016-01-12 19:02:36.936	510	12
5	2016-01-12 19:24:00.361	2016-01-12 19:24:00.361	2	5
6	2016-01-12 19:35:25.72	2016-01-12 19:35:25.72	556	7
7	2016-01-12 19:39:33.509	2016-01-12 19:39:33.509	28	6
8	2016-01-12 19:40:06.792	2016-01-12 19:40:06.792	29	6
\.


--
-- Name: card_voters_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('card_voters_id_seq', 8, true);


--
-- Data for Name: cards; Type: TABLE DATA; Schema: public; Owner: -
--

COPY cards (id, created, modified, board_id, list_id, name, description, due_date, "position", is_archived, attachment_count, checklist_count, checklist_item_count, checklist_item_completed_count, label_count, cards_user_count, cards_subscriber_count, card_voter_count, activity_count, user_id, is_deleted, comment_count, custom_fields) FROM stdin;
605	2016-01-05 13:46:26.6	2015-05-25 13:45:18.79542	7	211	UNRESOLVED Issues	\N	\N	6	f	0	1	1	0	0	1	0	0	4	12	f	0	\N
622	2016-01-07 13:46:26.6	2015-05-25 13:50:44.269265	6	203	S10: GazeHawk	\N	\N	15	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
621	2016-01-07 13:46:26.6	2015-05-25 13:50:40.550508	6	203	S10: FanPulse	\N	\N	14	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
620	2016-01-07 13:46:26.6	2015-05-25 13:50:37.33673	6	203	S10: AdGrok	\N	\N	13	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
619	2016-01-07 13:46:26.6	2015-05-25 13:50:33.640753	6	203	W11: TalkBin	\N	\N	12	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
604	2016-01-05 13:46:26.6	2015-05-25 13:44:54.99858	7	211	FIXED Issues	\N	\N	5	f	0	1	1	1	0	0	0	0	4	12	f	0	\N
587	2016-01-05 13:46:26.6	2015-05-25 13:43:20.842663	7	211	HTML5 Issues	\N	\N	3	f	0	1	7	0	0	0	0	0	9	12	f	0	\N
564	2016-01-05 13:46:26.6	2015-05-25 13:41:52.373321	7	211	NEW Issues	\N	\N	1	f	0	1	3	0	0	0	0	0	5	12	f	0	\N
550	2016-01-05 13:46:26.6	2015-05-25 13:38:12.272773	7	208	FIXED Issues	\N	\N	5	f	0	1	1	1	0	0	0	0	4	12	f	0	\N
618	2016-01-07 13:46:26.6	2015-05-25 13:50:29.939463	6	203	W11: Sendoid	\N	\N	11	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
207	2016-01-05 13:46:26.6	2015-05-25 12:54:24.301659	7	204	UNRESOLVED Issues	\N	\N	6	f	0	1	3	0	0	1	0	0	6	12	f	0	\N
61	2016-01-08 13:46:26.6	2015-05-25 11:41:06.866181	5	200	Distill	\N	\N	34	f	0	0	0	0	0	0	0	0	1	6	f	0	\N
174	2016-01-05 13:46:26.6	2015-05-25 12:51:13.963569	7	204	DEVELOPER	\N	\N	4	f	0	1	4	0	0	0	0	0	6	12	f	0	\N
101	2016-01-07 13:46:26.6	2015-05-25 12:37:52.079136	6	201	W14: Orankl	\N	\N	1	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
94	2016-01-07 13:46:26.6	2015-05-25 12:37:25.028918	6	201	W14: MadeSolid	\N	\N	1	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
93	2016-01-07 13:46:26.6	2015-05-25 12:37:20.4351	6	201	W14: Kimono	\N	\N	1	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
84	2016-01-07 13:46:26.6	2015-05-25 12:36:38.659988	6	201	W14: Camperoo	\N	\N	1	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
60	2016-01-08 13:46:26.6	2015-05-25 11:41:01.535232	5	200	Wander	\N	\N	33	f	0	0	0	0	0	0	0	0	1	6	f	0	\N
59	2016-01-08 13:46:26.6	2015-05-25 11:40:48.225766	5	200	Incredible Labs	\N	\N	32	f	0	0	0	0	0	0	0	0	1	6	f	0	\N
52	2016-01-08 13:46:26.6	2015-05-25 11:40:00.81149	5	200	EvntLive	\N	\N	25	f	0	0	0	0	0	0	0	0	1	6	f	0	\N
46	2016-01-08 13:46:26.6	2015-05-25 11:38:14.326796	5	200	IQ Engines	\N	\N	19	f	0	0	0	0	0	0	0	0	1	6	f	0	\N
45	2016-01-08 13:46:26.6	2015-05-25 11:38:10.002087	5	200	Rockmelt	\N	\N	18	f	0	0	0	0	0	0	0	0	1	6	f	0	\N
44	2016-01-08 13:46:26.6	2015-05-25 11:38:00.911675	5	200	Lexity  @ $35000m	\N	\N	17	f	0	0	0	0	0	0	0	0	1	6	f	0	\N
43	2016-01-08 13:46:26.6	2015-05-25 11:36:54.900608	5	200	Ztelic	\N	\N	16	f	0	0	0	0	0	0	0	0	1	6	f	0	\N
55	2016-01-08 13:46:26.6	2015-05-25 11:40:15.521743	5	200	Aviate	\N	\N	28	f	0	0	0	0	0	0	0	0	1	6	f	0	\N
54	2016-01-08 13:46:26.6	2015-05-25 11:40:08.633823	5	200	PeerCDN	\N	\N	27	f	0	0	0	0	0	0	0	0	1	6	f	0	\N
53	2016-01-08 13:46:26.6	2015-05-25 11:40:04.780438	5	200	Quik.io	\N	\N	26	f	0	0	0	0	0	0	0	0	1	6	f	0	\N
42	2016-01-08 13:46:26.6	2015-05-25 11:36:36.605486	5	200	Xobni  @ $40000m	\N	\N	15	f	0	0	0	0	0	0	0	0	1	6	f	0	\N
41	2016-01-08 13:46:26.6	2015-05-25 11:36:01.671308	5	200	Qwiki @ $50000m	\N	\N	14	f	0	0	0	0	0	0	0	0	1	6	f	0	\N
40	2016-01-08 13:46:26.6	2015-05-25 11:35:10.204611	5	200	Bignoggins Productions	\N	\N	13	f	0	0	0	0	0	0	0	0	1	6	f	0	\N
39	2016-01-08 13:46:26.6	2015-05-25 11:35:02.545095	5	200	Rondee	\N	\N	12	f	0	0	0	0	0	0	0	0	1	6	f	0	\N
38	2016-01-08 13:46:26.6	2015-05-25 11:34:55.836923	5	200	GhostBird Software	\N	\N	11	f	0	0	0	0	0	0	0	0	1	6	f	0	\N
92	2016-01-07 13:46:26.6	2015-05-25 12:37:15.847884	6	201	W14: Immunity Project	\N	\N	1	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
91	2016-01-07 13:46:26.6	2015-05-25 12:37:09.683635	6	201	W14: HoverChat	\N	\N	1	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
90	2016-01-07 13:46:26.6	2015-05-25 12:37:05.508421	6	201	W14: Gobble	\N	\N	1	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
36	2016-01-08 13:46:26.6	2015-05-25 11:33:37.710919	5	200	Tumblr @ $1100000m	\N	\N	9	f	0	0	0	0	0	0	0	0	1	6	f	0	\N
35	2016-01-08 13:46:26.6	2015-05-25 11:30:34.603765	5	200	Loki Studios	\N	\N	8	f	0	0	0	0	0	0	0	0	1	6	f	0	\N
58	2016-01-08 13:46:26.6	2015-05-25 11:40:44.148216	5	200	Tomfoolery	\N	\N	31	f	0	0	0	0	0	0	0	0	1	6	f	0	\N
57	2016-01-08 13:46:26.6	2015-05-25 11:40:26.796208	5	200	Cloud Party	\N	\N	30	f	0	0	0	0	0	0	0	0	1	6	f	0	\N
56	2016-01-08 13:46:26.6	2015-05-25 11:40:21.820674	5	200	SPARQ	\N	\N	29	f	0	0	0	0	0	0	0	0	1	6	f	0	\N
51	2016-01-08 13:46:26.6	2015-05-25 11:39:51.340071	5	200	Ptch @ $6500m	\N	\N	24	f	0	0	0	0	0	0	0	0	1	6	f	0	\N
50	2016-01-08 13:46:26.6	2015-05-25 11:38:59.084192	5	200	SkyPhrase	\N	\N	23	f	0	0	0	0	0	0	0	0	1	6	f	0	\N
49	2016-01-08 13:46:26.6	2015-05-25 11:38:26.726138	5	200	LookFlow	\N	\N	22	f	0	0	0	0	0	0	0	0	1	6	f	0	\N
48	2016-01-08 13:46:26.6	2015-05-25 11:38:23.219596	5	200	Bread	\N	\N	21	f	0	0	0	0	0	0	0	0	1	6	f	0	\N
551	2016-01-05 13:46:26.6	2015-05-25 13:39:15.914791	7	209	CHANGED Issues	\N	\N	1	f	0	1	1	0	0	0	0	0	3	12	f	0	\N
549	2016-01-05 13:46:26.6	2015-05-25 13:37:17.698802	7	208	DEVELOPER	\N	\N	4	f	0	1	5	0	0	0	0	0	7	12	f	0	\N
492	2016-01-05 13:46:26.6	2015-05-25 13:31:27.290533	7	207	UNRESOLVED issues	\N	\N	6	f	0	1	3	0	0	1	0	0	6	12	f	0	\N
25	2016-01-06 13:46:26.6	2015-05-25 11:06:05.00199	4	197	Accessibility improvements	\N	\N	24	f	0	0	0	0	0	0	0	0	1	5	f	0	\N
24	2016-01-06 13:46:26.6	2015-05-25 11:06:02.107303	4	197	Block callers who hide Caller ID	\N	\N	23	f	0	0	0	0	0	0	0	0	1	5	f	0	\N
22	2016-01-06 13:46:26.6	2015-05-25 11:05:54.802411	4	197	A better, easier Photos app	\N	\N	21	f	0	0	0	0	0	0	0	0	1	5	f	0	\N
21	2016-01-06 13:46:26.6	2015-05-25 11:05:40.678678	4	197	Improved integration between Contacts and Facebook	\N	\N	20	f	0	0	0	0	0	0	0	0	1	5	f	0	\N
557	2016-01-07 13:46:26.6	2015-05-25 13:41:29.508443	6	202	W10: NewsLabs	\N	\N	4	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
559	2016-01-07 13:46:26.6	2015-05-25 13:41:36.781293	6	202	W10: Swagapalooza	\N	\N	6	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
558	2016-01-07 13:46:26.6	2015-05-25 13:41:32.707559	6	202	W10: Notifo	\N	\N	5	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
567	2016-01-07 13:46:26.6	2015-05-25 13:42:00.81775	6	202	S08: PopCuts	\N	\N	13	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
566	2016-01-07 13:46:26.6	2015-05-25 13:41:57.255868	6	202	S08: People and Pages	\N	\N	12	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
565	2016-01-07 13:46:26.6	2015-05-25 13:41:53.862477	6	202	S08: AwesomeHighlighter	\N	\N	11	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
563	2016-01-07 13:46:26.6	2015-05-25 13:41:50.743194	6	202	W09: Propable	\N	\N	10	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
562	2016-01-07 13:46:26.6	2015-05-25 13:41:47.593496	6	202	W09: Nambii	\N	\N	9	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
561	2016-01-07 13:46:26.6	2015-05-25 13:41:43.606264	6	202	S09: Plurchase	\N	\N	8	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
560	2016-01-07 13:46:26.6	2015-05-25 13:41:40.175827	6	202	S09: Jobpic	\N	\N	7	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
582	2016-01-07 13:46:26.6	2015-05-25 13:42:56.871974	6	202	S07: Adpinion	\N	\N	27	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
581	2016-01-07 13:46:26.6	2015-05-25 13:42:53.39001	6	202	W08: 8aweek	\N	\N	26	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
580	2016-01-07 13:46:26.6	2015-05-25 13:42:49.441093	6	202	W08: Wundrbar	\N	\N	25	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
579	2016-01-07 13:46:26.6	2015-05-25 13:42:45.247829	6	202	W08: Tipjoy	\N	\N	24	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
601	2016-01-05 13:46:26.6	2015-05-25 13:44:14.646328	7	211	DEVELOPER	\N	\N	4	f	0	1	4	0	0	0	0	0	6	12	f	0	\N
607	2016-01-05 13:46:26.6	2015-05-25 13:47:14.877395	7	212	UNRESOLVED Issues	\N	\N	2	f	0	1	1	0	0	1	0	0	4	12	f	0	\N
180	2016-01-05 13:46:26.6	2015-05-25 12:52:30.40199	7	204	FIXED Issues	\N	\N	5	f	0	1	3	3	0	0	0	0	8	12	f	0	\N
9	2016-01-06 13:46:26.6	2015-05-25 11:04:53.348335	4	197	Battery-saving mode	\N	\N	8	f	0	0	0	0	0	0	0	0	1	5	f	0	\N
7	2016-01-06 13:46:26.6	2015-05-25 11:04:46.705425	4	197	Group FaceTime calls	\N	\N	6	f	0	0	0	0	0	0	0	0	1	5	f	0	\N
6	2016-01-06 13:46:26.6	2015-05-25 11:04:43.816576	4	197	FaceTime video messages	\N	\N	5	f	0	0	0	0	0	0	0	0	1	5	f	0	\N
575	2016-01-07 13:46:26.6	2015-05-25 13:42:33.123503	6	202	W08: Kirkland North	\N	\N	21	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
574	2016-01-07 13:46:26.6	2015-05-25 13:42:29.924341	6	202	S08: Youlicit	\N	\N	20	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
573	2016-01-07 13:46:26.6	2015-05-25 13:42:26.731722	6	202	S08: Vidly / Fliggo	\N	\N	19	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
572	2016-01-07 13:46:26.6	2015-05-25 13:42:22.701671	6	202	S08: UrbanTakeover	\N	\N	18	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
571	2016-01-07 13:46:26.6	2015-05-25 13:42:18.736235	6	202	S08: TicketStumbler	\N	\N	17	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
585	2016-01-07 13:46:26.6	2015-05-25 13:43:13.991713	6	202	S07: iJigg	\N	\N	30	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
29	2016-01-08 13:46:26.6	2015-05-25 11:28:26.241158	5	200	OnTheAir	\N	\N	0.75	f	0	0	0	0	1	0	1	1	2	6	f	0	\N
8	2016-01-06 13:46:26.6	2015-05-25 11:04:50.77859	4	197	Split-screen multitasking	\N	\N	7	f	1	0	0	0	0	0	0	0	2	5	f	0	\N
13	2016-01-06 13:46:26.6	2015-05-25 11:05:09.623516	4	197	Home screen widgets	\N	\N	12	f	1	0	0	0	0	0	0	0	2	5	f	0	\N
3	2016-01-06 13:46:26.6	2016-01-12 19:22:55.598	4	197	Improved reliability & stability	\N	2016-01-29 23:20:00	2	f	0	0	0	0	0	0	0	0	2	5	f	0	\N
2	2016-01-06 13:46:26.6	2016-01-12 19:23:54.871	4	197	Contact availability status	Steve Jobs set due date to this card Contact availability status	2016-02-11 06:30:00	1	f	0	0	0	0	3	1	0	1	6	5	f	0	\N
23	2016-01-06 13:46:26.6	2015-06-24 11:42:26.933	4	197	Subfolders	\N	\N	0.5	f	1	0	0	0	0	1	0	0	7	5	f	0	\N
456	2016-01-05 13:46:26.6	2015-05-25 13:28:02.617982	7	207	FIXED Issues	\N	\N	5	f	0	1	14	14	0	0	0	0	33	12	f	0	\N
98	2016-01-07 13:46:26.6	2016-01-12 19:30:14.289	6	201	W14: Next Caller	\N	2016-01-28 18:25:00	4	f	1	0	0	0	0	0	0	0	10	7	f	0	\N
555	2016-01-07 13:46:26.6	2016-01-12 19:33:35.343	6	202	W11: Moki.TV	\N	\N	0.5	f	1	0	0	0	2	0	0	0	7	7	f	0	\N
100	2016-01-07 13:46:26.6	2015-05-25 12:37:48.718197	6	201	W14: One Degree	\N	\N	1	f	0	0	0	0	0	0	1	0	3	7	f	0	\N
553	2016-01-07 13:46:26.6	2016-01-12 19:36:11.733	6	202	W11: FitFu\r\n	NUGANIC - CUSTOMIZE PORE CONTROL ESSENCE | 30ML FULL SIZE - WORTH $46.- This is a pore control essence which reduces the appearance of dilated pores.	\N	1	f	0	0	0	0	0	1	0	0	5	7	f	0	\N
28	2016-01-08 13:46:26.6	2016-01-12 19:38:52.224	5	200	Stamped	\N	2016-02-04 06:35:00	0.5	f	1	1	0	0	0	1	0	1	7	6	f	0	\N
610	2016-01-07 13:46:26.6	2016-01-12 19:36:58.982	6	203	W12: Carsabi	\N	\N	3.75	f	0	0	0	0	0	0	0	0	2	7	f	0	\N
609	2016-01-07 13:46:26.6	2015-05-25 13:47:28.857583	6	203	S13: Hackermeter	\N	\N	2	f	0	1	1	0	1	1	1	0	5	7	f	0	\N
96	2016-01-07 13:46:26.6	2016-01-12 19:33:29.993	6	201	W14: Minuum	\N	\N	1	f	1	0	0	0	0	0	0	0	4	7	f	0	\N
97	2016-01-07 13:46:26.6	2015-05-25 12:37:36.087052	6	201	W14: Move Loot	\N	\N	1	f	0	0	0	0	0	1	0	0	5	7	f	0	\N
26	2016-01-08 13:46:26.6	2016-01-12 19:40:13.722	5	200	Snip.it @ $10000m	\N	\N	1	t	0	0	0	0	0	0	0	0	2	6	f	0	\N
447	2016-01-05 13:46:26.6	2015-05-25 13:27:12.733993	7	207	DEVELOPER	\N	\N	4	f	0	1	4	0	0	0	0	0	6	12	f	0	\N
397	2016-01-05 13:46:26.6	2015-05-25 13:17:44.238711	7	206	UNRESOLVED Issues	\N	\N	6	f	0	1	3	0	0	1	0	0	6	12	f	0	\N
357	2016-01-05 13:46:26.6	2015-05-25 13:14:18.614722	7	206	FIXED Issues	\N	\N	5	f	0	1	13	13	0	0	0	0	35	12	f	0	\N
608	2016-01-07 13:46:26.6	2016-01-12 19:33:39.102	6	203	W14: Eventjoy	\N	\N	3.5	f	1	0	0	0	0	0	0	0	4	7	f	0	\N
99	2016-01-07 13:46:26.6	2016-01-12 19:30:57.345	6	201	W14: Noora Health	\N	2016-01-13 19:30:00	1	f	0	0	0	0	1	0	0	0	5	7	f	0	\N
342	2016-01-05 13:46:26.6	2015-05-25 13:08:51.694212	7	205	UNRESOLVED Issues	\N	\N	6	f	0	1	3	0	0	1	0	0	6	12	f	0	\N
279	2016-01-05 13:46:26.6	2015-05-25 13:01:42.269112	7	205	FIXED Issues	\N	\N	5	f	0	1	12	12	0	0	0	0	47	12	f	0	\N
554	2016-01-05 13:46:26.6	2016-01-12 19:06:34.199	7	210	FIXED Issues	\N	2016-02-11 18:05:00	1	f	0	1	3	3	1	1	0	0	12	12	f	0	\N
524	2016-01-05 13:46:26.6	2016-01-12 19:01:41.683	7	208	CHANGED Issues	\N	2016-03-04 02:10:00	2	f	0	1	5	0	0	2	0	0	10	12	f	0	\N
353	2016-01-05 13:46:26.6	2015-05-25 13:12:08.313304	7	206	HTML5 issues	\N	\N	3	f	0	1	12	0	2	0	0	1	15	12	f	0	\N
552	2016-01-05 13:46:26.6	2016-01-12 19:03:11.759	7	209	FIXED Issues	\N	2016-01-22 10:50:00	2	f	0	1	2	2	3	1	0	0	10	12	f	0	\N
606	2016-01-05 13:46:26.6	2015-05-25 13:46:26.626234	7	212	FIXED Issues	\N	\N	1	f	0	1	4	4	0	0	0	0	10	12	f	0	\N
510	2016-01-05 13:46:26.6	2016-01-12 19:02:30.897	7	208	NEW Issues	No longer accept insecure RC4 ciphers whenever possible	\N	1	f	0	1	5	0	0	0	0	1	9	12	f	0	\N
538	2016-01-05 13:46:26.6	2016-01-12 18:59:07.578	7	208	HTML5 Issues	No longer accept insecure RC4 ciphers whenever possible	\N	3	f	0	1	3	2	0	0	0	0	8	12	f	0	\N
163	2016-01-05 13:46:26.6	2015-05-25 12:46:28.7735	7	204	NEW Issues	\N	\N	1	f	1	1	3	0	0	0	0	0	6	12	f	0	\N
351	2016-01-05 13:46:26.6	2015-05-25 13:10:25.776665	7	206	NEW Issues	\N	\N	1	f	0	1	3	0	1	2	0	0	8	12	f	0	\N
352	2016-01-05 13:46:26.6	2016-01-12 19:00:46.527	7	205	CHANGED Issues	No longer accept insecure RC4 ciphers whenever possible	2016-01-12 18:45:00	0.5	f	0	1	4	0	0	2	0	0	11	12	f	0	\N
577	2016-01-05 13:46:26.6	2016-01-12 19:06:45.233	7	211	CHANGED Issues	\N	2016-02-25 19:05:00	2	f	0	1	4	1	0	0	0	0	8	12	f	0	\N
415	2016-01-05 13:46:26.6	2016-01-12 18:48:10.23	7	207	NEW Issues	\N	2016-02-14 01:45:00	1	f	0	1	3	0	3	2	0	0	8	12	f	0	\N
354	2016-01-05 13:46:26.6	2016-01-12 18:47:51.915	7	206	DEVELOPER	\N	2016-01-29 04:50:00	4	f	0	1	4	0	0	2	0	0	9	12	f	0	\N
269	2016-01-05 13:46:26.6	2015-05-25 13:00:57.599142	7	205	DEVELOPER	\N	\N	4	f	0	1	4	0	1	4	0	0	12	12	f	0	\N
89	2016-01-07 13:46:26.6	2015-05-25 12:36:57.096192	6	201	W14: Gbatteries	\N	\N	1	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
426	2016-01-05 13:46:26.6	2016-01-12 19:00:40.803	7	207	CHANGED Issues	No longer accept insecure RC4 ciphers whenever possible	2016-03-23 18:55:00	3.5	f	0	1	4	0	2	0	0	0	11	12	f	0	\N
173	2016-01-05 13:46:26.6	2015-05-25 12:48:55.074643	7	204	HTML5 Issues	\N	\N	3	f	1	1	12	0	0	0	0	0	17	12	f	0	\N
164	2016-01-05 13:46:26.6	2016-01-12 18:48:29.388	7	204	CHANGED Issues	\N	2016-03-18 00:05:00	2	f	0	1	5	0	1	2	0	0	11	12	f	0	\N
235	2016-01-05 13:46:26.6	2016-01-12 18:59:00.292	7	205	CHANGED Issues	No longer accept insecure RC4 ciphers whenever possible	\N	2	f	0	1	4	2	1	0	0	0	9	12	f	0	\N
246	2016-01-05 13:46:26.6	2016-01-12 18:58:39.787	7	205	HTML5 Issues	\N	2016-01-22 18:55:00	4.5	f	0	1	12	0	0	0	0	0	16	12	f	0	\N
435	2016-01-05 13:46:26.6	2015-05-25 13:25:23.422163	7	207	HTML5 Issues	\N	\N	3	f	1	1	12	3	0	0	0	0	18	12	f	0	\N
223	2016-01-05 13:46:26.6	2016-01-12 19:06:10.367	7	209	NEW Issues	\N	\N	1.5	f	1	1	3	1	0	2	0	1	12	12	f	0	\N
20	2016-01-06 13:46:26.6	2015-05-25 11:05:36.846872	4	197	Public transport directions in Apple Maps	\N	\N	19	f	0	0	0	0	0	0	0	0	1	5	f	0	\N
19	2016-01-06 13:46:26.6	2015-05-25 11:05:32.258436	4	197	Wider social-media integration	\N	\N	18	f	0	0	0	0	0	0	0	0	1	5	f	0	\N
18	2016-01-06 13:46:26.6	2015-05-25 11:05:26.355413	4	197	Mail improvements	\N	\N	17	f	0	0	0	0	0	0	0	0	1	5	f	0	\N
17	2016-01-06 13:46:26.6	2015-05-25 11:05:22.581852	4	197	Mail improvements	\N	\N	16	f	0	0	0	0	0	0	0	0	1	5	f	0	\N
16	2016-01-06 13:46:26.6	2015-05-25 11:05:19.024664	4	197	iMessage improvements	\N	\N	15	f	0	0	0	0	0	0	0	0	1	5	f	0	\N
15	2016-01-06 13:46:26.6	2015-05-25 11:05:15.604845	4	197	Calculator on iPad	\N	\N	14	f	0	0	0	0	0	0	0	0	1	5	f	0	\N
14	2016-01-06 13:46:26.6	2015-05-25 11:05:12.450727	4	197	Smaller file when upgrading iOS	\N	\N	13	f	0	0	0	0	0	0	0	0	1	5	f	0	\N
12	2016-01-06 13:46:26.6	2015-05-25 11:05:06.545377	4	197	Unplugged Hey Siri!	\N	\N	11	f	0	0	0	0	0	0	0	0	1	5	f	0	\N
11	2016-01-06 13:46:26.6	2015-05-25 11:05:03.339857	4	197	Local Siri	\N	\N	10	f	0	0	0	0	0	0	0	0	1	5	f	0	\N
10	2016-01-06 13:46:26.6	2015-05-25 11:05:00.092876	4	197	Ability to add apps and settings to Control Centre	\N	\N	9	f	0	0	0	0	0	0	0	0	1	5	f	0	\N
5	2016-01-06 13:46:26.6	2015-05-25 11:04:39.813748	4	197	Multiuser support/user accounts	\N	\N	4	f	0	0	0	0	0	0	0	0	1	5	f	0	\N
4	2016-01-06 13:46:26.6	2015-05-25 11:04:36.676469	4	197	Proper parental controls	\N	\N	3	f	0	0	0	0	0	0	0	0	1	5	f	0	\N
617	2016-01-07 13:46:26.6	2015-05-25 13:50:26.552383	6	203	W11: MailGun	\N	\N	10	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
616	2016-01-07 13:46:26.6	2015-05-25 13:50:23.081882	6	203	W11: Grove	\N	\N	9	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
615	2016-01-07 13:46:26.6	2015-05-25 13:50:18.017245	6	203	S11: TapEngage	\N	\N	8	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
614	2016-01-07 13:46:26.6	2015-05-25 13:50:13.801031	6	203	S11: Stypi	\N	\N	7	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
570	2016-01-07 13:46:26.6	2015-05-25 13:42:13.833334	6	202	S08: Socialbrowse	\N	\N	16	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
569	2016-01-07 13:46:26.6	2015-05-25 13:42:09.929833	6	202	S08: Snipd	\N	\N	15	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
568	2016-01-07 13:46:26.6	2015-05-25 13:42:04.807368	6	202	S08: Precognate	\N	\N	14	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
83	2016-01-07 13:46:26.6	2015-05-25 12:36:35.320676	6	201	W14: Cambly	\N	\N	1	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
82	2016-01-07 13:46:26.6	2015-05-25 12:36:31.815839	6	201	W14: Boostable	\N	\N	1	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
81	2016-01-07 13:46:26.6	2015-05-25 12:36:28.612353	6	201	W14: Bellabeat	\N	\N	1	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
80	2016-01-07 13:46:26.6	2015-05-25 12:36:24.269881	6	201	W14: Beacon	\N	\N	1	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
79	2016-01-07 13:46:26.6	2015-05-25 12:36:20.142972	6	201	W14: AptDeco	\N	\N	1	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
78	2016-01-07 13:46:26.6	2015-05-25 12:36:16.570279	6	201	W14: Ambition	\N	\N	1	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
77	2016-01-07 13:46:26.6	2015-05-25 12:36:10.889434	6	201	W14: Algolia	\N	\N	1	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
76	2016-01-07 13:46:26.6	2015-05-25 12:35:31.460306	6	201	W14: Algolia\r\n	\N	\N	1	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
75	2016-01-07 13:46:26.6	2015-05-25 12:35:27.49318	6	201	W14: AirPair\r\n	\N	\N	3	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
74	2016-01-07 13:46:26.6	2015-05-25 12:50:08.785898	6	201	W14: AirHelp\r\n\r\n	\N	\N	1	f	0	0	0	0	0	0	0	0	2	7	f	0	\N
73	2016-01-07 13:46:26.6	2015-05-25 12:34:52.648001	6	201	W14: Abacus\r\n	\N	\N	1	f	4	0	0	0	0	0	0	0	5	7	f	0	\N
95	2016-01-07 13:46:26.6	2015-05-25 12:37:28.303973	6	201	W14: Memebox	\N	\N	1	f	0	0	0	0	0	1	0	0	4	7	f	0	\N
88	2016-01-07 13:46:26.6	2015-05-25 12:36:52.772099	6	201	W14: Framed Data	\N	\N	1	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
87	2016-01-07 13:46:26.6	2015-05-25 12:36:49.327047	6	201	W14: CodeNow	\N	\N	1	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
86	2016-01-07 13:46:26.6	2015-05-25 12:36:44.697824	6	201	W14: CodeCombat	\N	\N	1	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
85	2016-01-07 13:46:26.6	2015-05-25 12:36:41.59739	6	201	W14: CareMessage	\N	\N	1	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
102	2016-01-07 13:46:26.6	2015-05-25 12:37:57.187932	6	201	W14: Piinpoint	\N	\N	1	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
578	2016-01-07 13:46:26.6	2015-05-25 13:42:41.380514	6	202	W08: Snaptalent	\N	\N	23	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
576	2016-01-07 13:46:26.6	2015-05-25 13:42:36.189807	6	202	W08: Mixwit	\N	\N	22	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
556	2016-01-07 13:46:26.6	2016-01-12 19:35:33.653	6	202	S10: I Move You	\N	2016-01-13 19:35:00	3	f	0	0	0	0	0	1	0	1	6	7	f	0	\N
584	2016-01-07 13:46:26.6	2015-05-25 13:43:05.619158	6	202	S07: Fuzzwich	\N	\N	29	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
583	2016-01-07 13:46:26.6	2015-05-25 13:43:00.727384	6	202	S07: Biographicon	\N	\N	28	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
613	2016-01-07 13:46:26.6	2015-05-25 13:50:05.059601	6	203	S11: Munch On Me	\N	\N	6	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
612	2016-01-07 13:46:26.6	2015-05-25 13:49:55.297434	6	203	S11: Glassmap	\N	\N	5	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
611	2016-01-07 13:46:26.6	2015-05-25 13:49:47.94572	6	203	W12: SocialCam	\N	\N	4	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
632	2016-01-07 13:46:26.6	2015-05-25 13:52:41.453608	6	203	S09: DailyBooth	\N	\N	25	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
631	2016-01-07 13:46:26.6	2015-05-25 13:52:29.314591	6	203	W10: Zencoder	\N	\N	24	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
630	2016-01-07 13:46:26.6	2015-05-25 13:52:26.226433	6	203	W10: Movity	\N	\N	23	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
629	2016-01-07 13:46:26.6	2015-05-25 13:52:22.886631	6	203	W10: Mertado	\N	\N	22	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
628	2016-01-07 13:46:26.6	2015-05-25 13:52:19.102983	6	203	W10: Etacts	\N	\N	21	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
627	2016-01-07 13:46:26.6	2015-05-25 13:52:15.728572	6	203	W10: datamarketplace	\N	\N	20	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
626	2016-01-07 13:46:26.6	2015-05-25 13:51:52.471108	6	203	W10: CardPool	\N	\N	19	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
625	2016-01-07 13:46:26.6	2015-05-25 13:51:48.161194	6	203	S10: 1000Memories	\N	\N	18	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
624	2016-01-07 13:46:26.6	2015-05-25 13:50:51.724507	6	203	S10: The Fridge	\N	\N	17	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
623	2016-01-07 13:46:26.6	2015-05-25 13:50:47.954452	6	203	S10: Rapportive	\N	\N	16	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
637	2016-01-07 13:46:26.6	2015-05-25 13:53:47.512285	6	203	W09: Divvyshot	\N	\N	30	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
636	2016-01-07 13:46:26.6	2015-05-25 13:53:43.812391	6	203	W09: Cloudkick	\N	\N	29	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
635	2016-01-07 13:46:26.6	2015-05-25 13:53:40.653083	6	203	S09: Lingt	\N	\N	28	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
634	2016-01-07 13:46:26.6	2015-05-25 13:53:37.584036	6	203	S09: GraffitiGeo	\N	\N	27	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
633	2016-01-07 13:46:26.6	2015-05-25 13:53:33.943949	6	203	S09: Flightcaster	\N	\N	26	f	0	0	0	0	0	0	0	0	1	7	f	0	\N
37	2016-01-08 13:46:26.6	2015-05-25 11:34:49.721415	5	200	PlayerScale	\N	\N	10	f	0	0	0	0	0	0	0	0	1	6	f	0	\N
47	2016-01-08 13:46:26.6	2015-05-25 11:38:18.368538	5	200	Hitpost	\N	\N	20	f	0	0	0	0	0	0	0	0	1	6	f	0	\N
72	2016-01-08 13:46:26.6	2015-05-25 11:46:26.88654	5	200	Cooliris	\N	\N	45	f	0	0	0	0	0	0	0	0	1	6	f	0	\N
71	2016-01-08 13:46:26.6	2015-05-25 11:46:14.978921	5	200	BrightRoll @ $640000m	\N	\N	44	f	0	0	0	0	0	0	0	0	2	6	f	0	\N
70	2016-01-08 13:46:26.6	2015-05-25 11:45:25.129835	5	200	LittleInc	\N	\N	43	f	0	0	0	0	0	0	0	0	1	6	f	0	\N
69	2016-01-08 13:46:26.6	2015-05-25 11:45:20.680584	5	200	Bookpad @ $15000m	\N	\N	42	f	0	0	0	0	0	0	0	0	1	6	f	0	\N
68	2016-01-08 13:46:26.6	2015-05-25 11:44:24.946163	5	200	Luminate	\N	\N	41	f	0	0	0	0	0	0	0	0	1	6	f	0	\N
67	2016-01-08 13:46:26.6	2015-05-25 11:44:21.31769	5	200	ClarityRay	\N	\N	40	f	0	0	0	0	0	0	0	0	1	6	f	0	\N
66	2016-01-08 13:46:26.6	2015-05-25 11:43:02.449451	5	200	Flurry @ $200000m	\N	\N	39	f	0	0	0	0	0	0	0	0	1	6	f	0	\N
65	2016-01-08 13:46:26.6	2015-05-25 11:41:45.273535	5	200	RayV	\N	\N	38	f	0	0	0	0	0	0	0	0	1	6	f	0	\N
64	2016-01-08 13:46:26.6	2015-05-25 11:41:23.038719	5	200	PhotoDrive	\N	\N	37	f	0	0	0	0	0	0	0	0	1	6	f	0	\N
63	2016-01-08 13:46:26.6	2015-05-25 11:41:16.248548	5	200	Blink	\N	\N	36	f	0	0	0	0	0	0	0	0	1	6	f	0	\N
62	2016-01-08 13:46:26.6	2015-05-25 11:41:11.09463	5	200	Vizify	\N	\N	35	f	0	0	0	0	0	0	0	0	1	6	f	0	\N
34	2016-01-08 13:46:26.6	2015-05-25 11:30:29.890597	5	200	MileWise	\N	\N	7	f	0	0	0	0	0	0	0	0	1	6	f	0	\N
33	2016-01-08 13:46:26.6	2015-05-25 11:30:25.544572	5	200	GoPollGo	\N	\N	6	f	0	0	0	0	0	0	0	0	1	6	f	0	\N
32	2016-01-08 13:46:26.6	2015-05-25 11:30:21.199959	5	200	Astrid	\N	\N	5	f	0	0	0	0	0	0	0	0	1	6	f	0	\N
31	2016-01-08 13:46:26.6	2015-05-25 11:29:50.155993	5	200	Summly @ $30000m	\N	\N	4	f	0	0	0	0	0	0	0	0	2	6	f	0	\N
30	2016-01-08 13:46:26.6	2015-05-25 11:28:46.645052	5	200	Jybe	\N	\N	3	f	0	0	0	0	0	0	0	0	1	6	f	0	\N
27	2016-01-08 13:46:26.6	2015-05-25 11:23:16.538938	5	200	Alike	\N	\N	2	f	0	0	0	0	0	1	0	0	4	6	f	0	\N
\.


--
-- Name: cards_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('cards_id_seq', 661, true);


--
-- Data for Name: cards_labels; Type: TABLE DATA; Schema: public; Owner: -
--

COPY cards_labels (id, created, modified, label_id, card_id, list_id, board_id) FROM stdin;
2	2015-06-11 14:25:59.907	2015-06-11 14:25:59.907	2	29	200	5
3	2015-06-11 14:25:59.935	2015-06-11 14:25:59.935	3	29	200	5
4	2016-01-12 18:45:16.317	2016-01-12 18:45:16.317	4	269	205	7
6	2016-01-12 18:45:46.791	2016-01-12 18:45:46.791	4	351	206	7
7	2016-01-12 18:45:46.808	2016-01-12 18:45:46.808	5	351	206	7
8	2016-01-12 18:46:12.052	2016-01-12 18:46:12.052	6	235	205	7
10	2016-01-12 18:49:57.536	2016-01-12 18:49:57.536	7	164	204	7
11	2016-01-12 18:49:57.554	2016-01-12 18:49:57.554	8	164	204	7
12	2016-01-12 18:57:22.217	2016-01-12 18:57:22.217	5	353	206	7
13	2016-01-12 18:57:28.927	2016-01-12 18:57:28.927	8	426	207	7
14	2016-01-12 18:59:48.242	2016-01-12 18:59:48.242	5	415	207	7
15	2016-01-12 19:03:01.078	2016-01-12 19:03:01.078	4	552	209	7
18	2016-01-12 19:07:44.69	2016-01-12 19:07:44.69	9	554	210	7
19	2016-01-12 19:07:44.758	2016-01-12 19:07:44.758	10	554	210	7
20	2016-01-12 19:23:10.138	2016-01-12 19:23:10.138	8	2	197	4
22	2016-01-12 19:30:38.353	2016-01-12 19:30:38.353	11	99	201	6
23	2016-01-12 19:30:38.371	2016-01-12 19:30:38.371	12	99	201	6
24	2016-01-12 19:34:40.356	2016-01-12 19:34:40.356	13	609	203	6
25	2016-01-12 19:34:40.376	2016-01-12 19:34:40.376	14	609	203	6
26	2016-01-12 19:34:40.382	2016-01-12 19:34:40.382	15	609	203	6
27	2016-01-12 19:34:49.863	2016-01-12 19:34:49.863	14	555	202	6
\.


--
-- Name: cards_labels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('cards_labels_id_seq', 27, true);


--
-- Name: cards_subscribers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('cards_subscribers_id_seq', 4, true);


--
-- Data for Name: cards_users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY cards_users (id, created, modified, card_id, user_id) FROM stdin;
2	2015-05-25 14:55:20.189216	2015-05-25 14:55:20.189216	207	15
3	2015-05-25 14:55:29.510585	2015-05-25 14:55:29.510585	342	13
4	2015-05-25 14:55:49.680961	2015-05-25 14:55:49.680961	397	14
5	2015-05-25 14:55:59.014116	2015-05-25 14:55:59.014116	492	15
6	2015-05-25 14:56:18.257957	2015-05-25 14:56:18.257957	605	13
7	2015-05-25 14:56:25.429819	2015-05-25 14:56:25.429819	607	14
8	2016-01-12 18:44:35.233	2016-01-12 18:44:35.233	164	13
9	2016-01-12 18:44:38.141	2016-01-12 18:44:38.141	164	11
10	2016-01-12 18:44:44.09	2016-01-12 18:44:44.09	223	11
11	2016-01-12 18:44:48.329	2016-01-12 18:44:48.329	223	2
13	2016-01-12 18:44:59.913	2016-01-12 18:44:59.913	269	12
14	2016-01-12 18:45:02.364	2016-01-12 18:45:02.364	269	14
15	2016-01-12 18:58:02.565	2016-01-12 18:58:02.565	352	13
16	2016-01-12 18:58:05.48	2016-01-12 18:58:05.48	352	11
17	2016-01-12 18:58:26.529	2016-01-12 18:58:26.529	269	13
18	2016-01-12 18:58:32.163	2016-01-12 18:58:32.163	269	11
19	2016-01-12 18:59:40.679	2016-01-12 18:59:40.679	415	13
20	2016-01-12 18:59:43.149	2016-01-12 18:59:43.149	415	11
21	2016-01-12 19:01:02.023	2016-01-12 19:01:02.023	354	15
22	2016-01-12 19:01:05.114	2016-01-12 19:01:05.114	354	14
23	2016-01-12 19:01:09.321	2016-01-12 19:01:09.321	351	14
24	2016-01-12 19:01:12.221	2016-01-12 19:01:12.221	351	2
25	2016-01-12 19:01:29.593	2016-01-12 19:01:29.593	524	15
26	2016-01-12 19:01:31.358	2016-01-12 19:01:31.358	524	11
27	2016-01-12 19:03:02.997	2016-01-12 19:03:02.997	552	13
28	2016-01-12 19:06:58.029	2016-01-12 19:06:58.029	554	13
29	2016-01-12 19:22:31.803	2016-01-12 19:22:31.803	2	5
31	2016-01-12 19:24:17.441	2016-01-12 19:24:17.441	23	5
37	2016-01-12 19:31:05.036	2016-01-12 19:31:05.036	97	7
41	2016-01-12 19:33:57.589	2016-01-12 19:33:57.589	553	7
43	2016-01-12 19:34:04.834	2016-01-12 19:34:04.834	95	7
47	2016-01-12 19:34:59.714	2016-01-12 19:34:59.714	609	7
49	2016-01-12 19:35:39.533	2016-01-12 19:35:39.533	556	7
53	2016-01-12 19:38:54.606	2016-01-12 19:38:54.606	28	6
54	2016-01-12 19:40:23.235	2016-01-12 19:40:23.235	27	6
\.


--
-- Name: cards_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('cards_users_id_seq', 56, true);


--
-- Data for Name: checklist_items; Type: TABLE DATA; Schema: public; Owner: -
--

COPY checklist_items (id, created, modified, user_id, card_id, checklist_id, name, is_completed, "position") FROM stdin;
2	2015-05-25 12:47:17.752917	2015-05-25 12:47:17.752917	12	163	2	Pinned tiles on the new tab page can be synced	f	1
3	2015-05-25 12:47:30.80108	2015-05-25 12:47:30.80108	12	163	2	Support for the full HTTP/2 protocol. HTTP/2 enables a faster, more scalable, and more responsive web.	f	2
4	2015-05-25 12:47:40.095485	2015-05-25 12:47:40.095485	12	163	2	Locale added: Uzbek (uz)	f	3
5	2015-05-25 12:48:05.982728	2015-05-25 12:48:05.982728	12	164	3	-remote option removed	f	1
6	2015-05-25 12:48:14.683961	2015-05-25 12:48:14.683961	12	164	3	No longer accept insecure RC4 ciphers whenever possible	f	2
7	2015-05-25 12:48:22.186636	2015-05-25 12:48:22.186636	12	164	3	Phasing out Certificates with 1024-bit RSA Keys	f	3
8	2015-05-25 12:48:31.981973	2015-05-25 12:48:31.981973	12	164	3	Shut down hangs will now show the crash reporter before exiting the program	f	4
9	2015-05-25 12:48:40.80605	2015-05-25 12:48:40.80605	12	164	3	Add-on Compatibility	f	5
10	2015-05-25 12:49:15.127001	2015-05-25 12:49:15.127001	12	173	4	Support for the ECMAScript 6 Symbol data type added	f	1
11	2015-05-25 12:49:22.38696	2015-05-25 12:49:22.38696	12	173	4	unicode-range CSS descriptor implemented	f	2
12	2015-05-25 12:49:29.488504	2015-05-25 12:49:29.488504	12	173	4	CSSOM-View scroll behavior implemented allowing smooth scrolling of content without custom libraries	f	3
13	2015-05-25 12:49:38.230757	2015-05-25 12:49:38.230757	12	173	4	object-fit and object-position implemented.	f	4
14	2015-05-25 12:49:38.552258	2015-05-25 12:49:38.552258	12	173	4	Defines how and where the content of a replaced element is displayed	f	5
15	2015-05-25 12:49:46.850776	2015-05-25 12:49:46.850776	12	173	4	isolation CSS property implemented.	f	6
16	2015-05-25 12:49:46.964508	2015-05-25 12:49:46.964508	12	173	4	Create a new stacking context to isolate groups of boxes to control which blend together	f	7
17	2015-05-25 12:49:54.401963	2015-05-25 12:49:54.401963	12	173	4	CSS3 will-change property implemented.	f	8
18	2015-05-25 12:49:54.509258	2015-05-25 12:49:54.509258	12	173	4	Hints the browser of elements that will be modified. The browser will perform some performance optimization for these	f	9
19	2015-05-25 12:50:09.729773	2015-05-25 12:50:09.729773	12	173	4	Improved ES6 generators for better performance	f	10
20	2015-05-25 12:50:22.645854	2015-05-25 12:50:22.645854	12	173	4	Changed JavaScript ''const'' semantics to conform better to the ES6 specification.	f	11
21	2015-05-25 12:50:22.728593	2015-05-25 12:50:22.728593	12	173	4	The const declaration is now block-scoped and requires an initializer. It also can not be redeclared anymore.	f	12
22	2015-05-25 12:51:27.889039	2015-05-25 12:51:27.889039	12	174	5	Eval sources now appear in the Debugger	f	1
23	2015-05-25 12:51:27.951108	2015-05-25 12:51:27.951108	12	174	5	Debug JavaScript code that is evaluated dynamically, either as a string passed to eval() or as a string passed to the Function constructor	f	2
24	2015-05-25 12:52:07.095954	2015-05-25 12:52:07.095954	12	174	5	DOM Promises inspection	f	3
25	2015-05-25 12:52:13.723759	2015-05-25 12:52:13.723759	12	174	5	Inspector: More paste options in markup view	f	4
29	2015-05-25 12:54:55.156129	2015-05-25 12:54:55.156129	12	207	7	Style Editor: Extra white space appearing above the editor for a sourcemapped scss file	f	1
30	2015-05-25 12:55:00.784383	2015-05-25 12:55:00.784383	12	207	7	For users who removed the Share & Hello buttons, this new version brings them back unexpectedly	f	2
31	2015-05-25 12:55:07.687018	2015-05-25 12:55:07.687018	12	207	7	Firefox Hello does not work for link generators if there is no camera installed	f	3
32	2015-05-25 12:58:18.074166	2015-05-25 12:58:18.074166	12	223	8	Pinned tiles on the new tab page can be synced	f	1
34	2015-05-25 12:58:29.740816	2015-05-25 12:58:29.740816	12	223	8	Locale added: Uzbek (uz)	f	3
35	2015-05-25 12:59:08.45197	2015-05-25 12:59:08.45197	12	235	9	No longer accept insecure RC4 ciphers whenever possible	f	1
37	2015-05-25 12:59:18.016336	2015-05-25 12:59:18.016336	12	235	9	Shut down hangs will now show the crash reporter before exiting the program	f	3
39	2015-05-25 12:59:57.412906	2015-05-25 12:59:57.412906	12	246	10	Support for the ECMAScript 6 Symbol data type added	f	1
40	2015-05-25 13:00:01.207067	2015-05-25 13:00:01.207067	12	246	10	unicode-range CSS descriptor implemented	f	2
41	2015-05-25 13:00:06.130601	2015-05-25 13:00:06.130601	12	246	10	CSSOM-View scroll behavior implemented allowing smooth scrolling of content without custom libraries	f	3
42	2015-05-25 13:00:12.900992	2015-05-25 13:00:12.900992	12	246	10	object-fit and object-position implemented.	f	4
43	2015-05-25 13:00:12.957907	2015-05-25 13:00:12.957907	12	246	10	Defines how and where the content of a replaced element is displayed	f	5
44	2015-05-25 13:00:22.882642	2015-05-25 13:00:22.882642	12	246	10	isolation CSS property implemented.	f	6
45	2015-05-25 13:00:22.968109	2015-05-25 13:00:22.968109	12	246	10	Create a new stacking context to isolate groups of boxes to control which blend together	f	7
46	2015-05-25 13:00:27.879447	2015-05-25 13:00:27.879447	12	246	10	CSS3 will-change property implemented.	f	8
47	2015-05-25 13:00:27.99656	2015-05-25 13:00:27.99656	12	246	10	Hints the browser of elements that will be modified. The browser will perform some performance optimization for these	f	9
48	2015-05-25 13:00:34.108206	2015-05-25 13:00:34.108206	12	246	10	Improved ES6 generators for better performance	f	10
49	2015-05-25 13:00:44.013624	2015-05-25 13:00:44.013624	12	246	10	Changed JavaScript ''const'' semantics to conform better to the ES6 specification.	f	11
50	2015-05-25 13:00:44.091294	2015-05-25 13:00:44.091294	12	246	10	The const declaration is now block-scoped and requires an initializer. It also can not be redeclared anymore.	f	12
51	2015-05-25 13:01:12.995529	2015-05-25 13:01:12.995529	12	269	11	Eval sources now appear in the Debugger	f	1
52	2015-05-25 13:01:13.087751	2015-05-25 13:01:13.087751	12	269	11	Debug JavaScript code that is evaluated dynamically, either as a string passed to eval() or as a string passed to the Function constructor	f	2
53	2015-05-25 13:01:18.81139	2015-05-25 13:01:18.81139	12	269	11	DOM Promises inspection	f	3
54	2015-05-25 13:01:24.959125	2015-05-25 13:01:24.959125	12	269	11	Inspector: More paste options in markup view	f	4
28	2015-05-25 12:54:10.634212	2015-05-25 13:52:49.316047	12	180	6	Fix some unexpected logout from Facebook or Google after restart	t	3
55	2015-05-25 13:02:02.026828	2015-05-25 13:52:59.377669	12	279	12	Hello may become inactive until restart	t	1
73	2015-05-25 13:09:08.007695	2015-05-25 13:09:08.007695	12	342	13	Style Editor: Extra white space appearing above the editor for a sourcemapped scss file	f	1
38	2015-05-25 12:59:24.355915	2016-01-12 19:04:09.666	12	235	9	Add-on Compatibility	t	4
36	2015-05-25 12:59:13.154767	2016-01-12 19:04:10.895	12	235	9	Phasing out Certificates with 1024-bit RSA Keys	t	2
74	2015-05-25 13:09:14.333301	2015-05-25 13:09:14.333301	12	342	13	For users who removed the Share & Hello buttons, this new version brings them back unexpectedly	f	2
75	2015-05-25 13:09:20.004172	2015-05-25 13:09:20.004172	12	342	13	Firefox Hello does not work for link generators if there is no camera installed	f	3
76	2015-05-25 13:10:42.142881	2015-05-25 13:10:42.142881	12	351	14	Pinned tiles on the new tab page can be synced	f	1
77	2015-05-25 13:10:47.302093	2015-05-25 13:10:47.302093	12	351	14	Support for the full HTTP/2 protocol. HTTP/2 enables a faster, more scalable, and more responsive web.	f	2
78	2015-05-25 13:10:52.516612	2015-05-25 13:10:52.516612	12	351	14	Locale added: Uzbek (uz)	f	3
79	2015-05-25 13:11:23.333053	2015-05-25 13:11:23.333053	12	352	15	No longer accept insecure RC4 ciphers whenever possible	f	1
80	2015-05-25 13:11:28.32541	2015-05-25 13:11:28.32541	12	352	15	Phasing out Certificates with 1024-bit RSA Keys	f	2
81	2015-05-25 13:11:33.518619	2015-05-25 13:11:33.518619	12	352	15	Shut down hangs will now show the crash reporter before exiting the program	f	3
82	2015-05-25 13:11:39.590184	2015-05-25 13:11:39.590184	12	352	15	Add-on Compatibility	f	4
83	2015-05-25 13:12:39.734647	2015-05-25 13:12:39.734647	12	353	16	Support for the ECMAScript 6 Symbol data type added	f	1
84	2015-05-25 13:12:44.405544	2015-05-25 13:12:44.405544	12	353	16	unicode-range CSS descriptor implemented	f	2
85	2015-05-25 13:12:49.492694	2015-05-25 13:12:49.492694	12	353	16	CSSOM-View scroll behavior implemented allowing smooth scrolling of content without custom libraries	f	3
86	2015-05-25 13:12:54.99402	2015-05-25 13:12:54.99402	12	353	16	object-fit and object-position implemented.	f	4
87	2015-05-25 13:12:55.066138	2015-05-25 13:12:55.066138	12	353	16	Defines how and where the content of a replaced element is displayed	f	5
88	2015-05-25 13:13:01.39166	2015-05-25 13:13:01.39166	12	353	16	isolation CSS property implemented.	f	6
89	2015-05-25 13:13:01.496998	2015-05-25 13:13:01.496998	12	353	16	Create a new stacking context to isolate groups of boxes to control which blend together	f	7
90	2015-05-25 13:13:07.639767	2015-05-25 13:13:07.639767	12	353	16	CSS3 will-change property implemented.	f	8
91	2015-05-25 13:13:07.68309	2015-05-25 13:13:07.68309	12	353	16	Hints the browser of elements that will be modified. The browser will perform some performance optimization for these	f	9
92	2015-05-25 13:13:14.229008	2015-05-25 13:13:14.229008	12	353	16	Improved ES6 generators for better performance	f	10
93	2015-05-25 13:13:20.739142	2015-05-25 13:13:20.739142	12	353	16	Changed JavaScript ''const'' semantics to conform better to the ES6 specification.	f	11
94	2015-05-25 13:13:20.852819	2015-05-25 13:13:20.852819	12	353	16	The const declaration is now block-scoped and requires an initializer. It also can not be redeclared anymore.	f	12
95	2015-05-25 13:13:52.210257	2015-05-25 13:13:52.210257	12	354	17	Eval sources now appear in the Debugger	f	1
96	2015-05-25 13:13:52.305503	2015-05-25 13:13:52.305503	12	354	17	Debug JavaScript code that is evaluated dynamically, either as a string passed to eval() or as a string passed to the Function constructor	f	2
97	2015-05-25 13:14:00.328431	2015-05-25 13:14:00.328431	12	354	17	DOM Promises inspection	f	3
98	2015-05-25 13:14:06.467786	2015-05-25 13:14:06.467786	12	354	17	Inspector: More paste options in markup view	f	4
112	2015-05-25 13:17:59.429905	2015-05-25 13:17:59.429905	12	397	19	Style Editor: Extra white space appearing above the editor for a sourcemapped scss file	f	1
113	2015-05-25 13:18:08.490504	2015-05-25 13:18:08.490504	12	397	19	For users who removed the Share & Hello buttons, this new version brings them back unexpectedly	f	2
114	2015-05-25 13:18:16.938492	2015-05-25 13:18:16.938492	12	397	19	Firefox Hello does not work for link generators if there is no camera installed	f	3
115	2015-05-25 13:20:04.624751	2015-05-25 13:20:04.624751	12	415	20	Pinned tiles on the new tab page can be synced	f	1
116	2015-05-25 13:20:09.836865	2015-05-25 13:20:09.836865	12	415	20	Support for the full HTTP/2 protocol. HTTP/2 enables a faster, more scalable, and more responsive web.	f	2
117	2015-05-25 13:20:14.994107	2015-05-25 13:20:14.994107	12	415	20	Locale added: Uzbek (uz)	f	3
57	2015-05-25 13:02:14.286379	2015-05-25 13:53:01.85671	12	279	12	Hello contact tabs may not be visible	t	3
58	2015-05-25 13:02:21.419339	2015-05-25 13:53:15.051731	12	279	12	Disable the usage of the ANY DNS query type	t	4
59	2015-05-25 13:02:27.441823	2015-05-25 13:53:16.561202	12	279	12	Fixed a startup crash with EMET	t	5
60	2015-05-25 13:02:34.422915	2015-05-25 13:53:23.498125	12	279	12	WebGL may use significant memory with Canvas2d	t	6
62	2015-05-25 13:02:48.280314	2015-05-25 13:53:39.167957	12	279	12	Option -remote has been restored	t	8
63	2015-05-25 13:02:53.768406	2015-05-25 13:53:49.337455	12	279	12	Fix a top crash	t	9
70	2015-05-25 13:07:19.16978	2015-05-25 13:54:01.981465	12	279	12	Various security fixes	t	13
71	2015-05-25 13:07:28.366697	2015-05-25 13:54:06.534257	12	279	12	CSS gradients work on premultiplied colors	t	14
72	2015-05-25 13:07:33.378728	2015-05-25 13:55:58.062541	12	279	12	Fix some unexpected logout from Facebook or Google after restart	t	15
99	2015-05-25 13:14:37.838567	2015-05-25 14:26:35.305538	12	357	18	Security fixes for issues disclosed at HP Zero Day Initiative''s Pwn2Own contest	t	1
100	2015-05-25 13:14:48.737821	2015-05-25 14:31:10.097249	12	357	18	Hello may become inactive until restart	t	2
101	2015-05-25 13:14:54.355745	2015-05-25 14:44:00.458403	12	357	18	Print preferences may not be preserved	t	3
102	2015-05-25 13:14:59.939757	2015-05-25 14:44:02.485437	12	357	18	Hello contact tabs may not be visible	t	4
103	2015-05-25 13:15:06.534911	2015-05-25 14:44:09.12198	12	357	18	Disable the usage of the ANY DNS query type	t	5
104	2015-05-25 13:15:12.44366	2015-05-25 14:44:10.407428	12	357	18	Fixed a startup crash with EMET	t	6
105	2015-05-25 13:15:20.176731	2015-05-25 14:44:22.637074	12	357	18	WebGL may use significant memory with Canvas2d	t	7
106	2015-05-25 13:15:26.689491	2015-05-25 14:46:05.663693	12	357	18	Accept hostnames that include an underscore character ("_")	t	8
107	2015-05-25 13:15:32.127669	2015-05-25 14:46:28.423655	12	357	18	Option -remote has been restored	t	9
108	2015-05-25 13:15:39.899617	2015-05-25 14:47:50.287384	12	357	18	Fix a top crash	t	10
109	2015-05-25 13:15:45.076396	2015-05-25 14:57:35.780088	12	357	18	Various security fixes	t	11
111	2015-05-25 13:15:58.103153	2015-05-25 14:57:33.513106	12	357	18	Fix some unexpected logout from Facebook or Google after restart	t	13
110	2015-05-25 13:15:50.786252	2015-05-25 14:57:31.066399	12	357	18	CSS gradients work on premultiplied colors	t	12
118	2015-05-25 13:20:53.816571	2015-05-25 13:20:53.816571	12	426	21	No longer accept insecure RC4 ciphers whenever possible	f	1
119	2015-05-25 13:20:58.945655	2015-05-25 13:20:58.945655	12	426	21	Phasing out Certificates with 1024-bit RSA Keys	f	2
120	2015-05-25 13:21:05.697101	2015-05-25 13:21:05.697101	12	426	21	Shut down hangs will now show the crash reporter before exiting the program	f	3
121	2015-05-25 13:25:11.189281	2015-05-25 13:25:11.189281	12	426	21	Add-on Compatibility	f	4
123	2015-05-25 13:25:42.253182	2015-05-25 13:25:42.253182	12	435	22	unicode-range CSS descriptor implemented	f	2
125	2015-05-25 13:26:29.506587	2015-05-25 13:26:29.506587	12	435	22	object-fit and object-position implemented.	f	4
188	2015-05-25 13:43:37.601041	2015-05-25 13:43:37.601041	12	587	36	BroadcastChannel API implemented	f	2
126	2015-05-25 13:26:29.598388	2015-05-25 13:26:29.598388	12	435	22	Defines how and where the content of a replaced element is displayed	f	5
127	2015-05-25 13:26:35.329186	2015-05-25 13:26:35.329186	12	435	22	isolation CSS property implemented.	f	6
129	2015-05-25 13:26:43.019475	2015-05-25 13:26:43.019475	12	435	22	CSS3 will-change property implemented.	f	8
130	2015-05-25 13:26:43.085773	2015-05-25 13:26:43.085773	12	435	22	Hints the browser of elements that will be modified. The browser will perform some performance optimization for these	f	9
131	2015-05-25 13:26:48.976034	2015-05-25 13:26:48.976034	12	435	22	Improved ES6 generators for better performance	f	10
132	2015-05-25 13:26:57.134067	2015-05-25 13:26:57.134067	12	435	22	Changed JavaScript ''const'' semantics to conform better to the ES6 specification.	f	11
133	2015-05-25 13:26:57.217707	2015-05-25 13:26:57.217707	12	435	22	The const declaration is now block-scoped and requires an initializer. It also can not be redeclared anymore.	f	12
134	2015-05-25 13:27:28.418219	2015-05-25 13:27:28.418219	12	447	23	Eval sources now appear in the Debugger	f	1
135	2015-05-25 13:27:28.523951	2015-05-25 13:27:28.523951	12	447	23	Debug JavaScript code that is evaluated dynamically, either as a string passed to eval() or as a string passed to the Function constructor	f	2
136	2015-05-25 13:27:43.510575	2015-05-25 13:27:43.510575	12	447	23	DOM Promises inspection	f	3
137	2015-05-25 13:27:48.953083	2015-05-25 13:27:48.953083	12	447	23	Inspector: More paste options in markup view	f	4
139	2015-05-25 13:29:13.341087	2015-05-25 14:58:52.591869	12	456	24	36.0.3: Security fixes for issues disclosed at HP Zero Day Initiative''s Pwn2Own contest	t	2
152	2015-05-25 13:31:42.43668	2015-05-25 13:31:42.43668	12	492	25	Style Editor: Extra white space appearing above the editor for a sourcemapped scss file	f	1
153	2015-05-25 13:31:47.911255	2015-05-25 13:31:47.911255	12	492	25	For users who removed the Share & Hello buttons, this new version brings them back unexpectedly	f	2
154	2015-05-25 13:31:53.864803	2015-05-25 13:31:53.864803	12	492	25	Firefox Hello does not work for link generators if there is no camera installed	f	3
155	2015-05-25 13:34:12.362597	2015-05-25 13:34:12.362597	12	510	26	Heartbeat user rating system - your feedback about Firefox	f	1
156	2015-05-25 13:34:17.85837	2015-05-25 13:34:17.85837	12	510	26	Yandex set as default search provider for the Turkish locale	f	2
157	2015-05-25 13:34:22.801605	2015-05-25 13:34:22.801605	12	510	26	Bing search now uses HTTPS for secure searching	f	3
158	2015-05-25 13:34:28.585005	2015-05-25 13:34:28.585005	12	510	26	Improved protection against site impersonation via OneCRL centralized certificate revocation	f	4
159	2015-05-25 13:34:34.191104	2015-05-25 13:34:34.191104	12	510	26	Opportunistically encrypt HTTP traffic where the server supports HTTP/2 AltSvc	f	5
160	2015-05-25 13:35:43.883879	2015-05-25 13:35:43.883879	12	524	27	Disabled insecure TLS version fallback for site security	f	1
161	2015-05-25 13:35:50.148655	2015-05-25 13:35:50.148655	12	524	27	Improved certificate and TLS communication security by removing support for DSA	f	2
162	2015-05-25 13:35:54.651744	2015-05-25 13:35:54.651744	12	524	27	Extended SSL error reporting for reporting non-certificate errors	f	3
163	2015-05-25 13:35:59.654029	2015-05-25 13:35:59.654029	12	524	27	TLS False Start optimization now requires a cipher suite using AEAD construction	f	4
164	2015-05-25 13:36:19.460145	2015-05-25 13:36:19.460145	12	524	27	Improved performance of WebGL rendering on Windows	f	5
166	2015-05-25 13:37:00.660496	2015-05-25 13:37:00.660496	12	538	28	IndexedDB now accessible from worker threads	f	2
168	2015-05-25 13:37:36.823241	2015-05-25 13:37:36.823241	12	549	29	Debug tabs opened in Chrome Desktop, Chrome for Android, and Safari for iOS	f	1
169	2015-05-25 13:37:42.005475	2015-05-25 13:37:42.005475	12	549	29	New Inspector animations panel to control element animations	f	2
170	2015-05-25 13:37:47.15782	2015-05-25 13:37:47.15782	12	549	29	New Security Panel included in Network Panel	f	3
171	2015-05-25 13:37:52.606855	2015-05-25 13:37:52.606855	12	549	29	Debugger panel support for chrome:// and about:// URIs	f	4
140	2015-05-25 13:29:51.939885	2015-05-25 14:59:03.305028	12	456	24	36.0.1 - Hello may become inactive until restart	t	3
141	2015-05-25 13:29:58.078311	2015-05-25 15:00:35.622473	12	456	24	36.0.1 - Print preferences may not be preserved	t	4
142	2015-05-25 13:30:19.618827	2015-05-25 15:00:39.9073	12	456	24	36.0.1 - Hello contact tabs may not be visible	t	5
143	2015-05-25 13:30:26.059659	2015-05-25 15:00:46.400546	12	456	24	36.0.1 - Disable the usage of the ANY DNS query type	t	6
144	2015-05-25 13:30:31.685452	2015-05-25 15:00:57.158869	12	456	24	36.0.1 - Fixed a startup crash with EMET	t	7
145	2015-05-25 13:30:40.264782	2015-05-25 15:01:05.146203	12	456	24	36.0.1 - WebGL may use significant memory with Canvas2d	t	8
146	2015-05-25 13:30:46.771793	2015-05-25 15:01:24.082316	12	456	24	36.0.1 - Accept hostnames that include an underscore character ("_")	t	9
147	2015-05-25 13:30:54.909274	2015-05-25 15:01:41.669704	12	456	24	36.0.1 - Option -remote has been restored	t	10
148	2015-05-25 13:31:01.58923	2015-05-25 15:02:54.863286	12	456	24	36.0.1 - Fix a top crash	t	11
151	2015-05-25 13:31:15.635503	2015-05-25 15:03:16.799348	12	456	24	Fix some unexpected logout from Facebook or Google after restart	t	14
150	2015-05-25 13:31:10.30439	2015-05-25 15:03:20.161121	12	456	24	CSS gradients work on premultiplied colors	t	13
149	2015-05-25 13:31:06.271816	2015-05-25 15:03:23.441423	12	456	24	Various security fixes	t	12
172	2015-05-25 13:37:59.181367	2015-05-25 13:37:59.181367	12	549	29	Added logging of weak ciphers to the web console	f	5
174	2015-05-25 13:39:38.13735	2015-05-25 13:39:38.13735	12	551	31	Disabled HTTP/2 AltSvc	f	1
180	2015-05-25 13:42:11.468835	2015-05-25 13:42:11.468835	12	564	34	New tab-based preferences	f	1
181	2015-05-25 13:42:16.274839	2015-05-25 13:42:16.274839	12	564	34	Ruby annotation support	f	2
182	2015-05-25 13:42:21.260057	2015-05-25 13:42:21.260057	12	564	34	Base for the next ESR release.	f	3
167	2015-05-25 13:37:05.189452	2016-01-12 19:03:33.157	12	538	28	New SDP/JSEP implementation in WebRTC	t	3
122	2015-05-25 13:25:37.57685	2016-01-12 19:03:39.841	12	435	22	Support for the ECMAScript 6 Symbol data type added	t	1
124	2015-05-25 13:25:46.92243	2016-01-12 19:03:44.843	12	435	22	CSSOM-View scroll behavior implemented allowing smooth scrolling of content without custom libraries	t	3
128	2015-05-25 13:26:35.415711	2016-01-12 19:03:48.985	12	435	22	Create a new stacking context to isolate groups of boxes to control which blend together	t	7
183	2015-05-25 13:42:52.56238	2015-05-25 13:42:52.56238	12	577	35	autocomplete=off is no longer supported for username/password fields	f	1
184	2015-05-25 13:42:58.085874	2015-05-25 13:42:58.085874	12	577	35	URL parser avoids doing percent encoding when setting the Fragment part of the URL, and percent decoding when getting the Fragment in line with the URL spec	f	2
186	2015-05-25 13:43:08.95347	2015-05-25 13:43:08.95347	12	577	35	Improved page load times via speculative connection warmup	f	4
187	2015-05-25 13:43:33.223867	2015-05-25 13:43:33.223867	12	587	36	WebSocket now available in Web Workers	f	1
189	2015-05-25 13:43:42.760051	2015-05-25 13:43:42.760051	12	587	36	Implemented srcset attribute and <picture> element for responsive images	f	3
190	2015-05-25 13:43:49.591484	2015-05-25 13:43:49.591484	12	587	36	Implemented DOM3 Events KeyboardEvent.code	f	4
191	2015-05-25 13:43:54.782791	2015-05-25 13:43:54.782791	12	587	36	Mac OS X: Implemented a subset of the Media Source Extensions (MSE) API to allow native HTML5 playback on YouTube	f	5
192	2015-05-25 13:44:01.785955	2015-05-25 13:44:01.785955	12	587	36	Implemented Encrypted Media Extensions (EME) API to support encrypted HTML5 video/audio playback (Windows Vista or later only)	f	6
193	2015-05-25 13:44:07.242319	2015-05-25 13:44:07.242319	12	587	36	Automatically download Adobe Primetime Content Decryption Module (CDM) for DRM playback through EME (Windows Vista or later only)	f	7
194	2015-05-25 13:44:28.320811	2015-05-25 13:44:28.320811	12	601	37	Optimized-out variables are now visible in Debugger UI	f	1
195	2015-05-25 13:44:33.354148	2015-05-25 13:44:33.354148	12	601	37	XMLHttpRequest logs in the web console are now visually labelled and can be filtered separately from regular network requests	f	2
196	2015-05-25 13:44:40.375742	2015-05-25 13:44:40.375742	12	601	37	WebRTC now has multistream and renegotiation support	f	3
197	2015-05-25 13:44:44.842532	2015-05-25 13:44:44.842532	12	601	37	copy command added to console	f	4
199	2015-05-25 13:45:40.178103	2015-05-25 13:45:40.178103	12	605	39	Responsive images do not update when the enclosing viewport changes	f	1
204	2015-05-25 13:47:27.851626	2015-05-25 13:47:27.851626	12	607	41	Responsive images do not update when the enclosing viewport changes	f	1
26	2015-05-25 12:54:01.04803	2015-05-25 13:52:47.10325	12	180	6	Various security fixes	t	1
27	2015-05-25 12:54:05.862787	2015-05-25 13:52:48.368878	12	180	6	CSS gradients work on premultiplied colors	t	2
56	2015-05-25 13:02:07.796507	2015-05-25 13:53:00.387807	12	279	12	Print preferences may not be preserved	t	2
61	2015-05-25 13:02:41.043935	2015-05-25 13:53:31.166366	12	279	12	Accept hostnames that include an underscore character	t	7
173	2015-05-25 13:38:27.656384	2015-05-25 13:56:54.837427	12	550	30	Various security fixes	t	1
175	2015-05-25 13:40:01.231288	2015-05-25 13:58:09.906752	12	552	32	Start-up crash due to graphics hardware and third party software	t	1
198	2015-05-25 13:45:08.747339	2015-05-25 15:02:50.42559	12	604	38	Various security fixes	t	1
176	2015-05-25 13:40:05.627797	2015-05-25 14:57:58.264679	12	552	32	Various security fixes	t	2
177	2015-05-25 13:41:01.966229	2015-05-25 14:58:09.238453	12	554	33	Google Maps may render incorrectly in some cases	t	1
178	2015-05-25 13:41:06.629015	2015-05-25 14:58:10.973504	12	554	33	Stability fixes for select graphics hardware and feature sets	t	2
179	2015-05-25 13:41:12.007711	2015-05-25 14:58:13.149791	12	554	33	Various security fixes	t	3
138	2015-05-25 13:28:21.602479	2015-05-25 14:58:27.287398	12	456	24	36.0.4: Security fixes for issues disclosed at HP Zero Day Initiative's Pwn2Own contest	t	1
200	2015-05-25 13:46:41.974002	2015-05-25 14:59:05.411406	12	606	40	Systems with first generation NVidia Optimus graphics cards may crash on start-up	t	1
201	2015-05-25 13:46:47.070374	2015-05-25 14:59:13.622998	12	606	40	Users who import cookies from Google Chrome can end up with broken websites	t	2
202	2015-05-25 13:46:57.723577	2015-05-25 14:59:23.002907	12	606	40	Large animated images may fail to play and may stop other images from loading	t	3
203	2015-05-25 13:47:03.123166	2015-05-25 15:01:32.675307	12	606	40	WebRTC H264 video streams from CiscoSpark native clients are not decoded correctly. (Fixed in Firefox ESR 38.0.1; was already fixed in Firefox 38.0)	t	4
165	2015-05-25 13:36:55.725204	2016-01-12 19:03:31.064	12	538	28	Added support for CSS display:contents	t	1
33	2015-05-25 12:58:23.972747	2016-01-12 19:04:00.655	12	223	8	Support for the full HTTP/2 protocol. HTTP/2 enables a faster, more scalable, and more responsive web.	t	2
185	2015-05-25 13:43:03.951397	2016-01-12 19:06:47.679	12	577	35	RegExp.prototype.source now returns "(?:)" instead of the empty string for empty regular expressions	t	3
205	2016-01-12 19:36:46.049	2016-01-12 19:36:46.049	7	609	43	q1	f	1
\.


--
-- Name: checklist_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('checklist_items_id_seq', 205, true);


--
-- Data for Name: checklists; Type: TABLE DATA; Schema: public; Owner: -
--

COPY checklists (id, created, modified, user_id, card_id, name, checklist_item_count, checklist_item_completed_count, "position") FROM stdin;
20	2015-05-25 13:19:57.290699	2015-05-25 13:19:57.290699	12	415	Checklist	3	0	1
7	2015-05-25 12:54:30.958204	2015-05-25 12:54:30.958204	12	207	Checklist	3	0	1
16	2015-05-25 13:12:14.067232	2015-05-25 13:12:14.067232	12	353	Checklist	12	0	1
2	2015-05-25 12:47:07.799161	2015-05-25 12:47:07.799161	12	163	Checklist	3	0	1
26	2015-05-25 13:34:02.191945	2015-05-25 13:34:02.191945	12	510	Checklist	5	0	1
3	2015-05-25 12:47:51.668111	2015-05-25 12:47:51.668111	12	164	Checklist	5	0	1
38	2015-05-25 13:45:00.944983	2015-05-25 13:45:00.944983	12	604	Checklist	1	1	1
17	2015-05-25 13:13:42.676554	2015-05-25 13:13:42.676554	12	354	Checklist	4	0	1
21	2015-05-25 13:20:40.353885	2015-05-25 13:20:40.353885	12	426	Checklist	4	0	1
36	2015-05-25 13:43:25.805526	2015-05-25 13:43:25.805526	12	587	Checklist	7	0	1
13	2015-05-25 13:08:57.266019	2015-05-25 13:08:57.266019	12	342	Checklist	3	0	1
14	2015-05-25 13:10:32.305097	2015-05-25 13:10:32.305097	12	351	Checklist	3	0	1
27	2015-05-25 13:35:07.323654	2015-05-25 13:35:07.323654	12	524	Checklist	5	0	1
33	2015-05-25 13:40:54.1782	2015-05-25 13:40:54.1782	12	554	Checklist	3	3	1
4	2015-05-25 12:49:01.740286	2015-05-25 12:49:01.740286	12	173	Checklist	12	0	1
34	2015-05-25 13:42:03.973582	2015-05-25 13:42:03.973582	12	564	Checklist	3	0	1
15	2015-05-25 13:11:12.301003	2015-05-25 13:11:12.301003	12	352	Checklist	4	0	1
10	2015-05-25 12:59:44.911089	2015-05-25 12:59:44.911089	12	246	Checklist	12	0	1
5	2015-05-25 12:51:19.512441	2015-05-25 12:51:19.512441	12	174	Checklist	4	0	1
37	2015-05-25 13:44:19.960393	2015-05-25 13:44:19.960393	12	601	Checklist	4	0	1
6	2015-05-25 12:52:36.648603	2015-05-25 12:52:36.648603	12	180	Checklist	3	3	1
11	2015-05-25 13:01:03.500574	2015-05-25 13:01:03.500574	12	269	Checklist	4	0	1
40	2015-05-25 13:46:33.278025	2015-05-25 13:46:33.278025	12	606	Checklist	4	4	1
19	2015-05-25 13:17:48.633723	2015-05-25 13:17:48.633723	12	397	Checklist	3	0	1
29	2015-05-25 13:37:27.489726	2015-05-25 13:37:27.489726	12	549	Checklist	5	0	1
25	2015-05-25 13:31:33.204633	2015-05-25 13:31:33.204633	12	492	Checklist	3	0	1
23	2015-05-25 13:27:19.427303	2015-05-25 13:27:19.427303	12	447	Checklist	4	0	1
39	2015-05-25 13:45:31.705478	2015-05-25 13:45:31.705478	12	605	Checklist	1	0	1
31	2015-05-25 13:39:29.345845	2015-05-25 13:39:29.345845	12	551	Checklist	1	0	1
18	2015-05-25 13:14:24.605889	2015-05-25 13:14:24.605889	12	357	Checklist	13	13	1
12	2015-05-25 13:01:49.032404	2015-05-25 13:01:49.032404	12	279	Checklist	12	12	1
32	2015-05-25 13:39:53.914632	2015-05-25 13:39:53.914632	12	552	Checklist	2	2	1
24	2015-05-25 13:28:07.412157	2015-05-25 13:28:07.412157	12	456	Checklist	14	14	1
41	2015-05-25 13:47:20.250132	2015-05-25 13:47:20.250132	12	607	Checklist	1	0	1
30	2015-05-25 13:38:17.714125	2015-05-25 13:38:17.714125	12	550	Checklist	1	1	1
9	2015-05-25 12:58:57.236305	2015-05-25 12:58:57.236305	12	235	Checklist	4	2	1
28	2015-05-25 13:36:45.445791	2015-05-25 13:36:45.445791	12	538	Checklist	3	2	1
35	2015-05-25 13:42:41.018564	2015-05-25 13:42:41.018564	12	577	Checklist	4	1	1
43	2016-01-12 19:36:34.997	2016-01-12 19:36:34.997	7	609	Checklist	1	0	1
44	2016-01-12 19:39:10.089	2016-01-12 19:39:10.089	6	28	Checklist	0	0	1
22	2015-05-25 13:25:28.725317	2015-05-25 13:25:28.725317	12	435	Checklist	12	3	1
8	2015-05-25 12:58:05.68916	2015-05-25 12:58:05.68916	12	223	Checklist	3	1	1
\.


--
-- Name: checklists_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('checklists_id_seq', 44, true);


--
-- Data for Name: cities; Type: TABLE DATA; Schema: public; Owner: -
--

COPY cities (id, created, modified, country_id, state_id, latitude, longitude, name, is_active) FROM stdin;
1	2015-05-21 11:45:47.245	2015-05-21 11:45:47.245	240	1	42.1508	-70.8228	Norwell	f
3	2016-01-12 17:00:46.039	2016-01-12 17:00:46.039	102	3	20	77		f
\.


--
-- Name: cities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('cities_id_seq', 15178, false);


--
-- Name: cities_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('cities_id_seq1', 3, true);


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
138	MH	MHL	584	RM	Marshall Islands	Majuro	181.300000000000011	65859	OC	.mh	USD	Dollar              	692       	                    	                    	mh,en-MH	2080185	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
139	MQ	MTQ	474	MB	Martinique	Fort-de-France	1100	432900	NA	.mq	EUR	Euro                	596       	#####               	^(d{5})$            	fr-MQ	3570311	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
140	MR	MRT	478	MR	Mauritania	Nouakchott	1030700	3205060	AF	.mr	MRO	Ouguiya             	222       	                    	                    	ar-MR,fuc,snk,fr,mey,wo	2378080	SN,DZ,EH,ML         	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
141	MU	MUS	480	MP	Mauritius	Port Louis	2040	1294104	AF	.mu	MUR	Rupee               	230       	                    	                    	en-MU,bho,fr	934292	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
142	YT	MYT	175	MF	Mayotte	Mamoudzou	374	159042	AF	.yt	EUR	Euro                	262       	#####               	^(d{5})$            	fr-YT	1024031	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
143	MX	MEX	484	MX	Mexico	Mexico City	1972550	112468855	NA	.mx	MXN	Peso                	52        	#####               	^(d{5})$            	es-MX	3996063	GT,US,BZ            	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
144	FM	FSM	583	FM	Micronesia	Palikir	702	107708	OC	.fm	USD	Dollar              	691       	#####               	^(d{5})$            	en-FM,chk,pon,yap,kos,uli,woe,nkr,kpg	2081918	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
145	MD	MDA	498	MD	Moldova	Chisinau	33843	4324000	EU	.md	MDL	Leu                 	373       	MD-####             	^(?:MD)*(d{4})$     	ro,ru,gag,tr	617790	RO,UA               	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
146	MC	MCO	492	MN	Monaco	Monaco	1.94999999999999996	32965	EU	.mc	EUR	Euro                	377       	#####               	^(d{5})$            	fr-MC,en,it	2993457	FR                  	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
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
164	NF	NFK	574	NF	Norfolk Island	Kingston	34.6000000000000014	1828	OC	.nf	AUD	Dollar              	672       	                    	                    	en-NF	2155115	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
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
195	SM	SMR	674	SM	San Marino	San Marino	61.2000000000000028	31477	EU	.sm	EUR	Euro                	378       	4789#               	^(4789d)$           	it-SM	3168068	IT                  	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
196	ST	STP	678	TP	Sao Tome and Principe	Sao Tome	1001	175808	AF	.st	STD	Dobra               	239       	                    	                    	pt-ST	2410758	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
197	SA	SAU	682	SA	Saudi Arabia	Riyadh	1960582	25731776	AS	.sa	SAR	Rial                	966       	#####               	^(d{5})$            	ar-SA	102358	QA,OM,IQ,YE,JO,AE,KW	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
198	SN	SEN	686	SG	Senegal	Dakar	196190	12323252	AF	.sn	XOF	Franc               	221       	#####               	^(d{5})$            	fr-SN,wo,fuc,mnk	2245662	GN,MR,GW,GM,ML      	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
199	RS	SRB	688	RI	Serbia	Belgrade	88361	7344847	EU	.rs	RSD	Dinar               	381       	######              	^(d{6})$            	sr,hu,bs,rom	6290252	AL,HU,MK,RO,HR,BA,BG	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
200	CS	SCG	891	YI	Serbia and Montenegro	Belgrade	102350	10829175	EU	.cs	RSD	Dinar               	381       	#####               	^(d{5})$            	cu,hu,sq,sr	0	AL,HU,MK,RO,HR,BA,BG	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
201	SC	SYC	690	SE	Seychelles	Victoria	455	88340	AF	.sc	SCR	Rupee               	248       	                    	                    	en-SC,fr-SC	241170	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
202	SL	SLE	694	SL	Sierra Leone	Freetown	71740	5245695	AF	.sl	SLL	Leone               	232       	                    	                    	en-SL,men,tem	2403846	LR,GN               	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
203	SG	SGP	702	SN	Singapore	Singapur	692.700000000000045	4701069	AS	.sg	SGD	Dollar              	65        	######              	^(d{6})$            	cmn,en-SG,ms-SG,ta-SG,zh-SG	1880251	                    	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
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
245	VA	VAT	336	VT	Vatican	Vatican City	0.440000000000000002	921	EU	.va	EUR	Euro                	379       	                    	                    	la,it,fr	3164670	IT                  	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
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
4	2014-05-08 12:13:50.69	2014-05-08 12:13:50.69	##SITE_NAME## Restyaboard <##FROM_EMAIL##>	##REPLY_TO_EMAIL##	changepassword	We will send this mail to user, when admin change users password.	Restyaboard / Password changed	<html>\n<head><meta http-equiv="Content-Type" content="text/html; charset=utf-8" /></head>\n<body style="margin:0">\n<header style="display:block;width:100%;padding-left:0;padding-right:0; border-bottom:solid 1px #dedede; float:left;background-color: #f7f7f7;">\n<div style="border: 1px solid #EEEEEE;">\n<h1 style="text-align:center;margin:10px 15px 5px;"> <a href="##SITE_URL##" title="##SITE_NAME##"><img src="##SITE_URL##/img/logo.png" alt="[Restyaboard]" title="##SITE_NAME##"></a> </h1>\n</div>\n</header>\n<main style="width:100%;padding-top:10px; padding-bottom:10px; margin:0 auto; float:left;">\n<div style="background-color:#f3f5f7;padding:10px;border: 1px solid #EEEEEE;">\n<div style="width: 500px;background-color: #f3f5f7;margin:0 auto;">\n<pre style="font-family: Arial, Helvetica, sans-serif; font-size: 13px;line-height:20px;"><h2 style="font-size:16px; font-family:Arial, Helvetica, sans-serif; margin: 20px 0px 0px;padding:10px 0px 0px 0px;">Hi,</h2><p style="white-space: normal; width: 100%;margin: 10px 0px 0px; font-family:Arial, Helvetica, sans-serif;"><br></p><p style="white-space: normal; width: 100%;margin: 0px 0px 0px; font-family:Arial, Helvetica, sans-serif;">Admin reset your password for your ##SITE_NAME## account.<br>Your new password: ##PASSWORD##<br></p><br><p style="white-space: normal; width: 100%;margin: 0px 0px 0px;font-family:Arial, Helvetica, sans-serif;">Thanks,<br>\nRestyaboard<br>\n##SITE_URL##</p>\n</pre>\n</div>\n</div>\n</main>\n<footer style="width:100%;padding-left:0;margin:0px auto;border-top: solid 1px #dedede; padding-bottom:10px; background:#fff;clear: both;padding-top: 10px;border-bottom: solid 1px #dedede;background-color: #f7f7f7;">\n<h6 style="text-align:center;margin:5px 15px;"> \n<a href="http://restya.com/board/?utm_source=Restyaboard - ##SITE_NAME##&utm_medium=email&utm_campaign=change_password_email" title="Open source. Trello like kanban board." rel="generator" style="font-size: 11px;text-align: center;text-decoration: none;color: #000;font-family: arial; padding-left:10px;">Powered by Restyaboard</a></h6>\n</footer>\n</body>\n</html>	SITE_NAME, SITE_URL, PASSWORD	Change Password
6	2015-10-09 06:15:49.891	2015-10-09 06:15:49.891	##SITE_NAME## Restyaboard <##FROM_EMAIL##>	##REPLY_TO_EMAIL##	email_notification	We will send this mail, when user activities in this site.	Restyaboard / ##NOTIFICATION_COUNT## new notifications since ##SINCE##	<html>\n<head><meta http-equiv="Content-Type" content="text/html; charset=utf-8" /></head>\n<body style="margin:0">\n<header style="display:block;width:100%;padding-left:0;padding-right:0; border-bottom:solid 1px #dedede; float:left;background-color: #f7f7f7;">\n<div style="border: 1px solid #EEEEEE;">\n<h1 style="text-align:center;margin:10px 15px 5px;"> <a href="##SITE_URL##" title="Restyaboard"><img src="##SITE_URL##/img/logo.png" alt="[Restyaboard]" title="Restyaboard"></a> </h1>\n</div>\n</header>\n<main style="width:100%;padding-top:10px; padding-bottom:10px; margin:0 auto; float:left;">\n<div style="background-color:#f3f5f7;padding:10px;border: 1px solid #EEEEEE;">\n<div style="width: 500px;background-color: #f3f5f7;margin:0 auto;">\n<div style="font-family: Arial, Helvetica, sans-serif; font-size: 13px;line-height:20px;margin-top:30px;"><h2 style="font-size:16px; font-family:Arial, Helvetica, sans-serif; margin: 7px 0px 0px 43px;padding:35px 0px 0px 0px;">Here's what you missed…</h2>\n<div style="white-space: normal; width: 100%;margin: 10px 0px 0px; font-family:Arial, Helvetica, sans-serif;">##CONTENT##</div>\n</div>\n</div>\n</div>\n<div style="text-align:center;margin:5px 15px;padding:10px 0px;">\n<a href="##SITE_URL##/#/user/##USER_ID##/settings">Change email preferences</a>\n</div>\n</main>\n<footer style="width:100%;padding-left:0;margin:0px auto;border-top: solid 1px #dedede; padding-bottom:10px; background:#fff;clear: both;padding-top: 10px;border-bottom: solid 1px #dedede;background-color: #f7f7f7;">\n<h6 style="text-align:center;margin:5px 15px;"> \n<a href="http://restya.com/board/?utm_source=Restyaboard - ##SITE_NAME##&utm_medium=email&utm_campaign=notification_email" title="Open source. Trello like kanban board." rel="generator" style="font-size: 11px;text-align: center;text-decoration: none;color: #000;font-family: arial; padding-left:10px;">Powered by Restyaboard</a>\n</h6>\n</footer>\n</body>\n</html>	SITE_URL, SITE_NAME, CONTENT, NAME, NOTIFICATION_COUNT, SINCE	Email Notification
1	2014-05-08 12:13:37.268	2014-05-08 12:13:37.268	##SITE_NAME## Restyaboard <##FROM_EMAIL##>	##REPLY_TO_EMAIL##	activation	We will send this mail, when user registering an account he/she will get an activation request.	Restyaboard / Account confirmation	<html>\n<head><meta http-equiv="Content-Type" content="text/html; charset=utf-8" /></head>\n<body style="margin:0">\n<header style="display:block;width:100%;padding-left:0;padding-right:0; border-bottom:solid 1px #dedede; float:left;background-color: #f7f7f7;">\n<div style="border: 1px solid #EEEEEE;">\n<h1 style="text-align:center;margin:10px 15px 5px;"> <a href="##SITE_URL##" title="##SITE_NAME##"><img src="##SITE_URL##/img/logo.png" alt="[Restyaboard]" title="##SITE_NAME##"></a> </h1>\n</div>\n</header>\n<main style="width:100%;padding-top:10px; padding-bottom:10px; margin:0 auto; float:left;">\n<div style="background-color:#f3f5f7;padding:10px;border: 1px solid #EEEEEE;">\n<div style="width: 500px;background-color: #f3f5f7;margin:0 auto;">\n<pre style="font-family: Arial, Helvetica, sans-serif; font-size: 13px;line-height:20px;"><h2 style="font-size:16px; font-family:Arial, Helvetica, sans-serif; margin: 20px 0px 0px;padding:10px 0px 0px 0px;">Hi ##NAME##,\n</h2><p style="white-space: normal; width: 100%;margin: 10px 0px 0px; font-family:Arial, Helvetica, sans-serif;"><br></p><p style="white-space: normal; width: 100%;margin: 0px 0px 0px; font-family:Arial, Helvetica, sans-serif;">You are one step ahead. Please click the below URL to activate your account.<br>##ACTIVATION_URL##<br>If you didn't create a ##SITE_NAME## account and feel this is an error, please contact us at ##CONTACT_EMAIL##.<br></p><br><p style="white-space: normal; width: 100%;margin: 0px 0px 0px;font-family:Arial, Helvetica, sans-serif;">Thanks,<br>\nRestyaboard<br>\n##SITE_URL##</p>\n</pre>\n</div>\n</div>\n</main>\n<footer style="width:100%;padding-left:0;margin:0px auto;border-top: solid 1px #dedede; padding-bottom:10px; background:#fff;clear: both;padding-top: 10px;border-bottom: solid 1px #dedede;background-color: #f7f7f7;">\n<h6 style="text-align:center;margin:5px 15px;"> \n<a href="http://restya.com/board/?utm_source=Restyaboard - ##SITE_NAME##&utm_medium=email&utm_campaign=activation_email" title="Open source. Trello like kanban board." rel="generator" style="font-size: 11px;text-align: center;text-decoration: none;color: #000;font-family: arial; padding-left:10px;">Powered by Restyaboard</a></h6>\n</footer>\n</body>\n</html>	SITE_URL, SITE_NAME, CONTACT_EMAIL, NAME, ACTIVATION_URL	Activation
2	2014-05-08 12:14:07.472	2014-05-08 12:14:07.472	##SITE_NAME## Restyaboard <##FROM_EMAIL##>	##REPLY_TO_EMAIL##	welcome	We will send this mail, when user register in this site and get activate.	Restyaboard / Welcome	<html>\n<head><meta http-equiv="Content-Type" content="text/html; charset=utf-8" /></head>\n<body style="margin:0">\n<header style="display:block;width:100%;padding-left:0;padding-right:0; border-bottom:solid 1px #dedede; float:left;background-color: #f7f7f7;">\n<div style="border: 1px solid #EEEEEE;">\n<h1 style="text-align:center;margin:10px 15px 5px;"> <a href="##SITE_URL##" title="##SITE_NAME##"><img src="##SITE_URL##/img/logo.png" alt="[Restyaboard]" title="##SITE_NAME##"></a> </h1>\n</div>\n</header>\n<main style="width:100%;padding-top:10px; padding-bottom:10px; margin:0 auto; float:left;">\n<div style="background-color:#f3f5f7;padding:10px;border: 1px solid #EEEEEE;">\n<div style="width: 500px;background-color: #f3f5f7;margin:0 auto;">\n<pre style="font-family: Arial, Helvetica, sans-serif; font-size: 13px;line-height:20px;"><h2 style="font-size:16px; font-family:Arial, Helvetica, sans-serif; margin: 20px 0px 0px;padding:10px 0px 0px 0px;">Hi ##NAME##,</h2><p style="white-space: normal; width: 100%;margin: 10px 0px 0px; font-family:Arial, Helvetica, sans-serif;"><br></p><p style="white-space: normal; width: 100%;margin: 0px 0px 0px; font-family:Arial, Helvetica, sans-serif;">We wish to say a quick hello and thanks for registering at ##SITE_NAME##.<br>If you didn't create a ##SITE_NAME## account and feel this is an error, please contact us at ##CONTACT_EMAIL##.<br></p><br><p style="white-space: normal; width: 100%;margin: 0px 0px 0px;font-family:Arial, Helvetica, sans-serif;">Thanks,<br>\nRestyaboard<br>\n##SITE_URL##</p>\n</pre>\n</div>\n</div>\n</main>\n<footer style="width:100%;padding-left:0;margin:0px auto;border-top: solid 1px #dedede; padding-bottom:10px; background:#fff;clear: both;padding-top: 10px;border-bottom: solid 1px #dedede;background-color: #f7f7f7;">\n<h6 style="text-align:center;margin:5px 15px;"> \n<a href="http://restya.com/board/?utm_source=Restyaboard - ##SITE_NAME##&utm_medium=email&utm_campaign=welcome_email" title="Open source. Trello like kanban board." rel="generator" style="font-size: 11px;text-align: center;text-decoration: none;color: #000;font-family: arial; padding-left:10px;">Powered by Restyaboard</a></h6>\n</footer>\n</body>\n</html>	SITE_URL, SITE_NAME, CONTACT_EMAIL, NAME	Welcome
5	2014-05-08 12:14:07.472	2014-05-08 12:14:07.472	##SITE_NAME## Restyaboard <##FROM_EMAIL##>	##REPLY_TO_EMAIL##	newprojectuser	We will send this mail, when user added for board.	Restyaboard / ##BOARD_NAME## assigned by ##CURRENT_USER##	<html>\n<head><meta http-equiv="Content-Type" content="text/html; charset=utf-8" /></head>\n<body style="margin:0">\n<header style="display:block;width:100%;padding-left:0;padding-right:0; border-bottom:solid 1px #dedede; float:left;background-color: #f7f7f7;">\n<div style="border: 1px solid #EEEEEE;">\n<h1 style="text-align:center;margin:10px 15px 5px;"> <a href="##SITE_URL##" title="##SITE_NAME##"><img src="##SITE_URL##/img/logo.png" alt="[Restyaboard]" title="##SITE_NAME##"></a> </h1>\n</div>\n</header>\n<main style="width:100%\nCREA;padding-top:10px; padding-bottom:10px; margin:0 auto; float:left;">\n<div style="background-color:#f3f5f7;padding:10px;border: 1px solid #EEEEEE;">\n<div style="width: 500px;background-color: #f3f5f7;margin:0 auto;">\n<pre style="font-family: Arial, Helvetica, sans-serif; font-size: 13px;line-height:20px;"><h2 style="font-size:16px; font-family:Arial, Helvetica, sans-serif; margin: 20px 0px 0px;padding:10px 0px 0px 0px;">Hi ##NAME##,</h2>\n<p style="white-space: normal; width: 100%;margin: 0px 0px 0px; font-family:Arial, Helvetica, sans-serif;">##CURRENT_USER## has added you to the board ##BOARD_NAME## ##BOARD_URL##<br></p><br><p style="white-space: normal; width: 100%;margin: 0px 0px 0px;font-family:Arial, Helvetica, sans-serif;">Thanks,<br>\nRestyaboard<br>\n##SITE_URL##</p>\n</pre>\n</div>\n</div>\n</main>\n<footer style="width:100%;padding-left:0;margin:0px auto;border-top: solid 1px #dedede; padding-bottom:10px; background:#fff;clear: both;padding-top: 10px;border-bottom: solid 1px #dedede;background-color: #f7f7f7;">\n<h6 style="text-align:center;margin:5px 15px;"> \n<a href="http://restya.com/board/?utm_source=Restyaboard - ##SITE_NAME##&utm_medium=email&utm_campaign=new_board_member_email" title="Open source. Trello like kanban board." rel="generator" style="font-size: 11px;text-align: center;text-decoration: none;color: #000;font-family: arial; padding-left:10px;">Powered by Restyaboard</a></h6>\n</footer>\n</body>\n</html>	SITE_URL, SITE_NAME, NAME, BOARD_NAME, CURRENT_USER, BOARD_URL	New Board User
3	2014-05-08 12:13:59.784	2014-05-08 12:13:59.784	##SITE_NAME## Restyaboard <##FROM_EMAIL##>	##REPLY_TO_EMAIL##	forgetpassword	We will send this mail, when user submit the forgot password form	Restyaboard / Password reset	<html>\n<head><meta http-equiv="Content-Type" content="text/html; charset=utf-8" /></head>\n<body style="margin:0">\n<header style="display:block;width:100%;padding-left:0;padding-right:0; border-bottom:solid 1px #dedede; float:left;background-color: #f7f7f7;">\n<div style="border: 1px solid #EEEEEE;">\n<h1 style="text-align:center;margin:10px 15px 5px;"> <a href="##SITE_URL##" title="##SITE_NAME##"><img src="##SITE_URL##/img/logo.png" alt="[Restyaboard]" title="##SITE_NAME##"></a> </h1>\n</div>\n</header>\n<main style="width:100%;padding-top:10px; padding-bottom:10px; margin:0 auto; float:left;">\n<div style="background-color:#f3f5f7;padding:10px;border: 1px solid #EEEEEE;">\n<div style="width: 500px;background-color: #f3f5f7;margin:0 auto;">\n<pre style="font-family: Arial, Helvetica, sans-serif; font-size: 13px;line-height:20px;"><h2 style="font-size:16px; font-family:Arial, Helvetica, sans-serif; margin: 20px 0px 0px;padding:10px 0px 0px 0px;">Hi ##NAME##,</h2><p style="white-space: normal; width: 100%;margin: 10px 0px 0px; font-family:Arial, Helvetica, sans-serif;"><br></p><p style="white-space: normal; width: 100%;margin: 0px 0px 0px; font-family:Arial, Helvetica, sans-serif;">We have received a password reset request for your account at ##SITE_NAME##.<br>New password: ##PASSWORD##<br>If you didn't requested this action and feel this is an error, please contact us at ##CONTACT_EMAIL##.<br></p><br><p style="white-space: normal; width: 100%;margin: 0px 0px 0px;font-family:Arial, Helvetica, sans-serif;">Thanks,<br>\nRestyaboard<br>\n##SITE_URL##</p>\n</pre>\n</div>\n</div>\n</main>\n<footer style="width:100%;padding-left:0;margin:0px auto;border-top: solid 1px #dedede; padding-bottom:10px; background:#fff;clear: both;padding-top: 10px;border-bottom: solid 1px #dedede;background-color: #f7f7f7;">\n<h6 style="text-align:center;margin:5px 15px;"> \n<a href="http://restya.com/board/?utm_source=Restyaboard - ##SITE_NAME##&utm_medium=email&utm_campaign=forgot_password_email" title="Open source. Trello like kanban board." rel="generator" style="font-size: 11px;text-align: center;text-decoration: none;color: #000;font-family: arial; padding-left:10px;">Powered by Restyaboard</a></h6>\n</footer>\n</body>\n</html>	SITE_NAME, SITE_URL, CONTACT_EMAIL, NAME, PASSWORD	Forgot Password
7	2016-01-10 06:15:49.891	2016-01-10 06:15:49.891	##SITE_NAME## Restyaboard <##FROM_EMAIL##>	##REPLY_TO_EMAIL##	due_date_notification	We will send this mail, One day before when the card due date end.	##SUBJECT##	<html>\n<head><meta http-equiv="Content-Type" content="text/html; charset=utf-8" /></head>\n<body style="margin:0">\n<header style="display:block;width:100%;padding-left:0;padding-right:0; border-bottom:solid 1px #dedede; float:left;background-color: #f7f7f7;">\n<div style="border: 1px solid #EEEEEE;">\n<h1 style="text-align:center;margin:10px 15px 5px;"> <a href="##SITE_URL##" title="##SITE_NAME##"><img src="##SITE_URL##/img/logo.png" alt="[Restyaboard]" title="##SITE_NAME##"></a> </h1>\n</div>\n</header>\n<main style="width:100%;padding-top:10px; padding-bottom:10px; margin:0 auto; float:left;">\n<div style="background-color:#f3f5f7;padding:10px;border: 1px solid #EEEEEE;">\n<div style="width: 500px;background-color: #f3f5f7;margin:0 auto;">\n<pre style="font-family: Arial, Helvetica, sans-serif; font-size: 13px;line-height:20px;">\n<h2 style="font-size:16px; font-family:Arial, Helvetica, sans-serif; margin: 7px 0px 0px 43px;padding:35px 0px 0px 0px;">Due soon…</h2>\n<p style="white-space: normal; width: 100%;margin: 10px 0px 0px; font-family:Arial, Helvetica, sans-serif;">##CONTENT##</p>\n</pre>\n</div>\n</div>\n</main>\n<footer style="width:100%;padding-left:0;margin:0px auto;border-top: solid 1px #dedede; padding-bottom:10px; background:#fff;clear: both;padding-top: 10px;border-bottom: solid 1px #dedede;background-color: #f7f7f7;">\n<h6 style="text-align:center;margin:5px 15px;"> \n<a href="http://restya.com/board/?utm_source=Restyaboard - ##SITE_NAME##&utm_medium=email&utm_campaign=due_date_notification_email" title="Open source. Trello like kanban board." rel="generator" style="font-size: 11px;text-align: center;text-decoration: none;color: #000;font-family: arial; padding-left:10px;">Powered by Restyaboard</a>\n</h6>\n</footer>\n</body>\n</html>	SITE_URL, SITE_NAME, SUBJECT, CONTENT	Due Date Notification
8	2014-05-08 12:14:07.472	2014-05-08 12:14:07.472	##SITE_NAME## Restyaboard <##FROM_EMAIL##>	##REPLY_TO_EMAIL##	ldap_welcome	We will send this mail, when admin imports from LDAP.	Restyaboard / Welcome	<html>\n<head></head>\n<body style="margin:0">\n<header style="display:block;width:100%;padding-left:0;padding-right:0; border-bottom:solid 1px #dedede; float:left;background-color: #f7f7f7;">\n<div style="border: 1px solid #EEEEEE;">\n<h1 style="text-align:center;margin:10px 15px 5px;"> <a href="##SITE_URL##" title="##SITE_NAME##"><img src="##SITE_URL##/img/logo.png" alt="[Restyaboard]" title="##SITE_NAME##"></a> </h1>\n</div>\n</header>\n<main style="width:100%;padding-top:10px; padding-bottom:10px; margin:0 auto; float:left;">\n<div style="background-color:#f3f5f7;padding:10px;border: 1px solid #EEEEEE;">\n<div style="width: 500px;background-color: #f3f5f7;margin:0 auto;">\n<pre style="font-family: Arial, Helvetica, sans-serif; font-size: 13px;line-height:20px;"><h2 style="font-size:16px; font-family:Arial, Helvetica, sans-serif; margin: 20px 0px 0px;padding:10px 0px 0px 0px;">Hi ##NAME##,</h2><p style="white-space: normal; width: 100%;margin: 10px 0px 0px; font-family:Arial, Helvetica, sans-serif;"><br></p><p style="white-space: normal; width: 100%;margin: 0px 0px 0px; font-family:Arial, Helvetica, sans-serif;">Admin imported your LDAP account in ##SITE_NAME##. You can login with your LDAP username and password in ##SITE_URL##.<br></p><br><p style="white-space: normal; width: 100%;margin: 0px 0px 0px;font-family:Arial, Helvetica, sans-serif;">Thanks,<br>\nRestyaboard<br>\n##SITE_URL##</p>\n</pre>\n</div>\n</div>\n</main>\n<footer style="width:100%;padding-left:0;margin:0px auto;border-top: solid 1px #dedede; padding-bottom:10px; background:#fff;clear: both;padding-top: 10px;border-bottom: solid 1px #dedede;background-color: #f7f7f7;">\n<h6 style="text-align:center;margin:5px 15px;"> \n<a href="http://restya.com/board/?utm_source=Restyaboard - ##SITE_NAME##&utm_medium=email&utm_campaign=welcome_email" title="Open source. Trello like kanban board." rel="generator" style="font-size: 11px;text-align: center;text-decoration: none;color: #000;font-family: arial; padding-left:10px;">Powered by Restyaboard</a></h6>\n</footer>\n</body>\n</html>	SITE_URL, SITE_NAME, CONTACT_EMAIL, NAME	LDAP Welcome
\.


--
-- Name: email_templates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('email_templates_id_seq', 1, true);


--
-- Data for Name: ips; Type: TABLE DATA; Schema: public; Owner: -
--

COPY ips (id, created, modified, ip, host, user_agent, "order", city_id, state_id, country_id, latitude, longitude) FROM stdin;
1	2015-05-21 11:45:47.262	2015-05-21 11:45:47.262	93.184.216.34		Mozilla/5.0 (Windows NT 6.3; WOW64; rv:38.0) Gecko/20100101 Firefox/38.0	0	1	1	240	42.1507999999999967	-70.8228000000000009
3	2016-01-12 17:00:46.075	2016-01-12 17:00:46.075	::1	newahsan16.ahsan.in	Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36	0	3	3	102	20	77
4	2016-01-12 18:12:05.188	2016-01-12 18:12:05.188	192.168.1.225	newahsan16.ahsan.in	Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36	0	3	3	102	20	77
5	2016-01-12 18:32:33.116	2016-01-12 18:32:33.116	192.168.1.127	atche-s020.ahsan.in	Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36	0	3	3	102	20	77
6	2016-01-13 12:15:13.946	2016-01-13 12:15:13.946	192.168.1.74	atche-s025.ahsan.in	Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36	0	3	3	102	20	77
7	2016-01-13 13:17:35.288	2016-01-13 13:17:35.288	192.168.1.138	atche-r020.ahsan.in	Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36	0	3	3	102	20	77
\.


--
-- Name: ips_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('ips_id_seq', 7, true);


--
-- Data for Name: labels; Type: TABLE DATA; Schema: public; Owner: -
--

COPY labels (id, created, modified, name, card_count) FROM stdin;
2	2015-06-11 14:25:59.906	2015-06-11 14:25:59.906	Urgent	1
3	2015-06-11 14:25:59.934	2015-06-11 14:25:59.934	Important	1
6	2016-01-12 18:46:12.044	2016-01-12 18:46:12.044	css	1
7	2016-01-12 18:49:41.162	2016-01-12 18:49:41.162	feature	1
5	2016-01-12 18:45:46.807	2016-01-12 18:45:46.807	block	3
4	2016-01-12 18:45:16.287	2016-01-12 18:45:16.287	urgent	3
9	2016-01-12 19:07:23.934	2016-01-12 19:07:23.934	crash	1
10	2016-01-12 19:07:44.755	2016-01-12 19:07:44.755	trivial	1
8	2016-01-12 18:49:57.552	2016-01-12 18:49:57.552	minor	3
11	2016-01-12 19:30:29.549	2016-01-12 19:30:29.549	fun	1
12	2016-01-12 19:30:38.37	2016-01-12 19:30:38.37	horor	1
13	2016-01-12 19:34:40.353	2016-01-12 19:34:40.353	Race	1
15	2016-01-12 19:34:40.381	2016-01-12 19:34:40.381	song	1
14	2016-01-12 19:34:40.376	2016-01-12 19:34:40.376	Health	2
\.


--
-- Name: labels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('labels_id_seq', 15, true);


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
412	2016-03-10 16:24:44.87	2016-03-10 16:24:44.87	Yiddish	yi	yi	0
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
2	2016-01-12 19:01:20.263	2016-01-12 19:01:20.263	206	12	t
3	2016-01-12 19:01:24.195	2016-01-12 19:01:24.195	204	12	t
4	2016-01-12 19:24:47.798	2016-01-12 19:24:47.798	197	5	t
5	2016-01-12 19:27:34.104	2016-01-12 19:27:34.104	201	7	t
\.


--
-- Name: list_subscribers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('list_subscribers_id_seq', 1, false);


--
-- Data for Name: lists; Type: TABLE DATA; Schema: public; Owner: -
--

COPY lists (id, created, modified, board_id, user_id, name, "position", is_archived, card_count, lists_subscriber_count, is_deleted, custom_fields) FROM stdin;
198	2015-05-25 11:14:59.895215	2015-05-25 11:14:59.895215	5	6	Watch List	1	f	0	0	f	\N
199	2015-05-25 11:15:03.772227	2015-05-25 11:15:03.772227	5	6	Deal	2	f	0	0	f	\N
210	2015-05-25 13:40:37.744217	2015-05-25 13:40:37.744217	7	12	37.0.2	7	f	1	0	f	\N
197	2015-05-25 11:04:17.046715	2015-05-25 11:04:17.046715	4	5	Wishlist	1	f	24	1	f	\N
212	2015-05-25 13:46:13.795223	2015-05-25 13:46:13.795223	7	12	38.0.1	9	f	2	0	f	\N
208	2015-05-25 13:33:45.263015	2015-05-25 13:33:45.263015	7	12	37	5	f	5	0	f	\N
211	2015-05-25 13:41:40.932666	2015-05-25 13:41:40.932666	7	12	38	8	f	6	0	f	\N
206	2015-05-25 13:10:10.574975	2015-05-25 13:10:10.574975	7	12	36.0.3	3	f	5	1	f	\N
204	2015-05-25 12:43:53.252219	2015-05-25 12:43:53.252219	7	12	36	1	f	6	1	f	\N
205	2015-05-25 12:56:26.028134	2015-05-25 12:56:26.028134	7	12	36.0.1	2	f	6	0	f	\N
207	2015-05-25 13:19:41.566983	2015-05-25 13:19:41.566983	7	12	36.0.4	4	f	6	0	f	\N
209	2015-05-25 13:38:58.336151	2015-05-25 13:38:58.336151	7	12	37.0.1	6	f	3	0	f	\N
200	2015-05-25 11:15:12.12493	2015-05-25 11:15:12.12493	5	6	Acquired	3	f	46	0	f	\N
202	2015-05-25 12:20:26.802772	2015-05-25 12:20:26.802772	6	7	Dead	2	f	30	0	f	\N
203	2015-05-25 12:20:30.952548	2015-05-25 12:20:30.952548	6	7	Exited	3	f	30	0	f	\N
201	2015-05-25 12:20:21.716913	2015-05-25 12:20:21.716913	6	7	Active	1	f	30	1	f	\N
\.


--
-- Name: lists_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('lists_id_seq', 212, true);


--
-- Name: lists_subscribers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('lists_subscribers_id_seq', 5, true);


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
14a67c0cdfa1f59e613975489e5b1baca6ff0680	7742632501382313	\N	2015-04-02 13:55:24	\N
7dfdfd6a246c0fd052d57cd0630f7e6689030858	7742632501382313	\N	2015-04-02 13:55:25	\N
8800435fb54b20f51c386810bb21adc7fbce0a5f	7742632501382313	admin	2015-04-02 13:55:32	\N
de3af2d856113797307f357161509f706137ddf1	7742632501382313	\N	2015-05-21 09:15:43	\N
430c0c1887cca0373aa9e7d1d21b293cc14ce6fd	7742632501382313	admin	2015-05-21 09:15:47	\N
84c77fadac4376def293b717f43b1d65b6a2e59b	7742632501382313	\N	2015-05-25 09:56:40	\N
0ee18b5d343d9f0eaa3800c57e249f406c985ecf	7742632501382313	admin	2015-05-25 09:56:45	\N
301ca67e348105a98bff2e39e2951cad38b99dcc	7742632501382313	\N	2015-05-25 10:09:26	\N
6aa242ac2e30cff961fbe2b535de907c7d40e797	7742632501382313	admin	2015-05-25 10:09:32	\N
1f3a7d6d7fd48a2f541c974e23cee021af41d09b	7742632501382313	\N	2015-05-25 10:26:54	\N
bf7b61e33ba047903b5e350bea93a96486820a67	7742632501382313	\N	2015-05-25 10:45:25	\N
77a1782035b4affcaf97b8e6df7755c14dc2d221	7742632501382313	admin	2015-05-25 10:45:39	\N
d98337909f078cbefbc46acb7e70d1e9535c7125	7742632501382313	\N	2015-05-25 10:50:13	\N
0e6a54e6d167fb12eaff5040afd5e4da2f441cd9	7742632501382313	admin	2015-05-25 10:51:00	\N
ff715ab7f837314fe9a7143c51da7c5204f90502	7742632501382313	\N	2015-05-25 10:51:27	\N
2954b4f751d0253982fc04608fb412eefb1f95a5	7742632501382313	\N	2015-05-25 10:51:41	\N
ebae7a930ef548b2e1af2c7f2a14afbded7cd73f	7742632501382313	admin	2015-05-25 11:09:42	\N
7d71a40cbba93beb5d42916faad68522411cfab2	7742632501382313	\N	2015-05-25 11:46:51	\N
b886f1ac10dbe8a09bd50b31eca57a7fa6c2279a	7742632501382313	\N	2015-05-25 11:49:02	\N
f3a5d2e73dec3553afc8b35ef7b89b1902cf1dbe	7742632501382313	admin	2015-05-25 11:51:09	\N
b8503e087f15d90814f510d634c22fd952933410	7742632501382313	\N	2015-05-25 11:53:49	\N
f2689a52f22c2a6f8e03505d7882281f3d5544de	7742632501382313	\N	2015-05-25 11:54:00	\N
8e5fa2571e2fbb871d2e66f6c9c1eccdd7148a10	7742632501382313	\N	2015-05-25 11:54:09	\N
754b0fd32494c97e5c3fa7c9a029d5da36ce9749	7742632501382313	admin	2015-05-25 11:54:18	\N
14192d6bba285a17a99ee62c31e64a9c16cc0ac7	7742632501382313	admin	2015-05-25 11:54:34	\N
1eda045643e6eb5ea74d7c53b2052fcb8c28587d	7742632501382313	\N	2015-05-25 11:55:54	\N
8c850bc5dc392e2d75df59767b7b468ed31a0196	7742632501382313	\N	2015-05-25 11:58:01	\N
931087b23542a1f06c09aebd30cee7ed988d3270	7742632501382313	\N	2015-05-25 12:01:37	\N
afc9ec09561c4c748f2d026c89f6e02cbcb0b7ad	7742632501382313	\N	2015-05-25 12:02:27	\N
3c67f0eea9f4855904ef5a1092f6df3027a67f0d	7742632501382313	\N	2015-05-25 12:03:36	\N
f6d3f190c471e78ef3d71c4935d1b35e4af45c72	7742632501382313	\N	2015-05-25 12:07:35	\N
fbadd45ee4436b7d3a90da410020ad02fba32d49	7742632501382313	\N	2015-05-25 12:09:43	\N
2fd704e406a90e199387075f61a4dbcd2e338c7b	7742632501382313	admin	2015-05-25 12:09:52	\N
87ca6791da98db42be5e0ed2cbf3358c3a534f6d	7742632501382313	\N	2015-05-25 12:33:25	\N
9aeb1636cdcb79fb543cd6064c9ccdf4e4171191	7742632501382313	admin	2015-05-25 12:33:31	\N
45ed4af7bd0795bafb48376f48cbdf25d8006808	7742632501382313	admin	2015-05-25 12:54:21	\N
e8bc1a3631a43b4fc20c89fda499b43d142b1fa9	7742632501382313	\N	2015-05-25 13:00:00	\N
4b912e553fd68860d08cb0d3e084b2bdd2c44d5b	7742632501382313	\N	2015-05-25 13:00:19	\N
402556f82da0703e79ff018143cde57f5a618329	7742632501382313	\N	2015-05-25 13:02:06	\N
40d513d8d9138a8971b6f482c2d581d0eccf8d23	7742632501382313	\N	2015-05-25 13:03:14	\N
284814ad7ea3d221f855661a8130c987ba08bb1c	7742632501382313	\N	2015-05-25 13:03:32	\N
219d91ff1d0c9fdfd2be3272b3db4d7f02662d13	7742632501382313	\N	2015-05-25 13:10:38	\N
d8c4e1a694b4ef98cad06e42f5a6d1ba0fde561e	7742632501382313	\N	2015-05-25 13:12:07	\N
62d385c40acca1ff97917944cf66d65ad8474cbf	7742632501382313	PaulGraham	2015-05-25 13:12:29	\N
c21992b2b9ed7428d15d566f34eb72a09b81ccdb	7742632501382313	\N	2015-05-25 13:12:35	\N
330e40063b7d41d0815f26ba669f0dfd5d22931e	7742632501382313	\N	2015-05-25 13:14:16	\N
a321151e8e591009523736936105281d9a9cd8ad	7742632501382313	JessicaLivings	2015-05-25 13:14:44	\N
7bd5f133df3cce950826b4672470c0a1d7e45c3f	7742632501382313	\N	2015-05-25 13:14:51	\N
f9b923fd263d558709edc8acedb33a42ca392403	7742632501382313	\N	2015-05-25 13:15:02	\N
e114f0804e6fa23986a1685c6f29ee6cb344aec6	7742632501382313	RobertMorris	2015-05-25 13:15:23	\N
7cf3de3b20b7ad47d24ec8ca6130d593902e6263	7742632501382313	\N	2015-05-25 13:15:51	\N
1ab1bc93559ae7b21f8809c4a054602f2a595376	7742632501382313	\N	2015-05-25 13:19:12	\N
b6e4e9e9cf9c473832cb111fa683a9f15f179c1e	7742632501382313	\N	2015-05-25 13:28:19	\N
4b1fc3e54c180f683e6fea484418402a4cf01f9c	7742632501382313	\N	2015-05-25 13:30:04	\N
eb38ffbd3fd9befa94aea6c3ee8c04eae452be37	7742632501382313	\N	2015-05-25 13:31:11	\N
8873ecfd03bafee112695054b96c90d8bb17a8ad	7742632501382313	DaveHyatt 	2015-05-25 13:32:53	\N
97d1b4b41203de3af9ade7487911f7b19f8f1bc5	7742632501382313	\N	2015-05-25 13:33:08	\N
136ff831a27925bb89aba094a5c6549b518a1b2b	7742632501382313	DaveHyatt 	2015-05-25 13:33:27	\N
439cefbceb48d9f038486a5996404687956e5ce4	7742632501382313	admin	2015-05-25 13:33:35	\N
f36ff695db3ce893fa1015a7ea2e19b0fe28733a	7742632501382313	\N	2015-05-25 13:40:46	\N
b30231745128f3d5b853b69eace16c7d2fe5095d	7742632501382313	\N	2015-05-25 13:42:36	\N
5321d4fa613514c303b49272c07fedcd0f4bb88c	7742632501382313	admin	2015-05-25 13:54:31	\N
494361d39edcdc52b51f850e7fc2dea146267019	7742632501382313	admin	2015-05-25 14:33:37	\N
9e1bfa7bfb7259db31cebd114953bde7fe496666	7742632501382313	admin	2015-05-25 14:54:41	\N
c4b21cd37c50a856b88c3c212646ef5f61951e20	7742632501382313	\N	2015-05-25 15:00:26	\N
fb8b14ae605308464c2b8b18238c10446b13cc40	7742632501382313	admin	2015-05-25 15:00:33	\N
13167dbb237cde6fba9dc5f076e3932a45f1db36	7742632501382313	\N	2015-05-25 15:26:00	\N
04a8465f8564a35d52195298bd8fa7e3bd1db280	7742632501382313	\N	2015-05-25 15:27:09	\N
8a35204c0f5a5fdd7d63ee4c18d72ef839bd6a54	7742632501382313	BrianGrinstead	2015-05-25 15:27:46	\N
d9f5ccc5de1eee9ae147b6102a516e7fcd68e2c8	7742632501382313	\N	2015-05-25 15:28:06	\N
c4b1cef00da57abc073953b03c5954cb313d495b	7742632501382313	\N	2015-05-25 15:30:00	\N
b2589b9f2516791378cb732dde6117c779d3a4c7	7742632501382313	MikedeBoer	2015-05-25 15:30:07	\N
be0015b442635287b4e562f0d60df4dd1c0f707e	7742632501382313	\N	2015-05-25 15:33:02	\N
325235d9615b40b3843de0a5c7f55b77cd70587e	7742632501382313	admin	2015-05-25 15:33:43	\N
2a2311b606b6c23f966e321534c51daf7df0b7af	7742632501382313	\N	2015-05-25 15:35:42	\N
6c1425e0462b042502fe7af2318c4391fa76ccd7	7742632501382313	MarkBanner	2015-05-25 15:36:01	\N
c9a579616a857338fbc676e3bf8f98c74852b320	7742632501382313	\N	2015-05-25 15:37:00	\N
694c8195134ee71c2c752af6cc9920d9223226c9	7742632501382313	\N	2015-05-25 15:49:07	\N
cd8222ae90313169ecb3f9d5cbc21df649ab6f6e	7742632501382313	MarkBanner	2015-05-25 15:49:21	\N
75f638dbb2c8b5668a14686485d7900b7590f40b	7742632501382313	\N	2015-05-25 15:49:26	\N
5b53d21952dd0dec8df921b1b5901b933db693b2	7742632501382313	\N	2015-05-25 15:49:49	\N
2a0730bf22edfd6e7af76545ef8768235960bdf0	7742632501382313	DaveHyatt 	2015-05-25 15:51:49	\N
0d2e65d30385257561909a68d47348837aa96197	7742632501382313	\N	2015-05-25 15:52:01	\N
a0b116507fe50a26a5730adb7f10bc9304030769	7742632501382313	DaveHyatt 	2015-05-25 15:52:50	\N
16cffa240d7921130636e6040edc2a35de9201e5	7742632501382313	\N	2015-05-25 15:52:54	\N
5ad7ad57daf02d075b751d61987a156d971d2f1a	7742632501382313	\N	2015-05-25 15:54:21	\N
04afc7429007cfb74bbef6ae10b46b96821d8b68	7742632501382313	admin	2015-05-25 15:54:26	\N
3fa3253193c104cf49e1f1ec81f9744f7d93a887	7742632501382313	admin	2015-05-25 15:54:44	\N
4005fa6e9989834e961a5985312920cb6439023d	7742632501382313	\N	2015-05-25 16:04:11	\N
ade3602e19a8d934c6e8e99eceac863f769fbd91	7742632501382313	admin	2015-05-25 16:04:18	\N
e4118f2f01cfd596a8f04e445a797562aa6dd935	7742632501382313	\N	2015-05-25 16:04:55	\N
ec1a156b543011be3637db85289727ce171fa4e4	7742632501382313	admin	2015-05-25 16:33:48	\N
3f2d8d708bcddb4add599ad30ba97394a66329c5	7742632501382313	\N	2015-05-26 11:12:46	\N
83559a06f04ed781a0d2c3f90ca0b79bd722b8ca	7742632501382313	\N	2015-05-26 11:12:49	\N
813edee6c3070e461f160b016e209670bc33ea82	7742632501382313	\N	2015-05-26 11:12:49	\N
f7395ab2aeb1fd5fe77cb886a58c0d5460d1f07a	7742632501382313	admin	2015-05-26 11:12:51	\N
6858f78a3bcba60cd7d5528a09fb27c8a24daf13	7742632501382313	\N	2015-06-06 08:33:34	\N
4d63e9a78994783b5b27bbe868f58e164e450d31	7742632501382313	admin	2015-06-06 08:33:40	\N
412d2da58ce1224a943c11da9db3f7f40c25cb0a	7742632501382313	\N	2015-06-06 08:41:58	\N
43ccf4cf505a996d2e33a81c903ae971335ddd10	7742632501382313	admin	2015-06-06 08:42:48	\N
43c8bbca0e3b0c3dfc832df254310c1155c0f51e	7742632501382313	\N	2015-06-06 16:22:04	\N
09a5cdb9f9b54b2923bf44c1ec1d906ef806522c	7742632501382313	admin	2015-06-06 16:22:16	\N
6323b732b46829f6dfeb8e0caebe2e9038c2abac	7742632501382313	\N	2015-06-06 16:26:35	\N
60937bad81f4eb76c2f1c2ef41d06814f4b5b876	7742632501382313	admin	2015-06-06 16:26:44	\N
d2e385752ed6079e75e0d6fbda3012a6a0da434b	7742632501382313	\N	2015-06-06 16:28:48	\N
ea028a6b4e38ddb67ce7d0ebfa3b0ca38c27dd59	7742632501382313	admin	2015-06-06 16:29:34	\N
861f0ad1f7c2485b4043bfa9e034c4ba04589bd9	7742632501382313	admin	2015-06-06 17:26:45	\N
6cfcb3e581d3ac36c1e053ad4c0fe3d45858d71a	7742632501382313	\N	2015-06-06 18:29:39	\N
66d1b4205b0b6f01d00b68914b1725ed2b95920a	7742632501382313	admin	2015-06-06 18:29:42	\N
d88a141e31ec95c12d8b5e44f7e57d8f25f9e123	7742632501382313	\N	2015-06-08 07:51:12	\N
455ec90058e66428ff54ff5383a6c427a3eceab8	7742632501382313	admin	2015-06-08 07:51:33	\N
1150105c7ccc781349d108a4a9edf80bafe4787e	7742632501382313	\N	2015-06-08 08:51:52	\N
f50972dfdeb80ea9ed8e8e2503df9e9599ba3f02	7742632501382313	admin	2015-06-08 08:51:59	\N
32fda3900e5905dedb8169075fc5432d255be7a9	7742632501382313	\N	2015-06-10 14:54:46	\N
fc1d748d95441fe3b201a4261b1b187b833c481c	7742632501382313	\N	2015-06-11 11:48:23	\N
0f47c2ea5e7411b172870320f8bf0dded2580a6b	7742632501382313	\N	2015-06-11 11:53:50	\N
9750b6abb10ae65c0d234f8b35d48889c6fe317f	7742632501382313	admin	2015-06-11 11:53:55	\N
db8f2acd73cc2cd58ab5e749d8c5fc743d7b1c36	7742632501382313	\N	2015-06-11 11:55:26	\N
3088a0da3deeae5273e1631c8574a64e838a9c64	7742632501382313	\N	2015-06-24 09:10:43	\N
126d00fcd26e17cf251d3b644839429f2d5b3c81	7742632501382313	admin	2015-06-24 09:10:47	\N
a2c9c7effa7abb64c18475498ef242f05359f13f	7742632501382313	\N	2016-01-12 13:30:41	\N
be48a0228771e5cc5ccbae9ab463e34b17ebc864	7742632501382313	admin	2016-01-12 13:30:46	\N
b787f5d6e0cabf127d397eca532277c81038a4e5	7742632501382313	\N	2016-01-12 14:41:58	\N
12c565cc28021524198b45c77a6628c6da172d3e	7742632501382313	admin	2016-01-12 14:42:05	\N
f9794c4c2ebfc8bf404db80c865e77d646aeef23	7742632501382313	\N	2016-01-12 15:02:27	\N
1c86fc9430aa8f6019537539f4e436d9518b6e66	7742632501382313	admin	2016-01-12 15:02:33	\N
8653c09534df28371e25e6184e78fe97dd6ca586	7742632501382313	\N	2016-01-12 15:03:40	\N
6a0d809643caa1411782add3072a105c3005742f	7742632501382313	\N	2016-01-12 15:51:26	\N
cca338876383f61f184ba015e46ff7a95cff39fc	7742632501382313	\N	2016-01-12 15:56:40	\N
894b603fa99664d974be53a6142eaf84371392e4	7742632501382313	admin	2016-01-12 16:02:37	\N
945d84638a90a383f5678d73437869a4e0d47fbe	7742632501382313	\N	2016-01-12 16:07:50	\N
356f03618225c83797e9a04f1db8759c1d89d18f	7742632501382313	\N	2016-01-12 16:27:49	\N
489a4dddf1d834c01e55322ea1e1fea44b71ad28	7742632501382313	\N	2016-01-12 16:31:52	\N
6fbf79f94dfbb09b0d4e3e4a759047c944b7def5	7742632501382313	\N	2016-01-12 16:32:28	\N
0bb74ab2752afeab4764fb552bd81ef23545f11c	7742632501382313	\N	2016-01-12 16:33:07	\N
550a97fb9f8e90b6df8b5852110c59d498b35fb6	7742632501382313	MarissaMayer	2016-01-12 16:33:38	\N
531811cd1a2dc054bd5f90cfcbc0e726be54191b	7742632501382313	\N	2016-01-13 06:55:11	\N
9ee1f9f73a5eec7558817e955c656d9d3c17ddf3	7742632501382313	admin	2016-01-13 06:55:25	\N
25d19082c1e6052459b811b3794b157aecaf4729	7742632501382313	\N	2016-01-13 07:39:40	\N
0b02cd8b061d16b04fa9d812d8ba42ee5db8452d	7742632501382313	admin	2016-01-13 07:39:43	\N
cdad1f9db1ab9f011a5a4675c656d5e41592859e	7742632501382313	\N	2016-01-13 08:42:57	\N
7b4ac5664cf1a857051bee41f0ee8e9159dce5a3	7742632501382313	admin	2016-01-13 08:43:02	\N
a9240393c8d2b8e449740235314657c25d6b9178	7742632501382313	\N	2016-01-13 08:44:57	\N
46273de43a989c4fc0e6535a60d7635ac2fe97a5	7742632501382313	admin	2016-01-13 08:45:14	\N
4ed75656e621cab6aaa67e0e46ea526ce89ca5f6	7742632501382313	\N	2016-01-13 09:21:05	\N
c62dfd77ecc8e4e8bb84a14d063ebc241717c0f8	7742632501382313	\N	2016-01-13 09:21:15	\N
22490944fc8ffc4f7935b82d0c433e8f442d385f	7742632501382313	admin	2016-01-13 09:21:20	\N
dd789eae40034b115f5c85adc2faafdfd7a55d49	7742632501382313	\N	2016-01-13 09:42:34	\N
6b93a01e62537e68f8a4649997f1f0a683c7040a	7742632501382313	admin	2016-01-13 09:42:37	\N
4cda15726fcf0def6681477e27bacf5e12f6541f	7742632501382313	\N	2016-01-13 09:47:24	\N
920d48cc428452eb43abd0107fa4027d80585210	7742632501382313	admin	2016-01-13 09:47:35	\N
1a834c32fb1e2498b0a36ef1d2dbd8dee3edf310	7742632501382313	\N	2016-01-13 09:48:12	\N
47679a7ba3275db9b83a2100118ccd97fcc02b6a	7742632501382313	admin	2016-01-13 09:48:24	\N
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
6664115227792148	hw3wpe2cfsxxygogwue47cwnf7	\N	client_credentials refresh_token authorization_code	\N	\N	Mobile App	\N	\N	\N	\N	2016-02-22 17:36:32.714	2016-02-22 17:36:32.714	3
7857596005287233	n0l2wlujcpkj0bd7gk8918gm6b	\N	client_credentials refresh_token authorization_code	\N	\N	Zapier	\N	\N	\N	\N	2016-02-22 17:36:32.714	2016-02-22 17:36:32.714	4
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
c49e20d85d91bff7eba10108cab44a9d702bbd92	7742632501382313	admin	2015-06-08 08:56:45	\N
0eecb38b8faee1a1bfffaaa5cd644e6ea9a19def	7742632501382313	admin	2015-06-08 09:09:32	\N
e8593cc235383d964084ab067207c329b0b2bb06	7742632501382313	admin	2015-06-08 09:45:39	\N
faa398b2df31cc2b7086d4b353e22f6c8efed4d4	7742632501382313	admin	2015-06-08 09:51:00	\N
843a2d27cc4ae5b0d8227915148c97f6cfab0d37	7742632501382313	admin	2015-06-08 10:54:18	\N
4ebc19a474778c2e90c93e5fb08f18eca5735276	7742632501382313	admin	2015-06-08 10:54:34	\N
bc385c589da13dd6e4a9a8182b17697262825d5d	7742632501382313	admin	2015-06-08 11:33:31	\N
d3b882f9dba003d6245e37af8b85fb2d3f69a14f	7742632501382313	PaulGraham	2015-06-08 12:12:29	\N
92c6d2ae86ebd086baf558fe14efa77bce3ee3d4	7742632501382313	JessicaLivings	2015-06-08 12:14:44	\N
2533c1a48efb7b716ae65e653b93978199fad755	7742632501382313	RobertMorris	2015-06-08 12:15:23	\N
cd78321c40799a57d5a38ae6f419b5c936a1f44f	7742632501382313	DaveHyatt 	2015-06-08 12:32:53	\N
fa02fdaa1e8b891d7bc6aa8fd379faf97b03b05c	7742632501382313	DaveHyatt 	2015-06-08 12:33:27	\N
085c6eef3541fb45593e339c80b047b78aeab197	7742632501382313	admin	2015-06-08 14:00:33	\N
de345b812794ca20ce09623bf0fd7c2aa7cd7b81	7742632501382313	BrianGrinstead	2015-06-08 14:27:46	\N
8f978f3e557d1c245ae1f7ec264e8964299f537b	7742632501382313	MikedeBoer	2015-06-08 14:30:07	\N
82c4969e2ceb03ac3f19e8f0267ff40128a98e45	7742632501382313	MarkBanner	2015-06-08 14:36:01	\N
6dab3a44764a03b5936201983858d9d7d6279ac4	7742632501382313	MarkBanner	2015-06-08 14:49:21	\N
38bc8559281634afbc51a48fe6ecbdd7142b7d2f	7742632501382313	DaveHyatt 	2015-06-08 14:51:49	\N
8ca685b3bee4fa13fba5f5003a8413977aaf7a59	7742632501382313	DaveHyatt 	2015-06-08 14:52:50	\N
00a9e0f16fa1e46cbc3c903d16f3b6b4e0059afb	7742632501382313	admin	2015-06-08 14:54:26	\N
75368487022b9cea3e8f54edf2f98fa181016787	7742632501382313	admin	2015-06-08 15:04:18	\N
1a8eea2d0c51ed473aeafe3326c4f46ffe306676	7742632501382313	admin	2015-06-09 10:12:51	\N
1ce300bd3ca373c55f9acdf75b38b9610ccc3782	7742632501382313	admin	2015-06-20 07:33:40	\N
ba6df89c34ada615e9db064bcac32ee46cc8a497	7742632501382313	admin	2015-06-20 07:42:48	\N
3c4acfd8257ec29b9f7d86a645ba5e0fbac7d514	7742632501382313	admin	2015-06-20 15:22:16	\N
e2b71a2803acb997202f2ebacf52caf95df4a9e0	7742632501382313	admin	2015-06-20 15:26:44	\N
b08538176ab9380d4df7d3b0075814fb57c30983	7742632501382313	admin	2015-06-20 15:29:34	\N
21cda57df59cc240163ed1bae17bd54a3e6ce3f6	7742632501382313	admin	2015-06-20 17:29:42	\N
5546bc0209f99625035e49f77c03704abc13296b	7742632501382313	admin	2015-06-22 06:51:33	\N
aedd94af4b72ab699663c2323f9b69c46f49445b	7742632501382313	admin	2015-06-22 07:51:59	\N
782c5ed7553926dc87bded3b5bc230c862182358	7742632501382313	admin	2015-06-25 10:53:55	\N
76ca709f43b083bc59da3b6950e66f526f1587f9	7742632501382313	admin	2015-07-08 08:10:47	\N
12513ab2b3529c9c7447d351ec0ddb8b292edd03	7742632501382313	admin	2016-01-26 12:30:46	\N
808bcf9997a1eb35b8e2cb88d9caba4960367d5a	7742632501382313	admin	2016-01-26 13:42:05	\N
b56559f43bffc3de1288d24c6e2ee766e118b807	7742632501382313	admin	2016-01-26 14:02:33	\N
a803ddb1e5e9240fc35858ed5a3d60157cd1ac44	7742632501382313	MarissaMayer	2016-01-26 15:33:38	\N
f7bb82a68eb3ec10873750f9b757a3d383403deb	7742632501382313	admin	2016-01-27 05:55:25	\N
56eb191d2f1b6e7c139f64b895cfd263cbb3e4d5	7742632501382313	admin	2016-01-27 06:39:43	\N
22740817e15449ee5eea29ebf50739150240858e	7742632501382313	admin	2016-01-27 07:43:02	\N
b766bc10095c27a38995c7be613a4d85f72cf140	7742632501382313	admin	2016-01-27 07:45:14	\N
7619d572644bca7bd62f25dd2413dcdb8454919c	7742632501382313	admin	2016-01-27 08:21:20	\N
6bb2db9d81b778307fa3cb19814893efdd330e03	7742632501382313	admin	2016-01-27 08:42:37	\N
39e93b31a302b260fee09561f77ea2a5d4708f81	7742632501382313	admin	2016-01-27 08:47:35	\N
6ec4da364229685cfce69d7f8180e5ce22b0a35a	7742632501382313	admin	2016-01-27 08:48:24	\N
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
1	2016-02-22 17:36:33.409	2016-02-22 17:36:33.409	Owner	Can view, create and edit org boards, and change settings for the organization.
2	2016-02-22 17:36:33.409	2016-02-22 17:36:33.409	Editor	Can view, create, and edit org boards, but not change settings.
3	2016-02-22 17:36:33.409	2016-02-22 17:36:33.409	Viewer	Can view only.
\.


--
-- Name: organization_user_roles_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('organization_user_roles_seq', 1, false);


--
-- Data for Name: organizations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY organizations (id, created, modified, user_id, name, website_url, description, logo_url, organization_visibility, organizations_user_count, board_count) FROM stdin;
2	2015-06-08 07:52:22.881582	2015-06-08 07:56:42.853215	1	Mozilla	https://www.mozilla.org		media/Organization/2/Mozilla.jpg	1	1	1
3	2015-06-08 07:57:04.683025	2015-06-08 07:57:37.924903	1	Yahoo!	https://yahoo.com		media/Organization/3/Yahoo.png	1	1	1
4	2015-06-08 07:57:47.095831	2015-06-08 07:58:14.618225	1	Apple	https://www.apple.com		media/Organization/4/Apple.png	1	1	1
\.


--
-- Name: organizations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('organizations_id_seq', 4, true);


--
-- Data for Name: organizations_users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY organizations_users (id, created, modified, organization_id, user_id, organization_user_role_id) FROM stdin;
2	2015-06-08 07:52:22.903892	2015-06-08 07:52:22.903892	2	1	1
3	2015-06-08 07:57:04.741936	2015-06-08 07:57:04.741936	3	1	1
4	2015-06-08 07:57:47.114834	2015-06-08 07:57:47.114834	4	1	1
\.


--
-- Name: organizations_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('organizations_users_id_seq', 4, true);


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
9	\N	\N	2	Enabled Login Options	Enabled Login Options	1
10	2016-01-12 16:39:35.919	2016-01-12 16:39:35.919	\N	IMAP	\N	5
\.


--
-- Name: setting_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('setting_categories_id_seq', 13, true);


--
-- Data for Name: settings; Type: TABLE DATA; Schema: public; Owner: -
--

COPY settings (id, setting_category_id, setting_category_parent_id, name, value, description, type, options, label, "order") FROM stdin;
11	3	0	SITE_NAME	Restya	\N	text	\N	Site Name	1
12	3	0	PAGING_COUNT	20	\N	text	\N	Paging Count	4
21	3	0	SITE_TIMEZONE	+0100	\N	text	\N	Site Timezone	5
18	6	0	DROPBOX_APPKEY		\N	text	\N	Dropbox App Key	1
20	6	0	FLICKR_API_KEY		\N	text	\N	Flickr API Key	2
19	3	0	LABEL_ICON	icon-circle	<a href="http://fortawesome.github.io/Font-Awesome/icons/" target="_blank">Font\r\nAwesome</a> class name. Recommended: icon-circle, icon-bullhorn,\r\nicon-tag, icon-bookmark, icon-pushpin, icon-star	text	\N	Label Icon	3
29	3	0	DEFAULT_REPLY_TO_EMAIL_ADDRESS	board@restya.com	\N	text	\N	Reply To Email Address	3
13	3	0	DEFAULT_FROM_EMAIL_ADDRESS	board@restya.com	\N	text	\N	From Email Address	2
31	3	0	DEFAULT_LANGUAGE	en_US	\N	text	\N	Default Language	6
32	10	0	IMAP_HOST		\N	text	\N	Incoming Mail Server	1
33	10	0	IMAP_PORT		e.g., 993	text	\N	Port	2
34	10	0	IMAP_EMAIL		\N	text	\N	Email address	3
35	10	0	IMAP_EMAIL_PASSWORD		\N	password	\N	Password	4
36	0	0	webhooks.last_processed_activity_id	0	\N	hidden	\N	Webhook Activity ID	0
39	11	0	XMPP_CLIENT_RESOURCE_NAME		\N	text	\N	Client Resource Name	3
30	3	0	DEFAULT_CONTACT_EMAIL_ADDRESS	board@restya.com	It is used in all outgoing emails	text	\N	Contact Email Address	4
42	3	0	DEFAULT_CARD_VIEW	Maximized	\N	select	Maximized,Normal Dockmodal	Default Card Open	7
22	3	0	STANDARD_LOGIN_ENABLED	true	\N	checkbox	\N	Standard login/register	8
\.


--
-- Name: settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('settings_id_seq', 60, true);


--
-- Data for Name: states; Type: TABLE DATA; Schema: public; Owner: -
--

COPY states (id, created, modified, country_id, name, is_active) FROM stdin;
1	2015-05-21 11:45:47.229	2015-05-21 11:45:47.229	240	Massachusetts	f
3	2016-01-12 17:00:46.037	2016-01-12 17:00:46.037	102		f
\.


--
-- Name: states_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('states_id_seq', 15138, false);


--
-- Name: states_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('states_id_seq1', 3, true);


--
-- Data for Name: user_logins; Type: TABLE DATA; Schema: public; Owner: -
--

COPY user_logins (id, created, modified, user_id, ip_id, user_agent) FROM stdin;
1	2015-05-21 11:45:47.266	2015-05-21 11:45:47.266	1	1	Mozilla/5.0 (Windows NT 6.3; WOW64; rv:38.0) Gecko/20100101 Firefox/38.0
2	2015-05-25 08:56:45.897776	2015-05-25 08:56:45.897776	1	1	Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.65 Safari/537.36
3	2015-05-25 09:09:32.956097	2015-05-25 09:09:32.956097	1	1	Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.65 Safari/537.36
4	2015-05-25 09:45:39.132988	2015-05-25 09:45:39.132988	1	1	Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.65 Safari/537.36
5	2015-05-25 09:51:00.321673	2015-05-25 09:51:00.321673	1	1	Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.65 Safari/537.36
6	2015-05-25 09:51:49.96895	2015-05-25 09:51:49.96895	3	1	Mozilla/5.0 (Windows NT 6.3; WOW64; rv:38.0) Gecko/20100101 Firefox/38.0
7	2015-05-25 10:47:01.919887	2015-05-25 10:47:01.919887	3	1	Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.65 Safari/537.36
8	2015-05-25 10:49:08.217055	2015-05-25 10:49:08.217055	3	1	Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.65 Safari/537.36
9	2015-05-25 10:54:18.714549	2015-05-25 10:54:18.714549	1	1	Mozilla/5.0 (Windows NT 6.3; WOW64; rv:38.0) Gecko/20100101 Firefox/38.0
10	2015-05-25 10:54:34.189001	2015-05-25 10:54:34.189001	1	1	Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.65 Safari/537.36
11	2015-05-25 11:03:53.106369	2015-05-25 11:03:53.106369	5	1	Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.65 Safari/537.36
12	2015-05-25 11:09:58.899718	2015-05-25 11:09:58.899718	6	1	Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.65 Safari/537.36
13	2015-05-25 11:33:31.689642	2015-05-25 11:33:31.689642	1	1	Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.65 Safari/537.36
14	2015-05-25 12:00:03.448286	2015-05-25 12:00:03.448286	6	1	Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.65 Safari/537.36
15	2015-05-25 12:02:39.042579	2015-05-25 12:02:39.042579	5	1	Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.65 Safari/537.36
16	2015-05-25 12:03:26.349293	2015-05-25 12:03:26.349293	5	1	Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.65 Safari/537.36
17	2015-05-25 12:10:29.883606	2015-05-25 12:10:29.883606	7	1	Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.65 Safari/537.36
18	2015-05-25 12:12:29.488809	2015-05-25 12:12:29.488809	8	1	Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.65 Safari/537.36
19	2015-05-25 12:14:44.267497	2015-05-25 12:14:44.267497	9	1	Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.65 Safari/537.36
20	2015-05-25 12:15:23.090987	2015-05-25 12:15:23.090987	10	1	Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.65 Safari/537.36
21	2015-05-25 12:18:53.925424	2015-05-25 12:18:53.925424	7	1	Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.65 Safari/537.36
22	2015-05-25 12:19:29.249156	2015-05-25 12:19:29.249156	7	1	Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.65 Safari/537.36
23	2015-05-25 12:32:53.904392	2015-05-25 12:32:53.904392	11	1	Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.65 Safari/537.36
24	2015-05-25 12:33:27.519855	2015-05-25 12:33:27.519855	11	1	Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.65 Safari/537.36
25	2015-05-25 12:42:52.950211	2015-05-25 12:42:52.950211	12	1	Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.65 Safari/537.36
26	2015-05-25 14:00:33.592527	2015-05-25 14:00:33.592527	1	1	Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.65 Safari/537.36
27	2015-05-25 14:27:46.224322	2015-05-25 14:27:46.224322	13	1	Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.65 Safari/537.36
28	2015-05-25 14:30:07.111239	2015-05-25 14:30:07.111239	14	1	Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.65 Safari/537.36
29	2015-05-25 14:36:01.84882	2015-05-25 14:36:01.84882	15	1	Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.65 Safari/537.36
30	2015-05-25 14:47:08.10051	2015-05-25 14:47:08.10051	12	1	Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.65 Safari/537.36
31	2015-05-25 14:49:21.184766	2015-05-25 14:49:21.184766	15	1	Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.65 Safari/537.36
32	2015-05-25 14:51:49.507515	2015-05-25 14:51:49.507515	11	1	Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.65 Safari/537.36
33	2015-05-25 14:52:50.338553	2015-05-25 14:52:50.338553	11	1	Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.65 Safari/537.36
34	2015-05-25 14:53:24.070752	2015-05-25 14:53:24.070752	12	1	Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.65 Safari/537.36
35	2015-05-25 14:54:26.240299	2015-05-25 14:54:26.240299	1	1	Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.73 Safari/537.36
36	2015-05-25 15:04:17.982329	2015-05-25 15:04:17.982329	1	1	Mozilla/5.0 (Windows NT 6.3; WOW64; rv:38.0) Gecko/20100101 Firefox/38.0
37	2015-05-26 13:42:51.319	2015-05-26 13:42:51.319	1	1	Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.65 Safari/537.36
38	2015-06-06 11:03:39.954	2015-06-06 11:03:39.954	1	1	Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.81 Safari/537.36
39	2015-06-06 07:42:48.846815	2015-06-06 07:42:48.846815	1	1	Mozilla/5.0 (Windows NT 6.3; WOW64; rv:38.0) Gecko/20100101 Firefox/38.0
40	2015-06-06 15:22:16.499847	2015-06-06 15:22:16.499847	1	1	Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.81 Safari/537.36
41	2015-06-06 15:26:44.868585	2015-06-06 15:26:44.868585	1	1	Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.30 Safari/537.36
42	2015-06-06 15:29:34.085245	2015-06-06 15:29:34.085245	1	1	Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.81 Safari/537.36
43	2015-06-06 17:29:42.400168	2015-06-06 17:29:42.400168	1	1	Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.30 Safari/537.36
44	2015-06-08 06:51:30.764194	2015-06-08 06:51:30.764194	1	1	Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.81 Safari/537.36
45	2015-06-08 07:51:59.886476	2015-06-08 07:51:59.886476	1	1	Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.81 Safari/537.36
46	2015-06-10 17:24:51.85	2015-06-10 17:24:51.85	6	1	Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.81 Safari/537.36
47	2015-06-11 14:23:55.835	2015-06-11 14:23:55.835	1	1	Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.124 Safari/537.36
48	2015-06-11 14:25:36.436	2015-06-11 14:25:36.436	6	1	Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.124 Safari/537.36
49	2015-06-24 11:40:47.64	2015-06-24 11:40:47.64	1	1	Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.130 Safari/537.36
50	2016-01-12 17:00:46.077	2016-01-12 17:00:46.077	1	3	Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36
51	2016-01-12 18:12:05.214	2016-01-12 18:12:05.214	1	4	Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36
52	2016-01-12 18:32:33.189	2016-01-12 18:32:33.189	1	5	Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36
53	2016-01-12 18:33:55.757	2016-01-12 18:33:55.757	12	5	Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36
54	2016-01-12 19:21:52.669	2016-01-12 19:21:52.669	5	5	Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36
55	2016-01-12 19:26:50.232	2016-01-12 19:26:50.232	7	5	Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36
56	2016-01-12 19:37:59.271	2016-01-12 19:37:59.271	6	5	Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36
57	2016-01-12 19:59:43.402	2016-01-12 19:59:43.402	12	5	Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36
58	2016-01-12 20:02:11.098	2016-01-12 20:02:11.098	5	5	Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36
59	2016-01-12 20:02:53.086	2016-01-12 20:02:53.086	7	5	Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36
60	2016-01-12 20:03:38.62	2016-01-12 20:03:38.62	6	5	Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36
61	2016-01-13 10:25:24.612	2016-01-13 10:25:24.612	1	4	Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36
62	2016-01-13 11:09:43.752	2016-01-13 11:09:43.752	1	3	Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36
63	2016-01-13 12:13:02.088	2016-01-13 12:13:02.088	1	4	Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36
64	2016-01-13 12:15:13.967	2016-01-13 12:15:13.967	1	6	Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36
65	2016-01-13 12:51:20.583	2016-01-13 12:51:20.583	1	3	Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36
66	2016-01-13 13:12:37.543	2016-01-13 13:12:37.543	1	4	Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36
67	2016-01-13 13:17:35.308	2016-01-13 13:17:35.308	1	7	Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36
68	2016-01-13 13:18:23.976	2016-01-13 13:18:23.976	1	5	Mozilla/5.0 (Windows NT 6.3; WOW64; rv:43.0) Gecko/20100101 Firefox/43.0
\.


--
-- Name: user_logins_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('user_logins_id_seq', 68, true);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY users (id, created, modified, role_id, username, email, password, full_name, initials, about_me, profile_picture_path, notification_frequency, is_allow_desktop_notification, is_active, is_email_confirmed, created_organization_count, created_board_count, joined_organization_count, list_count, joined_card_count, created_card_count, joined_board_count, checklist_count, checklist_item_completed_count, checklist_item_count, activity_count, card_voter_count, last_activity_id, last_login_date, last_login_ip_id, ip_id, login_type_id, is_productivity_beats, user_login_count, is_ldap, is_send_newsletter, last_email_notified_activity_id, owner_board_count, member_board_count, owner_organization_count, member_organization_count, language, timezone) FROM stdin;
10	2015-05-25 12:13:58.083139	2015-05-25 12:13:58.083139	2	RobertMorris	board+RobertMorris@restya.com	$2y$12$QiJW6TjPKzDZPAuoWEex9OjPHQF33YzfkdC09FhasgPO.MjZ5btKe	Robert Morris	RM	\N	\N	\N	f	t	t	0	0	0	0	0	0	0	0	0	0	0	0	0	2015-05-25 12:15:23.080662	1	1	2	t	1	f	0	0	0	0	0	0	\N	+0530
8	2015-05-25 12:11:49.712672	2015-05-25 12:11:49.712672	2	PaulGraham	board+PaulGraham@restya.com	$2y$12$QiJW6TjPKzDZPAuoWEex9OjPHQF33YzfkdC09FhasgPO.MjZ5btKe	Paul Graham	PG	\N	\N	\N	f	t	t	0	0	0	0	0	0	0	0	0	0	0	0	0	2015-05-25 12:12:29.464286	1	1	2	t	1	f	0	0	0	0	0	0	\N	+0530
9	2015-05-25 12:13:26.053729	2015-05-25 12:13:26.053729	2	JessicaLivings	board+Livingston@restya.com	$2y$12$QiJW6TjPKzDZPAuoWEex9OjPHQF33YzfkdC09FhasgPO.MjZ5btKe	Jessica Livings	JL	\N	\N	\N	f	t	t	0	0	0	0	0	0	0	0	0	0	0	0	0	2015-05-25 12:14:44.238055	1	1	2	t	1	f	0	0	0	0	0	0	\N	+0530
11	2015-05-25 12:29:45.598166	2015-05-25 12:29:45.598166	2	DaveHyatt 	board+dave@restya.com	$2y$12$QiJW6TjPKzDZPAuoWEex9OjPHQF33YzfkdC09FhasgPO.MjZ5btKe	Dave Hyatt	DH	\N	\N	\N	f	t	t	0	0	0	0	6	0	1	0	0	0	0	0	0	2015-05-25 14:52:50.254176	1	1	2	t	4	f	0	0	1	0	0	0	\N	+0530
7	2015-05-25 12:06:37.126442	2015-05-25 12:07:09.14728	2	TrevorBlackwell	board+TrevorBlackwell@restya.com	$2y$12$QiJW6TjPKzDZPAuoWEex9OjPHQF33YzfkdC09FhasgPO.MjZ5btKe	Trevor Blackwell	TB	\N	\N	\N	f	t	t	0	1	0	3	5	90	1	1	0	1	148	1	0	2016-01-12 20:02:53.084	5	1	2	t	5	f	0	0	1	0	0	0	\N	+0530
1	2014-06-03 12:40:41.189	2016-01-13 13:23:24.924	1	admin	board@restya.com	$2y$12$QiJW6TjPKzDZPAuoWEex9OjPHQF33YzfkdC09FhasgPO.MjZ5btKe	Admin	A		media/User/1/default-admin-user.png	\N	f	t	t	3	0	3	0	0	0	0	0	0	0	33	0	1200	2016-01-13 13:18:23.97	5	1	2	t	33	f	0	0	0	0	3	0	\N	+0530
2	2014-07-05 11:46:40.804	2014-07-05 11:46:40.804	2	user	board+user@restya.com	$2y$12$QiJW6TjPKzDZPAuoWEex9OjPHQF33YzfkdC09FhasgPO.MjZ5btKe	User	U	\N	\N	\N	f	t	t	0	0	0	0	2	0	4	0	0	0	0	0	0	\N	1	1	\N	t	0	f	0	0	4	0	0	0	\N	+0530
14	2015-05-25 14:29:39.237901	2015-05-25 14:29:39.237901	2	MikedeBoer	board+mike@restya.com	$2y$12$QiJW6TjPKzDZPAuoWEex9OjPHQF33YzfkdC09FhasgPO.MjZ5btKe	Mikede Boer	MB	\N	\N	\N	f	t	t	0	0	0	0	5	0	1	0	0	0	0	0	0	2015-05-25 14:30:07.085623	1	1	2	t	1	f	0	0	0	1	0	0	\N	+0530
13	2015-05-25 14:26:50.934329	2015-05-25 14:26:50.934329	2	BrianGrinstead	board+brian@restya.com	$2y$12$QiJW6TjPKzDZPAuoWEex9OjPHQF33YzfkdC09FhasgPO.MjZ5btKe	Brian Grinstead	BG	\N	\N	\N	f	t	t	0	0	0	0	8	0	1	0	0	0	0	0	0	2015-05-25 14:27:46.214209	1	1	2	t	1	f	0	0	0	1	0	0	\N	+0530
15	2015-05-25 14:34:51.584714	2015-05-25 14:34:51.584714	2	MarkBanner	board+Mark@restya.com	$2y$12$QiJW6TjPKzDZPAuoWEex9OjPHQF33YzfkdC09FhasgPO.MjZ5btKe	Mark Banner	MB	\N	\N	\N	f	t	t	0	0	0	0	4	0	1	0	0	0	0	0	0	2015-05-25 14:49:21.175059	1	1	2	t	2	f	0	0	0	1	0	0	\N	+0530
12	2015-05-25 12:42:30.636438	2016-01-12 20:00:00.743	2	BlakeRoss	board+blake@restya.com	$2y$12$QiJW6TjPKzDZPAuoWEex9OjPHQF33YzfkdC09FhasgPO.MjZ5btKe	Blake Ross	BR	\N	media/User/12/Blake_Ross.jpg	\N	f	t	t	0	1	0	9	1	40	1	40	62	197	452	3	1113	2016-01-12 19:59:43.401	5	1	2	t	5	f	0	0	0	1	0	0	\N	+0530
5	2015-05-25 11:02:56.605763	2015-05-25 11:02:56.605763	2	SteveJobs	board+SteveJobs@restya.com	$2y$12$QiJW6TjPKzDZPAuoWEex9OjPHQF33YzfkdC09FhasgPO.MjZ5btKe	Steve Jobs	SJ	\N	media/User/5/Steve_Jobs_with_red_shawl_edit2.jpg	\N	f	t	t	0	1	0	1	2	24	1	0	0	0	39	1	0	2016-01-12 20:02:11.097	5	1	2	t	5	f	0	0	1	0	0	0	\N	+0530
6	2015-05-25 11:09:33.770516	2016-01-12 19:42:06.435	2	MarissaMayer	board+MarissaMayer@restya.com	$2y$12$QiJW6TjPKzDZPAuoWEex9OjPHQF33YzfkdC09FhasgPO.MjZ5btKe	Marissa Mayer	MM	\N	media/User/6/640px-MarissaMayer2011Interview.jpg	\N	f	t	t	0	1	0	3	2	47	1	1	0	0	73	2	0	2016-01-12 20:03:38.619	5	1	2	t	6	f	0	0	1	0	0	0	\N	+0530
\.


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('users_id_seq', 15, true);


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
-- Name: acl_board_links_boards_user_roles_id; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY acl_board_links_boards_user_roles
    ADD CONSTRAINT acl_board_links_boards_user_roles_id PRIMARY KEY (id);


--
-- Name: acl_board_links_id; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY acl_board_links
    ADD CONSTRAINT acl_board_links_id PRIMARY KEY (id);


--
-- Name: acl_links_roles_id; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY acl_links_roles
    ADD CONSTRAINT acl_links_roles_id PRIMARY KEY (id);


--
-- Name: acl_organization_links_id; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY acl_organization_links
    ADD CONSTRAINT acl_organization_links_id PRIMARY KEY (id);


--
-- Name: acl_organization_links_organizations_user_roles_id; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY acl_organization_links_organizations_user_roles
    ADD CONSTRAINT acl_organization_links_organizations_user_roles_id PRIMARY KEY (id);


--
-- Name: activities_id; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY activities
    ADD CONSTRAINT activities_id PRIMARY KEY (id);


--
-- Name: board_stars_id; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY board_stars
    ADD CONSTRAINT board_stars_id PRIMARY KEY (id);


--
-- Name: board_subscribers_id; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY board_subscribers
    ADD CONSTRAINT board_subscribers_id PRIMARY KEY (id);


--
-- Name: board_user_roles_id; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY board_user_roles
    ADD CONSTRAINT board_user_roles_id PRIMARY KEY (id);


--
-- Name: board_users_id; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY boards_users
    ADD CONSTRAINT board_users_id PRIMARY KEY (id);


--
-- Name: boards_id; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY boards
    ADD CONSTRAINT boards_id PRIMARY KEY (id);


--
-- Name: card_attachments_id; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY card_attachments
    ADD CONSTRAINT card_attachments_id PRIMARY KEY (id);


--
-- Name: card_subscribers_id; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY card_subscribers
    ADD CONSTRAINT card_subscribers_id PRIMARY KEY (id);


--
-- Name: card_users_id; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cards_users
    ADD CONSTRAINT card_users_id PRIMARY KEY (id);


--
-- Name: card_voters_id; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY card_voters
    ADD CONSTRAINT card_voters_id PRIMARY KEY (id);


--
-- Name: cards_id; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cards
    ADD CONSTRAINT cards_id PRIMARY KEY (id);


--
-- Name: cards_labels_id; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cards_labels
    ADD CONSTRAINT cards_labels_id PRIMARY KEY (id);


--
-- Name: checklist_items_id; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY checklist_items
    ADD CONSTRAINT checklist_items_id PRIMARY KEY (id);


--
-- Name: checklists_id; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY checklists
    ADD CONSTRAINT checklists_id PRIMARY KEY (id);


--
-- Name: cities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cities
    ADD CONSTRAINT cities_pkey PRIMARY KEY (id);


--
-- Name: countries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (id);


--
-- Name: email_templates_id; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY email_templates
    ADD CONSTRAINT email_templates_id PRIMARY KEY (id);


--
-- Name: ips_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ips
    ADD CONSTRAINT ips_pkey PRIMARY KEY (id);


--
-- Name: labels_id; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY labels
    ADD CONSTRAINT labels_id PRIMARY KEY (id);


--
-- Name: lists_id; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY lists
    ADD CONSTRAINT lists_id PRIMARY KEY (id);


--
-- Name: lists_subscribers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY list_subscribers
    ADD CONSTRAINT lists_subscribers_pkey PRIMARY KEY (id);


--
-- Name: login_types_id; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY login_types
    ADD CONSTRAINT login_types_id PRIMARY KEY (id);


--
-- Name: oauth_access_tokens_access_token; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY oauth_access_tokens
    ADD CONSTRAINT oauth_access_tokens_access_token PRIMARY KEY (access_token);


--
-- Name: oauth_authorization_codes_authorization_code; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY oauth_authorization_codes
    ADD CONSTRAINT oauth_authorization_codes_authorization_code PRIMARY KEY (authorization_code);


--
-- Name: oauth_clients_client_id; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY oauth_clients
    ADD CONSTRAINT oauth_clients_client_id PRIMARY KEY (client_id);


--
-- Name: oauth_jwt_client_id; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY oauth_jwt
    ADD CONSTRAINT oauth_jwt_client_id PRIMARY KEY (client_id);


--
-- Name: oauth_refresh_tokens_refresh_token; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY oauth_refresh_tokens
    ADD CONSTRAINT oauth_refresh_tokens_refresh_token PRIMARY KEY (refresh_token);


--
-- Name: organization_user_roles_id; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY organization_user_roles
    ADD CONSTRAINT organization_user_roles_id PRIMARY KEY (id);


--
-- Name: organization_users_id; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY organizations_users
    ADD CONSTRAINT organization_users_id PRIMARY KEY (id);


--
-- Name: organizations_id; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY organizations
    ADD CONSTRAINT organizations_id PRIMARY KEY (id);


--
-- Name: roles_id; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT roles_id PRIMARY KEY (id);


--
-- Name: setting_categories_id; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY setting_categories
    ADD CONSTRAINT setting_categories_id PRIMARY KEY (id);


--
-- Name: settings_id; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY settings
    ADD CONSTRAINT settings_id PRIMARY KEY (id);


--
-- Name: states_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY states
    ADD CONSTRAINT states_pkey PRIMARY KEY (id);


--
-- Name: user_logins_id; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_logins
    ADD CONSTRAINT user_logins_id PRIMARY KEY (id);


--
-- Name: users_id; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_id PRIMARY KEY (id);


--
-- Name: webhooks_id; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY webhooks
    ADD CONSTRAINT webhooks_id PRIMARY KEY (id);


--
-- Name: acl_board_links_boards_user_roles_acl_board_link_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX acl_board_links_boards_user_roles_acl_board_link_id ON acl_board_links_boards_user_roles USING btree (acl_board_link_id);


--
-- Name: acl_board_links_boards_user_roles_board_user_role_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX acl_board_links_boards_user_roles_board_user_role_id ON acl_board_links_boards_user_roles USING btree (board_user_role_id);


--
-- Name: acl_board_links_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX acl_board_links_group_id ON acl_board_links USING btree (group_id);


--
-- Name: acl_board_links_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX acl_board_links_slug ON acl_board_links USING btree (slug);


--
-- Name: acl_board_links_url; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX acl_board_links_url ON acl_board_links USING btree (url);


--
-- Name: acl_links_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX acl_links_group_id ON acl_links USING btree (group_id);


--
-- Name: acl_links_roles_acl_link_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX acl_links_roles_acl_link_id ON acl_links_roles USING btree (acl_link_id);


--
-- Name: acl_links_roles_role_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX acl_links_roles_role_id ON acl_links_roles USING btree (role_id);


--
-- Name: acl_links_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX acl_links_slug ON acl_links USING btree (slug);


--
-- Name: acl_organization_links_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX acl_organization_links_group_id ON acl_organization_links USING btree (group_id);


--
-- Name: acl_organization_links_organizations_user_roles_acl_organizatio; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX acl_organization_links_organizations_user_roles_acl_organizatio ON acl_organization_links_organizations_user_roles USING btree (acl_organization_link_id);


--
-- Name: acl_organization_links_organizations_user_roles_organization_us; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX acl_organization_links_organizations_user_roles_organization_us ON acl_organization_links_organizations_user_roles USING btree (organization_user_role_id);


--
-- Name: acl_organization_links_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX acl_organization_links_slug ON acl_organization_links USING btree (slug);


--
-- Name: acl_organization_links_url; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX acl_organization_links_url ON acl_organization_links USING btree (url);


--
-- Name: activities_attachment_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX activities_attachment_id ON activities USING btree (foreign_id);


--
-- Name: activities_board_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX activities_board_id ON activities USING btree (board_id);


--
-- Name: activities_card_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX activities_card_id ON activities USING btree (card_id);


--
-- Name: activities_depth; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX activities_depth ON activities USING btree (depth);


--
-- Name: activities_freshness_ts; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX activities_freshness_ts ON activities USING btree (freshness_ts);


--
-- Name: activities_list_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX activities_list_id ON activities USING btree (list_id);


--
-- Name: activities_materialized_path; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX activities_materialized_path ON activities USING btree (materialized_path);


--
-- Name: activities_path; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX activities_path ON activities USING btree (path);


--
-- Name: activities_root; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX activities_root ON activities USING btree (root);


--
-- Name: activities_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX activities_type ON activities USING btree (type);


--
-- Name: activities_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX activities_user_id ON activities USING btree (user_id);


--
-- Name: attachments_card_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX attachments_card_id ON card_attachments USING btree (card_id);


--
-- Name: board_stars_board_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX board_stars_board_id ON board_stars USING btree (board_id);


--
-- Name: board_stars_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX board_stars_user_id ON board_stars USING btree (user_id);


--
-- Name: board_subscribers_board_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX board_subscribers_board_id ON board_subscribers USING btree (board_id);


--
-- Name: board_subscribers_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX board_subscribers_user_id ON board_subscribers USING btree (user_id);


--
-- Name: board_users_board_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX board_users_board_id ON boards_users USING btree (board_id);


--
-- Name: board_users_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX board_users_user_id ON boards_users USING btree (user_id);


--
-- Name: boards_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX boards_organization_id ON boards USING btree (organization_id);


--
-- Name: boards_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX boards_user_id ON boards USING btree (user_id);


--
-- Name: boards_users_board_user_role_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX boards_users_board_user_role_id ON boards_users USING btree (board_user_role_id);


--
-- Name: card_attachments_board_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX card_attachments_board_id ON card_attachments USING btree (board_id);


--
-- Name: card_attachments_list_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX card_attachments_list_id ON card_attachments USING btree (list_id);


--
-- Name: card_subscribers_card_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX card_subscribers_card_id ON card_subscribers USING btree (card_id);


--
-- Name: card_subscribers_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX card_subscribers_user_id ON card_subscribers USING btree (user_id);


--
-- Name: card_users_card_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX card_users_card_id ON cards_users USING btree (card_id);


--
-- Name: card_users_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX card_users_user_id ON cards_users USING btree (user_id);


--
-- Name: card_voters_card_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX card_voters_card_id ON card_voters USING btree (card_id);


--
-- Name: card_voters_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX card_voters_user_id ON card_voters USING btree (user_id);


--
-- Name: cards_board_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX cards_board_id ON cards USING btree (board_id);


--
-- Name: cards_labels_board_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX cards_labels_board_id ON cards_labels USING btree (board_id);


--
-- Name: cards_labels_card_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX cards_labels_card_id ON cards_labels USING btree (card_id);


--
-- Name: cards_labels_label_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX cards_labels_label_id ON cards_labels USING btree (label_id);


--
-- Name: cards_labels_list_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX cards_labels_list_id ON cards_labels USING btree (list_id);


--
-- Name: cards_list_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX cards_list_id ON cards USING btree (list_id);


--
-- Name: cards_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX cards_user_id ON cards USING btree (user_id);


--
-- Name: checklist_items_card_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX checklist_items_card_id ON checklist_items USING btree (card_id);


--
-- Name: checklist_items_checklist_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX checklist_items_checklist_id ON checklist_items USING btree (checklist_id);


--
-- Name: checklist_items_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX checklist_items_user_id ON checklist_items USING btree (user_id);


--
-- Name: checklists_card_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX checklists_card_id ON checklists USING btree (card_id);


--
-- Name: checklists_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX checklists_user_id ON checklists USING btree (user_id);


--
-- Name: email_templates_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX email_templates_name ON email_templates USING btree (name);


--
-- Name: ips_city_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ips_city_id ON ips USING btree (city_id);


--
-- Name: ips_country_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ips_country_id ON ips USING btree (country_id);


--
-- Name: ips_ip; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ips_ip ON ips USING btree (ip);


--
-- Name: ips_state_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ips_state_id ON ips USING btree (state_id);


--
-- Name: labels_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX labels_name ON labels USING btree (name);


--
-- Name: list_subscribers_list_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX list_subscribers_list_id ON list_subscribers USING btree (list_id);


--
-- Name: list_subscribers_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX list_subscribers_user_id ON list_subscribers USING btree (user_id);


--
-- Name: lists_board_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX lists_board_id ON lists USING btree (board_id);


--
-- Name: lists_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX lists_user_id ON lists USING btree (user_id);


--
-- Name: oauth_access_tokens_client_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX oauth_access_tokens_client_id ON oauth_access_tokens USING btree (client_id);


--
-- Name: oauth_access_tokens_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX oauth_access_tokens_user_id ON oauth_access_tokens USING btree (user_id);


--
-- Name: oauth_authorization_codes_client_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX oauth_authorization_codes_client_id ON oauth_authorization_codes USING btree (client_id);


--
-- Name: oauth_authorization_codes_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX oauth_authorization_codes_user_id ON oauth_authorization_codes USING btree (user_id);


--
-- Name: oauth_clients_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX oauth_clients_user_id ON oauth_clients USING btree (user_id);


--
-- Name: oauth_refresh_tokens_client_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX oauth_refresh_tokens_client_id ON oauth_refresh_tokens USING btree (client_id);


--
-- Name: oauth_refresh_tokens_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX oauth_refresh_tokens_user_id ON oauth_refresh_tokens USING btree (user_id);


--
-- Name: organization_users_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX organization_users_organization_id ON organizations_users USING btree (organization_id);


--
-- Name: organization_users_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX organization_users_user_id ON organizations_users USING btree (user_id);


--
-- Name: organizations_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX organizations_user_id ON organizations USING btree (user_id);


--
-- Name: organizations_users_organization_user_role_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX organizations_users_organization_user_role_id ON organizations_users USING btree (organization_user_role_id);


--
-- Name: roles_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX roles_name ON roles USING btree (name);


--
-- Name: setting_categories_parent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX setting_categories_parent_id ON setting_categories USING btree (parent_id);


--
-- Name: settings_setting_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX settings_setting_category_id ON settings USING btree (setting_category_id);


--
-- Name: settings_setting_category_parent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX settings_setting_category_parent_id ON settings USING btree (setting_category_parent_id);


--
-- Name: user_logins_ip_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX user_logins_ip_id ON user_logins USING btree (ip_id);


--
-- Name: user_logins_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX user_logins_user_id ON user_logins USING btree (user_id);


--
-- Name: users_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX users_email ON users USING btree (email);


--
-- Name: users_ip_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX users_ip_id ON users USING btree (ip_id);


--
-- Name: users_last_activity_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX users_last_activity_id ON users USING btree (last_activity_id);


--
-- Name: users_last_email_notified_activity_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX users_last_email_notified_activity_id ON users USING btree (last_email_notified_activity_id);


--
-- Name: users_last_login_ip_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX users_last_login_ip_id ON users USING btree (last_login_ip_id);


--
-- Name: users_login_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX users_login_type_id ON users USING btree (login_type_id);


--
-- Name: users_role_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX users_role_id ON users USING btree (role_id);


--
-- Name: users_username; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX users_username ON users USING btree (username);


--
-- Name: webhooks_url; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX webhooks_url ON webhooks USING btree (url);


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
-- Name: cities; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE cities FROM PUBLIC;
REVOKE ALL ON TABLE cities FROM postgres;
GRANT ALL ON TABLE cities TO postgres;


--
-- Name: countries; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE countries FROM PUBLIC;
REVOKE ALL ON TABLE countries FROM postgres;
GRANT ALL ON TABLE countries TO postgres;


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
-- Name: states; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE states FROM PUBLIC;
REVOKE ALL ON TABLE states FROM postgres;
GRANT ALL ON TABLE states TO postgres;


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
-- Name: languages_id_seq; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON SEQUENCE languages_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE languages_id_seq FROM postgres;
GRANT ALL ON SEQUENCE languages_id_seq TO postgres;


--
-- Name: languages; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE languages FROM PUBLIC;
REVOKE ALL ON TABLE languages FROM postgres;
GRANT ALL ON TABLE languages TO postgres;


--
-- Name: list_subscribers_id_seq; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON SEQUENCE list_subscribers_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE list_subscribers_id_seq FROM postgres;
GRANT ALL ON SEQUENCE list_subscribers_id_seq TO postgres;


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

