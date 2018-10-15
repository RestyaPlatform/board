#!/bin/bash
#
# Install script for Chat plugin setup
#
# Usage: ./chat.sh
#
# Copyright (c) 2014-2016 Restya.
# Dual License (OSL 3.0 & Commercial License)
{
	main() {
		if [[ $EUID -ne 0 ]];
		then
			echo "This script must be run as root"
			exit 1
		fi
		
		set -x
		whoami
		echo $(cat /etc/issue)
		OS_REQUIREMENT=$(lsb_release -i -s)
		OS_VERSION=$(lsb_release -rs | cut -f1 -d.)

		RESTYABOARD_DIR=$PWD
		APP_DIR=$PWD/client/apps/r_chat
		POSTGRES_DBHOST=localhost
		POSTGRES_DBNAME=restyaboard
		POSTGRES_DBUSER=restya

		# look for Non-empty sql dir in r_chat app folder
		if [ "$(ls -A $APP_DIR/sql)" ]; then
			psql -U postgres -c "\q"
			error_code=$?
			if [ ${error_code} != 0 ]
			then
				echo "PostgreSQL Changing the permission failed with error code ${error_code} (PostgreSQL Changing the permission failed with error code 34)"
				return 34
			fi
			sleep 1
			echo "Importing SQL..."
			psql -d ${POSTGRES_DBNAME} -f "$APP_DIR/sql/r_chat.sql" -U ${POSTGRES_DBUSER}
			if [ ${error_code} != 0 ]
			then
				echo "PostgreSQL SQL importing failed with error code ${error_code} (PostgreSQL Empty SQL failed with error code 39)"
				return 39
			fi
		fi
		# Look for Non-empty plugins folder
		if [ "$(ls -A $RESTYABOARD_DIR/server/php/plugins)" ]; then
			chmod -R 0777 $RESTYABOARD_DIR/server/php/plugins
		fi

		EJABBERD_DBHOST=localhost
		EJABBERD_DBNAME=ejabberd
		EJABBERD_DBUSER=ejabb
		EJABBERD_DBPASS=ftfnVgYl2
		EJABBERD_DBPORT=5432

		set +x
		echo "Enter your document root (where your Restyaboard path already installed. e.g., /usr/share/nginx/html/restyaboard):"
		read -r dir
		while [[ -z "$dir" ]]
		do
			read -r -p "Enter your document root (where your Restyaboard path already installed. e.g., /usr/share/nginx/html/restyaboard):" dir
		done

		set +x
		echo "To configure ejabberd, enter your restyaboard domain name (e.g., www.example.com, 192.xxx.xxx.xxx, etc.,):"
		read -r webdir
		while [[ -z "$webdir" ]]
		do
			read -r -p "To configure ejabberd, enter your restyaboard domain name (e.g., www.example.com, 192.xxx.xxx.xxx, etc.,):" webdir
		done

		if ([ "$OS_REQUIREMENT" = "Ubuntu" ] || [ "$OS_REQUIREMENT" = "Debian" ] || [ "$OS_REQUIREMENT" = "Raspbian" ])
		then
			apt install -y libz-dev
			CRON_DIR=/var/spool/cron/crontabs/root
		else
			CRON_DIR=/var/spool/cron/root
		fi

		cd /opt
		wget -O ejab.tgz https://www.process-one.net/downloads/downloads-action.php?file=/ejabberd/18.04/ejabberd-18.04.tgz
		tar -xvzf ejab.tgz
		cd ejabberd-18.04/
		./configure --enable-pgsql
		make
		make install

		echo "Creating ejabberd user and database..."
		psql -U postgres -c "CREATE USER ${EJABBERD_DBUSER} WITH ENCRYPTED PASSWORD '${EJABBERD_DBPASS}'"
		psql -U postgres -c "CREATE DATABASE ${EJABBERD_DBNAME}"
		psql -d ${EJABBERD_DBNAME} -f "/opt/ejabberd-15.07/sql/pg.sql" -U postgres

		mv $dir/ejabberd.yml /usr/local/etc/ejabberd/ejabberd.yml
		chmod -R go+w "/usr/local/etc/ejabberd/ejabberd.yml"
		sed -i "s/restya.com/$webdir/g" /usr/local/etc/ejabberd/ejabberd.yml
		sed -i 's/sql_database: "ejabberd"/sql_database: "'${EJABBERD_DBNAME}'"/g' /usr/local/etc/ejabberd/ejabberd.yml
		sed -i 's/sql_username: "postgres"/sql_username: "'${EJABBERD_DBUSER}'"/g' /usr/local/etc/ejabberd/ejabberd.yml
		sed -i 's/sql_password: ""/sql_password: "'${EJABBERD_DBPASS}'"/g' /usr/local/etc/ejabberd/ejabberd.yml

		ejabberdctl start
		sleep 15
		ejabberdctl register admin localhost restya
		ejabberdctl stop
		sleep 15
		ejabberdctl start

		echo "Setting up cron for chat server..."
		echo "*/5 * * * * $dir/server/php/plugins/Chat/shell/chat_activities.sh" >> CRON_DIR
		echo "0 * * * * $dir/server/php/plugins/Chat/shell/periodic_chat_email_notification.sh" >> CRON_DIR

		echo "Installation successfully completed"	
	}
	main
    echo "If you're finding it difficult to install Restyaboard Chat Plugin from your end, we do also offer free installation support that you may consider by contact us at info@restya.com"
	exit 1
} 2>&1 | tee -a chat.log