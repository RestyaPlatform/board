<?php
$data = '<body xmlns="http://jabber.org/protocol/httpbind" content="text/xml; charset=utf-8" to="phabricator.ahsan.in" route="xmpp:192.168.1.7:5280" secure="true" xml:lang="en" xmpp:version="1.0" xmlns:xmpp="urn:xmpp:xbosh" hold="1" wait="30" rid="1845" ver="1.10" from="sgopal@phabricator.ahsan.in"></body>';
$ch = curl_init('http://192.168.1.7:5280/http-bind');
curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'POST');
curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
$result = curl_exec($ch);
echo '<pre>';
if (curl_errno($ch)) {
    echo 'error:' . curl_error($ch);
}
echo $result;