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
 * @copyright  2014-2019 Restya
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
        if (file_exists($mediadir . DS . $filename['file_name'])) {
            unlink($mediadir . DS . $filename['file_name']);
        }
        $fp = fopen($mediadir . DS . $filename['file_name'], 'x');
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
        'revisions',
        'token'
    );
    if (!empty($_GET['token'])) {
        $token = $_GET['token'];
    } else {
        $token = '';
    }
    $values = array(
        'now()',
        'now()',
        $user_id,
        $comment,
        $type,
        $revision,
        $token
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
    $freshness_ts = date('Y-m-d H:i:s');
    $path = 'P' . $row['id'];
    $depth = 0;
    $qry_val_arr = array(
        $materialized_path,
        $path,
        $depth,
        $row['id']
    );
    $result = pg_query_params($db_lnk, 'UPDATE activities SET materialized_path = $1, path = $2, depth = $3, freshness_ts = now() WHERE id = $4 RETURNING *', $qry_val_arr);
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
    if (!empty($from_text) && is_string($from_text)) {
        $from_text = substr($from_text, 0, 1024 * 100);
    } else {
        return false;
    }
    if (!empty($to_text) && is_string($to_text)) {
        $to_text = substr($to_text, 0, 1024 * 100);
    } else {
        return false;
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
    if (is_plugin_enabled('r_support_app') && !isset($_POST['is_instant_add_Card'])) {
        require_once PLUGIN_PATH . DS . 'SupportApp' . DS . 'functions.php';
        if (checkSupportAppEnabled($r_resource_vars, $r_request_method, $r_resource_cmd)) {
            return true;
        }
    }
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
        'PUT',
        'DELETE'
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
        '/boards/?/lists/?/cards/?/card_subscribers',
        '/boards/?/board_subscribers/?',
        '/boards/?/lists/?/list_subscribers/?',
        '/boards/?/lists/?/cards/?/card_subscribers/?'
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
        if (!empty($r_request_method) && ($r_request_method === 'POST') && !empty($r_resource_cmd) && ($r_resource_cmd === '/settings')) {
            $r_request_method = 'GET';
        }
        if (!empty($r_request_method) && ($r_request_method === 'GET') && !empty($r_resource_cmd) && ($r_resource_cmd === '/users/?/activities')) {
            return true;
        }
        if (!empty($r_request_method) && ($r_request_method === 'PUT') && !empty($r_resource_cmd) && $r_resource_cmd === '/users/?' && !empty($post_data['last_activity_id'])) {
            return true;
        }
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
    if (file_exists(SITE_URL_FOR_SHELL)) {
        include_once SITE_URL_FOR_SHELL;
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
    $templates = executeQuery('SELECT * FROM email_templates WHERE name = $1', $qry_val_arr);
    if ($templates) {
        $message = strtr($templates['email_text_content'], $emailFindReplace);
        $message.= '<div itemscope itemtype="http://schema.org/EmailMessage"><div itemprop="potentialAction" itemscope itemtype="http://schema.org/ViewAction"><link itemprop="target" href="' . $_server_domain_url . '"/><meta itemprop="name" content="View on Restyaboard"/></div><meta itemprop="description" content="View on Restyaboard"/></div>';
        $subject = strtr($templates['subject'], $emailFindReplace);
        $from_email = strtr($templates['from_email'], $emailFindReplace);
        $headers = 'From:' . $from_email . PHP_EOL;
        if (!empty($reply_to_mail)) {
            $headers.= 'Reply-To:' . $reply_to_mail . PHP_EOL;
        }
        $headers.= "MIME-Version: 1.0" . PHP_EOL;
        $headers.= "Content-Type: text/html; charset=UTF-8" . PHP_EOL;
        $headers.= "X-Mailer: Restyaboard (0.6.8; +http://restya.com/board)" . PHP_EOL;
        $headers.= "X-Auto-Response-Suppress: All" . PHP_EOL;
        if (is_plugin_enabled('r_sparkpost')) {
            require_once PLUGIN_PATH . DS . 'SparkPost' . DS . 'functions.php';
            $result = SparkPostMail($to, $subject, $message, $headers, DEFAULT_FROM_EMAIL_ADDRESS);
        } else {
            $result = mail($to, $subject, $message, $headers, '-f' . DEFAULT_FROM_EMAIL_ADDRESS);
        }
        if (R_DEBUG) {
            if (!$result) {
                $compose_string = 'F, ' . $from_email . ', ' . $to . ', ' . $subject;
            } else {
                $compose_string = 'S, ' . $from_email . ', ' . $to . ', ' . $subject;
            }
            error_log($compose_string, 3, CACHE_PATH . DS . 'mail.log');
        }
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
            $_geo = @geoip_record_by_name($_SERVER['REMOTE_ADDR']);
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
        $old_list_id = $card->list_id;
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
            $comment = sprintf(__l('##USER_NAME## added %s card to %s.') , $card_result['name'], $name);
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
                    $comment = __l('##USER_NAME## added attachment to the card ##CARD_LINK##');
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
                    $comment->token = $_GET['token'];
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
                        $comment = __l('##USER_NAME## added checklist to the card ##CARD_LINK##');
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
                                $comment = __l('##USER_NAME## added checklist item to the card ##CARD_LINK##');
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
                    $qry_val_arr = array(
                        $cards_label->label_id
                    );
                    $_label = executeQuery('SELECT * FROM labels WHERE id = $1', $qry_val_arr);
                    $comment = __l('##USER_NAME## added label(s) to the card ##CARD_LINK## - ' . $_label['name']);
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
                    $comment = sprintf(__l('##USER_NAME## added %s as member to the card ##CARD_LINK##') , $_user['username']);
                    $response['activity'] = insertActivity($authUser['id'], $comment, 'add_card_user', $foreign_ids, '', $cards_user_result['id']);
                }
            }
            // Copy card custom fields
            if (is_plugin_enabled('r_custom_fields')) {
                $cards_custom_fields = 'list_id, card_id, board_id, custom_field_id';
                if (!empty($new_board_id)) {
                    $cards_custom_fields = 'board_id, list_id, card_id, custom_field_id';
                }
                $qry_val_arr = array(
                    $card_id
                );
                $cards_custom_field = pg_query_params($db_lnk, 'SELECT id, ' . $cards_custom_fields . ',value,is_active,value FROM cards_custom_fields WHERE card_id = $1 ORDER BY id', $qry_val_arr);
                if ($cards_custom_field && pg_num_rows($cards_custom_field)) {
                    while ($cards_field = pg_fetch_object($cards_custom_field)) {
                        if (!empty($new_board_id)) {
                            $cards_field->board_id = $new_board_id;
                            $cards_field->list_id = $new_list_id;
                            $cards_field->card_id = $new_card_id;
                        }
                        pg_execute_insert('cards_custom_fields', $cards_field);
                        $comment = __l('##USER_NAME## added card custom field(s) to the card ##CARD_LINK## ');
                        insertActivity($authUser['id'], $comment, 'add_card_custom_field', $foreign_ids);
                    }
                }
            }
        }
    }
    return $response;
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
function boardImportMailSend($import_type, $new_board)
{
    global $r_debug, $db_lnk, $authUser, $_server_domain_url;
    $val_arr = array(
        $authUser['id'],
    );
    $user = executeQuery('SELECT * FROM users WHERE id = $1 AND is_active = true', $val_arr);
    $board = executeQuery('SELECT * FROM boards WHERE id = $1', array(
        $new_board['id'],
    ));
    $emailFindReplace = array(
        '##NAME##' => $user['full_name'],
        '##BOARD_IMPORT_OPTION##' => $import_type,
        '##BOARD_NAME##' => $board['name'],
        '##BOARD_URL##' => $_server_domain_url . '/#/board/' . $board['id'],
    );
    sendMail('board_import_user_notification', $emailFindReplace, $user['email']);
}
/**
 * Create Trello member
 *
 * @param array $member member details
 * @param array $admin_user_id admin user ids
 * @param array $new_board newly created board details
 *
 * @return mixed
 */
function createTrelloMember($member = array() , $admin_user_id = array() , $new_board = array())
{
    global $r_debug, $db_lnk, $authUser, $_server_domain_url;
    $user_id = '';
    $qry_val_arr = array(
        utf8_decode($member['username'])
    );
    $userExist = executeQuery('SELECT * FROM users WHERE username = $1', $qry_val_arr);
    if (!$userExist) {
        $default_email_notification = 0;
        if (DEFAULT_EMAIL_NOTIFICATION === 'Periodically') {
            $default_email_notification = 1;
        } else if (DEFAULT_EMAIL_NOTIFICATION === 'Instantly') {
            $default_email_notification = 2;
        }
        $member['is_send_newsletter'] = $default_email_notification;
        $member['default_desktop_notification'] = (DEFAULT_DESKTOP_NOTIFICATION === 'Enabled') ? 'true' : 'false';
        $member['is_list_notifications_enabled'] = IS_LIST_NOTIFICATIONS_ENABLED;
        $member['is_card_notifications_enabled'] = IS_CARD_NOTIFICATIONS_ENABLED;
        $member['is_card_members_notifications_enabled'] = IS_CARD_MEMBERS_NOTIFICATIONS_ENABLED;
        $member['is_card_labels_notifications_enabled'] = IS_CARD_LABELS_NOTIFICATIONS_ENABLED;
        $member['is_card_checklists_notifications_enabled'] = IS_CARD_CHECKLISTS_NOTIFICATIONS_ENABLED;
        $member['is_card_attachments_notifications_enabled'] = IS_CARD_ATTACHMENTS_NOTIFICATIONS_ENABLED;
        $qry_val_arr = array(
            utf8_decode($member['username']) ,
            getCryptHash('restya') ,
            utf8_decode($member['initials']) ,
            utf8_decode($member['fullName']) ,
            $member['is_send_newsletter'],
            $member['default_desktop_notification'],
            $member['is_list_notifications_enabled'],
            $member['is_card_notifications_enabled'],
            $member['is_card_members_notifications_enabled'],
            $member['is_card_labels_notifications_enabled'],
            $member['is_card_checklists_notifications_enabled'],
            $member['is_card_attachments_notifications_enabled'],
            'trello-' . utf8_decode($member['username']) . '@mailinator.com',
        );
        $user = pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO users (created, modified, role_id, username, email, password, is_active, is_email_confirmed, initials, full_name, is_send_newsletter, default_desktop_notification, is_list_notifications_enabled, is_card_notifications_enabled, is_card_members_notifications_enabled, is_card_labels_notifications_enabled, is_card_checklists_notifications_enabled, is_card_attachments_notifications_enabled) VALUES (now(), now(), 2, $1, $13, $2, true, true, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12) RETURNING id', $qry_val_arr));
        $user_id = $user['id'];
    } else {
        $user_id = $userExist['id'];
    }
    $board_user_role_id = 2;
    if (in_array($member['id'], $admin_user_id)) {
        $board_user_role_id = 1;
    }
    $query_val = array(
        $user_id,
        $new_board['id']
    );
    $is_board_user_exist = executeQuery('SELECT * FROM boards_users WHERE user_id = $1 and board_id = $2', $query_val);
    if (!$is_board_user_exist) {
        $qry_val_arr = array(
            $user_id,
            $new_board['id'],
            $board_user_role_id
        );
        pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO boards_users (created, modified, user_id, board_id, board_user_role_id) VALUES (now(), now(), $1, $2, $3) RETURNING id', $qry_val_arr));
    }
    $is_board_subscribers_exist = executeQuery('SELECT * FROM board_subscribers WHERE user_id = $1 and board_id = $2', $query_val);
    $auto_subscribe_on_board = (AUTO_SUBSCRIBE_ON_BOARD === 'Enabled') ? 'true' : false;
    if ($auto_subscribe_on_board && !$is_board_subscribers_exist) {
        $qry_val_arr = array(
            $user_id,
            $new_board['id'],
            true
        );
        pg_query_params($db_lnk, 'INSERT INTO board_subscribers (created, modified, user_id, board_id, is_subscribed) VALUES (now(), now(), $1, $2, $3)', $qry_val_arr);
    }
    return $user_id;
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
    global $r_debug, $db_lnk, $authUser, $_server_domain_url;
    $users = $lists = $cards = $cardLists = $listNames = array();
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
            utf8_decode($board['name']) ,
            (!empty($board['prefs']['backgroundColor'])) ? $board['prefs']['backgroundColor'] : null,
            $background_image,
            $background_pattern,
            $user_id,
            $board_visibility
        );
        $new_board = pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO boards (created, modified, name, background_color, background_picture_url, background_pattern_url, user_id, board_visibility) VALUES (now(), now(), $1, $2, $3, $4, $5, $6) RETURNING id', $qry_val_arr));
        $server = strtolower($_SERVER['SERVER_SOFTWARE']);
        if (strpos($server, 'apache') !== false) {
            ob_end_clean();
            header("Connection: close\r\n");
            header("Content-Encoding: none\r\n");
            ignore_user_abort(true); // optional
            ob_start();
            echo json_encode($new_board);
            $size = ob_get_length();
            header("Content-Length: $size");
            ob_end_flush(); // Strange behaviour, will not work
            flush(); // Unless both are called !
            ob_end_clean();
        } else {
            echo json_encode($new_board);
            fastcgi_finish_request();
        }
        $admin_user_id = array();
        if (!empty($board['members'])) {
            foreach ($board['memberships'] as $membership) {
                if ($membership['memberType'] == 'admin') {
                    $admin_user_id[] = $membership['idMember'];
                }
            }
        }
        if (is_plugin_enabled('r_custom_fields') && !empty($board['customFields'])) {
            foreach ($board['customFields'] as $customField) {
                $options = array();
                if ($customField['type'] === 'date') {
                    $customField['type'] = 'datetime';
                }
                if ($customField['type'] === 'list') {
                    foreach ($customField['options'] as $option) {
                        $options[] = $option['value']['text'];
                        $customFieldOptions[$option['id']] = $option['value']['text'];
                    }
                    $customField['type'] = 'dropdown';
                }
                $qry_val_arr = array(
                    $user_id,
                    $customField['type'],
                    $customField['name'],
                    implode(',', $options) ,
                    $customField['name'],
                    $customField['pos'],
                    $customField['display']['cardFront'],
                    $new_board['id']
                );
                $customFieldId = pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO custom_fields (created, modified, user_id, type, name, description, options, label, position, visibility, color, board_id) VALUES (now(), now(), $1, $2, $3, NULL, $4, $5, $6, $7, NULL, $8) RETURNING id', $qry_val_arr));
                $customFields[$customField['id']] = $customFieldId['id'];
            }
        }
        if (!empty($board['labelNames'])) {
            foreach ($board['labelNames'] as $label) {
                if (!empty($label['name'])) {
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
                    $default_email_notification = 0;
                    if (DEFAULT_EMAIL_NOTIFICATION === 'Periodically') {
                        $default_email_notification = 1;
                    } else if (DEFAULT_EMAIL_NOTIFICATION === 'Instantly') {
                        $default_email_notification = 2;
                    }
                    $member['is_send_newsletter'] = $default_email_notification;
                    $member['default_desktop_notification'] = (DEFAULT_DESKTOP_NOTIFICATION === 'Enabled') ? 'true' : 'false';
                    $member['is_list_notifications_enabled'] = IS_LIST_NOTIFICATIONS_ENABLED;
                    $member['is_card_notifications_enabled'] = IS_CARD_NOTIFICATIONS_ENABLED;
                    $member['is_card_members_notifications_enabled'] = IS_CARD_MEMBERS_NOTIFICATIONS_ENABLED;
                    $member['is_card_labels_notifications_enabled'] = IS_CARD_LABELS_NOTIFICATIONS_ENABLED;
                    $member['is_card_checklists_notifications_enabled'] = IS_CARD_CHECKLISTS_NOTIFICATIONS_ENABLED;
                    $member['is_card_attachments_notifications_enabled'] = IS_CARD_ATTACHMENTS_NOTIFICATIONS_ENABLED;
                    $qry_val_arr = array(
                        utf8_decode($member['username']) ,
                        getCryptHash('restya') ,
                        utf8_decode($member['initials']) ,
                        utf8_decode($member['fullName']) ,
                        $member['is_send_newsletter'],
                        $member['default_desktop_notification'],
                        $member['is_list_notifications_enabled'],
                        $member['is_card_notifications_enabled'],
                        $member['is_card_members_notifications_enabled'],
                        $member['is_card_labels_notifications_enabled'],
                        $member['is_card_checklists_notifications_enabled'],
                        $member['is_card_attachments_notifications_enabled'],
                        'trello-' . utf8_decode($member['username']) . '@mailinator.com',
                    );
                    $user = pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO users (created, modified, role_id, username, email, password, is_active, is_email_confirmed, initials, full_name, is_send_newsletter, default_desktop_notification, is_list_notifications_enabled, is_card_notifications_enabled, is_card_members_notifications_enabled, is_card_labels_notifications_enabled, is_card_checklists_notifications_enabled, is_card_attachments_notifications_enabled) VALUES (now(), now(), 2, $1, $13, $2, true, true, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12) RETURNING id', $qry_val_arr));
                    $users[$member['id']] = $user['id'];
                    if ($member['avatarUrl']) {
                        $mediadir = MEDIA_PATH . DS . 'User' . DS . $user['id'];
                        $save_path = 'User' . DS . $user['id'];
                        $save_path = str_replace('\\', '/', $save_path);
                        $filename = curlExecute($member['avatarUrl'] . '/170.png', 'get', $mediadir, 'image');
                        $path = $save_path . DS . $filename['file_name'];
                        $qry_val_arr = array(
                            $path,
                            $user['id']
                        );
                        pg_query_params($db_lnk, 'UPDATE users SET profile_picture_path = $1 WHERE id = $2', $qry_val_arr);
                    }
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
                $auto_subscribe_on_board = (AUTO_SUBSCRIBE_ON_BOARD === 'Enabled') ? 'true' : false;
                if ($auto_subscribe_on_board) {
                    $qry_val_arr = array(
                        $users[$member['id']],
                        $new_board['id'],
                        true
                    );
                    pg_query_params($db_lnk, 'INSERT INTO board_subscribers (created, modified, user_id, board_id, is_subscribed) VALUES (now(), now(), $1, $2, $3)', $qry_val_arr);
                }
            }
        }
        $qry_val_arr = array(
            $authUser['id'],
            $new_board['id'],
            1
        );
        pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO boards_users (created, modified, user_id, board_id, board_user_role_id) VALUES (now(), now(), $1, $2, $3) RETURNING id', $qry_val_arr));
        $auto_subscribe_on_board = (AUTO_SUBSCRIBE_ON_BOARD === 'Enabled') ? 'true' : false;
        if ($auto_subscribe_on_board) {
            $qry_val_arr = array(
                $authUser['id'],
                $new_board['id'],
                true
            );
            pg_query_params($db_lnk, 'INSERT INTO board_subscribers (created, modified, user_id, board_id, is_subscribed) VALUES (now(), now(), $1, $2, $3)', $qry_val_arr);
        }
        if (!empty($board['lists'])) {
            $i = 0;
            foreach ($board['lists'] as $list) {
                $i+= 1;
                $is_closed = ($list['closed']) ? 'true' : 'false';
                $qry_val_arr = array(
                    utf8_decode($list['name']) ,
                    $new_board['id'],
                    $i,
                    $user_id,
                    $is_closed
                );
                $_list = pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO lists (created, modified, name, board_id, position, user_id, is_archived) VALUES (now(), now(), $1, $2, $3, $4, $5) RETURNING id', $qry_val_arr));
                $lists[$list['id']] = $_list['id'];
                $listNames[$list['id']] = $list['name'];
            }
        }
        if (!empty($board['cards'])) {
            foreach ($board['cards'] as $card) {
                $is_closed = ($card['closed']) ? 'true' : 'false';
                $date = (!empty($card['due'])) ? $card['due'] : NULL;
                $qry_val_arr = array(
                    $new_board['id'],
                    $lists[$card['idList']],
                    utf8_decode($card['name']) ,
                    utf8_decode($card['desc']) ,
                    $is_closed,
                    $card['pos'],
                    $date,
                    $user_id
                );
                $_card = pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO cards (created, modified, board_id, list_id, name, description, is_archived, position, due_date, user_id) VALUES (now(), now(), $1, $2, $3, $4, $5, $6, $7, $8) RETURNING id', $qry_val_arr));
                $cards[$card['id']] = $_card['id'];
                $cardLists[$card['id']] = $lists[$card['idList']];
                if (!empty($card['labels'])) {
                    foreach ($card['labels'] as $label) {
                        if (!empty($label['name'])) {
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
                }
                if (!empty($card['attachments'])) {
                    foreach ($card['attachments'] as $attachment) {
                        $created = $modified = $attachment['date'];
                        if ($attachment['isUpload']) {
                            $mediadir = MEDIA_PATH . DS . 'Card' . DS . $_card['id'];
                            $save_path = 'Card' . DS . $_card['id'];
                            $save_path = str_replace('\\', '/', $save_path);
                            $filename = curlExecute($attachment['url'], 'get', $mediadir, 'image');
                            $path = $save_path . DS . $filename['file_name'];
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
                        } else {
                            $qry_val_arr = array(
                                $created,
                                $modified,
                                $_card['id'],
                                $attachment['url'],
                                'NULL',
                                $lists[$card['idList']],
                                $new_board['id'],
                                'NULL',
                                $attachment['url']
                            );
                            pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO card_attachments (created, modified, card_id, name, path, list_id, board_id, mimetype, link) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) RETURNING id', $qry_val_arr));
                        }
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
                if (is_plugin_enabled('r_custom_fields') && !empty($card['customFieldItems'])) {
                    foreach ($card['customFieldItems'] as $customFieldItem) {
                        if (!empty($customFieldItem['idValue'])) {
                            $value = $customFieldOptions[$customFieldItem['idValue']];
                        } else if (!empty($customFieldItem['value']['text'])) {
                            $value = $customFieldItem['value']['text'];
                        } else if (!empty($customFieldItem['value']['checked'])) {
                            $value = $customFieldItem['value']['checked'];
                        } else if (!empty($customFieldItem['value']['number'])) {
                            $value = $customFieldItem['value']['number'];
                        } else if (!empty($customFieldItem['value']['date'])) {
                            $date_arr = explode('T', $customFieldItem['value']['date']);
                            $time_arr = explode('.', $date_arr[1]);
                            $value = $date_arr[0] . 'T' . $time_arr[0];
                        }
                        $qry_val_arr = array(
                            $_card['id'],
                            $customFields[$customFieldItem['idCustomField']],
                            $value,
                            $new_board['id'],
                            $lists[$card['idList']]
                        );
                        pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO cards_custom_fields (created, modified, card_id, custom_field_id, value, board_id, list_id) VALUES (now(), now(), $1, $2, $3, $4, $5) RETURNING id', $qry_val_arr));
                    }
                }
            }
        }
        if (!empty($board['checklists'])) {
            $checklists = array();
            foreach ($board['checklists'] as $checklist) {
                $qry_val_arr = array(
                    utf8_decode($checklist['name']) ,
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
                            utf8_decode($checkItem['name']) ,
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
            $board['actions'] = array_msort($board['actions'], array(
                'date' => SORT_ASC
            ));
            foreach ($board['actions'] as $action) {
                $type = '';
                if ($action['type'] == 'commentCard') {
                    $type = 'add_comment';
                    $comment = $action['data']['text'];
                } else if ($action['type'] == 'addMemberToCard' && !empty($action['member'])) {
                    $type = 'add_card_user';
                    $memberName = '';
                    if (!empty($action['member'])) {
                        $memberName = $action['member']['fullName'];
                    }
                    $comment = sprintf(__l('##USER_NAME## added %s as member to the card ##CARD_LINK##') , $memberName);
                } else if ($action['type'] == 'createCard') {
                    $type = 'add_card';
                    $listName = '';
                    if (!empty($listNames[$action['data']['list']['id']])) {
                        $listName = utf8_decode($listNames[$action['data']['list']['id']]);
                    }
                    $comment = sprintf(__l('##USER_NAME## added card ##CARD_LINK## to list %s. ') , $listName);
                } else if ($action['type'] == 'createList') {
                    $type = 'add_list';
                    $listName = '';
                    if (!empty($listNames[$action['data']['list']['id']])) {
                        $listName = utf8_decode($listNames[$action['data']['list']['id']]);
                    }
                    $comment = sprintf(__l('##USER_NAME## added list %s.') , $listName);
                } else if ($action['type'] == 'createBoard') {
                    $type = 'add_board';
                    $comment = __l('##USER_NAME## created board');
                } else if ($action['type'] == 'updateBoard') {
                    if (!empty($action['data']['board']['closed']) && isset($action['data']['board']['closed'])) {
                        $type = 'close_board';
                        $comment = __l('##USER_NAME## closed ##BOARD_NAME## board.');
                    } else if (!empty($action['data']['board']['closed'])) {
                        $type = 'reopen_board';
                        $comment = __l('##USER_NAME## reopened ##BOARD_NAME## board.');
                    } else if (!empty($action['data']['board']['prefs']['permissionLevel'])) {
                        $type = 'change_visibility';
                        $comment = sprintf(__l('##USER_NAME## changed visibility to %s') , $action['data']['board']['prefs']['permissionLevel']);
                    } else if (!empty($action['data']['board']['prefs']['background'])) {
                        $type = 'change_background';
                        $comment = sprintf(__l('##USER_NAME## changed backgound to board %s') , $action['data']['board']['prefs']['background']);
                    } else if (!empty($action['data']['board']['name'])) {
                        $type = 'edit_board';
                        $comment = __l('##USER_NAME## renamed ##BOARD_NAME## board.');
                    }
                } else if ($action['type'] == 'updateList') {
                    if (isset($action['data']['list']['closed'])) {
                        $type = 'archive_list';
                        $comment = __l('##USER_NAME## archived list ##LIST_NAME##');
                    } else if (!empty($action['data']['list']['pos'])) {
                        $type = 'change_list_position';
                        $listName = '';
                        if (!empty($listNames[$action['data']['list']['id']])) {
                            $listName = utf8_decode($listNames[$action['data']['list']['id']]);
                        }
                        $comment = sprintf(__l('##USER_NAME## changed list %s position.') , $listName);
                    } else if (!empty($action['data']['list']['name'])) {
                        $type = 'edit_list';
                        $comment = '##USER_NAME## renamed this list.';
                    }
                } else if ($action['type'] == 'updateCard') {
                    if (!empty($action['data']['card']['pos'])) {
                        $type = 'change_card_position';
                        $comment = __l('##USER_NAME## moved this card to different position.');
                    } else if (!empty($action['data']['card']['idList'])) {
                        $type = 'moved_list_card';
                        $listBeforeName = '';
                        if (!empty($listNames[$action['data']['listBefore']['id']])) {
                            $listBeforeName = utf8_decode($listNames[$action['data']['listBefore']['id']]);
                        }
                        $listAfterName = '';
                        if (!empty($listNames[$action['data']['listAfter']['id']])) {
                            $listAfterName = utf8_decode($listNames[$action['data']['listAfter']['id']]);
                        }
                        $comment = sprintf(__l('##USER_NAME## moved cards FROM %s to  %s') , $listBeforeName, $listAfterName);
                    } else if (!empty($action['data']['card']['due'])) {
                        $type = 'add_card_duedate';
                        $comment = __l('##USER_NAME## SET due date to the card ##CARD_LINK##');
                    } else if (!empty($action['data']['card']['desc'])) {
                        $type = 'add_card_desc';
                        $comment = __l('##USER_NAME## added card description in the card ##CARD_LINK## - ##DESCRIPTION##');
                    } else if (!empty($action['data']['card']['name'])) {
                        $type = 'edit_card';
                        $comment = sprintf(__l('##USER_NAME## edited %s card in this board.') , utf8_decode($action['data']['card']['name']));
                    }
                } else if ($action['type'] == 'addChecklistToCard') {
                    $type = 'add_card_checklist';
                    $comment = __l('##USER_NAME## added checklist ##CHECKLIST_NAME## to the card ##CARD_LINK##');
                } else if ($action['type'] == 'deleteAttachmentFromCard') {
                    $type = 'delete_card_attachment';
                    $comment = __l('##USER_NAME## deleted attachment from card ##CARD_LINK##');
                } else if ($action['type'] == 'addAttachmentToCard') {
                    $type = 'add_card_attachment';
                    $comment = __l('##USER_NAME## added attachment to the card ##CARD_LINK##');
                } else if ($action['type'] == 'addMemberToBoard') {
                    $type = 'add_board_user';
                    $comment = __l('##USER_NAME## added member to board');
                } else if ($action['type'] == 'removeChecklistFromCard') {
                    $type = 'delete_checklist';
                    $comment = __l('##USER_NAME## deleted checklist ##CHECKLIST_NAME## from card ##CARD_LINK##');
                }
                if (!empty($type)) {
                    $comment = utf8_decode($comment);
                    $created = $modified = $action['date'];
                    if (!empty($action['data']['list']['id'])) {
                        if (array_key_exists($action['data']['list']['id'], $lists)) {
                            $lists_key = $lists[$action['data']['list']['id']];
                        } else {
                            $lists_key = '';
                        }
                    }
                    if (!empty($action['data']['card']['id'])) {
                        if (array_key_exists($action['data']['card']['id'], $cards)) {
                            $cards_key = $cards[$action['data']['card']['id']];
                            $lists_key = $cardLists[$action['data']['card']['id']];
                        } else {
                            $cards_key = '';
                        }
                    }
                    if (!array_key_exists($action['idMemberCreator'], $users) || empty($users[$action['idMemberCreator']])) {
                        if (!empty($action['memberCreator'])) {
                            $users[$action['idMemberCreator']] = createTrelloMember($action['memberCreator'], $admin_user_id, $new_board);
                        } else {
                            $users[$action['idMemberCreator']] = 1;
                        }
                    }
                    if (empty($lists_key) && empty($cards_key)) {
                        $qry_val_arr = array(
                            $created,
                            $modified,
                            $new_board['id'],
                            $users[$action['idMemberCreator']],
                            $type,
                            $comment,
                            $_GET['token']
                        );
                        $activity = pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO activities (created, modified, board_id, user_id, type, comment, token) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING id', $qry_val_arr));
                    } else if (!empty($lists_key) && empty($cards_key)) {
                        $qry_val_arr = array(
                            $created,
                            $modified,
                            $new_board['id'],
                            $lists_key,
                            $users[$action['idMemberCreator']],
                            $type,
                            $comment,
                            $_GET['token']
                        );
                        $activity = pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO activities (created, modified, board_id, list_id, user_id, type, comment, token) VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING id', $qry_val_arr));
                    } else if (empty($lists_key) && !empty($cards_key)) {
                        $qry_val_arr = array(
                            $created,
                            $modified,
                            $new_board['id'],
                            $cards_key,
                            $users[$action['idMemberCreator']],
                            $type,
                            $comment,
                            $_GET['token']
                        );
                        $activity = pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO activities (created, modified, board_id, card_id, user_id, type, comment, token) VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING id', $qry_val_arr));
                    } else if (!empty($lists_key) && !empty($cards_key)) {
                        $qry_val_arr = array(
                            $created,
                            $modified,
                            $new_board['id'],
                            $lists_key,
                            $cards_key,
                            $users[$action['idMemberCreator']],
                            $type,
                            $comment,
                            $_GET['token']
                        );
                        $activity = pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO activities (created, modified, board_id, list_id, card_id, user_id, type, comment, token) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) RETURNING id', $qry_val_arr));
                    }
                    if (!empty($activity)) {
                        $id_converted = base_convert($activity['id'], 10, 36);
                        $materialized_path = sprintf("%08s", $id_converted);
                        $path = 'P' . $activity['id'];
                        $depth = 0;
                        $root = $activity['id'];
                        $freshness_ts = $created;
                        $qry_val_arr = array(
                            $materialized_path,
                            $path,
                            $depth,
                            $root,
                            $freshness_ts,
                            $activity['id']
                        );
                        pg_query_params($db_lnk, 'UPDATE activities SET materialized_path = $1, path = $2, depth = $3, root = $4, freshness_ts = $5 WHERE id = $6', $qry_val_arr);
                    }
                }
            }
        }
        if (!empty($cards)) {
            foreach ($cards as $value) {
                $conditions = array(
                    $value
                );
                $activity_count = executeQuery("SELECT COUNT(id) as total_count FROM activities WHERE type = 'add_comment' AND card_id = $1", $conditions);
                $activity_count = (!empty($activity_count)) ? $activity_count['total_count'] : 0;
                $qry_val_arr = array(
                    $activity_count,
                    $value
                );
                pg_query_params($db_lnk, 'UPDATE cards SET comment_count = $1 WHERE id = $2', $qry_val_arr);
            }
        }
        boardImportMailSend('Trello', $new_board);
        return $new_board;
    }
}
/**
 * Import Kantree board
 *
 * @param array $board Boards from kantree
 *
 * @return mixed
 */
function importKantreeBoard($jsonArr = array())
{
    global $r_debug, $db_lnk, $authUser, $_server_domain_url;
    $users = $userNames = $lists = $listNames = $cards = $cardLists = $labels = array();
    if (!empty($jsonArr)) {
        foreach ($jsonArr as $json) {
            if (!empty($json['board_created'])) {
                $board_name = $json['title'];
                if (!empty($json['stream'])) {
                    foreach ($json['stream'] as $group) {
                        if (!empty($group['project_id'])) {
                            $board['lists'][] = $group;
                        } elseif (empty($group['project_id'])) {
                            $board['labelNames'][] = $group;
                        }
                    }
                }
            } else {
                $board['cards'][] = $json;
            }
            if (!empty($json['groups'])) {
                foreach ($json['groups'] as $group) {
                    if ($group['scope'] == 'project') {
                        $board['lists'][] = $group;
                    }
                }
            }
            if (!empty($json['stream'])) {
                foreach ($json['stream'] as $stream) {
                    $board['actions'][] = $stream;
                }
            }
        }
        if (!empty($board_name)) {
            $user_id = $authUser['id'];
            $qry_val_arr = array(
                utf8_decode($board_name) ,
                $user_id,
                0
            );
            $new_board = pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO boards (created, modified, name, user_id, board_visibility) VALUES (now(), now(), $1, $2, $3) RETURNING id', $qry_val_arr));
            $server = strtolower($_SERVER['SERVER_SOFTWARE']);
            if (strpos($server, 'apache') !== false) {
                ob_end_clean();
                header("Connection: close\r\n");
                header("Content-Encoding: none\r\n");
                ignore_user_abort(true); // optional
                ob_start();
                echo json_encode($new_board);
                $size = ob_get_length();
                header("Content-Length: $size");
                ob_end_flush(); // Strange behaviour, will not work
                flush(); // Unless both are called !
                ob_end_clean();
            } else {
                echo json_encode($new_board);
                fastcgi_finish_request();
            }
            // insert current user as board member
            $qry_val_arr = array(
                $authUser['id'],
                $new_board['id'],
                1
            );
            pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO boards_users (created, modified, user_id, board_id, board_user_role_id) VALUES (now(), now(), $1, $2, $3) RETURNING id', $qry_val_arr));
            $auto_subscribe_on_board = (AUTO_SUBSCRIBE_ON_BOARD === 'Enabled') ? 'true' : false;
            if ($auto_subscribe_on_board) {
                $qry_val_arr = array(
                    $authUser['id'],
                    $new_board['id'],
                    true
                );
                pg_query_params($db_lnk, 'INSERT INTO board_subscribers (created, modified, user_id, board_id, is_subscribed) VALUES (now(), now(), $1, $2, $3)', $qry_val_arr);
            }
            // insert labels
            if (!empty($board['labelNames'])) {
                foreach ($board['labelNames'] as $label) {
                    if (!empty($label['object']['value'])) {
                        $qry_val_arr = array(
                            utf8_decode($label['object']['value'])
                        );
                        $check_label = executeQuery('SELECT id FROM labels WHERE name = $1', $qry_val_arr);
                        if (empty($check_label)) {
                            $qry_val_arr = array(
                                utf8_decode($label['object']['value'])
                            );
                            $check_label = pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO labels (created, modified, name) VALUES (now(), now(), $1) RETURNING id', $qry_val_arr));
                        }
                        $labels[$label['object']['id']] = $check_label['id'];
                    }
                }
            }
            if (!empty($board['lists'])) {
                $i = 0;
                foreach ($board['lists'] as $list) {
                    $list['id'] = !empty($list['title']) ? $list['id'] : $list['object']['id'];
                    $list['name'] = !empty($list['title']) ? $list['title'] : $list['object']['value'];
                    if (!in_array($list['name'], $listNames)) {
                        $i+= 1;
                        $qry_val_arr = array(
                            utf8_decode($list['name']) ,
                            $new_board['id'],
                            $i,
                            $user_id
                        );
                        $_list = pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO lists (created, modified, name, board_id, position, user_id) VALUES (now(), now(), $1, $2, $3, $4) RETURNING id', $qry_val_arr));
                        $lists[$list['id']] = $_list['id'];
                        $listNames[$list['id']] = $list['name'];
                    }
                }
            }
            if (!empty($board['cards'])) {
                $i = 0;
                foreach ($board['cards'] as $card) {
                    $i+= 1;
                    if (!empty($card['attributes'])) {
                        foreach ($card['attributes'] as $attribute) {
                            if ($attribute['name'] == 'Description') {
                                $card['desc'] = $attribute['value'];
                            } elseif ($attribute['name'] == 'Due Date') {
                                $card['due'] = $attribute['value']['end'];
                                if (!empty($attribute['value']['start'])) {
                                    $custom_fields['start_date'] = $attribute['value']['start'];
                                    $card['custom_fields'] = json_encode($custom_fields);
                                }
                            } elseif ($attribute['name'] == 'Attachments') {
                                foreach ($attribute['value'] as $value) {
                                    $card['attachments'][] = $value;
                                }
                            } elseif ($attribute['name'] == 'Assignees') {
                                foreach ($attribute['value'] as $value) {
                                    $card['idMembers'][] = $value;
                                }
                            }
                        }
                    }
                    if (!empty($card['groups'])) {
                        foreach ($card['groups'] as $group) {
                            if ($group['scope'] == 'project') {
                                $card['idList'] = $group['id'];
                            } elseif ($group['scope'] == 'org') {
                                $card['labels'][] = $group['id'];
                            }
                        }
                    }
                    $is_closed = !empty($card['is_archived']) ? 'true' : 'false';
                    $date = (!empty($card['due'])) ? $card['due'] : null;
                    $desc = (!empty($card['desc'])) ? utf8_decode($card['desc']) : null;
                    $qry_val_arr = array(
                        $new_board['id'],
                        $lists[$card['idList']],
                        utf8_decode($card['title']) ,
                        $desc,
                        $is_closed,
                        $i,
                        $date,
                        $user_id
                    );
                    $_card = pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO cards (created, modified, board_id, list_id, name, description, is_archived, position, due_date, user_id) VALUES (now(), now(), $1, $2, $3, $4, $5, $6, $7, $8) RETURNING id', $qry_val_arr));
                    $cards[$card['id']] = $_card['id'];
                    $cardLists[$card['id']] = $lists[$card['idList']];
                    if (!empty($card['labels'])) {
                        foreach ($card['labels'] as $label_id) {
                            $qry_val_arr = array(
                                $new_board['id'],
                                $lists[$card['idList']],
                                $_card['id'],
                                $labels[$label_id]
                            );
                            pg_query_params($db_lnk, 'INSERT INTO cards_labels (created, modified, board_id, list_id, card_id, label_id) VALUES (now(), now(), $1, $2, $3, $4)', $qry_val_arr);
                        }
                    }
                    if (!empty($card['attachments'])) {
                        foreach ($card['attachments'] as $attachment) {
                            $mediadir = MEDIA_PATH . DS . 'Card' . DS . $_card['id'];
                            $save_path = 'Card' . DS . $_card['id'];
                            $save_path = str_replace('\\', '/', $save_path);
                            $filename = curlExecute($attachment['url'], 'get', $mediadir, 'image');
                            $path = $save_path . DS . $filename['file_name'];
                            $qry_val_arr = array(
                                $new_board['id'],
                                $lists[$card['idList']],
                                $_card['id'],
                                $filename['file_name'],
                                $path,
                                $attachment['mimetype']
                            );
                            pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO card_attachments (created, modified, board_id, list_id, card_id, name, path, mimetype) VALUES (now(), now(), $1, $2, $3, $4, $5, $6, $7, $8) RETURNING id', $qry_val_arr));
                        }
                    }
                    if (!empty($card['idMembers'])) {
                        foreach ($card['idMembers'] as $cardMember) {
                            if (empty($users[$cardMember['id']])) {
                                $member = array(
                                    'id' => $cardMember['id'],
                                    'username' => $cardMember['username'],
                                    'fullName' => $cardMember['display_name'],
                                    'avatarUrl' => $cardMember['avatar'],
                                    'initials' => strtoupper(substr($cardMember['display_name'], 0, 1))
                                );
                                $users = importMember($member, $new_board, 'kantree');
                                $userNames[$cardMember['id']] = $cardMember['display_name'];
                            }
                            $qry_val_arr = array(
                                $_card['id'],
                                $users[$cardMember['id']]
                            );
                            pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO cards_users (created, modified, card_id, user_id) VALUES (now(), now(), $1, $2) RETURNING id', $qry_val_arr));
                        }
                    }
                }
            }
            if (!empty($board['actions'])) {
                $type = $comment = '';
                $board['actions'] = array_msort($board['actions'], array(
                    'date' => SORT_ASC
                ));
                $i = 0;
                $is_continue_to_next = 0;
                foreach ($board['actions'] as $action) {
                    if (!empty($is_continue_to_next)) {
                        $is_continue_to_next = 0;
                        $i++;
                        continue;
                    }
                    $lists_key = $cards_key = NULL;
                    $type = '';
                    if ($action['stream_type'] == 'activity') {
                        if ($action['verb'] == 'CREATE' && $action['object']['type'] == 'Card') {
                            $type = 'add_card';
                            //$list_id = $board['actions'][$i + 1]['target']['id'];
                            //$listName = (!empty($listNames[$list_id])) ? $listNames[$list_id] : '';
                            // $lists_key = $lists[$list_id];
                            $lists_key = $cardLists[$action['object']['id']];
                            $cards_key = $cards[$action['object']['id']];
                            $comment = sprintf(__l('##USER_NAME## added card ##CARD_LINK## to list %s. ') , $listName);
                            $is_continue_to_next = 1;
                        } elseif ($action['verb'] == 'UPDATE' && $action['target']['type'] == 'Card') {
                            $lists_key = $cardLists[$action['target']['id']];
                            $cards_key = $cards[$action['target']['id']];
                            if ($action['object']['value'] == 'Description') {
                                $type = 'edit_card_desc';
                                if ($action['message'] == '{actor} cleared {object} on {target}') {
                                    $comment = __l('##USER_NAME## removed card description from ##CARD_LINK##');
                                } else {
                                    $comment = __l('##USER_NAME## updated card description in ##CARD_LINK##');
                                }
                            } elseif ($action['object']['value'] == 'Assignees') {
                                $memberName = (!empty($memberNames[$action['sub_object']['id']])) ? $memberNames[$action['sub_object']['id']] : '';
                                if ($action['message'] == '{actor} unassigned {sub_object} from {object} on {target}') {
                                    $type = 'delete_card_users';
                                    $comment = __l('##USER_NAME## deleted member from card ##CARD_LINK##');
                                } else {
                                    $type = 'add_card_user';
                                    $comment = sprintf(__l('##USER_NAME## added %s as member to the card ##CARD_LINK##') , $memberName);
                                }
                            } elseif ($action['object']['value'] == 'Due Date') {
                                if ($action['message'] == '{actor} cleared {object} on {target}') {
                                    $type = 'delete_card_duedate';
                                    $comment = __l('Due date was removed to the card ##CARD_LINK##');
                                } else {
                                    $type = 'add_card_duedate';
                                    $comment = __l('##USER_NAME## SET due date to the card ##CARD_LINK##');
                                }
                            } elseif ($action['object']['value'] == 'Attachments') {
                                if ($action['message'] == '{actor} removed all files from {object} in {target}') {
                                    $type = 'delete_card_attachment';
                                    $comment = __l('##USER_NAME## deleted attachment from card ##CARD_LINK##');
                                } else {
                                    $type = 'add_card_attachment';
                                    $comment = __l('##USER_NAME## added attachment to the card ##CARD_LINK##');
                                }
                            } elseif (!empty($action['origin'])) {
                                $type = 'edit_card';
                                $comment = sprintf(__l('##USER_NAME## edited %s card in this board.') , $action['target']['value']);
                            }
                        } elseif ($action['verb'] == 'ARCHIVE' && $action['object']['type'] == 'Card') {
                            $lists_key = $cardLists[$action['object']['id']];
                            $cards_key = $cards[$action['object']['id']];
                            $comment = __l('##USER_NAME## archived card ##CARD_LINK##');
                            $activity_type = 'archived_card';
                        } elseif ($action['verb'] == 'MOVE' && $action['target']['type'] == 'CardGroup') {
                            $lists_key = $cardLists[$action['object']['id']];
                            $cards_key = $cards[$action['object']['id']];
                            if (!empty($labels[$action['target']['id']])) {
                                if ($action['message'] == '{actor} removed {object} from {target}') {
                                    $type = 'delete_card_label';
                                    $comment = sprintf(__l('##USER_NAME## removed label in the card ##CARD_LINK## - %s') , $action['target']['value']);
                                } else {
                                    $type = 'add_card_label';
                                    $comment = __l('##USER_NAME## added label to the card ##CARD_LINK## - ##LABEL_NAME##');
                                }
                            } else {
                                $type = 'moved_list_card';
                                $comment = sprintf(__l('##USER_NAME## moved card to list %s') , $action['target']['value']);
                            }
                        } elseif ($action['verb'] == 'CREATE' && $action['object']['type'] == 'CardGroup' && !empty($action['project_id'])) {
                            $type = 'add_list';
                            $comment = sprintf(__l('##USER_NAME## added list %s') , $action['object']['value']);
                        }
                    } elseif ($action['stream_type'] == 'comment') {
                        $lists_key = $cardLists[$action['card_id']];
                        $cards_key = $cards[$action['card_id']];
                        $type = 'add_comment';
                        $comment = $action['message'];
                    }
                    if (!empty($type)) {
                        $comment = utf8_decode($comment);
                        $created = $modified = date('Y-m-d H:i:s', $action['date']);
                        $qry_val_arr = array(
                            $created,
                            $modified,
                            $new_board['id'],
                            $lists_key,
                            $cards_key,
                            $users[$action['actor']['id']],
                            $type,
                            $comment,
                            $_GET['token']
                        );
                        $activity = pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO activities (created, modified, board_id, list_id, card_id, user_id, type, comment, token) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) RETURNING id', $qry_val_arr));
                        if (!empty($activity)) {
                            $id_converted = base_convert($activity['id'], 10, 36);
                            $materialized_path = sprintf("%08s", $id_converted);
                            $path = 'P' . $activity['id'];
                            $depth = 0;
                            $root = $activity['id'];
                            $freshness_ts = $created;
                            $qry_val_arr = array(
                                $materialized_path,
                                $path,
                                $depth,
                                $root,
                                $freshness_ts,
                                $activity['id']
                            );
                            pg_query_params($db_lnk, 'UPDATE activities SET materialized_path = $1, path = $2, depth = $3, root = $4, freshness_ts = $5 WHERE id = $6', $qry_val_arr);
                        }
                    }
                    $i++;
                }
            }
            if (!empty($cards)) {
                foreach ($cards as $value) {
                    $conditions = array(
                        $value
                    );
                    $activity_count = executeQuery("SELECT COUNT(id) as total_count FROM activities WHERE type = 'add_comment' AND card_id = $1", $conditions);
                    $activity_count = (!empty($activity_count)) ? $activity_count['total_count'] : 0;
                    $qry_val_arr = array(
                        $activity_count,
                        $value
                    );
                    pg_query_params($db_lnk, 'UPDATE cards SET comment_count = $1 WHERE id = $2', $qry_val_arr);
                }
            }
            boardImportMailSend('Kantree', $new_board);
            return $new_board;
        }
    }
}
/**
 * Import Taiga board
 *
 * @param array $board Boards from taiga
 *
 * @return mixed
 */
function importTaigaBoard($board = array())
{
    global $r_debug, $db_lnk, $authUser, $_server_domain_url;
    $users = $userNames = $lists = $listNames = $cards = $cardLists = $labels = array();
    $board['timeline'] = array_msort($board['timeline'], array(
        'created' => SORT_ASC
    ));
    if (!empty($board)) {
        $user_id = $authUser['id'];
        $qry_val_arr = array(
            utf8_decode($board['name']) ,
            !empty($board['is_private']) ? 0 : 2,
            $user_id
        );
        $new_board = pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO boards (created, modified, name, board_visibility, user_id) VALUES (now(), now(), $1, $2, $3) RETURNING id', $qry_val_arr));
        $server = strtolower($_SERVER['SERVER_SOFTWARE']);
        if (strpos($server, 'apache') !== false) {
            ob_end_clean();
            header("Connection: close\r\n");
            header("Content-Encoding: none\r\n");
            ignore_user_abort(true); // optional
            ob_start();
            echo json_encode($new_board);
            $size = ob_get_length();
            header("Content-Length: $size");
            ob_end_flush(); // Strange behaviour, will not work
            flush(); // Unless both are called !
            ob_end_clean();
        } else {
            echo json_encode($new_board);
            fastcgi_finish_request();
        }
        // insert current user as board member
        $qry_val_arr = array(
            $authUser['id'],
            $new_board['id'],
            1
        );
        pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO boards_users (created, modified, user_id, board_id, board_user_role_id) VALUES (now(), now(), $1, $2, $3) RETURNING id', $qry_val_arr));
        $auto_subscribe_on_board = (AUTO_SUBSCRIBE_ON_BOARD === 'Enabled') ? 'true' : false;
        if ($auto_subscribe_on_board) {
            $qry_val_arr = array(
                $authUser['id'],
                $new_board['id'],
                true
            );
            pg_query_params($db_lnk, 'INSERT INTO board_subscribers (created, modified, user_id, board_id, is_subscribed) VALUES (now(), now(), $1, $2, $3)', $qry_val_arr);
        }
        // insert labels
        if (!empty($board['tags_colors'])) {
            foreach ($board['tags_colors'] as $label) {
                if (!empty($label[0])) {
                    $qry_val_arr = array(
                        utf8_decode($label[0])
                    );
                    $check_label = executeQuery('SELECT id FROM labels WHERE name = $1', $qry_val_arr);
                    if (empty($check_label)) {
                        $qry_val_arr = array(
                            utf8_decode($label[0])
                        );
                        $check_label = pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO labels (created, modified, name) VALUES (now(), now(), $1) RETURNING id', $qry_val_arr));
                    }
                    $labels[$label[0]] = $check_label['id'];
                }
            }
        }
        // insert members
        if (!empty($board['memberships'])) {
            foreach ($board['memberships'] as $membership) {
                $member = array(
                    'id' => $membership['email'],
                    'username' => $membership['email'],
                    'email' => $membership['email'],
                    'fullName' => email2name($membership['email']) ,
                    'initials' => strtoupper(substr($membership['email'], 0, 1))
                );
                $users = importMember($member, $new_board, 'taiga');
                //$userNames[$membership['id']] = $member['fullName'];
                $userNames[$membership['email']] = $users[$membership['email']];
            }
        }
        if (!empty($board['us_statuses'])) {
            foreach ($board['us_statuses'] as $list) {
                if (!in_array($list['name'], $listNames)) {
                    $qry_val_arr = array(
                        utf8_decode($list['name']) ,
                        $new_board['id'],
                        $list['order'],
                        $list['color'],
                        $user_id
                    );
                    $_list = pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO lists (created, modified, name, board_id, position, color, user_id) VALUES (now(), now(), $1, $2, $3, $4, $5) RETURNING id', $qry_val_arr));
                    $lists[$list['name']] = $_list['id'];
                    $listNames[$list['name']] = $list['name'];
                }
            }
        }
        if (!empty($board['user_stories'])) {
            $i = 0;
            foreach ($board['user_stories'] as $card) {
                $i+= 1;
                $is_closed = !empty($card['is_closed']) ? 'true' : 'false';
                $date = (!empty($card['due'])) ? $card['due_date'] : null;
                $qry_val_arr = array(
                    $new_board['id'],
                    $lists[$card['status']],
                    utf8_decode($card['subject']) ,
                    utf8_decode($card['description']) ,
                    $is_closed,
                    $i,
                    $date,
                    $user_id
                );
                $_card = pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO cards (created, modified, board_id, list_id, name, description, is_archived, position, due_date, user_id) VALUES (now(), now(), $1, $2, $3, $4, $5, $6, $7, $8) RETURNING id', $qry_val_arr));
                $cards[$card['ref']] = $_card['id'];
                $cardLists[$card['ref']] = $lists[$card['status']];
                if (!empty($card['tags'])) {
                    foreach ($card['tags'] as $label) {
                        $qry_val_arr = array(
                            $new_board['id'],
                            $lists[$card['status']],
                            $_card['id'],
                            $labels[$label]
                        );
                        pg_query_params($db_lnk, 'INSERT INTO cards_labels (created, modified, board_id, list_id, card_id, label_id) VALUES (now(), now(), $1, $2, $3, $4)', $qry_val_arr);
                    }
                }
                if (!empty($card['attachments'])) {
                    foreach ($card['attachments'] as $attachment) {
                        $mediadir = MEDIA_PATH . DS . 'Card' . DS . $_card['id'];
                        $save_path = MEDIA_PATH . DS . 'Card' . DS . $_card['id'];
                        $save_path = str_replace('\\', '/', $save_path);
                        $path = $save_path . DS . $attachment['name'];
                        $fh = fopen($path, 'w');
                        fwrite($fh, $attachment['attached_file']['data']);
                        fclose($fh);
                        $qry_val_arr = array(
                            $new_board['id'],
                            $lists[$card['status']],
                            $_card['id'],
                            $attachment['name'],
                            $path,
                            $attachment['mimetype']
                        );
                        pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO card_attachments (created, modified, board_id, list_id, card_id, name, path, mimetype) VALUES (now(), now(), $1, $2, $3, $4, $5, $6) RETURNING id', $qry_val_arr));
                    }
                }
                if (!empty($card['assigned_users'])) {
                    foreach ($card['assigned_users'] as $cardMember) {
                        $qry_val_arr = array(
                            $_card['id'],
                            $userNames[$cardMember]
                        );
                        pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO cards_users (created, modified, card_id, user_id) VALUES (now(), now(), $1, $2) RETURNING id', $qry_val_arr));
                    }
                }
            }
        }
        if (!empty($board['timeline'])) {
            $type = $comment = '';
            $board['timeline'] = array_msort($board['timeline'], array(
                'created' => SORT_ASC
            ));
            foreach ($board['timeline'] as $action) {
                $lists_key = $cards_key = NULL;
                $type = '';
                if ($action['event_type'] == 'userstories.userstory.change') {
                    $lists_key = $cardLists[$action['data']['userstory']['ref']];
                    $cards_key = $cards[$action['data']['userstory']['ref']];
                    if (isset($action['data']['values_diff']['attachments']) && !empty($action['data']['values_diff']['attachments'])) {
                        if ($action['data']['values_diff']['attachments']['deleted']) {
                            $type = 'delete_card_attachment';
                            $comment = __l('##USER_NAME## deleted attachment from card ##CARD_LINK##');
                        } elseif ($action['data']['values_diff']['attachments']['new']) {
                            $type = 'add_card_attachment';
                            $comment = __l('##USER_NAME## added attachment to the card ##CARD_LINK##');
                        }
                    } elseif (isset($action['data']['values_diff']['assigned_users']) && !empty($action['data']['values_diff']['assigned_users'])) {
                        if ($action['data']['values_diff']['assigned_users'][0]) {
                            $type = 'delete_card_users';
                            $comment = __l('##USER_NAME## deleted member from card ##CARD_LINK##');
                        } else {
                            $type = 'add_card_user';
                            $comment = sprintf(__l('##USER_NAME## added %s as member to the card ##CARD_LINK##') , $action['data']['values_diff']['assigned_users'][1]);
                        }
                    } elseif (isset($action['data']['values_diff']['tags']) && !empty($action['data']['values_diff']['tags'])) {
                        if ($action['data']['values_diff']['tags'][0][0]) {
                            $type = 'add_card_label';
                            $comment = sprintf(__l('##USER_NAME## added label to the card ##CARD_LINK## - %s') , $action['data']['values_diff']['tags'][0][0]);
                        } else {
                            $type = 'delete_card_label';
                            $comment = sprintf(__l('##USER_NAME## removed label in the card ##CARD_LINK## - %s') , $action['data']['values_diff']['tags'][1][0]);
                        }
                    } elseif (isset($action['data']['values_diff']['description_diff']) && !empty($action['data']['values_diff']['description_diff'])) {
                        $type = 'edit_card_desc';
                        $comment = __l('##USER_NAME## updated description on the card ##CARD_LINK##');
                    } elseif (isset($action['data']['values_diff']['subject']) && !empty($action['data']['values_diff']['subject'])) {
                        $type = 'edit_card';
                        $comment = sprintf(__l('##USER_NAME## edited %s card in this board.') , utf8_decode($action['data']['values_diff']['subject'][1]));
                    } elseif (isset($action['data']['values_diff']['status']) && !empty($action['data']['values_diff']['status'])) {
                        $type = 'add_list';
                        $comment = sprintf(__l('##USER_NAME## added list %s') , $action['data']['values_diff']['status'][1]);
                    } elseif (isset($action['data']['values_diff']['due_date']) && !empty($action['data']['values_diff']['due_date'])) {
                        if ($action['data']['values_diff']['due_date'][0]) {
                            $type = 'delete_card_duedate';
                            $comment = __l('Due date was removed to the card ##CARD_LINK##');
                        } else {
                            $type = 'add_card_duedate';
                            $comment = __l('##USER_NAME## SET due date to the card ##CARD_LINK##');
                        }
                    }
                }
                if (!empty($type)) {
                    $comment = utf8_decode($comment);
                    $created = $modified = date('Y-m-d H:i:s', strtotime($action['created']));
                    $qry_val_arr = array(
                        $created,
                        $modified,
                        $new_board['id'],
                        $lists_key,
                        $cards_key,
                        $userNames[$action['data']['user']['email']],
                        $type,
                        $comment,
                        $_GET['token']
                    );
                    $activity = pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO activities (created, modified, board_id, list_id, card_id, user_id, type, comment, token) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) RETURNING id', $qry_val_arr));
                    if (!empty($activity)) {
                        $id_converted = base_convert($activity['id'], 10, 36);
                        $materialized_path = sprintf("%08s", $id_converted);
                        $path = 'P' . $activity['id'];
                        $depth = 0;
                        $root = $activity['id'];
                        $freshness_ts = $created;
                        $qry_val_arr = array(
                            $materialized_path,
                            $path,
                            $depth,
                            $root,
                            $freshness_ts,
                            $activity['id']
                        );
                        pg_query_params($db_lnk, 'UPDATE activities SET materialized_path = $1, path = $2, depth = $3, root = $4, freshness_ts = $5 WHERE id = $6', $qry_val_arr);
                    }
                }
                $i++;
            }
        }
        if (!empty($cards)) {
            foreach ($cards as $value) {
                $conditions = array(
                    $value
                );
                $activity_count = executeQuery("SELECT COUNT(id) as total_count FROM activities WHERE type = 'add_comment' AND card_id = $1", $conditions);
                $activity_count = (!empty($activity_count)) ? $activity_count['total_count'] : 0;
                $qry_val_arr = array(
                    $activity_count,
                    $value
                );
                pg_query_params($db_lnk, 'UPDATE cards SET comment_count = $1 WHERE id = $2', $qry_val_arr);
            }
        }
        boardImportMailSend('Taiga', $new_board);
        return $new_board;
    }
}
/**
 * Import Wekan board
 *
 * @param array $board Boards from trello
 *
 * @return mixed
 */
function importWekanBoard($board = array())
{
    set_time_limit(1800);
    global $r_debug, $db_lnk, $authUser, $_server_domain_url;
    $lists_data = $comments_data = $user_data = $users = $lists = $cards = array();
    if (!empty($board)) {
        $user_id = $authUser['id'];
        $board_visibility = 0;
        if ($board['permission'] == 'public') {
            $board_visibility = 2;
        }
        $background_image = $background_pattern = '';
        if (!empty($board['backgroundImage'])) {
            if ($board['backgroundTile'] == 'true') {
                $background_pattern = $board['backgroundImage'];
            } else {
                $background_image = $board['backgroundImage'];
            }
        }
        //board Creation
        $qry_val_arr = array(
            utf8_decode($board['title']) ,
            $board['color'],
            $background_image,
            $background_pattern,
            $user_id,
            $board_visibility
        );
        $new_board = board_creation($qry_val_arr, $db_lnk);
        $server = strtolower($_SERVER['SERVER_SOFTWARE']);
        if (strpos($server, 'apache') !== false) {
            ob_end_clean();
            header("Connection: close\r\n");
            header("Content-Encoding: none\r\n");
            ignore_user_abort(true); // optional
            ob_start();
            echo json_encode($new_board);
            $size = ob_get_length();
            header("Content-Length: $size");
            ob_end_flush(); // Strange behaviour, will not work
            flush(); // Unless both are called !
            ob_end_clean();
        } else {
            echo json_encode($new_board);
            fastcgi_finish_request();
        }
        if (!empty($board['labels'])) {
            foreach ($board['labels'] as $label) {
                if (!empty($label['name'])) {
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
                }
            }
        }
        if (!empty($board['users'])) {
            foreach ($board['users'] as $member) {
                $wekan_user_id = $member['_id'];
                $qry_val_arr = array(
                    utf8_decode($member['username'])
                );
                $username = $member['username'];
                $userExist = executeQuery('SELECT * FROM users WHERE username = $1', $qry_val_arr);
                if (!$userExist) {
                    $default_email_notification = 0;
                    if (DEFAULT_EMAIL_NOTIFICATION === 'Periodically') {
                        $default_email_notification = 1;
                    } else if (DEFAULT_EMAIL_NOTIFICATION === 'Instantly') {
                        $default_email_notification = 2;
                    }
                    $member['is_send_newsletter'] = $default_email_notification;
                    $member['default_desktop_notification'] = (DEFAULT_DESKTOP_NOTIFICATION === 'Enabled') ? 'true' : 'false';
                    $member['is_list_notifications_enabled'] = IS_LIST_NOTIFICATIONS_ENABLED;
                    $member['is_card_notifications_enabled'] = IS_CARD_NOTIFICATIONS_ENABLED;
                    $member['is_card_members_notifications_enabled'] = IS_CARD_MEMBERS_NOTIFICATIONS_ENABLED;
                    $member['is_card_labels_notifications_enabled'] = IS_CARD_LABELS_NOTIFICATIONS_ENABLED;
                    $member['is_card_checklists_notifications_enabled'] = IS_CARD_CHECKLISTS_NOTIFICATIONS_ENABLED;
                    $member['is_card_attachments_notifications_enabled'] = IS_CARD_ATTACHMENTS_NOTIFICATIONS_ENABLED;
                    $qry_val_arr = array(
                        utf8_decode($member['username']) ,
                        getCryptHash('restya') ,
                        utf8_decode($username['0']) ,
                        utf8_decode($member['username']) ,
                        $member['is_send_newsletter'],
                        $member['default_desktop_notification'],
                        $member['is_list_notifications_enabled'],
                        $member['is_card_notifications_enabled'],
                        $member['is_card_members_notifications_enabled'],
                        $member['is_card_labels_notifications_enabled'],
                        $member['is_card_checklists_notifications_enabled'],
                        $member['is_card_attachments_notifications_enabled'],
                        'wekan-' . utf8_decode($member['username']) . '@mailinator.com',
                    );
                    $user = pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO users (created, modified, role_id, username, email, password, is_active, is_email_confirmed, initials, full_name, is_send_newsletter, default_desktop_notification, is_list_notifications_enabled, is_card_notifications_enabled, is_card_members_notifications_enabled, is_card_labels_notifications_enabled, is_card_checklists_notifications_enabled, is_card_attachments_notifications_enabled) VALUES (now(), now(), 2, $1, $13, $2, true, true, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12) RETURNING id', $qry_val_arr));
                    $users[$wekan_user_id] = $user['id'];
                    $user_data[$wekan_user_id] = $username;
                } else {
                    $users[$wekan_user_id] = $userExist['id'];
                    $user_data[$wekan_user_id] = $username;
                }
                foreach ($board['members'] as $member) {
                    if ($wekan_user_id === $member['userId']) {
                        $board_user_role_id = 2;
                        if ($member['isAdmin'] === '1') {
                            $board_user_role_id = 1;
                        }
                        $qry_val_arr = array(
                            $users[$wekan_user_id],
                            $new_board['id'],
                            $board_user_role_id
                        );
                        pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO boards_users (created, modified, user_id, board_id, board_user_role_id) VALUES (now(), now(), $1, $2, $3) RETURNING id', $qry_val_arr));
                        $auto_subscribe_on_board = (AUTO_SUBSCRIBE_ON_BOARD === 'Enabled') ? 'true' : false;
                        if ($auto_subscribe_on_board) {
                            $qry_val_arr = array(
                                $users[$wekan_user_id],
                                $new_board['id'],
                                true
                            );
                            pg_query_params($db_lnk, 'INSERT INTO board_subscribers (created, modified, user_id, board_id, is_subscribed) VALUES (now(), now(), $1, $2, $3)', $qry_val_arr);
                        }
                    }
                }
            }
        }
        $qry_val_arr = array(
            $authUser['id'],
            $new_board['id'],
            1
        );
        pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO boards_users (created, modified, user_id, board_id, board_user_role_id) VALUES (now(), now(), $1, $2, $3) RETURNING id', $qry_val_arr));
        $auto_subscribe_on_board = (AUTO_SUBSCRIBE_ON_BOARD === 'Enabled') ? 'true' : false;
        if ($auto_subscribe_on_board) {
            $qry_val_arr = array(
                $authUser['id'],
                $new_board['id'],
                true
            );
            pg_query_params($db_lnk, 'INSERT INTO board_subscribers (created, modified, user_id, board_id, is_subscribed) VALUES (now(), now(), $1, $2, $3)', $qry_val_arr);
        }
        if (!empty($board['lists'])) {
            $i = 0;
            foreach ($board['lists'] as $list) {
                $i+= 1;
                $is_closed = ($list['archived']) ? 'true' : 'false';
                $qry_val_arr = array(
                    utf8_decode($list['title']) ,
                    $new_board['id'],
                    $i,
                    $user_id,
                    $is_closed
                );
                $_list = pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO lists (created, modified, name, board_id, position, user_id, is_archived) VALUES (now(), now(), $1, $2, $3, $4, $5) RETURNING id', $qry_val_arr));
                $lists[$list['_id']] = $_list['id'];
                $lists_data[$list['_id']] = utf8_decode($list['title']);
            }
        }
        if (!empty($board['cards'])) {
            foreach ($board['cards'] as $card) {
                $is_closed = ($card['archived']) ? 'true' : 'false';
                $date = (!empty($card['dueAt'])) ? $card['dueAt'] : NULL;
                if (isset($card['description']) && !empty($card['description'])) {
                    $description = $card['description'];
                } else {
                    $description = '';
                }
                $qry_val_arr = array(
                    $new_board['id'],
                    $lists[$card['listId']],
                    utf8_decode($card['title']) ,
                    utf8_decode($description) ,
                    $is_closed,
                    $card['sort'],
                    $date,
                    $user_id
                );
                $_card = pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO cards (created, modified, board_id, list_id, name, description, is_archived, position, due_date, user_id) VALUES (now(), now(), $1, $2, $3, $4, $5, $6, $7, $8) RETURNING id', $qry_val_arr));
                $cards[$card['_id']] = $_card['id'];
                if (!empty($card['labelIds'])) {
                    foreach ($card['labelIds'] as $label) {
                        foreach ($board['labels'] as $label_data) {
                            if ($label_data['_id'] === $label) {
                                if (!empty($label_data['name'])) {
                                    $qry_val_arr = array(
                                        utf8_decode($label_data['name'])
                                    );
                                    $check_label = executeQuery('SELECT id FROM labels WHERE name = $1', $qry_val_arr);
                                    $qry_val_arr = array(
                                        $new_board['id'],
                                        $lists[$card['listId']],
                                        $_card['id'],
                                        $check_label['id']
                                    );
                                    pg_query_params($db_lnk, 'INSERT INTO cards_labels (created, modified, board_id, list_id, card_id, label_id) VALUES (now(), now(), $1, $2, $3, $4)', $qry_val_arr);
                                }
                            }
                        }
                    }
                }
                if (!empty($board['attachments'])) {
                    foreach ($board['attachments'] as $attachment) {
                        if ($card['_id'] === $attachment['cardId']) {
                            $mediadir = MEDIA_PATH . DS . 'Card' . DS . $_card['id'];
                            $save_path = 'Card' . DS . $_card['id'];
                            $save_path = str_replace('\\', '/', $save_path);
                            $filename = curlExecute($attachment['url'], 'get', $mediadir, 'image');
                            $path = $save_path . DS . $filename['file_name'];
                            $created = $modified = date('Y-m-d H:i:s');
                            $qry_val_arr = array(
                                $created,
                                $modified,
                                $new_board['id'],
                                $lists[$card['listId']],
                                $cards[$card['_id']],
                                $filename['file_name'],
                                $path,
                                'image/jpeg'
                            );
                            pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO card_attachments (created, modified, board_id, list_id, card_id, name, path, mimetype) VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING id', $qry_val_arr));
                        }
                    }
                }
                if (!empty($card['members'])) {
                    foreach ($card['members'] as $cardMemberId) {
                        $qry_val_arr = array(
                            $_card['id'],
                            $users[$cardMemberId]
                        );
                        pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO cards_users (created, modified, card_id, user_id) VALUES (now(), now(), $1, $2) RETURNING id', $qry_val_arr));
                    }
                }
            }
        }
        if (!empty($board['comments'])) {
            foreach ($board['comments'] as $comment_datas) {
                $comments_data[$comment_datas['_id']] = $comment_datas['text'];
            }
        }
        if (!empty($board['activities'])) {
            $type = $comment = '';
            $board['activities'] = array_msort($board['activities'], array(
                'createdAt' => SORT_ASC
            ));
            foreach ($board['activities'] as $action) {
                if ($action['activityType'] == 'addComment') {
                    $type = 'add_comment';
                    $comment = $comments_data[$action['commentId']];
                } else if ($action['activityType'] == 'joinMember') {
                    $type = 'add_card_user';
                    $comment = sprintf(__l('##USER_NAME## added %s as member to the card ##CARD_LINK##') , utf8_decode($user_data[$action['memberId']]));
                } else if ($action['activityType'] == 'createCard') {
                    $type = 'add_card';
                    $comment = sprintf(__l('##USER_NAME## added card ##CARD_LINK## to list %s."') , utf8_decode($lists_data[$action['listId']]));
                } else if ($action['activityType'] == 'createList') {
                    $type = 'add_list';
                    $comment = sprintf(__l('##USER_NAME## added list %s.') , utf8_decode($lists_data[$action['listId']]));
                } else if ($action['activityType'] == 'createBoard') {
                    $type = 'add_board';
                    $comment = __l('##USER_NAME## created board');
                } else if ($action['activityType'] == 'archivedList') {
                    $type = 'archive_list';
                    $comment = __l('##USER_NAME## archived list ##LIST_NAME##');
                } else if ($action['activityType'] == 'moveCard') {
                    $type = 'moved_list_card';
                    $comment = sprintf(__l('##USER_NAME## moved cards FROM %s to %s') , utf8_decode($lists_data[$action['listId']]) , utf8_decode($lists_data[$action['listId']]));
                } else if ($action['activityType'] == 'addAttachment') {
                    $type = 'add_card_attachment';
                    $comment = __l('##USER_NAME## added attachment to the card ##CARD_LINK##');
                } else if ($action['activityType'] == 'addBoardMember') {
                    $type = 'add_board_user';
                    $comment = __l('##USER_NAME## added member to board');
                }
                $comment = utf8_decode($comment);
                $created = $modified = $action['createdAt'];
                if (!empty($action['listId'])) {
                    if (array_key_exists($action['listId'], $lists)) {
                        $lists_key = $lists[$action['listId']];
                    } else {
                        $lists_key = '';
                    }
                }
                if (!empty($action['cardId'])) {
                    if (array_key_exists($action['cardId'], $cards)) {
                        $cards_key = $cards[$action['cardId']];
                    } else {
                        $cards_key = '';
                    }
                }
                if (empty($lists_key) && empty($cards_key)) {
                    $qry_val_arr = array(
                        $created,
                        $modified,
                        $new_board['id'],
                        $users[$action['userId']],
                        $type,
                        $comment,
                        $_GET['token']
                    );
                    $activity = pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO activities (created, modified, board_id, user_id, type, comment, token) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING id', $qry_val_arr));
                } else if (!empty($lists_key) && empty($cards_key)) {
                    $qry_val_arr = array(
                        $created,
                        $modified,
                        $new_board['id'],
                        $lists_key,
                        $users[$action['userId']],
                        $type,
                        $comment,
                        $_GET['token']
                    );
                    $activity = pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO activities (created, modified, board_id, list_id, user_id, type, comment, token) VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING id', $qry_val_arr));
                } else if (empty($lists_key) && !empty($cards_key)) {
                    $qry_val_arr = array(
                        $created,
                        $modified,
                        $new_board['id'],
                        $cards_key,
                        $users[$action['userId']],
                        $type,
                        $comment,
                        $_GET['token']
                    );
                    $activity = pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO activities (created, modified, board_id, card_id, user_id, type, comment, token) VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING id', $qry_val_arr));
                } else if (!empty($lists_key) && !empty($cards_key)) {
                    $qry_val_arr = array(
                        $created,
                        $modified,
                        $new_board['id'],
                        $lists_key,
                        $cards_key,
                        $users[$action['userId']],
                        $type,
                        $comment,
                        $_GET['token']
                    );
                    $activity = pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO activities (created, modified, board_id, list_id, card_id, user_id, type, comment, token) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) RETURNING id', $qry_val_arr));
                }
                if (!empty($activity)) {
                    $id_converted = base_convert($activity['id'], 10, 36);
                    $materialized_path = sprintf("%08s", $id_converted);
                    $path = 'P' . $activity['id'];
                    $depth = 0;
                    $root = $activity['id'];
                    $freshness_ts = $created;
                    $qry_val_arr = array(
                        $materialized_path,
                        $path,
                        $depth,
                        $root,
                        $freshness_ts,
                        $activity['id']
                    );
                    pg_query_params($db_lnk, 'UPDATE activities SET materialized_path = $1, path = $2, depth = $3, root = $4, freshness_ts = $5 WHERE id = $6', $qry_val_arr);
                    $qry_val_arr = array(
                        $freshness_ts,
                        $root
                    );
                    pg_query_params($db_lnk, 'UPDATE activities SET freshness_ts = $1 WHERE root = $2', $qry_val_arr);
                }
            }
        }
        boardImportMailSend('Wekan', $new_board);
        return $new_board;
    }
}
/**
 * Import Asana board
 *
 * @param array $board Boards from Asana
 *
 * @return mixed
 */
function splitAsanatasks($board, $task)
{
    if (!empty($task['resource_subtype'])) {
        if ($task['resource_subtype'] == 'default_task') {
            $board['lists'] = (empty($board['lists'])) ? [] : $board['lists'];
            $board['card_count'] = (empty($board['card_count'])) ? [] : $board['card_count'];
            if (!empty($task['memberships'])) {
                if (!empty($task['memberships'][0]['section'])) {
                    $tmp_list = $task['memberships'][0]['section'];
                } else {
                    $board['todo_template'] = true;
                    if (!empty($task['completed']) && $task['completed'] == true) {
                        $tmp_list = $board['lists'][2];
                    } else if (!empty($task['assignee']) || !empty($task['due_on'])) {
                        $tmp_list = $board['lists'][1];
                    } else {
                        $tmp_list = $board['lists'][0];
                    }
                    $board['card_count'][$tmp_list['gid']] = 1;
                }
                $task['idList'] = $tmp_list['gid'];
                if ($tmp_list['resource_type'] === 'section' && !in_array($tmp_list, $board['lists'])) {
                    $board['card_count'][$task['idList']] = 1;
                    $board['lists'][] = $tmp_list;
                } else {
                    $board['card_count'][$task['idList']] = $board['card_count'][$task['idList']] + 1;
                }
            }
            $board['cards'][] = $task;
            if (!empty($task['tags'])) {
                $board['labelNames'] = (empty($board['labelNames'])) ? [] : $board['labelNames'];
                foreach ($task['tags'] as $tag) {
                    if ($tag['resource_type'] === 'tag' && !in_array($tag, $board['labelNames'])) {
                        $board['labelNames'][] = $tag;
                    }
                }
            }
            if (!empty($task['followers'])) {
                $board['subscribers'] = (empty($board['subscribers'])) ? [] : $board['subscribers'];
                foreach ($task['followers'] as $follower) {
                    if ($follower['resource_type'] === 'user' && !in_array($follower, $board['subscribers'])) {
                        $board['subscribers'][] = $follower;
                    }
                }
            }
        }
    }
    return $board;
}
function importAsanaBoard($jsonArr = array())
{
    global $r_debug, $db_lnk, $authUser, $_server_domain_url;
    $users = $userNames = $lists = $cards = $labels = array();
    $board['lists'] = array(
        array(
            'gid' => 1,
            'name' => "Todo",
            'resource_type' => 'section'
        ) ,
        array(
            'gid' => 2,
            'name' => "Doing",
            'resource_type' => 'section'
        ) ,
        array(
            'gid' => 3,
            'name' => "Done",
            'resource_type' => 'section'
        )
    );
    if (!empty($jsonArr)) {
        foreach ($jsonArr as $key => $json) {
            if (!empty($json['resource_subtype'])) {
                if (!empty($json['memberships'])) {
                    if (!empty($json['memberships'][0]['project']) && $key === 0) {
                        $board_details = $json['memberships'][0]['project'];
                    }
                }
                if ($json['resource_subtype'] == 'default_task') {
                    //Maintasks
                    $board = splitAsanatasks($board, $json);
                    //Subtasks
                    if (!empty($json['subtasks'])) {
                        foreach ($json['subtasks'] as $key => $subtask) {
                            if (empty($subtask['memberships']) && !empty($json['memberships'])) {
                                $subtask['memberships'] = $json['memberships'];
                            }
                            $board = splitAsanatasks($board, $subtask);
                        }
                    }
                }
            }
        }
        $board_name = $board_details['name'];
        if (!empty($board_name)) {
            $user_id = $authUser['id'];
            $qry_val_arr = array(
                utf8_decode($board_name) ,
                $user_id,
                0
            );
            $new_board = pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO boards (created, modified, name, user_id, board_visibility) VALUES (now(), now(), $1, $2, $3) RETURNING id', $qry_val_arr));
            $server = strtolower($_SERVER['SERVER_SOFTWARE']);
            if (strpos($server, 'apache') !== false) {
                ob_end_clean();
                header("Connection: close\r\n");
                header("Content-Encoding: none\r\n");
                ignore_user_abort(true); // optional
                ob_start();
                echo json_encode($new_board);
                $size = ob_get_length();
                header("Content-Length: $size");
                ob_end_flush(); // Strange behaviour, will not work
                flush(); // Unless both are called !
                ob_end_clean();
            } else {
                echo json_encode($new_board);
                fastcgi_finish_request();
            }
            // insert current user as board member
            $qry_val_arr = array(
                $authUser['id'],
                $new_board['id'],
                1
            );
            pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO boards_users (created, modified, user_id, board_id, board_user_role_id) VALUES (now(), now(), $1, $2, $3) RETURNING id', $qry_val_arr));
            $auto_subscribe_on_board = (AUTO_SUBSCRIBE_ON_BOARD === 'Enabled') ? 'true' : false;
            if ($auto_subscribe_on_board) {
                $qry_val_arr = array(
                    $authUser['id'],
                    $new_board['id'],
                    true
                );
                pg_query_params($db_lnk, 'INSERT INTO board_subscribers (created, modified, user_id, board_id, is_subscribed) VALUES (now(), now(), $1, $2, $3)', $qry_val_arr);
            }
            // insert labels
            if (!empty($board['labelNames'])) {
                foreach ($board['labelNames'] as $label) {
                    if (!empty($label['name'])) {
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
                        $labels[$label['id']] = $check_label['id'];
                    }
                }
            }
            // insert lists
            if (!empty($board['lists'])) {
                $i = 0;
                foreach ($board['lists'] as $list) {
                    if ((!empty($board['card_count'][$list['gid']]) && $board['card_count'][$list['gid']] > 0) || (!empty($board['todo_template']) && $list['gid'] <= 3)) {
                        $i+= 1;
                        $qry_val_arr = array(
                            utf8_decode($list['name']) ,
                            $new_board['id'],
                            $i,
                            $user_id
                        );
                        $_list = pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO lists (created, modified, name, board_id, position, user_id) VALUES (now(), now(), $1, $2, $3, $4) RETURNING id', $qry_val_arr));
                        $lists[$list['gid']] = $_list['id'];
                    }
                }
            }
            // insert board members
            if (!empty($board['subscribers'])) {
                foreach ($board['subscribers'] as $boarduser) {
                    if (empty($users[$boarduser['gid']])) {
                        $member = array(
                            'id' => $boarduser['gid'],
                            'username' => $boarduser['name'],
                            'fullName' => $boarduser['name'],
                            'avatarUrl' => null,
                            'initials' => strtoupper(substr($boarduser['name'], 0, 1))
                        );
                        $users = importMember($member, $new_board, 'asana');
                        $userNames[$boarduser['gid']] = $users[$boarduser['gid']];
                    }
                }
            }
            // insert cards
            if (!empty($board['cards'])) {
                $i = 0;
                foreach ($board['cards'] as $card) {
                    $i+= 1;
                    $is_closed = !empty($card['is_archived']) ? 'true' : 'false';
                    $date = (!empty($card['due_on'])) ? $card['due_on'] : null;
                    $desc = (!empty($card['notes'])) ? utf8_decode($card['notes']) : null;
                    $qry_val_arr = array(
                        $new_board['id'],
                        $lists[$card['idList']],
                        utf8_decode($card['name']) ,
                        $desc,
                        $is_closed,
                        $i,
                        $date,
                        $user_id
                    );
                    $_card = pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO cards (created, modified, board_id, list_id, name, description, is_archived, position, due_date, user_id) VALUES (now(), now(), $1, $2, $3, $4, $5, $6, $7, $8) RETURNING id', $qry_val_arr));
                    $cards[$card['id']] = $_card['id'];
                    if (!empty($card['tags'])) {
                        foreach ($card['tags'] as $label) {
                            $qry_val_arr = array(
                                $new_board['id'],
                                $lists[$card['idList']],
                                $_card['id'],
                                $labels[$label['id']]
                            );
                            pg_query_params($db_lnk, 'INSERT INTO cards_labels (created, modified, board_id, list_id, card_id, label_id) VALUES (now(), now(), $1, $2, $3, $4)', $qry_val_arr);
                        }
                    }
                    if (!empty($card['likes']) && !empty($card['liked'])) {
                        foreach ($card['likes'] as $like) {
                            $qry_val_arr = array(
                                $_card['id'],
                                $userNames[$like['user']['gid']],
                            );
                            pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO card_voters (created, modified, card_id, user_id) VALUES (now(), now(), $1, $2) RETURNING id', $qry_val_arr));
                        }
                    }
                    if (!empty($card['followers'])) {
                        foreach ($card['followers'] as $follower) {
                            $qry_val_arr = array(
                                $_card['id'],
                                $userNames[$follower['gid']],
                                'true'
                            );
                            pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO card_subscribers (created, modified, card_id, user_id, is_subscribed) VALUES (now(), now(), $1, $2,$3) RETURNING id', $qry_val_arr));
                        }
                    }
                    if (!empty($card['assignee'])) {
                        $qry_val_arr = array(
                            $_card['id'],
                            $userNames[$card['assignee']['gid']]
                        );
                        pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO cards_users (created, modified, card_id, user_id) VALUES (now(), now(), $1, $2) RETURNING id', $qry_val_arr));
                    }
                }
            }
            boardImportMailSend('Asana', $new_board);
            return $new_board;
        }
    }
}
/**
 * Import Taskwarrior board
 *
 * @param array $board Boards from Taskwarrior
 *
 * @return mixed
 */
function importTaskWarriorBoard($jsonArr = array())
{
    global $r_debug, $db_lnk, $authUser, $_server_domain_url;
    $users = $userNames = $lists = $cards = $labels = array();
    $board['lists'] = array(
        array(
            'gid' => 1,
            'name' => "Todo"
        ) ,
        array(
            'gid' => 2,
            'name' => "Doing"
        ) ,
        array(
            'gid' => 3,
            'name' => "Done"
        )
    );
    if (!empty($jsonArr)) {
        foreach ($jsonArr as $key => $json) {
            if (!empty($json['status']) && $json['status'] !== 'deleted') {
                if (!empty($json['project']) && isset($json['project'])) {
                    $board_name = $json['project'];
                }
                if ($json['status'] == 'completed') {
                    $tmp_list = $board['lists'][2];
                } else if ($json['status'] == 'waiting' || $json['status'] == 'recurring') {
                    $tmp_list = $board['lists'][1];
                } else {
                    $tmp_list = $board['lists'][0];
                }
                $json['idList'] = $tmp_list['gid'];
                $board['cards'][] = $json;
                if (!empty($json['tags'])) {
                    $board['labelNames'] = (empty($board['labelNames'])) ? [] : $board['labelNames'];
                    foreach ($json['tags'] as $tag) {
                        if (!in_array($tag, $board['labelNames'])) {
                            $board['labelNames'][] = $tag;
                        }
                    }
                }
            }
        }
        $board_name = (!empty($board_name)) ? $board_name : 'Taskwarrior';
        if (!empty($board_name)) {
            $user_id = $authUser['id'];
            $qry_val_arr = array(
                utf8_decode($board_name) ,
                $user_id,
                0
            );
            $new_board = pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO boards (created, modified, name, user_id, board_visibility) VALUES (now(), now(), $1, $2, $3) RETURNING id', $qry_val_arr));
            $server = strtolower($_SERVER['SERVER_SOFTWARE']);
            if (strpos($server, 'apache') !== false) {
                ob_end_clean();
                header("Connection: close\r\n");
                header("Content-Encoding: none\r\n");
                ignore_user_abort(true); // optional
                ob_start();
                echo json_encode($new_board);
                $size = ob_get_length();
                header("Content-Length: $size");
                ob_end_flush(); // Strange behaviour, will not work
                flush(); // Unless both are called !
                ob_end_clean();
            } else {
                echo json_encode($new_board);
                fastcgi_finish_request();
            }
            // insert current user as board member
            $qry_val_arr = array(
                $authUser['id'],
                $new_board['id'],
                1
            );
            pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO boards_users (created, modified, user_id, board_id, board_user_role_id) VALUES (now(), now(), $1, $2, $3) RETURNING id', $qry_val_arr));
            $auto_subscribe_on_board = (AUTO_SUBSCRIBE_ON_BOARD === 'Enabled') ? 'true' : false;
            if ($auto_subscribe_on_board) {
                $qry_val_arr = array(
                    $authUser['id'],
                    $new_board['id'],
                    true
                );
                pg_query_params($db_lnk, 'INSERT INTO board_subscribers (created, modified, user_id, board_id, is_subscribed) VALUES (now(), now(), $1, $2, $3)', $qry_val_arr);
            }
            // insert labels
            if (!empty($board['labelNames'])) {
                foreach ($board['labelNames'] as $label) {
                    if (!empty($label)) {
                        $qry_val_arr = array(
                            utf8_decode($label)
                        );
                        $check_label = executeQuery('SELECT id FROM labels WHERE name = $1', $qry_val_arr);
                        if (empty($check_label)) {
                            $qry_val_arr = array(
                                utf8_decode($label)
                            );
                            $check_label = pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO labels (created, modified, name) VALUES (now(), now(), $1) RETURNING id', $qry_val_arr));
                        }
                        $labels[utf8_decode($label) ] = $check_label['id'];
                    }
                }
            }
            // insert lists
            if (!empty($board['lists'])) {
                $i = 0;
                foreach ($board['lists'] as $list) {
                    $i+= 1;
                    $qry_val_arr = array(
                        utf8_decode($list['name']) ,
                        $new_board['id'],
                        $i,
                        $user_id
                    );
                    $_list = pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO lists (created, modified, name, board_id, position, user_id) VALUES (now(), now(), $1, $2, $3, $4) RETURNING id', $qry_val_arr));
                    $lists[$list['gid']] = $_list['id'];
                }
            }
            // insert cards
            if (!empty($board['cards'])) {
                $i = 0;
                foreach ($board['cards'] as $card) {
                    $i+= 1;
                    $is_closed = !empty($card['is_archived']) ? 'true' : 'false';
                    $date = (!empty($card['due'])) ? $card['due'] : null;
                    $desc = (!empty($card['notes'])) ? utf8_decode($card['notes']) : null;
                    $qry_val_arr = array(
                        $new_board['id'],
                        $lists[$card['idList']],
                        utf8_decode($card['description']) ,
                        $desc,
                        $is_closed,
                        $i,
                        $date,
                        $user_id
                    );
                    $_card = pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO cards (created, modified, board_id, list_id, name, description, is_archived, position, due_date, user_id) VALUES (now(), now(), $1, $2, $3, $4, $5, $6, $7, $8) RETURNING id', $qry_val_arr));
                    $cards[$card['id']] = $_card['id'];
                    if (!empty($card['tags'])) {
                        foreach ($card['tags'] as $label) {
                            $qry_val_arr = array(
                                $new_board['id'],
                                $lists[$card['idList']],
                                $_card['id'],
                                $labels[utf8_decode($label) ]
                            );
                            pg_query_params($db_lnk, 'INSERT INTO cards_labels (created, modified, board_id, list_id, card_id, label_id) VALUES (now(), now(), $1, $2, $3, $4)', $qry_val_arr);
                        }
                    }
                }
            }
            boardImportMailSend('Taskwarrior', $new_board);
            return $new_board;
        }
    }
}
/**
 * Import Pipefy board
 *
 * @param array $board Boards from Pipefy
 *
 * @return mixed
 */
function importpipefyBoard($board = array())
{
    global $r_debug, $db_lnk, $authUser, $_server_domain_url;
    $users = $userNames = $lists = $listNames = $cards = $cardLists = $labels = array();
    if (!empty($board)) {
        $user_id = $authUser['id'];
        foreach ($board as $key => $value) {
            if (!empty($value['Current phase']) && $value['Current phase'] !== 'NULL') {
                if (empty($data['lists'][$value['Current phase']])) {
                    $data['lists'][$value['Current phase']] = $value['Current phase'];
                }
            }
            if (!empty($value['Labels']) && $value['Labels'] !== 'NULL') {
                $temp_lables = explode(', ', $value['Labels']);
                foreach ($temp_lables as $tmp_label) {
                    if (empty($data['labels'][$tmp_label])) {
                        $data['labels'][$tmp_label] = $tmp_label;
                    }
                };
            }
            if (!empty($value['Creator']) && $value['Creator'] !== 'NULL') {
                if (empty($data['creators'][$value['Creator']])) {
                    $data['creators'][$value['Creator']] = $value['Creator'];
                }
            }
        }
        // insert new board
        $qry_val_arr = array(
            'Pipefy Board',
            2,
            $user_id
        );
        $new_board = pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO boards (created, modified, name, board_visibility, user_id) VALUES (now(), now(), $1, $2, $3) RETURNING id', $qry_val_arr));
        $server = strtolower($_SERVER['SERVER_SOFTWARE']);
        if (strpos($server, 'apache') !== false) {
            ob_end_clean();
            header("Connection: close\r\n");
            header("Content-Encoding: none\r\n");
            ignore_user_abort(true); // optional
            ob_start();
            echo json_encode($new_board);
            $size = ob_get_length();
            header("Content-Length: $size");
            ob_end_flush(); // Strange behaviour, will not work
            flush(); // Unless both are called !
            ob_end_clean();
        } else {
            echo json_encode($new_board);
            fastcgi_finish_request();
        }
        // insert current user as board member
        $qry_val_arr = array(
            $authUser['id'],
            $new_board['id'],
            1
        );
        pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO boards_users (created, modified, user_id, board_id, board_user_role_id) VALUES (now(), now(), $1, $2, $3) RETURNING id', $qry_val_arr));
        $auto_subscribe_on_board = (AUTO_SUBSCRIBE_ON_BOARD === 'Enabled') ? 'true' : false;
        if ($auto_subscribe_on_board) {
            $qry_val_arr = array(
                $authUser['id'],
                $new_board['id'],
                true
            );
            pg_query_params($db_lnk, 'INSERT INTO board_subscribers (created, modified, user_id, board_id, is_subscribed) VALUES (now(), now(), $1, $2, $3)', $qry_val_arr);
        }
        // insert labels
        if (!empty($data['labels'])) {
            foreach ($data['labels'] as $label) {
                if (!empty($label)) {
                    $qry_val_arr = array(
                        utf8_decode($label)
                    );
                    $check_label = executeQuery('SELECT id FROM labels WHERE name = $1', $qry_val_arr);
                    if (empty($check_label)) {
                        $qry_val_arr = array(
                            utf8_decode($label)
                        );
                        $check_label = pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO labels (created, modified, name) VALUES (now(), now(), $1) RETURNING id', $qry_val_arr));
                    }
                    $labels[$label] = $check_label['id'];
                }
            }
        }
        // insert board members
        if (!empty($data['creators'])) {
            foreach ($data['creators'] as $boarduser) {
                if (empty($users[$boarduser])) {
                    $member = array(
                        'id' => $boarduser,
                        'username' => strtolower($boarduser) ,
                        'fullName' => $boarduser,
                        'avatarUrl' => null,
                        'initials' => strtoupper(substr($boarduser, 0, 1))
                    );
                    $users = importMember($member, $new_board, 'pipefy');
                    $userNames[$boarduser] = $users[$boarduser];
                }
            }
        }
        // insert lists
        if (!empty($data['lists'])) {
            $i = 0;
            foreach ($data['lists'] as $list) {
                $i+= 1;
                if (!in_array($list, $listNames)) {
                    $qry_val_arr = array(
                        utf8_decode($list) ,
                        $new_board['id'],
                        $i,
                        $user_id
                    );
                    $_list = pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO lists (created, modified, name, board_id, position, color, user_id) VALUES (now(), now(), $1, $2, $3, NULL, $4) RETURNING id', $qry_val_arr));
                    $lists[$list] = $_list['id'];
                    $listNames[$list] = $list;
                }
            }
        }
        //Import cards
        $i = 0;
        foreach ($board as $key => $card) {
            $i+= 1;
            $is_closed = 'false';
            $date = (!empty($card['Due date']) && $card['Due date'] !== 'NULL') ? date('Y-m-d H:i:s', strtotime($card['Due date'])) : NULL;
            if (isset($card['Describe this bug']) && !empty($card['Describe this bug']) && $card['Describe this bug'] !== 'NULL') {
                $description = $card['Describe this bug'];
            } else {
                $description = '';
            }
            $card_user_id = (!empty($card['Creator']) && $card['Creator'] !== "NULL") ? $userNames[$card['Creator']] : $user_id;
            $created_at = (!empty($card['Created at']) && $card['Created at'] !== "NULL") ? date('Y-m-d H:i:s', strtotime($card['Created at'])) : date('Y-m-d H:i:s');
            $updated_at = (!empty($card['Updated at']) && $card['Updated at'] !== "NULL") ? date('Y-m-d H:i:s', strtotime($card['Updated at'])) : date('Y-m-d H:i:s');
            $qry_val_arr = array(
                $new_board['id'],
                $lists[$card['Current phase']],
                utf8_decode($card['Title']) ,
                $description,
                $is_closed,
                $i,
                $date,
                $card_user_id,
                $created_at,
                $updated_at
            );
            $_card = pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO cards (created, modified, board_id, list_id, name, description, is_archived, position, due_date, user_id) VALUES ($9, $10, $1, $2, $3, $4, $5, $6, $7, $8) RETURNING id', $qry_val_arr));
            $cards[$card['ID']] = $_card['id'];
            if (!empty($card['Labels']) && $card['Labels'] !== 'NULL') {
                $label_names = explode(', ', $card['Labels']);
                if (!empty($label_names)) {
                    foreach ($label_names as $label) {
                        $qry_val_arr = array(
                            $new_board['id'],
                            $lists[$card['Current phase']],
                            $_card['id'],
                            $labels[$label]
                        );
                        pg_query_params($db_lnk, 'INSERT INTO cards_labels (created, modified, board_id, list_id, card_id, label_id) VALUES (now(), now(), $1, $2, $3, $4)', $qry_val_arr);
                    }
                }
            }
            if (!empty($card['Attach screenshots of the bug']) && $card['Attach screenshots of the bug'] !== 'NULL') {
                $card_attachments = explode(', ', $card['Attach screenshots of the bug']);
                foreach ($card_attachments as $attachment) {
                    $mediadir = MEDIA_PATH . DS . 'Card' . DS . $_card['id'];
                    $save_path = 'Card' . DS . $_card['id'];
                    $save_path = str_replace('\\', '/', $save_path);
                    $filename = curlExecute($attachment, 'get', $mediadir, 'image');
                    $path = $save_path . DS . $filename['file_name'];
                    $qry_val_arr = array(
                        $new_board['id'],
                        $lists[$card['Current phase']],
                        $_card['id'],
                        $filename['file_name'],
                        $path
                    );
                    pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO card_attachments (created, modified, board_id, list_id, card_id, name, path, mimetype) VALUES (now(), now(), $1, $2, $3, $4, $5, NULL) RETURNING id', $qry_val_arr));
                }
            }
            if (!empty($card['Assignees'])) {
                $card_assignees = explode(', ', $card['Assignees']);
                foreach ($card_assignees as $cardMember) {
                    if (empty($users[$cardMember])) {
                        $member = array(
                            'id' => $cardMember,
                            'username' => strtolower($cardMember) ,
                            'fullName' => $cardMember,
                            'avatarUrl' => null,
                            'initials' => strtoupper(substr($cardMember, 0, 1))
                        );
                        $users = importMember($member, $new_board, 'pipefy');
                        $userNames[$cardMember] = $cardMember;
                    }
                    $qry_val_arr = array(
                        $_card['id'],
                        $users[$cardMember]
                    );
                    pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO cards_users (created, modified, card_id, user_id) VALUES (now(), now(), $1, $2) RETURNING id', $qry_val_arr));
                }
            }
        }
        boardImportMailSend('Pipefy', $new_board);
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
    if (file_exists(SITE_URL_FOR_SHELL)) {
        include_once SITE_URL_FOR_SHELL;
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
function paginate_data($c_sql, $db_lnk, $pg_params, $r_resource_filters, $limit = PAGING_COUNT)
{
    global $r_debug, $db_lnk, $authUser, $_server_domain_url;
    $c_result = pg_query_params($db_lnk, $c_sql, $pg_params);
    $c_data = pg_fetch_object($c_result, 0);
    $page = (isset($r_resource_filters['page']) && $r_resource_filters['page']) ? $r_resource_filters['page'] : 1;
    $page_count = PAGING_COUNT;
    if (!empty($limit) && $limit == 'all') {
        $page_count = $c_data->count;
    } elseif (!empty($limit)) {
        $page_count = $limit;
    }
    $start = ($page - 1) * $page_count;
    $total_page = !empty($page_count) ? ceil($c_data->count / $page_count) : 0;
    $showing = (($start + $page_count) > $c_data->count) ? ($c_data->count - $start) : $page_count;
    $_metadata = array(
        'noOfPages' => $total_page,
        'total_records' => $c_data->count,
        'limit' => $page_count,
        'offset' => $start,
        'showing' => $showing,
        'maxSize' => 5
    );
    $sql = ' ';
    $arr['sql'] = $sql;
    $arr['_metadata'] = $_metadata;
    return $arr;
}
function update_query($table_name, $id, $r_resource_cmd, $r_put, $comment = '', $activity_type = '', $foreign_ids = '')
{
    global $r_debug, $db_lnk, $authUser, $_server_domain_url;
    $values = array(
        'now()'
    );
    $sfields = '';
    $fields = 'modified';
    if (!empty($table_name) && !empty($id)) {
        $put = getbindValues($table_name, $r_put);
        if ($table_name == 'users') {
            unset($put['ip_id']);
        }
        foreach ($put as $key => $value) {
            if ($key != 'id') {
                $fields.= ', ' . $key;
                if ($value === false) {
                    array_push($values, 'false');
                } elseif ($value === 'null' || $value === 'NULL' || $value === 'null') {
                    array_push($values, null);
                } else {
                    array_push($values, $value);
                }
            }
            if ($key != 'id') {
                $sfields.= (empty($sfields)) ? $key : ", " . $key;
            }
        }
        if (!empty($comment)) {
            $revision = '';
            if ($activity_type != 'reopen_board' && $activity_type != 'close_board' && $activity_type != 'moved_list_card' && $activity_type != 'moved_card_checklist_item' && $activity_type != 'delete_organization_attachment') {
                $qry_va_arr = array(
                    $id
                );
                $revisions['old_value'] = executeQuery('SELECT ' . $sfields . ' FROM ' . $table_name . ' WHERE id =  $1', $qry_va_arr);
                if ($activity_type != 'change_list_position' && $activity_type != 'change_card_position' && $activity_type != 'move_card' && $activity_type != 'update_card_checklist' && $activity_type != 'update_card_checklist_item') {
                    if (!empty($r_put['position'])) {
                        unset($r_put['position']);
                    }
                    if (!empty($r_put['id'])) {
                        unset($r_put['id']);
                    }
                }
                $revisions['new_value'] = $r_put;
                $revision = serialize($revisions);
            }
            $foreign_id = $id;
            if ($activity_type == 'moved_list_card' || $activity_type == 'move_card') {
                $foreign_id = $r_put['list_id'];
            }
            $response['activity'] = insertActivity($authUser['id'], $comment, $activity_type, $foreign_ids, $revision, $foreign_id);
            if (!empty($response['activity']['revisions']) && trim($response['activity']['revisions']) != '') {
                $revisions = unserialize($response['activity']['revisions']);
            }
            if (!empty($revisions) && $response['activity']['type'] != 'moved_card_checklist_item') {
                if (!empty($revisions['new_value'])) {
                    $bool = true;
                    foreach ($revisions['new_value'] as $key => $value) {
                        if ($key != 'is_archived' && $key != 'is_deleted' && $key != 'created' && $key != 'modified' && $key != 'is_offline' && $key != 'uuid' && $key != 'to_date' && $key != 'temp_id' && $activity_type != 'moved_card_checklist_item' && $activity_type != 'add_card_desc' && $activity_type != 'add_card_duedate' && $activity_type != 'delete_card_duedate' && $activity_type != 'add_background' && $activity_type != 'change_background' && $activity_type != 'change_visibility') {
                            $old_val = (isset($revisions['old_value'][$key])) ? $revisions['old_value'][$key] : '';
                            $new_val = (isset($revisions['new_value'][$key])) ? $revisions['new_value'][$key] : '';
                            $diff[] = nl2br(getRevisiondifference($old_val, $new_val));
                        }
                        if ($activity_type == 'add_card_desc' || $activity_type == 'edit_card_duedate' || $activity_type == 'add_background' || $activity_type == 'change_background' || $activity_type == 'change_visibility') {
                            $diff[] = $revisions['new_value'][$key];
                        }
                        $bool = false;
                    }
                    if ($bool && $activity_type == 'delete_card_comment') {
                        $old_val = (isset($revisions['old_value'])) ? $revisions['old_value'] : '';
                        $new_val = (isset($revisions['new_value'])) ? $revisions['new_value'] : '';
                        $diff[] = nl2br(getRevisiondifference($old_val, $new_val));
                    }
                } else if (!empty($revisions['old_value']) && isset($obj['type']) && $obj['type'] == 'delete_card_comment') {
                    $diff[] = nl2br(getRevisiondifference($revisions['old_value'], ''));
                }
            }
            if (isset($diff)) {
                $response['activity']['difference'] = $diff;
            }
            if (isset($r_put['description'])) {
                $response['activity']['description'] = $r_put['description'];
            }
        }
        if ($r_resource_cmd == '/users/?') {
            if (isset($r_put['is_active']) && $r_put['is_active'] == false) {
                executeQuery('SELECT username FROM users WHERE id =' . $id);
                // Todo handle with jaxl for ban_account
                
            }
        }
        if ($r_resource_cmd == '/boards_users/?') {
            if (is_plugin_enabled('r_chat')) {
                xmppChangeGrantMember($r_put);
            }
        }
        $val = '';
        for ($i = 1, $len = count($values); $i <= $len; $i++) {
            $val.= '$' . $i;
            $val.= ($i != $len) ? ', ' : '';
        }
        array_push($values, $id);
        $query = 'UPDATE ' . $table_name . ' SET (' . $fields . ') = (' . $val . ') WHERE id = ' . '$' . $i;
        if ($r_resource_cmd == '/boards/?/lists/?/cards') {
            $query = 'UPDATE ' . $table_name . ' SET (' . $fields . ') = (' . $val . ') WHERE list_id = ' . '$' . $i;
        }
        pg_query_params($db_lnk, $query, $values);
    }
    if (empty($response)) {
        $response = 'Success';
    }
    return $response;
}
function json_response($table_name, $r_resource_vars)
{
    global $r_debug, $db_lnk, $authUser, $_server_domain_url;
    if ($table_name == 'organizations') {
        $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM organizations_listing ul WHERE id = $1) as d ';
        array_push($pg_params, $r_resource_vars['organizations']);
    } elseif ($table_name == 'organizations_users') {
        $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM organizations_users_listing ul WHERE id = $1) as d ';
        array_push($pg_params, $r_resource_vars['organizations_users']);
    } elseif ($table_name == 'lists') {
        $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM lists_listing WHERE id = $1) as d ';
        array_push($pg_params, $r_resource_vars['lists']);
    } elseif ($table_name == 'cards' && !empty($r_resource_vars['cards'])) {
        $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM cards_listing WHERE id = $1) as d ';
        array_push($pg_params, $r_resource_vars['cards']);
    } elseif ($table_name == 'cards' && !empty($r_resource_vars['lists'])) {
        $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM cards_listing WHERE list_id = $1) as d ';
        array_push($pg_params, $r_resource_vars['lists']);
    }
    if ($result = pg_query_params($db_lnk, $sql, $pg_params)) {
        $count = pg_num_rows($result);
        $i = 0;
        while ($row = pg_fetch_row($result)) {
            if ($i == 0 && $count > 1) {
                echo '[';
            }
            echo $row[0];
            $i++;
            if ($i < $count) {
                echo ',';
            } else {
                if ($count > 1) {
                    echo ']';
                }
            }
        }
        pg_free_result($result);
    }
}
function slugify($string)
{
    $separator = '-';
    $length = 100;
    $string = mb_strtolower($string, 'UTF-8');
    $string = preg_replace('/[\.\!\$\*\(\)\=\{\}\[\]\;\|\%\#\/\?\:\s\&\+\`\^\'\"\,\>\<\@]/i', $separator, $string);
    $string = preg_replace('/' . preg_quote($separator) . '[' . preg_quote($separator) . ']*/', $separator, $string);
    if (strlen($string) > $length) {
        $string = substr($string, 0, $length);
    }
    $string = preg_replace('/' . preg_quote($separator) . '$/', '', $string);
    $string = preg_replace('/^' . preg_quote($separator) . '/', '', $string);
    return $string;
}
function is_plugin_enabled($plugin_name)
{
    $file = APP_PATH . DS . 'client' . DS . 'apps' . DS . $plugin_name . DS . 'app.json';
    if (file_exists($file)) {
        $content = file_get_contents($file);
        $data = json_decode($content, true);
        if ($data['enabled'] === true) {
            return true;
        }
    }
    return false;
}
function importMember($member, $new_board, $import_type)
{
    $qry_val_arr = array(
        utf8_decode($member['username'])
    );
    global $r_debug, $db_lnk;
    $userExist = executeQuery('SELECT * FROM users WHERE username = $1', $qry_val_arr);
    if (!$userExist) {
        $default_email_notification = 0;
        if (DEFAULT_EMAIL_NOTIFICATION === 'Periodically') {
            $default_email_notification = 1;
        } elseif (DEFAULT_EMAIL_NOTIFICATION === 'Instantly') {
            $default_email_notification = 2;
        }
        $member['is_send_newsletter'] = $default_email_notification;
        $member['default_desktop_notification'] = (DEFAULT_DESKTOP_NOTIFICATION === 'Enabled') ? 'true' : 'false';
        $member['is_list_notifications_enabled'] = IS_LIST_NOTIFICATIONS_ENABLED;
        $member['is_card_notifications_enabled'] = IS_CARD_NOTIFICATIONS_ENABLED;
        $member['is_card_members_notifications_enabled'] = IS_CARD_MEMBERS_NOTIFICATIONS_ENABLED;
        $member['is_card_labels_notifications_enabled'] = IS_CARD_LABELS_NOTIFICATIONS_ENABLED;
        $member['is_card_checklists_notifications_enabled'] = IS_CARD_CHECKLISTS_NOTIFICATIONS_ENABLED;
        $member['is_card_attachments_notifications_enabled'] = IS_CARD_ATTACHMENTS_NOTIFICATIONS_ENABLED;
        $qry_val_arr = array(
            utf8_decode($member['username']) ,
            getCryptHash('restya') ,
            utf8_decode($member['initials']) ,
            utf8_decode($member['fullName']) ,
            $member['is_send_newsletter'],
            $member['default_desktop_notification'],
            $member['is_list_notifications_enabled'],
            $member['is_card_notifications_enabled'],
            $member['is_card_members_notifications_enabled'],
            $member['is_card_labels_notifications_enabled'],
            $member['is_card_checklists_notifications_enabled'],
            $member['is_card_attachments_notifications_enabled'],
            $import_type . '-' . utf8_decode($member['username']) . '@mailinator.com',
        );
        $user = pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO users (created, modified, role_id, username, email, password, is_active, is_email_confirmed, initials, full_name, is_send_newsletter, default_desktop_notification, is_list_notifications_enabled, is_card_notifications_enabled, is_card_members_notifications_enabled, is_card_labels_notifications_enabled, is_card_checklists_notifications_enabled, is_card_attachments_notifications_enabled) VALUES (now(), now(), 2, $1, $13, $2, true, true, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12) RETURNING id', $qry_val_arr));
        $users[$member['id']] = $user['id'];
        if (isset($member['avatarUrl']) && !empty($member['avatarUrl'])) {
            $mediadir = MEDIA_PATH . DS . 'User' . DS . $user['id'];
            $save_path = 'User' . DS . $user['id'];
            $save_path = str_replace('\\', '/', $save_path);
            $filename = curlExecute($member['avatarUrl'], 'get', $mediadir, 'image');
            $path = $save_path . DS . $filename['file_name'];
            $qry_val_arr = array(
                $path,
                $user['id']
            );
            pg_query_params($db_lnk, 'UPDATE users SET profile_picture_path = $1 WHERE id = $2', $qry_val_arr);
        }
    } else {
        $users[$member['id']] = $userExist['id'];
    }
    $qry_val_arr = array(
        $users[$member['id']],
        $new_board['id']
    );
    pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO boards_users (created, modified, user_id, board_id, board_user_role_id) VALUES (now(), now(), $1, $2, 2) RETURNING id', $qry_val_arr));
    $auto_subscribe_on_board = (AUTO_SUBSCRIBE_ON_BOARD === 'Enabled') ? 'true' : false;
    if ($auto_subscribe_on_board) {
        $qry_val_arr = array(
            $users[$member['id']],
            $new_board['id'],
            true
        );
        pg_query_params($db_lnk, 'INSERT INTO board_subscribers (created, modified, user_id, board_id, is_subscribed) VALUES (now(), now(), $1, $2, $3)', $qry_val_arr);
    }
    return $users;
}
function array_msort($array, $cols)
{
    $colarr = array();
    foreach ($cols as $col => $order) {
        $colarr[$col] = array();
        foreach ($array as $k => $row) {
            $colarr[$col]['_' . $k] = strtolower($row[$col]);
        }
    }
    $eval = 'array_multisort(';
    foreach ($cols as $col => $order) {
        $eval.= '$colarr[\'' . $col . '\'],' . $order . ',';
    }
    $eval = substr($eval, 0, -1) . ');';
    eval($eval);
    $ret = array();
    foreach ($colarr as $col => $arr) {
        foreach ($arr as $k => $v) {
            $k = substr($k, 1);
            if (!isset($ret[$k])) $ret[$k] = $array[$k];
            $ret[$k][$col] = $array[$k][$col];
        }
    }
    return $ret;
}
function board_creation($qry_val_arr = array() , $db_lnk)
{
    $new_board = pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO boards (created, modified, name, background_color, background_picture_url, background_pattern_url, user_id, board_visibility) VALUES (now(), now(), $1, $2, $3, $4, $5, $6) RETURNING id', $qry_val_arr));
    return $new_board;
}
/**
 * Generate client id
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
 * Generate client secret
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
 * Multi language support
 *
 * @return translated text
 */
function __l($text)
{
    global $locales;
    if (!empty($locales) && !empty($locales[$text])) {
        return $locales[$text];
    }
    return $text;
}
/**
 * E-mail notification
 *
 * @return mail
 */
function sendMailNotification($notification_type)
{
    global $r_debug, $db_lnk, $_server_domain_url;
    $qry_val_arr = array(
        $notification_type
    );
    $card_activity_types = array(
        'edit_card_desc',
        'delete_card_users',
        'add_card_user',
        'delete_card_duedate',
        'add_card_duedate',
        'delete_card_attachment',
        'add_card_attachment',
        "edit_card",
        "archived_card",
        'delete_card_label',
        'add_card_label',
        'delete_card_comment',
        'unarchived_card',
        'edit_card_duedate',
        'edit_card_startdate',
        'add_card_startdate',
        'delete_card_startdate',
        'edit_card_estimatedtime',
        'add_card_estimatedtime',
        "delete_card_estimatedtime",
        "edit_card_spenttime",
        'add_card_spenttime',
        "delete_card_spenttime",
        "add_card_desc",
        'add_card_color',
        "delete_card_color",
        "edit_card_color",
        "update_card_checklist_item",
        "moved_card_checklist_item",
        "update_card_checklist",
        "edit_comment",
        'add_card_custom_field',
        "update_card_custom_field",
        'delete_card_custom_field',
        "add_checklist_item",
        'add_card_voter',
        'add_comment'
    );
    $users_result = pg_query_params($db_lnk, 'SELECT users.id, users.username, users.email, users.full_name, users.last_email_notified_activity_id, users.timezone, users.language, (SELECT array_to_json(array_agg(row_to_json(d))) FROM (SELECT bs.board_id FROM board_subscribers bs WHERE bs.user_id = users.id AND bs.is_subscribed = \'t\') d) AS board_ids, (SELECT array_to_json(array_agg(row_to_json(d))) FROM (SELECT ls.list_id, l.board_id FROM list_subscribers ls, lists l WHERE ls.user_id = users.id AND l.id = ls.list_id AND ls.is_subscribed = \'t\') d) AS list_ids,(SELECT array_to_json(array_agg(row_to_json(d))) FROM (SELECT cs.card_id, c.list_id, c.board_id FROM card_subscribers cs, cards c WHERE cs.user_id = users.id AND c.id = cs.card_id AND cs.is_subscribed = \'t\') d) AS card_ids FROM users WHERE is_send_newsletter = $1', $qry_val_arr);
    while ($user = pg_fetch_assoc($users_result)) {
        $board_ids = $list_ids = $card_ids = array();
        $board_arr = (!empty($user['board_ids'])) ? array_filter(json_decode($user['board_ids'], true)) : '';
        $list_arr = (!empty($user['list_ids'])) ? array_filter(json_decode($user['list_ids'], true)) : '';
        $card_arr = (!empty($user['card_ids'])) ? array_filter(json_decode($user['card_ids'], true)) : '';
        if (!empty($board_arr) && is_array($board_arr)) {
            foreach ($board_arr as $boards) {
                $board_ids[] = $boards['board_id'];
            }
        }
        if (!empty($list_arr) && is_array($list_arr)) {
            foreach ($list_arr as $lists) {
                if (!in_array($lists['board_id'], $board_ids)) {
                    $list_ids[] = $lists['list_id'];
                }
            }
        }
        if (!empty($card_arr) && is_array($card_arr)) {
            foreach ($card_arr as $cards) {
                if (!in_array($cards['board_id'], $board_ids) && !in_array($cards['list_id'], $list_ids)) {
                    $card_ids[] = $cards['card_id'];
                }
            }
        }
        $mail_content = $mentioned_mail_content = '';
        $activities_result = '';
        $notification_count = 0;
        $reply_to_mail = '';
        $reply_to = '';
        if (!empty($board_ids)) {
            $qry_arr = array(
                $user['last_email_notified_activity_id'],
                $user['id'],
                '{' . implode(',', $board_ids) . '}'
            );
            $activities_result = pg_query_params($db_lnk, 'SELECT * FROM activities_listing WHERE id > $1 AND user_id != $2 AND board_id = ANY ($3) ORDER BY id DESC', $qry_arr);
            $i = 0;
            $tmp_card_id = '';
            while ($activity = pg_fetch_assoc($activities_result)) {
                if (!empty($activity['profile_picture_path'])) {
                    $hash = md5(SECURITYSALT . 'User' . $activity['user_id'] . 'png' . 'small_thumb');
                    $profile_picture_path = $_server_domain_url . '/img/small_thumb/User/' . $activity['user_id'] . '.' . $hash . '.png';
                    $user_avatar = '<img style="margin-right: 10px;vertical-align: middle;" src="' . $profile_picture_path . '" alt="[Image: ' . $activity['full_name'] . ']" class="img-rounded img-responsive">' . "\n";
                } else if (!empty($activity['initials'])) {
                    $user_avatar = '<i style="border-radius:4px;text-shadow:#6f6f6f 0.02em 0.02em 0.02em;width:32px;height:32px;line-height:32px;font-size:16px;display:inline-block;font-style:normal;text-align:center;text-transform:uppercase;color:#f47564 !important;background-color:#ffffff !important;border:1px solid #d7d9db;margin-right: 10px;">' . $activity['initials'] . '</i>' . "\n";
                }
                if (empty($i)) {
                    $activity_id[] = $activity['id'];
                    $i++;
                }
                $is_mention_activity = 0;
                if ($activity['type'] == 'add_comment' || $activity['type'] == 'edit_comment') {
                    preg_match_all('/@([^ ]*)/', $activity['comment'], $matches);
                    if (in_array($user['username'], $matches[1])) {
                        $mentioned_activity = $activity;
                        $is_mention_activity = 1;
                        $mentioned_activity['comment'] = __l('##USER_NAME## has mentioned you in card ##CARD_NAME## on ##BOARD_NAME##') . '<div style="margin:5px 0px 0px 43px"><div style="background-color: #ffffff;border: 1px solid #dddddd;border-radius: 4px;display: block;line-height: 1.42857;margin:7px 0;padding: 4px;transition: all 0.2s ease-in-out 0s;"><div style="padding:3px 0px 0px 0px;margin:0px">' . $activity['comment'] . '</div></div></div>';
                        $activity['comment'] = '';
                    } else {
                        $activity['comment'] = __l('##USER_NAME## commented to the card ##CARD_NAME## on ##BOARD_NAME##') . '<div style="margin:5px 0px 0px 43px"><div style="background-color: #ffffff;border: 1px solid #dddddd;border-radius: 4px;display: block;line-height: 1.42857;margin:7px 0;padding: 4px;transition: all 0.2s ease-in-out 0s;"><div style="padding:3px 0px 0px 0px;margin:0px">' . $activity['comment'] . '</div></div></div>';
                    }
                    $br = '<div style="line-height:20px;">&nbsp;</div>';
                } else {
                    if ($is_mention_activity) {
                        $mentioned_activity['comment'].= __l(' on ##BOARD_NAME##');
                        $br = '<div style="line-height:40px;">&nbsp;</div>';
                    } else {
                        $activity['comment'].= __l(' on ##BOARD_NAME##');
                        $br = '<div style="line-height:40px;">&nbsp;</div>';
                    }
                }
                if (!empty($activity['list_name']) && in_array($activity['type'], $card_activity_types)) {
                    $replaceContent = array(
                        'on ##BOARD_NAME##' => 'on list ##LIST_NAME##  of the ##BOARD_NAME##'
                    );
                    if ($is_mention_activity) {
                        if (strpos($mentioned_activity['comment'], '##LIST_NAME##') === false) {
                            $mentioned_activity['comment'] = strtr($mentioned_activity['comment'], $replaceContent);
                        }
                    }
                    if (strpos($activity['comment'], '##LIST_NAME##') === false) {
                        $activity['comment'] = strtr($activity['comment'], $replaceContent);
                    }
                }
                if (!empty($activity['card_id']) && IMAP_EMAIL) {
                    $imap_email = explode("@", IMAP_EMAIL);
                    $board_email = $imap_email[0] . '+' . $activity['board_id'] . '+' . $activity['card_id'] . '+' . md5(SECURITYSALT . $activity['board_id'] . $activity['card_id']) . '@' . $imap_email[1];
                    $qry_arr = array(
                        $activity['card_id']
                    );
                    $card = pg_query_params($db_lnk, 'SELECT * FROM cards WHERE id = $1', $qry_arr);
                    $card = pg_fetch_assoc($card);
                    $mail_to = 'mailto:' . $board_email . '?subject=RE:' . $card['name'];
                    if (empty($tmp_card_id) || $tmp_card_id == $activity['card_id']) {
                        $reply_to_mail = $board_email;
                    } else {
                        $reply_to_mail = '';
                    }
                    $tmp_card_id = $activity['card_id'];
                    $reply_to = '<div style="margin:5px 0px 0px 43px;"><a href="' . $mail_to . '" target="_blank">Reply via email</a></div>' . "\n";
                }
                if (!empty($activity['revisions']) && trim($activity['revisions']) !== '') {
                    $revisions = unserialize($activity['revisions']);
                    $activity['revisions'] = $revisions;
                    unset($dif);
                    if (!empty($revisions['new_value'])) {
                        foreach ($revisions['new_value'] as $key => $value) {
                            if ($key != 'is_archived' && $key != 'is_deleted' && $key != 'created' && $key != 'modified' && $key != 'is_offline' && $key != 'uuid' && $key != 'to_date' && $key != 'temp_id' && $activity['type'] != 'moved_card_checklist_item' && $activity['type'] != 'add_card_desc' && $activity['type'] != 'add_card_duedate' && $activity['type'] != 'delete_card_duedate' && $activity['type'] != 'add_background' && $activity['type'] != 'change_background' && $activity['type'] != 'change_visibility' && $activity['type'] != 'change_card_position') {
                                $old_val = (isset($revisions['old_value'][$key]) && $revisions['old_value'][$key] != null && $revisions['old_value'][$key] != 'null') ? $revisions['old_value'][$key] : '';
                                $new_val = (isset($revisions['new_value'][$key]) && $revisions['new_value'][$key] != null && $revisions['new_value'][$key] != 'null') ? $revisions['new_value'][$key] : '';
                                $dif[] = nl2br(getRevisiondifference($old_val, $new_val));
                            }
                            if ($activity['type'] == 'add_card_desc' || $activity['type'] == 'add_card_desc' || $activity['type'] == '	edit_card_duedate' || $activity['type'] == 'add_background' || $activity['type'] == 'change_background' || $activity['type'] == 'change_visibility') {
                                $dif[] = $revisions['new_value'][$key];
                            }
                        }
                    } else if (!empty($revisions['old_value']) && isset($activity['type']) && $activity['type'] == 'delete_card_comment') {
                        $dif[] = nl2br(getRevisiondifference($revisions['old_value'], ''));
                    }
                    if (isset($dif)) {
                        $activity['difference'] = $dif;
                    }
                    if (!empty($activity['difference'][0])) {
                        $search = array(
                            '<del',
                            '<ins'
                        );
                        $replace = array(
                            '<del style="padding: 0px 3px;font-size: 90%;line-height: 1;text-align: center;white-space: nowrap;vertical-align: baseline;background: #e5bdb2;color: #a82400;margin-left: 3px;"',
                            '<ins style="padding: 0px 3px;font-size: 90%;line-height: 1;text-align: center;white-space: nowrap;vertical-align: baseline;background: #d1e1ad;color: #405a04;text-decoration: none;margin-right: 3px;"'
                        );
                        $difference = str_replace($search, $replace, $activity['difference'][0]);
                        if ($is_mention_activity) {
                            $mentioned_activity['comment'].= '<div style="margin:5px 0px 0px 43px"><div style="background-color: #ffffff;border: 1px solid #dddddd;border-radius: 4px;display: block;line-height: 1.42857;margin:7px 0;padding: 4px;transition: all 0.2s ease-in-out 0s;"><div style="padding:3px 0px 0px 0px;margin:0px">' . $difference . '</div></div></div>';
                        } else {
                            $activity['comment'].= '<div style="margin:5px 0px 0px 43px"><div style="background-color: #ffffff;border: 1px solid #dddddd;border-radius: 4px;display: block;line-height: 1.42857;margin:7px 0;padding: 4px;transition: all 0.2s ease-in-out 0s;"><div style="padding:3px 0px 0px 0px;margin:0px">' . $difference . '</div></div></div>';
                        }
                    }
                }
                if ($is_mention_activity) {
                    $comment = findAndReplaceVariables($mentioned_activity);
                    $mentioned_mail_content.= '<div>' . "\n";
                    $mentioned_mail_content.= '<div style="float:left">' . $user_avatar . '</div>' . "\n";
                    $mentioned_mail_content.= '<div>' . $comment . $reply_to . '</div>' . "\n";
                    $mentioned_mail_content.= '</div>' . "\n";
                    $mentioned_mail_content.= $br . "\n";
                } else {
                    $comment = findAndReplaceVariables($activity);
                    $mail_content.= '<div>' . "\n";
                    $mail_content.= '<div style="float:left">' . $user_avatar . '</div>' . "\n";
                    $mail_content.= '<div>' . $comment . $reply_to . '</div>' . "\n";
                    $mail_content.= '</div>' . "\n";
                    $mail_content.= $br . "\n";
                }
                $notification_count++;
            }
        }
        if (!empty($list_ids)) {
            $qry_arr = array(
                $user['last_email_notified_activity_id'],
                $user['id'],
                '{' . implode(',', $list_ids) . '}'
            );
            $activities_result = pg_query_params($db_lnk, 'SELECT * FROM activities_listing WHERE id > $1 AND user_id != $2 AND list_id = ANY ($3) ORDER BY id DESC', $qry_arr);
            $i = 0;
            $tmp_card_id = '';
            while ($activity = pg_fetch_assoc($activities_result)) {
                if (!empty($activity['profile_picture_path'])) {
                    $hash = md5(SECURITYSALT . 'User' . $activity['user_id'] . 'png' . 'small_thumb');
                    $profile_picture_path = $_server_domain_url . '/img/small_thumb/User/' . $activity['user_id'] . '.' . $hash . '.png';
                    $user_avatar = '<img style="margin-right: 10px;vertical-align: middle;" src="' . $profile_picture_path . '" alt="[Image: ' . $activity['full_name'] . ']" class="img-rounded img-responsive">' . "\n";
                } else if (!empty($activity['initials'])) {
                    $user_avatar = '<i style="border-radius:4px;text-shadow:#6f6f6f 0.02em 0.02em 0.02em;width:32px;height:32px;line-height:32px;font-size:16px;display:inline-block;font-style:normal;text-align:center;text-transform:uppercase;color:#f47564 !important;background-color:#ffffff !important;border:1px solid #d7d9db;margin-right: 10px;">' . $activity['initials'] . '</i>' . "\n";
                }
                if (empty($i)) {
                    $activity_id[] = $activity['id'];
                    $i++;
                }
                $is_mention_activity = 0;
                if ($activity['type'] == 'add_comment' || $activity['type'] == 'edit_comment') {
                    preg_match_all('/@([^ ]*)/', $activity['comment'], $matches);
                    if (in_array($user['username'], $matches[1])) {
                        $mentioned_activity = $activity;
                        $is_mention_activity = 1;
                        $mentioned_activity['comment'] = __l('##USER_NAME## has mentioned you in card ##CARD_NAME## on ##BOARD_NAME##') . '<div style="margin:5px 0px 0px 43px"><div style="background-color: #ffffff;border: 1px solid #dddddd;border-radius: 4px;display: block;line-height: 1.42857;margin:7px 0;padding: 4px;transition: all 0.2s ease-in-out 0s;"><div style="padding:3px 0px 0px 0px;margin:0px">' . $activity['comment'] . '</div></div></div>';
                        $activity['comment'] = '';
                    } else {
                        $activity['comment'] = __l('##USER_NAME## commented to the card ##CARD_NAME## on ##BOARD_NAME##') . '<div style="margin:5px 0px 0px 43px"><div style="background-color: #ffffff;border: 1px solid #dddddd;border-radius: 4px;display: block;line-height: 1.42857;margin:7px 0;padding: 4px;transition: all 0.2s ease-in-out 0s;"><div style="padding:3px 0px 0px 0px;margin:0px">' . $activity['comment'] . '</div></div></div>';
                    }
                    $br = '<div style="line-height:20px;">&nbsp;</div>';
                } else {
                    if ($is_mention_activity) {
                        $mentioned_activity['comment'].= __l(' on ##BOARD_NAME##');
                        $br = '<div style="line-height:40px;">&nbsp;</div>';
                    } else {
                        $activity['comment'].= __l(' on ##BOARD_NAME##');
                        $br = '<div style="line-height:40px;">&nbsp;</div>';
                    }
                }
                if (!empty($activity['list_name']) && in_array($activity['type'], $card_activity_types)) {
                    $replaceContent = array(
                        'on ##BOARD_NAME##' => 'on list ##LIST_NAME##  of the ##BOARD_NAME##'
                    );
                    if ($is_mention_activity) {
                        if (strpos($mentioned_activity['comment'], '##LIST_NAME##') === false) {
                            $mentioned_activity['comment'] = strtr($mentioned_activity['comment'], $replaceContent);
                        }
                    }
                    if (strpos($activity['comment'], '##LIST_NAME##') === false) {
                        $activity['comment'] = strtr($activity['comment'], $replaceContent);
                    }
                }
                if (!empty($activity['card_id']) && IMAP_EMAIL) {
                    $imap_email = explode("@", IMAP_EMAIL);
                    $board_email = $imap_email[0] . '+' . $activity['board_id'] . '+' . $activity['card_id'] . '+' . md5(SECURITYSALT . $activity['board_id'] . $activity['card_id']) . '@' . $imap_email[1];
                    $qry_arr = array(
                        $activity['card_id']
                    );
                    $card = pg_query_params($db_lnk, 'SELECT * FROM cards WHERE id = $1', $qry_arr);
                    $card = pg_fetch_assoc($card);
                    $mail_to = 'mailto:' . $board_email . '?subject=RE:' . $card['name'];
                    if (empty($tmp_card_id) || $tmp_card_id == $activity['card_id']) {
                        $reply_to_mail = $board_email;
                    } else {
                        $reply_to_mail = '';
                    }
                    $tmp_card_id = $activity['card_id'];
                    $reply_to = '<div style="margin:5px 0px 0px 43px;"><a href="' . $mail_to . '" target="_blank">Reply via email</a></div>' . "\n";
                }
                if (!empty($activity['revisions']) && trim($activity['revisions']) !== '') {
                    $revisions = unserialize($activity['revisions']);
                    $activity['revisions'] = $revisions;
                    unset($dif);
                    if (!empty($revisions['new_value'])) {
                        foreach ($revisions['new_value'] as $key => $value) {
                            if ($key != 'is_archived' && $key != 'is_deleted' && $key != 'created' && $key != 'modified' && $key != 'is_offline' && $key != 'uuid' && $key != 'to_date' && $key != 'temp_id' && $activity['type'] != 'moved_card_checklist_item' && $activity['type'] != 'add_card_desc' && $activity['type'] != 'add_card_duedate' && $activity['type'] != 'delete_card_duedate' && $activity['type'] != 'add_background' && $activity['type'] != 'change_background' && $activity['type'] != 'change_visibility') {
                                $old_val = (isset($revisions['old_value'][$key]) && $revisions['old_value'][$key] != null && $revisions['old_value'][$key] != 'null') ? $revisions['old_value'][$key] : '';
                                $new_val = (isset($revisions['new_value'][$key]) && $revisions['new_value'][$key] != null && $revisions['new_value'][$key] != 'null') ? $revisions['new_value'][$key] : '';
                                $dif[] = nl2br(getRevisiondifference($old_val, $new_val));
                            }
                            if ($activity['type'] == 'add_card_desc' || $activity['type'] == 'add_card_desc' || $activity['type'] == '	edit_card_duedate' || $activity['type'] == 'add_background' || $activity['type'] == 'change_background' || $activity['type'] == 'change_visibility') {
                                $dif[] = $revisions['new_value'][$key];
                            }
                        }
                    } else if (!empty($revisions['old_value']) && isset($activity['type']) && $activity['type'] == 'delete_card_comment') {
                        $dif[] = nl2br(getRevisiondifference($revisions['old_value'], ''));
                    }
                    if (isset($dif)) {
                        $activity['difference'] = $dif;
                    }
                    if (!empty($activity['difference'][0])) {
                        $search = array(
                            '<del',
                            '<ins'
                        );
                        $replace = array(
                            '<del style="padding: 0px 3px;font-size: 90%;line-height: 1;text-align: center;white-space: nowrap;vertical-align: baseline;background: #e5bdb2;color: #a82400;margin-left: 3px;"',
                            '<ins style="padding: 0px 3px;font-size: 90%;line-height: 1;text-align: center;white-space: nowrap;vertical-align: baseline;background: #d1e1ad;color: #405a04;text-decoration: none;margin-right: 3px;"'
                        );
                        $difference = str_replace($search, $replace, $activity['difference'][0]);
                        if ($is_mention_activity) {
                            $mentioned_activity['comment'].= '<div style="margin:5px 0px 0px 43px"><div style="background-color: #ffffff;border: 1px solid #dddddd;border-radius: 4px;display: block;line-height: 1.42857;margin:7px 0;padding: 4px;transition: all 0.2s ease-in-out 0s;"><div style="padding:3px 0px 0px 0px;margin:0px">' . $difference . '</div></div></div>';
                        } else {
                            $activity['comment'].= '<div style="margin:5px 0px 0px 43px"><div style="background-color: #ffffff;border: 1px solid #dddddd;border-radius: 4px;display: block;line-height: 1.42857;margin:7px 0;padding: 4px;transition: all 0.2s ease-in-out 0s;"><div style="padding:3px 0px 0px 0px;margin:0px">' . $difference . '</div></div></div>';
                        }
                    }
                }
                if ($is_mention_activity) {
                    $comment = findAndReplaceVariables($mentioned_activity);
                    $mentioned_mail_content.= '<div>' . "\n";
                    $mentioned_mail_content.= '<div style="float:left">' . $user_avatar . '</div>' . "\n";
                    $mentioned_mail_content.= '<div>' . $comment . $reply_to . '</div>' . "\n";
                    $mentioned_mail_content.= '</div>' . "\n";
                    $mentioned_mail_content.= $br . "\n";
                } else {
                    $comment = findAndReplaceVariables($activity);
                    $mail_content.= '<div>' . "\n";
                    $mail_content.= '<div style="float:left">' . $user_avatar . '</div>' . "\n";
                    $mail_content.= '<div>' . $comment . $reply_to . '</div>' . "\n";
                    $mail_content.= '</div>' . "\n";
                    $mail_content.= $br . "\n";
                }
                $notification_count++;
            }
        }
        if (!empty($card_ids)) {
            $qry_arr = array(
                $user['last_email_notified_activity_id'],
                $user['id'],
                '{' . implode(',', $card_ids) . '}'
            );
            $activities_result = pg_query_params($db_lnk, 'SELECT * FROM activities_listing WHERE id > $1 AND user_id != $2 AND card_id = ANY ($3) ORDER BY id DESC', $qry_arr);
            $i = 0;
            $tmp_card_id = '';
            while ($activity = pg_fetch_assoc($activities_result)) {
                if (!empty($activity['profile_picture_path'])) {
                    $hash = md5(SECURITYSALT . 'User' . $activity['user_id'] . 'png' . 'small_thumb');
                    $profile_picture_path = $_server_domain_url . '/img/small_thumb/User/' . $activity['user_id'] . '.' . $hash . '.png';
                    $user_avatar = '<img style="margin-right: 10px;vertical-align: middle;" src="' . $profile_picture_path . '" alt="[Image: ' . $activity['full_name'] . ']" class="img-rounded img-responsive">' . "\n";
                } else if (!empty($activity['initials'])) {
                    $user_avatar = '<i style="border-radius:4px;text-shadow:#6f6f6f 0.02em 0.02em 0.02em;width:32px;height:32px;line-height:32px;font-size:16px;display:inline-block;font-style:normal;text-align:center;text-transform:uppercase;color:#02aff1 !important;background-color:#ffffff !important;border:1px solid #d7d9db;margin-right: 10px;">' . $activity['initials'] . '</i>' . "\n";
                }
                if (empty($i)) {
                    $activity_id[] = $activity['id'];
                    $i++;
                }
                $is_mention_activity = 0;
                if ($activity['type'] == 'add_comment' || $activity['type'] == 'edit_comment') {
                    preg_match_all('/@([^ ]*)/', $activity['comment'], $matches);
                    if (in_array($user['username'], $matches[1])) {
                        $mentioned_activity = $activity;
                        $is_mention_activity = 1;
                        $mentioned_activity['comment'] = __l('##USER_NAME## has mentioned you in card ##CARD_NAME## on ##BOARD_NAME##') . '<div style="margin:5px 0px 0px 43px"><div style="background-color: #ffffff;border: 1px solid #dddddd;border-radius: 4px;display: block;line-height: 1.42857;margin:7px 0;padding: 4px;transition: all 0.2s ease-in-out 0s;"><div style="padding:3px 0px 0px 0px;margin:0px">' . $activity['comment'] . '</div></div></div>';
                        $activity['comment'] = '';
                    } else {
                        $activity['comment'] = __l('##USER_NAME## commented to the card ##CARD_NAME## on ##BOARD_NAME##') . '<div style="margin:5px 0px 0px 43px"><div style="background-color: #ffffff;border: 1px solid #dddddd;border-radius: 4px;display: block;line-height: 1.42857;margin:7px 0;padding: 4px;transition: all 0.2s ease-in-out 0s;"><div style="padding:3px 0px 0px 0px;margin:0px">' . $activity['comment'] . '</div></div></div>';
                    }
                    $br = '<div style="line-height:20px;">&nbsp;</div>';
                } else {
                    if ($is_mention_activity) {
                        $mentioned_activity['comment'].= __l(' on ##BOARD_NAME##');
                        $br = '<div style="line-height:40px;">&nbsp;</div>';
                    } else {
                        $activity['comment'].= __l(' on ##BOARD_NAME##');
                        $br = '<div style="line-height:40px;">&nbsp;</div>';
                    }
                }
                if (!empty($activity['list_name']) && in_array($activity['type'], $card_activity_types)) {
                    $replaceContent = array(
                        'on ##BOARD_NAME##' => 'on list ##LIST_NAME##  of the ##BOARD_NAME##'
                    );
                    if ($is_mention_activity) {
                        if (strpos($mentioned_activity['comment'], '##LIST_NAME##') === false) {
                            $mentioned_activity['comment'] = strtr($mentioned_activity['comment'], $replaceContent);
                        }
                    }
                    if (strpos($activity['comment'], '##LIST_NAME##') === false) {
                        $activity['comment'] = strtr($activity['comment'], $replaceContent);
                    }
                }
                if (!empty($activity['card_id']) && IMAP_EMAIL) {
                    $imap_email = explode("@", IMAP_EMAIL);
                    $board_email = $imap_email[0] . '+' . $activity['board_id'] . '+' . $activity['card_id'] . '+' . md5(SECURITYSALT . $activity['board_id'] . $activity['card_id']) . '@' . $imap_email[1];
                    $qry_arr = array(
                        $activity['card_id']
                    );
                    $card = pg_query_params($db_lnk, 'SELECT * FROM cards WHERE id = $1', $qry_arr);
                    $card = pg_fetch_assoc($card);
                    $mail_to = 'mailto:' . $board_email . '?subject=RE:' . $card['name'];
                    if (empty($tmp_card_id) || $tmp_card_id == $activity['card_id']) {
                        $reply_to_mail = $board_email;
                    } else {
                        $reply_to_mail = '';
                    }
                    $tmp_card_id = $activity['card_id'];
                    $reply_to = '<div style="margin:5px 0px 0px 43px;"><a href="' . $mail_to . '" target="_blank">Reply via email</a></div>' . "\n";
                }
                if (!empty($activity['revisions']) && trim($activity['revisions']) !== '') {
                    $revisions = unserialize($activity['revisions']);
                    $activity['revisions'] = $revisions;
                    unset($dif);
                    if (!empty($revisions['new_value'])) {
                        foreach ($revisions['new_value'] as $key => $value) {
                            if ($key != 'is_archived' && $key != 'is_deleted' && $key != 'created' && $key != 'modified' && $key != 'is_offline' && $key != 'uuid' && $key != 'to_date' && $key != 'temp_id' && $activity['type'] != 'moved_card_checklist_item' && $activity['type'] != 'add_card_desc' && $activity['type'] != 'add_card_duedate' && $activity['type'] != 'delete_card_duedate' && $activity['type'] != 'add_background' && $activity['type'] != 'change_background' && $activity['type'] != 'change_visibility') {
                                $old_val = (isset($revisions['old_value'][$key]) && $revisions['old_value'][$key] != null && $revisions['old_value'][$key] != 'null') ? $revisions['old_value'][$key] : '';
                                $new_val = (isset($revisions['new_value'][$key]) && $revisions['new_value'][$key] != null && $revisions['new_value'][$key] != 'null') ? $revisions['new_value'][$key] : '';
                                $dif[] = nl2br(getRevisiondifference($old_val, $new_val));
                            }
                            if ($activity['type'] == 'add_card_desc' || $activity['type'] == 'add_card_desc' || $activity['type'] == '	edit_card_duedate' || $activity['type'] == 'add_background' || $activity['type'] == 'change_background' || $activity['type'] == 'change_visibility') {
                                $dif[] = $revisions['new_value'][$key];
                            }
                        }
                    } else if (!empty($revisions['old_value']) && isset($activity['type']) && $activity['type'] == 'delete_card_comment') {
                        $dif[] = nl2br(getRevisiondifference($revisions['old_value'], ''));
                    }
                    if (isset($dif)) {
                        $activity['difference'] = $dif;
                    }
                    if (!empty($activity['difference'][0])) {
                        $search = array(
                            '<del',
                            '<ins'
                        );
                        $replace = array(
                            '<del style="padding: 0px 3px;font-size: 90%;line-height: 1;text-align: center;white-space: nowrap;vertical-align: baseline;background: #e5bdb2;color: #a82400;margin-left: 3px;"',
                            '<ins style="padding: 0px 3px;font-size: 90%;line-height: 1;text-align: center;white-space: nowrap;vertical-align: baseline;background: #d1e1ad;color: #405a04;text-decoration: none;margin-right: 3px;"'
                        );
                        $difference = str_replace($search, $replace, $activity['difference'][0]);
                        if ($is_mention_activity) {
                            $mentioned_activity['comment'].= '<div style="margin:5px 0px 0px 43px"><div style="background-color: #ffffff;border: 1px solid #dddddd;border-radius: 4px;display: block;line-height: 1.42857;margin:7px 0;padding: 4px;transition: all 0.2s ease-in-out 0s;"><div style="padding:3px 0px 0px 0px;margin:0px">' . $difference . '</div></div></div>';
                        } else {
                            $activity['comment'].= '<div style="margin:5px 0px 0px 43px"><div style="background-color: #ffffff;border: 1px solid #dddddd;border-radius: 4px;display: block;line-height: 1.42857;margin:7px 0;padding: 4px;transition: all 0.2s ease-in-out 0s;"><div style="padding:3px 0px 0px 0px;margin:0px">' . $difference . '</div></div></div>';
                        }
                    }
                }
                if ($is_mention_activity) {
                    $comment = findAndReplaceVariables($mentioned_activity);
                    $mentioned_mail_content.= '<div>' . "\n";
                    $mentioned_mail_content.= '<div style="float:left">' . $user_avatar . '</div>' . "\n";
                    $mentioned_mail_content.= '<div>' . $comment . $reply_to . '</div>' . "\n";
                    $mentioned_mail_content.= '</div>' . "\n";
                    $mentioned_mail_content.= $br . "\n";
                } else {
                    $comment = findAndReplaceVariables($activity);
                    $mail_content.= '<div>' . "\n";
                    $mail_content.= '<div style="float:left">' . $user_avatar . '</div>' . "\n";
                    $mail_content.= '<div>' . $comment . $reply_to . '</div>' . "\n";
                    $mail_content.= '</div>' . "\n";
                    $mail_content.= $br . "\n";
                }
                $notification_count++;
            }
        }
        if (!empty($mail_content) || !empty($mentioned_mail_content)) {
            $timezone = SITE_TIMEZONE;
            if (!empty($user['timezone'])) {
                $timezone = trim($user['timezone']);
            }
            $language = DEFAULT_LANGUAGE;
            if (!empty($user['language'])) {
                $language = $user['language'];
            }
            setlocale(LC_TIME, $language);
            date_default_timezone_set($timezone);
            $qry_arr = array(
                max($activity_id) ,
                $user['id']
            );
            $main_content = '';
            if ($mentioned_mail_content) {
                $main_content = '<h2 style="font-size:16px;font-family:Arial,Helvetica,sans-serif;margin:7px 0px 0px 43px;padding:35px 0px 0px 0px">Mentioned to you</h2><br>';
                $main_content.= $mentioned_mail_content;
            }
            if ($mail_content) {
                $main_content.= '<h2 style="font-size:16px;font-family:Arial,Helvetica,sans-serif;margin:7px 0px 0px 43px;padding:35px 0px 0px 0px">Activities</h2><br>';
            }
            $main_content.= $mail_content;
            pg_query_params($db_lnk, 'UPDATE users SET last_email_notified_activity_id = $1 WHERE id = $2', $qry_arr);
            $emailFindReplace['##CONTENT##'] = $main_content;
            $emailFindReplace['##NAME##'] = $user['full_name'];
            $emailFindReplace['##NOTIFICATION_COUNT##'] = $notification_count;
            $emailFindReplace['##SINCE##'] = strftime("%I:%M %p ( %B %e, %Y)");
            $emailFindReplace['##USER_ID##'] = $user['id'];
            sendMail('email_notification', $emailFindReplace, $user['email'], $reply_to_mail);
        }
    }
}
function updateDependency($parentCard)
{
    global $db_lnk;
    $val_array = array(
        $parentCard['id']
    );
    $child_cards = pg_query_params($db_lnk, 'SELECT child_card_id FROM card_dependencies WHERE parent_card_id = $1', $val_array);
    while ($row = pg_fetch_assoc($child_cards)) {
        if (!empty($row)) {
            $condition = array(
                $row['child_card_id']
            );
            $childCard = executeQuery('SELECT id FROM cards where id = $1', $condition);
            $parentCard[] = updateDependency($childCard);
        }
    }
    $response = "";
    if (!empty($parentCard)) {
        foreach ($parentCard as $card_id) {
            $response = $card_id . "," . $response;
        }
    }
    return $response;
}
