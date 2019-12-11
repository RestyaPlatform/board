<?php
/**
 * R - Ultra lightweight REST server
 *
 * PHP version 5
 *
 * @category   PHP
 * @package    REST
 * @subpackage Core
 * @author     Restya <info@restya.com>
 * @copyright  2014-2019 Restya
 * @license    http://restya.com/ Restya Licence
 * @link       http://restya.com/
 * @todo       Fix code duplication & make it really lightweight
 * @since      2013-08-23
 */
$r_debug = '';
$authUser = $client = $form = array();
$_server_protocol = (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] != 'off') ? 'https' : 'http';
$request_uri_arr = explode('/api/', $_SERVER['REQUEST_URI'], 2);
$_server_context = $request_uri_arr[0];
$_server_domain_url = $_server_protocol . '://' . $_SERVER['HTTP_HOST'] . $_server_context; // http://localhost/context
header('x-response-url:' . $_SERVER['REQUEST_URI']);
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: *');
require_once '../config.inc.php';
require_once '../libs/vendors/finediff.php';
require_once '../libs/vendors/GoogleAuthenticator.php';
require_once '../libs/core.php';
require_once '../libs/vendors/OAuth2/Autoloader.php';
require_once '../libs/ActivityHandler.php';
$j_username = $j_password = '';
require_once '../bootstrap.php';
global $jabberHost, $jaxlDebug;
if (is_plugin_enabled('r_chat')) {
    require_once PLUGIN_PATH . DS . 'Chat' . DS . 'functions.php';
    require PLUGIN_PATH . DS . 'Chat' . DS . 'libs/vendors/jaxl3/jaxl.php';
    $json = file_get_contents(APP_PATH . DS . 'client' . DS . 'apps' . DS . 'r_chat' . DS . 'app.json');
    $chat_data = json_decode($json, true);
    $chatDBHost = $chat_data['settings']['r_chat_db_host']['value'];
    $chatDBPort = $chat_data['settings']['r_chat_db_port']['value'];
    $chatDBName = $chat_data['settings']['r_chat_db_name']['value'];
    $chatDBUser = $chat_data['settings']['r_chat_db_user']['value'];
    $chatDBPassword = $chat_data['settings']['r_chat_db_password']['value'];
    $jabberHost = $chat_data['settings']['r_chat_jabber_host']['value'];
    $jaxlDebug = $chat_data['settings']['r_chat_jaxl_debug']['value'];
}
/**
 * Common method to handle GET method
 *
 * @param string $r_resource_cmd     URL
 * @param array  $r_resource_vars    Array generated from URL
 * @param array  $r_resource_filters Array generated from URL query string
 *
 * @return mixed
 */
function r_get($r_resource_cmd, $r_resource_vars, $r_resource_filters)
{
    global $r_debug, $db_lnk, $authUser, $_server_domain_url, $jabberHost, $token_exception_url;
    // switch case.. if taking more length, then associative array...
    $query_timeout = 0;
    $sql = false;
    $elastic_search_sql = false;
    $parent_genre_name = '';
    $board_lists = array();
    $sort = 'id';
    $sort_by = 'DESC';
    $field = '*';
    $limit = PAGING_COUNT;
    $response = $revisions = $val_arr = $conditions = $pg_params = array();
    switch ($r_resource_cmd) {
    case '/oauth':
        if (!empty($_GET['refresh_token'])) {
            $oauth_clientid = OAUTH_CLIENTID;
            $oauth_client_secret = OAUTH_CLIENT_SECRET;
            $conditions = array(
                'access_token' => $_GET['refresh_token']
            );
            $response = executeQuery("SELECT user_id as username, expires, scope, client_id FROM oauth_refresh_tokens WHERE refresh_token = $1", $conditions);
            if ($response['client_id'] == 6664115227792148 && OAUTH_CLIENTID == 7742632501382313) {
                $oauth_clientid = '6664115227792148';
                $oauth_client_secret = 'hw3wpe2cfsxxygogwue47cwnf7';
            }
            $post_val = array(
                'grant_type' => 'refresh_token',
                'refresh_token' => $_GET['refresh_token'],
                'client_id' => $oauth_clientid,
                'client_secret' => $oauth_client_secret
            );
            $response = getToken($post_val);
        } else {
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
                $folder = explode(DS, $file);
                $folder_iso2_code = $folder[count($folder) - 2];
                array_push($lang_iso2_codes, $folder_iso2_code);
            }
            $languages = array();
            $qry_val_arr = array(
                '{' . implode($lang_iso2_codes, ',') . '}'
            );
            $result = pg_query_params($db_lnk, 'SELECT name, iso2 FROM languages WHERE iso2 = ANY ( $1 ) ORDER BY name ASC', $qry_val_arr);
            while ($row = pg_fetch_assoc($result)) {
                $languages[$row['iso2']] = $row['name'];
            }
            $response['languages'] = json_encode($languages);
            $files = glob(APP_PATH . DS . 'client' . DS . 'apps' . DS . '*' . DS . 'app.json', GLOB_BRACE);
            if (!empty($files)) {
                foreach ($files as $file) {
                    $content = file_get_contents($file);
                    $data = json_decode($content, true);
                    $folder = explode(DS, $file);
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
        }
        echo json_encode($response);
        break;

    case '/users/me':
        $role_val_arr = array(
            $authUser['role_id']
        );
        $role_links = executeQuery('SELECT * FROM role_links_listing WHERE id = $1', $role_val_arr);
        $val_arr = array(
            $authUser['id']
        );
        $user = executeQuery('SELECT * FROM users_listing WHERE id = $1', $val_arr);
        $response = array_merge($role_links, $response);
        $board_ids = array();
        if (!empty($user['boards_users'])) {
            $boards_users = json_decode($user['boards_users'], true);
            foreach ($boards_users as $boards_user) {
                $board_ids[] = $boards_user['board_id'];
            }
        }
        $notify_val_arr = array(
            $user['last_activity_id'],
            '{' . implode(',', $board_ids) . '}'
        );
        $notify_count = executeQuery('SELECT max(id) AS last_activity_id, count(a.*) AS notify_count FROM activities a  WHERE a.id > $1 AND board_id = ANY ($2) ', $notify_val_arr);
        $notify_count['last_activity_id'] = (!empty($notify_count['last_activity_id'])) ? $notify_count['last_activity_id'] : $user['last_activity_id'];
        $user = array_merge($user, $notify_count);
        unset($user['user']['password']);
        $response['user'] = $user;
        $response['user']['organizations'] = json_decode($user['organizations'], true);
        echo json_encode($response);
        break;

    case '/users':
        $response['users'] = array();
        $order_by = 'id';
        $direction = 'desc';
        $filter_condition = '';
        $_metadata = array();
        if (!empty($r_resource_filters['sort'])) {
            $order_by = $r_resource_filters['sort'];
            $direction = $r_resource_filters['direction'];
        } else if (!empty($r_resource_filters['filter'])) {
            $filter_condition = 'WHERE ';
            if ($r_resource_filters['filter'] == 'active') {
                $filter_condition.= 'is_active = 1';
            } else if ($r_resource_filters['filter'] == 'inactive') {
                $filter_condition.= 'is_active = 0';
            } else if ((is_plugin_enabled('r_ldap_login') || is_plugin_enabled('r_multiple_ldap_login')) && $r_resource_filters['filter'] == 'ldap') {
                $filter_condition.= 'is_ldap = 1';
            } else {
                $filter_condition.= 'role_id = ' . $r_resource_filters['filter'];
            }
        } else if (!empty($r_resource_filters['search'])) {
            $filter_condition = "WHERE LOWER(full_name) LIKE '%" . strtolower($r_resource_filters['search']) . "%' OR LOWER(email) LIKE '%" . strtolower($r_resource_filters['search']) . "%' ";
        }
        $c_sql = 'SELECT COUNT(*) FROM admin_users_listing ul ';
        if (!empty($r_resource_filters['search']) || !empty($r_resource_filters['filter'])) {
            $c_sql = 'SELECT COUNT(*) FROM admin_users_listing ul ' . $filter_condition;
        }
        if (!empty($c_sql)) {
            $paging_data = paginate_data($c_sql, $db_lnk, $pg_params, $r_resource_filters);
            $_metadata = $paging_data['_metadata'];
        }
        $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM admin_users_listing ul ' . $filter_condition . ' ORDER BY ' . $order_by . ' ' . $direction . ' limit ' . $_metadata['limit'] . ' offset ' . $_metadata['offset'] . ') as d ';
        $filter_count = array();
        $val_array = array(
            true
        );
        $active_count = executeQuery('SELECT count(*) FROM users WHERE is_active = $1', $val_array);
        $filter_count['active'] = $active_count['count'];
        $val_array = array(
            0
        );
        $inactive_count = executeQuery('SELECT count(*) FROM users WHERE is_active = $1', $val_array);
        $filter_count['inactive'] = $inactive_count['count'];
        $val_array = array(
            true
        );
        if (is_plugin_enabled('r_ldap_login') || is_plugin_enabled('r_multiple_ldap_login')) {
            $ldap_count = executeQuery('SELECT count(*) FROM users WHERE is_ldap = $1', $val_array);
            $filter_count['ldap'] = $ldap_count['count'];
        }
        $val_array = array(
            3
        );
        $s_result = pg_query_params($db_lnk, 'SELECT * FROM roles WHERE id != $1', $val_array);
        $roles = array();
        $i = 0;
        while ($row = pg_fetch_assoc($s_result)) {
            $roles[$i]['id'] = $row['id'];
            $roles[$i]['name'] = ucfirst($row['name']);
            $val_array = array(
                $row['id']
            );
            $user_count = executeQuery('SELECT count(*) FROM users WHERE role_id = $1', $val_array);
            $roles[$i]['count'] = $user_count['count'];
            $i++;
        }
        if (!empty($sql)) {
            if ($result = pg_query_params($db_lnk, $sql, $pg_params)) {
                $data = array();
                $board_lists = array();
                while ($row = pg_fetch_row($result)) {
                    $obj = json_decode($row[0], true);
                    if (is_plugin_enabled('r_groups')) {
                        $group_sql = 'SELECT row_to_json(d) FROM (SELECT * FROM groups_users Where user_id = $1 ORDER BY id DESC) as d ';
                        $obj['groups'] = null;
                        if ($group_result = pg_query_params($db_lnk, $group_sql, array(
                            $obj['id']
                        ))) {
                            while ($group = pg_fetch_row($group_result)) {
                                $group = json_decode($group[0], true);
                                $obj['groups'][] = $group;
                            }
                        }
                    }
                    $data['data'][] = $obj;
                }
                if (!empty($_metadata) && !empty($filter_count)) {
                    $data['filter_count'] = $filter_count;
                }
                if (!empty($roles)) {
                    $data['roles'] = $roles;
                }
                if (!empty($_metadata)) {
                    $data['_metadata'] = $_metadata;
                }
                echo json_encode($data);
            } else {
                $r_debug.= __LINE__ . ': ' . pg_last_error($db_lnk) . '\n';
            }
        } else {
            echo json_encode($response);
        }
        break;

    case '/user_logins':
        $response['users'] = array();
        $order_by = 'id';
        $direction = 'desc';
        $filter_condition = '';
        $_metadata = array();
        if (!empty($r_resource_filters['sort'])) {
            $order_by = $r_resource_filters['sort'];
            $direction = $r_resource_filters['direction'];
        } else if (!empty($r_resource_filters['search'])) {
            $filter_condition = "WHERE LOWER(full_name) LIKE '%" . strtolower($r_resource_filters['search']) . "%' OR LOWER(email) LIKE '%" . strtolower($r_resource_filters['search']) . "%' ";
        }
        $c_sql = 'SELECT COUNT(*) FROM user_logins_listing ul ';
        if (!empty($r_resource_filters['search'])) {
            $c_sql = 'SELECT COUNT(*) FROM user_logins_listing ul ' . $filter_condition;
        }
        if (!empty($c_sql)) {
            $paging_data = paginate_data($c_sql, $db_lnk, $pg_params, $r_resource_filters);
            $_metadata = $paging_data['_metadata'];
        }
        $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM user_logins_listing ul ' . $filter_condition . ' ORDER BY ' . $order_by . ' ' . $direction . ' limit ' . $_metadata['limit'] . ' offset ' . $_metadata['offset'] . ') as d ';
        if (!empty($sql)) {
            if ($result = pg_query_params($db_lnk, $sql, $pg_params)) {
                $data = array();
                $board_lists = array();
                while ($row = pg_fetch_row($result)) {
                    $obj = json_decode($row[0], true);
                    $data['data'][] = $obj;
                }
                if (!empty($_metadata)) {
                    $data['_metadata'] = $_metadata;
                }
                echo json_encode($data);
            } else {
                $r_debug.= __LINE__ . ': ' . pg_last_error($db_lnk) . '\n';
            }
        } else {
            echo json_encode($response);
        }
        break;

    case '/users/logout':
        $response['user'] = array();
        if (!empty($_GET['token'])) {
            $conditions = array(
                $_GET['token']
            );
            pg_query_params($db_lnk, 'DELETE FROM oauth_access_tokens WHERE access_token= $1', $conditions);
        }
        $authUser = array();
        echo json_encode($response);
        break;

    case '/users/?/activities':
        $condition = '';
        $flag = 0;
        if (!empty($authUser) && $authUser['role_id'] == 1 && $authUser['id'] == $r_resource_vars['users'] && empty($r_resource_filters['organization_id']) && empty($r_resource_filters['board_id'])) {
            $i = 1;
            if (!empty($r_resource_filters['mode']) && $r_resource_filters['mode'] != 'all') {
                if ($r_resource_filters['mode'] == 'activity') {
                    $condition.= ' WHERE (al.type != $' . $i;
                    array_push($pg_params, 'add_comment');
                    $i++;
                    $condition.= ' and al.type != $' . $i . ')';
                    array_push($pg_params, 'edit_comment');
                    $i++;
                } else if ($r_resource_filters['mode'] == 'comment') {
                    $condition.= ' WHERE al.type = $' . $i;
                    array_push($pg_params, 'add_comment');
                    $i++;
                }
                $condition.= (!empty($r_resource_filters['last_activity_id'])) ? ' AND ' : '';
            } else {
                $condition.= (!empty($r_resource_filters['last_activity_id'])) ? ' WHERE ' : '';
            }
            if (!empty($r_resource_filters['type']) && $r_resource_filters['type'] == 'profile') {
                $condition.= (!empty($r_resource_filters['last_activity_id'])) ? 'al.id < $' . $i : '';
                $i++;
            } else {
                $condition.= (!empty($r_resource_filters['last_activity_id'])) ? 'al.id > $' . $i : '';
                $i++;
            }
            $direction = 'DESC';
            if (!empty($r_resource_filters['direction']) && isset($r_resource_filters['direction'])) {
                $direction = $r_resource_filters['direction'];
            }
            $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM activities_listing al ' . $condition . ' ORDER BY id ' . $direction . ' LIMIT ' . PAGING_COUNT . ') as d';
            $c_sql = 'SELECT COUNT(*) FROM activities_listing al' . $condition;
        } else {
            if (isset($r_resource_filters['last_activity_id']) && !empty($r_resource_filters['last_activity_id'])) {
                $val_array = array(
                    $r_resource_filters['last_activity_id'],
                    'delete_board_user'
                );
                $responsedata = executeQuery('SELECT * FROM activities_listing WHERE id > $1 AND type = $2', $val_array);
                if (isset($responsedata['board_id'])) {
                    $val_array = array(
                        $responsedata['board_id'],
                        $authUser['id']
                    );
                    $boardUser = executeQuery('SELECT * FROM boards_users WHERE board_id = $1 AND user_id = $2', $val_array);
                    if (!isset($boardUser['id'])) {
                        $flag = 1;
                    }
                }
            }
            if (!empty($authUser) && $authUser['id'] != $r_resource_vars['users'] && $authUser['role_id'] != 1) {
                $val_array = array(
                    $authUser['id']
                );
                $logged_user = executeQuery('SELECT boards_users FROM users_listing WHERE id = $1', $val_array);
                $logged_user_board_ids = array();
                if (!empty($logged_user['boards_users'])) {
                    $logged_boards_users = json_decode($logged_user['boards_users'], true);
                    foreach ($logged_boards_users as $logged_boards_user) {
                        $logged_user_board_ids[] = $logged_boards_user['board_id'];
                    }
                }
            }
            $val_array = array(
                $r_resource_vars['users']
            );
            $user = executeQuery('SELECT boards_users FROM users_listing WHERE id = $1', $val_array);
            $board_ids = array();
            if (!empty($user['boards_users'])) {
                $boards_users = json_decode($user['boards_users'], true);
                foreach ($boards_users as $boards_user) {
                    $board_ids[] = $boards_user['board_id'];
                }
            }
            if (!empty($logged_user_board_ids)) {
                $board_ids = array_intersect($logged_user_board_ids, $board_ids);
            }
            $org_users = pg_query_params($db_lnk, 'SELECT organization_id FROM organizations_users WHERE user_id = $1', $val_array);
            $org_ids = array();
            while ($row = pg_fetch_assoc($org_users)) {
                $org_ids[] = $row['organization_id'];
            }
            if (!empty($r_resource_filters['organization_id'])) {
                if (!empty($r_resource_filters['last_activity_id'])) {
                    $condition = ' AND al.id < $4';
                }
                $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM activities_listing al WHERE (user_id = $1 AND (board_id IN (SELECT id FROM boards WHERE organization_id = $2) OR organization_id  = ANY ( $3 ))) ' . $condition . ' ORDER BY id DESC LIMIT ' . PAGING_COUNT . ') as d';
                $c_sql = 'SELECT COUNT(*) FROM activities_listing al WHERE ((user_id = $1 AND board_id IN (SELECT id FROM boards WHERE organization_id = $2)) OR organization_id  = ANY ( $3 )) ' . $condition;
                array_push($pg_params, $r_resource_vars['users'], $r_resource_filters['organization_id'], '{' . $r_resource_filters['organization_id'] . '}');
            } else if (!empty($r_resource_filters['type']) && $r_resource_filters['type'] == 'profile') {
                $i = 1;
                $str = 'user_id = $' . $i;
                array_push($pg_params, $r_resource_vars['users']);
                $i++;
                if (!empty($logged_user_board_ids)) {
                    $str.= ' AND board_id = ANY ( $' . $i . ' )';
                    array_push($pg_params, '{' . implode(',', $board_ids) . '}');
                    $i++;
                }
                if (!empty($r_resource_filters['last_activity_id'])) {
                    $str.= ' AND al.id < $' . $i;
                }
                $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM activities_listing al WHERE ' . $str . $condition . ' ORDER BY id DESC LIMIT ' . PAGING_COUNT . ') as d';
                $c_sql = 'SELECT COUNT(*) FROM activities_listing al WHERE ' . $str;
            } else if (!empty($r_resource_filters['type']) && $r_resource_filters['type'] == 'all') {
                if (!empty($r_resource_filters['last_activity_id'])) {
                    $condition = ' AND al.id > $3';
                }
                $direction = 'DESC';
                if (!empty($r_resource_filters['direction']) && isset($r_resource_filters['direction'])) {
                    $direction = $r_resource_filters['direction'];
                }
                $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM activities_listing al WHERE (board_id = ANY ( $1 ) OR organization_id  = ANY ( $2 ))' . $condition . ' ORDER BY id ' . $direction . ' LIMIT ' . PAGING_COUNT . ') as d';
                $c_sql = 'SELECT COUNT(*) FROM activities_listing al WHERE (board_id = ANY ( $1 ) OR organization_id  = ANY ( $2 ))' . $condition;
                array_push($pg_params, '{' . implode(',', $board_ids) . '}', '{' . implode(',', $org_ids) . '}');
            } else if (!empty($r_resource_filters['board_id']) && $r_resource_filters['board_id'] && $r_resource_filters['type'] == 'board_user_activity') {
                if (!empty($r_resource_filters['last_activity_id'])) {
                    $condition = ' AND al.id < $3';
                }
                $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM activities_listing al WHERE user_id = $1 AND board_id = $2' . $condition . ' ORDER BY id DESC LIMIT ' . PAGING_COUNT . ') as d';
                $c_sql = 'SELECT COUNT(*) FROM activities_listing al WHERE user_id = $1 AND board_id = $2' . $condition;
                array_push($pg_params, $r_resource_vars['users'], $r_resource_filters['board_id']);
            } else if (!empty($r_resource_filters['board_id']) && $r_resource_filters['board_id']) {
                if (!empty($r_resource_filters['last_activity_id'])) {
                    $condition = ' AND al.id > $3';
                }
                $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM activities_listing al WHERE user_id = $1 AND board_id = $2' . $condition . ' ORDER BY freshness_ts DESC, materialized_path ASC LIMIT ' . PAGING_COUNT . ') as d';
                $c_sql = 'SELECT COUNT(*) FROM activities_listing al WHERE user_id = $1 AND board_id = $2' . $condition;
                array_push($pg_params, $r_resource_vars['users'], $r_resource_filters['board_id']);
            } else {
                if (!empty($r_resource_filters['last_activity_id'])) {
                    $condition = ' AND al.id > $3';
                }
                $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM activities_listing al WHERE ( board_id = ANY( $1 ) OR organization_id  = ANY ( $2 ) )' . $condition . ' ORDER BY id DESC LIMIT ' . PAGING_COUNT . ') as d';
                $c_sql = 'SELECT COUNT(*) FROM activities_listing al WHERE ( board_id = ANY( $1 ) OR organization_id  = ANY ( $2 ) )' . $condition;
                array_push($pg_params, '{' . implode(',', $board_ids) . '}', '{' . implode(',', $org_ids) . '}');
            }
            if ($flag == 1) {
                unset($pg_params);
                $pg_params[0] = $r_resource_filters['last_activity_id'];
                $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM activities_listing al WHERE id > $1 ORDER BY id DESC LIMIT ' . PAGING_COUNT . ') as d';
                $c_sql = "";
            }
        }
        if (!empty($r_resource_filters['last_activity_id']) && $flag == 0) {
            array_push($pg_params, $r_resource_filters['last_activity_id']);
        }
        if (!empty($c_sql)) {
            $paging_data = paginate_data($c_sql, $db_lnk, $pg_params, $r_resource_filters);
            //  $sql.= $paging_data['sql'];
            $_metadata = $paging_data['_metadata'];
        }
        if (!empty($sql)) {
            if ($result = pg_query_params($db_lnk, $sql, $pg_params)) {
                $data = array();
                $board_lists = array();
                while ($row = pg_fetch_row($result)) {
                    $obj = json_decode($row[0], true);
                    if (isset($obj['board_activities']) && !empty($obj['board_activities'])) {
                        $board_activities_count = count($obj['board_activities']);
                        for ($k = 0; $k < $board_activities_count; $k++) {
                            if (!empty($obj['board_activities'][$k]['revisions']) && trim($obj['board_activities'][$k]['revisions']) != '') {
                                $revisions = unserialize($obj['board_activities'][$k]['revisions']);
                                $diff = array();
                                if (!empty($revisions['new_value'])) {
                                    foreach ($revisions['new_value'] as $key => $value) {
                                        if ($key != 'is_archived' && $key != 'is_deleted' && $key != 'created' && $key != 'modified' && $obj['type'] != 'moved_card_checklist_item' && $obj['type'] != 'add_card_desc' && $obj['type'] != 'add_card_duedate' && $obj['type'] != 'delete_card_duedate' && $obj['type'] != 'change_visibility' && $obj['type'] != 'add_background' && $obj['type'] != 'change_background') {
                                            $old_val = ($revisions['old_value'][$key] != null && $revisions['old_value'][$key] != 'null') ? $revisions['old_value'][$key] : '';
                                            $new_val = ($revisions['new_value'][$key] != null && $revisions['new_value'][$key] != 'null') ? $revisions['new_value'][$key] : '';
                                            $diff[] = nl2br(getRevisiondifference($old_val, $new_val));
                                        }
                                        if ($obj['type'] == 'add_card_desc' || $obj['type'] == 'add_card_desc' || $obj['type'] == '	edit_card_duedate' || $obj['type'] == 'change_visibility' || $obj['type'] == 'add_background' || $obj['type'] == 'change_background') {
                                            $diff[] = $revisions['new_value'][$key];
                                        }
                                    }
                                    if (isset($diff)) {
                                        $obj['board_activities'][$k]['difference'] = $diff;
                                    }
                                } else if (!empty($revisions['old_value']) && isset($obj['type']) && $obj['type'] == 'delete_card_comment') {
                                    $obj['board_activities'][$k]['difference'] = nl2br(getRevisiondifference($revisions['old_value'], ''));
                                }
                            }
                        }
                    }
                    $obj = ActivityHandler::getActivitiesObj($obj);
                    if (!empty($_metadata)) {
                        $data['data'][] = $obj;
                    } else {
                        $data[] = $obj;
                    }
                }
                if (!empty($_metadata)) {
                    $data['_metadata'] = $_metadata;
                }
                echo json_encode($data);
            } else {
                $r_debug.= __LINE__ . ': ' . pg_last_error($db_lnk) . '\n';
            }
        }
        break;

    case '/users/search':
        if (!empty($r_resource_filters['organizations'])) {
            $sql = 'SELECT row_to_json(d) FROM (SELECT u.id, u.username, u.profile_picture_path,u.initials, u.full_name FROM users u LEFT JOIN organizations_users ou ON ou.user_id = u.id WHERE u.is_active = true AND u.is_email_confirmed = true AND ';
            $sql.= '(ou.organization_id != $1 OR ou.user_id IS null) AND';
            array_push($pg_params, $r_resource_filters['organizations']);
        } else if (!empty($r_resource_filters['board_id'])) {
            $sql = 'SELECT row_to_json(d) FROM (SELECT u.id, u.username, u.profile_picture_path,u.initials, u.full_name FROM users u JOIN boards_users bu ON bu.user_id = u.id WHERE u.is_active = true AND u.is_email_confirmed = true AND ';
            $sql.= 'bu.board_id = $1 AND';
            array_push($pg_params, $r_resource_filters['board_id']);
        } else if (!empty($r_resource_filters['filter'])) {
            $sql = 'SELECT row_to_json(d) FROM (SELECT u.id, u.username, u.profile_picture_path,u.initials, u.full_name FROM users u WHERE ';
        } else {
            $sql = 'SELECT row_to_json(d) FROM (SELECT u.id, u.username, u.profile_picture_path,u.initials, u.full_name FROM users u WHERE  u.is_active = true AND u.is_email_confirmed = true AND ';
        }
        if (empty($pg_params)) {
            $sql.= '(LOWER(u.username) LIKE LOWER($1) OR LOWER(u.email) LIKE LOWER($2))) as d ';
        } else {
            $sql.= '(LOWER(u.username) LIKE LOWER($2) OR LOWER(u.email) LIKE LOWER($3))) as d ';
        }
        array_push($pg_params, '%' . $r_resource_filters['q'] . '%', '%' . $r_resource_filters['q'] . '%');
        if (empty($r_resource_filters['q'])) {
            $sql = false;
            $response = array();
            $pg_params = array();
        }
        if (!empty($sql)) {
            if ($result = pg_query_params($db_lnk, $sql, $pg_params)) {
                $data = array();
                while ($row = pg_fetch_row($result)) {
                    $obj = json_decode($row[0], true);
                    $data[] = $obj;
                }
                echo json_encode($data);
            } else {
                $r_debug.= __LINE__ . ': ' . pg_last_error($db_lnk) . '\n';
            }
        } else {
            echo json_encode($response);
        }
        break;

    case '/users/?':
        $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM users ul WHERE id = $1 ) as d ';
        array_push($pg_params, $r_resource_vars['users']);
        if (!empty($sql)) {
            if ($result = pg_query_params($db_lnk, $sql, $pg_params)) {
                $data = array();
                while ($row = pg_fetch_row($result)) {
                    $obj = json_decode($row[0], true);
                    if (IS_TWO_FACTOR_AUTHENTICATION_ENABLED) {
                        $ga = new PHPGangsta_GoogleAuthenticator();
                        if (empty($obj['two_factor_authentication_hash'])) {
                            $obj['two_factor_authentication_hash'] = $ga->createSecret();
                            $data = array(
                                $obj['two_factor_authentication_hash'],
                                $obj['id']
                            );
                            pg_query_params($db_lnk, 'UPDATE users SET two_factor_authentication_hash = $1 WHERE id = $2', $data);
                        }
                        $obj['qr_code_url'] = $ga->getQRCodeGoogleUrl($obj['full_name'] . ' (' . $obj['email'] . ')', $obj['two_factor_authentication_hash']);
                    }
                    $data = $obj;
                }
                if ($data['id'] != $authUser['id'] && $authUser['role_id'] != 1) {
                    $jsonArr = array(
                        'id' => $data['id'],
                        'role_id' => $data['role_id'],
                        'username' => $data['username'],
                        'full_name' => $data['full_name'],
                    );
                    echo json_encode($jsonArr);
                } else {
                    $s_result = pg_query_params($db_lnk, 'SELECT * FROM timezones order by utc_offset::int', array());
                    $data['timezones'] = array();
                    while ($row = pg_fetch_assoc($s_result)) {
                        $data['timezones'][] = $row;
                    }
                    echo json_encode($data);
                }
            } else {
                $r_debug.= __LINE__ . ': ' . pg_last_error($db_lnk) . '\n';
            }
        }
        break;

    case '/users/?/boards':
        if (!empty($authUser['id'])) {
            $val_array = array(
                $authUser['id']
            );
            $s_result = pg_query_params($db_lnk, 'SELECT board_id FROM board_stars WHERE is_starred = true AND user_id = $1', $val_array);
            $response['starred_boards'] = array();
            while ($row = pg_fetch_assoc($s_result)) {
                $response['starred_boards'][] = $row['board_id'];
            }
            $val_array = array(
                $authUser['id']
            );
            $s_result = pg_query_params($db_lnk, 'SELECT o.id as organization_id, o.name as organization_name, bu.board_id FROM boards_users  bu LEFT JOIN boards b ON b.id = bu.board_id LEFT JOIN organizations o ON o.id = b.organization_id  WHERE bu.user_id = $1', $val_array);
            $response['user_boards'] = array();
            while ($row = pg_fetch_assoc($s_result)) {
                $response['user_boards'][] = $row;
            }
            echo json_encode($response);
        }
        break;

    case '/users/?/cards':
        $logged_user_board_ids = array();
        if (!empty($authUser) && $authUser['id'] != $r_resource_vars['users']) {
            $val_array = array(
                $authUser['id']
            );
            $logged_user = executeQuery('SELECT boards_users FROM users_listing WHERE id = $1', $val_array);
            if (!empty($logged_user['boards_users'])) {
                $logged_boards_users = json_decode($logged_user['boards_users'], true);
                foreach ($logged_boards_users as $logged_boards_user) {
                    $logged_user_board_ids[] = $logged_boards_user['board_id'];
                }
            }
        }
        $str = '';
        $i = 1;
        if (!empty($logged_user_board_ids)) {
            $str.= 'board_id = ANY ( $' . $i . ' ) AND';
            $i++;
            array_push($pg_params, '{' . implode(',', $logged_user_board_ids) . '}');
        }
        if (empty($r_resource_filters['type'])) {
            $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM users_cards_listing ucl WHERE ' . $str . ' user_id = ANY ( $' . $i . ' ) ORDER BY board_name ASC) as d';
        } else {
            $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM created_cards_listing ucl WHERE ' . $str . ' created_user_id = ANY ( $' . $i . ' ) ORDER BY board_name ASC) as d';
        }
        if (!empty($r_resource_filters['user_ids'])) {
            array_push($pg_params, '{' . $r_resource_vars['users'] . ',' . $r_resource_filters['user_ids'] . '}');
        } else {
            array_push($pg_params, '{' . $r_resource_vars['users'] . '}');
        }
        if (!empty($sql)) {
            if ($result = pg_query_params($db_lnk, $sql, $pg_params)) {
                $data = array();
                while ($row = pg_fetch_row($result)) {
                    $obj = json_decode($row[0], true);
                    $data[] = $obj;
                }
                echo json_encode($data);
            } else {
                $r_debug.= __LINE__ . ': ' . pg_last_error($db_lnk) . '\n';
            }
        }
        break;

    case '/boards/list':
        if (!empty($r_resource_filters['type']) && $r_resource_filters['type'] == 'simple') {
            $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM simple_board_listing ul ';
            if (!empty($authUser) && $authUser['role_id'] != 1) {
                $val_array = array(
                    $authUser['id']
                );
                $s_result = pg_query_params($db_lnk, 'SELECT board_id FROM board_stars WHERE user_id = $1', $val_array);
                $response['starred_boards'] = array();
                while ($row = pg_fetch_assoc($s_result)) {
                    $response['starred_boards'][] = $row['board_id'];
                }
                $s_result = pg_query_params($db_lnk, 'SELECT board_id FROM boards_users WHERE user_id = $1', $val_array);
                $response['user_boards'] = array();
                while ($row = pg_fetch_assoc($s_result)) {
                    $response['user_boards'][] = $row['board_id'];
                }
                $board_ids = array_merge($response['starred_boards'], $response['user_boards']);
                $ids = 0;
                if (!empty($board_ids)) {
                    $board_ids = array_unique($board_ids);
                    $ids = '{' . implode($board_ids, ',') . '}';
                }
                $sql.= 'WHERE ul.id =ANY($1)';
                array_push($pg_params, $ids);
            }
            $sql.= ' ORDER BY name ASC) as d';
            if ($authUser['role_id'] != 1 && empty($board_ids)) {
                $sql = false;
            }
        } else {
            $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM boards_listing ul ';
            if (!empty($authUser) && $authUser['role_id'] != 1) {
                $val_array = array(
                    $authUser['id']
                );
                $s_result = pg_query_params($db_lnk, 'SELECT board_id FROM board_subscribers WHERE user_id = $1', $val_array);
                $response['starred_boards'] = array();
                while ($row = pg_fetch_assoc($s_result)) {
                    $response['starred_boards'][] = $row['board_id'];
                }
                $s_result = pg_query_params($db_lnk, 'SELECT board_id FROM boards_users WHERE user_id = $1', $val_array);
                $response['user_boards'] = array();
                while ($row = pg_fetch_assoc($s_result)) {
                    $response['user_boards'][] = $row['board_id'];
                }
                $board_ids = array_merge($response['starred_boards'], $response['user_boards']);
                $ids = 0;
                if (!empty($board_ids)) {
                    $board_ids = array_unique($board_ids);
                    $ids = '{' . implode($board_ids, ',') . '}';
                }
                $sql.= 'WHERE ul.id = ANY ($1)';
                array_push($pg_params, $ids);
            }
            $sql.= ' ORDER BY name ASC ) as d';
            if ($authUser['role_id'] != 1 && empty($board_ids)) {
                $sql = false;
            }
        }
        $c_sql = 'SELECT COUNT(*) FROM boards_listing bl';
        if (!empty($c_sql)) {
            $paging_data = paginate_data($c_sql, $db_lnk, $pg_params, $r_resource_filters);
            $sql.= $paging_data['sql'];
            $_metadata = $paging_data['_metadata'];
        }
        if (!empty($sql)) {
            if ($result = pg_query_params($db_lnk, $sql, $pg_params)) {
                $data = array();
                $board_lists = array();
                while ($row = pg_fetch_row($result)) {
                    $obj = json_decode($row[0], true);
                    $obj = ActivityHandler::getActivitiesObj($obj);
                    if (!empty($_metadata)) {
                        $data['data'][] = $obj;
                    } else {
                        $data[] = $obj;
                    }
                }
                if (!empty($_metadata)) {
                    $data['_metadata'] = $_metadata;
                }
                echo json_encode($data);
            } else {
                $r_debug.= __LINE__ . ': ' . pg_last_error($db_lnk) . '\n';
            }
        }
        break;

    case '/boards':
        $filter_condition = '';
        if (!empty($r_resource_filters['type']) && $r_resource_filters['type'] == 'simple') {
            $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM simple_board_listing ul ';
            if (!empty($authUser) && $authUser['role_id'] != 1) {
                $val_array = array(
                    $authUser['id']
                );
                $s_result = pg_query_params($db_lnk, 'SELECT board_id FROM board_stars WHERE user_id = $1', $val_array);
                $response['starred_boards'] = array();
                while ($row = pg_fetch_assoc($s_result)) {
                    $response['starred_boards'][] = $row['board_id'];
                }
                $s_result = pg_query_params($db_lnk, 'SELECT board_id FROM boards_users WHERE user_id = $1', $val_array);
                $response['user_boards'] = array();
                while ($row = pg_fetch_assoc($s_result)) {
                    $response['user_boards'][] = $row['board_id'];
                }
                $board_ids = array_merge($response['starred_boards'], $response['user_boards']);
                $ids = '{0}';
                if (!empty($board_ids)) {
                    $board_ids = array_unique($board_ids);
                    $ids = '{' . implode($board_ids, ',') . '}';
                }
                $sql.= 'WHERE ul.id =ANY($1)';
                array_push($pg_params, $ids);
            }
            $sql.= ' ORDER BY name ASC) as d ';
            if ($authUser['role_id'] != 1 && empty($board_ids)) {
                $sql = false;
            }
            $limit = 'all';
            if (!empty($pg_params)) {
                $c_sql = 'SELECT COUNT(*) FROM simple_board_listing ul WHERE ul.id =ANY($1)' . $filter_condition;
            } else {
                $c_sql = 'SELECT COUNT(*) FROM simple_board_listing ul ' . $filter_condition;
            }
        } else if (!empty($r_resource_filters['page'])) {
            $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM admin_boards_listing ul ';
            $order_by = 'name';
            $direction = 'asc';
            if (!empty($r_resource_filters['sort'])) {
                $order_by = $r_resource_filters['sort'];
                $direction = $r_resource_filters['direction'];
            }
            if (!empty($r_resource_filters['filter'])) {
                $filter_condition = 'WHERE ';
                if ($r_resource_filters['filter'] == 'open') {
                    $filter_condition.= 'is_closed = 0';
                } else if ($r_resource_filters['filter'] == 'closed') {
                    $filter_condition.= 'is_closed = 1';
                } else if ($r_resource_filters['filter'] == 'private') {
                    $filter_condition.= 'board_visibility = 0';
                } else if ($r_resource_filters['filter'] == 'public') {
                    $filter_condition.= 'board_visibility = 2';
                } else if ($r_resource_filters['filter'] == 'organization') {
                    $filter_condition.= 'board_visibility = 1';
                }
                $sql.= $filter_condition;
            } else if (!empty($r_resource_filters['search'])) {
                $filter_condition = "WHERE LOWER(name) LIKE '%" . strtolower($r_resource_filters['search']) . "%' ";
                $sql.= $filter_condition;
            }
            $sql.= ' ORDER BY ' . $order_by . ' ' . $direction . ') as d ';
        } else {
            $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM boards_listing ul ';
            if (!empty($authUser) && $authUser['role_id'] != 1) {
                $val_array = array(
                    $authUser['id']
                );
                $s_result = pg_query_params($db_lnk, 'SELECT board_id FROM board_subscribers WHERE user_id = $1', $val_array);
                $response['starred_boards'] = array();
                while ($row = pg_fetch_assoc($s_result)) {
                    $response['starred_boards'][] = $row['board_id'];
                }
                $s_result = pg_query_params($db_lnk, 'SELECT board_id FROM boards_users WHERE user_id = $1', $val_array);
                $response['user_boards'] = array();
                while ($row = pg_fetch_assoc($s_result)) {
                    $response['user_boards'][] = $row['board_id'];
                }
                $board_ids = array_merge($response['starred_boards'], $response['user_boards']);
                $ids = '{0}';
                if (!empty($board_ids)) {
                    $board_ids = array_unique($board_ids);
                    $ids = '{' . implode($board_ids, ',') . '}';
                }
                $sql.= 'WHERE ul.id = ANY ($1)';
                array_push($pg_params, $ids);
            }
            $sql.= ' ORDER BY name ASC) as d ';
            if ($authUser['role_id'] != 1 && empty($board_ids)) {
                $sql = false;
            }
        }
        if (isset($r_resource_filters['page'])) {
            $c_sql = 'SELECT COUNT(*) FROM boards_listing bl ' . $filter_condition;
        }
        $filter_count = array();
        $val_array = array(
            true
        );
        $closed_count = executeQuery('SELECT count(*) FROM boards WHERE is_closed = $1', $val_array);
        $filter_count['closed'] = $closed_count['count'];
        $val_array = array(
            0
        );
        $open_count = executeQuery('SELECT count(*) FROM boards WHERE is_closed = $1', $val_array);
        $filter_count['open'] = $open_count['count'];
        $val_array = array(
            0
        );
        $private_count = executeQuery('SELECT count(*) FROM boards WHERE board_visibility = $1', $val_array);
        $filter_count['private'] = $private_count['count'];
        $val_array = array(
            2
        );
        $public_count = executeQuery('SELECT count(*) FROM boards WHERE board_visibility = $1', $val_array);
        $filter_count['public'] = $public_count['count'];
        $val_array = array(
            1
        );
        $organization_count = executeQuery('SELECT count(*) FROM boards WHERE board_visibility = $1', $val_array);
        $filter_count['organization'] = $organization_count['count'];
        $board_user_roles_result = pg_query_params($db_lnk, 'SELECT id, name FROM board_user_roles', array());
        $board_user_roles = array();
        while ($board_user = pg_fetch_assoc($board_user_roles_result)) {
            $board_user_roles[] = $board_user;
        }
        if (!empty($c_sql)) {
            $paging_data = paginate_data($c_sql, $db_lnk, $pg_params, $r_resource_filters);
            $_metadata = $paging_data['_metadata'];
        }
        if (!empty($c_sql) && !empty($r_resource_filters['page'])) {
            $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM admin_boards_listing ul ' . $filter_condition . ' ORDER BY ' . $order_by . ' ' . $direction . ' limit ' . $_metadata['limit'] . ' offset ' . $_metadata['offset'] . ') as d ';
        }
        if (!empty($sql)) {
            if ($result = pg_query_params($db_lnk, $sql, $pg_params)) {
                $data = array();
                $board_lists = array();
                while ($row = pg_fetch_row($result)) {
                    $obj = json_decode($row[0], true);
                    if ((!empty($r_resource_filters['type']) && $r_resource_filters['type'] == 'simple')) {
                        if (!empty($obj['lists'])) {
                            foreach ($obj['lists'] as $list) {
                                $board_lists[$list['id']] = $list;
                            }
                        }
                    }
                    if (!empty($obj['organization_id']) && $obj['organization_id'] !== 0) {
                        $obj['organization_users'] = array();
                        $organization_user_sql = 'SELECT id, organization_id, user_id  FROM organizations_users WHERE organization_id = ' . $obj['organization_id'] . 'ORDER BY id ASC';
                        $organization_user_result = pg_query_params($db_lnk, $organization_user_sql, array());
                        while ($row = pg_fetch_assoc($organization_user_result)) {
                            $obj['organization_users'][] = $row;
                        }
                    }
                    if (!empty($_metadata)) {
                        $data['data'][] = $obj;
                    } else {
                        $data[] = $obj;
                    }
                }
                if (!empty($_metadata)) {
                    $data['_metadata'] = $_metadata;
                }
                if (!empty($_metadata) && !empty($filter_count)) {
                    $data['filter_count'] = $filter_count;
                }
                if (!empty($_metadata) && !empty($board_user_roles) && OAUTH_CLIENTID != 7857596005287233) {
                    $data['board_user_roles'] = $board_user_roles;
                }
                if (is_plugin_enabled('r_chart') && empty($r_resource_filters['page'])) {
                    require_once PLUGIN_PATH . DS . 'Chart' . DS . 'R' . DS . 'r.php';
                    $passed_values = array();
                    $passed_values['sort'] = $sort;
                    $passed_values['field'] = $field;
                    $passed_values['sort_by'] = $sort_by;
                    $passed_values['query_timeout'] = $query_timeout;
                    $passed_values['limit'] = $limit;
                    $passed_values['conditions'] = $conditions;
                    $passed_values['r_resource_cmd'] = $r_resource_cmd;
                    $passed_values['r_resource_vars'] = $r_resource_vars;
                    $passed_values['r_resource_filters'] = $r_resource_filters;
                    $passed_values['authUser'] = $authUser;
                    $passed_values['val_arr'] = $val_arr;
                    $passed_values['board_lists'] = $board_lists;
                    $plugin_return = call_user_func('Chart_r_get', $passed_values);
                    if (!empty($plugin_return)) {
                        foreach ($plugin_return as $return_plugin_key => $return_plugin_values) {
                            $ {
                                $return_plugin_key
                            } = $return_plugin_values;
                        }
                    }
                    echo json_encode(array_merge($data, $response));
                } else {
                    echo json_encode($data);
                }
            } else {
                $r_debug.= __LINE__ . ': ' . pg_last_error($db_lnk) . '\n';
            }
        } else {
            if (is_plugin_enabled('r_chart')) {
                $data = array();
                $board_lists = array();
                if (!empty($_metadata)) {
                    $data['_metadata'] = $_metadata;
                }
                require_once PLUGIN_PATH . DS . 'Chart' . DS . 'R' . DS . 'r.php';
                $passed_values = array();
                $passed_values['sort'] = $sort;
                $passed_values['field'] = $field;
                $passed_values['sort_by'] = $sort_by;
                $passed_values['query_timeout'] = $query_timeout;
                $passed_values['limit'] = $limit;
                $passed_values['conditions'] = $conditions;
                $passed_values['r_resource_cmd'] = $r_resource_cmd;
                $passed_values['r_resource_vars'] = $r_resource_vars;
                $passed_values['r_resource_filters'] = $r_resource_filters;
                $passed_values['authUser'] = $authUser;
                $passed_values['val_arr'] = $val_arr;
                $passed_values['board_lists'] = $board_lists;
                $plugin_return = call_user_func('Chart_r_get', $passed_values);
                if (!empty($plugin_return)) {
                    foreach ($plugin_return as $return_plugin_key => $return_plugin_values) {
                        $ {
                            $return_plugin_key
                        } = $return_plugin_values;
                    }
                }
                echo json_encode(array_merge($data, $response));
            } else {
                echo json_encode($response);
            }
        }
        break;

    case '/settings/?':
        $response = array();
        $sql = false;
        $s_sql = 'SELECT id, name, parent_id FROM setting_categories WHERE parent_id IS null ORDER BY "order" ASC';
        $s_result = pg_query_params($db_lnk, $s_sql, array());
        while ($row = pg_fetch_assoc($s_result)) {
            if ($row['id'] == $r_resource_vars['settings'] || $row['parent_id'] == $r_resource_vars['settings']) {
                $s_sql = 'SELECT s.*, sc.name as category_name FROM settings s LEFT JOIN setting_categories sc ON sc.id = s.setting_category_id  WHERE  setting_category_id = $1 OR setting_category_parent_id = $2 ORDER BY "order" ASC';
                $s_val = array(
                    $row['id'],
                    $row['id']
                );
                $ss_result = pg_query_params($db_lnk, $s_sql, $s_val);
                while ($srow = pg_fetch_assoc($ss_result)) {
                    $row['settings'][] = $srow;
                }
            }
            $response[] = $row;
        }
        $timezones_result = pg_query_params($db_lnk, 'SELECT * FROM timezones order by utc_offset::int', array());
        $timezones = array();
        while ($timezones_row = pg_fetch_assoc($timezones_result)) {
            $timezones[] = $timezones_row;
        }
        $response[]['timezones'] = $timezones;
        echo json_encode($response);
        break;

    case '/email_templates/?':
        $response = array();
        $sql = false;
        $s_sql = 'SELECT id, display_name FROM email_templates ORDER BY id ASC';
        $s_result = pg_query_params($db_lnk, $s_sql, array());
        while ($row = pg_fetch_assoc($s_result)) {
            if ($row['id'] == $r_resource_vars['email_templates']) {
                $s_sql = 'SELECT from_email, reply_to_email, name, description, subject, email_text_content, email_variables, display_name FROM email_templates WHERE  id = $1';
                $s_val = array(
                    $row['id']
                );
                $ss_result = pg_query_params($db_lnk, $s_sql, $s_val);
                while ($srow = pg_fetch_assoc($ss_result)) {
                    $row['template'] = $srow;
                }
            }
            $response[] = $row;
        }
        echo json_encode($response);
        break;

    case '/boards/?':
        $board = array();
        $s_sql = 'SELECT id FROM boards WHERE id =  $1';
        $board[] = $r_resource_vars['boards'];
        $check_board = executeQuery($s_sql, $board);
        if (!empty($check_board)) {
            $s_sql = 'SELECT b.board_visibility, bu.user_id FROM boards AS b LEFT JOIN boards_users AS bu ON bu.board_id = b.id WHERE b.id =  $1';
            $arr = array();
            $arr[] = $r_resource_vars['boards'];
            if (!empty($authUser) && $authUser['role_id'] != 1) {
                $s_sql.= ' AND (b.board_visibility = 2 OR bu.user_id = $2)';
                $arr[] = $authUser['id'];
            } else if (empty($authUser)) {
                $s_sql.= ' AND b.board_visibility = 2 ';
            }
            $check_visibility = executeQuery($s_sql, $arr);
            if (!empty($check_visibility)) {
                if (isset($_GET["type"]) && $_GET["type"] == "instant_card") {
                    $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM instant_board_listing ul WHERE id = $1 ORDER BY id DESC) as d';
                } else {
                    $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM boards_listing ul WHERE id = $1 ORDER BY id DESC) as d';
                }
                array_push($pg_params, $r_resource_vars['boards']);
                if (!empty($sql)) {
                    if ($result = pg_query_params($db_lnk, $sql, $pg_params)) {
                        $data = array();
                        while ($row = pg_fetch_row($result)) {
                            $obj = json_decode($row[0], true);
                            global $_server_domain_url;
                            if (!empty($authUser)) {
                                $md5_hash = md5(SECURITYSALT . $r_resource_vars['boards'] . $authUser['id']);
                                $obj['google_syn_url'] = $_server_domain_url . '/ical/' . $r_resource_vars['boards'] . '/' . $authUser['id'] . '/' . $md5_hash . '.ics';
                            }
                            $acl_links_sql = 'SELECT row_to_json(d) FROM (SELECT * FROM acl_board_links_listing) as d';
                            $acl_links_result = pg_query_params($db_lnk, $acl_links_sql, array());
                            $obj['acl_links'] = array();
                            while ($row = pg_fetch_assoc($acl_links_result)) {
                                $obj['acl_links'][] = json_decode($row['row_to_json'], true);
                            }
                            $board_user_roles_sql = 'SELECT row_to_json(d) FROM (SELECT * FROM board_user_roles) as d';
                            $board_user_roles_result = pg_query_params($db_lnk, $board_user_roles_sql, array());
                            $obj['board_user_roles'] = array();
                            while ($row = pg_fetch_assoc($board_user_roles_result)) {
                                $obj['board_user_roles'][] = json_decode($row['row_to_json'], true);
                            }
                            if (!empty($obj['organization_id']) && $obj['organization_id'] !== 0) {
                                $obj['organization_users'] = array();
                                $organization_user_sql = 'SELECT id, organization_id, user_id  FROM organizations_users WHERE organization_id = ' . $obj['organization_id'] . 'ORDER BY id ASC';
                                $organization_user_result = pg_query_params($db_lnk, $organization_user_sql, array());
                                while ($row = pg_fetch_assoc($organization_user_result)) {
                                    $obj['organization_users'][] = $row;
                                }
                            }
                            $data = $obj;
                        }
                        if (!isset($_GET["type"]) || (isset($_GET["type"]) && $_GET["type"] != "instant_card")) {
                            if (is_plugin_enabled('r_custom_fields')) {
                                require_once PLUGIN_PATH . DS . 'CustomFields' . DS . 'functions.php';
                                $data = customFieldAfterFetchBoard($r_resource_cmd, $r_resource_vars, $r_resource_filters, $data);
                                array_merge($data, $data);
                            }
                            if (is_plugin_enabled('r_gantt_view')) {
                                require_once PLUGIN_PATH . DS . 'Gantt' . DS . 'functions.php';
                                $data = cardDependencyAfterFetchBoard($r_resource_cmd, $r_resource_vars, $r_resource_filters, $data);
                                array_merge($data, $data);
                            }
                        }
                        echo json_encode($data);
                        pg_free_result($result);
                    } else {
                        $r_debug.= __LINE__ . ': ' . pg_last_error($db_lnk) . '\n';
                    }
                }
            } else {
                $response['error']['type'] = 'visibility';
                $response['error']['message'] = 'Unauthorized';
                header($_SERVER['SERVER_PROTOCOL'] . ' 401 Unauthorized', true, 401);
            }
        } else {
            $response['error']['type'] = 'board';
            $response['error']['message'] = 'Bad Request';
            header($_SERVER['SERVER_PROTOCOL'] . ' 400 Bad Request', true, 400);
            echo json_encode($response);
        }
        break;

    case '/organizations':
        if (!empty($r_resource_filters['type']) && $r_resource_filters['type'] == 'simple') {
            $organization_ids = array();
            $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM organizations';
            if (!empty($authUser) && $authUser['role_id'] != 1) {
                $s_sql = 'SELECT b.organization_id FROM boards_users AS bu LEFT JOIN boards AS b ON b.id = bu.board_id WHERE bu.user_id = $1';
                $conditions = array(
                    $authUser['id']
                );
                $s_result = pg_query_params($db_lnk, $s_sql, $conditions);
                while ($row = pg_fetch_assoc($s_result)) {
                    if ($row['organization_id'] != 0) {
                        array_push($organization_ids, $row['organization_id']);
                    }
                }
                $s_sql = 'SELECT id FROM organizations WHERE user_id = $1';
                $conditions = array(
                    $authUser['id']
                );
                $s_result = pg_query_params($db_lnk, $s_sql, $conditions);
                while ($row = pg_fetch_assoc($s_result)) {
                    array_push($organization_ids, $row['id']);
                }
                $s_sql = 'SELECT organization_id FROM organizations_users WHERE user_id = $1';
                $conditions = array(
                    $authUser['id']
                );
                $s_result = pg_query_params($db_lnk, $s_sql, $conditions);
                while ($row = pg_fetch_assoc($s_result)) {
                    array_push($organization_ids, $row['organization_id']);
                }
                if (!empty($organization_ids)) {
                    $sql.= ' WHERE id IN (' . implode(",", array_unique($organization_ids)) . ')';
                } else {
                    $sql.= ' WHERE user_id = ' . $authUser['id'];
                }
            }
            $sql.= ' ORDER BY id ASC) as d ';
            if (!empty($sql)) {
                if ($result = pg_query_params($db_lnk, $sql, $pg_params)) {
                    $data = array();
                    while ($row = pg_fetch_row($result)) {
                        $obj = json_decode($row[0], true);
                        $data[] = $obj;
                    }
                    echo json_encode($data);
                } else {
                    $r_debug.= __LINE__ . ': ' . pg_last_error($db_lnk) . '\n';
                }
            }
        } else {
            $organization_ids = array();
            $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM organizations_listing';
            if (!empty($authUser) && $authUser['role_id'] != 1) {
                $s_sql = 'SELECT b.organization_id FROM boards_users AS bu LEFT JOIN boards AS b ON b.id = bu.board_id WHERE bu.user_id = $1';
                $conditions = array(
                    $authUser['id']
                );
                $s_result = pg_query_params($db_lnk, $s_sql, $conditions);
                while ($row = pg_fetch_assoc($s_result)) {
                    if ($row['organization_id'] != 0) {
                        array_push($organization_ids, $row['organization_id']);
                    }
                }
                $s_sql = 'SELECT id FROM organizations WHERE user_id = $1';
                $conditions = array(
                    $authUser['id']
                );
                $s_result = pg_query_params($db_lnk, $s_sql, $conditions);
                while ($row = pg_fetch_assoc($s_result)) {
                    array_push($organization_ids, $row['id']);
                }
                $s_sql = 'SELECT organization_id FROM organizations_users WHERE user_id = $1';
                $conditions = array(
                    $authUser['id']
                );
                $s_result = pg_query_params($db_lnk, $s_sql, $conditions);
                while ($row = pg_fetch_assoc($s_result)) {
                    array_push($organization_ids, $row['organization_id']);
                }
                if (!empty($organization_ids)) {
                    $sql.= ' WHERE id IN (' . implode(",", array_unique($organization_ids)) . ')';
                } else {
                    $sql.= ' WHERE user_id = ' . $authUser['id'];
                }
            }
            $sql.= ' ORDER BY id ASC) as d ';
            if (!empty($sql)) {
                if ($result = pg_query_params($db_lnk, $sql, $pg_params)) {
                    $data = array();
                    while ($row = pg_fetch_row($result)) {
                        $obj = json_decode($row[0], true);
                        $acl_links_sql = 'SELECT row_to_json(d) FROM (SELECT * FROM acl_organization_links_listing) as d';
                        $acl_links_result = pg_query_params($db_lnk, $acl_links_sql, array());
                        $obj['acl_links'] = array();
                        while ($row = pg_fetch_assoc($acl_links_result)) {
                            $obj['acl_links'][] = json_decode($row['row_to_json'], true);
                        }
                        $organization_user_roles_sql = 'SELECT row_to_json(d) FROM (SELECT * FROM organization_user_roles) as d';
                        $organization_user_roles_result = pg_query_params($db_lnk, $organization_user_roles_sql, array());
                        $obj['organization_user_roles'] = array();
                        while ($row = pg_fetch_assoc($organization_user_roles_result)) {
                            $obj['organization_user_roles'][] = json_decode($row['row_to_json'], true);
                        }
                        $data[] = $obj;
                    }
                    echo json_encode($data);
                } else {
                    $r_debug.= __LINE__ . ': ' . pg_last_error($db_lnk) . '\n';
                }
            }
        }
        break;

    case '/organizations/?':
        $s_sql = 'SELECT o.organization_visibility, ou.user_id FROM organizations AS o LEFT JOIN organizations_users AS ou ON ou.organization_id = o.id WHERE o.id =  $1';
        $arr = array();
        $arr[] = $r_resource_vars['organizations'];
        if (!empty($authUser) && $authUser['role_id'] != 1) {
            $s_sql.= ' AND (o.organization_visibility = 1 OR ou.user_id = $2)';
            $arr[] = $authUser['id'];
        } else if (empty($authUser)) {
            $s_sql.= ' AND o.organization_visibility = 1 ';
        }
        $check_visibility = executeQuery($s_sql, $arr);
        if (!empty($check_visibility)) {
            $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM organization_listing ul WHERE id = $1 ORDER BY id DESC ) as d';
            array_push($pg_params, $r_resource_vars['organizations']);
            if (!empty($sql)) {
                if ($result = pg_query_params($db_lnk, $sql, $pg_params)) {
                    $data = array();
                    while ($row = pg_fetch_row($result)) {
                        $obj = json_decode($row[0], true);
                        $data = $obj;
                    }
                    $acl_organization_links_sql = 'SELECT row_to_json(d) FROM (SELECT * FROM acl_organization_links_listing) as d';
                    $acl_organization_links_result = pg_query_params($db_lnk, $acl_organization_links_sql, array());
                    $data['acl_links'] = array();
                    while ($row = pg_fetch_assoc($acl_organization_links_result)) {
                        $data['acl_links'][] = json_decode($row['row_to_json'], true);
                    }
                    $organization_user_roles_sql = 'SELECT id, name, description FROM organization_user_roles ORDER BY id ASC';
                    $organization_user_roles_result = pg_query_params($db_lnk, $organization_user_roles_sql, array());
                    $data['organization_user_roles'] = array();
                    while ($row = pg_fetch_assoc($organization_user_roles_result)) {
                        $data['organization_user_roles'][] = $row;
                    }
                    echo json_encode($data);
                } else {
                    $r_debug.= __LINE__ . ': ' . pg_last_error($db_lnk) . '\n';
                }
            }
        } else {
            $response['error']['type'] = 'visibility';
            $response['error']['message'] = 'Unauthorized';
            echo json_encode($response);
        }
        break;

    case '/boards/?/lists/?/cards/?/activities':
    case '/boards/?/lists/?/activities':
    case '/boards/?/activities':
        $val_array = array(
            $r_resource_vars['boards']
        );
        $order = '';
        $board = executeQuery('SELECT board_visibility FROM boards_listing WHERE id = $1', $val_array);
        if (isset($authUser['id']) && $authUser['id'] != 'undefined' && !empty($authUser['id'])) {
            $val_array = array(
                $r_resource_vars['boards'],
                $authUser['id']
            );
            $boards_user = executeQuery('SELECT * FROM boards_users WHERE board_id = $1 AND user_id = $2', $val_array);
        }
        if ((!empty($authUser) && $authUser['role_id'] == 1) || $board['board_visibility'] == 2 || !empty($boards_user)) {
            $construct_offset = '';
            $condition = '';
            array_push($pg_params, $r_resource_vars['boards']);
            $i = 2;
            if (isset($r_resource_filters['last_activity_id']) && $r_resource_filters['last_activity_id'] > 0) {
                if (!empty($r_resource_filters['type']) && $r_resource_filters['type'] == 'all') {
                    $condition = ' AND al.id < $' . $i;
                } else {
                    $condition = ' AND al.id > $' . $i;
                }
                array_push($pg_params, $r_resource_filters['last_activity_id']);
                $i++;
            }
            if (!empty($r_resource_vars['cards'])) {
                $condition.= ' AND al.card_id = $' . $i;
                array_push($pg_params, $r_resource_vars['cards']);
                $i++;
            } else if (!empty($r_resource_vars['lists'])) {
                $condition.= ' AND al.list_id = $' . $i;
                array_push($pg_params, $r_resource_vars['lists']);
                $i++;
            }
            if (!empty($r_resource_filters['filter'])) {
                $condition.= ' AND al.type = $' . $i;
                array_push($pg_params, $r_resource_filters['filter']);
                $i++;
            }
            if (!empty($r_resource_filters['mode']) && ($r_resource_filters['mode'] != 'all' || (isset($r_resource_filters['view']) && $r_resource_filters['view'] == 'modal_card'))) {
                if ($r_resource_filters['mode'] == 'activity') {
                    $condition.= ' AND (al.type != $' . $i;
                    array_push($pg_params, 'add_comment');
                    $i++;
                    $condition.= ' and al.type != $' . $i . ')';
                    array_push($pg_params, 'edit_comment');
                    $i++;
                } else if ($r_resource_filters['mode'] == 'comment') {
                    $condition.= ' AND al.type = $' . $i;
                    array_push($pg_params, 'add_comment');
                    $i++;
                    /* $condition.= ' OR al.type = $' . $i . ')';
                        array_push($pg_params, 'edit_comment');
                        $i++; */
                }
                $order = 'ORDER BY freshness_ts DESC, depth ASC';
            }
            $limit = PAGING_COUNT;
            if (!empty($r_resource_filters['limit'])) {
                $limit = $r_resource_filters['limit'];
            }
            if (isset($r_resource_filters['mode']) && $r_resource_filters['mode'] == '1' || (!isset($r_resource_filters['view']) && $r_resource_filters['mode'] == 'comment')) {
                $order = 'ORDER BY al.id DESC';
            }
            if (!isset($r_resource_vars['lists']) && !isset($r_resource_vars['cards'])) {
                $order = 'ORDER BY al.id DESC';
            }
            if (isset($r_resource_filters['page'])) {
                $offset_val = ($r_resource_filters['page'] - 1) * PAGING_COUNT;
                if ($offset_val < 0) {
                    $offset_val = 0;
                }
                $construct_offset = ' offset ' . $offset_val;
            }
            $sql = 'SELECT row_to_json(d) FROM (SELECT al.*, u.username, u.profile_picture_path, u.initials, u.full_name, c.description, c.name as card_name FROM activities_listing al LEFT JOIN users u ON al.user_id = u.id LEFT JOIN cards c on al.card_id = c.id WHERE al.board_id = $1' . $condition . ' ' . $order . ' LIMIT ' . $limit . ' ' . $construct_offset . ') as d ';
            if (empty($r_resource_filters['from']) || (!empty($r_resource_filters['from']) && $r_resource_filters['from'] != 'app')) {
                $c_sql = 'SELECT COUNT(*) FROM activities_listing al WHERE al.board_id = $1' . $condition;
            }
            if (!empty($c_sql)) {
                $paging_data = paginate_data($c_sql, $db_lnk, $pg_params, $r_resource_filters);
                $sql.= $paging_data['sql'];
                $_metadata = $paging_data['_metadata'];
            }
            if (!empty($sql)) {
                if ($result = pg_query_params($db_lnk, $sql, $pg_params)) {
                    $data = array();
                    $board_lists = array();
                    while ($row = pg_fetch_row($result)) {
                        $obj = json_decode($row[0], true);
                        if (isset($obj['board_activities']) && !empty($obj['board_activities'])) {
                            $board_activities_count = count($obj['board_activities']);
                            for ($k = 0; $k < $board_activities_count; $k++) {
                                if (!empty($obj['board_activities'][$k]['revisions']) && trim($obj['board_activities'][$k]['revisions']) != '') {
                                    $revisions = unserialize($obj['board_activities'][$k]['revisions']);
                                    $diff = array();
                                    if (!empty($revisions['new_value'])) {
                                        foreach ($revisions['new_value'] as $key => $value) {
                                            if ($key != 'is_archived' && $key != 'is_deleted' && $key != 'created' && $key != 'modified' && $obj['type'] != 'moved_card_checklist_item' && $obj['type'] != 'add_card_desc' && $obj['type'] != 'add_card_duedate' && $obj['type'] != 'delete_card_duedate' && $obj['type'] != 'change_visibility' && $obj['type'] != 'add_background' && $obj['type'] != 'change_background') {
                                                $old_val = ($revisions['old_value'][$key] != null && $revisions['old_value'][$key] != 'null') ? $revisions['old_value'][$key] : '';
                                                $new_val = ($revisions['new_value'][$key] != null && $revisions['new_value'][$key] != 'null') ? $revisions['new_value'][$key] : '';
                                                $diff[] = nl2br(getRevisiondifference($old_val, $new_val));
                                            }
                                            if ($obj['type'] == 'add_card_desc' || $obj['type'] == 'add_card_desc' || $obj['type'] == '	edit_card_duedate' || $obj['type'] == 'change_visibility' || $obj['type'] == 'add_background' || $obj['type'] == 'change_background') {
                                                $diff[] = $revisions['new_value'][$key];
                                            }
                                        }
                                        if (isset($diff)) {
                                            $obj['board_activities'][$k]['difference'] = $diff;
                                        }
                                    } else if (!empty($revisions['old_value']) && isset($obj['type']) && $obj['type'] == 'delete_card_comment') {
                                        $obj['board_activities'][$k]['difference'] = nl2br(getRevisiondifference($revisions['old_value'], ''));
                                    }
                                }
                            }
                        }
                        if (!empty($r_resource_filters['view']) && $r_resource_filters['view'] === 'modal_card' && isset($r_resource_filters['view'])) {
                            $replaceContent = array(
                                'the card ##CARD_LINK##' => 'this card',
                            );
                            $obj['comment'] = strtr($obj['comment'], $replaceContent);
                            $replaceContent = array(
                                'on card ##CARD_LINK##' => 'this card',
                            );
                            $obj['comment'] = strtr($obj['comment'], $replaceContent);
                            if ($obj['type'] === 'add_card') {
                                $obj['comment'] = '##USER_NAME## added this card';
                            }
                            if ($obj['type'] === 'convert_card') {
                                $replaceContent = array(
                                    ' to list ##LIST_NAME##' => '',
                                );
                                $obj['comment'] = strtr($obj['comment'], $replaceContent);
                            }
                        } else {
                            if ($obj['type'] === 'add_comment') {
                                $obj['comment'] = $obj['comment'];
                            }
                        }
                        $obj = ActivityHandler::getActivitiesObj($obj);
                        if (!empty($_metadata)) {
                            $data['data'][] = $obj;
                        } else {
                            $data[] = $obj;
                        }
                    }
                    if (!empty($_metadata)) {
                        $data['_metadata'] = $_metadata;
                    }
                    echo json_encode($data);
                } else {
                    $r_debug.= __LINE__ . ': ' . pg_last_error($db_lnk) . '\n';
                }
            }
        }
        break;

    case '/boards/?/boards_stars':
        $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM board_stars bs WHERE board_id = $1';
        array_push($pg_params, $r_resource_vars['boards']);
        if (!empty($authUser) && $authUser['role_id'] != 1) {
            $sql.= ' and user_id = $2';
            array_push($pg_params, $authUser['id']);
        }
        $sql.= ' ORDER BY id DESC) as d ';
        if (!empty($sql)) {
            if ($result = pg_query_params($db_lnk, $sql, $pg_params)) {
                $data = array();
                while ($row = pg_fetch_row($result)) {
                    $obj = json_decode($row[0], true);
                    $data = $obj;
                }
                echo json_encode($data);
            } else {
                $r_debug.= __LINE__ . ': ' . pg_last_error($db_lnk) . '\n';
            }
        }
        break;

    case '/boards/?/board_subscribers':
        $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM board_subscribers ul WHERE board_id = $1';
        array_push($pg_params, $r_resource_vars['boards']);
        if (!empty($authUser) && $authUser['role_id'] != 1) {
            $sql.= ' and user_id = $2';
            array_push($pg_params, $authUser['id']);
        }
        $sql.= ' ORDER BY id DESC) as d ';
        if ($result = pg_query_params($db_lnk, $sql, $pg_params)) {
            $data = array();
            while ($row = pg_fetch_row($result)) {
                $obj = json_decode($row[0], true);
                $data[] = $obj;
            }
            echo json_encode($data);
        } else {
            $r_debug.= __LINE__ . ': ' . pg_last_error($db_lnk) . '\n';
        }
        break;

    case '/boards/search':
        $sql = 'SELECT row_to_json(d) FROM (SELECT id, name, background_color FROM boards ul WHERE name ILIKE $1 ORDER BY id DESC) as d';
        array_push($pg_params, '%' . $r_resource_filters['q'] . '%');
        if ($result = pg_query_params($db_lnk, $sql, $pg_params)) {
            $data = array();
            while ($row = pg_fetch_row($result)) {
                $obj = json_decode($row[0], true);
                $data = $obj;
            }
            echo json_encode($data);
        } else {
            $r_debug.= __LINE__ . ': ' . pg_last_error($db_lnk) . '\n';
        }
        break;

    case '/boards/?/lists/?/cards/?':
    case '/boards/?/cards/?':
        $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM cards_listing cll WHERE id = $1) as d ';
        array_push($pg_params, $r_resource_vars['cards']);
        if ($result = pg_query_params($db_lnk, $sql, $pg_params)) {
            $data = array();
            while ($row = pg_fetch_row($result)) {
                $obj = json_decode($row[0], true);
                $data = $obj;
            }
            echo json_encode($data);
        } else {
            $r_debug.= __LINE__ . ': ' . pg_last_error($db_lnk) . '\n';
        }
        break;

    case '/boards/?/labels':
        $metadata = array();
        $data = array();
        array_push($pg_params, $r_resource_vars['boards']);
        $sql = 'SELECT DISTINCT label_id, MAX(name) FROM  cards_labels_listing cll WHERE board_id = $1 GROUP BY label_id ORDER BY MAX(name) ASC';
        if ($res = pg_query_params($db_lnk, $sql, $pg_params)) {
            while ($row = pg_fetch_assoc($res)) {
                $val_arr = array(
                    $row['label_id']
                );
                $label = executeQuery('SELECT * FROM labels WHERE id = $1', $val_arr);
                if ($label) {
                    $data['data'][] = $label;
                }
            }
            echo json_encode($data);
        } else {
            $r_debug.= __LINE__ . ': ' . pg_last_error($db_lnk) . '\n';
        }
        break;

    case '/boards/?/lists':
        $fields = !empty($r_resource_filters['fields']) ? $r_resource_filters['fields'] : '*';
        $_metadata = array();
        $sql = 'SELECT row_to_json(d) FROM (SELECT ' . $fields . ' FROM lists_listing cll WHERE board_id = $1) as d';
        array_push($pg_params, $r_resource_vars['boards']);
        if (empty($r_resource_filters['from']) || (!empty($r_resource_filters['from']) && $r_resource_filters['from'] != 'app')) {
            $c_sql = 'SELECT COUNT(*) FROM lists_listing cll';
            if (!empty($c_sql)) {
                $paging_data = paginate_data($c_sql, $db_lnk, $pg_params, $r_resource_filters);
                $sql.= $paging_data['sql'];
                $_metadata = $paging_data['_metadata'];
            }
        }
        if ($result = pg_query_params($db_lnk, $sql, $pg_params)) {
            $data = array();
            $board_lists = array();
            while ($row = pg_fetch_row($result)) {
                $obj = json_decode($row[0], true);
                $obj = ActivityHandler::getActivitiesObj($obj);
                if (!empty($_metadata)) {
                    $data['data'][] = $obj;
                } else {
                    $data[] = $obj;
                }
            }
            if (!empty($_metadata)) {
                $data['_metadata'] = $_metadata;
            }
            echo json_encode($data);
        } else {
            $r_debug.= __LINE__ . ': ' . pg_last_error($db_lnk) . '\n';
        }
        break;

    case '/boards/?/lists/?/cards':
        $_metadata = array();
        $data = array();
        $fields = !empty($r_resource_filters['fields']) ? $r_resource_filters['fields'] : '*';
        $qry_val_arr = array(
            $r_resource_vars['boards']
        );
        $sort_by_data = pg_query_params($db_lnk, 'SELECT sort_by, sort_direction FROM boards WHERE id = $1', $qry_val_arr);
        $sort_by = pg_fetch_assoc($sort_by_data);
        if (!empty($sort_by['sort_by']) && !empty($sort_by['sort_direction'])) {
            $sort_by_field = "";
            $sort_by_direction = $sort_by['sort_direction'];
            if ($sort_by['sort_by'] == "position" || $sort_by['sort_by'] == "id" || $sort_by['sort_by'] == "name" || $sort_by['sort_by'] == "card_voter_count" || $sort_by['sort_by'] == "attachment_count" || $sort_by['sort_by'] == "comment_count" || $sort_by['sort_by'] == "checklist_item_completed_count" || $sort_by['sort_by'] == "due_date" || $sort_by['sort_by'] == "list_moved_date") {
                $sort_by_field = $sort_by['sort_by'];
            }
            if ($sort_by['sort_by'] == "created_date") {
                $sort_by_field = "created";
            }
            if ($sort_by['sort_by'] == "checklist_item_pending_count") {
                $sort_by_field = "checklist_item_count - checklist_item_completed_count";
            }
            if ($sort_by['sort_by'] == "start_date") {
                $sort_by_field = "custom_fields::json#>>'{start_date}'";
            }
            $sql = 'SELECT row_to_json(d) FROM (SELECT ' . $fields . ' FROM cards_listing cll WHERE board_id = $1 AND list_id = $2 ORDER BY ' . $sort_by_field . ' ' . $sort_by_direction . ' ) as d ';
        } else {
            $sql = 'SELECT row_to_json(d) FROM (SELECT ' . $fields . ' FROM cards_listing cll WHERE board_id = $1 AND list_id = $2 ORDER BY position asc) as d ';
        }
        if (empty($r_resource_filters['from']) || (!empty($r_resource_filters['from']) && $r_resource_filters['from'] != 'app')) {
            $c_sql = 'SELECT COUNT(*) FROM cards_listing cll';
            if (!empty($c_sql)) {
                $paging_data = paginate_data($c_sql, $db_lnk, $pg_params, $r_resource_filters);
                $sql.= $paging_data['sql'];
                $_metadata = $paging_data['_metadata'];
            }
        }
        array_push($pg_params, $r_resource_vars['boards']);
        array_push($pg_params, $r_resource_vars['lists']);
        $qry_val_arr = array(
            $r_resource_vars['lists']
        );
        $attachments = pg_query_params($db_lnk, 'SELECT * FROM card_attachments WHERE list_id = $1 order by created DESC', $qry_val_arr);
        while ($attachment = pg_fetch_assoc($attachments)) {
            $data['attachments'][] = $attachment;
        }
        if ($result = pg_query_params($db_lnk, $sql, $pg_params)) {
            $board_lists = array();
            while ($row = pg_fetch_row($result)) {
                $obj = json_decode($row[0], true);
                if (!empty($_metadata)) {
                    $data['data'][] = $obj;
                } else {
                    $data[] = $obj;
                }
            }
            if (!empty($_metadata)) {
                $data['_metadata'] = $_metadata;
            }
            if (is_plugin_enabled('r_custom_fields')) {
                require_once PLUGIN_PATH . DS . 'CustomFields' . DS . 'functions.php';
                $data = customFieldAfterFetchBoardsListsCards($r_resource_cmd, $r_resource_vars, $r_resource_filters, $data);
            }
            echo json_encode($data);
        } else {
            $r_debug.= __LINE__ . ': ' . pg_last_error($db_lnk) . '\n';
        }
        break;

    case '/activities':
        $condition = '';
        $i = 1;
        $_metadata = array();
        if (isset($r_resource_filters['last_activity_id'])) {
            $condition = ' WHERE al.id < $' . $i;
            array_push($pg_params, $r_resource_filters['last_activity_id']);
            $i++;
        }
        if (!empty($r_resource_filters['filter'])) {
            $condition.= ' AND al.type = $' . $i;
            array_push($pg_params, $r_resource_filters['filter']);
            $i++;
        }
        $limit = PAGING_COUNT;
        if (!empty($r_resource_filters['limit'])) {
            $limit = $r_resource_filters['limit'];
        }
        $sql = 'SELECT row_to_json(d) FROM (SELECT al.*, u.username, u.profile_picture_path, u.initials, u.full_name, c.description FROM activities_listing al LEFT JOIN users u ON al.user_id = u.id LEFT JOIN cards c ON  al.card_id = c.id ' . $condition . ' ORDER BY id DESC limit ' . $limit . ') as d ';
        if (empty($r_resource_filters['from']) || (!empty($r_resource_filters['from']) && $r_resource_filters['from'] != 'app')) {
            $c_sql = 'SELECT COUNT(*) FROM activities_listing al' . $condition;
        }
        if (!empty($c_sql)) {
            $paging_data = paginate_data($c_sql, $db_lnk, $pg_params, $r_resource_filters);
            $sql.= $paging_data['sql'];
            $_metadata = $paging_data['_metadata'];
        }
        if (!empty($sql)) {
            if ($result = pg_query_params($db_lnk, $sql, $pg_params)) {
                $data = array();
                $board_lists = array();
                while ($row = pg_fetch_row($result)) {
                    $obj = json_decode($row[0], true);
                    if (!empty($obj['revisions']) && trim($obj['revisions']) != '' && $obj['type'] !== 'delete_label' && $obj['type'] !== 'change_grid_view_configuration' && $obj['type'] !== 'change_list_view_configuration' && $obj['type'] !== 'update_label' && $obj['type'] !== 'delete_card_dependency') {
                        $revisions = unserialize($obj['revisions']);
                        $obj['revisions'] = $revisions;
                        $diff = array();
                        if (!empty($revisions['new_value'])) {
                            foreach ($revisions['new_value'] as $key => $value) {
                                if ($key != 'is_archived' && $key != 'is_deleted' && $key != 'created' && $key != 'modified' && $key != 'is_offline' && $key != 'uuid' && $key != 'to_date' && $key != 'temp_id' && $obj['type'] != 'moved_card_checklist_item' && $obj['type'] != 'add_card_desc' && $obj['type'] != 'add_card_duedate' && $obj['type'] != 'delete_card_duedate' && $obj['type'] != 'add_background' && $obj['type'] != 'change_background' && $obj['type'] != 'change_visibility') {
                                    $old_val = (isset($revisions['old_value'][$key])) ? $revisions['old_value'][$key] : '';
                                    $new_val = (isset($revisions['new_value'][$key])) ? $revisions['new_value'][$key] : '';
                                    $diff[] = nl2br(getRevisiondifference($old_val, $new_val));
                                }
                                if ($obj['type'] == 'add_card_desc' || $obj['type'] == 'edit_card_duedate' || $obj['type'] == 'add_background' || $obj['type'] == 'change_background' || $obj['type'] == 'change_visibility') {
                                    $diff[] = $revisions['new_value'][$key];
                                }
                            }
                        } else if (!empty($revisions['old_value']) && isset($obj['type']) && $obj['type'] == 'delete_card_comment') {
                            $diff[] = nl2br(getRevisiondifference($revisions['old_value'], ''));
                        }
                        if (isset($diff)) {
                            $obj['difference'] = $diff;
                        }
                    }
                    if (!empty($_metadata)) {
                        $data['data'][] = $obj;
                    } else {
                        $data[] = $obj;
                    }
                }
                if (!empty($_metadata) && !empty($filter_count)) {
                    $data['filter_count'] = $filter_count;
                }
                if (!empty($_metadata)) {
                    $data['_metadata'] = $_metadata;
                }
                echo json_encode($data);
            } else {
                $r_debug.= __LINE__ . ': ' . pg_last_error($db_lnk) . '\n';
            }
        }
        break;

    case '/timezones':
        $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM timezones order by utc_offset::int) as d ';
        if ($result = pg_query_params($db_lnk, $sql, array())) {
            $data = array();
            while ($row = pg_fetch_row($result)) {
                $obj = json_decode($row[0], true);
                $data[] = $obj;
            }
            echo json_encode($data);
        } else {
            $r_debug.= __LINE__ . ': ' . pg_last_error($db_lnk) . '\n';
        }
        break;

    case '/boards/?/lists/?/cards/?/checklists':
        $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM checklist_add_listing al WHERE board_id = $1) as d ';
        array_push($pg_params, $r_resource_vars['boards']);
        if ($result = pg_query_params($db_lnk, $sql, $pg_params)) {
            $data = array();
            while ($row = pg_fetch_row($result)) {
                $obj = json_decode($row[0], true);
                $data[] = $obj;
            }
            echo json_encode($data);
        } else {
            $r_debug.= __LINE__ . ': ' . pg_last_error($db_lnk) . '\n';
        }
        break;

    case '/boards/?/visibility':
        $sql = 'SELECT row_to_json(d) FROM (SELECT board_visibility FROM boards bl WHERE bl.id = $1) as d ';
        array_push($pg_params, $r_resource_vars['boards']);
        if ($result = pg_query_params($db_lnk, $sql, $pg_params)) {
            $data = array();
            while ($row = pg_fetch_row($result)) {
                $obj = json_decode($row[0], true);
                $data = $obj;
            }
            echo json_encode($data);
        } else {
            $r_debug.= __LINE__ . ': ' . pg_last_error($db_lnk) . '\n';
        }
        break;

    case '/workflow_templates':
        $files = glob(APP_PATH . DS . 'client' . DS . 'js' . DS . 'workflow_templates' . DS . '*.json', GLOB_BRACE);
        foreach ($files as $file) {
            $data = file_get_contents($file);
            $json = json_decode($data, true);
            $response[] = array(
                'name' => $json['name'],
                'value' => implode($json['lists'], ',')
            );
        }
        sort($response);
        echo json_encode($response);
        break;

    case '/boards/?/lists/?/cards/?/search':
        $sql = 'SELECT row_to_json(d) FROM (SELECT bul.id, bul.user_id, bul.username, bul.profile_picture_path, bul.full_name, bul.initials  FROM boards_users_listing bul WHERE';
        $sql.= '(bul.username LIKE $1 OR bul.email LIKE $2) AND bul.board_id = $3) as d ';
        array_push($pg_params, '%' . $r_resource_filters['q'] . '%', '%' . $r_resource_filters['q'] . '%', $r_resource_vars['boards']);
        if (empty($r_resource_filters['q'])) {
            $sql = false;
            $response = array();
            $pg_params = array();
            echo json_encode($response);
        } else {
            if ($result = pg_query_params($db_lnk, $sql, $pg_params)) {
                $data = array();
                while ($row = pg_fetch_row($result)) {
                    $obj = json_decode($row[0], true);
                    $data[] = $obj;
                }
                echo json_encode($data);
            } else {
                $r_debug.= __LINE__ . ': ' . pg_last_error($db_lnk) . '\n';
            }
        }
        break;

    case '/boards/?/cards/search':
        $user_id = (!empty($authUser['id'])) ? $authUser['id'] : 0;
        if ($authUser['role_id'] != 1) {
            $sql = 'SELECT row_to_json(d) FROM (SELECT DISTINCT c.id, c.name, bu.board_id, c.list_id FROM boards_users bu join cards c on c.board_id = bu.board_id WHERE bu.board_id IN (SELECT board_id FROM boards_users WHERE user_id = $1 ) AND LOWER(c.name)  LIKE $2 AND  c.board_id = $3 ORDER BY name ASC) as d';
            array_push($pg_params, $user_id, '%' . strtolower($r_resource_filters['q']) . '%', $r_resource_vars['boards']);
        } else {
            $sql = 'SELECT row_to_json(d) FROM (SELECT DISTINCT c.id, c.name, bu.board_id, c.list_id FROM boards_users bu join cards c on c.board_id = bu.board_id WHERE bu.board_id IN (SELECT board_id FROM boards_users) AND LOWER(c.name)  LIKE $1 AND  c.board_id = $2 ORDER BY name ASC) as d';
            array_push($pg_params, '%' . strtolower($r_resource_filters['q']) . '%', $r_resource_vars['boards']);
        }
        if (empty($r_resource_filters['q'])) {
            $sql = false;
            $response = array();
            $pg_params = array();
            echo json_encode($response);
        } else {
            if ($result = pg_query_params($db_lnk, $sql, $pg_params)) {
                $data = array();
                while ($row = pg_fetch_row($result)) {
                    $obj = json_decode($row[0], true);
                    $obj_val_arr = array(
                        $obj['list_id']
                    );
                    $list_exist = executeQuery('SELECT * FROM lists WHERE id = $1', $obj_val_arr);
                    if (!empty($list_exist)) {
                        $data[] = $obj;
                    }
                }
                echo json_encode($data);
            } else {
                $r_debug.= __LINE__ . ': ' . pg_last_error($db_lnk) . '\n';
            }
        }
        break;

    case '/acl_links':
        $sql = false;
        $acl_links_sql = 'SELECT row_to_json(d) FROM (SELECT acl_links.id,  acl_links.name, acl_links.group_id, acl_links.slug, ( SELECT array_to_json(array_agg(row_to_json(alr.*))) AS array_to_json FROM ( SELECT acl_links_roles.role_id FROM acl_links_roles acl_links_roles WHERE acl_links_roles.acl_link_id = acl_links.id ORDER BY acl_links_roles.role_id) alr) AS acl_links_roles, acl_links.is_guest_action, acl_links.is_user_action, acl_links.is_admin_action, acl_links.is_hide FROM acl_links acl_links ORDER BY group_id ASC, id ASC) as d';
        $acl_links_result = pg_query_params($db_lnk, $acl_links_sql, array());
        $response['acl_links'] = array();
        while ($row = pg_fetch_assoc($acl_links_result)) {
            $response['acl_links'][] = json_decode($row['row_to_json'], true);
        }
        $roles_sql = 'SELECT id, name FROM roles ORDER BY id ASC';
        $roles_result = pg_query_params($db_lnk, $roles_sql, array());
        $response['roles'] = array();
        while ($row = pg_fetch_assoc($roles_result)) {
            $response['roles'][] = $row;
        }
        $acl_board_links_sql = 'SELECT row_to_json(d) FROM (SELECT acl_board_links.id,  acl_board_links.name, acl_board_links.group_id, ( SELECT array_to_json(array_agg(row_to_json(alr.*))) AS array_to_json FROM ( SELECT acl_board_links_boards_user_roles.board_user_role_id FROM acl_board_links_boards_user_roles acl_board_links_boards_user_roles WHERE acl_board_links_boards_user_roles.acl_board_link_id = acl_board_links.id ORDER BY acl_board_links_boards_user_roles.board_user_role_id) alr) AS acl_board_links_boards_user_roles, acl_board_links.is_hide FROM acl_board_links acl_board_links ORDER BY group_id ASC, id ASC) as d';
        $acl_board_links_result = pg_query_params($db_lnk, $acl_board_links_sql, array());
        $response['acl_board_links'] = array();
        while ($row = pg_fetch_assoc($acl_board_links_result)) {
            $response['acl_board_links'][] = json_decode($row['row_to_json'], true);
        }
        $board_user_roles_sql = 'SELECT id, name, description FROM board_user_roles ORDER BY id ASC';
        $board_user_roles_result = pg_query_params($db_lnk, $board_user_roles_sql, array());
        $response['board_user_roles'] = array();
        while ($row = pg_fetch_assoc($board_user_roles_result)) {
            $response['board_user_roles'][] = $row;
        }
        $acl_organization_links_sql = 'SELECT row_to_json(d) FROM (SELECT acl_organization_links.id,  acl_organization_links.name, acl_organization_links.group_id, ( SELECT array_to_json(array_agg(row_to_json(alr.*))) AS array_to_json FROM ( SELECT acl_organization_links_organizations_user_roles.organization_user_role_id FROM acl_organization_links_organizations_user_roles acl_organization_links_organizations_user_roles WHERE acl_organization_links_organizations_user_roles.acl_organization_link_id = acl_organization_links.id ORDER BY acl_organization_links_organizations_user_roles.organization_user_role_id) alr) AS acl_organization_links_organizations_user_roles FROM acl_organization_links acl_organization_links ORDER BY group_id ASC, id ASC) as d';
        $acl_organization_links_result = pg_query_params($db_lnk, $acl_organization_links_sql, array());
        $response['acl_organization_links'] = array();
        while ($row = pg_fetch_assoc($acl_organization_links_result)) {
            $response['acl_organization_links'][] = json_decode($row['row_to_json'], true);
        }
        $organization_user_roles_sql = 'SELECT id, name, description FROM organization_user_roles ORDER BY id ASC';
        $organization_user_roles_result = pg_query_params($db_lnk, $organization_user_roles_sql, array());
        $response['organization_user_roles'] = array();
        while ($row = pg_fetch_assoc($organization_user_roles_result)) {
            $response['organization_user_roles'][] = $row;
        }
        echo json_encode($response);
        break;

    case '/settings':
        $s_sql = pg_query_params($db_lnk, "SELECT name, value FROM settings WHERE name IN ('SITE_NAME', 'SITE_TIMEZONE', 'DROPBOX_APPKEY', 'LABEL_ICON', 'FLICKR_API_KEY', 'DEFAULT_LANGUAGE', 'IS_TWO_FACTOR_AUTHENTICATION_ENABLED', 'IMAP_EMAIL', 'PAGING_COUNT', 'ALLOWED_FILE_EXTENSIONS', 'DEFAULT_CARD_VIEW', 'DEFAULT_CARD_VIEW', 'R_LDAP_LOGIN_HANDLE', 'CALENDAR_VIEW_CARD_COLOR','R_MLDAP_LOGIN_HANDLE','R_MLDAP_SERVERS')", array());
        while ($row = pg_fetch_assoc($s_sql)) {
            $response[$row['name']] = $row['value'];
        }
        $files = glob(APP_PATH . DS . 'client' . DS . 'apps' . DS . '*' . DS . 'app.json', GLOB_BRACE);
        if (!empty($files)) {
            foreach ($files as $file) {
                $content = file_get_contents($file);
                $data = json_decode($content, true);
                if ($data['enabled'] === true) {
                    $response['apps']['enabled_apps'][] = $data['id'];
                    $folder = explode(DS, $file);
                    foreach ($data as $key => $value) {
                        if ($key != 'settings') {
                            $response['apps_data'][$folder[count($folder) - 2]][$key] = $value;
                        }
                    }
                    if (!empty($data['settings'])) {
                        foreach ($data['settings'] as $key => $value) {
                            if ($value['is_public']) {
                                $value['name'] = $key;
                                $response['apps']['settings'][] = $value;
                            }
                        }
                    }
                    if (!empty($data['assets'])) {
                        if (!empty($data['assets']['js'])) {
                            foreach ($data['assets']['js'] as $jsfiles) {
                                if (file_exists(APP_PATH . '/client/' . $jsfiles)) {
                                    $response['apps']['js'][] = $jsfiles;
                                }
                            }
                        }
                        if (!empty($data['assets']['css'])) {
                            foreach ($data['assets']['css'] as $cssfiles) {
                                if (file_exists(APP_PATH . '/client/' . $cssfiles)) {
                                    $response['apps']['css'][] = $cssfiles;
                                }
                            }
                        }
                        if (!empty($data['assets']['html'])) {
                            foreach ($data['assets']['html'] as $htmlfiles) {
                                $response['apps']['html'][] = $htmlfiles;
                            }
                        }
                        if (!empty($data['mutationObservers'])) {
                            $response['apps']['mutationObservers'][] = $data['mutationObservers'];
                        }
                        if (!empty($data['urlChange'])) {
                            $response['apps']['urlChange'][] = $data['urlChange'];
                        }
                    }
                }
            }
        }
        $response['apps_data'] = !empty($response['apps_data']) ? json_encode($response['apps_data']) : '';
        echo json_encode($response);
        break;

    case '/apps':
        $files = glob(APP_PATH . DS . 'client' . DS . 'apps' . DS . '*' . DS . 'app.json', GLOB_BRACE);
        if (!empty($files)) {
            foreach ($files as $file) {
                $folder = explode(DS, $file);
                $content = file_get_contents($file);
                $data = json_decode($content, true);
                $data['folder'] = $data['id'];
                $response[] = $data;
            }
        }
        echo json_encode($response);
        break;

    case '/apps/settings':
        $content = file_get_contents(APP_PATH . DS . 'client' . DS . 'apps' . DS . $r_resource_filters['app'] . DS . 'app.json');
        $data = json_decode($content, true);
        if (file_exists(SITE_URL_FOR_SHELL)) {
            include_once SITE_URL_FOR_SHELL;
        }
        if (!empty($data['settings_from_db'])) {
            $fields = $data['settings_from_db'];
            if ($data['id'] !== 'r_multiple_ldap_login') {
                $result = pg_query_params($db_lnk, 'SELECT * FROM settings WHERE name IN (' . $fields . ') ORDER BY "order" ASC', array());
            } else {
                $result = pg_query_params($db_lnk, 'SELECT * FROM settings WHERE name LIKE $1 ORDER BY "order" ASC', array(
                    '%R_MLDAP%'
                ));
            }
            while ($row = pg_fetch_assoc($result)) {
                $value = array();
                if (strpos($row['name'], 'PASSWORD') !== false) {
                    $value['is_encrypted'] = true;
                }
                $value['name'] = $row['name'];
                $value['folder'] = $r_resource_filters['app'];
                $value['app_name'] = $data['name'];
                $value['is_public'] = false;
                $value['info'] = $row['description'];
                $value['value'] = $row['value'];
                $value['label'] = $row['label'];
                $replaceContent = array(
                    '##SITE_NAME##' => SITE_NAME,
                    '##SITE_URL##' => $_server_domain_url,
                );
                $value['settings_description'] = strtr($data['settings_description'], $replaceContent);
                $response[] = $value;
            }
        } else {
            if (!empty($data['settings'])) {
                foreach ($data['settings'] as $key => $value) {
                    $value['name'] = $key;
                    $value['folder'] = $r_resource_filters['app'];
                    $value['app_name'] = $data['name'];
                    $replaceContent = array(
                        '##SITE_NAME##' => SITE_NAME,
                        '##SITE_URL##' => $_server_domain_url,
                    );
                    $value['settings_description'] = strtr($data['settings_description'], $replaceContent);
                    $response[] = $value;
                }
            }
        }
        echo json_encode($response);
        break;

    case '/oauth/clients':
        $response['oauth_clients'] = array();
        $condition = '';
        if (!empty($_GET['id'])) {
            $condition = 'WHERE id = $1';
            $condition_param = $_GET['id'];
        }
        if (!empty($condition_param)) {
            array_push($pg_params, $condition_param);
        }
        $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM oauth_clients c ' . $condition . ') as d ';
        if ($result = pg_query_params($db_lnk, $sql, $pg_params)) {
            $data = array();
            while ($row = pg_fetch_row($result)) {
                $obj = json_decode($row[0], true);
                $data[] = $obj;
            }
            echo json_encode($data);
        } else {
            $r_debug.= __LINE__ . ': ' . pg_last_error($db_lnk) . '\n';
        }
        break;

    case '/oauth/applications':
        $response['applications'] = array();
        $_metadata = array();
        $sql = 'SELECT row_to_json(d) FROM (SELECT DISTINCT ON (ort.client_id) ort.client_id, oc.client_name FROM oauth_refresh_tokens ort LEFT JOIN oauth_clients oc ON ort.client_id = oc.client_id WHERE ort.user_id = $1 AND ort.client_id != $2) as d ';
        array_push($pg_params, $authUser['username'], '7742632501382313');
        $c_sql = 'SELECT COUNT(*) FROM (SELECT DISTINCT ON (ort.client_id) ort.client_id, oc.client_name FROM oauth_refresh_tokens ort LEFT JOIN oauth_clients oc ON ort.client_id = oc.client_id WHERE ort.user_id = $1 AND ort.client_id != $2) As oc';
        if (!empty($c_sql)) {
            $paging_data = paginate_data($c_sql, $db_lnk, $pg_params, $r_resource_filters);
            $sql.= $paging_data['sql'];
            $_metadata = $paging_data['_metadata'];
        }
        if ($result = pg_query_params($db_lnk, $sql, $pg_params)) {
            $data = array();
            while ($row = pg_fetch_row($result)) {
                $obj = json_decode($row[0], true);
                $data[] = $obj;
            }
            if (!empty($_metadata)) {
                $data['_metadata'] = $_metadata;
            }
            echo json_encode($data);
        } else {
            $r_debug.= __LINE__ . ': ' . pg_last_error($db_lnk) . '\n';
        }
        break;

    case '/webhooks':
        $response['webhooks'] = array();
        $filter_condition = '';
        if (!empty($r_resource_filters['board_id'])) {
            $board_id = $r_resource_filters['board_id'];
            $filter_condition = "WHERE board_id = $board_id";
        }
        $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM webhooks w  ' . $filter_condition . ' ORDER BY id ASC) as d ';
        $c_sql = 'SELECT COUNT(*) FROM webhooks w';
        if (!empty($c_sql)) {
            $paging_data = paginate_data($c_sql, $db_lnk, $pg_params, $r_resource_filters);
            $sql.= $paging_data['sql'];
            $_metadata = $paging_data['_metadata'];
        }
        if ($result = pg_query_params($db_lnk, $sql, $pg_params)) {
            $data = array();
            while ($row = pg_fetch_row($result)) {
                $obj = json_decode($row[0], true);
                $data[] = $obj;
            }
            if (!empty($_metadata)) {
                $data['_metadata'] = $_metadata;
            }
            echo json_encode($data);
        } else {
            $r_debug.= __LINE__ . ': ' . pg_last_error($db_lnk) . '\n';
        }
        break;

    default:
        $plugin_url['ElasticSearch'] = array(
            '/search'
        );
        $plugin_url['SparkPost'] = array(
            '/users/?/sparkpost_test_mail'
        );
        $plugin_url['CardTemplate'] = array(
            '/boards/?/card_template',
            '/card_templates/?',
            '/boards/?/card_templates/?'
        );
        $plugin_url['Chat'] = array(
            '/xmpp_login',
            '/boards/?/chat_history'
        );
        $plugin_url['Insights'] = array(
            '/boards/?/reports'
        );
        $plugin_url['Chart'] = array(
            '/boards'
        );
        $plugin_url['BoardRoleMapper'] = array(
            '/board_roles'
        );
        $plugin_url['Broadcast'] = array(
            '/broadcasts',
            '/broadcasts/?',
            '/me/broadcasts'
        );
        $plugin_url['Group'] = array(
            '/groups',
            '/groups/?'
        );
        $plugin_url['DrawIO'] = array(
            '/card_diagrams',
            '/card_diagrams/?'
        );
        $plugin_url['Wiki'] = array(
            '/pages',
            '/pages/?'
        );
        $plugin_url['CRM'] = array(
            '/contacts',
            '/contacts/?'
        );
        $plugin_url['Salesforce'] = array(
            '/salesforce',
            '/salesforce/?',
            '/salesforce/search',
            '/salesforce/proxy'
        );
        $plugin_url['CustomFields'] = array(
            '/custom_fields',
            '/custom_fields/?',
            '/boards/?/custom_fields',
            '/boards/?/custom_fields/?',
            '/boards/?/cards_custom_fields',
            '/cards/?/cards_custom_fields',
            '/cards/?/cards_custom_fields/?'
        );
        foreach ($plugin_url as $plugin_key => $plugin_values) {
            if (in_array($r_resource_cmd, $plugin_values)) {
                $pluginToBePassed = $plugin_key;
                break;
            }
        }
        if (!empty($pluginToBePassed)) {
            require_once PLUGIN_PATH . DS . $pluginToBePassed . DS . 'R' . DS . 'r.php';
            $passed_values = array();
            $passed_values['sort'] = $sort;
            $passed_values['field'] = $field;
            $passed_values['sort_by'] = $sort_by;
            $passed_values['query_timeout'] = $query_timeout;
            $passed_values['limit'] = $limit;
            $passed_values['conditions'] = $conditions;
            $passed_values['r_resource_cmd'] = $r_resource_cmd;
            $passed_values['r_resource_vars'] = $r_resource_vars;
            $passed_values['r_resource_filters'] = $r_resource_filters;
            $passed_values['authUser'] = $authUser;
            $passed_values['val_arr'] = $val_arr;
            $passed_values['board_lists'] = $board_lists;
            $plugin_return = call_user_func($plugin_key . '_r_get', $passed_values);
            if ($pluginToBePassed === 'CardTemplate') {
                echo json_encode($plugin_return);
            } else if ($pluginToBePassed === 'CustomFields') {
                echo json_encode($plugin_return);
            } else {
                if (!empty($plugin_return)) {
                    foreach ($plugin_return as $return_plugin_key => $return_plugin_values) {
                        $ {
                            $return_plugin_key
                        } = $return_plugin_values;
                    }
                }
                echo json_encode($response);
            }
        }
    }
}
/**
 * Common method to handle POST method
 *
 * @param string $r_resource_cmd     URL
 * @param array  $r_resource_vars    Array generated from URL
 * @param array  $r_resource_filters Array generated from URL query string
 * @param array  $r_post             Post data
 *
 * @return mixed
 */
function r_post($r_resource_cmd, $r_resource_vars, $r_resource_filters, $r_post)
{
    global $r_debug, $db_lnk, $authUser, $thumbsizes, $_server_domain_url, $jabberHost;
    $emailFindReplace = $response = $foreign_id = $cards = $foreign_ids = $diff = $no_organization_users = $srow = $revisions = array();
    $fields = 'created, modified';
    $values = 'now(), now()';
    $json = $sql = $is_return_vlaue = $is_import_board = $keepcards = false;
    $is_keep_attachment = $is_keep_user = $is_keep_label = $is_keep_activity = $is_keep_checklist = $copied_card_id = 0;
    $uuid = $table_name = '';
    if (isset($r_post['uuid'])) {
        $uuid = $r_post['uuid'];
    }
    unset($r_post['temp_id']);
    unset($r_post['uuid']);
    unset($r_post['id']);
    switch ($r_resource_cmd) {
    case '/users/bulk_action':
        $r_post = json_encode($r_post[0]);
        $post_arr = json_decode($r_post, true);
        $action_id = $post_arr['action_id']['action_id'];
        unset($post_arr['action_id']);
        $user_ids = $post_arr;
        if ($action_id == 1) {
            foreach ($user_ids as $user_id) {
                $data = array(
                    0,
                    $user_id['user_id']
                );
                pg_query_params($db_lnk, 'UPDATE users SET is_active = $1 WHERE id = $2', $data);
            }
            $response = array(
                'success' => 'Checked users are blocked successfully.'
            );
        } else if ($action_id == 2) {
            foreach ($user_ids as $user_id) {
                $data = array(
                    1,
                    $user_id['user_id']
                );
                pg_query_params($db_lnk, 'UPDATE users SET is_active = $1 WHERE id = $2', $data);
            }
            $response = array(
                'success' => 'Checked users are unblocked successfully.'
            );
        } else if ($action_id == 3) {
            foreach ($user_ids as $user_id) {
                if (is_plugin_enabled('r_chat') && $jabberHost && $user_id['user_id']) {
                    xmppDeleteUser($user_id['user_id']);
                }
                $conditions = array(
                    $user_id['user_id']
                );
                $users = pg_query_params($db_lnk, 'DELETE FROM users WHERE id= $1 RETURNING username', $conditions);
            }
            $response = array(
                'success' => 'Checked users are deleted successfully.'
            );
        } else if ($action_id == 4) {
            foreach ($user_ids as $user_id) {
                $data = array(
                    1,
                    $user_id['user_id']
                );
                pg_query_params($db_lnk, 'UPDATE users SET is_email_confirmed = $1 WHERE id = $2', $data);
            }
            $response = array(
                'success' => 'Checked user emails are confirmed successfully.'
            );
        }
        echo json_encode($response);
        break;

    case '/boards/bulk_action':
        $r_post = json_encode($r_post[0]);
        $post_arr = json_decode($r_post, true);
        $action_id = $post_arr['action_id']['action_id'];
        unset($post_arr['action_id']);
        $board_ids = $post_arr;
        if ($action_id == 1) {
            foreach ($board_ids as $board_id) {
                $data = array(
                    1,
                    $board_id['board_id']
                );
                pg_query_params($db_lnk, 'UPDATE boards SET is_closed = $1 WHERE id = $2', $data);
            }
            $response = array(
                'success' => 'Checked boards are closed successfully.'
            );
        } else if ($action_id == 2) {
            foreach ($board_ids as $board_id) {
                $data = array(
                    0,
                    $board_id['board_id']
                );
                pg_query_params($db_lnk, 'UPDATE boards SET is_closed = $1 WHERE id = $2', $data);
            }
            $response = array(
                'success' => 'Checked boards are reopened successfully.'
            );
        } else if ($action_id == 3) {
            if (is_plugin_enabled('r_chat') && $jabberHost) {
                $xmpp = xmppObj();
            }
            foreach ($board_ids as $board_id) {
                if (is_plugin_enabled('r_chat') && $jabberHost) {
                    xmppDestroyRoom($board_id['board_id'], $xmpp);
                }
                $conditions = array(
                    $board_id['board_id']
                );
                $boards = pg_query_params($db_lnk, 'DELETE FROM boards WHERE id= $1', $conditions);
            }
            $response = array(
                'success' => 'Checked boards are deleted successfully.'
            );
        }
        echo json_encode($response);
        break;

    case '/users/forgotpassword': //users forgot password
        $val_arr = array(
            $r_post['email']
        );
        $user = executeQuery('SELECT * FROM users WHERE email = $1 AND is_active = true', $val_arr);
        if ($user) {
            $password = uniqid();
            $val_arr = array(
                getCryptHash($password) ,
                $user['id']
            );
            pg_query_params($db_lnk, 'UPDATE users SET password = $1 WHERE id = $2', $val_arr);
            $emailFindReplace = array(
                '##NAME##' => $user['full_name'],
                '##PASSWORD##' => $password,
            );
            $response = array(
                'success' => 'An email has been sent with your new password.'
            );
            sendMail('forgetpassword', $emailFindReplace, $user['email']);
        } else {
            $response = array(
                'error' => 'No matching email id is found in the database.'
            );
        }
        echo json_encode($response);
        break;

    case '/users': //Admin user add
        $table_name = 'users';
        $val_arr = array(
            $r_post['username'],
            $r_post['email']
        );
        $user = executeQuery('SELECT * FROM users WHERE username = $1 OR email = $2', $val_arr);
        if (!$user) {
            $sql = true;
            $table_name = 'users';
            $r_post['password'] = getCryptHash($r_post['password']);
            $r_post['role_id'] = 2; // user
            $r_post['ip_id'] = saveIp();
            // admin selected email notification
            if (isset($r_post['is_send_newsletter'])) {
                $default_email_notification = $r_post['is_send_newsletter'];
            } else {
                $default_email_notification = 0;
                if (DEFAULT_EMAIL_NOTIFICATION === 'Periodically') {
                    $default_email_notification = 1;
                } else if (DEFAULT_EMAIL_NOTIFICATION === 'Instantly') {
                    $default_email_notification = 2;
                } else if (DEFAULT_EMAIL_NOTIFICATION === 'Daily') {
                    $default_email_notification = 3;
                } else if (DEFAULT_EMAIL_NOTIFICATION === 'Weekly') {
                    $default_email_notification = 4;
                }
            }
            $r_post['is_send_newsletter'] = $default_email_notification;
            $r_post['default_desktop_notification'] = (DEFAULT_DESKTOP_NOTIFICATION === 'Enabled') ? 'true' : 'false';
            $r_post['is_list_notifications_enabled'] = IS_LIST_NOTIFICATIONS_ENABLED;
            $r_post['is_card_notifications_enabled'] = IS_CARD_NOTIFICATIONS_ENABLED;
            $r_post['is_card_members_notifications_enabled'] = IS_CARD_MEMBERS_NOTIFICATIONS_ENABLED;
            $r_post['is_card_labels_notifications_enabled'] = IS_CARD_LABELS_NOTIFICATIONS_ENABLED;
            $r_post['is_card_checklists_notifications_enabled'] = IS_CARD_CHECKLISTS_NOTIFICATIONS_ENABLED;
            $r_post['is_card_attachments_notifications_enabled'] = IS_CARD_ATTACHMENTS_NOTIFICATIONS_ENABLED;
            if (is_plugin_enabled('r_chat') && $jabberHost) {
                xmppRegisterUser($r_post);
            }
            if (!empty($sql)) {
                $post = getbindValues($table_name, $r_post);
                $result = pg_execute_insert($table_name, $post);
                if ($result) {
                    $row = pg_fetch_assoc($result);
                    $response['id'] = $row['id'];
                    $val_arr = array(
                        3,
                        'user_activation'
                    );
                    $activation_permission = executeQuery('SELECT * FROM acl_links al left join acl_links_roles alr on alr.acl_link_id = al.id where alr.role_id = $1 and slug = $2', $val_arr);
                    if ($activation_permission) {
                        $response['activation'] = 0;
                        if ($is_return_vlaue) {
                            $row = convertBooleanValues($table_name, $row);
                            $response[$table_name] = $row;
                        }
                        if (!empty($uuid)) {
                            $response['uuid'] = $uuid;
                        }
                        $emailFindReplace['##NAME##'] = $r_post['full_name'];
                        $emailFindReplace['##ACTIVATION_URL##'] = $_server_domain_url . '/#/users/activation/' . $row['id'] . '/' . md5($r_post['username']);
                        sendMail('activation', $emailFindReplace, $r_post['email']);
                    } else {
                        $response['activation'] = 1;
                        $qry_val_arr = array(
                            'true',
                            'true',
                            $response['id']
                        );
                        $sql = pg_query_params($db_lnk, "UPDATE users SET is_email_confirmed = $1, is_active = $2 WHERE id = $3", $qry_val_arr);
                        $emailFindReplace = array(
                            '##NAME##' => $r_post['full_name'],
                        );
                        sendMail('welcome', $emailFindReplace, $r_post['email']);
                    }
                }
            }
        } else {
            $msg = '';
            if ($user['email'] == $r_post['email']) {
                $msg = 1;
            } else if ($user['username'] == $r_post['username']) {
                $msg = 2;
            }
            $response = array(
                'error' => $msg
            );
        }
        echo json_encode($response);
        break;

    case '/users/invite': //User invite
        $table_name = 'users';
        $val_arr = array(
            $r_post['email']
        );
        $user = executeQuery('SELECT * FROM users WHERE email = $1', $val_arr);
        if (!$user) {
            $sql = true;
            $table_name = 'users';
            $r_post['role_id'] = 2; // user
            $r_post['initials'] = strtoupper(substr($r_post['full_name'], 0, 1));
            $r_post['ip_id'] = saveIp();
            $r_post['is_invite_from_board'] = true;
            $r_post['username'] = slugify($r_post['full_name']);
            $r_post['password'] = getCryptHash('restya');
            $default_email_notification = 0;
            if (DEFAULT_EMAIL_NOTIFICATION === 'Periodically') {
                $default_email_notification = 1;
            } else if (DEFAULT_EMAIL_NOTIFICATION === 'Instantly') {
                $default_email_notification = 2;
            } else if (DEFAULT_EMAIL_NOTIFICATION === 'Daily') {
                $default_email_notification = 3;
            } else if (DEFAULT_EMAIL_NOTIFICATION === 'Weekly') {
                $default_email_notification = 4;
            }
            $r_post['is_send_newsletter'] = $default_email_notification;
            $r_post['default_desktop_notification'] = (DEFAULT_DESKTOP_NOTIFICATION === 'Enabled') ? 'true' : 'false';
            $r_post['is_list_notifications_enabled'] = IS_LIST_NOTIFICATIONS_ENABLED;
            $r_post['is_card_notifications_enabled'] = IS_CARD_NOTIFICATIONS_ENABLED;
            $r_post['is_card_members_notifications_enabled'] = IS_CARD_MEMBERS_NOTIFICATIONS_ENABLED;
            $r_post['is_card_labels_notifications_enabled'] = IS_CARD_LABELS_NOTIFICATIONS_ENABLED;
            $r_post['is_card_checklists_notifications_enabled'] = IS_CARD_CHECKLISTS_NOTIFICATIONS_ENABLED;
            $r_post['is_card_attachments_notifications_enabled'] = IS_CARD_ATTACHMENTS_NOTIFICATIONS_ENABLED;
            if (is_plugin_enabled('r_chat') && $jabberHost) {
                xmppRegisterUser($r_post);
            }
            if (!empty($sql)) {
                $post = getbindValues($table_name, $r_post);
                $result = pg_execute_insert($table_name, $post);
                if ($result) {
                    $row = pg_fetch_assoc($result);
                    $response['id'] = $row['id'];
                    $emailFindReplace = array(
                        '##NAME##' => $r_post['full_name'],
                        '##CURRENT_USER##' => $authUser['full_name'],
                        '##BOARD_NAME##' => $r_post['board_name'],
                        '##BOARD_URL##' => $_server_domain_url . '/#/board/' . $r_post['board_id'],
                        '##REGISTRATION_URL##' => $_server_domain_url . '/#/users/register'
                    );
                    sendMail('new_project_user_invite', $emailFindReplace, $r_post['email']);
                }
            }
        } else {
            $response = array(
                'error' => 'Email address already exist'
            );
        }
        echo json_encode($response);
        break;

    case '/users/register': //users register
        $table_name = 'users';
        $val_arr = array(
            $r_post['username'],
            $r_post['email']
        );
        $user = executeQuery('SELECT * FROM users_listing WHERE (username = $1 AND username<>\'\') OR (email = $2 AND email<>\'\')', $val_arr);
        if (!$user) {
            $sql = true;
            $table_name = 'users';
            $r_post['password'] = getCryptHash($r_post['password']);
            $r_post['role_id'] = 2; // user
            $r_post['initials'] = strtoupper(substr($r_post['username'], 0, 1));
            $r_post['ip_id'] = saveIp();
            $r_post['full_name'] = ($r_post['email'] == '') ? $r_post['username'] : email2name($r_post['email']);
            $default_email_notification = 0;
            if (DEFAULT_EMAIL_NOTIFICATION === 'Periodically') {
                $default_email_notification = 1;
            } else if (DEFAULT_EMAIL_NOTIFICATION === 'Instantly') {
                $default_email_notification = 2;
            } else if (DEFAULT_EMAIL_NOTIFICATION === 'Daily') {
                $default_email_notification = 3;
            } else if (DEFAULT_EMAIL_NOTIFICATION === 'Weekly') {
                $default_email_notification = 4;
            }
            $r_post['is_send_newsletter'] = $default_email_notification;
            $r_post['default_desktop_notification'] = (DEFAULT_DESKTOP_NOTIFICATION === 'Enabled') ? 'true' : 'false';
            $r_post['is_list_notifications_enabled'] = IS_LIST_NOTIFICATIONS_ENABLED;
            $r_post['is_card_notifications_enabled'] = IS_CARD_NOTIFICATIONS_ENABLED;
            $r_post['is_card_members_notifications_enabled'] = IS_CARD_MEMBERS_NOTIFICATIONS_ENABLED;
            $r_post['is_card_labels_notifications_enabled'] = IS_CARD_LABELS_NOTIFICATIONS_ENABLED;
            $r_post['is_card_checklists_notifications_enabled'] = IS_CARD_CHECKLISTS_NOTIFICATIONS_ENABLED;
            $r_post['is_card_attachments_notifications_enabled'] = IS_CARD_ATTACHMENTS_NOTIFICATIONS_ENABLED;
            if (is_plugin_enabled('r_chat') && !empty($jabberHost)) {
                xmppRegisterUser($r_post);
            }
            if (!empty($sql)) {
                $post = getbindValues($table_name, $r_post);
                $result = pg_execute_insert($table_name, $post);
                if ($result) {
                    $row = pg_fetch_assoc($result);
                    $response['id'] = $row['id'];
                    $val_arr = array(
                        3,
                        'user_activation'
                    );
                    $activation_permission = executeQuery('SELECT * FROM acl_links al left join acl_links_roles alr on alr.acl_link_id = al.id where alr.role_id = $1 and slug = $2', $val_arr);
                    if ($activation_permission) {
                        $response['activation'] = 0;
                        if ($is_return_vlaue) {
                            $row = convertBooleanValues($table_name, $row);
                            $response[$table_name] = $row;
                        }
                        if (!empty($uuid)) {
                            $response['uuid'] = $uuid;
                        }
                        $emailFindReplace['##NAME##'] = $r_post['full_name'];
                        $emailFindReplace['##ACTIVATION_URL##'] = $_server_domain_url . '/#/users/activation/' . $row['id'] . '/' . md5($r_post['username']);
                        sendMail('activation', $emailFindReplace, $r_post['email']);
                    } else {
                        $response['activation'] = 1;
                        $qry_val_arr = array(
                            'true',
                            'true',
                            $response['id']
                        );
                        $sql = pg_query_params($db_lnk, "UPDATE users SET is_email_confirmed = $1, is_active = $2 WHERE id = $3", $qry_val_arr);
                        $emailFindReplace = array(
                            '##NAME##' => $r_post['full_name'],
                        );
                        sendMail('welcome', $emailFindReplace, $r_post['email']);
                    }
                }
            }
        } else {
            if ($user['is_invite_from_board'] == 't' && $user['is_active'] == 0 && $user['is_email_confirmed'] == 0) {
                $r_post['password'] = getCryptHash($r_post['password']);
                $qry_val_arr = array(
                    'true',
                    'true',
                    $r_post['username'],
                    getCryptHash($r_post['password']) ,
                    $user['id']
                );
                $sql = pg_query_params($db_lnk, "UPDATE users SET is_email_confirmed = $1, is_active = $2, username = $3, password = $4 WHERE id = $5", $qry_val_arr);
                $emailFindReplace = array(
                    '##NAME##' => $user['full_name'],
                );
                sendMail('welcome', $emailFindReplace, $r_post['email']);
                $response['activation'] = 1;
                $response['id'] = $user['id'];
            } else {
                $msg = '';
                if ($user['email'] == $r_post['email']) {
                    $msg = 1;
                } else if ($user['username'] == $r_post['username']) {
                    $msg = 2;
                }
                $response = array(
                    'error' => $msg
                );
            }
        }
        echo json_encode($response);
        break;

    case '/users/login': //users login
        $table_name = 'users';
        $val_arr = array(
            $r_post['email']
        );
        if (filter_var($r_post['email'], FILTER_VALIDATE_EMAIL) !== false) {
            $where = 'LOWER(email) = LOWER($1)';
        } else {
            $where = 'LOWER(username)=LOWER($1)';
        }
        $log_user = executeQuery('SELECT id, role_id, password, is_ldap::boolean::int FROM users WHERE ' . $where, $val_arr);
        if (is_plugin_enabled('r_ldap_login')) {
            require_once PLUGIN_PATH . DS . 'LdapLogin' . DS . 'functions.php';
            $ldap_response = ldapUpdateUser($log_user, $r_post);
            $ldap_error = $ldap_response['ldap_error'];
            $user = $ldap_response['user'];
        }
        if (is_plugin_enabled('r_multiple_ldap_login')) {
            require_once PLUGIN_PATH . DS . 'MultipleLdapLogin' . DS . 'functions.php';
            $ldap_response = ldapUpdateUser($log_user, $r_post);
            $ldap_error = $ldap_response['ldap_error'];
            $user = $ldap_response['user'];
        }
        if (!empty($log_user) && $log_user['is_ldap'] == 0) {
            $r_post['password'] = crypt($r_post['password'], $log_user['password']);
            $val_arr = array(
                $r_post['email'],
                $r_post['password'],
                1
            );
            $user = executeQuery('SELECT * FROM users_listing WHERE ' . $where . ' AND password = $2 AND is_active = $3', $val_arr);
        }
        if (!empty($user)) {
            if (!IS_TWO_FACTOR_AUTHENTICATION_ENABLED || $user['is_two_factor_authentication_enabled'] == 'f' || ($user['is_two_factor_authentication_enabled'] == 't' && !empty($r_post['verification_code']))) {
                $is_provide_access_token = false;
                if (!empty($r_post['verification_code'])) {
                    $qry_val_arr = array(
                        $user['id']
                    );
                    $s_result = pg_query_params($db_lnk, 'SELECT two_factor_authentication_hash FROM users WHERE id = $1', $qry_val_arr);
                    $row = pg_fetch_assoc($s_result);
                    $ga = new PHPGangsta_GoogleAuthenticator();
                    $r_post['verification_code'] = (string)$r_post['verification_code'];
                    $checkResult = $ga->verifyCode($row['two_factor_authentication_hash'], $r_post['verification_code'], 2);
                    if ($checkResult) {
                        $is_provide_access_token = true;
                    }
                } else {
                    $is_provide_access_token = true;
                }
                if ($is_provide_access_token) {
                    if (is_plugin_enabled('r_ldap_login') || is_plugin_enabled('r_multiple_ldap_login')) {
                        $login_type_id = 1;
                    } else {
                        $login_type_id = 2;
                    }
                    $last_login_ip_id = saveIp();
                    $val_arr = array(
                        $login_type_id,
                        $last_login_ip_id,
                        $user['id']
                    );
                    pg_query_params($db_lnk, 'UPDATE users SET last_login_date = now(), login_type_id = $1, last_login_ip_id = $2 WHERE id = $3', $val_arr);
                    unset($user['password']);
                    $user_agent = !empty($_SERVER['HTTP_USER_AGENT']) ? $_SERVER['HTTP_USER_AGENT'] : '';
                    $val_arr = array(
                        $user['id'],
                        $last_login_ip_id,
                        $user_agent
                    );
                    pg_query_params($db_lnk, 'INSERT INTO user_logins (created, modified, user_id, ip_id, user_agent) VALUES (now(), now(), $1, $2, $3)', $val_arr);
                    $conditions = array(
                        true
                    );
                    $role_val_arr = array(
                        $user['role_id']
                    );
                    $role_links = executeQuery('SELECT links FROM role_links_listing WHERE id = $1', $role_val_arr);
                    $post_val = array(
                        'grant_type' => 'password',
                        'username' => $user['username'],
                        'password' => $r_post['password'],
                        'client_id' => OAUTH_CLIENTID,
                        'client_secret' => OAUTH_CLIENT_SECRET,
                        'scope' => 'read write'
                    );
                    $response = getToken($post_val);
                    $response = array_merge($role_links, $response);
                    $board_ids = array();
                    if (!empty($user['boards_users'])) {
                        $boards_users = json_decode($user['boards_users'], true);
                        foreach ($boards_users as $boards_user) {
                            $board_ids[] = $boards_user['board_id'];
                        }
                    }
                    $notify_val_arr = array(
                        $user['last_activity_id'],
                        '{' . implode(',', $board_ids) . '}'
                    );
                    $notify_count = executeQuery('SELECT max(id) AS last_activity_id, count(a.*) AS notify_count FROM activities a  WHERE a.id > $1 AND board_id = ANY ($2) ', $notify_val_arr);
                    $notify_count['last_activity_id'] = (!empty($notify_count['last_activity_id'])) ? $notify_count['last_activity_id'] : $user['last_activity_id'];
                    $user = array_merge($user, $notify_count);
                    $response['user'] = $user;
                    $response['user']['organizations'] = json_decode($user['organizations'], true);
                } else {
                    $response = array(
                        'code' => 'verification_code',
                        'error' => 'Entered verification code is wrong. Please try again.'
                    );
                }
            } else {
                $response = array(
                    'code' => 'enter_verification_code',
                    'success' => 'User authenticated successfully'
                );
            }
        } else {
            $last_login_ip_id = saveIp();
            $user_agent = !empty($_SERVER['HTTP_USER_AGENT']) ? $_SERVER['HTTP_USER_AGENT'] : '';
            if (!empty($log_user)) {
                $val_arr = array(
                    $log_user['id'],
                    $last_login_ip_id,
                    $user_agent,
                    't'
                );
                pg_query_params($db_lnk, 'INSERT INTO user_logins (created, modified, user_id, ip_id, user_agent, is_login_failed) VALUES (now(), now(), $1, $2, $3, $4)', $val_arr);
            }
            // login failed error logged
            $login_fail_string = date('Y-m-d H:i:s') . '|' . $last_login_ip_id . '|' . $r_post['email'] . '|' . $user_agent;
            error_log($login_fail_string . PHP_EOL, 3, CACHE_PATH . DS . 'user_logins_failed.log');
            if (!empty($ldap_error)) {
                $response = array(
                    'code' => 'LDAP',
                    'error' => $ldap_error
                );
            } else {
                $response = array(
                    'code' => 'email',
                    'error' => 'Sorry, login failed. Either your username or password are incorrect or admin deactivated your account.'
                );
            }
        }
        echo json_encode($response);
        break;

    case '/users/?/adminchangepassword':
        $qry_val_array = array(
            $r_resource_vars['users']
        );
        if (!isset($r_post['password'])) {
            $response = array(
                'error' => 'Password is required.'
            );
        } else if (!isset($r_post['confirm_password'])) {
            $response = array(
                'error' => 'Confirm password is required.'
            );
        } else if (empty($r_post['password'])) {
            $response = array(
                'error' => 'Passwords can\'t be empty.'
            );
        } else if ($r_post['confirm_password'] == $r_post['password']) {
            $user = executeQuery('SELECT * FROM users WHERE id = $1', $qry_val_array);
            if ($user) {
                $res_val_arr = array(
                    getCryptHash($r_post['password']) ,
                    $r_resource_vars['users']
                );
                pg_query_params($db_lnk, 'UPDATE users SET password = $1 WHERE id = $2', $res_val_arr);
                if (is_plugin_enabled('r_chat') && $jabberHost) {
                    xmppChangePassword($r_post, $user);
                }
                if ($authUser['role_id'] == 1) {
                    $emailFindReplace = array(
                        '##PASSWORD##' => 'Please contact your administrator for your new password.'
                    );
                    sendMail('changepassword', $emailFindReplace, $user['email']);
                    $response = array(
                        'success' => 'Password change successfully.'
                    );
                }
            } else {
                $response = array(
                    'error' => 1
                );
            }
        } else {
            $response = array(
                'error' => 2
            );
        }
        echo json_encode($response);
        break;

    case '/users/?/changepassword':
        $qry_val_array = array(
            $r_resource_vars['users']
        );
        if (!isset($r_post['old_password']) && ($authUser['role_id'] == 2)) {
            $response = array(
                'error' => 'Old password is required.'
            );
        } else if (!isset($r_post['password'])) {
            $response = array(
                'error' => 'Password is required.'
            );
        } else if (!isset($r_post['confirm_password'])) {
            $response = array(
                'error' => 'Confirm password is required.'
            );
        } else if ((empty($r_post['old_password']) && ($authUser['role_id'] == 2)) || empty($r_post['password']) || empty($r_post['confirm_password'])) {
            $response = array(
                'error' => 'Passwords can\'t be empty.'
            );
        } else if ($r_post['confirm_password'] == $r_post['password']) {
            $user = executeQuery('SELECT * FROM users WHERE id = $1', $qry_val_array);
            if ($user['id'] != $authUser['id']) {
                header($_SERVER['SERVER_PROTOCOL'] . ' 401 Unauthorized', true, 401);
            } else {
                if ($user) {
                    $cry_old_pass = crypt($r_post['old_password'], $user['password']);
                    if ((($authUser['role_id'] == 2) && ($user['password'] == $cry_old_pass)) || ($authUser['role_id'] == 1)) {
                        $res_val_arr = array(
                            getCryptHash($r_post['password']) ,
                            $r_resource_vars['users']
                        );
                        pg_query_params($db_lnk, 'UPDATE users SET password = $1 WHERE id = $2', $res_val_arr);
                        if (is_plugin_enabled('r_chat') && $jabberHost) {
                            xmppChangePassword($r_post, $user);
                        }
                        $conditions = array(
                            $authUser['username']
                        );
                        pg_query_params($db_lnk, 'DELETE FROM oauth_access_tokens WHERE user_id= $1', $conditions);
                        pg_query_params($db_lnk, 'DELETE FROM oauth_refresh_tokens WHERE user_id= $1', $conditions);
                        if ($authUser['role_id'] == 1) {
                            $emailFindReplace = array(
                                '##PASSWORD##' => 'should be known to you already. If not, please use the password reset function to generate a one-time password, and then reset it again.'
                            );
                            sendMail('changepassword', $emailFindReplace, $user['email']);
                            $response = array(
                                'success' => 'Password change successfully. Please login.'
                            );
                        }
                    } else {
                        $response = array(
                            'error' => 1
                        );
                    }
                } else {
                    $response = array(
                        'error' => 2
                    );
                }
            }
        } else {
            $response = array(
                'error' => 3
            );
        }
        echo json_encode($response);
        break;

    case '/users/?':
        $is_return_vlaue = true;
        $profile_picture_path = 'null';
        $no_error = true;
        $msg = '';
        if (!empty($_FILES['attachment']['name']) && $_FILES['attachment']['error'] == 0) {
            $allowed_ext = array(
                'gif',
                'png',
                'jpg',
                'jpeg',
                'bmp'
            );
            $filename = $_FILES['attachment']['name'];
            $file_ext = pathinfo($filename, PATHINFO_EXTENSION);
            if (in_array($file_ext, $allowed_ext)) {
                $mediadir = MEDIA_PATH . DS . 'User' . DS . $r_resource_vars['users'];
                $save_path = 'User' . DS . $r_resource_vars['users'];
                if (!file_exists($mediadir)) {
                    mkdir($mediadir, 0777, true);
                }
                $file = $_FILES['attachment'];
                $file['name'] = preg_replace('/[^A-Za-z0-9\-.]/', '', $file['name']);
                if (is_uploaded_file($file['tmp_name']) && move_uploaded_file($file['tmp_name'], $mediadir . DS . $file['name'])) {
                    $profile_picture_path = $save_path . DS . $file['name'];
                    foreach ($thumbsizes['User'] as $key => $value) {
                        $mediadir = IMG_PATH . DS . $key . DS . 'User' . DS . $r_resource_vars['users'];
                        $list = glob($mediadir . '.*');
                        if (!empty($list) && isset($list[0]) && file_exists($list[0])) {
                            unlink($list[0]);
                        }
                    }
                    $authUser['profile_picture_path'] = $profile_picture_path;
                    $response['profile_picture_path'] = $profile_picture_path;
                    $comment = '##USER_NAME## updated the profile image';
                    $foreign_ids['user_id'] = $r_resource_vars['users'];
                    $response['activity'] = insertActivity($r_resource_vars['users'], $comment, 'update_profile_attachment', $foreign_ids);
                }
                $qry_val_arr = array(
                    $profile_picture_path,
                    $r_resource_vars['users']
                );
                pg_query_params($db_lnk, 'UPDATE users SET profile_picture_path = $1 WHERE id = $2', $qry_val_arr);
            } else {
                $no_error = false;
                $msg = 1;
            }
        } else {
            if (!empty($_POST['email'])) {
                $usr_val_arr = array(
                    $_POST['email']
                );
                $user = executeQuery('SELECT * FROM users WHERE email = $1', $usr_val_arr);
                if ($user['id'] != $r_resource_vars['users'] && $user['email'] == $_POST['email']) {
                    $no_error = false;
                    $msg = 2;
                }
            }
            if (!empty($_POST['username'])) {
                $usr_val_arr = array(
                    $_POST['username']
                );
                $user = executeQuery('SELECT * FROM users WHERE username = $1', $usr_val_arr);
                if ($user['id'] != $r_resource_vars['users'] && $user['username'] == $_POST['username']) {
                    $no_error = false;
                    $msg = 3;
                }
            }
            if ($no_error && ($authUser['role_id'] == 1 || $authUser['id'] == $r_resource_vars['users'])) {
                $qry_val_arr = array(
                    (isset($_POST['default_desktop_notification']) && $_POST['default_desktop_notification'] === 'Enabled') ? 'true' : 'false',
                    (isset($_POST['is_list_notifications_enabled'])) ? 'true' : 'false',
                    (isset($_POST['is_card_notifications_enabled'])) ? 'true' : 'false',
                    (isset($_POST['is_card_members_notifications_enabled'])) ? 'true' : 'false',
                    (isset($_POST['is_card_labels_notifications_enabled'])) ? 'true' : 'false',
                    (isset($_POST['is_card_checklists_notifications_enabled'])) ? 'true' : 'false',
                    (isset($_POST['is_card_attachments_notifications_enabled'])) ? 'true' : 'false',
                    $r_resource_vars['users']
                );
                pg_query_params($db_lnk, 'UPDATE users SET default_desktop_notification= $1, is_list_notifications_enabled= $2, is_card_notifications_enabled= $3, is_card_members_notifications_enabled= $4, is_card_labels_notifications_enabled= $5, is_card_checklists_notifications_enabled= $6, is_card_attachments_notifications_enabled= $7 WHERE id = $8', $qry_val_arr);
                unset($_POST['default_desktop_notification']);
                unset($_POST['is_list_notifications_enabled']);
                unset($_POST['is_card_notifications_enabled']);
                unset($_POST['is_card_members_notifications_enabled']);
                unset($_POST['is_card_labels_notifications_enabled']);
                unset($_POST['is_card_checklists_notifications_enabled']);
                unset($_POST['is_card_attachments_notifications_enabled']);
                $comment = '##USER_NAME## updated the profile.';
                $foreign_ids['user_id'] = $authUser['id'];
                $table_name = 'users';
                $id = $r_resource_vars['users'];
                $put = getbindValues($table_name, $_POST);
                if ($table_name == 'users') {
                    unset($put['ip_id']);
                }
                $sfields = '';
                foreach ($put as $key => $value) {
                    if ($key != 'is_send_newsletter') {
                        if ($key != 'id') {
                            $fields.= ', ' . $key;
                        }
                        if ($key != 'id' && $key != 'position') {
                            $sfields.= (empty($sfields)) ? $key : ", " . $key;
                        }
                    }
                }
                if (!empty($comment)) {
                    $qry_va_arr = array(
                        $id
                    );
                    $revisions['old_value'] = executeQuery('SELECT ' . $sfields . ' FROM ' . $table_name . ' WHERE id =  $1', $qry_va_arr);
                    /* unset($revisions['old_value']['is_send_newsletter']);
                     unset($_POST['is_send_newsletter']); */
                    $temp_revisions = array_diff($revisions['old_value'], $_POST);
                    foreach ($temp_revisions as $key => $value) {
                        $revisions['new_value'][$key] = (isset($_POST[$key])) ? $_POST[$key] : '';
                    }
                    $revision = serialize($revisions);
                    $foreign_id = $id;
                    if (!empty($temp_revisions)) {
                        $response['activity'] = insertActivity($authUser['id'], $comment, 'update_profile', $foreign_ids, $revision, $foreign_id);
                    } else {
                        $response['activity'] = '';
                    }
                    if (!empty($response['activity']['revisions']) && trim($response['activity']['revisions']) != '') {
                        $revisions = unserialize($response['activity']['revisions']);
                    }
                    if (!empty($revisions)) {
                        if (!empty($revisions['new_value'])) {
                            foreach ($revisions['new_value'] as $key => $value) {
                                $old_val = (isset($revisions['old_value'][$key])) ? $revisions['old_value'][$key] : '';
                                $new_val = (isset($revisions['new_value'][$key])) ? $revisions['new_value'][$key] : '';
                                $diff[] = nl2br(getRevisiondifference($old_val, $new_val));
                            }
                        }
                    }
                    if (isset($diff)) {
                        $response['activity']['difference'] = $diff;
                    }
                }
                if (!empty($_POST['full_name'])) {
                    $qry_val_arr = array(
                        $_POST['full_name'],
                        $r_resource_vars['users']
                    );
                    pg_query_params($db_lnk, 'UPDATE users SET full_name= $1 WHERE id = $2', $qry_val_arr);
                }
                if (!empty($_POST['about_me'])) {
                    $qry_val_arr = array(
                        $_POST['about_me'],
                        $r_resource_vars['users']
                    );
                    pg_query_params($db_lnk, 'UPDATE users SET about_me= $1 WHERE id = $2', $qry_val_arr);
                }
                if (!empty($_POST['initials'])) {
                    $qry_val_arr = array(
                        strtoupper($_POST['initials']) ,
                        $r_resource_vars['users']
                    );
                    pg_query_params($db_lnk, 'UPDATE users SET initials= $1 WHERE id = $2', $qry_val_arr);
                }
                if (!empty($_POST['timezone'])) {
                    $qry_val_arr = array(
                        $_POST['timezone'],
                        $r_resource_vars['users']
                    );
                    pg_query_params($db_lnk, 'UPDATE users SET timezone= $1 WHERE id = $2', $qry_val_arr);
                }
                if (isset($_POST['is_send_newsletter'])) {
                    $qry_val_arr = array(
                        $_POST['is_send_newsletter'],
                        $r_resource_vars['users']
                    );
                    pg_query_params($db_lnk, 'UPDATE users SET is_send_newsletter= $1 WHERE id = $2', $qry_val_arr);
                }
                if (!empty($_POST['email'])) {
                    $qry_val_arr = array(
                        $_POST['email'],
                        $r_resource_vars['users']
                    );
                    pg_query_params($db_lnk, 'UPDATE users SET email= $1 WHERE id = $2', $qry_val_arr);
                }
                if (!empty($r_post['is_intro_video_skipped'])) {
                    $qry_val_arr = array(
                        $r_post['is_intro_video_skipped'],
                        $r_resource_vars['users']
                    );
                    pg_query_params($db_lnk, 'UPDATE users SET is_intro_video_skipped= $1 WHERE id = $2', $qry_val_arr);
                }
                if (!empty($_POST['username'])) {
                    $qry_val_arr = array(
                        $r_resource_vars['users']
                    );
                    $user = executeQuery('SELECT username FROM users WHERE id = $1', $qry_val_arr);
                    $qry_val_arr = array(
                        $_POST['username'],
                        $r_resource_vars['users']
                    );
                    pg_query_params($db_lnk, 'UPDATE users SET username= $1 WHERE id = $2', $qry_val_arr);
                    $conditions = array(
                        $_POST['username'],
                        $user['username']
                    );
                    pg_query_params($db_lnk, 'UPDATE oauth_access_tokens set user_id = $1 WHERE user_id= $2', $conditions);
                    pg_query_params($db_lnk, 'UPDATE oauth_refresh_tokens set user_id = $1 WHERE user_id= $2', $conditions);
                }
                if (!empty($response['activity']['id'])) {
                    $qry_val_arr = array(
                        $response['activity']['id']
                    );
                    $new_activity = pg_query_params($db_lnk, 'SELECT * FROM activities_listing WHERE id = $1', $qry_val_arr);
                    $response['activity'] = pg_fetch_assoc($new_activity);
                }
            } else {
                $response['error']['message'] = 'Unauthorized';
                header($_SERVER['SERVER_PROTOCOL'] . ' 401 Unauthorized', true, 401);
            }
        }
        if ($no_error) {
            $response['success'] = 'User Profile has been updated.';
        } else {
            $response['error'] = $msg;
        }
        echo json_encode($response);
        break;

    case '/settings': //settings update
        foreach ($r_post as $key => $value) {
            if ($key == 'IMAP_EMAIL_PASSWORD' || strpos($key, 'PASSWORD') !== false) {
                if (!empty($value)) {
                    $value_encode = str_rot13($value);
                    $value = base64_encode($value_encode);
                } else {
                    break;
                }
            }
            $qry_val_arr = array(
                $value,
                trim($key)
            );
            pg_query_params($db_lnk, 'UPDATE settings SET value = $1 WHERE name = $2', $qry_val_arr);
        }
        $response = array(
            'success' => 'Settings updated successfully.'
        );
        echo json_encode($response);
        break;

    case '/boards': //boards add
        if (!empty($_FILES['board_import'])) {
            if ($_FILES['board_import']['error'] == 0) {
                $get_files = file_get_contents($_FILES['board_import']['tmp_name']);
                $utf8_encoded_content = utf8_encode($get_files);
                if (version_compare(phpversion() , '5.4.0', '<')) {
                    $imported_board = json_decode($utf8_encoded_content, true, 512);
                } else {
                    $imported_board = json_decode($utf8_encoded_content, true, 512, JSON_UNESCAPED_UNICODE);
                }
                if (!empty($imported_board) && !empty($imported_board['prefs'])) {
                    $board = importTrelloBoard($imported_board);
                    $response['id'] = $board['id'];
                } else {
                    $response['error'] = 'Invalid file format. Upload json file';
                }
            } else {
                $response['error'] = 'Unable to import. please try again.';
            }
        } elseif (!empty($_FILES['board_import_wekan'])) {
            if ($_FILES['board_import_wekan']['error'] == 0) {
                $get_files = file_get_contents($_FILES['board_import_wekan']['tmp_name']);
                $utf8_encoded_content = utf8_encode($get_files);
                if (version_compare(phpversion() , '5.4.0', '<')) {
                    $imported_board = json_decode($utf8_encoded_content, true, 512);
                } else {
                    $imported_board = json_decode($utf8_encoded_content, true, 512, JSON_UNESCAPED_UNICODE);
                }
                if (!empty($imported_board)) {
                    $board = importWekanBoard($imported_board);
                    $response['id'] = $board['id'];
                } else {
                    $response['error'] = 'Invalid file format. Upload json file';
                }
            } else {
                $response['error'] = 'Unable to import. please try again.';
            }
        } elseif (!empty($_FILES['board_import_kantree'])) {
            if ($_FILES['board_import_kantree']['error'] == 0) {
                $get_files = file_get_contents($_FILES['board_import_kantree']['tmp_name']);
                $utf8_encoded_content = utf8_encode($get_files);
                if (version_compare(phpversion() , '5.4.0', '<')) {
                    $imported_board = json_decode($utf8_encoded_content, true, 512);
                } else {
                    $imported_board = json_decode($utf8_encoded_content, true, 512, JSON_UNESCAPED_UNICODE);
                }
                if (!empty($imported_board)) {
                    $board = importKantreeBoard($imported_board);
                    $response['id'] = $board['id'];
                } else {
                    $response['error'] = 'Invalid file format. Upload json file';
                }
            } else {
                $response['error'] = 'Unable to import. please try again.';
            }
        } elseif (!empty($_FILES['board_import_taiga'])) {
            if ($_FILES['board_import_taiga']['error'] == 0) {
                $get_files = file_get_contents($_FILES['board_import_taiga']['tmp_name']);
                $utf8_encoded_content = utf8_encode($get_files);
                if (version_compare(phpversion() , '5.4.0', '<')) {
                    $imported_board = json_decode($utf8_encoded_content, true, 512);
                } else {
                    $imported_board = json_decode($utf8_encoded_content, true, 512, JSON_UNESCAPED_UNICODE);
                }
                if (!empty($imported_board)) {
                    $board = importTaigaBoard($imported_board);
                    $response['id'] = $board['id'];
                } else {
                    $response['error'] = 'Invalid file format. Upload json file';
                }
            } else {
                $response['error'] = 'Unable to import. please try again.';
            }
        } elseif (!empty($_FILES['board_import_asana'])) {
            if ($_FILES['board_import_asana']['error'] == 0) {
                $get_files = file_get_contents($_FILES['board_import_asana']['tmp_name']);
                $utf8_encoded_content = utf8_encode($get_files);
                if (version_compare(phpversion() , '5.4.0', '<')) {
                    $imported_board = json_decode($utf8_encoded_content, true, 512);
                } else {
                    $imported_board = json_decode($utf8_encoded_content, true, 512, JSON_UNESCAPED_UNICODE);
                }
                if (!empty($imported_board)) {
                    $board = importAsanaBoard($imported_board['data']);
                    $response['id'] = $board['id'];
                } else {
                    $response['error'] = 'Invalid file format. Upload json file';
                }
            } else {
                $response['error'] = 'Unable to import. please try again.';
            }
        } elseif (!empty($_FILES['board_import_taskwarrior'])) {
            if ($_FILES['board_import_taskwarrior']['error'] == 0) {
                $get_files = file_get_contents($_FILES['board_import_taskwarrior']['tmp_name']);
                $utf8_encoded_content = utf8_encode($get_files);
                if (version_compare(phpversion() , '5.4.0', '<')) {
                    $imported_board = json_decode($utf8_encoded_content, true, 512);
                } else {
                    $imported_board = json_decode($utf8_encoded_content, true, 512, JSON_UNESCAPED_UNICODE);
                }
                if (!empty($imported_board)) {
                    $board = importTaskWarriorBoard($imported_board);
                    $response['id'] = $board['id'];
                } else {
                    $response['error'] = 'Invalid file format. Upload json file';
                }
            } else {
                $response['error'] = 'Unable to import. please try again.';
            }
        } elseif (!empty($_FILES['board_import_pipefy'])) {
            if ($_FILES['board_import_pipefy']['error'] == 0) {
                if ($_FILES['board_import_pipefy']['type'] === 'text/csv') {
                    $all_rows = array();
                    $imported_board = array();
                    if (($handle = fopen($_FILES['board_import_pipefy']['tmp_name'], "r")) !== false) {
                        $row = 1;
                        while (($data = fgetcsv($handle, 40000, ",")) !== false) {
                            if ($row > 1) {
                                $arrResult = array();
                                foreach ($data as $key => $value) {
                                    $arrResult[$all_rows[0][$key]] = $value;
                                };
                                $imported_board[] = $arrResult;
                            } else {
                                $all_rows[] = $data;
                            }
                            $row++;
                        }
                        if (!empty($imported_board)) {
                            $board = importpipefyBoard($imported_board);
                            $response['id'] = $board['id'];
                        } else {
                            $response['error'] = 'Invalid file format. Upload CSV file';
                        }
                    }
                    fclose($handle);
                } else {
                    $response['error'] = 'Invalid file format. Upload CSV file';
                }
            } else {
                $response['error'] = 'Unable to import. please try again.';
            }
        } else {
            $table_name = 'boards';
            $qry_val_arr = array(
                $r_post['name']
            );
            executeQuery('SELECT id, name FROM ' . $table_name . ' WHERE name = $1', $qry_val_arr);
            if (isset($r_post['template']) && !empty($r_post['template'])) {
                $lists = explode(',', $r_post['template']);
            }
            unset($r_post['template']);
            $sql = true;
            $r_post['user_id'] = (!empty($authUser['id'])) ? $authUser['id'] : 1;
        }
        if (!empty($sql)) {
            $post = getbindValues($table_name, $r_post);
            $auto_subscribe_on_board = (AUTO_SUBSCRIBE_ON_BOARD === 'Enabled') ? 'true' : false;
            $post['auto_subscribe_on_board'] = $auto_subscribe_on_board;
            $auto_subscribe_on_card = (AUTO_SUBSCRIBE_ON_CARD === 'Enabled') ? 'true' : false;
            $post['auto_subscribe_on_card'] = $auto_subscribe_on_card;
            $result = pg_execute_insert($table_name, $post);
            if ($result) {
                $row = pg_fetch_assoc($result);
                $response['id'] = $row['id'];
                $response['name'] = $row['name'];
                if ($is_return_vlaue) {
                    $row = convertBooleanValues($table_name, $row);
                    $response[$table_name] = $row;
                }
                if (!empty($uuid)) {
                    $response['uuid'] = $uuid;
                }
                if (is_plugin_enabled('r_chat') && $jabberHost) {
                    xmppCreateRoom($r_post, $response);
                }
                if (is_plugin_enabled('r_groups') && !empty($r_post['group_id'])) {
                    $condition = array(
                        $r_post['group_id'],
                        $r_post['user_id']
                    );
                    $groups_users = pg_query_params($db_lnk, 'SELECT user_id FROM groups_users WHERE group_id = $1 AND user_id != $2', $condition);
                    while ($groups_user = pg_fetch_assoc($groups_users)) {
                        if (!empty($groups_user)) {
                            $qry_val_arr = array(
                                $response['id'],
                                $groups_user['user_id']
                            );
                            pg_query_params($db_lnk, "INSERT INTO boards_users (created, modified, board_id , user_id, board_user_role_id) VALUES (now(), now(), $1, $2, '2')", $qry_val_arr);
                        }
                    }
                }
                if (!$is_import_board) {
                    $foreign_id['board_id'] = $response['id'];
                    $comment = '##USER_NAME## created board';
                    $qry_val_arr = array(
                        $row['id'],
                        $r_post['user_id']
                    );
                    $response['activity'] = insertActivity($authUser['id'], $comment, 'add_board', $foreign_id);
                    pg_query_params($db_lnk, 'INSERT INTO boards_users (created, modified, board_id , user_id, board_user_role_id) VALUES (now(), now(), $1, $2, 1)', $qry_val_arr);
                    $auto_subscribe_on_board = (AUTO_SUBSCRIBE_ON_BOARD === 'Enabled') ? 'true' : false;
                    if ($auto_subscribe_on_board) {
                        $qry_val_arr = array(
                            $row['id'],
                            $r_post['user_id'],
                            true
                        );
                        pg_query_params($db_lnk, 'INSERT INTO board_subscribers (created, modified, board_id , user_id, is_subscribed) VALUES (now(), now(), $1, $2, $3)', $qry_val_arr);
                    }
                    if (!empty($row['board_visibility']) && $row['board_visibility'] == 1 && !empty($r_post['organization_id'])) {
                        $qry_val_arr = array(
                            $r_post['organization_id']
                        );
                        $organization_users = pg_query_params($db_lnk, 'SELECT * FROM organizations_users WHERE organization_id = $1', $qry_val_arr);
                        while ($organization_user = pg_fetch_assoc($organization_users)) {
                            if (!empty($organization_user)) {
                                if ($organization_user['user_id'] != $row['user_id']) {
                                    $qry_val_arr = array(
                                        $row['id'],
                                        $organization_user['user_id']
                                    );
                                    $check_board_users = executeQuery('SELECT id FROM boards_users WHERE board_id = $1 and user_id = $2', $qry_val_arr);
                                    if (empty($check_board_users)) {
                                        pg_query_params($db_lnk, 'INSERT INTO boards_users (created, modified, board_id , user_id, board_user_role_id) VALUES (now(), now(), $1, $2, 2)', $qry_val_arr);
                                    }
                                    $auto_subscribe_on_board = (AUTO_SUBSCRIBE_ON_BOARD === 'Enabled') ? 'true' : false;
                                    if ($auto_subscribe_on_board) {
                                        $qry_val_arr = array(
                                            $row['id'],
                                            $organization_user['user_id'],
                                            true
                                        );
                                        pg_query_params($db_lnk, 'INSERT INTO board_subscribers (created, modified, board_id , user_id, is_subscribed) VALUES (now(), now(), $1, $2, $3)', $qry_val_arr);
                                    }
                                }
                            }
                        }
                    }
                    if (isset($lists) && !empty($lists)) {
                        $position = 1;
                        foreach ($lists as $list) {
                            $qry_val_arr = array(
                                $response['id'],
                                $list,
                                $authUser['id'],
                                $position
                            );
                            $s_sql = 'INSERT INTO lists (created, modified, board_id, name, user_id, position) VALUES (now(), now(), $1, $2, $3, $4) RETURNING id';
                            $result = pg_query_params($db_lnk, $s_sql, $qry_val_arr);
                            if ($position === 1) {
                                $result_response = pg_fetch_assoc($result);
                                $qry_val_arr = array(
                                    $result_response['id'],
                                    $response['id']
                                );
                                pg_query_params($db_lnk, 'UPDATE boards SET default_email_list_id = $1 WHERE id = $2', $qry_val_arr);
                            }
                            $position++;
                        }
                    }
                    $qry_val_arr = array(
                        $row['id']
                    );
                    $response['simple_board'] = executeQuery('SELECT row_to_json(d) FROM (SELECT * FROM simple_board_listing sbl WHERE id = $1 ORDER BY id ASC) as d', $qry_val_arr);
                    $response['simple_board'] = json_decode($response['simple_board']['row_to_json'], true);
                }
            }
        }
        echo json_encode($response);
        break;

    case '/boards/?/boards_stars': //stars add
        $table_name = 'board_stars';
        $qry_val_arr = array(
            $r_resource_vars['boards'],
            $authUser['id']
        );
        $subcriber = executeQuery('SELECT id, is_starred FROM ' . $table_name . ' WHERE board_id = $1 and user_id = $2', $qry_val_arr);
        if (!$subcriber) {
            $qry_val_arr = array(
                $r_resource_vars['boards'],
                $authUser['id']
            );
            $result = pg_query_params($db_lnk, 'INSERT INTO ' . $table_name . ' (created, modified, board_id, user_id, is_starred) VALUES (now(), now(), $1, $2, true) RETURNING id', $qry_val_arr);
            $star = pg_fetch_assoc($result);
            $response['id'] = $star['id'];
        } else {
            $conditions = array(
                $r_resource_vars['boards'],
                $authUser['id']
            );
            pg_query_params($db_lnk, 'DELETE FROM board_stars WHERE board_id = $1 AND user_id = $2', $conditions);
            $response['id'] = $subcriber['id'];
        }
        echo json_encode($response);
        break;

    case '/boards/?/board_subscribers': //subscriber add
        $table_name = 'board_subscribers';
        $qry_val_arr = array(
            $r_resource_vars['boards'],
            $authUser['id']
        );
        $subcriber = executeQuery('SELECT id, is_subscribed FROM ' . $table_name . ' WHERE board_id = $1 and user_id = $2', $qry_val_arr);
        if (!$subcriber) {
            $qry_val_arr = array(
                $r_resource_vars['boards'],
                $authUser['id']
            );
            $result = pg_query_params($db_lnk, 'INSERT INTO ' . $table_name . ' (created, modified, board_id, user_id, is_subscribed) VALUES (now(), now(), $1, $2, true) RETURNING *', $qry_val_arr);
        } else {
            if ($subcriber['is_subscribed'] == 1) {
                $qry_val_arr = array(
                    $r_resource_vars['boards'],
                    $authUser['id']
                );
                $result = pg_query_params($db_lnk, 'UPDATE ' . $table_name . ' SET is_subscribed = false Where  board_id = $1 and user_id = $2 RETURNING *', $qry_val_arr);
            } else {
                $qry_val_arr = array(
                    $r_resource_vars['boards'],
                    $authUser['id']
                );
                $result = pg_query_params($db_lnk, 'UPDATE ' . $table_name . ' SET is_subscribed = True Where  board_id = $1 and user_id = $2 RETURNING *', $qry_val_arr);
            }
        }
        $_response = pg_fetch_assoc($result);
        $response = convertBooleanValues($table_name, $_response);
        echo json_encode($response);
        break;

    case '/boards/?/copy': //boards copy
        $table_name = 'boards';
        $sql = true;
        $copied_board_id = $r_resource_vars['boards'];
        $board_visibility = $r_post['board_visibility'];
        if (!empty($r_post['organization_id'])) {
            $organization_id = $r_post['organization_id'];
        }
        $keepcards = false;
        if (!empty($r_post['keepCards'])) {
            $keepcards = true;
            unset($r_post['keepCards']);
        }
        $keepusers = false;
        if (!empty($r_post['keepUsers'])) {
            $keepusers = true;
            unset($r_post['keepUsers']);
        }
        $keeplabels = false;
        if (!empty($r_post['keepLabels'])) {
            $keeplabels = true;
            unset($r_post['keepLabels']);
        }
        $keepcomments = false;
        if (!empty($r_post['keepComments'])) {
            $keepcomments = true;
            unset($r_post['keepComments']);
        }
        $keepattachments = false;
        if (!empty($r_post['keepAttachments'])) {
            $keepattachments = true;
            unset($r_post['keepAttachments']);
        }
        $keepchecklists = false;
        if (!empty($r_post['keepChecklists'])) {
            $keepchecklists = true;
            unset($r_post['keepChecklists']);
        }
        $keepcustomFields = false;
        if (!empty($r_post['keepCustomFields'])) {
            $keepcustomFields = true;
            unset($r_post['keepCustomFields']);
        }
        $qry_val_arr = array(
            $copied_board_id
        );
        $sresult = pg_query_params($db_lnk, 'SELECT * FROM boards WHERE id = $1', $qry_val_arr);
        $srow = pg_fetch_assoc($sresult);
        unset($srow['id']);
        unset($srow['created']);
        unset($srow['modified']);
        unset($srow['user_id']);
        unset($srow['name']);
        if ($srow['commenting_permissions'] === null) {
            $srow['commenting_permissions'] = 0;
        }
        if ($srow['voting_permissions'] === null) {
            $srow['voting_permissions'] = 0;
        }
        if ($srow['inivitation_permissions'] === null) {
            $srow['inivitation_permissions'] = 0;
        }
        $r_post['user_id'] = $authUser['id'];
        $r_post = array_merge($r_post, $srow);
        $r_post['board_visibility'] = $board_visibility;
        if (!empty($organization_id)) {
            $r_post['organization_id'] = $organization_id;
        }
        if (!empty($sql)) {
            $post = getbindValues($table_name, $r_post);
            $result = pg_execute_insert($table_name, $post);
            if ($result) {
                $row = pg_fetch_assoc($result);
                $response['id'] = $row['id'];
                if ($is_return_vlaue) {
                    $row = convertBooleanValues($table_name, $row);
                    $response[$table_name] = $row;
                }
                if (!empty($uuid)) {
                    $response['uuid'] = $uuid;
                }
                $new_board_id = $row['id'];
                if ($keepusers) {
                    //Copy board users
                    $boards_user_fields = 'user_id, board_user_role_id';
                    $qry_val_arr = array(
                        $r_resource_vars['boards']
                    );
                    $boards_users = pg_query_params($db_lnk, 'SELECT id, ' . $boards_user_fields . ' FROM boards_users WHERE board_id = $1', $qry_val_arr);
                    if ($boards_users && pg_num_rows($boards_users)) {
                        $boards_user_fields = 'created, modified, board_id, ' . $boards_user_fields;
                        while ($boards_user = pg_fetch_object($boards_users)) {
                            $boards_user_values = array();
                            array_push($boards_user_values, 'now()', 'now()', $new_board_id);
                            foreach ($boards_user as $key => $value) {
                                if ($key != 'id') {
                                    if ($value === false) {
                                        array_push($boards_user_values, 'false');
                                    } else if ($value === null) {
                                        array_push($boards_user_values, null);
                                    } else {
                                        array_push($boards_user_values, $value);
                                    }
                                }
                            }
                            $boards_user_val = '';
                            for ($i = 1, $len = count($boards_user_values); $i <= $len; $i++) {
                                $boards_user_val.= '$' . $i;
                                $boards_user_val.= ($i != $len) ? ', ' : '';
                            }
                            pg_query_params($db_lnk, 'INSERT INTO boards_users (' . $boards_user_fields . ') VALUES (' . $boards_user_val . ')', $boards_user_values);
                        }
                    }
                    //Copy board subscribers
                    $boards_subscriber_fields = 'user_id, is_subscribed';
                    $qry_val_arr = array(
                        $r_resource_vars['boards']
                    );
                    $boards_subscribers = pg_query_params($db_lnk, 'SELECT id, ' . $boards_subscriber_fields . ' FROM board_subscribers WHERE board_id = $1', $qry_val_arr);
                    if ($boards_subscribers && pg_num_rows($boards_subscribers)) {
                        $boards_subscriber_fields = 'created, modified, board_id, ' . $boards_subscriber_fields;
                        while ($boards_subscriber = pg_fetch_object($boards_subscribers)) {
                            $boards_subscriber_values = array();
                            array_push($boards_subscriber_values, 'now()', 'now()', $new_board_id);
                            foreach ($boards_subscriber as $key => $value) {
                                if ($key != 'id') {
                                    if ($value === false) {
                                        array_push($boards_subscriber_values, 'false');
                                    } else if ($value === null) {
                                        array_push($boards_subscriber_values, null);
                                    } else {
                                        array_push($boards_subscriber_values, $value);
                                    }
                                }
                            }
                            $boards_subscriber_val = '';
                            for ($i = 1, $len = count($boards_subscriber_values); $i <= $len; $i++) {
                                $boards_subscriber_val.= '$' . $i;
                                $boards_subscriber_val.= ($i != $len) ? ', ' : '';
                            }
                            pg_query_params($db_lnk, 'INSERT INTO board_subscribers (' . $boards_subscriber_fields . ') VALUES (' . $boards_subscriber_val . ')', $boards_subscriber_values);
                        }
                    }
                } else {
                    //Add into board users
                    $qry_val_arr = array(
                        $new_board_id,
                        $r_post['user_id'],
                        1
                    );
                    pg_query_params($db_lnk, 'INSERT INTO boards_users (created, modified, board_id, user_id, board_user_role_id) VALUES (now(), now(), $1, $2, $3)', $qry_val_arr);
                    //Copy board subscribers
                    $qry_val_arr = array(
                        $copied_board_id,
                        $r_post['user_id']
                    );
                    $boards_subscriber = executeQuery('SELECT id, user_id, is_subscribed FROM board_subscribers WHERE board_id = $1 and user_id = $2', $qry_val_arr);
                    if (!empty($boards_subscriber)) {
                        $boards_subscriber_values = array(
                            $new_board_id,
                            $r_post['user_id'],
                            $boards_subscriber['is_subscribed']
                        );
                        pg_query_params($db_lnk, 'INSERT INTO board_subscribers (created, modified, board_id, user_id, is_subscribed) VALUES (now(), now(), $1, $2, $3)', $boards_subscriber_values);
                    }
                }
                //Copy board star
                $boards_star_fields = 'user_id, is_starred';
                $qry_val_arr = array(
                    $r_resource_vars['boards']
                );
                $boards_stars = pg_query_params($db_lnk, 'SELECT id, ' . $boards_star_fields . ' FROM board_stars WHERE board_id = $1', $qry_val_arr);
                if ($boards_stars && pg_num_rows($boards_stars)) {
                    $boards_star_fields = 'created, modified, board_id, ' . $boards_star_fields;
                    while ($boards_star = pg_fetch_object($boards_stars)) {
                        $boards_star_values = array();
                        array_push($boards_star_values, 'now()', 'now()', $new_board_id);
                        foreach ($boards_star as $key => $value) {
                            if ($key != 'id') {
                                if ($value === false) {
                                    array_push($boards_star_values, 'false');
                                } else if ($value === null) {
                                    array_push($boards_star_values, null);
                                } else {
                                    array_push($boards_star_values, $value);
                                }
                            }
                        }
                        $boards_star_val = '';
                        for ($i = 1, $len = count($boards_star_values); $i <= $len; $i++) {
                            $boards_star_val.= '$' . $i;
                            $boards_star_val.= ($i != $len) ? ', ' : '';
                        }
                        pg_query_params($db_lnk, 'INSERT INTO board_stars (' . $boards_star_fields . ') VALUES (' . $boards_star_val . ')', $boards_star_values);
                    }
                }
                if ($keepcards) {
                    $qry_val_arr = array(
                        $r_resource_vars['boards']
                    );
                    $lists = pg_query_params($db_lnk, 'SELECT id, name, position, is_archived, card_count, lists_subscriber_count, color FROM lists WHERE board_id = $1', $qry_val_arr);
                } else {
                    $qry_val_arr = array(
                        $r_resource_vars['boards']
                    );
                    $lists = pg_query_params($db_lnk, 'SELECT id, name, position, is_archived, lists_subscriber_count, color FROM lists WHERE board_id = $1', $qry_val_arr);
                }
                if ($lists) {
                    // Copy lists
                    while ($list = pg_fetch_object($lists)) {
                        $list_id = $list->id;
                        $list_fields = 'created, modified, board_id, user_id';
                        $list_values = array();
                        array_push($list_values, 'now()', 'now()', $new_board_id, $authUser['id']);
                        foreach ($list as $key => $value) {
                            if ($key != 'id') {
                                $list_fields.= ', ' . $key;
                                if ($value === false) {
                                    array_push($list_values, 'false');
                                } else {
                                    array_push($list_values, $value);
                                }
                            }
                        }
                        $list_val = '';
                        for ($i = 1, $len = count($list_values); $i <= $len; $i++) {
                            $list_val.= '$' . $i;
                            $list_val.= ($i != $len) ? ', ' : '';
                        }
                        $lists_result = pg_query_params($db_lnk, 'INSERT INTO lists (' . $list_fields . ') VALUES (' . $list_val . ') RETURNING id', $list_values);
                        if ($lists_result) {
                            $list_result = pg_fetch_assoc($lists_result);
                            $new_list_id = $list_result['id'];
                            if ($keepusers) {
                                //Copy list subscribers
                                $lists_subscriber_fields = 'user_id, is_subscribed';
                                $qry_val_arr = array(
                                    $list_id
                                );
                                $lists_subscribers = pg_query_params($db_lnk, 'SELECT id, ' . $lists_subscriber_fields . ' FROM list_subscribers WHERE list_id = $1', $qry_val_arr);
                                if ($lists_subscribers && pg_num_rows($lists_subscribers)) {
                                    $lists_subscriber_fields = 'created, modified, list_id, ' . $lists_subscriber_fields;
                                    while ($lists_subscriber = pg_fetch_object($lists_subscribers)) {
                                        $lists_subscriber_values = array();
                                        array_push($lists_subscriber_values, 'now()', 'now()', $new_list_id);
                                        foreach ($lists_subscriber as $key => $value) {
                                            if ($key != 'id') {
                                                if ($value === false) {
                                                    array_push($lists_subscriber_values, 'false');
                                                } else if ($value === null) {
                                                    array_push($lists_subscriber_values, null);
                                                } else {
                                                    array_push($lists_subscriber_values, $value);
                                                }
                                            }
                                        }
                                        $lists_subscriber_val = '';
                                        for ($i = 1, $len = count($lists_subscriber_values); $i <= $len; $i++) {
                                            $lists_subscriber_val.= '$' . $i;
                                            $lists_subscriber_val.= ($i != $len) ? ', ' : '';
                                        }
                                        pg_query_params($db_lnk, 'INSERT INTO list_subscribers (' . $lists_subscriber_fields . ') VALUES (' . $lists_subscriber_val . ')', $lists_subscriber_values);
                                    }
                                }
                            } else {
                                //Copy list subscribers
                                $qry_val_arr = array(
                                    $list_id,
                                    $r_post['user_id']
                                );
                                $lists_subscriber = executeQuery('SELECT id, user_id, is_subscribed FROM list_subscribers WHERE list_id = $1 and user_id =$2', $qry_val_arr);
                                if (!empty($lists_subscriber)) {
                                    $lists_subscriber_values = array(
                                        $new_list_id,
                                        $r_post['user_id'],
                                        $lists_subscriber['is_subscribed']
                                    );
                                    pg_query_params($db_lnk, 'INSERT INTO list_subscribers (created, modified, list_id, user_id, is_subscribed) VALUES (now(), now(), $1, $2, $3)', $lists_subscriber_values);
                                }
                            }
                            // Copy cards
                            $card_fields = 'name, description, due_date, position, is_archived, user_id, color, custom_fields';
                            if ($keepcards) {
                                $qry_val_arr = array(
                                    $list_id
                                );
                                $cards = pg_query_params($db_lnk, 'SELECT id, ' . $card_fields . ' FROM cards WHERE list_id = $1', $qry_val_arr);
                            }
                            if ($keepcards && pg_num_rows($cards)) {
                                $card_fields = 'created, modified, board_id, list_id, ' . $card_fields;
                                while ($card = pg_fetch_object($cards)) {
                                    $card_id = $card->id;
                                    $card_values = array();
                                    array_push($card_values, 'now()', 'now()', $new_board_id, $new_list_id);
                                    foreach ($card as $key => $value) {
                                        if ($key != 'id') {
                                            if ($value === false) {
                                                array_push($card_values, 'false');
                                            } else if ($value === null) {
                                                array_push($card_values, null);
                                            } else {
                                                array_push($card_values, $value);
                                            }
                                        }
                                    }
                                    $card_val = '';
                                    for ($i = 1, $len = count($card_values); $i <= $len; $i++) {
                                        $card_val.= '$' . $i;
                                        $card_val.= ($i != $len) ? ', ' : '';
                                    }
                                    $card_result = pg_query_params($db_lnk, 'INSERT INTO cards (' . $card_fields . ') VALUES (' . $card_val . ') RETURNING id', $card_values);
                                    if ($card_result) {
                                        $card_result = pg_fetch_assoc($card_result);
                                        $new_card_id = $card_result['id'];
                                        //Copy card attachments
                                        if ($keepattachments) {
                                            $attachment_fields = 'name, path, mimetype';
                                            $qry_val_arr = array(
                                                $card_id
                                            );
                                            $attachments = pg_query_params($db_lnk, 'SELECT id, ' . $attachment_fields . ' FROM card_attachments WHERE card_id = $1', $qry_val_arr);
                                            if ($attachments && pg_num_rows($attachments)) {
                                                $attachment_fields = 'created, modified, board_id, list_id, card_id, ' . $attachment_fields;
                                                while ($attachment = pg_fetch_object($attachments)) {
                                                    $attachment_values = array();
                                                    array_push($attachment_values, 'now()', 'now()', $new_board_id, $new_list_id, $new_card_id);
                                                    foreach ($attachment as $key => $value) {
                                                        if ($key != 'id') {
                                                            if ($value === false) {
                                                                array_push($attachment_values, 'false');
                                                            } else if ($value === null) {
                                                                array_push($attachment_values, null);
                                                            } else {
                                                                array_push($attachment_values, $value);
                                                            }
                                                        }
                                                    }
                                                    $attachment_val = '';
                                                    for ($i = 1, $len = count($attachment_values); $i <= $len; $i++) {
                                                        $attachment_val.= '$' . $i;
                                                        $attachment_val.= ($i != $len) ? ', ' : '';
                                                    }
                                                    pg_query_params($db_lnk, 'INSERT INTO card_attachments (' . $attachment_fields . ') VALUES (' . $attachment_val . ')', $attachment_values);
                                                }
                                            }
                                        }
                                        //Copy checklists
                                        if ($keepchecklists) {
                                            $checklist_fields = 'user_id, name, checklist_item_count, checklist_item_completed_count, position';
                                            $qry_val_arr = array(
                                                $card_id
                                            );
                                            $checklists = pg_query_params($db_lnk, 'SELECT id, ' . $checklist_fields . ' FROM checklists WHERE card_id = $1', $qry_val_arr);
                                            if ($checklists && pg_num_rows($checklists)) {
                                                $checklist_fields = 'created, modified, card_id, ' . $checklist_fields;
                                                while ($checklist = pg_fetch_object($checklists)) {
                                                    $checklist_values = array();
                                                    array_push($checklist_values, 'now()', 'now()', $new_card_id);
                                                    $checklist_id = $checklist->id;
                                                    foreach ($checklist as $key => $value) {
                                                        if ($key != 'id') {
                                                            if ($value === false) {
                                                                array_push($checklist_values, 'false');
                                                            } else if ($value === null) {
                                                                array_push($checklist_values, null);
                                                            } else {
                                                                array_push($checklist_values, $value);
                                                            }
                                                        }
                                                    }
                                                    $checklist_val = '';
                                                    for ($i = 1, $len = count($checklist_values); $i <= $len; $i++) {
                                                        $checklist_val.= '$' . $i;
                                                        $checklist_val.= ($i != $len) ? ', ' : '';
                                                    }
                                                    $checklist_result = pg_query_params($db_lnk, 'INSERT INTO checklists (' . $checklist_fields . ') VALUES (' . $checklist_val . ') RETURNING id', $checklist_values);
                                                    if ($checklist_result) {
                                                        $checklist_result = pg_fetch_assoc($checklist_result);
                                                        $new_checklist_id = $checklist_result['id'];
                                                        //Copy checklist items
                                                        $checklist_item_fields = 'user_id, name, position';
                                                        $qry_val_array = array(
                                                            $checklist_id
                                                        );
                                                        $checklist_items = pg_query_params($db_lnk, 'SELECT id, ' . $checklist_item_fields . ' FROM checklist_items WHERE checklist_id = $1', $qry_val_array);
                                                        if ($checklist_items && pg_num_rows($checklist_items)) {
                                                            $checklist_item_fields = 'created, modified, card_id, checklist_id, ' . $checklist_item_fields;
                                                            while ($checklist_item = pg_fetch_object($checklist_items)) {
                                                                $checklist_item_values = array();
                                                                array_push($checklist_item_values, 'now()', 'now()', $new_card_id, $new_checklist_id);
                                                                foreach ($checklist_item as $key => $value) {
                                                                    if ($key != 'id') {
                                                                        if ($value === false) {
                                                                            array_push($checklist_item_values, 'false');
                                                                        } else if ($value === null) {
                                                                            array_push($checklist_item_values, null);
                                                                        } else {
                                                                            array_push($checklist_item_values, $value);
                                                                        }
                                                                    }
                                                                }
                                                                $checklist_item_val = '';
                                                                for ($i = 1, $len = count($checklist_item_values); $i <= $len; $i++) {
                                                                    $checklist_item_val.= '$' . $i;
                                                                    $checklist_item_val.= ($i != $len) ? ', ' : '';
                                                                }
                                                                pg_query_params($db_lnk, 'INSERT INTO checklist_items (' . $checklist_item_fields . ') VALUES (' . $checklist_item_val . ')', $checklist_item_values);
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        if ($keepcomments) {
                                            $qry_val_arr = array(
                                                $new_card_id,
                                                $r_post['user_id'],
                                                $new_list_id,
                                                $new_board_id,
                                                $card_id,
                                                $_GET['token']
                                            );
                                            pg_query_params($db_lnk, 'INSERT INTO activities (created, modified, card_id, user_id, list_id, board_id, token, foreign_id, type, comment, revisions, root, freshness_ts, depth, path, materialized_path) SELECT created, modified, $1, $2, $3, $4, $6,foreign_id, type, comment, revisions, root, freshness_ts, depth, path, materialized_path FROM activities WHERE type = \'add_comment\' AND card_id = $5 ORDER BY id', $qry_val_arr);
                                            $activity_count = executeQuery("SELECT COUNT(id) as total_count FROM activities WHERE type = 'add_comment' AND card_id = $1", array(
                                                $new_card_id
                                            ));
                                            $activity_count = (!empty($activity_count)) ? $activity_count['total_count'] : 0;
                                            $qry_val_arr = array(
                                                $activity_count,
                                                $new_card_id
                                            );
                                            pg_query_params($db_lnk, 'UPDATE cards SET comment_count = $1 WHERE id = $2', $qry_val_arr);
                                        }
                                        if (is_plugin_enabled('r_custom_fields') && $keepcustomFields) {
                                            $customFields = array();
                                            $qry_val_arr = array(
                                                $r_resource_vars['boards'],
                                            );
                                            $custom_fields = pg_query_params($db_lnk, 'SELECT * FROM custom_fields WHERE board_id IS NULL or board_id = $1', $qry_val_arr);
                                            while ($custom_field = pg_fetch_assoc($custom_fields)) {
                                                if (!empty($custom_field['board_id'])) {
                                                    $qry_val_arr = array(
                                                        $new_board_id,
                                                        $custom_field['name']
                                                    );
                                                    $customField = executeQuery('SELECT * FROM custom_fields WHERE board_id = $1 AND name = $2', $qry_val_arr);
                                                    if (empty($customField)) {
                                                        $data = array(
                                                            'user_id' => $authUser['id'],
                                                            'type' => $custom_field['type'],
                                                            'name' => $custom_field['name'],
                                                            'description' => $custom_field['description'],
                                                            'options' => $custom_field['options'],
                                                            'label' => $custom_field['label'],
                                                            'position' => $custom_field['position'],
                                                            'visibility' => $custom_field['visibility'],
                                                            'color' => $custom_field['color'],
                                                            'board_id' => $new_board_id,
                                                        );
                                                        $result = pg_execute_insert('custom_fields', $data);
                                                        $row = pg_fetch_assoc($result);
                                                        $customFields[$custom_field['id']] = (int)($row['id']);
                                                    } else {
                                                        $qry_val_arr = array(
                                                            $r_resource_vars['boards'],
                                                            $custom_field['name']
                                                        );
                                                        $previous_customField = executeQuery('SELECT * FROM custom_fields WHERE board_id = $1 AND name = $2', $qry_val_arr);
                                                        if (!empty($previous_customField) && !empty($customField)) {
                                                            if ($previous_customField['type'] === 'dropdown') {
                                                                $new_customfield_options = explode(',', $customField['options']);
                                                                $previous_customfield_options = explode(',', $previous_customField['options']);
                                                                $new_unique_option = array_unique(array_merge($new_customfield_options, $previous_customfield_options));
                                                                $data = array(
                                                                    $customField['id'],
                                                                    implode(',', $new_unique_option)
                                                                );
                                                                pg_query_params($db_lnk, 'UPDATE custom_fields SET options = $2 WHERE id = $1', $data);
                                                            }
                                                        }
                                                        $customFields[$custom_field['id']] = $customField['id'];
                                                    }
                                                } else {
                                                    $customFields[$custom_field['id']] = $custom_field['id'];
                                                }
                                            }
                                            if (!empty($customFields)) {
                                                $qry_val_arr = array(
                                                    $card_id
                                                );
                                                $cardsCustomFields = pg_query_params($db_lnk, 'SELECT * FROM cards_custom_fields WHERE card_id = $1 ORDER BY id', $qry_val_arr);
                                                while ($cardsCustomField = pg_fetch_assoc($cardsCustomFields)) {
                                                    if (isset($customFields[$cardsCustomField['custom_field_id']])) {
                                                        $data = array(
                                                            $new_card_id,
                                                            $customFields[$cardsCustomField['custom_field_id']],
                                                            $cardsCustomField['value'],
                                                            $cardsCustomField['is_active'],
                                                            $new_board_id,
                                                            $new_list_id
                                                        );
                                                        pg_query_params($db_lnk, 'INSERT INTO cards_custom_fields (created, modified, card_id, custom_field_id, value,is_active, board_id, list_id) VALUES (now(), now(), $1, $2, $3, $4, $5, $6)', $data);
                                                    }
                                                }
                                            }
                                        }
                                        if ($keepusers) {
                                            //Copy card voters
                                            $card_voter_fields = 'user_id';
                                            $qry_val_arr = array(
                                                $card_id
                                            );
                                            $card_voters = pg_query_params($db_lnk, 'SELECT id, ' . $card_voter_fields . ' FROM card_voters WHERE card_id = $1', $qry_val_arr);
                                            if ($card_voters && pg_num_rows($card_voters)) {
                                                $card_voter_fields = 'created, modified, card_id, ' . $card_voter_fields;
                                                while ($card_voter = pg_fetch_object($card_voters)) {
                                                    $card_voter_values = array();
                                                    array_push($card_voter_values, 'now()', 'now()', $new_card_id);
                                                    foreach ($card_voter as $key => $value) {
                                                        if ($key != 'id') {
                                                            if ($value === false) {
                                                                array_push($card_voter_values, 'false');
                                                            } else if ($value === null) {
                                                                array_push($card_voter_values, null);
                                                            } else {
                                                                array_push($card_voter_values, $value);
                                                            }
                                                        }
                                                    }
                                                    $card_voter_val = '';
                                                    for ($i = 1, $len = count($card_voter_values); $i <= $len; $i++) {
                                                        $card_voter_val.= '$' . $i;
                                                        $card_voter_val.= ($i != $len) ? ', ' : '';
                                                    }
                                                    pg_query_params($db_lnk, 'INSERT INTO card_voters (' . $card_voter_fields . ') VALUES (' . $card_voter_val . ')', $card_voter_values);
                                                }
                                            }
                                            //Copy card subscribers
                                            $cards_subscriber_fields = 'user_id, is_subscribed';
                                            $qry_val_arr = array(
                                                $card_id
                                            );
                                            $cards_subscribers = pg_query_params($db_lnk, 'SELECT id, ' . $cards_subscriber_fields . ' FROM card_subscribers WHERE card_id = $1', $qry_val_arr);
                                            if ($cards_subscribers && pg_num_rows($cards_subscribers)) {
                                                $cards_subscriber_fields = 'created, modified, card_id, ' . $cards_subscriber_fields;
                                                while ($cards_subscriber = pg_fetch_object($cards_subscribers)) {
                                                    $cards_subscriber_values = array();
                                                    array_push($cards_subscriber_values, 'now()', 'now()', $new_card_id);
                                                    foreach ($cards_subscriber as $key => $value) {
                                                        if ($key != 'id') {
                                                            if ($value === false) {
                                                                array_push($cards_subscriber_values, 'false');
                                                            } else if ($value === null) {
                                                                array_push($cards_subscriber_values, null);
                                                            } else {
                                                                array_push($cards_subscriber_values, $value);
                                                            }
                                                        }
                                                    }
                                                    $cards_subscriber_val = '';
                                                    for ($i = 1, $len = count($cards_subscriber_values); $i <= $len; $i++) {
                                                        $cards_subscriber_val.= '$' . $i;
                                                        $cards_subscriber_val.= ($i != $len) ? ', ' : '';
                                                    }
                                                    pg_query_params($db_lnk, 'INSERT INTO card_subscribers (' . $cards_subscriber_fields . ') VALUES (' . $cards_subscriber_val . ')', $cards_subscriber_values);
                                                }
                                            }
                                            //Copy card users
                                            $cards_user_fields = 'user_id';
                                            $qry_val_arr = array(
                                                $card_id
                                            );
                                            $cards_users = pg_query_params($db_lnk, 'SELECT id, ' . $cards_user_fields . ' FROM cards_users WHERE card_id = $1', $qry_val_arr);
                                            if ($cards_users && pg_num_rows($cards_users)) {
                                                $cards_user_fields = 'created, modified, card_id, ' . $cards_user_fields;
                                                while ($cards_user = pg_fetch_object($cards_users)) {
                                                    $cards_user_values = array();
                                                    array_push($cards_user_values, 'now()', 'now()', $new_card_id);
                                                    foreach ($cards_user as $key => $value) {
                                                        if ($key != 'id') {
                                                            if ($value === false) {
                                                                array_push($cards_user_values, 'false');
                                                            } else if ($value === null) {
                                                                array_push($cards_user_values, null);
                                                            } else {
                                                                array_push($cards_user_values, $value);
                                                            }
                                                        }
                                                    }
                                                    $cards_user_val = '';
                                                    for ($i = 1, $len = count($cards_user_values); $i <= $len; $i++) {
                                                        $cards_user_val.= '$' . $i;
                                                        $cards_user_val.= ($i != $len) ? ', ' : '';
                                                    }
                                                    pg_query_params($db_lnk, 'INSERT INTO cards_users (' . $cards_user_fields . ') VALUES (' . $cards_user_val . ')', $cards_user_values);
                                                }
                                            }
                                        } else {
                                            //Copy card subscribers
                                            $qry_val_arr = array(
                                                $card_id,
                                                $r_post['user_id']
                                            );
                                            $cards_subscriber = executeQuery('SELECT id, user_id, is_subscribed FROM card_subscribers WHERE card_id = $1 and user_id =$2', $qry_val_arr);
                                            if (!empty($cards_subscriber)) {
                                                $cards_subscriber_values = array(
                                                    $new_card_id,
                                                    $r_post['user_id'],
                                                    $cards_subscriber['is_subscribed']
                                                );
                                                pg_query_params($db_lnk, 'INSERT INTO card_subscribers (created, modified, card_id, user_id, is_subscribed) VALUES (now(), now(), $1, $2, $3)', $cards_subscriber_values);
                                            }
                                        }
                                        //Copy card labels
                                        if ($keeplabels) {
                                            $cards_label_fields = 'label_id';
                                            $qry_val_arr = array(
                                                $card_id
                                            );
                                            $cards_labels = pg_query_params($db_lnk, 'SELECT id, ' . $cards_label_fields . ' FROM cards_labels WHERE card_id = $1', $qry_val_arr);
                                            if ($cards_labels && pg_num_rows($cards_labels)) {
                                                $cards_label_fields = 'created, modified, board_id, list_id, card_id, ' . $cards_label_fields;
                                                while ($cards_label = pg_fetch_object($cards_labels)) {
                                                    $cards_label_values = array();
                                                    array_push($cards_label_values, 'now()', 'now()', $new_board_id, $new_list_id, $new_card_id);
                                                    foreach ($cards_label as $key => $value) {
                                                        if ($key != 'id') {
                                                            if ($value === false) {
                                                                array_push($cards_label_values, 'false');
                                                            } else if ($value === null) {
                                                                array_push($cards_label_values, null);
                                                            } else {
                                                                array_push($cards_label_values, $value);
                                                            }
                                                        }
                                                    }
                                                    $cards_label_val = '';
                                                    for ($i = 1, $len = count($cards_label_values); $i <= $len; $i++) {
                                                        $cards_label_val.= '$' . $i;
                                                        $cards_label_val.= ($i != $len) ? ', ' : '';
                                                    }
                                                    pg_query_params($db_lnk, 'INSERT INTO cards_labels (' . $cards_label_fields . ') VALUES (' . $cards_label_val . ')', $cards_label_values);
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                $qry_val_arr = array(
                    $r_resource_vars['boards']
                );
                $sresult = pg_query_params($db_lnk, 'SELECT name FROM boards WHERE id = $1', $qry_val_arr);
                $srow = pg_fetch_assoc($sresult);
                $foreign_ids['board_id'] = $new_board_id;
                $comment = '##USER_NAME## copied this board from ' . $srow['name'];
                $response['activity'] = insertActivity($authUser['id'], $comment, 'copy_board', $foreign_ids, null, $r_resource_vars['boards']);
            }
        }
        echo json_encode($response);
        break;

    case '/boards/?/custom_backgrounds':
        $is_return_vlaue = true;
        if (!empty($_FILES['attachment']) && $_FILES['attachment']['error'] == 0) {
            $allowed_ext = array(
                'gif',
                'png',
                'jpg',
                'jpeg',
                'bmp'
            );
            $filename = $_FILES['attachment']['name'];
            $file_ext = pathinfo($filename, PATHINFO_EXTENSION);
            if (in_array($file_ext, $allowed_ext)) {
                $mediadir = MEDIA_PATH . DS . 'Board' . DS . $r_resource_vars['boards'];
                $save_path = 'Board' . DS . $r_resource_vars['boards'];
                if (!file_exists($mediadir)) {
                    mkdir($mediadir, 0777, true);
                }
                $file = $_FILES['attachment'];
                $file['name'] = preg_replace('/[^A-Za-z0-9\-.]/', '', $file['name']);
                if (is_uploaded_file($file['tmp_name']) && move_uploaded_file($file['tmp_name'], $mediadir . DS . $file['name'])) {
                    $r_post['name'] = $file['name'];
                    foreach ($thumbsizes['Board'] as $key => $value) {
                        $mediadir = IMG_PATH . DS . $key . DS . 'Board' . DS . $r_resource_vars['boards'];
                        $list = glob($mediadir . '.*');
                        if (!empty($list) && isset($list[0]) && file_exists($list[0])) {
                            unlink($list[0]);
                        }
                    }
                    $hash = md5(SECURITYSALT . 'Board' . $r_resource_vars['boards'] . 'jpg' . 'extra_large_thumb');
                    $background_picture_url = $_server_domain_url . '/img/extra_large_thumb/Board/' . $r_resource_vars['boards'] . '.' . $hash . '.jpg';
                    $r_post['background_picture_path'] = $save_path . DS . $file['name'];
                    $background_picture_url = preg_replace('/(http|https):/', '', $background_picture_url);
                    $r_post['path'] = $background_picture_url;
                    $r_post['background_picture_url'] = $background_picture_url;
                    $response['background_picture_url'] = $background_picture_url;
                }
                $qry_val_array = array(
                    $r_post['path'],
                    $r_post['background_picture_path'],
                    $r_resource_vars['boards']
                );
                $qry_val_arr = array(
                    $r_resource_vars['boards']
                );
                $previous_value = executeQuery('SELECT * FROM boards WHERE id = $1', $qry_val_arr);
                $foreign_ids['board_id'] = $r_resource_vars['boards'];
                if (empty($previous_value['background_picture_url'])) {
                    $comment = '##USER_NAME## added background to board "' . $previous_value['name'] . '"';
                    $activity_type = 'add_background';
                } else {
                    $comment = '##USER_NAME## changed backgound to board "' . $previous_value['name'] . '"';
                    $activity_type = 'change_background';
                }
                unset($r_post['name']);
                $response['activity'] = update_query('boards', $r_resource_vars['boards'], $r_resource_cmd, $r_post, $comment, $activity_type, $foreign_ids);
            } else {
                $response['error'] = 'File extension not supported. It supports only jpg, png, bmp and gif.';
            }
        }
        echo json_encode($response);
        break;

    case '/boards/?/users':
        $is_return_vlaue = true;
        $table_name = 'boards_users';
        $r_post['board_id'] = $r_resource_vars['boards'];
        $qry_val_arr = array(
            $r_resource_vars['boards'],
            $r_post['user_id']
        );
        $boards_user = executeQuery('SELECT * FROM boards_users WHERE board_id = $1 AND user_id = $2', $qry_val_arr);
        if (empty($boards_user)) {
            $sql = true;
        }
        if (!empty($sql)) {
            $post = getbindValues($table_name, $r_post);
            $result = pg_execute_insert($table_name, $post);
            if ($result) {
                $row = pg_fetch_assoc($result);
                if (is_plugin_enabled('r_board_role_mapper')) {
                    require_once PLUGIN_PATH . DS . 'BoardRoleMapper' . DS . 'functions.php';
                    $board_user_role_id = boardRoleAfterInsertBoardUser($r_post);
                    if (!empty($board_user_role_id)) {
                        $response['board_user_role_id'] = $board_user_role_id;
                    }
                }
                $response['id'] = $row['id'];
                if ($is_return_vlaue) {
                    $row = convertBooleanValues($table_name, $row);
                    $response[$table_name] = $row;
                }
                $qry_val_arr = array(
                    $r_post['board_id']
                );
                $s_result = pg_query_params($db_lnk, 'SELECT id, name, auto_subscribe_on_board FROM boards WHERE id = $1', $qry_val_arr);
                $previous_value = pg_fetch_assoc($s_result);
                if ($previous_value['auto_subscribe_on_board'] === 't') {
                    $qry_val_arr = array(
                        $r_post['board_id'],
                        $r_post['user_id'],
                        true
                    );
                    pg_query_params($db_lnk, 'INSERT INTO board_subscribers (created, modified, board_id , user_id, is_subscribed) VALUES (now(), now(), $1, $2, $3)', $qry_val_arr);
                }
                $foreign_ids['board_id'] = $r_resource_vars['boards'];
                $foreign_ids['board_id'] = $r_post['board_id'];
                $qry_val_arr = array(
                    $r_post['user_id']
                );
                $user = executeQuery('SELECT * FROM users WHERE id = $1', $qry_val_arr);
                if ($user) {
                    $emailFindReplace = array(
                        '##NAME##' => $user['full_name'],
                        '##CURRENT_USER##' => $authUser['full_name'],
                        '##BOARD_NAME##' => $previous_value['name'],
                        '##BOARD_URL##' => $_server_domain_url . '/#/board/' . $r_post['board_id']
                    );
                    sendMail('newprojectuser', $emailFindReplace, $user['email']);
                }
                $comment = '##USER_NAME## added member to board';
                $response['activity'] = insertActivity($authUser['id'], $comment, 'add_board_user', $foreign_ids, '', $response['id']);
                if (is_plugin_enabled('r_chat') && $jabberHost) {
                    xmppGrantMember($r_post, $previous_value);
                }
            }
        }
        echo json_encode($response);
        break;

    case '/boards/?/lists':
        $table_name = 'lists';
        $r_post['board_id'] = $r_resource_vars['boards'];
        $r_post['user_id'] = $authUser['id'];
        $sql = true;
        if (isset($r_post['clone_list_id'])) {
            $clone_list_id = $r_post['clone_list_id'];
            unset($r_post['clone_list_id']);
            unset($r_post['list_cards']);
        }
        if (!empty($sql)) {
            $post = getbindValues($table_name, $r_post);
            $result = pg_execute_insert($table_name, $post);
            if ($result) {
                $row = pg_fetch_assoc($result);
                $response['id'] = $row['id'];
                if ($is_return_vlaue) {
                    $row = convertBooleanValues($table_name, $row);
                    $response[$table_name] = $row;
                }
                $foreign_ids['board_id'] = $r_post['board_id'];
                $foreign_ids['list_id'] = $response['id'];
                $comment = '##USER_NAME## added list "' . $r_post['name'] . '".';
                $response['activity'] = insertActivity($authUser['id'], $comment, 'add_list', $foreign_ids);
                if (!empty($clone_list_id)) {
                    $new_list_id = $response['id'];
                    // Copy cards
                    $card_fields = 'board_id, name, description, position, due_date, is_archived, attachment_count, checklist_count, checklist_item_count, checklist_item_completed_count, label_count, cards_user_count, cards_subscriber_count, card_voter_count, activity_count, user_id, comment_count,custom_fields,color';
                    $card_fields = 'list_id, ' . $card_fields;
                    $qry_val_arr = array(
                        $clone_list_id
                    );
                    $cards = pg_query_params($db_lnk, 'SELECT id, ' . $card_fields . ' FROM cards WHERE list_id = $1 ORDER BY id', $qry_val_arr);
                    if (pg_num_rows($cards)) {
                        copyCards($cards, $new_list_id, $post['name'], $foreign_ids['board_id']);
                    }
                }
                $qry_val_arr = array(
                    $foreign_ids['list_id']
                );
                $s_result = pg_query_params($db_lnk, 'SELECT * FROM lists_listing WHERE id = $1', $qry_val_arr);
                $list = pg_fetch_assoc($s_result);
                $response['list'] = $list;
                if (!empty($response['list'])) {
                    if (is_plugin_enabled('r_custom_fields')) {
                        $response['custom_fields'] = array();
                        $conditions = array(
                            $response['list']['board_id']
                        );
                        $custom_fields = pg_query_params($db_lnk, 'SELECT * FROM custom_fields_listing WHERE board_id IS NULL or board_id = $1 ORDER BY position ASC', $conditions);
                        while ($custom_field = pg_fetch_assoc($custom_fields)) {
                            $response['custom_fields'][] = $custom_field;
                        }
                    }
                }
                $qry_val_arr = array(
                    $foreign_ids['list_id']
                );
                $attachments = pg_query_params($db_lnk, 'SELECT * FROM card_attachments WHERE list_id = $1 order by created DESC', $qry_val_arr);
                while ($attachment = pg_fetch_assoc($attachments)) {
                    $response['list']['attachments'][] = $attachment;
                }
                $qry_val_arr = array(
                    $foreign_ids['list_id']
                );
                $activities = pg_query_params($db_lnk, 'SELECT * FROM activities_listing WHERE list_id = $1', $qry_val_arr);
                while ($activity = pg_fetch_assoc($activities)) {
                    $response['list']['activities'][] = $activity;
                }
                $condition = array(
                    $foreign_ids['list_id']
                );
                $cards = pg_query_params($db_lnk, 'select * from cards where list_id = $1', $condition);
                while ($card = pg_fetch_assoc($cards)) {
                    $response['list']['checklists'] = $response['list']['checklists_items'] = array();
                    if (!empty($card)) {
                        $condition = array(
                            $card['id']
                        );
                        $checklists = pg_query_params($db_lnk, 'select * from checklists where card_id = $1', $condition);
                        while ($checklist = pg_fetch_assoc($checklists)) {
                            if (!empty($checklist)) {
                                $response['list']['checklists'][] = $checklist;
                                $condition = array(
                                    $card['id'],
                                    $checklist['id']
                                );
                                $checklist_items = pg_query_params($db_lnk, 'select * from checklist_items where card_id = $1 AND checklist_id = $2', $condition);
                                while ($checklist_item = pg_fetch_assoc($checklist_items)) {
                                    if (!empty($checklist_item)) {
                                        $response['list']['checklists_items'][] = $checklist_item;
                                    }
                                }
                            }
                        }
                    }
                }
                $qry_val_arr = array(
                    $foreign_ids['list_id']
                );
                $labels = pg_query_params($db_lnk, 'SELECT * FROM cards_labels_listing WHERE list_id = $1', $qry_val_arr);
                while ($label = pg_fetch_assoc($labels)) {
                    $response['list']['labels'][] = $label;
                }
                $response['list']['cards'] = json_decode($response['list']['cards'], true);
                if (isset($response['list']['lists_subscribers'])) {
                    $response['list']['lists_subscribers'] = json_decode($response['list']['lists_subscribers'], true);
                }
                $qry_val_arr = array(
                    $r_post['board_id']
                );
                $list_count = executeQuery('SELECT count(*) as count FROM lists WHERE board_id = $1', $qry_val_arr);
                if ($list_count['count'] == 1) {
                    $qry_val_arr = array(
                        $r_post['board_id'],
                        $response['id']
                    );
                    pg_query_params($db_lnk, 'UPDATE boards SET default_email_list_id = $2 WHERE id = $1', $qry_val_arr);
                }
            }
        }
        echo json_encode($response);
        break;

    case '/boards/?/lists/?/list_subscribers':
        $table_name = 'list_subscribers';
        $r_post['user_id'] = $authUser['id'];
        $qry_val_arr = array(
            $r_resource_vars['lists'],
            $r_post['user_id']
        );
        $s_result = pg_query_params($db_lnk, 'SELECT is_subscribed FROM list_subscribers WHERE list_id = $1 and user_id = $2', $qry_val_arr);
        $check_subscribed = pg_fetch_assoc($s_result);
        if (!empty($check_subscribed)) {
            $is_subscribed = ($r_post['is_subscribed']) ? true : 0;
            $qry_val_arr = array(
                $is_subscribed,
                $r_resource_vars['lists'],
                $r_post['user_id']
            );
            pg_query_params($db_lnk, 'UPDATE list_subscribers SET is_subscribed = $1 WHERE list_id = $2 and user_id = $3', $qry_val_arr);
        } else {
            $r_post['list_id'] = $r_resource_vars['lists'];
            $sql = true;
        }
        if (!empty($sql)) {
            $post = getbindValues($table_name, $r_post);
            $result = pg_execute_insert($table_name, $post);
            if ($result) {
                $row = pg_fetch_assoc($result);
                $response['id'] = $row['id'];
            }
        }
        echo json_encode($response);
        break;

    case '/boards/?/lists/?/cards':
        if (isset($_POST) && !empty($_POST) && isset($_POST['is_instant_add_Card'])) {
            $r_post = json_decode($_POST['data'], true);
            $r_post['image_link'] = $_POST['image_link'];
        }
        $table_name = 'cards';
        if (!empty($r_post['is_support_app'])) {
            $admin = executeQuery('SELECT id FROM users WHERE role_id = $1', [1]);
            $r_post['user_id'] = $userID = $admin['id'];
        } else {
            $r_post['user_id'] = $userID = $authUser['id'];
        }
        $qry_val_arr = array(
            $r_post['board_id'],
            $r_post['list_id']
        );
        $pos_res = pg_query_params($db_lnk, 'SELECT position FROM cards WHERE board_id = $1 AND list_id = $2 ORDER BY position DESC LIMIT 1', $qry_val_arr);
        $position = pg_fetch_array($pos_res);
        if (empty($r_post['due_date'])) {
            unset($r_post['due_date']);
        }
        if (!empty($r_post['user_ids'])) {
            $r_post['members'] = explode(',', $r_post['user_ids']);
        }
        if (!isset($r_post['position'])) {
            $r_post['position'] = $position[0] + 1;
        }
        $sql = true;
        if (!empty($sql)) {
            $post = getbindValues($table_name, $r_post);
            $result = pg_execute_insert($table_name, $post);
            if ($result) {
                $row = pg_fetch_assoc($result);
                $response['id'] = $row['id'];
                $qry_val_arr = array(
                    $r_post['list_id']
                );
                $s_result = pg_query_params($db_lnk, 'SELECT name FROM lists WHERE id = $1', $qry_val_arr);
                $list = pg_fetch_assoc($s_result);
                $foreign_ids['board_id'] = $r_post['board_id'];
                $foreign_ids['card_id'] = $response['id'];
                $foreign_ids['list_id'] = $r_post['list_id'];
                $comment = '##USER_NAME## added card ##CARD_LINK## to list "' . $list['name'] . '".';
                $response['activity'] = insertActivity($userID, $comment, 'add_card', $foreign_ids, '', $r_post['list_id']);
                if (isset($_POST) && !empty($_POST) && isset($_POST['is_instant_add_Card'])) {
                    $is_return_vlaue = true;
                    $table_name = 'card_attachments';
                    $r_post['card_id'] = $response['id'];
                    $mediadir = MEDIA_PATH . DS . 'Card' . DS . $r_post['card_id'];
                    $save_path = 'Card' . DS . $r_post['card_id'];
                    $save_path = str_replace('\\', '/', $save_path);
                    if (!empty($_FILES['attachment']) && is_array($_FILES['attachment']['name']) && $_FILES['attachment']['error'][0] == 0) {
                        $file = $_FILES['attachment'];
                        $file_count = count($file['name']);
                        for ($i = 0; $i < $file_count; $i++) {
                            if (empty($r_post['attachment_remove_ids']) || !in_array($i, $r_post['attachment_remove_ids'])) {
                                if ($file['name'][$i] != 'undefined') {
                                    if (!file_exists($mediadir)) {
                                        mkdir($mediadir, 0777, true);
                                    }
                                    $cur_os = strtolower(PHP_OS);
                                    if (substr($cur_os, 0, 3) === 'win') {
                                        $file['name'][$i] = urlencode($file['name'][$i]);
                                    }
                                    $file_arr = pathinfo($file['name'][$i]);
                                    $filename_without_ext = $file_arr['filename'];
                                    if (file_exists($mediadir . DS . $file['name'][$i])) {
                                        $filename_without_ext = $file_arr['filename'] . '-' . mt_rand(0, 999);
                                        $file['name'][$i] = $filename_without_ext . '.' . $file_arr['extension'];
                                    }
                                    if (is_uploaded_file($file['tmp_name'][$i]) && move_uploaded_file($file['tmp_name'][$i], $mediadir . DS . $file['name'][$i])) {
                                        $r_post[$i]['path'] = $save_path . DS . $file['name'][$i];
                                        $r_post[$i]['name'] = $file['name'][$i];
                                        $r_post[$i]['mimetype'] = $file['type'][$i];
                                        $qry_val_arr = array(
                                            $r_post['card_id'],
                                            $r_post[$i]['name'],
                                            $r_post[$i]['path'],
                                            $r_post['list_id'],
                                            $r_post['board_id'],
                                            $r_post[$i]['mimetype']
                                        );
                                        $s_result = pg_query_params($db_lnk, 'INSERT INTO card_attachments (created, modified, card_id, name, path, list_id, board_id, mimetype) VALUES (now(), now(), $1, $2, $3, $4, $5, $6) RETURNING *', $qry_val_arr);
                                        $cardAttachment = $response_file['card_attachments'][$i] = pg_fetch_assoc($s_result);
                                        if (class_exists('imagick') && in_array($file_arr['extension'], array(
                                            'pdf'
                                        ))) {
                                            try {
                                                $im = new Imagick($mediadir . DS . $file['name'][$i] . "[0]"); // 0-first page, 1-second page
                                                $im->setImageColorspace(Imagick::COLORSPACE_RGB); // prevent image colors from inverting
                                                $im->setimageformat('png');
                                                $im->thumbnailimage(200, 150); // width and height
                                                $target_hash = md5(SECURITYSALT . 'CardAttachment' . $cardAttachment['id'] . 'png' . 'original');
                                                $target_dir = IMG_PATH . DS . 'original' . DS . 'CardAttachment';
                                                $target = $target_dir . DS . $cardAttachment['id'] . '.' . $target_hash . '.png';
                                                if (!file_exists($target_dir)) {
                                                    mkdir($target_dir, 0777, true);
                                                }
                                                $im->writeimage($target);
                                                $im->clear();
                                                $im->destroy();
                                                $response_file['card_attachments'][$i]['doc_image_path'] = 'original' . DS . 'CardAttachment' . DS . $cardAttachment['id'] . '.' . $target_hash . '.png';
                                                $qry_val_arr = array(
                                                    $response_file['card_attachments'][$i]['doc_image_path'],
                                                    $cardAttachment['id']
                                                );
                                                pg_query_params($db_lnk, 'UPDATE card_attachments SET doc_image_path = $1 WHERE id = $2', $qry_val_arr);
                                            }
                                            catch(Exception $e) {
                                            }
                                        }
                                        $foreign_ids['board_id'] = $r_post['board_id'];
                                        $foreign_ids['list_id'] = $r_post['list_id'];
                                        $foreign_ids['card_id'] = $r_post['card_id'];
                                        $comment = '##USER_NAME## added attachment to the card ##CARD_LINK##';
                                        $response_file['activity'] = insertActivity($userID, $comment, 'add_card_attachment', $foreign_ids, null, $response_file['card_attachments'][$i]['id']);
                                        foreach ($thumbsizes['CardAttachment'] as $key => $value) {
                                            $imgdir = IMG_PATH . DS . $key . DS . 'CardAttachment' . DS . $response_file['card_attachments'][$i]['id'];
                                            $list = glob($imgdir . '.*');
                                            if (!empty($list) && isset($list[0]) && file_exists($list[0])) {
                                                unlink($list[0]);
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if (!empty($r_post['dropbox_image_link']) && is_array($r_post['dropbox_image_link'])) {
                        $i = 0;
                        foreach ($r_post['dropbox_image_link'] as $image_link) {
                            $r_post['name'] = $r_post['link'] = $image_link;
                            $qry_val_arr = array(
                                $r_post['card_id'],
                                $r_post['name'],
                                'NULL',
                                $r_post['list_id'],
                                $r_post['board_id'],
                                'NULL',
                                $r_post['link']
                            );
                            $s_result = pg_query_params($db_lnk, 'INSERT INTO card_attachments (created, modified, card_id, name, path, list_id, board_id, mimetype, link) VALUES (now(), now(), $1, $2, $3, $4, $5, $6, $7) RETURNING *', $qry_val_arr);
                            $response_file['card_attachments'][] = pg_fetch_assoc($s_result);
                            $foreign_ids['board_id'] = $r_post['board_id'];
                            $foreign_ids['list_id'] = $r_post['list_id'];
                            $foreign_ids['card_id'] = $r_post['card_id'];
                            $comment = '##USER_NAME## added attachment to the card ##CARD_LINK##';
                            $response_file['activity'] = insertActivity($userID, $comment, 'add_card_attachment', $foreign_ids, null, $response_file['card_attachments'][$i]['id']);
                            $i++;
                        }
                    }
                    if (isset($r_post['image_link']) && !empty($r_post['image_link'])) {
                        $sql = true;
                        $r_post['name'] = $r_post['link'] = $r_post['image_link'];
                        $r_post['path'] = '';
                        unset($r_post['image_link']);
                        if (!empty($sql)) {
                            $post = getbindValues($table_name, $r_post);
                            $result = pg_execute_insert($table_name, $post);
                            if ($result) {
                                $row = pg_fetch_assoc($result);
                                $response_file['card_attachments'] = $row;
                                $foreign_ids['board_id'] = $r_post['board_id'];
                                $foreign_ids['list_id'] = $r_post['list_id'];
                                $foreign_ids['card_id'] = $r_post['card_id'];
                                $comment = '##USER_NAME## added attachment to the card ##CARD_LINK##';
                                $response_file['activity'] = insertActivity($userID, $comment, 'add_card_attachment', $foreign_ids, null, $row['id']);
                                foreach ($thumbsizes['CardAttachment'] as $key => $value) {
                                    $mediadir = IMG_PATH . DS . $key . DS . 'CardAttachment' . DS . $row['id'];
                                    $list = glob($mediadir . '.*');
                                    if (!empty($list) && isset($list[0]) && file_exists($list[0])) {
                                        unlink($list[0]);
                                    }
                                }
                            }
                        }
                    }
                    $qry_val_arr = array(
                        $response['id']
                    );
                    $card_attachments = pg_query_params($db_lnk, 'SELECT * FROM card_attachments WHERE card_id = $1 ORDER BY id DESC', $qry_val_arr);
                    while ($card_attachment = pg_fetch_assoc($card_attachments)) {
                        $response['card_attachments'][] = $card_attachment;
                    }
                }
                if (!empty($r_post['members'])) {
                    foreach ($r_post['members'] as $member) {
                        $s_usql = 'INSERT INTO cards_users (created, modified, card_id, user_id) VALUES(now(), now(), ' . $response['id'] . ', ' . $member . ') RETURNING id';
                        $s_result = pg_query_params($db_lnk, $s_usql, array());
                        $card_user = pg_fetch_assoc($s_result);
                        $qry_val_arr = array(
                            $member
                        );
                        $_user = executeQuery('SELECT username FROM users WHERE id = $1', $qry_val_arr);
                        $comment = '##USER_NAME## added "' . $_user['username'] . '" as member to the card ##CARD_LINK##';
                        $response['activity'] = insertActivity($userID, $comment, 'add_card_user', $foreign_ids, '', $card_user['id']);
                    }
                }
                if (!empty($r_post['labels'])) {
                    $r_post['card_labels'] = $r_post['labels'];
                }
                $names = '';
                if (!empty($r_post['card_labels'])) {
                    $label_names = explode(',', $r_post['card_labels']);
                    foreach ($label_names as $label_name) {
                        $names.= $label_name . ', ';
                        $qry_val_arr = array(
                            $label_name
                        );
                        $s_result = pg_query_params($db_lnk, 'SELECT id FROM labels WHERE name = $1', $qry_val_arr);
                        $label = pg_fetch_assoc($s_result);
                        if (empty($label)) {
                            $qry_val_arr = array(
                                $label_name
                            );
                            $s_result = pg_query_params($db_lnk, $s_sql = 'INSERT INTO labels (created, modified, name) VALUES (now(), now(), $1) RETURNING id', $qry_val_arr);
                            $label = pg_fetch_assoc($s_result);
                        }
                        $r_post['label_id'] = $label['id'];
                        $r_post['card_id'] = $row['id'];
                        $r_post['list_id'] = $row['list_id'];
                        $r_post['board_id'] = $row['board_id'];
                        $qry_val_arr = array(
                            $r_post['card_id'],
                            $r_post['label_id'],
                            $r_post['board_id'],
                            $r_post['list_id']
                        );
                        pg_query_params($db_lnk, 'INSERT INTO cards_labels (created, modified, card_id, label_id, board_id, list_id) VALUES (now(), now(), $1, $2, $3, $4) RETURNING *', $qry_val_arr);
                    }
                    $comment = '##USER_NAME## added label(s) to the card ##CARD_LINK## - ' . $names;
                    insertActivity($userID, $comment, 'add_card_label', $foreign_ids, null, $r_post['label_id']);
                }
                if (!empty($r_post['cards_checklists_card_id'])) {
                    $qry_val_arr = array(
                        $response['id'],
                        $r_post['cards_checklists_card_id']
                    );
                    $checklist = pg_query_params($db_lnk, 'INSERT INTO checklists (created, modified, user_id, card_id, name, checklist_item_count, checklist_item_completed_count, position) SELECT created, modified, user_id, $1, name, checklist_item_count, checklist_item_completed_count, position FROM checklists WHERE card_id = $2 ORDER BY id', $qry_val_arr);
                    $updateChecklist = pg_fetch_assoc($checklist);
                    $qry_val_arr = array(
                        $response['id']
                    );
                    $query_val_arr = array(
                        0,
                        $updateChecklist['id']
                    );
                    $sql = pg_query_params($db_lnk, "UPDATE checklists SET checklist_item_completed_count = $1 WHERE id = $2", $query_val_arr);
                    $checklists = pg_query_params($db_lnk, 'SELECT id FROM checklists WHERE card_id = $1 order by id', $qry_val_arr);
                    $qry_val_arr = array(
                        $r_post['cards_checklists_card_id']
                    );
                    $prev_checklists = pg_query_params($db_lnk, 'SELECT id FROM checklists WHERE card_id = $1 order by id', $qry_val_arr);
                    $prev_checklist_ids = array();
                    while ($prev_checklist_id = pg_fetch_assoc($prev_checklists)) {
                        $prev_checklist_ids[] = $prev_checklist_id['id'];
                    }
                    $i = 0;
                    while ($checklist_id = pg_fetch_assoc($checklists)) {
                        $qry_val_arr = array(
                            $response['id'],
                            $checklist_id['id'],
                            $prev_checklist_ids[$i]
                        );
                        $items = pg_query_params($db_lnk, 'INSERT INTO checklist_items (created, modified, user_id, card_id, name, checklist_id, position) SELECT created, modified, user_id, $1, name , $2,  position FROM checklist_items WHERE checklist_id = $3 ORDER BY id', $qry_val_arr);
                        $i++;
                        $checklist_items = pg_fetch_assoc($items);
                        $qry_val_arr = array(
                            0,
                            $checklist_items['id']
                        );
                        $sql = pg_query_params($db_lnk, "UPDATE checklist_items SET is_completed = $1 WHERE id = $2", $qry_val_arr);
                    }
                }
                if (!empty($r_post['cards_custom_fields_card_id']) && is_plugin_enabled('r_custom_fields')) {
                    $custom_fields = explode(',', $r_post['cards_custom_fields_id']);
                    if (!empty($custom_fields) && !empty($r_post['cards_custom_fields_id'])) {
                        foreach ($custom_fields as $key => $value) {
                            $qry_val_arr = array(
                                $response['id'],
                                $r_post['list_id'],
                                $r_post['board_id'],
                                $r_post['cards_custom_fields_card_id'],
                                $value
                            );
                            pg_query_params($db_lnk, 'INSERT INTO cards_custom_fields (created, modified, card_id, custom_field_id, value, is_active, board_id, list_id) SELECT created, modified, $1, custom_field_id, value, is_active, $2, $3 FROM cards_custom_fields WHERE card_id = $4 AND custom_field_id = $5 ORDER BY id', $qry_val_arr);
                        };
                    } else {
                        $qry_val_arr = array(
                            $response['id'],
                            $r_post['list_id'],
                            $r_post['board_id'],
                            $r_post['cards_custom_fields_card_id']
                        );
                        pg_query_params($db_lnk, 'INSERT INTO cards_custom_fields (created, modified, card_id, custom_field_id, value, is_active, board_id, list_id) SELECT created, modified, $1, custom_field_id, value, is_active, $2, $3 FROM cards_custom_fields WHERE card_id = $4 ORDER BY id', $qry_val_arr);
                    }
                }
                $qry_val_arr = array(
                    $response['id']
                );
                $cards_users = pg_query_params($db_lnk, 'SELECT * FROM cards_users_listing WHERE card_id = $1', $qry_val_arr);
                while ($cards_user = pg_fetch_assoc($cards_users)) {
                    $response['cards_users'][] = $cards_user;
                }
                $qry_val_arr = array(
                    $response['id']
                );
                $cards_labels = pg_query_params($db_lnk, 'SELECT * FROM cards_labels_listing WHERE card_id = $1', $qry_val_arr);
                while ($cards_label = pg_fetch_assoc($cards_labels)) {
                    $response['cards_labels'][] = $cards_label;
                }
                $qry_val_arr = array(
                    $response['id']
                );
                $cards_checklists = pg_query_params($db_lnk, 'SELECT * FROM checklists_listing WHERE card_id = $1', $qry_val_arr);
                while ($cards_checklist = pg_fetch_assoc($cards_checklists)) {
                    $response['cards_checklists'][] = $cards_checklist;
                }
                if (!empty($r_post['cards_custom_fields_card_id']) && is_plugin_enabled('r_custom_fields')) {
                    $obj['custom_fields'] = array();
                    $conditions = array(
                        $foreign_ids['board_id']
                    );
                    $custom_fields = pg_query_params($db_lnk, 'SELECT * FROM custom_fields_listing WHERE board_id IS NULL or board_id = $1 ORDER BY position ASC', $conditions);
                    while ($custom_field = pg_fetch_assoc($custom_fields)) {
                        $response['cards_custom_fields'][] = $custom_field;
                    }
                }
            }
        }
        echo json_encode($response);
        break;

    case '/boards/?/lists/?/cards/?/comments':
        $is_return_vlaue = true;
        $table_name = 'activities';
        $sql = true;
        $prev_message = array();
        if (isset($r_post['root']) && !empty($r_post['root'])) {
            $qry_val_arr = array(
                $r_post['root']
            );
            $prev_message = executeQuery('SELECT ac.*, u,username, u.profile_picture_path, u.initials, u.full_name FROM activities ac LEFT JOIN users u ON ac.user_id = u.id WHERE ac.id = $1 order by created DESC', $qry_val_arr);
        }
        $r_post['freshness_ts'] = date('Y-m-d H:i:s');
        $r_post['type'] = 'add_comment';
        $r_post['token'] = $_GET['token'];
        if (empty($r_post['user_id'])) {
            $r_post['user_id'] = $authUser['id'];
        }
        if (empty($r_post['card_id'])) {
            $r_post['card_id'] = $r_resource_vars['cards'];
        }
        if (empty($r_post['list_id'])) {
            $r_post['list_id'] = $r_resource_vars['lists'];
        }
        if (empty($r_post['board_id'])) {
            $r_post['board_id'] = $r_resource_vars['boards'];
        }
        $revision = '';
        $revisions['old_value']['comment'] = $r_post['comment'];
        $r_post['revisions'] = serialize($revisions);
        if (!empty($sql)) {
            $post = getbindValues($table_name, $r_post);
            $result = pg_execute_insert($table_name, $post);
            if ($result) {
                $comment = $r_post['comment'];
                preg_match_all("/(?<!\w)@\w+/", $comment, $added_users);
                foreach ($added_users[0] as $username) {
                    $username = substr($username, 1, strlen($username));
                    $qry_val_arr = array(
                        $username
                    );
                    $user = executeQuery('SELECT id FROM users WHERE username = $1', $qry_val_arr);
                    if (!empty($user)) {
                        $qry_val_arr = array(
                            $r_post['card_id'],
                            $user['id']
                        );
                        $card_subscribed = executeQuery('DELETE FROM card_subscribers WHERE id = (SELECT id FROM card_subscribers WHERE card_id = $1 and user_id = $2)', $qry_val_arr);
                        $qry_val_arr = array(
                            $r_post['card_id'],
                            $user['id'],
                            true
                        );
                        pg_query_params($db_lnk, 'INSERT INTO card_subscribers (created, modified, card_id , user_id, is_subscribed) VALUES (now(), now(), $1, $2, $3)', $qry_val_arr);
                    }
                }
                $row = pg_fetch_assoc($result);
                $response['activities']['created'] = $row['created'];
                $response['id'] = $row['id'];
                $conditions = array(
                    $r_post['card_id']
                );
                $activity_count = executeQuery("SELECT COUNT(id) as total_count FROM activities WHERE type = 'add_comment' AND card_id = $1", $conditions);
                $activity_count = (!empty($activity_count)) ? $activity_count['total_count'] : 0;
                $qry_val_arr = array(
                    $activity_count,
                    $r_post['card_id']
                );
                pg_query_params($db_lnk, 'UPDATE cards SET comment_count = $1 WHERE id = $2', $qry_val_arr);
                $id_converted = base_convert($response['id'], 10, 36);
                $materialized_path = sprintf("%08s", $id_converted);
                if (!empty($prev_message['materialized_path'])) {
                    $materialized_path = $prev_message['materialized_path'] . '-' . $materialized_path;
                }
                if (!empty($prev_message['path'])) {
                    $path = $prev_message['path'] . '.P' . $response['id'];
                    $depth = $prev_message['depth'] + 1;
                    $root = $prev_message['root'];
                } else {
                    $path = 'P' . $response['id'];
                    $depth = 0;
                    $root = $response['id'];
                }
                $response['activities']['depth'] = $depth;
                $response['activities']['path'] = $path;
                $qry_val_arr = array(
                    $materialized_path,
                    $path,
                    $depth,
                    $root,
                    $response['id']
                );
                pg_query_params($db_lnk, 'UPDATE activities SET materialized_path = $1, path = $2, depth = $3, root = $4 WHERE id = $5', $qry_val_arr);
                $qry_val_arr = array(
                    $root
                );
                pg_query_params($db_lnk, 'UPDATE activities SET freshness_ts =  now() WHERE root = $1', $qry_val_arr);
                $qry_val_arr = array(
                    $root
                );
                $act_res = pg_query_params($db_lnk, 'SELECT * FROM activities WHERE root = $1', $qry_val_arr);
                $response['activity'] = pg_fetch_assoc($act_res);
            }
        }
        echo json_encode($response);
        break;

    case '/boards/?/lists/?/cards/?/card_subscribers':
        $table_name = 'card_subscribers';
        $json = true;
        $r_post['user_id'] = $authUser['id'];
        unset($r_post['list_id']);
        unset($r_post['board_id']);
        $qry_val_arr = array(
            $r_resource_vars['cards'],
            $r_post['user_id']
        );
        $s_result = pg_query_params($db_lnk, 'SELECT id, is_subscribed FROM card_subscribers WHERE card_id = $1 and user_id = $2', $qry_val_arr);
        $check_subscribed = pg_fetch_assoc($s_result);
        if (!empty($check_subscribed)) {
            $is_subscribed = ($r_post['is_subscribed']) ? 'true' : 'false';
            $qry_val_arr = array(
                $is_subscribed,
                $r_resource_vars['cards'],
                $r_post['user_id']
            );
            $s_result = pg_query_params($db_lnk, 'UPDATE card_subscribers SET is_subscribed = $1 WHERE card_id = $2 and user_id = $3 RETURNING id', $qry_val_arr);
            $subscribe = pg_fetch_assoc($s_result);
            $response['id'] = $subscribe['id'];
            if ($sql && ($sql !== true) && !empty($json) && !empty($response['id'])) {
                if ($result = pg_query_params($db_lnk, $sql, array())) {
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
            $response['id'] = $check_subscribed['id'];
            echo json_encode($response);
        } else {
            $r_post['card_id'] = $r_resource_vars['cards'];
            $r_post['user_id'] = $r_post['user_id'];
            $sql = true;
            if (!empty($sql)) {
                $post = getbindValues($table_name, $r_post);
                $result = pg_execute_insert($table_name, $post);
                if ($result) {
                    $row = pg_fetch_assoc($result);
                    $response['id'] = $row['id'];
                }
            }
            echo json_encode($response);
        }
        break;

    case '/boards/?/lists/?/cards/?/multiple-attachments':
        $is_return_vlaue = true;
        $table_name = 'card_attachments';
        $r_post['card_id'] = $r_resource_vars['cards'];
        $r_post['list_id'] = $r_resource_vars['lists'];
        $r_post['board_id'] = $r_resource_vars['boards'];
        $mediadir = MEDIA_PATH . DS . 'Card' . DS . $r_resource_vars['cards'];
        $save_path = 'Card' . DS . $r_resource_vars['cards'];
        $save_path = str_replace('\\', '/', $save_path);
        if (!empty($_FILES['attachments']) && $_FILES['attachment']['error'] == 0) {
            $file = $_FILES['attachments'];
            $file_count = $_POST['total_attachment'];
            for ($i = 0; $i < $file_count; $i++) {
                if ($file['name'][$i] != 'undefined') {
                    if (!file_exists($mediadir)) {
                        mkdir($mediadir, 0777, true);
                    }
                    $cur_os = strtolower(PHP_OS);
                    if (substr($cur_os, 0, 3) === 'win') {
                        $file['name'][$i] = urlencode($file['name'][$i]);
                    }
                    $file_arr = pathinfo($file['name'][$i]);
                    $filename_without_ext = $file_arr['filename'];
                    if (file_exists($mediadir . DS . $file['name'][$i])) {
                        $filename_without_ext = $file_arr['filename'] . '-' . mt_rand(0, 999);
                        $file['name'][$i] = $filename_without_ext . '.' . $file_arr['extension'];
                    }
                    if (is_uploaded_file($file['tmp_name'][$i]) && move_uploaded_file($file['tmp_name'][$i], $mediadir . DS . $file['name'][$i])) {
                        $r_post[$i]['path'] = $save_path . DS . $file['name'][$i];
                        $r_post[$i]['name'] = $file['name'][$i];
                        $r_post[$i]['mimetype'] = $file['type'][$i];
                        $qry_val_arr = array(
                            $r_post['card_id'],
                            $r_post[$i]['name'],
                            $r_post[$i]['path'],
                            $r_post['list_id'],
                            $r_post['board_id'],
                            $r_post[$i]['mimetype']
                        );
                        $s_result = pg_query_params($db_lnk, 'INSERT INTO card_attachments (created, modified, card_id, name, path, list_id, board_id, mimetype) VALUES (now(), now(), $1, $2, $3, $4, $5, $6) RETURNING *', $qry_val_arr);
                        $cardAttachment = $response['card_attachments'][$i] = pg_fetch_assoc($s_result);
                        if (class_exists('imagick') && in_array($file_arr['extension'], array(
                            'pdf'
                        ))) {
                            try {
                                $im = new Imagick($mediadir . DS . $file['name'][$i] . "[0]"); // 0-first page, 1-second page
                                $im->setImageColorspace(Imagick::COLORSPACE_RGB); // prevent image colors from inverting
                                $im->setimageformat('png');
                                $im->thumbnailimage(200, 150); // width and height
                                $target_hash = md5(SECURITYSALT . 'CardAttachment' . $cardAttachment['id'] . 'png' . 'original');
                                $target_dir = IMG_PATH . DS . 'original' . DS . 'CardAttachment';
                                $target = $target_dir . DS . $cardAttachment['id'] . '.' . $target_hash . '.png';
                                if (!file_exists($target_dir)) {
                                    mkdir($target_dir, 0777, true);
                                }
                                $im->writeimage($target);
                                $im->clear();
                                $im->destroy();
                                $response['card_attachments'][$i]['doc_image_path'] = 'original' . DS . 'CardAttachment' . DS . $cardAttachment['id'] . '.' . $target_hash . '.png';
                                $qry_val_arr = array(
                                    $response['card_attachments'][$i]['doc_image_path'],
                                    $cardAttachment['id']
                                );
                                pg_query_params($db_lnk, 'UPDATE card_attachments SET doc_image_path = $1 WHERE id = $2', $qry_val_arr);
                            }
                            catch(Exception $e) {
                            }
                        }
                        $foreign_ids['board_id'] = $r_resource_vars['boards'];
                        $foreign_ids['list_id'] = $r_resource_vars['lists'];
                        $foreign_ids['card_id'] = $r_resource_vars['cards'];
                        $comment = '##USER_NAME## added attachment to the card ##CARD_LINK##';
                        $response['activity'] = insertActivity($authUser['id'], $comment, 'add_card_attachment', $foreign_ids, null, $response['card_attachments'][$i]['id']);
                        foreach ($thumbsizes['CardAttachment'] as $key => $value) {
                            $imgdir = IMG_PATH . DS . $key . DS . 'CardAttachment' . DS . $response['card_attachments'][$i]['id'];
                            $list = glob($imgdir . '.*');
                            if (!empty($list) && isset($list[0]) && file_exists($list[0])) {
                                unlink($list[0]);
                            }
                        }
                    }
                }
            }
        }
        echo json_encode($response);
        break;

    case '/boards/?/lists/?/cards/?/card_voters':
        $table_name = 'card_voters';
        $r_post['card_id'] = $r_resource_vars['cards'];
        $r_post['user_id'] = $authUser['id'];
        $qry_val_arr = array(
            $r_post['card_id'],
            $r_post['user_id']
        );
        $check_already_added = executeQuery('SELECT * FROM card_voters WHERE card_id = $1 AND user_id = $2', $qry_val_arr);
        if (!empty($check_already_added)) {
            $response['id'] = $check_already_added['id'];
            $response['cards_voters'] = $check_already_added;
            $sql = false;
            echo json_encode($response);
        } else {
            $sql = true;
            if (!empty($sql)) {
                $post = getbindValues($table_name, $r_post);
                $result = pg_execute_insert($table_name, $post);
                if ($result) {
                    $row = pg_fetch_assoc($result);
                    $response['id'] = $row['id'];
                    $foreign_ids['board_id'] = $r_resource_vars['boards'];
                    $foreign_ids['list_id'] = $r_resource_vars['lists'];
                    $foreign_ids['card_id'] = $r_post['card_id'];
                    $comment = '##USER_NAME## voted on the card ##CARD_LINK##';
                    $response['activity'] = insertActivity($authUser['id'], $comment, 'add_card_voter', $foreign_ids, '', $response['id']);
                    $qry_val_arr = array(
                        $response['id']
                    );
                    $s_result = pg_query_params($db_lnk, 'SELECT * FROM card_voters_listing WHERE id = $1', $qry_val_arr);
                    $user = pg_fetch_assoc($s_result);
                    $response['card_voters'] = $user;
                }
            }
            echo json_encode($response);
        }
        break;

    case '/boards/?/lists/?/cards/?/attachments':
        $is_return_vlaue = true;
        $table_name = 'card_attachments';
        $r_post['card_id'] = $r_resource_vars['cards'];
        $r_post['list_id'] = $r_resource_vars['lists'];
        $r_post['board_id'] = $r_resource_vars['boards'];
        $mediadir = MEDIA_PATH . DS . 'Card' . DS . $r_resource_vars['cards'];
        $save_path = 'Card' . DS . $r_resource_vars['cards'];
        $save_path = str_replace('\\', '/', $save_path);
        if (!empty($_FILES['attachment']) && $_FILES['attachment']['error'] == 0) {
            if (!file_exists($mediadir)) {
                mkdir($mediadir, 0777, true);
            }
            $file = $_FILES['attachment'];
            $cur_os = strtolower(PHP_OS);
            if (substr($cur_os, 0, 3) === 'win') {
                $file['name'] = urlencode($file['name']);
            }
            $file_arr = pathinfo($file['name']);
            $filename_without_ext = $file_arr['filename'];
            if (file_exists($mediadir . DS . $file['name'])) {
                $filename_without_ext = $file_arr['filename'] . '-' . mt_rand(0, 999);
                $file['name'] = $filename_without_ext . '.' . $file_arr['extension'];
            }
            if (is_uploaded_file($file['tmp_name']) && move_uploaded_file($file['tmp_name'], $mediadir . DS . $file['name'])) {
                $r_post['path'] = $save_path . '/' . $file['name'];
                $r_post['name'] = $file['name'];
                $r_post['mimetype'] = $file['type'];
                $qry_val_arr = array(
                    $r_post['card_id'],
                    $r_post['name'],
                    $r_post['path'],
                    $r_post['list_id'],
                    $r_post['board_id'],
                    $r_post['mimetype']
                );
                $s_result = pg_query_params($db_lnk, 'INSERT INTO card_attachments (created, modified, card_id, name, path, list_id, board_id, mimetype) VALUES (now(), now(), $1, $2, $3, $4, $5, $6) RETURNING *', $qry_val_arr);
                $cardAttachment = $response['card_attachments'][0] = pg_fetch_assoc($s_result);
                if (class_exists('imagick') && in_array($file_arr['extension'], array(
                    'pdf'
                ))) {
                    $im = new Imagick($mediadir . DS . $file['name'] . "[0]"); // 0-first page, 1-second page
                    $im->setImageColorspace(Imagick::COLORSPACE_RGB); // prevent image colors from inverting
                    $im->setimageformat('png');
                    $im->thumbnailimage(200, 150); // width and height
                    $target_hash = md5(SECURITYSALT . 'CardAttachment' . $cardAttachment['id'] . 'png' . 'original');
                    $target_dir = IMG_PATH . DS . 'original' . DS . 'CardAttachment';
                    $target = $target_dir . DS . $cardAttachment['id'] . '.' . $target_hash . '.png';
                    if (!file_exists($target_dir)) {
                        mkdir($target_dir, 0777, true);
                    }
                    $im->writeimage($target);
                    $im->clear();
                    $im->destroy();
                    $response['card_attachments'][0]['doc_image_path'] = 'original' . DS . 'CardAttachment' . DS . $cardAttachment['id'] . '.' . $target_hash . '.png';
                    $qry_val_arr = array(
                        $response['card_attachments'][0]['doc_image_path'],
                        $cardAttachment['id']
                    );
                    pg_query_params($db_lnk, 'UPDATE card_attachments SET doc_image_path = $1 WHERE id = $2', $qry_val_arr);
                }
            }
            foreach ($thumbsizes['CardAttachment'] as $key => $value) {
                $mediadir = IMG_PATH . DS . $key . DS . 'CardAttachment' . DS . $response['card_attachments'][0]['id'];
                $list = glob($mediadir . '.*');
                if (!empty($list) && isset($list[0]) && file_exists($list[0])) {
                    unlink($list[0]);
                }
            }
            $foreign_ids['board_id'] = $r_resource_vars['boards'];
            $foreign_ids['list_id'] = $r_resource_vars['lists'];
            $foreign_ids['card_id'] = $r_resource_vars['cards'];
            $comment = '##USER_NAME## added attachment to the card ##CARD_LINK##';
            $response['activity'] = insertActivity($authUser['id'], $comment, 'add_card_attachment', $foreign_ids, null, $response['card_attachments'][0]['id']);
        } else if (!empty($_FILES['attachment']) && is_array($_FILES['attachment']['name']) && $_FILES['attachment']['error'][0] == 0) {
            $file = $_FILES['attachment'];
            $file_count = count($file['name']);
            for ($i = 0; $i < $file_count; $i++) {
                if ($file['name'][$i] != 'undefined') {
                    if (!file_exists($mediadir)) {
                        mkdir($mediadir, 0777, true);
                    }
                    $cur_os = strtolower(PHP_OS);
                    if (substr($cur_os, 0, 3) === 'win') {
                        $file['name'][$i] = urlencode($file['name'][$i]);
                    }
                    $file_arr = pathinfo($file['name'][$i]);
                    $filename_without_ext = $file_arr['filename'];
                    if (file_exists($mediadir . DS . $file['name'][$i])) {
                        $filename_without_ext = $file_arr['filename'] . '-' . mt_rand(0, 999);
                        $file['name'][$i] = $filename_without_ext . '.' . $file_arr['extension'];
                    }
                    if (is_uploaded_file($file['tmp_name'][$i]) && move_uploaded_file($file['tmp_name'][$i], $mediadir . DS . $file['name'][$i])) {
                        $r_post[$i]['path'] = $save_path . DS . $file['name'][$i];
                        $r_post[$i]['name'] = $file['name'][$i];
                        $r_post[$i]['mimetype'] = $file['type'][$i];
                        $qry_val_arr = array(
                            $r_post['card_id'],
                            $r_post[$i]['name'],
                            $r_post[$i]['path'],
                            $r_post['list_id'],
                            $r_post['board_id'],
                            $r_post[$i]['mimetype']
                        );
                        $s_result = pg_query_params($db_lnk, 'INSERT INTO card_attachments (created, modified, card_id, name, path, list_id, board_id, mimetype) VALUES (now(), now(), $1, $2, $3, $4, $5, $6) RETURNING *', $qry_val_arr);
                        $cardAttachment = $response['card_attachments'][$i] = pg_fetch_assoc($s_result);
                        if (class_exists('imagick') && in_array($file_arr['extension'], array(
                            'pdf'
                        ))) {
                            try {
                                $im = new Imagick($mediadir . DS . $file['name'][$i] . "[0]"); // 0-first page, 1-second page
                                $im->setImageColorspace(Imagick::COLORSPACE_RGB); // prevent image colors from inverting
                                $im->setimageformat('png');
                                $im->thumbnailimage(200, 150); // width and height
                                $target_hash = md5(SECURITYSALT . 'CardAttachment' . $cardAttachment['id'] . 'png' . 'original');
                                $target_dir = IMG_PATH . DS . 'original' . DS . 'CardAttachment';
                                $target = $target_dir . DS . $cardAttachment['id'] . '.' . $target_hash . '.png';
                                if (!file_exists($target_dir)) {
                                    mkdir($target_dir, 0777, true);
                                }
                                $im->writeimage($target);
                                $im->clear();
                                $im->destroy();
                                $response['card_attachments'][$i]['doc_image_path'] = 'original' . DS . 'CardAttachment' . DS . $cardAttachment['id'] . '.' . $target_hash . '.png';
                                $qry_val_arr = array(
                                    $response['card_attachments'][$i]['doc_image_path'],
                                    $cardAttachment['id']
                                );
                                pg_query_params($db_lnk, 'UPDATE card_attachments SET doc_image_path = $1 WHERE id = $2', $qry_val_arr);
                            }
                            catch(Exception $e) {
                            }
                        }
                        $foreign_ids['board_id'] = $r_resource_vars['boards'];
                        $foreign_ids['list_id'] = $r_resource_vars['lists'];
                        $foreign_ids['card_id'] = $r_resource_vars['cards'];
                        $comment = '##USER_NAME## added attachment to the card ##CARD_LINK##';
                        $response['activity'] = insertActivity($authUser['id'], $comment, 'add_card_attachment', $foreign_ids, null, $response['card_attachments'][$i]['id']);
                        foreach ($thumbsizes['CardAttachment'] as $key => $value) {
                            $imgdir = IMG_PATH . DS . $key . DS . 'CardAttachment' . DS . $response['card_attachments'][$i]['id'];
                            $list = glob($imgdir . '.*');
                            if (!empty($list) && isset($list[0]) && file_exists($list[0])) {
                                unlink($list[0]);
                            }
                        }
                    }
                }
            }
        } else if (isset($r_post['image_link']) && !empty($r_post['image_link'])) {
            if (!empty($r_post['image_link']) && is_array($r_post['image_link'])) {
                $i = 0;
                foreach ($r_post['image_link'] as $image_link) {
                    $r_post['name'] = $r_post['link'] = $image_link;
                    $qry_val_arr = array(
                        $r_post['card_id'],
                        $r_post['name'],
                        'NULL',
                        $r_post['list_id'],
                        $r_post['board_id'],
                        'NULL',
                        $r_post['link']
                    );
                    $s_result = pg_query_params($db_lnk, 'INSERT INTO card_attachments (created, modified, card_id, name, path, list_id, board_id, mimetype, link) VALUES (now(), now(), $1, $2, $3, $4, $5, $6, $7) RETURNING *', $qry_val_arr);
                    $response['card_attachments'][] = pg_fetch_assoc($s_result);
                    $foreign_ids['board_id'] = $r_resource_vars['boards'];
                    $foreign_ids['list_id'] = $r_resource_vars['lists'];
                    $foreign_ids['card_id'] = $r_resource_vars['cards'];
                    $comment = '##USER_NAME## added attachment to the card ##CARD_LINK##';
                    $response['activity'] = insertActivity($authUser['id'], $comment, 'add_card_attachment', $foreign_ids, null, $response['card_attachments'][$i]['id']);
                    $i++;
                }
            } else {
                $sql = true;
                $r_post['name'] = $r_post['link'] = $r_post['image_link'];
                $r_post['path'] = '';
                unset($r_post['image_link']);
                if (!empty($sql)) {
                    $post = getbindValues($table_name, $r_post);
                    $result = pg_execute_insert($table_name, $post);
                    if ($result) {
                        $row = pg_fetch_assoc($result);
                        $response['card_attachments'] = $row;
                        $foreign_ids['board_id'] = $r_post['board_id'];
                        $foreign_ids['list_id'] = $r_post['list_id'];
                        $foreign_ids['card_id'] = $r_post['card_id'];
                        $comment = '##USER_NAME## added attachment to the card ##CARD_LINK##';
                        $response['activity'] = insertActivity($authUser['id'], $comment, 'add_card_attachment', $foreign_ids, null, $row['id']);
                        foreach ($thumbsizes['CardAttachment'] as $key => $value) {
                            $mediadir = IMG_PATH . DS . $key . DS . 'CardAttachment' . DS . $row['id'];
                            $list = glob($mediadir . '.*');
                            if (!empty($list) && isset($list[0]) && file_exists($list[0])) {
                                unlink($list[0]);
                            }
                        }
                    }
                }
            }
        }
        echo json_encode($response);
        break;

    case '/boards/?/lists/?/cards/?/labels':
        $is_return_vlaue = true;
        $table_name = 'cards_labels';
        $r_post['card_id'] = $r_resource_vars['cards'];
        $r_post['list_id'] = $r_resource_vars['lists'];
        $r_post['board_id'] = $r_resource_vars['boards'];
        $qry_val_arr = array(
            $r_resource_vars['cards']
        );
        $previous_label_results = pg_query_params($db_lnk, 'SELECT l.name FROM labels l inner join cards_labels cl on cl.label_id = l.id WHERE card_id = $1', $qry_val_arr);
        $previous_cards_labels = array();
        while ($previous_label_result = pg_fetch_assoc($previous_label_results)) {
            $previous_cards_labels[] = $previous_label_result['name'];
        }
        $label_names = pg_query_params($db_lnk, 'SELECT l.name FROM labels l inner join cards_labels cl on cl.label_id = l.id WHERE card_id = $1', $qry_val_arr);
        $delete_labels = pg_query_params($db_lnk, 'DELETE FROM ' . $table_name . ' WHERE card_id = $1 RETURNING label_id', $qry_val_arr);
        $delete_label = pg_fetch_assoc($delete_labels);
        $delete_labels_count = pg_affected_rows($delete_labels);
        $names = '';
        if (!empty($r_post['name'])) {
            $label_names = explode(',', $r_post['name']);
            $oldlabel = array();
            $newlabel = array();
            foreach ($label_names as $label_name) {
                if (in_array($label_name, $previous_cards_labels)) {
                    $oldlabel[] = $label_name;
                } else {
                    $newlabel[] = $label_name;
                }
                $names.= $label_name . ', ';
                $qry_val_arr = array(
                    $label_name
                );
                $s_result = pg_query_params($db_lnk, 'SELECT id FROM labels WHERE name = $1', $qry_val_arr);
                $label = pg_fetch_assoc($s_result);
                if (empty($label)) {
                    $qry_val_arr = array(
                        $label_name
                    );
                    $s_result = pg_query_params($db_lnk, 'INSERT INTO labels (created, modified, name) VALUES (now(), now(), $1) RETURNING id', $qry_val_arr);
                    $label = pg_fetch_assoc($s_result);
                }
                $r_post['label_id'] = $label['id'];
                $qry_val_arr = array(
                    $r_post['card_id'],
                    $r_post['label_id'],
                    $r_post['board_id'],
                    $r_post['list_id']
                );
                pg_query_params($db_lnk, 'INSERT INTO ' . $table_name . ' (created, modified, card_id, label_id, board_id, list_id) VALUES (now(), now(), $1, $2, $3, $4) RETURNING *', $qry_val_arr);
            }
            $qry_val_arr = array(
                $r_post['card_id']
            );
            $s_result = pg_query_params($db_lnk, 'SELECT * FROM cards_labels_listing WHERE card_id = $1 ORDER BY id ASC', $qry_val_arr);
            $cards_labels = pg_fetch_all($s_result);
            $response['cards_labels'] = $cards_labels;
            if (count($newlabel) && !count(array_diff($previous_cards_labels, $oldlabel))) {
                $names = implode(",", $newlabel);
                $names = preg_replace('/[ ,]+/', ', ', $names);
                $comment = '##USER_NAME## added label(s) to the card ##CARD_LINK## - ' . $names;
                $type = 'add_card_label';
            } else if (!count($newlabel) && count(array_diff($previous_cards_labels, $oldlabel))) {
                $names = implode(",", array_diff($previous_cards_labels, $oldlabel));
                $names = preg_replace('/[ ,]+/', ', ', $names);
                $comment = '##USER_NAME## removed label(s) to the card ##CARD_LINK## - ' . $names;
                $type = 'update_card_label';
            } else if (count($newlabel) && count(array_diff($previous_cards_labels, $oldlabel))) {
                $deletenames = implode(",", array_diff($previous_cards_labels, $oldlabel));
                $names = implode(",", $newlabel);
                $names = preg_replace('/[ ,]+/', ', ', $names);
                $comment = '##USER_NAME## removed the label(s) ' . ' - ' . $deletenames . ' and added the label(s) ' . ' - ' . $names . ' to the card ##CARD_LINK##';
                $type = 'update_card_label';
            } else {
                echo json_encode("Success");
                break;
            }
        } else {
            $response['cards_labels'] = array();
            while ($labels_data = pg_fetch_assoc($label_names)) {
                $names.= $labels_data['name'] . ', ';
            }
            $names = substr($names, 0, -2);
            $comment = '##USER_NAME## removed label(s) in the card ##CARD_LINK## - ' . $names;
            $r_post['label_id'] = $delete_label['label_id'];
            $type = 'delete_card_label';
        }
        $foreign_ids['board_id'] = $r_post['board_id'];
        $foreign_ids['list_id'] = $r_post['list_id'];
        $foreign_ids['card_id'] = $r_post['card_id'];
        $response['activity'] = insertActivity($authUser['id'], $comment, $type, $foreign_ids, null, $r_post['label_id']);
        echo json_encode($response);
        break;

    case '/boards/?/lists/?/cards/?/checklists':
        $sql = true;
        $table_name = 'checklists';
        $r_post['user_id'] = $authUser['id'];
        $r_post['card_id'] = $r_resource_vars['cards'];
        if (isset($r_post['checklist_id'])) {
            $checklist_id = $r_post['checklist_id'];
            unset($r_post['checklist_id']);
        }
        if (!empty($sql)) {
            $post = getbindValues($table_name, $r_post);
            $result = pg_execute_insert($table_name, $post);
            if ($result) {
                $row = pg_fetch_assoc($result);
                $response['id'] = $row['id'];
                if (isset($checklist_id) && !empty($checklist_id)) {
                    $qry_val_arr = array(
                        $r_post['user_id'],
                        $response['id'],
                        $checklist_id,
                        $r_post['card_id']
                    );
                    pg_query_params($db_lnk, 'INSERT INTO checklist_items (created, modified, user_id, card_id, checklist_id, name, is_completed, position) SELECT created, modified, $1, $4, $2, name, false, position FROM checklist_items WHERE checklist_id = $3', $qry_val_arr);
                }
                $qry_val_arr = array(
                    $response['id']
                );
                $result = pg_query_params($db_lnk, 'SELECT * FROM checklists_listing WHERE id = $1', $qry_val_arr);
                $response['checklist'] = pg_fetch_assoc($result);
                $response['checklist']['checklists_items'] = json_decode($response['checklist']['checklists_items'], true);
                $foreign_ids['board_id'] = $r_resource_vars['boards'];
                $foreign_ids['list_id'] = $r_resource_vars['lists'];
                $foreign_ids['card_id'] = $r_resource_vars['cards'];
                $comment = '##USER_NAME## added checklist ' . $response['checklist']['name'] . ' to the card ##CARD_LINK##';
                $response['activity'] = insertActivity($authUser['id'], $comment, 'add_card_checklist', $foreign_ids, '', $response['id']);
            }
        }
        echo json_encode($response);
        break;

    case '/boards/?/lists/?/cards/?/checklists/?/items':
        $table_name = 'checklist_items';
        $is_return_vlaue = true;
        $r_post['user_id'] = $authUser['id'];
        $r_post['card_id'] = $r_resource_vars['cards'];
        $r_post['checklist_id'] = $r_resource_vars['checklists'];
        unset($r_post['created']);
        unset($r_post['modified']);
        unset($r_post['is_offline']);
        unset($r_post['list_id']);
        unset($r_post['board_id']);
        $names = explode("\n", $r_post['name']);
        foreach ($names as $name) {
            $r_post['name'] = trim($name);
            if (isset($r_post['name'])) {
                $qry_val_arr = array(
                    $r_post['checklist_id']
                );
                $position = executeQuery('SELECT max(position) as position FROM checklist_items WHERE checklist_id = $1', $qry_val_arr);
                $checklist_name = executeQuery('SELECT name FROM checklists WHERE id = $1', $qry_val_arr);
                $r_post['position'] = $position['position'];
                if (empty($r_post['position'])) {
                    $r_post['position'] = 0;
                }
                $r_post['position']+= 1;
                if (empty($r_post['member'])) {
                    unset($r_post['member']);
                }
                unset($r_post['checklist_items']);
                $result = pg_execute_insert($table_name, $r_post);
                $item = pg_fetch_assoc($result);
                $response[$table_name][] = $item;
                $foreign_ids['board_id'] = $r_resource_vars['boards'];
                $foreign_ids['list_id'] = $r_resource_vars['lists'];
                $foreign_ids['card_id'] = $r_post['card_id'];
                $comment = '##USER_NAME## added item ' . $r_post['name'] . ' in checklist ' . $checklist_name['name'] . ' of the card ##CARD_LINK##';
                $response['activities'][] = insertActivity($authUser['id'], $comment, 'add_checklist_item', $foreign_ids, '', $item['id']);
            }
        }
        echo json_encode($response);
        break;

    case '/boards/?/lists/?/cards/?/checklists/?/items/?/convert_to_card':
        $is_return_vlaue = true;
        $table_name = 'cards';
        $qry_val_arr = array(
            $r_resource_vars['items']
        );
        $result = pg_query_params($db_lnk, 'SELECT name FROM checklist_items WHERE id = $1', $qry_val_arr);
        $row = pg_fetch_assoc($result);
        $qry_val_arr = array(
            $r_resource_vars['items']
        );
        pg_query_params($db_lnk, 'DELETE FROM checklist_items WHERE id = $1', $qry_val_arr);
        $r_post['board_id'] = $r_resource_vars['boards'];
        $r_post['list_id'] = $r_resource_vars['lists'];
        $r_post['name'] = $row['name'];
        $qry_val_arr = array(
            $r_post['list_id']
        );
        $sresult = pg_query_params($db_lnk, 'SELECT max(position) as position FROM cards WHERE list_id = $1', $qry_val_arr);
        $srow = pg_fetch_assoc($sresult);
        $r_post['position'] = $srow['position'];
        $r_post['user_id'] = $authUser['id'];
        $sql = true;
        if (!empty($sql)) {
            $post = getbindValues($table_name, $r_post);
            $result = pg_execute_insert($table_name, $post);
            if ($result) {
                $row = pg_fetch_assoc($result);
                $response['id'] = $row['id'];
                if ($is_return_vlaue) {
                    $row = convertBooleanValues($table_name, $row);
                    $response[$table_name] = $row;
                }
                $qry_val_arr = array(
                    $r_post['list_id']
                );
                $s_result = pg_query_params($db_lnk, 'SELECT name FROM lists WHERE id = $1', $qry_val_arr);
                $list = pg_fetch_assoc($s_result);
                $foreign_ids['board_id'] = $r_post['board_id'];
                $foreign_ids['card_id'] = $response['id'];
                $foreign_ids['list_id'] = $r_post['list_id'];
                $comment = '##USER_NAME## converted this checklist item ' . $row['name'] . ' to the card ##CARD_LINK## to list ##LIST_NAME##';
                insertActivity($authUser['id'], $comment, 'convert_card', $foreign_ids, null, $r_resource_vars['items']);
                if (!empty($r_post['members'])) {
                    foreach ($r_post['members'] as $member) {
                        $s_usql = 'INSERT INTO cards_users (created, modified, card_id, user_id) VALUES(now(), now(), ' . $response['id'] . ', ' . $member . ') RETURNING id';
                        $s_result = pg_query_params($db_lnk, $s_usql, array());
                        $card_user = pg_fetch_assoc($s_result);
                        $qry_val_arr = array(
                            $member
                        );
                        $_user = executeQuery('SELECT username FROM users WHERE id = $1', $qry_val_arr);
                        $comment = '##USER_NAME## added "' . $_user['username'] . '" as member to the card ##CARD_LINK##';
                        $response['activity'] = insertActivity($authUser['id'], $comment, 'add_card_user', $foreign_ids, '', $card_user['id']);
                    }
                }
                $qry_val_arr = array(
                    $response['id']
                );
                $cards_users = pg_query_params($db_lnk, 'SELECT * FROM cards_users_listing WHERE card_id = $1', $qry_val_arr);
                while ($cards_user = pg_fetch_assoc($cards_users)) {
                    $response['cards_users'][] = $cards_user;
                }
                if (!empty($r_post['labels'])) {
                    $r_post['card_labels'] = $r_post['labels'];
                }
                $names = '';
                if (!empty($r_post['card_labels'])) {
                    $label_names = explode(',', $r_post['card_labels']);
                    foreach ($label_names as $label_name) {
                        $names.= $label_name . ', ';
                        $qry_val_arr = array(
                            $label_name
                        );
                        $s_result = pg_query_params($db_lnk, 'SELECT id FROM labels WHERE name = $1', $qry_val_arr);
                        $label = pg_fetch_assoc($s_result);
                        if (empty($label)) {
                            $qry_val_arr = array(
                                $label_name
                            );
                            $s_result = pg_query_params($db_lnk, $s_sql = 'INSERT INTO labels (created, modified, name) VALUES (now(), now(), $1) RETURNING id', $qry_val_arr);
                            $label = pg_fetch_assoc($s_result);
                        }
                        $r_post['label_id'] = $label['id'];
                        $r_post['card_id'] = $row['id'];
                        $r_post['list_id'] = $row['list_id'];
                        $r_post['board_id'] = $row['board_id'];
                        $qry_val_arr = array(
                            $r_post['card_id'],
                            $r_post['label_id'],
                            $r_post['board_id'],
                            $r_post['list_id']
                        );
                        pg_query_params($db_lnk, 'INSERT INTO cards_labels (created, modified, card_id, label_id, board_id, list_id) VALUES (now(), now(), $1, $2, $3, $4) RETURNING *', $qry_val_arr);
                    }
                    $comment = '##USER_NAME## added label(s) to the card ##CARD_LINK## - ' . $names;;
                    insertActivity($authUser['id'], $comment, 'add_card_label', $foreign_ids, null, $r_post['label_id']);
                }
                $qry_val_arr = array(
                    $response['id']
                );
                $cards_labels = pg_query_params($db_lnk, 'SELECT * FROM cards_labels_listing WHERE card_id = $1', $qry_val_arr);
                while ($cards_label = pg_fetch_assoc($cards_labels)) {
                    $response['cards_labels'][] = $cards_label;
                }
            }
        }
        echo json_encode($response);
        break;

    case '/boards/?/lists/?/cards/?/users/?':
        $is_return_vlaue = true;
        $table_name = 'cards_users';
        unset($r_post['board_id']);
        unset($r_post['list_id']);
        unset($r_post['is_offline']);
        unset($r_post['profile_picture_path']);
        unset($r_post['username']);
        unset($r_post['initials']);
        $qry_val_arr = array(
            $r_resource_vars['cards'],
            $r_resource_vars['users']
        );
        $check_already_added = executeQuery('SELECT * FROM cards_users WHERE card_id = $1 AND user_id = $2', $qry_val_arr);
        if (!empty($check_already_added)) {
            $response['id'] = $check_already_added['id'];
            $response['cards_users'] = $check_already_added;
        } else {
            $sql = true;
            if (!empty($sql)) {
                $post = getbindValues($table_name, $r_post);
                $result = pg_execute_insert($table_name, $post);
                if ($result) {
                    $row = pg_fetch_assoc($result);
                    $response['id'] = $row['id'];
                    $qry_val_arr = array(
                        $r_resource_vars['cards']
                    );
                    $board = executeQuery('SELECT b.auto_subscribe_on_card FROM cards c left join boards b on b.id = c.board_id WHERE c.id = $1', $qry_val_arr);
                    if (!empty($board) && ($board['auto_subscribe_on_card'] === 't')) {
                        $qry_val_arr = array(
                            $r_post['card_id'],
                            $r_post['user_id'],
                            true
                        );
                        pg_query_params($db_lnk, 'INSERT INTO card_subscribers (created, modified, card_id , user_id, is_subscribed) VALUES (now(), now(), $1, $2, $3)', $qry_val_arr);
                    }
                    if ($is_return_vlaue) {
                        $row = convertBooleanValues($table_name, $row);
                        $response[$table_name] = $row;
                    }
                    $qry_val_arr = array(
                        $r_post['card_id'],
                        $r_post['user_id']
                    );
                    $sel_query = 'SELECT cu.card_id, cu.user_id, users.username, c.board_id, c.list_id, b.name as board_name FROM cards_users cu LEFT JOIN cards c ON cu.card_id = c.id LEFT JOIN users ON cu.user_id = users.id LEFT JOIN boards b ON c.board_id = b.id WHERE cu.card_id = $1 AND cu.user_id = $2';
                    $get_details = pg_query_params($db_lnk, $sel_query, $qry_val_arr);
                    $sel_details = pg_fetch_assoc($get_details);
                    $foreign_ids['board_id'] = $sel_details['board_id'];
                    $foreign_ids['list_id'] = $sel_details['list_id'];
                    $foreign_ids['card_id'] = $r_post['card_id'];
                    $comment = '##USER_NAME## added "' . $sel_details['username'] . '" as member to the card ##CARD_LINK##';
                    $response['activity'] = insertActivity($authUser['id'], $comment, 'add_card_user', $foreign_ids, '', $response['id']);
                }
            }
        }
        echo json_encode($response);
        break;

    case '/boards/?/lists/?/cards/?/copy':
        $is_return_vlaue = true;
        $r_post['user_id'] = $authUser['id'];
        $table_name = 'cards';
        if (isset($r_post['keep_attachments'])) {
            $is_keep_attachment = $r_post['keep_attachments'];
            unset($r_post['keep_attachments']);
        }
        if (isset($r_post['keep_activities'])) {
            $is_keep_activity = $r_post['keep_activities'];
            unset($r_post['keep_activities']);
        }
        if (isset($r_post['keep_labels'])) {
            $is_keep_label = $r_post['keep_labels'];
            unset($r_post['keep_labels']);
        }
        if (isset($r_post['keep_users'])) {
            $is_keep_user = $r_post['keep_users'];
            unset($r_post['keep_users']);
        }
        if (isset($r_post['keep_checklists'])) {
            $is_keep_checklist = $r_post['keep_checklists'];
            unset($r_post['keep_checklists']);
        }
        if (isset($r_post['keep_custom_fields'])) {
            $is_keep_custom_fields = $r_post['keep_custom_fields'];
            unset($r_post['keep_custom_fields']);
        }
        $copied_card_id = $r_resource_vars['cards'];
        unset($r_post['copied_card_id']);
        $qry_val_arr = array(
            $copied_card_id
        );
        $sresult = pg_query_params($db_lnk, 'SELECT * FROM cards WHERE id = $1', $qry_val_arr);
        $srow = pg_fetch_assoc($sresult);
        unset($srow['id']);
        $card_name = $r_post['name'];
        $r_post = array_merge($srow, $r_post);
        $r_post['name'] = $card_name;
        $conditions = array(
            $r_post['list_id'],
            '0'
        );
        $list_card_objs = pg_query_params($db_lnk, 'SELECT * FROM cards_listing WHERE list_id = $1 AND is_archived = $2 ORDER BY position ASC', $conditions);
        $list_cards = array();
        $h = 1;
        while ($card = pg_fetch_assoc($list_card_objs)) {
            $list_cards[$h] = $card;
            $h++;
        }
        if (isset($list_cards[$r_post['position']]) && isset($list_cards[$r_post['position'] - 1])) {
            $r_post['position'] = ($list_cards[$r_post['position']]['position'] + $list_cards[$r_post['position'] - 1]['position']) / 2;
        } else if (!isset($list_cards[$r_post['position']]) && isset($list_cards[$r_post['position'] - 1])) {
            $r_post['position'] = $list_cards[$r_post['position'] - 1]['position'] + 1;
        } else if (isset($list_cards[$r_post['position']]) && !isset($list_cards[$r_post['position'] - 1])) {
            $r_post['position'] = $list_cards[$r_post['position']]['position'] / 2;
        } else if (!isset($list_cards[$r_post['position']]) && !isset($list_cards[$r_post['position'] - 1])) {
            $r_post['position'] = 1;
        }
        $sql = true;
        if (!empty($sql)) {
            $r_post['card_voter_count'] = NULL;
            $r_post['cards_subscriber_count'] = NULL;
            if ($is_keep_attachment == 'undefined') {
                $r_post['attachment_count'] = NULL;
            }
            if ($is_keep_activity == 'undefined') {
                $r_post['comment_count'] = NULL;
            }
            if ($is_keep_label == 'undefined') {
                $r_post['label_count'] = NULL;
            }
            if ($is_keep_user == 'undefined') {
                $r_post['cards_user_count'] = NULL;
            }
            if ($is_keep_checklist == 'undefined') {
                $r_post['checklist_count'] = NULL;
                $r_post['checklist_item_count'] = NULL;
                $r_post['checklist_item_completed_count'] = NULL;
            }
            $post = getbindValues($table_name, $r_post);
            $result = pg_execute_insert($table_name, $post);
            if ($result) {
                $row = pg_fetch_assoc($result);
                $response['id'] = $row['id'];
                if ($is_return_vlaue) {
                    $row = convertBooleanValues($table_name, $row);
                    $response[$table_name] = $row;
                }
                if ($is_keep_attachment) {
                    $qry_val_arr = array(
                        $response['id'],
                        $r_post['list_id'],
                        $r_post['board_id'],
                        $copied_card_id
                    );
                    pg_query_params($db_lnk, 'INSERT INTO card_attachments (created, modified, card_id, name, path, mimetype, list_id, board_id) SELECT created, modified, $1, name, path, mimetype, $2, $3 FROM card_attachments WHERE card_id = $4 ORDER BY id', $qry_val_arr);
                }
                if ($is_keep_user) {
                    $qry_val_arr = array(
                        $response['id'],
                        $copied_card_id
                    );
                    pg_query_params($db_lnk, 'INSERT INTO cards_users (created, modified, card_id, user_id) SELECT created, modified, $1, user_id  FROM cards_users WHERE card_id = $2 ORDER BY id', $qry_val_arr);
                }
                if ($is_keep_label) {
                    $qry_val_arr = array(
                        $response['id'],
                        $r_post['list_id'],
                        $r_post['board_id'],
                        $copied_card_id
                    );
                    pg_query_params($db_lnk, 'INSERT INTO cards_labels (created, modified, card_id, label_id, list_id, board_id) SELECT created, modified, $1, label_id, $2, $3 FROM cards_labels WHERE card_id = $4 ORDER BY id', $qry_val_arr);
                }
                if (isset($is_keep_custom_fields)) {
                    if (is_plugin_enabled('r_custom_fields')) {
                        if ($r_post['board_id'] != $r_resource_vars['boards']) {
                            $customFields = array();
                            $qry_val_arr = array(
                                $r_resource_vars['boards'],
                            );
                            $custom_fields = pg_query_params($db_lnk, 'SELECT * FROM custom_fields WHERE board_id IS NULL or board_id = $1', $qry_val_arr);
                            while ($custom_field = pg_fetch_assoc($custom_fields)) {
                                if (!empty($custom_field['board_id'])) {
                                    $qry_val_arr = array(
                                        $r_post['board_id'],
                                        $custom_field['name']
                                    );
                                    $customField = executeQuery('SELECT * FROM custom_fields WHERE board_id = $1 AND name = $2', $qry_val_arr);
                                    if (empty($customField)) {
                                        $data = array(
                                            'user_id' => $authUser['id'],
                                            'type' => $custom_field['type'],
                                            'name' => $custom_field['name'],
                                            'description' => $custom_field['description'],
                                            'options' => $custom_field['options'],
                                            'label' => $custom_field['label'],
                                            'position' => $custom_field['position'],
                                            'visibility' => $custom_field['visibility'],
                                            'color' => $custom_field['color'],
                                            'board_id' => $r_post['board_id'],
                                        );
                                        $result = pg_execute_insert('custom_fields', $data);
                                        $row = pg_fetch_assoc($result);
                                        $customFields[$custom_field['id']] = (int)($row['id']);
                                    } else {
                                        $qry_val_arr = array(
                                            $r_resource_vars['boards'],
                                            $custom_field['name']
                                        );
                                        $previous_customField = executeQuery('SELECT * FROM custom_fields WHERE board_id = $1 AND name = $2', $qry_val_arr);
                                        if (!empty($previous_customField) && !empty($customField)) {
                                            if ($previous_customField['type'] === 'dropdown') {
                                                $new_customfield_options = explode(',', $customField['options']);
                                                $previous_customfield_options = explode(',', $previous_customField['options']);
                                                $new_unique_option = array_unique(array_merge($new_customfield_options, $previous_customfield_options));
                                                $data = array(
                                                    $customField['id'],
                                                    implode(',', $new_unique_option)
                                                );
                                                pg_query_params($db_lnk, 'UPDATE custom_fields SET options = $2 WHERE id = $1', $data);
                                            }
                                        }
                                        $customFields[$custom_field['id']] = $customField['id'];
                                    }
                                } else {
                                    $customFields[$custom_field['id']] = $custom_field['id'];
                                }
                            }
                            if (!empty($customFields)) {
                                $qry_val_arr = array(
                                    $copied_card_id
                                );
                                $cardsCustomFields = pg_query_params($db_lnk, 'SELECT * FROM cards_custom_fields WHERE card_id = $1 ORDER BY id', $qry_val_arr);
                                while ($cardsCustomField = pg_fetch_assoc($cardsCustomFields)) {
                                    if (isset($customFields[$cardsCustomField['custom_field_id']])) {
                                        $data = array(
                                            $response['id'],
                                            $customFields[$cardsCustomField['custom_field_id']],
                                            $cardsCustomField['value'],
                                            $cardsCustomField['is_active'],
                                            $r_post['board_id'],
                                            $r_post['list_id']
                                        );
                                        pg_query_params($db_lnk, 'INSERT INTO cards_custom_fields (created, modified, card_id, custom_field_id, value,is_active, board_id, list_id) VALUES (now(), now(), $1, $2, $3, $4, $5, $6)', $data);
                                    }
                                }
                            }
                        } else {
                            $qry_val_arr = array(
                                $response['id'],
                                $r_post['board_id'],
                                $r_post['list_id'],
                                $copied_card_id
                            );
                            pg_query_params($db_lnk, 'INSERT INTO cards_custom_fields (created, modified, card_id, custom_field_id, value,is_active,board_id,list_id) SELECT created, modified, $1, custom_field_id,value,is_active, $2, $3 FROM cards_custom_fields WHERE card_id = $4 ORDER BY id', $qry_val_arr);
                        }
                    }
                }
                if ($is_keep_activity) {
                    $qry_val_arr = array(
                        $response['id'],
                        $r_post['user_id'],
                        $r_post['list_id'],
                        $r_post['board_id'],
                        $copied_card_id,
                        $_GET['token']
                    );
                    pg_query_params($db_lnk, 'INSERT INTO activities (created, modified, card_id, user_id, list_id, board_id, foreign_id, token, type, comment, revisions, root, freshness_ts, depth, path, materialized_path) SELECT created, modified, $1, $2, $3, $4, foreign_id, $6, type, comment, revisions, root, freshness_ts, depth, path, materialized_path FROM activities WHERE type = \'add_comment\' AND card_id = $5 ORDER BY id', $qry_val_arr);
                }
                if ($is_keep_checklist) {
                    $qry_val_arr = array(
                        $response['id'],
                        $copied_card_id
                    );
                    pg_query_params($db_lnk, 'INSERT INTO checklists (created, modified, user_id, card_id, name, checklist_item_count, position) SELECT created, modified, user_id, $1, name, checklist_item_count, position FROM checklists WHERE card_id = $2 ORDER BY id', $qry_val_arr);
                    $qry_val_arr = array(
                        $response['id']
                    );
                    $checklists = pg_query_params($db_lnk, 'SELECT id FROM checklists WHERE card_id = $1 order by id', $qry_val_arr);
                    $qry_val_arr = array(
                        $copied_card_id
                    );
                    $prev_checklists = pg_query_params($db_lnk, 'SELECT id FROM checklists WHERE card_id = $1 order by id', $qry_val_arr);
                    $prev_checklist_ids = array();
                    while ($prev_checklist_id = pg_fetch_assoc($prev_checklists)) {
                        $prev_checklist_ids[] = $prev_checklist_id['id'];
                    }
                    $i = 0;
                    while ($checklist_id = pg_fetch_assoc($checklists)) {
                        $qry_val_arr = array(
                            $response['id'],
                            $checklist_id['id'],
                            $prev_checklist_ids[$i]
                        );
                        pg_query_params($db_lnk, 'INSERT INTO checklist_items (created, modified, user_id, card_id, name, checklist_id, position) SELECT created, modified, user_id, $1, name , $2, position FROM checklist_items WHERE checklist_id = $3 ORDER BY id', $qry_val_arr);
                        $i++;
                    }
                }
                $foreign_ids['board_id'] = $r_post['board_id'];
                $foreign_ids['list_id'] = $r_post['list_id'];
                $foreign_ids['card_id'] = $response['id'];
                $comment = '##USER_NAME## copied this card ##CARD_NAME## from ' . $srow['name'];
                $response['activity'] = insertActivity($authUser['id'], $comment, 'copy_card', $foreign_ids, null, $response['id']);
                $qry_val_arr = array(
                    $response['id']
                );
                $response['cards'] = executeQuery('SELECT * FROM cards_listing WHERE id = $1', $qry_val_arr);
                if (!empty($response['cards']['cards_checklists'])) {
                    $response['cards']['cards_checklists'] = json_decode($response['cards']['cards_checklists'], true);
                }
                if (!empty($response['cards']['cards_users'])) {
                    $response['cards']['cards_users'] = json_decode($response['cards']['cards_users'], true);
                }
                if (!empty($response['cards']['cards_voters'])) {
                    $response['cards']['cards_voters'] = json_decode($response['cards']['cards_voters'], true);
                }
                if (!empty($response['cards']['cards_subscribers'])) {
                    $response['cards']['cards_subscribers'] = json_decode($response['cards']['cards_subscribers'], true);
                }
                if (!empty($response['cards']['cards_labels'])) {
                    $response['cards']['cards_labels'] = json_decode($response['cards']['cards_labels'], true);
                }
                $qry_val_arr = array(
                    $response['id']
                );
                $activities = executeQuery('SELECT ( SELECT array_to_json(array_agg(row_to_json(cl.*))) AS array_to_json  FROM ( SELECT activities_listing.* FROM activities_listing activities_listing WHERE (activities_listing.card_id = cards.id) ORDER BY activities_listing.id DESC) cl) AS activities FROM cards cards WHERE id = $1', $qry_val_arr);
                if (!empty($activities)) {
                    $response['cards']['activities'] = json_decode($activities['activities'], true);
                }
                $qry_val_arr = array(
                    $response['id']
                );
                $attachments = pg_query_params($db_lnk, 'SELECT * FROM card_attachments WHERE card_id = $1 ORDER BY id ASC', $qry_val_arr);
                while ($attachment = pg_fetch_assoc($attachments)) {
                    $response['cards']['attachments'][] = $attachment;
                }
                if (is_plugin_enabled('r_custom_fields')) {
                    require_once PLUGIN_PATH . DS . 'CustomFields' . DS . 'functions.php';
                    $data = customFieldAfterFetchBoard($r_resource_cmd, $r_resource_vars, $r_resource_filters, $response);
                    $response = $data;
                }
                if (is_plugin_enabled('r_gantt_view')) {
                    require_once PLUGIN_PATH . DS . 'Gantt' . DS . 'functions.php';
                    $data = cardDependencyAfterFetchBoard($r_resource_cmd, $r_resource_vars, $r_resource_filters, $response);
                    $response = $data;
                }
            }
        }
        echo json_encode($response);
        break;

    case '/organizations/?/users/?': //organization users add
        $table_name = 'organizations_users';
        $sql = true;
        $is_return_vlaue = true;
        $r_post['organization_id'] = $r_resource_vars['organizations'];
        $r_post['user_id'] = $r_resource_vars['users'];
        if (!empty($sql)) {
            $post = getbindValues($table_name, $r_post);
            $result = pg_execute_insert($table_name, $post);
            if ($result) {
                $row = pg_fetch_assoc($result);
                $response['id'] = $row['id'];
                if ($is_return_vlaue) {
                    $row = convertBooleanValues($table_name, $row);
                    $response[$table_name] = $row;
                }
                $qry_val_arr = array(
                    $response['id']
                );
                $foreign_ids['organization_id'] = $r_post['organization_id'];
                $foreign_id = $response['id'];
                $comment = '##USER_NAME## added member to organization';
                $response['activity'] = insertActivity($authUser['id'], $comment, 'add_organization_user', $foreign_ids, null, $foreign_id);
                $response['organizations_users'] = executeQuery('SELECT * FROM organizations_users_listing WHERE id = $1', $qry_val_arr);
                $response['organizations_users']['boards_users'] = json_decode($response['organizations_users']['boards_users'], true);
                $qry_val_arr = array(
                    $r_post['organization_id']
                );
                $boards = pg_query_params($db_lnk, 'SELECT * FROM boards WHERE organization_id = $1', $qry_val_arr);
                while ($board = pg_fetch_assoc($boards)) {
                    if (!empty($board)) {
                        $qry_val_arr = array(
                            $board['id'],
                            $r_post['user_id']
                        );
                        $boards_users = pg_query_params($db_lnk, 'SELECT * FROM boards_users WHERE board_id = $1 AND user_id = $2', $qry_val_arr);
                        $boards_users = pg_fetch_assoc($boards_users);
                        if (empty($boards_users)) {
                            $qry_val_arr = array(
                                $board['id'],
                                $r_post['user_id'],
                                2
                            );
                            pg_query_params($db_lnk, 'INSERT INTO boards_users (created, modified, board_id , user_id, board_user_role_id) VALUES (now(), now(), $1, $2, $3)', $qry_val_arr);
                        }
                    }
                }
            }
        }
        echo json_encode($response);
        break;

    case '/organizations': //organizations add
        $sql = true;
        $table_name = 'organizations';
        $r_post['user_id'] = (!empty($authUser['id'])) ? $authUser['id'] : 1;
        $r_post['organization_visibility'] = 2;
        if (!empty($sql)) {
            $post = getbindValues($table_name, $r_post);
            $result = pg_execute_insert($table_name, $post);
            if ($result) {
                $row = pg_fetch_assoc($result);
                $response['id'] = $row['id'];
                $qry_val_arr = array(
                    $row['id'],
                    $r_post['user_id'],
                    1
                );
                pg_query_params($db_lnk, 'INSERT INTO organizations_users (created, modified, organization_id , user_id, organization_user_role_id) VALUES (now(), now(), $1, $2, $3)', $qry_val_arr);
                $foreign_id['organization_id'] = $row['id'];
                $comment = '##USER_NAME## created organization "##ORGANIZATION_LINK##"';
                $response['activity'] = insertActivity($authUser['id'], $comment, 'add_organization', $foreign_id);
                if (is_plugin_enabled('r_groups') && !empty($r_post['group_id'])) {
                    $condition = array(
                        $r_post['group_id'],
                        $r_post['user_id']
                    );
                    $groups_users = pg_query_params($db_lnk, 'SELECT user_id FROM groups_users WHERE group_id = $1 AND user_id != $2', $condition);
                    while ($groups_user = pg_fetch_assoc($groups_users)) {
                        if (!empty($groups_user)) {
                            $qry_val_arr = array(
                                $row['id'],
                                $groups_user['user_id']
                            );
                            pg_query_params($db_lnk, "INSERT INTO organizations_users (created, modified, organization_id , user_id, organization_user_role_id) VALUES (now(), now(), $1, $2, '2')", $qry_val_arr);
                        }
                    }
                }
            }
        }
        echo json_encode($response);
        break;

    case '/organizations/?/upload_logo': // organizations logo upload
        $sql = false;
        $json = true;
        if (!empty($_FILES['file'])) {
            $_FILES['attachment'] = $_FILES['file'];
        }
        if (!empty($_FILES['attachment']) && $_FILES['attachment']['error'] == 0) {
            $allowed_ext = array(
                'gif',
                'png',
                'jpg',
                'jpeg',
                'bmp'
            );
            $filename = $_FILES['attachment']['name'];
            $file_ext = pathinfo($filename, PATHINFO_EXTENSION);
            if (in_array($file_ext, $allowed_ext)) {
                $mediadir = MEDIA_PATH . DS . 'Organization' . DS . $r_resource_vars['organizations'];
                $save_path = 'Organization' . DS . $r_resource_vars['organizations'];
                if (!file_exists($mediadir)) {
                    mkdir($mediadir, 0777, true);
                }
                $file = $_FILES['attachment'];
                $file['name'] = preg_replace('/[^A-Za-z0-9\-.]/', '', $file['name']);
                if (is_uploaded_file($file['tmp_name']) && move_uploaded_file($file['tmp_name'], $mediadir . DS . $file['name'])) {
                    $logo_url = $save_path . DS . $file['name'];
                    foreach ($thumbsizes['Organization'] as $key => $value) {
                        $list = glob(MEDIA_PATH . DS . $key . DS . 'Organization' . DS . $r_resource_vars['organizations'] . '.*');
                        if (!empty($list) && isset($list[0]) && file_exists($list[0])) {
                            unlink($list[0]);
                        }
                    }
                    foreach ($thumbsizes['Organization'] as $key => $value) {
                        $mediadir = IMG_PATH . DS . $key . DS . 'Organization' . DS . $r_resource_vars['organizations'];
                        $list = glob($mediadir . '.*');
                        if (!empty($list) && isset($list[0]) && file_exists($list[0])) {
                            unlink($list[0]);
                        }
                    }
                    $qry_val_arr = array(
                        $logo_url,
                        $r_resource_vars['organizations']
                    );
                    pg_query_params($db_lnk, 'UPDATE organizations SET logo_url = $1 WHERE id = $2', $qry_val_arr);
                    $response['logo_url'] = $logo_url;
                    $foreign_ids['organization_id'] = $r_resource_vars['organizations'];
                    $comment = ((!empty($authUser['full_name'])) ? $authUser['full_name'] : $authUser['username']) . ' added attachment to this organization ##ORGANIZATION_LINK##';
                    $response['activity'] = insertActivity($authUser['id'], $comment, 'add_organization_attachment', $foreign_ids);
                }
            } else {
                $response['error'] = 1;
            }
        }
        echo json_encode($response);
        break;

    case '/acl_links':
        $table_name = $r_post['table'];
        $colmns = array(
            'acl_links_roles' => array(
                'acl_link_id',
                'role_id'
            ) ,
            'acl_board_links_boards_user_roles' => array(
                'acl_board_link_id',
                'board_user_role_id'
            ) ,
            'acl_organization_links_organizations_user_roles' => array(
                'acl_organization_link_id',
                'organization_user_role_id'
            )
        );
        $qry_val_arr = array(
            $r_post['acl_link_id'],
            $r_post['role_id']
        );
        $acl = executeQuery('SELECT * FROM ' . $table_name . ' WHERE ' . $colmns[$table_name][0] . ' = $1 AND ' . $colmns[$table_name][1] . ' = $2', $qry_val_arr);
        if ($acl) {
            $qry_val_arr = array(
                $r_post['acl_link_id'],
                $r_post['role_id']
            );
            pg_query_params($db_lnk, 'DELETE FROM ' . $table_name . ' WHERE ' . $colmns[$table_name][0] . ' = $1 AND ' . $colmns[$table_name][1] . ' = $2', $qry_val_arr);
        } else {
            $qry_val_arr = array(
                $r_post['acl_link_id'],
                $r_post['role_id']
            );
            pg_query_params($db_lnk, 'INSERT INTO ' . $table_name . ' (created, modified, ' . $colmns[$table_name][0] . ', ' . $colmns[$table_name][1] . ') VALUES(now(), now(), $1, $2)', $qry_val_arr);
        }
        echo json_encode($response);
        break;

    case '/apps/settings':
        $folder_name = $r_post['folder'];
        unset($r_post['folder']);
        if (isset($r_post['ldap_removed_server'])) {
            $ldap_removed_server = $r_post['ldap_removed_server'];
            unset($r_post['ldap_removed_server']);
            if (!empty($ldap_removed_server)) {
                foreach ($ldap_removed_server as $key => $val) {
                    $val = str_replace(' ', '_', $val);
                    pg_query_params($db_lnk, 'DELETE FROM settings WHERE name LIKE $1', array(
                        '%-' . $val . '%'
                    ));
                };
            }
        }
        $content = file_get_contents(APP_PATH . DS . 'client' . DS . 'apps' . DS . $folder_name . DS . 'app.json');
        if (is_writable(APP_PATH . '/client/apps/' . $folder_name . '/app.json')) {
            $app = json_decode($content, true);
            if (isset($r_post['enable'])) {
                $app['enabled'] = $r_post['enable'];
                $fh = fopen(APP_PATH . '/client/apps/' . $folder_name . '/app.json', 'w');
                fwrite($fh, json_encode($app, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES));
                fclose($fh);
            } else {
                if (!empty($app['settings_from_db'])) {
                    foreach ($r_post as $key => $val) {
                        if (strpos($key, 'PASSWORD') !== false) {
                            if (!empty($val)) {
                                $value_encode = str_rot13($val);
                                $val = base64_encode($value_encode);
                            } else {
                                continue;
                            }
                        }
                        $qry_val_arr = array(
                            $val,
                            trim($key)
                        );
                        if ($folder_name !== 'r_multiple_ldap_login') {
                            pg_query_params($db_lnk, "UPDATE settings SET value = $1 WHERE name = $2", $qry_val_arr);
                        } else {
                            $LDAPSettingExists = executeQuery('SELECT * FROM settings WHERE name = $1', array(
                                trim($key)
                            ));
                            if ($LDAPSettingExists) {
                                pg_query_params($db_lnk, "UPDATE settings SET value = $1 WHERE name = $2", $qry_val_arr);
                            } else {
                                $constant_key = explode('-', trim($key));
                                $ldap_constant_attribute = executeQuery('SELECT * FROM settings WHERE name = $1', array(
                                    $constant_key[0]
                                ));
                                $new_qry_val_arr = array(
                                    $val,
                                    trim($key) ,
                                    $ldap_constant_attribute['description'],
                                    $ldap_constant_attribute['type'],
                                    $ldap_constant_attribute['options'],
                                    $ldap_constant_attribute['label'],
                                    $ldap_constant_attribute['order']
                                );
                                pg_query_params($db_lnk, 'INSERT INTO settings (setting_category_id, setting_category_parent_id, value , name, description, type, options, label, "order") VALUES (0, 0, $1, $2, $3, $4, $5, $6, $7)', $new_qry_val_arr);
                            }
                        }
                    }
                } else {
                    foreach ($r_post as $key => $val) {
                        if (!empty($app['settings'][$key]['is_encrypted'])) {
                            if (!empty($val)) {
                                $value_encode = str_rot13($val);
                                $val = base64_encode($value_encode);
                            } else {
                                break;
                            }
                        }
                        if (strpos($key, 'r_elasticsearch_index_name') !== false) {
                            if (trim(strtolower($app['settings'][$key]['value'])) !== trim(strtolower($val))) {
                                $filename = CACHE_PATH . DS . 'r_elasticsearch_last_processed_activity_id.php';
                                if (file_exists($filename)) {
                                    unlink($filename);
                                }
                            }
                        }
                        $app['settings'][$key]['value'] = $val;
                    }
                    $fh = fopen(APP_PATH . '/client/apps/' . $folder_name . '/app.json', 'w');
                    fwrite($fh, json_encode($app, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES));
                    fclose($fh);
                }
            }
            $response['success'] = 'App updated successfully';
        } else {
            $response['error']['type'] = 'File permission';
            $response['error']['content'] = '/client/apps/ ' . $folder_name . ' / app.json';
        }
        echo json_encode($response);
        break;

    case '/oauth/token':
        if (!empty($_POST['code'])) {
            $post_val = array(
                'grant_type' => 'authorization_code',
                'code' => $_POST['code'],
                'redirect_uri' => $_POST['redirect_uri'],
                'client_id' => $_POST['client_id'],
                'client_secret' => $_POST['client_secret']
            );
        } else {
            $post_val = array(
                'grant_type' => 'authorization_code',
                'code' => $r_post['code'],
                'redirect_uri' => $r_post['redirect_uri'],
                'client_id' => OAUTH_CLIENTID,
                'client_secret' => OAUTH_CLIENT_SECRET
            );
        }
        $response = getToken($post_val);
        if (!empty($_POST['code']) && !empty($response['expires'])) {
            unset($response['expires']);
        }
        echo json_encode($response);
        break;

    case '/oauth/clients':
        $sql = true;
        $table_name = 'oauth_clients';
        $r_post['client_id'] = isClientIdAvailable();
        $r_post['client_secret'] = isClientSecretAvailable();
        $r_post['grant_types'] = 'client_credentials refresh_token authorization_code';
        if (!empty($sql)) {
            $post = getbindValues($table_name, $r_post);
            $result = pg_execute_insert($table_name, $post);
            if ($result) {
                $row = pg_fetch_assoc($result);
                $response['id'] = $row['id'];
            }
        }
        echo json_encode($response);
        break;

    case '/webhooks':
        $sql = true;
        $table_name = 'webhooks';
        if (!empty($sql)) {
            $post = getbindValues($table_name, $r_post);
            $result = pg_execute_insert($table_name, $post);
            if ($result) {
                $row = pg_fetch_assoc($result);
                $response['id'] = $row['id'];
            }
        }
        echo json_encode($response);
        break;

    case '/roles':
        $sql = true;
        $table_name = 'roles';
        if (!empty($sql)) {
            $post = getbindValues($table_name, $r_post);
            $result = pg_execute_insert($table_name, $post);
            if ($result) {
                $row = pg_fetch_assoc($result);
                $response['id'] = $row['id'];
            }
        }
        echo json_encode($response);
        break;

    case '/board_user_roles':
        $sql = true;
        $table_name = 'board_user_roles';
        if (!empty($sql)) {
            $post = getbindValues($table_name, $r_post);
            $result = pg_execute_insert($table_name, $post);
            if ($result) {
                $row = pg_fetch_assoc($result);
                $response['id'] = $row['id'];
            }
        }
        echo json_encode($response);
        break;

    case '/organization_user_roles':
        $sql = true;
        $table_name = 'organization_user_roles';
        if (!empty($sql)) {
            $post = getbindValues($table_name, $r_post);
            $result = pg_execute_insert($table_name, $post);
            if ($result) {
                $row = pg_fetch_assoc($result);
                $response['id'] = $row['id'];
            }
        }
        echo json_encode($response);
        break;

    default:
        $plugin_url['LdapLogin'] = array(
            '/users/import',
            '/users/test-connection'
        );
        $plugin_url['MultipleLdapLogin'] = array(
            '/mldap/users/import',
            '/mldap/users/test-connection'
        );
        $plugin_url['BoardRoleMapper'] = array(
            '/board_roles'
        );
        $plugin_url['Broadcast'] = array(
            '/broadcasts',
            '/broadcasts/?'
        );
        $plugin_url['Group'] = array(
            '/groups',
            '/groups_users'
        );
        $plugin_url['DrawIO'] = array(
            '/card_diagrams'
        );
        $plugin_url['Wiki'] = array(
            '/pages'
        );
        $plugin_url['CRM'] = array(
            '/contacts'
        );
        $plugin_url['Salesforce'] = array(
            '/salesforce'
        );
        $plugin_url['CardTemplate'] = array(
            '/boards/?/cards/?/card_template',
            '/boards/?/card_templates/?'
        );
        $plugin_url['CustomFields'] = array(
            '/custom_fields',
            '/boards/?/custom_fields',
            '/boards/?/cards_custom_fields'
        );
        $plugin_url['Gantt'] = array(
            '/boards/?/card_dependencies'
        );
        $plugin_url['SupportApp'] = array(
            '/card_support_users'
        );
        foreach ($plugin_url as $plugin_key => $plugin_values) {
            if (in_array($r_resource_cmd, $plugin_values)) {
                $pluginToBePassed = $plugin_key;
                break;
            }
        }
        if (!empty($pluginToBePassed)) {
            require_once PLUGIN_PATH . DS . $pluginToBePassed . DS . 'R' . DS . 'r.php';
            $passed_values = array();
            $passed_values['sql'] = $sql;
            $passed_values['r_resource_cmd'] = $r_resource_cmd;
            $passed_values['r_resource_vars'] = $r_resource_vars;
            $passed_values['r_resource_filters'] = $r_resource_filters;
            $passed_values['authUser'] = $authUser;
            $passed_values['r_post'] = $r_post;
            if (!empty($table_name)) {
                $passed_values['table_name'] = $table_name;
            }
            if (!empty($siteCurrencyCode)) {
                $passed_values['siteCurrencyCode'] = $siteCurrencyCode;
            }
            if (!empty($enabledPlugins)) {
                $passed_values['enabledPlugins'] = $enabledPlugins;
            }
            $plugin_return = call_user_func($plugin_key . '_r_post', $passed_values);
            echo json_encode($plugin_return);
            break;
        }
        header($_SERVER['SERVER_PROTOCOL'] . ' 501 Not Implemented', true, 501);
        break;
    }
}
/**
 * Common method to handle PUT method
 *
 * @param string $r_resource_cmd     URL
 * @param array  $r_resource_vars    Array generated from URL
 * @param array  $r_resource_filters Array generated from URL query string
 * @param array  $r_put              Post data
 *
 * @return mixed
 */
function r_put($r_resource_cmd, $r_resource_vars, $r_resource_filters, $r_put)
{
    global $r_debug, $db_lnk, $authUser, $thumbsizes, $_server_domain_url;
    $fields = 'modified';
    $values = array(
        date('Y-m-d H:i:s')
    );
    $sfields = $table_name = $id = $activity_type = '';
    $response = $diff = $pg_params = $foreign_id = $foreign_ids = $revisions = $previous_value = $obj = array();
    $sql = $json = false;
    unset($r_put['temp_id']);
    switch ($r_resource_cmd) {
    case '/users/?/activation': //users activation
        $qry_val_arr = array(
            $r_resource_vars['users'],
            'false'
        );
        $user = executeQuery('SELECT * FROM users WHERE id = $1 AND is_email_confirmed = $2', $qry_val_arr);
        if ($user && (md5($user['username']) == $r_put['hash'])) {
            $qry_val_arr = array(
                'true',
                'true',
                $r_resource_vars['users']
            );
            $sql = pg_query_params($db_lnk, "UPDATE users SET is_email_confirmed = $1, is_active = $2 WHERE id = $3", $qry_val_arr);
            if ($sql) {
                $emailFindReplace = array(
                    '##NAME##' => $user['full_name'],
                );
                sendMail('welcome', $emailFindReplace, $user['email']);
                $response['success'] = 'Your activation has been confirmed . You can now login to the site';
            } else {
                $response['error'] = 'Invalid Activation URL';
            }
        } else {
            $response['error'] = 'Invalid Activation URL';
        }
        echo json_encode($response);
        break;

    case '/users/?': //users
        $table_name = 'users';
        $id = $r_resource_vars['users'];
        $comment = '##USER_NAME## updated the profile.';
        $activity_type = 'update_profile';
        $response = array();
        if (!empty($r_put['is_two_factor_authentication_enabled'])) {
            unset($r_put['is_two_factor_authentication_enabled']);
        }
        if (isset($r_put['profile_picture_path'])) {
            $comment = '##USER_NAME## deleted the profile image';
            $activity_type = 'delete_profile_attachment';
        } else if (isset($r_put['role_id'])) {
            $qry_val_arr = array(
                $r_resource_vars['users']
            );
            $activity_type = 'change_user_permission';
            $s_result = pg_query_params($db_lnk, 'SELECT username FROM users WHERE id = $1', $qry_val_arr);
            $username = pg_fetch_assoc($s_result);
            $comment = '##USER_NAME## changed the user permission for "' . $username['username'] . '"';
            $foreign_id['user_id'] = $r_resource_vars['users'];
        } else if (isset($r_put['is_productivity_beats'])) {
            $activity_type = 'productivity_beat_update';
        } else if (isset($r_put['is_active'])) {
            $activity_type = 'user_activation';
            $is_active = ($r_put['is_active']) ? 'activated' : 'inactivated';
            $qry_val_arr = array(
                $r_resource_vars['users']
            );
            $s_result = pg_query_params($db_lnk, 'SELECT username FROM users WHERE id = $1', $qry_val_arr);
            $username = pg_fetch_assoc($s_result);
            $comment = '##USER_NAME## ' . $is_active . ' ' . $username['username'] . '';
            $foreign_id['user_id'] = $r_resource_vars['users'];
        } else if (isset($r_put['last_activity_id']) || isset($r_put['language'])) {
            $comment = '';
            $response['success'] = 'Language changed successfully.';
        } else if (isset($r_put['verification_code'])) {
            $qry_val_arr = array(
                $r_resource_vars['users']
            );
            $s_result = pg_query_params($db_lnk, 'SELECT two_factor_authentication_hash FROM users WHERE id = $1', $qry_val_arr);
            $row = pg_fetch_assoc($s_result);
            $ga = new PHPGangsta_GoogleAuthenticator();
            $r_put['verification_code'] = (string)$r_put['verification_code'];
            $checkResult = $ga->verifyCode($row['two_factor_authentication_hash'], $r_put['verification_code'], 2);
            if ($checkResult) {
                $r_put['is_two_factor_authentication_enabled'] = true;
            } else {
                $response = array(
                    'code' => 'verification_code',
                    'error' => 'Entered verification code is wrong. Please try again.'
                );
            }
        }
        if (isset($r_put['password'])) {
            unset($r_put['password']);
        }
        $foreign_ids['user_id'] = $authUser['id'];
        if (empty($response['error'])) {
            $response = update_query($table_name, $id, $r_resource_cmd, $r_put, $comment, $activity_type, $foreign_ids);
        }
        echo json_encode($response);
        break;

    case '/email_templates/?': //email template update
        $json = true;
        $table_name = 'email_templates';
        $id = $r_resource_vars['email_templates'];
        $response['success'] = 'Email Template has been updated successfully.';
        $response = update_query($table_name, $id, $r_resource_cmd, $r_put);
        echo json_encode($response);
        break;

    case '/labels/?': //labels update
        $json = true;
        $table_name = 'labels';
        $id = $r_resource_vars['labels'];
        $response['success'] = 'Label has been updated successfully.';
        $response = update_query($table_name, $id, $r_resource_cmd, $r_put);
        echo json_encode($response);
        $comment = __l('##USER_NAME## updated ' . $r_put['name'] . ' label on ##BOARD_NAME##');
        $type = 'update_label';
        $label_id['id'] = $r_resource_vars['labels'];
        $revision = json_encode($label_id);
        $qry_val_arr = array(
            $r_put['board_id'],
            $authUser['id'],
            $type,
            $comment,
            $_GET['token'],
            $revision
        );
        $activity = pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO activities (created, modified, board_id, user_id, type, comment, token, revisions) VALUES (now(), now(),$1, $2, $3, $4, $5, $6) RETURNING id', $qry_val_arr));
        break;

    case '/oauth/clients/?':
        $json = true;
        $table_name = 'oauth_clients';
        $id = $r_resource_vars['clients'];
        $response['success'] = 'Client has been updated successfully.';
        $response = update_query($table_name, $id, $r_resource_cmd, $r_put);
        echo json_encode($response);
        break;

    case '/boards_users/?':
        $json = true;
        $table_name = 'boards_users';
        $id = $r_resource_vars['boards_users'];
        $qry_val_arr = array(
            $r_resource_vars['boards_users']
        );
        executeQuery('SELECT id FROM ' . $table_name . ' WHERE id =  $1', $qry_val_arr);
        $response = update_query($table_name, $id, $r_resource_cmd, $r_put);
        echo json_encode($response);
        break;

    case '/boards/?':
        $table_name = 'boards';
        $id = $r_resource_vars['boards'];
        $qry_val_arr = array(
            $r_resource_vars['boards']
        );
        $previous_value = executeQuery('SELECT * FROM ' . $table_name . ' WHERE id = $1', $qry_val_arr);
        $board_visibility = array(
            'Private',
            'Organization',
            'Public'
        );
        $comment = '';
        $foreign_ids['board_id'] = $r_resource_vars['boards'];
        if (!empty($r_put['is_support_app'])) {
            if (is_plugin_enabled('r_support_app')) {
                require_once PLUGIN_PATH . DS . 'SupportApp' . DS . 'functions.php';
                $r_put['id'] = $r_resource_vars['boards'];
                $SupportAppResponse = checkSupportAppFields($r_put, $r_resource_cmd);
                if (empty($r_put['support_list_id'])) {
                    echo json_encode($SupportAppResponse);
                    break;
                }
            }
        }
        if (isset($r_put['r_gridview_configure'])) {
            if (is_plugin_enabled('r_gridview_configure')) {
                $field_arr = array(
                    'r_gridview_configure',
                );
                $custom_fields_array = array();
                $custom_fields_array['r_gridview_configure'] = $r_put['r_gridview_configure'];
                $boardCustomFields = executeQuery('SELECT board_custom_fields FROM boards WHERE id = $1', [$id]);
                if (!empty($boardCustomFields['board_custom_fields'])) {
                    $boardCustomFields = json_decode($boardCustomFields['board_custom_fields'], true);
                    foreach ($boardCustomFields as $key => $boardValue) {
                        if (array_key_exists($key, $custom_fields_array)) {
                            $custom_fields_array[$key] = $custom_fields_array[$key];
                        } else {
                            $custom_fields_array[$key] = $boardValue;
                        }
                    }
                }
                $board['id'] = $id;
                $board['board_custom_fields'] = json_encode($custom_fields_array);
                $grid_view_response = update_query('boards', $id, $r_resource_cmd, $board);
                $comment = __l('##USER_NAME## changed grid view configuration on ##BOARD_NAME##');
                $type = 'change_grid_view_configuration';
                $revision = $board['board_custom_fields'];
                $qry_val_arr = array(
                    $r_resource_vars['boards'],
                    $authUser['id'],
                    $type,
                    $comment,
                    $_GET['token'],
                    $revision
                );
                $activity = pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO activities (created, modified, board_id, user_id, type, comment, token, revisions) VALUES (now(), now(),$1, $2, $3, $4, $5, $6) RETURNING id', $qry_val_arr));
                echo json_encode($grid_view_response);
                break;
            }
        }
        if (isset($r_put['r_listview_configure'])) {
            if (is_plugin_enabled('r_listview_configure')) {
                $field_arr = array(
                    'r_listview_configure'
                );
                $custom_fields_array = array();
                $custom_fields_array['r_listview_configure'] = $r_put['r_listview_configure'];
                $boardCustomFields = executeQuery('SELECT board_custom_fields FROM boards WHERE id = $1', [$id]);
                if (!empty($boardCustomFields['board_custom_fields'])) {
                    $boardCustomFields = json_decode($boardCustomFields['board_custom_fields'], true);
                    foreach ($boardCustomFields as $key => $boardValue) {
                        if (array_key_exists($key, $custom_fields_array)) {
                            $custom_fields_array[$key] = $custom_fields_array[$key];
                        } else {
                            $custom_fields_array[$key] = $boardValue;
                        }
                    }
                }
                $board['id'] = $id;
                $board['board_custom_fields'] = json_encode($custom_fields_array);
                $grid_view_response = update_query('boards', $id, $r_resource_cmd, $board);
                $comment = __l('##USER_NAME## changed list view configuration on ##BOARD_NAME##');
                $type = 'change_list_view_configuration';
                $revision = $board['board_custom_fields'];
                $qry_val_arr = array(
                    $r_resource_vars['boards'],
                    $authUser['id'],
                    $type,
                    $comment,
                    $_GET['token'],
                    $revision
                );
                $activity = pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO activities (created, modified, board_id, user_id, type, comment, token, revisions) VALUES (now(), now(),$1, $2, $3, $4, $5, $6) RETURNING id', $qry_val_arr));
            }
        }
        if (isset($r_put['r_listview_configure_position'])) {
            if (is_plugin_enabled('r_listview_configure')) {
                $field_arr = array(
                    'r_listview_configure_position',
                );
                $custom_fields_array = array();
                $custom_fields_array['r_listview_configure_position'] = $r_put['r_listview_configure_position'];
                $boardCustomFields = executeQuery('SELECT board_custom_fields FROM boards WHERE id = $1', [$id]);
                if (!empty($boardCustomFields['board_custom_fields'])) {
                    $boardCustomFields = json_decode($boardCustomFields['board_custom_fields'], true);
                    foreach ($boardCustomFields as $key => $boardValue) {
                        if (array_key_exists($key, $custom_fields_array)) {
                            $custom_fields_array[$key] = $custom_fields_array[$key];
                        } else {
                            $custom_fields_array[$key] = $boardValue;
                        }
                    }
                }
                $board['id'] = $id;
                $board['board_custom_fields'] = json_encode($custom_fields_array);
                $grid_view_response = update_query('boards', $id, $r_resource_cmd, $board);
                echo json_encode($grid_view_response);
                break;
            }
        }
        if (isset($r_put['default_email_list_id']) || isset($r_put['is_default_email_position_as_bottom'])) {
            $comment = '';
        } else if (isset($r_put['board_visibility'])) {
            $comment = '##USER_NAME## changed visibility to ' . $board_visibility[$r_put['board_visibility']];
            $activity_type = 'change_visibility';
        } else if (!empty($r_put['is_closed'])) {
            $comment = '##USER_NAME## closed ##BOARD_NAME## board.';
            $activity_type = 'close_board';
        } else if (isset($r_put['is_closed'])) {
            $comment = '##USER_NAME## reopened ##BOARD_NAME## board.';
            $activity_type = 'reopen_board';
        } else if (isset($r_put['name'])) {
            $comment = '##USER_NAME## renamed ##BOARD_NAME## board.';
            $activity_type = 'edit_board';
        } else if (isset($r_put['auto_subscribe_on_board'])) {
            if ($r_put['auto_subscribe_on_board']) {
                $comment = '##USER_NAME## enabled auto subscribe a member when he\'s added to a board on ##BOARD_NAME## board.';
            } else {
                $comment = '##USER_NAME## disabled auto subscribe a member when he\'s added to a card on ##BOARD_NAME## board.';
            }
            $activity_type = 'auto_subscribe_on_board';
        } else if (isset($r_put['auto_subscribe_on_card'])) {
            if ($r_put['auto_subscribe_on_card']) {
                $comment = '##USER_NAME## enabled auto subscribe on card when adding a board member on ##BOARD_NAME## board.';
            } else {
                $comment = '##USER_NAME## disabled auto subscribe on card when adding a board member on ##BOARD_NAME## board.';
            }
            $activity_type = 'auto_subscribe_on_card';
        } else if (isset($r_put['background_picture_url']) || isset($r_put['background_pattern_url']) || isset($r_put['background_color']) || isset($r_put['remove_background'])) {
            if (empty($previous_value['background_picture_url']) && empty($previous_value['background_pattern_url']) && empty($previous_value['background_color'])) {
                $comment = '##USER_NAME## added background to board "' . $previous_value['name'] . '"';
                $activity_type = 'add_background';
            } else {
                $comment = '##USER_NAME## changed backgound to board "' . $previous_value['name'] . '"';
                $activity_type = 'change_background';
            }
            unset($r_put['remove_background']);
        } else if (isset($r_put['music_name']) && !empty($r_put['music_content'])) {
            $comment = '##USER_NAME## updated the beats on ##BOARD_NAME## board.';
        } else if (isset($r_put['sort_by']) && !empty($r_put['sort_by'])) {
            $comment = '##USER_NAME## updated the sort of cards on ##BOARD_NAME## board.';
            $activity_type = 'update_sort_card';
        } else if (isset($r_put['is_show_image_front_of_card'])) {
            if ($r_put['is_show_image_front_of_card']) {
                $comment = '##USER_NAME## enabled card cover image on ##BOARD_NAME## board.';
            } else {
                $comment = '##USER_NAME## disabled card cover image on ##BOARD_NAME## board.';
            }
            $activity_type = 'is_show_image_front_of_card';
        }
        if (!empty($r_put['organization_id'])) {
            $qry_val_arr = array(
                $r_put['organization_id']
            );
            $organizations_users = pg_query_params($db_lnk, 'SELECT user_id FROM organizations_users WHERE organization_id = $1', $qry_val_arr);
            while ($organizations_user = pg_fetch_assoc($organizations_users)) {
                if (!empty($organizations_user)) {
                    $qry_val_arr = array(
                        $r_resource_vars['boards'],
                        $organizations_user['user_id']
                    );
                    $boards_users = pg_query_params($db_lnk, 'SELECT * FROM boards_users WHERE board_id = $1 AND user_id = $2', $qry_val_arr);
                    $boards_users = pg_fetch_assoc($boards_users);
                    if (empty($boards_users)) {
                        $qry_val_arr = array(
                            $r_resource_vars['boards'],
                            $organizations_user['user_id'],
                            2
                        );
                        pg_query_params($db_lnk, 'INSERT INTO boards_users (created, modified, board_id , user_id, board_user_role_id) VALUES (now(), now(), $1, $2, $3)', $qry_val_arr);
                    }
                }
            }
        }
        $response = update_query($table_name, $id, $r_resource_cmd, $r_put, $comment, $activity_type, $foreign_ids);
        echo json_encode($response);
        break;

    case '/boards/?/lists/?': //lists update
        $json = true;
        $table_name = 'lists';
        $id = $r_resource_vars['lists'];
        if (isset($r_put['position']) || isset($r_put['is_archived']) || isset($r_put['color']) || isset($r_put['custom_fields'])) {
            $qry_val_arr = array(
                $r_resource_vars['lists']
            );
            $s_sql = 'SELECT name, board_id, position, color, custom_fields FROM ' . $table_name . ' WHERE id = $1';
            $s_result = pg_query_params($db_lnk, $s_sql, $qry_val_arr);
            $previous_value = pg_fetch_assoc($s_result);
        }
        $comment = '';
        $foreign_ids['board_id'] = $r_resource_vars['boards'];
        $foreign_ids['list_id'] = $r_resource_vars['lists'];
        if (isset($r_put['board_id']) && !empty($r_put['board_id'])) {
            $qry_val_arr = array(
                $r_put['board_id'],
                $r_resource_vars['lists']
            );
            pg_query_params($db_lnk, 'UPDATE cards SET board_id = $1 WHERE list_id = $2', $qry_val_arr);
            $qry_val_arr = array(
                $r_put['board_id'],
                $r_resource_vars['lists']
            );
            $customFields = array();
            pg_query_params($db_lnk, 'UPDATE card_attachments SET board_id = $1 WHERE list_id = $2', $qry_val_arr);
            pg_query_params($db_lnk, 'UPDATE cards_labels SET board_id = $1 WHERE list_id = $2', $qry_val_arr);
            pg_query_params($db_lnk, 'UPDATE activities SET board_id = $1 WHERE list_id = $2', $qry_val_arr);
            if ($previous_value['board_id'] !== $r_put['board_id']) {
                if (is_plugin_enabled('r_custom_fields')) {
                    $qry_val_arr = array(
                        $previous_value['board_id']
                    );
                    $s_sql = 'SELECT * FROM custom_fields WHERE board_id = $1';
                    $custom_fields = pg_query_params($db_lnk, $s_sql, $qry_val_arr);
                    while ($custom_field = pg_fetch_assoc($custom_fields)) {
                        $qry_val_arr = array(
                            $r_put['board_id'],
                            $custom_field['name']
                        );
                        $customField = executeQuery('SELECT * FROM custom_fields WHERE board_id = $1 AND name = $2', $qry_val_arr);
                        if (empty($customField)) {
                            $data = array(
                                'user_id' => $authUser['id'],
                                'type' => $custom_field['type'],
                                'name' => $custom_field['name'],
                                'description' => $custom_field['description'],
                                'options' => $custom_field['options'],
                                'label' => $custom_field['label'],
                                'position' => $custom_field['position'],
                                'visibility' => $custom_field['visibility'],
                                'color' => $custom_field['color'],
                                'board_id' => $r_put['board_id'],
                            );
                            $result = pg_execute_insert('custom_fields', $data);
                            $row = pg_fetch_assoc($result);
                            $customFields[$custom_field['id']] = (int)($row['id']);
                        } else {
                            $qry_val_arr = array(
                                $previous_value['board_id'],
                                $custom_field['name']
                            );
                            $previous_customField = executeQuery('SELECT * FROM custom_fields WHERE board_id = $1 AND name = $2', $qry_val_arr);
                            if (!empty($previous_customField) && !empty($customField)) {
                                if ($previous_customField['type'] === 'dropdown') {
                                    $new_customfield_options = explode(',', $customField['options']);
                                    $previous_customfield_options = explode(',', $previous_customField['options']);
                                    $new_unique_option = array_unique(array_merge($new_customfield_options, $previous_customfield_options));
                                    $data = array(
                                        $customField['id'],
                                        implode(',', $new_unique_option)
                                    );
                                    pg_query_params($db_lnk, 'UPDATE custom_fields SET options = $2 WHERE id = $1', $data);
                                }
                            }
                            $customFields[$custom_field['id']] = $customField['id'];
                        }
                    }
                    $qry_val_arr = array(
                        $previous_value['board_id']
                    );
                    $s_sql = 'SELECT * FROM custom_fields WHERE board_id = $1';
                    $custom_fields = pg_query_params($db_lnk, $s_sql, $qry_val_arr);
                    while ($custom_field = pg_fetch_assoc($custom_fields)) {
                        $qry_val_arr = array(
                            $r_put['board_id'],
                            $customFields[$custom_field['id']],
                            $r_resource_vars['lists'],
                            $custom_field['id']
                        );
                        pg_query_params($db_lnk, 'UPDATE cards_custom_fields SET board_id = $1, custom_field_id = $2 WHERE list_id = $3 AND custom_field_id = $4', $qry_val_arr);
                    }
                }
                $qry_val_arr = array(
                    $previous_value['board_id']
                );
                $current_board_name = executeQuery('SELECT name FROM boards WHERE id =  $1', $qry_val_arr);
                $qry_val_arr = array(
                    $r_put['board_id']
                );
                // changing the board id
                $foreign_ids['board_id'] = $r_put['board_id'];
                $new_board_name = executeQuery('SELECT name FROM boards WHERE id =  $1', $qry_val_arr);
                $comment = '##USER_NAME## moved the list ##LIST_NAME## from ' . $current_board_name['name'] . ' to ' . $new_board_name['name'] . '.';
                $activity_type = 'move_list';
            }
        }
        if (isset($r_put['position']) && ((!isset($r_put['board_id']) && $previous_value['position'] != $r_put['position']) || (isset($r_put['board_id']) && $previous_value['board_id'] == $r_put['board_id']))) {
            $comment = '##USER_NAME## changed list ' . $previous_value['name'] . ' position.';
            $activity_type = 'change_list_position';
        } else if (isset($previous_value) && isset($r_put['is_archived'])) {
            $id = $r_resource_vars['lists'];
            $foreign_ids['board_id'] = $r_resource_vars['boards'];
            $foreign_ids['list_id'] = $r_resource_vars['lists'];
            if (empty($r_put['is_archived'])) {
                $comment = '##USER_NAME## unarchived list "' . $previous_value['name'] . '"';
                $activity_type = 'unarchive_list';
            } else {
                $comment = '##USER_NAME## archived list "' . $previous_value['name'] . '"';
                $activity_type = 'archive_list';
            }
        } else if (isset($r_put['custom_fields'])) {
            $previous_custom_fields_value = json_decode($previous_value['custom_fields'], true);
            $custom_fields = json_decode($r_put['custom_fields'], true);
            if (is_plugin_enabled('r_auto_archive_expired_cards') && isset($custom_fields['auto_archive_days'])) {
                if (empty($previous_custom_fields_value['auto_archive_days']) && isset($custom_fields['auto_archive_days'])) {
                    if (!empty($custom_fields['auto_archive_days'])) {
                        $comment = '##USER_NAME## set ' . $custom_fields['auto_archive_days'] . 'days to auto archive to move the list "##LIST_NAME##"';
                        $activity_type = 'add_list_auto_archive_day';
                    }
                } else if (!empty($previous_custom_fields_value) && isset($custom_fields['auto_archive_days']) && $custom_fields['auto_archive_days'] != $previous_custom_fields_value['auto_archive_days']) {
                    if (empty($custom_fields['auto_archive_days'])) {
                        $comment = '##USER_NAME## removed auto archive days for list "##LIST_NAME##"';
                        $activity_type = 'delete_list_auto_archive_day';
                    } else {
                        $comment = '##USER_NAME## updated ' . $custom_fields['auto_archive_days'] . 'days to auto archive to move the list "##LIST_NAME##"';
                        $activity_type = 'edit_list_auto_archive_day';
                    }
                }
            }
            if (is_plugin_enabled('r_task_move_on_due_date') && isset($custom_fields['move_list_id'])) {
                if (!empty($custom_fields['move_list_id'])) {
                    $qry_val_arr = array(
                        $custom_fields['move_list_id']
                    );
                    $move_list = executeQuery('SELECT name FROM lists WHERE id = $1', $qry_val_arr);
                }
                if (empty($previous_custom_fields_value['move_list_id']) && isset($custom_fields['move_list_id'])) {
                    if (!empty($custom_fields['move_list_id'])) {
                        $comment = '##USER_NAME## set task move on due date from "##LIST_NAME##" to "' . $move_list['name'] . '"';
                        $activity_type = 'add_list_task_move_duedate';
                    }
                } else if (!empty($previous_custom_fields_value) && isset($custom_fields['move_list_id']) && $custom_fields['move_list_id'] != $previous_custom_fields_value['move_list_id']) {
                    if (empty($custom_fields['move_list_id'])) {
                        $comment = '##USER_NAME## removed task move on due date from "##LIST_NAME##"';
                        $activity_type = 'delete_list_task_move_duedate';
                    } else {
                        $comment = '##USER_NAME## updated task move on due date from "##LIST_NAME##" to "' . $move_list['name'] . '"';
                        $activity_type = 'edit_list_task_move_duedate';
                    }
                }
            }
            if (isset($custom_fields['list_collapse'])) {
                if ($custom_fields['list_collapse']) {
                    $comment = '##USER_NAME## minimized the ##LIST_NAME## list';
                    $activity_type = 'list_change_min';
                } else {
                    $comment = '##USER_NAME## maximized the ##LIST_NAME## list';
                    $activity_type = 'list_change_max';
                }
            }
            if (is_plugin_enabled('r_agile_wip') && isset($custom_fields['wip_limit'])) {
                if (empty($previous_custom_fields_value['wip_limit']) && isset($custom_fields['wip_limit'])) {
                    if (!empty($custom_fields['wip_limit'])) {
                        $comment = '##USER_NAME## set Agile WIP limit to list "##LIST_NAME##" as ' . $custom_fields['wip_limit'];
                        $activity_type = 'add_list_agile_wip_limit';
                        if (isset($custom_fields['hard_wip_limit'])) {
                            if ($custom_fields['hard_wip_limit'] === 'yes') {
                                $comment.= " and set as hard limit";
                            }
                        }
                    }
                } else if (!empty($previous_custom_fields_value) && (isset($custom_fields['wip_limit']) && $custom_fields['wip_limit'] != $previous_custom_fields_value['wip_limit']) || (isset($custom_fields['hard_wip_limit']) && $custom_fields['hard_wip_limit'] != $previous_custom_fields_value['hard_wip_limit'])) {
                    if (empty($custom_fields['wip_limit']) && isset($custom_fields['wip_limit'])) {
                        $comment = '##USER_NAME## removed Agile WIP limit - ' . $previous_custom_fields_value['wip_limit'] . ' from list "##LIST_NAME##"';
                        $activity_type = 'delete_list_agile_wip_limit';
                    } else {
                        $comment = '##USER_NAME## updated Agile WIP limit - ' . $custom_fields['wip_limit'] . ' on list "##LIST_NAME##"';
                        $activity_type = 'edit_list_agile_wip_limit';
                    }
                    if (empty($custom_fields['hard_wip_limit']) && isset($custom_fields['hard_wip_limit'])) {
                        $comment.= " and removed hard limit";
                    } else {
                        $comment.= " and set as hard limit";
                    }
                }
            }
        } else if (isset($r_put['color'])) {
            if (empty($previous_value['color']) && isset($r_put['color'])) {
                $comment = '##USER_NAME## added list color - ' . $r_put['color'] . ' in ##LIST_NAME##';
                $activity_type = 'add_list_color';
            } else if (!empty($previous_value) && isset($r_put['color']) && $r_put['color'] != $previous_value['color']) {
                if (empty($r_put['color'])) {
                    $comment = '##USER_NAME## removed list color - ' . $previous_value['color'] . ' from ##LIST_NAME##';
                    $activity_type = 'delete_list_color';
                } else {
                    $comment = '##USER_NAME## updated list color - ' . $r_put['color'] . ' on ##LIST_NAME##';
                    $activity_type = 'edit_list_color';
                }
            }
        } else if (!isset($r_put['board_id'])) {
            $id = $r_resource_vars['lists'];
            $comment = '##USER_NAME## renamed this list.';
            $activity_type = 'edit_list';
        }
        $response = update_query($table_name, $id, $r_resource_cmd, $r_put, $comment, $activity_type, $foreign_ids);
        echo json_encode($response);
        break;

    case '/boards/?/lists/?/cards': //card list_id(move cards all in this list) update
        $json = true;
        $table_name = 'cards';
        $id = $r_resource_vars['lists'];
        $foreign_ids['board_id'] = $r_resource_vars['boards'];
        $foreign_ids['list_id'] = $r_resource_vars['lists'];
        $qry_val_arr = array(
            $foreign_ids['list_id']
        );
        $old_list = executeQuery('SELECT name FROM lists WHERE id = $1', $qry_val_arr);
        if (!empty($r_put['list_id'])) {
            $qry_val_arr = array(
                $r_put['list_id'],
                $foreign_ids['list_id']
            );
            pg_query_params($db_lnk, 'UPDATE card_attachments SET list_id = $1 WHERE list_id = $2', $qry_val_arr);
            $qry_val_arr = array(
                $r_put['list_id'],
                $foreign_ids['list_id']
            );
            pg_query_params($db_lnk, 'UPDATE cards_labels SET list_id = $1 WHERE list_id = $2', $qry_val_arr);
            $qry_val_array = array(
                $r_put['list_id']
            );
            $new_list = executeQuery('SELECT name FROM lists WHERE id =  $1', $qry_val_array);
            $comment = '##USER_NAME## moved cards FROM ' . $old_list['name'] . ' to ' . $new_list['name'];
            $activity_type = 'moved_list_card';
            $revisions['old_value']['list_id'] = $foreign_ids['list_id'];
            $revisions['new_value'] = $r_put;
        } else if (isset($r_put['is_archived']) && !empty($r_put['is_archived'])) {
            $comment = '##USER_NAME## archived cards in ' . $old_list['name'];
            $activity_type = 'archived_card';
        } else {
            $comment = '##USER_NAME## edited ' . $old_list['name'] . ' card in this board.';
            $activity_type = 'edit_card';
        }
        $response = update_query($table_name, $id, $r_resource_cmd, $r_put, $comment, $activity_type, $foreign_ids);
        echo json_encode($response);
        break;

    case '/boards/?/lists/?/cards/?': //cards update
        $table_name = 'cards';
        $final_custom_array = array();
        $present_custom_fields = array();
        $previous_custom_fields = array();
        $comment = '';
        $id = $r_resource_vars['cards'];
        $foreign_ids['board_id'] = !empty($r_put['board_id']) ? $r_put['board_id'] : $r_resource_vars['boards'];
        $foreign_ids['list_id'] = $r_resource_vars['lists'];
        $foreign_ids['card_id'] = $r_resource_vars['cards'];
        $activity_type = 'edit_card';
        $qry_val_arr = array(
            $r_resource_vars['cards']
        );
        $s_result = pg_query_params($db_lnk, 'SELECT name, board_id, list_id, position, description, custom_fields, due_date, color FROM ' . $table_name . ' WHERE id = $1', $qry_val_arr);
        $previous_value = pg_fetch_assoc($s_result);
        if (!empty($r_put['custom_fields'])) {
            if ($previous_value && !empty($previous_value['custom_fields'])) {
                $previous_custom_fields = json_decode($previous_value['custom_fields'], true);
            }
            $present_custom_fields = json_decode($r_put['custom_fields'], true);
            $final_custom_array = array_merge($previous_custom_fields, $present_custom_fields);
            $custom_field_encode = json_encode($final_custom_array);
            $r_put['custom_fields'] = $custom_field_encode;
        }
        $current_list_id = $previous_value['list_id'];
        if (isset($r_put['position'])) {
            if (!empty($r_put['list_id'])) {
                $current_list_id = $r_put['list_id'];
                $foreign_ids['list_id'] = $r_put['list_id'];
                $new_board_id = !empty($r_put['board_id']) ? $r_put['board_id'] : $r_resource_vars['boards'];
                $qry_val_arr = array(
                    $r_put['list_id'],
                    $new_board_id,
                    $foreign_ids['card_id']
                );
                pg_query_params($db_lnk, 'UPDATE card_attachments SET list_id = $1, board_id = $2 WHERE card_id = $3', $qry_val_arr);
                pg_query_params($db_lnk, 'UPDATE cards_labels SET list_id = $1, board_id = $2 WHERE card_id = $3', $qry_val_arr);
                if (isset($previous_value['board_id']) && isset($r_put['board_id']) && $r_put['board_id'] == $previous_value['board_id']) {
                    pg_query_params($db_lnk, 'UPDATE activities SET list_id = $1, board_id = $2 WHERE card_id = $3', $qry_val_arr);
                } else {
                    $qry_val_arr = array(
                        $r_put['list_id'],
                        $new_board_id,
                        $foreign_ids['card_id'],
                        "add_comment"
                    );
                    pg_query_params($db_lnk, 'UPDATE activities SET list_id = $1, board_id = $2 WHERE card_id = $3 AND type = $4', $qry_val_arr);
                }
            }
            $qry_val_arr = array(
                $current_list_id
            );
            $current_list_name = executeQuery('SELECT name FROM lists WHERE id =  $1', $qry_val_arr);
            $comment = '##USER_NAME## changed the card ##CARD_LINK## position';
            $activity_type = 'change_card_position';
            if (!empty($r_put['list_id']) && $previous_value['list_id'] != $r_put['list_id']) {
                $foreign_ids['list_id'] = $r_resource_vars['lists'];
                $comment = '##USER_NAME## moved the card ##CARD_LINK## to ' . $current_list_name['name'];
                $activity_type = 'move_card';
            }
        }
        if (isset($previous_value) && isset($r_put['is_archived'])) {
            if (is_plugin_enabled('r_auto_archive_expired_cards')) {
                if (!empty($r_put['is_custom_field'])) {
                    if ($r_put['is_archived']) {
                        $comment = 'This card ##CARD_NAME## is archived due to Auto archived is enabled on ##LIST_NAME##';
                    }
                }
            }
            if ($r_put['is_archived']) {
                $comment = '##USER_NAME## archived card ' . $previous_value['name'];
                $activity_type = 'archived_card';
            } else {
                $comment = '##USER_NAME## send back card ' . $previous_value['name'] . ' to board';
                $activity_type = 'unarchived_card';
            }
            $foreign_ids['board_id'] = $r_resource_vars['boards'];
            $foreign_ids['list_id'] = $r_resource_vars['lists'];
        }
        if (isset($r_put['due_date']) && $r_put['due_date'] != 'NULL') {
            $data_val = array(
                'false',
                $r_resource_vars['cards']
            );
            pg_query_params($db_lnk, 'update cards set is_due_date_notification_sent = $1 where id = $2', $data_val);
            if (isset($previous_value['due_date']) && ($previous_value['due_date'] != 'null' && $previous_value['due_date'] != '')) {
                $comment = '##USER_NAME## updated due date - ' . $r_put['due_date'] . ' to the card ##CARD_LINK##';
                $activity_type = 'edit_card_duedate';
            } else {
                $comment = '##USER_NAME## set due date - ' . $r_put['due_date'] . ' to the card ##CARD_LINK##';
                $activity_type = 'add_card_duedate';
            }
            if (is_plugin_enabled('r_gantt_view')) {
                require_once PLUGIN_PATH . DS . 'Gantt' . DS . 'functions.php';
                $r_put['id'] = $r_resource_vars['cards'];
                $childCardResponse = updateDependencyCards($r_put, array());
            }
        } else if (isset($r_put['due_date'])) {
            $comment = '##USER_NAME##  removed Due date - ' . $previous_value['due_date'] . ' to the card ##CARD_LINK##';
            $activity_type = 'delete_card_duedate';
        }
        if (is_plugin_enabled('r_gantt_view')) {
            if (isset($present_custom_fields['start_date']) && $present_custom_fields['start_date'] != 'NULL' && $present_custom_fields['start_date'] != '') {
                if (isset($previous_custom_fields['start_date']) && ($previous_custom_fields['start_date'] != 'null' && $previous_custom_fields['start_date'] != '')) {
                    $comment = '##USER_NAME## updated Start date - ' . $present_custom_fields['start_date'] . ' ' . $present_custom_fields['start_time'] . ' to the card ##CARD_LINK##';
                    $activity_type = 'edit_card_startdate';
                } else {
                    $comment = '##USER_NAME## set start date - ' . $present_custom_fields['start_date'] . ' ' . $present_custom_fields['start_time'] . ' to the card ##CARD_LINK##';
                    $activity_type = 'add_card_startdate';
                }
            } else if (isset($present_custom_fields['start_date'])) {
                $comment = '##USER_NAME## removed Start date - ' . $previous_custom_fields['start_date'] . ' ' . $previous_custom_fields['start_time'] . ' to the card ##CARD_LINK##';
                $activity_type = 'delete_card_startdate';
            }
        }
        if (is_plugin_enabled('r_estimated_time')) {
            if ((isset($present_custom_fields['hour']) && $present_custom_fields['hour'] != 'NULL' && $present_custom_fields['hour'] != '') || (isset($present_custom_fields['min']) && $present_custom_fields['min'] != 'NULL' && $present_custom_fields['min'] != '')) {
                if (isset($present_custom_fields['hour']) && ($present_custom_fields['hour'] != 'null' && $present_custom_fields['hour'] != '') && isset($present_custom_fields['min']) && ($present_custom_fields['min'] != 'null' && $present_custom_fields['min'] != '')) {
                    $comment = '##USER_NAME## updated estimated time ' . $present_custom_fields['hour'] . ' hour(s) ' . $present_custom_fields['min'] . ' min(s) to the card ##CARD_LINK##';
                    $activity_type = 'edit_card_estimatedtime';
                } else if (isset($present_custom_fields['hour']) && ($present_custom_fields['hour'] != 'null' && $present_custom_fields['hour'] != '')) {
                    $comment = '##USER_NAME## set estimated time ' . $present_custom_fields['hour'] . ' hour(s) to the card ##CARD_LINK##';
                    $activity_type = 'add_card_estimatedtime';
                } else if (isset($present_custom_fields['min']) && ($present_custom_fields['min'] != 'null' && $present_custom_fields['min'] != '')) {
                    $comment = '##USER_NAME## set estimated time ' . $present_custom_fields['min'] . ' min(s) to the card ##CARD_LINK##';
                    $activity_type = 'add_card_estimatedtime';
                }
            } else if (isset($present_custom_fields['hour']) && isset($present_custom_fields['min'])) {
                $comment = '##USER_NAME## removed estimated time to the card ##CARD_LINK##';
                $activity_type = 'delete_card_estimatedtime';
            }
        }
        if (is_plugin_enabled('r_spent_time')) {
            if ((isset($present_custom_fields['number']) && $present_custom_fields['number'] != 'NULL' && $present_custom_fields['number'] != '') && (isset($present_custom_fields['period']) && $present_custom_fields['period'] != 'NULL' && $present_custom_fields['period'] != '')) {
                if (isset($previous_custom_fields['number']) && ($previous_custom_fields['number'] != 'null' && $previous_custom_fields['number'] != '') && isset($previous_custom_fields['period']) && ($previous_custom_fields['period'] != 'null' && $previous_custom_fields['period'] != '')) {
                    $comment = '##USER_NAME## updated spent time ' . $present_custom_fields['number'] . ' ' . $present_custom_fields['period'] . ' to the card ##CARD_LINK##';
                    $activity_type = 'edit_card_spenttime';
                } else {
                    $comment = '##USER_NAME## set spent time ' . $present_custom_fields['number'] . ' ' . $present_custom_fields['period'] . ' to the card ##CARD_LINK##';
                    $activity_type = 'add_card_spenttime';
                }
            } else if (isset($present_custom_fields['period']) && isset($present_custom_fields['number'])) {
                $comment = '##USER_NAME## removed spent time to the card ##CARD_LINK##';
                $activity_type = 'delete_card_spenttime';
            }
        }
        if (isset($previous_value['board_id']) && isset($r_put['board_id']) && $r_put['board_id'] != $previous_value['board_id']) {
            if (is_plugin_enabled('r_custom_fields')) {
                $customFields = array();
                $qry_val_arr = array(
                    $previous_value['board_id'],
                );
                $custom_fields = pg_query_params($db_lnk, 'SELECT * FROM custom_fields WHERE board_id IS NULL or board_id = $1', $qry_val_arr);
                while ($custom_field = pg_fetch_assoc($custom_fields)) {
                    if (!empty($custom_field['board_id'])) {
                        $qry_val_arr = array(
                            $r_put['board_id'],
                            $custom_field['name']
                        );
                        $customField = executeQuery('SELECT * FROM custom_fields WHERE board_id = $1 AND name = $2', $qry_val_arr);
                        if (empty($customField)) {
                            $data = array(
                                'user_id' => $authUser['id'],
                                'type' => $custom_field['type'],
                                'name' => $custom_field['name'],
                                'description' => $custom_field['description'],
                                'options' => $custom_field['options'],
                                'label' => $custom_field['label'],
                                'position' => $custom_field['position'],
                                'visibility' => $custom_field['visibility'],
                                'color' => $custom_field['color'],
                                'board_id' => $r_put['board_id'],
                            );
                            $result = pg_execute_insert('custom_fields', $data);
                            $row = pg_fetch_assoc($result);
                            $customFields[$custom_field['id']] = (int)($row['id']);
                        } else {
                            $qry_val_arr = array(
                                $previous_value['board_id'],
                                $custom_field['name']
                            );
                            $previous_customField = executeQuery('SELECT * FROM custom_fields WHERE board_id = $1 AND name = $2', $qry_val_arr);
                            if (!empty($previous_customField) && !empty($customField)) {
                                if ($previous_customField['type'] === 'dropdown') {
                                    $new_customfield_options = explode(',', $customField['options']);
                                    $previous_customfield_options = explode(',', $previous_customField['options']);
                                    $new_unique_option = array_unique(array_merge($new_customfield_options, $previous_customfield_options));
                                    $data = array(
                                        $customField['id'],
                                        implode(',', $new_unique_option)
                                    );
                                    pg_query_params($db_lnk, 'UPDATE custom_fields SET options = $2 WHERE id = $1', $data);
                                }
                            }
                            $customFields[$custom_field['id']] = $customField['id'];
                        }
                    } else {
                        $customFields[$custom_field['id']] = $custom_field['id'];
                    }
                }
                if (!empty($customFields)) {
                    $qry_val_arr = array(
                        $id
                    );
                    $cardsCustomFields = pg_query_params($db_lnk, 'SELECT * FROM cards_custom_fields WHERE card_id = $1 ORDER BY id', $qry_val_arr);
                    while ($cardsCustomField = pg_fetch_assoc($cardsCustomFields)) {
                        if (isset($customFields[$cardsCustomField['custom_field_id']])) {
                            $data = array(
                                $customFields[$cardsCustomField['custom_field_id']],
                                $r_put['board_id'],
                                $r_put['list_id'],
                                $cardsCustomField['id']
                            );
                            pg_query_params($db_lnk, 'UPDATE cards_custom_fields SET custom_field_id = $1, board_id = $2, list_id = $3 WHERE id = $4', $data);
                        }
                    }
                }
            }
            $qry_val_arr = array(
                $foreign_ids['card_id'],
                $r_put['board_id']
            );
            pg_query_params($db_lnk, 'DELETE FROM cards_users WHERE card_id = $1 AND user_id NOT IN (select user_id FROM boards_users WHERE board_id = $2)', $qry_val_arr);
            pg_query_params($db_lnk, 'DELETE FROM card_subscribers WHERE card_id = $1 AND user_id NOT IN (select user_id FROM boards_users WHERE board_id = $2)', $qry_val_arr);
            pg_query_params($db_lnk, 'DELETE FROM card_voters WHERE card_id = $1 AND user_id NOT IN (select user_id FROM boards_users WHERE board_id = $2)', $qry_val_arr);
            $comment = '##USER_NAME## moved the card ##CARD_LINK## to different board.';
        }
        if (isset($previous_value['name']) && isset($r_put['name']) && $r_put['name'] != $previous_value['name']) {
            $comment = '##USER_NAME## renamed ##CARD_LINK##';
        }
        if (empty($previous_value['description']) && isset($r_put['description'])) {
            $comment = '##USER_NAME## added card description in the card ##CARD_LINK## - ##DESCRIPTION##';
            $activity_type = 'add_card_desc';
        } else if (isset($previous_value) && isset($r_put['description']) && $r_put['description'] != $previous_value['description']) {
            if (empty($r_put['description'])) {
                $comment = '##USER_NAME## removed description from the card ##CARD_LINK##';
            } else {
                $comment = '##USER_NAME## updated description on the card ##CARD_LINK##';
            }
            $activity_type = 'edit_card_desc';
        }
        if (isset($previous_value['list_id']) && isset($r_put['list_id']) && $r_put['list_id'] != $previous_value['list_id'] && isset($previous_value['board_id']) && isset($r_put['board_id']) && $r_put['board_id'] == $previous_value['board_id']) {
            $qry_val_arr = array(
                $r_put['list_id']
            );
            $s_result = pg_query_params($db_lnk, 'SELECT name FROM lists WHERE id = $1', $qry_val_arr);
            $list_value = pg_fetch_assoc($s_result);
            $qry_val_arr = array(
                $previous_value['list_id']
            );
            $s_result = pg_query_params($db_lnk, 'SELECT name FROM lists WHERE id = $1', $qry_val_arr);
            $previous_list_value = pg_fetch_assoc($s_result);
            $comment = '##USER_NAME## moved the card ##CARD_LINK## from ' . $previous_list_value['name'] . ' list to ' . $list_value['name'] . '.';
        }
        if (empty($previous_value['color']) && isset($r_put['color'])) {
            $comment = '##USER_NAME## added card color - ' . $r_put['color'] . ' in the card ##CARD_LINK##';
            $activity_type = 'add_card_color';
        } else if (!empty($previous_value) && isset($r_put['color']) && $r_put['color'] != $previous_value['color']) {
            if (empty($r_put['color'])) {
                $comment = '##USER_NAME## removed card color - ' . $previous_value['color'] . ' from the card ##CARD_LINK##';
                $activity_type = 'delete_card_color';
            } else {
                $comment = '##USER_NAME## updated card color - ' . $r_put['color'] . ' on the card ##CARD_LINK##';
                $activity_type = 'edit_card_color';
            }
        }
        unset($r_put['start']);
        $response = update_query($table_name, $id, $r_resource_cmd, $r_put, $comment, $activity_type, $foreign_ids);
        if (!empty($childCardResponse)) {
            $response['child_cards'] = $childCardResponse;
        }
        echo json_encode($response);
        break;

    case '/boards/?/lists/?/cards/?/comments/?': // comment update
        $table_name = 'activities';
        $id = $r_resource_vars['comments'];
        $foreign_ids['board_id'] = $r_resource_vars['boards'];
        $foreign_ids['list_id'] = $r_resource_vars['lists'];
        $foreign_ids['card_id'] = $r_resource_vars['cards'];
        $comment = '##USER_NAME## updated comment to this card ##CARD_LINK##';
        $activity_type = 'edit_comment';
        $response = update_query($table_name, $id, $r_resource_cmd, $r_put, $comment, $activity_type, $foreign_ids);
        echo json_encode($response);
        break;

    case '/boards/?/lists/?/cards/?/attachments/?': // card attachment update
        $table_name = 'card_attachments';
        $id = $r_resource_vars['attachments'];
        $foreign_ids['board_id'] = $r_resource_vars['boards'];
        $foreign_ids['list_id'] = $r_resource_vars['lists'];
        $foreign_ids['card_id'] = $r_resource_vars['cards'];
        $data = array(
            $foreign_ids['card_id'],
            $foreign_ids['board_id'],
            $foreign_ids['list_id']
        );
        pg_query_params($db_lnk, 'UPDATE card_attachments SET is_cover = false WHERE card_id = $1 AND board_id = $2 AND list_id = $3', $data);
        $comment = '##USER_NAME## updated card attachments to this card ##CARD_LINK##';
        $activity_type = 'update_card_attachment';
        $response = update_query($table_name, $id, $r_resource_cmd, $r_put, $comment, $activity_type, $foreign_ids);
        echo json_encode($response);
        break;

    case '/boards/?/lists/?/cards/?/checklists/?':
        $table_name = 'checklists';
        $id = $r_resource_vars['checklists'];
        $foreign_ids['board_id'] = $r_resource_vars['boards'];
        $foreign_ids['list_id'] = $r_resource_vars['lists'];
        $foreign_ids['card_id'] = $r_resource_vars['cards'];
        $comment = '##USER_NAME## updated checklist of card "##CARD_LINK##"';
        unset($r_put['checklists_items']);
        unset($r_put['created']);
        unset($r_put['modified']);
        unset($r_put['checklist_item_completed_count']);
        unset($r_put['checklist_item_count']);
        unset($r_put['is_offline']);
        unset($r_put['list_id']);
        unset($r_put['board_id']);
        if (isset($r_put['position']) && !empty($r_put['position'])) {
            $comment = '##USER_NAME## moved checklist ##CHECKLIST_NAME## on the card ##CARD_LINK##';
        }
        $activity_type = 'update_card_checklist';
        $response = update_query($table_name, $id, $r_resource_cmd, $r_put, $comment, $activity_type, $foreign_ids);
        echo json_encode($response);
        break;

    case '/boards/?/lists/?/cards/?/checklists/?/items/?':
        $table_name = 'checklist_items';
        $id = $r_resource_vars['items'];
        $comment = '';
        $foreign_ids['board_id'] = $r_resource_vars['boards'];
        $foreign_ids['list_id'] = $r_resource_vars['lists'];
        $foreign_ids['card_id'] = $r_resource_vars['cards'];
        unset($r_put['created']);
        unset($r_put['modified']);
        unset($r_put['is_offline']);
        unset($r_put['list_id']);
        unset($r_put['board_id']);
        $qry_val_arr = array(
            $r_resource_vars['items']
        );
        $prev_value = executeQuery('SELECT * FROM ' . $table_name . ' WHERE id =  $1', $qry_val_arr);
        $activity_type = 'update_card_checklist_item';
        if (!empty($r_put['is_completed'])) {
            $comment = '##USER_NAME## updated ' . $prev_value['name'] . ' as completed on the card ##CARD_LINK##';
        } else if (isset($r_put['position'])) {
            $comment = '##USER_NAME## moved checklist item ##CHECKLIST_ITEM_NAME## on the card ##CARD_LINK##';
            if (isset($r_put['checklist_id']) && $r_put['checklist_id'] != $prev_value['checklist_id']) {
                $activity_type = 'moved_card_checklist_item';
            }
        } else if (isset($r_put['is_completed']) && $r_put['is_completed'] == 'false') {
            $comment = '##USER_NAME## updated ' . $prev_value['name'] . ' as incomplete on the card ##CARD_LINK##';
        } else {
            $comment = '##USER_NAME## updated item name of ' . $r_put['name'] . ' in the card ##CARD_LINK##';
        }
        $response = update_query($table_name, $id, $r_resource_cmd, $r_put, $comment, $activity_type, $foreign_ids);
        echo json_encode($response);
        break;

    case '/activities/undo/?':
        $qry_val_arr = array(
            $r_resource_vars['undo']
        );
        $comment = '';
        $activity = executeQuery('SELECT * FROM activities WHERE id =  $1', $qry_val_arr);
        if (!empty($activity['revisions']) && trim($activity['revisions']) != '') {
            $revisions = unserialize($activity['revisions']);
            if ($activity['type'] == 'update_card_checklist_item') {
                $table_name = 'checklist_items';
                $id = $activity['foreign_id'];
                $r_put = $revisions['old_value'];
                $foreign_ids['board_id'] = $activity['board_id'];
                $foreign_ids['list_id'] = $activity['list_id'];
                $foreign_ids['card_id'] = $activity['card_id'];
                $comment = '##USER_NAME## undo this card ##CARD_LINK## checklist item ##CHECKLIST_ITEM_NAME##';
                $activity_type = 'update_card_checklist_item';
                $response['undo']['checklist_item'] = $r_put;
                $response['undo']['checklist_item']['id'] = $id;
            } else if ($activity['type'] == 'update_card_checklist') {
                $table_name = 'checklists';
                $id = $activity['foreign_id'];
                $r_put = $revisions['old_value'];
                $foreign_ids['board_id'] = $activity['board_id'];
                $foreign_ids['list_id'] = $activity['list_id'];
                $foreign_ids['card_id'] = $activity['card_id'];
                $comment = '##USER_NAME## undo this card ##CARD_LINK## checklist ##CHECKLIST_NAME##';
                $activity_type = 'update_card_checklist';
                $response['undo']['checklist'] = $r_put;
                $response['undo']['checklist']['id'] = $id;
            } else if ($activity['type'] == 'edit_comment') {
                $table_name = 'activities';
                $id = $activity['foreign_id'];
                if (!is_array($revisions['old_value'])) {
                    $r_put['comment'] = $revisions['old_value'];
                } else {
                    $r_put = $revisions['old_value'];
                }
                $foreign_ids['board_id'] = $activity['board_id'];
                $foreign_ids['list_id'] = $activity['list_id'];
                $foreign_ids['card_id'] = $activity['card_id'];
                $comment = '##USER_NAME## undo this card ##CARD_LINK## comment';
                $activity_type = 'edit_comment';
                $response['undo']['edit_comment'] = $id;
                $response['undo']['card'] = $r_put;
                $response['undo']['card']['id'] = $activity['card_id'];
            } else if ($activity['type'] == 'delete_card_comment') {
                $table_name = 'activities';
                $id = $activity['foreign_id'];
                if (!is_array($revisions['old_value'])) {
                    $r_put['comment'] = $revisions['old_value'];
                } else {
                    $r_put = $revisions['old_value'];
                }
                $foreign_ids['board_id'] = $activity['board_id'];
                $foreign_ids['list_id'] = $activity['list_id'];
                $foreign_ids['card_id'] = $activity['card_id'];
                $comment = '##USER_NAME## undo this card ##CARD_LINK## comment';
                $activity_type = 'delete_card_comment';
                $response['undo']['delete_card_comment'] = $id;
                $response['undo']['card'] = $r_put;
                $response['undo']['card']['id'] = $activity['card_id'];
            } else if (!empty($activity['card_id'])) {
                $table_name = 'cards';
                $id = $activity['card_id'];
                $r_put = $revisions['old_value'];
                $foreign_ids['board_id'] = $activity['board_id'];
                $foreign_ids['list_id'] = $activity['list_id'];
                $foreign_ids['card_id'] = $activity['card_id'];
                $comment = '##USER_NAME## undo this card ##CARD_LINK##';
                $activity_type = (!empty($activity['type']) && $activity['type'] != 'edit_card') ? $activity['type'] : 'edit_card';
                $response['undo']['card'] = $r_put;
                $response['undo']['card']['id'] = $id;
            } else if (!empty($activity['list_id'])) {
                $table_name = 'lists';
                $id = $activity['list_id'];
                $r_put = $revisions['old_value'];
                $foreign_ids['board_id'] = $activity['board_id'];
                $foreign_ids['list_id'] = $activity['list_id'];
                $comment = '##USER_NAME## undo this list.';
                $activity_type = (!empty($activity['type']) && $activity['type'] != 'edit_list') ? $activity['type'] : 'edit_list';
                $response['undo']['list'] = $r_put;
                $response['undo']['list']['id'] = $id;
            } else if (!empty($activity['board_id'])) {
                $table_name = 'boards';
                $id = $activity['board_id'];
                $r_put = $revisions['old_value'];
                $foreign_ids['board_id'] = $activity['board_id'];
                $comment = '##USER_NAME## undo this board.';
                $activity_type = (!empty($activity['type']) && $activity['type'] != 'edit_board') ? $activity['type'] : 'edit_board';
                $response['undo']['board'] = $r_put;
                $response['undo']['board']['id'] = $id;
            }
        }
        $activity_response = update_query($table_name, $id, $r_resource_cmd, $r_put, $comment, $activity_type, $foreign_ids);
        $response = array_merge($response, $activity_response);
        echo json_encode($response);
        break;

    case '/boards/?/board_subscribers/?': //boards subscribers update
        $json = true;
        $table_name = 'board_subscribers';
        $id = $r_resource_vars['board_subscribers'];
        $response['success'] = 'Updated successfully.';
        $response['id'] = $id;
        $response = update_query($table_name, $id, $r_resource_cmd, $r_put);
        echo json_encode($response);
        break;

    case '/boards/?/lists/?/list_subscribers/?': //lists update
        $json = true;
        $table_name = 'list_subscribers';
        $id = $r_resource_vars['list_subscribers'];
        $response = update_query($table_name, $id, $r_resource_cmd, $r_put);
        echo json_encode($response);
        break;

    case '/organizations/?':
        $json = true;
        $table_name = 'organizations';
        $id = $r_resource_vars['organizations'];
        $foreign_ids['organization_id'] = $r_resource_vars['organizations'];
        if (isset($r_put['logo_url']) && ($r_put['logo_url'] == 'null' || $r_put['logo_url'] == 'NULL')) {
            foreach ($thumbsizes['Organization'] as $key => $value) {
                $mediadir = IMG_PATH . DS . $key . DS . 'Organization' . DS . $id;
                $list = glob($mediadir . '.*');
                if (!empty($list) && isset($list[0]) && file_exists($list[0])) {
                    unlink($list[0]);
                }
            }
            $comment = ((!empty($authUser['full_name'])) ? $authUser['full_name'] : $authUser['username']) . ' deleted attachment from organizations ##ORGANIZATION_LINK##';
            $activity_type = 'delete_organization_attachment';
        } else {
            $organization_visibility = array(
                '',
                'Public',
                'Private'
            );
            if (isset($r_put['name'])) {
                $comment = '##USER_NAME## edited "##ORGANIZATION_LINK##" organization.';
                $activity_type = 'edit_organization';
            } else if (isset($r_put['organization_visibility'])) {
                $comment = '##USER_NAME## changed organization visibility to ' . $organization_visibility[$r_put['organization_visibility']];
                $activity_type = 'change_visibility';
            }
        }
        $qry_val_arr = array(
            $r_resource_vars['organizations']
        );
        executeQuery('SELECT id FROM ' . $table_name . ' WHERE id = $1', $qry_val_arr);
        $response = update_query($table_name, $id, $r_resource_cmd, $r_put, $comment, $activity_type, $foreign_ids);
        echo json_encode($response);
        break;

    case '/organizations_users/?':
        $json = true;
        $table_name = 'organizations_users';
        $id = $r_resource_vars['organizations_users'];
        $qry_val_arr = array(
            $r_resource_vars['organizations_users']
        );
        executeQuery('SELECT id FROM ' . $table_name . ' WHERE id =  $1', $qry_val_arr);
        $response = update_query($table_name, $id, $r_resource_cmd, $r_put);
        echo json_encode($response);
        break;

    case '/webhooks/?':
        $json = true;
        $table_name = 'webhooks';
        $id = $r_resource_vars['webhooks'];
        $response = update_query($table_name, $id, $r_resource_cmd, $r_put);
        echo json_encode($response);
        break;

    case '/roles/?':
        $json = true;
        $table_name = 'roles';
        $id = $r_resource_vars['roles'];
        $response = update_query($table_name, $id, $r_resource_cmd, $r_put);
        echo json_encode($response);
        break;

    case '/board_user_roles/?':
        $json = true;
        $table_name = 'board_user_roles';
        $id = $r_resource_vars['board_user_roles'];
        $response = update_query($table_name, $id, $r_resource_cmd, $r_put);
        echo json_encode($response);
        break;

    case '/organization_user_roles/?':
        $json = true;
        $table_name = 'organization_user_roles';
        $id = $r_resource_vars['organization_user_roles'];
        $response = update_query($table_name, $id, $r_resource_cmd, $r_put);
        echo json_encode($response);
        break;

    default:
        $plugin_url['CustomFields'] = array(
            '/custom_fields/?',
            '/boards/?/custom_fields/?',
            '/custom_fields/update_position'
        );
        $plugin_url['Broadcast'] = array(
            '/broadcasts/?'
        );
        $plugin_url['Group'] = array(
            '/groups/?'
        );
        $plugin_url['DrawIO'] = array(
            '/card_diagrams/?'
        );
        $plugin_url['Wiki'] = array(
            '/pages/?'
        );
        $plugin_url['CRM'] = array(
            '/contacts/?'
        );
        $plugin_url['Salesforce'] = array(
            '/salesforce/?'
        );
        foreach ($plugin_url as $plugin_key => $plugin_values) {
            if (in_array($r_resource_cmd, $plugin_values)) {
                $pluginToBePassed = $plugin_key;
                break;
            }
        }
        if (!empty($pluginToBePassed)) {
            require_once PLUGIN_PATH . DS . $pluginToBePassed . DS . 'R' . DS . 'r.php';
            $passed_values = array();
            $passed_values['sql'] = $sql;
            $passed_values['r_resource_cmd'] = $r_resource_cmd;
            $passed_values['r_resource_vars'] = $r_resource_vars;
            $passed_values['r_resource_filters'] = $r_resource_filters;
            $passed_values['authUser'] = $authUser;
            $passed_values['r_put'] = $r_put;
            if (!empty($table_name)) {
                $passed_values['table_name'] = $table_name;
            }
            if (!empty($siteCurrencyCode)) {
                $passed_values['siteCurrencyCode'] = $siteCurrencyCode;
            }
            if (!empty($enabledPlugins)) {
                $passed_values['enabledPlugins'] = $enabledPlugins;
            }
            $plugin_return = call_user_func($plugin_key . '_r_put', $passed_values);
            echo json_encode($plugin_return);
            break;
        }
        header($_SERVER['SERVER_PROTOCOL'] . ' 501 Not Implemented', true, 501);
        break;
    }
}
/**
 * Common method to handle DELETE method
 *
 * @param string $r_resource_cmd     URL
 * @param array  $r_resource_vars    Array generated from URL
 * @param array  $r_resource_filters Array generated from URL query string
 *
 * @return mixed
 */
function r_delete($r_resource_cmd, $r_resource_vars, $r_resource_filters)
{
    global $r_debug, $db_lnk, $authUser, $_server_domain_url, $jabberHost, $thumbsizes;
    $sql = false;
    $pg_params = $diff = $response = $conditions = $foreign_ids = $foreign_id = $revisions_del = array();
    $activity_type = '';
    switch ($r_resource_cmd) {
    case '/users/?': // delete users
        $qry_val_arr = array(
            $r_resource_vars['users']
        );
        $s_result = pg_query_params($db_lnk, 'SELECT username, role_id FROM users WHERE id = $1', $qry_val_arr);
        $username = pg_fetch_assoc($s_result);
        if ($username['role_id'] == 1) {
            $response['error'] = 'Admin users can\'t be deleted';
        } else {
            $foreign_id['user_id'] = $r_resource_vars['users'];
            $comment = '##USER_NAME## deleted "' . $username['username'] . '"';
            $response['activity'] = insertActivity($authUser['id'], $comment, 'delete_user', $foreign_id);
            $sql = 'DELETE FROM users WHERE id= $1';
            array_push($pg_params, $r_resource_vars['users']);
            if (is_plugin_enabled('r_chat') && $jabberHost) {
                xmppDeleteSingleUser($username);
            }
        }
        break;

    case '/organizations/?/organizations_users/?': // delete organization user
        $qry_val_arr = array(
            $r_resource_vars['organizations_users']
        );
        $s_result = pg_query_params($db_lnk, 'SELECT username, organization_id, name, full_name FROM organizations_users_listing WHERE id = $1', $qry_val_arr);
        $previous_value = pg_fetch_assoc($s_result);
        $foreign_ids['organization_id'] = $previous_value['organization_id'];
        $comment = '##USER_NAME## removed member "' . $previous_value['full_name'] . '" from organization';
        $response['activity'] = insertActivity($authUser['id'], $comment, 'delete_organization_user', $foreign_ids, '', $r_resource_vars['organizations_users']);
        $sql = 'DELETE FROM organizations_users WHERE id= $1';
        array_push($pg_params, $r_resource_vars['organizations_users']);
        $qry_val_arr = array(
            $r_resource_vars['organizations_users']
        );
        $organizations_users_result = pg_query_params($db_lnk, 'SELECT user_id FROM organizations_users_listing WHERE id = $1', $qry_val_arr);
        $organizations_users = pg_fetch_assoc($organizations_users_result);
        $conditions = array(
            $previous_value['organization_id'],
            $organizations_users['user_id']
        );
        pg_query_params($db_lnk, 'DELETE FROM boards_users WHERE board_id IN (SELECT id FROM boards WHERE organization_id = $1) AND user_id = $2', $conditions);
        break;

    case '/boards/?/boards_users/?': // delete board user
        $qry_val_arr = array(
            $r_resource_vars['boards_users']
        );
        $s_result = pg_query_params($db_lnk, 'SELECT username, full_name, board_id, user_id, board_name FROM boards_users_listing WHERE id = $1', $qry_val_arr);
        $previous_value = pg_fetch_assoc($s_result);
        $foreign_ids['board_id'] = $previous_value['board_id'];
        $comment = '##USER_NAME## removed member "' . $previous_value['username'] . '" from board';
        $response['activity'] = insertActivity($authUser['id'], $comment, 'delete_board_user', $foreign_ids, '', $r_resource_vars['boards_users']);
        $sql = 'DELETE FROM boards_users WHERE id= $1';
        $conditions = array(
            $previous_value['board_id']
        );
        $cards = pg_query_params($db_lnk, 'SELECT id FROM cards WHERE board_id = $1', $conditions);
        while ($row = pg_fetch_assoc($cards)) {
            $conditions = array(
                $row['id'],
                $previous_value['user_id']
            );
            pg_query_params($db_lnk, 'DELETE FROM cards_users WHERE card_id = $1 AND user_id = $2', $conditions);
            pg_query_params($db_lnk, 'DELETE FROM card_subscribers WHERE card_id = $1 AND user_id = $2', $conditions);
        }
        $board_user = executeQuery('SELECT * FROM boards_users WHERE id =  $1', $qry_val_arr);
        if (!empty($board_user)) {
            $conditions = array(
                $board_user['board_id'],
                $board_user['user_id']
            );
            pg_query_params($db_lnk, 'DELETE FROM board_stars WHERE board_id = $1 AND user_id = $2', $conditions);
            pg_query_params($db_lnk, 'DELETE FROM board_subscribers WHERE board_id = $1 AND user_id = $2', $conditions);
        }
        array_push($pg_params, $r_resource_vars['boards_users']);
        if (is_plugin_enabled('r_chat') && $jabberHost) {
            xmppRevokeMember($previous_value);
        }
        break;

    case '/boards/?': // delete boards
        if (is_plugin_enabled('r_chat') && $jabberHost) {
            $xmpp = xmppObj();
            xmppDestroyRoom($r_resource_vars['boards'], $xmpp);
        }
        $sql = 'DELETE FROM boards WHERE id = $1';
        array_push($pg_params, $r_resource_vars['boards']);
        break;

    case '/boards/?/lists/?': // delete lists
        $qry_val_arr = array(
            $r_resource_vars['lists']
        );
        $s_result = pg_query_params($db_lnk, 'SELECT name, board_id, position FROM lists WHERE id = $1', $qry_val_arr);
        $previous_value = pg_fetch_assoc($s_result);
        $foreign_id['board_id'] = $r_resource_vars['boards'];
        $foreign_id['list_id'] = $r_resource_vars['lists'];
        $comment = '##USER_NAME## deleted list "' . $previous_value['name'] . '"';
        $response['activity'] = insertActivity($authUser['id'], $comment, 'delete_list', $foreign_id);
        $sql = 'DELETE FROM lists WHERE id= $1';
        array_push($pg_params, $r_resource_vars['lists']);
        break;

    case '/boards/?/lists': // delete Archived lists
        $sql = 'DELETE FROM lists WHERE board_id = $1 AND is_archived = true';
        $foreign_id['board_id'] = $r_resource_vars['boards'];
        $comment = '##USER_NAME## deleted all archived list(s) on ##BOARD_NAME##';
        $response['activity'] = insertActivity($authUser['id'], $comment, 'delete_archived_list', $foreign_id);
        array_push($pg_params, $r_resource_vars['boards']);
        break;

    case '/boards/?/cards': // delete Archived cards
        $sql = 'DELETE FROM cards WHERE board_id = $1 AND is_archived = true';
        $foreign_id['board_id'] = $r_resource_vars['boards'];
        $comment = '##USER_NAME## deleted all archived card(s) on ##BOARD_NAME##';
        $response['activity'] = insertActivity($authUser['id'], $comment, 'delete_archived_card', $foreign_id);
        array_push($pg_params, $r_resource_vars['boards']);
        break;

    case '/organizations/?': // delete organization
        $foreign_id['organization_id'] = $r_resource_vars['organizations'];
        $comment = '##USER_NAME## deleted organization';
        $response['activity'] = insertActivity($authUser['id'], $comment, 'delete_organization', $foreign_id);
        $data = array(
            0,
            2,
            $foreign_id['organization_id']
        );
        pg_query_params($db_lnk, 'UPDATE boards SET organization_id = $1, board_visibility = $2 WHERE organization_id = $3', $data);
        $conditions = array(
            $foreign_id['organization_id']
        );
        $s_result = pg_query_params($db_lnk, 'SELECT user_id FROM organizations WHERE id = $1', $conditions);
        $organization = pg_fetch_assoc($s_result);
        $conditions = array(
            $organization['user_id'],
            $foreign_id['organization_id']
        );
        pg_query_params($db_lnk, 'DELETE FROM organizations_users WHERE user_id = $1 AND organization_id = $2', $conditions);
        $sql = 'DELETE FROM organizations WHERE id= $1';
        array_push($pg_params, $r_resource_vars['organizations']);
        break;

    case '/boards/?/labels/?': // delete Labels in Filter
        $sql = 'DELETE FROM cards_labels WHERE board_id = $1 AND label_id = $2';
        array_push($pg_params, $r_resource_vars['boards'], $r_resource_vars['labels']);
        $comment = __l('##USER_NAME## removed label ##LABEL_NAME## on ##BOARD_NAME##');
        $type = 'delete_label';
        $label_id['id'] = $r_resource_vars['labels'];
        $revision = json_encode($label_id);
        $qry_val_arr = array(
            $r_resource_vars['boards'],
            $authUser['id'],
            $type,
            $comment,
            $_GET['token'],
            $revision
        );
        $activity = pg_fetch_assoc(pg_query_params($db_lnk, 'INSERT INTO activities (created, modified, board_id, user_id, type, comment, token, revisions) VALUES (now(), now(),$1, $2, $3, $4, $5, $6) RETURNING id', $qry_val_arr));
        break;

    case '/boards/?/lists/?/cards/?': // delete card
        $qry_val_arr = array(
            $r_resource_vars['cards']
        );
        $s_result = pg_query_params($db_lnk, 'SELECT name, board_id, position FROM cards WHERE id = $1', $qry_val_arr);
        $previous_value = pg_fetch_assoc($s_result);
        $foreign_id['board_id'] = $r_resource_vars['boards'];
        $foreign_id['list_id'] = $r_resource_vars['lists'];
        $foreign_id['card_id'] = $r_resource_vars['cards'];
        $comment = '##USER_NAME## deleted card ' . $previous_value['name'];
        $response['activity'] = insertActivity($authUser['id'], $comment, 'delete_card', $foreign_id);
        $sql = 'DELETE FROM cards WHERE id = $1';
        array_push($pg_params, $r_resource_vars['cards']);
        if (is_plugin_enabled('r_elasticsearch')) {
            require_once PLUGIN_PATH . DS . 'ElasticSearch' . DS . 'functions.php';
            deleteCardFromElastica($r_resource_vars['cards']);
        }
        break;

    case '/boards/?/lists/?/cards/?/card_voters/?': // delete card voters
        $sql = 'DELETE FROM card_voters WHERE id = $1';
        array_push($pg_params, $r_resource_vars['card_voters']);
        $foreign_ids['board_id'] = $r_resource_vars['boards'];
        $foreign_ids['list_id'] = $r_resource_vars['lists'];
        $foreign_ids['card_id'] = $r_resource_vars['cards'];
        $comment = '##USER_NAME## unvoted the card ##CARD_LINK##';
        $response['activity'] = insertActivity($authUser['id'], $comment, 'unvote_card', $foreign_ids, null, $r_resource_vars['card_voters']);
        break;

    case '/boards/?/lists/?/cards/?/comments/?': // comment DELETE
        $qry_val_arr = array(
            $r_resource_vars['comments']
        );
        $revisions = executeQuery('SELECT comment, revisions FROM activities WHERE id =  $1 OR foreign_id = $1 ORDER BY id desc limit 1', $qry_val_arr);
        $comment = '##USER_NAME## deleted comment in card ##CARD_LINK##';
        if (!empty($revisions['revisions'])) {
            $revision = unserialize($revisions['revisions']);
            $revisions_del['comment'] = $comment;
            if (isset($revision['new_value']['comment'])) {
                $revisions_del['old_value'] = $revision['new_value']['comment'];
            } else {
                $revisions_del['old_value'] = '';
            }
            $revisions_del['new_value'] = '';
            $revisions_del = serialize($revisions_del);
        } else {
            $revisions_del['comment'] = $comment;
            $revisions_del['old_value'] = $revisions['comment'];
            $revisions_del['new_value'] = '';
            $revisions_del = serialize($revisions_del);
        }
        $sql = 'DELETE FROM activities WHERE id = $1';
        array_push($pg_params, $r_resource_vars['comments']);
        $foreign_ids['board_id'] = $r_resource_vars['boards'];
        $foreign_ids['list_id'] = $r_resource_vars['lists'];
        $foreign_ids['card_id'] = $r_resource_vars['cards'];
        $response['activity'] = insertActivity($authUser['id'], $comment, 'delete_card_comment', $foreign_ids, $revisions_del, $r_resource_vars['comments']);
        if (!empty($response['activity']['revisions']) && trim($response['activity']['revisions']) != '') {
            $revisions = unserialize($response['activity']['revisions']);
        }
        if (!empty($revisions) && $response['activity']['type'] != 'moved_card_checklist_item') {
            if (!empty($revisions['new_value'])) {
                foreach ($revisions['new_value'] as $key => $value) {
                    if ($key != 'is_archived' && $key != 'is_deleted' && $key != 'created' && $key != 'modified' && $key != 'is_offline' && $key != 'uuid' && $key != 'to_date' && $key != 'temp_id' && $activity_type != 'moved_card_checklist_item' && $activity_type != 'add_card_desc' && $activity_type != 'add_card_duedate' && $activity_type != 'delete_card_duedate' && $activity_type != 'add_background' && $activity_type != 'change_background' && $activity_type != 'change_visibility') {
                        $old_val = (isset($revisions['old_value'][$key])) ? $revisions['old_value'][$key] : '';
                        $new_val = (isset($revisions['new_value'][$key])) ? $revisions['new_value'][$key] : '';
                        $diff[] = nl2br(getRevisiondifference($old_val, $new_val));
                    }
                    if ($activity_type == 'add_card_desc' || $activity_type == 'edit_card_duedate' || $activity_type == 'add_background' || $activity_type == 'change_background' || $activity_type == 'change_visibility') {
                        $diff[] = $revisions['new_value'][$key];
                    }
                }
            } else if (!empty($revisions['old_value']) && isset($response['activity']['type']) && $response['activity']['type'] == 'delete_card_comment') {
                $diff[] = nl2br(getRevisiondifference($revisions['old_value'], ''));
            }
        }
        if (isset($diff)) {
            $response['activity']['difference'] = $diff;
        }
        $result = pg_query_params($db_lnk, $sql, $pg_params);
        if ($result) {
            $conditions = array(
                $r_resource_vars['comments']
            );
            pg_query_params($db_lnk, "DELETE FROM activities WHERE path like '%P" . $r_resource_vars['comments'] . "%'", array());
        }
        $conditions = array(
            $r_resource_vars['cards']
        );
        $activity_count = executeQuery("SELECT COUNT(id) as total_count FROM activities WHERE type = 'add_comment' AND card_id = $1", $conditions);
        $activity_count = (!empty($activity_count)) ? $activity_count['total_count'] : 0;
        $qry_val_arr = array(
            $activity_count,
            $r_resource_vars['cards']
        );
        pg_query_params($db_lnk, 'UPDATE cards SET comment_count = $1 WHERE id = $2', $qry_val_arr);
        $response['activity']['comment_count'] = $activity_count;
        $response['error'] = array(
            'code' => (!$result) ? 1 : 0
        );
        $sql = false;
        break;

    case '/boards/?/lists/?/cards/?/attachments/?': //delete card attachment
        $sql = 'DELETE FROM card_attachments WHERE id = $1';
        array_push($pg_params, $r_resource_vars['attachments']);
        $foreign_ids['board_id'] = $r_resource_vars['boards'];
        $foreign_ids['list_id'] = $r_resource_vars['lists'];
        $foreign_ids['card_id'] = $r_resource_vars['cards'];
        $comment = '##USER_NAME## deleted attachment from the card ##CARD_LINK##';
        $response['activity'] = insertActivity($authUser['id'], $comment, 'delete_card_attachment', $foreign_ids, null, $r_resource_vars['attachments']);
        $mediadir = MEDIA_PATH . DS . 'Card' . DS . $r_resource_vars['cards'];
        $qry_val_arr = array(
            $r_resource_vars['attachments']
        );
        $attachment = executeQuery('SELECT name, path FROM card_attachments WHERE id =  $1', $qry_val_arr);
        if (!empty($attachment)) {
            $file = APP_PATH . DS . $attachment['path'];
            if (file_exists($file)) {
                unlink($file);
            }
            foreach ($thumbsizes['CardAttachment'] as $key => $value) {
                $file_ext = explode('.', $attachment['name']);
                $hash = md5(SECURITYSALT . 'CardAttachment' . $r_resource_vars['attachments'] . $file_ext[1] . $key);
                $thumb_file = IMG_PATH . DS . $key . DS . 'Organization' . DS . $r_resource_vars['attachments'] . '.' . $hash . '.' . $file_ext[1];
                if (file_exists($thumb_file)) {
                    unlink($thumb_file);
                }
            }
        }
        break;

    case '/boards/?/lists/?/cards/?/checklists/?': // delete checklist
        $qry_val_arr = array(
            $r_resource_vars['checklists']
        );
        $s_result = pg_query_params($db_lnk, 'SELECT name FROM checklists WHERE id = $1', $qry_val_arr);
        $checklist = pg_fetch_assoc($s_result);
        pg_query_params($db_lnk, 'DELETE FROM checklist_items WHERE checklist_id = $1', $qry_val_arr);
        $foreign_ids['board_id'] = $r_resource_vars['boards'];
        $foreign_ids['list_id'] = $r_resource_vars['lists'];
        $foreign_ids['card_id'] = $r_resource_vars['cards'];
        $comment = '##USER_NAME## deleted checklist ' . $checklist['name'] . ' from the card ##CARD_LINK##';
        $response['activity'] = insertActivity($authUser['id'], $comment, 'delete_checklist', $foreign_ids, null, $r_resource_vars['checklists']);
        $sql = 'DELETE FROM checklists WHERE id = $1';
        array_push($pg_params, $r_resource_vars['checklists']);
        break;

    case '/boards/?/lists/?/cards/?/checklists/?/items/?': // delete items
        $foreign_ids['board_id'] = $r_resource_vars['boards'];
        $foreign_ids['list_id'] = $r_resource_vars['lists'];
        $foreign_ids['card_id'] = $r_resource_vars['cards'];
        $qry_val_arr = array(
            $r_resource_vars['items']
        );
        $s_result = pg_query_params($db_lnk, 'SELECT name FROM checklist_items WHERE id = $1', $qry_val_arr);
        $checklist_item = pg_fetch_assoc($s_result);
        $comment = '##USER_NAME## deleted checklist ' . $checklist_item['name'] . ' item from the card ##CARD_LINK##';
        $response['activity'] = insertActivity($authUser['id'], $comment, 'delete_checklist_item', $foreign_ids, null, $r_resource_vars['items']);
        $sql = 'DELETE FROM checklist_items WHERE id = $1';
        array_push($pg_params, $r_resource_vars['items']);
        break;

    case '/boards/?/lists/?/cards/?/cards_users/?': // delete  card_user
        $foreign_ids['board_id'] = $r_resource_vars['boards'];
        $foreign_ids['list_id'] = $r_resource_vars['lists'];
        $foreign_ids['card_id'] = $r_resource_vars['cards'];
        $comment = '##USER_NAME## deleted member from the card ##CARD_LINK##';
        $response['activity'] = insertActivity($authUser['id'], $comment, 'delete_card_users', $foreign_ids, null, $r_resource_vars['cards_users']);
        $sql = 'DELETE FROM cards_users WHERE id = $1';
        $qry_val_arr = array(
            $r_resource_vars['cards_users']
        );
        $card_user = executeQuery('SELECT * FROM cards_users WHERE id =  $1', $qry_val_arr);
        if (!empty($card_user)) {
            $conditions = array(
                $card_user['card_id'],
                $card_user['user_id']
            );
            pg_query_params($db_lnk, 'DELETE FROM card_subscribers WHERE card_id = $1 AND user_id = $2', $conditions);
        }
        array_push($pg_params, $r_resource_vars['cards_users']);
        break;

    case '/oauth/clients/?':
        $sql = 'DELETE FROM oauth_clients WHERE id= $1';
        array_push($pg_params, $r_resource_vars['clients']);
        break;

    case '/oauth/applications/?':
        $conditions = array(
            $r_resource_vars['applications']
        );
        pg_query_params($db_lnk, 'DELETE FROM oauth_access_tokens WHERE client_id = $1', $conditions);
        pg_query_params($db_lnk, 'DELETE FROM oauth_refresh_tokens WHERE client_id = $1', $conditions);
        $sql = false;
        break;

    case '/webhooks/?':
        $sql = 'DELETE FROM webhooks WHERE id= $1';
        array_push($pg_params, $r_resource_vars['webhooks']);
        break;

    case '/roles/?':
        $sql = 'DELETE FROM roles WHERE id= $1';
        $d_sql = 'UPDATE users SET role_id = 2 WHERE role_id = $1';
        array_push($pg_params, $r_resource_vars['roles']);
        break;

    case '/board_user_roles/?':
        $sql = 'DELETE FROM board_user_roles WHERE id= $1';
        $d_sql = 'UPDATE boards_users SET board_user_role_id = 3 WHERE board_user_role_id = $1';
        array_push($pg_params, $r_resource_vars['board_user_roles']);
        break;

    case '/organization_user_roles/?':
        $sql = 'DELETE FROM organization_user_roles WHERE id= $1';
        $d_sql = 'UPDATE organizations_users SET organization_user_role_id = 3 WHERE organization_user_role_id = $1';
        array_push($pg_params, $r_resource_vars['organization_user_roles']);
        break;

    default:
        $plugin_url['CustomFields'] = array(
            '/custom_fields/?',
            '/boards/?/custom_fields/?'
        );
        $plugin_url['CardTemplate'] = array(
            '/boards/?/card_templates/?'
        );
        $plugin_url['Gantt'] = array(
            '/boards/?/card_dependencies/?'
        );
        $plugin_url['Broadcast'] = array(
            '/broadcasts/?'
        );
        $plugin_url['Group'] = array(
            '/groups/?',
            '/groups/?/users/?'
        );
        $plugin_url['DrawIO'] = array(
            '/card_diagrams/?'
        );
        $plugin_url['Wiki'] = array(
            '/pages/?'
        );
        $plugin_url['CRM'] = array(
            '/contacts/?'
        );
        $plugin_url['Salesforce'] = array(
            '/salesforce/?'
        );
        $plugin_url['SupportApp'] = array(
            '/card_support_users'
        );
        foreach ($plugin_url as $plugin_key => $plugin_values) {
            if (in_array($r_resource_cmd, $plugin_values)) {
                $pluginToBePassed = $plugin_key;
                break;
            }
        }
        if (!empty($pluginToBePassed)) {
            require_once PLUGIN_PATH . DS . $pluginToBePassed . DS . 'R' . DS . 'r.php';
            $passed_values = array();
            $passed_values['sql'] = $sql;
            $passed_values['r_resource_cmd'] = $r_resource_cmd;
            $passed_values['r_resource_vars'] = $r_resource_vars;
            $passed_values['r_resource_filters'] = $r_resource_filters;
            $passed_values['authUser'] = $authUser;
            if (!empty($table_name)) {
                $passed_values['table_name'] = $table_name;
            }
            if (!empty($siteCurrencyCode)) {
                $passed_values['siteCurrencyCode'] = $siteCurrencyCode;
            }
            if (!empty($enabledPlugins)) {
                $passed_values['enabledPlugins'] = $enabledPlugins;
            }
            $plugin_return = call_user_func($plugin_key . '_r_delete', $passed_values);
            echo json_encode($plugin_return);
            exit;
            break;
        }
        header($_SERVER['SERVER_PROTOCOL'] . ' 501 Not Implemented', true, 501);
        break;
    }
    if (!empty($sql)) {
        $result = pg_query_params($db_lnk, $sql, $pg_params);
        if ($result && !empty($d_sql)) {
            pg_query_params($db_lnk, $d_sql, $pg_params);
        }
        $response['error'] = array(
            'code' => (!$result) ? 1 : 0
        );
    }
    echo json_encode($response);
}
global $exception_url, $scope_exception_url, $token_exception_url;
$exception_url = array(
    '/users/forgotpassword',
    '/users/register',
    '/users/login',
    '/users/?/activation',
    '/settings',
    '/boards/?',
    '/oauth/token',
    '/users/logout'
);
$scope_exception_url = array(
    '/users/login',
    '/users/register',
    '/oauth/token',
    '/users/?/activation',
    '/users/forgotpassword'
);
$token_exception_url = array(
    '/users/logout',
    '/oauth',
    '/oauth/token',
    '/settings'
);
main();
