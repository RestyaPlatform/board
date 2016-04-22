<?php
/**
 * Cron to send email notification by minutes based to users
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
require_once $app_path . '/libs/vendors/finediff.php';
require_once $app_path . '/libs/core.php';
global $_server_domain_url;
if (file_exists(APP_PATH . '/tmp/cache/site_url_for_shell.php')) {
    include_once APP_PATH . '/tmp/cache/site_url_for_shell.php';
}
if ($db_lnk) {
    $qry_val_arr = array(
        2
    );
    $users_result = pg_query_params($db_lnk, 'SELECT users.id, users.username, users.email, users.full_name, (SELECT array_to_json(array_agg(row_to_json(d))) FROM (SELECT bs.board_id FROM board_subscribers bs WHERE bs.user_id = users.id) d) AS board_ids FROM users WHERE is_send_newsletter = $1', $qry_val_arr);
    while ($user = pg_fetch_assoc($users_result)) {
        $board_ids = array();
        $board_arr = (!empty($user['board_ids'])) ? array_filter(json_decode($user['board_ids'], true)) : '';
        if (!empty($board_arr) && is_array($board_arr)) {
            foreach ($board_arr as $boards) {
                $board_ids[] = $boards['board_id'];
            }
        }
        $mail_content = '';
        $activities_result = '';
        $notification_count = 0;
        $reply_to_mail = '';
        $reply_to = '';
        foreach ($board_ids as $board_id) {
            $qry_arr = array(
                'chat',
                $user['id'],
                $board_id
            );
            $activities_result = pg_query_params($db_lnk, 'SELECT * FROM activities_listing WHERE created_at >= NOW() - \'1 hour\'::INTERVAL AND type = $1 AND user_id != $2 AND board_id = $3 ORDER BY board_name, created DESC', $qry_arr);
            $i = 0;
            while ($activity = pg_fetch_assoc($activities_result)) {
                if (empty($i)) {
                    $mail_content.= '<span style="font-weight: bold; color:#f47564;    font-size: 18px; text-transform: capitalize;">' . $activity['board_name'] . '</span><span style="font-weight: bold; color:#f47564;    font-size: 18px; text-transform: capitalize; margin-left:30px;">' . date('F d, Y', strtotime($activity['created_at'])) . '</span><ul style="padding-left: 0;list-style: none;font-family: Arial, sans-serif;font-size: 14px; line-height: 1.42857143; color: #555;">';
                    $i++;
                }
                $mail_content.= '<li><div style="margin-top: 15px;margin-right:10px;"><span><strong>' . $activity['created_time'] . '</strong></span><span style="margin-right: 10px; margin-left:10px;"><strong>' . '< ' . $activity['username'] . ' >' . '</strong></span><span>' . $activity['comment'] . '</span></div></li>';
            }
            if (!empty($i)) {
                $mail_content.= '</ul>';
                $mail_content.= '<div style="line-height:20px;">&nbsp;</div>';
            }
        }
        if (!empty($mail_content)) {
            $emailFindReplace['##CONTENT##'] = $mail_content;
            sendMail('chat_notification', $emailFindReplace, $user['email'], $reply_to_mail);
        }
    }
}
