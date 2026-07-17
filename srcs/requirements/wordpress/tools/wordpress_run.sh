#!/bin/bash
set -e

#Get secrets from the very secret secretive secret files of secrets (oooo)
load_secrets() {
    local secrets_dir="/run/secrets"
    [ -d "$secrets_dir" ] || return 0

    for secret_file in "$secrets_dir"/*; do
        [ -f "$secret_file" ] || continue
        set -a
        source "$secret_file"
        set +a
    done
}

load_secrets

# We sleep for mariadb to finish
sleep 10

if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Installing WordPress..."
    rm -rf /var/www/html/*
    wget https://wordpress.org/wordpress-7.0.tar.gz -P /tmp
    tar -xzf /tmp/wordpress-7.0.tar.gz --directory /tmp
    cp -r /tmp/wordpress/. /var/www/html/
    cp /tmp/wp-config.php /var/www/html/wp-config.php
    chown -R root:root /var/www/html
    rm -rf /tmp/wordpress /tmp/wordpress-7.0.tar.gz
    wp core install \
        --allow-root \
        --path=/var/www/html \
        --url="${USERNAME}.42.fr" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --skip-email
    echo "WordPress installed."
fi

# This exec replaces the entrypoint process with the cmd passed in the dockerfile
exec "$@"