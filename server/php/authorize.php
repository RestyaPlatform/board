<?php
/**
 * Authorization
 *
 * PHP version 5
 *
 * @category   PHP
 * @package    Restyaboard
 * @subpackage Core
 * @author     Restya <info@restya.com>
 * @copyright  2014-2016 Restya
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
$request = OAuth2\Request::createFromGlobals();
$response = new OAuth2\Response();
if (!$server->validateAuthorizeRequest($request, $response)) {
    $response->send();
    die;
}
// display an authorization form
if (empty($_POST)) {
    exit('
<form method="post">
  <label>Do You Authorize TestClient?</label><br />
  <input type="submit" name="authorized" value="yes">
  <input type="submit" name="authorized" value="no">
</form>');
}
// print the authorization code if the user has authorized your client
$is_authorized = ($_POST['authorized'] === 'yes');
$server->handleAuthorizeRequest($request, $response, $is_authorized);
if ($is_authorized) {
    // this is only here so that you get to see your code in the cURL request. Otherwise, we'd redirect back to the client
    $code = substr($response->getHttpHeader('Location') , strpos($response->getHttpHeader('Location') , 'code=') + 5, 40);
    exit("SUCCESS! Authorization Code: $code");
}
$response->send();
