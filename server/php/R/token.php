<?php
/**
 * Returns an OAuth2 access token to the client
 *
 * PHP version 5
 *
 * @category   PHP
 * @package    Restyaboard
 * @subpackage Core
 * @author     Restya <info@restya.com>
 * @copyright  2014 Restya
 * @license    http://restya.com/ Restya Licence
 * @link       http://restya.com/
 */
require_once 'server.php';
$server->handleTokenRequest(OAuth2\Request::createFromGlobals())->send();
