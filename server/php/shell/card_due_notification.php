<?php
/**
 * Cron to card due date
 *
 * PHP version 5
 *
 * @category   PHP
 * @package    Restyaboard
 * @subpackage Core
 * @author     Restya <info@restya.com>
 * @copyright  2014-2019 Restya
 * @license    http://restya.com/ Restya Licence
 * @link       http://restya.com/
 */
if (!defined('APP_PATH')) {
    $app_path = dirname(dirname(__FILE__));
    require_once $app_path . '/config.inc.php';
    require_once $app_path . '/libs/core.php';
}
global $_server_domain_url;
if (file_exists(SITE_URL_FOR_SHELL)) {
    include_once SITE_URL_FOR_SHELL;
}
if ($db_lnk) {
    $qry_val_arr = array();
    $result = pg_query_params($db_lnk, "SELECT * FROM cards_listing WHERE is_due_date_notification_sent = false and is_archived = 0 and notification_due_date <= (NOW() + '1 day'::INTERVAL);", $qry_val_arr);
    while ($card = pg_fetch_assoc($result)) {
        $data_val = array(
            'true',
            $card['id']
        );
        pg_query_params($db_lnk, 'update cards set is_due_date_notification_sent = $1 where id = $2', $data_val);
        $cards_users = json_decode($card['cards_users']);
        if (!empty($cards_users)) {
            $i = 0;
            foreach ($cards_users as $cards_user) {
                $mail_content = '';
                if (!empty($cards_user->profile_picture_path)) {
                    $hash = md5(SECURITYSALT . 'User' . $cards_user->user_id . 'png' . 'small_thumb');
                    $profile_picture_path = $_server_domain_url . '/img/small_thumb/User/' . $cards_user->user_id . '.' . $hash . '.png';
                    $user_avatar = '<img style="margin-right: 10px;vertical-align: middle;" src="' . $profile_picture_path . '" alt="[Image: ' . $cards_user->full_name . ']" class="img-rounded img-responsive">' . "\n";
                } else if (!empty($cards_user->initials)) {
                    $user_avatar = '<i style="border-radius:4px;text-shadow:#6f6f6f 0.02em 0.02em 0.02em;width:32px;height:32px;line-height:32px;font-size:16px;display:inline-block;font-style:normal;text-align:center;text-transform:uppercase;color:#f47564 !important;background-color:#ffffff !important;border:1px solid #d7d9db;margin-right: 10px;">' . $cards_user->initials . '</i>' . "\n";
                }
                $date = date_create($card['due_date']);
                $message = '<a href="' . $_server_domain_url . '/#/board/' . $card['board_id'] . '/card/' . $card['id'] . '">' . $card['name'] . '</a> on <a href="' . $_server_domain_url . '/#/board/' . $card['board_id'] . '">' . $card['board_name'] . '</a> is due ' . date_format($date, "M d") . ' at ' . date_format($date, "h:i a (T)");
                $subject = $card['name'] . ' on ' . $card['board_name'] . ' is due ' . date_format($date, "M d") . ' at ' . date_format($date, "h:i a (T)") . ' at ' . date("h:i A") . ' on ' . date("F d, Y");
                $br = '<div style="line-height:40px;">&nbsp;</div>';
                $mail_content.= '<div style="display:table">' . "\n";
                $mail_content.= '<div style="float:left">' . $user_avatar . '</div>' . "\n";
                $mail_content.= '<div style="vertical-align: middle;display:table-cell;">' . $message . '</div>' . "\n";
                $mail_content.= '</div>' . "\n";
                $mail_content.= $br . "\n";
                $users[$cards_user->email][$i]['content'] = $mail_content;
                $users[$cards_user->email][$i]['subject'] = $subject;
                $i++;
            }
        }
    }
    if (!empty($users)) {
        foreach ($users as $key => $val) {
            $to_mail = $key;
            foreach ($val as $mail) {
                $emailFindReplace['##SUBJECT##'] = $mail['subject'];
                $emailFindReplace['##CONTENT##'] = $mail['content'];
                sendMail('due_date_notification', $emailFindReplace, $to_mail);
            }
        }
    }
}
