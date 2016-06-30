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

// enable multi client support
// this will force 1st parameter of callbacks
// as connected client instance
define('JAXL_MULTI_CLIENT', true);

// input multiple account credentials
$accounts = array();
$add_new = TRUE;
while($add_new) {
	$jid = readline('Enter Jabber Id: ');
	$pass = readline('Enter Password: ');
	$accounts[] = array($jid, $pass);
	$next = readline('Add another account (y/n): ');
	$add_new = $next == 'y' ? TRUE : FALSE;
}

// setup jaxl
require_once 'jaxl.php';

//
// common callbacks
//

function on_auth_success($client) {
	_info("got on_auth_success cb, jid ".$client->full_jid->to_string());
	
	// fetch roster list
	$client->get_roster();
	
	// fetch vcard
	$client->get_vcard();
	
	// set status
	$client->set_status("available!", "dnd", 10);
}

function on_auth_failure($client, $reason) {
	_info("got on_auth_failure cb with reason $reason");
	$client->send_end_stream();
}

function on_chat_message($client, $stanza) {
	// echo back incoming chat message stanza
	$stanza->to = $stanza->from;
	$stanza->from = $client->full_jid->to_string();
	$client->send($stanza);
}

function on_presence_stanza($client, $stanza) {
	global $client;
	
	$type = ($stanza->type ? $stanza->type : "available");
	$show = ($stanza->show ? $stanza->show : "???");
	_info($stanza->from." is now ".$type." ($show)");
	
	if($type == "available") {
		// fetch vcard
		$client->get_vcard($stanza->from);
	}
}

function on_disconnect($client) {
	_info("got on_disconnect cb");
}

//
// bootstrap all account instances
//

foreach($accounts as $account) {
	$client = new JAXL(array(
		'jid' => $account[0],
		'pass' => $account[1],
		'log_level' => JAXL_DEBUG
	));
	
	$client->add_cb('on_auth_success', 'on_auth_success');
	$client->add_cb('on_auth_failure', 'on_auth_failure');
	$client->add_cb('on_chat_message', 'on_chat_message');
	$client->add_cb('on_presence_stanza', 'on_presence_stanza');
	$client->add_cb('on_disconnect', 'on_disconnect');
	
	$client->connect($client->get_socket_path());
	$client->start_stream();
}

// start core loop
JAXLLoop::run();
echo "done\n";

?>
