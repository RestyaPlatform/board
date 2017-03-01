<?php
/**
 * Main function to start
 *
 * @return string
 */
require_once 'config.inc.php';
require_once 'libs' . DIRECTORY_SEPARATOR . 'core.php';
require_once __DIR__ . '/Slim/vendor/autoload.php';
require_once 'libs' . DIRECTORY_SEPARATOR . 'database.php';
require_once 'libs' . DIRECTORY_SEPARATOR . 'auth.php';
require_once 'libs/vendors/finediff.php';
require_once 'libs' . DIRECTORY_SEPARATOR . 'vendors' . DIRECTORY_SEPARATOR . 'OAuth2' . DIRECTORY_SEPARATOR . 'Autoloader.php';
$config = array('settings' => array('displayErrorDetails' => R_DEBUG));
global $app;
$app = new Slim\App($config);
$app->add(new \pavlakis\cli\CliRequest());
$app->add(new Auth());
require_once 'libs' . DIRECTORY_SEPARATOR . 'dependencies.php';
$dirs = APP_PATH . DIRECTORY_SEPARATOR . 'server' . DIRECTORY_SEPARATOR . 'php' . DIRECTORY_SEPARATOR . 'plugins' ; 
$plugins = glob($dirs . '/*', GLOB_ONLYDIR);
foreach($plugins as $plugin){
    $plugin_name = str_ireplace($dirs. DIRECTORY_SEPARATOR, '', $plugin);
    require_once __DIR__ . '/plugins/' . $plugin_name . '/Slim/index.php';
}
function main()
{
    global $r_debug, $authUser, $token, $localAccessIps, $db_lnk, $token_exception_url, $exception_url, $scope_exception_url, $post_exception_url, $put_exception_url, $exception_before_token, $exception_url, $admin_access_url, $put_admin_access_url, $_server_domain_url;
    $exception_url = array(
        '/users/forgotpassword',
        '/users/register',
        '/users/login',
        '/users/?/activation',
        '/settings',
        '/boards/?',
        '/oauth/token'
    );
    $scope_exception_url = array(
        '/users/login',
        '/users/register',
        '/oauth/token',
        '/users/?/activation',
        '/users/forgotpassword'
    );
    $token_exception_url = array(
        '/settings',
        '/oauth/token'
    );
    if (PHP_SAPI == 'cli') { // if command line mode...
        if ($_SERVER['argc'] < 2) {
            echo 'Usage: php ' . __FILE__ . ' <relative url>' . "\n";
            exit(1);
        }
        $argv = explode('?', urldecode($_SERVER['argv'][1])); // override '_url'
        $_GET['_url'] = $argv[0];
        if (!empty($argv[1])) {
            $cli_params = explode('&', $argv[1]);
            foreach ($cli_params as $key => $value) {
                $final_params = explode('=', $value);
                $_GET[$final_params[0]] = $final_params[1];
            }
        }
        $_SERVER['REQUEST_METHOD'] = 'GET';
    }
    if (!empty($_GET['_url']) && $db_lnk) {
        header('Content-Type: application/json');
        if (!defined('STDIN') && !file_exists(APP_PATH . '/tmp/cache/client.php') && !empty($_server_domain_url)) {
            doPost('http://restya.com/clients', array(
                'app' => 'board',
                'ver' => '0.4.2',
                'url' => $_server_domain_url
            ));
            $fh = fopen(APP_PATH . '/tmp/cache/client.php', 'a');
            fwrite($fh, '<?php' . "\n");
            fwrite($fh, '$_server_domain_url = \'' . $_server_domain_url . '\';');
            fclose($fh);
        }
    } else {
        header($_SERVER['SERVER_PROTOCOL'] . ' 404 Not Found', true, 404);
    }
    if (R_DEBUG) {
        if (!headers_sent()) {
            header('X-RDebug: ' . $r_debug);
        }
    }
}
