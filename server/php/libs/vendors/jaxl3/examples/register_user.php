<?php 
/**
 * Jaxl (Jabber XMPP Library)
 *
 * Copyright (c) 2009-2012, Abhinav Singh <me@abhinavsingh.com>.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * * Redistributions of source code must retain the above copyright
 * notice, this list of conditions and the following disclaimer.
 *
 * * Redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in
 * the documentation and/or other materials provided with the
 * distribution.
 *
 * * Neither the name of Abhinav Singh nor the names of his
 * contributors may be used to endorse or promote products derived
 * from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRIC
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
 * ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 *
 */

if($argc < 2) {
	echo "Usage: $argv[0] domain\n";
	exit;
}

//
// initialize JAXL object with initial config
//
require_once 'jaxl.php';
$client = new JAXL(array(
	'jid' => $argv[1],
	'log_level' => JAXL_DEBUG
));

$client->require_xep(array(
	'0077'	// InBand Registration	
));

//
// below are two states which become part of
// our client's xmpp_stream lifecycle
// consider as if these methods are directly
// inside xmpp_stream state machine
// 
// Note: $stanza = $args[0] is an instance of
// JAXLXml in xmpp_stream state methods, 
// it is yet not ready for easy access 
// patterns available on XMPPStanza instances
//

$form = array();

function wait_for_register_response($event, $args) {
	global $client, $form;
	
	if($event == 'stanza_cb') {
		$stanza = $args[0];
		if($stanza->name == 'iq') {
			$form['type'] = $stanza->attrs['type'];
			if($stanza->attrs['type'] == 'result') {
				echo "registration successful".PHP_EOL."shutting down...".PHP_EOL;
				$client->send_end_stream();
				return "logged_out";
			}
			else if($stanza->attrs['type'] == 'error') {
				$error = $stanza->exists('error');
				echo "registration failed with error code: ".$error->attrs['code']." and type: ".$error->attrs['type'].PHP_EOL;
				echo "error text: ".$error->exists('text')->text.PHP_EOL;
				echo "shutting down...".PHP_EOL;
				$client->send_end_stream();
				return "logged_out";
			}
		}
	}
	else {
		_notice("unhandled event $event rcvd");
	}
}

function wait_for_register_form($event, $args) {
	global $client, $form;
	
	$stanza = $args[0];
	$query = $stanza->exists('query', NS_INBAND_REGISTER);
	if($query) {
		$instructions = $query->exists('instructions');
		if($instructions) {
			echo $instructions->text.PHP_EOL;
		}
		
		foreach($query->childrens as $k=>$child) {
			if($child->name != 'instructions') {
				$form[$child->name] = readline($child->name.":");
				
			}
		}
		
		$client->xeps['0077']->set_form($stanza->attrs['from'], $form);
		return "wait_for_register_response";
	}
	else {
		$client->end_stream();
		return "logged_out";
	}
}

//
// add necessary event callbacks here
//

$client->add_cb('on_stream_features', function($stanza) {
	global $client, $argv;
	$client->xeps['0077']->get_form($argv[1]);
	return "wait_for_register_form";
});

$client->add_cb('on_disconnect', function() {
	global $form;
	_info("registration " . ($form['type'] == 'result' ? 'succeeded' : 'failed'));
});

//
// finally start configured xmpp stream
//
$client->start();

//
// if registration was successful
// try to connect with newly registered account
//
if($form['type'] == 'result') {

_info("connecting newly registered user account");
$client = new JAXL(array(
	'jid' => $form['username'].'@'.$argv[1],
	'pass' => $form['password'],
	'log_level' => JAXL_DEBUG
));

$client->add_cb('on_auth_success', function() {
	global $client;
	$client->set_status('Available');
});

$client->start();

}

echo "done\n";

?>
