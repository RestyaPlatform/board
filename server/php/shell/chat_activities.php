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
    $chat_history = pg_query_params($db_lnk, "SELECT * FROM archive WHERE id > $1", $qry_val_arr);
	while ($chat = pg_fetch_assoc($chat_history)) {
		$user_name = explode('/', $chat['peer']);		
		$user_qry = pg_query($db_lnk, "SELECT id FROM users WHERE username = '" . end($user_name) ."'");
		$user = pg_fetch_assoc($user_qry);
		$qry_val_arr = array(
			$user['id'],
			'chat',
			$chat['txt'],
			$chat['username']
		);
		pg_query_params($db_lnk, 'INSERT INTO activities (created, modified, board_id, user_id, type, comment) SELECT now(), now(), id, $1, $2, $3 FROM boards WHERE name = $4', $qry_val_arr);
		$last_processed_chat_id = $chat['id'];
	}
	if (!empty($last_processed_chat_id)) {
		$qry_val_arr = array(
			$last_processed_chat_id,
			'chat.last_processed_chat_id'
		);
		pg_query_params($db_lnk, 'UPDATE settings SET value = $1 WHERE name = $2', $qry_val_arr);
	}
}


