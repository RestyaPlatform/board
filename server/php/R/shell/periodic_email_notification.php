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
 * @copyright  2014 Restya
 * @license    http://restya.com/ Restya Licence
 * @link       http://restya.com/
 */
$app_path = dirname(dirname(__FILE__));
require_once $app_path . '/config.inc.php';
require_once $app_path . '/libs/core.php';
global $_server_domain_url;
if (file_exists(APP_PATH . '/tmp/cache/site_url_for_shell.php')) {
    include_once APP_PATH . '/tmp/cache/site_url_for_shell.php';
}
if ($db_lnk) {
    $qry_val_arr = array(
        2
    );
    $users_result = pg_query_params($db_lnk, 'SELECT users.*, (SELECT array_to_json(array_agg(row_to_json(d))) FROM (SELECT bs.board_id FROM board_subscribers bs WHERE bs.user_id = users.id) d) AS board_ids, (SELECT array_to_json(array_agg(row_to_json(d))) FROM (SELECT ls.list_id, l.board_id FROM list_subscribers ls, lists l WHERE ls.user_id = users.id AND l.id = ls.list_id) d) AS list_ids,(SELECT array_to_json(array_agg(row_to_json(d))) FROM (SELECT cs.card_id, c.list_id, c.board_id FROM card_subscribers cs, cards c WHERE cs.user_id = users.id AND c.id = cs.card_id) d) AS card_ids FROM users WHERE is_send_newsletter = $1', $qry_val_arr);
    while ($user = pg_fetch_assoc($users_result)) {
        $board_ids = $list_ids = $card_ids = array();
        $board_arr = (!empty($user['board_ids'])) ? array_filter(json_decode($user['board_ids'], true)) : '';
        $list_arr = (!empty($user['list_ids'])) ? array_filter(json_decode($user['list_ids'], true)) : '';
        $card_arr = (!empty($user['card_ids'])) ? array_filter(json_decode($user['card_ids'], true)) : '';
        if (!empty($board_arr)) {
            foreach ($board_arr as $boards) {
                $board_ids[] = $boards['board_id'];
            }
        }
        if (!empty($list_arr)) {
            foreach ($list_arr as $lists) {
                if (!in_array($lists['board_id'], $board_ids)) {
                    $list_ids[] = $lists['list_id'];
                }
            }
        }
        if (!empty($card_arr)) {
            foreach ($card_arr as $cards) {
                if (!in_array($cards['board_id'], $board_ids) && !in_array($cards['list_id'], $list_ids)) {
                    $card_ids[] = $cards['card_id'];
                }
            }
        }
        $mail_content = '';
        $activities_result = '';
        $notification_count = 0;
        if (!empty($board_ids)) {
            $qry_arr = array(
                $user['last_email_notified_activity_id'],
                $user['id'],
                '{' . implode(',', $board_ids) . '}'
            );
            $activities_result = pg_query_params($db_lnk, 'SELECT * FROM activities_listing WHERE id > $1 AND user_id = $2  AND board_id = ANY ($3) ORDER BY id DESC', $qry_arr);
            $i = 0;
            while ($activity = pg_fetch_assoc($activities_result)) {
                if (!empty($activity['profile_picture_path'])) {
                    $hash = md5(SECURITYSALT . 'User' . $activity['user_id'] . 'png' . 'small_thumb' . SITE_NAME);
                    $profile_picture_path = $_server_domain_url . '/img/small_thumb/User/' . $activity['user_id'] . '.' . $hash . '.png';
                    $user_avatar = '<img style="margin-right: 10px;vertical-align: middle;" src="' . $profile_picture_path . '" alt="[Image: ' . $activity['full_name'] . ']" class="img-rounded img-responsive">';
                } else if (!empty($activity['initials'])) {
                    $user_avatar = '<i style="border-radius:4px;text-shadow:#6f6f6f 0.02em 0.02em 0.02em;width:32px;height:32px;line-height:32px;font-size:16px;display:inline-block;font-style:normal;text-align:center;text-transform:uppercase;color:#f47564 !important;background-color:#ffffff !important;border:1px solid #d7d9db;margin-right: 10px;">' . $activity['initials'] . '</i>';
                }
                if (empty($i)) {
                    $activity_id[] = $activity['id'];
                    $i++;
                }
                if ($activity['type'] == 'add_comment' || $activity['type'] == 'edit_comment') {
                    $activity['comment'] = '##USER_NAME## commented to the card ##CARD_NAME## on ##BOARD_NAME##<br/><div style="background-color: #ffffff;border: 1px solid #dddddd;border-radius: 4px;display: block;line-height: 1.42857;margin:7px 0;padding: 4px;transition: all 0.2s ease-in-out 0s;"><p style="padding:3px 0px 0px 0px;margin:0px">' . $activity['comment'] . '</p></div>';
                    $br = '<br/>';
                } else {
                    $activity['comment'].= ' on ##BOARD_NAME##';
                    $br = '<br/><br/>';
                }
                $comment = findAndReplaceVariables($activity);
                $mail_content.= $user_avatar . $comment . $br;
                $notification_count++;
            }
        }
        if (!empty($list_ids)) {
            $qry_arr = array(
                $user['last_email_notified_activity_id'],
                $user['id'],
                '{' . implode(',', $list_ids) . '}'
            );
            $activities_result = pg_query_params($db_lnk, 'SELECT * FROM activities_listing WHERE id > $1 AND user_id = $2  AND list_id = ANY ($3) ORDER BY id DESC', $qry_arr);
            $i = 0;
            while ($activity = pg_fetch_assoc($activities_result)) {
                if (!empty($activity['profile_picture_path'])) {
                    $hash = md5(SECURITYSALT . 'User' . $activity['user_id'] . 'png' . 'small_thumb' . SITE_NAME);
                    $profile_picture_path = $_server_domain_url . '/img/small_thumb/User/' . $activity['user_id'] . '.' . $hash . '.png';
                    $user_avatar = '<img style="margin-right: 10px;vertical-align: middle;" src="' . $profile_picture_path . '" alt="[Image: ' . $activity['full_name'] . ']" class="img-rounded img-responsive">';
                } else if (!empty($activity['initials'])) {
                    $user_avatar = '<i style="border-radius:4px;text-shadow:#6f6f6f 0.02em 0.02em 0.02em;width:32px;height:32px;line-height:32px;font-size:16px;display:inline-block;font-style:normal;text-align:center;text-transform:uppercase;color:#f47564 !important;background-color:#ffffff !important;border:1px solid #d7d9db;margin-right: 10px;">' . $activity['initials'] . '</i>';
                }
                if (empty($i)) {
                    $activity_id[] = $activity['id'];
                    $i++;
                }
                if ($activity['type'] == 'add_comment' || $activity['type'] == 'edit_comment') {
                    $activity['comment'] = '##USER_NAME## commented to the card ##CARD_NAME## on ##BOARD_NAME##<br/><div style="background-color: #ffffff;border: 1px solid #dddddd;border-radius: 4px;display: block;line-height: 1.42857;margin:7px 0;padding: 4px;transition: all 0.2s ease-in-out 0s;"><p style="padding:3px 0px 0px 0px;margin:0px">' . $activity['comment'] . '</p></div>';
                    $br = '<br/>';
                } else {
                    $activity['comment'].= ' on ##BOARD_NAME##';
                    $br = '<br/><br/>';
                }
                $comment = findAndReplaceVariables($activity);
                $mail_content.= $user_avatar . $comment . $br;
                $notification_count++;
            }
        }
        if (!empty($card_ids)) {
            $qry_arr = array(
                $user['last_email_notified_activity_id'],
                $user['id'],
                '{' . implode(',', $card_ids) . '}'
            );
            $activities_result = pg_query_params($db_lnk, 'SELECT * FROM activities_listing WHERE id > $1 AND user_id = $2  AND card_id = ANY ($3) ORDER BY id DESC', $qry_arr);
            $i = 0;
            while ($activity = pg_fetch_assoc($activities_result)) {
                if (!empty($activity['profile_picture_path'])) {
                    $hash = md5(SECURITYSALT . 'User' . $activity['user_id'] . 'png' . 'small_thumb' . SITE_NAME);
                    $profile_picture_path = $_server_domain_url . '/img/small_thumb/User/' . $activity['user_id'] . '.' . $hash . '.png';
                    $user_avatar = '<img style="margin-right: 10px;vertical-align: middle;" src="' . $profile_picture_path . '" alt="[Image: ' . $activity['full_name'] . ']" class="img-rounded img-responsive">';
                } else if (!empty($activity['initials'])) {
                    $user_avatar = '<i style="border-radius:4px;text-shadow:#6f6f6f 0.02em 0.02em 0.02em;width:32px;height:32px;line-height:32px;font-size:16px;display:inline-block;font-style:normal;text-align:center;text-transform:uppercase;color:#f47564 !important;background-color:#ffffff !important;border:1px solid #d7d9db;margin-right: 10px;">' . $activity['initials'] . '</i>';
                }
                if (empty($i)) {
                    $activity_id[] = $activity['id'];
                    $i++;
                }
                if ($activity['type'] == 'add_comment' || $activity['type'] == 'edit_comment') {
                    $activity['comment'] = '##USER_NAME## commented to the card ##CARD_NAME## on ##BOARD_NAME##<br/><div style="background-color: #ffffff;border: 1px solid #dddddd;border-radius: 4px;display: block;line-height: 1.42857;margin:7px 0;padding: 4px;transition: all 0.2s ease-in-out 0s;"><p style="padding:3px 0px 0px 0px;margin:0px">' . $activity['comment'] . '</p></div>';
                    $br = '<br/>';
                } else {
                    $activity['comment'].= ' on ##BOARD_NAME##';
                    $br = '<br/><br/>';
                }
                $comment = findAndReplaceVariables($activity);
                $mail_content.= $user_avatar . $comment . $br;
                $notification_count++;
            }
        }
        if (!empty($mail_content)) {
            $qry_arr = array(
                max($activity_id) ,
                $user['id']
            );
            pg_query_params($db_lnk, 'UPDATE users SET last_email_notified_activity_id = $1 WHERE id = $2', $qry_arr);
            $emailFindReplace['##CONTENT##'] = $mail_content;
            $emailFindReplace['##NAME##'] = $user['full_name'];
            $emailFindReplace['##NOTIFICATION_COUNT##'] = $notification_count;
            $emailFindReplace['##SINCE##'] = date("h:i A (F j, Y)");
            $emailFindReplace['##USER_ID##'] = $user['id'];
            sendMail('email_notification', $emailFindReplace, $user['email']);
        }
    }
}
