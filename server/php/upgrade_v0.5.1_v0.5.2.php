<?php
/**
 * To delete board subscribers
 *
 * PHP version 5
 *
 * @category   PHP
 * @package    Restyaboard
 * @subpackage Core
 * @author     Restya <info@restya.com>
 * @copyright  2014-2019 Restya
 * @license    http://restya.com/ Restya Licence
 * @link       http://restya.com/
 */
require_once 'config.inc.php';
require_once 'libs/core.php';
if ($db_lnk) {
    $qry_val = array(
        'SITE_TIMEZONE'
    );
    $check_settings_timezone = executeQuery('select * from settings where name = $1', $qry_val);
    if ($check_settings_timezone['value'] != '') {
        $data = array(
            'SITE_TIMEZONE'
        );
        pg_query_params($db_lnk, 'update settings set value = (select code from timezones where utc_offset = (select value from settings where name = $1) limit 1) where name = $1', $data);
    } else {
        $data = array(
            'Europe/Berlin',
            'SITE_TIMEZONE'
        );
        pg_query_params($db_lnk, 'UPDATE settings SET value = $1 WHERE name = $2', $data);
    }
    $users = pg_query_params($db_lnk, 'SELECT * FROM users order by id', array());
    while ($user = pg_fetch_assoc($users)) {
        if ($user['timezone'] != '') {
            $data = array(
                $user['timezone'],
                $user['id']
            );
            pg_query_params($db_lnk, 'update users set timezone = (select code from timezones where utc_offset = $1 limit 1) where id = $2', $data);
        } else {
            $data = array(
                'SITE_TIMEZONE',
                $user['id']
            );
            pg_query_params($db_lnk, 'update users set timezone = (select value from settings where name = $1) where id = $2', $data);
        }
    }
}
