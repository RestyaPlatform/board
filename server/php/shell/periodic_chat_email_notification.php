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
                if (!empty($activity['profile_picture_path'])) {
                    $hash = md5(SECURITYSALT . 'User' . $activity['user_id'] . 'png' . 'small_thumb');
                    $profile_picture_path = $_server_domain_url . '/img/small_thumb/User/' . $activity['user_id'] . '.' . $hash . '.png';
                    $user_avatar = '<img style="margin-right: 10px;vertical-align: middle;" src="' . $profile_picture_path . '" alt="[Image: ' . $activity['full_name'] . ']" class="img-rounded img-responsive">' . "\n";
                } else if (!empty($activity['initials'])) {
                    $user_avatar = '<i style="border-radius:4px;text-shadow:#6f6f6f 0.02em 0.02em 0.02em;width:32px;height:32px;line-height:32px;font-size:16px;display:inline-block;font-style:normal;text-align:center;text-transform:uppercase;color:#f47564 !important;background-color:#ffffff !important;border:1px solid #d7d9db;margin-right: 10px;">' . $activity['initials'] . '</i>' . "\n";
                }
                if (empty($i)) {
                    $activity_id[] = $activity['id'];
                    $i++;
                }
                preg_match_all('/@([^ ]*)/', $activity['comment'], $matches);
                if (in_array($user['username'], $matches[1])) {
                    $activity['comment'] = '##USER_NAME## has mentioned you in card ##CARD_NAME## on ##BOARD_NAME##<div style="margin:5px 0px 0px 43px"><div style="background-color: #ffffff;border: 1px solid #dddddd;border-radius: 4px;display: block;line-height: 1.42857;margin:7px 0;padding: 4px;transition: all 0.2s ease-in-out 0s;"><div style="padding:3px 0px 0px 0px;margin:0px">' . $activity['comment'] . '</div></div></div>';
                } else {
                    $activity['comment'] = '##USER_NAME## commented to the card ##CARD_NAME## on ##BOARD_NAME##<div style="margin:5px 0px 0px 43px"><div style="background-color: #ffffff;border: 1px solid #dddddd;border-radius: 4px;display: block;line-height: 1.42857;margin:7px 0;padding: 4px;transition: all 0.2s ease-in-out 0s;"><div style="padding:3px 0px 0px 0px;margin:0px">' . $activity['comment'] . '</div></div></div>';
                }
                $br = '<div style="line-height:20px;">&nbsp;</div>';
                $comment = findAndReplaceVariables($activity);
                $mail_content.= '<div>' . "\n";
                $mail_content.= '<div style="float:left">' . $user_avatar . '</div>' . "\n";
                $mail_content.= '<div>' . $comment . $reply_to . '</div>' . "\n";
                $mail_content.= '</div>' . "\n";
                $mail_content.= $br . "\n";
                $notification_count++;
            }
        }
        if (!empty($mail_content)) {
            $emailFindReplace['##CONTENT##'] = $mail_content;
            $emailFindReplace['##NAME##'] = $user['full_name'];
            $emailFindReplace['##NOTIFICATION_COUNT##'] = $notification_count;
            $emailFindReplace['##SINCE##'] = date("h:i A (F j, Y)");
            $emailFindReplace['##USER_ID##'] = $user['id'];
            sendMail('email_notification', $emailFindReplace, $user['email'], $reply_to_mail);
        }
    }
}
