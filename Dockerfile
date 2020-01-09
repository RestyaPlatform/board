FROM php:7-cli as builder

RUN apt-get update
RUN apt-get install -y gnupg2
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y nodejs

WORKDIR /app

COPY package.json .

RUN npm install
RUN npm install -g grunt-cli

COPY .sandstorm/ .sandstorm/
COPY .tx/ .tx/
COPY docs/ docs/
COPY Jelastic/ Jelastic/
COPY build/ build/
COPY client/ client/
COPY restyaboard.conf .
COPY sql/ sql/
COPY api_explorer/ api_explorer/
COPY server/ server/
COPY media/ media/
COPY .codeclimate.yml .
COPY .htaccess .
COPY diagnose.php .
COPY ejabberd.yml .
COPY restyaboard.sh .
COPY restyaboard-ssl.conf .
COPY restyaboard_uninstall.sh .
COPY Gruntfile.js .

RUN npm run docker:prebuild

# Result image
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
    postfix \
    postgresql-client \
    unzip \
    wget

#RUN chmod 600 /etc/postfix/sasl_passwords

# Necessary steps for php7.2
RUN apt install -y apt-transport-https lsb-release ca-certificates && \
    wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
    sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list' && \
    apt update

RUN apt-get install -y \
    php7.2 \
    php7.2-cli \
    php7.2-common \
    php7.2-curl \
    php7.2-fpm \
    php7.2-imagick \
    php7.2-imap \
    php7.2-ldap \
    php7.2-mbstring \
    php7.2-pgsql \
    php7.2-xml

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
COPY --from=builder /app/restyaboard-docker.zip /tmp/restyaboard.zip

RUN unzip /tmp/restyaboard.zip -d ${ROOT_DIR} && \
    rm /tmp/restyaboard.zip && \
    chown -R www-data:www-data ${ROOT_DIR}
RUN mv  ${ROOT_DIR}/api_explorer/ ${ROOT_DIR}/client/api_explorer/

# install apps
ADD docker-scripts/install_apps.sh /tmp/
RUN chmod +x /tmp/install_apps.sh
RUN . /tmp/install_apps.sh && \
    chown -R www-data:www-data ${ROOT_DIR}

# configure app
WORKDIR ${ROOT_DIR}
RUN rm /etc/nginx/sites-enabled/default && \
    cp restyaboard.conf ${CONF_FILE} && \
    sed -i "s/server_name.*$/server_name \"localhost\";/" ${CONF_FILE} && \
	sed -i "s|listen 80.*$|listen 80;|" ${CONF_FILE} && \
    sed -i "s|root.*html|root ${ROOT_DIR}|" ${CONF_FILE}

# cleanup
RUN apt-get autoremove -y --purge && \
    apt-get clean

# Default values. Can be changed during container start.
ENV POSTGRES_HOST=postgres \
    POSTGRES_PORT=5432 \
    POSTGRES_USER=admin \
    POSTGRES_PASSWORD=admin \
    POSTGRES_DB=restyaboard

# entrypoint
COPY docker-scripts/docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["start"]
