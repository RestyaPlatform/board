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
 * @copyright  2014-2022 Restya
 * @license    http://restya.com/ Restya Licence
 * @link       http://restya.com/
 */
if (!defined('APP_PATH')) {
    $app_path = dirname(dirname(__FILE__));
    require_once $app_path . '/config.inc.php';
    require_once $app_path . '/libs/core.php';
}
global $_server_domain_url;
if ($db_lnk) {
    $qry_val_arr = array(
        'webhooks.last_processed_activity_id'
    );
    $result = pg_query_params($db_lnk, 'SELECT value FROM settings WHERE name = $1', $qry_val_arr);
    $row = pg_fetch_assoc($result);
    if (!empty($row)) {
        $qry_val_arr = array(
            $row['value'],
            0
        );
        $activities = pg_query_params($db_lnk, "SELECT * FROM activities_listing WHERE id > $1 AND card_id != $2 AND card_id IS NOT NULL ORDER BY id ASC", $qry_val_arr);
        $count = pg_num_rows($activities);
        if ($count) {
            while ($activity = pg_fetch_assoc($activities)) {
                $qry_val_arr = array(
                    true
                );
                $result = pg_query_params($db_lnk, "SELECT * FROM webhooks WHERE is_active = $1", $qry_val_arr);
                $count = pg_num_rows($result);
                if ($count) {
                    $i = 1;
                    $mh = curl_multi_init();
                    $status = 1;
                    while ($row = pg_fetch_assoc($result)) {
                        $activity_json = '';
                        $activities_enabled = array();
                        if (!empty($row['activities_enabled'])) {
                            $activities_enabled = explode(',', $row['activities_enabled']);
                        }
                        if (empty($activities_enabled) || (!empty($activities_enabled) && in_array($activity['type'], $activities_enabled))) {
                            if ($row['type'] != 'Default') {
                                require_once $app_path . DS . 'plugins' . DS . $row['type'] . DS . 'functions.php';
                                $function_name = 'postIn' . $row['type'];
                                $activity_json = $function_name($row, $activity, $_server_domain_url);
                            } else {
                                $activity_json = json_encode($activity);
                            }
                        }
                        if (empty($activity_json)) {
                            $status = 0;
                            continue;
                        }
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
                    if ($status) {
                        do {
                            $mrc = curl_multi_exec($mh, $active);
                        } while ($mrc == CURLM_CALL_MULTI_PERFORM);
                        do {
                            curl_multi_exec($mh, $running);
                            curl_multi_select($mh);
                        } while ($running > 0);
                        $j = 1;
                        $ch = 'ch' . $j;
                        while ($row = pg_fetch_assoc($result)) {
                            curl_multi_remove_handle($mh, $$ch);
                            $j++;
                        }
                    }
                    $last_processed_activity_id = $activity['id'];
                    $qry_val_arr = array(
                        $last_processed_activity_id,
                        'webhooks.last_processed_activity_id'
                    );
                    pg_query_params($db_lnk, 'UPDATE settings SET value = $1 WHERE name = $2', $qry_val_arr);
                    curl_multi_close($mh);
                }
            }
        }
    }
}
