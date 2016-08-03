<?php
/**
 * Common functions
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
/**
 * Returns an OAuth2 access token to the client
 *
 * @param array $post Post data
 *
 * @return mixed
 */
function getToken($post)
{
    $old_server_method = $_SERVER['REQUEST_METHOD'];
    if (!empty($_SERVER['CONTENT_TYPE'])) {
        $old_content_type = $_SERVER['CONTENT_TYPE'];
    }
    $_SERVER['REQUEST_METHOD'] = 'POST';
    $_SERVER['CONTENT_TYPE'] = 'application/x-www-form-urlencoded';
    $_POST = $post;
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
        $always_issue_new_refresh_token = array(
            'always_issue_new_refresh_token' => true
        );
        $server->addGrantType(new OAuth2\GrantType\RefreshToken($storage, $always_issue_new_refresh_token));
    } elseif (isset($_POST['grant_type']) && $_POST['grant_type'] == 'authorization_code') {
        $server->addGrantType(new OAuth2\GrantType\AuthorizationCode($storage));
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
    $response = $server->handleTokenRequest(OAuth2\Request::createFromGlobals())->send('return');
    $_SERVER['REQUEST_METHOD'] = $old_server_method;
    if (!empty($old_content_type)) {
        $_SERVER['CONTENT_TYPE'] = $old_content_type;
    }
    return json_decode($response, true);
}
/**
 * To generate random string
 *
 * @param array  $arr_characters Random string options
 * @param string $length         Length of the random string
 *
 * @return string
 */
function getRandomStr($arr_characters, $length)
{
    $rand_str = '';
    $characters_length = count($arr_characters);
    for ($i = 0; $i < $length; ++$i) {
        $rand_str.= $arr_characters[rand(0, $characters_length - 1) ];
    }
    return $rand_str;
}
/**
 * To generate the encrypted password
 *
 * @param string $str String to be encrypted
 *
 * @return string
 */
function getCryptHash($str)
{
    $salt = '';
    if (CRYPT_BLOWFISH) {
        if (version_compare(PHP_VERSION, '5.3.7') >= 0) { // http://www.php.net/security/crypt_blowfish.php
            $algo_selector = '$2y$';
        } else {
            $algo_selector = '$2a$';
        }
        $workload_factor = '12$'; // (around 300ms on Core i7 machine)
        $val_arr = array(
            '.',
            '/'
        );
        $range1 = range('0', '9');
        $range2 = range('a', 'z');
        $range3 = range('A', 'Z');
        $res_arr = array_merge($val_arr, $range1, $range2, $range3);
        $salt = $algo_selector . $workload_factor . getRandomStr($res_arr, 22); // './0-9A-Za-z'
        
    } else if (CRYPT_MD5) {
        $algo_selector = '$1$';
        $char1 = chr(33);
        $char2 = chr(127);
        $range = range($char1, $char2);
        $salt = $algo_selector . getRandomStr($range, 12); // actually chr(0) - chr(255), but used ASCII only
        
    } else if (CRYPT_SHA512) {
        $algo_selector = '$6$';
        $workload_factor = 'rounds=5000$';
        $char1 = chr(33);
        $char2 = chr(127);
        $range = range($char1, $char2);
        $salt = $algo_selector . $workload_factor . getRandomStr($range, 16); // actually chr(0) - chr(255), but used ASCII only
        
    } else if (CRYPT_SHA256) {
        $algo_selector = '$5$';
        $workload_factor = 'rounds=5000$';
        $char1 = chr(33);
        $char2 = chr(127);
        $range = range($char1, $char2);
        $salt = $algo_selector . $workload_factor . getRandomStr($range, 16); // actually chr(0) - chr(255), but used ASCII only
        
    } else if (CRYPT_EXT_DES) {
        $algo_selector = '_';
        $val_arr = array(
            '.',
            '/'
        );
        $range1 = range('0', '9');
        $range2 = range('a', 'z');
        $range3 = range('A', 'Z');
        $res_arr = array_merge($val_arr, $range1, $range2, $range3);
        $salt = $algo_selector . getRandomStr($res_arr, 8); // './0-9A-Za-z'.
        
    } else if (CRYPT_STD_DES) {
        $algo_selector = '';
        $val_arr = array(
            '.',
            '/'
        );
        $range1 = range('0', '9');
        $range2 = range('a', 'z');
        $range3 = range('A', 'Z');
        $res_arr = array_merge($val_arr, $range1, $range2, $range3);
        $salt = $algo_selector . getRandomStr($res_arr, 2); // './0-9A-Za-z'
        
    }
    return crypt($str, $salt);
}
/**
 * Execute CURL Request
 *
 * @param string $url    URL
 * @param string $method optional Method of CURL default value : get
 * @param mixed  $post   optional CURL Values default value : array ()
 * @param string $format optional Format for values default value : plain
 *
 * @return mixed
 */
function curlExecute($url, $method = 'get', $post = array() , $format = 'plain')
{
    $filename = $return = $error = array();
    $mediadir = '';
    if ($format == 'image') {
        $mediadir = $post;
        if (!file_exists($mediadir)) {
            mkdir($mediadir, 0777, true);
        }
        $path = explode('/', $url);
        $filename['file_name'] = $path[count($path) - 1];
    }
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
    curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
    curl_setopt($ch, CURLOPT_USERAGENT, $_SERVER['HTTP_USER_AGENT']);
    if ($format != 'image') {
        curl_setopt($ch, CURLOPT_TIMEOUT, 300); // 300 seconds (5min)
        
    }
    if ($method == 'get') {
        curl_setopt($ch, CURLOPT_POST, false);
        if ($format == 'image') {
            curl_setopt($ch, CURLOPT_BINARYTRANSFER, true);
            curl_setopt($ch, CURLOPT_HEADER, false);
        }
    } elseif ($method == 'post') {
        if ($format == 'json') {
            $post_string = json_encode($post);
            $curl_opt = array(
                'Content-Type: application/json',
                'Content-Length: ' . strlen($post_string)
            );
            curl_setopt($ch, CURLOPT_HTTPHEADER, $curl_opt);
        } else {
            $post_string = http_build_query($post, '', '&');
        }
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $post_string);
    }
    $response = curl_exec($ch);
    if ($format == 'token') {
        return $response;
    }
    if ($format == 'image') {
        $info = curl_getinfo($ch);
        array_change_key_case($info);
        $content_type = explode('/', $info['content_type']);
        $extension = explode(';', $content_type[1]);
        $filename['extension'] = $extension[0];
        $filename['file_name'] = (strpos($filename['file_name'], '.') !== false) ? $filename['file_name'] : $filename['file_name'] . '.' . $content_type[1];
        $filename['file_name'] = preg_replace('/[^A-Za-z0-9\-.]/', '', $filename['file_name']);
        curl_close($ch);
        if (file_exists($mediadir . DIRECTORY_SEPARATOR . $filename['file_name'])) {
            unlink($mediadir . DIRECTORY_SEPARATOR . $filename['file_name']);
        }
        $fp = fopen($mediadir . DIRECTORY_SEPARATOR . $filename['file_name'], 'x');
        fwrite($fp, $response);
        fclose($fp);
        return $filename;
    }
    $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    if (curl_errno($ch)) {
        $return['error']['message'] = curl_error($ch);
        curl_close($ch);
        return $return;
    }
    switch ($http_code) {
    case 201:
    case 200:
        $return = json_decode($response, true);
        if ($return === null) {
            $error['error']['code'] = 1;
            $error['error']['message'] = 'Syntax error, malformed JSON';
            $return = $error;
        }
        break;

    case 401:
        $return['error']['code'] = 1;
        $return['error']['message'] = 'Unauthorized';
        break;

    default:
        $return['error']['code'] = 1;
        $return['error']['message'] = 'Not Found';
    }
    curl_close($ch);
    return $return;
}
/**
 * Post url by using CURL
 *
 * @param string $url    URL
 * @param array  $post   (optional) default value : array ()
 * @param string $format (optional) default value : plain
 *
 * @return mixed
 */
function doPost($url, $post = array() , $format = 'plain')
{
    return curlExecute($url, 'post', $post, $format);
}
/**
 * Get url by using CURL
 *
 * @param string $url URL
 *
 * @return mixed
 */
function doGet($url)
{
    $return = curlExecute($url);
    return $return;
}
/**
 * Record each activities
 *
 * @param integer $user_id     UserID
 * @param string  $comment     Comment to insert
 * @param string  $type        Type of the comment
 * @param array   $foreign_ids Optional default value : array ()
 * @param mixed   $revision    Optional default value : null
 * @param integer $foreign_id  Optional default value : null
 *
 * @return mixed
 */
function insertActivity($user_id, $comment, $type, $foreign_ids = array() , $revision = null, $foreign_id = null)
{
    global $r_debug, $db_lnk;
    $result = '';
    $fields = array(
        'created',
        'modified',
        'user_id',
        'comment',
        'type',
        'revisions'
    );
    $values = array(
        'now()',
        'now()',
        $user_id,
        $comment,
        $type,
        $revision
    );
    if ($foreign_id !== null) {
        array_push($fields, 'foreign_id');
        array_push($values, $foreign_id);
    }
    foreach ($foreign_ids as $key => $value) {
        if ($key != 'id' && $key != 'user_id') {
            array_push($fields, $key);
            if ($value === false) {
                array_push($values, 'false');
            } else {
                array_push($values, $value);
            }
        }
    }
    if (!empty($foreign_ids['board_id']) || !empty($foreign_ids['organization_id']) || !empty($foreign_ids['user_id'])) {
        $val = '';
        for ($i = 1, $len = count($values); $i <= $len; $i++) {
            $val.= '$' . $i;
            $val.= ($i != $len) ? ', ' : '';
        }
        $result = pg_query_params($db_lnk, 'INSERT INTO activities (' . implode(', ', $fields) . ') VALUES (' . $val . ') RETURNING *', $values);
    }
    $row = pg_fetch_assoc($result);
    $id_converted = base_convert($row['id'], 10, 36);
    $materialized_path = sprintf("%08s", $id_converted);
    $freshness_ts = date('Y-m-d h:i:s');
    $path = 'P' . $row['id'];
    $depth = 0;
    $qry_val_arr = array(
        $materialized_path,
        $path,
        $depth,
        $freshness_ts,
        $row['id']
    );
    $result = pg_query_params($db_lnk, 'UPDATE activities SET materialized_path = $1, path = $2, depth = $3, freshness_ts = $4 WHERE id = $5 RETURNING *', $qry_val_arr);
    $row = pg_fetch_assoc($result);
    $qry_val_arr = array(
        $row['id']
    );
    $s_row = pg_query_params($db_lnk, 'SELECT * FROM activities_listing WHERE id = $1', $qry_val_arr);
    $row = pg_fetch_assoc($s_row);
    return $row;
}
/**
 * Get difference between current and previous version
 *
 * @param string $from_text Original text
 * @param string $to_text   Changed text
 *
 * @return difference
 */
function getRevisiondifference($from_text, $to_text)
{
    // limit input
    if (!empty($from_text)) {
        $from_text = substr($from_text, 0, 1024 * 100);
    }
    if (!empty($to_text)) {
        $to_text = substr($to_text, 0, 1024 * 100);
    }
    $granularity = 2; // 0: Paragraph/lines, 1: Sentence, 2: Word, 3: Character
    $granularityStacks = array(
        FineDiff::$paragraphGranularity,
        FineDiff::$sentenceGranularity,
        FineDiff::$wordGranularity,
        FineDiff::$characterGranularity
    );
    $diff_opcodes = FineDiff::getDiffOpcodes($from_text, $to_text, $granularityStacks[$granularity]);
    $difference = FineDiff::renderDiffToHTMLFromOpcodes($from_text, $diff_opcodes);
    return $difference;
}
/**
 * LDAP authetication to login
 *
 * @param integer $p_user_id  UserID
 * @param string  $p_password Password
 *
 * @return user
 */
function ldapAuthenticate($p_user_id, $p_password)
{
    $g_enable_ssl_connectivity = ENABLE_SSL_CONNECTIVITY;
    $g_ldap_protocol_version = LDAP_PROTOCOL_VERSION;
    $g_ldap_server = LDAP_SERVER;
    $g_ldap_port = LDAP_PORT;
    $g_ldap_root_dn = LDAP_ROOT_DN;
    $g_ldap_organisation = '';
    $g_ldap_uid_field = LDAP_UID_FIELD;
    $g_ldap_bind_dn = LDAP_BIND_DN; // A system account to login to LDAP
    $g_ldap_bind_passwd = LDAP_BIND_PASSWD; // System account password
    // if password is empty and ldap allows anonymous login, then
    // the user will be able to login, hence, we need to check
    // for this special case.
    if (empty($p_password)) {
        return false;
    }
    $t_ldap_organization = $g_ldap_organisation;
    $t_ldap_root_dn = $g_ldap_root_dn;
    $t_username = $p_user_id;
    $t_ldap_uid_field = $g_ldap_uid_field;
    $t_search_filter = "(&$t_ldap_organization($t_ldap_uid_field=$t_username))";
    $t_search_attrs = array(
        $t_ldap_uid_field,
        'name',
        'mail'
    );
    $t_ldap_server = ($g_enable_ssl_connectivity == 'true') ? 'ldaps://' . $g_ldap_server : 'ldap://' . $g_ldap_server;
    $t_ldap_port = $g_ldap_port;
    $t_ds = @ldap_connect($t_ldap_server, $t_ldap_port);
    if ($t_ds > 0) {
        $t_protocol_version = $g_ldap_protocol_version;
        if ($t_protocol_version > 0) {
            ldap_set_option($t_ds, LDAP_OPT_PROTOCOL_VERSION, $t_protocol_version);
            ldap_set_option($t_ds, LDAP_OPT_REFERRALS, 0);
        }
        // If no Bind DN and Password is set, attempt to login as the configured
        //  Bind DN.
        $t_password = '';
        $t_binddn = '';
        if (empty($t_binddn) && empty($t_password)) {
            $t_binddn = $g_ldap_bind_dn;
            $ldap_bind_passwd_decode = base64_decode($g_ldap_bind_passwd);
            $t_password = str_rot13($ldap_bind_passwd_decode);
        }
        if (!empty($t_binddn) && !empty($t_password)) {
            $t_br = @ldap_bind($t_ds, $t_binddn, $t_password);
        } else {
            // Either the Bind DN or the Password are empty, so attempt an anonymous bind.
            $t_br = @ldap_bind($t_ds);
        }
        if (!$t_br) {
            return 'ERROR_LDAP_AUTH_FAILED';
        }
    } else {
        return 'ERROR_LDAP_SERVER_CONNECT_FAILED';
    }
    // Search for the user id
    $t_sr = ldap_search($t_ds, $t_ldap_root_dn, $t_search_filter, $t_search_attrs);
    $t_info = ldap_get_entries($t_ds, $t_sr);
    $user = array();
    $user['User']['is_username_exits'] = false;
    $user['User']['is_password_matched'] = false;
    if (!empty($t_info)) {
        $user['User']['is_username_exits'] = true;
        // Try to authenticate to each until we get a match
        for ($i = 0; $i < $t_info['count']; $i++) {
            $t_dn = $t_info[$i]['dn'];
            // Attempt to bind with the DN and password
            if (@ldap_bind($t_ds, $t_dn, $p_password)) {
                $user['User']['is_password_matched'] = true;
                if (isset($t_info[$i]['name'])) {
                    $user['User']['first_name'] = $t_info[$i]['name'][0];
                }
                if (isset($t_info[$i]['mail'])) {
                    $user['User']['email'] = $t_info[$i]['mail'][0];
                }
                break; // Don't need to go any further
                
            }
        }
    }
    if (empty($user['User']['email'])) {
        return 'ERROR_LDAP_EMAIL_NOT_ASSOCIATED';
    }
    ldap_free_result($t_sr);
    ldap_unbind($t_ds);
    return $user;
}
/**
 * Check the current url and method can access by the user
 *
 * @param string $r_request_method Optional default value : 'GET'
 * @param string $r_resource_cmd   Optional default value : '/users'
 * @param string $r_resource_vars  Resource variable
 * @param string $post_data        Post data
 *
 * @return true if links allowed false otherwise
 */
function checkAclLinks($r_request_method = 'GET', $r_resource_cmd = '/users', $r_resource_vars = array() , $post_data = array())
{
    global $r_debug, $db_lnk, $authUser;
    $role = 3; // Guest role id
    if ($authUser) {
        $role = $authUser['role_id'];
        if ($authUser['role_id'] == 1) {
            return true;
        }
    }
    if (!empty($r_resource_vars['boards'])) {
        $qry_val_arr = array(
            $r_resource_vars['boards']
        );
        $board = executeQuery('SELECT board_visibility FROM boards WHERE id = $1', $qry_val_arr);
        if ($board['board_visibility'] == 2 && $r_request_method == 'GET') {
            return true;
        }
    }
    if (!empty($r_resource_vars['organizations'])) {
        $qry_val_arr = array(
            $r_resource_vars['organizations']
        );
        $organizations = executeQuery('SELECT organization_visibility FROM organizations WHERE id = $1', $qry_val_arr);
        if ($organizations['organization_visibility'] == 1 && $r_request_method == 'GET') {
            return true;
        }
    }
    $board_temp_arr = array(
        '/boards_users/?'
    );
    $organization_temp_arr = array(
        '/organizations_users/?'
    );
    $board_exception_arr = array(
        '/boards/?'
    );
    $board_exception_method_arr = array(
        'PUT'
    );
    $organization_exception_arr = array(
        '/organizations/?'
    );
    $organization_exception_method_arr = array(
        'DELETE',
        'PUT'
    );
    $board_star = true;
    $public_board_exception_url = array(
        '/boards/?/boards_stars/?',
        '/boards/?/boards_stars',
        '/boards/?/lists/?/cards/?/comments',
        '/boards/?/board_subscribers',
        '/boards/?/lists/?/list_subscribers',
        '/boards/?/lists/?/cards/?/card_subscribers'
    );
    if (in_array($r_resource_cmd, $public_board_exception_url)) {
        $board_star = false;
    }
    //temp fix
    if (((!empty($r_resource_vars['boards']) && (!in_array($r_resource_cmd, $board_exception_arr) || (in_array($r_resource_cmd, $board_exception_arr) && in_array($r_request_method, $board_exception_method_arr)))) || in_array($r_resource_cmd, $board_temp_arr)) && $board_star) {
        if ($r_request_method == 'PUT' && in_array($r_resource_cmd, $board_temp_arr)) {
            $r_resource_vars['boards'] = $post_data['board_id'];
        }
        $qry_val_arr = array(
            $r_resource_vars['boards'],
            $authUser['id']
        );
        $board_user_role_id = executeQuery('SELECT board_user_role_id FROM boards_users WHERE board_id = $1 AND user_id = $2', $qry_val_arr);
        $role = $board_user_role_id['board_user_role_id'];
        $qry_val_arr = array(
            $role,
            $r_request_method,
            $r_resource_cmd
        );
        $board_allowed_link = executeQuery('SELECT * FROM acl_board_links_listing WHERE board_user_role_id = $1 AND method = $2 AND url = $3', $qry_val_arr);
        if (empty($board_allowed_link)) {
            return false;
        }
    } else if (!empty($r_resource_vars['organizations']) && (!in_array($r_resource_cmd, $organization_exception_arr) || (in_array($r_resource_cmd, $organization_exception_arr) && in_array($r_request_method, $organization_exception_method_arr))) || in_array($r_resource_cmd, $organization_temp_arr)) {
        if ($r_request_method == 'PUT' && in_array($r_resource_cmd, $organization_temp_arr)) {
            $r_resource_vars['organizations'] = $post_data['organization_id'];
        }
        $qry_val_arr = array(
            $r_resource_vars['organizations'],
            $authUser['id']
        );
        $organization_user_role_id = executeQuery('SELECT organization_user_role_id FROM organizations_users WHERE organization_id = $1 AND user_id = $2', $qry_val_arr);
        $role = $organization_user_role_id['organization_user_role_id'];
        $qry_val_arr = array(
            $role,
            $r_request_method,
            $r_resource_cmd
        );
        $organization_allowed_link = executeQuery('SELECT * FROM acl_organization_links_listing WHERE organization_user_role_id = $1 AND method = $2 AND url = $3', $qry_val_arr);
        if (empty($organization_allowed_link)) {
            return false;
        }
    } else {
        $qry_val_arr = array(
            $role,
            $r_request_method,
            $r_resource_cmd
        );
        $allowed_link = executeQuery('SELECT * FROM acl_links_listing WHERE role_id = $1 AND method = $2 AND url = $3', $qry_val_arr);
        if (empty($allowed_link)) {
            return false;
        }
    }
    return true;
}
/**
 * To execute the query
 *
 * @param string $qry SQL query to execute
 * @param array  $arr Query values
 *
 * @return mixed query results
 */
function executeQuery($qry, $arr = array())
{
    global $db_lnk;
    $result = pg_query_params($db_lnk, $qry, $arr);
    if (pg_num_rows($result)) {
        return pg_fetch_assoc($result);
    } else {
        return false;
    }
}
/**
 * Common method to send mail
 *
 * @param string $template        Email template name
 * @param array  $replace_content Email content replace array
 * @param string $to              To email address
 * @param string $reply_to_mail   Reply to email address
 *
 * @return void
 */
function sendMail($template, $replace_content, $to, $reply_to_mail = '')
{
    global $r_debug, $db_lnk, $_server_domain_url;
    if (file_exists(APP_PATH . '/tmp/cache/site_url_for_shell.php')) {
        include_once APP_PATH . '/tmp/cache/site_url_for_shell.php';
    }
    $default_content = array(
        '##SITE_NAME##' => SITE_NAME,
        '##SITE_URL##' => $_server_domain_url,
        '##FROM_EMAIL##' => DEFAULT_FROM_EMAIL_ADDRESS,
        '##CONTACT_EMAIL##' => DEFAULT_CONTACT_EMAIL_ADDRESS
    );
    $qry_val_arr = array(
        $template
    );
    $emailFindReplace = array_merge($default_content, $replace_content);
    $template = executeQuery('SELECT * FROM email_templates WHERE name = $1', $qry_val_arr);
    if ($template) {
        $message = strtr($template['email_text_content'], $emailFindReplace);
        $subject = strtr($template['subject'], $emailFindReplace);
        $from_email = strtr($template['from_email'], $emailFindReplace);
        $headers = 'From:' . $from_email . "\r\n";
        if (!empty($reply_to_mail)) {
            $headers.= 'Reply-To:' . $reply_to_mail . "\r\n";
        }
        $headers.= "MIME-Version: 1.0\r\n";
        $headers.= "Content-Type: text/html; charset=ISO-8859-1\r\n";
        $headers.= "X-Mailer: Restyaboard (0.3; +http://restya.com/board)\r\n";
        $headers.= "X-Auto-Response-Suppress: All\r\n";
        mail($to, $subject, $message, $headers);
    }
}
/**
 * Insert current access ip address into IPs table
 *
 * @return int IP id
 */
function saveIp()
{
    global $db_lnk;
    $qry_val_arr = array(
        $_SERVER['REMOTE_ADDR']
    );
    $ip_row = executeQuery('SELECT id FROM ips WHERE ip = $1', $qry_val_arr);
    if (!$ip_row) {
        $country_id = 0;
        $_geo = array();
        if (function_exists('geoip_record_by_name')) {
            $_geo = geoip_record_by_name($_SERVER['REMOTE_ADDR']);
        }
        if (!empty($_geo)) {
            $qry_val_arr = array(
                $_geo['country_code']
            );
            $country_row = executeQuery('SELECT id FROM countries WHERE iso_alpha2 = $1', $qry_val_arr);
            if ($country_row) {
                $country_id = $country_row['id'];
            }
            $qry_val_arr = array(
                $_geo['region']
            );
            $state_row = executeQuery('SELECT id FROM states WHERE name = $1', $qry_val_arr);
            if (!$state_row) {
                $qry_val_arr = array(
                    $_geo['region'],
                    $country_id
                );
                $result = pg_query_params($db_lnk, 'INSERT INTO states (created, modified, name, country_id) VALUES (now(), now(), $1, $2) RETURNING id', $qry_val_arr);
                $state_row = pg_fetch_assoc($result);
            }
            $qry_val_arr = array(
                $_geo['city']
            );
            $city_row = executeQuery('SELECT id FROM cities WHERE name = $1', $qry_val_arr);
            if (!$city_row) {
                $qry_val_arr = array(
                    $_geo['city'],
                    $state_row['id'],
                    $country_id,
                    $_geo['latitude'],
                    $_geo['longitude']
                );
                $result = pg_query_params($db_lnk, 'INSERT INTO cities (created, modified, name, state_id, country_id, latitude, longitude) VALUES (now(), now(), $1, $2, $3, $4, $5) RETURNING id ', $qry_val_arr);
                $city_row = pg_fetch_assoc($result);
            }
        }
        $user_agent = !empty($_SERVER['HTTP_USER_AGENT']) ? $_SERVER['HTTP_USER_AGENT'] : '';
        $state_id = (!empty($state_row['id'])) ? $state_row['id'] : 0;
        $city_id = (!empty($city_row['id'])) ? $city_row['id'] : 0;
        $lat = (!empty($_geo['latitude'])) ? $_geo['latitude'] : 0.00;
        $lng = (!empty($_geo['longitude'])) ? $_geo['longitude'] : 0.00;
        $qry_val_arr = array(
            $_SERVER['REMOTE_ADDR'],
            gethostbyaddr($_SERVER['REMOTE_ADDR']) ,
            $city_id,
            $state_id,
            $country_id,
            $lat,
            $lng,
            $user_agent
        );
        $result = pg_query_params($db_lnk, 'INSERT INTO ips (created, modified, ip, host, city_id, state_id, country_id, latitude, longitude, user_agent) VALUES (now(), now(), $1, $2, $3, $4, $5, $6, $7, $8) RETURNING id', $qry_val_arr);
        $ip_row = pg_fetch_assoc($result);
    }
    return $ip_row['id'];
}
/**
 * Copy Card
 *
 * @param mixed   $cards        Card record array
 * @param integer $new_list_id  List id of the new card
 * @param string  $name         Card name
 * @param integer $new_board_id Board id of the new card
 *
 * @return void
 */
function copyCards($cards, $new_list_id, $name, $new_board_id = '')
{
    global $db_lnk, $authUser;
    $foreign_ids = $response = array();
    while ($card = pg_fetch_object($cards)) {
        $card->list_id = $new_list_id;
        $card_id = $card->id;
        if ($card->due_date === null) {
            unset($card->due_date);
        }
        $card_result = pg_execute_insert('cards', $card);
        if ($card_result) {
            $card_result = pg_fetch_assoc($card_result);
            $new_card_id = $card_result['id'];
            $foreign_ids['card_id'] = $new_card_id;
            $foreign_ids['board_id'] = $new_board_id;
            $foreign_ids['list_id'] = $new_list_id;
            $comment = '##USER_NAME## added ' . $card_result['name'] . ' card to ' . $name . '.';
            insertActivity($authUser['id'], $comment, 'add_card', $foreign_ids);
            // Copy card attachments
            $attachment_fields = 'list_id, card_id, name, path, mimetype';
            if (!empty($new_board_id)) {
                $attachment_fields = 'board_id, list_id, card_id, name, path, mimetype';
            }
            $qry_val_arr = array(
                $card_id
            );
            $attachments = pg_query_params($db_lnk, 'SELECT id, ' . $attachment_fields . ' FROM card_attachments WHERE card_id = $1 ORDER BY id', $qry_val_arr);
            if ($attachments && pg_num_rows($attachments)) {
                while ($attachment = pg_fetch_object($attachments)) {
                    $attachment->board_id = $new_board_id;
                    $attachment->list_id = $new_list_id;
                    $attachment->card_id = $new_card_id;
                    $attachment_result = pg_execute_insert('card_attachments', $attachment);
                    $attachment_result = pg_fetch_assoc($attachment_result);
                    $comment = '##USER_NAME## added attachment to this card ##CARD_LINK##';
                    insertActivity($authUser['id'], $comment, 'add_card_attachment', $foreign_ids, null, $attachment_result['id']);
                }
            }
            // Copy card comments
            $comment_fields = 'list_id, card_id, board_id, user_id, type, comment, root, freshness_ts, depth, path, materialized_path';
            $qry_val_arr = array(
                $card_id,
                'add_comment'
            );
            $comments = pg_query_params($db_lnk, 'SELECT id, ' . $comment_fields . ' FROM activities WHERE card_id = $1 AND type = $2 ORDER BY id', $qry_val_arr);
            if ($comments && pg_num_rows($comments)) {
                while ($comment = pg_fetch_object($comments)) {
                    $comment->board_id = $new_board_id;
                    $comment->list_id = $new_list_id;
                    $comment->card_id = $new_card_id;
                    pg_execute_insert('activities', $comment);
                }
            }
            // Copy checklists
            $checklist_fields = 'card_id, user_id, name, checklist_item_count, checklist_item_completed_count, position';
            $qry_val_arr = array(
                $card_id
            );
            $checklists = pg_query_params($db_lnk, 'SELECT id, ' . $checklist_fields . ' FROM checklists WHERE card_id = $1 ORDER BY id', $qry_val_arr);
            if ($checklists && pg_num_rows($checklists)) {
                while ($checklist = pg_fetch_object($checklists)) {
                    $checklist_id = $checklist->id;
                    $checklist->card_id = $new_card_id;
                    $checklist_result = pg_execute_insert('checklists', $checklist);
                    if ($checklist_result) {
                        $checklist_result = pg_fetch_assoc($checklist_result);
                        $new_checklist_id = $checklist_result['id'];
                        $comment = '##USER_NAME## added checklist to this card ##CARD_LINK##';
                        insertActivity($authUser['id'], $comment, 'add_card_checklist', $foreign_ids, '', $new_checklist_id);
                        $checklist_item_fields = 'card_id, checklist_id, user_id, name, position';
                        $qry_val_arr = array(
                            $checklist_id
                        );
                        $checklist_items = pg_query_params($db_lnk, 'SELECT id, ' . $checklist_item_fields . ' FROM checklist_items WHERE checklist_id = $1 ORDER BY id', $qry_val_arr);
                        if ($checklist_items && pg_num_rows($checklist_items)) {
                            while ($checklist_item = pg_fetch_object($checklist_items)) {
                                $checklist_item->card_id = $new_card_id;
                                $checklist_item->checklist_id = $new_checklist_id;
                                $checklist_item_result = pg_execute_insert('checklist_items', $checklist_item);
                                $checklist_item_result = pg_fetch_assoc($checklist_item_result);
                                $comment = '##USER_NAME## added checklist item to this card ##CARD_LINK##';
                                insertActivity($authUser['id'], $comment, 'add_checklist_item', $foreign_ids, '', $checklist_item_result['id']);
                            }
                        }
                    }
                }
            }
            // Copy card labels
            $cards_label_fields = 'list_id, card_id, board_id, label_id';
            if (!empty($new_board_id)) {
                $cards_label_fields = 'board_id, list_id, card_id, label_id';
            }
            $qry_val_arr = array(
                $card_id
            );
            $cards_labels = pg_query_params($db_lnk, 'SELECT id, ' . $cards_label_fields . ' FROM cards_labels WHERE card_id = $1 ORDER BY id', $qry_val_arr);
            if ($cards_labels && pg_num_rows($cards_labels)) {
                while ($cards_label = pg_fetch_object($cards_labels)) {
                    if (!empty($new_board_id)) {
                        $cards_label->board_id = $new_board_id;
                        $cards_label->list_id = $new_list_id;
                        $cards_label->card_id = $new_card_id;
                    }
                    pg_execute_insert('cards_labels', $cards_label);
                    $comment = '##USER_NAME## added label(s) to this card ##CARD_LINK## - ##LABEL_NAME##';
                    insertActivity($authUser['id'], $comment, 'add_card_label', $foreign_ids);
                }
            }
            // Copy card users
            $cards_user_fields = 'card_id, user_id';
            $qry_val_arr = array(
                $card_id
            );
            $cards_users = pg_query_params($db_lnk, 'SELECT id, ' . $cards_user_fields . ' FROM cards_users WHERE card_id = $1 ORDER BY id', $qry_val_arr);
            if ($cards_users && pg_num_rows($cards_users)) {
                while ($cards_user = pg_fetch_object($cards_users)) {
                    $cards_user->card_id = $new_card_id;
                    $cards_user_result = pg_execute_insert('cards_users', $cards_user);
                    $cards_user_result = pg_fetch_assoc($cards_user_result);
                    $qry_val_arr = array(
                        $cards_user->user_id
                    );
                    $_user = executeQuery('SELECT username FROM users WHERE id = $1', $qry_val_arr);
                    $comment = '##USER_NAME## added ' . $_user['username'] . ' as member to this card ##CARD_LINK##';
                    $response['activity'] = insertActivity($authUser['id'], $comment, 'add_card_user', $foreign_ids, '', $cards_user_result['id']);
                }
            }
        }
    }
}
/**
 * To generate query by passed args and insert into table
 *
 * @param string  $table_name Table name to execute the query
 * @param mixed   $r_post     Values
 * @param integer $return_row Return rows
 *
 * @return mixed
 */
function pg_execute_insert($table_name, $r_post, $return_row = 1)
{
    global $db_lnk;
    $fields = 'created, modified';
    $values = 'now(), now()';
    $val_arr = array();
    $i = 1;
    foreach ($r_post as $key => $value) {
        if ($key != 'id') {
            $fields.= ', "' . $key . '"';
            $values.= ', $' . $i;
            if ($value === false) {
                $val_arr[] = 'false';
            } else if ($value === null) {
                $val_arr[] = null;
            } else {
                $val_arr[] = $value;
            }
            $i++;
        }
    }
    if (!empty($return_row)) {
        $row = pg_query_params($db_lnk, 'INSERT INTO ' . $table_name . ' (' . $fields . ') VALUES (' . $values . ') RETURNING *', $val_arr);
    } else {
        $row = pg_query_params($db_lnk, 'INSERT INTO ' . $table_name . ' (' . $fields . ') VALUES (' . $values . ')', $val_arr);
    }
    return $row;
}
/**
 * Common method to get binded values
 *
 * @param string $table Table name to get values
 * @param mixed  $data  Field list
 *
 * @return mixed
 */
function getbindValues($table, $data)
{
    global $db_lnk;
    $qry_val_arr = array(
        $table
    );
    $result = pg_query_params($db_lnk, 'SELECT * FROM information_schema.columns WHERE table_name = $1 ', $qry_val_arr);
    $bindValues = array();
    while ($field_details = pg_fetch_assoc($result)) {
        $field = $field_details['column_name'];
        $val_arr = array(
            'created',
            'modified'
        );
        if (in_array($field, $val_arr)) {
            continue;
        }
        //todo : get list_id from lists table
        if ($field == 'id' && $table == 'lists' && array_key_exists('list_id', $data)) {
            $bindValues['id'] = $data['list_id'];
        }
        if ($field == 'ip_id') {
            $data['ip'] = !empty($data['ip']) ? $data['ip'] : '';
            $ip_id = saveIp();
            $bindValues[$field] = $ip_id;
        } elseif (array_key_exists($field, $data)) {
            if ($field == 'is_active' || $field == 'is_allow_email_alias') {
                $boolean = !empty($data[$field]) ? 'true' : 'false';
                $bindValues[$field] = $boolean;
            } else if ($field == 'due_date' && $data[$field] == null) {
                $bindValues[$field] = null;
            } else {
                $bindValues[$field] = $data[$field];
            }
        }
    }
    return $bindValues;
}
/**
 * Import Trello board
 *
 * @param array $board Boards from trello
 *
 * @return mixed
 */
function importTrelloBoard($board = array())
{
    set_time_limit(1800);
    global $r_debug, $db_lnk, $authUser, $_server_domain_url;
    $users = $lists = $cards = array();
    if (!empty($board)) {
        $user_id = $authUser['id'];
        $board_visibility = 0;
        if ($board['prefs']['permissionLevel'] == 'public') {
            $board_visibility = 2;
        }
        $background_image = $background_pattern = '';
        if (!empty($board['prefs']['backgroundImage'])) {
            if ($board['prefs']['backgroundTile'] == 'true') {
                $background_pattern = $board['prefs']['backgroundImage'];
            } else {
                $background_image = $board['prefs']['backgroundImage'];
            }
        }
        $qry_val_arr = array(
            utf8_decode($board['name']),
            $board['prefs']['backgroundColor'],
            $background_image,
            $background_pattern,
            $user_id,
            $board_visibility
        );
        $new_board = pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO boards (created, modified, name, background_color, background_picture_url, background_pattern_url, user_id, board_visibility) VALUES (now(), now(), $1, $2, $3, $4, $5, $6) RETURNING id', $qry_val_arr));
        $admin_user_id = array();
        if (!empty($board['members'])) {
            foreach ($board['memberships'] as $membership) {
                if ($membership['memberType'] == 'admin') {
                    $admin_user_id[] = $membership['idMember'];
                }
            }
        }
        if (!empty($board['members'])) {
            foreach ($board['members'] as $member) {
                $qry_val_arr = array(
                    utf8_decode($member['username'])
                );
                $userExist = executeQuery('SELECT * FROM users WHERE username = $1', $qry_val_arr);
                if (!$userExist) {
                    $qry_val_arr = array(
                        utf8_decode($member['username']),
                        getCryptHash('restya') ,
                        utf8_decode($member['initials']),
                        utf8_decode($member['fullName'])
                    );
                    $user = pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO users (created, modified, role_id, username, email, password, is_active, is_email_confirmed, initials, full_name) VALUES (now(), now(), 2, $1, \'\', $2, true, true, $3, $4) RETURNING id', $qry_val_arr));
                    $users[$member['id']] = $user['id'];
                } else {
                    $users[$member['id']] = $userExist['id'];
                }
                $board_user_role_id = 2;
                if (in_array($member['id'], $admin_user_id)) {
                    $board_user_role_id = 1;
                }
                $qry_val_arr = array(
                    $users[$member['id']],
                    $new_board['id'],
                    $board_user_role_id
                );
                pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO boards_users (created, modified, user_id, board_id, board_user_role_id) VALUES (now(), now(), $1, $2, $3) RETURNING id', $qry_val_arr));
            }
        }
        $qry_val_arr = array(
            $authUser['id'],
            $new_board['id'],
            1
        );
        pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO boards_users (created, modified, user_id, board_id, board_user_role_id) VALUES (now(), now(), $1, $2, $3) RETURNING id', $qry_val_arr));
        if (!empty($board['lists'])) {
            $i = 0;
            foreach ($board['lists'] as $list) {
                $i+= 1;
                $is_closed = ($list['closed']) ? 'true' : 'false';
                $qry_val_arr = array(
                    utf8_decode($list['name']),
                    $new_board['id'],
                    $i,
                    $user_id,
                    $is_closed
                );
                $_list = pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO lists (created, modified, name, board_id, position, user_id, is_archived) VALUES (now(), now(), $1, $2, $3, $4, $5) RETURNING id', $qry_val_arr));
                $lists[$list['id']] = $_list['id'];
            }
        }
        if (!empty($board['cards'])) {
            foreach ($board['cards'] as $card) {
                $is_closed = ($card['closed']) ? 'true' : 'false';
                $date = $card['due'];
                $qry_val_arr = array(
                    $new_board['id'],
                    $lists[$card['idList']],
                    utf8_decode($card['name']),
                    utf8_decode($card['desc']),
                    $is_closed,
                    $card['pos'],
                    $date,
                    $user_id
                );
                $_card = pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO cards (created, modified, board_id, list_id, name, description, is_archived, position, due_date, user_id) VALUES (now(), now(), $1, $2, $3, $4, $5, $6, $7, $8) RETURNING id', $qry_val_arr));
                $cards[$card['id']] = $_card['id'];
                if (!empty($card['labels'])) {
                    foreach ($card['labels'] as $label) {
                        $qry_val_arr = array(
                            utf8_decode($label['name'])
                        );
                        $check_label = executeQuery('SELECT id FROM labels WHERE name = $1', $qry_val_arr);
                        if (empty($check_label)) {
                            $qry_val_arr = array(
                                utf8_decode($label['name'])
                            );
                            $check_label = pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO labels (created, modified, name) VALUES (now(), now(), $1) RETURNING id', $qry_val_arr));
                        }
                        $qry_val_arr = array(
                            $new_board['id'],
                            $lists[$card['idList']],
                            $_card['id'],
                            $check_label['id']
                        );
                        pg_query_params($db_lnk, 'INSERT INTO cards_labels (created, modified, board_id, list_id, card_id, label_id) VALUES (now(), now(), $1, $2, $3, $4)', $qry_val_arr);
                    }
                }
                if (!empty($card['attachments'])) {
                    foreach ($card['attachments'] as $attachment) {
                        $mediadir = APP_PATH . DIRECTORY_SEPARATOR . 'media' . DIRECTORY_SEPARATOR . 'Card' . DIRECTORY_SEPARATOR . $_card['id'];
                        $save_path = 'media' . DIRECTORY_SEPARATOR . 'Card' . DIRECTORY_SEPARATOR . $_card['id'];
                        $save_path = str_replace('\\', '/', $save_path);
                        $filename = curlExecute($attachment['url'], 'get', $mediadir, 'image');
                        $path = $save_path . DIRECTORY_SEPARATOR . $filename['file_name'];
                        $created = $modified = $attachment['date'];
                        $qry_val_arr = array(
                            $created,
                            $modified,
                            $new_board['id'],
                            $lists[$card['idList']],
                            $_card['id'],
                            $filename['file_name'],
                            $path,
                            $attachment['mimeType']
                        );
                        pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO card_attachments (created, modified, board_id, list_id, card_id, name, path, mimetype) VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING id', $qry_val_arr));
                    }
                }
                if (!empty($card['idMembersVoted'])) {
                    foreach ($card['idMembersVoted'] as $votedMemberId) {
                        $qry_val_arr = array(
                            $_card['id'],
                            $users[$votedMemberId]
                        );
                        pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO card_voters (created, modified, card_id, user_id) VALUES (now(), now(), $1, $2) RETURNING id', $qry_val_arr));
                    }
                }
                if (!empty($card['idMembers'])) {
                    foreach ($card['idMembers'] as $cardMemberId) {
                        $qry_val_arr = array(
                            $_card['id'],
                            $users[$cardMemberId]
                        );
                        pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO cards_users (created, modified, card_id, user_id) VALUES (now(), now(), $1, $2) RETURNING id', $qry_val_arr));
                    }
                }
            }
        }
        if (!empty($board['checklists'])) {
            $checklists = array();
            foreach ($board['checklists'] as $checklist) {
                $qry_val_arr = array(
                    utf8_decode($checklist['name']),
                    $checklist['pos'],
                    $cards[$checklist['idCard']],
                    $user_id
                );
                $_checklist = pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO checklists (created, modified, name, position, card_id, user_id) VALUES (now(), now(), $1, $2, $3, $4) RETURNING id', $qry_val_arr));
                $checklists[$checklist['id']] = $_checklist['id'];
                if (!empty($checklist['checkItems'])) {
                    foreach ($checklist['checkItems'] as $checkItem) {
                        $is_completed = ($checkItem['state'] == 'complete') ? 'true' : 'false';
                        $qry_val_arr = array(
                            utf8_decode($checkItem['name']),
                            $checkItem['pos'],
                            $cards[$checklist['idCard']],
                            $_checklist['id'],
                            $is_completed,
                            $user_id
                        );
                        pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO checklist_items (created, modified, name, position, card_id, checklist_id, is_completed, user_id) VALUES (now(), now(), $1, $2, $3, $4, $5, $6) RETURNING id', $qry_val_arr));
                    }
                }
            }
        }
        if (!empty($board['actions'])) {
            $type = $comment = '';
            foreach ($board['actions'] as $action) {
                if ($action['type'] == 'commentCard') {
                    $type = 'add_comment';
                    $comment = $action['data']['text'];
                } else if ($action['type'] == 'addMemberToCard') {
                    $type = 'add_card_user';
                    $comment = '##USER_NAME## added "' . utf8_decode($action['member']['fullName']) . '" as member to this card ##CARD_LINK##';
                } else if ($action['type'] == 'createCard') {
                    $type = 'add_card';
                    $comment = '##USER_NAME## added card ##CARD_LINK## to list "' . utf8_decode($action['data']['list']['name']) . '".';
                } else if ($action['type'] == 'createList') {
                    $type = 'add_list';
                    $comment = '##USER_NAME## added list "' . utf8_decode($action['data']['list']['name']) . '".';
                } else if ($action['type'] == 'createBoard') {
                    $type = 'add_board';
                    $comment = '##USER_NAME## created board';
                } else if ($action['type'] == 'updateBoard') {
                    if (!empty($action['data']['board']['closed']) && $action['data']['board']['closed']) {
                        $type = 'reopen_board';
                        $comment = '##USER_NAME## closed ##BOARD_NAME## board.';
                    } else if (!empty($action['data']['board']['closed'])) {
                        $type = 'reopen_board';
                        $comment = '##USER_NAME## reopened ##BOARD_NAME## board.';
                    } else if (!empty($action['data']['board']['prefs']['permissionLevel'])) {
                        $type = 'change_visibility';
                        $comment = '##USER_NAME## changed visibility to ' . $action['data']['board']['prefs']['permissionLevel'];
                    } else if (!empty($action['data']['board']['prefs']['background'])) {
                        $type = 'change_background';
                        $comment = '##USER_NAME## changed backgound to board "' . $action['data']['board']['prefs']['background'] . '"';
                    } else if (!empty($action['data']['board']['name'])) {
                        $type = 'edit_board';
                        $comment = '##USER_NAME## renamed ##BOARD_NAME## board.';
                    }
                } else if ($action['type'] == 'updateList') {
                    if ($action['data']['list']['closed']) {
                        $type = 'archive_list';
                        $comment = '##USER_NAME## archived ##LIST_NAME##';
                    } else if (!empty($action['data']['list']['pos'])) {
                        $type = 'change_list_position';
                        $comment = '##USER_NAME## changed list ' . utf8_decode($action['data']['list']['name']) . ' position.';
                    } else if (!empty($action['data']['list']['name'])) {
                        $type = 'edit_list';
                        $comment = '##USER_NAME## renamed this list.';
                    }
                } else if ($action['type'] == 'updateCard') {
                    if (!empty($action['data']['card']['pos'])) {
                        $type = 'change_card_position';
                        $comment = '##USER_NAME## moved this card to different position.';
                    } else if (!empty($action['data']['card']['idList'])) {
                        $type = 'moved_list_card';
                        $comment = '##USER_NAME## moved cards FROM ' . utf8_decode($action['data']['listBefore']['name']) . ' to ' . utf8_decode($action['data']['listAfter']['name']);
                    } else if (!empty($action['data']['card']['due'])) {
                        $type = 'add_card_duedate';
                        $comment = '##USER_NAME## SET due date to this card ##CARD_LINK##';
                    } else if (!empty($action['data']['card']['desc'])) {
                        $type = 'add_card_desc';
                        $comment = '##USER_NAME## added card description in ##CARD_LINK## - ##DESCRIPTION##';
                    } else if (!empty($action['data']['card']['name'])) {
                        $type = 'edit_card';
                        $comment = '##USER_NAME## edited ' . utf8_decode($action['data']['list']['name']) . ' card in this board.';
                    }
                } else if ($action['type'] == 'addChecklistToCard') {
                    $type = 'add_card_checklist';
                    $comment = '##USER_NAME## added checklist ##CHECKLIST_NAME## to this card ##CARD_LINK##';
                } else if ($action['type'] == 'deleteAttachmentFromCard') {
                    $type = 'delete_card_attachment';
                    $comment = '##USER_NAME## deleted attachment from card ##CARD_LINK##';
                } else if ($action['type'] == 'addAttachmentToCard') {
                    $type = 'add_card_attachment';
                    $comment = '##USER_NAME## added attachment to this card ##CARD_LINK##';
                } else if ($action['type'] == 'addMemberToBoard') {
                    $type = 'add_board_user';
                    $comment = '##USER_NAME## added member to board';
                } else if ($action['type'] == 'removeChecklistFromCard') {
                    $type = 'delete_checklist';
                    $comment = '##USER_NAME## deleted checklist ##CHECKLIST_NAME## from card ##CARD_LINK##';
                }
                $created = $modified = $action['date'];
                $qry_val_arr = array(
                    $created,
                    $modified,
                    $new_board['id'],
                    $lists[$action['data']['list']['id']],
                    $cards[$action['data']['card']['id']],
                    $users[$action['idMemberCreator']],
                    $type,
                    utf8_decode($comment)
                );
                pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO activities (created, modified, board_id, list_id, card_id, user_id, type, comment) VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING id', $qry_val_arr));
            }
        }
        return $new_board;
    }
}
/**
 * Email to name
 *
 * @param string $email Email
 *
 * @return string
 */
function email2name($email)
{
    $email = substr($email, 0, strrpos($email, '@'));
    // replace non-text
    $name = trim(ucwords(preg_replace('/[\W\d_]+/', ' ', strtolower($email))));
    // split by final space
    if (preg_match('/(.*)?\s(.*)$/', $name, $matches)) {
        $full_name = $matches[1] . ' ' . $matches[2];
    } else {
        $full_name = $name;
    }
    return $full_name;
}
/**
 * Find and replace comment variables
 *
 * @param array $activity is activity informations
 *
 * @return string
 */
function findAndReplaceVariables($activity)
{
    global $_server_domain_url;
    if (file_exists(APP_PATH . '/tmp/cache/site_url_for_shell.php')) {
        include_once APP_PATH . '/tmp/cache/site_url_for_shell.php';
    }
    $data = array(
        '##ORGANIZATION_LINK##' => $activity['organization_name'],
        '##CARD_LINK##' => '<a href="' . $_server_domain_url . '/#/board/' . $activity['board_id'] . '/card/' . $activity['card_id'] . '">' . $activity['card_name'] . '</a>',
        '##LABEL_NAME##' => $activity['label_name'],
        '##CARD_NAME##' => '<a href="' . $_server_domain_url . '/#/board/' . $activity['board_id'] . '/card/' . $activity['card_id'] . '">' . $activity['card_name'] . '</a>',
        '##DESCRIPTION##' => $activity['card_description'],
        '##LIST_NAME##' => $activity['list_name'],
        '##BOARD_NAME##' => '<a href="' . $_server_domain_url . '/#/board/' . $activity['board_id'] . '">' . $activity['board_name'] . '</a>',
        '##USER_NAME##' => '<strong>' . $activity['full_name'] . '</strong>',
        '##CHECKLIST_ITEM_NAME##' => $activity['checklist_item_name'],
        '##CHECKLIST_ITEM_PARENT_NAME##' => $activity['checklist_item_parent_name'],
        '##CHECKLIST_NAME##' => $activity['checklist_name']
    );
    $comment = strtr($activity['comment'], $data);
    return $comment;
}
/**
 * Common method to convert boolean values
 *
 * @param string $table Table name to get values
 * @param array  $row   Field list
 *
 * @return mixed
 */
function convertBooleanValues($table, $row)
{
    global $db_lnk;
    $qry_val_arr = array(
        $table
    );
    $result = pg_query_params($db_lnk, 'SELECT * FROM information_schema.columns WHERE table_name = $1 ', $qry_val_arr);
    while ($field_details = pg_fetch_assoc($result)) {
        if ($field_details['data_type'] == 'boolean') {
            $row[$field_details['column_name']] = ($row[$field_details['column_name']] == 'f') ? 0 : 1;
        }
    }
    return $row;
}
/**
 * Genrate client id
 *
 * @return client_id
 */
function isClientIdAvailable()
{
    do {
        $client_id = '';
        for ($i = 0; $i < 16; $i++) {
            $client_id.= mt_rand(0, 9);
        }
        $qry_val_arr = array(
            $client_id
        );
        $oauth_client = executeQuery('SELECT * FROM oauth_clients WHERE client_id = $1', $qry_val_arr);
    } while (!empty($oauth_client));
    return $client_id;
}
/**
 * Genrate client secret
 *
 * @return client_secret
 */
function isClientSecretAvailable()
{
    $characters = 'abcdefghijklmnopqrstuvwxyz0123456789';
    do {
        $client_secret = '';
        for ($i = 0; $i < 26; $i++) {
            $client_secret.= $characters[mt_rand(0, strlen($characters) - 1) ];
        }
        $qry_val_arr = array(
            $client_secret
        );
        $oauth_client = executeQuery('SELECT * FROM oauth_clients WHERE client_secret = $1', $qry_val_arr);
    } while (!empty($oauth_client));
    return $client_secret;
}
/**
 * Genrate ejabberd connection
 *
 * @return ejabberd connection
 */
function getEjabberdConnection()
{
    return pg_connect('host=' . CHAT_DB_HOST . ' port=' . CHAT_DB_PORT . ' dbname=' . CHAT_DB_NAME . ' user=' . CHAT_DB_USER . ' password=' . CHAT_DB_PASSWORD . ' options=--client_encoding=UTF8');
}
/**
 * Bind array from ElasticSearch data
 *
 * @param array  $result Search list to bind elastic
 * @param string $type   Fetching type
 *
 * @return array
 */
function bind_elastic($result, $type)
{
    $card = array(
        'id' => !empty($result['_source']['id']) ? $result['_source']['id'] : null,
        'name' => !empty($result['_source']['name']) ? $result['_source']['name'] : null,
        'list_id' => !empty($result['_source']['list_id']) ? $result['_source']['list_id'] : null,
        'list_name' => !empty($result['_source']['list']) ? $result['_source']['list'] : null,
        'board_id' => !empty($result['_source']['board_id']) ? $result['_source']['board_id'] : null,
        'board_name' => !empty($result['_source']['board']) ? $result['_source']['board'] : null,
        'name' => !empty($result['_source']['name']) ? $result['_source']['name'] : null,
        'attachment_count' => !empty($result['_source']['attachment_count']) ? $result['_source']['attachment_count'] : 0,
        'due_date' => !empty($result['_source']['due_date']) ? $result['_source']['due_date'] : null,
        'comment_count' => !empty($result['_source']['activities']) ? count($result['_source']['activities']) : 0,
        'type' => $type,
        'checklist_item_completed_count' => !empty($result['_source']['checklist_item_completed_count']) ? $result['_source']['checklist_item_completed_count'] : 0,
        'checklist_item_count' => !empty($result['_source']['checklist_item_count']) ? $result['_source']['checklist_item_count'] : 0,
        'vote_count' => !empty($result['_source']['card_voter_count']) ? $result['_source']['card_voter_count'] : 0,
        'description' => !empty($result['_source']['description']) ? $result['_source']['description'] : null
    );
    if (!empty($result['highlight'])) {
        $card['highlight'] = $result['highlight'];
    }
    return $card;
}
/**
 * Wait for register response
 *
 * @param array  $event events
 * @param string $args  arguments
 *
 * @return array
 */
function wait_for_register_response($event, $args)
{
    global $client, $form;
    if ($event == 'stanza_cb') {
        $stanza = $args[0];
        if ($stanza->name == 'iq') {
            $form['type'] = $stanza->attrs['type'];
            if ($stanza->attrs['type'] == 'result') {
                $client->send_end_stream();
                return "logged_out";
            } else if ($stanza->attrs['type'] == 'error') {
                $stanza->exists('error');
                $client->send_end_stream();
                return "logged_out";
            }
        }
    } else {
        _notice("unhandled event $event rcvd");
    }
}
/**
 * Wait for register form
 *
 * @param array  $event events
 * @param string $args  arguments
 *
 * @return array
 */
function wait_for_register_form($event, $args)
{
    global $client, $form, $j_username, $j_password;
    $stanza = $args[0];
    $query = $stanza->exists('query', NS_INBAND_REGISTER);
    if ($query) {
        $instructions = $query->exists('instructions');
        foreach ($query->childrens as $k => $child) {
            if ($child->name != 'instructions') {
                if ($child->name == 'username') {
                    $form[$child->name] = $j_username;
                } else {
                    $form[$child->name] = $j_password;
                }
            }
        }
        $client->xeps['0077']->set_form($stanza->attrs['from'], $form);
        return "wait_for_register_response";
    } else {
        $client->end_stream();
        return "logged_out";
    }
}
/**
 * Get list name of TODO, DOING, DONE
 *
 * @param string $name Fetching work flow
 *
 * @return array
 */
function getWorkFlow($name)
{
    global $db_lnk;
    $settings = '';
    $qry_val_arr = array(
        $name
    );
    $s_sql = pg_query_params($db_lnk, 'SELECT value FROM settings WHERE name = $1', $qry_val_arr);
    $row = pg_fetch_assoc($s_sql);
    $data = explode(',', $row['value']);
    foreach ($data as $row) {
        $settings.= 'list:' . $row . ' OR ';
    }
    $settings = substr($settings, 0, -4);
    $settings_query = '(' . $settings . ') OR ';
    return $settings_query;
}
/**
 * Get xmpp user object to process create, delete board etc.
 *
 * @return array
 */
function getXmppUser()
{
    global $authUser;
    $conditions = array(
        $authUser['username']
    );
    $chat_db_lnk = getEjabberdConnection();
    $user_password = pg_query_params($chat_db_lnk, 'SELECT password FROM users WHERE username = $1', $conditions);
    $user_password = pg_fetch_assoc($user_password);
    return array(
        'username' => $authUser['username'] . '@' . JABBER_HOST,
        'password' => $user_password['password'],
        'host' => JABBER_HOST,
        'ssl' => false,
        'port' => 5222,
        'resource' => uniqid('', true)
    );
}
