<?php
/**
 * Main function to start
 *
 * @return string
 */
require_once 'config.inc.php';
require_once 'libs' . DS . 'core.php';
require_once 'libs' . DS . 'vendors' . DS . 'OAuth2' . DS . 'Autoloader.php';
function main()
{
    global $r_debug, $authUser, $token, $localAccessIps, $db_lnk, $token_exception_url, $exception_url, $scope_exception_url, $post_exception_url, $put_exception_url, $exception_before_token, $exception_url, $admin_access_url, $put_admin_access_url, $_server_domain_url, $locales;
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
        $r_debug.= __LINE__ . ': ' . $_GET['_url'] . "\n";
        $url = '/' . $_GET['_url'];
        $url = str_replace('/v' . R_API_VERSION, '', $url);
        // routes...
        // Samples: 1. /products.json
        //          2. /products.json?page=1&key1=val1
        //          3. /users/5/products/10.json
        //          4. /products/10.json
        $_url_parts_with_querystring = explode('?', $url);
        $_url_parts_with_ext = explode('.', $_url_parts_with_querystring[0]);
        $r_resource_type = @$_url_parts_with_ext[1]; // 'json'
        $r_resource_filters = $_GET;
        unset($r_resource_filters['_url']); // page=1&key1=val1
        // /users/5/products/10 -> /users/?/products/? ...
        $r_resource_cmd = preg_replace('/\/\d+/', '/?', $_url_parts_with_ext[0]);
        header('Content-Type: application/json');
        if (!defined('STDIN') && !file_exists(CLIENT_INFORMATION) && !empty($_server_domain_url)) {
            $fh = fopen(CLIENT_INFORMATION, 'a');
            fwrite($fh, '<?php' . "\n");
            fwrite($fh, '$_server_domain_url = \'' . $_server_domain_url . '\';');
            fclose($fh);
        }
        $current_locale = DEFAULT_LANGUAGE;
        if ($r_resource_cmd != '/users/login') {
            if (!empty($_GET['token'])) {
                $conditions = array(
                    'access_token' => $_GET['token']
                );
                $response = executeQuery("SELECT user_id as username, expires, scope, client_id FROM oauth_access_tokens WHERE access_token = $1", $conditions);
                $expires = strtotime($response['expires']);
                $clientresponse = executeQuery("SELECT is_expirable_token FROM oauth_clients WHERE client_id = $1", array(
                    'client_id' => OAUTH_CLIENTID
                ));
                if (empty($response) || !empty($response['error']) || ($expires > 0 && $expires < time() && $clientresponse['is_expirable_token'] === 1)) {
                    $response['error']['type'] = 'OAuth';
                    header($_SERVER['SERVER_PROTOCOL'] . ' 401 Unauthorized', true, 401);
                    exit;
                }
                $user = $role_links = array();
                if (!empty($response['username'])) {
                    $qry_val_arr = array(
                        $response['username']
                    );
                    $user = executeQuery('SELECT * FROM users WHERE username = $1', $qry_val_arr);
                    $qry_val_arr = array(
                        $user['role_id']
                    );
                    $role_links = executeQuery('SELECT * FROM role_links_listing WHERE id = $1', $qry_val_arr);
                }
                $authUser = array_merge($role_links, $user);
                if (!empty($user['language'])) {
                    $current_locale = $user['language'];
                }
            }
        }
        if (!empty($current_locale) && file_exists(APP_PATH . 'client' . DS . 'locales' . DS . $current_locale . DS . 'translation.json')) {
            $locale = file_get_contents(APP_PATH . 'client' . DS . 'locales' . DS . $current_locale . DS . 'translation.json');
            $locales = json_decode($locale, true);
        }
        $r_resource_vars = array();
        if (preg_match_all('/([^\/]+)\/(\d+)/', $_url_parts_with_ext[0], $matches)) {
            for ($i = 0, $len = count($matches[0]); $i < $len; ++$i) {
                $r_resource_vars[$matches[1][$i]] = $matches[2][$i];
            }
        }
        $post_data = array();
        if ($_SERVER['REQUEST_METHOD'] == 'PUT') {
            $r_put = json_decode(file_get_contents('php://input'));
            $post_data = $r_put = (array)$r_put;
        }
        if (in_array($r_resource_cmd, $token_exception_url) || checkAclLinks($_SERVER['REQUEST_METHOD'], $r_resource_cmd, $r_resource_vars, $post_data)) {
            // /users/5/products/10 -> array('users' => 5, 'products' => 10) ...
            $scope = array();
            if (!empty($response['scope'])) {
                $scope = explode(" ", $response['scope']);
            }
            if ($r_resource_type == 'json') {
                $is_valid_req = false;
                // Server...
                switch ($_SERVER['REQUEST_METHOD']) {
                case 'GET':
                    if ((in_array('read', $scope) || $r_resource_cmd == '/oauth' || $r_resource_cmd == '/users/logout') || in_array($r_resource_cmd, $scope_exception_url)) {
                        r_get($r_resource_cmd, $r_resource_vars, $r_resource_filters);
                        $is_valid_req = true;
                    } else {
                        header($_SERVER['SERVER_PROTOCOL'] . ' 401 Authentication failed', true, 401);
                    }
                    break;

                case 'POST':
                    if ((in_array('write', $scope) && ((!empty($authUser)) || (in_array($r_resource_cmd, $exception_url) && empty($authUser))) || (is_plugin_enabled('r_support_app') && ($r_resource_cmd == '/card_support_users' || !empty($r_resource_vars['boards'])))) || in_array($r_resource_cmd, $scope_exception_url)) {
                        $r_post = json_decode(file_get_contents('php://input'));
                        $r_post = (array)$r_post;
                        r_post($r_resource_cmd, $r_resource_vars, $r_resource_filters, $r_post);
                        $is_valid_req = true;
                    } else {
                        header($_SERVER['SERVER_PROTOCOL'] . ' 401 Authentication failed', true, 401);
                    }
                    break;

                case 'PUT':
                    if ((in_array('write', $scope) && ((!empty($authUser)) || (in_array($r_resource_cmd, $exception_url) && empty($authUser)))) || in_array($r_resource_cmd, $scope_exception_url)) {
                        r_put($r_resource_cmd, $r_resource_vars, $r_resource_filters, $r_put);
                        $is_valid_req = true;
                    } else {
                        header($_SERVER['SERVER_PROTOCOL'] . ' 401 Authentication failed', true, 401);
                    }
                    break;

                case 'DELETE':
                    if ((in_array('write', $scope) && ((!empty($authUser)) || (in_array($r_resource_cmd, $exception_url) && empty($authUser)))) || in_array($r_resource_cmd, $scope_exception_url)) {
                        r_delete($r_resource_cmd, $r_resource_vars, $r_resource_filters);
                        $is_valid_req = true;
                    } else {
                        header($_SERVER['SERVER_PROTOCOL'] . ' 401 Authentication failed', true, 401);
                    }
                    break;

                default:
                    header($_SERVER['SERVER_PROTOCOL'] . ' 501 Not Implemented', true, 501);
                    break;
                }
            }
        } else {
            if ($r_resource_cmd == '/boards/?/lists/?/cards') {
                $response = array(
                    'error' => 1
                );
                echo json_encode($response);
                exit;
            }
            header($_SERVER['SERVER_PROTOCOL'] . ' 401 Authentication failed', true, 401);
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
