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
 * @copyright  2014-2016 Restya
 * @license    http://restya.com/ Restya Licence
 * @link       http://restya.com/
 */
require_once 'config.inc.php';
require_once 'libs/core.php';
if (!empty($_GET['plugin'])) {
    $content = file_get_contents(APP_PATH . DIRECTORY_SEPARATOR . 'client' . DIRECTORY_SEPARATOR . 'apps' . DIRECTORY_SEPARATOR . $_GET['plugin'] . DIRECTORY_SEPARATOR . 'app.json');
    $data = json_decode($content, true);
    $post_data = array(
        'client_id' => $data['settings'][$_GET['plugin'] . '_client_id']['value'],
        'client_secret' => $data['settings'][$_GET['plugin'] . '_client_secret']['value'],
        'code' => $_GET['code']
    );
	if ($_GET['plugin'] == 'r_zapier') {
		$post_data['redirect_uri'] = $data['settings'][$_GET['plugin'] . '_redirect_uri']['value'];
	}
	$format = ($_GET['plugin'] == 'r_zapier') ? 'json' : 'token';
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
