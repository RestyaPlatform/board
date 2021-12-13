<?php
/**
 * Ical format of card to create Google calendar
 *
 * PHP version 5
 *
 * @category   PHP
 * @package    Restyaboard
 * @subpackage Core
 * @author     Restya <info@restya.com>
 * @copyright  2014 Restya
 * @license    http://restya.com/ Restya Licence
 * @link       http://restya.com/
 */
require_once 'config.inc.php';
global $_server_domain_url;
if (file_exists(SITE_URL_FOR_SHELL)) {
    include_once SITE_URL_FOR_SHELL;
}
if (!empty($_GET['board_id']) && !empty($_GET['user_id']) && !empty($_GET['hash'])) {
    $md5_hash = md5(SECURITYSALT . $_GET['board_id'] . $_GET['user_id']);
    if ($md5_hash == $_GET['hash']) {
        $timezone = SITE_TIMEZONE;
        $val_array = array(
            $_GET['user_id']
        );
        $result = pg_query_params($db_lnk, 'SELECT timezone FROM users WHERE id = $1', $val_array);
        $user = pg_fetch_assoc($result);
        if (!empty($user['timezone'])) {
            $timezone = $user['timezone'];
        }
        date_default_timezone_set($timezone);
        $val_array = array(
            $_GET['board_id']
        );
        // For restricted board user assigned cards
        if (!empty($user)) {
            $board_user = pg_query_params($db_lnk, 'SELECT board_id FROM boards_users WHERE user_id = $1 AND board_user_role_id = $2 AND board_id = $3', array(
                $_GET['user_id'],
                4,
                $_GET['board_id']
            ));
            $is_restricted_board_user = pg_fetch_assoc($board_user);
        }
        if (!empty($is_restricted_board_user)) {
            $cardsIDS = pg_query_params($db_lnk, 'SELECT c.id, c.board_id FROM cards c left join cards_users cu on cu.card_id = c.id WHERE cu.user_id = $1 AND c.board_id = $2', array(
                $_GET['user_id'],
                $_GET['board_id']
            ));
            while ($row = pg_fetch_assoc($cardsIDS)) {
                $assigned_card_ids[] = $row['id'];
            }
        }
        $result = pg_query_params($db_lnk, 'SELECT board.name, card.id, card.name as card_name, card.description, card.due_date FROM boards board LEFT JOIN cards card ON card.board_id = board.id WHERE card.is_archived = FALSE AND card.due_date IS NOT NULL AND board.id = $1', $val_array);
        $count = pg_num_rows($result);
        $ical = 'BEGIN:VCALENDAR' . "\r\n";
        $ical.= 'VERSION:2.0' . "\r\n";
        $ical.= 'PRODID:-//' . SITE_NAME . '//EN' . "\r\n";
        $ical.= 'X-PUBLISHED-TTL:PT1H' . "\r\n";
        $ical.= 'X-ORIGINAL-URL:' . $_server_domain_url . "\r\n";
        $ical.= 'METHOD:PUBLISH' . "\r\n";
        if ($count > 0) {
            $event = $board_name = '';
            while ($row = pg_fetch_assoc($result)) {
                $board_name = $row['name'];
                $uid = preg_replace('#^https?://#', '', $_server_domain_url);
                // Checcking unassigned cards for Restricted board user.
                if (!empty($assigned_card_ids)) {
                    if (in_array($row['id'], $assigned_card_ids)) {
                        $event.= 'BEGIN:VEVENT' . "\r\n";
                        $event.= 'UID:' . $row['id'] . "@" . $uid . "\r\n";
                        $event.= 'DTSTART;TZID=' . $timezone . ':' . date('Ymd\THis', strtotime($row['due_date'])) . "\r\n";
                        $event.= 'DTEND;TZID=' . $timezone . ':' . date('Ymd\THis', strtotime($row['due_date'])) . "\r\n";
                        $event.= 'SUMMARY:' . $row['card_name'] . "\r\n";
                        $event.= 'URL:' . $_server_domain_url . '/#/board/' . $_GET['board_id'] . "/card/" . $row['id'] . "\r\n";
                        $event.= 'END:VEVENT' . "\r\n";
                    }
                } else if (!empty($is_restricted_board_user)) {
                    $event = null;
                } else if (empty($is_restricted_board_user)) {
                    $event.= 'BEGIN:VEVENT' . "\r\n";
                    $event.= 'UID:' . $row['id'] . "@" . $uid . "\r\n";
                    $event.= 'DTSTART;TZID=' . $timezone . ':' . date('Ymd\THis', strtotime($row['due_date'])) . "\r\n";
                    $event.= 'DTEND;TZID=' . $timezone . ':' . date('Ymd\THis', strtotime($row['due_date'])) . "\r\n";
                    $event.= 'SUMMARY:' . $row['card_name'] . "\r\n";
                    $event.= 'URL:' . $_server_domain_url . '/#/board/' . $_GET['board_id'] . "/card/" . $row['id'] . "\r\n";
                    $event.= 'END:VEVENT' . "\r\n";
                }
            }
            $ical.= 'X-WR-CALNAME:' . $board_name . ' (via ' . SITE_NAME . ')' . "\r\n";
            $ical.= $event;
        }
        $ical.= 'END:VCALENDAR';
        header('Content-type: text/calendar; charset=utf-8');
        header('Content-Disposition: inline; filename=calendar.ics');
        echo $ical;
    } else {
        header($_SERVER['SERVER_PROTOCOL'] . ' 404 Not Found', true, 404);
    }
} else {
    header($_SERVER['SERVER_PROTOCOL'] . ' 404 Not Found', true, 404);
}
