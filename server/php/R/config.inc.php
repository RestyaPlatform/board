<?php
/**
 * Core configurations
 *
 * PHP version 5
 *
 * @category   PHP
 * @package    Restyaboard
 * @subpackage Core
 * @author     Restya <info@restya.com>
 * @copyright  2014 Restya
 * @license    http://www.restya.com/ Restya Licence
 * @link       http://www.restya.com
 */
define('R_DEBUG', false);
ini_set('display_errors', R_DEBUG);
define('R_API_VERSION', 1);
define('APP_PATH', dirname(dirname(dirname(dirname(__FILE__)))));
// While changing below oAuth credentials, have to update in oauth_clients table also.
define('OAUTH_CLIENTID', '7742632501382313');
define('OAUTH_CLIENT_SECRET', '4g7C4l1Y2b0S6a7L8c1E7B3K0e');
$default_timezone = 'Europe/Berlin';
if (ini_get('date.timezone')) {
    $default_timezone = ini_get('date.timezone');
}
date_default_timezone_set($default_timezone);
define('R_DB_HOST', 'localhost');
define('R_DB_USER', 'restya');
define('R_DB_PASSWORD', 'hjVl2!rGd');
define('R_DB_NAME', 'restyaboard');
define('R_DB_PORT', 5432);
define('SecuritySalt', 'e9a556134534545ab47c6c81c14f06c0b8sdfsdf');
if (!($db_lnk = @pg_connect('host=' . R_DB_HOST . ' port=' . R_DB_PORT . ' dbname=' . R_DB_NAME . ' user=' . R_DB_USER . ' password=' . R_DB_PASSWORD . ' options=--client_encoding=UTF8'))) {
    header($_SERVER['SERVER_PROTOCOL'] . ' 500 Internal Server Error', true, 500);
    $r_debug.= __LINE__ . ': ' . pg_last_error($db_lnk) . '\n';
}
$settings = pg_query_params($db_lnk, 'SELECT name, value FROM settings WHERE setting_category_id in (1,2,3) OR setting_category_parent_id in (1,2,3)', array());
while ($setting = pg_fetch_assoc($settings)) {
    if ($setting['name'] == 'LDAP_LOGIN_ENABLED') {
        $setting['value'] = (in_array(strtolower($setting['value']) , array(
            'true'
        ))) ? true : false;
    }
    define($setting['name'], $setting['value']);
}
$thumbsizes = array(
    'User' => array(
        'micro_thumb' => '16x16',
        'small_thumb' => '32x32',
        'normal_thumb' => '64x64',
        'medium_thumb' => '153x153'
    ) ,
    'Organization' => array(
        'medium_thumb' => '153x153',
        'small_thumb' => '32x32'
    ) ,
    'Board' => array(
        'micro_thumb' => '16x16',
        'small_thumb' => '32x32',
        'medium_thumb' => '153x153',
        'extra_large_thumb' => '2000x1263'
    ) ,
    'CardAttachment' => array(
        'small_thumb' => '108x78',
        'medium_thumb' => '153x153',
        'large_thumb' => '202x151'
    )
);
$aspect['CardAttachment']['large_thumb'] = 1;
