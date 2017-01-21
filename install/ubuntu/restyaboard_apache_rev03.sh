#/bin/sh
#
# Install script for Restyaboard
#
# Usage: ./restyaboard.sh
#
# Copyright (c) 2014-2016 Restya.
# Dual License (OSL 3.0 & Commercial License)
{
	if [[ $EUID -ne 0 ]];
	then
		echo "This script must be run as root"
		exit 1
	fi
	#whoami
	#echo $(cat /etc/issue)
	OS_REQUIREMENT=$(cat /proc/version | grep 'Ubuntu\|Debian\|Raspbian' | sed 's/^.*Ubuntu.*$/Ubuntu/g' | sed 's/^.*Debian.*$/Debian/g' | sed 's/^.*Debian.*$/Debian/g' | sed 's/^.*Raspbian.*$/Raspbian/g')
	
	RUNNING_OS=$(lsb_release -i -s)
	RUNNING_VERSION=$(lsb_release -r -s)
	
	if ! ([ "$RUNNING_OS" = "Ubuntu" ] && [ "$RUNNING_VERSION" = "16.04" ])
		then
			echo "This script is designed to run under Ubuntu 16.04"
			exit 0
	fi
	
	RESTYABOARD_VERSION=$(curl --silent https://api.github.com/repos/RestyaPlatform/board/releases | grep tag_name -m 1 | awk '{print $2}' | sed -e 's/[^v0-9.]//g')
	#set -x
	POSTGRES_DBHOST=localhost
	POSTGRES_DBNAME=restyaboard
	POSTGRES_DBUSER=restya
	POSTGRES_DBPASS=hjVl2!rGd
	POSTGRES_DBPORT=5432
	EJABBERD_DBHOST=localhost
	EJABBERD_DBNAME=ejabberd
	EJABBERD_DBUSER=ejabb
	EJABBERD_DBPASS=ftfnVgYl2
	EJABBERD_DBPORT=5432
	
	echo "POSTGRES_DBHOST=${POSTGRES_DBHOST}"
	echo "POSTGRES_DBNAME=${POSTGRES_DBNAME}"
	echo "POSTGRES_DBUSER=${POSTGRES_DBUSER}"
	echo "POSTGRES_DBPASS=${POSTGRES_DBPASS}"
	echo "POSTGRES_DBPORT=${POSTGRES_DBPORT}"
	echo "EJABBERD_DBHOST=${EJABBERD_DBHOST}"
	echo "EJABBERD_DBNAME=${EJABBERD_DBNAME}"
	echo "EJABBERD_DBUSER=${EJABBERD_DBUSER}"
	echo "EJABBERD_DBPASS=${EJABBERD_DBPASS}"
	echo "EJABBERD_DBPORT=${EJABBERD_DBPORT}"
	#set +x
	
	if ([ "$OS_REQUIREMENT" = "Ubuntu" ] || [ "$OS_REQUIREMENT" = "Debian" ] || [ "$OS_REQUIREMENT" = "Raspbian" ])
	then
		echo "Setup script will install version ${RESTYABOARD_VERSION} and create database ${POSTGRES_DBNAME} with user ${POSTGRES_DBUSER} and password ${POSTGRES_DBPASS}. To continue enter \"y\" or to quit the process and edit the version and database details enter \"n\" (y/n)?"
		read -r answer
		#set -x
		case "${answer}" in
			[Yy])
			
			dir=/var/www/restyaboard
			mkdir -p "$dir"
			
			#set +x
			echo "To configure apache, enter your fully-qualified hostname (e.g., www.example.com, restyaboard.fritz.box, etc.,):"
			read -r webdir
			while [[ -z "$webdir" ]]
			do
				read -r -p "To configure apache, enter your fully-qualified hostname (e.g., www.example.com, restyaboard.fritz.box, etc.,):" webdir
			done
			#set -x
			echo "$webdir"

			#set +x
			echo "Do you want to install Restyaboard apps (y/n)?"
			read -r apps_answer
			#set -x
			
			echo "Do you want to setup SMTP configuration (y/n)?"
			read -r mail_answer
			case "${mail_answer}" in
				[Yy])
				echo "Enter SMTP server address (e.g., smtp.gmail.com)"
				read -r smtp_server
				echo "Enter SMTP port"
				read -r smtp_port
				echo "Enter SMTP username"
				read -r smtp_username
				echo "Enter SMTP password"
				read -r smtp_password
			esac
			
			# install prerequirements
	    apt-get install -y curl unzip php-geoip libgeoip-dev php php-common apache2 libapache2-mod-php php-cli php-curl php-pgsql php-mbstring php-ldap imagemagick php-imagick php-imap elasticsearch ejabberd erlang-p1-pgsql jq
			
			# Download Apache2 Site config file
			echo "Downloading Apache2 Site config file..."
			curl -v -L -G -o /etc/apache2/sites-available/restyaboard.conf https://raw.githubusercontent.com/BlackDuck888/board/master/install/ubuntu/restyaboard.conf
			
			echo "Downloading Restyaboard script..."
			curl -v -L -G -d "app=board&ver=${RESTYABOARD_VERSION}" -o /tmp/restyaboard.zip http://restya.com/download.php
			unzip /tmp/restyaboard.zip -d $dir
			rm /tmp/restyaboard.zip
			rm $dir/restyaboard.conf
			

			echo "Changing server_name in apache configuration..."
			sed -i "s/ServerName.*$/ServerName $webdir/" /etc/apache2/sites-available/restyaboard.conf
	
			# configure mail settings
			case "${mail_answer}" in
				[Yy])
				sed -i "s/#php_value SMTP localhost/php_value SMTP $smtp_server/" /etc/apache2/sites-available/restyaboard.conf
				sed -i "s/#php_value smtp_port 25/php_value smtp_port $smtp_port/" /etc/apache2/sites-available/restyaboard.conf
				sed -i "s/#php_value auth_username user/php_value auth_username $smtp_username/" /etc/apache2/sites-available/restyaboard.conf
				sed -i "s/#php_value auth_password pw/php_value auth_password $smtp_password/" /etc/apache2/sites-available/restyaboard.conf
			esac
			
			echo "Installing postfix..."
			echo "postfix postfix/mailname string $webdir"\
			| debconf-set-selections &&\
			echo "postfix postfix/main_mailer_type string 'Internet Site'"\
			| debconf-set-selections &&\
			apt-get install -y postfix
			        if [ $? != 0 ]
				then
					echo "-y postfix installation failed with error code 16"
					exit 1
				fi
			echo "Changing permission..."
			chmod -R go+w "$dir/media"
			chmod -R go+w "$dir/client/img"
			chmod -R go+w "$dir/tmp/cache"
			chmod -R 0755 $dir/server/php/shell/*.sh

			su - postgres -c "psql -c '\q'"
			if [ $? != 0 ]
			then
				echo "PostgreSQL Changing the permission failed with error code 34"
				exit 1ll
			fi
			sleep 1

			echo "Creating PostgreSQL user and database..."
			su - postgres -c "psql -U postgres -c "\""CREATE USER ${POSTGRES_DBUSER} WITH ENCRYPTED PASSWORD '${POSTGRES_DBPASS}'"\"" "
			if [ $? != 0 ]
			then
				echo "PostgreSQL user creation failed with error code 35 "
				exit 1
			fi
			su - postgres -c "psql -U postgres -c "\""CREATE DATABASE ${POSTGRES_DBNAME} OWNER ${POSTGRES_DBUSER} ENCODING 'UTF8' TEMPLATE template0"\"" "
			if [ $? != 0 ]
			then
				echo "PostgreSQL database creation failed with error code 36"
				exit 1
			fi
			su - postgres -c "psql -U postgres -c "\""CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;"\"" "
			if [ $? != 0 ]
			then
				echo "PostgreSQL extension creation failed with error code 37"
				exit 1
			fi
			su - postgres -c "psql -U postgres -c "\""COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';"\"" "
			if [ "$?" = 0 ];
			then
				echo "Importing empty SQL..."
				echo "${POSTGRES_DBHOST}:${POSTGRES_DBPORT}:${POSTGRES_DBNAME}:${POSTGRES_DBUSER}:${POSTGRES_DBPASS}" > ~postgres/.pgpass
				chmod 600 ~postgres/.pgpass
				chown postgres.postgres ~postgres/.pgpass
				su - postgres -c "psql -d ${POSTGRES_DBNAME} -f "\""$dir/sql/restyaboard_with_empty_data.sql"\"" -U ${POSTGRES_DBUSER} -h ${POSTGRES_DBHOST} "
				rm ~postgres/.pgpass
				if [ $? != 0 ]
				then
					echo "PostgreSQL Empty SQL importing failed with error code 39"
					exit 1
				fi
			fi
			
			echo "PostgreSQL - make fixes for Ubuntu 16.04"
			su - postgres -c "psql -U postgres -d ${POSTGRES_DBNAME} -c "\""delete from settings where name in ('TODO', 'DOING', 'DONE') and setting_category_id = 3;"\"" "
			su - postgres -c "psql -U postgres -d ${POSTGRES_DBNAME} -c "\""delete from settings where id in (select id from settings where name = 'DEFAULT_CARD_VIEW' and setting_category_id = 3 order by id desc limit 1); "\"" "
			su - postgres -c "psql -U postgres -d ${POSTGRES_DBNAME} -c "\""delete from settings where id in (select id from settings where name in ('XMPP_CLIENT_RESOURCE_NAME', 'JABBER_HOST', 'BOSH_SERVICE_URL') and setting_category_id = 11 order by id desc limit 3);"\"" "
			su - postgres -c "psql -U postgres -d ${POSTGRES_DBNAME} -c "\""delete from settings where id in (select id from settings where name = 'chat.last_processed_chat_id' and setting_category_id = 0 order by id desc limit 1); "\"" "
			su - postgres -c "psql -U postgres -d ${POSTGRES_DBNAME} -c "\""delete from setting_categories where id in (select id from setting_categories where name = 'Cards Workflow' order by id desc limit 1);"\"" "
			su - postgres -c "psql -U postgres -d ${POSTGRES_DBNAME} -c "\""INSERT INTO boards (created, modified, "user_id", "name", "board_visibility") VALUES (now(), now(), '1', 'Board', '0');"\"" "
 			su - postgres -c "psql -U postgres -d ${POSTGRES_DBNAME} -c "\""DELETE FROM users WHERE id = 2;"\"" "
 			su - postgres -c "psql -U postgres -d ${POSTGRES_DBNAME} -c "\""UPDATE settings SET value = 'http://localhost:9200' WHERE name = 'ELASTICSEARCH_URL';"\"" "
 			su - postgres -c "psql -U postgres -d ${POSTGRES_DBNAME} -c "\""UPDATE settings SET value = 'restya' WHERE name = 'ELASTICSEARCH_INDEX';"\"" "
 			su - postgres -c "psql -U postgres -d ${POSTGRES_DBNAME} -c "\""UPDATE settings SET value = 'false' WHERE name = 'ENABLE_SSL_CONNECTIVITY';"\"" "
 			
 			
 			#2016-07-31 14:38:30 CEST [4021-8] restya@restyaboard LOG:  execute <unnamed>: UPDATE settings SET value = $1 WHERE name = $2
			#2016-07-31 14:38:30 CEST [4021-9] restya@restyaboard DETAIL:  parameters: $1 = 'http://localhost:9200', $2 = 'ELASTICSEARCH_URL'
			#2016-07-31 14:38:30 CEST [4021-10] restya@restyaboard LOG:  execute <unnamed>: UPDATE settings SET value = $1 WHERE name = $2
			#2016-07-31 14:38:30 CEST [4021-11] restya@restyaboard DETAIL:  parameters: $1 = 'restya', $2 = 'ELASTICSEARCH_INDEX'
			#2016-07-31 14:38:30 CEST [4021-12] restya@restyaboard LOG:  execute <unnamed>: UPDATE settings SET value = $1 WHERE name = $2
			#2016-07-31 14:38:30 CEST [4021-13] restya@restyaboard DETAIL:  parameters: $1 = 'false', $2 = 'ENABLE_SSL_CONNECTIVITY'
			
			# set elasticsearch as deamon
			sed -i "s/#START_DAEMON=true/START_DAEMON=true/g" "/etc/default/elasticsearch"
 			
			echo "Changing PostgreSQL database name, user and password..."
			sed -i "s/^.*'R_DB_NAME'.*$/define('R_DB_NAME', '${POSTGRES_DBNAME}');/g" "$dir/server/php/config.inc.php"
			sed -i "s/^.*'R_DB_USER'.*$/define('R_DB_USER', '${POSTGRES_DBUSER}');/g" "$dir/server/php/config.inc.php"
			sed -i "s/^.*'R_DB_PASSWORD'.*$/define('R_DB_PASSWORD', '${POSTGRES_DBPASS}');/g" "$dir/server/php/config.inc.php"
			sed -i "s/^.*'R_DB_HOST'.*$/define('R_DB_HOST', '${POSTGRES_DBHOST}');/g" "$dir/server/php/config.inc.php"
			sed -i "s/^.*'R_DB_PORT'.*$/define('R_DB_PORT', '${POSTGRES_DBPORT}');/g" "$dir/server/php/config.inc.php"
			
			echo "Setting up cron for every 5 minutes to update ElasticSearch indexing..."
			echo "*/5 * * * * $dir/server/php/shell/indexing_to_elasticsearch.sh" >> /var/spool/cron/crontabs/root
			
			echo "Setting up cron for every 5 minutes to send email notification to user, if the user chosen notification type as instant..."
			echo "*/5 * * * * $dir/server/php/shell/instant_email_notification.sh" >> /var/spool/cron/crontabs/root
			
			echo "Setting up cron for every 1 hour to send email notification to user, if the user chosen notification type as periodic..."
			echo "0 * * * * $dir/server/php/shell/periodic_email_notification.sh" >> /var/spool/cron/crontabs/root
			
			echo "Setting up cron for every 30 minutes to fetch IMAP email..."
			echo "*/30 * * * * $dir/server/php/shell/imap.sh" >> /var/spool/cron/crontabs/root
			
			echo "Setting up cron for every 5 minutes to send activities to webhook..."
			echo "*/5 * * * * $dir/server/php/shell/webhook.sh" >> /var/spool/cron/crontabs/root
			
			echo "Setting up cron for every 5 minutes to send email notification to past due..."
			echo "*/5 * * * * $dir/server/php/shell/card_due_notification.sh" >> /var/spool/cron/crontabs/root
			
			echo "Setting up cron for every 5 minutes to send chat conversation as email notification to user..."
			echo "*/5 * * * * $dir/server/php/shell/chat_activities.sh" >> /var/spool/cron/crontabs/root
			
			echo "Setting up cron for every 1 hour to send chat conversation as email notification to user, if the user chosen notification type as periodic..."
			echo "0 * * * * $dir/server/php/shell/periodic_chat_email_notification.sh" >> /var/spool/cron/crontabs/root

			echo "Downloading GeoIP data"
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
				
			case "${apps_answer}" in
				[Yy])
				curl -v -L -G -o /tmp/apps.json https://raw.githubusercontent.com/RestyaPlatform/board-apps/master/apps.json
				chmod -R go+w "/tmp/apps.json"
				for fid in `jq -r '.[] | .id + "-v" + .version' /tmp/apps.json`
				do
					mkdir "$dir/client/apps"
					chmod -R go+w "$dir/client/apps"
					curl -v -L -G -o /tmp/$fid.zip https://github.com/RestyaPlatform/board-apps/releases/download/v1/$fid.zip
					unzip /tmp/$fid.zip -d "$dir/client/apps"
				done
			esac
			
			#apt-get install make
			#apt-get install autotools-dev
			#apt-get install automake
			#apt-get install erlang
			#apt-get install libyaml-dev			
			#apt-get install expat			
			#cd /opt
			#wget https://www.process-one.net/downloads/ejabberd/15.07/ejabberd-15.07.tgz
			#tar -zvxf ejabberd-15.07.tgz
			#cd ejabberd-15.07
			#wget https://www.process-one.net/downloads/ejabberd/16.06/ejabberd-16.06.tgz
			#tar -zvxf ejabberd-16.06.tgz
			#cd ejabberd-16.06
			#./autogen.sh
			#./configure --enable-pgsql
			#make
			#make install

			#cd /etc/ejabberd
			#echo "Creating ejabberd user and database..."
			#psql -U postgres -c "CREATE USER ${EJABBERD_DBUSER} WITH ENCRYPTED PASSWORD '${EJABBERD_DBPASS}'"

			#cd /etc/ejabberd
			#psql -U postgres -c "CREATE DATABASE ${EJABBERD_DBNAME}"

			#psql -d ${EJABBERD_DBNAME} -f "/opt/ejabberd-16.06/sql/pg.sql" -U postgres
			#mv /etc/ejabberd/ejabberd.yml /etc/ejabberd/ejabberd.yml.dist
			#mv $dir/ejabberd.yml /etc/ejabberd/ejabberd.yml
			#chmod -R go+w "/etc/ejabberd/ejabberd.yml"
			#sed -i 's/restya.com/'$webdir'/g' /etc/ejabberd/ejabberd.yml
			#sed -i 's/ejabberd15/'${EJABBERD_DBNAME}'/g' /etc/ejabberd/ejabberd.yml
			
			#ejabberdctl start
			#sleep 15
			#ejabberdctl change_password admin $webdir restya
			#ejabberdctl stop
			#sleep 15
			#ejabberdctl start
			
			#cd /opt
			#wget https://www.process-one.net/downloads/ejabberd/15.07/ejabberd-15.07.tgz
			#tar -zvxf ejabberd-15.07.tgz
			#cd ejabberd-15.07
			#wget https://www.process-one.net/downloads/ejabberd/16.06/ejabberd-16.06.tgz
			#tar -zvxf ejabberd-16.06.tgz
			#cd ejabberd-16.06
			#./autogen.sh
			#./configure --enable-pgsql
			#make
			#make install

			echo "Creating ejabberd user and database..."
			su - postgres -c "psql -U postgres -c "\""CREATE USER ${EJABBERD_DBUSER} WITH ENCRYPTED PASSWORD '${EJABBERD_DBPASS}'"\"" "
			su - postgres -c "psql -U postgres -c "\""CREATE DATABASE ${EJABBERD_DBNAME}"\"" "

			#/usr/share/doc/ejabberd/examples/pg.sql.gz
			gunzip -c /usr/share/doc/ejabberd/examples/pg.sql.gz > /tmp/pg.sql

			#psql -d ${EJABBERD_DBNAME} -f "/opt/ejabberd-16.06/sql/pg.sql" -U postgres
			#su - postgres -c "psql -d ${EJABBERD_DBNAME} -f "\""/opt/ejabberd-16.06/sql/pg.sql"\"" "
			su - postgres -c "psql -d ${EJABBERD_DBNAME} -f "\""/tmp/pg.sql"\"" "
			rm /tmp/pg.sql
			mv /etc/ejabberd/ejabberd.yml /etc/ejabberd/ejabberd.yml.dist
			curl -v -L -G -o /etc/ejabberd/ejabberd.yml https://raw.githubusercontent.com/RestyaPlatform/board/master/ejabberd.yml
			chmod 600 /etc/ejabberd/ejabberd.yml
			chown ejabberd.ejabberd /etc/ejabberd/ejabberd.yml
			#mv $dir/ejabberd.yml /etc/ejabberd/ejabberd.yml
			#chmod -R go+w "/etc/ejabberd/ejabberd.yml"
			sed -i 's/restya.com/'$webdir'/g' /etc/ejabberd/ejabberd.yml
			sed -i 's/ejabberd15/'${EJABBERD_DBNAME}'/g' /etc/ejabberd/ejabberd.yml
			sed -i 's/odbc_username: \"postgres\"/odbc_username: \"'${EJABBERD_DBUSER}'\"/g' /etc/ejabberd/ejabberd.yml
			sed -i 's/odbc_password: \"\"/odbc_password: \"'${EJABBERD_DBPASS}'\"/g' /etc/ejabberd/ejabberd.yml
			sed -i 's/loglevel: 5/loglevel: 4/g' /etc/ejabberd/ejabberd.yml
			
			ejabberdctl start
			sleep 15
			ejabberdctl change_password admin $webdir restya
			#ejabberdctl set-password admin $webdir restya
			ejabberdctl stop
			sleep 15
			ejabberdctl start
				
			a2enmod rewrite
			a2ensite restyaboard
			chown www-data.www-data /var/www/restyaboard -R
			service apache2 restart
			
			echo "Starting services..."
			service cron restart
			service postgresql restart
			service postfix restart
			service elasticsearch restart
			service apache2 restart
		esac
	fi
	#set +x
	echo "Login with username admin and password restya @ $webdir"
} 2>&1 | tee -a restyaboard_install.log


