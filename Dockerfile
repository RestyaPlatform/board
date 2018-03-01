FROM debian:stretch

# update & install package
RUN apt-get update && \
    echo "postfix postfix/mailname string localhost" | debconf-set-selections && \
    echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections && \
    TERM=linux DEBIAN_FRONTEND=noninteractive apt-get install -y \
    cron \
    curl \
    imagemagick \
    jq \
    libpq5 \
    nginx \
    php7.0 \
    php7.0-cli \
    php7.0-common \
    php7.0-curl \
    php7.0-fpm \
    php7.0-imagick \
    php7.0-imap \
    php7.0-ldap \
    php7.0-mbstring \
    php7.0-pgsql \
    php7.0-xml \
    postfix \
    postgresql-client \
    unzip

# after initial setup of deps to improve rebuilding speed
ENV ROOT_DIR=/usr/share/nginx/html \
    CONF_FILE=/etc/nginx/conf.d/restyaboard.conf \
    SMTP_DOMAIN=localhost \
    SMTP_USERNAME=root \
    SMTP_PASSWORD=root \
    SMTP_SERVER=localhost \
    SMTP_PORT=465 \
    TZ=Etc/UTC

# deploy app
ADD restyaboard-docker.zip /tmp/restyaboard.zip
RUN unzip /tmp/restyaboard.zip -d ${ROOT_DIR} && \
    rm /tmp/restyaboard.zip

# install apps
ADD docker-scripts/install_apps.sh /tmp/
RUN chmod +x /tmp/install_apps.sh
RUN . /tmp/install_apps.sh

# configure app
WORKDIR ${ROOT_DIR}
RUN rm /etc/nginx/sites-enabled/default && \
    cp restyaboard.conf ${CONF_FILE} && \
    sed -i "s/server_name.*$/server_name \"localhost\";/" ${CONF_FILE} && \
	sed -i "s|listen 80.*$|listen 80;|" ${CONF_FILE} && \
    sed -i "s|root.*html|root ${ROOT_DIR}|" ${CONF_FILE} && \
    chown -cR www-data:www-data . && \
    chmod -R 777 .

# cleanup
RUN apt-get autoremove -y --purge && \
    apt-get clean

# entrypoint
COPY docker-scripts/docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["start"]
