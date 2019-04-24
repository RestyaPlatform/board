#!/bin/bash
set -euo pipefail

# Update OS & install curl & unzip
apt-get update -y
apt-get install -y curl unzip

# Find latest Restyaboard version
RESTYABOARD_VERSION=$(curl --silent https://api.github.com/repos/RestyaPlatform/board/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

# Initialize directory variables
DOWNLOAD_DIR=/opt/restyaboard
RESTYABOARD_DIR=/usr/share/nginx/html/restyaboard

# Restyaboard DB details
POSTGRES_DBHOST=localhost
POSTGRES_DBNAME=restyaboard
POSTGRES_DBUSER=restya
POSTGRES_DBPASS=hjVl2!rGd
POSTGRES_DBPORT=5432

# PHP latest version package
sh -c 'echo "deb http://ftp.de.debian.org/debian jessie main" > /etc/apt/sources.list.d/debjessie.list'
apt install apt-transport-https lsb-release ca-certificates -y
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list
apt install debian-keyring debian-archive-keyring -y
apt update -y

# nginx installation
apt install -y cron nginx
service nginx start

# php installation
apt install -y php7.2 php7.2-opcache php7.2-common php7.2-fpm php7.2-cli php7.2-gd php7.2-curl libpq5 php7.2-pgsql php7.2-mbstring php7.2-ldap gcc imagemagick php7.2-imagick php7.2-imap php7.2-xml --allow-unauthenticated
timezone=$(cat /etc/timezone)
sed -i -e 's/date.timezone/;date.timezone/g' /etc/php/7.2/fpm/php.ini
service php7.2-fpm start

# postgresql installation
apt install -y postgresql
PSQL_VERSION=$(psql --version | egrep -o '[0-9]{1,}\.[0-9]{1,}' | head -1)
sed -e 's/peer/trust/g' -e 's/ident/trust/g' < /etc/postgresql/${PSQL_VERSION}/main/pg_hba.conf > /etc/postgresql/${PSQL_VERSION}/main/pg_hba.conf.1
cd /etc/postgresql/${PSQL_VERSION}/main || exit
mv pg_hba.conf pg_hba.conf_old
mv pg_hba.conf.1 pg_hba.conf
service postgresql restart

# php geoip installation
apt-get -y install gcc make autoconf libc-dev pkg-config php7.2-geoip php7.2-dev libgeoip-dev
cd /opt/
wget http://pecl.php.net/get/geoip-1.1.1.tgz
tar zxvf ./geoip-1.1.1.tgz
cd /opt/geoip-1.1.1/
phpize
ls -la
./configure
make
make install
echo "extension=geoip.so" >> /etc/php/7.2/fpm/php.ini
wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz
gunzip GeoIP.dat.gz
mv GeoIP.dat /usr/share/GeoIP/GeoIP.dat
wget http://geolite.maxmind.com/download/geoip/database/GeoIPv6.dat.gz
gunzip GeoIPv6.dat.gz
mv GeoIPv6.dat /usr/share/GeoIP/GeoIPv6.dat
wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz
gunzip GeoLiteCity.dat.gz
mv GeoLiteCity.dat /usr/share/GeoIP/GeoIPCity.dat
wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCityv6-beta/GeoLiteCityv6.dat.gz
gunzip GeoLiteCityv6.dat.gz
mv GeoLiteCityv6.dat /usr/share/GeoIP/GeoLiteCityv6.dat
wget http://download.maxmind.com/download/geoip/database/asnum/GeoIPASNum.dat.gz
gunzip GeoIPASNum.dat.gz
mv GeoIPASNum.dat /usr/share/GeoIP/GeoIPASNum.dat
wget http://download.maxmind.com/download/geoip/database/asnum/GeoIPASNumv6.dat.gz
gunzip GeoIPASNumv6.dat.gz
mv GeoIPASNumv6.dat /usr/share/GeoIP/GeoIPASNumv6.dat

# Restyaboard script installation
mkdir -p ${DOWNLOAD_DIR}
curl -v -L -G -d "app=board&ver=${RESTYABOARD_VERSION}" -o /tmp/restyaboard.zip http://restya.com/download.php
unzip /tmp/restyaboard.zip -d ${DOWNLOAD_DIR}
rm /tmp/restyaboard.zip
mkdir -p ${RESTYABOARD_DIR}
cp -r ${DOWNLOAD_DIR}/* ${RESTYABOARD_DIR}
find ${RESTYABOARD_DIR} -type d -print0 | xargs -0 chmod 0755
find ${RESTYABOARD_DIR} -type f -print0 | xargs -0 chmod 0644

# Restyaboard nginx configuration
cp ${DOWNLOAD_DIR}/restyaboard.conf /etc/nginx/conf.d
sed -i "s|root.*html|root ${RESTYABOARD_DIR}|" /etc/nginx/conf.d/restyaboard.conf
sed -i "s/server_name.*$/server_name _;/" /etc/nginx/conf.d/restyaboard.conf
sed -i "s|listen 80.*$|listen 80;|" /etc/nginx/conf.d/restyaboard.conf
rm -rf /etc/nginx/conf.d/default.conf /etc/nginx/sites-available/default.conf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default.conf /etc/nginx/sites-enabled/default

# Restyaboard DB creation
psql -U postgres -c "\q"
psql -U postgres -c "DROP USER IF EXISTS ${POSTGRES_DBUSER};CREATE USER ${POSTGRES_DBUSER} WITH ENCRYPTED PASSWORD '${POSTGRES_DBPASS}'"
psql -U postgres -c "CREATE DATABASE ${POSTGRES_DBNAME} OWNER ${POSTGRES_DBUSER} ENCODING 'UTF8' TEMPLATE template0"
psql -U postgres -c "CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;"
psql -U postgres -c "COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';"
psql -d ${POSTGRES_DBNAME} -f "${RESTYABOARD_DIR}/sql/restyaboard_with_empty_data.sql" -U ${POSTGRES_DBUSER}

# Restyaboard DB details update in config file
sed -i "s/^.*'R_DB_NAME'.*$/define('R_DB_NAME', '${POSTGRES_DBNAME}');/g" "${RESTYABOARD_DIR}/server/php/config.inc.php"
sed -i "s/^.*'R_DB_USER'.*$/define('R_DB_USER', '${POSTGRES_DBUSER}');/g" "${RESTYABOARD_DIR}/server/php/config.inc.php"
sed -i "s/^.*'R_DB_PASSWORD'.*$/define('R_DB_PASSWORD', '${POSTGRES_DBPASS}');/g" "${RESTYABOARD_DIR}/server/php/config.inc.php"
sed -i "s/^.*'R_DB_HOST'.*$/define('R_DB_HOST', '${POSTGRES_DBHOST}');/g" "${RESTYABOARD_DIR}/server/php/config.inc.php"
sed -i "s/^.*'R_DB_PORT'.*$/define('R_DB_PORT', '${POSTGRES_DBPORT}');/g" "${RESTYABOARD_DIR}/server/php/config.inc.php"

# Restyaboard cron setup
echo "*/5 * * * * ${RESTYABOARD_DIR}/server/php/shell/instant_email_notification.sh > /dev/null 2> /dev/null" >> /var/spool/cron/crontabs/root
echo "0 * * * * ${RESTYABOARD_DIR}/server/php/shell/periodic_email_notification.sh > /dev/null 2> /dev/null" >> /var/spool/cron/crontabs/root
echo "*/30 * * * * ${RESTYABOARD_DIR}/server/php/shell/imap.sh > /dev/null 2> /dev/null" >> /var/spool/cron/crontabs/root
echo "*/5 * * * * ${RESTYABOARD_DIR}/server/php/shell/webhook.sh > /dev/null 2> /dev/null" >> /var/spool/cron/crontabs/root
echo "*/5 * * * * ${RESTYABOARD_DIR}/server/php/shell/card_due_notification.sh > /dev/null 2> /dev/null" >> /var/spool/cron/crontabs/root

# Restarting services
service cron restart
service php7.2-fpm restart
service nginx restart

exit 0