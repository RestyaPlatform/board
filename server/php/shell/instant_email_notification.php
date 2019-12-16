<?php
/**
 * Cron to send email notification by minutes based to users
 *
 * PHP version 5
 *
 * @category   PHP
 * @package    Restyaboard
 * @subpackage Core
 * @author     Restya <info@restya.com>
 * @copyright  2014-2019 Restya
 * @license    http://restya.com/ Restya Licence
 * @link       http://restya.com/
 */
if (!defined('APP_PATH')) {
    $app_path = dirname(dirname(__FILE__));
    require_once $app_path . '/config.inc.php';
    require_once $app_path . '/libs/vendors/finediff.php';
    require_once $app_path . '/libs/core.php';
}
date_default_timezone_set('GMT');
global $_server_domain_url;
if (file_exists(SITE_URL_FOR_SHELL)) {
    include_once SITE_URL_FOR_SHELL;
}
sendMailNotification(2);
