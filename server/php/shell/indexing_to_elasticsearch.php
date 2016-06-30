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
if ($db_lnk) {
    $qry_val_arr = array(
        'elasticsearch.last_processed_activity_id'
    );
    $result = pg_query_params($db_lnk, 'SELECT value FROM settings WHERE name = $1', $qry_val_arr);
    $row = pg_fetch_assoc($result);
    if (!empty($row)) {
        $qry_val_arr = array(
            $row['value'],
            0
        );
        $result = pg_query_params($db_lnk, "SELECT id, card_id FROM activities WHERE id > $1 AND card_id != $2 AND board_id != $2 AND card_id IS NOT NULL ORDER BY id ASC", $qry_val_arr);
        $count = pg_num_rows($result);
        if ($count) {
            $ch = curl_init();
            while ($row = pg_fetch_assoc($result)) {
                $qry_val_arr = array(
                    $row['card_id']
                );
                $card_result = pg_query_params($db_lnk, 'SELECT id, json FROM cards_elasticsearch_listing WHERE id = $1', $qry_val_arr);
                $card_row = pg_fetch_assoc($card_result);
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
                    $last_processed_activity_id = $row['id'];
                    echo 'Saved Successfully.' . PHP_EOL;
                    break;

                case 401:
                    echo 'Unauthorized.' . PHP_EOL;
                    break;

                default:
                    echo 'Not Found.' . PHP_EOL;
                }
            }
            if (!empty($last_processed_activity_id)) {
                $qry_val_arr = array(
                    $last_processed_activity_id,
                    'elasticsearch.last_processed_activity_id'
                );
                pg_query_params($db_lnk, 'UPDATE settings SET value = $1 WHERE name = $2', $qry_val_arr);
            }
            curl_close($ch);
        }
    }
}
