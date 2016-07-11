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
	set -x
	whoami
	echo $(cat /etc/issue)
	OS_REQUIREMENT=$(cat /proc/version | grep 'Ubuntu\|Debian\|Raspbian' | sed 's/^.*Ubuntu.*$/Ubuntu/g' | sed 's/^.*Debian.*$/Debian/g' | sed 's/^.*Debian.*$/Debian/g' | sed 's/^.*Raspbian.*$/Raspbian/g')
	if ([ "$OS_REQUIREMENT" = "Ubuntu" ] || [ "$OS_REQUIREMENT" = "Debian" ] || [ "$OS_REQUIREMENT" = "Raspbian" ])
	then
		apt-get install -y curl unzip
	else
		yum install -y curl unzip
	fi
	RESTYABOARD_VERSION=$(curl --silent https://api.github.com/repos/RestyaPlatform/board/releases | grep tag_name -m 1 | awk '{print $2}' | sed -e 's/[^v0-9.]//g')
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
	DOWNLOAD_DIR=/opt/restyaboard
	
	update_version()
	{
		set +x
		echo "A newer version ${RESTYABOARD_VERSION} of Restyaboard is available. Do you want to get it now y/n?"
		read -r answer
		set -x
		case "${answer}" in
			[Yy])
			set +x
			echo "Enter your document root (where your Restyaboard to be installed. e.g., /usr/share/nginx/html/restyaboard):"
			read -r dir
			while [[ -z "$dir" ]]
			do
				read -r -p "Enter your document root (where your Restyaboard to be installed. e.g., /usr/share/nginx/html/restyaboard):" dir
			done
			set -x
			
			echo "Downloading files..."
			curl -v -L -G -d "app=board&ver=${RESTYABOARD_VERSION}" -o /tmp/restyaboard.zip http://restya.com/download.php
			unzip /tmp/restyaboard.zip -d ${DOWNLOAD_DIR}
			
			echo "Updating files..."
			cp -r ${DOWNLOAD_DIR}/. "$dir"
			
			echo "Connecting database to run SQL changes..."
			psql -U postgres -c "\q"
			if [ $? != 0 ]
			then
				echo "PostgreSQL database connection failed with error code 32"
				exit 1
			fi
			sleep 1
			
			echo "Changing PostgreSQL database name, user and password..."
			sed -i "s/^.*'R_DB_NAME'.*$/define('R_DB_NAME', '${POSTGRES_DBNAME}');/g" "$dir/server/php/config.inc.php"
			sed -i "s/^.*'R_DB_USER'.*$/define('R_DB_USER', '${POSTGRES_DBUSER}');/g" "$dir/server/php/config.inc.php"
			sed -i "s/^.*'R_DB_PASSWORD'.*$/define('R_DB_PASSWORD', '${POSTGRES_DBPASS}');/g" "$dir/server/php/config.inc.php"
			sed -i "s/^.*'R_DB_HOST'.*$/define('R_DB_HOST', '${POSTGRES_DBHOST}');/g" "$dir/server/php/config.inc.php"
			sed -i "s/^.*'R_DB_PORT'.*$/define('R_DB_PORT', '${POSTGRES_DBPORT}');/g" "$dir/server/php/config.inc.php"
			
			echo "Changing ejabberd database name, user and password..."
			sed -i "s/^.*'CHAT_DB_NAME'.*$/define('CHAT_DB_NAME', '${EJABBERD_DBNAME}');/g" "$dir/server/php/config.inc.php"
			sed -i "s/^.*'CHAT_DB_USER'.*$/define('CHAT_DB_USER', '${EJABBERD_DBUSER}');/g" "$dir/server/php/config.inc.php"
			sed -i "s/^.*'CHAT_DB_PASSWORD'.*$/define('CHAT_DB_PASSWORD', '${EJABBERD_DBPASS}');/g" "$dir/server/php/config.inc.php"
			sed -i "s/^.*'CHAT_DB_HOST'.*$/define('CHAT_DB_HOST', '${EJABBERD_DBHOST}');/g" "$dir/server/php/config.inc.php"
			sed -i "s/^.*'CHAT_DB_PORT'.*$/define('CHAT_DB_PORT', '${EJABBERD_DBPORT}');/g" "$dir/server/php/config.inc.php"
			
			if ([ "$OS_REQUIREMENT" = "Ubuntu" ] || [ "$OS_REQUIREMENT" = "Debian" ] || [ "$OS_REQUIREMENT" = "Raspbian" ])
			then
				echo "Setting up cron for every 5 minutes to send chat conversation as email notification to user..."
				echo "*/5 * * * * $dir/server/php/shell/chat_activities.sh" >> /var/spool/cron/crontabs/root
				
				echo "Setting up cron for every 1 hour to send chat conversation as email notification to user, if the user chosen notification type as periodic..."
				echo "0 * * * * $dir/server/php/shell/periodic_chat_email_notification.sh" >> /var/spool/cron/crontabs/root
				
				if ! hash GeoIP-devel 2>&-;
				then
					apt-get install php5-geoip php5-dev libgeoip-dev
					if [ $? != 0 ]
					then
						echo "php5-geoip php5-dev libgeoip-dev installation failed with error code 50"
						exit 1
					fi
				fi
				if ! hash pecl/geoip 2>&-;
				then
					pecl install geoip
					if [ $? != 0 ]
					then
						echo "pecl geoip installation failed with error code 47"
						exit 1
					fi
				fi
				echo "extension=geoip.so" >> /etc/php.ini
				mkdir -v /usr/share/GeoIP
				if [ $? != 0 ]
				then
					echo "GeoIP folder creation failed with error code 52"
					exit 1
				fi
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

				service php5-fpm restart
				
				set +x
				echo "Do you want to install Restyaboard apps (y/n)?"
				read -r answer
				set -x
				case "${answer}" in
					[Yy])
					if ! hash jq 2>&-;
					then
						echo "Installing jq..."
						apt-get install jq
						if [ $? != 0 ]
						then
							echo "jq installation failed with error code 53"
							exit 1
						fi
					fi
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
				
				apt-get install autotools-dev

				apt-get install automake

				apt-get install erlang

				apt-get install libyaml-dev

				cd /opt
				wget http://liquidtelecom.dl.sourceforge.net/project/expat/expat/2.1.1/expat-2.1.1.tar.bz2
				tar -jvxf expat-2.1.1.tar.bz2
				cd expat-2.1.1/
				./configure
				make
				make install

				cd /opt
				wget https://www.process-one.net/downloads/ejabberd/15.07/ejabberd-15.07.tgz
				tar -zvxf ejabberd-15.07.tgz
				cd ejabberd-15.07
				./autogen.sh
				./configure --enable-pgsql
				make
				make install

				set +x
				echo "To configure ejabberd, enter your domain name (e.g., www.example.com, 192.xxx.xxx.xxx, etc.,):"
				read -r webdir
				while [[ -z "$webdir" ]]
				do
					read -r -p "To configure ejabberd, enter your domain name (e.g., www.example.com, 192.xxx.xxx.xxx, etc.,):" webdir
				done
				
				cd /etc/ejabberd
				echo "Creating ejabberd user and database..."
				psql -U postgres -c "CREATE USER ${EJABBERD_DBUSER} WITH ENCRYPTED PASSWORD '${EJABBERD_DBPASS}'"

				cd /etc/ejabberd
				psql -U postgres -c "CREATE DATABASE ${EJABBERD_DBNAME}"

				psql -d ${EJABBERD_DBNAME} -f "/opt/ejabberd-15.07/sql/pg.sql" -U postgres
				mv $dir/ejabberd.yml /etc/ejabberd/ejabberd.yml
				chmod -R go+w "/etc/ejabberd/ejabberd.yml"
				sed -i 's/restya.com/'$webdir'/g' /etc/ejabberd/ejabberd.yml
				sed -i 's/ejabberd15/'${EJABBERD_DBNAME}'/g' /etc/ejabberd/ejabberd.yml
				
				ejabberdctl start
				sleep 15
				ejabberdctl change_password admin $webdir restya
				ejabberdctl stop
				sleep 15
				ejabberdctl start
				
			else
				
				echo "Setting up cron for every 5 minutes to send chat conversation as email notification to user..."
				echo "*/5 * * * * $dir/server/php/shell/chat_activities.sh" >> /var/spool/cron/crontabs/root
				
				echo "Setting up cron for every 1 hour to send chat conversation as email notification to user, if the user chosen notification type as periodic..."
				echo "0 * * * * $dir/server/php/shell/periodic_chat_email_notification.sh" >> /var/spool/cron/crontabs/root
				
				if ! hash GeoIP-devel 2>&-;
				then
					yum install GeoIP-devel
					if [ $? != 0 ]
					then
						echo "GeoIP-devel installation failed with error code 46"
						exit 1
					fi
				fi

				if ! hash pecl/geoip 2>&-;
				then
					pecl install geoip
					if [ $? != 0 ]
					then
						echo "pecl geoip installation failed with error code 47"
						exit 1
					fi
				fi
				echo "extension=geoip.so" >> /etc/php.ini
				mkdir -v /usr/share/GeoIP
				if [ $? != 0 ]
				then
					echo "GeoIP folder creation failed with error code 48"
					exit 1
				fi
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

				ps -q 1 | grep -q -c "systemd"
				if [ "$?" -eq 0 ];
				then
					systemctl restart php-fpm
				else
					/etc/init.d/php-fpm restart
				fi
				
				set +x
				echo "Do you want to install Restyaboard apps (y/n)?"
				read -r answer
				set -x
				case "${answer}" in
					[Yy])
					if ! hash jq 2>&-;
					then
						echo "Installing jq..."
						yum install -y jq
						if [ $? != 0 ]
						then
							echo "jq installation failed with error code 49"
							exit 1
						fi
					fi
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

				cd /opt
				wget https://www.process-one.net/downloads/ejabberd/15.07/ejabberd-15.07.tgz
				wget https://packages.erlang-solutions.com/erlang/esl-erlang/FLAVOUR_1_general/esl-erlang_18.3-1~centos~6_i386.rpm
				rpm -ivh esl-erlang_18.3-1~centos~6_i386.rpm
				yum install libyaml*
				tar -zvxf ejabberd-15.07.tgz
				cd ejabberd-15.07
				./autogen.sh
				./configure --enable-pgsql
				make
				make install
				yum install php-xml
				set +x
				echo "To configure ejabberd, enter your domain name (e.g., www.example.com, 192.xxx.xxx.xxx, etc.,):"
				read -r webdir
				while [[ -z "$webdir" ]]
				do
					read -r -p "To configure ejabberd, enter your domain name (e.g., www.example.com, 192.xxx.xxx.xxx, etc.,):" webdir
				done

				echo "Creating ejabberd user and database..."
				psql -U postgres -c "CREATE USER ${EJABBERD_DBUSER} WITH ENCRYPTED PASSWORD '${EJABBERD_DBPASS}'"

				cd /etc/ejabberd
				psql -U postgres -c "CREATE DATABASE ${EJABBERD_DBNAME}"
				
				psql -d ${EJABBERD_DBNAME} -f "/opt/ejabberd-15.07/sql/pg.sql" -U postgres
				mv $dir/ejabberd.yml /etc/ejabberd/ejabberd.yml
				chmod -R go+w "/etc/ejabberd/ejabberd.yml"
				sed -i 's/restya.com/'$webdir'/g' /etc/ejabberd/ejabberd.yml
				sed -i 's/ejabberd15/'${EJABBERD_DBNAME}'/g' /etc/ejabberd/ejabberd.yml

				ejabberdctl start
				sleep 15
				ejabberdctl change_password admin $webdir restya
				ejabberdctl stop
				sleep 15
				ejabberdctl start

				ps -q 1 | grep -q -c "systemd"
				if [ "$?" -eq 0 ];
				then
					echo "Starting services with systemd..."
					systemctl start nginx
					systemctl start php-fpm
				else
					echo "Starting services..."
					/etc/init.d/php-fpm restart
					/etc/init.d/nginx restart
				fi

			fi
			
			set +x
			echo "Folder structure modified. Script going to delete unwanted files inside R folder except r.php and README.md. Do you want to do it now y/n?"
			read -r answer
			set -x
			case "${answer}" in
				[Yy])
				rm -rf $dir/server/php/R/shell $dir/server/php/R/libs $dir/server/php/R/image.php $dir/server/php/R/config.inc.php $dir/server/php/R/authorize.php $dir/server/php/R/oauth_callback.php $dir/server/php/R/download.php $dir/server/php/R/ical.php
			esac
			
			echo "Updating SQL..."
			psql -d ${POSTGRES_DBNAME} -f "$dir/sql/${RESTYABOARD_VERSION}.sql" -U ${POSTGRES_DBUSER}
			/bin/echo "$RESTYABOARD_VERSION" > /opt/restyaboard/release
			if [ $? != 0 ]
			then
				echo "PostgreSQL updation of SQL failed with error code 33"
				exit 1
			fi
			
			php $dir/server/php/shell/upgrade_v0.2.1_v0.3.php
		esac
	}
	
	if [ -d "$DOWNLOAD_DIR" ];
	then
		version=$(cat /opt/restyaboard/release)
		if [[ $version < $RESTYABOARD_VERSION ]];
		then
			update_version
			exit
		else
			echo "No new version available"
			exit;
		fi
	else
		set +x
		echo "Is Restyaboard already installed y/n?"
		read -r answer
		set -x
		case "${answer}" in
			[Yy])
			update_version
			exit
		esac
	fi
	if ([ "$OS_REQUIREMENT" = "Ubuntu" ] || [ "$OS_REQUIREMENT" = "Debian" ] || [ "$OS_REQUIREMENT" = "Raspbian" ])
	then
		set +x
		echo "Setup script will install version ${RESTYABOARD_VERSION} and create database ${POSTGRES_DBNAME} with user ${POSTGRES_DBUSER} and password ${POSTGRES_DBPASS}. To continue enter \"y\" or to quit the process and edit the version and database details enter \"n\" (y/n)?"
		read -r answer
		set -x
		case "${answer}" in
			[Yy])
			echo "deb http://mirrors.linode.com/debian/ wheezy main contrib non-free" >> /etc/apt/sources.list
			echo "deb-src http://mirrors.linode.com/debian/ wheezy main contrib non-free" >> /etc/apt/sources.list
			echo "deb http://mirrors.linode.com/debian-security/ wheezy/updates main contrib non-free" >> /etc/apt/sources.list
			echo "deb-src http://mirrors.linode.com/debian-security/ wheezy/updates main contrib non-free" >> /etc/apt/sources.list
			echo "deb http://mirrors.linode.com/debian/ wheezy-updates main" >> /etc/apt/sources.list
			echo "deb-src http://mirrors.linode.com/debian/ wheezy-updates main" >> /etc/apt/sources.list
			sed -i -e 's/deb cdrom/#deb cdrom/g' /etc/apt/sources.list
			
			apt-key update
			apt-get update
			apt-get install debian-keyring debian-archive-keyring
			if [ $? != 0 ]
			then
				echo "debian-keyring installation failed with error code 1"
				exit 1
			fi
			
			apt-get update -y
			apt-get upgrade -y
			
			echo "Checking nginx..."
			if ! which nginx > /dev/null 2>&1; then
				echo "nginx not installed!"
				set +x
				echo "Do you want to install nginx (y/n)?"
				read -r answer
				set -x
				case "${answer}" in
					[Yy])
					echo "Installing nginx..."
					apt-get install -y cron nginx
					if [ $? != 0 ]
					then
						echo "nginx installation failed with error code 2"
						exit 1
					fi
					service nginx start
				esac
			fi
			
			echo "Checking PHP..."
			if ! hash php 2>&-; then
				echo "PHP is not installed!"
				set +x
				echo "Do you want to install PHP (y/n)?"
				read -r answer
				set -x
				case "${answer}" in
					[Yy])
					echo "Installing PHP..."
					apt-get install -y php5 php5-common
					if [ $? != 0 ]
					then
						echo "php5-common installation failed with error code 3"
						exit 1
					fi
				esac
			fi
			
			echo "Installing PHP fpm and cli extension..."
			apt-get install -y php5-fpm php5-cli
			if [ $? != 0 ]
			then
				echo "php5-cli installation failed with error code 4"
				exit 1
			fi
			service php5-fpm start
			
			echo "Checking PHP curl extension..."
			php -m | grep curl
			if [ "$?" -gt 0 ]; then
				echo "Installing php5-curl..."
				apt-get install -y php5-curl
				if [ $? != 0 ]
				then
					echo "php5-curl installation failed with error code 5"
					exit 1
				fi
			fi
			
			echo "Checking PHP pgsql extension..."
			php -m | grep pgsql
			if [ "$?" -gt 0 ]; then
				echo "Installing php5-pgsql..."
				apt-get install -y php5-pgsql
				if [ $? != 0 ]
				then
					echo "php5-pgsql installation failed with error code 6"
					exit 1
				fi
			fi
			
			echo "Checking PHP mbstring extension..."
			php -m | grep mbstring
			if [ "$?" -gt 0 ]; then
				echo "Installing php5-mbstring..."
				apt-get install -y php5-mbstring
				if [ $? != 0 ]
				then
					echo "php5-mbstring installation failed with error code 7"
					exit 1
				fi
			fi
			
			echo "Checking PHP ldap extension..."
			php -m | grep ldap
			if [ "$?" -gt 0 ]; then
				echo "Installing php5-ldap..."
				apt-get install -y php5-ldap
				if [ $? != 0 ]
				then
					echo "php5-ldap installation failed with error code 8"
					exit 1
				fi
			fi
			
			echo "Checking PHP imagick extension..."
			php -m | grep imagick
			if [ "$?" -gt 0 ]; then
				echo "Installing php5-imagick..."
				apt-get install gcc
				if [ $? != 0 ]
				then
					echo "gcc installation failed with error code 9"
					exit 1
				fi
				apt-get install imagemagick
				if [ $? != 0 ]
				then
					echo "imagemagick installation failed with error code 9"
					exit 1
				fi
				apt-get install php5-imagick
				if [ $? != 0 ]
				then
					echo "php5-imagick installation failed with error code 10"
					exit 1
				fi
			fi
			
			echo "Checking PHP imap extension..."
			php -m | grep imap
			if [ "$?" -gt 0 ]; then
				echo "Installing php5-imap..."
				apt-get install -y php5-imap
				if [ $? != 0 ]
				then
					echo "php5-imap installation failed with error code 11"
					exit 1
				fi
			fi
			
			echo "Setting up timezone..."
			timezone=$(cat /etc/timezone)
			sed -i -e 's/date.timezone/;date.timezone/g' /etc/php5/fpm/php.ini
			echo "date.timezone = $timezone" >> /etc/php5/fpm/php.ini
			
			echo "Checking PostgreSQL..."
			id -a postgres
			if [ $? != 0 ]; then
				echo "PostgreSQL not installed!"
				set +x
				echo "Do you want to install PostgreSQL (y/n)?"
				read -r answer
				set -x
				case "${answer}" in
					[Yy])
					echo "Installing PostgreSQL..."
					sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
					apt-get install wget ca-certificates
					if [ $? != 0 ]
					then
						echo "ca-certificates installation failed with error code 12"
						exit 1
					fi
					wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc
					apt-key add ACCC4CF8.asc
					apt-get update
					apt-get install postgresql-9.4
					if [ $? != 0 ]
					then
						echo "postgresql-9.4 installation failed with error code 13"
						exit 1
					fi
					sed -e 's/peer/trust/g' -e 's/ident/trust/g' < /etc/postgresql/9.4/main/pg_hba.conf > /etc/postgresql/9.4/main/pg_hba.conf.1
					cd /etc/postgresql/9.4/main || exit
					mv pg_hba.conf pg_hba.conf_old
					mv pg_hba.conf.1 pg_hba.conf
					service postgresql restart
				esac
			fi
			
			echo "Checking ElasticSearch..."
			if ! curl http://localhost:9200 > /dev/null 2>&1; then
				echo "ElasticSearch not installed!"
				set +x
				echo "Do you want to install ElasticSearch (y/n)?"
				read -r answer
				set -x
				case "${answer}" in
					[Yy])
					echo "Installing ElasticSearch..."
					apt-get install openjdk-6-jre
					if [ $? != 0 ]
					then
						echo "openjdk-6-jre installation failed with error code 14"
						exit 1
					fi
					wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.90.7.deb
					if [ $? != 0 ]
					then
						echo "elasticsearch downloading failed with error code 15"
						exit 1
					fi
					dpkg -i elasticsearch-0.90.7.deb
					service elasticsearch restart
				esac
			fi

			echo "Downloading Restyaboard script..."
			mkdir /opt/restyaboard
			curl -v -L -G -d "app=board&ver=${RESTYABOARD_VERSION}" -o /tmp/restyaboard.zip http://restya.com/download.php
			unzip /tmp/restyaboard.zip -d /opt/restyaboard
			cp /opt/restyaboard/restyaboard.conf /etc/nginx/conf.d
			rm /tmp/restyaboard.zip
			
			set +x
			echo "To configure nginx, enter your domain name (e.g., www.example.com, 192.xxx.xxx.xxx, etc.,):"
			read -r webdir
			while [[ -z "$webdir" ]]
			do
				read -r -p "To configure nginx, enter your domain name (e.g., www.example.com, 192.xxx.xxx.xxx, etc.,):" webdir
			done
			set -x
			echo "$webdir"
			echo "Changing server_name in nginx configuration..."
			sed -i "s/server_name.*$/server_name \"$webdir\";/" /etc/nginx/conf.d/restyaboard.conf
			sed -i "s|listen 80.*$|listen 80;|" /etc/nginx/conf.d/restyaboard.conf
			
			set +x
			echo "Enter your document root (where your Restyaboard to be installed. e.g., /usr/share/nginx/html/restyaboard):"
			read -r dir
			while [[ -z "$dir" ]]
			do
				read -r -p "Enter your document root (where your Restyaboard to be installed. e.g., /usr/share/nginx/html/restyaboard):" dir
			done
			set -x
			echo "$dir"
			mkdir -p "$dir"
			echo "Changing root directory in nginx configuration..."
			sed -i "s|root.*html|root $dir|" /etc/nginx/conf.d/restyaboard.conf
			echo "Copying Restyaboard script to root directory..."
			cp -r /opt/restyaboard/* "$dir"
			
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

			psql -U postgres -c "\q"
			if [ $? != 0 ]
			then
				echo "PostgreSQL Changing the permission failed with error code 34"
				exit 1
			fi
			sleep 1

			echo "Creating PostgreSQL user and database..."
			psql -U postgres -c "CREATE USER ${POSTGRES_DBUSER} WITH ENCRYPTED PASSWORD '${POSTGRES_DBPASS}'"
			if [ $? != 0 ]
			then
				echo "PostgreSQL user creation failed with error code 35 "
				exit 1
			fi
			psql -U postgres -c "CREATE DATABASE ${POSTGRES_DBNAME} OWNER ${POSTGRES_DBUSER} ENCODING 'UTF8' TEMPLATE template0"
			if [ $? != 0 ]
			then
				echo "PostgreSQL database creation failed with error code 36"
				exit 1
			fi
			psql -U postgres -c "CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;"
			if [ $? != 0 ]
			then
				echo "PostgreSQL extension creation failed with error code 37"
				exit 1
			fi
			psql -U postgres -c "COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';"
			if [ "$?" = 0 ];
			then
				echo "Importing empty SQL..."
				psql -d ${POSTGRES_DBNAME} -f "$dir/sql/restyaboard_with_empty_data.sql" -U ${POSTGRES_DBUSER}
				if [ $? != 0 ]
				then
					echo "PostgreSQL Empty SQL importing failed with error code 39"
					exit 1
				fi
			fi
			
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

			echo "Do you want to setup SMTP configuration (y/n)?"
			read -r answer
			case "${answer}" in
				[Yy])
				echo "Enter SMTP server address (e.g., smtp.gmail.com)"
				read -r smtp_server
				echo "Enter SMTP port"
				read -r smtp_port
				echo "Enter SMTP username"
				read -r smtp_username
				echo "Enter SMTP password"
				read -r smtp_password
				sed -i "1021 i auth_username = $smtp_username" /etc/php.ini
				sed -i "1022 i auth_password = $smtp_password" /etc/php.ini
				sed -i "s/SMTP = localhost/SMTP = $smtp_server/" /etc/php.ini
				sed -i "s/smtp_port = 25/smtp_port = $smtp_port/" /etc/php.ini
			esac
			
			if ! hash GeoIP-devel 2>&-;
			then
				apt-get install php5-geoip php5-dev libgeoip-dev
				if [ $? != 0 ]
				then
					echo "php5-geoip php5-dev libgeoip-dev installation failed with error code 50"
					exit 1
				fi
			fi
			if ! hash pecl/geoip 2>&-;
			then
				pecl install geoip
				if [ $? != 0 ]
				then
					echo "pecl geoip installation failed with error code 47"
					exit 1
				fi
			fi
			echo "extension=geoip.so" >> /etc/php.ini
			mkdir -v /usr/share/GeoIP
			if [ $? != 0 ]
			then
				echo "GeoIP folder creation failed with error code 52"
				exit 1
			fi
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
			
			service php5-fpm restart
			
			set +x
			echo "Do you want to install Restyaboard apps (y/n)?"
			read -r answer
			set -x
			case "${answer}" in
				[Yy])
				if ! hash jq 2>&-;
				then
					echo "Installing jq..."
					apt-get install jq
					if [ $? != 0 ]
					then
						echo "jq installation failed with error code 53"
						exit 1
					fi
				fi
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
			
			apt-get install autotools-dev

			apt-get install automake

			apt-get install erlang

			apt-get install libyaml-dev

			cd /opt
			wget http://liquidtelecom.dl.sourceforge.net/project/expat/expat/2.1.1/expat-2.1.1.tar.bz2
			tar -jvxf expat-2.1.1.tar.bz2
			cd expat-2.1.1/
			./configure
			make
			make install

			cd /opt
			wget https://www.process-one.net/downloads/ejabberd/15.07/ejabberd-15.07.tgz
			tar -zvxf ejabberd-15.07.tgz
			cd ejabberd-15.07
			./autogen.sh
			./configure --enable-pgsql
			make
			make install

			cd /etc/ejabberd
			echo "Creating ejabberd user and database..."
			psql -U postgres -c "CREATE USER ${EJABBERD_DBUSER} WITH ENCRYPTED PASSWORD '${EJABBERD_DBPASS}'"

			cd /etc/ejabberd
			psql -U postgres -c "CREATE DATABASE ${EJABBERD_DBNAME}"

			psql -d ${EJABBERD_DBNAME} -f "/opt/ejabberd-15.07/sql/pg.sql" -U postgres
			mv $dir/ejabberd.yml /etc/ejabberd/ejabberd.yml
			chmod -R go+w "/etc/ejabberd/ejabberd.yml"
			sed -i 's/restya.com/'$webdir'/g' /etc/ejabberd/ejabberd.yml
			sed -i 's/ejabberd15/'${EJABBERD_DBNAME}'/g' /etc/ejabberd/ejabberd.yml
			
			ejabberdctl start
			sleep 15
			ejabberdctl change_password admin $webdir restya
			ejabberdctl stop
			sleep 15
			ejabberdctl start
			
			echo "Starting services..."
			service cron restart
			service php5-fpm restart
			service nginx restart
			service postfix restart
			service elasticsearch restart
		esac
	else
		set +x
		echo "Setup script will install version ${RESTYABOARD_VERSION} and create database ${POSTGRES_DBNAME} with user ${POSTGRES_DBUSER} and password ${POSTGRES_DBPASS}. To continue enter \"y\" or to quit the process and edit the version and database details enter \"n\" (y/n)?"
		read -r answer
		set -x
		case "${answer}" in
			[Yy])

			echo "Checking nginx..."
			if ! which nginx > /dev/null 2>&1;
			then
				echo "nginx not installed!"
				set +x
				echo "Do you want to install nginx (y/n)?"
				read -r answer
				set -x
				case "${answer}" in
					[Yy])
					echo "Installing nginx..."
					yum install -y epel-release
					if [ $? != 0 ]
					then
						echo "epel-release installation failed with error code 17"
						exit 1
					fi
					yum install -y zip cron nginx
					if [ $? != 0 ]
					then
						echo "cron nginx installation failed with error code 18"
						exit 1
					fi
					service nginx start
					chkconfig --levels 35 nginx on
				esac
			fi

			echo "Checking PHP..."
			if ! hash php 2>&-;
			then
				echo "PHP is not installed!"
				set +x
				echo "Do you want to install PHP (y/n)?" 
				read -r answer
				set -x
				case "${answer}" in
					[Yy])
					echo "Installing PHP..."
					yum install -y epel-release
					if [ $? != 0 ]
					then
						echo "epel-release installation failed with error code 19"
						exit 1
					fi
					yum install -y php
					if [ $? != 0 ]
					then
						echo "php installation failed with error code 20"
						exit 1
					fi
				esac
			fi
			
			echo "Installing PHP fpm and cli extension..."
			yum install -y php-fpm php-devel php-cli
			if [ $? != 0 ]
			then
				echo "php-devel installation failed with error code 21"
				exit 1
			fi
			service php-fpm start
			chkconfig --levels 35 php-fpm on

			echo "Checking PHP curl extension..."
			php -m | grep curl
			if [ "$?" -gt 0 ];
			then
				echo "Installing php-curl..."
				yum install -y php-curl
				if [ $? != 0 ]
				then
					echo "php-curl installation failed with error code 22"
					exit 1
				fi
			fi
			
			echo "Checking PHP pgsql extension..."
			php -m | grep pgsql
			if [ "$?" -gt 0 ];
			then
				echo "Installing php-pgsql..."
				yum install -y php-pgsql
				if [ $? != 0 ]
				then
					echo "php-pgsql installation failed with error code 23"
					exit 1
				fi
			fi

			echo "Checking PHP mbstring extension..."
			php -m | grep mbstring
			if [ "$?" -gt 0 ];
			then
				echo "Installing php-mbstring..."
				yum install -y php-mbstring
				if [ $? != 0 ]
				then
					echo "php-mbstring installation failed with error code 24"
					exit 1
				fi
			fi
			
			echo "Checking PHP ldap extension..."
			php -m | grep ldap
			if [ "$?" -gt 0 ];
			then
				echo "Installing php-ldap..."
				yum install -y php-ldap
				if [ $? != 0 ]
				then
					echo "php-ldap installation failed with error code 25"
					exit 1
				fi
			fi
			
			echo "Checking PHP imagick extension..."
			php -m | grep imagick
			if [ "$?" -gt 0 ];
			then
				echo "Installing php-imagick..."

				yum install -y ImageM* netpbm gd gd-* libjpeg libexif gcc coreutils make
				yum install php-pear
				if [ $? != 0 ]
				then
					echo "Installing php-imagick failed with error code 26"
					exit 1
				fi

				cd /usr/local/src
				wget http://pecl.php.net/get/imagick-2.2.2.tgz
				tar zxvf ./imagick-2.2.2.tgz
				cd imagick-2.2.2
				phpize
				./configure
				make
				make test
				make install
				echo "extension=imagick.so" >> /etc/php.ini
			fi
			
			echo "Checking PHP imap extension..."
			php -m | grep imap
			if [ "$?" -gt 0 ];
			then
				echo "Installing php-imap..."
				yum install -y php-imap
				if [ $? != 0 ]
				then
					echo "php-imap installation failed with error code 26"
					exit 1
				fi
				
			fi
			
			echo "Setting up timezone..."
			timezone=$(cat /etc/sysconfig/clock | grep ZONE | cut -d"\"" -f2)
			sed -i -e 's/date.timezone/;date.timezone/g' /etc/php.ini
			echo "date.timezone = $timezone" >> /etc/php.ini

			PHP_VERSION=$(php -v | grep "PHP 5" | sed 's/.*PHP \([^-]*\).*/\1/' | cut -c 1-3)
			echo "Installed PHP version: '$PHP_VERSION'"

			echo "Checking PostgreSQL..."
			id -a postgres
			if [ $? != 0 ];
			then
				echo "PostgreSQL not installed!"
				set +x
				echo "Do you want to install PostgreSQL (y/n)?"
				read -r answer
				set -x
				case "${answer}" in
					[Yy])
					echo "Installing PostgreSQL..."
					if [ $(getconf LONG_BIT) = "32" ]; then
						yum install -y http://yum.postgresql.org/9.4/redhat/rhel-6.6-i386/pgdg-centos94-9.4-1.noarch.rpm
						if [ $? != 0 ]
						then
							echo "Installing PostgreSQL 32 fail with error code 27"
							exit 1
						fi
					fi
					if [ $(getconf LONG_BIT) = "64" ]; then
						yum install -y http://yum.postgresql.org/9.4/redhat/rhel-6.6-x86_64/pgdg-centos94-9.4-1.noarch.rpm
						if [ $? != 0 ]
						then
							echo "Installing PostgreSQL 64 fail with error code 28"
							exit 1
						fi
					fi

					yum install -y postgresql94-server postgresql94-contrib
					if [ $? != 0 ]
					then
						echo "postgresql04-contrib installation failed with error code 29"
						exit 1
					fi
					
					ps -q 1 | grep -q -c "systemd"
					if [ "$?" -eq 0 ]; then
						if [ -f /usr/pgsql-9.4/bin/postgresql94-setup ]; then
							/usr/pgsql-9.4/bin/postgresql94-setup initdb
						fi
						systemctl start postgresql-9.4.service
						systemctl enable postgresql-9.4.service
					else
						service postgresql-9.4 initdb
						/etc/init.d/postgresql-9.4 start
						chkconfig --levels 35 postgresql-9.4 on
					fi

					sed -e 's/peer/trust/g' -e 's/ident/trust/g' < /var/lib/pgsql/9.4/data/pg_hba.conf > /var/lib/pgsql/9.4/data/pg_hba.conf.1
					cd /var/lib/pgsql/9.4/data || exit
					mv pg_hba.conf pg_hba.conf_old
					mv pg_hba.conf.1 pg_hba.conf
					
					ps -q 1 | grep -q -c "systemd"
					if [ "$?" -eq 0 ]; then
						systemctl restart postgresql-9.4.service
					else
						/etc/init.d/postgresql-9.4 restart
					fi
				esac
			fi

			echo "Checking ElasticSearch..."
			if ! curl http://localhost:9200 > /dev/null 2>&1;
			then
				echo "ElasticSearch not installed!"
				set +x
				echo "Do you want to install ElasticSearch (y/n)?"
				read -r answer
				set -x
				case "${answer}" in
					[Yy])
					echo "Installing ElasticSearch..."
					sudo yum install java-1.7.0-openjdk -y
					if [ $? != 0 ]
					then
						echo "java installation failed with error code 30"
						exit 1
					fi
					wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.90.10.noarch.rpm
					if [ $? != 0 ]
					then
						echo " ElasticSearch downloading failed with error code 31"
						exit 1
					fi
					nohup rpm -Uvh elasticsearch-0.90.10.noarch.rpm &
					chkconfig elasticsearch on
				esac
			fi

			echo "Downloading Restyaboard script..."
			mkdir ${DOWNLOAD_DIR}
			curl -v -L -G -d "app=board&ver=${RESTYABOARD_VERSION}" -o /tmp/restyaboard.zip http://restya.com/download.php
			unzip /tmp/restyaboard.zip -d ${DOWNLOAD_DIR}
			cp ${DOWNLOAD_DIR}/restyaboard.conf /etc/nginx/conf.d
			rm /tmp/restyaboard.zip

			set +x
			echo "To configure nginx, enter your domain name (e.g., www.example.com, 192.xxx.xxx.xxx, etc.,):"
			read -r webdir
			while [[ -z "$webdir" ]]
			do
				read -r -p "To configure nginx, enter your domain name (e.g., www.example.com, 192.xxx.xxx.xxx, etc.,):" webdir
			done
			set -x
			echo "$webdir"
			echo "Changing server_name in nginx configuration..."
			sed -i "s/server_name.*$/server_name \"$webdir\";/" /etc/nginx/conf.d/restyaboard.conf
			sed -i "s|listen 80.*$|listen 80;|" /etc/nginx/conf.d/restyaboard.conf

			set +x
			echo "Enter your document root (where your Restyaboard to be installed. e.g., /usr/share/nginx/html/restyaboard):"
			read -r dir
			while [[ -z "$dir" ]]
			do
				read -r -p "Enter your document root (where your Restyaboard to be installed. e.g., /usr/share/nginx/html/restyaboard):" dir
			done
			set -x
			echo "$dir"
			mkdir -p "$dir"
			echo "Changing root directory in nginx configuration..."
			sed -i "s|root.*html|root $dir|" /etc/nginx/conf.d/restyaboard.conf
			echo "Copying Restyaboard script to root directory..."
			cp -r "$DOWNLOAD_DIR"/* "$dir"

			echo "Changing permission..."
			chmod -R go+w "$dir/media"
			chmod -R go+w "$dir/client/img"
			chmod -R go+w "$dir/tmp/cache"
			chmod -R 0755 $dir/server/php/shell/*.sh

			psql -U postgres -c "\q"
			if [ $? != 0 ]
			then
				echo "PostgreSQL Changing the permission failed with error code 40"
				exit 1
			fi			
			sleep 1

			echo "Creating PostgreSQL user and database..."
			psql -U postgres -c "CREATE USER ${POSTGRES_DBUSER} WITH ENCRYPTED PASSWORD '${POSTGRES_DBPASS}'"
			if [ $? != 0 ]
			then
				echo "PostgreSQL user creation failed with error code 41"
				exit 1
			fi			
			psql -U postgres -c "CREATE DATABASE ${POSTGRES_DBNAME} OWNER ${POSTGRES_DBUSER} ENCODING 'UTF8' TEMPLATE template0"
			if [ $? != 0 ]
			then
				echo "PostgreSQL database creation failed with error code 42"
				exit 1
			fi			
			psql -U postgres -c "CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;"
			if [ $? != 0 ]
			then
				echo "PostgreSQL extension creation failed with error code 43"
				exit 1
			fi			
			psql -U postgres -c "COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';"
			if [ "$?" = 0 ];
			then
				echo "Importing empty SQL..."
				psql -d ${POSTGRES_DBNAME} -f "$dir/sql/restyaboard_with_empty_data.sql" -U ${POSTGRES_DBUSER}
				if [ $? != 0 ]
				then
					echo "PostgreSQL Empty SQL importing failed with error code 45"
					exit 1
				fi	
			fi

			echo "Changing PostgreSQL database name, user and password..."
			sed -i "s/^.*'R_DB_NAME'.*$/define('R_DB_NAME', '${POSTGRES_DBNAME}');/g" "$dir/server/php/config.inc.php"
			sed -i "s/^.*'R_DB_USER'.*$/define('R_DB_USER', '${POSTGRES_DBUSER}');/g" "$dir/server/php/config.inc.php"
			sed -i "s/^.*'R_DB_PASSWORD'.*$/define('R_DB_PASSWORD', '${POSTGRES_DBPASS}');/g" "$dir/server/php/config.inc.php"
			sed -i "s/^.*'R_DB_HOST'.*$/define('R_DB_HOST', '${POSTGRES_DBHOST}');/g" "$dir/server/php/config.inc.php"
			sed -i "s/^.*'R_DB_PORT'.*$/define('R_DB_PORT', '${POSTGRES_DBPORT}');/g" "$dir/server/php/config.inc.php"
			
			echo "Setting up cron for every 5 minutes to update ElasticSearch indexing..."
			echo "*/5 * * * * $dir/server/php/shell/indexing_to_elasticsearch.sh" >> /var/spool/cron/root
			
			echo "Setting up cron for every 5 minutes to send email notification to user, if the user chosen notification type as instant..."
			echo "*/5 * * * * $dir/server/php/shell/instant_email_notification.sh" >> /var/spool/cron/root
			
			echo "Setting up cron for every 1 hour to send email notification to user, if the user chosen notification type as periodic..."
			echo "0 * * * * $dir/server/php/shell/periodic_email_notification.sh" >> /var/spool/cron/root
			
			echo "Setting up cron for every 30 minutes to fetch IMAP email..."
			echo "*/30 * * * * $dir/server/php/shell/imap.sh" >> /var/spool/cron/root
			
			echo "Setting up cron for every 5 minutes to send activities to webhook..."
			echo "*/5 * * * * $dir/server/php/shell/webhook.sh" >> /var/spool/cron/root
			
			echo "Setting up cron for every 5 minutes to send email notification to past due..."
			echo "*/5 * * * * $dir/server/php/shell/card_due_notification.sh" >> /var/spool/cron/root
			
			echo "Setting up cron for every 5 minutes to send chat conversation as email notification to user..."
			echo "*/5 * * * * $dir/server/php/shell/chat_activities.sh" >> /var/spool/cron/crontabs/root
			
			echo "Setting up cron for every 1 hour to send chat conversation as email notification to user, if the user chosen notification type as periodic..."
			echo "0 * * * * $dir/server/php/shell/periodic_chat_email_notification.sh" >> /var/spool/cron/crontabs/root
			
			echo "Reset php-fpm (use unix socket mode)..."
			sed -i "/listen = 127.0.0.1:9000/a listen = /var/run/php5-fpm.sock" /etc/php-fpm.d/www.conf

			echo "Do you want to setup SMTP configuration (y/n)?"
			read -r answer
			case "${answer}" in
				[Yy])
				echo "Enter SMTP server address (e.g., smtp.gmail.com)"
				read -r smtp_server
				echo "Enter SMTP port"
				read -r smtp_port
				echo "Enter SMTP username"
				read -r smtp_username
				echo "Enter SMTP password"
				read -r smtp_password
				sed -i "1021 i auth_username = $smtp_username" /etc/php.ini
				sed -i "1022 i auth_password = $smtp_password" /etc/php.ini
				sed -i "s/SMTP = localhost/SMTP = $smtp_server/" /etc/php.ini
				sed -i "s/smtp_port = 25/smtp_port = $smtp_port/" /etc/php.ini
			esac		
			
			# Start services
			ps -q 1 | grep -q -c "systemd"
			if [ "$?" -eq 0 ];
			then
				echo "Starting services with systemd..."
				systemctl start nginx
				systemctl start php-fpm
			else
				echo "Starting services..."
				/etc/init.d/php-fpm restart
				/etc/init.d/nginx restart
			fi

			if ! hash GeoIP-devel 2>&-;
			then
				yum install GeoIP-devel
				if [ $? != 0 ]
				then
					echo "GeoIP-devel installation failed with error code 46"
					exit 1
				fi
			fi

			if ! hash pecl/geoip 2>&-;
			then
				pecl install geoip
				if [ $? != 0 ]
				then
					echo "pecl geoip installation failed with error code 47"
					exit 1
				fi
			fi
			echo "extension=geoip.so" >> /etc/php.ini
			mkdir -v /usr/share/GeoIP
			if [ $? != 0 ]
			then
				echo "GeoIP folder creation failed with error code 48"
				exit 1
			fi
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
			
			ps -q 1 | grep -q -c "systemd"
			if [ "$?" -eq 0 ];
			then
				systemctl restart php-fpm
			else
				/etc/init.d/php-fpm restart
			fi
			
			set +x
			echo "Do you want to install Restyaboard apps (y/n)?"
			read -r answer
			set -x
			case "${answer}" in
				[Yy])
				if ! hash jq 2>&-;
				then
					echo "Installing jq..."
					yum install -y jq
					if [ $? != 0 ]
					then
						echo "jq installation failed with error code 49"
						exit 1
					fi
				fi
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
			
			cd /opt
			wget https://www.process-one.net/downloads/ejabberd/15.07/ejabberd-15.07.tgz
			wget https://packages.erlang-solutions.com/erlang/esl-erlang/FLAVOUR_1_general/esl-erlang_18.3-1~centos~6_i386.rpm
			rpm -ivh esl-erlang_18.3-1~centos~6_i386.rpm
			yum install libyaml*
			tar -zvxf ejabberd-15.07.tgz
			cd ejabberd-15.07
			./autogen.sh
			./configure --enable-pgsql
			make
			make install
			yum install php-xml
			echo "Creating ejabberd user and database..."
			psql -U postgres -c "CREATE USER ${EJABBERD_DBUSER} WITH ENCRYPTED PASSWORD '${EJABBERD_DBPASS}'"

			cd /etc/ejabberd
			psql -U postgres -c "CREATE DATABASE ${EJABBERD_DBNAME}"
			
			psql -d ${EJABBERD_DBNAME} -f "/opt/ejabberd-15.07/sql/pg.sql" -U postgres
			mv $dir/ejabberd.yml /etc/ejabberd/ejabberd.yml
			chmod -R go+w "/etc/ejabberd/ejabberd.yml"
			sed -i 's/restya.com/'$webdir'/g' /etc/ejabberd/ejabberd.yml
			sed -i 's/ejabberd15/'${EJABBERD_DBNAME}'/g' /etc/ejabberd/ejabberd.yml

			ejabberdctl start
			sleep 15
			ejabberdctl change_password admin $webdir restya
			ejabberdctl stop
			sleep 15
			ejabberdctl start

			ps -q 1 | grep -q -c "systemd"
			if [ "$?" -eq 0 ];
			then
				echo "Starting services with systemd..."
				systemctl start nginx
				systemctl start php-fpm
			else
				echo "Starting services..."
				/etc/init.d/php-fpm restart
				/etc/init.d/nginx restart
			fi
			
			/bin/echo "$RESTYABOARD_VERSION" > /opt/restyaboard/release
		esac
	fi
	set +x
	echo "Login with username admin and password restya"
} 2>&1 | tee -a restyaboard_install.log
