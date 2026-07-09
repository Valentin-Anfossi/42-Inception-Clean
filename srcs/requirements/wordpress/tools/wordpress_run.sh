#!/bin/bash
set -e

#Get secrets from the very secret secretive secret files of secrets (oooo)
for f in /run/secrets/*; do
  [ -f "$f" ] || continue
  set -a
  . "$f"
  set +a
done

sleep 10

if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Installing WordPress..."
    wget https://wordpress.org/wordpress-7.0.tar.gz --progress=bar:force:noscroll -P /tmp
    tar -xzf /tmp/wordpress-7.0.tar.gz --directory /tmp
    cp -r /tmp/wordpress/. /var/www/html/
    cp /tmp/wp-config.php /var/www/html/wp-config.php
    chown -R root:root /var/www/html
    rm -rf /tmp/wordpress /tmp/wordpress-7.0.tar.gz
    wp core install \
        --allow-root \
        --path=/var/www/html \
        --url="${WP_URL}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --skip-email
    echo "WordPress installed."
fi
exec "$@"