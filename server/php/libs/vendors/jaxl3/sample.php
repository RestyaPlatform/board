<?php
echo '<pre>';
require 'jaxl.php';
$client = new JAXL(array(
	'bosh_url' => 'http://192.168.1.7:5280/http-bind',
    'jid' => 'sgopal@phabricator.ahsan.in',
    'pass' => 'a1985b7434b41fc0a195e81ac509198e',
	//'auth_type' => 'PLAIN',
	'host' => '192.168.1.7',
	'port' => '5280',
	'log_level' => JAXL_INFO
));
$client->add_cb('on_auth_success', function() {
    global $client;
	echo 'sdf';
	print_r($client);
});
$client->add_cb('on_auth_failure', function($reason) {
	global $client;
	$client->send_end_stream();
	_info("got on_auth_failure cb with reason $reason");
});
$client->start();