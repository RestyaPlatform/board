<?php
/**
 * To upgrade v0.2.1 to v0.3
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
require_once $app_path . '/libs/vendors/OAuth2/Autoloader.php';
require_once $app_path . '/libs/vendors/xmpp/vendor/autoload.php';
use Xmpp\Xep\Xep0045 as xmpp;
use Psr\Log\LoggerInterface;
require $app_path . '/libs/vendors/jaxl3/jaxl.php';
// Delete ElasticSearch index
$ch = curl_init(ELASTICSEARCH_URL . ELASTICSEARCH_INDEX);
curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'DELETE');
$result = curl_exec($ch);
// Update setting to re-index data
$qry_val_arr = array(
    0,
    'elasticsearch.last_processed_activity_id'
);
pg_query_params($db_lnk, 'UPDATE settings SET value = $1 WHERE name = $2', $qry_val_arr);
$j_username = $j_password = '';
$users = pg_query_params($db_lnk, 'SELECT * FROM users', array());
while ($user = pg_fetch_assoc($users)) {
    if (JABBER_HOST) {
        $conditions = array(
            trim($user['username'])
        );
        $chat_db_lnk = getEjabberdConnection();
        $check_user = pg_query_params($chat_db_lnk, 'SELECT password FROM users WHERE username = $1', $conditions);
        if (!($check_user && pg_num_rows($check_user))) {
            global $j_username, $j_password;
            $jaxl_initialize = array(
                'jid' => JABBER_HOST,
                'strict' => false,
                'log_level' => JAXL_DEBUG,
                'port' => 5222,
                'log_path' => 'jaxl.log'
            );
            $GLOBALS['client'] = new JAXL($jaxl_initialize);
            $j_username = trim($user['username']);
            $j_password = trim($user['password']);
            $xeps = array(
                '0077'
            );
            $GLOBALS['client']->require_xep($xeps);
            $GLOBALS['client']->add_cb('on_stream_features', function ($stanza)
            {
                global $argv;
                $GLOBALS['client']->xeps['0077']->get_form(JABBER_HOST);
                return "wait_for_register_form";
            });
            $GLOBALS['client']->add_cb('on_disconnect', function ()
            {
                global $form;
                _info("registration " . ($form['type'] == 'result' ? 'succeeded' : 'failed'));
            });
            $GLOBALS['client']->start();
            $xmpp_user = array(
                'username' => $j_username . '@' . JABBER_HOST,
                'password' => $j_password,
                'host' => JABBER_HOST,
                'ssl' => false,
                'port' => 5222,
                'resource' => uniqid('', true)
            );
            $xmpp = new xmpp($xmpp_user);
            $board_conditions = array(
                $user['id'],
                'f'
            );
            $boards = pg_query_params($db_lnk, 'SELECT id,name FROM boards WHERE user_id = $1 and is_closed = $2', $board_conditions);
            if ($boards && pg_num_rows($boards)) {
                while ($board = pg_fetch_assoc($boards)) {
                    $xmpp->createRoom('board-' . $board['id'], $board['name']);
                    $board_members_conditions = array(
                        $board['id']
                    );
                    $board_members = pg_query_params($db_lnk, 'SELECT u.username FROM boards_users bu left join users u on u.id = bu.user_id WHERE board_id = $1', $board_members_conditions);
                    if ($board_members && pg_num_rows($board_members)) {
                        while ($board_member = pg_fetch_assoc($board_members)) {
                            $xmpp->grantMember('board-' . $board['id'], $board_member['username'], 'member');
                        }
                    }
                }
            }
        }
    }
}
