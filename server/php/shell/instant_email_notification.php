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
    $users_result = pg_query_params($db_lnk, 'SELECT users.id, users.username, users.email, users.full_name, users.last_email_notified_activity_id, users.timezone, (SELECT array_to_json(array_agg(row_to_json(d))) FROM (SELECT bs.board_id FROM board_subscribers bs WHERE bs.user_id = users.id) d) AS board_ids, (SELECT array_to_json(array_agg(row_to_json(d))) FROM (SELECT ls.list_id, l.board_id FROM list_subscribers ls, lists l WHERE ls.user_id = users.id AND l.id = ls.list_id) d) AS list_ids,(SELECT array_to_json(array_agg(row_to_json(d))) FROM (SELECT cs.card_id, c.list_id, c.board_id FROM card_subscribers cs, cards c WHERE cs.user_id = users.id AND c.id = cs.card_id) d) AS card_ids FROM users WHERE is_send_newsletter = $1', $qry_val_arr);
    while ($user = pg_fetch_assoc($users_result)) {
        $board_ids = $list_ids = $card_ids = array();
        $board_arr = (!empty($user['board_ids'])) ? array_filter(json_decode($user['board_ids'], true)) : '';
        $list_arr = (!empty($user['list_ids'])) ? array_filter(json_decode($user['list_ids'], true)) : '';
        $card_arr = (!empty($user['card_ids'])) ? array_filter(json_decode($user['card_ids'], true)) : '';
        if (!empty($board_arr) && is_array($board_arr)) {
            foreach ($board_arr as $boards) {
                $board_ids[] = $boards['board_id'];
            }
        }
        if (!empty($list_arr) && is_array($list_arr)) {
            foreach ($list_arr as $lists) {
                if (!in_array($lists['board_id'], $board_ids)) {
                    $list_ids[] = $lists['list_id'];
                }
            }
        }
        if (!empty($card_arr) && is_array($card_arr)) {
            foreach ($card_arr as $cards) {
                if (!in_array($cards['board_id'], $board_ids) && !in_array($cards['list_id'], $list_ids)) {
                    $card_ids[] = $cards['card_id'];
                }
            }
        }
        $mail_content = '';
        $activities_result = '';
        $notification_count = 0;
        $reply_to_mail = '';
        $reply_to = '';
        if (!empty($board_ids)) {
            $qry_arr = array(
                $user['last_email_notified_activity_id'],
                $user['id'],
                '{' . implode(',', $board_ids) . '}'
            );
            $activities_result = pg_query_params($db_lnk, 'SELECT * FROM activities_listing WHERE id > $1 AND user_id != $2 AND board_id = ANY ($3) ORDER BY id DESC', $qry_arr);
            $i = 0;
            $tmp_card_id = '';
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
                if ($activity['type'] == 'add_comment' || $activity['type'] == 'edit_comment') {
                    preg_match_all('/@([^ ]*)/', $activity['comment'], $matches);
                    if (in_array($user['username'], $matches[1])) {
                        $activity['comment'] = '##USER_NAME## has mentioned you in card ##CARD_NAME## on ##BOARD_NAME##<div style="margin:5px 0px 0px 43px"><div style="background-color: #ffffff;border: 1px solid #dddddd;border-radius: 4px;display: block;line-height: 1.42857;margin:7px 0;padding: 4px;transition: all 0.2s ease-in-out 0s;"><div style="padding:3px 0px 0px 0px;margin:0px">' . $activity['comment'] . '</div></div></div>';
                    } else {
                        $activity['comment'] = '##USER_NAME## commented to the card ##CARD_NAME## on ##BOARD_NAME##<div style="margin:5px 0px 0px 43px"><div style="background-color: #ffffff;border: 1px solid #dddddd;border-radius: 4px;display: block;line-height: 1.42857;margin:7px 0;padding: 4px;transition: all 0.2s ease-in-out 0s;"><div style="padding:3px 0px 0px 0px;margin:0px">' . $activity['comment'] . '</div></div></div>';
                    }
                    $br = '<div style="line-height:20px;">&nbsp;</div>';
                } else {
                    $activity['comment'].= ' on ##BOARD_NAME##';
                    $br = '<div style="line-height:40px;">&nbsp;</div>';
                }
                if (!empty($activity['card_id']) && IMAP_EMAIL) {
                    $imap_email = split("@", IMAP_EMAIL);
                    $board_email = $imap_email[0] . '+' . $activity['board_id'] . '+' . $activity['card_id'] . '+' . md5(SECURITYSALT . $activity['board_id'] . $activity['card_id']) . '@' . $imap_email[1];
                    $qry_arr = array(
                        $activity['card_id']
                    );
                    $card = pg_query_params($db_lnk, 'SELECT * FROM cards WHERE id = $1', $qry_arr);
                    $card = pg_fetch_assoc($card);
                    $mail_to = 'mailto:' . $board_email . '?subject=RE:' . $card['name'];
                    if (empty($tmp_card_id) || $tmp_card_id == $activity['card_id']) {
                        $reply_to_mail = $board_email;
                    } else {
                        $reply_to_mail = '';
                    }
                    $tmp_card_id = $activity['card_id'];
                    $reply_to = '<div style="margin:5px 0px 0px 43px;"><a href="' . $mail_to . '" target="_blank">Reply via email</a></div>' . "\n";
                }
                if (!empty($activity['revisions']) && trim($activity['revisions']) !== '') {
                    $revisions = unserialize($activity['revisions']);
                    $activity['revisions'] = $revisions;
                    unset($dif);
                    if (!empty($revisions['new_value'])) {
                        foreach ($revisions['new_value'] as $key => $value) {
                            if ($key != 'is_archived' && $key != 'is_deleted' && $key != 'created' && $key != 'modified' && $key != 'is_offline' && $key != 'uuid' && $key != 'to_date' && $key != 'temp_id' && $activity['type'] != 'moved_card_checklist_item' && $activity['type'] != 'add_card_desc' && $activity['type'] != 'add_card_duedate' && $activity['type'] != 'delete_card_duedate' && $activity['type'] != 'add_background' && $activity['type'] != 'change_background' && $activity['type'] != 'change_visibility' && $activity['type'] != 'change_card_position') {
                                $old_val = (isset($revisions['old_value'][$key]) && $revisions['old_value'][$key] != null && $revisions['old_value'][$key] != 'null') ? $revisions['old_value'][$key] : '';
                                $new_val = (isset($revisions['new_value'][$key]) && $revisions['new_value'][$key] != null && $revisions['new_value'][$key] != 'null') ? $revisions['new_value'][$key] : '';
                                $dif[] = nl2br(getRevisiondifference($old_val, $new_val));
                            }
                            if ($activity['type'] == 'add_card_desc' || $activity['type'] == 'add_card_desc' || $activity['type'] == '	edit_card_duedate' || $activity['type'] == 'add_background' || $activity['type'] == 'change_background' || $activity['type'] == 'change_visibility') {
                                $dif[] = $revisions['new_value'][$key];
                            }
                        }
                    } else if (!empty($revisions['old_value']) && isset($activity['type']) && $activity['type'] == 'delete_card_comment') {
                        $dif[] = nl2br(getRevisiondifference($revisions['old_value'], ''));
                    }
                    if (isset($dif)) {
                        $activity['difference'] = $dif;
                    }
                    if (!empty($activity['difference'][0])) {
                        $search = array(
                            '<del',
                            '<ins'
                        );
                        $replace = array(
                            '<del style="padding: 0px 3px;font-size: 90%;line-height: 1;text-align: center;white-space: nowrap;vertical-align: baseline;background: #e5bdb2;color: #a82400;margin-left: 3px;"',
                            '<ins style="padding: 0px 3px;font-size: 90%;line-height: 1;text-align: center;white-space: nowrap;vertical-align: baseline;background: #d1e1ad;color: #405a04;text-decoration: none;margin-right: 3px;"'
                        );
                        $difference = str_replace($search, $replace, $activity['difference'][0]);
                        $activity['comment'].= '<div style="margin:5px 0px 0px 43px"><div style="background-color: #ffffff;border: 1px solid #dddddd;border-radius: 4px;display: block;line-height: 1.42857;margin:7px 0;padding: 4px;transition: all 0.2s ease-in-out 0s;"><div style="padding:3px 0px 0px 0px;margin:0px">' . $difference . '</div></div></div>';
                    }
                }
                $comment = findAndReplaceVariables($activity);
                $mail_content.= '<div>' . "\n";
                $mail_content.= '<div style="float:left">' . $user_avatar . '</div>' . "\n";
                $mail_content.= '<div>' . $comment . $reply_to . '</div>' . "\n";
                $mail_content.= '</div>' . "\n";
                $mail_content.= $br . "\n";
                $notification_count++;
            }
        }
        if (!empty($list_ids)) {
            $qry_arr = array(
                $user['last_email_notified_activity_id'],
                $user['id'],
                '{' . implode(',', $list_ids) . '}'
            );
            $activities_result = pg_query_params($db_lnk, 'SELECT * FROM activities_listing WHERE id > $1 AND user_id != $2 AND list_id = ANY ($3) ORDER BY id DESC', $qry_arr);
            $i = 0;
            $tmp_card_id = '';
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
                if ($activity['type'] == 'add_comment' || $activity['type'] == 'edit_comment') {
                    preg_match_all('/@([^ ]*)/', $activity['comment'], $matches);
                    if (in_array($user['username'], $matches[1])) {
                        $activity['comment'] = '##USER_NAME## has mentioned you in card ##CARD_NAME## on ##BOARD_NAME##<div style="margin:5px 0px 0px 43px"><div style="background-color: #ffffff;border: 1px solid #dddddd;border-radius: 4px;display: block;line-height: 1.42857;margin:7px 0;padding: 4px;transition: all 0.2s ease-in-out 0s;"><div style="padding:3px 0px 0px 0px;margin:0px">' . $activity['comment'] . '</div></div></div>';
                    } else {
                        $activity['comment'] = '##USER_NAME## commented to the card ##CARD_NAME## on ##BOARD_NAME##<div style="margin:5px 0px 0px 43px"><div style="background-color: #ffffff;border: 1px solid #dddddd;border-radius: 4px;display: block;line-height: 1.42857;margin:7px 0;padding: 4px;transition: all 0.2s ease-in-out 0s;"><div style="padding:3px 0px 0px 0px;margin:0px">' . $activity['comment'] . '</div></div></div>';
                    }
                    $br = '<div style="line-height:20px;">&nbsp;</div>';
                } else {
                    $activity['comment'].= ' on ##BOARD_NAME##';
                    $br = '<div style="line-height:40px;">&nbsp;</div>';
                }
                if (!empty($activity['card_id']) && IMAP_EMAIL) {
                    $imap_email = split("@", IMAP_EMAIL);
                    $board_email = $imap_email[0] . '+' . $activity['board_id'] . '+' . $activity['card_id'] . '+' . md5(SECURITYSALT . $activity['board_id'] . $activity['card_id']) . '@' . $imap_email[1];
                    $qry_arr = array(
                        $activity['card_id']
                    );
                    $card = pg_query_params($db_lnk, 'SELECT * FROM cards WHERE id = $1', $qry_arr);
                    $card = pg_fetch_assoc($card);
                    $mail_to = 'mailto:' . $board_email . '?subject=RE:' . $card['name'];
                    if (empty($tmp_card_id) || $tmp_card_id == $activity['card_id']) {
                        $reply_to_mail = $board_email;
                    } else {
                        $reply_to_mail = '';
                    }
                    $tmp_card_id = $activity['card_id'];
                    $reply_to = '<div style="margin:5px 0px 0px 43px;"><a href="' . $mail_to . '" target="_blank">Reply via email</a></div>' . "\n";
                }
                if (!empty($activity['revisions']) && trim($activity['revisions']) !== '') {
                    $revisions = unserialize($activity['revisions']);
                    $activity['revisions'] = $revisions;
                    unset($dif);
                    if (!empty($revisions['new_value'])) {
                        foreach ($revisions['new_value'] as $key => $value) {
                            if ($key != 'is_archived' && $key != 'is_deleted' && $key != 'created' && $key != 'modified' && $key != 'is_offline' && $key != 'uuid' && $key != 'to_date' && $key != 'temp_id' && $activity['type'] != 'moved_card_checklist_item' && $activity['type'] != 'add_card_desc' && $activity['type'] != 'add_card_duedate' && $activity['type'] != 'delete_card_duedate' && $activity['type'] != 'add_background' && $activity['type'] != 'change_background' && $activity['type'] != 'change_visibility') {
                                $old_val = (isset($revisions['old_value'][$key]) && $revisions['old_value'][$key] != null && $revisions['old_value'][$key] != 'null') ? $revisions['old_value'][$key] : '';
                                $new_val = (isset($revisions['new_value'][$key]) && $revisions['new_value'][$key] != null && $revisions['new_value'][$key] != 'null') ? $revisions['new_value'][$key] : '';
                                $dif[] = nl2br(getRevisiondifference($old_val, $new_val));
                            }
                            if ($activity['type'] == 'add_card_desc' || $activity['type'] == 'add_card_desc' || $activity['type'] == '	edit_card_duedate' || $activity['type'] == 'add_background' || $activity['type'] == 'change_background' || $activity['type'] == 'change_visibility') {
                                $dif[] = $revisions['new_value'][$key];
                            }
                        }
                    } else if (!empty($revisions['old_value']) && isset($activity['type']) && $activity['type'] == 'delete_card_comment') {
                        $dif[] = nl2br(getRevisiondifference($revisions['old_value'], ''));
                    }
                    if (isset($dif)) {
                        $activity['difference'] = $dif;
                    }
                    if (!empty($activity['difference'][0])) {
                        $search = array(
                            '<del',
                            '<ins'
                        );
                        $replace = array(
                            '<del style="padding: 0px 3px;font-size: 90%;line-height: 1;text-align: center;white-space: nowrap;vertical-align: baseline;background: #e5bdb2;color: #a82400;margin-left: 3px;"',
                            '<ins style="padding: 0px 3px;font-size: 90%;line-height: 1;text-align: center;white-space: nowrap;vertical-align: baseline;background: #d1e1ad;color: #405a04;text-decoration: none;margin-right: 3px;"'
                        );
                        $difference = str_replace($search, $replace, $activity['difference'][0]);
                        $activity['comment'].= '<div style="margin:5px 0px 0px 43px"><div style="background-color: #ffffff;border: 1px solid #dddddd;border-radius: 4px;display: block;line-height: 1.42857;margin:7px 0;padding: 4px;transition: all 0.2s ease-in-out 0s;"><div style="padding:3px 0px 0px 0px;margin:0px">' . $difference . '</div></div></div>';
                    }
                }
                $comment = findAndReplaceVariables($activity);
                $mail_content.= '<div>' . "\n";
                $mail_content.= '<div style="float:left">' . $user_avatar . '</div>' . "\n";
                $mail_content.= '<div>' . $comment . $reply_to . '</div>' . "\n";
                $mail_content.= '</div>' . "\n";
                $mail_content.= $br . "\n";
                $notification_count++;
            }
        }
        if (!empty($card_ids)) {
            $qry_arr = array(
                $user['last_email_notified_activity_id'],
                $user['id'],
                '{' . implode(',', $card_ids) . '}'
            );
            $activities_result = pg_query_params($db_lnk, 'SELECT * FROM activities_listing WHERE id > $1 AND user_id != $2 AND card_id = ANY ($3) ORDER BY id DESC', $qry_arr);
            $i = 0;
            $tmp_card_id = '';
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
                if ($activity['type'] == 'add_comment' || $activity['type'] == 'edit_comment') {
                    preg_match_all('/@([^ ]*)/', $activity['comment'], $matches);
                    if (in_array($user['username'], $matches[1])) {
                        $activity['comment'] = '##USER_NAME## has mentioned you in card ##CARD_NAME## on ##BOARD_NAME##<div style="margin:5px 0px 0px 43px"><div style="background-color: #ffffff;border: 1px solid #dddddd;border-radius: 4px;display: block;line-height: 1.42857;margin:7px 0;padding: 4px;transition: all 0.2s ease-in-out 0s;"><div style="padding:3px 0px 0px 0px;margin:0px">' . $activity['comment'] . '</div></div></div>';
                    } else {
                        $activity['comment'] = '##USER_NAME## commented to the card ##CARD_NAME## on ##BOARD_NAME##<div style="margin:5px 0px 0px 43px"><div style="background-color: #ffffff;border: 1px solid #dddddd;border-radius: 4px;display: block;line-height: 1.42857;margin:7px 0;padding: 4px;transition: all 0.2s ease-in-out 0s;"><div style="padding:3px 0px 0px 0px;margin:0px">' . $activity['comment'] . '</div></div></div>';
                    }
                    $br = '<div style="line-height:20px;">&nbsp;</div>';
                } else {
                    $activity['comment'].= ' on ##BOARD_NAME##';
                    $br = '<div style="line-height:40px;">&nbsp;</div>';
                }
                if (!empty($activity['card_id']) && IMAP_EMAIL) {
                    $imap_email = split("@", IMAP_EMAIL);
                    $board_email = $imap_email[0] . '+' . $activity['board_id'] . '+' . $activity['card_id'] . '+' . md5(SECURITYSALT . $activity['board_id'] . $activity['card_id']) . '@' . $imap_email[1];
                    $qry_arr = array(
                        $activity['card_id']
                    );
                    $card = pg_query_params($db_lnk, 'SELECT * FROM cards WHERE id = $1', $qry_arr);
                    $card = pg_fetch_assoc($card);
                    $mail_to = 'mailto:' . $board_email . '?subject=RE:' . $card['name'];
                    if (empty($tmp_card_id) || $tmp_card_id == $activity['card_id']) {
                        $reply_to_mail = $board_email;
                    } else {
                        $reply_to_mail = '';
                    }
                    $tmp_card_id = $activity['card_id'];
                    $reply_to = '<div style="margin:5px 0px 0px 43px;"><a href="' . $mail_to . '" target="_blank">Reply via email</a></div>' . "\n";
                }
                if (!empty($activity['revisions']) && trim($activity['revisions']) !== '') {
                    $revisions = unserialize($activity['revisions']);
                    $activity['revisions'] = $revisions;
                    unset($dif);
                    if (!empty($revisions['new_value'])) {
                        foreach ($revisions['new_value'] as $key => $value) {
                            if ($key != 'is_archived' && $key != 'is_deleted' && $key != 'created' && $key != 'modified' && $key != 'is_offline' && $key != 'uuid' && $key != 'to_date' && $key != 'temp_id' && $activity['type'] != 'moved_card_checklist_item' && $activity['type'] != 'add_card_desc' && $activity['type'] != 'add_card_duedate' && $activity['type'] != 'delete_card_duedate' && $activity['type'] != 'add_background' && $activity['type'] != 'change_background' && $activity['type'] != 'change_visibility') {
                                $old_val = (isset($revisions['old_value'][$key]) && $revisions['old_value'][$key] != null && $revisions['old_value'][$key] != 'null') ? $revisions['old_value'][$key] : '';
                                $new_val = (isset($revisions['new_value'][$key]) && $revisions['new_value'][$key] != null && $revisions['new_value'][$key] != 'null') ? $revisions['new_value'][$key] : '';
                                $dif[] = nl2br(getRevisiondifference($old_val, $new_val));
                            }
                            if ($activity['type'] == 'add_card_desc' || $activity['type'] == 'add_card_desc' || $activity['type'] == '	edit_card_duedate' || $activity['type'] == 'add_background' || $activity['type'] == 'change_background' || $activity['type'] == 'change_visibility') {
                                $dif[] = $revisions['new_value'][$key];
                            }
                        }
                    } else if (!empty($revisions['old_value']) && isset($activity['type']) && $activity['type'] == 'delete_card_comment') {
                        $dif[] = nl2br(getRevisiondifference($revisions['old_value'], ''));
                    }
                    if (isset($dif)) {
                        $activity['difference'] = $dif;
                    }
                    if (!empty($activity['difference'][0])) {
                        $search = array(
                            '<del',
                            '<ins'
                        );
                        $replace = array(
                            '<del style="padding: 0px 3px;font-size: 90%;line-height: 1;text-align: center;white-space: nowrap;vertical-align: baseline;background: #e5bdb2;color: #a82400;margin-left: 3px;"',
                            '<ins style="padding: 0px 3px;font-size: 90%;line-height: 1;text-align: center;white-space: nowrap;vertical-align: baseline;background: #d1e1ad;color: #405a04;text-decoration: none;margin-right: 3px;"'
                        );
                        $difference = str_replace($search, $replace, $activity['difference'][0]);
                        $activity['comment'].= '<div style="margin:5px 0px 0px 43px"><div style="background-color: #ffffff;border: 1px solid #dddddd;border-radius: 4px;display: block;line-height: 1.42857;margin:7px 0;padding: 4px;transition: all 0.2s ease-in-out 0s;"><div style="padding:3px 0px 0px 0px;margin:0px">' . $difference . '</div></div></div>';
                    }
                }
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
            $qry_arr = array(
                max($activity_id) ,
                $user['id']
            );
            pg_query_params($db_lnk, 'UPDATE users SET last_email_notified_activity_id = $1 WHERE id = $2', $qry_arr);
            $emailFindReplace['##CONTENT##'] = $mail_content;
            $emailFindReplace['##NAME##'] = $user['full_name'];
            $emailFindReplace['##NOTIFICATION_COUNT##'] = $notification_count;
            $emailFindReplace['##SINCE##'] = date("h:i A (F j, Y)", strtotime($user['timezone']));
            $emailFindReplace['##USER_ID##'] = $user['id'];
            sendMail('email_notification', $emailFindReplace, $user['email'], $reply_to_mail);
        }
    }
}
