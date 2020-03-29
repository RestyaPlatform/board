#!/bin/sh
set -e

if [ "$1" = 'start' ]; then

  # config
  sed -i \
      -e "s/^.*'R_DB_HOST'.*$/define('R_DB_HOST', '${POSTGRES_HOST}');/g" \
      -e "s/^.*'R_DB_PORT'.*$/define('R_DB_PORT', '${POSTGRES_PORT}');/g" \
      -e "s/^.*'R_DB_USER'.*$/define('R_DB_USER', '${POSTGRES_USER}');/g" \
      -e "s/^.*'R_DB_PASSWORD'.*$/define('R_DB_PASSWORD', '${POSTGRES_PASSWORD}');/g" \
      -e "s/^.*'R_DB_NAME'.*$/define('R_DB_NAME', '${POSTGRES_DB}');/g" \
      ${ROOT_DIR}/server/php/config.inc.php

  # Relay SMTP server should be configured in another service
  echo "sendmail_path = /usr/sbin/sendmail -S $SMTP_SERVER:$SMTP_PORT -t -i" >> /etc/php7/php.ini

  # Configure Timezone
  echo $TZ > /etc/timezone
  cp /usr/share/zoneinfo/$TZ /etc/localtime
  sed -i "s|;date.timezone = |date.timezone = ${TZ}|" /etc/php7/php.ini

  # Log errors from php-fpm
  cat >> /etc/php7/php-fpm.d/www.conf <<EOF
; CUSTOM FROM HERE
php_flag[display_errors] = off
php_admin_value[error_log] = /var/log/php7/$pool.error.log
php_admin_flag[log_errors] = on
EOF

  # init db
  export PGHOST=${POSTGRES_HOST}
  export PGPORT=${POSTGRES_PORT}
  export PGUSER=${POSTGRES_USER}
  export PGPASSWORD=${POSTGRES_PASSWORD}
  export PGDATABASE=${POSTGRES_DB}
  
  set +e
  while :
  do
    psql -c "\q"
    if [ "$?" = 0 ]; then
      break
    fi
    sleep 1
  done
  if [ "$(psql -c '\d')" = "" ]; then
    psql -f "${ROOT_DIR}/sql/restyaboard_with_empty_data.sql"
  fi
  set -e

  # cron shell
  echo "*/5 * * * * ${ROOT_DIR}/server/php/shell/main.sh" >> /var/spool/cron/crontabs/root

  mkdir -p /run/nginx

  mkdir -p /var/lib/nginx/html/tmp/cache
  chown -R nginx:nginx /var/lib/nginx/html/tmp/cache

  mkdir -p /var/lib/nginx/html/media
  chown -R nginx:nginx /var/lib/nginx/html/media

  # service start
  php-fpm7
  crond -b -L /var/log/cron.log
  nginx

  # tail log
  exec tail -F /var/log/nginx/*.log /var/log/cron.log /var/log/php7/error.log
fi

exec "$@"
