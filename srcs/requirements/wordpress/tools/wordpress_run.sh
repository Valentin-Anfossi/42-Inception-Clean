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
    echo "Secrets loaded into env variables"
}

load_secrets

# We sleep for mariadb to finish 
# I do not like it
sleep 5

if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Installing WordPress..."
    rm -rf /var/www/html/*
    wget https://wordpress.org/wordpress-7.0.tar.gz -P /tmp
    tar -xzf /tmp/wordpress-7.0.tar.gz --directory /tmp
    cp -r /tmp/wordpress/. /var/www/html/
    chown -R root:root /var/www/html
    rm -rf /tmp/wordpress /tmp/wordpress-7.0.tar.gz
    #We create the config file with the tool because it's safer and I like it
    wp config create \
        --dbname="$SQL_DATABASE" \
        --dbuser="$SQL_USER" \
        --dbpass="$SQL_PASSWORD" \
        --dbhost="$SQL_HOST" \
        --allow-root --path=/var/www/html
    #redis needs some values, FS_METHOD allows redis to use direct access and write on the filesystem
    wp config set WP_REDIS_HOST "redis" --allow-root --path=/var/www/html
    wp config set WP_REDIS_PORT 6379 --allow-root --path=/var/www/html
    wp config set WP_CACHE true --allow-root --path=/var/www/html
    wp config set FS_METHOD direct --allow-root --path=/var/www/html
    
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

    echo "Installing redis."
    chown -R www-data:www-data /var/www/html/wp-content
    chmod -R 755 /var/www/html/wp-content
    wp plugin install redis-cache --activate --allow-root --path=/var/www/html 
    wp redis enable --allow-root --path=/var/www/html
    echo "Redis installed."
else
    echo "wp-config.php present, skipping wordpress install"
    chown -R www-data:www-data /var/www/html/wp-content
    chmod -R 755 /var/www/html/wp-content
fi

# This exec replaces the entrypoint process with the cmd passed in the dockerfile
exec "$@"