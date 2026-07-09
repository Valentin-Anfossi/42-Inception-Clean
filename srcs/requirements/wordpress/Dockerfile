FROM debian:bookworm

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    wget \
    curl \
    php-fpm \
    php-mysql \
    mariadb-client

COPY ./tools/wordpress_run.sh /usr/local/bin/wordpress_run.sh
COPY ./config/wp-config.php /tmp/wp-config.php

RUN chmod +x /usr/local/bin/wordpress_run.sh

#Modify php to listen 9000 and not clear env variables
RUN sed -i 's|listen = /run/php/php8.2-fpm.sock|listen = 9000|' /etc/php/8.2/fpm/pool.d/www.conf
RUN sed -i 's|;clear_env = no|clear_env = no|' /etc/php/8.2/fpm/pool.d/www.conf

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

ENTRYPOINT ["/usr/local/bin/wordpress_run.sh"]

CMD ["php-fpm8.2", "--nodaemonize"]