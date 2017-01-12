<?php
/**
 * Main function to start
 *
 * @return string
 */
require_once 'config.inc.php';
require_once 'libs' . DIRECTORY_SEPARATOR . 'core.php';
require_once 'libs' . DIRECTORY_SEPARATOR . 'vendors' . DIRECTORY_SEPARATOR . 'OAuth2' . DIRECTORY_SEPARATOR . 'Autoloader.php';
function main()
{
    global $r_debug, $authUser, $token, $localAccessIps, $db_lnk, $token_exception_url, $exception_url, $scope_exception_url;
    global $post_exception_url, $put_exception_url, $exception_before_token, $exception_url, $admin_access_url, $put_admin_access_url;
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
        if (!defined('STDIN') && !file_exists(APP_PATH . '/tmp/cache/client.php') && !empty($_server_domain_url)) {
            doPost('http://restya.com/clients', array(
                'app' => 'board',
                'ver' => '0.3',
                'url' => $_server_domain_url
            ));
            $fh = fopen(APP_PATH . '/tmp/cache/client.php', 'a');
            fwrite($fh, '<?php' . "\n");
            fwrite($fh, '$_server_domain_url = \'' . $_server_domain_url . '\';');
            fclose($fh);
        }
        if ($r_resource_cmd != '/users/login') {
            if (!empty($_GET['token'])) {
                $conditions = array(
                    'access_token' => $_GET['token']
                );
                $response = executeQuery("SELECT user_id as username, expires, scope, client_id FROM oauth_access_tokens WHERE access_token = $1", $conditions);
                $expires = strtotime($response['expires']);
                if (empty($response) || !empty($response['error']) || ($response['client_id'] != 6664115227792148 && $response['client_id'] != OAUTH_CLIENTID) || ($expires > 0 && $expires < time() && $response['client_id'] != 7857596005287233 && $response['client_id'] != 1193674816623028)) {
                    $response['error']['type'] = 'OAuth';
                    echo json_encode($response);
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
            } else if (!empty($_GET['refresh_token'])) {
                $oauth_clientid = OAUTH_CLIENTID;
                $oauth_client_secret = OAUTH_CLIENT_SECRET;
                $conditions = array(
                    'access_token' => $_GET['refresh_token']
                );
                $response = executeQuery("SELECT user_id as username, expires, scope, client_id FROM oauth_refresh_tokens WHERE refresh_token = $1", $conditions);
                if ($response['client_id'] == 6664115227792148 && OAUTH_CLIENTID == 7742632501382313) {
                    $oauth_clientid = 6664115227792148;
                    $oauth_client_secret = 'hw3wpe2cfsxxygogwue47cwnf7';
                }
                $post_val = array(
                    'grant_type' => 'refresh_token',
                    'refresh_token' => $_GET['refresh_token'],
                    'client_id' => $oauth_clientid,
                    'client_secret' => $oauth_client_secret
                );
                $response = getToken($post_val);
                echo json_encode($response);
                exit;
            } else if (!in_array($r_resource_cmd, $token_exception_url)) {
                $post_val = array(
                    'grant_type' => 'client_credentials',
                    'client_id' => OAUTH_CLIENTID,
                    'client_secret' => OAUTH_CLIENT_SECRET
                );
                $response = getToken($post_val);
                $qry_val_arr = array(
                    3
                );
                $role_links = executeQuery('SELECT * FROM role_links_listing WHERE id = $1', $qry_val_arr);
                $response = array_merge($response, $role_links);
                $files = glob(APP_PATH . '/client/locales/*/translation.json', GLOB_BRACE);
                $lang_iso2_codes = array();
                foreach ($files as $file) {
                    $folder = explode('/', $file);
                    $folder_iso2_code = $folder[count($folder) - 2];
                    array_push($lang_iso2_codes, $folder_iso2_code);
                }
                $qry_val_arr = array(
                    '{' . implode($lang_iso2_codes, ',') . '}'
                );
                $result = pg_query_params($db_lnk, 'SELECT name, iso2 FROM languages WHERE iso2 = ANY ( $1 ) ORDER BY name ASC', $qry_val_arr);
                while ($row = pg_fetch_assoc($result)) {
                    $languages[$row['iso2']] = $row['name'];
                }
                $response['languages'] = json_encode($languages);
                $files = glob(APP_PATH . '/client/apps/*/app.json', GLOB_BRACE);
                if (!empty($files)) {
                    foreach ($files as $file) {
                        $content = file_get_contents($file);
                        $data = json_decode($content, true);
                        $folder = explode('/', $file);
                        if ($data['enabled'] === true) {
                            foreach ($data as $key => $value) {
                                if ($key != 'settings') {
                                    $response['apps'][$folder[count($folder) - 2]][$key] = $value;
                                }
                            }
                        }
                    }
                }
                $response['apps'] = !empty($response['apps']) ? json_encode($response['apps']) : '';
                echo json_encode($response);
                exit;
            }
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
        if ($r_resource_cmd == '/users/logout' || $r_resource_cmd == '/users/register' || checkAclLinks($_SERVER['REQUEST_METHOD'], $r_resource_cmd, $r_resource_vars, $post_data)) {
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
                    if (in_array('read', $scope)) {
                        r_get($r_resource_cmd, $r_resource_vars, $r_resource_filters);
                        $is_valid_req = true;
                    } else {
                        header($_SERVER['SERVER_PROTOCOL'] . ' 401 Authentication failed', true, 401);
                    }
                    break;

                case 'POST':
                    if ((in_array('write', $scope) && ((!empty($authUser)) || (in_array($r_resource_cmd, $exception_url) && empty($authUser)))) || in_array($r_resource_cmd, $scope_exception_url)) {
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
