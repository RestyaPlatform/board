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
if(CHAT_DB_HOST) {
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
		$chat_history = pg_query_params($ejabberd_db_lnk, "SELECT * FROM archive WHERE id > $1 ORDER BY username, id", $qry_val_arr);
		$boards = array();
		while ($chat = pg_fetch_assoc($chat_history)) {
			$qry_val_arr = array(
				$chat['username'],
				'chat',
			);
			$previous_data = pg_query_params($db_lnk, "SELECT count(*) FROM activities_listing WHERE board_id = (SELECT id FROM boards WHERE name = $1) AND type = $2 AND now()::date = created_at::timestamp::date", $qry_val_arr);
			$previous_data_count = pg_fetch_assoc($previous_data);
			$user_name = explode('/', $chat['peer']);
			$user_qry = pg_query($db_lnk, "SELECT id FROM users WHERE username = '" . end($user_name) . "'");
			$user = pg_fetch_assoc($user_qry);
			if (!array_key_exists($chat['username'], $boards)) {
				$qry_arr = array(
					$chat['username'],
					'chat'
				);
				$activity_card_id = pg_query_params($db_lnk, 'SELECT card_id FROM activities WHERE board_id = (SELECT id FROM boards WHERE name = $1) AND type = $2 ORDER BY id DESC', $qry_arr);
				$activity_card_id = pg_fetch_assoc($activity_card_id);
				if (!empty($activity_card_id['card_id'])) {
					$boards[$chat['username']] = $activity_card_id['card_id'];
				}
			}
			$qry_val_arr = array(
				$chat['created_at'],
				$user['id'],
				'chat',
				$chat['txt'],
				$chat['username']
			);
			$col = '';
			$val = '';
			if (strpos($chat['txt'], 'EOD#') !== false) {
				unset($boards[$chat['username']]);
			}
			if (array_key_exists($chat['username'], $boards)) {
				array_push($qry_val_arr, $boards[$chat['username']]);
				$col = ', card_id';
				$val = ', $6';
			}
			$activity_id = pg_query_params($db_lnk, 'INSERT INTO activities (created, modified, board_id, user_id, type, comment' . $col . ') SELECT $1, $1, id, $2, $3, $4' . $val . ' FROM boards WHERE name = $5 RETURNING id', $qry_val_arr);
			$activity_id = pg_fetch_assoc($activity_id);
			$last_processed_chat_id = $chat['id'];
			if (strpos($chat['txt'], 'BOD#') !== false) {
				$boards[$chat['username']] = explode('#', $chat['txt']) [1];
			}
			if ($previous_data_count[count] == 0) {
				$qry_arr = array(
					$activity_id['id']
				);
				$activities_result = pg_query_params($db_lnk, 'SELECT * FROM activities_listing WHERE id = $1', $qry_arr);
				$activity = pg_fetch_assoc($activities_result);
				if (!empty($activity['profile_picture_path'])) {
					$hash = md5(SECURITYSALT . 'User' . $activity['user_id'] . 'png' . 'small_thumb');
					$profile_picture_path = $_server_domain_url . '/img/small_thumb/User/' . $activity['user_id'] . '.' . $hash . '.png';
					$user_avatar = '<img style="margin-right: 10px;vertical-align: middle;" src="' . $profile_picture_path . '" alt="[Image: ' . $activity['full_name'] . ']" class="img-rounded img-responsive">' . "\n";
				} else if (!empty($activity['initials'])) {
					$user_avatar = '<i style="border-radius:4px;text-shadow:#6f6f6f 0.02em 0.02em 0.02em;width:32px;height:32px;line-height:32px;font-size:16px;display:inline-block;font-style:normal;text-align:center;text-transform:uppercase;color:#f47564 !important;background-color:#ffffff !important;border:1px solid #d7d9db;margin-right: 10px;">' . $activity['initials'] . '</i>' . "\n";
				}
				preg_match_all('/@([^ ]*)/', $activity['comment'], $matches);
				if (in_array($user['username'], $matches[1])) {
					$activity['comment'] = '##USER_NAME## has mentioned you in card ##CARD_NAME## on ##BOARD_NAME##<div style="margin:5px 0px 0px 43px"><div style="background-color: #ffffff;border: 1px solid #dddddd;border-radius: 4px;display: block;line-height: 1.42857;margin:7px 0;padding: 4px;transition: all 0.2s ease-in-out 0s;"><div style="padding:3px 0px 0px 0px;margin:0px">' . $activity['comment'] . '</div></div></div>';
				} else {
					$activity['comment'] = '##USER_NAME## commented to the card ##CARD_NAME## on ##BOARD_NAME##<div style="margin:5px 0px 0px 43px"><div style="background-color: #ffffff;border: 1px solid #dddddd;border-radius: 4px;display: block;line-height: 1.42857;margin:7px 0;padding: 4px;transition: all 0.2s ease-in-out 0s;"><div style="padding:3px 0px 0px 0px;margin:0px">' . $activity['comment'] . '</div></div></div>';
				}
				$br = '<div style="line-height:20px;">&nbsp;</div>';
				$comment = findAndReplaceVariables($activity);
				$mail_content = '<div>' . "\n";
				$mail_content.= '<div style="float:left">' . $user_avatar . '</div>' . "\n";
				$mail_content.= '<div>' . $comment . $reply_to . '</div>' . "\n";
				$mail_content.= '</div>' . "\n";
				$mail_content.= $br . "\n";
				$qry_val_arr = array(
					$chat['username']
				);
				$board_users = pg_query_params($db_lnk, "SELECT username,email FROM boards_users_listing WHERE board_id  = (SELECT id FROM boards WHERE name = $1)", $qry_val_arr);
				while ($board_user = pg_fetch_assoc($board_users)) {
					$emailFindReplace['##CONTENT##'] = $mail_content;
					$emailFindReplace['##NAME##'] = $user['full_name'];
					$emailFindReplace['##NOTIFICATION_COUNT##'] = $notification_count;
					$emailFindReplace['##SINCE##'] = date("h:i A (F j, Y)");
					$emailFindReplace['##USER_ID##'] = $user['id'];
					sendMail('email_notification', $emailFindReplace, $board_user['email'], '');
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