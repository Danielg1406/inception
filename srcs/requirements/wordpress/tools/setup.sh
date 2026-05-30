#!/bin/bash

chown -R www-data:www-data /var/www/inception/

wp_cli() {
  php -d memory_limit=512M /usr/local/bin/wp --allow-root --path="/var/www/inception/" "$@"
}

if [ ! -f "/var/www/inception/wp-config.php" ]; then
  mv /tmp/wp-config.php /var/www/inception/
fi

sleep 10

wp_cli core download || true

if ! wp_cli core is-installed;
then
  wp_cli core install \
      --url=$WP_URL \
      --title=$WP_TITLE \
      --admin_user=$WP_ADMIN_USER \
      --admin_password=$WP_ADMIN_PASSWORD \
      --admin_email=$WP_ADMIN_EMAIL
fi;

if ! wp_cli user get $WP_USER;
then
  wp_cli user create \
      $WP_USER \
      $WP_EMAIL \
      --user_pass=$WP_PASSWORD \
      --role=$WP_ROLE
fi;

wp_cli theme install raft --activate 

exec $@