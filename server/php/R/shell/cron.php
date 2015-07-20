<?php
/**
 * Cron to update ElasticSearch indexing
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
if (!empty($argv[0])) {
    $app_path = str_replace('shell/cron.php', '', $argv[0]);
    require_once $app_path . 'config.inc.php';
} else {
    require_once '../config.inc.php';
}
if ($db_lnk) {
    $result = pg_query_params($db_lnk, 'SELECT value FROM settings WHERE name = $1', array(
        'elasticsearch.last_processed_activtiy_id'
    ));
    $row = pg_fetch_assoc($result);
    if (!empty($row)) {
        $result = pg_query_params($db_lnk, "SELECT * FROM activities WHERE (type = 'add_card' OR type = 'add_list' OR  type = 'add_board' OR  type = 'edit_card' OR type = 'edit_list' OR  type = 'edit_board') AND id > $1", array(
            $row['value']
        ));
        $count = pg_num_rows($result);
        if ($count > 0) {
            $params = array();
            $ch = curl_init();
            while ($row = pg_fetch_assoc($result)) {
                $revisions = unserialize($row['revisions']);
                $id = '';
                $type = '';
                $doc_fileds = array();
                if (!empty($row['card_id'])) {
                    $id = $row['card_id'];
                    $user_result = pg_query_params($db_lnk, 'SELECT username FROM users WHERE id = $1', array(
                        $row['user_id']
                    ));
                    $user_row = pg_fetch_assoc($user_result);
                    $doc_fileds['user_name'] = $user_row['username'];
                    $list_result = pg_query_params($db_lnk, 'SELECT name FROM lists WHERE id = $1', array(
                        $row['list_id']
                    ));
                    $list_row = pg_fetch_assoc($list_result);
                    $doc_fileds['list_name'] = $list_row['name'];
                    $doc_fileds['list_id'] = $row['list_id'];
                    $board_result = pg_query_params($db_lnk, 'SELECT name FROM boards WHERE id = $1', array(
                        $row['board_id']
                    ));
                    $board_row = pg_fetch_assoc($board_result);
                    $doc_fileds['board_name'] = $board_row['name'];
                    $doc_fileds['board_id'] = $row['board_id'];
                    $card_result = pg_query_params($db_lnk, 'SELECT name, description, due_date FROM cards WHERE id = $1', array(
                        $row['card_id']
                    ));
                    $card_row = pg_fetch_assoc($card_result);
                    $doc_fileds['card_name'] = $card_row['name'];
                    $doc_fileds['card_description'] = $card_row['description'];
                    $doc_fileds['due_date'] = $card_row['due_date'];
                    if (!empty($revisions)) {
                        foreach ($revisions['new_value'] as $key => $value) {
                            if ($key == 'name') {
                                $doc_fileds['card_name'] = $value;
                            } else {
                                $doc_fileds[$key] = $value;
                            }
                        }
                    }
                    $type = 'cards';
                } else if (!empty($row['list_id'])) {
                    $id = $row['list_id'];
                    $user_result = pg_query_params($db_lnk, 'SELECT username FROM users WHERE id = $1', array(
                        $row['user_id']
                    ));
                    $user_row = pg_fetch_assoc($user_result);
                    $doc_fileds['user_name'] = $user_row['username'];
                    $board_result = pg_query_params($db_lnk, 'SELECT name FROM boards WHERE id = $1', array(
                        $row['board_id']
                    ));
                    $board_row = pg_fetch_assoc($board_result);
                    $doc_fileds['board_name'] = $board_row['name'];
                    $doc_fileds['board_id'] = $row['board_id'];
                    $list_result = pg_query_params($db_lnk, 'SELECT name FROM lists WHERE id = $1', array(
                        $row['list_id']
                    ));
                    $list_row = pg_fetch_assoc($list_result);
                    $doc_fileds['list_name'] = $list_row['name'];
                    if (!empty($revisions)) {
                        foreach ($revisions['new_value'] as $key => $value) {
                            if ($key == 'name') {
                                $doc_fileds['list_name'] = $value;
                            } else {
                                $doc_fileds[$key] = $value;
                            }
                        }
                    }
                    $type = 'lists';
                } else if (!empty($row['board_id'])) {
                    $id = $row['board_id'];
                    $user_result = pg_query_params($db_lnk, 'SELECT username FROM users WHERE id = $1', array(
                        $row['user_id']
                    ));
                    $user_row = pg_fetch_assoc($user_result);
                    $doc_fileds['user_name'] = $user_row['username'];
                    if (!empty($revisions)) {
                        foreach ($revisions['new_value'] as $key => $value) {
                            if ($key == 'name') {
                                $doc_fileds['board_name'] = $value;
                            } else {
                                $doc_fileds[$key] = $value;
                            }
                        }
                    }
                    $type = 'boards';
                }
                $url = ELASTICSEARCH_URL . ELASTICSEARCH_INDEX . '/' . $type . '/' . $id;
                curl_setopt($ch, CURLOPT_URL, $url);
                curl_setopt($ch, CURLOPT_HTTPAUTH, CURLAUTH_BASIC);
                curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
                curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);
                curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
                curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
                curl_setopt($ch, CURLOPT_TIMEOUT, 300); // 300 seconds (5min)
                unset($doc_fileds['activity']);
                $post_string = json_encode($doc_fileds);
                curl_setopt($ch, CURLOPT_HTTPHEADER, array(
                    'Content-Type: application/json',
                    'Content-Length: ' . strlen($post_string)
                ));
                curl_setopt($ch, CURLOPT_POST, true);
                curl_setopt($ch, CURLOPT_POSTFIELDS, $post_string);
                curl_exec($ch);
                $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
                if (curl_errno($ch)) {
                    echo 'Error:: ' . curl_error($ch) . PHP_EOL;
                }
                switch ($http_code) {
                case 201:
                case 200:
                    echo 'Saved Successfully.' . PHP_EOL;
                    break;

                case 401:
                    echo 'Unauthorized.' . PHP_EOL;
                    break;

                default:
                    echo 'Not Found.' . PHP_EOL;
                }
                pg_query_params($db_lnk, 'UPDATE settings SET value = $1 WHERE name = $2', array(
                    $row['id'],
                    'elasticsearch.last_processed_activtiy_id'
                ));
            }
            curl_close($ch);
        }
    }
}
