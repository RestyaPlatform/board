#/bin/sh
#
# Restyaboard uninstall
#
# Usage: ./restyaboard_uninstall.sh
#
# Copyright (c) 2014-2017 Restya.
# Dual License (OSL 3.0 & Commercial License)
{

	if [[ $EUID -ne 0 ]];
	then
		echo "This script must be run as root"
		exit 1
	fi

	POSTGRES_DBHOST=localhost
	POSTGRES_DBNAME=restyaboardtest
	POSTGRES_DBUSER=restyat
	POSTGRES_DBPASS=hjVl2!rGdt
	POSTGRES_DBPORT=5432
	DOWNLOAD_DIR=/opt/restyaboard
	version=$(cat ${DOWNLOAD_DIR}/release)

	set -x
	whoami
	echo $(cat /etc/issue)
	OS_REQUIREMENT=$(lsb_release -i -s)
	if ([ "$OS_REQUIREMENT" = "" ])
	then
		echo "lsb_release is not enabled, please install \"yum install -y redhat-lsb-core\" command before running uninstall script"
		exit 1
	fi

	set +x
	echo -e "Uninstall script will uninstall version ${version}, drop database ${POSTGRES_DBNAME} with user ${POSTGRES_DBUSER} and password ${POSTGRES_DBPASS}, installed files and its directories which are related to restyaboard, crons and nginx configuration. To continue enter \"y\" or to quit the process and edit the version and database details enter \"n\" (y/n)?"
	read -r answer
	set -x
	case "${answer}" in
		[Yy])
		set +x
		echo "Enter the reason for uninstalling the Restyaboard:"
		read -r reason
		while [[ -z "$reason" ]]
		do
			read -r -p "Enter the reason for uninstalling the Restyaboard:" reason
		done

		curl -v -L -G -d "app=board&ver=${version}&reason=${reason}&os=${OS_REQUIREMENT}" "http://restya.com/uninstall.php"

		set +x
		echo "Enter your document root (where your Restyaboard was installed. e.g., /usr/share/nginx/html/restyaboard):"
		read -r dir
		while [[ -z "$dir" ]]
		do
			read -r -p "Enter your document root (where your Restyaboard was installed. e.g., /usr/share/nginx/html/restyaboard):" dir
		done


		echo "Removing PostgreSQL user and database..."
		psql -U postgres -c "DROP USER IF EXISTS ${POSTGRES_DBUSER};"
		psql -U postgres -c "DROP DATABASE ${POSTGRES_DBNAME};"
		
		echo "Removing Restyaboard files and its directories..."
		rm -rf $dir

		echo "Removing Restyaboard conf file"
		rm -rf /etc/nginx/conf.d/restyaboard.conf

		echo "Clearing the Restyaboard crons"
		sed -i '/\*\/5 \* \* \* \* $dir\/server\/php\/shell\/instant_email_notification.sh > \/dev\/null 2> \/dev\/null/d' /var/spool/cron/crontabs/root
		sed -i '/\0 \* \* \* \* $dir\/server\/php\/shell\/periodic_email_notification.sh > \/dev\/null 2> \/dev\/null/d' /var/spool/cron/crontabs/root
		sed -i '/\*\/30 \* \* \* \* $dir\/server\/php\/shell\/imap.sh > \/dev\/null 2> \/dev\/null/d' /var/spool/cron/crontabs/root
		sed -i '/\*\/5 \* \* \* \* $dir\/server\/php\/shell\/card_due_notification.sh > \/dev\/null 2> \/dev\/null/d' /var/spool/cron/crontabs/root
		sed -i '/\*\/5 \* \* \* \* $dir\/server\/php\/shell\/webhook.sh > \/dev\/null 2> \/dev\/null/d' /var/spool/cron/crontabs/root

		if ([ "$OS_REQUIREMENT" = "Ubuntu" ] || [ "$OS_REQUIREMENT" = "Debian" ] || [ "$OS_REQUIREMENT" = "Raspbian" ])
		then
			set +x
			echo "Uninstall script is going to uninstall PHP, are you sure want to remove (y/n)?"
			read -r answer
			set -x
			case "${answer}" in
				[Yy])
				apt-get remove php* -y 
				apt-get purge php* -y
			esac

			set +x
			echo "Uninstall script is going to uninstall PostgreSQL, are you sure want to remove (y/n)?"
			read -r answer
			set -x
			case "${answer}" in
				[Yy])
				apt-get --purge remove postgresql-* -y
			esac

			set +x
			echo "Uninstall script is going to uninstall nginx, are you sure want to remove (y/n)?"
			read -r answer
			set -x
			case "${answer}" in
				[Yy])
				apt-get purge nginx nginx-common -y
			esac
		else
			set +x
			echo "Uninstall script is going to uninstall PHP, are you sure want to remove (y/n)?"
			read -r answer
			set -x
			case "${answer}" in
				[Yy])
				yum remove php*
			esac

			set +x
			echo "Uninstall script is going to uninstall PostgreSQL, are you sure want to remove (y/n)?"
			read -r answer
			set -x
			case "${answer}" in
				[Yy])
				yum remove postgresql-*
			esac

			set +x
			echo "Uninstall script is going to uninstall nginx, are you sure want to remove (y/n)?"
			read -r answer
			set -x
			case "${answer}" in
				[Yy])
				yum remove nginx
			esac
		fi
	esac
} 2>&1 | tee -a restyaboard_uninstall.log