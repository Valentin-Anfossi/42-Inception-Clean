FROM debian:bookworm

RUN apt-get update -y

RUN apt-get install -y \
    php \
    php-fpm \
    php-mysqli \
    nginx

RUN mkdir -p /var/www/adminer

COPY ./conf/nginx.conf /etc/nginx/conf.d

COPY ./ressources/index.php /var/www/adminer/
COPY ./tools/adminer_run.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/adminer_run.sh

RUN sed -i 's|listen = /run/php/php8.2-fpm.sock|listen = 127.0.0.1:9000|' /etc/php/8.2/fpm/pool.d/www.conf
RUN sed -i 's|;clear_env = no|clear_env = no|' /etc/php/8.2/fpm/pool.d/www.conf

ENTRYPOINT ["/usr/local/bin/adminer_run.sh"]

EXPOSE 8080