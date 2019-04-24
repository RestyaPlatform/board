

<?php
/**
 * mail for main.sh
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
    require_once $app_path . '/libs/core.php';
}
global $_server_domain_url;
if (file_exists(SITE_URL_FOR_SHELL)) {
    include_once SITE_URL_FOR_SHELL;
}
if (!empty($argv) && !empty($argv[1])) {
    if ($db_lnk) {
        $to_email = DEFAULT_REPLY_TO_EMAIL_ADDRESS;
        $from_email = DEFAULT_FROM_EMAIL_ADDRESS;
        if (!empty($to_email) && !empty($from_email)) {
            $email = pg_fetch_assoc($result);
            $subject = 'Restyaboard / From cron (' . $argv[1] . ')';
            $from_email = DEFAULT_FROM_EMAIL_ADDRESS;
            $message = 'Please check the permission for the shell script file of ' . $argv[1] . ' in your server ' . $_server_domain_url;
            $headers = 'From:' . $from_email . PHP_EOL;
            if (!empty($to_email)) {
                $headers.= 'Reply-To:' . $to_email . PHP_EOL;
            }
            $headers.= "MIME-Version: 1.0" . PHP_EOL;
            $headers.= "Content-Type: text/html; charset=UTF-8" . PHP_EOL;
            $headers.= "X-Mailer: Restyaboard (0.6.7; +http://restya.com/board)" . PHP_EOL;
            $headers.= "X-Auto-Response-Suppress: All" . PHP_EOL;
            $result = mail($to_email, $subject, $message, $headers, '-f' . $from_email);
            if (R_DEBUG) {
                if (!$result) {
                    $compose_string = 'F, ' . $from_email . ', ' . $to_email . ', ' . $subject;
                } else {
                    $compose_string = 'S, ' . $from_email . ', ' . $to_email . ', ' . $subject;
                }
                error_log($compose_string, 3, CACHE_PATH . DS . 'mail.log');
            }
        }
    }
}
