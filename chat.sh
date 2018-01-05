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
	OS_REQUIREMENT=$(lsb_release -i -s)
	OS_VERSION=$(lsb_release -rs | cut -f1 -d.)
	if ([ "$OS_REQUIREMENT" = "Ubuntu" ] || [ "$OS_REQUIREMENT" = "Debian" ] || [ "$OS_REQUIREMENT" = "Raspbian" ])
	then
		set +x
		echo "Enter your document root (where your Restyaboard path already installed. e.g., /usr/share/nginx/html/restyaboard):"
		read -r dir
		while [[ -z "$dir" ]]
		do
			read -r -p "Enter your document root (where your Restyaboard path already installed. e.g., /usr/share/nginx/html/restyaboard):" dir
		done

        EJABBERD_DBHOST=localhost
        EJABBERD_DBNAME=ejabberd
        EJABBERD_DBUSER=ejabb
        EJABBERD_DBPASS=ftfnVgYl2
		EJABBERD_DBPORT=5432
		echo "Changing ejabberd database name, user and password..."
		sed -i "s/^.*'CHAT_DB_NAME'.*$/define('CHAT_DB_NAME', '${EJABBERD_DBNAME}');/g" "$dir/server/php/config.inc.php"
		sed -i "s/^.*'CHAT_DB_USER'.*$/define('CHAT_DB_USER', '${EJABBERD_DBUSER}');/g" "$dir/server/php/config.inc.php"
		sed -i "s/^.*'CHAT_DB_PASSWORD'.*$/define('CHAT_DB_PASSWORD', '${EJABBERD_DBPASS}');/g" "$dir/server/php/config.inc.php"
		sed -i "s/^.*'CHAT_DB_HOST'.*$/define('CHAT_DB_HOST', '${EJABBERD_DBHOST}');/g" "$dir/server/php/config.inc.php"
		sed -i "s/^.*'CHAT_DB_PORT'.*$/define('CHAT_DB_PORT', '${EJABBERD_DBPORT}');/g" "$dir/server/php/config.inc.php"

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
			apt install automake libc6-dev gcc libssl-dev erlang
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
			sed -i 's/odbc_username: "postgres"/odbc_username: "'${EJABBERD_DBUSER}'"/g' /etc/ejabberd/ejabberd.yml
			sed -i 's/odbc_password: ""/odbc_password: "'${EJABBERD_DBPASS}'"/g' /etc/ejabberd/ejabberd.yml

			echo "Setting up cron for chat server..."
			echo "*/5 * * * * $dir/server/php/plugins/Chat/shell/chat_activities.sh" >> /var/spool/cron/crontabs/root
			echo "0 * * * * $dir/server/php/plugins/Chat/shell/periodic_chat_email_notification.sh" >> /var/spool/cron/crontabs/root
			
			ejabberdctl start
			sleep 15
			ejabberdctl change_password admin localhost restya
			ejabberdctl stop
			sleep 15
			ejabberdctl start
        echo "Installation successfully completed"
    else
		set +x
		echo "Enter your document root (where your Restyaboard path already installed. e.g., /usr/share/nginx/html/restyaboard):"
		read -r dir
		while [[ -z "$dir" ]]
		do
			read -r -p "Enter your document root (where your Restyaboard path already installed. e.g., /usr/share/nginx/html/restyaboard):" dir
		done

        wget https://www.process-one.net/downloads/ejabberd/15.07/ejabberd-15.07.tgz

        yum install -y libyaml*
			tar -zvxf ejabberd-15.07.tgz
			cd ejabberd-15.07
			./autogen.sh
			./configure --enable-pgsql
			make
			make install

        echo "Creating ejabberd user and database..."
			psql -U postgres -c "CREATE USER ${EJABBERD_DBUSER} WITH ENCRYPTED PASSWORD '${EJABBERD_DBPASS}'"

			cd /etc/ejabberd
			psql -U postgres -c "CREATE DATABASE ${EJABBERD_DBNAME}"
			
			psql -d ${EJABBERD_DBNAME} -f "/opt/ejabberd-15.07/sql/pg.sql" -U postgres
			mv $dir/ejabberd.yml /etc/ejabberd/ejabberd.yml
			chmod -R go+w "/etc/ejabberd/ejabberd.yml"
			sed -i 's/ejabberd15/'${EJABBERD_DBNAME}'/g' /etc/ejabberd/ejabberd.yml

			echo "Setting up cron for chat server..."
			echo "*/5 * * * * $dir/server/php/plugins/Chat/shell/chat_activities.sh" >> /var/spool/cron/root
			echo "0 * * * * $dir/server/php/plugins/Chat/shell/periodic_chat_email_notification.sh" >> /var/spool/cron/root

			ejabberdctl start
			sleep 15
			ejabberdctl change_password admin localhost restya
			ejabberdctl stop
			sleep 15
			ejabberdctl start

        echo "Installation successfully completed"
	fi
}