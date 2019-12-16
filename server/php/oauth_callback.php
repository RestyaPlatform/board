<?php
/**
 * Returns an OAuth2 access token to the client
 *
 * PHP version 5
 *
 * @category   PHP
 * @package    Restyaboard
 * @subpackage Plugin
 * @author     Restya <info@restya.com>
 * @copyright  2014-2019 Restya
 * @license    http://restya.com/ Restya Licence
 * @link       http://restya.com/
 */
require_once 'config.inc.php';
require_once 'libs/core.php';
if (!empty($_GET['plugin'])) {
    $content = file_get_contents(APP_PATH . DS . 'client' . DS . 'apps' . DS . $_GET['plugin'] . DS . 'app.json');
    $data = json_decode($content, true);
    if (!empty($data['settings']['r_is_restyaboard_login']) && $data['settings']['r_is_restyaboard_login']['value'] === 'true') {
        $format = 'json';
        $oauth_clients = executeQuery('SELECT * FROM oauth_clients WHERE client_id = $1', array(
            $data['settings'][$_GET['plugin'] . '_client_id']['value']
        ));
        $post_data = array(
            'client_id' => $oauth_clients['client_id'],
            'client_secret' => $oauth_clients['client_secret'],
            'code' => $_GET['code']
        );
        if (file_exists(SITE_URL_FOR_SHELL)) {
            include_once SITE_URL_FOR_SHELL;
        }
        $url = explode("//", $_server_domain_url);
        if (!empty($oauth_clients['redirect_uri'])) {
            $post_data['redirect_uri'] = $oauth_clients['redirect_uri'];
        } else {
            $post_data['redirect_uri'] = $_server_domain_url . '/apps/' . $_GET['plugin'] . '/login.html';
        }
        $data['settings'][$_GET['plugin'] . '_oauth_token_url']['value'] = $url[0] . '//' . $oauth_clients['client_id'] . ':' . $oauth_clients['client_secret'] . '@' . $url[1] . '/api/v1/oauth/token.json';
    } else {
        $format = 'token';
        $post_data = array(
            'client_id' => $data['settings'][$_GET['plugin'] . '_client_id']['value'],
            'client_secret' => $data['settings'][$_GET['plugin'] . '_client_secret']['value'],
            'code' => $_GET['code']
        );
    }
    $response = doPost($data['settings'][$_GET['plugin'] . '_oauth_token_url']['value'], $post_data, $format);
    if (is_array($response)) {
        $response = json_encode($response);
    }
    $response_array = json_decode($response, true);
    if (json_last_error() == JSON_ERROR_NONE) {
        $access_token = $response_array['access_token'];
    } else {
        parse_str($response);
    }
    echo (!empty($access_token)) ? $access_token : 'failed';
}
