<?php
/**
 * Cron to send email notification by hourly based to users
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
define('WEEK_TEMP_FILE', CACHE_PATH . DS . 'week_email_notification.php');
date_default_timezone_set('GMT');
global $_server_domain_url;
if (file_exists(SITE_URL_FOR_SHELL)) {
    include_once SITE_URL_FOR_SHELL;
}
if (!file_exists(WEEK_TEMP_FILE)) {
    $fh = fopen(WEEK_TEMP_FILE, "a");
    fwrite($fh, '<?php' . "\n" . '$_weekend_email_notification_time_trace = \'' . strtotime('now') . '\';');
    fclose($fh);
}
if (file_exists(WEEK_TEMP_FILE)) {
    include_once WEEK_TEMP_FILE;
}
$weekDay = date('w', strtotime('now')); // Get Weekend
if (round((strtotime('now') - $_weekend_email_notification_time_trace) / (60 * 60 * 24)) > 0 && $weekDay == 0) {
    file_put_contents(WEEK_TEMP_FILE, '<?php' . "\n" . '$_weekend_email_notification_time_trace = \'' . strtotime('now') . '\';');
    sendMailNotification(4);
}
