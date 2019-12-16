<?php
/**
 * Platform.sh installation file
 *
 * PHP version 5
 *
 * @category   PHP
 * @package    Restyaboard
 * @subpackage Plugin
 * @author     Restya <info@restya.com>
 * @copyright  2014-2019 Restya
 * @license    http://restya.com/ Restya Licence
 * @link       http://restya.com/
 */
$current_dir = dirname(__FILE__);
exec('chmod -R 0777 ' . $current_dir . '/../../tmp ' . $current_dir . '/../../media');
exec('echo "sql file executed" > /tmp/.sql.installed');
exec('mkdir -p /tmp/pgpass');
exec('chmod -R go-rwx /tmp/pgpass');
$relationships = json_decode(base64_decode(getenv('PLATFORM_RELATIONSHIPS')) , true);
if (!empty($relationships['database'])) {
    foreach ($relationships['database'] as $endpoint) {
        define('R_DB_HOST', $endpoint['host']);
        define('R_DB_USER', $endpoint['username']);
        define('R_DB_PASSWORD', $endpoint['password']);
        define('R_DB_NAME', $endpoint['path']);
        define('R_DB_PORT', $endpoint['port']);
        break;
    }
}
exec('echo "' . R_DB_HOST . ':' . R_DB_PORT . ':' . R_DB_NAME . ':' . R_DB_USER . ':' . R_DB_PASSWORD . '" > /tmp/pgpass/.pgpass');
exec('chmod 0600 /tmp/pgpass/.pgpass');
putenv('PGPASSFILE=/tmp/pgpass/.pgpass');
exec('psql --host=' . R_DB_HOST . ' --port=' . R_DB_PORT . ' --dbname=' . R_DB_NAME . ' --username=' . R_DB_USER . ' --file=' . $current_dir . '/../../sql/restyaboard_with_empty_data.sql');
exec('rm -rf /tmp/pgpass');
