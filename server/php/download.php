<?php
/**
 * To download card attachment
 *
 * PHP version 5
 *
 * @category   PHP
 * @package    Restyaboard
 * @subpackage Core
 * @author     Restya <info@restya.com>
 * @copyright  2014-2017 Restya
 * @license    http://restya.com/ Restya Licence
 * @link       http://restya.com/
 */
require_once 'config.inc.php';
if (!empty($_GET['id']) && !empty($_GET['hash'])) {
    $md5_hash = md5(SECURITYSALT . 'download' . $_GET['id']);
    if ($md5_hash == $_GET['hash']) {
        if(isset($_COOKIE['auth'])) {
            $auth = json_decode($_COOKIE['auth'], true);
            if ($db_lnk) {
                $conditions = array(
                    'access_token' => $auth['access_token']
                );
                $result = pg_query_params($db_lnk, 'SELECT user_id as username, expires, scope, client_id FROM oauth_access_tokens WHERE access_token = $1', $conditions);
                $auth_response = pg_fetch_assoc($result);
                $expires = strtotime($auth_response['expires']);
                if (empty($auth_response) || !empty($auth_response['error']) || ($auth_response['client_id'] != 6664115227792148 && $auth_response['client_id'] != OAUTH_CLIENTID) || ($expires > 0 && $expires < time() && $auth_response['client_id'] != 7857596005287233 && $auth_response['client_id'] != 1193674816623028)) {
                    $auth_response['error']['type'] = 'OAuth';
                    echo json_encode($auth_response);
                    header($_SERVER['SERVER_PROTOCOL'] . ' 401 Unauthorized', true, 401);
                    exit;
                }
                if(!empty($auth_response)) {
                    $val_array = array(
                        $_GET['id']
                    );
                    $result = pg_query_params($db_lnk, 'SELECT * FROM card_attachments WHERE id = $1', $val_array);
                    $attachment = pg_fetch_assoc($result);
                    if(!empty($attachment)) {
                        $val_array = array(
                            $attachment['board_id'],
                            $auth_response['username']
                        );
                        $result = pg_query_params($db_lnk, 'SELECT bu.id FROM boards_users bu left join users u on u.id = bu.user_id WHERE bu.board_id = $1 and u.username = $2', $val_array);
                        $board_user = pg_fetch_assoc($result);
                        if(!empty($board_user) || ($auth['user']['role_id'] == 1)) {
                            $mediadir = APP_PATH . DIRECTORY_SEPARATOR . 'media' . DIRECTORY_SEPARATOR . 'Card' . DIRECTORY_SEPARATOR . $attachment['card_id'];
                            $file = $mediadir . DIRECTORY_SEPARATOR . $attachment['name'];
                            if (file_exists($file)) {
                                $basename = basename($file);
                                $add_slash = addcslashes($basename, '"\\');
                                $quoted = sprintf('"%s"', $add_slash);
                                $size = filesize($file);
                                $path_info = pathinfo($file);
                                $image_extensions = array(
                                    'gif',
                                    'jpeg',
                                    'jpg',
                                    'png'
                                );
                                
                                if (isset($_GET['view']) && in_array(strtolower($path_info['extension']) , $image_extensions)) {
                                    if ($path_info['extension'] == 'jpg') {
                                        header('Content-Type: image/jpeg');
                                    } else {
                                        header('Content-Type: image/' . $path_info['extension']);
                                    }
                                } else {
                                    header('Content-Description: File Transfer');
                                    header('Content-Type: application/octet-stream');
                                    header('Content-Disposition: attachment; filename=' . $quoted);
                                    header('Content-Transfer-Encoding: binary');
                                    header('Connection: Keep-Alive');
                                    header('Content-length: ' . $size);
                                    header('Expires: 0');
                                    header('Cache-Control: must-revalidate, post-check=0, pre-check=0');
                                    header('Pragma: public');
                                }
                                readfile($file);
                                exit;
                            }
                        } else {
                            header($_SERVER['SERVER_PROTOCOL'] . ' 401 Unauthorized', true, 401);
                            exit;
                        }
                    }
                } else {
                    header($_SERVER['SERVER_PROTOCOL'] . ' 401 Unauthorized', true, 401);
                    exit;
                }
            }
        } else {
            header($_SERVER['SERVER_PROTOCOL'] . ' 401 Unauthorized', true, 401);
            exit;
        }
    } else {
        header($_SERVER['SERVER_PROTOCOL'] . ' 404 Not Found', true, 404);
    }
} else {
    header($_SERVER['SERVER_PROTOCOL'] . ' 404 Not Found', true, 404);
}
