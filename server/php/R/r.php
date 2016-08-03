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
 * @copyright  2014-2016 Restya
 * @license    http://restya.com/ Restya Licence
 * @link       http://restya.com/
 * @todo       Fix code duplication & make it really lightweight
 * @since      2013-08-23
 */
$r_debug = '';
$authUser = $client = $form = array();
$_server_protocol = (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] != 'off') ? 'https' : 'http';
$_server_domain_url = $_server_protocol . '://' . $_SERVER['HTTP_HOST']; // http://localhost
header('Access-Control-Allow-Origin: ' . $_server_domain_url);
header('Access-Control-Allow-Methods: *');
require_once '../config.inc.php';
require_once '../libs/vendors/finediff.php';
require_once '../libs/core.php';
require_once '../libs/vendors/OAuth2/Autoloader.php';
require_once '../libs/vendors/xmpp/vendor/autoload.php';
use Xmpp\Xep\Xep0045 as xmpp;
use Psr\Log\LoggerInterface;
require '../libs/vendors/jaxl3/jaxl.php';
$j_username = $j_password = '';
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
    global $r_debug, $db_lnk, $authUser, $_server_domain_url;
    // switch case.. if taking more length, then associative array...
    $sql = false;
    $response = $revisions = $pg_params = array();
    switch ($r_resource_cmd) {
    case '/xmpp_login':
        include '../libs/vendors/xmpp-prebind-php/XmppPrebind.php';
        $conditions = array(
            $authUser['username']
        );
        $chat_db_lnk = getEjabberdConnection();
        $user_password = pg_query_params($chat_db_lnk, 'SELECT password FROM users WHERE username = $1', $conditions);
        $user_password = pg_fetch_assoc($user_password);
        $xmppPrebind = new XmppPrebind(JABBER_HOST, BOSH_SERVICE_URL, XMPP_CLIENT_RESOURCE_NAME, false, true);
        $xmppPrebind->connect($authUser['username'], $user_password['password']);
        $xmppPrebind->auth();
        $response = $xmppPrebind->getSessionInfo();
        break;

    case '/boards/?/chat_history':
        $condition = 'WHERE al.board_id = $1 AND al.type = $2';
        $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM activities_listing al ' . $condition . ' ORDER BY created DESC) as d ';
        $c_sql = 'SELECT COUNT(*) FROM activities_listing al ' . $condition;
        array_push($pg_params, $r_resource_vars['boards'], 'chat');
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
        break;

    case '/users':
        $response['users'] = array();
        $order_by = 'id';
        $direction = 'desc';
        $filter_condition = '';
        if (!empty($r_resource_filters['sort'])) {
            $order_by = $r_resource_filters['sort'];
            $direction = $r_resource_filters['direction'];
        } else if (!empty($r_resource_filters['filter'])) {
            $filter_condition = 'WHERE ';
            if ($r_resource_filters['filter'] == 'active') {
                $filter_condition.= 'is_active = 1';
            } else if ($r_resource_filters['filter'] == 'inactive') {
                $filter_condition.= 'is_active = 0';
            } else if ($r_resource_filters['filter'] == 'ldap') {
                $filter_condition.= 'is_ldap = 1';
            } else {
                $filter_condition.= 'role_id = ' . $r_resource_filters['filter'];
            }
        } else if (!empty($r_resource_filters['search'])) {
            $filter_condition = "WHERE LOWER(full_name) LIKE '%" . strtolower($r_resource_filters['search']) . "%' OR LOWER(email) LIKE '%" . strtolower($r_resource_filters['search']) . "%' ";
        }
        $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM users_listing ul ' . $filter_condition . ' ORDER BY ' . $order_by . ' ' . $direction . ') as d ';
        $c_sql = 'SELECT COUNT(*) FROM users_listing ul ';
        if (!empty($r_resource_filters['search'])) {
            $c_sql = 'SELECT COUNT(*) FROM users_listing ul ' . $filter_condition;
        }
        break;

    case '/users/logout':
        $response['user'] = array();
        $conditions = array(
            $_GET['token']
        );
        pg_query_params($db_lnk, 'DELETE FROM oauth_access_tokens WHERE access_token= $1', $conditions);
        $authUser = array();
        break;

    case '/users/?/activities':
        $condition = $condition1 = '';
        if (isset($r_resource_filters['last_activity_id']) && $r_resource_filters['last_activity_id'] > 0) {
            $condition = ' AND al.id > $2';
            $condition1 = ' AND al.id > $3';
            if (!empty($r_resource_filters['type']) && $r_resource_filters['type'] == 'profile') {
                $condition = ' AND al.id < $2';
                $condition1 = ' AND al.id < $3';
            }
        }
        if (!empty($authUser) && $authUser['id'] != $r_resource_vars['users']) {
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
        if (!empty($authUser) && $authUser['role_id'] == 1 && $authUser['id'] == $r_resource_vars['users'] && empty($r_resource_filters['board_id'])) {
            if (!empty($r_resource_filters['type']) && $r_resource_filters['type'] == 'profile') {
                $condition = (!empty($r_resource_filters['last_activity_id'])) ? ' WHERE al.id < $1' : "";
            } else {
                $condition = (!empty($r_resource_filters['last_activity_id'])) ? ' WHERE al.id > $1' : "";
            }
            $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM activities_listing al ' . $condition . ' ORDER BY id DESC LIMIT ' . PAGING_COUNT . ') as d';
            $c_sql = 'SELECT COUNT(*) FROM activities_listing al' . $condition;
        } else {
            if (!empty($r_resource_filters['type']) && $r_resource_filters['type'] == 'profile') {
                $str = '';
                $i = 1;
                if (!empty($logged_user_board_ids)) {
                    $str.= 'board_id = ANY ( $' . $i . ' ) AND';
                    $i++;
                    array_push($pg_params, '{' . implode(',', $board_ids) . '}');
                }
                $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM activities_listing al WHERE ' . $str . ' user_id = $' . $i . $condition . ' ORDER BY id DESC LIMIT ' . PAGING_COUNT . ') as d';
                $c_sql = 'SELECT COUNT(*) FROM activities_listing al WHERE ' . $str . ' user_id = $' . $i . $condition;
                array_push($pg_params, $r_resource_vars['users']);
            } else if (!empty($r_resource_filters['organization_id'])) {
                if (isset($r_resource_filters['last_activity_id']) && $r_resource_filters['last_activity_id'] > 0) {
                    $condition1 = ' AND al.id > $4';
                }
                $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM activities_listing al WHERE ((user_id = $1 AND board_id IN (SELECT id FROM boards WHERE organization_id = $2)) OR organization_id  = ANY ( $3 )) ' . $condition1 . ' ORDER BY id DESC LIMIT ' . PAGING_COUNT . ') as d';
                $c_sql = 'SELECT COUNT(*) FROM activities_listing al WHERE ((user_id = $1 AND board_id IN (SELECT id FROM boards WHERE organization_id = $2)) OR organization_id  = ANY ( $3 )) ' . $condition1;
                array_push($pg_params, $r_resource_vars['users'], $r_resource_filters['organization_id'], '{' . $r_resource_filters['organization_id'] . '}');
            } else if (!empty($r_resource_filters['type']) && $r_resource_filters['type'] = 'all') {
                $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM activities_listing al WHERE (board_id = ANY ( $1 ) OR organization_id  = ANY ( $2 ))' . $condition1 . ' ORDER BY id DESC LIMIT ' . PAGING_COUNT . ') as d';
                $c_sql = 'SELECT COUNT(*) FROM activities_listing al WHERE (board_id = ANY ( $1 ) OR organization_id  = ANY ( $2 ))' . $condition1;
                array_push($pg_params, '{' . implode(',', $board_ids) . '}', '{' . implode(',', $org_ids) . '}');
            } else if (!empty($r_resource_filters['board_id']) && $r_resource_filters['board_id']) {
                $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM activities_listing al WHERE user_id = $1 AND board_id = $2' . $condition1 . ' ORDER BY freshness_ts DESC, materialized_path ASC LIMIT ' . PAGING_COUNT . ') as d';
                $c_sql = 'SELECT COUNT(*) FROM activities_listing al WHERE user_id = $1 AND board_id = $2' . $condition1;
                array_push($pg_params, $r_resource_vars['users'], $r_resource_filters['board_id']);
            } else {
                $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM activities_listing al WHERE ( board_id = ANY( $1 ) OR organization_id  = ANY ( $2 ) )' . $condition1 . ' ORDER BY id DESC LIMIT ' . PAGING_COUNT . ') as d';
                $c_sql = 'SELECT COUNT(*) FROM activities_listing al WHERE ( board_id = ANY( $1 ) OR organization_id  = ANY ( $2 ) )' . $condition1;
                array_push($pg_params, '{' . implode(',', $board_ids) . '}', '{' . implode(',', $org_ids) . '}');
            }
        }
        if (!empty($condition) || !empty($condition1)) {
            array_push($pg_params, $r_resource_filters['last_activity_id']);
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
        break;

    case '/users/?':
        $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM users ul WHERE id = $1) as d ';
        array_push($pg_params, $r_resource_vars['users']);
        break;

    case '/users/?/boards':
        if (!empty($authUser)) {
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
        $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM users_cards_listing ucl WHERE ' . $str . ' user_id = $' . $i . ' ORDER BY board_id ASC) as d ';
        array_push($pg_params, $r_resource_vars['users']);
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
            $sql.= ' ORDER BY name ASC) as d ';
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
            $sql.= ' ORDER BY name ASC) as d ';
            if ($authUser['role_id'] != 1 && empty($board_ids)) {
                $sql = false;
            }
        }
        $c_sql = 'SELECT COUNT(*) FROM boards_listing bl';
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
                $ids = 0;
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
            } else if (!empty($r_resource_filters['filter'])) {
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
                $filter_condition = "WHERE name LIKE '%" . $r_resource_filters['search'] . "%' ";
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
                $ids = 0;
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
                $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM boards_listing ul WHERE id = $1 ORDER BY id DESC) as d ';
                array_push($pg_params, $r_resource_vars['boards']);
            } else {
                $response['error']['type'] = 'visibility';
                $response['error']['message'] = 'Unauthorized';
                header($_SERVER['SERVER_PROTOCOL'] . ' 401 Unauthorized', true, 401);
            }
        } else {
            $response['error']['type'] = 'board';
            $response['error']['message'] = 'Bad Request';
            header($_SERVER['SERVER_PROTOCOL'] . ' 400 Bad Request', true, 400);
        }
        break;

    case '/organizations':
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
            $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM organizations_listing ul WHERE id = $1 ORDER BY id DESC) as d ';
            array_push($pg_params, $r_resource_vars['organizations']);
        } else {
            $response['error']['type'] = 'visibility';
            $response['error']['message'] = 'Unauthorized';
        }
        break;

    case '/boards/?/lists/?/cards/?/activities':
    case '/boards/?/lists/?/activities':
    case '/boards/?/activities':
        $val_array = array(
            $r_resource_vars['boards']
        );
        $board = executeQuery('SELECT board_visibility FROM boards_listing WHERE id = $1', $val_array);
        $val_array = array(
            $r_resource_vars['boards'],
            $authUser['id']
        );
        $boards_user = executeQuery('SELECT * FROM boards_users WHERE board_id = $1 AND user_id = $2', $val_array);
        if ((!empty($authUser) && $authUser['role_id'] == 1) || $board['board_visibility'] == 2 || !empty($boards_user)) {
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
            $limit = PAGING_COUNT;
            if (!empty($r_resource_filters['limit'])) {
                $limit = $r_resource_filters['limit'];
            }
            $sql = 'SELECT row_to_json(d) FROM (SELECT al.*, u.username, u.profile_picture_path, u.initials, u.full_name, c.description, c.name as card_name FROM activities_listing al LEFT JOIN users u ON al.user_id = u.id LEFT JOIN cards c on al.card_id = c.id WHERE al.board_id = $1' . $condition . ' ORDER BY al.id DESC LIMIT ' . $limit . ') as d ';
            if (empty($r_resource_filters['from']) || (!empty($r_resource_filters['from']) && $r_resource_filters['from'] != 'app')) {
                $c_sql = 'SELECT COUNT(*) FROM activities_listing al WHERE al.board_id = $1' . $condition;
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
        break;

    case '/boards/?/board_subscribers':
        $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM board_subscribers ul WHERE board_id = $1';
        array_push($pg_params, $r_resource_vars['boards']);
        if (!empty($authUser) && $authUser['role_id'] != 1) {
            $sql.= ' and user_id = $2';
            array_push($pg_params, $authUser['id']);
        }
        $sql.= ' ORDER BY id DESC) as d ';
        break;

    case '/boards/search':
        $sql = 'SELECT row_to_json(d) FROM (SELECT id, name, background_color FROM boards ul WHERE name ILIKE $1 ORDER BY id DESC) as d ';
        array_push($pg_params, '%' . $r_resource_filters['q'] . '%');
        break;

    case '/boards/?/lists/?/cards/?':
        $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM cards_listing cll WHERE id = $1) as d ';
        array_push($pg_params, $r_resource_vars['cards']);
        break;

    case '/boards/?/lists':
        $fields = !empty($r_resource_filters['fields']) ? $r_resource_filters['fields'] : '*';
        $sql = 'SELECT row_to_json(d) FROM (SELECT ' . $fields . ' FROM lists_listing cll WHERE board_id = $1) as d ';
        array_push($pg_params, $r_resource_vars['boards']);
        if (empty($r_resource_filters['from']) || (!empty($r_resource_filters['from']) && $r_resource_filters['from'] != 'app')) {
            $c_sql = 'SELECT COUNT(*) FROM lists_listing cll';
        }
        break;

    case '/boards/?/lists/?/cards':
        $fields = !empty($r_resource_filters['fields']) ? $r_resource_filters['fields'] : '*';
        $sql = 'SELECT row_to_json(d) FROM (SELECT ' . $fields . ' FROM cards_listing cll WHERE board_id = $1 AND list_id = $2) as d ';
        array_push($pg_params, $r_resource_vars['boards']);
        array_push($pg_params, $r_resource_vars['lists']);
        if (empty($r_resource_filters['from']) || (!empty($r_resource_filters['from']) && $r_resource_filters['from'] != 'app')) {
            $c_sql = 'SELECT COUNT(*) FROM cards_listing cll';
        }
        break;

    case '/activities':
        $condition = '';
        $i = 1;
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
        break;

    case '/boards/?/lists/?/cards/?/checklists':
        $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM checklist_add_listing al WHERE board_id = $1) as d ';
        array_push($pg_params, $r_resource_vars['boards']);
        break;

    case '/boards/?/visibility':
        $sql = 'SELECT board_visibility FROM boards bl WHERE bl.id = $1';
        array_push($pg_params, $r_resource_vars['boards']);
        break;

    case '/workflow_templates':
        $files = glob(APP_PATH . '/client/js/workflow_templates/*.json', GLOB_BRACE);
        foreach ($files as $file) {
            $data = file_get_contents($file);
            $json = json_decode($data, true);
            $response[] = array(
                'name' => $json['name'],
                'value' => implode($json['lists'], ', ')
            );
        }
        break;

    case '/search':
        if (!empty($r_resource_filters['q'])) {
            $response = array();
            $data_for = '';
            if (!empty($r_resource_filters['q'])) {
                $str = $r_resource_filters['q'];
                $data_for_except = array(
                    'boards',
                    'lists',
                    'cards_labels',
                    'cards_comments',
                    'cards_checklists',
                    'cards'
                );
                $data_for_exp = explode(':', $str, 2);
                if (in_array($data_for_exp[0], $data_for_except)) {
                    $str = $data_for_exp[1];
                }
                $is_quote_start = '';
                $colon_arr = $string_arr = array();
                $space_split_arr = explode(' ', $str);
                $except = array(
                    'due',
                    'has',
                    'is',
                    'created',
                    'edited'
                );
                $page = 1;
                $size = 10;
                $from = '';
                if (!empty($r_resource_filters['page'])) {
                    $page = $r_resource_filters['page'];
                    $from = '&from=';
                    $from.= ($page > 1) ? (($page - 1) * 20) - 10 : ($page) * 10;
                    $size = 20;
                }
                if (!empty($space_split_arr)) {
                    foreach ($space_split_arr as $space_split) {
                        if (!empty($is_quote_start)) {
                            $colon_arr[$is_quote_start].= ' ' . $space_split;
                            if (strpos($space_split, '"')) {
                                $is_quote_start = '';
                            }
                        } elseif (strpos($space_split, ':')) {
                            $colon_split = explode(':', $space_split);
                            if (in_array($colon_split[0], $except)) {
                                $colon_arr[$colon_split[0] . ':' . $colon_split[1]] = $colon_split[1];
                            } else {
                                $colon_arr[$colon_split[0]] = $colon_split[1];
                            }
                            if (strpos($colon_split[1], '"') === 0) {
                                $is_quote_start = $colon_split[0];
                            }
                        } else {
                            $string_arr[] = $space_split;
                        }
                    }
                }
                $split_str = implode(' ', $string_arr);
                if (!empty($split_str)) {
                    $split_str = '*' . $split_str . '*';
                }
                $data = array();
                if (!empty($split_str)) {
                    $list = 'list:' . $split_str;
                    $board = 'board:' . $split_str;
                    $cards_labels = 'cards_labels.name:' . $split_str;
                    $cards_comments = 'activities.comment:' . $split_str;
                    $cards_checklists = 'cards_checklists.checklist_item_name:' . $split_str;
                }
                if (!empty($r_resource_filters['data_for'])) {
                    $data_for = $r_resource_filters['data_for'];
                }
                $final = '';
                $admin = '';
                if ($authUser['role_id'] != 1) {
                    $admin = ' AND board_users.user_id:' . $authUser['id'];
                }
                foreach ($colon_arr as $key => $value) {
                    if ($key === "board") {
                        $board = $key . ':' . '*' . $value . '*';
                        $final.= $board . ' AND ';
                    } elseif ($key === "list") {
                        $list = $key . ':' . '*' . $value . '*';
                        $final.= $list . ' AND ';
                    } elseif ($key === "label") {
                        $final.= 'cards_labels.name:' . '*' . $value . '*' . ' AND ';
                    } elseif ($key === "has:attachments") {
                        $final.= 'attachment_count:>0 AND ';
                    } elseif ($key === "has:members") {
                        $final.= 'cards_user_count:>0 AND ';
                    } elseif ($key === "has:description") {
                        $final.= '_exists_:description AND ';
                    } elseif ($key === "is:archived") {
                        $final.= 'is_archived:>0 AND ';
                    } elseif ($key === "is:open") {
                        $final.= 'is_archived:0 AND ';
                    } elseif ($key === "is:starred") {
                        $final.= 'board_stars.user_id:' . $authUser['id'] . ' AND ';
                    } elseif ($key === "description") {
                        $final.= 'description.name:' . $value . ' AND ';
                    } elseif ($key === "checklist") {
                        $final.= 'cards_checklists.name:' . '*' . $value . '*' . ' AND ';
                    } elseif ($key === "comment") {
                        $final.= 'activities.comment:' . '*' . $value . '*' . ' AND ';
                    } elseif ($key === "name") {
                        $final.= $key . ':' . $value . ' AND ';
                    } elseif ($key === "due:day") {
                        $final.= 'due_date:[now TO now+1d] AND ';
                    } elseif ($key === "due:week") {
                        $final.= 'due_date:[now TO now+1w] AND ';
                        $data['sort']['due_date']['order'] = 'desc';
                    } elseif ($key === "due:month") {
                        $final.= 'due_date:[now TO now+1M] AND ';
                        $data['sort']['due_date']['order'] = 'desc';
                    } elseif ($key === "due:overdue") {
                        $final.= 'due_date:[* TO now] AND ';
                        $data['sort']['due_date']['order'] = 'desc';
                    } elseif ($key === "due:today_todo" || $key === "due:today_doing" || $key === "due:today_done") {
                        $due = explode(':', $key);
                        $today = explode('_', $due[1]);
                        $settings = getWorkFlow(strtoupper($today[1]));
                        $user_con = ($authUser['role_id'] == 1) ? '' : 'cards_users.user_id:' . $authUser['id'] . ' AND ';
                        $final.= 'due_date:[' . date('Y-m-d') . ' TO ' . date('Y-m-d') . '] AND ' . $user_con . $settings;
                    } elseif ($key === "due:week_todo" || $key === "due:week_doing" || $key === "due:week_done") {
                        $due = explode(':', $key);
                        $today = explode('_', $due[1]);
                        $settings = getWorkFlow(strtoupper($today[1]));
                        $day = date('w') - 1;
                        $week_start = date('Y-m-d', strtotime('-' . $day . ' days'));
                        $week_end = date('Y-m-d', strtotime('+' . (6 - $day) . ' days'));
                        $user_con = ($authUser['role_id'] == 1) ? '' : 'cards_users.user_id:' . $authUser['id'] . ' AND ';
                        $final.= 'due_date:[' . $week_start . ' TO ' . $week_end . '] AND ' . $user_con . $settings;
                        $data['sort']['due_date']['order'] = 'desc';
                    } elseif ($key === "due:overall_todo" || $key === "due:overall_doing" || $key === "due:overall_done") {
                        $due = explode(':', $key);
                        $today = explode('_', $due[1]);
                        $settings = getWorkFlow(strtoupper($today[1]));
                        $user_con = ($authUser['role_id'] == 1) ? '' : 'cards_users.user_id:' . $authUser['id'] . ' AND ';
                        $final.= $user_con . $settings;
                        $data['sort']['due_date']['order'] = 'desc';
                    } elseif ($key === "due:unassigned") {
                        $settings_todo = getWorkFlow('TODO');
                        $settings_doing = getWorkFlow('DOING');
                        $settings_done = getWorkFlow('DONE');
                        $_str = $settings_todo . $settings_doing . $settings_done;
                        $_str = substr($_str, 0, strlen($_str) - 4);
                        $final.= 'cards_user_count:0 AND (' . $_str . ') AND ';
                    } elseif ($key === "created:day") {
                        $final.= 'created:[now-1d TO now] AND ';
                    } elseif ($key === "created:week") {
                        $data['sort']['created']['order'] = 'desc';
                        $final.= 'created:[now-1w TO now] AND ';
                    } elseif ($key === "created:month") {
                        $data['sort']['created']['order'] = 'desc';
                        $final.= 'created:[now-1M TO now] AND ';
                    } elseif ($key === "edited:day") {
                        $final.= 'modified:[now-1d TO now] AND ';
                    } elseif ($key === "edited:week") {
                        $data['sort']['modified']['order'] = 'desc';
                        $final.= 'modified:[now-1w TO now] AND ';
                    } elseif ($key === "edited:month") {
                        $data['sort']['modified']['order'] = 'desc';
                        $final.= 'modified:[now-1M TO now] AND ';
                    } elseif ($key === "user") {
                        if ($value === "me") {
                            $final.= 'board_users.user_id:' . $authUser['id'] . ' AND ';
                        } else {
                            $conditions = array(
                                $value
                            );
                            $user_result = pg_query_params($db_lnk, 'SELECT id FROM users WHERE username = $1', $conditions);
                            $user = pg_fetch_assoc($user_result);
                            $final.= 'board_users.user_id:' . $user['id'] . ' AND ';
                        }
                    } else {
                        $due_cre_edi = explode(':', $key);
                        if ($due_cre_edi[0] === 'due') {
                            $final.= 'due_date:[now TO now+' . $value . 'd] AND ';
                        } elseif ($due_cre_edi[0] === 'created') {
                            $final.= 'created:[now-' . $value . 'd TO now] AND ';
                        } elseif ($due_cre_edi[0] === 'edited') {
                            $final.= 'modified:[now-' . $value . 'd TO now] AND ';
                        }
                    }
                }
                $elasticsearch_url = ELASTICSEARCH_URL . ELASTICSEARCH_INDEX . '/cards/_search?size=' . $size . $from;
                $response['result'] = array();
                if (!empty($board) && ((!empty($data_for) && $data_for === 'boards') || empty($data_for))) {
                    $data['query']['query_string']['query'] = $board . $admin;
                    $data['highlight']['fields']['board'] = new stdClass;
                    $data['aggs']['board']['terms']['field'] = 'board_id';
                    $data['aggs']['board']['terms']['size'] = 0;
                    $search_response = doPost($elasticsearch_url, $data, 'json');
                    $board_count = count($search_response['aggregations']['board']['buckets']);
                    $board_ids = array();
                    foreach ($search_response['aggregations']['board']['buckets'] as $board) {
                        $board_ids[] = $board['key'];
                    }
                    $conditions = array(
                        '{' . implode($board_ids, ',') . '}'
                    );
                    $boards_result = pg_query_params($db_lnk, 'SELECT id,name FROM boards WHERE id = ANY($1)', $conditions);
                    $result = array();
                    while ($board = pg_fetch_assoc($boards_result)) {
                        $result['_source']['board_id'] = $board['id'];
                        $result['_source']['board'] = $board['name'];
                        $response['result']['boards'][] = bind_elastic($result, 'boards');
                    }
                    if (!empty($response['result']['boards'])) {
                        $response['result']['metadata']['boards']['count'] = $board_count;
                        $response['result']['metadata']['boards']['page'] = $page;
                    }
                }
                if (!empty($list) && ((!empty($data_for) && $data_for === 'lists') || empty($data_for))) {
                    $data['query']['query_string']['query'] = $list . $admin;
                    $data['highlight']['fields']['list'] = new stdClass;
                    $data['aggs']['list']['terms']['field'] = 'list_id';
                    $data['aggs']['list']['terms']['size'] = 0;
                    $search_response = doPost($elasticsearch_url, $data, 'json');
                    $list_count = count($search_response['aggregations']['list']['buckets']);
                    $list_ids = array();
                    foreach ($search_response['aggregations']['list']['buckets'] as $list) {
                        $list_ids[] = $list['key'];
                    }
                    $conditions = array(
                        '{' . implode($list_ids, ',') . '}'
                    );
                    $list_result = pg_query_params($db_lnk, 'SELECT id,name,board_id,(select name from boards where id = l.board_id) as board FROM lists l WHERE id = ANY($1)', $conditions);
                    $result = array();
                    while ($list = pg_fetch_assoc($list_result)) {
                        $result['_source']['list_id'] = $list['id'];
                        $result['_source']['list'] = $list['name'];
                        $result['_source']['board_id'] = $list['board_id'];
                        $result['_source']['board'] = $list['board'];
                        $response['result']['lists'][] = bind_elastic($result, 'lists');
                    }
                    if (!empty($response['result']['lists'])) {
                        $response['result']['metadata']['lists']['count'] = $list_count;
                        $response['result']['metadata']['lists']['page'] = $page;
                    }
                }
                $data['highlight']['pre_tags'] = array(
                    "<span class=\"bg-search\">"
                );
                $data['highlight']['post_tags'] = array(
                    "</span>"
                );
                $str = '';
                if (!empty($split_str)) {
                    $str = '(name:' . $split_str . ' OR description:' . $split_str . ')';
                } else {
                    $final = substr($final, 0, strlen($final) - 4);
                }
                if ((!empty($data_for) && $data_for === 'cards') || empty($data_for)) {
                    $data['query']['query_string']['query'] = $final . $str . $admin;
                    $data['highlight']['fields']['name'] = new stdClass;
                    $data['highlight']['fields']['description'] = new stdClass;
                    $search_response = doPost($elasticsearch_url, $data, 'json');
                    if (!empty($search_response['hits']['hits'])) {
                        $response['result']['metadata']['cards']['count'] = $search_response['hits']['total'];
                        $response['result']['metadata']['cards']['page'] = $page;
                        foreach ($search_response['hits']['hits'] as $result) {
                            $response['result']['cards'][] = bind_elastic($result, 'cards');
                        }
                    }
                }
                if (!empty($cards_labels) && ((!empty($data_for) && $data_for === 'cards_labels') || empty($data_for))) {
                    $data['query']['query_string']['query'] = $cards_labels . $admin;
                    $data['highlight']['fields']['cards_labels.name'] = new stdClass;
                    $search_response = doPost($elasticsearch_url, $data, 'json');
                    if (!empty($search_response['hits']['hits'])) {
                        $response['result']['metadata']['cards_labels']['count'] = $search_response['hits']['total'];
                        $response['result']['metadata']['cards_labels']['page'] = $page;
                        foreach ($search_response['hits']['hits'] as $result) {
                            $response['result']['cards_labels'][] = bind_elastic($result, 'cards_labels');
                        }
                    }
                }
                if (!empty($cards_comments) && ((!empty($data_for) && $data_for === 'cards_comments') || empty($data_for))) {
                    $data['query']['query_string']['query'] = $cards_comments . $admin;
                    $data['highlight']['fields']['activities.comment'] = new stdClass;
                    $search_response = doPost($elasticsearch_url, $data, 'json');
                    if (!empty($search_response['hits']['hits'])) {
                        $response['result']['metadata']['comments']['count'] = $search_response['hits']['total'];
                        $response['result']['metadata']['comments']['page'] = $page;
                        foreach ($search_response['hits']['hits'] as $result) {
                            $response['result']['comments'][] = bind_elastic($result, 'comments');
                        }
                    }
                }
                if (!empty($cards_checklists) && ((!empty($data_for) && $data_for === 'cards_checklists') || empty($data_for))) {
                    $data['query']['query_string']['query'] = $cards_checklists . $admin;
                    $data['highlight']['fields']['cards_checklists.checklist_item_name'] = new stdClass;
                    $search_response = doPost($elasticsearch_url, $data, 'json');
                    if (!empty($search_response['hits']['hits'])) {
                        $response['result']['metadata']['checklists']['count'] = $search_response['hits']['total'];
                        $response['result']['metadata']['checklists']['page'] = $page;
                        foreach ($search_response['hits']['hits'] as $result) {
                            $response['result']['checklists'][] = bind_elastic($result, 'checklists');
                        }
                    }
                }
            }
        }
        break;

    case '/boards/?/lists/?/cards/?/search':
        $sql = 'SELECT row_to_json(d) FROM (SELECT bul.id, bul.user_id, bul.username, bul.profile_picture_path, bul.full_name, bul.initials  FROM boards_users_listing bul WHERE';
        $sql.= '(bul.username LIKE $1 OR bul.email LIKE $2) AND bul.board_id = $3) as d ';
        array_push($pg_params, '%' . $r_resource_filters['q'] . '%', '%' . $r_resource_filters['q'] . '%', $r_resource_vars['boards']);
        if (empty($r_resource_filters['q'])) {
            $sql = false;
            $response = array();
            $pg_params = array();
        }
        break;

    case '/boards/?/cards/search':
        $user_id = (!empty($authUser['id'])) ? $authUser['id'] : 0;
        $sql = 'SELECT row_to_json(d) FROM (SELECT DISTINCT c.id, c.name, bu.board_id FROM boards_users bu join cards c on c.board_id = bu.board_id WHERE bu.board_id IN (SELECT board_id FROM boards_users WHERE user_id = $1) AND c.name  LIKE $2 ORDER BY id ASC) as d';
        array_push($pg_params, $user_id, '%' . $r_resource_filters['q'] . '%');
        if (empty($r_resource_filters['q'])) {
            $sql = false;
            $response = array();
            $pg_params = array();
        }
        break;

    case '/acl_links':
        $sql = false;
        $acl_links_sql = 'SELECT row_to_json(d) FROM (SELECT acl_links.id,  acl_links.name, acl_links.group_id, ( SELECT array_to_json(array_agg(row_to_json(alr.*))) AS array_to_json FROM ( SELECT acl_links_roles.role_id FROM acl_links_roles acl_links_roles WHERE acl_links_roles.acl_link_id = acl_links.id ORDER BY acl_links_roles.role_id) alr) AS acl_links_roles, acl_links.is_guest_action, acl_links.is_user_action, acl_links.is_admin_action, acl_links.is_hide FROM acl_links acl_links ORDER BY group_id ASC, id ASC) as d';
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
        break;

    case '/settings':
        $s_sql = pg_query_params($db_lnk, 'SELECT name, value FROM settings WHERE name = \'SITE_NAME\' OR name = \'SITE_TIMEZONE\' OR name = \'DROPBOX_APPKEY\' OR name = \'LABEL_ICON\' OR name = \'FLICKR_API_KEY\' or name = \'LDAP_LOGIN_ENABLED\' OR name = \'DEFAULT_LANGUAGE\' OR name = \'IMAP_EMAIL\' OR name = \'STANDARD_LOGIN_ENABLED\' OR name = \'BOSH_SERVICE_URL\' OR name = \'PREBIND_URL\' OR name = \'JABBER_HOST\' OR name = \'PAGING_COUNT\' OR name = \'DEFAULT_CARD_VIEW\' OR name = \'TODO\' OR name = \'DOING\' OR name = \'DONE\' OR name = \'TODO_COLOR\' OR name = \'DOING_COLOR\' OR name = \'DONE_COLOR\' OR name = \'TODO_ICON\' OR name = \'DOING_ICON\' OR name = \'DONE_ICON\'', array());
        while ($row = pg_fetch_assoc($s_sql)) {
            $response[$row['name']] = $row['value'];
        }
        $files = glob(APP_PATH . '/client/apps/*/app.json', GLOB_BRACE);
        if (!empty($files)) {
            foreach ($files as $file) {
                $content = file_get_contents($file);
                $data = json_decode($content, true);
                if ($data['enabled'] === true) {
                    if (!empty($data['settings'])) {
                        foreach ($data['settings'] as $key => $value) {
                            if ($value['is_public']) {
                                $value['name'] = $key;
                                $response['apps']['settings'][] = $value;
                            }
                        }
                    }
                    foreach ($data['assets']['js'] as $jsfiles) {
                        $response['apps']['js'][] = $jsfiles;
                    }
                    foreach ($data['assets']['css'] as $cssfiles) {
                        $response['apps']['css'][] = $cssfiles;
                    }
                }
            }
        }
        break;

    case '/apps':
        $files = glob(APP_PATH . '/client/apps/*/app.json', GLOB_BRACE);
        if (!empty($files)) {
            foreach ($files as $file) {
                $folder = explode('/', $file);
                $content = file_get_contents($file);
                $data = json_decode($content, true);
                $data['folder'] = $folder[count($folder) - 2];
                $response[] = $data;
            }
        }
        break;

    case '/apps/settings':
        $content = file_get_contents(APP_PATH . '/client/apps/' . $r_resource_filters['app'] . '/app.json');
        $data = json_decode($content, true);
        if (file_exists(APP_PATH . '/tmp/cache/site_url_for_shell.php')) {
            include_once APP_PATH . '/tmp/cache/site_url_for_shell.php';
        }
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
        break;

    case '/oauth/applications':
        $response['applications'] = array();
        $sql = 'SELECT row_to_json(d) FROM (SELECT DISTINCT ON (ort.client_id) ort.client_id, oc.client_name FROM oauth_refresh_tokens ort LEFT JOIN oauth_clients oc ON ort.client_id = oc.client_id WHERE ort.user_id = $1 AND ort.client_id != $2) as d ';
        array_push($pg_params, $authUser['username'], '7742632501382313');
        $c_sql = 'SELECT COUNT(*) FROM (SELECT DISTINCT ON (ort.client_id) ort.client_id, oc.client_name FROM oauth_refresh_tokens ort LEFT JOIN oauth_clients oc ON ort.client_id = oc.client_id WHERE ort.user_id = $1 AND ort.client_id != $2) As oc';
        break;

    case '/webhooks':
        $response['webhooks'] = array();
        $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM webhooks w ORDER BY id ASC) as d ';
        $c_sql = 'SELECT COUNT(*) FROM webhooks w';
        break;

    default:
        header($_SERVER['SERVER_PROTOCOL'] . ' 501 Not Implemented', true, 501);
    }
    if (!empty($sql)) {
        $_metadata = array();
        if (!empty($c_sql)) {
            $c_result = pg_query_params($db_lnk, $c_sql, $pg_params);
            $c_data = pg_fetch_object($c_result, 0);
            $page = (isset($r_resource_filters['page']) && $r_resource_filters['page']) ? $r_resource_filters['page'] : 1;
            $page_count = PAGING_COUNT;
            if (!empty($limit) && $limit == 'all') {
                $page_count = $c_data->count;
            }
            $start = ($page - 1) * $page_count;
            $total_page = ceil($c_data->count / $page_count);
            $showing = (($start + $page_count) > $c_data->count) ? ($c_data->count - $start) : $page_count;
            $_metadata = array(
                'noOfPages' => $total_page,
                'total_records' => $c_data->count,
                'limit' => $page_count,
                'offset' => $start,
                'showing' => $showing,
                'maxSize' => 5
            );
            $sql.= ' LIMIT ' . $page_count . ' OFFSET ' . $start;
        }
        if ($r_resource_cmd == '/users') {
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
            $ldap_count = executeQuery('SELECT count(*) FROM users WHERE is_ldap = $1', $val_array);
            $filter_count['ldap'] = $ldap_count['count'];
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
        }
        if ($r_resource_cmd == '/boards') {
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
        }
        $arrayResponse = array(
            '/users/?/cards',
            '/users/?/activities',
            '/users/search',
            '/boards',
            '/boards/?/lists',
            '/boards/?/lists/?/cards',
            '/boards/?/activities',
            '/boards/?/lists/?/activities',
            '/boards/?/lists/?/cards/?/activities',
            '/boards/?/lists/?/cards/?/search',
            '/cards/search',
            '/organizations',
            '/activities',
            '/oauth/clients',
            '/oauth/applications',
            '/webhooks',
            '/boards/?/chat_history'
        );
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
                    if ($r_resource_cmd == '/boards/?') {
                        global $_server_domain_url;
                        $md5_hash = md5(SECURITYSALT . $r_resource_vars['boards']);
                        $obj['google_syn_url'] = $_server_domain_url . '/ical/' . $r_resource_vars['boards'] . '/' . $md5_hash . '.ics';
                    }
                } else if ($r_resource_cmd == '/boards/?/lists/?/cards/?/activities' || $r_resource_cmd == '/users/?/activities' || $r_resource_cmd == '/users/?/notify_count' || $r_resource_cmd == '/boards/?/activities') {
                    if (!empty($obj['revisions']) && trim($obj['revisions']) !== '') {
                        $revisions = unserialize($obj['revisions']);
                        $obj['revisions'] = $revisions;
                        $diff = array();
                        if (!empty($revisions['new_value'])) {
                            foreach ($revisions['new_value'] as $key => $value) {
                                if ($key != 'is_archived' && $key != 'is_deleted' && $key != 'created' && $key != 'modified' && $key != 'is_offline' && $key != 'uuid' && $key != 'to_date' && $key != 'temp_id' && $obj['type'] != 'moved_card_checklist_item' && $obj['type'] != 'add_card_desc' && $obj['type'] != 'add_card_duedate' && $obj['type'] != 'delete_card_duedate' && $obj['type'] != 'add_background' && $obj['type'] != 'change_background' && $obj['type'] != 'change_visibility') {
                                    $old_val = (isset($revisions['old_value'][$key]) && $revisions['old_value'][$key] != null && $revisions['old_value'][$key] != 'null') ? $revisions['old_value'][$key] : '';
                                    $new_val = (isset($revisions['new_value'][$key]) && $revisions['new_value'][$key] != null && $revisions['new_value'][$key] != 'null') ? $revisions['new_value'][$key] : '';
                                    $diff[] = nl2br(getRevisiondifference($old_val, $new_val));
                                }
                                if ($obj['type'] == 'add_card_desc' || $obj['type'] == 'add_card_desc' || $obj['type'] == '	edit_card_duedate' || $obj['type'] == 'add_background' || $obj['type'] == 'change_background' || $obj['type'] == 'change_visibility') {
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
                    if ($obj['type'] === 'add_board_user') {
                        $obj_val_arr = array(
                            $obj['foreign_id']
                        );
                        $obj['board_user'] = executeQuery('SELECT * FROM boards_users_listing WHERE id = $1', $obj_val_arr);
                    } else if ($obj['type'] === 'add_list') {
                        $obj_val_arr = array(
                            $obj['list_id']
                        );
                        $obj['list'] = executeQuery('SELECT * FROM lists WHERE id = $1', $obj_val_arr);
                    } else if ($obj['type'] === 'change_list_position') {
                        $obj_val_arr = array(
                            $obj['list_id']
                        );
                        $obj['list'] = executeQuery('SELECT position, board_id FROM lists WHERE id = $1', $obj_val_arr);
                    } else if ($obj['type'] === 'add_card') {
                        $obj_val_arr = array(
                            $obj['card_id']
                        );
                        $obj['card'] = executeQuery('SELECT * FROM cards WHERE id = $1', $obj_val_arr);
                    } else if ($obj['type'] === 'copy_card') {
                        $obj_val_arr = array(
                            $obj['foreign_id']
                        );
                        $obj['card'] = executeQuery('SELECT * FROM cards WHERE id = $1', $obj_val_arr);
                    } else if ($obj['type'] === 'add_card_checklist') {
                        $obj_val_arr = array(
                            $obj['foreign_id']
                        );
                        $obj['checklist'] = executeQuery('SELECT * FROM checklists_listing WHERE id = $1', $obj_val_arr);
                        $obj['checklist']['checklists_items'] = json_decode($obj['checklist']['checklists_items'], true);
                    } else if ($obj['type'] === 'add_card_label') {
                        $obj_val_arr = array(
                            $obj['card_id']
                        );
                        $s_result = pg_query_params($db_lnk, 'SELECT * FROM cards_labels_listing WHERE  card_id = $1', $obj_val_arr);
                        while ($row = pg_fetch_assoc($s_result)) {
                            $obj['labels'][] = $row;
                        }
                    } else if ($obj['type'] === 'add_card_voter') {
                        $obj_val_arr = array(
                            $obj['foreign_id']
                        );
                        $obj['voter'] = executeQuery('SELECT * FROM card_voters_listing WHERE id = $1', $obj_val_arr);
                    } else if ($obj['type'] === 'add_card_user') {
                        $obj_val_arr = array(
                            $obj['foreign_id']
                        );
                        $obj['user'] = executeQuery('SELECT * FROM cards_users_listing WHERE id = $1', $obj_val_arr);
                    } else if ($obj['type'] === 'update_card_checklist') {
                        $obj_val_arr = array(
                            $obj['foreign_id']
                        );
                        $obj['checklist'] = executeQuery('SELECT * FROM checklists WHERE id = $1', $obj_val_arr);
                    } else if ($obj['type'] === 'add_checklist_item' || $obj['type'] === 'update_card_checklist_item' || $obj['type'] === 'moved_card_checklist_item') {
                        $obj_val_arr = array(
                            $obj['foreign_id']
                        );
                        $obj['item'] = executeQuery('SELECT * FROM checklist_items WHERE id = $1', $obj_val_arr);
                    } else if ($obj['type'] === 'add_card_attachment') {
                        $obj_val_arr = array(
                            $obj['foreign_id']
                        );
                        $obj['attachment'] = executeQuery('SELECT * FROM card_attachments WHERE id = $1', $obj_val_arr);
                    } else if ($obj['type'] === 'change_card_position') {
                        $obj_val_arr = array(
                            $obj['card_id']
                        );
                        $obj['card'] = executeQuery('SELECT position FROM cards WHERE id = $1', $obj_val_arr);
                    }
                } else if ($r_resource_cmd == '/boards/?') {
                    global $_server_domain_url;
                    $md5_hash = md5(SECURITYSALT . $r_resource_vars['boards']);
                    $obj['google_syn_url'] = $_server_domain_url . '/ical/' . $r_resource_vars['boards'] . '/' . $md5_hash . '.ics';
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
                } else if ($r_resource_cmd == '/activities') {
                    if (!empty($obj['revisions']) && trim($obj['revisions']) != '') {
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
                } else if ($r_resource_cmd == '/organizations/?') {
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
                } else if ($r_resource_cmd == '/boards' && (!empty($r_resource_filters['type']) && $r_resource_filters['type'] == 'simple')) {
                    if (!empty($obj['lists'])) {
                        foreach ($obj['lists'] as $list) {
                            $board_lists[$list['id']] = $list;
                        }
                    }
                }
                if (!empty($_metadata)) {
                    $data['data'][] = $obj;
                } elseif (in_array($r_resource_cmd, $arrayResponse)) {
                    $data[] = $obj;
                } else {
                    $data = $obj;
                }
            }
            if (!empty($_metadata)) {
                $data['_metadata'] = $_metadata;
            }
            if (!empty($_metadata) && !empty($filter_count)) {
                $data['filter_count'] = $filter_count;
            }
            if (!empty($_metadata) && !empty($board_user_roles)) {
                $data['board_user_roles'] = $board_user_roles;
            }
            if (!empty($roles)) {
                $data['roles'] = $roles;
            }
            if (!empty($_metadata)) {
                $data['_metadata'] = $_metadata;
            }
            if (!empty($board_lists) && $r_resource_cmd == '/boards' && (!empty($r_resource_filters['type']) && $r_resource_filters['type'] == 'simple')) {
                $settings = array();
                $s_sql = pg_query_params($db_lnk, 'SELECT name, LOWER(value) as value FROM settings WHERE name = \'TODO\' OR name = \'DOING\' OR name = \'DONE\'', array());
                while ($row = pg_fetch_assoc($s_sql)) {
                    $settings[$row['name']] = array_map('trim', explode(',', $row['value']));
                }
                if (!empty($settings)) {
                    $settings_lists = array();
                    $my_lists = array();
                    $dashboard_response = array();
                    $monday = 'last monday';
                    $sunday = 'next sunday';
                    if (1 == date('N')) {
                        $monday = 'today';
                    }
                    if (0 == date('N')) {
                        $sunday = 'today';
                    }
                    $week_start_day = date('Y-m-d', strtotime($monday));
                    $week_end_day = date('Y-m-d', strtotime($sunday));
                    $dashboard_response['week_start_day'] = date('d', strtotime($monday));
                    $dashboard_response['week_end_day'] = date('d', strtotime($sunday));
                    $dashboard_response['week_start_month'] = date('M', strtotime($monday));
                    $dashboard_response['week_end_month'] = date('M', strtotime($sunday));
                    foreach ($board_lists as $list) {
                        foreach ($settings as $key => $setting) {
                            $trim = trim($list['name']);
                            $str_low = strtolower($trim);
                            if (in_array($str_low, $setting)) {
                                $my_lists[] = $list['id'];
                                $settings_lists[$key][] = $list['id'];
                            }
                        }
                    }
                    $user_con = ($authUser['role_id'] == 1) ? '' : 'cu.user_id = ' . $authUser['id'] . ' and ';
                    foreach ($settings_lists as $key => $settings_list) {
                        $s_sql = pg_query_params($db_lnk, 'SELECT count(cl.id) as cnt FROM cards_listing cl left join cards_users cu on cu.card_id = cl.id where ' . $user_con . 'CAST(cl.due_date AS DATE) = current_date::date and cl.list_id IN (' . implode($settings_list, ',') . ')', array());
                        while ($row = pg_fetch_assoc($s_sql)) {
                            $dashboard_response['today'][$key] = $row['cnt'];
                        }
                        $s_sql = pg_query_params($db_lnk, 'SELECT count(cl.id) as cnt FROM cards_listing cl left join cards_users cu on cu.card_id = cl.id where ' . $user_con . 'cl.list_id IN (' . implode($settings_list, ',') . ')', array());
                        while ($row = pg_fetch_assoc($s_sql)) {
                            $dashboard_response['overall'][$key] = $row['cnt'];
                        }
                        $s_sql = pg_query_params($db_lnk, 'SELECT count(cl.id) as cnt FROM cards_listing cl left join cards_users cu on cu.card_id = cl.id where ' . $user_con . 'CAST(cl.due_date AS DATE) between \'' . $week_start_day . '\' and \'' . $week_end_day . '\' and cl.list_id IN (' . implode($settings_list, ',') . ')', array());
                        while ($row = pg_fetch_assoc($s_sql)) {
                            $dashboard_response['current_week'][$key] = $row['cnt'];
                        }
                        $s_sql = pg_query_params($db_lnk, 'select (SELECT count(cl.id) as cnt FROM cards_listing cl left join cards_users cu on cu.card_id = cl.id where ' . $user_con . '(CAST(due_date AS DATE) =  cast(date_trunc(\'week\', current_date) as date) + i) and cl.list_id IN (' . implode($settings_list, ',') . ')) from generate_series(0,6) i', array());
                        while ($row = pg_fetch_assoc($s_sql)) {
                            $dashboard_response['current_weekwise'][$key][] = $row['cnt'];
                        }
                        $s_sql = pg_query_params($db_lnk, 'select (SELECT count(cl.id) as cnt FROM cards_listing cl left join cards_users cu on cu.card_id = cl.id where ' . $user_con . '(CAST(due_date AS DATE) =  cast(date_trunc(\'week\', current_date - interval \'7 days\') as date) + i) and cl.list_id IN (' . implode($settings_list, ',') . ')) from generate_series(0,6) i', array());
                        while ($row = pg_fetch_assoc($s_sql)) {
                            $dashboard_response['last_weekwise'][$key][] = $row['cnt'];
                        }
                    }
                    if (!empty($my_lists)) {
                        $s_sql = pg_query_params($db_lnk, 'SELECT count(id) as cnt FROM cards_listing where cards_user_count = 0 and list_id IN (' . implode($my_lists, ',') . ')', array());
                        while ($row = pg_fetch_assoc($s_sql)) {
                            $dashboard_response['unassigned'] = $row['cnt'];
                        }
                    }
                    $data['_metadata']['dashboard'] = $dashboard_response;
                }
            }
            echo json_encode($data);
            pg_free_result($result);
        } else {
            $r_debug.= __LINE__ . ': ' . pg_last_error($db_lnk) . '\n';
        }
    } else {
        echo json_encode($response);
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
    global $r_debug, $db_lnk, $authUser, $thumbsizes, $_server_domain_url;
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
                $conditions = array(
                    $user_id['user_id']
                );
                $users = pg_query_params($db_lnk, 'DELETE FROM users WHERE id= $1 RETURNING username', $conditions);
                if (JABBER_HOST) {
                    $user = pg_fetch_assoc($users);
                    $xmpp_user = getXmppUser();
                    $xmpp = new xmpp($xmpp_user);
                    $xmpp->deleteUser('<iq from="' . $authUser['username'] . '@' . JABBER_HOST . '" id="delete-user-2" to="' . JABBER_HOST . '" type="set" xml:lang="en"><command xmlns="http://jabber.org/protocol/commands" node="http://jabber.org/protocol/admin#delete-user"><x xmlns="jabber:x:data" type="submit"><field type="hidden" var="FORM_TYPE"><value>http://jabber.org/protocol/admin</value></field><field var="accountjids"><value>' . $user['username'] . '@' . JABBER_HOST . '</value></field></x></command></iq>');
                }
            }
            $response = array(
                'success' => 'Checked users are deleted successfully.'
            );
        }
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
            if (JABBER_HOST) {
                $xmpp_user = getXmppUser();
                $xmpp = new xmpp($xmpp_user);
            }
            foreach ($board_ids as $board_id) {
                $conditions = array(
                    $board_id['board_id']
                );
                $boards = pg_query_params($db_lnk, 'DELETE FROM boards WHERE id= $1', $conditions);
                if (JABBER_HOST && $boards) {
                    $board = pg_fetch_assoc($boards);
                    $xmpp->destroyRoom('board-' . $board_id['board_id']);
                }
            }
            $response = array(
                'success' => 'Checked boards are deleted successfully.'
            );
        }
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
            pg_query_params($db_lnk, 'UPDATE users SET (password) = ($1) WHERE id = $2', $val_arr);
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
            $r_post['is_active'] = true;
            $r_post['is_email_confirmed'] = true;
            $r_post['role_id'] = 2; // user
            $r_post['initials'] = strtoupper(substr($r_post['username'], 0, 1));
            $r_post['ip_id'] = saveIp();
            $r_post['full_name'] = email2name($r_post['email']);
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
        break;

    case '/users/register': //users register
        $table_name = 'users';
        $val_arr = array(
            $r_post['username'],
            $r_post['email']
        );
        $user = executeQuery('SELECT * FROM users WHERE (username = $1 AND username<>\'\') OR (email = $2 AND email<>\'\')', $val_arr);
        if (!$user) {
            $sql = true;
            $table_name = 'users';
            $r_post['password'] = getCryptHash($r_post['password']);
            $r_post['role_id'] = 2; // user
            $r_post['initials'] = strtoupper(substr($r_post['username'], 0, 1));
            $r_post['ip_id'] = saveIp();
            $r_post['full_name'] = ($r_post['email'] == '') ? $r_post['username'] : email2name($r_post['email']);
            if (JABBER_HOST) {
                global $j_username, $j_password;
                $jaxl_initialize = array(
                    'jid' => JABBER_HOST,
                    'strict' => false,
                    'log_level' => JAXL_DEBUG,
                    'port' => 5222,
                    'log_path' => 'jaxl.log'
                );
                $GLOBALS['client'] = new JAXL($jaxl_initialize);
                $j_username = $r_post['username'];
                $j_password = $r_post['password'];
                $xeps = array(
                    '0077'
                );
                $GLOBALS['client']->require_xep($xeps);
                $GLOBALS['client']->add_cb('on_stream_features', function ($stanza)
                {
                    global $argv;
                    $GLOBALS['client']->xeps['0077']->get_form(JABBER_HOST);
                    return "wait_for_register_form";
                });
                $GLOBALS['client']->add_cb('on_disconnect', function ()
                {
                    global $form;
                    _info("registration " . ($form['type'] == 'result' ? 'succeeded' : 'failed'));
                });
                $GLOBALS['client']->start();
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
        break;

    case '/users/login': //users login
        $table_name = 'users';
        $val_arr = array(
            $r_post['email']
        );
        $log_user = executeQuery('SELECT id, role_id, password, is_ldap::boolean::int FROM users WHERE email = $1 or username = $1', $val_arr);
        if (LDAP_LOGIN_ENABLED && (empty($log_user) || (!empty($log_user) && $log_user['is_ldap'] == 1))) {
            $check_user = ldapAuthenticate($r_post['email'], $r_post['password']);
            if (is_array($check_user) && !empty($check_user['User']) && $check_user['User']['is_username_exits'] && $check_user['User']['is_password_matched'] && isset($check_user['User']['email']) && !empty($check_user['User']['email'])) {
                $val_arr = array(
                    $check_user['User']['email']
                );
                $user = executeQuery('SELECT * FROM users_listing WHERE email = $1', $val_arr);
                if (!$user) {
                    $r_post['password'] = getCryptHash($r_post['password']);
                    $r_post['role_id'] = 2; // user
                    preg_match_all('/\b\w/', $check_user['User']['first_name'], $match);
                    $val_arr = array(
                        $r_post['email'],
                        $check_user['User']['email'],
                        $r_post['password'],
                        $check_user['User']['first_name'],
                        strtoupper(substr($r_post['email'], 0, 1))
                    );
                    $result = pg_query_params($db_lnk, 'INSERT INTO ' . $table_name . ' (created, modified, role_id, username, email, password, full_name, initials, is_active, is_email_confirmed, is_ldap) VALUES (now(), now(), 2, $1, $2, $3, $4, $5, true, true, true) RETURNING * ', $val_arr);
                    $user = pg_fetch_assoc($result);
                    $val_arr = array(
                        $user['id']
                    );
                    $user = executeQuery('SELECT * FROM users_listing WHERE id = $1', $val_arr);
                }
            } else {
                $ldap_error = $check_user;
            }
        } else if (STANDARD_LOGIN_ENABLED && !empty($log_user) && $log_user['is_ldap'] == 0) {
            $r_post['password'] = crypt($r_post['password'], $log_user['password']);
            $val_arr = array(
                $r_post['email'],
                $r_post['password'],
                1
            );
            $user = executeQuery('SELECT * FROM users_listing WHERE (email = $1 or username = $1) AND password = $2 AND is_active = $3', $val_arr);
        }
        if (!empty($user)) {
            if (LDAP_LOGIN_ENABLED) {
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
            $role_val_arr = array(
                $user['role_id']
            );
            $role_links = executeQuery('SELECT * FROM role_links_listing WHERE id = $1', $role_val_arr);
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
        break;

    case '/users/?/changepassword':
        $qry_val_array = array(
            $r_resource_vars['users']
        );
        if ($r_post['confirm_password'] == $r_post['password']) {
            $user = executeQuery('SELECT * FROM users WHERE id = $1', $qry_val_array);
            if ($user) {
                $cry_old_pass = crypt($r_post['old_password'], $user['password']);
                if ((($authUser['role_id'] == 2) && ($user['password'] == $cry_old_pass)) || ($authUser['role_id'] == 1)) {
                    $res_val_arr = array(
                        getCryptHash($r_post['password']) ,
                        $r_resource_vars['users']
                    );
                    pg_query_params($db_lnk, 'UPDATE users SET (password) = ($1) WHERE id = $2', $res_val_arr);
                    if (JABBER_HOST) {
                        $xmpp_user = getXmppUser();
                        $xmpp = new xmpp($xmpp_user);
                        $xmpp->changePassword('<iq xmlns="jabber:client" to="' . JABBER_HOST . '" type="set" id="2"><query 
						xmlns="jabber:iq:register"><username>' . $user['username'] . '</username><password>' . $r_post['password'] . '</password></query></iq>');
                    }
                    $conditions = array(
                        $authUser['username']
                    );
                    pg_query_params($db_lnk, 'DELETE FROM oauth_access_tokens WHERE user_id= $1', $conditions);
                    pg_query_params($db_lnk, 'DELETE FROM oauth_refresh_tokens WHERE user_id= $1', $conditions);
                    if ($authUser['role_id'] == 1) {
                        $emailFindReplace = array(
                            '##PASSWORD##' => $r_post['password']
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
        } else {
            $response = array(
                'error' => 3
            );
        }
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
                $mediadir = APP_PATH . DIRECTORY_SEPARATOR . 'media' . DIRECTORY_SEPARATOR . 'User' . DIRECTORY_SEPARATOR . $r_resource_vars['users'];
                $save_path = 'media' . DIRECTORY_SEPARATOR . 'User' . DIRECTORY_SEPARATOR . $r_resource_vars['users'];
                if (!file_exists($mediadir)) {
                    mkdir($mediadir, 0777, true);
                }
                $file = $_FILES['attachment'];
                $file['name'] = preg_replace('/[^A-Za-z0-9\-.]/', '', $file['name']);
                if (is_uploaded_file($file['tmp_name']) && move_uploaded_file($file['tmp_name'], $mediadir . DIRECTORY_SEPARATOR . $file['name'])) {
                    $profile_picture_path = $save_path . DIRECTORY_SEPARATOR . $file['name'];
                    foreach ($thumbsizes['User'] as $key => $value) {
                        $mediadir = APP_PATH . '/client/img/' . $key . '/User/' . $r_resource_vars['users'];
                        $list = glob($mediadir . '.*');
                        if (file_exists($list[0])) {
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
            if ($no_error) {
                $_POST['initials'] = strtoupper($_POST['initials']);
                $qry_val_arr = array(
                    $_POST['full_name'],
                    $_POST['about_me'],
                    $_POST['initials'],
                    $_POST['is_send_newsletter'],
                    $_POST['timezone'],
                    $r_resource_vars['users']
                );
                $comment = '##USER_NAME## updated the profile.';
                $foreign_ids['user_id'] = $authUser['id'];
                $table_name = 'users';
                $id = $r_resource_vars['users'];
                if (!empty($table_name) && !empty($id)) {
                    $put = getbindValues($table_name, $_POST);
                    if ($table_name == 'users') {
                        unset($put['ip_id']);
                    }
                    $sfields = '';
                    foreach ($put as $key => $value) {
                        if ($key != 'id') {
                            $fields.= ', ' . $key;
                        }
                        if ($key != 'id' && $key != 'position') {
                            $sfields.= (empty($sfields)) ? $key : ", " . $key;
                        }
                    }
                    if (!empty($comment)) {
                        $qry_va_arr = array(
                            $id
                        );
                        $revisions['old_value'] = executeQuery('SELECT ' . $sfields . ' FROM ' . $table_name . ' WHERE id =  $1', $qry_va_arr);
                        unset($revisions['old_value']['is_send_newsletter']);
                        unset($_POST['is_send_newsletter']);
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
                }
                pg_query_params($db_lnk, 'UPDATE users SET full_name = $1, about_me = $2, initials = $3, is_send_newsletter = $4, timezone = $5 WHERE id = $6', $qry_val_arr);
                if (!empty($_POST['email'])) {
                    $qry_val_arr = array(
                        $_POST['email'],
                        $r_resource_vars['users']
                    );
                    pg_query_params($db_lnk, 'UPDATE users SET email= $1 WHERE id = $2', $qry_val_arr);
                }
            }
        }
        if ($no_error) {
            $response['success'] = 'User Profile has been updated.';
        } else {
            $response['error'] = $msg;
        }
        break;

    case '/settings': //settings update
        foreach ($r_post as $key => $value) {
            if (($key == 'LDAP_BIND_PASSWD' || $key == 'IMAP_EMAIL_PASSWORD')) {
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
        break;

    case '/boards': //boards add
        if (!empty($_FILES['board_import'])) {
            if ($_FILES['board_import']['error'] == 0) {
                $get_files = file_get_contents($_FILES['board_import']['tmp_name']);
                $utf8_encoded_content = utf8_encode($get_files);
                $imported_board = json_decode($utf8_encoded_content, true, 512, JSON_UNESCAPED_UNICODE);
                if (!empty($imported_board) && !empty($imported_board['prefs'])) {
                    $board = importTrelloBoard($imported_board);
                    $response['id'] = $board['id'];
                } else {
                    $response['error'] = 'Unable to import. please try again.';
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
        } else {
            $subcriber = convertBooleanValues($table_name, $subcriber);
            if ($subcriber['is_starred'] == 1) {
                $qry_val_arr = array(
                    0,
                    $r_resource_vars['boards'],
                    $authUser['id']
                );
                $result = pg_query_params($db_lnk, 'UPDATE ' . $table_name . ' SET is_starred = $1 Where  board_id = $2 and user_id = $3 RETURNING id', $qry_val_arr);
            } else {
                $qry_val_arr = array(
                    1,
                    $r_resource_vars['boards'],
                    $authUser['id']
                );
                $result = pg_query_params($db_lnk, 'UPDATE ' . $table_name . ' SET is_starred = $1 Where  board_id = $2 and user_id = $3 RETURNING id', $qry_val_arr);
            }
        }
        $star = pg_fetch_assoc($result);
        $response['id'] = $star['id'];
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
        $r_post = array_merge($r_post, $srow);
        $r_post['board_visibility'] = $board_visibility;
        if (!empty($organization_id)) {
            $r_post['organization_id'] = $organization_id;
        }
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
                $mediadir = APP_PATH . DIRECTORY_SEPARATOR . 'media' . DIRECTORY_SEPARATOR . 'Board' . DIRECTORY_SEPARATOR . $r_resource_vars['boards'];
                $save_path = 'media' . DIRECTORY_SEPARATOR . 'Board' . DIRECTORY_SEPARATOR . $r_resource_vars['boards'];
                if (!file_exists($mediadir)) {
                    mkdir($mediadir, 0777, true);
                }
                $file = $_FILES['attachment'];
                $file['name'] = preg_replace('/[^A-Za-z0-9\-.]/', '', $file['name']);
                if (is_uploaded_file($file['tmp_name']) && move_uploaded_file($file['tmp_name'], $mediadir . DIRECTORY_SEPARATOR . $file['name'])) {
                    $r_post['name'] = $file['name'];
                    foreach ($thumbsizes['Board'] as $key => $value) {
                        $mediadir = APP_PATH . DIRECTORY_SEPARATOR . 'client' . DIRECTORY_SEPARATOR . 'img' . DIRECTORY_SEPARATOR . $key . DIRECTORY_SEPARATOR . 'Board' . DIRECTORY_SEPARATOR . $r_resource_vars['boards'];
                        $list = glob($mediadir . '.*');
                        if (file_exists($list[0])) {
                            unlink($list[0]);
                        }
                    }
                    $hash = md5(SECURITYSALT . 'Board' . $r_resource_vars['boards'] . 'jpg' . 'extra_large_thumb');
                    $background_picture_url = $_server_domain_url . '/img/extra_large_thumb/Board/' . $r_resource_vars['boards'] . '.' . $hash . '.jpg';
                    $r_post['background_picture_path'] = $save_path . DIRECTORY_SEPARATOR . $file['name'];
                    $r_post['path'] = $background_picture_url;
                    $response['background_picture_url'] = $background_picture_url;
                }
                $qry_val_array = array(
                    $r_post['path'],
                    $r_post['background_picture_path'],
                    $r_resource_vars['boards']
                );
                pg_query_params($db_lnk, 'UPDATE boards SET background_picture_url = $1,background_picture_path = $2 WHERE id = $3', $qry_val_array);
            } else {
                $response['error'] = 'File extension not supported. It supports only jpg, png, bmp and gif.';
            }
        }
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
            $is_subscribed = ($r_post['is_subscribed']) ? true : false;
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
        break;

    case '/boards/?/lists/?/cards':
        $table_name = 'cards';
        $r_post['user_id'] = $authUser['id'];
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
        $r_post['freshness_ts'] = date('Y-m-d h:i:s');
        $r_post['type'] = 'add_comment';
        if (empty($r_post['user_id'])) {
            $r_post['user_id'] = $authUser['id'];
        }
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
        $s_result = pg_query_params($db_lnk, 'SELECT is_subscribed FROM card_subscribers WHERE card_id = $1 and user_id = $2', $qry_val_arr);
        $check_subscribed = pg_fetch_assoc($s_result);
        if (!empty($check_subscribed)) {
            $is_subscribed = ($r_post['is_subscribed']) ? true : false;
            $qry_val_arr = array(
                $is_subscribed,
                $r_resource_vars['cards'],
                $r_post['user_id']
            );
            $s_result = pg_query_params($db_lnk, 'UPDATE card_subscribers SET is_subscribed = $1 WHERE card_id = $2 and user_id = $3 RETURNING id', $qry_val_arr);
            $subscribe = pg_fetch_assoc($s_result);
            $response['id'] = $subscribe['id'];
        } else {
            $r_post['card_id'] = $r_resource_vars['cards'];
            $r_post['user_id'] = $r_post['user_id'];
            $sql = true;
        }
        break;

    case '/boards/?/lists/?/cards/?/card_voters':
        $table_name = 'card_voters';
        $r_post['card_id'] = $r_resource_vars['cards'];
        $r_post['user_id'] = $authUser['id'];
        $sql = true;
        break;

    case '/boards/?/lists/?/cards/?/attachments':
        $is_return_vlaue = true;
        $table_name = 'card_attachments';
        $r_post['card_id'] = $r_resource_vars['cards'];
        $r_post['list_id'] = $r_resource_vars['lists'];
        $r_post['board_id'] = $r_resource_vars['boards'];
        $mediadir = APP_PATH . DIRECTORY_SEPARATOR . 'media' . DIRECTORY_SEPARATOR . 'Card' . DIRECTORY_SEPARATOR . $r_resource_vars['cards'];
        $save_path = 'media' . DIRECTORY_SEPARATOR . 'Card' . DIRECTORY_SEPARATOR . $r_resource_vars['cards'];
        $save_path = str_replace('\\', '/', $save_path);
        if (!empty($_FILES['attachment']) && $_FILES['attachment']['error'] == 0) {
            if (!file_exists($mediadir)) {
                mkdir($mediadir, 0777, true);
            }
            $file = $_FILES['attachment'];
            if (is_uploaded_file($file['tmp_name']) && move_uploaded_file($file['tmp_name'], $mediadir . DIRECTORY_SEPARATOR . $file['name'])) {
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
                $response['card_attachments'][] = pg_fetch_assoc($s_result);
            }
            foreach ($thumbsizes['CardAttachment'] as $key => $value) {
                $mediadir = APP_PATH . '/client/img/' . $key . '/CardAttachment/' . $response['card_attachments'][0]['id'];
                $list = glob($mediadir . '.*');
                if (!empty($list) && file_exists($list[0])) {
                    unlink($list[0]);
                }
            }
            $foreign_ids['board_id'] = $r_resource_vars['boards'];
            $foreign_ids['list_id'] = $r_resource_vars['lists'];
            $foreign_ids['card_id'] = $r_resource_vars['cards'];
            $comment = '##USER_NAME## added attachment to this card ##CARD_LINK##';
            $response['activity'] = insertActivity($authUser['id'], $comment, 'add_card_attachment', $foreign_ids, null, $response['card_attachments'][0]['id']);
        } else if (!empty($_FILES['attachment']) && is_array($_FILES['attachment']['name']) && $_FILES['attachment']['error'][0] == 0) {
            $file = $_FILES['attachment'];
            $file_count = count($file['name']);
            for ($i = 0; $i < $file_count; $i++) {
                if ($file['name'][$i] != 'undefined') {
                    if (!file_exists($mediadir)) {
                        mkdir($mediadir, 0777, true);
                    }
                    if (is_uploaded_file($file['tmp_name'][$i]) && move_uploaded_file($file['tmp_name'][$i], $mediadir . DIRECTORY_SEPARATOR . $file['name'][$i])) {
                        $r_post[$i]['path'] = $save_path . DIRECTORY_SEPARATOR . $file['name'][$i];
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
                        $response['card_attachments'][] = pg_fetch_assoc($s_result);
                        $foreign_ids['board_id'] = $r_resource_vars['boards'];
                        $foreign_ids['list_id'] = $r_resource_vars['lists'];
                        $foreign_ids['card_id'] = $r_resource_vars['cards'];
                        $comment = '##USER_NAME## added attachment to this card ##CARD_LINK##';
                        $response['activity'] = insertActivity($authUser['id'], $comment, 'add_card_attachment', $foreign_ids, null, $response['card_attachments'][$i]['id']);
                        foreach ($thumbsizes['CardAttachment'] as $key => $value) {
                            $imgdir = APP_PATH . '/client/img/' . $key . '/CardAttachment/' . $response['card_attachments'][$i]['id'];
                            $list = glob($imgdir . '.*');
                            if (!empty($list) && file_exists($list[0])) {
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
                    $comment = '##USER_NAME## added attachment to this card ##CARD_LINK##';
                    $response['activity'] = insertActivity($authUser['id'], $comment, 'add_card_attachment', $foreign_ids, null, $response['card_attachments'][$i]['id']);
                    $i++;
                }
            } else {
                $sql = true;
                $attachment_url_host = parse_url($r_post['image_link'], PHP_URL_HOST);
                $url_hosts = array(
                    'docs.google.com',
                    'www.dropbox.com',
                    'github.com'
                );
                if (in_array($attachment_url_host, $url_hosts)) {
                    $r_post['name'] = $r_post['link'] = $r_post['image_link'];
                    $r_post['path'] = '';
                } else {
                    $filename = curlExecute($r_post['image_link'], 'get', $mediadir, 'image');
                    $r_post['name'] = $filename['file_name'];
                    $r_post['link'] = $r_post['image_link'];
                    $r_post['path'] = $save_path . '/' . $r_post['name'];
                }
                unset($r_post['image_link']);
            }
        }
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
        $delete_labels = pg_query_params($db_lnk, 'DELETE FROM ' . $table_name . ' WHERE card_id = $1 RETURNING label_id', $qry_val_arr);
        $delete_label = pg_fetch_assoc($delete_labels);
        $delete_labels_count = pg_affected_rows($delete_labels);
        if (!empty($r_post['name'])) {
            $label_names = explode(',', $r_post['name']);
            unset($r_post['name']);
            foreach ($label_names as $label_name) {
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
            $s_result = pg_query_params($db_lnk, 'SELECT * FROM cards_labels_listing WHERE card_id = $1', $qry_val_arr);
            $cards_labels = pg_fetch_all($s_result);
            $response['cards_labels'] = $cards_labels;
            $comment = '##USER_NAME## added label(s) to this card ##CARD_LINK## - ##LABEL_NAME##';
        } else {
            $response['cards_labels'] = array();
            $comment = '##USER_NAME## removed label(s) in this card ##CARD_LINK## - ##LABEL_NAME##';
            $foreign_ids['foreign_id'] = $delete_label['label_id'];
        }
        $foreign_ids['board_id'] = $r_post['board_id'];
        $foreign_ids['list_id'] = $r_post['list_id'];
        $foreign_ids['card_id'] = $r_post['card_id'];
        if (!empty($delete_labels_count)) {
            $response['activity'] = insertActivity($authUser['id'], $comment, 'add_card_label', $foreign_ids, null, $r_post['label_id']);
        }
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
            if (!empty($r_post['name'])) {
                $qry_val_arr = array(
                    $r_post['checklist_id']
                );
                $position = executeQuery('SELECT max(position) as position FROM checklist_items WHERE checklist_id = $1', $qry_val_arr);
                $r_post['position'] = $position['position'];
                if (empty($r_post['position'])) {
                    $r_post['position'] = 0;
                }
                $r_post['position']+= 1;
                if (empty($r_post['member'])) {
                    unset($r_post['member']);
                }
                $result = pg_execute_insert($table_name, $r_post);
                $item = pg_fetch_assoc($result);
                $response[$table_name][] = $item;
                $foreign_ids['board_id'] = $r_resource_vars['boards'];
                $foreign_ids['list_id'] = $r_resource_vars['lists'];
                $foreign_ids['card_id'] = $r_post['card_id'];
                $comment = '##USER_NAME## added item ##CHECKLIST_ITEM_NAME## in checklist ##CHECKLIST_ITEM_PARENT_NAME## of card ##CARD_LINK##';
                $response['activities'][] = insertActivity($authUser['id'], $comment, 'add_checklist_item', $foreign_ids, '', $item['id']);
            }
        }
        break;

    case '/boards/?/lists/?/cards/?/checklists/?/items/?/convert_to_card':
        $is_return_vlaue = true;
        $table_name = 'cards';
        $qry_val_arr = array(
            $r_resource_vars['items']
        );
        $result = pg_query_params($db_lnk, 'SELECT name FROM checklist_items WHERE id = $1', $qry_val_arr);
        $row = pg_fetch_assoc($result);
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
        }
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
            'false'
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
        break;

    case '/organizations/?/users/?': //organization users add
        $table_name = 'organizations_users';
        $sql = true;
        $is_return_vlaue = true;
        $r_post['organization_id'] = $r_resource_vars['organizations'];
        $r_post['user_id'] = $r_resource_vars['users'];
        break;

    case '/organizations': //organizations add
        $sql = true;
        $table_name = 'organizations';
        $r_post['user_id'] = (!empty($authUser['id'])) ? $authUser['id'] : 1;
        $r_post['organization_visibility'] = 2;
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
                $mediadir = APP_PATH . DIRECTORY_SEPARATOR . 'media' . DIRECTORY_SEPARATOR . 'Organization' . DIRECTORY_SEPARATOR . $r_resource_vars['organizations'];
                $save_path = 'media' . DIRECTORY_SEPARATOR . 'Organization' . DIRECTORY_SEPARATOR . $r_resource_vars['organizations'];
                if (!file_exists($mediadir)) {
                    mkdir($mediadir, 0777, true);
                }
                $file = $_FILES['attachment'];
                $file['name'] = preg_replace('/[^A-Za-z0-9\-.]/', '', $file['name']);
                if (is_uploaded_file($file['tmp_name']) && move_uploaded_file($file['tmp_name'], $mediadir . DIRECTORY_SEPARATOR . $file['name'])) {
                    $logo_url = $save_path . DIRECTORY_SEPARATOR . $file['name'];
                    foreach ($thumbsizes['Organization'] as $key => $value) {
                        $list = glob(APP_PATH . DIRECTORY_SEPARATOR . 'img' . DIRECTORY_SEPARATOR . $key . DIRECTORY_SEPARATOR . 'Organization' . DIRECTORY_SEPARATOR . $r_resource_vars['organizations'] . '.*');
                        if (file_exists($list[0])) {
                            unlink($list[0]);
                        }
                    }
                    foreach ($thumbsizes['Organization'] as $key => $value) {
                        $mediadir = APP_PATH . '/client/img/' . $key . '/Organization/' . $r_resource_vars['organizations'];
                        $list = glob($mediadir . '.*');
                        if (file_exists($list[0])) {
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
        break;

    case '/apps/settings':
        $folder_name = $r_post['folder'];
        unset($r_post['folder']);
        $content = file_get_contents(APP_PATH . '/client/apps/' . $folder_name . '/app.json');
        $app = json_decode($content, true);
        if (isset($r_post['enable'])) {
            $app['enabled'] = $r_post['enable'];
        } else {
            foreach ($r_post as $key => $val) {
                $app['settings'][$key]['value'] = $val;
            }
        }
        $fh = fopen(APP_PATH . '/client/apps/' . $folder_name . '/app.json', 'w');
        fwrite($fh, json_encode($app, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES));
        fclose($fh);
        $response['success'] = 'App updated successfully';
        break;

    case '/oauth/token':
        $post_val = array(
            'grant_type' => 'authorization_code',
            'code' => $r_post['code'],
            'redirect_uri' => $r_post['redirect_uri'],
            'client_id' => OAUTH_CLIENTID,
            'client_secret' => OAUTH_CLIENT_SECRET
        );
        $response = getToken($post_val);
        break;

    case '/oauth/clients':
        $sql = true;
        $table_name = 'oauth_clients';
        $r_post['client_id'] = isClientIdAvailable();
        $r_post['client_secret'] = isClientSecretAvailable();
        $r_post['grant_types'] = 'client_credentials refresh_token authorization_code';
        break;

    case '/webhooks':
        $sql = true;
        $table_name = 'webhooks';
        break;

    case '/roles':
        $sql = true;
        $table_name = 'roles';
        break;

    case '/board_user_roles':
        $sql = true;
        $table_name = 'board_user_roles';
        break;

    case '/organization_user_roles':
        $sql = true;
        $table_name = 'organization_user_roles';
        break;

    case '/users/import':
        $t_ldap_server = (LDAP_IS_SSL == 'true') ? 'ldaps://' : 'ldap://';
        $t_ds = $ldap_connection = ldap_connect($t_ldap_server . LDAP_SERVER, LDAP_PORT);
        if ($t_ds > 0) {
            ldap_set_option($ldap_connection, LDAP_OPT_PROTOCOL_VERSION, LDAP_PROTOCOL_VERSION) or die('Unable to set LDAP protocol version');
            ldap_set_option($ldap_connection, LDAP_OPT_REFERRALS, 0);
            $t_password = '';
            $t_binddn = '';
            if (empty($t_binddn) && empty($t_password)) {
                $t_binddn = LDAP_BIND_DN;
                $ldap_bind_passwd_decode = base64_decode(LDAP_BIND_PASSWD);
                $t_password = str_rot13($ldap_bind_passwd_decode);
            }
            if (true === ldap_bind($ldap_connection, $t_binddn, $t_password)) {
                $search_filter = '(&(objectCategory=person)(' . LDAP_UID_FIELD . '=*))';
                $attributes = array(
                    'samaccountname',
                    'mail',
                    'name',
                    'memberof',
                    'admincount',
                );
                $result = ldap_search($ldap_connection, LDAP_ROOT_DN, $search_filter, $attributes);
                if (false !== $result) {
                    $entries = ldap_get_entries($ldap_connection, $result);
                    $users = array();
                    for ($x = 0; $x < $entries['count']; $x++) {
                        if (!empty($entries[$x]['mail'][0])) {
                            if ($_POST['is_import_organizations'] != 'true') {
                                $users[] = array(
                                    'username' => !empty($entries[$x]['samaccountname'][0]) ? trim($entries[$x]['samaccountname'][0]) : '',
                                    'email' => !empty($entries[$x]['mail'][0]) ? trim($entries[$x]['mail'][0]) : '',
                                    'name' => !empty($entries[$x]['name'][0]) ? trim($entries[$x]['name'][0]) : '',
                                    'admincount' => !empty($entries[$x]['admincount']['count']) ? trim($entries[$x]['admincount']['count']) : '',
                                );
                            } else {
                                if (!empty($entries[$x]['memberof'][0])) {
                                    $users[trim($entries[$x]['memberof'][0]) ][] = array(
                                        'username' => !empty($entries[$x]['samaccountname'][0]) ? trim($entries[$x]['samaccountname'][0]) : '',
                                        'email' => !empty($entries[$x]['mail'][0]) ? trim($entries[$x]['mail'][0]) : '',
                                        'name' => !empty($entries[$x]['name'][0]) ? trim($entries[$x]['name'][0]) : '',
                                        'admincount' => !empty($entries[$x]['admincount']['count']) ? trim($entries[$x]['admincount']['count']) : '',
                                    );
                                } else {
                                    $no_organization_users[] = array(
                                        'username' => !empty($entries[$x]['samaccountname'][0]) ? trim($entries[$x]['samaccountname'][0]) : '',
                                        'email' => !empty($entries[$x]['mail'][0]) ? trim($entries[$x]['mail'][0]) : '',
                                        'name' => !empty($entries[$x]['name'][0]) ? trim($entries[$x]['name'][0]) : '',
                                        'admincount' => !empty($entries[$x]['admincount']['count']) ? trim($entries[$x]['admincount']['count']) : '',
                                    );
                                }
                            }
                        }
                    }
                }
                ldap_unbind($ldap_connection);
            }
            if (!empty($users)) {
                if ($_POST['is_import_organizations'] != 'true') {
                    foreach ($users as $keys => $values) {
                        $condition = array(
                            $values['username']
                        );
                        $is_user_exist = executeQuery('SELECT id FROM users WHERE username = $1', $condition);
                        if (empty($is_user_exist)) {
                            $password = getCryptHash($values['username']);
                            preg_match_all('/\b\w/', $values['name'], $match);
                            $data = array(
                                $values['username'],
                                $values['email'],
                                $password,
                                $values['name'],
                                strtoupper(substr($values['username'], 0, 1))
                            );
                            pg_query_params($db_lnk, 'INSERT INTO users(created, modified, role_id, username, email, password, full_name, initials, is_active, is_email_confirmed, is_ldap) VALUES (now(), now(), 2, $1, $2, $3, $4, $5,  true, true, true) RETURNING id ', $data);
                            if ($_POST['is_send_welcome_mail'] == 'true') {
                                $emailFindReplace = array(
                                    '##NAME##' => $values['name'],
                                );
                                sendMail('welcome', $emailFindReplace, $values['email']);
                            }
                        }
                    }
                } else {
                    foreach ($users as $key => $value) {
                        $org = explode(",", $key);
                        $organization_name = substr($org[0], 3);
                        $condition = array(
                            $organization_name
                        );
                        $is_organization_exist = executeQuery('SELECT id FROM organizations WHERE name = $1', $condition);
                        if (empty($is_organization_exist)) {
                            $data = array(
                                $authUser['id'],
                                $organization_name,
                                0
                            );
                            $result = pg_query_params($db_lnk, 'INSERT INTO organizations(created, modified, user_id, name, organization_visibility) VALUES (now(), now(), $1, $2, $3) RETURNING id', $data);
                            $organization = pg_fetch_assoc($result);
                            $organization_id = $organization['id'];
                        } else {
                            $organization_id = $is_organization_exist['id'];
                        }
                        foreach ($value as $keys => $values) {
                            $condition = array(
                                $values['username']
                            );
                            $is_user_exist = executeQuery('SELECT id FROM users WHERE username = $1', $condition);
                            if (empty($is_user_exist)) {
                                $password = getCryptHash($values['username']);
                                preg_match_all('/\b\w/', $values['name'], $match);
                                $data = array(
                                    $values['username'],
                                    $values['email'],
                                    $password,
                                    $values['name'],
                                    strtoupper(substr($values['username'], 0, 1))
                                );
                                $result1 = pg_query_params($db_lnk, 'INSERT INTO users(created, modified, role_id, username, email, password, full_name, initials, is_active, is_email_confirmed, is_ldap) VALUES (now(), now(), 2, $1, $2, $3, $4, $5,  true, true, true) RETURNING id ', $data);
                                $user = pg_fetch_assoc($result1);
                                $user_id = $user['id'];
                                if ($_POST['is_send_welcome_mail'] == 'true') {
                                    $emailFindReplace = array(
                                        '##NAME##' => $values['name'],
                                    );
                                    sendMail('welcome', $emailFindReplace, $values['email']);
                                }
                            } else {
                                $user_id = $is_user_exist['id'];
                            }
                            if (empty($is_organization_exist)) {
                                $organization_user_role_id = 2;
                                if (!empty($values['admincount'])) {
                                    $organization_user_role_id = 1;
                                }
                                $data = array(
                                    $organization_id,
                                    $user_id,
                                    $organization_user_role_id
                                );
                                $condition = array(
                                    $user_id
                                );
                                $is_organization_user_exist = executeQuery('SELECT id FROM organizations_users WHERE user_id = $1', $condition);
                                if (empty($is_organization_user_exist)) {
                                    pg_query_params($db_lnk, 'INSERT INTO organizations_users (created, modified, organization_id, user_id, organization_user_role_id) VALUES (now(), now(), $1, $2, $3)', $data);
                                }
                            }
                        }
                    }
                }
                $response['success'] = 'import_success';
            } else {
                $response['error'] = 'user_not_found';
            }
        } else {
            $response['error'] = 'connection_failed';
        }
        break;

    default:
        header($_SERVER['SERVER_PROTOCOL'] . ' 501 Not Implemented', true, 501);
        break;
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
            if ($r_resource_cmd == '/users/register') {
                $emailFindReplace['##NAME##'] = $r_post['full_name'];
                $emailFindReplace['##ACTIVATION_URL##'] = 'http://' . $_SERVER['HTTP_HOST'] . '/#/users/activation/' . $row['id'] . '/' . md5($r_post['username']);
                sendMail('activation', $emailFindReplace, $r_post['email']);
            } else if ($r_resource_cmd == '/boards') {
                if (JABBER_HOST) {
                    $xmpp_user = getXmppUser();
                    $xmpp = new xmpp($xmpp_user);
                    $xmpp->createRoom('board-' . $response['id'], $r_post['name']);
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
                    $qry_val_arr = array(
                        $row['id'],
                        $r_post['user_id'],
                        true
                    );
                    pg_query_params($db_lnk, 'INSERT INTO board_subscribers (created, modified, board_id , user_id, is_subscribed) VALUES (now(), now(), $1, $2, $3)', $qry_val_arr);
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
                                    pg_query_params($db_lnk, 'INSERT INTO boards_users (created, modified, board_id , user_id, board_user_role_id) VALUES (now(), now(), $1, $2, 2)', $qry_val_arr);
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
                    if (isset($lists) && !empty($lists)) {
                        $position = 1;
                        foreach ($lists as $list) {
                            $qry_val_arr = array(
                                $response['id'],
                                $list,
                                $authUser['id'],
                                $position
                            );
                            $s_sql = 'INSERT INTO lists (created, modified, board_id, name, user_id, position) VALUES';
                            $s_sql.= '(now(), now(), $1, $2, $3, $4)';
                            pg_query_params($db_lnk, $s_sql, $qry_val_arr);
                            $position++;
                        }
                    }
                    $qry_val_arr = array(
                        $row['id']
                    );
                    $response['simple_board'] = executeQuery('SELECT row_to_json(d) FROM (SELECT * FROM simple_board_listing sbl WHERE id = $1 ORDER BY id ASC) as d', $qry_val_arr);
                    $response['simple_board'] = json_decode($response['simple_board']['row_to_json'], true);
                }
            } else if ($r_resource_cmd == '/organizations') {
                $qry_val_arr = array(
                    $row['id'],
                    $r_post['user_id'],
                    1
                );
                pg_query_params($db_lnk, 'INSERT INTO organizations_users (created, modified, organization_id , user_id, organization_user_role_id) VALUES (now(), now(), $1, $2, $3)', $qry_val_arr);
                $foreign_id['organization_id'] = $row['id'];
                $comment = '##USER_NAME## created organization "##ORGANIZATION_LINK##"';
                $response['activity'] = insertActivity($authUser['id'], $comment, 'add_organization', $foreign_id);
            } else if ($r_resource_cmd == '/boards/?/lists') {
                $foreign_ids['board_id'] = $r_post['board_id'];
                $foreign_ids['list_id'] = $response['id'];
                $comment = '##USER_NAME## added list "' . $r_post['name'] . '".';
                $response['activity'] = insertActivity($authUser['id'], $comment, 'add_list', $foreign_ids);
                if (!empty($clone_list_id)) {
                    $new_list_id = $response['id'];
                    // Copy cards
                    $card_fields = 'board_id, name, description, position, due_date, is_archived, attachment_count, checklist_count, checklist_item_count, checklist_item_completed_count, label_count, cards_user_count, cards_subscriber_count, card_voter_count, activity_count, user_id, comment_count';
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
                $response['list']['lists_subscribers'] = json_decode($response['list']['lists_subscribers'], true);
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
            } else if ($r_resource_cmd == '/boards/?/lists/?/cards' || $r_resource_cmd == '/boards/?/lists/?/cards/?/checklists/?/items/?/convert_to_card') {
                $qry_val_arr = array(
                    $r_post['list_id']
                );
                $s_result = pg_query_params($db_lnk, 'SELECT name FROM lists WHERE id = $1', $qry_val_arr);
                $list = pg_fetch_assoc($s_result);
                $foreign_ids['board_id'] = $r_post['board_id'];
                $foreign_ids['card_id'] = $response['id'];
                $foreign_ids['list_id'] = $r_post['list_id'];
                $comment = '##USER_NAME## added card ##CARD_LINK## to list "' . $list['name'] . '".';
                $response['activity'] = insertActivity($authUser['id'], $comment, 'add_card', $foreign_ids, '', $r_post['list_id']);
                if (!empty($r_post['members'])) {
                    foreach ($r_post['members'] as $member) {
                        $s_usql = 'INSERT INTO cards_users (created, modified, card_id, user_id) VALUES(now(), now(), ' . $response['id'] . ', ' . $member . ') RETURNING id';
                        $s_result = pg_query_params($db_lnk, $s_usql, array());
                        $card_user = pg_fetch_assoc($s_result);
                        $qry_val_arr = array(
                            $member
                        );
                        $_user = executeQuery('SELECT username FROM users WHERE id = $1', $qry_val_arr);
                        $comment = '##USER_NAME## added "' . $_user['username'] . '" as member to this card ##CARD_LINK##';
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
                if (!empty($r_post['card_labels'])) {
                    $label_names = explode(',', $r_post['card_labels']);
                    foreach ($label_names as $label_name) {
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
                    $comment = '##USER_NAME## added label(s) to this card ##CARD_LINK## - ##LABEL_NAME##';
                    insertActivity($authUser['id'], $comment, 'add_card_label', $foreign_ids, null, $r_post['label_id']);
                }
                $qry_val_arr = array(
                    $response['id']
                );
                $cards_labels = pg_query_params($db_lnk, 'SELECT * FROM cards_labels_listing WHERE card_id = $1', $qry_val_arr);
                while ($cards_label = pg_fetch_assoc($cards_labels)) {
                    $response['cards_labels'][] = $cards_label;
                }
            } else if ($r_resource_cmd == '/boards/?/copy') {
                $new_board_id = $row['id'];
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
                    $lists = pg_query_params($db_lnk, 'SELECT id, name, position, is_archived, card_count, lists_subscriber_count FROM lists WHERE board_id = $1', $qry_val_arr);
                } else {
                    $qry_val_arr = array(
                        $r_resource_vars['boards']
                    );
                    $lists = pg_query_params($db_lnk, 'SELECT id, name, position, is_archived, lists_subscriber_count FROM lists WHERE board_id = $1', $qry_val_arr);
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
                            // Copy cards
                            $card_fields = 'name, description, due_date, position, is_archived, attachment_count, checklist_count, checklist_item_count, checklist_item_completed_count, label_count, cards_user_count, cards_subscriber_count, card_voter_count, activity_count, user_id, comment_count';
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
                                        //Copy checklists
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
                                        //Copy card labels
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
            } else if ($r_resource_cmd == '/boards/?/lists/?/cards/?/checklists') {
                if (isset($checklist_id) && !empty($checklist_id)) {
                    $qry_val_arr = array(
                        $r_post['user_id'],
                        $response['id'],
                        $checklist_id
                    );
                    pg_query_params($db_lnk, 'INSERT INTO checklist_items (created, modified, user_id, card_id, checklist_id, name, is_completed, position) SELECT created, modified, $1, card_id, $2, name, false, position FROM checklist_items WHERE checklist_id = $3', $qry_val_arr);
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
                $comment = '##USER_NAME## added checklist ' . $response['checklist']['name'] . ' to this card ##CARD_LINK##';
                $response['activity'] = insertActivity($authUser['id'], $comment, 'add_card_checklist', $foreign_ids, '', $response['id']);
            } else if ($r_resource_cmd == '/boards/?/lists/?/cards/?/comments') {
                $id_converted = base_convert($response['id'], 10, 36);
                $materialized_path = sprintf("%08s", $id_converted);
                if (!empty($prev_message['materialized_path'])) {
                    $materialized_path = $prev_message['materialized_path'] . '-' . $materialized_path;
                }
                if (!empty($prev_message['path'])) {
                    $path = $prev_message['path'] . '.P' . $response['id'];
                    $depth = $prev_message['depth'] + 1;
                    $root = $prev_message['root'];
                    $response['activities']['depth'] = $depth;
                } else {
                    $path = 'P' . $response['id'];
                    $depth = 0;
                    $root = $response['id'];
                }
                $qry_val_arr = array(
                    $materialized_path,
                    $path,
                    $depth,
                    $root,
                    $response['id']
                );
                pg_query_params($db_lnk, 'UPDATE activities SET materialized_path = $1, path = $2, depth = $3, root = $4 WHERE id = $5', $qry_val_arr);
                $qry_val_arr = array(
                    $r_post['freshness_ts'],
                    $root
                );
                pg_query_params($db_lnk, 'UPDATE activities SET freshness_ts = $1 WHERE root = $2', $qry_val_arr);
                $qry_val_arr = array(
                    $root
                );
                $act_res = pg_query_params($db_lnk, 'SELECT * FROM activities WHERE root = $1', $qry_val_arr);
                $response['activity'] = pg_fetch_assoc($act_res);
            } else if ($r_resource_cmd == '/boards/?/lists/?/cards/?/copy') {
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
                if ($is_keep_activity) {
                    $qry_val_arr = array(
                        $response['id'],
                        $r_post['user_id'],
                        $r_post['list_id'],
                        $r_post['board_id'],
                        $copied_card_id
                    );
                    pg_query_params($db_lnk, 'INSERT INTO activities (created, modified, card_id, user_id, list_id, board_id, foreign_id, type, comment, revisions, root, freshness_ts, depth, path, materialized_path) SELECT created, modified, $1, $2, $3, $4, foreign_id, type, comment, revisions, root, freshness_ts, depth, path, materialized_path FROM activities WHERE type = \'add_comment\' AND card_id = $5 ORDER BY id', $qry_val_arr);
                }
                if ($is_keep_checklist) {
                    $qry_val_arr = array(
                        $response['id'],
                        $copied_card_id
                    );
                    pg_query_params($db_lnk, 'INSERT INTO checklists (created, modified, user_id, card_id, name, checklist_item_count, checklist_item_completed_count, position) SELECT created, modified, user_id, $1, name, checklist_item_count, checklist_item_completed_count, position FROM checklists WHERE card_id = $2 ORDER BY id', $qry_val_arr);
                    $qry_val_arr = array(
                        $response['id']
                    );
                    $checklists = pg_query_params($db_lnk, 'SELECT id FROM checklists WHERE card_id = $1', $qry_val_arr);
                    $qry_val_arr = array(
                        $copied_card_id
                    );
                    $prev_checklists = pg_query_params($db_lnk, 'SELECT id FROM checklists WHERE card_id = $1', $qry_val_arr);
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
                        pg_query_params($db_lnk, 'INSERT INTO checklist_items (created, modified, user_id, card_id, name, checklist_id, is_completed, position) SELECT created, modified, user_id, $1, name , $2, is_completed, position FROM checklist_items WHERE checklist_id = $3 ORDER BY id', $qry_val_arr);
                        $i++;
                    }
                }
                $foreign_ids['board_id'] = $r_post['board_id'];
                $foreign_ids['list_id'] = $r_post['list_id'];
                $foreign_ids['card_id'] = $response['id'];
                $comment = '##USER_NAME## copied this card "' . $srow['name'] . '" to ##CARD_NAME##';
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
                $attachments = pg_query_params($db_lnk, 'SELECT * FROM card_attachments WHERE card_id = $1', $qry_val_arr);
                while ($attachment = pg_fetch_assoc($attachments)) {
                    $response['cards']['attachments'][] = $attachment;
                }
            } else if ($r_resource_cmd == '/boards/?/lists/?/cards/?/users/?') {
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
                $comment = '##USER_NAME## added "' . $sel_details['username'] . '" as member to this card ##CARD_LINK##';
                $response['activity'] = insertActivity($authUser['id'], $comment, 'add_card_user', $foreign_ids, '', $response['id']);
            } else if ($r_resource_cmd == '/boards/?/lists/?/cards/?/attachments') {
                $foreign_ids['board_id'] = $r_post['board_id'];
                $foreign_ids['list_id'] = $r_post['list_id'];
                $foreign_ids['card_id'] = $r_post['card_id'];
                $comment = '##USER_NAME## added attachment to this card ##CARD_LINK##';
                $response['activity'] = insertActivity($authUser['id'], $comment, 'add_card_attachment', $foreign_ids, null, $response['id']);
                foreach ($thumbsizes['CardAttachment'] as $key => $value) {
                    $mediadir = APP_PATH . '/client/img/' . $key . '/CardAttachment/' . $response['id'];
                    $list = glob($mediadir . '.*');
                    if (file_exists($list[0])) {
                        unlink($list[0]);
                    }
                }
            } else if ($r_resource_cmd == '/boards/?/lists/?/cards/?/card_voters') {
                $foreign_ids['board_id'] = $r_resource_vars['boards'];
                $foreign_ids['list_id'] = $r_resource_vars['lists'];
                $foreign_ids['card_id'] = $r_post['card_id'];
                $comment = '##USER_NAME## voted on ##CARD_LINK##';
                $response['activity'] = insertActivity($authUser['id'], $comment, 'add_card_voter', $foreign_ids, '', $response['id']);
                $qry_val_arr = array(
                    $response['id']
                );
                $s_result = pg_query_params($db_lnk, 'SELECT * FROM card_voters_listing WHERE id = $1', $qry_val_arr);
                $user = pg_fetch_assoc($s_result);
                $response['card_voters'] = $user;
            } else if ($r_resource_cmd == '/boards/?/users') {
                $qry_val_arr = array(
                    $r_post['board_id']
                );
                $s_result = pg_query_params($db_lnk, 'SELECT id, name FROM boards WHERE id = $1', $qry_val_arr);
                $previous_value = pg_fetch_assoc($s_result);
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
                        '##BOARD_URL##' => 'http://' . $_SERVER['HTTP_HOST'] . '/#/board/' . $r_post['board_id'],
                    );
                    sendMail('newprojectuser', $emailFindReplace, $user['email']);
                }
                $comment = '##USER_NAME## added member to board';
                $response['activity'] = insertActivity($authUser['id'], $comment, 'add_board_user', $foreign_ids, '', $response['id']);
                if (JABBER_HOST) {
                    $xmpp_user = getXmppUser();
                    $xmpp = new xmpp($xmpp_user);
                    $xmpp->grantMember('board-' . $previous_value['id'], $r_post['username'], 'member');
                }
            } else if ($r_resource_cmd == '/organizations/?/users/?') {
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
    }
    // todo: $sql set as true query not execute, so add condition ($sql !== true)
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
    } else {
        echo json_encode($response);
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
        'now()'
    );
    $sfields = $table_name = $id = $activity_type = '';
    $response = $diff = $pg_params = $foreign_id = $foreign_ids = $revisions = $previous_value = $obj = array();
    $sql = $json = false;
    unset($r_put['temp_id']);
    switch ($r_resource_cmd) {
    case '/users/?/activation': //users activation
        $qry_val_arr = array(
            $r_put['id'],
            'false'
        );
        $user = executeQuery('SELECT * FROM users WHERE id = $1 AND is_email_confirmed = $2', $qry_val_arr);
        if ($user && (md5($user['username']) == $r_put['hash'])) {
            $qry_val_arr = array(
                'true',
                'true',
                $r_put['id']
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
        break;

    case '/users/?': //users
        $table_name = 'users';
        $id = $r_resource_vars['users'];
        $comment = '##USER_NAME## updated the profile.';
        $activity_type = 'update_profile';
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
        }
        $foreign_ids['user_id'] = $authUser['id'];
        break;

    case '/email_templates/?': //email template update
        $json = true;
        $table_name = 'email_templates';
        $id = $r_resource_vars['email_templates'];
        $response['success'] = 'Email Template has been updated successfully.';
        break;

    case '/oauth/clients/?':
        $json = true;
        $table_name = 'oauth_clients';
        $id = $r_resource_vars['clients'];
        $response['success'] = 'Client has been updated successfully.';
        break;

    case '/boards_users/?':
        $json = true;
        $table_name = 'boards_users';
        $id = $r_resource_vars['boards_users'];
        $qry_val_arr = array(
            $r_resource_vars['boards_users']
        );
        executeQuery('SELECT id FROM ' . $table_name . ' WHERE id =  $1', $qry_val_arr);
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
        $foreign_ids['board_id'] = $r_resource_vars['boards'];
        if (isset($r_put['default_email_list_id']) || isset($r_put['is_default_email_position_as_bottom'])) {
            $comment = '';
        } else if (isset($r_put['board_visibility'])) {
            $comment = '##USER_NAME## changed visibility to ' . $board_visibility[$r_put['board_visibility']];
            $activity_type = 'change_visibility';
        } else if (!empty($r_put['is_closed'])) {
            $comment = '##USER_NAME## closed ##BOARD_NAME## board.';
            $activity_type = 'reopen_board';
        } else if (isset($r_put['is_closed'])) {
            $comment = '##USER_NAME## reopened ##BOARD_NAME## board.';
            $activity_type = 'reopen_board';
        } else if (isset($r_put['name'])) {
            $comment = '##USER_NAME## renamed ##BOARD_NAME## board.';
            $activity_type = 'edit_board';
        } else if (isset($r_put['background_picture_url']) || isset($r_put['background_pattern_url']) || isset($r_put['background_color'])) {
            if (empty($previous_value['background_picture_url']) && empty($previous_value['background_pattern_url']) && empty($previous_value['background_color'])) {
                $comment = '##USER_NAME## added background to board "' . $previous_value['name'] . '"';
                $activity_type = 'add_background';
            } else {
                $comment = '##USER_NAME## changed backgound to board "' . $previous_value['name'] . '"';
                $activity_type = 'change_background';
            }
        }
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
        break;

    case '/boards/?/lists/?': //lists update
        $json = true;
        $table_name = 'lists';
        $id = $r_resource_vars['lists'];
        if (isset($r_put['position']) || isset($r_put['is_archived'])) {
            $qry_val_arr = array(
                $r_resource_vars['lists']
            );
            $s_sql = 'SELECT name, board_id, position FROM ' . $table_name . ' WHERE id = $1';
            $s_result = pg_query_params($db_lnk, $s_sql, $qry_val_arr);
            $previous_value = pg_fetch_assoc($s_result);
        }
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
            pg_query_params($db_lnk, 'UPDATE card_attachments SET board_id = $1 WHERE list_id = $2', $qry_val_arr);
        }
        if (isset($r_put['position'])) {
            $comment = '##USER_NAME## changed list ' . $previous_value['name'] . ' position.';
            $activity_type = 'change_list_position';
        } else if (isset($previous_value) && isset($r_put['is_archived'])) {
            $id = $r_resource_vars['lists'];
            $foreign_ids['board_id'] = $r_resource_vars['boards'];
            $foreign_ids['list_id'] = $r_resource_vars['lists'];
            $comment = '##USER_NAME## archived ##LIST_NAME##';
            $activity_type = 'archive_list';
        } else {
            $id = $r_resource_vars['lists'];
            $comment = '##USER_NAME## renamed this list.';
            $activity_type = 'edit_list';
        }
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
        break;

    case '/boards/?/lists/?/cards/?': //cards update
        $table_name = 'cards';
        $id = $r_resource_vars['cards'];
        $foreign_ids['board_id'] = $r_resource_vars['boards'];
        $foreign_ids['list_id'] = $r_resource_vars['lists'];
        $foreign_ids['card_id'] = $r_resource_vars['cards'];
        $activity_type = 'edit_card';
        $qry_val_arr = array(
            $r_resource_vars['cards']
        );
        $s_result = pg_query_params($db_lnk, 'SELECT name, board_id, list_id, position, description, due_date FROM ' . $table_name . ' WHERE id = $1', $qry_val_arr);
        $previous_value = pg_fetch_assoc($s_result);
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
            }
            $qry_val_arr = array(
                $current_list_id
            );
            $current_list_name = executeQuery('SELECT name FROM lists WHERE id =  $1', $qry_val_arr);
            $comment = '##USER_NAME## moved the card ##CARD_LINK## to ' . $current_list_name['name'];
            $activity_type = 'change_card_position';
            if (!empty($r_put['list_id'])) {
                $foreign_ids['list_id'] = $r_resource_vars['lists'];
                $activity_type = 'move_card';
            }
        }
        if (isset($previous_value) && isset($r_put['is_archived'])) {
            if ($r_put['is_archived']) {
                $comment = '##USER_NAME## archived ' . $previous_value['name'];
            } else {
                $comment = '##USER_NAME## send back ' . $previous_value['name'] . ' to board';
            }
            $foreign_ids['board_id'] = $r_resource_vars['boards'];
            $foreign_ids['list_id'] = $r_resource_vars['lists'];
            $activity_type = 'archived_card';
        }
        if (isset($r_put['due_date']) && $r_put['due_date'] != 'NULL') {
            if (isset($previous_value['due_date']) && ($previous_value['due_date'] != 'null' && $previous_value['due_date'] != '')) {
                $comment = 'Due date was updated to this card ##CARD_LINK##';
                $activity_type = 'edit_card_duedate';
            } else {
                $comment = '##USER_NAME## set due date to this card ##CARD_LINK##';
                $activity_type = 'add_card_duedate';
            }
        } else if (isset($r_put['due_date'])) {
            $comment = 'Due date was removed to this card ##CARD_LINK##';
            $activity_type = 'delete_card_duedate';
        }
        if (isset($previous_value['board_id']) && isset($r_put['board_id']) && $r_put['board_id'] != $previous_value['board_id']) {
            $comment = '##USER_NAME## moved the card ##CARD_LINK## to different board.';
        }
        if (isset($previous_value['name']) && isset($r_put['name']) && $r_put['name'] != $previous_value['name']) {
            $comment = '##USER_NAME## renamed ##CARD_LINK##';
        }
        if (!isset($previous_value['description']) && isset($r_put['description'])) {
            $comment = '##USER_NAME## added card description in ##CARD_LINK## - ##DESCRIPTION##';
            $activity_type = 'add_card_desc';
        } else if (isset($previous_value) && isset($r_put['description']) && $r_put['description'] != $previous_value['description']) {
            if (empty($r_put['description'])) {
                $comment = '##USER_NAME## removed description from ##CARD_LINK##';
            } else {
                $comment = '##USER_NAME## updated description on ##CARD_LINK## - ##DESCRIPTION##';
            }
            $activity_type = 'edit_card_desc';
        }
        if (isset($previous_value['list_id']) && isset($r_put['list_id']) && $r_put['list_id'] != $previous_value['list_id']) {
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
            $comment = '##USER_NAME## moved this card ##CARD_LINK## from ' . $previous_list_value['name'] . ' list to ' . $list_value['name'] . '.';
        }
        unset($r_put['start']);
        break;

    case '/boards/?/lists/?/cards/?/comments/?': // comment update
        $table_name = 'activities';
        $id = $r_resource_vars['comments'];
        $foreign_ids['board_id'] = $r_resource_vars['boards'];
        $foreign_ids['list_id'] = $r_resource_vars['lists'];
        $foreign_ids['card_id'] = $r_resource_vars['cards'];
        $comment = '##USER_NAME## updated comment to this card ##CARD_LINK##';
        $activity_type = 'update_card_comment';
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
            $comment.= ' position';
        }
        $activity_type = 'update_card_checklist';
        break;

    case '/boards/?/lists/?/cards/?/checklists/?/items/?':
        $table_name = 'checklist_items';
        $id = $r_resource_vars['items'];
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
            $comment = '##USER_NAME## updated ##CHECKLIST_ITEM_NAME## as completed on card ##CARD_LINK##';
        } else if (isset($r_put['position'])) {
            $comment = '##USER_NAME## moved checklist item on card ##CARD_LINK##';
            if (isset($r_put['checklist_id']) && $r_put['checklist_id'] != $prev_value['checklist_id']) {
                $activity_type = 'moved_card_checklist_item';
            }
        } else if (isset($r_put['is_completed']) && $r_put['is_completed'] == 'false') {
            $comment = '##USER_NAME## updated ##CHECKLIST_ITEM_NAME## as incomplete on card ##CARD_LINK##';
        } else {
            $comment = '##USER_NAME## updated item name as ##CHECKLIST_ITEM_NAME## in card ##CARD_LINK##';
        }
        break;

    case '/activities/undo/?':
        $qry_val_arr = array(
            $r_resource_vars['undo']
        );
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
            } else if ($activity['type'] == 'update_card_comment') {
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
                $activity_type = 'update_card_comment';
                $response['undo']['update_card_comment'] = $id;
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
        break;

    case '/boards/?/board_subscribers/?': //boards subscribers update
        $json = true;
        $table_name = 'board_subscribers';
        $id = $r_resource_vars['board_subscribers'];
        $response['success'] = 'Updated successfully.';
        $response['id'] = $id;
        break;

    case '/boards/?/lists/?/list_subscribers/?': //lists update
        $json = true;
        $table_name = 'list_subscribers';
        $id = $r_resource_vars['list_subscribers'];
        break;

    case '/organizations/?':
        $json = true;
        $table_name = 'organizations';
        $id = $r_resource_vars['organizations'];
        $foreign_ids['organization_id'] = $r_resource_vars['organizations'];
        if (isset($r_put['logo_url']) && ($r_put['logo_url'] == 'null' || $r_put['logo_url'] == 'NULL')) {
            foreach ($thumbsizes['Organization'] as $key => $value) {
                $mediadir = APP_PATH . '/client/img/' . $key . '/Organization/' . $id;
                $list = glob($mediadir . '.*');
                if (file_exists($list[0])) {
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
        break;

    case '/organizations_users/?':
        $json = true;
        $table_name = 'organizations_users';
        $id = $r_resource_vars['organizations_users'];
        $qry_val_arr = array(
            $r_resource_vars['organizations_users']
        );
        executeQuery('SELECT id FROM ' . $table_name . ' WHERE id =  $1', $qry_val_arr);
        break;

    case '/webhooks/?':
        $json = true;
        $table_name = 'webhooks';
        $id = $r_resource_vars['webhooks'];
        break;

    case '/roles/?':
        $json = true;
        $table_name = 'roles';
        $id = $r_resource_vars['roles'];
        break;

    case '/board_user_roles/?':
        $json = true;
        $table_name = 'board_user_roles';
        $id = $r_resource_vars['board_user_roles'];
        break;

    case '/organization_user_roles/?':
        $json = true;
        $table_name = 'organization_user_roles';
        $id = $r_resource_vars['organization_user_roles'];
        break;

    default:
        header($_SERVER['SERVER_PROTOCOL'] . ' 501 Not Implemented', true, 501);
        break;
    }
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
            if ($activity_type != 'reopen_board' && $activity_type != 'moved_list_card' && $activity_type != 'moved_card_checklist_item' && $activity_type != 'delete_organization_attachment' && $activity_type != 'move_card') {
                $qry_va_arr = array(
                    $id
                );
                $revisions['old_value'] = executeQuery('SELECT ' . $sfields . ' FROM ' . $table_name . ' WHERE id =  $1', $qry_va_arr);
                if (!empty($r_put['position'])) {
                    unset($r_put['position']);
                }
                if (!empty($r_put['id'])) {
                    unset($r_put['id']);
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
                executeQuery('SELECT username FROM users WHERE id =' . $r_resource_vars['users']);
                // Todo handle with jaxl for ban_account
                
            }
        }
        if ($r_resource_cmd == '/boards_users/?') {
            if (JABBER_HOST) {
                $affiliation = ($r_put['board_user_role_id'] == 1) ? 'admin' : 'member';
                $xmpp_user = getXmppUser();
                $xmpp = new xmpp($xmpp_user);
                $xmpp->grantMember('board-' . $r_put['board_id'], $r_put['username'], $affiliation);
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
    if (!empty($sql) && !empty($json)) {
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
    } else {
        echo json_encode($response);
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
    global $r_debug, $db_lnk, $authUser, $_server_domain_url;
    $sql = false;
    $pg_params = $diff = $response = $foreign_ids = $foreign_id = $revisions_del = array();
    $activity_type = '';
    switch ($r_resource_cmd) {
    case '/users/?': // delete users
        $qry_val_arr = array(
            $r_resource_vars['users']
        );
        $s_result = pg_query_params($db_lnk, 'SELECT username FROM users WHERE id = $1', $qry_val_arr);
        $username = pg_fetch_assoc($s_result);
        $foreign_id['user_id'] = $r_resource_vars['users'];
        $comment = '##USER_NAME## deleted "' . $username['username'] . '"';
        $response['activity'] = insertActivity($authUser['id'], $comment, 'delete_user', $foreign_id);
        $sql = 'DELETE FROM users WHERE id= $1';
        array_push($pg_params, $r_resource_vars['users']);
        if (JABBER_HOST) {
            $xmpp_user = getXmppUser();
            $xmpp = new xmpp($xmpp_user);
            $xmpp->deleteUser('<iq from="' . $authUser['username'] . '@' . JABBER_HOST . '" id="delete-user-2" to="' . JABBER_HOST . '" type="set" xml:lang="en"><command xmlns="http://jabber.org/protocol/commands" node="http://jabber.org/protocol/admin#delete-user"><x xmlns="jabber:x:data" type="submit"><field type="hidden" var="FORM_TYPE"><value>http://jabber.org/protocol/admin</value></field><field var="accountjids"><value>' . $username['username'] . '@' . JABBER_HOST . '</value></field></x></command></iq>');
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
        }
        array_push($pg_params, $r_resource_vars['boards_users']);
        if (JABBER_HOST) {
            $xmpp_user = getXmppUser();
            $xmpp = new xmpp($xmpp_user);
            $xmpp->revokeMember('board-' . $previous_value['board_id'], $previous_value['username']);
        }
        break;

    case '/boards/?/lists/?': // delete lists
        $qry_val_arr = array(
            $r_resource_vars['lists']
        );
        $s_result = pg_query_params($db_lnk, 'SELECT name, board_id, position FROM lists WHERE id = $1', $qry_val_arr);
        $previous_value = pg_fetch_assoc($s_result);
        $foreign_id['board_id'] = $r_resource_vars['boards'];
        $foreign_id['list_id'] = $r_resource_vars['lists'];
        $comment = '##USER_NAME## deleted "' . $previous_value['name'] . '"';
        $response['activity'] = insertActivity($authUser['id'], $comment, 'delete_list', $foreign_id);
        $sql = 'DELETE FROM lists WHERE id= $1';
        array_push($pg_params, $r_resource_vars['lists']);
        break;

    case '/boards/?/lists': // delete Archived lists
        $sql = 'DELETE FROM lists WHERE board_id = $1 AND is_archived = true';
        array_push($pg_params, $r_resource_vars['boards']);
        break;

    case '/boards/?/cards': // delete Archived cards
        $sql = 'DELETE FROM cards WHERE board_id = $1 AND is_archived = true';
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
        break;

    case '/boards/?/lists/?/cards/?/card_voters/?': // delete card voters
        $sql = 'DELETE FROM card_voters WHERE id = $1';
        array_push($pg_params, $r_resource_vars['card_voters']);
        $foreign_ids['board_id'] = $r_resource_vars['boards'];
        $foreign_ids['list_id'] = $r_resource_vars['lists'];
        $foreign_ids['card_id'] = $r_resource_vars['cards'];
        $comment = '##USER_NAME## unvoted this card ##CARD_LINK##';
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
            $revisions_del['old_value'] = $revision['new_value']['comment'];
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
        break;

    case '/boards/?/lists/?/cards/?/attachments/?': //delete card attachment
        $sql = 'DELETE FROM card_attachments WHERE id = $1';
        array_push($pg_params, $r_resource_vars['attachments']);
        $foreign_ids['board_id'] = $r_resource_vars['boards'];
        $foreign_ids['list_id'] = $r_resource_vars['lists'];
        $foreign_ids['card_id'] = $r_resource_vars['cards'];
        $comment = '##USER_NAME## deleted attachment from card ##CARD_LINK##';
        $response['activity'] = insertActivity($authUser['id'], $comment, 'delete_card_attachment', $foreign_ids, null, $r_resource_vars['attachments']);
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
        $comment = '##USER_NAME## deleted checklist ' . $checklist['name'] . ' from card ##CARD_LINK##';
        $response['activity'] = insertActivity($authUser['id'], $comment, 'delete_checklist', $foreign_ids, null, $r_resource_vars['checklists']);
        $sql = 'DELETE FROM checklists WHERE id = $1';
        array_push($pg_params, $r_resource_vars['checklists']);
        break;

    case '/boards/?/lists/?/cards/?/checklists/?/items/?': // delete items
        $foreign_ids['board_id'] = $r_resource_vars['boards'];
        $foreign_ids['list_id'] = $r_resource_vars['lists'];
        $foreign_ids['card_id'] = $r_resource_vars['cards'];
        $comment = '##USER_NAME## deleted checklist ##CHECKLIST_NAME## item from card ##CARD_LINK##';
        $response['activity'] = insertActivity($authUser['id'], $comment, 'delete_checklist_item', $foreign_ids, null, $r_resource_vars['items']);
        $sql = 'DELETE FROM checklist_items WHERE id = $1';
        array_push($pg_params, $r_resource_vars['items']);
        break;

    case '/boards/?/lists/?/cards/?/cards_users/?': // delete  card_user
        $foreign_ids['board_id'] = $r_resource_vars['boards'];
        $foreign_ids['list_id'] = $r_resource_vars['lists'];
        $foreign_ids['card_id'] = $r_resource_vars['cards'];
        $comment = '##USER_NAME## deleted member from card ##CARD_LINK##';
        $response['activity'] = insertActivity($authUser['id'], $comment, 'delete_card_users', $foreign_ids, null, $r_resource_vars['cards_users']);
        $sql = 'DELETE FROM cards_users WHERE id = $1';
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

    default:
        header($_SERVER['SERVER_PROTOCOL'] . ' 501 Not Implemented', true, 501);
        break;
    }
    if (!empty($sql)) {
        $result = pg_query_params($db_lnk, $sql, $pg_params);
        $response['error'] = array(
            'code' => (!$result) ? 1 : 0
        );
    }
    echo json_encode($response);
}
$exception_url = array(
    '/users/forgotpassword',
    '/users/register',
    '/users/login',
    '/users/?/activation',
    '/settings',
    '/boards/?',
    '/oauth/token'
);
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
    $scope_exception_url = array(
        '/users/login',
        '/users/register',
        '/oauth/token',
        '/users/?/activation',
        '/users/forgotpassword'
    );
    if ($r_resource_cmd != '/users/login') {
        $token_exception_url = array(
            '/settings',
            '/oauth/token'
        );
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
    if ($r_resource_cmd == '/users/logout' || checkAclLinks($_SERVER['REQUEST_METHOD'], $r_resource_cmd, $r_resource_vars, $post_data)) {
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
