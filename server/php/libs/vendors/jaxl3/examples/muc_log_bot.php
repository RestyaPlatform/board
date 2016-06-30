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

if($argc < 5) {
	echo "Usage: $argv[0] host jid pass room@service.domain.tld nickname\n";
	exit;
}

//
// initialize JAXL object with initial config
//
require_once 'jaxl.php';
$client = new JAXL(array(
	// (required) credentials
	'jid' => $argv[2],
	'pass' => $argv[3],
	'host' => $argv[1],
	'log_level' => JAXL_INFO
));

$client->require_xep(array(
	'0045',	// MUC
	'0203',	// Delayed Delivery
	'0199'  // XMPP Ping
));

//
// add necessary event callbacks here
//

$_room_full_jid = $argv[4]."/".$argv[5];
$room_full_jid = new XMPPJid($_room_full_jid);

$client->add_cb('on_auth_success', function() {
	global $client, $room_full_jid;
	_info("got on_auth_success cb, jid ".$client->full_jid->to_string());

	// join muc room
	$client->xeps['0045']->join_room($room_full_jid);
});

$client->add_cb('on_auth_failure', function($reason) {
	global $client;
	$client->send_end_stream();
	_info("got on_auth_failure cb with reason $reason");
});

$client->add_cb('on_groupchat_message', function($stanza) {
	global $client;
	
	$from = new XMPPJid($stanza->from);
	$delay = $stanza->exists('delay', NS_DELAYED_DELIVERY);
	
	if($from->resource) {
		echo "message stanza rcvd from ".$from->resource." saying... ".$stanza->body.($delay ? ", delay timestamp ".$delay->attrs['stamp'] : ", timestamp ".gmdate("Y-m-dTH:i:sZ")).PHP_EOL;
	}
	else {
		$subject = $stanza->exists('subject');
		if($subject) {
			echo "room subject: ".$subject->text.($delay ? ", delay timestamp ".$delay->attrs['stamp'] : ", timestamp ".gmdate("Y-m-dTH:i:sZ")).PHP_EOL;
		}
	}
});

$client->add_cb('on_presence_stanza', function($stanza) {
	global $client, $room_full_jid;
	
	$from = new XMPPJid($stanza->from);
	
	// self-stanza received, we now have complete room roster
	if(strtolower($from->to_string()) == strtolower($room_full_jid->to_string())) {
		if(($x = $stanza->exists('x', NS_MUC.'#user')) !== false) {
			if(($status = $x->exists('status', null, array('code'=>'110'))) !== false) {
				$item = $x->exists('item');
				_info("xmlns #user exists with x ".$x->ns." status ".$status->attrs['code'].", affiliation:".$item->attrs['affiliation'].", role:".$item->attrs['role']);
			}
			else {
				_info("xmlns #user have no x child element");
			}
		}
		else {
			_warning("=======> odd case 1");
		}
	}
	// stanza from other users received
	else if(strtolower($from->bare) == strtolower($room_full_jid->bare)) {
		if(($x = $stanza->exists('x', NS_MUC.'#user')) !== false) {
			$item = $x->exists('item');
			echo "presence stanza of type ".($stanza->type ? $stanza->type : "available")." received from ".$from->resource.", affiliation:".$item->attrs['affiliation'].", role:".$item->attrs['role'].PHP_EOL;
		}
		else {
			_warning("=======> odd case 2");
		}
	}
	else {
		_warning("=======> odd case 3");
	}
	
});

$client->add_cb('on_disconnect', function() {
	_info("got on_disconnect cb");
});

//
// finally start configured xmpp stream
//
$client->start();
echo "done\n";

?>
