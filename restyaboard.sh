#/bin/sh
#
# Install script for Restyaboard
#
# Usage: ./restyaboard.sh
#
# Copyright (c) 2014-2015 Restya.
# Dual License (OSL 3.0 & Commercial License)
{
	RESTYABOARD_VERSION=v0.1.5
	POSTGRES_DBHOST=localhost
	POSTGRES_DBNAME=restyaboard
	POSTGRES_DBUSER=restya
	POSTGRES_DBPASS=hjVl2!rGd
	POSTGRES_DBPORT=5432
	
	echo "Setup script will install version ${RESTYABOARD_VERSION} and create database ${POSTGRES_DBNAME} with user ${POSTGRES_DBUSER} and password ${POSTGRES_DBPASS}. To continue enter \"y\" or to quit the process and edit the version and database details enter \"n\" (y/n)?" 
	read answer
	case "${answer}" in
		[Yy])

		echo "Checking PHP..."
		if ! hash php 2>&-; then
			echo "PHP is not installed!"
			echo "Do you want to install PHP (y/n)?" 
			read answer
			case "${answer}" in
				[Yy])
				echo "Installing PHP..."
				yum install -y epel-release
				yum install -y php-fpm php-cli
				service php-fpm start
				chkconfig --levels 35 php-fpm on
			esac
		fi

		echo "Checking PHP pgsql extension..."
		php -m | grep pgsql
		if [ "$?" -gt 0 ]; then
			echo "Installing php-pgsql..."
			yum install -y php-pgsql
		fi

		echo "Checking PHP mbstring extension..."
		php -m | grep mbstring
		if [ "$?" -gt 0 ]; then
			echo "Installing php-mbstring..."
			yum install -y php-mbstring
		fi

		PHP_VERSION=$(php -v | grep "PHP 5" | sed 's/.*PHP \([^-]*\).*/\1/' | cut -c 1-3)
		echo "Installed PHP version: '$PHP_VERSION'"

		echo "Checking nginx..."
		if ! which nginx > /dev/null 2>&1; then
			echo "nginx not installed!"
			echo "Do you want to install nginx (y/n)?"
			read answer
			case "${answer}" in
				[Yy])
				echo "Installing nginx..."
				yum install -y epel-release
				yum install -y zip curl cron nginx
				service nginx start
				chkconfig --levels 35 nginx on
			esac
		fi

		echo "Checking PostgreSQL..."
		id -a postgres
		if [ $? != 0 ]; then
			echo "PostgreSQL not installed!"
			echo "Do you want to install PostgreSQL (y/n)?"
			read answer
			case "${answer}" in
				[Yy])
				echo "Installing PostgreSQL..."
				if [ $(getconf LONG_BIT) = "32" ]; then
					yum install http://yum.postgresql.org/9.4/redhat/rhel-6.6-i386/pgdg-centos94-9.4-1.noarch.rpm
				fi
				if [ $(getconf LONG_BIT) = "64" ]; then
					yum install http://yum.postgresql.org/9.4/redhat/rhel-6.6-x86_64/pgdg-centos94-9.4-1.noarch.rpm
				fi
				yum install -y postgresql94-server postgresql04-contrib
				service postgresql-9.4 initdb
				/etc/init.d/postgresql-9.4 start
				chkconfig --levels 35 postgresql-9.4 on
				sed -e 's/peer/trust/g' -e 's/ident/trust/g' < /var/lib/pgsql/9.4/data/pg_hba.conf > /var/lib/pgsql/9.4/data/pg_hba.conf.1
				cd /var/lib/pgsql/9.4/data
				mv pg_hba.conf pg_hba.conf_old
				mv pg_hba.conf.1 pg_hba.conf
				/etc/init.d/postgresql-9.4 restart
			esac
		fi

		echo "Checking ElasticSearch..."
		if ! curl http://localhost:9200 > /dev/null 2>&1; then
			echo "ElasticSearch not installed!"
			echo "Do you want to install ElasticSearch (y/n)?"
			read answer
			case "${answer}" in
				[Yy])
				echo "Installing ElasticSearch..."
				sudo yum install java-1.7.0-openjdk -y
				wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.90.10.noarch.rpm
				nohup rpm -Uvh elasticsearch-0.90.10.noarch.rpm &
				chkconfig elasticsearch on
			esac
		fi

		echo "Downloading Restyaboard script..."
		mkdir /opt/restyaboard
		curl -L -o /tmp/restyaboard.zip \
		https://github.com/RestyaPlatform/board/releases/download/${RESTYABOARD_VERSION}/board-${RESTYABOARD_VERSION}.zip &&\
		unzip /tmp/restyaboard.zip -d /opt/restyaboard &&\
		cp /opt/restyaboard/restyaboard.conf /etc/nginx/conf.d
		rm /tmp/restyaboard.zip

		echo -n "To configure nginx, enter your domain name:"
		read webdir
		echo "$webdir"
		echo -n "Changing server_name in nginx configuration..."
		sed -i "s/server_name.*$/server_name "$webdir";/" /etc/nginx/conf.d/restyaboard.conf
		sed -i 's|listen 80.*$|listen 80;|' /etc/nginx/conf.d/restyaboard.conf

		echo -n "To copy downloaded script, enter your document root path:"
		read dir
		echo "$dir"
		mkdir -p $dir
		echo -n "Changing root directory in nginx configuration..."
		sed -i 's|root.*html|root '$dir'|' /etc/nginx/conf.d/restyaboard.conf
		echo -n "Copying Restyaboard script to root directory..."
		cp -r /opt/restyaboard/* "$dir"

		echo "Changing permission..."
		chmod -R go+w $dir/media
		chmod -R go+w $dir/client/img

		psql -U postgres -c "\q"
		if [ "$?" = 0 ]; then
			break
		fi	
		sleep 1

		echo "Creating PostgreSQL user and database..."
		psql -U postgres -c "CREATE USER ${POSTGRES_DBUSER} WITH ENCRYPTED PASSWORD '${POSTGRES_DBPASS}'"
		psql -U postgres -c "CREATE DATABASE ${POSTGRES_DBNAME} OWNER ${POSTGRES_DBUSER} ENCODING 'UTF8'"
		if [ "$?" = 0 ]; then
			echo "Importing empty SQL..."
			psql -d ${POSTGRES_DBNAME} -f $dir/sql/restyaboard_with_empty_data.sql -U ${POSTGRES_DBUSER}
		fi

		echo "Changing PostgreSQL database name, user and password..."
		sed -i "s/^.*'R_DB_NAME'.*$/define('R_DB_NAME', '${POSTGRES_DBNAME}');/g" \
			$dir/server/php/R/config.inc.php
		sed -i "s/^.*'R_DB_USER'.*$/define('R_DB_USER', '${POSTGRES_DBUSER}');/g" \
			$dir/server/php/R/config.inc.php
		sed -i "s/^.*'R_DB_PASSWORD'.*$/define('R_DB_PASSWORD', '${POSTGRES_DBPASS}');/g" \
			$dir/server/php/R/config.inc.php
		sed -i "s/^.*'R_DB_HOST'.*$/define('R_DB_HOST', '${POSTGRES_DBHOST}');/g" \
			$dir/server/php/R/config.inc.php
		sed -i "s/^.*'R_DB_PORT'.*$/define('R_DB_PORT', '${POSTGRES_DBPORT}');/g" \
		  $dir/server/php/R/config.inc.php
		
		echo "Setting up cron for every 5 minutes to update ElasticSearch indexing..."  
		echo '*/5 * * * * php $dir/server/php/R/shell/cron.php' >> /var/spool/cron/root

		echo "Starting services..."
		/etc/init.d/php-fpm restart
		/etc/init.d/nginx restart
	esac
} | tee -a restyaboard_install.log