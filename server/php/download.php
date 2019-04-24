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
 * @copyright  2014-2019 Restya
 * @license    http://restya.com/ Restya Licence
 * @link       http://restya.com/
 */
require_once 'config.inc.php';
if (!empty($_GET['id']) && !empty($_GET['hash'])) {
    $md5_hash = md5(SECURITYSALT . 'download' . $_GET['id']);
    if ($md5_hash == $_GET['hash']) {
        if ($db_lnk) {
            $val_array = array(
                $_GET['id']
            );
            $result = pg_query_params($db_lnk, 'SELECT * FROM card_attachments WHERE id = $1', $val_array);
            $attachment = pg_fetch_assoc($result);
            if (!empty($attachment)) {
                $val_array = array(
                    $attachment['board_id']
                );
                $result = pg_query_params($db_lnk, 'SELECT * FROM boards WHERE id = $1', $val_array);
                $board = pg_fetch_assoc($result);
                if (!empty($board) && $board['board_visibility'] === '2') {
                    $file = MEDIA_PATH . DS . $attachment['path'];
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
                } else if (isset($_COOKIE['auth'])) {
                    $auth = json_decode($_COOKIE['auth'], true);
                    $conditions = array(
                        'access_token' => $auth['access_token']
                    );
                    $result = pg_query_params($db_lnk, 'SELECT user_id as username, expires, scope, client_id FROM oauth_access_tokens WHERE access_token = $1', $conditions);
                    $auth_response = pg_fetch_assoc($result);
                    if (!empty($auth_response)) {
                        $val_array = array(
                            $_GET['id']
                        );
                        $result = pg_query_params($db_lnk, 'SELECT * FROM card_attachments WHERE id = $1', $val_array);
                        $attachment = pg_fetch_assoc($result);
                        if (!empty($attachment)) {
                            $val_array = array(
                                $attachment['board_id'],
                                $auth_response['username']
                            );
                            $result = pg_query_params($db_lnk, 'SELECT bu.id FROM boards_users bu left join users u on u.id = bu.user_id WHERE bu.board_id = $1 and u.username = $2', $val_array);
                            $board_user = pg_fetch_assoc($result);
                            if (!empty($board_user) || ($auth['user']['role_id'] == 1)) {
                                $file = MEDIA_PATH . DS . $attachment['path'];
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
                                header($_SERVER['SERVER_PROTOCOL'] . ' 401 Unauthorized 1', true, 401);
                                exit;
                            }
                        } else {
                            header($_SERVER['SERVER_PROTOCOL'] . ' 401 Unauthorized 2', true, 401);
                            exit;
                        }
                    } else {
                        header($_SERVER['SERVER_PROTOCOL'] . ' 401 Unauthorized 3', true, 401);
                        exit;
                    }
                } else {
                    header($_SERVER['SERVER_PROTOCOL'] . ' 401 Unauthorized 4', true, 401);
                    exit;
                }
            }
        }
    } else {
        $md5_hash = md5(SECURITYSALT . $_GET['id'] . '.csv');
        if ($md5_hash == $_GET['hash']) {
            $file = MEDIA_PATH . DS . 'reports' . DS . $_GET['id'] . '.csv';
            if (file_exists($file)) {
                $basename = basename($file);
                $add_slash = addcslashes($basename, '"\\');
                $quoted = sprintf('"%s"', $add_slash);
                $size = filesize($file);
                $path_info = pathinfo($file);
                header('Content-Description: File Transfer');
                header('Content-Type: application/octet-stream');
                header('Content-Disposition: attachment; filename=' . $quoted);
                header('Content-Transfer-Encoding: binary');
                header('Connection: Keep-Alive');
                header('Content-length: ' . $size);
                header('Expires: 0');
                header('Cache-Control: must-revalidate, post-check=0, pre-check=0');
                header('Pragma: public');
                readfile($file);
                exit;
            } else {
                header($_SERVER['SERVER_PROTOCOL'] . ' 404 Not Found', true, 404);
            }
        } else {
            header($_SERVER['SERVER_PROTOCOL'] . ' 404 Not Found', true, 404);
        }
    }
} else {
    header($_SERVER['SERVER_PROTOCOL'] . ' 404 Not Found', true, 404);
}
