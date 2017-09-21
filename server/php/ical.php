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
if (file_exists(APP_PATH . '/tmp/cache/site_url_for_shell.php')) {
    include_once APP_PATH . '/tmp/cache/site_url_for_shell.php';
}
if (!empty($_GET['id']) && !empty($_GET['hash'])) {
    $md5_hash = md5(SECURITYSALT . $_GET['id']);
    if ($md5_hash == $_GET['hash']) {
        $timezone = SITE_TIMEZONE;
        $conditions = array(
            $timezone
        );
        $result = pg_query_params($db_lnk, 'select * from timezones WHERE code = $1', $conditions);
        $timezone = pg_fetch_assoc($result); 
        $timezone_hours = substr($timezone['utc_offset'], 0, -2);
        $timezone_minutes = substr($timezone['utc_offset'], -2);
        $val_array = array(
            $_GET['id']
        );
        $result = pg_query_params($db_lnk, 'SELECT board.name, card.id, card.name as card_name, card.description, card.due_date FROM boards board LEFT JOIN cards card ON card.board_id = board.id WHERE card.is_archived = FALSE AND card.due_date IS NOT NULL AND board.id = $1', $val_array);
        $count = pg_num_rows($result);
        $ical = 'BEGIN:VCALENDAR' . "\r\n";
        $ical.= 'VERSION:2.0' . "\r\n";
        $ical.= 'PRODID:-//' . SITE_NAME . '//EN' . "\r\n";
        $ical.= 'X-PUBLISHED-TTL:PT1H' . "\r\n";
        $ical.= 'X-ORIGINAL-URL:' . $_server_domain_url . "\r\n";
        $ical.= 'CALSCALE:GREGORIAN' . "\r\n";
        $ical.= 'METHOD:PUBLISH' . "\r\n";
        if ($count > 0) {
            $event = $board_name = '';
            while ($row = pg_fetch_assoc($result)) {
                $board_name = $row['name'];
                $due_date =  $row['due_date'].' '.$timezone_hours . 'hours ' . $timezone_minutes . 'minutes';
                $event.= 'BEGIN:VEVENT' . "\r\n";
                $event.= 'UID:' . $row['id'] . "\r\n";
                $event.= 'DTSTART:' . date('Ymd\THis\Z', strtotime($due_date)) . "\r\n";
                $event.= 'DTEND:' . date('Ymd\THis\Z', strtotime($due_date)) . "\r\n";
                $event.= 'SUMMARY:' . $row['card_name'] . "\r\n";
                $event.= 'URL:' . $_server_domain_url . '/client/#/board/' . $_GET['id'] . "\r\n";
                $event.= 'END:VEVENT' . "\r\n";
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
