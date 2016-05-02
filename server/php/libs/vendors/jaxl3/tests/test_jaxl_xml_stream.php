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

// TODO: support for php unit and add more tests
error_reporting(E_ALL);
require_once "jaxl.php";

/**
 * 
 * @author abhinavsingh
 *
 */
class JAXLXmlStreamTest extends PHPUnit_Framework_TestCase {
	
	function xml_start_cb($node) {
		$this->assertEquals('stream', $node->name);
		$this->assertEquals(NS_XMPP, $node->ns);
	}
	
	function xml_end_cb($node) {
		$this->assertEquals('stream', $node->name);
	}
	
	function xml_stanza_cb($node) {
		$this->assertEquals('features', $node->name);
		$this->assertEquals(1, sizeof($node->childrens));
	}
	
	function test_xml_stream_callbacks() {
		$xml = new JAXLXmlStream();
		$xml->set_callback(array(&$this, "xml_start_cb"), array(&$this, "xml_end_cb"), array(&$this, "xml_stanza_cb"));
		$xml->parse('<stream:stream xmlns:stream="http://etherx.jabber.org/streams" xmlns="jabber:client">');
		$xml->parse('<features>');
		$xml->parse('<mechanisms>');
		$xml->parse('</mechanisms>');
		$xml->parse('</features>');
		$xml->parse('</stream:stream>');
	}
}
