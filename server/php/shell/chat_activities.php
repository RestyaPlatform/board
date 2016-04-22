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
    $boards = array();
    $chat_history = pg_query_params($ejabberd_db_lnk, "SELECT * FROM archive WHERE id > $1", $qry_val_arr);
    while ($chat = pg_fetch_assoc($chat_history)) {
        $user_name = explode('/', $chat['peer']);
        $user_qry = pg_query($db_lnk, "SELECT id FROM users WHERE username = '" . end($user_name) . "'");
        $user = pg_fetch_assoc($user_qry);
        $qry_val_arr = array(
            $chat['created_at'],
            $user['id'],
            'chat',
            $chat['txt'],
            $chat['username']
        );
        pg_query_params($db_lnk, 'INSERT INTO activities (created, modified, board_id, user_id, type, comment) SELECT $1, $1, id, $2, $3, $4 FROM boards WHERE name = $5', $qry_val_arr);
        $last_processed_chat_id = $chat['id'];
        $qry_val_arr = array(
            $chat['username'],
            'chat',
        );
        $previous_data = pg_query_params($db_lnk, "SELECT count(*) FROM activities_listing WHERE board_id = (SELECT id FROM boards WHERE name = $1)  AND type = $2 AND created_at <= NOW() - '5 minutes'::INTERVAL", $qry_val_arr);
        $previous_data_count = pg_fetch_assoc($previous_data);
        if ($previous_data_count[count] == 0 && !in_array($chat['username'], $boards)) {
            array_push($boards, $chat['username']);
            $qry_val_arr = array(
                $chat['username']
            );
            $board_users = pg_query_params($db_lnk, "SELECT username,email FROM boards_users_listing WHERE board_id  = (SELECT id FROM boards WHERE name = $1)", $qry_val_arr);
            while ($board_user = pg_fetch_assoc($board_users)) {
                $mail_content = '<span style="font-weight: bold; color:#f47564;    font-size: 18px; text-transform: capitalize;">' . $chat['username'] . '</span><span style="font-weight: bold; color:#f47564;    font-size: 18px; text-transform: capitalize; margin-left:30px;">' . date('F d, Y', strtotime($chat['created_at'])) . '</span><ul style="padding-left: 0;list-style: none;font-family: Arial, sans-serif;font-size: 14px; line-height: 1.42857143; color: #555;">';
                $mail_content.= '<li><div style="margin-top: 15px;margin-right:10px;"><span><strong>' . date("H:i", strtotime($chat['created_at'])) . '</strong></span><span style="margin-right: 10px; margin-left:10px;"><strong>' . '< ' . end($user_name) . ' >' . '</strong></span><span>' . $chat['txt'] . '</span></div></li>';
                $mail_content.= '</ul>';
                $emailFindReplace['##CONTENT##'] = $mail_content;
                sendMail('chat_notification', $emailFindReplace, $board_user['email'], '');
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
