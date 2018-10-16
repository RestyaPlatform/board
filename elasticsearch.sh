#!/bin/bash
#
# Install script for ElasticSearch plugin setup
#
# Usage: ./elasticsearch.sh
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
        APP_DIR=$PWD/client/apps/r_elasticsearch
        POSTGRES_DBHOST=localhost
        POSTGRES_DBNAME=restyaboard
        POSTGRES_DBUSER=restya

        # look for Non-empty sql dir in r_elasticsearch app folder
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
            psql -d ${POSTGRES_DBNAME} -f "$APP_DIR/sql/r_elasticsearch.sql" -U ${POSTGRES_DBUSER}
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
        exit 1
    }
    main
    echo "If you're finding it difficult to install Restyaboard ElasticSearch Plugin from your end, we do also offer free installation support that you may consider by contact us at info@restya.com"
	exit 1
} 2>&1 | tee -a elasticsearch.log