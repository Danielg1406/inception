#!/bin/bash

set -eu

DB_PASSWORD=$(cat /run/secrets/db_password)
set -a
. /run/secrets/credentials
set +a

export DB_PASSWORD

chown -R www-data:www-data /var/www/inception/

wp_cli() {
  php -d memory_limit=512M /usr/local/bin/wp --allow-root --path="/var/www/inception/" "$@"
}

if [ ! -f "/var/www/inception/wp-config.php" ]; then
  install -o www-data -g www-data -m 644 /tmp/wp-config.php /var/www/inception/wp-config.php
fi

chown -R www-data:www-data /var/www/inception/
chmod 644 /var/www/inception/wp-config.php

sleep 10

wp_cli core download || true

if ! wp_cli core is-installed;
then
  wp_cli core install \
      --url="$WP_URL" \
      --title="$WP_TITLE" \
      --admin_user="$WP_ADMIN_USER" \
      --admin_password="$WP_ADMIN_PASSWORD" \
      --admin_email="$WP_ADMIN_EMAIL"
fi;

if wp_cli user get $WP_ADMIN_USER;
then
  wp_cli user update \
      "$WP_ADMIN_USER" \
      --user_email="$WP_ADMIN_EMAIL" \
      --user_pass="$WP_ADMIN_PASSWORD" \
      --role=administrator
else
  wp_cli user create \
  "$WP_ADMIN_USER" \
  "$WP_ADMIN_EMAIL" \
  --user_pass="$WP_ADMIN_PASSWORD" \
  --role=administrator
fi;

if wp_cli user get "$WP_USER";
then
  wp_cli user update \
      "$WP_USER" \
      --user_email="$WP_EMAIL" \
      --user_pass="$WP_PASSWORD" \
      --role="$WP_ROLE"
else
  wp_cli user create \
      "$WP_USER" \
      "$WP_EMAIL" \
      --user_pass="$WP_PASSWORD" \
      --role="$WP_ROLE"
fi;

wp_cli theme install raft --activate 
chown -R www-data:www-data /var/www/inception/
find /var/www/inception -type d -exec chmod 755 {} \;
find /var/www/inception -type f -exec chmod 644 {} \;

exec $@
