<?php
/**
 * Cron to add chat history as a activity
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
$app_path = dirname(dirname(__FILE__));
require_once $app_path . '/config.inc.php';
require_once $app_path . '/libs/core.php';
if (CHAT_DB_HOST) {
    $ejabberd_db_lnk = pg_connect('host=' . CHAT_DB_HOST . ' port=' . CHAT_DB_PORT . ' dbname=' . CHAT_DB_NAME . ' user=' . CHAT_DB_USER . ' password=' . CHAT_DB_PASSWORD . ' options=--client_encoding=UTF8') or die('Ejabberd database could not connect');
    $qry_val_arr = array(
        'chat.last_processed_chat_id'
    );
    $result = pg_query_params($db_lnk, 'SELECT value FROM settings WHERE name = $1', $qry_val_arr);
    $row = pg_fetch_assoc($result);
    if ($db_lnk && $ejabberd_db_lnk && !empty($row)) {
        $qry_val_arr = array(
            $row['value']
        );
        $chat_history = pg_query_params($ejabberd_db_lnk, "SELECT * FROM archive WHERE id > $1 ORDER BY id ASC", $qry_val_arr);
        $board_ids = array();
        while ($chat = pg_fetch_assoc($chat_history)) {
            $peer = explode('/', $chat['peer']);
            if (sizeof($peer) > 1) {
                list($board, $jabber_host) = explode('@', $peer[0]);
                list($board, $board_id) = explode('-', $board);
                $username = $peer[1];
                $qry_val_arr = array(
                    $board_id,
                    'chat'
                );
                $previous_data = pg_query_params($db_lnk, "SELECT count(*) FROM activities_listing WHERE board_id = $1 AND type = $2 AND now()::date = created::timestamp::date", $qry_val_arr);
                $previous_data_count = pg_fetch_assoc($previous_data);
                $qry_val_arr = array(
                    $username
                );
                $user_qry = pg_query_params($db_lnk, "SELECT id, full_name FROM users WHERE username = $1", $qry_val_arr);
                $user = pg_fetch_assoc($user_qry);
                if (!array_key_exists($board_id, $board_ids)) {
                    $qry_val_arr = array(
                        $board_id,
                        'chat'
                    );
                    $activity_card_id = pg_query_params($db_lnk, 'SELECT card_id, comment FROM activities WHERE board_id = $1 AND type = $2 ORDER BY id DESC', $qry_val_arr);
                    $activity_card_id = pg_fetch_assoc($activity_card_id);
                    if (!empty($activity_card_id['card_id']) && strpos($activity_card_id['comment'], 'EOD#') === false) {
                        $board_ids[$board_id] = $activity_card_id['card_id'];
                    }
                }
                $data = array(
                    $chat['created_at'],
                    $user['id'],
                    'chat',
                    $chat['txt'],
                    $board_id
                );
                $col = $val = '';
                if (strpos($chat['txt'], 'BOD#') !== false) {
                    $chat_text = explode('#', $chat['txt']);
                    $board_ids[$board_id] = $chat_text[1];
                }
                if (array_key_exists($board_id, $board_ids)) {
                    array_push($data, $board_ids[$board_id]);
                    $col = ', card_id';
                    $val = ', $6';
                }
                if (strpos($chat['txt'], 'EOD#') !== false) {
                    unset($board_ids[$board_id]);
                }
                $activity_id = pg_query_params($db_lnk, 'INSERT INTO activities (created, modified, board_id, user_id, type, comment' . $col . ') VALUES ($1, $1, $5, $2, $3, $4' . $val . ') RETURNING id', $data);
                $activity_id = pg_fetch_assoc($activity_id);
                $last_processed_chat_id = $chat['id'];
                if ($previous_data_count['count'] == 0) {
                    $qry_arr = array(
                        $activity_id['id']
                    );
                    $activities_result = pg_query_params($db_lnk, 'SELECT * FROM activities_listing WHERE id = $1', $qry_arr);
                    $activity = pg_fetch_assoc($activities_result);
                    $activity['comment'] = '##BOARD_NAME## chat conversation<div style="margin:5px 0px 0px 43px"><div style="background-color: #ffffff;border: 1px solid #dddddd;border-radius: 4px;display: block;line-height: 1.42857;margin:7px 0;padding: 4px;transition: all 0.2s ease-in-out 0s;"><div style="padding:3px 0px 0px 0px;margin:0px">' . $activity['created_time'] . ' &lt;' . $activity['username'] . '&gt; : ' . $activity['comment'] . '</div></div></div>';
                    $br = '<div style="line-height:20px;">&nbsp;</div>';
                    $comment = findAndReplaceVariables($activity);
                    $mail_content = '<div>' . "\n";
                    $mail_content.= '<div>' . $comment . $reply_to . '</div>' . "\n";
                    $mail_content.= '</div>' . "\n";
                    $mail_content.= $br . "\n";
                    $qry_val_arr = array(
                        $board_id
                    );
                    $board_users = pg_query_params($db_lnk, "SELECT username, email FROM boards_users_listing WHERE board_id = $1", $qry_val_arr);
                    while ($board_user = pg_fetch_assoc($board_users)) {
                        $qry_val_arr = array(
                            $board_user['username']
                        );
                        $user_timezone = pg_query_params($db_lnk, "SELECT timezone FROM users WHERE username = $1", $qry_val_arr);
                        $user_timezone = pg_fetch_assoc($user_timezone);
                        $emailFindReplace['##CONTENT##'] = $mail_content;
                        $emailFindReplace['##NAME##'] = $user['full_name'];
                        $emailFindReplace['##NOTIFICATION_COUNT##'] = '1';
                        $emailFindReplace['##SINCE##'] = date("h:i A (F j, Y)", strtotime($user_timezone['timezone']));
                        $emailFindReplace['##USER_ID##'] = $user['id'];
                        sendMail('email_notification', $emailFindReplace, $board_user['email'], '');
                    }
                }
            }
        }
        if (!empty($last_processed_chat_id)) {
            $qry_val_arr = array(
                $last_processed_chat_id,
                'chat.last_processed_chat_id'
            );
            pg_query_params($db_lnk, 'UPDATE settings SET value = $1 WHERE name = $2', $qry_val_arr);
        }
    }
}
