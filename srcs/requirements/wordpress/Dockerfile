FROM  php:7.4-fpm

ARG	PHPPATH=/usr/local/etc

RUN	apt-get update && apt-get install --no-install-recommends -y \
      ca-certificates \
      wget \
      tar \
      default-libmysqlclient-dev && \
      rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install mysqli pdo pdo_mysql

COPY	conf/www.conf ${PHPPATH}/php-fpm.d/

RUN   if [ -f ${PHPPATH}/php.ini ]; then \
        sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' ${PHPPATH}/php.ini; \
        fi && \
        sed -i "s/listen = .*\\.sock/listen = 9000/g" ${PHPPATH}/php-fpm.d/www.conf && \
        sed -i 's/;listen.mode = 0660/listen.mode = 0660/g' ${PHPPATH}/php-fpm.d/www.conf && \
        sed -i 's/;daemonize = yes/daemonize = no/g' ${PHPPATH}/php-fpm.d/www.conf

RUN wget --no-check-certificate https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

RUN	mkdir -p /run/php/ && \
      mkdir -p /var/run/php/ && \
      mkdir -p /var/www/inception/

RUN	chown -R www-data:www-data /var/www/inception/

COPY	conf/wp-config.php /tmp/
COPY	tools/setup.sh /bin/

RUN	chmod +x /bin/setup.sh

EXPOSE      9000

CMD   ["setup.sh", "php-fpm", "--nodaemonize"]