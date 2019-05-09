<?php
/**
 * Diagnose
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
$nginx_class = true;
exec("which nginx", $nginx_version);
if (!empty($nginx_version[0])) {
    $nginx_class = true;
}
$php_class = false;
if (version_compare(PHP_VERSION, '5.2.0', '>')) {
    $php_class = true;
}
$psql_class = false;
exec("psql --version | egrep -o '[0-9]{1,}\.[0-9]{1,}'", $psql_version);
if ($psql_version[0] >= '9.2') {
    $psql_class = true;
}
$gd_class = false;
if (function_exists('gd_info')) {
    $gd_version_arr = gd_info();
    $gd_version = $gd_version_arr['GD Version'];
    $gd_class = true;
}
$imagick_class = false;
$imagick_version = '';
if (class_exists('imagick')) {
    $imagick_version_arr = Imagick::getVersion();
    $imagick_version = $imagick_version_arr['versionString'];
    $imagick_class = true;
}
$curl_class = false;
if (function_exists('curl_init')) {
    $curl_version_arr = curl_version();
    $curl_version = $curl_version_arr['version'];
    $curl_class = true;
}
require_once 'server/php/config.inc.php';
ini_set('display_errors', true);
$settings = pg_query_params($db_lnk, 'SELECT name, value FROM settings', array());
while ($setting = pg_fetch_assoc($settings)) {
    if (!defined($setting['name'])) {
        define($setting['name'], $setting['value']);
    }
};
$sitename_setting_class = false; 
if (SITE_NAME != 'Restyaboard') {
    $sitename_setting_class = true;
}
$dropbox_setting_class = false;
if (DROPBOX_APPKEY) {
    $dropbox_setting_class = true;
}
$flickr_setting_class = false;
if (FLICKR_API_KEY) {
    $flickr_setting_class = true;
}
$email_setting_class = false;
if (DEFAULT_REPLY_TO_EMAIL_ADDRESS != 'board@restya.com' && DEFAULT_FROM_EMAIL_ADDRESS != 'board@restya.com' && DEFAULT_CONTACT_EMAIL_ADDRESS != 'board@restya.com') {
    $email_setting_class = true;
}
$imap_setting_class = false;
if (IMAP_HOST && IMAP_PORT && IMAP_EMAIL && IMAP_EMAIL_PASSWORD) {
    $imap_setting_class = true;
}
$imap_class = $imap_connection_class = false;
$imap_version = $imap_connection = ''; 
if (function_exists('imap_open')) {
    $imap_class = true;
    if ($imap_setting_class) {
        $is_ssl = (IMAP_PORT === '993') ? 'ssl/' : '';
        $imap_email_password = IMAP_EMAIL_PASSWORD;
        $imap_email_password_decode = base64_decode($imap_email_password);
        $imap_email_password = str_rot13($imap_email_password_decode);
        $connection = imap_open('{' . IMAP_HOST . ':' . IMAP_PORT . '/imap/' . $is_ssl . 'novalidate-cert}INBOX', IMAP_EMAIL, $imap_email_password, NULL, 1, array(
            'DISABLE_AUTHENTICATOR' => 'PLAIN'
        ));
        if ($connection) {
            $imap_connection = 'Success';
            $imap_connection_class = true;
        }
    }
}
function _is_writable_recursive($dir) {
    if (!($folder = @opendir($dir))) {
        return false;
    }
    while ($file = readdir($folder)) {
        if ($file != '.' && $file != '..' && (!is_writable($dir . '/' . $file) || (is_dir($dir . '/' . $file) && !_is_writable_recursive($dir . '/' . $file)))) {
            closedir($folder);
            return false;
        }
    }
    closedir($folder);
    return true;
}
if (file_exists(APP_PATH . '/client/apps/r_ldap_login/app.json')) {
    $is_having_ldap_plugin = true;
    $ldap_class = false;
    if (function_exists('ldap_connect')) {
        $ldap_version = '';
        $ldap_class = true;
    }
    $g_enable_ssl_connectivity = R_LDAP_LOGIN_ENABLE_SSL;    
    $g_ldap_protocol_version = R_LDAP_LOGIN_PROTOCOL_VERSION;
    $g_ldap_server = R_LDAP_LOGIN_SERVER;
    $g_ldap_port = R_LDAP_LOGIN_PORT;
    $g_ldap_bind_dn = R_LDAP_LOGIN_BIND_DN;
    $g_ldap_bind_passwd = R_LDAP_LOGIN_BIND_PASSWORD;
    $t_ldap_server = ($g_enable_ssl_connectivity == 'true') ? 'ldaps://' . $g_ldap_server : 'ldap://' . $g_ldap_server;
    $ldap_connection_class = false;
    $ldap_connection = '';
    if (function_exists('ldap_connect')) {
        $t_ds = ldap_connect($t_ldap_server, $g_ldap_port);
        if ($t_ds > 0) {
            if ($g_ldap_protocol_version > 0) {
                ldap_set_option($t_ds, LDAP_OPT_PROTOCOL_VERSION, $g_ldap_protocol_version);
            }
            if (!empty($g_ldap_bind_dn) && !empty($g_ldap_bind_passwd)) {
                $t_br = ldap_bind($t_ds, $g_ldap_bind_dn, str_rot13(base64_decode($g_ldap_bind_passwd)));
            } else {
                $t_br = ldap_bind($t_ds);
            }
            if ($t_br) {
                $ldap_connection = 'Success';
                $ldap_connection_class = true;
            } else {
                $ldap_connection = 'ERROR_LDAP_AUTH_FAILED';
            }
        } else {
            $ldap_connection = 'ERROR_LDAP_SERVER_CONNECT_FAILED';
        }
    }
}
if (file_exists(APP_PATH . '/client/apps/r_elasticsearch/app.json')) {
    $is_having_elasticsearch_plugin = true;
    $elasticsearch_server_class = $elasticsearch_port_class = $elasticsearch_index_class = $elasticsearch_class = false;
    $elasticsearch_version = $elasticsearch_connection = '';
    $elasticsearch_json = file_get_contents(APP_PATH . DS .'client' . DS . 'apps' . DS . 'r_elasticsearch' . DS . 'app.json');
    $elasticsearch_data = json_decode($elasticsearch_json, true);
    if ($elasticsearch_data['settings']['r_elasticsearch_server_host']['value'] != 'REPLACE_ELASTIC_SEARCH_SERVER_HOST') {
        $elasticsearch_server_class = $elasticsearch_data['settings']['r_elasticsearch_server_host']['value'];
    }
    if ($elasticsearch_data['settings']['r_elasticsearch_server_port']['value'] != 'REPLACE_ELASTIC_SEARCH_SERVER_PORT') {
        $elasticsearch_port_class = $elasticsearch_data['settings']['r_elasticsearch_server_port']['value'];
    }
    if ($elasticsearch_data['settings']['r_elasticsearch_index_name']['value'] != 'REPLACE_ELASTIC_SEARCH_INDEX_NAME') {
        $elasticsearch_index_class = $elasticsearch_data['settings']['r_elasticsearch_index_name']['value'];
    }
    if (function_exists('curl_init')) {
        $ch = curl_init('http://'.$elasticsearch_server_class. ':'. $elasticsearch_port_class . '/' . $elasticsearch_index_class . '/cards/_search');
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
        curl_setopt($ch, CURLOPT_USERAGENT, $_SERVER['HTTP_USER_AGENT']);
        curl_setopt($ch, CURLOPT_POST, false);
        $response = curl_exec($ch);
        $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        if (in_array($http_code, array(201, 200))) {
            $elasticsearch_class = true;
            $elasticsearch_connection_class = true;
            $response_arr = json_decode($response, true);
            $elasticsearch_connection = $response_arr['hits']['total'] . ' records indexed';
        }
    }
}
$_writable_folders = array(
    TMP_PATH,
    MEDIA_PATH,
    IMG_PATH
);
$writable = '';
foreach($_writable_folders as $folder) {
    if (_is_writable_recursive($folder)) {
        $writable.= '<tr><td> ' . $folder . '</td><td class="green">Writable</td></tr>';
    } else {
        $writable.= '<tr><td>' . $folder . '</td><td class="red">Not Writable</td></tr>';
    }
}
$_writable_files = array(
    APP_PATH . '/server/php/shell/main.sh'
);
foreach($_writable_files as $file) {
    if (file_exists($file)) {
        if (is_writable($file)) {
            $writable.= '<tr><td> ' . $file . '</td><td class="green">Writable</td></tr>';
        } else {
            $writable.= '<tr><td>' . $file . '</td><td class="red">Not Writable</td></tr>';
        }
    }
}
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Restyaboard - Diagnostic Tool</title>
<style type="text/css">
body {
    color: #4c4c4c;
    line-height: 18px;
    font-size: 12px;
    font-family: verdana;
}
table.list,
table.list td,
table.list th {
    border: 1px solid #e5e5e5;
}
table.topic-list td,
table.topic-list th {
    border: none;
    border-bottom: 1px solid #e5e5e5;
}
table.list,
table.list-info {
    border-spacing: 0;
    border-collapse: collapse;
    margin: 5px auto;
    width: 90%;
}
table.list td,
table.list th {
    padding: 6px 5px;
    border-width: 1px;
    background-color: #fff;
    vertical-align: middle;
    font-size: 12px;
    font-family: verdana;
}
table.list td {
    text-align: left;
}
table.list th {
    color: #36769C;
    background: #DCEDF2;
    text-align: left;
}
table.list th a {
    color: #36769C;
}
table.list th a:hover {
    text-decoration: none;
}
table.list tr.altrow td {
    background-color: #f0f7fe;
}
table.list tr:hover td {
    background-color: #EFFDFF;
}
table.list tr th.dl,
table.list tr td.dl {
    text-align: left;
}
table.list tr th.deal-name,
table.list tr td.deal-name {
    width: 150px;
    white-space: wrap;
}
table.list tr th.dc,
table.list tr td.dc {
    text-align: center;
}
table.list tr th.dr,
table.list tr td.dr {
    text-align: right;
}
table.list tr.total-block td {
    background: #f0f8fe;
    font-weight: bold;
}
table.list tr td.deal-name,
table.list tr th.deal-name {
    width: 220px;
}
table.list tr td.green,
table.list-info tr td.green {
    background: #91CE5F;
    color: white;
    font-size: 13px;
    font-weight: bold;
}
table.list tr td.red,
table.list-info tr td.red {
    background: #ED6F75;
    color: white;
    font-size: 13px;
    font-weight: bold;
}
table.list tr td.yellow,
table.list-info tr td.yellow {
    background: #F2F27D;
    color: #333333;
    font-size: 13px;
    font-weight: bold;
}
table.list tr td.orange,
table.list-info tr td.orange {
    background: #F7A33D;
    color: white;
    font-size: 13px;
    font-weight: bold;
}
table.list-info {
    float: right;
}
table.list-info tr td {
    margin: 0;
    padding: 0 10px 0 5px;
    border-bottom: 2px solid #e5e5e5;
    background-color: #fff;
    vertical-align: middle;
    font-size: 12px;
    font-family: verdana;
    text-align: left;
}
table.list-info tr td.green,
table.list-info tr td.red,
table.list-info tr td.yellow,
table.list-info tr td.orange,
table.list-info tr td.orange {
    background: #91CE5F;
    width: 20px;
    padding: 0;
}
table.list-info tr td.red {
    background: #ED6F75;
}
table.list-info tr td.yellow {
    background: #F2F27D;
}
table.list tr td.orange,
table.list-info tr td.orange {
    background: #F7A33D;
}
div.list-info-block {
    float: right;
    width: 625px;
}
div.top-block-left {
    float: left;
}
div.top-block {
    min-height: 90px;
    overflow: hidden;
}
.green_req_details {
    background: #52AF0A;
    color: #FFFFFF;
}
.red_req_details {
    background: #DB3D47;
    color: #FFFFFF;
    padding: 2px 0px;
}
.red_req_details h1 {
    font-size: 17px;
}
.orange_req_details {
    background: #f68e08;
    color: #FFFFFF;
}
.yellow_req_details {
    background: #FAFA3D;
    color: #000000;
}
h1 {
    font-size: 22px !important;
}
div#final_verdict h1 {
    font-size: 18px !important;
}
</style>
</head>
<body>
   <div class="top-block">
      <div class="top-block-left">
         <h1>Restyaboard Diagnostic Tool</h1>
         <em>This tool will check server and software configuration</em>
         <h2> Step 1: Checking Server Requirements... </h2>
      </div>
      <div class="list-info-block">
         <table class="list-info">
            <tr>
               <td class="green">&nbsp;</td>
               <td> - Requirement Met!</td>
               <td class="red">&nbsp;</td>
               <td> - Requirement not met. <b>Need to fix!</b></td>
            </tr>
            <tr>
               <td class="orange">&nbsp;</td>
               <td> - Requirement met, but, unable to check exact version.</td>
               <td class="yellow">&nbsp;</td>
               <td> - Requirement not met, but, its not madatory.</td>
            </tr>
         </table>
      </div>
   </div>
   <table border="2" class="list">
   <tr>
      <th colspan="2"> Settings </th>
      <th> Required Server Settings </th>
      <th> Current  Server Settings </th>
   </tr>
   <tr>
      <th colspan="4"> Mandatory </th>
   </tr>
   <tr>
      <td colspan="2"> Nginx </td>
      <td> </td>
      <td class="<?php echo (!empty($nginx_class)) ? 'green' : 'red'; ?>"> <?php echo !empty($nginx_version[0]) ? $nginx_version[0] : ''; ?></td>
   </tr>
   <tr>
      <td colspan="2"> PHP Version </td>
      <td><p>v0.0.1 to v0.4.2, 5.2+ (preferably 5.3.5)</p></td>
      <td class="<?php echo (!empty($php_class)) ? 'green' : 'red'; ?>"> <?php echo PHP_VERSION; ?></td>
   </tr>
   <tr>
      <td rowspan="5"> PHP Extensions </td>
      <td> GD </td>
      <td> 2.x+ </td>
      <td class="<?php echo (!empty($gd_class)) ? 'green' : 'red'; ?>"> <?php echo $gd_version; ?> </td>
   </tr>
   <tr>
      <td> Imagick </td>
      <td> 6.x+ </td>
      <td class="<?php echo (!empty($imagick_class) && empty($gd_class)) ? 'green' : ((!empty($gd_class)) ? 'orange' : 'red'); ?>"> <?php echo $imagick_version; ?> </td>
   </tr>
   <tr>
      <td> CURL </td>
      <td> 7.x+ </td>
      <td class="<?php echo (!empty($curl_class)) ? 'green' : 'red'; ?>"> <?php echo $curl_version; ?> </td>
   </tr>
   <tr>
      <td> IMAP </td>
      <td>  </td>
      <td class="<?php echo (!empty($imap_class)) ? 'orange' : 'red'; ?>"> <?php echo $imap_version; ?> </td>
   </tr>
   <?php if (!empty($is_having_ldap_plugin)): ?>
   <tr>
      <td> LDAP </td>
      <td>  </td>
      <td class="<?php echo (!empty($ldap_class)) ? 'orange' : 'red'; ?>"> <?php echo $ldap_version; ?> </td>
   </tr>
   <?php endif; ?>
   <tr>
      <td colspan="2"> PostgreSQL Version </td>
      <td> 9.3+ </td>
      <td class="<?php echo (!empty($psql_class)) ? 'green' : 'red'; ?>"> <?php echo $psql_version[0]; ?> </td>
   </tr>
   <?php if (!empty($is_having_elasticsearch_plugin)): ?>
   <tr>
      <td colspan="2"> ElasticSearch Version </td>
      <td> 0.9+ </td>
      <td class="<?php echo (!empty($elasticsearch_class)) ? 'green' : 'red'; ?>"> <?php echo $elasticsearch_version; ?> </td>
   </tr>
   <?php endif; ?>
   </table>
   <h2>Step 2: Checking File Permissions...</h2>
   <table border="2" class="list">
   <tr>
        <th> Folders</th>
        <th> Permissions</th>
   </tr>
   <?php echo $writable; ?>
   </table>
   <h2>Step 3: Checking Third Party Configuration...</h2>
   <table border="2" class="list">
   <tr>
       <th> Settings </th>
       <th> Updated? </th>
   </tr>
   <tr>
       <td> Site Name </td>
       <td class="<?php echo (!empty($sitename_setting_class)) ? 'green' : 'red'; ?>"> <?php echo SITE_NAME; ?> </td>
   </tr>
   <tr>
       <td> Email </td>
       <td class="<?php echo (!empty($email_setting_class)) ? 'green' : 'red'; ?>"> <?php echo DEFAULT_FROM_EMAIL_ADDRESS; ?> </td>
   </tr>
   <tr>
       <td> Dropbox APP Key </td>
       <td class="<?php echo (!empty($dropbox_setting_class)) ? 'green' : 'red'; ?>"> <?php echo DROPBOX_APPKEY; ?> </td>
   </tr>
   <tr>
       <td> Flickr API Key </td>
       <td class="<?php echo (!empty($flickr_setting_class)) ? 'green' : 'red'; ?>"> <?php echo FLICKR_API_KEY; ?> 
   </tr>
   <tr>
       <td> IMAP </td>
       <td class="<?php echo (!empty($imap_setting_class)) ? 'green' : 'red'; ?>"> <?php echo IMAP_EMAIL; ?> 
   </tr>
   <?php if (!empty($is_having_elasticsearch_plugin)): ?>
   <tr>
       <td> ElasticSearch Server </td>
       <td class="<?php echo (!empty($elasticsearch_server_class)) ? 'green' : 'red'; ?>"> <?php echo $elasticsearch_server_class; ?> 
   </tr>
   <tr>
       <td> ElasticSearch Index </td>
       <td class="<?php echo (!empty($elasticsearch_index_class)) ? 'green' : 'red'; ?>"> <?php echo $elasticsearch_index_class; ?> 
   </tr>
   <?php endif; ?>
   </table>
   <h2>Step 3: Checking Third Party Connection...</h2>
   <table border="2" class="list">
   <tr>
       <th> Software </th>
       <th> Connected? </th>
   </tr>
   <tr>
       <td> IMAP </td>
       <td class="<?php echo (!empty($imap_connection_class)) ? 'green' : 'red'; ?>"> <?php echo $imap_connection; ?> 
   </tr>
   <?php if (!empty($is_having_ldap_plugin)): ?>
   <tr>
       <td> LDAP </td>
       <td class="<?php echo (!empty($ldap_connection_class)) ? 'green' : 'red'; ?>"> <?php echo $ldap_connection; ?> 
   </tr>
   <?php endif; ?>
   <?php if (!empty($is_having_elasticsearch_plugin)): ?>
   <tr>
       <td> ElasticSearch </td>
       <td class="<?php echo (!empty($elasticsearch_connection_class)) ? 'green' : 'red'; ?>"> <?php echo $elasticsearch_connection; ?> 
   </tr>
   <?php endif; ?>
</body>
</html>

