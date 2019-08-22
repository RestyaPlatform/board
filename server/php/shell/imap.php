<?php
/**
 * Cron to fetch email and insert card or card comments based on to email address
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
define('IMAP_TEMP_FILE', CACHE_PATH . DS . 'imap.php');
if (!file_exists(IMAP_TEMP_FILE)) {
    $fh = fopen(IMAP_TEMP_FILE, "a");
    fwrite($fh, '<?php' . "\n" . '$_imap_time_trace = \'' . strtotime('now') . '\';');
    fclose($fh);
}
if (file_exists(IMAP_TEMP_FILE)) {
    include_once IMAP_TEMP_FILE;
}
if (round((strtotime('now') - $_imap_time_trace) / 60) >= 30) {
    file_put_contents(IMAP_TEMP_FILE, '<?php' . "\n" . '$_imap_time_trace = \'' . strtotime('now') . '\';');
    // Check is imap extension loaded
    if (!extension_loaded('imap')) {
        echo 'IMAP PHP extension not available on this server. Bounced email functions will not work.';
    } else {
        if (!empty(IMAP_HOST) && !empty(IMAP_EMAIL) && !empty(IMAP_EMAIL_PASSWORD)) {
            $imap_email_password = IMAP_EMAIL_PASSWORD;
            $imap_email_password_decode = base64_decode($imap_email_password);
            $imap_email_password = str_rot13($imap_email_password_decode);
            $is_ssl = (IMAP_PORT === '993') ? 'ssl/' : '';
            $connection = imap_open('{' . IMAP_HOST . ':' . IMAP_PORT . '/imap/' . $is_ssl . 'novalidate-cert}INBOX', IMAP_EMAIL, $imap_email_password, null, 1, array(
                'DISABLE_AUTHENTICATOR' => 'PLAIN',
            ));
            if ($connection) {
                $emails = imap_search($connection, 'UNSEEN');
                if (!empty($emails)) {
                    foreach ($emails as $key => $counter) {
                        $fetch_header = explode("\n", imap_fetchheader($connection, $counter));
                        if (is_array($fetch_header) && count($fetch_header)) {
                            $fetch_head = array();
                            foreach ($fetch_header as $line) {
                                // is line with additional header?
                                if (preg_match('/^X-/i', $line)) {
                                    // separate name and value
                                    preg_match('/^([^:]*): (.*)/i', $line, $arg);
                                    $fetch_head[$arg[1]] = $arg[2];
                                }
                            }
                        }
                        $header = imap_header($connection, $counter);
                        foreach ($header->to as $to) {
                            if (isset($fetch_head['X-Forwarded-To']) && $fetch_head['X-Forwarded-To'] != 'undefined') {
                                $mail = explode('+', strstr($fetch_head['X-Forwarded-To'], "@", true));
                            } else {
                                $mail = explode('+', $to->mailbox);
                            }
                            // Email format for board - board+##board_id##+hash@restya.com
                            // Email format for card  - board+##board_id##+##card_id##+hash@restya.com
                            // Check to email address contains atleast one "+" symbol
                            if (count($mail) > 1) {
                                $body_data = array();
                                // Fetch email body
                                $s = imap_fetchstructure($connection, $counter);
                                if (empty($s->parts)) { // simple
                                    $body = imapBodyDecode($connection, $counter, $s, 0); // pass 0 as part-number
                                    
                                } else { // multipart: cycle through each part
                                    foreach ($s->parts as $partno => $p) {
                                        $body_data[] = imapBodyDecode($connection, $counter, $p, $partno + 1);
                                    }
                                    if ($body_data) {
                                        if ($body_data[0] && is_array($body_data[0])) {
                                            $body = $body_data[0][0];
                                        } else {
                                            $body = $body_data[0];
                                        }
                                    }
                                }
                                $body_charset = mb_detect_encoding($body);
                                if ($body_charset !== 'UTF-8') {
                                    $body = iconv($body_charset, "UTF-8//TRANSLIT", $body);
                                }
                                $board_id = $mail[1];
                                $card_id = '';
                                $hash = $mail[2];
                                if (count($mail) > 3) {
                                    $card_id = $mail[2];
                                    $hash = $mail[3];
                                }
                                // Check email hash with generated hash
                                if ($hash == md5(SECURITYSALT . $board_id . $card_id)) {
                                    $condition = array(
                                        $board_id,
                                    );
                                    // Check from email is a member/owner in board
                                    $board_query = pg_query_params($db_lnk, 'SELECT default_email_list_id, is_default_email_position_as_bottom, user_id FROM boards_users_listing WHERE board_id = $1', $condition);
                                    $board = pg_fetch_assoc($board_query);
                                    if (!empty($board)) {
                                        // To email address is for board then insert the email as new card
                                        if (empty($card_id)) {
                                            $str = 'coalesce(MAX(position), 0)';
                                            if (empty($board['is_default_email_position_as_bottom'])) {
                                                $str = 'coalesce(MIN(position), 0)';
                                            }
                                            $list_id = $board['default_email_list_id'];
                                            $val_arr = array(
                                                $board_id,
                                                $list_id,
                                            );
                                            // Select minimum/maximum card position based on email to board settings
                                            $card_query = pg_query_params('SELECT ' . $str . ' as position FROM cards WHERE board_id = $1 AND list_id = $2', $val_arr);
                                            $card = pg_fetch_assoc($card_query);
                                            $position = empty($card['position']) ? 1 : (!empty($board['is_default_email_position_as_bottom'])) ? $card['position'] + 1 : ($card['position'] / 2);
                                            // Fetch email header
                                            $title = imap_utf8($header->subject);
                                            $title_charset = mb_detect_encoding($body);
                                            if ($title_charset !== 'UTF-8') {
                                                $title = iconv($title_charset, "UTF-8//TRANSLIT", $title);
                                            }
                                            $val_arr = array(
                                                $board_id,
                                                $list_id,
                                                $title,
                                                $body,
                                                $position,
                                                $board['user_id'],
                                            );
                                            // Insert card in default list id and position as selected in email to board settings
                                            $card_query = pg_query_params($db_lnk, 'INSERT INTO cards (created, modified, board_id, list_id, name, description, position, user_id) VALUES (now(), now(), $1, $2, $3, $4, $5, $6) RETURNING id', $val_arr);
                                            $card = pg_fetch_assoc($card_query);
                                            $card_id = $card['id'];
                                            // Inserting activities for the inserted card
                                            $val_arr = array(
                                                $card_id,
                                                $board['user_id'],
                                                $list_id,
                                                $board_id,
                                                'add_card',
                                                __l('##USER_NAME## added card ##CARD_LINK## to list ##LIST_NAME##.') ,
                                            );
                                            $activity_res = pg_query_params($db_lnk, 'INSERT INTO activities (created, modified, card_id, user_id, list_id, board_id, type, comment) VALUES (now(), now(), $1, $2, $3, $4, $5, $6)', $val_arr);
                                        } else {
                                            // To email address is for specific card then insert the email as card comment
                                            $val_arr = array(
                                                $card_id,
                                            );
                                            // Fetching list_id to update in card comment
                                            $card_query = pg_query_params('SELECT list_id FROM cards WHERE id = $1', $val_arr);
                                            $card = pg_fetch_assoc($card_query);
                                            $list_id = $card['list_id'];
                                            $val_arr = array(
                                                $card_id,
                                                $board['user_id'],
                                                $list_id,
                                                $board_id,
                                                'add_comment',
                                                $body,
                                            );
                                            // Insert email content as comment in respective card
                                            $activity_res = pg_query_params($db_lnk, 'INSERT INTO activities (created, modified, card_id, user_id, list_id, board_id, type, comment) VALUES (now(), now(), $1, $2, $3, $4, $5, $6)', $val_arr);
                                            $activity = pg_fetch_assoc($activity_res);
                                            if (!empty($activity)) {
                                                $id_converted = base_convert($activity['id'], 10, 36);
                                                $materialized_path = sprintf("%08s", $id_converted);
                                                $path = 'P' . $activity['id'];
                                                $depth = 0;
                                                $root = $activity['id'];
                                                $freshness_ts = $created;
                                                $qry_val_arr = array(
                                                    $materialized_path,
                                                    $path,
                                                    $depth,
                                                    $root,
                                                    $freshness_ts,
                                                    $activity['id'],
                                                );
                                                pg_query_params($db_lnk, 'UPDATE activities SET materialized_path = $1, path = $2, depth = $3, root = $4, freshness_ts = $5 WHERE id = $6', $qry_val_arr);
                                                $qry_val_arr = array(
                                                    $freshness_ts,
                                                    $root,
                                                );
                                                pg_query_params($db_lnk, 'UPDATE activities SET freshness_ts = $1 WHERE root = $2', $qry_val_arr);
                                            }
                                        }
                                        // Fetching email structure to get the attachments
                                        $structure = imap_fetchstructure($connection, $header->Msgno);
                                        $attachments = array();
                                        if (isset($structure->parts) && count($structure->parts)) {
                                            $i = 0;
                                            $file_attachments = false;
                                            foreach ($structure->parts as $partno0 => $p) {
                                                $attachments[$i] = array(
                                                    'is_attachment' => false,
                                                    'filename' => '',
                                                    'name' => '',
                                                    'attachment' => '',
                                                );
                                                if (isset($structure->parts[$i]->bytes)) {
                                                    $attachments[$i]['filesize'] = $structure->parts[$i]->bytes;
                                                }
                                                //### Tmobile & metropcs
                                                if (!empty($structure->parts[$i]->id)) {
                                                    if (preg_match('/</i', $structure->parts[$i]->id) && preg_match('/>/i', $structure->parts[$i]->id)) {
                                                        foreach ($structure->parts[$i]->parameters as $param) {
                                                            if (strtolower($param->attribute) == 'name') {
                                                                $attachments[$i]['is_attachment'] = true;
                                                                $attachments[$i]['name'] = $param->value;
                                                                $attachments[$i]['filename'] = $param->value;
                                                            }
                                                        }
                                                    }
                                                }
                                                // Setting attachment filename
                                                if ($structure->parts[$i]->ifdparameters) {
                                                    foreach ($structure->parts[$i]->dparameters as $object) {
                                                        if (strtolower($object->attribute) == 'filename') {
                                                            if (!preg_match('/tmobile/i', strtolower($object->value)) && !preg_match('/dottedline/i', strtolower($object->value))) {
                                                                $attachments[$i]['is_attachment'] = true;
                                                                $attachments[$i]['filename'] = $object->value;
                                                            }
                                                        }
                                                    }
                                                }
                                                // Setting attachment name
                                                if ($structure->parts[$i]->ifparameters) {
                                                    foreach ($structure->parts[$i]->parameters as $object) {
                                                        if (strtolower($object->attribute) == 'name') {
                                                            $attachments[$i]['is_attachment'] = true;
                                                            $attachments[$i]['name'] = $object->value;
                                                        }
                                                    }
                                                }
                                                // Decoding the attachment content based on encoding format
                                                if ($attachments[$i]['is_attachment']) {
                                                    $attachments[$i]['attachment'] = imap_fetchbody($connection, $header->Msgno, $i + 1);
                                                    if ($structure->parts[$i]->encoding == 3) { // 3 = BASE64
                                                        $attachments[$i]['attachment'] = base64_decode($attachments[$i]['attachment']);
                                                    } elseif ($structure->parts[$i]->encoding == 4) { // 4 = QUOTED-PRINTABLE
                                                        $attachments[$i]['attachment'] = quoted_printable_decode($attachments[$i]['attachment']);
                                                    }
                                                }
                                                if ($attachments[$i]['is_attachment'] === true) {
                                                    // Generating filename with time to avoid duplicate filename for same card
                                                    $file_attachments = true;
                                                    $mediadir = MEDIA_PATH . DS . 'Card' . DS . $card_id;
                                                    $filename = date('Y_m_d', time()) . '_at_' . date('H_i_s', time()) . '_' . $attachments[$i]['filename'];
                                                    $save_path = 'Card' . DS . $card_id;
                                                    if (!file_exists($mediadir)) {
                                                        mkdir($mediadir, 0777, true);
                                                    }
                                                    // Saving attachment content in file
                                                    $fh = fopen($mediadir . DS . $filename, 'x+');
                                                    fputs($fh, $attachments[$i]['attachment']);
                                                    fclose($fh);
                                                    $val_arr = array(
                                                        $card_id,
                                                        $filename,
                                                        $save_path . '/' . $filename,
                                                        $list_id,
                                                        $board_id,
                                                        strtolower('image/' . $structure->parts[1]->subtype) ,
                                                    );
                                                    // Inserting attachments for the card
                                                    pg_query_params($db_lnk, 'INSERT INTO card_attachments (created, modified, card_id, name, path, list_id , board_id, mimetype) VALUES (now(), now(), $1, $2, $3, $4, $5, $6)', $val_arr);
                                                    // Inserting activities for the inserted attachment
                                                    $val_arr = array(
                                                        $card_id,
                                                        $board['user_id'],
                                                        $list_id,
                                                        $board_id,
                                                        'add_card_attachment',
                                                        __l('##USER_NAME## added attachment to this card ##CARD_LINK##') ,
                                                    );
                                                    $activity_res = pg_query_params($db_lnk, 'INSERT INTO activities (created, modified, card_id, user_id, list_id, board_id, type, comment) VALUES (now(), now(), $1, $2, $3, $4, $5, $6)', $val_arr);
                                                }
                                                $i++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        // Set Seen flag to the email
                        imap_setflag_full($connection, $counter, "\\Seen \\Flagged", ST_UID);
                    }
                }
                // Closing the imap connection
                imap_expunge($connection);
            }
        }
    }
}
// Connect imap server
function imapBodyDecode($mbox, $mid, $p, $partno)
{
    // $partno = '1', '2', '2.1', '2.1.3', etc for multipart, 0 if simple
    $message = '';
    // DECODE DATA
    $data = ($partno) ? imap_fetchbody($mbox, $mid, $partno) : // multipart
    imap_body($mbox, $mid); // simple
    // Any part may be encoded, even plain text messages, so check everything.
    if ($p->encoding == 4) {
        $data = quoted_printable_decode($data);
    } elseif ($p->encoding == 3) {
        $data = base64_decode($data);
    }
    // TEXT
    if ($p->type == 0 && $data) {
        // Messages may be split in different parts because of inline attachments,
        // so append parts together with blank row.
        if (strtolower($p->subtype) == 'plain') {
            $message.= trim($data) . "\n\n";
        } else {
            $message.= $data . "<br><br>";
        }
    }
    // EMBEDDED MESSAGE
    // Many bounce notifications embed the original message as type 2,
    // but AOL uses type 1 (multipart), which is not handled here.
    // There are no PHP functions to parse embedded messages,
    // so this just appends the raw source to the main message.
    elseif ($p->type == 2 && $data) {
        $message.= $data . "\n\n";
    }
    // SUBPART RECURSION
    if (!empty($p->parts)) {
        foreach ($p->parts as $partno0 => $p2) {
            $message = imapBodyDecode($mbox, $mid, $p2, $partno . '.' . ($partno0 + 1));
        }
        // 1.2, 1.2.1, etc.
        
    }
    return $message;
}
