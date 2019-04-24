<?php
/**
 * Cron to update
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
$app_path = dirname(dirname(__FILE__));
require_once $app_path . '/config.inc.php';
require_once $app_path . '/libs/core.php';
require_once $app_path . '/libs/vendors/finediff.php';
$files = glob(APP_PATH . DS . 'server/php/shell/*.php', GLOB_BRACE);
if (!empty($files)) {
    foreach ($files as $file) {
        if ($file !== APP_PATH . DS . 'server/php/shell/main.php') {
            include_once $file;
        }
    }
}
$pluginfiles = glob(PLUGIN_PATH . DS . '*' . DS . 'shell' . DS . '*.php', GLOB_BRACE);
if (!empty($pluginfiles)) {
    foreach ($pluginfiles as $pluginfile) {
        include_once $pluginfile;
    }
}
