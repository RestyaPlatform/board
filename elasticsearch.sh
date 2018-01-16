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

                add-apt-repository ppa:openjdk-r/ppa
                apt-get update

                apt-get install -y openjdk-8-jre
                if [ $? != 0 ]
                then
                    echo "openjdk-8-jre installation failed with error code 14"
                fi
                wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.6.3.deb
                if [ $? != 0 ]
                then
                    echo "elasticsearch downloading failed with error code 15"
                    exit 1
                fi
                dpkg -i elasticsearch-5.6.3.deb
                service elasticsearch restart
                echo "Setting up cron for elastic search..."
			    echo "*/5 * * * * $dir/server/php/plugins/ElasticSearch/shell/indexing_to_elasticsearch.sh" >> /var/spool/cron/crontabs/root
            esac
        fi
        echo "Installation successfully completed"
    else
        set +x
		echo "Enter your document root (where your Restyaboard path already installed. e.g., /usr/share/nginx/html/restyaboard):"
		read -r dir
		while [[ -z "$dir" ]]
		do
			read -r -p "Enter your document root (where your Restyaboard path already installed. e.g., /usr/share/nginx/html/restyaboard):" dir
		done
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
                sudo yum install -y java-1.8.0-openjdk
                if [ $? != 0 ]
                then
                    echo "Java installation failed with error code 30"
                    exit 1
                fi
                wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.6.3.rpm
                if [ $? != 0 ]
                then
                    echo "ElasticSearch downloading failed with error code 31"
                    exit 1
                fi
                nohup rpm -Uvh elasticsearch-5.6.3.rpm &
                chkconfig elasticsearch on
                echo "Setting up cron for elastic search..."
			    echo "*/5 * * * * $dir/server/php/plugins/ElasticSearch/shell/indexing_to_elasticsearch.sh" >> /var/spool/cron/root
            esac
        fi
        echo "Installation successfully completed"
    fi
}