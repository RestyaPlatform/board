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
 * @copyright  2014-2017 Restya
 * @license    http://restya.com/ Restya Licence
 * @link       http://restya.com/
 */
$app_path = dirname(dirname(__FILE__));
require_once $app_path . '/config.inc.php';
if ($db_lnk) {
    $qry_val_arr = array(
        'webhooks.last_processed_activity_id'
    );
    $result = executeQuery('SELECT value FROM settings WHERE name = ?', $qry_val_arr);
    $row = $result;
    if (!empty($row)) {
        $qry_val_arr = array(
            $row['value'],
            0
        );
        $activities = executeQueryAll("SELECT * FROM activities_listing WHERE id > ? AND card_id != ? AND card_id IS NOT NULL ORDER BY id ASC", $qry_val_arr);
        $count = count($activities);
        if ($count) {
            foreach ($activities as $activity) {
                $activity_json = json_encode($activity);
                $qry_val_arr = array(
                    true
                );
                $result = executeQueryAll("SELECT * FROM webhooks WHERE is_active = ?", $qry_val_arr);
                $count = count($result);
                if ($count) {
                    $i = 1;
                    $mh = curl_multi_init();
                    foreach ($result as $row) {
                        $ch = 'ch' . $i;
                        $$ch = curl_init();
                        curl_setopt($$ch, CURLOPT_URL, $row['url']);
                        $curl_opt = array(
                            'Content-Type: application/json',
                            'Content-Length: ' . strlen($activity_json)
                        );
                        curl_setopt($$ch, CURLOPT_HTTPHEADER, $curl_opt);
                        curl_setopt($$ch, CURLOPT_POST, true);
                        curl_setopt($$ch, CURLOPT_POSTFIELDS, $activity_json);
                        curl_multi_add_handle($mh, $$ch);
                        $i++;
                    }
                    do {
                        $mrc = curl_multi_exec($mh, $active);
                    } while ($mrc == CURLM_CALL_MULTI_PERFORM);
                    do {
                        curl_multi_exec($mh, $running);
                        curl_multi_select($mh);
                    } while ($running > 0);
                    $j = 1;
                    $ch = 'ch' . $j;
                    foreach ($result as $row) {
                        curl_multi_remove_handle($mh, $$ch);
                        $j++;
                    }
                    $last_processed_activity_id = $activity['id'];
                    $qry_val_arr = array(
                        $last_processed_activity_id,
                        'webhooks.last_processed_activity_id'
                    );
                    executeQuery('UPDATE settings SET value = ? WHERE name = ?', $qry_val_arr);
                    curl_multi_close($mh);
                }
            }
        }
    }
}
