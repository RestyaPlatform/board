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
 * @copyright  2014-2018 Restya
 * @license    http://restya.com/ Restya Licence
 * @link       http://restya.com/
 */
define('R_DEBUG', true);
ini_set('display_errors', R_DEBUG);
define('R_API_VERSION', 1);
if (!defined('JSON_PRETTY_PRINT')) {
    define('JSON_PRETTY_PRINT', 128);
}
if (!defined('JSON_UNESCAPED_SLASHES')) {
    define('JSON_UNESCAPED_SLASHES', 128);
}
if (!defined('JSON_UNESCAPED_UNICODE')) {
    define('JSON_UNESCAPED_UNICODE', 256);
}
define('APP_PATH', dirname(dirname(dirname(__FILE__))));
define('SITE_URL_FOR_SHELL', sys_get_temp_dir() . '/restya_site_url_for_shell.php');
define('CLIENT_INFORMATION', sys_get_temp_dir() . '/restya_client_information.php');

// While changing below oAuth credentials, have to update in oauth_clients table also.
if (isset($_SERVER['PHP_AUTH_USER']) && isset($_SERVER['PHP_AUTH_PW'])) {
    define('OAUTH_CLIENTID', $_SERVER['PHP_AUTH_USER']);
    define('OAUTH_CLIENT_SECRET', $_SERVER['PHP_AUTH_PW']);
} else {
    define('OAUTH_CLIENTID', '7742632501382313');
    define('OAUTH_CLIENT_SECRET', '4g7C4l1Y2b0S6a7L8c1E7B3K0e');
}
define('R_DB_HOST', 'postgres');
define('R_DB_USER', 'admin');
define('R_DB_PASSWORD', 'admin');
define('R_DB_NAME', 'restyaboard');
define('R_DB_PORT', '5432');
define('CHAT_DB_HOST', 'localhost');
define('CHAT_DB_USER', 'ejabberd');
define('CHAT_DB_PASSWORD', 'ftfnVgYl2');
define('CHAT_DB_NAME', 'ejabb');
define('CHAT_DB_PORT', '5432');
define('SECURITYSALT', 'e9a556134534545ab47c6c81c14f06c0b8sdfsdf');
define('SITE_LICENSE_KEY', 'REPLACE YOUR LICENCE HERE');
define('LICENSE_HASH', '');
if (!defined('STDIN') && !file_exists(SITE_URL_FOR_SHELL) && !empty($_server_domain_url)) {
    $fh = fopen(SITE_URL_FOR_SHELL, 'a');
    fwrite($fh, '<?php' . "\n");
    fwrite($fh, '$_server_domain_url = \'' . $_server_domain_url . '\';');
    fclose($fh);
}
$db_lnk = pg_connect('host=' . R_DB_HOST . ' port=' . R_DB_PORT . ' dbname=' . R_DB_NAME . ' user=' . R_DB_USER . ' password=' . R_DB_PASSWORD . ' options=--client_encoding=UTF8') or die('Database could not connect');
$settings = pg_query_params($db_lnk, 'SELECT name, value FROM settings', array());
while ($setting = pg_fetch_assoc($settings)) {
    define($setting['name'], $setting['value']);
}
date_default_timezone_set(SITE_TIMEZONE);
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
