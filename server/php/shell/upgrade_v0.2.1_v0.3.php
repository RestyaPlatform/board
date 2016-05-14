<?php
/**
 * To upgrade v0.2.1 to v0.3
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
// Delete ElasticSearch index
$ch = curl_init(ELASTICSEARCH_URL . ELASTICSEARCH_INDEX);
curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'DELETE');
$result = curl_exec($ch);
// Update setting to re-index data
$qry_val_arr = array(
    0,
    'elasticsearch.last_processed_activity_id'
);
pg_query_params($db_lnk, 'UPDATE settings SET value = $1 WHERE name = $2', $qry_val_arr);
