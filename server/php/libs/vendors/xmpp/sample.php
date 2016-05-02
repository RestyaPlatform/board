<?php
require 'vendor/autoload.php';
use Xmpp\Xep\Xep0045 as xmpp;
use Psr\Log\LoggerInterface;

$roomId = 'YourHouse';
$userId = 'pbaskar';

//$options = array(
//    'username'  => 'siva_063at09',
//    'password'  => 'ahsan123',
//    'host'      => '192.168.1.20',
//    'ssl'       => false,
//    'port'      => 5222,
//    'resource'  => uniqid('', true),
//    'mucServer' => 'conference.phabricator.ahsan.in', // optional
//);

$options = array(
    'username'  => 'sgopal@phabricator.ahsan.in',
    'password'  => 'a1985b7434b41fc0a195e81ac509198e',
    'host'      => 'phabricator.ahsan.in',
    'ssl'       => false,
    'port'      => 5222,
    'resource'  => uniqid('', true)
);
$xmpp = new xmpp($options);
echo '<pre>';
//$xmpp->createRoom($roomId);
//$xmpp->grantMember($roomId, $userId);
//$xmpp->register('siva', 'agriya');