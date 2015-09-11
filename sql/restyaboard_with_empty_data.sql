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
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: label_card_count_update(); Type: FUNCTION; Schema: public; Owner: postgres
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


ALTER FUNCTION public.label_card_count_update() OWNER TO postgres;

--
-- Name: update_board_count(); Type: FUNCTION; Schema: public; Owner: postgres
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


ALTER FUNCTION public.update_board_count() OWNER TO postgres;

--
-- Name: update_board_star_count(); Type: FUNCTION; Schema: public; Owner: postgres
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


ALTER FUNCTION public.update_board_star_count() OWNER TO postgres;

--
-- Name: update_board_subscriber_count(); Type: FUNCTION; Schema: public; Owner: postgres
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


ALTER FUNCTION public.update_board_subscriber_count() OWNER TO postgres;

--
-- Name: update_board_user_count(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION update_board_user_count() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN

	IF (TG_OP = 'DELETE') THEN

		UPDATE "boards" SET "boards_user_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "boards_users" WHERE "board_id" = OLD."board_id") t WHERE "id" = OLD."board_id";

		UPDATE "users" SET "joined_board_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "boards_users" WHERE "user_id" = OLD."user_id") t WHERE "id" = OLD."user_id";

		RETURN OLD;

	ELSIF (TG_OP = 'UPDATE') THEN

		UPDATE "boards" SET "boards_user_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "boards_users" WHERE "board_id" = OLD."board_id") t WHERE "id" = OLD."board_id";

		UPDATE "boards" SET "boards_user_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "boards_users" WHERE "board_id" = NEW."board_id") t WHERE "id" = NEW."board_id";

	        UPDATE "users" SET "joined_board_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "boards_users" WHERE "user_id" = OLD."user_id") t WHERE "id" = OLD."user_id";

	        UPDATE "users" SET "joined_board_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "boards_users" WHERE "user_id" = NEW."user_id") t WHERE "id" = NEW."user_id";

		RETURN OLD;

	ELSIF (TG_OP = 'INSERT') THEN

		UPDATE "boards" SET "boards_user_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "boards_users" WHERE "board_id" = NEW."board_id") t WHERE "id" = NEW."board_id";

	        UPDATE "users" SET "joined_board_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "boards_users" WHERE "user_id" = NEW."user_id") t WHERE "id" = NEW."user_id";

		RETURN NEW;

	END IF;

END;

$$;


ALTER FUNCTION public.update_board_user_count() OWNER TO postgres;

--
-- Name: update_card_activity_count(); Type: FUNCTION; Schema: public; Owner: postgres
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


ALTER FUNCTION public.update_card_activity_count() OWNER TO postgres;

--
-- Name: update_card_attachment_count(); Type: FUNCTION; Schema: public; Owner: postgres
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


ALTER FUNCTION public.update_card_attachment_count() OWNER TO postgres;

--
-- Name: update_card_checklist_count(); Type: FUNCTION; Schema: public; Owner: postgres
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


ALTER FUNCTION public.update_card_checklist_count() OWNER TO postgres;

--
-- Name: update_card_checklist_item_count(); Type: FUNCTION; Schema: public; Owner: postgres
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


ALTER FUNCTION public.update_card_checklist_item_count() OWNER TO postgres;

--
-- Name: update_card_count(); Type: FUNCTION; Schema: public; Owner: postgres
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


ALTER FUNCTION public.update_card_count() OWNER TO postgres;

--
-- Name: update_card_subscriber_count(); Type: FUNCTION; Schema: public; Owner: postgres
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


ALTER FUNCTION public.update_card_subscriber_count() OWNER TO postgres;

--
-- Name: update_card_user_count(); Type: FUNCTION; Schema: public; Owner: postgres
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


ALTER FUNCTION public.update_card_user_count() OWNER TO postgres;

--
-- Name: update_card_voters_count(); Type: FUNCTION; Schema: public; Owner: postgres
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


ALTER FUNCTION public.update_card_voters_count() OWNER TO postgres;

--
-- Name: update_comment_count(); Type: FUNCTION; Schema: public; Owner: postgres
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


ALTER FUNCTION public.update_comment_count() OWNER TO postgres;

--
-- Name: update_list_count(); Type: FUNCTION; Schema: public; Owner: postgres
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

		UPDATE "boards" SET "list_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "lists" WHERE  "board_id" = NEW."board_id") t WHERE "id" = NEW."board_id";

		UPDATE "users" SET "list_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "lists" WHERE "user_id" = OLD."user_id") t WHERE "id" = OLD."user_id";

		UPDATE "users" SET "list_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "lists" WHERE "user_id" = NEW."user_id") t WHERE "id" = NEW."user_id";

		RETURN OLD;

	ELSIF (TG_OP = 'INSERT') THEN

		UPDATE "boards" SET "list_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "lists" WHERE "board_id" = NEW."board_id") t WHERE "id" = NEW."board_id";

		UPDATE "users" SET "list_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "lists" WHERE "user_id" = NEW."user_id") t WHERE "id" = NEW."user_id";

		RETURN NEW;

	END IF;

END;

$$;


ALTER FUNCTION public.update_list_count() OWNER TO postgres;

--
-- Name: update_list_subscriber_count(); Type: FUNCTION; Schema: public; Owner: postgres
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


ALTER FUNCTION public.update_list_subscriber_count() OWNER TO postgres;

--
-- Name: update_organization_count(); Type: FUNCTION; Schema: public; Owner: postgres
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


ALTER FUNCTION public.update_organization_count() OWNER TO postgres;

--
-- Name: update_organization_user_count(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION update_organization_user_count() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN

	IF (TG_OP = 'DELETE') THEN

		UPDATE "organizations" SET "organizations_user_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "organizations_users" WHERE "organization_id" = OLD."organization_id") t WHERE "id" = OLD."organization_id";

	        UPDATE "users" SET "joined_organization_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "organizations_users" WHERE "user_id" = OLD."user_id") t WHERE "id" = OLD."user_id";

		RETURN OLD;

	ELSIF (TG_OP = 'UPDATE') THEN

		UPDATE "organizations" SET "organizations_user_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "organizations_users" WHERE "organization_id" = OLD."organization_id") t WHERE "id" = OLD."organization_id";

		UPDATE "organizations" SET "organizations_user_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "organizations_users" WHERE "organization_id" = NEW."organization_id") t WHERE "id" = NEW."organization_id";

	        UPDATE "users" SET "joined_organization_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "organizations_users" WHERE "user_id" = OLD."user_id") t WHERE "id" = OLD."user_id";

	        UPDATE "users" SET "joined_organization_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "organizations_users" WHERE "user_id" = NEW."user_id") t WHERE "id" = NEW."user_id";

		RETURN OLD;

	ELSIF (TG_OP = 'INSERT') THEN

		UPDATE "organizations" SET "organizations_user_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "organizations_users" WHERE "organization_id" = NEW."organization_id") t WHERE "id" = NEW."organization_id";

	        UPDATE "users" SET "joined_organization_count" = total_count FROM (SELECT COUNT(*) as total_count FROM "organizations_users" WHERE "user_id" = NEW."user_id") t WHERE "id" = NEW."user_id";

		RETURN NEW;

	END IF;

END;

$$;


ALTER FUNCTION public.update_organization_user_count() OWNER TO postgres;

--
-- Name: update_user_delete(); Type: FUNCTION; Schema: public; Owner: postgres
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


ALTER FUNCTION public.update_user_delete() OWNER TO postgres;

--
-- Name: update_users_user_login_count(); Type: FUNCTION; Schema: public; Owner: postgres
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


ALTER FUNCTION public.update_users_user_login_count() OWNER TO postgres;

--
-- Name: acl_links_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE acl_links_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE acl_links_id_seq OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: acl_links; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
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
    is_allow_only_to_admin smallint DEFAULT (0)::smallint NOT NULL,
    is_allow_only_to_user smallint DEFAULT (0)::smallint NOT NULL
);


ALTER TABLE acl_links OWNER TO postgres;

--
-- Name: acl_links_roles_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE acl_links_roles_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE acl_links_roles_roles_id_seq OWNER TO postgres;

--
-- Name: acl_links_roles; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE acl_links_roles (
    id bigint DEFAULT nextval('acl_links_roles_roles_id_seq'::regclass) NOT NULL,
    created timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    acl_link_id bigint NOT NULL,
    role_id bigint NOT NULL
);


ALTER TABLE acl_links_roles OWNER TO postgres;

--
-- Name: acl_links_listing; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW acl_links_listing AS
 SELECT aclr.role_id, 
    acl.slug, 
    acl.url, 
    acl.method
   FROM (acl_links_roles aclr
   JOIN acl_links acl ON ((acl.id = aclr.acl_link_id)));


ALTER TABLE acl_links_listing OWNER TO postgres;

--
-- Name: activities_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE activities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE activities_id_seq OWNER TO postgres;

--
-- Name: activities; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
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
    organization_id bigint DEFAULT 0::bigint
);


ALTER TABLE activities OWNER TO postgres;

--
-- Name: boards_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE boards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE boards_id_seq OWNER TO postgres;

--
-- Name: boards; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
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
    music_content text
);


ALTER TABLE boards OWNER TO postgres;

--
-- Name: cards_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE cards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cards_id_seq OWNER TO postgres;

--
-- Name: cards; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
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
    comment_count bigint DEFAULT (0)::bigint
);


ALTER TABLE cards OWNER TO postgres;

--
-- Name: cards_labels_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE cards_labels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cards_labels_id_seq OWNER TO postgres;

--
-- Name: cards_labels; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
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


ALTER TABLE cards_labels OWNER TO postgres;

--
-- Name: labels_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE labels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE labels_id_seq OWNER TO postgres;

--
-- Name: labels; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE labels (
    id bigint DEFAULT nextval('labels_id_seq'::regclass) NOT NULL,
    created timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    name character varying(255) NOT NULL,
    card_count bigint DEFAULT 0 NOT NULL
);


ALTER TABLE labels OWNER TO postgres;

--
-- Name: cards_labels_listing; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW cards_labels_listing AS
 SELECT cl.id, 
    cl.created, 
    cl.modified, 
    cl.label_id, 
    cl.card_id, 
    c.name AS card_name, 
    c.list_id, 
    l.name, 
    cl.board_id
   FROM ((cards_labels cl
   LEFT JOIN cards c ON ((c.id = cl.card_id)))
   LEFT JOIN labels l ON ((l.id = cl.label_id)));


ALTER TABLE cards_labels_listing OWNER TO postgres;

--
-- Name: checklist_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE checklist_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE checklist_items_id_seq OWNER TO postgres;

--
-- Name: checklist_items; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
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
    "position" double precision NOT NULL
);


ALTER TABLE checklist_items OWNER TO postgres;

--
-- Name: checklists_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE checklists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE checklists_id_seq OWNER TO postgres;

--
-- Name: checklists; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
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
    "position" double precision NOT NULL
);


ALTER TABLE checklists OWNER TO postgres;

--
-- Name: lists_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE lists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE lists_id_seq OWNER TO postgres;

--
-- Name: lists; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
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
    is_deleted boolean DEFAULT false NOT NULL
);


ALTER TABLE lists OWNER TO postgres;

--
-- Name: organizations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE organizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE organizations_id_seq OWNER TO postgres;

--
-- Name: organizations; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
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
    board_count bigint DEFAULT 0
);


ALTER TABLE organizations OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE users_id_seq
    START WITH 2
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE users_id_seq OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
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
    last_activity_id bigint,
    last_login_date timestamp without time zone,
    last_login_ip_id bigint,
    ip_id bigint,
    login_type_id smallint,
    is_productivity_beats boolean DEFAULT false NOT NULL,
    user_login_count bigint DEFAULT (0)::bigint NOT NULL,
    is_ldap boolean DEFAULT false NOT NULL
);


ALTER TABLE users OWNER TO postgres;

--
-- Name: activities_listing; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW activities_listing AS
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


ALTER TABLE activities_listing OWNER TO postgres;

--
-- Name: attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE attachments_id_seq
    START WITH 2
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE attachments_id_seq OWNER TO postgres;

--
-- Name: boards_stars_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE boards_stars_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE boards_stars_id_seq OWNER TO postgres;

--
-- Name: board_stars; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE board_stars (
    id bigint DEFAULT nextval('boards_stars_id_seq'::regclass) NOT NULL,
    created timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    board_id bigint NOT NULL,
    user_id bigint NOT NULL,
    is_starred boolean NOT NULL
);


ALTER TABLE board_stars OWNER TO postgres;

--
-- Name: boards_subscribers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE boards_subscribers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE boards_subscribers_id_seq OWNER TO postgres;

--
-- Name: board_subscribers; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE board_subscribers (
    id bigint DEFAULT nextval('boards_subscribers_id_seq'::regclass) NOT NULL,
    created timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    board_id bigint NOT NULL,
    user_id bigint NOT NULL,
    is_subscribed boolean NOT NULL
);


ALTER TABLE board_subscribers OWNER TO postgres;

--
-- Name: boards_labels_listing; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW boards_labels_listing AS
 SELECT cards_labels.id, 
    cards_labels.created, 
    cards_labels.modified, 
    cards_labels.label_id, 
    cards_labels.card_id, 
    cards_labels.list_id, 
    cards_labels.board_id, 
    labels.name
   FROM (cards_labels cards_labels
   LEFT JOIN labels labels ON ((labels.id = cards_labels.label_id)));


ALTER TABLE boards_labels_listing OWNER TO postgres;

--
-- Name: boards_users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE boards_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE boards_users_id_seq OWNER TO postgres;

--
-- Name: boards_users; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE boards_users (
    id bigint DEFAULT nextval('boards_users_id_seq'::regclass) NOT NULL,
    created timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    board_id bigint NOT NULL,
    user_id bigint NOT NULL,
    is_admin boolean NOT NULL
);


ALTER TABLE boards_users OWNER TO postgres;

--
-- Name: boards_users_listing; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW boards_users_listing AS
 SELECT bu.id, 
    bu.created, 
    bu.modified, 
    bu.board_id, 
    bu.user_id, 
    bu.is_admin, 
    u.username, 
    u.email, 
    u.full_name, 
    u.is_active, 
    u.is_email_confirmed, 
    b.name AS board_name, 
    u.profile_picture_path, 
    u.initials
   FROM ((boards_users bu
   JOIN users u ON ((u.id = bu.user_id)))
   JOIN boards b ON ((b.id = bu.board_id)));


ALTER TABLE boards_users_listing OWNER TO postgres;

--
-- Name: card_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE card_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE card_attachments_id_seq OWNER TO postgres;

--
-- Name: card_attachments; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
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
    mimetype character varying(255)
);


ALTER TABLE card_attachments OWNER TO postgres;

--
-- Name: cards_subscribers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE cards_subscribers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cards_subscribers_id_seq OWNER TO postgres;

--
-- Name: card_subscribers; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE card_subscribers (
    id bigint DEFAULT nextval('cards_subscribers_id_seq'::regclass) NOT NULL,
    created timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    card_id bigint NOT NULL,
    user_id bigint NOT NULL,
    is_subscribed boolean NOT NULL
);


ALTER TABLE card_subscribers OWNER TO postgres;

--
-- Name: card_voters_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE card_voters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE card_voters_id_seq OWNER TO postgres;

--
-- Name: card_voters; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE card_voters (
    id bigint DEFAULT nextval('card_voters_id_seq'::regclass) NOT NULL,
    created timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    card_id bigint NOT NULL,
    user_id bigint NOT NULL
);


ALTER TABLE card_voters OWNER TO postgres;

--
-- Name: card_voters_listing; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW card_voters_listing AS
 SELECT card_voters.id, 
    card_voters.created, 
    card_voters.modified, 
    card_voters.user_id, 
    card_voters.card_id, 
    users.username, 
    users.role_id, 
    users.profile_picture_path, 
    users.initials
   FROM (card_voters card_voters
   LEFT JOIN users users ON ((users.id = card_voters.user_id)));


ALTER TABLE card_voters_listing OWNER TO postgres;

--
-- Name: cards_users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE cards_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cards_users_id_seq OWNER TO postgres;

--
-- Name: cards_users; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE cards_users (
    id bigint DEFAULT nextval('cards_users_id_seq'::regclass) NOT NULL,
    created timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    card_id bigint NOT NULL,
    user_id bigint NOT NULL
);


ALTER TABLE cards_users OWNER TO postgres;

--
-- Name: cards_users_listing; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW cards_users_listing AS
 SELECT u.username, 
    u.profile_picture_path, 
    cu.id, 
    cu.created, 
    cu.modified, 
    cu.card_id, 
    cu.user_id, 
    u.initials
   FROM (cards_users cu
   LEFT JOIN users u ON ((u.id = cu.user_id)));


ALTER TABLE cards_users_listing OWNER TO postgres;

--
-- Name: checklists_listing; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW checklists_listing AS
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
                    checklist_items.is_completed, 
                    checklist_items."position"
                   FROM checklist_items checklist_items
                  WHERE (checklist_items.checklist_id = checklists.id)
                  ORDER BY checklist_items."position") ci) AS checklists_items, 
    checklists."position"
   FROM checklists checklists;


ALTER TABLE checklists_listing OWNER TO postgres;

--
-- Name: cards_listing; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW cards_listing AS
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
    cards.is_archived, 
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
                    cards_users_listing.initials
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
                    card_voters_listing.initials
                   FROM card_voters_listing card_voters_listing
                  WHERE (card_voters_listing.card_id = cards.id)
                  ORDER BY card_voters_listing.id) cv) AS cards_voters, 
    ( SELECT array_to_json(array_agg(row_to_json(cs.*))) AS array_to_json
           FROM ( SELECT cards_subscribers.id, 
                    cards_subscribers.created, 
                    cards_subscribers.modified, 
                    cards_subscribers.card_id, 
                    cards_subscribers.user_id, 
                    cards_subscribers.is_subscribed
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
    cards.comment_count
   FROM cards cards;


ALTER TABLE cards_listing OWNER TO postgres;

--
-- Name: lists_subscribers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE lists_subscribers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE lists_subscribers_id_seq OWNER TO postgres;

--
-- Name: list_subscribers; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE list_subscribers (
    id bigint DEFAULT nextval('lists_subscribers_id_seq'::regclass) NOT NULL,
    created timestamp without time zone NOT NULL,
    modified timestamp without time zone,
    list_id bigint NOT NULL,
    user_id bigint NOT NULL,
    is_subscribed boolean DEFAULT false NOT NULL
);


ALTER TABLE list_subscribers OWNER TO postgres;

--
-- Name: lists_listing; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW lists_listing AS
 SELECT lists.id, 
    lists.created, 
    lists.modified, 
    lists.board_id, 
    lists.name, 
    lists."position", 
    lists.is_archived, 
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
                    cards_listing.is_archived, 
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
                    lists_subscribers.is_subscribed
                   FROM list_subscribers lists_subscribers
                  WHERE (lists_subscribers.list_id = lists.id)
                  ORDER BY lists_subscribers.id) ls) AS lists_subscribers
   FROM lists lists;


ALTER TABLE lists_listing OWNER TO postgres;

--
-- Name: boards_listing; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW boards_listing AS
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
    board.is_show_image_front_of_card, 
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
                  ORDER BY boards_users.id) bu) AS boards_users
   FROM (boards board
   LEFT JOIN organizations organizations ON ((organizations.id = board.organization_id)));


ALTER TABLE boards_listing OWNER TO postgres;

--
-- Name: checklist_add_listing; Type: VIEW; Schema: public; Owner: postgres
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


ALTER TABLE checklist_add_listing OWNER TO postgres;

--
-- Name: cities; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
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


ALTER TABLE cities OWNER TO postgres;

--
-- Name: cities_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE cities_id_seq
    START WITH 15178
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cities_id_seq OWNER TO postgres;

--
-- Name: cities_id_seq1; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE cities_id_seq1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cities_id_seq1 OWNER TO postgres;

--
-- Name: cities_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE cities_id_seq1 OWNED BY cities.id;


--
-- Name: countries; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
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


ALTER TABLE countries OWNER TO postgres;

--
-- Name: countries_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE countries_id_seq
    START WITH 262
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE countries_id_seq OWNER TO postgres;

--
-- Name: countries_id_seq1; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE countries_id_seq1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE countries_id_seq1 OWNER TO postgres;

--
-- Name: countries_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE countries_id_seq1 OWNED BY countries.id;


--
-- Name: email_templates_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE email_templates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE email_templates_id_seq OWNER TO postgres;

--
-- Name: email_templates; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
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


ALTER TABLE email_templates OWNER TO postgres;

--
-- Name: gadget_users_listing; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW gadget_users_listing AS
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
                    checklist_items.is_completed
                   FROM checklist_items checklist_items
                  WHERE (checklist_items.checklist_id = checklists.id)
                  ORDER BY checklist_items.id) ci) AS checklist_items
   FROM checklists checklists;


ALTER TABLE gadget_users_listing OWNER TO postgres;

--
-- Name: ips_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ips_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ips_id_seq OWNER TO postgres;

--
-- Name: ips; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
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


ALTER TABLE ips OWNER TO postgres;

--
-- Name: list_subscribers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE list_subscribers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE list_subscribers_id_seq OWNER TO postgres;

--
-- Name: login_types_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE login_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE login_types_id_seq OWNER TO postgres;

--
-- Name: login_types; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE login_types (
    id bigint DEFAULT nextval('login_types_id_seq'::regclass) NOT NULL,
    created timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE login_types OWNER TO postgres;

--
-- Name: oauth_access_tokens; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE oauth_access_tokens (
    access_token character varying(40) NOT NULL,
    client_id character varying(80),
    user_id character varying(255),
    expires timestamp without time zone,
    scope character varying(2000)
);


ALTER TABLE oauth_access_tokens OWNER TO postgres;

--
-- Name: oauth_authorization_codes; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE oauth_authorization_codes (
    authorization_code character varying(40) NOT NULL,
    client_id character varying(80),
    user_id character varying(255),
    redirect_uri character varying(2000),
    expires timestamp without time zone,
    scope character varying(2000)
);


ALTER TABLE oauth_authorization_codes OWNER TO postgres;

--
-- Name: oauth_clients; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE oauth_clients (
    client_id character varying(80) NOT NULL,
    client_secret character varying(80),
    redirect_uri character varying(2000),
    grant_types character varying(80),
    scope character varying(100),
    user_id character varying(80)
);


ALTER TABLE oauth_clients OWNER TO postgres;

--
-- Name: oauth_jwt; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE oauth_jwt (
    client_id character varying(80) NOT NULL,
    subject character varying(80),
    public_key character varying(2000)
);


ALTER TABLE oauth_jwt OWNER TO postgres;

--
-- Name: oauth_refresh_tokens; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE oauth_refresh_tokens (
    refresh_token character varying(40) NOT NULL,
    client_id character varying(80),
    user_id character varying(255),
    expires timestamp without time zone,
    scope character varying(2000)
);


ALTER TABLE oauth_refresh_tokens OWNER TO postgres;

--
-- Name: oauth_scopes; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE oauth_scopes (
    scope text NOT NULL,
    is_default boolean
);


ALTER TABLE oauth_scopes OWNER TO postgres;

--
-- Name: organizations_users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE organizations_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE organizations_users_id_seq OWNER TO postgres;

--
-- Name: organizations_users; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE organizations_users (
    id bigint DEFAULT nextval('organizations_users_id_seq'::regclass) NOT NULL,
    created timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    organization_id bigint NOT NULL,
    user_id bigint NOT NULL,
    is_admin boolean NOT NULL
);


ALTER TABLE organizations_users OWNER TO postgres;

--
-- Name: organizations_users_listing; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW organizations_users_listing AS
 SELECT organizations_users.id, 
    organizations_users.created, 
    organizations_users.modified, 
    organizations_users.user_id, 
    organizations_users.organization_id, 
    organizations_users.is_admin, 
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
                    boards_users.is_admin, 
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


ALTER TABLE organizations_users_listing OWNER TO postgres;

--
-- Name: organizations_listing; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW organizations_listing AS
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
                    boards_listing.is_closed, 
                    boards_listing.is_allow_organization_members_to_join, 
                    boards_listing.boards_user_count, 
                    boards_listing.list_count, 
                    boards_listing.card_count, 
                    boards_listing.boards_subscriber_count, 
                    boards_listing.background_pattern_url, 
                    boards_listing.is_show_image_front_of_card, 
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
                    organizations_users_listing.is_admin, 
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


ALTER TABLE organizations_listing OWNER TO postgres;

--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE roles_id_seq OWNER TO postgres;

--
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE roles (
    id bigint DEFAULT nextval('roles_id_seq'::regclass) NOT NULL,
    created timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE roles OWNER TO postgres;

--
-- Name: role_links_listing; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW role_links_listing AS
 SELECT role.id, 
    ( SELECT array_to_json(array_agg(link.*)) AS array_to_json
           FROM ( SELECT alls.slug
                   FROM acl_links_listing alls
                  WHERE (alls.role_id = role.id)) link) AS links
   FROM roles role;


ALTER TABLE role_links_listing OWNER TO postgres;

--
-- Name: setting_categories; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
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


ALTER TABLE setting_categories OWNER TO postgres;

--
-- Name: setting_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE setting_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE setting_categories_id_seq OWNER TO postgres;

--
-- Name: setting_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE setting_categories_id_seq OWNED BY setting_categories.id;


--
-- Name: settings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE settings_id_seq OWNER TO postgres;

--
-- Name: settings; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
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
    label character varying(22),
    "order" integer DEFAULT 0 NOT NULL
);


ALTER TABLE settings OWNER TO postgres;

--
-- Name: settings_listing; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW settings_listing AS
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


ALTER TABLE settings_listing OWNER TO postgres;

--
-- Name: simple_board_listing; Type: VIEW; Schema: public; Owner: postgres
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
  ORDER BY board.name;


ALTER TABLE simple_board_listing OWNER TO postgres;

--
-- Name: states; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE states (
    id bigint NOT NULL,
    created timestamp without time zone,
    modified timestamp without time zone,
    country_id bigint,
    name character varying(45),
    is_active boolean DEFAULT false
);


ALTER TABLE states OWNER TO postgres;

--
-- Name: states_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE states_id_seq
    START WITH 15138
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE states_id_seq OWNER TO postgres;

--
-- Name: states_id_seq1; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE states_id_seq1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE states_id_seq1 OWNER TO postgres;

--
-- Name: states_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE states_id_seq1 OWNED BY states.id;


--
-- Name: user_logins; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE user_logins (
    id integer NOT NULL,
    created timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    user_id bigint DEFAULT (0)::bigint NOT NULL,
    ip_id bigint DEFAULT (0)::bigint NOT NULL,
    user_agent character varying(255)
);


ALTER TABLE user_logins OWNER TO postgres;

--
-- Name: user_logins_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE user_logins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE user_logins_id_seq OWNER TO postgres;

--
-- Name: user_logins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE user_logins_id_seq OWNED BY user_logins.id;


--
-- Name: users_cards_listing; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW users_cards_listing AS
 SELECT b.name AS board_name, 
    l.name AS list_name, 
    c.id, 
    c.created, 
    c.modified, 
    c.board_id, 
    c.list_id, 
    c.name, 
    c.description, 
    c.due_date, 
    c."position", 
    c.is_archived, 
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
    c.is_deleted, 
    cu.user_id, 
    c.comment_count
   FROM (((cards_users cu
   JOIN cards c ON ((c.id = cu.card_id)))
   JOIN boards b ON ((b.id = c.board_id)))
   JOIN lists l ON ((l.id = c.list_id)));


ALTER TABLE users_cards_listing OWNER TO postgres;

--
-- Name: users_listing; Type: VIEW; Schema: public; Owner: postgres
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


ALTER TABLE users_listing OWNER TO postgres;

--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY cities ALTER COLUMN id SET DEFAULT nextval('cities_id_seq1'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY countries ALTER COLUMN id SET DEFAULT nextval('countries_id_seq1'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY setting_categories ALTER COLUMN id SET DEFAULT nextval('setting_categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY states ALTER COLUMN id SET DEFAULT nextval('states_id_seq1'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_logins ALTER COLUMN id SET DEFAULT nextval('user_logins_id_seq'::regclass);


--
-- Data for Name: acl_links; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY acl_links (id, created, modified, name, url, method, slug, group_id, is_allow_only_to_admin, is_allow_only_to_user) FROM stdin;
1	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Forgot password	/users/forgotpassword	POST	users_forgotpassword	1	0	0
2	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Register	/users/register	POST	users_register	1	0	0
3	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Login	/users/login	POST	users_login	1	0	0
58	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	View board	/boards/?	GET	view_board	2	0	0
5	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Add organization	/organizations	POST	add_organization	5	0	1
6	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Add board	/boards	POST	add_board	2	0	1
7	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Subscribe board	/boards/?/board_subscribers	POST	subscribe_board	2	0	1
8	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Copy board	/boards/?/copy	POST	copy_board	2	0	1
10	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Change password	/users/?/changepassword	POST	user_changepassword	1	0	1
11	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Upload organization logo	/organizations/?/upload_logo	POST	upload_organization_logo	5	0	1
12	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Add list	/boards/?/lists	POST	add_list	3	0	1
13	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Subscribe list	/boards/?/lists/?/list_subscribers	POST	subscribe_list	3	0	1
16	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Vote card	/boards/?/lists/?/cards/?/card_voters	POST	vote_card	4	0	1
17	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Add card	/boards/?/lists/?/cards	POST	add_card	4	0	1
18	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Upload attachment to card	/boards/?/lists/?/cards/?/attachments	POST	add_card_attachment	4	0	1
19	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Assign labels to card	/boards/?/lists/?/cards/?/labels	POST	add_labels	4	0	1
20	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Add checklist to card	/boards/?/lists/?/cards/?/checklists	POST	add_checklists	4	0	1
21	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Add item to checklist	/boards/?/lists/?/cards/?/checklists/?/items	POST	add_checklist_item	4	0	1
22	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Convert item to card	/boards/?/lists/?/cards/?/checklists/?/items/?/convert_to_card	POST	convert_item_to_card	4	0	1
23	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Upload profile picture	/users/?	POST	add_user_profile_picture	1	0	1
24	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Upload custom background to board	/boards/?/custom_backgrounds	POST	add_custom_background	2	0	1
25	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Assign member to card	/boards/?/lists/?/cards/?/users/?	POST	add_card_user	4	0	1
26	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Copy card	/boards/?/lists/?/cards/?/copy	POST	copy_card	4	0	1
28	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Edit organization	/organizations/?	PUT	edit_organization	5	0	1
57	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Users management	/users	GET	view_user_listing	1	1	0
31	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Edit board	/boards/?	PUT	edit_board	2	0	1
32	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Unsubscribe board	/subscriber/?/edit	PUT	unsubscribe_board	2	0	1
33	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Edit list	/boards/?/lists/?	PUT	edit_list	3	0	1
34	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Edit card	/boards/?/lists/?/cards/?	PUT	edit_card	4	0	1
35	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Unsubscribe list	/boards/?/lists/?/list_subscribers/?	PUT	unsubscribe_list	3	0	1
36	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Unsubscribe card	/boards/?/lists/?/cards/?/card_subscribers/?	PUT	unsubscribe_card	4	0	1
37	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Unvote card	/boards/?/lists/?/cards/?/card_voters/?	PUT	unvote_card	4	0	1
39	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Edit checklist	/boards/?/lists/?/cards/?/checklists/?	PUT	edit_checklist	4	0	1
41	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Undo activity	/activities/undo/?	PUT	undo_activity	4	0	1
42	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Edit user details	/users/?	PUT	edit_user_details	1	0	1
43	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Delete board	/boards/?	DELETE	delete_board	2	0	1
44	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Delete organization	/organizations/?	DELETE	delete_organization	5	0	1
45	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Remove organization member	/organizations_users/?	DELETE	remove_organization_user	5	0	1
46	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Remove board member	/boards_users/?	DELETE	remove_board_user	2	0	1
47	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Delete list	/boards/?/lists/?	DELETE	delete_list	3	0	1
62	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Organization members listing	/organizations_users/?	GET	view_organization_user_listing	5	0	1
50	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Delete card	/boards/?/lists/?/cards/?	DELETE	delete_card	4	0	1
51	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Remove attachment from card	/boards/?/lists/?/cards/?/attachments/?	DELETE	remove_card_attachment	4	0	1
52	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Delete checklist	/boards/?/lists/?/cards/?/checklists/?	DELETE	delete_checklist	4	0	1
53	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Delete item in checklist	/boards/?/lists/?/cards/?/checklists/?/items/?	DELETE	delete_checklist_item	4	0	1
54	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Remove card member	/boards/?/lists/?/cards/?/cards_users/?	DELETE	remove_card_user	4	0	1
72	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Archived lists	/boards/?/archived_lists	GET	view_archived_lists	3	0	1
61	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	View organization	/organizations/?	GET	view_organization	5	0	1
101	2014-11-21 06:46:53.094432	2014-11-21 06:46:53.094432	Setting view	/settings/?	GET	setting_list	6	1	0
55	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Delete user	/users/?	DELETE	delete_user	1	0	1
70	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Board search	/boards/search	GET	view_board_search	2	0	1
56	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	View boards listing	/boards	GET	view_board_listing	2	0	1
29	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Update organization member permission	/organizations_users/?	PUT	edit_organization_user	5	0	1
111	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Settings management	/settings	GET	load_settings	6	1	0
109	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Email templates management	/email_templates/?	GET	view_email_template_listing	6	1	0
99	2014-11-21 02:52:08.822706	2014-11-21 02:52:08.822706	Setting update	/settings	POST	setting_update	6	1	0
110	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Edit email template	/email_templates/?	PUT	edit_email_template	6	1	0
64	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	View user activities	/users/?/activities	GET	view_user_activities	1	0	1
115	2014-08-25 13:14:18.2	2014-08-25 13:14:18.2	All activities	/activities	GET	activities_listing	2	1	1
4	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Add organization member	/organizations/?/users/?	POST	add_organization_user	5	0	1
9	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Add board member	/boards/?/users	POST	add_board_users	2	0	1
14	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Post comment to card	/boards/?/lists/?/cards/?/comments	POST	comment_card	4	0	1
15	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Subscribe card	/boards/?/lists/?/cards/?/card_subscribers	POST	subscribe_card	4	0	1
68	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Starred boards listing	/boards/starred	GET	view_stared_boards	2	0	1
38	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Edit comment	/boards/?/lists/?/cards/?/comments/?	PUT	edit_comment	4	0	1
40	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Edit item in checklist	/boards/?/lists/?/cards/?/checklists/?/items/?	PUT	edit_checklist_item	4	0	1
49	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Delete comment	/boards/?/lists/?/cards/?/comments/?	DELETE	delete_comment	4	0	1
69	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Board subscribers	/boards/?/board_subscribers	GET	view_board_subscribers	2	0	1
63	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	View board activities	/boards/?/activities	GET	view_board_activities	2	0	1
71	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Archived cards	/boards/?/archived_cards	GET	view_archived_cards	4	0	1
73	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Cards listing	/boards/?/lists/?/cards/?	GET	view_card_isting	4	0	1
75	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Checklist listing	/boards/?/lists/?/cards/?/checklists	GET	view_checklist_listing	4	0	1
85	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	View user assigned cards	/users/?/cards	GET	view_user_cards	4	0	1
86	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	View user assigned boards	/users/?/boards	GET	view_user_board	2	0	1
87	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Search card to add in comment	/boards/?/lists/?/cards/?/search	GET	view_card_search	4	0	1
74	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Card activities	/boards/?/lists/?/cards/?/activities	GET	view_card_activities	4	0	0
30	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Update board member permission	/boards_users/?	PUT	edit_board_user	2	0	1
81	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	View user	/users/?	GET	view_user	1	0	1
89	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	View card labels	/boards/?/lists/?/cards/?/labels	GET	view_card_labels	4	0	1
91	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Archived card send back to board	/boards/?/lists/?/cards	POST	send_back_to_archived_card	4	0	1
92	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Archived list send back to board	/lists/?	PUT	send_back_to_archived_list	2	0	1
77	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Board visibility	/boards/?/visibility	GET	view_board_visibility	2	0	1
104	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Starred board	/boards/?/boards_stars	POST	starred_board	2	0	1
105	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Unstarred board	/starred/?/edit	PUT	unstarred_board	2	0	1
60	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Board members listing	/board_users/?	GET	view_board_listing	2	0	1
67	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	My boards listing	/boards/my_boards	GET	view_my_boards	2	0	1
97	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Move list cards	/boards/?/lists/?/cards	PUT	move_list_cards	4	0	1
98	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Search card	/cards/search	GET	search_card	4	0	1
103	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	View starred boards listing	/boards/?/boards_stars	GET	view_board_star	2	0	1
106	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	View closed boards	/boards/closed_boards	GET	view_closed_boards	2	0	1
108	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	View organizations listing	/organizations	GET	view_organization_listing	5	0	1
112	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Remove card member	/boards/?/lists/?/cards/?/users/?	DELETE	delete_card_user	4	0	1
113	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Unstar board	/boards/?/boards_stars/?	PUT	board_star	2	0	1
114	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Unsubscribe board	/boards/?/board_subscribers/?	PUT	board_subscriber	2	0	1
78	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Organization visibility	/organizations/?/visibility	GET	view_organization_visibility	5	0	1
116	2014-08-25 13:14:18.2	2014-08-25 13:14:18.2	Download attachment from card	/download/?	GET	activities_listing	4	1	1
76	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	View user search	/users/search	GET	view_user_search	1	0	1
79	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Load workflow templates	/workflow_templates	GET	view_workflow_templates	2	0	1
94	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Roles listing	/acl_links	GET	roles	6	1	0
80	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Search	/search	GET	view_search	2	0	1
82	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Board sync Google calendar URL	/boards/?/sync_calendar	GET	view_sync_calendar	2	0	1
118	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	Roles Update	/acl_links	POST	roles	6	1	0
117	2015-05-09 13:14:18.2	2015-05-09 13:14:18.2	Create user	/users	POST	users	1	1	0
27	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	User activation	/users/?/activation	PUT	user_activation	1	0	0
\.


--
-- Name: acl_links_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('acl_links_id_seq', 118, true);


--
-- Data for Name: acl_links_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY acl_links_roles (id, created, modified, acl_link_id, role_id) FROM stdin;
1164	2014-11-21 06:46:53.094432	2014-11-21 06:46:53.094432	101	1
1165	2014-11-21 02:52:08.822706	2014-11-21 02:52:08.822706	102	1
1166	2014-11-21 02:52:08.822706	2014-11-21 02:52:08.822706	103	1
1167	2014-11-21 02:52:08.822706	2014-11-21 02:52:08.822706	104	1
1168	2014-11-21 02:52:08.822706	2014-11-21 02:52:08.822706	103	2
1169	2014-11-21 02:52:08.822706	2014-11-21 02:52:08.822706	104	2
1170	2014-11-21 02:52:08.822706	2014-11-21 02:52:08.822706	105	1
1171	2014-11-21 02:52:08.822706	2014-11-21 02:52:08.822706	105	2
870	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	1	1
871	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	1	2
872	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	1	3
873	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	2	1
874	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	2	2
875	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	2	3
876	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	3	1
877	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	3	2
878	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	3	3
879	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	4	1
880	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	4	2
881	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	4	3
882	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	5	1
883	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	5	2
884	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	5	3
885	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	6	1
888	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	7	1
889	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	7	2
890	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	7	3
891	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	8	1
892	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	8	2
893	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	8	3
894	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	9	1
895	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	9	2
896	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	9	3
897	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	10	1
898	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	10	2
899	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	10	3
900	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	11	1
901	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	11	2
902	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	11	3
903	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	12	1
904	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	12	2
905	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	12	3
906	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	13	1
907	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	13	2
908	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	13	3
909	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	14	1
910	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	14	2
911	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	14	3
912	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	15	1
913	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	15	2
914	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	15	3
915	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	16	1
916	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	16	2
917	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	16	3
918	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	17	1
919	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	17	2
920	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	17	3
921	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	18	1
922	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	18	2
923	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	18	3
924	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	19	1
925	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	19	2
926	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	19	3
927	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	20	1
928	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	20	2
929	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	20	3
930	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	21	1
931	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	21	2
932	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	21	3
933	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	22	1
934	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	22	2
935	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	22	3
936	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	23	1
937	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	23	2
938	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	23	3
939	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	24	1
940	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	24	2
941	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	24	3
942	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	25	1
943	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	25	2
944	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	25	3
945	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	26	1
946	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	26	2
947	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	26	3
948	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	27	1
949	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	27	2
950	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	27	3
951	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	28	1
952	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	28	2
953	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	28	3
954	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	29	1
955	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	29	2
956	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	29	3
957	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	30	1
958	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	30	2
959	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	30	3
960	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	31	1
961	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	31	2
962	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	31	3
963	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	32	1
964	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	32	2
965	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	32	3
966	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	33	1
967	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	33	2
968	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	33	3
969	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	34	1
970	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	34	2
971	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	34	3
972	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	35	1
973	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	35	2
974	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	35	3
975	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	36	1
976	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	36	2
977	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	36	3
978	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	37	1
979	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	37	2
980	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	37	3
981	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	38	1
982	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	38	2
983	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	38	3
984	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	39	1
985	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	39	2
986	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	39	3
987	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	40	1
988	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	40	2
989	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	40	3
990	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	41	1
991	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	41	2
992	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	41	3
993	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	42	1
994	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	42	2
995	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	42	3
996	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	43	1
997	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	43	2
998	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	43	3
999	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	44	1
1000	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	44	2
1001	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	44	3
1002	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	45	1
1003	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	45	2
1004	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	45	3
1005	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	46	1
1006	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	46	2
1007	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	46	3
1008	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	47	1
1009	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	47	2
1010	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	47	3
1011	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	48	1
1012	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	48	2
1013	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	48	3
1014	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	49	1
1015	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	49	2
1016	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	49	3
1017	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	50	1
1018	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	50	2
1019	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	50	3
1020	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	51	1
1021	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	51	2
1022	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	51	3
1023	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	52	1
1024	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	52	2
1025	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	52	3
1026	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	53	1
1027	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	53	2
1028	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	53	3
1029	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	54	1
1030	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	54	2
1031	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	54	3
1032	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	55	1
1033	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	55	2
1034	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	55	3
1035	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	56	1
1036	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	56	2
1037	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	56	3
1038	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	57	1
1041	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	58	1
1042	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	58	2
1043	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	58	3
1044	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	59	1
1045	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	59	2
1046	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	59	3
1047	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	60	1
1048	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	60	2
1049	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	60	3
1050	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	61	1
1051	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	61	2
1052	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	61	3
1053	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	62	1
1054	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	62	2
1055	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	62	3
1056	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	63	1
1057	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	63	2
1058	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	63	3
1059	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	64	1
1060	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	64	2
1061	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	64	3
1062	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	65	1
1063	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	65	2
1064	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	65	3
1065	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	66	1
1066	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	66	2
1067	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	66	3
1068	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	67	1
1069	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	67	2
1070	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	67	3
1071	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	68	1
1072	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	68	2
1073	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	68	3
1074	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	69	1
1075	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	69	2
1076	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	69	3
1077	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	70	1
1078	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	70	2
1079	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	70	3
1080	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	71	1
1081	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	71	2
1082	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	71	3
1083	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	72	1
1084	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	72	2
1085	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	72	3
1086	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	73	1
1087	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	73	2
1088	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	73	3
1089	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	74	1
1090	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	74	2
1091	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	74	3
1092	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	75	1
1093	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	75	2
1094	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	75	3
1095	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	76	1
1096	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	76	2
1097	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	76	3
1098	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	77	1
1099	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	77	2
1100	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	77	3
1101	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	78	1
1102	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	78	2
1103	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	78	3
1104	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	79	1
1105	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	79	2
1106	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	79	3
1107	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	80	1
1108	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	80	2
1109	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	80	3
1110	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	81	1
1111	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	81	2
1112	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	81	3
1113	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	82	1
1114	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	82	2
1115	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	82	3
1116	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	83	1
1117	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	83	2
1118	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	83	3
1119	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	84	1
1120	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	84	2
1121	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	84	3
1122	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	85	1
1123	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	85	2
1124	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	85	3
1125	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	86	1
1126	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	86	2
1127	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	86	3
1128	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	87	1
1129	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	87	2
1130	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	87	3
1131	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	88	1
1132	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	88	2
1133	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	88	3
1134	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	89	1
1135	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	89	2
1136	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	89	3
1137	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	90	1
1138	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	90	2
1139	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	90	3
1140	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	91	1
1141	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	91	2
1142	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	91	3
1143	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	92	1
1144	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	92	2
1145	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	92	3
1146	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	93	1
1147	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	93	2
1148	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	93	3
1149	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	94	1
1152	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	95	1
1153	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	95	2
1154	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	95	3
1155	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	96	1
1156	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	96	2
1157	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	96	3
1158	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	97	1
1159	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	97	2
1160	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	97	3
1161	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	98	1
1162	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	98	2
1163	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	98	3
1172	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	106	1
1173	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	106	2
1174	2014-11-14 16:23:16.77598	2014-11-14 16:23:16.77598	106	3
1175	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	106	1
1176	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	106	2
1177	2014-08-25 13:14:18.247	2014-08-25 13:14:18.247	106	3
1178	2014-11-21 06:46:53.094432	2014-11-21 06:46:53.094432	108	1
1179	2014-11-21 06:46:53.094432	2014-11-21 06:46:53.094432	109	1
1180	2014-11-21 06:46:53.094432	2014-11-21 06:46:53.094432	110	1
1181	2014-11-21 06:46:53.094432	2014-11-21 06:46:53.094432	108	2
1182	2014-11-21 06:46:53.094432	2014-11-21 06:46:53.094432	108	2
1183	2014-11-21 06:46:53.094432	2014-11-21 06:46:53.094432	108	3
1184	2014-11-21 06:46:53.094432	2014-11-21 06:46:53.094432	108	3
1185	2014-11-21 06:46:53.094432	2014-11-21 06:46:53.094432	111	1
1186	2014-11-21 06:46:53.094432	2014-11-21 06:46:53.094432	111	2
1187	2014-11-21 06:46:53.094432	2014-11-21 06:46:53.094432	111	3
1188	2014-11-21 06:46:53.094432	2014-11-21 06:46:53.094432	99	1
1189	2014-11-21 06:46:53.094432	2014-11-21 06:46:53.094432	112	1
1190	2014-11-21 06:46:53.094432	2014-11-21 06:46:53.094432	112	2
1191	2014-11-21 06:46:53.094432	2014-11-21 06:46:53.094432	112	3
1192	2014-11-21 06:46:53.094432	2014-11-21 06:46:53.094432	113	1
1193	2014-11-21 06:46:53.094432	2014-11-21 06:46:53.094432	113	2
1194	2014-11-21 06:46:53.094432	2014-11-21 06:46:53.094432	113	3
1195	2014-11-21 06:46:53.094432	2014-11-21 06:46:53.094432	114	1
1196	2014-11-21 06:46:53.094432	2014-11-21 06:46:53.094432	114	2
1197	2014-11-21 06:46:53.094432	2014-11-21 06:46:53.094432	114	3
1198	2014-11-21 06:46:53.094432	2014-11-21 06:46:53.094432	24	1
1199	2014-11-21 06:46:53.094432	2014-11-21 06:46:53.094432	24	2
1200	2014-11-21 06:46:53.094432	2014-11-21 06:46:53.094432	24	3
1201	2014-11-21 06:46:53.094432	2014-11-21 06:46:53.094432	115	1
1202	2014-11-21 06:46:53.094432	2014-11-21 06:46:53.094432	115	2
1203	2014-11-21 06:46:53.094432	2014-11-21 06:46:53.094432	115	3
1204	2014-11-21 06:46:53.094432	2014-11-21 06:46:53.094432	116	1
1205	2014-11-21 06:46:53.094432	2014-11-21 06:46:53.094432	116	2
1206	2014-11-21 06:46:53.094432	2014-11-21 06:46:53.094432	116	3
1207	2015-05-09 06:46:53.094432	2015-05-09 06:46:53.094432	117	1
1208	2015-05-09 06:46:53.094432	2015-05-09 06:46:53.094432	117	2
1209	2015-05-09 06:46:53.094432	2015-05-09 06:46:53.094432	117	3
1210	2013-02-07 10:11:00	2015-04-25 19:58:48.8	118	1
\.


--
-- Name: acl_links_roles_roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('acl_links_roles_roles_id_seq', 1210, true);


--
-- Data for Name: activities; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY activities (id, created, modified, board_id, list_id, card_id, user_id, foreign_id, type, comment, revisions, root, freshness_ts, depth, path, materialized_path, organization_id) FROM stdin;
\.


--
-- Name: activities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('activities_id_seq', 2, true);


--
-- Name: attachments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('attachments_id_seq', 1, false);


--
-- Data for Name: board_stars; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY board_stars (id, created, modified, board_id, user_id, is_starred) FROM stdin;
\.


--
-- Data for Name: board_subscribers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY board_subscribers (id, created, modified, board_id, user_id, is_subscribed) FROM stdin;
\.


--
-- Data for Name: boards; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY boards (id, created, modified, user_id, organization_id, name, board_visibility, background_color, background_picture_url, commenting_permissions, voting_permissions, inivitation_permissions, is_closed, is_allow_organization_members_to_join, boards_user_count, list_count, card_count, boards_subscriber_count, background_pattern_url, boards_star_count, is_show_image_front_of_card, background_picture_path, music_name, music_content) FROM stdin;
\.


--
-- Name: boards_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('boards_id_seq', 2, true);


--
-- Name: boards_stars_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('boards_stars_id_seq', 1, false);


--
-- Name: boards_subscribers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('boards_subscribers_id_seq', 1, true);


--
-- Data for Name: boards_users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY boards_users (id, created, modified, board_id, user_id, is_admin) FROM stdin;
\.


--
-- Name: boards_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('boards_users_id_seq', 2, true);


--
-- Data for Name: card_attachments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY card_attachments (id, created, modified, card_id, name, path, list_id, board_id, mimetype) FROM stdin;
\.


--
-- Name: card_attachments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('card_attachments_id_seq', 1, true);


--
-- Data for Name: card_subscribers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY card_subscribers (id, created, modified, card_id, user_id, is_subscribed) FROM stdin;
\.


--
-- Data for Name: card_voters; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY card_voters (id, created, modified, card_id, user_id) FROM stdin;
\.


--
-- Name: card_voters_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('card_voters_id_seq', 1, true);


--
-- Data for Name: cards; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY cards (id, created, modified, board_id, list_id, name, description, due_date, "position", is_archived, attachment_count, checklist_count, checklist_item_count, checklist_item_completed_count, label_count, cards_user_count, cards_subscriber_count, card_voter_count, activity_count, user_id, is_deleted, comment_count) FROM stdin;
\.


--
-- Name: cards_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('cards_id_seq', 1, true);


--
-- Data for Name: cards_labels; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY cards_labels (id, created, modified, label_id, card_id, list_id, board_id) FROM stdin;
\.


--
-- Name: cards_labels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('cards_labels_id_seq', 1, true);


--
-- Name: cards_subscribers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('cards_subscribers_id_seq', 1, true);


--
-- Data for Name: cards_users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY cards_users (id, created, modified, card_id, user_id) FROM stdin;
\.


--
-- Name: cards_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('cards_users_id_seq', 1, true);


--
-- Data for Name: checklist_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY checklist_items (id, created, modified, user_id, card_id, checklist_id, name, is_completed, "position") FROM stdin;
\.


--
-- Name: checklist_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('checklist_items_id_seq', 1, true);


--
-- Data for Name: checklists; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY checklists (id, created, modified, user_id, card_id, name, checklist_item_count, checklist_item_completed_count, "position") FROM stdin;
\.


--
-- Name: checklists_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('checklists_id_seq', 1, true);


--
-- Data for Name: cities; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY cities (id, created, modified, country_id, state_id, latitude, longitude, name, is_active) FROM stdin;
1	2015-05-21 11:45:47.245	2015-05-21 11:45:47.245	102	1	20	77	undefined	f
\.


--
-- Name: cities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('cities_id_seq', 15178, false);


--
-- Name: cities_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('cities_id_seq1', 1, true);


--
-- Data for Name: countries; Type: TABLE DATA; Schema: public; Owner: postgres
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
240	US	USA	840	US	UnitedStates	Washington	9629091	310232863	NA	.us	USD	Dollar              	1         	#####-####          	^(d{9})$            	en-US,es-US,haw,fr	6252001	CA,MX,CU            	          	2013-02-07 10:11:00	US	USA	2013-09-19 16:10:20.878
250	YE	YEM	887	YM	Yemen	Sanaa	527970	23495361	AS	.ye	YER	Rial                	967       	                    	                    	ar-YE	69543	SA,OM               	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
251	ZM	ZMB	894	ZA	Zambia	Lusaka	752614	13460305	AF	.zm	ZMK	Kwacha              	260       	#####               	^(d{5})$            	en-ZM,bem,loz,lun,lue,ny,toi	895949	ZW,TZ,MZ,CD,NA,MW,AO	          	2013-02-07 10:11:00	\N	\N	2013-02-07 10:11:00
3	AL	ALB	8	AL	Albania	Tirana	28748	2986952	EU	.al	ALL	Lek                 	355       	                    	                    	sq,el	783754	MK,GR,CS,ME,RS,XK   	          	2013-02-07 10:11:00	2	3	2013-04-11 16:15:53.73
32	BR	BRA	76	BR	Brazil	Brasilia	8511965	201103330	SA	.br	BRL	Real                	55        	#####-###           	^(d{8})$            	pt-BR,es,en,fr	3469034	SR,PE,BO,UY,GY,PY,GF	          	2013-02-07 10:11:00	BR	BRZ	2013-09-19 14:52:25.866
112	JP	JPN	392	JA	Japan	Tokyo	377835	127288000	AS	.jp	JPY	Yen                 	81        	###-####            	^(d{7})$            	ja	1861060	                    	          	2013-02-07 10:11:00	JA	JAP	2013-09-19 14:53:54.835
239	GB	GBR	826	UK	United Kingdom	London	244820	62348447	EU	.uk	GBP	Pound               	44        	@# #@@|@## #@@|@@# #	^(([A-Z]d{2}[A-Z]{2}	en-GB,cy-GB,gd	2635167	IE                  	          	2013-02-07 10:11:00	UK	UKS	2013-09-19 14:55:04.538
252	ZW	ZWE	716	ZI	Zimbabwe	Harare	390580	0	AF	.zw	ZWL	Dollar              	263       	                    	                    	en-ZW,sn,nr,nd	878675	ZA,MZ,BW,ZM         	          	2013-02-07 10:11:00	\N	\N	2013-11-19 14:03:16.283
\.


--
-- Name: countries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('countries_id_seq', 262, false);


--
-- Name: countries_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('countries_id_seq1', 1, false);


--
-- Data for Name: email_templates; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY email_templates (id, created, modified, from_email, reply_to_email, name, description, subject, email_text_content, email_variables, display_name) FROM stdin;
1	2014-05-08 12:13:37.268	2014-05-08 12:13:37.268	##FROM_EMAIL##	##REPLY_TO_EMAIL##	activation	We will send this mail, when user registering an account he/she will get an activation request.	Please activate your ##SITE_NAME## account	Hi ##USERNAME##,\r\n\r\nYour account has been created. Please visit the following URL to activate your account.\r\n\r\n##ACTIVATION_URL##\r\n\r\nThanks,\r\n##SITE_NAME##\r\n##SITE_URL##	SITE_URL, SITE_NAME, ACTIVATION_URL, USERNAME	Activation
2	2014-05-08 12:14:07.472	2014-05-08 12:14:07.472	##FROM_EMAIL##	##REPLY_TO_EMAIL##	welcome	We will send this mail, when user register in this site and get activate.	Welcome to ##SITE_NAME##	Hi ##USERNAME##,\r\n\r\nWe wish to say a quick hello and thanks for registering at ##SITE_NAME##.\r\n\r\nIf you did not request this account and feel this is an error, please contact us at ##CONTACT_MAIL##\r\n\r\nThanks,\r\n##SITE_NAME##\r\n##SITE_URL##	SITE_NAME, SITE_URL, CONTACT_MAIL, USERNAME	Welcome
3	2014-05-08 12:13:59.784	2014-05-08 12:13:59.784	##FROM_EMAIL##	##REPLY_TO_EMAIL##	forgetpassword	We will send this mail, when user submit the forgot password form	Forgot Password	Hi ##USERNAME##,\r\n\r\nA password request has been made for your user account at ##SITE_NAME##.\r\n\r\nNew password: ##PASSWORD##\r\n\r\nIf you did not request this action and feel this is in error, please contact us at ##CONTACT_MAIL##.\r\n\r\nThanks,\r\n##SITE_NAME##\r\n##SITE_URL##	SITE_NAME, SITE_URL, CONTACT_MAIL, PASSWORD, USERNAME	Forgot Password
4	2014-05-08 12:13:50.69	2014-05-08 12:13:50.69	##FROM_EMAIL##	##REPLY_TO_EMAIL##	changepassword	We will send this mail to user, when admin change users password.	Password changed	Hi,\r\n\r\nAdmin reset your password for your  ##SITE_NAME## account.\r\n\r\nYour new password: ##PASSWORD##\r\n\r\nThanks,\r\n##SITE_NAME##\r\n##SITE_URL##	SITE_NAME, SITE_URL, PASSWORD	Change Password
5	2014-05-08 12:14:07.472	2014-05-08 12:14:07.472	##FROM_EMAIL##	##REPLY_TO_EMAIL##	newprojectuser	We will send this mail, when user added for board.	Welcome to ##SITE_NAME##	Hi ##USERNAME##,\r\n\r\n You have been invited by ##CURRENT_USER## to the ##SITE_NAME## board: ##BOARD_NAME##\r\n\r\nPlease visit the following URL.\r\n\r\n##BOARD_URL##\r\n\r\nThanks,\r\n##SITE_NAME##\r\n##SITE_URL##	SITE_NAME, SITE_URL, CONTACT_MAIL, USERNAME, CURRENT_USER	New Board User
\.


--
-- Name: email_templates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('email_templates_id_seq', 1, true);


--
-- Data for Name: ips; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY ips (id, created, modified, ip, host, user_agent, "order", city_id, state_id, country_id, latitude, longitude) FROM stdin;
1	2015-05-21 11:45:47.262	2015-05-21 11:45:47.262	::1	115.111.183.202	Mozilla/5.0 (Windows NT 6.3; WOW64; rv:38.0) Gecko/20100101 Firefox/38.0	0	1	1	102	20	77
\.


--
-- Name: ips_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('ips_id_seq', 1, true);


--
-- Data for Name: labels; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY labels (id, created, modified, name, card_count) FROM stdin;
\.


--
-- Name: labels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('labels_id_seq', 1, true);


--
-- Data for Name: list_subscribers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY list_subscribers (id, created, modified, list_id, user_id, is_subscribed) FROM stdin;
\.


--
-- Name: list_subscribers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('list_subscribers_id_seq', 1, false);


--
-- Data for Name: lists; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY lists (id, created, modified, board_id, user_id, name, "position", is_archived, card_count, lists_subscriber_count, is_deleted) FROM stdin;
\.


--
-- Name: lists_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('lists_id_seq', 196, true);


--
-- Name: lists_subscribers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('lists_subscribers_id_seq', 1, true);


--
-- Data for Name: login_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY login_types (id, created, modified, name) FROM stdin;
1	2015-04-07 18:42:59.514	2015-04-07 18:42:59.514	LDAP
2	2015-04-07 18:42:59.515	2015-04-07 18:42:59.515	Normal
\.


--
-- Name: login_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('login_types_id_seq', 2, true);


--
-- Data for Name: oauth_access_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY oauth_access_tokens (access_token, client_id, user_id, expires, scope) FROM stdin;
\.


--
-- Data for Name: oauth_authorization_codes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY oauth_authorization_codes (authorization_code, client_id, user_id, redirect_uri, expires, scope) FROM stdin;
\.


--
-- Data for Name: oauth_clients; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY oauth_clients (client_id, client_secret, redirect_uri, grant_types, scope, user_id) FROM stdin;
7742632501382313	4g7C4l1Y2b0S6a7L8c1E7B3K0e	http://localhost/restyaboard/server/php/R/r.php	client_credentials password refresh_token		2
\.


--
-- Data for Name: oauth_jwt; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY oauth_jwt (client_id, subject, public_key) FROM stdin;
\.


--
-- Data for Name: oauth_refresh_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY oauth_refresh_tokens (refresh_token, client_id, user_id, expires, scope) FROM stdin;
8adf4daa06961f18d2afda535b2f4463193c62f5	7742632501382313	admin	2015-04-16 12:55:32	\N
b43d289f47100a9c70ebd21f31c15db059ef82bb	7742632501382313	admin	2015-06-04 08:15:47	\N
52831802ce6fbd12bfbe34f1def7b679a0822a18	7742632501382313	admin	2015-06-20 07:23:34	\N
\.


--
-- Data for Name: oauth_scopes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY oauth_scopes (scope, is_default) FROM stdin;
\.


--
-- Data for Name: organizations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY organizations (id, created, modified, user_id, name, website_url, description, logo_url, organization_visibility, organizations_user_count, board_count) FROM stdin;
\.


--
-- Name: organizations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('organizations_id_seq', 1, true);


--
-- Data for Name: organizations_users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY organizations_users (id, created, modified, organization_id, user_id, is_admin) FROM stdin;
\.


--
-- Name: organizations_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('organizations_users_id_seq', 1, true);


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY roles (id, created, modified, name) FROM stdin;
1	2014-09-02 19:43:15.815	2014-09-02 19:43:15.815	admin
2	2014-09-02 19:43:15.815	2014-09-02 19:43:15.815	user
3	2014-09-02 19:43:15.815	2014-09-02 19:43:15.815	guest
\.


--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('roles_id_seq', 3, true);


--
-- Data for Name: setting_categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY setting_categories (id, created, modified, parent_id, name, description, "order") FROM stdin;
4	2014-11-21 02:52:08.822706	2014-11-21 02:52:08.822706	2	Server Details	\N	0
5	2014-11-21 02:52:08.822706	2014-11-21 02:52:08.822706	2	Connection Details	\N	0
7	2015-04-25 19:58:48.845	2015-04-25 19:58:48.845	6	Dropbox	\N	0
3	2014-11-21 02:52:08.822706	2014-11-21 02:52:08.822706	\N	System	\N	1
2	2014-11-08 02:52:08.822706	2014-04-28 17:01:11	\N	LDAP	\N	2
6	2015-04-25 19:58:48.845	2015-04-25 19:58:48.845	\N	Third Party API	\N	3
1	2014-04-23 16:30:20.121	2014-04-23 16:30:20.121	\N	ElasticSearch		4
\.


--
-- Name: setting_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('setting_categories_id_seq', 5, true);


--
-- Data for Name: settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY settings (id, setting_category_id, setting_category_parent_id, name, value, description, type, options, label, "order") FROM stdin;
2	4	2	LDAP_SERVER	\N	\N	text	\N	Server	1
5	4	2	LDAP_PORT	\N	\N	text	\N	Port	2
4	4	2	LDAP_PROTOCOL_VERSION	\N	\N	text	\N	Protocol Version	3
6	4	2	LDAP_ROOT_DN	\N	\N	text	\N	User DNS	4
7	4	2	LDAP_ORGANISATION	\N	\N	text	\N	Organization	5
8	5	2	LDAP_UID_FIELD	\N	\N	text	\N	Domain	6
9	5	2	LDAP_BIND_DN	\N	\N	text	\N	Username	7
10	5	2	LDAP_BIND_PASSWD	\N	\N	text	\N	Password	8
3	5	2	LDAP_LOGIN_ENABLED	false	\N	checkbox	\N	LDAP Login Enabled	9
11	3	0	SITE_NAME	Restyaboard	\N	text	\N	Site Name	1
13	3	0	DEFAULT_FROM_EMAIL	board@restya.com	\N	text	\N	From Email	2
19	3	0	LABEL_ICON	icon-circle	<a href="http://fortawesome.github.io/Font-Awesome/icons/" target="_blank">Font\r\nAwesome</a> class name. Recommended: icon-circle, icon-bullhorn,\r\nicon-tag, icon-bookmark, icon-pushpin, icon-star	text	\N	Label Icon	3
12	3	0	PAGING_COUNT	20	\N	text	\N	Paging Count	4
21	3	0	SITE_TIMEZONE	+0200	\N	text	\N	Site Timezone	5
18	6	0	DROPBOX_APPKEY		\N	text	\N	Dropbox App Key	1
20	6	0	FLICKR_API_KEY		\N	text	\N	Flickr API Key	2
14	1	0	ELASTICSEARCH_HOST		\N	text	\N	Host	1
15	1	0	SECRET_KEY		\N	text	\N	Secret Key	2
16	1	0	ELASTICSEARCH_URL		\N	text	\N	URL	3
17	1	0	ELASTICSEARCH_INDEX		\N	text	\N	Index	4
23	0	0	elasticsearch.last_processed_activtiy_id	0	\N	hidden	\N	Last Activity ID	3
22	5	2	STANDARD_LOGIN_ENABLED	true	\N	checkbox	\N	Standard Login Enabled	10
\.


--
-- Name: settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('settings_id_seq', 22, true);


--
-- Data for Name: states; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY states (id, created, modified, country_id, name, is_active) FROM stdin;
1	2015-05-21 11:45:47.229	2015-05-21 11:45:47.229	102	undefined	f
\.


--
-- Name: states_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('states_id_seq', 15138, false);


--
-- Name: states_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('states_id_seq1', 1, true);


--
-- Data for Name: user_logins; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY user_logins (id, created, modified, user_id, ip_id, user_agent) FROM stdin;
1	2015-05-21 11:45:47.266	2015-05-21 11:45:47.266	1	1	Mozilla/5.0 (Windows NT 6.3; WOW64; rv:38.0) Gecko/20100101 Firefox/38.0
2	2015-06-06 10:53:34.529	2015-06-06 10:53:34.529	1	1	Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.81 Safari/537.36
\.


--
-- Name: user_logins_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('user_logins_id_seq', 2, true);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY users (id, created, modified, role_id, username, email, password, full_name, initials, about_me, profile_picture_path, notification_frequency, is_allow_desktop_notification, is_active, is_email_confirmed, created_organization_count, created_board_count, joined_organization_count, list_count, joined_card_count, created_card_count, joined_board_count, checklist_count, checklist_item_completed_count, checklist_item_count, activity_count, card_voter_count, last_activity_id, last_login_date, last_login_ip_id, ip_id, login_type_id, is_productivity_beats, user_login_count, is_ldap) FROM stdin;
2	2014-07-05 11:46:40.804	2014-07-05 11:46:40.804	2	user	board+user@restya.com	$2y$12$QiJW6TjPKzDZPAuoWEex9OjPHQF33YzfkdC09FhasgPO.MjZ5btKe	User	U	\N	\N	\N	f	t	t	0	0	0	0	0	0	0	0	0	0	0	0	\N	\N	\N	\N	\N	f	0	f
1	2014-06-03 12:40:41.189	2015-04-02 16:26:03.939	1	admin	board@restya.com	$2y$12$QiJW6TjPKzDZPAuoWEex9OjPHQF33YzfkdC09FhasgPO.MjZ5btKe	New Admin	PA	Added About Me	media/User/1/default-admin-user.png	\N	f	t	t	0	0	0	0	0	0	0	0	0	0	0	0	2	2015-06-06 10:53:34.46	1	\N	2	t	2	f
\.


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('users_id_seq', 2, true);


--
-- Name: acl_links_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY acl_links
    ADD CONSTRAINT acl_links_id PRIMARY KEY (id);


--
-- Name: acl_links_roles_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY acl_links_roles
    ADD CONSTRAINT acl_links_roles_id PRIMARY KEY (id);


--
-- Name: activities_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY activities
    ADD CONSTRAINT activities_id PRIMARY KEY (id);


--
-- Name: board_subscribers_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY board_subscribers
    ADD CONSTRAINT board_subscribers_id PRIMARY KEY (id);


--
-- Name: board_users_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY boards_users
    ADD CONSTRAINT board_users_id PRIMARY KEY (id);


--
-- Name: boards_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY boards
    ADD CONSTRAINT boards_id PRIMARY KEY (id);


--
-- Name: card_attachments_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY card_attachments
    ADD CONSTRAINT card_attachments_id PRIMARY KEY (id);


--
-- Name: card_subscribers_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY card_subscribers
    ADD CONSTRAINT card_subscribers_id PRIMARY KEY (id);


--
-- Name: card_users_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY cards_users
    ADD CONSTRAINT card_users_id PRIMARY KEY (id);


--
-- Name: card_voters_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY card_voters
    ADD CONSTRAINT card_voters_id PRIMARY KEY (id);


--
-- Name: cards_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY cards
    ADD CONSTRAINT cards_id PRIMARY KEY (id);


--
-- Name: cards_labels_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY cards_labels
    ADD CONSTRAINT cards_labels_id PRIMARY KEY (id);


--
-- Name: checklist_items_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY checklist_items
    ADD CONSTRAINT checklist_items_id PRIMARY KEY (id);


--
-- Name: checklists_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY checklists
    ADD CONSTRAINT checklists_id PRIMARY KEY (id);


--
-- Name: cities_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY cities
    ADD CONSTRAINT cities_pkey PRIMARY KEY (id);


--
-- Name: countries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (id);


--
-- Name: email_templates_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY email_templates
    ADD CONSTRAINT email_templates_id PRIMARY KEY (id);


--
-- Name: ips_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ips
    ADD CONSTRAINT ips_pkey PRIMARY KEY (id);


--
-- Name: labels_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY labels
    ADD CONSTRAINT labels_id PRIMARY KEY (id);


--
-- Name: lists_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY lists
    ADD CONSTRAINT lists_id PRIMARY KEY (id);


--
-- Name: lists_subscribers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY list_subscribers
    ADD CONSTRAINT lists_subscribers_pkey PRIMARY KEY (id);


--
-- Name: oauth_access_tokens_access_token; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY oauth_access_tokens
    ADD CONSTRAINT oauth_access_tokens_access_token PRIMARY KEY (access_token);


--
-- Name: oauth_authorization_codes_authorization_code; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY oauth_authorization_codes
    ADD CONSTRAINT oauth_authorization_codes_authorization_code PRIMARY KEY (authorization_code);


--
-- Name: oauth_clients_client_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY oauth_clients
    ADD CONSTRAINT oauth_clients_client_id PRIMARY KEY (client_id);


--
-- Name: oauth_jwt_client_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY oauth_jwt
    ADD CONSTRAINT oauth_jwt_client_id PRIMARY KEY (client_id);


--
-- Name: oauth_refresh_tokens_refresh_token; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY oauth_refresh_tokens
    ADD CONSTRAINT oauth_refresh_tokens_refresh_token PRIMARY KEY (refresh_token);


--
-- Name: organization_users_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY organizations_users
    ADD CONSTRAINT organization_users_id PRIMARY KEY (id);


--
-- Name: organizations_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY organizations
    ADD CONSTRAINT organizations_id PRIMARY KEY (id);


--
-- Name: roles_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT roles_id PRIMARY KEY (id);


--
-- Name: setting_categories_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY setting_categories
    ADD CONSTRAINT setting_categories_id PRIMARY KEY (id);


--
-- Name: settings_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY settings
    ADD CONSTRAINT settings_id PRIMARY KEY (id);


--
-- Name: states_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY states
    ADD CONSTRAINT states_pkey PRIMARY KEY (id);


--
-- Name: users_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_id PRIMARY KEY (id);


--
-- Name: acl_links_roles_acl_link_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX acl_links_roles_acl_link_id ON acl_links_roles USING btree (acl_link_id);


--
-- Name: acl_links_roles_role_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX acl_links_roles_role_id ON acl_links_roles USING btree (role_id);


--
-- Name: acl_links_slug; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX acl_links_slug ON acl_links USING btree (slug);


--
-- Name: activities_attachment_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX activities_attachment_id ON activities USING btree (foreign_id);


--
-- Name: activities_board_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX activities_board_id ON activities USING btree (board_id);


--
-- Name: activities_card_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX activities_card_id ON activities USING btree (card_id);


--
-- Name: activities_depth; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX activities_depth ON activities USING btree (depth);


--
-- Name: activities_freshness_ts; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX activities_freshness_ts ON activities USING btree (freshness_ts);


--
-- Name: activities_list_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX activities_list_id ON activities USING btree (list_id);


--
-- Name: activities_materialized_path; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX activities_materialized_path ON activities USING btree (materialized_path);


--
-- Name: activities_path; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX activities_path ON activities USING btree (path);


--
-- Name: activities_root; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX activities_root ON activities USING btree (root);


--
-- Name: activities_type; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX activities_type ON activities USING btree (type);


--
-- Name: activities_user_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX activities_user_id ON activities USING btree (user_id);


--
-- Name: attachments_card_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX attachments_card_id ON card_attachments USING btree (card_id);


--
-- Name: board_stars_board_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX board_stars_board_id ON board_stars USING btree (board_id);


--
-- Name: board_stars_user_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX board_stars_user_id ON board_stars USING btree (user_id);


--
-- Name: board_subscribers_board_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX board_subscribers_board_id ON board_subscribers USING btree (board_id);


--
-- Name: board_subscribers_user_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX board_subscribers_user_id ON board_subscribers USING btree (user_id);


--
-- Name: board_users_board_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX board_users_board_id ON boards_users USING btree (board_id);


--
-- Name: board_users_user_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX board_users_user_id ON boards_users USING btree (user_id);


--
-- Name: boards_organization_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX boards_organization_id ON boards USING btree (organization_id);


--
-- Name: boards_user_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX boards_user_id ON boards USING btree (user_id);


--
-- Name: card_attachments_board_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX card_attachments_board_id ON card_attachments USING btree (board_id);


--
-- Name: card_attachments_list_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX card_attachments_list_id ON card_attachments USING btree (list_id);


--
-- Name: card_subscribers_card_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX card_subscribers_card_id ON card_subscribers USING btree (card_id);


--
-- Name: card_subscribers_user_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX card_subscribers_user_id ON card_subscribers USING btree (user_id);


--
-- Name: card_users_card_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX card_users_card_id ON cards_users USING btree (card_id);


--
-- Name: card_users_user_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX card_users_user_id ON cards_users USING btree (user_id);


--
-- Name: card_voters_card_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX card_voters_card_id ON card_voters USING btree (card_id);


--
-- Name: card_voters_user_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX card_voters_user_id ON card_voters USING btree (user_id);


--
-- Name: cards_board_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX cards_board_id ON cards USING btree (board_id);


--
-- Name: cards_labels_board_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX cards_labels_board_id ON cards_labels USING btree (board_id);


--
-- Name: cards_labels_card_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX cards_labels_card_id ON cards_labels USING btree (card_id);


--
-- Name: cards_labels_label_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX cards_labels_label_id ON cards_labels USING btree (label_id);


--
-- Name: cards_labels_list_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX cards_labels_list_id ON cards_labels USING btree (list_id);


--
-- Name: cards_list_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX cards_list_id ON cards USING btree (list_id);


--
-- Name: cards_user_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX cards_user_id ON cards USING btree (user_id);


--
-- Name: checklist_items_card_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX checklist_items_card_id ON checklist_items USING btree (card_id);


--
-- Name: checklist_items_checklist_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX checklist_items_checklist_id ON checklist_items USING btree (checklist_id);


--
-- Name: checklist_items_user_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX checklist_items_user_id ON checklist_items USING btree (user_id);


--
-- Name: checklists_card_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX checklists_card_id ON checklists USING btree (card_id);


--
-- Name: checklists_user_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX checklists_user_id ON checklists USING btree (user_id);


--
-- Name: email_templates_name; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX email_templates_name ON email_templates USING btree (name);


--
-- Name: labels_name; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX labels_name ON labels USING btree (name);


--
-- Name: list_subscribers_list_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX list_subscribers_list_id ON list_subscribers USING btree (list_id);


--
-- Name: list_subscribers_user_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX list_subscribers_user_id ON list_subscribers USING btree (user_id);


--
-- Name: lists_board_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX lists_board_id ON lists USING btree (board_id);


--
-- Name: lists_user_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX lists_user_id ON lists USING btree (user_id);


--
-- Name: oauth_access_tokens_client_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX oauth_access_tokens_client_id ON oauth_access_tokens USING btree (client_id);


--
-- Name: oauth_access_tokens_user_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX oauth_access_tokens_user_id ON oauth_access_tokens USING btree (user_id);


--
-- Name: oauth_authorization_codes_client_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX oauth_authorization_codes_client_id ON oauth_authorization_codes USING btree (client_id);


--
-- Name: oauth_authorization_codes_user_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX oauth_authorization_codes_user_id ON oauth_authorization_codes USING btree (user_id);


--
-- Name: oauth_clients_user_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX oauth_clients_user_id ON oauth_clients USING btree (user_id);


--
-- Name: oauth_refresh_tokens_client_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX oauth_refresh_tokens_client_id ON oauth_refresh_tokens USING btree (client_id);


--
-- Name: oauth_refresh_tokens_user_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX oauth_refresh_tokens_user_id ON oauth_refresh_tokens USING btree (user_id);


--
-- Name: organization_users_organization_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX organization_users_organization_id ON organizations_users USING btree (organization_id);


--
-- Name: organization_users_user_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX organization_users_user_id ON organizations_users USING btree (user_id);


--
-- Name: organizations_user_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX organizations_user_id ON organizations USING btree (user_id);


--
-- Name: roles_name; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX roles_name ON roles USING btree (name);


--
-- Name: setting_categories_parent_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX setting_categories_parent_id ON setting_categories USING btree (parent_id);


--
-- Name: settings_setting_category_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX settings_setting_category_id ON settings USING btree (setting_category_id);


--
-- Name: settings_setting_category_parent_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX settings_setting_category_parent_id ON settings USING btree (setting_category_parent_id);


--
-- Name: users_email; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX users_email ON users USING btree (email);


--
-- Name: users_last_activity_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX users_last_activity_id ON users USING btree (last_activity_id);


--
-- Name: users_role_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX users_role_id ON users USING btree (role_id);


--
-- Name: users_username; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX users_username ON users USING btree (username);


--
-- Name: label_card_count_update; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER label_card_count_update AFTER INSERT OR DELETE OR UPDATE ON cards_labels FOR EACH ROW EXECUTE PROCEDURE label_card_count_update();


--
-- Name: update_board_count; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_board_count AFTER INSERT OR DELETE OR UPDATE ON boards FOR EACH ROW EXECUTE PROCEDURE update_board_count();


--
-- Name: update_board_star_count; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_board_star_count AFTER INSERT OR DELETE OR UPDATE ON board_stars FOR EACH ROW EXECUTE PROCEDURE update_board_star_count();


--
-- Name: update_board_subscriber_count; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_board_subscriber_count AFTER INSERT OR DELETE OR UPDATE ON board_subscribers FOR EACH ROW EXECUTE PROCEDURE update_board_subscriber_count();


--
-- Name: update_board_user_count; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_board_user_count AFTER INSERT OR DELETE OR UPDATE ON boards_users FOR EACH ROW EXECUTE PROCEDURE update_board_user_count();


--
-- Name: update_card_activity_count; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_card_activity_count AFTER INSERT OR DELETE OR UPDATE ON activities FOR EACH ROW EXECUTE PROCEDURE update_card_activity_count();


--
-- Name: update_card_attachment_count; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_card_attachment_count AFTER INSERT OR DELETE OR UPDATE ON card_attachments FOR EACH ROW EXECUTE PROCEDURE update_card_attachment_count();


--
-- Name: update_card_checklist_count; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_card_checklist_count AFTER INSERT OR DELETE OR UPDATE ON checklists FOR EACH ROW EXECUTE PROCEDURE update_card_checklist_count();


--
-- Name: update_card_checklist_item_count; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_card_checklist_item_count AFTER INSERT OR DELETE OR UPDATE ON checklist_items FOR EACH ROW EXECUTE PROCEDURE update_card_checklist_item_count();


--
-- Name: update_card_count; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_card_count AFTER INSERT OR DELETE OR UPDATE ON cards FOR EACH ROW EXECUTE PROCEDURE update_card_count();


--
-- Name: update_card_subscriber_count; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_card_subscriber_count AFTER INSERT OR DELETE OR UPDATE ON card_subscribers FOR EACH ROW EXECUTE PROCEDURE update_card_subscriber_count();


--
-- Name: update_card_user_count; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_card_user_count AFTER INSERT OR DELETE OR UPDATE ON cards_users FOR EACH ROW EXECUTE PROCEDURE update_card_user_count();


--
-- Name: update_card_voters_count; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_card_voters_count AFTER INSERT OR DELETE OR UPDATE ON card_voters FOR EACH ROW EXECUTE PROCEDURE update_card_voters_count();


--
-- Name: update_comment_count; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_comment_count AFTER INSERT OR DELETE OR UPDATE ON activities FOR EACH ROW EXECUTE PROCEDURE update_comment_count();


--
-- Name: update_list_count; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_list_count AFTER INSERT OR DELETE OR UPDATE ON lists FOR EACH ROW EXECUTE PROCEDURE update_list_count();


--
-- Name: update_list_subscriber_count; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_list_subscriber_count AFTER INSERT OR DELETE OR UPDATE ON list_subscribers FOR EACH ROW EXECUTE PROCEDURE update_list_subscriber_count();


--
-- Name: update_organization_count; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_organization_count AFTER INSERT OR DELETE OR UPDATE ON organizations FOR EACH ROW EXECUTE PROCEDURE update_organization_count();


--
-- Name: update_organization_user_count; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_organization_user_count AFTER INSERT OR DELETE OR UPDATE ON organizations_users FOR EACH ROW EXECUTE PROCEDURE update_organization_user_count();


--
-- Name: update_user_delete; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_user_delete AFTER DELETE ON users FOR EACH ROW EXECUTE PROCEDURE update_user_delete();


--
-- Name: update_users_user_login_count; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_users_user_login_count AFTER INSERT OR DELETE OR UPDATE ON user_logins FOR EACH ROW EXECUTE PROCEDURE update_users_user_login_count();


--
-- Name: cities_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY cities
    ADD CONSTRAINT cities_country_id_fkey FOREIGN KEY (country_id) REFERENCES countries(id) ON DELETE CASCADE;


--
-- Name: cities_state_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY cities
    ADD CONSTRAINT cities_state_id_fkey FOREIGN KEY (state_id) REFERENCES states(id) ON DELETE CASCADE;


--
-- Name: states_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY states
    ADD CONSTRAINT states_country_id_fkey FOREIGN KEY (country_id) REFERENCES countries(id) ON DELETE CASCADE;


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- Name: acl_links_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE acl_links_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE acl_links_id_seq FROM postgres;
GRANT ALL ON SEQUENCE acl_links_id_seq TO postgres;
GRANT ALL ON SEQUENCE acl_links_id_seq TO restya;


--
-- Name: acl_links; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE acl_links FROM PUBLIC;
REVOKE ALL ON TABLE acl_links FROM postgres;
GRANT ALL ON TABLE acl_links TO postgres;
GRANT ALL ON TABLE acl_links TO restya;


--
-- Name: acl_links_roles_roles_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE acl_links_roles_roles_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE acl_links_roles_roles_id_seq FROM postgres;
GRANT ALL ON SEQUENCE acl_links_roles_roles_id_seq TO postgres;
GRANT ALL ON SEQUENCE acl_links_roles_roles_id_seq TO restya;


--
-- Name: acl_links_roles; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE acl_links_roles FROM PUBLIC;
REVOKE ALL ON TABLE acl_links_roles FROM postgres;
GRANT ALL ON TABLE acl_links_roles TO postgres;
GRANT ALL ON TABLE acl_links_roles TO restya;


--
-- Name: acl_links_listing; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE acl_links_listing FROM PUBLIC;
REVOKE ALL ON TABLE acl_links_listing FROM postgres;
GRANT ALL ON TABLE acl_links_listing TO postgres;
GRANT ALL ON TABLE acl_links_listing TO restya;


--
-- Name: activities_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE activities_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE activities_id_seq FROM postgres;
GRANT ALL ON SEQUENCE activities_id_seq TO postgres;
GRANT ALL ON SEQUENCE activities_id_seq TO restya;


--
-- Name: activities; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE activities FROM PUBLIC;
REVOKE ALL ON TABLE activities FROM postgres;
GRANT ALL ON TABLE activities TO postgres;
GRANT ALL ON TABLE activities TO restya;


--
-- Name: boards_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE boards_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE boards_id_seq FROM postgres;
GRANT ALL ON SEQUENCE boards_id_seq TO postgres;
GRANT ALL ON SEQUENCE boards_id_seq TO restya;


--
-- Name: boards; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE boards FROM PUBLIC;
REVOKE ALL ON TABLE boards FROM postgres;
GRANT ALL ON TABLE boards TO postgres;
GRANT ALL ON TABLE boards TO restya;


--
-- Name: cards_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE cards_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE cards_id_seq FROM postgres;
GRANT ALL ON SEQUENCE cards_id_seq TO postgres;
GRANT ALL ON SEQUENCE cards_id_seq TO restya;


--
-- Name: cards; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE cards FROM PUBLIC;
REVOKE ALL ON TABLE cards FROM postgres;
GRANT ALL ON TABLE cards TO postgres;
GRANT ALL ON TABLE cards TO restya;


--
-- Name: cards_labels_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE cards_labels_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE cards_labels_id_seq FROM postgres;
GRANT ALL ON SEQUENCE cards_labels_id_seq TO postgres;
GRANT ALL ON SEQUENCE cards_labels_id_seq TO restya;


--
-- Name: cards_labels; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE cards_labels FROM PUBLIC;
REVOKE ALL ON TABLE cards_labels FROM postgres;
GRANT ALL ON TABLE cards_labels TO postgres;
GRANT ALL ON TABLE cards_labels TO restya;


--
-- Name: labels_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE labels_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE labels_id_seq FROM postgres;
GRANT ALL ON SEQUENCE labels_id_seq TO postgres;
GRANT ALL ON SEQUENCE labels_id_seq TO restya;


--
-- Name: labels; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE labels FROM PUBLIC;
REVOKE ALL ON TABLE labels FROM postgres;
GRANT ALL ON TABLE labels TO postgres;
GRANT ALL ON TABLE labels TO restya;


--
-- Name: cards_labels_listing; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE cards_labels_listing FROM PUBLIC;
REVOKE ALL ON TABLE cards_labels_listing FROM postgres;
GRANT ALL ON TABLE cards_labels_listing TO postgres;
GRANT ALL ON TABLE cards_labels_listing TO restya;


--
-- Name: checklist_items_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE checklist_items_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE checklist_items_id_seq FROM postgres;
GRANT ALL ON SEQUENCE checklist_items_id_seq TO postgres;
GRANT ALL ON SEQUENCE checklist_items_id_seq TO restya;


--
-- Name: checklist_items; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE checklist_items FROM PUBLIC;
REVOKE ALL ON TABLE checklist_items FROM postgres;
GRANT ALL ON TABLE checklist_items TO postgres;
GRANT ALL ON TABLE checklist_items TO restya;


--
-- Name: checklists_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE checklists_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE checklists_id_seq FROM postgres;
GRANT ALL ON SEQUENCE checklists_id_seq TO postgres;
GRANT ALL ON SEQUENCE checklists_id_seq TO restya;


--
-- Name: checklists; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE checklists FROM PUBLIC;
REVOKE ALL ON TABLE checklists FROM postgres;
GRANT ALL ON TABLE checklists TO postgres;
GRANT ALL ON TABLE checklists TO restya;


--
-- Name: lists_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE lists_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE lists_id_seq FROM postgres;
GRANT ALL ON SEQUENCE lists_id_seq TO postgres;
GRANT ALL ON SEQUENCE lists_id_seq TO restya;


--
-- Name: lists; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE lists FROM PUBLIC;
REVOKE ALL ON TABLE lists FROM postgres;
GRANT ALL ON TABLE lists TO postgres;
GRANT ALL ON TABLE lists TO restya;


--
-- Name: organizations_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE organizations_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE organizations_id_seq FROM postgres;
GRANT ALL ON SEQUENCE organizations_id_seq TO postgres;
GRANT ALL ON SEQUENCE organizations_id_seq TO restya;


--
-- Name: organizations; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE organizations FROM PUBLIC;
REVOKE ALL ON TABLE organizations FROM postgres;
GRANT ALL ON TABLE organizations TO postgres;
GRANT ALL ON TABLE organizations TO restya;


--
-- Name: users_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE users_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE users_id_seq FROM postgres;
GRANT ALL ON SEQUENCE users_id_seq TO postgres;
GRANT ALL ON SEQUENCE users_id_seq TO restya;


--
-- Name: users; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE users FROM PUBLIC;
REVOKE ALL ON TABLE users FROM postgres;
GRANT ALL ON TABLE users TO postgres;
GRANT ALL ON TABLE users TO restya;


--
-- Name: activities_listing; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE activities_listing FROM PUBLIC;
REVOKE ALL ON TABLE activities_listing FROM postgres;
GRANT ALL ON TABLE activities_listing TO postgres;
GRANT ALL ON TABLE activities_listing TO restya;


--
-- Name: attachments_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE attachments_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE attachments_id_seq FROM postgres;
GRANT ALL ON SEQUENCE attachments_id_seq TO postgres;
GRANT ALL ON SEQUENCE attachments_id_seq TO restya;


--
-- Name: boards_stars_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE boards_stars_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE boards_stars_id_seq FROM postgres;
GRANT ALL ON SEQUENCE boards_stars_id_seq TO postgres;
GRANT ALL ON SEQUENCE boards_stars_id_seq TO restya;


--
-- Name: board_stars; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE board_stars FROM PUBLIC;
REVOKE ALL ON TABLE board_stars FROM postgres;
GRANT ALL ON TABLE board_stars TO postgres;
GRANT ALL ON TABLE board_stars TO restya;


--
-- Name: boards_subscribers_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE boards_subscribers_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE boards_subscribers_id_seq FROM postgres;
GRANT ALL ON SEQUENCE boards_subscribers_id_seq TO postgres;
GRANT ALL ON SEQUENCE boards_subscribers_id_seq TO restya;


--
-- Name: board_subscribers; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE board_subscribers FROM PUBLIC;
REVOKE ALL ON TABLE board_subscribers FROM postgres;
GRANT ALL ON TABLE board_subscribers TO postgres;
GRANT ALL ON TABLE board_subscribers TO restya;


--
-- Name: boards_labels_listing; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE boards_labels_listing FROM PUBLIC;
REVOKE ALL ON TABLE boards_labels_listing FROM postgres;
GRANT ALL ON TABLE boards_labels_listing TO postgres;
GRANT ALL ON TABLE boards_labels_listing TO restya;


--
-- Name: boards_users_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE boards_users_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE boards_users_id_seq FROM postgres;
GRANT ALL ON SEQUENCE boards_users_id_seq TO postgres;
GRANT ALL ON SEQUENCE boards_users_id_seq TO restya;


--
-- Name: boards_users; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE boards_users FROM PUBLIC;
REVOKE ALL ON TABLE boards_users FROM postgres;
GRANT ALL ON TABLE boards_users TO postgres;
GRANT ALL ON TABLE boards_users TO restya;


--
-- Name: boards_users_listing; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE boards_users_listing FROM PUBLIC;
REVOKE ALL ON TABLE boards_users_listing FROM postgres;
GRANT ALL ON TABLE boards_users_listing TO postgres;
GRANT ALL ON TABLE boards_users_listing TO restya;


--
-- Name: card_attachments_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE card_attachments_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE card_attachments_id_seq FROM postgres;
GRANT ALL ON SEQUENCE card_attachments_id_seq TO postgres;
GRANT ALL ON SEQUENCE card_attachments_id_seq TO restya;


--
-- Name: card_attachments; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE card_attachments FROM PUBLIC;
REVOKE ALL ON TABLE card_attachments FROM postgres;
GRANT ALL ON TABLE card_attachments TO postgres;
GRANT ALL ON TABLE card_attachments TO restya;


--
-- Name: cards_subscribers_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE cards_subscribers_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE cards_subscribers_id_seq FROM postgres;
GRANT ALL ON SEQUENCE cards_subscribers_id_seq TO postgres;
GRANT ALL ON SEQUENCE cards_subscribers_id_seq TO restya;


--
-- Name: card_subscribers; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE card_subscribers FROM PUBLIC;
REVOKE ALL ON TABLE card_subscribers FROM postgres;
GRANT ALL ON TABLE card_subscribers TO postgres;
GRANT ALL ON TABLE card_subscribers TO restya;


--
-- Name: card_voters_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE card_voters_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE card_voters_id_seq FROM postgres;
GRANT ALL ON SEQUENCE card_voters_id_seq TO postgres;
GRANT ALL ON SEQUENCE card_voters_id_seq TO restya;


--
-- Name: card_voters; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE card_voters FROM PUBLIC;
REVOKE ALL ON TABLE card_voters FROM postgres;
GRANT ALL ON TABLE card_voters TO postgres;
GRANT ALL ON TABLE card_voters TO restya;


--
-- Name: card_voters_listing; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE card_voters_listing FROM PUBLIC;
REVOKE ALL ON TABLE card_voters_listing FROM postgres;
GRANT ALL ON TABLE card_voters_listing TO postgres;
GRANT ALL ON TABLE card_voters_listing TO restya;


--
-- Name: cards_users_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE cards_users_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE cards_users_id_seq FROM postgres;
GRANT ALL ON SEQUENCE cards_users_id_seq TO postgres;
GRANT ALL ON SEQUENCE cards_users_id_seq TO restya;


--
-- Name: cards_users; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE cards_users FROM PUBLIC;
REVOKE ALL ON TABLE cards_users FROM postgres;
GRANT ALL ON TABLE cards_users TO postgres;
GRANT ALL ON TABLE cards_users TO restya;


--
-- Name: cards_users_listing; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE cards_users_listing FROM PUBLIC;
REVOKE ALL ON TABLE cards_users_listing FROM postgres;
GRANT ALL ON TABLE cards_users_listing TO postgres;
GRANT ALL ON TABLE cards_users_listing TO restya;


--
-- Name: checklists_listing; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE checklists_listing FROM PUBLIC;
REVOKE ALL ON TABLE checklists_listing FROM postgres;
GRANT ALL ON TABLE checklists_listing TO postgres;
GRANT ALL ON TABLE checklists_listing TO restya;


--
-- Name: cards_listing; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE cards_listing FROM PUBLIC;
REVOKE ALL ON TABLE cards_listing FROM postgres;
GRANT ALL ON TABLE cards_listing TO postgres;
GRANT ALL ON TABLE cards_listing TO restya;


--
-- Name: lists_subscribers_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE lists_subscribers_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE lists_subscribers_id_seq FROM postgres;
GRANT ALL ON SEQUENCE lists_subscribers_id_seq TO postgres;
GRANT ALL ON SEQUENCE lists_subscribers_id_seq TO restya;


--
-- Name: list_subscribers; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE list_subscribers FROM PUBLIC;
REVOKE ALL ON TABLE list_subscribers FROM postgres;
GRANT ALL ON TABLE list_subscribers TO postgres;
GRANT ALL ON TABLE list_subscribers TO restya;


--
-- Name: lists_listing; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE lists_listing FROM PUBLIC;
REVOKE ALL ON TABLE lists_listing FROM postgres;
GRANT ALL ON TABLE lists_listing TO postgres;
GRANT ALL ON TABLE lists_listing TO restya;


--
-- Name: boards_listing; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE boards_listing FROM PUBLIC;
REVOKE ALL ON TABLE boards_listing FROM postgres;
GRANT ALL ON TABLE boards_listing TO postgres;
GRANT ALL ON TABLE boards_listing TO restya;


--
-- Name: checklist_add_listing; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE checklist_add_listing FROM PUBLIC;
REVOKE ALL ON TABLE checklist_add_listing FROM postgres;
GRANT ALL ON TABLE checklist_add_listing TO postgres;
GRANT ALL ON TABLE checklist_add_listing TO restya;


--
-- Name: cities; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE cities FROM PUBLIC;
REVOKE ALL ON TABLE cities FROM postgres;
GRANT ALL ON TABLE cities TO postgres;
GRANT ALL ON TABLE cities TO restya;


--
-- Name: cities_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE cities_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE cities_id_seq FROM postgres;
GRANT ALL ON SEQUENCE cities_id_seq TO postgres;
GRANT ALL ON SEQUENCE cities_id_seq TO restya;


--
-- Name: cities_id_seq1; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE cities_id_seq1 FROM PUBLIC;
REVOKE ALL ON SEQUENCE cities_id_seq1 FROM postgres;
GRANT ALL ON SEQUENCE cities_id_seq1 TO postgres;
GRANT ALL ON SEQUENCE cities_id_seq1 TO restya;


--
-- Name: countries; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE countries FROM PUBLIC;
REVOKE ALL ON TABLE countries FROM postgres;
GRANT ALL ON TABLE countries TO postgres;
GRANT ALL ON TABLE countries TO restya;


--
-- Name: countries_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE countries_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE countries_id_seq FROM postgres;
GRANT ALL ON SEQUENCE countries_id_seq TO postgres;
GRANT ALL ON SEQUENCE countries_id_seq TO restya;


--
-- Name: countries_id_seq1; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE countries_id_seq1 FROM PUBLIC;
REVOKE ALL ON SEQUENCE countries_id_seq1 FROM postgres;
GRANT ALL ON SEQUENCE countries_id_seq1 TO postgres;
GRANT ALL ON SEQUENCE countries_id_seq1 TO restya;


--
-- Name: email_templates_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE email_templates_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE email_templates_id_seq FROM postgres;
GRANT ALL ON SEQUENCE email_templates_id_seq TO postgres;
GRANT ALL ON SEQUENCE email_templates_id_seq TO restya;


--
-- Name: email_templates; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE email_templates FROM PUBLIC;
REVOKE ALL ON TABLE email_templates FROM postgres;
GRANT ALL ON TABLE email_templates TO postgres;
GRANT ALL ON TABLE email_templates TO restya;


--
-- Name: gadget_users_listing; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE gadget_users_listing FROM PUBLIC;
REVOKE ALL ON TABLE gadget_users_listing FROM postgres;
GRANT ALL ON TABLE gadget_users_listing TO postgres;
GRANT ALL ON TABLE gadget_users_listing TO restya;


--
-- Name: ips_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE ips_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE ips_id_seq FROM postgres;
GRANT ALL ON SEQUENCE ips_id_seq TO postgres;
GRANT ALL ON SEQUENCE ips_id_seq TO restya;


--
-- Name: ips; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE ips FROM PUBLIC;
REVOKE ALL ON TABLE ips FROM postgres;
GRANT ALL ON TABLE ips TO postgres;
GRANT ALL ON TABLE ips TO restya;


--
-- Name: list_subscribers_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE list_subscribers_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE list_subscribers_id_seq FROM postgres;
GRANT ALL ON SEQUENCE list_subscribers_id_seq TO postgres;
GRANT ALL ON SEQUENCE list_subscribers_id_seq TO restya;


--
-- Name: login_types_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE login_types_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE login_types_id_seq FROM postgres;
GRANT ALL ON SEQUENCE login_types_id_seq TO postgres;
GRANT ALL ON SEQUENCE login_types_id_seq TO restya;


--
-- Name: login_types; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE login_types FROM PUBLIC;
REVOKE ALL ON TABLE login_types FROM postgres;
GRANT ALL ON TABLE login_types TO postgres;
GRANT ALL ON TABLE login_types TO restya;


--
-- Name: oauth_access_tokens; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE oauth_access_tokens FROM PUBLIC;
REVOKE ALL ON TABLE oauth_access_tokens FROM postgres;
GRANT ALL ON TABLE oauth_access_tokens TO postgres;
GRANT ALL ON TABLE oauth_access_tokens TO restya;


--
-- Name: oauth_authorization_codes; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE oauth_authorization_codes FROM PUBLIC;
REVOKE ALL ON TABLE oauth_authorization_codes FROM postgres;
GRANT ALL ON TABLE oauth_authorization_codes TO postgres;
GRANT ALL ON TABLE oauth_authorization_codes TO restya;


--
-- Name: oauth_clients; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE oauth_clients FROM PUBLIC;
REVOKE ALL ON TABLE oauth_clients FROM postgres;
GRANT ALL ON TABLE oauth_clients TO postgres;
GRANT ALL ON TABLE oauth_clients TO restya;


--
-- Name: oauth_jwt; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE oauth_jwt FROM PUBLIC;
REVOKE ALL ON TABLE oauth_jwt FROM postgres;
GRANT ALL ON TABLE oauth_jwt TO postgres;
GRANT ALL ON TABLE oauth_jwt TO restya;


--
-- Name: oauth_refresh_tokens; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE oauth_refresh_tokens FROM PUBLIC;
REVOKE ALL ON TABLE oauth_refresh_tokens FROM postgres;
GRANT ALL ON TABLE oauth_refresh_tokens TO postgres;
GRANT ALL ON TABLE oauth_refresh_tokens TO restya;


--
-- Name: oauth_scopes; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE oauth_scopes FROM PUBLIC;
REVOKE ALL ON TABLE oauth_scopes FROM postgres;
GRANT ALL ON TABLE oauth_scopes TO postgres;
GRANT ALL ON TABLE oauth_scopes TO restya;


--
-- Name: organizations_users_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE organizations_users_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE organizations_users_id_seq FROM postgres;
GRANT ALL ON SEQUENCE organizations_users_id_seq TO postgres;
GRANT ALL ON SEQUENCE organizations_users_id_seq TO restya;


--
-- Name: organizations_users; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE organizations_users FROM PUBLIC;
REVOKE ALL ON TABLE organizations_users FROM postgres;
GRANT ALL ON TABLE organizations_users TO postgres;
GRANT ALL ON TABLE organizations_users TO restya;


--
-- Name: organizations_users_listing; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE organizations_users_listing FROM PUBLIC;
REVOKE ALL ON TABLE organizations_users_listing FROM postgres;
GRANT ALL ON TABLE organizations_users_listing TO postgres;
GRANT ALL ON TABLE organizations_users_listing TO restya;


--
-- Name: organizations_listing; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE organizations_listing FROM PUBLIC;
REVOKE ALL ON TABLE organizations_listing FROM postgres;
GRANT ALL ON TABLE organizations_listing TO postgres;
GRANT ALL ON TABLE organizations_listing TO restya;


--
-- Name: roles_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE roles_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE roles_id_seq FROM postgres;
GRANT ALL ON SEQUENCE roles_id_seq TO postgres;
GRANT ALL ON SEQUENCE roles_id_seq TO restya;


--
-- Name: roles; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE roles FROM PUBLIC;
REVOKE ALL ON TABLE roles FROM postgres;
GRANT ALL ON TABLE roles TO postgres;
GRANT ALL ON TABLE roles TO restya;


--
-- Name: role_links_listing; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE role_links_listing FROM PUBLIC;
REVOKE ALL ON TABLE role_links_listing FROM postgres;
GRANT ALL ON TABLE role_links_listing TO postgres;
GRANT ALL ON TABLE role_links_listing TO restya;


--
-- Name: setting_categories; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE setting_categories FROM PUBLIC;
REVOKE ALL ON TABLE setting_categories FROM postgres;
GRANT ALL ON TABLE setting_categories TO postgres;
GRANT ALL ON TABLE setting_categories TO restya;


--
-- Name: setting_categories_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE setting_categories_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE setting_categories_id_seq FROM postgres;
GRANT ALL ON SEQUENCE setting_categories_id_seq TO postgres;
GRANT ALL ON SEQUENCE setting_categories_id_seq TO restya;


--
-- Name: settings_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE settings_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE settings_id_seq FROM postgres;
GRANT ALL ON SEQUENCE settings_id_seq TO postgres;
GRANT ALL ON SEQUENCE settings_id_seq TO restya;


--
-- Name: settings; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE settings FROM PUBLIC;
REVOKE ALL ON TABLE settings FROM postgres;
GRANT ALL ON TABLE settings TO postgres;
GRANT ALL ON TABLE settings TO restya;


--
-- Name: settings_listing; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE settings_listing FROM PUBLIC;
REVOKE ALL ON TABLE settings_listing FROM postgres;
GRANT ALL ON TABLE settings_listing TO postgres;
GRANT ALL ON TABLE settings_listing TO restya;


--
-- Name: simple_board_listing; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE simple_board_listing FROM PUBLIC;
REVOKE ALL ON TABLE simple_board_listing FROM postgres;
GRANT ALL ON TABLE simple_board_listing TO postgres;
GRANT ALL ON TABLE simple_board_listing TO restya;


--
-- Name: states; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE states FROM PUBLIC;
REVOKE ALL ON TABLE states FROM postgres;
GRANT ALL ON TABLE states TO postgres;
GRANT ALL ON TABLE states TO restya;


--
-- Name: states_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE states_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE states_id_seq FROM postgres;
GRANT ALL ON SEQUENCE states_id_seq TO postgres;
GRANT ALL ON SEQUENCE states_id_seq TO restya;


--
-- Name: states_id_seq1; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE states_id_seq1 FROM PUBLIC;
REVOKE ALL ON SEQUENCE states_id_seq1 FROM postgres;
GRANT ALL ON SEQUENCE states_id_seq1 TO postgres;
GRANT ALL ON SEQUENCE states_id_seq1 TO restya;


--
-- Name: user_logins; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE user_logins FROM PUBLIC;
REVOKE ALL ON TABLE user_logins FROM postgres;
GRANT ALL ON TABLE user_logins TO postgres;
GRANT ALL ON TABLE user_logins TO restya;


--
-- Name: user_logins_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE user_logins_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE user_logins_id_seq FROM postgres;
GRANT ALL ON SEQUENCE user_logins_id_seq TO postgres;
GRANT ALL ON SEQUENCE user_logins_id_seq TO restya;


--
-- Name: users_cards_listing; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE users_cards_listing FROM PUBLIC;
REVOKE ALL ON TABLE users_cards_listing FROM postgres;
GRANT ALL ON TABLE users_cards_listing TO postgres;
GRANT ALL ON TABLE users_cards_listing TO restya;


--
-- Name: users_listing; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE users_listing FROM PUBLIC;
REVOKE ALL ON TABLE users_listing FROM postgres;
GRANT ALL ON TABLE users_listing TO postgres;
GRANT ALL ON TABLE users_listing TO restya;


--
-- PostgreSQL database dump complete
--

