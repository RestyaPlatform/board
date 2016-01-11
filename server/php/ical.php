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
if (!empty($_GET['id']) && !empty($_GET['hash'])) {
    $md5_hash = md5(SECURITYSALT . $_GET['id']);
    if ($md5_hash == $_GET['hash']) {
        $r_debug = '';
        if ($db_lnk) {
            $val_array = array(
                $_GET['id']
            );
            $result = pg_query_params($db_lnk, 'SELECT board.name, card.id, card.name as card_name, card.description, card.due_date FROM boards board LEFT JOIN cards card ON card.board_id = board.id WHERE card.is_archived = FALSE AND card.due_date IS NOT NULL AND board.id = $1', $val_array);
            $count = pg_num_rows($result);
            $ical = 'BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//' . SITE_NAME . '//EN
X-PUBLISHED-TTL:PT1H
X-ORIGINAL-URL:http://' . $_SERVER['HTTP_HOST'] . '
CALSCALE:GREGORIAN
METHOD:PUBLISH';
            if ($count > 0) {
                $event = '';
                $board_name = '';
                while ($row = pg_fetch_assoc($result)) {
                    $board_name = $row['name'];
                    $event.= '
BEGIN:VEVENT
UID:' . $row['id'] . '
DTSTART:' . date('Ymd\THis\Z', strtotime($row['due_date'])) . '
DTEND:' . date('Ymd\THis\Z', strtotime($row['due_date'])) . '
SUMMARY:' . $row['card_name'] . '
URL:http://' . $_SERVER['HTTP_HOST'] . '/client/#/board/' . $_GET['id'] . '
DESCRIPTION:' . $row['description'] . '
END:VEVENT';
                }
                $ical.= '
X-WR-CALNAME:' . $board_name . ' (via ' . SITE_NAME . ')';
                $ical.= $event;
            }
            $ical.= '
END:VCALENDAR';
            header('Content-type: text/calendar; charset=utf-8');
            header('Content-Disposition: inline; filename=calendar.ics');
            echo $ical;
            exit;
        }
    } else {
        header($_SERVER['SERVER_PROTOCOL'] . ' 404 Not Found', true, 404);
    }
} else {
    header($_SERVER['SERVER_PROTOCOL'] . ' 404 Not Found', true, 404);
}
