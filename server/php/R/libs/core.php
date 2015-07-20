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
 * @copyright  2014 Restya
 * @license    http://www.restya.com/ Restya Licence
 * @link       http://www.restya.com
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
 * @param  $str
 * @return string
 */
function getCryptHash($str)
{
    if (CRYPT_BLOWFISH) {
        if (version_compare(PHP_VERSION, '5.3.7') >= 0) { // http://www.php.net/security/crypt_blowfish.php
            $algo_selector = '$2y$';
        } else {
            $algo_selector = '$2a$';
        }
        $workload_factor = '12$'; // (around 300ms on Core i7 machine)
        $salt = $algo_selector . $workload_factor . getRandomStr(array_merge(array(
            '.',
            '/'
        ) , range('0', '9') , range('a', 'z') , range('A', 'Z')) , 22); // './0-9A-Za-z'
        
    } else if (CRYPT_MD5) {
        $algo_selector = '$1$';
        $salt = $algo_selector . getRandomStr(range(chr(33) , chr(127)) , 12); // actually chr(0) - chr(255), but used ASCII only
        
    } else if (CRYPT_SHA512) {
        $algo_selector = '$6$';
        $workload_factor = 'rounds=5000$';
        $salt = $algo_selector . $workload_factor . getRandomStr(range(chr(33) , chr(127)) , 16); // actually chr(0) - chr(255)
        
    } else if (CRYPT_SHA256) {
        $algo_selector = '$5$';
        $workload_factor = 'rounds=5000$';
        $salt = $algo_selector . $workload_factor . getRandomStr(range(chr(33) , chr(127)) , 16); // actually chr(0) - chr(255)
        
    } else if (CRYPT_EXT_DES) {
        $algo_selector = '_';
        $salt = $algo_selector . getRandomStr(array_merge(array(
            '.',
            '/'
        ) , range('0', '9') , range('a', 'z') , range('A', 'Z')) , 8); // './0-9A-Za-z'.
        
    } else if (CRYPT_STD_DES) {
        $algo_selector = '';
        $salt = $algo_selector . getRandomStr(array_merge(array(
            '.',
            '/'
        ) , range('0', '9') , range('a', 'z') , range('A', 'Z')) , 2); // './0-9A-Za-z'
        
    }
    return crypt($str, $salt);
}
/**
 * Execute CURL Request
 *
 * @param  $url
 * @param  $method[optional]	default value : get
 * @param  $post[optional]		default value : array ()
 * @param  $format[optional]	default value : plain
 * @return mixed
 */
function curlExecute($url, $method = 'get', $post = array() , $format = 'plain')
{
    $filename = '';
    $mediadir = '';
    if ($format == 'image') {
        $mediadir = $post;
        if (!file_exists($mediadir)) {
            mkdir($mediadir, 0777, true);
        }
        $path = explode('/', $url);
        $filename = $path[count($path) - 1];
    }
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
    curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
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
            curl_setopt($ch, CURLOPT_HTTPHEADER, array(
                'Content-Type: application/json',
                'Content-Length: ' . strlen($post_string)
            ));
        } else {
            $post_string = http_build_query($post, '', '&');
        }
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $post_string);
    }
    $response = curl_exec($ch);
    if ($format == 'image') {
        $info = curl_getinfo($ch);
        array_change_key_case($info);
        $content_type = explode('/', $info['content_type']);
        $filename = (strpos($filename, '.') !== false) ? $filename : $filename . '.' . $content_type[1];
        $filename = preg_replace('/[^A-Za-z0-9\-.]/', '', $filename);
        curl_close($ch);
        if (file_exists($mediadir . DIRECTORY_SEPARATOR . $filename)) {
            unlink($mediadir . DIRECTORY_SEPARATOR . $filename);
        }
        $fp = fopen($mediadir . DIRECTORY_SEPARATOR . $filename, 'x');
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
        if ($return === NULL) {
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
 * @param  $url
 * @param  $post[optional]		default value : array ()
 * @param  $format[optional]	default value : plain
 * @return mixed
 */
function doPost($url, $post = array() , $format = 'plain')
{
    return curlExecute($url, 'post', $post, $format);
}
/**
 * Get url by using CURL
 *
 * @param  $url
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
 * @param  $user_id
 * @param  $comment
 * @param  $type
 * @param  $foreign_id[optional]		default value : array ()
 * @param  $revision[optional]		default value : NULL
 * @return mixed
 */
function insertActivity($user_id, $comment, $type, $foreign_ids = array() , $revision = NULL, $foreign_id = NULL)
{
    global $r_debug, $db_lnk;
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
    if ($foreign_id != NULL) {
        array_push($fields, 'foreign_id');
        array_push($values, $foreign_id);
    }
    $all_foreign_ids = $foreign_ids;
    foreach ($foreign_ids as $key => $value) {
        if ($key != 'id') {
            array_push($fields, $key);
            if ($value === false) {
                array_push($values, 'false');
            } else {
                array_push($values, $value);
            }
        }
    }
    if (!empty($foreign_ids['board_id'])) {
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
    $result = pg_query_params($db_lnk, 'UPDATE activities SET materialized_path = $1, path = $2, depth = $3, freshness_ts = $4 WHERE id = $5 RETURNING *', array(
        $materialized_path,
        $path,
        $depth,
        $freshness_ts,
        $row['id']
    ));
    $row = pg_fetch_assoc($result);
    $s_row = pg_query_params($db_lnk, 'SELECT * FROM activities_listing WHERE id = $1', array(
        $row['id']
    ));
    $row = pg_fetch_assoc($s_row);
    return $row;
}
/**
 * Get difference between current and previous version
 *
 * @param  $from_text
 * @param  $to_text
 * @return difference
 */
function getRevisiondifference($from_text, $to_text)
{
    // limit input
    $from_text = substr($from_text, 0, 1024 * 100);
    $to_text = substr($to_text, 0, 1024 * 100);
    // ensure input is suitable for diff
    $from_text = mb_convert_encoding($from_text, 'HTML-ENTITIES', 'UTF-8');
    $to_text = mb_convert_encoding($to_text, 'HTML-ENTITIES', 'UTF-8');
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
 * @param  $p_user_id
 * @param  $p_password
 * @return user
 */
function ldapAuthenticate($p_user_id, $p_password)
{
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
        'dn',
        '*'
    );
    $t_ldap_server = $g_ldap_server;
    $t_ldap_port = $g_ldap_port;
    $t_ds = @ldap_connect($t_ldap_server, $t_ldap_port);
    if ($t_ds > 0) {
        $t_protocol_version = $g_ldap_protocol_version;
        if ($t_protocol_version > 0) {
            ldap_set_option($t_ds, LDAP_OPT_PROTOCOL_VERSION, $t_protocol_version);
        }
        // If no Bind DN and Password is set, attempt to login as the configured
        //  Bind DN.
        $t_password = '';
        $t_binddn = '';
        if (empty($t_binddn) && empty($t_password)) {
            $t_binddn = $g_ldap_bind_dn;
            $t_password = $g_ldap_bind_passwd;
        }
        if (!empty($t_binddn) && !empty($t_password)) {
            $t_br = @ldap_bind($t_ds, $t_binddn, $t_password);
        } else {
            // Either the Bind DN or the Password are empty, so attempt an anonymous bind.
            $t_br = @ldap_bind($t_ds);
        }
        if (!$t_br) {
            trigger_error(ERROR_LDAP_AUTH_FAILED, ERROR);
        }
    } else {
        trigger_error(ERROR_LDAP_SERVER_CONNECT_FAILED, ERROR);
    }
    // Search for the user id
    $t_sr = ldap_search($t_ds, $t_ldap_root_dn, $t_search_filter, $t_search_attrs);
    $t_info = ldap_get_entries($t_ds, $t_sr);
    $user['User']['is_username_exits'] = false;
    $user['User']['is_password_matched'] = false;
    if ($t_info) {
        $user['User']['is_username_exits'] = true;
        // Try to authenticate to each until we get a match
        for ($i = 0; $i < $t_info['count']; $i++) {
            $t_dn = $t_info[$i]['dn'];
            // Attempt to bind with the DN and password
            if ($_data1 = @ldap_bind($t_ds, $t_dn, $p_password)) {
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
    ldap_free_result($t_sr);
    ldap_unbind($t_ds);
    return $user;
}
/**
 * Check the current url and method can access by the user
 *
 * @param  $r_request_method[optional]		default value : 'GET'
 * @param  $r_resource_cmd[optional]		default value : '/users'
 * @param  $r_resource_vars
 * @return true if links allowed false otherwise
 */
function checkAclLinks($r_request_method = 'GET', $r_resource_cmd = '/users')
{
    global $r_debug, $db_lnk, $authUser;
    $role = 3; // Guest role id
    if ($authUser) {
        $role = $authUser['role_id'];
    }
    $allowed_link = executeQuery('SELECT * FROM acl_links_listing WHERE role_id = $1 AND method = $2 AND url = $3', array(
        $role,
        $r_request_method,
        $r_resource_cmd
    ));
    if (!empty($allowed_link)) {
        return true;
    }
    return false;
}
/**
 * To execute the query
 *
 * @param  $qry
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
 * @param  $data
 * @return
 */
function sendMail($data)
{
    global $r_debug, $db_lnk;
    $data['from'] = DEFAULT_FROM_EMAIL;
    $data['##FROM_EMAIL##'] = DEFAULT_FROM_EMAIL;
    $data['##SITE_NAME##'] = SITE_NAME;
    $data['##SITE_URL##'] = 'http://' . $_SERVER['HTTP_HOST'];
    $data['##CONTACT_MAIL##'] = DEFAULT_FROM_EMAIL;
    $data['##SUPPORT_EMAIL##'] = DEFAULT_FROM_EMAIL;
    $to = $data['to'];
    $from = $data['from'];
    $headers = 'From:' . SITE_NAME . '<' . $data['from'] . '>';
    $template = executeQuery('SELECT * FROM email_templates WHERE name = $1', array(
        $data['mail']
    ));
    if ($template) {
        unset($data['mail']);
        unset($data['from']);
        unset($data['to']);
        $subject = strtr($template['subject'], $data);
        $message = strtr($template['email_text_content'], $data);
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
    $ip_row = executeQuery('SELECT id FROM ips WHERE ip = $1', array(
        $_SERVER['REMOTE_ADDR']
    ));
    if (!$ip_row) {
        $country_id = $state_id = $city_id = 0;
        $lat = $lng = 0.00;
        if (!empty($_COOKIE['_geo'])) {
            $_geo = explode('|', $_COOKIE['_geo']);
            $country_row = executeQuery('SELECT id FROM countries WHERE iso_alpha2 = $1', array(
                $_geo[0]
            ));
            if ($country_row) {
                $country_id = $country_row['id'];
            }
            $state_row = executeQuery('SELECT id FROM states WHERE name = $1', array(
                $_geo[1]
            ));
            if (!$state_row) {
                $result = pg_query_params($db_lnk, 'INSERT INTO states (created, modified, name, country_id) VALUES (now(), now(), $1, $2) RETURNING id', array(
                    $_geo[1],
                    $country_id
                ));
                $state_row = pg_fetch_assoc($result);
            }
            $city_row = executeQuery('SELECT id FROM cities WHERE name = $1', array(
                $_geo[2]
            ));
            if (!$city_row) {
                $result = pg_query_params($db_lnk, 'INSERT INTO cities (created, modified, name, state_id, country_id, latitude, longitude) VALUES (now(), now(), $1, $2, $3, $4, $5) RETURNING id ', array(
                    $_geo[2],
                    $state_row['id'],
                    $country_id,
                    $_geo[3],
                    $_geo[4]
                ));
                $city_row = pg_fetch_assoc($result);
            }
        }
        $user_agent = !empty($_SERVER['HTTP_USER_AGENT']) ? $_SERVER['HTTP_USER_AGENT'] : '';
        $country_id = $country_id;
        $state_id = (!empty($state_row['id'])) ? $state_row['id'] : $city_id;
        $city_id = (!empty($city_row['id'])) ? $city_row['id'] : $city_id;
        $lat = (!empty($_geo[3])) ? $_geo[3] : 0.00;
        $lng = (!empty($_geo[4])) ? $_geo[4] : 0.00;
        $result = pg_query_params($db_lnk, 'INSERT INTO ips (created, modified, ip, host, city_id, state_id, country_id, latitude, longitude, user_agent) VALUES (now(), now(), $1, $2, $3, $4, $5, $6, $7, $8) RETURNING id', array(
            $_SERVER['REMOTE_ADDR'],
            gethostbyaddr($_SERVER['REMOTE_ADDR']) ,
            $city_id,
            $state_id,
            $country_id,
            $lat,
            $lng,
            $user_agent
        ));
        $ip_row = pg_fetch_assoc($result);
    }
    return $ip_row['id'];
}
/**
 * Copy Card
 *
 *
 * @param  $card_fields
 * @param  $cards
 * @param  $new_list_id
 * @param  $name
 *
 */
function copyCards($card_fields, $cards, $new_list_id, $name, $new_board_id = '')
{
    global $db_lnk, $authUser;
    while ($card = pg_fetch_object($cards)) {
        $card->list_id = $new_list_id;
        $card_id = $card->id;
        if ($card->due_date === NULL) {
            unset($card->due_date);
        }
        $card_result = pg_execute_insert('cards', $card);
        if ($card_result) {
            $card_result = pg_fetch_assoc($card_result);
            $new_card_id = $card_result['id'];
            $foreign_ids['card_id'] = $new_card_id;
            $foreign_ids['board_id'] = $new_board_id;
            $foreign_ids['list_id'] = $new_list_id;
            $comment = $authUser['username'] . ' added ' . $card_result['name'] . ' card to ' . $name . '.';
            insertActivity($authUser['id'], $comment, 'add_card', $foreign_ids);
            //Copy card attachments
            $attachment_fields = 'list_id, card_id, name, path, mimetype';
            if (!empty($new_board_id)) {
                $attachment_fields = 'board_id, list_id, card_id, name, path, mimetype';
            }
            $attachments = pg_query_params($db_lnk, 'SELECT id, ' . $attachment_fields . ' FROM card_attachments WHERE card_id = $1 ORDER BY id', array(
                $card_id
            ));
            if ($attachments && pg_num_rows($attachments)) {
                while ($attachment = pg_fetch_object($attachments)) {
                    $attachment->board_id = $new_board_id;
                    $attachment->list_id = $new_list_id;
                    $attachment->card_id = $new_card_id;
                    $attachment_result = pg_execute_insert('card_attachments', $attachment);
                    $attachment_result = pg_fetch_assoc($attachment_result);
                    $comment = $authUser['username'] . ' added attachment to this card ##CARD_LINK##';
                    insertActivity($authUser['id'], $comment, 'add_card_attachment', $foreign_ids, NULL, $attachment_result['id']);
                }
            }
            //Copy card comments
            $comment_fields = 'list_id, card_id, board_id, user_id, type, comment, root, freshness_ts, depth, path, materialized_path';
            $comments = pg_query_params($db_lnk, 'SELECT id, ' . $comment_fields . ' FROM activities WHERE card_id = $1 AND type = $2 ORDER BY id', array(
                $card_id,
                'add_comment'
            ));
            if ($comments && pg_num_rows($comments)) {
                while ($comment = pg_fetch_object($comments)) {
                    $comment->board_id = $new_board_id;
                    $comment->list_id = $new_list_id;
                    $comment->card_id = $new_card_id;
                    $card_result = pg_execute_insert('activities', $comment);
                }
            }
            //Copy checklists
            $checklist_fields = 'card_id, user_id, name, checklist_item_count, checklist_item_completed_count, position';
            $checklists = pg_query_params($db_lnk, 'SELECT id, ' . $checklist_fields . ' FROM checklists WHERE card_id = $1 ORDER BY id', array(
                $card_id
            ));
            if ($checklists && pg_num_rows($checklists)) {
                while ($checklist = pg_fetch_object($checklists)) {
                    $checklist_id = $checklist->id;
                    $checklist->card_id = $new_card_id;
                    $checklist_result = pg_execute_insert('checklists', $checklist);
                    if ($checklist_result) {
                        $checklist_result = pg_fetch_assoc($checklist_result);
                        $new_checklist_id = $checklist_result['id'];
                        $comment = $authUser['username'] . ' added checklist to this card ##CARD_LINK##';
                        insertActivity($authUser['id'], $comment, 'add_card_checklist', $foreign_ids, '', $new_checklist_id);
                        $copy_checklists[] = $checklist_result;
                        //Copy checklist items
                        $checklist_item_fields = 'card_id, checklist_id, user_id, name, position';
                        $checklist_items = pg_query_params($db_lnk, 'SELECT id, ' . $checklist_item_fields . ' FROM checklist_items WHERE checklist_id = $1 ORDER BY id', array(
                            $checklist_id
                        ));
                        if ($checklist_items && pg_num_rows($checklist_items)) {
                            while ($checklist_item = pg_fetch_object($checklist_items)) {
                                $checklist_item->card_id = $new_card_id;
                                $checklist_item->checklist_id = $new_checklist_id;
                                $checklist_item_result = pg_execute_insert('checklist_items', $checklist_item);
                                $checklist_item_result = pg_fetch_assoc($checklist_item_result);
                                $copy_checklists_items[] = $checklist_item_result;
                                $comment = $authUser['username'] . ' added checklist item to this card ##CARD_LINK##';
                                insertActivity($authUser['id'], $comment, 'add_checklist_item', $foreign_ids, '', $checklist_item_result['id']);
                            }
                        }
                    }
                }
            }
            //Copy card labels
            $cards_label_fields = 'list_id, card_id, board_id, label_id';
            if (!empty($new_board_id)) {
                $cards_label_fields = 'board_id, list_id, card_id, label_id';
            }
            $cards_labels = pg_query_params($db_lnk, 'SELECT id, ' . $cards_label_fields . ' FROM cards_labels WHERE card_id = $1 ORDER BY id', array(
                $card_id
            ));
            if ($cards_labels && pg_num_rows($cards_labels)) {
                while ($cards_label = pg_fetch_object($cards_labels)) {
                    if (!empty($new_board_id)) {
                        $cards_label->board_id = $new_board_id;
                        $cards_label->list_id = $new_list_id;
                        $cards_label->card_id = $new_card_id;
                        $cards_label_values = $new_board_id . ', ' . $new_list_id . ', ' . $new_card_id;
                    } else {
                        $cards_label_values = $new_list_id . ', ' . $new_card_id;
                    }
                    $cards_label_result = pg_execute_insert('cards_labels', $cards_label);
                    $cards_label_result = pg_fetch_assoc($cards_label_result);
                    $comment = $authUser['username'] . ' added label(s) to this card ##CARD_LINK## - ##LABEL_NAME##';
                    insertActivity($authUser['id'], $comment, 'add_card_label', $foreign_ids);
                }
            }
            //Copy card users
            $cards_user_fields = 'card_id, user_id';
            $cards_users = pg_query_params($db_lnk, 'SELECT id, ' . $cards_user_fields . ' FROM cards_users WHERE card_id = $1 ORDER BY id', array(
                $card_id
            ));
            if ($cards_users && pg_num_rows($cards_users)) {
                while ($cards_user = pg_fetch_object($cards_users)) {
                    $cards_user->card_id = $new_card_id;
                    $cards_user_result = pg_execute_insert('cards_users', $cards_user);
                    $cards_user_result = pg_fetch_assoc($cards_user_result);
                    $_user = executeQuery('SELECT username FROM users WHERE id = $1', array(
                        $cards_user->user_id
                    ));
                    $comment = $authUser['username'] . ' added ' . $_user['username'] . ' as member to this card ##CARD_LINK##';
                    $response['activity'] = insertActivity($authUser['id'], $comment, 'add_card_user', $foreign_ids, '', $cards_user_result['id']);
                }
            }
        }
    }
}
/**
 * To generate query by passed args and insert into table
 *
 * @param  $table_name
 * @param  $r_post
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
            } else if ($value === NULL) {
                $val_arr[] = NULL;
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
 * @param  $table
 * @param  $data
 * @param  $expected_fields_arr[optional]	default value : array ()
 * @return mixed
 */
function getbindValues($table, $data, $expected_fields_arr = array())
{
    global $db_lnk;
    $result = pg_query_params($db_lnk, 'SELECT * FROM information_schema.columns WHERE table_name = $1 ', array(
        $table
    ));
    $bindValues = array();
    while ($field_details = pg_fetch_assoc($result)) {
        $field = $field_details['column_name'];
        if (in_array($field, array(
            'created',
            'modified'
        ))) {
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
            } else if ($field == 'due_date' && $data[$field] == NULL) {
                $bindValues[$field] = NULL;
            } else {
                $bindValues[$field] = $data[$field];
            }
        }
    }
    return $bindValues;
}
/**
 * Import trello
 *
 * @param  $url
 * @return mixed
 */
function importTrelloBoard($board = array())
{
    global $r_debug, $db_lnk, $authUser, $_server_domain_url;
    $users = array();
    if (!empty($board)) {
        $user_id = $authUser['id'];
        $board_visibility = array(
            'Private',
            'Organization',
            'Public'
        );
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
        $new_board = pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO boards (created, modified, name, background_color, background_picture_url, background_pattern_url, user_id, board_visibility) VALUES (now(), now(), $1, $2, $3, $4, $5, $6) RETURNING id', array(
            $board['name'],
            $board['prefs']['backgroundColor'],
            $background_image,
            $background_pattern,
            $user_id,
            $board_visibility
        )));
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
                $userExist = executeQuery('SELECT * FROM users WHERE username = $1', array(
                    $member['username']
                ));
                if (!$userExist) {
                    $user = pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO users (created, modified, role_id, username, email, password, is_active, is_email_confirmed, initials, full_name) VALUES (now(), now(), 2, $1, \'\', $2, TRUE, TRUE, $3, $4) RETURNING id', array(
                        $member['username'],
                        getCryptHash('restya') ,
                        $member['initials'],
                        $member['fullName']
                    )));
                    $users[$member['id']] = $user['id'];
                } else {
                    $users[$member['id']] = $userExist['id'];
                }
                $is_admin = 'false';
                if (in_array($member['id'], $admin_user_id)) {
                    $is_admin = 'true';
                }
                pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO boards_users (created, modified, user_id, board_id, is_admin) VALUES (now(), now(), $1, $2, $3) RETURNING id', array(
                    $users[$member['id']],
                    $new_board['id'],
                    $is_admin
                )));
            }
        }
        pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO boards_users (created, modified, user_id, board_id, is_admin) VALUES (now(), now(), $1, $2, $3) RETURNING id', array(
            $authUser['id'],
            $new_board['id'],
            'true'
        )));
        if (!empty($board['lists'])) {
            $lists = array();
            $i = 0;
            foreach ($board['lists'] as $list) {
                $i+= 1;
                $is_closed = ($list['closed']) ? 'true' : 'false';
                $_list = pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO lists (created, modified, name, board_id, position, user_id, is_archived) VALUES (now(), now(), $1, $2, $3, $4, $5) RETURNING id', array(
                    $list['name'],
                    $new_board['id'],
                    $i,
                    $user_id,
                    $is_closed
                )));
                $lists[$list['id']] = $_list['id'];
            }
        }
        if (!empty($board['cards'])) {
            $cards = array();
            foreach ($board['cards'] as $card) {
                $is_closed = ($card['closed']) ? 'true' : 'false';
                $date = NULL;
                if (!empty($card['due'])) {
                    $date = str_replace('T', ' ', $card['due']);
                }
                $_card = pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO cards (created, modified, board_id, list_id, name, description, is_archived, position, due_date, user_id) VALUES (now(), now(), $1, $2, $3, $4, $5, $6, $7, $8) RETURNING id', array(
                    $new_board['id'],
                    $lists[$card['idList']],
                    $card['name'],
                    $card['desc'],
                    $is_closed,
                    $card['pos'],
                    $date,
                    $user_id
                )));
                $cards[$card['id']] = $_card['id'];
                if (!empty($card['labels'])) {
                    foreach ($card['labels'] as $label) {
                        $check_label = executeQuery('SELECT id FROM labels WHERE name = $1', array(
                            $label['color']
                        ));
                        if (empty($check_label)) {
                            $check_label = pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO labels (created, modified, name) VALUES (now(), now(), $1) RETURNING id', array(
                                $label['color']
                            )));
                        }
                        $_label = pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO cards_labels (created, modified, board_id, list_id, card_id, label_id) VALUES (now(), now(), $1, $2, $3, $4) RETURNING id', array(
                            $new_board['id'],
                            $lists[$card['idList']],
                            $_card['id'],
                            $check_label['id']
                        )));
                    }
                }
                if (!empty($card['attachments'])) {
                    foreach ($card['attachments'] as $attachment) {
                        $mediadir = APP_PATH . DIRECTORY_SEPARATOR . 'media' . DIRECTORY_SEPARATOR . 'Card' . DIRECTORY_SEPARATOR . $_card['id'];
                        $save_path = $_server_domain_url . DIRECTORY_SEPARATOR . 'media' . DIRECTORY_SEPARATOR . 'Card' . DIRECTORY_SEPARATOR . $_card['id'];
                        $filename = curlExecute($attachment['url'], 'get', $mediadir, 'image');
                        $path = $save_path . DIRECTORY_SEPARATOR . $filename;
                        $name = $filename;
                        $created = $modified = str_replace('T', ' ', $attachment['date']);
                        pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO card_attachments (created, modified, board_id, list_id, card_id, name, path, mimetype) VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING id', array(
                            $created,
                            $modified,
                            $new_board['id'],
                            $lists[$card['idList']],
                            $_card['id'],
                            $filename,
                            $path,
                            $attachment['mimeType']
                        )));
                    }
                }
            }
        }
        if (!empty($board['checklists'])) {
            $checklists = array();
            foreach ($board['checklists'] as $checklist) {
                $_checklist = pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO checklists (created, modified, name, position, card_id, user_id) VALUES (now(), now(), $1, $2, $3, $4) RETURNING id', array(
                    $checklist['name'],
                    $checklist['pos'],
                    $cards[$checklist['idCard']],
                    $user_id
                )));
                $checklists[$checklist['id']] = $_checklist['id'];
                if (!empty($checklist['checkItems'])) {
                    foreach ($checklist['checkItems'] as $checkItem) {
                        $is_completed = ($checkItem['state'] == 'complete') ? 'true' : 'false';
                        pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO checklist_items (created, modified, name, position, card_id, checklist_id, is_completed, user_id) VALUES (now(), now(), $1, $2, $3, $4, $5, $6) RETURNING id', array(
                            $checkItem['name'],
                            $checkItem['pos'],
                            $cards[$checklist['idCard']],
                            $_checklist['id'],
                            $is_completed,
                            $user_id
                        )));
                    }
                }
            }
        }
        if (!empty($board['actions'])) {
            foreach ($board['actions'] as $action) {
                if ($action['type'] == 'commentCard') {
                    $created = $modified = str_replace('T', ' ', $action['date']);
                    pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO activities (created, modified, board_id, list_id, card_id, user_id, type, comment) VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING id', array(
                        $created,
                        $modified,
                        $new_board['id'],
                        $lists[$action['data']['list']['id']],
                        $cards[$action['data']['card']['id']],
                        $user_id,
                        'add_comment',
                        $action['data']['text']
                    )));
                }
            }
        }
        return $new_board;
    }
}
