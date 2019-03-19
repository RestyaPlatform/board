<?php
exec('mkdir -p /tmp/pgpass');
exec('chmod -R go-rwx /tmp/pgpass');
$relationships = json_decode(base64_decode(getenv('PLATFORM_RELATIONSHIPS')), true);
if (!empty($relationships['database'])) {
    foreach ($relationships['database'] as $endpoint) {
          define('R_DB_HOST', 'database.internal');
          define('R_DB_USER', $endpoint['username']);
          define('R_DB_PASSWORD', $endpoint['password']);
          define('R_DB_NAME', $endpoint['path']);
          define('R_DB_PORT', $endpoint['port']);
       break;
    }
 }
echo exec(R_DB_HOST.':'.R_DB_PORT.':'.R_DB_NAME.':'.R_DB_USER.':'.R_DB_PASSWORD.' > /tmp/pgpass/.pgpass');
exec('chmod go-rwx /tmp/pgpass/.pgpass');
exec('export PGPASSFILE=/tmp/pgpass/.pgpass');
exec('psql --port='.R_DB_PORT.' --dbname='.R_DB_NAME.' --username='.R_DB_USER.' --no-password --file=../../sql/restyaboard_with_empty_data.sql');
exec('rm -rf /tmp/pgpass');
exec('touch tmp/cache/.sql.installed');


