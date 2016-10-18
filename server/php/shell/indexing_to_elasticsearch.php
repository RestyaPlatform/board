<?php
/**
 * Cron to update ElasticSearch indexing
 *
 * PHP version 5
 *
 * @category   PHP
 * @package    Restyaboard
 * @subpackage Core
 * @author     Restya <info@restya.com>
 * @copyright  2014-2016 Restya
 * @license    http://restya.com/ Restya Licence
 * @link       http://restya.com/
 */
$app_path = dirname(dirname(__FILE__));

require_once $app_path . '/config.inc.php';
if (file_exists(APP_PATH . '/tmp/cache/site_url_for_shell.php')) {
    include_once APP_PATH . '/tmp/cache/site_url_for_shell.php';
}
if(empty(ELASTICSEARCH_URL) || empty(ELASTICSEARCH_INDEX)) {
    echo 'Please configure the ElasticSearch on <a href="'.$_server_domain_url.'#/settings/1">settings</a> page';    
    exit;
}
if ($db_lnk) {
    $qry_val_arr = array(
        'elasticsearch.last_processed_activity_id'
    );
    $result = pg_query_params($db_lnk, 'SELECT value FROM settings WHERE name = $1', $qry_val_arr);
    $row = pg_fetch_assoc($result);
    $row=0;
    if (!empty($row)) {
        $qry_val_arr = array(
            $row['value'],
            0
        );
        $result = pg_query_params($db_lnk, "SELECT id, card_id FROM activities WHERE id > $1 AND card_id != $2 AND board_id != $2 AND card_id IS NOT NULL ORDER BY id ASC", $qry_val_arr);
        $count = pg_num_rows($result);
        if (!empty($count)) {
            $ch = curl_init();
            while ($row = pg_fetch_assoc($result)) {
                $qry_val_arr = array(
                    $row['card_id']
                );
                $card_result = pg_query_params($db_lnk, 'SELECT id, json FROM cards_elasticsearch_listing WHERE id = $1', $qry_val_arr);
                $card_row = pg_fetch_assoc($card_result);
                if(curl_call($card_row)) {
                    $last_processed_activity_id = $row['id']; 
                }
            }
            if (!empty($last_processed_activity_id)) {
                $qry_val_arr = array(
                    $last_processed_activity_id,
                    'elasticsearch.last_processed_activity_id'
                );
                pg_query_params($db_lnk, 'UPDATE settings SET value = $1 WHERE name = $2', $qry_val_arr);
                echo 'ElasticSearch indexing is done';
            } else {
                echo 'Please check ElasticSearch is installed or not on '.ELASTICSEARCH_URL;
            }
            curl_close($ch);
        } else {
            echo 'There is no activity.';
        }
    } else {
        echo 'There is no last processed activity on database to continue.';
    }
}  else {
    echo 'There is an issue on connecting the database.';
}

function curl_call($card_row) {
    curl_setopt($ch, CURLOPT_URL, ELASTICSEARCH_URL . ELASTICSEARCH_INDEX . '/cards/' . $card_row['id']);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
    curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
    $curl_opt = array(
        'Content-Type: application/json',
        'Content-Length: ' . strlen($card_row['json'])
    );
    curl_setopt($ch, CURLOPT_HTTPHEADER, $curl_opt);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $card_row['json']);
    curl_exec($ch);
    $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    if (curl_errno($ch)) {
        echo 'Error:: ' . curl_error($ch) . PHP_EOL;
    }
    switch ($http_code) {
        case 201:
        case 200:
            return true;
            break;

        case 401:
            return false;
            break;

        default:
            return false;
    }
}