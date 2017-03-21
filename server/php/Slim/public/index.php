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
 * @copyright  2014-2017 Restya
 * @license    http://restya.com/ Restya Licence
 * @link       http://restya.com/
 * @todo       Fix code duplication & make it really lightweight
 * @since      2013-08-23
 */
use Illuminate\Database\Capsule\Manager as DB;
require_once '../../bootstrap.php';
/**
 * GET oauthGet
 * Summary: Get site token
 * Notes: oauth
 * Output-Formats: [application/json]
 */
$app->GET('/api/v1/oauth.json', function ($request, $response, $args)
{
    global $token_exception_url, $db_lnk;
    if (!empty($_GET['refresh_token'])) {
        $oauth_clientid = OAUTH_CLIENTID;
        $oauth_client_secret = OAUTH_CLIENT_SECRET;
        $conditions = array(
            $_GET['refresh_token']
        );
        $sth = $this->db->prepare("SELECT user_id as username, expires, scope, client_id FROM oauth_refresh_tokens WHERE refresh_token =?");
        $sth->execute($conditions);
        $responses = $sth->fetch(PDO::FETCH_ASSOC);
        if ($responses['client_id'] == 6664115227792148 && OAUTH_CLIENTID == 7742632501382313) {
            $oauth_clientid = 6664115227792148;
            $oauth_client_secret = 'hw3wpe2cfsxxygogwue47cwnf7';
        }
        $post_val = array(
            'grant_type' => 'refresh_token',
            'refresh_token' => $_GET['refresh_token'],
            'client_id' => $oauth_clientid,
            'client_secret' => $oauth_client_secret
        );
        $responses = getToken($post_val);
    } else if (!in_array('/oauth', $token_exception_url)) {
        $post_val = array(
            'grant_type' => 'client_credentials',
            'client_id' => OAUTH_CLIENTID,
            'client_secret' => OAUTH_CLIENT_SECRET
        );
        $responses = getToken($post_val);
        $qry_val_arr = array(
            3
        );
        $sth = $this->db->prepare("SELECT * FROM role_links_listing WHERE id = 3");
        $sth->execute();
        $role_links = $sth->fetch(PDO::FETCH_ASSOC);
        $responses = array_merge($responses, $role_links);
        $files = glob(APP_PATH . '/client/locales/*/translation.json', GLOB_BRACE);
        $lang_iso2_codes = array();
        foreach ($files as $file) {
            $folder = explode('/', $file);
            $folder_iso2_code = $folder[count($folder) - 2];
            array_push($lang_iso2_codes, $folder_iso2_code);
        }
        $qry_val_arr = '{' . implode($lang_iso2_codes, ',') . '}';
        $sth = $this->db->prepare("SELECT name, iso2 FROM languages WHERE iso2 = ANY (:an_array) ORDER BY name ASC");
        $sth->bindParam(':an_array', $qry_val_arr);
        $sth->execute();
        $results = $sth->fetchAll();
        foreach ($results as $result) {
            $languages[$result['iso2']] = $result['name'];
        }
        $responses['languages'] = json_encode($languages);
        $files = glob(APP_PATH . '/client/apps/*/app.json', GLOB_BRACE);
        if (!empty($files)) {
            foreach ($files as $file) {
                $content = file_get_contents($file);
                $data = json_decode($content, true);
                $folder = explode('/', $file);
                if ($data['enabled'] === true) {
                    foreach ($data as $key => $value) {
                        if ($key != 'settings') {
                            $responses['apps'][$folder[count($folder) - 2]][$key] = $value;
                        }
                    }
                }
            }
        }
        $responses['apps'] = !empty($results['apps']) ? json_encode($results['apps']) : '';
    }
    echo json_encode($responses, JSON_NUMERIC_CHECK);
});
$app->GET('/api/v1/users/me.json', function ($request, $response, $args)
{
    global $authUser, $db;
    $role_val_arr = array(
        $authUser['role_id']
    );
    $sth = $this->db->prepare("SELECT * FROM role_links_listing WHERE id = ?");
    $sth->execute($role_val_arr);
    $role_links = $sth->fetch(PDO::FETCH_ASSOC);
    $val_arr = array(
        $authUser['id']
    );
    $sth = $this->db->prepare("SELECT * FROM users_listing WHERE id = ?");
    $sth->execute($val_arr);
    $user = $sth->fetch(PDO::FETCH_ASSOC);
    $response = array_merge($role_links, $user);
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
    $notify_count = executeQuery('SELECT max(id) AS last_activity_id, count(a.*) AS notify_count FROM activities a  WHERE a.id > ? AND board_id = ANY (?) ', $notify_val_arr);
    $notify_count['last_activity_id'] = (!empty($notify_count['last_activity_id'])) ? $notify_count['last_activity_id'] : $user['last_activity_id'];
    $user = array_merge($user, $notify_count);
    unset($user['user']['password']);
    $results['user'] = $user;
    $results['user']['organizations'] = json_decode($user['organizations'], true);
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->GET('/api/v1/users.json', function ($request, $response, $args)
{
    $pg_params = $data = array();
    global $authUser;
    $r_resource_filters = $request->getQueryParams();
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
        } else if (is_plugin_enabled('r_ldap_login') && $r_resource_filters['filter'] == 'ldap') {
            $filter_condition.= 'is_ldap = 1';
        } else {
            $filter_condition.= 'role_id = ' . $r_resource_filters['filter'];
        }
    } else if (!empty($r_resource_filters['search'])) {
        $filter_condition = "WHERE LOWER(full_name) LIKE '%" . strtolower($r_resource_filters['search']) . "%' OR LOWER(email) LIKE '%" . strtolower($r_resource_filters['search']) . "%' ";
    }
    $c_sql = 'SELECT COUNT(*) FROM users_listing ul ';
    if (!empty($r_resource_filters['search'])) {
        $c_sql = 'SELECT COUNT(*) FROM users_listing ul ' . $filter_condition;
    }
    if (!empty($c_sql)) {
        $paging_data = paginate_data($c_sql, $pg_params, $r_resource_filters);
        $_metadata = $paging_data['_metadata'];
    }
    $sql = 'SELECT * FROM users_listing ul ' . $filter_condition . ' ORDER BY ' . $order_by . ' ' . $direction . ' limit ' . $_metadata['limit'] . ' offset ' . $_metadata['offset'];
    $filter_count = array();
    $val_array = array(
        true
    );
    $active_count = executeQuery('SELECT count(*) FROM users WHERE is_active = ?', $val_array);
    $filter_count['active'] = $active_count['count'];
    $val_array = array(
        0
    );
    $inactive_count = executeQuery('SELECT count(*) FROM users WHERE is_active = ?', $val_array);
    $filter_count['inactive'] = $inactive_count['count'];
    $val_array = array(
        true
    );
    if (is_plugin_enabled('r_ldap_login')) {
        $ldap_count = executeQuery('SELECT count(*) FROM users WHERE is_ldap = ?', $val_array);
        $filter_count['ldap'] = $ldap_count['count'];
    }
    $val_array = array(
        3
    );
    $sth = $this->db->prepare("SELECT * FROM roles WHERE id != ?");
    $sth->execute($val_array);
    $s_result = $sth->fetchAll();
    $roles = array();
    $i = 0;
    foreach ($s_result as $row) {
        $roles[$i]['id'] = $row['id'];
        $roles[$i]['name'] = ucfirst($row['name']);
        $val_array = array(
            $row['id']
        );
        $user_count = executeQuery('SELECT count(*) FROM users WHERE role_id = ?', $val_array);
        $roles[$i]['count'] = $user_count['count'];
        $i++;
    }
    if (!empty($sql)) {
        $sth = $this->db->prepare($sql);
        $sth->execute($pg_params);
        $result = $sth->fetchAll();
        if ($result) {
            $board_lists = array();
            foreach ($result as $row) {
                $data['data'][] = $row;
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
            echo json_encode($data, JSON_NUMERIC_CHECK);
        } else {
            echo json_encode($data, JSON_NUMERIC_CHECK);
        }
    } else {
        echo json_encode($results, JSON_NUMERIC_CHECK);
    }
});
$app->GET('/api/v1/users/logout.json', function ($request, $response, $args)
{
    $results['user'] = array();
    $conditions = array(
        $_GET['token']
    );
    $sth = $this->db->prepare('DELETE FROM oauth_access_tokens WHERE access_token= ?');
    $sth->execute($conditions);
    $authUser = array();
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->GET('/api/v1/users/{userId}/activities.json', function ($request, $response, $args)
{
    global $authUser, $db_lnk, $r_debug;
    $r_resource_filters = $request->getQueryParams();
    $r_resource_vars['users'] = $request->getAttribute('userId');
    $pg_params = $data = array();
    $condition = '';
    if (!empty($authUser) && $authUser['role_id'] == 1 && $authUser['id'] == $r_resource_vars['users'] && empty($r_resource_filters['board_id'])) {
        if (!empty($r_resource_filters['type']) && $r_resource_filters['type'] == 'profile') {
            $condition = (!empty($r_resource_filters['last_activity_id'])) ? ' WHERE al.id < ?' : '';
        } else {
            $condition = (!empty($r_resource_filters['last_activity_id'])) ? ' WHERE al.id > ?' : '';
        }
        $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM activities_listing al ' . $condition . ' ORDER BY id DESC LIMIT ' . PAGING_COUNT . ') as d';
        $c_sql = 'SELECT COUNT(*) FROM activities_listing al' . $condition;
    } else {
        if (!empty($authUser) && $authUser['id'] != $r_resource_vars['users']) {
            $val_array = array(
                $authUser['id']
            );
            $logged_user = executeQuery('SELECT boards_users FROM users_listing WHERE id = ?', $val_array);
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
        $user = executeQuery('SELECT boards_users FROM users_listing WHERE id = ?', $val_array);
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
        $org_users = executeQueryAll('SELECT organization_id FROM organizations_users WHERE user_id = ?', $val_array);
        $org_ids = array();
        foreach ($org_users as $row) {
            $org_ids[] = $row['organization_id'];
        }
        if (!empty($r_resource_filters['type']) && $r_resource_filters['type'] == 'profile') {
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
        } else if (!empty($r_resource_filters['organization_id'])) {
            if (!empty($r_resource_filters['last_activity_id'])) {
                $condition = ' AND al.id > $4';
            }
            $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM activities_listing al WHERE ((user_id = ? AND board_id IN (SELECT id FROM boards WHERE organization_id = ?)) OR organization_id  = ANY ( ? )) ' . $condition . ' ORDER BY id DESC LIMIT ' . PAGING_COUNT . ') as d';
            $c_sql = 'SELECT COUNT(*) FROM activities_listing al WHERE ((user_id = ? AND board_id IN (SELECT id FROM boards WHERE organization_id = ?)) OR organization_id  = ANY ( ? )) ' . $condition;
            array_push($pg_params, $r_resource_vars['users'], $r_resource_filters['organization_id'], '{' . $r_resource_filters['organization_id'] . '}');
        } else if (!empty($r_resource_filters['type']) && $r_resource_filters['type'] = 'all') {
            if (!empty($r_resource_filters['last_activity_id'])) {
                $condition = ' AND al.id > ?';
            }
            $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM activities_listing al WHERE (board_id = ANY ( ? ) OR organization_id  = ANY ( ? ))' . $condition . ' ORDER BY id DESC LIMIT ' . PAGING_COUNT . ') as d';
            $c_sql = 'SELECT COUNT(*) FROM activities_listing al WHERE (board_id = ANY ( ? ) OR organization_id  = ANY ( ? ))' . $condition;
            array_push($pg_params, '{' . implode(',', $board_ids) . '}', '{' . implode(',', $org_ids) . '}');
        } else if (!empty($r_resource_filters['board_id']) && $r_resource_filters['board_id']) {
            if (!empty($r_resource_filters['last_activity_id'])) {
                $condition = ' AND al.id > ?';
            }
            $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM activities_listing al WHERE user_id = ? AND board_id = ?' . $condition . ' ORDER BY freshness_ts DESC, materialized_path ASC LIMIT ' . PAGING_COUNT . ') as d';
            $c_sql = 'SELECT COUNT(*) FROM activities_listing al WHERE user_id = ? AND board_id = ?' . $condition;
            array_push($pg_params, $r_resource_vars['users'], $r_resource_filters['board_id']);
        } else {
            if (!empty($r_resource_filters['last_activity_id'])) {
                $condition = ' AND al.id > ?';
            }
            $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM activities_listing al WHERE ( board_id = ANY( ? ) OR organization_id  = ANY ( ? ) )' . $condition . ' ORDER BY id DESC LIMIT ' . PAGING_COUNT . ') as d';
            $c_sql = 'SELECT COUNT(*) FROM activities_listing al WHERE ( board_id = ANY( ? ) OR organization_id  = ANY ( ? ) )' . $condition;
            array_push($pg_params, '{' . implode(',', $board_ids) . '}', '{' . implode(',', $org_ids) . '}');
        }
    }
    if (!empty($r_resource_filters['last_activity_id'])) {
        array_push($pg_params, $r_resource_filters['last_activity_id']);
    }
    if (!empty($c_sql)) {
        $paging_data = paginate_data($c_sql, $pg_params, $r_resource_filters);
        $_metadata = $paging_data['_metadata'];
    }
    if (!empty($sql)) {
        if ($result = executeQueryAll($sql, $pg_params)) {
            $data = array();
            $board_lists = array();
            foreach ($result as $row) {
                $obj = json_decode($row['row_to_json'], true);
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
                $obj = getActivitiesObj($obj);
                if (!empty($_metadata)) {
                    $data['data'][] = $obj;
                } else {
                    $data[] = $obj;
                }
            }
            if (!empty($_metadata)) {
                $data['_metadata'] = $_metadata;
            }
            echo json_encode($data, JSON_NUMERIC_CHECK);
        } else {
            if (!empty($_metadata)) {
                $data['_metadata'] = $_metadata;
            }
            echo json_encode($data, JSON_NUMERIC_CHECK);
        }
    }
});
$app->GET('/api/v1/users/search.json', function ($request, $response, $args)
{
    $data = $pg_params = array();
    $r_resource_filters = $request->getQueryParams();
    if (!empty($r_resource_filters['organizations'])) {
        $sql = 'SELECT u.id, u.username, u.profile_picture_path,u.initials, u.full_name FROM users u LEFT JOIN organizations_users ou ON ou.user_id = u.id WHERE u.is_active = true AND u.is_email_confirmed = true AND ';
        $sql.= '(ou.organization_id != ? OR ou.user_id IS null) AND';
        array_push($pg_params, $r_resource_filters['organizations']);
    } else if (!empty($r_resource_filters['board_id'])) {
        $sql = 'SELECT u.id, u.username, u.profile_picture_path,u.initials, u.full_name FROM users u JOIN boards_users bu ON bu.user_id = u.id WHERE u.is_active = true AND u.is_email_confirmed = true AND ';
        $sql.= 'bu.board_id = ? AND';
        array_push($pg_params, $r_resource_filters['board_id']);
    } else if (!empty($r_resource_filters['filter'])) {
        $sql = 'SELECT u.id, u.username, u.profile_picture_path,u.initials, u.full_name FROM users u WHERE ';
    } else {
        $sql = 'SELECT u.id, u.username, u.profile_picture_path,u.initials, u.full_name FROM users u WHERE  u.is_active = true AND u.is_email_confirmed = true AND ';
    }
    if (empty($pg_params)) {
        $sql.= '(LOWER(u.username) LIKE LOWER(?) OR LOWER(u.email) LIKE LOWER(?)) ';
    } else {
        $sql.= '(LOWER(u.username) LIKE LOWER(?) OR LOWER(u.email) LIKE LOWER(?)) ';
    }
    array_push($pg_params, '%' . $r_resource_filters['q'] . '%', '%' . $r_resource_filters['q'] . '%');
    if (empty($r_resource_filters['q'])) {
        $sql = false;
        $response = array();
        $pg_params = array();
    }
    if (!empty($sql)) {
        if ($result = executeQueryAll($sql, $pg_params)) {
            $data = array();
            foreach ($result as $row) {
                $obj = $row;
                $data[] = $obj;
            }
            echo json_encode($data, JSON_NUMERIC_CHECK);
        } else {
            echo json_encode($data, JSON_NUMERIC_CHECK);
        }
    } else {
        echo json_encode($results, JSON_NUMERIC_CHECK);
    }
});
$app->GET('/api/v1/users/{userId}.json', function ($request, $response, $args)
{
    $pg_params = array(
        $request->getAttribute('userId')
    );
    $data = array();
    $sql = 'SELECT * FROM users ul WHERE id = ?';
    if (!empty($sql)) {
        if ($result = executeQueryAll($sql, $pg_params)) {
            $data = array();
            foreach ($result as $row) {
                $data = $row;
            }
            echo json_encode($data, JSON_NUMERIC_CHECK);
        } else {
            echo json_encode($data, JSON_NUMERIC_CHECK);
        }
    }
});
$app->GET('/api/v1/users/{userId}/boards.json', function ($request, $response, $args)
{
    global $authUser;
    $r_resource_filters = $request->getQueryParams();
    $pg_params = array();
    if (!empty($authUser)) {
        $val_array = array(
            $authUser['id']
        );
        $s_result = executeQueryAll('SELECT board_id FROM board_stars WHERE is_starred = true AND user_id = ?', $val_array);
        $results['starred_boards'] = array();
        foreach ($s_result as $row) {
            $results['starred_boards'][] = $row['board_id'];
        }
        $val_array = array(
            $authUser['id']
        );
        $s_result = executeQueryAll('SELECT o.id as organization_id, o.name as organization_name, bu.board_id FROM boards_users  bu LEFT JOIN boards b ON b.id = bu.board_id LEFT JOIN organizations o ON o.id = b.organization_id  WHERE bu.user_id = ?', $val_array);
        $results['user_boards'] = array();
        foreach ($s_result as $row) {
            $results['user_boards'][] = $row;
        }
        echo json_encode($results, JSON_NUMERIC_CHECK);
    }
});
$app->GET('/api/v1/users/{userId}/cards.json', function ($request, $response, $args)
{
    global $authUser;
    $r_resource_vars['users'] = $request->getAttribute('userId');
    $pg_params = $data = array();
    $logged_user_board_ids = array();
    if (!empty($authUser) && $authUser['id'] != $r_resource_vars['users']) {
        $val_array = array(
            $authUser['id']
        );
        $logged_user = executeQuery('SELECT boards_users FROM users_listing WHERE id = ?', $val_array);
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
    $sql = 'SELECT * FROM users_cards_listing ucl WHERE ' . $str . ' user_id = $' . $i . ' ORDER BY board_id ASC';
    array_push($pg_params, $r_resource_vars['users']);
    if (!empty($sql)) {
        if ($result = executeQueryAll($sql, $pg_params)) {
            $data = array();
            foreach ($result as $row) {
                $obj = $row;
                $data[] = $obj;
            }
            echo json_encode($data, JSON_NUMERIC_CHECK);
        } else {
            echo json_encode($data, JSON_NUMERIC_CHECK);
        }
    }
});
$app->GET('/api/v1/boards/search.json', function ($request, $response, $args)
{
    global $authUser;
    $r_resource_filters = $request->getQueryParams();
    $data = array();
    $sql = 'SELECT id, name, background_color FROM boards ul WHERE name ILIKE ? ORDER BY id DESC';
    array_push($pg_params, '%' . $r_resource_filters['q'] . '%');
    if ($result = executeQueryAll($sql, $pg_params)) {
        $data = array();
        foreach ($result as $row) {
            $obj = $row;
            $data = $obj;
        }
        echo json_encode($data, JSON_NUMERIC_CHECK);
    } else {
        echo json_encode($data, JSON_NUMERIC_CHECK);
    }
});
$app->GET('/api/v1/boards/list.json', function ($request, $response, $args)
{
    global $authUser;
    $r_resource_filters = $request->getQueryParams();
    $data = array();
    if (!empty($r_resource_filters['type']) && $r_resource_filters['type'] == 'simple') {
        $sql = 'SELECT * FROM simple_board_listing ul ';
        if (!empty($authUser) && $authUser['role_id'] != 1) {
            $val_array = array(
                $authUser['id']
            );
            $s_result = executeQueryAll('SELECT board_id FROM board_stars WHERE user_id = ?', $val_array);
            $results['starred_boards'] = array();
            foreach ($s_result as $row) {
                $results['starred_boards'][] = $row['board_id'];
            }
            $s_result = executeQueryAll('SELECT board_id FROM boards_users WHERE user_id = ?', $val_array);
            $results['user_boards'] = array();
            foreach ($s_result as $row) {
                $results['user_boards'][] = $row['board_id'];
            }
            $board_ids = array_merge($results['starred_boards'], $results['user_boards']);
            $ids = 0;
            if (!empty($board_ids)) {
                $board_ids = array_unique($board_ids);
                $ids = '{' . implode($board_ids, ',') . '}';
            }
            $sql.= 'WHERE ul.id =ANY(?)';
            array_push($pg_params, $ids);
        }
        $sql.= ' ORDER BY name ASC';
        if ($authUser['role_id'] != 1 && empty($board_ids)) {
            $sql = false;
        }
    } else {
        $sql = 'SELECT * FROM boards_listing ul ';
        if (!empty($authUser) && $authUser['role_id'] != 1) {
            $val_array = array(
                $authUser['id']
            );
            $s_result = executeQueryAll('SELECT board_id FROM board_subscribers WHERE user_id = ?', $val_array);
            $results['starred_boards'] = array();
            foreach ($s_result as $row) {
                $results['starred_boards'][] = $row['board_id'];
            }
            $s_result = executeQueryAll('SELECT board_id FROM boards_users WHERE user_id = ?', $val_array);
            $results['user_boards'] = array();
            foreach ($s_result as $row) {
                $results['user_boards'][] = $row['board_id'];
            }
            $board_ids = array_merge($results['starred_boards'], $results['user_boards']);
            $ids = 0;
            if (!empty($board_ids)) {
                $board_ids = array_unique($board_ids);
                $ids = '{' . implode($board_ids, ',') . '}';
            }
            $sql.= 'WHERE ul.id = ANY (?)';
            array_push($pg_params, $ids);
        }
        $sql.= ' ORDER BY name ASC ';
        if ($authUser['role_id'] != 1 && empty($board_ids)) {
            $sql = false;
        }
    }
    $c_sql = 'SELECT COUNT(*) FROM boards_listing bl';
    if (!empty($c_sql)) {
        $paging_data = paginate_data($c_sql, $pg_params, $r_resource_filters);
        $_metadata = $paging_data['_metadata'];
    }
    if (!empty($sql)) {
        if ($result = executeQueryAll($sql, $pg_params)) {
            $data = array();
            $board_lists = array();
            foreach ($result as $row) {
                $obj = $row;
                $obj = getActivitiesObj($obj);
                if (!empty($_metadata)) {
                    $data['data'][] = $obj;
                } else {
                    $data[] = $obj;
                }
            }
            if (!empty($_metadata)) {
                $data['_metadata'] = $_metadata;
            }
            echo json_encode($data, JSON_NUMERIC_CHECK);
        } else {
            echo json_encode($data, JSON_NUMERIC_CHECK);
        }
    }
});
$app->GET('/api/v1/boards.json', function ($request, $response, $args)
{
    global $authUser;
    $r_resource_filters = $request->getQueryParams();
    $filter_condition = '';
    $sort = 'id';
    $sort_by = 'DESC';
    $field = '*';
    $limit = PAGING_COUNT;
    $query_timeout = 0;
    $data = $pg_params = $conditions = array();
    if (!empty($r_resource_filters['type']) && $r_resource_filters['type'] == 'simple') {
        $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM simple_board_listing ul ';
        if (!empty($authUser) && $authUser['role_id'] != 1) {
            $val_array = array(
                $authUser['id']
            );
            $s_result = executeQueryAll('SELECT board_id FROM board_stars WHERE user_id = ?', $val_array);
            $results['starred_boards'] = array();
            foreach ($s_result as $row) {
                $results['starred_boards'][] = $row['board_id'];
            }
            $s_result = executeQueryAll('SELECT board_id FROM boards_users WHERE user_id = ?', $val_array);
            $results['user_boards'] = array();
            foreach ($s_result as $row) {
                $results['user_boards'][] = $row['board_id'];
            }
            $board_ids = array_merge($results['starred_boards'], $results['user_boards']);
            $ids = '{0}';
            if (!empty($board_ids)) {
                $board_ids = array_unique($board_ids);
                $ids = '{' . implode($board_ids, ',') . '}';
            }
            $sql.= 'WHERE ul.id =ANY(?)';
            array_push($pg_params, $ids);
        }
        $sql.= ' ORDER BY name ASC ) as d';
        if ($authUser['role_id'] != 1 && empty($board_ids)) {
            $sql = false;
        }
        $limit = 'all';
        if (!empty($pg_params)) {
            $c_sql = 'SELECT COUNT(*) FROM simple_board_listing ul WHERE ul.id =ANY(?)' . $filter_condition;
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
        $sql.= ' ORDER BY ' . $order_by . ' ' . $direction . ' ) as d';
    } else {
        $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM boards_listing ul ';
        if (!empty($authUser) && $authUser['role_id'] != 1) {
            $val_array = array(
                $authUser['id']
            );
            $s_result = executeQueryAll('SELECT board_id FROM board_subscribers WHERE user_id = ?', $val_array);
            $results['starred_boards'] = array();
            foreach ($s_result as $row) {
                $results['starred_boards'][] = $row['board_id'];
            }
            $s_result = executeQueryAll('SELECT board_id FROM boards_users WHERE user_id = ?', $val_array);
            $results['user_boards'] = array();
            foreach ($s_result as $row) {
                $results['user_boards'][] = $row['board_id'];
            }
            $board_ids = array_merge($results['starred_boards'], $results['user_boards']);
            $ids = '{0}';
            if (!empty($board_ids)) {
                $board_ids = array_unique($board_ids);
                $ids = '{' . implode($board_ids, ',') . '}';
            }
            $sql.= 'WHERE ul.id = ANY (?)';
            array_push($pg_params, $ids);
        }
        $sql.= ' ORDER BY name ASC ) as d';
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
    $closed_count = executeQuery('SELECT count(*) FROM boards WHERE is_closed = ?', $val_array);
    $filter_count['closed'] = $closed_count['count'];
    $val_array = array(
        0
    );
    $open_count = executeQuery('SELECT count(*) FROM boards WHERE is_closed = ?', $val_array);
    $filter_count['open'] = $open_count['count'];
    $val_array = array(
        0
    );
    $private_count = executeQuery('SELECT count(*) FROM boards WHERE board_visibility = ?', $val_array);
    $filter_count['private'] = $private_count['count'];
    $val_array = array(
        2
    );
    $public_count = executeQuery('SELECT count(*) FROM boards WHERE board_visibility = ?', $val_array);
    $filter_count['public'] = $public_count['count'];
    $val_array = array(
        1
    );
    $organization_count = executeQuery('SELECT count(*) FROM boards WHERE board_visibility = ?', $val_array);
    $filter_count['organization'] = $organization_count['count'];
    $board_user_roles_result = executeQueryAll('SELECT id, name FROM board_user_roles', array());
    $board_user_roles = array();
    foreach ($board_user_roles_result as $board_user) {
        $board_user_roles[] = $board_user;
    }
    if (!empty($c_sql)) {
        $paging_data = paginate_data($c_sql, $pg_params, $r_resource_filters);
        $_metadata = $paging_data['_metadata'];
    }
    if (!empty($sql)) {
        if ($result = executeQueryAll($sql, $pg_params)) {
            $data = array();
            $board_lists = array();
            foreach ($result as $row) {
                $obj = json_decode($row['row_to_json'], true);
                if ((!empty($r_resource_filters['type']) && $r_resource_filters['type'] == 'simple')) {
                    if (!empty($obj['lists'])) {
                        foreach ($obj['lists'] as $list) {
                            $board_lists[$list['id']] = $list;
                        }
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
            if (!empty($_metadata) && !empty($board_user_roles)) {
                $data['board_user_roles'] = $board_user_roles;
            }
            if (is_plugin_enabled('r_chart')) {
                require_once APP_PATH . DIRECTORY_SEPARATOR . 'server' . DIRECTORY_SEPARATOR . 'php' . DIRECTORY_SEPARATOR . 'plugins' . DIRECTORY_SEPARATOR . 'Chart' . DIRECTORY_SEPARATOR . 'Slim' . DIRECTORY_SEPARATOR . 'index.php';
                $passed_values = array();
                $passed_values['sort'] = $sort;
                $passed_values['field'] = $field;
                $passed_values['sort_by'] = $sort_by;
                $passed_values['query_timeout'] = $query_timeout;
                $passed_values['limit'] = $limit;
                $passed_values['conditions'] = $conditions;
                $passed_values['r_resource_filters'] = $r_resource_filters;
                $passed_values['authUser'] = $authUser;
                $passed_values['board_lists'] = $board_lists;
                $plugin_return = getChartData($passed_values);
                if (!empty($plugin_return)) {
                    foreach ($plugin_return as $return_plugin_key => $return_plugin_values) {
                        $ {
                            $return_plugin_key
                        } = $return_plugin_values;
                    }
                }
                echo json_encode(array_merge($data, $response) , JSON_NUMERIC_CHECK);
            } else {
                echo json_encode($data, JSON_NUMERIC_CHECK);
            }
        } else {
            echo json_encode($data, JSON_NUMERIC_CHECK);
        }
    } else {
        echo json_encode($results, JSON_NUMERIC_CHECK);
    }
});
$app->GET('/api/v1/settings/{settingId}.json', function ($request, $response, $args)
{
    $r_resource_vars['settings'] = $request->getAttribute('settingId');
    $sql = false;
    $s_sql = 'SELECT id, name, parent_id FROM setting_categories WHERE parent_id IS null ORDER BY "order" ASC';
    $s_result = executeQueryAll($s_sql, array());
    foreach ($s_result as $row) {
        if ($row['id'] == $r_resource_vars['settings'] || $row['parent_id'] == $r_resource_vars['settings']) {
            $s_sql = 'SELECT s.*, sc.name as category_name FROM settings s LEFT JOIN setting_categories sc ON sc.id = s.setting_category_id  WHERE  setting_category_id = ? OR setting_category_parent_id = ? ORDER BY "order" ASC';
            $s_val = array(
                $row['id'],
                $row['id']
            );
            $ss_result = executeQueryAll($s_sql, $s_val);
            foreach ($ss_result as $srow) {
                $row['settings'][] = $srow;
            }
        }
        $results[] = $row;
    }
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->GET('/api/v1/email_templates/{emailTemplateId}.json', function ($request, $response, $args)
{
    $r_resource_vars['email_templates'] = $request->getAttribute('emailTemplateId');
    $response = array();
    $sql = false;
    $s_sql = 'SELECT id, display_name FROM email_templates ORDER BY id ASC';
    $s_result = executeQueryAll($s_sql, array());
    foreach ($s_result as $row) {
        if ($row['id'] == $r_resource_vars['email_templates']) {
            $s_sql = 'SELECT from_email, reply_to_email, name, description, subject, email_text_content, email_variables, display_name FROM email_templates WHERE  id = ?';
            $s_val = array(
                $row['id']
            );
            $ss_result = executeQueryAll($s_sql, $s_val);
            foreach ($ss_result as $srow) {
                $row['template'] = $srow;
            }
        }
        $results[] = $row;
    }
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->GET('/api/v1/boards/{boardId}.json', function ($request, $response, $args)
{
    global $authUser;
    $board = $data = $pg_params = array();
    $r_resource_vars['boards'] = $request->getAttribute('boardId');
    $s_sql = 'SELECT id FROM boards WHERE id =  ?';
    $board[] = $r_resource_vars['boards'];
    $check_board = executeQuery($s_sql, $board);
    if (!empty($check_board)) {
        $s_sql = 'SELECT b.board_visibility, bu.user_id FROM boards AS b LEFT JOIN boards_users AS bu ON bu.board_id = b.id WHERE b.id =  ?';
        $arr = array();
        $arr[] = $r_resource_vars['boards'];
        if (!empty($authUser) && $authUser['role_id'] != 1) {
            $s_sql.= ' AND (b.board_visibility = 2 OR bu.user_id = ?)';
            $arr[] = $authUser['id'];
        } else if (empty($authUser)) {
            $s_sql.= ' AND b.board_visibility = 2 ';
        }
        $check_visibility = executeQuery($s_sql, $arr);
        if (!empty($check_visibility)) {
            $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM boards_listing ul WHERE id = ? ORDER BY id DESC) as d';
            $pg_params = array();
            array_push($pg_params, $r_resource_vars['boards']);
            if (!empty($sql)) {
                if ($result = executeQueryAll($sql, $pg_params)) {
                    $data = array();
                    foreach ($result as $row) {
                        $obj = json_decode($row['row_to_json'], true);
                        global $_server_domain_url;
                        $md5_hash = md5(SECURITYSALT . $r_resource_vars['boards']);
                        $obj['google_syn_url'] = $_server_domain_url . '/ical/' . $r_resource_vars['boards'] . '/' . $md5_hash . '.ics';
                        $acl_links_sql = 'SELECT * FROM acl_board_links_listing';
                        $acl_links_result = executeQueryAll($acl_links_sql, array());
                        $obj['acl_links'] = array();
                        foreach ($acl_links_result as $row) {
                            $obj['acl_links'][] = $row;
                        }
                        $board_user_roles_sql = 'SELECT * FROM board_user_roles';
                        $board_user_roles_result = executeQueryAll($board_user_roles_sql, array());
                        $obj['board_user_roles'] = array();
                        foreach ($board_user_roles_result as $row) {
                            $obj['board_user_roles'][] = $row;
                        }
                        $data = $obj;
                    }
                    echo json_encode($data, JSON_NUMERIC_CHECK);
                } else {
                    echo json_encode($data, JSON_NUMERIC_CHECK);
                }
            }
        } else {
            $results['error']['type'] = 'visibility';
            $results['error']['message'] = 'Unauthorized';
            header($_SERVER['SERVER_PROTOCOL'] . ' 401 Unauthorized', true, 401);
            echo json_encode($results, JSON_NUMERIC_CHECK);
        }
    } else {
        $results['error']['type'] = 'board';
        $results['error']['message'] = 'Bad Request';
        header($_SERVER['SERVER_PROTOCOL'] . ' 400 Bad Request', true, 400);
        echo json_encode($results, JSON_NUMERIC_CHECK);
    }
});
$app->GET('/api/v1/organizations.json', function ($request, $response, $args)
{
    global $authUser;
    $r_resource_filters = $request->getQueryParams();
    $data = $pg_params = array();
    if (!empty($r_resource_filters['type']) && $r_resource_filters['type'] == 'simple') {
        $organization_ids = array();
        $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM organizations';
        if (!empty($authUser) && $authUser['role_id'] != 1) {
            $s_sql = 'SELECT b.organization_id FROM boards_users AS bu LEFT JOIN boards AS b ON b.id = bu.board_id WHERE bu.user_id = ?';
            $conditions = array(
                $authUser['id']
            );
            $s_result = executeQueryAll($s_sql, $conditions);
            foreach ($s_result as $row) {
                if ($row['organization_id'] != 0) {
                    array_push($organization_ids, $row['organization_id']);
                }
            }
            $s_sql = 'SELECT id FROM organizations WHERE user_id = ?';
            $conditions = array(
                $authUser['id']
            );
            $s_result = executeQueryAll($s_sql, $conditions);
            foreach ($s_result as $row) {
                array_push($organization_ids, $row['id']);
            }
            $s_sql = 'SELECT organization_id FROM organizations_users WHERE user_id = ?';
            $conditions = array(
                $authUser['id']
            );
            $s_result = executeQueryAll($s_sql, $conditions);
            foreach ($s_result as $row) {
                array_push($organization_ids, $row['organization_id']);
            }
            if (!empty($organization_ids)) {
                $sql.= ' WHERE id IN (' . implode(",", array_unique($organization_ids)) . ')';
            } else {
                $sql.= ' WHERE user_id = ' . $authUser['id'];
            }
        }
        $sql.= ' ORDER BY id ASC ) as d';
        if (!empty($sql)) {
            if ($result = executeQueryAll($sql, $pg_params)) {
                $data = array();
                foreach ($result as $row) {
                    $obj = json_decode($row['row_to_json'], true);
                    $data[] = $obj;
                }
                echo json_encode($data, JSON_NUMERIC_CHECK);
            } else {
                echo json_encode($data, JSON_NUMERIC_CHECK);
            }
        }
    } else {
        $organization_ids = array();
        $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM organizations_listing';
        if (!empty($authUser) && $authUser['role_id'] != 1) {
            $s_sql = 'SELECT b.organization_id FROM boards_users AS bu LEFT JOIN boards AS b ON b.id = bu.board_id WHERE bu.user_id = ?';
            $conditions = array(
                $authUser['id']
            );
            $s_result = executeQueryAll($s_sql, $conditions);
            foreach ($s_result as $row) {
                if ($row['organization_id'] != 0) {
                    array_push($organization_ids, $row['organization_id']);
                }
            }
            $s_sql = 'SELECT id FROM organizations WHERE user_id = ?';
            $conditions = array(
                $authUser['id']
            );
            $s_result = executeQueryAll($s_sql, $conditions);
            foreach ($s_result as $row) {
                array_push($organization_ids, $row['id']);
            }
            $s_sql = 'SELECT organization_id FROM organizations_users WHERE user_id = ?';
            $conditions = array(
                $authUser['id']
            );
            $s_result = executeQueryAll($s_sql, $conditions);
            foreach ($s_result as $row) {
                array_push($organization_ids, $row['organization_id']);
            }
            if (!empty($organization_ids)) {
                $sql.= ' WHERE id IN (' . implode(",", array_unique($organization_ids)) . ')';
            } else {
                $sql.= ' WHERE user_id = ' . $authUser['id'];
            }
        }
        $sql.= ' ORDER BY id ASC ) as d ';
        if (!empty($sql)) {
            if ($result = executeQueryAll($sql, $pg_params)) {
                $data = array();
                foreach ($result as $row) {
                    $obj = json_decode($row['row_to_json'], true);
                    $acl_links_sql = 'SELECT * FROM acl_organization_links_listing';
                    $acl_links_result = executeQueryAll($acl_links_sql, array());
                    $obj['acl_links'] = array();
                    foreach ($acl_links_result as $row) {
                        $obj['acl_links'][] = $row;
                    }
                    $organization_user_roles_sql = 'SELECT * FROM organization_user_roles';
                    $organization_user_roles_result = executeQueryAll($organization_user_roles_sql, array());
                    $obj['organization_user_roles'] = array();
                    foreach ($organization_user_roles_result as $row) {
                        $obj['organization_user_roles'][] = $row;
                    }
                    $data[] = $obj;
                }
                echo json_encode($data, JSON_NUMERIC_CHECK);
            } else {
                echo json_encode($data, JSON_NUMERIC_CHECK);
            }
        }
    }
});
$app->GET('/api/v1/organizations/{organizationId}.json', function ($request, $response, $args)
{
    $r_resource_vars['organizations'] = $request->getAttribute('organizationId');
    $pg_params = array();
    $s_sql = 'SELECT o.organization_visibility, ou.user_id FROM organizations AS o LEFT JOIN organizations_users AS ou ON ou.organization_id = o.id WHERE o.id =  ?';
    $arr = $data = array();
    $arr[] = $r_resource_vars['organizations'];
    if (!empty($authUser) && $authUser['role_id'] != 1) {
        $s_sql.= ' AND (o.organization_visibility = 1 OR ou.user_id = ?)';
        $arr[] = $authUser['id'];
    } else if (empty($authUser)) {
        $s_sql.= ' AND o.organization_visibility = 1 ';
    }
    $check_visibility = executeQuery($s_sql, $arr);
    if (!empty($check_visibility)) {
        $sql = 'SELECT row_to_json(d) FROM (SELECT * FROM organizations_listing ul WHERE id = ? ORDER BY id DESC ) as d';
        array_push($pg_params, $r_resource_vars['organizations']);
        if (!empty($sql)) {
            if ($result = executeQueryAll($sql, $pg_params)) {
                $data = array();
                foreach ($result as $row) {
                    $obj = json_decode($row['row_to_json'], true);
                    $data = $obj;
                }
                $acl_organization_links_sql = 'SELECT * FROM acl_organization_links_listing';
                $acl_organization_links_result = executeQueryAll($acl_organization_links_sql, array());
                $data['acl_links'] = array();
                foreach ($acl_organization_links_result as $row) {
                    $data['acl_links'][] = $row;
                }
                $organization_user_roles_sql = 'SELECT id, name, description FROM organization_user_roles ORDER BY id ASC';
                $organization_user_roles_result = executeQueryAll($organization_user_roles_sql, array());
                $data['organization_user_roles'] = array();
                foreach ($organization_user_roles_result as $row) {
                    $data['organization_user_roles'][] = $row;
                }
                echo json_encode($data, JSON_NUMERIC_CHECK);
            } else {
                echo json_encode($data, JSON_NUMERIC_CHECK);
            }
        }
    } else {
        $results['error']['type'] = 'visibility';
        $results['error']['message'] = 'Unauthorized';
        echo json_encode($results, JSON_NUMERIC_CHECK);
    }
});
$app->GET('/api/v1/boards/{boardId}/lists/{listId}/cards/{cardId}/activities.json', function ($request, $response, $args)
{
    $results = array();
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->GET('/api/v1/boards/{boardId}/lists/{listId}/activities.json', function ($request, $response, $args)
{
    $results = array();
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->GET('/api/v1/boards/{boardId}/activities.json', function ($request, $response, $args)
{
    global $authUser;
    $r_resource_vars['boards'] = $request->getAttribute('boardId');
    $val_array = $data = array(
        $r_resource_vars['boards']
    );
    $board = executeQuery('SELECT board_visibility FROM boards_listing WHERE id = ?', $val_array);
    $val_array = array(
        $r_resource_vars['boards'],
        $authUser['id']
    );
    $boards_user = executeQuery('SELECT * FROM boards_users WHERE board_id = ? AND user_id = ?', $val_array);
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
        $sql = 'SELECT al.*, u.username, u.profile_picture_path, u.initials, u.full_name, c.description, c.name as card_name FROM activities_listing al LEFT JOIN users u ON al.user_id = u.id LEFT JOIN cards c on al.card_id = c.id WHERE al.board_id = ?' . $condition . ' ORDER BY al.id DESC LIMIT ' . $limit . ' ';
        if (empty($r_resource_filters['from']) || (!empty($r_resource_filters['from']) && $r_resource_filters['from'] != 'app')) {
            $c_sql = 'SELECT COUNT(*) FROM activities_listing al WHERE al.board_id = ?' . $condition;
        }
        if (!empty($c_sql)) {
            $paging_data = paginate_data($c_sql, $pg_params, $r_resource_filters);
            $_metadata = $paging_data['_metadata'];
        }
        if (!empty($sql)) {
            if ($result = executeQueryAll($sql, $pg_params)) {
                $data = array();
                $board_lists = array();
                foreach ($result as $row) {
                    $obj = $row;
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
                    $obj = getActivitiesObj($obj);
                    if (!empty($_metadata)) {
                        $data['data'][] = $obj;
                    } else {
                        $data[] = $obj;
                    }
                }
                if (!empty($_metadata)) {
                    $data['_metadata'] = $_metadata;
                }
                echo json_encode($data, JSON_NUMERIC_CHECK);
            } else {
                echo json_encode($data, JSON_NUMERIC_CHECK);
            }
        }
    }
});
$app->GET('/api/v1/boards/{boardId}/boards_stars.json', function ($request, $response, $args)
{
    global $authUser;
    $r_resource_vars['boards'] = $request->getAttribute('boardId');
    $data = array();
    $sql = 'SELECT * FROM board_stars bs WHERE board_id = ?';
    array_push($pg_params, $r_resource_vars['boards']);
    if (!empty($authUser) && $authUser['role_id'] != 1) {
        $sql.= ' and user_id = ?';
        array_push($pg_params, $authUser['id']);
    }
    $sql.= ' ORDER BY id DESC ';
    if (!empty($sql)) {
        if ($result = executeQueryAll($sql, $pg_params)) {
            $data = array();
            foreach ($result as $row) {
                $obj = $row;
                $data = $obj;
            }
            echo json_encode($data, JSON_NUMERIC_CHECK);
        } else {
            echo json_encode($data, JSON_NUMERIC_CHECK);
        }
    }
});
$app->GET('/api/v1/boards/{boardId}/board_subscribers.json', function ($request, $response, $args)
{
    global $authUser;
    $r_resource_vars['boards'] = $request->getAttribute('boardId');
    $data = array();
    $sql = 'SELECT * FROM board_subscribers ul WHERE board_id = ?';
    array_push($pg_params, $r_resource_vars['boards']);
    if (!empty($authUser) && $authUser['role_id'] != 1) {
        $sql.= ' and user_id = ?';
        array_push($pg_params, $authUser['id']);
    }
    $sql.= ' ORDER BY id DESC ';
    if ($result = executeQueryAll($sql, $pg_params)) {
        $data = array();
        foreach ($result as $row) {
            $obj = $row;
            $data[] = $obj;
        }
        echo json_encode($data, JSON_NUMERIC_CHECK);
    } else {
        echo json_encode($data, JSON_NUMERIC_CHECK);
    }
});
$app->GET('/api/v1/boards/{boardId}/lists/{listId}/cards/{cardId}.json', function ($request, $response, $args)
{
    global $authUser;
    $r_resource_vars['boards'] = $request->getAttribute('boardId');
    $r_resource_vars['lists'] = $request->getAttribute('listId');
    $r_resource_vars['cards'] = $request->getAttribute('cardId');
    $data = array();
    $sql = 'SELECT * FROM cards_listing cll WHERE id = ? ';
    array_push($pg_params, $r_resource_vars['cards']);
    if ($result = executeQueryAll($sql, $pg_params)) {
        foreach ($result as $row) {
            $obj = $row;
            $data = $obj;
        }
        echo json_encode($data, JSON_NUMERIC_CHECK);
    } else {
        echo json_encode($data, JSON_NUMERIC_CHECK);
    }
});
$app->GET('/api/v1/boards/{boardId}/lists.json', function ($request, $response, $args)
{
    global $authUser;
    $pg_params = array();
    $r_resource_filters = $request->getQueryParams();
    $r_resource_vars['boards'] = $request->getAttribute('boardId');
    $data = array();
    $fields = !empty($r_resource_filters['fields']) ? $r_resource_filters['fields'] : '*';
    $_metadata = array();
    $sql = 'SELECT ' . $fields . ' FROM lists_listing cll WHERE board_id = ?';
    array_push($pg_params, $r_resource_vars['boards']);
    if (empty($r_resource_filters['from']) || (!empty($r_resource_filters['from']) && $r_resource_filters['from'] != 'app')) {
        $c_sql = 'SELECT COUNT(*) FROM lists_listing cll';
        if (!empty($c_sql)) {
            $paging_data = paginate_data($c_sql, $pg_params, $r_resource_filters);
            $_metadata = $paging_data['_metadata'];
        }
    }
    if ($result = executeQueryAll($sql, $pg_params)) {
        $board_lists = array();
        foreach ($result as $row) {
            $obj = $row;
            $obj = getActivitiesObj($obj);
            if (!empty($_metadata)) {
                $data['data'][] = $obj;
            } else {
                $data[] = $obj;
            }
        }
        if (!empty($_metadata)) {
            $data['_metadata'] = $_metadata;
        }
        echo json_encode($data, JSON_NUMERIC_CHECK);
    } else {
        if (!empty($_metadata)) {
            $data['_metadata'] = $_metadata;
        }
        echo json_encode($data, JSON_NUMERIC_CHECK);
    }
});
$app->GET('/api/v1/boards/{boardId}/lists/{listId}/cards.json', function ($request, $response, $args)
{
    global $authUser;
    $r_resource_filters = $request->getQueryParams();
    $r_resource_vars['boards'] = $request->getAttribute('boardId');
    $r_resource_vars['lists'] = $request->getAttribute('listId');
    $_metadata = $data = array();
    $fields = !empty($r_resource_filters['fields']) ? $r_resource_filters['fields'] : '*';
    $sql = 'SELECT ' . $fields . ' FROM cards_listing cll WHERE board_id = ? AND list_id = ? ';
    if (empty($r_resource_filters['from']) || (!empty($r_resource_filters['from']) && $r_resource_filters['from'] != 'app')) {
        $c_sql = 'SELECT COUNT(*) FROM cards_listing cll';
        if (!empty($c_sql)) {
            $paging_data = paginate_data($c_sql, $pg_params, $r_resource_filters);
            $_metadata = $paging_data['_metadata'];
        }
    }
    array_push($pg_params, $r_resource_vars['boards']);
    array_push($pg_params, $r_resource_vars['lists']);
    if ($result = executeQueryAll($sql, $pg_params)) {
        $data = array();
        $board_lists = array();
        foreach ($result as $row) {
            $obj = $row;
            if (!empty($_metadata)) {
                $data['data'][] = $obj;
            } else {
                $data[] = $obj;
            }
        }
        if (!empty($_metadata)) {
            $data['_metadata'] = $_metadata;
        }
        echo json_encode($data, JSON_NUMERIC_CHECK);
    } else {
        if (!empty($_metadata)) {
            $data['_metadata'] = $_metadata;
        }
        echo json_encode($data, JSON_NUMERIC_CHECK);
    }
});
$app->GET('/api/v1/activities.json', function ($request, $response, $args)
{
    global $authUser;
    $r_resource_filters = $request->getQueryParams();
    $condition = '';
    $i = 1;
    $_metadata = $data = array();
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
    $sql = 'SELECT al.*, u.username, u.profile_picture_path, u.initials, u.full_name, c.description FROM activities_listing al LEFT JOIN users u ON al.user_id = u.id LEFT JOIN cards c ON  al.card_id = c.id ' . $condition . ' ORDER BY id DESC limit ' . $limit . ' ';
    if (empty($r_resource_filters['from']) || (!empty($r_resource_filters['from']) && $r_resource_filters['from'] != 'app')) {
        $c_sql = 'SELECT COUNT(*) FROM activities_listing al' . $condition;
    }
    if (!empty($c_sql)) {
        $paging_data = paginate_data($c_sql, $pg_params, $r_resource_filters);
        $_metadata = $paging_data['_metadata'];
    }
    if (!empty($sql)) {
        if ($result = executeQueryAll($sql, $pg_params)) {
            $data = array();
            $board_lists = array();
            foreach ($result as $row) {
                $obj = $row;
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
            echo json_encode($data, JSON_NUMERIC_CHECK);
        } else {
            if (!empty($_metadata)) {
                $data['_metadata'] = $_metadata;
            }
            echo json_encode($data, JSON_NUMERIC_CHECK);
        }
    }
});
$app->GET('/api/v1/boards/{boardId}/lists/{listId}/cards/{cardId}/checklists.json', function ($request, $response, $args)
{
    $data = array();
    $sql = 'SELECT * FROM checklist_add_listing al WHERE board_id = ? ';
    array_push($pg_params, $r_resource_vars['boards']);
    if ($result = executeQueryAll($sql, $pg_params)) {
        $data = array();
        foreach ($result as $row) {
            $obj = $row;
            $data[] = $obj;
        }
        echo json_encode($data, JSON_NUMERIC_CHECK);
    } else {
        echo json_encode($data, JSON_NUMERIC_CHECK);
    }
});
$app->GET('/api/v1/boards/{boardId}/visibility.json', function ($request, $response, $args)
{
    $data = array();
    $sql = 'SELECT board_visibility FROM boards bl WHERE bl.id = ? ';
    array_push($pg_params, $r_resource_vars['boards']);
    if ($result = executeQueryAll($sql, $pg_params)) {
        $data = array();
        foreach ($result as $row) {
            $obj = $row;
            $data = $obj;
        }
        echo json_encode($data, JSON_NUMERIC_CHECK);
    } else {
        echo json_encode($data, JSON_NUMERIC_CHECK);
    }
});
$app->GET('/api/v1/workflow_templates.json', function ($request, $response, $args)
{
    $files = glob(APP_PATH . '/client/js/workflow_templates/*.json', GLOB_BRACE);
    foreach ($files as $file) {
        $data = file_get_contents($file);
        $json = json_decode($data, true);
        $results[] = array(
            'name' => $json['name'],
            'value' => implode($json['lists'], ', ')
        );
    }
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->GET('/api/v1/boards/{boardId}/lists/{listId}/cards/{cardId}/search.json', function ($request, $response, $args)
{
    $data = array();
    $r_resource_filters = $request->getQueryParams();
    $sql = 'SELECT bul.id, bul.user_id, bul.username, bul.profile_picture_path, bul.full_name, bul.initials  FROM boards_users_listing bul WHERE';
    $sql.= '(bul.username LIKE ? OR bul.email LIKE ?) AND bul.board_id = ? ';
    array_push($pg_params, '%' . $r_resource_filters['q'] . '%', '%' . $r_resource_filters['q'] . '%', $r_resource_vars['boards']);
    if (empty($r_resource_filters['q'])) {
        $sql = false;
        $response = array();
        $pg_params = array();
        echo json_encode($results, JSON_NUMERIC_CHECK);
    } else {
        if ($result = executeQueryAll($sql, $pg_params)) {
            foreach ($result as $row) {
                $obj = $row;
                $data[] = $obj;
            }
            echo json_encode($data, JSON_NUMERIC_CHECK);
        } else {
            echo json_encode($data, JSON_NUMERIC_CHECK);
        }
    }
});
$app->GET('/api/v1/boards/{boardId}/cards/search.json', function ($request, $response, $args)
{
    global $authUser;
    $r_resource_filters = $request->getQueryParams();
    $data = array();
    $user_id = (!empty($authUser['id'])) ? $authUser['id'] : 0;
    $sql = 'SELECT DISTINCT c.id, c.name, bu.board_id FROM boards_users bu join cards c on c.board_id = bu.board_id WHERE bu.board_id IN (SELECT board_id FROM boards_users WHERE user_id = ?) AND c.name  LIKE ? ORDER BY id ASC';
    array_push($pg_params, $user_id, '%' . $r_resource_filters['q'] . '%');
    if (empty($r_resource_filters['q'])) {
        $sql = false;
        $response = array();
        $pg_params = array();
        echo json_encode($results, JSON_NUMERIC_CHECK);
    } else {
        if ($result = executeQueryAll($sql, $pg_params)) {
            $data = array();
            foreach ($result as $row) {
                $obj = $row;
                $data[] = $obj;
            }
            echo json_encode($data, JSON_NUMERIC_CHECK);
        } else {
            echo json_encode($data, JSON_NUMERIC_CHECK);
        }
    }
});
$app->GET('/api/v1/acl_links.json', function ($request, $response, $args)
{
    $sql = false;
    $acl_links_sql = 'SELECT acl_links.id,  acl_links.name, acl_links.group_id, ( SELECT array_to_json(array_agg(row_to_json(alr.*))) AS array_to_json FROM ( SELECT acl_links_roles.role_id FROM acl_links_roles acl_links_roles WHERE acl_links_roles.acl_link_id = acl_links.id ORDER BY acl_links_roles.role_id) alr) AS acl_links_roles, acl_links.is_guest_action, acl_links.is_user_action, acl_links.is_admin_action, acl_links.is_hide FROM acl_links acl_links ORDER BY group_id ASC, id ASC';
    $acl_links_result = executeQueryAll($acl_links_sql, array());
    $results['acl_links'] = array();
    foreach ($acl_links_result as $row) {
        $results['acl_links'][] = $row;
    }
    $roles_sql = 'SELECT id, name FROM roles ORDER BY id ASC';
    $roles_result = executeQueryAll($roles_sql, array());
    $results['roles'] = array();
    foreach ($roles_result as $row) {
        $results['roles'][] = $row;
    }
    $acl_board_links_sql = 'SELECT acl_board_links.id,  acl_board_links.name, acl_board_links.group_id, ( SELECT array_to_json(array_agg(row_to_json(alr.*))) AS array_to_json FROM ( SELECT acl_board_links_boards_user_roles.board_user_role_id FROM acl_board_links_boards_user_roles acl_board_links_boards_user_roles WHERE acl_board_links_boards_user_roles.acl_board_link_id = acl_board_links.id ORDER BY acl_board_links_boards_user_roles.board_user_role_id) alr) AS acl_board_links_boards_user_roles, acl_board_links.is_hide FROM acl_board_links acl_board_links ORDER BY group_id ASC, id ASC';
    $acl_board_links_result = executeQueryAll($acl_board_links_sql, array());
    $results['acl_board_links'] = array();
    foreach ($acl_board_links_result as $row) {
        $results['acl_board_links'][] = $row;
    }
    $board_user_roles_sql = 'SELECT id, name, description FROM board_user_roles ORDER BY id ASC';
    $board_user_roles_result = executeQueryAll($board_user_roles_sql, array());
    $results['board_user_roles'] = array();
    foreach ($board_user_roles_result as $row) {
        $results['board_user_roles'][] = $row;
    }
    $acl_organization_links_sql = 'SELECT acl_organization_links.id,  acl_organization_links.name, acl_organization_links.group_id, ( SELECT array_to_json(array_agg(row_to_json(alr.*))) AS array_to_json FROM ( SELECT acl_organization_links_organizations_user_roles.organization_user_role_id FROM acl_organization_links_organizations_user_roles acl_organization_links_organizations_user_roles WHERE acl_organization_links_organizations_user_roles.acl_organization_link_id = acl_organization_links.id ORDER BY acl_organization_links_organizations_user_roles.organization_user_role_id) alr) AS acl_organization_links_organizations_user_roles FROM acl_organization_links acl_organization_links ORDER BY group_id ASC, id ASC';
    $acl_organization_links_result = executeQueryAll($acl_organization_links_sql, array());
    $results['acl_organization_links'] = array();
    foreach ($acl_organization_links_result as $row) {
        $results['acl_organization_links'][] = $row;
    }
    $organization_user_roles_sql = 'SELECT id, name, description FROM organization_user_roles ORDER BY id ASC';
    $organization_user_roles_result = executeQueryAll($organization_user_roles_sql, array());
    $results['organization_user_roles'] = array();
    foreach ($organization_user_roles_result as $row) {
        $results['organization_user_roles'][] = $row;
    }
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->GET('/api/v1/settings.json', function ($request, $response, $args)
{
    $s_sql = executeQueryAll('SELECT name, value FROM settings WHERE name = \'SITE_NAME\' OR name = \'SITE_TIMEZONE\' OR name = \'DROPBOX_APPKEY\' OR name = \'LABEL_ICON\' OR name = \'FLICKR_API_KEY\'  OR name = \'DEFAULT_LANGUAGE\' OR name = \'IMAP_EMAIL\' OR name = \'STANDARD_LOGIN_ENABLED\' OR name = \'PAGING_COUNT\' OR name = \'DEFAULT_CARD_VIEW\'', array());
    foreach ($s_sql as $row) {
        $results[$row['name']] = $row['value'];
    }
    $files = glob(APP_PATH . '/client/apps/*/app.json', GLOB_BRACE);
    if (!empty($files)) {
        foreach ($files as $file) {
            $content = file_get_contents($file);
            $data = json_decode($content, true);
            if ($data['enabled'] === true) {
                $folder = explode('/', $file);
                if ($data['enabled'] === true) {
                    foreach ($data as $key => $value) {
                        if ($key != 'settings') {
                            $results['apps_data'][$folder[count($folder) - 2]][$key] = $value;
                        }
                    }
                }
                if (!empty($data['settings'])) {
                    foreach ($data['settings'] as $key => $value) {
                        if ($value['is_public']) {
                            $value['name'] = $key;
                            $results['apps']['settings'][] = $value;
                        }
                    }
                }
                foreach ($data['assets']['js'] as $jsfiles) {
                    $results['apps']['js'][] = $jsfiles;
                }
                foreach ($data['assets']['css'] as $cssfiles) {
                    $results['apps']['css'][] = $cssfiles;
                }
            }
        }
    }
    $results['apps_data'] = !empty($results['apps_data']) ? json_encode($results['apps_data']) : '';
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->GET('/api/v1/apps.json', function ($request, $response, $args)
{
    $files = glob(APP_PATH . '/client/apps/*/app.json', GLOB_BRACE);
    if (!empty($files)) {
        foreach ($files as $file) {
            $folder = explode('/', $file);
            $content = file_get_contents($file);
            $data = json_decode($content, true);
            $data['folder'] = $folder[count($folder) - 2];
            $results[] = $data;
        }
    }
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->GET('/api/v1/apps/settings.json', function ($request, $response, $args)
{
    global $authUser;
    $r_resource_filters = $request->getQueryParams();
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
            $results[] = $value;
        }
    }
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->GET('/api/v1/oauth/clients.json', function ($request, $response, $args)
{
    $data = $pg_params = array();
    $condition = '';
    if (!empty($_GET['id'])) {
        $condition = 'WHERE id = ?';
        $condition_param = $_GET['id'];
    }
    if (!empty($condition_param)) {
        array_push($pg_params, $condition_param);
    }
    $sql = 'SELECT * FROM oauth_clients c ' . $condition . ' ';
    if ($result = executeQueryAll($sql, $pg_params)) {
        foreach ($result as $row) {
            $obj = $row;
            $data[] = $obj;
        }
        echo json_encode($data, JSON_NUMERIC_CHECK);
    } else {
        echo json_encode($data, JSON_NUMERIC_CHECK);
    }
});
$app->GET('/api/v1/oauth/applications.json', function ($request, $response, $args)
{
    global $authUser;
    $r_resource_filters = $request->getQueryParams();
    $_metadata = $pg_params = $data = array();
    $sql = 'SELECT DISTINCT ON (ort.client_id) ort.client_id, oc.client_name FROM oauth_refresh_tokens ort LEFT JOIN oauth_clients oc ON ort.client_id = oc.client_id WHERE ort.user_id = ? AND ort.client_id != ? ';
    array_push($pg_params, $authUser['username'], '7742632501382313');
    $c_sql = 'SELECT COUNT(*) FROM (SELECT DISTINCT ON (ort.client_id) ort.client_id, oc.client_name FROM oauth_refresh_tokens ort LEFT JOIN oauth_clients oc ON ort.client_id = oc.client_id WHERE ort.user_id = ? AND ort.client_id != ?) As oc';
    if (!empty($c_sql)) {
        $paging_data = paginate_data($c_sql, $pg_params, $r_resource_filters);
        $_metadata = $paging_data['_metadata'];
    }
    if ($result = executeQueryAll($sql, $pg_params)) {
        foreach ($result as $row) {
            $obj = $row;
            $data[] = $obj;
        }
        if (!empty($_metadata)) {
            $data['_metadata'] = $_metadata;
        }
        echo json_encode($data, JSON_NUMERIC_CHECK);
    } else {
        echo json_encode($data, JSON_NUMERIC_CHECK);
    }
});
$app->GET('/api/v1/webhooks.json', function ($request, $response, $args)
{
    $pg_params = $data = array();
    $r_resource_filters = $request->getQueryParams();
    $sql = 'SELECT * FROM webhooks w ORDER BY id ASC ';
    $c_sql = 'SELECT COUNT(*) FROM webhooks w';
    if (!empty($c_sql)) {
        $paging_data = paginate_data($c_sql, $pg_params, $r_resource_filters);
        $_metadata = $paging_data['_metadata'];
    }
    if ($result = executeQueryAll($sql, $pg_params)) {
        foreach ($result as $row) {
            $obj = $row;
            $data[] = $obj;
        }
        if (!empty($_metadata)) {
            $data['_metadata'] = $_metadata;
        }
        echo json_encode($data, JSON_NUMERIC_CHECK);
    } else {
        echo json_encode($data, JSON_NUMERIC_CHECK);
    }
});
$app->POST('/api/v1/users/bulk_action.json', function ($request, $response, $args)
{
    $args = $request->getParsedBody();
    $args = json_encode($args[0]);
    $post_arr = json_decode($args, true);
    $action_id = $post_arr['action_id']['action_id'];
    unset($post_arr['action_id']);
    $user_ids = $post_arr;
    if ($action_id == 1) {
        foreach ($user_ids as $user_id) {
            $data = array(
                0,
                $user_id['user_id']
            );
            executeQueryAll('UPDATE users SET is_active = ? WHERE id = ?', $data);
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
            executeQueryAll('UPDATE users SET is_active = ? WHERE id = ?', $data);
        }
        $response = array(
            'success' => 'Checked users are unblocked successfully.'
        );
    } else if ($action_id == 3) {
        foreach ($user_ids as $user_id) {
            $conditions = array(
                $user_id['user_id']
            );
            $users = executeQueryAll('DELETE FROM users WHERE id= ? RETURNING username', $conditions);
            if (is_plugin_enabled('r_chat') && $jabberHost) {
                xmppDeleteUser($users);
            }
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
});
$app->POST('/api/v1/boards/bulk_action.json', function ($request, $response, $args)
{
    $args = $request->getParsedBody();
    $args = json_encode($args[0]);
    $post_arr = json_decode($args, true);
    $action_id = $post_arr['action_id']['action_id'];
    unset($post_arr['action_id']);
    $board_ids = $post_arr;
    if ($action_id == 1) {
        foreach ($board_ids as $board_id) {
            $data = array(
                1,
                $board_id['board_id']
            );
            executeQueryAll('UPDATE boards SET is_closed = ? WHERE id = ?', $data);
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
            executeQueryAll('UPDATE boards SET is_closed = ? WHERE id = ?', $data);
        }
        $response = array(
            'success' => 'Checked boards are reopened successfully.'
        );
    } else if ($action_id == 3) {
        if (is_plugin_enabled('r_chat') && $jabberHost) {
            $xmpp = xmppObj();
        }
        foreach ($board_ids as $board_id) {
            $conditions = array(
                $board_id['board_id']
            );
            $boards = executeQueryAll('DELETE FROM boards WHERE id= ?', $conditions);
            if (is_plugin_enabled('r_chat') && $jabberHost && $boards) {
                xmppDestroyRoom($boards, $xmpp);
            }
        }
        $response = array(
            'success' => 'Checked boards are deleted successfully.'
        );
    }
});
$app->POST('/api/v1/users/forgotpassword.json', function ($request, $response, $args)
{
    $args = $request->getParsedBody();
    $sth = $this->db->prepare('SELECT * FROM users WHERE email = ? AND is_active = true');
    $sth->bindParam(1, $args['email']);
    $sth->execute();
    $user = $sth->fetch(PDO::FETCH_ASSOC);
    if ($user) {
        $password = uniqid();
        $val_arr = array(
            getCryptHash($password) ,
            $user['id']
        );
        $sth = $this->db->prepare('UPDATE users SET (password) = (?) WHERE id = ?');
        $sth->execute($val_arr);
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
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->POST('/api/v1/users.json', function ($request, $response, $args)
{
    $args = $request->getParsedBody();
    $table_name = 'users';
    $val_arr = array(
        $args['username'],
        $args['email']
    );
    $user = executeQuery('SELECT * FROM users WHERE username = ? OR email = ?', $val_arr);
    if (!$user) {
        $sql = true;
        $table_name = 'users';
        $args['password'] = getCryptHash($args['password']);
        $args['role_id'] = 2; // user
        $args['is_active'] = true;
        $args['is_email_confirmed'] = true;
        $args['role_id'] = 2; // user
        $args['initials'] = strtoupper(substr($args['username'], 0, 1));
        $args['ip_id'] = saveIp();
        $args['full_name'] = email2name($args['email']);
        if (is_plugin_enabled('r_chat') && $jabberHost) {
            xmppRegisterUser($args);
        }
        if (!empty($sql)) {
            $post = getbindValues($table_name, $args);
            $result = executeInsertQuery($table_name, $post);
            if ($result) {
                $row = $result;
                $results['id'] = $row['id'];
                if ($is_return_vlaue) {
                    $row = convertBooleanValues($table_name, $row);
                    $results[$table_name] = $row;
                }
                if (!empty($uuid)) {
                    $results['uuid'] = $uuid;
                }
                $emailFindReplace['##NAME##'] = $args['full_name'];
                $emailFindReplace['##ACTIVATION_URL##'] = 'http://' . $_SERVER['HTTP_HOST'] . '/#/users/activation/' . $row['id'] . '/' . md5($args['username']);
                sendMail('activation', $emailFindReplace, $args['email']);
            }
        }
    } else {
        $msg = '';
        if ($user['email'] == $args['email']) {
            $msg = 1;
        } else if ($user['username'] == $args['username']) {
            $msg = 2;
        }
        $response = array(
            'error' => $msg
        );
    }
    echo json_encode($response, JSON_NUMERIC_CHECK);
});
$app->POST('/api/v1/users/register.json', function ($request, $response, $args)
{
    $args = $request->getParsedBody();
    $table_name = 'users';
    $val_arr = array(
        $args['username'],
        $args['email']
    );
    $user = executeQuery('SELECT * FROM users WHERE (username = ? AND username<>\'\') OR (email = ? AND email<>\'\')', $val_arr);
    if (!$user) {
        $sql = true;
        $table_name = 'users';
        $args['password'] = getCryptHash($args['password']);
        $args['role_id'] = 2; // user
        $args['initials'] = strtoupper(substr($args['username'], 0, 1));
        $args['ip_id'] = saveIp();
        $args['full_name'] = ($args['email'] == '') ? $args['username'] : email2name($args['email']);
        if (is_plugin_enabled('r_chat') && !empty($jabberHost)) {
            xmppRegisterUser($args);
        }
        if (!empty($sql)) {
            $post = getbindValues($table_name, $args);
            $result = executeInsertQuery($table_name, $post);
            if ($result) {
                $row = $result;
                $results['id'] = $row['id'];
                if ($is_return_vlaue) {
                    $row = convertBooleanValues($table_name, $row);
                    $results[$table_name] = $row;
                }
                if (!empty($uuid)) {
                    $results['uuid'] = $uuid;
                }
                $emailFindReplace['##NAME##'] = $args['full_name'];
                $emailFindReplace['##ACTIVATION_URL##'] = 'http://' . $_SERVER['HTTP_HOST'] . '/#/users/activation/' . $row['id'] . '/' . md5($args['username']);
                sendMail('activation', $emailFindReplace, $args['email']);
            }
        }
    } else {
        $msg = '';
        if ($user['email'] == $args['email']) {
            $msg = 1;
        } else if ($user['username'] == $args['username']) {
            $msg = 2;
        }
        $response = array(
            'error' => $msg
        );
    }
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->POST('/api/v1/users/login.json', function ($request, $response, $args)
{
    global $db_lnk;
    $args = $request->getParsedBody();
    $table_name = 'users';
    $val_arr = array(
        $args['email'],
        $args['email']
    );
    $log_user = executeQuery('SELECT id, role_id, password, is_ldap::boolean::int FROM users WHERE email = ? or username = ?', $val_arr);
    if (is_plugin_enabled('r_ldap_login')) {
        require_once APP_PATH . DIRECTORY_SEPARATOR . 'server' . DIRECTORY_SEPARATOR . 'php' . DIRECTORY_SEPARATOR . 'plugins' . DIRECTORY_SEPARATOR . 'LdapLogin' . DIRECTORY_SEPARATOR . 'functions.php';
        $ldap_response = ldapUpdateUser($log_user, $args);
        $ldap_error = $ldap_response['ldap_error'];
        $user = $ldap_response['user'];
    }
    if (STANDARD_LOGIN_ENABLED && !empty($log_user) && $log_user['is_ldap'] == 0) {
        $args['password'] = crypt($args['password'], $log_user['password']);
        $val_arr = array(
            $args['email'],
            $args['email'],
            $args['password'],
            1
        );
        $user = executeQuery('SELECT * FROM users_listing WHERE (email = ? or username = ?) AND password = ? AND is_active = ?', $val_arr);
    }
    if (!empty($user)) {
        if (is_plugin_enabled('r_ldap_login')) {
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
        executeQueryAll('UPDATE users SET last_login_date = now(), login_type_id = ?, last_login_ip_id = ? WHERE id = ?', $val_arr);
        unset($user['password']);
        $user_agent = !empty($_SERVER['HTTP_USER_AGENT']) ? $_SERVER['HTTP_USER_AGENT'] : '';
        $val_arr = array(
            $user['id'],
            $last_login_ip_id,
            $user_agent
        );
        executeQueryAll('INSERT INTO user_logins (created, modified, user_id, ip_id, user_agent) VALUES (now(), now(), ?, ?, ?)', $val_arr);
        $role_val_arr = array(
            $user['role_id']
        );
        $role_links = executeQuery('SELECT links FROM role_links_listing WHERE id = ?', $role_val_arr);
        $post_val = array(
            'grant_type' => 'password',
            'username' => $user['username'],
            'password' => $args['password'],
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
        $notify_count = executeQuery('SELECT max(id) AS last_activity_id, count(a.*) AS notify_count FROM activities a  WHERE a.id > ? AND board_id = ANY (?) ', $notify_val_arr);
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
    echo json_encode($response);
    //return renderWithJson($response);
    
});
$app->POST('/api/v1/users/{userId}/adminchangepassword.json', function ($request, $response, $args)
{
    global $authUser;
    $args = $request->getParsedBody();
    $r_resource_vars['users'] = $request->getAttribute('userId');
    $pg_params = array();
    $qry_val_array = array(
        $r_resource_vars['users']
    );
    if ($args['confirm_password'] == $args['password']) {
        $user = executeQuery('SELECT * FROM users WHERE id = ?', $qry_val_array);
        if ($user) {
            $res_val_arr = array(
                getCryptHash($args['password']) ,
                $r_resource_vars['users']
            );
            executeQueryAll('UPDATE users SET (password) = (?) WHERE id = ?', $res_val_arr);
            if (is_plugin_enabled('r_chat') && $jabberHost) {
                xmppChangePassword($args, $user);
            }
            if ($authUser['role_id'] == 1) {
                $emailFindReplace = array(
                    '##PASSWORD##' => $args['password']
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
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->POST('/api/v1/users/{userId}/changepassword.json', function ($request, $response, $args)
{
    global $authUser;
    $args = $request->getParsedBody();
    $r_resource_vars['users'] = $request->getAttribute('userId');
    $pg_params = array();
    $qry_val_array = array(
        $r_resource_vars['users']
    );
    if ($args['confirm_password'] == $args['password']) {
        $user = executeQuery('SELECT * FROM users WHERE id = ?', $qry_val_array);
        if ($user) {
            $cry_old_pass = crypt($args['old_password'], $user['password']);
            if ((($authUser['role_id'] == 2) && ($user['password'] == $cry_old_pass)) || ($authUser['role_id'] == 1)) {
                $res_val_arr = array(
                    getCryptHash($args['password']) ,
                    $r_resource_vars['users']
                );
                executeQueryAll('UPDATE users SET (password) = (?) WHERE id = ?', $res_val_arr);
                if (is_plugin_enabled('r_chat') && $jabberHost) {
                    xmppChangePassword($args, $user);
                }
                $conditions = array(
                    $authUser['username']
                );
                executeQueryAll('DELETE FROM oauth_access_tokens WHERE user_id= ?', $conditions);
                executeQueryAll('DELETE FROM oauth_refresh_tokens WHERE user_id= ?', $conditions);
                if ($authUser['role_id'] == 1) {
                    $emailFindReplace = array(
                        '##PASSWORD##' => $args['password']
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
    return renderWithJson($response);
});
$app->POST('/api/v1/users/{userId:\d+}.json', function ($request, $response, $args)
{
    $args = $request->getParsedBody();
    $r_resource_vars['users'] = $request->getAttribute('userId');
    $pg_params = array();
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
                    if (!empty($list) && file_exists($list[0])) {
                        unlink($list[0]);
                    }
                }
                $authUser['profile_picture_path'] = $profile_picture_path;
                $results['profile_picture_path'] = $profile_picture_path;
                $comment = '##USER_NAME## updated the profile image';
                $foreign_ids['user_id'] = $r_resource_vars['users'];
                $results['activity'] = insertActivity($r_resource_vars['users'], $comment, 'update_profile_attachment', $foreign_ids);
            }
            $qry_val_arr = array(
                $profile_picture_path,
                $r_resource_vars['users']
            );
            executeQueryAll('UPDATE users SET profile_picture_path = ? WHERE id = ?', $qry_val_arr);
        } else {
            $no_error = false;
            $msg = 1;
        }
    } else {
        if (!empty($_POST['email'])) {
            $usr_val_arr = array(
                $_POST['email']
            );
            $user = executeQuery('SELECT * FROM users WHERE email = ?', $usr_val_arr);
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
                    $revisions['old_value'] = executeQuery('SELECT ' . $sfields . ' FROM ' . $table_name . ' WHERE id =  ?', $qry_va_arr);
                    unset($revisions['old_value']['is_send_newsletter']);
                    unset($_POST['is_send_newsletter']);
                    $temp_revisions = array_diff($revisions['old_value'], $_POST);
                    foreach ($temp_revisions as $key => $value) {
                        $revisions['new_value'][$key] = (isset($_POST[$key])) ? $_POST[$key] : '';
                    }
                    $revision = serialize($revisions);
                    $foreign_id = $id;
                    if (!empty($temp_revisions)) {
                        $results['activity'] = insertActivity($authUser['id'], $comment, 'update_profile', $foreign_ids, $revision, $foreign_id);
                    } else {
                        $results['activity'] = '';
                    }
                    if (!empty($results['activity']['revisions']) && trim($results['activity']['revisions']) != '') {
                        $revisions = unserialize($results['activity']['revisions']);
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
                        $results['activity']['difference'] = $diff;
                    }
                }
            }
            executeQueryAll('UPDATE users SET full_name = ?, about_me = ?, initials = ?, is_send_newsletter = ?, timezone = ? WHERE id = ?', $qry_val_arr);
            if (!empty($_POST['email'])) {
                $qry_val_arr = array(
                    $_POST['email'],
                    $r_resource_vars['users']
                );
                executeQueryAll('UPDATE users SET email= ? WHERE id = ?', $qry_val_arr);
            }
        }
    }
    if ($no_error) {
        $results['success'] = 'User Profile has been updated.';
    } else {
        $results['error'] = $msg;
    }
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->POST('/api/v1/settings.json', function ($request, $response, $args)
{
    $args = $request->getParsedBody();
    foreach ($args as $key => $value) {
        if ($key == 'IMAP_EMAIL_PASSWORD') {
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
        executeQueryAll('UPDATE settings SET value = ? WHERE name = ?', $qry_val_arr);
    }
    $results = array(
        'success' => 'Settings updated successfully.'
    );
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->POST('/api/v1/boards.json', function ($request, $response, $args)
{
    global $authUser, $jabberHost;
    $is_import_board = false;
    $args = $request->getParsedBody();
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
                $results['id'] = $board['id'];
            } else {
                $results['error'] = 'Unable to import. please try again.';
            }
        } else {
            $results['error'] = 'Unable to import. please try again.';
        }
    } else {
        $table_name = 'boards';
        $qry_val_arr = array(
            $args['name']
        );
        executeQuery('SELECT id, name FROM ' . $table_name . ' WHERE name = ?', $qry_val_arr);
        if (isset($args['template']) && !empty($args['template'])) {
            $lists = explode(',', $args['template']);
        }
        unset($args['template']);
        $sql = true;
        $args['user_id'] = (!empty($authUser['id'])) ? $authUser['id'] : 1;
    }
    if (!empty($sql)) {
        $post = getbindValues($table_name, $args);
        $result = executeInsertQuery($table_name, $post);
        if ($result) {
            $row = $result;
            $results['id'] = $row['id'];
            if (!empty($uuid)) {
                $results['uuid'] = $uuid;
            }
            if (is_plugin_enabled('r_chat') && $jabberHost) {
                xmppCreateRoom($args, $response);
            }
            if (!$is_import_board) {
                $foreign_id['board_id'] = $results['id'];
                $comment = '##USER_NAME## created board';
                $qry_val_arr = array(
                    $row['id'],
                    $args['user_id']
                );
                $results['activity'] = insertActivity($authUser['id'], $comment, 'add_board', $foreign_id);
                executeQueryAll('INSERT INTO boards_users (created, modified, board_id , user_id, board_user_role_id) VALUES (now(), now(), ?, ?, 1)', $qry_val_arr);
                $qry_val_arr = array(
                    $row['id'],
                    $args['user_id'],
                    true
                );
                executeQueryAll('INSERT INTO board_subscribers (created, modified, board_id , user_id, is_subscribed) VALUES (now(), now(), ?, ?, ?)', $qry_val_arr);
                if (!empty($row['board_visibility']) && $row['board_visibility'] == 1 && !empty($args['organization_id'])) {
                    $qry_val_arr = array(
                        $args['organization_id']
                    );
                    $organization_users = executeQueryAll('SELECT * FROM organizations_users WHERE organization_id = ?', $qry_val_arr);
                    foreach ($organization_users as $organization_user) {
                        if (!empty($organization_user)) {
                            if ($organization_user['user_id'] != $row['user_id']) {
                                $qry_val_arr = array(
                                    $row['id'],
                                    $organization_user['user_id']
                                );
                                executeQueryAll('INSERT INTO boards_users (created, modified, board_id , user_id, board_user_role_id) VALUES (now(), now(), ?, ?, 2)', $qry_val_arr);
                                $qry_val_arr = array(
                                    $row['id'],
                                    $organization_user['user_id'],
                                    true
                                );
                                executeQueryAll('INSERT INTO board_subscribers (created, modified, board_id , user_id, is_subscribed) VALUES (now(), now(), ?, ?, ?)', $qry_val_arr);
                            }
                        }
                    }
                }
                if (isset($lists) && !empty($lists)) {
                    $position = 1;
                    foreach ($lists as $list) {
                        $qry_val_arr = array(
                            $results['id'],
                            $list,
                            $authUser['id'],
                            $position
                        );
                        $s_sql = 'INSERT INTO lists (created, modified, board_id, name, user_id, position) VALUES';
                        $s_sql.= '(now(), now(), ?, ?, ?, ?)';
                        executeQueryAll($s_sql, $qry_val_arr);
                        $position++;
                    }
                }
                $qry_val_arr = array(
                    $row['id']
                );
                $results['simple_board'] = executeQuery('SELECT row_to_json(d) FROM (SELECT * FROM simple_board_listing sbl WHERE id = ? ORDER BY id ASC) as d', $qry_val_arr);
                $results['simple_board'] = json_decode($results['simple_board']['row_to_json'], true);
            }
        }
    }
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->POST('/api/v1/boards/{boardId}/boards_stars.json', function ($request, $response, $args)
{
    global $authUser;
    $args = $request->getParsedBody();
    $r_resource_vars['boards'] = $request->getAttribute('boardId');
    $table_name = 'board_stars';
    $qry_val_arr = array(
        $r_resource_vars['boards'],
        $authUser['id']
    );
    $subcriber = executeQuery('SELECT id, is_starred FROM ' . $table_name . ' WHERE board_id = ? and user_id = ?', $qry_val_arr);
    if (!$subcriber) {
        $qry_val_arr = array(
            $r_resource_vars['boards'],
            $authUser['id']
        );
        $result = executeQuery('INSERT INTO ' . $table_name . ' (created, modified, board_id, user_id, is_starred) VALUES (now(), now(), ?, ?, true) RETURNING id', $qry_val_arr);
    } else {
        $subcriber = convertBooleanValues($table_name, $subcriber);
        if ($subcriber['is_starred'] == 1) {
            $qry_val_arr = array(
                0,
                $r_resource_vars['boards'],
                $authUser['id']
            );
            $result = executeQuery('UPDATE ' . $table_name . ' SET is_starred = ? Where  board_id = ? and user_id = ? RETURNING id', $qry_val_arr);
        } else {
            $qry_val_arr = array(
                1,
                $r_resource_vars['boards'],
                $authUser['id']
            );
            $result = executeQuery('UPDATE ' . $table_name . ' SET is_starred = ? Where  board_id = ? and user_id = ? RETURNING id', $qry_val_arr);
        }
    }
    $star = $result;
    $results['id'] = $star['id'];
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->POST('/api/v1/boards/{boardId}/board_subscribers.json', function ($request, $response, $args)
{
    global $authUser;
    $args = $request->getParsedBody();
    $r_resource_vars['boards'] = $request->getAttribute('boardId');
    $table_name = 'board_subscribers';
    $qry_val_arr = array(
        $r_resource_vars['boards'],
        $authUser['id']
    );
    $subcriber = executeQuery('SELECT id, is_subscribed FROM ' . $table_name . ' WHERE board_id = ? and user_id = ?', $qry_val_arr);
    if (!$subcriber) {
        $qry_val_arr = array(
            $r_resource_vars['boards'],
            $authUser['id']
        );
        $result = executeQuery('INSERT INTO ' . $table_name . ' (created, modified, board_id, user_id, is_subscribed) VALUES (now(), now(), ?, ?, true) RETURNING *', $qry_val_arr);
    } else {
        if ($subcriber['is_subscribed'] == 1) {
            $qry_val_arr = array(
                $r_resource_vars['boards'],
                $authUser['id']
            );
            $result = executeQuery('UPDATE ' . $table_name . ' SET is_subscribed = false Where  board_id = ? and user_id = ? RETURNING *', $qry_val_arr);
        } else {
            $qry_val_arr = array(
                $r_resource_vars['boards'],
                $authUser['id']
            );
            $result = executeQuery('UPDATE ' . $table_name . ' SET is_subscribed = True Where  board_id = ? and user_id = ? RETURNING *', $qry_val_arr);
        }
    }
    $_response = $result;
    $response = convertBooleanValues($table_name, $_response);
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->POST('/api/v1/boards/{boardId}/copy.json', function ($request, $response, $args)
{
    global $authUser;
    $args = $request->getParsedBody();
    $r_resource_vars['boards'] = $request->getAttribute('boardId');
    $table_name = 'boards';
    $sql = true;
    $copied_board_id = $r_resource_vars['boards'];
    $board_visibility = $args['board_visibility'];
    if (!empty($args['organization_id'])) {
        $organization_id = $args['organization_id'];
    }
    $keepcards = false;
    if (!empty($args['keepCards'])) {
        $keepcards = true;
        unset($args['keepCards']);
    }
    $qry_val_arr = array(
        $copied_board_id
    );
    $sresult = executeQuery('SELECT * FROM boards WHERE id = ?', $qry_val_arr);
    $srow = $sresult;
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
    $args = array_merge($args, $srow);
    $args['board_visibility'] = $board_visibility;
    if (!empty($organization_id)) {
        $args['organization_id'] = $organization_id;
    }
    if (!empty($sql)) {
        $post = getbindValues($table_name, $args);
        $result = executeInsertQuery($table_name, $post);
        if ($result) {
            $row = $result;
            $results['id'] = $row['id'];
            if (!empty($uuid)) {
                $results['uuid'] = $uuid;
            }
            $new_board_id = $row['id'];
            //Copy board users
            $boards_user_fields = 'user_id, board_user_role_id';
            $qry_val_arr = array(
                $r_resource_vars['boards']
            );
            $boards_users = executeQueryAll('SELECT id, ' . $boards_user_fields . ' FROM boards_users WHERE board_id = ?', $qry_val_arr);
            if ($boards_users && count($boards_users)) {
                $boards_user_fields = 'created, modified, board_id, ' . $boards_user_fields;
                foreach ($boards_users as $boards_user) {
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
                        $boards_user_val.= '?';
                        $boards_user_val.= ($i != $len) ? ', ' : '';
                    }
                    executeQueryAll('INSERT INTO boards_users (' . $boards_user_fields . ') VALUES (' . $boards_user_val . ')', $boards_user_values);
                }
            }
            //Copy board subscribers
            $boards_subscriber_fields = 'user_id, is_subscribed';
            $qry_val_arr = array(
                $r_resource_vars['boards']
            );
            $boards_subscribers = executeQueryAll('SELECT id, ' . $boards_subscriber_fields . ' FROM board_subscribers WHERE board_id = ?', $qry_val_arr);
            if ($boards_subscribers && count($boards_subscribers)) {
                $boards_subscriber_fields = 'created, modified, board_id, ' . $boards_subscriber_fields;
                foreach ($boards_subscribers as $boards_subscriber) {
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
                        $boards_subscriber_val.= '?';
                        $boards_subscriber_val.= ($i != $len) ? ', ' : '';
                    }
                    executeQueryAll('INSERT INTO board_subscribers (' . $boards_subscriber_fields . ') VALUES (' . $boards_subscriber_val . ')', $boards_subscriber_values);
                }
            }
            //Copy board star
            $boards_star_fields = 'user_id, is_starred';
            $qry_val_arr = array(
                $r_resource_vars['boards']
            );
            $boards_stars = executeQueryAll('SELECT id, ' . $boards_star_fields . ' FROM board_stars WHERE board_id = ?', $qry_val_arr);
            if ($boards_stars && count($boards_stars)) {
                $boards_star_fields = 'created, modified, board_id, ' . $boards_star_fields;
                foreach ($boards_stars as $boards_star) {
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
                        $boards_star_val.= '?';
                        $boards_star_val.= ($i != $len) ? ', ' : '';
                    }
                    executeQueryAll('INSERT INTO board_stars (' . $boards_star_fields . ') VALUES (' . $boards_star_val . ')', $boards_star_values);
                }
            }
            if ($keepcards) {
                $qry_val_arr = array(
                    $r_resource_vars['boards']
                );
                $lists = executeQueryAll('SELECT id, name, position, is_archived, card_count, lists_subscriber_count FROM lists WHERE board_id = ?', $qry_val_arr);
            } else {
                $qry_val_arr = array(
                    $r_resource_vars['boards']
                );
                $lists = executeQueryAll('SELECT id, name, position, is_archived, lists_subscriber_count FROM lists WHERE board_id = ?', $qry_val_arr);
            }
            if ($lists) {
                // Copy lists
                foreach ($lists as $list) {
                    $list_id = $list['id'];
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
                        $list_val.= '?';
                        $list_val.= ($i != $len) ? ', ' : '';
                    }
                    $lists_result = executeQuery('INSERT INTO lists (' . $list_fields . ') VALUES (' . $list_val . ') RETURNING id', $list_values);
                    if ($lists_result) {
                        $list_result = $lists_result;
                        $new_list_id = $list_result['id'];
                        //Copy list subscribers
                        $lists_subscriber_fields = 'user_id, is_subscribed';
                        $qry_val_arr = array(
                            $list_id
                        );
                        $lists_subscribers = executeQueryAll('SELECT id, ' . $lists_subscriber_fields . ' FROM list_subscribers WHERE list_id = ?', $qry_val_arr);
                        if ($lists_subscribers && count($lists_subscribers)) {
                            $lists_subscriber_fields = 'created, modified, list_id, ' . $lists_subscriber_fields;
                            foreach ($lists_subscribers as $lists_subscriber) {
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
                                    $lists_subscriber_val.= '?';
                                    $lists_subscriber_val.= ($i != $len) ? ', ' : '';
                                }
                                executeQueryAll('INSERT INTO list_subscribers (' . $lists_subscriber_fields . ') VALUES (' . $lists_subscriber_val . ')', $lists_subscriber_values);
                            }
                        }
                        // Copy cards
                        $card_fields = 'name, description, due_date, position, is_archived, attachment_count, checklist_count, checklist_item_count, checklist_item_completed_count, label_count, cards_user_count, cards_subscriber_count, card_voter_count, activity_count, user_id, comment_count';
                        if ($keepcards) {
                            $qry_val_arr = array(
                                $list_id
                            );
                            $cards = executeQueryAll('SELECT id, ' . $card_fields . ' FROM cards WHERE list_id = ?', $qry_val_arr);
                        }
                        if ($keepcards && count($cards)) {
                            $card_fields = 'created, modified, board_id, list_id, ' . $card_fields;
                            foreach ($cards as $card) {
                                $card_id = $card['id'];
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
                                    $card_val.= '?';
                                    $card_val.= ($i != $len) ? ', ' : '';
                                }
                                $card_result = executeQuery('INSERT INTO cards (' . $card_fields . ') VALUES (' . $card_val . ') RETURNING id', $card_values);
                                if ($card_result) {
                                    $card_result = $card_result;
                                    $new_card_id = $card_result['id'];
                                    //Copy card attachments
                                    $attachment_fields = 'name, path, mimetype';
                                    $qry_val_arr = array(
                                        $card_id
                                    );
                                    $attachments = executeQueryAll('SELECT id, ' . $attachment_fields . ' FROM card_attachments WHERE card_id = ?', $qry_val_arr);
                                    if ($attachments && count($attachments)) {
                                        $attachment_fields = 'created, modified, board_id, list_id, card_id, ' . $attachment_fields;
                                        foreach ($attachments as $attachment) {
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
                                                $attachment_val.= '?';
                                                $attachment_val.= ($i != $len) ? ', ' : '';
                                            }
                                            executeQueryAll('INSERT INTO card_attachments (' . $attachment_fields . ') VALUES (' . $attachment_val . ')', $attachment_values);
                                        }
                                    }
                                    //Copy checklists
                                    $checklist_fields = 'user_id, name, checklist_item_count, checklist_item_completed_count, position';
                                    $qry_val_arr = array(
                                        $card_id
                                    );
                                    $checklists = executeQueryAll('SELECT id, ' . $checklist_fields . ' FROM checklists WHERE card_id = ?', $qry_val_arr);
                                    if ($checklists && count($checklists)) {
                                        $checklist_fields = 'created, modified, card_id, ' . $checklist_fields;
                                        foreach ($checklists as $checklist) {
                                            $checklist_values = array();
                                            array_push($checklist_values, 'now()', 'now()', $new_card_id);
                                            $checklist_id = $checklist['id'];
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
                                                $checklist_val.= '?';
                                                $checklist_val.= ($i != $len) ? ', ' : '';
                                            }
                                            $checklist_result = executeQuery('INSERT INTO checklists (' . $checklist_fields . ') VALUES (' . $checklist_val . ') RETURNING id', $checklist_values);
                                            if ($checklist_result) {
                                                $checklist_result = $checklist_result;
                                                $new_checklist_id = $checklist_result['id'];
                                                //Copy checklist items
                                                $checklist_item_fields = 'user_id, name, position';
                                                $qry_val_array = array(
                                                    $checklist_id
                                                );
                                                $checklist_items = executeQueryAll('SELECT id, ' . $checklist_item_fields . ' FROM checklist_items WHERE checklist_id = ?', $qry_val_array);
                                                if ($checklist_items && count($checklist_items)) {
                                                    $checklist_item_fields = 'created, modified, card_id, checklist_id, ' . $checklist_item_fields;
                                                    foreach ($checklist_items as $checklist_item) {
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
                                                            $checklist_item_val.= '?';
                                                            $checklist_item_val.= ($i != $len) ? ', ' : '';
                                                        }
                                                        executeQueryAll('INSERT INTO checklist_items (' . $checklist_item_fields . ') VALUES (' . $checklist_item_val . ')', $checklist_item_values);
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
                                    $card_voters = executeQueryAll('SELECT id, ' . $card_voter_fields . ' FROM card_voters WHERE card_id = ?', $qry_val_arr);
                                    if ($card_voters && count($card_voters)) {
                                        $card_voter_fields = 'created, modified, card_id, ' . $card_voter_fields;
                                        foreach ($card_voters as $card_voter) {
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
                                                $card_voter_val.= '?';
                                                $card_voter_val.= ($i != $len) ? ', ' : '';
                                            }
                                            executeQueryAll('INSERT INTO card_voters (' . $card_voter_fields . ') VALUES (' . $card_voter_val . ')', $card_voter_values);
                                        }
                                    }
                                    //Copy card labels
                                    $cards_label_fields = 'label_id';
                                    $qry_val_arr = array(
                                        $card_id
                                    );
                                    $cards_labels = executeQueryAll('SELECT id, ' . $cards_label_fields . ' FROM cards_labels WHERE card_id = ?', $qry_val_arr);
                                    if ($cards_labels && count($cards_labels)) {
                                        $cards_label_fields = 'created, modified, board_id, list_id, card_id, ' . $cards_label_fields;
                                        foreach ($cards_labels as $cards_label) {
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
                                                $cards_label_val.= '?';
                                                $cards_label_val.= ($i != $len) ? ', ' : '';
                                            }
                                            executeQueryAll('INSERT INTO cards_labels (' . $cards_label_fields . ') VALUES (' . $cards_label_val . ')', $cards_label_values);
                                        }
                                    }
                                    //Copy card subscribers
                                    $cards_subscriber_fields = 'user_id, is_subscribed';
                                    $qry_val_arr = array(
                                        $card_id
                                    );
                                    $cards_subscribers = executeQueryAll('SELECT id, ' . $cards_subscriber_fields . ' FROM card_subscribers WHERE card_id = ?', $qry_val_arr);
                                    if ($cards_subscribers && count($cards_subscribers)) {
                                        $cards_subscriber_fields = 'created, modified, card_id, ' . $cards_subscriber_fields;
                                        foreach ($cards_subscribers as $cards_subscriber) {
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
                                                $cards_subscriber_val.= '?';
                                                $cards_subscriber_val.= ($i != $len) ? ', ' : '';
                                            }
                                            executeQueryAll('INSERT INTO card_subscribers (' . $cards_subscriber_fields . ') VALUES (' . $cards_subscriber_val . ')', $cards_subscriber_values);
                                        }
                                    }
                                    //Copy card users
                                    $cards_user_fields = 'user_id';
                                    $qry_val_arr = array(
                                        $card_id
                                    );
                                    $cards_users = executeQueryAll('SELECT id, ' . $cards_user_fields . ' FROM cards_users WHERE card_id = ?', $qry_val_arr);
                                    if ($cards_users && count($cards_users)) {
                                        $cards_user_fields = 'created, modified, card_id, ' . $cards_user_fields;
                                        foreach ($cards_users as $cards_user) {
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
                                                $cards_user_val.= '?';
                                                $cards_user_val.= ($i != $len) ? ', ' : '';
                                            }
                                            executeQueryAll('INSERT INTO cards_users (' . $cards_user_fields . ') VALUES (' . $cards_user_val . ')', $cards_user_values);
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
            $sresult = executeQuery('SELECT name FROM boards WHERE id = ?', $qry_val_arr);
            $srow = $sresult;
            $foreign_ids['board_id'] = $new_board_id;
            $comment = '##USER_NAME## copied this board from ' . $srow['name'];
            $results['activity'] = insertActivity($authUser['id'], $comment, 'copy_board', $foreign_ids, null, $r_resource_vars['boards']);
        }
    }
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->POST('/api/v1/boards/{boardId}/custom_backgrounds.json', function ($request, $response, $args)
{
    $args = $request->getParsedBody();
    $r_resource_vars['boards'] = $request->getAttribute('boardId');
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
                $args['name'] = $file['name'];
                foreach ($thumbsizes['Board'] as $key => $value) {
                    $mediadir = APP_PATH . DIRECTORY_SEPARATOR . 'client' . DIRECTORY_SEPARATOR . 'img' . DIRECTORY_SEPARATOR . $key . DIRECTORY_SEPARATOR . 'Board' . DIRECTORY_SEPARATOR . $r_resource_vars['boards'];
                    $list = glob($mediadir . '.*');
                    if (!empty($list)) {
                        if (file_exists($list[0])) {
                            unlink($list[0]);
                        }
                    }
                }
                $hash = md5(SECURITYSALT . 'Board' . $r_resource_vars['boards'] . 'jpg' . 'extra_large_thumb');
                $background_picture_url = $_server_domain_url . '/img/extra_large_thumb/Board/' . $r_resource_vars['boards'] . '.' . $hash . '.jpg';
                $args['background_picture_path'] = $save_path . DIRECTORY_SEPARATOR . $file['name'];
                $args['path'] = $background_picture_url;
                $results['background_picture_url'] = $background_picture_url;
            }
            $qry_val_array = array(
                $args['path'],
                $args['background_picture_path'],
                $r_resource_vars['boards']
            );
            executeQueryAll('UPDATE boards SET background_picture_url = ?,background_picture_path = ? WHERE id = ?', $qry_val_array);
        } else {
            $results['error'] = 'File extension not supported. It supports only jpg, png, bmp and gif.';
        }
    }
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->POST('/api/v1/boards/{boardId}/users.json', function ($request, $response, $args)
{
    global $authUser, $jabberHost;
    $results = array();
    $args = $request->getParsedBody();
    $r_resource_vars['boards'] = $request->getAttribute('boardId');
    $is_return_vlaue = true;
    $table_name = 'boards_users';
    $args['board_id'] = $r_resource_vars['boards'];
    $qry_val_arr = array(
        $r_resource_vars['boards'],
        $args['user_id']
    );
    $boards_user = executeQuery('SELECT * FROM boards_users WHERE board_id = ? AND user_id = ?', $qry_val_arr);
    if (empty($boards_user)) {
        $sql = true;
    }
    if (!empty($sql)) {
        $post = getbindValues($table_name, $args);
        $result = executeInsertQuery($table_name, $post);
        if ($result) {
            $row = $result;
            $results['id'] = $row['id'];
            if ($is_return_vlaue) {
                $row = convertBooleanValues($table_name, $row);
                $results[$table_name] = $row;
            }
            $qry_val_arr = array(
                $args['board_id']
            );
            $s_result = executeQuery('SELECT id, name FROM boards WHERE id = ?', $qry_val_arr);
            $previous_value = $s_result;
            $foreign_ids['board_id'] = $r_resource_vars['boards'];
            $foreign_ids['board_id'] = $args['board_id'];
            $qry_val_arr = array(
                $args['user_id']
            );
            $user = executeQuery('SELECT * FROM users WHERE id = ?', $qry_val_arr);
            if ($user) {
                $emailFindReplace = array(
                    '##NAME##' => $user['full_name'],
                    '##CURRENT_USER##' => $authUser['full_name'],
                    '##BOARD_NAME##' => $previous_value['name'],
                    '##BOARD_URL##' => 'http://' . $_SERVER['HTTP_HOST'] . '/#/board/' . $args['board_id'],
                );
                sendMail('newprojectuser', $emailFindReplace, $user['email']);
            }
            $comment = '##USER_NAME## added member to board';
            $results['activity'] = insertActivity($authUser['id'], $comment, 'add_board_user', $foreign_ids, '', $results['id']);
            if (is_plugin_enabled('r_chat') && $jabberHost) {
                xmppGrantMember($args, $previous_value);
            }
        }
    }
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->POST('/api/v1/boards/{boardId}/lists.json', function ($request, $response, $args)
{
    global $authUser;
    $args = $request->getParsedBody();
    $r_resource_vars['boards'] = $request->getAttribute('boardId');
    $table_name = 'lists';
    $args['board_id'] = $r_resource_vars['boards'];
    $args['user_id'] = $authUser['id'];
    $sql = true;
    if (isset($args['clone_list_id'])) {
        $clone_list_id = $args['clone_list_id'];
        unset($args['clone_list_id']);
        unset($args['list_cards']);
    }
    if (!empty($sql)) {
        $post = getbindValues($table_name, $args);
        $result = executeInsertQuery($table_name, $post);
        if ($result) {
            $row = $result;
            $results['id'] = $row['id'];
            $foreign_ids['board_id'] = $args['board_id'];
            $foreign_ids['list_id'] = $results['id'];
            $comment = '##USER_NAME## added list "' . $args['name'] . '".';
            $results['activity'] = insertActivity($authUser['id'], $comment, 'add_list', $foreign_ids);
            if (!empty($clone_list_id)) {
                $new_list_id = $results['id'];
                // Copy cards
                $card_fields = 'board_id, name, description, position, due_date, is_archived, attachment_count, checklist_count, checklist_item_count, checklist_item_completed_count, label_count, cards_user_count, cards_subscriber_count, card_voter_count, activity_count, user_id, comment_count';
                $card_fields = 'list_id, ' . $card_fields;
                $qry_val_arr = array(
                    $clone_list_id
                );
                $cards = executeQueryAll('SELECT id, ' . $card_fields . ' FROM cards WHERE list_id = ? ORDER BY id', $qry_val_arr);
                if (count($cards)) {
                    copyCards($cards, $new_list_id, $post['name'], $foreign_ids['board_id']);
                }
            }
            $qry_val_arr = array(
                $foreign_ids['list_id']
            );
            $s_result = executeQuery('SELECT * FROM lists_listing WHERE id = ?', $qry_val_arr);
            $list = $s_result;
            $results['list'] = $list;
            $qry_val_arr = array(
                $foreign_ids['list_id']
            );
            $attachments = executeQueryAll('SELECT * FROM card_attachments WHERE list_id = ? order by created DESC', $qry_val_arr);
            foreach ($attachments as $attachment) {
                $results['list']['attachments'][] = $attachment;
            }
            $qry_val_arr = array(
                $foreign_ids['list_id']
            );
            $activities = executeQueryAll('SELECT * FROM activities_listing WHERE list_id = ?', $qry_val_arr);
            foreach ($activities as $activity) {
                $results['list']['activities'][] = $activity;
            }
            $condition = array(
                $foreign_ids['list_id']
            );
            $cards = executeQueryAll('select * from cards where list_id = ?', $condition);
            foreach ($cards as $card) {
                $results['list']['checklists'] = $results['list']['checklists_items'] = array();
                if (!empty($card)) {
                    $condition = array(
                        $card['id']
                    );
                    $checklists = executeQueryAll('select * from checklists where card_id = ?', $condition);
                    foreach ($checklists as $checklist) {
                        if (!empty($checklist)) {
                            $results['list']['checklists'][] = $checklist;
                            $condition = array(
                                $card['id'],
                                $checklist['id']
                            );
                            $checklist_items = executeQueryAll('select * from checklist_items where card_id = ? AND checklist_id = ?', $condition);
                            foreach ($checklist_items as $checklist_item) {
                                if (!empty($checklist_item)) {
                                    $results['list']['checklists_items'][] = $checklist_item;
                                }
                            }
                        }
                    }
                }
            }
            $qry_val_arr = array(
                $foreign_ids['list_id']
            );
            $labels = executeQueryAll('SELECT * FROM cards_labels_listing WHERE list_id = ?', $qry_val_arr);
            foreach ($labels as $label) {
                $results['list']['labels'][] = $label;
            }
            $results['list']['cards'] = json_decode($results['list']['cards'], true);
            $results['list']['lists_subscribers'] = json_decode($results['list']['lists_subscribers'], true);
            $qry_val_arr = array(
                $args['board_id']
            );
            $list_count = executeQuery('SELECT count(*) as count FROM lists WHERE board_id = ?', $qry_val_arr);
            if ($list_count['count'] == 1) {
                $qry_val_arr = array(
                    $args['board_id'],
                    $results['id']
                );
                executeQueryAll('UPDATE boards SET default_email_list_id = ? WHERE id = ?', $qry_val_arr);
            }
        }
    }
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->POST('/api/v1/boards/{boardId}/lists/{listId}/list_subscribers.json', function ($request, $response, $args)
{
    $args = $request->getParsedBody();
    $r_resource_vars['boards'] = $request->getAttribute('boardId');
    $r_resource_vars['lists'] = $request->getAttribute('listId');
    $table_name = 'list_subscribers';
    $args['user_id'] = $authUser['id'];
    $qry_val_arr = array(
        $r_resource_vars['lists'],
        $args['user_id']
    );
    $s_result = executeQueryAll('SELECT is_subscribed FROM list_subscribers WHERE list_id = ? and user_id = ?', $qry_val_arr);
    $check_subscribed = $s_result;
    if (!empty($check_subscribed)) {
        $is_subscribed = ($args['is_subscribed']) ? true : false;
        $qry_val_arr = array(
            $is_subscribed,
            $r_resource_vars['lists'],
            $args['user_id']
        );
        executeQueryAll('UPDATE list_subscribers SET is_subscribed = ? WHERE list_id = ? and user_id = ?', $qry_val_arr);
    } else {
        $args['list_id'] = $r_resource_vars['lists'];
        $sql = true;
    }
    if (!empty($sql)) {
        $post = getbindValues($table_name, $args);
        $result = executeInsertQuery($table_name, $post);
        if ($result) {
            $row = $result;
            $results['id'] = $row['id'];
        }
    }
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->POST('/api/v1/boards/{boardId}/lists/{listId}/cards.json', function ($request, $response, $args)
{
    global $authUser;
    $args = $request->getParsedBody();
    $r_resource_vars['boards'] = $request->getAttribute('boardId');
    $r_resource_vars['lists'] = $request->getAttribute('listId');
    $table_name = 'cards';
    $args['user_id'] = $authUser['id'];
    $qry_val_arr = array(
        $args['board_id'],
        $args['list_id']
    );
    $pos_res = executeQuery('SELECT position FROM cards WHERE board_id = ? AND list_id = ? ORDER BY position DESC LIMIT 1', $qry_val_arr);
    $position = $pos_res;
    if (empty($args['due_date'])) {
        unset($args['due_date']);
    }
    if (!empty($args['user_ids'])) {
        $args['members'] = explode(',', $args['user_ids']);
    }
    if (!isset($args['position'])) {
        $args['position'] = $position['position'] + 1;
    }
    $sql = true;
    if (!empty($sql)) {
        $post = getbindValues($table_name, $args);
        $result = executeInsertQuery($table_name, $post);
        if ($result) {
            $row = $result;
            $results['id'] = $row['id'];
            $qry_val_arr = array(
                $args['list_id']
            );
            $s_result = executeQuery('SELECT name FROM lists WHERE id = ?', $qry_val_arr);
            $list = $s_result;
            $foreign_ids['board_id'] = $args['board_id'];
            $foreign_ids['card_id'] = $results['id'];
            $foreign_ids['list_id'] = $args['list_id'];
            $comment = '##USER_NAME## added card ##CARD_LINK## to list "' . $list['name'] . '".';
            $results['activity'] = insertActivity($authUser['id'], $comment, 'add_card', $foreign_ids, '', $args['list_id']);
            if (!empty($args['members'])) {
                foreach ($args['members'] as $member) {
                    $s_usql = 'INSERT INTO cards_users (created, modified, card_id, user_id) VALUES(now(), now(), ' . $results['id'] . ', ' . $member . ') RETURNING id';
                    $s_result = executeQueryAll($s_usql, array());
                    $card_user = $s_result;
                    $qry_val_arr = array(
                        $member
                    );
                    $_user = executeQuery('SELECT username FROM users WHERE id = ?', $qry_val_arr);
                    $comment = '##USER_NAME## added "' . $_user['username'] . '" as member to this card ##CARD_LINK##';
                    $results['activity'] = insertActivity($authUser['id'], $comment, 'add_card_user', $foreign_ids, '', $card_user['id']);
                }
            }
            $qry_val_arr = array(
                $results['id']
            );
            $cards_users = executeQueryAll('SELECT * FROM cards_users_listing WHERE card_id = ?', $qry_val_arr);
            foreach ($cards_users as $cards_user) {
                $results['cards_users'][] = $cards_user;
            }
            if (!empty($args['labels'])) {
                $args['card_labels'] = $args['labels'];
            }
            if (!empty($args['card_labels'])) {
                $label_names = explode(',', $args['card_labels']);
                foreach ($label_names as $label_name) {
                    $qry_val_arr = array(
                        $label_name
                    );
                    $s_result = executeQueryAll('SELECT id FROM labels WHERE name = ?', $qry_val_arr);
                    $label = $s_result;
                    if (empty($label)) {
                        $qry_val_arr = array(
                            $label_name
                        );
                        $s_result = executeQueryAll($s_sql = 'INSERT INTO labels (created, modified, name) VALUES (now(), now(), ?) RETURNING id', $qry_val_arr);
                        $label = $s_result;
                    }
                    $args['label_id'] = $label['id'];
                    $args['card_id'] = $row['id'];
                    $args['list_id'] = $row['list_id'];
                    $args['board_id'] = $row['board_id'];
                    $qry_val_arr = array(
                        $args['card_id'],
                        $args['label_id'],
                        $args['board_id'],
                        $args['list_id']
                    );
                    executeQueryAll('INSERT INTO cards_labels (created, modified, card_id, label_id, board_id, list_id) VALUES (now(), now(), ?, ?, ?, ?) RETURNING *', $qry_val_arr);
                }
                $comment = '##USER_NAME## added label(s) to this card ##CARD_LINK## - ##LABEL_NAME##';
                insertActivity($authUser['id'], $comment, 'add_card_label', $foreign_ids, null, $args['label_id']);
            }
            $qry_val_arr = array(
                $results['id']
            );
            $cards_labels = executeQueryAll('SELECT * FROM cards_labels_listing WHERE card_id = ?', $qry_val_arr);
            foreach ($cards_labels as $cards_label) {
                $results['cards_labels'][] = $cards_label;
            }
        }
    }
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->POST('/api/v1/boards/{boardId}/lists/{listId}/cards/{cardId}/comments.json', function ($request, $response, $args)
{
    $args = $request->getParsedBody();
    $r_resource_vars['boards'] = $request->getAttribute('boardId');
    $r_resource_vars['lists'] = $request->getAttribute('listId');
    $r_resource_vars['cards'] = $request->getAttribute('cardId');
    $is_return_vlaue = true;
    $table_name = 'activities';
    $sql = true;
    $prev_message = array();
    if (isset($args['root']) && !empty($args['root'])) {
        $qry_val_arr = array(
            $args['root']
        );
        $prev_message = executeQuery('SELECT ac.*, u,username, u.profile_picture_path, u.initials, u.full_name FROM activities ac LEFT JOIN users u ON ac.user_id = u.id WHERE ac.id = ? order by created DESC', $qry_val_arr);
    }
    $args['freshness_ts'] = date('Y-m-d h:i:s');
    $args['type'] = 'add_comment';
    if (empty($args['user_id'])) {
        $args['user_id'] = $authUser['id'];
    }
    if (!empty($sql)) {
        $post = getbindValues($table_name, $args);
        $result = executeInsertQuery($table_name, $post);
        if ($result) {
            $row = $result;
            $results['id'] = $row['id'];
            $id_converted = base_convert($results['id'], 10, 36);
            $materialized_path = sprintf("%08s", $id_converted);
            if (!empty($prev_message['materialized_path'])) {
                $materialized_path = $prev_message['materialized_path'] . '-' . $materialized_path;
            }
            if (!empty($prev_message['path'])) {
                $path = $prev_message['path'] . '.P' . $results['id'];
                $depth = $prev_message['depth'] + 1;
                $root = $prev_message['root'];
                $results['activities']['depth'] = $depth;
            } else {
                $path = 'P' . $results['id'];
                $depth = 0;
                $root = $results['id'];
            }
            $qry_val_arr = array(
                $materialized_path,
                $path,
                $depth,
                $root,
                $results['id']
            );
            executeQueryAll('UPDATE activities SET materialized_path = ?, path = ?, depth = ?, root = ? WHERE id = ?', $qry_val_arr);
            $qry_val_arr = array(
                $args['freshness_ts'],
                $root
            );
            executeQueryAll('UPDATE activities SET freshness_ts = ? WHERE root = ?', $qry_val_arr);
            $qry_val_arr = array(
                $root
            );
            $act_res = executeQueryAll('SELECT * FROM activities WHERE root = ?', $qry_val_arr);
            $results['activity'] = $act_res;
        }
    }
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->POST('/api/v1/boards/{boardId}/lists/{listId}/cards/{cardId}/card_subscribers.json', function ($request, $response, $args)
{
    global $authUser;
    $args = $request->getParsedBody();
    $r_resource_vars['boards'] = $request->getAttribute('boardId');
    $r_resource_vars['lists'] = $request->getAttribute('listId');
    $r_resource_vars['cards'] = $request->getAttribute('cardId');
    $table_name = 'card_subscribers';
    $json = true;
    $args['user_id'] = $authUser['id'];
    unset($args['list_id']);
    unset($args['board_id']);
    $qry_val_arr = array(
        $r_resource_vars['cards'],
        $args['user_id']
    );
    $s_result = executeQueryAll('SELECT is_subscribed FROM card_subscribers WHERE card_id = ? and user_id = ?', $qry_val_arr);
    $check_subscribed = $s_result;
    if (!empty($check_subscribed)) {
        $is_subscribed = ($args['is_subscribed']) ? 'true' : 'false';
        $qry_val_arr = array(
            $is_subscribed,
            $r_resource_vars['cards'],
            $args['user_id']
        );
        $s_result = executeQuery('UPDATE card_subscribers SET is_subscribed = ? WHERE card_id = ? and user_id = ? RETURNING id', $qry_val_arr);
        $subscribe = $s_result;
        $results['id'] = $subscribe['id'];
        if ($sql && ($sql !== true) && !empty($json) && !empty($results['id'])) {
            if ($result = executeQueryAll($sql, array())) {
                $count = count($result);
                $i = 0;
                foreach ($result as $row) {
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
    } else {
        $args['card_id'] = $r_resource_vars['cards'];
        $args['user_id'] = $args['user_id'];
        $sql = true;
        if (!empty($sql)) {
            $post = getbindValues($table_name, $args);
            $result = executeInsertQuery($table_name, $post);
            if ($result) {
                $row = $result;
                $results['id'] = $row['id'];
            }
        }
        echo json_encode($results, JSON_NUMERIC_CHECK);
    }
});
$app->POST('/api/v1/boards/{boardId}/lists/{listId}/cards/{cardId}/card_voters.json', function ($request, $response, $args)
{
    global $authUser;
    $args = $request->getParsedBody();
    $r_resource_vars['boards'] = $request->getAttribute('boardId');
    $r_resource_vars['lists'] = $request->getAttribute('listId');
    $r_resource_vars['cards'] = $request->getAttribute('cardId');
    $results = array();
    $table_name = 'card_voters';
    $args['card_id'] = $r_resource_vars['cards'];
    $args['user_id'] = $authUser['id'];
    $qry_val_arr = array(
        $args['card_id'],
        $args['user_id']
    );
    $check_already_added = executeQuery('SELECT * FROM card_voters WHERE card_id = ? AND user_id = ?', $qry_val_arr);
    if (!empty($check_already_added)) {
        $results['id'] = $check_already_added['id'];
        $results['cards_voters'] = $check_already_added;
        $sql = false;
        echo json_encode($results, JSON_NUMERIC_CHECK);
    } else {
        $sql = true;
        if (!empty($sql)) {
            $post = getbindValues($table_name, $args);
            $result = executeInsertQuery($table_name, $post);
            if ($result) {
                $row = $result;
                $results['id'] = $row['id'];
                $foreign_ids['board_id'] = $r_resource_vars['boards'];
                $foreign_ids['list_id'] = $r_resource_vars['lists'];
                $foreign_ids['card_id'] = $args['card_id'];
                $comment = '##USER_NAME## voted on ##CARD_LINK##';
                $results['activity'] = insertActivity($authUser['id'], $comment, 'add_card_voter', $foreign_ids, '', $results['id']);
                $qry_val_arr = array(
                    $results['id']
                );
                $s_result = executeQueryAll('SELECT * FROM card_voters_listing WHERE id = ?', $qry_val_arr);
                $user = $s_result;
                $results['card_voters'] = $user;
            }
        }
        echo json_encode($results, JSON_NUMERIC_CHECK);
    }
});
$app->POST('/api/v1/boards/{boardId}/lists/{listId}/cards/{cardId}/attachments.json', function ($request, $response, $args)
{
    global $authUser, $thumbsizes;
    $args = $request->getParsedBody();
    $r_resource_vars['boards'] = $request->getAttribute('boardId');
    $r_resource_vars['lists'] = $request->getAttribute('listId');
    $r_resource_vars['cards'] = $request->getAttribute('cardId');
    $is_return_vlaue = true;
    $table_name = 'card_attachments';
    $args['card_id'] = $r_resource_vars['cards'];
    $args['list_id'] = $r_resource_vars['lists'];
    $args['board_id'] = $r_resource_vars['boards'];
    $mediadir = APP_PATH . DIRECTORY_SEPARATOR . 'media' . DIRECTORY_SEPARATOR . 'Card' . DIRECTORY_SEPARATOR . $r_resource_vars['cards'];
    $save_path = 'media' . DIRECTORY_SEPARATOR . 'Card' . DIRECTORY_SEPARATOR . $r_resource_vars['cards'];
    $save_path = str_replace('\\', '/', $save_path);
    if (!empty($_FILES['attachment']) && $_FILES['attachment']['error'] == 0) {
        if (!file_exists($mediadir)) {
            mkdir($mediadir, 0777, true);
        }
        $file = $_FILES['attachment'];
        if (is_uploaded_file($file['tmp_name']) && move_uploaded_file($file['tmp_name'], $mediadir . DIRECTORY_SEPARATOR . $file['name'])) {
            $args['path'] = $save_path . '/' . $file['name'];
            $args['name'] = $file['name'];
            $args['mimetype'] = $file['type'];
            $qry_val_arr = array(
                $args['card_id'],
                $args['name'],
                $args['path'],
                $args['list_id'],
                $args['board_id'],
                $args['mimetype']
            );
            $s_result = executeQuery('INSERT INTO card_attachments (created, modified, card_id, name, path, list_id, board_id, mimetype) VALUES (now(), now(), ?, ?, ?, ?, ?, ?) RETURNING *', $qry_val_arr);
            $results['card_attachments'][] = $s_result;
        }
        foreach ($thumbsizes['CardAttachment'] as $key => $value) {
            $mediadir = APP_PATH . '/client/img/' . $key . '/CardAttachment/' . $results['card_attachments'][0]['id'];
            $list = glob($mediadir . '.*');
            if (!empty($list) && file_exists($list[0])) {
                unlink($list[0]);
            }
        }
        $foreign_ids['board_id'] = $r_resource_vars['boards'];
        $foreign_ids['list_id'] = $r_resource_vars['lists'];
        $foreign_ids['card_id'] = $r_resource_vars['cards'];
        $comment = '##USER_NAME## added attachment to this card ##CARD_LINK##';
        $results['activity'] = insertActivity($authUser['id'], $comment, 'add_card_attachment', $foreign_ids, null, $results['card_attachments'][0]['id']);
    } else if (!empty($_FILES['attachment']) && is_array($_FILES['attachment']['name']) && $_FILES['attachment']['error'][0] == 0) {
        $file = $_FILES['attachment'];
        $file_count = count($file['name']);
        for ($i = 0; $i < $file_count; $i++) {
            if ($file['name'][$i] != 'undefined') {
                if (!file_exists($mediadir)) {
                    mkdir($mediadir, 0777, true);
                }
                if (is_uploaded_file($file['tmp_name'][$i]) && move_uploaded_file($file['tmp_name'][$i], $mediadir . DIRECTORY_SEPARATOR . $file['name'][$i])) {
                    $args[$i]['path'] = $save_path . DIRECTORY_SEPARATOR . $file['name'][$i];
                    $args[$i]['name'] = $file['name'][$i];
                    $args[$i]['mimetype'] = $file['type'][$i];
                    $qry_val_arr = array(
                        $args['card_id'],
                        $args[$i]['name'],
                        $args[$i]['path'],
                        $args['list_id'],
                        $args['board_id'],
                        $args[$i]['mimetype']
                    );
                    $s_result = executeQuery('INSERT INTO card_attachments (created, modified, card_id, name, path, list_id, board_id, mimetype) VALUES (now(), now(), ?, ?, ?, ?, ?, ?) RETURNING *', $qry_val_arr);
                    $results['card_attachments'][] = $s_result;
                    $foreign_ids['board_id'] = $r_resource_vars['boards'];
                    $foreign_ids['list_id'] = $r_resource_vars['lists'];
                    $foreign_ids['card_id'] = $r_resource_vars['cards'];
                    $comment = '##USER_NAME## added attachment to this card ##CARD_LINK##';
                    $results['activity'] = insertActivity($authUser['id'], $comment, 'add_card_attachment', $foreign_ids, null, $results['card_attachments'][$i]['id']);
                    foreach ($thumbsizes['CardAttachment'] as $key => $value) {
                        $imgdir = APP_PATH . '/client/img/' . $key . '/CardAttachment/' . $results['card_attachments'][$i]['id'];
                        $list = glob($imgdir . '.*');
                        if (!empty($list) && file_exists($list[0])) {
                            unlink($list[0]);
                        }
                    }
                }
            }
        }
    } else if (isset($args['image_link']) && !empty($args['image_link'])) {
        if (!empty($args['image_link']) && is_array($args['image_link'])) {
            $i = 0;
            foreach ($args['image_link'] as $image_link) {
                $args['name'] = $args['link'] = $image_link;
                $qry_val_arr = array(
                    $args['card_id'],
                    $args['name'],
                    'NULL',
                    $args['list_id'],
                    $args['board_id'],
                    'NULL',
                    $args['link']
                );
                $s_result = executeQuery('INSERT INTO card_attachments (created, modified, card_id, name, path, list_id, board_id, mimetype, link) VALUES (now(), now(), ?, ?, ?, ?, ?, ?, ?) RETURNING *', $qry_val_arr);
                $results['card_attachments'][] = $s_result;
                $foreign_ids['board_id'] = $r_resource_vars['boards'];
                $foreign_ids['list_id'] = $r_resource_vars['lists'];
                $foreign_ids['card_id'] = $r_resource_vars['cards'];
                $comment = '##USER_NAME## added attachment to this card ##CARD_LINK##';
                $results['activity'] = insertActivity($authUser['id'], $comment, 'add_card_attachment', $foreign_ids, null, $results['card_attachments'][$i]['id']);
                $i++;
            }
        } else {
            $sql = true;
            $attachment_url_host = parse_url($args['image_link'], PHP_URL_HOST);
            $url_hosts = array(
                'docs.google.com',
                'www.dropbox.com',
                'github.com'
            );
            if (in_array($attachment_url_host, $url_hosts)) {
                $args['name'] = $args['link'] = $args['image_link'];
                $args['path'] = '';
            } else {
                $filename = curlExecute($args['image_link'], 'get', $mediadir, 'image');
                $args['name'] = $filename['file_name'];
                $args['link'] = $args['image_link'];
                $args['path'] = $save_path . '/' . $args['name'];
            }
            unset($args['image_link']);
            if (!empty($sql)) {
                $post = getbindValues($table_name, $args);
                $result = executeInsertQuery($table_name, $post);
                if ($result) {
                    $row = $result;
                    $results['id'] = $row['id'];
                    $foreign_ids['board_id'] = $args['board_id'];
                    $foreign_ids['list_id'] = $args['list_id'];
                    $foreign_ids['card_id'] = $args['card_id'];
                    $comment = '##USER_NAME## added attachment to this card ##CARD_LINK##';
                    $results['activity'] = insertActivity($authUser['id'], $comment, 'add_card_attachment', $foreign_ids, null, $results['id']);
                    foreach ($thumbsizes['CardAttachment'] as $key => $value) {
                        $mediadir = APP_PATH . '/client/img/' . $key . '/CardAttachment/' . $results['id'];
                        $list = glob($mediadir . '.*');
                        if (file_exists($list[0])) {
                            unlink($list[0]);
                        }
                    }
                }
            }
        }
    }
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->POST('/api/v1/boards/{boardId}/lists/{listId}/cards/{cardId}/labels.json', function ($request, $response, $args)
{
    global $authUser;
    $args = $request->getParsedBody();
    $r_resource_vars['boards'] = $request->getAttribute('boardId');
    $r_resource_vars['lists'] = $request->getAttribute('listId');
    $r_resource_vars['cards'] = $request->getAttribute('cardId');
    $is_return_vlaue = true;
    $table_name = 'cards_labels';
    $args['card_id'] = $r_resource_vars['cards'];
    $args['list_id'] = $r_resource_vars['lists'];
    $args['board_id'] = $r_resource_vars['boards'];
    $qry_val_arr = array(
        $r_resource_vars['cards']
    );
    $delete_labels = executeQuery('DELETE FROM ' . $table_name . ' WHERE card_id = ? RETURNING label_id', $qry_val_arr);
    $delete_label = $delete_labels;
    $delete_labels_count = count($delete_labels);
    if (!empty($args['name'])) {
        $label_names = explode(',', $args['name']);
        unset($args['name']);
        foreach ($label_names as $label_name) {
            $qry_val_arr = array(
                $label_name
            );
            $s_result = executeQuery('SELECT id FROM labels WHERE name = ?', $qry_val_arr);
            $label = $s_result;
            if (empty($label)) {
                $qry_val_arr = array(
                    $label_name
                );
                $s_result = executeQuery('INSERT INTO labels (created, modified, name) VALUES (now(), now(), ?) RETURNING id', $qry_val_arr);
                $label = $s_result;
            }
            $args['label_id'] = $label['id'];
            $qry_val_arr = array(
                $args['card_id'],
                $args['label_id'],
                $args['board_id'],
                $args['list_id']
            );
            executeQueryAll('INSERT INTO ' . $table_name . ' (created, modified, card_id, label_id, board_id, list_id) VALUES (now(), now(), ?, ?, ?, ?) RETURNING *', $qry_val_arr);
        }
        $qry_val_arr = array(
            $args['card_id']
        );
        $s_result = executeQueryAll('SELECT * FROM cards_labels_listing WHERE card_id = ?', $qry_val_arr);
        $cards_labels = $s_result;
        $results['cards_labels'] = $cards_labels;
        $comment = '##USER_NAME## added label(s) to this card ##CARD_LINK## - ##LABEL_NAME##';
    } else {
        $results['cards_labels'] = array();
        $comment = '##USER_NAME## removed label(s) in this card ##CARD_LINK## - ##LABEL_NAME##';
        $foreign_ids['foreign_id'] = $delete_label['label_id'];
    }
    $foreign_ids['board_id'] = $args['board_id'];
    $foreign_ids['list_id'] = $args['list_id'];
    $foreign_ids['card_id'] = $args['card_id'];
    if (!empty($delete_labels_count)) {
        if (!empty($args['label_id'])) {
            $results['activity'] = insertActivity($authUser['id'], $comment, 'add_card_label', $foreign_ids, null, $args['label_id']);
        }
    }
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->POST('/api/v1/boards/{boardId}/lists/{listId}/cards/{cardId}/checklists.json', function ($request, $response, $args)
{
    global $authUser;
    $args = $request->getParsedBody();
    $r_resource_vars['boards'] = $request->getAttribute('boardId');
    $r_resource_vars['lists'] = $request->getAttribute('listId');
    $r_resource_vars['cards'] = $request->getAttribute('cardId');
    $sql = true;
    $table_name = 'checklists';
    $args['user_id'] = $authUser['id'];
    $args['card_id'] = $r_resource_vars['cards'];
    if (isset($args['checklist_id'])) {
        $checklist_id = $args['checklist_id'];
        unset($args['checklist_id']);
    }
    if (!empty($sql)) {
        $post = getbindValues($table_name, $args);
        $result = executeInsertQuery($table_name, $post);
        if ($result) {
            $row = $result;
            $results['id'] = $row['id'];
            if (isset($checklist_id) && !empty($checklist_id)) {
                $qry_val_arr = array(
                    $args['user_id'],
                    $results['id'],
                    $checklist_id,
                    $args['card_id']
                );
                executeQueryAll('INSERT INTO checklist_items (created, modified, user_id, card_id, checklist_id, name, is_completed, position) SELECT created, modified, ?, ?, ?, name, false, position FROM checklist_items WHERE checklist_id = ?', $qry_val_arr);
            }
            $qry_val_arr = array(
                $results['id']
            );
            $result = executeQuery('SELECT * FROM checklists_listing WHERE id = ?', $qry_val_arr);
            $results['checklist'] = $result;
            $results['checklist']['checklists_items'] = json_decode($results['checklist']['checklists_items'], true);
            $foreign_ids['board_id'] = $r_resource_vars['boards'];
            $foreign_ids['list_id'] = $r_resource_vars['lists'];
            $foreign_ids['card_id'] = $r_resource_vars['cards'];
            $comment = '##USER_NAME## added checklist ' . $results['checklist']['name'] . ' to this card ##CARD_LINK##';
            $results['activity'] = insertActivity($authUser['id'], $comment, 'add_card_checklist', $foreign_ids, '', $results['id']);
        }
    }
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->POST('/api/v1/boards/{boardId}/lists/{listId}/cards/{cardId}/checklists/{checklistId}/items.json', function ($request, $response, $args)
{
    global $authUser;
    $args = $request->getParsedBody();
    $r_resource_vars['boards'] = $request->getAttribute('boardId');
    $r_resource_vars['lists'] = $request->getAttribute('listId');
    $r_resource_vars['cards'] = $request->getAttribute('cardId');
    $r_resource_vars['checklists'] = $request->getAttribute('checklistId');
    $table_name = 'checklist_items';
    $is_return_vlaue = true;
    $args['user_id'] = $authUser['id'];
    $args['card_id'] = $r_resource_vars['cards'];
    $args['checklist_id'] = $r_resource_vars['checklists'];
    unset($args['created']);
    unset($args['modified']);
    unset($args['is_offline']);
    unset($args['list_id']);
    unset($args['board_id']);
    $names = explode("\n", $args['name']);
    foreach ($names as $name) {
        $args['name'] = trim($name);
        if (!empty($args['name'])) {
            $qry_val_arr = array(
                $args['checklist_id']
            );
            $position = executeQuery('SELECT max(position) as position FROM checklist_items WHERE checklist_id = ?', $qry_val_arr);
            $args['position'] = $position['position'];
            if (empty($args['position'])) {
                $args['position'] = 0;
            }
            $args['position']+= 1;
            if (empty($args['member'])) {
                unset($args['member']);
            }
            $args = getbindValues($table_name, $args);
            $result = executeInsertQuery($table_name, $args);
            $item = $result;
            $results[$table_name][] = $item;
            $foreign_ids['board_id'] = $r_resource_vars['boards'];
            $foreign_ids['list_id'] = $r_resource_vars['lists'];
            $foreign_ids['card_id'] = $args['card_id'];
            $comment = '##USER_NAME## added item ##CHECKLIST_ITEM_NAME## in checklist ##CHECKLIST_ITEM_PARENT_NAME## of card ##CARD_LINK##';
            $results['activities'][] = insertActivity($authUser['id'], $comment, 'add_checklist_item', $foreign_ids, '', $item['id']);
        }
    }
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->POST('/api/v1/boards/{boardId}/lists/{listId}/cards/{cardId}/checklists/{checklistId}/items/{itemId}/convert_to_card.json', function ($request, $response, $args)
{
    $args = $request->getParsedBody();
    $r_resource_vars['boards'] = $request->getAttribute('boardId');
    $r_resource_vars['lists'] = $request->getAttribute('listId');
    $r_resource_vars['cards'] = $request->getAttribute('cardId');
    $r_resource_vars['checklists'] = $request->getAttribute('checklistId');
    $r_resource_vars['items'] = $request->getAttribute('itemId');
    $is_return_vlaue = true;
    $table_name = 'cards';
    $qry_val_arr = array(
        $r_resource_vars['items']
    );
    $result = executeQueryAll('SELECT name FROM checklist_items WHERE id = ?', $qry_val_arr);
    $row = $result;
    $args['board_id'] = $r_resource_vars['boards'];
    $args['list_id'] = $r_resource_vars['lists'];
    $args['name'] = $row['name'];
    $qry_val_arr = array(
        $args['list_id']
    );
    $sresult = executeQueryAll('SELECT max(position) as position FROM cards WHERE list_id = ?', $qry_val_arr);
    $srow = $sresult;
    $args['position'] = $srow['position'];
    $args['user_id'] = $authUser['id'];
    $sql = true;
    if (!empty($sql)) {
        $post = getbindValues($table_name, $args);
        $result = executeInsertQuery($table_name, $post);
        if ($result) {
            $row = $result;
            $results['id'] = $row['id'];
            if ($is_return_vlaue) {
                $row = convertBooleanValues($table_name, $row);
                $results[$table_name] = $row;
            }
            $qry_val_arr = array(
                $args['list_id']
            );
            $s_result = executeQuery('SELECT name FROM lists WHERE id = ?', $qry_val_arr);
            $list = $s_result;
            $foreign_ids['board_id'] = $args['board_id'];
            $foreign_ids['card_id'] = $results['id'];
            $foreign_ids['list_id'] = $args['list_id'];
            $comment = '##USER_NAME## added card ##CARD_LINK## to list "' . $list['name'] . '".';
            $results['activity'] = insertActivity($authUser['id'], $comment, 'add_card', $foreign_ids, '', $args['list_id']);
            if (!empty($args['members'])) {
                foreach ($args['members'] as $member) {
                    $s_usql = 'INSERT INTO cards_users (created, modified, card_id, user_id) VALUES(now(), now(), ' . $results['id'] . ', ' . $member . ') RETURNING id';
                    $s_result = executeQuery($s_usql, array());
                    $card_user = $s_result;
                    $qry_val_arr = array(
                        $member
                    );
                    $_user = executeQuery('SELECT username FROM users WHERE id = ?', $qry_val_arr);
                    $comment = '##USER_NAME## added "' . $_user['username'] . '" as member to this card ##CARD_LINK##';
                    $results['activity'] = insertActivity($authUser['id'], $comment, 'add_card_user', $foreign_ids, '', $card_user['id']);
                }
            }
            $qry_val_arr = array(
                $results['id']
            );
            $cards_users = executeQueryAll('SELECT * FROM cards_users_listing WHERE card_id = ?', $qry_val_arr);
            foreach ($cards_users as $cards_user) {
                $results['cards_users'][] = $cards_user;
            }
            if (!empty($args['labels'])) {
                $args['card_labels'] = $args['labels'];
            }
            if (!empty($args['card_labels'])) {
                $label_names = explode(',', $args['card_labels']);
                foreach ($label_names as $label_name) {
                    $qry_val_arr = array(
                        $label_name
                    );
                    $s_result = executeQuery('SELECT id FROM labels WHERE name = ?', $qry_val_arr);
                    $label = $s_result;
                    if (empty($label)) {
                        $qry_val_arr = array(
                            $label_name
                        );
                        $s_result = executeQuery($s_sql = 'INSERT INTO labels (created, modified, name) VALUES (now(), now(), ?) RETURNING id', $qry_val_arr);
                        $label = $s_result;
                    }
                    $args['label_id'] = $label['id'];
                    $args['card_id'] = $row['id'];
                    $args['list_id'] = $row['list_id'];
                    $args['board_id'] = $row['board_id'];
                    $qry_val_arr = array(
                        $args['card_id'],
                        $args['label_id'],
                        $args['board_id'],
                        $args['list_id']
                    );
                    executeQueryAll('INSERT INTO cards_labels (created, modified, card_id, label_id, board_id, list_id) VALUES (now(), now(), ?, ?, ?, ?) RETURNING *', $qry_val_arr);
                }
                $comment = '##USER_NAME## added label(s) to this card ##CARD_LINK## - ##LABEL_NAME##';
                insertActivity($authUser['id'], $comment, 'add_card_label', $foreign_ids, null, $args['label_id']);
            }
            $qry_val_arr = array(
                $results['id']
            );
            $cards_labels = executeQueryAll('SELECT * FROM cards_labels_listing WHERE card_id = ?', $qry_val_arr);
            foreach ($cards_labels as $cards_label) {
                $results['cards_labels'][] = $cards_label;
            }
        }
    }
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->POST('/api/v1/boards/{boardId}/lists/{listId}/cards/{cardId}/users/{userId}.json', function ($request, $response, $args)
{
    global $authUser;
    $args = $request->getParsedBody();
    $r_resource_vars['users'] = $request->getAttribute('userId');
    $r_resource_vars['cards'] = $request->getAttribute('cardId');
    $r_resource_vars['boards'] = $request->getAttribute('boardId');
    $r_resource_vars['lists'] = $request->getAttribute('listId');
    $pg_params = array();
    $is_return_vlaue = true;
    $table_name = 'cards_users';
    unset($args['board_id']);
    unset($args['list_id']);
    unset($args['is_offline']);
    unset($args['profile_picture_path']);
    unset($args['username']);
    unset($args['initials']);
    $qry_val_arr = array(
        $r_resource_vars['cards'],
        $r_resource_vars['users']
    );
    $check_already_added = executeQuery('SELECT * FROM cards_users WHERE card_id = ? AND user_id = ?', $qry_val_arr);
    if (!empty($check_already_added)) {
        $results['id'] = $check_already_added['id'];
        $results['cards_users'] = $check_already_added;
    } else {
        $sql = true;
        if (!empty($sql)) {
            $post = getbindValues($table_name, $args);
            $result = executeInsertQuery($table_name, $post);
            if ($result) {
                $row = $result;
                $results['id'] = $row['id'];
                if ($is_return_vlaue) {
                    $row = convertBooleanValues($table_name, $row);
                    $results[$table_name] = $row;
                }
                $qry_val_arr = array(
                    $args['card_id'],
                    $args['user_id']
                );
                $sel_query = 'SELECT cu.card_id, cu.user_id, users.username, c.board_id, c.list_id, b.name as board_name FROM cards_users cu LEFT JOIN cards c ON cu.card_id = c.id LEFT JOIN users ON cu.user_id = users.id LEFT JOIN boards b ON c.board_id = b.id WHERE cu.card_id = ? AND cu.user_id = ?';
                $get_details = executeQueryAll($sel_query, $qry_val_arr);
                $sel_details = $get_details;
                $foreign_ids['board_id'] = $sel_details['board_id'];
                $foreign_ids['list_id'] = $sel_details['list_id'];
                $foreign_ids['card_id'] = $args['card_id'];
                $comment = '##USER_NAME## added "' . $sel_details['username'] . '" as member to this card ##CARD_LINK##';
                $results['activity'] = insertActivity($authUser['id'], $comment, 'add_card_user', $foreign_ids, '', $results['id']);
            }
        }
    }
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->POST('/api/v1/boards/{boardId}/lists/{listId}/cards/{cardId}/copy.json', function ($request, $response, $args)
{
    global $authUser;
    $args = $request->getParsedBody();
    $r_resource_vars['cards'] = $request->getAttribute('cardId');
    $r_resource_vars['boards'] = $request->getAttribute('boardId');
    $r_resource_vars['lists'] = $request->getAttribute('listId');
    $is_keep_attachment = false;
    $is_return_vlaue = true;
    $args['user_id'] = $authUser['id'];
    $table_name = 'cards';
    if (isset($args['keep_attachments'])) {
        $is_keep_attachment = $args['keep_attachments'];
        unset($args['keep_attachments']);
    }
    if (isset($args['keep_activities'])) {
        $is_keep_activity = $args['keep_activities'];
        unset($args['keep_activities']);
    }
    if (isset($args['keep_labels'])) {
        $is_keep_label = $args['keep_labels'];
        unset($args['keep_labels']);
    }
    if (isset($args['keep_users'])) {
        $is_keep_user = $args['keep_users'];
        unset($args['keep_users']);
    }
    if (isset($args['keep_checklists'])) {
        $is_keep_checklist = $args['keep_checklists'];
        unset($args['keep_checklists']);
    }
    $copied_card_id = $r_resource_vars['cards'];
    unset($args['copied_card_id']);
    $qry_val_arr = array(
        $copied_card_id
    );
    $sresult = executeQueryAll('SELECT * FROM cards WHERE id = ?', $qry_val_arr);
    $srow = $sresult[0];
    unset($srow['id']);
    $card_name = $args['name'];
    $args = array_merge($srow, $args);
    $args['name'] = $card_name;
    $conditions = array(
        $args['list_id'],
        '0'
    );
    $list_card_objs = executeQueryAll('SELECT * FROM cards_listing WHERE list_id = ? AND is_archived = ? ORDER BY position ASC', $conditions);
    $list_cards = array();
    $h = 1;
    foreach ($list_card_objs as $card) {
        $list_cards[$h] = $card;
        $h++;
    }
    if (isset($list_cards[$args['position']]) && isset($list_cards[$args['position'] - 1])) {
        $args['position'] = ($list_cards[$args['position']]['position'] + $list_cards[$args['position'] - 1]['position']) / 2;
    } else if (!isset($list_cards[$args['position']]) && isset($list_cards[$args['position'] - 1])) {
        $args['position'] = $list_cards[$args['position'] - 1]['position'] + 1;
    } else if (isset($list_cards[$args['position']]) && !isset($list_cards[$args['position'] - 1])) {
        $args['position'] = $list_cards[$args['position']]['position'] / 2;
    } else if (!isset($list_cards[$args['position']]) && !isset($list_cards[$args['position'] - 1])) {
        $args['position'] = 1;
    }
    $sql = true;
    if (!empty($sql)) {
        $post = getbindValues($table_name, $args);
        $result = executeInsertQuery($table_name, $post);
        if ($result) {
            $row = $result;
            $results['id'] = $row['id'];
            if ($is_return_vlaue) {
                $row = convertBooleanValues($table_name, $row);
                $results[$table_name] = $row;
            }
            if ($is_keep_attachment) {
                $qry_val_arr = array(
                    $results['id'],
                    $args['list_id'],
                    $args['board_id'],
                    $copied_card_id
                );
                executeQueryAll('INSERT INTO card_attachments (created, modified, card_id, name, path, mimetype, list_id, board_id) SELECT created, modified, ?, name, path, mimetype, ?, ? FROM card_attachments WHERE card_id = ? ORDER BY id', $qry_val_arr);
            }
            if ($is_keep_user) {
                $qry_val_arr = array(
                    $results['id'],
                    $copied_card_id
                );
                executeQueryAll('INSERT INTO cards_users (created, modified, card_id, user_id) SELECT created, modified, ?, user_id  FROM cards_users WHERE card_id = ? ORDER BY id', $qry_val_arr);
            }
            if ($is_keep_label) {
                $qry_val_arr = array(
                    $results['id'],
                    $args['list_id'],
                    $args['board_id'],
                    $copied_card_id
                );
                executeQueryAll('INSERT INTO cards_labels (created, modified, card_id, label_id, list_id, board_id) SELECT created, modified, ?, label_id, ?, ? FROM cards_labels WHERE card_id = ? ORDER BY id', $qry_val_arr);
            }
            if ($is_keep_activity) {
                $qry_val_arr = array(
                    $results['id'],
                    $args['user_id'],
                    $args['list_id'],
                    $args['board_id'],
                    $copied_card_id
                );
                executeQueryAll('INSERT INTO activities (created, modified, card_id, user_id, list_id, board_id, foreign_id, type, comment, revisions, root, freshness_ts, depth, path, materialized_path) SELECT created, modified, ?, ?, ?, ?, foreign_id, type, comment, revisions, root, freshness_ts, depth, path, materialized_path FROM activities WHERE type = \'add_comment\' AND card_id = ? ORDER BY id', $qry_val_arr);
            }
            if ($is_keep_checklist) {
                $qry_val_arr = array(
                    $results['id'],
                    $copied_card_id
                );
                executeQueryAll('INSERT INTO checklists (created, modified, user_id, card_id, name, checklist_item_count, checklist_item_completed_count, position) SELECT created, modified, user_id, ?, name, checklist_item_count, checklist_item_completed_count, position FROM checklists WHERE card_id = ? ORDER BY id', $qry_val_arr);
                $qry_val_arr = array(
                    $results['id']
                );
                $checklists = executeQueryAll('SELECT id FROM checklists WHERE card_id = ?', $qry_val_arr);
                $qry_val_arr = array(
                    $copied_card_id
                );
                $prev_checklists = executeQueryAll('SELECT id FROM checklists WHERE card_id = ?', $qry_val_arr);
                $prev_checklist_ids = array();
                foreach ($prev_checklists as $prev_checklist_id) {
                    $prev_checklist_ids[] = $prev_checklist_id['id'];
                }
                $i = 0;
                foreach ($checklists as $checklist_id) {
                    $qry_val_arr = array(
                        $results['id'],
                        $checklist_id['id'],
                        $prev_checklist_ids[$i]
                    );
                    executeQueryAll('INSERT INTO checklist_items (created, modified, user_id, card_id, name, checklist_id, is_completed, position) SELECT created, modified, user_id, ?, name , ?, is_completed, position FROM checklist_items WHERE checklist_id = ? ORDER BY id', $qry_val_arr);
                    $i++;
                }
            }
            $foreign_ids['board_id'] = $args['board_id'];
            $foreign_ids['list_id'] = $args['list_id'];
            $foreign_ids['card_id'] = $results['id'];
            $comment = '##USER_NAME## copied this card "' . $srow['name'] . '" to ##CARD_NAME##';
            $results['activity'] = insertActivity($authUser['id'], $comment, 'copy_card', $foreign_ids, null, $results['id']);
            $qry_val_arr = array(
                $results['id']
            );
            $results['cards'] = executeQuery('SELECT * FROM cards_listing WHERE id = ?', $qry_val_arr);
            if (!empty($results['cards']['cards_checklists'])) {
                $results['cards']['cards_checklists'] = json_decode($results['cards']['cards_checklists'], true);
            }
            if (!empty($results['cards']['cards_users'])) {
                $results['cards']['cards_users'] = json_decode($results['cards']['cards_users'], true);
            }
            if (!empty($results['cards']['cards_voters'])) {
                $results['cards']['cards_voters'] = json_decode($results['cards']['cards_voters'], true);
            }
            if (!empty($results['cards']['cards_subscribers'])) {
                $results['cards']['cards_subscribers'] = json_decode($results['cards']['cards_subscribers'], true);
            }
            if (!empty($results['cards']['cards_labels'])) {
                $results['cards']['cards_labels'] = json_decode($results['cards']['cards_labels'], true);
            }
            $qry_val_arr = array(
                $results['id']
            );
            $activities = executeQuery('SELECT ( SELECT array_to_json(array_agg(row_to_json(cl.*))) AS array_to_json  FROM ( SELECT activities_listing.* FROM activities_listing activities_listing WHERE (activities_listing.card_id = cards.id) ORDER BY activities_listing.id DESC) cl) AS activities FROM cards cards WHERE id = ?', $qry_val_arr);
            if (!empty($activities)) {
                $results['cards']['activities'] = json_decode($activities['activities'], true);
            }
            $qry_val_arr = array(
                $results['id']
            );
            $attachments = executeQueryAll('SELECT * FROM card_attachments WHERE card_id = ?', $qry_val_arr);
            foreach ($attachments as $attachment) {
                $results['cards']['attachments'][] = $attachment;
            }
        }
    }
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->POST('/api/v1/organizations/{organizationId}/users/{userId}.json', function ($request, $response, $args)
{
    global $authUser;
    $args = $request->getParsedBody();
    $r_resource_vars['users'] = $request->getAttribute('userId');
    $r_resource_vars['organizations'] = $request->getAttribute('organizationId');
    $pg_params = array();
    $table_name = 'organizations_users';
    $sql = true;
    $is_return_vlaue = true;
    $args['organization_id'] = $r_resource_vars['organizations'];
    $args['user_id'] = $r_resource_vars['users'];
    if (!empty($sql)) {
        $post = getbindValues($table_name, $args);
        $result = executeInsertQuery($table_name, $post);
        if ($result) {
            $row = $result;
            $results['id'] = $row['id'];
            if ($is_return_vlaue) {
                $row = convertBooleanValues($table_name, $row);
                $results[$table_name] = $row;
            }
            $qry_val_arr = array(
                $results['id']
            );
            $foreign_ids['organization_id'] = $args['organization_id'];
            $foreign_id = $results['id'];
            $comment = '##USER_NAME## added member to organization';
            $results['activity'] = insertActivity($authUser['id'], $comment, 'add_organization_user', $foreign_ids, null, $foreign_id);
            $results['organizations_users'] = executeQuery('SELECT * FROM organizations_users_listing WHERE id = ?', $qry_val_arr);
            $results['organizations_users']['boards_users'] = json_decode($results['organizations_users']['boards_users'], true);
            $qry_val_arr = array(
                $args['organization_id']
            );
            $boards = executeQueryAll('SELECT * FROM boards WHERE organization_id = ?', $qry_val_arr);
            foreach ($boards as $board) {
                if (!empty($board)) {
                    $qry_val_arr = array(
                        $board['id'],
                        $args['user_id']
                    );
                    $boards_users = executeQueryAll('SELECT * FROM boards_users WHERE board_id = ? AND user_id = ?', $qry_val_arr);
                    $boards_users = $boards_users;
                    if (empty($boards_users)) {
                        $qry_val_arr = array(
                            $board['id'],
                            $args['user_id'],
                            2
                        );
                        executeQueryAll('INSERT INTO boards_users (created, modified, board_id , user_id, board_user_role_id) VALUES (now(), now(), ?, ?, ?)', $qry_val_arr);
                    }
                }
            }
        }
    }
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->POST('/api/v1/organizations.json', function ($request, $response, $args)
{
    global $authUser;
    $args = $request->getParsedBody();
    $sql = true;
    $table_name = 'organizations';
    $args['user_id'] = (!empty($authUser['id'])) ? $authUser['id'] : 1;
    $args['organization_visibility'] = 2;
    if (!empty($sql)) {
        $post = getbindValues($table_name, $args);
        $result = executeInsertQuery($table_name, $post);
        if ($result) {
            $row = $result;
            $results['id'] = $row['id'];
            $qry_val_arr = array(
                $row['id'],
                $args['user_id'],
                1
            );
            executeQueryAll('INSERT INTO organizations_users (created, modified, organization_id , user_id, organization_user_role_id) VALUES (now(), now(), ?, ?, ?)', $qry_val_arr);
            $foreign_id['organization_id'] = $row['id'];
            $comment = '##USER_NAME## created organization "##ORGANIZATION_LINK##"';
            $results['activity'] = insertActivity($authUser['id'], $comment, 'add_organization', $foreign_id);
        }
    }
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->POST('/api/v1/organizations/{organizationId}/upload_logo.json', function ($request, $response, $args)
{
    global $authUser, $thumbsizes;
    $args = $request->getParsedBody();
    $r_resource_vars['organizations'] = $request->getAttribute('organizationId');
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
                    if (!empty($list)) {
                        if (file_exists($list[0])) {
                            unlink($list[0]);
                        }
                    }
                }
                foreach ($thumbsizes['Organization'] as $key => $value) {
                    $mediadir = APP_PATH . '/client/img/' . $key . '/Organization/' . $r_resource_vars['organizations'];
                    $list = glob($mediadir . '.*');
                    if (!empty($list)) {
                        if (file_exists($list[0])) {
                            unlink($list[0]);
                        }
                    }
                }
                $qry_val_arr = array(
                    $logo_url,
                    $r_resource_vars['organizations']
                );
                executeQueryAll('UPDATE organizations SET logo_url = ? WHERE id = ?', $qry_val_arr);
                $results['logo_url'] = $logo_url;
                $foreign_ids['organization_id'] = $r_resource_vars['organizations'];
                $comment = ((!empty($authUser['full_name'])) ? $authUser['full_name'] : $authUser['username']) . ' added attachment to this organization ##ORGANIZATION_LINK##';
                $results['activity'] = insertActivity($authUser['id'], $comment, 'add_organization_attachment', $foreign_ids);
            }
        } else {
            $results['error'] = 1;
        }
    }
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->POST('/api/v1/acl_links.json', function ($request, $response, $args)
{
    $args = $request->getParsedBody();
    $table_name = $args['table'];
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
        $args['acl_link_id'],
        $args['role_id']
    );
    $acl = executeQuery('SELECT * FROM ' . $table_name . ' WHERE ' . $colmns[$table_name][0] . ' = ? AND ' . $colmns[$table_name][1] . ' = ?', $qry_val_arr);
    if ($acl) {
        $qry_val_arr = array(
            $args['acl_link_id'],
            $args['role_id']
        );
        executeQueryAll('DELETE FROM ' . $table_name . ' WHERE ' . $colmns[$table_name][0] . ' = ? AND ' . $colmns[$table_name][1] . ' = ?', $qry_val_arr);
    } else {
        $qry_val_arr = array(
            $args['acl_link_id'],
            $args['role_id']
        );
        executeQueryAll('INSERT INTO ' . $table_name . ' (created, modified, ' . $colmns[$table_name][0] . ', ' . $colmns[$table_name][1] . ') VALUES(now(), now(), ?, ?)', $qry_val_arr);
    }
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->POST('/api/v1/apps/settings.json', function ($request, $response, $args)
{
    $args = $request->getParsedBody();
    $folder_name = $args['folder'];
    unset($args['folder']);
    $content = file_get_contents(APP_PATH . '/client/apps/' . $folder_name . '/app.json');
    $app = json_decode($content, true);
    if (isset($args['enable'])) {
        $app['enabled'] = $args['enable'];
    } else {
        foreach ($args as $key => $val) {
            if (!empty($app['settings'][$key]['is_encrypted'])) {
                if (!empty($val)) {
                    $value_encode = str_rot13($val);
                    $val = base64_encode($value_encode);
                } else {
                    break;
                }
            }
            $app['settings'][$key]['value'] = $val;
        }
    }
    $fh = fopen(APP_PATH . '/client/apps/' . $folder_name . '/app.json', 'w');
    fwrite($fh, json_encode($app, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES));
    fclose($fh);
    $results['success'] = 'App updated successfully';
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->POST('/api/v1/oauth/clients.json', function ($request, $response, $args)
{
    $args = $request->getParsedBody();
    $sql = true;
    $table_name = 'oauth_clients';
    $args['client_id'] = isClientIdAvailable();
    $args['client_secret'] = isClientSecretAvailable();
    $args['grant_types'] = 'client_credentials refresh_token authorization_code';
    if (!empty($sql)) {
        $post = getbindValues($table_name, $args);
        $result = executeInsertQuery($table_name, $post);
        if ($result) {
            $row = $result;
            $results['id'] = $row['id'];
        }
    }
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->POST('/api/v1/webhooks.json', function ($request, $response, $args)
{
    $args = $request->getParsedBody();
    $sql = true;
    $table_name = 'webhooks';
    if (!empty($sql)) {
        $post = getbindValues($table_name, $args);
        $result = executeInsertQuery($table_name, $post);
        if ($result) {
            $row = $result;
            $results['id'] = $row['id'];
        }
    }
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->POST('/api/v1/roles.json', function ($request, $response, $args)
{
    $args = $request->getParsedBody();
    $sql = true;
    $table_name = 'roles';
    if (!empty($sql)) {
        $post = getbindValues($table_name, $args);
        $result = executeInsertQuery($table_name, $post);
        if ($result) {
            $row = $result;
            $results['id'] = $row['id'];
        }
    }
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->POST('/api/v1/board_user_roles.json', function ($request, $response, $args)
{
    $args = $request->getParsedBody();
    $sql = true;
    $table_name = 'board_user_roles';
    if (!empty($sql)) {
        $post = getbindValues($table_name, $args);
        $result = executeInsertQuery($table_name, $post);
        if ($result) {
            $row = $result;
            $results['id'] = $row['id'];
        }
    }
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->POST('/api/v1/organization_user_roles.json', function ($request, $response, $args)
{
    $sql = true;
    $table_name = 'organization_user_roles';
    if (!empty($sql)) {
        $post = getbindValues($table_name, $args);
        $result = executeInsertQuery($table_name, $post);
        if ($result) {
            $row = $result;
            $results['id'] = $row['id'];
        }
    }
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->POST('/api/v1/oauth/token.json', function ($request, $response, $args)
{
    $args = $request->getParsedBody();
    $post_val = array(
        'grant_type' => 'authorization_code',
        'code' => $args['code'],
        'redirect_uri' => $args['redirect_uri'],
        'client_id' => OAUTH_CLIENTID,
        'client_secret' => OAUTH_CLIENT_SECRET
    );
    $results = getToken($post_val);
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->PUT('/api/v1/users/{userId}/activation.json', function ($request, $response, $args)
{
    $args = $request->getParsedBody();
    $r_resource_vars['users'] = $request->getAttribute('userId');
    $pg_params = array();
    $qry_val_arr = array(
        $args['id'],
        'false'
    );
    $user = executeQuery('SELECT * FROM users WHERE id = ? AND is_email_confirmed = ?', $qry_val_arr);
    if ($user && (md5($user['username']) == $args['hash'])) {
        $qry_val_arr = array(
            'true',
            'true',
            $args['id']
        );
        $sql = executeQueryAll("UPDATE users SET is_email_confirmed = ?, is_active = ? WHERE id = ?", $qry_val_arr);
        if ($sql) {
            $emailFindReplace = array(
                '##NAME##' => $user['full_name'],
            );
            sendMail('welcome', $emailFindReplace, $user['email']);
            $results['success'] = 'Your activation has been confirmed . You can now login to the site';
        } else {
            $results['error'] = 'Invalid Activation URL';
        }
    } else {
        $results['error'] = 'Invalid Activation URL';
    }
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->PUT('/api/v1/users/{userId}.json', function ($request, $response, $args)
{
    global $authUser;
    $args = $request->getParsedBody();
    $r_resource_vars['users'] = $request->getAttribute('userId');
    $pg_params = array();
    $table_name = 'users';
    $id = $r_resource_vars['users'];
    $comment = '##USER_NAME## updated the profile.';
    $activity_type = 'update_profile';
    if (isset($args['profile_picture_path'])) {
        $comment = '##USER_NAME## deleted the profile image';
        $activity_type = 'delete_profile_attachment';
    } else if (isset($args['role_id'])) {
        $qry_val_arr = array(
            $r_resource_vars['users']
        );
        $activity_type = 'change_user_permission';
        $s_result = executeQuery('SELECT username FROM users WHERE id = ?', $qry_val_arr);
        $username = $s_result;
        $comment = '##USER_NAME## changed the user permission for "' . $username['username'] . '"';
        $foreign_id['user_id'] = $r_resource_vars['users'];
    } else if (isset($args['is_productivity_beats'])) {
        $activity_type = 'productivity_beat_update';
    } else if (isset($args['is_active'])) {
        $activity_type = 'user_activation';
        $is_active = ($args['is_active']) ? 'activated' : 'inactivated';
        $qry_val_arr = array(
            $r_resource_vars['users']
        );
        $s_result = executeQuery('SELECT username FROM users WHERE id = ?', $qry_val_arr);
        $username = $s_result;
        $comment = '##USER_NAME## ' . $is_active . ' ' . $username['username'] . '';
        $foreign_id['user_id'] = $r_resource_vars['users'];
    } else if (isset($args['last_activity_id']) || isset($args['language'])) {
        $comment = '';
        $results['success'] = 'Language changed successfully.';
    }
    $foreign_ids['user_id'] = $authUser['id'];
    $results = update_query($table_name, $id, '', $args, $comment, $activity_type, $foreign_ids);
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->PUT('/api/v1/email_templates/{emailTemplateId}.json', function ($request, $response, $args)
{
    $args = $request->getParsedBody();
    $r_resource_vars['email_templates'] = $request->getAttribute('emailTemplateId');
    $json = true;
    $table_name = 'email_templates';
    $id = $r_resource_vars['email_templates'];
    $results['success'] = 'Email Template has been updated successfully.';
    $results = update_query($table_name, $id, $r_resource_cmd, $args);
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->PUT('/api/v1/oauth/clients/{clientId}.json', function ($request, $response, $args)
{
    $args = $request->getParsedBody();
    $r_resource_vars['clients'] = $request->getAttribute('clientId');
    $json = true;
    $table_name = 'oauth_clients';
    $id = $r_resource_vars['clients'];
    $results['success'] = 'Client has been updated successfully.';
    $results = update_query($table_name, $id, $r_resource_cmd, $args);
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->PUT('/api/v1/boards_users/{boardUserId}.json', function ($request, $response, $args)
{
    $args = $request->getParsedBody();
    $r_resource_vars['boards_users'] = $request->getAttribute('boardUserId');
    $json = true;
    $table_name = 'boards_users';
    $id = $r_resource_vars['boards_users'];
    $qry_val_arr = array(
        $r_resource_vars['boards_users']
    );
    executeQuery('SELECT id FROM ' . $table_name . ' WHERE id =  ?', $qry_val_arr);
    $results = update_query($table_name, $id, $r_resource_cmd, $args);
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->PUT('/api/v1/boards/{boardId}.json', function ($request, $response, $args)
{
    $args = $request->getParsedBody();
    $r_resource_vars['boards'] = $request->getAttribute('boardId');
    $table_name = 'boards';
    $id = $r_resource_vars['boards'];
    $qry_val_arr = array(
        $r_resource_vars['boards']
    );
    $previous_value = executeQuery('SELECT * FROM ' . $table_name . ' WHERE id = ?', $qry_val_arr);
    $board_visibility = array(
        'Private',
        'Organization',
        'Public'
    );
    $foreign_ids['board_id'] = $r_resource_vars['boards'];
    if (isset($args['default_email_list_id']) || isset($args['is_default_email_position_as_bottom'])) {
        $comment = '';
    } else if (isset($args['board_visibility'])) {
        $comment = '##USER_NAME## changed visibility to ' . $board_visibility[$args['board_visibility']];
        $activity_type = 'change_visibility';
    } else if (!empty($args['is_closed'])) {
        $comment = '##USER_NAME## closed ##BOARD_NAME## board.';
        $activity_type = 'reopen_board';
    } else if (isset($args['is_closed'])) {
        $comment = '##USER_NAME## reopened ##BOARD_NAME## board.';
        $activity_type = 'reopen_board';
    } else if (isset($args['name'])) {
        $comment = '##USER_NAME## renamed ##BOARD_NAME## board.';
        $activity_type = 'edit_board';
    } else if (isset($args['background_picture_url']) || isset($args['background_pattern_url']) || isset($args['background_color'])) {
        if (empty($previous_value['background_picture_url']) && empty($previous_value['background_pattern_url']) && empty($previous_value['background_color'])) {
            $comment = '##USER_NAME## added background to board "' . $previous_value['name'] . '"';
            $activity_type = 'add_background';
        } else {
            $comment = '##USER_NAME## changed backgound to board "' . $previous_value['name'] . '"';
            $activity_type = 'change_background';
        }
    } else if (isset($args['music_name']) && !empty($args['music_content'])) {
        $comment = '##USER_NAME## updated the beats on ##BOARD_NAME## board.';
    }
    if (!empty($args['organization_id'])) {
        $qry_val_arr = array(
            $args['organization_id']
        );
        $organizations_users = executeQueryAll('SELECT user_id FROM organizations_users WHERE organization_id = ?', $qry_val_arr);
        foreach ($organizations_users as $organizations_user) {
            if (!empty($organizations_user)) {
                $qry_val_arr = array(
                    $r_resource_vars['boards'],
                    $organizations_user['user_id']
                );
                $boards_users = executeQueryAll('SELECT * FROM boards_users WHERE board_id = ? AND user_id = ?', $qry_val_arr);
                $boards_users = $boards_users;
                if (empty($boards_users)) {
                    $qry_val_arr = array(
                        $r_resource_vars['boards'],
                        $organizations_user['user_id'],
                        2
                    );
                    executeQueryAll('INSERT INTO boards_users (created, modified, board_id , user_id, board_user_role_id) VALUES (now(), now(), ?, ?, ?)', $qry_val_arr);
                }
            }
        }
    }
    $results = update_query($table_name, $id, '', $args, $comment, $activity_type, $foreign_ids);
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->PUT('/api/v1/boards/{boardId}/lists/{listId}.json', function ($request, $response, $args)
{
    $args = $request->getParsedBody();
    $r_resource_vars['boards'] = $request->getAttribute('boardId');
    $r_resource_vars['lists'] = $request->getAttribute('listId');
    $json = true;
    $table_name = 'lists';
    $id = $r_resource_vars['lists'];
    if (isset($args['position']) || isset($args['is_archived'])) {
        $qry_val_arr = array(
            $r_resource_vars['lists']
        );
        $s_sql = 'SELECT name, board_id, position FROM ' . $table_name . ' WHERE id = ?';
        $s_result = executeQuery($s_sql, $qry_val_arr);
        $previous_value = $s_result;
    }
    $foreign_ids['board_id'] = $r_resource_vars['boards'];
    $foreign_ids['list_id'] = $r_resource_vars['lists'];
    if (isset($args['board_id']) && !empty($args['board_id'])) {
        $qry_val_arr = array(
            $args['board_id'],
            $r_resource_vars['lists']
        );
        executeQueryAll('UPDATE cards SET board_id = ? WHERE list_id = ?', $qry_val_arr);
        $qry_val_arr = array(
            $args['board_id'],
            $r_resource_vars['lists']
        );
        executeQueryAll('UPDATE card_attachments SET board_id = ? WHERE list_id = ?', $qry_val_arr);
    }
    if (isset($args['position'])) {
        $comment = '##USER_NAME## changed list ' . $previous_value['name'] . ' position.';
        $activity_type = 'change_list_position';
    } else if (isset($previous_value) && isset($args['is_archived'])) {
        $id = $r_resource_vars['lists'];
        $foreign_ids['board_id'] = $r_resource_vars['boards'];
        $foreign_ids['list_id'] = $r_resource_vars['lists'];
        $comment = '##USER_NAME## archived ##LIST_NAME##';
        $activity_type = 'archive_list';
    } else if (isset($args['custom_fields'])) {
        $comment = '##USER_NAME## auto archived ##LIST_NAME## - ' . $args['custom_fields'];
    } else {
        $id = $r_resource_vars['lists'];
        $comment = '##USER_NAME## renamed this list.';
        $activity_type = 'edit_list';
    }
    $results = update_query($table_name, $id, '', $args, $comment, $activity_type, $foreign_ids);
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->PUT('/api/v1/boards/{boardId}/lists/{listId}/cards.json', function ($request, $response, $args)
{
    $args = $request->getParsedBody();
    $r_resource_vars['boards'] = $request->getAttribute('boardId');
    $r_resource_vars['lists'] = $request->getAttribute('listId');
    $json = true;
    $table_name = 'cards';
    $id = $r_resource_vars['lists'];
    $foreign_ids['board_id'] = $r_resource_vars['boards'];
    $foreign_ids['list_id'] = $r_resource_vars['lists'];
    $qry_val_arr = array(
        $foreign_ids['list_id']
    );
    $old_list = executeQuery('SELECT name FROM lists WHERE id = ?', $qry_val_arr);
    if (!empty($args['list_id'])) {
        $qry_val_arr = array(
            $args['list_id'],
            $foreign_ids['list_id']
        );
        executeQueryAll('UPDATE card_attachments SET list_id = ? WHERE list_id = ?', $qry_val_arr);
        $qry_val_arr = array(
            $args['list_id'],
            $foreign_ids['list_id']
        );
        executeQueryAll('UPDATE cards_labels SET list_id = ? WHERE list_id = ?', $qry_val_arr);
        $qry_val_array = array(
            $args['list_id']
        );
        $new_list = executeQuery('SELECT name FROM lists WHERE id =  ?', $qry_val_array);
        $comment = '##USER_NAME## moved cards FROM ' . $old_list['name'] . ' to ' . $new_list['name'];
        $activity_type = 'moved_list_card';
        $revisions['old_value']['list_id'] = $foreign_ids['list_id'];
        $revisions['new_value'] = $args;
    } else if (isset($args['is_archived']) && !empty($args['is_archived'])) {
        $comment = '##USER_NAME## archived cards in ' . $old_list['name'];
        $activity_type = 'archived_card';
    } else {
        $comment = '##USER_NAME## edited ' . $old_list['name'] . ' card in this board.';
        $activity_type = 'edit_card';
    }
    $results = update_query($table_name, $id, $r_resource_cmd, $args, $comment, $activity_type, $foreign_ids);
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->PUT('/api/v1/boards/{boardId}/lists/{listId}/cards/{cardId}.json', function ($request, $response, $args)
{
    $args = $request->getParsedBody();
    $r_resource_vars['boards'] = $request->getAttribute('boardId');
    $r_resource_vars['lists'] = $request->getAttribute('listId');
    $r_resource_vars['cards'] = $request->getAttribute('cardId');
    $table_name = 'cards';
    $comment = '';
    $id = $r_resource_vars['cards'];
    $foreign_ids['board_id'] = !empty($args['board_id']) ? $args['board_id'] : $r_resource_vars['boards'];
    $foreign_ids['list_id'] = $r_resource_vars['lists'];
    $foreign_ids['card_id'] = $r_resource_vars['cards'];
    $activity_type = 'edit_card';
    $qry_val_arr = array(
        $r_resource_vars['cards']
    );
    $s_result = executeQuery('SELECT name, board_id, list_id, position, description, custom_fields, due_date FROM ' . $table_name . ' WHERE id = ?', $qry_val_arr);
    $previous_value = $s_result;
    if (!empty($previous_value['custom_fields'])) {
        $custom_decode = json_decode($previous_value['custom_fields'], true);
        $present_custom_decode = json_decode($args['custom_fields'], true);
        $final_custom_array = array_merge($custom_decode, $present_custom_decode);
        $custom_field_encode = json_encode($final_custom_array);
        $args['custom_fields'] = $custom_field_encode;
    }
    $current_list_id = $previous_value['list_id'];
    if (isset($args['position'])) {
        if (!empty($args['list_id'])) {
            $current_list_id = $args['list_id'];
            $foreign_ids['list_id'] = $args['list_id'];
            $new_board_id = !empty($args['board_id']) ? $args['board_id'] : $r_resource_vars['boards'];
            $qry_val_arr = array(
                $args['list_id'],
                $new_board_id,
                $foreign_ids['card_id']
            );
            executeQueryAll('UPDATE card_attachments SET list_id = ?, board_id = ? WHERE card_id = ?', $qry_val_arr);
        }
        $qry_val_arr = array(
            $current_list_id
        );
        $current_list_name = executeQuery('SELECT name FROM lists WHERE id =  ?', $qry_val_arr);
        $comment = '##USER_NAME## moved the card ##CARD_LINK## to ' . $current_list_name['name'];
        $activity_type = 'change_card_position';
        if (!empty($args['list_id'])) {
            $foreign_ids['list_id'] = $r_resource_vars['lists'];
            $activity_type = 'move_card';
        }
    }
    if (isset($previous_value) && isset($args['is_archived'])) {
        if ($args['is_archived']) {
            $comment = '##USER_NAME## archived ' . $previous_value['name'];
        } else {
            $comment = '##USER_NAME## send back ' . $previous_value['name'] . ' to board';
        }
        $foreign_ids['board_id'] = $r_resource_vars['boards'];
        $foreign_ids['list_id'] = $r_resource_vars['lists'];
        $activity_type = 'archived_card';
    }
    if (isset($args['due_date']) && $args['due_date'] != 'NULL') {
        if (isset($previous_value['due_date']) && ($previous_value['due_date'] != 'null' && $previous_value['due_date'] != '')) {
            $comment = 'Due date was updated to this card ##CARD_LINK##';
            $activity_type = 'edit_card_duedate';
        } else {
            $comment = '##USER_NAME## set due date to this card ##CARD_LINK##';
            $activity_type = 'add_card_duedate';
        }
    } else if (isset($args['due_date'])) {
        $comment = 'Due date was removed to this card ##CARD_LINK##';
        $activity_type = 'delete_card_duedate';
    }
    if (isset($previous_value['board_id']) && isset($args['board_id']) && $args['board_id'] != $previous_value['board_id']) {
        $comment = '##USER_NAME## moved the card ##CARD_LINK## to different board.';
    }
    if (isset($previous_value['name']) && isset($args['name']) && $args['name'] != $previous_value['name']) {
        $comment = '##USER_NAME## renamed ##CARD_LINK##';
    }
    if (!isset($previous_value['description']) && isset($args['description'])) {
        $comment = '##USER_NAME## added card description in ##CARD_LINK## - ##DESCRIPTION##';
        $activity_type = 'add_card_desc';
    } else if (isset($previous_value) && isset($args['description']) && $args['description'] != $previous_value['description']) {
        if (empty($args['description'])) {
            $comment = '##USER_NAME## removed description from ##CARD_LINK##';
        } else {
            $comment = '##USER_NAME## updated description on ##CARD_LINK## - ##DESCRIPTION##';
        }
        $activity_type = 'edit_card_desc';
    }
    if (isset($previous_value['list_id']) && isset($args['list_id']) && $args['list_id'] != $previous_value['list_id']) {
        $qry_val_arr = array(
            $args['list_id']
        );
        $s_result = executeQuery('SELECT name FROM lists WHERE id = ?', $qry_val_arr);
        $list_value = $s_result;
        $qry_val_arr = array(
            $previous_value['list_id']
        );
        $s_result = executeQuery('SELECT name FROM lists WHERE id = ?', $qry_val_arr);
        $previous_list_value = $s_result;
        $comment = '##USER_NAME## moved this card ##CARD_LINK## from ' . $previous_list_value['name'] . ' list to ' . $list_value['name'] . '.';
    }
    unset($args['start']);
    $results = update_query($table_name, $id, '', $args, $comment, $activity_type, $foreign_ids);
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->PUT('/api/v1/boards/{boardId}/lists/{listId}/cards/{cardId}/comments/{commentId}.json', function ($request, $response, $args)
{
    $args = $request->getParsedBody();
    $r_resource_vars['boards'] = $request->getAttribute('boardId');
    $r_resource_vars['lists'] = $request->getAttribute('listId');
    $r_resource_vars['cards'] = $request->getAttribute('cardId');
    $r_resource_vars['comments'] = $request->getAttribute('commentId');
    $table_name = 'activities';
    $id = $r_resource_vars['comments'];
    $foreign_ids['board_id'] = $r_resource_vars['boards'];
    $foreign_ids['list_id'] = $r_resource_vars['lists'];
    $foreign_ids['card_id'] = $r_resource_vars['cards'];
    $comment = '##USER_NAME## updated comment to this card ##CARD_LINK##';
    $activity_type = 'update_card_comment';
    $results = update_query($table_name, $id, $r_resource_cmd, $args, $comment, $activity_type, $foreign_ids);
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->PUT('/api/v1/boards/{boardId}/lists/{listId}/cards/{cardId}/checklists/{checklistId}.json', function ($request, $response, $args)
{
    $args = $request->getParsedBody();
    $r_resource_vars['boards'] = $request->getAttribute('boardId');
    $r_resource_vars['lists'] = $request->getAttribute('listId');
    $r_resource_vars['cards'] = $request->getAttribute('cardId');
    $r_resource_vars['checklists'] = $request->getAttribute('checklistId');
    $table_name = 'checklists';
    $id = $r_resource_vars['checklists'];
    $foreign_ids['board_id'] = $r_resource_vars['boards'];
    $foreign_ids['list_id'] = $r_resource_vars['lists'];
    $foreign_ids['card_id'] = $r_resource_vars['cards'];
    $comment = '##USER_NAME## updated checklist of card "##CARD_LINK##"';
    unset($args['checklists_items']);
    unset($args['created']);
    unset($args['modified']);
    unset($args['checklist_item_completed_count']);
    unset($args['checklist_item_count']);
    unset($args['is_offline']);
    unset($args['list_id']);
    unset($args['board_id']);
    if (isset($args['position']) && !empty($args['position'])) {
        $comment.= ' position';
    }
    $activity_type = 'update_card_checklist';
    $results = update_query($table_name, $id, $r_resource_cmd, $args, $comment, $activity_type, $foreign_ids);
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->PUT('/api/v1/boards/{boardId}/lists/{listId}/cards/{cardId}/checklists/{checklistId}/items/{itemId}.json', function ($request, $response, $args)
{
    $args = $request->getParsedBody();
    $r_resource_vars['boards'] = $request->getAttribute('boardId');
    $r_resource_vars['lists'] = $request->getAttribute('listId');
    $r_resource_vars['cards'] = $request->getAttribute('cardId');
    $r_resource_vars['checklists'] = $request->getAttribute('checklistId');
    $r_resource_vars['items'] = $request->getAttribute('itemId');
    $table_name = 'checklist_items';
    $id = $r_resource_vars['items'];
    $comment = '';
    $foreign_ids['board_id'] = $r_resource_vars['boards'];
    $foreign_ids['list_id'] = $r_resource_vars['lists'];
    $foreign_ids['card_id'] = $r_resource_vars['cards'];
    unset($args['created']);
    unset($args['modified']);
    unset($args['is_offline']);
    unset($args['list_id']);
    unset($args['board_id']);
    $qry_val_arr = array(
        $r_resource_vars['items']
    );
    $prev_value = executeQuery('SELECT * FROM ' . $table_name . ' WHERE id =  ?', $qry_val_arr);
    $activity_type = 'update_card_checklist_item';
    if (!empty($args['is_completed'])) {
        $comment = '##USER_NAME## updated ##CHECKLIST_ITEM_NAME## as completed on card ##CARD_LINK##';
    } else if (isset($args['position'])) {
        $comment = '##USER_NAME## moved checklist item on card ##CARD_LINK##';
        if (isset($args['checklist_id']) && $args['checklist_id'] != $prev_value['checklist_id']) {
            $activity_type = 'moved_card_checklist_item';
        }
    } else if (isset($args['is_completed']) && $args['is_completed'] == 'false') {
        $comment = '##USER_NAME## updated ##CHECKLIST_ITEM_NAME## as incomplete on card ##CARD_LINK##';
    } else {
        $comment = '##USER_NAME## updated item name as ##CHECKLIST_ITEM_NAME## in card ##CARD_LINK##';
    }
    $results = update_query($table_name, $id, $r_resource_cmd, $args, $comment, $activity_type, $foreign_ids);
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->PUT('/api/v1/activities/undo/{Id}.json', function ($request, $response, $args)
{
    $args = $request->getParsedBody();
    $r_resource_vars['undo'] = $request->getAttribute('Id');
    $qry_val_arr = array(
        $r_resource_vars['undo']
    );
    $comment = '';
    $activity = executeQuery('SELECT * FROM activities WHERE id =  ?', $qry_val_arr);
    if (!empty($activity['revisions']) && trim($activity['revisions']) != '') {
        $revisions = unserialize($activity['revisions']);
        if ($activity['type'] == 'update_card_checklist_item') {
            $table_name = 'checklist_items';
            $id = $activity['foreign_id'];
            $args = $revisions['old_value'];
            $foreign_ids['board_id'] = $activity['board_id'];
            $foreign_ids['list_id'] = $activity['list_id'];
            $foreign_ids['card_id'] = $activity['card_id'];
            $comment = '##USER_NAME## undo this card ##CARD_LINK## checklist item ##CHECKLIST_ITEM_NAME##';
            $activity_type = 'update_card_checklist_item';
            $results['undo']['checklist_item'] = $args;
            $results['undo']['checklist_item']['id'] = $id;
        } else if ($activity['type'] == 'update_card_checklist') {
            $table_name = 'checklists';
            $id = $activity['foreign_id'];
            $args = $revisions['old_value'];
            $foreign_ids['board_id'] = $activity['board_id'];
            $foreign_ids['list_id'] = $activity['list_id'];
            $foreign_ids['card_id'] = $activity['card_id'];
            $comment = '##USER_NAME## undo this card ##CARD_LINK## checklist ##CHECKLIST_NAME##';
            $activity_type = 'update_card_checklist';
            $results['undo']['checklist'] = $args;
            $results['undo']['checklist']['id'] = $id;
        } else if ($activity['type'] == 'update_card_comment') {
            $table_name = 'activities';
            $id = $activity['foreign_id'];
            if (!is_array($revisions['old_value'])) {
                $args['comment'] = $revisions['old_value'];
            } else {
                $args = $revisions['old_value'];
            }
            $foreign_ids['board_id'] = $activity['board_id'];
            $foreign_ids['list_id'] = $activity['list_id'];
            $foreign_ids['card_id'] = $activity['card_id'];
            $comment = '##USER_NAME## undo this card ##CARD_LINK## comment';
            $activity_type = 'update_card_comment';
            $results['undo']['update_card_comment'] = $id;
            $results['undo']['card'] = $args;
            $results['undo']['card']['id'] = $activity['card_id'];
        } else if ($activity['type'] == 'delete_card_comment') {
            $table_name = 'activities';
            $id = $activity['foreign_id'];
            if (!is_array($revisions['old_value'])) {
                $args['comment'] = $revisions['old_value'];
            } else {
                $args = $revisions['old_value'];
            }
            $foreign_ids['board_id'] = $activity['board_id'];
            $foreign_ids['list_id'] = $activity['list_id'];
            $foreign_ids['card_id'] = $activity['card_id'];
            $comment = '##USER_NAME## undo this card ##CARD_LINK## comment';
            $activity_type = 'delete_card_comment';
            $results['undo']['delete_card_comment'] = $id;
            $results['undo']['card'] = $args;
            $results['undo']['card']['id'] = $activity['card_id'];
        } else if (!empty($activity['card_id'])) {
            $table_name = 'cards';
            $id = $activity['card_id'];
            $args = $revisions['old_value'];
            $foreign_ids['board_id'] = $activity['board_id'];
            $foreign_ids['list_id'] = $activity['list_id'];
            $foreign_ids['card_id'] = $activity['card_id'];
            $comment = '##USER_NAME## undo this card ##CARD_LINK##';
            $activity_type = (!empty($activity['type']) && $activity['type'] != 'edit_card') ? $activity['type'] : 'edit_card';
            $results['undo']['card'] = $args;
            $results['undo']['card']['id'] = $id;
        } else if (!empty($activity['list_id'])) {
            $table_name = 'lists';
            $id = $activity['list_id'];
            $args = $revisions['old_value'];
            $foreign_ids['board_id'] = $activity['board_id'];
            $foreign_ids['list_id'] = $activity['list_id'];
            $comment = '##USER_NAME## undo this list.';
            $activity_type = (!empty($activity['type']) && $activity['type'] != 'edit_list') ? $activity['type'] : 'edit_list';
            $results['undo']['list'] = $args;
            $results['undo']['list']['id'] = $id;
        } else if (!empty($activity['board_id'])) {
            $table_name = 'boards';
            $id = $activity['board_id'];
            $args = $revisions['old_value'];
            $foreign_ids['board_id'] = $activity['board_id'];
            $comment = '##USER_NAME## undo this board.';
            $activity_type = (!empty($activity['type']) && $activity['type'] != 'edit_board') ? $activity['type'] : 'edit_board';
            $results['undo']['board'] = $args;
            $results['undo']['board']['id'] = $id;
        }
    }
    $results = update_query($table_name, $id, $r_resource_cmd, $args, $comment, $activity_type, $foreign_ids);
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->PUT('/api/v1/boards/{boardId}/board_subscribers/{boardSubscriberId}.json', function ($request, $response, $args)
{
    $args = $request->getParsedBody();
    $r_resource_vars['boards'] = $request->getAttribute('boardId');
    $json = true;
    $table_name = 'board_subscribers';
    $id = $r_resource_vars['board_subscribers'];
    $results['success'] = 'Updated successfully.';
    $results['id'] = $id;
    $results = update_query($table_name, $id, $r_resource_cmd, $args);
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->PUT('/api/v1/boards/{boardId}/lists/{listId}/list_subscribers/{listSubscriberId}.json', function ($request, $response, $args)
{
    $args = $request->getParsedBody();
    $r_resource_vars['boards'] = $request->getAttribute('boardId');
    $r_resource_vars['lists'] = $request->getAttribute('listId');
    $r_resource_vars['list_subscribers'] = $request->getAttribute('listSubscriberId');
    $json = true;
    $table_name = 'list_subscribers';
    $id = $r_resource_vars['list_subscribers'];
    $results = update_query($table_name, $id, $r_resource_cmd, $args);
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->PUT('/api/v1/organizations/{organizationId}.json', function ($request, $response, $args)
{
    global $authUser, $thumbsizes;
    $args = $request->getParsedBody();
    $r_resource_vars['organizations'] = $request->getAttribute('organizationId');
    $json = true;
    $table_name = 'organizations';
    $id = $r_resource_vars['organizations'];
    $foreign_ids['organization_id'] = $r_resource_vars['organizations'];
    if (isset($args['logo_url']) && ($args['logo_url'] == 'null' || $args['logo_url'] == 'NULL')) {
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
        if (isset($args['name'])) {
            $comment = '##USER_NAME## edited "##ORGANIZATION_LINK##" organization.';
            $activity_type = 'edit_organization';
        } else if (isset($args['organization_visibility'])) {
            $comment = '##USER_NAME## changed organization visibility to ' . $organization_visibility[$args['organization_visibility']];
            $activity_type = 'change_visibility';
        }
    }
    $qry_val_arr = array(
        $r_resource_vars['organizations']
    );
    executeQuery('SELECT id FROM ' . $table_name . ' WHERE id = ?', $qry_val_arr);
    $results = update_query($table_name, $id, '', $args, $comment, $activity_type, $foreign_ids);
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->PUT('/api/v1/organizations_users/{organizationUserId}.json', function ($request, $response, $args)
{
    $args = $request->getParsedBody();
    $r_resource_vars['organizations_users'] = $request->getAttribute('organizationUserId');
    $json = true;
    $table_name = 'organizations_users';
    $id = $r_resource_vars['organizations_users'];
    $qry_val_arr = array(
        $r_resource_vars['organizations_users']
    );
    executeQuery('SELECT id FROM ' . $table_name . ' WHERE id =  ?', $qry_val_arr);
    $results = update_query($table_name, $id, '', $args);
    echo json_encode($results);
});
$app->PUT('/api/v1/webhooks/{webhookId}.json', function ($request, $response, $args)
{
    $args = $request->getParsedBody();
    $r_resource_vars['webhooks'] = $request->getAttribute('webhookId');
    $json = true;
    $table_name = 'webhooks';
    $id = $r_resource_vars['webhooks'];
    $results = update_query($table_name, $id, '', $args);
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->PUT('/api/v1/roles/{roleId}.json', function ($request, $response, $args)
{
    $args = $request->getParsedBody();
    $r_resource_vars['roles'] = $request->getAttribute('roleId');
    $json = true;
    $table_name = 'roles';
    $id = $r_resource_vars['roles'];
    $results = update_query($table_name, $id, '', $args);
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->PUT('/api/v1/board_user_roles/{boardUserRoleId}.json', function ($request, $response, $args)
{
    $args = $request->getParsedBody();
    $r_resource_vars['board_user_roles'] = $request->getAttribute('boardUserRoleId');
    $json = true;
    $table_name = 'board_user_roles';
    $id = $r_resource_vars['board_user_roles'];
    $results = update_query($table_name, $id, '', $args);
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->PUT('/api/v1/organization_user_roles/{organizationUserRoleId}.json', function ($request, $response, $args)
{
    $args = $request->getParsedBody();
    $r_resource_vars['organization_user_roles'] = $request->getAttribute('organizationUserRoleId');
    $json = true;
    $table_name = 'organization_user_roles';
    $id = $r_resource_vars['organization_user_roles'];
    $results = update_query($table_name, $id, $r_resource_cmd, $args);
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->DELETE('/api/v1/users/{userId}.json', function ($request, $response, $args)
{
    $r_resource_vars['users'] = $request->getAttribute('userId');
    $pg_params = array();
    $qry_val_arr = array(
        $r_resource_vars['users']
    );
    $s_result = executeQuery('SELECT username FROM users WHERE id = ?', $qry_val_arr);
    $username = $s_result;
    $foreign_id['user_id'] = $r_resource_vars['users'];
    $comment = '##USER_NAME## deleted "' . $username['username'] . '"';
    $results['activity'] = insertActivity($authUser['id'], $comment, 'delete_user', $foreign_id);
    $sql = 'DELETE FROM users WHERE id= ?';
    array_push($pg_params, $r_resource_vars['users']);
    if (is_plugin_enabled('r_chat') && $jabberHost) {
        xmppDeleteSingleUser($username);
    }
    $result = executeQueryAll($sql, $pg_params);
    $results['error'] = array(
        'code' => (!$result) ? 1 : 0
    );
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->DELETE('/api/v1/organizations/{organizationId}/organizations_users/{organizationUserId}.json', function ($request, $response, $args)
{
    global $authUser;
    $r_resource_vars['organizations'] = $request->getAttribute('organizationId');
    $r_resource_vars['organizations_users'] = $request->getAttribute('organizationUserId');
    $pg_params = array();
    $qry_val_arr = array(
        $r_resource_vars['organizations_users']
    );
    $s_result = executeQueryAll('SELECT username, organization_id, name, full_name FROM organizations_users_listing WHERE id = ?', $qry_val_arr);
    $previous_value = $s_result;
    $foreign_ids['organization_id'] = $previous_value['organization_id'];
    $comment = '##USER_NAME## removed member "' . $previous_value['full_name'] . '" from organization';
    $results['activity'] = insertActivity($authUser['id'], $comment, 'delete_organization_user', $foreign_ids, '', $r_resource_vars['organizations_users']);
    $sql = 'DELETE FROM organizations_users WHERE id= ?';
    $pg_params = array();
    array_push($pg_params, $r_resource_vars['organizations_users']);
    $qry_val_arr = array(
        $r_resource_vars['organizations_users']
    );
    $organizations_users_result = executeQueryAll('SELECT user_id FROM organizations_users_listing WHERE id = ?', $qry_val_arr);
    $organizations_users = $organizations_users_result;
    $conditions = array(
        $previous_value['organization_id'],
        $organizations_users['user_id']
    );
    executeQueryAll('DELETE FROM boards_users WHERE board_id IN (SELECT id FROM boards WHERE organization_id = ?) AND user_id = ?', $conditions);
    $result = executeQueryAll($sql, $pg_params);
    $results['error'] = array(
        'code' => (!$result) ? 1 : 0
    );
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->DELETE('/api/v1/boards/{boardId}/boards_users/{boardUserId}.json', function ($request, $response, $args)
{
    global $authUser;
    $r_resource_vars['boards'] = $request->getAttribute('boardId');
    $r_resource_vars['boards_users'] = $request->getAttribute('boardUserId');
    $qry_val_arr = array(
        $r_resource_vars['boards_users']
    );
    $s_result = executeQuery('SELECT username, full_name, board_id, user_id, board_name FROM boards_users_listing WHERE id = ?', $qry_val_arr);
    $previous_value = $s_result;
    $foreign_ids['board_id'] = $previous_value['board_id'];
    $comment = '##USER_NAME## removed member "' . $previous_value['username'] . '" from board';
    $results['activity'] = insertActivity($authUser['id'], $comment, 'delete_board_user', $foreign_ids, '', $r_resource_vars['boards_users']);
    $sql = 'DELETE FROM boards_users WHERE id= ?';
    $conditions = array(
        $previous_value['board_id']
    );
    $cards = executeQueryAll('SELECT id FROM cards WHERE board_id = ?', $conditions);
    foreach ($cards as $row) {
        $conditions = array(
            $row['id'],
            $previous_value['user_id']
        );
        executeQueryAll('DELETE FROM cards_users WHERE card_id = ? AND user_id = ?', $conditions);
    }
    $pg_params = array();
    array_push($pg_params, $r_resource_vars['boards_users']);
    if (is_plugin_enabled('r_chat') && $jabberHost) {
        xmppRevokeMember($previous_value);
    }
    $result = executeQueryAll($sql, $pg_params);
    $results['error'] = array(
        'code' => (!$result) ? 1 : 0
    );
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->DELETE('/api/v1/boards/{boardId}/lists/{listId}.json', function ($request, $response, $args)
{
    global $authUser;
    $r_resource_vars['boards'] = $request->getAttribute('boardId');
    $r_resource_vars['lists'] = $request->getAttribute('listId');
    $qry_val_arr = array(
        $r_resource_vars['lists']
    );
    $s_result = executeQuery('SELECT name, board_id, position FROM lists WHERE id = ?', $qry_val_arr);
    $previous_value = $s_result;
    $foreign_id['board_id'] = $r_resource_vars['boards'];
    $foreign_id['list_id'] = $r_resource_vars['lists'];
    $comment = '##USER_NAME## deleted "' . $previous_value['name'] . '"';
    $results['activity'] = insertActivity($authUser['id'], $comment, 'delete_list', $foreign_id);
    $sql = 'DELETE FROM lists WHERE id= ?';
    $pg_params = array();
    array_push($pg_params, $r_resource_vars['lists']);
    $result = executeQueryAll($sql, $pg_params);
    $results['error'] = array(
        'code' => (!$result) ? 1 : 0
    );
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->DELETE('/api/v1/boards/{boardId}/lists.json', function ($request, $response, $args)
{
    $r_resource_vars['boards'] = $request->getAttribute('boardId');
    $sql = 'DELETE FROM lists WHERE board_id = ? AND is_archived = true';
    $pg_params = array();
    array_push($pg_params, $r_resource_vars['boards']);
    $result = executeQueryAll($sql, $pg_params);
    $results['error'] = array(
        'code' => (!$result) ? 1 : 0
    );
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->DELETE('/api/v1/boards/{boardId}/cards.json', function ($request, $response, $args)
{
    $r_resource_vars['boards'] = $request->getAttribute('boardId');
    $sql = 'DELETE FROM cards WHERE board_id = ? AND is_archived = true';
    array_push($pg_params, $r_resource_vars['boards']);
    $result = executeQueryAll($sql, $pg_params);
    $results['error'] = array(
        'code' => (!$result) ? 1 : 0
    );
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->DELETE('/api/v1/organizations/{organizationId}.json', function ($request, $response, $args)
{
    global $authUser;
    $r_resource_vars['organizations'] = $request->getAttribute('organizationId');
    $pg_params = array();
    $foreign_id['organization_id'] = $r_resource_vars['organizations'];
    $comment = '##USER_NAME## deleted organization';
    $results['activity'] = insertActivity($authUser['id'], $comment, 'delete_organization', $foreign_id);
    $data = array(
        0,
        2,
        $foreign_id['organization_id']
    );
    executeQueryAll('UPDATE boards SET organization_id = ?, board_visibility = ? WHERE organization_id = ?', $data);
    $conditions = array(
        $foreign_id['organization_id']
    );
    $s_result = executeQuery('SELECT user_id FROM organizations WHERE id = ?', $conditions);
    $organization = $s_result;
    $conditions = array(
        $organization['user_id'],
        $foreign_id['organization_id']
    );
    executeQueryAll('DELETE FROM organizations_users WHERE user_id = ? AND organization_id = ?', $conditions);
    $sql = 'DELETE FROM organizations WHERE id= ?';
    array_push($pg_params, $r_resource_vars['organizations']);
    $result = executeQueryAll($sql, $pg_params);
    $results['error'] = array(
        'code' => (!$result) ? 1 : 0
    );
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->DELETE('/api/v1/boards/{boardId}/labels/{labelId}.json', function ($request, $response, $args)
{
    $r_resource_vars['boards'] = $request->getAttribute('boardId');
    $r_resource_vars['labels'] = $request->getAttribute('labelId');
    $pg_params = array();
    $sql = 'DELETE FROM cards_labels WHERE board_id = ? AND label_id = ?';
    array_push($pg_params, $r_resource_vars['boards'], $r_resource_vars['labels']);
    $result = executeQueryAll($sql, $pg_params);
    $results['error'] = array(
        'code' => (!$result) ? 1 : 0
    );
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->DELETE('/api/v1/boards/{boardId}/lists/{listId}/cards/{cardId}.json', function ($request, $response, $args)
{
    $r_resource_vars['boards'] = $request->getAttribute('boardId');
    $r_resource_vars['lists'] = $request->getAttribute('listId');
    $r_resource_vars['cards'] = $request->getAttribute('cardId');
    $pg_params = array();
    $qry_val_arr = array(
        $r_resource_vars['cards']
    );
    $s_result = executeQuery('SELECT name, board_id, position FROM cards WHERE id = ?', $qry_val_arr);
    $previous_value = $s_result;
    $foreign_id['board_id'] = $r_resource_vars['boards'];
    $foreign_id['list_id'] = $r_resource_vars['lists'];
    $foreign_id['card_id'] = $r_resource_vars['cards'];
    $comment = '##USER_NAME## deleted card ' . $previous_value['name'];
    $results['activity'] = insertActivity($authUser['id'], $comment, 'delete_card', $foreign_id);
    $sql = 'DELETE FROM cards WHERE id = ?';
    array_push($pg_params, $r_resource_vars['cards']);
    $result = executeQueryAll($sql, $pg_params);
    $results['error'] = array(
        'code' => (!$result) ? 1 : 0
    );
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->DELETE('/api/v1/boards/{boardId}/lists/{listId}/cards/{cardId}/card_voters/{cardVoterId}.json', function ($request, $response, $args)
{
    $r_resource_vars['boards'] = $request->getAttribute('boardId');
    $r_resource_vars['lists'] = $request->getAttribute('listId');
    $r_resource_vars['cards'] = $request->getAttribute('cardId');
    $r_resource_vars['card_voters'] = $request->getAttribute('cardVoterId');
    $pg_params = array();
    $sql = 'DELETE FROM card_voters WHERE id = ?';
    array_push($pg_params, $r_resource_vars['card_voters']);
    $foreign_ids['board_id'] = $r_resource_vars['boards'];
    $foreign_ids['list_id'] = $r_resource_vars['lists'];
    $foreign_ids['card_id'] = $r_resource_vars['cards'];
    $comment = '##USER_NAME## unvoted this card ##CARD_LINK##';
    $results['activity'] = insertActivity($authUser['id'], $comment, 'unvote_card', $foreign_ids, null, $r_resource_vars['card_voters']);
    $result = executeQueryAll($sql, $pg_params);
    $results['error'] = array(
        'code' => (!$result) ? 1 : 0
    );
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->DELETE('/api/v1/boards/{boardId}/lists/{listId}/cards/{cardId}/comments/{commentId}.json', function ($request, $response, $args)
{
    $r_resource_vars['boards'] = $request->getAttribute('boardId');
    $r_resource_vars['lists'] = $request->getAttribute('listId');
    $r_resource_vars['cards'] = $request->getAttribute('cardId');
    $r_resource_vars['comments'] = $request->getAttribute('commentId');
    $pg_params = array();
    $qry_val_arr = array(
        $r_resource_vars['comments']
    );
    $revisions = executeQuery('SELECT comment, revisions FROM activities WHERE id =  ? OR foreign_id = ? ORDER BY id desc limit 1', $qry_val_arr);
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
    $sql = 'DELETE FROM activities WHERE id = ?';
    array_push($pg_params, $r_resource_vars['comments']);
    $foreign_ids['board_id'] = $r_resource_vars['boards'];
    $foreign_ids['list_id'] = $r_resource_vars['lists'];
    $foreign_ids['card_id'] = $r_resource_vars['cards'];
    $results['activity'] = insertActivity($authUser['id'], $comment, 'delete_card_comment', $foreign_ids, $revisions_del, $r_resource_vars['comments']);
    if (!empty($results['activity']['revisions']) && trim($results['activity']['revisions']) != '') {
        $revisions = unserialize($results['activity']['revisions']);
    }
    if (!empty($revisions) && $results['activity']['type'] != 'moved_card_checklist_item') {
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
        } else if (!empty($revisions['old_value']) && isset($results['activity']['type']) && $results['activity']['type'] == 'delete_card_comment') {
            $diff[] = nl2br(getRevisiondifference($revisions['old_value'], ''));
        }
    }
    if (isset($diff)) {
        $results['activity']['difference'] = $diff;
    }
    $result = executeQueryAll($sql, $pg_params);
    $results['error'] = array(
        'code' => (!$result) ? 1 : 0
    );
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->DELETE('/api/v1/boards/{boardId}/lists/{listId}/cards/{cardId}/attachments/{attachmentId}.json', function ($request, $response, $args)
{
    global $authUser;
    $pg_params = array();
    $r_resource_vars['boards'] = $request->getAttribute('boardId');
    $r_resource_vars['lists'] = $request->getAttribute('listId');
    $r_resource_vars['cards'] = $request->getAttribute('cardId');
    $r_resource_vars['attachments'] = $request->getAttribute('attachmentId');
    $sql = 'DELETE FROM card_attachments WHERE id = ?';
    array_push($pg_params, $r_resource_vars['attachments']);
    $foreign_ids['board_id'] = $r_resource_vars['boards'];
    $foreign_ids['list_id'] = $r_resource_vars['lists'];
    $foreign_ids['card_id'] = $r_resource_vars['cards'];
    $comment = '##USER_NAME## deleted attachment from card ##CARD_LINK##';
    $results['activity'] = insertActivity($authUser['id'], $comment, 'delete_card_attachment', $foreign_ids, null, $r_resource_vars['attachments']);
    $result = executeQueryAll($sql, $pg_params);
    $results['error'] = array(
        'code' => (!$result) ? 1 : 0
    );
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->DELETE('/api/v1/boards/{boardId}/lists/{listId}/cards/{cardId}/checklists/{checklistId}.json', function ($request, $response, $args)
{
    $pg_params = array();
    $r_resource_vars['boards'] = $request->getAttribute('boardId');
    $r_resource_vars['lists'] = $request->getAttribute('listId');
    $r_resource_vars['cards'] = $request->getAttribute('cardId');
    $r_resource_vars['checklists'] = $request->getAttribute('checklistId');
    $qry_val_arr = array(
        $r_resource_vars['checklists']
    );
    $s_result = executeQuery('SELECT name FROM checklists WHERE id = ?', $qry_val_arr);
    $checklist = $s_result;
    executeQueryAll('DELETE FROM checklist_items WHERE checklist_id = ?', $qry_val_arr);
    $foreign_ids['board_id'] = $r_resource_vars['boards'];
    $foreign_ids['list_id'] = $r_resource_vars['lists'];
    $foreign_ids['card_id'] = $r_resource_vars['cards'];
    $comment = '##USER_NAME## deleted checklist ' . $checklist['name'] . ' from card ##CARD_LINK##';
    $results['activity'] = insertActivity($authUser['id'], $comment, 'delete_checklist', $foreign_ids, null, $r_resource_vars['checklists']);
    $sql = 'DELETE FROM checklists WHERE id = ?';
    array_push($pg_params, $r_resource_vars['checklists']);
    $result = executeQueryAll($sql, $pg_params);
    $results['error'] = array(
        'code' => (!$result) ? 1 : 0
    );
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->DELETE('/api/v1/boards/{boardId}/lists/{listId}/cards/{cardId}/checklists/{checklistId}/items/{itemId}.json', function ($request, $response, $args)
{
    $pg_params = array();
    $r_resource_vars['boards'] = $request->getAttribute('boardId');
    $r_resource_vars['lists'] = $request->getAttribute('listId');
    $r_resource_vars['cards'] = $request->getAttribute('cardId');
    $r_resource_vars['checklists'] = $request->getAttribute('checklistId');
    $r_resource_vars['items'] = $request->getAttribute('itemId');
    $foreign_ids['board_id'] = $r_resource_vars['boards'];
    $foreign_ids['list_id'] = $r_resource_vars['lists'];
    $foreign_ids['card_id'] = $r_resource_vars['cards'];
    $comment = '##USER_NAME## deleted checklist ##CHECKLIST_NAME## item from card ##CARD_LINK##';
    $results['activity'] = insertActivity($authUser['id'], $comment, 'delete_checklist_item', $foreign_ids, null, $r_resource_vars['items']);
    $sql = 'DELETE FROM checklist_items WHERE id = ?';
    array_push($pg_params, $r_resource_vars['items']);
    $result = executeQueryAll($sql, $pg_params);
    $results['error'] = array(
        'code' => (!$result) ? 1 : 0
    );
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->DELETE('/api/v1/boards/{boardId}/lists/{listId}/cards/{cardId}/cards_users/{cardUserId}.json', function ($request, $response, $args)
{
    $pg_params = array();
    $r_resource_vars['boards'] = $request->getAttribute('boardId');
    $r_resource_vars['lists'] = $request->getAttribute('listId');
    $r_resource_vars['cards'] = $request->getAttribute('cardId');
    $r_resource_vars['cards_users'] = $request->getAttribute('cardUserId');
    $foreign_ids['board_id'] = $r_resource_vars['boards'];
    $foreign_ids['list_id'] = $r_resource_vars['lists'];
    $foreign_ids['card_id'] = $r_resource_vars['cards'];
    $comment = '##USER_NAME## deleted member from card ##CARD_LINK##';
    $results['activity'] = insertActivity($authUser['id'], $comment, 'delete_card_users', $foreign_ids, null, $r_resource_vars['cards_users']);
    $sql = 'DELETE FROM cards_users WHERE id = ?';
    array_push($pg_params, $r_resource_vars['cards_users']);
    $result = executeQueryAll($sql, $pg_params);
    $results['error'] = array(
        'code' => (!$result) ? 1 : 0
    );
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->DELETE('/api/v1/oauth/clients/{clientId}.json', function ($request, $response, $args)
{
    $pg_params = array();
    $r_resource_vars['clients'] = $request->getAttribute('clientId');
    $sql = 'DELETE FROM oauth_clients WHERE id= ?';
    array_push($pg_params, $r_resource_vars['clients']);
    $result = executeQueryAll($sql, $pg_params);
    $results['error'] = array(
        'code' => (!$result) ? 1 : 0
    );
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->DELETE('/api/v1/oauth/applications/{applicationId}.json', function ($request, $response, $args)
{
    $r_resource_vars['applications'] = $request->getAttribute('applicationId');
    $conditions = array(
        $r_resource_vars['applications']
    );
    executeQueryAll('DELETE FROM oauth_access_tokens WHERE client_id = ?', $conditions);
    executeQueryAll('DELETE FROM oauth_refresh_tokens WHERE client_id = ?', $conditions);
    $sql = false;
    $results['error'] = array(
        'code' => 0
    );
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->DELETE('/api/v1/webhooks/{webhookId}.json', function ($request, $response, $args)
{
    $pg_params = array();
    $r_resource_vars['webhooks'] = $request->getAttribute('webhookId');
    $sql = 'DELETE FROM webhooks WHERE id= ?';
    array_push($pg_params, $r_resource_vars['webhooks']);
    $result = executeQueryAll($sql, $pg_params);
    $results['error'] = array(
        'code' => (!$result) ? 1 : 0
    );
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->DELETE('/api/v1/roles/{roleId}.json', function ($request, $response, $args)
{
    $r_resource_vars['roles'] = $request->getAttribute('roleId');
    $pg_params = array();
    $sql = 'DELETE FROM roles WHERE id= ?';
    array_push($pg_params, $r_resource_vars['roles']);
    $result = executeQueryAll($sql, $pg_params);
    $results['error'] = array(
        'code' => (!$result) ? 1 : 0
    );
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->DELETE('/api/v1/board_user_roles/{boardUserRoleId}.json', function ($request, $response, $args)
{
    $pg_params = array();
    $r_resource_vars['board_user_roles'] = $request->getAttribute('boardUserRoleId');
    $sql = 'DELETE FROM board_user_roles WHERE id= ?';
    array_push($pg_params, $r_resource_vars['board_user_roles']);
    $result = executeQueryAll($sql, $pg_params);
    $results['error'] = array(
        'code' => (!$result) ? 1 : 0
    );
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
$app->DELETE('/api/v1/organization_user_roles/{organizationUserRoleId}.json', function ($request, $response, $args)
{
    $pg_params = array();
    $r_resource_vars['organization_user_roles'] = $request->getAttribute('organizationUserRoleId');
    $sql = 'DELETE FROM organization_user_roles WHERE id= ?';
    array_push($pg_params, $r_resource_vars['organization_user_roles']);
    $result = executeQueryAll($sql, $pg_params);
    $results['error'] = array(
        'code' => (!$result) ? 1 : 0
    );
    echo json_encode($results, JSON_NUMERIC_CHECK);
});
main();
$app->run();
