<?php
/**
 * To delete board subscribers
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
require_once 'config.inc.php';
require_once 'libs/core.php';
if ($db_lnk) {
    $activities = pg_query_params($db_lnk, "SELECT * FROM activities where freshness_ts is null and (type='add_comment' or type='edit_comment')", array());
    while ($activity = pg_fetch_assoc($activities)) {
        $id_converted = base_convert($activity['id'], 10, 36);
        $materialized_path = sprintf("%08s", $id_converted);
        $path = 'P' . $activity['id'];
        $depth = 0;
        $root = $activity['id'];
        $freshness_ts = $activity['created'];
        $qry_val_arr = array(
            $materialized_path,
            $path,
            $depth,
            $root,
            $freshness_ts,
            $activity['id']
        );
        pg_query_params($db_lnk, 'UPDATE activities SET materialized_path = $1, path = $2, depth = $3, root = $4, freshness_ts = $5 WHERE id = $6', $qry_val_arr);
        $qry_val_arr = array(
            $freshness_ts,
            $root
        );
        pg_query_params($db_lnk, 'UPDATE activities SET freshness_ts = $1 WHERE root = $2', $qry_val_arr);
    }
}
