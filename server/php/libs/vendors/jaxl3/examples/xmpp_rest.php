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

// View explanation for this example here:
// https://groups.google.com/d/msg/jaxl/QaGjZP4A2gY/n6SYutrBVxsJ
if($argc < 3) {
	echo "Usage: $argv[0] jid pass\n";
	exit;
}

// initialize xmpp client
require_once 'jaxl.php';
$xmpp = new JAXL(array(
	'jid' => $argv[1],
	'pass' => $argv[2],
	'log_level' => JAXL_INFO
));

// register callbacks on required xmpp events
$xmpp->add_cb('on_auth_success', function() {
	global $xmpp;
	_info("got on_auth_success cb, jid ".$xmpp->full_jid->to_string());
});

// initialize http server
require_once JAXL_CWD.'/http/http_server.php';
$http = new HTTPServer();

// add generic callback
// you can also dispatch REST style callback
// Refer: http://jaxl.readthedocs.org/en/latest/users/http_extensions.html#dispatch-rules
$http->cb = function($request) {
	// For demo purposes we simply return xmpp client full jid
	global $xmpp;
	$request->ok($xmpp->full_jid->to_string());
};

// This will start main JAXLLoop,
// hence we don't need to call $http->start() explicitly
$xmpp->start();

?>
