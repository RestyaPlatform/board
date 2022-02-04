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
 * @copyright  2014-2022 Restya
 * @license    http://restya.com/ Restya Licence
 * @link       http://restya.com/
 */
session_start();
require_once 'config.inc.php';
require_once 'libs/core.php';
require_once 'libs/vendors/OAuth2/Autoloader.php';
if (file_exists(SITE_URL_FOR_SHELL)) {
    include_once SITE_URL_FOR_SHELL;
}
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
$val_arr = array(
    $_GET['client_id'],
);
$oauth_client = executeQuery('SELECT client_name FROM oauth_clients WHERE client_id = $1', $val_arr);
$error_msg = 0;
if (!empty($_POST['email']) && !empty($_POST['password'])) {
    $val_arr = array(
        $_POST['email']
    );
    $log_user = executeQuery('SELECT id, role_id, password, is_ldap::boolean::int FROM users WHERE email = $1 or username = $1', $val_arr);
    if (is_plugin_enabled('r_ldap_login')) {
        require_once PLUGIN_PATH . DS . 'LdapLogin' . DS . 'functions.php';
        $ldap_response = ldapUpdateUser($log_user, $_POST);
        $ldap_error = $ldap_response['ldap_error'];
        $user = $ldap_response['user'];
    }
    if (!empty($log_user) && $log_user['is_ldap'] == 0) {
        $_POST['password'] = crypt($_POST['password'], $log_user['password']);
        $val_arr = array(
            $_POST['email'],
            $_POST['password'],
            1
        );
        $user = executeQuery('SELECT * FROM users_listing WHERE (email = $1 or username = $1) AND password = $2 AND is_active = $3', $val_arr);
    }
    if (!empty($user)) {
        $_SESSION["username"] = $user['username'];
        $error_msg = 0;
    } else {
        unset($_POST['password']);
        $error_msg = "Sorry, login failed. Either your username or password are incorrect.";
    }
} else {
    $error_msg = "1";
}
?>
<!DOCTYPE html>
<html class="no-js" lang="en">
 <head>
	 <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	 <link rel="stylesheet" type="text/css" href="/css/authorize.css">
	<!-- build:js /js/authorize.cache.js -->
	<script src="/js/libs/jquery-1.8.3.js"></script>
	<script src="/js/libs/bootstrap-alert.js"></script>
	<script src="/js/libs/jquery.bootstrap-growl.js"></script>
	<!-- endbuild -->
 </head>
 <body style="cursor: auto">
	 <div class="navbar-btn"></div>
	 <script>
	 function flashMesssage(type, message) {
        $.bootstrapGrowl(message, {
            type: type,
            offset: {
                from: 'top',
                amount: 20
            },
            align: 'right',
            width: type == 'danger' ? 250 : 400,
            delay: type == 'danger' ? 4000 : 0,
            allow_dismiss: true,
            stackup_spacing: 10
        });
    }
	 </script>
<?php
// display an authorization form
if (!empty($error_msg) && (empty($_POST['authorized']) || (!empty($_POST['authorized']) && $_POST['authorized'] === 'Deny'))) {
    if (is_plugin_enabled('r_ldap_login')) {
        $loginPlaceholder = 'LDAP Login';
    } else {
        $loginPlaceholder = 'Email or Username';
    } ?>
	<section class="clearfix">
	  <div class="col-md-4 col-md-offset-4">
		<div class="text-center navbar-btn"><a title="Restya" href="#/"><img title="<?php
    echo SITE_NAME; ?>" alt="[Image: <?php
    echo SITE_NAME; ?>]" src="<?php
    echo $_server_domain_url . '/img/logo.png'; ?>"></a></div>
			<div class="well">
				<div class="panel panel-default">
					<div class="panel-heading lead">Login</div>
					<div class="panel-body well-lg">
						<form class="form-horizontal clearfix col-xs-12" method="post" role="form" name="UserLoginForm" id="UserLoginForm">
							<div class="form-group">
							  <label for="inputEmail" class="sr-only control-label"><?php
    echo __l('Email or Username') ?></label>
							  <input type="text" placeholder="<?php
    echo $loginPlaceholder; ?>" class="form-control authorize_ldap" id="inputEmail" name="email"  value="<?php
    echo !empty($_POST['email']) ? $_POST['email'] : (!empty($_GET['u']) ? $_GET['u'] : ''); ?>" title="" required/>
							</div>
							<div class="form-group">
							  <label for="inputPassword" class="sr-only control-label"><?php
    echo __l('Password') ?></label>
							  <input type="password" placeholder="Password" class="form-control" id="inputPassword" name="password" title="Password" required/>
							</div>
							<div class="form-group">
							  <label for="submit2" class="sr-only control-label">Login</label>
							  <input type="submit" class="btn btn-primary col-xs-12" value="Login" id="submitLogin" />
							</div>
							<?php
    if (!empty($error_msg) && $error_msg != 1) {
?>
								<div><script>flashMesssage('danger', <?php
        echo __l('Sorry, login failed. Either your username or password are incorrect.') ?>);</script></div>
							<?php
    } ?>
						</form>
					</div>
				</div>
			</div>			
		</div>
	 </section>
<?php
} else {
    if (empty($_POST['authorized'])) {
?>
            <section class="clearfix">
			  <div class="col-md-4 col-md-offset-4">
				<div class="text-center navbar-btn"><a title="Restya" href="#/"><img title="<?php
        echo SITE_NAME; ?>" alt="[Image: <?php
        echo SITE_NAME; ?>]" src="<?php
        echo $_server_domain_url . '/img/logo.png'; ?>"></a></div>
				<div class="well">
				  <div class="text-center">
					<div class="h2 list-group-item-heading"> <?php
        echo sprintf(__l('Let %s use your account?') , '<strong>' . $oauth_client['client_name'] . ' application</strong> '); ?></div>
					<form method="post">
					<ul class="list-inline h2">
					  <li><input type="submit" value="Allow" name="authorized" class="btn btn-primary btn-lg" title="Allow" /></li>
					  <li><input type="submit" value="Deny" name="authorized" class="btn btn-default btn-lg" title="Deny" /></li>
					</ul>
					</form>
				  </div>
				  <hr>
				  <p><?php
        echo sprintf(__l('You are logged in as %s The app will be able to use your account until you disable it.') , '<strong>' . $user['full_name'] . ' (' . $user['username'] . ')</strong>') ?></p>
				  <hr>
				  <div class="clearfix"> <strong><?php
        echo __l('The app will be able to') ?>:</strong>
					<ul>
					  <li><?php
        echo __l(' Read all of your boards and organizations') ?></li>
					  <li><?php
        echo __l('Create and update cards, lists and boards ') ?></li>
					  <li><?php
        echo __l('Make comments for you ') ?></li>
					  <li><?php
        echo __l('Read your email address') ?></li>
					</ul>
					<strong><?php
        echo __l("It won't be able to") ?>:</strong>
					<ul>
					  <li><?php
        echo sprintf(__l('See your %s password') , SITE_NAME) ?></li>
					</ul>
				  </div>
				</div>
			  </div>
		    </section>
<?php
    } else {
        // print the authorization code if the user has authorized your client
        $is_authorized = ($_POST['authorized'] === 'Allow') ? true : false;
        $server->handleAuthorizeRequest($request, $response, $is_authorized, $_SESSION["username"]);
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