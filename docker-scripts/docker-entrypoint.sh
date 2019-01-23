#!/bin/bash
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
  echo $TZ > /etc/timezone
  rm /etc/localtime
  cp /usr/share/zoneinfo/$TZ /etc/localtime
  sed -i "s|;date.timezone = |date.timezone = ${TZ}|" /etc/php/7.2/fpm/php.ini

  # postfix
  echo "[${SMTP_SERVER}]:${SMTP_PORT} ${SMTP_USERNAME}:${SMTP_PASSWORD}" > /etc/postfix/sasl_passwd
  postmap /etc/postfix/sasl_passwd
  echo "www-data@${SMTP_DOMAIN} ${SMTP_USERNAME}" > /etc/postfix/sender_canonical
  postmap /etc/postfix/sender_canonical
  sed -i \
      -e '/mydomain.*/d' \
      -e '/myhostname.*/d' \
      -e '/myorigin.*/d' \
      -e '/mydestination.*/d' \
      -e "$ a mydomain = ${SMTP_DOMAIN}" \
      -e "$ a myhostname = localhost" \
      -e '$ a myorigin = $mydomain' \
      -e '$ a mydestination = localhost, $myhostname, localhost.$mydomain' \
      -e '$ a sender_canonical_maps = hash:/etc/postfix/sender_canonical' \
      -e "s/#relayhost =.*$/relayhost = [${SMTP_SERVER}]:${SMTP_PORT}/" \
      -e '/smtp_.*/d' \
      -e '$ a smtpd_tls_session_cache_database = btree:${data_directory}/smtpd_scache' \
      -e '$ a smtp_sasl_auth_enable = yes' \
      -e '$ a smtp_sasl_security_options = noanonymous' \
      -e '$ a smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd' \
      -e '$ a smtp_use_tls = yes' \
      -e '$ a smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt' \
      -e '$ a smtp_tls_wrappermode = yes' \
      -e '$ a smtp_tls_security_level = encrypt' \
      /etc/postfix/main.cf

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
  if [ "$(psql -c '\d')" = "No relations found." ]; then
    psql -f "${ROOT_DIR}/sql/restyaboard_with_empty_data.sql"
  fi
  set -e

  # cron shell
  echo "*/5 * * * * ${ROOT_DIR}/server/php/shell/instant_email_notification.sh" >> /var/spool/cron/crontabs/root
  echo "0 * * * * ${ROOT_DIR}/server/php/shell/periodic_email_notification.sh" >> /var/spool/cron/crontabs/root
  echo "*/30 * * * * ${ROOT_DIR}/server/php/shell/imap.sh" >> /var/spool/cron/crontabs/root
  echo "*/5 * * * * ${ROOT_DIR}/server/php/shell/webhook.sh" >> /var/spool/cron/crontabs/root
  echo "*/5 * * * * ${ROOT_DIR}/server/php/shell/card_due_notification.sh" >> /var/spool/cron/crontabs/root

  # service start
  service cron start
  service php7.2-fpm start
  service nginx start
  service postfix start

  # tail log
  exec tail -f /var/log/nginx/access.log /var/log/nginx/error.log
fi

exec "$@"
