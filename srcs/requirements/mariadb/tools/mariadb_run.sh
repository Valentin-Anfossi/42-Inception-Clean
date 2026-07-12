#!/bin/bash
set -e

mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

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

#Checks if database has already been initialized
if [ ! -f /var/lib/mysql/.init_flag ]; then
    echo "Initializing database..."

    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
    #I use mysqld_safe here instead of mariadbd because mariadbd doesn't have --skip-syslog
    mysqld_safe --datadir=/var/lib/mysql --skip-syslog &

    until mysql -e "SELECT 1;" &> /dev/null; do
        echo "Waiting for database connection..."
        sleep 2
    done

    mysql -e "CREATE DATABASE IF NOT EXISTS ${SQL_DATABASE};"
    
    # Create admin and user accounts with privileges
    mysql -e "CREATE USER IF NOT EXISTS '${SQL_ADMIN}'@'%' IDENTIFIED BY '${SQL_ADMINPASSWORD}';"
    mysql -e "GRANT ALL PRIVILEGES ON *.* TO '${SQL_ADMIN}'@'%' WITH GRANT OPTION;"

    mysql -e "CREATE USER IF NOT EXISTS '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD}';"
    mysql -e "GRANT ALL PRIVILEGES ON ${SQL_DATABASE}.* TO '${SQL_USER}'@'%';"

    mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}'; FLUSH PRIVILEGES;"

    mysqladmin -u root -p"${SQL_ROOT_PASSWORD}" shutdown
    touch /var/lib/mysql/.init_flag
    echo "Database initialized. Restarting MariaDB..."
fi

exec mariadbd --user=mysql --datadir=/var/lib/mysql