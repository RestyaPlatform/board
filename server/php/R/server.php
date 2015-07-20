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
 * @license    http://www.restya.com/ Restya Licence
 * @link       http://www.restya.com
 */
require_once ('config.inc.php');
require_once ('libs/vendors/OAuth2/Autoloader.php');
OAuth2\Autoloader::register();
$oauth_config = array(
    'user_table' => 'users'
);
$storage = new OAuth2\Storage\Pdo(array(
    'dsn' => 'pgsql:host=' . R_DB_HOST . ';dbname=' . R_DB_NAME . ';port=' . R_DB_PORT,
    'username' => R_DB_USER,
    'password' => R_DB_PASSWORD
) , $oauth_config);
$server = new OAuth2\Server($storage);
if (isset($_POST['grant_type']) && $_POST['grant_type'] == 'password') {
    $users = array(
        $_POST['username'] => array(
            'password' => $_POST['password']
        )
    );
    $storage = new OAuth2\Storage\Memory(array(
        'user_credentials' => $users
    ));
    $server->addGrantType(new OAuth2\GrantType\UserCredentials($storage));
} elseif (isset($_POST['grant_type']) && $_POST['grant_type'] == 'refresh_token') {
    $server->addGrantType(new OAuth2\GrantType\RefreshToken($storage));
} else {
    $clients = array(
        OAUTH_CLIENTID => array(
            'client_secret' => OAUTH_CLIENT_SECRET
        )
    );
    $storage = new OAuth2\Storage\Memory(array(
        'client_credentials' => $clients
    ));
    $server->addGrantType(new OAuth2\GrantType\ClientCredentials($storage));
}
