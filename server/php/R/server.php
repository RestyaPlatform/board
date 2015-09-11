<?php
/**
 * Create and configure OAuth2 Server object
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
require_once 'libs/vendors/OAuth2/Autoloader.php';
OAuth2\Autoloader::register();
$oauth_config = array(
    'user_table' => 'users'
);
$val_array = array(
    'dsn' => 'pgsql:host=' . R_DB_HOST . ';dbname=' . R_DB_NAME . ';port=' . R_DB_PORT,
    'username' => R_DB_USER,
    'password' => R_DB_PASSWORD
);
$storage = new OAuth2\Storage\Pdo($val_array, $oauth_config);
$server = new OAuth2\Server($storage);
if (isset($_POST['grant_type']) && $_POST['grant_type'] == 'password') {
    $val_array = array(
        'password' => $_POST['password']
    );
    $users = array(
        $_POST['username'] => $val_array
    );
    $user_credentials = array(
        'user_credentials' => $users
    );
    $storage = new OAuth2\Storage\Memory($user_credentials);
    $server->addGrantType(new OAuth2\GrantType\UserCredentials($storage));
} elseif (isset($_POST['grant_type']) && $_POST['grant_type'] == 'refresh_token') {
    $server->addGrantType(new OAuth2\GrantType\RefreshToken($storage));
} else {
    $val_array = array(
        'client_secret' => OAUTH_CLIENT_SECRET
    );
    $clients = array(
        OAUTH_CLIENTID => $val_array
    );
    $credentials = array(
        'client_credentials' => $clients
    );
    $storage = new OAuth2\Storage\Memory($credentials);
    $server->addGrantType(new OAuth2\GrantType\ClientCredentials($storage));
}
