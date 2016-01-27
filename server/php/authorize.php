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
require_once 'libs/core.php';
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
?>
<!DOCTYPE html>
<html class="no-js" lang="en">
 <head>
	 <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	 <link rel="stylesheet" type="text/css" href="../client/css/bootstrap.css">
 </head>
 <body style="cursor: auto">
	 <div class="navbar-btn"></div>
<?php
// display an authorization form
if (empty($_POST)) {
    if (LDAP_LOGIN_ENABLED) {
        $loginPlaceholder = 'LDAP Login';
    } else {
        $loginPlaceholder = 'Email or Username';
    } ?>
	<section class="clearfix">
	  <div class="col-md-5 col-md-offset-4">
		<div class="text-center navbar-btn"><a title="Restya" href="#/"><img title="<?php
    echo SITE_NAME; ?>" alt="[Image: <?php
    echo SITE_NAME; ?>]" src="../client/img/logo.png"></a></div>
			<div class="well">
				<div class="panel panel-default">
					<div class="panel-heading lead">Login</div>
					<div class="panel-body well-lg">
						<form class="form-horizontal clearfix col-xs-12" method="post" role="form" name="UserLoginForm" id="UserLoginForm">
							<div class="form-group">
							  <label for="inputEmail" class="sr-only control-label">Email or Username</label>
							  <input type="text" placeholder="<?php
    echo $loginPlaceholder; ?>" class="form-control" id="inputEmail" name="email"  title="<?php
    echo $loginPlaceholder; ?>" required/>
							</div>
							<div class="form-group">
							  <label for="inputPassword" class="sr-only control-label">Password</label>
							  <input type="password" placeholder="Password" class="form-control" id="inputPassword" name="password" title="Password" required/>
							</div>
							<div class="form-group">
							  <label for="submit2" class="sr-only control-label">Login</label>
							  <input type="submit" class="btn btn-primary col-xs-12" value="Login" id="submitLogin" />
							</div>
						</form>
					</div>
				</div>
			</div>			
		</div>
	 </section>
<?php
} else {
    if (empty($_POST['authorized'])) {
        $val_arr = array(
            $_POST['email']
        );
        $log_user = executeQuery('SELECT id, role_id, password, is_ldap::boolean::int FROM users WHERE email = $1 or username = $1', $val_arr);
        $_POST['password'] = crypt($_POST['password'], $log_user['password']);
        $val_arr = array(
            $_POST['email'],
            $_POST['password'],
            1
        );
        $user = executeQuery('SELECT * FROM users_listing WHERE (email = $1 or username = $1) AND password = $2 AND is_active = $3', $val_arr);
        if (!empty($user)) { ?>
            <section class="clearfix">
			  <div class="col-md-5 col-md-offset-4">
				<div class="text-center navbar-btn"><a title="Restya" href="#/"><img title="<?php
            echo SITE_NAME; ?>" alt="[Image: <?php
            echo SITE_NAME; ?>]" src="../client/img/logo.png"></a></div>
				<div class="well">
				  <div class="text-center">
					<div class="h2 list-group-item-heading"> Let <strong>Sandbox <?php
            echo SITE_NAME; ?> Application </strong> use your account?</div>
					<form method="post">
					<ul class="list-inline h2">
					  <li><input type="submit" value="Allow" name="authorized" class="btn btn-primary btn-lg" title="Allow" /></li>
					  <li><input type="submit" value="Deny" name="authorized" class="btn btn-default btn-lg" title="Deny" /></li>
					</ul>
					</form>
				  </div>
				  <hr>
				  <p>You are logged in as <strong><?php
            echo $user['full_name'] . ' (' . $user['username'] . ')'; ?></strong> The app will be able to use your account <strong> until you disable it.</strong></p>
				  <hr>
				  <div class="clearfix"> <strong>The app will be able to:</strong>
					<ul>
					  <li> Read all of your boards and teams </li>
					  <li>Create and update cards, lists and boards </li>
					  <li>Make comments for you </li>
					  <li>Read your email address </li>
					</ul>
					<strong>It won't be able to:</strong>
					<ul>
					  <li>see your <?php
            echo SITE_NAME; ?> password </li>
					</ul>
				  </div>
				</div>
			  </div>
		    </section>
<?php
        } else {
            $_POST = array();
            header('Location: ' . $_SERVER['REQUEST_URI']);
            exit;
        }
    } else {
        // print the authorization code if the user has authorized your client
        $is_authorized = ($_POST['authorized'] === 'Allow') ? true : false;
        $server->handleAuthorizeRequest($request, $response, $is_authorized);
        if ($is_authorized) {
            // this is only here so that you get to see your code in the cURL request. Otherwise, we'd redirect back to the client
            header('Location: ' . $response->getHttpHeader('Location'));
            exit;
        }
        $response->send();
    }
} ?>
 </body>
</html>