#!/bin/bash
set -e

mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

#Get secrets from the very secret secretive secret files of secrets (oooo)
for f in /run/secrets/*; do
  [ -f "$f" ] || continue
  set -a
  . "$f"
  set +a
done

#Checks if database has already been initialized
if [ ! -f /var/lib/mysql/.init_flag ]; then
    echo "Initializing database..."

    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
    #You could use mariadb here as well but you wouldn't see error logs in console
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