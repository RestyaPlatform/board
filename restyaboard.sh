#!/bin/bash
#
# Install script for Restyaboard
#
# Usage: ./restyaboard.sh
#
# Copyright (c) 2014-2019 Restya.
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
		#
		# Checking the OS name and OS version
		#
		find_release ()
		{
			# Checking the Ubuntu OS
			if [ -f /etc/lsb-release ]; then
				OS_REQUIREMENT="`grep DISTRIB_ID /etc/lsb-release`"
				DISTRIB_ID='DISTRIB_ID='
				OS_NAME=$OS_REQUIREMENT$DISTRIB_ID
				array=();
				if ([ "$OS_REQUIREMENT" != "$DISTRIB_ID" ])
				then
					while [[ $OS_NAME ]]; do
					array+=( "${OS_NAME%%"$DISTRIB_ID"*}" );
					OS_NAME=${OS_NAME#*"$DISTRIB_ID"};
					done;
					OS_REQUIREMENT=${array[1]}
				fi
				OS_VERSION="`grep DISTRIB_RELEASE /etc/lsb-release`"
				DISTRIB_RELEASE='DISTRIB_RELEASE='
				OS_Ver=$OS_VERSION$DISTRIB_RELEASE
				version=();
				if ([ "$OS_VERSION" != "$DISTRIB_RELEASE" ])
				then
					while [[ $OS_Ver ]]; do
					version+=( "${OS_Ver%%"$DISTRIB_RELEASE"*}" );
					OS_Ver=${OS_Ver#*"$DISTRIB_RELEASE"};
					done;
					OS_VERSION=${version[1]}
				fi
				return
			fi

			# Checking the Redhat, Fedora, and Centos
			if [ -f /etc/redhat-release ]; then
				OS_REQUIREMENT="`cat /etc/redhat-release | cut -d ' ' -f 1`"
				OS_VERSION="`cat /etc/redhat-release | cut -d ' ' -f 4 | cut -d '.' -f 1`"
				return
			fi

			# Checking the Debian OS
			if [ -f /etc/issue ]; then
				OS_REQUIREMENT="`cat /etc/issue | cut -d ' ' -f 1`"
				OS_VERSION="`cat /etc/issue | cut -d ' ' -f 3`"
				return
			fi

			# Checking the OpenBSD 
			if [ -f /etc/motd ]; then
				OS_REQUIREMENT="`cat /etc/motd | head -1 | cut -d ' ' -f 1`"
				OS_VERSION="`cat /etc/motd | head -1 | cut -d ' ' -f 2`"
				return
			fi

		}
		findbin ()
        {
            ret=0
            newpath=`echo $PATH | tr : ' '`
            for i in ${newpath}; do
				if [ -x $i/$1 ]; then
					ret=1
					break
				fi
            done
            echo $ret
            return 
        }
        checkdeps()
        {
            pkginfo="dpkg rpm ipkg pkg_info"
            for i in $pkginfo; do
                ret=`findbin $i`
                if [ $ret -eq 1 ]; then
					pkginfo=$i
					echo "Yes, found $i, so we'll use that for listing packages"
					break
                fi
            done

            if [ ${pkginfo} = "pkg_info" ]; then
                # BSD needs PKG_PATH set to load anything over the net.
                if [ x${PKG_PATH} = x ]; then
					echo "Please set the environment variable PKG_PATH and try again."
					exit 1
                fi
            fi
            
            
            pkg_name="yum apt-get ipkg pkg_add"
            for i in ${pkg_name}; do
                ret=`findbin $i`
                if [ $ret -eq 1 ]; then
                pkg_name=$i
					echo "Yes, found $i, so we'll use that to install packages"
					break
                fi
            done
            

            for i in ${genericdeps} ${gtkdeps} ${kdedeps}; do
                case $pkginfo in
                dpkg)
                    deps="`dpkg -l "*$i*" | grep -- "^ii" | cut -d ' ' -f 3`"
                    ;;
                rpm)
                deps="`rpm -q $i`"
                    ;;
                pkg_info)
                deps="`pkg_info | grep "$i" | sed -e 's: .*$::'`"
                ;;
                ipkg)
                deps="todo"
                    ;;
                *)
                    echo "ERROR: No package manager found!"
                    exit 1
                    ;;
                esac
                found=`echo ${deps} | grep -v 'not installed' | grep -c "${i}" 2>&1`
                if [ $found -gt 0 ]; then
                	echo "Yes, found $i"
                else
					echo "Nope, $i appears to not be installed"
					missing="${missing} $i"
                fi
                done

            if [ -n "${missing}" ]; then
                echo "package(s)\"${missing}\" are missing!"
                echo "You will need sudo priviledges to install the packages"
                if [ x$yes = xno ]; then
                	$debug sudo ${pkgnet} install ${missing}
                else
                	$debug sudo ${pkgnet} -y install ${missing}
                fi
            fi
        }
		install_nginx() 
		{
			if ([ "$OS_REQUIREMENT" = "Ubuntu" ] || [ "$OS_REQUIREMENT" = "Debian" ] || [ "$OS_REQUIREMENT" = "LinuxMint" ] || [ "$OS_REQUIREMENT" = "Raspbian" ])
			then
				APACHE_ENABLED=$(service apache2 status | grep 'running' | wc -l) 
				if [ ${APACHE_ENABLED} -eq 1 ]
				then
					set +x
					echo "It looks like Apache is running in your server. If you've configured and using any other application in Apache then continue in Apache. Otherwise Restyaboard is recommending to use nginx. So script will stop the apache and install nginx in your server. Do you want to continue as Apache provide "y" or to continue with nginx provide "n" (Y/n)?"
					read -r answer
					set -x
					case "${answer}" in
						[Nn])
						echo "Stopping apache..."
						service apache2 stop
						APACHE_ENABLED=$(service apache2 status | grep 'running' | wc -l) 
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
								apt install -y cron nginx
								error_code=$?
								if [ ${error_code} != 0 ]
								then
									echo "nginx installation failed with error code ${error_code} (nginx installation failed with error code 2)"
									return 2
								fi
								if [ -f "/etc/nginx/conf.d/default" ]; then
									rm -rf /etc/nginx/conf.d/default
								fi
								if [ -f "/etc/nginx/sites-enabled/default" ]; then
									rm -rf /etc/nginx/sites-enabled/default
								fi
								if [ -f "/etc/nginx/sites-available/default" ]; then
									rm -rf /etc/nginx/sites-available/default
								fi
								service nginx start
							esac
						fi
					esac
				else
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
							apt install -y cron nginx
							error_code=$?
							if [ ${error_code} != 0 ]
							then
								echo "nginx installation failed with error code ${error_code} (nginx installation failed with error code 2)"
								return 2
							fi
							if [ -f "/etc/nginx/conf.d/default" ]; then
								rm -rf /etc/nginx/conf.d/default
							fi
							if [ -f "/etc/nginx/sites-enabled/default" ]; then
								rm -rf /etc/nginx/sites-enabled/default
							fi
							if [ -f "/etc/nginx/sites-available/default" ]; then
								rm -rf /etc/nginx/sites-available/default
							fi
							service nginx start
						esac
					fi
				fi
			else
				APACHE_ENABLED=$(service httpd status | grep 'running' | wc -l)
				if [ ${APACHE_ENABLED} -eq 1 ]
				then  
					set +x
					echo "It looks like Apache is running in your server. If you've configured and using any other application in Apache then continue in Apache. Otherwise Restyaboard is recommending to use nginx. So script will stop the apache and install nginx in your server. Do you want to continue as Apache provide "y" or to continue with nginx provide "n" (Y/n)?"
					read -r answer
					set -x
					case "${answer}" in
						[Nn])
						echo "Stopping apache..."
						service httpd stop
						APACHE_ENABLED=$(service httpd status | grep 'running' | wc -l) 
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
                                rpm -Uvh "http://nginx.org/packages/centos/${OS_VERSION}/noarch/RPMS/nginx-release-centos-${OS_VERSION}-0.el${OS_VERSION}.ngx.noarch.rpm"
                                yum install -y zip cronie nginx
                                error_code=$?
                                if [ ${error_code} != 0 ]
                                then
                                    echo "cron nginx installation failed with error code ${error_code} cron nginx installation failed with error code 18"
                                    return 18
                                fi
                                if [ -f "/etc/nginx/conf.d/default.conf" ]; then
                                    rm -rf /etc/nginx/conf.d/default.conf
                                fi
								if [ -f "/etc/nginx/sites-enabled/default.conf" ]; then
                                    rm -rf /etc/nginx/sites-enabled/default.conf
                                fi
                                if [ -f "/etc/nginx/sites-available/default.conf" ]; then
                                    rm -rf /etc/nginx/sites-available/default.conf
                                fi
                                service nginx start
                                chkconfig --levels 35 nginx on
                            esac
						fi
					esac
				else
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
							rpm -Uvh "http://nginx.org/packages/centos/${OS_VERSION}/noarch/RPMS/nginx-release-centos-${OS_VERSION}-0.el${OS_VERSION}.ngx.noarch.rpm"
							yum install -y zip cronie nginx
							error_code=$?
							if [ ${error_code} != 0 ]
							then
								echo "cron nginx installation failed with error code ${error_code} cron nginx installation failed with error code 18"
								return 18
							fi
							if [ -f "/etc/nginx/conf.d/default.conf" ]; then
								rm -rf /etc/nginx/conf.d/default.conf
							fi
							if [ -f "/etc/nginx/sites-enabled/default.conf" ]; then
								rm -rf /etc/nginx/sites-enabled/default.conf
							fi
							if [ -f "/etc/nginx/sites-available/default.conf" ]; then
								rm -rf /etc/nginx/sites-available/default.conf
							fi
							service nginx start
							chkconfig --levels 35 nginx on
						esac
					fi
				fi
			fi
		}
		install_php()
		{
			if ! hash php 2>&-; then
				echo "PHP is not installed!"
				set +x
				echo "Do you want to install PHP (y/n)?"
				read -r answer
				set -x
				case "${answer}" in
					[Yy])
					if ([ "$pkg_name" = "apt-get" ])
					then							
						echo "Installing PHP..."
						apt install -y php7.4 php7.4-common --allow-unauthenticated
						error_code=$?
						if [ ${error_code} != 0 ]
						then
							echo "PHP installation failed with error code ${error_code} (PHP installation failed with error code 3)"
							return 3
						fi
					else 
						if ([ "$pkg_name" = "yum" ])
						then
							if ([ "$OS_REQUIREMENT" = "CentOS" ] && [ "$OS_VERSION" = "8" ])
        					then
								echo "Note: For the latest version of PHP, we're going to download https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm and https://rpms.remirepo.net/enterprise/remi-release-8.rpm."
								echo "Installing PHP..."
								dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
								dnf -y install https://rpms.remirepo.net/enterprise/remi-release-8.rpm
								dnf module enable php:remi-7.4
								dnf -y install php php-cli php-common
							else
								yum install -y epel-release
								echo "Note: For the latest version of PHP, we're going to download http://rpms.famillecollet.com/enterprise/remi-release-${OS_VERSION}.rpm."
								echo "Installing PHP..."
								rpm -Uvh "http://rpms.famillecollet.com/enterprise/remi-release-${OS_VERSION}.rpm"
								yum --enablerepo=remi-php74 install -y php
							fi
							error_code=$?
							if [ ${error_code} != 0 ]
							then
								echo "php installation failed with error code ${error_code} (php installation failed with error code 20)"
								return 20
							fi
						fi
					fi
				esac
			fi
			
			echo "Installing PHP fpm and cli extension..."
			if ([ "$pkg_name" = "apt-get" ])
			then
				apt install -y php7.4-fpm php7.4-cli --allow-unauthenticated
				error_code=$?
				if [ ${error_code} != 0 ]
				then
					echo "php7.4-cli installation failed with error code ${error_code} (php7.4-cli installation failed with error code 4)"
				fi
				service php7.4-fpm start
			else 
				if ([ "$pkg_name" = "yum" ])
				then
					if ([ "$OS_REQUIREMENT" = "CentOS" ] && [ "$OS_VERSION" = "8" ])
        			then
						dnf -y install php-fpm php-devel php-opcache
						dnf -y install php-json
					else
						yum --enablerepo=remi-php74 install -y php-fpm php-devel php-cli php-opcache
					fi
					error_code=$?
					if [ ${error_code} != 0 ]
					then
						echo "php-devel installation failed with error code ${error_code} (php-devel installation failed with error code 21)"
						return 21
					fi					
					service php-fpm start
				fi
			fi
			if ([ "$OS_REQUIREMENT" = "Ubuntu" ] || [ "$OS_REQUIREMENT" = "Debian" ] || [ "$OS_REQUIREMENT" = "LinuxMint" ] || [ "$OS_REQUIREMENT" = "Raspbian" ])
			then
				echo "...."
			else
				chkconfig --levels 35 php-fpm on		
			fi
			
			echo "Checking PHP curl extension..."
			php -m | grep curl
			if [ "$?" -gt 0 ]; then
				echo "Installing php-curl..."
				if ([ "$pkg_name" = "apt-get" ])
				then
					apt install -y php7.4-curl --allow-unauthenticated
					error_code=$?
					if [ ${error_code} != 0 ]
					then
						echo "php7.4-curl installation failed with error code ${error_code} (php7.4-curl installation failed with error code 5)"
						return 5
					fi
				else 
					if ([ "$pkg_name" = "yum" ])
					then
						if ([ "$OS_REQUIREMENT" = "CentOS" ] && [ "$OS_VERSION" = "8" ])
						then
							dnf -y install php-curl
						else
							yum --enablerepo=remi-php74 install -y php-curl
						fi
						error_code=$?
						if [ ${error_code} != 0 ]
						then
							echo "php-curl installation failed with error code ${error_code} (php-curl installation failed with error code 22)"
							return 22
						fi
					fi
				fi
			fi
			
			echo "Checking PHP pgsql extension..."
			php -m | grep pgsql
			if [ "$?" -gt 0 ]; then
				echo "Installing php-pgsql..."
				if ([ "$pkg_name" = "apt-get" ])
				then
					apt install libpq5
					apt install -y php7.4-pgsql --allow-unauthenticated
					error_code=$?
					if [ ${error_code} != 0 ]
					then
						echo "php7.4-pgsql installation failed with error code ${error_code} (php7.4-pgsql installation failed with error code 6)"
						return 6
					fi
				else 
					if ([ "$pkg_name" = "yum" ])
					then
						if ([ "$OS_REQUIREMENT" = "CentOS" ] && [ "$OS_VERSION" = "8" ])
						then
							dnf -y install php-pgsql
						else
							yum --enablerepo=remi-php74 install -y php-pgsql
						fi
						error_code=$?
						if [ ${error_code} != 0 ]
						then
							echo "php-pgsql installation failed with error code ${error_code} (php-pgsql installation failed with error code 23)"
							return 23
						fi
					fi
				fi
			fi
			
			echo "Checking PHP mbstring extension..."
			php -m | grep mbstring
			if [ "$?" -gt 0 ]; then
				echo "Installing php-mbstring..."
				if ([ "$pkg_name" = "apt-get" ])
				then
					apt install -y php7.4-mbstring --allow-unauthenticated
					error_code=$?
					if [ ${error_code} != 0 ]
					then
						echo "php7.4-mbstring installation failed with error code ${error_code} (php7.4-mbstring installation failed with error code 7)"
						return 7
					fi
				else 
					if ([ "$pkg_name" = "yum" ])
					then
						if ([ "$OS_REQUIREMENT" = "CentOS" ] && [ "$OS_VERSION" = "8" ])
						then
							dnf -y install php-mbstring
						else
							yum --enablerepo=remi-php74 install -y php-mbstring
						fi
						error_code=$?
						if [ ${error_code} != 0 ]
						then
							echo "php-mbstring installation failed with error code ${error_code} (php-mbstring installation failed with error code 24)"
							return 24
						fi
					fi
				fi
			fi
			
			echo "Checking PHP ldap extension..."
			php -m | grep ldap
			if [ "$?" -gt 0 ]; then
				echo "Installing php-ldap..."
				if ([ "$pkg_name" = "apt-get" ])
				then
					apt install -y php7.4-ldap --allow-unauthenticated
					error_code=$?
					if [ ${error_code} != 0 ]
					then
						echo "php7.4-ldap installation failed with error code ${error_code} (php7.4-ldap installation failed with error code 8)"
						return 8
					fi
				else 
					if ([ "$pkg_name" = "yum" ])
					then
						if ([ "$OS_REQUIREMENT" = "CentOS" ] && [ "$OS_VERSION" = "8" ])
						then
							dnf -y install php-ldap
						else
							yum --enablerepo=remi-php74 install -y php-ldap
						fi
						error_code=$?
						if [ ${error_code} != 0 ]
						then
							echo "php-ldap installation failed with error code ${error_code} (php-ldap installation failed with error code 25)"
							return 25
						fi
					fi
				fi
			fi
			
			echo "Checking PHP imagick extension..."
			php -m | grep imagick
			if [ "$?" -gt 0 ]; then
				echo "Installing php-imagick..."
				if ([ "$pkg_name" = "apt-get" ])
				then
					apt install -y gcc
					error_code=$?
					if [ ${error_code} != 0 ]
					then
						echo "gcc installation failed with error code ${error_code} (gcc installation failed with error code 9)"
						return 9
					fi
					apt install -y imagemagick
					error_code=$?
					if [ ${error_code} != 0 ]
					then
						echo "imagemagick installation failed with error code ${error_code} (imagemagick installation failed with error code 9)"
						return 9
					fi
					apt install -y php7.4-imagick --allow-unauthenticated
					error_code=$?
					if [ ${error_code} != 0 ]
					then
						echo "php7.4-imagick installation failed with error code ${error_code} (php7.4-imagick installation failed with error code 10)"
						return 10
					fi
				else 
					if ([ "$pkg_name" = "yum" ])
					then
						yum install -y ImageM* netpbm gd gd-* libjpeg libexif gcc coreutils make
						if ([ "$OS_REQUIREMENT" = "CentOS" ] && [ "$OS_VERSION" = "8" ])
						then
							dnf -y install php-pear
							dnf -y install php-gd
						else
							yum --enablerepo=remi-php74 install -y php-pear
							yum --enablerepo=remi-php74 install -y php-gd
						fi
						error_code=$?
						if [ ${error_code} != 0 ]
						then
							echo "Installing php-imagick failed with error code ${error_code} (Installing php-imagick failed with error code 26)"
							return 26
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
				fi
			fi
			
			echo "Checking PHP imap extension..."
			php -m | grep imap
			if [ "$?" -gt 0 ]; then
				echo "Installing php7.4-imap..."
				if ([ "$pkg_name" = "apt-get" ])
				then
					apt install -y php7.4-imap --allow-unauthenticated
					error_code=$?
					if [ ${error_code} != 0 ]
					then
						echo "php7.4-imap installation failed with error code ${error_code} (php7.4-imap installation failed with error code 11)"
						return 11
					fi
				else
					if ([ "$pkg_name" = "yum" ])
					then
						if ([ "$OS_REQUIREMENT" = "CentOS" ] && [ "$OS_VERSION" = "8" ])
						then
							dnf -y install php-imap
						else
							yum --enablerepo=remi-php74 install -y php-imap
						fi
						error_code=$?
						if [ ${error_code} != 0 ]
						then
							echo "php-imap installation failed with error code ${error_code} (php-imap installation failed with error code 26)"
							return 26
						fi
					fi
				fi
			fi
			
			echo "Checking xml..."
			php -m | grep xml
			if [ "$?" -gt 0 ]; then
				echo "Installing xml..."
				if ([ "$pkg_name" = "apt-get" ])
				then
					apt install php7.4-xml --allow-unauthenticated
					error_code=$?
					if [ ${error_code} != 0 ]
					then
						echo "xml installation failed with error code ${error_code} (xml installation failed with error code 56)"
						return 56
					fi
				else
					if ([ "$pkg_name" = "yum" ])
					then
						if ([ "$OS_REQUIREMENT" = "CentOS" ] && [ "$OS_VERSION" = "8" ])
						then
							dnf -y install php-xml
						else
							yum --enablerepo=remi-php74 install -y php-xml
						fi
						error_code=$?
						if [ ${error_code} != 0 ]
						then
							echo "xml installation failed with error code ${error_code} (xml installation failed with error code 57)"
							return 57
						fi
					fi
				fi
			fi
		}
		set_timezone()
		{
			if ([ "$OS_REQUIREMENT" = "Ubuntu" ] || [ "$OS_REQUIREMENT" = "Debian" ] || [ "$OS_REQUIREMENT" = "LinuxMint" ] || [ "$OS_REQUIREMENT" = "Raspbian" ])
			then
				timezone=$(cat /etc/timezone)
				sed -i -e 's/date.timezone/;date.timezone/g' /etc/php/7.4/fpm/php.ini
				echo "date.timezone = $timezone" >> /etc/php/7.4/fpm/php.ini
			else 
				PHP_VERSION=$(php -v | grep "PHP 5" | sed 's/.*PHP \([^-]*\).*/\1/' | cut -c 1-3)
				echo "Installed PHP version: '$PHP_VERSION'"
				timezone=$(cat /etc/sysconfig/clock | grep ZONE | cut -d"\"" -f2)
				sed -i -e 's/date.timezone/;date.timezone/g' /etc/php.ini
				echo "date.timezone = $timezone" >> /etc/php.ini
			fi
		}
		install_postgresql()
		{
			if ([ "$OS_REQUIREMENT" = "Ubuntu" ] || [ "$OS_REQUIREMENT" = "Debian" ] || [ "$OS_REQUIREMENT" = "LinuxMint" ] || [ "$OS_REQUIREMENT" = "Raspbian" ])
			then
				id -a postgres
				error_code=$?
				if [ ${error_code} != 0 ]; then
					echo "PostgreSQL not installed!"
					set +x
					echo "Do you want to install PostgreSQL (y/n)?"
					read -r answer
					set -x
					case "${answer}" in
						[Yy])
						echo "Installing PostgreSQL..."
						sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
						apt install wget ca-certificates
						error_code=$?
						if [ ${error_code} != 0 ]
						then
							echo "ca-certificates installation failed with error code ${error_code} (ca-certificates installation failed with error code 12)"
						fi
						wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc
						apt-key add ACCC4CF8.asc
						apt update
						apt install -y postgresql --allow-unauthenticated
						error_code=$?
						if [ ${error_code} != 0 ]
						then
							echo "postgresql installation failed with error code ${error_code} (postgresql installation failed with error code 13)"
							return 13
						fi
					esac
				else
					PSQL_VERSION=$(psql --version | egrep -o '[0-9]{1,}\.[0-9]{1,}' | head -1)
					if [[ ${PSQL_VERSION} == "" ]]; then
						PSQL_VERSION=$(psql --version | egrep -o '[0-9]{1,}\.[0-9]{1,}')
					fi
					if [[ ${PSQL_VERSION} =~ ^10\.[0-9]{1,}$ ]]; then
						PSQL_VERSION=10
					fi
					if [[ ${PSQL_VERSION} =~ ^11\.[0-9]{1,}$ ]]; then
						PSQL_VERSION=11
					fi
					if [[ ${PSQL_VERSION} =~ ^12\.[0-9]{1,}$ ]]; then
						PSQL_VERSION=12
					fi
					if [[ 1 -eq "$(echo "${PSQL_VERSION} < 9.3" | bc)" ]]; then
						set +x
						echo "Restyaboard will not work in your PostgreSQL version (i.e. less than 9.3). So script going to update PostgreSQL version 9.6"
						sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
						apt install wget ca-certificates
						error_code=$?
						if [ ${error_code} != 0 ]
						then
							echo "ca-certificates installation failed with error code ${error_code} (ca-certificates installation failed with error code 12)"
						fi
						wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc
						apt-key add ACCC4CF8.asc
						apt update
						apt upgrade
						apt install -y postgresql --allow-unauthenticated
						error_code=$?
						if [ ${error_code} != 0 ]
						then
							echo "postgresql installation failed with error code ${error_code} (postgresql installation failed with error code 13)"
							return 13
						fi
					fi
				fi
				PSQL_VERSION=$(psql --version | egrep -o '[0-9]{1,}\.[0-9]{1,}' | head -1)
				if [[ ${PSQL_VERSION} == "" ]]; then
					PSQL_VERSION=$(psql --version | egrep -o '[0-9]{1,}\.[0-9]{1,}')
				fi
				if [[ ${PSQL_VERSION} =~ ^10\.[0-9]{1,}$ ]]; then
					PSQL_VERSION=10
				fi
				if [[ ${PSQL_VERSION} =~ ^11\.[0-9]{1,}$ ]]; then
					PSQL_VERSION=11
				fi
				if [[ ${PSQL_VERSION} =~ ^12\.[0-9]{1,}$ ]]; then
					PSQL_VERSION=12
				fi
				sed -e 's/peer/trust/g' -e 's/ident/trust/g' < /etc/postgresql/${PSQL_VERSION}/main/pg_hba.conf > /etc/postgresql/${PSQL_VERSION}/main/pg_hba.conf.1
				cd /etc/postgresql/${PSQL_VERSION}/main || exit
				mv pg_hba.conf pg_hba.conf_old
				mv pg_hba.conf.1 pg_hba.conf
				service postgresql restart
			else
				if ! which psql > /dev/null 2>&1;
				then
					echo "PostgreSQL not installed!"
					set +x
					echo "Do you want to install PostgreSQL (y/n)?"
					read -r answer
					set -x
					case "${answer}" in
						[Yy])
						echo "Installing PostgreSQL..."
						if [ $(getconf LONG_BIT) = "64" ]; then
							if [[ $OS_REQUIREMENT = "Fedora" ]]; then
								dnf install -y "https://download.postgresql.org/pub/repos/yum/reporpms/F-${OS_VERSION}-x86_64/pgdg-fedora-repo-latest.noarch.rpm"
							else
								if ([ "$OS_REQUIREMENT" = "CentOS" ] && [ "$OS_VERSION" != "8" ])
								then
									yum install -y "https://download.postgresql.org/pub/repos/yum/reporpms/EL-${OS_VERSION}-x86_64/pgdg-redhat-repo-latest.noarch.rpm"
								fi
							fi
						fi
						if ([ "$OS_REQUIREMENT" = "CentOS" ] && [ "$OS_VERSION" = "8" ])
						then
							dnf module enable postgresql:13
							dnf -y install postgresql-server postgresql-contrib postgresql-libs
						else
							yum install -y postgresql13 postgresql13-server postgresql13-contrib postgresql13-libs	
						fi
						error_code=$?
						if [ ${error_code} != 0 ]
						then
							echo "postgresql13 installation failed with error code ${error_code} (postgresql13 installation failed with error code 29)"
							return 29
						fi
					esac
				else 
					PSQL_VERSION=$(psql --version | egrep -o '[0-9]{1,}\.[0-9]{1,}')
					if [[ $PSQL_VERSION < 9.3 ]]; then
						set +x
						echo "Restyaboard will not work in your PostgreSQL version (i.e. less than 9.3). So script going to update PostgreSQL version 9.6"
						if [ $(getconf LONG_BIT) = "64" ]; then
							if [[ $OS_REQUIREMENT = "Fedora" ]]; then
								dnf install -y "https://download.postgresql.org/pub/repos/yum/reporpms/F-${OS_VERSION}-x86_64/pgdg-fedora-repo-latest.noarch.rpm"
							else
								if ([ "$OS_REQUIREMENT" = "CentOS" ] && [ "$OS_VERSION" != "8" ])
								then
									yum install -y "https://download.postgresql.org/pub/repos/yum/reporpms/EL-${OS_VERSION}-x86_64/pgdg-redhat-repo-latest.noarch.rpm"
								fi
							fi
						fi
						if ([ "$OS_REQUIREMENT" = "CentOS" ] && [ "$OS_VERSION" = "8" ])
						then
							dnf module enable postgresql:13
							dnf -y install postgresql-server postgresql-contrib postgresql-libs
						else
							yum install -y postgresql13 postgresql13-server postgresql13-contrib postgresql13-libs
						fi
						error_code=$?
						if [ ${error_code} != 0 ]
						then
							echo "postgresql installation failed with error code ${error_code} (postgresql installation failed with error code 29)"
							return 29
						fi
					fi
				fi
				PSQL_VERSION=$(psql --version | egrep -o '[0-9]{1,}\.[0-9]{1,}')
				if [[ ${PSQL_VERSION} =~ ^13\.[0-9]{1,}$ ]]; then
					PSQL_VERSION=13
				fi
				PSQL_FOLDER=$(echo ${PSQL_VERSION} | sed 's/\.//')
				if ([ "$OS_REQUIREMENT" = "CentOS" ] && [ "$OS_VERSION" = "8" ])
				then
					postgresql-setup --initdb
				else
					"/usr/pgsql-${PSQL_VERSION}/bin/postgresql-${PSQL_VERSION}-setup" initdb
				fi
				if ([ "$OS_REQUIREMENT" = "CentOS" ] && [ "$OS_VERSION" = "8" ])
				then
					systemctl enable postgresql
					systemctl start postgresql
				else
					if [ -f "/bin/systemctl" ]; then
						systemctl start "postgresql-${PSQL_VERSION}.service"
						systemctl enable "postgresql-${PSQL_VERSION}.service"
					else
						"/etc/init.d/postgresql-${PSQL_VERSION}" start
						chkconfig --levels 35 "postgresql-${PSQL_VERSION}" on
					fi
				fi
				if ([ "$OS_REQUIREMENT" = "CentOS" ] && [ "$OS_VERSION" = "8" ])
				then
					sed -e 's/peer/trust/g' -e 's/ident/trust/g' < "/var/lib/pgsql/data/pg_hba.conf" > "/var/lib/pgsql/data/pg_hba.conf.1"
					cd "/var/lib/pgsql/data" || exit
				else
					sed -e 's/peer/trust/g' -e 's/ident/trust/g' < "/var/lib/pgsql/${PSQL_VERSION}/data/pg_hba.conf" > "/var/lib/pgsql/${PSQL_VERSION}/data/pg_hba.conf.1"
					cd "/var/lib/pgsql/${PSQL_VERSION}/data" || exit
				fi
				mv pg_hba.conf pg_hba.conf_old
				mv pg_hba.conf.1 pg_hba.conf
				if ([ "$OS_REQUIREMENT" = "CentOS" ] && [ "$OS_VERSION" = "8" ])
				then
					systemctl restart postgresql
				else
					if [ -f "/bin/systemctl" ]; then
						systemctl restart "postgresql-${PSQL_VERSION}.service"
					else
						"/etc/init.d/postgresql-${PSQL_VERSION}" restart
					fi
				fi
			fi
		}
		install_geoip()
		{
			if ([ "$OS_REQUIREMENT" = "Ubuntu" ] || [ "$OS_REQUIREMENT" = "Debian" ] || [ "$OS_REQUIREMENT" = "LinuxMint" ] || [ "$OS_REQUIREMENT" = "Raspbian" ])
			then
				if ! hash GeoIP-devel 2>&-;
				then
					apt install -y php7.4-geoip php7.4-dev libgeoip-dev
					error_code=$?
					if [ ${error_code} != 0 ]
					then
						echo "php7.4-geoip php7.4-dev libgeoip-dev installation failed with error code ${error_code} (php7.4-geoip php7.4-dev libgeoip-dev installation failed with error code 50)"
					fi
				fi

				if ! hash pecl/geoip 2>&-;
				then
					pecl install geoip
					error_code=$?
					if [ ${error_code} != 0 ]
					then
						echo "pecl geoip installation failed with error code ${error_code} (pecl geoip installation failed with error code 47)"
					fi
				fi

				echo "extension=geoip.so" >> /etc/php.ini

				mkdir -v /usr/share/GeoIP
				error_code=$?
				if [ ${error_code} != 0 ]
				then
					echo "GeoIP folder creation failed with error code ${error_code} (GeoIP folder creation failed with error code 52)"
				fi
				get_geoip_data
			else
				if ! hash pecl/geoip 2>&-;
				then
					pecl install geoip
					error_code=$?
					if [ ${error_code} != 0 ]
					then
						echo "pecl geoip installation failed with error code ${error_code} (pecl geoip installation failed with error code 47)"
						return 47
					fi
				fi
			fi
		}
		configure_restyaboard()
		{
			if ([ "$OS_REQUIREMENT" = "Ubuntu" ] || [ "$OS_REQUIREMENT" = "Debian" ] || [ "$OS_REQUIREMENT" = "LinuxMint" ] || [ "$OS_REQUIREMENT" = "Raspbian" ])
			then
				set +x
				if [ ${APACHE_ENABLED} -eq 1 ] 
				then
					set +x
					echo "To configure apache, enter your domain name (e.g., www.example.com, 192.xxx.xxx.xxx, etc.,):"
					read -r webdir
					while [[ -z "$webdir" ]]
					do
						read -r -p "To configure apache, enter your domain name (e.g., www.example.com, 192.xxx.xxx.xxx, etc.,):" webdir
					done
					set -x
					echo "$webdir"
					curl -v -L -G -o ${DOWNLOAD_DIR}/.htaccess https://raw.githubusercontent.com/RestyaPlatform/board/master/.htaccess
					set +x
					echo "Enter your document root (where your Restyaboard to be installed. e.g., /var/www/html/restyaboard):"
					read -r dir
					while [[ -z "$dir" ]]
					do
						read -r -p "Enter your document root (where your Restyaboard to be installed. e.g., /var/www/html/restyaboard):" dir
					done
					set -x
					echo "$dir"
					mkdir -p "$dir"
					echo "Changing root directory in apache configuration..."
					cp ${DOWNLOAD_DIR}/.htaccess $dir
					set -x
					echo "<VirtualHost *:80>
						ServerName $webdir
						ServerAlias $webdir
						DocumentRoot $dir
					</VirtualHost> 

					<Directory $dir>
						Options Indexes FollowSymLinks
						AllowOverride All
						Require all granted
					</Directory>" >> /etc/apache2/sites-available/restyaboard.conf
					set -x
					echo "127.0.0.1  $webdir" >> /etc/hosts
					rm -rf ${DOWNLOAD_DIR}/.htaccess
				else
				    echo "To configure nginx, enter your domain name (e.g., www.example.com, 192.xxx.xxx.xxx, etc.,):"
					read -r webdir
					while [[ -z "$webdir" ]]
					do
						read -r -p "To configure nginx, enter your domain name (e.g., www.example.com, 192.xxx.xxx.xxx, etc.,):" webdir
					done
					set -x
					echo "$webdir"
					set -x
					cp ${DOWNLOAD_DIR}/restyaboard.conf /etc/nginx/conf.d
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
				fi
			else
				if [ ${APACHE_ENABLED} -eq 1 ]
				then
					set +x
					echo "To configure apache, enter your domain name (e.g., www.example.com, 192.xxx.xxx.xxx, etc.,):"
					read -r webdir
					while [[ -z "$webdir" ]]
					do
						read -r -p "To configure apache, enter your domain name (e.g., www.example.com, 192.xxx.xxx.xxx, etc.,):" webdir
					done
                    set -x
				    echo "$webdir"
                    curl -v -L -G -o ${DOWNLOAD_DIR}/.htaccess https://raw.githubusercontent.com/RestyaPlatform/board/master/.htaccess
					set +x
					echo "Enter your document root (where your Restyaboard to be installed. e.g., /var/www/html/restyaboard):"
					read -r dir
					while [[ -z "$dir" ]]
					do
						read -r -p "Enter your document root (where your Restyaboard to be installed. e.g., /var/www/html/restyaboard):" dir
					done
					set -x
					echo "$dir"
					mkdir -p "$dir"
					echo "Changing root directory in apache configuration..."
					cp ${DOWNLOAD_DIR}/.htaccess $dir
					set -x
					echo "<VirtualHost *:80>
						ServerName $webdir
						ServerAlias $webdir
						DocumentRoot $dir
					</VirtualHost> 

					<Directory $dir>
						Options Indexes FollowSymLinks
						AllowOverride All
						Require all granted
					</Directory>" >> /etc/httpd/sites-available/restyaboard.conf
					set -x
					echo "127.0.0.1  $webdir" >> /etc/hosts
					rm -rf ${DOWNLOAD_DIR}/.htaccess
				else
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
					cp ${DOWNLOAD_DIR}/restyaboard.conf /etc/nginx/conf.d
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
				fi
			fi
		}
		install_postfix()
		{
			if ([ "$OS_REQUIREMENT" = "Ubuntu" ] || [ "$OS_REQUIREMENT" = "Debian" ] || [ "$OS_REQUIREMENT" = "LinuxMint" ] || [ "$OS_REQUIREMENT" = "Raspbian" ])
			then
				echo "Installing postfix..."
				echo "postfix postfix/mailname string $webdir"\
				| debconf-set-selections &&\
				echo "postfix postfix/main_mailer_type string 'Internet Site'"\
				| debconf-set-selections &&\
				apt install -y postfix
				error_code=$?
				if [ ${error_code} != 0 ]
				then
					echo "postfix installation failed with error code ${error_code} (postfix installation failed with error code 16)"
				fi
				PHP_VERSION=$(php --version | head -n 1 | cut -d " " -f 2 | grep --only-matching --perl-regexp "^\\d\.\\d+")
				if [ -f "/etc/php/${PHP_VERSION}/fpm/php.ini" ] 
				then
					sed -i "s/;sendmail_path =/sendmail_path = \"\/usr\/sbin\/sendmail -t -i\"/g" /etc/php/${PHP_VERSION}/fpm/php.ini
				fi
				if [ -f "/etc/php/${PHP_VERSION}/cli/php.ini" ] 
				then
					sed -i "s/;sendmail_path =/sendmail_path = \"\/usr\/sbin\/sendmail -t -i\"/g" /etc/php/${PHP_VERSION}/cli/php.ini
				fi
				if [ -f "/etc/php.ini" ] 
				then
					sed -i "s/;sendmail_path =/sendmail_path = \"\/usr\/sbin\/sendmail -t -i\"/g" /etc/php.ini
				fi
			fi
		}
		change_permission()
		{
			if ([ "$OS_REQUIREMENT" = "CentOS" ])
			then
				chcon -R -t httpd_sys_rw_content_t $dir/media/ $dir/tmp/cache/ $dir/client/img/
				chcon -Rv --type=httpd_t $dir/
			fi
		}
		psql_connect()
		{
			if ([ "$OS_REQUIREMENT" = "Ubuntu" ] || [ "$OS_REQUIREMENT" = "Debian" ] || [ "$OS_REQUIREMENT" = "LinuxMint" ] || [ "$OS_REQUIREMENT" = "Raspbian" ])
			then
				psql -U postgres -c "\q"
				error_code=$?
				if [ ${error_code} != 0 ]
				then
					echo "PostgreSQL Changing the permission failed with error code ${error_code} (PostgreSQL Changing the permission failed with error code 34)"
					return 34
				fi
				sleep 1
				echo "Creating PostgreSQL user and database..."
				psql -U postgres -c "DROP USER IF EXISTS ${POSTGRES_DBUSER};CREATE USER ${POSTGRES_DBUSER} WITH ENCRYPTED PASSWORD '${POSTGRES_DBPASS}'"
				error_code=$?
				if [ ${error_code} != 0 ]
				then
					echo "PostgreSQL user creation failed with error code ${error_code} (PostgreSQL user creation failed with error code 35)"
					return 35
				fi
				psql -U postgres -c "CREATE DATABASE ${POSTGRES_DBNAME} OWNER ${POSTGRES_DBUSER} ENCODING 'UTF8' TEMPLATE template0"
				error_code=$?
				if [ ${error_code} != 0 ]
				then
					echo "PostgreSQL database creation failed with error code ${error_code} (PostgreSQL database creation failed with error code 36)"
					return 36
				fi
				psql -U postgres -c "CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;"
				error_code=$?
				if [ ${error_code} != 0 ]
				then
					echo "PostgreSQL extension creation failed with error code ${error_code} (PostgreSQL extension creation failed with error code 37)"
					return 37
				fi
				psql -U postgres -c "COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';"
				error_code=$?
				if [ ${error_code} = 0 ];
				then
					echo "Importing empty SQL..."
					psql -d ${POSTGRES_DBNAME} -f "$dir/sql/restyaboard_with_empty_data.sql" -U ${POSTGRES_DBUSER}
					if [ ${error_code} != 0 ]
					then
						echo "PostgreSQL Empty SQL importing failed with error code ${error_code} (PostgreSQL Empty SQL importing failed with error code 39)"
						return 39
					fi
				fi
			else
				psql -U postgres -c "\q"
				error_code=$?
				if [ ${error_code} != 0 ]
				then
					echo "PostgreSQL Changing the permission failed with error code ${error_code} (PostgreSQL Changing the permission failed with error code 40)"
					return 40
				fi			
				sleep 1
				echo "Creating PostgreSQL user and database..."
				psql -U postgres -c "DROP USER IF EXISTS ${POSTGRES_DBUSER};CREATE USER ${POSTGRES_DBUSER} WITH ENCRYPTED PASSWORD '${POSTGRES_DBPASS}'"
				error_code=$?
				if [ ${error_code} != 0 ]
				then
					echo "PostgreSQL user creation failed with error code ${error_code} (PostgreSQL user creation failed with error code 41)"
					return 41
				fi			
				psql -U postgres -c "CREATE DATABASE ${POSTGRES_DBNAME} OWNER ${POSTGRES_DBUSER} ENCODING 'UTF8' TEMPLATE template0"
				error_code=$?
				if [ ${error_code} != 0 ]
				then
					echo "PostgreSQL database creation failed with error code ${error_code} (PostgreSQL database creation failed with error code 42)"
					return 42
				fi			
				psql -U postgres -c "CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;"
				error_code=$?
				if [ ${error_code} != 0 ]
				then
					echo "PostgreSQL extension creation failed with error code ${error_code} (PostgreSQL extension creation failed with error code 43)"
					return 43
				fi			
				psql -U postgres -c "COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';"
				if [ "$?" = 0 ];
				then
					echo "Importing empty SQL..."
					psql -d ${POSTGRES_DBNAME} -f "$dir/sql/restyaboard_with_empty_data.sql" -U ${POSTGRES_DBUSER}
					error_code=$?
					if [ ${error_code} != 0 ]
					then
						echo "PostgreSQL Empty SQL importing failed with error code ${error_code} (PostgreSQL Empty SQL importing failed with error code 45)"
						return 45
					fi	
				fi
				if ([ "$OS_REQUIREMENT" = "CentOS" ])
				then
					setsebool -P allow_postfix_local_write_mail_spool 1
				fi
			fi
		}
		php_fpm_reset()
		{
			if ([ "$OS_REQUIREMENT" = "Ubuntu" ] || [ "$OS_REQUIREMENT" = "Debian" ] || [ "$OS_REQUIREMENT" = "LinuxMint" ] || [ "$OS_REQUIREMENT" = "Raspbian" ])
			then
				echo "........."
			else
				echo "Reset php-fpm (use unix socket mode)..."
				if [ -f "/run/php/php7.4-fpm.sock" ]; then
					sed -i "s/listen = 127.0.0.1:9000/listen = \/run\/php\/php7.4-fpm.sock/g" /etc/php-fpm.d/www.conf
				elif [ -f "/run/php-fpm/www.sock" ]; then
					sed -i "s/listen = 127.0.0.1:9000/listen = \/run\/php-fpm\/www.sock/g" /etc/php-fpm.d/www.conf
					sed -i "s/unix:\/run\/php\/php7.4-fpm.sock/unix:\/run\/php-fpm\/www.sock/g" /etc/nginx/conf.d/restyaboard.conf
				else
					sed -i "s/unix:\/run\/php\/php7.4-fpm.sock/127.0.0.1:9000/g" /etc/nginx/conf.d/restyaboard.conf
				fi
			fi
		}
		install_jq()
		{
			if ([ "$OS_REQUIREMENT" = "Ubuntu" ] || [ "$OS_REQUIREMENT" = "Debian" ] || [ "$OS_REQUIREMENT" = "LinuxMint" ] || [ "$OS_REQUIREMENT" = "Raspbian" ])
			then
				apt install -y jq
				error_code=$?
				if [ ${error_code} != 0 ]
				then
					echo "jq installation failed with error code ${error_code} (jq installation failed with error code 53)"
				fi
			else
				yum install -y jq
				error_code
				if [ ${error_code} != 0 ]
				then
					echo "jq installation failed with error code ${error_code} (jq installation failed with error code 49)"
					return 49
				fi
			fi
		}
		set_db_connection()
		{	
			if ([ "$OS_REQUIREMENT" = "Ubuntu" ] || [ "$OS_REQUIREMENT" = "Debian" ] || [ "$OS_REQUIREMENT" = "LinuxMint" ] || [ "$OS_REQUIREMENT" = "Raspbian" ])
			then
				echo "Starting services..."
				service cron restart
				service php7.4-fpm restart
				if [ ${APACHE_ENABLED} -eq 1 ] 
				then
					a2ensite restyaboard.conf
					a2enmod rewrite
				    service apache2 restart
				else
					service nginx restart
				fi
				service postfix restart
				apt install -y python-pip
				pip install virtualenv
			else
				if [ -f "/bin/systemctl" ]; then
					echo "Starting services with systemd..."
					if [ ${APACHE_ENABLED} -eq 1 ] 
					then
						a2ensite restyaboard.conf
						a2enmod rewrite
						systemctl restart httpd.service
					else
						systemctl restart nginx
					fi
					systemctl restart php-fpm
				else
					echo "Starting services..."
					/etc/init.d/php-fpm restart
					if [ ${APACHE_ENABLED} -eq 1 ] 
					then
						/etc/init.d/httpd restart
					else
						/etc/init.d/nginx restart
					fi
				fi
				yum install -y python-pip
				pip install virtualenv
				if ([ "$OS_REQUIREMENT" = "CentOS" ])
				then
					setsebool -P httpd_can_network_connect_db=1
				fi
			fi
		}
		ssl_connectivity()
		{
			if [[ $webdir =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
				echo "SSL connectivity cannot be set for IP address"
			else
				set +x
				echo "Do you want to set up SSL connectivity for your domain and your domain should be  publicly accessible Restyaboard instance and your domain should be mappped to this Restyaboard Server, Note: If you're trying to set SSL  for Non-publicly accessible instance, then your Restyaboard will not work (y/n)?"
				read -r answer
				set -x
				case "${answer}" in
					[Yy])
					if ([ "$OS_REQUIREMENT" = "Ubuntu" ] || [ "$OS_REQUIREMENT" = "Debian" ] || [ "$OS_REQUIREMENT" = "LinuxMint" ] || [ "$OS_REQUIREMENT" = "Raspbian" ])
					then
						apt install certbot python3-certbot-nginx -y
						service nginx restart
						service php7.4-fpm restart
						certbot --nginx
					else
						if ([ "$OS_REQUIREMENT" = "CentOS" ] && [ "$OS_VERSION" = "8" ])
						then
							dnf -y install epel-release
							dnf -y install certbot python3-certbot-nginx
							certbot --nginx
						else
							yum install -y epel-release
							yum install certbot-nginx
							certbot --nginx
						fi
						error_code=$?
						if [ ${error_code} != 0 ]
						then
							echo "SSL installation failed with error code ${error_code} (php installation failed with error code 20)"
							return 20
						fi
						if [ -f "/bin/systemctl" ]; then
							echo "Starting services with systemd..."
							systemctl restart nginx
							systemctl restart php-fpm
						else
							echo "Starting services..."
							/etc/init.d/php-fpm restart
							/etc/init.d/nginx restart
						fi
					fi
				esac
			fi
		}
		find_release
		checkdeps
		if ([ "$pkg_name" = "apt-get" ])
        then
			apt update
			apt install -y curl unzip
		else
			if ([ "$pkg_name" = "yum" ])
        	then
				yum install -y curl unzip
			fi
		fi
		RESTYABOARD_VERSION=$(curl --silent https://api.github.com/repos/RestyaPlatform/board/releases | grep tag_name -m 1 | awk '{print $2}' | sed -e 's/[^v0-9.]//g')
		POSTGRES_DBHOST=localhost
		POSTGRES_DBNAME=restyaboard
		POSTGRES_DBUSER=restya
		POSTGRES_DBPASS=hjVl2!rGd
		POSTGRES_DBPORT=5432
		DOWNLOAD_DIR=/opt/restyaboard
		
		get_geoip_data () 
		{
			wget https://mirrors-cdn.liferay.com/geolite.maxmind.com/download/geoip/database/GeoIP.dat.gz
			gunzip GeoIP.dat.gz
			mv GeoIP.dat /usr/share/GeoIP/GeoIP.dat
			wget https://mirrors-cdn.liferay.com/geolite.maxmind.com/download/geoip/database/GeoIPv6.dat.gz
			gunzip GeoIPv6.dat.gz
			mv GeoIPv6.dat /usr/share/GeoIP/GeoIPv6.dat
			wget https://mirrors-cdn.liferay.com/geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.xz
			unxz GeoLiteCity.dat.xz
			mv GeoLiteCity.dat /usr/share/GeoIP/GeoIPCity.dat
			wget https://mirrors-cdn.liferay.com/geolite.maxmind.com/download/geoip/database/GeoLiteCityv6.dat.gz
			gunzip GeoLiteCityv6.dat.gz
			mv GeoLiteCityv6.dat /usr/share/GeoIP/GeoLiteCityv6.dat
			wget https://mirrors-cdn.liferay.com/geolite.maxmind.com/download/geoip/database/GeoIPASNum.dat.gz
			gunzip GeoIPASNum.dat.gz
			mv GeoIPASNum.dat /usr/share/GeoIP/GeoIPASNum.dat
			wget https://mirrors-cdn.liferay.com/geolite.maxmind.com/download/geoip/database/GeoIPASNumv6.dat.gz
			gunzip GeoIPASNumv6.dat.gz
			mv GeoIPASNumv6.dat /usr/share/GeoIP/GeoIPASNumv6.dat
		}

		upgrade-0.3-0.4()
		{
			sed -i "s/*\/5 * * * * $dir\/server\/php\/shell\/chat_activities.sh//" /var/spool/cron/crontabs/root
			sed -i "s/0 * * * * $dir\/server\/php\/shell\/periodic_chat_email_notification.sh//" /var/spool/cron/crontabs/root
			sed -i "s/*\/5 * * * * $dir\/server\/php\/shell\/indexing_to_elasticsearch.sh//" /var/spool/cron/crontabs/root

			rm $dir/server/php/shell/chat_activities.sh
			rm $dir/server/php/shell/chat_activities.php
			rm $dir/server/php/shell/indexing_to_elasticsearch.sh
			rm $dir/server/php/shell/indexing_to_elasticsearch.php
			rm $dir/server/php/shell/periodic_chat_email_notification.sh
			rm $dir/server/php/shell/periodic_chat_email_notification.php
			rm $dir/server/php/shell/upgrade_v0.2.1_v0.3.php

			rm -rf $dir/client/apps/

			rm -rf $dir/server/php/libs/vendors/xmpp/
			rm -rf $dir/server/php/libs/vendors/jaxl3/
			rm -rf $dir/server/php/libs/vendors/xmpp-prebind-php/
		}

		upgrade-0.4-0.4.1()
		{
			sed -i "s/*\/5 * * * * $dir\/server\/php\/shell\/chat_activities.sh//" /var/spool/cron/crontabs/root
			sed -i "s/0 * * * * $dir\/server\/php\/shell\/periodic_chat_email_notification.sh//" /var/spool/cron/crontabs/root
			sed -i "s/*\/5 * * * * $dir\/server\/php\/shell\/indexing_to_elasticsearch.sh//" /var/spool/cron/crontabs/root

			rm $dir/server/php/shell/chat_activities.sh
			rm $dir/server/php/shell/chat_activities.php
			rm $dir/server/php/shell/indexing_to_elasticsearch.sh
			rm $dir/server/php/shell/indexing_to_elasticsearch.php
			rm $dir/server/php/shell/periodic_chat_email_notification.sh
			rm $dir/server/php/shell/periodic_chat_email_notification.php
			rm $dir/server/php/shell/upgrade_v0.2.1_v0.3.php

			rm -rf $dir/client/apps/

			rm -rf $dir/server/php/libs/vendors/xmpp/
			rm -rf $dir/server/php/libs/vendors/jaxl3/
			rm -rf $dir/server/php/libs/vendors/xmpp-prebind-php/
		}

		upgrade-0.5.2-0.6()
		{
			sed -i "s/rewrite ^\/ical\/.*/rewrite ^\/ical\/([0-9]*)\/([0-9]*)\/([a-z0-9]*).ics\$ \/server\/php\/ical.php?board_id=\$1\&user_id=\$2\&hash=\$3 last;/" /etc/nginx/conf.d/restyaboard.conf
		}

		upgrade-0.6.3-0.6.4()
		{
			if [ -d "$dir/client/apps/r_hide_card_created_date" ]; then
				rm -rf $dir/client/apps/r_hide_card_created_date/
				chmod -R go+w "$dir/client/apps"
				curl -v -L -G -o /tmp/r_hide_card_additional_informations-v0.1.1.zip https://github.com/RestyaPlatform/board-apps/releases/download/v1/r_hide_card_additional_informations-v0.1.1.zip
				unzip /tmp/r_hide_card_additional_informations-v0.1.1.zip -d "$dir/client/apps"
			fi
		}

		upgrade-0.6.4-0.6.5()
		{
			if [ -d "$dir/client/apps/r_hide_card_id" ]; then
				rm -rf $dir/client/apps/r_hide_card_id/
				chmod -R go+w "$dir/client/apps"
				curl -v -L -G -o /tmp/r_hide_card_additional_informations-v0.1.2.zip https://github.com/RestyaPlatform/board-apps/releases/download/v1/r_hide_card_additional_informations-v0.1.2.zip
				unzip /tmp/r_hide_card_additional_informations-v0.1.2.zip -d "$dir/client/apps"
			fi
		}

		upgrade-0.6.5-0.6.6()
		{
			if [ -d "$dir/client/apps" ]; then
				chmod -R go+w "$dir/client/apps"
				curl -v -L -G -o /tmp/r_codenames-v0.1.1.zip https://github.com/RestyaPlatform/board-apps/releases/download/v1/r_codenames-v0.1.1.zip
				unzip /tmp/r_codenames-v0.1.1.zip -d "$dir/client/apps"
			else 
				mkdir "$dir/client/apps"
				chmod -R go+w "$dir/client/apps"
				curl -v -L -G -o /tmp/r_codenames-v0.1.1.zip https://github.com/RestyaPlatform/board-apps/releases/download/v1/r_codenames-v0.1.1.zip
				unzip /tmp/r_codenames-v0.1.1.zip -d "$dir/client/apps"
			fi
		}
		
		upgrade-0.6.6-0.6.7(){
			if [ -d "$dir/client/apps" ]; then
				chmod -R go+w "$dir/client/apps"
			else 
				mkdir "$dir/client/apps"
				chmod -R go+w "$dir/client/apps"
			fi
			curl -v -L -G -o /tmp/r_card_counter-v0.1.1.zip https://github.com/RestyaPlatform/board-apps/releases/download/v1/r_card_counter-v0.1.1.zip
			unzip /tmp/r_card_counter-v0.1.1.zip -d "$dir/client/apps"

			curl -v -L -G -o /tmp/r_codenames-v0.1.2.zip https://github.com/RestyaPlatform/board-apps/releases/download/v1/r_codenames-v0.1.2.zip
			unzip /tmp/r_codenames-v0.1.2.zip -d "$dir/client/apps"

			curl -v -L -G -o /tmp/r_eu_gdpr-v0.1.2.zip https://github.com/RestyaPlatform/board-apps/releases/download/v1/r_eu_gdpr-v0.1.2.zip
			unzip /tmp/r_eu_gdpr-v0.1.2.zip -d "$dir/client/apps"

			curl -v -L -G -o /tmp/r_gmail_addon-v0.1.1.zip https://github.com/RestyaPlatform/board-apps/releases/download/v1/r_gmail_addon-v0.1.1.zip
			unzip /tmp/r_gmail_addon-v0.1.1.zip -d "$dir/client/apps"			
			
			curl -v -L -G -o /tmp/r_hide_card_additional_informations-v0.1.3.zip https://github.com/RestyaPlatform/board-apps/releases/download/v1/r_hide_card_additional_informations-v0.1.3.zip
			unzip /tmp/r_hide_card_additional_informations-v0.1.3.zip -d "$dir/client/apps"

            find "$dir/client/apps" -type d -exec chmod 755 {} \;
            find "$dir/client/apps" -type f -exec chmod 644 {} \;
            chmod 0777 $dir/client/apps/**/*.json

			if ([ "$OS_REQUIREMENT" = "Ubuntu" ] || [ "$OS_REQUIREMENT" = "Debian" ] || [ "$OS_REQUIREMENT" = "LinuxMint" ] || [ "$OS_REQUIREMENT" = "Raspbian" ])
			then
				: > /var/spool/cron/crontabs/root
				echo "*/5 * * * * $dir/server/php/shell/main.sh > /dev/null 2> /dev/null" >> /var/spool/cron/crontabs/root
			else
				: > /var/spool/cron/root
				echo "*/5 * * * * $dir/server/php/shell/main.sh > /dev/null 2> /dev/null" >> /var/spool/cron/root
			fi
		}

		upgrade-0.6.7-0.6.8(){
			if [ -d "$dir/client/apps" ]; then
				chmod -R go+w "$dir/client/apps"
			else 
				mkdir "$dir/client/apps"
				chmod -R go+w "$dir/client/apps"
			fi
			curl -v -L -G -o /tmp/r_codenames-v0.1.3.zip  https://github.com/RestyaPlatform/board-apps/releases/download/v1/r_codenames-v0.1.3.zip
			unzip /tmp/r_codenames-v0.1.3.zip -d "$dir/client/apps"

            find "$dir/client/apps" -type d -exec chmod 755 {} \;
            find "$dir/client/apps" -type f -exec chmod 644 {} \;
            chmod 0777 $dir/client/apps/**/*.json
		}

		upgrade-0.6.8-0.6.9(){
			if [ -d "$dir/client/apps" ]; then
				chmod -R go+w "$dir/client/apps"
			else 
				mkdir "$dir/client/apps"
				chmod -R go+w "$dir/client/apps"
			fi
			curl -v -L -G -o /tmp/r_codenames-v0.1.4.zip  https://github.com/RestyaPlatform/board-apps/releases/download/v1/r_codenames-v0.1.4.zip
			unzip /tmp/r_codenames-v0.1.4.zip -d "$dir/client/apps"

            find "$dir/client/apps" -type d -exec chmod 755 {} \;
            find "$dir/client/apps" -type f -exec chmod 644 {} \;
            chmod 0777 $dir/client/apps/**/*.json
		}
		upgrade-0.6.9-1.7(){
			if [ -d "$dir/client/apps/r_togetherjs" ]; then
				rm -rf $dir/client/apps/r_togetherjs/
			fi
			if [ -d "$dir/client/apps" ]; then
				chmod -R go+w "$dir/client/apps"
			else 
				mkdir "$dir/client/apps"
				chmod -R go+w "$dir/client/apps"
			fi
			curl -v -L -G -o /tmp/r_codenames-v0.1.5.zip  https://github.com/RestyaPlatform/board-apps/releases/download/v1/r_codenames-v0.1.5.zip
			unzip /tmp/r_codenames-v0.1.5.zip -d "$dir/client/apps"
			curl -v -L -G -o /tmp/r_gmail_addon-v0.1.2.zip https://github.com/RestyaPlatform/board-apps/releases/download/v1/r_gmail_addon-v0.1.2.zip
			unzip /tmp/r_gmail_addon-v0.1.2.zip -d "$dir/client/apps"
			
			echo "Applying permission..."
			useradd restyaboard
			usermod --password 'hjVl2!rGd' restyaboard
			PHP_VERSION=$(php --version | head -n 1 | cut -d " " -f 2 | grep --only-matching --perl-regexp "^\\d\.\\d+")
			if ([ "$OS_REQUIREMENT" = "Ubuntu" ] || [ "$OS_REQUIREMENT" = "Debian" ] || [ "$OS_REQUIREMENT" = "LinuxMint" ] || [ "$OS_REQUIREMENT" = "Raspbian" ])
			then
				user www-data;
				usermod -a -G restyaboard www-data
				sed -i "s/\[www\]/[restyaboard] group=restyaboard/g" /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf
				sed -i "s/user\s*=\s*www-data/user = restyaboard/g" /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf
				sed -i "0,/group\s*=\s*www-data/s//group = restyaboard/g" /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf
			else
				user nginx;
				usermod -a -G restyaboard nginx
				sed -i "s/\[www\]/[restyaboard] group=restyaboard/g" /etc/php-fpm.d/www.conf
				sed -i "s/user\s*=\s*apache/user = restyaboard/g" /etc/php-fpm.d/www.conf
				sed -i "0,/group\s*=\s*apache/s//group = restyaboard/g" /etc/php-fpm.d/www.conf
			fi
			chown -R restyaboard:restyaboard $dir
			chmod -R u=rwX,g=rX,o= $dir
			chown -R restyaboard:restyaboard "$dir/media"
			chmod -R u=rwX,g=rX,o= $dir/media;
			chown -R restyaboard:restyaboard "$dir/client/img"
			chmod -R u=rwX,g=rX,o= $dir/client/img;
			chown -R restyaboard:restyaboard "$dir/tmp/cache"
			chmod -R u=rwX,g=rX,o= $dir/tmp/cache;
			chmod +x $dir/server/php/shell/main.sh
			chown -R restyaboard:restyaboard "$dir/client/apps"
			chmod -R u=rwX,g=rX,o= "$dir/client/apps"
			chmod -R u=rwX,g=rX,o= $dir/client/apps/**/*.json
			if ([ "$OS_REQUIREMENT" = "CentOS" ])
			then
				chcon -R -t httpd_sys_rw_content_t $dir/client/apps/**/*.json
			fi
		}

		update_version()
		{
			set +x
			if ([ "$OS_REQUIREMENT" = "Ubuntu" ] || [ "$OS_REQUIREMENT" = "Debian" ] || [ "$OS_REQUIREMENT" = "LinuxMint" ] || [ "$OS_REQUIREMENT" = "Raspbian" ])
			then
				APACHE_ENABLED=$(service apache2 status | grep 'running' | wc -l)
			else
				APACHE_ENABLED=$(service httpd status | grep 'running' | wc -l)
			fi
			echo -e "A newer version ${RESTYABOARD_VERSION} of Restyaboard is available.\n\nImportant: Please note that upgrading will remove any commercial apps that were free in previous version.\nFor more details about commercial apps, please visit https://restya.com/board/pricing\n\nDo you want to get it now y/n?"
			read -r answer
			set -x
			case "${answer}" in
				[Yy])
				set +x
				if [ ${APACHE_ENABLED} -eq 1 ] 
				then
					echo "Enter your document root (where your Restyaboard to be installed. e.g., /var/www/html/restyaboard):"
					read -r dir
					while [[ -z "$dir" ]]
					do
						read -r -p "Enter your document root (where your Restyaboard to be installed. e.g., /var/www/html/restyaboard):" dir
					done
				else
				    echo "Enter your document root (where your Restyaboard to be installed. e.g., /usr/share/nginx/html/restyaboard):"
					read -r dir
					while [[ -z "$dir" ]]
					do
						read -r -p "Enter your document root (where your Restyaboard to be installed. e.g., /usr/share/nginx/html/restyaboard):" dir
					done
				fi
				set -x
				
				echo "Downloading files..."
				curl -v -L -G -d "app=board&ver=${RESTYABOARD_VERSION}" -o /tmp/restyaboard.zip -k https://restya.com/download.php
				unzip /tmp/restyaboard.zip -d ${DOWNLOAD_DIR}
				
				echo "Updating files..."
				cp -r ${DOWNLOAD_DIR}/. "$dir"
				
				echo "Connecting database to run SQL changes..."
				psql -U postgres -c "\q"
				error_code=$? 
				if [ ${error_code} != 0 ]
				then
					echo "PostgreSQL database connection failed with error code ${error_code} (PostgreSQL database connection failed with error code 32)"
					return 32
				fi
				sleep 1
				
				echo "Changing PostgreSQL database name, user and password..."
				sed -i "s/^.*'R_DB_NAME'.*$/define('R_DB_NAME', '${POSTGRES_DBNAME}');/g" "$dir/server/php/config.inc.php"
				sed -i "s/^.*'R_DB_USER'.*$/define('R_DB_USER', '${POSTGRES_DBUSER}');/g" "$dir/server/php/config.inc.php"
				sed -i "s/^.*'R_DB_PASSWORD'.*$/define('R_DB_PASSWORD', '${POSTGRES_DBPASS}');/g" "$dir/server/php/config.inc.php"
				sed -i "s/^.*'R_DB_HOST'.*$/define('R_DB_HOST', '${POSTGRES_DBHOST}');/g" "$dir/server/php/config.inc.php"
				sed -i "s/^.*'R_DB_PORT'.*$/define('R_DB_PORT', '${POSTGRES_DBPORT}');/g" "$dir/server/php/config.inc.php"
				PHP_VERSION=$(php --version | head -n 1 | cut -d " " -f 2 | grep --only-matching --perl-regexp "^\\d\.\\d+")
				version=$(cat ${DOWNLOAD_DIR}/release)
				declare -a upgrade;
				if [[ $version < "v0.4" ]];
				then
					upgrade+=("upgrade-0.3-0.4")
				fi
				if [[ $version < "v0.4.1" ]];
				then
					upgrade+=("upgrade-0.4-0.4.1")
				fi
				if [[ $version < "v0.5" ]];
				then
					upgrade+=("upgrade-0.4.2-0.5")
				fi
				if [[ $version < "v0.5.2" ]];
				then
					upgrade+=("upgrade-0.5.1-0.5.2")
				fi
				if [[ $version < "v0.6" ]];
				then
					upgrade+=("upgrade-0.5.2-0.6")
				fi
				if [[ $version < "v0.6.1" ]];
				then
					upgrade+=("upgrade-0.6-0.6.1")
				fi
				if [[ $version < "v0.6.2" ]];
				then
					upgrade+=("upgrade-0.6.1-0.6.2")
				fi
				if [[ $version < "v0.6.3" ]];
				then
					upgrade+=("upgrade-0.6.2-0.6.3")
				fi
				if [[ $version < "v0.6.4" ]];
				then
					upgrade+=("upgrade-0.6.3-0.6.4")
				fi
				if [[ $version < "v0.6.5" ]];
				then
					upgrade+=("upgrade-0.6.4-0.6.5")
				fi	
				if [[ $version < "v0.6.6" ]];
				then
					upgrade+=("upgrade-0.6.5-0.6.6")
				fi
				if [[ $version < "v0.6.7" ]];
				then
					set +x
					echo "Before updating make sure to remove duplicate username's and emails used by more than one user, otherwise unique indexing for users will be thrown an error But all other queries will be executed without any issue."
					read -r -s -p $'Press [Enter] key to continue...'
					upgrade+=("upgrade-0.6.6-0.6.7")
				fi
				if [[ $version < "v0.6.8" ]];
				then
					upgrade+=("upgrade-0.6.7-0.6.8")
				fi		 
				if [[ $version < "v0.6.9" ]];
				then
					upgrade+=("upgrade-0.6.8-0.6.9")
				fi	
				if [[ $version < "v1.7" ]];
				then
					upgrade+=("upgrade-0.6.9-1.7")
				fi
				# use for loop to read all values and indexes
				for i in "${upgrade[@]}"
				do
					if [ "$(type -t ${i})" = function ];
					then
						eval ${i}
					fi
					if [ -f "$dir/sql/${i}.sql" ];
					then
						echo "Updating SQL..."
						psql -d ${POSTGRES_DBNAME} -f "$dir/sql/${i}.sql" -U ${POSTGRES_DBUSER}
						error_code=$?
						if [ ${error_code} != 0 ]
						then
							echo "PostgreSQL updation of SQL failed with error code ${error_code} (PostgreSQL updation of SQL failed with error code 33)"
							return 33
						fi
					fi
				done
				/bin/echo "$RESTYABOARD_VERSION" > ${DOWNLOAD_DIR}/release

				if ([ "$OS_REQUIREMENT" = "Ubuntu" ] || [ "$OS_REQUIREMENT" = "Debian" ] || [ "$OS_REQUIREMENT" = "LinuxMint" ] || [ "$OS_REQUIREMENT" = "Raspbian" ])
				then
				    if [ ${APACHE_ENABLED} -eq 1 ]
				    then
					    service apache2 restart
    			    else
                        service nginx restart
				    fi
					service php${PHP_VERSION}-fpm restart
				else
					if [ -f "/bin/systemctl" ]; then
						echo "Starting services with systemd..."
						if [ ${APACHE_ENABLED} -eq 1 ]
				 		then
                            systemctl restart httpd.service
						else
							systemctl restart nginx
						fi
						systemctl restart php-fpm
					else
						echo "Starting services..."
						/etc/init.d/php-fpm restart
						if [ ${APACHE_ENABLED} -eq 1 ]
				 		then
                            /etc/init.d/httpd restart
						else
							/etc/init.d/nginx restart							
						fi
					fi
				fi

			esac
		}
		
		if [ -f "$DOWNLOAD_DIR/release" ];
		then
			version=$(cat ${DOWNLOAD_DIR}/release)
			if [[ $version < $RESTYABOARD_VERSION ]];
			then
				update_version
				exit;
			else
				echo "No new version available"
				exit;
			fi
		else
			set +x
			echo "Is Restyaboard already installed and configured/working y/n?"
			read -r answer
			set -x
			case "${answer}" in
				[Yy])
				update_version
				exit;
			esac
		fi
		set +x
		echo "Setup script will install version ${RESTYABOARD_VERSION} and create database ${POSTGRES_DBNAME} with user ${POSTGRES_DBUSER} and password ${POSTGRES_DBPASS}. To continue enter \"y\" or to quit the process and edit the version and database details enter \"n\" (y/n)?"
		read -r answer
		set -x
		case "${answer}" in
			[Yy])
			if ([ "$OS_REQUIREMENT" = "Debian" ])
			then
				sed -i -e 's/deb cdrom/#deb cdrom/g' /etc/apt/sources.list
				sh -c 'echo "deb http://ftp.de.debian.org/debian jessie main" > /etc/apt/sources.list.d/debjessie.list'
				apt install apt-transport-https lsb-release ca-certificates -y
				wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
				echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list
			fi
			if ([ "$OS_REQUIREMENT" = "Ubuntu" ] || [ "$OS_REQUIREMENT" = "Debian" ] || [ "$OS_REQUIREMENT" = "LinuxMint" ] || [ "$OS_REQUIREMENT" = "Raspbian" ])
				then
				apt install debian-keyring debian-archive-keyring -y
				apt update -y
				apt upgrade -y
				apt install python-software-properties -y
				apt install software-properties-common -y
				if ! hash php 2>&-; then
					set +x
					echo "To install latest version of PHP, script will add 'ppa:ondrej/php' repository in sources.list.d directory. Do you want to continue (y/n)?"
					read -r answer
					set -x
					case "${answer}" in
						[Yy])
						add-apt-repository ppa:ondrej/php
					esac
					apt update -y
					apt install libjpeg8 -y --allow-unauthenticated
				fi
			fi
			install_nginx
			
			echo "Checking PHP..."
			install_php

			echo "Setting up timezone..."
			set_timezone
			
			echo "Checking PostgreSQL..."
			install_postgresql

			install_geoip
			
			echo "Downloading Restyaboard script..."
			if ([ "$pkg_name" = "apt-get" ])
			then
				apt install -y curl
			fi
			mkdir ${DOWNLOAD_DIR}
			curl -v -L -G -d "app=board&ver=${RESTYABOARD_VERSION}" -o /tmp/restyaboard.zip -k https://restya.com/download.php
			unzip /tmp/restyaboard.zip -d ${DOWNLOAD_DIR}
			rm /tmp/restyaboard.zip

			configure_restyaboard
			
			
			echo "Copying Restyaboard script to root directory..."
			cp -r ${DOWNLOAD_DIR}/* "$dir"
			
			install_postfix
			
			echo "Changing permission..."
			useradd restyaboard
			usermod --password 'hjVl2!rGd' restyaboard
			if ([ "$OS_REQUIREMENT" = "Ubuntu" ] || [ "$OS_REQUIREMENT" = "Debian" ] || [ "$OS_REQUIREMENT" = "LinuxMint" ] || [ "$OS_REQUIREMENT" = "Raspbian" ])
			then
				user www-data;
				usermod -a -G restyaboard www-data
				sed -i "s/\[www\]/[restyaboard] group=restyaboard/g" /etc/php/7.4/fpm/pool.d/www.conf
				sed -i "s/user\s*=\s*www-data/user = restyaboard/g" /etc/php/7.4/fpm/pool.d/www.conf
				sed -i "0,/group\s*=\s*www-data/s//group = restyaboard/g" /etc/php/7.4/fpm/pool.d/www.conf
			else
				user nginx;
				usermod -a -G restyaboard nginx
				sed -i "s/\[www\]/[restyaboard] group=restyaboard/g" /etc/php-fpm.d/www.conf
				sed -i "s/user\s*=\s*apache/user = restyaboard/g" /etc/php-fpm.d/www.conf
				sed -i "0,/group\s*=\s*apache/s//group = restyaboard/g" /etc/php-fpm.d/www.conf
			fi
			chown -R restyaboard:restyaboard $dir
			chmod -R u=rwX,g=rX,o= $dir
			chown -R restyaboard:restyaboard "$dir/media"
			chmod -R u=rwX,g=rX,o= $dir/media;
			chown -R restyaboard:restyaboard "$dir/client/img"
			chmod -R u=rwX,g=rX,o= $dir/client/img;
			chown -R restyaboard:restyaboard "$dir/tmp/cache"
			chmod -R u=rwX,g=rX,o= $dir/tmp/cache;
			chmod +x $dir/server/php/shell/main.sh
			change_permission

			psql_connect
			
			echo "Changing PostgreSQL database name, user and password..."
			sed -i "s/^.*'R_DB_NAME'.*$/define('R_DB_NAME', '${POSTGRES_DBNAME}');/g" "$dir/server/php/config.inc.php"
			sed -i "s/^.*'R_DB_USER'.*$/define('R_DB_USER', '${POSTGRES_DBUSER}');/g" "$dir/server/php/config.inc.php"
			sed -i "s/^.*'R_DB_PASSWORD'.*$/define('R_DB_PASSWORD', '${POSTGRES_DBPASS}');/g" "$dir/server/php/config.inc.php"
			sed -i "s/^.*'R_DB_HOST'.*$/define('R_DB_HOST', '${POSTGRES_DBHOST}');/g" "$dir/server/php/config.inc.php"
			sed -i "s/^.*'R_DB_PORT'.*$/define('R_DB_PORT', '${POSTGRES_DBPORT}');/g" "$dir/server/php/config.inc.php"
			
			echo "Setting up cron for every 5 minutes.."
			if ([ "$OS_REQUIREMENT" = "Ubuntu" ] || [ "$OS_REQUIREMENT" = "Debian" ] || [ "$OS_REQUIREMENT" = "LinuxMint" ] || [ "$OS_REQUIREMENT" = "Raspbian" ])
			then
				echo "*/5 * * * * $dir/server/php/shell/main.sh > /dev/null 2> /dev/null" >> /var/spool/cron/crontabs/root
			else
				echo "*/5 * * * * $dir/server/php/shell/main.sh > /dev/null 2> /dev/null" >> /var/spool/cron/root
			fi
			php_fpm_reset

			set +x
			echo "Do you want to install Restyaboard apps (y/n)?"
			read -r answer
			set -x
			case "${answer}" in
				[Yy])
				if ! hash jq 2>&-;
				then
					echo "Installing jq..."
					install_jq
				fi
				mkdir "$dir/client/apps"
				chown -R restyaboard:restyaboard "$dir/client/apps"
				chmod -R u=rwX,g=rX,o= "$dir/client/apps"
				curl -v -L -G -o /tmp/apps.json https://raw.githubusercontent.com/RestyaPlatform/board-apps/master/apps.json
				chown -R restyaboard:restyaboard "/tmp/apps.json"
				for fid in `jq -r '.[] | .id + "-v" + .version + "#" + .price' /tmp/apps.json`
				do
					app_name=$(echo ${fid} | cut -d"#" -f1)
					app_price=$(echo ${fid} | cut -d"#" -f2)
					if ([ "$app_price" = "Free" ])
					then
						curl -v -L -G -o /tmp/$app_name.zip https://github.com/RestyaPlatform/board-apps/releases/download/v1/$app_name.zip
						unzip /tmp/$app_name.zip -d "$dir/client/apps"
					fi
				done
				chown -R restyaboard:restyaboard "$dir/client/apps"
				chmod -R u=rwX,g=rX,o= "$dir/client/apps"
				chmod -R u=rwX,g=rX,o= $dir/client/apps/**/*.json
				if ([ "$OS_REQUIREMENT" = "CentOS" ])
				then
					chcon -R -t httpd_sys_rw_content_t $dir/client/apps/**/*.json
				fi
			esac
			if ([ "$OS_REQUIREMENT" = "Ubuntu" ] || [ "$OS_REQUIREMENT" = "Debian" ] || [ "$OS_REQUIREMENT" = "LinuxMint" ] || [ "$OS_REQUIREMENT" = "Raspbian" ])
			then
				service nginx restart
				service php7.4-fpm restart
			else
				if [ -f "/bin/systemctl" ]; then
					echo "Starting services with systemd..."
					systemctl restart nginx
					systemctl restart php-fpm
				else
					echo "Starting services..."
					/etc/init.d/php-fpm restart
					/etc/init.d/nginx restart
				fi
			fi
			set_db_connection
		esac
		/bin/echo "$RESTYABOARD_VERSION" > ${DOWNLOAD_DIR}/release
		if ([ "$OS_REQUIREMENT" = "Ubuntu" ] || [ "$OS_REQUIREMENT" = "Debian" ] || [ "$OS_REQUIREMENT" = "LinuxMint" ] || [ "$OS_REQUIREMENT" = "Raspbian" ])
		then
			if [ ${APACHE_ENABLED} -eq 0 ]; then
				ssl_connectivity
			fi
		else
			if [ ${APACHE_ENABLED} -eq 0 ]; then
				ssl_connectivity
			fi
		fi
		if ([ "$OS_REQUIREMENT" = "CentOS" ] && [ "$OS_VERSION" = "8" ])
        then
			semanage permissive -a httpd_t
		fi
		set +x
		echo "Checking Hosting..."
		response=$(curl -H Metadata:true http://169.254.169.254/metadata/instance?api-version=2017-04-02 --write-out %{http_code} --connect-timeout 10 --max-time 10 --silent --output /dev/null)
		
		if [ -f /etc/ImageMagick-6/policy.xml ]; then
     		sed -i -e 's/<policy domain="coder" rights="none" pattern="PDF" \/>/<policy domain="coder" rights="read" pattern="PDF" \/>/g' /etc/ImageMagick-6/policy.xml
		fi

		if [ -f /etc/ImageMagick/policy.xml ]; then
			sed -i -e 's/<policy domain="coder" rights="none" pattern="PDF" \/>/<policy domain="coder" rights="read" pattern="PDF" \/>/g' /etc/ImageMagick/policy.xml
		fi

		if [ ${response} -eq 200 ];then
			echo "Note: PHP Mailer will not work in Azure. Kindly use external SMTP mail server."
		fi
		set +x
		curl -v -L -G -d "app=board&os=${os}&version=${version}" -k "https://restya.com/success_installation.php"
		echo "Restyaboard URL : $webdir"

		echo "Login with username admin and password restya"
		exit 1
	}
	main
	error=$?
	os=$(lsb_release -i -s)
	curl -v -L -G -d "app=board&os=${os}&error=${error}" -k "https://restya.com/error_installation.php"
	echo "If you're finding it difficult to install Restyaboard from your end, we do also offer free installation support that you may consider https://restya.com/contact?category=free-installation"
	exit 1
} 2>&1 | tee -a restyaboard_install.log
