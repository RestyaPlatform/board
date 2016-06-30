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
 * @copyright  2014-2016 Restya
 * @license    http://restya.com/ Restya Licence
 * @link       http://restya.com/
 */
$app_path = dirname(dirname(__FILE__));
require_once $app_path . '/config.inc.php';
// Check is imap extension loaded
if (!extension_loaded('imap')) {
    echo 'IMAP PHP extension not available on this server. Bounced email functions will not work.';
    exit;
}
// Connect imap server
$imap_email_password = IMAP_EMAIL_PASSWORD;
$imap_email_password_decode = base64_decode($imap_email_password);
$imap_email_password = str_rot13($imap_email_password_decode);
$connection = imap_open('{' . IMAP_HOST . ':' . IMAP_PORT . '/imap/ssl/novalidate-cert/notls}INBOX', IMAP_EMAIL, $imap_email_password);
if (!$connection) {
    return;
}
$message_count = imap_num_msg($connection);
for ($counter = 1; $counter <= $message_count; $counter++) {
    // Fetch email header
    $header = imap_header($connection, $counter);
    // Fetch email body
    $body = imap_fetchbody($connection, $counter, 1.1);
    $mail = explode('+', $header->to[0]->mailbox);
    // Email format for board - board+##board_id##+hash@restya.com
    // Email format for card  - board+##board_id##+##card_id##+hash@restya.com
    // Check to email address contains atleast one "+" symbol
    if (count($mail) > 1) {
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
                $board_id
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
                        $list_id
                    );
                    // Select minimum/maximum card position based on email to board settings
                    $card_query = pg_query_params('SELECT ' . $str . ' as position FROM cards WHERE board_id = $1 AND list_id = $2', $val_arr);
                    $card = pg_fetch_assoc($card_query);
                    $position = empty($card['position']) ? 1 : (!empty($board['is_default_email_position_as_bottom'])) ? $card['position'] + 1 : $card['position'];
                    $val_arr = array(
                        $board_id,
                        $list_id,
                        $header->subject,
                        $body,
                        $position,
                        $board['user_id']
                    );
                    // Insert card in default list id and position as selected in email to board settings
                    $card_query = pg_query_params($db_lnk, 'INSERT INTO cards (created, modified, board_id, list_id, name, description, position, user_id) VALUES (now(), now(), $1, $2, $3, $4, $5, $6) RETURNING id', $val_arr);
                    $card = pg_fetch_assoc($card_query);
                    $card_id = $card['id'];
                } else {
                    $body = imap_fetchbody($connection, $counter, 1);
                    // To email address is for specific card then insert the email as card comment
                    $val_arr = array(
                        $card_id
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
                        $body
                    );
                    // Insert email content as comment in respective card
                    pg_query_params($db_lnk, 'INSERT INTO activities (created, modified, card_id, user_id, list_id, board_id, type, comment) VALUES (now(), now(), $1, $2, $3, $4, $5, $6)', $val_arr);
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
                        if (preg_match('/</i', $structure->parts[$i]->id) && preg_match('/>/i', $structure->parts[$i]->id)) {
                            foreach ($structure->parts[$i]->parameters as $param) {
                                if (strtolower($param->attribute) == 'name') {
                                    $attachments[$i]['is_attachment'] = true;
                                    $attachments[$i]['name'] = $param->value;
                                    $attachments[$i]['filename'] = $param->value;
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
                            $filename = date('Y_m_d', time()) . '_at_' . date('H_i_s', time()) . '_' . $attachments[$i]['filename'];
                            $save_path = 'media' . DIRECTORY_SEPARATOR . 'Card' . DIRECTORY_SEPARATOR . $card_id;
                            $mediadir = APP_PATH . DIRECTORY_SEPARATOR . $save_path;
                            if (!file_exists($mediadir)) {
                                mkdir($mediadir, 0777, true);
                            }
                            // Saving attachment content in file
                            $fh = fopen($mediadir . DIRECTORY_SEPARATOR . $filename, 'x+');
                            fputs($fh, $attachments[$i]['attachment']);
                            fclose($fh);
                            $val_arr = array(
                                $card_id,
                                $filename,
                                $save_path . '/' . $filename,
                                $list_id,
                                $board_id,
                                strtolower('image/' . $structure->parts[1]->subtype)
                            );
                            // Inserting attachments for the card
                            pg_query_params($db_lnk, 'INSERT INTO card_attachments (created, modified, card_id, name, path, list_id , board_id, mimetype) VALUES (now(), now(), $1, $2, $3, $4, $5, $6)', $val_arr);
                        }
                        $i++;
                    }
                    if (empty($file_attachments)) {
                        $body = imap_fetchbody($connection, $counter, 1);
                        // To email address is for specific card then insert the email as card comment
                        $val_arr = array(
                            $card_id
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
                            $body
                        );
                        // Insert email content as comment in respective card
                        pg_query_params($db_lnk, 'INSERT INTO activities (created, modified, card_id, user_id, list_id, board_id, type, comment) VALUES (now(), now(), $1, $2, $3, $4, $5, $6)', $val_arr);
                    }
                }
            }
        }
    }
    // Deleting the email
    imap_delete($connection, trim($header->Msgno));
}
// Closing the imap connection
imap_expunge($connection);
